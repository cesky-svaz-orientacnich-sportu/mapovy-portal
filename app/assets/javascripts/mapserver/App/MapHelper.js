App.MapHelper = App.newClass({

    constructor: function (state, map, toc, search, wmsLayer) {
        this.state = state;
        this.map = map;
        this.toc = toc;
        this.search = search;
        this.wmsLayer = wmsLayer;
    },

    listeners: [],

    ftHighlightLayer: null,

    registerMapClickListeners: function (callBack) {
        this.listeners.push(google.maps.event.addListener(this.map, 'click', callBack));
        // TODO
        //this.listeners.push(google.maps.event.addListener(this.ftLayer1, 'click', callBack));
        //this.listeners.push(google.maps.event.addListener(this.ftLayer2, 'click', callBack));
    },

    unregisterMapClickListeners: function () {
        for (i = 0; i < this.listeners.length; i++) {
            google.maps.event.removeListener(this.listeners[i]);
        }
    },

    clearListeners: function () {
        this.unregisterMapClickListeners();
        this.listeners = [];
    },

    changeMapType: function (mapTypeId) {
      console.dir(mapTypeId);
        $("#baseMapSwitch a").removeClass("active");
        $("#baseMapSwitch a[data-map-type=" + mapTypeId + "]").addClass("active");
        if (mapTypeId == 'SHC') {
            this.map.setMapTypeId('SHC');
            $('#cuzkCopyright').show();
        }
        else {
            this.map.setMapTypeId(google.maps.MapTypeId[mapTypeId]);
            $('#cuzkCopyright').hide();
        }
    },

    showSelectInMap: function () {
      var select1 = null;
      var select2 = null;

      if (this.state.lastSelect1) {
        var select1 = {
          select: ['shape_json'],
          where: this.state.lastSelect1.where
        };
        this.wmsLayer.where = select1.where;
        this.wmsLayer.layers.maps = true;
      } else {
        this.wmsLayer.layers.maps2 = false;
      }

      if (this.state.lastSelect2) {
        var select2 = {
          select: ['shape_json'],
          where: this.state.lastSelect2.where
        };
        this.wmsLayer.where2 = select2.where;
        this.wmsLayer.layers.maps2 = true;
      } else {
        this.wmsLayer.layers.maps2 = false;
      }

      this.wmsLayer.redraw();

      $("#toc").hide();
      $("#area_toc").hide();
      $("#cancelSearch").show();

      this.search.searchBySelect(select1, select2, this.zoomToResults, true);
    },

    zoomToResults: function(data) {
        var numRows = data.length;

        var coordinates = [];
        for (i = 0; i < numRows; i++) {
            if (data[i]['shape_json'] !== '') {
                var points = JSON.parse(data[i]['shape_json']);
                for (var j = 0; j < points.length; j++) {
                    var lng = points[j][1];
                    var lat = points[j][0];
                    coordinates.push(new google.maps.LatLng(lat, lng));
                }
            }
        }

        var bounds = new google.maps.LatLngBounds();
        for (var i = 0; i < coordinates.length; i++) {
            bounds.extend(coordinates[i]);
        }

        if (coordinates.length > 0)
          map.fitBounds(bounds);
        var zoomLevel = map.getZoom() - 1;
        map.setZoom(zoomLevel);
    },

    highlightMapPolygon: function (id) {
        this.clearHighlight();

        var layer = new google.maps.ImageMapType({
          getTileUrl: function(coord, zoom) {
            var proj = map.getProjection();
            var zfactor = Math.pow(2, zoom);
            // get Long Lat coordinates
            var top = proj.fromPointToLatLng(new google.maps.Point(coord.x * 256 / zfactor, coord.y * 256 / zfactor));
            var bot = proj.fromPointToLatLng(new google.maps.Point((coord.x + 1) * 256 / zfactor, (coord.y + 1) * 256 / zfactor));

            //corrections for the slight shift of the SLP (mapserver)
            var deltaX = 0.0013;
            var deltaY = 0.00058;

            //create the Bounding box string
            var bbox =   (top.lng() + deltaX) + "," +
                         (bot.lat() + deltaY) + "," +
                         (bot.lng() + deltaX) + "," +
                         (top.lat() + deltaY);

            //base WMS URL
            var url = Config.wmsUrl;
            url += '?SERVICE=WMS';
            url += '&VERSION=1.3.0';
            url += '&REQUEST=GetMap';
            url += '&FORMAT=image/png';
            url += '&TRANSPARENT=true';
            url += '&LAYERS=highlight';
            url += '&CRS=EPSG:3857';
            url += '&STYLES=';
            url += '&WIDTH=256';
            url += '&HEIGHT=256';
            url += '&BBOX='+ bbox;
            url += '&whereH='+ encodeURIComponent("id = " + id);
            return url;
          },
          tileSize: new google.maps.Size(256, 256),
          isPng: true
        });

        this.ftHighlightLayer = map.overlayMapTypes.setAt(14, layer);
    },

    clearHighlight: function () {
        if (this.ftHighlightLayer !== null) {
            map.overlayMapTypes.removeAt(14);
        }
    }

});