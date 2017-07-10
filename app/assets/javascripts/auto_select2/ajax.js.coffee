jQuery ($) ->
  initAutoSelect2Ajax = ->
    $('select.auto-select2-ajax').each ->
      $input = $(this)
      return if $input.data('select2')

      options = $input.data('auto-select2')
      href = options.href
      delete options.href
      extra = options.extra || {}
      delete options.extra

      defaultOptions =
        allowClear: true
        multiple: false
        ajax:
          url: href
          data: (params) ->
            $.extend({}, extra, term: params.term, page: params.page)
          dataType: 'json'
          delay: 250
          cache: true

      $input.select2($.extend({}, defaultOptions, options))

      return
    return

  initAutoSelect2Ajax()

  $document = $(document)
  $document.on 'ajaxSuccess', ->
    initAutoSelect2Ajax()
    return

  $document.on 'init_reqired.auto_select2', ->
    initAutoSelect2Ajax()
    return
  return
