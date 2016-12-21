//UDMv3.5
//**DO NOT EDIT THIS *****
if (!exclude) { //********
//************************



///////////////////////////////////////////////////////////////////////////
//
//  ULTIMATE DROPDOWN MENU VERSION 3.5 by Brothercake
//  This is a special version for Dynamic Drive (http://www.dynamicdrive.com)
//
//  Link-wrapping routine by Brendan Armstrong
//  Original KDE modifications by David Joham
//  Opera reload/resize based on a routine by Michael Wallner
//  Select-element hiding routine by Huy Do
//
///////////////////////////////////////////////////////////////////////////



// *** POSITIONING AND STYLES *********************************************



var menuALIGN = "left";		// alignment
var absLEFT = 	50;		// absolute left or right position (if menu is left or right aligned)
var absTOP = 	233; 		// absolute top position

var staticMENU = false;		// static positioning mode (ie5,ie6 and ns4 only)

var stretchMENU = false;		// show empty cells
var showBORDERS = false;		// show empty cell borders

var baseHREF = "/PrivateLabel/COLCOA/images/";	// base path to .js files for the script (ie: resources/)
var zORDER = 	1000;		// base z-order of nav structure (not ns4)

var mCOLOR = 	"#94171e";	// main nav cell color
var rCOLOR = 	"#eeeeee";	// main nav cell rollover color
var bSIZE = 	0;		// main nav border size
var bCOLOR = 	"#cccccc"	// main nav border color
var aLINK = 	"#ffffff";	// main nav link color
var aHOVER = 	"#cc0000";		// main nav link hover-color (dual purpose)
var aDEC = 	"none";		// main nav link decoration
var fFONT = 	"arial";	// main nav font face
var fSIZE = 	12;		// main nav font size (pixels)
var fWEIGHT = 	""		// main nav font weight
var tINDENT = 	0;		// main nav text indent (if text is left or right aligned)
var vPADDING = 	0;		// main nav vertical cell padding
var vtOFFSET = 	0;		// main nav vertical text offset (+/- pixels from middle)

var keepLIT =	true;		// keep rollover color when browsing menu
var vOFFSET = 	5;		// shift the submenus vertically
var hOFFSET = 	4;		// shift the submenus horizontally

var smCOLOR = 	"#94171e";	// submenu cell color
var srCOLOR = 	"#eeeeee";	// submenu cell rollover color
var sbSIZE = 	1;		// submenu border size
var sbCOLOR = 	"#D1545B"	// submenu border color
var saLINK = 	"#ffffff";	// submenu link color
var saHOVER = 	"#cc0000";		// submenu link hover-color (dual purpose)
var saDEC = 	"none";		// submenu link decoration
var sfFONT = 	"arial";	// submenu font face
var sfSIZE = 	12;			// submenu font size (pixels)
var sfWEIGHT = 	"normal"	// submenu font weight
var stINDENT = 	3;		// submenu text indent (if text is left or right aligned)
var svPADDING = 0;		// submenu vertical cell padding
var svtOFFSET = 0;		// submenu vertical text offset (+/- pixels from middle)

var shSIZE =	0;		// submenu drop shadow size
var shCOLOR =	"#eeeeee";	// submenu drop shadow color
var shOPACITY = 60;		// submenu drop shadow opacity (not ie4,ns4 or opera)

var keepSubLIT = true;		// keep submenu rollover color when browsing child menu
var chvOFFSET = -12;		// shift the child menus vertically
var chhOFFSET = 7;		// shift the child menus horizontally

var openTIMER = 10;		// [** new **] menu opening delay time (not ns4/op5/op6)
var openChildTIMER = 20;	// [** new **] child-menu opening delay time (not ns4/op5/op6)
var closeTIMER = 330;		// menu closing delay time

var cellCLICK = true;		// links activate on TD click
var aCURSOR = "hand";		// cursor for active links (not ns4 or opera)

var altDISPLAY = "";		// where to display alt text
var allowRESIZE = mu;		// allow resize/reload

var redGRID = false;		// show a red grid
var gridWIDTH = 760;		// override grid width
var gridHEIGHT = 500;		// override grid height
var documentWIDTH = 0;		// override document width

var hideSELECT = false;		// auto-hide select boxes when menus open (ie only)
var allowForSCALING = false;	// allow for text scaling in gecko browsers
var allowPRINTING = false;	// allow the navbar and menus to print (not ns4)

var arrWIDTH = 13;		// [** new **] arrow width (not ns4/op5/op6)
var arrHEIGHT = 13;		// [** new **] arrow height (not ns4/op5/op6)

var arrHOFFSET = -1;		// [** new **] arrow horizontal offset (not ns4/op5/op6)
var arrVOFFSET = -3;		// [** new **] arrow vertical offset (not ns4/op5/op6)
var arrVALIGN = "middle";	// [** new **] arrow vertical align (not ns4/op5/op6)

var arrLEFT = "<";		// [** new **] left arrow (not ns4/op5/op6)
var arrRIGHT = "<img src=/PrivateLabel/COLCOA/images/arrow_strait.gif>";		// [** new **] right arrow (not ns4/op5/op6)



//** LINKS ***********************************************************



addMainItem("http://colcoa.org/site/program/index.asp","PROGRAM",75,"center","","",0,0,"","","","","");

	defineSubmenuProperties(135,"left","left",-6,-5,"","","","","","","");

	
addMainItem("#","INFO",45,"center","","",0,0,"","","","","");

	defineSubmenuProperties(140,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("http://colcoa.org/site/info/location.asp","Location","","");
	addSubmenuItem("http://colcoa.org/site/info/tickets.asp","Tickets","","");
	addSubmenuItem("http://colcoa.org/site/info/audience_choice.asp","Audience Choice Award","","");
	addSubmenuItem("http://colcoa.org/site/links/index.asp","Friends","","");


addMainItem("#","SPECIAL EVENTS",115,"center","","",0,0,"","","","","");

	defineSubmenuProperties(155,"left","left",-6,-5,"","","","","","","");
	
	addSubmenuItem("http://colcoa.org/site/happy_hours/index.asp","Happy Hour Talks","","");
	addSubmenuItem("http://colcoa.org/site/events/film_noir.asp","Film Noir night","","");
	addSubmenuItem("http://colcoa.org/site/events/crepes.asp","Crêpes en Ville","","");
	addSubmenuItem("http://colcoa.org/site/events/sunday.asp","COLCOA Sunday Special","","");






addMainItem("#","PRESS",60,"center","","",0,0,"","","","","");

	defineSubmenuProperties(120,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("http://colcoa.org/site/press/fest_reviews.asp","Festival Reviews","","");
	addSubmenuItem("http://colcoa.org/site/press/film_reviews.asp","Film Reviews","","");
	addSubmenuItem("http://colcoa.org/site/press/press_releases.asp","Press Release","","");
	addSubmenuItem("http://colcoa.org/site/press/stills.asp","Film Stills","","");


addMainItem("http://colcoa.org/site/sponsors/index.asp","SPONSORS",86,"center","","",0,0,"","","","","");

	defineSubmenuProperties(135,"left","left",-6,-5,"","","","","","","");



addMainItem("http://colcoa.org/site/livre_dor/index.asp","LIVRE D'OR",86,"center","","",0,0,"","","","","");

	defineSubmenuProperties(135,"left","left",-6,-5,"","","","","","","");



addMainItem("#","PHOTOS",70,"center","","",0,0,"","","","","");

	defineSubmenuProperties(90,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("#","Coming Soon...","","");





addMainItem("http://colcoa.org/site/about/index.asp","ABOUT COLCOA",110,"center","","",0,0,"","","","","");

	defineSubmenuProperties(185,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("http://colcoa.org/site/about/last10years.asp","Last 10 Years","","");
	addSubmenuItem("http://colcoa.org/site/about/culture.asp","Franco-American Cultural Fund","","");
	addSubmenuItem("http://colcoa.org/site/about/staff.asp","Staff","","");
	addSubmenuItem("http://colcoa.org/site/about/archive.asp","Archive","","");


addMainItem("http://colcoa.org/site/contact/index.asp","CONTACT US",85,"center","","",0,0,"","","","","");

	defineSubmenuProperties(85,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("http://colcoa.org/site/contact/Volunteerapp2007.doc","Volunteer","_blank","");



//**DO NOT EDIT THIS *****
}//***********************
//************************
