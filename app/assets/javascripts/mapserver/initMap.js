var map,
    wmsLayer,
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

function createWMSLayer() {
  var overlay = new google.maps.ImageMapType({
    getTileUrl: function(coord, zoom) {
      var proj = map.getProjection();
      var zfactor = Math.pow(2, zoom);
      // get Long Lat coordinates
      var top = proj.fromPointToLatLng(new google.maps.Point(coord.x * 256 / zfactor, coord.y * 256 / zfactor));
      var bot = proj.fromPointToLatLng(new google.maps.Point((coord.x + 1) * 256 / zfactor, (coord.y + 1) * 256 / zfactor));

      //corrections for the slight shift of the SLP (mapserver)
      var deltaX = 0.0013;
      var deltaY = 0.00058;

      //create the Bounding box string
      var bbox =   (top.lng() + deltaX) + "," +
                   (bot.lat() + deltaY) + "," +
                   (bot.lng() + deltaX) + "," +
                   (top.lat() + deltaY);

      //base WMS URL
      var url = Config.wmsUrl;
      url += '?SERVICE=WMS';
      url += '&VERSION=1.3.0';
      url += '&REQUEST=GetMap';
      url += '&FORMAT=image/png';
      url += '&TRANSPARENT=true';
      url += '&LAYERS='+ wmsLayer.getLayers();
      url += '&CRS=EPSG:3857';
      url += '&STYLES=';
      url += '&WIDTH=256';
      url += '&HEIGHT=256';
      url += '&BBOX='+ bbox;
      url += '&where='+ wmsLayer.where;
      url += '&whereE='+ wmsLayer.whereE;
      url += '&whereB='+ wmsLayer.whereB;
      return url;
    },
    tileSize: new google.maps.Size(256, 256),
    isPng: true
  });

   return overlay;
}

function renderInfoWindow(map) {
  if (map['map_family'] == 'embargo') {
    return '<div class="infoWindow">' +
      '<div class="header title cleaned">' +
        '<h3><a href="/' + Config.locale + '/maps/' + map['id'] + '/fusion"><span>' + map['title'] + '</span></a></h3>' +
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
          '<td>' + map['year'] + '</td>' +
          '<td></td>' +
          '<td>' + map['patron'] +'</td>' +
          '<td></td>' +
        '</tr>' +
        '<tr>' +
          '<th colspan="2">' + Config.resourceString.map_layers.embargo.info_title + ':' +'</th>' +
          '<td colspan="2"></td>' +
        '</tr>' +
        '<tr>' +
          '<td colspan="2">' + map['embargo_until'].split(" ")[0] + '</td>' +
          '<td colspan="2"></td>' +
        '</tr>' +
      '</table>' +
    '</div>';
  } else {
    return '<div class="infoWindow" data-map-family="' + map['map_family'] + '">' +
      '<div class="header title cleaned">' +
        '<h3><a href="/' + Config.locale + '/maps/' + map['id'] + '/fusion"><span>' + map['title'] + '</span></a></h3>' +
        '<ul class="toolsList">' +
          '<li><a class="infoTableLink" href="/' + Config.locale + '/maps/' + map['id'] + '/info_table"><img src="/img/tool-08.png" alt="Ikona" /></a></li>' +
          (
            (map['has_jpg'] == '1') ?
            ('<li><a class="mapPreviewLink" href="' + Config.assetRoot + '/data/jpg/' + map['preview_identifier'] + '.jpg"><img src="/img/tool-06.png" alt="Ikona" /></a></li>') :
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
          '<td>' + map['year'] + '</td>' +
          '<td>1:' + map['scale'] +'</td>' +
          '<td>' + map['patron'] +'</td>' +
          '<td>' + map['map_sport'] +'</td>' +
        '</tr>' +
        '<tr>' +
          '<th colspan="2">' + Config.resourceString.map_attributes.state + ':</th>' +
          '<th colspan="2"></td>' +
        '</tr>' +
        '<tr>' +
          '<td colspan="2">' + map['state'] +'</td>' +
          '<td colspan="2"></td>' +
        '</tr>' +
        '<tr>' +
          (
            (map['has_blocking'] == 1) ?
            (
              '<th colspan="2">' + Config.resourceString.map_layers.blocking.title + ':' +'</th>'
            ) :
            (
              '<th colspan="2"></td>'
            )
          ) +
          (
            (map['has_embargo'] == 1) ?
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
            (map['has_blocking'] == 1) ?
            (
              '<td colspan="2">' + map['blocking_from'] + " -- " + map['blocking_until'] + '</td>'
            ) :
            (
              '<td colspan="2"></td>'
            )
          ) +
          (
            (map['has_embargo'] == 1) ?
            (
              '<td colspan="2">' + map['embargo_until'].split(" ")[0] + '</td>'
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
  wmsLayer.layers.blocking = true;
  wmsLayer.whereB = 'has_blocking = true AND map_sport in (' + sports.join(",") + ') AND blocking_from <= ' + date + ' AND blocking_until >= ' + date + '';
  console.log("BLOCK ON " + date + " AND " + sports + " / QUERY " + wmsLayer.whereB);
  wmsLayer.redraw();
}

function showEmbargo(date) {
  wmsLayer.layers.embargoes = true;
  wmsLayer.whereE = 'has_embargo = true AND embargo_until >= ' + date;
  console.log("EMB QUERY " + wmsLayer.whereE);
  wmsLayer.redraw();
}

function initMapsLayer() {
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
          where += 'id < 0';
      }
  }

  wmsLayer = {
    overlay: null,
    redraw: function() {
      map.overlayMapTypes.pop();
      map.overlayMapTypes.push(wmsLayer.overlay);
    },
    layers: {
      maps: false,
      embargoes: false,
      blocking: false
    },
    getLayers: function() {
      var layers = [];
      if (wmsLayer.layers.maps) layers.push('maps');
      if (wmsLayer.layers.embargoes) layers.push('embargoes');
      if (wmsLayer.layers.blocking) layers.push('blocking');
      return layers.join(',');
    },
    where: where,
    whereE: '1',
    whereB: '1',
    suppressInfoWindows: false
  };

  wmsLayer.overlay = createWMSLayer();
  wmsLayer.layers.maps = true;
  wmsLayer.redraw();

  // TODO: ftLayer1 ~ Config.ftLayerId
  // TODO: ftLayer2 ~ Config.ftLayerId
  // TODO: ftLayerE ~ Config.ftEmbargoLayerId
  // TODO: ftLayerB ~ Config.ftBlockingLayerId

  // info window override
  var infoWindow = new google.maps.InfoWindow({content: ''});
  map.addListener('click', function(e) {
    if (! wmsLayer.suppressInfoWindows) {
      $.get('/api/maps_in_point', {
        format: 'json',
        lonlat: encodeURI(e.latLng.lng()+','+e.latLng.lat()),
        layers: encodeURI(wmsLayer.getLayers()),
        where: encodeURI(wmsLayer.where),
        whereE: encodeURI(wmsLayer.whereE),
        whereB: encodeURI(wmsLayer.whereB)
      }).done(function(res) {
        if (res.status == 'success') {
          infoWindow.setContent(renderInfoWindow(res.data));
          infoWindow.setPosition(new google.maps.LatLng(e.latLng.lat(), e.latLng.lng()));
          infoWindow.open(map);
        }
        else {
          infoWindow.close();
        }
      })
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

    toc = new App.Toc(map, ftLayer2, ftLayerId);
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