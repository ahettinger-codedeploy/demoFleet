// Initialise cycle slideshow
$(document).ready(function() {
    $('.slideshow').cycle({
		fx: 'fade',
		timeout: '6000' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
	});
    $('.slideshow2').cycle({
		fx: 'scrollUp',
		timeout: '6000' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
	});
});


// Search field disappearing text
jQuery(document).ready(function() {
    var initial = "Search...";
    var empty = "";
    jQuery(".SearchTextBox").val(initial);
    jQuery(".SearchTextBox").focus(function(){
        if (jQuery(this).val() == initial) {
        jQuery(this).val("");
        }
    }).blur(function(){
        if (jQuery(this).val() == empty) {
        jQuery(this).val(initial);
    }
    });
});


// Initialise font settings
Cufon.replace('h1, h2, h3, h4, h5', { fontFamily: 'GeosansLight', textShadow: '2px 2px 1px rgba(0, 0, 0, 0.25)' });
Cufon.replace('.wsc_lh_white h1, .wsc_lh_white h2, .wsc_lh_white h3, .wsc_lh_white h4, .wsc_lh_white h5', { fontFamily: 'GeosansLight' });
$(document).ready(function () {
    $('h1, h2, h3, h4, h5').addClass("cufonApplied");
});


// Creating additional blocks for feedback send button
jQuery(document).ready(function() {
    $(".Feedback_CommandButtons a.CommandButton").addClass("button").wrapInner("<span><strong></strong></span>");
});

// Fancybox initialization
$(document).ready(function() {
    $(".wsc_recent_projects ul li a[rel=wsc_group]").fancybox({
		'overlayShow'	: false,
		'transitionIn'	: 'elastic',
		'transitionOut'	: 'elastic'
    });
});

$(".dnnForm.dnnSearchResults table tr").removeClass("dnnGridItem dnnGridAltItem");