//**PUT EVERYTHING AFTER THIS IF STATEMENT**
if (window.imodules_common_loaded == null) { //Load first time only
window.imodules_common_loaded = true;

window.loaded = false;

function imod_DebugWrite(s, i) {
	if (window.__DebugWrite)
		__DebugWrite(s, i);
}

if (! window.imod) var imod = {}; 
if (! imod.Fancy) imod.Fancy = {};
if (! imod.Fancy.Handlers) imod.Fancy.Handlers = {};
if (! imod.dom)	imod.dom = {}; //DOM manipulation
	
imod.Browser = {}; //browser related stuff like size, cookies, querystring
imod.Browser.Request = {};
imod.Form = {};
imod.Element = {};
imod.General = {};

imod.General.StringBuilder = function () {
	var Items = new Array();
	
	this.Append = Append;
	this.ToString = ToString;
	
	function Append() { //can pass as many strings as you like now
		for (var i = 0; i < arguments.length; i++)
			Items.push(arguments[i]);
	}
	
	function ToString() {
		return Items.join("");
	}
}

imod.Browser.ScreenWidth = function() {
	return screen.availWidth;
}

imod.Browser.ScreenHeight = function() {
	return screen.availHeight;
}

imod.Browser.ParseQuerystring = function() {
	var qs = {};
	var s = window.location.search.replace(/^\?/, "");
	var aryQS = s.split("&");
	for (var i = 0; i < aryQS.length; i++) {
		var aryPair = aryQS[i].split("=");
		qs[aryPair[0]] = aryPair[1];
	}
	return qs;
}
imod.Browser.Request.Querystring = imod.Browser.ParseQuerystring();
imod.Browser.Request.QueryString = imod.Browser.Request.Querystring;

imod.Browser.IE = (window.attachEvent != null);
imod.Browser.IE7 = false;
imod.Browser.IE6 = false;
if (imod.Browser.IE) {
	if (window.XMLHttpRequest)
		imod.Browser.IE7 = true;
	else
		imod.Browser.IE6 = true;
}

imod.Browser.GetWindowScroll = function(frm) {
	var oReturn = {"left":0, "top":0};
	var w = (frm || frm == 0) ? window.frames[frm] : window;
	var de = w.document.documentElement;
	var db = w.document.body;
	
	if (de && de.scrollLeft > 0)
		oReturn.left = de.scrollLeft;
	else
		oReturn.left = db.scrollLeft;
	if (de && de.scrollTop > 0)
		oReturn.top = de.scrollTop;
	else
		oReturn.top = db.scrollTop;
		
	return oReturn;
}

imod.Browser.ScrollWindow = function() {
	var left = null, top = null, frm = null;
	switch (arguments.length) {
		case 2:
			left = arguments[0];
			top = arguments[1];
			break;
		case 3:
			frm = arguments[0];
			left = arguments[1];
			top = arguments[2];
			break;
		default:
			var s = "No overload for ScrollWindow(";
			for (var i = 0; i < arguments.length; i++) {
				if (i > 0) s += ",";
				s += typeof(arguments[i]);
			}
			s += ")";
			throw new Error(s);
	}

	var w = (frm || frm == 0) ? window.frames[frm] : window;
	var de = w.document.documentElement;
	var db = w.document.body;
	
	if (left != null) {
		if (de) de.scrollLeft += left;
		db.scrollLeft += left;
	}
	if (top != null) {
		if (de) de.scrollTop += top;
		db.scrollTop += top;
	}
}

/*
imod.Browser.SetWindowScroll = function() {
	var left = top = frm = null;
	switch (arguments.length) {
		case 2:
			left = arguments[0];
			top = arguments[1];
			break;
		case 3:
			frm = arguments[0];
			left = arguments[1];
			top = arguments[2];
			break;
		default:
			var s = "No overload for SetWindowScroll(";
			for (var i = 0; i < arguments.length; i++) {
				if (i > 0) s += ",";
				s += typeof(arguments[i]);
			}
			s += ")";
			throw new Error(s);
	}

	var w = (frm) ? window.frames[frm] : window;
	var de = w.document.documentElement;
	var db = w.document.body;
	
	if (left != null) {
		if (de) de.scrollLeft = left;
		db.scrollLeft = left;
	}
	if (top != null) {
		if (de) de.scrollTop = top;
		db.scrollTop = top;
	}
}
*/

imod.Browser.GetWindowSize = function(frm) {
	var oReturn = {width:0, height:0};
	
	var w = (frm) ? window.frames[frm] : window;
	var de = w.document.documentElement;
	var db = w.document.body;

	if (w.innerWidth)
		oReturn.width = w.innerWidth;
	else if (de && de.offsetWidth > 0)
		oReturn.width = de.offsetWidth;
	else
		oReturn.width = db.offsetWidth;
		
	if (w.innerHeight)
		oReturn.height = w.innerHeight;
	else if (de && de.offsetHeight > 0)
		oReturn.height = de.offsetHeight;
	else
		oReturn.height = db.offsetHeight;

	return oReturn;
}

imod.dom.DisableSelect = function(o) {
	o.style.MozUserSelect = "none";
	o.onselectstart = function() { return false; };
	o.unselectable = "on";
}

imod.dom.ConfirmPageExit = function(sPrmMessage, prmConfirmDelegate) {
	var f = function(e) {
		if (window.event) e = window.event;
		var bDoIt = true;
		if (prmConfirmDelegate != null)
			bDoIt = prmConfirmDelegate();
		if (bDoIt) {
			e.returnValue = sPrmMessage.replace(/<br[^>]*>/gi, "\n");
			e.cancelBubble = true;
		}
	}
	imod.dom.AddHandler(window, "beforeunload", f);
}

imod.dom.PreventDefault = function(e) {
	if (e && e.preventDefault)
		e.preventDefault();
	else
		window.event.returnValue = false;
}

imod.dom.DisableMouseSelect = function(o) {
	o.style.MozUserSelect = "none";
	o.onselectstart = function() { return false; };
}

imod.dom.GetSender = function(e) {
	if (e && e.target)
		return e.target;
	if (window.event && window.event.srcElement)
		return window.event.srcElement;
	return null;
}

imod.dom.InsertAfter = function(oPrmInsert, oPrmAfter) {
	if (oPrmAfter.nextSibling) {
		oPrmAfter.parentNode.insertBefore(oPrmInsert, oPrmAfter.nextSibling);
	}
	else {
		oPrmAfter.parentNode.appendChild(oPrmInsert);
	}
}

imod.dom.GenerateId = function(sPrmRoot) {
	var sRoot = sPrmRoot;
	var sId = null;
	if (! sRoot)
		sRoot = "element";
	while (sId == null || imod.$(sId))
		sId = sRoot + Math.random().toString().replace(/\./gi, "");
	return sId;	
}

imod.dom.CenterElement = function(o) {
	var x = imod_ClientWidth() - o.offsetWidth;
	var y = imod_ClientHeight() - o.offsetHeight;
	if (x < 0) x = 0;
	if (y < 0) y = 0;
	var ws = imod.Browser.GetWindowScroll();
	
	o.style.left = ((x / 2) + ws.left) + "px";
	o.style.top = ((y / 2) + ws.top) + "px";
}

//Element, x, y
//Element, point  (where point is any object with an exposed x and y property)
imod.dom.PositionElement = function() {
	var x = 0;
	var y = 0;
	var o = null;

	switch (arguments.length) {
		case 2:
			o = arguments[0];
			x = arguments[1].x;
			y = arguments[1].y;
		case 3:
			o = arguments[0];
			x = arguments[1];
			y = arguments[2];
			break;
	}
	var w = o.offsetWidth;
	var h = o.offsetHeight;
	var winScroll = imod.Browser.GetWindowScroll();

	if (x + w > imod_ClientWidth() + winScroll.left)
		x -= (x + w - imod_ClientWidth() - winScroll.left);
	if (x < winScroll.left)
		x = winScroll.left;

	if (y + h > imod_ClientHeight() + winScroll.top)
		y -= (y + h - imod_ClientHeight() - winScroll.top);
	if (y < winScroll.top)
		y = winScroll.top;

	o.style.left = x + "px";
	o.style.top = y + "px";
}

imod.Fancy.BouncyImage = function(o) {
	/*
	var div = document.createElement("span");
	var PaddingProperty = "padding";
	if (imod.Browser.IE)
		PaddingProperty = "margin";

	o.style[PaddingProperty] = "1px";

	o.onmouseover = function() {
		this.style[PaddingProperty] = "0px 2px 2px 0px";
	}
	
	o.onmouseout = function() {
		this.style[PaddingProperty] = "1px";
	}
	*/
}

imod.Fancy.GlobalFastTitle2 = function(oPrmRoot) {
	var oRoot = oPrmRoot;
	if (oRoot == null)
		oRoot = document.body;
	
	imod.dom.AddHandler(oRoot, "mouseover", imod.Fancy.FastTitleHandler2);
	imod.dom.AddHandler(oRoot, "mouseout", imod.Fancy.FastTitleCloseHandler2);
	imod.dom.AddHandler(oRoot, "mousemove", imod.Fancy.FastTitleMoveHandler2);
	
	imod.Fancy.BuildFastTitleDiv();
}

imod.Fancy.FastTitleMoveHandler2 = function(e) {
	if (imod.Fancy.FastTitleOn) {
		imod.Fancy.ShowFastTitle(imod.Fancy.FastTitleCurrent, e);
	}
}

imod.Fancy.ShowFastTitle = function(sender, e) {
	if (sender.FastTitle != null) {
		var divFastTitle = imod.$("divFastTitle55378008");
		var divFastTitleContent = imod.$("divFastTitleContent55378008");
		var divShadow = imod.$("divFastTitleShadow55378008");
		divFastTitleContent.innerHTML = sender.FastTitle;
		divFastTitle.style.display = "";
		var iOffsetY = 0;
		//if (imod.Browser.MouseX(e) + 15 + divFastTitle.offsetWidth > imod_ClientWidth() + imod_DocumentScrollLeft())
		var ws = imod.Browser.GetWindowScroll();
		var mouse = imod.Browser.GetMouse(e);
		if (mouse.x + 15 + divFastTitle.offsetWidth > imod_ClientWidth() + ws.left)
			iOffsetY = 15
		imod.dom.PositionElement(divFastTitle, mouse.x + 15, mouse.y + iOffsetY);
		divShadow.style.width = divFastTitle.offsetWidth + "px";
		divShadow.style.height = divFastTitle.offsetHeight + "px";
		divShadow.style.display = "";
		var pos = imod.dom.GetPosition(divFastTitle);
		
		imod.dom.PositionElement(divShadow, 3 + pos.x, 3 + pos.y);
		//imod.dom.PositionElement(divShadow, 3 + imod.dom.OffsetLeft(divFastTitle), 3 + imod.dom.OffsetTop(divFastTitle));
	}
}

imod.Fancy.FastTitleHandler2 = function (e) {
	var sender = ((e.target != null) ? e.target : window.event.srcElement);

	switch (sender.tagName) {
		case "IFRAME":
			return; //skip iframes
	}

	if (!sender.FastTitleCached) {
		var oCurrent = sender;
		var bNotFound = true;

		while (bNotFound) {
			if (oCurrent == document || oCurrent == document.body) {
				sender.FastTitle = null;
				sender.title = "";
			}
			else {
				if (oCurrent.FastTitle)
					sender.FastTitle = oCurrent.FastTitle;
				else if (oCurrent.title != null && oCurrent.title.length > 0)
					sender.FastTitle = oCurrent.title;
				else if (oCurrent.alt != null && oCurrent.alt.length > 0)
					sender.FastTitle = oCurrent.alt;
				else {
					oCurrent = oCurrent.parentNode;
				}
			}
			if (sender.FastTitle != null || oCurrent == null || oCurrent == document.body) {
				bNotFound = false;
				if (oCurrent != null && oCurrent != document.body)
					oCurrent.title = "";
			}
		}
		if (sender.FastTitle != null)
			sender.title = "";
		sender.FastTitleCached = true;
	}
	if (imod.Fancy.FastTitle != null) {
		imod.Fancy.FastTitleOn = true;
		imod.Fancy.FastTitleCurrent = sender;
		imod.Fancy.ShowFastTitle(sender, e);
	}
}

imod.Fancy.FastTitleCloseHandler2 = function(e) {
	if (imod.Fancy.FastTitleOn) {
		var sender = ((e.target != null) ? this : window.event.srcElement);
		var divFastTitle = imod$("divFastTitle55378008");
		divFastTitle.style.display = "none";
		imod$("divFastTitleShadow55378008").style.display = "none";
		imod.Fancy.FastTitleOn = false;
		imod.Fancy.FastTitleCurrent = null;
	}
}

imod.Fancy.GlobalFastTitle = function(o) {
	return;
}

imod.Fancy.BuildFastTitleDiv = function() {
	var divFastTitle = document.createElement("div");
	//var sSkin = "RoundedShadowBorder";
	//var w = "7px";
	//var h = "7px";
	var sSkin = "RoundedBorder";
	var w = "5px";
	var h = "5px";
	divFastTitle.id = "divFastTitle55378008";
	divFastTitle.style.position = "absolute";
	divFastTitle.style.display = "none";
	
	var t, r, c //table, row, cell
	var img;
	t = document.createElement("table");
	t.style.position = "";
	t.cellPadding = 0;
	t.cellSpacing = 0;
	t.border = 0;
	
	r = t.insertRow(0);
	
	c = r.insertCell(0);
	c.width = w;
	c.height = h;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/top-left.gif";
	c.appendChild(img);
	
	c = r.insertCell(1);
	c.height = h;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/top.gif";
	c.style.backgroundImage = "url(" + img.src + ")";

	c = r.insertCell(2);
	c.width = w;
	c.height = h;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/top-right.gif";
	c.appendChild(img);
	
	r = t.insertRow(1);
	
	c = r.insertCell(0);
	c.height = h;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/left.gif";
	c.style.backgroundImage = "url(" + img.src + ")";
		
	c = r.insertCell(1);
	var div = document.createElement("div");
	div.id = "divFastTitleContent55378008";
	c.appendChild(div);

	c = r.insertCell(2);
	c.height = h;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/right.gif";
	c.style.backgroundImage = "url(" + img.src + ")";

	r = t.insertRow(2);
	
	c = r.insertCell(0);
	c.width = w;
	c.height = h;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/bottom-left.gif";
	c.appendChild(img);
	
	c = r.insertCell(1);
	c.height = h;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/bottom.gif";
	c.style.backgroundImage = "url(" + img.src + ")";

	c = r.insertCell(2);
	c.width = w;
	c.height = h ;
	img = document.createElement("img");
	img.src = "/images/FastTitle/" + sSkin + "/bottom-right.gif";
	c.appendChild(img);

	divFastTitle.appendChild(t);
	document.body.appendChild(divFastTitle);
	
	//Shadow
	var divShadow = divFastTitle.cloneNode(true);
	document.body.appendChild(divShadow);
		
	var re = new RegExp(sSkin, "gi");
	divShadow.innerHTML = divShadow.innerHTML.replace(re, sSkin + "/Shadow");
	var tShadow = divShadow.firstChild;
	tShadow.width = "100%";
	tShadow.height = "100%";

	tShadow.rows[1].cells[1].firstChild.innerHTML = "&nbsp;";
	tShadow.rows[1].cells[1].firstChild.style.backgroundColor = "black";

	imod.dom.SetOpacity(divShadow, .3);
	divShadow.id = "divFastTitleShadow55378008";
	divShadow.style.zIndex = "99999998";

	return divFastTitle;
}

imod.Fancy.FastTitle = function(o, s) {
	var divFastTitle = imod$("divFastTitle55378008");
	if (divFastTitle == null) {
		divFastTitle = imod.Fancy.BuildFastTitleDiv();
	}
	if (o.FastTitle == null) {
		imod.dom.AddHandler(o, "mousemove", imod.Fancy.FastTitleHandler);
		imod.dom.AddHandler(o, "mouseout", imod.Fancy.FastTitleCloseHandler);
	}
	if (s == null) {
		if (o.title != null && o.title.length > 0)
			o.FastTitle = o.title;
		else 
			o.FastTitle = o.alt;
		o.title = "";
	}
	else {
		o.FastTitle = s;
	}
	o.FastTitleEnabled = true;
}

imod.Fancy.FastTitleHandler = function(e) {
	var sender = ((e.target != null) ? this : window.event.srcElement);
	if (sender.FastTitleEnabled) {
		var divFastTitle = imod$("divFastTitle55378008");
		var divFastTitleContent = imod$("divFastTitleContent55378008");
		var divShadow = imod$("divFastTitleShadow55378008");
		divFastTitleContent.innerHTML = sender.FastTitle;
		divFastTitle.style.display = "";
		var iOffsetY = 0;
		if (imod.Browser.MouseX(e) + 15 + divFastTitle.offsetWidth > imod_ClientWidth() + imod_DocumentScrollLeft())
			iOffsetY = 15
		imod.dom.PositionElement(divFastTitle, imod.Browser.MouseX(e) + 15, imod.Browser.MouseY(e) + iOffsetY);
		
		divShadow.style.left = (3 + imod.dom.OffsetLeft(divFastTitle)) + "px";
		divShadow.style.top = (3 + imod.dom.OffsetTop(divFastTitle)) + "px";
		divShadow.style.width = divFastTitle.offsetWidth + "px";
		divShadow.style.height = divFastTitle.offsetHeight + "px";
		divShadow.style.display = "";
	}	
}

imod.Fancy.FastTitleCloseHandler = function(e) {
	var sender = ((e.target != null) ? this : window.event.srcElement);
	var divFastTitle = imod$("divFastTitle55378008");
	divFastTitle.style.display = "none";
	imod$("divFastTitleShadow55378008").style.display = "none";
}

imod.Fancy.MakeDraggable = function(oPrmDrag, oPrmTarget) {
	var oDrag = oPrmDrag;
	var oTarget = oPrmTarget;
	if (oTarget == null)
		oTarget = oDrag;

	imod.dom.DisableMouseSelect(oTarget);
	imod.dom.AddHandler(oTarget, "mousedown", MouseDown);
	imod.dom.AddHandler(document.body, "mousemove", MouseMove);
	imod.dom.AddHandler(document.body, "mouseup", MouseUp);
	
	function MouseDown(e) {
		oDrag.Dragging = true;
		oDrag.DragOffsetX = imod.Browser.MouseX(e) - imod.dom.OffsetLeft(oDrag);
		oDrag.DragOffsetY = imod.Browser.MouseY(e) - imod.dom.OffsetTop(oDrag);
	}
	
	function MouseMove(e) {
		if (oDrag.Dragging)
			imod.dom.PositionElement(oDrag, imod.Browser.MouseX(e) - oDrag.DragOffsetX, imod.Browser.MouseY(e) - oDrag.DragOffsetY);
	}
	
	function MouseUp() {
		oDrag.Dragging = false;
	}
}

imod.Fancy.MakeNifty = function(sPrmId, bPrmLoaded) {
	if (imod.Trace) imod.Trace.Warn("Warning!!! Nifty corners suck!");
	imod_RemoveHandler(window, "load", imod.Fancy.MakeNifty_Check);
	imod_AddHandler(window, "load", imod.Fancy.MakeNifty_Check);
	if (bPrmLoaded) {
		Rounded("div#" + sPrmId, "all", "transparent", "#fff", "smooth border #ccc");
	}
	else
		imod_AddHandler(window, "load", function() { Rounded("div#" + sPrmId, "all", "transparent", "#fff", "smooth border #ccc"); });
	
}

imod.Fancy.MakeNifty_Check = function() {
	if (! NiftyCheck()) 
		return;
}

//All of these should be moved to CSS where possible if we can make the admin template use standards mode
imod.Fancy.ActivateFancyInputFocus = function() {
	var inputs = null;
	if (arguments && arguments.length > 0)
		inputs = arguments;
	else
		inputs = imod_GetElementsByTagNames(document.body, "input", "textarea", "select");

	for (var i = 0; i < inputs.length; i++) {
		if (inputs[i].type != "radio" && inputs[i].type != "checkbox" && inputs[i].type != "button" && inputs[i].type != "submit" && inputs[i].type != "reset") {
			imod_AddHandler(inputs[i], "focus", imod.Fancy.HighlightInput);
			imod_AddHandler(inputs[i], "blur", imod.Fancy.UnHighlightInput);
		}
	}
}

imod.Fancy.HighlightInput = function(e) {
	var sender = this;
	if (window.event) sender = window.event.srcElement;
	sender._backgroundColor = sender.style.backgroundColor;
	sender.style.backgroundColor = "beige";
}

imod.Fancy.UnHighlightInput = function(e) {
	var sender = this;
	if (window.event != null) sender = window.event.srcElement;
	if (sender._backgroundColor != null)
		sender.style.backgroundColor = sender._backgroundColor;
	else
		sender.style.backgroundColor = "";
}

imod.Fancy.ActivateFancyLabels = function() {
	var inputs = null;
	if (arguments != null && arguments.length > 0)
		inputs = arguments;
	else
		inputs = imod_GetElementsByTagNames(document.body, "input", "textarea", "select");
	for (var i = 0; i < inputs.length; i++) {
		if (inputs[i].type != "checkbox" && inputs[i].type != "radio" && inputs[i].type != "button" && inputs[i].type != "submit" && inputs[i].type != "reset") {
			imod_AddHandler(inputs[i], "focus", imod.Fancy.HighlightInputLabel);
			imod_AddHandler(inputs[i], "blur", imod.Fancy.UnHighlightInputLabel);
		}
	}
}

imod.Fancy.HighlightInputLabel = function(e) {
	var sender = this;
	if (window.event != null) sender = window.event.srcElement;
	l = imod_GetLabelForInput(sender);
	if (l) {
		l._fontWeight = l.style.fontWeight;
		l.style.fontWeight = "bold";
	}
}

imod.Fancy.UnHighlightInputLabel = function(e) {
	var sender = this;
	if (window.event) sender = window.event.srcElement;
	l = imod_GetLabelForInput(sender);
	if (l) {
		if (l._fontWeight)
			l.style.fontWeight = l._fontWeight;
		else
			l.style.fontWeight = "";
	}
}

imod.Fancy.ActivateFancyCheckBoxes = function() {
	var cbs = imod_GetElementsByTagNames(document.body, "input");
	for (var i = 0; i < cbs.length; i++) {
		if (cbs[i].type == "checkbox") {
			imod_AddHandler(cbs[i], "click", imod.Fancy.Handlers.FancyRadioCheckBoxClickHandler);
			if (cbs[i].checked)
				imod.Fancy.SelectFancyCheckBox(cbs[i]);
		}
	}
}

imod.Fancy.ActivateFancyRadioButtons = function () {
	var rbs = imod_GetElementsByTagNames(document.body, "input");
	for (var i = 0; i < rbs.length; i++) {
		if (rbs[i].type == "radio") {
			imod_AddHandler(rbs[i], "click", imod.Fancy.Handlers.FancyRadioCheckBoxClickHandler);
			if (rbs[i].checked)
				imod.Fancy.SelectFancyCheckBox(rbs[i]);

		}
	}	
}

imod.Fancy.Handlers.FancyRadioCheckBoxClickHandler = function(e) {
	var sender = this;
	if (window.event) sender = window.event.srcElement;
	imod.Fancy.SelectFancyCheckBox(sender);
}

imod.Fancy.SelectFancyCheckBox = function(sender) {
	var SelectedItemCssText = "font-weight:bold;";
	var l = null;
	if (sender.type == "radio") {
		var radios = document.forms["MainForm"].elements[sender.name];
		for (var i = 0; i < radios.length; i++) {
			l = imod_GetLabelForInput(radios[i]);
			if (l) {
				l.style.cssText = l.style._cssText;
			}	
		}
		
	}
	l = imod_GetLabelForInput(sender);
	if (l) {
		if (sender.checked) {
			l.style._cssText = l.style.cssText;
			l.style.cssText = SelectedItemCssText;
		}	
		else {
			l.style.cssText = l.style._cssText;
		}
	}
}

function imod_GetLabelForInput(o) {
	var labels = document.body.getElementsByTagName("label");
	for (var i = 0; i < labels.length; i++) {
		if (labels[i].htmlFor == o.id)
			return labels[i];
	}
	return null;

}

function imod_ParseInt(sPrmInt) {
	if (! isNaN(sPrmInt))
		return parseInt(sPrmInt);
	if (typeof(sPrmInt) == "string" && sPrmInt.length > 0) {
		var s = sPrmInt.split("");
		var sValid = "0123456789";
		var sSkip = ",-";
		var sInt = "";
		var bGetting = false;
		for (var i = 0; i < s.length; i++) {
			if (sValid.indexOf(s[i]) > -1) {
				sInt += s[i];
				bGetting = true;
			}
			else if (sSkip.indexOf(s[i]) > -1) {
				//do nothing
			}
			else {
				if (bGetting)
					break;
			}
		}
		if (s[0] == "-")
			sInt = "-" + sInt;
		if (! isNaN(sInt))
			return parseInt(sInt);
	}
	return 0;
}

function imod_GetRadioButtonValue(sPrmName) {
	var rbs = document.forms["MainForm"].elements[sPrmName];
	for (var i = 0; i < rbs.length; i++) {
		if (rbs[i].checked)
			return rbs[i].value;		
	}
	return null;
}

function imod_SetTableRowBackgroundColors(oPrmTable, sPrmColor, sPrmColorAlt, bPrmSkipHeader) {
	if (sPrmColor == null)
		sPrmColor = "#f7f6eb";
	if (sPrmColorAlt == null)
		sPrmColorAlt = "#e5e7d8";
	if (oPrmTable == null) {
		alert("imod_SetTableRowBackgroundColors::oPrmTable is null");
		return;
	}
	if (oPrmTable.rows == null) {
		alert("imod_SetTableRowBackgroundColors::oPrmTable is not a table");
		return;
	}
	var iStart = 0;
	if (bPrmSkipHeader)
		iStart = 1;
	for (var i = iStart; i < oPrmTable.rows.length; i++) {
		if (i % 2 == 0)
			oPrmTable.rows[i].style.backgroundColor = sPrmColor;
		else
			oPrmTable.rows[i].style.backgroundColor = sPrmColorAlt;
	}
}
imod.Fancy.SetTableRowBackgroundColors = imod_SetTableRowBackgroundColors;

function imod_Pixel(i) {
	if (isNaN(i) && i.indexOf != null && i.indexOf("px") > -1)
		return i;
	var s = i + "px";
	if (s == "px")
		s = "";

	return s;
}

function imod_ASCX(sPrmUniqueId) {
	var UniqueId;
	if (sPrmUniqueId) { SetUniqueId(sPrmUniqueId); }
	this.Verbiage = new imod_Verbiage();
	
	this.$ = GetElement;
	this.O = GetObject;
	
	this.SetUniqueId = SetUniqueId;
	
	function SetUniqueId(sPrmUniqueId) {
		UniqueId = sPrmUniqueId.replace(/[$:]/gi, "_");
	}
	
	function GetElement(sPrmId) {
		return imod$(UniqueId + "_" + sPrmId);
	}
	
	function GetObject(sPrmName) {
		return window[UniqueId + "_" + sPrmName];
	}
}

function imod_Verbiage() {
	var Items = {};
	
	this.Add = Add;
	this.Set = Add;
	this.Get = Get;
	
	function Add(sPrmKey, sPrmValue) {
		Items[sPrmKey] = sPrmValue;
	}
	
	function Get(sPrmKey) {
		if (Items[sPrmKey] == null)
			return sPrmKey;
		return Items[sPrmKey];

	}
}

function imod_CreateElement(sPrmElement, sPrmFrame) {
	var dummy = null;
	if (sPrmFrame) {
		if (sPrmElement.indexOf("<") > -1) {
			dummy = window.frames[sPrmFrame].document.createElement("div");
			dummy.innerHTML = sPrmElement;
			return dummy.firstChild;
		}
		return window.frames[sPrmFrame].document.createElement(sPrmElement);
	}
	else {
		if (sPrmElement.indexOf("<") > -1) {
			dummy = document.createElement("div");
			dummy.innerHTML = sPrmElement;
			return dummy.firstChild;
		}
		return document.createElement(sPrmElement);
	}
}

function imod$() {
	if (arguments.length == 0)
		return null;
	if (arguments.length == 1)
		return document.getElementById(arguments[0]);
	var aryReturn = new Array(arguments.length);
	for (var i = 0; i < arguments.length; i++)
		aryReturn[i] = document.getElementById(arguments[i]);
	return aryReturn;
}

imod.$ = function() {
	if (arguments.length == 0)
		return null;
	if (arguments.length == 1)
		return document.getElementById(arguments[0]);
	var aryReturn = new Array(arguments.length);
	for (var i = 0; i < arguments.length; i++)
		aryReturn[i] = document.getElementById(arguments[i]);
	return aryReturn;
}


imod$ = function() {
	if (arguments.length == 0)
		return null;
	if (arguments.length == 1)
		return document.getElementById(arguments[0]);
	var aryReturn = new Array(arguments.length);
	for (var i = 0; i < arguments.length; i++)
		aryReturn[i] = document.getElementById(arguments[i]);
	return aryReturn;
}



//todo:  We should replace all calls with imod$ or something of the sort to prevent future collisions.  not as pretty, but still better than document.getElementById.
function $() {
	if (imod.Trace) imod.Trace.Warn("$ is deprecated for being too general, please use imod$");
	if (arguments.length == 0)
		return null;
	if (arguments.length == 1)
		return document.getElementById(arguments[0]);
	var aryReturn = new Array(arguments.length);
	for (var i = 0; i < arguments.length; i++)
		aryReturn[i] = document.getElementById(arguments[i]);
	return aryReturn;

}

function imod_ASCX$(sPrmId) {
	return imod$(this.UniqueId + "_" + sPrmId);
}

//Read .Net compatible cookie
function imod_GetCookie(sPrmName, sPrmKey) {
	var aryCookies = document.cookie.replace(/;\s/gi, ";").split(";");
	for (var i = 0; i < aryCookies.length; i++) {
		var sCookie = aryCookies[i];
		if (sCookie.indexOf(sPrmName + "=") == 0) {
			if (sPrmKey != null) {
				var sNewPairs = "";
				var sValues = sCookie.substring(sPrmName.length + 1, sCookie.length);
				var aryValues = sValues.split("&");
				for (var j = 0; j < aryValues.length; j++) {
					var sPair = aryValues[j];
					if (sPair.indexOf(sPrmKey + "=") == 0) {
						return window.unescape(sPair.substring(sPrmKey.length + 1, sPair.length));
					}
				}
			}
			else {
				return window.unescape(sCookie.substring(sPrmName.length + 1, sCookie.length));
			}
		}
	}
	return null;
}


//Write .Net compatible cookie
//Expiration NYI, Domain NYI
function imod_SetCookie(sPrmName, sPrmKey, sPrmValue, iPrmDaysToLive, sPrmDomain) {
	//var DateExpires = new Date("12/11/2009");
	var sDomain = "domain=" + window.location.host + ";";
	//var sExpires = "expires=" + DateExpires.toGMTString() + ";"; //" expires=;";
	var sPath = "path=/;"
	//var sCookieFooter = sExpires + sPath + sDomain;
	var sCookieFooter = sDomain;
	
	var aryCookies = document.cookie.replace(/;\s/gi, ";").split(";");
	for (var i = 0; i < aryCookies.length; i++) {
		var sCookie = aryCookies[i];
		if (sCookie.indexOf(sPrmName + "=") == 0) {
			var sNewPairs = "";
			var sValues = window.unescape(sCookie.substring(sPrmName.length + 1, sCookie.length));
			var aryValues = sValues.split("&");
			var bExists = false;
			for (var j = 0; j < aryValues.length; j++) {
				var sPair = aryValues[j];
				if (sPair.indexOf(sPrmKey + "=") == 0) {
					sNewPairs += "&" + sPrmKey + "=" + window.escape(sPrmValue);
					bExists = true;
				}
				else {
					sNewPairs += "&" + sPair;
				}
			}
			if (! bExists) {
				sNewPairs += "&" + sPrmKey + "=" + window.escape(sPrmValue);
			}
			if (sNewPairs.length > 0 && sNewPairs[0] == "&")
				sNewPairs = sNewPairs.substring(1);
			document.cookie = sPrmName + "=" + sNewPairs + ";" + sCookieFooter; // + " expires=" + DateExpires.toGMTString() + "; path=/";
			return;
		}
	}
	document.cookie = sPrmName + "=" + sPrmKey + "=" + window.escape(sPrmValue) + ";" + sCookieFooter; // + ";" + " expires=" + DateExpires.toGMTString() + "; path=/";
}

function imod_GetElementsByTagNames(oPrmTarget) {
	var aryReturn = new Array();
	for (var i = 1; i < arguments.length; i++) {
		var aryElements = oPrmTarget.getElementsByTagName(arguments[i]);
		for (var j = 0; j < aryElements.length; j++)
			aryReturn.push(aryElements[j]);
	}
	return aryReturn;
}

function imod_RollUp(sPrmId, iPrmDelay, iPrmAmount, prmDoneAction) {
	var Amount = iPrmAmount;
	var Delay = ((iPrmDelay != null) ? iPrmDelay : 35);
	var Done = false;
	var o = document.getElementById(sPrmId);
	o.style.display = "";
	var i = o.offsetHeight;
	if (Amount == null)
		Amount = i / 12;
	Deflate();
	
	function Deflate() {
		i -= Amount;
		if (i <= 0) {
			i = 0;
			Done = true;
		}
		o.style.height = i + "px";
		if (! Done) {
			setTimeout(Deflate, Delay);
		}
		else {
			o.style.display = "none";
			o.style.height = "";
			if (prmDoneAction != null)
				prmDoneAction();
		}	
	}
}

function imod_RollOut(sPrmId, iPrmDelay, iPrmAmount, prmDoneAction) {
	var Amount = iPrmAmount;
	var Delay = ((iPrmDelay != null) ? iPrmDelay : 35);
	var i = 0;
	var Done = false;
	var o = document.getElementById(sPrmId);
	o.style.visibility = "hidden";
	o.style.display = "";
	var Max = o.offsetHeight;
	if (Amount == null)
		Amount = Max / 12;
	o.style.height = "0px";
	o.style.visibility = "visible";
	Expand();
	
	function Expand() {
		i += Amount;
		if (i >= Max) {
			i = Max;
			Done = true;
		}
		o.style.height = i + "px";
		if (! Done) {
			setTimeout(Expand, Delay);
		}
		else {
			if (prmDoneAction != null)
				prmDoneAction();
		}
	}
}

function imod_SetOpacity(o, iPrmOpacity) {
	if (iPrmOpacity != null) {
		o.style.opacity = iPrmOpacity;
		o.style.MozOpacity = iPrmOpacity;
		o.style.filter = "alpha(opacity=" + iPrmOpacity * 100 + ")";
	}
	else {
		o.style.opacity = "";
		o.style.MozOpacity = "";
		o.style.filter = "";
	}	
}

function imod_IsPaired(sPrmTagName) {
	switch(sPrmTagName) {
		case "br":
		case "hr":
		case "input":
		case "link":
		case "img":
			return false;
	}
	return true;
}


function imod_GetHTML(o, bPrmInnerOnly) {
	var ProcessedKey = Math.random();
	return imod_GetHTML_R(o, bPrmInnerOnly, ProcessedKey);
}

function imod_GetHTML_R(o, bPrmInnerOnly, prmProcessedKey) {
	var s = "";
	if (o.HeyIEThisHasBeenProcessed == prmProcessedKey) {
		//o.HeyIEThisHasBeenProcessed = null; //Hoping this only gets duped once
		return "";
	}
	else {	
		if (o.tagName != null) {
			var sTag = o.tagName.toLowerCase();
			var bPaired = imod_IsPaired(sTag);
			if (! bPrmInnerOnly) {
				s += "<" + sTag;
				if (o.attributes != null) {
					for (var i = 0; i < o.attributes.length; i++) {
						if ((o.attributes[i].nodeValue != null && o.attributes[i].nodeValue != "" && typeof(o.attributes[i].nodeValue) != "object") || (o.attributes[i].nodeName.toLowerCase() == "style" && o.style.cssText.length > 0)) {
							if (o.attributes[i].specified == null || o.attributes[i].specified == true || (o.attributes[i].nodeName.toLowerCase() == "style" && o.style.cssText.length > 0)) {
								switch (o.attributes[i].nodeName.toLowerCase()) {
									case "fasttitle": //Exclude these attributes because IE is stupid
									case "fasttitlecached":
									case "heyiethishasbeenprocessed":
									case "styleold":
										break;
									default:
										s += " " + o.attributes[i].nodeName.toLowerCase() + "=\"";
										if (o.attributes[i].nodeName.toLowerCase() == "style") //IE hack
											s += o.style.cssText;
										else
											s += o.attributes[i].nodeValue;
										s += "\"";
										break;
								}
							}	
						}
					}
				}
			}
			o.HeyIEThisHasBeenProcessed = prmProcessedKey;
			if (! bPaired) {
				s += " />";
			}
			else {
				if (! bPrmInnerOnly)
					s += ">";
				if (o.text != null && window.attachEvent != null) //IE hack
					if (! bPrmInnerOnly)
						s += o.text;
				if (o.childNodes != null) {
					for (var i = 0; i < o.childNodes.length; i++)
						s += imod_GetHTML_R(o.childNodes[i], false, prmProcessedKey);
				}
				if (! bPrmInnerOnly)
					s += "</" + sTag + ">";
			}
			//imod_DebugWrite("DONE: " + sTag);
		}
		else {
			s += o.data;
		}
		return s;
	}
}

function imod_SelectText(oPrmContainer, sPrmTextProperty) {
	if (oPrmContainer.setSelectionRange != null) {
		oPrmContainer.setSelectionRange(0, oPrmContainer[sPrmTextProperty].length);
	}
	else if (oPrmContainer.createTextRange != null) {
		var oRange = oPrmContainer.createTextRange();		
		oRange.moveStart("character", 0);
		oRange.moveEnd("character", oPrmContainer[sPrmTextProperty].length);
		oRange.select();
	}
	else {
		alert("Element does not support selecting text");	
	}
}

function imod_RemoveChildNodes(o) {
	//you will lose your events and custom properties.
	//Proper usage: foo = imod_RemoveChildNodes(foo);
	//This is due to how JS handles pointers in method parameters.
	var oReturn = o.cloneNode(false);
	o.parentNode.replaceChild(oReturn, o);
	return oReturn;
}

function imod_StopPropagation(e, sPrmFrameName) {
	//Stops events from bubbling up.
	//e: the event object.  Currently needed for Mozilla
	//sPrmFrameName:  If you are stopping propagation of an event in a frame by a method declared outside the frame
	//	this should be set so in IE it knows which event object to use.
	if (e == null) {
		if (sPrmFrameName != null)
			e = window.frames[sPrmFrameName].event;
		else
			e = window.event;
	}
	if (e.stopPropagation) 
		e.stopPropagation();
	else 
		e.cancelBubble = true;
}

function imod_ResizeTreeView(sPrmClientId, prmWidth, prmHeight) {
	//Quick way to resize a RadTreeView clientside.
	var tv = document.getElementById(sPrmClient);
	if (tv == null)
		tv = document.getElementById(sPrmClientId + "Div");
	if (prmWidth != null)
		tv.style.width = prmWidth + "px";
	if (prmHeight != null)
		tv.style.height = prmHeight + "px";
}

function imod_Alert(sPrmMessage, sPrmTitle, iPrmButtons) {
	//Create a div based window alert message.
	//Requires the following CSS classes: IModAlert, IModAlertTitle, IModAlertMessage.
	//sPrmMessage: The message body
	//sPrmTitle: alert title, optional, but looks ugly without it.
	//iPrmButtons: NYI
	var divAlert = document.createElement("div");
	divAlert.className = "IModAlert";
	if (sPrmTitle != null) {
		var divTitle = document.createElement("div");
		divTitle.className = "IModAlertTitle";
		divTitle.innerHTML = sPrmTitle;
		divAlert.appendChild(divTitle);
	}
	var divMessage = document.createElement("div");
	divMessage.innerHTML = sPrmMessage;
	divMessage.className = "IModAlertMessage";
	divAlert.appendChild(divMessage);
	divAlert.appendChild(document.createElement("br"));
	var btnOkay = document.createElement("input");
	btnOkay.type = "button";
	btnOkay.className = "button";
	btnOkay.value = "Okay";
	btnOkay.style.textAlign = "center";
	btnOkay.onclick = function() {
		if (divAlert != null)
			document.body.removeChild(divAlert);
	}
	divAlert.appendChild(btnOkay);
	
	divAlert.style.zIndex = -9999;
	document.body.appendChild(divAlert);
	var x = (document.body.offsetWidth - 300) / 2;
	var y = (imod_ClientHeight() - divAlert.offsetHeight) / 2;
	divAlert.style.left = x + "px";
	divAlert.style.top = y + "px";
	divAlert.style.zIndex = 9999;
	btnOkay.focus();

	return divAlert;
}

//iPrmCenterMode: 0 - none, 1 - browser, 2 = screen, null - none, 3 = full screen
function imod_OpenWindow(sPrmUrl, iPrmWidth, iPrmHeight, sPrmWindowProperties, iPrmCenterMode, iPrmLeft, iPrmTop) {
	var sWindowProperties = "";
	if (iPrmCenterMode == 3)
		sWindowProperties = "width=" + imod.Browser.ScreenWidth() + ",height=" + imod.Browser.ScreenHeight();
	else
		sWindowProperties = "width=" + iPrmWidth + ",height=" + iPrmHeight;
	if (sPrmWindowProperties != null && sPrmWindowProperties.length > 0)
		sWindowProperties += "," + sPrmWindowProperties;
		
	if (iPrmCenterMode != null) {
		if (iPrmCenterMode == true)
			iPrmCenterMode = 1;
		else if (iPrmCenterMode == false)
			iPrmCenterMode = 2;
	}
	if (iPrmCenterMode != null && iPrmCenterMode != 0) {
		var x = 0;
		var y = 0;
		switch (iPrmCenterMode) {
			case 1: //browser
				x = (document.body.clientWidth - iPrmWidth) / 2;
				y = (imod_ClientHeight() - iPrmHeight) /2;
				if (window.screenX != null) {
					x += window.screenX;
					y += window.screenY;
				}
				else if (window.screenLeft != null) {
					x += window.screenLeft;
					y += window.screenTop;
				}
				break;
			case 2: //screen
				x = (screen.availWidth - iPrmWidth) / 2;
				y = (screen.availHeight - iPrmHeight) /2;
				break;
		}
		if (x < 0)
			x = 0;
		if (y < 0)
			y = 0;
		sWindowProperties += ",left=" + x + ",top=" + y;
	}
	else {
		if (iPrmLeft != null)
			sWindowProperties += ",left=" + iPrmLeft;
		if (iPrmTop != null)
			sWindowProperties += ",top=" + iPrmTop;
	}
	return window.open(sPrmUrl, "", sWindowProperties);
}

function imod_ClientHeight() {
	if (window.innerHeight)
		return window.innerHeight;
	if (document.documentElement && document.documentElement.clientHeight) //  && document.documentElement.clientHeight != document.documentElement.scrollHeight)
		return document.documentElement.clientHeight;
	return document.body.clientHeight;
}

function imod_ClientWidth() {
	if (window.innerWidth)
		return window.innerWidth;
	if (document.documentElement && document.documentElement.clientWidth) //  && document.documentElement.clientWidth != document.documentElement.scrollWidth)
		return document.documentElement.clientWidth;
	return document.body.clientWidth;
}

function imod_Bool(sPrmBool) {
	//Convert sPrmBool to boolean true or false.
	switch (sPrmBool) {
		case "true":
		case "True":
		case "T":
		case "t":
		case "1":
		case "-1":
		case true:
		case 1:
		case -1:
			return true;
	}
	return false;
}

/*
function imod_VerticalScrollBarWidth() {
	var iScrollHeight = 0;
	if (document.documentElement && document.documentElement.scrollHeight)
		iScrollHeight = document.documentElement.scrollHeight;
	else
		iScrollHeight = document.body.scrollHeight;
	if (iScrollHeight != imod_ClientHeight())
		return 16;
	return 0;
}
*/

/* not used it would seem
function imod_HorizontalScrollBarHeight() {
	var iScrollWidth = 0;
	if (document.documentElement && document.documentElement.scrollWidth)
		iScrollWidth = document.documentElement.scrollWidth;
	else
		iScrollWidth = document.body.scrollWidth;
	if (iScrollWidth != imod_ClientWidth())
		return 16;
	return 0;
}
*/

//Methods for the pixel location of elements on a page.  These versions attempt to factor in scroll offsets.
function imod_DocumentScrollTop(iPrmScroll) {
	if (iPrmScroll) {
		if (imod.Trace) imod.Trace.Warn("imod.Browser.DocumentScrollTop is deprecated, please use imod.Browser.ScrollWindow(left, top)");
		imod.Browser.ScrollWindow(null, iPrmScroll);
	}
	else {
		if (imod.Trace) imod.Trace.Warn("imod.Browser.DocumentScrollTop is deprecated, please use imod.Browser.GetWindowScroll()");
	}
	return imod.Browser.GetWindowScroll().top;
	/*
	if (iPrmScroll) {
		if (document.documentElement && document.documentElement.scrollTop)
			document.documentElement.scrollTop += iPrmScroll;
		document.body.scrollTop += iPrmScroll;
	}
	if (document.documentElement && document.documentElement.scrollTop)
		return document.documentElement.scrollTop;
	return document.body.scrollTop;
	*/
}

function imod_DocumentScrollLeft(iPrmScroll) {
	if (iPrmScroll) {
		if (imod.Trace) imod.Trace.Warn("imod.Browser.DocumentScrollLeft is deprecated, please use imod.Browser.ScrollWindow(left, top)");
		imod.Browser.ScrollWindow(iPrmScroll, null);
	}
	else {
		if (imod.Trace) imod.Trace.Warn("imod.Browser.DocumentScrollLeft is deprecated, please use imod.Browser.GetWindowScroll()");
	}
	return imod.Browser.GetWindowScroll().left;

	/*
	if (iPrmScroll) {
		if (document.documentElement && document.documentElement.scrollLeft)
			document.documentElement.scrollLeft += iPrmScroll;
		document.body.scrollLeft += iPrmScroll;
	}
	if (document.documentElement && document.documentElement.scrollLeft)
		return document.documentElement.scrollLeft;
	return document.body.scrollLeft;
	*/
}

/*
imod.dom.GetPosition = function(o) {
	var x = 0;
	var y = 0;
	var w = o.offsetWidth;
	var h = o.offsetHeight;
	while (o != null) {
		x += o.offsetLeft;
		y += o.offsetTop;
		o = o.offsetParent;
	}
	if(CheckScrollOffsets)
	{
		var o = el;
		var OffsetX = 0;
		var OffsetY = 0;
		if (o != null) {
			while (o.parentNode) {
				if (o.parentNode.scrollTop)
				{
					if (o.parentNode != document.body) //don't factor window scroll bars
					{
						OffsetY += o.parentNode.scrollTop;
					}
				}
				if (o.parentNode.scrollLeft)
				{
					if (o.parentNode != document.body) //don't factor window scroll bars
					{
						OffsetX += o.parentNode.scrollLeft;
					}
				}
				o = o.parentNode;
			}
		}
		x -= OffsetX;
		y -= OffsetY;
	}
	return {"x":x, "y":y, "w":w, "h":h, "x2":x+w, "y2":y+h};
}
*/

imod.dom.GetPosition = function(el, CheckScrollOffsets) {
	var o = el;
	var x = 0;
	var y = 0;
	var w = o.offsetWidth;
	var h = o.offsetHeight;
	while (o != null) {
		x += o.offsetLeft;
		y += o.offsetTop;
		o = o.offsetParent;
	}
	if(CheckScrollOffsets)
	{
		var o = el;
		var OffsetX = 0;
		var OffsetY = 0;
		if (o != null) {
			while (o.parentNode) {
				if (o.parentNode.scrollTop)
				{
					if (o.parentNode != document.body) //don't factor window scroll bars
					{
						OffsetY += o.parentNode.scrollTop;
					}
				}
				if (o.parentNode.scrollLeft)
				{
					if (o.parentNode != document.body) //don't factor window scroll bars
					{
						OffsetX += o.parentNode.scrollLeft;
					}
				}
				o = o.parentNode;
			}
		}
		if (document.documentElement != null) {
			if (document.documentElement.scrollLeft)
				OffsetX -= document.documentElement.scrollLeft;
			if (document.documentElement.scrollTop)
				OffsetY -= document.documentElement.scrollTop;
		}	

		
		x -= OffsetX;
		y -= OffsetY;
	}
	return {"x":x, "y":y, "w":w, "h":h, "x2":x+w, "y2":y+h};
}


function imod_OffsetLeft(o) {
	//Get the exact left pixel position of element o.
	if (imod.Trace) imod.Trace.Warn("imod.dom.OffsetLeft is deprecated, please use imod.dom.GetPosition(prmElement)");
	return imod.dom.GetPosition(o, true).x;

	/*
	var iReturn = 0;
	var iOffset = imod_ScrollLeft(o);
	while (o) { 
		iReturn += o.offsetLeft;
		o = o.offsetParent;
	}
	if (document.documentElement && document.documentElement.scrollLeft)
		iReturn += document.documentElement.scrollLeft;
	return iReturn - iOffset;
	*/
}

function imod_OffsetTop(o) {
	//Get the exact top pixel position of element o.
	if (imod.Trace) imod.Trace.Warn("imod.dom.OffsetTop is deprecated, please use imod.dom.GetPosition(prmElement)");
	return imod.dom.GetPosition(o, true).y;
	/*
	var iReturn = 0;
	var iOffset = imod_ScrollTop(o);
	while (o != null) { 
		iReturn += o.offsetTop;
		o = o.offsetParent;
	}
	if (document.documentElement != null && document.documentElement.scrollTop)
		iReturn += document.documentElement.scrollTop;
	return iReturn - iOffset;
	*/
}

//deprecated
imod.dom.OffsetPosition = function(o) {
	if (imod.Trace) imod.Trace.Warn("imod.dom.OffsetPosition is deprecated, please use imod.dom.GetPosition(prmElement)");
	return imod.dom.GetPosition(o);
}

function imod_MouseX(e) {
	if (imod.Trace) imod.Trace.Warn("imod.Browser.MouseX is deprecated.  Use imod.Browser.GetMouse()");
	return imod.Browser.GetMouse(e).x;
	/*
	var iScroll = imod.Browser.GetWindowScroll().left;
	if (e.pageX)
		return e.pageX;
	else if (e.clientX)
		return e.clientX + iScroll;
	else if (e.x)
		return e.x + iScroll;
	return 0;
	*/
}

function imod_MouseY(e) {
	if (imod.Trace) imod.Trace.Warn("imod.Browser.MouseY is deprecated.  Use imod.Browser.GetMouse()");
	return imod.Browser.GetMouse(e).y;
	/*
	var iScroll = imod.Browser.GetWindowScroll().top;
	if (e.pageY)
		return e.pageY;
	else if (e.clientY)
		return e.clientY + iScroll;
	else if (e.y)
		return e.y + iScroll;
	return 0;
	*/
}

//Return an object with the x and y coords of the mouse (clientX and clientY are added as a bonus if you need them)
imod.Browser.GetMouse = function(evt, frm) {
	var m = {};
	var w = (frm) ? window.frames[frm] : window;
	var e = (w.event) ? w.event : evt;
	m.clientX = e.clientX;
	m.clientY = e.clientY;
	if (e.pageX) {
		m.x = e.pageX;
		m.y = e.pageY;
	}
	else {
		var ws = imod.Browser.GetWindowScroll(frm);
		m.x = e.clientX + ws.left;
		m.y = e.clientY + ws.top;
	}
	return m;
}

/* No longer used it would seem
function imod_ScrollLeft(o) {
	var iReturn = 0;
	while (o.parentNode) {
		if (o.parentNode.scrollLeft)
			if (o.parentNode != document.body) //don't factor window scroll bars
				iReturn += o.parentNode.scrollLeft;
		o = o.parentNode;
	}
	return iReturn;
}

function imod_ScrollTop(o) {
	var iReturn = 0;
	if (o != null) {
		while (o.parentNode) {
			if (o.parentNode.scrollTop)
				if (o.parentNode != document.body) //don't factor window scroll bars
					iReturn += o.parentNode.scrollTop;
			o = o.parentNode;
		}
	}
	return iReturn;
}
*/

//Methods to add/remove event handlers
if (window.EventHandlers == null)
	var EventHandlers = new Array();

var LogHandlers = true;

function imod_HandlerCleanUp() {
	for (var i = 0; i < EventHandlers.length; i++) {
		if (EventHandlers[i].Event != "unload") {
			imod_RemoveHandler(EventHandlers[i].Object, EventHandlers[i].Event, EventHandlers[i].Handler);
			EventHandlers[i].Object = null;
			EventHandlers[i].Handler = null;
			EventHandlers[i] = null;
		}
	}
	EventHandlers = null;
	imod_RemoveHandler(window, "unload", imod_HandlerCleanUp);
}

function imod_RemoveHandlersOnUnload() {
	imod_AddHandler(window, "unload", imod_HandlerCleanUp);
}

imod.dom.AddHandler2 = function(o, sPrmEvent, prmMethod, bPrmOnCapture) {
	var f = function(e) {
		if (window.event != null) e = window.event;
		var target = e.target;
		if (target == null && e.srcElement != null)
			target = e.srcElement;
		prmMethod(o, e, target);
	}
	imod.dom.AddHandler(o, sPrmEvent, f, bPrmOnCapture);
}

function imod_AddHandler(o, sPrmEvent, f, bPrmOnCapture) {
	bReturn = false;
	if (o) {
		if (o.addEventListener != null) {
			var bOnCapture = false;
			if (bPrmOnCapture) bOnCapture = true;
			o.addEventListener(sPrmEvent, f, bOnCapture);
			bReturn = true;
		}
		else if (o.attachEvent) {
			o.attachEvent("on" + sPrmEvent, f);
			bReturn = true;
		}
		else {
			/*
			o["on" + sPrmEvent] = function(e) {
				if (o["on" + sPrmEvent] != null)
					o["on" + sPrmEvent](e);
				functionDelegate(e);
			}
			*/
		}
	} 
	if (LogHandlers)
		EventHandlers[EventHandlers.length++] = {"Object":o, "Event":sPrmEvent, "Handler":f};
	return bReturn;
}

function imod_RemoveHandler(o, sPrmEvent, f) {
	var bReturn = false;
	if (o == null) {
		return bReturn;
	}
	try {
		if (o.removeEventListener != null) {
			o.removeEventListener(sPrmEvent, f, false);
			bReturn = true;
		}
		else if (o.detachEvent) {
			o.detachEvent("on" + sPrmEvent, f);
			bReturn = true;
		}
		else {
			//o["on" + sPrmEvent] = null;
		}
	}
	catch(ex) {
		//Stop permission errors from breaking IE in cross-frame assignments
	}
	return bReturn;
}

//FIXES RadEditor's HTML issues
function imod_FixRadEditorHtml(sPrmClientID) {
	var bHasFail = true;
	if (window.GetRadEditor != null) {
		var RadEditor1 = GetRadEditor(sPrmClientID);
		if (RadEditor1 != null) {
			bHasFail = false;
			RadEditor1.FiltersManager.Add(new imod_RadEditorFix_CustomFilter());
		}
	}
	if (bHasFail)
		setTimeout(function() { imod_FixRadEditorHtml(sPrmClientID); }, 100);
}

function imod_RadEditorFix_CustomFilter() {          
	this.GetHtmlContent = imod_RadEditorFix;
}

function imod_RadEditorFix(sPrmHtml) {
	var sReturn = sPrmHtml;
	
	sReturn = sReturn.replace(/&amp;/gi, "&");
	sReturn = sReturn.replace(/&gt;/gi, ">");
	sReturn = sReturn.replace(/&lt;$/i, "<");
	sReturn = sReturn.replace(/&lt;([\s"'])/gi, "<$1");
	sReturn = sReturn.replace(/&lt;([<])/gi, "<<");
	sReturn = sReturn.replace(/%5B/gi, "[");
	sReturn = sReturn.replace(/%5D/gi, "]");
	
	//Fix token spacing	
	var reTokens = new Array(/\[[^\]]*\]/gi, /##[^#]*##/gi);
	for (var i = 0; i < reTokens.length; i++) {
		var mcToken = sReturn.match(reTokens[i]);
		if (mcToken != null) {
			for (var m = 0; m < mcToken.length; m++) {
				var mToken = mcToken[m];
				var sFixed = "";
				if (mToken != null) {
					sFixed = mToken.replace(/[\s]+/g, " ");
					sReturn = sReturn.replace(mToken, sFixed);
				}
			}
		}
	}
	return sReturn;
}

//WARNING:  This will not work when Peter's Date Package v1.1.10 is released!!!
//WARNING:  This will not work when Peter's Date Package v1.1.10 is released!!!
//WARNING:  This will not work when Peter's Date Package v1.1.10 is released!!!
//DJ 2005-0927 :: This method can be used to fix CS_Calendar's that are hidden.
//Also, this requires you know what width the calendar should be, if you don't know then ask me to make another fix.
function imod_FixCSCalendarWidth(sPrmCalendarId, iPrmCommonWidth) {
	var pCField = PDP_GetById(sPrmCalendarId);
	var vCId = pCField.id;
	var vWRTbl = PDP_GetById(vCId + "_WeekRows");
	var vCommonWidth = vWRTbl.offsetWidth;
	
	var vDayHeaderTable = PDP_GetById(vCId + "_DayHeader");
	var vHeaderTable1 = PDP_GetById(vCId + "_Header1");
	var vHeaderTable2 = PDP_GetById(vCId + "_Header2");
	var vHeaderTable3 = PDP_GetById(vCId + "_Header3");
	var vFooterTable1 = PDP_GetById(vCId + "_Footer1");
	var vFooterTable2 = PDP_GetById(vCId + "_Footer2");
	var vFooterTable3 = PDP_GetById(vCId + "_Footer3");
	
	var vCalendarClientWidth = 0;
	if (pCField.clientWidth)
		vCalendarClientWidth = pCField.clientWidth;
	else
		vCalendarClientWidth = pCField.offsetWidth;
	
	vCommonWidth = iPrmCommonWidth;
	if (vCalendarClientWidth > vCommonWidth) {
		vCommonWidth = vCalendarClientWidth;
		pCField.style.width = vCommonWidth + "px";
	}
	else 
		pCField.style.width = vCommonWidth + "px";
	vWRTbl.style.width = vCommonWidth + "px";
	
	if (vDayHeaderTable != null)
		vDayHeaderTable.style.width = vCommonWidth + "px";
	if (vHeaderTable1 != null)
		vHeaderTable1.style.width = vCommonWidth + "px";
	if (vHeaderTable2 != null)
		vHeaderTable2.style.width = vCommonWidth + "px";
	if (vHeaderTable3 != null)
		vHeaderTable3.style.width = vCommonWidth + "px";
	if (vFooterTable1 != null)
		vFooterTable1.style.width = vCommonWidth + "px";
	if (vFooterTable2 != null)
		vFooterTable2.style.width = vCommonWidth + "px";
	if (vFooterTable3 != null)
		vFooterTable3.style.width = vCommonWidth + "px";
	PDP_SetAtt(pCField, 'InitSize', true);
}

imod.General.divDarkScreen = null;
/*
imod.General.DarkScreen = function (iPrmOpacity, sPrmColor, iPrmZIndex) {
	if (!imod.General.divDarkScreen) {
		imod.General.divDarkScreen = document.createElement("div");
		imod.General.divDarkScreen.style.display = "none";
		imod.General.divDarkScreen.style.background = "#000";
		imod.General.divDarkScreen.style.opacity = .5;
		imod.General.divDarkScreen.style.filter = "alpha(opacity=50)";
		imod.General.divDarkScreen.style.zIndex = 1000;
		imod.General.divDarkScreen.style.position = "absolute";
		imod.General.divDarkScreen.style.left = "0px";
		imod.General.divDarkScreen.style.top = "0px";
		document.body.appendChild(imod.General.divDarkScreen);
	}
	if (iPrmOpacity)
		imod.dom.SetOpacity(imod.General.divDarkScreen, iPrmOpacity);
	if (sPrmColor)
		imod.General.divDarkScreen.style.background = sPrmColor;
	if (iPrmZIndex)
		imod.General.divDarkScreen.style.zIndex = iPrmZIndex;

	imod.General.divDarkScreen.style.width = document.body.scrollWidth + "px";
	imod.General.divDarkScreen.style.height = document.body.scrollHeight + "px";
	imod.General.divDarkScreen.style.display = "block";
}
*/
imod.General.NormalScreen = function() {
	if (imod.General.divDarkScreen)
		imod.General.divDarkScreen.style.display = "none";
}

//Adds trim function to the string object
String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };
	
//KD 2006-0808 added common function to show/hide an html element based on the checked status of a checkbox passed in
function imod_ShowHide(oPrmCheckBox, sPrmElementId)
{
	var oElement = document.getElementById(sPrmElementId);
	if (oPrmCheckBox && oElement)
	{
		if (oPrmCheckBox.checked)
			oElement.style.display = '';
		else
			oElement.style.display = 'none';
	}
} //imod_ShowHide

//KD 2006-0822 added common function to show/hide an html element based on a bool passed in
function imod_ForceShowHide(bShow, sPrmId)
{
	var element = document.getElementById(sPrmId);
	if (element && element.style)
	{
		if (bShow)
			element.style.display = '';
		else
			element.style.display = 'none';
	}
}

function imod_ToggleDisplay(sPrmId)
{
	var element = document.getElementById(sPrmId);
	if (element && element.style)
	{
		if (element.style.display == 'none')
			element.style.display = '';
		else
			element.style.display = 'none';
	}
}

// JP 2006-0818 - calls stripID with current URL
function stripQueryStringID(prmKey) {
    var currentURL = window.location.href;
    if (currentURL.indexOf(prmKey) > -1) {
        currentURL = stripID(prmKey, currentURL);
    }
    return currentURL;
}

// JP 2006-0818 - given a key and string, finds QS key within string and removes it, returning modified string
function stripID(prmKey, prmRemoveItFrom) {
    var retString = prmRemoveItFrom

    if (prmKey && prmRemoveItFrom) {
        var markerStart = prmRemoveItFrom.indexOf("&" + prmKey + "=");
        if (markerStart == -1) markerStart = prmRemoveItFrom.indexOf("?" + prmKey + "=");
        if (markerStart > -1) {
            var markerEnd = prmRemoveItFrom.indexOf("&", markerStart + 1);
            if (markerEnd > -1) {
                retString = prmRemoveItFrom.substring(0, markerStart) + prmRemoveItFrom.substring(markerEnd);
            }
            else {
                retString = prmRemoveItFrom.substring(0, markerStart);
            }
        }
    }

    return retString;
} // stripID

// KD 2006-0915 - the following 2 functions allow you to add a javascript file or css file to the head tag of the page
var arLoadedFiles = [];

function imod_LoadScriptFile(prmFullPath) {
	if (!arLoadedFiles[prmFullPath]) {
		var el = document.createElement("script");
		el.src = prmFullPath;
		el.type = "text/javascript";
		if (document.getElementsByTagName("head") && document.getElementsByTagName("head")[0]) {
			document.getElementsByTagName("head")[0].appendChild(el);
			arLoadedFiles[prmFullPath] = true;
		}
		el = null;
	}
}


function imod_LoadStyleFile(prmFullPath) {
	if (!arLoadedFiles[prmFullPath]) {
		var el = document.createElement("link");
		el.href = prmFullPath;
		el.rel = "stylesheet";
		el.type = "text/css";
		if (document.getElementsByTagName("head") && document.getElementsByTagName("head")[0]) {
			document.getElementsByTagName("head")[0].appendChild(el);
			arLoadedFiles[prmFullPath] = true;
		}
		el = null;
	}
}

imod.General.divDarkScreen = null;

imod.General.DarkScreen = function (iPrmOpacity, sPrmColor, iPrmZIndex) {
	if (!imod.General.divDarkScreen) {
		imod.General.divDarkScreen = document.createElement("div");
		imod.General.divDarkScreen.style.display = "none";
		imod.General.divDarkScreen.style.background = "#000";
		imod.General.divDarkScreen.style.opacity = .5;
		imod.General.divDarkScreen.style.filter = "alpha(opacity=50)";

		//imod.General.divDarkScreen.style.opacity = 0;
		//imod.General.divDarkScreen.style.filter = "alpha(opacity=0)";

		//pdavis 3/4/2011: Added ID to DarkScreen so it can be accessed and resized: ENC-2062
		imod.General.divDarkScreen.setAttribute("id", "divDarkScreen");

		imod.General.divDarkScreen.style.zIndex = 1000;
		imod.General.divDarkScreen.style.position = "absolute";
		imod.General.divDarkScreen.style.left = "0px";
		imod.General.divDarkScreen.style.top = "0px";
		document.body.appendChild(imod.General.divDarkScreen);
	}
	if (iPrmOpacity)
		imod.dom.SetOpacity(imod.General.divDarkScreen, iPrmOpacity);
	if (sPrmColor)
		imod.General.divDarkScreen.style.background = sPrmColor;
	if (iPrmZIndex)
		imod.General.divDarkScreen.style.zIndex = iPrmZIndex;

	imod.General.divDarkScreen.style.width = document.body.scrollWidth + "px";

	//I don't know what this height thing did but removing the check fixed some stuff so if you find something with a weird shaped background div then we will have to come back to this
	//if (document.body.scrollHeight > 1) {
	//	imod.General.divDarkScreen.style.height = document.body.scrollHeight + "px";
	//}
	//else {
		imod.General.divDarkScreen.style.height = imod.Browser.ClientHeight() + "px";
	//}


	imod.General.divDarkScreen.style.display = "block";
	//imod.General.DarkScreenOpacity = 0;
	//imod.General.DarkScreenThreadPointer = setInterval(imod.General.DarkScreenThread, 30);
}

imod.General.DarkScreenOpacity = 0;
imod.General.DarkScreenThreadPointer = 0;

imod.General.DarkScreenThread = function() {
	imod.General.DarkScreenOpacity += .01;
	imod.dom.SetOpacity(imod.General.divDarkScreen, imod.General.DarkScreenOpacity);
	if (imod.General.DarkScreenOpacity >= .5)
		clearInterval(imod.General.DarkScreenThreadPointer);
		
}

imod.General.NormalScreen = function() {
	if (imod.General.divDarkScreen)
		imod.General.divDarkScreen.style.display = "none";
}

imod.dom.Hide = function (el) {
	var o;
	if (el) {
		o = (el.style != null) ? el : imod$(el);
		if (o)
			o.style.display = "none";
	}

}

imod.dom.Show = function (el, s) {
	var o;
	if (el) {
		o = (el.style != null) ? el : imod$(el);
		if (o)
			o.style.display = (s != null) ? s : "";
	}
}

imod.dom.GetComputedStyle = function (el, p) {
	if (window.getComputedStyle)
		return window.getComputedStyle(el, null).getPropertyValue(p);
	if (el.currentStyle) {
		return el.currentStyle[p];
	}
	return;

}


//Adds trim function to the string object
String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };

String.concat = function() {
	var s = new Array(arguments.length);
	for (var i = 0; i < arguments.length; i++)
		s[i] = arguments[i];
	return s.join("");
}

imod.dom.AddHandler = imod_AddHandler;
imod.dom.RemoveHandler = imod_RemoveHandler;
imod.dom.StopPropagation = imod_StopPropagation;
imod.dom.OffsetTop = imod_OffsetTop;
imod.dom.OffsetLeft = imod_OffsetLeft;
imod.dom.MakePixel = imod_Pixel;
imod.dom.GetElementsByTagNames = imod_GetElementsByTagNames;
imod.dom.SetOpacity = imod_SetOpacity;
imod.dom.CreateElement = imod_CreateElement;
imod.dom.LoadScriptFile = imod_LoadScriptFile;
imod.dom.LoadStyleFile = imod_LoadStyleFile;

imod.Browser.MouseX = imod_MouseX;
imod.Browser.MouseY = imod_MouseY;
imod.Browser.ClientWidth = imod_ClientWidth;
imod.Browser.ClientHeight = imod_ClientHeight;
imod.Browser.OpenWindow = imod_OpenWindow;
imod.Browser.OpenFullWindow = function(sPrmUrl) {
	imod.Browser.OpenWindow(sPrmUrl, 0, 0, "location=yes,menubar=yes,toolbar=yes,directories=yes,status=yes,scrollbars=yes,resizable=yes", 3);
}
imod.Browser.DocumentScrollLeft = imod_DocumentScrollLeft;
imod.Browser.DocumentScrollTop = imod_DocumentScrollTop;
imod.Browser.GetCookie = imod_GetCookie;
imod.Browser.SetCookie = imod_SetCookie;

imod.Form.GetRadioButtonValue = imod_GetRadioButtonValue;
imod.Form.SelectText = imod_SelectText;

imod.General.ParseInt = imod_ParseInt;

imod.Fancy.SetTableRowBackgroundColors = imod_SetTableRowBackgroundColors;


imod.dom.AddHandler(window, "load", function() { window.loaded = true; });
imod_RemoveHandlersOnUnload();


if (!imod.Security) imod.Security = {};

imod.Security.Logout = function (logoutUrl, authenticationTicket, siteId, groupId) {

	if (window.console) console.log('authenticationTicket:' + authenticationTicket);

	jQuery.ajax({
		type: "POST",
		url: "/controls/login/AuthenticationService.asmx/Logout",
		data: Sys.Serialization.JavaScriptSerializer.serialize({ "sid": siteId, "gid": groupId, "authenticationTicket": authenticationTicket }),
		contentType: "application/json; charset=utf-8",
		dataFilter: function (data) {
			// This boils the response string down
			//  into a proper JavaScript Object().
			var result = eval('(' + data + ')');
			// If the response has a ".d" top-level property,
			//  return what's below that instead.
			if (result.hasOwnProperty('d'))
				return result.d;
			else
				return result;
		},
		success: function (result) {
			// This will now output the same thing
			//  across any current version of .NET.
			if (window.console) console.log(result.ReturnUrl);

			if (window.parent) {
				window.parent.location = result.ReturnUrl;
			}
			else {
				window.location = result.ReturnUrl;
			}			
		},
		error: function (xhr, textStatus, errorThrown) {
			if (textStatus !== null) {
				alert("error: " + textStatus);
			} else if (errorThrown !== null) {
				alert("exception: " + errorThrown.message);
			}
			else {
				alert("error");
			}
		},
		complete: function (data) {
			//alert('complete');
		}
	});
}

//**DO NOT PUT ANYTHING BELOW THIS LINE**
}
else {
	if (imod.Trace) imod.Trace.Warn("imodules_common loaded multiple times.  Remove the duplicate reference(s)");
}

