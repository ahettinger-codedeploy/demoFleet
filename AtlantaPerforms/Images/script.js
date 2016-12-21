function updateCalendar(thedate) {
	doAjaxGet('includes/calendar.php?date=' + thedate, function(text) {
		c = document.getElementById("calendarDiv");
		c.innerHTML = text;
	}, function (code) {
	});
}

function showEvents(d) {
	window.location = 'search.php?search=1&searchtype=date&datefrom=' + d + '&dateto=' + d;
}

function keywordSearch() {
	word = document.getElementById("keywordsearch");
	if (word) {
		window.location = 'search.php?search=1&searchtype=title&title=' + word.value + '&description=' + word.value;
	} else {
		alert("No word.");
	}
}