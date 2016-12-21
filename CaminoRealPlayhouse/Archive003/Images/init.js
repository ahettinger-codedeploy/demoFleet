jQuery(document).ready(function() {
  	
  
	/* for press releases show all press releases button */
        jQuery('#show_older_press').click(function(){
        jQuery('#old_press_releases').show();
        jQuery('#show_older_press').hide();

});
	/* Search form auto-clear */
	
	var searchLabel = "SEARCH";
	
	jQuery('#search_for').val(searchLabel);
	jQuery('#search_for').focus(function() {
		if(jQuery(this).val(searchLabel)){
			jQuery(this).val("");
		};
	});

	jQuery('#search_for').blur(function() {
		if(jQuery(this).val() == ""){
			jQuery(this).val(searchLabel).addClass("default");
		};
	});

	/* Mailing list go - form auto-clear */
	
	var searchLabel2 = "JOIN MAILING LIST";
	
	jQuery('#join_mailing_list').val(searchLabel2);
	jQuery('#join_mailing_list').focus(function() {
		if(jQuery(this).val(searchLabel2)){
			jQuery(this).val("");
		};
	});

	jQuery('#join_mailing_list').blur(function() {
		if(jQuery(this).val() == ""){
			jQuery(this).val(searchLabel2).addClass("default");
		};
	});
	
	
	/* Zebrastriping for TRs */


	jQuery('table.stripe_me tr').mouseover(function(){ jQuery(this).addClass("over");});
	jQuery('table.stripe_me tr').mouseout(function(){ jQuery(this).removeClass("over");});
	jQuery('table.stripe_me tr:odd').addClass("alt");
	
	
	jQuery('li.show_day').cluetip({ 
		height: 'auto',
		sticky: true,
		dropShadow: false,
		positionBy: 'mouse', 
		mouseOutClose: true,
		arrows: true,
		closePosition:    'top',
		closeText:        '<img src="_px/btn_close_tooltip.png" />',
		fx: {             
			open:       'fadeIn',
			openSpeed:  '500' 
		}
	});	

	jQuery('a.grid_show_bubble').cluetip({ 
		height: 'auto',
		sticky: true,
		dropShadow: false,
		width: 400,
		positionBy: 'bottomTop', 
		mouseOutClose: true,
		arrows: true,
		closePosition:    'top',
		closeText:        '<img src="_px/btn_close_tooltip.png" />',
		fx: {             
			open:       'fadeIn',
			openSpeed:  '500' 
		}
	});	


/* MOUSEOVER MENUS FOR MAIN NAV */

	// First, check to see if the new menu we're 
	// creating is too close to the right edge
	// of the screen
	
	jQuery.fn.tooClose = function() {
	
		// Basically, screen width minus right edge (left offset + width)
		if(document.body.offsetWidth - (jQuery(this).offset().left + jQuery(this).width()) < 1){
			return true
		};
	};

	jQuery("#main_navigation > li").hoverIntent(

		  // OVER
		  function(){
			
			// Slide the menu down			
			jQuery(this).children("ul:first").stop(true, true).slideDown("fast");
			
			// Change the state of the evoking a to show where we are
			jQuery(this).find("a", this).css("background-position", "center");
				
			// Check to see if we're too close	
			if(jQuery(this).children("ul:first").tooClose()){
			
				// If we are, put us right against the edge of the screen
				jQuery(this).children("ul:first").css("right","0");
			};


		
		
		  }, 
		  
		  // OUT
		  function(){
			jQuery(this).children("ul:first").stop(true, true).slideUp("fast", function(){
				// Reset the value when they go away
				jQuery(this).css("right","auto");
			});
			
			// Reset the position of the background element
			jQuery("a", this).css("background-position", "bottom");			
		  }
		  
	);
	

	jQuery("#main_navigation li ul li").hover(
		function(){
				
			jQuery(this).children("ul:first").stop(true, true).slideDown("fast");			
			jQuery(this).find("a:first").css("color","#ff0000");			
		},
		
		function(){
			jQuery(this).children("ul:first").stop(true, true).fadeOut("fast");
			jQuery(this).find("a:first").css("color","#fff");
		}
	);
	
	
//=========================================
//		Cross browser adjustments
//=========================================	

if (jQuery.browser.msie){

	// IE6 Exceptions
	if(jQuery.browser.version.substr(0,1) == "6"){
		
	}

	
	// IE7 Exceptions
	if(jQuery.browser.version.substr(0,1) == "7"){
		jQuery(".rail.wide.right p").css("max-width","none");
		jQuery("ul.grid_calendar.big li ul.events li").css("width","133px");
		jQuery("#donate_btn").val("");
		jQuery("body.homepage a.small_cap").css("margin", "0 0 10px");
		jQuery(".rail.center .list.big .text").css("width","250px");
		jQuery(".giant .list.big .text").css("width","750px");
		jQuery("#search_for").css("width","500px");
		jQuery(".rail.wide.left .list.big .text").css("width","500px");
		jQuery(".rail.wide h1").css({
			"float" : "none",
			"background" : "none",
			"color"	: "#002f59",
			"padding" : "0",
			"font-size" : "1.7em"
		});
	}

	// IE8 Exceptions
	if(jQuery.browser.version.substr(0,1) == "8"){
		jQuery("body.homepage a.small_cap").css("margin", "0 0 20px");
	}

	
	
} // End IE Check


jQuery(".row:last").css({
	"border" : "none",
	"margin" : "0"
	}
);

jQuery(".list li:last-child").css({
	"border" : "none",
	"margin" : "0"
	}
);

jQuery(".list li:only-child").css({
	"border" : "none",
	"margin" : "0"
	}
);

jQuery(".rail.center p:only-child").css({
	"margin" : "0 0 5px"
	}
);

	
	

	
	
	
});


