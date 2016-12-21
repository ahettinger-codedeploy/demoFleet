/**
 * Parse QueryString
 *
 * Simple function to parse query string
 *
 */
function querySt(ji) {
	hu = window.location.search.substring(1);
	gy = hu.split("&");
	for (i=0;i<gy.length;i++) {
		ft = gy[i].split("=");
		if (ft[0] == ji) {
			return ft[1];
		}
	}
}

/**
 * Parse URL for Subdomain
 *
 * Simple function to parse url from location string
 *
 */
function getSubDomain() {
	var loc = document.domain + "";
	splitValues=loc.split(".")
	if (splitValues.length == 3){
		return splitValues[1] + "." + splitValues[2]
	}else{
		return loc
	}
}

var LAUNCH = 'false';
/**
 * Track changes to launch settigs
 *
 */
function setLaunch(val) {
	LAUNCH = val;
}

/**
 * Determine if this is new session
 *
 * Simple function to current url and referrer
 *
 */
function isNewSession() {
	var new_sess = false;
	if (!$.cookie('voc_session')){
		new_sess = true;
		var date = new Date();		
		var SUBDOMAIN = getSubDomain();
		$.cookie('voc_session',date.getTime(), {domain: SUBDOMAIN} )
	}
	return new_sess;
}

/**
 * Determine if this is a first page viewed in a domain
 *
 * Simple function to current url and referrer
 *
 */
function isFirstPage() {
	curr = document.location.hostname;
	if (document.referrer){
			ref = document.referrer.hostname;
	}else{
		ref = curr;
	}
	// check is this is correct
	return curr == ref;
}

/**
 * 
 */
function setTimehash(){
	window.location.hash =  new Date().getTime();
	setTimeout("setTimehash()", 2000); 	
}

/**
 * increment our page count 
 *
 */
function increment_page_cnt(){
	var cnt = $.cookie('voc-page-cnt');
	if (cnt == null){
		cnt = 0;
	}
	cnt++;
	$.cookie('voc-page-cnt', cnt, { path: '/', domain: getSubDomain() });	
}

/**
 * Determine if survey should launch
 *
 */
function launch_survey(){
	var lnc_cnt = $.cookie('voc-page-cookie');
	var cnt = $.cookie('voc-page-cnt');
	//alert(lnc_cnt==cnt);
	return lnc_cnt==cnt;
}

/**
 * Determine what to request img or js
 *
 */
function generateRequest(){	
	var domain = "voice-of-customers.com";
	//var domain = "knowclick.local";
	var path = escape(document.location);
	var referrer = escape(document.referrer);
	var prot=(("https:" == document.location.protocol) ? "https://" : "http://");
	var first_page = isNewSession();
	var ID_COOKIE_NAME = 'voc-client';
	var SURVEY_COOKIE = 'voc-survey-id';	
	
	increment_page_cnt();
	document.write('<img id="VOC_REQUEST" src="' + prot + domain + '/images/knowclick.gif?session=' + $.cookie('voc_session') + '&client=' + $.cookie(ID_COOKIE_NAME) + '&dt=' + new Date().getTime() + '&referrer=' + referrer + ' "height="1" width="1" border="0" />');	
	
	if (!$.cookie(ID_COOKIE_NAME) || first_page) {
		document.write('<script id="VOC_REQUEST" type="text/javascript" src="' + prot + domain + '/launch_survey/prepare.js?vockey=' + KEY + '&domain=' + path + '&client=' + $.cookie(ID_COOKIE_NAME) + '&firstPage=' + isFirstPage() + '&referrer=' + referrer + '" ></scr'+'ipt>');
	} else if (launch_survey()) {		
		document.write('<script id="VOC_REQUEST" type="text/javascript" src="' + prot + domain + '/launch_survey.js?survey=' + $.cookie(SURVEY_COOKIE) + '&vockey=' + KEY + '&domain=' + path + '&client=' + $.cookie(ID_COOKIE_NAME) + '&firstPage=' + isFirstPage() + '&referrer=' + referrer + '" ></scr'+'ipt>');
	}	
	return "";
}


/** 
 * Cookie plugin
 *
 * Copyright (c) 2006 Klaus Hartl (stilbuero.de)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */

/**
 * Create a cookie with the given name and value and other optional parameters.
 *
 * @example $.cookie('the_cookie', 'the_value');
 * @desc Set the value of a cookie.
 * @example $.cookie('the_cookie', 'the_value', { expires: 7, path: '/', domain: 'jquery.com', secure: true });
 * @desc Create a cookie with all available options.
 * @example $.cookie('the_cookie', 'the_value');
 * @desc Create a session cookie.
 * @example $.cookie('the_cookie', null);
 * @desc Delete a cookie by passing null as value. Keep in mind that you have to use the same path and domain
 *       used when the cookie was set.
 *
 * @param String name The name of the cookie.
 * @param String value The value of the cookie.
 * @param Object options An object literal containing key/value pairs to provide optional cookie attributes.
 * @option Number|Date expires Either an integer specifying the expiration date from now on in days or a Date object.
 *                             If a negative value is specified (e.g. a date in the past), the cookie will be deleted.
 *                             If set to null or omitted, the cookie will be a session cookie and will not be retained
 *                             when the the browser exits.
 * @option String path The value of the path atribute of the cookie (default: path of page that created the cookie).
 * @option String domain The value of the domain attribute of the cookie (default: domain of page that created the cookie).
 * @option Boolean secure If true, the secure attribute of the cookie will be set and the cookie transmission will
 *                        require a secure protocol (like HTTPS).
 * @type undefined
 *
 * @name $.cookie
 * @cat Plugins/Cookie
 * @author Klaus Hartl/klaus.hartl@stilbuero.de
 */

/**
 * Get the value of a cookie with the given name.
 *
 * @example $.cookie('the_cookie');
 * @desc Get the value of a cookie.
 *
 * @param String name The name of the cookie.
 * @return The value of the cookie.
 * @type String
 *
 * @name $.cookie
 * @cat Plugins/Cookie
 * @author Klaus Hartl/klaus.hartl@stilbuero.de
 */
jQuery.cookie = function(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        // CAUTION: Needed to parenthesize options.path and options.domain
        // in the following expressions, otherwise they evaluate to undefined
        // in the packed version for some reason...
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};/*
 * SimpleModal 1.3 - jQuery Plugin
 * http://www.ericmmartin.com/projects/simplemodal/
 * Copyright (c) 2009 Eric Martin
 * Dual licensed under the MIT and GPL licenses
 * Revision: $Id: jquery.simplemodal.js 205 2009-06-12 13:29:21Z emartin24 $
 */

/**
 * SimpleModal is a lightweight jQuery plugin that provides a simple
 * interface to create a modal dialog.
 *
 * The goal of SimpleModal is to provide developers with a cross-browser 
 * overlay and container that will be populated with data provided to
 * SimpleModal.
 *
 * There are two ways to call SimpleModal:
 * 1) As a chained function on a jQuery object, like $('#myDiv').modal();.
 * This call would place the DOM object, #myDiv, inside a modal dialog.
 * Chaining requires a jQuery object. An optional options object can be
 * passed as a parameter.
 *
 * @example $('<div>my data</div>').modal({options});
 * @example $('#myDiv').modal({options});
 * @example jQueryObject.modal({options});
 *
 * 2) As a stand-alone function, like $.modal(data). The data parameter
 * is required and an optional options object can be passed as a second
 * parameter. This method provides more flexibility in the types of data 
 * that are allowed. The data could be a DOM object, a jQuery object, HTML
 * or a string.
 * 
 * @example $.modal('<div>my data</div>', {options});
 * @example $.modal('my data', {options});
 * @example $.modal($('#myDiv'), {options});
 * @example $.modal(jQueryObject, {options});
 * @example $.modal(document.getElementById('myDiv'), {options}); 
 * 
 * A SimpleModal call can contain multiple elements, but only one modal 
 * dialog can be created at a time. Which means that all of the matched
 * elements will be displayed within the modal container.
 * 
 * SimpleModal internally sets the CSS needed to display the modal dialog
 * properly in all browsers, yet provides the developer with the flexibility
 * to easily control the look and feel. The styling for SimpleModal can be 
 * done through external stylesheets, or through SimpleModal, using the
 * overlayCss and/or containerCss options.
 *
 * SimpleModal has been tested in the following browsers:
 * - IE 6, 7, 8
 * - Firefox 2, 3
 * - Opera 9
 * - Safari 3
 * - Chrome 1, 2
 *
 * @name SimpleModal
 * @type jQuery
 * @requires jQuery v1.2.2
 * @cat Plugins/Windows and Overlays
 * @author Eric Martin (http://ericmmartin.com)
 * @version 1.3
 */
;(function ($) {
	var ie6 = $.browser.msie && parseInt($.browser.version) == 6 && typeof window['XMLHttpRequest'] != "object",
		ieQuirks = null,
		w = [];

	/*
	 * Stand-alone function to create a modal dialog.
	 * 
	 * @param {string, object} data A string, jQuery object or DOM object
	 * @param {object} [options] An optional object containing options overrides
	 */
	$.modal = function (data, options) {
		return $.modal.impl.init(data, options);
	};

	/*
	 * Stand-alone close function to close the modal dialog
	 */
	$.modal.close = function () {
		$.modal.impl.close();
	};

	/*
	 * Chained function to create a modal dialog.
	 * 
	 * @param {object} [options] An optional object containing options overrides
	 */
	$.fn.modal = function (options) {
		return $.modal.impl.init(this, options);
	};

	/*
	 * SimpleModal default options
	 * 
	 * appendTo:		(String:'body') The jQuery selector to append the elements to. For ASP.NET, use 'form'.
	 * focus:			(Boolean:true) Forces focus to remain on the modal dialog
	 * opacity:			(Number:50) The opacity value for the overlay div, from 0 - 100
	 * overlayId:		(String:'simplemodal-overlay') The DOM element id for the overlay div
	 * overlayCss:		(Object:{}) The CSS styling for the overlay div
	 * containerId:		(String:'simplemodal-container') The DOM element id for the container div
	 * containerCss:	(Object:{}) The CSS styling for the container div
	 * dataId:			(String:'simplemodal-data') The DOM element id for the data div
	 * dataCss:			(Object:{}) The CSS styling for the data div
	 * minHeight:		(Number:200) The minimum height for the container
	 * minWidth:		(Number:200) The minimum width for the container
	 * maxHeight:		(Number:null) The maximum height for the container. If not specified, the window height is used.
	 * maxWidth:		(Number:null) The maximum width for the container. If not specified, the window width is used.
	 * autoResize:		(Boolean:false) Resize container on window resize? Use with caution - this may have undesirable side-effects.
	 * zIndex:			(Number: 1000) Starting z-index value
	 * close:			(Boolean:true) If true, closeHTML, escClose and overClose will be used if set.
	 							If false, none of them will be used.
	 * closeHTML:		(String:'<a class="modalCloseImg" title="Close"></a>') The HTML for the 
							default close link. SimpleModal will automatically add the closeClass to this element.
	 * closeClass:		(String:'simplemodal-close') The CSS class used to bind to the close event
	 * escClose:		(Boolean:true) Allow Esc keypress to close the dialog? 
	 * overlayClose:	(Boolean:false) Allow click on overlay to close the dialog?
	 * position:		(Array:null) Position of container [top, left]. Can be number of pixels or percentage
	 * persist:			(Boolean:false) Persist the data across modal calls? Only used for existing
								DOM elements. If true, the data will be maintained across modal calls, if false,
								the data will be reverted to its original state.
	 * onOpen:			(Function:null) The callback function used in place of SimpleModal's open
	 * onShow:			(Function:null) The callback function used after the modal dialog has opened
	 * onClose:			(Function:null) The callback function used in place of SimpleModal's close
	 */
	$.modal.defaults = {
		appendTo: 'body',
		focus: true,
		opacity: 50,
		overlayId: 'simplemodal-overlay',
		overlayCss: {},
		containerId: 'simplemodal-container',
		containerCss: {},
		dataId: 'simplemodal-data',
		dataCss: {},
		minHeight: 200,
		minWidth: 300,
		maxHeight: null,
		maxWidth: null,
		autoResize: false,
		zIndex: 1000,
		close: true,
		closeHTML: '<a class="modalCloseImg" title="Close"></a>',
		closeClass: 'simplemodal-close',
		escClose: true,
		overlayClose: false,
		position: null,
		persist: false,
		onOpen: null,
		onShow: null,
		onClose: null
	};

	/*
	 * Main modal object
	 */
	$.modal.impl = {
		/*
		 * Modal dialog options
		 */
		opts: null,
		/*
		 * Contains the modal dialog elements and is the object passed 
		 * back to the callback (onOpen, onShow, onClose) functions
		 */
		dialog: {},
		/*
		 * Initialize the modal dialog
		 */
		init: function (data, options) {
			// don't allow multiple calls
			if (this.dialog.data) {
				return false;
			}

			// $.boxModel is undefined if checked earlier
			ieQuirks = $.browser.msie && !$.boxModel;

			// merge defaults and user options
			this.opts = $.extend({}, $.modal.defaults, options);

			// keep track of z-index
			this.zIndex = this.opts.zIndex;

			// set the onClose callback flag
			this.occb = false;

			// determine how to handle the data based on its type
			if (typeof data == 'object') {
				// convert DOM object to a jQuery object
				data = data instanceof jQuery ? data : $(data);

				// if the object came from the DOM, keep track of its parent
				if (data.parent().parent().size() > 0) {
					this.dialog.parentNode = data.parent();

					// persist changes? if not, make a clone of the element
					if (!this.opts.persist) {
						this.dialog.orig = data.clone(true);
					}
				}
			}
			else if (typeof data == 'string' || typeof data == 'number') {
				// just insert the data as innerHTML
				data = $('<div/>').html(data);
			}
			else {
				// unsupported data type!
				alert('SimpleModal Error: Unsupported data type: ' + typeof data);
				return false;
			}

			// create the modal overlay, container and, if necessary, iframe
			this.create(data);
			data = null;

			// display the modal dialog
			this.open();

			// useful for adding events/manipulating data in the modal dialog
			if ($.isFunction(this.opts.onShow)) {
				this.opts.onShow.apply(this, [this.dialog]);
			}

			// don't break the chain =)
			return this;
		},
		/*
		 * Create and add the modal overlay and container to the page
		 */
		create: function (data) {
			// get the window properties
			w = this.getDimensions();

			// add an iframe to prevent select options from bleeding through
			if (ie6) {
				this.dialog.iframe = $('<iframe src="javascript:false;"/>')
					.css($.extend(this.opts.iframeCss, {
						display: 'none',
						opacity: 0, 
						position: 'fixed',
						height: w[0],
						width: w[1],
						zIndex: this.opts.zIndex,
						top: 0,
						left: 0
					}))
					.appendTo(this.opts.appendTo);
			}

			// create the overlay
			this.dialog.overlay = $('<div/>')
				.attr('id', this.opts.overlayId)
				.addClass('simplemodal-overlay')
				.css($.extend(this.opts.overlayCss, {
					display: 'none',
					opacity: this.opts.opacity / 100,
					height: w[0],
					width: w[1],
					position: 'fixed',
					left: 0,
					top: 0,
					zIndex: this.opts.zIndex + 1
				}))
				.appendTo(this.opts.appendTo);
		
			// create the container
			this.dialog.container = $('<div/>')
				.attr('id', this.opts.containerId)
				.addClass('simplemodal-container')
				.css($.extend(this.opts.containerCss, {
					display: 'none',
					position: 'fixed', 
					zIndex: this.opts.zIndex + 2
				}))
				.append(this.opts.close && this.opts.closeHTML
					? $(this.opts.closeHTML).addClass(this.opts.closeClass)
					: '')
				.appendTo(this.opts.appendTo);
				
			this.dialog.wrap = $('<div/>')
				.attr('tabIndex', -1)
				.addClass('simplemodal-wrap')
				.css({height: '100%', outline: 0, width: '100%'})
				.appendTo(this.dialog.container);
				
			// add styling and attributes to the data
			this.dialog.data = data
				.attr('id', data.attr('id') || this.opts.dataId)
				.addClass('simplemodal-data')
				.css($.extend(this.opts.dataCss, {
						display: 'none'
				}));
			data = null;

			this.setContainerDimensions();
			this.dialog.data.appendTo(this.dialog.wrap);

			// fix issues with IE
			if (ie6 || ieQuirks) {
				this.fixIE();
			}
		},
		/*
		 * Bind events
		 */
		bindEvents: function () {
			var self = this;

			// bind the close event to any element with the closeClass class
			$('.' + self.opts.closeClass).bind('click.simplemodal', function (e) {
				e.preventDefault();
				self.close();
			});
			
			// bind the overlay click to the close function, if enabled
			if (self.opts.close && self.opts.overlayClose) {
				self.dialog.overlay.bind('click.simplemodal', function (e) {
					e.preventDefault();
					self.close();
				});
			}
	
			// bind keydown events
			$(document).bind('keydown.simplemodal', function (e) {
				if (self.opts.focus && e.keyCode == 9) { // TAB
					self.watchTab(e);
				}
				else if ((self.opts.close && self.opts.escClose) && e.keyCode == 27) { // ESC
					e.preventDefault();
					self.close();
				}
			});

			// update window size
			$(window).bind('resize.simplemodal', function () {
				// redetermine the window width/height
				w = self.getDimensions();

				// reposition the dialog
				self.opts.autoResize ? self.setContainerDimensions() : self.setPosition();
	
				if (ie6 || ieQuirks) {
					self.fixIE();
				}
				else {
					// update the iframe & overlay
					self.dialog.iframe && self.dialog.iframe.css({height: w[0], width: w[1]});
					self.dialog.overlay.css({height: w[0], width: w[1]});
				}
			});
		},
		/*
		 * Unbind events
		 */
		unbindEvents: function () {
			$('.' + this.opts.closeClass).unbind('click.simplemodal');
			$(document).unbind('keydown.simplemodal');
			$(window).unbind('resize.simplemodal');
			this.dialog.overlay.unbind('click.simplemodal');
		},
		/*
		 * Fix issues in IE6 and IE7 in quirks mode
		 */
		fixIE: function () {
			var p = this.opts.position;

			// simulate fixed position - adapted from BlockUI
			$.each([this.dialog.iframe || null, this.dialog.overlay, this.dialog.container], function (i, el) {
				if (el) {
					var bch = 'document.body.clientHeight', bcw = 'document.body.clientWidth',
						bsh = 'document.body.scrollHeight', bsl = 'document.body.scrollLeft',
						bst = 'document.body.scrollTop', bsw = 'document.body.scrollWidth',
						ch = 'document.documentElement.clientHeight', cw = 'document.documentElement.clientWidth',
						sl = 'document.documentElement.scrollLeft', st = 'document.documentElement.scrollTop',
						s = el[0].style;

					s.position = 'absolute';
					if (i < 2) {
						s.removeExpression('height');
						s.removeExpression('width');
						s.setExpression('height','' + bsh + ' > ' + bch + ' ? ' + bsh + ' : ' + bch + ' + "px"');
						s.setExpression('width','' + bsw + ' > ' + bcw + ' ? ' + bsw + ' : ' + bcw + ' + "px"');
					}
					else {
						var te, le;
						if (p && p.constructor == Array) {
							var top = p[0] 
								? typeof p[0] == 'number' ? p[0].toString() : p[0].replace(/px/, '')
								: el.css('top').replace(/px/, '');
							te = top.indexOf('%') == -1 
								? top + ' + (t = ' + st + ' ? ' + st + ' : ' + bst + ') + "px"'
								: parseInt(top.replace(/%/, '')) + ' * ((' + ch + ' || ' + bch + ') / 100) + (t = ' + st + ' ? ' + st + ' : ' + bst + ') + "px"';

							if (p[1]) {
								var left = typeof p[1] == 'number' ? p[1].toString() : p[1].replace(/px/, '');
								le = left.indexOf('%') == -1 
									? left + ' + (t = ' + sl + ' ? ' + sl + ' : ' + bsl + ') + "px"'
									: parseInt(left.replace(/%/, '')) + ' * ((' + cw + ' || ' + bcw + ') / 100) + (t = ' + sl + ' ? ' + sl + ' : ' + bsl + ') + "px"';
							}
						}
						else {
							te = '(' + ch + ' || ' + bch + ') / 2 - (this.offsetHeight / 2) + (t = ' + st + ' ? ' + st + ' : ' + bst + ') + "px"';
							le = '(' + cw + ' || ' + bcw + ') / 2 - (this.offsetWidth / 2) + (t = ' + sl + ' ? ' + sl + ' : ' + bsl + ') + "px"';
						}
						s.removeExpression('top');
						s.removeExpression('left');
						s.setExpression('top', te);
						s.setExpression('left', le);
					}
				}
			});
		},
		focus: function (pos) {
			var self = this,
				p = pos || 'first';

			// focus on dialog or the first visible/enabled input element
			var input = $(':input:enabled:visible:' + p, self.dialog.wrap);
			input.length > 0 ? input.focus() : self.dialog.wrap.focus();
		},
		getDimensions: function () {
			var el = $(window);

			// fix a jQuery/Opera bug with determining the window height
			var h = $.browser.opera && $.browser.version > '9.5' && $.fn.jquery <= '1.2.6' ? document.documentElement['clientHeight'] :
				$.browser.opera && $.browser.version < '9.5' && $.fn.jquery > '1.2.6' ? window.innerHeight :
				el.height();

			return [h, el.width()];
		},
		getVal: function (v) {
			return v == 'auto' ? 0 : parseInt(v.replace(/px/, ''));
		},
		setContainerDimensions: function () {
			// get the dimensions for the container and data
			var ch = this.getVal(this.dialog.container.css('height')), cw = this.dialog.container.width(),
				dh = this.dialog.data.height(), dw = this.dialog.data.width();
			
			var mh = this.opts.maxHeight && this.opts.maxHeight < w[0] ? this.opts.maxHeight : w[0],
				mw = this.opts.maxWidth && this.opts.maxWidth < w[1] ? this.opts.maxWidth : w[1];

			// height
			if (!ch) {
				if (!dh) {ch = this.opts.minHeight;}
				else {
					if (dh > mh) {ch = mh;}
					else if (dh < this.opts.minHeight) {ch = this.opts.minHeight;}
					else {ch = dh;}
				}
			}
			else {
				ch = ch > mh ? mh : ch;
			}

			// width
			if (!cw) {
				if (!dw) {cw = this.opts.minWidth;}
				else {
					if (dw > mw) {cw = mw;}
					else if (dw < this.opts.minWidth) {cw = this.opts.minWidth;}
					else {cw = dw;}
				}
			}
			else {
				cw = cw > mw ? mw : cw;
			}

			this.dialog.container.css({height: ch, width: cw});
			if (dh > ch || dw > cw) {
				this.dialog.wrap.css({overflow:'auto'});
			}
			this.setPosition();
		},
		setPosition: function () {
			var top, left,
				hc = (w[0]/2) - ((this.dialog.container.height() || this.dialog.data.height())/2),
				vc = (w[1]/2) - ((this.dialog.container.width() || this.dialog.data.width())/2);

			if (this.opts.position && this.opts.position.constructor == Array) {
				top = this.opts.position[0] || hc;
				left = this.opts.position[1] || vc;
			} else {
				top = hc;
				left = vc;
			}
			this.dialog.container.css({left: left, top: top});
		},
		watchTab: function (e) {
			var self = this;
			if ($(e.target).parents('.simplemodal-container').length > 0) {
				// save the list of inputs
				self.inputs = $(':input:enabled:visible:first, :input:enabled:visible:last', self.dialog.data);

				// if it's the first or last tabbable element, refocus
				if (!e.shiftKey && e.target == self.inputs[self.inputs.length -1] ||
						e.shiftKey && e.target == self.inputs[0] ||
						self.inputs.length == 0) {
					e.preventDefault();
					var pos = e.shiftKey ? 'last' : 'first';
					setTimeout(function () {self.focus(pos);}, 10);
				}
			}
			else {
				// might be necessary when custom onShow callback is used
				e.preventDefault();
				setTimeout(function () {self.focus();}, 10);
			}
		},
		/*
		 * Open the modal dialog elements
		 * - Note: If you use the onOpen callback, you must "show" the 
		 *	        overlay and container elements manually 
		 *         (the iframe will be handled by SimpleModal)
		 */
		open: function () {
			// display the iframe
			this.dialog.iframe && this.dialog.iframe.show();

			if ($.isFunction(this.opts.onOpen)) {
				// execute the onOpen callback 
				this.opts.onOpen.apply(this, [this.dialog]);
			}
			else {
				// display the remaining elements
				this.dialog.overlay.show();
				this.dialog.container.show();
				this.dialog.data.show();
			}
			
			this.focus();

			// bind default events
			this.bindEvents();
		},
		/*
		 * Close the modal dialog
		 * - Note: If you use an onClose callback, you must remove the 
		 *         overlay, container and iframe elements manually
		 *
		 * @param {boolean} external Indicates whether the call to this
		 *     function was internal or external. If it was external, the
		 *     onClose callback will be ignored
		 */
		close: function () {
			// prevent close when dialog does not exist
			if (!this.dialog.data) {
				return false;
			}

			// remove the default events
			this.unbindEvents();

			if ($.isFunction(this.opts.onClose) && !this.occb) {
				// set the onClose callback flag
				this.occb = true;

				// execute the onClose callback
				this.opts.onClose.apply(this, [this.dialog]);
			}
			else {
				// if the data came from the DOM, put it back
				if (this.dialog.parentNode) {
					// save changes to the data?
					if (this.opts.persist) {
						// insert the (possibly) modified data back into the DOM
						this.dialog.data.hide().appendTo(this.dialog.parentNode);
					}
					else {
						// remove the current and insert the original, 
						// unmodified data back into the DOM
						this.dialog.data.hide().remove();
						this.dialog.orig.appendTo(this.dialog.parentNode);
					}
				}
				else {
					// otherwise, remove it
					this.dialog.data.hide().remove();
				}

				// remove the remaining elements
				this.dialog.container.hide().remove();
				this.dialog.overlay.hide().remove();
				this.dialog.iframe && this.dialog.iframe.hide().remove();

				// reset the dialog object
				this.dialog = {};
			}
		}
	};
})(jQuery);
var contact = {
	message: null,
	open: function (dialog) {
		// add padding to the buttons in firefox/mozilla
		if ($.browser.mozilla) {
			$('#voc-container .voc-button').css({
				'padding-bottom': '2px'
			});
		}
		// input field font size
		if ($.browser.safari) {
			$('#voc-container .voc-input').css({
				'font-size': '.9em'
			});
		}

		// dynamically determine height
		// make this use question optons
		var h = 300;
		if ($('#voc-subject').length) {
			h += 26;
		}
		if ($('#voc-cc').length) {
			h += 22;
		}

		var title = $('#voc-container .voc-title').html();
		$('#voc-container .voc-title').html('Loading...');
		dialog.overlay.fadeIn(200, function () {
			dialog.container.fadeIn(200, function () {
				dialog.data.fadeIn(200, function () {
					$('#voc-container .voc-content').animate({
						height: h
					}, function () {
						$('#voc-container .voc-title').html(title);
						$('#voc-container form').fadeIn(200, function () {
							$('#voc-container #voc-name').focus();

							$('#voc-container .voc-cc').click(function () {
								var cc = $('#voc-container #voc-cc');
								cc.is(':checked') ? cc.attr('checked', '') : cc.attr('checked', 'checked');
							});

							// fix png's for IE 6
							if ($.browser.msie && $.browser.version < 7) {
								$('#voc-container .voc-button').each(function () {
									if ($(this).css('backgroundImage').match(/^url[("']+(.*\.png)[)"']+$/i)) {
										var src = RegExp.$1;
										$(this).css({
											backgroundImage: 'none',
											filter: 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src="' +  src + '", sizingMethod="crop")'
										});
									}
								});
							}
						});
					});
				});
			});
		});
	},
	show: function (dialog) {
		$('#voc-container .voc-continue').click(function (e) {
			e.preventDefault();
			// validate form
			if (contact.validate()) {
				
				var msg = $('#voc-container .voc-message');
				msg.fadeOut(function () {
					msg.removeClass('voc-error').empty();
				});
				$('#voc-container .voc-title').html('Launching Survey...');
				$('#voc-container form').fadeOut(200);
				$('#voc-container .voc-content').animate({
					height: '80px'
				}, function () {
					$('#voc-container .voc-loading').fadeIn(200, function () {
							// check if no pop-up, and prompt with warning to allow from this site
							if (vocWin && vocWin.top) {
								// popup has opened
								$('#voc-container .voc-title').html('Thank you!');
								$.modal.close();
							} else {
								$('#voc-container .voc-title').html('Please enable pop-ups, and try again.');
								contact.close_error();
							}
                   	});
				});
			}
			else {
				if ($('#voc-container .voc-message:visible').length > 0) {
					var msg = $('#voc-container .voc-message div');
					msg.fadeOut(200, function () {
						msg.empty();
						contact.showError();
						msg.fadeIn(200);
					});
				}
				else {
					$('#voc-container .voc-message').animate({
						height: '30px'
					}, contact.showError);
				}
				
			}
		});
	},
	close_error: function (dialog) {
		$('#voc-container .voc-message').fadeOut();
		$('#voc-container form').fadeOut(200);
		$('#voc-container .voc-content').animate({
			height: 40
		}, function () {
			dialog.data.fadeOut(200, function () {
				dialog.container.fadeOut(200, function () {
					dialog.overlay.fadeOut(200, function () {
						$.modal.close();
					});
				});
			});
		});
	},
	close: function (dialog) {
		$('#voc-container .voc-message').fadeOut();
		$('#voc-container .voc-title').html('Thanks, maybe next time...');
		$('#voc-container form').fadeOut(200);
		$('#voc-container .voc-content').animate({
			height: 40
		}, function () {
			dialog.data.fadeOut(200, function () {
				dialog.container.fadeOut(200, function () {
					dialog.overlay.fadeOut(200, function () {
						$.modal.close();
					});
				});
			});
		});
	},
	error: function (xhr) {
		alert(xhr.statusText);
	},
	validate: function () {
		contact.message = '';
		// Do a check to see if the answered the one question
		//if (!$('#contact-container #contact-name').val()) {
		//	contact.message += 'Name is required. ';
		//}

		
		if (contact.message.length > 0) {
			return false;
		}
		else {
			return true;
		}
	},
	validateEmail: function (email) {
		var at = email.lastIndexOf("@");

		// Make sure the at (@) sybmol exists and  
		// it is not the first or last character
		if (at < 1 || (at + 1) === email.length)
			return false;

		// Make sure there aren't multiple periods together
		if (/(\.{2,})/.test(email))
			return false;

		// Break up the local and domain portions
		var local = email.substring(0, at);
		var domain = email.substring(at + 1);

		// Check lengths
		if (local.length < 1 || local.length > 64 || domain.length < 4 || domain.length > 255)
			return false;

		// Make sure local and domain don't start with or end with a period
		if (/(^\.|\.$)/.test(local) || /(^\.|\.$)/.test(domain))
			return false;

		// Check for quoted-string addresses
		// Since almost anything is allowed in a quoted-string address,
		// we're just going to let them go through
		if (!/^"(.+)"$/.test(local)) {
			// It's a dot-string address...check for valid characters
			if (!/^[-a-zA-Z0-9!#$%*\/?|^{}`~&'+=_\.]*$/.test(local))
				return false;
		}

		// Make sure domain contains only valid characters and at least one period
		if (!/^[-a-zA-Z0-9\.]*$/.test(domain) || domain.indexOf(".") === -1)
			return false;	

		return true;
	},
	showError: function () {
		$('#contact-container .contact-message')
			.html($('<div class="contact-error"></div>').append(contact.message))
			.fadeIn(200);
	}
};
