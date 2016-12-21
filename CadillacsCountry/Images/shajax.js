/**
 * @version		$Id: shajax.js 54 2008-12-31 16:17:52Z shumisha $
 * @package		sh404SEF
 * @copyright	Copyright (C) 2008 Yannick Gaultier. All rights reserved.
 * @license		GNU/GPL, see LICENSE.php
 * Joomla! is free software. This version may have been modified pursuant
 * to the GNU General Public License, and as distributed it includes or
 * is derivative of works licensed under the GNU General Public License or
 * other free or open source software licenses.
 * See COPYRIGHT.php for copyright notices and details.
 *
 * Based on Simple ajax by DeGraeve.com and others
 * 
 * For joomla usage:
 *	  1 - start with a basic working link : <a href="http://whatever.com/mypage"></a>
 *	  2 - Pick a name for this element, for instance : nextMonth
 *	  3 - Add to the link a class and a rel attribute, as follow :
 *				<a href="http://whatever.com/mypage" class="shajaxLinkNextMonth" rel="target_element"></a>
 *		  target_element is the name of html elemnt that needs to be replaced by the ajax call output
 *	  4 - find a loading gif somewhere and put it where you want (this one's great http://www.ajaxload.info/)
 *	  5 - set the shajaxProgressImage to the full <img> tag of your loader image
 *         shajaxProgressImage = '<img src="http://whatever.com/images/ajax-loader.gif" border="0"  style="vertical-align: middle" hspace="5"/>';
 *    6 - Somewhere on the page, create a span element to display the ajax loader image
 *    You have 2 options there : you can show a loader image for individual links, or a global one:
 *    If an element with an id="shajaxProgressNextMonth" is found, then it will be used
 *    If not found, the default one will used. The id of the default element can be set using the 
 *    defaultProgressElement global variable
 */  

var shajaxLiveSiteUrl = '';  // live site base url, to fix links that rely on the base tag
var shajaxProgressImage = '';  // must be initialized by user script
var defaultProgressElement = 'shajaxProgress';  // can be overriden by user script
var shajaxUrlMap = new Array();  // array holding mapping between non-ajax and ajax urls to call
/*
 * ajaxify links upon loading the DOM 
 */ 

/* Really technical stuff, better leave it to people who
 * know what they are doing ...
 *
*
 * (c)2006 Jesse Skinner/Dean Edwards/Matthias Miller/John Resig
 * Special thanks to Dan Webb's domready.js Prototype extension
 * and Simon Willison's addLoadEvent
 *
 * For more info, see:
 * http://www.thefutureoftheweb.com/blog/adddomloadevent
 * http://dean.edwards.name/weblog/2006/06/again/
 * http://www.vivabit.com/bollocks/2006/06/21/a-dom-ready-extension-for-prototype
 * http://simon.incutio.com/archive/2004/05/26/addLoadEvent
 * 
 *
 * To use: call addDOMLoadEvent one or more times with functions, ie:
 *
 *    function something() {
 *       // do something
 *    }
 *    addDOMLoadEvent(something);
 *
 *    addDOMLoadEvent(function() {
 *        // do other stuff
 *    });
 *
 */
 
addDOMLoadEvent = (function(){
    // create event function stack
    var load_events = [],
        load_timer,
        script,
        done,
        exec,
        old_onload,
        init = function () {
            done = true;

            // kill the timer
            clearInterval(load_timer);

            // execute each function in the stack in the order they were added
            while (exec = load_events.shift())
                exec();

            if (script) script.onreadystatechange = '';
        };

    return function (func) {
        // if the init function was already ran, just run this function now and stop
        if (done) return func();

        if (!load_events[0]) {
            // for Mozilla/Opera9
            if (document.addEventListener)
                document.addEventListener("DOMContentLoaded", init, false);

            // for Internet Explorer
            /*@cc_on @*/
            /*@if (@_win32)
                document.write("<script id=__ie_onload defer src=//0><\/scr"+"ipt>");
                script = document.getElementById("__ie_onload");
                script.onreadystatechange = function() {
                    if (this.readyState == "complete")
                        init(); // call the onload handler
                };
            /*@end @*/

            // for Safari
            if (/WebKit/i.test(navigator.userAgent)) { // sniff
                load_timer = setInterval(function() {
                    if (/loaded|complete/.test(document.readyState))
                        init(); // call the onload handler
                }, 10);
            }

            // for other browsers set the window.onload, but also execute the old window.onload
            old_onload = window.onload;
            window.onload = function() {
                init();
                if (old_onload) old_onload();
            };
        }

        load_events.push(func);
    }
})();

/* Now my own stuff */
addDOMLoadEvent( shAjaxifyLinks); 
 
/**
 * Make ajax links degrades
 */
function shAjaxifyLinks(elementId) {
	var container = null;
	if (elementId) {
	  container = document.getElementById( elementId);
	}
	var links = null;
	if (container) {
	  // restrict search to only part of the document
	  links = container.getElementsByTagName('a');
	} else  {
	  links = document.getElementsByTagName('a');
	} 
	if (links) {
	 	// search for links with class=shajaxLinkXXXXX 
	 	var aClass = '';
	 	var aRel ='';
		for(var i=0;i<links.length;i++){
			aClass = links[i].className;
			aRel = links[i].rel;
			if (aClass && aRel && aClass.substr(0, 10)=='shajaxLink') {
				links[i].name='#'+aClass;
				// this is one of our links. insert an onclick handler
      			links[i].onclick=function() {
      				// find about the link : does it map to something else
      			    var aLink = this.href;
      			    if (typeof( shajaxUrlMap) != 'undefined') {
      			    	if ( shajaxUrlMap[this.className]) {
      			      		aLink = shajaxUrlMap[this.className];
      			      }
      			    } 
      				// make sure we have an absolute link
					if (shajaxLiveSiteUrl && aLink.substr( 0, 7) != 'http://' && aLink.substr( 0, 9) == 'index.php') {
						// prepend live site url
						aLink = shajaxLiveSiteUrl + aLink;
					}
      				shajax( aLink, this.rel, 'format=raw&tmpl=component', 'shajaxProgress'+this.className.substr(10));
      				// and remove the actual link	
        			this.href='#' + this.className;
        			// return false, otherwise don't work when base tag is wrong
        			return false;
        		}
      		}
    	}
	}
}

function GetXmlHttp() {
  var xmlhttp = false;
  if (window.XMLHttpRequest)
  {
    xmlhttp = new XMLHttpRequest()
  }
  else if (window.ActiveXObject)// code for IE
  {
    try
    {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP")
    } catch (e) {
      try
      {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP")
      } catch (E) {
        xmlhttp=false
      }
    }
  }
  return xmlhttp;
}


/**
 */
function shajax(targetUrl, elementId, params, progress) {
    var xmlHttp = new GetXmlHttp();
    
	// identify the progress image element
	if (progress && !document.getElementById( progress)) {
		progress = defaultProgressElement;
	}
    if (xmlHttp) {
    	showProgress( progress, true);
    	var connector = '&';
    	if (targetUrl.indexOf( '?') == -1) {
    	  connector = '?';
    	}
    	xmlHttp.open('GET', targetUrl + connector + params, true);
        if (typeof(xmlHttp.setRequestHeader)!="undefined") {
        	xmlHttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        }
    	xmlHttp.onreadystatechange = function() {
        	if (xmlHttp.readyState == 4) {
            	showProgress( progress, false);
            	if (xmlHttp.status==200) {
            		document.getElementById(elementId).innerHTML = xmlHttp.responseText;
            		// need to redo the links
            		// but first must update the url map
        			var shMap = document.getElementById('shajaxRebuildUrlMap'+elementId);
        			var html;
        			if (shMap) {
        			  html = shMap.innerHTML;
        			}
        			// remove script tags in returned html (must be case insensitive for IE)
        			if (html) {
        			  html = html.replace( new RegExp("<script>", 'i'), '');
        			  html = html.replace( new RegExp("</script>", 'i'), '');
        			  // eval that code : it will reset to urlmap to new values, as we have changed month
        			  eval( html);
        			}  
        			// now we can redo the links
            		shAjaxifyLinks(elementId);
            	} 
        	}
    	}
    	xmlHttp.send( null);
    }
}

/**
 * Progress div may be simply surrounding an existing element of the page
 * This element will be replaced by the progress gif, and then restored afterward 
 * state = true : visible, state = false : invisible 
 */ 
function showProgress( progress, state) {
  
  if (typeof this.save == 'undefined') {
		this.save = '';
	}
  if (state) {
    this.save = document.getElementById(progress).innerHTML;
    document.getElementById(progress).innerHTML = shajaxProgressImage;
  } else {
    document.getElementById(progress).innerHTML = this.save;
  }
}
