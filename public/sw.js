const CACHE_NAME = 'example_cache';
const urlsToCache = [
  '/',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => response || fetch(event.request))
  );
});

self.addEventListener("push", event => {
  // if (event.data) {
  //   const data = event.data.json();
  //   console.log("Push received:", data);
  //   self.registration.showNotification('test', {body: 'showNotification test'});
  //   const options = {
  //     body: data.body
  //   };
  //   // event.waitUntil(
  //     // self.registration.showNotification(data.title, options)
  //   // );
  // } else {
  //   console.log("Push event but no data");
  // }

  const options = {
    body: 'This is a test notification body'
  };

  event.waitUntil(
    self.registration.showNotification('Test Notification', options)
      .then(() => console.log("Notification shown successfully"))
      .catch(err => console.error("Error showing notification", err))
  );
});
