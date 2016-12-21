/* Copyright (C) 2007 - 2011 YOOtheme GmbH, YOOtheme Proprietary Use License (http://www.yootheme.com/license) */

(function($) {
    
	
	(function(){
    if(parseFloat(jQuery.fn.jquery) < 1.5) return;

    // backgroundPosition[X,Y] get hooks
    var $div = $('<div style="background-position: 3px 5px">');
    $.support.backgroundPosition   = $div.css('backgroundPosition')  === "3px 5px" ? true : false;
    $.support.backgroundPositionXY = $div.css('backgroundPositionX') === "3px" ? true : false;
    $div = null;

    var xy = ["X","Y"];

    // helper function to parse out the X and Y values from backgroundPosition
    function parseBgPos(bgPos) {
        var parts  = bgPos.split(/\s/),
            values = {
                "X": parts[0],
                "Y": parts[1]
            };
        return values;
    }

    if (!$.support.backgroundPosition && $.support.backgroundPositionXY) {
        $.cssHooks.backgroundPosition = {
            get: function( elem, computed, extra ) {
                return $.map(xy, function( l, i ) {
                    return $.css(elem, "backgroundPosition" + l);
                }).join(" ");
            },
            set: function( elem, value ) {
                $.each(xy, function( i, l ) {
                    var values = parseBgPos(value);
                    elem.style[ "backgroundPosition" + l ] = values[ l ];
                });
            }
        };
    }

    if ($.support.backgroundPosition && !$.support.backgroundPositionXY) {
        $.each(xy, function( i, l ) {
            $.cssHooks[ "backgroundPosition" + l ] = {
                get: function( elem, computed, extra ) {
                    var values = parseBgPos( $.css(elem, "backgroundPosition") );
                    return values[ l ];
                },
                set: function( elem, value ) {
                    var values = parseBgPos( $.css(elem, "backgroundPosition") ),
                        isX = l === "X";
                    elem.style.backgroundPosition = (isX ? value : values[ "X" ]) + " " + 
                                                    (isX ? values[ "Y" ] : value);
                }
            };
            $.fx.step[ "backgroundPosition" + l ] = function( fx ) {
                $.cssHooks[ "backgroundPosition" + l ].set( fx.elem, fx.now + fx.unit );
            };
        });
    }
	
	})();

	$(document).bind('ready', function() {

		/* Accordion menu */
		$('.menu-accordion').accordionMenu({ mode:'slide' });
		
		/* Follower */
		$('div.mod-line ul.menu').follower({effect: {transition: 'linear', duration: 200}})

		/* Smoothscroller */
		$('a[href="#page"]').smoothScroller({ duration: 500 });

		/* Spotlight */
		$('.spotlight').spotlight({fade: 300, top: 200});

		/* Match height of div tags */
		var matchHeight = function() {
			$('#top > .horizontal div.deepest').matchHeight(20);
			$('#bottom > .horizontal div.deepest').matchHeight(20);
			$('#maintop > .horizontal div.deepest').matchHeight(20);
			$('#mainbottom > .horizontal div.deepest').matchHeight(20);
			$('#contenttop > .horizontal div.deepest').matchHeight(20);
			$('#contentbottom > .horizontal div.deepest').matchHeight(20);
			$('#middle, #left, #right').matchHeight(20);
			$('#mainmiddle, #contentleft, #contentright').matchHeight(20);
		};

		/* Animate background position */
		var animateBackgroungPos = function(selector, options) {
			
			if((navigator.userAgent.match(/(iPhone|iPod|iPad)/i))) {
				return;
			}
			
			var elements = $(selector);

			var options = $.extend({
				transition: 'linear',
				repeat: 5,
				duration: 5000,
				direction: 1,
				width: 558
			}, options);
			
			var timer = false;
			
			function animate() {
				
				if(options.repeat==-1) {
					clearInterval(timer);
					return;
				}
				
				$(elements).each(function(i){
					
					$(this).stop().css({'background-position-x': "0px", 'background-position-y': "40px"}).animate({ 
						'background-position-x': (options.direction * options.width) + "px",
						'background-position-y': "40px" 
					}, options.duration, options.transition );
			
				});
				
				options.repeat--;
				
				if(options.repeat==0) {
					options.transition = 'easeOutSine';
					options.duration = 2 * options.duration;
				}	
			}
			
			if (options.repeat) {
				timer = window.setInterval(animate, options.duration);
				animate();
			}	
		}
		
		var bgwidth = 558;
		var bgduration = 5000;
		
		switch(Warp.Settings.background) {
			
			case 'diamondjacks':
				repeat = 2;
				bgduration = 12500;
				bgwidth = 1028;
				break;
			
			case 'disco':
				repeat = 2;
				bgduration = 12500;
				bgwidth = 759;
				break;
				
			case 'jellyfish':
				repeat = 2;
				bgduration = 12500;
				bgwidth = 1028;
				break;
				
			case 'nebula':
				repeat = 2;
				bgduration = 20000;
				bgwidth = 556;
				break;
				
			case 'spotlights':
				repeat = 2;
				bgduration = 12500;
				bgwidth = 556;
				break;
			
		}
		
		$('#menu').css("visibility", "hidden");
		
		$(window).bind("load", function(){
			
			matchHeight();
			
			/* Dropdown menu */
			$('#menu').dropdownMenu({ mode: 'slide', dropdownSelector: 'div.dropdown:first', centerDropdown: true, fixWidth: true}).css("visibility", "visible");	
			
			if (Warp.Settings.bganimation == 1) {
				animateBackgroungPos('div#page-body', {direction: -1, width: bgwidth, duration: bgduration});
			}		
		})
	
	});

})(jQuery);