class ConversationsController < ApplicationController
  def new
  end

  def create
    recipients = User.where(id: conversation_params[:recipients])
    conversation = current_user.send_message(recipients,
                    conversation_params[:body], conversation_params[:subject])
                               .conversation
    redirect_to conversation_path(conversation), notice: 'Your message was'\
      ' successfully sent!'
  end

  def show
    @receipts = conversation.receipts_for(current_user)
                            .order('created_at ASC')
    conversation.mark_as_read(current_user)
  end

  def reply
    current_user.reply_to_conversation(conversation, message_params[:body])
    redirect_to conversation_path(conversation), notice: 'Your message was'\
      ' successfully sent!'
  end

  private

  def conversation_params
    params.require(:conversation).permit(:subject, :body, recipients: [])
  end

  def message_params
    params.require(:message).permit(:body, :subject)
  end
end
