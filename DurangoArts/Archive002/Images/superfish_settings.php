
jQuery(document).ready(function() {
	jQuery("ul.sf-menu").superfish({
		animation:     {opacity:"show",height:"show"},  // fade-in and slide-down animation
		delay:        0,                            // delay on mouseout
		speed:        1,  // animation speed
		autoArrows:   "",  // enable generation of arrow mark-up
		dropShadows:  ""  // enable drop shadows
	});
});