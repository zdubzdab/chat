require 'rails_helper'

feature 'User edit profile' do
  let(:user) { FactoryGirl.create(:user) }

  context 'edit' do
    scenario 'by guest' do
      visit edit_user_path(user)

      expect(page).to have_content('You dont have permission to do this.')
      expect(current_path).to eq('/sessions/new')
    end

    context 'by user' do
      before do
        log_in user
        visit edit_user_path(user)
      end

      scenario 'success' do
        fill_in 'Name',                   with: 'user33'
        fill_in 'Email',                  with: 'user33@gmail.com'
        fill_in 'Password',               with: 'password'
        fill_in 'Password confirmation',  with: 'password'
        click_on 'Submit'

        expect(page).to have_content('Profile was successfully updated.')
        expect(page).to have_content('Your name: user33')
        expect(page).to have_content('Your email: user33@gmail.com')
        expect(current_path).to eq('/')
      end

      scenario 'back to main page' do
        click_link 'Main page'
        expect(page).to have_link('Edit profile')
        expect(current_path).to eq('/')
      end

      scenario 'back' do
        click_link 'Back'
        expect(page).to have_link('Edit profile')
        expect(current_path).to eq('/')
      end
    end
  end
end
