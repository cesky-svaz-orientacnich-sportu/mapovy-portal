//function isElement(element) {

//    var result;

//    if ($(element).length > 0) { result = true; } else { result = false }

//    return result;

//}

//function resize() {
//  //window.alert('neco');
//	$(".dblCol").width(parseInt($("#advaSearch fieldset").width()) - parseInt($("#advaSearch .right").width()) - 50);

//	$("#searchResult").css("top",parseInt($("#top").css("height")));

//	$("#searchResult").css("height",$(window).height()- parseInt($("#top").css("height")));

//	$("ul.tabs").animate({top:(parseInt($("#top").css("height"))+20)},{duration: 'slow'},500);

//	$(".filter").animate({top:(parseInt($("#top").css("height"))+20)},{duration: 'slow'},500);

//	$("#searchResult").jScrollPane({showArrows: true});

//	//google.maps.event.trigger(map, 'resize');

//}


//$(window).resize(function() {
//	resize();
//});

function initLayout() {

    $(".toolsList .disabled img").css("opacity", 0.3);
    $(".toolsList .disabled a").css("cursor", "default");
    $(".toolsList .disabled a").click(function () {
        return false;
    });

    si = $("#formSearch input[type=text]")

    $(si).focus(function () {
        if ($(si).attr("value") == $(si).attr("title")) {
            $(si).attr("value", "");
        }
        $(si).parent().addClass("focus");
    });

    $(si).blur(function () {
        if ($(si).attr("value") == "") {
            $(si).attr("value", $(si).attr("title"));
        }
        $(si).parent().removeClass("focus");
    });


    $("#top .linkHide").click(function () {
        $("#top").slideUp("medium", function () {
            $(".linkShow").show();
            $("#top").css("height", 0);
            //resize();
            $("#searchResult").css("top", 0);
            $(".linkShowResults").css("top", 0);
            $("#map_canvas").css("top", 0);
            $("#baseMapSwitch").css("top", 25);
            $("#toc").css("top", 25);
            $("#cancelSearch").css("top", 25);
            google.maps.event.trigger(map, "resize");
            return false;
        });
    });


    $(".linkShow").click(function () {
        $(".linkShow").show();
        $("#top").css("height", "auto");
        $("#top").slideDown("medium", function () {
            //resize();
            $("#searchResult").css("top", 100);
            $(".linkShowResults").css("top", 100);
            $("#map_canvas").css("top", 100);
            $("#baseMapSwitch").css("top", 120);
            $("#toc").css("top", 120);
            $("#cancelSearch").css("top", 120);
            google.maps.event.trigger(map, "resize"); //TODO
            return false;
        });
    });


    $(".menuAdvanced, .menuApplication").bind("click", function () {
        $("#menuTop a").removeClass("active");
        $(this).addClass("active");
    });

    $(".linkAdvSearchHide, .menuAppllication").click(function () {
        $("#advaSearch").slideUp("medium", function () {
            //resize();
        });

        Advanced.clearOverlays();

        $(".linkAdvSearch").show();
        $("#formSearch .submitWrapper").removeClass("disabled");
        $('.inputtext :input').removeAttr('disabled');
        $('.searchSubmit').attr('onclick', 'searchSimple.search();');

        return false;

    });


    $(".popup .header a.close").click(function () {

        $(this).parent().parent().parent().hide();

    });

    $(".draggable").draggable({ handle: ".header" });

    $("div.submitWrapper:not(.disabled) a.searchSubmit").click(function () {
        $(this).next().click();
    });

    $(".popup .content .inside").jScrollPane({ showArrows: true });

    // reset Advanced Search Form values    
    $("#advancedSearchResetForm").click(function() {
        $('#advancedSearchName, #advancedSearchYearFrom, #advancedSearchYearTo, #TYP, #advancedSearchScale, #advancedSearchClub, #advancedSearchAuthor, #advancedSearchGPS, #advancedSearchPlace, #advancedSearchDistance').val('').placeholder();
    });
    
    $(document).on('mouseenter', 'ul.toolsList', initPreviewAndInfo);

}