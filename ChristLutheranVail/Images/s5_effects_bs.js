
// s5_boxslide copyrighted material by Shape5.com 2008 - current

// Title: Shape 5 Box Slide 
// URL: http://www.shape5.com
// Date: 02/08/2008
// Notes: This script is copyrighted material of shape5.com and may not be redistributed or resold by any means.


// Create PopupWindow objects
//
var s5_popup = new PopupWindow("s5_outerdiv_slide");
s5_popup.offsetY=20;

var clickk = "0";
big4c = 5;
big4 = 0;


function transition_big3()
{
			if (big4 <= 365)
			{
			window.setTimeout('increase2()',1);
			}  else { clickk = "1"; big4 = 365; }
	
}
function increase2()
{

	if (clickk == "0")
	{
	document.getElementById("s5_outerdiv_slide").style.width = big4 +'px';
	document.getElementById("s5_outerdiv_slide").style.height = big4 +'px';
	transition_big3()
	big4 = big4 + 30;

		
	} 


} 

function transition_big4()
{
			if (big4 > 5)
			{
			window.setTimeout('increase3()',1);

			


			}  else {  clickk = "0"; big4 = 0;  }
			
			
}

function increase3()
{
	if (clickk == "1")
	{
	document.getElementById("s5_outerdiv_slide").style.width = big4 +'px';
	document.getElementById("s5_outerdiv_slide").style.height = big4 +'px';
	transition_big4()
	big4 = big4 - 30;
	if (big4 <= 5)
			{	s5_popup.hidePopup('s5_anchor_slide');}
	}

} 










// Title: Shape 5 Box Slide 
// URL: http://www.shape5.com
// Date: 02/08/2008
// Notes: This script is copyrighted material of shape5.com and may not be redistributed or resold by any means.


// Create PopupWindow objects
//
var s5_popup3 = new PopupWindow("s5_outerdiv_slide2");
s5_popup3.offsetY=20;

var clickk3 = "0";
big4c3 = 5;
big43 = 0;


function transition_big33()
{
			if (big43 <= 365)
			{
			window.setTimeout('increase23()',1);
			}  else { clickk3 = "1"; big43 = 365; }
	
}
function increase23()
{

	if (clickk3 == "0")
	{
	document.getElementById("s5_outerdiv_slide2").style.width = big43 +'px';
	document.getElementById("s5_outerdiv_slide2").style.height = big43 +'px';
	transition_big33()
	big43 = big43 + 30;

		
	} 


} 

function transition_big43()
{
			if (big43 > 5)
			{
			window.setTimeout('increase33()',1);

			}  else {  clickk3 = "0"; big43 = 0;  }
			
			
}

function increase33()
{
	if (clickk3 == "1")
	{
	document.getElementById("s5_outerdiv_slide2").style.width = big43 +'px';
	document.getElementById("s5_outerdiv_slide2").style.height = big43 +'px';
	transition_big43()
	big43 = big43 - 30;
	if (big43 <= 5)
			{	s5_popup3.hidePopup('s5_anchor_slide2');}
	}

} 










// ===================================================================
// Author: Matt Kruse <matt@mattkruse.com>
// WWW: http://www.mattkruse.com/
// =========

/* SOURCE FILE: AnchorPosition.js */
function getAnchorPosition(anchorname){var useWindow=false;var coordinates=new Object();var x=0,y=0;var use_gebi=false, use_css=false, use_layers=false;if(document.getElementById){use_gebi=true;}else if(document.all){use_css=true;}else if(document.layers){use_layers=true;}if(use_gebi && document.all){x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);}else if(use_gebi){var o=document.getElementById(anchorname);x=AnchorPosition_getPageOffsetLeft(o);y=AnchorPosition_getPageOffsetTop(o);}else if(use_css){x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);}else if(use_layers){var found=0;for(var i=0;i<document.anchors.length;i++){if(document.anchors[i].name==anchorname){found=1;break;}}if(found==0){coordinates.x=0;coordinates.y=0;return coordinates;}x=document.anchors[i].x;y=document.anchors[i].y;}else{coordinates.x=0;coordinates.y=0;return coordinates;}coordinates.x=x;coordinates.y=y;return coordinates;}
function getAnchorWindowPosition(anchorname){var coordinates=getAnchorPosition(anchorname);var x=0;var y=0;if(document.getElementById){if(isNaN(window.screenX)){x=coordinates.x-document.body.scrollLeft+window.screenLeft;y=coordinates.y-document.body.scrollTop+window.screenTop;}else{x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;}}else if(document.all){x=coordinates.x-document.body.scrollLeft+window.screenLeft;y=coordinates.y-document.body.scrollTop+window.screenTop;}else if(document.layers){x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;}coordinates.x=x;coordinates.y=y;return coordinates;}
function AnchorPosition_getPageOffsetLeft(el){var ol=el.offsetLeft;while((el=el.offsetParent) != null){ol += el.offsetLeft;}return ol;}
function AnchorPosition_getWindowOffsetLeft(el){return AnchorPosition_getPageOffsetLeft(el)-document.body.scrollLeft;}
function AnchorPosition_getPageOffsetTop(el){var ot=el.offsetTop;while((el=el.offsetParent) != null){ot += el.offsetTop;}return ot;}
function AnchorPosition_getWindowOffsetTop(el){return AnchorPosition_getPageOffsetTop(el)-document.body.scrollTop;}


/* SOURCE FILE: PopupWindow.js */

function PopupWindow_getXYPosition(anchorname){var coordinates;if(this.type == "WINDOW"){coordinates = getAnchorWindowPosition(anchorname);}else{coordinates = getAnchorPosition(anchorname);}this.x = coordinates.x;this.y = coordinates.y;}
function PopupWindow_setSize(width,height){this.width = width;this.height = height;}
function PopupWindow_populate(contents){this.contents = contents;this.populated = false;}
function PopupWindow_setUrl(url){this.url = url;}
function PopupWindow_setWindowProperties(props){this.windowProperties = props;}
function PopupWindow_refresh(){if(this.divName != null){if(this.use_gebi){document.getElementById(this.divName).innerHTML = this.contents;}else if(this.use_css){document.all[this.divName].innerHTML = this.contents;}else if(this.use_layers){var d = document.layers[this.divName];d.document.open();d.document.writeln(this.contents);d.document.close();}}else{if(this.popupWindow != null && !this.popupWindow.closed){if(this.url!=""){this.popupWindow.location.href=this.url;}else{this.popupWindow.document.open();this.popupWindow.document.writeln(this.contents);this.popupWindow.document.close();}this.popupWindow.focus();}}}
function PopupWindow_showPopup(anchorname){this.getXYPosition(anchorname);this.x += this.offsetX;this.y += this.offsetY;if(!this.populated &&(this.contents != "")){this.populated = true;this.refresh();}if(this.divName != null){if(this.use_gebi){document.getElementById(this.divName).style.left = this.x + "px";document.getElementById(this.divName).style.top = this.y + "px";document.getElementById(this.divName).style.visibility = "visible";}else if(this.use_css){document.all[this.divName].style.left = (this.x) - ('200px');document.all[this.divName].style.top = this.y;document.all[this.divName].style.visibility = "visible";}else if(this.use_layers){document.layers[this.divName].left = this.x;document.layers[this.divName].top = this.y;document.layers[this.divName].visibility = "visible";}}else{if(this.popupWindow == null || this.popupWindow.closed){if(this.x0){this.x=0;}if(this.y<0){this.y=0;}if(screen && screen.availHeight){if((this.y + this.height) > screen.availHeight){this.y = screen.availHeight - this.height;}}if(screen && screen.availWidth){if((this.x + this.width) > screen.availWidth){this.x = screen.availWidth - this.width;}}var avoidAboutBlank = window.opera ||( document.layers && !navigator.mimeTypes['*']) || navigator.vendor == 'KDE' ||( document.childNodes && !document.all && !navigator.taintEnabled);this.popupWindow = window.open(avoidAboutBlank?"":"about:blank","window_"+anchorname,this.windowProperties+",width="+this.width+",height="+this.height+",screenX="+this.x+",left="+this.x+",screenY="+this.y+",top="+this.y+"");}this.refresh();}}
function PopupWindow_hidePopup(){if(this.divName != null){if(this.use_gebi){document.getElementById(this.divName).style.visibility = "hidden";}else if(this.use_css){document.all[this.divName].style.visibility = "hidden";}else if(this.use_layers){document.layers[this.divName].visibility = "hidden";}}else{if(this.popupWindow && !this.popupWindow.closed){this.popupWindow.close();this.popupWindow = null;}}}
function PopupWindow_isClicked(e){if(this.divName != null){if(this.use_layers){var clickX = e.pageX;var clickY = e.pageY;var t = document.layers[this.divName];if((clickX > t.left) &&(clickX < t.left+t.clip.width) &&(clickY > t.top) &&(clickY < t.top+t.clip.height)){return true;}else{return false;}}else if(document.all){var t = window.event.srcElement;while(t.parentElement != null){if(t.id==this.divName){return true;}t = t.parentElement;}return false;}else if(this.use_gebi && e){var t = e.originalTarget;while(t.parentNode != null){if(t.id==this.divName){return true;}t = t.parentNode;}return false;}return false;}return false;}
function PopupWindow_hideIfNotClicked(e){if(this.autoHideEnabled && !this.isClicked(e)){this.hidePopup();}}
function PopupWindow_autoHide(){this.autoHideEnabled = true;}
function PopupWindow_hidePopupWindows(e){for(var i=0;i<popupWindowObjects.length;i++){if(popupWindowObjects[i] != null){var p = popupWindowObjects[i];p.hideIfNotClicked(e);}}}
function PopupWindow_attachListener(){if(document.layers){document.captureEvents(Event.MOUSEUP);}window.popupWindowOldEventListener = document.onmouseup;if(window.popupWindowOldEventListener != null){document.onmouseup = new Function("window.popupWindowOldEventListener();PopupWindow_hidePopupWindows();");}else{document.onmouseup = PopupWindow_hidePopupWindows;}}
function PopupWindow(){if(!window.popupWindowIndex){window.popupWindowIndex = 0;}if(!window.popupWindowObjects){window.popupWindowObjects = new Array();}if(!window.listenerAttached){window.listenerAttached = true;PopupWindow_attachListener();}this.index = popupWindowIndex++;popupWindowObjects[this.index] = this;this.divName = null;this.popupWindow = null;this.width=0;this.height=0;this.populated = false;this.visible = false;this.autoHideEnabled = false;this.contents = "";this.url="";this.windowProperties="toolbar=no,location=no,status=no,menubar=no,scrollbars=auto,resizable,alwaysRaised,dependent,titlebar=no";if(arguments.length>0){this.type="DIV";this.divName = arguments[0];}else{this.type="WINDOW";}this.use_gebi = false;this.use_css = false;this.use_layers = false;if(document.getElementById){this.use_gebi = true;}else if(document.all){this.use_css = true;}else if(document.layers){this.use_layers = true;}else{this.type = "WINDOW";}this.offsetX = 0;this.offsetY = 0;this.getXYPosition = PopupWindow_getXYPosition;this.populate = PopupWindow_populate;this.setUrl = PopupWindow_setUrl;this.setWindowProperties = PopupWindow_setWindowProperties;this.refresh = PopupWindow_refresh;this.showPopup = PopupWindow_showPopup;this.hidePopup = PopupWindow_hidePopup;this.setSize = PopupWindow_setSize;this.isClicked = PopupWindow_isClicked;this.autoHide = PopupWindow_autoHide;this.hideIfNotClicked = PopupWindow_hideIfNotClicked;}















var leftclick = 0
var rightclick = 0
var big_hs = -slider_width
var bigc_hs = 0
function transition_big_hs() {
if (big_hs <= 0 || bigc_hs <= slider_width)
{
window.setTimeout('increaseleft()',5);
}
else {
leftclick = 1
big_hs = -slider_width;
bigc_hs = 0;
}
}


big4_hs = slider_width;
big4c_hs = -slider_width;
function transition_big4_hs() {
if (big4_hs <= slider_width || big4c_hs < 0)
{
window.setTimeout('increaseleft()',5);
}
else {
rightclick = 0
big4_hs = slider_width;
big4c_hs = -slider_width;
}
}


function increaseleft() {
if (rightclick == 1) {		
	document.getElementById("s5_middlecontentbarcenter").style.left = big4c_hs +'px';
	document.getElementById("s5_middlecontentbarright").style.left = big4_hs +'px';
	transition_big4_hs()
	big4c_hs = big4c_hs + slider_width_div;
	big4_hs = big4_hs + slider_width_div;	
	} 	
	else {
				if (leftclick == 1) {
				   return false;
				}
				 else {
				document.getElementById("s5_middlecontentbarcenter").style.left = bigc_hs +'px';
				document.getElementById("s5_middlecontentbarleft").style.left = big_hs +'px';
				transition_big_hs()
				bigc_hs = bigc_hs + slider_width_div;
				big_hs = big_hs + slider_width_div;
				}
		}		
}





var big2_hs = slider_width
var big2c_hs = 0
function transition_big2_hs() {
if (big2_hs >= 0 || big2c_hs >= slider_width)
{
window.setTimeout('increaseright()',5);
}
else {
rightclick = 1
big2_hs = slider_width;
big2c_hs = 0;
}
}


big3_hs = 0;
big3c_hs = slider_width;
function transition_big3_hs() {
if (big3_hs >= -slider_width || big3c_hs >= 0)
{
window.setTimeout('increaseright()',5);
}
else {
leftclick = 0
big3_hs = 0;
big3c_hs = slider_width;
}
}

function increaseright(){
	if (leftclick == 1) {		
	document.getElementById("s5_middlecontentbarcenter").style.left = big3c_hs +'px';
	document.getElementById("s5_middlecontentbarleft").style.left = big3_hs +'px';
	transition_big3_hs()
	big3c_hs = big3c_hs - slider_width_div;
	big3_hs = big3_hs - slider_width_div;	
	} 
	else {
					if (rightclick == 1) {
						return false;
					}
					 else {
					document.getElementById("s5_middlecontentbarcenter").style.left = big2c_hs +'px';
					document.getElementById("s5_middlecontentbarright").style.left = big2_hs +'px';
					transition_big2_hs()
					big2c_hs = big2c_hs - slider_width_div;
					big2_hs = big2_hs - slider_width_div;
					}
		}
}





