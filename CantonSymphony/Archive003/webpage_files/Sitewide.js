
//------------------------------------------------------------------------------

// function showElement(): Generic function that shows the HTML element with ID str_id
function showElement(str_id, bln_useVis)
{
	if (bln_useVis) {
		document.getElementById(str_id).style.visibility = "visible";
	} else {
		document.getElementById(str_id).style.display = "block";
	}
}

//------------------------------------------------------------------------------

// function hideElement(): Generic function that hides the HTML element with ID str_id
function hideElement(str_id, bln_useVis)
{
	//if (bln_useVis) {
	//	document.getElementById(str_id).style.visibility = "hidden";
	//} else {
		document.getElementById(str_id).style.display = "none";
	//}
}

//------------------------------------------------------------------------------

// function toggleElement(): Generic function that hides/shows the HTML element with ID str_id
function toggleElement(str_id, bln_useVis)
{
	var obj_elem = document.getElementById(str_id);
	//alert(obj_elem.style.display.toString() + "," + obj_elem.style.visibility.toString());
	//if ((!bln_useVis && obj_elem.style.display != "block") || (bln_useVis && obj_elem.style.visibility != "visible"))
	if (obj_elem.style.display != "block") {
		showElement(str_id,false);
		return true;
	} else {
		hideElement(str_id,false);
		return false;
	}
}

//------------------------------------------------------------------------------
// function fontAdjust: Adjusts the pixel size of the page's main content text by specified interval
function fontAdjust(int_adjust)
{
	if (int_adjust != undefined) {
		var obj_pagetext = document.getElementById("pagetext");
		var int_textsize = (obj_pagetext.style.fontSize != '' ? Number(String(obj_pagetext.style.fontSize).replace("px","")) : 12 );
	
		int_textsize = Number(int_textsize) + int_adjust;
		int_textsize = (int_textsize < 2 ? 2 : int_textsize);
		obj_pagetext.style.fontSize = int_textsize + "px";
	}

	return false;
}

//------------------------------------------------------------------------------
// function bookmarkPage: Detects browser and then saves current page as bookmark accordingly
function bookmarkPage(str_desc)
{
	var str_url = window.location.href;
	//alert(str_url);
	if (window.sidebar) {
		//alert("Firefox bookmarking");
		window.sidebar.addPanel(str_desc,str_url,"");
	} else if (window.external) {
		//alert("IE bookmarking");
		window.external.AddFavorite(str_url,str_desc);
	} else {
		alert("Press CTRL-D (Netscape) or CTRL-T (Opera) to bookmark");
	}
}

//------------------------------------------------------------------------------
// function showSideMenu: Handler for onclick() event of layout_frame template's "Show Menu"/"Hide Menu" link
function showSideMenu(str_menuid, str_containerid, str_centered, obj_link)
{
	var bln_vis = toggleElement(str_menuid);
	var obj_container = document.getElementById(str_containerid);
	var obj_centered  = document.getElementById(str_centered);
	if (bln_vis) {
		obj_container.className = "left_menu_border";
		obj_centered.style.width = "960px";
		obj_link.innerHTML = "Hide Menu";
	} else {
		obj_container.className = "";
		obj_centered.style.width = "";
		obj_link.innerHTML = "Show Menu";
	}
}

//------------------------------------------------------------------------------
// function setCookie: (from w3schools.com) 
function setCookie(str_name, str_value, int_expiredays)
{
	var obj_exdate = new Date();
	obj_exdate.setTime(obj_exdate.getTime() + (int_expiredays*24*3600*1000));
	document.cookie = str_name + "=" + escape(str_value) + ((int_expiredays==null) ? "" : ";expires="+obj_exdate);
}

//------------------------------------------------------------------------------
// function getCookie: (from w3schools.com)
function getCookie(str_name)
{
	if (document.cookie.length > 0) {
		var int_start = document.cookie.indexOf(str_name + "=");
		if (int_start != -1) { 
			int_start = int_start + str_name.length + 1; 
			var int_end = document.cookie.indexOf(";", int_start);
			if (int_end == -1) {
				int_end = document.cookie.length;
			}
			return unescape(document.cookie.substring(int_start, int_end));
		} 
	}
	return null;
}

//------------------------------------------------------------------------------
// function printPageCSS: handler for page utility 'print page'; temporarily sets 
//  a flag in a cookie to force smarty use the layout_print.css stylesheet
function printPageCSS()
{
	setCookie("printPageCSS",1,1);
	var obj_ppc = window.open(window.location, "printPageCSS");
	obj_ppc.focus();
}

//------------------------------------------------------------------------------
// function printPage: handler for page utility 'print page'
function printPage()
{
	window.print();
	return false;
}

//==============================================================================
// Suckerfish menu preparation for IE, found on htmldog.com
var sfHover = function() {
//	alert("attaching onmouseovers");
	// Retrieve the top level dropdown menu list object
	var sfEls = document.getElementById("dm_toplevel");
	if (sfEls) {
		sfEls = sfEls.getElementsByTagName("LI");
		// For each list item in the top level list...
		for (var i = 0; i < sfEls.length; i++) {
			// Set the mouseover action to add the sfhover class
			sfEls[i].onmouseover = function() {
				this.className += " sfhover";
			};
			// Set the mouseout action to remove the sfhover class
			sfEls[i].onmouseout = function() {
				this.className = this.className.replace(new RegExp(" sfhover\\b"), "");
			};
		}
	}
};

//----------------------------------------------------------------------

// Function to load PHIZ in it's own window to give it an 'Application' feel.
function loadPhiz(obj_form)
{
	var get_val = null;
	if (obj_form) {
		get_val = "phiz.php?name_first=" + document.getElementById('name_first').value + "&name_last=" + document.getElementById('name_last').value + "&group_id=" + document.getElementById('group_id').value;
	} else {
		get_val = "phiz.php";
	}
	
	try {
		var dom_phizWin = window.open('/modules/phiz/' + get_val,'phizWin','toolbar=no,location=no,directories=no,status=no,menubar=no,copyhistory=no');
		//alert('/modules/phiz/' + get_val);
	//	window.name="PHIZ";
		if (!dom_phizWin) {
			alert("There was an error while trying to open PHIZ in another window. Please check that your browser is not blocking popup windows.");
		} else {
			dom_phizWin.focus();
		}
		dom_phizWin.moveTo(0, 0);
		dom_phizWin.resizeTo(screen.width, screen.height);
	} catch(obj_err) { alert("There was an error while trying to oen PHIZ in another window. Please check that your browser is not blocking popup windows."); }
	
	return false;
}
// Set the onload event for the page to be this sfHover function
if (window.attachEvent) {
	window.attachEvent("onload", sfHover);
}
// End Suckerfish prep
//==============================================================================

// Initialization of printPageCSS cookie...
setCookie("printPageCSS", 0, -1);
