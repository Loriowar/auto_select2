jQuery ($) ->
  format = (item)->
    result = item.text
    if item.class_name != undefined
      result = '<span class="'+item.class_name+'">'+item.text+'</span>'
    result
  window.initAutoAjaxSelect2 = ->
    $inputs = $('input.auto-ajax-select2').not('.select2-offscreen')
    $inputs.each ->
      $input = $(this)
      path = $input.data('href')
      limit = $input.data('limit') || 25
      s2DefaultOptions = {
        allowClear: true
        multiple: false
        formatSelection: format
        formatResult: format
        ajax: {
          url: path,
          dataType: 'json',
          data: (term, page) ->
            ajaxData = { term: term, page: page }
            $this = $(this.context)

            additionalUserData = $this.data('s2options')
            paramsCollection = {}
            if additionalUserData isnt `undefined`
              additionalAjaxData = additionalUserData['additional_ajax_data']
              if additionalAjaxData isnt `undefined`
                $(additionalAjaxData['selector']).each (index, el) ->
                  $el = $(el)
                  paramsCollection[$el.attr('name')] = $el.val()
                  return
                delete paramsCollection[$this.attr('name')]

            return $.extend({}, paramsCollection, ajaxData)
          ,
          results: (data, page) ->
            more = (page * limit) < data.total
            return { results: data.items, more: more }
        },
        initSelection : (element, callback) ->
          $element = $(element)
          id = $element.val()
          initText = $element.data('init-text')
          initClassName = $element.data('init-class-name')
          if (id != '')
            if initText != undefined
              params = { id: id, text: initText }
              if initClassName != undefined
                params.class_name = initClassName
              callback(params)
            else
              $.ajax(path, {
                data: { init: true, item_ids: id },
                dataType: "json"
              }).done((data) ->
                if(data != null)
                  callback(data)
                else
                  $element.val('')
                  callback({ id: '', text: '' })
              )
      }

      s2UserOptions = $input.data("s2options")

      if s2UserOptions is `undefined`
        s2FullOptions = $.extend({}, s2DefaultOptions)
      else
        s2FullOptions = $.extend({}, s2DefaultOptions, s2UserOptions)

      $input.select2(s2FullOptions)

      return
    return
  initAutoAjaxSelect2()

  $body = $('body')
  $body.on 'ajaxSuccess', ->
    initAutoAjaxSelect2()
    return

  $body.on 'cocoon:after-insert', ->
    initAutoAjaxSelect2()
    return
  return
