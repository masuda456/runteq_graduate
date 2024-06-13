// app/javascript/packs/application.js
import "google-maps"
import "channels"

// マップを初期化する関数を作成
function initMap() {
    var mapOptions = {
      center: {lat: 34.6937, lng: 135.5023}, // 大阪の中心座標
      zoom: 10
    };
    var map = new google.maps.Map(document.getElementById('map'), mapOptions);
  
    // マーカー情報の配列
    var locations = [
      {lat: 34.6937, lng: 135.5023, title: '大阪'},
      {lat: 34.7019, lng: 135.4940, title: '梅田'},
      {lat: 34.6820, lng: 135.5322, title: 'なんば'}
    ];
  
    // // マーカーを追加
    // locations.forEach(function(location) {
    //     console.log('Adding marker at:', location); // デバッグのためのログ
    //   new google.maps.Marker({
    //     position: {lat: location.lat, lng: location.lng},
    //     map: map,
    //     title: location.title
    //   });
    // });

    for (var i =0; i < locations.length; i++) {
        console.log('Adding marker at:'); // デバッグのためのログ
    }
  }
  
  window.initMap = initMap;
  
