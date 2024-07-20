VAPID_PUBLIC_KEY = Rails.application.credentials.dig(:webpush, :vapid_key, :public_key)
VAPID_PRIVATE_KEY = Rails.application.credentials.dig(:webpush, :vapid_key, :private_key)
VAPID_SUBJECT = Rails.application.credentials.dig(:webpush, :vapid_key, :subject)
