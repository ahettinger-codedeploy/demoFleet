<!-- Begin VIEWER OPTIONS CODE

//  use only lowercase on options



// IMAGE VIEWER OPTIONS

var viewer 		= "popup"	// OPTIONS: | new | popup | same | New browser or a popup
var width 		= "700"		// WIDTH OF THE POPUP
var height 		= "575"		// HEIGHT OF THE POPUP
var scrollbars		= "yes"		// SHOW SCROLLBARS IN POPUP - yes OR no
var menu		= "no"		// SHOW MENU IN POPUP - yes OR no
var tool		= "no"		// SHOW TOOLBAR IN POPUP - yes OR no



// SLIDESHOW OPTIONS

var SS_viewer	 	= "no"		// yes/FULL BROWSER OR no/POPUP MODE
var SS_width 		= "700"		// SLIDESHOW WIDTH
var SS_height 		= "575"		// SLIDESHOW HEIGHT
var SS_scrollbars 	= "0"		// TURN ON POPUP SCROLLBARS "1" FOR ON "0" FOR OFF



// COPYRIGHT 2008 © Allwebco Design Corporation
// Unauthorized use or sale of this script is strictly prohibited by law

// YOU DO NOT NEED TO EDIT BELOW THIS LINE






// START IMAGE VIEW CODE

function ViewImage(data) {
   if (viewer == "popup") {
    windowHandle = window.open('image-viewer.htm' + '?' + data,'windowName',',scrollbars='+scrollbars+',resizable=yes,toolbar='+tool+',menubar='+menu+',width='+width+',height='+height+'');

}
else if (viewer == "new") {
    windowHandle = window.open('image-viewer.htm' + '?' + data,'windowName');
}
else if (viewer == "same") {
    window.location = ('image-viewer.htm' + '?' + data);
}
}

// END IMAGE VIEW CODE








// START SLIDESHOW POPUP CODE




function popUpSlideshow(URL) {
day = new Date();
id = day.getTime();
   if (SS_viewer == "no") {
eval("page" + id + " = window.open(URL, '" + id + "', 'toolbar=0,scrollbars='+SS_scrollbars+',location=0,statusbar=0,menubar=0,resizable=1,width='+SS_width+',height='+SS_height+'');");
}
else 
if (viewer == "yes") {
eval("page" + id + " = window.open(URL);");
}
}











// START menu_gallery.js IE FULL SCREEN

function fullScreen() {
  window.open(location.href,'fullscreen','fullscreen,scrollbars')
}





//  End -->