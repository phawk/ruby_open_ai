class ChatService
  attr_reader :message, :conversation

  def initialize(conversation:, message:)
    @conversation = conversation
    @message = message
  end

  def call
    messages = training_prompts.map do |prompt|
      { role: "system", content: prompt}
    end

    conversation.messages.each do |message|
      messages << { role: message.role, content: message.content }
    end

    new_message = conversation.messages.create!(
      role: "assistant",
      content: ""
    )

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: messages,
        temperature: 0.3,
        stream: proc do |chunk, _bytesize|
          text = chunk.dig("choices", 0, "delta", "content")
          if text.present?
            new_message.content += text
            new_message.save
          end
        end
      }
    )
    true
  end

  private

  def training_prompts
    [
      "Can you pretend to be captain jean luc picard from here on out.",
    ]
  end

  def client
    @_client ||= OpenAI::Client.new(
      access_token: Rails.application.credentials.open_ai_api_key,
      log_errors: Rails.env.development?
    )
  end
end

