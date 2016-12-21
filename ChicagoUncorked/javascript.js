
<!--- IMAGE PRELOAD SCRIPT --->

aboutus = new Image();
aboutus.src = "images/aboutus.gif";

comingup = new Image();
comingup.src = "images/comingup.gif";

reviews = new Image();
reviews.src = "images/reviews.gif";

mailinglist = new Image();
mailinglist.src = "images/mailinglist.gif";

messages = new Image();
messages.src = "images/messages.gif";

links = new Image();
links.src = "images/links.gif";

national = new Image();
national.src = "images/national.gif";

popupmailinglist = new Image();
popupmailinglist.src = "images/popupmailinglist.gif";

popupwhatsnew = new Image();
popupwhatsnew.src = "images/popupwhatsnew.gif";

<!--- END IMAGE PRELOAD SCRIPT --->



<!--- STATUS BAR SCRIPT --->

function displayHREF() {
window.defaultStatus = "Tampa Bay Wine Brats";
return true;
}

<!--- END STATUS BAR SCRIPT --->



<!--- IMAGE ROLLOVER SCRIPT --->

function MM_swapImgRestore() { //v2.0
 if (document.MM_swapImgData != null)
   for (var i=0; i<(document.MM_swapImgData.length-1); i+=2)
     document.MM_swapImgData[i].src = document.MM_swapImgData[i+1];
}

function MM_swapImage() { //v2.0
 var i,j=0,objStr,obj,swapArray=new Array,oldArray=document.MM_swapImgData;
 for (i=0; i < (MM_swapImage.arguments.length-2); i+=3) {
   objStr = MM_swapImage.arguments[(navigator.appName == 'Netscape')?i:i+1];
   if ((objStr.indexOf('document.layers[')==0 && document.layers==null) ||
       (objStr.indexOf('document.all[')   ==0 && document.all   ==null))
     objStr = 'document'+objStr.substring(objStr.lastIndexOf('.'),objStr.length);
   obj = eval(objStr);
   if (obj != null) {
     swapArray[j++] = obj;
     swapArray[j++] = (oldArray==null || oldArray[j-1]!=obj)?obj.src:oldArray[j];
     obj.src = MM_swapImage.arguments[i+2];
 } }
 document.MM_swapImgData = swapArray; //used for restore
}

<!--- END IMAGE ROLLOVER SCRIPT --->



<!--- SHOW/HIDE LAYERS SCRIPT --->

function MM_showHideLayers() { //v2.0
 var i, visStr, args, theObj;
 args = MM_showHideLayers.arguments;
 for (i=0; i<(args.length-2); i+=3) { //with arg triples (objNS,objIE,visStr)
   visStr   = args[i+2];
   if (navigator.appName == 'Netscape' && document.layers != null) {
     theObj = eval(args[i]);
     if (theObj) theObj.visibility = visStr;
   } else if (document.all != null) { //IE
     if (visStr == 'show') visStr = 'visible'; //convert vals
     if (visStr == 'hide') visStr = 'hidden';
     theObj = eval(args[i+1]);
     if (theObj) theObj.style.visibility = visStr;
 } }
}

<!--- END SHOW/HIDE LAYERS SCRIPT --->



<!--- POP-UP WINDOW SCRIPT --->

function displayWindow(url, width, height) {
var Win = window.open(url,"displayWindow",'width=' + width + ',height=' + height + ',resizable=no,scrollbars=yes,menubar=no,status=no,top=0,left=0');
self.name = "main";
}

<!--- END POP-UP WINDOW SCRIPT --->



<!--- OUTSIDE URL POP-UP WINDOW SCRIPT --->

function launchWindow(theURL) {
winSpecs = 'top=0,left=0,toolbar=yes,scrollbars=yes,status=no,width=' + eval(screen.availWidth - 10) + ',height=' + eval(screen.availHeight - 75);
openIt = window.open(theURL, 'theWindow', winSpecs);
openIt.focus();
}

<!--- END OUTSIDE URL POP-UP WINDOW SCRIPT --->



<!--- VALIDATE WINE SEARCH SCRIPT --->

function openWineSearchWin(theForm) {
	submitIt = true;
	checkWineSearch(theForm);
	if (submitIt) { 
		window.open('', 'WineSearch', 'top=0,left=0,toolbar=yes,scrollbars=yes,status=no,width=' + eval(screen.availWidth - 10) + ',height=' + eval(screen.availHeight - 75));
		theForm.target = 'WineSearch';
		theForm.action = "winesearch.cfm";
		theForm.submit();
	}
}

function checkWineSearch(theForm) {
	if (theForm.RE.value == "") {
		theForm.RE.focus();
		alert("Please enter an address.");
		submitIt = false;
	}
	if (theForm.RT.value == "") {
		theForm.RT.focus();
		alert("Please enter a city.");
		submitIt = false;
	}
}

<!--- END VALIDATE WINE SEARCH SCRIPT --->



<!--- FRAME BUSTER SCRIPT --->

//if (top == self) {
	//if(top != "mailinglistremove.cfm") {
	//	top.location.href = 'http://tampa.winebrats.org';
	//}
//}

<!--- END FRAME BUSTER SCRIPT ---> 
