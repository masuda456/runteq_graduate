// app/javascript/controllers/subscribe_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Subscribe controller connected")
  }

  async subscribe(event) {
    event.preventDefault()

    if ("serviceWorker" in navigator) {
      try {
        const registration = await navigator.serviceWorker.register("/sw.js")

        const permission = await Notification.requestPermission()
        if (permission === "granted") {
          const subscription = await registration.pushManager.subscribe({
            userVisibleOnly: true,
            applicationServerKey: urlBase64ToUint8Array("BNFQW8D0D_iGfNze8OI_6vgrGIcLNusOHDIRPqs8ex1HAqtJhy1uKoe0-hnB-7THPHZjYGkVzDUQtQYYbgsbYgQ=")
          })

          const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

          // サーバーにサブスクリプション情報を送信する
          const response = await fetch("/subscriptions", {
            method: "POST",
            body: JSON.stringify({
              subscription: {
                endpoint: subscription.endpoint,
                keys: {
                  p256dh: subscription.toJSON().keys.p256dh,
                  auth: subscription.toJSON().keys.auth
                }
              }
            }),
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": csrfToken
            }
          })

          if (!response.ok) {
            throw new Error("Failed to save subscription on server")
          }

          console.log("Subscribed!")
          const responseData = await response.json()
          console.log("Server response:", responseData)
        } else {
          console.log("Notification permission denied")
        }
      } catch (error) {
        console.error("Service Worker registration or subscription failed", error)
      }
    } else {
      console.log("Service Worker is not supported in this browser")
    }
  }
}

// 公開鍵をUint8Arrayに変換する関数
function urlBase64ToUint8Array(base64String) {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4)
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/")
  const rawData = window.atob(base64)
  const outputArray = new Uint8Array(rawData.length)

  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i)
  }
  return outputArray
}
