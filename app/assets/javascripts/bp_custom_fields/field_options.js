jQuery(document).ready(function() {
  // need to call this everytime an field is added by cocoon
  $('.field-template-select-field-type').each(function(index) {
    bp_bind_type_select($(this));
  });
  
  $('.field_template-fields').on('cocoon:after-insert', function (e, insertedItem) {
    new_select = insertedItem.find('select.field-template-select-field-type').first();
    bp_bind_type_select(new_select);
  })
});

function bp_bind_type_select(select){
  var container = select.parents('.nested-fields').first();
  if (select.val() != ""){bp_show_field_options_for(select.val(), container)};
  select.change(function(event) {
    var field_type = select.val();
    bp_show_field_options_for(field_type, container);
  });  
}

function bp_show_field_options_for(field_type, container) {
  container.find('.additional_option').removeClass('active');
  container.find('.' + field_type + '.additional_option').addClass('active');
}
