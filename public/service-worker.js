self.addEventListener('install', function(event) {
  console.log('Service Worker installing.');
  // キャッシュやその他のインストールタスクをここに書く
});

self.addEventListener('activate', function(event) {
  console.log('Service Worker activating.');
  // 古いキャッシュのクリアなどのタスクをここに書く
});

self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request).then(function(response) {
      return response || fetch(event.request);
    })
  );
});
