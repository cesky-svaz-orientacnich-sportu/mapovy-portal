jQuery ->

  $('#advanced_search_gps_button').on 'click', ->
    searchAdvanced.userGpsCoords()

  $('.map-controls-background-switch button').on 'click', (e) ->
    e.preventDefault()
    mapHelper.changeMapType($(this).data('map-type'))

  $('.map-controls-header').on 'click', ->
    if $(this).attr('aria-expanded') == 'true' then toc.collapse() else toc.expand()

  $('.map-cancel-search, .search-result-hide').on 'click', ->
    sidebar.hideResults()

  $('#map_tool_print_button').on 'click', ->
    mapLink.print()

  $('#map_tool_url_button').on 'click', ->
    mapLink.show()

  $('#map_tool_measure_button').on 'click', ->
    mapHelper.unregisterMapClickListeners()
    measure.init()

  $('#map_tool_help_button').on 'click', ->
    sidebar.reset()
    sidebar.show()
    toc.refresh(true)
    searchAdvanced.clearOverlays();

  $('#tools_link_close_button').on 'click', ->
    mapLink.hide()

  $('#tools_link_update_button').on 'click', ->
    mapLink.update()

  $('#tools_measure_clear_button').on 'click', ->
    measure.clear()

  $('#tools_measure_reset_button').on 'click', ->
    measure.reset()
