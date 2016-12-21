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
var absLEFT = 	15;		// absolute left or right position (if menu is left or right aligned)
var absTOP = 	233; 		// absolute top position

var staticMENU = false;		// static positioning mode (ie5,ie6 and ns4 only)

var stretchMENU = false;		// show empty cells
var showBORDERS = false;		// show empty cell borders

var baseHREF = "Images/";	// base path to .js files for the script (ie: resources/)
var zORDER = 	1000;		// base z-order of nav structure (not ns4)

var mCOLOR = 	"#740500";	// main nav cell color
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

var smCOLOR = 	"#740500";	// submenu cell color
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
var arrRIGHT = "<img src=Images/arrow_strait.gif>";		// [** new **] right arrow (not ns4/op5/op6)



//** LINKS ***********************************************************





	
addMainItem("#","INFO",40,"center","","",0,0,"","","","","");

	defineSubmenuProperties(140,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("http://www.colcoa.org/2008/info/location.asp","Location","","");
	addSubmenuItem("http://www.colcoa.org/2008/info/tickets.asp","Buy Tickets","","");
	addSubmenuItem("#","<i>COL•COA Awards</i>","","");
		// define child menu properties (width,"align to edge","text-alignment",v offset,h offset,"filter","smCOLOR","srCOLOR","sbCOLOR","shCOLOR","saLINK","saHOVER") [** last six are new **]
		defineChildmenuProperties(170,"left","left",11,-6,"","","","","","","");
		// add child menu link items ("url","Link name","_target","alt text")
		addChildmenuItem("#","<i>COL•COA Audience Award</i>","","");
		addChildmenuItem("#","<i>COL•COA Critics Award</i>","","");
		addChildmenuItem("#","<i>COL•COA Short Film Award</i>","","");
	
	addSubmenuItem("http://www.colcoa.org/2008/info/volunteer.asp","How to Volunteer?","","");




addMainItem("#","PROGRAM",80,"center","","",0,0,"","","","","");

	defineSubmenuProperties(190,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("#","<i>Full program will be announced <br>on March 12th at midnight</i>","","");
	


addMainItem("#","EVENTS & PANELS",120,"center","","",0,0,"","","","","");

	defineSubmenuProperties(240,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("#","<i>All events and panels will be announced <br>on March 12th at midnight</i>","","");







addMainItem("#","SPONSORS",90,"center","","",0,0,"","","","","");

	defineSubmenuProperties(120,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("#","<i>2008 Sponsors</i>","","");
	addSubmenuItem("http://www.colcoa.org/2008/sponsors/become.asp","Become a Sponsor","","");
	addSubmenuItem("http://www.colcoa.org/2008/sponsors/recent_sponsor.asp","Recent Sponsors","","");






addMainItem("#","INDUSTRY",75,"center","","",0,0,"","","","","");

	defineSubmenuProperties(220,"left","left",-6,-5,"","","","","","","");
	addSubmenuItem("#","<i>An Audience for You</i>","","");
	addSubmenuItem("#","<i>Industry Supporters</i>","","");
	addSubmenuItem("#","<i>How to attend</i>","","");
	addSubmenuItem("#","<i>Contact International Sales</i>","","");
	addSubmenuItem("#","<i>Contact Film Producers</i>","","");
	addSubmenuItem("#","<i>Contact Filmmakers</i>","","");
	addSubmenuItem("#","<i>Petits-déjeuners at the Sunset Marquis</i>","","");
	addSubmenuItem("http://www.colcoa.org/2008/industry/distribution.asp","US Distributors talk about COL•COA","","");
	
	



addMainItem("#","EDUCATION",85,"center","","",0,0,"","","","","");

	defineSubmenuProperties(130,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("http://www.colcoa.org/2008/education/high_school.asp","COL•COA High School","","");
	addSubmenuItem("#","<i>COL•COA Master class</i>","","");
	addSubmenuItem("#","<i>Parental Guidance</i>","","");


addMainItem("#","PRESS & PHOTOS",120,"center","","",0,0,"","","","","");

	defineSubmenuProperties(150,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("#","<i>Press Screenings</i>","","");
	addSubmenuItem("#","<i>How to cover COL•COA?</i>","","");
	addSubmenuItem("#","<i>Press Releases</i>","","");
	addSubmenuItem("#","<i>Film Stills</i>","","");
	addSubmenuItem("#","<i>Festival Reviews </i>","","");
	addSubmenuItem("#","<i>Film Reviews</i>","","");
	addSubmenuItem("#","<i>Photos COL•COA 2008</i>","","");


addMainItem("#","ABOUT US",75,"center","","",0,0,"","","","","");

	defineSubmenuProperties(125,"left","left",-6,-5,"","","","","","","");

	addSubmenuItem("#","About COL•COA","","");
		// define child menu properties (width,"align to edge","text-alignment",v offset,h offset,"filter","smCOLOR","srCOLOR","sbCOLOR","shCOLOR","saLINK","saHOVER") [** last six are new **]
		defineChildmenuProperties(130,"left","left",11,-6,"","","","","","","");
		// add child menu link items ("url","Link name","_target","alt text")
		addChildmenuItem("http://www.colcoa.org/2008/about/story.asp","COL•COA Story","","");
		addChildmenuItem("http://www.colcoa.org/2008/about/growth.asp","A Steady Growth","","");
		addChildmenuItem("http://www.colcoa.org/2008/about/key_figures.asp","Key Figures","","");
		
	
	addSubmenuItem("http://www.colcoa.org/2008/about/culture.asp","Franco-American<br>Cultural Fund","","");
	addSubmenuItem("http://www.colcoa.org/2008/about/staff.asp","Team","","");
	addSubmenuItem("http://www.colcoa.org/2008/about/livredor.asp","Livre D'or","","");
	
	addSubmenuItem("#","Archive","","");
		// define child menu properties (width,"align to edge","text-alignment",v offset,h offset,"filter","smCOLOR","srCOLOR","sbCOLOR","shCOLOR","saLINK","saHOVER") [** last six are new **]
		defineChildmenuProperties(130,"left","left",11,-6,"","","","","","","");
		// add child menu link items ("url","Link name","_target","alt text")
		addChildmenuItem("http://www.colcoa.org/2008/about/last11years.asp","Last 11 Years","","");
		addChildmenuItem("http://www.colcoa.org/2008/about/archive.asp","Previous Websites","","");
	
	

addMainItem("http://www.colcoa.org/2008/contact/index.asp","CONTACT US",85,"center","","",0,0,"","","","","");

	defineSubmenuProperties(85,"left","left",-6,-5,"","","","","","","");




//**DO NOT EDIT THIS *****
}//***********************
//************************
