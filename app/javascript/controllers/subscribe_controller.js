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

          // サーバーにサブスクリプション情報を送信する
          await fetch("/subscriptions", {
            method: "POST",
            body: JSON.stringify(subscription),
            headers: {
              "Content-Type": "application/json"
            }
          })

          console.log("Subscribed!")
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
