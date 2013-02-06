var modalLoadingHTML =
    '<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>Loading...</h3></div>'
  + '<div class="modal-body"><img src="/img/loading.gif"> Loading...</div><div class="modal-footer"><a class="btn" data-dismiss="modal">Close</a></div>';
  
var modalFailureHTML =
    '<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>Error</h3></div>'
  + '<div class="modal-body">An unexpected error occured.</div><div class="modal-footer"></div>';
  
function getModalFailureHTML(jqXHR, textStatus, errorThrown) {
  html =
    '<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>Unexpected Error</h3></div>'
  + '<div class="modal-body">An unexpected error occured: <strong>';
  if(textStatus == "error") {
    html += jqXHR['status'] + ' ' + jqXHR['statusText'];
  } else {
    html += textStatus + ' ' + errorThrown;
  }
  
  console.log("**** Modal Failure Debugging Information ****");
  console.log("textStatus: " + textStatus);
  console.log("errorThrown: " + errorThrown);
  console.log("jqXHR: ");
  console.log(jqXHR);
  
  html += '</strong></div><div class="modal-footer"><a class="btn" data-dismiss="modal">Close</a></div>';
  return html;
}