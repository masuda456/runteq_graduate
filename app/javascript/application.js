// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "jquery"
import "bootstrap"

Turbo.start()

// サービスワーカーの登録
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js')
      .then((registration) => {
        console.log('Service Worker registered:', registration);

        // サブスクライブボタンのクリックイベント
        const subscribeButton = document.getElementById('subscribe-btn');
        subscribeButton.addEventListener('click', () => {
          subscribeUserToPush(registration);
        });
      })
      .catch((error) => {
        console.error('Service Worker registration failed:', error);
      });
  });
}

function urlBase64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding)
    .replace(/-/g, '+')
    .replace(/_/g, '/');
  const rawData = window.atob(base64);
  const outputArray = new Uint8Array(rawData.length);
  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

function subscribeUserToPush(registration) {
  const subscribeOptions = {
    userVisibleOnly: true,
    applicationServerKey: urlBase64ToUint8Array('BLLLR6hD2JNT-pSrRD6D3cexVqrnxoprMOQrb2CXWOpkyDlDNMKdIdSITWOy6hW2_7hgesvF2U76RW4s2bLoVMw')
  };

  registration.pushManager.subscribe(subscribeOptions)
    .then(function(pushSubscription) {
      console.log('Received PushSubscription:', JSON.stringify(pushSubscription));
      return fetch('/notifications/subscribe', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(pushSubscription)
      });
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      console.log('Subscription successful:', data);
    })
    .catch(function(error) {
      console.error('Failed to subscribe the user: ', error);
      if (error.name) {
        console.error('Error name:', error.name);
      }
      if (error.message) {
        console.error('Error message:', error.message);
      }
      if (error.stack) {
        console.error('Error stack:', error.stack);
      }
    });
}
