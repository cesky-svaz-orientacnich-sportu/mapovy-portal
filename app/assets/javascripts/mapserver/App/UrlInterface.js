App.UrlInterface = App.newClass({

    constructor: function () {},

    lastLocationHref: '',

    paramsCache: [],

    getZoom: function () {
        var zoom = this.getParam('z');
        if (parseInt(zoom) > 0 && parseInt(zoom) < 22) {
            return parseInt(zoom);
        }
        else {
            return null;
        }
    },

    getLat: function () {
        var lat = this.getParam('lat');
        if (parseFloat(lat) >= -90 && parseFloat(lat) <= 90) {
            return parseFloat(lat);
        }
        else {
            return null;
        }
    },

    getLng: function () {
        var lat = this.getParam('lng');
        if (parseFloat(lat) >= -180 && parseFloat(lat) <= 180) {
            return parseFloat(lat);
        }
        else {
            return null;
        }
    },

    getMapTypeId: function () {
        var mapTypeId = this.getParam('m');

        var allowedTypes = ['SATELLITE', 'ROADMAP', 'SHC'];
        if (mapTypeId && $.inArray(mapTypeId.toUpperCase(), allowedTypes) >= 0) {
            return mapTypeId.toUpperCase();
        }
        else {
            return null;
        }
    },

    getLayers: function () {
        var layers = this.getParam('l');

        var pattern = /^[0-9,]*$/;
        if (layers != null && layers.match(pattern)) {
            return layers.split(',');
        }
        else {
            return null;
        }
    },

    getFilter: function () {
        var filter = '';
        var filterArr = [];

        var idFilter = this.getIdFilter();
        if (idFilter) {
            return idFilter;
        }
        else {
            var nameFilter = this.getNameFilter();
            if (nameFilter) {
                filterArr.push(nameFilter);
            }

            var authorFilter = this.getAuthorFilter();
            if (authorFilter) {
                filterArr.push(authorFilter);
            }

            var yearFilter = this.getYearFilter();
            if (yearFilter) {
                filterArr.push(yearFilter);
            }

            var clubFilter = this.getClubFilter();
            if (clubFilter) {
                filterArr.push(clubFilter);
            }

            filter = filterArr.join(' AND ');
        }

        return filter;
    },

    getIdFilter: function () {
        var filter;
        var id = this.getParam('id');
        if (id) {
            filter = "id = " + id;
        }

        return filter;
    },

    getNameFilter: function () {
        var filter;
        var name = this.getParam('name');
        if (name) {
            filter = "LOWER(title) LIKE LOWER('%" + name + "%')";
        }

        return filter;
    },

    getAuthorFilter: function () {
        var filter;
        var author = this.getParam('author');
        if(author) {
            filter = "cartographers_for_api LIKE '%:" + parseInt(author) + "]%'";
        }
        
        return filter;
    },

    getYearFilter: function () {
        var filter;
        var year = this.getParam('year');
        if (year) {
            filter = "year = " + year;
        }

        return filter;
    },

    getClubFilter: function () {
        var filter;
        var club = this.getParam('club');
        if (club) {
            filter = "patron LIKE '%" + club + "%'";
        }

        return filter;
    },

    getParam: function (name) {
        return this.getParams()[name];
    },

    getParams: function () {
        if (window.location.href == this.lastLocationHref) {
            return this.paramsCache;
        }

        var params = []
        var pairs = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        var pair;
        for (i = 0; i < pairs.length; i++) {
            pair = pairs[i].split('=');
            params.push(pair[0]);
            params[pair[0]] = pair[1] != null ? pair[1] : '';
        }

        this.lastLocationHref = window.location.href;
        this.paramsCache = params;

        return params;
    }

});