function parseURL(){
	var myStr, searchIndex;
	myStr = location.href;
	
	// Find the ?
	searchIndex = myStr.indexOf("?");
	
	// Cut the string before the ? if a ? is found
	if(searchIndex > 0)
	myStr = myStr.substring(0, searchIndex);
	
	return myStr;
}

var isInternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
// Handle all the FSCommand messages in a Flash movie.
function master_nav2_DoFSCommand(command, args) {
	var master_nav2Obj = isInternetExplorer ? document.all.master_nav2 : document.master_nav2;
	if(command == "ResizeDiv"){
		document.getElementById("MasterNavContainer").style.height=args+"px";
	}
}
// Hook for Internet Explorer.
if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && navigator.userAgent.indexOf("Windows") != -1 && navigator.userAgent.indexOf("Windows 3.1") == -1) {
	document.write('<script language=\"VBScript\"\>\n');
	document.write('On Error Resume Next\n');
	document.write('Sub master_nav2_FSCommand(ByVal command, ByVal args)\n');
	document.write('	Call master_nav2_DoFSCommand(command, args)\n');
	document.write('End Sub\n');
	document.write('</script\>\n');
}

document.write('<div ID="MasterNavContainer" name="MasterNavContainer" style="overflow:hidd');
document.write('en; width:173px; height:145px;"><object classid="clsid:d27cdb6e-ae6d-11cf');
document.write('-96b8-444553540000" codebase="https://fpdownload.macromedia.com/pub/shockwav');
document.write('e/cabs/flash/swflash.cab#version=6,0,0,0" id="master_nav2" width="173" heig');
document.write('ht="1000" align="middle"><param name="allowScriptAccess" value="always" /');
document.write('><param name="movie" value="http://www.tix.com/PrivateLabel/ChoctawColiseum/Master_Nav/master_nav2.swf" />');
document.write('<param name="menu" value="false" /><PARAM NAME="FlashVars" value="MenuAt='+parseURL()+'">');
document.write('<param name="quality" value="high" /><param name="scale" val');
document.write('ue="noscale" /><param name="salign" value="lt" /><param name="wmode" va');
document.write('lue="transparent" /><param name="bgcolor" value="#8d30ac" /><embed src=');
document.write('"http://www.tix.com/PrivateLabel/ChoctawColiseum/Master_Nav/master_nav2.swf" FlashVars="MenuAt='+parseURL()+'" menu="false" quality="high" scale="noscale" salign="lt" w');
document.write('mode="transparent" bgcolor="#8d30ac" width="173" height="1000" swLiveConnec');
document.write('t=true id="master_nav2" name="master_nav2" align="middle" allowScriptAccess');
document.write('="always" type="application/x-shockwave-flash" pluginspage="https://www.macr');
document.write('omedia.com/go/getflashplayer" /></object></div>');