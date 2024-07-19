# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  protect_from_forgery except: [:subscribe]

  def subscribe
    begin
      subscription = JSON.parse(request.body.read)
      Webpush.payload_send(
        message: {
          title: 'Push Notification',
          body: 'You have a new message!'
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
      render json: { message: 'Notification sent successfully' }, status: :ok
    rescue => e
      Rails.logger.error "Error sending push notification: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def self.send_daily_push_notifications
    subscriptions = PushSubscription.all
    subscriptions.each do |subscription|
      Webpush.payload_send(
        message: {
          title: 'Daily Push Notification',
          body: 'Here is your daily update!',
          icon: '/images/icons/icon-192x192.png'
        }.to_json,
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh,
        auth: subscription.auth,
        vapid: {
          subject: Rails.application.config.webpush[:vapid_key][:subject],
          public_key: Rails.application.config.webpush[:vapid_key][:public_key],
          private_key: Rails.application.config.webpush[:vapid_key][:private_key]
        }
      )
    end
  end
end
