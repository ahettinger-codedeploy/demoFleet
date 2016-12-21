(function($){
		  
		  
	$(document).ready(function(){
							   
		//	Dropdown activation
			//$('#navdd').click(nav_dd);
			
		//	Scroll to element
			scrollToElement();
			
		//	Micromenu toggle
			micromenuToggle();
			
		//	Mobile Navigation Toggle
			mobileMainNavigation();

		//	Main Menu on scroll
			navigationOnScroll();

		//	Parallax
			parallax();
			parallax_Footer();
			parallax_Slider();
			
		//	Ajaxed Contact Form
			ajaxContactForm();
			
		//	Initialize search form
			initSearch();
			
		//	Custom form "Placeholder"
		//	replaces default "placeholder" attribute on input forms
			customPlaceholder();
			
		//	On window resize
			windowResize();
			
		//	Masonry
			initMasonry();

		//	Appear element when scrolled to
			appearOnScroll();

		//	Fluid Video Resizing
			fluid_video();

		//	Fluid Video Resizing
			slidingLogos();

			//post_slider_init();
			//follow_btn();
			//notification();
			//tooltip_init();
			
			
			if(typeof $.fn.counterUp !== 'undefined') {
			$('.the1-counterup').counterUp({
				delay: 10,
				time: 1000
			});
			}
		
			
			/*
			$('#fontawesomeEE').load('http://localhost/wp_atto/?page_id=77 #FA', function(){
				var output = '';
				$('#fontawesomeEE').children('div').children('div').each(function() {
					var $this = $(this);
                    var texti = $this.find('i').text();
					$this.find('p,br,i,span').remove();
					var klasa = $this.text().trim();
					
					var currentItem = '[item][txt]'+texti+'[/txt][cls]'+klasa+'[/cls][/item]<br>';
					
					output += currentItem;
					
                });
				$('#fontawesomeEE').html(output);
			});
			*/
			
			
	});





	//	MICROMENU TOGGLE
	//---------------------------------------
	
	function micromenuToggle(){
		var $mm = $('.header-wrapper.micromenu');
		$('#micromenu-toggle').on( 'click', function(){
			$mm.find('.header-inner').fadeToggle(100);										 
		});
		if ( $mm.length > 0 ){
			$mm.outside( 'click', function(){
				$(this).find('.header-inner').fadeOut(100);
			});
		}
	}



	//	PARALLAX
	//---------------------------------------
	
	function parallax(){
		$('.s-parallax-background').each(function(index, element) {
            var $this = $(this);
			var bgImage = $this.css( 'background-image' );
			bgImage = bgImage.replace(/"/g,'');
			$this.prepend( '<div class="s-parallax-layer" style="background-image:'+bgImage+';"></div>' );
        });
		updateParallax();
		$(window).on( 'scroll', function(){
			updateParallax(); 
		});
	}
	function updateParallax(){
		var velocity = 0.2;
		var pos = $(window).scrollTop();
		$('.s-parallax-layer').each(function(){
			var $element = $(this);
			var offset = ($element.offset().top); 
			
			var position = Math.round( -( pos - offset )* velocity ) ;
			$(this).css('backgroundPosition', '50% ' + ( (position/2)+50 ) + '%');
		});
	};
	
	function parallax_Footer(){
		var $footerWrapper = $('#footer-wrapper');
		var $footer = $footerWrapper.find('#footer');
		var footerHeight = 0;
		
		if ( !$('body').hasClass('static-parallax-footer') ) return false;
		
		$(window).on( 'load resize', function(){
			footerHeight = $footer.height();
			$footerWrapper.height(footerHeight);
		});
	}
	
	function parallax_Slider(){
		
		if ( $('#the1_mainslider.revo-parallax').find('.slotholder').length < 1 ) return false;
		
		var el = {
			parent: $('#the1_mainslider.revo-parallax'),
			child: $('#the1_mainslider.revo-parallax').find('.slotholder')
			}
		
		updateParallax_Slider( el );
		$(window).on( 'scroll', function(){
			updateParallax_Slider( el ); 
		});
		
		function updateParallax_Slider( el ){
			console.log( el.parent );
			var pos = $(window).scrollTop();
			var sl_velocity = -0.6;
			var offset = ( el.parent.offset().top );
			
			var position = - ( pos - offset ) * sl_velocity;
			position = position < 0 ? 0 : position;
			el.child.css('transform','translateY('+position+'px)');
			console.log('pos:'+position+'; offset:'+offset+'; velocity: '+sl_velocity);
		};
	}



	//	CONTACT FORM (excluding slider parallax)
	//---------------------------------------
	
	function ajaxContactForm(){
		
		$('body').on( 'submit', '#contact-form.ajax-contact-form', function(){
			var $this = $(this);
			$this.closest('form').submit
		});
		
		
	
		$('#cf-wrapper.ajax-contact-form').on('submit', 'form#cf-form', function(e) {
			e.preventDefault();
			var $this = $(this);
			var $loadingGif = '<div style="width:50px;height:50px;display:inline-block;background:none" class="lm-loadingscreen loading-screen"><div class="loading-screen-inner"><div class="loading-icon"></div></div></div>';
			$this.find('#cf-submit-wrapper').html( $loadingGif );
			
			var data = $this.serialize();
			$.post(the1Globals.ajaxUrl, data, function(response) {
				$('#cf-wrapper').html(response);
			});
			//overlayer('<div id="saving">saving...</div>');
			return false;
		});
		
		
		
	}
	
	
	//	MOBILE MAIN NAVIGATION
	//------------------------------------------
	
	function mobileMainNavigation(){
		
		$('.main-nav-toggle').on( 'click', function(){
			var $this = $(this);
			var $nav = $('.main-nav-mobile');
			
			if ( $nav.hasClass('mobile-open') ) {
				$nav.removeClass('mobile-open');
				$('.main-nav-toggle').removeClass('active');
			} else {
				$nav.addClass('mobile-open');
				$('.main-nav-toggle').addClass('active');
			}
		});
		
		$('#main-nav').find('.menu-item-has-children').append('<div class="toggle-submenu"></div>');
		
		$('#main-nav').on( 'click', '.toggle-submenu', function(){
			var $this = $(this);
			var $submenu = $this.parent().children('.sub-menu');
			$submenu.toggleClass('expanded');
		});
		
	}
	
	
//	NAVIGATION ON SCROLL
//------------------------------------------------
	
	function navigationOnScroll(){
		
		var $nav = $('.header-wrapper-sticky');
		var $toTop = $('#to-top');
		var state = 1;
		var changed = false;
		
		$(window).on( 'scroll', function(){
			var $this = $(this);
			if ( $this.scrollTop() < 50 ) {
				if ( state !== 1 ) {
					state = 1;
					$nav.addClass('hidden');
					$toTop.removeClass('visible')
				}
			} else {
				if ( state !== 2 ) {
					state = 2;
					$nav.removeClass('hidden');
					$toTop.addClass('visible');
				}
			}
		});
		
	}


//	INITIALIZE SEARCH FORM
//------------------------------------------------
	
	function initSearch(){
		
		var $form = $('.header-search');
		if ( $form.length < 1 ) return false;
		var $icon = $form.find('.icon');
		
		$form.outside( 'click', function(){
			var $field = $(this).find('.field');
			$field.parent().fadeOut(150);
		});

		$icon.on( 'click', function(){
			var $field = $(this).closest('.header-search').find('.field-wrapper');
			$field.show();
		});
		
	}
	
	
//	CUSTOM PLACEHOLDER
//------------------------------------------------

	function customPlaceholder(){
		
		var $fields = $('.customplaceholder');
		if ( $fields.length < 1 ) return false;
		
		$fields.on( 'focus', function(){
			var $this = $(this);
			var defaultText = $this.data().customplaceholder;
			if ( $this.val() == defaultText ){
				$this.val('');
				$this.removeClass('passive');
			}
		});

		$fields.on( 'blur', function(){
			var $this = $(this);
			var defaultText = $this.data().customplaceholder;
			if ( $this.val() == defaultText || $this.val() == '' ){
				$this.val( defaultText );
				$this.addClass('passive');
			}
		});
	
	}


//	SLIDING LOGOS
//------------------------------------------------
	
	function slidingLogos(){
		
		var $wrapper = $('.the1_logos');
		
		if ( $wrapper.length < 1 ) return false;
		
		var $listWrapper = $wrapper.find('.the1_logos__list-wrapper');
		var $list = $wrapper.find('.the1_logos__list');
		var $items = $wrapper.find('.the1_logo');

		
		var listWidth, wrapperWidth, diff, slideable;
		slideable = false;
		
		$wrapper.on( 'mouseenter', function(){
			$(this).addClass('slideable');
		}).on('mouseleave', function(){
			$(this).removeClass('slideable');
		});
		
		$(document).on('mousemove', '.the1_logos.slideable', function(e){
			slideLogos(e); 
		});
		$(window).on('resize', function(){
			setTimeout(function(){setupLogos()},500);
		});
		
		setupLogos();
		setTimeout(function(){setupLogos()},1000);
		
		function setupLogos(){
			wrapperWidth = $listWrapper.width();
			listWidth = 0;
			$items.each(function(index, element) {
                listWidth += $(this).outerWidth(true);
            });
			$list.css( 'width', listWidth+'px' );
			if ( listWidth > wrapperWidth ) { 
				slideable = true;
			} else { 
				slideable = false;
				$list.css('transform','none');

			};
			
		}
		function slideLogos(e){
			if ( slideable ) {
					var mousePosX = e.pageX - $listWrapper.offset().left;
					var newListPos = ( mousePosX / wrapperWidth ) * ( wrapperWidth - listWidth - (0*2) );
					
					$list.css('transform','translateX('+(newListPos)+'px)');
					console.log(wrapperWidth+' : '+listWidth+' : '+slideable);
			}
		}
					
	}


//	WINDOW ON RESIZE
//------------------------------------------------
	
	function windowResize(){
		
		$(window).on( 'resize', function(){
			updateParallax();
		});
		
	}


//	SCROLL TO ELEMENT FROM HASHTAG LINKS
//-------------------------------------------------

	function scrollToElement(){
		
		var duration = 800;
		var doc = $(document);
		var $htmlBody = $('html,body');
			
		//by hashtag
		$('#nav').find('a').on( 'click', function(){
			var $this = $(this);
			
			var href = $this.attr('href');
			if ( href.charAt( 0 ) == '#' ) {
				var $nav = $('#nav');
				
				if ( href === "#" ){
					duration = doc.scrollTop();
					$htmlBody.bind("scroll mousedown DOMMouseScroll mousewheel keyup", function(){ $htmlBody.stop(); });
					$htmlBody.animate( { scrollTop: 0 }, duration*0.9, function(){ $htmlBody.unbind("scroll mousedown DOMMouseScroll mousewheel keyup"); });
					return false;
				} else {
					var divpos = $( href ).position().top;
					duration = Math.abs( divpos-doc.scrollTop() );
					$htmlBody.bind("scroll mousedown DOMMouseScroll mousewheel keyup", function(){ $htmlBody.stop(); });
					$htmlBody.animate({ scrollTop: Math.floor(divpos) - $('.header-height').height() }, duration*0.9, function(){ $htmlBody.unbind("scroll mousedown DOMMouseScroll mousewheel keyup"); });
					return false;
				}
			}
		});
		
		//to top
		$('#to-top').on( 'click', function(){
			duration = doc.scrollTop();
			$htmlBody.bind("scroll mousedown DOMMouseScroll mousewheel keyup", function(){ $htmlBody.stop(); });
			$htmlBody.animate({ scrollTop: 0 }, duration*0.9, function(){ $htmlBody.unbind("scroll mousedown DOMMouseScroll mousewheel keyup"); });
		});
	}


//	APPEAR ITEMS WHEN SCROLLED TO
//-------------------------------------------------

	function appearOnScroll(){
		
		var $items = $('.toShow');
		
		function appearAction(){
			var $win = $(window);
			$items.each(function(i) {
				var $this = $(this);
				var a = $this.offset().top + $this.height();
				var b = $win.scrollTop() + $win.height();
				if (a < b) $this.removeClass('toShow-hidden');
			});
		}
		
		$(window).on( 'scroll', function(){ appearAction(); } );
		appearAction();
	}


//	INITIALIZE MASONRY
//------------------------------------------------
	
	function initMasonry(){
	
		var $masonryContainer = $('#blog-masonry');
		if ( $masonryContainer.length > 0 ) {
			$masonryContainer.imagesLoaded( function(){
				$masonryContainer.masonry({
					itemSelector: 'article.post'
				});
				//$(this).masonry('layout');									  
			});
		}
		
		var $homeBlogMasonry = $('.blog-layout-masonry');
		if ( $homeBlogMasonry.length > 0 ) {
			$homeBlogMasonry.imagesLoaded( function(){
				$homeBlogMasonry.masonry({
					itemSelector: '.blog-latest-item'
				});
				//$(this).masonry('layout');									  
			});
		}
	
	}


// NOTIFICATION BAR
		function notification(){
			height = $('.note-wrap .note-main').height();
			$('.note-main').css('height', height+'px');
			$('.note-close').click(function(){
				if( $(this).hasClass('once') ) $.cookie('milli_note','hide', { path: '/' });	
				$('.note-main').slideToggle('slow');
			})
		}


		
// NAVIGATION DROPDOWN TOGGLE
		function nav_dd(){
			ddBtn = $(this);
			ddNav = $('#nav');
			if( ddBtn.hasClass('active') ){
				ddBtn.removeClass('active');
				ddNav.slideUp();
			} else {
				ddBtn.addClass('active');
				ddNav.slideDown();
			}
		}
		

// FOLLOW BUTTON
		function follow_btn(){
			var follow = $('#follow-btn');
			var followWrapper = $('.follow-wrapper', follow);
			follow.hover(
				function(){	
					var follow = $('#follow-btn');
					var followWrapper = $('.follow-wrapper', follow);
					fllW = $('.f1', follow).width();
					socW = $('.f2', follow).width();
					
					el = $(this);
					el.stop().animate({width:socW}, 300);
					followWrapper.stop().animate({marginLeft:-fllW}, 300);
				},
				
				function(){
					fllW = $('.f1', follow).width();
					socW = $('.f2', follow).width();
					
					el = $(this);
					el.stop().animate({width:fllW}, 300);
					followWrapper.stop().animate({marginLeft:0}, 300);
				}
			)
		}
		
		
// POST SLIDER
		function post_slider_init(){
			$('.ctrl-dots a').click(function(){
				if( !$(this).hasClass('active') ){
					var slider = $(this).closest('.post-slider');
					var parent = $(this).parent();
					id = $(this).attr('class');
					id = id.substr(3);
					$('a.active', parent).removeClass('active');
					$(this).addClass('active');
					
					$('.images div.thmb'+(id) , slider).css('z-index',2).show();
					$('.images div:eq(0)', slider).css('z-index',3).stop().fadeOut(200, function(){
						$('.images div.thmb'+(id) , slider).css('z-index',3).prependTo($('.images', slider));
					});
				}
			})
		}
		
		
// FLUID VIDEO FIX
		function fluid_video(){
			var $allVideos = $(".post-media").find('iframe');
			
			// Figure out and save aspect ratio for each video
			$allVideos.each(function() {
			  $(this)
				.data('aspectRatio', this.height / this.width)
				.removeAttr('height')
				.removeAttr('width');
			});
			
			$(window).resize(function() {
				$allVideos.each(function() {
					var $el = $(this);
					var newWidth = $el.width();
					$el.height(newWidth * $el.data('aspectRatio'));
				});
			}).resize();
		}
		
		
// SCROLL TO TOP
		function to_top() {
			$('#to-top').click(function(){
				$('html, body').animate({scrollTop:0}, 'slow');
				return false;
			});
		}


// GET URL QUERY STRING VALUES
		function getUrlVars(){
			var vars = [], hash;
			var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
			for(var i = 0; i < hashes.length; i++)
			{
				hash = hashes[i].split('=');
				vars.push(hash[0]);
				vars[hash[0]] = hash[1];
			}
			return vars;
		}


// SC TOOLTIP
		function tooltip_init(){
			$('.tt').tooltip({
				position: {
					my: "center bottom-15",
					at: "center top",
					using: function( position, feedback ) {
						$( this ).css( position );
						$( "<div>" )
							.addClass( "tt-arrow" )
							.addClass( feedback.vertical )
							.addClass( feedback.horizontal )
							.appendTo( this );
					}
				}
			});
		}







	/* jquery plugin to close elements when click outside of it */
	if ( $.fn.outside ){ return false; }
    $.fn.outside = function(ename, cb){
        return this.each(function(){
            var $this = $(this),
                self = this;

            $(document).bind(ename, function tempo(e){
                if(e.target !== self && !$.contains(self, e.target)){
                    cb.apply(self, [e]);
                    if(!self.parentNode) $(document.body).unbind(ename, tempo);
                }
            });
        });
    };


})(jQuery);