require 'rails_helper'

feature 'Authorisation' do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  before do
    visit sessions_new_path
  end

  scenario 'page for guests' do
    expect(page).to have_content('Chat')
    expect(page).to have_content('Log in')
    expect(page).not_to have_content('Log out')
    expect(page).not_to have_content('Messages')
  end

  context 'admin' do
    scenario 'success' do
      fill_in 'Email',                  with: admin.email
      fill_in 'Password',               with: admin.password
      click_on 'Submit'

      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_content('User')
      expect(page).to have_link('Log out')
      expect(current_path).to eq('/admin/users')
    end

    context 'invalid' do
      scenario 'email' do
        fill_in 'Email',                  with: ''
        fill_in 'Password',               with: admin.password
        click_on 'Submit'

        expect(current_path).to eq('/sessions/create')
      end

      scenario 'password' do
        fill_in 'Email',                  with: user.email
        fill_in 'Password',               with: ''
        click_on 'Submit'

        expect(current_path).to eq('/sessions/create')
      end
    end

    scenario 'page' do
      log_in admin
      visit '/sessions/new'

      expect(page).to have_content('Chat')
      expect(page).to have_content('Log in')
    end

    it 'should have the right links on the page' do
      log_in admin
      visit '/sessions/new'

      click_link 'Main page'
      expect(page).to have_link('Create user')
      expect(current_path).to eq('/admin/users')

      visit '/sessions/new'
      click_on 'Log out'
      expect(page).to have_content('Signed out successfully.')
      expect(page).to have_content('Log in')
      expect(current_path).to eq('/sessions/new')
    end
  end

  context 'user' do
    scenario 'success' do
      fill_in 'Email',                  with: user.email
      fill_in 'Password',               with: user.password
      click_on 'Submit'

      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_content('Your email:')
      expect(page).to have_link('Log out')
      expect(current_path).to eq('/')
    end

    it 'should have the right links on the page' do
      log_in user
      visit '/sessions/new'

      click_link 'Main page'
      expect(page).to have_content('Your email:')
      expect(current_path).to eq('/')

      visit '/sessions/new'
      click_on 'Log out'
      expect(page).to have_content('Signed out successfully.')
      expect(page).to have_content('Log in')
      expect(current_path).to eq('/sessions/new')
    end
  end
end
