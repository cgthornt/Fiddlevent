$(function(){
   var isSearching= false;
   
   $("#lookup_fb_url").click(function(){
    if(isSearching)
       return false;
    
    if(!confirm("This will overwrite existing form data; continue?"))
      return false;
    
    var fb_url= $("#event_facebook_url");
    fb_url.attr("disabled", "disabled");
    var url= $.url(fb_url.val());
    $("#lookup_fb_url").val("Searching...");
    console.log(url.attr('host'));
    console.log(url.attr('path'));
    var fb_id= url.segment(2);
    var api_url= "https://graph.facebook.com/" + fb_id;
    
    $("#fb_url_error").fadeOut();
    
    var request= $.ajax({
        url: api_url,
        dataType: 'json'
    });
    
    request.done(function(data){
     if(data == false)
        $("#fb_url_error").fadeIn();
        
     else
     {
        $("#event_name").val(data["name"]);
        $("#event_description").val(data["description"]);
        $("#event_fb_event_id").val(data["id"]);
        
        // Dates are parsed as UTC, as such Javascript will automatically apply an offset.
        // We will need to remove that offset. We want to directly put the start/stop time
        // from facebook into our event
        offset  = new Date().getTimezoneOffset() * 60 * 1000;
        st      = new Date(data["start_time"]).getTime() + offset;
        et      = new Date(data["end_time"]).getTime() + offset;
        
        start_time = new Date(st);
        end_time   = new Date(et);
        
        // Start Time
        $("#datetime_event_date_time_start").val(start_time.format("mm/dd/yyyy"));
        $("#datetime_event_time_time_start").val(start_time.format("hh:MMTT"));
        $("#event_time_start").val(start_time.format("isoDateTime"));
        
        // End Time
        // Start Dates
        $("#datetime_event_date_time_stop").val(end_time.format("mm/dd/yyyy"));
        $("#datetime_event_time_time_stop").val(end_time.format("hh:MMTT"));
        $("#event_time_stop").val(end_time.format("isoDateTime"));
        
        // $("#datetime_time_event_time_stop").val(s);
     }
 
     console.log(data);
    });
    
    request.fail(function() {
     $("#fb_url_error").fadeIn();
    });
    
    request.always(function() {
     fb_url.attr("disabled", false);
     isSearching= false;
    });
        
   });
});