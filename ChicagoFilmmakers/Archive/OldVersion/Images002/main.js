n01off = new Image(51, 21);
n01off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_home_off.gif";
n02off = new Image(53, 21);
n02off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_films_off.gif";
n03off = new Image(60, 21);
n03off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_events_off.gif";
n04off = new Image(63, 21);
n04off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_tickets_off.gif";
n05off = new Image(89, 21);
n05off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_membership_off.gif";
n06off = new Image(75, 21);
n06off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_sponsors_off.gif";
n07off = new Image(61, 21);
n07off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_venues_off.gif";
n08off = new Image(59, 21);
n08off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_travel_off.gif";
n09off = new Image(54, 21);
n09off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_media_off.gif";
n10off = new Image(71, 21);
n10off.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_about_off.gif";

n01on = new Image(51, 21);
n01on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_home_on.gif";
n02on = new Image(53, 21);
n02on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_films_on.gif";
n03on = new Image(60, 21);
n03on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_events_on.gif";
n04on = new Image(63, 21);
n04on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_tickets_on.gif";
n05on = new Image(89, 21);
n05on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_membership_on.gif";
n06on = new Image(75, 21);
n06on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_sponsors_on.gif";
n07on = new Image(61, 21);
n07on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_venues_on.gif";
n08on = new Image(59, 21);
n08on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_travel_on.gif";
n09on = new Image(54, 21);
n09on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_media_on.gif";
n10on = new Image(71, 21);
n10on.src = "http://www.tix.com/PrivateLabel/ChicagoFilmmakers/Images/nav_about_on.gif";

function img_act(v) {
	document[v].src = eval(v + "on.src");
}
function img_inact(v) {
	document[v].src = eval(v + "off.src");
}
var flash6 = false;
var flash7 = false;
var flash8 = false;
if (((navigator.appName == "Netscape") && (parseFloat(navigator.appVersion) >= 4) && navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"] && navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin)) {
	if (navigator.plugins['Shockwave Flash'].description.indexOf("6.") != -1) flash6 = true;
	if (navigator.plugins['Shockwave Flash'].description.indexOf("7.") != -1) flash7 = true;
	if (navigator.plugins['Shockwave Flash'].description.indexOf("8.") != -1) flash8 = true;
}
else if ( (navigator.userAgent) && (navigator.userAgent.indexOf("MSIE") >= 0) && (navigator.appVersion.toLowerCase().indexOf("win") != -1) ) {
	document.write('<script language=VBScript>');
	document.write('on error resume next \n');
	document.write('flash6 = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.6"))) \n');
	document.write('flash7 = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.7"))) \n');
	document.write('flash8 = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.8"))) \n');
	document.write('<\/script>');
}
//flash6 = false;
//flash7 = false;
//flash8 = false;
