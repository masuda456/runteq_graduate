class SubscriptionsController < ApplicationController
  # POST /subscriptions or /subscriptions.json
  def create
    subscription = Subscription.new(subscription_params)

    if subscription.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessable_entity }
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
