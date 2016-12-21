// (c) 2006 
function catSetSelectedItem(menuid) {
    var host = document.location.host;
	var pageurl = document.location.href.substring(document.location.href.indexOf(host)+host.length);

	var ie = false;
	var detect = navigator.userAgent.toLowerCase();	
	if (detect.indexOf('msie') > 0) ie = true;
		
	var menus = document.getElementById(menuid);
	var tds = menus.getElementsByTagName("td");

	if (!setSelected(tds, pageurl, ie)) {
		// iterate through all sub-menus
		var masterdiv = document.getElementById(menuid+"_divs");
		// old menus don't have this
		if (masterdiv) {
			var divs = masterdiv.getElementsByTagName("div");
			for (var i = 0; i < divs.length; i++) {
				tds = divs[i].getElementsByTagName("td");
				if (setSelected(tds, pageurl, ie))
					break;
			}
		}
	}
}

function getInternetExplorerVersion() {
    var rv = -1; // Return value assumes failure.
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat(RegExp.$1);
    }
    return rv;
}

function setSelected(tds, pageurl, ie) {
	var itemurl;
	var queryIndex;
	var pos, po2;
	var parentId;

	// get all items td's
	for (var i = 0; i < tds.length; i++)
	{
		if (tds[i].getAttribute("onclick") != null)
		{
			itemurl = tds[i].getAttribute("onclick").toString();
			pos = itemurl.indexOf("=");		
			if (pos != -1) {
				pos2 = itemurl.indexOf(';');		
				itemurl = itemurl.substring(pos+2,pos2-1);					

				//queryIndex = itemurl.indexOf("?");
				//if (queryIndex != -1)
				//	itemurl = itemurl.substring(0,queryIndex);
					
				if (itemurl.toLowerCase() == pageurl.toLowerCase())
				{
				    parentId = ProcessTD(tds[i], ie);
                    
                    // set all parents selected als
                    var _continue = true;
                    var i = 0;
                    while (_continue) {
                        i++;
                        if (parentId.length > 0) 
                            parentId = ProcessTD(document.getElementById(parentId), ie);
                        else
                            _continue = false;
                        if (i>10) _continue = false; // safety
                    }
				    return true;
				}
			}
		}
	}
	return false;
}

function ProcessTD(td, ie) {

	var eventstr;
	var selcss;
	var selimg;
	var parentId;
	
	// get selected css/image values
	selcss = td.getAttribute("selcss");
	selimg = td.getAttribute("selimg");
	parentId = td.getAttribute("pid");
	
	// change onmouseout to both the selimage (if there's one) and selcss
	if (selcss != null) {
	    if (ie) {
	        var ver = getInternetExplorerVersion();
	        if (ver > -1) {
                if (ver >= 8.0)
                    td.setAttribute("class", selcss);
                else
                    td.setAttribute("className", selcss);
	        }
	    } else
	        td.setAttribute("class", selcss);					
	}
	if (selimg != null)
		td.style.backgroundImage = "url("+selimg+")";
		
	// remove onmouseover events for style changes e.g. class or bg image
	// menu to be selected regardless of whether the mouse is over/out of the item
	// we however need to keep mouseover/out for opening/closing a menu's child menu
	eventstr = td.getAttribute("onmouseover").toString();
	pos = eventstr.indexOf("catDynMenu");
	if (pos != -1) {
		pos2 = eventstr.indexOf(';',pos);		
		td.onmouseover = Function(eventstr.substring(pos,pos2+1)); 
		// this method does not work in IE, must have Function() around it
		//td.setAttribute("onmouseover",eventstr.substring(pos,pos2+1),0);
	}
	else {
		td.removeAttribute("onmouseover"); // ie
		td.onmouseover = null; // mozilla
	}
	eventstr = td.getAttribute("onmouseout").toString();
	pos = eventstr.indexOf("catDynMenu");
	if (pos != -1) {
		pos2 = eventstr.indexOf(';',pos);
		td.onmouseout = Function(eventstr.substring(pos,pos2+1)); 
	}
	else {
		td.removeAttribute("onmouseout"); // ie
		td.onmouseout = null; // mozilla			
	}	
	
	if (parentId && td.id != parentId)
	    return parentId;
	else
	    return '';
}