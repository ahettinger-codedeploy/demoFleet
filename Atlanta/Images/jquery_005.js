/*******************
* DOCUMENT READY 
* (this should be the only instance of document ready in this file.)
********************/
jQuery(document).ready(function ($) {

    initFooterLinks();
    initMobileNav();
    toggleSearch();
    initSearchBox();
    showSearchBoxOnMobile();
	expandableBoxes();

	$(window).scroll(desktopNavPosition);
	desktopNavPosition();

	if ($.ui) {
	    $("#tabs").tabs();
	}

    if (window.innerWidth < 740) { // mobile
        mobileSliderVerticalAlignment();
    } else { // desktop
        desktopTileHover();
    }
});

/*******************
* WINDOW LOAD 
* (this should be the only instance of window load in this file.)
********************/
jQuery(window).load(function ($) {
    initHomePageSlider();
    initCarousel();
    initSlideshow();
});

jQuery(window).resize(function ($) {
    toggleCarouselView();
    toggleMobileNav();
});

/******************
* PLUGINS
*******************/
// Create new ieUserAgent object
var ieUserAgent = {
    init: function () {
        // Get the user agent string
        var ua = navigator.userAgent;
        this.compatibilityMode = false;

        // Detect whether or not the browser is IE
        var ieRegex = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (ieRegex.exec(ua) == null)
            this.exception = "The user agent detected does not contai Internet Explorer.";

        // Get the current "emulated" version of IE
        this.renderVersion = parseFloat(RegExp.$1);
        this.version = this.renderVersion;

        // Check the browser version with the rest of the agent string to detect compatibility mode
        if (ua.indexOf("Trident/6.0") > -1) {
            if (ua.indexOf("MSIE 7.0") > -1) {
                this.compatibilityMode = true;
                this.version = 10;                  // IE 10
            }
        }
        else if (ua.indexOf("Trident/5.0") > -1) {
            if (ua.indexOf("MSIE 7.0") > -1) {
                this.compatibilityMode = true;
                this.version = 9;                   // IE 9
            }
        }
        else if (ua.indexOf("Trident/4.0") > -1) {
            if (ua.indexOf("MSIE 7.0") > -1) {
                this.compatibilityMode = true;
                this.version = 8;                   // IE 8
            }
        }
        else if (ua.indexOf("MSIE 7.0") > -1)
            this.version = 7;                       // IE 7
        else
            this.version = 6;                       // IE 6
    }
};


/*******************
* Included javascript for old IE browsers
********************/
ieUserAgent.init();
if (ieUserAgent.renderVersion <= 8 || (ieUserAgent.renderVersion >= 9 && ieUserAgent.compatibilityMode)) {
    document.write("<script type='text/javascript' src='/_static/js/css3-mediaqueries.js'></script>");
    jQuery(document).ready(function () {
        jQuery.getScript("/_static/js/rem.min.js");
    });
}



/*******************
* FUNCTIONS
* Definitions of units of work
********************/
// Main navigation toggle at low resolutions
function initMobileNav() {
    $('#primaryNav').after($('#primaryNav').clone().attr("id", "mobileNav").hide());
	$('#mobileNav').wrap("<div class='mp-pusher' id='mp-pusher'>");
	$('#mobileNav > ul').wrap("<div class='mp-level'>").prepend('<a class="mp-back" href="#">close</a>');
	$('#mobileNav li.subnav > ul').wrap("<div class='mp-level'></div>").prepend('<a class="mp-back" href="#">back</a>');

	$('#mobileNav li.subnav > a').each(function() {
	    $element = $(this).parent().find("> .mp-level > ul > a.mp-back");
	    $(this).clone().addClass("heading").insertAfter($element);
	});

	new mlPushMenu(document.getElementById('mobileNav'), document.getElementById('primaryNavToggle'), {
        type: 'cover'
    });
    toggleMobileNav();
}
function toggleMobileNav() {
    if (window.innerWidth < 740) { // mobile
        $('#primaryNav').hide();
        $('#mobileNav').show();
    }
    else {
        initSubNav();
        $('#primaryNav').show();
        $('#mobileNav').hide();
    }
}

// Toggles search on mobile
function toggleSearch() {
    if (window.innerWidth < 740) { // mobile
        $('#searchToggle').click(function() {
			$('#siteSearch').toggle();
		});
    }
}


// Main tile hover effect on high resolutions
function desktopTileHover() {
	var viewportWidth = $(window).width();
	if(viewportWidth > 959) {
		$('#mainTiles .slide').hover(function() {
			$(this).children('div.slideout').stop(true, true).animate({top: '30%'}, 100);
		}, function() {
			$(this).children('div.slideout').stop(true, true);
			$(this).children('div.slideout').animate({top: '34%'}, 100);
		});
	}
}
function desktopNavPosition() {
    var $nav = $('#navigation');
    var scrollTop = $(window).scrollTop(),
        elementOffset = $('#header')[0].getBoundingClientRect().top + 12;
    if (elementOffset <= 0) {
        $nav.addClass("fixed");
    } else {
        $nav.removeClass("fixed");
    }
}

function initHomePageSlider() {
	$('.flexsliderMain').flexslider({
		animation: "fade",
		directionNav: true,
		controlNav: false,
		prevText: '',
		nextText: ''
	});
}
function initCarousel() {
    $('.secondarySlider').each(function () {
        var sliderOptions = {
            animation: "slide",
            animationLoop: true,
            itemWidth: 230,
            itemMargin: 10,
            controlNav: false,
            directionNav: true,
            slideshow: true,
            pauseOnHover: true,
            prevText: '',
            nextText: '',
            minItems: 4,
            maxItems: 4,
            start: function () {
                var viewportWidth = $(window).width();
                if (viewportWidth > 739) {
                    $('.secondarySlider').not(".block-carousel").each(function () {
                        var maxHeightSlider = 0;
                        $(".secondarySliderCopy div", this).each(function () {
                            maxHeightSlider = $(this).innerHeight() > maxHeightSlider ? $(this).innerHeight() : maxHeightSlider;
                        });
                        $(".secondarySliderCopy div", this).height(maxHeightSlider + 10);
                    });
                }
            }
        };

        //define should-load boolean
        var shouldLoad = true;

        //change option base on type of carousel
        if ($(this).hasClass("small-carousel")) {
            sliderOptions.itemWidth = 220;
            sliderOptions.maxItems = 10;
        }
        else if ($(this).hasClass("mobile-carousel")
            && $("body").width() < 960) {
            shouldLoad = false;
        }
        else if ($(this).hasClass("block-carousel")) {
            shouldLoad = false;

            // set heights to be all the same
            var maxHeightSlider = 0;
            $('.secondarySliderCopy div', this).each(function () {
                if ($(this).innerHeight() > maxHeightSlider) {
                    maxHeightSlider = $(this).innerHeight();
                }
            });
            $('.secondarySliderCopy div', this).height(maxHeightSlider + 10);
        }
        else {
            // do not use as it removes bind events for tracking
            //sliderOptions.randomize = true;
        }

        // change some of the options if home page
        if ($("body").hasClass("wireframe--home")) {
            
        }

        //evaluate if flexslider should load
        if (shouldLoad) {
            // copy source
            $sourceSlides = $("ul.slides", this).clone();

            var docWidth = $(document).width();
            // reduce maxItems for phone view
            if (docWidth < 520) {
                try { console.log("load carousel with phone view"); } catch (e) { }
                sliderOptions.minItems = 1;
                sliderOptions.maxItems = 1;
                sliderOptions.itemMargin = 0;
                sliderOptions.slideshow = false;
            }

            if (520 < docWidth && docWidth < 960) {
                sliderOptions.minItems = 2;
                sliderOptions.maxItems = 2;
            }

            // load flexslider
            $(this).flexslider(sliderOptions);

            // hide source slides container and append slides back
            $sourceSlides.addClass("row").find("li").addClass("six unit");
            $('> .row', this).hide().empty().addClass("mobile-only").removeClass("row").append($sourceSlides);
        }
    });
    //toggleCarouselView();
}
function toggleCarouselView() {
    var isMobile = false;
    if ($(window).width() <= 730) {
        isMobile = true;
    }

    $('.secondarySlider').not(".mobile-carousel, .block-carousel").each(function () {
        if (isMobile) {
            $("> .mobile-only", this).show();
            $(".flex-viewport, .flex-direction-nav", this).hide();
        } else {
            $("> .mobile-only", this).hide();
            $(".flex-viewport, .flex-direction-nav", this).show();
        }
    });
}
function initSlideshow() {
    $('.flex-slideshow').each(function () {
        var slideshowOptions = {
            animation: "slide",
            smoothHeight: true,
            directionNav: true,
            controlNav: false,
            animationLoop: false,
            slideshow: false,
            prevText: '',
            nextText: ''
        };

        // change some of the options if home page
        if ($(this).hasClass("with-thumbnails")) {
            // create html dom for slideshow nav
            $(this).after($(this).clone().removeClass().addClass("flex-nav-thumbnails"));
            $(".flex-nav-thumbnails object").remove();
            $(".flex-nav-thumbnails img").show();
            // init slideshow nav
            $('.flex-nav-thumbnails').flexslider({
                animation: "slide",
                controlNav: false,
                animationLoop: false,
                slideshow: false,
                itemWidth: 70,
                asNavFor: '.flex-slideshow.with-thumbnails'
            });
            slideshowOptions.sync = ".flex-nav-thumbnails";
            slideshowOptions.smoothHeight = false;
        }


        $(this).flexslider(slideshowOptions);
    });
}

// Centers the h1 vertically on low resolutions
function mobileSliderVerticalAlignment() {
	var headerHeight = $(".sliderCopy").height();
	var headerWidth = $(".sliderCopy h1 span").width();
	var headerCenter = (0-(headerHeight/2));
	if ($(window).width() <= 960) {
		$(".sliderCopy").css("margin-top",headerCenter);
	}
	$(".sliderCopy p").css("width",headerWidth);
}

// Sets header subnavs to equal heights
function initSubNav() {
    $('#primaryNav > ul > li > ul > .submenu-container').each(function () {
		var maxHeight = 0;
		$('> li', this).each(function () {
		    if ($('> ul', this).length == 0) {
		        $(this).append("<ul></ul>");
		    }
		    maxHeight = $('> ul', this).innerHeight() > maxHeight ? $('> ul', this).innerHeight() : maxHeight;
		});
		$('> li > ul', this).height(maxHeight);
	});
}

// Sets footer sections to equal heights
function initFooterLinks() {
    if (jQuery('#footerLinksLeft').height() > jQuery('#footerLinksRight').height()) {
        jQuery('#footerLinksRight').height(jQuery('#footerLinksLeft').height());
    } else {
        jQuery('#footerLinksLeft').height(jQuery('#footerLinksRight').height());
    }
}

//adds the word search to the search box
function initSearchBox() {
    setTimeout(function () {
        jQuery(".gsc-input").attr("placeholder", "SEARCH");
    }, 1000);
}

//Expandable boxes
function expandableBoxes() {
	$('.clickToExpand').click(function() {
		if ($(window).width() < 740) {
			$(this).parent().children('div.expandable').slideToggle(300);
		}
	});
}

//show the search box on mobile
function showSearchBoxOnMobile() {
    if ($(window).width() < 740) {
        setTimeout(function () {
            var showOrHide = false;
            $('#siteSearch').click(function () {
                if (showOrHide === false) {
                    $('#siteSearch input.gsc-input[type="text"]').css({
                        'position': 'absolute',
                        'right': '-100%',
                        'top': '52px',
                        'width': $(window).width(),
                        'height': '44px',
                        'font-size': '24px'
                    });
                    $('#siteSearch input.gsc-search-button[type="button"]').css({
                        'margin': '17px 0 0 77%',
                        'position': 'absolute'
                    });
                    $('#siteSearch input.gsc-input[type="text"]').show();
                    $('#siteSearch').prepend('<img src="_static/img/x-mark-24.png"/>');
                    $('#siteSearch img').css({
                        'display': 'block',
                        'margin': '6px auto 0 auto',
                    });
                    $('#siteSearch input.gsc-input[type="text"]').focus();
                    showOrHide = true;
                }
                else if (showOrHide == true) {
                    $('#siteSearch input.gsc-input[type="text"]').blur();
                    $('#siteSearch input.gsc-input[type="text"]').hide();
                    $('#siteSearch input.gsc-search-button[type="button"]').removeAttr('style');
                    $('#siteSearch input.gsc-search-button[type="button"]').css({
                        'margin-left': '-10px'
                    });
                    $('td.gsc-search-button').css({
                        'text-align': 'center'
                    });
                    $('#siteSearch img').remove();
                    showOrHide = false;
                }
            });

            $('#siteSearch img').live('click', function () {
                $('#siteSearch input.gsc-input[type="text"]').blur();
                $('#gsc-i-id1').val('');
                $('#siteSearch input.gsc-input[type="text"]').hide();
                $('#siteSearch input.gsc-search-button[type="button"]').removeAttr('style');
                $('#siteSearch input.gsc-search-button[type="button"]').css({
                    'margin-left': '-10px'
                });
                $('td.gsc-search-button').css({
                   'text-align':'center'
                });
                $('#siteSearch img').remove();
                showOrHide = false;
            });

        }, 1000);
    }
    else {
        setTimeout(function () {
            $('#siteSearch').css({
                'right':'0'
            });
            $('#siteSearch input.gsc-search-button[type="button"]').css({
                'position': 'relative',
                'left': '-25px'
            });
        }, 1000);
    }
}


/* Mapping by device http://stackoverflow.com/a/18899718 */
function myNavFun(url) {
    // If it's an iPhone..
    if ((navigator.platform.indexOf("iPhone") != -1)
        || (navigator.platform.indexOf("iPod") != -1)
        || (navigator.platform.indexOf("iPad") != -1))
        window.open("maps://maps.apple.com/?q=" + url);
    else
        window.open("http://maps.google.com/maps?q=" + url);
}
