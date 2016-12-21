/*Dropdownmegamenu javascript to delay the disappearance of the menu when the user mouses out.  Uses jquery library.*/

$(document).ready(function() {

	var timer =null;
	var timer2 =null;
	var delay = 300; //change this number for shorter or longer delay
	var delay2 = 300;//delay when mousing over
	
	//hide the dropdowns via javascript so that they will still work if you do not have javascript enabled.
	$('.megamenu_container').css('display','none');
	
	$("#dropdownmegamenu > ul > li").hover(
	
		//what happens on hover over
   	 	 function(){
		 	//end timers and stop hiding if they are mousing back in.
		 	if (timer != null) {
		 		clearTimeout(timer);
				timer=null;
			}
			if (timer2 != null) {
		 		clearTimeout(timer2);
				timer2=null;
			}
       	 	// Find the hovered menu's sub-menu
			var $menu = $(this);
        	var $submenu = $(this).find('.megamenu_container');

        	// hide any other submenus that are open
        	$('.megamenu_container').not($submenu).css('display','none');
			$('.megamenu_over').not($menu).removeClass('megamenu_over');

        	// show current menu, with delay
        	timer2=setTimeout(function(){$submenu.css('display','block');$menu.addClass('megamenu_over');timer2=null;}, delay2);
    	},
		
		//what happens on mouse out
		function(){
    		var $submenu = $(this).find('.megamenu_container');
			var $menu = $(this);
			// delay disappearance
			timer = setTimeout(function(){$submenu.css('display','none');$menu.removeClass('megamenu_over'); timer=null;}, delay);
			//clear show timer, if mousing out before menu appeared
			if (timer2 != null) {
		 		clearTimeout(timer2);
				timer2=null;
			}
		}
		
	)

});

