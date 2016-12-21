/* Rollover Function */

function swapImage(imageID, imagePath) {
	var imgID;
	imgID = document.getElementById(imageID);
	imgID.src = imagePath;
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

// Admission-specific popups to support flash detection

function tourpopup()
{	
	MM_openBrWindow('/admission/flash/onlinetour_detect.html','flashpopup','width=768,height=500');
	return false;
	window.focus()
}

function experiencepopup()
{	
	MM_openBrWindow('/admission/flash/pacific_experience_detect.html','flashpopup','width=768,height=500');
	return false;
	window.focus()
}

// Support for Google Maps

