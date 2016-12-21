//Generated:2011-04-27 17:46:26// Flashtalking Standard Flash - Template 2.09 - XRE04 - OOB - XYZ - pl - ftrck
// www: http://www.flashtalking.com
// Date of last revision: 25th August 2010

// (c) Simplicity Marketing Ltd.  Flashtalking is a Trade Mark of Simplicity Marketing Ltd.

var ftRandomNumber_72890=Math.floor(Math.random()*1000000);
var ftexttrack_72890=new Array();
for(var exti_72890=0;exti_72890<ftexttrack_72890.length;exti_72890++){
	ftoutputExtTrack_72890(ftexttrack_72890[exti_72890]);
}
function ftoutputExtTrack_72890(pimg){
	if(pimg!=""){	
		document.write('<div style="position:absolute;"><img style="width:1px; height:1px" src="'+pimg+'?'+ftRandomNumber_72890+'"/></div>');	
	}
}
if(typeof(ft728x90_OOBclickTrack)=="undefined"){
	var ft728x90_OOBclickTrack="";
}
if(typeof(ftConfID_101428)=="undefined"){
	var ftConfID_101428="0";
}
if(typeof(ftGUID_101428)=="undefined"){
	var ftGUID_101428="99999999999999";
}
if(typeof(ftParams_101428)=="undefined"){
	var ftParams_101428="";
}
if(typeof(ftGeoC2_101428)=="undefined"){
	var ftGeoC2_101428="";
	var ftGeoState_101428="";
	var ftGeoCity_101428="";
	var ftISP_101428="";
	var ftSpeed_101428="";
	var ftDMA_101428="";
	var ftLong_101428="";
	var ftLat_101428="";
	var ftPostal_101428="";
}
if(typeof(ftKeyword_101428)=="undefined"){
	var ftKeyword_101428="";
}
if(typeof(ftSegment_101428)=="undefined"){
	var ftSegment_101428="";
}
var ftGeoC2_72890=ftGeoC2_101428;
var ftGeoState_72890=ftGeoState_101428;
var ftGeoCity_72890=ftGeoCity_101428;
var ftISP_72890=ftISP_101428;
var ftSpeed_72890=ftSpeed_101428;
var ftDMA_72890=ftDMA_101428;
var ftLong_72890=ftLong_101428;
var ftLat_72890=ftLat_101428;
var ftPostal_72890=ftPostal_101428;
var ftKeyword_72890=ftKeyword_101428;
var ftSegment_72890=ftSegment_101428;
var ftConfID=ftConfID_101428;
var ftGUID=ftGUID_101428;
var ftParams_72890=ftParams_101428;
var ftCreativeID="172025";
var ftPID="101428";
var ftCID="9500";
var ftLinkMode="0";
var ftLinkID="0";
var ftStatBaseURL="http://stat.flashtalking.com/reportV3/ft.stat?16095210-";
var ftMVT="false";
var ftSetFileSize="20.869140625";
var ftServeDom_72890="http://a.flashtalking.com";
var ftswf="http://a.flashtalking.com/xre/10/101428/172025/swf/728x90_Saab_T1_DifferentLook_ft.swf"; 
var ftgif="http://servedby.flashtalking.com/imp/3/15135;101428;204;jpg;RGM;94XCustomChannelSynchedLeaderboardLifestyleAwareness/?"+ftRandomNumber_72890;
var ftminversion=8;
var ftmaxversion=15;
var ftcreativewidth="728";
var ftcreativeheight="90";
var ftwmode="opaque";
var prefswfhref_72890="http://servedby.flashtalking.com/click/3/15135;101428;172025;211;"+ftConfID_101428+"/?g="+ftGUID_101428+"&random="+ftRandomNumber_72890+"&ft_sgid=489&url=363150";
var prefswfhref1_72890="http://servedby.flashtalking.com/click/3/15135;101428;172025;211;"+ftConfID_101428+"/?g="+ftGUID_101428+"&random="+ftRandomNumber_72890+"&ft_sgid=489&url=363150";



















var altimghref_72890="http://servedby.flashtalking.com/click/3/15135;101428;172025;210;"+ftConfID_101428+"/?g="+ftGUID_101428+"&random="+ftRandomNumber_72890+"&ft_sgid=489&url=363150";
var ftpoliteload_72890=false;
var ftStreamMode_72890=false;
var ftadvload_72890=true;
var ftAbsXPos_72890="";
var ftAbsYPos_72890="";
var ftAbsZ_72890="";
var ftbgcolor="";
var ftAID=1;
var ftimgout_72890=false;
var ftclickstr_72890="";
var ftmaxnumcts=20;
var plugin=false;
var qs1_72890=new Querystring72890();
var ftoobpath_72890="http://a.flashtalking.com/oob/ftoob.html?";
var ftgeostr_72890="";
var browtype_72890=determineBrowser_72890();
var machtype_72890=determineMachineType_72890();
var ftswfid_72890="ftswfid72890";
var t_72890;
ftpoliteload_72890=(ftpoliteload_72890)?"1":"0";
ftStreamMode_72890=(ftStreamMode_72890)?"1":"0";
var ftCustomVars_72890="";
var ftopdivid_72890="ftopdiv_72890";

var ftFoldAdId_101428=ftopdivid_72890;
var ftFoldAdType_101428=1;
var ftFoldAdHeight_101428=parseInt(ftcreativeheight);
var ftStatBaseURL_101428=ftStatBaseURL;
var ftFoldScrAppend_101428=1;

function getElementRef_72890(elementName){
	var elementRef="";
	if(!document.body){
		document.write('<bo'+'dy>');
	}
	if(document.getElementById){
		if(document.getElementById(elementName)){
			elementRef=eval(document.getElementById(elementName));
		}
	}else if(!document.getElementById&&document.all){
		if(eval("window."+elementName)){
			elementRef=eval("window."+elementName);
		}
	}else if(document.layers){
		if(document.layers[elementName]){
			elementRef=eval(document.layers[elementName]);
		}
	}
	return elementRef;
}
function Querystring72890()
{
	var querystring=ftParams_72890;
	querystring=unescape(querystring);
	var args=querystring.split('&');
	for(var i=0;i<args.length;i++)
	{
		var pair=args[i].split('=');
		if(pair.length>1){
			for(var i2=2;i2<pair.length;i2++)
			{
				pair[1]+="="+pair[i2];
			}
		}
		temp=unescape(pair[0]).split('+');
		temp0=temp.join(' ');
		temp=unescape(pair[1]).split('+');
		temp1=temp.join(' ');
		this[temp0]=temp1;
	}
	this.get=Querystring72890_get;
}
function Querystring72890_get(strKey,strDefault)
{
	var value=this[strKey];
	if(value==null){value=strDefault;}
	return value;
}
function vendorclickbasic_72890(){
	var vclick="";
	vclick=qs1_72890.get("click","");
	return vclick;
}
function ftmakeClickStr_72890(num,vclick,oobstr){
	var ct="";
	var str="prefswfhref"+num+"_72890";
	if(eval('typeof('+str+')')!="undefined"){
		ct=eval("prefswfhref"+num+"_72890");
	}
	if(ct!=""){
		if(oobstr==""){
			ftclickstr_72890+="clickTag"+num+"="+escape(vclick+ct)+"&";
		}else{
			ftclickstr_72890+="clickTag"+num+"="+escape(vclick+ftoobpath_72890+oobstr+"fturl="+ct)+"&";
		}
	}
}
function ftvarClickStr_72890(vclick){
	var oobstr="";
	var cts=ftmaxnumcts+1;
	if(ft728x90_OOBclickTrack!=""){
		oobstr="ftoob="+ft728x90_OOBclickTrack+"&";
	}
	ftmakeClickStr_72890("",vclick,oobstr);
	for(var i=1;i<cts;i++){
 		ftmakeClickStr_72890(i,vclick,oobstr);
 	}
}
function ftAbsXY_72890(){
	ftAbsXPos_72890=qs1_72890.get("ftx","");
	ftAbsYPos_72890=qs1_72890.get("fty","");
	ftAbsZ_72890=qs1_72890.get("ftadz","");
	if((ftAbsXPos_72890!="")&&(ftAbsYPos_72890=="")){
		ftAbsYPos_72890="0";
	}
	if((ftAbsYPos_72890!="")&&(ftAbsXPos_72890=="")){
		ftAbsXPos_72890="0";
	}
	if(ftAbsZ_72890!=""){
		ftAbsZ_72890="z-index:"+ftAbsZ_72890+";";
	}
}
function determineMachineType_72890(){
	if(navigator.appVersion.indexOf("Windows")!=-1){
		return "win";
	}
	if(navigator.appVersion.indexOf("Mac")!=-1){
		return "mac";
	}
	return "other";
}
function determineBrowser_72890(){
	if(navigator.appVersion.indexOf("MSIE")!=-1&&navigator.userAgent.indexOf("Opera")<0){
		return "MSIE";
	}
	if((navigator.userAgent.indexOf("Safari")!=-1)&&(navigator.userAgent.indexOf("Chrome")<0)){
		return "sf";
	}
	if(navigator.userAgent.indexOf("Chrome")!=-1){
		return "chrm";
	}
	if(navigator.userAgent.indexOf("Opera")!=-1){
		return "op";
	}
	if(navigator.appName.indexOf("Netscape")!=-1){
		if((navigator.product.indexOf("Gecko")!=-1)&&((navigator.vendor.indexOf("Firefox")!=-1)||navigator.userAgent.indexOf("Firefox")!=-1)){
			return "fx";
		}else{
			return "ntsc";
		}
	}
	return "other";
}
function determineFXVersion_72890(){
	return parseFloat(navigator.userAgent.substr(navigator.userAgent.lastIndexOf("Firefox/") + 8));
}
function ftSendToFlash_72890(){
	var targwin=window;
	var swf=(browtype_72890=="MSIE")?targwin[ftswfid_72890]:targwin.document[ftswfid_72890];
	var isset="0";
	try{
		var isset=swf.politeReady();
		if(isset!="1"){
			setTimeout("ftSendToFlash_72890()",90);
		}
	}catch(e){
		if(isset!="1"){
			setTimeout("ftSendToFlash_72890()",90);
		}
	}
}
function ftaddOnload_72890(){
    if(typeof(window.onload=='function')){
    	var preonload=window.onload;
    	window.onload=function(){ftSendToFlash_72890();if(preonload){preonload();}};
    }else{
    	window.onload=ftSendToFlash_72890;
    }
}
function ftaddAdvancedLoad_72890(){
	if((document.readyState)&&(((browtype_72890!="sf")&&(browtype_72890!="chrm"))&&(browtype_72890!="fx"))){
		ftaddOnreadystatechange_72890('ftcheckload_72890');
	}else{
	if(browtype_72890=="fx"){
			ftcheckfxload_72890();
		}else{
			if((browtype_72890=="sf")||(browtype_72890=="chrm")){
				t_72890=setInterval(function(){if(/loaded|complete/.test(document.readyState)){ftchecksfload_72890();}},10);
			}else{
				ftaddOnload_72890();
			}
		}
	}
}
function ftcheckload_72890(){
	if(document.readyState=="complete"){
		ftSendToFlash_72890();
	}
}
function ftchecksfload_72890(){
	if(t_72890){
		clearInterval(t_72890);
	}
	ftSendToFlash_72890();
}
function ftcheckfxload_72890(){
	if(determineFXVersion_72890()>=3.6){
		if(document.readyState=="complete"){
			ftSendToFlash_72890();
		}else{
			window.addEventListener("DOMContentLoaded", ftSendToFlash_72890, true);
		}
	}else{
		window.addEventListener("DOMContentLoaded", ftSendToFlash_72890, true);
	}
}
function ftaddOnreadystatechange_72890(fname){
   		var fttempstr="";
   		var prefuncstr="";
   		var targwin="window.document";

   		if(typeof eval(targwin+".onreadystatechange")=="undefined"||eval(targwin+".onreadystatechange")==null) {
				prefuncstr="";
  	 }else{
				fttempstr=eval(targwin+".onreadystatechange.toString()");
				prefuncstr=fttempstr.slice((fttempstr.indexOf("{")+1),fttempstr.lastIndexOf("}"));
    	}
   		prefuncstr=prefuncstr+";"+fname+"();";
   		eval("function ftrdystchfuncs_72890(){ "+prefuncstr+"}");
    	try{
   			eval(targwin+'.addEventListener("readystatechange",ftrdystchfuncs_72890,false)');
   		}catch(e){
    		eval(targwin+'.attachEvent("onreadystatechange",ftrdystchfuncs_72890)');
    	}
}
if (((((navigator.appName == "Netscape") && (navigator.userAgent.indexOf("Mozilla") != -1) && (parseFloat(navigator.appVersion) >= 4))||((navigator.userAgent.indexOf("Opera") != -1) && (parseFloat(navigator.appVersion) >= 3))) && navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"] && navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin)) {
var plugname=navigator.plugins['Shockwave Flash'].description;var plugsubstr=plugname.substring((plugname.indexOf("Shockwave Flash")+"Shockwave Flash".length),(plugname.indexOf(".")));
if( plugsubstr >= ftminversion) { plugin = true;}
}
else if (navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0 && (navigator.userAgent.indexOf("Opera")<0) && (navigator.userAgent.indexOf("Windows 95")>=0 || navigator.userAgent.indexOf("Windows 98")>=0 || navigator.userAgent.indexOf("Windows NT")>=0) && document.all) 
{
document.write('<script language=VBScript>' + '\n' +
   'ftmaxversion = '+ftmaxversion + '\n' +
   'ftminversion = '+ftminversion + '\n' +
   'Do' + '\n' +
    'On Error Resume Next' + '\n' +
    'plugin = (IsObject(CreateObject(\"ShockwaveFlash.ShockwaveFlash.\" & ftmaxversion & \"\")))' + '\n' +
    'If plugin = true Then Exit Do' + '\n' +
    'ftmaxversion = ftmaxversion - 1' + '\n' +
    'Loop While ftmaxversion >= ftminversion' + '\n' +
  '<\/script>');
}
ftAbsXY_72890();
var vclick=vendorclickbasic_72890();
if(ft728x90_OOBclickTrack!=""){
	altimghref_72890=ftoobpath_72890+"ftoob="+ft728x90_OOBclickTrack+"fturl="+altimghref_72890;
}
if(ftAbsXPos_72890!=""){
	document.write('<div id="'+ftopdivid_72890+'" style="position:absolute; top:'+ftAbsYPos_72890+'px; left:'+ftAbsXPos_72890+'px; '+ftAbsZ_72890+'">');
}else{
	document.write('<div id="'+ftopdivid_72890+'">');
}
if(plugin){
 ftvarClickStr_72890(vclick);
 if(ftclickstr_72890!=""){
 	ftclickstr_72890=ftclickstr_72890.substr(0,ftclickstr_72890.length-1);
}
 if(ftGeoC2_72890!=""){
		ftgeostr_72890='&ftGeoCountry='+escape(ftGeoC2_72890)+'&ftGeoState='+escape(ftGeoState_72890)+'&ftGeoCity='+escape(ftGeoCity_72890)+'&ftGeoISP='+escape(ftISP_72890)+'&ftGeoSpeed='+escape(ftSpeed_72890)+'&ftDMA='+escape(ftDMA_72890)+'&ftLong='+escape(ftLong_72890)+'&ftLat='+escape(ftLat_72890)+'&ftPostal='+escape(ftPostal_72890);
 }
 	
if(ftCustomVars_72890!=""){
	ftCustomVars_72890='&'+ftCustomVars_72890;
}
 var ftclickTag=ftclickstr_72890+'&creativeID='+escape(ftCreativeID)+'&cID='+escape(ftCID)+'&ftPlacementID='+escape(ftPID)+'&aID='+escape(ftAID)+'&ftSetFileSize='+escape(ftSetFileSize)+'&ftStatBaseURL='+escape(ftStatBaseURL)+'&ftConfID='+escape(ftConfID)+'&ftMVT='+escape(ftMVT)+'&ftGUID='+escape(ftGUID)+'&ftServeDom='+escape(ftServeDom_72890)+'&ftLinkMode='+escape(ftLinkMode)+'&ftLinkID='+escape(ftLinkID)+'&ftPL='+escape(ftpoliteload_72890)+'&ftStreamMode='+escape(ftStreamMode_72890)+'&ftKeyword='+escape(ftKeyword_72890)+'&ftSegment='+escape(ftSegment_72890)+ftgeostr_72890+ftCustomVars_72890;
 document.write('<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=3,0,0,0" ID="'+ftswfid_72890+'" WIDTH="'+ ftcreativewidth +'" HEIGHT="'+ ftcreativeheight +'">');
 document.write('<PARAM NAME=movie VALUE="'+ftswf+'"><PARAM NAME=FlashVars VALUE="'+ftclickTag+'"/><PARAM NAME=quality VALUE=autohigh><PARAM NAME=bgcolor VALUE=#'+ ftbgcolor +'><PARAM NAME=wmode VALUE='+ ftwmode +'><PARAM NAME="allowScriptAccess" value="always">'); 
 document.write('<EMBED src="'+ftswf+'" name="'+ftswfid_72890+'" id="'+ftswfid_72890+'" FlashVars="'+ftclickTag+'" quality=autohigh swLiveConnect=TRUE WIDTH="'+ ftcreativewidth +'" HEIGHT="'+ ftcreativeheight +'" bgcolor=#'+ ftbgcolor+' wmode="'+ftwmode+'" allowScriptAccess="always" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">');
 document.write('</EMBED>');
 document.write('</OBJECT>'); 
 	if(ftpoliteload_72890=="1"){
 		if(!ftadvload_72890){
			ftaddOnload_72890();
		}else{
			ftaddAdvancedLoad_72890();
		}	
	}
}else{
 document.write('<A TARGET="_blank" HREF="'+vclick+altimghref_72890+'"><IMG SRC="' + ftgif + '" BORDER=0></A>');
 ftimgout_72890=true;
}
if(!ftimgout_72890){
//-->
document.write('<NOEMBED><A TARGET=\"_blank\" HREF=\"'+vclick+altimghref_72890+'\"><IMG SRC=\"'+ftgif+'\" BORDER=0></A></NOEMBED>');
}
document.write('</div>');
var ftextscript_72890="";
if(ftextscript_72890!=""){	
	document.write('<div style="position:absolute;"><scr'+'ipt src="'+ftextscript_72890+'?'+ftRandomNumber_72890+'"></scr'+'ipt></div>');	
}



var ftFoldURL_101428="http://a.flashtalking.com/pageFold/ftpagefold_v2-30.js";
ftFoldURL_101428+="#stat="+ftStatBaseURL_101428+"&cfid="+ftConfID_101428+"&guid="+ftGUID_101428+"&adid="+ftFoldAdId_101428+"&adtype="+ftFoldAdType_101428+"&h="+ftFoldAdHeight_101428;
switch(ftFoldScrAppend_101428){
	case 1:
	default:
		document.write('<div style="position:absolute;"><scr'+'ipt src="'+ftFoldURL_101428+'"></scr'+'ipt></div>');
		break;
	case 2:
		var ftFoldobj_101428=document.createElement('script');
		ftFoldobj_101428.src=ftFoldURL_101428;
		document.body.appendChild(ftFoldobj_101428);
		break;
}