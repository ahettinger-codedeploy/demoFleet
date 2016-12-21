var numCheckable = 0, numChecked = 0, idcounter ='';

function showCalendar() {
	var calendarSelectorStyle = document.getElementById('calendarSelectors').style;
	if (calendarSelectorStyle.display == 'inline-block' || calendarSelectorStyle.display == 'block') {
		calendarSelectorStyle.display = 'none';
		document.getElementById('subheader').style.bottom = '';
		document.getElementById('a_calendar').className = 'button';
	}
	else {
		if (isie7 || isie6 || (document.documentMode < 8))
			calendarSelectorStyle.display = 'inline-block';
		else
			calendarSelectorStyle.display = 'block';
		var height = document.getElementById('calendarSelectors').clientHeight - 5;
		document.getElementById('subheader').style.bottom = -height + 'px';
		document.getElementById('a_calendar').className = 'button active';
	}
}

function inviteFriends(eventId) {
	document.aspnetForm.eventID.value = eventId;
	document.aspnetForm.action = '/emailpage.aspx';
	document.aspnetForm.submit();
}

function eventDetails(id, thisDay, thisMonth, thisYear, calType, modal) {
	if (modal)
		closeModalDialog('editItemBehavior');
	document.aspnetForm.action = '/Calendar.aspx?EID=' + id + '&month=' + thisMonth + '&year=' + thisYear + '&day=' + thisDay + '&calType=' + calType;
	document.aspnetForm.submit();
}

function findPos(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) {
		do {
			curleft += obj.offsetLeft;
			curtop += obj.offsetTop;
		} while (obj = obj.offsetParent);
	}
	return curleft;
}

function showDetailsBox(id, counter) {
	
	// logic for shifting the Detail box to left if there isn't space on the right side.
	var moreActionsDiv = document.getElementById('showDetails' + id + '_' + counter);
	//get the element distance from right
	var leftpos = findPos(moreActionsDiv.parentNode);
	if (document.body.scrollWidth - leftpos < 327) {
		moreActionsDiv.className = moreActionsDiv.className.replace(/detailsTooltip/, 'detailsTooltip flip');
		moreActionsDiv.style.left = moreActionsDiv.style.width - 270 + 'px';
	}
	else {
		moreActionsDiv.className = moreActionsDiv.className.replace(/detailsTooltip flip/, 'detailsTooltip');
		moreActionsDiv.style.left = '0px';
	}
	//	logic for shifting the Detail box to left if there isn't space on the right side ends.

	if (document.getElementById('showDetails' + idcounter)) {
		document.getElementById('showDetails' + idcounter).style.display = 'none';
		document.getElementById('parentdiv' + idcounter).style.zIndex = '1';
		document.getElementById('parentdiv' + idcounter).style.position = '';
	}
	
	moreActionsDiv.style.display = 'block';
	var height = document.getElementById('parentdiv' + id + '_' + counter).clientHeight + 2;
	moreActionsDiv.style.bottom = height + 'px';
	document.getElementById('parentdiv' + id + '_' + counter).style.zIndex = '5';
	document.getElementById('parentdiv' + id + '_' + counter).style.position = 'relative';
	idcounter = id + '_' + counter;
}

function hideDetailsBox(id, counter) {
	if (document.getElementById('showDetails' + id + '_' + counter)) {
		document.getElementById('showDetails' + id + '_' + counter).style.display = 'none';
		document.getElementById('parentdiv' + id + '_' + counter).style.zIndex = '1';
		document.getElementById('parentdiv' + id + '_' + counter).style.position = '';
	}
}

function removeDefaultStartDate(elem) {
	if (elem.value == 'Start date')
		elem.value = '';
	else if (elem.value == '')
		elem.value = 'Start date';
}

function removeDefaultEndDate(elem) {
	if (elem.value == 'End date')
		elem.value = '';
	else if (elem.value == '')
		elem.value = 'End date';
}

function removeDefaultSearchTerm(elem) {
	if (elem.value == 'Search')
		elem.value = '';
	else if (elem.value == '')
		elem.value = 'Search';
}

function changeView(view, thisDay, thisMonth, thisYear, CID) {
	document.aspnetForm.calendarView.value = view;
	document.aspnetForm.action = '/calendar.aspx?' + (thisMonth ? 'month=' + thisMonth + '&' : '') + (thisYear ? 'year=' + thisYear + '&' : '') + (thisDay && view == 'week' ? 'day=' + thisDay : '') + (CID ? 'CID=' + CID + '&' : '');
	document.aspnetForm.submit();
}

function printView(view) {
	var action = document.aspnetForm.action;
	if(action.indexOf('?') != -1)
		action = action + "&PREVIEW=YES";
	else
		action = action + "?PREVIEW=YES";

	if (action.indexOf('view') == -1)
		action = action + "&view=" + view;
	window.open(action, "");
}

function checkAllCalendars(value) {
	var arrCheckboxes = document.getElementsByName("chkCalendarID");
	for (var cv = 0; cv < arrCheckboxes.length; cv++)
		arrCheckboxes[cv].checked = value;

	numChecked = (value ? arrCheckboxes.length : 0);
}

function boxChanged(wasChecked) {
	if (wasChecked)
		++numChecked;
	else
		--numChecked;
	document.getElementById('allCalendars').checked = (numChecked == numCheckable);
}

function searchTextHook(ev) {
	ev = (window.event ? window.event : ev);
	if (ev.keyCode == 10 || ev.keyCode == 13)
		calendarSearch();
}

function calendarSearch() {
	var frm = document.aspnetForm;
	var startDate = frm.startDate.value;
	var enddate = frm.enddate.value;
	var searchTerm = frm.searchTerm.value;
	var CID = '';

	if (startDate == 'Start date')
		startDate = '';
	if (enddate == 'End date')
		enddate = '';
	if (searchTerm == 'Search')
		searchTerm = '';

	var arrCheckboxes = document.getElementsByName("chkCalendarID");
	for (var cv = 0; cv < arrCheckboxes.length; cv++) {
		if (arrCheckboxes[cv].checked)
			CID = CID + arrCheckboxes[cv].value + ",";
	}

	if (startDate + enddate + searchTerm == "") {
		frm.action = '/calendar.aspx?CID=' + CID;
	}
	else {
		frm.calendarView.value = 'list';
		frm.action = '/calendar.aspx?Keywords=' + encodeURIComponent(searchTerm) + '&startDate=' + startDate + '&enddate=' + enddate + '&CID=' + CID;
	}
	frm.submit();
}

function eventDetail(id) {
	document.aspnetForm.calendarView.value = 'week';
	document.aspnetForm.eventID.value = id;
	redrawContent();
}

function facilityDetail(id) {
	document.aspnetForm.action = '/facilities.aspx?Page=resvdetail&FRID=' + id;
	document.aspnetForm.submit();
}

function showMore(id, showMoreId, day) {
	var elemStyle = document.getElementById(id).style;
	if (elemStyle.display == 'none') {
		elemStyle.display = 'block';
		document.aspnetForm.showMoreDay.value = day;
		document.getElementById(showMoreId).innerHTML = '<img src="/Common/images/Calendar/showless.png" width="65" height="17" alt="Hide More" border="0">';
	}
	else {
		elemStyle.display = 'none';
		document.aspnetForm.showMoreDay.value = '';
		document.getElementById(showMoreId).innerHTML = '<img src="/Common/images/Calendar/showmore.png" width="65" height="17" alt="Show More" border="0">';
	}
}

function switchWeek(action) {
	document.aspnetForm.calendarView.value = 'week';
	document.aspnetForm.eventID.value = 0;
	document.aspnetForm.action = action;
	redrawContent();
}

function changeDate(year, month, view, CID) {
	var frm = document.aspnetForm;
	frm.calendarView.value = view;
	frm.action = '/calendar.aspx?month=' + month + '&year=' + year + (CID ? '&CID=' + CID : '');
	redrawContent();
}

function displayPopUp(id) {
	var elemStyle = document.getElementById(id).style;
	if (elemStyle.display == 'none') {
		elemStyle.display = 'block';
	}
	else {
		elemStyle.display = 'none';
	}
}

function showAllEvents(day, month, year, state) {
	var behaviorID = $find('editItemBehavior');
	var ifrID = document.getElementById('liveEditDialog');
	if (behaviorID) {
		ifrID.style.height = '350px';
		ifrID.src = '/common/modules/Calendar/ShowAllEvents.aspx?day=' + day + '&year=' + year + '&month=' + month + '&state=' + state;
		ifrID.style.display = 'block';
		behaviorID.show();
	}
}

function expandAll(month, year, action, CID) {
	if (action == 'expand') {
	    document.aspnetForm.action = '/calendar.aspx?month=' + month + '&year=' + year + '&mode=expandAll' + (CID ? '&CID=' + CID + '&' : '');
	}
	else {
	    document.aspnetForm.action = '/calendar.aspx?month=' + month + '&year=' + year + (CID ? '&CID=' + CID + '&' : '');
	}
	document.aspnetForm.calendarView.value = 'month';
	redrawContent();
}

function refreshPage(date, state) {
	var frm = document.aspnetForm;
	var datecopy = date;
	var month = datecopy.substring(0, datecopy.indexOf('/'));
	datecopy = datecopy.substring(datecopy.indexOf('/') + 1);
	var day = datecopy.substring(0, datecopy.indexOf('/'));
	datecopy = datecopy.substring(datecopy.indexOf('/') + 1);
	var year = datecopy.substring(datecopy.indexOf('/'));
	if (state == 'expanded')
		frm.action = '/calendar.aspx?day=' + day + '&month=' + month + '&year=' + year + '&mode=expandAll';
	else
		frm.action = '/calendar.aspx?day=' + day + '&month=' + month + '&year=' + year;
	frm.calendarView.value = 'month';
	frm.submit();
}

// LIVE EDIT STUFF:
try {
	Sys.Application.add_load(loadOrAjaxUpdate);
}
catch (ex) { }

if (!window.CalendarKAMMenu) {
	CalendarKAMMenu = function() { };
	window.CalendarKAMMenu = CalendarKAMMenu;
}

function raiseAsyncPostbackCalendar(updatePanelID, closePopUp, actionTaken) {
    if (closePopUp)
		closeModalDialog('editItemBehavior');

	blockMenuSpawn = true;
	if (CalendarKAMMenu.dayCounter)
		CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
	else
		CalendarItemHideMenu(1);
	CalendarCategoryHideMenu();
	if (actionTaken)
		__doPostBack(updatePanelID, actionTaken);
	else
		__doPostBack(updatePanelID, "calendar");
}

function CalendarEventModifyDelete(calendarID, action, updatePanelID, eventID) {
	var ysnArchShowForce = -1, doSubmit = true;
	var frmCalendar = document.aspnetForm;

	switch (action) {
		case "Link":
			{
				doSubmit = false;
				showCopyLinkWindowUsingRelatedLink('/calendar.aspx?EID=' + eventID);
				break;
			}
		case "Publish":
		case "Unpublish":
		case "Reject":
		case "Submit":
			frmCalendar.strActionFE.value = "CalendarItem" + action;
			break;
		case "Delete":
			{
				if (confirm("Are you sure you want to delete this item?")) {
					frmCalendar.strActionFE.value = "CalendarItemDelete";
				}
				else
					doSubmit = false;
				break;
			}
		case 'archivePublic':
			ysnArchShowForce = 1;
		case 'archiveHidden':
			if (ysnArchShowForce < 0) ysnArchShowForce = 0;
			if (!(confirm('Are you sure you want to archive this item?'))) {
				ysnArchShowForce = -1;
				return;
			}
			frmCalendar.strActionFE.value = 'CalendarItemArchive';
			frmCalendar.ysnArchShowForceFE.value = ysnArchShowForce;
			break;
		default:
			{
				doSubmit = false;
				break;
			}
	}
	if (doSubmit) {
		frmCalendar.ysnSaveFE.value = 1;
		frmCalendar.lngCalendarEventID.value = eventID;
		raiseAsyncPostbackCalendar(updatePanelID, 0);
	}
}

function openEditWindowCalendar(calendarID, eventID, isCopy, order, updatePanelID, isSubmit) {
	behavior = $find('editItemBehavior');
	if (behavior) {
		var ifr = document.getElementById('liveEditDialog');
		if (isSubmit) {
			document.getElementById('ctl00_LiveEditModalTitle').innerHTML = ' Event Submission';
			setModalClassFE('submitEvent', behavior);
		}
		else
			setModalClass('liveEdit calendar', behavior);

		var url = '/common/modules/Calendar/calendarLiveEdit.aspx?calendarID=' + calendarID + '&eventID=' + eventID + '&order=' + order + '&updatePanelID=' + updatePanelID;

		if (isSubmit)
			url = url + '&submit=1';
		if (isCopy)
			ifr.src = url + '&strPage=itemCopy';
		else
			ifr.src = url + '&strPage=itemForm';

		ifr.style.display = 'block';
		behavior.show();
	}
}

function CalendarItemMouseOver(sender, event, itemID, dayCounter) {
	if (blockMenuSpawn)
		return;
	var controlID;
	CalendarKAMMenu.eventID = itemID;
	////58 is moduleId Please follow the format LiveEditControlModuleID_ItemId 
	controlID = 'LiveEditControl58_' + itemID + '_' + dayCounter;
	var liveEditControl = $get(controlID);

	// Make sure previous KAMs are hidden if they need to be.
	if (!showLiveEditControls) {
		if (previousKAMControl)
			previousKAMControl.style.display = 'none';
		previousKAMControl = liveEditControl;
	}

	// Change z-index, for proper display.
	var parentContainer = resolveLiveEditContainer(liveEditControl);
	parentContainer.style.zIndex = 2;
	if (document.getElementById('parentdiv' + itemID + '_' + dayCounter))
		document.getElementById('parentdiv' + itemID + '_' + dayCounter).style.zIndex = 5;

	// Move action category menu to container for category.
	liveEditControl.appendChild(CalendarKAMMenu.elemItemMenu);

	// Show tool-tip (if they are not disabled).
	CalendarShowTooltip(controlID);

	// Show KAM.
	liveEditControl.style.display = 'block';
}

function CalendarShowTooltip(controlID) {
	var liveEditControl = $get(controlID);
	liveEditControl.appendChild(CalendarKAMMenu.elemTooltip);

	if (CalendarKAMMenu.elemTooltip) {
		if (showToolTip)
			CalendarKAMMenu.elemTooltip.style.display = 'block';
		else
			CalendarKAMMenu.elemTooltip.style.display = 'none';
	}
}

function CalendarItemMouseOut(sender, event, itemID, dayCounter) {
	// Ignore when mouse leaves child controls within the live edit control.	
	event = (window.event ? window.event : event);
	var toElement = (event.toElement ? event.toElement : event.relatedTarget);

	if (!elemInsideOrEq(sender, toElement)) {
		CalendarItemHideMenu(dayCounter);
	}
}

function CalendarCategoryMouseOver(sender, event, categoryID, fromCalendarScreen) {
	if (blockMenuSpawn)
		return;

	CalendarKAMMenu.calendarID = categoryID;
	var controlID;
	if (!fromCalendarScreen)
		controlID = 'LiveEditControl_' + categoryID;
	else
		controlID = 'LiveEditControlCalendar_' + categoryID;
	var liveEditControl = $get(controlID);

	// Make sure previous KAMs are hidden if they need to be.
	if (!showLiveEditControls) {
		if (previousKAMControl)
			previousKAMControl.style.display = 'none';
		previousKAMControl = liveEditControl;
	}

	// Move action category menu to container for category.
	liveEditControl.appendChild(CalendarKAMMenu.elemCatMenu);

	// Change z-index, for proper display.
	var parentContainer = resolveLiveEditContainer(liveEditControl);
	parentContainer.style.zIndex = 2;

	// Show tool-tip (if they are not disabled).
	CalendarShowTooltip(controlID);

	// Show KAM.
	liveEditControl.style.display = 'block';
}

// Summons action menu for a category.
function CalendarActionsCategory(calendarID, catElemID, updatePanelID, status, rights, fromCalendarScreen) {
	CalendarKAMMenu.updatePanelID = updatePanelID;
	CalendarKAMMenu.eventID = 0;
	CalendarKAMMenu.calendarID = calendarID;
	CalendarKAMMenu.counter = 0;
	CalendarKAMMenu.status = status;
	CalendarKAMMenu.rights = rights;
	if (!fromCalendarScreen)
		liveEditCommonCategory(
			$get(catElemID),
			CalendarKAMMenu.elemTooltip,
			CalendarKAMMenu.elemCatMenu,
			$get('LiveEditControl_' + calendarID), 'CalendarCategoryLiveEditMoreActions');
	else
		liveEditCommonCategory(
			$get(catElemID),
			CalendarKAMMenu.elemTooltip,
			CalendarKAMMenu.elemCatMenu,
			$get('LiveEditControlAlbum_' + calendarID), 'CalendarCategoryLiveEditMoreActions');
}

function CalendarCategoryMouseOut(sender, event) {
	// Ignore when mouse leaves child controls within the live edit control.
	event = (window.event ? window.event : event);
	var toElement = (event.toElement ? event.toElement : event.relatedTarget);

	if (!elemInsideOrEq(sender, toElement))
		CalendarCategoryHideMenu();
}

function CalendarCategoryHideMenu() {
	var categoryID = CalendarKAMMenu.calendarID;
	var controlID = 'LiveEditControl_' + categoryID;
	var controlIDAlbum = 'LiveEditControlAlbum_' + categoryID;

	var liveEditControl = $get(controlID);
	var liveEditControlAlbum = $get(controlIDAlbum);

	if (!liveEditControl && !liveEditControlAlbum)
		return;

	// Change z-index, for proper display.
	var parentContainer;
	if (liveEditControl)
		parentContainer = resolveLiveEditContainer(liveEditControl);
	else
		parentContainer = resolveLiveEditContainer(liveEditControlAlbum);
	parentContainer.style.zIndex = 0;

	// Hide action menu for category.
	CalendarKAMMenu.elemCatMenu.style.display = 'none';

	if (CalendarKAMMenu.elemCatMenu.parentNode) {
		CalendarKAMMenu.elemCatMenu.parentNode.removeChild(CalendarKAMMenu.elemCatMenu);
		CalendarKAMMenu.elemLiveEditBullpen.appendChild(CalendarKAMMenu.elemCatMenu);
	}

	// Hide any possibly visible tool-tip.
	CalendarHideTooltip();

	// Hide KAM unless KAMs are set to always show.
	if (!showLiveEditControls) {
		if (liveEditControlAlbum)
			liveEditControlAlbum.style.display = 'none';
		if (liveEditControl)
			liveEditControl.style.display = 'none';
	}
}

function CalendarItemHideMenu(dayCounter) {
	var itemID = CalendarKAMMenu.eventID;
	//58 is moduleId Please follow the format LiveEditControlModuleID_ItemId 
	var controlID = 'LiveEditControl58_' + itemID + '_' + dayCounter;
	var liveEditControl = $get(controlID);

	if (!liveEditControl)
		return;

	// Change z-index, for proper display.
	var parentContainer = resolveLiveEditContainer(liveEditControl);
	parentContainer.style.zIndex = 0;
	if (document.getElementById('parentdiv' + itemID + '_' + dayCounter))
		document.getElementById('parentdiv' + itemID + '_' + dayCounter).style.zIndex = 1;
	
	// Hide action menu for item.
	CalendarKAMMenu.elemItemMenu.style.display = 'none';

	if (CalendarKAMMenu.elemItemMenu.parentNode) {
		CalendarKAMMenu.elemItemMenu.parentNode.removeChild(CalendarKAMMenu.elemItemMenu);
		CalendarKAMMenu.elemLiveEditBullpen.appendChild(CalendarKAMMenu.elemItemMenu);
	}

	// Hide any possibly visible tool-tip.
	CalendarHideTooltip();

	// Hide KAM unless KAMs are set to always show.	
	if (!showLiveEditControls) {
		liveEditControl.style.display = 'none';
	}
}

// Hides tool-tip text for a category.
function CalendarHideTooltip() {
	if (CalendarKAMMenu.elemTooltip.parentNode)
		CalendarKAMMenu.elemTooltip.parentNode.removeChild(CalendarKAMMenu.elemTooltip);
	CalendarKAMMenu.elemTooltip.style.display = 'none';
}

function CalendarActionsInit() {
	// Set up state variables (they change per item).
	CalendarKAMMenu.updatePanelID = '';
	CalendarKAMMenu.eventID = 0;
	CalendarKAMMenu.calendarID = 0;
	CalendarKAMMenu.counter = 0;
	CalendarKAMMenu.order = 0;
	CalendarKAMMenu.status = 0;
	CalendarKAMMenu.rights = 0;
	CalendarKAMMenu.dayCounter = 0;

	// Get invisible bullpen (where hidden stuff is stored).
	CalendarKAMMenu.elemLiveEditBullpen = $get('CalendarLiveEditBullpen');

	// Set up KAM tooltip.
	CalendarKAMMenu.elemTooltip = $get('CalendarLiveEditToolTip');
	if (!showToolTip)
		CalendarKAMMenu.elemTooltip.style.display = 'none';

	// Set up category action menu.
	CalendarKAMMenu.elemCatMenu = $get('CalendarCategoryLiveEditMoreActions');

	CalendarKAMMenu.elemCatActionNew = $get('CalendarCategoryNewItem');
	hookAnchorClick(CalendarKAMMenu.elemCatActionNew,
		function(sender, eventArgs) {
			CalendarCategoryHideMenu();
			var updatePanel = (CalendarKAMMenu.updatePanelID + '').trim();

			if (updatePanel == 'feature' || updatePanel == '')
				openEditWindowCalendar(0, 0, 1, 0, 'feature');
			else
				openEditWindowCalendar(CalendarKAMMenu.calendarID, 0, 0, 0, CalendarKAMMenu.updatePanelID);
		});

	// Set up item action menu.
	CalendarKAMMenu.elemItemMenu = $get('CalendarItemLiveEditMoreActions');
	CalendarKAMMenu.elemItemActionModify = $get('CalendarItemModify');
	CalendarKAMMenu.elemItemActionCommands = $get('CalendarItemCommands');
	hookAnchorClick(CalendarKAMMenu.elemItemActionModify,
		function(sender, eventArgs) {
			if (!CalendarKAMMenu.elemItemActionModify.inactive) {
				CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
				openEditWindowCalendar(CalendarKAMMenu.calendarID, CalendarKAMMenu.eventID, 0, -1, CalendarKAMMenu.updatePanelID);
			}
		});

	CalendarKAMMenu.elemItemActionCopyLink = $get('CalendarItemCopyLink');
	hookAnchorClick(CalendarKAMMenu.elemItemActionCopyLink,
		function(sender, eventArgs) {
			CalendarEventModifyDelete(CalendarKAMMenu.calendarID, 'Link', CalendarKAMMenu.updatePanelID, CalendarKAMMenu.eventID);
		});

	CalendarKAMMenu.elemItemActionUnpublish = $get('CalendarItemUnpublish');
	hookAnchorClick(CalendarKAMMenu.elemItemActionUnpublish,
		function(sender, eventArgs) {
			CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
			CalendarEventModifyDelete(CalendarKAMMenu.calendarID, 'Unpublish', CalendarKAMMenu.updatePanelID, CalendarKAMMenu.eventID);
		});

	CalendarKAMMenu.elemItemActionPublish = $get('CalendarItemPublish');
	hookAnchorClick(CalendarKAMMenu.elemItemActionPublish,
		function (sender, eventArgs) {
		    CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
		    var title = $('#eventTitle_' + CalendarKAMMenu.eventID).text();
		    title = title.replace(/^\[[A-Z]*\] /g, ''); //get rid of status at the beginning of title.
		    saveAndSendBE(CalendarKAMMenu.calendarID, CalendarKAMMenu.updatePanelID, CalendarKAMMenu.eventID, title);
		});

	CalendarKAMMenu.elemItemActionSubmit = $get('CalendarItemSubmit');
	hookAnchorClick(CalendarKAMMenu.elemItemActionSubmit,
		function(sender, eventArgs) {
			CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
			CalendarEventModifyDelete(CalendarKAMMenu.calendarID, 'Submit', CalendarKAMMenu.updatePanelID, CalendarKAMMenu.eventID);
		});

	CalendarKAMMenu.elemItemActionCopy = $get('CalendarItemCopy');
	hookAnchorClick(CalendarKAMMenu.elemItemActionCopy,
		function(sender, eventArgs) {
			CalendarItemHideMenu(CalendarKAMMenu.dayCounter);

			if (CalendarKAMMenu.counter > 0)
				openEditWindowCalendar(CalendarKAMMenu.calendarID, CalendarKAMMenu.eventID, 1, -1, CalendarKAMMenu.updatePanelID);
			else
				openEditWindowCalendar(CalendarKAMMenu.calendarID, CalendarKAMMenu.eventID, 1, -1, 'search');
		});

	CalendarKAMMenu.elemItemActionArchive = $get('CalendarItemArchive');
	hookAnchorClick(CalendarKAMMenu.elemItemActionArchive,
		function(sender, eventArgs) {
			CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
			CalendarEventModifyDelete(CalendarKAMMenu.calendarID, 'archiveHidden', CalendarKAMMenu.updatePanelID, CalendarKAMMenu.eventID);
		});

	CalendarKAMMenu.elemItemActionDelete = $get('CalendarItemDelete');
	hookAnchorClick(CalendarKAMMenu.elemItemActionDelete,
		function(sender, eventArgs) {
			CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
			CalendarEventModifyDelete(CalendarKAMMenu.calendarID, 'Delete', CalendarKAMMenu.updatePanelID, CalendarKAMMenu.eventID);
		});

	CalendarKAMMenu.elemItemActionNewAnchor = $get('CalendarItemNewItemAnchor');
	CalendarKAMMenu.elemItemActionNew = $get('CalendarItemNewItem');
	hookAnchorClick(CalendarKAMMenu.elemItemActionNew,
		function(sender, eventArgs) {
			if (!CalendarKAMMenu.elemItemActionNew.inactive) {
				CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
				openEditWindowCalendar(CalendarKAMMenu.calendarID, 0, 0, CalendarKAMMenu.order, CalendarKAMMenu.updatePanelID);
			}
		});

	CalendarKAMMenu.elemItemActionReject = $get('CalendarItemReject');
	hookAnchorClick(CalendarKAMMenu.elemItemActionReject,
		function(sender, eventArgs) {
			CalendarItemHideMenu(CalendarKAMMenu.dayCounter);
			CalendarEventModifyDelete(CalendarKAMMenu.calendarID, 'Reject', CalendarKAMMenu.updatePanelID, CalendarKAMMenu.eventID);
		});
}

// Called when Notify Me pop-up is closed on the Front End.
function notifyMePopUpCallBack(frmMain, argument) {
    var array = argument.split('_');
    var comingFrom = array[0];
    switch (comingFrom) {
        case "LiveEdit":
            CalendarEventModifyDelete(array[1], 'Publish', array[2], array[3]);
            break;
        default:
            alert('Not callback provided to handle notifyme');
    }
    closeModalDialog('editItemBehavior');
}

function saveAndSendBE(catId, updatePanelID, eventID, title) {
    var ifrID = document.getElementById('liveEditDialog');
    var behaviorID = $find('editItemBehavior');
    var argument = "LiveEdit_" + catId + "_" + updatePanelID + "_" + eventID;
    if (behaviorID) {
        setModalClass('notifyMe', behaviorID);
        ifrID.src = '/common/admin/sendEmailBE.aspx?formName=aspnetForm&catId=' + catId + '&title=' + title + '&from=calendar&moduleName=calendar&comingFrom=' + argument + '&status=calendar';
        ifrID.style.display = 'block';
        behaviorID.show();
    }
}

// Summons action menu for an item.
function CalendarActionItems(eventID, updatePanelID, calendarID, order, counter, status, rights, lastItem, dayCounter) {
	CalendarKAMMenu.updatePanelID = updatePanelID;
	CalendarKAMMenu.calendarID = calendarID;
	CalendarKAMMenu.eventID = eventID;
	CalendarKAMMenu.counter = counter;
	CalendarKAMMenu.order = order;
	CalendarKAMMenu.status = status;
	CalendarKAMMenu.rights = rights;
	CalendarKAMMenu.lastItem = lastItem;
	CalendarKAMMenu.dayCounter = dayCounter;

	// Determine if modify is available.
	if (rights >= PUBLISHER || rights == AUTHOR && status < MIN_PUBLISHED) {
		CalendarKAMMenu.elemItemActionModify.className = 'big modify';
		CalendarKAMMenu.elemItemActionModify.title = '';
		CalendarKAMMenu.elemItemActionModify.inactive = false;
	}
	else {
		CalendarKAMMenu.elemItemActionModify.className = 'big modify inactive';
		CalendarKAMMenu.elemItemActionModify.title = 'You do not have rights to modify this item.'
		CalendarKAMMenu.elemItemActionModify.inactive = true;
	}

	// Determine visiblity of submit/reject/publish/unpublish.
	CalendarKAMMenu.elemItemActionSubmit.style.display = 'none';
	CalendarKAMMenu.elemItemActionReject.style.display = 'none';
	CalendarKAMMenu.elemItemActionPublish.style.display = 'none';
	CalendarKAMMenu.elemItemActionUnpublish.style.display = 'none';

	if (rights > AUTHOR) {
		if (status > MAX_DRAFT)
			CalendarKAMMenu.elemItemActionUnpublish.style.display = '';
		else
			CalendarKAMMenu.elemItemActionPublish.style.display = '';

		if (status == SUBMITTED)
			CalendarKAMMenu.elemItemActionReject.style.display = '';
	}
	else if (status != SUBMITTED && status <= MAX_DRAFT)
		CalendarKAMMenu.elemItemActionSubmit.style.display = '';

	// Determine visiblity of delete/archive.
	CalendarKAMMenu.elemItemActionArchive.style.display = 'none';
	CalendarKAMMenu.elemItemActionDelete.style.display = 'none';

	if (rights > AUTHOR) {
		// Only publisher or higher can delete.
		if (status > MAX_DRAFT)
			CalendarKAMMenu.elemItemActionArchive.style.display = '';
		else
			CalendarKAMMenu.elemItemActionDelete.style.display = '';
	}
	else if (status <= MAX_DRAFT)
		CalendarKAMMenu.elemItemActionDelete.style.display = '';

	// Determine visiblity/behavior of new.
	if (counter > 0) {
		if (rights >= AUTHOR) {
			CalendarKAMMenu.elemItemActionNew.style.display = '';
			CalendarKAMMenu.elemItemActionNewAnchor.title = '';
			CalendarKAMMenu.elemItemActionNewAnchor.className = 'addItem';
			CalendarKAMMenu.elemItemActionNew.inactive = false;
		}
		else
			CalendarKAMMenu.elemItemActionNew.style.display = 'none';
	}
	else if (counter > -2) {
		CalendarKAMMenu.elemItemActionNew.style.display = '';
		CalendarKAMMenu.elemItemActionNewAnchor.title = 'You cannot add item on search screen.';
		CalendarKAMMenu.elemItemActionNewAnchor.className = 'addItem inactive';
		CalendarKAMMenu.elemItemActionNew.inactive = true;
	}
	else
		CalendarKAMMenu.elemItemActionNew.style.display = 'none';

	// Apply even/odd classes.
	var listItems = CalendarKAMMenu.elemItemActionCommands.firstChild;
	var lc = 0;

	while (listItems != null) {
		if (listItems.nodeType == 1 && listItems.style.display != 'none')
			listItems.className = (((++lc) % 2) == 0 ? 'even' : '');
		listItems = listItems.nextSibling;
	}
	// Show menu.
	liveEditCommonItem(
	CalendarKAMMenu.elemTooltip,
	CalendarKAMMenu.elemItemMenu,
	$get('LiveEditControl58_' + eventID + '_' + CalendarKAMMenu.dayCounter), 'CalendarItemLiveEditMoreActions', false); ////58 is moduleId Please follow the format LiveEditControlModuleID_ItemId 
}