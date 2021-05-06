function setupMapEditorSubmit() {

  $('#map_form .submit-btn').click(function() {
    var latlngs = [];
    var area = null;
    if (!polygon || !polygon.getPath()) {
      if (!confirm("Nebyl určen obrys mapy (polygon neexistuje). Chceš záznam přesto uložit?")) {
        return;
      }
    } else {
      var shape = polygon.getPath().getArray();
      latlngs = shape.map(function(x) {
        return([x.lat(), x.lng()]);
      });
      if (latlngs.size < 3) {
        if (!confirm("Nebyl určen obrys mapy (pole bodů je prázdné). Chceš záznam přesto uložit?")) {
          return;
        }
      };
      var area = Math.round(google.maps.geometry.spherical.computeArea(shape)) / 1000000 ;
    }

    $('#map_form').find('.areaField').val(area);
    $('#map_form').find('.shapeField').val(JSON.stringify(latlngs));
    $('#map_form').submit();
  });

}


function setupMap(mapElement, useScrollWheel) {
  if (!mapElement) alert("Map not found!");
  var zoom = Config.mapInitParams.zoom;
  var lat = Config.mapInitParams.lat;
  var lng = Config.mapInitParams.lng;
  var mapTypeId = Config.mapInitParams.mapTypeId;

  var getShcTile = new google.maps.ImageMapType({
    getTileUrl: function (coord, zoom) {
      if(zoom == 8) {
        return Config.assetRoot + "/data/tiles/" + zoom + "/" + coord.y + "/" + coord.x + ".png";
      } else {
        // return "http://ags.cuzk.cz/ArcGIS/rest/services/zmwm/MapServer/tile/" + (zoom - 9) + "/" + coord.y + "/" + coord.x;
        return "https://ags.cuzk.cz/ArcGIS/rest/services/zmwm/MapServer/tile/" + (zoom) + "/" + coord.y + "/" + coord.x;
      }
    },
    tileSize: new google.maps.Size(256, 256),
    isPng: true,
    maxZoom: 17,
    minZoom: 8,
    name: "SHC"
  });

  var myLatlng = new google.maps.LatLng(lat, lng);
  var myOptions = {
      center: myLatlng,
      zoom: zoom,
      overviewMapControl: false,
      scaleControl: true,
      mapTypeControl: false,
      scrollwheel: useScrollWheel,
      fullscreenControl: false,
      streetViewControl: false
  };

  var map = new google.maps.Map(mapElement, myOptions);
  map.mapTypes.set("SHC", getShcTile);
  map.setMapTypeId(mapTypeId);

  map.enableKeyDragZoom({
      key: 'ctrl',
      boxStyle: {
          border: "4px solid #D93C00",
          backgroundColor: "transparent",
          opacity: 1.0
      },
      veilStyle: {
          backgroundColor: "gray",
          opacity: 0.35,
          cursor: "crosshair"
      },
  });

  return map;
}

function setupMapEditor(map) {

  var drawingManager = new google.maps.drawing.DrawingManager({
    drawingMode: google.maps.drawing.OverlayType.POLYGON,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT,
      drawingModes: [
        google.maps.drawing.OverlayType.POLYGON
      ]
    },
    polygonOptions: {
      editable: true
    }
  });

  drawingManager.setMap(map);

  google.maps.event.addListener(drawingManager, 'overlaycomplete', function(e) {
    if (polygon) {
      polygon.setMap(null);
    }
    polygon = e.overlay;
  });

  return drawingManager;
}
