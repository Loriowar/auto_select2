jQuery ($) ->
  window.initAutoDataSelect2 = ->
    $('input.auto-data-select2').each ->
      $input = $(this)
      return if $input.data('select2')
      customFormatSelection = $input.data('s2-format-selection')
      customFormatResult = $input.data('s2-format-result')
      if customFormatSelection isnt `undefined` && (window[customFormatSelection] isnt `undefined`)
        formatSelectionFunc = window[customFormatSelection]
      if (customFormatResult isnt `undefined`) && (window[customFormatResult] isnt `undefined`)
        formatResultFunc = window[customFormatResult]
      $input.select2({
        data: $input.data('s2-data')
        formatSelection: formatSelectionFunc
        formatResult: formatResultFunc
      })
      return
    return
  initAutoDataSelect2()


  $document = $(document)
  $document.on 'ajaxSuccess', ->
    initAutoDataSelect2()
    return

  $document.on 'cocoon:after-insert', ->
    initAutoDataSelect2()
    return
  return