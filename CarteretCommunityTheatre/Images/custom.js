jQuery(function($) {
 
	var Engine = {
       
		animations : {
           
			navBarAnim : function(){
                   
				jQuery(window).scroll(function(){
					"use strict";	
					var jQueryiw = jQuery('body').innerWidth();
					
					if(jQuery(window).scrollTop() != 0){
						jQuery('.mtnav').stop().animate({top: '0px'}, 500);
						jQuery('.logo').stop().animate({width: '150px'}, 500);
						jQuery('.logo').css('margin-top','3px');
					}       
					else {
						 if ( jQueryiw < 992 ) {
						  }
						  else{
						   jQuery('.mtnav').stop().animate({top: '30px'}, 500);
						  }
						  jQuery('.logo').stop().animate({width: '166px'}, 500);
						  jQuery('.logo').css('margin-top','-4px');		
					}
				});
                        
			}, // navBarAnim
			
			detailsAnim : function(){
                   
				"use strict";
				$('.tip-arrow').css({'bottom':1+'px'});
				$('.tip-arrow').animate({'bottom':-9+'px'},{ duration: 700, queue: false });	
				
				$('.bookfilters').css({'margin-top':-40+'px'});
				$('.bookfilters').animate({'margin-top':0+'px'},{ duration: 1000, queue: false });	
				
				$('.topsortby').css({'opacity':0});
				$('.topsortby').animate({'opacity':1},{ duration: 1000, queue: false });	
			
				$('.itemscontainer').css({'opacity':0});
				$('.itemscontainer').animate({'opacity':1},{ duration: 1000, queue: false });
                        
			}, // detailsAnim
			
			offerHover : function(){
                   
				var theSide = 'marginLeft';
				var options = {};
				options[theSide] = jQuery('.one').width()/2-15;
				jQuery(".one")
					.mouseenter(function() {
						jQuery(".mhover", this).addClass( "block" );
						jQuery(".mhover", this).removeClass( "none" );
						jQuery(".icon", this).stop().animate(options, 100);
					})
				jQuery(".one").mouseleave(function() {
						jQuery(".mhover", this).addClass( "none" );
						jQuery(".mhover", this).removeClass( "block" );
						jQuery(".icon", this).stop().animate({marginLeft:"0px"}, 100);
					});
                        
			}, // offerHover
			
			backtoTop : function(){
                   
				"use strict";
				// hide #back-top first
				jQuery("#back-top").hide();
				
				// fade in #back-top
				jQuery(function () {
					jQuery(window).scroll(function () {
						if (jQuery(this).scrollTop() > 700) {
							jQuery('#back-top').fadeIn();
						} else {
							jQuery('#back-top').fadeOut();
						}
					});
			
					// scroll body to 0px on click
					jQuery('#back-top a').click(function () {
						jQuery('body,html').animate({
							scrollTop: 0
						}, 500);
						return false;
					});
					
					// scroll body to 0px on click
					jQuery('a#gotop2').click(function () {
						jQuery('body,html').animate({
							scrollTop: 0
						}, 500);
						return false;
					});
					
					var jQueryih = jQuery('body').innerHeight();
					
					jQuery(".scroll").click(function(event){		
						event.preventDefault();
						jQuery('html,body').animate({scrollTop:jQuery(this.hash).offset().top - jQueryih}, 1500);
					});
				});
                        
			}, // backtoTop
			
			listPicHover : function() {
				
				function StartAnime2() {	
				var $wlist = $('.listitem2').width();
				var $hlist = $('.listitem2').height();
		
				$('.liover').css({
					"width":10+"%",
					"height":10+"%",
					"background-color":"#72bf66",
					"position":"absolute",
					"top":$hlist/2+"px", 
					"left":$wlist/2+"px", 
					"opacity":0.0, 
				});
				$('.fav-icon').css({
					"top":$hlist/2-11+"px",
					"left":$wlist+"px",
				});
				$('.book-icon').css({
					"top":$hlist/2-11+"px",
					"left":-25+"px",
				});
				
				$( ".listitem2" )
					.mouseenter(function() {
						$(this).find('.liover').stop().animate({ "left":10+"%","top":10+"%","width":80+"%","height":80+"%","opacity":0.5  });
						//$(this).find('.book-icon').stop().animate({ "left":$wlist/2-42+"px" });
						$(this).find('.fav-icon').stop().animate({ "left":$wlist/2-15+"px" });
		
		
					})
					.mouseleave(function() {
						$(this).find('.liover').stop().animate({ "left":$wlist/2+"px","top":$hlist/2+"px","width":10+"%","height":10+"%","opacity":0.0  });
						//$(this).find('.book-icon').stop().animate({ "left":-25+"px" });
						$(this).find('.fav-icon').stop().animate({ "left":$wlist+"px" });
					
					});	
				
				}
				
				StartAnime2();
				
				$(window).resize(function() {
					StartAnime2();					
				});
			
			}, //listPicHover
			
			socialIconsAnim : function(){
                   
				jQuery(window).scroll(function(){
					"use strict";	
					if(jQuery(window).scrollTop() >= 300){
						jQuery('.social1').stop().animate({top:'0px'}, 100);
						
						setTimeout(function (){
							jQuery('.social2').stop().animate({top:'0px'}, 100);
						}, 100);
						
						setTimeout(function (){
							jQuery('.social3').stop().animate({top:'0px'}, 100);
						}, 200);
						
						setTimeout(function (){
							jQuery('.social4').stop().animate({top:'0px'}, 100);
						}, 300);
						
						setTimeout(function (){
							jQuery('.gotop').stop().animate({top:'0px'}, 200);
						}, 400);				
						
					}       
					
				});
                        
			} // socialIconsAnim
			            
		}, // end animations
		
		bctweaks : {
            
	       	buildDropMenu : function(){
	
				// Need to add the caret, and add a few classes above and below
				// to create compatiablity with BC and Bootstraps Nav Menus
				$("div.navbar-collapse > ul").addClass('nav navbar-nav navbar-right');
				$(".nav li.dropdown > a").addClass('dropdown-toggle').append(" <b class='lightcaret mt-2'></b>");
				$(".nav li.dropdown > ul").addClass('dropdown-menu posright-0');
				$("a.dropdown-toggle").attr('data-toggle', 'dropdown');
				$('li.dropdown-header').each(function(){
		        	var $this = jQuery(this),
		                text = $this.find('a').text();
		            $this.html(text);
		        });
				
			}, // buildDropMenu
	
			showSubMenu : function(){
	
				if($(".collapse .dropdown.open")){
					$("dropdown-menu").show();
				}
				
			}, // showSubMenu
			
			prettyDate : function() {
				// Put our new date function to work
				if ($("span.dep-date").length > 0) {
					$(function() {	
						$('span.dep-date').each(function() {	
							var bcDateText = $(this).text(); // get the text of the date
							var newJsDate = bcDateToJsDate(bcDateText); // uses the javascript date function to split and order our date
							$(this).html(toShortMonthDate(newJsDate)); // re-write the date in the format you choose. To change the separator just add an - after newJsDate so it would be (newJsDate,"-")
					
						});
					});
				}
			}, // prettyDate
			
			navSelectedState : function(nav){
		 
				// This script creates the selected state on the menus
				$("div.navbar-collapse ul.nav li").each(function(){ // Pass in the container tag eg 'nav'
					if ($(this).find("a").attr('href') === window.location.pathname)
				    {
					 $(this).addClass('active');
					 $(this).parents("li").addClass('active');
				    }   
				});
			} // navSelectedState
			
		}, // bctweaks
		
		settings : {
           
			niceScroll : function(){
                   
				"use strict";
				var nice = jQuery("html").niceScroll({
					cursorcolor:"#ccc",
					cursorborder:"0px solid #fff",			
					railpadding:{top:0,right:0,left:0,bottom:0},
					cursorwidth:"5px",
					cursorborderradius:"0px",
					cursoropacitymin:0,
					cursoropacitymax:0.7,
					boxzoom:true,
					autohidemode:false
				});  
				
				jQuery('html').addClass('no-overflow-y');
                        
			},// niceScroll
			
			detailSliderInit : function(){
            
            	"use strict";
				var $carousel = $('#carousel'),
					$pager = $('#pager');
	
				function getCenterThumb() {
					var $visible = $pager.triggerHandler( 'currentVisible' ),
						center = Math.floor($visible.length / 2);
					
					return center;
				}
	
				$carousel.carouFredSel({
					responsive: true,
					items: {
						visible: 1,
						width: 800,
						height: (500/800*100) + '%'
					},
					scroll: {
						fx: 'crossfade',
						onBefore: function( data ) {
							var src = data.items.visible.first().attr( 'src' );
							src = src.split( '/large/' ).join( '/small/' );
	
							$pager.trigger( 'slideTo', [ 'img[src="'+ src +'"]', -getCenterThumb() ] );
							$pager.find( 'img' ).removeClass( 'selected' );
						},
						onAfter: function() {
							$pager.find( 'img' ).eq( getCenterThumb() ).addClass( 'selected' );
						}
					},
					prev: {
						button: "#prev_btn2",
						key: "left"
					},
					next: {
						button: "#next_btn2",
						key: "right"
					},	
				});
				$pager.carouFredSel({
					width: '100%',
					auto: false,
					height: 120,
					items: {
						visible: 'odd'
					},
					onCreate: function() {
						var center = getCenterThumb();
						$pager.trigger( 'slideTo', [ -center, { duration: 0 } ] );
						$pager.find( 'img' ).eq( center ).addClass( 'selected' );
					}
				});
				$pager.find( 'img' ).click(function() {
					var src = $(this).attr( 'src' );
					src = src.split( '/small/' ).join( '/large/' );
					$carousel.trigger( 'slideTo', [ 'img[src="'+ src +'"]' ] );
				});       
				
                        
			},// detailSliderInit
			
			customSelectMenus : function(){
                   
				jQuery('.mySelectBoxClass').customSelect();
					/* -OR- set a custom class name for the stylable element */
					//jQuery('.mySelectBoxClass').customSelect({customClass:'mySelectBoxClass'});
				
				function mySelectUpdate(){
					setTimeout(function (){
						$('.mySelectBoxClass').trigger('update');
					}, 200);
				}
				
				$(window).resize(function() {
					mySelectUpdate();
				});
                        
			},// customSelectMenus
			
			listPgCounter : function(){
                   
				$.fn.countTo = function(options) {
					// merge the default plugin settings with the custom options
					options = $.extend({}, $.fn.countTo.defaults, options || {});
	
					// how many times to update the value, and how much to increment the value on each update
					var loops = Math.ceil(options.speed / options.refreshInterval),
						increment = (options.to - options.from) / loops;
	
					return $(this).each(function() {
						var _this = this,
							loopCount = 0,
							value = options.from,
							interval = setInterval(updateTimer, options.refreshInterval);
	
						function updateTimer() {
							value += increment;
							loopCount++;
							$(_this).html(value.toFixed(options.decimals));
	
							if (typeof(options.onUpdate) == 'function') {
								options.onUpdate.call(_this, value);
							}
	
							if (loopCount >= loops) {
								clearInterval(interval);
								value = options.to;
	
								if (typeof(options.onComplete) == 'function') {
									options.onComplete.call(_this, value);
								}
							}
						}
					});
				};
	
				$.fn.countTo.defaults = {
					from: 0,  // the number the element should start at
					to: 100,  // the number the element should end at
					speed: 1000,  // how long it should take to count between the target numbers
					refreshInterval: 100,  // how often the element should be updated
					decimals: 0,  // the number of decimal places to show
					onUpdate: null,  // callback method for every time the element is updated,
					onComplete: null,  // callback method for when the element finishes updating
				};
                        
			},// listCounter
			
			sliderParallax : function(){
			
				"use strict";
				var jQueryscrollTop;
				var jQueryheaderheight;
				var jQueryloggedin = false;
					
				if(jQueryloggedin == false){
				  jQueryheaderheight = jQuery('.navbar-wrapper2').height() - 20;
				} else {
				  jQueryheaderheight = jQuery('.navbar-wrapper2').height() + 100;
				}
				
				
				jQuery(window).scroll(function(){
				  var jQueryiw = jQuery('body').innerWidth();
				  jQueryscrollTop = jQuery(window).scrollTop();	   
					  if ( jQueryiw < 992 ) {
					 
					  }
					  else{
					   jQuery('.navbar-wrapper2').css({'min-height' : 110-(jQueryscrollTop/2) +'px'});
					  }
				  jQuery('#dajy').css({'top': ((- jQueryscrollTop / 5)+ jQueryheaderheight)  + 'px' });
				  //jQuery(".sboxpurple").css({'opacity' : 1-(jQueryscrollTop/300)});
				  jQuery(".scrolleffect").css({'top': ((- jQueryscrollTop / 5)+ jQueryheaderheight) + 30  + 'px' });
				  jQuery(".tp-leftarrow").css({'left' : 20-(jQueryscrollTop/2) +'px'});
				  jQuery(".tp-rightarrow").css({'right' : 20-(jQueryscrollTop/2) +'px'});
				});
				
			} // sliderParallax
            
		}// end settings
      
	};
  
	Engine.animations.navBarAnim();
	Engine.animations.detailsAnim();
	Engine.animations.offerHover();
	Engine.animations.backtoTop();
	Engine.animations.listPicHover();
	Engine.animations.socialIconsAnim();
	
	Engine.bctweaks.buildDropMenu();
	Engine.bctweaks.showSubMenu();
	Engine.bctweaks.prettyDate();
	Engine.bctweaks.navSelectedState('nav');
	
	Engine.settings.niceScroll();
	Engine.settings.detailSliderInit();
	Engine.settings.customSelectMenus();
	Engine.settings.listPgCounter();	
	Engine.settings.sliderParallax();
   
});