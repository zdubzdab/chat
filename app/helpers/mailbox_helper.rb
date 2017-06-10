module MailboxHelper
  def unread_messages_count(user)
    user.unread_inbox_count
  end
end
