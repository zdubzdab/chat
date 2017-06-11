require 'rails_helper'
require 'rake'
Rails.application.load_tasks

feature 'User manage messagess' do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  scenario 'page' do
    log_in user1
    visit root_path

    expect(page).to have_content('Main page')
    expect(page).to have_content('Your name: user1')
    expect(page).to have_content('Your email: user1@gmail.com')
  end

  it 'should have the right links on the page' do
    log_in user1
    visit root_path

    click_link 'Edit profile'
    expect(page).to have_button('Submit')
    expect(current_path).to eq(edit_user_path(user1))

    visit root_path
    click_on 'Write message'
    expect(page).to have_content('Subject')
    expect(page).to have_content('Message')
    expect(page).to have_content('Your name: ')
    expect(page).to have_content('Your email: ')
    expect(current_path).to eq('/conversations/new')

    log_in user2
    send_message(user1, 'Subject333', 'Message333')
    log_in user1
    click_on 'Inbox'
    expect(page).to have_content('Subject333')
    expect(page).to have_content('Message333')

    log_in user2
    click_on 'Sent'
    expect(page).to have_content('Subject333')
    expect(page).to have_content('Message333')

    click_on 'Log out'
    expect(page).to have_content('Signed out successfully.')
    expect(page).to have_content('Log in')
    expect(current_path).to eq('/sessions/new')
  end

  context 'sending message' do
    scenario 'by guest' do
      visit root_path

      expect(page).to have_content('You dont have permission to do this.')
      expect(current_path).to eq('/sessions/new')
    end

    context 'by user' do
      before do
        log_in user2
        log_in user1
        visit new_conversation_path
      end

      context 'success' do
        scenario 'sending' do
          select "#{user2.name}",           from: 'conversation[recipients][]'
          fill_in 'Subject',                with: 'Subject333'
          fill_in 'conversation[body]',     with: 'Message333'
          click_on 'Send Message'

          expect(page).to have_content('Your message was successfully sent!')
          expect(page).to have_content('Subject:Subject333')
          expect(page).to have_content('Text:Message333')
        end

        scenario 'other user should receive the message' do
          send_message(user2, 'Subject333', 'Message333')

          log_in user2
          visit root_path

          expect(page).to have_content("#{user1.name}")
          expect(page).to have_content('Subject:Subject333')
          expect(page).to have_content('Text:Message333')
        end
      end
    end
  end

  context 'list with sent messages' do
    before do
      log_in user2
      log_in user1
      send_message(user2, 'Subject333', 'Message333')
      click_on 'Sent'
    end

    scenario 'user should see sent messages' do
      expect(page).to have_content("#{user1.name}")
      expect(page).to have_content('Subject:Subject333')
      expect(page).to have_content('Text:Message333')
    end

    scenario 'user send second message after first' do
      click_on 'View details'
      fill_in 'message[body]',     with: 'Message999'
      click_on 'Reply'

      expect(page).to have_content('Your message was successfully sent!')
      expect(page).to have_content('Subject:Subject333')
      expect(page).to have_content('Text:Message999')
    end
  end

  scenario 'if user read message number of unread mes should decrease on 1' do
    log_in user2
    log_in user1
    send_message(user2, 'Subject333', 'Message333')
    log_in user2
    expect(find('#unread_messages')).to have_content('1')

    click_on 'View details'

    expect(find('#unread_messages')).to have_content('0')
  end

  context 'user reply on receive message' do
    before do
      log_in user2
      log_in user1
      send_message(user2, 'Subject333', 'Message333')
      log_in user2
      click_on 'View details'
    end

    scenario 'user reply' do
      expect(page).to have_content("#{user1.name}")
      expect(page).to have_content('Subject333')
      expect(page).to have_content('Message333')
      fill_in 'message[body]',     with: 'Message999'
      click_on 'Reply'

      expect(page).to have_content('Your message was successfully sent!')
      expect(page).to have_content('Subject:Subject333')
      expect(page).to have_content('Text:Message999')
    end

    scenario 'other user should receive replication' do
      fill_in 'message[body]',     with: 'Message000'
      click_on 'Reply'

      log_in user1
      expect(find('#unread_messages')).to have_content('1')
      expect(page).to have_content('Subject:Subject333')
      expect(page).to have_content('Text:Message000')
    end
  end

  scenario 'test button that check if there is new message', js: true do
    log_in user2
    visit root_path
    expect(find('#unread_messages')).to have_content('0')

    Rake::Task['send_new_message'].invoke
    click_on 'Check for new messages'

    expect(find('#unread_messages')).to have_content('1')
  end
end
