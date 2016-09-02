jQuery ($) ->
  window.initAutoStaticSelect2 = ->
    $("select.auto-static-select2").not(".select2-offscreen").each (index, el) ->
      $el = $(el)
      s2UserOptions = $el.data("s2options")

      s2DefaultOptions =
        allowClear: true
        width: "resolve"

      if s2UserOptions is `undefined`
        s2FullOptions = $.extend({}, s2DefaultOptions)
      else
        s2FullOptions = $.extend({}, s2DefaultOptions, s2UserOptions)

      $el.select2(s2FullOptions)

      return
    return
  initAutoStaticSelect2()

  $document = $(document)
  $document.on 'ajaxSuccess', ->
    initAutoStaticSelect2()
    return

  $document.on 'cocoon:after-insert', ->
    initAutoStaticSelect2()
    return
  return