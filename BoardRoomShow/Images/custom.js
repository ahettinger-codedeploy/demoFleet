/* Get base path to the script files by getting "data-path" value of #js-dispatcher
----------------------------------------------------------------------------- */
var dispatherObject = document.getElementById("js-dispatcher");
var dispatherValue = dispatherObject.getAttribute('src');
var myRe = /(.*)\/custom.js/ig;
var scriptsPath = myRe.exec(dispatherValue)[1];

/* Load everything else after DOM is ready
* ---------------------------------------------------------------------- */

// If JavaScript is enabled remove 'no-js' class and give 'js' class
jQuery('.no-js').removeClass('no-js').addClass('js');


// When DOM is fully loaded

jQuery(document).ready(function ($) {

    /* ---------------------------------------------------------------------- */
    /*	Custom Functions
    /* ---------------------------------------------------------------------- */

    // Fixed scrollHorz effect
    $.fn.cycle.transitions.fixedScrollHorz = function ($cont, $slides, opts) {

        $('.image-gallery-slider-nav a').on('click', function (e) {
            $cont.data('dir', '')
            if (e.target.className.indexOf('prev') > -1) $cont.data('dir', 'prev');
        });

        $cont.css('overflow', 'hidden');
        opts.before.push($.fn.cycle.commonReset);
        var w = $cont.width();
        opts.cssFirst.left = 0;
        opts.cssBefore.left = w;
        opts.cssBefore.top = 0;
        opts.animIn.left = 0;
        opts.animOut.left = 0 - w;

        if ($cont.data('dir') === 'prev') {
            opts.cssBefore.left = -w;
            opts.animOut.left = w;
        }

    };

    // Slide effects for #portfolio-items-filter
    $.fn.slideHorzShow = function (speed, easing, callback) { this.animate({ marginLeft: 'show', marginRight: 'show', paddingLeft: 'show', paddingRight: 'show', width: 'show' }, speed, easing, callback); };
    $.fn.slideHorzHide = function (speed, easing, callback) { this.animate({ marginLeft: 'hide', marginRight: 'hide', paddingLeft: 'hide', paddingRight: 'hide', width: 'hide' }, speed, easing, callback); };

    // Test whether argument elements are parents of the first matched element
    $.fn.hasParent = function (objs) {
        objs = $(objs);
        var found = false;
        $(this[0]).parents().andSelf().each(function () {
            if ($.inArray(this, objs) != -1) {
                found = true;
                return false;
            }
        });
        return found;
    };

    /* end Custom Functions */

    /* ---------------------------------------------------------------------- */
    /*	Main Navigation
    /* ---------------------------------------------------------------------- */

    (function () {

        var $mainNav = $('#main-nav').children('ul'),
			optionsList = '<option value="" selected>Navigate...</option>';

        // Regular nav
        $mainNav.on('mouseenter', 'li', function () {
            var $this = $(this),
				$subMenu = $this.children('ul');
            if ($subMenu.length) $this.addClass('hover');
            $subMenu.hide().stop(true, true).fadeIn(200);
        }).on('mouseleave', 'li', function () {
            $(this).removeClass('hover').children('ul').stop(true, true).fadeOut(50);
        });

        // Responsive nav
        $mainNav.find('li').each(function () {
            var $this = $(this),
				$anchor = $this.children('a'),
				depth = $this.parents('ul').length - 1,
				indent = '';

            if (depth) {
                while (depth > 0) {
                    indent += ' - ';
                    depth--;
                }
            }

            optionsList += '<option value="' + $anchor.attr('href') + '">' + indent + ' ' + $anchor.text() + '</option>';
        }).end()
		  .after('<select class="responsive-nav">' + optionsList + '</select>');

        $('.responsive-nav').on('change', function () {
            window.location = $(this).val();
        });

    })();


    $('#main-nav ul > li:has(.current)').addClass('current');

    /* end Main Navigation */

    /* ---------------------------------------------------------------------- */
    /*	Min-height
    /* ---------------------------------------------------------------------- */
    (function () {

        // Set minimum height so footer will stay at the bottom of the window, even if there isn't enough content
        function setMinHeight() {

            $('#content').css('min-height',
				$(window).outerHeight(true)
				- ($('body').outerHeight(true)
				- $('body').height())
                - $('#top').outerHeight(true)
				- $('#header').outerHeight(true)
				- ($('#content').outerHeight(true) - $('#content').height())
            //+ ($('.page-title').length ? Math.abs(parseInt($('.page-title').css('margin-top'))) : 0)
				- $('#footer').outerHeight(true)
				- $('#footer-bottom').outerHeight(true)
			);

        }

        // Init
        setMinHeight();

        // Window resize
        $(window).on('resize', function () {

            var timer = window.setTimeout(function () {
                window.clearTimeout(timer);
                setMinHeight();
            }, 30);

        });

    })();

    /* end Min-height */


    /* ---------------------------------------------------------------------- */
    /*	Fancybox
    /* ---------------------------------------------------------------------- */

    (function () {

        // Images
        $('.single-image, .image-gallery').fancybox({
            'transitionIn': 'fade',
            'transitionOut': 'fade',
            'titlePosition': 'over'
        }).each(function () {
            $(this).append('<span class="zoom">&nbsp;</span>');
        });

        // Iframe
        $('.iframe').fancybox({
            'autoScale': false,
            'transitionIn': 'fade',
            'transitionOut': 'fade',
            'type': 'iframe',
            'titleShow': false
        }).each(function () {
            $(this).append('<span class="zoom">&nbsp;</span>');
        });

    })();

    /* end Fancybox */
    /* ---------------------------------------------------------------------- */
    /*	Widgets
    /* ---------------------------------------------------------------------- */


    /* Tweet */
    yepnope({
        test: $(".widget-tweets").length,
        yep: scriptsPath + '/jquery.tweet.js',
        callback: function () {
            $(".widget-tweets .widget-content").tweet({
                username: 'boardroomsurf',
                count: 4,
                loading_text: "Loading. Please wait..."
            });
        }
    });
	
	 yepnope({
        test: $(".widget-tweets_east").length,
        yep: scriptsPath + '/jquery.tweet.js',
        callback: function () {
            $(".widget-tweets_east .widget-content").tweet({
                username: 'SurfExpo',
                count: 4,
                loading_text: "Loading. Please wait..."
            });
        }
    });

    /* Flickr */
    yepnope({
        test: $('.widget-gallery').length,
        yep: scriptsPath + '/jflickrfeed.min.js',
        callback: function () {
            $(".widget-gallery").jflickrfeed({
                limit: 6,
                qstrings: { id: "22980156@N03" },
                itemTemplate: "<a class='' rel='galleryWidget1' href='{{image_b}}'><img src='{{image_s}}' alt='{{title}}' /></a>"
            }, function (data) {

                $('a[rel=galleryWidget1]').fancybox({
                    'transitionIn': 'fade',
                    'transitionOut': 'fade',
                    'titlePosition': 'over'
                });

            });


        }
    });

    /* Google+*/
    yepnope({
        test: $('#map').length,
        yep: scriptsPath + '/jquery.gmap.min.js',
        callback: function () {
            $('#map').gMap({
                address: 'Del Mar, CA',
                scrollwheel: false,
                zoom: 16,
                markers: [
					{ 'address': 'Del Mar, CA' }
				]
            });
        }
    });

    /* Switcher */
    yepnope({
        test: $("#style-switcher").length,
        yep: [scriptsPath + '/switcher/jquery.core-ui-select.js',
        scriptsPath + '/jquery.cookie.js',
         scriptsPath + '/switcher/script.js',
         scriptsPath + '/switcher/style.css']
    });


    /* ---------------------------------------------------------------------- */
    /*	SLIDERS
    /* ---------------------------------------------------------------------- */

    yepnope({
        test: $('#features-slider.wsc_call_html, #logos-slider, #photos-slider.wsc_call_html').length,
        yep: scriptsPath + '/jquery.smartStartSlider.min.js',
        callback: function () {

            // Features Slider 
            if ($('#features-slider.wsc_call_html').length) {

                $('#features-slider.wsc_call_html').smartStartSlider({
                    pos: 0,
                    hideContent: true,
                    timeout: 3000,
                    pause: false,
                    pauseOnHover: true,
                    type: {
                        mode: 'random',
                        speed: 400,
                        easing: 'easeInOutExpo',
                        seqfactor: 100
                    }
                });

            }

            // Logos Slider
            if ($('#logos-slider').length) {

                $('#logos-slider').smartStartSlider({
                    pos: 0,
                    hideContent: true,
                    contentPosition: 'center',
                    timeout: 3000,
                    pause: false,
                    pauseOnHover: true,
                    type: {
                        mode: 'random',
                        speed: 400,
                        easing: 'easeInOutExpo',
                        seqfactor: 100
                    }
                });

            }

            // Photos Slider
            if ($('#photos-slider.wsc_call_html').length) {

                $('#photos-slider.wsc_call_html').smartStartSlider({
                    pos: 0,
                    hideContent: true,
                    contentPosition: 'bottom',
                    timeout: 3000,
                    pause: false,
                    pauseOnHover: true,
                    type: {
                        mode: 'random',
                        speed: 400,
                        easing: 'easeInOutExpo',
                        seqfactor: 100
                    }
                });

            }

        }
    });

    /* end Sliders */

    /* ---------------------------------------------------------------------- */
    /*	Projects Carousel & Post Carousel
    /* ---------------------------------------------------------------------- */

    (function () {

        var $carousel = $('.projects-carousel.wsc_call_html, .post-carousel');

        if ($carousel.length) {

            var scrollCount;

            function getWindowWidth() {

                if ($(window).width() < 480) {
                    scrollCount = 1;
                } else if ($(window).width() < 768) {
                    scrollCount = 2;
                } else if ($(window).width() < 960) {
                    scrollCount = 3;
                } else {
                    scrollCount = 4;
                }

            }

            function initCarousel(carousels) {

                carousels.each(function () {

                    var $this = $(this);

                    $this.jcarousel({
                        animation: 600,
                        easing: 'easeOutCubic',
                        scroll: scrollCount,
                        itemVisibleInCallback: function () {
                            onBeforeAnimation: resetPosition($this);
                            onAfterAnimation: resetPosition($this);
                        }
                    });

                });

            }

            function adjustCarousel() {

                $carousel.each(function () {

                    var $this = $(this),
						$lis = $this.children('li')
                    newWidth = $lis.length * $lis.first().outerWidth(true) + 100;

                    getWindowWidth();

                    // Resize only if width has changed
                    if ($this.width() !== newWidth) {

                        $this.css('width', newWidth)
							 .data('resize', 'true');

                        initCarousel($this);

                        $this.jcarousel('scroll', 1);

                        var timer = window.setTimeout(function () {
                            window.clearTimeout(timer);
                            $this.data('resize', null);
                        }, 600);

                    }

                });

            }

            function resetPosition(elem) {
                if (elem.data('resize'))
                    elem.css('left', '0');
            }

            getWindowWidth();

            initCarousel($carousel);

            // Detect swipe gestures support
            if (Modernizr.touch) {

                function swipeFunc(e, dir) {

                    var $carousel = $(e.currentTarget);

                    if (dir === 'left')
                        $carousel.parent('.jcarousel-clip').siblings('.jcarousel-next').trigger('click');

                    if (dir === 'right')
                        $carousel.parent('.jcarousel-clip').siblings('.jcarousel-prev').trigger('click');

                }

                $carousel.swipe({
                    swipeLeft: swipeFunc,
                    swipeRight: swipeFunc,
                    allowPageScroll: 'auto'
                });

            }

            // Window resize
            $(window).on('resize', function () {

                var timer = window.setTimeout(function () {
                    window.clearTimeout(timer);
                    adjustCarousel();
                }, 30);

            });

        }

    })();

    /* end Projects Carousel & Post Carousel */

    /* ---------------------------------------------------------------------- */
    /*	Image Gallery Slider
    /* ---------------------------------------------------------------------- */
    (function () {

        var $slider = $('.image-gallery-slider ul');

        if ($slider.length) {

            // Run slider when all images are fully loaded
            $(window).load(function () {

                $slider.each(function (i) {
                    var $this = $(this);

                    $this.css('height', $this.find('li:first img').height())
						 .after('<div class="image-gallery-slider-nav"> <a class="prev image-gallery-slider-nav-prev-' + i + '">Prev</a> <a class="next image-gallery-slider-nav-next-' + i + '">Next</a> </div>')
						 .cycle({
						     before: function (curr, next, opts) {
						         var $this = $(this);
						         // set the container's height to that of the current slide
						         $this.parent().stop().animate({ height: $this.height() }, opts.speed);
						         // remove temporary styles, if they exist
						         $('.ss-temp-slider-styles').remove();
						     },
						     containerResize: false,
						     easing: 'easeInOutExpo',
						     fx: 'fixedScrollHorz',
						     fit: true,
						     next: '.image-gallery-slider-nav-next-' + i,
						     pause: true,
						     prev: '.image-gallery-slider-nav-prev-' + i,
						     slideExpr: 'li',
						     slideResize: true,
						     speed: 600,
						     timeout: 0,
						     width: '100%'
						 });

                });

                // Position nav
                var $arrowNav = $('.image-gallery-slider-nav a');
                $arrowNav.css('margin-top', -$arrowNav.height() / 2);

                // Pause on nav hover
                $('.image-gallery-slider-nav a').on('mouseenter', function () {
                    $(this).parent().prev().cycle('pause');
                }).on('mouseleave', function () {
                    $(this).parent().prev().cycle('resume');
                })

            });

            // Resize
            $(window).on('resize', function () {
                $slider.css('height', $slider.find('li:visible img').height());
            });

        }

    })();

    /* end Image Gallery Slider */
    /* ---------------------------------------------------------------------- */
    /*	Portfolio Filter
    /* ---------------------------------------------------------------------- */

    (function () {

        var $container = $('#portfolio-items');

        if ($container.length) {

            var $itemsFilter = $('#portfolio-items-filter'),
				mouseOver;

            // Copy categories to item classes
            $('article', $container).each(function (i) {
                var $this = $(this);
                $this.addClass($this.attr('data-categories'));
            });

            // Run Isotope when all images are fully loaded
            $(window).on('load', function () {

                $container.isotope({
                    itemSelector: 'article',
                    layoutMode: 'fitRows'
                });

            });

            // Filter projects
            $itemsFilter.on('click', 'a', function (e) {
                var $this = $(this),
					currentOption = $this.attr('data-categories');

                $itemsFilter.find('a').removeClass('active');
                $this.addClass('active');

                if (currentOption) {
                    if (currentOption !== '*') currentOption = currentOption.replace(currentOption, '.' + currentOption)
                    $container.isotope({ filter: currentOption });
                }

                e.preventDefault();
            });

            $itemsFilter.find('a').first().addClass('active');
            $itemsFilter.find('a').not('.active').hide();

            // On mouseover (hover)
            $itemsFilter.on('mouseenter', function () {
                var $this = $(this);

                clearTimeout(mouseOver);

                // Wait 100ms before animating to prevent unnecessary flickering
                mouseOver = setTimeout(function () {
                    if ($(window).width() >= 960)
                        $this.find('li a').stop(true, true).slideHorzShow(300);
                }, 100);
            }).on('mouseleave', function () {
                clearTimeout(mouseOver);

                if ($(window).width() >= 960)
                    $(this).find('li a').not('.active').stop(true, true).slideHorzHide(150);
            });

        }

    })();

    /* end Portfolio Filter */
    /* ---------------------------------------------------------------------- */
    /*	MediaElement
    /* ---------------------------------------------------------------------- */

    (function () {

        var $player = $('video, audio');

        if ($player.length) {

            $player.mediaelementplayer({
                audioWidth: '100%',
                audioHeight: '30px',
                videoWidth: '100%',
                videoHeight: '100%'
            });

            // Fix for player, if in Image Gallery Slider
            $('.mejs-fullscreen-button').on('click', 'button', function () {

                if ($(this).hasParent('.image-gallery-slider ul')) {

                    // Minimize
                    if ($(this).parent().hasClass('mejs-unfullscreen')) {

                        $(this).parents('.image-gallery-slider ul').css({
                            'height': $(this).parents('.image-gallery-slider ul').height(),
                            'overflow': 'hidden',
                            'z-index': ''
                        });

                        // Enlarge
                    } else {

                        // Add temporary styling so cycle slider won't screw up the height totally
                        $('head').append('<style class="ss-temp-slider-styles"> .image-gallery-slider ul { height: ' + $(this).parents('.image-gallery-slider ul').css('height') + ' !important; } </style>')

                        $(this).parents('.image-gallery-slider ul').css({
                            'overflow': 'visible',
                            'z-index': '999'
                        });

                    }
                }

            });

            // Same thing but with an ESC key
            $(document).keyup(function (e) {

                // Minimize
                if (e.keyCode == 27) {

                    $('.mejs-fullscreen-button').parents('.image-gallery-slider ul').css({
                        'height': $('.mejs-fullscreen-button').parents('.image-gallery-slider ul').height(),
                        'overflow': 'hidden',
                        'z-index': ''
                    });

                }

            });

        }

    })();

    /* end MediaElement */

    /* ---------------------------------------------------------------------- */
    /*	FitVids
    /* ---------------------------------------------------------------------- */

    (function () {

        $('.container').each(function () {
            var selectors = [
				"iframe[src^='http://player.vimeo.com']",
				"iframe[src^='http://www.youtube.com']",
				"iframe[src^='http://blip.tv']",
				"object",
				"embed"
			],
				$allVideos = $(this).find(selectors.join(','));

            $allVideos.each(function () {
                var $this = $(this);
                if (this.tagName.toLowerCase() == 'embed' && $this.parent('object').length || $this.parent('.fluid-width-video-wrapper').length) { return; }
                var height = this.tagName.toLowerCase() == 'object' ? $this.attr('height') : $this.height(),
				aspectRatio = height / $this.width();
                if (!$this.attr('id')) {
                    var videoID = 'fitvid' + Math.floor(Math.random() * 999999);
                    $this.attr('id', videoID);
                }
                $this.wrap('<div class="fluid-width-video-wrapper"></div>').parent('.fluid-width-video-wrapper').css('padding-top', (aspectRatio * 100) + "%");
                $this.removeAttr('height').removeAttr('width');
            });
        });

    })();

    /* end FitVids */
    /* ---------------------------------------------------------------------- */
    /*	Accordion Content
    /* ---------------------------------------------------------------------- */

    (function () {

        var $container = $('.wsc_accordion.wsc_call_html .acc-container'),
			$trigger = $('.wsc_accordion.wsc_call_html .acc-trigger');

        $container.hide();
        $trigger.first().addClass('active').next().show();

        var fullWidth = $container.outerWidth(true);
        $trigger.css('width', fullWidth);
        $container.css('width', fullWidth);

        $trigger.on('click', function (e) {
            if ($(this).next().is(':hidden')) {
                $trigger.removeClass('active').next().slideUp(300);
                $(this).toggleClass('active').next().slideDown(300);
            }
            e.preventDefault();
        });

        // Resize
        $(window).on('resize', function () {
            fullWidth = $container.outerWidth(true)
            $trigger.css('width', $trigger.parent().width());
            $container.css('width', $container.parent().width());
        });

    })();

    /* end Accordion Content */

    /* ---------------------------------------------------- */
    /*	Content Tabs
    /* ---------------------------------------------------- */

    (function () {

        var $tabsNav = $('.tabs-nav.wsc_call_html'),
			$tabsNavLis = $tabsNav.children('li'),
			$tabContent = $('.tab-content');

        $tabContent.hide();
        $tabsNavLis.first().addClass('active').show();
        $tabContent.first().show();

        $tabsNavLis.on('click', function (e) {
            var $this = $(this);

            $tabsNavLis.removeClass('active');
            $this.addClass('active');
            $tabContent.hide();

            $($this.find('a').attr('href')).fadeIn();

            e.preventDefault();
        });

    })();

    /* end Content Tabs */
    /* ---------------------------------------------------- */
    /*	UItoTop (Back to Top)
    /* ---------------------------------------------------- */

    (function () {

        var settings = {
            button: '#back-to-top',
            text: 'Back to Top',
            min: 200,
            fadeIn: 400,
            fadeOut: 400,
            scrollSpeed: 800,
            easingType: 'easeInOutExpo'
        },
			oldiOS = false,
			oldAndroid = false;

        // Detect if older iOS device, which doesn't support fixed position
        if (/(iPhone|iPod|iPad)\sOS\s[0-4][_\d]+/i.test(navigator.userAgent))
            oldiOS = true;

        // Detect if older Android device, which doesn't support fixed position
        if (/Android\s+([0-2][\.\d]+)/i.test(navigator.userAgent))
            oldAndroid = true;

        $('body').append('<a href="#" id="' + settings.button.substring(1) + '" title="' + settings.text + '">' + settings.text + '</a>');

        $(settings.button).click(function (e) {
            $('html, body').animate({ scrollTop: 0 }, settings.scrollSpeed, settings.easingType);

            e.preventDefault();
        });

        $(window).scroll(function () {
            var position = $(window).scrollTop();

            if (oldiOS || oldAndroid) {
                $(settings.button).css({
                    'position': 'absolute',
                    'top': position + $(window).height()
                });
            }

            if (position > settings.min)
                $(settings.button).fadeIn(settings.fadeIn);
            else
                $(settings.button).fadeOut(settings.fadeOut);
        });

    })();

    /* end UItoTop (Back to Top) */

    /* ---------------------------------------------------------------------- */
    /*	Contact Form
    /* ---------------------------------------------------------------------- */

    (function () {

        // Setup any needed variables.
        var $form = $('.contact-form'),
			$loader = '<img src="img/loader.gif" height="11" width="16" alt="Loading..." />';

        $form.append('<div id="response" class="hidden">');
        var $response = $('#response');

        // Do what we need to when form is submitted.
        $form.on('click', 'input[type=submit]', function (e) {

            // Hide any previous response text and show loader
            $response.hide().html($loader).show();

            // Make AJAX request 
            $.post('php/contact-send.php', $form.serialize(), function (data) {
                // Show response message
                $response.html(data);

                // Scroll to bottom of the form to show respond message
                var bottomPosition = $form.offset().top + $form.outerHeight() - $(window).height();
                if ($(document).scrollTop() < bottomPosition) $('html, body').animate({ scrollTop: bottomPosition });
            });

            // Cancel default action
            e.preventDefault();
        });

    })();

    /* end Contact Form */

    // });


    /* Search */
    if ($('.wsc_search').length) {
        var initial = "Search...";
        var empty = "";
        jQuery(".SearchTextBox").val(initial);
        jQuery(".SearchTextBox").focus(function () {
            if (jQuery(this).val() == initial) {
                jQuery(this).val("");
            }
        }).blur(function () {
            if (jQuery(this).val() == empty) {
                jQuery(this).val(initial);
            }
        });

        $('.use-form-styles .SearchContainer a').addClass('button');
    }

    /*Feedback 5
    -------------------------------------------------------------------*/
    if ($('.FeedbackForm').length) {

        $('.Feedback_CommandButtons a, .Feedback_Confirmation a').addClass('button');

        $('.use-form-styles span.NormalRed').css({ 'float': 'left', 'margin-top': '-15px', 'padding-bottom': '20px' }).before('<div class="clear"></div>');

        $('.use-form-styles .Feedback_ContactBlock span.NormalRed').css({ 'padding-top': '0px' });

        // Fix for Postal Code Field
        if ($(".Feedback_Field label[id*=PostalCode]").html() == '') {
            $(".Feedback_Field label[id*=PostalCode]").html("Postal Code");
        }
        // End Fix for Postal Code Field

        $('.Feedback_Field input[id*=txtEmail], .Feedback_Field input[id*=txtName]').attr('value', '');

        $('.FeedbackForm .Feedback_Required').each(function () {
            label = $(this).parents('.Feedback_Field').children('.Feedback_FieldLabel').children('.dnnTooltip').children('label').children('a').children('span').html();
            $(this).parents('.Feedback_Field').children('.Feedback_FieldLabel').children('.dnnTooltip').children('label').children('a').children('span').html(label + '<span class="wsc_required">  (required)</span>');
        });
    }

    /*Feedback 6
    -------------------------------------------------------------------*/
    if ($('.dnnForm.FeedbackForm').length) {

        $('input.dnnFormRequired, textarea.dnnFormRequired').each(function () {
            label = $(this).parents().children('label').html();
            $(this).parents().children('label').html(label + '<span class="wsc_required">  (required)</span>');
        });
    }



    /* PostIt Blog Module
    -------------------------------------------------------------------------*/
    // Applying additional classes


    $(".wsc_posts_common .wsc_image_frame a ").append('<span class="zoom">&nbsp;</span>').addClass('wsc_img_link');

    $(".wsc_posts_common .wsc_image_frame").after('<div class="clear"></div>');


    $('.wsc_img_link').append('<span class="zoom">&nbsp;</span>');


    $('.posts-paging').addClass('pagination');



    /* User scripts for Social Groups module
    -------------------------------------------------------------------------*/

    $('.mdMemberList > li:odd').css({ 'margin-right': '0px' });

    $('.ListCol-1').each(function () {
        if ($(this).html() == '') {
            $(this).css({ 'display': 'none' });
        }
    });

    $("#footer .wsc_pane:not(.DNNEmptyPane)").parents('#footer').css({ 'padding': '35px 0 30px' });


});
