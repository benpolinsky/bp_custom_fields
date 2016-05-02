// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  switch ($('.custom-fields').attr('data-action')) {
  case "edit":
    var field_html = $('.custom-fields').html();
    $('form').append(field_html);
    break;
  case  "new":
  var field_html = $('.custom-fields').html();
  $('form').append(field_html);
    break;
  default:
    return false
  }
});
