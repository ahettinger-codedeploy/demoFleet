// JavaScript Document
/*
	Calendar Pop-up Edit Window
	mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	
	Author: Ian Carr
	Date: July 2009
	
	Javascript Functions that allow a
	user to edit many diffrent mini
	documents in rich text with just one
	editor instance. Currently is designed
	to work with tinyMCE editor.
*/

/*
	Global Variables to save us time and money
*/
var minWinWidth = 460;
var minWinHeight = 460;

var current = "0"; // Our current document we are editing - uses arbitrary integer id numbers to find via special css id values
var edWindowOpen = false; // Is our editor currently open?
var edName = "edWindow"; // The css id name used to name parts of our editor window
var edDivName = edName + "pop"; // id of the main div of the window
var mceName = edName + "mce"; // name of the textarea that tinyMCE turns into a full editor

//Initialized Variables:
var ed = null; // Our tinyMCE instance
var edDiv = null; // the div that becomes the editor popup
var edTitle = null; // The div of the edit window title

var arrayBox = null; // Array of every day box (used for resizing)
var lenBox = null; //number of elements in arrayBox
var arrayMsg = null; // Array of every "(more...)" message (used for resizing)
var lenMsg = null; //number of elements in arrayMsg

var isResize = false; //Used to lock out multible calls to reDraw

var isLink = false; //Used to prevent editor from opening when user clicks on a link

var isIE6  = false; //Used to change behaviors for silly old ie6
var isIE7  = false; //Used to change behaviors for silly old ie7

var jump = true; //If true will auto-jump so Calendar fills the screen on load

var edInitCallback = null; //If set and is a function, will be called at end of initED()
var edInitEdComplete = false; //Set to true at the end of initED()
var edTinyMCEInitComplete = false; //Set to true by callback from tinyMCE editor when it has been init.

var lastUpdateTimeArray;

var blueBarHeight = 25; // height of the blue menu bar for scrolling

function getED() {
	if (ed == null) {
		var myed = tinyMCE.get(mceName);
		if (typeof(myed) == 'object') {
			ed = myed;
		} else {
			//alert("getED failed");
		}
	}
	return ed;
}

// Callback fuction used by tinyMCE to indicate it has fully loaded
function onTinyMCEInitComplete() {
	edTinyMCEInitComplete = true;
	
	// Support a callback when initED is completed AND tinyMCE is loaded too ...
	if (edInitCallback != null && edInitEdComplete) {
		if(typeof(edInitCallback) == 'function') {
			edInitCallback();
		}
		edInitCallback = null;
	}
}

// Sets up our variables and does our initial resize call
function initED(){
	// Try to get the tinyMCE editor window object
	var myed = tinyMCE.get(mceName);
	if (typeof(myed) != 'object') {
		if (isIE6 || isIE7) {
			return;
		}
	}
	// Successfully got it, finish initialization
	ed = myed;

	//Collect all of the day boxes into an array
	//arrayBox = getElementsByClass("daybox");
	arrayBox = $$(".daybox");
	lenBox = arrayBox.length;
	
	//Collect all of the "(more...)" daymsgs into an array
	//arrayMsg = getByClass("daymsg");
	arrayMsg = $$(".daymsg");
	lenMsg = arrayMsg.length;
	
	//Set the last 'update' time to now
	lastUpdateTimeArray = new Array();
	var nowtime = new Date();
	for ( i = 0; i < lenBox; i++ ) {
		var id = parseInt(arrayBox[i].id);
		lastUpdateTimeArray[id] = nowtime.valueOf();
	}
	
	//resize everything
	reDraw();

	//make our links disable the ed popup behavior
	linkCheck();
	
	//initalize our remaining varaibles
	edTitle = $("popName");
	edDiv = $(edDivName);
	
	//Make resizing activate on window resize
	window.onresize = resize;
	
	//Display the Calendar Boxes
	paint();

	paintMore();
	//Jump to the Calendar
	//scrollToMenubar();
	
	//Display the Chrome on top
	//document.getElementById("TheChrome").style.display = "block";

	// initED is finished
	edInitEdComplete = true;

	// Support a callback when initED is completed AND tinyMCE is loaded too ...
	if (edInitCallback != null && edTinyMCEInitComplete) {
		if(typeof(edInitCallback) == 'function') {
			edInitCallback();
		}
		edInitCallback = null;
	}
}

function paint(){
	for( i = 0; i < lenBox; i++)
		arrayBox[i].style.display = "block";
}

function paintMore() {
	if (numInCol <= 10) {
//		alert("paintMore");
		for( var i = 0; i < lenMsg; i++ ){
			isMore(i+1);
		}
	}
}
// Reacts to any click in a daybox Will launch
// or load the editor window as is needed.
function activate(cur){
	//Do nothing if link is clicked
	if(isLink)
		return;
	//Handle case where activate is called before initED() or before tinyMCE is loaded
	if(edInitEdComplete == false || edTinyMCEInitComplete == false) {
		// Create a callback to call ourselves after initED() and/or tinyMCE is done
		if (edInitCallback == null)
			edInitCallback = function() { activate(cur); };
		return;
	}
	//Do nothing if current is cur
	if(current == cur && edWindowOpen) {
		setTimeout ( "getED().focus();", 10); // Make editor the cursor focus
		return;
	}
	//If allready open, save contents of current day box pressed and turn off color
	if(edWindowOpen){
		changeText(true);
		selectOFF();
	} else {
		//or launch the new window
		openEd();
	}
	//update variables, editor window
	current = cur;
	titleUpdate();
	loadText(cur);
	selectON();
	setTimeout ( "getED().focus();", 10); // Make editor the cursor focus
}

function getScrollTop() {
  var scrOfY=0;
  //var scrOfX=0;
  if( typeof( window.pageYOffset ) == 'number' ) {
    //Netscape compliant
    scrOfY = window.pageYOffset;
    //scrOfX = window.pageXOffset;
  } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
    //DOM compliant
    scrOfY = document.body.scrollTop;
    //scrOfX = document.body.scrollLeft;
  } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
    //IE6 standards compliant mode
    scrOfY = document.documentElement.scrollTop;
    //scrOfX = document.documentElement.scrollLeft;
  }
  return scrOfY;
}
// Displays the editor window and calls the grey out function
function openEd(){
	greyON();
	edDiv.style.display="block";
	edWindowOpen = true;
	var centerHeight = (document.body.offsetHeight / 2) - 150;
	edDiv.style.top = (getScrollTop()+centerHeight)+"px";
}

// Hides the editor window (saving any changes) and calls the un-grey out funciton
function closeEd(){
	changeText(true);
	greyOFF();
	edDiv.style.display="none";
	edWindowOpen = false;
	selectOFF();
}

// Text and border effect used when edit window is open
// Works through magic of css inheritance (all elements
// that change inherit their colors from the div w/ id of "thePage")
var graySaveBorderColor;
var graySaveColor;
function greyON(){
	//if(isTemplate)
	//	return;
	var page = $("thePage");
	graySaveBorderColor=page.style.borderColor;
	graySaveColor=page.style.color;
	page.style.borderColor="#AAA";
	page.style.color="#666";
}

// Reverses effects of greyOn()
function greyOFF(){
	//if(isTemplate)
	//	return;
	var page = $("thePage");
	page.style.borderColor=graySaveBorderColor;
	page.style.color=graySaveColor;
}

// Background effect used for the daybox currently
// being edited.
var selectSaveBackgroundColor;
function selectON(){
	//if(isTemplate)
	//	return;
	selectSaveBackgroundColor = $(current + 'div').style.backgroundColor;
	$(current + 'div').style.backgroundColor = "#D1F2F7";
}

// Reverses effects of selectON
function selectOFF(){
	//if(isTemplate)
	//	return;
	$(current + 'div').style.backgroundColor = selectSaveBackgroundColor;
}

// Automatically called by tinyMCE when ever the user interacts with it
// -- only called when tinyMCE adds an 'undo level' which may not always
//    happen on every key press.
var loadingText = 0;

function autoSave(){
	if (loadingText == 0) {
		changeText(false);
	}
}

function findMatchingCloseBracket(textin, startAt) {
	var index = startAt;
	var nesting = 1;
	var maxIndex = textin.length;
	while (nesting > 0 && index < maxIndex) {
		var ch = textin.charAt(index);
		if (ch == '[') {
			nesting++;
		} else if (ch == ']') {
			nesting--;
		} else if (ch == '<') {
			// quit with markup
			return -1;
		}
		index++;
	}
	if (nesting == 0) {
		return index-1;
	}
	return -1;
}

function processHiddenText(text, readonly) {
	//alert("processHiddenText"+text);
	var ex = 10;
	var startAt = 0;
	while (ex-- > 0) {
		var index = text.indexOf("[", startAt);
		if (index == -1) {
			break; // end of the loop no more text to process
		}
		//var endIndex = text.indexOf("]", index); // find the end of the hidden text
		var endIndex = findMatchingCloseBracket(text, index+1);
		if (endIndex == -1) {
			break; // no end bracket, stop and leave it alone
		}
		var hiddenText = text.substring(index+1, endIndex); // pick up everything between the brackets
		var replacementText = "";
		if (hiddenText.length > 0) {
			var barIndex = hiddenText.indexOf("|");
			if (barIndex == -1) {
				// hidden text case
				hiddenText = hiddenText.stripTags();
				hiddenText = hiddenText.replace(/"/g, "&quot;");
				replacementText = "<span title=\""+hiddenText+"\" style=\"cursor:pointer;font-weight:bold\">*</span>";
			} else {
				// obfuscated text case
				var editorText = hiddenText.substring(0, barIndex);
				var publicText = hiddenText.substring(barIndex+1);
				if (!readonly) {
					replacementText = editorText;
				} else {
					replacementText = publicText;
				}
			}
		}
		// replace the bracked text with the replacementText
		startAt = index+replacementText.length;
		text = text.substring(0, index)+replacementText+text.substring(endIndex+1);
	}
	//alert("returning "+text);
	return text;
}
// Saves to day box with Edited content (and activates autosave)
function changeText(instantSave){
	if (typeof(instantSave) == 'undefined') {
		instantSave = false;
	}
	if (typeof(getED().settings.readonly) == 'undefined' || !getED().settings.readonly) {
		var text = getED().getContent(); //Get the content from editor
		
		// Don't update anything if its still really the same
		if (text != $(current + 'hi').value) {
			$(current + 'up').innerHTML = processHiddenText(text, $('ht_readonly').value == "y"); // put it into the visible day box
			$(current + 'hi').value = text; // Also put it into hidden input field used for autosaving
			
			if (instantSave === true) {
				calendarDayHasChanged(current); //Flag the day as changed which is useful if autoSave fails
				calendarAutoSave(current); //Trigger the instant autosave event by hand
			}
			else
				calendarHandleInput(current); //Trigger the delayed autosave event by hand
		}
		
		// else catch case where text may have been changed and updated
		// but not saved yet and an instant save is now requested
		else if (instantSave === true) {
			calendarSaveDayIfChanged(current);
		}
	}
	if (numInCol <= 10) {
		isMore(current); //Checks if a "(more...)" bar is needed, except for event view which is autosizing
	}
	linkCheck(); //Checks for any new links
}

// Loads to editor with ajax provided content and updates day box
function loadTextCompleteSuccess(json, index){
	if (index != null) {
		var nowtime = new Date();
		lastUpdateTimeArray[index] = nowtime.valueOf();

		// If data was returned, json.request1 will not be 'undefined'
		// This means the data was modified on the server and should be updated
		if (typeof(json.request1) != 'undefined') {
			// This puts the variables into the document form
			$(index + 'up').innerHTML = processHiddenText(json.request1, $('ht_readonly').value=="y");
			if (current == index) {
				getED().setContent( ($('ht_readonly').value=="y" ? processHiddentText(json.request1, true) : json.request1) ); // Load it to editor
			}
			
			if (json.crcDay1)
				eval('document.form1.crcDay' + index + '.value = json.crcDay1;');
			if (json.updatecount1)
				eval('document.form1.updatecount' + index + '.value = json.updatecount1;');
			if (json.existingRecord1)
				eval('document.form1.existingRecord' + index + '.value = json.existingRecord1;');
		}
		// No data was returned, therefore the data on the server is consistent
		// with our data
		else {
			if (current == index) {
				getED().setContent( ($('ht_readonly').value=="y" ? processHiddenText($(index + 'hi').value, true) : $(index + 'hi').value) ); // Load it to editor
			}
		}
	}
	if (loadingText > 0) {
		loadingText --;
	}
	getED().setProgressState(false); // Done loading
}

// Loads to editor with Day box content after failed ajax request
function loadTextCompleteFailure(json, index){
	if (index != null) {
		if (current == index) {
			getED().setContent($(index + 'up').innerHTML); // Load it to editor, hidden text already processed
		}
	}
	if (loadingText > 0) {
		loadingText --;
	}
	getED().setProgressState(false); // Done loading
}

// Loads to editor with Day box content
function loadText(id){
	var updatetime = lastUpdateTimeArray[id]; //Get last update time for content
	var nowtime = new Date(); //Get current time for content
	if (nowtime.valueOf() - updatetime > ( 2 * 60 * 1000 ) ) { // More than 2 minutes, do a forced check for new content
		getED().setProgressState(true); // Put up 'ajax spinner' part of editor

		// Set up the parameter array to be passed back to the server
		var params = {
			session_user_name: document.form1.session_user_name.value,
			requestIndex1: id
		};
	
		// Have to extract "i" value from my_id field
		var my_id_params = document.form1.my_id.value.toQueryParams();
		if (my_id_params.i != null) {
			params.i = my_id_params.i;
		}
		else {
			getED().setContent( ($('ht_readonly').value=="y" ? processHiddenText($(id + 'hi').value) : $(id + 'hi').value) ); // Load it to editor
			getED().setProgressState(false); // Done loading
			return;
		}
	
		// Have to use 'eval' to get the values from the particular index we are working
		eval('params.crcDay1 = document.form1.crcDay' + id + '.value;');
		eval('params.updatecount1 = document.form1.updatecount' + id + '.value;');
		eval('params.yyyymmddDay1 = document.form1.yyyymmddDay' + id + '.value;');
		eval('params.existingRecord1 = document.form1.existingRecord' + id + '.value;');
		
		// Pass the index we were working on--this is so the updated data can be put in the right place later on
		params.requestIndex1 = id;
		params.numOfDaysToLoad = 1;
		
		// Cookie checking code
		if ( typeof(checkSessionCookie) == 'function' ) {
			if ( checkSessionCookie() != true ) {
				params.session_id = session_id;
			}
		}
		
		// Send the ajax request
		loadingText ++;
		new Ajax.Request('load_day.php', {
			method: 'POST',
			parameters: params,
			onSuccess: function(transport) {
				var index = null;
				if (transport.request && transport.request.parameters && transport.request.parameters.requestIndex1)
				  index = transport.request.parameters.requestIndex1;
			  if (transport.responseText) {
					var json = transport.responseText.evalJSON();
					if (!json || !json.result || json.result != "OK")
						loadTextCompleteFailure(json, index);
					else
						loadTextCompleteSuccess(json, index);
				}  
				else
					loadTextCompleteFailure(null, index);
				},
			onFailure: function(transport) {
				var index = null;
				if (transport.request && transport.request.parameters && transport.request.parameters.requestIndex1)
				  index = transport.request.parameters.requestIndex1;
				loadTextCompleteFailure(null, index);
			},
			onException: function(request, e) {
				if (e.toString)
					alert("Exception: " + e.toString());
				else
					alert("Exception");
				var index = null;
				if (request.parameters && request.parameters.requestIndex1)
				  index = request.parameters.requestIndex1;
				loadTextCompleteFailure(null, index);
			}
		});
	}
	else {
		getED().setContent( ($('ht_readonly').value == "y" ? processHiddenText($(id + 'hi').value, true) : $(id + 'hi').value) ); // Load it to editor
	}
}

//updates the edit widnow title with the current edited days date
function titleUpdate(){
	var date, year, month, day;
	
	date = $(current + "date").parentNode.id; // get encoded year-MM-DD date
	date = date.split("-"); //turn encoded date into an array
	year = date[0]; //get year number
	
	switch(date[1]){ //turn month number into word
		case "01":
			month = "January";
			break;
		case "02":
			month = "February";
			break;
		case "03":
			month = "March";
			break;
		case "04":
			month = "April";
			break;
		case "05":
			month = "May";
			break;
		case "06":
			month = "June";
			break;
		case "07":
			month = "July";
			break;
		case "08":
			month = "August";
			break;
		case "09":
			month = "September";
			break;
		case "10":
			month = "October";
			break;
		case "11":
			month = "November";
			break;
		default:
			month = "December";
			break;
	}
	day = date[2]; //get day number
	if (day.charAt(0) == '0') //remove preceding 0 on day number
    	day = day.substr(1,day.length-1)
//	edTitle.innerHTML = month + " " + day + ", " + year; //set edit box's title to date string.
	var params = new Array();
	params['[month]'] = month;
	params['_[day]'] = day;
	params['_[year]'] = year;
	edTitle.innerHTML = _l('[month] _[day] _[year]', params);

}

//Simple container function to prevent too many calls to reSize.
function resize(){
	if(!isResize){
		isResize = true;
		setTimeout ( "resize2()", 50 );
	} else {
		//alert("resize skipped "+$('thePage').offsetWidth);
	}
}

//helper function to actually call resize and on completion turn off the lock
function resize2(){
	reDraw();
	paintMore(); // update the more bars on resize
	isResize = false;
}

//Resizes all of the day boxes such that the calendar alone will exactly fill the entier browser window
function reDraw(isSecondaryRedraw) {
	//default values for old browsers
	var pageW = minWinWidth, pageH = minWinHeight;
	var fullWidth = minWinWidth;
	var noff;
	var ieoff;
	if(iframe){ //if iframe = true will not take scroll bar sizes into account when rendering calendar
		noff = 54;
		ieoff = 54;
	} else {
		noff = 32;
		ieoff = 32;
	}
	
	if(isIE6) {
		$("thePage").style.height="auto"; // added this so that we can set a height on the calendar div area to prevent IE7/8 from jumping during paging (because of no height)
	}

	var needsAnotherRedraw = false;
	//Get size of window (either browser or iframe size) and subtract scroll bar offset from it
	if (parseInt(navigator.appVersion)>3) {
		if (navigator.appName=="Netscape") {
			fullWidth = window.innerWidth;
			pageW = $('thePage').offsetWidth;
			if (!isSecondaryRedraw && (fullWidth - pageW) < 10) {
				needsAnotherRedraw = true;
			}
			pageH = window.innerHeight - noff - (iframe ? 0 : blueBarHeight);
		}
		if (navigator.appName.indexOf("Microsoft")!=-1) {
			fullWidth = document.body.offsetWidth;
			pageW = $('thePage').offsetWidth;
			pageH = document.body.offsetHeight - ieoff - (iframe ? 0 : blueBarHeight);
		}
	}
//alert("pageW="+pageW+", width="+fullWidth);
	if (needsAnotherRedraw) {
		setTimeout('reDraw(true)', 50); // this doesn't work when the window actually DOES get smaller than the display area...
	}
	if(pageW < minWinWidth)
		pageW = minWinWidth;
	if(pageH < minWinHeight)
		pageH = minWinHeight;
		
	if(isIE6) {
		$("thePage").style.width = pageW;
	}
	if ($('cal_horizontal_ad') != null) {
		pageH -= $('cal_horizontal_ad').offsetHeight; // in case an add is being displayed
	}
	pageW -= 3; // for the left border
//alert('pageW='+pageW+"fullWidth="+fullWidth);
	// calculate rounded size for day boxes 
	// (we are conservative because so much as a single pixle too wide will
	// cause the whole calendar to have a broken display)
	error = 1.5; // 1 for border width, .5 so we always get the number rounded down.
	boxW = Math.round((pageW / numInRow) - error);
	boxH = Math.round((pageH / numInCol) - error);
	
	// adjust the width and height of all calendar days
	for( i = 0; i < lenBox; i++ ){
		if (numInCol <= 10) {
			arrayBox[i].style.width= boxW + "px";
			arrayBox[i].style.height= boxH + "px";
		} else {
			arrayBox[i].style.width= "99.9%";
			arrayBox[i].style.height = "auto"; // let it scale to the required height
		}
	}

	if (numInCol <= 10) {
		$('thePage').style.height = ((boxH * numInCol)+10)+"px";// set the div height, helps prevent IE from growing/shrinking
	} else {
		$('thePage').style.height = pageH+"px";
	}

	// adjust the width and height of any visible "(more...)" bars
	for( i = 0; i < lenMsg; i++ ){
		if(arrayMsg[i].style.display != "none"){
			arrayMsg[i].style.top=(boxH - 15)+ "px";
			arrayMsg[i].style.height= "20px";
		}
	}
	scrollToMenubar();
}

//disables the ability to launch the editor popup when a user has a mouse over a link. Restores the ability when the user moves the mouse off the link.
//based on code from: http://www.webmonkey.com/tutorial/Get_Started_With_Prototype
function linkCheck(){
	// Gather every link and give it mouseover code to turn isLink on
	// and a mouseout event to turn isLink off. The editor popup will
	// not launch when isLink is true, thus allowing links to work as expected.
	$$('a').each(function(elmt) {
		elmt.observe('mouseover', function(ev) {
			isLink = true;
		});
		elmt.observe('mouseout', function(ev) {
			isLink = false;
			//alert(ev.target.innerHTML);
		});
	});
}

//Checks if a "(more...)" bar should be turned on
function isMore(cur){
	box = $(cur + 'up'); //get current day's text box
	height = box.offsetHeight + box.offsetTop; //get it's height
	var element = $(cur + 'msg');
	if(arrayBox[1].offsetHeight <= height){ //activate "(more...)" bar if needed
		element.style.display = "block";
		element.setOpacity(0.7);
		element.style.backgroundColor='#D0D0D0';
	} else {
		element.style.display = "none";
	}
}

//Browser compliant way to make "(more...)" bars go transparent
/* This is available through prototype
function setOpacity(value) {
	$(current + 'msg').style.opacity = value/10;
	$(current + 'msg').style.filter = 'alpha(opacity=' + value*10 + ')';
}
*/

//Gets all objects with a particular class
//From: http://www.dustindiaz.com/getelementsbyclass/
/* Prototype does this--see documentation for $$
function getElementsByClass(searchClass,node,tag) {
	var classElements = new Array();
	if ( node == null )
		node = document;
	if ( tag == null )
		tag = '*';
	var els = node.getElementsByTagName(tag);
	var elsLen = els.length;
	var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");
	for (i = 0, j = 0; i < elsLen; i++) {
		if ( pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
	}
	return classElements;
}
*/

//Gets all objects with a particular class
//From: http://www.snook.ca/archives/javascript/your_favourite_1
// Warning!! getClass() is a pre-defined browser function... renamed it to getByClass()
/* Prototype does this--see documentation for $$
function getByClass(xx){
	var rl=new Array();
	var ael=document.all?document.all:document.getElementsByTagName('*'); //not here ";" originally
	for(i=0,j=0;i<ael.length;i++){
		if((ael[i].className==xx)){
			rl[j]=ael[i];
			j++;
		}
	}
	return rl;
}
*/

//Replaces all classes with another class
// Currently not used , but may be useful for resizing the editor window
//From: http://www.snook.ca/archives/javascript/your_favourite_1
/* Its not used--nor is it prototype-ified
function classRepl(whatReplace,withWhatReplace){
	for(var i=0;i<getByClass(whatReplace).length;i++){
		getByClass(whatReplace)[i].onclick=function(){
			this.className=this.className==withWhatReplace?whatReplace:withWhatReplace;
		}
	}
}
*/

//Following three functons taken from the Photo App's Code.

function scrollToTop() {
	setTimeout("scroll(0,0);", 100);
}

function scrollToMenubar() {
	if ($('menuBar') != null) {
		var loc = findPos($('menuBar'))[0] - (iframe ? 0 : blueBarHeight);
		setTimeout("scroll(0, "+loc+");", 100);
	}
} 

function findPos(obj) {
	var cleft = 0;
	var ctop = 0;
	if (obj.offsetParent) {
		do {
			cleft += obj.offsetLeft;
			ctop += obj.offsetTop;
		} while (obj = obj.offsetParent);
	}
	return [ctop,cleft];
} 

