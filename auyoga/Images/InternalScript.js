﻿/*  CHANGE LOG
    'JAI 10/23/15 - Moved some Script to external file
*/


/*

 * bring browser up to speed somewhat

 * NOTE: THESE PROTOTYPE METHODS ARE DUPLICATED IN util.js AND nondashboard-utils.js

 * 		KEEP THEM IDENTICAL

 */

if(!String.prototype.trim)

{

    String.prototype.trim = function()

    {

        var start = -1;

        var end = this.length;

        while(this.charCodeAt(--end) < 33);

        while(this.charCodeAt(++start) < 33);

        return this.slice(start, end + 1);

    };

}

if(!String.prototype.toBoolean)

{

    String.prototype.toBoolean = function()

    {

        switch(this.valueOf())

        {

            case "1":

                return true;

                break;

            case "0": case "": case "no": case "false":

            case "No": case "False": case "NO": case "FALSE":

                return false;

                break;

            default:

                return true;

        }

    };

}

if(!Array.prototype.indexOf)

{

    Array.prototype.indexOf = function(value, fromIndex)

    {

        var len = this.length;

        if(fromIndex == null)

            fromIndex = 0;

        else if(fromIndex < 0)

            fromIndex = Math.max(0, len + fromIndex);

        for(var i = fromIndex; i < len; i++)

        {

            if(this[i] === value)

                return i;

        }

        return -1;

    };

}

var EventCache=function() 

{

    var listEvents=[];

    return{

        listEvents: listEvents,

        add: function(node,sEventName,fHandler,bCapture)

        {

            listEvents.push(arguments);

        },

		

        flush: function()

        {

            var i, item;

            for(i=listEvents.length-1;i>=0;i=i-1) 

            {	

                item=listEvents[i];

                if(!item) 

                    continue;

                if(item[0].removeEventListener) 

                    item[0].removeEventListener(item[1],item[2],item[3]);

                var logical_type='';

                if(item[1].substring(0,2)!="on") 

                {

                    logical_type=item[1];

                    item[1]="on"+item[1];

                }

                else 

                    logical_type=item[1].substring(2,event_name_without_on.length);

                if(typeof item[0].__eventHandlers!='undefined'&&typeof item[0].__eventHandlers[logical_type]!='undefined') 

                    item[0].__eventHandlers[logical_type]=null;

                if(item[0].detachEvent) 

                    item[0].detachEvent(item[1],item[2]);

                item[0][item[1]]=null;

            };

            listEvents=null;

        }

    }

}();



function flashMsg(msg, width)

{

    var FLASH_MSG_ID = 'cs_flashMsg'; // id of html object that shows the msg

    if(!width)

        var width = 200;

    var div = document.createElement('div');

    div.id = FLASH_MSG_ID;

    div.style.width = width + 'px';

    div.style.marginLeft = (-width / 2) + 'px'; // minus half the width, to center on pg

    div.className = 'cs_flashMsg';

    div.innerHTML = msg;

    div.onclick = close; // let user close it; probably not needed, but safe

    document.body.appendChild(div);

    setTimeout(close, 2000); // kill msg after a while in case page isn't going to reload

	

    function close()

    {

        var div = document.getElementById(FLASH_MSG_ID);

        if(div)

            div.parentNode.removeChild(div);

    }

}



/* start functions used by lightbox */

function OnMouseDown(e)

{

    // IE is retarded and doesn't pass the event object

    if (e == null) 

        e = window.event; 

    if(typeof e.stopPropagation!='undefined')

        e.stopPropagation();

    else

        e.cancelBubble=true;		

    // IE uses srcElement, others use target

    var target = e.target != null ? e.target : e.srcElement;

    if (_debug)

        _debug.innerHTML = target.className == 'drag' 

		? 'draggable element clicked' 

		: 'NON-draggable element clicked';

    target = getDraggableTarget(target);

    // for IE, left click == 1

    // for Firefox, left click == 0

    if ((e.button == 1 && window.event != null || 

		e.button == 0) && target)

    {

        // grab the mouse position

        _startX = e.clientX;

        _startY = e.clientY;

		

        // grab the clicked element's position

        _offsetX = ExtractNumber(target.style.left);

        _offsetY = ExtractNumber(target.style.top);

		

        // bring the clicked element to the front while it is being dragged

        _oldZIndex = target.style.zIndex;

        target.style.zIndex = 10000;

		

        // we need to access the element in OnMouseMove

        _dragElement = target;



        // tell our code to start moving the element with the mouse

        document.onmousemove = OnMouseMove;

		

        // cancel out any text selections

        document.body.focus();

		

        // prevent text selection in IE

        document.onselectstart = function () { return false; };

        // prevent IE from trying to drag an image

        target.ondragstart = function() { return false; };

		

        // prevent text selection (except IE)

        return false;

    }

}



function OnMouseUp(e)

{

    if (_dragElement != null)

    {

        _dragElement.style.zIndex = _oldZIndex;



        // we're done with these events until the next OnMouseDown

        document.onmousemove = null;

        document.onselectstart = null;

        _dragElement.ondragstart = null;



        // this is how we know we're not dragging

        _dragElement = null;

        if (_debug)

            _debug.innerHTML = 'mouse up';

    }

}



function OnMouseMove(e)

{

    if (e == null) 

        var e = window.event; 

    if(typeof e.stopPropagation!='undefined')

        e.stopPropagation();

    else

        e.cancelBubble=true;				



    // this is the actual "drag code"

    _dragElement.style.left = (_offsetX + e.clientX - _startX) + 'px';

    _dragElement.style.top = (_offsetY + e.clientY - _startY) + 'px';

    if (_debug)

        _debug.innerHTML = '(' + _dragElement.style.left + ', ' + _dragElement.style.top + ')';	

}



function ExtractNumber(value)

{

    var n = parseInt(value);

	

    return n == null || isNaN(n) ? 0 : n;

}



function getDraggableTarget(obj)

{

    if (obj.className.indexOf('drag') >= 0)

        return obj;

    if (obj.offsetParent)

    {	

        while(obj=obj.offsetParent)

        {

            if (obj.className.indexOf('drag') >= 0)

                return obj;			

        }

    }

    return null;

}

/* END functions used by lightbox */



// this function is duplicated in browser-all.js and util.js; if you change one, change the other!

function BrowserCheck() {

    var b = navigator.appName.toString();

    var b_ver;

    var up = navigator.platform.toString();

    var ua = navigator.userAgent.toString().toLowerCase();

    var re_opera = /Opera.([0-9\.]*)/i;

    var re_msie = /MSIE.([0-9\.]*)/i;

    var re_gecko = /gecko/i;

    // mozilla/5.0 (macintosh; u; intel mac os x 10_6_7; en-us) applewebkit/533.20.25 (khtml, like gecko) version/5.0.4 safari/533.20.27

    var re_safari = /safari\/([\d\.]*)/i;

    var re_mozilla = /firefox\/([\d\.]*)/i;

    var re_chrome = /chrome\/([\d\.]*)/i;

    var ie_documentMode = 0;

    var browserType = {};

    browserType.mozilla = browserType.ie = browserType.opera = r = false;

    browserType.version = (ua.match(/.+(?:rv|it|ra|ie|me)[\/: ]([\d.]+)/) || [])[1];

    browserType.chrome = /chrome/.test(ua);

    browserType.safari = /webkit/.test(ua) && !/chrome/.test(ua);

    browserType.opera = /opera/.test(ua);

    browserType.ie = /msie/.test(ua) && !/opera/.test(ua);

    browserType.mozilla = /mozilla/.test(ua) && !/(compatible|webkit)/.test(ua);

	

    if (ua.match(re_opera))

    {

        r = ua.match(re_opera);

        browserType.version = parseFloat(r[1]);

    }

    else if (ua.match(re_msie))

    {

        r = ua.match(re_msie);

        browserType.version = parseFloat(r[1]);

        ie_documentMode = browserType.version;

        if (browserType.version <= 7)

        {

            re_ver = /trident\/([\d\.]*)/i;

            r = ua.match(re_ver);

            // in IE compat mode, trident=4.0 (IE8), =5.0 (IE9), =6.0 (IE10) etc, i.e, version=trident+4.

            if (r && parseFloat(r[1]) >= 4)

            {

                browserType.version = parseFloat(r[1]) + 4;

                ie_documentMode = document.documentMode;

            }

        }

    }

    else if (browserType.safari && !browserType.chrome)

    {

        re_ver = /version\/([\d\.]*)/i;

        if (ua.match(re_ver))

        {

            r = ua.match(re_ver);

            browserType.version = parseFloat(r[1]);

        }

    }

    else if (browserType.chrome)

    {

        b_ver = ua.match(re_chrome);

        r = b_ver[1].split('.');

        browserType.version = parseFloat(r[0]);

    }

    else if (ua.match(re_gecko))

    {

        var re_gecko_version = /rv:\s*([0-9\.]+)/i;

        r = ua.match(re_gecko_version);

        browserType.version = parseFloat(r[1]);

        if (ua.match(re_mozilla))

        {

            r = ua.match(re_mozilla);

            browserType.version = parseFloat(r[1]);

        }

    }

    else if (ua.match(re_mozilla))

    {

        r = ua.match(re_mozilla);

        browserType.version = parseFloat(r[1]);

    }

    browserType.windows = browserType.mac = browserType.linux = false;

    browserType.Platform = ua.match(/windows/i) ? "windows" : (ua.match(/linux/i) ? "linux" : (ua.match(/mac/i) ? "mac" : ua.match(/unix/i) ? "unix" : "unknown"));

    this[browserType.Platform] = true;

    browserType.v = browserType.version;

    browserType.valid = browserType.ie && browserType.v >= 6 || browserType.mozilla && browserType.v >= 1.4 || browserType.safari && browserType.v >= 5 || browserType.chrome && browserType.v >= 12;

    browserType.okToAuthor = (browserType.ie && browserType.v >= 8 && ie_documentMode >= 7) || (browserType.mozilla && browserType.v >= 3.6);

    return browserType;

};



// make sure we have our namespace

// must be called AFTER code to relocate if not in dashboard, if that's used

var commonspot = window.commonspot || parent.commonspot || {};



/**

 * commonspot.util: utility package

 */

if(!commonspot.util)

{

    commonspot.util = {};

	

    commonspot.util.checkDashboard = function()

    {

        return (typeof(commonspot.lview) != 'undefined');

    }

	

    /**

	 * Encode string properly for html charactor

	 * @return string

	 */

    commonspot.util.encodeString = function(str)

    {	

        var regExp = /&amp;#39;|&amp;amp;|&amp;nbsp;|&lt;br \/&gt;&lt;br \/&gt;/;

		  	

        if (str && str.search(regExp) != -1)		

        { 

            str = str.replace(/&amp;amp;/, '&amp;');

            str = str.replace(/&amp;#39;/, '&#39;');  

            str = str.replace(/&amp;nbsp;/, '&nbsp;'); 

            str = str.replace(/&lt;br \/&gt;&lt;br \/&gt;/, ' '); 		

        }  	

			 

        return str;

    };

		

    /**

	 * Escape special XML characters with the equivalent entities

	 * @return string

	 */

    commonspot.util.encodeXmlEntities = function(str)

    {

        if(str && str.search(/[&<>"]/) != -1)

        {

            str = str.replace(/&/g, '&amp;');

            str = str.replace(/</g, '&lt;');

            str = str.replace(/>/g, '&gt;');

            str = str.replace(/"/g, '&quot;');

        }

        // dmerrill 3/12/09: don't know why we do this, not xml spec

        return encodeURIComponent(str);

    };

		

    /**

	 * format a std commonspot date (yyyy-mm-dd hh:mm:ss) for display as a date only

	 * default format is yyyy-mm-dd

	 * if USFormat is true, returns it as mm/dd/yyyy

	 */

    commonspot.util.formatCSDate = function(csDateStr, USFormat)

    {

        if(!csDateStr)

            return;

        if(USFormat)

        {

            var aDateParts = csDateStr.split(/[- :]/);

            if(aDateParts.length < 3)

                throw("[formatCSDate(USFormat)] invalid date: " + csDateStr);

            return aDateParts[1] + "/" + aDateParts[2] + "/" + aDateParts[0];

        }

        return csDateStr.substr(0, 10);

    };

	

    /**

	 * for ea passed field in passed object, creates a new field w orig fld value converted to std date format

	 * @param row (object): object to process

	 * 		it's assumed to contain each of the fields in dateFieldsList, ea w date data

	 * @param dateFieldsList (string): comma-delimited list of fields to process

	 * @param fieldNameSuffix (string): appended to end of processed fld name to create name of formated fld

	 * 	if not passed, '_display' is used

	 * 	to overwrite orig fld w formatted version, pass ''

	 */

    commonspot.util.formatCSDateFields = function(obj, dateFieldsList, fieldNameSuffix)

    {

        if(!fieldNameSuffix)

            fieldNameSuffix = '_display';

        var aDateFlds = dateFieldsList.split(',');

        for(var i = 0; i < aDateFlds.length; i++)

            obj[aDateFlds[i] + fieldNameSuffix] = commonspot.util.formatCSDate(obj[aDateFlds[i]]);

    };

	

	

    /*

	 * @return object: returns an object with values from url hash, interpreted as query string format

	 */

    commonspot.util.getHashArgs = function()

    {

        var argStr = document.location.hash.replace(/^#+/, ''); // strip all leading #

        if (!argStr.toQueryParams)

            return null;

        var args = argStr.toQueryParams();

        args.qstring = window.location.search;

        if (args.mode)

            args.mode = args.mode.toLowerCase();

        return args;

    };

	

    commonspot.util.getObjFieldLCase = function(obj, name)

    {

        if (name)

            return obj[name.toLowerCase()];

        else

            return null;

    };



    // return true if any item in permissionNeededList is in permissionList

    commonspot.util.hasAnyPermission = function(permissionNeededList, permissionList)

    {

        if( (!permissionNeededList) || (!permissionList) )

            return false;			

			

        aPermsNeeded = permissionNeededList.toLowerCase().split(',');

        aPermsYouHave = permissionList.toLowerCase().split(',');

		

        for(var i = 0; i < aPermsNeeded.length; i++)

        {

            if(aPermsYouHave.indexOf(aPermsNeeded[i]) != -1) 

                return true;

        }

        return false;

    };

		

	

    /*

	 * returns true if passed array or object has members

	 */

    commonspot.util.hasMembers = function(obj)

    {

        for(var f in obj)

        {

            try

            {

                if(obj.hasOwnProperty(f))

                    return true;

            }

            catch(e)

            {

                return false;	

            }

        }

        return false;

    };

	

    /**

	 * Return boolean (true/false) as per the permission.

	 */	

    commonspot.util.hasPermission = function(permission, permissionList)

    {

        if( ! permissionList )

            return false;			

			

        permissionList = ',' + permissionList.toLowerCase() + ',';

        return (permissionList.indexOf(',' + permission.toLowerCase() + ',') != -1)

    };



    /*

	 * adds members of src to dest, returning dest

	 * overwrites existing members if overwrite is true

	 * ignores prototype members of either src or dest

	 * 	means it won't copy from src prototype, and it will overwrite dest prototype members

	 */

    commonspot.util.merge = function(dest, src, overwrite, lcaseDestField)

    {

        var destFld;

        for(var fld in src)

        {

            destFld = lcaseDestField ? fld.toLowerCase() : fld;

            if(src.hasOwnProperty(fld) && (overwrite || (!dest.hasOwnProperty(destFld)) || dest[destFld] === null))

                dest[destFld] = src[fld];

        }

        return dest;

    };

	

    /*

	 * pads passed value to a minimum of len chars; no effect if it's already that long or more

	 */

    commonspot.util.pad = function (val, len)

    {

        val = String(val);

        len = len || 2;

        while (val.length < len) val = "0" + val;

        return val;

    };

		

    /**

	 * commonspot.util.plural

	 * returns a string with passed count, a space, and count-appropriate form of noun

	 * @see \cs\devdocs\javascript-function-docs.js

	 */

    commonspot.util.plural = function(count, noun, specialPlural, specialZero)

    {

        switch(count)

        {

            case 0:

                return count + " " + (specialZero || specialPlural || (noun + "s"));

                break;

            case 1:

                return count + " " + noun;

                break;

            default:

                return count + " " + (specialPlural || (noun + "s"));

        }

    };

		

    commonspot.util.setOptions = function(dest, src)

    {

        for(var fld in src)

            dest[fld] = src[fld];

    };

							

	

    /*

	 * converts a date, or a string parsable as one, to commonspot's std yyyy-mm-dd hh:mm:ss format

	 * rtns commonspot.err.INVALID_DATE_TOKEN if not a valid date

	 */

    commonspot.util.toCSDateFormat = function(date)

    {

        date = new Date(date); // applies Date.parse if necessary

        if(isNaN(date))

            return commonspot.err.INVALID_DATE_TOKEN;

        return	date.getFullYear() + "-" +

					commonspot.util.pad((date.getMonth() + 1)) + "-" +

					commonspot.util.pad(date.getDay()) + " " +

					commonspot.util.pad(date.getHours()) + ":" +

					commonspot.util.pad(date.getMinutes()) + ":" +

					commonspot.util.pad(date.getSeconds());

    };



    /**

	 * Return true if a given object is an array

	 * @return boolean

	 * technique used in the next few functions is known as the Miller Device; see here:

	 * 	http://blog.360.yahoo.com/blog-TBPekxc1dLNy5DOloPfzVvFIVOWMB0li?p=916

	 * obj.constructor === Array and similar fails in multi-window/multi-frame environment

	 */

    commonspot.util.isArray = function(obj)

    {

        return obj && Object.prototype.toString.apply(obj) === "[object Array]";

    };

    commonspot.util.isDate = function(obj)

    {

        return obj && (Object.prototype.toString.apply(obj) === "[object Date]");

    }

    commonspot.util.isValidDate = function(obj)

    {

        return obj && commonspot.util.isDate(obj) && !(isNaN(obj));

    }

    commonspot.util.getObjectClass = function(obj)

    {

        var classStr = Object.prototype.toString.apply(obj); // "[object Array]", "[object String]", etc

        return classStr.substring(8, classStr.length - 1); // "Array", "String", etc

    };

	

    commonspot.util.arrayTest = function(_this, item, from)

    {

        //return cs_utility.array.arrayIndexOf(_this,item,from)!=-1;

        return _this.indexOf(item, from)!=-1;

    };

	

    /**

	 * given an array of objects and the name of a keyFld, returns an object...

	 * ...whose keys are the values in keyFld and whose values are the corresponding objects

	 * @param objArr (array): array of objects to examine

	 * @param keyFld (string): name of fld to look for in each object; values become keys in result object

	 */

    commonspot.util.objectArrayToObject = function(objArr, keyFld)

    {

        var i, keyValue;

        var obj = {};

        for(var i = 0; i < objArr.length; i++)

        {

            keyValue = objArr[i][keyFld];

            if(typeof keyValue != 'undefined')

                obj[keyValue] = objArr[i];

        }

        return obj;

    };

	

    /**

	 * returns a new object that's a by-value copy of passed one

	 * USAGE: foo = new commonspot.util.cloneObject(someObject);

	 */

    commonspot.util.cloneObject = function (obj)

    {

        for (i in obj)

            this[i] = obj[i];

    };

	

    /**

	 * Return a random integrer

	 * @return integer

	 */

    commonspot.util.generateRandomInt = function()

    {

        return Math.floor(Math.random() * 100000);

    };



    commonspot.util.getFileSizeHtml = function(fileSize)

    {

        if (fileSize < 1024)

            return fileSize + ' bytes';

			

        var value = fileSize % 1024;



        if (value > 0)

            return (fileSize / 1024).toFixed(2) + ' KB';

			

        return (fileSize / 1024) + ' KB';

    };

	

    commonspot.util.calcPreviewImgProp = function(origWidth, origHeight, maxWidth, maxHeight)

    {

        var isScaled = false;

        var newW = origWidth;

        var newH = origHeight;

				

        if ((origWidth >= maxWidth) || (origHeight >= maxHeight))

        {

            var ratioW = maxWidth / origWidth;

            var ratioH = maxHeight / origHeight;

            var ratio = Math.min(ratioW,ratioH);

	

            newW = Math.max(Math.round(origWidth * ratio), 1);		 

            newH = Math.max(Math.round(origHeight * ratio), 1);				

	

            isScaled = true;

        }		

	

        var imgProp = {width: newW,

            height: newH,

            isScaled: isScaled}

								

        return imgProp;

    };

	

    /*

	 * rtns html dump of passed obj

	 */

    commonspot.util.getDumpHTML = function(obj, caption)

    {

        var html = "";

        if(obj == undefined)

            html = "Object is undefined."

        else if(obj == null)

            html = "Object is null."

        else if(typeof obj == "function")

            html = "[function]";

        else if(typeof obj !== "object" || commonspot.util.isDate(obj))

            html = obj.toString().escapeHTML();

        else if(commonspot.util.isArray(obj))

        {

            var getDumpHTML = commonspot.util.getDumpHTML;

            var len = obj.length;

            html = '<table class="dumpTable">';

            if(caption)

                html += "<caption>" + caption +"</caption>";

            for(var i = 0; i < len; i++)

                html += "<tr><td>" + i + "</td><td>" + getDumpHTML(obj[i]) + "</td></tr>";

            html += "</table>";

        }

        else // object

        {

            var getDumpHTML = commonspot.util.getDumpHTML;

            html = '<table class="dumpTable">';

            if(caption)

                html += "<caption>" + caption +"</caption>";

            for(var key in obj)

                html += "<tr><td>" + key + "</td><td>" + getDumpHTML(obj[key]) + "</td></tr>";

            html += "</table>";

        }

        return html;

    };

	

    commonspot.util.repeatString = function(str, count)

    {

        var t = "";

        for(var i = 1; i <= count; i++)

            t += str;

        return t;

    };

	

    commonspot.util.jsSafe = function(str) // escape same chars as cf's JSStringFormat function

    {

        return str.replace(/(['"\\\b\t\n\f\r])/g, function(chr){return "\\" + commonspot.util.jsSafe.chars[chr.charCodeAt(0)];})

    };

    commonspot.util.jsSafe.chars = 

	{

	    8: "b",	// backspace

	    9: "t",	// tab

	    10: "n",	// newline

	    12: "f",	// formfeed

	    13: "r",	// carriage return

	    34: '"',	// dbl quote

	    39: "'",	// single quote

	    92: "\\"	// backslash

	};

	

    // returns str with tokens in the form {key} replaced by the value of data[key]

    // if key isn't found in data, returns original token

    // key can contain only alphanumeric characters and underscores

    commonspot.util.replaceTokens = function(str, data)

    {

        return str.replace

		(

			/{(\w+)}/g,

			function(fullMatch, key) // key is portion of match inside (), ie inside {} within str

			{

			    return (typeof data[key] === "undefined") ? fullMatch : data[key];

			}

		);

    };

	

    /**

	 * commonspot.util.cookie: package for cookie-related utilities

	 */

    commonspot.util.cookie = {};

		

    commonspot.util.cookie.createCookie = function(name,value,days)

    {

        if(days)

        {

            var date = new Date();

            date.setTime(date.getTime() + (days*24*60*60*1000));

            var expires = "; expires=" + date.toGMTString();

        }

        else 

            var expires = "";

        document.cookie = name + "=" + value + expires + "; path=/";			

    };

	

    commonspot.util.cookie.readCookie = function(name)

    {

        var nameEQ = name + "=";

        var ca = document.cookie.split(';');

        for (var i=0; i < ca.length; i++)

        {

            var c = ca[i];

            while (c.charAt(0) == ' ')

            {

                c = c.substring(1,c.length);

            }

            if (c.indexOf(nameEQ) == 0)

            {

                return c.substring(nameEQ.length,c.length);

            }	

        }

        return null;

    };

	

    commonspot.util.cookie.eraseCookie = function(name)

    {

        commonspot.util.cookie.createCookie(name,"",-1);

    };

	

    /**

	 * commonspot.util.dom: package for dom-related utilities

	 */

    commonspot.util.dom = {};

	

    /*

	encapsulation of dom createElement

	objType, objID, objClass, objTitle, objHTML, objParent, objOnClick, objRefBefore, objRefAfter

	*/	

    commonspot.util.dom.addToDom = function(args)

    {

        var dom = document.createElement(args.objType);

        if (args.objID)

            dom.id = args.objID;

        if (args.objTitle)

            dom.title = args.objTitle;

        if (args.objClass)

            dom.className = args.objClass;

        if (args.objHTML)

            dom.innerHTML = args.objHTML;	

        if (args.objRefBefore)

            args.objParent.insertBefore(dom, args.objRefBefore);

        else if (args.objRefAfter){} // not implemented

        else		

            args.objParent.appendChild(dom);

        if (args.objOnClick)

            commonspot.util.event.addEvent(dom, "click", args.objOnClick);

        return dom;	

    }

    /**

	 * commonspot.util.dom.getWinScrollSize: returns actual content size of given window; 

	 * @param win (object): window object. if not supplied returns value for current window

	 * @return {width, height}

	 */	

    commonspot.util.dom.getWinScrollSize = function()

    {

        var sWidth=0, sHeight=0;

        var winSize = commonspot.util.dom.getWinSize();

        var win = self;

        if (win.document.body.clientHeight)

        {

            sHeight = win.document.body.clientHeight;

            sWidth = win.document.body.clientWidth;

        }	

        else if (win.document.height)

        {

            sHeight = win.document.height;

            sWidth = win.document.width;

        }

        return {width: Math.max(sWidth,winSize.width), height: Math.max(sHeight,winSize.height)};

    };

	

    /**

	 * commonspot.util.dom.getWinSize: returns inner size of current window; from PPK

	 * @return {width, height}

	 */

    commonspot.util.dom.getWinSize = function()

    {

        var width, height;

        if (self.innerHeight) // all except Explorer

        {

            width = self.innerWidth;

            height = self.innerHeight;

        }

        else if (document.documentElement && document.documentElement.clientHeight) // Explorer 6 Strict Mode

        {

            width = document.documentElement.clientWidth;

            height = document.documentElement.clientHeight;

        }

        else if (document.body) // other Explorers

        {

            width = document.body.clientWidth;

            height = document.body.clientHeight;

        }

        return {width: width, height: height};

    };

	

    /**

	 * removes all child nodes from passed obj

	 * needed because IE won't directly set innerHTML of some tags

	 * 

	 * @param obj (object): object to remove all children from

	 */

    commonspot.util.dom.removeAllChildren = function(obj)

    {

        while(obj.firstChild)

            obj.removeChild(obj.firstChild);

    };

	

    /**

	 * finds tag w requested name further up in dom hierarchy from passed obj

	 * 

	 * @param obj (dom node): object to find an ancestor of

	 * @param tagName (string): tag name to find

	 * 	not case sensitive

	 * 	won't find body or anything above there; those are singletons w simpler ways to find them

	 * @param level (int, optional): if passed, return level'th matching ancestor, not just first one

	 */

    commonspot.util.dom.getAncestorTag = function(obj, tagName, level)

    {

        if(!obj || !obj.parentNode)

            return null;

			

        tagName = tagName.toUpperCase();

        if(typeof level == 'undefined')

            level = 1;

		

        var tag = obj.parentNode;

        var curLevel = 0;

		

        while((tag.nodeName != tagName || curLevel < level) && tag.parentNode && tag.parentNode.nodeName != 'BODY')

        {

            tag = tag.parentNode;

            if(tag.nodeName == tagName)

                curLevel++;

        }

		

        if(tag.nodeName != tagName || curLevel < level)

            tag = null;

        return tag;

    };

	

    /**

	 * returns elements w passed className inside element w passed id.

	 * homegrown because Prototype 1.5's getElementsBySelector seems broken in IE7.

	 * @param id (string): id of element to look inside

	 * @param className (string): className to look for

	 * @param tagName (string, optional): if passed, looks only at tags w this name 

	 * @param getAll (boolean, optional): if true, return array of all found elements, otherwise, return first one

	 */

    commonspot.util.dom.getChildrenByClassName = function(id, className, tagName, getAll)

    {

        var results = [];

        var classMatchRegex = new RegExp("(^|\\s)" + className + "(\\s|$)");

        var tags = document.getElementById(id).getElementsByTagName(tagName || '*');

        for(var i = 0; i < tags.length; i++)

        {

            if(tags[i].className == className || tags[i].className.match(classMatchRegex))

            {

                if(getAll)

                    results.push(tags[i]);

                else

                    return tags[i];

            }

        }

        // if looking for single element and found none, rtn null; w/o this, rtns an empty array

        // when geAll=true we always rtn an array

        // when it's not, rtn a dom object, or something analogous to "no dom object", and tests false if you do if(domObj)

        if((!getAll) && (results.length === 0))

            return null;

        return results;

    };

	

    /*

	* get all editable fields of the form

	*/

    commonspot.util.dom.findAllFields = function(iform) {	

        var arr = [];

        var elements = iform.elements;	

        var element;

        for (var i=0; i<elements.length; i++)

        {

            element = elements[i];

            // get rid of bad apples first

            if(('hidden,button,submit,reset').indexOf(element.type)>=0)

                continue;

            if (element.disabled || element.readOnly)

                continue;

            arr.push(element);		

        }



        return arr;

    };



    /*

	* activate all editable fields of the form

	*/	

    commonspot.util.dom.activateAllFields = function(iform) {	

        var elements = commonspot.util.dom.findAllFields(iform);

        var curFld;



        for (var i=0; i< elements.length; i++)

        {

            try

            {

                curFld = eval(iform + '.' + elements[i]);

                if (curFld)

                {

                    if (curFld.activate)

                        curFld.activate();

                    else

                        curFld.focus();	

                }

            }

            catch (ex) {}	

        }

    };

	

    /*

	* Finds the first editable, non-disabled, non-hidden form field excluding buttons to set focus.

	* Takes a form as single argument. 

	* This is an enhanced version of prototype's "findFirstElement" function

	*/

    commonspot.util.dom.findFirstEditableField = function(iform) {

        var firstByIndex = null;



        var elements = commonspot.util.dom.findAllFields(iform);

        try

        {

            if (elements.findAll)

            {

                firstByIndex = elements.findAll(function(element) 

                {

                    return element.hasAttribute('tabIndex') && element.tabIndex >= 0;

                }).sortBy(function(element) { return element.tabIndex }).first();

            }

        }

        catch(e){}

        return firstByIndex ? firstByIndex : arr[0];

    };

		

    /**

	 * commonspot.util.css: package for event-related utilities 

	 * we only need this addEvent function so adding it here instead of importing event package of prototype

	 */	



	

    commonspot.util.event = {};

	

    /**

	*	Irons out the IE and FF differences. Ideally we should use W3C model addEventListener,

	*	ie, when IE agrees with it

	*/

    commonspot.util.event.addEvent = function( dObj, type, fn ) 

    {

        if (dObj.addEventListener) 

        {

            dObj.addEventListener( type, fn, false );

            //EventCache.add(dObj, type, fn, 1);

        }

        else if (dObj.attachEvent) 

        {

            dObj["e"+type+fn] = fn;

            dObj[type+fn] = function() 

            { 

                dObj["e"+type+fn]( window.event ); 

            }

            dObj.attachEvent( "on"+type, dObj[type+fn] );

            EventCache.add(dObj, type, fn, 1);

        }

        else 

        {

            dObj["on"+type] = dObj["e"+type+fn];

        }

    };

	

    /**

	 * commonspot.util.css: package for css-related utilities

	 */

    commonspot.util.css = {};



    commonspot.util.css.addRemoveClassNameByIDs = function(objIDsList, className, add)

    {

        var lightboxWindow = top.commonspot.lightbox.getCurrentWindow();

        var objIDs = objIDsList.split(",");

        var objs = lightboxWindow.$.apply(lightboxWindow, objIDs);

        if(objs)

        {

            if(objs.nodeName) // single element

                objs = [objs];

            objs.each(function(elem, index)

            {

                if(!elem)

                    throw new Error("[addRemoveClassNameByIDs] Element with ID '" + objIDs[index] + "' can't be found.");

                else if(add)

                    elem.addClassName(className);

                else

                    elem.removeClassName(className);

            });

        }

        else // oops, bad objIDsList

            throw new Error("[addRemoveClassNameByIDs] Unable to find objects with the following IDs: " + objIDsList);

    };

		

		

    /**

	 * commonspot.util.css.showHideCSSClass: shows or hides a css class

	 */

    commonspot.util.css.showHideCSSClass = function(show, stylesheetID, targetClass)

    {

        var display = show ? '' : 'none';

        commonspot.util.css.setStyleRuleProperty(stylesheetID, targetClass, 'display', display);

    };

	

    /**

	*

	*/

    commonspot.util.css.setHideForMenusForAllFrames = function(stylesheetID, targetClass, propertyName, value, win)

    {

        var cWin;

        var win = win ? win : window;

        var arrayWindows = [];

        var iFrames = win.document.getElementsByTagName('iframe');

        for (var i =0; i<iFrames.length; i++)

        {

            cWin = iFrames[i].contentWindow;

            try

            {

                if (cWin && cWin.document)

                    arrayWindows[i] = cWin;

            }

            catch(e){};		

        }

		

        if (win.document)

            arrayWindows[iFrames.length] = win;

        for (i=0; i<arrayWindows.length; i++)

        {	

            commonspot.util.css.setStyleRuleProperty(stylesheetID, targetClass, propertyName, value, arrayWindows[i]);

        }	

    };	

	

	



	

    /**

	 * commonspot.util.css.setStyleRuleProperty: sets a requested property of a stylesheet class

	 */

    commonspot.util.css.setStyleRuleProperty = function(stylesheetID, targetClass, propertyName, value, win)

    {	

        // note that propertyNames need to use their js-style names, ie, 'whiteSpace', not 'white-space'

        var cssRules, ruleIndex;

        var doc = win ? win.document : document;

        var ss = doc.getElementById(stylesheetID);

        if(!ss)

            return;

        if(!ss.sheet) // IE

        {

            ss = doc.styleSheets[stylesheetID];

            cssRules = doc.styleSheets[stylesheetID].rules;

        }

        else // Firefox

        {

            cssRules = ss.sheet.cssRules;

        }

        ruleIndex = getCSSRuleIndex(cssRules, '.' + targetClass);

        if(ruleIndex != null)

        {

            cssRules[ruleIndex].style[propertyName] = value;

        }

        return;

	

        function getCSSRuleIndex(cssRules, selectorText)

        {

            for(var i = 0; i < cssRules.length; i++)

            {

                if(cssRules[i].selectorText == selectorText)

                {

                    return i;

                }

            }

            return null;

        }

    };

	

    commonspot.util.css.hideForMenus = function(hide) 

    {

        var prop=hide ? 'hidden' : 'visible';

        commonspot.util.css.setStyleRuleProperty('cs_maincss','cpHideForMenus','visibility',prop);

        commonspot.util.css.setStyleRuleProperty('cs_maincss','cpMenuSafe','visibility',prop);

    };

	

    /*

	 * shows or hides any number of passed elements, passed as objects or as IDs

	 * elements argument can be:

	 * 	- an elementID string, comma delimited for multiple

	 * 	- an object containing html elements or strings

	 *		- an array containing html elements or string elementIDs

	 * note:

	 * 	showHideElements works by modifying inline style

	 * 	showHideElementsUsingCSSClass does the same thing by adding or removing a css class; 

	 * 		it's a better choice for table rows

	 * 	copies of these functions in util.js work on objects in the top frame, regardless of where they're called from

	 * 	copies of them in nondashboard-util.js work on local window

	 */

    commonspot.util.css.showHideElements = function(show, elements, dspType)

    {

        if (!dspType) 

            dspType = 'block';

        var display = show ? dspType : 'none';

        var targets;

        if (typeof elements == 'string') 

            targets = elements.split(',');

        else 

            targets = elements;

        targets.each(function(elem)

        {

            $(elem).style.display = display;

        });

    };

	

    // see comments above for showHideElements

    commonspot.util.css.showHideElementsUsingCSSClass = function(show, elements)

    {

        var targets = (typeof elements == 'string') ? elements.split(',') : elements;

        if(typeof targets !== "array")

        {

            targets.each(function(elem)

            {

                if(show)

                    $(elem).removeClassName('showHideElements_hide');

                else

                    $(elem).addClassName('showHideElements_hide');

            });

        }

    };



	

    /*

	 * disables any number of passed elements, passed as objects or as IDs

	 * 	does visual change w css class 'disabled'; set that up to look right for the look of each kind of item 

	 *		does actual disabling by stashing item's onclick in onclickDisabled custom property, nulling onclick

	 *		also sets item's disabled property

	 *			if neither of those to methods applies (disabled parent item etc), code will need to check some other way

	 */

    commonspot.util.css.enableDisableElements = function(enable, elements)

    {

        if(enable)

            elements.each(function(elem)

            {

                elem.removeClassName('disabled');

                elem.onclick = elem.onclickDisabled ? elem.onclickDisabled : elem.onclick;

                elem.onmouseover = elem.onmouseoverDisabled ? elem.onmouseoverDisabled : elem.onmouseover;

                elem.disabled = false;

            });

        else

            elements.each(function(elem)

            {

                elem.addClassName('disabled');

                elem.onclickDisabled = elem.onclick ? elem.onclick : elem.onclickDisabled;

                elem.onmouseoverDisabled = elem.onmouseover ? elem.onmouseover : elem.onmouseoverDisabled;

                elem.onclick = null;

                elem.onmouseover = null;

                elem.disabled = true;

            });

    };

	

	

    commonspot.util.css.showFromMenuFields = function(visibleMenuClassList, fieldsList, dspType)

    {

        if(!dspType)

            dspType = 'block';

        var fld, show, selector;

        var aFields = fieldsList.split(',');

        var aData = visibleMenuClassList.split(',');

	

        for(var i = 0; i < aFields.length; i++)

        {

            fld = aFields[i];

	      

            show = commonspot.util.arrayTest(aData,fld,0) ? 1 : 0;

			

            selector = '.cs_' + fld + '_hide';

            commonspot.util.css.showHideElements(show, $$(selector), dspType)

        } 

    };

	

    commonspot.util.css.enableFromMenuFields = function(enabledMenuClassList, fieldsList, dspType)

    {

        if(!dspType)

            dspType = 'block';

        var fld, enable, selector;

        var aFields = fieldsList.split(',');

        var aData = enabledMenuClassList.split(',');

	

        for(var i = 0; i < aFields.length; i++)

        {

            fld = aFields[i];

	      

            enable = commonspot.util.arrayTest(aData,fld,0) ? 1 : 0;

			

            selector = '.cs_' + fld + '_disable';

            commonspot.util.css.enableDisableElements(enable, $$(selector))

        } 

    };

	

    /**

	 * display effects package

	 */

    commonspot.util.effects = {};

	

    /**

	 * commonspot.util.effects.blindLeft: like scriptaculous BlindUp, but to left

	 */

    commonspot.util.effects.blindLeft = function(element) {

        element = $(element);

        element.makeClipping();

        return new Effect.Scale(element, 0,

          Object.extend({ scaleContent: false, 

              scaleX: true,

              scaleY: false,

              restoreAfterFinish: true,

              afterFinishInternal: function(effect) {

                  effect.element.hide().undoClipping();

              } 

          }, arguments[1] || {})

        );

    };

	

    /**

	 * commonspot.util.effects.blindRight: like scriptaculous BlindDown, but from left

	 */

    commonspot.util.effects.blindRight = function(element) {

        element = $(element);

        var elementDimensions = element.getDimensions();

        return new Effect.Scale(element, 100, Object.extend({ 

            scaleContent: false, 

            scaleX: true,

            scaleY: false,

            scaleFrom: 0,

            scaleMode: {originalHeight: elementDimensions.height, originalWidth: elementDimensions.width},

            restoreAfterFinish: true,

            afterSetup: function(effect) {

                effect.element.makeClipping().setStyle({width: '0px'}).show(); 

            },  

            afterFinishInternal: function(effect) {

                effect.element.undoClipping();

            }

        }, arguments[1] || {}));

    };

	

	

    /**

	 * commonspot.util.menus: package for operating menus

	 */

    commonspot.util.menus = {};

	

    /*

	 * checks or unchecks passed menu item

	 * requires css class 'checked', with check image as background

	 * item should have class 'checkableMenuItem' applied always, for correct spacing

	 */

    commonspot.util.menus.checkItem = function(checked, item)

    {

        var element = $(item);

        if(!element)

        {}

        else if(checked)

            element.addClassName('checkedMenuItem');

        else

            element.removeClassName('checkedMenuItem');

    };

	



	

    /**

	 * change StyleRule.

	 * Currently the property is hardcoded for display:block.

	 * We have to make it dynamic . so that it can set any property.

	 */ 

    commonspot.util.css.changeStyleRule = function(document, sheetTitle, className, propertyName, value)

    {

        var rules = commonspot.util.css.getStyleSheetByTitle(document, sheetTitle).rules; 

		

        for (i=0; i< rules.length; i++)

        {      

            if (rules[i].selectorText.toLowerCase() == className.toLowerCase())

            { 	

                rules[i].style.display = value; 

                break; 

            } 

        }  

    };

	 

    /**

	 * Get Stylesheet By Title.

	 */ 

    commonspot.util.css.getStyleSheetByTitle = function(doc, sheetTitle)

    { 	

        var sheet = null;

        var rules = null;

		

        if (doc.styleSheets.length > 0)

        {

            for (i = 0; i< doc.styleSheets.length; i++)

            {

                if ( doc.styleSheets[i].title.toLowerCase()  == sheetTitle)

                {

                    sheet = doc.styleSheets[i];

                    rules = sheet.cssRules? sheet.cssRules: sheet.rules;

                    break; 

                }			 

            }  	

        }

		

        return {sheet: sheet, rules: rules};

    };



	

    /*

	 * xml utilities

	 */

    commonspot.util.xml = {};

	

    /**

	 * Serialize object's properties into XML tags

	 * @param obj (any type ex function I think) required

	 * @param nodeName (string) optional

	 * 	if not passed, defaults to 'struct' for structs, and 'array' for arrays

	 * 	for other types, no root node is rendered unless nodeName is passed, in which case it's used

	 * array containers have a 'class="array"' attribute to tell the server side that it's an array

	 * empty structs have a 'class="struct"' attribute for the same reason

	 * array item nodes are always <item> tags

	 * array example:

	 * 	<foo class="array"><item>hello</item><item>world</item></foo>

	 * @return an XML string

	 */

    /*

       test code:

var UNDEFINED;

tests =

[

   "asdf & <qwer>",

   new Date(),

   new Date("not a valid date"),

   {a:1,b:2},

   {a:1,b:2,c:{aa:11,bb:22,cc:{aaa:111,bbb:222}}},

   [1,2],

   [1,2,"asdf & <qwer>",{aa:11,bb:22}],

   [1,2,[33,44,[555,666]]],

   {a:1,b:2,c:[33,44,[555,666,{aa:77,bb:88,cc:[1,2]}]]},

   {a:1,b:'foo',c:'',d:[],e:{}},

   ["one element array"],

   {a:1,b:2,c:["one element array"]},

   function(){},

   {a:1,b:2,c:function(){}},

   UNDEFINED,

   null,

   {lastName: UNDEFINED, firstName: null, birthday: new Date('not a valid date')}

];

for(var i = 0; i < tests.length; i++)

{

   console.log(i, "TEST OBJ:", tests[i]);

   console.log(i, commonspot.util.xml.objectToXml(tests[i]));

   console.log(i, commonspot.util.xml.objectToXml(tests[i], "data"));

}

commonspot.util.xml.objectToXml(x);

    */

	

    commonspot.util.xml.objectToXml = function(obj, nodeName)

    {

        var xml = '';

        var _nodeName = nodeName;

		

        var type = typeof obj;

        if(obj === undefined)

            type = 'undefined';

        else if(obj == null)

            type = 'null';

        else if(type !== 'object')

        {}

        else if(commonspot.util.isArray(obj))

            type = 'array';

        else if(commonspot.util.isDate(obj))

            type = 'date';



        switch (type)

        {

            case 'number':

            case 'boolean':

                xml = obj;

                break;

				

            case 'string':

                xml = commonspot.util.xml.encodeEntities(obj);

                break;

			

            case 'date':

                if(isNaN(obj))

                {

                    xml = commonspot.err.INVALID_DATE_TOKEN;

                    nodeClass = 'exception';

                }

                else

                {

                    xml = commonspot.util.toCSDateFormat(obj);

                    if(xml === commonspot.err.INVALID_DATE_TOKEN)

                        nodeClass = 'exception';

                }

                break;

			

            case 'array':

                _nodeName = _nodeName ? _nodeName : 'array';

                var nodeClass = 'array';

                var objectToXml = commonspot.util.xml.objectToXml; // local, will bang on it

                var len = obj.length;

                for(var i = 0; i < len; i++)

                    xml += objectToXml(obj[i], 'item');

                break;

				

            case 'object':

                _nodeName = _nodeName ? _nodeName : 'struct';

                nodeClass = 'struct';

                var objectToXml = commonspot.util.xml.objectToXml; // local, will bang on it

                for(var key in obj)

                {

                    xml += objectToXml(obj[key], key);

                    nodeClass = ''; // dont' need to put a class on it if it has children

                }

                break;

			

            case 'null':

                xml = commonspot.err.NULL_VALUE_TOKEN;

                nodeClass = 'exception';

                break;

			

            case 'undefined':

                xml = commonspot.err.UNDEFINED_VALUE_TOKEN;

                nodeClass = 'exception';

                break;

				

            default:

                xml = commonspot.err.UNSUPPORTED_TYPE_TOKEN.replace('</', ': ' + typeof obj + '</');

                nodeClass = 'exception';

        }



        if(_nodeName)

            xml = '<' + _nodeName + (nodeClass ? ' class="' + nodeClass + '"' : '') + '>' + xml + '</' + _nodeName + '>';

        return xml;

    };

	

    /**

	 * returns a javascript object analguous to a passed xml node

	 * @param node (xml node): node to process

	 * @param skip (string || object):

	 * 	can be a comma delimited list of dot-path items to omit, ie, "item.data,item.status.data.cmd"

	 * 		no extra whitespace!!!

	 * 	can also be a struct w those dot-path items as keys and any value that evals as true in a boolean test

	 * 	NOT xpath etc, ie, no wildcards, just simple exact match to passed skip paths

	 * 	this is recursive, and passed string gets converted to a more efficient struct, which then gets passed on

	 * @param path (string || null):

	 * 	DO NOT PASS THIS. calls itself recursively, passing this internally to support @param skip

	 * @return (object): js object representing pass xml node

	 * 

	 * somewhat specialized for commonspot use

	 * 	doesn't create or examine attributes, with one exception:

	 * 	attribute 'class' is used to know if a container is an array, but not applied to result

	 */

    /* test code

xml = '<s><a>1</a><b>2</b><c class="array"><item>11</item><item>22 &quot; &apos; &lt; &gt; &amp; &amp;amp; &amp;amp;amp;</item><item></item><item class="array"></item><item class="struct"></item></c></s>';

xmlDoc = tmt.xml.stringToDOM(xml);

commonspot.util.xml.nodeToObject(xmlDoc);

*/

	

    commonspot.util.xml.nodeToObject = function(node, skip, path)

    {

        if(!node)

            return null;

			

        if(!skip)

            skip = {};

        else if(typeof skip === "string")

        {	// passed value is a string, convert to struct for efficient existance testing

            var aSkip = skip.split(",");

            skip = {};

            for(var i = 0; i < aSkip.length; i++)

                skip[aSkip[i]] = true;

        }

		

        // if no path, make it "", and if it's not "", put a "." on end

        path = path || "";

        path = (path === "") ? path : (path + ".");

	

        var obj = {};

        var child, typeClass, isArray, isStruct, hasChildNodes, tagName, childObj, childPath, nodeAtrs, dataType, csItemKey;

	

        nodeAtrs = commonspot.util.xml.getNodeAttributes(node);

        if(commonspot.util.xml.nodeHasValue(node)) // node has a value, use it

        {

            dataType = (nodeAtrs && nodeAtrs["type"]) ? nodeAtrs["type"].toLowerCase() : null; // we honor 'type' attribute

            try

            {

                child = node.firstChild;

                switch(child.nodeType)

                {

                    case 3: // TEXT_NODE

                    case 4: // CDATA_SECTION_NODE

                        obj = child.data;

                        if(dataType === "bool")

                            obj = obj.toBoolean();

                        else if(dataType === "int")

                        {

                            obj = parseInt(obj);

                            obj = isNaN(obj) ? 0 : obj;

                        }

                            /* dmerrill 9/4/09: works, not used, yet, maybe never
    
                            else if(dataType === "float")
    
                            {
    
                                obj = parseFloat(obj);
    
                                obj = isNaN(obj) ? 0 : obj;
    
                            }*/

                        else if(child.nodeType == 3) // TEXT_NODE

                            obj = commonspot.util.xml.encodeEntities(obj);

                        break;

                }

            } catch (e) { alert("commonspot.util.xml.nodeToObject() exception caught: " + e); }

        }

        else // no value

        {

            hasChildNodes = (node.childNodes && node.childNodes.length > 0);

            isArray = isStruct = false;

            if(nodeAtrs)

            {

                isArray = (nodeAtrs["class"] === "array");

                isStruct = (nodeAtrs["class"] === "struct");

            }

            if(!(isArray || isStruct))

                isStruct = hasChildNodes; // it's a struct if it isn't an array and has child nodes

            obj = isArray ? [] : isStruct ? {} : "";

			

            if(!hasChildNodes) // no value, no children

                return obj;

			

            child = node.firstChild;

            while(child)

            {

                tagName = child.nodeName;

                if(tagName === 'cs_item')

                {

                    csItemKey = commonspot.util.xml.getNodeAttribute(child, 'key');

                    tagName = csItemKey || tagName;

                }

                childPath = path + tagName;

                if(child.nodeType == 1 && !skip[childPath]) // Node.ELEMENT_NODE and not skipped path

                {

                    childObj = commonspot.util.xml.nodeToObject(child, skip, childPath);

                    if(isArray)

                        obj.push(childObj);

                    else

                        obj[tagName] = childObj;

                }

                child = child.nextSibling;

            }

        }

        return obj;

    };

	

    commonspot.util.xml.getNodeAttribute = function(node, attributeName)

    {

        if((!node.attributes) || node.attributes.length === 0)

            return null;

        attributeName = attributeName ? attributeName.toLowerCase() : null;

        for(var i = 0; i < node.attributes.length; i++)

        {

            if(node.attributes[i].name && (node.attributes[i].name.toLowerCase() == attributeName))

                return node.attributes[i].value;

        }

        return null;

    };

	

    commonspot.util.xml.getNodeAttributes = function(node)

    {

        if((!node.attributes) || node.attributes.length === 0)

            return null;

        var atrs = node.attributes;

        var result = {};

        for(var i = 0; i < atrs.length; i++)

        {

            if (atrs[i].name)

                result[atrs[i].name.toLowerCase()] = atrs[i].value;

        }	

        return result;

    };

		

    commonspot.util.xml.nodeHasValue = function(node)

    {

        if (node)

        {

            var child = node.firstChild;

            // 3 = Node.TEXT_NODE, 4 = CDATA_SECTION_NODE

            if (child && child.nextSibling == null && (child.nodeType == 3 || child.nodeType == 4))

                return true;

        }

        return false;

    };

	

    /**

	 * Unescapes special chars that the commonspot serializer escapes

	 * @return string

	 */

    commonspot.util.xml.decodeEntities = function(str)

    {

        if(str && (str.length >= 4) && str.search(/&lt;|&gt;|&quot;|&amp;/) != -1)

        {

            str = str.replace(/&lt;/gi, '<');

            str = str.replace(/&gt;/gi, '>');

            str = str.replace(/&quot;/gi, '"');

            str = str.replace(/&amp;/gi, '&');

        }

        return str;

    };

	

    commonspot.util.xml.encodeEntities = function(str)

    {

        if (str && str.search(/[&<>"]/) != -1)

        {

            str = str.replace(/&/g, '&amp;');

            str = str.replace(/</g, '&lt;');

            str = str.replace(/>/g, '&gt;');

            str = str.replace(/"/g, '&quot;');

        }

        return str;

    };

	

} // End: commonspot.util







/*

 * Error managment tools

 */

if(!commonspot.err) // commonspot.err not built yet

{

    // NAMESPACE

    commonspot.err = {};

	

    // CONSTANTS

    commonspot.err.COMMAND_REFUSAL_ERROR_CODE = 409;

    commonspot.err.AUTHORING_DISABLED_ERROR_CODE = 503;

    commonspot.err.INTERNAL_ERROR_CODE = 560;

	

    commonspot.err.INCOMPLETE_RETURN_VALUE_EXCEPTION = 'CSIncompleteReturnValueException';

	

    commonspot.err.HTTP_ERROR_MSG = 'Failed to get command response, server reported a communication error.';

    commonspot.err.FATAL_COMMAND_COLLECTION_ERROR_MSG = 'We\'re sorry, an error has occurred.';

    commonspot.err.EMPTY_COLLECTION_MSG = 'The command collection is empty and cannot be sent.';

    commonspot.err.EMPTY_RESPONSE_MSG = 'The server response is empty and cannot be processed.';

    commonspot.err.COMMAND_HANDLER_ERROR_MSG_START = 'JavaScript error in command response handler.';

    commonspot.err.UNMAPPED_FIELD_ERROR_MSG_START = '';

    commonspot.err.MISSING_DATASET_ERROR_MSG = 'Unable to locate dataset';

    commonspot.err.REQUIRED_MSG = "This field is required.";

	

    commonspot.err.MAPPED_FIELD_ERROR_MSGS_HEADER = 'Please correct the following:';

    commonspot.err.INTERNAL_ERROR_MSGS_HEADER = 'We\'re sorry, an internal error has occurred.';

	

    commonspot.err.FIELD_ERROR_CSS_CLASS = 'CommonSpotFieldError';

    commonspot.err.INVALID_VALUE_PREFIX = "{!INVALID_VALUE_PREFIX!}";

	

    commonspot.err.NULL_VALUE_TOKEN = '<message>Attempt to pass a null value.</message>';

    commonspot.err.UNDEFINED_VALUE_TOKEN = '<message>Attempt to pass an undefined value.</message>';

    commonspot.err.UNSUPPORTED_TYPE_TOKEN = '<message>Attempt to pass an unsupported type.</message>';

    commonspot.err.INVALID_DATE_TOKEN = '<message>Attempt to pass an invalid date.</message>';

	

    // STATIC METHODS

	

    /*

	 * rtns passed msg w INVALID_VALUE_PREFIX prepended

	 * point is that it's recognized by ErrorCollection.checkFieldValue as an invalid value

	 * for an example, see /dashboard/dialogs/tools/js/advanced-search.js:

	 * 	getOwner() rtns a msg built w commonspot.err.invalidMsg() if it's invalid

	 * 	collectFormArgs() creates a new commonspot.err.ErrorCollection

	 * 		then checks each collected value with the collection's checkFieldValue() method

	 * 		it then calls the collection's displayErrors() method to show them, and bails if that rtns true (were rrs)

	 */

    commonspot.err.invalidMsg = function(msg)

    {

        return commonspot.err.INVALID_VALUE_PREFIX + msg;

    };

		

    /*

	 * clears field error styling off all fields that might get it if they fail

	 * relevant fields are ones whose highlightIDs are in passed fieldErrorMap or are values in errorCodeMap

	 * always operates on topmost lightbox window, regardless of where it's called from

	 */

    commonspot.err.clearFieldErrorDisplay = function(fieldErrorMap, errorCodeMap)

    {

        var lightboxWindow = top.commonspot.lightbox.getCurrentWindow();

        var highlightIDs;

        for(var fld in fieldErrorMap)

        {

            highlightIDs = fieldErrorMap[fld].highlightIDs;

            if(highlightIDs)

                commonspot.util.css.addRemoveClassNameByIDs(highlightIDs, commonspot.err.FIELD_ERROR_CSS_CLASS, false);

        }

        for(var code in errorCodeMap)

        {

            highlightIDs = errorCodeMap[code].highlightIDs;

            if(highlightIDs) // should exist, friendlyName and highlightIDs are reason for map to exist

                commonspot.util.css.addRemoveClassNameByIDs(highlightIDs, commonspot.err.FIELD_ERROR_CSS_CLASS, false);

        }

    };

	

    // CLASSES

	

    /*

	 * ErrorCollection class, holds and displays error objects

	 */

    commonspot.err.ErrorCollection = function ()

    {

        this.errors = [];

        return this;

    };

	

    /*

	 * adds passed errorObject to this collection

	 * object must support render() method

	 * 	TODO: explain that more

	 */

    commonspot.err.ErrorCollection.prototype.addError = function(errorObject)

    {

        this.errors.push(errorObject);

    };

	

    /**

	 * checks passed value, if it starts w INVALID_PREFIX, it's an error, and rest of it is error msg

	 * 	so, add corresponding FieldError object to this ErrorCollection, and rtn true

	 * otherwise, it's not an error, clear its error appearance, and rtn false

	 * can also validate the value here, but mostly we validate on the server side, so in general, don't

	 * 

	 * @param value (any) required: value to check

	 * @param friendlyName (string) optional: name to call it in user alerts

	 * @param highlightID (string) optional: id of dom element to hilight if invalid

	 * @param validator (string or function) optional:

	 * 	if passed, it's used to process the value first

	 * 	can be the name of a std validator, in commonspot.err.validators namespace...

	 * 		...or a reference to (not the name of) a custom function 

	 * 	validator functions should return passed value if it's valid, else commonspot.err.invalidMsg("Some message")

	 */

    commonspot.err.ErrorCollection.prototype.checkFieldValue = function(value, friendlyName, highlightID, validator)

    {

        if(typeof validator === "string")

            validator = commonspot.err.validators[validator];

        if(typeof validator === "function")

            value = validator(value);

			

        var lightboxWindow = top.commonspot.lightbox.getCurrentWindow();

        if((typeof value === "string") && (value.substr(0, commonspot.err.INVALID_VALUE_PREFIX.length) == commonspot.err.INVALID_VALUE_PREFIX))

        {

            if(highlightID && highlightID != "")

                lightboxWindow.$(highlightID).addClassName(commonspot.err.FIELD_ERROR_CSS_CLASS);

            var msg = value.substr(commonspot.err.INVALID_VALUE_PREFIX.length);

            var fieldError = new commonspot.err.FieldError(msg, friendlyName, highlightID);

            this.addError(fieldError);

            return true;

        }

        else if(highlightID && highlightID != "")

        {

            lightboxWindow.$(highlightID).removeClassName(commonspot.err.FIELD_ERROR_CSS_CLASS);

            return false;

        }

    };

	

    /*

	 * if collection contains errors, displays them and rtns true, else rtns false

	 * TODO: explain more about responsibilities of objects in its error collection, and how instances of them get created

	 */

    commonspot.err.ErrorCollection.prototype.displayErrors = function()

    {

        if(this.errors.length > 0)

        {

            var lightboxWindow = top.commonspot.lightbox.getCurrentWindow();

            var fieldMsgs = "";

            var userMsgs = "";

            var internalMsgs = "";

            var msgs;

            for(var i = 0; i < this.errors.length; i++)

            {

                msgs = this.errors[i].render(lightboxWindow);

                if(msgs.field && msgs.field !== "")

                    fieldMsgs += msgs.field;

                if(msgs.user && msgs.user !== "")

                    userMsgs += msgs.user;

                if(msgs.internal && msgs.internal !== "")

                    internalMsgs += msgs.internal;

            }

            var msg = "";

            if(userMsgs !== "")

                msg += userMsgs;

            if(fieldMsgs !== "")

                msg += "<h2>" + commonspot.err.MAPPED_FIELD_ERROR_MSGS_HEADER + "</h2><dl>" + fieldMsgs + "</dl>";

            if(internalMsgs !== "")

                msg += "<h2>" + commonspot.err.INTERNAL_ERROR_MSGS_HEADER + "</h2><dl>" + internalMsgs + "</dl>";

            commonspot.dialog.client.alert(msg);

        }

        return (this.errors.length > 0); // boolean == hasErrors

    };

	

	

    /*

	 * Helper function.  Checks if the passed value is empty. If so sets an invalidMsg and checks the field Value

	 */

    commonspot.err.ErrorCollection.prototype.setErrorIfEmpty = function(value, friendlyName, highlightID, msg)

    {

        if(value == "")

        {

            if(typeof(msg) == "undefined")

                msg = commonspot.err.REQUIRED_MSG;

            value = commonspot.err.invalidMsg(msg);

            this.checkFieldValue(value, friendlyName, highlightID);		

        }	

    };

	

    /*

	 * CmdError class, represents a server-side error running a cmd

	 * TODO: write this, document fieldErrors and fieldErrorMap members better

	 * fieldErrors

	 * 	errortype:

	 * 	message:

	 * 	fieldtype:

	 * 	passedtype:

	 * fieldErrorMap

	 * 	struct, keyed by the lcase argument name on the server side.

	 * 	for each field, value is a struct containing...

	 * 		friendlyName:

	 * 		highlightIDs:

	 * 		position:

	 */

    commonspot.err.CmdError = function(responseStatus, fieldErrorMap, errorCodeMap)

    {

        this.cmd = responseStatus.cmd;

        this.code = responseStatus.code;

        this.reasonCode = responseStatus.reasoncode;

        this.text = responseStatus.text;

        this.hasFieldErrors = responseStatus.hasFieldErrors;

        if(responseStatus.data)

        {

            this.exceptionType = responseStatus.data.exceptiontype;

            this.fieldErrors = responseStatus.data.fielderrors;

        }

        this.fieldErrorMap = fieldErrorMap;

        this.errorCodeMap = errorCodeMap;

        //console.log("CmdError.this", this);

        return this;

    };

	

    /*

	 * visually indicate field errors when applicable, and rtn struct w error msgs:

	 * 	.field: user-fixable data problems

	 * 	.user: other expected exception alerts

	 * 	.internal: unexpected internal error (cf crash, unmapped field errors, etc)

	 */

    commonspot.err.CmdError.prototype.render = function(lightboxWindow)

    {

        var map, fieldName, highlightIDs, position;

        var msgs = {field: "", user: "", internal: ""};

        var orderedFieldMsgs = [];

        var unorderedFieldMsgs = [];

        if(this.hasFieldErrors)

        {	// cmd refusal with field errors user can fix (if we have a mapping for the fld), typically validation

            for(var fld in this.fieldErrors)

            {

                if(!this.fieldErrors.hasOwnProperty(fld)) // skip prototype extended methods

                    continue;

                // if error is a string, not an object, it's an internal exception; so far, that's only INCOMPLETE_RETURN_VALUE_EXCEPTION

                if(typeof this.fieldErrors[fld] === 'string')

                {

                    msgs.internal += '<dt>' + this.errorSource(this.cmd, fld) + '</dt><dd>' + this.fieldErrors[fld].escapeHTML() + '</dd>';

                }

                else if(this.fieldErrorMap && this.fieldErrorMap[fld]) // have a mapping for this fld -- user-entered data they can change

                {

                    map = this.fieldErrorMap[fld];

                    fieldName = map.friendlyName || fld;

                    highlightIDs = map.highlightIDs;

                    position = map.position;

                    if(highlightIDs)

                        commonspot.util.css.addRemoveClassNameByIDs(highlightIDs, commonspot.err.FIELD_ERROR_CSS_CLASS, true);

                    msg = (this.fieldErrors[fld].errortype == "empty") ? commonspot.err.REQUIRED_MSG : this.fieldErrors[fld].message;

                    msg = '<dt title="Data type: ' + this.fieldErrors[fld].fieldtype + '">' + fieldName + '</dt><dd>' + msg.escapeHTML() + '</dd>';

                    if(typeof position == "undefined") // has position only if added to cmd collection via a Command obj

                        unorderedFieldMsgs.push(msg);

                    else

                        orderedFieldMsgs[position] = msg;

                }

                else // no mapping for this fld, not something user can fix -- internal error or missing or incorrect map

                    msgs.internal += '<dt title="Data type: ' + this.fieldErrors[fld].fieldtype + '">' + this.errorSource(this.cmd, fld) + '</dt><dd>' + commonspot.err.UNMAPPED_FIELD_ERROR_MSG_START + this.fieldErrors[fld].message.escapeHTML() + '</dd>';

            }

        }

        else if(this.code === commonspot.err.COMMAND_REFUSAL_ERROR_CODE) // non-field cmd refusal

        {

            map = this.errorCodeMap ? this.errorCodeMap.getForCode(this.reasonCode) : null;

            if(map) // have specs for this reasonCode, alert like a field error and highlight requested flds

            {

                commonspot.util.css.addRemoveClassNameByIDs(map.highlightIDs, commonspot.err.FIELD_ERROR_CSS_CLASS, true);

                msg = '<dt>' + map.itemTitle + '</dt><dd>' + this.text.escapeHTML() + '</dd>';

                unorderedFieldMsgs.push(msg);

            }

            else

                msgs.user += '<p>' + this.text.escapeHTML() + '</p>';

        }

        else if(this.code === commonspot.err.AUTHORING_DISABLED_ERROR_CODE) // authoring is disabled, just say it

            msgs.user += '<p>' + this.text.escapeHTML() + '</p>';

        else // non-field internal error

            msgs.internal += '<dt>' + this.errorSource(this.cmd) + '</dt><dd>' + this.text.escapeHTML() + '</dd>';

			

        msgs.field = orderedFieldMsgs.join("") + unorderedFieldMsgs.join(""); // concat ordered msgs, ones w no position at end

        return msgs;

    };

	

    commonspot.err.CmdError.prototype.errorSource = function(cmd, fld)

    {

        switch(this.exceptionType)

        {

            case "CSIncompleteReturnValueException":

                return cmd + ", " + "field '" + fld + "' in return value:";

            default:

                return (fld ? cmd + "." + fld : cmd);

        }

    };

	

	

    /*

	 * CmdHandlerError class, represents a client-side js error in a cmd response handler

	 * TODO: write this

	 */

    commonspot.err.CmdHandlerError = function(cmd, error)

    {

        this.cmd = cmd;

        this.text = error.toString().escapeHTML();

        return this;

    };

	

    /*

	 * visually indicate field errors when applicable, which won't happen, and...

	 * rtn struct w error msgs:

	 * 	.field: user-fixable data problems; null

	 * 	.user: other expected exception; null

	 * 	.internal: unexpected internal error; error text

	 */

    commonspot.err.CmdHandlerError.prototype.render = function(lightboxWindow)

    {

        var msgs =

		{

		    field: "",

		    user: "",

		    internal: "<dt>" + this.cmd + "</dt><dd>" + commonspot.err.COMMAND_HANDLER_ERROR_MSG_START + "<br />" + this.text.escapeHTML() + "</dd>"

		};

        return msgs;

    };

	

    /*

	 * FieldError class, represents a client-side validation error specific to some field

	 * TODO: write this

	 */

    commonspot.err.FieldError = function(msg, friendlyName, highlightIDs)

    {

        this.msg = msg;

        this.friendlyName = friendlyName;

        this.highlightIDs = highlightIDs;

        return this;

    };

	

    /*

	 * visually indicate field errors when applicable, which won't happen, and...

	 * rtn struct w error msgs:

	 * 	.field: user-fixable data problems; null

	 * 	.user: other expected exception; null

	 * 	.internal: unexpected internal error; error text

	 */

    commonspot.err.FieldError.prototype.render = function(lightboxWindow)

    {

        if(this.highlightIDs && this.highlightIDs != "")

            lightboxWindow.$

				.apply(lightboxWindow, this.highlightIDs.split(","))

				.addClassName(commonspot.err.FIELD_ERROR_CSS_CLASS);

        var msgs =

		{

		    field: "<dt>" + this.friendlyName + "</dt><dd>" + this.msg.escapeHTML() + "</dd>",

		    user: "",

		    internal: ""

		};

        return msgs;

    };



    /*

	* ErrorCodeMap class, represents a mapping of error codes to error item titles and highlightIDs

	* use to handle non-validation errors (cmd refusal) as a field error when it's a known code

	* constructor args let you create first mapping immediately; call addCode to add more if needed

	*/

    commonspot.err.ErrorCodeMap = function(code, itemTitle, highlightIDs)

    {

        this.map = {};

        if(code)

            this.addCode(code, itemTitle, highlightIDs);

        return this;

    };



    commonspot.err.ErrorCodeMap.prototype.addCode = function(code, itemTitle, highlightIDs)

    {

        this.map[code] = {itemTitle: itemTitle, highlightIDs: highlightIDs};

    };



    commonspot.err.ErrorCodeMap.prototype.getForCode = function(code)

    {

        return this.map[code];

    };

	

    /*

	 * namspace for client-side value validators

	 * shouldn't be many of these, most validation is server-side

	 * validators should return passed value if it's valid, else commonspot.err.invalidMsg("Some message")

	 * validators are used by ErrorCollection.checkFieldValue, so far

	 * you can pass checkFieldValue the name of a std validator, or a reference to (not the name of) a custom function 

	 */

    commonspot.err.validators = {};

	

    commonspot.err.validators.required = function(value)

    {

        if(value == "") // assumes value has been trimmed, as by commonspotLocal.util.getValue

            value = commonspot.err.invalidMsg(commonspot.err.REQUIRED_MSG);

        return value;

    };



} // commonspot.err not built yet


/**

 * commonspot.lightbox: lightbox package

 */

if (typeof commonspot == 'undefined')

commonspot = {};

commonspot.lightbox = {};

// Stack holding the currently opened lightboxes

commonspot.lightbox.stack = [];

// Defaults for size and position

commonspot.lightbox.DEFAULT_TOP = 20;

commonspot.lightbox.DIALOG_DEFAULT_WIDTH = 100;

commonspot.lightbox.DIALOG_DEFAULT_HEIGHT = 100;

commonspot.lightbox.WINDOW_MARGINS = 30;

// Constrains from XHTML/CSS and images

commonspot.lightbox.FURNITURE_HEIGHT = 70;

commonspot.lightbox.FURNITURE_WIDTH = 20;

commonspot.lightbox.CORNERS_WIDTH = 20;

// constant to request no overlay msg

commonspot.lightbox.NO_OVERLAY_MSG = 'NONE';

commonspot.lightbox.helpDlg = null;



var _startX = 0; // mouse starting positions 

var _startY = 0; 

var _offsetX = 0; // current element offset 

var _offsetY = 0; 

var _dragElement; // needs to be passed from OnMouseDown to OnMouseMove 

var _oldZIndex = 0; // we temporarily increase the z-index during drag 

var _debug = document.getElementById('debug');

if (typeof is == 'undefined')

    var is = BrowserCheck();

/**

 * Adjust layout. To call if vieport's dimensions changed

 */

commonspot.lightbox.adjustLayout = function()

{

    for(var i = 0; i < commonspot.lightbox.stack.length; i++)

        commonspot.lightbox.stack[i].adjustLayout();

};



commonspot.lightbox.openURL = function(options)

{

    var options = options || {};

    var defaultOptions =

	{

	    title: "Custom Dialog",

	    subtitle: "",

	    helpId: "",

	    width: 100,

	    name: 'customDlg',

	    height: 50,

	    hasMaximizeIcon: true,

	    hasCloseIcon: true,

	    hasHelpIcon: false,

	    hasReloadIcon: false,

	    url: "/commonspot/dashboard/dialogs/blank-dialog.html",

	    dialogType: "dialog"

	};	

    commonspot.util.merge(options, defaultOptions);

    var hideClose = options.hasCloseIcon ? false : true;

    var hideHelp = options.hasHelpIcon ? false : true;

    var hideReload = options.hasReloadIcon ? false : true;

    var dlgObj = commonspot.lightbox.openDialog(defaultOptions.url, hideClose, options.name, commonspot.lightbox.NO_OVERLAY_MSG, options.dialogType, null, hideHelp, hideReload);



    commonspot.lightbox.initCurrent(defaultOptions.width, defaultOptions.height, {title: options.title, subtitle: options.subtitle, reload: options.hasReloadIcon, helpId: options.helpId, maximize: options.hasMaximizeIcon}); 

    dlgObj.iframeNode.src = options.url;

    setTimeout(function() {

        commonspot.lightbox.resizeCurrent(options.width, options.height);

    }, 50);

}



/**

 * Open either a url or a document DOM inside a lightbox

 * @param url  (string). Required

 * @param hideClose  (boolean). Optional. Set it to true to remove the close button from furniture's top right corner

 * @param hideHelp (boolean). Optional. Set it to true for the dialogs that do not need the Help Button and the QAHelp Processing.

 */

commonspot.lightbox.openDialog = function(url, hideClose, name, customOverlayMsg, dialogType, opener, hideHelp, hideReload)

{

    var url = url ? url : null;

    var hideClose = hideClose ? hideClose : null;

    var hideHelp = arguments[6] ? arguments[6] : null;

    var hideReload = arguments[7] ? arguments[7] : null;

    var name = name ? name : null;

    if (name == 'error')

        name = 'dlg_error';

    var customOverlayMsg = customOverlayMsg ? customOverlayMsg : null;

    dialogType = dialogType || 'dialog';

    var dlgOpener = opener ? opener : null;

    var options = {

        url: url,

        hideClose: hideClose,

        name: name,

        customOverlayMsg: customOverlayMsg,

        dialogType: dialogType,

        opener: dlgOpener,

        hideHelp: hideHelp,

        hideReload: hideReload

    }

    commonspot.lightbox.stack.push(commonspot.lightbox.dialogFactory.getInstance(options));

    /*

	commented for 6.0 this should be live in 6.x when we want spellcheck for the spry dialogs.

	code in dashboard\dialogs\pageview\create-work-request.html is left as-is as an example.

	setTimeout(function(){

		if (commonspot.lightbox.stack.length)

			commonspot.lightbox.addSpellCheckButton(commonspot.lightbox.stack.last().getWindow().document);	

	},50);

	*/

    return commonspot.lightbox.stack[commonspot.lightbox.stack.length - 1];

};



/**

 * Changes the URL of the lightbox to a SPRY dialog

 * @param url  (string). Required

 */

commonspot.lightbox.loadSpryURL = function(url)

{

    var win = commonspot.lightbox.stack.last().getWindow();

    win.location.href = url;

};



/**

 * Changes the URL of the lightbox to a Legacy dialog

 * 

 * @param loaderParamsString (string): arguments to pass to loader

 * @param customVarValues (value object, optional): custom dynamic argument values

 * 

 * loaderParamsString is everything after the '?', including csModule=whatever.cfm

 * can include {varName} placeholders to be filled in when this is called

 * there are two kinds of vars:

 * 	- standard ones we do always

 * 		pageID for now, maybe others some day

 * 	- custom ones whose values are passed in customVarValues value object

 * 		customVarValues should be in the form {fldName1: fldValue1, fldName2: fldValue2,...}

 * 		{fldName1} in loaderParamsString will be replaced with fldValue1, etc

 */

commonspot.lightbox.loadLegacyURL = function(loaderParamsString, customVarValues, bNewWindow)

{

    // replace any std var placeholders w real values

    var pageID = commonspot.data.uiState.lview.dsCurrentPage.getCurrentRow().pageid;

    loaderParamsString = loaderParamsString.replace('{pageID}', pageID);

	

    // replace any custom dynamic arguments with passed values

    for(var fld in customVarValues)

        loaderParamsString = loaderParamsString.replace('{' + fld + '}', customVarValues[fld]);

	

    var win = commonspot.lightbox.stack.last().getWindow();

    if( bNewWindow )

        commonspot.dialog.server.show(loaderParamsString);

    else

    {

        // get loader, build url

        var loader = commonspot.clientUI.state.location.getLoaderURL('subsiteurl');

        var url = loader + '?' + loaderParamsString;	

	

        win.location.href = url;

    }

};



/*

 * Loads a full url (url with /{sitename}/loader.cfm?csmodule={template}

 */

commonspot.lightbox.loadLegacyFullURL = function(url)

{

    var win = commonspot.lightbox.stack.last().getWindow();

    win.location.href = url;

};



/*

 * returns the lightbox object representing the topmost window, ignoring alerts if requested

 */

commonspot.lightbox.getCurrent = function(includeAlerts)

{

    if (commonspot.lightbox.stack.length === 0)

        return;

    if (typeof includeAlerts === 'undefined')

        includeAlerts = true;

    if (includeAlerts)

        return commonspot.lightbox.stack.last();

    else

    {

        var endPos = commonspot.lightbox.stack.length - 1;

        for (var i = endPos; i >= 0; i--)

        {

            if (commonspot.lightbox.stack[i].dialogType !== 'alert')

                return commonspot.lightbox.stack[i];

        }

    }

}



/**

 * Get window object of topmost lightbox, ignoring alerts if requested

 */

commonspot.lightbox.getCurrentWindow = function(includeAlerts)

{

    var currentDlg = commonspot.lightbox.getCurrent(includeAlerts);

    if (currentDlg)

        return currentDlg.getWindow();

    else

        return window;	

};



/**

 * Close the topmost lightbox

 */

commonspot.lightbox.closeCurrent = function()

{

    if (commonspot.lightbox.stack.length > 0)

    {

        if (top.commonspot.lightbox.stack.length>1)

            activateFields(top.commonspot.lightbox.stack[top.commonspot.lightbox.stack.length-2].getWindow());	

	

        var currentDialog = commonspot.lightbox.stack.last();



        currentDialog.close(); 

    }

	

    if (commonspot.clientUI && commonspot.clientUI.isURLError)

    {

        commonspot.clientUI.state.mode.urlHash.setHashFromModeAndPage();

        commonspot.clientUI.isURLError = false;

    }

};



// function called when 'X' close btn image is clicked

// tries to do what dlg's own cancel or close btn would do, else just closes

commonspot.lightbox.closeBtnOnClick = function()

{

    try

    {

        var dlgWin = commonspot.lightbox.getCurrentWindow();

        var doc = dlgWin.document;

    }

    catch(e)

    {

        dlgWin = null;

    }

    if(!dlgWin)

    {

        commonspot.lightbox.closeCurrent();

        return;

    }	

    var closeBtn = doc.getElementById('closeButton') || doc.getElementById('Close');

    var cancelBtn = doc.getElementById('cancelButton');

    var btn = cancelBtn ? cancelBtn : closeBtn;

	

    if(!btn)

        commonspot.lightbox.closeCurrent();

    else if(btn.onclick)

        btn.onclick();

    else

        btn.click();

}



/**

 * Close the topmost lightbox and reload the parent Dialog

 */

commonspot.lightbox.closeCurrentWithReload = function()

{

    if (commonspot.lightbox.stack.length > 0)

    {

        var currentDialog = commonspot.lightbox.stack.last();

        currentDialog.close();

		

        // Get next existing dialog and reload it  

        if (commonspot.lightbox.stack.length != 0)

        {

            var nextExistingWindow = commonspot.lightbox.stack.last(); 

            nextExistingWindow.getWindow().location.reload();

        }

        else

            commonspot.lightbox.reloadPage();

    }

};



/**

 * Close the parent of topmost lightbox

 */

commonspot.lightbox.closeParent = function()

{

    var pos = commonspot.lightbox.stack.length - 2;

    if (pos >= 0)

        commonspot.lightbox.stack[pos].close();

};



/**

 * Close all parent lightboxes

 */

commonspot.lightbox.closeParentDialogs = function()

{

    var endPos = commonspot.lightbox.stack.length - 2;

    for (var i = endPos; i >= 0; i--)

        commonspot.lightbox.stack[i].close();

}



/**

 * Close all lightboxes, and refresh the innermost one

 * @param closeCount  int is the number of child dialogs to close

 */

commonspot.lightbox.closeChildDialogsWithReload = function(closeCount)

{

    var curCount = 0;

    for (var i = commonspot.lightbox.stack.length-1; i >= 0; i--)

    {

        if (curCount <= closeCount)

        {

            commonspot.lightbox.stack[i].close();  

            curCount++;

        }	

        else

            break;

    }

    // Get next existing dialog and reload it  

    if (commonspot.lightbox.stack.length != 0)

    {

        var nextExistingWindow = commonspot.lightbox.stack.last(); 

        nextExistingWindow.getWindow().location.reload();

    }		

};



/**

 * Close all lightboxes, apart the innermost one

 */

commonspot.lightbox.closeChildDialogs = function()

{

    for(var i = commonspot.lightbox.stack.length-1; i > 0; i--)

    {

        commonspot.lightbox.stack[i].close();  

    }

};



/**

 * Close all child lightboxes from given position

 */

commonspot.lightbox.closeChildDlgsFromPosition = function(currPos)

{

    if (typeof currPos === 'undefined')

        currPos = -1;  //if pass nothing, close all... ??

		

    var endPos = commonspot.lightbox.stack.length - 1;

	

    for (var i=endPos; i > currPos; i--)

        commonspot.lightbox.stack[i].close();

};



/**

 * Close given number of lightboxes 

 */

commonspot.lightbox.closeTopChildDialogs = function(count)

{

    if (!count)

        return;

    start = commonspot.lightbox.stack.length - 1;

    end = ((start - count) > -1) ? (start - count) : -1;



    for(var i = start; i > end; i--)

    {

        commonspot.lightbox.stack[i].close();

    }	

};



/**

 * Close all lightboxes

 */

commonspot.lightbox.closeAllDialogs = function()

{

    var endPos = commonspot.lightbox.stack.length - 1;

	

    for (var i = endPos; i >= 0; i--)

        commonspot.lightbox.stack[i].close();  

};



commonspot.lightbox.reloadPage = function()

{

    var pFrame = document.getElementById('page_frame');

    if (pFrame)

        pFrame.contentWindow.location.reload();	

    else if (!commonspot.lview)

        window.location.reload();

};

commonspot.lightbox.reloadAdmin = function()

{

    var pFrame = document.getElementById('admin_iframe');

    if (pFrame)

        pFrame.contentWindow.location.reload();	

    else if (!commonspot.lview)

        window.location.reload();

};

/**

 * Resize, setup and show the dialog inside the topmost lightbox

 * @param w			  (int). Required. Width of the dialog

 * @param h			  (int). Required. Height of the dialog

 * @param dialogInfo  (object). Required. Info about required for dialog's furniture 

 * {title (string), subtitle (string), helpId (string), close (boolean), reload (boolean), maximize (boolean)}

 * @param closeCallback (string). Optional. A callback function to be called on dialog's close 

 * @param includeAlerts (boolean). Optional, default false. Affects topmost non-alert lightbox unless this is true.

 */

commonspot.lightbox.initCurrent = function(w, h, dialogInfo, closeCallback, includeAlerts)

{

    var currentDialog = commonspot.lightbox.getCurrent(includeAlerts);

    if(currentDialog)

    {

        if ((typeof closeCallback != 'undefined') && (closeCallback != '') && (currentDialog.hasCloseButton)) 

            currentDialog.closeImg.onclick = function(){ currentDialog.getWindow()[closeCallback]();};

		

        currentDialog.resize(w, h);

        currentDialog.show();

        if(dialogInfo)

        {

            // Populate the furniture

            currentDialog.setUpFurniture(dialogInfo);

        }

        currentDialog.getWindow().focus();

        currentDialog.origWidth = currentDialog.width;

        currentDialog.origHeight = currentDialog.height;



        if(currentDialog.showQAButtons)

            commonspot.lightbox.getQAStatus(currentDialog);

    }

};



/**

 * Dialogs that have a DOM handler (typically server ones) should call this to let the handler do its job

 * Additionally, it extract info from the dialog to populate the furniture

 */

commonspot.lightbox.initCurrentServerDialog = function(index)

{

    if (commonspot.lightbox.stack.length > 0)

    {

        var currentDialog = commonspot.lightbox.stack.last();

        var win = currentDialog.getWindow();

        // Extract info from the dialog	

        var dialogInfo = commonspot.lightbox.extractServerDialogInfo(win, index);

        if (dialogInfo.maximize)

            commonspot.lightbox.stack.last().hasMaxButton = true;

        else

            commonspot.lightbox.stack.last().hasMaxButton = false;

        if(win.onLightboxLoad)

        {

            win.onLightboxLoad();

        }	

        currentDialog.setUpFurniture(dialogInfo);

        commonspot.lightbox.stack.last().origWidth = currentDialog.width;

        commonspot.lightbox.stack.last().origHeight = currentDialog.height;

    }

};



/**

*  function called by maximize / restore button of a lighbox dialog 

*  @param iconObj. Required. A reference to the maximize/restore button object

*/

commonspot.lightbox.callResize = function(iconObj)

{

    var currentDialog = commonspot.lightbox.stack.last();

    if (!iconObj)

        iconObj = document.getElementById('restoreImg_' + (commonspot.lightbox.dialogFactory.zIndexCounter-3));

    var tmpClassName = iconObj.className;

    if (tmpClassName.indexOf('ico_maximize')>-1)

    {

        // resize window to max size

        tmpClassName=tmpClassName.replace('ico_maximize','ico_pop');

        iconObj.title='Restore Down';

        var maxVals = commonspot.lightbox.getMaxSize();

        currentDialog.resize(maxVals.width-60, maxVals.height);

    }

    else

    {

        // restore window to its original size

        tmpClassName=tmpClassName.replace('ico_pop','ico_maximize');

        iconObj.title='Maximize';

        currentDialog.resize(currentDialog.origWidth, currentDialog.origHeight);

    }

    iconObj.className = tmpClassName;

};





/**

 * Extract information from a server dialog that will be used to set up the furniture (title, subtitle etc)

 * @param win			(window). Required. A reference to the dialog's window object

 */

commonspot.lightbox.extractServerDialogInfo = function(win, index)

{

    var doc = win.document;

    // index is defined when coming from page with tabs. without this index we are not updating

    // the lightbox subtitle.

    if (typeof index == 'undefined')

        var index = 0;

    var info = {

        title: '',

        subtitle: '',

        maximize: false,

        reload: true,

        close: true

    };

    var titleCell = '';	

    var subtitleCell = '';

    var errorCells = '';

	

    titleCell = getElementsByClassNameLocal("cs_dlgTitle")[index];



    if(titleCell)

    {

        info.title = titleCell.innerHTML;

        titleCell.style.display = 'none';

    }

	

    subtitleCell = getElementsByClassNameLocal('cs_dlgDesc')[index];

    if(subtitleCell)

    {

        info.subtitle = '<div>' + subtitleCell.innerHTML + '</div>';

        subtitleCell.style.display = 'none';

    }

	

    errorCells = getElementsByClassNameLocal('cs_lightboxServerDlgError');

    for(var i = 0; i < errorCells.length; i++)

    {

        info.subtitle += '<div class="cs_dlgError">' + errorCells[i].innerHTML + '</div>';

        errorCells[i].style.display = 'none';

    }

	

    // Help id should be stored inside a global JavaScript variable in the dialog

    if(win.DIALOG_HELP_ID)

        info.helpId = win.DIALOG_HELP_ID;



    var mainTable = win.document.getElementById('MainTable');

	

    if (mainTable && mainTable.className && (mainTable.className).indexOf('allowMaximize')>-1)

        info.maximize = true;

		

    if (mainTable && mainTable.className && (mainTable.className).indexOf('hideReload')>-1)

        info.reload = false;



    if (mainTable && mainTable.className && (mainTable.className).indexOf('hideClose')>-1)

        info.close = false;

		

    return info;

	

	

    function getElementsByClassNameLocal(className)

    {

        if ((is.mozilla && is.version > 3) || (is.ie && is.version > 8))

            return win.document.getElementsByClassName(className); // call native version of getElementsByClassName

        else

            return document.getElementsByClassName(className,doc); // call prototype version

    }

};



/**

 * Resize the dialog inside the topmost lightbox

 * @param w			(int). Required. Width

 * @param h			(int). Required. Height

 */

commonspot.lightbox.resizeCurrent = function(w, h)

{

    if (commonspot.lightbox.stack.length > 0)

    {

        var currentDialog = commonspot.lightbox.stack.last();

        currentDialog.resize(w, h);

        commonspot.lightbox.stack.last().origWidth = currentDialog.width;

        commonspot.lightbox.stack.last().origHeight = currentDialog.height;

    }

};



/**

 * Resize the dialog inside the topmost lightbox

 * @param w			(int). Required. Width

 * @param h			(int). Required. Height

 */

commonspot.lightbox.recalcLightboxSizeByPos = function(pos)

{

    if (commonspot.lightbox.stack.length > pos && commonspot.lightbox.stack.length > 0)

    {

        var currentDialog = commonspot.lightbox.stack[pos];

        var win = currentDialog.getWindow();

        var maintable = win.document.getElementById('MainTable');

        if(maintable)

            currentDialog.resize(maintable.offsetWidth, maintable.offsetHeight + 65);

        else

        {

            maintable = win.document.getElementById('pagelistContainerDiv');

            if(maintable)

                currentDialog.resize(maintable.offsetWidth - 20, maintable.offsetHeight + 81);

        }

    }

};



/**

 * Return the frame name of the topmost dialog, null if no dialog is opened

 */

commonspot.lightbox.getFrameName = function()

{

    if (commonspot.lightbox.stack.length > 0)

    {

        var currentDialog = commonspot.lightbox.stack.last();

        return currentDialog.getFrameName();

    }

    else

    {

        return null;

    }

};



/**

 * Return the max size currently available for a lightbox

 * @return {width, height}

 */

commonspot.lightbox.getMaxSize = function()

{

    var maxSize = {};

    var winDimensions = commonspot.lightbox.getWinSize();

    maxSize.height = winDimensions.height - commonspot.lightbox.FURNITURE_HEIGHT - commonspot.lightbox.WINDOW_MARGINS;

    maxSize.width = winDimensions.width - commonspot.lightbox.FURNITURE_WIDTH;

    return maxSize;

};





/**

 * Return the opener window of the topmost dialog, null if no opener

 * Actually, we only know top window's real opener if it was passed into dialogFactory.getInstance or openDialog

 * 	mostly nobody does that, except newWindow, in overrides.js, passes the current window as opener

 * If we don't have real opener, or if ignoreOpenerProperty is true, we return window of next-to-top lightbox

 */

commonspot.lightbox.getOpenerWindow = function(ignoreOpenerProperty)

{

    if (commonspot.lightbox.stack.length > 1)

    {

        // Opened by another dialog

        var thisDialog = commonspot.lightbox.stack.last();

        if (thisDialog.opener && !ignoreOpenerProperty)

            return thisDialog.opener;

        var previousDialog = commonspot.lightbox.stack[commonspot.lightbox.stack.length - 2];

        return previousDialog.getWindow();

    }

    else

        return commonspot.lightbox.getVisibleFrameWindow(); // not true in admin modes, but needed to create a pg from there

};



/**

* checks who amin-frame or lview-frame who is visible and returns that

**/

commonspot.lightbox.getVisibleFrameWindow = function()

{

    // for now, just returning pageFrame as there are few situations where this logic is not right.

    return commonspot.lightbox.getPageWindow();

	

    var cursection;

    var modes = ['mycs','lview','admin'];

    // not sure here for mycs, returning page_frame is correct or not. when we decide what is correct, we should change the first element of the below array to it.

    var windows = ['page_frame','page_frame','admin_iframe'];

    for (var i=0; i<modes.length; i++)

    {

        cursection = document.getElementById(modes[i]);

        curWin = document.getElementById(windows[i]).contentWindow;	

			

        try

        {

            curDisplay = cursection.style.display;		

        }

        catch(e)

        {

            curDisplay = 'none';

        }

	

        if (curDisplay != 'none')

            return curWin;

    }

};



/**

*	returns contentWindow of page-frame

*/

commonspot.lightbox.getPageWindow = function()

{

    var pFrame = document.getElementById('page_frame');

    var win, href;

    try

    {

        if (pFrame)

        {

            win = pFrame.contentWindow;

            href = win.location.href; // this is only a feeler to check if this is IE9 and has access denied problem

            return win;

        }

        else

            return top;

    }

    catch(e)

    {

        return top;

    }

};



/**

*	returns contentWindow of admin-frame

*/

commonspot.lightbox.getAdminWindow = function()

{

    var win = top.document.getElementById('admin_iframe').contentWindow;

    return (win ? win : null);

};



// returns next-to-top lightbox object (NOT its window)

// DOES NOT honor explicit opener property of lightbox object

commonspot.lightbox.getNextToTopDlg = function(returnOpenerWhenEmpty)

{

    var pos = commonspot.lightbox.stack.length - 2;

    var parentDialog = null;

    if (pos >= 0)

        parentDialog = commonspot.lightbox.stack[pos];

    else

    {

        if (returnOpenerWhenEmpty)

            return commonspot.lightbox.getPageWindow();

    }	

    return parentDialog;

}



// keep closing parent dlgs until we find one with requested callback, then return it

commonspot.lightbox.findCallbackInAncestorWindow = function(callback)

{

    var parentDlg, dlgCallback, pWindow, shouldBreak=0;

    var lightbox = commonspot.lightbox; // local ref, so we don't lose it as dlgs close; calling code should do the same to run callback

    var pageWindow = lightbox.getPageWindow();

    while((parentDlg = lightbox.getNextToTopDlg(true)) && !shouldBreak)

    {

		

        if (typeof parentDlg.getWindow == 'function')

        {

            pWindow = parentDlg.getWindow();

            shouldBreak = pWindow == pageWindow ? 1 : 0;

            dlgCallback = pWindow[callback];

        }	

        else

        {

            shouldBreak = parentDlg == pageWindow ? 1 : 0;

            dlgCallback = parentDlg[callback];

        }	

			

        if(dlgCallback)

            return dlgCallback;

        else

            parentDlg.close();

    }

    return null; // didn't find callback, oops

}



/*

 * Function to handle specific key presses.

 */

commonspot.lightbox.handleDialogKeys = function(e)

{

    if(!commonspot.lightbox.getCurrent().hasCloseButton)

        return;

    var code;

	

    if (!e) 

        var e = window.event; // Get event.



    // Get key code.

    if (e.keyCode) 

        code = e.keyCode;

    else if (e.which) 

        code = e.which;

	

    switch (code) 

    {

        case 27: // Escape key

            commonspot.lightbox.closeBtnOnClick();

            break;

    }

}		

/*

* should this go in a sperate namespace and file ??

*/

var commonspotData = {};

commonspot.lightbox.getQAStatus = function(dlgObj)

{

    if (!e) 

        var e = window.event; // Get event.

    dlgObj.QAStatusUpdated = true;	

    var args = {};	

    var temp = '';

    var obsArr = [];

    var win = dlgObj.getWindow();

    var frName = dlgObj.getFrameName();

    var frObj;

    /* we should have this somewhere common

		these are the titles that multiple dialogs can have. so do not expect them to be unique 

	*/

    var generalDialogTitles = ('CommonSpot Error,Debug Help Status,CommonSpot Message,About CommonSpot,CommonSpot Security Exception').split(",");;

    if (frName == 'error')

        return;

    var formFlds = win.document.getElementsByName("fromlongproc");

    if (formFlds.length)

    {

        //there may be more than 1

        for(var i=0;i<formFlds.length;i++)

        {

            if (formFlds[i].value == 1)

                return;

        }

    }

    obsArr = document.getElementsByName(frName);

    for (var i=0; i<obsArr.length; i++)

    {

        if (obsArr[i].tagName.toLowerCase() == 'iframe')

            frObj = obsArr[i];

    }

    if (!frObj)

        return;

    var hashArgs = commonspot.util.getHashArgs();

    if (!hashArgs)

        return;

    var mode = hashArgs.mode || commonspot.clientUI.state.mode.MYCS;	

    var LOADER_URL;

    // Set loader appropriately (based on Server Admin mode or not).

    if (mode != 'server_admin')

    {

        var url = hashArgs.url;

        if (url.length > 0)

            LOADER_URL = commonspot.clientUI.state.location.getPathFromUrlStr(url) + 'loader.cfm';

    }

    else

        LOADER_URL = '/commonspot/admin/loader.cfm';

    if (!LOADER_URL || commonspot.data.Users_GetUserInfo.getCurrentRow().name == '')

    {	

        commonspot.lightbox.hideQAElements('All');

        return;		

    }

    args.widgetName = dlgObj.headerTitle.innerHTML;

    args.widgetNameSrc = 'Request.params.csModule';

    args.queryString = '';

    args.statusType = "QA";

    args.formParams = '';

    args.helpObjectType = 'CFMDialog';

    args.helpObjectTitle = (args.widgetName != '') ? args.widgetName : win.document.title;

    if (args.widgetName == '')

        args.widgetName = args.helpObjectTitle;

    if ((generalDialogTitles.indexOf(win.document.title) >= 0)

				|| ((win.document.title).indexOf('Debug Help Status') == 0))

    {

        commonspot.lightbox.hideQAElements('All');

        return;	

    }	

    args.moduleName = unescape(frObj.src.toLowerCase());

    if (args.moduleName != '')

    {

        // first remove any protocol (if found) from the module name

        var index = args.moduleName.match(/^\s*https?:\/\/[^\/]*/);

        args.moduleName = args.moduleName.replace(index,''); 

        index = args.moduleName.indexOf('csmodule');

        if (index >= 0) // legacy

        {

            args.widgetNameSrc = "Request.params.csModule";

            temp = args.moduleName.substring(index);

            // look for csmodule=

            var begin = temp.indexOf('csmodule=');

            if (begin >= 0)

                begin = begin+9;

            // remove any query string part after csmodule value

            var end = temp.indexOf('&');

            if (begin>=0 && end>=0 && end>begin) // get just csmodule part if there is querystring

                args.moduleName = temp.substring(begin,end);

            else if (begin>=0) // get csmodule part

                args.moduleName = temp.substring(begin);	

        }	

        else //spry

        {

            index = args.moduleName.indexOf('/commonspot/dashboard/');

            if (index >= 0)

            {

                args.moduleName = args.moduleName.substring(index);

                index = args.moduleName.indexOf('?');

                if (index >= 0)

                    args.moduleName = args.moduleName.substring(0,index);

                args.widgetNameSrc = "SPRY Dialog URL";

                args.helpObjectType = "AJAXDialog";

            }	

        }

    }

    if (!args.widgetName.length)

    {

        commonspot.lightbox.hideQAElements('All');

        return;

    }	

    commonspotData.DebugHelp_getHelpObjectStatus = new commonspot.spry.Dataset({ xpath: commonspot.data.ARRAY_XPATH });	

    var collectionOptions = {closeOnError: 0, overlayElementID: '', onCompleteCallback: commonspot.lightbox.onCompleteCallback_GetHelpObjectStatus};

    var cmd = commonspot.ajax.commandEngine.commandCollectionFactory.getInstance(LOADER_URL, collectionOptions);

    cmdOptions = {datasetRoot: commonspotData, datasetName: 'DebugHelp_getHelpObjectStatus'};	

    cmd.add('DebugHelp', 'getHelpObjectStatus', args,  cmdOptions); 

    cmd.send();		



}



commonspot.lightbox.onCompleteCallback_GetHelpObjectStatus = function()

{

    if(this.hasAnyError)

    {

        commonspot.lightbox.hideQAElements('All');

        return;  

    }	

    var data = commonspotData.DebugHelp_getHelpObjectStatus.getData()[0];

    if (!data)

    {

        commonspot.lightbox.hideQAElements('All');

        return;

    }	

    var frName = commonspot.lightbox.stack.last().getFrameName();

    var statusMsg = window.document.getElementById('QAStatusMsg_' + frName);

    var statusIcon = window.document.getElementById('statusIcon_' + frName);

    var qaIcon = window.document.getElementById('qaIcon_' + frName);

    var reportsIcon = window.document.getElementById('reportsIcon_' + frName);

    var mapStatus = data["helpmodulestatus"];

    var intMapStatus;

    var statusText = "";

    var statusColor = 'green';

    switch(mapStatus)

    {

        case "AutoMapped":

            statusText = "AUTO";

            statusColor = 'lightgreen';

            intMapStatus = 1;

            break;

        case "Mapped":

            statusText = "MAP";

            statusColor = 'lightgreen';

            intMapStatus = 2;

            break;

        case "MappedBroken":

            statusText = "MAP-B";

            statusColor = 'tomato';

            intMapStatus = 3;

            break;

        case "MappedCanBeAuto":

            statusText = "MAP-A?";

            statusColor = 'yellow';

            intMapStatus = 4;

            break;

        case "NeedsMapDuplicate":

            statusText = "NO MAP-DUP";

            statusColor = 'tomato';

            intMapStatus = 5;

            break;

        case "NeedsMapNone":

            statusText = "NO MAP-NONE";

            statusColor = 'tomato';

            intMapStatus = 6;

            break;

    }

    if (statusMsg)

    {

        statusMsg.style.backgroundColor = statusColor;

        statusMsg.innerHTML = statusText;

        statusMsg.onclick = function(e) 

        {

            var event = e || window.event;	

            if(typeof event.stopPropagation!='undefined')

                event.stopPropagation();

            else

                event.cancelBubble=true;			

            commonspot.lightbox.openDialog('/commonspot/dashboard/dialogs/common/map-dialog.html?HelpObjectID=' + data["helpobjectid"],false, null, null, null, null, true);

        };	

    }

    if (intMapStatus >= 5)

    {

        var eleList = 'docIcon_'+frName+',qaIcon_'+frName;

        //commonspot.lightbox.hideQAElements(eleList);

    }



    var color = (data["statuscategorycolor"] == '' ? 'red' : data["statuscategorycolor"]).toLowerCase();

    var type = data["statustype"];

    if (statusIcon)

    {

        statusIcon.onclick = function(e)

        {

            var event = e || window.event;

            if(typeof event.stopPropagation!='undefined')	

                event.stopPropagation();

            else

                event.cancelBubble=true;

            commonspot.lightbox.openDialog('/commonspot/dashboard/dialogs/common/module-mapping-status-report.html',false, null, null, null, null, true);

        }

    }

    if (qaIcon)	

    {

        // if (type == 'QA' || type == '') // check current record type (can be 'QA' or 'Doc'

        qaIcon.src = '/commonspot/private/' + color + '.png';	

        qaIcon.onclick = function(e)

        {

            var event = e || window.event;	

            if(typeof event.stopPropagation!='undefined')

                event.stopPropagation();

            else

                event.cancelBubble=true;	

            commonspot.lightbox.openDialog('/commonspot/dashboard/dialogs/common/debug-status.html' +

											'?HelpObjectID=' + data["helpobjectid"] +

											'&HelpObjectTitle=' + escape(data["helpobjecttitle"]) +

											'&HelpObjectType=' + data["helpobjecttype"] +

											'&MappingCount=' + data["mappingcount"] +

											'&WidgetName=' + escape(data["widgetname"]) +

											'&StatusType=QA' +

											'&WidgetNameSource=' + escape(data["widgetnamesrc"]),false, null, null, null, null, true);

        }

    }

    if (reportsIcon)

    {

        reportsIcon.onclick = function(e)

        {

            var event = e || window.event;	

            if(typeof event.stopPropagation!='undefined')

                event.stopPropagation();

            else

                event.cancelBubble=true;			

            commonspot.lightbox.openDialog('/commonspot/dashboard/dialogs/common/help-status-report.html' +

											'?HelpObjectID=' + data["helpobjectid"] +

											'&HelpObjectTitle=' + escape(data["helpobjecttitle"]) +

											'&HelpObjectType=' + data["helpobjecttype"] +

											'&MappingCount=' + data["mappingcount"] +

											'&WidgetName=' + escape(data["widgetname"]) +

											'&WidgetNameSource=' + escape(data["widgetnamesrc"]),false, null, null, null, null, true);

        }

    }



}

/**

 * Singleton, object factory for lightboxed dialogs

 */

commonspot.lightbox.dialogFactory = {};

commonspot.lightbox.dialogFactory.zIndexCounter = 1000;





/**

 * Factory method for lightboxed dialogs

 * @param url			(string). Required

 * @param hideClose  (boolean). Optional. Set it to true to remove the close button from furniture's top right corner

 */

commonspot.lightbox.dialogFactory.getInstance = function(args)

{

    //url, hideClose, name, customOverlayMsg, dialogType, opener, hideHelp, hideReload

    var dialogObj = {dialogType: args.dialogType, opener: args.opener};

    var bodyNode = document.getElementsByTagName('body')[0];

    var nextZindex = commonspot.lightbox.dialogFactory.zIndexCounter +1;

    var overlayMsg = 'Loading...';

    var overlayTitle = 'Loading, please wait';

    var cVal = commonspot.util.cookie.readCookie('REGISTERDIALOGS');

    var onClick; 

    if (args.customOverlayMsg)

        overlayMsg = overlayTitle = args.customOverlayMsg;

    if(overlayMsg != commonspot.lightbox.NO_OVERLAY_MSG)

        commonspot.lightbox.loadingMsg.show(overlayMsg, overlayTitle);

	

    dialogObj.top = commonspot.lightbox.DEFAULT_TOP;

    dialogObj.boxWidth, dialogObj.width, dialogObj.height, dialogObj.left;

    dialogObj.frameName = args.name ? args.name : 'lightboxFrame_' + nextZindex;

    dialogObj.hasCloseButton = true;

    dialogObj.showQAButtons =  cVal == 'ON' ? true : false;

    if (args.hideHelp)

        dialogObj.showQAButtons = false;

    dialogObj.hasMaxButton = true;

    if(args.hideClose)

    {

        dialogObj.hasCloseButton = false;

        dialogObj.hasMaxButton = false;

    }



    var onclick = function(e) {

        var event = e || window.event;	 

        if(typeof event.stopPropagation!='undefined')

            event.stopPropagation();

        else

            event.cancelBubble=true;		

    };

    // Create the overlay layer

    dialogObj.overlayDiv = commonspot.util.dom.addToDom({objType:'DIV', objID: 'lightboxOverlay_' + nextZindex, objClass:'lightboxOverlay', objOnClick: onclick, objParent:bodyNode});

	

    dialogObj.overlayDiv.style.opacity = '.45';

    dialogObj.overlayDiv.style.filter='alpha(opacity=45);';

    dialogObj.overlayDiv.style.zIndex = nextZindex;

    dialogObj.overlayDiv.style.height = commonspot.util.dom.getWinScrollSize().height + 'px';

	

    // Main container

    dialogObj.divNode = document.createElement('div');

    dialogObj.divNode.className = 'lightboxContainer drag';

    dialogObj.divNode.onclick = function(e) { 

        var event = e || window.event;	 

        if(typeof event.stopPropagation!='undefined')

            event.stopPropagation();

        else

            event.cancelBubble=true;	

    }

    dialogObj.divNode.style.zIndex = nextZindex +1;

    dialogObj.divNode.style.top = '-5000px';

    var thisZIndex = nextZindex+2;

	

    // Top corners

    dialogObj.topCorners = commonspot.util.dom.addToDom({objType:'DIV', objID: 'lightboxTopCorner_' + nextZindex, objClass:'lightboxTopCorner', objHTML:commonspot.lightbox.generateHTMLcorners('t'), objParent:dialogObj.divNode});	

    dialogObj.topCorners.style.zIndex = thisZIndex;

    // Header section

    dialogObj.header = document.createElement('div');

    dialogObj.header.className = 'lightboxHeader';

    dialogObj.header.id = 'lightboxHeader_' + nextZindex;

    dialogObj.header.onmousedown = OnMouseDown;

    dialogObj.header.onmouseup = OnMouseUp;

	

    // Title 

    dialogObj.titleContainer = commonspot.util.dom.addToDom({objType:'DIV', objClass:'lightboxTitleContainer', objParent:dialogObj.header});	



    // Header Title

    dialogObj.headerTitle = commonspot.util.dom.addToDom({objType:'H1', objParent:dialogObj.titleContainer});	



    // Top icons

    dialogObj.iconsContainer = document.createElement('div');

    dialogObj.iconsContainer.className = 'lightboxIconsContainer';



    // help icon

    if (!args.hideHelp)

    {

        dialogObj.helpImg = commonspot.util.dom.addToDom({objType:'SPAN', objID:'help_img', objClass:'ico_help actionMontageIcon', objTitle:'Help', objParent:dialogObj.iconsContainer});	

    }	



    // qa icons

    if (dialogObj.showQAButtons)

    {

        dialogObj.QAiconsContainer = commonspot.util.dom.addToDom({objType:'DIV', objClass: 'QAIconsContainer', objParent:dialogObj.iconsContainer});



        dom = commonspot.util.dom.addToDom({objType:'SPAN', objID:'QAStatusMsg_'+dialogObj.frameName, objClass:'statusMsg', objParent:dialogObj.QAiconsContainer});



        dom = commonspot.util.dom.addToDom({objType:'IMG', objID:'statusIcon_'+dialogObj.frameName, objClass:'statusIconClass', objTitle:'Mapping Report', objParent:dialogObj.QAiconsContainer});

        dom.src = ('/commonspot/dashboard/icons/application_view_detail.png');



        dom = commonspot.util.dom.addToDom({objType:'IMG', objID:'qaIcon_'+dialogObj.frameName, objClass:'qaIconClass', objTitle:'QA status', objParent:dialogObj.QAiconsContainer});

        dom.src = ('/commonspot/private/white.png');

		

        dom = commonspot.util.dom.addToDom({objType:'IMG', objID:'reportsIcon_'+dialogObj.frameName, objClass:'reportIconClass', objTitle:'Status Report', objParent:dialogObj.QAiconsContainer});

        dom.src = ('/commonspot/dashboard/icons/table_sort.png');

    }

	

    // Reload icon

    if (!args.hideReload)

    {	

        onClick = function()

        {

            var dialogWin = dialogObj.getWindow();

            if(dialogWin)

            {

                dialogWin.location.reload();

            }

        }

        dialogObj.reloadImg = commonspot.util.dom.addToDom({objType:'SPAN', objID:'reloadImg_'+nextZindex, objClass:'ico_arrow_refresh_small actionMontageIcon', objTitle:'Refresh', objParent:dialogObj.iconsContainer, objOnClick:onClick});

    }

		

	

    // Maximize / Restore icon

    if(dialogObj.hasMaxButton)

    {

        onClick = function(event){

            var event = event || window.event;	 

            var target = (event && event.target) || (event && event.srcElement);

            commonspot.lightbox.callResize(target);

        };

        dialogObj.maxImg = commonspot.util.dom.addToDom({objType:'SPAN', objID:'restoreImg_' + nextZindex, objClass:'ico_maximize actionMontageIcon', objTitle:'Maximize', objParent:dialogObj.iconsContainer, objOnClick:onClick});



        dialogObj.maxImg.style.display = 'none';

    }

	

    // Close icon

    if(dialogObj.hasCloseButton)

    {

        onClick = commonspot.lightbox.closeBtnOnClick;

        dialogObj.closeImg = commonspot.util.dom.addToDom({objType:'SPAN', objID:'closeImg_'+nextZindex, objClass:'ico_close actionMontageIcon', objTitle:'Close', objParent:dialogObj.iconsContainer, objOnClick:onClick});	

    }



    // blank space to right of right most icon

    dialogObj.blankImg = commonspot.util.dom.addToDom({objType:'SPAN', objClass:'ico_blank noactionMontageIcon', objParent:dialogObj.iconsContainer});	

		

    dialogObj.header.appendChild(dialogObj.iconsContainer);

    if (dialogObj.showQAButtons)

        dialogObj.header.appendChild(dialogObj.QAiconsContainer);

    if (!args.hideHelp)

        dialogObj.helpImg.innerHTML = '&nbsp;';

    if (!args.hideReload)	

        dialogObj.reloadImg.innerHTML = '&nbsp;';

    if(dialogObj.hasMaxButton)

        dialogObj.maxImg.innerHTML = '&nbsp;';

    if(dialogObj.hasCloseButton)	

        dialogObj.closeImg.innerHTML = '&nbsp;';

    dialogObj.blankImg.innerHTML = '&nbsp;';

		

    // subtitle

    dialogObj.subTitleContainer = commonspot.util.dom.addToDom({objType:'DIV', objClass:'lightboxSubTitleContainer', objParent:dialogObj.header});



    // header subtitle

    dialogObj.headerSubtitle = commonspot.util.dom.addToDom({objType:'H2', objParent:dialogObj.subTitleContainer});

	

    dialogObj.divNode.appendChild(dialogObj.header);

	

    onclick = function(e) { 

        var event = e || window.event;	 

        if(typeof event.stopPropagation!='undefined')

            event.stopPropagation();

        else

            event.cancelBubble=true;	

    };



    // iframe container

    dialogObj.iframeDiv = commonspot.util.dom.addToDom({objType:'DIV', objOnClick: onclick, objID: 'iframeContainer_' + nextZindex, objClass:'iframeContainer', objParent:dialogObj.divNode});

    dialogObj.divNode.id = 'lightboxContainer_' + nextZindex;

    dialogObj.iframeDiv.style.zIndex = thisZIndex;



    // iframe

    var iframeHTML = '<iframe class="lightboxIframe" scrolling="no" frameborder="0" src="' + args.url + '" name="' + dialogObj.frameName + '" id="' + dialogObj.frameName + '">';

    // Here we use innerHTML instead of DOM to work around a weird IE's bug, where borders are displayed for <iframe> created with DOM methods

    dialogObj.iframeDiv.innerHTML = iframeHTML;

    // We need to store a pointer tothe <iframe> DOM node

    dialogObj.iframeNode = dialogObj.iframeDiv.childNodes[0];



	

    // Bottom corners

    dialogObj.bottomCorners = commonspot.util.dom.addToDom({objType:'DIV', objID: 'lightboxBottomCorner_' + nextZindex, objClass:'lightboxBottomCorner', objHTML:commonspot.lightbox.generateHTMLcorners('b'), objParent:dialogObj.divNode});	

    dialogObj.bottomCorners.style.zIndex = thisZIndex;

    // Append everything to the body

    bodyNode.appendChild(dialogObj.divNode);

	

    // The header act as "handle" for dragging

    //dialogObj.draggable = new Draggable($(dialogObj.divNode), {handle: $(dialogObj.header), starteffect: false, endeffect: false, zindex: 9999999 });

	

    // Adjust the size of the ovelay layer to fill the whole vieport

    dialogObj.adjustLayout = function()

    {

        dialogObj.overlayDiv.style.height = commonspot.lightbox.getWinSize().height + 'px';

    }

	

    dialogObj.close = function()

    {

        commonspot.lightbox.loadingMsg.hide();

        try

        {

            //element.parentNode.removeChild(element);

            dialogObj.divNode.parentNode.removeChild(dialogObj.divNode);

            dialogObj.overlayDiv.parentNode.removeChild(dialogObj.overlayDiv);

            //EventCache.flushLightBoxEvents(nextZindex);

        }

        catch(e){}

        var index = commonspot.lightbox.stack.indexOf(dialogObj);

        commonspot.lightbox.stack.splice(index, 1);

        // fix IE8 "frozen" fields, by focusing topmost lightbox window if there is one

        var curWin = commonspot.lightbox.getCurrentWindow();

        if (!curWin)

            curWin = window;

		

        activateFields(curWin);

			

    }

	

    // This hides the lightbox dialog and overlay

    dialogObj.hideLightbox = function(delay)	

    {

        setTimeout(function(){ 

            $(dialogObj.divNode).hide();

            $(dialogObj.overlayDiv).hide();

        }, delay );

    }

	

    dialogObj.getFrameName = function()

    {

        return dialogObj.frameName;

    }

    dialogObj.getLightboxContainer = function()

    {

        return dialogObj.divNode;

    }

    dialogObj.getWindow = function()

    {

        return dialogObj.iframeNode.contentWindow;

    }

	

    dialogObj.resize = function(w, h)

    {

        var maxHeight = commonspot.lightbox.getMaxSize().height;

        var maxWidth = commonspot.lightbox.getMaxSize().width;

		

        if(h > maxHeight)

            h = maxHeight;

			

        w = w + commonspot.lightbox.FURNITURE_WIDTH;

        dialogObj.boxWidth = w + commonspot.lightbox.FURNITURE_WIDTH;

        dialogObj.width = w;

        if(dialogObj.boxWidth > maxWidth)

        {

            dialogObj.boxWidth = maxWidth;

            dialogObj.width = maxWidth - commonspot.lightbox.FURNITURE_WIDTH;

        }	

		

        dialogObj.height = h;			

        try

        {

            var dialogWin = dialogObj.getWindow();

            doc = dialogWin.doc;

            // If the dialog contains a onResize hook, call it

            if(dialogWin.onLightboxResize)

                dialogWin.onLightboxResize(dialogObj.width, dialogObj.height);

        }

        catch (e){}

        dialogObj.left = (commonspot.lightbox.getWinSize().width / 2) - (dialogObj.boxWidth / 2);

        var topSpacer = dialogObj.topCorners.childNodes[1];

        var bottomSpacer = dialogObj.bottomCorners.childNodes[1];

        topSpacer.style.width = (dialogObj.boxWidth -commonspot.lightbox.CORNERS_WIDTH) + 'px';

        bottomSpacer.style.width = (dialogObj.boxWidth -commonspot.lightbox.CORNERS_WIDTH) + 'px';

        dialogObj.divNode.style.left = dialogObj.left + 'px';

        dialogObj.divNode.style.width = dialogObj.boxWidth + 'px';

        dialogObj.iframeNode.style.width = dialogObj.width + 'px';

        dialogObj.iframeNode.style.height = dialogObj.height-3 + 'px';

        if (dialogObj.showQAButtons)

        {

            var rr = dialogObj.iconsContainer.style.width;

            dialogObj.QAiconsContainer.style.right = rr;

        }

    }

	

    dialogObj.show = function()

    {

        if (window == top) // not in dashboard

        {

            var wnd = commonspot.lightbox.getWinSize();

            if (typeof wnd.scrollY == 'number')

                dialogObj.divNode.style.top = (dialogObj.top + wnd.scrollY) + 'px';

            else

                dialogObj.divNode.style.top = dialogObj.top + 'px';

        }

        else

            dialogObj.divNode.style.top = dialogObj.top + 'px';

        commonspot.lightbox.loadingMsg.hide();

        dialogObj.iframeNode.style.visibility = 'visible';

        // Handle key events at the window level

        var dlgWin = dialogObj.getWindow();

        dlgWin.onkeydown = commonspot.lightbox.handleDialogKeys;

        activateFields(dlgWin);

    }

	

    dialogObj.setUpFurniture = function(info)

    {

        if(info.title)

        {

            dialogObj.headerTitle.innerHTML = info.title;

            if (!args.hideHelp)

            {

                dialogObj.helpImg.style.visibility = 'visible';

                dialogObj.helpImg.style.display = 'inline';

                if(info.title)

                {

                    dialogObj.helpImg.onclick = function()

                    {

                        var loaderUrl = commonspot.clientUI.state.location.getLoaderURL('subsiteurl');

                        var dialogUrl = loaderUrl + '?csModule=help/openhelp&CSHelpID=' + encodeURIComponent(info.title);		

                        var winSize = top.commonspot.util.dom.getWinSize();			

                        var argsStr = "menubar=0,location=0,scrollbars=1,status=0,resizable=1,width=" + (winSize.width-100) + ",height=" + (winSize.height-40);

                        if (commonspot.lightbox.helpDlg && !commonspot.lightbox.helpDlg.closed)

                            (commonspot.lightbox.helpDlg).location.href = dialogUrl;					

                        else

                            commonspot.lightbox.helpDlg = window.open(dialogUrl,'helpDlg',argsStr);

                    }

                }				

            }



        }

        if(info.subtitle.length)

        {

            (dialogObj.headerSubtitle).innerHTML = info.subtitle;

            (dialogObj.headerSubtitle).style.display = '';

        }	

        else

            (dialogObj.headerSubtitle).style.display = 'none';

		

        if (typeof(info.close) == 'undefined')

            info.close = true;



        if (typeof(info.reload) == 'undefined')

            info.reload = true;

			

        if (args.hideReload)

            info.reload = false;					

        if(info.maximize)

        {

            dialogObj.maxImg.style.visibility = 'visible';

            dialogObj.maxImg.style.display = 'inline';

        }	

        else

        {

            if( dialogObj.maxImg )

            {

                dialogObj.maxImg.style.display = 'none';

                dialogObj.maxImg.style.visibility = '';

            }

            dialogObj.hasMaxButton = false;

        }

				

        if(info.reload)

        {

            dialogObj.reloadImg.style.display = 'inline';

            dialogObj.reloadImg.style.visibility = 'visible';

        }



        if(typeof dialogObj.closeImg == 'undefined'){}

        else if(info.close)

        {

            dialogObj.closeImg.style.visibility = 'visible';

            dialogObj.closeImg.style.display = 'inline';

        }

        else

            dialogObj.closeImg.style.display = 'none';

    }

	

    dialogObj.showCrash = function()

    {

        var maxVals = commonspot.lightbox.getMaxSize();

        dialogObj.resize(maxVals.width-60, maxVals.height);

        dialogObj.iframeNode.style.overflow = "scroll";

        dialogObj.show();

        commonspot.dialog.client.alert("We're sorry, an error has occurred.<br />Close this message to view the available details.<br />Please see your server logs for more information.");

    };

	

    // Set initial size

    dialogObj.resize(commonspot.lightbox.DIALOG_DEFAULT_WIDTH, commonspot.lightbox.DIALOG_DEFAULT_HEIGHT);

    // Update z-index counter

    commonspot.lightbox.dialogFactory.zIndexCounter = commonspot.lightbox.dialogFactory.zIndexCounter +2;

    return dialogObj;

};



commonspot.lightbox.addSpellCheckButton = function(vDoc)

{

    var forms = vDoc.forms;

    var hasSpellcheck = false;

    var allFields = [];

    var noSpellCheckFlds = '';

    if (!forms.length)

        return;

		

    var spellCheckData = commonspot.data.SpellCheck_GetSettings.getData()[0];	

    if(!spellCheckData || !spellCheckData.enablespellcheck)

        return;

		

    var fld = vDoc.getElementById('noSpellCheckFields');

    if (fld && fld.value)

        noSpellCheckFlds = ',' + fld.value + ',';

		

    if (!hasSpellcheck)

    {

        for (var i=0; i<forms[0].elements.length; i++)

        {

            fld = forms[0].elements[i];

            fldStr = ',' + fld.name + ',';

            if ((fld.type == "text" || fld.type == "textarea") && (noSpellCheckFlds.indexOf(fldStr) == -1))

            {

                hasSpellcheck = true;

                break;

            }	

        }

    }	

    if (!hasSpellcheck)

        return;

    footer = vDoc.getElementById('dialogFooter');



    if (footer && hasSpellcheck)

    {

        var isChecked = "";

        isChecked = ' checked="checked"';

        if (spellCheckData.defaultstate == 'Enforce spell check')

            isChecked += ' disabled="disabled"';

        var dom = document.createElement('div');

        dom.id = 'spellCheckContainer';

        var label = document.createElement('label');

        dom.appendChild(label);

        var input = document.createElement('input');

        input.type = 'checkbox';

        input.id = 'SpellCheckOn';

        input.name = 'SpellCheckOn';

        input.value = 1;

        if (spellCheckData.defaultstate == 'Enforce spell check' || spellCheckData.defaultstate == 'Default On')

            input.checked = true;

        if (spellCheckData.defaultstate == 'Enforce spell check')

            input.readonly = true;

        label.appendChild(input);

        var tNode = document.createTextNode('Spell check');

        label.appendChild(tNode);						

        footer.appendChild(dom);

    }

};

commonspot.lightbox.loadingMsg =

{

    init: function()

    {

        var dom = document.createElement('div');

        dom.id = 'loading_container';

        dom.style.display = 'none';

        var dom2 = document.createElement('div');

        dom2.id = 'loading_content';

        dom2.title = 'Loading, please wait';

        img = document.createElement('img');

        img.id = 'loading_img';

        img.src = '/commonspot/dashboard/images/dialog/loading.gif';

        img.title = 'Loading, please wait';

        dom3 = document.createElement('div');

        dom3.id = 'loading_text';

        dom2.appendChild(img);

        dom2.appendChild(dom3);

        dom.appendChild(dom2);

        return top.document.body.appendChild(dom);

    },

    onDashboardLoaded: function()

    {

        top.document.getElementById('loading_container').style.display = 'none'; // kill initial Loading msg

        // add border, which we don't want against initial plain white, and background

        var loading_content = top.document.getElementById('loading_content');

        loading_content.style.border = '1px solid #7E96AD';

        loading_content.style.background = '#fff';

    },

    show: function(overlayMsg, overlayTitle)

    {

        var loadingDiv = top.document.getElementById('loading_content');

        if (!loadingDiv)

            loadingDiv = commonspot.lightbox.loadingMsg.init();

        var loadingImg = top.document.getElementById('loading_img');

        if (loadingDiv)

        {

            loadingDiv.title = overlayTitle;

            if (loadingImg)

                loadingImg.title = overlayTitle;

            setTimeout(function()

            {

                // attach onclick event to close if this is there even after 3 secs.

                if (top.document.getElementById('loading_container').style.display != 'none')

                {

                    loadingDiv.onclick = function(e) {

                        var event = e || window.event;	

                        if(typeof event.stopPropagation!='undefined')

                            event.stopPropagation();

                        else

                            event.cancelBubble=true;			

                        commonspot.lightbox.closeCurrent();			

                    }

                    var delayOverlayMsg = "Loading, please wait or click to abort";

                    loadingDiv.title = delayOverlayMsg;

                    if (loadingImg)

                        loadingImg.title = delayOverlayMsg;

                }

            },3000);	

        }

        top.document.getElementById('loading_text').innerHTML = overlayMsg;

        top.document.getElementById('loading_container').style.display = 'block';

    },

    hide: function()

    {

        top.document.getElementById('loading_container').style.display = 'none';

        top.document.getElementById('loading_content').onclick = {};

    }

};



/**

 * Helper method generate XHTML for top and bottom corners

 * @param type	(string). Required. Either 't' for top, or 'b', for bottom

 * @param width  (int). Required. Dimension of the dialog

 * @return XHTML code

 */

commonspot.lightbox.generateHTMLcorners = function(type)

{

    var cornersHTML = '';

    var spacerWidth = commonspot.lightbox.DIALOG_DEFAULT_WIDTH - commonspot.lightbox.CORNERS_WIDTH;

    cornersHTML += '<img width="10" height="10" src="/commonspot/javascript/lightbox/' + type + 'l.gif"/>';

    cornersHTML += '<img width="' + spacerWidth + '" height="10" src="/commonspot/javascript/lightbox/' + type + 'spacer.gif"/>';

    cornersHTML += '<img width="10" height="10" src="/commonspot/javascript/lightbox/' + type + 'r.gif"/>';

    return cornersHTML;

};





commonspot.lightbox.hideQAElements = function(objList)

{

    var frName = commonspot.lightbox.stack.last().getFrameName();

    var elem;

    var allObjects = "QAStatusMsg_,statusIcon_,docIcon_,qaIcon_,reportsIcon_";

    allObjects = allObjects.replace(/_/gi,"_"+frName);

    if (objList == 'All')

    {

        var objList = allObjects;

    }	

    var elems = allObjects.split(",");

    for(var i=0; i<elems.length; i++)

    {

        elem = document.getElementById(elems[i]);

        if(elem)

        {

            if (objList.indexOf(elems[i])>=0)

                elem.style.display='none';

            else

                elem.style.display='';	

        }

    }

}



commonspot.lightbox.setLightBoxControlState = function(name,state)

{

    if (typeof name == 'undefined')

        return;

    if (typeof state == 'undefined')

        var state = '';	

    var btnID = name + '_' + parseInt(parseInt(commonspot.lightbox.dialogFactory.zIndexCounter)-1);

    var btnObj = document.getElementById(btnID);

    if (btnObj)

        btnObj.style.display = state;

}

/**

 * Utility method. Returns inner size of current viewport

 * @return {width, height, scrollX, scrollY}

 */

commonspot.lightbox.getWinSize = function(checkCurrentFrameFirst, wnd)

{

    var width, height, scrollX, scrollY, pgFrame, pgWin, checkAccess;

    if (typeof checkCurrentFrameFirst == 'undefined')

        var checkCurrentFrameFirst = false;

    if (!wnd)

        var wnd = window;	

    if (checkCurrentFrameFirst)

    {

        try // need this try-catch to avoid IE 'access denied' error when there is no page context.

        {

            if (commonspot.lightbox.stack.length)

            {

                pgWin = commonspot.lightbox.stack.last().getWindow();

                checkAccess = commonspot.lightbox.stack.last().getFrameName();

            }	

            else

            {

                pgFrame = document.getElementById('page_frame');

                if (pgFrame)

                {

                    pgWin = pgFrame.contentWindow;

                    checkAccess = pgWin.name;

                }

            }

        }

        catch(e)

        {	

            pgWin = null;

            checkAccess = null;

        }	

        if (checkAccess)

            return commonspot.lightbox.getWinSize(false, pgWin);

    }

    if( typeof( wnd.innerWidth ) == 'number' ) 

    {

        //Non-IE

        width = wnd.innerWidth;

        height = wnd.innerHeight;

    } 

    else if( wnd.document.documentElement && 

				( wnd.document.documentElement.clientWidth || wnd.document.documentElement.clientHeight ) ) 

    {

        //IE 6+ in 'standards compliant mode'

        width = wnd.document.documentElement.clientWidth;

        height = wnd.document.documentElement.clientHeight;

    } 

    else if( wnd.document.body && ( wnd.document.body.clientWidth || wnd.document.body.clientHeight ) ) 

    {

        //IE 4 compatible

        width = wnd.document.body.clientWidth;

        height = wnd.document.body.clientHeight;

    }

    if( typeof( wnd.pageYOffset ) == 'number' ) 

    {

        //Netscape compliant

        scrollY = wnd.pageYOffset;

        scrollX = wnd.pageXOffset;

    } 

    else if( wnd.document.body && ( wnd.document.body.scrollLeft || wnd.document.body.scrollTop ) ) 

    {

        //DOM compliant

        scrollY = wnd.document.body.scrollTop;

        scrollX = wnd.document.body.scrollLeft;

    } 

    else if( wnd.document.documentElement && 

				( wnd.document.documentElement.scrollLeft || wnd.document.documentElement.scrollTop ) ) 

    {

        //IE6 standards compliant mode

        scrollY = wnd.document.documentElement.scrollTop;

        scrollX = wnd.document.documentElement.scrollLeft;

    }

	

    return {width: width, height: height, scrollX: scrollX, scrollY: scrollY};

};





function activateFields(win)

{

    var firstFld = null;

    if(win.document.forms.length)

    {

        for (var i=0; i<win.document.forms.length; i++)

        {

            commonspot.util.dom.activateAllFields(win.document.forms[i]);

        }

    }

    var iFrames = win.document.getElementsByTagName('iframe');



    // all other

    for (i=0; i<iFrames.length; i++)

    {

        try

        {

            var isSafe = iFrames[i].contentWindow.document;

        }

        catch(e)

        {

            continue;

        }	

        if (iFrames[i].contentWindow.document.forms && iFrames[i].contentWindow.document.forms.length)

        {

            for (var j=0; j<iFrames[i].contentWindow.document.forms.length; j++)

            {

                commonspot.util.dom.activateAllFields(iFrames[i].contentWindow.document.forms[j]);

            }

            iFrames[i].contentWindow.focus();

        }

    }



    win.focus();

}



function InitDragDrop() 

{ 

    if( typeof OnMouseDown != 'undefined' ) 

    {

        document.onmousedown = OnMouseDown; 

        document.onmouseup = OnMouseUp; 

    }

    else

        setTimeout( "InitDragDrop()", 100 );

}



InitDragDrop(); 

    /* 

 * overrides.js   Copyright PaperThin, Inc.

 */

if (typeof BrowserCheck != 'undefined')

var is = BrowserCheck();

if ((typeof top.commonspot != 'undefined') && (typeof top.commonspot.lightbox != 'undefined'))

{ 

    checkDlg = function()

    {

        ResizeWindow();

    }



    CloseWindow = function()

    {

        top.commonspot.lightbox.closeCurrent();

    }



    cs_OpenURLinOpener = function(workUrl)

    {

        OpenURLInOpener(workUrl);

    }



    doCPOpenInOpener = function(workUrl)

    {

        OpenURLInOpener(workUrl);

    }



    DoFocus = function(){};



    if (typeof handleLoad != 'function')

    {

        handleLoad = function()

        {

            ResizeWindow();

        }

    }	

	

    newWindow = function(name, url, customOverlayMsg, openInWindow, windowProps)

    {

        var customOverlayMsg = customOverlayMsg ? customOverlayMsg : null;	

        var openInWindow = openInWindow ? openInWindow : false;

        var windowProps = windowProps ? windowProps : null;

        if (openInWindow)

        {

            window.open(url, name, windowProps);

            return;

        }

        if (url.indexOf('/commonspot/dashboard/') == 0 || url.indexOf('controls/imagecommon/add-image') > 0)

        {

            if (!is.valid)

            {

                alert('This functionality requires Internet Explorer 7/Firefox 2 or later.');

                return;

            }

            var setupComplete = checkDashboardSetup();

            if (!setupComplete)

            {

                setTimeout(function(){

                    newWindow(name, url, customOverlayMsg);

                },100);

                return;

            }	

        }	



        if (top.commonspot && top.commonspot.lightbox)

            top.commonspot.lightbox.openDialog(url, null, name, customOverlayMsg, null, window);

    }



    OpenURLandClose = function(workUrl)

    {

        var openerWin = top.commonspot.lightbox.getOpenerWindow();

        openerWin.location.href = workUrl;

        if (document.getElementById("leavewindowopen").checked == false)

        {

            setTimeout('window.close()', 250);

        }

    }



    OpenURLInOpener = function(workUrl)

    {

        var openWin = top.commonspot.lightbox.getOpenerWindow();

        if (openWin)

        {

            openWin.location.href = workUrl;

        }	

    }



    RefreshAndCloseWindow = function(clearQueryParams)

    {

        var openWin = top.commonspot.lightbox.getOpenerWindow();

        var clearQueryParams = clearQueryParams ? clearQueryParams : 0;

        if (clearQueryParams)

        {

            ResetParentWindow();

            return;

        }

        try // without this try-catch IE throws Access Denied for dialogs called from site-admin

        {

            if (openWin)

                openWin.location.reload();

        }

        catch(e) {}	

        CloseWindow();

    }



    ResetParentWindow = function()

    {

        var pWin = top.commonspot.lightbox.getOpenerWindow();

        try // without this try-catch IE throws Access Denied for dialogs called from site-admin

        {

            if (pWin)

            {

                var addPageInLView = 0;

                var pSearch = pWin.location.search;

                if (pSearch.indexOf('cs_pgIsInLView=1') >= 0)

                    addPageInLView = 1;

                var pHref = pWin.location.href;

                if (pHref.length && pSearch.length)

                    pHref = pHref.replace(pSearch, '');

                if (addPageInLView)

                    pHref = pHref + '?cs_pgIsInLView=1';

                if (pHref != pWin.location.href)

                    pWin.location.href = pHref;

                else

                    pWin.location.reload();

            }	

        }

        catch(e) {}	

        CloseWindow();	

    }

	

    RefreshParentWindow = function()

    {

        var openerWin = top.commonspot.lightbox.getOpenerWindow();

        pageid = openerWin.js_gvPageID;

        if (pageid > 0)

        {

            openerWin.document.cookie = "scrollPage=" + pageid;

            openerWin.document.cookie = "scrollX=" + cd_scrollLeft;

            openerWin.document.cookie = "scrollY=" + cd_scrollTop;

        }

        openerWin.location.reload();

        DoFocus(self);

        DoFocusDone=1;	// not done, but we don't want the focus

    }



    ResizeWindow = function(doRecalc, curTab)

    {

        if (typeof ResizeWindowSafe != 'undefined')		// this variable is set in dlgcommon-head for legacy dialogs (initially set to 0, then to 1 upon calling dlgcommon-foot)

        { 

            if (ResizeWindowSafe == 1)

                ResizeWindow_Meat(doRecalc, curTab);  // this function is defined in over-rides.js

            else

                ResizeWindowCalledCount = ResizeWindowCalledCount + 1;

        }

        else

            ResizeWindow_Meat(doRecalc, curTab);  // this function is defined in over-rides.js

    }

	



    ResizeWindow_Meat = function(doRecalc, currentTab)

    {

        var maintable = document.getElementById('MainTable');

        if (maintable)

        {

            if (doRecalc)

            {

                if (top.commonspot)

                {

                    top.commonspot.lightbox.initCurrentServerDialog(currentTab);

                    ResizeWindow_Meat();

                }	

            }

            else

            {

                if (maintable.offsetHeight < 130)

                    maintable.style.height = '130px';

                else

                    maintable.style.height = '';

                if (maintable.offsetWidth < 300)

                    maintable.style.width = '300px';

				

                if (top.commonspot)

                {

                    top.commonspot.lightbox.initCurrent(maintable.offsetWidth+5, maintable.offsetHeight + 42);

                    fixFooterWidth(maintable.offsetWidth,maintable.offsetHeight + 40);

                }	

            }	

        }	

    }	



    fixFooterWidth = function() {

        var proxyBtnTable = document.getElementById('clsProxyButtonTable');

        var maintable = document.getElementById('MainTable');

        //debugger;

        if (proxyBtnTable && maintable && proxyBtnTable.offsetWidth > (maintable.offsetWidth+10))

        {

            maintable.style.width = proxyBtnTable.offsetWidth + 'px';

            top.commonspot.lightbox.initCurrent(proxyBtnTable.offsetWidth, maintable.offsetHeight + 40);

        }

    };

	

    setthefocus = function(){};



    /* Overwrite native window's methods */



    self.close = function()

    {

        CloseWindow();

    }



    //self.focus = function(){};



    top.window.resizeTo = function(w, h)

    {

        top.commonspot.lightbox.initCurrent(w, h);

    }



    window.close = function()

    {

        CloseWindow();

    }



    // window.focus = function(){};



    window.resizeTo = function(w, h)

    {

        top.commonspot.lightbox.initCurrent(w, h);

    }

	

    checkDashboardSetup = function()

    {

        if (top.commonspot.clientUI)

            return true;



        if (!parent.window.document.getElementById("hiddenframeDiv"))

            doDashboardSetup();



        return false;

    }

	

    doDashboardSetup = function()

    {

        if (document.parentWindow)

            var curWin = document.parentWindow;

        else

            var curWin = window;	

        var iframeDiv = curWin.parent.parent.document.createElement('div');

        iframeDiv.id = 'hiddenframeDiv';

        iframeDiv.style.left = '-1000px';

        iframeDiv.style.top = '-1000px';

		

        var iframeHTML = '<iframe src="/commonspot/dashboard/hidden_iframe.html" name="hidden_frame" id="hidden_frame" width="1" height="1" scrolling="no" frameborder="0"></iframe>';

        iframeDiv.innerHTML = iframeHTML;

        var hiddenFrame = iframeDiv.childNodes[0];

        parent.window.document.body.appendChild(iframeDiv);

    }

}



if (typeof(onLightboxLoad) == "undefined")

{

    /**

	* Hook that gets called by lightbox whenever the dialog gets loaded

	*/

    onLightboxLoad = function() 

    {	

        try{

            var rootDiv = document.getElementById('cs_commondlg')

        }catch(e){ 

            // $ function is not defined when there is an error. 

            // in that case, just return so we can show the error msg.

            return; 

        }	

        if (rootDiv)

        {	 

            // Check if we have buttons

            var outerDiv = document.getElementById('clsPushButtonsDiv');

            var tableEle = document.getElementById('clsPushButtonsTable');

            var otherBtns = document.getElementsByClassName('clsDialogButton');

            if (tableEle || otherBtns.length)

            {

                // Remove existing "proxy" buttons first

                var btnHolder = document.getElementById('clsProxyButtonHolder');

                if (btnHolder)

                {

                    btnHolder.parentNode.removeChild(btnHolder);

                }

				

                // check if cf debug is on

                var arr = document.getElementsByClassName('cfdebug');

                // Append a new <div> that will contain the "proxy" buttons

                var dom = document.createElement('div');

                dom.id = "clsProxyButtonHolder";

                dom.innerHTML = '<table id="clsProxyButtonTable" border="0" cellspacing="2" cellpadding="0"><tr><td id="clsProxySpellCheckCell" nowrap="nowrap"></td><td id="clsProxyButtonCell" nowrap="nowrap"></td></tr></table>';				

                if (arr.length > 0) 	// stick in after root div and before CF debug table

                {

                    /*

						IE has problem with appending node before a script node. to get around it we add a div node around

						the script tags we have after rootDiv (dlgcommon-foot.cfm) and manipulate its innerHTML

						however, non-ie browsers has problem with manipulating innerHTML so doing it ol'way

					*/

                    if (is.ie)

                    {

                        var inHTML = dom.outerHTML + rootDiv.nextSibling.innerHTML;

                        rootDiv.nextSibling.innerHTML = inHTML;

                    }

                    else

                        rootDiv.parentNode.insertBefore(dom, rootDiv.nextSibling);

                }	

                else

                    rootDiv.parentNode.appendChild(dom);



                proxySpellChecker($('clsProxySpellCheckCell'));

                proxyPushButtons($('clsProxyButtonCell'));

                // Hide the "real" buttons

                if (outerDiv)

                    outerDiv.style.display='none';

                if (tableEle)

                    tableEle.style.display='none';

            }

        }

    }

}	



proxyPushButtons = function(targetNode)

{

    var cellNode = $('clsProxyButtonCell');

    var buttons = $$('#clsPushButtonsTable input[type="submit"]', '#clsPushButtonsTable input[type="button"]');

    var moreButtons = document.getElementsByClassName('clsDialogButton', null, 'INPUT');

    var addClose = 0;

    for (var i=0; i<moreButtons.length; i++)

    {

        // lame! but FF is not happy with concat arrays feature;

        buttons.push(moreButtons[i]);

    }

    if ((buttons.length == 1 && buttons[0].value == 'Help') || buttons.length == 0)

        addClose = 1;

    cleanRadioAndCheckBoxes($$('#MainTable input[type="checkbox"]', '#MainTable input[type="radio"]'));

    var doneButtons = [];

    var buttonString = [];

    for(var i=0; i<buttons.length; i++)

    {

        buttons[i].style.display = 'none';

        var buttonText = buttons[i].value.replace(/^\s+|\s+$/g, '');

        buttonString[i] = buttonText.toLowerCase();

    }  

    // show prev button

    var indexButton = arrayIndexOf(buttonString,'prev');

    var proxyIndex = 1;

    if (indexButton != -1 && arrayIndexOf(doneButtons,'prev') == -1)    

    {

        cellNode.appendChild(createProxyButton(buttons[indexButton],proxyIndex++));

        doneButtons.push('prev');

    }



    // show next button

    indexButton = arrayIndexOf(buttonString,'next');

    if (indexButton != -1 && arrayIndexOf(doneButtons,'next') == -1)    

    {

        cellNode.appendChild(createProxyButton(buttons[indexButton],proxyIndex++));

        doneButtons.push('next');

    }      

    // show all misc. buttons that are not submit and not cancel or close

    for(var i=0; i<buttons.length; i++)

    {

        buttonText = buttons[i].value.replace(/^\s+|\s+$/g, '');

        if (buttonText != 'Help' && 

		      buttonText != 'Close' &&

				buttonText != 'No' &&

		      buttonText != 'Cancel' &&

		      buttons[i].type == 'button' &&

				arrayIndexOf(doneButtons,buttonText) == -1)

        {

            cellNode.appendChild(createProxyButton(buttons[i],proxyIndex++));

            doneButtons.push(buttonText);

        }

    }

     

     

    // show all submit buttons that are not cancel or close

    for(var i=0; i<buttons.length; i++)

    {

        buttonText = buttons[i].value.replace(/^\s+|\s+$/g, '');

        if (buttonText != 'Help' && 

					buttonText != 'Close' &&

					buttonText != 'No' &&

					buttonText != 'Cancel' &&

					buttons[i].type == 'submit' &&

					arrayIndexOf(doneButtons,buttonText) == -1)

        {

            cellNode.appendChild(createProxyButton(buttons[i],proxyIndex++));

            doneButtons.push(buttonText);

        }

    }     



    // show cancel and close buttons

    for(var i=0; i<buttons.length; i++)

    {

        buttonText = buttons[i].value.replace(/^\s+|\s+$/g, '');

        if (buttonText != 'Help' && arrayIndexOf(doneButtons,buttonText) == -1)

        {

            cellNode.appendChild(createProxyButton(buttons[i],proxyIndex++));

            doneButtons.push(buttonText);

        }   

    }  



    if (arrayIndexOf(doneButtons, 'cancel') != -1 || arrayIndexOf(doneButtons, 'close') != -1)

        addClose = 0;

	

    // show close button if there are no buttons in the lighbox

    if (addClose && cellNode)

    {

        var closeNode = {

            value: 'Close',

            className: 'clsCloseButton',

            type: 'button',

            name: 'Close'

        };

        cellNode.appendChild(createProxyButton(closeNode,proxyIndex++));

    } 

}



cleanRadioAndCheckBoxes = function(buttons)

{

    var cName = "";

    for (var i=0; i<buttons.length; i++)

    {

        cName = buttons[i].className;

        if (cName.indexOf('clsNoBorderInput')==-1)

        {

            buttons[i].className = cName+' clsNoBorderInput';

        }

    }

}

proxySpellChecker = function(targetNode)

{

    var boxNode = $('OldSpellCheckOn');

    // Proxy the node only if it's visible (it could be hidden)

    if (boxNode && (boxNode.type == 'checkbox'))

    {

        var proxyLabel = document.createElement('label');

        var proxyBox = document.createElement('input');

        proxyBox.setAttribute('id', 'SpellCheckOn');

        proxyBox.setAttribute('name', 'SpellCheckOn');

        proxyBox.setAttribute('type', 'checkbox');

        proxyBox.setAttribute('value', 1);

        proxyBox.className = 'clsNoBorderInput';

        proxyBox.onclick = function(){

            var o = $('OldSpellCheckOn');

            if (o)

                o.checked = this.checked;

        };

        proxyLabel.appendChild(proxyBox);

        proxyLabel.appendChild(document.createTextNode('Check Spelling'));

        targetNode.appendChild(proxyLabel);

        // Reflect original's status

        proxyBox.checked = boxNode.checked;

    }

}

			

/**

 * Helper method. Generate a proxy DOM node out of an original button

 * @param buttonNode   (node). Required. The original button DOM node

 * @return node

 */

createProxyButton = function(buttonNode,index)

{



    /*

	 Buttons must be styled to look as links. 

	 Since this can be tricky accross browsers, we wrap a <span> around the buttons 

	*/

	

    // Use trimmed value for text

    var buttonText = buttonNode.value.replace(/^\s+|\s+$/g, '');

    var newButtonText = buttonText;

    if (buttonText == 'OK' || buttonText == 'Finish')

        newButtonText = 'Save';    



    var proxyContainer = document.createElement('span');

    proxyContainer.id = 'proxyButton' + index; 

    if (buttonNode.title)

        proxyContainer.title = buttonNode.title;

    proxyContainer.className = buttonNode.className;  

    if ((buttonText == 'Cancel' || buttonText == 'Close') && 

				(buttonNode.className.indexOf('clsPushButton') >= 0 || buttonNode.className.indexOf('clsCancelButton') >= 0 || buttonNode.className.indexOf('clsCloseButton') >= 0)){

        proxyContainer.className = 'cls'+buttonText+'Button';

    }



    var proxyBox = document.createElement('input');

    if (buttonNode.type == 'submit' && typeof buttonNode.click == 'function'){

        proxyBox.setAttribute('type', 'button');

    }

    else{

        proxyBox.setAttribute('type', buttonNode.type);

    }   

    proxyBox.setAttribute('name', buttonNode.name);

    proxyBox.setAttribute('value', newButtonText);

    proxyBox.setAttribute('id', buttonText);



    if (newButtonText=='Cancel' || newButtonText=='Close')

    {

        proxyContainer.onclick = function()

        {

            if (typeof buttonNode.click == 'function' || typeof buttonNode.click == 'object')

            {

                buttonNode.click();

            }

            else

                top.commonspot.lightbox.closeCurrent();

        }

    }   

    else   

    {

        proxyContainer.onclick = function()

        {

            if (typeof buttonNode.click == 'function' || typeof buttonNode.click == 'object')

            {

                buttonNode.click();

            }	

            return false;

        }

    }		

    proxyBox.onmouseover = function()

    {

        this.style.textDecoration = 'underline';

        return false;

    }

    proxyBox.onmouseout = function()

    {

        this.style.textDecoration = 'none';

        return false;

    }	

    proxyContainer.appendChild(proxyBox);

    return proxyContainer;

}

/**

* Helper method.    Return index of an element in an array NOT case-sensitive.

* @param _this      Required. Array

 * @param x          Required. key

* @return index      

*/

arrayIndexOf = function(_this,x) 

{

    for(var i=0;i<_this.length;i++) 

    {

        if (_this[i].toLowerCase()==x.toLowerCase()) 

            return i;

    }

    return-1;

}   	

		



if (typeof(onLightboxResize) == "undefined")

{

	

    /**

	 * Hook that gets called by lightbox whenever the dialog gets resized

	 * @param w         (int). Required. Width

	 * @param h         (int). Required. Height

	 */

    onLightboxResize = function(w, h)

    {

        // Remove margins from the dialog's body

        document.body.style.margin = 0;

        document.body.style.padding = 0;

        var rootDiv = document.getElementById('cs_commondlg');

        if (rootDiv)

        {

            main_table = document.getElementById('MainTable');

            if (main_table && main_table.style)

            {

                main_table.style.width = (w-35)+'px';

                rootDiv.style.width = (w-10)+'px';

                main_table.style.height = (h -45) + 'px';

                main_table.style.marginTop = 0;

                rootDiv.style.marginTop = '10px';

                rootDiv.style.height = (h -37) + 'px';

            }	

				

            // Add scrollbars to the main box

            rootDiv.style.overflow = 'auto';

        }

    }



}

    /*

JavaScript routines to resolve references for windows inside lightbox

*/



getOpener = function(ignoreOpenerProperty)

{

    if ((self != top) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'))

    {

        return top.commonspot.lightbox.getOpenerWindow(ignoreOpenerProperty);

    }

    else

    {

        return self.opener;

    }

}





getRTEopener = function(FrameName)

{

    // Grab the window object out of the RTE's iframe

    if (!FrameName)

        FrameName = 'WebEdit';

    var fr = null;

    var stackLen = 0;

    if ((self != top) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'))

        stackLen = top.commonspot.lightbox.stack.length;

    for (var i=stackLen-1; i>=0; i--)

    {

        if(top.commonspot.lightbox.stack.length == 1)

            fr = top.commonspot.lightbox.getOpenerWindow().document.getElementById(FrameName);

        else

            fr = top.commonspot.lightbox.stack[i].getWindow().document.getElementById(FrameName);

        if (fr)

            return fr.contentWindow;

    }

    return fr;

}



hasLightbox = function()

{

    return ((top != self) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'));

}



var cleanHTMLWnd;

var spellcheckerWnd;

getCleanHTMLTarget = function(dlgLoader)

{

    var url = dlgLoader ? dlgLoader + '?csModule=/commonspot/dhtmledit/clean_dhtml_fields' : '/commonspot/dhtmledit/clean_dhtml_fields.cfm';



    if((top != self) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'))

    {

        var frName;

        for (var i=0; i<top.commonspot.lightbox.stack.length; i++)

        {

            frName = top.commonspot.lightbox.stack[i].getFrameName();

            if (frName == 'cleanHTML')

                return frName;

        }	

        var lightboxTarget = openEmptyLightBox(url, null, 'cleanHTML');

        return top.commonspot.lightbox.getFrameName();

    }

    else

    {

        if (!cleanHTMLWnd || cleanHTMLWnd.closed)

            cleanHTMLWnd = newWindow( 'cleanHTML', url);

        return 'cleanHTML';	

    }

	

}



getSpellCheckTarget = function(dlgLoader)

{

    var url = dlgLoader ? dlgLoader + '?csModule=/commonspot/spellchk/introscreen' : '/commonspot/spellchk/introscreen.cfm';



    if((top != self) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'))

    {

        // Open an empty lightbox

        var frName;

        for (var i=0; i<top.commonspot.lightbox.stack.length; i++)

        {

            frName = top.commonspot.lightbox.stack[i].getFrameName();

            if (frName == 'spellchecker')

                return frName;

        }	

        var lightboxTarget = openEmptyLightBox(url, null, 'spellchecker');

        return top.commonspot.lightbox.getFrameName();

    }

    else

    {

        if (!spellcheckerWnd || spellcheckerWnd.closed)

            spellcheckerWnd = newWindow( 'spellchecker', url);

        return 'spellchecker';	

    }

	

}



closeEmptyChildDialogs = function(frameNameList)

{

    var frameNameList = frameNameList ? frameNameList : 'cleanHTML,spellchecker';

    if ((top != self) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'))

    {

        var win;

        for (var i=top.commonspot.lightbox.stack.length-1; i>=0; i--)

        {

            win = top.commonspot.lightbox.stack[i];

            frName = win.getFrameName();

            if (frameNameList.indexOf(frName) >= 0)

                win.close();

        }

    }	

}



closeCleanHTMLWindows = function()

{

    closeEmptyChildDialogs('cleanHTML');

    /*

	if (self.children)

	{

		for(i=0;i<self.children.length;i++)

			self.children[i].close();

	}

	*/

}



closeSpellCheckWindows = function()

{

    closeEmptyChildDialogs('spellchecker');

}



openEmptyLightBox = function(url, hideClose, name, customOverlayMsg)

{

    var lightboxTarget;	

    var url = url ? url : null;

    var hideClose = hideClose ? hideClose : null;

    var name = name ? name : null;

    var customOverlayMsg = customOverlayMsg ? customOverlayMsg : null;

    // If we are inside a lightbox

    if ((top != self) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'))

    {

        // Open an empty lightbox

        top.commonspot.lightbox.openDialog(url, hideClose, name, customOverlayMsg, null, null, true);

		

        lightboxTarget = top.commonspot.lightbox.getFrameName();

        // Form's target now must be the lightbox, not a new window

        return lightboxTarget;

    }

    else

        return;

}



// returns contentWindow of admin-frame

getAdminWindow = function()

{

    var win = null;

    if ((top != self) && (typeof(top.commonspot)!= 'undefined') && (typeof(top.commonspot.lightbox)!= 'undefined'))

        win = top.commonspot.lightbox.getAdminWindow();

    return win;	

}





/**

 * Generic alert to user.

 * see commonspot.dialog.client.showHTMLDialog for supported options

 * msg can be text, or can be an array, in which case it'll be rendered as an html list

 */

if ((top != self) && (typeof(top.commonspot)!== 'undefined') && (typeof(top.commonspot.lightbox)!== 'undefined'))

{

    if (typeof top.commonspot.dialog === 'undefined')

        top.commonspot.dialog = {};

    if (typeof top.commonspot.dialog.client === 'undefined')

    {

        top.commonspot.dialog.client = {};



        top.commonspot.dialog.client.alert = function(msg, options)

        {

            var html;

            if(msg.constructor == String)

                html = msg;

            else // assumed to be an array

            {

                if(msg.length === 1)

                    html = msg[0];

                else

                {

                    html = "<ul>";

                    for(var i = 0; i < msg.length; i++)

                        html += "<li>" + msg[i] + "</li>";

                    html += "</ul>";

                }

            }

            html = html.replace(/\n/g, '<br />');

            top.commonspot.dialog.client.showHTMLDialog(html, options, 'alert');

        }



        /*

		 * create a lightboxed dlg containing the passed html

		 */

        top.commonspot.dialog.client.showHTMLDialog = function(html, options, dialogType)

        {

            var options = options || {};

            var defaultOptions =

			{

			    title: "CommonSpot Message",

			    subtitle: "",

			    helpId: "",

			    width: 500,

			    height: 600,

			    style: '',

			    useDefaultStyles: true,

			    maximize: false,

			    hideClose: false,

			    hideHelp: true,

			    hideReload: true

			};

            top.commonspot.util.merge(options, defaultOptions);



            dialogType = dialogType || 'dialog';



            var style = options.style;

            if(options.useDefaultStyles)

                style = top.commonspot.dialog.client.getHTMLDialogDefaultStyles() + style;



            html = top.commonspot.dialog.client.getHTMLDialogHTML(html, style, options.title, options);



            // openDialog(url, hideClose, name, customOverlayMsg, dialogType, opener, hideHelp)

            var dlgObj = top.commonspot.lightbox.openDialog("about:blank", options.hideClose, null, top.commonspot.lightbox.NO_OVERLAY_MSG, dialogType, null, options.hideClose, options.hideReload);

            var lightboxWindow = dlgObj.getWindow();

            lightboxWindow.document.write(html);

            lightboxWindow.document.close();



            top.commonspot.lightbox.initCurrent

			(

				options.width,

				options.height,

				{

				    title: options.title, subtitle: options.subtitle, helpId: options.helpId,

				    close: options.close, reload: options.reload, maximize: options.maximize

				},

				'',

				true

			);



            var dt = lightboxWindow.document.getElementById("dialogContainer");

            var w = Math.max(dt.clientWidth + 30, 350);

            var h = Math.max(dt.clientHeight, 70) - ((options.hideClose && !options.customButtons) ? 30 : 0);

            top.commonspot.lightbox.resizeCurrent(w, h);

            // first wanted this to autosize, to measure it, but now want it full width so close btn is far right

            lightboxWindow.document.getElementById("dialogContainer").style.width = "100%";

        };



        top.commonspot.dialog.client.getHTMLDialogDefaultStyles = function()

        {

            var style =

	'body {font-family: Verdana,Arial,Helvetica,sans-serif; margin: 0; overflow: scroll; text-decoration: none; font-size: 11px;}\n\

            a:active {text-decoration: underline; color: #1D2661;}\n\

            a:hover {text-decoration: underline;color: #003366;}\n\

            a {color: #1D2661;text-decoration: underline;}\n\

            a:visited {	text-decoration: underline;color: #1D2661;}\n\

	#content {margin: 15px 11px; overflow: auto; font-size: 11px;}\n\

	#innerdialogContainer {background-color:#F0F0F0;border-bottom:1px solid #999999;border-top:1px solid #999999;margin-top:10px;}\n\

	#htmlDlgTableCell h2 {font-size: 11px; margin: 15px 0 8px;}\n\

	#htmlDlgTableCell h2:first-child {margin-top: 0;}\n\

	#htmlDlgTableCell p {margin: 0 0 8px; padding: 0;}\n\

	#htmlDlgTableCell ul {margin: 0 0 1em 1em; padding: 0;}\n\

	#htmlDlgTableCell li {margin: 5px;}\n\

	#htmlDlgTableCell dl {margin: 0 0 1em;}\n\

	#htmlDlgTableCell dt {color: #013466; font-weight: bold; margin: 5px 0 0;}\n\

	#htmlDlgTableCell dd {margin: 0 0 0 1.5em;}\n\

	#dialogContainer #dialogFooter {display: block; font-weight: bold; height: 28px; line-height: 28px; margin: 5px 0 0; padding: 0 1px; text-align: right; font-size: 11px;}\n\

	#htmlDlgTableCell .dumpTable caption {font-size: 8pt; font-weight: bold;}\n\

	#htmlDlgTableCell .dumpTable td {border: 1px solid #ccc; font-size: 8pt; padding: 1px;}\n\

            ';

            return style;

        };



        top.commonspot.dialog.client.getHTMLDialogHTML = function(alertHTML, styleHTML, title, options)

        {

            var btnHTML = '';

            var linkID, linkClass, linkOnClick, linkObj, linkAccessKey, linkText, linkObj;

            var accessKeyHTML = '';

            btnHTML += options.hideClose ? '' : '<a id="closeButton" accesskey="C" href="javascript:;" onclick="top.commonspot.lightbox.closeCurrent()">Close</a>';

            if (options.customButtons)

            {

                for (var i=0; i<options.customButtons.length; i++)

                {

                    linkObj = options.customButtons[i];

                    linkID = linkObj.id ? linkObj.id : 'okButton';

                    linkOnClick = linkObj.onclick ? linkObj.onclick : '';

                    linkText = linkObj.linkText ? linkObj.linkText : '';

                    if (linkObj.accessKey)

                        accessKeyHTML = ' accesskey="' + linkObj.accessKey + '"';

                    if (linkOnClick != '' && linkID != '' && linkText != '')

                        btnHTML += '<a id="' + linkID + '"' + accessKeyHTML + ' href="javascript:;" onclick="' + linkOnClick + '">' + linkText + '</a>';

                }

            }

            var html =

				'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' +

				'<html>' +

				'<head>' +

					'<link href="/commonspot/dashboard/css/dialog.css" rel="stylesheet" type="text/css" id="dialogcss" />' +

					'<style>' + styleHTML + '</style>' +

					(title ? '<title>' + title + '</title>' : '') +

				'</head>' +

				'<body>' +

					'<table id="dialogContainer">' +

						'<tr><td>' +

							'<table id="innerdialogContainer" width="100%">' +

								'<tr>' +

									'<td id="htmlDlgTableCell">' +

										'<div id="content">' + alertHTML + '</div>' +

									'</td>' +

								'</tr>' +

							'</table>' +

						'</td></tr>' +

						'<tr><td>' +

							'<div id="dialogFooter">' +

								btnHTML +

							'</div>' +

						'</td></tr>'

            '</table>' +

        '</body>' +

        '</html>';

            return html;

        };

    }

}	 
