App.MapLink = App.newClass({

    constructor: function (urlInterface, apiKey) {
        this.urlInterface = urlInterface;
        this.apiKey = apiKey;
    },

    show: function (mapId) {
        this.update(mapId);
        $('.map-show-url-link').show();
    },

    update: function (mapId) {
        if (mapId) {
          var url = Config.hostname + "/" + Config.locale + "/maps/" + mapId + "/fusion";
        } else {
          var url = this.getLink();
        }
        $('#urlInp').val(url);
        this.shorten();
    },

    print: function () {
        var url = this.getLink(null, true);
        // window.open(url);
        window.print();
    },

    getLink: function () {
        var locPath = location.pathname;
        var locHost = Config.hostname;

        var url = locHost + locPath;
        var pairs = [];

        var lg = Config.locale;
        if (lg) {
            pairs.push('locale=' + lg);
        }

        var visibleLayers = [];

        pairs.push('z=' + map.getZoom());
        pairs.push('lat=' + map.getCenter().lat());
        pairs.push('lng=' + map.getCenter().lng());
        pairs.push('m=' + map.getMapTypeId());

        url += '?' + pairs.join('&');

        return url;
    },

    hide: function () {
        $('.map-show-url-link').hide();
    },

    shorten: function () {
        gapi.client.setApiKey(this.apiKey);

        gapi.client.load(
            'urlshortener',
            'v1',
            function () {
                var request = gapi.client.urlshortener.url.insert({
                    'resource': {
                        'longUrl': $('#urlInp').val()
                    }
                });
                var resp = request.execute(function (resp) {
                    if (resp.error) {
                        //$("#urlInp").val('Error. ' + resp.error.message);
                    }
                    else {
                        $("#urlInp").val(resp.id);
                    }
                });
            }
        );
    }

});
