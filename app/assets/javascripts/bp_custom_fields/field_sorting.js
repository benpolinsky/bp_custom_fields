jQuery(document).ready(function($) {
  if (document.getElementById('field-template-sort-container') !== null) {
    var el = document.getElementById('field-template-sort-container');
    var sortable = Sortable.create(el, {
      handle: '.bpcf-header-list-top',
      onEnd: function (e) {
        console.log(e.oldIndex, e.newIndex);
        $('.nested-fields').each(function(index) {
          var new_index = index+1
          $(this).find('.bpcf-field-header .bpcf-header-list-bottom li#order').text(new_index);
          $(this).find('.bpcf-field-header .bpcf-header-list-bottom input[type="hidden"]').val(new_index);
        });
      }
    });    
  }
});
