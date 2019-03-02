App.Search = App.newClass({

    constructor: function (state, ftLayerId, apiKey, resultsCallback, sidebar) {
        this.state = state;
        this.ftLayerId = ftLayerId;
        this.apiKey = apiKey;
        this.resultsCallback = resultsCallback;
        this.sidebar = sidebar;
    },

    searchByName: function (name, callback) {
        var name = name.replace(/'/g, "\\\'");
        var filter = "NAZEV CONTAINS IGNORING CASE '" + name + "' ";

        this.searchByFilter(filter, callback);
    },

    searchByLatLng: function (latLng, callback) {
        var filter = "ST_INTERSECTS(geometry, RECTANGLE(LATLNG" + latLng + ", LATLNG" + latLng + ")) ";
        this.searchByFilter(filter, callback);
    },

    searchByFilter: function (filter, callback) {
      var filter1 = null;
      var filter2 = null;
      // visibility
      if (Config.user && (Config.user.role == 'admin' || Config.user.role == 'manager' || Config.user.role == 'cartographer')) {
        filter1 = filter + " AND " + Config.fullStateQuery;
      } else {
        if (Config.user) {
          filter2 = filter + " AND CREATED_BY_ID = " + Config.user.id;
        }
        filter1 = filter + " AND " + Config.stateQuery;
      }
      var select1 = 'SELECT ID, NAZEV, PATRON, ROK, MERITKO, OBRAZ, MAP_SPORT, MAP_FAMILY, hasJPG, hasKML, hasBLOCKING, hasEMBARGO, BLOCKING_FROM, BLOCKING_UNTIL, EMBARGO_UNTIL FROM ' + this.ftLayerId + ' WHERE ' + filter1 + ' ORDER BY ROK DESC';
      var select2 = null;
      if (filter2) {
        select2 = 'SELECT ID, NAZEV, PATRON, ROK, MERITKO, OBRAZ, MAP_SPORT, MAP_FAMILY, hasJPG, hasKML, hasBLOCKING, hasEMBARGO, BLOCKING_FROM, BLOCKING_UNTIL, EMBARGO_UNTIL FROM ' + this.ftLayerId + ' WHERE ' + filter2 + ' ORDER BY ROK DESC';
      }
      console.log("Search by filter: " + select1 + " || " + select2);
      this.searchBySelect(select1, select2, callback);          
    },

    searchBySelect: function (select1, select2, callback, notShowWaiting) {
        if (!callback) {
            callback = this.resultsCallback;
        }

        this.state.lastSelect1 = select1;
        this.state.lastSelect2 = select2;

        if (!notShowWaiting) {
            this.sidebar.showWaiting();
        }
        
        var url1 = null;
        var url2 = null;

        url1 = 'https://www.googleapis.com/fusiontables/v1/query?key=' + this.apiKey + '&sql=' + encodeURIComponent(select1);
        if (select2) {
          url2 = 'https://www.googleapis.com/fusiontables/v1/query?key=' + this.apiKey + '&sql=' + encodeURIComponent(select2);          
        }

        $.ajax({
            url: url1,
            dataType: 'json',
            success: function(data) {
              if (url2) {
                $.ajax({
                  url: url2,
                  dataType: 'json',
                  success: function(data) {
                    callback(data, true);
                  },
                    error: function(xhr, status, error) { 
                    alert('search error? S = ' + status + " E = " + error + " -- the request was " + select2); 
                    App.sidebar.hideWaiting();
                  }
                });                
              } else {
                callback(data, false);
              }
            },
            error: function(xhr, status, error) { 
              alert('search error? S = ' + status + " E = " + error + " -- the request was " + select1); 
              App.sidebar.hideWaiting();
            }
        });

    }

});