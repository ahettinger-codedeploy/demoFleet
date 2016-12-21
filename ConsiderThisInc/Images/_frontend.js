
if ( typeof Object.create !== 'function' ) {
	Object.create = function( obj ){
		function F(){};
		F.prototype = obj;
		return new F();
	};
};


(function( $, window, document, undefined ){

	var Slider = {
		
		init: function( options, elem ){
				var self = this;
				
				self.wrapper = elem;		//cache wrapper element
				self.$wrapper = $( elem );	// -- jquery version
				
				self.$slidesMedia = self.$wrapper.find('.ts-media').find('.ts-item');
				self.$slidesContent = self.$wrapper.find('.ts-content').find('.ts-item');
				self.$thumbsWrapper = self.$wrapper.find('.ts-thumbs');
				self.$thumbs = self.$wrapper.find('.ts-thumb');
				self.$dots = self.$wrapper.find('.ts-dot');
				self.$tabs = self.$wrapper.find('.ts-tab');
				self.$curtain = self.$wrapper.find('.ts-curtain');
				self.$autoplayBar = self.$wrapper.find('.ts-autoplay-progress');
				
				self.$btnLeft = self.$wrapper.find('.ts-goLeft');
				self.$btnRight = self.$wrapper.find('.ts-goRight');
				
				
				self.totalSlides = ( self.$wrapper.data().totalslides ? self.$wrapper.data().totalslides : self.$slidesMedia.length );
				self.slWidth = ( self.$wrapper.data().width ? self.$wrapper.data().width : 800 );
				self.slHeight = ( self.$wrapper.data().height ? self.$wrapper.data().height : 400 );

				self.currSlide = 0;
				self.prevSlide = 0;
				self.nextSlide = 1;
				self.ready = true;
				self.autoPlay = true;
				self.hasAutoPlay = self.$wrapper.data().autoplay;
				self.autoPlayDelay = ( self.$wrapper.data().autoplay_delay ? (self.$wrapper.data().autoplay_delay*1000) : 2000 );
				self.hasZooming = self.$wrapper.data().zooming;
				
				self.$btnLeft.on( 'click', function(){ self.stopAutoPlay(); self.slideLeft(); });
				self.$btnRight.on( 'click', function(){ self.stopAutoPlay(); self.slideRight(); });
				self.$thumbs.on( 'click', function(){ self.slideGoTo( $(this).data().index ); } );
				self.$dots.on( 'click', function(){ self.slideGoTo( $(this).data().index ); } );
				self.$tabs.on( 'click', function(){ self.slideGoTo( $(this).data().index ); } );
				
				self.resizeTimeout;
				
				//self.loading();
				self.resizeInit();
				//self.swipeSlide();
				self.swipppeSlide();
				if ( self.hasAutoPlay ){
					self.actionAutoPlay();
				}
				self.keyboardEvents();
				
				self.actionSlide();
				
				self.videoDuration('dVDk7PXNXB8');
		},
		
		loading: function(){
				var self = this;
				
				/*
				self.$slidesMedia.has('video').each( function(){
					var $this = $(this);
					$this.find('video').loadeddata( function(){
						self.actionResizeSlider();
						//$this.find('.sl-loadingscreen').fadeOut();
						self.$thumbs.eq( $this.data().index ).addClass('ready').find('.sl-loadingscreen').fadeOut();
					});
				});
				*/
				
				var $slideImageNew = self.$slidesMedia.eq( self.currSlide );
				if ( $slideImageNew.has('video').length > 0 ){
					$slideImageNew.find('video')[0].play();
				};
				
				var $videoSlides = self.$slidesMedia.filter('.ts-item.type-embededvideo');
				var slData = $slideImageNew.data();
				$videoSlides.html('');
				if ( slData.type=='embededvideo' ){
						var $videourl = slData.src;
						var allData = {
							videourl: $videourl,
							action: 'video_request'
						}								
						$.ajax({
							type : "post",
							url : the1Globals.ajaxUrl,
							data : allData,
							success: function(response) {
								var $response = $(response);
								$slideImageNew.html( $response );
							}
						});							
						self.$pattern.fadeOut(100);
				} else {
						self.$pattern.fadeIn(100);
				}
				
				

				self.$slidesMedia.has('img').each( function(){
					var $this = $(this);
					$this.imagesLoaded( function(){
						$this.find('.sl-loadingscreen').fadeOut();
						self.$thumbs.eq( $this.data().index ).addClass('ready').find('.sl-loadingscreen').fadeOut();
					});
				});
		},
		
		actionAutoPlay: function(){
				var self = this;
				
				if ( self.autoPlay && self.totalSlides > 1 ){
					if ( self.hasZooming ){
						self.$slidesMedia.eq( self.currSlide ).addClass( 'autoplay' );
					}
					self.$autoplayBar.css('width','0px');
					self.$autoplayBar.animate({
						width: '100%'
					}, ( self.autoPlayDelay - 500 ), function() {
						// Animation complete.
					});
					
					
					setTimeout(
					function(){
						if ( self.autoPlay ){
							self.slideRight();
							self.actionAutoPlay();
						}
					}
					, self.autoPlayDelay
					);
				}
			
		},
		
		stopAutoPlay: function(){
				var self = this;
				
				self.autoPlay = false;
				self.$autoplayBar.hide();
		},
		
		keyboardEvents: function(){
				var self = this;
				
				$(document).bind('keydown',function(evt) {
					switch(evt.keyCode) {
						case 39: self.slideRight();	self.stopAutoPlay(); break;
						case 37: self.slideLeft(); self.stopAutoPlay(); break;
					}
				});		
		},
		
		slideLeft: function(){
				var self = this;
				
				if ( !self.ready || self.$slidesMedia.length < 2 ) return false;
				self.ready = false;
				
				self.prevSlide = self.currSlide;
				self.currSlide--;
				if ( self.currSlide < 0 ) {
					self.currSlide = ( self.totalSlides - 1 );
				}
				self.actionSlide();
		},
		
		slideRight: function(){
				var self = this;
				
				if ( !self.ready || self.$slidesMedia.length < 2 ) return false;
				self.ready = false;
				
				self.prevSlide = self.currSlide;
				self.currSlide++;
				self.nextSlide = self.currSlide+1;
				
				if ( self.currSlide >= self.totalSlides ) {
					self.currSlide = 0;
					self.nextSlide = 1;
				}
				if ( self.nextSlide >= self.totalSlides ) {
					self.nextSlide = 0;
				}
				
				self.actionSlide();
		},
		
		slideGoTo: function(i){
				var self = this;
				
				if ( i !== self.currSlide ){
					
					if ( !self.ready ) return false;
					self.ready = false;
					
					self.stopAutoPlay();
					
					self.prevSlide = self.currSlide;
					self.currSlide = i;
					self.actionSlide();
				}
		},
		
		actionSlide: function(){
				var self = this;
				
				// check if this is initial Load of slider
				var firstLoad = ( self.prevSlide === self.currSlide ? true : false );
				
			//	Slides: Media
				var $slideMedia_new = self.$slidesMedia.eq( self.currSlide );
				var $slideMedia_old = self.$slidesMedia.eq( self.prevSlide );
				
				// unload video slides
				var $videoSlides = self.$slidesMedia.filter('.ts-item.type-embededvideo');
				if ( $videoSlides.length > 0 ) { $videoSlides.html(''); }
				
				// get data of the NewSlide
				var slData = $slideMedia_new.data();
				
				// check if NewSlide is a youtube/vimeo slide and load the video
				if ( slData.type=='embededvideo' ){
					
					//hide pattern if not video slide
					//self.$curtain.delay(200).fadeOut(200);
					
					var $videourl = slData.src;
					var allData = {
						videourl: $videourl,
						action: 'video_request'
					}								
					$.ajax({
						type : "post",
						url : the1Globals.ajaxUrl,
						data : allData,
						success: function(response) {
							var $response = $(response);
							$slideMedia_new.html( $response );
						}
					});							
				} else {
					
					//show pattern if not video slide
					//self.$curtain.fadeIn(200);
					
				}
				
				/*
				// check if NewSlide is a selfhosted video slide and plays video
				if ( $slideMedia_new.has('video').length > 0 ){
					$slideMedia_new.find('video')[0].play();
				};
				*/

			//	Slides: Content
				var $slideContent_new = self.$slidesContent.eq( self.currSlide );
				/*var $slideContent_new_Elements = $slideContent_new.find('.sl-slidecontentcell').children();*/
				
				var $slideContent_old = self.$slidesContent.eq( self.prevSlide );
				/*var $slideContent_old_Elements = $slideContent_old.find('.sl-slidecontentcell').children();*/
				
				// put new slide behind the current slide and make it visible
				$slideMedia_new.css('z-index', 1).show();
				
				
				/*self.actionResizeSlider();*/
				/*$slideContent_old_Elements.css( 'opacity', 0 ).css( 'transform', 'translateY(-50px)' );*/
				
				/*
				$slideContent_old_Elements.each(function(i){
					var $this = $(this);
					setTimeout(
						function(){ $this.css( 'transform', fx[fx.currentOut()[i]] ).css( 'opacity', 0 ); }
						, i*150
					);
				});
				*/
				
				/*
				$slideContent_new_Elements.each(function(i){
					$(this).css( 'transform', fx[fx.current()[i]] ).css( 'opacity', 0 );
				});
				*/
				
				if ( firstLoad ) {
					// if it's firstLoad, show the initial slide
					$slideContent_new.addClass('current').show();
					$slideMedia_new.css('z-index', 2);
					self.ready = true;
				} else {
					// else, hide the current slide and show the new one
					$slideContent_old.removeClass('current').fadeOut( 300, function(){
						$slideContent_new.show().delay(100);
						setTimeout( function(){ $slideContent_new.addClass('current'); },100);
					});
					
					$slideMedia_old.delay(100).fadeOut( 300, function(){
						$slideMedia_old.css('z-index', -1).removeClass( 'autoplay' ); 
						$slideMedia_new.css('z-index', 2);
						/*
						$slideContent_new_Elements.each(function(i){
							var $this = $(this);
							setTimeout(
								function(){ $this.css( 'opacity', 1 ).css( 'transform', 'translate(0,0)' ); }
								, (i*100)+200
							);
						});
						*/
						self.ready = true;
					});
				}
				
				// set active control (thumb, dot, ...)
				self.actionSetActiveControl();
				
		},
		
		actionSetActiveControl : function(){
				var self = this;
				
				if ( self.$thumbs.length > 0 ){
					self.$thumbs.removeClass('active').eq( self.currSlide ).addClass('active');
				}
				if ( self.$dots.length > 0 ){
					self.$dots.removeClass('active').eq( self.currSlide ).addClass('active');
				}
				if ( self.$tabs.length > 0 ){
					self.$tabs.removeClass('active').removeClass('next-active').eq( self.currSlide ).addClass('active');
					self.$tabs.eq( self.nextSlide ).addClass('next-active');
				}

		},
		
		resizeInit: function(){
				var self = this;
				
				// resize slides on page load
				self.resizeTimeout = setTimeout( function(){ self.actionResizeSlider(); }, 10 );
		
				// resize slides on window reize
				$(window).on('resize', function(){
					clearTimeout( self.resizeTimeout );
					self.resizeTimeout = null;
					self.resizeTimeout = setTimeout( 
						function(){
							self.actionResizeSlider()
						}, 10 
					);
				});
		},
		
		actionResizeSlider: function(){
				var self = this;
				
				// if 0 slides, exit function
				if ( self.totalSlides < 1 ) return false;
				
				// (ratio) Width and Height set on slider
				var limitWidth = self.slWidth;
				var limitHeight = self.slHeight;
				
				// set calculated slider Height based on ratio
				var slWIDTH = $(self.$wrapper).width();
				var slHEIGHT = limitHeight;
				if ( slWIDTH < limitWidth ) {
					slHEIGHT = slWIDTH*(limitHeight/limitWidth);
				}
				self.$wrapper.height(slHEIGHT);
				
	
		},
		
		swipppeSlide: function(){
				var self = this;
				var $sw = self.$wrapper;
				var swipeStartPos;
				
				$sw.on('mousedown',function(e){
					swipeStartPos = e.pageX;
					$(this).addClass('swippping');
				}).on('mouseup',function(){
					$(this).removeClass('swippping');
				}).on('mouseleave',function(){
					$(this).removeClass('swippping');
				});
				
				$sw.parent().on('mousemove','.ts-wrapper.swippping',function(e){
					var mousePos =  e.pageX;
					var swipeTravel = Math.abs( swipeStartPos - mousePos );
					if ( swipeTravel > 100 ) {
						if ( swipeStartPos > mousePos ){ 
							// swipe left
							self.slideLeft();
							$(this).removeClass('swippping');
						} else {
							// swipe right
							self.slideRight();
							$(this).removeClass('swippping');
						}
						self.stopAutoPlay()
					}
				});
		},
		
		videoDuration: function( id ){
					var allData = {
						videoid: id,
						action: 'get_youtube_duration'
					}								
					$.ajax({
						type : "post",
						url : the1Globals.ajaxUrl,
						data : allData,
						success: function(response) {
							//var $response = $(response);
							console.log(response);
						}
					});							
		}
		
		/*
		swipeSlide: function(){
				var self = this;
				if ( $.fn.swipe ){
					self.$wrapper.swipe(
						{
							swipeLeft: function(event){
								event.preventDefault();
								self.stopAutoPlay();
								self.slideRight();
								return false;
							},
							swipeRight: function(event){
								event.preventDefault();
								self.stopAutoPlay();
								self.slideLeft();
								return false;
							},
							excludedElements: '',
							threshold: 20
						}
					);
				}
		},
		*/


	}




	$.fn.the1Slider = function( options ){

		return this.each(function(){
			var slider = Object.create( Slider );
			slider.init( options, this );
		});
		
	};
	
	
	// Default Values
	$.fn.the1Slider.options = {
		type		: 'fullscreen',
		fx			: 'slide',
		items		: '.ts-items',
		item		: '.ts-item',
		navarrow	: '.ts-navarrow',
		left		: '.ts-goLeft',
		right		: '.ts-goRight',
		thumbnails	: '.ts-thumbnails',
		thumbnailslist	: '.ts-thumbnailslist',
		thumbnail	: '.ts-thumbnail',
		dots		: '.ts-dots',
		dot			: '.ts-dot',
		bottombar	: '.ts-bottombar',
		loading		: '.ts-loadingscreen'
	};



	$(document).ready(function(){ 
		$('.ts-wrapper').the1Slider();
	});


})( jQuery, window, document );







/*


(function($){
	$(document).ready(function(){
		//	Slider
			swipppe();
			
	});


	//	SLIDER: parallax
	//---------------------------------------
	
	function swipppe(){

		var $sw = $('.ts-wrapper');
		var swipeStartPos;
		
		$sw.on('mousedown',function(e){
			swipeStartPos = e.pageX;
			$(this).addClass('swippping');
		}).on('mouseup',function(){
			$(this).removeClass('swippping');
		}).on('mouseleave',function(){
			$(this).removeClass('swippping');
		});
		
		$(document).on('mousemove','.ts-wrapper.swippping',function(e){
			var mousePos =  e.pageX;
			var swipeTravel = Math.abs( swipeStartPos - mousePos );
			if ( swipeTravel > 100 ) {
				if ( swipeStartPos > mousePos ){ 
					// swipe left
					$(this).removeClass('swippping');
				} else {
					// swipe right
					$(this).removeClass('swippping');
				}
			}
		});
		
		

	}


})(jQuery);
*/