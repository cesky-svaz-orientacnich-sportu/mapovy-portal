App.Measure = App.newClass({

    constructor: function (map, ftLayer) {
        this.map = map;
        this.ftLayer = ftLayer;
    },

    mvcLine: new google.maps.MVCArray(),

    mvcPolygon: new google.maps.MVCArray(),

    mvcMarkers: new google.maps.MVCArray(),

    line: null,

    polygon: null,

    listeners: {
        MeasureOnMap: null,
        MeasureOnFtLayer: null,
        Marker1: null,
        Marker2: null,
        Marker3: null,
        Marker4: null
    },

    init: function () {
        $('#showMeasure').show();
        this.map.setOptions({ draggableCursor: 'crosshair' });

        this.ftLayer.setOptions({
            suppressInfoWindows: true
        });

        var this_ = this;
        this.listeners.MeasureOnMap = google.maps.event.addListener(this.map, "click", function (event) { this_.add(event.latLng); });
        this.listeners.MeasureOnFtLayer = google.maps.event.addListener(this.ftLayer, "click", function (event) { this_.add(event.latLng); });
    },

    add: function (latLng) {
        // Add a draggable marker to the map where the user clicked
        var marker = new google.maps.Marker({
            map: this.map,
            position: latLng,
            draggable: true,
            raiseOnDrag: false,
            title: "Drag me to change shape",
            icon: new google.maps.MarkerImage("../img/measure-vertex.png", new google.maps.Size(9, 9), new google.maps.Point(0, 0), new google.maps.Point(5, 5))
        });

        // Add this LatLng to our line and polygon MVCArrays
        // Objects added to these MVCArrays automatically update the line and polygon shapes on the map
        this.mvcLine.push(latLng);
        this.mvcPolygon.push(latLng);

        // Push this marker to an MVCArray
        // This way later we can loop through the array and remove them when measuring is done
        this.mvcMarkers.push(marker);

        // Get the index position of the LatLng we just pushed into the MVCArray
        // We'll need this later to update the MVCArray if the user moves the measure vertexes
        var latLngIndex = this.mvcLine.getLength() - 1;

        // When the user mouses over the measure vertex markers, change shape and color to make it obvious they can be moved
        this.listeners.Marker1 = google.maps.event.addListener(marker, "mouseover", function () {
            marker.setIcon(new google.maps.MarkerImage("../img/measure-vertex-hover.png", new google.maps.Size(15, 15), new google.maps.Point(0, 0), new google.maps.Point(8, 8)));
        });

        // Change back to the default marker when the user mouses out
        this.listeners.Marker2 = google.maps.event.addListener(marker, "mouseout", function () {
            marker.setIcon(new google.maps.MarkerImage("../img/measure-vertex.png", new google.maps.Size(9, 9), new google.maps.Point(0, 0), new google.maps.Point(5, 5)));
        });

        // When the measure vertex markers are dragged, update the geometry of the line and polygon by resetting the
        //     LatLng at this position
        this.listeners.Marker3 = google.maps.event.addListener(marker, "drag", function (evt) {
            measure.mvcLine.setAt(latLngIndex, evt.latLng);
            measure.mvcPolygon.setAt(latLngIndex, evt.latLng);
        });

        // When dragging has ended and there is more than one vertex, measure length, area.
        this.listeners.Marker4 = google.maps.event.addListener(marker, "dragend", function () {
            if (measure.mvcLine.getLength() > 1) {
                measure.calc();
            }
        });

        // If there is more than one vertex on the line
        if (this.mvcLine.getLength() > 1) {

            // If the line hasn't been created yet
            if (!this.line) {

                // Create the line (google.maps.Polyline)
                this.line = new google.maps.Polyline({
                    map: this.map,
                    clickable: false,
                    strokeColor: "#FF0000",
                    strokeOpacity: 1,
                    strokeWeight: 3,
                    path: this.mvcLine
                });

            }

            // If there is more than two vertexes for a polygon
            if (this.mvcPolygon.getLength() > 2) {

                // If the polygon hasn't been created yet
                if (!this.polygon) {

                    // Create the polygon (google.maps.Polygon)
                    this.polygon = new google.maps.Polygon({
                        clickable: false,
                        map: this.map,
                        fillOpacity: 0.25,
                        strokeOpacity: 0,
                        paths: this.mvcPolygon
                    });

                }

            }

        }

        // If there's more than one vertex, measure length, area.
        if (this.mvcLine.getLength() > 1) {
            this.calc();
        }

    },

    calc: function () {
        // Use the Google Maps geometry library to measure the length of the line
        var length = google.maps.geometry.spherical.computeLength(this.line.getPath());
        length = length / 1000;
        jQuery("#span-length").text(length.toFixed(2))

        // If we have a polygon (>2 vertexes inthe mvcPolygon MVCArray)
        if (this.mvcPolygon.getLength() > 2) {
            // Use the Google Maps geometry library tomeasure the area of the polygon
            var area = google.maps.geometry.spherical.computeArea(this.polygon.getPath());
            area = area / 1000000;
            jQuery("#span-area").text(area.toFixed(2));
        }

    },

    reset: function () {

        // If we have a polygon or a line, remove them from the map and set null
        if (this.polygon) {
            this.polygon.setMap(null);
            this.polygon = null;
        }
        if (this.line) {
            this.line.setMap(null);
            this.line = null
        }

        // Empty the mvcLine and mvcPolygon MVCArrays
        this.mvcLine.clear();
        this.mvcPolygon.clear();

        // Loop through the markers MVCArray and remove each from the map, then empty it
        this.mvcMarkers.forEach(function (elem, index) {
            elem.setMap(null);
        });
        this.mvcMarkers.clear();
        jQuery("#span-length,#span-area").text(0);

    },

    clear: function () {
        this.ftLayer.setOptions({
            suppressInfoWindows: false
        });

        this.reset();
        this.map.setOptions({ draggableCursor: 'url(https://maps.gstatic.com/mapfiles/openhand_8_8.cur),default' });
        google.maps.event.removeListener(this.listeners.MeasureOnMap);
        google.maps.event.removeListener(this.listeners.MeasureOnFtLayer);
        google.maps.event.removeListener(this.listeners.Marker1);
        google.maps.event.removeListener(this.listeners.Marker2);
        google.maps.event.removeListener(this.listeners.Marker3);
        google.maps.event.removeListener(this.listeners.Marker4);
        $('#showMeasure').hide();
    }

});