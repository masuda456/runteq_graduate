$(function() {
  var current_user_gender = window.currentUser ? window.currentUser.gender : null;

  // ワークアウトの予定の登録と検索の切り替え
  $('.workout-option').on('change', function() {
    if ($('#searchWorkout').is(':checked')) {
      $('#search-WorkoutSchedules-form').show();
      $('#create-WorkoutSchedules-form').hide();
    } else {
      $('#search-WorkoutSchedules-form').hide();
      $('#create-WorkoutSchedules-form').show();
    }
  });

  $('.map-request').on('click', function() {
    var address = '';
    if ($(this).val() == 'create') {
      address = $('#address').val();
    } else if ($(this).val() == 'search') {
      address = $('#address-search').val();
    }

    var handleLocation = function(lat, lng) {
      if ($(this).val() == 'create') {
        console.log($('#date-search').val());
        initMap(lat, lng, 'ジム');
        $('#mapModal').modal('show'); // モーダルウィンドウを表示
      } else if ($(this).val() == 'search') {
        if($('#date-search').val() != ''){
          searchMap(lat, lng, $('#date-search').val(), current_user_gender);
          $('#mapModal').modal('show'); // モーダルウィンドウを表示
        }else{
          alert('他のユーザーの予定を検索する場合は、日付を指定してください。');
        }
      }
    }.bind(this);

    if (address != '') {
      conversionLocation(address, handleLocation);
    } else {
      getCurrentLocation(handleLocation);
    }

    // 地図オブジェクトがロードされているか確認し、されていない場合はエラーメッセージを表示
    setTimeout(function() {
      var isMapLoaded = typeof google !== 'undefined' && google.maps && document.getElementById('map');
      if (!isMapLoaded) {
        $('#map-error-message').show();
      } else {
        $('#map-error-message').hide();
      }
    }, 1000); // 1秒待ってからチェック
  });

  // 地図を非表示にする
  $('#close-modal').on('click', function() {
    $('#mapModal').modal('hide'); 
  });

  // 地図を再表示する
  $('#show-map').on('click', function() {
    $('#mapModal').modal('show'); 
  });
});

function initMap(lat, lng, keyword) {
  console.log('called initMap');

  CustomInfoWindow.prototype = new google.maps.OverlayView();

  CustomInfoWindow.prototype.onAdd = function() {
    var div = document.createElement('div');
    div.style.border = '1px solid black';
    div.style.background = 'white';
    div.style.padding = '5px';
    div.style.position = 'absolute';
    div.style.zIndex = '100';
    div.innerHTML = this.content;
    this.div = div;

    var panes = this.getPanes();
    panes.overlayLayer.appendChild(div);
  };

  CustomInfoWindow.prototype.draw = function() {
    var overlayProjection = this.getProjection();
    var position = overlayProjection.fromLatLngToDivPixel(this.marker.getPosition());
    var div = this.div;
    div.style.left = position.x + 'px';
    div.style.top = position.y + 'px';
  };

  CustomInfoWindow.prototype.onRemove = function() {
    this.div.parentNode.removeChild(this.div);
    this.div = null;
  };

  CustomInfoWindow.prototype.show = function() {
    if (this.div) {
      this.div.style.display = 'block';
    }
  };

  CustomInfoWindow.prototype.hide = function() {
    if (this.div) {
      this.div.style.display = 'none';
    }
  };

  var coords = { lat: lat, lng: lng };

  var mapOptions = {
    center: coords,
    zoom: 15
  };
  var map = new google.maps.Map(document.getElementById('map'), mapOptions);

  if (keyword) {
    var service = new google.maps.places.PlacesService(map);
    service.nearbySearch({
      location: coords,
      radius: 5000,
      keyword: keyword
    }, function(results, status) {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        results.forEach(function(place) {
          createMarker(map, place);
        });
      }
    });
  }

  function createMarker(map, place) {
    var placeLoc = place.geometry.location;
    var marker = new google.maps.Marker({
      map: map,
      position: placeLoc,
      title: place.name
    });

    var contentString = '<div style="font-size: 12px; font-weight: bold;">' + place.name + '</div>';
    var infoWindow = new CustomInfoWindow(map, marker, contentString);

    marker.addListener('mouseover', function() {
      infoWindow.show();
    });

    marker.addListener('mouseout', function() {
      infoWindow.hide();
    });

    marker.addListener('click', function() {
      console.log(place);
      if (confirm(place.name + '\nこのジムでトレーニングしますか？')) {
        $('#googlemap_place_name').val(place.name);
        $('#googlemap_place_id').val(place.place_id);
        $('#googlemap_place_lat').val(place.geometry.location.lat());
        $('#googlemap_place_lng').val(place.geometry.location.lng());
        $('#mapModal').modal('hide');
      }
    });
  }
}

function handleLocationError(browserHasGeolocation) {
  var message = browserHasGeolocation ? 
    'Error: The Geolocation service failed.' : 
    'Error: Your browser doesn\'t support geolocation.';
  console.error(message);
}

function conversionLocation(address, callback) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({ 'address': address }, function(results, status) {
    if (status === 'OK') {
      var location = results[0].geometry.location;
      callback(location.lat(), location.lng());
    } else {
      console.error('Geocode was not successful for the following reason: ' + status);
      getCurrentLocation(function(location) {
        callback(location.lat, location.lng());
      });
    }
  });
}

function getCurrentLocation(callback) {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var userLat = position.coords.latitude;
      var userLng = position.coords.longitude;
      console.log('Current location:', userLat, userLng); // デバッグ用ログ
      callback(userLat, userLng);
    }, function() {
      handleLocationError(true);
    });
  } else {
    handleLocationError(false);
  }
}

function searchMap(lat, lng, date, current_user_gender) {

  CustomInfoWindow.prototype = new google.maps.OverlayView();

  CustomInfoWindow.prototype.onAdd = function() {
    var div = document.createElement('div');
    div.style.border = '1px solid black';
    div.style.background = 'white';
    div.style.padding = '5px';
    div.style.position = 'absolute';
    div.style.zIndex = '100';
    div.innerHTML = this.content;
    this.div = div;

    var panes = this.getPanes();
    panes.overlayLayer.appendChild(div);
  };

  CustomInfoWindow.prototype.draw = function() {
    var overlayProjection = this.getProjection();
    var position = overlayProjection.fromLatLngToDivPixel(this.marker.getPosition());
    var div = this.div;
    div.style.left = position.x + 'px';
    div.style.top = position.y + 'px';
  };

  CustomInfoWindow.prototype.onRemove = function() {
    this.div.parentNode.removeChild(this.div);
    this.div = null;
  };

  CustomInfoWindow.prototype.show = function() {
    if (this.div) {
      this.div.style.display = 'block';
    }
  };

  CustomInfoWindow.prototype.hide = function() {
    if (this.div) {
      this.div.style.display = 'none';
    }
  };

  var coords = { lat: lat, lng: lng };

  var mapOptions = {
    center: coords,
    zoom: 15
  };
  var map = new google.maps.Map(document.getElementById('map'), mapOptions);

  // Ajaxでデータを取得
  $.ajax({
    url: '/workout_schedules/search',  // 必要に応じて変更
    method: 'GET',
    dataType: 'json',
    data: { date: date }, // 日付パラメータを追加
    success: function(data) {
      console.log('AJAX request successful:', data);  // デバッグ用のコンソールログ
      data.forEach(function(schedule) {
        if (schedule.only_same_gender !== "all_genders" && schedule.user.gender !== current_user_gender) {
          return; // 条件を満たさない場合はスキップ
        }

        var place = {
          geometry: {
            location: new google.maps.LatLng(schedule.googlemap_place_lat, schedule.googlemap_place_lng)
          },
          name: schedule.googlemap_place_name,
          place_id: schedule.googlemap_place_id,
          user_name: schedule.user.name,
          user_gender: schedule.user.gender,
          looks: schedule.looks,
          start_at: schedule.start_at,
          finish_at: schedule.finish_at,
          do_leg: schedule.do_leg,
          do_chest: schedule.do_chest,
          do_back: schedule.do_back,
          do_arm: schedule.do_arm,
          do_shoulder: schedule.do_shoulder
        };
        createMarker(map, place, schedule);
      });
    },
    error: function(jqXHR, textStatus, errorThrown) {
      console.error('Ajax request failed: ' + textStatus + ', ' + errorThrown);
    }
  });

  function createMarker(map, place, schedule) {
    var placeLoc = place.geometry.location;
    var marker = new google.maps.Marker({
      map: map,
      position: placeLoc,
      title: place.name
    });

    var contentString = '<div style="font-size: 12px; font-weight: bold;">' + place.name + '</div>';
    var infoWindow = new CustomInfoWindow(map, marker, contentString);

    // マウスオーバーでCustomInfoWindowを表示
    marker.addListener('mouseover', function() {
      infoWindow.show();
    });

    // マウスアウトでCustomInfoWindowを閉じる
    marker.addListener('mouseout', function() {
      infoWindow.hide();
    });

    // マーカーをクリックしたときに処理を実行
    marker.addListener('click', function() {
      // 任意の処理をここに追加
      var targetParts = [];
      if (schedule.do_leg) targetParts.push('脚');
      if (schedule.do_chest) targetParts.push('胸');
      if (schedule.do_back) targetParts.push('背中');
      if (schedule.do_arm) targetParts.push('腕');
      if (schedule.do_shoulder) targetParts.push('肩');

      var message = place.name + '\n\n' +
                    '予定部位: ' + targetParts.join(', ') + '\n' +
                    '予定時刻: ' + schedule.start_at.slice(11, 16) + ' - ' + schedule.finish_at.slice(11, 16) + '\n' +
                    '見た目: ' + schedule.looks + '\n' +
                    'ユーザー: ' + schedule.user.name + '\n' +
                    '性別: ' + schedule.user.gender_in_japanese;

      if (confirm(message)) {
        $('#googlemap_place_name').val(place.name);
        $('#googlemap_place_id').val(place.place_id);
        $('#mapModal').modal('hide');
      }
    });
  }
}

function CustomInfoWindow(map, marker, content) {
  this.map = map;
  this.marker = marker;
  this.content = content;
  this.div = null;
}
