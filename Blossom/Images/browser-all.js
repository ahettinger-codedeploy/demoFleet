function newWindow (name,workUrl)
{
	var externalLinkRegEx = /^https?:[\/\\]{2}/i;
	var blnPopUpsOffScreen=0;
	var intTop=200;
	var intLeft=200;
	var intHeight=290;
	var intWidth=480;
	var cookieStr = document.cookie;
	var cookieWinRegEx = /CSOFFSCREENPOPUPSALLOWED=\d/i;
	var rxVal = /\d+/;
	try
	{
		if (cookieStr && cookieStr.match(cookieWinRegEx))
		{
			var strVal=cookieStr.match(cookieWinRegEx);
			if (strVal)
				blnPopUpsOffScreen=strVal.toString().match(rxVal);
			else
				blnPopUpsOffScreen = 0;
		}
		else
			blnPopUpsOffScreen=0;
	}
	catch (oErr)
	{
		blnPopUpsOffScreen=0;
	}
	if(blnPopUpsOffScreen==1)
	{
		intTop=window.screen.height - 9;
		intLeft=window.screen.width - 9;
		intHeight=1;
		intWidth=1;
	}
	else
	{
		intTop=(window.screen.height / 2) - 109;
		intLeft=(window.screen.width / 2) - 210;
		intHeight=218;
		intWidth=421;
	}
	if(!workUrl.match(externalLinkRegEx) && workUrl.indexOf('kurrentPageID') == -1)
	{
		if(typeof js_gvPageID != 'undefined')
		{
			try
			{
				if( workUrl.indexOf ('?') == -1 )
					workUrl = workUrl + '?kurrentPageID=' + js_gvPageID;
				else
					workUrl = workUrl + '&kurrentPageID=' + js_gvPageID;
			}
			catch (oErr)
			{ /* Do Nothing */ }
		}
	}
	var re = new RegExp();
	re = /&amp;/gi;
	workUrl = workUrl.replace(re,"&");
	// do not use CommonSpot loader if the URL is fully-qualified (i.e. if we find a protocol)
	if ((workUrl.search(/^[a-zA-Z]+:\/\//) == 0) && (workUrl.search(/[\/\\]/g) >= 0) && (blnPopUpsOffScreen==0))
	{
		if (document.CS_StaticURL && window.location.href.indexOf(document.CS_StaticURL) == -1)
			workUrl = jsDlgLoader + '?proc_type=dynamic_page&onlyurlvars=1&realTarget=' + escape(workUrl);
	}
	var strWinOptions = 'toolbar=no,resizable=yes,scrollbars=yes,menubar=no,location=no';
	if(arguments.length >= 2 && arguments[2])
	{
		var strOptions=arguments[2];
		var strTopPos=strOptions.match(/top=\s*(\d+)/i);
		if(strTopPos && strTopPos[1] >=0)
		{
			intTop=strTopPos[1];
			strOptions=strOptions.replace(/top=\s*\d+\s*,?/i,'')
		}
		var strLeftPos=strOptions.match(/left=\s*(\d+)/i);
		if(strLeftPos && strLeftPos[1] >=0)
		{
			intLeft=strLeftPos[1];
			strOptions=strOptions.replace(/left=\s*\d+\s*,?/i,'')
		}
		var strHeight=strOptions.match(/height=\s*(\d+)/i);
		if(strHeight && strHeight[1] >=0)
		{
			intHeight=strHeight[1];
			strOptions=strOptions.replace(/height=\s*\d+\s*,?/i,'')
		}
		var strWidth=strOptions.match(/width=\s*(\d+)/i);
		if(strWidth && strWidth[1] >=0)
		{
			intWidth=strWidth[1];
			strOptions=strOptions.replace(/width=\s*\d+\s*,?/i,'')
		}
		var strWinOptions = strOptions;
	}
	strWinOptions = strWinOptions + ',top='+ intTop + ',left=' + intLeft + ',height=' + intHeight + ',width=' + intWidth;
	var winWindow=window.open(workUrl,name,strWinOptions);
	if (!winWindow)
		alert('Unable to open window - please make sure the pop-up blocker is disabled for this site');
	else
		winWindow.focus();
	if(arguments.length==4 && arguments[3]==1 && winWindow)
		return winWindow;
}
function newCenteredWindow(name, url, width, height, windowFeatures)
{
	var left = (screen.availWidth - width) / 2;
	var top = ((screen.availHeight - height) / 2) - 20; // a bit above center
	if(!windowFeatures)
		var windowFeatures = 'toolbar=no,menubar=no,location=no,scrollbars,resizable';
	windowFeatures += ',top=' + top + ',left=' + left + ',width=' + width + ',height=' + height;
	newWindow(name, url, windowFeatures);
}
function submitFormToNewWindow(windowName, loader, csModule, args)
{
	var form, fldName;
	form = document.createElement('form');
	form.target = windowName;
	form.action = loader;
	form.method = 'post';
	//form.enctype = 'multipart/form-data'; // NEEDSWORK: we may need to do this for UTF8???
	form.style.display = 'none';
	createField(form, 'csModule', csModule);
	for(fldName in args)
		createField(form, fldName, args[fldName]);
	document.body.appendChild(form);
	newWindow(windowName, '_blank');
	form.submit();
	document.body.removeChild(form);
	
	function createField(form, name, value)
	{
		var fld = document.createElement('input');
		fld.type = 'hidden';
		fld.name = name;
		fld.value = value;
		form.appendChild(fld);
	}
}
function AskClearCache (workUrl)
{
	newWindow('clearcache', workUrl);
}
function setSelectedAudience(id)
{
	newWindow('SetAudience',jsDlgLoader + '?csModule=utilities/set-audience&amp;target='+id);
}
function doDisplayOptionsMenu(dlgloader,pageid,event)
{
	var thisMenu = document.getElementById("DisplayOptionsMenu");
	calcMenuPos ("DisplayOptionsMenu",event);
	stopEvent(event);
}
function doRolesMenu(dlgloader,pageid,event)
{
	var thisMenu = document.getElementById("RolesMenu");
	calcMenuPos ("RolesMenu",event);
	stopEvent(event);
}
function doPageManagementMenu(dlgloader,pageid,event)
{
	var thisMenu = document.getElementById("PageManagementMenu");
	calcMenuPos ("PageManagementMenu",event);
	stopEvent(event);
}
function toggleState (value, name)
{
	document.styleSheets[0].addRule(".cls" + name, (value) ? "display:block;" : "display:none;");
	document.cookie = name + "=" + value;
}
function toggleDesc (value, name)
{
	document.getElementById("id" + name).style.display =  (value) ? "block" : "none";
	document.getElementById("id" + name + "img").src =  (value) ? "/commonspot/images/arrow-right.gif" : "/commonspot/images/arrow.gif";
	document.cookie = name + "=" + value;
}
function stopEvent(event)
{
	if(event.preventDefault)
	{
		event.preventDefault();
		event.stopPropagation();
	}
	else
	{
		event.returnValue = false;
		event.cancelBubble = true;
	}
}
function canRollover(browserVersion)
{
	var agent = navigator.userAgent.toLowerCase();
	var isMoz = agent.match('mozilla') && agent.match('gecko');
	var minVers = isMoz ? 3 : 4;
	return (browserVersion >= minVers) ? 1 : 0;
}

var bVer = parseInt(navigator.appVersion);
var bCanRollover = canRollover(bVer);

function ImageSet(imgID,newTarget)
{
	if (bCanRollover)
		document[imgID].src=newTarget;
}

function gotoDiffLang(workUrl)
{
	window.location=workUrl+'&amp;pageid='+js_gvPageID;
}
var doRefresh = true;
function refreshParent()
{
	if ( self.opener && doRefresh )
	{
		self.opener.location.reload();
	}
	self.close;
}

function getFrameWindow(frameID,frameName)
{
	if (frameID)
		return window.document.getElementById(frameID).contentWindow;
	
	var frames = window.frames;
	for (var i=0; i<frames.length; i++)
	{
		if (frames[i].name == frameName)
			return frames[i];
	}
	return null;
}

function getContentFromChildFrame(frameName,fieldname,formname)
{
   if (formname == null)
		formname = "dlgform";
	var RTEFrame = getFrameWindow(frameName);
	if (RTEFrame && RTEFrame.saveKTML)
		RTEFrame.saveKTML(fieldname); // first call the save function of the KTML
	if (document.getElementById(frameName).contentDocument) { // moz
		var innertbVal = eval("document.getElementById('"+frameName+"').contentDocument."+fieldname+formname+"."+fieldname).value;
	} else { // IE
		var innertbVal = eval("document.frames['"+frameName+"'].document."+fieldname+formname+"."+fieldname).value;
	}
	var tb = eval ('document.' + formname + "." + fieldname);
	
	tb.value = innertbVal;
}
function glblLinkHandler(lobj, attr, val)
{
	lobj.style[attr]=val;
}
// we should replace tons of diff. instances of form validation codes with this one to make 
// sure we do not have diff. implementations for the same task.	
function stringTrim(_this,str) 
{
   if(!str) str = _this;
   return str.replace(/^\s*/,"").replace(/\s*$/,"");
}

function substringReplace(source,pattern,replacement)
{
	var pos = 0;
	var target="";
	while ((pos = source.indexOf(pattern)) != (-1))
	{
		target = target + source.substring(0,pos) + replacement;
		source = source.substring(pos+pattern.length);
		pos = source.indexOf(pattern);
	}
	return (target + source);
}
function cs_decodeURI(res) 
{
	try
	{
		return decodeURI(res);
	}
	catch(e){
		return res;
	}
}
function cs_encodeURI(res) {
	try
	{
		var res = cs_decodeURI(res);
	}
	catch(e){}
	return encodeURI(res);
}