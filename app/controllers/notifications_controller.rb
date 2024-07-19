# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  protect_from_forgery except: [:subscribe]

  def subscribe
    subscription = JSON.parse(request.body.read)
    Webpush.payload_send(
      message: {
        title: 'Push Notification',
        body: 'You have a new message!',
        icon: '/images/icons/icon-192x192.png'
      }.to_json,
      endpoint: subscription['endpoint'],
      p256dh: subscription['keys']['p256dh'],
      auth: subscription['keys']['auth'],
      vapid: {
        subject: 'mailto:YOUR_EMAIL@example.com',
        public_key: Rails.application.config.webpush[:vapid_public_key],
        private_key: Rails.application.config.webpush[:vapid_private_key]
      }
    )
    head :ok
  end
end
