jQuery ($) ->
  window.initAutoDataSelect2 = ->
    $('input.auto-data-select2').not('.select2-offscreen').each ->
      $input = $(this)
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


  $body = $('body')
  $body.on 'ajaxSuccess', ->
    initAutoDataSelect2()
    return

  $body.on 'cocoon:after-insert', ->
    initAutoDataSelect2()
    return
  return