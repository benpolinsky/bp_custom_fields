jQuery(document).ready(function($) {
  // TODO: you need to gather each within a flex group... but one thing at a time
  // all add_links, replace with a plus, and move text to a hover state
  
  var fields = $('.links .add_fields')
  var menu = '<div class="field-menu">+</div>';
  $('body').append(menu);
  
  fields.each(function(index) {
    current_template = $('.field-menu').data('template');
    if (current_template == undefined) {current_template = ""}
    $('.field-menu').data('template', (current_template + append_drop(this)));
    add_base_link_styles(this);
  });
  
  append_menu();
});

function add_base_link_styles(el) {
  $(el).addClass('add-icon');
}

function append_drop(el) {
  return "<p>" + $(el).text() + "</p>";
  // content = $(el).text()
 
}

function append_menu() {
  console.log($('.field-menu').data('template'));
   new Drop({
     target: $('.field-menu')[0],
     position: 'left middle',
     content: $('.field-menu').data('template'),
     openOn: 'hover',
     classes: "the-menu"
   })
}