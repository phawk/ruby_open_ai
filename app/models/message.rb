class Message < ApplicationRecord
  belongs_to :conversation

  after_create_commit -> { broadcast_created }
  after_update_commit -> { broadcast_updated }

  def broadcast_created
    broadcast_append_to(
      conversation,
      partial: "messages/message",
      locals: { message: self },
      target: "messages"
    )
  end

  def broadcast_updated
    broadcast_replace_to(
      conversation,
      partial: "messages/message",
      locals: { message: self },
      target: "message_#{id}"
    )
  end
end
