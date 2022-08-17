App.Search.Simple = App.newClass({

	constructor: function (state, resultsCallback, sidebar) {
		App.Search.call(this, state, resultsCallback, sidebar);
		this.init();
	},

	Extends: App.Search,

	search: function () {
		var name = $(".toolbar-search-input").val();
		this.searchByName(name);
	},

	init: function () {
		this.initAutocomplete();
		this.initKeyPressed();
		$('.toolbar-search-submit').on('click', function(e) {
			e.preventDefault();
			searchSimple.search();
		});
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
		console.log("Autocomplete init with query = " + where);
		$.ajax({
			url: '/api/select',
			dataType: 'json',
			data: {
				select: ['title'],
				where: where,
				group_by: 'title'
			},
			error: function(jqxhr, status, error) {
				console.log("Could not load autocomplete list : S = " + status + " E = " + error + " while request was sent to `/api/select`");
			},
			success: function (res) {
				if (res.status == 'success') {
					// Create the list of results for display of autocomplete
					list = [];
					for (i = 0; i < res.data.length; i++) {
						list.push(res.data[i]['title']);
					}

					// Use the results to create the autocomplete options
					$(".toolbar-search-input").autocomplete({
						source: function(request, response) {
							var filtered_results = $.ui.autocomplete.filter(list, request.term);
							response(filtered_results.slice(0, 20));
						},
						minLength: 2
					});
				} else {
					console.log("Could not load autocomplete list : S = error E = " + res.message + " while request was sent to `/api/select`");
				}
			}
		});
	},

	initKeyPressed: function () {
		var this_ = this;
		$('.toolbar-search-input').keypress(function (e) {
			if (e.keyCode == '13') {
				$('.ui-autocomplete').hide();
				this_.search();
			}
		});
	}
});
