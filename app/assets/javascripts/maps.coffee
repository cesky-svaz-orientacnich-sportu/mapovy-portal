jQuery ->
  $('.maps_compare_remove_button').on 'click', ->
    console.dir("hoho")
    $(this).closest('.map-item').fadeOut()