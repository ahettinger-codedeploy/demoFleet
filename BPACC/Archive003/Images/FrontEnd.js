var menusLoaded = false;
var menus = new Array();
var intMenuWidthLevel = 0;
var intMenuHeightLevel = 0;
var delay = 0;
var order = "";
var child;
var menuLoc = 'float';
var menuFlag = 0;
var Loaded = false;
var w = 925;
var intresize = 0;
var ysnFeatureColumn = 0;
var intPopupMenuHeight2 = 0;
var intPopupMenuHeight = 0;

function closeModalDialog(behaviourID) {
	var behavior = $find(behaviourID);
	
	if (behavior)
		behavior.hide();
}

function changeModalDialogHeight(height, showDetails) {
	var ifr = document.getElementById('liveEditDialog');
	if (ifr)
	    ifr.style.height = height + 'px';
	if(showDetails != '')
	    document.cookie = "showAddDetails=" + showDetails + ";";
}

function setModalClassForEditItemBehavior(cssClass, showDetails) {
	var behaviorID = $find('editItemBehavior');
	var modalContainer = document.getElementById(behaviorID._PopupControlID);
	if (modalContainer)
		modalContainer.className = 'modalContainer modalContainerCP ' + cssClass;
	if (showDetails != '')
		document.cookie = "showAddDetails=" + showDetails + ";";
}

function showHideUnpublishedItems() {
	if (document.getElementById('viewUnpublished').checked) {
		document.cookie = "showAll=true; expires=12/31/2999 23:59:59";
		document.getElementById('viewActionItems').checked = true;
		document.getElementById('viewActionItems').disabled = true;

	}
	else {
		document.cookie = "showAll=false; expires=12/31/2999 23:59:59";
		document.getElementById('viewActionItems').checked = false;
		document.getElementById('viewActionItems').disabled = false;
	}
	showHideActionItems();
}

function showHideActionItems() {
	if (document.getElementById('viewActionItems').checked)
		document.cookie = "showActionItems=true; expires=12/31/2999 23:59:59";
	else
		document.cookie = "showActionItems=false; expires=12/31/2999 23:59:59";
		
	if (typeof redrawContent == 'function')
		redrawContent();
	else
		location.reload(true);
}

function showHideLiveEditControl() {
	if (document.getElementById('viewEditable').checked)
		document.cookie = "showLiveEditControls=true; expires=12/31/2999 23:59:59";
	else
		document.cookie = "showLiveEditControls=false; expires=12/31/2999 23:59:59";
	
	if (typeof redrawContent == 'function') 
		redrawContent();
	else
		location.reload(true);
}

// Briefcase functionality.
function ShowBriefcase(id) {
	openGenericModalDialog(null, 'myBriefcaseDialog', 'My Briefcase', '/Common/modules/MyBriefcase/MyBriefcase.aspx?ID=' + id);
}

// Print preview.
function pPreview(mode) {
	var printStr = 'PREVIEW=YES';
	if (mode == 1)
		printStr = 'PRINT=YES';
	window.open(document.URL + (document.URL.indexOf("?") == -1 ? '?' : '&') + printStr, '_blank');
}

function Navigate(txtAction) {
	if (txtAction.lastIndexOf("&") == txtAction.length - 1)
		txtAction = txtAction.slice(0, -1);
	document.frmNavigate.action = txtAction;
	location.href = txtAction;
}

function showExternalSiteDialog(anchor) {
	window.externalUrl = anchor.href;
	window.externalTarget = anchor.target;
	openGenericModalDialog(externalSiteDialogHeight, 'externalLinkDialog', 'Leaving Site', '/Common/Modules/LeavingSite/Dialog.aspx');
	return false;
}

// todo: rename to openModalDialog, to match closeModalDialog
function openGenericModalDialog(height, className, title, src) {
	document.getElementById('ctl00_LiveEditModalTitle').innerHTML = title;
	
	behavior = $find('editItemBehavior');
	
	if (behavior) {
		var ifr = document.getElementById('liveEditDialog');
		var target = document.getElementById('ctl00_liveEditPopupWindow');
		
		ifr.src = src;
		
		if (className)
			target.className = 'modalContainer ' + className;
		if (height)
			ifr.style.height = height;
		
		ifr.style.display = 'block';
		
		behavior.show();
	}
}

function expandCollapseCategory(catID) {
	if (document.getElementById(catID).style.display == 'none') {
		document.getElementById(catID).style.display = 'block';
		document.getElementById('a_' + catID).innerHTML = '&#9660;';
	}
	else {
		document.getElementById(catID).style.display = 'none';
		document.getElementById('a_' + catID).innerHTML = '&#9658;';
	}
}
function slideToggle(element, bShow, duration) {
	var $el = $(element)
    , visible = $el.is(":visible");

	// if the bShow isn't present, get the current visibility and reverse it
	if (arguments.length == 1) bShow = !visible;

	// if the current visiblilty is the same as the requested state, cancel
	if (bShow == visible) return false;

	$.each($el, function (i, e) {
		var $e = $(e);
		var visible = $e.is(":visible");
		var height = $e.show().height();
		if (!$e.data("originalHeight")) {
			$e.data("originalHeight", height);
		};
		if (!visible) $e.hide().css({ height: 0 });
	})

	// expand the knowledge (instead of slideDown/Up, use custom animation which applies fix)
	if (bShow) {
		$.each($el, function (i, e) {
			$e = $(e);
			$e.show().animate({ height: $e.data("originalHeight") }, { duration: duration });
		})
	} else {
		$el.animate({ height: 0 }, { duration: duration, complete: function () {
				$el.hide();
			}
		});
		
	}
	$el.queue(function () { $el.height('auto'); $(this).dequeue(); });
}
// Setup handlers for My Account toolbar
$(document).ready(function () {
    var $Favorites = $('#favoritesList');
    var $UserMenu = $('.commonToolbar .userMenu .popOut');
    $Favorites.hide();
    $UserMenu.hide();

    $('a[href="#favoritesList"]').click(function (e) {
        e.preventDefault();
        if ($Favorites.hasClass('open')) {
            $Favorites.slideUp(200);
        } else {
            slideToggle($Favorites,true, 200);
        }
        $Favorites.toggleClass('open');
    });

    $('.commonToolbar .popOutContainer > a').click(function (e) {
        if ($UserMenu.hasClass('open')) {
            $UserMenu.slideUp(200);
        } else {
            $UserMenu.slideDown(200);
        }
        $UserMenu.toggleClass('open');
    });

});
