blnJavaScriptLoaded = false;

// no comments and code arranged for fastest loading This is Frank Roths Council Legistar js
// dpcjsr
function xlaunchLegistar(){
alert("hello");
}
// Browser detection.  Defines the variables and the form submission
		// Store this as bits in a field.
		// Bit 0 = IE4
		// Bit 1 = IE5
		// Bit 2 = NS4
		// Bit 3 = NS6
		// Bit 4 = V4 Browser
		// Bit 5 = V5 Browser 
		var IE4 = (document.all) ? 1 : 0;
		var IE5 = (navigator.appVersion.indexOf("MSIE 5") != -1) ? 1 : 0;
		var NS4 = (document.layers) ? 1 : 0;
		var NS6 = (navigator.userAgent.indexOf("Netscape6") != -1) ? 1 : 0;
		var ver4 = (IE4 || NS4) ? 1 : 0;
		var ver5 = (IE5 || NS6) ? 1 : 0;
		
		// This value should be stored in a URL parameter named XSLT.UserSession.@Browser
		var bitField=0;
		if (IE4) bitField = bitField|1;  // Set bit 0
		if (IE5) bitField = bitField|2; 
		if (NS4) bitField = bitField|4;
		if (NS6) bitField = bitField|8;
		if (ver4) bitField = bitField|16;
		if (ver5) bitField = bitField|32;
		
		function launchLegistar(){
		var currentWidth = screen.availWidth;
		var currentHeight = screen.availHeight;
		
		currentWidth = currentWidth - 12;
		currentHeight = currentHeight - 32;
		
		if (NS4){currentHeight -= 24}
//		appWindow = window.open('http://legistar.cabq.gov:81/Legistar.asp?action=0&XSLT.UserSession.@Browser=' + bitField, 'test', 'resizable=yes,top=0,left=0,width=' + currentWidth + ',height=' + currentHeight);
		appWindow = window.open('http://daystar2.cabq.gov:81/legistarweb/Legistar.asp?action=0&XSLT.UserSession.@Browser=' + bitField, 'test', 'resizable=yes,top=0,left=0,width=' + currentWidth + ',height=' + currentHeight);
		}
		
		/*
		alert("IE4:" + IE4);
		alert("IE5:" + IE5);
		alert("NS4:" + NS4);
		alert("NS6:" + NS6);
		alert("v4:" + ver4);
		alert("v5:" + ver5);
		alert(navigator.userAgent);
		*/
		
		//var formName = document.forms[launch].elements['selectRes'];

NS = (document.layers) ? 1 : 0;
IE = (document.all) ? 1 : 0;
ver4 = (NS || IE) ? 1 : 0;

blnMenusLoaded = false;
outMenu = false;

function ABQonLoad() {
	PreloadAllImages();
	MakeAllMenus();
}

function ABQonMouseOver(strVar1, strVar2, strVar3, intVar4) {
	MM_swapImage(strVar1, strVar2, strVar3, intVar4);
	if (blnMenusLoaded)	{
		ABQMenu(strVar1, true);
	}
}

function ABQonMouseOut(strVar1) {
	MM_swapImgRestore();
	if (blnMenusLoaded)	{
		ABQMenu(strVar1, false);
	}
}

function PreloadAllImages() {
    MM_preloadImages('/images/h_cityservices_l.gif','/images/h_businessservices_l.gif','/images/h_environment_l.gif','/images/h_transportation_l.gif','/images/h_recreation_l.gif','/images/h_jobs_l.gif','/images/h_publicsafety_l.gif','/images/h_visitorinformation_l.gif')
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_displayStatusMsg(msgStr) {//v2.0
  status=msgStr;
  document.MM_returnValue = true;
}

function offsite() {
	open("/offsite.html", "offsite", "toolbar=0,location=0,status=0,menubar=0,scrollbars=0,resizable=0,width=400,height=280,top=0,left=0");
}

function offsite2() {
	open("/offsite2.html", "offsite2", "toolbar=0,location=0,status=0,menubar=0,scrollbars=0,resizable=0,width=500,height=525,top=0,left=0");
}

function ABQHiLite(objLink, blnOn) {
	if (ver4) {
		if (IE) {
			if (blnOn) {
				outMenu = false;
				objLink.style.color = "#FF0000";
			} else {
				outMenu = true;
				objLink.style.color = "#333399";
			}
		}
	}
}

function ABQMenu(strMenuName, blnOn) {
	if (ver4)
	{
		if (blnOn) {
			// first, make sure all menus are invisible, including the search box
			// then show the requested menu
			outMenu = true;
			HideAllMenus(false);
			outMenu = false;
			ShowMenu(strMenuName);
		} else {
			outMenu = true;
			if (IE)	{
				setTimeout('HideAllMenus(true);', 250);
			}
		}
	}
}

function ShowMenu(onMenuName) {
	var MENUname = 'MENU' + onMenuName;
	var DEFmenu = eval('DEF' + onMenuName);
	if (NS) {
		windowWidth  = window.innerWidth;
		windowHeight = window.innerHeight;
		var thisMENU = eval(MENUname);
		thisMENU.left = (windowWidth+8)/2 + DEFmenu.widthOffset - 8;
		thisMENU.top = DEFmenu.heightOffset;
		thisMENU.visibility = "show";
	} 
	if (IE) {
		windowWidth = document.body.clientWidth;
		windowHeight = document.body.clientHeight;
		document.all[MENUname].style.pixelLeft = (windowWidth+8)/2 + DEFmenu.widthOffset;
		document.all[MENUname].style.pixelTop = DEFmenu.heightOffset;
		document.all[MENUname].style.visibility = "visible";
	}
}

function HideAllMenus(blnSearch) {
	if (IE) {
		if (outMenu) {
			HideMenu('cityservices');
			HideMenu('environment');
			HideMenu('transportation');
			HideMenu('businessservices');
			HideMenu('recreation');
			HideMenu('jobs');
			HideMenu('publicsafety');
			HideMenu('visitorinfo');
			SearchBox(blnSearch);
			outMenu = false;
		}
	}
	if (NS) {
		HideMenu('cityservices');
		HideMenu('environment');
		HideMenu('transportation');
		HideMenu('businessservices');
		HideMenu('recreation');
		HideMenu('jobs');
		HideMenu('publicsafety');
		HideMenu('visitorinfo');
		SearchBox(blnSearch);
	}
}

function HideMenu(poffMenuName) {
	var offMENUname = 'MENU' + poffMenuName;
	if (NS) {
		var thisMENU = eval(offMENUname);
		thisMENU.visibility = "hide";
	} 
	if (IE) {
		document.all[offMENUname].style.visibility = "hidden";
	}
}

function SearchBox(showSearch) {
	if (showSearch)	{
		if (NS) {
			document.layers['NSsearch'].visibility = "show";
		} 
		if (IE) {
			document.all['IEsearch'].style.visibility = "visible";
		}
	} else {
		if (NS) {
			document.layers['NSsearch'].visibility = "hide";
		}
		if (IE) {
			document.all['IEsearch'].style.visibility = "hidden";
		}
	}
}


function MakeAllMenus() {
	if (ver4) {
		if (NS)	{
			InitNS(DEFcityservices);
			InitNS(DEFenvironment);
			InitNS(DEFtransportation);
			InitNS(DEFbusinessservices);
			InitNS(DEFrecreation);
			InitNS(DEFjobs);
			InitNS(DEFpublicsafety);
			InitNS(DEFvisitorinfo);
			SearchBox(true);
			blnMenusLoaded = true;
		}
		if (IE) {
			InitIE(DEFcityservices);
			InitIE(DEFenvironment);
			InitIE(DEFtransportation);
			InitIE(DEFbusinessservices);
			InitIE(DEFrecreation);
			InitIE(DEFjobs);
			InitIE(DEFpublicsafety);
			InitIE(DEFvisitorinfo);
			blnMenusLoaded = true;
		}
	}
}

function InitIE(DEFmenu) {
	var strStartTag = '<DIV ID="MENU' + DEFmenu.menuName + '" onMouseOver="outMenu=false;" onMouseOut="ABQMenu(\'\', false);" STYLE="POSITION: absolute; Z-INDEX: 100; BACKGROUND: white; VISIBILITY: hidden; TOP: 0; LEFT: 0;">';
	var strStopTag = '</DIV>';
	document.body.insertAdjacentHTML("beforeEnd", strStartTag + DEFmenu.htmlContent + strStopTag);
}

function InitNS(DEFmenu) {
	eval('MENU' + DEFmenu.menuName + ' = new Layer(800);');
	newMENU = eval('MENU' + DEFmenu.menuName);
	newMENU.document.open();
	newMENU.document.write(DEFmenu.htmlContent);
	newMENU.document.close();
	newMENU.zIndex = 99;
	newMENU.visibility = "hide";
	newMENU.bgcolor = "#FFFFFF";
	newMENU.onmouseout = HideAllMenus;
}

function Menu(widthOffset, heightOffset, menuName, htmlContent) {
	this.widthOffset = widthOffset;
	this.heightOffset = heightOffset;
	this.menuName = menuName;
	this.htmlContent = htmlContent;
}

if (ver4) {
	DEFcityservices = new Menu(-384, 109, 'cityservices', 
	'<p><table border="0" cellspacing="0" cellpadding="1" bgcolor="#D6D6AD">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/a-z.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Abq A-Z</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/housing/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Affordable Housing</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/animalservices/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Animal Services</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/cip/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Capital Implementation</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/council/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">City Council</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/progress/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">City Goals</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/wastewater/roach.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Cockroaches</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/clerk/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Elections/Voting</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/solidwaste/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Garbage/Trash</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/govtv/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">GOV-TV</a>&#160;&#160;</font></td></tr>' +
    '<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/gis/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Interactive Maps</a>&#160;&#160;</font></td></tr>' +			
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/city/youth.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Kids</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/library/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Library</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/mayor/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Mayor</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/planning/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Planning</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/seniors/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Seniors</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/streets/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Streets</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/customerservices/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Water & Sewer</a>&#160;&#160;</font></td></tr>' +
	
	
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
	DEFenvironment = new Menu(-305, 109, 'environment',
	'<p><table width="120" border="0" cellspacing="0" cellpadding="1" bgcolor="#ADD6AD">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/solidwaste/act.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Clean Team</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/solidwaste/greenwst.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Composting</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/envhealth/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Environmental Health</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/aes/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Environmental Story</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/solidwaste/cleancit.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Graffitti Removal</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/p2/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Pollution Prevention</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/waterconservation/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Water Conservation</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/waterpolicy/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Water Policy</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/waterquality/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Water Quality</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/waterresources/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Water Resources</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/aircare/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Vehicle Pollution</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/waterconservation/xeric.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Xeriscaping</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
	DEFtransportation = new Menu(-210, 109, 'transportation',
	'<p><table width="130" border="0" cellspacing="0" cellpadding="1" bgcolor="#D6AD33">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/airport/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Airport/Aviation</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.amtrak.com/" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Amtrak</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/transit/tran.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Bus Routes</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/bike/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Bike</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/construction/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Construction</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.mrgcog.org/" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Mid-region COG</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/streets/failureform.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Pothole Repair</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/streets/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Traffic</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/transit/index.htm" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Transit</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
	DEFbusinessservices = new Menu(-130, 109, 'businessservices',
	'<p><table width="190" border="0" cellspacing="0" cellpadding="1" bgcolor="#D6D685">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://mesa.cabq.gov/bidpkg.nsf/Solicitations?OpenPage" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Bids and Proposals</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/planning/statistics/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Building Permits</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/dfa/treasury/license.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Business Registration</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.amlegal.com/albuquerque_nm/" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">City Law</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/planning/statistics/index.html#index" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Cost of Living Index</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/oed/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Economic Development</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/film/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Film Office</a>&#160;&#160;</font></td></tr>' +	
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://greenalliancenm.org/" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Green Building</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/dfa/purchase/regisinfo.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">How to Become a City Vendor</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/dfa/treasury/investor/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Investor Information</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/construction/development.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Land Development</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.nextgenclusters.net" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Next Generation Economy</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/dfa/purchase/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Purchasing Information</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.cabq.gov/onlinesvcs/vendors/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Vendor Services</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
	
	DEFrecreation = new Menu(10, 109, 'recreation',
	'<p><table width="110" border="0" cellspacing="0" cellpadding="1" bgcolor="#ADD6D6">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/biopark/aquarium/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Aquarium</a>&#160;&#160;</font></td></tr>' +
'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/balloon/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Balloon Museum</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/bike/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Bike</a>&#160;&#160;</font></td></tr>' +
		'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/biopark/garden/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Botanic Gardens</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/communitycenters/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Community Centers</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/calendar/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Events Calendar</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/gis/park.htm" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Find a Park</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/golf/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Golf</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/city/youth.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Kids</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/kimo/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">KiMo Theatre</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/rgvls/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Libraries</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/museum/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Museum</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/sbcc/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">S Broadway Center</a>&#160;&#160;</font></td></tr>' +
		'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/recreation/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Sports & Rec</a>&#160;&#160;</font></td></tr>' +
		'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/crs/actguide.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Summer Fun</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/recreation/aquatics.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Swimming</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/recreation/tennis.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Tennis</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/biopark/zoo/" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Zoo</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
	
	DEFjobs = new Menu(70, 109, 'jobs',
	'<p><table width="125" border="0" cellspacing="0" cellpadding="1" bgcolor="#D6D6FF">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://mesa.cabq.gov/cityjobs.nsf/OutsideView?OpenPage" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">City Government</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/fire/recruit.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Fire Dept Recruiting</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/police/recruiting/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Police Dept Recruiting</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.abqjournal.com/jobs/" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Alb. Journal job page</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
	
	DEFpublicsafety = new Menu(155, 109, 'publicsafety',
	'<p><table width="100" border="0" cellspacing="0" cellpadding="1" bgcolor="#D6ADAD">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/consumerhealth/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Consumer Health</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/fire/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Fire</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/police/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Police</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
	DEFvisitorinfo = new Menu(251, 109, 'visitorinfo',
	'<p><table width="125" border="0" cellspacing="0" cellpadding="1" bgcolor="#FFD65C">' +
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +	
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/city/aboutabq.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">About Albuquerque</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/visitorinfo.shtml" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Activities/Events</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.abqcvb.org/" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Tourist Info.</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="/gis/index.html" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Interactive Maps (GIS)</a>&#160;&#160;</font></td></tr>' +
	'<tr><td><font face="Arial, Helvetica, sans-serif" size="1">&#160;&#160;<A HREF="http://www.gacc.org/" onClick="offsite()" onMouseOver="ABQHiLite(this, true);" onMouseOut="ABQHiLite(this, false);">Relocation</a>&#160;&#160;</font></td></tr>' +

	
	'<tr><td><img src="/images/spacer.gif" height="5" width="5"></td></tr>' +
	'</table></p>');
}

blnJavaScriptLoaded = true;
