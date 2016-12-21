/* Website global functions */
function checkNavLocation(){
		window.status = "University of the Pacific: San Francisco, Sacramento, and Stockton"
}

function showStatus(sMsg) {
    window.status = sMsg ;
    return true ;
}


// Spam-proof email by deanq.com
// Copyright © 2003. deanq.com
function email(who,domain,subject) {
  if (!domain) var domain = "pacific.edu";
  if (!subject) var subject = " ";
  var attrib = "width=1,height=1,resizable=1,toolbar=0,menubar=0,left=2000,top=2000,screenX=2000,screenY=2000,scrollbars=0";
  MyWindow=window.open('', "email", attrib);
  MyWindow.document.write("<HTML><HEAD><TITLE> <\/TITLE><META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'><\/HEAD><BODY leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad=\"javascript:location.href='mailto:" + who + "@" + domain + "?subject=" + subject + "'\" onBlur='window.close()' onFocus='window.close()'><\/BODY><\/HTML>");
  MyWindow.window.resizeTo(1, 1);
  MyWindow.document.title = " ";
  MyWindow.document.close();
}	

// legacy email substitution routine
function mt(addr) {
	addr = addr.substring(1,8)+addr.substring(9, addr.length-1);
	parent.location.href='mailto:'+addr;
}
// current email obfuscation routine
function email4(who,domain,subject,msgbody) {
  if (!domain) var domain = "pacific.edu";
  if (!subject) var subject = " ";
  if (!msgbody) var msgbody = " ";
  var attrib = "width=1,height=1,resizable=1,toolbar=0,menubar=0,left=2000,top=2000,screenX=2000,screenY=2000,scrollbars=0";
  MyWindow=window.open('', "email", attrib);
  MyWindow.document.write("<HTML><HEAD><TITLE> <\/TITLE><META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'><\/HEAD><BODY leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad=\"javascript:location.href='mailto:" + who + "@" + domain + "?subject=" + subject + "&body=" + msgbody + "'\" onBlur='window.close()' onFocus='window.close()'><\/BODY><\/HTML>");
  MyWindow.window.resizeTo(1, 1);
  MyWindow.document.title = " ";
  MyWindow.document.close();
}	


// Menu control
function Pac_goLoc( url ) {
	window.location.href = url;
}

function PacNavMenu( tableCellRef, hoverFlag, navStyle ) {
	if ( hoverFlag ) {
		switch ( navStyle ) {
			case 1:
				tableCellRef.style.backgroundColor = '#3E647E';
				break;
			default:
				if ( document.getElementsByTagName ) {
					tableCellRef.getElementsByTagName( 'a' )[0].style.color = '#6E6F64';
				}
		}
	} else {
		switch ( navStyle ) {
			case 1:
				tableCellRef.style.backgroundColor = '#CF7600';
				break;
			default:
				if ( document.getElementsByTagName ) {
					tableCellRef.getElementsByTagName( 'a' )[0].style.color = '#ADA59D';
				}
		}
	}
}

function PacNavMenuClick( tableCellRef, navStyle, url ) {
	PacNavMenu( tableCellRef, 0, navStyle );
	Pac_goLoc( url );
}

function formHandler(form){
var URL = document.form.site.options[document.form.site.selectedIndex].value;
window.location.href = URL;
}

MM_reloadPage(true);

function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}

var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed) popUpWin.close();
  }
  
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}
