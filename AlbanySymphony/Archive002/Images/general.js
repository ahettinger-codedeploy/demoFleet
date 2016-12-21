//<!--- *************** Clear Keyword *************** --->
function clearKeyword(formPath, keyword){
	if (formPath.value == keyword) {
		formPath.value = "";
	}
};;

//<!--- *************** Popup Window *************** --->
var popupWin;
function openWin(windowURL,windowName,wit,hite,scroll) { 
	var winH = (screen.height - hite) / 2;
	var winW = (screen.width - wit) / 2;
	popupWin = window.open( windowURL, windowName, "menubar=no,status=no,toolbar=no,location=no,scrollbars="+scroll+",screenx=1,screeny=1,width=" + wit + ",height=" + hite + ",top="+winH+",left="+winW);
	popupWin.focus();
};;

//<!--- *************** FORM BUTTON roll-over styles *************** --->
function hov(loc,cls){
  		if(loc.className)
     		loc.className=cls;
};;
