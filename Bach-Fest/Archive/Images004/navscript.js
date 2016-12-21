var objNavMenu = null;
var prevObjNavMenu = null;
var prevObjDropMenu = null;
var numDropMenu = 10;
////// link styles
var bgLinkColor = '#ffffff';
var bgLinkHover = '#000080'
var bgLinkActive = '#000080'
var linkColor = '#000080'
var linkHover = '#ffffff'
var linkActive = '#ffffff'
			
var isIE = null;
if (navigator.appName.indexOf('Microsoft Internet Explorer') != -1) isIE=1;

function initDropMenu () {
	document.onclick = hideDropMenu;
		for (i=1; i<=numDropMenu; i++) {
		menuName = 'dropMenu' + i;
		navName = 'navMenu' + i;
		objDropMenu = document.getElementById(menuName);
		objNavMenu = document.getElementById(navName);
		objDropMenu.style.visibility = 'hidden';
		objNavMenu.onmouseover =  menuHover;
		objNavMenu.onmouseout = menuOut;
		objNavMenu.onclick = showDropMenu;
	}
	objNavMenu = null;
	return;
}

function  menuHover(e) {
	document.onclick = null;
	hoverObjNavMenu = document.getElementById(this.id);
	if (hoverObjNavMenu != objNavMenu) {
		hoverObjNavMenu.style.color = linkHover;
		hoverObjNavMenu.style.backgroundColor = bgLinkHover;
	}		
}
			
function menuOut (e) {
	document.onclick = hideDropMenu;
	outObjNavMenu = document.getElementById(this.id);
	if (outObjNavMenu != objNavMenu) {
		outObjNavMenu.style.color = linkColor;
		outObjNavMenu.style.backgroundColor = bgLinkColor;
	}
}
			
function showDropMenu(e) {
	menuName = 'drop' + this.id.substring(3,this.id.length);
	objDropMenu = document.getElementById(menuName);
	if (prevObjDropMenu == objDropMenu) {
		hideDropMenu();
		return;
	}
	if (prevObjDropMenu != null) hideDropMenu();
		objNavMenu = document.getElementById(this.id);
		if ((prevObjNavMenu != objNavMenu ) || (prevObjDropMenu == null)) {
			objNavMenu.style.color = linkActive;
			objNavMenu.style.backgroundColor = bgLinkActive;
	}
				
	if (objDropMenu) {
		xPos = objNavMenu.offsetParent.offsetLeft + objNavMenu.offsetLeft;
		yPos = objNavMenu.offsetParent.offsetTop + objNavMenu.offsetParent.offsetHeight;
		if (isIE) {
			yPos -= 1;
			xPos -= 6;
		}
		objDropMenu.style.left = xPos + 'px';
		objDropMenu.style.top = yPos + 'px';
		objDropMenu.style.visibility = 'visible';
		prevObjDropMenu = objDropMenu;
		prevObjNavMenu = objNavMenu;
	}
			
}
			
function hideDropMenu() {
	document.onclick = null;
	if (prevObjDropMenu) {
		prevObjDropMenu.style.visibility = 'hidden';
		prevObjDropMenu = null;
		prevObjNavMenu.style.color = linkColor;
		prevObjNavMenu.style.backgroundColor = bgLinkColor;
	}
	objNavMenu = null;
}