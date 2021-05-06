App.MapHelper = App.newClass({

    constructor: function (state, map, toc, search, ftLayer1, ftLayer2) {
        this.state = state;
        this.map = map;
        this.toc = toc;
        this.search = search;
        this.ftLayer1 = ftLayer1;
        this.ftLayer2 = ftLayer2;
    },

    listeners: [],

    ftHighlightLayer: null,

    registerMapClickListeners: function (callBack) {
        this.listeners.push(google.maps.event.addListener(this.map, 'click', callBack));
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
        this.ftLayer1.where = select1.where;
        this.ftLayer1.show();
      } else {
        this.ftLayer2.hide();
      }

      if (this.state.lastSelect2) {
        var select2 = {
          select: ['shape_json'],
          where: this.state.lastSelect2.where
        };
        this.ftLayer2.where = select2.where;
        this.ftLayer2.show();
      } else {
        this.ftLayer2.hide();
      }

      $(".map-controls").hide();
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

        this.ftHighlightLayer = new WMSLayer({
            layer: 'highlight',
            where: 'id = ' + id,
            suppressInfoWindows: true,
            map: map,
            index: 4
        });
        this.ftHighlightLayer.show();
    },

    clearHighlight: function () {
        if (this.ftHighlightLayer !== null) {
            this.ftHighlightLayer.hide();
        }
    }

});
