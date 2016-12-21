//
// Used to add multiple functions to the window.onload event.
// - http://www.sitepoint.com/blog-post-view.php?id=171578
//
function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      oldonload();
      func();
    }
  }
}

// This function should be called when the user clicks a link, dialog, or button
// on the page.  It provides a little visual feedback that their request is 
// being processed.  If its a dialog and the user will stay on the same page
// then the visual cues will be removed after a delay.
function busy(p) {
	document.body.style.cursor='wait';

	window.status='Loading ... please wait ...';

	if (!p)
		setTimeout('notbusy()',1000);
}

// Called after the busy() function.  Will remove the visual processing cues.
function notbusy() {
	window.status='';
	document.body.style.cursor='default';
}

function kdRedirect(pUrl) {
	window.location=pUrl;
}

function kdPopup(pUrl,pName,pWidth,pHeight,pScrollbars) {

	var vWin2;
	var vLeft = 0;
	var vTop  = 0;
			
	if (!pScrollbars || pScrollbars == 0) 
		pScrollbars='';
	else
		pScrollbars=',scrollbars';
	
	vLeft = (screen.availWidth/2) - (pWidth/2);
	vTop  = (screen.availHeight/2) - (pHeight/2);
	
	vWin2 = window.open(pUrl,pName,'width=' + pWidth + ',height=' + pHeight + ',left=' + vLeft + ',top=' + vTop + ',resizable,dependent,alwaysRaised' + pScrollbars); 
	vWin2.opener = self;
	//vWin2.focus(); 
	
	return false;
}

function kdDialog(pUrl,pName,pWidth,pHeight) {

	var vLeft = 0;
	var vTop  = 0;
	var ie	  = document.all&&navigator.userAgent.indexOf("Opera")==-1
	
	// cookied values set by the user
	var vWidth = getCookie("dialogWidth");
	var vHeight= getCookie("dialogHeight");
	
	// defaults
	if (vWidth == null) vWidth =725;
	if (vHeight== null) vHeight=420;
	
	if (!pName) {
		if (typeof(kdSiteName)=='undefined')
			kdSiteName='General';
			
		kdSiteName = kdSiteName.replace(/\./g,'_');

		pName=kdSiteName;
	}

	// custom sizes?
	if (!pWidth)  pWidth =vWidth;
	if (!pHeight) pHeight=vHeight;
	
	// make sure the dialog isn't too big
	if ( (screen.availWidth - pWidth) < 100)
		pWidth = screen.availWidth-100;
	if ( (screen.availHeight - pHeight) < 100)
		pHeight = screen.availHeight-100;
		
	vLeft = (screen.availWidth/2) - (pWidth/2);
	vTop  = (screen.availHeight/2) - (pHeight/2);

	if (ie) 
		vScrollbars='';
	else
		vScrollbars=',scrollbars';
				
	var vDlg = window.open(pUrl,pName,'width=' + pWidth + ',height=' + pHeight + ',left=' + vLeft + ',top=' + vTop + ',resizable' + vScrollbars); 

	//vDlg.resizeTo(pWidth,pHeight);			
	//vDlg.moveTo(vLeft,vTop);
	
	vDlg.opener = self;
	
	return false;
}

function kdHelp(pRoot,pLocation,pTopic) {
	var vUrl='';

	if (pLocation != '' && pTopic != '')
		vUrl=pRoot + 'Help/dialogs.cfm?dialog=Help&Location=' + escape(pLocation) + '&Topic=' + escape(pTopic);
	else
		vUrl=pRoot + 'Help/dialogs.cfm';

	return kdPopup(vUrl,'KDHelp',600,400,0);	
}	
	
function kdGetOffset(el, which) {
    // Function for IE to calculate position of an element.
	
    var amount = el["offset"+which] 
	
    if (which=="Top")
      amount+=el.offsetHeight
	if (which=="Left")
	  amount+=el.offsetWidth
	  
    el = el.offsetParent
	
    while (el!=null) {
      amount+=el["offset"+which]
      el = el.offsetParent
    }
    return amount
 }

function toggleObject(objectId) {
	var o=getStyleObject(objectId)
	
	if (o) {
		if (o.style.display == 'none')
			o.style.display='';
		else
			o.style.display='none';
	}
}

function toggleFolder(objectID,imageID,folderOpen,folderClosed) {

		var obj = getStyleObject(objectID);
		var img = getStyleObject(imageID);

		if (obj.style.display == 'block'){
			obj.style.display = 'none';
			if(img){
				if(!folderClosed){
					img.src = 'Images/icons-small/folder-closed.gif';
				} else {
					img.src = folderClosed;
				}					
			}
		}else{
			obj.style.display = 'block';
			if(img){
				if(!folderOpen){
					img.src = 'Images/icons-small/folder-open.gif';
				} else {
					img.src = folderOpen;
				}					
			}
		}
		
		return false;
}

function toggleLayer(objectID,layerName,imgDir,imgPrefix) {
		if (imgPrefix == null) imgPrefix='layer-';
		
		imageID = 'img' + objectID
		var obj = getStyleObject(objectID);
		var img = getStyleObject(imageID);

		if (obj.style.display == 'block') {
			obj.style.display = 'none';
			if(img){
				img.src = imgDir + imgPrefix + 'max.gif';
				img.alt = 'Display ' + layerName
			}
			return 0;
		}
		else {
			obj.style.display = 'block';
			if(img){
				img.src = imgDir + imgPrefix + 'min.gif';
				img.alt = 'Hide ' + layerName
			}
			return 1;
		}
}

function getStyleObject(objectId) {
    // cross-browser function to get an object given its id
    if(document.getElementById && document.getElementById(objectId)) {
		// W3C DOM
		return document.getElementById(objectId);
    } 
	else if (document.all && document.all(objectId)) {
		// MSIE 4 DOM
		return document.all(objectId);
    } 
	else if (document.layers && document.layers[objectId]) {
		// NN 4 DOM.. note: this won't find nested layers
		return document.layers[objectId];
    } 
	else {
		return false;
    }
} 

function ltrim(s){
	return s.replace( /^\s*/, "" )
}

function rtrim(s){
	return s.replace( /\s*$/, "" );
}

function trim(s){
	return rtrim(ltrim(s));
}	

function setCookie (cookieName, cookieValue, path, expires, domain, secure) {
	document.cookie =  escape(cookieName) + '=' + escape(cookieValue) + (expires ? '; EXPIRES=' + expires.toGMTString() : '') + (path ? '; PATH=' + path : '')
    //+ (domain ? '; DOMAIN=' + domain : '')
    //+ (secure ? '; SECURE' : '');
}
function getCookie (cookieName)	{
	var cookieValue = null;
	var posName = document.cookie.indexOf(escape(cookieName) + '=');
	
	if (posName != -1)	{
		var posValue = posName + (escape(cookieName) + '=').length;
		var endPos = document.cookie.indexOf(';', posValue);

		if (endPos != -1)
			cookieValue = unescape(document.cookie.substring(posValue,endPos));
		else
			cookieValue = unescape(document.cookie.substring(posValue));
	}
	return cookieValue;
}

// to support section 508 we have this function which traps the "enter" key
// so the click event is only called once.
function fireClick(obj){
	// 13 is the keycode for the "enter" key.  0 is the key code for the click.
	if (event.keyCode != 13){
		obj.click();
	}
}


// the following two functions help act as "input masks" on fields to prevent erroneous data entry
// just have them called during the onKeyPress event of the control.
function forceNumeric(){
	//allows numeric values and decimal points(01234567890.)
	if ( ((event.keyCode > 47) && (event.keyCode < 58)) || (event.keyCode == 46)) 
	  event.returnValue = true;
	else
	  event.returnValue = false;
}

function forceDate(){
	//allows numeric values (code=48 - code=57) and the forward slash (code=47) and dash (code=45)  (01234567890/)
	if ((event.keyCode > 46) && (event.keyCode < 58) || (event.keyCode == 45)) 
	  event.returnValue = true;
	else
	  event.returnValue = false;
}
