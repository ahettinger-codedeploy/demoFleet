function onHelp(helpId) {
	window.status = helpId;

	var w = 350;
	var h = 500;
	var l = (screen.availWidth/2) - (w/2);
	var t = (screen.availHeight/2) - (h/2);

	window.open('http://www.urj.com/help35/announcements/index.cfm?id=' + helpId,
	 			'kdhelp',
	 			'width=' + w + ',height=' + h + ',left=' + l + ',top=' + t + ',resizable,dependent,alwaysRaised,scrollbars');

	return false;
}

function showBusyMsg(m){
	busy();
}

/********************************************************************************

This file provides functions that are used by KD pages.  These are things like
the right click edit menus and the main admin bar.

*********************************************************************************/

//
// The following functions handle the right click edit menu options.
//
function onMove() {
	busy();
	//kdDialog(kdRelRoot + "PagePrograms/dialogs.cfm?dialog=Move&pge_id=" + kdPageId + "&pge_prg_id=" + ppr_id);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=position&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onMoveUp() {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&action=move&dir=up&returnto=" + escape(kdCurUrl);
}
function onMoveDown() {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&action=move&dir=down&returnto=" + escape(kdCurUrl);
}
function onMoveToRegion(region,subregion) {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&action=movetoregion&region=" + region + "&subregion=" + subregion + "&returnto=" + escape(kdCurUrl);
	return false;
}

function onOptions() {
	busy();
	//kdDialog(kdRelRoot + "PagePrograms/dialogs.cfm?dialog=Options&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=options&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onProperties() {
	busy();
	//kdDialog(kdRelRoot + "PagePrograms/dialogs.cfm?dialog=Rename&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=properties&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onDisplayMode() {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=display&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onSetDisplayMode(newmde) {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&action=updatedisplay&displaymode=" + escape(newmde) + "&returnto=" + escape(kdCurUrl);
}
function onStyleSheet() {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=stylesheet&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onSetStyleSheet(id) {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&action=updatestyles&style_id=" + id + "&returnto=" + escape(kdCurUrl);
}
function onContainer() {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=container&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}

function onData() {
	busy();
	//kdDialog(kdRelRoot + "PagePrograms/dialogs.cfm?dialog=Data&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=data&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onStyles() {
	busy();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=styles&sheet_id=" + sty_id;
}
function onContainerStyles() {
	busy(1);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=styles&objecttype=CNT&object_id=" + cnt_id;
}
function onRemove() {
	busy(1);
	onRemovePageProgram(kdPageId, pge_prg_id);
}
function onMinMax() {
	busy(1);
	onMinMaxPageProgram(kdPageId, pge_prg_id);
}
function onResetStyles() {
	if (confirm('Are you sure you want to reset this programs styles?')) {
		busy();
		window.location=kdRelRoot + "PagePrograms/actions.cfm?action=ResetStyles&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id;
	}
}
function onCopyToPage() {
	busy();
	window.location = kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=transfer&pge_id=" + kdPageId + "&mode=Copy&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onMoveToPage() {
	busy();
	window.location = kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=transfer&pge_id=" + kdPageId + "&mode=Move&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}
function onShare() {
	busy();
	window.location = kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=transfer&pge_id=" + kdPageId + "&mode=Share&pge_prg_id=" + pge_prg_id + "&returnto=" + escape(kdCurUrl);
}

function onAddProgram(region,subregion) {
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&page=add&pge_id=" + kdPageId + "&region=" + region + "&subregion=" + subregion + "&returnto=" + escape(kdCurUrl);
}

//
// Called when user requests to edit the current page
//
function kdEditPage() {
	busy(1);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pages&action=edit&id=" + kdPageId + "&returnto=" + escape(kdCurUrl);
}
		
//
// Called when the user requests to publish the current page.
//
function kdPublishChanges() {
	if (!confirm('Publish Changes?')) return false;

	busy(1);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pages&action=publish&id=" + kdPageId + "&returnto=" + escape(kdCurUrl);
	
	return false;
}

//
// Called when the user requests to take over editing of the current page.
//
function kdTakeOver(user) {
	if (!confirm('Are you sure you want to take over editing this page from "' + user + '"?')) return false;

	busy(1);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pages&action=takeoveredit&id=" + kdPageId + "&returnto=" + escape(kdCurUrl);
	
	return false;
}

//
// Called when the user requests to cancel their edits on the current page.
//
function kdCancelChanges() {
	if (!confirm('Cancel Changes?')) return false;

	busy(1);
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pages&action=cancel&id=" + kdPageId + "&returnto=" + escape(kdCurUrl);
}


/********************************************************************************

Functions used to generate, display, and manage the right click edit menus
on the page.

*********************************************************************************/

var showContainerTimeout = 0;
var showMoveTimeout = 0;
var showDisplayModeTimeout = 0;
var showStylesTimeout = 0;

function showMoveMenu(e) {
	showMoveTimeout = setTimeout('openMoveMenu()',400);
}
function openMoveMenu() {
	hideAuxMenus('pprMenuMove');
	
	var mm = document.getElementById('pprMenu');
	var sm = document.getElementById('pprMenuMove');

	if (sm.style.display == 'block')
		return;

	sm.style.top = parseInt(mm.style.top) + 100;
	sm.style.left = parseInt(mm.style.left) + mm.offsetWidth;
	sm.style.display = 'block';
}
function hideMoveMenu(e) {
	clearTimeout(showMoveTimeout);
	document.getElementById('pprMenuMove').style.display = 'none';
}

function showContainerMenu(e) {
	showContainerTimeout = setTimeout('openContainerMenu()',400);	
}
function openContainerMenu() {
	hideAuxMenus('pprMenuContainer');

	//
	// Show the menu
	//
	var mm = document.getElementById('pprMenu');
	var cm = document.getElementById('pprMenuContainer');

	if (cm.style.display == 'block')
		return;

	//
	// Is this the first time the container menu has been displayed?  If so
	// then we need to load it with the container list.  The list is presented
	// inside of a inline frame.  This allows us to provide container previews
	// and not have to load all of the container styles in the current page.
	//
	var e = document.getElementById('pprMenuContainerList');
	
	//if (e.src == kdSiteRelRoot + 'dummy.htm')
		e.src = kdSiteRelRoot + 'admin/containers.cfm';

	cm.style.top = parseInt(mm.style.top) + 30;
	cm.style.left = parseInt(mm.style.left) + mm.offsetWidth;
	cm.style.display = 'block';

}
function hideContainerMenu(e) {
	clearTimeout(showContainerTimeout);
	document.getElementById('pprMenuContainer').style.display = 'none';
}
function onContainerMenuSel(cnt_id) {
	busy();
	onPgePrgHide();
	window.location=kdSiteRelRoot + "Admin/index.cfm?section=pageprograms&pge_id=" + kdPageId + "&pge_prg_id=" + pge_prg_id + "&action=updatecontainer&container_id=" + cnt_id + "&returnto=" + escape(kdCurUrl);
}

function showDisplayModeMenu(e) {
	showDisplayModeTimeout = setTimeout('openDisplayModeMenu()',400);
}
function openDisplayModeMenu() {
	hideAuxMenus('pprMenuDisplayMode');
	
	var mm = document.getElementById('pprMenu');
	var sm = document.getElementById('pprMenuDisplayMode');

	if (sm.style.display == 'block')
		return;

	var e = document.getElementById('pprMenuDisplayModeList');
	
	// Remove existing nodes
	for (var i=e.options.length-1; i>=0; i--) {
		e.options[i] = null;
	}

	//
	// Add display modes
	var modes = displaymodes[prg_id];
	
	var i = 0;
	
	for (mode in modes) {
		e.options[i] = new Option(modes[mode][2],modes[mode][1]);
		
		if (modes[mode][0] == mde_id)
			e.options[i].selected = true;
			
		i++;
	}
		
	sm.style.top = parseInt(mm.style.top) + 75;
	sm.style.left = parseInt(mm.style.left) + mm.offsetWidth;
	sm.style.display = 'block';
}
function hideDisplayModeMenu(e) {
	clearTimeout(showDisplayModeTimeout);
	document.getElementById('pprMenuDisplayMode').style.display = 'none';
}

function showStylesMenu(e) {
	showStylesTimeout = setTimeout('openStylesMenu()',400);
}
function openStylesMenu() {
	hideAuxMenus('pprMenuStyles');
	
	var mm = document.getElementById('pprMenu');
	var sm = document.getElementById('pprMenuStyles');

	if (sm.style.display == 'block')
		return;
		
	var e = document.getElementById('pprMenuStylesList');
	
	// Remove existing nodes
	for (var i=e.options.length-1; i>=0; i--) {
		e.options[i] = null;
	}
	
	//
	// Add style sheets
	var sheets = stylesheets[mde_id];

	var i = 0;
	
	for (sheet in sheets) {
		e.options[i] = new Option(sheets[sheet][1],sheets[sheet][0]);
		
		if (sheets[sheet][0] == sty_id)
			e.options[i].selected = true;
		
		i++;
	}
	
	sm.style.top = parseInt(mm.style.top) + 75;
	sm.style.left = parseInt(mm.style.left) + mm.offsetWidth;
	sm.style.display = 'block';
}
function hideStylesMenu(e) {
	clearTimeout(showStylesTimeout);
	document.getElementById('pprMenuStyles').style.display = 'none';
}

function hideAuxMenus(exclude) {
	// hide all of the side menus
	if (exclude != 'pprMenuMove')
		hideMoveMenu();
	if (exclude != 'pprMenuContainer')
		hideContainerMenu();
	if (exclude != 'pprMenuDisplayMode')
		hideDisplayModeMenu();
	if (exclude != 'pprMenuStyles')
		hideStylesMenu();
}

// Values are set when the right click menu is displayed.
var pge_prg_id=0;
var prg_id=0;
var mde_id=0;
var style_id=0;
var cnt_id=0;

function onPgePrgMenu(program_id,ppr_id,prgname,mode_id,container_id,style_id,supoptions,supfolders,locked,state,e) {
	
	if (pge_prg_id)
		onPgePrgHide();	

	// save ref to page program to be used by menu items when clicked.
	pge_prg_id = ppr_id;
	prg_id = program_id;
	mde_id = mode_id;
	sty_id = style_id;
	cnt_id = container_id;
		
	//
	// Update the menu based on the page program
	//
	var o = document.getElementById("pprMenuItemOptions");
	
	if (supoptions) {
		o.childNodes[0].nodeValue = (prgname == 'Content' ? 'Change Content' : 'Change Options');
		o.style.display = 'block';
	}
	else
		o.style.display = 'none';
		
	document.getElementById("pprMenuItemData").style.display = (supfolders ? "block" : "none");
	document.getElementById("pprMenuItemDeleteSep").style.display = (locked ? "none" : "block");
	document.getElementById("pprMenuItemDelete").style.display = (locked ? "none" : "block");
	
	// Get program info from the client cache to enable/disable the display mode/style sheet
	// menus
	var prg = programs[prg_id];
	var mde = displaymodes[prg_id][mde_id];
	
	var modes = prg[3];
	var styles = mde[3];
		
	document.getElementById("pprMenuItemDisplay").style.display = (modes>1 ? "block" : "none");
	document.getElementById("pprMenuItemStyles").style.display = (styles>1 ? "block" : "none");
	
	document.getElementById("pprMenuItemState").childNodes[0].nodeValue = (state == 0 ? "Minimize" : "Maximize");
	
	//
	// Position the menu
	//
	var ie5=document.all&&document.getElementById;
	var ns6=document.getElementById&&!document.all;

	var menuobj=getStyleObject("pprMenu");
	
	var rightedge	=ie5 ? document.body.clientWidth -event.clientX : window.innerWidth -e.clientX;
	var bottomedge	=ie5 ? document.body.clientHeight-event.clientY : window.innerHeight-e.clientY;
	
	// If the horizontal distance isn't enough to accomodate the width of the context menu
	if ( rightedge < 150 )
		// move the horizontal position of the menu to the left by it's width
		menuobj.style.left=ie5? document.body.scrollLeft+event.clientX-150 : window.pageXOffset+e.clientX-menuobj.offsetWidth
	else
		// position the horizontal position of the menu where the mouse was clicked
		menuobj.style.left=ie5? document.body.scrollLeft+event.clientX : window.pageXOffset+e.clientX

	// Same concept with the vertical position
	if ( bottomedge < 280)
		menuobj.style.top=ie5? document.body.scrollTop+event.clientY-280 : window.pageYOffset+e.clientY-menuobj.offsetHeight
	else
		menuobj.style.top=ie5? document.body.scrollTop+event.clientY : window.pageYOffset+e.clientY
	
	//
	// Display the context menu
	menuobj.style.display="block";
	menuobj.style.visibility="visible";
	
	// Trap click event for the entire page so we can hide the menu
	document.onclick=onPgePrgHide;
	
	return false;
}
function onPgePrgHide() {
	if (pge_prg_id) {
		getStyleObject("pprMenu").style.display='none';
		hideAuxMenus();
	}
}
function onPgePrgOver(e) {
	var o=pgePrgProcEvent(e);
	
	if (o) {
	window.status = o.tagName;
		o.className="ItemOver";
		
		switch (o.id) {
			case "pprMenuItemDisplay":
				 hideAuxMenus('pprMenuDisplayMode');
				 showDisplayModeMenu();
				 break;
			case "pprMenuItemContainer":
				 hideAuxMenus('pprMenuContainer');
				 showContainerMenu();
				 break;
			case "pprMenuItemStyles":
				 hideAuxMenus('pprMenuStyles');
				 showStylesMenu();
				 break;
			case "pprMenuItemMove":
				 hideAuxMenus('pprMenuMove');
				 showMoveMenu();
				 break;
			default:
				 hideAuxMenus();
		}
	}
}	
function onPgePrgOut(e) {
	var o=pgePrgProcEvent(e);
	
	if (o) o.className='';
}
function pgePrgProcEvent(e) {
	var ie5=document.all&&document.getElementById
	var ns6=document.getElementById&&!document.all

	var firingobj=ie5? event.srcElement : e.target;

	//if (ns6 && (firingobj.parentNode.tagName=='DIV'))
	//	firingobj=firingobj.parentNode;
			
	if (firingobj.tagName=='DIV' && firingobj.id!='pprMenu')
		return firingobj;
	else if (firingobj.tagName=='IMG')
		return firingobj.parentNode;
	else
		return null;
}


//
// Page Program Edit Related Functions
//
function onPgePrgEnter(pge_prg_id,e) {
	var e=getStyleObject('ppr' + pge_prg_id);
	
	if (e) {
		e.setAttribute('origBorderWidth',e.style.borderWidth);
		e.style.borderWidth='2px';
	}
}
function onPgePrgExit(pge_prg_id,e) {
	var e=getStyleObject('ppr' + pge_prg_id);
	
	if (e) {
		e.style.borderWidth=e.getAttribute('origBorderWidth');
	}
}