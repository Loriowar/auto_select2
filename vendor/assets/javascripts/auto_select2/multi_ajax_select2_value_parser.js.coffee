jQuery ($) ->
# Tune input fields before submitting form, change csv values into input elements with array names
  $(document).on 'submit', 'form', ->
    $form = $(@)
    $form.find('input.auto-ajax-select2.multiple:enabled').each ->
      $multi = $(@)
      data = $multi.select2('data')
      name = $multi.attr('name')
      $multi.remove()
      new_name = name
      if !name.endsWith('[]')
        new_name = "#{name}[]"
      if data.length == 0
        # Create hidden field with blank value for detect clean select2 on server side
        $form.append $('<input/>', type: 'hidden', name: new_name, value: '')
      else
        # Create hidden fields with array-like names
        for item in data
          $form.append $('<input/>', type: 'hidden', name: new_name, value: item.id)
      return
    return
  return