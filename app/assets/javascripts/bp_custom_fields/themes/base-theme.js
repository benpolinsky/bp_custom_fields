jQuery(document).ready(function($) {
  // all add_links, replace with a plus, and move text to a hover state
  $('.links .add_fields').each(function(index) {
    add_base_link_styles(this);
  });
  $('.links').on('mouseover', 'a.add_fields', function(event) {
    console.log('hover over here!');
  });
});

function add_base_link_styles(el) {
  $(el).addClass('add-icon');
}
