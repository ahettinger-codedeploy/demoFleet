var adWidth = 1025;
var adHeight = 32;
var adBkgCol = "FFFFFF"; //background color of the ad - if not set in the swf
var adBase = "http://graphics.ocsn.com"; //base domain for the swf, shouldn't need to be changed
var adSWF = "http://graphics.ocsn.com/schools/amer/graphics/amer-06-scoreboard.swf"; //path to the swf
var masterSWF = "http://graphics.ocsn.com/graphics/oas-scoreboard-master.swf";
var xmlForSports = "http://graphics.ocsn.com/schools/amer/data/xml/sports.xml";
var xmlForSchools = "http://graphics.ocsn.com/schools/amer/data/xml/schools.xml";
var xmlForEvents = "http://graphics.ocsn.com/schools/amer/data/xml/scoreboard.xml";
var sponsorURL = "";
var xmlRefreshRate = 60;
var flashrandom = Math.random();
//var adBase = ".";
//var adSWF = "amer-06-scoreboard-index.swf";
//var masterSWF = "oas-scoreboard-master.swf";
//var xmlForSports = "sports.xml";
//var xmlForSchools = "schools.xml";
//var xmlForEvents = "scoreboard.xml";

var ScrbrdcookName = "amerScoreboard"; //cookie name
var ScrbrdcookValue = "true";
var cookChoices = "";

var expirday = new Date();
expirday.setTime(expirday.getTime() + (24 * 60 * 60 * 1000));
var expiryear = new Date();
expiryear.setTime(expiryear.getTime() + (365 * 24 * 60 * 60 * 1000));
function getScrbrdCookVal(offset) {
	var endstr = document.cookie.indexOf(";",offset);
	if(endstr == -1) 
		endstr = document.cookie.length;
		return document.cookie.substring(offset,endstr);
}
function getScrbrdCook(name){
	var arg = name + "=";
	var alen = arg.length
	var clen = document.cookie.length;
	var i = 0;
	while(i < clen){
		var j = i + alen;
		if(document.cookie.substring(i,j) == arg)
		 return getScrbrdCookVal(j);
		      i = document.cookie.indexOf("",i) + 1;
		if(i == 0) break;
	}
return null;
}
function SetScbrdCook(name,value,choices,expires){
	if(name){
	cookLife = (expires)? "; expires=" + expires.toGMTString() : "";
	document.cookie = name + "=" + value + "&offChoices=" + choices + cookLife + ";path=/";
	}	
}
if (getScrbrdCook(ScrbrdcookName) != null){
	cookChoices = getScrbrdCook("offChoices");
}

var adSWFurl = adSWF+"?nRate="+xmlRefreshRate+"&xmlSports="+xmlForSports+"&xmlSchools="+xmlForSchools+"&xmlEvents="+xmlForEvents+"&cookChoices="+cookChoices+"&sponsorClick="+sponsorURL+"&masterFile="+masterSWF+"&"; //full url string - path to swf, passing txt files urls

//shouldn't have to edit anything below
var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"]) ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
if ( plugin ) {
	plugin = parseInt(plugin.description.substring(plugin.description.indexOf(".")-1)) >= 6;
}
else if (navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0 
   && (navigator.userAgent.indexOf("Windows 95")>=0 || navigator.userAgent.indexOf("Windows 98")>=0 || navigator.userAgent.indexOf("Windows NT")>=0)) {
	document.write('<SCR'+'IPT LANGUAGE=VBScript\> \n');
	document.write('on error resume next \n');
	document.write('plugin = ( IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.6")))\n');
	document.write('</SCR'+'IPT\> \n');
}
if ( plugin ) {
	adFlashCode =' <OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"';
//	adFlashCode +=' codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" ';
	adFlashCode +=' ID=cstvad WIDTH='+adWidth+' HEIGHT='+adHeight+'>';
	adFlashCode +=' <PARAM NAME=movie VALUE="'+adSWFurl+'?&random='+flashrandom+'"> <PARAM NAME=menu VALUE=false> <PARAM NAME=quality VALUE=high> <PARAM NAME=scale VALUE=exactfit> <PARAM NAME=salign VALUE=LT> <PARAM NAME=wmode VALUE=window> <PARAM NAME=bgcolor VALUE=#'+adBkgCol+'> <PARAM NAME=base VALUE="'+adBase+'"> '; 
	adFlashCode +=' <EMBED src="'+adSWFurl+'?&random='+flashrandom+'" menu=false quality=high scale=exactfit salign=LT wmode=window bgcolor=#'+adBkgCol+' swLiveConnect=FALSE BASE="'+adBase+'" WIDTH='+adWidth+' HEIGHT='+adHeight;
	adFlashCode +=' TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></EMBED></OBJECT>';
	document.write(adFlashCode);
}