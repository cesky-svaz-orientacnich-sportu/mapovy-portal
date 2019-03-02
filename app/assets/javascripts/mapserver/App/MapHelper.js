App.MapHelper = App.newClass({

    constructor: function (state, map, toc, search, ftLayer1, ftLayer2, ftHighlightLayerId) {
        this.state = state;
        this.map = map;
        this.toc = toc;
        this.search = search;
        this.ftLayer1 = ftLayer1;
        this.ftLayer2 = ftLayer2;
        this.ftHighlightLayerId = ftHighlightLayerId;
    },

    listeners: [],

    ftHighlightLayer: null,

    registerMapClickListeners: function (callBack) {
        this.listeners.push(google.maps.event.addListener(this.map, 'click', callBack));
        this.listeners.push(google.maps.event.addListener(this.ftLayer1, 'click', callBack));
        this.listeners.push(google.maps.event.addListener(this.ftLayer2, 'click', callBack));
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
        var from1   = this.state.lastSelect1.substring(this.state.lastSelect1.indexOf(' FROM'));
        var select1 = 'SELECT geometry ' + from1;
        var where1  = this.state.lastSelect1.substring(this.state.lastSelect1.indexOf('WHERE') + 6);

        this.ftLayer1.query.where = where1;
        this.ftLayer1.setMap(this.map);
      } else {
        this.ftLayer2.setMap(null);
      }

      if (this.state.lastSelect2) {
        var from2   = this.state.lastSelect2.substring(this.state.lastSelect2.indexOf(' FROM'));
        var select2 = 'SELECT geometry ' + from2;
        var where2  = this.state.lastSelect2.substring(this.state.lastSelect2.indexOf('WHERE') + 6);

        this.ftLayer2.query.where = where2;
        this.ftLayer2.setMap(this.map);
      } else {
        this.ftLayer2.setMap(null);
      }

      $("#toc").hide();
      $("#area_toc").hide();
      $("#cancelSearch").show();

      this.search.searchBySelect(select1, select2, this.zoomToResults, true);
    },

    zoomToResults: function(table) {
        var numRows = table.rows.length;
        var numCols = table.columns.length;

        var coordinates = [];
        for (i = 0; i < numRows; i++) {
            if (table.rows[i][0] !== '') {
              var geometry = table.rows[i][0].geometry;
                for (var j = 0; j < geometry.coordinates[0].length; j++) {
                  var lng = geometry.coordinates[0][j][0];
                  var lat = geometry.coordinates[0][j][1];
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

        this.ftHighlightLayer = new google.maps.FusionTablesLayer({
          query: {
            select: 'geometry',
            from: this.ftHighlightLayerId,
            where: "'ID'= " + id
          },
          options: {
            suppressInfoWindows: true,
            templateId: 2,
            styleId: 2
          }
        });

        this.ftHighlightLayer.setMap(map);
    },

    clearHighlight: function () {
        if (this.ftHighlightLayer) {
            this.ftHighlightLayer.setMap(null);
        }
    }

});