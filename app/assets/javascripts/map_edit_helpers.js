$(function() {
  $('#inlineBaseMapSwitch a').on('click', function() {
    changeInlineMapType($(this).data('map-type'));
  });
});

function changeInlineMapType(mapTypeId) {
    $("#inlineBaseMapSwitch a").removeClass("active");
    $("#inlineBaseMapSwitch a[data-map-type="+mapTypeId+"]").addClass("active");
    if (mapTypeId == 'SHC') {
        map.setMapTypeId('SHC');
    } else {
        map.setMapTypeId(google.maps.MapTypeId[mapTypeId]);
    }
}

function setOrisEvent(year) {
  $.get("/filter_oris_events/" + year).success(function(data){
    $("#map_oris_event_id").html(data);
    $("#map_oris_event_id").select2({allowClear: true});
    $("#map_oris_event_id").prop('disabled', false);
  });
}

function fixMapHeight(element) {
  h = 0.95 * $( window ).height() - 40;
  if (h > 800) h = 800;
  element.height(h);
}

$(function() {
  $("#map_year").on('change propertychange input paste', function() {
    var y = parseInt($("#map_year").val());
    if (y > 2000 && y < 2100) {
      $("#map_oris_event_id").prop('disabled', true);
      setOrisEvent(y);
    }
  });

  $("#map_oris_event_id").on('change propertychange input paste', function() {
    rid = $("#map_oris_event_id").val();
    if (rid && rid != '') {
      $('#map_main_race_title').prop('readonly', true);
      $('#map_main_race_date').prop('readonly', true);
      $('#map_non_oris_event_url').prop('readonly', true);
      if (r = window.race_map[rid]) {
        $('#map_main_race_title').val(r.title);
        $('#map_main_race_date').val(r.date);
        $('#map_non_oris_event_url').val(r.url);
      }
    } else {
      $('#map_main_race_title').prop('readonly', false);
      $('#map_main_race_date').prop('readonly', false);
      $('#map_non_oris_event_url').prop('readonly', false);
    }
  });
});
