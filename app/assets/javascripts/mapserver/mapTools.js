function zoom2one(mapId) {
    // zoom and center map on query results
    $.ajax({
        url: '/api/select',
        dataType: 'json',
        data: {
            select: ['shape_kml'],
            where: "id = " + mapId
        },
        error: function(jqxhr, status, error) {
            window.alert("Could not zoom : S = " + status + " E = " + error);
        },
        success: function (res) {
            if (res) {
                alert('no response');
            } else if (res.status == 'success') {
                numRows = res.data.length;
                if (numRows == 0) {
                  window.alert("Mapa s tímto ID neexistuje");
                }
                if (numRows == 1) {
                  var kml = res.data[0]['shape_kml'];
                  var kmlString = "<Placemark>" + kml + "</Placemark>";
                }
                if (numRows > 1) {
                  var count = numRows - 1;
                  for (i = 0; i <= count; i++) {
                    var kml = res.data[i]['shape_kml'];
                    kmlString += "<Placemark>" + kml + "</Placemark>";
                  }
                }
                if (kml == '')
                    { window.alert("Omlouváme se, ale tato mapa nedisponuje obrysem"); }
                // create a geoXml3 parser for the click handlers
                var geoXml = new geoXML3.parser({
                    map: map,
                    zoom: false
                });

                geoXml.parseKmlString(kmlString);
                geoXml.docs[0].gpolygons[0].setMap(null);
                google.maps.event.trigger(map, 'resize');
                map.fitBounds(geoXml.docs[0].gpolygons[0].bounds);
                var zoomLevel = map.getZoom();
                map.setZoom(zoomLevel);
            } else {
                window.alert("Could not zoom : S = error E = " + res.message);
            }
        }
    });
}

function executeAdvEnter(e) {
	if (e.keyCode == 13) {
		$('.ui-autocomplete').hide();
	    searchAdvanced.search();
	}
}

function showSelectedItem() {
  for(i = 0; i < queryArr.length; i++){
	  var record = queryArr[i].split("=");
	  var argname = record[0];
    var value = record[1];
    if (argname == 'club' || argname == 'year' || argname == 'author') {
      showSelectedLayer();
    }
  }
}

function geocodeAddress(address) {
  var coords = "";
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      coords = results[0].geometry.location;
      coords = coords.lat()+","+coords.lng();
      $('#advancedSearchGPS').val(coords);
      $('#advancedSearchPlace').val("");
      // searchAdvanced.clearOverlays();
      //   var marker = new google.maps.Marker({
      //     position: coords,
      //     title:""
      //     });
      //   marker.setMap(map);
      //
      searchAdvanced.search();
    } else {
      window.alert("Geocode was not successful for the following reason: " + status);
    }
  });
  return coords;
}

function showLayersFromUrl() {
  if (urlLinkValue) {
    $("div.item").removeClass("active");
    $("input.fitem").attr("checked", false);
    layers = urlLinkValue.split(",");
    for(s = 0; s < layers.length; s++){
      $("input#fitem" + layers[s]).attr("checked", true);
      $("div#item" + layers[s]).addClass("item active");
    }
	  toc.refresh();
  }
}
