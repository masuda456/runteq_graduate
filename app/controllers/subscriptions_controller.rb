class SubscriptionsController < ApplicationController
  protect_from_forgery except: :create

  def create
    subscription = Subscription.new(subscription_params)
    subscription.user = current_user

    if subscription.save
      begin
        Rails.logger.info "Attempting to send push notification to #{subscription.endpoint}"

        WebPush.payload_send(
          message: {
            title: 'success save subscription',
            body: 'You have a new subscription'
          }.to_json,
          endpoint: subscription.endpoint,
          p256dh: subscription.keys['p256dh'],
          auth: subscription.keys['auth'],
          vapid: {
            subject: Rails.application.config.webpush[:vapid_key][:subject],
            public_key: Rails.application.config.webpush[:vapid_key][:public_key],
            private_key: Rails.application.config.webpush[:vapid_key][:private_key]
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
    params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
  end
end
