App.Toc = App.newClass({

    constructor: function (map, wmsLayer) {
        this.map = map;
        this.wmsLayer = wmsLayer;
    },

    refresh: function () {

        $("#toc .options .item").removeClass("active");
        
        var visibleFamilies = [];
        var visibleSports = [];
        var minYear = 9999;
        var maxYear = -9999;
        
        $("#toc .options input").each(function(i) {
          if ($(this).prop('checked')) {
            $(this).parent().addClass('active');
            col = $(this).attr('data-filter-column');
            if (col == 'MAP_FAMILY') {
              visibleFamilies.push("'" + $(this).attr('data-filter-value') + "'");
            }
            if (col == 'MAP_SPORT') {
              visibleSports.push("'" + $(this).attr('data-filter-value') + "'");
            }
            if (col == 'ROK') {
              min = $(this).attr('data-filter-value1');
              max = $(this).attr('data-filter-value2');
              if (min < minYear) minYear = min;
              if (max > maxYear) maxYear = max;
            }
          }
          if ($(this).attr('data-filter-value') == 'attribute') {
            if ($(this).prop('checked')) {
              // attrs.push("AND " + $(this).attr('data-filter-column') + " IS NOT NULL");
              //attrs.push("AND " + $(this).attr('data-filter-column') + " = 1");              
            } else {
              attrs.push("AND ((" + $(this).attr('data-filter-column') + " != 1))");
            }
          }
        });
              
        this.wmsLayer.layers.maps = false;
        this.wmsLayer.layers.maps2 = false;
        this.wmsLayer.layers.embargoes = false;
        this.wmsLayer.layers.blocking = false;
        this.wmsLayer.redraw();
        
        var attrs = [];
        
        var where1 = "";
        var where2 = null;
        if ((visibleFamilies.length > 0) && (visibleSports.length > 0) && (minYear <= maxYear)) {
            where = 'map_family IN (' + visibleFamilies.join(',') + ') AND map_sport IN (' + visibleSports.join(',') + ') AND year >= ' + minYear + ' AND year <= ' + maxYear + ' ' + attrs.join(" ");

            if (Config.user && (Config.user.role == 'admin' || Config.user.role == 'manager' || Config.user.role == 'cartographer')) {
              where1 = where;
            } else {
              where1 = (where + " AND " + Config.stateQuery);
              if (Config.user) {
                where2 = (where + " AND state IN ('proposed', 'change_requested') AND created_by_id = " + Config.user.id);
              }
            }
            
            console.log("TOC update with primary where query: " + where1);
            this.wmsLayer.layers.maps = true;
            this.wmsLayer.where = where1;
            this.wmsLayer.redraw();

            if (where2) {
              console.log("TOC update with secondary where query: " + where2);
              this.wmsLayer.where2 = where2;
              this.wmsLayer.layers.maps2 = true;
              this.wmsLayer.redraw();
            }
        }
        
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();

        if(dd<10) {
            dd='0'+dd
        } 

        if(mm<10) {
            mm='0'+mm
        } 

        today = "'" + yyyy + "-" + mm + "-" + dd + " 00:00'";
        
        if ($('#area__embargo').prop('checked')) {
          showEmbargo(today);
        }

        var area_date = $('#area__blocking_year').val();
        var sports = [];
        if ($('#area__blocking_foot').prop('checked')) {
          sports.push("'foot'")
          sports.push("'sprint'")
        }
        if ($('#area__blocking_bike').prop('checked')) {
          sports.push("'mtbo'")
        }
        if ($('#area__blocking_ski').prop('checked')) {
          sports.push("'ski'")
        }
        if (sports.length > 0) {
          showBlocking(area_date, sports);
        }
        if ($('#area__blocking_other').prop('checked')) {
          showBlocking(area_date, ["'trail'", "'extreme'", "'indoor'", "'other'"]);
        }
    },

    collapse: function () {
        $("#toc .options").slideUp("medium");
        $("#toc").addClass("minimized");

        $("#toc .link.toc_expand").show();
        $("#toc .link.toc_collapse").hide();
    },

    expand: function () {
        $("#toc .options").slideDown("medium");
        $("#toc").removeClass("minimized");

        $("#toc .link.toc_expand").hide();
        $("#toc .link.toc_collapse").show();
    },

    area_collapse: function () {
        $("#areatoc .options").slideUp("medium");
        $("#areatoc").addClass("minimized");

        $("#areatoc .link.toc_expand").show();
        $("#areatoc .link.toc_collapse").hide();
    },

    area_expand: function () {
        $("#areatoc .options").slideDown("medium");
        $("#areatoc").removeClass("minimized");

        $("#areatoc .link.toc_expand").hide();
        $("#areatoc .link.toc_collapse").show();
    }

});