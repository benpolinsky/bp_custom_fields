$(document).ready(function() {
  var toolbarStates = {
    none: [],
    basic: ['bold', 'italic', 'underline', 'anchor', 'h2', 'h3', 'quote'],
    full: ['bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript', 'orderedlist', 'unorderedlist', 'indent', 'outdent', 'justifyCenter', 'justifyLeft', 'justifyFull', 'justifyRight', 'anchor', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'quote', 'pre', 'removeFormat']
  }
  var editor = new MediumEditor('.bpcf-editor', {
    toolbar: {
      buttons: toolbarStates["basic"]
    }
  });
});
