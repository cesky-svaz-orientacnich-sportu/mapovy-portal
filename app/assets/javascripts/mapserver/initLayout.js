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
