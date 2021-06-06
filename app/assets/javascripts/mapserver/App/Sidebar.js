App.Sidebar = App.newClass({

    constructor: function (map, resourceString, accessGranted) {
        this.map = map;
        this.width = 385;
        this.resourceString = resourceString;
        this.accessGranted = accessGranted;
        this.pageSize = 30;
        this.maxPages = 10;
        this.init();
    },

    init: function () {
        $(".map-show-help").click(this.show);
    },

    show: function () {
        $(".search-result").show();
        $(".map-show-help").hide();
    },

    hide: function () {
        $(".search-result").hide();
        $(".map-show-help").show();
    },

    reset: function () {
        this.hideWaiting();

        $('.search-result-list').html('');

        $('.search-result-heading').html(sidebar.resourceString.sideBarQuickHelpH1);
        $('.search-result-heading').show();
        $('#quickHelp').show();

        $('.search-result-header-links').html('');
    },

    showWaiting: function () {
        this.show();

        $('.search-result-heading').html('');
        $('.search-result-list').html('');
        $('#news').hide();
        $('#quickHelp').hide();
        $('#waiting').show();
    },

    hideWaiting: function () {
        $('#waiting').hide();
    },

    hideResults: function() {
       sidebar.reset();
       $('.map-cancel-search').hide();
       $('.map-controls').show();
       toc.refresh();
       searchAdvanced.clearOverlays();
       sidebar.hide();
    },

    showResults: function (data, secondary, page) {
        //TODO: sidebar -> this

        sidebar.hideWaiting();

        if (!data) data = sidebar.lastData;

        var numRows = 0;
        if (data) {
          numRows = data.length;
          console.log("Search results " + numRows + " : " + data);
          sidebar.lastData = data;
        } else {
          console.log("Search results blank? : " + data);
        }

        var cancel = $(".map-cancel-search").length ? '<button type="button" onClick="sidebar.hideResults();">'+sidebar.resourceString.sideBarCancel+'</button>' : '';

        // Create the list of results for display
        if (numRows == 0) {
            $('.search-result-list').html(sidebar.resourceString.sideBarNoResults);
            $('.search-result-heading').html(sidebar.resourceString.sideBarNoResultsHead);
            $('.search-result-header-links').html(cancel);
            $('#quickHelp').hide();
            $('.search-result-list').show();

            sidebar.show();
            return;
        }

        // setting limit of results in sidebar
        var allRows = numRows;
        if (numRows > sidebar.pageSize * sidebar.maxPages) {
          numRows = sidebar.pageSize * sidebar.maxPages;
        }
        var numberOfResults = numRows;
        var numFrom = '';
        var currentPage = 0;
        if (page) currentPage = page;
        var numStart = currentPage * sidebar.pageSize;
        var numEnd = numStart + sidebar.pageSize;
        if (numEnd > numRows) numEnd = numRows;
        var paginationHtml = '';
        var sideHeadingString = sidebar.resourceString.sideBarResults;
        console.log("Found " + numRows + " results, page size is " + sidebar.pageSize + " and current page is " + currentPage);
        if (numRows > sidebar.pageSize) {
          numberOfResults = sidebar.pageSize;
          nPages = Math.ceil(numRows / sidebar.pageSize);
          paginationHtml = "<nav class=\"sidebarPagination\">";
          for (var i = 0; i < nPages; ++i) {
            paginationHtml += "<a href=\"#\" " + (i == currentPage ? ' class="current" ' : '') + " onclick=\"sidebar.showResults(null, null, " + i + "); return false;\">" + (i+1) + "</a>";
          }
          paginationHtml += "</nav>";
          sideHeadingString += (numStart + 1) + ' - ' + numEnd + ' (' + allRows + ')';
        } else {
          sideHeadingString += numberOfResults;
        }
        if (allRows > numRows) {
          sideHeadingString += "<br />zobrazuji pouze " + numRows + " map";
        }
        $('.search-result-heading').html(sideHeadingString);

        //concatenate the results into a string
        var dataHtml = '';
        var mapsId = [], mapsIdAll = [], urlImg, urlKML;
        for (var i = 0; i < numRows; i++) {
          var mapId = parseInt(data[i]['id']);
          mapsIdAll.push(mapId);
        }
        for (var i = numStart; i < numEnd; i++) {
            var mapId = parseInt(data[i]['id']);
            mapsId.push(mapId);
            var js = '';
            for (j = 0; j < 1; j++) {
                dataHtml += '<li id="mapResult_' + mapId + '">' +
                '<div class="title" id="result' + data[i]['id'] + '" ">' +
                  '<h3>'+
                    '<a href="/' + Config.locale + '/maps/' + mapId + '/fusion">' +
                      '<span>' + data[i]['title'] + '</span>' +
                    '</a>' +
                  '</h3>' +
                  '<ul class="tools-list">';

                urlImg = Config.assetRoot + '/data/jpg/' + data[i]['preview_identifier'] + '.jpg';
                urlKML = Config.assetRoot + '/data/kml/' + mapId + '.kml';

                if (data[i]['preview_identifier'] && data[i]['preview_identifier'] != '' && data[i]['preview_identifier'] != '0') {
                  dataHtml += '<li>' +
                    '<a href="' + urlImg + '" class="mapPreviewLink" title="' + sidebar.resourceString.preview + '">' +
                      '<img class="mapa" src="/img/tool-06.png" alt="Nahled" />' +
                    '</a>' +
                  '</li>';
                } else {
                  dataHtml += '<li><img class="mapa" src="/img/tool-06-dis.png" /></li>';
                }

                dataHtml += '<li>' +
                  '<a href="javascript:zoom2one(' + mapId + ')" title="' + sidebar.resourceString.zoomTo + '">' +
                    '<img src="/img/tool-07.png" alt="Zoom to" />'
                  '</a>' +
                '</li>';

                dataHtml += '<li>' +
                  '<a class="infoTableLink" href="/' + Config.locale + '/maps/' + mapId + '/info_table" title="' + sidebar.resourceString.info + '">' +
                    '<img src="/img/tool-08.png" alt="Ikona" />' +
                  '</a>' +
                '</li>' +
                '<li>' +
                  '<a href="javascript:mapLink.show(' + mapId + ')" title="' + sidebar.resourceString.link2oneMap + '">' +
                    '<img src="/img/tool-03.png" alt="Ikona" />' +
                  '</a>' +
                '</li>';

                // if (mapShapeExists(mapId)) {
                //   dataHtml += '<li>' +
                //     '<a href="' + urlKML + '" target="_blank" title="' + sidebar.resourceString.georefKML + '">' +
                //       '<img src="/img/tool-09.png" alt="KML" />' +
                //     '</a>' +
                //    '</li>';
                // } else {
                //     dataHtml += '<li><img src="/img/tool-09-dis.png" /></li>';
                // }


                dataHtml += '</ul></div>' +
                    '<table class="tableData">' +
                      '<tr>'+
                        '<th>' + sidebar.resourceString.map_attributes.year + ':</th>'+
                        '<th>' + sidebar.resourceString.map_attributes.scale + ':</th>'+
                        '<th>' + sidebar.resourceString.map_attributes.patron + ':</th>'+
                        '<th>' + sidebar.resourceString.map_attributes.sport + ':</th>' +
                        '<th>' + sidebar.resourceString.map_attributes.id + ':</th>' +
                      '</tr>' +
                      '<tr>' +
                        '<td>' + data[i]['year'] + '</a></td>' +
                        '<td>' + data[i]['scale'] + '</td>' +
                        '<td>' + data[i]['patron'] + '</td>' +
                        '<td>' + Config.resourceString.map_enums.map_sport[data[i]['map_sport']] + '</td>' +
                        '<td>' + data[i]['id'] + '</td>' +
                      '</tr>' +
                    '</table>' +
                  '</li>';
            }
        }
        //display the results on the page
        $('.search-result-list').html(paginationHtml + dataHtml + paginationHtml);

        //highlighting map polygons on mouseenter
        for (i = 0; i < mapsId.length; i++) {
            var id = mapsId[i];
            (function (id) {
                $('#mapResult_' + id).mouseenter(function () {
                    mapHelper.highlightMapPolygon(id);
                });
                $('#mapResult_' + id).mouseleave(function () {
                    mapHelper.clearHighlight();
                });
            }(id));
        }

        var sideHeadingLinks2 =
          '<a href="/' + Config.locale + '/maps/table_search?list=' + mapsIdAll.join("-") + '" target="_blank">' + sidebar.resourceString.sideBarTable + '</a>' +
          '<a href="/' + Config.locale + '/maps/download_search?list=' +  mapsIdAll.join("-") + '" target="_blank">' + sidebar.resourceString.sideBarDownload + '</a>';
        $('.search-result-header-links').html(cancel + sideHeadingLinks2);

        $(".map-controls").hide();
        $(".map-cancel-search").show();

        mapHelper.showSelectInMap();
    }
});
