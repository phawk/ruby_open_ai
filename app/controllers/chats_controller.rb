class ChatsController < ApplicationController
  def create
    service = ChatService.new(message: chat_params[:content])
    response = service.call
    render turbo_stream: turbo_stream.append(
        "messages",
        partial: "messages/message",
        locals: { response: response }
      )
  end

  private

  def chat_params
    params.permit(:content).merge(user: Current.user)
  end
end
