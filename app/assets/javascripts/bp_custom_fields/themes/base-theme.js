jQuery(document).ready(function($) {
  // TODO: you need to gather each within a flex group... but one thing at a time
  // all add_links, replace with a plus, and move text to a hover state
  if ($('.custom-field-container ').length > 0 && $('.links .add_fields').length > 0) {
    initialize_custom_field_design()    
  }
  
  $('.custom-field-container').on('click', '.toggle-group', function(event) {
    var nextFieldGroup = $(this).siblings('.custom-group-inner');
    $(this).toggleClass('active');
    toggleFieldGroup(nextFieldGroup);
  });

});

function toggleFieldGroup(fieldGroup) {
  fieldGroup.toggleClass('active');
}

function initialize_custom_field_design() {
  var bpcf_element_counter = 0;
  
  var fields = $('.links .add_fields')
  var menu = '<div class="field-menu">+</div>';
  $('.custom-field-container').append(menu);
  
  fields.each(function(index) {
    $(this).attr('id', "l_"+(new Date().getTime()+bpcf_element_counter++));
    current_template = $('.field-menu').data('template');
    if (current_template == undefined) {current_template = ""}
    $('.field-menu').data('template', (current_template + append_drop(this)));
    add_base_link_styles(this);
  });
  
  append_menu();
  
}

function add_base_link_styles(el) {
  $(el).addClass('bpcf-link-hidden');
}

function append_drop(el) {
  return "<a href='#' class='drop-link' data-target='"+$(el).attr('id')+"'>" + $(el).text() + "</a>";
}

function append_menu() {

  var drop = new Drop({
     target: $('.field-menu')[0],
     position: 'left middle',
     content: $('.field-menu').data('template'),
     openOn: 'hover',
     classes: "drop-theme-arrows-bounce-dark the-menu"
   })
   
   drop.once('open', function(event) {
     $('a.drop-link').on('click', function(event){
       var dataId = $(this).attr('data-target');
       $('a#'+dataId+'').click();
       drop.position();
        event.preventDefault();
     });
   });
}