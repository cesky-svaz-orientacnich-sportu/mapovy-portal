// FancyBox setup

function initPreviewAndInfo() {
  $('a.mapPreviewLink').fancybox({
        'transitionIn': 'elastic',
        'transitionOut': 'elastic',
        'titleShow': true,
        'titlePosition': 'inside',
        'titleFormat': formatFancyTitle
  });
  $('a.infoTableLink').fancybox({
        'width': 740,
        'height': 630,
        'autoScale': false,
        'transitionIn': 'none',
        'transitionOut': 'none',
        'type': 'iframe',
        'titleShow': false
  });
}
   
function formatFancyTitle(title, currentArray, currentIndex, currentOpts) {
    var html = Config.resourceString.previewCopyright + '<br><a href="' + currentOpts.href + '" target="_blank">' + Config.resourceString.inNewWindow + '</a>';
    return html;
}

function after_load() {

  $('body').tooltip({selector: '[data-toggle=tooltip]', container: 'body'});  
  $('body').popover({selector: '[data-toggle=popover]', html: true});

  $("form").unbind("submit").on("submit", function(){
    $(this).find("input[type=\"submit\"]").prop("disabled", true);
    $(this).find("input[type=\"submit\"]").after("<i class=\"fa fa-spinner fa-spin\"/>");
    $(this).find("button.submit-btn").prop("disabled", true);
    $(this).find("button.submit-btn").after("<i class=\"fa fa-spinner fa-spin\"/>");
  });
  
}

