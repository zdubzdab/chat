module MailboxHelper
  def unread_messages_count
    current_user.unread_inbox_count
  end
end
