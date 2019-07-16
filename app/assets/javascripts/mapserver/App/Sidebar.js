App.Sidebar = App.newClass({

    constructor: function (map, width, resourceString, accessGranted) {
        this.map = map;
        this.width = width;
        this.resourceString = resourceString;
        this.accessGranted = accessGranted;
        this.pageSize = 30;
        this.maxPages = 10;
        this.init();
    },

    init: function () {
        $(".hide_search_results_button").click(this.hide);
        $(".linkShowResults").click(this.show);
    },

    show: function () {
        $("#searchResult").animate({ left: "0" }, { duration: 'slow', easing: 'easeOutBack' }, 500);
        $(".linkShowResults").hide();

        $("#map_canvas").css("left", sidebar.width);
        google.maps.event.trigger(map, "resize");
    },

    hide: function () {
        $("#searchResult").animate({ left: '-' + sidebar.width }, { duration: 'slow', easing: 'easeOutBack' }, 500);
        $(".linkShowResults").show();

        $("#map_canvas").css("left", 0);
        google.maps.event.trigger(map, "resize");
    },

    reset: function () {
        this.hideWaiting();

        $('#resultsList').html('');

        $('#sideHeading').html(sidebar.resourceString.sideBarQuickHelpH1);
        $('#sideHeading').show();
        $('#quickHelp').show();

        $('#sideHeadingLinks').html('');
        $('#searchResult').jScrollPane({ showArrows: true });
        
        //this.marker.setMap(null);
        //$('input.fitem').removeAttr('disabled');
    },

    showWaiting: function () {
        this.show();

        $('#sideHeading').html('');
        $('#resultsList').html('');
        $('#news').hide();
        $('#quickHelp').hide();
        $('#waiting').show();
    },

    hideWaiting: function () {
        $('#waiting').hide();
    },
    
    hideResults: function() {
       sidebar.reset(); 
       $('#titlebar').remove();
       $('#cancelSearch').hide();
       $('#toc').show();
       $('#area_toc').show();
       toc.refresh(); 
       searchAdvanced.clearOverlays(); 
       sidebar.hide();
    },

    showResults: function (table, secondary, page) {
        //TODO: sidebar -> this

        sidebar.hideWaiting();

        if (!table) table = sidebar.lastTable;

        var numRows = 0;
        var numCols = 0;
        if (table && table.rows) {
          numRows = table.rows.length;
          numCols = table.columns.length;   
          console.log("Search results " + numRows + " / " + numCols + " : " + table);       
          sidebar.lastTable = table;
        } else {
          console.log("Search results blank? : " + table);                 
        }

        var cancel = '<a href="#" onClick="sidebar.hideResults(); ">' + sidebar.resourceString.sideBarCancel + '</a>';

        // Create the list of results for display
        if (numRows == 0) {
            $('#resultsList').html(sidebar.resourceString.sideBarNoResults);
            $('#sideHeading').html(sidebar.resourceString.sideBarNoResultsHead);
            $('#sideHeadingLinks').html(cancel);
            $('#quickHelp').hide();
            $('#resultsList').show();

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
        $('#sideHeading').html(sideHeadingString);

        //concatenate the results into a string
        var fusionTableData = '';
        var mapsId = [], mapsIdAll = [], urlImg, urlKML;
        for (var i = 0; i < numRows; i++) {
          var mapId = parseInt(table.rows[i][0]);
          mapsIdAll.push(mapId);
        }
        for (var i = numStart; i < numEnd; i++) {
            var mapId = parseInt(table.rows[i][0]);
            mapsId.push(mapId);
            var js = '';
            for (j = 0; j < 1; j++) {
                fusionTableData += '<li id="mapResult_' + mapId + '" class="cleaned">' + 
                '<div class="title cleaned" id="result' + table.rows[i][0] + '" ">' + 
                  '<h3>'+
                    '<a href="/' + Config.locale + '/maps/' + mapId + '/fusion">' + 
                      '<span>' + table.rows[i][1] + '</span>' + 
                    '</a>' + 
                  '</h3>' +
                  '<ul class="toolsList">';
                
                urlImg = Config.assetRoot + '/data/jpg/' + table.rows[i][5] + '.jpg';
                urlKML = Config.assetRoot + '/data/kml/' + mapId + '.kml';
                
                if (table.rows[i][5] && table.rows[i][5] != '' && table.rows[i][5] != '0') {
                  fusionTableData += '<li>' +
                    '<a href="' + urlImg + '" class="mapPreviewLink" title="' + sidebar.resourceString.preview + '">' + 
                      '<img class="mapa" src="/img/tool-06.png" alt="Nahled" />' + 
                    '</a>' + 
                  '</li>';
                } else {
                  fusionTableData += '<li><img class="mapa" src="/img/tool-06-dis.png" /></li>';
                }
                
                fusionTableData += '<li>' +
                  '<a href="javascript:zoom2one(' + mapId + ')" title="' + sidebar.resourceString.zoomTo + '">' +
                    '<img src="/img/tool-07.png" alt="Zoom to" />'
                  '</a>' +
                '</li>';
                
                fusionTableData += '<li>' + 
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
                //   fusionTableData += '<li>' +
                //     '<a href="' + urlKML + '" target="_blank" title="' + sidebar.resourceString.georefKML + '">' +
                //       '<img src="/img/tool-09.png" alt="KML" />' +
                //     '</a>' +
                //    '</li>';
                // } else {
                //     fusionTableData += '<li><img src="/img/tool-09-dis.png" /></li>';
                // }
                

                fusionTableData += '</ul></div>' +
                    '<table class="tableData">' +
                      '<tr>'+
                        '<th>' + sidebar.resourceString.map_attributes.year + ':</th>'+
                        '<th>' + sidebar.resourceString.map_attributes.scale + ':</th>'+
                        '<th>' + sidebar.resourceString.map_attributes.patron + ':</th>'+
                        '<th>' + sidebar.resourceString.map_attributes.sport + ':</th>' +
                        '<th>' + sidebar.resourceString.map_attributes.id + ':</th>' +
                      '</tr>' +
                      '<tr>' +
                        '<td>' + table.rows[i][3] + '</a></td>' +
                        '<td>' + table.rows[i][4] + '</td>' +
                        '<td>' + table.rows[i][2] + '</td>' +
                        '<td>' + Config.resourceString.map_enums.map_sport[table.rows[i][6]] + '</td>' +
                        '<td>' + table.rows[i][0] + '</td>' +
                      '</tr>' +
                    '</table>' +
                  '</li>';
            }
        }
        //display the results on the page
        $('#resultsList').html(paginationHtml + fusionTableData + paginationHtml);

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

        //var queryLink = '?lg=<?php echo $lg ?>&page=query';

        var sideHeadingLinks2 = '<span>|</span>' +
          '<a href="/' + Config.locale + '/maps/table_search?list=' + mapsIdAll.join("-") + '" target="_blank">' + sidebar.resourceString.sideBarTable + '</a>' +
          '<span>|</span>' + 
          '<a href="/' + Config.locale + '/maps/download_search?list=' +  mapsIdAll.join("-") + '" target="_blank">' + sidebar.resourceString.sideBarDownload + '</a>';
        $('#sideHeadingLinks').html(cancel + sideHeadingLinks2);

        $('#searchResult').jScrollPane({ showArrows: true });
        $("#toc").hide();
        $("#cancelSearch").show();
        
        //showQueryInMap();
        mapHelper.showSelectInMap();
    },


});