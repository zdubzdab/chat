class MailboxController < ApplicationController
  def inbox
    @inbox = mailbox.inbox
  end

  def sent
    @sent = mailbox.sentbox
  end
end
