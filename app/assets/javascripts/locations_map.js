
var geocoder;
var map;
var marker;
var previewResult;

function previewMap() {
  address = $("#location_address").val();
  address_2 = $("#location_address_2").val();
  city = $("#location_city").val();
  state = $("#location_state_id option:selected").text();
  zip = $("#location_zip").val();
  addr = address + " " + address_2 + ", " + city + " " + state + " " + zip;
  geocoder.geocode({'address' : addr}, function(results, status) {
    if(status == google.maps.GeocoderStatus.OK) {
      previewResult = true;
      // Remove existing marker
      if(marker != null) {
        marker.setMap(null);
        marker = null;
      }
      
      // Center the map
      loc = results[0].geometry.location;
      map.setCenter(loc);
      marker = new google.maps.Marker({
        map: map,
        position: loc
      });
      map.setZoom(17);
      
      // Set latitude and logitude
      $("#location_latitude").val(loc.lat());
      $("#location_longitude").val(loc.lng());
      
    }
  });
  
  return true;
}


$(function() {

  
  lat = $("#location_latitude").val();
  lng = $("#location_longitude").val();
  
  cnt = new google.maps.LatLng(39.833333, -98.583333);
  zm  = 3;
  
  if(lat && lng) {
    cnt = new google.maps.LatLng(lat, lng);
    zm = 17;
  }
  
  var options = {
    // Center to the center of the us
    center: cnt,
    zoom: zm,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  
  map = new google.maps.Map(document.getElementById("google-maps-locations-form"), options);
  geocoder = new google.maps.Geocoder();
  

  if(lat && lng) {
    marker = new google.maps.Marker({
      map: map,
      position: cnt
    });
  }

  $("#location-form-preview").click(function() {
    previewMap();
    return false;
  });
  
  $("#new_location,#edit_location>input").focusout(function() {
    previewMap();
  });
  
});