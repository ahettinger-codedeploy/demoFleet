jQuery.noConflict();

/* Plugin to make variable height divs equal heights */
jQuery.fn.sameHeights = function() {

 var tallest = 0;
  this.children().each(function(){
    if (jQuery(this).outerHeight() > tallest) {
      tallest = jQuery(this).outerHeight(); 
    }
  });
  jQuery(this).children().height(tallest);
};

/*---------------------------Pretty Photo--------------------------------*/	
	jQuery(function(){
		jQuery('a[data-rel]').each(function() {
			jQuery(this).attr('rel', jQuery(this).data('rel'));
		});
	   jQuery("a[rel^='prettyPhoto']").prettyPhoto({
			animation_speed: 'fast',
			slideshow: 5000,
			autoplay_slideshow: false,
			opacity: 0.50,
			show_title: false,
			allow_resize: true,
			default_width: 500,
			default_height: 344,
			counter_separator_label: '/',
			theme: 'light_square',
			horizontal_padding: 20,
			hideflash: false,
			wmode: 'opaque',
			autoplay: true,
			modal: false,
			deeplinking: false,
			overlay_gallery: true,
			keyboard_shortcuts: true,
			changepicturecallback: function(){},
			callback: function(){},
			ie6_fallback: true
			});
	});	
/*------------------------Sortable Gallery Hover---------------------------*/
     function hover_overlay() {
		
		jQuery('.hover_image img, .hover_link img, .hover_video img, .hover_slideshow img, .wall li img, .fproject ul li img, .project ul li img').hover( function() {
            jQuery(this).stop().animate({opacity : 0.2}, 500);
        }, function() {
            jQuery(this).stop().animate({opacity : 1}, 500);
        });
		
    }
    
    hover_overlay();
    
/*********** Scroll to Top ************/
jQuery(document).ready(function(){
	jQuery('#top-link').topLink({
		min: 400,
		fadeSpeed: 500
	});
});
/**************************************/    

/************ Box Grids ***************/
jQuery(document).ready(function(){
	
	// Pricing table zebra coloring
	
	// Menu arrows
	jQuery('#menu ul.sub-menu li').each(function(){
		if ((jQuery(this).find('.sub-menu').length > 0)) {
			jQuery(this).addClass('icon_sub');
		}
	});
	
	jQuery('#menu > ul > li').each(function(){
		if ((jQuery(this).find('.sub-menu').length > 0)) {
			jQuery(this).addClass('icon_drop');
		}
	});
	
	hover_overlay();
	
	// Toggles
	jQuery(".toggle-container").hide();
	jQuery(".toggle-trigger").click(function(e){
		e.preventDefault;
		jQuery(this).toggleClass("open").next().slideToggle(500);
		return false;
	});
	
	 //Tooltips
    jQuery(".tip_trigger").hover(function(){
        tip = jQuery(this).find('.tip');
        tip.show(); //Show tooltip
    	}, function() {
        	tip.hide(); //Hide tooltip
    	}).mousemove(function(e) {
        var mousex = e.pageX + 20; //Get X coodrinates
        var mousey = e.pageY + 20; //Get Y coordinates
        var tipWidth = tip.width(); //Find width of tooltip
        var tipHeight = tip.height(); //Find height of tooltip

        //Distance of element from the right edge of viewport
        var tipVisX = jQuery(window).width() - (mousex + tipWidth);
        //Distance of element from the bottom of viewport
        var tipVisY = jQuery(window).height() - (mousey + tipHeight);

        //Absolute position the tooltip according to mouse position
        tip.css({  top: mousey, left: mousex });
    });
	
	// Blog styling
	jQuery(".reply a").addClass('button regular small alignright');
	jQuery('.bottom_nav .link-list a').addClass('fade');
	jQuery(".tagcloud a").addClass('button tag small');
	jQuery(".single-comments a, .comment-listing a, .byadmin").addClass('color');
	jQuery(".post-tags a").addClass('button tag');
	
});

// Initialize Masonry
jQuery(function(){
	jQuery('#masonry-grid').masonry({itemSelector : '.masonry-item'});
});

// Initialize Tabs
jQuery(function() {
	jQuery("ul.tabs").tabs("div.panes > .pane", {effect:'fade'});
});

jQuery(function() {
	// OPACITY OF BUTTON SET TO 40%
	jQuery(".fade").css("opacity","0.40"); 
	// ON MOUSE OVER
	jQuery(".fade").hover(function () { 
		// SET OPACITY TO 100%
		jQuery(this).stop().animate({
		opacity: 1.0
		}, "slow");
	},

	// ON MOUSE OUT
	function () {
		// SET OPACITY BACK TO 40%
		jQuery(this).stop().animate({
		opacity: 0.40
		}, "slow");
	});
	
});

/*---------------------------Portfolio Description Hover Fade--------------------------------*/	
jQuery(function() {
	jQuery(".hover_slideshow a span, .hover_image a span, .hover_link a span, .hover_video a span, .recent ul a, .wall li a span, .project li a span, .wall li a span, .fproject li a span, .project li a strong, .wall li a strong, .fproject li a strong").css("opacity","0");
	
	jQuery(".hover_slideshow > a, .hover_image > a, .hover_link > a, .hover_video > a, .wall li a, .project li a, .fproject li a").hover(function () { 
			jQuery(this).find('span, strong').stop().animate({opacity: 1.0}, "slow");		
		},
		// ON MOUSE OUT
		function () {
			jQuery(this).find('span, strong').stop().animate({opacity: 0}, "fast");
		}
	);
	
});

/********* Contact Widget *************/
function checkemail(emailaddress){
	var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i); 
	return pattern.test(emailaddress); 
}

jQuery(document).ready(function(){ 
	jQuery('#registerErrors, .widgetinfo').hide();								
	jQuery('#contactFormWidget input#wformsend').click(function(){ 
		var $name 	= jQuery('#wname').val();
		var $email 	= jQuery('#wemail').val();
		var $message = jQuery('#wmessage').val();
		var $subject = jQuery('#wsubject').val();
		var $contactemail = jQuery('#wcontactemail').val();
		var $contacturl = jQuery('#wcontacturl').val();
		var $mywebsite 	= jQuery('#wcontactwebsite').val();
		
		if ($name != '' && $name.length < 3){ $nameshort = true; } else { $nameshort = false; }
		if ($name != '' && $name.length > 30){ $namelong = true; } else { $namelong = false; }
		if ($email != '' && checkemail($email)){ $emailerror = true; } else { $emailerror = false; }
		if ($message != '' && $message.length < 3){ $messageshort = true; } else { $messageshort = false; }
		
		jQuery('#contactFormWidget .loading').animate({opacity: 1}, 250);
		
		if ($name != '' && $nameshort != true && $namelong != true && $email != '' && $emailerror != false && $message != '' && $messageshort != true && $contactemail != '' && $contacturl != '' && $mywebsite != ''){ 
			jQuery.post($contacturl, 
				{type: 'widget', contactemail: $contactemail, name: $name, email: $email, message: $message, subject: $subject}, 
				function(data){
					jQuery('#contactFormWidget .loading').animate({opacity: 0}, 250);
					jQuery('.form').fadeOut();
					jQuery('#bottom #wname, #bottom #wemail, #bottom #wmessage').css({'border':'0'});
					jQuery('.widgeterror').hide();
					jQuery('.widgetinfo').fadeIn('slow');
					jQuery('.widgetinfo').delay(2000).fadeOut(1000, function(){ 
						jQuery('#wname, #wemail, #wmessage, #wsubject').val('');
						jQuery('.form').fadeIn('slow');
					});
				}
			);
			
			return false;
		} else {
			jQuery('#contactFormWidget .loading').animate({opacity: 0}, 250);
			jQuery('.widgeterror').hide();
			jQuery('.widgeterror').fadeIn('fast');
			jQuery('.widgeterror').delay(3000).fadeOut(1000);
			
			if ($name == '' || $nameshort == true || $namelong == true){ 
				jQuery('#wname').css({'border':'1px solid #941e1c'}); 
			} else { 
				jQuery('#wname').css({'border':'1px solid #787878'}); 
			}
			
			if ($email == '' || $emailerror == false){ 
				jQuery('#wemail').css({'border':'1px solid #941e1c'}); 
			} else { 
				jQuery('#wemail').css({'border':'1px solid #787878'}); 
			}
			
			if ($message == '' || $messageshort == true){ 
				jQuery('#wmessage').css({'border':'1px solid #941e1c'}); 
			} else { 
				jQuery('#wmessage').css({'border':'1px solid #787878'}); 
			}
			
			return false;
		}
	});
});

// jQuery Input Hints plugin
// Copyright (c) 2009 Rob Volk
// http://www.robvolk.com
jQuery.fn.inputHints=function(){jQuery(this).each(function(i){jQuery(this).val(jQuery(this).attr('title'));});jQuery(this).focus(function(){if(jQuery(this).val()==jQuery(this).attr('title'))
jQuery(this).val('');}).blur(function(){if(jQuery(this).val()=='')
jQuery(this).val(jQuery(this).attr('title'));});};


jQuery(document).ready(function() {
    jQuery('input[title], textarea[title]').inputHints();
	jQuery('.socialbar a').click( function() {
        window.open(this.href);
        return false;
    });
});

/**
 * jQuery.fullBg
 * Version 1.0
 * Copyright (c) 2010 c.bavota - http://bavotasan.com
 * Dual licensed under MIT and GPL.
 * Date: 02/23/2010
**/
(function($) {
	$.fn.fullBg = function(){
		var bgImg = $(this);
		
		bgImg.addClass('fullBg');
		
		function resizeImg() {
			var imgwidth = bgImg.width();
			var imgheight = bgImg.height();
			
			var winwidth = $(window).width();
			var winheight = $(window).height();
				
			var widthratio = winwidth/imgwidth;
			var heightratio = winheight/imgheight;
			
			var widthdiff = heightratio*imgwidth;
			var heightdiff = widthratio*imgheight;
			
			if(heightdiff>winheight) {
				bgImg.css({
					width: winwidth+'px',
					height: heightdiff+'px'
				});
			} else {
				bgImg.css({
					width: widthdiff+'px',
					height: winheight+'px'
				});		
			}
		} 
		resizeImg();
		$(window).resize(function() {
			resizeImg();
		}); 
	};
})(jQuery)
/**************************************/