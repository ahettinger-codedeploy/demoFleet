/* Global Variables */
var isMobile = false; // Use for mobile features 
var isIE = typeof document.all != 'undefined'; // IE detection
var navAnimWaiting = false; // navigation variables;
var navAnimWaitTime = 350;
var navClosedHeight = 41;

/* Mobile Browser Detection - regex from http://detectmobilebrowsers.com/ - rewrote redirection to instead add responsive.css to head */
(function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)))isMobile=true;})(navigator.userAgent||navigator.vendor||window.opera);

/* Page Load */

if (isMobile) {
	var h=document.getElementsByTagName('head')[0];
	var l=document.createElement('link');
	l.rel='stylesheet';
	l.type='text/css';
	l.href='/reskin/css/responsive.css';
	l.media='all';
	h.appendChild(l);
}

jQuery(document).ready(function(){
	jQuery.extend( jQuery.easing,
	{
		easeOutQuart: function (x, t, b, c, d) {
			return -c * ((t=t/d-1)*t*t*t - 1) + b;
		}
	});

	jQuery.fn.extend({
		pause: function(duration) {
			jQuery(this).stop().animate({ dummy: 1 }, duration);
			return this;
		},
	
		/* Equal Heights Plugin by:	Scott Jehl, Todd Parker, Maggie Costello Wachs (http://www.filamentgroup.com) */
		equalHeights: function() {
			var tallest = 0;
			jQuery(this).each(function(){
				var t = jQuery(this);
				if (t.height() > tallest) tallest = t.height();
			});
			if (isIE) jQuery(this).css('height', tallest);
			jQuery(this).css('min-height', tallest); 
			return this;
		}
	});
	
	/* Set Page-Content Height */
	var contentArea = jQuery('#main');
	minHeight = jQuery(window).height() - jQuery('header').outerHeight(true) - jQuery('footer').outerHeight(true) - 1;
	if (!isMobile && contentArea.outerHeight() < minHeight) contentArea.css("min-height", minHeight + "px");
	
	/* Set Subnavigation Items to Equal Height */
	jQuery("nav.home-nav ul.sub-nav").equalHeights();
	jQuery("nav.site-nav ul.main ul.sub-nav").equalHeights();
	
	/* Set Site Navigation Widths */
	if (jQuery("nav.site-nav ul.site").length > 0) {
		var snav = jQuery("nav.site-nav");
		var lis = jQuery("nav.site-nav ul.site li");
		var avgw = parseInt(snav.find("ul.site").outerWidth() / lis.length * 1.1);
		var els = 0;
		lis.each(function(){if (jQuery(this).outerWidth() < avgw) els++; else jQuery(this).css("width", jQuery(this).outerWidth() + 1);});
		var extrapx = parseInt((snav.outerWidth() - snav.find("ul.site").outerWidth() - (lis.length - els)) / els);
		lis.each(function(){ if (jQuery(this).outerWidth() < avgw) jQuery(this).css("width", jQuery(this).outerWidth() + extrapx); });
		extrapx = snav.outerWidth() - snav.find("ul.site").outerWidth();
		if (extrapx > 0) lis.last().css("width", lis.last().outerWidth() + extrapx);
	}
	
	/* Push down nav method */
	if (!isMobile) {
		jQuery("nav.home-nav a").focus(function(){jQuery("nav.home-nav").mouseenter();});
		jQuery("a:not(nav.home-nav a)").focus(function(){jQuery("nav.home-nav").mouseleave();});
		jQuery("nav.home-nav").mouseenter(function(){
			jQuery(this).stop().pause(60).animate({ height: jQuery('nav.home-nav > ul').outerHeight() }, navAnimWaitTime, "easeOutQuart" );
		}).mouseleave(function(){
			jQuery(this).stop().pause(60).animate({ height: String(navClosedHeight) + 'px' }, navAnimWaitTime, "easeOutQuart" );
		});
		
		/*jQuery("#main-nav").hover(function(){
			if (!navAnimWaiting) {
				navAnimWaiting = true;
				jQuery("#main-nav").animate({'height' : jQuery('#main-nav ul.sub-nav').first().outerHeight() + navClosedHeight }, navAnimWaitTime);
				setTimeout("navAnimWaiting=false", navAnimWaitTime);
			}
		},function(){
			if (!navAnimWaiting) {
				navAnimWaiting = true;
				jQuery("#main-nav").animate({'height' : String(navClosedHeight) + 'px' }, navAnimWaitTime);
				setTimeout("navAnimWaiting=false", navAnimWaitTime);
			}
		});*/
	}
	else {
		jQuery("nav.home-nav > ul > li > a").click(function(){
			var $nav = jQuery("nav.home-nav");
			var animTo = navClosedHeight;
			if($nav.height() == navClosedHeight) animTo = jQuery('nav.home-nav > ul').outerHeight();
			$nav.animate({ height: animTo }, navAnimWaitTime, "easeOutQuart" );
			jQuery("nav ul.sub-nav li.has-child ul").hide();
		});
	}
	
	/* Expand AU Menu Nav */
	jQuery("nav.site-nav ul.main").hide().css("visibility","visible");
	jQuery("div.expand-tab > span").click(function(){
		if (jQuery("nav.site-nav ul.main").is(":visible")) {
			jQuery("nav.site-nav ul.main").slideUp(navAnimWaitTime);
		}
		else {
			jQuery("nav.site-nav ul.main").slideDown(navAnimWaitTime);
		}
	});
	
	/* Expand AU Sub Nav Child */
	if (!isMobile) {
		jQuery("nav ul.sub-nav li.has-child > a").append(' <span class="arrow"></span>');
		if(isIE && parseFloat(navigator.appVersion.split("MSIE")[1]) < 9) jQuery("nav ul.sub-nav li.has-child").parent().parent().css({ 'position' : 'relative', 'z-index' : '100'});
		var sub_nav_hover = [];
		jQuery("nav ul.sub-nav li.has-child").hover(function(){
			var $t = jQuery(this);
			$t.addClass("hover");
			if (sub_nav_hover[$t.index()] == null) {
				var pos = 150;
				if($t.parents("nav").outerWidth() - $t.parent().parent().position().left < 400) pos*=-1.75;
				$t.children("ul").css("left", pos);
				$t.children("ul").each(function(){
					var w = jQuery(this).width();
					jQuery(this).css("width", 0).show().animate({ 'width' :  w}, 300);
				});
			}
		}, function(){
			$t = jQuery(this);
			$t.removeClass("hover");
			sub_nav_hover[$t.index()] = setTimeout(function(){if (!$t.hasClass("hover")) $t.children('ul').hide(); sub_nav_hover[$t.index()] = null;}, 400);
		});
	}
	
	/* Open Search Options on Focus */
	jQuery('#search-box-reskin input.search').click(function() { jQuery('#search-detail').slideDown(200);});
	jQuery('#login-reskin a').click(function() { if(jQuery('#login-detail').is(':visible')) jQuery('#login-detail').slideUp(200); else jQuery('#login-detail').slideDown(200);});
	
	jQuery(document).mouseup(function (e)
	{
	    if (!jQuery('#search-detail').is(e.target) && jQuery('#search-box-reskin').has(e.target).length === 0 && jQuery('#search-detail').has(e.target).length === 0)
	    {
	        jQuery('#search-detail').slideUp(200);
	    }
	    if (!jQuery('#login-detail').is(e.target) && !jQuery('#login-reskin a').is(e.target) && jQuery('#login-reskin a').has(e.target).length === 0 && jQuery('#login-detail').has(e.target).length === 0)
	    {
	        jQuery('#login-detail').slideUp(200);
	    }
	    if (!jQuery('nav.site-nav').is(e.target) && jQuery('nav.site-nav').has(e.target).length === 0)
	    {
	    	jQuery('nav.site-nav ul.main').slideUp(200);
	    }
	});
	
	jQuery(document).keyup(function(e) {
    if (e.keyCode == 27) {
        jQuery('#search-detail').slideUp(200);
		jQuery('#login-detail').slideUp(200);
		jQuery("nav.site-nav ul.main").slideUp(200);
    }
	if (e.keyCode == 13 && jQuery('#search-detail').is(':visible')) {
		jQuery('#search-reskin').submit();
	}
});

	/* Overlay nav method
	if (!isMobile) {
		jQuery("#main-nav").hover(function(){
			if (!navAnimWaiting) {
				navAnimWaiting = true;
				jQuery("#main-nav ul.sub-nav").slideDown(navAnimWaitTime, function(){navAnimWaiting=false;});
			}
		},function(){
			if (!navAnimWaiting) {
				navAnimWaiting = true;
				jQuery("#main-nav ul.sub-nav").slideUp(navAnimWaitTime, function(){navAnimWaiting=false;});
			}
		});
	} */
});