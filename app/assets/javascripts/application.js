// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require defs
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require_tree ./jquery_plugins
//= require_tree ./plugins
//= require cart


function showRemoteModal(modalToShow, url) {
  target  = modalToShow
  theHtml = modalLoadingHTML;
  theUrl  = url
  target.html(theHtml);
  target.modal('show');
  $.ajax({
    url: theUrl
  }).done(function(html) {
    target.html(html);
  }).fail(function(jqXHR, textStatus, errorThrown) {
    target.html(getModalFailureHTML(jqXHR, textStatus, errorThrown));
  });
}

/**
 * Updates hidden times. Assumes date/times to be correct up to this point
 */
function updateHiddenDateTime(container) {
  console.log("Updating hidden time");
  
  base_date_id = "#" + container.data('id') + "_date_";
  base_time_id = "#" + container.data('id') + "_time_";
  base_hidden_id = "#" + container.data('object') + "_";
  
  // Get dates
  start_date = $(base_date_id + container.data('start'));
  stop_date  = $(base_date_id + container.data('stop'));
  
  // Get Times
  start_time = $(base_time_id + container.data('start'));
  stop_time  = $(base_time_id + container.data('stop'));
  
  // Hidden Field
  start_hidden = $(base_hidden_id + container.data('start'));
  stop_hidden  = $(base_hidden_id + container.data('stop'));
  
  // The seconds to be stored into the hidden fields
  date_start = null;
  date_stop  = null;
  
  try {
    // Get the base date and then add seconds
    date_start  = $.datepicker.parseDate("mm/dd/yy", start_date.val()).getTime() / 1000;
    date_start += parseTime(start_time.val());
    date_start =  new Date(date_start * 1000);
  } catch(err) { }
  
  try {
    date_stop = $.datepicker.parseDate("mm/dd/yy", stop_date.val()).getTime() / 1000;
    date_stop += parseTime(stop_time.val());
    date_stop = new Date(date_stop * 1000);
  } catch(err) {}

  if(date_start instanceof Date)
    start_hidden.val(date_start.format("isoDateTime"));
    
  if(date_stop instanceof Date)
    stop_hidden.val(date_stop.format("isoDateTime"));
  
}


/**
 * Converts a time string into number of seconds since the beginning of the day
 */
function parseTime(time) {
  try {
    hours   = time.substring(0,2);
    minutes = time.substring(3,5);
    ampm    = time.substring(5,7);
    
    if(hours.substring(0,1) == 0)
      hours = hours.substring(1,2);
    
    if(minutes.substring(0,1) == 0)
      minutes = minutes.substring(1,2);
      
    //console.log("Parsing time; input: '" + time + "', string parse: '" + hours + "-" + minutes + "'");
    
    hours   = parseInt(hours);
    minutes = parseInt(minutes);
    
    if(isNaN(hours) || isNaN(seconds))
      return 0;

    // If PM, add 12 hours to the value, except for 12:00pm
    if(ampm == "PM" && hours != 12)
      hours += 12;
      
    // If 12am, this translates to 00:00 in the 24-hour clock
    if(ampm == "AM" && hours == 12)
      hours = 0;
    
    seconds  = minutes * 60;
    seconds += hours * 60 * 60;
  } catch(err) {
    seconds = 0;
  }
  
  // If NaN, return 0
  if(isNaN(seconds))
    seconds = 0;
  return seconds;
}


$(function() {
  
  $('textarea.wysiwyg').each(function(){
    id = $(this).attr('id');
    new nicEditor({buttonList: ['bold', 'italic', 'underline', 'ul', 'ol'], iconsPath : '/img/nicEditorIcons.gif'}).panelInstance(id);
  });
  
  $('body').tooltip({ selector: "[rel=tooltip]" });
  $("#flash-messages").delay(10000).fadeOut("slow");
  
  $("input.datetime-date").datepicker({
    changeMonth: true,
    changeYear:  true
  });
  
  $("input.datetime-time").timeEntry();
  
  $("a.datetime-timezone-change").click(function() {
    attr = $(this).data('attr');
    console.log(attr);
    $(this).parent().hide();
    $("#datetime-timeone-select-container_" + attr).show();
    return false;
  });
  
  $("input.hidden-datetime").closest("form").submit(function() {
    $("input.hidden-datetime").each(function() {
      id = this.id;
      date = $("#datetime_date_" + id);
      time = $("#datetime_time_" + id);
      timezone = $("#tzone_" + id + " option:selected").html().substr(4, 6);
      str = date.val() + " " + time.val() + " " + timezone;
      $(this).val(str);
      
    });
    return true;
  });
  
  $(".datetime-range .datetimerange-date-start, .datetime-range .datetimerange-date-stop").change(function() {
    container = $(this).parent().parent();
    base_id = "#" + container.data('id') + "_date_";
    
    start = $(base_id + container.data('start'));
    stop  = $(base_id + container.data('stop'));
    
    var date_start, date_stop;
    
    // Parse Start Date
    try {
      date_start = $.datepicker.parseDate("mm/dd/yy", start.val());
    } catch(err) {
      console.log("Couldn't parse date start!");
      return;
    }
    
    if(date_start == null) {
      console.log("Date start is null; stopping parse");
      return;
    }
    
    // Parse Stop Date
    try {
      date_stop  = $.datepicker.parseDate("mm/dd/yy", stop.val());
    } catch(err) {
      console.log("Couldn't parse date stop, using date_start");
      date_stop  = date_start;
    }
  
    
    // If we specified no end date
    if(date_stop == null) {
      date_stop = date_start;
      stop.val(date_start.format('mm/dd/yy'));
    }
      
    // We changed the start date
    if($(this).attr('id') == start.attr('id') && date_start.getTime() > date_stop.getTime())
      stop.val(date_start.format('mm/dd/yy'));
    
    // If we changed the stop date
    if($(this).attr('id') == stop.attr('id') && date_start.getTime() < date_stop.getTime())
      start.val(date_stop.format('mm/dd/yy'));
    
    updateHiddenDateTime(container);
    
  });
  
  $(".datetime-range .datetimerange-time-start, .datetime-range .datetimerange-time-stop").change(function() {
    console.log("Time Updated!");
    container = $(this).parent().parent().parent();
    console.log(container);
    updateHiddenDateTime(container);
  });
  
    
  $("a.remote-modal").on('click', function() {
    showRemoteModal($("#remote-modal-container"), $(this).attr('href'));
    return false; 
  });
  
  /*
  $(".remote-modal").not("a").live('click', function() {
    if($(this).data('url'))
      showRemoteModal($("#remote-modal-container"), $(this).data('url'));
  }) */
  
  
  $(".remote-modal-open").on('click', function() {
    console.log($(this).data('modal-id'));
    target = $("#remote-modal-" + $(this).data('modal-id'));
    theHtml = modalLoadingHTML;
    theUrl = target.data('url');
    target.html(theHtml);
    target.modal('show');
    $.ajax({
      url: theUrl
    }).done(function(html) {
      target.html(html);
    }).fail(function(jqXHR, textStatus) {
      console.log(jqXHR);
      target.html("Request Failed: " + textStatus);
    });
  });
  
  
  $(".filter-flag").each(function() {
    if($(this).val() == "1") {
      fid = $(this).data('id');
      console.log("ID: " + fid);
      $(".filter-children-" + fid).hide();
      tgl = $("#toggle-filter-" + fid);
      oh  = tgl.data('original-text');
      tgl.html(oh + "&nbsp;&nbsp; (all)");
    }
  });
  
  // Filter Sidebar
  $(".toggle-filter").click(function() {
    ele = $(this);
    id  = $(this).data('id');
    flag = $("#fhide_" + id);
    
    children = $(".filter-children-" + id);
    checkboxes = $(".filter-chk-parent-" + id);
    
    // Already Hidden, so show all children
    if(flag.val() == "1") {
      children.fadeIn();
      checkboxes.prop("checked", false);
      flag.val("0");
      ele.html(ele.data('original-text'));
      
    // Not hidden, so hide and select children
    } else {
      children.fadeOut();
      checkboxes.prop("checked", true);
      flag.val("1");
      ele.html(ele.data('original-text') + "&nbsp;&nbsp; (all)");
    }
  });
  
});