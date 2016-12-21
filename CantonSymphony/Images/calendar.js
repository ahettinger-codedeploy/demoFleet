/**
 * Sets up the required functionality of the calendar components
 * 
 * @author Joshua Smith 
 */
function calendarInit()
{
	$("#calendarPrint").click(function() {
		window.print();
		return false;
	});
	
	$("#calendarCategories").change(function() {
		//todo: submit the containing form
		//alert('category changed');
		$(this).parent('form').submit();
	});
	
	$("#calendarReturnToCalendar").click(function() {
		history.back();
		return false;
	});
	
	$("div.more-link a").click(function() {
		$("li.extra", $(this).closest("td")).toggle();
		return false;
	});
}

$(document).ready(calendarInit);

// Add a class to ul for correct z-index of a.tip. Based on Suckerfish menu preparation for IE, found on htmldog.com - modified to use jQuery
$(document).ready(function () {
	// Set the onload event for the page to be this sfHover function
	if (window.attachEvent) {
		$(".calendar_grid td ul").mouseover(function() {
			$(this).addClass("calhover");
		}).mouseout(function() {
			$(this).removeClass("calhover");
		});
	}
});
