App.Toc = App.newClass({

    constructor: function (map, ftLayer2, ftLayerId) {
        this.map = map;
        this.ftLayer2 = ftLayer2;
        this.ftLayerId = ftLayerId;
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
              
        wmsLayer.layers.maps = false;
        wmsLayer.layers.embargoes = false;
        wmsLayer.layers.blocking = false;
        wmsLayer.redraw();
        
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
                where2 = (where + " AND MAP_STATE IN ('proposed', 'change_requested') AND CREATED_BY_ID = " + Config.user.id);
              }
            }
            
            console.log("TOC update with primary where query: " + where1);
            wmsLayer.layers.maps = true;
            wmsLayer.where = where1;
            wmsLayer.redraw();

            if (where2) {
              console.log("TOC update with secondary where query: " + where2);
              this.ftLayer2.query.where = where2;
              this.ftLayer2.setMap(map);              
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