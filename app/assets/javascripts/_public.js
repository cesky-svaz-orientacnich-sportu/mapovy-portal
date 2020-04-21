// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require plugins
//= require jquery
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.colReorder
//= require dataTables/extras/dataTables.colVis
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require bootstrap
//= require jquery_ujs
//= require jquery-ui/widgets/draggable
//= require jquery-ui/widgets/autocomplete
//= require mapserver/config
//= require jquery_nested_form
//= require select2-full
//= require mapserver/common
//= require ./fancybox/jquery.fancybox
//= require map_edit_helpers
//= require maps

$(function() {
  initPreviewAndInfo();
});

$(after_load);
