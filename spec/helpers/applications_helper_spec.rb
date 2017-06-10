require 'rails_helper'

describe ApplicationHelper do
  include ApplicationHelper

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe 'show_link_for_users method' do
    it 'show link if current user presnt' do
      expect(
        show_link_for_users(user, (link_to 'Main page', root_path))
      ).to eq((link_to 'Main page', root_path))
      expect(
        show_link_for_users(nil, (link_to 'Main page', root_path))
      ).to eq()
    end
  end

  describe 'show_link_depend_on_user_role method' do
    it 'show link on desired pages' do
      expect(
        show_link_depend_on_user_role(admin, (link_to 'Admin page', '#'),
                                      true, (link_to 'User page', '#'), false)
      ).to eq()
      expect(
        show_link_depend_on_user_role(
          admin, (link_to 'Admin page', '#'), false,
          (link_to 'User page', '#'), true
        )
      ).to eq((link_to 'Admin page', '#'))
      expect(
        show_link_depend_on_user_role(user, (link_to 'Admin page', '#'),
                                      true, (link_to 'User page', '#'), true)
      ).to eq()
      expect(
        show_link_depend_on_user_role(
          user, (link_to 'Admin page', '#'), false,
          (link_to 'User page', '#'), false
        )
      ).to eq((link_to 'User page', '#'))
    end
  end

  describe 'date_format method' do
    let(:date1) { DateTime.new(2017, 6, 10, 11, 5, 0) }
    let(:date2) { DateTime.new(2016, 6, 1, 6, 5, 0) }

    it 'show date in desired format' do
      expect(time_fomat(date1)).to eq('Saturday, Jun 10, 2017 at 11:05AM')
      expect(time_fomat(date2)).to eq('Wednesday, Jun 01, 2016 at 06:05AM')
    end
  end

  describe 'patch_depend_on_url method' do
    it 'choose desired patch' do
      expect(patch_depend_on_url(true, user)).to eq([:admin, user])
    end

    it 'choose desired patch' do
      expect(patch_depend_on_url(false, user)).to eq(user)
    end
  end
end
