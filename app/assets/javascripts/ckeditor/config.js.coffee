# http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html#.toolbar_Full
CKEDITOR.editorConfig = (config) ->
  config.language = 'en'
  config.width = '650'
  config.height = '200'
  config.toolbar_Pure = [
    { name: 'paragraph',   items: [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
    { name: 'insert',      items: [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak' ] },
    { name: 'links',       items: [ 'Link','Unlink' ] },
    { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike'] },
    { name: 'colors',      items: [ 'TextColor','BGColor' ] },
    { name: 'styles',      items: [ 'Styles','Format','Font','FontSize' ] }
  ]
  config.toolbar = 'Pure'
  true