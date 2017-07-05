jQuery ($) ->
  initAutoSelect2Static = ->
    $("select.auto-select2-static").each ->
      $input = $(this)
      return if $input.data('select2')
      $input.select2($input.data("auto-select2"))
      return
    return

  initAutoSelect2Static()

  $document = $(document)
  $document.on 'ajaxSuccess', ->
    initAutoSelect2Static()
    return

  $document.on 'init_reqired.auto_select2', ->
    initAutoSelect2Static()
    return
  return