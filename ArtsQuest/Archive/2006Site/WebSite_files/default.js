<!--

/* ******************** */
/* MACROMEDIA */

function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}
function changeImagesArray(array) {
	if (document.images && (preloadFlag == true)) {
		for (var i=0; i<array.length; i+=2) {
			document[array[i]].src = array[i+1];
		}
	}
}
function changeImages() {
	changeImagesArray(changeImages.arguments);
}
function toggleImages() {
	for (var i=0; i<toggleImages.arguments.length; i+=2) {
		if (selected == toggleImages.arguments[i])      changeImagesArray(toggleImages.arguments[i+1]);
	}
}
var selected = '';
var preloadFlag = false;
function preloadImages() {
	if (document.images) {
		nav_mymusikfest_over = newImage("images/navigation/nav_mymusikfest_over.gif");
		nav_ticketsevents_over = newImage("images/navigation/nav_ticketsevents_over.gif");
		nav_about_over = newImage("images/navigation/nav_about_over.gif");
		nav_sponsors_over = newImage("images/navigation/nav_sponsors_over.gif");
		nav_volunteers_over = newImage("images/navigation/nav_volunteers_over.gif");
		nav_merch_over = newImage("images/navigation/nav_merch_over.gif");
		nav_contact_over = newImage("images/navigation/nav_contact_over.gif");
		gi_nav_performers_over = newImage("images/frontpage/gi_nav_performers_over.jpg");
		gi_nav_artists_over = newImage("images/frontpage/gi_nav_artists_over.gif");
		gi_nav_food_over = newImage("images/frontpage/gi_nav_food_over.gif");
		gi_nav_retailers_over = newImage("images/frontpage/gi_nav_retailers_over.gif");
		preloadFlag = true;
	}
}
function MM_jumpMenu(targ,selObj,restore){ //v3.0
	eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
	if (restore) selObj.selectedIndex=0;
}


/* ******************** */
/* FUNCTIONS */

// Confirms an action, return boolen
function isSure ()
{
	return confirm("Are you sure you'd like to do this?");
}

// Pops up a centered window
function popupWindow (passed_url, passed_width, passed_height)
{
	window.open(passed_url, "", "left="+((screen.width/2)-(passed_width/2))+",top="+((screen.height/2)-(passed_height/2))+",width="+passed_width+",height="+passed_height+",scrollbars=yes,resizable=yes");
}

// -->