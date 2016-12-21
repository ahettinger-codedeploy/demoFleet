// save_day.js
//
// Javascript component of ajax save day functionality--used in fns_form*
// Uses save_day.php
//
// autoSave variables... most important here is the timeout... adjust to a reasonable default
var autoSaveTimers = new Array(60);
var autoSaveActive = new Array(60);
var autoSavesActive = 0;
var autoSaveTimeout = 15 * 1000;
var autoSaveMightBeStuck = 0;
var autoSaveForceCallback = null;
var autoSaveDisabled = 0;

// Not really AutoSave variables but are used in some of the auto save code...
var userHasOkedLeavingPageAlready = 0;

// Variables to keep track of which days have been modified and not yet saved...
var g_calendarDayModified = Array(60);
var g_calendarDirty = false;

// Called by ajax event handler when ajax event has completed successfully with a returned json
// object with result == 'OK'.  Also called by failure handler for the special case of handling
// 'bad usernames' in the sharing boxes.
function calendarAutoSaveCompleteSuccess(json, index) {
	if (json.numOfDaysToSave == null) {
		json.numOfDaysToSave = 0;
	}
	for ( index = 1; index <= json.numOfDaysToSave; index++ ) {
		var request, crcDay, updatecount, yyyymmddDay, existingRecord, errorDay, requestIndex;
		
		// This pulls the variables out of the json response
		eval ('request = json.request' + index + ';');
		eval ('crcDay = json.crcDay' + index + ';');
		eval ('updatecount = json.updatecount' + index + ';');
		eval ('existingRecord = json.existingRecord' + index + ';');
		eval ('errorDay = json.errorDay' + index + ';');
		eval ('requestIndex = json.requestIndex' + index + ';');
		
		// Get the yyyymmddDay for this requestIndex from the document
		if (requestIndex)
			eval ('yyyymmddDay = document.form1.yyyymmddDay' + requestIndex + '.value;');
		
		// This puts the variables into the document form
		if (request)
			eval('document.form1.request' + requestIndex + '.value = request;');
		if (crcDay)
			eval('document.form1.crcDay' + requestIndex + '.value = crcDay;');
		if (updatecount)
			eval('document.form1.updatecount' + requestIndex + '.value = updatecount;');
		if (existingRecord)
			eval('document.form1.existingRecord' + requestIndex + '.value = existingRecord;');
		
		// This updates the html display block of the selected day that was saved with the
		// "newly" saved data (the server can alter the data during the save process)
		if (request) {
			var div = $(requestIndex + 'up');
			div.innerHTML = processHiddenText(request, $('ht_readonly').value == "y"); //request;
		}

		// Error handling for server error messages
		if (errorDay != "") {
			alert("Error Saving Calendar:\n\nDate: " + yyyymmddDay + "\n" + errorDay);
		}

		// Flag the day as saved
		calendarDayHasBeenSaved(requestIndex);
		if (requestIndex != null)
			autoSaveActive[requestIndex] = 0;
		
		// Update the last update time array, if it exists
		if ( typeof(lastUpdateTimeArray) != 'undefined' ) {
			var nowtime = new Date();
			lastUpdateTimeArray[requestIndex] = nowtime.valueOf();
		}
	}

	// Clear auto save tracking flags
	autoSaveMightBeStuck = 0;
	if (autoSavesActive > 0)
	  autoSavesActive --;
	
	// See how many auto saves are active, if zero we should call the callback now
	if (autoSavesActive == 0 && autoSaveForceCallback != null) {
		autoSaveForceCallback();
		autoSaveForceCallback = null;
	}
}

// Called by ajax handler when either the ajax event is cancelled, fails, or returns a json
// object where json.result != 'OK'.  It is possible to have a null passed in so this code is
// mindful of this condition.
//
// This code handles two possible scenarios:
//   1. the save completed successfully, but one or both of the sharing usernames are invalid
//      and need to be fixed.
//   2. the save or the request completely failed.  There is potentially a message passed back
//      from the server with the reason why.  AutoSave is disabled in this scenario.
function calendarAutoSaveCompleteFailure(json, index) {
	var die_message = "Auto Save Disabled due to a server error; Be sure you save your work!";
	if (json && json.die_message && !isblank(json.die_message)) {
		die_message += "\n\n" + json.die_message;
	}
	$('saveButton').style.display = 'inline';
	autoSaveDisabled = 1;
	stopAutoSaveTimers();
	alert(die_message);

	if (index != null)
	  autoSaveActive[index] = 0;
	if (autoSavesActive > 0)
		autoSavesActive --;
}

// This function "replaces" the is_info_saved function that is defined later on.  The startAutoSaveTimer
// function does the replacement.  The purpose is to make it possible for us to also catch the situation
// where a document has been 'AutoSaved' but not saved.
var autoSaveIsInfoSavedOrig = null;

function autoSaveIsInfoSaved() {
	if (autoSavesActive > 0) {
		if (autoSaveMightBeStuck > 2) {
			// Make sure autosave stops working here
			stopAutoSaveTimers();
			
			// Warn user about potential save problem with Auto Backup
			alert ("It looks like Auto Save might be stuck; please come back to this page\nto verify your calendar has really been saved later.");
		}
		else {
			alert ("Please wait for Auto Save to complete before navigating to another page");
			autoSaveMightBeStuck ++;
			return false;
		}
	}
	
	// Make sure autosave stops working here
	stopAutoSaveTimers();
	
	// Make sure the global calendar modified flag is set
	if (g_calendarDirty)
		g_calendar_modified = 'y';

	// The user "has oked" leaving the page--they clicked something
	userHasOkedLeavingPageAlready = 1;

	return true;
}

// This function is called by the document body onbeforeunload handler.  This is a special event handler
// that is not like any other event handler.  If a string is returned, that string, along with browser
// specific text, is displayed to the user along with an OK and a Cancel button.  If the user clicks
// OK, the window is allowed to be closed/navigated away from/whatever.  If the user clicks cancel, then
// the window is not closed and/or the page is not navigated away from.
//
// Oh, one other thing, this function cannot return anything at all (no return statement) if you do not
// want a box to pop up at all.
//
// Because we handle a lot of these situations already, a special flag, userHasOkedLeavingPageAlready,
// is used to tell this code not to return a prompt to the user in cases where it normaly would.
function bodyOnBeforeUnloadHandler() {
	if (autoSavesActive > 0 && autoSaveMightBeStuck <= 2) {
		return "Auto Backup or Save is active.\n\n   * To guarantee your calendar is saved, press \"Cancel\"\n     and wait 15 seconds before continuing.\n\n   * To leave this page anyway, press \"OK\"";
	}

	if (userHasOkedLeavingPageAlready == 0 && g_calendarDirty) {
		$('saveButton').style.display = 'inline';
		return "Your calendar has not been auto saved.\n\nDo you want to save your calendar before leaving?\n\n   * To save your work, press \"Cancel\" and then \"Save\"\n\n   * To leave without saving your work, press \"OK\"";
	}
	
	// If the user chooses to stay, there is no way for us to find out.  We will "clear" the Oked flag
	// here so that the user has to OK leaving again.
	userHasOkedLeavingPageAlready = 0;
}

// This function is called when the auto save timer event is fired.  It creates an auto save request using
// a subset of the current form variables, and updating the form request variable.  The request is handled by the
// prototype javascript library Ajax.Request object which will fire specific events based upon the
// success or failure of the request.  These results are passed to the above autoSaveComplete....
// functions.  If the document has not been modified, it resets the timer so that it will check for
// changes again at the next autosave interval.
function calendarAutoSave(index) {
  if (autoSaveDisabled === 1)
    return;

  if (autoSaveActive[index])
    return;

	// Flag this index as busy
	autoSaveActive[index] = 1;
	autoSavesActive ++;

	// Clear any pending timer because we are going to save now; the timer is set by someone pressing a
	// key in a particular textarea; it is used to save data even if the user doesn't change focus to
	// something else (by pressing tab or clicking on something else).
	stopAutoSaveTimer(index);

	// Set up the parameter array to be passed back to the server
	var params = {
		what_button_was_pressed: 'AutoSave',
		session_user_name: document.form1.session_user_name.value,
		calname: document.form1.calname.value,
		requestIndex1: index
	};

	// Have to extract "i" value from my_id field
	var my_id_params = document.form1.my_id.value.toQueryParams();
	if (my_id_params.i != null) {
		params.i = my_id_params.i;
	}
	else {
		alert("Unable to determine i value for AutoBackup function");
		return;
	}

	// Have to use 'eval' to get the values from the particular index we are working
	eval('params.request1 = document.form1.request' + index + '.value;');
	eval('params.crcDay1 = document.form1.crcDay' + index + '.value;');
	eval('params.updatecount1 = document.form1.updatecount' + index + '.value;');
	eval('params.yyyymmddDay1 = document.form1.yyyymmddDay' + index + '.value;');
	eval('params.existingRecord1 = document.form1.existingRecord' + index + '.value;');
	
	// Pass the index we were working on--this is so the updated data can be put in the right place later on
	params.requestIndex1 = index;
	params.numOfDaysToSave = 1;
	
	// Cookie checking code
	if ( typeof(checkSessionCookie) == 'function' ) {
		if ( checkSessionCookie() != true ) {
			params.session_id = session_id;
		}
	}
	
	// Send the ajax request
	new Ajax.Request('save_day.php', {
		method: 'POST',
		parameters: params,
		onSuccess: function(transport) {
			var index = null;
			if (transport.request && transport.request.parameters && transport.request.parameters.requestIndex1)
			  index = transport.request.parameters.requestIndex1;
		  if (transport.responseText) {
				var json = transport.responseText.evalJSON();
				if (!json || !json.result || json.result != "OK")
					calendarAutoSaveCompleteFailure(json, index);
				else
					calendarAutoSaveCompleteSuccess(json, index);
			}  
			else
				calendarAutoSaveCompleteFailure(null, index);
			},
		onFailure: function(transport) {
			var index = null;
			if (transport.request && transport.request.parameters && transport.request.parameters.requestIndex1)
			  index = transport.request.parameters.requestIndex1;
			calendarAutoSaveCompleteFailure(null, index);
		},
		onException: function(request, e) {
			if (e.toString)
				alert("Exception: " + e.toString());
			else
				alert("Exception");
			var index = null;
			if (request.parameters && request.parameters.requestIndex1)
			  index = request.parameters.requestIndex1;
			calendarAutoSaveCompleteFailure(null, index);
		}
	});
}

// Function to save only if a day has been flagged as changed
function calendarSaveDayIfChanged(index) {
	if (g_calendarDayModified[index] == true) {
		calendarAutoSave(index);
	}
}

// Function to track when a day has been changed (had text entered)
function calendarDayHasChanged(index) {
	g_calendarDayModified[index] = true;
	g_calendarDirty = true;
}

// Function to clear day changed flag, and possibly calendar dirty flag
function calendarDayHasBeenSaved(index) {
	var i;
	
	g_calendarDayModified[index] = false;

	for (i = 0; i < g_calendarDayModified.length; i++) {
		if (g_calendarDayModified[i] == true)
			break;
	}
	
	if (i == g_calendarDayModified.length) {
		g_calendarDirty = false;
		g_calendar_modified = 'n'; // XX - this is defined in the main page code
	}
}

// KeyPress handler
function calendarHandleKeyPress(e, index) {
	g_calendar_modified = 'y'; // XX - this is defined in the main page code
	startAutoSaveTimer(index);
}

// KeyDown handler
function calendarHandleKeyDown(e, index) {
	if (document.all)
		e = window.event;
		
	var key;
	if (e.which)
		key = e.which;
	if (document.all)
		key = e.keyCode;

	// Catch special case of backspace/delete in IE since IE doesn't call onKeyPress event handlers
	// for backspace and delete.
	if (key == 8 || key == 46)
		calendarHandleKeyPress(e, index);
}

// onPaste handler (IE/Safari)
function calendarHandlePaste(index) {
	g_calendar_modified = 'y'; // XX - this is defined in the main page code
	startAutoSaveTimer(index);
}

// onCut handler (IE/Safari)
function calendarHandleCut(index) {
	g_calendar_modified = 'y'; // XX - this is defined in the main page code
	startAutoSaveTimer(index);
}

// onInput handler (FF)
function calendarHandleInput(index) {
	g_calendar_modified = 'y'; // XX - this is defined in the main page code
	startAutoSaveTimer(index);
}

// This function is used to start/restart the autosave process
function startAutoSaveTimer(index) {
	// Ok, this is called when the user changes a cell, so keep track of it:
	calendarDayHasChanged(index);
	
	// This code hooks our autoSaveIsInfoSaved function in place of the default is_info_saved
	if (is_info_saved != autoSaveIsInfoSaved) {
		autoSaveIsInfoSavedOrig = is_info_saved;
		is_info_saved = autoSaveIsInfoSaved;
	}
	
	// This code hooks our onunloadevent handler
	if (window.onbeforeunload != bodyOnBeforeUnloadHandler) {
		window.onbeforeunload = bodyOnBeforeUnloadHandler;
	}

	// If a timer is already running, stop it
  if (autoSaveTimers[index] != null)
		stopAutoSaveTimer(index);

  // Set a timer
  autoSaveTimers[index] = setTimeout('calendarAutoSave(' + index + ');', autoSaveTimeout);
}

// This function is used to stop the autosave process.  If an autosave request
// is currently being processed, this function does not stop it.  It only stops
// the timer from being reset to run again by those processes.
function stopAutoSaveTimer(index) {
  if (autoSaveTimers[index] != null)
    clearTimeout(autoSaveTimers[index]);
  autoSaveTimers[index] = null;
}

function stopAutoSaveTimers() {
	var i;
	for (i = 0; i < autoSaveTimers.length; i++) {
		stopAutoSaveTimer(i);
	}
}

function forceAutoSaveWithCallback(callback) {
	var i;

	// Make sure autosave isn't already running
	if (autoSavesActive > 0) {
		alert("AutoSave is currently saving your calendar; please wait a second and try again");
		return false;
	}
	
  // Stop any pending save timers
	stopAutoSaveTimers();

	// Set the callback function to be called when all modified calendars are saved.
	autoSaveForceCallback = callback;
	
	// Now look for any modified calendars
	for (i = 0; i < g_calendarDayModified.length; i++) {
		calendarSaveDayIfChanged(i);
	}
	
	// See how many auto saves are active, if zero we should call the callback now
	if (autoSavesActive == 0 && autoSaveForceCallback != null) {
		autoSaveForceCallback();
		autoSaveForceCallback = null;
	}
	
	// Otherwise, create a div that pops up to say we are saving, maybe??
	else {
	}
	
	// Return false so we can be used in events
	return false;
}
