App.Search.Advanced = App.newClass({

	constructor: function (state, ftLayer1, ftLayer2, resultsCallback, sidebar, resourceString) {
		App.Search.call(this, state, resultsCallback, sidebar);

		this.ftLayer1 = ftLayer1;
		this.ftLayer2 = ftLayer2;
		this.resourceString = resourceString;

		this.init();
	},

	Extends: App.Search,

	show: function () {
		$(".toolbar-advanced-search").slideDown("fast", function () {});
		$(".toolbar-advanced-search-expand").hide();
		$(".toolbar-search-submit").attr('disabled', '');
		$('.toolbar-search-input').attr('disabled', '');
	},

	hide: function () {
		$(".toolbar-advanced-search").slideUp("medium", function () {});
		$(".toolbar-advanced-search-expand").show();
		$(".toolbar-search-submit").removeAttr("disabled");
		$('.toolbar-search-input').removeAttr('disabled');
	},

	search: function () {
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
			  query_parts.push("ST_DistanceSphere(shape_geom, ST_MakePoint(" + this.center.lng() + ", " + this.center.lat() + ")) <= " + distance);
			  this.clearOverlays();
			  var distanceOptions = {
				  strokeColor: "#fe5900",
				  strokeOpacity: 0.8,
				  strokeWeight: 2,
				  fillColor: "#fe5900",
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
			query_parts.push("LOWER(title) LIKE LOWER('%" + name + "%')");
		}

		if (scale) {
			query_parts.push("scale = " + scale);
		}

		if (club) {
			query_parts.push("LOWER(patron) LIKE LOWER('%" + club + "%')");
		}

		if (author) {
			query_parts.push("cartographers_for_api LIKE '%:" + author + "]%'");
		}

		if (sport) {
			query_parts.push("map_sport = '" + sport + "'");
		}

		if (yearFrom != '') {
			query_parts.push("year >= '" + yearFrom + "'");
		}

		if (yearTo != '') {
			query_parts.push("year <= '" + yearTo + "'");
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
		$(".toolbar-advanced-search-expand, .menuAdvanced").click(this.show);
		var clearOverlays = this.clearOverlays;
		var hide = this.hide;
		$(".toolbar-advanced-search-collapse").click(function () {
			clearOverlays();
			hide();
			return false;
		});
		this.initAutocomplete();
	},

	initAutocomplete: function () {
		where = Config.stateQuery;
		if (Config.user) {
			switch (Config.user.role) {
				case 'admin':
					where = '';
					break;
				case 'manager':
				case 'cartographer':
					where = Config.fullStateQuery;
					break;
			}
		}
		$.ajax({
			url: '/api/select',
			dataType: 'json',
			data: {
				select: ['title'],
				where: where,
				group_by: 'title'
			},
			jsonp: 'jsonCallback',//
			success: function (res) {
				if (res.status == 'success') {
					// Create the list of results for display of autocomplete
					list = [];
					for (i = 0; i < res.data.length; i++) {
						list.push(res.data[i]['title']);
					}

					// Use the results to create the autocomplete options
					$("#advancedSearchName").autocomplete({
						source: function(request, response) {
							var filtered_results = $.ui.autocomplete.filter(list, request.term);
							response(filtered_results.slice(0, 20));
						},
						minLength: 2
					});
				}
			}
		});
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
		this.clearOverlays();
		$('#advancedSearchGPS').val(this.resourceString.gpsTooltip);

		this.ftLayer1.suppressInfoWindows = true;

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

				this_.ftLayer1.suppressInfoWindows = false;
			}
		);

		var ftLayerClickListener = google.maps.event.addListener(
			map,
			'click',
			function (event) {
				if (!this_.ftLayer1.visible) return;

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

				this_.ftLayer1.suppressInfoWindows = false;
			}
		);
	}
});
