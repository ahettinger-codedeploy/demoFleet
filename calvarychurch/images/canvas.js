// Adds a Class to the HTML element in Editor Mode
// This allows you to make style adjustments to your pages in Editor Mode
$(document).ready(function () {
	if (ews && ews.Editor) {
		$("html").addClass("editoron");
	}
});
// Removes Responsive Stylesheet in Editor Mode
$(document).ready(function () {
    if (ews && ews.Editor) {
        $("head link[href$='responsive.content.min.css']").remove();
    }
});

// This turns on the mobile "mean menu"
$(document).ready(function () {
    $('header .nav').meanmenu();
});

// This allows the FAQ answer dropdown to work
$(document).ready(function () {
    $('.maincontent dt a').click(function (e) {
        e.preventDefault();
        $(this).parent().siblings('dd').slideToggle('fast', function () { });
        $(this).parent().toggleClass('open');
    });
});

// Parallax Scrolling for Main Slideshow
$(window).bind('scroll', function (e) {
    parallaxScroll();
});

function parallaxScroll() {
    var scrolled = $(window).scrollTop();
    $('#main-slideshow .ews_slideshow_bgdiv').css('top', (0 - (scrolled * -0.3)) + 'px');
}

// Adds A Class To .ews_html (HTML Block) That Contatins Iframes And/Or Objects
//$(document).ready(function () {
//    $('iframe, object').parent('.ews_html').addClass('responsive-video');
//});

// jQuery Breakpoint Indicator for Mobile (requires breakpoint.js)
if (window.matchMedia) {
    $.breakpoint({
        condition: function () {
            return window.matchMedia('screen and (max-width:600px)').matches;
        },
        first_enter: function () {

        },
        enter: function () {
            // Turn off Parallax Scrolling for Mobile
            $(window).bind('scroll', function (e) {
                parallaxScroll();
            });

            function parallaxScroll() {
                var scrolled = $(window).scrollTop();
                $('#main-slideshow .ews_slideshow_bgdiv').css('top', (0) + 'px');
            }
        },
        exit: function () {
            // Turn back on Parallax Scrolling
            $(window).bind('scroll', function (e) {
                parallaxScroll();
            });

            function parallaxScroll() {
                var scrolled = $(window).scrollTop();
                $('#main-slideshow .ews_slideshow_bgdiv').css('top', (0 - (scrolled * -0.7)) + 'px');
            }
        }
    });
}

// Hide header on scroll
$(document).ready(function () {
    //caches a jQuery object containing the header element
    var header = $("html");
    var reachedBottom = false;
    $(window).scroll(function (Event) {
        var lastScroll = 34;

        var st = $(this).scrollTop();
        //var bs = $(window).scrollTop() + window.innerHeight == $(document).height();

        if (st < lastScroll) {
            header.removeClass('state-shrunk').addClass('state-expanded');
        }
        else if (st + $(window).height() === document.height) {
            header.removeClass('state-shrunk');
            reachedBottom = true;
        } else if ((reachedBottom) && (st + $(window).height() <= document.height - 30)) {
            reachedBottom = false;
            console.log((st + $(window).height() - (document.height - 30)));
        }
            /*
                    else if (How do I get current position and if scrolled UP 30 PIXELS do something) {
                        alert('test');
                    }
            */
        else {
            header.addClass("state-shrunk");
        }
    });
});