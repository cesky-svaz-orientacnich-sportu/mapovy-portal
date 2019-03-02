var map,
    ftLayer1,
    ftLayer2,
    geocoder,
    mapHelper,
    mapLink,
    measure,
    searchSimple,
    searchAdvanced,
    sidebar,
    toc,
    urlInterface;

var state = {};

function renderInfoWindow(e) {
  if (e.row['MAP_FAMILY'].value == 'embargo') {
    return '<div class="infoWindow">' +
      '<div class="header title cleaned">' +
        '<h3><a href="/' + Config.locale + '/maps/' + e.row['ID'].value + '/fusion"><span>' + e.row['NAZEV'].value + '</span></a></h3>' +
      '</div>' +
      '<table class="data">' +
        '<colgroup>' +
          '<col width="70">' +
          '<col width="70">' +
          '<col width="70">' +
          '<col width="70">' +
        '</colgroup>' +
        '<tr>' +
          '<th>' + Config.resourceString.map_attributes.year +   ':</th>' +
          '<th></th>' +
          '<th>' + Config.resourceString.map_attributes.patron + ':</th>' +
          '<th></th>' +
        '</tr>' +
        '<tr>' +
          '<td>' + e.row['ROK'].value + '</td>' +
          '<td></td>' +
          '<td>' + e.row['PATRON'].value +'</td>' +
          '<td></td>' +
        '</tr>' +
        '<tr>' +
          '<th colspan="2">' + Config.resourceString.map_layers.embargo.info_title + ':' +'</th>' +
          '<td colspan="2"></td>' +
        '</tr>' +
        '<tr>' +
          '<td colspan="2">' + e.row['EMBARGO_UNTIL'].value.split(" ")[0] + '</td>' +
          '<td colspan="2"></td>' +
        '</tr>' +
      '</table>' +
    '</div>';
  } else {
    return '<div class="infoWindow" data-map-family="' + e.row['MAP_FAMILY'].value + '">' +
      '<div class="header title cleaned">' +
        '<h3><a href="/' + Config.locale + '/maps/' + e.row['ID'].value + '/fusion"><span>' + e.row['NAZEV'].value + '</span></a></h3>' +
        '<ul class="toolsList">' +
          '<li><a class="infoTableLink" href="/' + Config.locale + '/maps/' + e.row['ID'].value + '/info_table"><img src="/img/tool-08.png" alt="Ikona" /></a></li>' +
          (
            (e.row['hasJPG'].value == '1') ?
            ('<li><a class="mapPreviewLink" href="' + Config.assetRoot + '/data/jpg/' + e.row['OBRAZ'].value + '.jpg"><img src="/img/tool-06.png" alt="Ikona" /></a></li>') :
            ('<li><img style="margin-top:-6px" src="/img/tool-06-dis.png" /></li>')
          ) +
        '</ul>' +
      '</div>' +
      '<table class="data">' +
        '<colgroup>' +
          '<col width="70">' +
          '<col width="70">' +
          '<col width="70">' +
          '<col width="70">' +
        '</colgroup>' +
        '<tr>' +
          '<th>' + Config.resourceString.map_attributes.year +   ':</th>' +
          '<th>' + Config.resourceString.map_attributes.scale +  ':</th>' +
          '<th>' + Config.resourceString.map_attributes.patron + ':</th>' +
          '<th>' + Config.resourceString.map_attributes.sport +  ':</th>' +
        '</tr>' +
        '<tr>' +
          '<td>' + e.row['ROK'].value + '</td>' +
          '<td>1:' + e.row['MERITKO'].value +'</td>' +
          '<td>' + e.row['PATRON'].value +'</td>' +
          '<td>' + Config.resourceString.map_enums.map_sport[e.row['MAP_SPORT'].value] +'</td>' +
        '</tr>' +
        '<tr>' +
          '<th colspan="2">' + Config.resourceString.map_attributes.state + ':</th>' +
          '<th colspan="2"></td>' +
        '</tr>' +
        '<tr>' +
          '<td colspan="2">' + Config.resourceString.map_enums.state[e.row['MAP_STATE'].value] +'</td>' +
          '<td colspan="2"></td>' +
        '</tr>' +
        '<tr>' +
          (
            (e.row['hasBLOCKING'].value == 1) ?
            (
              '<th colspan="2">' + Config.resourceString.map_layers.blocking.title + ':' +'</th>'
            ) :
            (
              '<th colspan="2"></td>'
            )
          ) +
          (
            (e.row['hasEMBARGO'].value == 1) ?
            (
              '<th colspan="2">' + Config.resourceString.map_layers.embargo.info_title + ':' +'</th>'
            ) :
            (
              '<th colspan="2"></td>'
            )
          ) +
        '</tr>' +
        '<tr>' +
          (
            (e.row['hasBLOCKING'].value == 1) ?
            (
              '<td colspan="2">' + e.row['BLOCKING_FROM'].value + " -- " + e.row['BLOCKING_UNTIL'].value + '</td>'
            ) :
            (
              '<td colspan="2"></td>'
            )
          ) +
          (
            (e.row['hasEMBARGO'].value == 1) ?
            (
              '<td colspan="2">' + e.row['EMBARGO_UNTIL'].value.split(" ")[0] + '</td>'
            ) :
            (
              '<td colspan="2"></td>'
            )
          ) +
        '</tr>' +
      '</table>' +
    '</div>';

  }
}

function showBlocking(date, sports) {
  var where = 'hasBLOCKING = 1 AND MAP_SPORT in (' + sports.join(",") + ') AND BLOCKING_FROM <= ' + date + ' AND BLOCKING_UNTIL >= ' + date + '';
  console.log("BLOCK ON " + date + " AND " + sports + " / QUERY " + where);
  this.ftLayerB.query.where = where;
  this.ftLayerB.setMap(this.map);
}

function showEmbargo(date, year) {
  //var where = '(hasEMBARGO = 1 AND EMBARGO_UNTIL >= ' + date + ') OR (MAP_FAMILY = "embargo")';
  var where = 'MAP_FAMILY = \'embargo\' AND ROK = ' + year;
  console.log("EMB QUERY " + where);
  this.ftLayerE.query.where = where;
  this.ftLayerE.setMap(this.map);
}

function initMapsLayer() {

  var ftLayerId = Config.ftLayerId;
  var filter = urlInterface.getFilter();
  var where = '';
  if (filter) {
      searchSimple.searchByFilter(filter);
      where += filter;
  }
  else {
      var layers = urlInterface.getLayers();
      if (layers) {
      }  else {
          where += 'ID < 0';
      }
  }

  ftLayer1 = new google.maps.FusionTablesLayer({
      query: {
          select: 'geometry',
          from: ftLayerId,
          where: where
      },
      options: {
          styleId:2,
          templateId:2,
          suppressInfoWindows: false
          //clickable: false
      }
  });
  ftLayer1.setMap(map);

  ftLayer2 = new google.maps.FusionTablesLayer({
      query: {
          select: 'geometry',
          from: ftLayerId,
          where: where
      },
      options: {
          styleId:2,
          templateId:2,
          suppressInfoWindows: false
          //clickable: false
      }
  });
  ftLayer2.setMap(null);

  ftLayerE = new google.maps.FusionTablesLayer({
      query: {
          select: 'geometry',
          from: Config.ftEmbargoLayerId
      },
      options: {
          styleId:2,
          templateId:2,
          suppressInfoWindows: false
      }
  });
  ftLayerE.setMap(null);

  ftLayerB = new google.maps.FusionTablesLayer({
      query: {
          select: 'geometry',
          from: Config.ftBlockingLayerId
      },
      options: {
          styleId:2,
          templateId:2,
          suppressInfoWindows: false
      }
  });
  ftLayerB.setMap(null);

  // info window override
  google.maps.event.addListener(ftLayer1, 'click', function(e) {
    if (e) {
      e.infoWindowHtml = renderInfoWindow(e);
    }
  });
  google.maps.event.addListener(ftLayer2, 'click', function(e) {
    if (e) {
      e.infoWindowHtml = renderInfoWindow(e);
    }
  });
  google.maps.event.addListener(ftLayerE, 'click', function(e) {
    if (e) {
      e.infoWindowHtml = renderInfoWindow(e);
    }
  });
  google.maps.event.addListener(ftLayerB, 'click', function(e) {
    if (e) {
      e.infoWindowHtml = renderInfoWindow(e);
    }
  });

}

function initMap() {

    var ftLayerId = Config.ftLayerId;

    urlInterface = new App.UrlInterface(ftLayerId);

    var zoom = urlInterface.getZoom() ? urlInterface.getZoom() : Config.mapInitParams.zoom;
    var lat = urlInterface.getLat() ? urlInterface.getLat() : Config.mapInitParams.lat;
    var lng = urlInterface.getLng() ? urlInterface.getLng() : Config.mapInitParams.lng;
    var mapTypeId = urlInterface.getMapTypeId() ? urlInterface.getMapTypeId() : Config.mapInitParams.mapTypeId;

    var getShcTile = new google.maps.ImageMapType({
        getTileUrl: function (coord, zoom) {
            if(zoom == 8) {
                return Config.assetRoot + "/data/tiles/" + zoom + "/" + coord.y + "/" + coord.x + ".png";
            }
            else {
                // return "https://ags.cuzk.cz/ArcGIS/rest/services/zmwm/MapServer/tile/" + (zoom - 9) + "/" + coord.y + "/" + coord.x;
                return "https://ags.cuzk.cz/ArcGIS/rest/services/zmwm/MapServer/tile/" + (zoom) + "/" + coord.y + "/" + coord.x;
            }

        },
        tileSize: new google.maps.Size(256, 256),
        isPng: true,
        maxZoom: 17,
        minZoom: 8,
        name: "SHC"
    });

    var myLatlng = new google.maps.LatLng(lat, lng);
    var myOptions = {
        center: myLatlng,
        zoom: zoom,
        overviewMapControl: false,
        scaleControl: true,
        mapTypeControl: false,
        scrollwheel: true
    };

    geocoder = new google.maps.Geocoder();
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    map.mapTypes.set("SHC", getShcTile);
    map.setMapTypeId(mapTypeId);

    map.enableKeyDragZoom({
        key: 'ctrl',
        boxStyle: {
            border: "4px solid #D93C00",
            backgroundColor: "transparent",
            opacity: 1.0
        },
        veilStyle: {
            backgroundColor: "gray",
            opacity: 0.35,
            cursor: "crosshair"
        },
    });
}

function initMapComponents() {

    var ftLayerId = Config.ftLayerId;
    var mapTypeId = Config.mapInitParams.mapTypeId;

    sidebar = new App.Sidebar(map, 385, Config.resourceString, Config.accessGranted);
    urlInterface = new App.UrlInterface(ftLayerId);
    mapLink = new App.MapLink(urlInterface, Config.apiKey);
    searchSimple = new App.Search.Simple(state, ftLayerId, Config.apiKey, sidebar.showResults, sidebar);

    // app objects init
    searchAdvanced = new App.Search.Advanced(state, ftLayer1, ftLayer2, ftLayerId, Config.apiKey, sidebar.showResults, sidebar, Config.resourceString);

    toc = new App.Toc(map, ftLayer1, ftLayer2, ftLayerE, ftLayerB, ftLayerId);
    mapHelper = new App.MapHelper(state, map, toc, searchSimple, ftLayer1, ftLayer2, Config.ftHighlightLayerId);
    measure = new App.Measure(map, ftLayer1);

    mapHelper.changeMapType(mapTypeId);

    //CONTEXT MENU
    var contextMenuOptions = {};
    contextMenuOptions.classNames = { menu: 'context_menu', menuSeparator: 'context_menu_separator' };

    //  create an array of ContextMenuItem objects
    //  an 'id' is defined for each of the four directions related items
    var menuItems = [];
    //  a menuItem with no properties will be rendered as a separator
    menuItems.push({ className: 'context_menu_item', eventName: 'zoom_in_click', label: Config.resourceString.zoomIn });
    menuItems.push({ className: 'context_menu_item', eventName: 'zoom_out_click', label: Config.resourceString.zoomOut });
    menuItems.push({});
    menuItems.push({ className: 'context_menu_item', eventName: 'center_map_click', label: Config.resourceString.centerMapHere });
    menuItems.push({});
    menuItems.push({ className: 'context_menu_item', eventName: 'handle_map_click', label: Config.resourceString.findMapsHere });
    contextMenuOptions.menuItems = menuItems;

    var mapContextMenu = new ContextMenu(map, contextMenuOptions);

    //  listen for the ContextMenu 'menu_item_selected' event
    google.maps.event.addListener(mapContextMenu, 'menu_item_selected', function (latLng, eventName) {
        switch (eventName) {
            case 'zoom_in_click':
                map.setZoom(map.getZoom() + 1);
                break;
            case 'zoom_out_click':
                map.setZoom(map.getZoom() - 1);
                break;
            case 'center_map_click':
                map.panTo(latLng);
                break;
            case 'handle_map_click':
                searchSimple.searchByLatLng(latLng);
                break;
        }
    });

    //function handleMapClick(event) {
    //    mapContextMenu.show(event.latLng);
    //}

    //mapHelper.registerMapClickListeners(handleMapClick);

    var overlay = new google.maps.OverlayView();
    overlay.draw = function () { };
    overlay.setMap(map);

    function handleRightClick(e) {
        var rightclick;
        if (!e) {
            var e = window.event;
        }

        if (e.which) {
            rightclick = (e.which == 3);
        }
        else if (e.button) {
            rightclick = (e.button == 2);
        }

        if (rightclick) {
            var x = e.pageX - this.offsetLeft;
            var y = e.pageY - this.offsetTop;
            var pxPoint = new google.maps.Point(x, y);
            var latLng = overlay.getProjection().fromContainerPixelToLatLng(pxPoint);

            mapContextMenu.show(latLng);
        }
    }

    $('#map_canvas').mousedown(handleRightClick);

}