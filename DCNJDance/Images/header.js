<!-- Begin HEADER OPTIONS CODE


// ONLY USE lowercase FOR ALL OPTIONS


// CHANGE ANY OF THESE VARIABLES TO "no" OR "yes" TO TURN AN OPTION OFF OR ON


var color		= "FFFFFF"	// HEADER BACKGROUND COLOR
var flashwidth		= "600"		// WIDTH OF THE FLASH (IN PIXELS)
var flashheight		= "75"		// HEIGHT OF THE FLASH (IN PIXELS)
var headerlayer		= "no"		// SOLID COLOR HEADER




// COPYRIGHT 2008 © Allwebco Design Corporation
// Unauthorized use or sale of this script is strictly prohibited by law

// YOU DO NOT NEED TO EDIT BELOW THIS LINE



document.write('<div id="header-layer">');
document.write('<span class="printhide">');
   if (headerlayer == "yes") {
document.write('<TABLE cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td bgcolor="#'+color+'" align="right">');
}
document.write('<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" WIDTH="'+flashwidth+'" HEIGHT="'+flashheight+'" id="sublogo">');
document.write('<PARAM NAME="movie" VALUE="sublogo.swf">');
document.write('<PARAM NAME="quality" VALUE="high">');
document.write('<PARAM NAME="wmode" VALUE="transparent">');
document.write('<PARAM NAME="bgcolor" VALUE="#'+color+'">');
document.write('<EMBED src="sublogo.swf" quality="high" wmode="transparent" bgcolor="#'+color+'"  WIDTH="'+flashwidth+'" HEIGHT="'+flashheight+'" NAME="sublogo" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED></OBJECT><br>');
   if (headerlayer == "yes") {
document.write("</td></tr></table>");
}
document.write('</span>');
document.write('</div>');

//  End -->