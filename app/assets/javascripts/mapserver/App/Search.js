App.Search = App.newClass({

	constructor: function (state, resultsCallback, sidebar) {
		this.state = state;
		this.resultsCallback = resultsCallback;
		this.sidebar = sidebar;
	},

	searchByName: function (name, callback) {
		var name = name.replace(/'/g, "''");
		var filter = "LOWER(title) LIKE LOWER('%" + name + "%') ";

		this.searchByFilter(filter, callback);
	},

	searchByLatLng: function (latLng, callback) {
		var filter = "St_Intersects(shape_geom, St_MakeEnvelope("
		+ (latLng.lng() - 0.000001) + ","
		+ (latLng.lat() - 0.000001) + ","
		+ (latLng.lng() + 0.000001) + ","
		+ (latLng.lat() + 0.000001)
		+ ")) ";
		this.searchByFilter(filter, callback);
	},

	searchByFilter: function (filter, callback) {
		var filter1 = filter + " AND " + Config.stateQuery;
		var filter2 = null;
		if (Config.user) {
			switch (Config.user.role) {
				case 'admin':
					filter1 = filter;
					break;
				case 'manager':
				case 'cartographer':
					filter1 = filter + " AND " + Config.fullStateQuery;
					break;
				default:
					filter2 = filter + " AND created_by_id = " + Config.user.id;
			}
		}
		var select1 = {
			select: ['id', 'title', 'patron', 'year', 'scale', 'preview_identifier', 'map_sport', 'map_family', 'has_jpg', 'has_kml', 'has_blocking', 'has_embargo', 'blocking_from', 'blocking_until', 'embargo_until'],
			where: filter1,
			order_by: 'year DESC'
		};
		var select2 = null;
		if (filter2) {
			select2 = {
				select: ['id', 'title', 'patron', 'year', 'scale', 'preview_identifier', 'map_sport', 'map_family', 'has_jpg', 'has_kml', 'has_blocking', 'has_embargo', 'blocking_from', 'blocking_until', 'embargo_until'],
				where: filter2,
				order_by: 'year DESC'
			};
		}
		console.log("Search by filter: " + filter1 + " || " + filter2);
		this.searchBySelect(select1, select2, callback);
	},

	searchBySelect: function (select1, select2, callback, notShowWaiting) {
		if (!callback) {
			callback = this.resultsCallback;
		}

		this.state.lastSelect1 = select1;
		this.state.lastSelect2 = select2;

		if (!notShowWaiting) {
			this.sidebar.showWaiting();
		}

		$.ajax({
			url: '/api/select',
			dataType: 'json',
			data: select1,
			success: function(res1) {
				if (res1.status == 'success') {
					if (select2) {
						$.ajax({
							url: '/api/select',
							dataType: 'json',
							data: select2,
							success: function(res2) {
								if (res2.status == 'success') {
									callback(res2.data, true);
								} else {
									alert('search error? S = error E = ' + res2.message + " -- the request was `...WHERE " + select2.where + "...`"); // TODO: replace with error message in sidebar
									sidebar.hideWaiting();
								}
							},
							error: function(xhr, status, error) {
								alert('search error? S = ' + status + " E = " + error + " -- the request was `...WHERE " + select2.where + "...`"); // TODO: replace with error message in sidebar
								sidebar.hideWaiting();
							}
						});
					} else {
						callback(res1.data, false);
					}
				} else {
					alert('search error? S = error E = ' + res1.message + ' -- the request was `...WHERE ' + select1.where + '...`'); // TODO: replace with error message in sidebar
					sidebar.hideWaiting();
				}
			},
			error: function(xhr, status, error) {
				alert('search error? S = ' + status + " E = " + error + " -- the request was `...WHERE " + select1.where + "...`"); // TODO: replace with error message in sidebar
				sidebar.hideWaiting();
			}
		});
	}

});
