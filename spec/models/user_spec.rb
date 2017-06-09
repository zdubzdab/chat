require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(2).on(:create) }

  it { should validate_presence_of(:email) }
  it { should_not allow_value('test@test').for(:email) }
  it { should_not allow_value('test@test.').for(:email) }
  it { should_not allow_value('test_test.com').for(:email) }

  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6).is_at_most(15).on(:create) }
  it { should validate_confirmation_of(:password) }

  describe 'scope all_except current_user' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    it 'excludes answer that belongs_to_current_test' do
      expect(User.all_except(user1)).not_to include(user1)
      expect(User.all_except(user1)).to include(user2)
    end
  end
end
