//Global Page JavaScript Variables
var RequiredFlashVersion = 6;			
var Flash2Installed = false;	
var Flash3Installed = false;		
var Flash4Installed = false;		
var Flash5Installed = false;
var Flash6Installed = false;
var Flash7Installed = false;
var ActualFlashVersion = 0;
var MaxFlashVersion = 7;		
var HasRightFlashVersion = false;	
var jsVersion = 1.0;				
var BrowserName = new String();
var BrowserAppVersion = parseFloat(navigator.appVersion);
var BrowserVersion;
var BrowserIsMac;

var isIE = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;	
var isWin = (navigator.appVersion.indexOf("Windows") != -1) ? true : false;

jsVersion = 1.1;

if(isIE && isWin){ // don't write vbscript tags on anything but ie win
	document.write('<SCR' + 'IPT LANGUAGE=VBScript\> \n');
	document.write('on error resume next \n');
	document.write('Flash2Installed = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.2"))) \n');
	document.write('Flash3Installed = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.3"))) \n');
	document.write('Flash4Installed = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.4"))) \n');
	document.write('Flash5Installed = (IsObject(CreateObject("SWCtl.SWCtl.8"))) \n');	// Flash 5 is coupled with Shockwave 8
	document.write('If (Flash5Installed = false) Then \n Flash5Installed = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.5"))) \n End If \n');	 //Check for Flash 5 if Shock not avail
	document.write('If (Flash6Installed = false) Then \n Flash6Installed = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.6"))) \n End If \n');	 //Check for Flash 6 if Shock not avail
	document.write('If (Flash7Installed = false) Then \n Flash7Installed = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.7"))) \n End If \n');	 //Check for Flash 7 if Shock not avail
	document.write('</SCR' + 'IPT\> \n');

}

function detectFlash()
{	
	if (navigator.plugins)
	{		
		if (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"])
		{
			var isVersion2 = navigator.plugins["Shockwave Flash 2.0"] ? " 2.0" : "";
			var flashDescription = navigator.plugins["Shockwave Flash" + isVersion2].description;
			var flashVersion = parseInt(flashDescription.charAt(flashDescription.indexOf(".") - 1));
			
			// This will override the current Flash#Installed only if "flashversion" is valid
			Flash2Installed = flashVersion == 2;		
			Flash3Installed = flashVersion == 3;
			Flash4Installed = flashVersion == 4;
			Flash5Installed = flashVersion == 5;
			Flash6Installed = flashVersion == 6;
			Flash7Installed = flashVersion == 7;
		}
	}
	
	for (var i = 2; i <= MaxFlashVersion; i++)
	{	
		if (eval("Flash" + i + "Installed") == true) ActualFlashVersion = i;
	}
	
	if (navigator.userAgent.indexOf("WebTV") != -1) ActualFlashVersion = 2;
	
	if (BrowserIsMac && BrowserVersion < 4.5)
	{
		//Because Mac Level 4 Browsers will not expose plugins, assume they are availabe for this application
		ActualFlashVersion = RequiredFlashVersion;
		
	}
}
	
//Checks the FlashVersion
detectFlash();