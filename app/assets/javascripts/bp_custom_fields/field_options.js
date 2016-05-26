jQuery(document).ready(function() {
  // need to call this everytime an field is added by cocoon
  $('.field-template-select-field-type').each(function(index) {
    bp_bind_type_select($(this));
  });
  
  $('.field_template-fields').on('cocoon:after-insert', function (e, insertedItem) {
    new_select = insertedItem.find('select.field-template-select-field-type').first();
    bp_bind_type_select(new_select);
  })
  
  $('.field_template-fields').on('keyup', 'input.field_template-name', function(event) {
    bp_update_header_value(this, 'name', $(this).val());
  });
  
  $('.field_template-fields').on('keyup', 'input.field_template-label', function(event) {
    bp_update_header_value(this, 'label', $(this).val());
  });
});

function bp_bind_type_select(select){
  var container = select.closest('.nested-fields');
  if (select.val() != ""){
    bp_show_field_options_for(select.val(), container);
    disable_other_fields(select.val(), container);
  }
  select.change(function(event) {
    var field_type = $(this).val();
    var selected_text = $('#' + $(this).context.id + ' option:selected').text();
    bp_show_field_options_for(field_type, container);
    bp_update_header_value(this, 'type', selected_text);
  });  
}

function bp_show_field_options_for(field_type, container) {
  container.find('.additional-option').removeClass('active');
  container.find('.' + field_type + '.additional-option').addClass('active');
}

function disable_other_fields(field_type, container) {
  var non_active_containers = container.find('.additional-option').not('.' + field_type);
  // console.log(non_active_containers);
  container.find('.additional-option').not('.' + field_type).each(function(index) {
    $(this).find("input, textarea, select").attr('disabled', true);
  });
}

function bp_update_header_value(el, column, value) {
  $(el).closest('.nested-fields').find('#'+column).text(value);
}