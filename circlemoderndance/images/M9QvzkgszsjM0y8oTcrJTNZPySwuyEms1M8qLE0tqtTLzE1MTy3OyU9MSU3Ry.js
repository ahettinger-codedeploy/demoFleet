/*!
 * imagesLoaded PACKAGED v3.0.4
 * JavaScript is all like "You images are done yet or what?"
 */

(function(){"use strict";function e(){}function t(e,t){for(var n=e.length;n--;)if(e[n].listener===t)return n;return-1}var n=e.prototype;n.getListeners=function(e){var t,n,i=this._getEvents();if("object"==typeof e){t={};for(n in i)i.hasOwnProperty(n)&&e.test(n)&&(t[n]=i[n])}else t=i[e]||(i[e]=[]);return t},n.flattenListeners=function(e){var t,n=[];for(t=0;e.length>t;t+=1)n.push(e[t].listener);return n},n.getListenersAsObject=function(e){var t,n=this.getListeners(e);return n instanceof Array&&(t={},t[e]=n),t||n},n.addListener=function(e,n){var i,r=this.getListenersAsObject(e),o="object"==typeof n;for(i in r)r.hasOwnProperty(i)&&-1===t(r[i],n)&&r[i].push(o?n:{listener:n,once:!1});return this},n.on=n.addListener,n.addOnceListener=function(e,t){return this.addListener(e,{listener:t,once:!0})},n.once=n.addOnceListener,n.defineEvent=function(e){return this.getListeners(e),this},n.defineEvents=function(e){for(var t=0;e.length>t;t+=1)this.defineEvent(e[t]);return this},n.removeListener=function(e,n){var i,r,o=this.getListenersAsObject(e);for(r in o)o.hasOwnProperty(r)&&(i=t(o[r],n),-1!==i&&o[r].splice(i,1));return this},n.off=n.removeListener,n.addListeners=function(e,t){return this.manipulateListeners(!1,e,t)},n.removeListeners=function(e,t){return this.manipulateListeners(!0,e,t)},n.manipulateListeners=function(e,t,n){var i,r,o=e?this.removeListener:this.addListener,s=e?this.removeListeners:this.addListeners;if("object"!=typeof t||t instanceof RegExp)for(i=n.length;i--;)o.call(this,t,n[i]);else for(i in t)t.hasOwnProperty(i)&&(r=t[i])&&("function"==typeof r?o.call(this,i,r):s.call(this,i,r));return this},n.removeEvent=function(e){var t,n=typeof e,i=this._getEvents();if("string"===n)delete i[e];else if("object"===n)for(t in i)i.hasOwnProperty(t)&&e.test(t)&&delete i[t];else delete this._events;return this},n.emitEvent=function(e,t){var n,i,r,o,s=this.getListenersAsObject(e);for(r in s)if(s.hasOwnProperty(r))for(i=s[r].length;i--;)n=s[r][i],o=n.listener.apply(this,t||[]),(o===this._getOnceReturnValue()||n.once===!0)&&this.removeListener(e,s[r][i].listener);return this},n.trigger=n.emitEvent,n.emit=function(e){var t=Array.prototype.slice.call(arguments,1);return this.emitEvent(e,t)},n.setOnceReturnValue=function(e){return this._onceReturnValue=e,this},n._getOnceReturnValue=function(){return this.hasOwnProperty("_onceReturnValue")?this._onceReturnValue:!0},n._getEvents=function(){return this._events||(this._events={})},"function"==typeof define&&define.amd?define(function(){return e}):"undefined"!=typeof module&&module.exports?module.exports=e:this.EventEmitter=e}).call(this),function(e){"use strict";var t=document.documentElement,n=function(){};t.addEventListener?n=function(e,t,n){e.addEventListener(t,n,!1)}:t.attachEvent&&(n=function(t,n,i){t[n+i]=i.handleEvent?function(){var t=e.event;t.target=t.target||t.srcElement,i.handleEvent.call(i,t)}:function(){var n=e.event;n.target=n.target||n.srcElement,i.call(t,n)},t.attachEvent("on"+n,t[n+i])});var i=function(){};t.removeEventListener?i=function(e,t,n){e.removeEventListener(t,n,!1)}:t.detachEvent&&(i=function(e,t,n){e.detachEvent("on"+t,e[t+n]);try{delete e[t+n]}catch(i){e[t+n]=void 0}});var r={bind:n,unbind:i};"function"==typeof define&&define.amd?define(r):e.eventie=r}(this),function(e){"use strict";function t(e,t){for(var n in t)e[n]=t[n];return e}function n(e){return"[object Array]"===c.call(e)}function i(e){var t=[];if(n(e))t=e;else if("number"==typeof e.length)for(var i=0,r=e.length;r>i;i++)t.push(e[i]);else t.push(e);return t}function r(e,n){function r(e,n,s){if(!(this instanceof r))return new r(e,n);"string"==typeof e&&(e=document.querySelectorAll(e)),this.elements=i(e),this.options=t({},this.options),"function"==typeof n?s=n:t(this.options,n),s&&this.on("always",s),this.getImages(),o&&(this.jqDeferred=new o.Deferred);var a=this;setTimeout(function(){a.check()})}function c(e){this.img=e}r.prototype=new e,r.prototype.options={},r.prototype.getImages=function(){this.images=[];for(var e=0,t=this.elements.length;t>e;e++){var n=this.elements[e];"IMG"===n.nodeName&&this.addImage(n);for(var i=n.querySelectorAll("img"),r=0,o=i.length;o>r;r++){var s=i[r];this.addImage(s)}}},r.prototype.addImage=function(e){var t=new c(e);this.images.push(t)},r.prototype.check=function(){function e(e,r){return t.options.debug&&a&&s.log("confirm",e,r),t.progress(e),n++,n===i&&t.complete(),!0}var t=this,n=0,i=this.images.length;if(this.hasAnyBroken=!1,!i)return this.complete(),void 0;for(var r=0;i>r;r++){var o=this.images[r];o.on("confirm",e),o.check()}},r.prototype.progress=function(e){this.hasAnyBroken=this.hasAnyBroken||!e.isLoaded;var t=this;setTimeout(function(){t.emit("progress",t,e),t.jqDeferred&&t.jqDeferred.notify(t,e)})},r.prototype.complete=function(){var e=this.hasAnyBroken?"fail":"done";this.isComplete=!0;var t=this;setTimeout(function(){if(t.emit(e,t),t.emit("always",t),t.jqDeferred){var n=t.hasAnyBroken?"reject":"resolve";t.jqDeferred[n](t)}})},o&&(o.fn.imagesLoaded=function(e,t){var n=new r(this,e,t);return n.jqDeferred.promise(o(this))});var f={};return c.prototype=new e,c.prototype.check=function(){var e=f[this.img.src];if(e)return this.useCached(e),void 0;if(f[this.img.src]=this,this.img.complete&&void 0!==this.img.naturalWidth)return this.confirm(0!==this.img.naturalWidth,"naturalWidth"),void 0;var t=this.proxyImage=new Image;n.bind(t,"load",this),n.bind(t,"error",this),t.src=this.img.src},c.prototype.useCached=function(e){if(e.isConfirmed)this.confirm(e.isLoaded,"cached was confirmed");else{var t=this;e.on("confirm",function(e){return t.confirm(e.isLoaded,"cache emitted confirmed"),!0})}},c.prototype.confirm=function(e,t){this.isConfirmed=!0,this.isLoaded=e,this.emit("confirm",this,t)},c.prototype.handleEvent=function(e){var t="on"+e.type;this[t]&&this[t](e)},c.prototype.onload=function(){this.confirm(!0,"onload"),this.unbindProxyEvents()},c.prototype.onerror=function(){this.confirm(!1,"onerror"),this.unbindProxyEvents()},c.prototype.unbindProxyEvents=function(){n.unbind(this.proxyImage,"load",this),n.unbind(this.proxyImage,"error",this)},r}var o=e.jQuery,s=e.console,a=s!==void 0,c=Object.prototype.toString;"function"==typeof define&&define.amd?define(["eventEmitter/EventEmitter","eventie/eventie"],r):e.imagesLoaded=r(e.EventEmitter,e.eventie)}(window);
;/**!
 * trunk8 v1.3.2
 * https://github.com/rviscomi/trunk8
 * 
 * Copyright 2012 Rick Viscomi
 * Released under the MIT License.
 * 
 * Date: October 21, 2012
 */

(function ($) {
	var methods,
		utils,
		SIDES = {
			/* cen...ter */
			center: 'center',
			/* ...left */
			left: 'left',
			/* right... */
			right: 'right'
		},
		WIDTH = {
			auto: 'auto'
		};
	
	function trunk8(element) {
		this.$element = $(element);
		this.original_text = this.$element.html();
		this.settings = $.extend({}, $.fn.trunk8.defaults);
	}
	
	trunk8.prototype.updateSettings = function (options) {
		this.settings = $.extend(this.settings, options);
	};

	function truncate() {
		var data = this.data('trunk8'),
			settings = data.settings,
			width = settings.width,
			side = settings.side,
			fill = settings.fill,
			line_height = utils.getLineHeight(this) * settings.lines,
			str = data.original_text,
			length = str.length,
			max_bite = '',
			lower, upper,
			bite_size,
			bite;
		
		/* Reset the field to the original string. */
		this.html(str);

		if (width === WIDTH.auto) {
			/* Assuming there is no "overflow: hidden". */
			if (this.height() <= line_height) {
				/* Text is already at the optimal trunkage. */
				return;
			}

			/* Binary search technique for finding the optimal trunkage. */
			/* Find the maximum bite without overflowing. */
			lower = 0;
			upper = length - 1;

			while (lower <= upper) {
				bite_size = lower + ((upper - lower) >> 1);
				
				bite = utils.eatStr(str, side, length - bite_size, fill);
				
				this.html(bite);

				/* Check for overflow. */
				if (this.height() > line_height) {
					upper = bite_size - 1;
				}
				else {
					lower = bite_size + 1;

					/* Save the bigger bite. */
					max_bite = (max_bite.length > bite.length) ? max_bite : bite;
				}
			}

			/* Reset the content to eliminate possible existing scroll bars. */
			this.html('');
			
			/* Display the biggest bite. */
			this.html(max_bite);
			
			if (settings.tooltip) {
				this.attr('title', str);
			}
		}
		else if (!isNaN(width)) {
			bite_size = length - width;

			bite = utils.eatStr(str, side, bite_size, fill);

			this.html(bite);
			
			if (settings.tooltip) {
				this.attr('title', str);
			}
		}
		else {
			$.error('Invalid width "' + width + '".');
		}
	}

	methods = {
		init: function (options) {
			return this.each(function () {
				var $this = $(this),
					data = $this.data('trunk8');
				
				if (!data) {
					$this.data('trunk8', (data = new trunk8(this)));
				}
				
				data.updateSettings(options);
				
				truncate.call($this);
			});
		},

		/** Updates the text value of the elements while maintaining truncation. */
		update: function (new_string) {
			return this.each(function () {
				var $this = $(this);
				
				/* Update text. */
				if (new_string) {
					$this.data('trunk8').original_text = new_string;
				}

				/* Truncate accordingly. */
				truncate.call($this);
			});
		},
		
		revert: function () {
			return this.each(function () {
				/* Get original text. */
				var text = $(this).data('trunk8').original_text;
				
				/* Revert element to original text. */
				$(this).html(text);
			});
		},

		/** Returns this instance's settings object. NOT CHAINABLE. */
		getSettings: function () {
			return this.get(0).data('trunk8').settings;
		}
	};

	utils = {
		/** Replaces [bite_size] [side]-most chars in [str] with [fill]. */
		eatStr: function (str, side, bite_size, fill) {
		    var length = str.length,
		    	key = utils.eatStr.generateKey.apply(null, arguments),
		        half_length,
		        half_bite_size;

	        /* If the result is already in the cache, return it. */
	        if (utils.eatStr.cache[key]) {
				return utils.eatStr.cache[key];
	        }
	        
			/* Common error handling. */
		    if ((typeof str !== 'string') || (length === 0)) {
		    	$.error('Invalid source string "' + str + '".');
		    }
		    if ((bite_size < 0) || (bite_size > length)) {
		    	$.error('Invalid bite size "' + bite_size + '".');
		    }
		    else if (bite_size === 0) {
			    /* No bite should show no truncation. */
				return str;
		    }
		    if (typeof (fill + '') !== 'string') {
				$.error('Fill unable to be converted to a string.');
		    }

			/* Compute the result, store it in the cache, and return it. */
		    switch (side) {
		        case SIDES.right:
			        /* str... */
		            return utils.eatStr.cache[key] =
			            	$.trim(str.substr(0, length - bite_size)) + fill;
		            
		        case SIDES.left:
			        /* ...str */
		            return utils.eatStr.cache[key] =
			            	fill + $.trim(str.substr(bite_size));
		            
		        case SIDES.center:
			        /* Bit-shift to the right by one === Math.floor(x / 2) */
		            half_length = length >> 1; // halve the length
		            half_bite_size = bite_size >> 1; // halve the bite_size

			        /* st...r */
		            return utils.eatStr.cache[key] =
			            	$.trim(utils.eatStr(str.substr(0, length - half_length), SIDES.right, bite_size - half_bite_size, '')) +
		            		fill +
		            		$.trim(utils.eatStr(str.substr(length - half_length), SIDES.left, half_bite_size, ''));
		            
		        default:
		        	$.error('Invalid side "' + side + '".');
		    }
		},
		
		getLineHeight: function (elem) {
	            var $elem = $(elem),
	            	floats = $elem.css('float'),
	            	position = $elem.css('position'),
	            	html = $elem.html(),
			        wrapper_id = 'line-height-test',
			        line_height;
	            
	            if (floats !== 'none') {
	            	$elem.css('float', 'none');
	            }
	            
	            if (position === 'absolute') {
	            	$elem.css('position', 'static');
	            }
	
	            /* Set the content to a small single character and wrap. */
	            $elem.html('i').wrap('<div id="' + wrapper_id + '" />');
	
	            /* Calculate the line height by measuring the wrapper.*/
	            line_height = $('#' + wrapper_id).innerHeight();
	
	            /* Remove the wrapper and reset the style/content. */
	            $elem.html(html).css({
	            	'float': floats,
	            	'position': position
	            }).unwrap();
	
	            return line_height;
	        }
	};

	utils.eatStr.cache = {};
	utils.eatStr.generateKey = function () {
		return Array.prototype.join.call(arguments, '');
	};
	
	$.fn.trunk8 = function (method) {
		if (methods[method]) {
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		}
		else if (typeof method === 'object' || !method) {
			return methods.init.apply(this, arguments);
		}
		else {
			$.error('Method ' + method + ' does not exist on jQuery.trunk8');
		}
	};
	
	/* Default trunk8 settings. */
	$.fn.trunk8.defaults = {
		fill: '&hellip;',
		lines: 1,
		side: SIDES.right,
		tooltip: true,
		width: WIDTH.auto
	};
})(jQuery);
