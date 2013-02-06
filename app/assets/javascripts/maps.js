/**
 *= require smartinfowindow
 */


function autoloadGmaps() {
    $(".map-container").each(function(index, value) {
        container = $(value);
        children = container.children();
        options = container.data("options");
        if(options == null) options = {};
        if(options['latitude'] == null) options['latitude'] = 39.833333;
        if(options['longitude'] == null) options['longitude'] = -98.583333;
        if(options['zoom'] == null) options['zoom'] = 3;
        if(options['hideControls'] ==  null) options['hideControls'] = false;
    
    
        //h = !options['hideControls'];
        // for now, always hide controls
        h = false;
        
        var options = {
          // Center to the center of the us
          center: new google.maps.LatLng(options['latitude'], options['longitude']),
          zoom: options['zoom'],
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          zoomControl: h,
          scaleControl: h,
          panControl: h,
          mapTypeControl: h,
          streetViewControl: h
        };
        
        console.log("Creating map!");
        console.log(options)
        var map = new google.maps.Map(value, options);
        
        var markers = [];
        
        children.map(function() {
            var marker = $(this);
            options = marker.data("options");
            if(options == null) options = {};
            if(options['latitude'] == null) options['latitude'] = 39.833333;
            if(options['longitude'] == null) options['longitude'] = -98.583333;
            
            opts = {map: map, position: new google.maps.LatLng(options['latitude'], options['longitude'])};
            mrkr = new google.maps.Marker(opts);
            markers.push(mrkr);
            
            if($(this).html()) {
            
              google.maps.event.addListener(mrkr, 'click', function(e) {
                  var content = marker.html();
                  console.log(content);
                  var infobox = new SmartInfoWindow({position: mrkr.getPosition(), map: map, content: content });
              });
            }
            
            
        });
        
    });
}


$(function() {
    autoloadGmaps();
});