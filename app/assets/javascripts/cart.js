
/**
 * Adds an event to the cart
 */
function addItemToCart(eventId) {
  var eid = eventId;
  liked_cookies = $.cookie("liked");
  if(liked_cookies) {
    split = liked_cookies.split(",");
    // Don't set a cookie if the event is already liked
    if(split.indexOf("" + eventId) != -1) return;
    split.push(eventId);
    $.cookie("liked", split);
  } else {
    $.cookie("liked", [eventId]);
  }
  $("#cart-info").hide();
  var oHtml = $("#cart-sortable").html();
  $("#cart-sortable").html('<div class="cart-loading"><img src="/img/loading.gif"> Loading...</div>');
  // Now Ajax that stuff
  $.ajax("/search/cart_ajax?event_id=" + eid)
    .done(function(data) {
      oHtml += data;
    })
    .always(function() {
      $("#cart-sortable").html(oHtml);
      enableSortable();
    });
}

/**
 * Takes all liked elements on the page and resets cookies
 */
function validateLikedCookies() {
  var ids = new Array();
  $(".liked-event").each(function(index) {
    theId = $(this).data('id');
    if(!isNaN(theId)) ids.unshift(theId);
  });
  console.log(ids);
  $.cookie("liked", ids);
}

/**
 * Remove items from a cart
 */
function removeItemFromCart(eventId) {
  $(".liked-event-" + eventId).fadeOut(300, function() {
    liked_cookies = $.cookie("liked");
    if(liked_cookies) {
      split = liked_cookies.split(",");
      index = $.inArray("" + eventId, split);
      console.log("Removing event ID " + eventId);
      console.log(split);
      console.log("Found at index " + index);
      if(index == -1) return;
      split.splice(index, 1);
      $.cookie("liked", split);
      // Show the info if that was the last element
      console.log(split.length);
      
      if(split.length == 0)
        $("#cart-info").fadeIn();
    } 
    // Make sure to re-enable sorting
    enableSortable();
  });
}


/** Since there's no 'live' for draggable and droppable **/
function enableDragNDrop() {
  $("#cart-items").droppable({
    hoverClass: 'result-hovering',
    accept: '.search-result',
    drop: function(event, ui) {
      event = $(ui.draggable[0]);
      event_id = event.data('eid');
      addItemToCart(event_id); 
    }
  });
  $(".search-result").draggable({
    revert: true,
    opacity: 0.7,
    zIndex: 5
    //cursorAt: {top: 56, left: 0},
  });
}

/** since there's no 'live' for sortable items **/
function enableSortable() {
  $("#cart-sortable").sortable({
    containment: "#cart-items",
    // On change, re-order cookies
    stop: function(event, ui) {
      validateLikedCookies();
    }
  });
}

/**
 * Opens an event for viewing
 */
var originalHtml = null;
var theUrl = '';
var target;

function openEvent(eventId) {
   window.location.hash = "event" + eventId;
}

function actuallyOpenEvent(eventId) {
    theUrl = "/search/event_ajax_full?event_id=" + eventId
    target = $("#results-container");
    
    // We want to keep orignal html, say a user clicks from the cart.
    if(originalHtml == null)
      originalHtml = target.html();
    
    target.fadeOut(100, function() {
      target.show();
      loadingHtml =
        '<div id="event-results-full" class="event-loading"><div id="event-details"><div class="row"><div class="span8"><div class="page-header" style="margin-bottom:0"><h1>Loading</h1></div></div></div>'
      + '<div class="row"><div class="span6"><p><img src="/img/loading.gif"> Loading...</p></div></div></div>';
      
      target.html(loadingHtml);
      $.ajax({
        url: theUrl
      }).done(function(html) {
        var thtml = html;
        target.hide();
        target.fadeIn(200, function() {
          target.html(thtml);
          autoloadGmaps();
        }); 
        
      }).fail(function(jqXHR, textStatus) {
        console.log(jqXHR);
        target.html(modalFailureHTML);
      }).always(function() {
      });
    });
}

function closeEvent() {
  $("#event-result-full").fadeOut(200, function() {
    target = $("#results-container");
    target.html(originalHtml);
    enableDragNDrop();
    originalHtml = null;
    
    // Remove hash
    window.location.hash = "";
  });
}

$(function() {
  
  // Detect if the hash has changed
  $(window).hashchange(function() {
    // console.log("Hash Changed!!");
    hsh =  window.location.hash;
    if(hsh.substring(1,6) == "event") // We're viewing an event
      actuallyOpenEvent(hsh.substring(6));
    else {
      if(originalHtml != null) closeEvent();
    }
  });
  $(window).hashchange();
  
  
  enableSortable();
  enableDragNDrop();
  
  $('.search-result').on('click', function() {
    event_id = $(this).data('eid');
    openEvent(event_id);
  });
  
  // When we click the "cancel" button when we're viewing an event
  $('#event-result-close').on('click', function() {
    closeEvent();
  });
  
  
  // If someone clicks the like button while viewing an event
  $("#event-like-button").on('click', function() {
    addItemToCart($(this).data("id"));
    $(this).html("Added!");
    $(this).fadeOut();
    return false;
  });
  
  // Unlikes an event
  $("#event-unlike-button").on('click', function() {
    removeItemFromCart($(this).data("id"));
    $(this).html("Removed");
    $(this).fadeOut();
    return false;
  });
  
  
  $(".rm-event").on('click', function(e) {
    e.stopPropagation();
    event_id = $(this).data('id');
    removeItemFromCart(event_id);
    
  });
  
  // Set a cookie so that we know whether to show the narrow resutls or liked events
  $("#sidebar-tab-narrow").click(function() {  $.cookie("sTab", "filter"); });
  $("#sidebar-tab-events").click(function() {  $.cookie("sTab", "liked");  });
  
  // Clicking on a liked event
  $(".liked-event").on('click', function(e) {
      openEvent($(this).data('id'));
  });
});