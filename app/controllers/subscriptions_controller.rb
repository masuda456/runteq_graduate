class SubscriptionsController < ApplicationController
  # POST /subscriptions or /subscriptions.json
  def create
    subscription = Subscription.new(subscription_params)
    subscription.user = current_user

    if subscription.save
      WebPush.payload_send(
        message: {
          title: 'success save ',
          body: 'You have a new subscription'
        }.to_json,
        endpoint: subscription['endpoint'],
        p256dh: subscription['keys']['p256dh'],
        auth: subscription['keys']['auth'],
        vapid: {
          subject: Rails.application.config.webpush[:vapid_key][:subject],
          public_key: Rails.application.config.webpush[:vapid_key][:public_key],
          private_key: Rails.application.config.webpush[:vapid_key][:private_key]
        }
      )
      render json: { status: :ok }
    else
      Rails.logger.error subscription.errors.full_messages
      render json: { status: :unprocessable_entity, errors: subscription.errors.full_messages }
    end
  end

  # DELETE /subscriptions or /subscriptions.json
  def destroy
    subscription = Subscription.find_by(
      endpoint: subscription_params[:endpoint],
      user_id: subscription_params[:user_id]&.to_i
    )

    if subscription.destroy
      render json: { status: :ok }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  private
    def subscription_params
      params
	.require(:subscription)
	.permit(:endpoint, :auth_key, :p256dh_key, :user_id)
    end
end
