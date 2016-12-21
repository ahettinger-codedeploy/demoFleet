var MenuHasBeenClicked = false;
var NumMenus = 0;
var MenuNamePrefix = "";
function getRealCoords(uEleObj,uEleAxis){
	var uTempObj,uEleObj,uEleAxis;
	(uEleAxis=="x") ? uElePos = uEleObj.offsetLeft : uElePos = uEleObj.offsetTop;
	uTempObj = uEleObj.offsetParent;
	while(uTempObj != null){
		uElePos += (uEleAxis=="x") ? uTempObj.offsetLeft : uTempObj.offsetTop;
		uTempObj = uTempObj.offsetParent;
	}
	return uElePos;
}
//get real coords function
function SAVEgetRealCoords(uEleObj,uEleAxis){
	var uTempObj,uEleObj,uEleAxis;
	(uEleAxis=="x") ? uElePos = uEleObj.offsetLeft : uElePos = uEleObj.offsetTop;
	uTempObj = uEleObj.offsetParent;
	while(uTempObj != null){
		uElePos += (uEleAxis=="x") ? uTempObj.offsetLeft : uTempObj.offsetTop;
		uTempObj = uTempObj.offsetParent;
	}
	return uElePos;
}

function SetupMenu(num, prefix)
{
	NumMenus = num;
	MenuNamePrefix = prefix;
	//y =  getRealCoords(mark,"y");
	//x =  getRealCoords(mark,"x") ;
//	var mark = document.getElementById('MenuMarker');
//	x = mark.offsetLeft;
//	y = mark.offsetTop + mark.offsetParent.offsetTop; 
//	var obj = document.getElementById('MenuSpan');
//	obj.style.position = "absolute";
//	obj.style.left = x + "px";
//	obj.style.top = y + "px";
//	obj.style.zIndex = 0;
//	obj.style.display = "block";
}

function MenuMouseOver(id, td_obj)
{
	if (MenuHasBeenClicked) return;
	HideAllMenus();
	var obj = document.getElementById(id);
	y =  getRealCoords(td_obj,"y");
	x =  getRealCoords(td_obj,"x")  ;
	obj.style.visibility = "visible";
	obj.style.display = "block";
	obj.style.position = "absolute";
	obj.style.left = x + "px";
	obj.style.top = (y - 10) + "px";
	obj.style.zIndex = 10;
	td_obj.className = 'menuHoverClass';
	var close_obj = document.getElementById('CloserLayer');
	close_obj.style.visibility="visible";
}
function TEST()
{
	var coordinates = new Object();
	coordinates = getAnchorPosition("small_menu");
	var obj = document.getElementById("menu1");
	obj.style.visibility = "visible";
	obj.style.display = "block";
	obj.style.position = "absolute";
	obj.style.left = coordinates.x + "px";
	obj.style.top = coordinates.y + "px";
	obj.style.zIndex = 10;
}
function switchMenu(id, target_name)
{
	if (MenuHasBeenClicked) return;
	for (var i=1; i<=NumMenus; i++)
	{
		var menu = document.getElementById(MenuNamePrefix+i);
		if (menu != null) menu.style.visibility = "hidden";
	}
	var coordinates = new Object();
	coordinates = getAnchorPosition(target_name);
	var obj = document.getElementById(id);
	obj.style.visibility = "visible";
	obj.style.display = "block";
	obj.style.position = "absolute";
	obj.style.left = coordinates.x + "px";
	obj.style.top = coordinates.y + "px";
	obj.style.zIndex = 10;
}
function MenuMouseOver_Name(id, target_name)
{
	if (MenuHasBeenClicked) return;
	HideAllMenus();
	var coordinates = new Object();
	coordinates = getAnchorPosition(target_name);
	var obj = document.getElementById(id);
	obj.style.visibility = "visible";
	obj.style.display = "block";
	obj.style.position = "absolute";
	obj.style.left = coordinates.x + "px";
	obj.style.top = coordinates.y + "px";
	obj.style.zIndex = 10;
	var td_obj = document.getElementById(target_name);
	td_obj.className = 'menuHoverClass';
	var close_obj = document.getElementById('CloserLayer');
	close_obj.style.visibility="visible";
}

function MenuClick(url)
{
	if (url != null && url.length > 0)
	{
		MenuHasBeenClicked = true;
		document.location = url;
	}
}

function MenuItemMouseOver(td_obj, span_id)
{
	if (MenuHasBeenClicked) return;
	td_obj.className = 'itemHighlight';
	var span = document.getElementById(span_id);
	span.innerHTML = "&nbsp;&nbsp;" + MenuMarkerHTML;
}

function MenuItemMouseOut(td_obj, span_id)
{
	if (MenuHasBeenClicked) return;
	td_obj.className = '';
	var span = document.getElementById(span_id);
	span.innerHTML = "";
}

function MenuMouseOut(id, td_obj)
{
	if (MenuHasBeenClicked) return;
	var obj = document.getElementById(id);
	td_obj.className = 'menuClass';
}

function HideAllMenus()
{
	if (MenuHasBeenClicked) return;
	if (typeof(NumMenus) == "undefined") return;
	if (typeof(MenuNamePrefix) == "undefined") return;
	for (var i=1; i<=NumMenus; i++)
	{
		var menu = document.getElementById(MenuNamePrefix+i);
		if (menu != null) menu.style.visibility = "hidden";
		var close_obj = document.getElementById('CloserLayer');
		close_obj.style.visibility="hidden";
	}
}
