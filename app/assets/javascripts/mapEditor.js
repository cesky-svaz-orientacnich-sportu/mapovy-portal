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
      if (zoom == 8) {
        return Config.assetRoot + "/data/tiles/" + zoom + "/" + coord.y + "/" + coord.x + ".png";
      } else {
        return "https://ags.cuzk.cz/arcgis1/rest/services/ZTM_WM/MapServer/tile/" + (zoom) + "/" + coord.y + "/" + coord.x;
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
          border: "4px solid #fe5900",
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

const setupGPXImport = (map) => {
  const readFile = file => new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => {
      resolve(reader.result)
    }
    reader.onerror = reject
    reader.readAsText(file)
  })

  const $button = document.createElement('button')
  const $label = document.createElement('label')
  const $input = document.createElement('input')

  $button.classList.add('btn', 'btn-primary')
  $button.setAttribute('type', 'button')
  $button.setAttribute('style', 'margin-top:4px;margin-bottom:16px')
  $button.innerHTML = 'Nahrát obrys z GPX'
  $button.addEventListener('click', e => {
    e.preventDefault()
    $input.click()
  })

  $label.setAttribute('for', 'map-editor-gpx-import')
  $label.classList.add('sr-only')
  $label.innerHTML = 'GPX obrysu mapy'

  $input.classList.add('sr-only')
  $input.setAttribute('id', 'map-editor-gpx-import')
  $input.setAttribute('type', 'file')
  $input.setAttribute('accept', '.gpx')
  $input.addEventListener('change', async e => {
    const $loading = document.createElement('div')
    $loading.classList.add('loading')
    $loading.innerHTML =
      '<svg width="24" height="24" viewBox="0 0 24 24" aria-hidden="true"><rect x="0" y="0" width="24" height="24" fill="none" stroke="none" /><path fill="currentColor" d="m7 17l3.2-6.8L17 7l-3.2 6.8L7 17m5-5.9a.9.9 0 0 0-.9.9a.9.9 0 0 0 .9.9a.9.9 0 0 0 .9-.9a.9.9 0 0 0-.9-.9M12 2a10 10 0 0 1 10 10a10 10 0 0 1-10 10A10 10 0 0 1 2 12A10 10 0 0 1 12 2m0 2a8 8 0 0 0-8 8a8 8 0 0 0 8 8a8 8 0 0 0 8-8a8 8 0 0 0-8-8Z"/></svg>'+
      '<p class="sr-only">Načítám</p>'
    $button.append($loading)
    const $mapLoading = $loading.cloneNode(true)
    map.getDiv().append($mapLoading)

    if (e.target && e.target.files) {
      const gpx = await readFile(e.target.files[0])

	  polygon.setMap(null) // remove old polygon

	  const points = []
      for (const line of gpx.split('\n')) {
        const coords = line.match(/lat="([0-9.]+)".+lon="([0-9.]+)"/)
        if (coords) {
          points.push(new google.maps.LatLng(parseFloat(coords[1]), parseFloat(coords[2])))
        }
      }
      if (points.length) {
        polygon = new google.maps.Polygon({
          paths: points,
          editable: true
        })
        polygon.setMap(map)

        const bounds = new google.maps.LatLngBounds()
        for (const point of points) {
          bounds.extend(point)
        }
        map.fitBounds(bounds)
      }
      $loading.remove()
      $mapLoading.remove()
    }
  })

  map.getDiv().before($button, $label, $input)
}

function setupMapEditor(map) {
  const drawingManager = new google.maps.drawing.DrawingManager({
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
  })

  drawingManager.setMap(map)

  google.maps.event.addListener(drawingManager, 'overlaycomplete', e => {
    if (polygon) {
      polygon.setMap(null)
    }
    polygon = e.overlay
  })

  setupGPXImport(map)

  return drawingManager
}
