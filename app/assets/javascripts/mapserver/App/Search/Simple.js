App.Search.Simple = App.newClass({

    constructor: function (state, resultsCallback, sidebar) {
        App.Search.call(this, state, resultsCallback, sidebar);
        this.init();
    },

    Extends: App.Search,

    search: function () {
        var name = $("#simpleSearchName").val();
        this.searchByName(name);
    },

    init: function () {
        this.initAutocomplete();
        this.initKeyPressed();
    },

    initAutocomplete: function () {
        where = '';
        // visibility
        if (Config.user && (Config.user.role == 'admin' || Config.user.role == 'manager' || Config.user.role == 'cartographer')) {
        } else {
          if (Config.user) {
//            where = Config.stateQuery + " OR CREATED_BY_ID = " + Config.user.id;
            where = Config.stateQuery;
          } else {
            where = Config.stateQuery;
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
              window.alert("Could not load autocomplete list : S = " + status + " E = " + error + " while request was sent to `/api/select`");
            },
            success: function (res) {
                // Create the list of results for display of autocomplete
                list = [];
                for (i = 0; i < res.data.length; i++) {
                    list.push(res.data[i]['title']);
                }

                // Use the results to create the autocomplete options
                $("#simpleSearchName").autocomplete({
                    source: function(request, response) {
                      var filtered_results = $.ui.autocomplete.filter(list, request.term);
                      response(filtered_results.slice(0, 20));
                    },
                    minLength: 2
                });

            }
        });

        // // anonymous function for setting maximum items as a result of autocomplete
        // $.ui.autocomplete.prototype._renderMenu = function (ul, items) {
        //     var self = this;
        //     $.each(items, function (index, item) {
        //         if (index < 20) // here we define how many results to show
        //         { self._renderItem(ul, item); }
        //     });
        // }
    },

    initKeyPressed: function () {
      var this_ = this;
      $('#simpleSearchName').keypress(function (e) {
          if (e.keyCode == '13') {
              $('.ui-autocomplete').hide();
              this_.search();
          }
      });
    }
});