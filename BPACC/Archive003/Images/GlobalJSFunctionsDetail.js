/// <reference name="MicrosoftAjax.js" />
/// <reference name="Util.js" />
/// <reference path="GlobalJSFunctionsDetail.js" />
var ajax_call_counter = 0;
var safariRateLimited = null;
var validationCallbacks = new Array();
var numbersOnly = new RegExp('^[0-9]*$');
var isie6 = false; // Should be set by conditional comments on page.
var isie7 = false;
var isie = window.clipboardData;

// User-agent sniffing for functions that rely on the user-agent
// to determine version of Safari. Avoid using this variable and
// check for the presence of features instead (best-practice).
var isWebKit = (navigator.userAgent.toLowerCase().indexOf('webkit') > -1);

// Determines if an array contains an object.
// Uses == equality, case-sensitive. a containsExact() could do === equality.
if (!Array.prototype.contains) {
	Array.prototype.contains = function(item) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == item)
				return true;
		}
		return false;
	}
}

// Gets index of an item if it is present in the array, else returns -1.
if (!Array.prototype.indexOf) {
	Array.prototype.indexOf = function(item) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == item)
				return i;
		}
		return -1;
	}
}

// Implement ECMAScript 5 String.trim() and friends for browsers that
// don't have it (e.g. Firefox prior to 3.5, Internet Explorer 6, 7, 8).
if (!String.prototype.trim) {
	String.prototype.trim = function() {
		return this.replace(/^\s+/g, "").replace(/\s+$/g, "");
	}
	String.prototype.trimLeft = function() {
		return this.replace(/^\s+/g, "");
	}
	String.prototype.trimRight = function() {
		return this.replace(/\s+$/g, "");
	}
}

// Implement .NET-style left-padding method.
String.prototype.padLeft = function(desiredLength, paddingChar) {
	paddingChar += '';
	desiredLength = parseInt(desiredLength);
	
	if (paddingChar.length > 1)
		paddingChar = paddingChar.charAt(0);
	else if (paddingChar.length < 1)
		return this;
	
	if (this.length >= desiredLength)
		return this;
	else {
		var arr = new Array();
		var padNum = desiredLength - this.length;
		
		for (var i = 0; i < padNum; i++)
			arr.push(paddingChar);
		
		return arr.join('') + this;
	}
}
	
// Implement .NET-style right-padding method.
String.prototype.padRight = function(desiredLength, paddingChar) {
	paddingChar += '';
	desiredLength = parseInt(desiredLength);
	
	if (paddingChar.length > 1)
		paddingChar = paddingChar.charAt(0);
	else if (paddingChar.length < 1)
		return this;
	
	if (this.length >= desiredLength)
		return this;
	else {
		var arr = new Array();
		var padNum = desiredLength - this.length;
		
		for (var i = 0; i < padNum; i++)
			arr.push(paddingChar);
		
		return this + arr.join('');
	}
}

String.isNullOrEmpty = function(text) {
	return (text == null || text == '');
}

// Validation plugs for runat=server form in master page.
function headerValidationCallback() {
	for (var i = 0; i < validationCallbacks.length; i++) {
		if (!validationCallbacks[i]())
			return false;
	}
	return true;
}

function addHeaderValidator(method) {
	validationCallbacks.push(method);
}

// Copies text data to clipboard in WebKit browsers (Chrome/Safari).
function toWebkitClipboard(text) {
	// Create element in DOM with text to copy.
	var tmp = document.createElement('div');
	tmp.textContent = text;
	document.body.appendChild(tmp);
	
	// Get current user selection, and remove selection current ranges.
	var curSelection = window.getSelection();
	curSelection.removeAllRanges();
	
	// Create new selection range with DOM element containing text to copy.
	var textRange = document.createRange();
	textRange.selectNode(tmp);
	curSelection.addRange(textRange);
	
	// Execute COPY DHTML command.
	document.execCommand("Copy");
	
	// Clean-up.
	document.body.removeChild(tmp);
}

// Copies value in stringVal to the clipboard, displaying the successMessage if hideAlert is false.
// NOTE: Replace this with something like toWebkitClipboard() at some point.
function toClipboardEx(stringVal, hideAlert, successMessage) {
	if (window.clipboardData) {		// Internet Explorer
		if (!window.clipboardData.setData("Text", stringVal) && !hideAlert)
			hideAlert = true;
	}
	else if ((window.WebKitPoint || !window.netscape) && !window.opera) {
		toWebkitClipboard(stringVal);
	}
	else if (window.netscape) {	// Mozilla Firefox and derivitives (Netscape, Seamonkey)...
		try {
			// Request full access to the XPCOM (Cross-Platform COM) API.
			netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
		}
		catch (e) {
			// Unable to obtain access, user rejected or setting in about:config not set right.
			alert('Please type "about:config" in your browser and press enter. Type "signed.applets.codebase_principal_support" in Filter. Double click to change the value to "true". Then come back and click on the link again.\n\nIf you have already performed this action, make sure when you are asked whether to allow or deny the browser permission, that you are allowing it.');
			return;
		}
		
		// Create an instance of the clipboard class.
		var clipBoard = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
		
		// Create an instance of the Transferable class (used to talk to the clipboard).
		var clipTrans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
		
		// Set clipboard format for text only.
		clipTrans.addDataFlavor('text/unicode');
		
		// Create XPCOM string, set data to copy of stringVal.
		var clipString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
		var copyText = stringVal;
		clipString.data = copyText;
		
		// Note: This code may be bugged in some scenarios! 1 char does not always equal 2 bytes in UTF-16!
		// Set data to transfer to the clipboard (length * 2, since 1 char is usually 2 bytes in UTF-16).
		clipTrans.setTransferData("text/unicode", clipString, copyText.length * 2);
		
		// Transfer data to the global clipboard.
		clipBoard.setData(clipTrans, null, clipBoard.kGlobalClipboard);
	}
	
	if (!hideAlert)
		alert(successMessage);
	
	return true;
}

function toClipboard(stringVal, hideAlert) {
	return toClipboardEx(stringVal, hideAlert, "The link has been copied to your clipboard.");
}

function getClipboard() {
	if (window.clipboardData) {
		return window.clipboardData.getData('Text');
	} else if (window.netscape) {
		try {
			netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
		}
		catch (e) {
			alert('Please type "about:config" in your browser and press enter. Type "signed.applets.codebase_principal_support" in Filter. Double click to change the value to "true". Then come back and click on the link again.\n\nIf you have already performed this action, make sure when you are asked whether to allow or deny the browser permission, that you are allowing it.');
			return;
		}
		
		// Create instances of the Clipboard and Transferable objects.
		var clipBoard = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
		var clipTrans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
		
		// Get data from global clipboard, place in clipTrans object.
		clipTrans.addDataFlavor('text/unicode');
		clipBoard.getData(clipTrans, clipBoard.kGlobalClipboard);
		
		// Create objects to pass to getTransferData, which uses XPCOM String
		// and Integer classes instead of those normally used by JavaScript.
		var objStr = new Object(); var objNumBytes = new Object();
		try {
			clipTrans.getTransferData('text/unicode', objStr, objNumBytes);
		}
		catch (error) {
			return '';
		}
		
		// Query whichever interface is available, opting to use nsISupportsWString.
		if (objStr) {
			if (Components.interfaces.nsISupportsWString)
				objStr = objStr.value.QueryInterface(Components.interfaces.nsISupportsWString);
			else if (Components.interfaces.nsISupportsString)
				objStr = objStr.value.QueryInterface(Components.interfaces.nsISupportsString);
			else
				objStr = null;
		}
		
		// Note: This code may be bugged in some scenarios! 1 char does not always equal 2 bytes in UTF-16!
		// Get data out of the XPCOM string and into a normal JS string.
		if (objStr)
			return (objStr.data.substring(0, objNumBytes.value / 2));
	}
	return;
}

// Gets the computed style of an element (browser-independent).
var getCurrentStyle = (document.defaultView ?
	function(elem) {
		return document.defaultView.getComputedStyle(elem, '');
	} :
	function(elem) {
		return elem.currentStyle;
	}
);

// Gets children nodes of an HTML DOM element matching the tag name specified.
function getChildNodesByTag(domElement, tagName) {
	var cn = domElement.childNodes;
	var nodesPresent = 0, retVal = new Array();
	retVal.length = cn.length;
	
	tagName = tagName.toUpperCase();
	for (var cv = 0; cv < cn.length; cv++) {
		if (cn[cv].nodeType == 1 && cn[cv].nodeName == tagName)
			retVal[nodesPresent++] = cn[cv];
	}
	
	return retVal.slice(0, nodesPresent);
}

// Returns true on Safari browsers 1.3.4 and older (bad date object behavior in old Safari).
// Check does not work properly if user-agent has been modified by user.
var isSafariVersion13OrOlder = (isWebKit ?
	function() {
		var navAppVersion = navigator.appVersion;
		var phraseToFind = 'AppleWebKit/';
		var foundStartAt = navAppVersion.indexOf(phraseToFind) + phraseToFind.length;
		var foundEndAt = navAppVersion.indexOf(' ', foundStartAt + 1);
		return (parseInt(navAppVersion.substring(foundStartAt, foundEndAt)) < 320);
	} :
	function() {
		return false;
	}
);

// Returns true on Safari browsers 2.0.4 and older (textbox/button not stylable before 3.x).
// Check does not work properly if user-agent has been modified by user.
var isSafariVersion20OrOlder = (isWebKit ?
	function() {
		var navAppVersion = navigator.appVersion;
		var phraseToFind = 'AppleWebKit/';
		var foundStartAt = navAppVersion.indexOf(phraseToFind) + phraseToFind.length;
		var foundEndAt = navAppVersion.indexOf(' ', foundStartAt + 1);
		return (parseInt(navAppVersion.substring(foundStartAt, foundEndAt)) < 525);
	} :
	function() {
		return false;
	}
);

// Returns true if an event fired too soon after another event.
// Mechanism used on older Safari browsers to prevent 
// double-fire problems (especially with key presses).
function safariEventRateLimitBlock() {
	if (isWebKit && isSafariVersion13OrOlder()) {
		if (safariRateLimited != 0)
			return true;
		else {
			safariRateLimited = setTimeout('safariRateLimited = 0;', 10);
			return false;
		}
	}
}

// Get coordinates relative to document (works out container issues).
// Wrote this so it works in quirks or standards mode.
function getDocumentCoordinates(element) {
	var htmlElem = document.body.parentNode;
	var bodyElem = document.body;
	var pos = { "x": 0, "y": 0 };
	pos.toString = function() { return this.x + ', ' + this.y; }
	while (element != null) {
		pos.x += element.offsetLeft;
		pos.y += element.offsetTop;
		switch (element.offsetParent) {
			case htmlElem:
			case bodyElem:
			case null:
				return pos;
		}
		element = element.offsetParent;
	}
}

// Attach an event handler to an object (browser-independent).
// First clause is W3C DOM method, second is DHTML (IE).
var addEvent = (window.addEventListener ?
	function(obj, evType, fn, useCapture) {
		try {
			obj.addEventListener(evType, fn, useCapture);
		} catch (e) { }
		return true;
	} :
	function(obj, evType, fn, useCapture) {
		try {
			return obj.attachEvent('on' + evType, fn);
		} catch (e) { }
	}
);

// Release an event handler from an object (browser-independent).
// First clause is W3C DOM method, second is DHTML (IE).
var removeEvent = (window.removeEventListener ?
	function(obj, evType, fn, useCapture) {
		try {
			obj.removeEventListener(evType, fn, useCapture);
		} catch (e) { }
		return true;
	} :
	function(obj, evType, fn, useCapture) {
		try {
			obj.detachEvent('on' + evType, fn);
		} catch (e) { }
		return true;
	}
);

// Stops a DOM event from propagating further than the current handler.
// Note: Returning false from event handlers in IE 6/7/8 does the same thing.
function stopEventPropagation(evObj) {
	if (evObj.preventDefault)
		evObj.preventDefault();
	
	// Calling cancelButton after stopPropagation
	// may negate the stopPropagation so do not do it. -KB
	if (evObj.stopPropagation)
		evObj.stopPropagation();
	else if (evObj.cancelBubble)
		evObj.cancelBubble();
}

// These functions assists in obscuring email addresses:
function mailTo(obj) {
	//alert('mailto:'+eval(obj.getAttribute('id')));
	obj.setAttribute('href', 'mailto:' + eval(obj.getAttribute('id')));
}

function js_mail(obj, Emails) {
	var mail_link = Emails[0];
	for (var email = 1; email < Emails.length; email++)
		if (Emails[email] != null && Emails[email] != '' && Emails[email].substr(1, 4) != 'href') mail_link = mail_link + Emails[email];

	obj.setAttribute('href', 'mailto:' + mail_link);
}

// Used to prevent right-click menu from appearing for some clients that wanted this ability.
function antiContextMenuHook() {
	// Note: Opera is not hookable.
	var showAlert = function() { alert('All images are protected by Copyright. Do not use without permission.'); }
	var mdClick = function(e) {
		if (!document.all) {
			if (e.button == 2 || e.button == 3)
				showAlert();
		}
		else if (event && event.button == 2)
			showAlert();
	}
	var cmClick = function(e) {
		if (navigator.userAgent.toLowerCase().indexOf('khtml') > -1) {
			// Safari, Konquerer
			if (e.preventDefault)
				e.preventDefault();
			showAlert();
		}
		if (e.stopPropagation)
			e.stopPropagation(); // Mozilla Firefox 2.0
		return false; // IE 6.0 and 7.0
	}
	document.onmousedown = mdClick;
	document.oncontextmenu = cmClick;
}

// Form validation functions:
function RegExValidate(expression, value, param) {
	var re = new RegExp(expression, param);
	if (value.match(re)) return true;
	else return false;
}

// Used for validating emailaddress for special scenarios like continuous periods. - VB
function checkSpecialScenarios(s) {
	var bugchars = '!#$^&*()+|}{[]?><~%:;/,=`"\'';
	var i;
	var lchar = "";
	// Search through string's characters one by one.
	// If character is not in bag.
	for (i = 0; i < s.length; i++) {
		// Check that current character isn't whitespace.
		var c = s.charAt(i);
		if (i > 0) lchar = s.charAt(i - 1)
		if (bugchars.indexOf(c) != -1 || (lchar == "." && c == ".")) return false;
	}
	return true;
}

// JavaScript version of CivicPlus.CMS.Site.Validation.IsValidEmailAddress();
function emailValidate(emailAddress) {
	var emailAddressTrimmed = TrimString(emailAddress + "");
	if (emailAddressTrimmed != "") {
		if (checkSpecialScenarios(emailAddressTrimmed) == false)
			return false;
		var parts = emailAddressTrimmed.splitRemoveEmpties('@');
		if (emailAddressTrimmed.substr(emailAddressTrimmed.length - 1) == '@')
			return false;
		if (parts.length == 2) {
			for (var i = 0; i < parts.length; i++) {
				if (!RegExValidate('^[A-Z0-9]$', parts[i].substr(0, 1), 'i') || (!RegExValidate('^[A-Z0-9]$', parts[i].substr(parts[i].length - 1), 'i')) || (!RegExValidate('^[A-Z0-9_%-\\.]+$', parts[i].substr(1, parts[i].length - 1), 'i')))
					return false;
			}
			var lastDotPos = parts[1].lastIndexOf('.');
			if (lastDotPos < 0 || parts[1].substr(lastDotPos).length < 3 || (!RegExValidate('^[A-Z]+$', parts[1].substr(lastDotPos + 1), 'i')))
				return false;
			else
				return true;
		}
		else
			return false;
	}
	else
		return false;
}

// Returns: 0 - success, 1 - illegal value, 2 - too large, 3 - too small, 4 - blank.
function intValidateWithRange(value, min, max) {
	if (value == '' || value == null) return 4;
	if (RegExValidate('^(-|)[0-9]*$', value, 'i')) {
		try { var pint = parseInt(value); } catch (ex) { return 1; }
		if (pint < min) return 3; else if (pint > max) return 2; return 0;
	} else
		return 1;
}

// Split function that remotes empty entries.
String.prototype.splitRemoveEmpties = function(separator, howmany) {
	var splitArr;
	var returnArr = new Array();

	if (arguments.length == 2)
		splitArr = this.split(separator, howmany);
	else
		splitArr = this.split(separator);

	for (var i = 0; i < splitArr.length; i++) {
		if (splitArr[i] != '')
			returnArr.push(splitArr[i]);
	}

	return returnArr;
}

// JavaScript equivalent of a function in GlobalFunctionsDetail.aspx.
// Do not use this function unless you have a good reason (e.g. textarea length on client must match size on server).
// KNOWN: Does not do entities properly, matches server behavior (where's the semi-colon?).
function SQLSafe(strInput) {
	return strInput.replace(/\'/g, "&#39").replace(/\"/g, "&#34");
}

// Returns true if the string is empty. Will blow up on NULLs.
function FieldIsEmpty(strInput) {
	return TrimString(strInput).length == 0;
}

// Removes leading and trailing white space from a string. Will blow up on NULLs.
function TrimString(strInput) {
	return strInput.replace(/^\s+/g, "").replace(/\s+$/g, "");
}

// Returns true if the value is an integer value.
function isInteger(strInput) {
	return (strInput == parseInt(strInput).toString());
}

// Returns true if the value is a real number.
function isRealNumber(strInput) {
	return (strInput == parseFloat(strInput));
}

// Date validator class.
function dateValidator() {
	this.firstValidDate = new Date('01/01/1753');
	this.lastValidDate = new Date('01/01/3000');
	this.strStartDateID = 'Start/Begin Date';
	this.strEndDateID = 'End/Stop/Expiration Date';
	this.strStartTimeID = 'Start Time';
	this.strEndTimeID = 'End Time';
	this.ysnRequireStartDateIfEndSpecified = false;
	this.ysnStartDateRequired = false;
	this.ysnEndDateRequired = false;
	this.ysnStartTimeRequired = false;
	this.ysnEndTimeRequired = false;
	this.ysnAllowEqualDates = false;
	this.ysnCent = false; //Allow only four digit years
	var dtiEndDate;
	var dtiStartDate;

	this.setStartDate = function(date) {
		dtiStartDate = this.cleanDate(date);
	}

	this.setEndDate = function(date) {
		dtiEndDate = this.cleanDate(date);
	}

	this.cleanDate = function(date) {
		if (date) {
			if (RegExValidate('^([0-9\-\\\/]*?)([0-9]{2,4})$', date, 'i')) {
				var year = RegExp.$2;
				if (year.length == 2) {
					if (year >= 50) date = RegExp.$1 + "19" + year;
					else date = RegExp.$1 + "20" + year;
				}
				date = date.replace('\-', '/', 'g');
			}
		}
		return date;
	}

	this.dateValidate = function(dtiDate, ysnRequired, strID) {
		if (!ysnRequired && dtiDate == '') return true;
		else if (ysnRequired && dtiDate == '') {
			if (strID) this.error = strID + ' is required';
			else this.error = ' is required';
			this.errorNumber = 1;
			return false;
		}
		else if (RegExValidate('^(1[0-2]|0?[1-9])(\/|\-)(0?[1-9]|[1-2][0-9]|3[0-1])\\2([0-9]{4}|[0-9]{2})$', dtiDate, 'i')) {
			var month = RegExp.$1;
			var day = RegExp.$3;
			var year = RegExp.$4;

			if (year.length == 2 && this.ysnCent == true) {
				if (strID) this.error = strID + ' requires a four digit year';
				else this.error = 'Please use a four digit year';
				return false;
			}
			if (year.length == 4 && (year > 3000 || year < 1753)) {
				this.error = dtiDate + '\nis outside of the date range.';
				this.errorNumber = 2;
				return false;
			}
			if (day == 31 && (month == 4 || month == 6 || month == 9 || month == 11)) {
				this.error = 'This month doesn\'t have 31 days';
				this.errorNumber = 3;
				return false;
			}
			if (day >= 30 && month == 2) {
				this.error = 'February doesn\'t have ' + day + ' days';
				this.errorNumber = 4;
				return false;
			}
			if (month == 2 && day == 29 && !(year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
				this.error = 'This is not a leap year\nFebruary doesn\'t have 29 days.';
				this.errorNumber = 5;
				return false;
			}
			return true;
		}
		else {
			if (strID) this.error = strID + ' is not a valid date format.\nPlease use mm/dd/yyyy.';
			else this.error = dtiDate + '\n is an invalid date format.\nPlease use mm/dd/yyyy.';
			this.errorNumber = 6;
			return false;
		}
		return false;
	}

	this.dateOrderValidate = function() {
		if (this.dateValidate(dtiStartDate, this.ysnStartDateRequired, this.strStartDateID) && this.dateValidate(dtiEndDate, this.ysnEndDateRequired, this.strEndDateID)) {
			if (this.ysnRequireStartDateIfEndSpecified && !dtiStartDate && dtiEndDate) {
				this.error = 'A start date must be specified if an end date was entered.'
				this.errorNumber = 9; return false;
			}
			if (!dtiStartDate || !dtiEndDate) return true;
			else {
				var StartDate = new Date(dtiStartDate);
				var EndDate = new Date(dtiEndDate);
			}
			if (StartDate.getTime() < EndDate.getTime()) return true;
			else if (StartDate.getTime() == EndDate.getTime() && this.ysnAllowEqualDates == true) {
				this.ysnDatesAreEqual = true;
				return true;
			}
			else {
				this.error = 'The end date must be after the start date.';
				this.errorNumber = 7; return false;
			}
		}
		else return false;
	}

	this.dateValidateNew = function (dtiDate, ysnRequired, strID) {
		var month;
		var day;
		var year;
		
		if (!ysnRequired && dtiDate == '') return true;

		if (ysnRequired && dtiDate == '') {
			if (strID) this.error = strID + ' is required';
			else this.error = ' is required';
			this.errorNumber = 1;
			return false;
		}

		var dateFormat;
		$.ajax({
			url: '/Utility/GetDateFormat',
			async: false,
			type: 'GET',
			dataType: 'json',
			success: function (data) {
				dateFormat = data.dateFormat;
			},
			error: function (jqXHR, textStatus, errorThrown) {
				dateFormat = "mm/dd/yyyy";
			}
		});

		if ((dateFormat == "mm/dd/yyyy") && (RegExValidate('^(1[0-2]|0?[1-9])(\/|\-)(0?[1-9]|[1-2][0-9]|3[0-1])\\2([0-9]{4}|[0-9]{2})$', dtiDate, 'i'))) {
			month = RegExp.$1;
			day = RegExp.$3;
			year = RegExp.$4;

			return this.validDateParts(month, day, year);
		}

		if ((dateFormat == "dd/mm/yyyy") && (RegExValidate('^(0?[1-9]|[1-2][0-9]|3[0-1])(\/|\-)(1[0-2]|0?[1-9])\\2([0-9]{4}|[0-9]{2})$', dtiDate, 'i'))) {
			month = RegExp.$3;
			day = RegExp.$1;
			year = RegExp.$4;

			return this.validDateParts(month, day, year);
		}

		if (strID) this.error = strID + ' is not a valid date format.\nPlease use ' + dateFormat + '.';
		else this.error = dtiDate + '\n is an invalid date format.\nPlease use ' + dateFormat + '.';
		this.errorNumber = 6;

		return false;
	}

	this.validDateParts = function (month, day, year) {
		if (year.length == 2 && this.ysnCent == true) {
			if (strID) this.error = strID + ' requires a four digit year';
			else this.error = 'Please use a four digit year';
			return false;
		}
		if (year.length == 4 && (year > 3000 || year < 1753)) {
			this.error = dtiDate + '\nis outside of the date range.';
			this.errorNumber = 2;
			return false;
		}
		if (day == 31 && (month == 4 || month == 6 || month == 9 || month == 11)) {
			this.error = 'This month doesn\'t have 31 days';
			this.errorNumber = 3;
			return false;
		}
		if (day >= 30 && month == 2) {
			this.error = 'February doesn\'t have ' + day + ' days';
			this.errorNumber = 4;
			return false;
		}
		if (month == 2 && day == 29 && !(year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
			this.error = 'This is not a leap year\nFebruary doesn\'t have 29 days.';
			this.errorNumber = 5;
			return false;
		}
		return true;
	}

	this.dateOrderValidateNew = function () {
		if (this.dateValidateNew(dtiStartDate, this.ysnStartDateRequired, this.strStartDateID) && this.dateValidateNew(dtiEndDate, this.ysnEndDateRequired, this.strEndDateID)) {
			if (this.ysnRequireStartDateIfEndSpecified && !dtiStartDate && dtiEndDate) {
				this.error = 'A start date must be specified if an end date was entered.'
				this.errorNumber = 9; return false;
			}
			if (!dtiStartDate || !dtiEndDate) return true;
			else {
				var StartDate = new Date(this.getStandardDate(dtiStartDate));
				var EndDate = new Date(this.getStandardDate(dtiEndDate));
			}
			if (StartDate.getTime() < EndDate.getTime()) return true;
			else if (StartDate.getTime() == EndDate.getTime() && this.ysnAllowEqualDates == true) {
				this.ysnDatesAreEqual = true;
				return true;
			}
			else {
				this.error = 'The end date must be after the start date.';
				this.errorNumber = 7; return false;
			}
		}
		else return false;
	}

	this.getStandardDate = function (dateText) {
		$.ajax({
			url: '/Utility/GetDate?dateText=' + dateText,
			async: false,
			type: 'GET',
			dataType: 'json',
			success: function (data) {
				dateText = data.date;
			},
			error: function (jqXHR, textStatus, errorThrown) {
			}
		});

		return dateText;
	}

	this.smallDateTimeMaxValueValidate = function () {
		var StartDate = new Date(dtiStartDate);
		var EndDate = new Date(dtiEndDate);
		var MaxDate = new Date('05/06/2079 23:59:59');
		var result = true;
		if (StartDate <= MaxDate && EndDate <= MaxDate) {
			result = true;
		}
		else if (StartDate > MaxDate) {
			this.error = "The start date must be less than '5/6/2079'.";
			this.errorNumber = 2;
			result = false;
		}
		else if (EndDate > MaxDate) {
			this.error = "The end date must be less than '5/6/2079'.";
			this.errorNumber = 3;
			result = false;
		}
		return result;
	}

	this.format = function(format, date) {
		if (!date) var date = new Date();
		var day = date.getDate();
		var month = date.getMonth() + 1;
		var year = date.getFullYear();
		return format.replace(/dd/g, day).replace(/mm/g, month).replace(/y{1,4}/g, year)
	}

	this.timeValidate = function(ditTime, ysnRequired, strID) {
		if (!ysnRequired && ditTime == '') return true;
		else if (ysnRequired && ditTime == '') {
			if (strID) this.error = strID + ' is required';
			else this.error = 'Time is required';
			this.errorNumber = 1;
			return false;
		}
		else if (RegExValidate('^(1[0-2]|0?[1-9]):([0-5]?[0-9])(:([0-5][0-9]))?$', ditTime, 'i')) return true;
		else {
			if (strID) this.error = strID + ' is not valid.';
			else this.error = ' is not valid.';
			this.errorNumber = 8;
			return false;
		}
		return false;
	}

	this.timeOrderValidate = function() {
		if (!this.ysnAllowTimeOnly && ((!dtiStartDate && this.dtiStartTime) || (!dtiEndDate && this.dtiEndTime))) {
			this.error = 'You only submited a time.\nPlease provide a day as well.';
			this.errorNumber = 10;
			return false;
		}
		if (this.timeValidate(this.dtiStartTime, this.ysnStartTimeRequired, this.strStartTimeID) && this.timeValidate(this.dtiEndTime, this.ysnEndTimeRequired, this.strEndTimeID)) {
			if (!this.ysnDatesAreEqual) return true;

			var dtiStartTime = this.convertTo24Hour(this.dtiStartTime, this.strStartAMPM, dtiStartDate);
			var dtiEndTime = this.convertTo24Hour(this.dtiEndTime, this.strEndAMPM, dtiEndDate);

			if (dtiStartTime.getTime() < dtiEndTime.getTime()) return true;
			else if (dtiStartTime.getTime() == dtiEndTime.getTime() && this.ysnAllowEqualTimes == true) {
				this.ysnTimesAreEqual = true;
				return true;
			}
			else {
				this.error = 'The End Time must be after the Start Time if the Start and End Dates are the same.'
				this.errorNumber = 9;
				return false;
			}
			return false;
		}
		return false;
	}

	this.convertTo24Hour = function(time, AMPM, date) {
		if (!date) date = "1/1/70"
		time = new Date(date + " " + time);
		if (AMPM == 'AM' && time.getHours() == 12) time.setHours(0);
		else if (AMPM == 'PM' && time.getHours() != 12) time.setHours(time.getHours() + 12);
		return time;
	}
}

// Helper function for inputAlert().
function inputEmailValidate(obj, required) {
	if (required == null || required == false)
		return (obj.value == '' || emailValidate(obj.value) == true)
	else
		return (obj.value != '' && emailValidate(obj.value) == true)
}

// Note: This function does not match standard validation behavior! Users are supposed to see
// a summary of problems with their inputs and not be alerted multiple times!
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Calls another validation routine, and determines success/failure on result of call (true/false).
// Displays error message on validation failure. Returns result of call.
function inputAlert(call, obj, required, errorMessage) {
	call = eval('input' + call + 'Validate');
	if (call(obj, required) == false) {
		if (errorMessage == null)
			errorMessage = 'Please enter a single valid email address without any extra body, subject, etc. information (ie user@domain.com).';
		obj.setAttribute('autocomplete', 'off');
		obj.focus();
		obj.setAttribute('autocomplete', 'on');
		alert(errorMessage);
		return false;
	}
	else
		return true;
}
// End Form Validation functions.

// Begin AJAX functions:
// See http://blogs.msdn.com/xmlteam/archive/2006/10/23/using-the-right-version-of-msxml-in-internet-explorer.aspx
// If you are curious why the XMLHTTP versions specified are and why others are not.
function makeErrorRequest(url, status) {
	var http_error_request = false;
	var origin = location.pathname;

	if (window.XMLHttpRequest) { // Mozilla, Safari, IE7
		http_error_request = new XMLHttpRequest();
		if (http_error_request.overrideMimeType)
			http_error_request.overrideMimeType("text/html");
	} else if (window.ActiveXObject) { // IE6
		try {
			http_error_request = new ActiveXObject("Msxml2.XMLHTTP.6.0");
		} catch (e) {
			try {
				http_error_request = new ActiveXObject("Msxml2.XMLHTTP"); // Version 3.0
			} catch (e) { }
		}
	}

	http_error_request.onreadystatechange = function() { }
	http_error_request.open("GET", "/AJAX-error.ashx?url=" + escape(url) + "&status=" + status + "&origin=" + escape(origin), true);
	http_error_request.send(null);
	//if(status == 403) 
	//window.location = '/admin/AccessDenied.aspx?fromURL=' + window.location.pathname.substr(7);
}

// Makes AJAX request, additionally supporting POST data (makeHttpRequest doesn't).
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Note: It's YOUR responsibility as a developer to make sure data 
// placed in formData is formatted as it should be. Form data should be 
// in Query String format with the value portions escape()'d. -KB
function makeHttpRequestEx(URL, formData, callbackFunc, ysnReturnXML) {
	var xmlHttpRequest, sendMethod;

	if (window.XMLHttpRequest) { // Mozilla, Safari, IE7
		xmlHttpRequest = new XMLHttpRequest();
		if (xmlHttpRequest.overrideMimeType && !ysnReturnXML)
			xmlHttpRequest.overrideMimeType("text/html");
	} else if (window.ActiveXObject) { // IE6
		try {
			xmlHttpRequest = new ActiveXObject("Msxml2.XMLHTTP.6.0");
		} catch (e) {
			try {
				xmlHttpRequest = new ActiveXObject("MSxml2.XMLHTTP"); // Version 3
			} catch (e) { }
		}
	}

	window.callbackFunc = callbackFunc;
	xmlHttpRequest.onreadystatechange = function() {
		if (xmlHttpRequest.readyState == 4)
			window.callbackFunc(xmlHttpRequest);
	}

	if (formData != null) {
		xmlHttpRequest.AddHeader("content-type", "application/x-www-form-urlencoded");
		sendMethod = "POST";
	}
	else
		sendMethod = "GET";

	xmlHttpRequest.open(sendMethod, URL, true);
	xmlHttpRequest.send(formData);

	return xmlHttpRequest;
}
// Makes AJAX request. Used in n-menu code.
function makeHttpRequest(url, callback_function, return_xml) {
	var http_request = false;

	if (window.XMLHttpRequest) { // Mozilla, Safari, IE7
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType && !return_xml)
			http_request.overrideMimeType("text/html");
	} else if (window.ActiveXObject) { // IE6
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP.6.0");
		} catch (e) {
			try {
				http_request = new ActiveXObject("MSxml2.XMLHTTP"); // Version 3
			} catch (e) { }
		}
	}

	if (!http_request) {
		alert("Unfortunately, your browser doesn't support this feature.");
		return false;
	}

	http_request.onreadystatechange = function() {
		if (http_request.readyState == 4) {
			--ajax_call_counter;

			//try {
				if (http_request.status == 200) {
					if (return_xml)
						eval(callback_function + ', http_request.responseXML)');
					else {
						if (http_request.responseText.search(/<form action='error.asp' method=post>/i) < 0)
							eval(callback_function + ', http_request.responseText)');
						else
							makeErrorRequest(url, http_request.status);
					}
				}
				else if (http_request.status)
					makeErrorRequest(url, http_request.status);
			//} catch (e) {
				// If this happens, there is no way to notify anyone
				// of the previous error. It might be their connection died,
				// or failed in some other way.

				//alert('An error occured while reporting the previous error.');
				//var USER_EXPLAIN_ERR_EN = '\n\nTechnical Details:\n' + e.name + ' - ';
				// IE 6 & 7: No Line Number, No Filename
				//if (document.all && !window.opera) { 
				//	alert(USER_EXPLAIN_ERR_EN + e.description + ' (line unavailable, code: ' + e.number + ')' + '\n\nJavaScript Callback:\n' + callback_function + ', <responseData>);');
				//} 
				// Opera and Firefox 1.5+: Line Number + Filename
				//else {
				//	alert(USER_EXPLAIN_ERR_EN + e.message + '\n' + e.fileName + ', line ' + e.lineNumber + '\n\nJavaScript Callback:\n' + callback_function + ', <responseData>);');
				//}
			//}

			http_request = null;
		}
	}

	http_request.open("GET", url, true);
	http_request.send(null);
}
// Invoked on window.onunload for pages using synchronous AHAH.
// Catches switches to different pages and window closes.
// -=-=-=-=-
// Note: It is synchronous instead of asynchronous to ensure 
// the operation completes before a close. This is SHAH.
//
function destroyAHAH(e) {
	var http_request;

	if (window.XMLHttpRequest) { // Mozilla, Safari, IE7
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType) {
			http_request.overrideMimeType("text/html");
		}
	} else if (window.ActiveXObject) { // IE6
		try {
			http_request = new ActiveXObject("MSXML2.XMLHTTP.6.0");
		} catch (e) {
			try {
				http_request = new ActiveXObject("MSXML2.XMLHTTP"); // Version 3
			} catch (e) { }
		}
	}

	if (!http_request) return;
	http_request.open("GET", 'http://' + window.location.host + '/AJAX-NMenuLoader.ashx?clearCache=1', false);
	http_request.send(null);
	//alert(http_request.status + ': if 200, the session cache object was term\'d where needed be.');
}
// End AJAX functions.

//  
//  slideShow class
//  vars:
//  slideShowId						constructor param for the id of the image that will have the Slide Show 
//  slideShowLink					constructor param for the id of the link that will be around the image that has Slide Show, use '' for no link
//  slideShowSpeed					optional constructor param for the speed of the slide show, default = 5000
//  filterName						optional constructor param for the IE filter, default = blendTrans
//  filterAttr1						optional constructor param for the IE filter, default = duration=3
//  filterAttr2						optional constructor param for the IE filter
//  filterAttr3						optional constructor param for the IE filter
//  j								counter for the object
//  picArr							array of pictures
//  altArr							array of alt text
//  linkArr							array of links
//  methods:
//  addImage(n, img, alt, link)		add an image with alt text and a link, n specifies which postion in the arrays
//  runSlideShow()					continually calls nextSlide to run the Slide Show
//  nextSlide()						applies the transition and advances the Slide Show image 1 spot in the arrays
//  mouseOver()						detects and loads that image to the Main Image Display & draws border around the slected image & removed border from the Other small image icons
function slideShow(slideShowId, slideShowLink, slideShowSpeed, filterName, filterAttr1, filterAttr2, filterAttr3, slideShowLinkTarget, layout) {
	if (!slideShowLinkTarget || slideShowLinkTarget == null || slideShowLinkTarget == "undefined" || slideShowLinkTarget == "")
		slideShowLinkTarget = "_self";
	if (!layout || layout == null || layout == "undefined")
		layout = 1;
	
	this.slideShowId = document.getElementById(slideShowId);

	this.picArr = new Array();
	this.altArr = new Array();
	this.linkArr = new Array();
	this.linkTargetArr = new Array();

	// If junk data causes one slideshow to fail the others should not.
	if (this.slideShowId == null) {
		this.addImage = function(n, img, alt, link, linkTarget) { }
		this.runSlideShow = function() { }
		this.nextSlide = function() { }
		this.mouseOver = function(elem, imgPath, altText) { }
		return;
	}

	var tmpElem = document.createElement('a');
	if (slideShowLink && slideShowLink != '') {
		do {
			slideShowLink = (slideShowLink).replace("%38", "&");
		} while ((slideShowLink).indexOf("%38") != -1)
		tmpElem.href = slideShowLink;
		if (slideShowLinkTarget && slideShowLinkTarget != '')
			tmpElem.target = slideShowLinkTarget;
	}
	else
		tmpElem.removeAttribute('href');

	this.j = 1;
	if (slideShowSpeed == null || slideShowSpeed == '')
		this.slideShowSpeed = 4000;
	else
		this.slideShowSpeed = slideShowSpeed * 1000;
	if (filterAttr1 == null || filterAttr1 == '')
		filterAttr1 = 2;
	if (filterName == null || filterName == '' || filterName.toLowerCase() == 'blendtrans')
		this.filterName = 'BlendTrans(duration=' + filterAttr1;
	else if (filterName.toLowerCase() != 'none')
		this.filterName = 'progid:DXImageTransform.Microsoft.' + filterName + ', duration=' + filterAttr1;
	if (filterAttr2 != null && filterAttr2 != '')
		this.filterName = this.filterName + ',' + filterAttr2;
	if (filterAttr3 != null && filterAttr3 != '')
		this.filterName = this.filterName + ',' + filterAttr3;
	this.filterName = this.filterName + ')';

	switch (layout) {
		case 1: // Standard
			tmpElem.style.border = 'none';
			tmpElem.style.background = 'transparent';
			//tmpElem.style.border = 'medium none';
			//tmpElem.style.background = 'transparent none repeat scroll 0% 0%';
			tmpElem.id = slideShowId + '_link';
			this.slideShowLink = tmpElem;
			this.slideShowId.parentNode.insertBefore(tmpElem, this.slideShowId);
			this.slideShowId.parentNode.removeChild(this.slideShowId);
			this.slideShowLink.appendChild(this.slideShowId);
			break;
		case 5: // StandardFiveBottom
				//DO NOT COPY for this case - follow 12 for a better code.
			//tmpElem.style.border = 'none';
			//tmpElem.style.background = 'transparent';
			tmpElem.style.border = 'medium none';
			tmpElem.style.background = 'transparent none repeat scroll 0% 0%';
			tmpElem.id = slideShowId + '_link';
			this.slideShowLink = tmpElem;
			this.slideShowId.parentNode.insertBefore(tmpElem, this.slideShowId);
			//this.slideShowId.parentNode.removeChild(this.slideShowId);
			this.slideShowLink.appendChild(this.slideShowId);
			var tmpElemHTML = this.slideShowLink.innerHTML;

			var td = this.slideShowId.parentNode.parentNode;
			this.slideShowId.parentNode.parentNode.removeChild(this.slideShowId.parentNode);

			var newSection = document.createElement("div");
			newSection.setAttribute("id", "SubSection1");

			var cpSlideShowWrapper1 = document.createElement("div");
			cpSlideShowWrapper1.setAttribute("id", "cpSlideShowWrapper1");
			cpSlideShowWrapper1.style.padding = "5px";
			cpSlideShowWrapper1.style.background = "rgb(70, 43, 16) none repeat scroll 0% 0%";
			cpSlideShowWrapper1.style.position = "relative";
			cpSlideShowWrapper1.style.width = "416px";
			//cpSlideShowWrapper1.style.-moz-background-clip = "border";
			//cpSlideShowWrapper1.style.-moz-background-origin = "padding";
			//cpSlideShowWrapper1.style.-moz-background-inline-policy = "continuous";
			cpSlideShowWrapper1.style.height = "254px";

			var imageHead = document.createElement("div");
			imageHead.style.padding = "4px";
			imageHead.style.background = "rgb(241, 239, 234) none repeat scroll 0% 0%";
			imageHead.style.align = "left";
			imageHead.style.width = "406px";
			//-moz-background-clip: border; 
			//-moz-background-origin: padding; 
			//-moz-background-inline-policy: continuous; 
			imageHead.style.float = "left";
			imageHead.style.height = "198px";
			imageHead.style.align = "left";

			imageHead.innerHTML = tmpElemHTML;
			cpSlideShowWrapper1.appendChild(imageHead);

			var imageRows = document.createElement("div");
			imageRows.setAttribute("id", "imageRows");
			imageRows.style.position = "relative";
			imageRows.style.align = "left";
			imageRows.style.margin = "5px 0px 0px 0px";
			imageRows.style.width = "416px";
			imageRows.style.float = "left";
			imageRows.style.height = "42px";
			imageRows.style.clear = "both";

			cpSlideShowWrapper1.appendChild(imageRows);
			newSection.appendChild(cpSlideShowWrapper1);
			td.appendChild(newSection);

			this.slideShowId = document.getElementById(slideShowId);
			if (isie) {
				this.slideShowId.style.height = "100%";
				this.slideShowId.style.width = "100%";
			}
			else {
				this.slideShowId.setAttribute("height", "100%");
				this.slideShowId.setAttribute("width", "100%");
			}
			break;
		case 12: //This case would handle the new 12 image slideshow without Rotation. & with mouseover
			tmpElem.id = slideShowId + '_link';
			this.slideShowLink = tmpElem;
			this.slideShowId.parentNode.insertBefore(tmpElem, this.slideShowId);
			this.slideShowLink.appendChild(this.slideShowId);
			var tmpElemHTML = this.slideShowLink.innerHTML;

			var td = this.slideShowId.parentNode.parentNode;

			// If the slideshow is in the middle of the page's content, we
			// have to keep track of its next sibling, so we put the 12-thumbnail
			// content in the new location.
			var nextSibling = this.slideShowLink.nextSibling;

			this.slideShowId.parentNode.parentNode.removeChild(this.slideShowId.parentNode);

			var newSection = document.createElement("div");
			newSection.setAttribute("id", "SubSectionFor" + slideShowId);

			var cpSlideShowWrapper1 = document.createElement("div");
			cpSlideShowWrapper1.setAttribute("id", "cpSlideShowWrapper" + slideShowId);

			//Remove these in-line style Height and Width after CSS changes
			cpSlideShowWrapper1.style.width = "441px";
			cpSlideShowWrapper1.style.height = "190px";
			cpSlideShowWrapper1.style.padding = "5px";
			cpSlideShowWrapper1.style.position = "relative";
			cpSlideShowWrapper1.style.clear = "both";

			var imageHead = document.createElement("div");
			imageHead.setAttribute("id", "imageHead");
			//Remove these in-line style Height and Width after CSS changes
			imageHead.style.width = "201px"; //185 px
			imageHead.style.height = "168px";
			imageHead.style.padding = "8px";
			imageHead.style.align = "left";
			imageHead.style.styleFloat = "left";
			imageHead.style.cssFloat = "left";
			imageHead.innerHTML = tmpElemHTML;
			cpSlideShowWrapper1.appendChild(imageHead);

			var imageRowsHeader = document.createElement("div");
			imageRowsHeader.setAttribute("id", "imageRowsHeader");
			imageRowsHeader.style.position = "relative";
			imageRowsHeader.style.align = "right";
			imageRowsHeader.style.styleFloat = "right";
			imageRowsHeader.style.cssFloat = "right";
			imageRowsHeader.style.width = "216px"; //247px
			imageRowsHeader.style.height = "18px";

			//Image Link
			var slideImageHeaderLink = document.createElement("a");
			slideImageHeaderLink.setAttribute("href", "/gallery.aspx");

			//Image Header
			var slideImageHeader = document.createElement("img");
			slideImageHeader.setAttribute("id", slideShowId + "Header");
			slideImageHeader.setAttribute("src", "/images/pages/ImageHeader.jpg");
			slideImageHeader.setAttribute("target", "_blank");
			slideImageHeader.style.width = "198px"; //247px
			slideImageHeader.style.height = "18px";
			slideImageHeader.setAttribute("border", "0");

			slideImageHeaderLink.appendChild(slideImageHeader);
			imageRowsHeader.appendChild(slideImageHeaderLink);

			cpSlideShowWrapper1.appendChild(imageRowsHeader);

			var imageRows = document.createElement("div");
			imageRows.setAttribute("id", "imageRows");
			imageRows.style.position = "relative";
			imageRows.style.align = "right";
			//imageRows.style.margin = "28px 0px 0px 0px";
			imageRows.style.styleFloat = "right";
			imageRows.style.cssFloat = "right";
			imageRows.style.width = "216px"; //247px
			imageRows.style.height = "145px";
			imageRows.style.padding = "4px";

			cpSlideShowWrapper1.appendChild(imageRows);
			newSection.appendChild(cpSlideShowWrapper1);

			var scriptTag = td.firstChild;
			while (scriptTag) {
				if (scriptTag.nodeType == 1 && scriptTag.tagName == 'SCRIPT')
					break;
				scriptTag = scriptTag.nextSibling;
			}
			if (nextSibling != null)
				td.insertBefore(newSection, nextSibling);
			else
				td.insertBefore(newSection, scriptTag);

			this.slideShowId = document.getElementById(slideShowId);
			//Remove these in-line style Height and Width after CSS changes
			if (isie) {
				this.slideShowId.style.height = "100%";
				this.slideShowId.style.width = "100%";
			}
			else {
				this.slideShowId.setAttribute("height", "100%");
				this.slideShowId.setAttribute("width", "100%");
			}
			break;
		default:
			break;
	}

	this.addImage = function(n, img, alt, link, linkTarget) {
		if (layout == 12 && n > 11)
			return; // Allow only upto 12 thumbnail images for Standard 12 Bottom layout

		if (!linkTarget || linkTarget == null || linkTarget == "undefined" || linkTarget == "")
			linkTarget = "_self";

		this.picArr[n] = new Image();
		this.picArr[n].src = img;

		do {
			alt = (alt).replace("%39", "'");
		} while ((alt).indexOf("%39") != -1)
		this.altArr[n] = alt;

		do {
			link = (link).replace("%38", "&");
		} while ((link).indexOf("%38") != -1)
		this.linkArr[n] = link;

		this.linkTargetArr[n] = linkTarget;

		switch (layout) {
			case 5:
				var slideImage = document.createElement("img");
				slideImage.setAttribute("id", slideShowId + n);
				if (isie) {
					slideImage.style.height = "40";
					slideImage.style.width = "40";
				}
				else {
					slideImage.setAttribute("height", "40");
					slideImage.setAttribute("width", "40");
				}
				if (n == 0)
					slideImage.setAttribute("border", "1");
				else
					slideImage.setAttribute("border", "0");
				slideImage.style.borderStyle = "solid";
				slideImage.style.borderColor = "#FFFF00";
				slideImage.setAttribute("src", img);
				slideImage.setAttribute("alt", alt);
				slideImage.setAttribute("link", link);
				slideImage.setAttribute("target", linkTarget);
				slideImage.setAttribute("class", "photoGalleryImgArray");

				if (n == 0)
					slideImage.style.margin = "0px 0px 0px 0px";
				else
					slideImage.style.margin = "0px 0px 0px 6px";
				this.imageRows = document.getElementById("imageRows");
				this.imageRows.appendChild(slideImage);
				break;
			case 12: //This case would handle the new 12 image slideshow without Rotation. & with mouseover
				var slideImage = document.createElement("img");
				slideImage.setAttribute("id", slideShowId + n);
				//Remove these in-line style 'Padding' after CSS changes
				if (n == 0) {
					if (isie)
						slideImage.style.cssText = "margin:6px 6px; border: 2px solid transparent; background-color: lightblue; padding: 3px; height:30px; width:30px;";
					else
						slideImage.setAttribute('style', 'margin:6px 6px; border: 2px solid transparent; background-color: lightblue; padding: 3px; height:30px; width:30px;');
				}
				else {
					if (isie)
						slideImage.style.cssText = "margin:6px 6px; border: 2px solid transparent ; background-color: white; padding: 3px; height:30px; width:30px;";
					else
						slideImage.setAttribute('style', 'margin:6px 6px; border: 2px solid transparent ; background-color: white; padding: 3px;height:30px; width:30px;');
				}
				slideImage.setAttribute("src", img);
				slideImage.setAttribute("alt", alt);
				slideImage.setAttribute("link", link);
				slideImage.setAttribute("target", linkTarget);
				slideImage.setAttribute("class", "photoGalleryImgArray");
				var siObj = eval(slideShowId.replace("Image", ""));
				slideImage.onmouseover = function() { siObj.mouseOver(slideShowId + n, img, alt); };

				this.imageRows = document.getElementById("imageRows");
				this.imageRows.appendChild(slideImage);
				break;
			default:
				break;
		}
	}
	
	this.mouseOver = function(elem, imgPath, altText) {
		//Set the Main Display image to mouseOver Image
		this.slideShowId.setAttribute("src", imgPath);
		this.slideShowId.alt = altText;
		
		//Loop through all other images and set the border to 1
		this.ImageRows = document.getElementById("imageRows");
		this.ImageRows.Images = this.ImageRows.getElementsByTagName("img");
		var j = 0;
		while (j < this.ImageRows.Images.length) {
			if (this.ImageRows.Images[j] == document.getElementById(elem)) {
				if (isie)
					this.ImageRows.Images[j].style.cssText = "margin:6px 6px; border: 2px solid transparent; background-color: lightblue; padding: 3px; height:30px; width:30px;";
				else
					this.ImageRows.Images[j].setAttribute('style', 'margin:6px 6px; border: 2px solid transparent; background-color: lightblue; padding: 3px;height:30px; width:30px;');
			}
			else {
				if (isie)
					this.ImageRows.Images[j].style.cssText = "margin:6px 6px; border: 2px solid transparent; background-color:white; padding: 3px;height:30px; width:30px;";
				else
					this.ImageRows.Images[j].setAttribute('style', 'margin:6px 6px; border: 2px solid transparent; background-color:white; padding: 3px;height:30px; width:30px;');
			}
			j++;
		}
	}
	
	this.runSlideShow = function() {
		switch (layout) {
			case 12:
			case 5:
				//Do nothing, do not run a slideshow
				break;
			default:
				if (this.picArr.length > 1) {
					var self = this; 					//  reference to get around context loss of this during setTimeout()
					this.timeoutId = setTimeout(function() { self.nextSlide(); self.runSlideShow(); }, this.slideShowSpeed);
				}
				break;
		}
	}
	
	this.nextSlide = function() {
		if (document.all && this.slideShowId.filters && this.filterName.toLowerCase() != 'none') {
			this.slideShowId.style.filter = this.filterName;
			this.slideShowId.filters.item(0).apply();
		}
		this.slideShowId.setAttribute('src', this.picArr[this.j].src);
		this.slideShowId.setAttribute('alt', this.altArr[this.j]);
		
		var slideLink = this.linkArr[this.j]
		var slideLinkTarget = this.linkTargetArr[this.j]
		if (slideLink && slideLink != '') {
			tmpElem.href = slideLink;
			if (slideLinkTarget && slideLinkTarget != '')
				tmpElem.target = slideLinkTarget;
		}
		else
			tmpElem.removeAttribute('href');
		
		if (document.all && this.slideShowId.filters && filterName.toLowerCase() != 'none')
			this.slideShowId.filters.item(0).play();
		
		var slideImageId, slideImage;
		if (layout == 5) {
			// Set the selected image's border
			if (this.j == 0)
				slideImageId = slideShowId + (this.picArr.length - 1);
			else
				slideImageId = slideShowId + (this.j - 1);
			slideImage = document.getElementById(slideImageId);
			slideImage.setAttribute("border", "0");

			slideImageId = slideShowId + this.j;
			slideImage = document.getElementById(slideImageId);
			slideImage.setAttribute("border", "1");
		}

		this.j++;
		if (this.j >= this.picArr.length)
			this.j = 0;
	}
}

//el is the pointer to the input type="file"
//example usage: <input type="file" size="38" name="txtFile" onChange="validateFileUpload(this);">
function validateFileUpload(el, useWhiteList) {
	var val = el.value;
	var cbox = document.getElementById(el.name + "_pdf");
	if (cbox) {
		cbox.disabled = true;
		cbox.checked = false;
	}
	if (val.length > 0) {
		if (!isAllowedFileExtension(val, useWhiteList)) {
			alert("The file you are trying to upload is not an allowed file type.");
			el.focus();
			return false;
		}
		if (cbox) {
			cbox.disabled = !isAllowedFileExtensionPDF(val);
			if (cbox.disabled) cbox.checked = false;
		}
	}
	return true;
}

function isAllowedFileExtension(filename, useWhiteList) {
	if (filename + '' == '')
		return true;
	
	// Cut out the path portion (why not use lastIndexOf()?).
	while (filename.indexOf("/", 0) > 0)
		filename = filename.substr(filename.indexOf("/", 0) + 1, filename.length - filename.indexOf("/", 0))
	while (filename.indexOf("\\", 0) > 0)
		filename = filename.substr(filename.indexOf("\\", 0) + 1, filename.length - filename.indexOf("\\", 0))

	var lastPeriod = filename.indexOf(".", 0);
	var i = lastPeriod;

	while (lastPeriod > 0) {
		i = lastPeriod;
		lastPeriod = filename.indexOf(".", i + 1);
	}

	var fileExtension = (i > 0 ? filename.substr(i + 1, filename.length - i) : "");

	if (useWhiteList)
		return isAllowedFileExtensionWhiteList('.' + fileExtension)
	else {
		switch (fileExtension.toUpperCase()) {
			case "ASA":
			case "ASAX":
			case "ASBX":
			case "ASCX":
			case "ASP":
			case "ASPX":
			case "BAT":
			case "CAB":
			case "CF":
			case "CFM":
			case "CGI":
			case "COM":
			case "CONFIG":
			case "DLL":
			case "EXE":
			case "HTA":
			case "LHA":
			case "LHZ":
			case "MIM":
			case "PIF":
			case "PL":
			case "SYS":
			case "UUE":
			case "VBS":
			case "VXD":
			case "WEBINFO":
			case "WIZ":
			case "WSH":
				{
					return false;
					break;
				}
			default:
				{
					return true;
					break;
				}
		}
	}
}

// Makes sure a file being uploaded for PDF conversion is supported.
// Note: Server logic should additionally chop out paths and other evil things (e.g. Windows Device Names like 'CON', 'AUX', etc).
function isAllowedFileExtensionPDF(filename) {
	//cut out the path portion
	while (filename.indexOf("/", 0) > 0)
		filename = filename.substr(filename.indexOf("/", 0) + 1, filename.length - filename.indexOf("/", 0))
	while (filename.indexOf("\\", 0) > 0)
		filename = filename.substr(filename.indexOf("\\", 0) + 1, filename.length - filename.indexOf("\\", 0))

	var lastPeriod, i, fileExtension;
	lastPeriod = filename.indexOf(".", 0);
	i = lastPeriod;
	while (lastPeriod > 0) {
		i = lastPeriod;
		lastPeriod = filename.indexOf(".", i + 1);
	}

	if (i > 0)
		fileExtension = filename.substr(i + 1, filename.length - i).toUpperCase();
	else
		fileExtension = "";

	switch (fileExtension) {
		case "GIF":
		case "JPG":
		case "JPEG":
		case "PNG":
		case "HTM":
		case "HTML":
		case "DOC":
		case "DOCX":
		case "XLS":
		case "XLSX":
		case "TXT":
			{
				return true;
				break;
			}
		default:
			{
				return false;
				break;
			}
	}
}

// returns true if it is a valid US or Canadian zip code.
// supports ZIP, ZIP+4 and Canadian zip code format
// * intCountryCode is a ISO 3166-1 numeric value.
function isZipCode(strInput, intCountryCode) {
	var re
	if (intCountryCode == 840) // USA
		re = /^\d{5}([\-]\d{4})?$/;
	else if (intCountryCode == 124) // Canada
		re = /^[A-Z]\d[A-Z][- |]\d[A-Z]\d$/i;
	return (re.test(strInput));
}

// returns name to assign postal/zip code.
function getZipCodeName(intCountryCode) {
	if (intCountryCode == 840) // USA
		return 'Zip';
	else// if (intCountryCode == 124) // Canada
		return 'Postal';
}

// Gets card type. Will return one of the following values (or an empty string for unknown/invalid cards):
// * Master = M
// * Visa = V
// * Discover = D
// * American Express = A
function getCreditCardType(cardNumber) {
	switch (cardNumber.substr(0, 2)) {
		case "51":
		case "52":
		case "53":
		case "54":
		case "55":
			return "M";
		case "65":
			return "D";
	}
	switch (cardNumber.substr(0, 1)) {
		case "4":
			return "V";
	}
	switch (cardNumber.substr(0, 4)) {
		case "6011":
			return "D";
	}
	switch (cardNumber.substr(0, 2)) {
		case "34":
		case "37":
			return "A";
	}

	// Card unknown/invalid.
	return '';
}

// Validates credit card numbers. cardType is an optional argument.
function isValidCreditCardNumber(cardNumber, cardType) {
	var isValid = false;
	var ccCheckRegExp = /[^\d ]/;

	isValid = !ccCheckRegExp.test(cardNumber);

	if (isValid) {
		// Get card type if not explicitly specified.
		if (cardType == null)
			cardType = getCreditCardType(cardNumber);

		// If unknown/unsupported/invalid card type, abort/fail.
		if (cardType == '')
			return false;

		var cardNumbersOnly = cardNumber.replace(/ /g, "");
		var cardNumberLength = cardNumbersOnly.length;
		var lengthIsValid = false;
		var patternIsValid = false;
		var patternRegExp;

		switch (cardType) {
			case "V":
				{ // visa
					lengthIsValid = (cardNumberLength == 13 || cardNumberLength == 16);
					patternRegExp = /^4/;
					break;
				}
			case "M":
				{ // mastercard
					lengthIsValid = (cardNumberLength == 16);
					patternRegExp = /^5[1-5]/;
					break;
				}
			case "A":
				{ // amercian express
					lengthIsValid = (cardNumberLength == 15);
					patternRegExp = /^3[4,7]/;
					break;
				}
			case "D":
				{ // discover
					lengthIsValid = (cardNumberLength == 16);
					patternRegExp = /^6011/;
					break;
				}
			/*case "J":
				{ // jcb
					lengthIsValid = (cardNumberLength == 15) || (cardNumberLength == 16);
					patternRegExp = /^[3,1800,2131]/;
					break;
				}
			case "C":
				{ // diner's club
					lengthIsValid = (cardNumberLength == 14);
					patternRegExp = /^3[0,6,8]/;
					break;
				}*/
			default:
				patternRegExp = /^$/;
		}

		patternIsValid = patternRegExp.test(cardNumbersOnly);
		isValid = patternIsValid && lengthIsValid;
	}

	if (isValid) {
		var numberProduct;
		var numberProductDigitIndex;
		var checkSumTotal = 0;

		for (digitCounter = cardNumberLength - 1; digitCounter >= 0; digitCounter--) {
			checkSumTotal += parseInt(cardNumbersOnly.charAt(digitCounter));
			digitCounter--;
			numberProduct = String((cardNumbersOnly.charAt(digitCounter) * 2));
			for (var productDigitCounter = 0; productDigitCounter < numberProduct.length; productDigitCounter++)
				checkSumTotal += parseInt(numberProduct.charAt(productDigitCounter));

		}

		isValid = (checkSumTotal % 10 == 0);
	}

	return isValid;
}

// Confirms data given is legal.
function isDate(varDateToCheck) {
	var objDate = new dateValidator();
	return objDate.dateValidate(varDateToCheck, true, 'Date');
}

// Confirms data given is legal.
function isDateNew(varDateToCheck) {
	var objDate = new dateValidator();
	return objDate.dateValidateNew(varDateToCheck, true, 'Date');
}

// TODO: JavaScript - Remove this function. Better ways to handle this.
// Date comparison function.
function dateDiff(dtiDateEntered, dtiDateToday) {
	var date1 = new Date();
	var date2 = new Date();
	var diff = new Date();
	// Initialize the first date
	var date1temp = new Date(dtiDateEntered);
	date1.setTime(date1temp.getTime());
	// Initialize the second date
	var date2temp = new Date(dtiDateToday);
	date2.setTime(date2temp.getTime());
	// sets difference date to difference of first date and second date
	diff.setTime(date1.getTime() - date2.getTime());
	timediff = diff.getTime();
	days = Math.floor(timediff / (86400000)); // 1000 * 60 * 60 * 24
	timediff -= days * (86400000);
	return days;
}

// .NET JavaScript debugging function.
// TO-DO: Add sections for 'add_' and 'remove_' event prefixes.
function debugDisplayMembers(obj) {
	var getters = new Array();
	var setters = new Array();
	var others = new Array();
	var sKey;

	for (var key in obj) {
		sKey = key + "";
		if (!((sKey.length > 0) && (sKey[0] == '_'))) {
			switch (sKey.substr(0, 4)) {
				case 'get_':
					getters.push(key);
					break;
				case 'set_':
					setters.push(key);
					break;
				default:
					others.push(key);
			}
		}
	}

	getters.sort();
	setters.sort();
	others.sort();

	alert(others.join(", ") + "\r\n\r\n" +
		getters.join(", ") + "\r\n\r\n" +
		setters.join(", "));
}

// BEGIN PSEUDO-FORMS CODE
// Do not call any of these methods directly in your application code.
// Pseudo-forms are transparent, you shouldn't need to use these methods.
addEvent(window, 'load', initializePseudoForms, false);

// Allows IE to recognize tag "subform". You cannot legally nest
// FORM tags inside FORM tags and at least Firefox pretends they're not 
// in the DOM period. This is problematic, so the tag was renamed.
// Done for FORMS inside of FORMs trick to get around ASP.NET form limitations
// for content we cannot control (User Pages, Info Advanced HTML, etc).
document.createElement('subform');

// Initialize pseudo-forms. Called on window load.
function initializePseudoForms() {
	// Make sure we're in an HTML document (not XUL).
	if (document.body) {
		var subForms = document.body.getElementsByTagName('subform');
		for (var i = 0; i < subForms.length; i++)
			setupPseudoForm(subForms[i]);
	}
}

// Sets up pseudo-form.
function setupPseudoForm(pseudoFormElement) {
	// Re-routes form submission elements (no javascript used/necessary).
	// (those being input.type=submit, button.type=submit, and input.type=image)
	var rerouteElement = function(input, pseudoFormElement, newTagName, newType, copyInnerHTML) {
		var replacement = document.createElement(newTagName);
		replacement.setAttribute('type', newType);
		var onClickDest, onClickSrc = replacement.getAttribute('onclick');
		if (onClickSrc != null)
			replacement.removeAttribute('onclick');
		cloneAttributes(input, replacement);
		if (onClickSrc != null) {
			eval("window.tmp = function(event) { " + onClick + " }");
			onClickSrc = window.tmp;
			window.tmp = null;
			onClickDest = function(ev) {
				ev = (window.event ? window.event : ev);
				if (onClickSrc(ev) == false)
					return;
				pseudoFormElement._submitter = replacement;
				pseudoFormElement._submevent = ev;
				pseudoFormElement.submit();
			}
		}
		else {
			onClickDest = function(ev) {
				ev = (window.event ? window.event : ev);
				pseudoFormElement._submitter = replacement;
				pseudoFormElement._submevent = ev;
				pseudoFormElement.submit();
			}
		}

		// Return replacement routine.
		var fn = function() {
			var inputParent = input.parentNode;
			var inputRightAfter = input.nextSibling;
			var inputDisabled = input.disabled; // For Internet Explorer (it forgets).
			var inputHTML = (copyInnerHTML ? input.innerHTML : null);
			inputParent.removeChild(input); input = null;
			if (copyInnerHTML)
				replacement.innerHTML = inputHTML;
			inputParent.insertBefore(replacement, inputRightAfter);
			replacement.disabled = inputDisabled;
			addEvent(replacement, 'click', onClickDest, false);
		}
		return fn;
	}

	// Re-route submits (needs to be done early on).
	var inputs, input, inc, repls;
	repls = new Array();
	inputs = pseudoFormElement.getElementsByTagName('input');
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		switch (input.type.toLowerCase()) {
			case 'submit':
				repls.push(rerouteElement(input, pseudoFormElement, 'input', 'button', false));
				break;
			case 'image':
				repls.push(rerouteElement(input, pseudoFormElement, 'img', 'image', false));
				break;
		}
	}
	inputs = pseudoFormElement.getElementsByTagName('button');
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		switch (input.type.toLowerCase()) {
			case 'submit':
				repls.push(rerouteElement(input, pseudoFormElement, 'button', 'button', true));
				break;
		}
	}
	for (var i = 0; i < repls.length; i++)
		repls[i]();

	// Implement properties for pseudo-form.
	var name = pseudoFormElement.getAttribute('name');
	if (name && name != '') {
		document[name] = pseudoFormElement;
		document.forms[name] = pseudoFormElement;
	}
	pseudoFormElement.method = pseudoFormElement.getAttribute('method');
	if (pseudoFormElement.method == null || pseudoFormElement.method == '')
		pseudoFormElement.method = 'get';
	pseudoFormElement.enctype = pseudoFormElement.getAttribute('enctype');
	if (pseudoFormElement.enctype == null || pseudoFormElement.enctype == '')
		pseudoFormElement.enctype = 'application/x-www-form-urlencoded';
	pseudoFormElement.target = pseudoFormElement.getAttribute('target');
	pseudoFormElement.action = pseudoFormElement.getAttribute('action');
	pseudoFormElement.acceptCharset = pseudoFormElement.getAttribute('accept-charset');

	// Initialize.
	var elements = new Array(); // elements in pseudo-form (for form.elements).
	var simpleInputs = new Array(); // simple value inputs and textareas, no additional logic.
	var stateInputs = new Array(); // checkboxes and radiobuttons.
	var dropdowns = new Array(); // drop-downs and lists.
	pseudoFormElement.elements = elements;
	pseudoFormElement._simple = simpleInputs;
	pseudoFormElement._state = stateInputs;
	pseudoFormElement._dropdown = dropdowns;

	// Registers element for the pseudo-form.
	var registerElement = function(input) {
		// Add to elements array.
		elements.push(input);
		// Add as property.
		if (input.name != '' && input.name != null) {
			obj = pseudoFormElement[input.name];
			if (obj == null)
				pseudoFormElement[input.name] = input;
			else if (obj instanceof Array)
				obj.push(input);
			else {
				var arr = new Array();
				arr.push(obj);
				arr.push(input);
				pseudoFormElement[input.name] = arr;
			}
		}
	}

	// Add methods (can be overridden by form elements /w same names, just like real forms).
	pseudoFormElement.submit = function() { submitPseudoForm(this, false); }
	pseudoFormElement.reset = document.aspnetForm.reset; // HACK (we'll fix it if someone complains)

	// Register elements, and categorize them for form submission.
	inputs = pseudoFormElement.getElementsByTagName('input');
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		switch (input.type.toLowerCase()) {
			case 'checkbox':
			case 'radio':
				stateInputs.push(input);
				registerElement(input);
				break;
			case 'text':
			case 'hidden':
			case 'password':
				simpleInputs.push(input);
				registerElement(input);
				break;
			default:
				registerElement(input);
		}
	}
	inputs = pseudoFormElement.getElementsByTagName('textarea');
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		simpleInputs.push(input);
		registerElement(input);
	}
	inputs = pseudoFormElement.getElementsByTagName('select');
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		dropdowns.push(input);
		registerElement(input);
	}
	inputs = pseudoFormElement.getElementsByTagName('button');
	for (var i = 0; i < inputs.length; i++)
		registerElement(inputs[i]);
}

// Copies attributes from one element to another. Copy should occur
// before destElement is added to the DOM, as some things become read-only.
// ID and CLASS need to be handled specially for compatiblity reasons.
// Warning: TYPE is not supported (blame IE)!
function cloneAttributes(srcElement, destElement) {
	var attr;
	for (var i = 0; i < srcElement.attributes.length; i++) {
		attr = srcElement.attributes[i];
		switch (attr.name.toLowerCase()) {
			case 'name':
				if ((attr.value + '').toLowerCase() == 'submit')
					destElement.setAttribute('name', 'submit_button');
				else
					destElement.setAttribute('name', attr.value);
				break;
			case 'class':
				destElement.className = attr.value;
				break;
			case 'id':
				destElement.id = attr.value;
				break;
			case 'type':
			case 'form':
				break;
			default:
				try { destElement.setAttribute(attr.name, attr.value); }
				catch (e) { }
		}
	}
}

// Called by pseudo-form when submit() is invoked.
function submitPseudoForm(pseudoFormElement, debugMode) {
	var inputs, input;
	var spawner = pseudoFormElement._submitter;
	var spawnerEvent = pseudoFormElement._submevent;
	pseudoFormElement._submitter = null;
	pseudoFormElement._submevent = null;

	// Destroy form if it already exists (possible if target not implicit/explicit "_self").
	if (pseudoFormElement._form != null)
		document.body.removeChild(pseudoFormElement._form);
	pseudoFormElement._form = null;

	// Fire pseudo-onsubmit event (remember that just like in real forms, only fires on non-J/S submits).
	var onsubmit = pseudoFormElement.getAttribute('onsubmit');
	if (onsubmit != null && onsubmit != '' && spawnerEvent) {
		eval("window.tmp = function(event) { " + onsubmit + " }");
		onsubmit = window.tmp;
		window.tmp = null;
		if (onsubmit(spawnerEvent) == false)
			return false;
	}

	// Create actual form to forward submission to.
	var newForm = document.createElement('form');
	pseudoFormElement._form = newForm;

	// Transfer some standard HTML/XHTML attributes.
	newForm.dir = pseudoFormElement.dir;
	newForm.lang = pseudoFormElement.lang;
	newForm.title = pseudoFormElement.title;

	// Setup actual form action, accept, accept-charset, encoding, method, and target.
	var action = pseudoFormElement.getAttribute('action');
	var method = pseudoFormElement.getAttribute('method');
	var target = pseudoFormElement.getAttribute('target');
	var enctype = pseudoFormElement.getAttribute('enctype');
	var accept = pseudoFormElement.getAttribute('accept');
	var acceptCharset = pseudoFormElement.getAttribute('accept-charset');
	if (action)
		newForm.action = action;
	if (method)
		newForm.method = method;
	if (target)
		newForm.target = target;
	if (enctype)
		newForm.enctype = enctype;
	if (accept)
		newForm.accept = accept;
	if (acceptCharset)
		newForm.acceptCharset = acceptCharset;

	// Method used to create hidden input copies.
	var newHiddenInput = function(name, value) {
		var ret = document.createElement('input');
		ret.type = 'hidden';
		ret.value = value;
		ret.name = name;
		newForm.appendChild(ret);
	}

	// Create element for spawner if one exists (submitted w/o JS, e.g. input.type=submit).
	if (spawner && spawner.name != null && spawner.name != '')
		newHiddenInput(spawner.name, spawner.value);

	// Forward text, textarea, hidden, and password input values.
	inputs = pseudoFormElement._simple;
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		if ((!input.disabled) && (input.style.display != 'none'))
			newHiddenInput(input.name, input.value);
	}

	// Forward checkbox and radio-button values.
	inputs = pseudoFormElement._state;
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		if ((!input.disabled) && (input.style.display != 'none')) {
			if (input.checked)
				newHiddenInput(input.name, input.value);
		}
	}

	// Forward drop-down/list selections.
	// Blame for text/value condition and necessity of options loop lies with IE.
	// 1) Specifically, IE 7  and IE 7 mode don't give the implicit value if it's left off.
	// 2) IE 8 should support retrieval of all values from the select.value prop, but doesn't.
	inputs = pseudoFormElement._dropdown;
	for (var i = 0; i < inputs.length; i++) {
		input = inputs[i];
		if ((!input.disabled) && (input.style.display != 'none')) {
			for (var j = 0; j < input.options.length; j++) {
				if (input.options[j].selected) {
					if (input.options[j].value == '')
						newHiddenInput(input.name, input.options[j].text);
					else
						newHiddenInput(input.name, input.options[j].value);
				}
			}
		}
	}

	document.body.appendChild(newForm);
	if (debugMode)
		alert(newForm.innerHTML);
	newForm.submit();
}
// END PSEUDO-FORMS CODE

function phoneStripFormatting(value) {
	/// <summary>Strips formatting characters (for display purposes only) from the NANP phone number given.</summary>
	/// <param name="value" type="String">Phone number.</summary>
	/// <returns type="String">Phone number with formatting cahracter removed.</returns>
	return (value + '').replace(/\(/g, '').replace(/\)/g, '').replace(/\s/g, '').replace(/\-/g, '');
}

function phoneReformat(value, delim) {
	/// <summary>Reformats a number for display purposes using delimiter specified.</summary>
	/// <param name="value" type="String">The phone number.</summary>
	/// <param name="delim" type="String">The delimiter used. If argument is not passed, a hyphen is used.</summary>
	/// <returns type="String">Reformatted phone number.</returns>
	value = phoneStripFormatting(value);
	
	if (delim == null)
		delim = '-';
	
	return value.substr(0, 3) + delim + value.substr(3, 3) + delim + value.substr(6)
}

function phoneObfuscate(value, secret, delim) {
	/// <summary>Reformats a number for display purposes, obfuscating the first 6 digits.</summary>
	/// <param name="value" type="String">The phone number.</summary>
	/// <param name="secret" type="String">The obfuscation character or string to use in place of a digit in the number. If argument is not pased, a asterisk is used.</summary>
	/// <param name="delim" type="String">The delimiter used. If argument is not passed, a hyphen is used.</summary>
	/// <returns type="String">Reformatted, obfuscated phone number.</returns>
	value = phoneStripFormatting(value);

	if (secret == null)
		secret = '*';
	
	if (delim == null)
		delim = '-';
	
	secret = secret + secret + secret + delim;
	return secret + secret + value.substr(6);
}

function phoneValidate(value) {
	/// <summary>Validates that phone numbers appear to adhere to the NANP format (North American Numbering Plan).</summary>
	/// <remarks>
	/// Expects area code to be present, and no country code (e.g. 555-555-0123 is valid, 1-555-555-0123 is not).
	/// Does not validate that numbers are legal (e.g. area code 123 is invalid, area codes cannot begin with 1).
	/// </remarks>
	/// <param name="value" type="String">Phone number.</summary>
	/// <returns type="Boolean">Whether or not number passed a basic format validation.</returns>
	value = phoneStripFormatting(value);
	if (value.length == 10)
		return numbersOnly.test(value);
	else
		return false;
}

//gets the cookie, if it exists
function getCookieValue(cookiename) {
	var ck = document.cookie;
	var cn = cookiename + "=";
	var pos = ck.indexOf(cn);
	
	if (pos != -1) {
		var start = pos + cn.length;
		var end = ck.indexOf(";", start);
		if (end == -1) end = ck.length;
		var cookieValue = ck.substring(start, end);
		return (cookieValue);
	}
	
	return (null);
}

// Returns whether or not file extension given is acceptable.
// Client-side version of FileSystemSafety.IsAllowedFileExtension().
function isAllowedFileExtensionWhiteList(ext) {
	if (!window.acceptedFileExtensions) {
		window.acceptedFileExtensions =
		{
			'.123':1,'.3g2':1,'.3gp':1,'.3gp2':1,'.7z':1,'.aac':1,'.abw':1,'.abx':1,'.accdb':1,'.accde':1,
			'.accdr':1,'.accdt':1,'.accfl':1,'.ace':1,'.ade':1,'.adp':1,'.aeh':1,'.ai':1,'.aif':1,'.aiff':1,
			'.amr':1,'.apng':1,'.arc':1,'.art':1,'.asc':1,'.asf':1,'.asx':1,'.atom':1,'.au':1,'.avi':1,
			'.awt':1,'.azw':1,'.azw1':1,'.b64':1,'.backup':1,'.bin':1,'.bmp':1,'.bz':1,'.bz2':1,'.bzip':1,
			'.bzip2':1,'.cab':1,'.caf':1,'.cgm':1,'.crtx':1,'.css':1,'.csv':1,'.cwk':1,'.dap':1,'.db':1,
			'.dbf':1,'.dcr':1,'.dds':1,'.dex':1,'.dib':1,'.dif':1,'.diz':1,'.dmg':1,'.doc':1,'.docm':1,
			'.docx':1,'.dot':1,'.dotm':1,'.dotx':1,'.drw':1,'.ds_store':1,'.dv':1,'.dvr-ms':1,'.dwf':1,'.dwg':1,
			'.dxf':1,'.emf':1,'.eml':1,'.emlx':1,'.emz':1,'.eot':1,'.eps':1,'.fbp':1,'.fdp':1,'.fhtml':1,
			'.file':1,'.flac':1,'.flc':1,'.fli':1,'.flp':1,'.flv':1,'.fm':1,'.fm2':1,'.fm3':1,'.fm5':1,
			'.fmp':1,'.fnt':1,'.fon':1,'.fp':1,'.fp3':1,'.fp5':1,'.fp7':1,'.fphtml':1,'.fpt':1,'.fpweb':1,
			'.fpx':1,'.gg':1,'.gif':1,'.gnumeric':1,'.gra':1,'.gsm':1,'.gz':1,'.hdmov':1,'.hdp':1,'.hqx':1,
			'.htm':1,'.html':1,'.ical':1,'.icns':1,'.ico':1,'.ics':1,'.ifo':1,'.indd':1,'.isf':1,'.isu':1,
			'.ivs':1,'.jbf':1,'.jpe':1,'.jpeg':1,'.jpf':1,'.jpg':1,'.jxr':1,'.key':1,'.kml':1,'.kmz':1,
			'.knt':1,'.kth':1,'.lhz':1,'.lit':1,'.log':1,'.lrc':1,'.lrf':1,'.lrx':1,'.lst':1,'.lyr':1,
			'.m4a':1,'.m4b':1,'.m4p':1,'.m4r':1,'.mdb':1,'.mde':1,'.mht':1,'.mhtml':1,'.mid':1,'.midi':1,
			'.mim':1,'.mix':1,'.mng':1,'.mobi':1,'.mod':1,'.moi':1,'.mov':1,'.movie':1,'.mp3':1,'.mp4':1,
			'.mpa':1,'.mpc':1,'.mpe':1,'.mpeg':1,'.mpg':1,'.mpv2':1,'.msg':1,'.mswmm':1,'.mxd':1,'.numbers':1,
			'.odb':1,'.odf':1,'.odg':1,'.ods':1,'.odx':1,'.ofm':1,'.oft':1,'.ogg':1,'.ogm':1,'.ogv':1,
			'.one':1,'.onepkg':1,'.opx':1,'.osis':1,'.ost':1,'.otf':1,'.oth':1,'.p65':1,'.p7b':1,'.pages':1,
			'.pbm':1,'.pcast':1,'.pcf':1,'.pcm':1,'.pct':1,'.pcx':1,'.pdc':1,'.pdd':1,'.pdf':1,'.pdp':1,
			'.pfx':1,'.pgf':1,'.pic':1,'.pict':1,'.pkg':1,'.pmd':1,'.pmf':1,'.png':1,'.pot':1,'.pothtml':1,
			'.potm':1,'.potx':1,'.ppam':1,'.pps':1,'.ppsm':1,'.ppsx':1,'.ppt':1,'.ppthtml':1,'.pptm':1,'.pptx':1,
			'.prc':1,'.ps':1,'.psd':1,'.psp':1,'.pspimage':1,'.pst':1,'.pub':1,'.pubhtml':1,'.pubmhtml':1,'.qbb':1,
			'.qcp':1,'.qt':1,'.qxd':1,'.qxp':1,'.ra':1,'.ram':1,'.ramm':1,'.rar':1,'.raw':1,'.rax':1,
			'.rm':1,'.rmh':1,'.rmi':1,'.rmm':1,'.rmvb':1,'.rmx':1,'.rp':1,'.rss':1,'.rt':1,'.rtf':1,
			'.rts':1,'.rv':1,'.sbx':1,'.sdf':1,'.sea':1,'.shs':1,'.sit':1,'.sitx':1,'.smil':1,'.snapfireshow':1,
			'.snp':1,'.stc':1,'.svg':1,'.svgz':1,'.swf':1,'.sxc':1,'.sxi':1,'.tab':1,'.tar':1,'.tex':1,
			'.tga':1,'.thmx':1,'.tif':1,'.tiff':1,'.tpz':1,'.tr':1,'.trm':1,'.tsv':1,'.ttf':1,'.txt':1,
			'.uue':1,'.vcf':1,'.vob':1,'.vrml':1,'.vsc':1,'.vsd':1,'.wab':1,'.wav':1,'.wax':1,'.wbk':1,
			'.wbmp':1,'.wdp':1,'.webarchive':1,'.webloc':1,'.wk1':1,'.wk3':1,'.wm':1,'.wma':1,'.wmf':1,'.wmmp':1,
			'.wmv':1,'.wmx':1,'.wpd':1,'.wps':1,'.wri':1,'.wvx':1,'.xbm':1,'.xcf':1,'.xg0':1,'.xg1':1,
			'.xg2':1,'.xg3':1,'.xg4':1,'.xht':1,'.xhtm':1,'.xhtml':1,'.xif':1,'.xlam':1,'.xlb':1,'.xlc':1,
			'.xld':1,'.xlk':1,'.xlm':1,'.xls':1,'.xlsb':1,'.xlshtml':1,'.xlsm':1,'.xlsmhtml':1,'.xlsx':1,'.xlt':1,
			'.xlthtml':1,'.xltm':1,'.xltx':1,'.xlv':1,'.xlw':1,'.xml':1,'.xpi':1,'.xps':1,'.xsf':1,'.xsn':1,
			'.xtp':1,'.zabw':1,'.zip':1,'.zipx':1
		};
	}
	
	return (window.acceptedFileExtensions[(ext + '').toLowerCase()] === 1);
}

function handleServiceMethodError(error) {
	throw new Error('A server-side error occurred during the execution of an AJAX request (' +
		error.get_exceptionType() +
		')!\r\n\r\nAdditional Information:\r\n' +
		error.get_message() +
		'\r\n\r\nStack Trace:\r\n' +
		error.get_stackTrace().trim());
}

function toggleDisplay(elem) {
	elem.style.display =
		(elem.style.display == 'none' ? '' : 'none');
}

// BEGIN Old Character Counter
var MAX_MESSAGE_SIZE_SMS = 160;
var trackLengths = new Array();

function registerCharCounter(input, outputElemID, maxMessageSize) {
	var outputElem = document.getElementById(outputElemID);
	var id = input.id;
	var tracker;
	
	tracker = new Object();
	tracker.oldLength = -1;
	tracker.outputElem = outputElem;
	tracker.input = input;
	trackLengths[id] = tracker;
	
	setInterval(
		'var tracker = trackLengths[\'' + id + '\'];\r\n' +
		'var newLength = (tracker.input.value + \'\').length;\r\n' +
		'if (newLength != tracker.oldLength) {\r\n' +
		'	if (newLength > ' + maxMessageSize + ')' +
		'		tracker.outputElem.innerHTML = (newLength - ' + maxMessageSize + ') + " Characters Over";\r\n' +
		'	else\r\n' +
		'		tracker.outputElem.innerHTML = (' + maxMessageSize  + ' - newLength) + " Characters Remaining";\r\n' +
		'	\r\n' +
		'	tracker.oldLength = newLength;\r\n' +
		'}\r\n', 100);
}
// END Old Character Counter

function elemInsideOrEq(elemFirst, elemSecond) {
	/// <summary>Gets whether or not second element specified is inside or is equal to first element.</summary>
	/// <param name="elemFirst" type="domElement">First element.</param>
	/// <param name="elemSecond" type="domElement">Second element.</param>
	if (elemFirst == elemSecond)
		return true;

	if (elemFirst && elemSecond) {
		elemSecond = elemSecond.parentNode;

		while (elemSecond != null) {
			if (elemSecond == elemFirst)
				return true;

			elemSecond = elemSecond.parentNode;
		}
	}

	return false;
}

function hookAnchorClick(anchor, fn) {
	/// <summary>Hooks an anchor onclick and prevents default HREF behavior.</summary>
	/// <param name="anchor" type="domElement">The DOM element to attach the event handler for.</param>
	/// <param name="fn" type="Function">Function to be called when anchor is clicked. Should have sender and event argument, in that order.</param>
	var clickHandler = function(event) {
		var sender;

		if (window.event) {
			event = window.event;
			sender = event.srcElement;
		}
		else
			sender = event.target;

		fn(sender, event);

		if (event.stopPropagation)
			event.stopPropagation();
		else
			event.cancelBubble = true;

		return false;
	}

	// HACK: MSIE/Opera onclick fails to operate correctly.
	if (isie7 || isie6 || (document.documentMode < 8) || window.opera)
		anchor.onmousedown = clickHandler;
	else
		anchor.onclick = clickHandler;
}

// For ClientCharacterCounter control.
var registeredCounters = null;
function registerCounter(assocElem, counterElem, fmtStandard, fmtOver, maxChars) {
	if (assocElem == null || counterElem == null || maxChars == null || fmtStandard == null || fmtOver == null)
		return;
	
	if (registeredCounters == null) {
		registeredCounters = [];
		
		setInterval(function() {
			for (var i = 0, l = registeredCounters.length; i < l; i++) {
				if (registeredCounters[i].counter && registeredCounters[i].input) {
					var len = registeredCounters[i].input.value.length;
					var prevLen = registeredCounters[i].prevLen;
					
					if (len == prevLen)
						continue;
					else {
						registeredCounters[i].prevLen = len;
						
						var max = registeredCounters[i].maxChars;
						var numToDisplay = max - len;
						
						var fmtToUse = (numToDisplay >= 0
							? registeredCounters[i].fmtStandard
							: registeredCounters[i].fmtOver);
						
						if(numToDisplay >= 0)
							registeredCounters[i].counter.className = 'counterUnderLimit';
						else
							registeredCounters[i].counter.className = 'counterOverLimit';
						
						numToDisplay = Math.abs(numToDisplay);
						
						registeredCounters[i].counter.innerHTML = fmtToUse
							.replace(/\{0\}/g, numToDisplay)
							.replace(/\{1\}/g, (numToDisplay == 1 ? '' : 's'));
					}
				}
			}
		}, 100);
	}
	
	registeredCounters.push({
		"fmtStandard": fmtStandard,
		"fmtOver": fmtOver,
		"counter": counterElem,
		"input": assocElem,
		"prevLen": -1,
		"maxChars": maxChars});
}

// Implements HTML5 placeholder attribute for browsers that do not support it (and for HTML5 server-side control).
var tmpPH = document.createElement('input');
var supportPH = (tmpPH.placeholder != null);
//var colorPH = '#c0c0c0';

var removePlaceholder = (supportPH ?
	function(elem) { } : function(elem) {
		if(elem != null) {
			if (elem.hidePlaceholder)
				elem.hidePlaceholder();
			
			elem.hidePlaceholder = null;
			elem.showPlaceholder = null;
			
			removeEvent(elem, 'focus', elem._ph_focus, false);
			removeEvent(elem, 'blur', elem._ph_onblur, false);
			removeEvent(elem._ph_form, 'submit', elem._ph_form_submit, false);
		} 
	});

	var setPlaceholder = (supportPH ?
	function (elem) { } : function (elem) {
		if (elem != null) {
			if (elem.showPlaceholder != null)
				removePlaceholder(elem);

			var attrVal = elem.getAttribute('placeholder');

			elem.hidePlaceholder = function () {
				if (elem.value == attrVal) {
					if (elem.oldClassName != null)
						elem.className = elem.oldClassName;

					elem.value = '';
				}
			}

			elem.showPlaceholder = function () {
				if (elem.value == '') {
					if (attrVal == null)
						attrVal = '';
					elem.value = attrVal;

					var className = elem.className;
					className = (className == null ? '' : elem.className);
					elem.oldClassName = className;
					elem.className = className + ' fakePlaceholder';
				}
			}

			if (elem.value == null || elem.value == '')
				elem.showPlaceholder();

			elem._ph_focus = function (event) {
				elem.hidePlaceholder();
			};

			elem._ph_blur = function (event) {
				elem.showPlaceholder();
			};

			addEvent(elem, 'focus', elem._ph_focus, false);
			addEvent(elem, 'blur', elem._ph_blur, false);

			if (elem.form) {
				elem._ph_form = elem.form;

				elem._ph_form_submit = function (event) {
					if (elem)
						removePlaceholder(elem);
				};

				addEvent(elem._ph_form, 'submit', elem._ph_form_submit, false);
			}
		}
	});

//When programtically form.submit() is invoked, the placeholders are not removed automatically (onsubmit event is not called).
//This function could be invoked before form.submit() if necessary.
function removePlaceHolders() {
	$('input[placeholder]').each(function () {
		removePlaceholder($(this).get(0));
	});
}

var setPlaceHolder = setPlaceholder;

// Detects if nextElementSibling/previousElementSibling are present.
function detectElementSiblingSupport() {
	var p = document.createElement('div');
	var c1 = document.createElement('div');
	var c2 = document.createElement('div');

	p.appendChild(c1);
	p.appendChild(c2);

	return (c1.nextElementSibling != null);
}

// Gets next sibling element. Version for browsers missing nextElementSibling DOM property.
function nextElementSibling(elem) {
	elem = elem.nextSibling;
	
	while (elem != null) {
		if (elem.nodeType == 1)
			return elem;

		elem = elem.nextSibling;
	}
	
	return null;
}

// Gets previous sibling element. Version for browsers missing previousElementSibling DOM property.
function previousElementSibling(elem) {
	elem = elem.previousSibling;
	
	while (elem != null) {
		if (elem.nodeType == 1)
			return elem;

		elem = elem.previousSibling;
	}
	
	return null;
}

// Gets first child element. Version for browsers missing firstElementChild DOM property. 
function firstElementChild(elem) {
	elem = elem.firstChild;

	while (elem != null) {
		if (elem.nodeType == 1)
			return elem;

		elem = elem.nextSibling;
	}

	return null;
}

if (detectElementSiblingSupport()) {
	// If browsers support built-in DOM properties, just use those.
	nextElementSibling = function(elem) { return elem.nextElementSibling; }
	previousElementSibling = function(elem) { return elem.previousElementSibling; }
	firstElementChild = function(elem) { return elem.firstElementChild; }
}

function haltEvent(event, windowEvent) {
	if (windowEvent & !window.opera)
		windowEvent.cancelBubble();
	else {
		if (event.stopPropagation)
			event.stopPropagation();
		
		if (event.preventDefault)
			event.preventDefault();
	}
}

// Gets absolute left offset.
function absoluteOffsetLeft(oElem) {
	var oLeft = 0;

	while (oElem != null) {
		oLeft += oElem.offsetLeft;
		oElem = oElem.offsetParent;
	}

	return oLeft;
}

function imposeMaxLength(e, Object, MaxLen) {
    //Truncate to maximum length
    if (Object.value.length > MaxLen)
        Object.value = Object.value.substring(0, MaxLen);

    //ALLOW:        BACKSPACE           DELETE                  LEFT ARROW              UP ARROW            RIGHT ARROW             DOWN ARROW
    if ((e.keyCode == '8') || (e.keyCode == '46') || (e.keyCode == '37') || (e.keyCode == '38') || (e.keyCode == '39') || (e.keyCode == '40'))
        return true;

	return (Object.value.length <= MaxLen);
}

function checkURL(val, showAlert) {
	val = TrimString(val);
	if (val != '' && (val.substr(0, 7) != 'http://' && val.substr(0, 8) != 'https://' && val.substr(0, 6) != 'ftp://' && val.substr(0, 1) != '/')) {
		if (arguments.length == 1 || showAlert)
			alert('All URLs must begin with http:// or https:// or ftp://.\nAll internal links must start with a \\');

		return false;
	}
	return true;
}

function toSQLSafe(formvar) {
	var s = String(formvar);
	s = (s.replace(/'/gi, "&#39")).replace(/"/gi, "&#34");
	return s;
}

function cancelFE(needsConfirm) {
	if (needsConfirm) {
		if (!confirm("You will discard any unsaved changes. Do you want to proceed?"))
			return;
	}
	window.parent.closeModalDialog('editItemBehavior');
	return false;
}


var ajaxSpinnerVisible = false;
// Called when async postbacks begins
function onAjaxPostBackStart(sender, args) {
	ajaxPostBackStart('Loading');
}

// Called when async postback ends
function onAjaxPostBackEnd(sender, args) {
	ajaxPostBackEnd();
}

// Show ajax process panel with a customized text
function ajaxPostBackStart(textProcessing) {
	if (!ajaxSpinnerVisible) {
		var panelAjaxProgress = $("#divAjaxProgress"),
				divAjaxImgProgress = $("#divAjaxImgProgress"),
				panelAjaxShade = $("#divAjaxShade");

		if (panelAjaxProgress.length > 0) {
		}
		else {
			//create divs no the fly
			panelAjaxProgress = $('<div id="divAjaxProgress" style="display:none;"></div>');
			panelAjaxShade = $('<div id="divAjaxShade"></div>');
			divAjaxImgProgress = $('<div id="divAjaxImgProgress" class="loading"><img src="/Common/images/ajax-loader.gif" alt="' + textProcessing + '" title="' + textProcessing + '" /><p>' + textProcessing + '</p></div>');
			
			panelAjaxProgress.append(panelAjaxShade);
			panelAjaxProgress.append(divAjaxImgProgress);
			panelAjaxProgress.prependTo('body');
		}

		panelAjaxProgress
				.height($(window).height()).width($(window).width())
				.css({ 'position': 'fixed', 'top': '0px', 'left': '0px', 'bottom': '0px', 'right': '0px',
					'text-align': 'center', 'border': '1px solid #666',
					'z-index': '90000000'
				});
		panelAjaxShade
				.height($(window).height()).width($(window).width())
				.css({ 'position': 'fixed', 'top': '0px', 'left': '0px', 'bottom': '0px', 'right': '0px',
					'background': '#fff', 'opacity': '0.5'
				});

		divAjaxImgProgress.css({ 'position': 'relative', 'top': ($(window).height() / 2) - (divAjaxImgProgress.height() / 2) + 'px' });

		panelAjaxProgress.fadeIn("fast");
		divAjaxImgProgress.fadeIn("fast");

		ajaxSpinnerVisible = true;
		$(window).bind('resize', ajaxProcesingResizing);
	}
}

// Hide ajax process panel
function ajaxPostBackEnd() {
	if (ajaxSpinnerVisible) {
		var panelAjaxProgress = $("#divAjaxProgress");
		var divAjaxImgProgress = $("#divAjaxImgProgress");

		divAjaxImgProgress.fadeOut("fast");
		panelAjaxProgress.fadeOut("fast");

		ajaxSpinnerVisible = false;
		$(window).unbind('resize', ajaxProcesingResizing);
	}
}

// Resize ajax panel when on window resize
function ajaxProcesingResizing() {
	if (ajaxSpinnerVisible) {
		var panelAjaxProgress = $("#divAjaxProgress");
		var divAjaxImgProgress = $("#divAjaxImgProgress");
		var panelAjaxShade = $("#divAjaxShade");

		panelAjaxProgress.height($(window).height()).width($(window).width());
		panelAjaxShade.height($(window).height()).width($(window).width());

		divAjaxImgProgress.css({ 'top': ($(window).height() / 2) - (divAjaxImgProgress.height() / 2) + 'px' });
	}
}

function beginRequest(sender, args) {
	document.body.style.cursor = "wait";
}

function pageLoaded(sender, args) {
	document.body.style.cursor = "default";
}

function getThumbNailPath(path, width, height) {
	var lastSlashPos = path.lastIndexOf('/');
	var filename = path.substr(lastSlashPos + 1);
	var directory = path.substr(0, lastSlashPos);
	var lastDotPos = filename.lastIndexOf('.');
	var filenameWithOutExtension = filename.substr(0, lastDotPos)
	var fileExtension = filename.substr(lastDotPos)
	return directory + "/ThumbNails/" + filenameWithOutExtension + "_" + width + "x" + height + "_thumb" + fileExtension;
}

function measureHtml(html, fontStyle) {
	var tmp = document.createElement('span');
	tmp.style.display = 'inline';
	tmp.style.position = 'absolute';
	tmp.style.top = '-1000px';
	tmp.style.left = '-1000px';
	tmp.style.font = fontStyle;
	tmp.innerHTML = html;

	document.body.appendChild(tmp);
	var retVal = { width: tmp.clientWidth, height: tmp.clientHeight };
	document.body.removeChild(tmp);

	return retVal;
}

function fileValidateError(errorType) {
	if (errorType == 1)
		alert("A file you tried to upload was not of a permitted type. Only *.jpeg, *.jpg, *.gif, *.png, *.bmp are allowed");
	else
		alert("You have an invalid character in your filename. These are the accepted characters: a-z 0-9 ~ !( ) - + = [ ] { } , . $");
}

function getNumericThousandsSeparator() {
	var dummy = new Number(11111111);
	var thousandSep = dummy.toLocaleString().replace(/1/g, '');
	return (thousandSep.length > 0 ? thousandSep.charAt(0) : ',');
}

function getNumericDecimalSeparator() {
	var dummy = new Number(1.1);
	var thousandSep = dummy.toLocaleString().replace(/1/g, '');
	return (thousandSep.length > 0 ? thousandSep.charAt(0) : '.');
}

function JSSafe(txtString) {
	var myRegExp = new RegExp("'", "g");
	return (txtString).replace(myRegExp, "\\'");
}

function openReportInAppropriateWindow(url, popupWindowID, modalTitleID) {
	//Please use ajaxContainer.FindControl to determine the identifiers of the modal (popupWindowID, modalTitleID)
	//please check jobs2 jobsContent.ascx for reference
	document.getElementById(modalTitleID).innerHTML = 'Report This Listing as Inappropriate';
	behavior = $find('editItemBehavior');
	if (behavior) {
		var ifr = document.getElementById('liveEditDialog');
		var liveEditPopupWindow = document.getElementById(popupWindowID);
		liveEditPopupWindow.className = "modalContainer reportInappropriate";

		var url = "/common/modules/ReportInappropriate/ReportInappropriate.aspx?popupWindowID=" + popupWindowID + "&url=" + url;
		ifr.src = url;
		ifr.style.display = 'block';
		behavior.show();
	}
}

function ChangeDateFormat(elem) {
	if (elem.value != "") {
		var Error = false;
		var dateSplit = (elem.value).split("/");

		if (dateSplit.length == 3) {
			if (dateSplit[0] <= 12 && dateSplit[1] <= 31) {

				var d = new Date(elem.value);
				var currentDate = new Date();

				var selectedDate = d.getDate();
				var selectedMonth = d.getMonth();
				var SelectedYear = d.getFullYear();

				if (isNaN(selectedDate))
					Error = true;
				else if (isNaN(selectedDate))
					Error = true;
				else if (isNaN(selectedDate))
					Error = true;
				if (Error == false) {
					if (selectedDate.toString().length == 1)
						selectedDate = '0' + selectedDate;

					selectedMonth++;

					if (selectedMonth.toString().length == 1)
						selectedMonth = '0' + selectedMonth;


					currentYear = currentDate.getFullYear();

					if (SelectedYear.toString().substr(0, 2) < 20)
						SelectedYear = currentYear;
					elem.value = selectedMonth + '/' + selectedDate + '/' + SelectedYear;
				}
			}
			else
				Error = true;
		}
		else
			Error = true;

		if (Error == true) {
			alert('Date should be in the format MM/DD/YYY');
			elem.value = "";
		}
	}
}

function ChangeDateFormatNew(elem) {
	return isDateNew(elem.value);
}

function isSilverlightInstalled() {
	var isSilverlightInstalled = false;
	try {
		//check on IE
		try {
			var slControl = new ActiveXObject('AgControl.AgControl');
			isSilverlightInstalled = true;
			isSilverlightInstalled = true;
		}
		catch (e) {
			//either not installed or not IE. Check Firefox.
			if (navigator.plugins["Silverlight Plug-In"]) {
				isSilverlightInstalled = true;
			}
		}
	}
	catch (e) {
		//we don't want to leak exceptions. However, you may want
		//to add exception tracking code here.
	}
	return isSilverlightInstalled;
}

function setModalClass(cssClass, behaviorID) {
	var modalContainer = document.getElementById(behaviorID._PopupControlID);

	if (modalContainer)
		modalContainer.className = 'modalContainer modalContainerCP ' + cssClass;
}

function setModalClassFE(cssClass, behaviorID) {
	var modalContainer = document.getElementById(behaviorID._PopupControlID);

	if (modalContainer)
		modalContainer.className = 'modalContainer ' + cssClass;
}

//------------------- Copy Link ---------------------//
function showCopyLinkWindow(relatedLink, absoluteAddress, behavior, ifrID) {
	if (behavior) {
		setModalClass('modalCopyLink', behavior);
		var iFrame = document.getElementById(ifrID);
		iFrame.src = '/common/admin/CopyLink.aspx?relatedLink=' + encodeURIComponent(relatedLink) + '&absoluteAddress=' + encodeURIComponent(absoluteAddress);
		iFrame.style.display = 'block';
		behavior.show();
	}
}

function showCopyLinkWindowUsingAddress(absoluteAddress) {
	var relatedUrl = absoluteAddress.replace(window.location.host, '');
	relatedUrl = relatedUrl.replace(window.location.protocol + '//', '');

	var behavior = $find('copyLinkBehavior');
	if(behavior)
		showCopyLinkWindow(relatedUrl, absoluteAddress, behavior, 'copyLinkDialog');
	else
		showCopyLinkWindow(relatedUrl, absoluteAddress, $find('editItemBehavior'), 'liveEditDialog');
}

function showCopyLinkWindowUsingRelatedLink(relatedUrl) {
	var absoluteUrl = window.location.protocol + '//' + window.location.host + relatedUrl;

	var behavior = $find('copyLinkBehavior');
	if (behavior)
		showCopyLinkWindow(relatedUrl, absoluteUrl, behavior, 'copyLinkDialog');
	else
		showCopyLinkWindow(relatedUrl, absoluteUrl, $find('editItemBehavior'), 'liveEditDialog');
}

function closeCopyModal() {
	var behavior = $find('copyLinkBehavior');
	if (behavior)
		behavior.hide();
	else {
		behavior = $find('editItemBehavior');
		if (behavior)
			behavior.hide();
	}
}
//------------------- Copy Link End---------------------//

//Parses the query string for the specified paramter and returns the value
//Returns "" if the parameter is not found
function GetQueryStringParameter(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.href);
    if (results == null)
        return "";
    else
        return results[1];
}

function setModalTitle(title, behaviorID) {
    if (behaviorID) {
        $('#' + behaviorID._PopupControlID).find('.modalTitle').text(title);
    }
    else {
        //if behaviorID is not provided, do the same as setModalTitle on FrontEnd.js
        var titleElem = document.getElementById('ctl00_LiveEditModalTitle');

        if (titleElem == null)
            titleElem = document.getElementById('ctl00_LiveEditModalTitle');

        if (titleElem == null)
            titleElem = document.getElementById('ctl00_ctl00_NotifyMeModalTitle');

        if (titleElem)
            titleElem.innerHTML = title;
    }
}

//------------------- Copy Link End---------------------//

// Validates domain of email with service (ensures MX record present, DNS name valid, acceptable format).
// The callbacks object should contain the following methods:
// * badFormat - Email format invalid. Will also be thrown for null/empty email addresses.
// * mxMissing - MX record missing for the domain.
// * dnsError - A DNS error occurred (domain invalid, invalid characters in domain, etc).
// * success - The email appears to be valid.
function validateEmailDomain(emailAddress, callbacks) {
	$.ajax({
		type: "POST",
		url: "/Services/ValidateEmail.ashx",
		data: { email: emailAddress },
		success: function (data, textStatus, jqXHR) {
			switch (data.d) {
				case 1:
					callbacks.badFormat(emailAddress);
					break;
				case 2:
					callbacks.mxMissing(emailAddress);
					break;
				case 3:
					callbacks.dnsError(emailAddress);
					break;
				case 0:
				default:
					callbacks.success(emailAddress);
					break;
			}
		}
	});
}

//Called when opening action menu.
function openPopup(id, event) {
	var $popUp = $(document.getElementById(id));

	if ($popUp.hasClass('popped')) {
		//do not do anything if popup is already open.
		return false;
	}

	//Hide all popups already open if nesessary.
	$('.popUp').fadeOut(200).removeClass('popped');
	$('.popUpParent').removeClass('popped');

	//Open popup
	$popUp.fadeIn(200);
	$popUp.addClass('popped');
	$popUp.parents('.popUpParent').addClass('popped');

	//prevent triggering any other event.
	if (window.event)
		window.event.cancelBubble = true;
	else
		event.stopPropagation();
}
