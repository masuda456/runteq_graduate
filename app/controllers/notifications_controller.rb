# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  protect_from_forgery except: [:subscribe]

  def subscribe
    begin
      subscription = {
        endpoint: params[:endpoint],
        keys: {
          p256dh: params[:p256dh],
          auth: params[:auth]
        }
      }
      Webpush.payload_send(
        message: {
          title: 'Push Notification',
          body: 'You have a new message!',
          icon: '/images/icons/icon-192x192.png'
        }.to_json,
        endpoint: subscription[:endpoint],
        p256dh: subscription[:keys][:p256dh],
        auth: subscription[:keys][:auth],
        vapid: {
          subject: 'mailto:YOUR_EMAIL@example.com',
          public_key: Rails.application.config.webpush[:vapid_public_key],
          private_key: Rails.application.config.webpush[:vapid_private_key]
        }
      )
      head :ok
    rescue => e
      Rails.logger.error "Error sending push notification: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
