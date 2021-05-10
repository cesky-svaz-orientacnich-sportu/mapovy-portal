App.Toc = App.newClass({

    constructor: function (map, ftLayer1, ftLayer2, ftLayerE, ftLayerCA, ftLayerB) {
        this.map = map;
        this.ftLayer1 = ftLayer1;
        this.ftLayer2 = ftLayer2;
        this.ftLayerE = ftLayerE;
        this.ftLayerCA = ftLayerCA;
        this.ftLayerB = ftLayerB;
    },

    showEmbargoes: function (date) {
        this.ftLayerE.where = 'has_embargo = true AND embargo_until >= ' + date;
        console.log("EMB QUERY " + this.ftLayerE.where);
        this.ftLayerE.show();
    },

    showCompetitionAreas: function (date) {
        this.ftLayerCA.where = 'has_competition_area = true AND competition_area_until >= ' + date;
        console.log("CA QUERY " + this.ftLayerCA.where);
        this.ftLayerCA.show();
    },

    showBlocking: function (date, sports) {
        this.ftLayerB.where = 'has_blocking = true AND map_sport in (' + sports.join(",") + ') AND blocking_from <= ' + date + ' AND blocking_until >= ' + date + '';
        console.log("BLOCK ON " + date + " AND " + sports + " / QUERY " + this.ftLayerB.where);
        this.ftLayerB.show();
    },

    refresh: function () {
        var $items = $(".map-controls .item");

        $items.removeClass("active");
        $items.find('input').each(function(i) {
          if ($(this).prop('checked')) {
            $(this).closest('.item').addClass('active');
          }
        });

        var visibleFamilies = [];
        var visibleSports = [];
        var minYear = 9999;
        var maxYear = -9999;

        $(".map-controls input").each(function(i) {
          if ($(this).prop('checked')) {
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

        this.ftLayer1.hide();
        this.ftLayer2.hide();
        this.ftLayerE.hide();
        this.ftLayerCA.hide();
        this.ftLayerB.hide();

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
            this.ftLayer1.where = where1;
            this.ftLayer1.show();

            if (where2) {
              console.log("TOC update with secondary where query: " + where2);
              this.ftLayer2.where = where2;
              this.ftLayer2.show();
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

        if ($('#area__embargoes').prop('checked')) {
          this.showEmbargoes(today);
        }

        if ($('#area__competition_areas').prop('checked')) {
          this.showCompetitionAreas(today);
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
          this.showBlocking(area_date, sports);
        }
        if ($('#area__blocking_other').prop('checked')) {
          this.showBlocking(area_date, ["'trail'", "'extreme'", "'indoor'", "'other'"]);
        }
    },

    collapse: function () {
        $(".map-controls-body").slideUp("medium");
        $(".map-controls-header").attr('aria-expanded', 'false');
    },

    expand: function () {
        $(".map-controls-body").slideDown("medium");
        $(".map-controls-header").attr('aria-expanded', 'true');
    },

});
