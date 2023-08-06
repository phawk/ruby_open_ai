OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.open_ai_api_key
end
