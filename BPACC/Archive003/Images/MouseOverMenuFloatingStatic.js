var left = (txtMenuType.substring(txtMenuType.length - 1) == 'R');
var sidebarmenuPopout = (SideBarPopout.toLowerCase());
var currentMenu = false;
var iTimeoutID;
var side;
var removeImage = function () { };

if (window.ActiveXObject)
	window.ie = window[window.XMLHttpRequest ? 'ie7' : 'ie6'] = true;
else if (document.childNodes && !document.all && !navigator.taintEnabled)
	window.khtml = true;
else if (document.getBoxObjectFor != null)
	window.gecko = true;

function addSubMenuTop(obj, btm_img)
{
	clearTimeout(iTimeoutID);

	if (currentMenu && currentMenu != obj)
		hideNav(currentMenu);

	currentMenu = obj;

	if (menuLevelTop == 0)
		return;

	side = false;

	var el = document.getElementById('navTopWrapper');
	if (el)
		el.parentNode.removeChild(el);

	var fakeId = obj.id.replace(/t|s|sub/i, '');

	if(menus[fakeId])
	{
		var objPos = getElementPosition(obj);
		var elTop = objPos.top;
		var elLeft = objPos.left;
		var trueHeight = (obj.firstChild.firstChild.height > 0 && !window.opera) ? obj.firstChild.firstChild.height : (obj.offsetHeight == 0) ? obj.parentNode.offsetHeight : obj.offsetHeight;
		var opOffset = ysnHorizontal ? obj.offsetWidth + intSubMenuXRelative2 : 0;

		var wrapper = document.createElement('div');
		wrapper.id = 'navTopWrapper';
		wrapper.level = 1;

		wrapper.className = 'wrapper';
		if (intMenuHeightLevel >= 1) wrapper.className += '  wrapperHeight';
		if (intMenuWidthLevel >= 1) wrapper.className += ' wrapperWidth';

		var elStyle = wrapper.style;
		//this is added to fix the menu display issue(overlaping) in safari
		var topStyle = ysnHorizontal ? (elTop + intSubMenuYRelative2) : (elTop + trueHeight);
		if (/Safari/.test(navigator.userAgent))
			topStyle = topStyle + 15;
		topStyle += 'px';

		elStyle.top = topStyle;
		elStyle.left = (elLeft + opOffset) + 'px';

		wrapper.innerHTML = menus[fakeId].replace(/&lt;/g, "<").replace(/&gt;/g, ">");

		document.getElementById("floating").appendChild(wrapper);

		if ((window.khtml) && (intMenuHeightLevel >= 1) && (wrapper.offsetHeight < intPopupMenuHeight2)) wrapper.style.height = intPopupMenuHeight2 + 'px';

		if (btm_img) 
		{
			var imgWrapper = document.createElement('div');
			imgWrapper.className = 'imgWrapper';
			imgWrapper.innerHTML = '<img class = "btmImage" src = "' + btm_img + '">';
			wrapper.appendChild(imgWrapper);
			elStyle.borderBottom = 'none';
			imgWrapper.style.top = wrapper.clientHeight + 'px';
		}
		popupDelay2 ? iTimeoutID = setTimeout(function () { elStyle.visibility = 'visible'; }, popupDelay2) : elStyle.visibility = 'visible';

		if (isie6) hideSelect();
	}
}

function addSubMenuSide(obj)
{
	clearTimeout(iTimeoutID);

	removeImage();

	var el = document.getElementById('navTopWrapper');
	if (el) el.parentNode.removeChild(el);

	if (currentMenu && currentMenu != obj) hideNav(currentMenu);
	currentMenu = obj;

	if (menuLevelSide == 0) return;

	side = true;

	if (obj.children.length > 1 && obj.children[1] != null && obj.children[1].src != null) {
		var fileName = obj.children[1].src;
		fileName = fileName.substring(fileName.lastIndexOf("/") + 1, fileName.lastIndexOf("."));
		var fileNameMO = fileName + "MO";
		if (fileName.indexOf("MO") > -1)
			fileNameMO = fileName.substring(0, fileName.length - 2);
		obj.children[1].src = obj.children[1].src.replace(fileName, fileNameMO);
	}
	obj.style.zIndex = 1000;

	var wrapper = document.createElement('div');
	wrapper.level = 1;
	wrapper.id = 'navSideWrapper';
	wrapper.className = 'wrapper';
	if (intPopupMenuHeightLevels >= 1) wrapper.className += '  intPopupMenuHeight';
	if (intPopupMenuWidthLevels >= 1) wrapper.className += ' intPopupMenuWidth';

	drawMenu(obj, wrapper, (intSubMenuXRelative + 2), obj.parentNode);
}

function addSubMenu(obj)
{
	clearTimeout(iTimeoutID);

	var parent = obj.parentNode;
	var offset = side ? intSecondaryMenuXRelative : intSecondaryMenuXRelative2;

	var children = parent.childNodes;
	var nodes = children.length;
	for (var i = 0; i < nodes; i++) if (children[i] != obj) hideNav(children[i]);

	if ((side ? (parent.level >= menuLevelSide) : (parent.level >= menuLevelTop))) return;

	obj.style.zIndex = 1000;

	if (obj.children.length > 1 && obj.children[1] != null && obj.children[1].src != null) {
		obj.children[1].src = obj.children[1].src.replace("SubMenuIndicatorArrow", "SubMenuIndicatorArrowMouseover");
	}

	var wrapper = document.createElement('div');
	wrapper.level = (parent.level + 1);

	wrapper.className = 'wrapper';

	if(side)
	{
		if (intPopupMenuHeightLevels > parent.level) wrapper.className += '  intPopupMenuHeight';
		if (intPopupMenuWidthLevels > parent.level) wrapper.className += ' intPopupMenuWidth';
	}
	else
	{
		if (intMenuHeightLevel > parent.level) wrapper.className += '  wrapperHeight';
		if (intMenuWidthLevel > parent.level) wrapper.className += ' wrapperWidth';
	}

	drawMenu(obj, wrapper, offset, parent);
}

function drawMenu(obj, wrapper, offset, parent)
{	   
	var fakeId = obj.id.replace(/t|sub|s/i, '');
	var linkMenuLevel = 0;
	if (!menus[fakeId] || (obj.lastChild.className && obj.lastChild.className.indexOf('wrapper') != -1)) return;
	if (menus[fakeId].indexOf('<customTag') != -1) {
		linkMenuLevel = (menus[fakeId].substr(menus[fakeId].indexOf('<customTag menuLevel=') + 21, 2));
		menus[fakeId] = menus[fakeId].replace(menus[fakeId].substring(menus[fakeId].indexOf('<customTag menuLevel=')), menus[fakeId].substring(menus[fakeId].indexOf('</customTag>') + 12), '');
	}
	if (parseInt(linkMenuLevel) == menuLevelTop - 1) {
		while (menus[fakeId].indexOf('/images/layout/design21/SubMenuIndicator.png') != -1) {
			menus[fakeId] = menus[fakeId].replace("<img alt=\"right arrow\" src=\"/images/layout/design21/SubMenuIndicator.png\">", "");
		}
	}

	if ($.trim(menus[fakeId]) == "undefined") return;

	wrapper.innerHTML = menus[fakeId].replace(/&lt;/g, "<").replace(/&gt;/g, ">");
	wrapper.border = true;

	obj.appendChild(wrapper);

	var elStyle = wrapper.style;
	var elClientTop = side ? intOuterMOMBorderSize : intOuterMOMBorderSize2;
	var padding = side ? intSecondSidePadding : intSecondSidePadding2;
	var elWidth = wrapper.offsetWidth;
	var parentWidth = (window.ie6 && wrapper.level > 1) ? (wrapper.parentNode.offsetWidth - padding) : wrapper.parentNode.offsetWidth;

	if (!window.ie6) elStyle.width = elWidth + 'px';
	if (parent.left) wrapper.left = true;

	if ((sidebarmenuPopout == "left" && side && !parent.bounce) || obj.parentNode.left) {
		if (window.ie6 && wrapper.level > 1) parentWidth += (padding);
		elStyle.right = (parentWidth + offset) + 'px';
	}
	else elStyle.left = (parentWidth + offset) + 'px';

	if(window.khtml)
	{
		var height = side ? intPopupMenuHeight : intPopupMenuHeight2;
		var level = side ? intPopupMenuHeightLevels : intMenuHeightLevel;
		if ((level >= wrapper.level) && (wrapper.offsetHeight < height)) wrapper.style.height = height + 'px';
	}

	if(side ? ysnMenuBounce : ysnMenuBounce2)
	{	  
		if (parent.bounce) wrapper.bounce = true;
		var elLeft = getElementPosition(wrapper).left;
		elStyle.display = 'none';
		var winWidth = getWidth();
		var winHeight = getHeight();
		var scrollTop = getScrollTop();
		var scrollLeft = getScrollLeft();

		if(((winWidth + scrollLeft - elLeft - elWidth) <= 5) && ((elLeft - elWidth) > 0))
		{
			elStyle.left = '';
			if (window.ie6) elStyle.left = '-' + (padding + elWidth) + 'px';
			else elStyle.right = (parentWidth + offset) + 'px';
			wrapper.left = true;

			if (left && side) wrapper.bounce = false;
			else wrapper.bounce = true;
		}
		else if ((elLeft - scrollLeft) <= 5 && (obj.parentNode.left || (sidebarmenuPopout == "left" && side)))
		{	
			elStyle.right = '';
			wrapper.left = '';

			if (window.ie6 && !left) parentWidth = parentWidth - padding;
			elStyle.left = (parentWidth + offset) + 'px';

			if (sidebarmenuPopout == "left" && side) wrapper.bounce = true;
			else wrapper.bounce = false;
		}
		if(wrapper.bounce)
		{
			if (wrapper.className.indexOf('wrapperHeight') != -1 && !side) wrapper.className += ' bounceHeight';
			wrapper.className += ' bounce';
			var children = wrapper.getElementsByTagName('A');
			var nodes = children.length;
			for (var i = 0; i < nodes; i++) if (children[i].className == 'SubCat') children[i].className += ' bounce';

			children = wrapper.getElementsByTagName('SPAN');
			nodes = children.length;
			for (var i = 0; i < nodes; i++) if (children[i].className == 'SubCatGroup') children[i].className += ' bounce';

			children = wrapper.getElementsByTagName('DIV');
			nodes = children.length;
			for (var i = 0; i < nodes; i++) children[i].className += ' bounceItem';
		}
		elStyle.display = 'block';
		var elTop = (getElementPosition(wrapper).top - scrollTop);
		var elHeight = (wrapper.offsetHeight);
		elStyle.display = 'none';
		if (!side) elTop += elClientTop;
		if (((winHeight - elTop - elHeight) < 10) && (elHeight < winHeight)) elStyle.top = (winHeight - elTop - elHeight - 10) + 'px';
		elStyle.display = 'block';
	}
	(popupDelay && wrapper.level == 1) ? iTimeoutID = setTimeout(function () { elStyle.visibility = 'visible'; }, popupDelay) : elStyle.visibility = 'visible';

	if (isie6) hideSelect();
}

function removeSubMenu(obj) {
	if (obj.children.length > 1 && obj.children[1] != null && obj.children[1].src != null) {
		var fileNameMO = obj.children[1].src;
		fileNameMO = fileNameMO.substring(fileNameMO.lastIndexOf("/") + 1, fileNameMO.lastIndexOf("."));
		var fileName = "";
		if (fileNameMO.indexOf("MO") > -1)
			fileName = fileNameMO.substring(0, fileNameMO.length - 2);
		else
			fileName = fileNameMO;
		obj.children[1].src = obj.children[1].src.replace(fileNameMO, fileName);
	}
	clearTimeout(iTimeoutID);
	iTimeoutID = setTimeout(function () { if (!side) removeNavWrapper(); else hideNav(obj); if (isie6) showSelect(); }, side ? popdownDelay : popdownDelay2);
}

function removeNavWrapper()
{
	var el = document.getElementById('navTopWrapper');
	if (el) { el.parentNode.removeChild(el); removeImage(); }
	else removeImage();
}

function hideNav(obj)
{
	if (obj.className.indexOf('navText') != -1) obj.style.zIndex = 999;
	var el;
	if (el = obj.lastChild) if (el.className && el.className.indexOf('wrapper') != -1) obj.removeChild(el);
}

function hideSelect() 
{
	var x = document.getElementsByTagName('select');
	var nodes = x.length;
	for (var i = 0; i < nodes; i++) if (x.item(i).className != 'dontHide') x.item(i).style.visibility = 'hidden';
}

function showSelect() 
{
	var x = document.getElementsByTagName('select');
	var nodes = x.length;
	for (var i = 0; i < nodes; i++) x.item(i).style.visibility = 'visible';
}

function getElementPosition(offsetTrail) 
{
	var offsetLeft = 0;
	var offsetTop = 0;
	el = offsetTrail;
	while (offsetTrail) 
	{
		offsetLeft += offsetTrail.offsetLeft;
		offsetTop += offsetTrail.offsetTop;
		if(!window.opera && !window.khtml && offsetTrail.className.indexOf('wrapper') != -1 && offsetTrail.border) 
		{
			var elClientTop = offsetTrail.bounce ? side ? intOuterMOMBorderSizeb : intOuterMOMBorderSize2b : side ? intOuterMOMBorderSize : intOuterMOMBorderSize2;
			offsetLeft += elClientTop;
			offsetTop += elClientTop;
		}
		offsetTrail = offsetTrail.offsetParent;
	}

	if (window.gecko) {
		while (el) {
			if (el.style && el.style.marginTop) {
				margin = el.style.marginTop;
				margin = margin.substr(0, (margin.length - 2));
				if (el.offsetTop == margin) offsetTop = (offsetTop - margin);
			}
			el = el.parentNode;
		}
	}
	if (window.khtml && document.body.topMargin && document.body.leftMargin)
	{
		offsetLeft += document.body.leftMargin;
		offsetTop += document.body.topMargin;
	}
	if (window.khtml && intSubMenuY != 0) offsetTop += intSubMenuY;
	return { left: offsetLeft, top: offsetTop };
}

function getScrollLeft()
{
	return this.pageXOffset || document.documentElement.scrollLeft;
}

function getScrollTop()
{
	return this.pageYOffset || document.documentElement.scrollTop;
}

function getWidth()
{
	if (this.khtml) return this.innerWidth;
	if (this.opera) return document.body.clientWidth;
	return document.documentElement.clientWidth;
}

function getHeight()
{
	if (this.khtml) return this.innerHeight;
	if (this.opera) return document.body.clientHeight;
	return document.documentElement.clientHeight;
}
function sideBarMouseOut(obj) {
	obj.className = '';
	if (obj.children[0].children[1] != null && obj.children[0].children[1].src != null) {
		var fileNameMO = obj.children[0].children[1].src;
		fileNameMO = fileNameMO.substring(fileNameMO.lastIndexOf("/") + 1, fileNameMO.lastIndexOf("."));
		var fileName = "";
		if (fileNameMO.indexOf("MO") > -1)
			fileName = fileNameMO.substring(0, fileNameMO.length - 2);
		else
			fileName = fileNameMO;
		obj.children[0].children[1].src = obj.children[0].children[1].src.replace(fileNameMO, fileName);
	}
}