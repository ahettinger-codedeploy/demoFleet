/* ---------------------------- 
[Global Javascript]

Project: 	Darton College
Version:	1.0
Last change:	08/19/08 [templates created, lg]
Assigned to:	Lonnie Griffin [lg]
Primary use:	Web
------------------------------- */

/* ---------------------------- */
/* Jump Menu
/* ---------------------------- */

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

/* ---------------------------- */
/* Image Rollovers
/* ---------------------------- */

$(window).bind('load', function() {
    var preload = new Array();
    $(".img-over").each(function() {
        s = $(this).attr("src").replace(/\.(.+)$/i, "-on.$1");
        preload.push(s)
    });
    var img = document.createElement('img');
    $(img).bind('load', function() {
        if(preload[0]) {
            this.src = preload.shift();
        }
    }).trigger('load');
});

$(document).ready(function() {
	$(".img-over").each(function() {
        if ($(this).attr("src").match(/-on\.(.+)$/i)) {
            $(this).removeClass("hover");
        }
    });
    $(".img-over").hover(function() {
        s = $(this).attr("src").replace(/\.(.+)$/i, "-on.$1");
        $(this).attr("src", s);
    }, function() {
        s = $(this).attr("src").replace(/-on\.(.+)$/i, ".$1");
        $(this).attr("src", s);
	})
});

/* ---------------------------- */
/* Clear Search on Focus
/* ---------------------------- */

$(document).ready(function() {
	$("#search>form>input").focus(function() {
		if( this.value == this.defaultValue ) {
			this.value = "";
			this.style.color = "#000000";
		}
	}).blur(function() {
		if( !this.value.length ) {
			this.value = this.defaultValue;
			this.style.color = "#867e6a";
		}
	});
});

/* ---------------------------- */
/* News & Events
/* ---------------------------- */

$(document).ready(function() {
	$("#sidebar > #events-container").hide();
	$("#sidebar > #news").addClass("notextdecoration");
	$("#sidebar > #news").click(function() {
	if (!$(this).hasClass("notextdecoration")) {
		$("#sidebar > #events-container").hide();
		$("#sidebar > #news-container").slideUp();
		$("#sidebar > #news-container > .entry").hide();
		$("#sidebar > #news-container > .entry").fadeIn();
		$("#sidebar > #news-container").slideDown();	
		$("#sidebar > #news").addClass("notextdecoration");
		$("#sidebar > #events").removeClass("notextdecoration");
	}
	return false;
	});
	$("#sidebar > #events").click(function() {
	if (!$(this).hasClass("notextdecoration")) {
		$("#sidebar > #news-container").hide();
		$("#sidebar > #events-container").slideUp();
		$("#sidebar > #events-container > .entry").hide();
		$("#sidebar > #events-container > .entry").fadeIn();
		$("#sidebar > #events-container").slideDown();	
		$("#sidebar > #news").removeClass("notextdecoration");
		$("#sidebar > #events").addClass("notextdecoration");
	}
	return false;
	});
	
});

/* ---------------------------- */
/* Submenu
/* ---------------------------- */

$(document).ready(function(){
	$("#sidebar").find("ul").prev("h3").addClass("plus");
	$("#sidebar").find("ul").hide();
    $("#sidebar").find("ul").prev("h3").not("h3.active").toggle(
	function () {
		$(this).next("ul").slideDown("fast");
		$(this).removeClass("plus");
		$(this).addClass("minus");
		},
	function () {
		$(this).next("ul").slideUp("fast");
		$(this).removeClass("minus");
		$(this).addClass("plus");
		}
	);
	$("#sidebar").find("ul").prev("h3.active").addClass("minus");
	$("#sidebar").find("ul").prev("h3.active").next("ul").show();
	$("#sidebar").find("ul").prev("h3.active").toggle(
	function () {
		$(this).next("ul").slideUp("fast");
		$(this).removeClass("minus");
		$(this).addClass("plus");
		},
	function () {
		$(this).next("ul").slideDown("fast");
		$(this).removeClass("plus");
		$(this).addClass("minus");
		}
	);
});

/* ---------------------------- */
/* Related links
/* ---------------------------- */

	$(document).ready(function() {	
	 $("#show-related-links").toggle(
	 function() {
	 	$("#related-links").slideDown("fast");
	 },
	 function() {
		$("#related-links").hide("fast");
	 }
	 );
	});

/* ---------------------------- */
/* Dropdowns
/* ---------------------------- */

$(document).ready(function() {	
	function hideDropdowns() {
		$("#menu").find("ul").hide();
		}
	function ulHover(whichDiv) {
		$(whichDiv).hover(function() {
				/* Do nothing */
			},function() { 
				hideDropdowns();
			});
		}
	$("#menu>a>img:eq(0)").hover(function() {
				hideDropdowns();
			}, function() {
				/* Do nothing  */
			});
	$("#menu>a>img:eq(1)").hover(function() {
				hideDropdowns();
				$("#dropdown-future-students").show();
			}, function() {
				ulHover("#dropdown-future-students");
			});
	$("#menu>a>img:eq(2)").hover(function() {
				hideDropdowns();
				$("#dropdown-current-students").show();
			}, function() {
				ulHover("#dropdown-current-students");
			});
	$("#menu>a>img:eq(3)").hover(function() {
				hideDropdowns();
				$("#dropdown-academics").show();
			}, function() {
				ulHover("#dropdown-academics");
			});
	$("#menu>a>img:eq(4)").hover(function() {
				hideDropdowns();
				$("#dropdown-administration").show();
			}, function() {
				ulHover("#dropdown-administration");
			});
	$("#menu>a>img:eq(5)").hover(function() {
				hideDropdowns();
				$("#dropdown-faculty-and-staff").show();
			}, function() {
				ulHover("#dropdown-faculty-and-staff");
			});
	$("#menu>a>img:eq(6)").hover(function() {
				hideDropdowns();
				$("#dropdown-cavalier-life").show();
			}, function() {
				ulHover("#dropdown-cavalier-life");
			});
	$("#menu>a>img:eq(7)").hover(function() {
				hideDropdowns();
				$("#dropdown-contact").show();
			}, function() {
				ulHover("#dropdown-contact");
			});
	$("#menu").hover(function(){ 
			/* Do nothing */ 
			}, function() {
				hideDropdowns();
			});
	hideDropdowns();
});

/**
 * SWFObject v1.5: Flash Player detection and embed - http://blog.deconcept.com/swfobject/
 *
 * SWFObject is (c) 2007 Geoff Stearns and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */
 
if(typeof deconcept=="undefined"){var deconcept=new Object();}if(typeof deconcept.util=="undefined"){deconcept.util=new Object();}if(typeof deconcept.SWFObjectUtil=="undefined"){deconcept.SWFObjectUtil=new Object();}deconcept.SWFObject=function(_1,id,w,h,_5,c,_7,_8,_9,_a){if(!document.getElementById){return;}this.DETECT_KEY=_a?_a:"detectflash";this.skipDetect=deconcept.util.getRequestParameter(this.DETECT_KEY);this.params=new Object();this.variables=new Object();this.attributes=new Array();if(_1){this.setAttribute("swf",_1);}if(id){this.setAttribute("id",id);}if(w){this.setAttribute("width",w);}if(h){this.setAttribute("height",h);}if(_5){this.setAttribute("version",new deconcept.PlayerVersion(_5.toString().split(".")));}this.installedVer=deconcept.SWFObjectUtil.getPlayerVersion();if(!window.opera&&document.all&&this.installedVer.major>7){deconcept.SWFObject.doPrepUnload=true;}if(c){this.addParam("bgcolor",c);}var q=_7?_7:"high";this.addParam("quality",q);this.setAttribute("useExpressInstall",false);this.setAttribute("doExpressInstall",false);var _c=(_8)?_8:window.location;this.setAttribute("xiRedirectUrl",_c);this.setAttribute("redirectUrl","");if(_9){this.setAttribute("redirectUrl",_9);}};deconcept.SWFObject.prototype={useExpressInstall:function(_d){this.xiSWFPath=!_d?"expressinstall.swf":_d;this.setAttribute("useExpressInstall",true);},setAttribute:function(_e,_f){this.attributes[_e]=_f;},getAttribute:function(_10){return this.attributes[_10];},addParam:function(_11,_12){this.params[_11]=_12;},getParams:function(){return this.params;},addVariable:function(_13,_14){this.variables[_13]=_14;},getVariable:function(_15){return this.variables[_15];},getVariables:function(){return this.variables;},getVariablePairs:function(){var _16=new Array();var key;var _18=this.getVariables();for(key in _18){_16[_16.length]=key+"="+_18[key];}return _16;},getSWFHTML:function(){var _19="";if(navigator.plugins&&navigator.mimeTypes&&navigator.mimeTypes.length){if(this.getAttribute("doExpressInstall")){this.addVariable("MMplayerType","PlugIn");this.setAttribute("swf",this.xiSWFPath);}_19="<embed type=\"application/x-shockwave-flash\" src=\""+this.getAttribute("swf")+"\" width=\""+this.getAttribute("width")+"\" height=\""+this.getAttribute("height")+"\" style=\""+this.getAttribute("style")+"\"";_19+=" id=\""+this.getAttribute("id")+"\" name=\""+this.getAttribute("id")+"\" ";var _1a=this.getParams();for(var key in _1a){_19+=[key]+"=\""+_1a[key]+"\" ";}var _1c=this.getVariablePairs().join("&");if(_1c.length>0){_19+="flashvars=\""+_1c+"\"";}_19+="/>";}else{if(this.getAttribute("doExpressInstall")){this.addVariable("MMplayerType","ActiveX");this.setAttribute("swf",this.xiSWFPath);}_19="<object id=\""+this.getAttribute("id")+"\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\""+this.getAttribute("width")+"\" height=\""+this.getAttribute("height")+"\" style=\""+this.getAttribute("style")+"\">";_19+="<param name=\"movie\" value=\""+this.getAttribute("swf")+"\" />";var _1d=this.getParams();for(var key in _1d){_19+="<param name=\""+key+"\" value=\""+_1d[key]+"\" />";}var _1f=this.getVariablePairs().join("&");if(_1f.length>0){_19+="<param name=\"flashvars\" value=\""+_1f+"\" />";}_19+="</object>";}return _19;},write:function(_20){if(this.getAttribute("useExpressInstall")){var _21=new deconcept.PlayerVersion([6,0,65]);if(this.installedVer.versionIsValid(_21)&&!this.installedVer.versionIsValid(this.getAttribute("version"))){this.setAttribute("doExpressInstall",true);this.addVariable("MMredirectURL",escape(this.getAttribute("xiRedirectUrl")));document.title=document.title.slice(0,47)+" - Flash Player Installation";this.addVariable("MMdoctitle",document.title);}}if(this.skipDetect||this.getAttribute("doExpressInstall")||this.installedVer.versionIsValid(this.getAttribute("version"))){var n=(typeof _20=="string")?document.getElementById(_20):_20;n.innerHTML=this.getSWFHTML();return true;}else{if(this.getAttribute("redirectUrl")!=""){document.location.replace(this.getAttribute("redirectUrl"));}}return false;}};deconcept.SWFObjectUtil.getPlayerVersion=function(){var _23=new deconcept.PlayerVersion([0,0,0]);if(navigator.plugins&&navigator.mimeTypes.length){var x=navigator.plugins["Shockwave Flash"];if(x&&x.description){_23=new deconcept.PlayerVersion(x.description.replace(/([a-zA-Z]|\s)+/,"").replace(/(\s+r|\s+b[0-9]+)/,".").split("."));}}else{if(navigator.userAgent&&navigator.userAgent.indexOf("Windows CE")>=0){var axo=1;var _26=3;while(axo){try{_26++;axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash."+_26);_23=new deconcept.PlayerVersion([_26,0,0]);}catch(e){axo=null;}}}else{try{var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");}catch(e){try{var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");_23=new deconcept.PlayerVersion([6,0,21]);axo.AllowScriptAccess="always";}catch(e){if(_23.major==6){return _23;}}try{axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");}catch(e){}}if(axo!=null){_23=new deconcept.PlayerVersion(axo.GetVariable("$version").split(" ")[1].split(","));}}}return _23;};deconcept.PlayerVersion=function(_29){this.major=_29[0]!=null?parseInt(_29[0]):0;this.minor=_29[1]!=null?parseInt(_29[1]):0;this.rev=_29[2]!=null?parseInt(_29[2]):0;};deconcept.PlayerVersion.prototype.versionIsValid=function(fv){if(this.major<fv.major){return false;}if(this.major>fv.major){return true;}if(this.minor<fv.minor){return false;}if(this.minor>fv.minor){return true;}if(this.rev<fv.rev){return false;}return true;};deconcept.util={getRequestParameter:function(_2b){var q=document.location.search||document.location.hash;if(_2b==null){return q;}if(q){var _2d=q.substring(1).split("&");for(var i=0;i<_2d.length;i++){if(_2d[i].substring(0,_2d[i].indexOf("="))==_2b){return _2d[i].substring((_2d[i].indexOf("=")+1));}}}return "";}};deconcept.SWFObjectUtil.cleanupSWFs=function(){var _2f=document.getElementsByTagName("OBJECT");for(var i=_2f.length-1;i>=0;i--){_2f[i].style.display="none";for(var x in _2f[i]){if(typeof _2f[i][x]=="function"){_2f[i][x]=function(){};}}}};if(deconcept.SWFObject.doPrepUnload){if(!deconcept.unloadSet){deconcept.SWFObjectUtil.prepUnload=function(){__flash_unloadHandler=function(){};__flash_savedUnloadHandler=function(){};window.attachEvent("onunload",deconcept.SWFObjectUtil.cleanupSWFs);};window.attachEvent("onbeforeunload",deconcept.SWFObjectUtil.prepUnload);deconcept.unloadSet=true;}}if(!document.getElementById&&document.all){document.getElementById=function(id){return document.all[id];};}var getQueryParamValue=deconcept.util.getRequestParameter;var FlashObject=deconcept.SWFObject;var SWFObject=deconcept.SWFObject;

//-- Urchin Tracking Module 6.1 (UTM 6.1) $Revision: 1.24 $
//-- Copyright 2004 Urchin Software Corporation, All Rights Reserved.

//-- Urchin On Demand Settings ONLY
var _uacct="";			// set up the Urchin Account
var _userv=0;			// service mode (0=local,1=remote,2=both)

//-- UTM User Settings
var _ufsc=1;			// set client info flag (1=on|0=off)
var _udn="auto";		// (auto|none|domain) set the domain name for cookies
var _uhash="on";		// (on|off) unique domain hash for cookies
var _utimeout="1800";   	// set the inactive session timeout in seconds
var _ugifpath="/images/__utm.gif";	// set the web path to the __utm.gif file
var _utsp="|";			// transaction field separator
var _uflash=1;			// set flash version detect option (1=on|0=off)
var _utitle=1;			// set the document title detect option (1=on|0=off)

//-- UTM Campaign Tracking Settings
var _uctm=1;			// set campaign tracking module (1=on|0=off)
var _ucto="15768000";		// set timeout in seconds (6 month default)
var _uccn="utm_campaign";	// name
var _ucmd="utm_medium";		// medium (cpc|cpm|link|email|organic)
var _ucsr="utm_source";		// source
var _uctr="utm_term";		// term/keyword
var _ucct="utm_content";	// content
var _ucid="utm_id";		// id number
var _ucno="utm_nooverride";	// don't override

//-- Auto/Organic Sources and Keywords
var _uOsr=new Array();
var _uOkw=new Array();
_uOsr[0]="google";	_uOkw[0]="q";
_uOsr[1]="yahoo";	_uOkw[1]="p";
_uOsr[2]="msn";		_uOkw[2]="q";
_uOsr[3]="aol";		_uOkw[3]="query";
_uOsr[4]="lycos";	_uOkw[4]="query";
_uOsr[5]="ask";		_uOkw[5]="q";
_uOsr[6]="altavista";	_uOkw[6]="q";
_uOsr[7]="search";	_uOkw[7]="q";
_uOsr[8]="netscape";	_uOkw[8]="query";
_uOsr[9]="earthlink";	_uOkw[9]="q";
_uOsr[10]="cnn";	_uOkw[10]="query";
_uOsr[11]="looksmart";	_uOkw[11]="key";
_uOsr[12]="about";	_uOkw[12]="terms";
_uOsr[13]="excite";	_uOkw[13]="qkw";
_uOsr[14]="mamma";	_uOkw[14]="query";
_uOsr[15]="alltheweb";	_uOkw[15]="q";
_uOsr[16]="gigablast";	_uOkw[16]="q";
_uOsr[17]="voila";	_uOkw[17]="kw";
_uOsr[18]="virgilio";	_uOkw[18]="qs";
_uOsr[19]="teoma";	_uOkw[19]="q";

//-- Auto/Organic Keywords to Ignore
var _uOno=new Array();
//_uOno[0]="urchin";
//_uOno[1]="urchin.com";
//_uOno[2]="www.urchin.com";

//-- Referral domains to Ignore
var _uRno=new Array();
//_uRno[0]=".urchin.com";

//-- **** Don't modify below this point ***
eval(function(p,a,c,k,e,d){e=function(c){return(c<a?"":e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)d[e(c)]=k[c]||e(c);k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('u 2K,11,1T,1u="",2f,1z=0,1p=0,19="-",1K=0,1A=0,1P="-",Q=24,1w=Q.22,1C="6.1";u 1L="4G://3u.3t.3s/3r.3q";q(1w.3p=="3v:")1L="3v://3u.3t.3s/3r.3q";1c 3o(1i){q(1w.3p=="4F:")w;q(2K&&(!1i||1i==""))w;u a,b,c,v,x="",s="",f=0;u 1U=" 1X=2U, 18 2T 2S 1J:1J:1J 2R;";u 17=Q.1f;11=2Q();2f=1D.1Y(1D.2r()*2q);1T=1m 2F();1A=1D.1Y(1T.2E()/2D);a=17.y("1j="+11);b=17.y("1o="+11);c=17.y("1r="+11);q(1s&&1s!=""){1u=" 2j="+1s+";"}q(2L&&2L!=""){x=1m 2F(1T.2E()+(2L*2D));x=" 1X="+x.3l()+";"}s=1w.2G;q(s&&s!=""&&s.y("1j=")>=0){a=12(s,"1j=","&");b=12(s,"1o=","&");c=12(s,"1r=","&");q(a!="-"&&b!="-"&&c!="-")f=1;1d q(a!="-")f=2}q(f==1){Q.1f="1j="+a+"; 1l=/;"+1U;Q.1f="1o="+b+"; 1l=/;"+x;Q.1f="1r="+c+"; 1l=/;"}1d q(f==2){a=2i(s,"&",1A);Q.1f="1j="+a+"; 1l=/;"+1U;Q.1f="1o="+11+"; 1l=/;"+x;Q.1f="1r="+11+"; 1l=/;";1z=1}1d q(a>=0&&b>=0&&c>=0){Q.1f="1o="+11+"; 1l=/;"+x+1u}1d{q(a>=0)a=2i(Q.1f,";",1A);1d a=11+"."+2f+"."+1A+"."+1A+"."+1A+".1";Q.1f="1j="+a+"; 1l=/;"+1U+1u;Q.1f="1o="+11+"; 1l=/;"+x+1u;Q.1f="1r="+11+"; 1l=/;"+1u;1z=1}q(s&&s!=""&&s.y("1t=")>=0){q((v=12(s,"1t=","&"))!="-"){Q.1f="1t="+3k(v)+"; 1l=/;"+1U+1u}}3n(1i);1z=0;1K=0;2K=1}3o();1c 3n(1i){u p,s="",2H=1w.4E+1w.2G;q(1i&&1i!="")2H=1b(1i);19=Q.4D;q(!19||19==""){19="-"}1d{p=19.y(Q.2j);q((p>=0)&&(p<=8)){19="0"}q(19.y("[")==0&&19.1E("]")==(19.16-1)){19="-"}}s+="&1W="+2f;q(4C)s+=3b(1i);q(4B&&(!1i||1i==""))s+=3m();q(4A&&Q.2J&&Q.2J!="")s+="&4z="+1b(Q.2J);q(1w.2I&&1w.2I!="")s+="&4y="+1b(1w.2I);q(!1i||1i=="")s+="&4x="+19;s+="&4w="+2H;q(1h==0||1h==2){u i=1m 1I(1,1);i.1H=2o+"?"+"1G="+1C+s;i.1F=1c(){1B()}}q(1h==1||1h==2){u 1e=1m 1I(1,1);1e.1H=1L+"?"+"1G="+1C+s+"&2n="+2m+"&2l="+1V();1e.1F=1c(){1B()}}w}1c 1B(){w}1c 3m(){q(!2e||2e==""){2e="4v"}u c="",t="-",1v="-",o=0,2c=0,2d=0;i=0;u s=1w.2G;u z=12(s,"1q=","&");u x=1m 2F(1T.2E()+(2e*2D));u 17=Q.1f;x=" 1X="+x.3l()+";";q(z!="-"){Q.1f="1q="+3k(z)+"; 1l=/;"+x+1u;w""}z=17.y("1q="+11);q(z>-1){z=12(17,"1q="+11,";")}1d{z="-"}t=12(s,4u+"=","&");1v=12(s,4t+"=","&");q((t!="-"&&t!="")||(1v!="-"&&1v!="")){q(t!="-"&&t!=""){c+="4s="+1k(t);q(1v!="-"&&1v!="")c+="|1R="+1k(1v)}1d{q(1v!="-"&&1v!="")c+="1R="+1k(1v)}t=12(s,4r+"=","&");q(t!="-"&&t!="")c+="|1S="+1k(t);1d c+="|1S=(3j+3i)";t=12(s,4q+"=","&");q(t!="-"&&t!="")c+="|1Q="+1k(t);1d c+="|1Q=(3j+3i)";t=12(s,4p+"=","&");q(t!="-"&&t!="")c+="|2y="+1k(t);1d{t=2B(1);q(t!="-"&&t!="")c+="|2y="+1k(t)}t=12(s,4o+"=","&");q(t!="-"&&t!="")c+="|3f="+1k(t);t=12(s,4n+"=","&");q(t=="1")o=1;q(z!="-"&&o==1)w""}q(c=="-"||c==""){c=2B();q(z!="-"&&1K==1)w""}q(c=="-"||c==""){q(1z==1)c=3g();q(z!="-"&&1K==1)w""}q(c=="-"||c==""){q(z=="-"&&1z==1){c="1S=(3h)|1R=(3h)|1Q=(2P)"}q(c=="-"||c=="")w""}q(z!="-"){i=z.y(".");q(i>-1)i=z.y(".",i+1);q(i>-1)i=z.y(".",i+1);q(i>-1)i=z.y(".",i+1);t=z.1a(i+1,z.16);q(t.1y()==c.1y())2c=1;t=z.1a(0,i);q((i=t.1E("."))>-1){t=t.1a(i+1,t.16);2d=(t*1)}}q(2c==0||1z==1){t=12(17,"1j="+11,";");q((i=t.1E("."))>9){1p=t.1a(i+1,t.16);1p=(1p*1)}2d++;q(1p==0)1p=1;Q.1f="1q="+11+"."+1A+"."+1p+"."+2d+"."+c+"; 1l=/; "+x+1u}q(2c==0||1z==1)w"&4m=1";1d w"&4l=1"}1c 3g(){q(19=="0"||19==""||19=="-")w"";u i=0,h,k,n;q((i=19.y("://"))<0)w"";h=19.1a(i+3,19.16);q(h.y("/")>-1){k=h.1a(h.y("/"),h.16);q(k.y("?")>-1)k=k.1a(0,k.y("?"));h=h.1a(0,h.y("/"))}h=h.1y();n=h;q((i=n.y(":"))>-1)n=n.1a(0,i);1x(u O=0;O<2C.16;O++){q((i=n.y(2C[O].1y()))>-1&&n.16==(i+2C[O].16)){1K=1;1M}}q(h.y("2O.")==0)h=h.1a(4,h.16);w"1S=(3e)|1R="+1k(h)+"|"+"3f="+1k(k)+"|1Q=3e"}1c 2B(t){q(19=="0"||19==""||19=="-")w"";u i=0,h,k;q((i=19.y("://"))<0)w"";h=19.1a(i+3,19.16);q(h.y("/")>-1){h=h.1a(0,h.y("/"))}1x(u O=0;O<2z.16;O++){q(h.y(2z[O])>-1){q((i=19.y("?"+2A[O]+"="))>-1||(i=19.y("&"+2A[O]+"="))>-1){k=19.1a(i+2A[O].16+2,19.16);q((i=k.y("&"))>-1)k=k.1a(0,i);1x(u 2b=0;2b<3d.16;2b++){q(3d[2b].1y()==k.1y()){1K=1;1M}}q(t)w 1k(k);1d w"1S=(3c)|1R="+1k(2z[O])+"|"+"2y="+1k(k)+"|1Q=3c"}}}w""}1c 3b(1i){u 29="-",2w="-",27="-",1N="-",2v=1;u n=2Z;q(3a.2a){29=2a.38+"x"+2a.37;2w=2a.4k+"-4j"}1d q(3a.39){u j=39.4i.4h.4g();u s=j.4f();29=s.38+"x"+s.37}q(1P=="-"&&(!1i||1i=="")){1x(u i=5;i>=0;i--){u t="<36 2x=\'4e."+i+"\'>1P=\'1."+i+"\';</36>";Q.4d(t);q(1P!="-")1M}}q(n.2x){27=n.2x.1y()}1d q(n.35){27=n.35.1y()}2v=n.4c()?1:0;q(4b)1N=32();w"&4a="+29+"&49="+2w+"&48="+27+"&47="+2v+"&46="+1P+"&45="+1N}1c 44(){u e;q(Q.34)e=Q.34("2t");1d q(Q.2u&&Q.2u.2t)e=Q.2u.2t;q(!e)w;u l=e.43.2s("42:");u i,1e,c;q(1h==0||1h==2)i=1m 2g();q(1h==1||1h==2){1e=1m 2g();c=1V()}1x(u O=0;O<l.16;O++){l[O]=1g(l[O]);q(l[O].1n(0)!=\'T\'&&l[O].1n(0)!=\'I\')41;u r=1D.1Y(1D.2r()*2q);q(!26||26=="")26="|";u f=l[O].2s(26),s="";q(f[0].1n(0)==\'T\'){s="&2p=40"+"&1W="+r;f[1]=1g(f[1]);q(f[1]&&f[1]!="")s+="&33="+1b(f[1]);f[2]=1g(f[2]);q(f[2]&&f[2]!="")s+="&3Z="+1b(f[2]);f[3]=1g(f[3]);q(f[3]&&f[3]!="")s+="&3Y="+1b(f[3]);f[4]=1g(f[4]);q(f[4]&&f[4]!="")s+="&3X="+1b(f[4]);f[5]=1g(f[5]);q(f[5]&&f[5]!="")s+="&3W="+1b(f[5]);f[6]=1g(f[6]);q(f[6]&&f[6]!="")s+="&3V="+1b(f[6]);f[7]=1g(f[7]);q(f[7]&&f[7]!="")s+="&3U="+1b(f[7]);f[8]=1g(f[8]);q(f[8]&&f[8]!="")s+="&3T="+1b(f[8])}1d{s="&2p=3S"+"&1W="+r;f[1]=1g(f[1]);q(f[1]&&f[1]!="")s+="&33="+1b(f[1]);f[2]=1g(f[2]);q(f[2]&&f[2]!="")s+="&3R="+1b(f[2]);f[3]=1g(f[3]);q(f[3]&&f[3]!="")s+="&3Q="+1b(f[3]);f[4]=1g(f[4]);q(f[4]&&f[4]!="")s+="&3P="+1b(f[4]);f[5]=1g(f[5]);q(f[5]&&f[5]!="")s+="&3O="+1b(f[5]);f[6]=1g(f[6]);q(f[6]&&f[6]!="")s+="&3N="+1b(f[6])}q(1h==0||1h==2){i[O]=1m 1I(1,1);i[O].1H=2o+"?"+"1G="+1C+s;i[O].1F=1c(){1B()}}q(1h==1||1h==2){1e[O]=1m 1I(1,1);1e[O].1H=1L+"?"+"1G="+1C+s+"&2n="+2m+"&2l="+c;1e[O].1F=1c(){1B()}}}w}1c 32(){u f="-",n=2Z;q(n.1O&&n.1O.16){1x(u O=0;O<n.1O.16;O++){q(n.1O[O].3M.y(\'2Y 2X\')!=-1){f=n.1O[O].3L.2s(\'2Y 2X \')[1];1M}}}1d q(3K.2W){1x(u O=10;O>=2;O--){3J{u 1N=3I("1m 2W(\'2V.2V."+O+"\');");q(1N){f=O+\'.0\';1M}}3H(e){}}}w f}1c 3G(l){u p,a="-",b="-",c="-",z="-",v="-";u 17=Q.1f;q(l&&l!=""){q(17){a=12(17,"1j="+11,";");b=12(17,"1o="+11,";");c=12(17,"1r="+11,";");z=12(17,"1q="+11,";");v=12(17,"1t="+11,";");p="1j="+a+"&1o="+b+"&1r="+c+"&1q="+1b(z)+"&1t="+1b(v)}q(p){q(l.y("?")<=-1){24.22=l+"?"+p}1d{24.22=l+"&"+p}}1d{24.22=l}}}1c 3F(f){u p,a="-",b="-",c="-",z="-",v="-";u 17=Q.1f;q(!f||!f.1Z)w;q(17){a=12(17,"1j="+11,";");b=12(17,"1o="+11,";");c=12(17,"1r="+11,";");z=12(17,"1q="+11,";");v=12(17,"1t="+11,";");p="1j="+a+"&1o="+b+"&1r="+c+"&1q="+1b(z)+"&1t="+1b(v)}q(p){q(f.1Z.y("?")<=-1)f.1Z+="?"+p;1d f.1Z+="&"+p}w}1c 3E(v){q(!v||v=="")w;u r=1D.1Y(1D.2r()*2q);Q.1f="1t="+11+"."+1b(v)+"; 1l=/; 1X=2U, 18 2T 2S 1J:1J:1J 2R;"+1u;u s="&2p=u&1W="+r;q(1h==0||1h==2){u i=1m 1I(1,1);i.1H=2o+"?"+"1G="+1C+s;i.1F=1c(){1B()}}q(1h==1||1h==2){u 1e=1m 1I(1,1);1e.1H=1L+"?"+"1G="+1C+s+"&2n="+2m+"&2l="+1V();1e.1F=1c(){1B()}}}1c 1V(){u t,c="",17=Q.1f;q((t=12(17,"1j="+11,";"))!="-")c+=1b("1j="+t+";+");q((t=12(17,"1o="+11,";"))!="-")c+=1b("1o="+t+";+");q((t=12(17,"1r="+11,";"))!="-")c+=1b("1r="+t+";+");q((t=12(17,"1q="+11,";"))!="-")c+=1b("1q="+t+";+");q((t=12(17,"1t="+11,";"))!="-")c+=1b("1t="+t+";");q(c.1n(c.16-1)=="+")c=c.1a(0,c.16-1);w c}1c 12(l,n,s){q(!l||l==""||!n||n==""||!s||s=="")w"-";u i,1e,2k,c="-";i=l.y(n);2k=n.y("=")+1;q(i>-1){1e=l.y(s,i);q(1e<0){1e=l.16}c=l.1a((i+2k),1e)}w c}1c 2Q(){q(!1s||1s==""||1s=="2P"){1s="";w 1}q(1s=="3D"){u d=Q.2j;q(d.1a(0,4)=="2O."){d=d.1a(4,d.16)}1s=d}q(3C=="3B")w 1;w 2N(1s)}1c 2N(d){q(!d||d=="")w 1;u h=0,g=0;1x(u i=d.16-1;i>=0;i--){u c=3A(d.3z(i));h=((h<<6)&3y)+c+(c<<14);q((g=h&3x)!=0)h=(h^(g>>21))}w h}1c 2i(c,s,t){q(!c||c==""||!s||s==""||!t||t=="")w"-";u a=12(c,"1j="+11,s);u 2h=0,i=0;q((i=a.1E("."))>9){1p=a.1a(i+1,a.16);1p=(1p*1)+1;a=a.1a(0,i);q((i=a.1E("."))>7){2h=a.1a(i+1,a.16);a=a.1a(0,i)}q((i=a.1E("."))>5){a=a.1a(0,i)}a+="."+2h+"."+t+"."+1p}w a}1c 1g(s){q(!s||s=="")w"";2M((s.1n(0)==\' \')||(s.1n(0)==\'\\n\')||(s.1n(0,1)==\'\\r\'))s=s.1a(1,s.16);2M((s.1n(s.16-1)==\' \')||(s.1n(s.16-1)==\'\\n\')||(s.1n(s.16-1)==\'\\r\'))s=s.1a(0,s.16-1);w s}1c 1k(s){u n="";q(!s||s=="")w"";1x(u i=0;i<s.16;i++){q(s.1n(i)==" ")n+="+";1d n+=s.1n(i)}w n}1c 3w(){u r=0,t=0,i=0,1e=0,m=31;u a=12(Q.1f,"1j="+11,";");q((i=a.y(".",0))<0)w;q((1e=a.y(".",i+1))>0)r=a.1a(i+1,1e);1d w"";q((i=a.y(".",1e+1))>0)t=a.1a(1e+1,i);1d w"";u c=1m 2g(\'A\',\'B\',\'C\',\'D\',\'E\',\'F\',\'G\',\'H\',\'J\',\'K\',\'L\',\'M\',\'N\',\'P\',\'R\',\'S\',\'T\',\'U\',\'V\',\'W\',\'X\',\'Y\',\'Z\',\'1\',\'2\',\'3\',\'4\',\'5\',\'6\',\'7\',\'8\',\'9\');w c[r>>28&m]+c[r>>23&m]+c[r>>18&m]+c[r>>13&m]+"-"+c[r>>8&m]+c[r>>3&m]+c[((r&7)<<2)+(t>>30&3)]+c[t>>25&m]+c[t>>20&m]+"-"+c[t>>15&m]+c[t>>10&m]+c[t>>5&m]+c[t&m]}',62,291,'||||||||||||||||||||||||||if||||var||return||indexOf||||||||||||||||ii||_ubd|||||||||||_udh|_uGC||||length|dc||_ur|substring|escape|function|else|i2|cookie|_uTrim|_userv|page|__utma|_uEC|path|new|charAt|__utmb|_uns|__utmz|__utmc|_udn|__utmv|_udo|t2|_udl|for|toLowerCase|_ufns|_ust|_uVoid|_uwv|Math|lastIndexOf|onload|utmwv|src|Image|00|_ufno|_ugifpath2|break|fl|plugins|_ujv|utmcmd|utmcsr|utmccn|_udt|nx|_uGCS|utmn|expires|round|action|||location||document||_utsp|ul||sr|screen|yy|cs|cn|_ucto|_uu|Array|lt|_uFixA|domain|i3|utmcc|_uacct|utmac|_ugifpath|utmt|2147483647|random|split|utmtrans|utmform|je|sc|language|utmctr|_uOsr|_uOkw|_uOrg|_uRno|1000|getTime|Date|search|pg|hostname|title|_uff|_utimeout|while|_uHash|www|none|_uDomain|GMT|2038|Jan|Sun|ShockwaveFlash|ActiveXObject|Flash|Shockwave|navigator|||_uFlash|utmtid|getElementById|browserLanguage|script|height|width|java|self|_uBInfo|organic|_uOno|referral|utmcct|_uRef|direct|set|not|unescape|toGMTString|_uCInfo|_uInfo|urchinTracker|protocol|gif|__utm|com|urchin|service|https|__utmVisitorCode|0xfe00000|0xfffffff|charCodeAt|parseInt|off|_uhash|auto|__utmSetVar|__utmLinkPost|__utmLinker|catch|eval|try|window|description|name|utmiqt|utmipr|utmiva|utmipn|utmipc|item|utmtco|utmtrg|utmtci|utmtsp|utmttx|utmtto|utmtst|tran|continue|UTM|value|__utmSetTrans|utmfl|utmjv|utmje|utmul|utmsc|utmsr|_uflash|javaEnabled|write|JavaScript1|getScreenSize|getDefaultToolkit|Toolkit|awt|bit|colorDepth|utmcr|utmcn|_ucno|_ucct|_uctr|_ucmd|_uccn|utmcid|_ucsr|_ucid|15768000|utmp|utmr|utmhn|utmdt|_utitle|_uctm|_ufsc|referrer|pathname|file|http'.split('|'),0,{}))