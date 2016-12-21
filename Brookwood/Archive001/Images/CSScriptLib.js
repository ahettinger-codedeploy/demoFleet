/* -- Adobe GoLive JavaScript Library */

CSAg = window.navigator.userAgent; CSBVers = parseInt(CSAg.charAt(CSAg.indexOf("/")+1),10);
CSIsW3CDOM = ((document.getElementById) && !(IsIE()&&CSBVers<6)) ? true : false;
function IsIE() { return CSAg.indexOf("MSIE") > 0;}
function CSIEStyl(s) { return document.all.tags("div")[s].style; }
function CSNSStyl(s) { if (CSIsW3CDOM) return document.getElementById(s).style; else return CSFindElement(s,0);  }
CSIImg=false;
function CSInitImgID() {if (!CSIImg && document.images) { for (var i=0; i<document.images.length; i++) { if (!document.images[i].id) document.images[i].id=document.images[i].name; } CSIImg = true;}}
function CSFindElement(n,ly) { if (CSBVers<4) return document[n];
	if (CSIsW3CDOM) {CSInitImgID();return(document.getElementById(n));}
	var curDoc = ly?ly.document:document; var elem = curDoc[n];
	if (!elem) {for (var i=0;i<curDoc.layers.length;i++) {elem=CSFindElement(n,curDoc.layers[i]); if (elem) return elem; }}
	return elem;
}
function CSGetImage(n) {if(document.images) {return ((!IsIE()&&CSBVers<5)?CSFindElement(n,0):document.images[n]);} else {return null;}}
CSDInit=false;
function CSIDOM() { if (CSDInit)return; CSDInit=true; if(document.getElementsByTagName) {var n = document.getElementsByTagName('DIV'); for (var i=0;i<n.length;i++) {CSICSS2Prop(n[i].id);}}}
function CSICSS2Prop(id) { var n = document.getElementsByTagName('STYLE');for (var i=0;i<n.length;i++) { var cn = n[i].childNodes; for (var j=0;j<cn.length;j++) { CSSetCSS2Props(CSFetchStyle(cn[j].data, id),id); }}}
function CSFetchStyle(sc, id) {
	var s=sc; while(s.indexOf("#")!=-1) { s=s.substring(s.indexOf("#")+1,sc.length); if (s.substring(0,s.indexOf("{")).toUpperCase().indexOf(id.toUpperCase())!=-1) return(s.substring(s.indexOf("{")+1,s.indexOf("}")));}
	return "";
}
function CSGetStyleAttrValue (si, id, st) {
	var s=si.toUpperCase();
	var myID=id.toUpperCase()+":";
	var id1=s.indexOf(myID,st);
	if (id1==-1) return "";
	var ch=s.charAt(id1-1);
	if (ch!=" " && ch!="\t" && ch!="\n" && ch!=";" && ch!="{")
		return CSGetStyleAttrValue (si, id, id1+1);
	var start=id1+myID.length;
	ch=s.charAt(start);
	while(ch==" " || ch=="\t" || ch=="\n") {start++; ch=s.charAt(start);}
	s=s.substring(start,si.length);
	var id2=s.indexOf(";");
	return ((id2==-1)?s:s.substring(0,id2));
}
function CSSetCSS2Props(si, id) {
	var el=document.getElementById(id);
	if (el==null) return;
	var style=document.getElementById(id).style;
	if (style) {
		if (style.left=="") style.left=CSGetStyleAttrValue(si,"left",0);
		if (style.top=="") style.top=CSGetStyleAttrValue(si,"top",0);
		if (style.width=="") style.width=CSGetStyleAttrValue(si,"width",0);
		if (style.height=="") style.height=CSGetStyleAttrValue(si,"height",0);
		if (style.visibility=="") style.visibility=CSGetStyleAttrValue(si,"visibility",0);
		if (style.zIndex=="") style.zIndex=CSGetStyleAttrValue(si,"z-index",0);
	}
}
function CSSetStyleVis(s,v) {
	if (CSIsW3CDOM){CSIDOM();document.getElementById(s).style.visibility=(v==0)?"hidden":"visible";}
	else if(IsIE())CSIEStyl(s).visibility=(v==0)?"hidden":"visible";
	else CSNSStyl(s).visibility=(v==0)?'hide':'show';
}
function CSGetStyleVis(s) {
	if (CSIsW3CDOM) {CSIDOM();return(document.getElementById(s).style.visibility=="hidden")?0:1;}
	else if(IsIE())return(CSIEStyl(s).visibility=="hidden")?0:1;
	else return(CSNSStyl(s).visibility=='hide')?0:1;
}
CSInit = new Array;
function CSScriptInit() {
if(typeof(skipPage) != "undefined") { if(skipPage) return; }
idxArray = new Array;
for(var i=0;i<CSInit.length;i++)
	idxArray[i] = i;
CSAction2(CSInit, idxArray);}
CSStopExecution=false;
function CSAction(array) {return CSAction2(CSAct, array);}
function CSAction2(fct, array) { 
	var result;
	for (var i=0;i<array.length;i++) {
		if(CSStopExecution) return false; 
		var aa = fct[array[i]];
		if (aa == null) return false;
		var ta = new Array;
		for(var j=1;j<aa.length;j++) {
			if((aa[j]!=null)&&(typeof(aa[j])=="object")&&(aa[j].length==2)){
				if(aa[j][0]=="VAR"){ta[j]=CSStateArray[aa[j][1]];}
				else{if(aa[j][0]=="ACT"){ta[j]=CSAction(new Array(new String(aa[j][1])));}
				else ta[j]=aa[j];}
			} else ta[j]=aa[j];
		}			
		result=aa[0](ta);
	}
	return result;
}
CSAct = new Object;
CSIm=new Object();
function CSIShow(n,i) {
	if (document.images) {
		if (CSIm[n]) {
			var img=CSGetImage(n);
			if (img&&typeof(CSIm[n][i].src)!="undefined") {img.src=CSIm[n][i].src;}
			if(i!=0) self.status=CSIm[n][3]; else self.status=" ";
			return true;
		}
	}
	return false;
}
function CSILoad(action) {
	im=action[1];
	if (document.images) {
		CSIm[im]=new Object();
		for (var i=2;i<5;i++) {
			if (action[i]!='') {CSIm[im][i-2]=new Image(); CSIm[im][i-2].src=action[i];}
			else CSIm[im][i-2]=0;
		}
		CSIm[im][3] = action[5];
	}
}

function CSClickReturn () {
	var bAgent = window.navigator.userAgent; 
	var bAppName = window.navigator.appName;
	if ((bAppName.indexOf("Explorer") >= 0) && (bAgent.indexOf("Mozilla/3") >= 0) && (bAgent.indexOf("Mac") >= 0))
		return true; /* dont follow link */
	else return false; /* dont follow link */
}
function CSButtonReturn () { return !CSClickReturn(); }

function CSOpenWindow(action) {
	var wf = "";	
	wf = wf + "width=" + action[3];
	wf = wf + ",height=" + action[4];
	wf = wf + ",resizable=" + (action[5] ? "yes" : "no");
	wf = wf + ",scrollbars=" + (action[6] ? "yes" : "no");
	wf = wf + ",menubar=" + (action[7] ? "yes" : "no");
	wf = wf + ",toolbar=" + (action[8] ? "yes" : "no");
	wf = wf + ",directories=" + (action[9] ? "yes" : "no");
	wf = wf + ",location=" + (action[10] ? "yes" : "no");
	wf = wf + ",status=" + (action[11] ? "yes" : "no");		
	window.open(action[1],action[2],wf);
}

function CSCloseWindow() { 
if (self.parent.frames.length != 0) {
	self.parent.close()	
	} else {
	window.close()
	}
}

function CSShowHide(action) {
	if (action[1] == '') return;
	var type=action[2];
	if(type==0) CSSetStyleVis(action[1],0);
	else if(type==1) CSSetStyleVis(action[1],1);
	else if(type==2) { 
		if (CSGetStyleVis(action[1]) == 0) CSSetStyleVis(action[1],1);
		else CSSetStyleVis(action[1],0);
	}
}

// OUT PNG library 1.0.7
// Script copyright 2004 OUT Media Design GmbH. All rights reserved.

function OUTpngBrowserCheck(){
// Code partially taken from:
// Browser Detect Lite  v2.1 <http://www.dithered.com/javascript/browser_detect/index.html>
// modified by Chris Nott (chris@NOSPAMdithered.com - remove NOSPAM)
// modified by Oliver Zahorka
	var ua=navigator.userAgent.toLowerCase(); 
	this.ua=ua;
	// browser name
	this.isGecko=(ua.indexOf('gecko')>=0);
	this.isMozilla=(this.isGecko && ua.indexOf("gecko/")+14 == ua.length);
	this.isNS=((this.isGecko)?(ua.indexOf('netscape')>=0):((ua.indexOf('mozilla')>=0) && (ua.indexOf('spoofer')<0) && (ua.indexOf('compatible')<0) && (ua.indexOf('opera')<0) && (ua.indexOf('webtv')<0) && (ua.indexOf('hotjava')<0)));
	this.isIE=((ua.indexOf("msie")>=0) && (ua.indexOf("opera")<0) && (ua.indexOf("webtv")<0)); 
	this.isOpera=(ua.indexOf("opera")>=0); 
	this.isAol=(ua.indexOf("aol")>=0); 
	// browser version
	this.vers=parseFloat(navigator.appVersion); 
	// correct version number for NS6+ 
	if (this.isNS && this.isGecko){this.vers=parseFloat(ua.substring(ua.lastIndexOf('/')+1));}
	// correct version number for IE4+ 
	else if (this.isIE && this.vers >= 4){this.vers=parseFloat(ua.substring(ua.indexOf('msie ')+5));}
	// correct version number for Opera 
	else if (this.isOpera){if (ua.indexOf('opera/')>=0){this.vers=parseFloat(ua.substring(ua.indexOf('opera/')+6));}else{this.vers=parseFloat(ua.substring(ua.indexOf('opera ')+6));}}
	// platform
	this.isWin  =(ua.indexOf('win')>=0);
	this.isMac  =(ua.indexOf('mac')>=0);
	this.isUnix =(ua.indexOf('unix')>=0 || ua.indexOf('linux')>=0 || ua.indexOf('sunos')>=0 || ua.indexOf('bsd')>=0 || ua.indexOf('x11')>=0)
}

function OUTcheckPNGSupport()
{
	var b=new OUTpngBrowserCheck();
	// support for PNG via AlphaImageLoader, if is IE5.5+ on windows; set flag to 1
	if (b.isIE && b.vers>=5.5) return 1;
	// no support for PNG; set flag to -1 for Opera < 6 on Win/Unix, Opera < 5 on Mac, Netscape < 5, AOL
	else if ((b.isIE && b.isWin) || (b.isIE && b.isMac && b.vers < 5) || (b.isOpera && (b.isWin || b.isUnix) && b.vers < 6) || (b.isOpera && b.isMac && b.vers < 5) || (b.isNS && b.vers < 5) || b.isAol) return -1;
	// support for PNG right away; set flag to 0 for all others
	else return 0;
}

var OUTpngSupport=OUTcheckPNGSupport();

function OUTisPNGsrc(s,n){s=s.toLowerCase();n="."+n.toLowerCase();return s.lastIndexOf(n)==(s.length-n.length);}

function OUTpngImgReplace(img,isrc,psrc,rsrc){
	if (OUTpngSupport>0 && psrc && psrc!="#" && isrc && isrc!="#"){
		img.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+isrc+"', sizingMethod='scale')";
		img.src=psrc;
	}
	if(OUTpngSupport<0 && rsrc && rsrc!="#"){img.src=rsrc;}
	if(OUTpngSupport==0 && isrc && isrc!="#" && img.src!=isrc){img.src=isrc;}
}

function OUTpngCSILoadTrans(s) {if(typeof(CSIm)!="undefined"){for(var n in CSIm){CSIm[n][4]=new Image();CSIm[n][4].src=s;}}}

function OUTpngCSIShow(n,i) {
	if (document.images) {
		if (CSIm[n]) {
			var img=CSGetImage(n);
			if (img&&typeof(CSIm[n][i].src)!="undefined") {
				if(!OUTisPNGsrc(CSIm[n][i].src,"png")) img.src=CSIm[n][i].src;
				else OUTpngImgReplace(img,CSIm[n][i].src,CSIm[n][4].src,"#")
			}
			if(i!=0) self.status=CSIm[n][3]; else self.status=" ";
			return true;
		}
	}
	return false;
}

function OUTpngRolloverInit(a) {OUTpngCSILoadTrans(a[1]); if(typeof(CSIShow)!="undefined" && OUTpngCSIShow)CSIShow=OUTpngCSIShow;}

//
// OUT PNG Transparency for IE 1.0.6
// Script copyright 2004 OUT Media Design GmbH. All rights reserved.

function OUTpngIEBgReplace(style,s,m){
	style.backgroundImage="";
	style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+s+"', sizingMethod='"+m+"')";
}

function OUTiePNGimgXparency(a) {
	/* check browser */
	if (OUTpngSupport>0){
		/* add Smart Rollover support */
		OUTpngRolloverInit(a);
		/* replace img */
		if(document.images){
			for (var i=0;i<document.images.length;i++) {
				var img=document.images[i];
				if(img&&OUTisPNGsrc(img.src,a[2]))OUTpngImgReplace(img,img.src,a[1],"#");
			}
		}
		/* replace style backgrounds */
		if (a[3] && document.all) {
			for(var i=0;i<document.all.length;i++){
			 	var e=document.all[i],s=null;
			 	if (e.background) s=e.background;
			 	else if (e.style && e.style.backgroundImage) {
			 		s=e.style.backgroundImage;
			 		s=s.substr(4,s.length-5);
			 	}
			 	if(s&&OUTisPNGsrc(s,a[2])){e.background="";OUTpngIEBgReplace(e.style,s,a[4]);}
			}
		}
		/* replace css backgrounds */
		if (a[5] && document.styleSheets) {
			for (var j=0; j<document.styleSheets.length; j++){
				for(var i=0;i<document.styleSheets[j].rules.length;i++){
				 	var e=document.styleSheets[j].rules[i],s=null;
				 	if (e.style && e.style.backgroundImage) {
				 		s=e.style.backgroundImage;
				 		s=s.substr(4,s.length-5);
				 	}
				 	if(s&&OUTisPNGsrc(s,a[2]))OUTpngIEBgReplace(e.style,s,a[6]);
				}
			}
		}
	}
}
//
//-->


