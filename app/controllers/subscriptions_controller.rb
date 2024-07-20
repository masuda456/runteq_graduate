class SubscriptionsController < ApplicationController
  protect_from_forgery except: :create

  def create
    subscription = Subscription.new(subscription_params)
    subscription.user = current_user

    if subscription.save
      begin
        Rails.logger.info "Attempting to send push notification to #{subscription.endpoint}"

        Webpush.payload_send(
          message: {
            title: 'Subscription Saved',
            body: 'You have a new subscription'
          }.to_json,
          endpoint: subscription.endpoint,
          p256dh: subscription.p256dh_key,
          auth: subscription.auth_key,
          vapid: {
            subject: Rails.application.credentials.dig(:webpush, :vapid_key, :subject),
            public_key: Rails.application.credentials.dig(:webpush, :vapid_key, :public_key),
            private_key: Rails.application.credentials.dig(:webpush, :vapid_key, :private_key)
          }
        )

        Rails.logger.info "Push notification sent successfully"
        render json: { status: :ok }
      rescue => e
        Rails.logger.error "Error sending push notification: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        render json: { status: :internal_server_error, error: e.message }
      end
    else
      Rails.logger.error subscription.errors.full_messages
      render json: { status: :unprocessable_entity, errors: subscription.errors.full_messages }
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, :auth_key, :p256dh_key)
  end
end
