require 'rails_helper'

describe MailboxHelper do
  include MailboxHelper

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe 'unread_messages_count method' do
    it 'correctly count unread messages' do
      expect(unread_messages_count(user)).to eq(0)

      admin.send_message(user, 'Text', 'subject')

      expect(unread_messages_count(user)).to eq(1)
    end
  end
end
