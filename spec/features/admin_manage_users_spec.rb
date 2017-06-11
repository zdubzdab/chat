require 'rails_helper'

feature 'Admin manage users' do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  scenario 'page' do
    log_in admin
    visit admin_users_path

    expect(page).to have_content('Users')
    expect(page).to have_content('user')
    expect(page).to have_content('user1@gmail.com')
    expect(page).to have_content('Created at')
  end

  it 'should have the right links on the page' do
    log_in admin
    visit admin_users_path

    click_link 'Create user'
    expect(page).to have_button('Submit')
    expect(current_path).to eq(new_admin_user_path)

    visit admin_users_path
    click_on 'Edit'
    expect(page).to have_content('Edit user')
    expect(current_path).to eq(edit_admin_user_path(admin))
  end

  context 'creation' do
    scenario 'by guest' do
      visit admin_users_path

      expect(page).to have_content('You dont have permission to do this.')
      expect(current_path).to eq('/sessions/new')
    end

    scenario 'by user' do
      log_in user
      visit admin_users_path

      expect(page).to have_content('You dont have permission to do this.')
      expect(current_path).to eq('/sessions/new')
    end

    context 'by admin' do
      before do
        log_in admin
        visit new_admin_user_path
      end

      scenario 'success' do
        fill_in 'Name',                  with: 'user_name'
        fill_in 'Email',                 with: 'example@gmail.com'
        fill_in 'Password',              with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_on 'Submit'

        expect(page).to have_content('User was successfully created.')
        expect(page).to have_content('user_name')
        expect(page).to have_content('example@gmail.com')
        expect(current_path).to eq('/admin/users')
      end

      context 'invalid' do
        scenario 'blank name' do
          fill_in 'Name',                   with: ''
          fill_in 'Email',                  with: 'user@example.com'
          fill_in 'Password',               with: 'password'
          fill_in 'Password confirmation',  with: 'password'
          click_on 'Submit'

          expect(page).to have_content("Name can't be blankName "\
            'is too short (minimum is 2 characters)')
        end

        scenario 'blank email' do
          fill_in 'Name',                   with: 'user_name'
          fill_in 'Email',                  with: ''
          fill_in 'Password',               with: 'password'
          fill_in 'Password confirmation',  with: 'password'
          click_on 'Submit'

          expect(page).to have_content("Email can't be blankEmail "\
            'bad format')
        end

        scenario 'invalid email' do
          fill_in 'Name',                   with: 'user_name'
          fill_in 'Email',                  with: 'user.gmail'
          fill_in 'Password',               with: 'password'
          fill_in 'Password confirmation',  with: 'password'
          click_on 'Submit'

          expect(page).to have_content('Email bad format')
        end

        scenario 'blank password' do
          fill_in 'Name',                   with: 'user_name'
          fill_in 'Email',                  with: 'user@example.com'
          fill_in 'Password',               with: ''
          fill_in 'Password confirmation',  with: 'password'
          click_on 'Submit'

          expect(page).to have_content("Password can't be blank"\
            'Password is too short (minimum is 6 characters)')
        end

        scenario 'blank password confirmation' do
          fill_in 'Name',                   with: 'user_name'
          fill_in 'Email',                  with: 'user@example.com'
          fill_in 'Password',               with: 'password'
          fill_in 'Password confirmation',  with: ''
          click_on 'Submit'

          expect(page).to have_content("Password confirmation doesn't match"\
          ' Password')
        end

        scenario "Password confirmation doesn't match Password" do
          fill_in 'Name',                   with: 'user_name'
          fill_in 'Email',                  with: 'user@gmail.com'
          fill_in 'Password',               with: 'password'
          fill_in 'Password confirmation',  with: 'passwor'
          click_on 'Submit'

          expect(page).to have_content("Password confirmation doesn't match"\
            ' Password')
        end
      end

      scenario 'back' do
        click_link 'Back'
        expect(page).to have_content('Users')
        expect(current_path).to eq(admin_users_path)
      end
    end
  end

  context 'edit' do
    before do
      log_in admin
      visit edit_admin_user_path(admin)
    end

    scenario 'success' do
      fill_in 'Name',                   with: 'admin33'
      fill_in 'Email',                  with: 'admin33@gmail.com'
      fill_in 'Password',               with: 'password'
      fill_in 'Password confirmation',  with: 'password'
      click_on 'Submit'

      expect(page).to have_content('User was successfully updated.')
      expect(page).to have_content('admin33')
      expect(page).to have_content('admin33@gmail.com')
      expect(current_path).to eq('/admin/users')
    end

    scenario 'back to main page' do
      click_link 'Main page'
      expect(page).to have_content('Users')
      expect(current_path).to eq(admin_users_path)
    end

    scenario 'back' do
      click_link 'Back'
      expect(page).to have_content('Users')
      expect(current_path).to eq(admin_users_path)
    end
  end

  scenario 'delete' do
    log_in user
    log_in admin
    visit admin_users_path

    click_link('Destroy', match: :first)
    expect(page).to have_content('User was successfully deleted.')
    expect(current_path).to eq(admin_users_path)
  end
end
