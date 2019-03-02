App.Search.Advanced = App.newClass({

    constructor: function (state, ftLayer1, ftLayer2, ftLayerId, apiKey, resultsCallback, sidebar, resourceString) {
        App.Search.call(this, state, ftLayerId, apiKey, resultsCallback, sidebar);

        this.ftLayer1 = ftLayer1;
        this.ftLayer2 = ftLayer2;
        this.resourceString = resourceString;

        this.init();
    },

    Extends: App.Search,

    show: function () {
        $("#advaSearch").slideDown("fast", function () {
            //resize();
            //google.maps.event.trigger(map, 'resize');
        });

        $(".linkAdvSearch").hide();
        $("#formSearch .submitWrapper").addClass("disabled");
        $('.inputtext :input').attr('disabled', true);
        $('.searchSubmit').removeAttr('onclick');
    },

    hide: function () {
        $("#advaSearch").slideUp("medium", function () {
            //resize();
        });

        $(".linkAdvSearch").show();
        $("#formSearch .submitWrapper").removeClass("disabled");
        $('.inputtext :input').removeAttr('disabled');
        $('.searchSubmit').attr('onclick', 'searchSimple.search()');
    },

    search: function () {
        //linkAdvSearchHide();
        //document.getElementById('infoGPS').innerHTML = '';

        var name = $('#advancedSearchName').val();
        var yearFrom = $('#advancedSearchYearFrom').val();
        var yearTo = $('#advancedSearchYearTo').val();
        var sport = $('#advancedSearchMapSport').val();
        var scale = $('#advancedSearchScale').val();
        var club = $('#advancedSearchClub').val();
        var author = $('#advancedSearchAuthor').val();
        var gps = $('#advancedSearchGPS').val();
        var place = $('#advancedSearchPlace').val();
        var distance = $('#advancedSearchDistance').val();

        var query_parts = [];
        var errors = [];

        if (place) {
            gps = geocodeAddress(place);
            return;
        }

        if (gps) {
            var position = gps.split(",");
            this.center = new google.maps.LatLng(position[0], position[1]);
            distance = distance > 0 ? distance * 1000 : 5000;
            var gps_ok = true;
            if (position.length != 2) {
              errors.push("souřadnice mají špatný formát -- správný je \"z.š., z.d.\"");
              gps_ok = false;              
            }
            if (distance > 30000) {
              errors.push("maximální poloměr je 30 km");
              gps_ok = false;
            }
            if (this.center.lng() < 12.0) {
              errors.push("zeměpisná délka je mimo území ČR");
              gps_ok = false;
            }
            if (this.center.lng() > 18.9) {
              errors.push("zeměpisná délka je mimo území ČR");
              gps_ok = false;
            }
            if (this.center.lat() < 48.5) {
              errors.push("zeměpisná šířka je mimo území ČR");
              gps_ok = false;
            }
            if (this.center.lat() > 51.1) {
              errors.push("zeměpisná šířka je mimo území ČR");
              gps_ok = false;
            }
            if (gps_ok) {
              query_parts.push("ST_INTERSECTS(geometry, CIRCLE(LATLNG(" + this.center.lat() + ", " + this.center.lng() + "), " + distance + "))");
              this.clearOverlays();
              var distanceOptions = {
                  strokeColor: "#FF0000",
                  strokeOpacity: 0.8,
                  strokeWeight: 2,
                  fillColor: "#FF0000",
                  fillOpacity: 0.15,
                  map: map,
                  center: this.center,
                  radius: distance
              };
              this.circleOverlay = new google.maps.Circle(distanceOptions);
              this.circleOverlay.setMap(map);

              this.markerOverlay = new google.maps.Marker({
                  position: this.center,
                  title: ""
              });
              this.markerOverlay.setMap(map);              
              console.log("Drawing marker");
            }
        }

        if (name) {
            query_parts.push("NAZEV CONTAINS IGNORING CASE '" + name + "'");
        }

        if (scale) {
            query_parts.push("MERITKO = " + scale);
        }

        if (club) {
            query_parts.push("PATRON CONTAINS IGNORING CASE '" + club + "'");
        }

        if (author) {
            query_parts.push("AUTHORS CONTAINS IGNORING CASE '" + author + "]'");
        }

        if (sport) {
            query_parts.push("MAP_SPORT = '" + sport + "'");
        }

        if (yearFrom != '') {
            query_parts.push("ROK >= '" + yearFrom + "'");
        }

        if (yearTo != '') {
            query_parts.push("ROK <= '" + yearTo + "'");
        }
        
        if (errors.length > 0) {
          alert(this.resourceString.advancedSearchInvalid + errors.join(", "));
        } else {
          if (query_parts.length > 0) {
            this.hide();
        
            var filter = query_parts.join(' AND ');
            this.searchByFilter(filter);          
          } else {
            alert(this.resourceString.advancedSearchEmpty);
          }          
        }
    },

    init: function () {
        $(".linkAdvSearch, .menuAdvanced").click(this.show);
        this.initAutocomplete();
    },

    initAutocomplete: function () {
        $.ajax({
            url: 'https://www.googleapis.com/fusiontables/v1/query?key=' + this.apiKey + '&sql=' +
                    encodeURIComponent('SELECT NAZEV, COUNT() FROM ' + this.ftLayerId + ' GROUP BY NAZEV'),
            dataType: 'json',
            jsonp: 'jsonCallback',//
            success: function (table) {
                var rows = table.rows.length;
                var cols = table.columns.length;
                // Create the list of results for display of autocomplete
                results = [];
                for (i = 0; i < rows; i++) {
                    results.push(table.rows[i][0]);
                }

                // Use the results to create the autocomplete options
                $("#advancedSearchName").autocomplete({
                    source: function(request, response) {
                        var filtered_results = $.ui.autocomplete.filter(results, request.term);        
                        response(filtered_results.slice(0, 20));
                    },
                    minLength: 2
                });

            }
        });

        // // anonymous function for setting maximum items as a result of autocomplete
        // $.ui.autocomplete.prototype._renderMenu = function (ul, items) {
        //     var self = this;
        //     $.each(items, function (index, item) {
        //         if (index < 20) // here we define how many results to show
        //         { self._renderItem(ul, item); }
        //     });
        // }
    },

    clearOverlays: function () {
        if (this.markerOverlay) {
            console.log("Clearing marker");
            this.markerOverlay.setMap(null);
        }

        if (this.circleOverlay) {
            this.circleOverlay.setMap(null);
        }
    },

    userGpsCoords: function () {
        //$('#infoGPS').show();
        this.clearOverlays();
        $('#advancedSearchGPS').val(this.resourceString.gpsTooltip);

        this.ftLayer1.setOptions({
            suppressInfoWindows: true
        });

        var this_ = this;

        var mapClickListener = google.maps.event.addListener(
            map,
            'click',
            function (event) {

                this_.clearOverlays();

                this_.markerOverlay = new google.maps.Marker({
                    position: event.latLng,
                    title: ""
                });
                this_.markerOverlay.setMap(map);
                console.log("Drawing marker");

                $('#advancedSearchGPS').val(event.latLng.lat() + "," + event.latLng.lng());
                $('#infoGPS').hide();
                //$('#infoWinGPS').html(event.latLng);
                this_.center = event.latLng;

                google.maps.event.removeListener(mapClickListener);
                google.maps.event.removeListener(ftLayerClickListener);

                this_.ftLayer1.setOptions({
                    suppressInfoWindows: false
                });
            }
        );

        var ftLayerClickListener = google.maps.event.addListener(
            this.ftLayer1,
            'click',
            function (event) {

                this_.clearOverlays();

                this_.markerOverlay = new google.maps.Marker({
                    position: event.latLng,
                    title: ""
                });
                this_.markerOverlay.setMap(map);
                console.log("Drawing marker");

                $('#advancedSearchGPS').val(event.latLng);
                $('#infoGPS').hide();
                //$('#infoWinGPS').html(event.latLng);
                this_.center = event.latLng;

                google.maps.event.removeListener(mapClickListener);
                google.maps.event.removeListener(ftLayerClickListener);

                this_.ftLayer1.setOptions({
                    suppressInfoWindows: false
                });
            }
        );
    }
});