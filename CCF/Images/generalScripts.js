/*! ----------------------------------------------------------------------
 *  WARNING: THIS IS A GENERATED FILE
 *  The original file can be found at generalScripts.in.js
 *  ----------------------------------------------------------------------
 */

$(function(){

/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "print-modifications.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="print-modifications.snip.js"

*/
(function() {
    ccf.debug('[ccf.print] modifying stuff for print');

    var canonical = ccf.canonicalURL,
        hostname = window.location.protocol + '://' + window.location.host,
        $header = $('#header').filter(':not(.with-print-header-additions)'),
        logoUrl = $('#logo > a').css('backgroundImage');

    logoUrl = logoUrl ? logoUrl : '/_layouts/ui/img/logo.gif';
    logoUrl = logoUrl.replace(/^url\(/, '').replace(/\)$/, '');

    $('a[href^="/"], a[href^="http"]').each(function() {
        var $this_ = $(this);
        var curHref = $this_.attr('href');
        if (curHref.match(/^http.*/i)) {
            $this_.attr('data-full-url', curHref);
        } else {
            $this_.attr('data-full-url', hostname + curHref);
        }
    });

    if (canonical && $header.length > 0) {
        $('<div class="noscreen clearthis" style="display:none;" id="print-header-additions">' +
            '<img id="print-logo"  src="' + logoUrl + '"/>' +
            '<p id="print-current-url">Current URL: ' + canonical + '</p>' +
          '</div>').prependTo($header);
        $header.addClass('with-print-header-additions');
    }

    //prepend tab headings to their respective tab content elements for printing
    if ($("#section-tabs-container div").length > 0) {
        ccf.debug('[ccf.print] found section-tabs-container');
        //set up the objects for tab content and tab headings
        var tabItems = $("#section-tabs-container").find("div.tab-sections-content");
        var tabList = $("#section-tabs-list");
        //ccf.debug('[ccf.print] set tabItems: %o',tabItems);
        $(tabItems).each(function(idx) {
            //to use the nth-child selector we must start with 1, not zero
            var i = idx + 1;
            
            var tabContents = $(this);
            //get the associated tab heading
            var tabHeading = $("#section-tabs-list li:nth-child(" + (i) + ")").children("a").html();
            ccf.debug('[ccf.print] prepending heading %o', tabHeading);
            //prepend an h2 element with a class that will be hidden onscreen, but displayed for printing
            $('<h2 class="print-tab-heading">' + tabHeading + "</h2>").prependTo(tabContents);
        });
    } //if section-tabs-container

    //handle alternate tab control styles
    if ($(".tab-control div").length > 0) {
        ccf.debug('[ccf.print] found tab-control');
        //set up the objects for tab content and tab headings
        var tabItems = $(".tab-control").find("div.tab-content");
        var tabList = $(".tab-list");
        //ccf.debug('[ccf.print] set tabItems: %o',tabItems);
        $(tabItems).each(function(idx) {
            //to use the nth-child selector we must start with 1, not zero
            var i = idx + 1;

            var tabContents = $(this);
            //get the associated tab heading
            var tabHeading = $(".tab-list li:nth-child(" + (i) + ")").children("a").html();
            ccf.debug('[ccf.print] prepending heading %o', tabHeading);
            //prepend an h2 element with a class that will be hidden onscreen, but displayed for printing
            $('<h2 class="print-tab-heading">' + tabHeading + "</h2>").prependTo(tabContents);
        });
    } //if tab-control

    window.onbeforeprint = function() {
        $(document).trigger('onbeforeprint');
    };
    window.onafterprint = function() {
        $(document).trigger('onafterprint');
    };

    // 2011-11-17 (smartin): Adding chrome-specific print functions
    if (ccf.isChrome()) {
        //hide object/embed items on print (prevents white space where SWF file appears in other browsers)
        $('embed').each(function() {
            $(this).addClass('noprint');
        });
        $('object').each(function() {
            $(this).addClass('noprint');
        });
    }

    if (ccf.isIE7()) {

        ccf.debug('[ccf.print-modifications] wiring on(before|after)print for IE');
        var $doc = $(document);

        $doc.bind('onbeforeprint', function() {
            ccf.debug('[ccf.print-modifications] appending LINK spans to all valid anchors');
            //2011-09-28 (smartin): Filtering the set of anchors to prevent auto-append of link spans for walking directions (and subsequent display of the link HTML during printing)
            $anchors = $('a[data-full-url]').parent().filter(':not(.walkingDirection)').children('a[data-full-url]');
            $anchors.each(function() {
                //$('a[data-full-url]').each(function(){
                var $this_ = $(this);
                $('<span class="onbeforeprint-appended-url">' +
 	                   '[ LINK: ' + $this_.attr('data-full-url') + ' ]</span>').appendTo($this_);
            });
        });

        $doc.bind('onafterprint', function() {
            ccf.debug('[ccf.print-modifications] removing LINK spans appended for print');
            $('.onbeforeprint-appended-url').remove();
        });
    }
})();
/*!

	/="print-modifications.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "contact-area.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="contact-area.snip.js"

*/
/* =Tabs for Contact Area */

(function(){
    var $tabs = $('#contact-area .tab-sections');
    var $closableArea = $('#contact-area.closable');
    ccf.hasClosableArea = $closableArea.length > 0;

    if (typeof ccf.hideContactAreaOnLoad == 'undefined') {
        ccf.hideContactAreaOnLoad = ccf.hasClosableArea;
    }

    var $nav = $('#contact-nav');
    var $navLinks = $nav.find('a');

    if (!ccf.hasClosableArea && !ccf.isHomePage) {
        ccf.debug('[ccf contact-area] Wiring nav links for toggling only');
        $navLinks.filter(':not(.wired)').click(function(){
            $tabs.hide();
            $tabs.filter(this.hash).show();

            $navLinks.removeClass('active');
            $(this).addClass('active');
            return false;
        }).addClass('wired');

    } else {
        ccf.debug('[ccf contact-area] Wiring nav links for toggling and hiding');
        $navLinks.filter(':not(.wired)').click(function(){
            var $thisPane = $(this.hash);
            var $this_ = $(this);
            var $visibleSections = $('.tab-sections:visible');
            var leaveActive = true;

           if ($visibleSections.length && !$thisPane.is(':visible')) {
               /* just switch */
               $visibleSections.hide();
               $thisPane.show();
           } else if ($thisPane.is(':visible')) {
               /* slide up */
               $thisPane.slideUp('100');
               $this_.removeClass('active');
               leaveActive = false;
           } else {
               /* slide down */
               $thisPane.slideDown('100');
           }
           $('#contact-nav a.active').removeClass('active');
           if (leaveActive) {
               $this_.addClass('active');
           }
           return false;
        }).addClass('wired');
    }

    if ((ccf.hasClosableArea && ccf.hideContactAreaOnLoad) ||
         (ccf.isHomePage && ccf.hideContactAreaOnLoad)) {
        ccf.debug('[ccf contact-area] Hiding all tab sections');
        $tabs.hide();
    } else {
        ccf.debug('[ccf contact-area] Showing only first of tab sections');
        var $defaultTabLink = $nav.find('.default-tab a');
        if ($defaultTabLink.length > 0) {
            $defaultTabLink.click();
        } else {
            $navLinks.filter(':first').click();
        }
    }

})();
/*!

	/="contact-area.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "tab-control.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="tab-control.snip.js"

*/
/* =General Tabs for Content Areas */
(function(){
        var debug = ccf.debug;

    $('div.tab-control ul.tab-list a').click( function(evt, args) {
        
        if (!args || args.isFake != true) {
            $(document).trigger('tab-control.click', [this]);
        }
        var indx = $(this).parent().prevAll().length;
	  //get a count of the <li> tabs that came before the currently clicked tab

        if (!$(this).hasClass('active')) {
		//get the children of the 'tab-control' div, which contains the tabs and their associated content divs
		//filter out the tab elements
		//for the content divs, stop any videos

		$(this).parent().parent().parent().children()
                .filter(':not(ul)').each(function() {
                    // In this block, 'this' is the panel (most likely a <div>) the
                    // gets hidden / shown as the result of a tab click.
                    
                    // Find any videos and pause them.
                    
                    var $this_ = $(this);

                    $this_.find('object[id^="limelight"]').each(function() {
                        try {
                            this.doPause();
                        } catch (err) {
                            var i = 2;
                        }
                    });
                    $this_.find('video').each(function() {
                        try {
                            this.pause();
                        } catch (err) {
                            try {
                                this.stop();
                            } catch (err1) {
                                var i = 2;
                            }
                        }
                    });
                }
            ).hide().slice(indx, indx + 1).show();

		//select the link's parent <li>, find the sibling <li> items, get the links they contain, and remove the 'active' class
            $(this).parent().siblings().children().removeClass('active');

		//add the active class to the current link
            $(this).addClass('active');
      }

	 return false;
    });

	$('a[href^=#tab]').parent().parent()
        .filter(':not(ul.tab-list)')
        .find('a[href^=#tab]').click(function(){
            $('div.tab-control ul.tab-list ' +
                'a[href="' + $(this).attr('href') + '"]').trigger('click', [{isFake: true}]);
            return false;
        });

    $('div.tab-control').each(function() {
        $(this).children().filter('div').hide().filter(':first').show();
        $(this).children().filter('ul').children()
            .filter(':first').children().trigger('click', [{isFake: true}]);
    });

})();
/*!

	/="tab-control.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "slideshow.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="slideshow.snip.js"

*/
/* =Slideshow Scripts */

$("a._slideshow").click(function() {
    window.open($(this).attr('href'), 'Video',
        'menubar=0,scrollbars=0,toolbar=0,location=0,' +
        'status=0,resizable=0,width=560,height=375,' +
        'screenX=110,screenY=10,left=110,top=1');
    return false;
});

/*!

	/="slideshow.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "section-tabs.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="section-tabs.snip.js"

*/
/* =Section Tabs for Florida Microsite */

var $tabSectionContainers =
    $('div#section-tabs-container div.tab-sections-content');
$tabSectionContainers.hide().filter(':first').show();

$('div#section-tabs-container ul#section-tabs-list a').click(function () {
    $tabSectionContainers.hide();
    $tabSectionContainers.filter(this.hash).show();
    $('div#section-tabs-container ' +
        'ul#section-tabs-list a').removeClass('active');
    $(this).addClass('active');
    return false;
}).filter(':first').click();

var $tertiaryTabContent =
    $('div.tab-sections-content div.tertiary-content');

$('div.tab-sections-content ul.third-nav a').click(function () {
    $tertiaryTabContent.filter(this.hash).siblings()
        .filter(":not(div.third-nav-container)").hide();
    $tertiaryTabContent.filter(this.hash).show();
    $(this).parent().parent().parent().children().children().children()
        .removeClass('active');
    $(this).addClass('active');
    return false;
});

$('div.tab-sections-content').each(function() {
    $(this).children().filter("div.tertiary-content")
        .hide().filter(":first").show();
    $(this).children().filter("ul").children().filter(':first')
        .children().click();
    $(this).children().children().filter("div.tertiary-content")
        .hide().filter(":first").show();
    $(this).children().children().filter("ul").children()
        .filter(':first').children().click();
});

/*!

	/="section-tabs.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "accordion-control.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="accordion-control.snip.js"

*/
/* =Accordion Controls for Content Area */

/* Hides all of the information on page load */
$("div.accordion_full_sub").hide();

/* Sets the inner-padding to clear this so floated elements don't overflow outside the white area.  Added it to accordion_ful_sub as well because without it weird things happen to the tabs inside accordions in IE7 */
$("div.accordion_full_sub, div.accordion_full_sub > div.inner-padding").addClass('clearthis');

var $accordionH3s =
    $('div#accordion_full h3, div.accordion_full h3').filter(':not(.plain)');

/* Makes the entire div clickable and starts subsequent function */
$accordionH3s.click(function(evt, args) {
    if (!args || args.isFake != true) {
        $(document).trigger('accordion.toggle', [this]);
    }

    /* Upon clicking the information for the department will expand down */
    $(this).next("div.accordion_full_sub").slideToggle("slow")
        .siblings("div.accordion_full_sub").slideUp("slow");

    $(this).parent().find("object").each(function() {
        this.doPause();
    });
    
    /* This adds the 'active' class to the div changing the arrow to point
    * down.
    */
    $(this).toggleClass("active");
    /* This removes the 'active' class when another institute is clicked */
    $(this).siblings("h3").filter(':not(.plain)').removeClass("active");

});
$accordionH3s.hover(function() {
    $(this).addClass("hover");
}, function() {
    $(this).removeClass("hover");
});
/*!

	/="accordion-control.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "accordion-lite-control.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="accordion-lite-control.snip.js"

*/
/* =Accordion Lite */

/* Hides all of the information on page load */
$("dl.accordion-lite > dd").hide();

/* Makes the entire dt clickable and starts subsequent function */
$("dl.accordion-lite > dt").click(function(){
    /* Upon clicking the Q for the A will expand down */
    $(this).next("dl.accordion-lite > dd").slideToggle("fast");
    /* This adds the 'active' class to the div changing the arrow
        * to point down
        */
    $(this).toggleClass("active");
});
$("dl.accordion-lite > dt").hover(function(){
    $(this).addClass("hover");
}, function() {
    $(this).removeClass("hover");
});
/*!

	/="accordion-lite-control.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "pdf-links.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="pdf-links.snip.js"

*/
/* Adding the class of "pdf" to all links that point to a pdf file */
$("a[href$='pdf']").parent().addClass("pdf");
/*!

	/="pdf-links.snip.js"

*/
/* ....iiiiiiiiiiiiiiiiii.... INCLUDE "goto-hashlink.snip.js" ....iiiiiiiiiiiiiiiiii.... */
/*!

	="goto-hashlink.snip.js"

*/

(function() {
    var $doc = $(document);
    ccf._origTitle = document.title;
    //alert('_origTitle is equal to ' + ccf._origTitle);
    $doc.bind('ccf.goto-hashlink', function() {
        var debug = ccf.debug;
        var loc = window.location;
        debug('[ccf.goto-hashlink] looking for valid hash tag');

        if (loc && loc.hash) {
            var hsh = loc.hash;
            var $target = $(hsh);
            var $body = $('body,html');

            //check for existence of target
            if (!$target.length) {
                //check for an alternate target with an underscore
                var althsh = loc.hash.replace(/-/, "_");
                var $alttarget = $(althsh);
            }

            var $target_class = $target.attr('class');
            debug('[ccf.goto-hashlink] Set target class = %o', $target_class);

            if ($target.length) {
                if ($target_class.indexOf('tab-content') >= 0 || $target_class.indexOf('tab-sections-content') >= 0) {
                    $('a[href$="' + hsh + '"]').click();
                    $body.animate({ scrollTop: $target.parent().offset().top - $body.offset().top }, 500);
                    //if accordion is anywhere in the class name of the parent
                } else if ($target.parent().attr('class').indexOf('accordion') >= 0) {
                    debug('[ccf.goto-hashlink] Setting accordion full/lite target by ID');
                    //simulates a click on the accordion so it opens
                    $target.click();
                    //this timeout is needed to wait for all the accordions to finish hiding, so that when we jump to the target it's in its final resting spot
                    setTimeout(
						function() {
						    $(window).scrollTop($target.position().top);
						}, 400
					);
                } else {
                    debug('[ccf.goto-hashlink] scrolling to %o', $target);
                    $body.animate({ scrollTop: $target.offset().top - $body.offset().top }, 500);
                    $('a[href="' + hsh + '"]').click({ isFake: true });
                }
            }

        } // end if loc && loc.hash

        $(document).trigger('ccf.dehash-title');
    });

    //this is the fix the title of the page that displays in the browers in IE
    $doc.bind('ccf.dehash-title', function() {
        setTimeout(
                function() {
                    if (document.title.match(/.*#.*/)) {
                        document.title = ccf._origTitle;
                    }
                }, 1000
		);
    });

    $doc.bind('change propertychange', function() {
        $(document).trigger('ccf.dehash-title');
    });

    $doc.trigger('ccf.goto-hashlink');

})();
/*!

	/="goto-hashlink.snip.js"

*/
    $(".blank-target").attr("target", "_blank");

});
