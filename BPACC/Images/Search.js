$(document).ready(function () {
	$('.widgetSearchButton').click(function (e) {
		e.preventDefault();
		doWidgetSearch($(this).siblings('.widgetSearchBox').val());
	});
	$('.widgetSearchBox').keypress(function (e) {
		if (window.clipboardData) { // internet explorer
			if (e.keyCode == 13) { // return key
				doWidgetSearch($(this).val());
				return false;
			}
		}
		else {
			if (e.which == 13) { // return key
				doWidgetSearch($(this).val());
				return false;
			}
		}
		return true;
	});
	//$('.widgetSearchBox').autocomplete({
	//	source: '/Search/AutoComplete',
	//	html: true,
	//	delay: 0
	//});
});

function doWidgetSearch(searchPhrase) {
	if (searchPhrase != '') {
		window.location.href = '/Search/Results?searchPhrase=' + searchPhrase;
	}
}
