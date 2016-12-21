/**
 * Handles toggling the navigation menu for small screens.
 */
( function() {
	var container, button, menu;

	container = document.getElementById( 'site-navigation' );
	if ( ! container ) {
		return;
	}

	button = container.getElementsByTagName( 'button' )[0];
	if ( 'undefined' === typeof button ) {
		return;
	}

	menu = container.getElementsByTagName( 'ul' )[0];

	// Hide menu toggle button if menu is empty and return early.
	if ( 'undefined' === typeof menu ) {
		button.style.display = 'none';
		return;
	}

	menu.setAttribute( 'aria-expanded', 'false' );

	if ( -1 === menu.className.indexOf( 'nav-menu' ) ) {
		menu.className += ' nav-menu';
	}

	button.onclick = function() {
		if ( -1 !== container.className.indexOf( 'toggled' ) ) {
			container.className = container.className.replace( ' toggled', '' );
			button.setAttribute( 'aria-expanded', 'false' );
			menu.setAttribute( 'aria-expanded', 'false' );
		} else {
			container.className += ' toggled';
			button.setAttribute( 'aria-expanded', 'true' );
			menu.setAttribute( 'aria-expanded', 'true' );


		}
	};
} )();

/**
 * Skip link focus fix
 */
( function() {
	var is_webkit = navigator.userAgent.toLowerCase().indexOf( 'webkit' ) > -1,
	    is_opera  = navigator.userAgent.toLowerCase().indexOf( 'opera' )  > -1,
	    is_ie     = navigator.userAgent.toLowerCase().indexOf( 'msie' )   > -1;

	if ( ( is_webkit || is_opera || is_ie ) && document.getElementById && window.addEventListener ) {
		window.addEventListener( 'hashchange', function() {
			var element = document.getElementById( location.hash.substring( 1 ) );

			if ( element ) {
				if ( ! /^(?:a|select|input|button|textarea)$/i.test( element.tagName ) )
					element.tabIndex = -1;

				element.focus();
			}
		}, false );
	}
})();

/**
 * Parallax Section
 */
( function() {
    var isMobile = {
        Android: function() {
            return navigator.userAgent.match(/Android/i);
        },
        BlackBerry: function() {
            return navigator.userAgent.match(/BlackBerry/i);
        },
        iOS: function() {
            return navigator.userAgent.match(/iPhone|iPad|iPod/i);
        },
        Opera: function() {
            return navigator.userAgent.match(/Opera Mini/i);
        },
        Windows: function() {
            return navigator.userAgent.match(/IEMobile/i);
        },
        any: function() {
            return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
        }
    };

    var testMobile = isMobile.any();

    jQuery('.wpc_row_parallax').each(function() {
		var $this = jQuery(this);
		var bg    = $this.find('.wpc_parallax_bg');
        
        jQuery(bg).css('backgroundImage', 'url(' + $this.data('bg') + ')');

        if (testMobile == null) {
            jQuery(bg).addClass('not-mobile');
            jQuery(bg).removeClass('is-mobile');
            jQuery(bg).parallax('50%', 0.4);
        }
        else {
            //jQuery(bg).css('backgroundAttachment', 'inherit');
            jQuery(bg).removeClass('not-mobile');
            jQuery(bg).addClass('is-mobile');

        }

    });

})();

/**
 * Fixed Main Header.
 */
( function() {
    
    if ( header_fixed_setting.fixed_header == '1' ) {
		var header_fixed = jQuery('.fixed-on');
		var p_to_top     = header_fixed.position().top;

	    jQuery(window).scroll(function(){
	        if(jQuery(document).scrollTop() > p_to_top) {
	            header_fixed.addClass('header-fixed');
	            header_fixed.stop().animate({},300);

	            // if ( jQuery('#site-navigation').hasClass('toggled') ) {
	            // 	jQuery('.nav-menu').css({ 'height' : jQuery(window).height() + 'px', 'overflow' : 'auto' });
	            // 	header_fixed.stop().animate({},300); 
	            // }

	        } else {
	            header_fixed.removeClass('header-fixed');
	            header_fixed.stop().animate({},300); 
	        }
	    });
	}

})();

/**
 * Fixed Navigation on Touch devices.
 */
// ( function() {
// 	jQuery.fn.navigationTouch = function () {
// 		if( !( 'ontouchstart' in window ) &&
// 			!navigator.msMaxTouchPoints &&
// 			!navigator.userAgent.toLowerCase().match( /windows phone os 7/i ) ) return false;

// 		this.each( function()
// 		{
// 			var curItem = false;

// 			jQuery( this ).on( 'click', function( e )
// 			{
// 				var item = jQuery( this );
// 				if( item[ 0 ] != curItem[ 0 ] )
// 				{
// 					e.preventDefault();
// 					curItem = item;
// 				}
// 			});

// 			jQuery( document ).on( 'click touchstart MSPointerDown', function( e )
// 			{
// 				var resetItem = true,
// 					parents	  = jQuery( e.target ).parents();

// 				for( var i = 0; i < parents.length; i++ )
// 					if( parents[ i ] == curItem[ 0 ] )
// 						resetItem = false;

// 				if( resetItem )
// 					curItem = false;
// 			});
// 		});
// 		return this;
// 	};
// 	jQuery( '#site-navigation li:has(ul)' ).navigationTouch();

// })();

/**
 * Performs a smooth page scroll to an anchor on the same page.
 */
// ( function() {

// 	jQuery('a[href*=#]:not([href=#])').click(function() {
// 	    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') 
// 	        || location.hostname == this.hostname) {

// 	        var target = jQuery(this.hash);
// 	        target = target.length ? target : jQuery('[name=' + this.hash.slice(1) +']');
// 	           if (target.length) {
// 	             jQuery('html,body').animate({
// 	                 scrollTop: target.offset().top - 65
// 	            }, 1000);
// 	            return false;
// 	        }
// 	    }
// 	});
// })();

/**
 * Smooth One Page scroll for main navigation.
 */
 ( function() {

 	var currentSection;
 	var contentSections = jQuery('.vc_row');
	var	navigationItems = jQuery('#site-navigation .nav-menu li a');

	// update the navigation style.
	updateNavigation();
	jQuery(window).on('scroll', function(){
		updateNavigation();
	});

    // jQuery('a[href*=#]:not([href=#])').on('click', function(event){
    // 	event.preventDefault();
    //     smoothScroll(jQuery(this.hash));
    // });

 	jQuery('.onepage-navigation #site-navigation .nav-menu li a[href*=#]').on('click', function(event){
        event.preventDefault();
        smoothScroll(jQuery(this.hash));
    });

 	function smoothScroll(target) {
 		if ( header_fixed_setting.fixed_header == '1' ) {
 			jQuery('body,html').animate({'scrollTop':target.offset().top - jQuery('.header-fixed').height() },600 );
 		} else {
 			jQuery('body,html').animate({'scrollTop':target.offset().top }, 600 );
 		}
    }

	function updateNavigation() {
		contentSections.each(function(){
			$this = jQuery(this);

			if ( header_fixed_setting.fixed_header == '1' ) {
				if ( jQuery(window).scrollTop() > ( $this.offset().top - (jQuery('.header-fixed').height() + 10) ) ) {
					currentSection = ( $this.attr('id') );
				}
			} else {
				if ( jQuery(window).scrollTop() > ( $this.offset().top ) ) {
					currentSection = ( $this.attr('id') );
				}
			}

			// if ( jQuery(window).scrollTop() < ( jQuery('.site-header').offset().top ) ) {
			// 	jQuery('.onepage-navigation #site-navigation .nav-menu li a[href*=#page]').addClass('home-menu-actived');
			// } else {
			// 	jQuery('.onepage-navigation #site-navigation .nav-menu li a[href*=#page]').removeClass('home-menu-actived');
			// }
			
			navigationItems.removeClass('menu-actived');

			jQuery('#site-navigation .nav-menu li a[href*="#'+currentSection+'"]').addClass('menu-actived');

		});
	}
 	
 })();

/**
 * Call magnificPopup when use
 */
( function() {
    
    // WordPress gallery lightbox
	jQuery('.gallery-lightbox').magnificPopup({
		delegate: '.gallery-item a',
		type:'image',
		zoom: {
			enabled:true
		}
	});

	// Menu Lightbox
	jQuery('.entry-content').magnificPopup({
		delegate: '.menu-image-lightbox a',
		type: 'image',
		gallery:{
			enabled:true
		},
		zoom: {
			enabled:true
		}
	});

})();

/**
 * Responsive Videos
 */
( function() {
	jQuery('.site-content').fitVids();

})();





