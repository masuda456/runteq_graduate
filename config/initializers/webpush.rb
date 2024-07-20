Webpush.configure do |config|
  config.vapid_key = {
    subject: Rails.application.credentials.dig(:webpush, :vapid_key, :subject),
    public_key: Rails.application.credentials.dig(:webpush, :vapid_key, :public_key),
    private_key: Rails.application.credentials.dig(:webpush, :vapid_key, :private_key)
  }
end
