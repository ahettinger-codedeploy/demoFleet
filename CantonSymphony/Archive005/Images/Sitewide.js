/*jslint onevar: true, browser: true, undef: true, nomen: true, eqeqeq: true, plusplus: true, bitwise: true, regexp: true, newcap: true, immed: true */
// Suckerfish menu preparation for IE, found on htmldog.com - modified to use jQuery
$(document).ready(function () {
	// Set the onload event for the page to be this sfHover function
	if (window.attachEvent) {
		$("ul.menu > li").not("ul.menu > li li").mouseover(function() {
			$(this).addClass("sfhover");
		}).mouseout(function() {
			$(this).removeClass("sfhover");
		});
	}
});

//Initialize Javascript on site load
function init()
{
	$('.searchform-query').click(function() {
		this.select();
	});
	$('.selectOnClick').click(function() {
		this.select();
	});
}
$(document).ready(init);

