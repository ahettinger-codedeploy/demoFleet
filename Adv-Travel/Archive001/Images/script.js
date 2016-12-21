try {
var _xnext_included;
if (!_xnext_included) {
_xnext_included = true;

if(!document.body) {
    throw "The tag <body> is missing";
}

function xInjectJs(src) {
	if (window.ecwid_script_defer) {
		var script = document.createElement("script");
		script.setAttribute("src", src);
		script.charset = "utf-8";
		script.setAttribute("type", "text/javascript");
		document.body.appendChild(script);
	} else document.write("<script src='"+src+"' type='text/javascript' charset='utf-8'></script>");
}

// Hi! Do you love reading JavaScript code? We too! 
// Ecwid has a plenty of different APIs and we welcome all developers to 
// create addons and services (free or paid ones) for Ecwid merchants. Such 
// addons and apps will be promoted on our site. 
// More about our APIs: http://kb.ecwid.com/w/page/25232810/API

xInjectJs("http://d3lsmbh0k6qtyk.cloudfront.net/gz/10.3-14033/functions.js");

var ecwidContextPath = "";
var ep = function() {
	  this.extensions = [];
	  this.consumers = [];
	  var that = this;
	  this.registerConsumer = function(cons) {
	    that.consumers.push(cons);
	    if (that.extensions.length) cons.addExtensions(that.extensions);
	  };
	  this.addExtension = this.add = function(ext) {
	    that.extensions.push(ext);
	    for (var i=0; i<that.consumers.length; i++) that.consumers[i].addExtensions([ext]);
	  };
	};
var proxyChain = function() {return {Chain:new ep}};
window.Ecwid = {
	MessageBundles:(window.Ecwid && window.Ecwid.MessageBundles) ? window.Ecwid.MessageBundles : {},
	ExtensionPoint:ep,
	ProductBrowser : {Links:new ep,
			CategoryView:proxyChain()
			},
	Controller : proxyChain(),
	ShoppingCartController : proxyChain(),
	ProductModel : proxyChain(),
	CategoriesModel : proxyChain(),
	CategoryModel : proxyChain(),
	AppContainer : proxyChain(),
	Profile : proxyChain(),
	CustomerCredentialsModel : proxyChain(),
	LocationHashModel : proxyChain(),
	OnAPILoaded: new ep,
	OnPageLoad: new ep,
	OnSetProfile: new ep,
	OnPageLoaded: new ep,
	OnConfigLoaded: new ep
	};

if (window.top != window && document.referrer) {
	var hash_position = document.referrer.lastIndexOf('#ecwid:');
	if (hash_position != -1) {
		var hash = document.referrer.substr(hash_position);
		var loc = window.location.href;
		if (loc.indexOf('#') == -1) window.location.replace(loc + hash);
		else {
			if (loc.substr(loc.indexOf('#')) != hash) window.location.replace(loc.substr(0, loc.indexOf('#')) + hash);
		}
	}
}

if(!window.ecwid_nocssrewrite) {
    var html_id = null;
    var html_tag = document.getElementsByTagName("html");
    if(html_tag && html_tag.length) {
        html_tag = html_tag[0];
        if(!html_tag.id) html_tag.id = "ecwid_html";
        html_id = html_tag.id;
    }

    var body_id = null;
    var body_tag = document.getElementsByTagName("body");
    if(body_tag && body_tag.length) {
        body_tag = body_tag[0];
        if(!body_tag.id) body_tag.id = "ecwid_body";
        body_id = body_tag.id;
    }

    if(html_id || body_id) {
        css_selectors_prefix = "";
        if(html_id) {
            css_selectors_prefix += "html%23"+html_id;
        }
        if(html_id && body_id) css_selectors_prefix += "%20";
        if(body_id) {
            css_selectors_prefix += "body%23"+body_id;
        }
    }
}

window.ecwid_script_base='http://d3lsmbh0k6qtyk.cloudfront.net/gz/10.3-14033/';window.ecwid_url='http://app.ecwid.com/';window.ecwid_static='http://d3lsmbh0k6qtyk.cloudfront.net/gz/';window.ecwid_assets_url='http://d3lsmbh0k6qtyk.cloudfront.net/gz/';if (!window.amazon_image_domain) window.amazon_image_domain = 'http://images.ecwid.com';
window.ecwid_white_label=null;



var ecwid_onBodyDoneTimerId,ecwid_bodyDone;
function ecwid_no_fb_iframe() {
	return !window.location.href.match(/fb_xd_fragment/g);
}
function ecwid_onBodyDone() {
    if (!ecwid_bodyDone && ecwid_no_fb_iframe()) {
    	ecwid_bodyDone = true;
    	window.ecwid_script_defer = true;
    	
    	ru_cdev_xnext_frontend_Main=function(){var Y='',fb='" for "gwt:onLoadErrorFn"',db='" for "gwt:onPropertyErrorFn"',pb='"><\/script>',gb='#',Mb='.cache.js',ib='/',Fb='48F780FCAFD7EEA890587E53D3A85B8C',Gb='606C3281867D189E1AE5270BD3BC404B',Hb='93938236D719A7D71FF5048EB1C7EFA5',Ib='983D3841897BAAC50C594792D04C1004',Lb=':',Z='::',N='<html><head><\/head><body><\/body><\/html>',ob='<script id="',ab='=',hb='?',cb='Bad handler "',Jb='C6DE4FC30D218C5014A2BC7493B0E8C6',R='DOMContentLoaded',I='DUMMY',Kb='ED66F1CC7B3C1A7534571C8F8EDC0BE0',Sb='http://app.ecwid.com/css?ownerid=91303&h=-899268814&lang=en'+(document.documentMode==7?'&IE8-like-IE7':'')+(window.css_selectors_prefix? '&id-selector='+window.css_selectors_prefix:''),qb='SCRIPT',nb='__gwt_marker_ru.cdev.xnext.frontend.Main',rb='base',lb='baseUrl',D='begin',J='body',C='bootstrap',kb='clear.cache.gif',_='content',Eb='devmode.js',Tb='end',Ab='gecko',Bb='gecko1_8',F='gwt.codesvr=',eb='gwt:onLoadErrorFn',bb='gwt:onPropertyErrorFn',$='gwt:property',U='head',Qb='href',zb='ie6',yb='ie8',xb='ie9',K='iframe',jb='img',P='javascript',L='javascript:""',Nb='link',Rb='loadExternalRefs',V='meta',T='moduleRequested',S='moduleStartup',wb='msie',W='name',tb='opera',M='position:absolute; width:0; height:0; border:none; left: -1000px; top: -1000px; !important',Ob='rel',G='ru.cdev.xnext.frontend.Main',mb='ru.cdev.xnext.frontend.Main.nocache.js',X='ru.cdev.xnext.frontend.Main::',vb='safari',O='script',Db='selectingPermutation',H='startup',Pb='stylesheet',E='undefined',Cb='unknown',sb='user.agent',Q='var $wnd = window.parent;',ub='webkit';var n;var o=window;var p=document;s(C,D);function q(){if(typeof p.readyState==E){return typeof p.body!=E&&p.body!=null}return /loaded|complete/.test(p.readyState)}
function r(){var a=o.location.search;return a.indexOf(F)!=-1}
function s(a,b){if(o.__gwtStatsEvent){o.__gwtStatsEvent({moduleName:G,sessionId:o.__gwtStatsSessionId,subSystem:H,evtGroup:a,millis:(new Date).getTime(),type:b})}}
ru_cdev_xnext_frontend_Main.__sendStats=s;ru_cdev_xnext_frontend_Main.__moduleName=G;ru_cdev_xnext_frontend_Main.__errFn=null;ru_cdev_xnext_frontend_Main.__moduleBase=I;ru_cdev_xnext_frontend_Main.__softPermutationId=0;ru_cdev_xnext_frontend_Main.__computePropValue=null;var t=function(){return false};var u=function(){return null};__propertyErrorFunction=null;function v(e){var f;function g(){i();return f}
function h(){i();return f.getElementsByTagName(J)[0]}
function i(){if(f){return}var a=p.createElement(K);a.src=L;a.id=G;a.style.cssText=M;a.tabIndex=-1;p.body.appendChild(a);f=a.contentDocument;if(!f){f=a.contentWindow.document}f.open();f.write(N);f.close();var b=f.getElementsByTagName(J)[0];var c=f.createElement(O);c.language=P;var d=Q;c.text=d;b.appendChild(c)}
function j(a){var b=false;if(q()){b=true;a()}var c;function d(){if(!b){b=true;a();if(p.removeEventListener){p.removeEventListener(R,d,false)}if(c){clearInterval(c)}}}
if(p.addEventListener){p.addEventListener(R,function(){d()},false)}var c=setInterval(function(){if(q()){d()}},50)}
function k(a){var b=h();var c=g().createElement(O);c.language=P;c.text=a;b.appendChild(c);b.removeChild(c)}
ru_cdev_xnext_frontend_Main.onScriptDownloaded=function(a){j(function(){k(a)})};s(S,T);var l=p.createElement(O);l.src=e;p.getElementsByTagName(U)[0].appendChild(l)}
function w(){var c={};var d;var e;var f=p.getElementsByTagName(V);for(var g=0,h=f.length;g<h;++g){var i=f[g],j=i.getAttribute(W),k;if(j){j=j.replace(X,Y);if(j.indexOf(Z)>=0){continue}if(j==$){k=i.getAttribute(_);if(k){var l,m=k.indexOf(ab);if(m>=0){j=k.substring(0,m);l=k.substring(m+1)}else{j=k;l=Y}c[j]=l}}else if(j==bb){k=i.getAttribute(_);if(k){try{d=eval(k)}catch(a){alert(cb+k+db)}}}else if(j==eb){k=i.getAttribute(_);if(k){try{e=eval(k)}catch(a){alert(cb+k+fb)}}}}}u=function(a){var b=c[a];return b==null?null:b};__propertyErrorFunction=d;ru_cdev_xnext_frontend_Main.__errFn=e}
function x(){if(window.ecwid_script_base){n=window.ecwid_script_base;return n}function e(a){var b=a.lastIndexOf(gb);if(b==-1){b=a.length}var c=a.indexOf(hb);if(c==-1){c=a.length}var d=a.lastIndexOf(ib,Math.min(c,b));return d>=0?a.substring(0,d+1):Y}
function f(a){if(a.match(/^\w+:\/\//)){}else{var b=p.createElement(jb);b.src=a+kb;a=e(b.src)}return a}
function g(){var a=u(lb);if(a!=null){return a}return Y}
function h(){var a=p.getElementsByTagName(O);for(var b=0;b<a.length;++b){if(a[b].src.indexOf(mb)!=-1){return e(a[b].src)}}return Y}
function i(){var a;if(typeof q==E||!q()){var b=nb;var c;p.write(ob+b+pb);c=p.getElementById(b);a=c&&c.previousSibling;while(a&&a.tagName!=qb){a=a.previousSibling}if(c){c.parentNode.removeChild(c)}if(a&&a.src){return e(a.src)}}return Y}
function j(){var a=p.getElementsByTagName(rb);if(a.length>0){return a[a.length-1].href}return Y}
var k=g();if(k==Y){k=h()}if(k==Y){k=i()}if(k==Y){k=j()}if(k==Y){k=e(p.location.href)}k=f(k);n=k;return k}
function y(a){if(a.match(/^\//)){return a}if(a.match(/^[a-zA-Z]+:\/\//)){return a}return ru_cdev_xnext_frontend_Main.__moduleBase+a}
function z(){var f=[];var g;function h(a,b){var c=f;for(var d=0,e=a.length-1;d<e;++d){c=c[a[d]]||(c[a[d]]=[])}c[a[e]]=b}
var i=[];var j=[];function k(a){var b=j[a](),c=i[a];if(b in c){return b}var d=[];for(var e in c){d[c[e]]=e}if(__propertyErrorFunc){__propertyErrorFunc(a,d,b)}throw null}
j[sb]=function(){var b=navigator.userAgent.toLowerCase();var c=function(a){return parseInt(a[1])*1000+parseInt(a[2])};if(function(){return b.indexOf(tb)!=-1}())return tb;if(function(){return b.indexOf(ub)!=-1}())return vb;if(function(){return b.indexOf(wb)!=-1&&p.documentMode>=9}())return xb;if(function(){return b.indexOf(wb)!=-1&&p.documentMode>=8}())return yb;if(function(){var a=/msie ([0-9]+)\.([0-9]+)/.exec(b);if(a&&a.length==3)return c(a)>=6000}())return zb;if(function(){return b.indexOf(Ab)!=-1}())return Bb;return Cb};i[sb]={gecko1_8:0,ie6:1,ie8:2,ie9:3,opera:4,safari:5};t=function(a,b){return b in i[a]};ru_cdev_xnext_frontend_Main.__computePropValue=k;s(C,Db);if(r()){return y(Eb)}var l;try{h([zb],Fb);h([tb],Gb);h([Bb],Hb);h([yb],Ib);h([vb],Jb);h([xb],Kb);l=f[k(sb)];var m=l.indexOf(Lb);if(m!=-1){g=l.substring(m+1);l=l.substring(0,m)}}catch(a){}ru_cdev_xnext_frontend_Main.__softPermutationId=g;return y(l+Mb)}
function A(){if(!o.__gwt_stylesLoaded){o.__gwt_stylesLoaded={}}function c(a){if(!__gwt_stylesLoaded[a]){var b=p.createElement(Nb);b.setAttribute(Ob,Pb);b.setAttribute(Qb,y(a));p.getElementsByTagName(U)[0].appendChild(b);__gwt_stylesLoaded[a]=true}}
s(Rb,D);c(Sb);s(Rb,Tb)}
w();ru_cdev_xnext_frontend_Main.__moduleBase=x();var B=z();A();s(C,Tb);v(B)}
ru_cdev_xnext_frontend_Main();
    	
		if (document.removeEventListener) {
			document.removeEventListener("DOMContentLoaded", ecwid_onBodyDone, false);
		}
		if (ecwid_onBodyDoneTimerId) {
			clearInterval(ecwid_onBodyDoneTimerId);
		}
    }
}

if (document.addEventListener) {
	document.addEventListener("DOMContentLoaded", function() {
		ecwid_onBodyDone();
	}, false);
}

// Fallback. If onBodyDone() gets fired twice, it's not a big deal.
var ecwid_onBodyDoneTimerId = setInterval(function() {
	if (/loaded|complete/.test(document.readyState)) {
		ecwid_onBodyDone();
	}
}, 50);



window.xnext_ownerId=91303;
window.Ecwid.Preload={conf:"//OK[0,3,103,17,0,102,0,0,101,1,100,35,34,33,32,19,8,0,31,6,1,0,0,0,99,98,97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,27,2,64,0,0,70,69,66,65,8,9,4,2,64,0,0,68,67,66,65,8,3,2,64,3,12,1,0,0,12,63,0,237503941,0,4.75,1,62,1,12,61,-26,0.0,0.0,0.0,0.0,19,50,1,12,60,0.0,1000.0,59,1,19,47,-26,0.0,0.0,20.0,0.0,19,50,1,12,58,0.0,1000.0,57,1,19,47,-26,0.0,0.0,0.0,0.0,19,50,1,12,56,0.0,1000.0,55,0,19,47,-26,0.0,0.0,0.0,0.0,19,50,1,12,54,0.0,1000.0,53,1,19,47,0,0,0,52,0,51,0.0,0.0,0.0,0.0,19,50,1,12,49,0.0,1000.0,48,1,19,47,5,12,46,0,45,0,0,0,44,43,160,16,42,0,0,41,40,19,39,0,1,1,38,1,12,37,36,0,0,35,34,33,32,0,8,0,31,6,15,0,0,0,0,0,200,0,1,34422,30,91303,0,1676329,60,29,28,0,0,32,19,0,27,24,0,1,19,1,26,25,500,24,0,10,19,23,0,0,22,0,21,46,20,19,18,17,0,16,15,14,13,1,12,11,160,0,0,0,10,80,80,1,0,1,91303,0,9,0,0,0,8,0,7,6,0,5,0,0,0,4,0,0,3,1,2,1,[\"1y\",\"c\",\"en\",\"http://app.ecwid.com/css?ownerid=91303&h=-899268814&lang=en\",\"251458316228\",\"r\",\"Upland\",\"US\",\"CA\",\"t\",\"s\",\"h\",\"19\",\"lionelfrancoproductions@gmail.com\",\"Adventure Travel\",\"o\",\" .\",\"$\",\"\",\"MMM d, yyyy\",\"n\",\"jeni@adv-travel.com\",\"1u\",\"light\",\"1v\",\"1w\",\"like\",\"p\",\"rO0ABXcEAAAAAA==\",\"7\",\"Lawton\",\"580-250-4000\",\"73501\",\"OK\",\"200 Southwest C Avenue, Suite 136\\n\",\"Lionel Franco\",\"1p\",\"1n\",\"<div class='ecwid-paymentPaypal'><img class='defaultCCImage' border='0' src='https://app.ecwid.com/icons/creditcards.gif'/></div>\",\"PayPalStandard\",\"PayPal\",\"1r\",\"4.2\",\"10.3.14033\",\"13\",\"18\",\"14\",\"6425-1308593253425\",\"Pick up at Adventure Travel/Central Mall\",\"16\",\"1h\",\"N/A\",\"6426-1308593253425\",\"Pick up at Adventure Travel/Fort Sill Welcome Center\",\"6427-1308593253425\",\"Will-Call/The Day of the Concert\",\"6428-1308593253425\",\"Deliver to Address\",\"7146-1314117453585\",\"Charley's Convention: Pick up at Registration\",\"1f\",\"1b\",\"Sales Tax\",\"1l\",\"UM\",\"VI\",\"1\",\"USA\",\"2\",\"US & Canada\",\"AT\",\"BE\",\"BG\",\"CY\",\"CZ\",\"DK\",\"EE\",\"FI\",\"FR\",\"DE\",\"GR\",\"HU\",\"IE\",\"IT\",\"LV\",\"LT\",\"LU\",\"MT\",\"NL\",\"PL\",\"PT\",\"RO\",\"SK\",\"SI\",\"ES\",\"SE\",\"GB\",\"3\",\"EU\",\"Adventure Travel Store\",\"hh:mm a\",\"http://adv-travel.com/?page_id=727\",\"u\"],1,7]",cat:"//OK[0,0,91303,10,29,160,0,1,10769,5,91303,0,19208193,126,3,4,1621240,1,0,3,2,0,0,91303,40,28,160,0,1,14623,5,91303,0,3967540,107,3,4,176219,0,0,3,2,0,0,91303,30,13,-22,177054,0,0,3,2,2,0,91303,20,27,82,0,1,1691,5,91303,0,16544039,49,3,4,1477779,1,0,3,2,31,-8,91303,10,26,135,0,1,12686,5,91303,0,1492496,160,3,4,173903,1,0,3,2,3,-8,91303,60,25,160,0,1,14234,5,91303,0,1518074,121,3,4,240058,1,0,3,2,0,-21,91303,10,12,-19,191366,0,0,3,2,0,-21,91303,20,17,-34,191367,0,0,3,2,0,-33,91303,20,24,160,0,1,15196,5,91303,0,3617138,123,3,4,337135,0,0,3,2,0,-21,91303,30,23,160,0,1,16768,5,91303,0,2505024,134,3,4,191368,0,0,3,2,1,-8,91303,30,22,160,0,1,15964,5,91303,0,938404,160,3,4,191360,1,0,3,2,1,-8,91303,70,21,160,0,1,9092,5,91303,0,938401,87,3,4,191361,1,0,3,2,3,-8,91303,100,20,160,0,1,14428,5,91303,0,938390,107,3,4,191362,1,0,3,2,0,-18,91303,10,19,160,0,1,15298,5,91303,0,3858230,124,3,4,333004,0,0,3,2,2,-8,91303,90,18,160,0,1,12032,5,91303,0,938386,107,3,4,191363,1,0,3,2,0,0,-21,91303,20,17,160,0,1,15196,5,91303,0,3617139,123,3,4,191367,0,0,3,2,91303,10,16,160,0,1,15196,5,91303,0,2797435,123,3,4,337134,0,0,3,2,18,-8,91303,80,15,160,0,1,13864,5,91303,0,938388,112,3,4,191365,1,0,3,2,1,-8,91303,40,14,160,0,1,16876,5,91303,0,1492507,147,3,4,240038,1,0,3,2,0,0,0,0,91303,30,13,160,0,1,9878,5,91303,0,4370579,107,3,4,177054,0,0,3,2,91303,10,12,160,0,1,15207,5,91303,0,4370578,124,3,4,191366,0,0,3,2,91303,20,11,160,0,1,15298,5,91303,0,3260788,124,3,4,333003,0,0,3,2,3,-8,91303,110,10,160,0,1,12602,5,91303,0,1492510,147,3,4,240039,1,0,3,2,4,-8,91303,20,9,108,0,1,11642,5,91303,0,938400,160,3,4,191358,1,0,3,2,1,68,0,91303,50,6,-3,173902,1,8,3,2,91303,50,7,160,0,1,22638,5,91303,0,938403,160,3,4,191359,1,0,3,2,68,0,91303,50,6,160,0,1,17343,5,91303,0,943795,107,3,4,173902,1,0,3,2,23,1,[\"h\",\"1s\",\"rO0ABXcEAAAAAA==\",\"p\",\"7\",\"Amusement Parks\",\"Hurricane Harbor\",\"\",\"Six Flags\",\"Speed Zone\",\"OU Premium Games\",\"OU Sooners\",\"Sports Tickets\",\"White Water Bay\",\"Universal Orlando\",\"Dallas Non-Premium Games\",\"Dallas Cowboys\",\"Schlitterbahn\",\"OU Non-Premium Games\",\"Sea World\",\"Fiesta Texas\",\"Frontier City\",\"Texas Motor Speedway\",\"Dallas Premium Games\",\"Castaway Cove\",\"Disney World\",\"Transfers\",\"Concert Tickets\",\"Enid Fundraiser\"],1,7]"};
window.Ecwid.MessageBundles['ru.cdev.xnext.client']={};window.Ecwid.MessageBundles['ru.cdev.gwt.client']={};window.Ecwid.demo=false;



function xAddWidget(widgetType, arg) {
	var i=1;
	var id;
	do {
		id = widgetType+"-"+i++;
	} while (document.getElementById(id));
	var stylePrefix = "style=";
	var style = "";
	for (var i=0; i<arg.length; i++) {
		if (arg[i].substr(0,stylePrefix.length) == stylePrefix) {
			var str = arg[i].substr(stylePrefix.length);
			str = str.replace(/^ +\'?/,"").replace(/\'? +$/,"");
			if (str.substring(0,1)=="'") str = str.substring(1);
			if (str.substring(str.length-1)=="'") str = str.substring(0, str.length-1);
			style += str;
		}
	}
	var html = "<div id='"+id+"'";
    if(style) {
        html += " style='"+style+"'";
    }
	html += "></div>";
	document.write(html);
	var l = 0;
	if (!window._xnext_initialization_scripts) {
		window._xnext_initialization_scripts = [];
	} else {
		l = window._xnext_initialization_scripts.length;
	}
	window._xnext_initialization_scripts[l] = {widgetType:widgetType, id:id, arg:arg};
}

function xProductBrowser() {
	ecwid_loader();
	xAddWidget("ProductBrowser", arguments);
}
function ecwid_loader() {
	if (!window.ecwid_loader_shown && ecwid_no_fb_iframe()) {
		if (!window.ecwid_use_custom_loading_indicator && !window.ecwid_script_defer) {
			document.write("<table id='ecwid_loading_indicator' cellpadding='0' cellspacing='0' style='width:100%;background-color:transparent;'><tr><td style='padding:30px;text-align:center'><img src='http://d3lsmbh0k6qtyk.cloudfront.net/gz/10.3-14033/icons/loadingAnimation.gif'/></td></tr></table>");
		}
		window.ecwid_loader_shown = true;
	}
}
function xAddToBag() {
    xAddWidget("AddToBag", arguments);
}
function xProductThumbnail() {
    xAddWidget("ProductThumbnail", arguments);
}
function xLoginForm() {
	xAddWidget("LoginForm", arguments);
}
function xMinicart() {
	xAddWidget("Minicart", arguments);
}
function xCategories() {
	ecwid_loader();
	xAddWidget("Categories", arguments);
}
function xVCategories() {
	xAddWidget("VCategories", arguments);
}
function xSearchPanel() {
	xAddWidget("SearchPanel", arguments);
}
function xGadget() {
	xAddWidget("Gadget", arguments);
}
function xFriendConnect(siteId) {
	Ecwid.gfcSiteId = siteId;
}
function xAffiliate(id) { Ecwid.affiliateId = id; }

if (typeof xInitialized == 'function') xInitialized();

if (/MSIE .+Win/.test(navigator.userAgent)) {
  var clientHeight = document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight;
} else {
  var clientHeight = window.innerHeight-20;
}
document.body.style.minHeight = clientHeight+"px";

}
} catch (e) {
    function xReportError(msg) {
    	var html = "<table style='width:100%'><tr><td align='center'><div style='background-color:white;text-align:left;width: 300px;border: 5px #8080ff solid; padding: 20px'><img style='border:none;float:left;margin:0 20px 5px 0' src='http://my.ecwid.com/icons/msg_error.gif'>"+msg+"</div></td></tr></table>";
    	if (window.ecwid_script_defer) {
    	    var element = document.createElement("div");
    	    element.innerHTML = html;
    	    document.body.appendChild(element);
    	} else document.write(html);
    }

	var commonError = "The store cannot be loaded in your browser because of some JavaScript errors, sorry.<br/>" +
			"If you open this site using a mobile device, you can visit our <a href='http://app.ecwid.com/jsp/91303/catalog'>mobile store</a> " +
			"which is designed specially for them and doesn't use JavaScript.<br/><br/>" +
			"Below here's the exact error occurred. Please report it to the <a href='http://www.ecwid.com/bt'>issue tracker</a>.<br/><br/>";

	var bodyTagError = "This document doesn't contain the required " +
			"<a href='http://www.htmldog.com/reference/htmltags/body/'>&lt;body&gt; and &lt;/body&gt;</a> "+
            "tags. Thus your Ecwid store cannot be loaded. " +
            "Please add these tags and refresh the page. This message will disappear and you will see your store.";

	var isWindowsMobile2005 = /(msie 4).*(windows ce)/i.test(navigator.userAgent);

    if (!document.body && !isWindowsMobile2005)  {
        xReportError(bodyTagError);
	} else {
		xReportError(commonError + e.message);
	}

	throw e;
}
