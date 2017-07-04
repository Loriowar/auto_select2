jQuery ($) ->
  window.initAutoCustomSelect2 = ->
    $('input.auto-custom-select2').each ->
      $input = $(this)
      return if $input.data('select2')

      s2Options = $input.data("s2-options")
      if s2Options != undefined
        $input.select2(s2Options)
      return
    return

  initAutoCustomSelect2()

  return