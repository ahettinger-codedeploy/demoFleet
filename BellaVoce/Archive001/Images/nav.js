//////////////////////////////////////////////////////
//
//	The purpose of this file is to
//	apply a hover class on mouseover
//	on the <li> elements in the nav.
//	This is because IE doesn't put
//	the pseudo class :hover on <li> elements
//
//	This is code that uses the
//	jquery javascript library (http://jquery.com/)
//
//////////////////////////////////////////////////////
$(window).load(function() {
	if (document.all&&document.getElementById) {
		// this is needed for the IE 6 pseudo hover class bug
		$(".navtop li").hover(function () {
			$(this).addClass("hover");
		},function () {
			$(this).removeClass("hover");
		});
	} else {
		// this is need for safari when nav covers flash
		$(".navtop li ul").hover(function () {
			$(this).addClass("redraw");
		},function () {
			$(this).removeClass("redraw");
		});
	}
});
