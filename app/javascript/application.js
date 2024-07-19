document.getElementById('subscribe-btn').addEventListener('click', () => {
  navigator.serviceWorker.ready.then(function(registration) {
    const subscribeOptions = {
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array('BAD2vsi8pwGL0SLmyMUjhyaGAEXP0GKZT2exQp7f6EOlToqhCm9qDLNPPyg6TssGrOS_g6cSkAJ0zKQklOJL7LE')
    };

    return registration.pushManager.subscribe(subscribeOptions);
  }).then(function(pushSubscription) {
    console.log('Received PushSubscription:', JSON.stringify(pushSubscription));
    
    return fetch('/notifications/subscribe', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(pushSubscription)
    });
  }).then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  }).then(data => {
    console.log('Subscription successful:', data);
  }).catch(function(error) {
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
});
