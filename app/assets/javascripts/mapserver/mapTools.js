function zoom2one(mapId) {
    // zoom and center map on query results
    var query = "SELECT geometry FROM " + Config.ftLayerId + " WHERE ID = " + mapId;
    var queryText = encodeURIComponent(query);
    var query = new google.visualization.Query('https://www.google.com/fusiontables/gvizdata?tq=' + queryText);
    query.send(zoomTo);
}

function zoom2query(query) {
    // zoom and center map on query results
    // set the callback function
    $.ajax({
      url: 'https://www.googleapis.com/fusiontables/v1/query?key=' + Config.apiKey + '&sql=' + encodeURIComponent(query),
      dataType: 'jsonp',
      jsonp: 'jsonCallback',
      success: zoom2queryResp
      //error: handleFtError
    });
}

function zoom2queryResp(json) {
    var numRows = json.table.rows.length;
    var numCols = json.table.cols.length;
    var coordinates = [];

    for(i = 0; i < numRows; i++) {
      if (json.table.rows[i][0] !== '' ) {
        var shape = json.table.rows[i][0];
        for (var j = 0; j < shape.coordinates[0].length; j++) {
          var lng = json.table.rows[i][0].coordinates[0][j][0];
          var lat = json.table.rows[i][0].coordinates[0][j][1];
          coordinates.push(new google.maps.LatLng(lat, lng));
        }
      }
    }

    var bounds = new google.maps.LatLngBounds();
    for (var i = 0; i < coordinates.length; i++) {
      bounds.extend(coordinates[i]);
    }
    google.maps.event.trigger(map, 'resize');
    if (coordinates.length > 0) map.fitBounds(bounds);
    var zoomLevel = map.getZoom();
    map.setZoom(zoomLevel);
}

// Function using GeoXML library for zooming to the feature
function zoomTo(response) {
    if (!response) {
        alert('no response');
        return;
    }
    if (response.isError()) {
        alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
        return;
    }
    fTresponse = response;
    //for more information on the response object, see the documentation
    //http://code.google.com/apis/visualization/documentation/reference.html#QueryResponse
    numRows = response.getDataTable().getNumberOfRows();
    numCols = response.getDataTable().getNumberOfColumns();
    if (numRows == 0) {
      window.alert("Mapa s tímto ID neexistuje");
    }
    if (numRows == 1) {
      var kml = fTresponse.getDataTable().getValue(0, 0);
      var kmlString = "<Placemark>" + kml + "</Placemark>";
    }
    if (numRows > 1) {
      var count = numRows - 1;
      for (i = 0; i <= count; i++) {
        var kml = fTresponse.getDataTable().getValue(i, 0);
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