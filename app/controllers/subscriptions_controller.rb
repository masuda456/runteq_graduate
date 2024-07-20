class SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.new(subscription_params)
    subscription.user = current_user

    if subscription.save
      WebPush.payload_send(
        message: {
          title: 'Success save ',
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
      render json: { status: :ok }
    else
      Rails.logger.error subscription.errors.full_messages
      render json: { status: :unprocessable_entity, errors: subscription.errors.full_messages }
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, :p256dh_key, :auth_key)
  end
end
