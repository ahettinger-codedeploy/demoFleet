
/**
 * 
 * credits for this plugin go to brandonaaron.net
 * 	
 * unfortunately his site is down
 * 
 * @param {Object} up
 * @param {Object} down
 * @param {Object} preventDefault
 */
jQuery.fn.extend({
	mousewheel: function(up, down, preventDefault) {
		return this.hover(
			function() {
				jQuery.event.mousewheel.giveFocus(this, up, down, preventDefault);
			},
			function() {
				jQuery.event.mousewheel.removeFocus(this);
			}
		);
	},
	mousewheeldown: function(fn, preventDefault) {
		return this.mousewheel(function(){}, fn, preventDefault);
	},
	mousewheelup: function(fn, preventDefault) {
		return this.mousewheel(fn, function(){}, preventDefault);
	},
	unmousewheel: function() {
		return this.each(function() {
			jQuery(this).unmouseover().unmouseout();
			jQuery.event.mousewheel.removeFocus(this);
		});
	},
	unmousewheeldown: jQuery.fn.unmousewheel,
	unmousewheelup: jQuery.fn.unmousewheel
});


// Tooltip from CSS Globe written by Alen Grakalic (http://cssglobe.com)

this.tooltip = function(){xOffset = -10;yOffset = 10;jQuery.noConflict();jQuery(".tooltip").hover(function(e){this.t = this.title;this.title = "";jQuery("body").append("<p class='itooltip'>"+ this.t +"</p>");jQuery(".itooltip").css("top",(e.pageY - xOffset) + "px").css("left",(e.pageX + yOffset) + "px").fadeIn(500);},function(){this.title = this.t; jQuery(".itooltip").remove();});jQuery("a.tooltip").mousemove(function(e){jQuery(".itooltip").css("top",(e.pageY - xOffset) + "px").css("left",(e.pageX + yOffset) + "px");});};
//END TOOLTIP


//MOLITOR SCRIPTS

this.molitorscripts = function () {

	
	//DEFINE VARIABLES
	var notitle = "#dropmenu a",
	    opacity = ".60",
	    opaque = ".collapse",
		browserName = navigator.appName;	


	//VARIABLE OPACITY SETTINGS
	jQuery(opaque).stop(true,true).animate({opacity : opacity}, 300);
	jQuery(opaque).hover(function() {
		jQuery(this).stop(true,true).animate({opacity : '1'}, 300);
		}, function() {
		jQuery(this).stop(true,true).animate({opacity : opacity}, 300);
	});

	//REMOVE TITLE ATTRIBUTE
	jQuery(notitle).removeAttr("title");
	
	//DEFINE VARIABLES BASED ON BROWSER BEING USED
	if (browserName != "Microsoft Internet Explorer"){
    var arrow = "#dropmenu ul li ul";	
	}
	else {
	var arrow = "#dropmenu ul li ul";
	}
	
	//MENU
	jQuery("#dropmenu ul").css("display", "none"); // Opera Fix
	jQuery("#dropmenu li").hover(function(){
		jQuery(this).find('ul:first').slideDown(200);
		},function(){
		jQuery(this).find('ul:first').slideUp(200);
	});
	jQuery(arrow).parent().children("a").prepend("<span style='float:right;'>&rsaquo;</span>");
	
	jQuery(function() {
	var zIndexNumber = 1000;
	//jQuery('div').each(function() {
	//	jQuery(this).css('zIndex', zIndexNumber);
	//	zIndexNumber -= 10;
	//});
	});
	
	//Show Banner
	jQuery(".main_image .desc").show(); //Show Banner
	jQuery(".main_image .block").stop(true,true).animate({ opacity: 0.85 }, 1 ); //Set Opacity
	//Click and Hover events for thumbnail list
	jQuery(".image_thumb ul li:first").addClass('active'); 
	jQuery(".image_thumb ul li").click(function(){ 
		//Set Variables
		var imgAlt = jQuery(this).find('img').attr("alt"); //Get Alt Tag of Image
		var imgTitle = jQuery(this).find('span img').attr("src"); //Get Main Image URL
		var imgDesc = jQuery(this).find('.block').html(); 	//Get HTML of block
		var imgDescHeight = jQuery(".main_image").find('.block').height();	//Calculate height of block	
		
		if (jQuery(this).is(".active")) {  //If it's already active, then...
			return false; // Don't click through
		} else {
			//Animate the Teaser				
			jQuery(".main_image .block").stop(true,true).animate({ opacity: 0, marginBottom: -imgDescHeight }, 250 , function() {
				jQuery(".main_image .block").html(imgDesc).stop(true,true).animate({ opacity: 0.85,	marginBottom: "0" }, 250 );
				jQuery(".main_image img").attr({ src: imgTitle , alt: imgAlt});
			});
		}
		
		jQuery(".image_thumb ul li").removeClass('active'); //Remove class of 'active' on all lists
		jQuery(this).addClass('active');  //add class of 'active' on this list only
		return false;
		
	}) .hover(function(){
		jQuery(this).addClass('hover');
		}, function() {
		jQuery(this).removeClass('hover');
	});	
	//Toggle Teaser
	jQuery("a.collapse").click(function(){
		jQuery(".main_image .block").slideToggle();
		jQuery("a.collapse").toggleClass("show");
		return false; //NEW
	});
	
	//TABS
	jQuery(function () {
    var tabContainers = jQuery('#tabs > div');
    
    jQuery('#tabs h2.tabNavigation a').click(function () {
        tabContainers.hide().filter(this.hash).fadeIn(350);
        
        jQuery('#tabs h2.tabNavigation a').removeClass('selected');
        jQuery(this).addClass('selected');
        
        return false;
    }).filter(':first').click();
	
});

	
	
}

//END MYSCRIPTS

jQuery.noConflict(); jQuery(document).ready(function(){molitorscripts(); tooltip();  });