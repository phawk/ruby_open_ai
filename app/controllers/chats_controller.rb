class ChatsController < ApplicationController
  def create
    conversation = Current.user.conversations.find(chat_params[:conversation_id])
    message = conversation.messages.create!(
      role: "user",
      content: chat_params[:content]
    )
    ChatService.new(conversation: conversation, message: message).call

    head :no_content
  end

  private

  def chat_params
    params.permit(:content, :conversation_id).merge(user: Current.user)
  end
end
