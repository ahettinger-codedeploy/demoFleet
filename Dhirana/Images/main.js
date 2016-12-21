function log(n) {
	try {
		console.log(n);
	} catch(err) {}
}

(function($) {
	$.extend({
		settings: {
			scrollSpeed: 0.80,
			backgroundMovementDivider: 3
		},
		
		globals: {
			menufadeelements: $('#main-header nav #menu li')
				.not('.home')
				//.add('#main-header #languages')
				//.add('#product-info')
				.add('#main-header .white-bg')
				.add('#product-categories')
				.add('#main-header .arrow'),
			hash: null,
			activePart: null,
			activeElement: null,
			previousElement: null,
			headerHeight: null,
			scrollleft: null,
			backgroundElements: $('#backgrounds img'),
			isFirstHashChange: true,
			siteTitle: null
		},
		
		changeHash: function(hash) {
			$.globals.hash = {
				id: {
					from: window.location.hash.split('index.html')[1],
					to: hash.split('index.html')[1]
				},
				hash: {
					from: window.location.hash,
					to: hash
				}
				
			}
			
			
			//window.location.hash = hash;
			$.address.value(hash.replace('#/', ''));
		},
		
		pictures: {
			activeProduct: null,
			pictures: $('#product-viewer a').click(function(e) { e.preventDefault() }),
			initProduct: null,
			speed: 800,
			fromx: '-100%',
			tox: '200%',
			productInfoHitArea: $('.section.pictures .product-info-hit-area'),
			productInfo: $('#product-info'),
			
			init: function() {
				$.pictures.productInfoHitArea.css('opacity', 0);
				this.pictures.find('img').load(function() {
					$.pictures.productInfoHitArea.hover(function() {
						$.pictures.productInfo.fadeIn();
					},
					function() {
						$.pictures.productInfo.fadeOut();
					});
					$.pictures.alignImage($(this));
					$(this).parent().hide();
				});
				
				if(this.initProduct == null) {
					this.initProduct = this.pictures.eq(0);
				}
				
				this.initProduct.find('img').load(function() {
					$.pictures.change($(this).parent());
				});
			},
			
			alignImage: function(el) {
				el.css({
					marginLeft: (el.width() / 2) * -1,
					marginTop: ((el.height() / 2) * -1)
				});
			},
			
			alignImages: function() {
				this.pictures.find('img').each(function() {
					$.pictures.alignImage($(this));
				});
			},
			
			change: function(el) {
				if(this.activeProduct == el) {
				 	log('return');
					return;
				}
				
				if(this.pictures.index(this.activeProduct) < this.pictures.index(el)) {
					var s = this.fromx;
					var e = this.tox;
				} else {
					var s = this.tox;
					var e = this.fromx;
				}
				
				if(this.activeProduct != null) {
					this.activeProduct.find('img').stop().animate({'opacity': 0, left: s}, this.speed);
				}
				
				var img = el.find('img');
				
				el.show();
				
				img.css({
					'opacity': 0,
					'left': e
				}).stop().animate({'opacity': 1, 'left': '50%'}, this.speed);
				
				$.pictures.alignImage(img);
				
				this.activeProduct = el;
				
				
				$('#product-info').text($.pictures.activeProduct.find('img').attr('alt'))
					.css('marginTop', ($('#product-info').outerHeight() / 2) * -1);;
				
				$('#product-categories a').each(function() {
					$(this).removeClass('selected');
					if($.pictures.activeProduct.hasClass($(this).attr('href').split('#')[1])) {
						$(this).addClass('selected');
					}
				});
				
				if($.globals.activePart == 'white') {
					this.changeHashToProduct();
				}
			},
			
			changeHashToProduct: function(el) {
				if(this.activeProduct != null)
					$.changeHash('/' + $('.pictures.section').attr('id') +'/'+ this.activeProduct.attr('id'));
			},
			
			next: function(el) {
				var index = this.pictures.index(this.activeProduct)+1;
				if(index <= this.pictures.length-1) {
					this.change(this.pictures.eq(index));
					//this.changeHashToProduct(this.pictures.eq(index));
				}
			},
			
			prev: function(el) {
				var index = this.pictures.index(this.activeProduct)-1;
				if(index >= 0) {
					this.change(this.pictures.eq(index));
					//this.changeHashToProduct(this.pictures.eq(index));
				}
			}
		},
		
		navigateTo: function(el, jump) {
			$.globals.previousElement = $.globals.activeElement;
			$.globals.activeElement = el;
			
			var jump = jump || false;
			
			if(el.length == 0) {
				return false;
			}
			
			
			if(!el.hasClass('pictures')) {
				var previousActivePart = $.globals.activePart;
				$.globals.activePart = 'black';
				
				$.globals.menufadeelements.not('#product-categories, #product-info').each(function() {
					if($(this).css('opacity') < 1) {
						$(this).animate({'opacity': 1}, 300, function() {
							if(!$.support.opacity) {
								$(this).get(0).style.filter = '';
							}
						});
					}
				});
				
				
				var newleft = el.offset().left-380;
				if(!jump)
					var speed = (Math.abs($(window).scrollLeft() - newleft) * $.settings.scrollSpeed / 2) + 300;
				else
					var speed = 1;
				
				$('html,body').queue([]).stop();
				//$('html').scrollTo({ left: newleft, top: 0 }, speed, { });
				$('#backgrounds').stop().animate({ left: $.globals.activeElement.position().left / $.settings.backgroundMovementDivider }, speed);
				
				$('html,body').queue([]).stop().animate({ scrollLeft: newleft }, speed)
				
				if(previousActivePart == 'white') {
					$('.pictures.section').stop().animate({
						height: 0
					});
					
					$('#product-info').stop().animate({'opacity': 0},150);
					$('#product-categories').stop().animate({'opacity': 0},150);
					$('#product-viewer').fadeOut(speed);
				}
			} else {
				
				if(!jump)
					var speed = 500;
				else
					var speed = 0;
				
				$.globals.activePart = 'white';
				
				this.pictures.changeHashToProduct();
				
				$(document).trigger('mousemove');
				
				el.stop().animate({
					height: $(window).height() - $.globals.headerHeight
				}, speed);
				
				$('#product-info').stop().animate({'opacity': 1}, 400);
				$('#product-categories').stop().animate({'opacity': 1}, 150);
				$('#product-viewer').fadeIn(speed);
				
				$.pictures.alignImages();
			}
			
			
			
			if(el.hasClass('section')) {
				var sectionId = el.attr('id');
			} else {
				var sectionId = el.parents('.section').attr('id');
			}
			
			if(window.location.hash != sectionId) {
				if($.globals.activePart == 'black') {
					$.changeHash('#/'+sectionId);
				} else {
					//$.pictures.changeHashToProduct();
				}
				
				var menuElementSelected = $('#main-header nav a[href=#'+sectionId+']');
				var arrow = $('#main-header nav .arrow');
				
				$.address.title(menuElementSelected.text() + '  —  ' + $.globals.siteTitle);
				
				if(menuElementSelected.parent().hasClass('home')) {
					arrow.stop().animate({ height: 0 }, 200);
				} else {
					var newLeft = menuElementSelected.position().left + (menuElementSelected.width() / 2) + 40;
					
					if(arrow.height() < 6) {
						arrow.css('left', newLeft);
						var animateOptions = { height: 6 }
						speed = 200;
					} else {
						var animateOptions = { left: newLeft }
					}
					
					arrow.stop().queue([]).animate(animateOptions, speed);
				}
				
				$('#main-header nav a').removeClass('active');
				menuElementSelected.addClass('active');
			}
		},
		
		initNavigation: function() {
			var nav = this;
			var elements = $('#sections .section').add('#sections .section article .column');
			var timer = null;
			var hovering = false;
			var stopped = true;
			
			var arrows = $('#arrows');
			var arrowslinks = arrows.find('a');
			var arrownext = arrows.find('.next');
			var arrowprev = arrows.find('.prev');
			
			var productcategories = $('#product-categories a');
			
			arrowslinks.add($.globals.menufadeelements).show();
			if($.globals.activePart == 'black') {
				
				$('#product-categories, #product-info').css('opacity', 0);
			}
			
			arrowslinks.add($.globals.menufadeelements).hover(function() {
				hovering = true;
			}, function() {
				hovering = false;
			});
			
			productcategories.click(function(e) {
				e.preventDefault();
				
				var product = $('.'+($(this).attr('href').split('#')[1])).eq(0);
				$.pictures.change(product);
			});
			
			$(document).bind('mousemove keydown', $.throttle( 200, function() {
				if(stopped == true) {
					arrowslinks.stop().animate({ opacity: 1 });
					if($.globals.activePart == 'white') {
						$.globals.menufadeelements.stop().animate({ opacity: 1 }, 200, function() {
							if(!$.support.opacity) {
								$(this).get(0).style.filter = '';
							}
						});
					}
					stopped = false;
				}
				
				clearTimeout(timer);
				if(!hovering) {
					timer = setTimeout(function() {
						if($.globals.activePart == 'white') {
							$.globals.menufadeelements.animate({ opacity: 0 },800);
						}
						arrowslinks.stop().animate({ opacity: 0 },800);
						stopped = true;
					}, 1500);
				}
			})).trigger('mousemove');
			
			$(window).resize( $.throttle(100, function() {
				if($.globals.activePart == 'white') {
					$.globals.activeElement.height($(window).height() - $.globals.headerHeight);
				}
			})).trigger('resize');
			
			$(window).resize(function(e) {
				e.preventDefault();
				$(window).scrollLeft($.globals.scrollleft);
			});
			
			nav.next = function() {
				if($.globals.activePart == 'black') {
					var newindex = elements.index($.globals.activeElement)+1;
					if(newindex <= elements.length -1) {
						var newel = elements.eq(newindex);
						$.navigateTo(newel);
					}
				} else {
					$.pictures.next();
				}
			}
			
			nav.prev = function() {
				if($.globals.activePart == 'black') {
					var newindex = elements.index($.globals.activeElement)-1;
					if(newindex >= 0) {
						var newel = elements.eq(newindex);
						$.navigateTo(newel);
					}
				} else {
					$.pictures.prev();
				}
			}
			
			arrownext.click(function(e) { e.preventDefault(); nav.next(); });
			arrowprev.click(function(e) { e.preventDefault(); nav.prev(); });
			
			$(document).keydown(function(e) {
				if(e.which == 37 ||
				   e.which == 38 ||
				   e.which == 39 ||
				   e.which == 40) {
				   	e.preventDefault();
					
					var scrollY = 300;
					
					switch(e.which) {
						case 37:
							nav.prev();
						break;
						case 39:
							nav.next();
						break;
						case 38:
							if($.globals.activePart == 'black') {
								if($(window).scrollTop() == 0) {
									$.navigateTo($('.section.pictures'));
								} else {
									$('html,body').queue([]).stop();
									$('html,body').stop().animate({
										scrollTop: $(window).scrollTop() - scrollY,
										scrollLeft: $(window).scrollLeft()
									}, 300);
									//$('#backgrounds').stop().animate({ left: $(window).scrollLeft() / $.settings.backgroundMovementDivider });
								}
							}
						break;
						case 40:
							if($.globals.activePart == 'black') {
								$('html,body').queue([]).stop();
								log('black and down')
								$('html,body').stop().animate({
									scrollTop: $(window).scrollTop() + scrollY,
									scrollLeft: $(window).scrollLeft()
								}, 300);
								//$('#backgrounds').stop().animate({ left: $(window).scrollLeft() / $.settings.backgroundMovementDivider });
							} else {
								var previousSection = $.globals.previousElement;
								if(previousSection != null && !previousSection.hasClass('pictures')) {
									$.navigateTo(previousSection);
								} else {
									$.navigateTo($('.section.home'));
								}
							}
						break;
					}
				}
			});
		}
	});
	
	
	
	$.fn.extend({
		lazyLoad: function() {
			return $(this).each(function() {
				$link = $(this);
				$image = $(this).find('img');
					
				$image.hide().load(function() {
					//$(this).fadeIn(2000);
					$(this).show();
				});
				
				$image.attr('src', $link.attr('href'))
				if($image.parents('.slideshow').length === 0){
					$image
						.css('cursor', 'default')
						.click(function(e) {e.preventDefault()});
				}
			});
		},
		
		columnSlideshow: function() {
			return $(this).each(function() {
				var $self = $(this);
				var $imagewrapper = $self.find('.images');
				var $images = $imagewrapper.find('a');
				
				var currentImage = 0;
				
				$images.click(function(e) { e.preventDefault() })
				
				$self.nextImage = function() {
					if(currentImage == $images.length - 1) {
						currentImage = 0;
					} else {
						currentImage++;
					}
					
					$self.find('.current').text(currentImage+1);
					
					var newleft = ($images.eq(0).width() * currentImage) *-1;
					$imagewrapper.stop().animate({'left': newleft });
				}
				
				$.address.wrap(true);
				$self.click($self.nextImage);
			});
		},
		
		initMainMenu: function() {
			return $(this).click(function(e) {
				e.preventDefault();
				var url = $(this).attr('href');
				
				$.globals.activeElement = $(url);
				
				$.navigateTo($(url));
			});
		}
	});
	
	$.address.externalChange(function(event) {
		var pathNames = event.pathNames;
		
		if(pathNames.length > 0) {
			var section = $('#'+pathNames[0]);
			
			if(section.hasClass('pictures') && pathNames.length > 1) {
				if($.globals.isFirstHashChange) {
					$.pictures.initProduct = $('#' + pathNames[1]);
				} else {
					$.pictures.change($('#' + pathNames[1]));
				}
			}
			
			$.navigateTo(section, $.globals.isFirstHashChange);
		} else {
			$.navigateTo($('.section.home'), $.globals.isFirstHashChange);
		}
		
		if($.globals.isFirstHashChange) {
			$.pictures.init();
			$.initNavigation();
		}
		
		$.globals.isFirstHashChange = false;
	});
	
	$(function() {
		$.fn.reverse = [].reverse; 
		
		$.globals.siteTitle = $.address.title();
		
		if($('#ie6-message').length > 0) {
			$('#no-js-message').remove();
			return;
		}
		
		$('body').removeClass('no-js').addClass('has-js');
		
		$.globals.headerHeight = $('#main-header').outerHeight();
		$('.lazyLoad').reverse().lazyLoad();
		$('#sections .slideshow').columnSlideshow();
		
		$('nav #menu a').initMainMenu();
		
		$(window).scroll(function() {
			$.globals.scrollleft = $(this).scrollLeft();
		});
	});
})(jQuery);