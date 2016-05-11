jQuery(document).ready(function() {
  // need to call this everytime an field is added by cocoon
  bp_show_field_options_for($('.field-template-select-field-type').val());
  $('.field-template-select-field-type').change(function(event) {
    var field_type = $(this).val();
    bp_show_field_options_for(field_type);
  });
});


function bp_show_field_options_for(field_type) {
  $('.additional_option').removeClass('active');
  $('.' + field_type + '.additional_option').addClass('active');
}

