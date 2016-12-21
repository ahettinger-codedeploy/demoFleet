// page init
jQuery(function(){
	initSetVideoHeight();
	initMobileNav();
	initSameHeight();
	initFitVids();
	jQuery('input, textarea').placeholder();
	initCyclicCenterGallery();
});

// cyclic center gallery init
function initCyclicCenterGallery(){
	jQuery('.carousel').multiSlideCenterCyclicGallery({
		mask: '.mask',
		slideset: '.slideset',
		slides: '.slide',
		btnPrev: '.prev',
		btnNext: '.next',
		pagerLinks: '.pagination li',
		animSpeed: 400,
		switchTime: 6000,
		autoRotation: true,
		handleTouch: true
	});
}

function initSetVideoHeight(){
	jQuery('.column:has(.video-box)').each(function(){
		var holder = jQuery(this);
		var box = holder.find('.video-box');
		var content = holder.find('.content-column');
		if(content.length){
			var timer;
			function resetHeight(){
				box.css({height:''});
			}
			function setHeight(){
				if(content.height() < holder.height()){
					var dif = holder.height() - content.height();
					box.css({height: box.height() + dif});
				}
			}
			jQuery(window).on('load resize orientationchange',function(){
				resetHeight();
				clearTimeout(timer);
				timer = setTimeout(setHeight,100);
			})
		}
	})
}

// mobile menu init
function initMobileNav() {
	jQuery('.wrap').mobileNav({
		hideOnClickOutside: true,
		menuActiveClass: 'active',
		menuOpener: '.opener',
		menuDrop: '.drop'
	});
}

// align blocks height
function initSameHeight() {
	jQuery('#threecolumns').sameHeight({
		elements: '.column',
		//useMinHeight: true,
		multiLine: true
	});
}

// handle flexible video size
function initFitVids() {
	jQuery('.video-box').fitVids();
}

/*
 * jQuery cyclic center gallery plugin
*/
;(function($){
	function MultiSlideCenterCyclicGallery(options){
		this.options = $.extend({
			slideset: '.slideset',
			mask: '.mask',
			slides: '.slide',
			btnPrev: '.prev',
			btnNext: '.next',
			activeClass:'active',
			galleryReadyClass: 'gallery-js-ready',
			cloneRightClass: 'right-clone',
			cloneLeftClass: 'left-clone',
			animSpeed: 500,
			switchTime: 3000,
			swipeThreshold: 15,
			generatePagination: false,
			pagerList: '<ul>',
			pagerListItem: '<li><a href="#"></a></li>',
			pagerListItemText: 'a',
			pagerLinks: '.pagination li',
			event: 'click',
			autoRotation: false,
			handleTouch: false
		}, options);
		this.init();
	}
	MultiSlideCenterCyclicGallery.prototype = {
		init: function(){
			if(this.options.holder) {
				this.findElements();
				this.initState();
				this.attachEvents();
				this.autoRotate();
				this.refreshState();
				this.makeCallback('onInit', this);
			}
		},
		findElements: function(){
			// control elements
			this.gallery = $(this.options.holder).addClass(this.options.galleryReadyClass);
			this.slideset = this.gallery.find(this.options.slideset);
			this.slides = this.slideset.find(this.options.slides);
			this.btnPrev = this.gallery.find(this.options.btnPrev);
			this.btnNext = this.gallery.find(this.options.btnNext);
			this.mask = this.gallery.find(this.options.mask);
			this.slideCount = this.slides.length;
			this.currentStep = 0;
			this.stepsCount = 0;
			this.swipeProperties = ['left', 'right'];
			this.refreshPosition;
			
			this.galleryAnimating = false;
			// create gallery pagination
			if(typeof this.options.generatePagination === 'string') {
				this.pagerLinks = this.buildPagination();
			} else {
				this.pagerLinks = this.gallery.find(this.options.pagerLinks);
			}
		},
		initState: function(){
			this.cloneLeft = this.slides.clone().addClass(this.options.cloneLeftClass).prependTo(this.slideset);
			this.cloneRight = this.slides.clone().addClass(this.options.cloneRightClass).appendTo(this.slideset);
			this.slideset.css({
				width: this.mask.outerWidth(true)*this.slides.length*3,
				marginLeft: -this.mask.outerWidth()*this.slides.length
			})
		},
		buildPagination: function() {
			var pagerLinks = $();
			if(!this.pagerHolder) {
				this.pagerHolder = this.gallery.find(this.options.generatePagination);
			}
			if(this.pagerHolder.length) {
				this.pagerHolder.empty();
				this.pagerList = jQuery(this.options.pagerList).appendTo(this.pagerHolder);
				for(var i = 0; i < this.slides.length; i++) {
					jQuery(this.options.pagerListItem).appendTo(this.pagerList).find(this.options.pagerListItemText).text(i+1);
				}
				pagerLinks = this.pagerList.children();
			}
			return pagerLinks;
		},
		attachEvents: function(){
			var self = this;
			
			if(this.pagerLinks.length) {
				this.pagerLinksHandler = function(e) {
					e.preventDefault();
					self.numSlide(self.pagerLinks.index(e.currentTarget));
				};
				this.pagerLinks.on(this.options.event, this.pagerLinksHandler);
			}
			// previous and next button handlers
			if(this.btnPrev.length) {
				this.prevSlideHandler = function(e) {
					e.preventDefault();
					self.prevSlide();
				};
				this.btnPrev.bind(this.options.event, this.prevSlideHandler);
			}
			if(this.btnNext.length) {
				this.nextSlideHandler = function(e) {
					e.preventDefault();
					self.nextSlide();
				};
				this.btnNext.bind(this.options.event, this.nextSlideHandler);
			}
			this.onWindowResize();
			this.windowResizeHandler = function(){
				self.onWindowResize();
			}
			$(window).bind('load resize orientationchange', this.windowResizeHandler);
			if(isTouchDevice) {
				this.slideset.css({'-webkit-transform': 'translate3d(0px, 0px, 0px)'});
				
				if(this.options.handleTouch && jQuery.fn.hammer) {
					this.slideset.hammer({
						drag_block_horizontal: true,
						drag_block_vertical: false,
						drag_min_distance: 1
					}).on('touch release dragleft dragright swipeleft swiperight', function(ev){
						self.originalOffset = parseInt(self.getStepOffset(), 10);
						switch(ev.type) {
							case ('dragright'):
							case ('dragleft'):
								if(!self.galleryAnimating){
									if(ev.gesture.direction === self.swipeProperties[0] || ev.gesture.direction === self.swipeProperties[1]){
										var dragOffset = self.originalOffset + ev.gesture['deltaX'];
										self.slideset.css({
											marginLeft: dragOffset
										});
										ev.gesture.preventDefault();
									};
								};
								break;
							case ('swipeleft'):
								if(!self.galleryAnimating){
									self.nextSlide();
								}
								ev.gesture.stopDetect();
								break;
							case ('swiperight'):
								if(!self.galleryAnimating){
									 self.prevSlide();
								}
								ev.gesture.stopDetect();
								break;

							case 'release':
								if(!self.galleryAnimating){
									if(Math.abs(ev.gesture['deltaX']) > self.options.swipeThreshold) {
										if(ev.gesture.direction == 'right') self.prevSlide(); else if(ev.gesture.direction == 'left') self.nextSlide();
									}
									else {
										self.switchSlide();
									}
								}
								break;
						}
					});
				}
			}
		},
		getStepOffset: function(){
			return  -(this.currentStep*this.mask.outerWidth() + this.mask.outerWidth()*this.slides.length);
		},
		prevSlide: function(){
			if(!this.galleryAnimating) {
				if(this.currentStep > -this.slides.length) {
					this.currentStep--
					this.switchSlide();
				}
			}
		},
		nextSlide: function(){
			if(!this.galleryAnimating) {
				if(this.currentStep < this.slides.length) {
					this.currentStep++
					this.switchSlide();
				}
			}
		},
		numSlide: function(index){
			if(this.currentStep != index) {
				this.currentStep = index;
				this.switchSlide();
			}
		},
		switchSlide: function(){
			var self = this;
			
			this.galleryAnimating = true;
			this.slideset.stop().animate({
				marginLeft: this.getStepOffset()
			},{duration: this.options.animSpeed, complete: function(){
				// animation complete
				if(self.slideCount === Math.abs(self.currentStep)) {
					self.currentStep = 0;
					self.slideset.css({
						marginLeft: self.getStepOffset()
					});
				}
				if(self.currentStep < 0) {
					self.currentStep = self.slides.length-1;
					self.slideset.css({
						marginLeft: self.getStepOffset()
					});
				}
				
				self.makeCallback('onChange', self);
				self.galleryAnimating = false;
				self.autoRotate();
				self.refreshState();
			}});
			
			this.makeCallback('onBeforeChange', this);
		},
		refreshState: function() {
			this.pagerLinks.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
			this.slides.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
			this.cloneLeft.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
			this.cloneRight.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
		},
		autoRotate: function() {
			var self = this;
			clearTimeout(this.timer);
			if(this.options.autoRotation) {
				this.timer = setTimeout(function(){
					self.nextSlide(true);
				}, this.options.switchTime);
			}
		},
		pauseRotation: function() {
			clearTimeout(this.timer);
		},
		onWindowResize: function(){
			var self = this;
			var maskWidth = {width: this.mask.outerWidth()}
			this.slides.css(maskWidth);
			this.cloneLeft.css(maskWidth);
			this.cloneRight.css(maskWidth);
			this.buildPagination();
			
			this.slideset.css({
				width: this.mask.outerWidth()*this.slides.length*3,
				marginLeft: this.getStepOffset()
			});
		},
		makeCallback: function(name) {
			if(typeof this.options[name] === 'function') {
				var args = Array.prototype.slice.call(arguments);
				args.shift();
				this.options[name].apply(this, args);
			}
		},
		destroy: function() {
			// destroy handler
			var self = this;
			this.btnPrev.unbind(this.options.event, this.prevSlideHandler);
			this.btnNext.unbind(this.options.event, this.nextSlideHandler);
			if(this.options.handleTouch && $.fn.hammer) {
				this.mask.hammer().off('touch release  dragleft dragright swipeleft swiperight');
			}
			$(window).unbind('load resize orientationchange', this.windowResizeHandler);
			// autorotation handlers
			this.pauseRotation();

			// remove clone slides
			this.cloneLeft.remove();
			this.cloneRight.remove();
			
			setTimeout(function(){
				// remove inline styles, classes
				self.gallery.removeClass(self.options.galleryReadyClass);
				self.slideset.add(self.slides).removeAttr('style');
				self.slides.removeClass(self.options.activeClass);
			}, 10);
		}
	};
	var isTouchDevice = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch;

	// jquery plugin
	$.fn.multiSlideCenterCyclicGallery = function(opt){
		return this.each(function(){
			$(this).data('MultiSlideCenterCyclicGallery', new MultiSlideCenterCyclicGallery($.extend(opt,{holder:this})));
		});
	};
}(jQuery));

/*
 * Simple Mobile Navigation
 */
;(function($) {
	function MobileNav(options) {
		this.options = $.extend({
			container: null,
			hideOnClickOutside: false,
			menuActiveClass: 'nav-active',
			menuOpener: '.nav-opener',
			menuDrop: '.nav-drop',
			toggleEvent: 'click',
			outsideClickEvent: 'click touchstart pointerdown MSPointerDown'
		}, options);
		this.initStructure();
		this.attachEvents();
	}
	MobileNav.prototype = {
		initStructure: function() {
			this.page = $('html');
			this.container = $(this.options.container);
			this.opener = this.container.find(this.options.menuOpener);
			this.drop = this.container.find(this.options.menuDrop);
		},
		attachEvents: function() {
			var self = this;

			if(activateResizeHandler) {
				activateResizeHandler();
				activateResizeHandler = null;
			}

			this.outsideClickHandler = function(e) {
				if(self.isOpened()) {
					var target = $(e.target);
					if(!target.closest(self.opener).length && !target.closest(self.drop).length) {
						self.hide();
					}
				}
			};

			this.openerClickHandler = function(e) {
				e.preventDefault();
				self.toggle();
			};

			this.opener.on(this.options.toggleEvent, this.openerClickHandler);
		},
		isOpened: function() {
			return this.container.hasClass(this.options.menuActiveClass);
		},
		show: function() {
			this.container.addClass(this.options.menuActiveClass);
			if(this.options.hideOnClickOutside) {
				this.page.on(this.options.outsideClickEvent, this.outsideClickHandler);
			}
		},
		hide: function() {
			this.container.removeClass(this.options.menuActiveClass);
			if(this.options.hideOnClickOutside) {
				this.page.off(this.options.outsideClickEvent, this.outsideClickHandler);
			}
		},
		toggle: function() {
			if(this.isOpened()) {
				this.hide();
			} else {
				this.show();
			}
		},
		destroy: function() {
			this.container.removeClass(this.options.menuActiveClass);
			this.opener.off(this.options.toggleEvent, this.clickHandler);
			this.page.off(this.options.outsideClickEvent, this.outsideClickHandler);
		}
	};

	var activateResizeHandler = function() {
		var win = $(window),
			doc = $('html'),
			resizeClass = 'resize-active',
			flag, timer;
		var removeClassHandler = function() {
			flag = false;
			doc.removeClass(resizeClass);
		};
		var resizeHandler = function() {
			if(!flag) {
				flag = true;
				doc.addClass(resizeClass);
			}
			clearTimeout(timer);
			timer = setTimeout(removeClassHandler, 500);
		};
		win.on('resize orientationchange', resizeHandler);
	};

	$.fn.mobileNav = function(options) {
		return this.each(function() {
			var params = $.extend({}, options, {container: this}),
				instance = new MobileNav(params);
			$.data(this, 'MobileNav', instance);
		});
	};
}(jQuery));

/*
 * jQuery SameHeight plugin
 */
;(function($){
	$.fn.sameHeight = function(opt) {
		var options = $.extend({
			skipClass: 'same-height-ignore',
			leftEdgeClass: 'same-height-left',
			rightEdgeClass: 'same-height-right',
			elements: '>*',
			flexible: false,
			multiLine: false,
			useMinHeight: false,
			biggestHeight: false
		},opt);
		return this.each(function(){
			var holder = $(this), postResizeTimer, ignoreResize;
			var elements = holder.find(options.elements).not('.' + options.skipClass);
			if(!elements.length) return;

			// resize handler
			function doResize() {
				elements.css(options.useMinHeight && supportMinHeight ? 'minHeight' : 'height', '');
				if(options.multiLine) {
					// resize elements row by row
					resizeElementsByRows(elements, options);
				} else {
					// resize elements by holder
					resizeElements(elements, holder, options);
				}
			}
			doResize();

			// handle flexible layout / font resize
			var delayedResizeHandler = function() {
				if(!ignoreResize) {
					ignoreResize = true;
					doResize();
					clearTimeout(postResizeTimer);
					postResizeTimer = setTimeout(function() {
						doResize();
						setTimeout(function(){
							ignoreResize = false;
						}, 10);
					}, 100);
				}
			};

			// handle flexible/responsive layout
			if(options.flexible) {
				$(window).bind('resize orientationchange fontresize', delayedResizeHandler);
			}

			// handle complete page load including images and fonts
			$(window).bind('load', delayedResizeHandler);
		});
	};

	// detect css min-height support
	var supportMinHeight = typeof document.documentElement.style.maxHeight !== 'undefined';

	// get elements by rows
	function resizeElementsByRows(boxes, options) {
		var currentRow = $(), maxHeight, maxCalcHeight = 0, firstOffset = boxes.eq(0).offset().top;
		boxes.each(function(ind){
			var curItem = $(this);
			if(curItem.offset().top === firstOffset) {
				currentRow = currentRow.add(this);
			} else {
				maxHeight = getMaxHeight(currentRow);
				maxCalcHeight = Math.max(maxCalcHeight, resizeElements(currentRow, maxHeight, options));
				currentRow = curItem;
				firstOffset = curItem.offset().top;
			}
		});
		if(currentRow.length) {
			maxHeight = getMaxHeight(currentRow);
			maxCalcHeight = Math.max(maxCalcHeight, resizeElements(currentRow, maxHeight, options));
		}
		if(options.biggestHeight) {
			boxes.css(options.useMinHeight && supportMinHeight ? 'minHeight' : 'height', maxCalcHeight);
		}
	}

	// calculate max element height
	function getMaxHeight(boxes) {
		var maxHeight = 0;
		boxes.each(function(){
			maxHeight = Math.max(maxHeight, $(this).outerHeight());
		});
		return maxHeight;
	}

	// resize helper function
	function resizeElements(boxes, parent, options) {
		var calcHeight;
		var parentHeight = typeof parent === 'number' ? parent : parent.height();
		boxes.removeClass(options.leftEdgeClass).removeClass(options.rightEdgeClass).each(function(i){
			var element = $(this);
			var depthDiffHeight = 0;
			var isBorderBox = element.css('boxSizing') === 'border-box' || element.css('-moz-box-sizing') === 'border-box' || element.css('-webkit-box-sizing') === 'border-box';

			if(typeof parent !== 'number') {
				element.parents().each(function(){
					var tmpParent = $(this);
					if(parent.is(this)) {
						return false;
					} else {
						depthDiffHeight += tmpParent.outerHeight() - tmpParent.height();
					}
				});
			}
			calcHeight = parentHeight - depthDiffHeight;
			calcHeight -= isBorderBox ? 0 : element.outerHeight() - element.height();

			if(calcHeight > 0) {
				element.css(options.useMinHeight && supportMinHeight ? 'minHeight' : 'height', calcHeight);
			}
		});
		boxes.filter(':first').addClass(options.leftEdgeClass);
		boxes.filter(':last').addClass(options.rightEdgeClass);
		return calcHeight;
	}
}(jQuery));

/*
 * jQuery FontResize Event
 */
jQuery.onFontResize = (function($) {
	$(function() {
		var randomID = 'font-resize-frame-' + Math.floor(Math.random() * 1000);
		var resizeFrame = $('<iframe>').attr('id', randomID).addClass('font-resize-helper');

		// required styles
		resizeFrame.css({
			width: '100em',
			height: '10px',
			position: 'absolute',
			borderWidth: 0,
			top: '-9999px',
			left: '-9999px'
		}).appendTo('body');

		// use native IE resize event if possible
		if (window.attachEvent && !window.addEventListener) {
			resizeFrame.bind('resize', function () {
				$.onFontResize.trigger(resizeFrame[0].offsetWidth / 100);
			});
		}
		// use script inside the iframe to detect resize for other browsers
		else {
			var doc = resizeFrame[0].contentWindow.document;
			doc.open();
			doc.write('<scri' + 'pt>window.onload = function(){var em = parent.jQuery("#' + randomID + '")[0];window.onresize = function(){if(parent.jQuery.onFontResize){parent.jQuery.onFontResize.trigger(em.offsetWidth / 100);}}};</scri' + 'pt>');
			doc.close();
		}
		jQuery.onFontResize.initialSize = resizeFrame[0].offsetWidth / 100;
	});
	return {
		// public method, so it can be called from within the iframe
		trigger: function (em) {
			$(window).trigger("fontresize", [em]);
		}
	};
}(jQuery));

/*! http://mths.be/placeholder v2.0.7 by @mathias */
;(function(window, document, $) {

	// Opera Mini v7 doesn’t support placeholder although its DOM seems to indicate so
	var isOperaMini = Object.prototype.toString.call(window.operamini) == '[object OperaMini]';
	var isInputSupported = 'placeholder' in document.createElement('input') && !isOperaMini;
	var isTextareaSupported = 'placeholder' in document.createElement('textarea') && !isOperaMini;
	var prototype = $.fn;
	var valHooks = $.valHooks;
	var propHooks = $.propHooks;
	var hooks;
	var placeholder;

	if (isInputSupported && isTextareaSupported) {

		placeholder = prototype.placeholder = function() {
			return this;
		};

		placeholder.input = placeholder.textarea = true;

	} else {

		placeholder = prototype.placeholder = function() {
			var $this = this;
			$this
				.filter((isInputSupported ? 'textarea' : ':input') + '[placeholder]')
				.not('.placeholder')
				.bind({
					'focus.placeholder': clearPlaceholder,
					'blur.placeholder': setPlaceholder
				})
				.data('placeholder-enabled', true)
				.trigger('blur.placeholder');
			return $this;
		};

		placeholder.input = isInputSupported;
		placeholder.textarea = isTextareaSupported;

		hooks = {
			'get': function(element) {
				var $element = $(element);

				var $passwordInput = $element.data('placeholder-password');
				if ($passwordInput) {
					return $passwordInput[0].value;
				}

				return $element.data('placeholder-enabled') && $element.hasClass('placeholder') ? '' : element.value;
			},
			'set': function(element, value) {
				var $element = $(element);

				var $passwordInput = $element.data('placeholder-password');
				if ($passwordInput) {
					return $passwordInput[0].value = value;
				}

				if (!$element.data('placeholder-enabled')) {
					return element.value = value;
				}
				if (value == '') {
					element.value = value;
					// Issue #56: Setting the placeholder causes problems if the element continues to have focus.
					if (element != safeActiveElement()) {
						// We can't use `triggerHandler` here because of dummy text/password inputs :(
						setPlaceholder.call(element);
					}
				} else if ($element.hasClass('placeholder')) {
					clearPlaceholder.call(element, true, value) || (element.value = value);
				} else {
					element.value = value;
				}
				// `set` can not return `undefined`; see http://jsapi.info/jquery/1.7.1/val#L2363
				return $element;
			}
		};

		if (!isInputSupported) {
			valHooks.input = hooks;
			propHooks.value = hooks;
		}
		if (!isTextareaSupported) {
			valHooks.textarea = hooks;
			propHooks.value = hooks;
		}

		$(function() {
			// Look for forms
			$(document).delegate('form', 'submit.placeholder', function() {
				// Clear the placeholder values so they don't get submitted
				var $inputs = $('.placeholder', this).each(clearPlaceholder);
				setTimeout(function() {
					$inputs.each(setPlaceholder);
				}, 10);
			});
		});

		// Clear placeholder values upon page reload
		$(window).bind('beforeunload.placeholder', function() {
			$('.placeholder').each(function() {
				this.value = '';
			});
		});

	}

	function args(elem) {
		// Return an object of element attributes
		var newAttrs = {};
		var rinlinejQuery = /^jQuery\d+$/;
		$.each(elem.attributes, function(i, attr) {
			if (attr.specified && !rinlinejQuery.test(attr.name)) {
				newAttrs[attr.name] = attr.value;
			}
		});
		return newAttrs;
	}

	function clearPlaceholder(event, value) {
		var input = this;
		var $input = $(input);
		if (input.value == $input.attr('placeholder') && $input.hasClass('placeholder')) {
			if ($input.data('placeholder-password')) {
				$input = $input.hide().next().show().attr('id', $input.removeAttr('id').data('placeholder-id'));
				// If `clearPlaceholder` was called from `$.valHooks.input.set`
				if (event === true) {
					return $input[0].value = value;
				}
				$input.focus();
			} else {
				input.value = '';
				$input.removeClass('placeholder');
				input == safeActiveElement() && input.select();
			}
		}
	}

	function setPlaceholder() {
		var $replacement;
		var input = this;
		var $input = $(input);
		var id = this.id;
		if (input.value == '') {
			if (input.type == 'password') {
				if (!$input.data('placeholder-textinput')) {
					try {
						$replacement = $input.clone().attr({ 'type': 'text' });
					} catch(e) {
						$replacement = $('<input>').attr($.extend(args(this), { 'type': 'text' }));
					}
					$replacement
						.removeAttr('name')
						.data({
							'placeholder-password': $input,
							'placeholder-id': id
						})
						.bind('focus.placeholder', clearPlaceholder);
					$input
						.data({
							'placeholder-textinput': $replacement,
							'placeholder-id': id
						})
						.before($replacement);
				}
				$input = $input.removeAttr('id').hide().prev().attr('id', id).show();
				// Note: `$input[0] != input` now!
			}
			$input.addClass('placeholder');
			$input[0].value = $input.attr('placeholder');
		} else {
			$input.removeClass('placeholder');
		}
	}

	function safeActiveElement() {
		// Avoid IE9 `document.activeElement` of death
		// https://github.com/mathiasbynens/jquery-placeholder/pull/99
		try {
			return document.activeElement;
		} catch (err) {}
	}

}(this, document, jQuery));

/*!
* FitVids 1.0.3
*
* Copyright 2013, Chris Coyier - http://css-tricks.com + Dave Rupert - http://daverupert.com
* Credit to Thierry Koblentz - http://www.alistapart.com/articles/creating-intrinsic-ratios-for-video/
* Released under the WTFPL license - http://sam.zoy.org/wtfpl/
*
* Date: Thu Sept 01 18:00:00 2011 -0500
*/
;(function(b){b.fn.fitVids=function(a){var j={customSelector:null};if(!document.getElementById("fit-vids-style")){var g=document.createElement("div"),i=document.getElementsByTagName("base")[0]||document.getElementsByTagName("script")[0],h="&shy;<style>.fluid-width-video-wrapper{width:100%;position:relative;padding:0;}.fluid-width-video-wrapper iframe,.fluid-width-video-wrapper object,.fluid-width-video-wrapper embed {position:absolute;top:0;left:0;width:100%;height:100%;}</style>";g.className="fit-vids-style";g.id="fit-vids-style";g.style.display="none";g.innerHTML=h;i.parentNode.insertBefore(g,i)}if(a){b.extend(j,a)}return this.each(function(){var d=["iframe[src*='player.vimeo.com']","iframe[src*='youtube.com']","iframe[src*='youtube-nocookie.com']","iframe[src*='kickstarter.com'][src*='video.html']","object","embed"];if(j.customSelector){d.push(j.customSelector)}var c=b(this).find(d.join(","));c=c.not("object object");c.each(function(q,r){var e=b(this);if(this.tagName.toLowerCase()==="embed"&&e.parent("object").length||e.parent(".fluid-width-video-wrapper").length){return}var p=(this.tagName.toLowerCase()==="object"||(e.attr("height")&&!isNaN(parseInt(e.attr("height"),10))))?parseInt(e.attr("height"),10):e.height(),o=!isNaN(parseInt(e.attr("width"),10))?parseInt(e.attr("width"),10):e.width(),n=p/o;if(!e.attr("id")){var f="fitvid"+Math.floor(Math.random()*999999);e.attr("id",f)}e.wrap('<div class="fluid-width-video-wrapper"></div>').parent(".fluid-width-video-wrapper").css("padding-top",(n*100)+"%");e.removeAttr("height").removeAttr("width");b(window).on("resize orientationchange",function(){e.parent(".fluid-width-video-wrapper").css("padding-top","");var s=(r.tagName.toLowerCase()==="object"||(e.attr("height")&&!isNaN(parseInt(e.attr("height"),10))))?parseInt(e.attr("height"),10):e.height(),m=!isNaN(parseInt(e.attr("width"),10))?parseInt(e.attr("width"),10):e.width(),l=s/m;e.parent(".fluid-width-video-wrapper").css("padding-top",(l*100)+"%")})})})}})(window.jQuery||window.Zepto);