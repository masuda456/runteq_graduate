class Notification < ApplicationRecord
  belongs_to :user
  has_many :subscriptions, through: :user

  validates :title, presence: true
  validates :body, presence: true

  after_create :push

  def push
    creds = Rails.application.credentials
    subscriptions.each do |subscription|
      response =
        WebPush.payload_send(
          message: to_json,
          endpoint: subscription.endpoint,
          p256dh: subscription.p256dh_key,
          auth: subscription.auth_key,
          vapid: {
            private_key: creds.webpush.private_key,
            public_key: creds.webpush.public_key
          }
        )

      logger.info "WebPush Info: #{response.inspect}"
    rescue WebPush::ExpiredSubscription,
           WebPush::InvalidSubscription
      logger.warn "WebPush Warn: #{response.inspect}"
    rescue WebPush::ResponseError => e
      logger.error "WebPush Error: #{e.message}"
    end
  end
end
