$(document).ready(function () {
	$('.noclick').click(function (event) { 
		event.preventDefault(); 
	});
	
	$('ul.sf-menu').superfish({
		speed:       'fast',
		onBeforeShow:  function(){ $("#menu-item-529 > .sub-menu").css("left",-135); }
	});
     
     
    $('ul#menu-main').mobileMenu({
	    switchWidth: 980,                   //width (in px to switch at)
	    topOptionText: ' - Navigate and Discover Downtown Shreveport! - ',     //first option text
	    indentString: '&nbsp;&nbsp;&nbsp;'  //string for indenting nested items
	});
});

    