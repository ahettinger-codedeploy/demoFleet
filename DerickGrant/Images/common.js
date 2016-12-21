jQuery(document).ready(function(){

	jQuery('.homemenu ul.menu').superfish({
		animation:   {height:'show'},
		speed:         'fast',
		autoArrows:  true,
		dropShadows: true
		});
	jQuery(".homemenu ul ul li").css({"display":"block"});
  
	//Sidebar toggle function
	jQuery(".menu-toggle-off").live('click',function () {
		jQuery(".social-header").css({"visibility":"hidden"});
		jQuery("#slidecaption").css({"visibility":"hidden"});
		jQuery('.container').stop().animate({left:'-1050','opacity':'0'},500, function() {
			jQuery(".container").css({"display":"none"});
		});
		jQuery(".homemenu").stop().animate({'opacity':'0'},150, function() {
			jQuery(".mainmenu-navigation").css({"display":"none"});
		});
		jQuery('.menu-toggle').removeClass('menu-toggle-off');
		jQuery('.menu-toggle').addClass('menu-toggle-on');
		jQuery('.mcycletextwrap').css({"visibility":"hidden"});
	  });
	
	//Sidebar toggle function
	jQuery(".menu-toggle-on").live('click',function () {
		
			jQuery(".homemenu").stop().animate({'opacity':'1'},500);
			jQuery(".mainmenu-navigation").css({"display":"block"});
			jQuery('.menu-toggle').removeClass('menu-toggle-on');
			jQuery('.menu-toggle').addClass('menu-toggle-off');
			jQuery(".container").css({"display":"block"});
			jQuery("#slidecaption").css({"visibility":"visible"});
			jQuery('.container').stop().animate({left:'0','opacity':'1'},500);
			jQuery('.mcycletextwrap').css({"visibility":"visible"});	
			jQuery(".social-header").css({"visibility":"visible"});
	});
	
	// Responsive dropdown list triggered on Mobile platforms
    jQuery('#top-select-menu').bind('change', function () { // bind change event to select
        var url = jQuery(this).val(); // get selected value
        if (url != '') { // require a URL
            window.location = url; // redirect
        }
        return false;
    });

	jQuery("a[rel^='prettyPhoto']").prettyPhoto({
		theme:'dark_rounded',
		opacity: 0.9,
		deeplinking: false,
		overlay_gallery: false,
		show_title: false,
		social_tools: false
	});
	
	//Switch the "Open" and "Close" state per click then slide up/down (depending on open/close state)
	jQuery("h4.trigger").click(function(){
		jQuery(this).toggleClass("active").next().slideToggle("fast");
		return false;
	});
	jQuery('h4.trigger').trigger('click');	
	
	jQuery(".postformat-image-lightbox img").fadeTo("fast", 0.8);
	jQuery(".postformat-image-lightbox img").hover(
	function () {
	  jQuery(this).stop().fadeTo("fast", 0.9);
	},
	function () {
	  jQuery(this).stop().fadeTo("fast", 0.8);
	});
	
	jQuery("#main-portfolio-carousel .preload").hover(
	function () {
	  jQuery(this).stop().fadeTo("fast", 0.6);
	},
	function () {
	  jQuery(this).stop().fadeTo("fast", 1);
	});
	
	jQuery(".portfolio-image-holder").hover(
	function () {
	  jQuery(this).stop().fadeTo("fast", 0.6);
	},
	function () {
	  jQuery(this).stop().fadeTo("fast", 1);
	});
	
	jQuery(".thumbnail-image").hover(
	function () {
	  jQuery(this).stop().fadeTo("fast", 0.6);
	},
	function () {
	  jQuery(this).stop().fadeTo("fast", 1);
	});
	
	jQuery(".pictureframe").hover(
	function () {
	  jQuery(this).stop().fadeTo("fast", 0.6);
	},
	function () {
	  jQuery(this).stop().fadeTo("fast", 1);
	});
	
	jQuery(".filter-image-holder").hover(
	function () {
	  jQuery(this).stop().fadeTo("fast", 0.6);
	},
	function () {
	  jQuery(this).stop().fadeTo("fast", 1);
	});
	
	
	jQuery('.qtips').tipsy({gravity: 'n'});
	jQuery('.etips').tipsy({gravity: 'e'});
	jQuery('.stips').tipsy({gravity: 's'});
    
});

jQuery(function () {
	jQuery('.portfolio-thumbnail-block').hide();
	jQuery('.filter-thumbnail-block').hide();
});

var i = 0;//initialize
var int=0;//Internet Explorer Fix
jQuery(window).bind("load", function() {
	var int = setInterval("doThis(i)",10);

	jQuery('.filter-thumbnail-loader').hide();
	jQuery('.filter-thumbnail-block:hidden').fadeIn(800);

});

function doThis() {
	var images = jQuery('.portfolio-image-holder').length;
	if (i >= images) {
		clearInterval(int);
	}
	jQuery('.thumbnail-loader').eq(i).fadeOut(0);
	jQuery('.portfolio-thumbnail-block:hidden').eq(0).fadeIn(800);
	i++;
}