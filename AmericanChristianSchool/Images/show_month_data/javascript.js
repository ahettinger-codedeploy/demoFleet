var prefs;
var IE = false; //may later be overridden by conditionally included ie-rollover.js
var firstRun = true;
var ignoreNextToggle = false;

function generateRequest(){
	var string = '../calendar/printpdf.php?';
	var headerText = (prefs.otherprefs[1] ? escape(document.getElementById('headertext').value) : '');
	var footerText = (prefs.otherprefs[2] ? escape(document.getElementById('footertext').value) : '');
	
	var dates;
	if(mode == 'Year'){
		dates = '0';
	} else if(mode == 'Month'){
		dates = encodeArray(prefs.dates, -month+1);
	} else {
		dates = encodeArray(prefs.dates, -5);
	}
	/*if(prefs.yearonapage[0]){
		dates = '0';
	} else {
		dates = encodeArray(prefs.dates, (mode=="Month") ? -month+1 : -5);
	}*/
	
	var args = new Array('basedate='+year+'-'+month+'-'+day,
						 'dates='+dates,
						 'i='+peopleid,
						 //'layout='+(prefs.yearonapage[0] ? 'Year' : mode)+prefs.layout,
						 'layout='+mode+prefs.layout,
						 'font='+prefs.font,
						 'size='+prefs.size,
						 'calendartable='+calendartable,
						 'customtitle='+headerText,
						 'footer='+footerText,
						 'portrait='+(new Number(prefs.portrait)),
						 'blackandwhite='+(new Number(prefs.otherprefs[0])));
	if(mode != 'Day'){
		args.push('includeWeekends='+(new Number(prefs.otherprefs[3])));
		$betaNum=4;
	} else {
		args.push('includeWeekends=1');
		$betaNum=3;
	}
	if (prefs.otherprefs[$betaNum] > 0)
		args.push('pdftype=tcpdf');
	else
		args.push('pdftype=oldpdf');
	string += args.join('&');
	return string;
}

function init()
{	
	var listDefaultIndex = (mode=="Month") ? month-1 : 5;
	
	if(typeof prefs == "undefined"){ //First run
		prefs = new Object();
		for(each in storedPrefs){
			prefs[each] = storedPrefs[each];
		}
	}
	
	prefs.dates = new Array();
	for(var i=0; i<12; i++){
		prefs.dates[i] = (i==listDefaultIndex);
	}
	if(!document.getElementById('dates').hasChildNodes()) fillDatePicker((mode=="Month") ? 0 : 5);
	
	/* Fill in values */
	
	prepareYearPicker();
	
	prepareList('dates', listDefaultIndex);
	var otherprefsEnabledIndices = new Array();
	for(var i=0; i<prefs.otherprefs.length; i++){
		if(prefs.otherprefs[i]){
			otherprefsEnabledIndices.push(i);
		}
	}
	prepareList('otherprefs', otherprefsEnabledIndices); //TODO
	if(mode=='Month' || mode=='Year'){
		prepareList('yearonapage', new Array());
	}
	
	var g = new Array('layout', 'font', 'size', 'portrait');
	for(var i=0; i<g.length; i++){
		prepareList(g[i], prefs[g[i]]);
	}
	
	if(!prefs.otherprefs[1]) document.getElementById('headertext').setAttribute('disabled', 'disabled');
	document.getElementById('headertext').value = customtitle;
	if(!prefs.otherprefs[2]) document.getElementById('footertext').setAttribute('disabled', 'disabled');
	document.getElementById('footertext').value = prefs.footertext;
	
	if(IE){
		fixIErollover();
	}
	
	changePreview();
	
	setYearOnAPageListState();
	
	if(!IE){
	
		document.getElementById('panel-scroller').addEventListener(
			'click',
			function(evt){
				setPanelVisibility('hidden');
				},
			false);
			
		document.getElementById('panel').addEventListener(
			'click',
			function(evt){
				if(!evt) var evt = window.event;
				evt.cancelBubble = true;
				if(evt.stopPropagation) evt.stopPropagation();
				},
			false);
		
	}
	
	keepDialogInScreen();
	
}

function validateAndGo(){
	if(validateDates()){
		var winObject = window.open(generateRequest(), 'pdfwindow');
		if(winObject==null){
			window.alert("Your web browser blocked the pop-up\nthat contains your printable Calendar.\n\nPlease turn off pop-up blocking for\nkeepandshare.com to fix this.");
		} else {
			setPanelVisibility('hide');
		}
	} else {
		window.alert("Please select at least one date to print\nfrom the list to the left.");
	}
	return false;
}							
function validateDates(){
	for(var i=0; i<prefs.dates.length; i++){
		if (prefs.dates[i]){
			return true;
		}
	}
	return false;
}

function changePreview(){

	document.getElementById('previewInner').style.background = "url(/pdf/dialog/images/thumbs_"+mode+".gif) no-repeat";
	
	var combinations;
	switch(mode){
		case 'Year':
			combinations = [1,1,1,2];
			break;
		case 'Month':
			combinations = [2,4,4,2];
			break;
		case 'Week':
			combinations = [2,4,4,2];
			break;
		case 'Day':
			combinations = [2,4,4,2];
			break;
	}
	
	var numCombinations = reduce(function(x,y){return x*y;}, combinations, 1, true);
	var prevItem = numCombinations;
	var posComponents = new Array(combinations.length);
	
	userChoices = [prefs.layout, prefs.font, prefs.size, prefs.portrait];
	if(mode == "Year"){
		userChoices = [0,0,0,prefs.portrait];
	}
	
	for(var i=0; i<combinations.length; i++){
		prevItem = prevItem / combinations[i];
		posComponents[i] = prevItem * userChoices[i];
	}
	
	canvas = document.getElementById('previewInner');
	clippedWidth = canvas.clientWidth;
	clippedHeight = canvas.clientHeight;
	
	var distance = clippedHeight * reduce(function(x,y){return x+y;},
										  posComponents,
										  0,
										  true);
	
	canvas.style.backgroundPosition = '0 -' + distance + 'px';
	
	/*var usePortraitSheet = (mode=="Month" && prefs.portrait)
							|| (mode=="Day" && prefs.layout==0);*/
	
	var previewSheet = document.getElementById('previewSheet');
	previewSheet.style.backgroundPosition = '0 ' + (prefs.portrait ? '0' : '-300px');
	
	/*var newX = prefs.font*clippedWidth;
	var newY = prefs.layout*clippedHeight;
	canvas.style.backgroundPosition = '-'+newX+'px -'+newY+'px';*/
	
}

function toggle(element, index)
{
	if(element.getAttribute('disabled') != null && element.getAttribute('disabled') != false){ //IE hack
		return;
	}
	
	var thisParent = element.parentNode;
	
	if(thisParent.id=='otherprefs' && ignoreNextToggle/* && prefs.otherprefs[2]*/){
		//alert('ignoring this toggle');
		ignoreNextToggle = false;
		//alert('set ignoreNextToggle to false just now');
		return;
	}
	
	//ignoreNextToggle = false;
	
	if(thisParent.className=='radiolist1'){
		if(prefs[thisParent.id] != index){
			var siblings = thisParent.childNodes;
			for(var i=0; i<siblings.length; i++){
				siblings[i].className = '';
			}
			element.className = 'selected';
			prefs[thisParent.id] = index;
		}
	} else if(element.parentNode.className=='checklist1') {
		prefs[thisParent.id][index] = !prefs[thisParent.id][index];
		element.className = (/*element.className=='selected'*/ /selected/.test(element.className) ? '' : 'selected');
	}
	
	if(thisParent.id=='otherprefs'){
		
		var isEnabled = prefs.otherprefs[index];
		
		if(isEnabled){
			element.getElementsByTagName('input')[0].removeAttribute('disabled');
		} else {
			element.getElementsByTagName('input')[0].setAttribute('disabled', 'disabled');
		}
	}
	
	if(thisParent.id=='yearonapage'){
		
		if(prefs.yearonapage[0]){
			mode = 'Year';
		} else {
			mode = 'Month';
		}
		
		setYearOnAPageListState();
		
	}
	
	if(thisParent.id=='layout' || thisParent.id=='font' || thisParent.id=='portrait' || thisParent.id=='size' || thisParent.id == 'yearonapage'){
		changePreview();
	}
}

/*function blockEventHandler(evt){
	evt.stopPropagation();
	return false;
}*/

function prepareList(listID, enabledIndices)
{
	if(enabledIndices == null){
		enabledIndices = new Array();
	} else if(typeof enabledIndices != 'object'){
		/*var value = enabledIndices;
		enabledIndices = new Array(1);
		enabledIndices[0] = value;*/
		enabledIndices = [enabledIndices];
	}
	
	var parent = document.getElementById(listID);
	try{
		var children = parent.childNodes;
	} catch (e){
		alert("Exception caught:\nlistID = "+listID+"\nenabledIndices = "+enabledIndices.toString()+"\nparent = "+parent + "\nexception = "+e);
	}
	for(var i=0; i<children.length; i++){
		prepareListHelper(enabledIndices, children[i], i);
	}
}
function prepareListHelper(enabledIndices, child, j)
{
	if(enabledIndices.length != 0){
		var equal = function(x){ return x==j;};
		var or = function(x,y) { return x || y; };
		
		var isEnabled = reduce(or, map(equal, enabledIndices), false, false);

		child.className = (isEnabled) ? 'selected' : '';
	}
	
	child.onclick = function(){ toggle(this, j); }
}

function fillDatePicker(baseTSOffset)
{
	if(mode == 'Month' || mode == 'Year'){
		var baseTimestamp = new Date(year, 0, 1, 0, 0, 0);
	} else {
		var baseTimestamp = new Date(year, month-1, day, 0, 0, 0);
	}

	var list = document.getElementById('dates'); //<ol>
	for(i=0; i<12; i++){
		var offsetTimestamp = getOffsetDate(baseTimestamp, i-baseTSOffset, mode);
		var text = getText(i, offsetTimestamp);
		var textNode = document.createTextNode(text);
		var li = document.createElement('li');
		li.appendChild(textNode);
		list.appendChild(li);
	}
}

function getText(listIndex, date)
{
	switch (mode.toLowerCase()){
		case 'year':
		case 'month':
			if (date.getMonth()==0 || date.getMonth()==11 || listIndex==0 || listIndex==36-1){
				//return "F 'y";
				return format('F',date)+" '"+format('y',date);
			} else {
				return format('F',date);
			}
		case 'week':
			variableWeekStart = (format('w',date) - weekStartOffset) % 7;
			wbegin = getOffsetDate(date, -variableWeekStart, 'day');
			wend = getOffsetDate(date, 6-variableWeekStart, 'day');
			if (wbegin.getMonth() != wend.getMonth()){ //different month
				return format('M',wbegin)+' '+format('j',wbegin)+' - '+format('M',wend)+' '+format('j',wend);
			} else { //same month
				return format('M',wbegin)+' '+format('j',wbegin)+'-'+format('j',wend);
			}
		case 'day':
			return format('F',date)+' '+format('j',date);
	}
}

var monthNames = new Array('January','February','March','April','May','June','July','August','September','October','November','December');

function format(pattern, date)
{
	switch(pattern){ //Sample: January 31, 2007
		case 'n':
			return date.getMonth()+1;
			//1
		case 'M':
			return monthNames[date.getMonth()].substr(0,3);
			//Jan
		case 'F':
			return monthNames[date.getMonth()];
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
	}
}

function getOffsetDate(timestamp, offset, offsetUnit)
{
	var month = timestamp.getMonth();
	var year = timestamp.getFullYear();
	var date = timestamp.getDate();
	switch (offsetUnit.toLowerCase()){
		case 'year':
		case 'month':
			month += offset;
			date = 1;
			break;
		case 'week':
			date += 7*offset;
			break;
		case 'day':
			date += offset;
			break;
	}
	return new Date(year, month, date, 0, 0, 0);
}

function encodeArray(array, indexOfFirstItem){
	var result = '';
	for (var i=0; i<array.length; i++){
		if (array[i]){
			if (result.length>0) {
				result += ',';
			}
			result += (i+indexOfFirstItem);
		}
	}
	return result;
}

function setPanelVisibility(mode){
	var panelstyle = document.getElementById('panel-scroller').style;
	switch(mode){
		case 'show':
		case 'visible':
			//setCalendarOverflow('hidden');
			init();
			panelstyle.visibility = 'visible';
			break;
		case 'hide':
		case 'hidden':
			//setCalendarOverflow('auto');
			panelstyle.visibility = 'hidden';
			break;
		case 'toggle':
			setPanelVisibility((panelstyle.visibility=='visible') ? 'hidden' : 'visible');
			break;
	}
	return false;
}

function setCalendarOverflow(newState){
	var ua = navigator.userAgent;
	if(ua.indexOf('Firefox') != -1 && ua.indexOf('Macintosh') != -1){
		var tas = document.getElementsByTagName('textarea');
		for(i=0; i<tas.length; i++){
			if(tas[i].id == "ta"){
				tas[i].style.overflow = newState;
			}
		}
	}
}

function setYear(){
	var select = document.getElementById('yearpicker');
	year = select.options[select.selectedIndex].text;
	datelist = document.getElementById('dates');
	while(datelist.hasChildNodes()){
		datelist.removeChild(datelist.firstChild);
	}
	fillDatePicker(0);
	prepareList('dates', null);
	for(var i = 0; i < 12; i++){
		prefs.dates[i] = false;
	}
}

function prepareYearPicker(){
	if(mode != 'Month' && mode != 'Year' && document.getElementById('yearspecific')) {
		document.getElementById('col1').removeChild(document.getElementById('yearspecific'));
	}
	if(mode != 'Month' && mode != 'Year'){
		return;
	}
	var select = document.getElementById('yearpicker');
	if(select.hasChildNodes()) {
		while(select.hasChildNodes()){
			select.removeChild(select.firstChild);
		}
	}
	var d = new Date(year, 0, 1, 0, 0, 0);
	var startYear = parseInt(d.getFullYear()) - 3;
	var endYear = startYear + 8;
	for(var i = startYear; i < endYear; i++){
		var option = document.createElement('option');
		var text = document.createTextNode(i);
		option.appendChild(text);
		select.appendChild(option);
	}
	setTimeout(function(){select.selectedIndex = year - startYear; }, 0); //to avoid Opera 9.25 bug
//	select.selectedIndex = year - 2006;
}

function selectAllYears(){
	var liNodes = document.getElementById('dates').childNodes;
	for(var i=0; i<prefs.dates.length; i++){
		prefs.dates[i] = true;
		liNodes[i].className = 'selected';
	}
	return false;
}

function setYearOnAPageListState(){
	
	if(mode == 'Year' || mode == 'Month'){
	
		var divs = ['yearspecific', 'dates'];
		
		var a = document.getElementById('dates').getElementsByTagName('li');
		var b = document.getElementById('yearselectall');
		var c = document.getElementById('yearpicker');
		
		var elts = convertNodelistToArray(a).concat([b, c]);
		
		for(var i = 0; i < elts.length; i++){
			var element = elts[i];
			
			if(mode == 'Year'){ //disabling
				element.setAttribute('disabled', 'disabled');
				element.className += " panel-disabled";
			} else {
				element.removeAttribute('disabled');
				element.className = element.className.replace(/\s*panel-disabled\s*/, '');
			}	
		}
	}
}

function keepDialogInScreen(){
	var screenwidth = ( IE ? document.body.clientWidth : window.innerWidth);
	var screenheight = ( IE ? document.body.clientHeight : window.innerHeight);
	
	var panel = document.getElementById('panel');
	
	var panelheight = panel.scrollHeight;
	var panelwidth = panel.scrollWidth;
	
	var panelx = panel.offsetLeft;
	var panely = panel.offsetTop;
	
	if(panelheight > screenheight){ //dialog taller than window
		//alertstr += 'Dialog taller than window';
		panel.style.top = 0;
	} else if(panely + panelheight > screenheight){ //dialog overflows due to top margin
		//alertstr += 'Top margin causes overflow';
		panel.style.top = screenheight - panelheight;
	} else { //does not overflow
		//alertstr += 'Does not overflow';
	}
	
//	var alertstr = 'screenwidth = '+screenwidth+'\npanelwidth = '+panelwidth+'\npanelx = '+panelx+'\n\n';
	
	if(panelwidth > screenwidth){ //dialog taller than window
//		alertstr += 'Dialog wider than window';
		panel.style.left = 0;
	} else if(panelx + panelwidth > screenwidth){ //dialog overflows due to top margin
//		alertstr += 'Left margin causes overflow';
		panel.style.left = screenwidth - panelwidth;
	} else { //does not overflow
//		alertstr += 'Does not overflow';
	}
	
//	alert(alertstr);
}

function cancel(){
	prefs = undefined;
	setPanelVisibility("hide");
	return false;
}

function reduce(func, array, base, startLeft){
	var length = array.length;
	var result = base;
	for(var i = 0; i<length; i++){
		if(startLeft){
			result = func(result, array[i]);
		} else {
			result = func(array[length-1-i], result);
		}
	}
	return result;
}

function map(func, array){
	var result = new Array(array.length);
	for(var i=0; i<array.length; i++){
		result[i] = func(array[i]);
	}
	return result;
}

/* Shamelessly inspired by Simon Willison
 * http://simonwillison.net/2004/May/26/addLoadEvent
 */
function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
	window.onload = func;
  } else {
	window.onload = function() {
	  if (oldonload) {
		oldonload();
	  }
	  func();
	}
  }
}

function preloadPreview(){
	addLoadEvent(	function(){
						var buffer = new Image();
						buffer.src = "/pdf/dialog/images/thumbs_"+mode+".gif";
					}
				);
}

function convertNodelistToArray(nl){
	var result = new Array();
	
	for(var i = 0, length = nl.length; i < length; i++){
		result.push(nl[i]);
	}
	
	return result;
}
