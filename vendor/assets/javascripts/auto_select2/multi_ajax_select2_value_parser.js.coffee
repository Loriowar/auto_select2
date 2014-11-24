jQuery ($) ->
  # Tune input fields before submitting form, change csv values into input elements with array names
  $('input.auto-ajax-select2.multiple').closest('form').submit ->
    $form = $(@) # save a reference to the form for later usage
    $('input.auto-ajax-select2.multiple').each ->
      $multi = $(@)
      data = $multi.select2('data')
      name = $multi.attr('name')
      $multi.remove()
      # Create hidden fields with array like names
      $form.append $.map(data, (obj)->
        $('<input/>', type: 'hidden', name: "#{name}[]", value: obj.id)
      )
      return
    return
  return