var IE = false; //may later be overridden by conditionally included re-ie-rollover.js
var re_prefs;
var re_editing = "n";

var noimagePath = "/calendar10/repeatingdialog/images/no.icon.png";

function re_setUpCalendars(){
	Calendar.setup({
		   //inputField	: 'startDate',
	   //ifFormat   :  "%Y-%m-%d",     // format of the input field (even if hidden, this format will be honored)
	   //daFormat   :  "%Y-%m-%d",  // format of the displayed date
	   inputField   :  'cal_popup_input',     // Both the Repeating Events startdate, enddate, and the calendar "GoTo" popup calendar use this date to determine what month to display when calendar popups
		   ifFormat		: '%b. %e, %Y',
		   button		: 'startdateicon',
		   align		: 'bc',
		   singleClick	: true,
	   step         :    1,            // display every year in the drop-down boxes
			 weekNumbers  :  false,          // turn off week numbers
		   firstDay		: weekStart,
		   onUpdate		: re_changeStartDateWrapper});
	
	Calendar.setup({
		   //inputField	: 'endDate',
	   inputField   :  'cal_popup_input',     // sane as startdate and Calendar green button "GoTo" popup calendar
		   ifFormat		: '%b. %e, %Y',
		   button		: 'enddateicon',
		   align		: 'bc',
		   singleClick	: true,
	   step         :    1,            // display every year in the drop-down boxes
			 weekNumbers  :  false,          // turn off week numbers
		   firstDay		: weekStart,
		   onUpdate		: re_changeEndDateWrapper});
}			   

function re_edit( index, occurrenceDate )
{
	re_editing = "y";
	re_prefs = new Object();
	
	re_prefs['text'] = re_storedLinks[index].text;
	re_prefs['frequency'] = re_storedLinks[index].frequency;
	re_prefs['timeframe'] = re_storedLinks[index].timeframe;
	//alert( re_storedLinks[index].firstDay );
	re_prefs['startDate'] = new Date(re_storedLinks[index].startDate.substring(0,4),re_storedLinks[index].startDate.substring(5,7) - 1,re_storedLinks[index].startDate.substring(8,10));
	re_prefs['endDate']   = new Date(re_storedLinks[index].endDate.substring(0,4),re_storedLinks[index].endDate.substring(5,7) - 1,re_storedLinks[index].endDate.substring(8,10));

	if( re_storedLinks[index].endDate.substring(0,10) == "2099-12-31" )
		re_prefs['endIsDefined'] = false;
	else
		re_prefs['endIsDefined'] = true;
	re_prefs['color'] = re_storedLinks[index].color;
//alert( re_storedLinks[index].returnTo );
	re_prefs['returnTo'] = re_storedLinks[index].returnTo;
	re_prefs['firstDay'] = re_storedLinks[index].firstDay;
	re_prefs['repeatid'] = re_storedLinks[index].repeatid;
	re_prefs['monthstyle'] = re_storedLinks[index].monthstyle;
	re_prefs['weeknum'] = re_storedLinks[index].weeknum;
	re_prefs['dayname'] = re_storedLinks[index].dayname;
	re_prefs['emphasis'] = re_storedLinks[index].emphasis;
	re_prefs['notifyenable'] = re_storedLinks[index].notifyenable;
	re_prefs['notifyprior'] = re_storedLinks[index].notifyprior;
	re_prefs['notifyhour'] = re_storedLinks[index].notifyhour;
	re_prefs['notifyshares'] = re_storedLinks[index].notifyshares;
	re_prefs['notifyfriends'] = re_storedLinks[index].notifyfriends;
	re_prefs['notifyfriendslist'] = re_storedLinks[index].notifyfriendslist;
	re_prefs['image_url'] = re_storedLinks[index].image_url;
	re_prefs['occurrence_date'] = occurrenceDate;

//alert( "re_storedLinks monthstyle = " + re_storedLinks[index].monthstyle + ", re_prefs monthstyle = " + re_prefs['monthstyle'] );

/*alert( re_prefs['text'] + ", " + re_prefs['frequency'] + ", " + re_prefs['timeframe'] + ", " + re_prefs['startDate'] 
												+ ", " + re_prefs['endDate'] + ", " + re_prefs['color'] + ", " + re_prefs['returnTo'] );  */
	
	if(IE){
		re_fixIErollover();
	}
	
	re_prepareList('timeframe',re_prefs.timeframe);
	re_changeAction('color',re_prefs.color);
	re_changeAction('emphasis',re_prefs.emphasis);
	re_changeAction('frequency',re_prefs.frequency);
	re_changeAction('startDate',re_prefs.startDate);
	re_changeAction('endIsDefined',re_prefs.endIsDefined);
	if( re_prefs.endIsDefined == true )    // enddate needs to be put in proper format IF it exists
		re_changeAction('endDate',re_prefs.endDate);
	re_changeAction('text',re_prefs.text);
	re_setPanelVisibility('visible');
	re_prepareList('monthstyle',re_prefs.monthstyle);

	document.getElementById('notifyenable').checked = (re_prefs.notifyenable == 'Y');
	document.getElementById('notifyprior').value = re_prefs.notifyprior;
	document.getElementById('notifyhour').value = re_prefs.notifyhour;
	document.getElementById('notifyshares').checked = (re_prefs.notifyshares == 'Y');
	document.getElementById('notifyfriends').checked = (re_prefs.notifyfriends == 'Y');
	document.getElementById('notifyfriends_editlink').style.display = (re_prefs.notifyfriends == 'Y') ? "" : "none";
	document.getElementById('notifyfriendslist').value = re_prefs.notifyfriendslist;
	if (g_friendsWithInputBox != null) {
		g_friendsWithInputBox.loadFriendSettings(re_prefs.notifyfriendslist);
	}
	document.getElementById('image_url').src = ((re_prefs.image_url == '') ? noimagePath : re_prefs.image_url);
	display_ie_6_warning_dialog_if_needed( );
	if (re_prefs.endIsDefined && (re_formatString('Y-m-d', re_prefs.startDate) == re_formatString('Y-m-d', re_prefs.endDate))) {
		// special case, if the date range is the same day, don't offer the "Delete this Day" option since there is only one
		$('delete').style.display="block";
		$('delete_day').style.display="none";
	} else {
		$('delete').style.display="block";
		$('delete_day').style.display="block";
	}

	return false;  // Rich added Feb 8, 2008
}



function re_init(newEvent, startingDate)
{
	// mmo 2010-03-26: appears that this is ONLY called for new events
	re_editing = "n";
	if(newEvent){
		var st_date = (startingDate == null ? document.getElementById('re_start_date').value : startingDate);
		re_prefs = {  //Default values for new events
			frequency : 1,
			timeframe : (startingDate == null ? 0 : 3),
			startDate : new Date( st_date.substring(0,4), st_date.substring(5,7) - 1, st_date.substring(8,10)),
			/*startDate : new Date(),*/
			endIsDefined : (startingDate == null ? false : true),
			endDate : (startingDate == null ? new Date() : new Date( st_date.substring(0,4), st_date.substring(5,7) - 1, st_date.substring(8,10))),
			color : 0,
			text : '',
			monthstyle : 0,
			emphasis : 'N',
			notifyenable : 'N',
			notifyprior : 0,
			notifyhour : 5,
			notifyshares : 'N',
			notifyfriends : 'N',
			notifyfriendslist : '',
			image_url : ''
		};
/*		if(document.getElementById('delete')) {
			document.getElementById('buttons').removeChild(document.getElementById('delete')); 
		}  */
		$('delete').style.display="none";
		$('delete_day').style.display="none";
	} else { //editing existing event. Draws from object storedPrefs, defined in html <script>
		re_prefs = new Object();
		for(each in re_storedPrefs){
			re_prefs[each] = re_storedPrefs[each];
		}
		//re_prefs['text'] = text;
		//re_prefs['text'] = "hi there";
		//document.getElementById('delete').style.visibility = 'visible';
	}
	
	if(IE){
		//alert('is ie, fixing rollover11');
		re_fixIErollover();
	}
	
	re_prefs['firstDay'] = re_storedPrefs['firstDay'];
	re_prefs['returnTo'] = re_storedPrefs['returnTo'];
	
	re_prepareList('timeframe',re_prefs.timeframe);
	re_changeAction('color',re_prefs.color);
	re_changeAction('frequency',re_prefs.frequency);
	re_changeAction('startDate',re_prefs.startDate);
	if (startingDate != null) {
		re_changeAction('endDate', re_prefs.endDate);
	}
	re_changeAction('endIsDefined',re_prefs.endIsDefined);
	re_changeAction('text',re_prefs.text);
	re_prepareList('monthstyle',re_prefs.monthstyle);
	re_changeAction('emphasis', re_prefs.emphasis);
	document.getElementById('notifyenable').checked = (re_prefs.notifyenable == 'Y');
	document.getElementById('notifyprior').value = re_prefs.notifyprior;
	document.getElementById('notifyhour').value = re_prefs.notifyhour;
	document.getElementById('notifyshares').checked = (re_prefs.notifyshares == 'Y');
	document.getElementById('notifyfriends').checked = (re_prefs.notifyfriends == 'Y');
	document.getElementById('notifyfriends_editlink').style.display = document.getElementById('notifyfriends').checked ? "" : "none";
	document.getElementById('notifyfriendslist').value = re_prefs.notifyfriendslist;
	if (g_friendsWithInputBox != null) {
		g_friendsWithInputBox.loadFriendSettings(re_prefs.notifyfriendslist);
	}
	document.getElementById('image_url').src = ((re_prefs.image_url == '') ? noimagePath : re_prefs.image_url);
	re_setPanelVisibility('visible');
	document.getElementById('textarea').focus();
	
	display_ie_6_warning_dialog_if_needed( );

	if( newEvent == true )
		return false;  // causes the dialog to stay up
	return false;  // Rich added Feb 8, 2008
}


function re_generateRequest(){
	/*var string = 'http://www.keepandshare.com/calendar/action.php?';
	var args = new Array('ac=111345',
						 'st='+re_prefs.startDate,
						 'en='+re_prefs.endDate,
						 'rep='+re_prefs.timeframe,
						 'req='+re_prefs.text,
						 'def='+re_prefs.endIsDefined,
						 'freq='+re_prefs.frequency,
						 'co='+re_prefs.color,
						 'fd='+re_prefs.firstDay,
						 'app='+document.getElementById('app').value,
						 'to='+re_prefs.returnTo );    */

//alert( "endDate = " + re_prefs.endDate );
	//document.getElementById('h_startDate').value = re_formatString('Y-m-d', re_prefs.startDate);
	//document.getElementById('h_endDate').value = re_formatString('Y-m-d', re_prefs.endDate);
	document.getElementById('h_startDate').value = re_prefs.startDateYYMMDD;
	document.getElementById('h_endDate').value = re_prefs.endDateYYMMDD;
	document.getElementById('h_timeframe').value = re_prefs.timeframe;
	document.getElementById('h_text').value = re_prefs.text;
	document.getElementById('h_endIsDefined').value = re_prefs.endIsDefined;
	document.getElementById('h_frequency').value = re_prefs.frequency;
	document.getElementById('h_color').value = re_prefs.color;
	document.getElementById('h_emphasis').value = re_prefs.emphasis;
	document.getElementById('h_firstDay').value = re_prefs.firstDay;
	document.getElementById('h_app').value = document.getElementById('app').value;
	document.getElementById('h_returnTo').value = re_prefs.returnTo;
	if( re_prefs.repeatid )
		document.getElementById('h_repeatid').value = re_prefs.repeatid;
	document.getElementById('h_action').value = "update";
	document.getElementById('h_monthstyle').value = re_prefs['monthstyle'];
	document.getElementById('h_weeknum').value = re_prefs['weeknum'];
	document.getElementById('h_dayname').value = re_prefs['dayname'];
	document.getElementById('h_notifyenable').value = re_prefs['notifyenable'];
	document.getElementById('h_notifyprior').value = re_prefs['notifyprior'];
  document.getElementById('h_notifyhour').value = re_prefs['notifyhour'];
	document.getElementById('h_notifyshares').value = re_prefs['notifyshares'];
	document.getElementById('h_notifyfriends').value = re_prefs['notifyfriends'];
	document.getElementById('h_notifyfriendslist').value = (g_friendsWithInputBox != null) ? g_friendsWithInputBox.saveFriendSettings() : '';
	document.getElementById('h_image_url').value = re_prefs['image_url'];
	var now = new Date();
  document.getElementById('h_notifygmtoffset').value = now.getTimezoneOffset();
 //string += args.join('&');
	//if( re_prefs.repeatid )
	//	string += '&id='+re_prefs.repeatid;
	//return string;

	return;
}

/**
* singleInstance is true if only the current day is to be deleted
*/
function re_delete(singleInstance){
	//self.location = "http://www.keepandshare.com/calendar/action.php?ac=111345&id=" + re_prefs.repeatid + "&del=y" +
	//								'&app='+document.getElementById('app').value + '&fd=' + re_prefs.firstDay + '&to=' + re_prefs.returnTo;
	re_setPanelVisibility('hide');

	if( re_editing == "n")  // did user click on "delete" when creating a new repeating event?
		return true;	

	document.getElementById('h_repeatid').value = re_prefs.repeatid;
	document.getElementById('h_app').value = document.getElementById('app').value;
	document.getElementById('h_firstDay').value = re_prefs.firstDay;
	document.getElementById('h_returnTo').value = re_prefs.returnTo;
	document.getElementById('h_action').value = "del";
	if (singleInstance) {
		document.getElementById('h_occurrence_date').value = re_prefs.occurrence_date;
	}
	//return false;
  document.form1.what_button_was_pressed.value = "Repeating";
  document.form1.submit();
	return true;
}							


function re_doSubmit(){
	if(re_validate())  {

		//self.location = re_generateRequest();
		re_generateRequest();

		re_setPanelVisibility('hide');
		document.form1.what_button_was_pressed.value = "Repeating";
		document.form1.submit();
		return true;
	}
	return false;
}							


function re_validate()  
{
	var freq = document.getElementById('frequency').value;
	if ((freq != parseInt(freq)) || isNaN(freq) || parseInt(freq) <= 0){
		alert('The repetition frequency must be a positive integer.');
		return false; //frequency is NaN or less than 1
	}
	var text = document.getElementById('textarea').value;
	if (text == '' || text.match(/^\s+$/) != null){
		alert('The text field cannot be empty.');
		return false; //no text or all whitespace
	}
	if (endIsDefined && (re_prefs.startDate > re_prefs.endDate)){
		alert('The end date cannot be before the start date');
		return false; //end date is earlier or equal to start date
	}
//	alert("Valid data");
	return true;
}

function re_toggle(element, index)
{
	var thisParent = element.parentNode;
	if(thisParent.className=='radiolist'){
		if(re_prefs[thisParent.id] != index){
			var siblings = thisParent.childNodes;
			for(var i=0; i<siblings.length; i++){
				siblings[i].className = '';
			}
			element.className = 'selected';
			re_prefs[thisParent.id] = index;
		}
	} else if(element.parentNode.className=='checklist') {
		re_prefs[thisParent.id][index] = !prefs[thisParent.id][index];
		element.className = (element.className=='selected' ? '' : 'selected');
	}
	
	re_changeAction(thisParent.id, index);
}

//var re_colors = new Array('000000', 'ed1c24', 'f7941d', '39b54a', '0072bc', '92278f');
var re_colors = new Array('8f6327', 'e033d2', 'FF3300', '339900', '0072bc', '92278f');
var re_background_colors = new Array('FFFF00', 'CCFF99', 'FBCE8D', 'D3F7F7', 'FFCCFF', '99CCFF');
var re_timeframenames = new Array('year', 'month', 'week', 'day');

var oldTimeframe = 0; // to maintain the previous state since by the time re_changeAction is called, the re_prefs.timeframe value has been changed

function re_changeAction(name, value){
	switch(name){
		case 'timeframe':
			document.getElementById('frequencylabel').innerHTML = re_timeframenames[value] + ((re_prefs.frequency != 1) ? 's' : '');
			re_prefs.timeframe = value;
			re_showHideMonthStyle(value == 1);
			if (oldTimeframe == 3 && value != 3){
				// if it's NOT being changed to Day view, then if the start and end dates are the same, blank the enddate
				if (re_prefs.startDate.getTime() == re_prefs.endDate.getTime()) {
					re_clearEndDate()
				}
			}
			oldTimeframe = re_prefs.timeframe;
			break;
		case 'frequency':
			re_prefs.frequency = parseInt(value);
			document.getElementById('frequency').value = value;
			re_changeAction('timeframe', re_prefs.timeframe);
			break;
		case 'color':
			document.getElementById('textarea').style.color = '#'+re_colors[value];
			re_prefs.color = value;
			if (re_prefs.emphasis == 'H') {
				re_changeAction('emphasis', 'H');
			}
			break;
		case 'text':
			document.getElementById('textarea').value = value;
			re_prefs.text = value;
			break;
		case 'startDate':
			re_prefs.startDate = value;
			re_prefs.startDateYYMMDD = re_formatString('Y-m-d', value); /* Ben is unsure about this */
			document.getElementById('startDate').value = re_formatString('M. j, Y', value);
			
			//update monthstyle list items
			var textToWrite = re_appendOrdinalSuffix(re_formatString('j', value)) + " of the month";
			document.getElementById("monthstyle").childNodes[0].firstChild.nodeValue = textToWrite;
			var daynum = re_formatString('j', value);
			var firstOfMonth = new Date(value.valueOf());
			firstOfMonth.setDate(1);
			var weeknum = 1 + Math.floor((daynum - 1) / 7);
			textToWrite = re_appendOrdinalSuffix(weeknum)+" "+re_formatString('l', value) + " of the month";
			document.getElementById("monthstyle").childNodes[1].firstChild.nodeValue = textToWrite;
			// values to save to db for monthy repeats by day of week not date of month
			re_prefs.weeknum = weeknum - 1;
			re_prefs.dayname = re_formatString('D', value);
			break;
		case 'endDate':
			re_prefs.endDate = value;
			re_prefs.endDateYYMMDD = re_formatString('Y-m-d', value); /* Ben is unsure about this */
			endIsDefined = true;
			document.getElementById('endDate').value = re_formatString('M. j, Y', value);
			break;
		case 'endIsDefined':
			endIsDefined = value;
			document.getElementById('endDate').value = (endIsDefined ? re_formatString('M. j, Y', re_prefs.endDate) : '<none>');
			break;
		case 'emphasis':
			if (value == 'N') {
				document.getElementById('noemphasis').checked = true;
				document.getElementById('textarea').style.fontWeight = '';
				document.getElementById('textarea').style.backgroundColor = '';
				re_prefs.emphasis = 'N';
			} else if (value == 'B') {
				document.getElementById('boldemphasis').checked = true;
				document.getElementById('textarea').style.backgroundColor = '';
				re_prefs.emphasis = 'B';
				document.getElementById('textarea').style.fontWeight = 'bold';
			} else if (value == 'H') {
				document.getElementById('highlightemphasis').checked = true;
				document.getElementById('textarea').style.fontWeight = '';
				re_prefs.emphasis = 'H';
				document.getElementById('textarea').style.backgroundColor = '#'+re_background_colors[re_prefs.color];
			}
			break;
		case 'notifyenable':
			if (document.getElementById('notifyenable').checked) {
				re_prefs.notifyenable = 'Y';
			} else {
				re_prefs.notifyenable = 'N';
				re_prefs.notifyshares = 'N';
				re_prefs.notifyfriends = 'N';
				document.getElementById('notifyshares').checked = false;
				document.getElementById('notifyfriends').checked = false;
				document.getElementById('notifyfriends_editlink').style.display = "none";
			}
			break;
		case 'notifyprior':
			re_prefs.notifyprior = value;
			re_prefs.notifyenable = 'Y';
			document.getElementById('notifyenable').checked = true;
			break;
		case 'notifyhour':
			re_prefs.notifyhour = value;
			re_prefs.notifyenable = 'Y';
			document.getElementById('notifyenable').checked = true;
			break;
		case 'notifyshares':
			if (document.getElementById('notifyshares').checked) {
				re_prefs.notifyshares = 'Y';
				re_prefs.notifyenable = 'Y';
				document.getElementById('notifyenable').checked = true;
			} else {
				re_prefs.notifyshares = 'N';
			}
			break;
		case 'notifyfriends':
			if (document.getElementById('notifyfriends').checked) {
				re_prefs.notifyfriends = 'Y';
				re_prefs.notifyenable = 'Y';
				document.getElementById('notifyenable').checked = true;
				document.getElementById('notifyfriends_editlink').style.display = "";
			} else {
				re_prefs.notifyfriends = 'N';
				document.getElementById('notifyfriends_editlink').style.display = "none";
			}
			break;
		case 'image_url':
			re_prefs.image_url = value;
			document.getElementById('image_url').src =  ((re_prefs.image_url == '') ? noimagePath : re_prefs.image_url);
			break;
	}
}

function re_changeStartDateWrapper(calendar){
	re_changeAction('startDate', calendar.date);
}
function re_changeEndDateWrapper(calendar){
	re_changeAction('endDate', calendar.date);
}

function re_clearEndDate(){
	re_prefs.endIsDefined = false;
	document.getElementById('endDate').value = '<none>';
	//document.getElementById('h_endDate').value = '<none>';
	re_prefs.endDate = '<none>';
	re_prefs.endDateYYMMDD = '<none>';
	return false;
}

function re_prepareList(listID, enabledIndex)
{
	var parent = document.getElementById(listID);
	var children = parent.childNodes;
	for(var i=0; i<children.length; i++){
		re_prepareListHelper(enabledIndex, children[i], i);
	}
}
function re_prepareListHelper(enabledIndex, child, j)
{
	child.className = (enabledIndex==j) ? 'selected' : '';
	child.onclick = function(){ re_toggle(this, j); }
}


var re_monthNames = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
var re_dayNames = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

function re_format(pattern, date)
{
	switch(pattern){ //Sample: January 31, 2007
		case 'd':     // rich added to be same as php 'd'  -- 2 digit day 01 to 31 instead of 1 to 31
			return (date.getDate() < 10 ? '0' : '') + date.getDate();  
		case 'm':     // rich added to be same as php 'm'  -- 2 digit month 01 to 12 instead of 1 to 12
			return (date.getMonth() < 9 ? '0' : '') + (date.getMonth() + 1);  
		case 'n':
			return date.getMonth()+1;
			//1
		case 'M':
			return re_monthNames[date.getMonth()].substr(0,3);
			//Jan
		case 'F':
			return re_monthNames[date.getMonth()];
			//return January
		case 'j':
			return date.getDate();
			//31
		case 'w':
			return date.getDay();
			//3, because Wednesday
		case 'y':
			return (date.getFullYear()+'').substr(2,2);
			//07
		case 'Y':
			return date.getFullYear();
			//2007
		case 'l': //lowercase L
			return re_dayNames[date.getDay()];
			//Wednesday
		case 'D':
			return re_dayNames[date.getDay()].substr(0, 3);
			//Wed
		default:
			return pattern; //character is unchanged
	}
}

function re_formatString(patternString, date){
	var returnString = '';
	for(var i = 0; i < patternString.length; i++){
		returnString += re_format(patternString.charAt(i), date);
	}
	return returnString;
}

function re_setPanelVisibility(mode){
	var panelstyle = document.getElementById('re_panel').style;
	switch(mode){
		case 'show':
		case 'visible':
			/*init();*/
			panelstyle.visibility = 'visible';
			break;
		case 'hide':
		case 'hidden':
			panelstyle.visibility = 'hidden';
			break;
		case 'toggle':
			re_setPanelVisibility((panelstyle.visibility=='visible') ? 'hidden' : 'visible');
			break;
	}
//	alert( "inside 2 re_setPanelVisibility(), mode = " + mode )
	return false;
}

function display_ie_6_warning_dialog_if_needed( )  {
	// 	Determine whether to display an IE < 7 warning javascript dialog the first time a user sees the Events dialog
	//alert( document.getElementById('ie_version').value );
	if( document.getElementById('ie_version').value != "unknown"  )  {  // Is this an IE browser?
		if( document.getElementById('ie_version_major').value < 7 && document.getElementById('display_ie6_RE_warning').value == 'y'  )  {  // Is this IE less than version 7
				alert( "Since you have an out of date Microsoft Internet Explorer browser (version " + document.getElementById('ie_version').value + ")\n\r the radio buttons on the left side "
				+ "of the Event dialog do not work.  \n\rJust click on the words (Annually, Monthly, Weekly, or Daily) to select the time period." 
				+ "\n\r\n\rTo upgrade to the latest Microsoft Internet Explorer browser google using \n\rthe search words \"Microsoft ie download\"" );
				document.getElementById('display_ie6_RE_warning').value = 'n';
		}
	}
}

function re_showHideMonthStyle(show){
	document.getElementById('monthstyle_table').style.display = (show ? IE ? "block" : "table" : "none");
}

function re_appendOrdinalSuffix(num_){
	var suffix;
	var num = parseInt(num_);
	switch(num){
		case 1:
		case 21:
		case 31:
			suffix = "st";
			break;
		case 2:
		case 22:
			suffix = "nd";
			break
		case 3:
		case 23:
			suffix = "rd";
			break;
		default:
			suffix = "th";
	}
	return num+suffix;
}