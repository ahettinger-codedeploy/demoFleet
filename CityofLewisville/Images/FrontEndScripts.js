// FAQ Single List begins... //
var popupMOM;
function showPopup(e, elemID, txtWhen, txtWhere) 
{
	if (txtWhen=='') 
		txtWhen = 'All Day';
	popupMOM = document.createElement('div');
	popupMOM.className = 'tooltip';
	//popupMOM.style.cssText = 'position: absolute; border: 2px groove #b3b3b3; left: 0px; top: 0px; padding: 2px;';
	if ( txtWhen.length > 0 )
		popupMOM.innerHTML = '<span class="when">When: </span>' + txtWhen + '<br />';
		
	if ( txtWhere.length > 0 )
		popupMOM.innerHTML += '<span class="where">Where: </span>' + txtWhere;
		
	document.body.appendChild(popupMOM);
	positionPopup(e, elemID);
}	

function positionPopup(e, elemID) 
{
	var docb = document.body;
	if (popupMOM == null) return;

	var newLeft = ((e.clientX + docb.scrollLeft) + 4);
	var newTop = ((e.clientY + docb.scrollTop) + 4);
	
	if (newLeft + popupMOM.offsetWidth > (docb.clientWidth+docb.scrollLeft)) 
	{
		var newerLeft = ((e.clientX + docb.scrollLeft) - 4) - popupMOM.offsetWidth;
		if (newerLeft > 0) newLeft = newerLeft;
	}
	
	if (newTop + popupMOM.offsetHeight > (docb.clientHeight + docb.scrollTop)) 
	{
		var newerTop = ((e.clientY + docb.scrollTop) - 4) - popupMOM.offsetHeight;
		if (newerTop > 0) newTop = newerTop;
	}
	
	var popStyle = popupMOM.style;
	popStyle.left = newLeft + 'px';
	popStyle.top = newTop + 'px';
}	

function hidePopup() 
{
	if (popupMOM == null) return;
	document.body.removeChild(popupMOM);
	popupMOM = null;
}

function ToggleElement(elementId)
{
	element = document.getElementById(elementId);
	if ( element != null )
		element.style.display = (element.style.display == "none" ? "block" : "none");
}

// ...Ends FAQ Single List //

(function ($) {
	$.queryString = (function (a) {
		if (a == "") return {};
		var b = {};
		for (var i = 0; i < a.length; ++i) {
			var p = a[i].split('=');
			if (p.length != 2) continue;
			b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
		}
		return b;
	})(window.location.search.substr(1).split('&'))
})(jQuery);

function redirectToUrl(url, target, id) {
	var objWin = window;
	if (target == "_blank") {
		objWin = window.open(url, id);
		return;
	}
	else if (target == "_parent") {
		if (window.parent != null) {
			objWin = window.parent;
		}
	}
	else if (target == "_top") {
		if (window.top != null) {
			objWin = window.top;
		}
	}
	if (objWin != null) {
		objWin.location = url;
		objWin.focus();
	}
}

$(document).ready(function ()
{

	/* Search */
	$(".defaultText").focus(function (srcc)
	{
		if ($(this).val() == $(this)[0].title)
		{
			$(this).removeClass("defaultTextActive");
			$(this).val("");
		}
	});
	$(".defaultText").blur(function ()
	{
		if ($(this).val() == "")
		{
			$(this).addClass("defaultTextActive");
			$(this).val($(this)[0].title);
		}
	});
	$(".defaultText").blur();

	$('input#q').live("keydown", function (e)
	{
		/* ENTER PRESSED*/
		if (e.which == 13)
		{
			window.location = $(".searchbox_anchor").attr("href");
			return false;
		}
	});

	$("input#q").live("keyup", function (e)
	{
		var qev = $(this).val();
		var qe = encodeURIComponent(qev);

		$(".searchbox_anchor.google").attr("href", "gcsearch.aspx?q=" + encodeURIComponent(qe) + "&chp=" + $("input#hdnCustonHomePage").val());
		$(".searchbox_anchor.isys").attr("href", "search.aspx?request=" + encodeURIComponent(qe) + "&maxFiles=" + $("input#hdnMaxFiles").val());
		$(".searchbox_anchor.searchblox").attr("href", "sbsearch.aspx?query=" + encodeURIComponent(qe) + "&pagesize=" + $("input#hdnMaxFiles").val());
	});

	if ($(".searchbox_anchor.google").length > 0)
		$("input#q").val($.queryString["q"] != null ? decodeURIComponent($.queryString["q"]) : $("input#q").attr("title"));
	else if ($(".searchbox_anchor.searchblox").length > 0)
		$("input#q").val($.queryString["query"] != null ? decodeURIComponent($.queryString["query"]) : $("input#q").attr("title"));

	$('#alert_controls').click(function ()
	{
		var alertClass = $(this).attr("class");
		if (alertClass == "hide")
		{
			$(document).find(".important_alert_wrapper").slideUp("150");
			$(this).attr("class", "show");
			$.cookie('IMPTNOTICE', "HIDE", { expires: 1 });
		}
		else
		{
			$(document).find(".important_alert_wrapper").slideDown("150");
			$(this).attr("class", "hide");
			$.cookie('IMPTNOTICE', "SHOW", { expires: 1 });
		}
	});

	var imptNotice = $.cookie('IMPTNOTICE');
	if (!imptNotice)
	{
		$(".important_alert_wrapper").slideDown("150");
		$("#alert_controls").attr("class", "hide");

		$.cookie('IMPTNOTICE', "SHOW", { expires: 1 });
	}
	else
	{
		// check whether important notice was shown or hidden before
		if (imptNotice == "HIDE")
		{
			$(".important_alert_wrapper").slideUp("150");
			$("#alert_controls").attr("class", "show");
		}
		else
		{
			setTimeout(function ()
			{
				$(".important_alert_wrapper").slideDown("150");
				$("#alert_controls").attr("class", "hide");
			}, 500);
		}
	}
});

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
jQuery.cookie = function (name, value, options) {
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
};