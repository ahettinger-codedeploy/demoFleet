jQuery.noConflict();

/*
  * TYPOGRAPHY
*/
/*
Cufon.set('fontFamily', 'ColaborateLight');
Cufon.replace('h2, #main h3, h4, h5, h6, #slogan, .label', {
	hover: true
});

Cufon.set('fontFamily', 'Colaborate-Medium');
Cufon.replace('#main_home h3', {
	hover: true
});
*/
/*
  * WE CALL PK_ FUNCTIONS
*/

jQuery(document).ready(function(){	
	//jQuery("#menu").pk_menu();
	
	if (jQuery(".cartLink").length !=0){
		jQuery("#catCartDetails").html('<div class="center over_all_under"><div class="center breadcrumb"><p><a href="/home">Home</a> / Shop</p></div></div><div class="wrap_fullwidth big_padding" id="intro"><div class="center"><h2 id="page_title" class="line_back_ground">Shopping cart</h2><p id="slogan">Your shopping cart is empty</p></div></div><div class="wrap_fullwidth" id="main"><div class="center"><div class="box_fullwidth"><br /><a href="/shop">Continue shopping</a> or go to <a href="/home">homepage</a></div></div></div>');
	}
	


	
	jQuery("#cat_14623_divs").pk_menu();

	jQuery("#options_wrapper").pk_options_menu();

	/* GALLERIES */

	if(jQuery("#project_details").length == 0) {
	
		jQuery(".big_gallery").pk_gallery({
			photos: ".item",
			thumbs: ".gallery_navigation a",
			buttonNext: ".gallery_button_next",
			buttonPrev: ".gallery_button_prev",
			buttonPlayPause: ".button_play_pause",
			easing: "easeInOutQuad",
			speedIn: 400,
			speedOut: 600
		});
		jQuery(".small_gallery").pk_gallery({
			photos: ".item",
			thumbs: ".gallery_navigation a",
			buttonNext: ".gallery_button_next",
			buttonPrev: ".gallery_button_prev",
			buttonPlayPause: ".button_play_pause",
			easing: "easeInOutQuad",
			speedIn: 400,
			speedOut: 600
		});
	}
	jQuery("#project_details").pk_gallery({
		photos: ".project",
		thumbs: "#grid div.box_one_third .small_shadow",
		buttonNext: "#portfolio_navigation .next",
		buttonPrev: "#portfolio_navigation .prev",
		buttonClose: ".button_close",
		autoStart: false,
		toogle: true
	});

	/* href="/page"R */

	jQuery(".twitter_list").pk_twitter({
		user: "adobebc",
		count: 3
	});

	/**/

	jQuery("#grid").pk_portfolio();
	jQuery("#categories_dropdown").pk_dropdown();
	jQuery("input:text, input:password, textarea").pk_input();
	//jQuery("#contact_form").pk_form();
	jQuery("body").pk_improvements();
});

/*
  * PK_MENU ***
*/

(function($) {
	$.fn.pk_menu = function(options) {
		var defaults = {
			autoPosition: false,
			limitValue: "wrapper",
			easing: "easeOutQuint",
			speedIn: 400,
			speedOut: 100
		};
		
		var settings = $.extend({}, defaults, options);
		
		/**/
		
		return this.each(function () {
			var $root = $(this);
			var $mainmenu = $(">ul", this);
		
			var $headers = $mainmenu.find("ul").parent();
		
			var $limitValue = (settings.limitValue == "document") ? $(window).width() : 960;
            
			/**/
		
			$headers.each(function () {
				var $curobj = $(this);
				var $subul = $(this).find('ul:first');
				var $ul = $("ul", $curobj);
			
				$("ul ul", $root).css({"display": "none", "paddingTop": "0px"}).find("li:first").css({"marginTop": "15px"});
				$("ul ul ul", $root).find("li:first").css({"marginTop": "5px"});
			
				/**/
			
				function getProperty($li, $ul) {
					$li.dimensions = {
						w: $li.offsetWidth, 
						h: $li.offsetHeight, 
						subulw: $ul.outerWidth(), 
						subulh: $ul.outerHeight()
					}
					return $li.dimensions;
				}
			
				function showMenu ($element) {
					$element.css({visibility:'visible'}).slideDown(settings.speedIn);
				}
 
    			function hideMenu ($element, $current) {
    				$element.slideUp(settings.speedIn, function() {
    					$element.hide();
    				});
    				setTimeout(function() { 
        				$current.stop().animate({
        					borderBottomWidth: "5px"
        				}, settings.speedIn + 100, "easeInOutSine");
   				 	}, 100); 
    			}
			
				/**/
				$curobj.click(function() {
					var $targetul = $(this).find("ul:first");
					$targetul.hide();
				});
				$curobj.hoverIntent(function() {
					closeOptionsMenu();
					getProperty(this, $subul);
					
					if($(this).find("selected")) {
						$(this).stop().animate({borderBottomWidth: "0px"}, 1, "easeInOutSine");
					}
					
					var $targetul = $(this).find("ul:first");
					var $offset = $(this).offset();
				
					if($curobj.parents("ul").length == 1) {
						$ul.css({visibility:'hidden'});
						this.firstLevel = true;
						$subul.css({top: 30 + "px"});
					} else {
						this.firstLevel = false;
						$subul.css({top: -5 + "px"});
					}
					
					if(this.firstLevel) {
						var menuleft = 0;
					} else {
						var menuleft = this.dimensions.w;
					}
					
					if(($offset.left + menuleft + this.dimensions.subulw) > $limitValue && !this.firstLevel) {
						menuleft = -(this.dimensions.w);
					}
				
					if(settings.autoPosition == true) {
						$targetul.css({left:menuleft + "px"});
					}
					showMenu($targetul);
				}, function() {
					var $targetul = $(this).find("ul:first");
					hideMenu($targetul, $(this));
				});
			});
		});
	};
})(jQuery);

/*
  * PK_OPTIONS_MENU ***
*/

function closeOptionsMenu() {
	jQuery("#options_wrapper div").filter(":visible").stop().slideUp(500, function() {
		jQuery("#options_wrapper").hide();
	});
}

(function($) {
	$.fn.pk_options_menu = function(options) {
		var defaults = {
			controls: "#options_menu li",
			easing: "easeOutExpo",
			speedIn: 400,
			speedOut: 100
		}
		
		var settings = $.extend({}, defaults, options);
		
		/**/
		
		return this.each(function() {
			var $root = $(this);
			var $menu = $(settings.controls);
			var $items = $("div", $root);
			var $new_item = null;
			
			$root.hide();
			
			$menu.each(function(i) {
				$(this).hoverIntent(function() {
					$new_item = $items.filter(":eq(" + i + ")");
					
					if($new_item.css("display") == "none") {
						if($root.css("display") == "none") {
							$root.show();
							$items.filter(":visible").slideUp(0);
							$new_item.slideDown(settings.speedIn);
						} else {
							$items.filter(":visible").slideUp(settings.speedOut, function() {
								$new_item.slideDown(settings.speedIn);
							});
						}
						$new_item.bind("mouseleave", function() {
							closeOptionsMenu();
						});
					}
				}, function(){});
			});
		});
	};
})(jQuery);

/*
  * PK_PORTFOLIO ***
*/

function closeProjects() {
	jQuery("#project_details .project").filter(":visible").fadeOut(400);
	jQuery('#portfolio_navigation').fadeOut(200);
	jQuery("#project_details").animate({
		"height" : "0px" 
	}, 400, "easeInOutQuad");
	jQuery('.breadcrumb').animate({"paddingTop": "70px"}, 400, "easeInOutQuad");
}

(function($) {
	$.fn.pk_portfolio = function(options) {
		var defaults = {
			easing: "easeInOutQuad",
			speedIn: 400,
			speedOut: 200
		};
		
		var settings = $.extend({}, defaults, options);
		
		/**/
		
		return this.each(function() {
			var $root = $(this);
			
			if($("body").find(".portfolio_big_gallery").length > 0) {
				$("#project_details .project").each(function(i) {
					$("#p" + (i + 1) + " .big_gallery").pk_gallery({
						photos: ".item",
						thumbs: "#gn" + (i + 1) + " a",
						buttonNext: "#gbn" + (i + 1),
						buttonPrev: "#gbp" + (i + 1),
						buttonPlayPause: "#pp" + (i + 1),
						autoStart: false,
						speedIn: 400,
						speedOut: 600
					});
				});
			}
			
			if($("body").find(".portfolio_small_gallery").length > 0) {
				$("#project_details .project").each(function(i) {
					$("#p" + (i + 1) + " .small_gallery").pk_gallery({
						photos: ".item",
						thumbs: "#gn" + (i + 1) + " a",
						buttonNext: "#gbn" + (i + 1),
						buttonPrev: "#gbp" + (i + 1),
						buttonPlayPause: "#pp" + (i + 1),
						autoStart: false,
						speedIn: 400,
						speedOut: 600
					});
				});
			}
			
			$(".box_one_third", $root).css("background-image" , "url('images/skin/preview_icon.png')");
			$(".small_shadow", $root).find("img").hover(function(){
				$(this).stop().animate({ "opacity" : 0.3 }, 400, "easeInOutQuad");
			}, function() {
				$(this).stop().animate({ "opacity" : 1 }, 400, "easeInOutQuad");
			});
		});
	};
})(jQuery);

/*
  * PK_GALLERY ***
*/

  
(function($) {
	$.fn.pk_gallery = function(options) {
		
		var defaults = {
			photos: "",
			thumbs: "",
			buttonNext: "",
			buttonPrev: "",
			buttonPlayPause: "",
			buttonClose: "",
			/**/
			autoStart: true,
			firstClick: true,
			toogle: false,
			/**/
			timer: 5000,
			easing: "",
			speedIn: 400,
			speedOut: 200
		};
		
		var settings = $.extend({}, defaults, options);
		
		/**/
		
		return this.each(function() {
			var $root = $(this);
			var $items = $(settings.photos , $root);
			var $thumbs = $(settings.thumbs);
			var $totItems = $items.length;
			var $movies = [];
			var $status = ""; 
			var $index = 0; 
			var $interval = "";
			
			
			/* Sanitize BC output: Tweaked so it removes the empty elements generated by BC */
			$(".item:empty").remove();
			$items = $(settings.photos , $root);
			
			for (i=$items.length;i<12;i++){
				$("a#"+i).remove();	
			}
			
			$thumbs = $(settings.thumbs);
			/* EOF - Tweaked so it removes the empty elements generated by BC */
				
			/* Tweak portfolio style  */	
			if(jQuery("#project_details").length != 0)	{
				$("#grid div a").each(function(i) {
					$(this).attr("rel", "");
					$(this).attr("href", "#");
				});
				$("#grid .caption").each(function(i) {
					$(this).hide();
				});
				
				$("#grid .light_button").each(function(i) {
					$(this).hide();
				});
				
			}
			/* EOF - Tweak portfolio style  */		
			
			
			/**/
			
			function slideshow(index) {
				if(index){
					var id = index;
				} else {
					var id = 0;
				}
				$interval = setInterval(
					function() {
						play(id, "next");
					}, settings.timer
				);
			}
			
			function play(index, verse) {
				var id = index;
				if(verse == "next" || verse == undefined) {
					if(id < ($thumbs.length - 1)) {
						id++;
					} else {
						id = 0;
					}
				} else {
					if(id > 0) {
						id--;
					} else {
						id = ($thumbs.length - 1);
					}
				}
				$thumbs.filter(":eq("+ id +")").trigger("click", [true]);
			}
			
			function positionNavigation(next, prev, nav, gallery) {
				var left = (gallery.width() / 2) - (nav.width() / 2);
				var top = (gallery.height() / 2) - (next.height() / 2);
			
				
				next.css("margin-top", top);
				prev.css("margin-top", top);
				nav.css("margin-left", left);
			}
			
			function changeThumbs($current) {
				for(i = 0; i < $thumbs.length; i++) {
					$thumbs.filter(":eq("+ i +")").removeClass("current");
				}
				$current.addClass("current");
			}
			
			if(settings.autoStart == true) {
				$status = "play";
				$(settings.buttonPlayPause + " img").attr('src', 'images/skin/button_pause.png');
			} else {
				$status = "pause";
			}
			
			if($("body").find("#project_details").length > 0) {
				$thumbs.css("cursor", "pointer");
			}
			
			/**/

			$thumbs.each(function(i) {
				$movies[i] = $items.filter(":eq(" + i + ")").find(".movie").html();
				
				$(this).click(function() {
					var $new_item = $items.filter(":eq(" + i + ")");
					var $media = $items.filter(":eq(" + i + ")").find(".movie").length;
					var $new_height = $new_item.height();
					
					this.id = i;
					$index = this.id;
					
					if($interval) {
						clearInterval($interval);
					}
					if($media == 0 && $status == "play" && $totItems > 1) {
						slideshow(this.id);
					}
					
					if($new_item.css("display") == "none") {
						if($items.filter(":visible").find(".movie")) {
							$items.find(".movie").empty();
						}
						if($media > 0) {
							$new_item.find(".movie").html($movies[this.id]);
						}
						$items.filter(":visible").fadeOut(settings.speedOut, settings.easing);
						$new_item.fadeIn(settings.speedIn, settings.easing);
						
						if($("#project_details").length > 0) {
							var tot = $new_item.find(".item").length;
							
							var width = (15 * tot) + 80;
							$new_item.find(".gallery_navigation").css("width", width);
							if($("body").find(".portfolio_big_gallery").length > 0) {
								positionNavigation($new_item.find(".gallery_button_next"), $new_item.find(".gallery_button_prev"), $new_item.find(".gallery_navigation"), $new_item.find(".big_gallery"));
							}
							if($("body").find(".portfolio_small_gallery").length > 0) {
								positionNavigation($new_item.find(".gallery_button_next"), $new_item.find(".gallery_button_prev"), $new_item.find(".gallery_navigation"), $new_item.find(".small_gallery"));
							}
						}
					}
					
					if(settings.toogle == true) {
						$root.show().animate({
							"height" : $new_height 
						}, settings.speedIn, settings.easing, function() {
							$('#portfolio_navigation').slideDown(settings.speedIn);
						});
						$('html:not(:animated),body:not(:animated)').animate({ scrollTop: 0 }, settings.speedIn, settings.easing);
						$('.breadcrumb').animate({ "paddingTop": "0px"}, settings.speedIn, settings.easing);
					}
					
					changeThumbs($(this));
					
					return false;
				});
			});
			
			if($totItems > 1) {
				var width = (15 * $totItems) + 80;
				$root.find(".gallery_navigation").css("width", width);
				var left = ($root.width() / 2) - ($root.find(".gallery_navigation").width() / 2);
				var top = ($root.height() / 2) - ($(settings.buttonNext).height() / 2);
				
				/* NAVIGATION */
			
				$root.find(".gallery_navigation").show().css("margin-left", left);
				
				/* BUTTON PLAY/PAUSE */
				
				$(settings.buttonPlayPause, $(this)).click(function() {
					if($status == "play") {
						$status = "pause";
						clearInterval($interval);
						$("img", $(this)).attr('src', 'images/skin/button_play.png');
					} else {
						$status = "play";
						play($index, "next");
						$("img", $(this)).attr('src', 'images/skin/button_pause.png');
					}
				});
				
				/* BUTTONS NEXT / PREV / CLOSE */
				
				$(settings.buttonNext).show().css("margin-top", top).click(function() {
					play($index, "next");
				});
				$(settings.buttonPrev).show().css("margin-top", top).click(function() {
					play($index, "prev");
				});
			} else {
				$root.find(".gallery_navigation").hide();
			}
			
			/* BUTTON CLOSE */
			
			$(settings.buttonClose, $items).click(function() {
				closeProjects();
			});
			
			/* FIRST CLICK */
			
			if(settings.firstClick) {
				setTimeout(function() { 
        			$thumbs.filter(":eq(0)").trigger("click", [true]);
   				}, 500);
			}
		});
	}
})(jQuery);

/*
  * PK_DROPDOWN ***
*/

(function($) {
	$.fn.pk_dropdown = function(options) {
		var defaults = {
			menu: ".dropdown",
			button: ".dropdown_button",
			easing: "easeOutQuad",
			speedIn: 400,
			speedOut: 400
		};
		
		var settings = $.extend({}, defaults, options);
		
		return this.each(function() {
			var $root = $(this);
			var $menu = $(settings.menu);
			var $button = $(settings.button);
			
			$menu.hide();
			
			$root.hoverIntent(function() {
				$menu.animate({
					"height": "show"
				},settings.speedIn, settings.easing);
				$button.find("img").attr("src", "images/skin/button_close_categories.png");
			}, function() {
				$menu.animate({
					"height": "hide"
				}, settings.speedIn, settings.easing);
				$button.find("img").attr("src", "images/skin/button_open_categories.png");
			});
		});
	}
})(jQuery);


/*
  * PK_INPUT ***
*/

(function($) {
	$.fn.pk_input = function() {
		return this.each(function() {
			var $root = $(this);
			var inputValue = $root.val();
			
			function reset() {
				var value = $root.val();
				if(inputValue == value) {
					$root.val("");
				}
			}
			
			function blur() {
				var value = $root.val();
				if(value == "") {
					$root.val(inputValue);
				}
			}
			
			$root.focus(function() {
  				reset();
			});
			$root.blur(function() {
  				blur();
			});
		});
	}
})(jQuery);

/*
  * PK_FORM ***
*/

(function($) {
	$.fn.pk_form = function(options) {
		var defaults = {
			php: "sendMail.php",
			text: "Your message has been sent. Thanks ;-)",
			response: "#response",
			submit: "#submit",
			timer: 4000,
			easing: "",
			speedIn: 400,
			speedOut: 400
		};
		
		var settings = $.extend({}, defaults, options);
		
		return this.each(function () {
			var $root = $(this);
			var $response = $(settings.response);
			var $submit = $(settings.submit);
			
			/**/
			
			function showResponse($timer) {
				$submit.fadeOut(5, function() {;
					$response.css("opacity", 0);
					$response.show().stop().animate({
 						opacity: 1
 					}, settings.speedIn, settings.easing, function(){
						interval = setInterval(hideResponse, $timer);
					});
				});
			}
			
			function hideResponse() {
				clearInterval(interval);
				$response.stop().animate({
					opacity:0
				}, settings.speedIn, settings.easing, function() {
					$response.hide();
					$submit.fadeIn(400);
				});
			}
			
			/**/
		
			$root.submit(function(){
				$.ajax({
					type: "POST",
					url: settings.php,
					data: $(this).serialize(),
					success: function(output) {
						$response.ajaxComplete(function() {
							if(output == 'ok') {
								if($("#contacts").length > 0) {
									$("#name", $root).val('');
									$("#email", $root).val('');
									$("#message", $root).text('');
								} else {
									$("#name", $root).val('Name');
									$("#email", $root).val('Email');
									$("#message", $root).text('Message');
								}
								$(this).html("<p>" + settings.text + "</p>");
								showResponse(settings.timer * 2);
							} else {
								$(this).html(output);
								showResponse(settings.timer);
							}
						});
					}
				});
				return false;
			});
		});
	}
})(jQuery);

/*
  * PK_TWITTER ***
*/

(function($) {
	$.fn.pk_twitter = function(options) {
		var defaults = {
			user: "parkerandkent",
			count: 1
		};
	
		var settings = $.extend({}, defaults, options);
		
		String.prototype.linkify = function() {
			return this.replace(/[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/, function(m) {
				return m.link(m);
			});
		};
		
		function get_time(time_value) {
	  		var values = time_value.split(" ");
	  		time_value = values[1] + " " + values[2] + ", " + values[5] + " " + values[3];
	 		var parsed_date = Date.parse(time_value);
	  		var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
	  		var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
	  		delta = delta + (relative_to.getTimezoneOffset() * 60);
	  
	  		var r = '';
	  		if (delta < 60) {
				r = 'a minute ago';
	  		} else if(delta < 120) {
				r = 'couple of minutes ago';
	  		} else if(delta < (45*60)) {
				r = (parseInt(delta / 60)).toString() + ' minutes ago';
	 		} else if(delta < (90*60)) {
				r = 'an hour ago';
	  		} else if(delta < (24*60*60)) {
				r = '' + (parseInt(delta / 3600)).toString() + ' hours ago';
	  		} else if(delta < (48*60*60)) {
				r = '1 day ago';
	  		} else {
				r = (parseInt(delta / 86400)).toString() + ' days ago';
	  		}
	  
	  		return r;
		};
		
		return this.each(function () {
			var $root = $(this);
			
			$.getJSON('http://twitter.com/status/user_timeline/' + settings.user + '.json?count=' + settings.count + '&callback=?', function(data){
				$root.find("li").remove();
				$.each(data, function(index, item){
					$root.append('<li>' + item.text.linkify() + '<small>' + get_time(item.created_at) + '</small></li>');
				});
			});
		});
	}
})(jQuery);

/*
  * PK_IMPROVEMENTS ***
*/

(function($) {
	$.fn.pk_improvements = function(options) {
		var defaults = {
			easing: "easeOutQuint",
			speedIn: "fast",
			speedOut: "fast"
		};
	
		var settings = $.extend({}, defaults, options);
		
		return this.each(function () {
			var $root = $(this);
			
			/* PRETTYPHOTO --- theme: light_rounded / dark_rounded / light_square / dark_square */
			
			if($("body").find("a[rel^='prettyPhoto']").length > 0) {
				
				$("a[rel^='prettyPhoto']").prettyPhoto({
					"default_width": 820,
					"default_height": 500,
					"opacity": 0.80,
					"theme": 'light_square'	
				});
			}
		});
	}
})(jQuery);

/*
  * END PK_CODE ***
*/

/**
* hoverIntent is similar to jQuery's built-in "hover" function except that
* instead of firing the onMouseOver event immediately, hoverIntent checks
* to see if the user's mouse has slowed down (beneath the sensitivity
* threshold) before firing the onMouseOver event.
* 
* hoverIntent r5 // 2007.03.27 // jQuery 1.1.2+
* <http://cherne.net/brian/resources/jquery.hoverIntent.html>
* 
* hoverIntent is currently available for use in all personal or commercial 
* projects under both MIT and GPL licenses. This means that you can choose 
* the license that best suits your project, and use it accordingly.
* 
* // basic usage (just like .hover) receives onMouseOver and onMouseOut functions
* $("ul li").hoverIntent( showNav , hideNav );
* 
* // advanced usage receives configuration object only
* $("ul li").hoverIntent({
*	sensitivity: 7, // number = sensitivity threshold (must be 1 or higher)
*	interval: 100,   // number = milliseconds of polling interval
*	over: showNav,  // function = onMouseOver callback (required)
*	timeout: 0,   // number = milliseconds delay before onMouseOut function call
*	out: hideNav    // function = onMouseOut callback (required)
* });
* 
* @param  f  onMouseOver function || An object with configuration options
* @param  g  onMouseOut function  || Nothing (use configuration options object)
* @author    Brian Cherne <brian@cherne.net>
*/
(function($) {
	$.fn.hoverIntent = function(f,g) {
		// default configuration options
		var cfg = {
			sensitivity: 7,
			interval: 100,
			timeout: 200
		};
		// override configuration options with user supplied object
		cfg = $.extend(cfg, g ? { over: f, out: g } : f );

		// instantiate variables
		// cX, cY = current X and Y position of mouse, updated by mousemove event
		// pX, pY = previous X and Y position of mouse, set by mouseover and polling interval
		var cX, cY, pX, pY;

		// A private function for getting mouse position
		var track = function(ev) {
			cX = ev.pageX;
			cY = ev.pageY;
		};

		// A private function for comparing current and previous mouse position
		var compare = function(ev,ob) {
			ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t);
			// compare mouse positions to see if they've crossed the threshold
			if ( ( Math.abs(pX-cX) + Math.abs(pY-cY) ) < cfg.sensitivity ) {
				$(ob).unbind("mousemove",track);
				// set hoverIntent state to true (so mouseOut can be called)
				ob.hoverIntent_s = 1;
				return cfg.over.apply(ob,[ev]);
			} else {
				// set previous coordinates for next time
				pX = cX; pY = cY;
				// use self-calling timeout, guarantees intervals are spaced out properly (avoids JavaScript timer bugs)
				ob.hoverIntent_t = setTimeout( function(){compare(ev, ob);} , cfg.interval );
			}
		};

		// A private function for delaying the mouseOut function
		var delay = function(ev,ob) {
			ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t);
			ob.hoverIntent_s = 0;
			return cfg.out.apply(ob,[ev]);
		};

		// A private function for handling mouse 'hovering'
		var handleHover = function(e) {
			// next three lines copied from jQuery.hover, ignore children onMouseOver/onMouseOut
			var p = (e.type == "mouseover" ? e.fromElement : e.toElement) || e.relatedTarget;
			while ( p && p != this ) { try { p = p.parentNode; } catch(e) { p = this; } }
			if ( p == this ) { return false; }

			// copy objects to be passed into t (required for event object to be passed in IE)
			var ev = jQuery.extend({},e);
			var ob = this;

			// cancel hoverIntent timer if it exists
			if (ob.hoverIntent_t) { ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t); }

			// else e.type == "onmouseover"
			if (e.type == "mouseover") {
				// set "previous" X and Y position based on initial entry point
				pX = ev.pageX; pY = ev.pageY;
				// update "current" X and Y position based on mousemove
				$(ob).bind("mousemove",track);
				// start polling interval (self-calling timeout) to compare mouse coordinates over time
				if (ob.hoverIntent_s != 1) { ob.hoverIntent_t = setTimeout( function(){compare(ev,ob);} , cfg.interval );}

			// else e.type == "onmouseout"
			} else {
				// unbind expensive mousemove event
				$(ob).unbind("mousemove",track);
				// if hoverIntent state is true, then call the mouseOut function after the specified delay
				if (ob.hoverIntent_s == 1) { ob.hoverIntent_t = setTimeout( function(){delay(ev,ob);} , cfg.timeout );}
			}
		};

		// bind the function to the two event listeners
		return this.mouseover(handleHover).mouseout(handleHover);
	};
	
	
	
	
	
})(jQuery);
