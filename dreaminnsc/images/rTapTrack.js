(function(){window.version="3.0.15";var r="https:"==document.location.protocol?"https://metrics.responsetap.com/track/":"http://metrics.responsetap.com/track/",t="numberPlaceHolderIds",u=["adinsightnumber","rtapnumber"],w=["s_vi","__utma","__utmz","_ga"],x={},y=6E3,z=0,aa=0,ba=2083-r.length-100,A="html head title meta img script style svg object embed canvas iframe noscript video optgroup".split(" ");
function B(a){this.o=new C;this.u=new ca(this);this.a=new D;this.sessionId=null;this.G=a;this.h=this.m=null;this.F=18E5;this.v=null;this.O=3;this.P=1;this.f="undefined"!==typeof adiZeroConfig&&adiZeroConfig?!0:!1;if(a=(a=this.G)&&!isNaN(a))E("__adiCookieCheck","isEnabled",null,null,null),a="isEnabled"===F("__adiCookieCheck"),document.cookie="__adiCookieCheck=;expires=Fri, 02-Jan-1970 00:00:00 GMT";this.N=a&&null==F("adiErr")?!0:!1;this.J=this.I=!1;this.D=null;this.R=!1;this.M=0}B.prototype={};
function da(){var a=x;for(itemKey in a){if(isNaN(itemKey))return!1;a=parseInt(itemKey);if(0>a||99<a)return!1}return!0}
function ea(a){var b=G;if(!a||!a.children||!a.children.length)return!1;var c=!1,f=a.style.visibility,d=fa(a,b.f);a.style.visibility="hidden";if(!H(d)){for(var c=!0,e=b.f?function(a,b,c,d){d=d.replace(/[-()+.\s]/g,"\\$&");I(a,d,c,b)}:function(a,b,c){ga(a,b,c)},l=!1,h=J(d),k=0;k<h.length;k++){var g=d.get(h[k]),m=b.a.get(h[k]);if(m)if(g=g.b,"R"===m.status||"F"===m.status)for(var n=0;n<g.length;n++)m.b.push(g[n]),e(g[n].element,m.c,m.j,g[n].text),"F"===m.status&&-1!==g[n].element.innerHTML.indexOf(m.c)&&
(m.status="R");else for(l=!0,n=0;n<g.length;n++)m.b.push(g[n]);else l=!0,b.a.i[h[k]]=g,b.a.length++}l&&(ha()&&!K()?(a.style.visibility=f,b.u.X()?b.u.A():b.u.start()):(d=ia(b.a),ja(b,d)))}a.style.visibility=f;return c}
function ka(a,b,c){var f=G,d="function"===typeof b?b:function(){},e="function"===typeof c?c:function(){};if(!f.N||f.J)return e("We cannot perform tracking"),!1;if(f.f){if("string"!==typeof a||0==a.length)return e("Invalid PlaceHolder destination ("+a+")"),!1}else if(isNaN(a)||0>=a)return e("Invalid PlaceHolder ID ("+a+")"),!1;if(!f.I)return e("Mobile replacement request made too early; we have not finished setting up"),!1;b=f.a.get(a);f.a.put(a,document.createElement("a"),null,!0);b&&b.c?la(f,a,{numberPlaceHolderTelephoneNumbers:[{numberPlaceHolderId:a,
telephoneNumber:b.c,e164FormattedTelNumber:b.j,destinationNumber:a}]},d,e):(f.a.get(a).status="P",L(f.o,f.G,[a],M(N(window.location.href)),"numberReplacementOnly.json",function(b){la(f,a,b,d,e)},function(){e("Failure response from the server")}));return!0}function ma(a,b){var c=b.numberPlaceHolderTelephoneNumbers,f=a.f?na:oa,d=c.length;if(c)for(var e=0;e<d;e++)f(a.a,c[e])}
function pa(a,b,c,f,d,e,l,h){var k=new Date;a=a.v;var g=new Date;g.setTime(k.getTime()+31536E6);var m=new Date;m.setTime(k.getTime()+parseInt(f,10));E("adiV",b,g,a,"/");E("adiVi",c,m,a,"/");E("adiS",d,m,a,"/");E("adiLP",k.getTime(),m,a,"/");1==l&&0<h&&(b=new Date,b.setTime(k.getTime()+36E5*h),E("adiBas",!0,b,a,"/"));e&&e.ruleGroupId&&(h="rg:"+e.ruleGroupId+",p:"+(e.performanceRuleGroup?!0:!1),numberAttributionCookieExpiryDate=new Date,numberAttributionCookieExpiryDate.setTime(k.getTime()+parseInt(e.cookieExpiryLength,
10)),E("adiNA",h,numberAttributionCookieExpiryDate,a,"/"))}
function la(a,b,c,f,d){if(c&&c.numberPlaceHolderTelephoneNumbers){var e=0,l=0,h=c.numberPlaceHolderTelephoneNumbers;for(c=0;c<h.length;c++){var k=h[c][a.f?"destinationNumber":"numberPlaceHolderId"];if(b==k){l=h[c];e=a.a.get(k);break}}if(l)if(b=l.numberPlaceHolderId,h=l.telephoneNumber,k=l.e164FormattedTelNumber,b&&h&&k)if(e){var g=e.b,m=!1,n=!1,p="tel:"+k,q=null;for(c=0;c<g.length;c++){var v=g[c];v.H?(v.element.href=p,v.element.innerHTML=h,v.element.className=u[1]+b,q=v.element,v.H=!1,m=!0):n=!0}n&&
"R"!==e.status&&oa(a.a,l);m?(e.status="R",e.c=h,e.j=k,window.location.href=p,f(q)):("R"!==e.status&&(e.status="F"),e.c=h,e.j=k,d("Internal Error"))}else d("Internal Error");else d("No number returned from server, ensure your PlaceHolder ID is correct");else d("No number returned from server, ensure your PlaceHolder ID is correct")}else d("No number returned from server, ensure your PlaceHolder ID is correct")}
function qa(a,b,c){a.I=!0;if(b.adInsightVisitorId&&-1<b.adInsightVisitorId){ma(a,b);a.m=b.adInsightVisitorId;a.h=b.adInsightVisitId;a.sessionId=b.sessionId;a.R=b.enableBasicProduct;a.M=b.basicProductAttributionWindowHours;var f=b.numberAttribution;a.F=b.cookieLength;a.v=b.cookieDomain;pa(a,a.m,a.h,a.F,a.sessionId,f,a.R,a.M);c||("function"===typeof adInsightPostReplacement&&adInsightPostReplacement(),"function"===typeof rTapPostReplacement&&rTapPostReplacement(),a.u.T()&&a.u.start());b.isLandingPageImpression&&
(b.websiteCookieKeys&&(w=w.concat(b.websiteCookieKeys)),O(a,!1));ra(a);sa()&&(document.addEventListener?document.addEventListener("contextmenu",function(){P(a.sessionId,"keepAlive")},!1):document.attachEvent("oncontextmenu",function(){P(a.sessionId,"keepAlive")}))}else a.J=!0}
function ra(a){var b=a.F,c=a.v,f=a.sessionId;a.D&&clearTimeout(a.D);a.D=setInterval(function(){var a=F("adiLP"),e=(new Date).getTime();a<e-y&&(a=new Date,a.setTime(e+parseInt(b,10)),E("adiLP",e,a,c,"/"),P(f,"update"))},parseInt(y,10)+Math.floor(1E3*Math.random()))}
function O(a,b){a.O--;for(var c=0<a.O||1==b,f=!0,d=a.h,e=a.sessionId,l={},h=w.length,k=0;k<h;k++){var g=w[k],m=F(g);if(Q(m)){if(f=!1,c)break}else"s_vi"==g&&(m=m.substring(7,m.length-4)),l[g]=m}(Q(e)||Q(d)||!f)&&c?setTimeout(function(){O(a,!1)},100):Q(d)||Q(e)||R(a.o,l,d,"cookieData;jsessionid="+e,"cookieData")}function M(a){return{sessionId:F("adiS"),m:F("adiV"),h:F("adiVi"),S:F("adiNA"),referrer:a||N(document.referrer),L:F("adiBas")}}
function ja(a,b){L(a.o,a.G,b,M(N(window.location.href)),"numberReplacementOnly.json",function(b){b.replacementOnlyResponse?ma(a,b):qa(a,b,!0)},function(){})}
function ta(){var a=G;if(a.N){a.f&&(t="numberPlaceHolderDestinations",minNumberLength=10,maxContainedElemsInNumber=1,ua(),va());a.a=fa(document,a.f);var b=[],b=ha()&&!K()?wa(a.a,a.f):ia(a.a),c=M(),f=function(){L(a.o,a.G,b,c,"numberReplacement.json",xa,ya)};Q(c.h)&&!S()?T(f,null,!0):f()}else U("Unable to perform tracking - possible causes: No website id, website id NaN, cookies disabled or Error cookie set")}function C(){this.U=N(window.location.href)}C.prototype={};
function P(a,b){V(b+";jsessionid="+a,za,Aa)}
function R(a,b,c,f,d){var e=null,l=!1,h;h="adInsightVisitId="+c+("&"+d+"=");for(e in b){var e=e.toString().replace(/\\/g,"\\\\").replace(/:/g,"\\:").replace(/,/g,"\\,"),k=b[e].toString().replace(/\\/g,"\\\\").replace(/:/g,"\\:").replace(/,/g,"\\,"),k=N(e)+":"+N(k)+",";if(h.length+k.length-1>ba)if(l){R(a,b,c,f,d);break}else U('Unable to send key/value data to "/'+f+'" with key: "'+e+'" - String length is too long for the request');else h+=k,l=!0,delete b[e]}l&&(h=h.substring(0,h.length-1),V(f,null,
Ba,h))}
function L(a,b,c,f,d,e,l){b="websiteId="+b;var h=Ca(),k;a:{if(!window.ActiveXObject)try{for(var g=0;g<navigator.mimeTypes.length;g++){var m=navigator.mimeTypes[g].type.match(/^application\/x-java-applet;jpi-version=(.*)$/);if(null!=m){k=m[1];break a}}}catch(q){}k=null}a.U&&(b+="&windowLocation="+a.U);f.referrer&&(b+="&referrer="+f.referrer);f.m&&(b+="&adInsightVisitorId="+f.m);f.h&&(b+="&adInsightVisitId="+f.h);if(f.S){a=0;for(var m=!1,g=f.S.split(","),n=0;n<g.length;n++){var p=g[n].split(":");"rg"===
p[0]?a=p[1]:"p"===p[0]&&(m="true"===p[1]?!0:!1)}a&&(b+="&numberAttributionRuleGroupId="+a+"&numberAttributionPerformanceRuleGroup="+m)}screen.height&&screen.width&&(b+="&displayResolution="+N(screen.width+"x"+screen.height));screen.colorDepth&&(b+="&displayColour="+N(screen.colorDepth));h&&(b+="&flashVersion="+N(h));k&&(b+="&javaVersion="+N(k));for(n=0;n<c.length;n++)b+="&"+t+"="+encodeURIComponent(c[n]);c=f.sessionId;Q(c)&&(c="");f.L&&(b+="&allowBasicProduct="+f.L);V(d+";jsessionid="+c,e,l,b)}
function V(a,b,c,f){var d=r,d=d+a;b&&(a="json"+ ++z,window[a]=function(a){b(a)},d=-1<d.indexOf("?")?d+("&callback="+a):d+("?callback="+a));c&&(a="json"+ ++z,window[a]=function(a){c(a)},d=-1<d.indexOf("?")?d+("&callbackFailure="+a):d+("?callbackFailure="+a));Q(f)||(d=-1<d.indexOf("?")?d+("&"+f):d+("?"+f));var e=document.createElement("script");e.src=d+"&noCache="+Math.random();e.async=!0;var l=!1;e.onload=e.onreadystatechange=function(){l||this.readyState&&"loaded"!==this.readyState&&"complete"!==
this.readyState||(l=!0,e.onload=e.onreadystatechange=null,e&&e.parentNode&&e.parentNode.removeChild(e))};try{document.body.appendChild(e)}catch(h){}}
function ca(a){var b=this,c=null,f=parseInt(void 0)||500,d=null,e=!0,e=!1;this.X=function(){return null!==c};this.start=function(){d||(d=T(b.start,b.pause,!1));S()&&(e&&(addEventListener?addEventListener("scroll",b.w):attachEvent("onscroll",b.w)),c=setTimeout(b.A,f))};this.pause=function(){e&&(addEventListener?removeEventListener("scroll",b.w):detachEvent("onscroll",b.w));null!==c&&(clearTimeout(c),c=null)};this.stop=function(){b.pause();d&&(Da(d),d=null)};this.T=function(){var b=a.a;if(!H(b))for(var c=
J(b),d=0;d<c.length;d++)if("U"===b.get(c[d]).status)return!0;return!1};this.A=function(){var d=null,e=wa(a.a,a.f);e.length&&ja(a,e);b.T()?d=setTimeout(b.A,f):b.stop();c=d};this.w=function(){c&&clearTimeout(c);c=setTimeout(b.A,f/2)}}function E(a,b,c,f,d){a=a+"="+escape(b);c&&(a+=";expires="+(new Date(c)).toGMTString());f&&(a+=";domain="+f);d&&(a+=";path="+d);document.cookie=a}
function F(a){var b=document.cookie.toString();if(!Q(b))for(var c,f,d=b.split(";"),b=0;b<d.length;b++)if(c=d[b].substr(0,d[b].indexOf("=")),f=d[b].substr(d[b].indexOf("=")+1),c=c.replace(/^\s+|\s+$/g,""),c==a)return unescape(f);return null}function W(a,b,c){for(var f=0;f<u.length;f++)if(c.toLowerCase().startsWith(u[f])){var d=c.toLowerCase().substr(u[f].length);if(!isNaN(d)){a.put(d,b);break}}}
function fa(a,b){var c=new D,f=document.getElementsByClassName?!0:!1,d=document.evaluate?!0:!1,e="undefined"===typeof adiClassMapping?!1:!0,l="undefined"===typeof adiIdMapping?!1:!0;if(l){var h;if("undefined"!==typeof adiIdMapping)for(var k in adiIdMapping)(h=document.getElementById(k))&&W(c,h,adiIdMapping[k])}if(f&&e)for(var g in adiClassMapping){h=a.getElementsByClassName(g);k=0;for(var m=h.length;k<m;k+=1)X(A,h[k].nodeName.toLowerCase())||W(c,h[k],adiClassMapping[g])}if(d){if(!b){var n;n=".//*[";
for(d=0;d<u.length;d++)0<d&&(n+=" or "),n+="contains(translate(@class, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'"+u[d]+"')";for(d=document.evaluate(n+"]",a,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE,null);n=d.iterateNext();)if(!X(A,n.nodeName.toLowerCase()))for(g=n.className.split(" "),h=0;h<g.length;h++)W(c,n,g[h])}if(!f&&e)for(var p in adiClassMapping)for(classesToCheck=".//*[contains(concat(' ', @class, ' '),' "+p+" ')]",f=document.evaluate(classesToCheck,a,null,XPathResult.UNORDERED_NODE_ITERATOR_TYPE,
null);node=f.iterateNext();)X(A,node.nodeName.toLowerCase())||W(c,node,adiClassMapping[p])}else if(!b||e){p=a.getElementsByTagName("*");d=p.length;do if(g=p[d-1],!X(A,g.nodeName.toLowerCase())&&(h="string"==typeof g.className?(g.className||"").split(/\s+/):null,null!=h&&0<h.length))for(k=0;k<h.length;k++)if(m=h[k],b||W(c,g,m),!f&&e)for(n in adiClassMapping)m===n&&W(c,g,adiClassMapping[n]);while(--d)}if(b&&(e||l||U("Zero Config object must include classes or IDs"),(e=c.get("0"))&&e.b.length))for(c=
new D,l=e.b.length,f=0;f<l;f++)Ea(c,e.b[f].element);return c}function N(a){return encodeURIComponent(a).replace(/%20/g,"+")}function oa(a,b){var c=b.numberPlaceHolderId,f=b.telephoneNumber,d=b.e164FormattedTelNumber,e=!1,l=a.get(c);if(l){for(var h=l.b,k=0;k<h.length;k++)h[k].H||(ga(h[k].element,f,d),e=!0);e?l.status="R":(l.status="F",U(c+" failed to be replaced, tracking number: "+f+" is unused"));l.c=f;l.j=d}return e}
function ga(a,b,c){a.innerHTML="t";a.firstChild.nodeValue=b;a.style.visibility="visible";Y()?"A"!=a.tagName?(b=document.createElement("a"),b.setAttribute("href","tel:"+c),b.appendChild(a.firstChild),a.appendChild(b)):a.setAttribute("href","tel:"+c):"A"==a.tagName&&a.setAttribute("href","tel:"+c)}function U(a){window.console&&console.log&&console.log(a)}function X(a,b){for(var c=a.length;c--;)if(a[c]===b)return!0;return!1}function Q(a){var b=!0;a&&""!==a&&(b=!1);return b}
function sa(){var a=navigator.userAgent.toLowerCase();return!Y()&&-1<a.search("msie")?!0:!1}function Y(){var a=navigator.userAgent.toLowerCase(),b="android;blackberry;iemobile;windows ce;series60;symbian;palm;bb10".split(";");if(-1<a.search("iphone")&&-1==a.search("ipad"))return!0;for(var c=0;c<b.length;c++)if(-1<a.search(b[c]))return!0;return!1}function K(){return-1<navigator.userAgent.toLowerCase().search("iphone|ipad")?!0:!1}
function Ca(){try{try{var a=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");try{a.$="always"}catch(b){return"6.0.0"}}catch(b){}return(new ActiveXObject("ShockwaveFlash.ShockwaveFlash")).GetVariable("$version").replace(/\D+/g,".").match(/^.?(.+).?$/)[1]}catch(b){try{return(navigator.plugins["Shockwave Flash 2.0"]||navigator.plugins["Shockwave Flash"]).description.replace(/\D+/g,".").match(/^.?(.+).?$/)[1]}catch(c){}}return null}
function ia(a){var b=[];if(!H(a))for(var c=J(a),f=0;f<c.length;f++){var d=a.get(c[f]);"U"===d.status&&(d.status="P",b.push(c[f]))}return b}function ha(){return"undefined"!==typeof adiRVO&&adiRVO?!0:!1}var S,Z;Z=function(){var a=["webkit","moz","ms","o"];if("hidden"in document)return"hidden";for(var b=0;b<a.length;b++)if(a[b]+"Hidden"in document)return a[b]+"Hidden";return null};S=function(a){a||(a=Z());return a?!document[a]:!0};
function T(a,b,c){var f=Z(),d=null;if(f){var e=f.replace(/[H|h]idden/,"")+"visibilitychange",d=function(){var l=S(f);l&&a?a():!l&&b&&b();c&&(Da(d,e),a&&!l?T(a,null,c):b&&l&&T(null,b,c))};document.addEventListener(e,d,!1);return d}return null}function Da(a,b){var c=b;if(!c){c=Z();if(!c)return;c=c.replace(/[H|h]idden/,"")+"visibilitychange"}document.removeEventListener(c,a,!1)}
function wa(a,b){var c=[];if(!H(a))for(var f=J(a),d=0;d<f.length;d++){var e=a.get(f[d]);if("U"===e.status)for(var l=0;l<e.b.length;l++){var h=e.b[l].element,k=b,g=h.getBoundingClientRect(),m=window.innerHeight||document.documentElement.clientHeight,n=window.innerWidth||document.documentElement.clientWidth,p,q,v;h.currentStyle?(p=h.currentStyle.display,q=h.currentStyle.visibility,v=h.currentStyle.position):(p=getComputedStyle(h,null).display,q=getComputedStyle(h,null).visibility,v=getComputedStyle(h,
null).position);if(!("none"===p||null===h.offsetParent&&"fixed"!==v||k&&"hidden"===q)&&(0<=g.top&&g.top<m||0<g.bottom&&g.bottom<=m)&&(0<=g.left&&g.left<n||0<g.right&&g.right<=n)){c.push(f[d]);e.status="P";break}}}return c}function ua(){delete adiClassMapping;if(adiZeroConfig.classes instanceof Array&&adiZeroConfig.classes.length){adiClassMapping={};for(var a=0;a<adiZeroConfig.classes.length;a++)adiClassMapping[adiZeroConfig.classes[a]]=u[0]+"0"}}
function va(){delete adiIdMapping;if(adiZeroConfig.ids instanceof Array&&adiZeroConfig.ids.length){adiIdMapping={};for(var a=0;a<adiZeroConfig.ids.length;a++)adiIdMapping[adiZeroConfig.ids[a]]=u[0]+"0"}}
function Ea(a,b){function c(){var c=minNumberLength;this.g="";this.l=-1;this.B=0;this.C=this.K=!1;this.s=function(){return this.g.length>=c};this.start=function(a){this.l=a;this.B=0;this.C=!1;h=0;c=minNumberLength};this.Z=function(a){this.start(a);this.g="+";c=minNumberLength+2};this.end=function(c){var e=!0,f=d.substring(this.l,c);if(this.K===(this.B%2?!1:!0))for(var e=!1,g=this.l,h=1,k=d.charAt(g);!e&&0<g;){g--;var l=k,k=d.charAt(g);"<"===k&&("/"!==l?--h||(f=d.substring(g,c),e=!0):h++)}-1===b.innerHTML.indexOf(f)&&
(e=!1);e&&a.put(this.g,b,f);this.clear()};this.V=function(){if(this.g&&!this.C)for(var a=1;3>a;a++){var b=d.charAt(this.l-a);if("("===b)this.l-=a;else if(!b.match(/\s|-|\./))break}this.C=!1};this.clear=function(){this.g="";this.B=0}}var f="area base br col command embed hr img input keygen link meta param source track wbr".split(" ");if("none"!==(b.currentStyle?b.currentStyle:getComputedStyle(b,null)).display&&!(("string"===typeof b.textContent?b.textContent:b.innerText).replace(/\s+/g,"").length<
minNumberLength)){for(var d=b.innerHTML.replace(/\s\s\s\s\s+|\n+|\r+|\t+|\v+|\f+/g,"     "),e=0,l=d.length,h=0,k=0,g=new c;e<l;){var m=d.charAt(e);if("<"===m){g.s()&&!h&&g.end(e);m="";for(e++;">"!==d.charAt(e);)if(m+=d.charAt(e),e<l-1)e++;else{U("Zero Config - Potential number finder error for: "+d);break}var n,p,q=document.createElement("div");q.innerHTML="<"+m.replace(/\//g,"").replace(/src=/,"dummy=").replace(/background:/,"dummy:")+">";document.body.appendChild(q);p=(n=q.firstChild)?1===n.nodeType:
!1;n=n&&p?(n.currentStyle?n.currentStyle:getComputedStyle(n,null)).display:"block";document.body.removeChild(q);p&&(p=X(A,q.nodeName.toLowerCase()),q=X(f,q.nodeName.toLowerCase()),(++g.B>2*maxContainedElemsInNumber||"block"===n||p)&&!k&&g.clear(),m.startsWith("/")?(h--,k&&k--):q?g.K=!g.K:(h++,("none"===n||p||k)&&k++))}else if(!k)switch(m){case "+":g.s()&&g.end(e);g.Z(e);break;case "-":case ".":break;case "(":g.C=!0;break;case ")":g.V();break;case " ":g.s()&&g.end(e);break;default:d.charAt(e).match(/[0-9]/)?
(g.g||g.start(e),g.g+=m):g.s()?g.end(e):g.clear()}e++}g.s()&&g.end(e)}}
function I(a,b,c,f,d){if("undefined"===typeof d||null==d)d=[];"string"===typeof b&&(b=new RegExp(b,"g"));for(var e=0;e<a.children.length;e++)"A"===a.tagName&&d.push(a),I(a.children[e],b,c,f,d),"A"===a.tagName&&d.pop(a);0>a.innerHTML.search(b)||(d="A"===a.tagName?a:0<d.length?d[d.length-1]:null,null!=d?("tel:"===d.getAttribute("href").trim().substring(0,4).toLowerCase()&&d.setAttribute("href","tel:"+c),a.innerHTML=a.innerHTML.replace(b,f)):Y()?a.innerHTML=a.innerHTML.replace(b,'<a href="tel:'+c+'">'+
f+"</a>"):a.innerHTML=a.innerHTML.replace(b,f))}function na(a,b){var c=b.destinationNumber,f=b.telephoneNumber,d=b.e164FormattedTelNumber,e=!1,l=a.get(c);if(l){for(var h=l.b,k=0;k<h.length;k++){var g=h[k].element,m=h[k].text.replace(/[-()+.\s]/g,"\\$&");I(g,m,d,f);e=e||-1!==g.innerHTML.indexOf(f)}e?l.status="R":(l.status="F",U(c+" failed to be replaced, tracking number: "+f+" is unused"));l.c=f;l.j=d}return e}function D(){this.i={};this.length=0}
D.prototype={put:function(a,b,c,f){if(a&&b){var d={element:b,text:c?c:"",H:f?f:!1};if(void 0===this.i[a])b="U",c="",f=[d],d="",this.length++;else{var e=this.get(a);f=e.b;b=e.status;c=e.c;f.push(d);d=e.j}this.i[a]={status:b,c:c,b:f,aa:d}}},get:function(a){var b=void 0;a&&(b=this.i[a]);return b}};function H(a){return a.i&&0<a.length?!1:!0}function J(a){var b=[],c;for(c in a.i)a.i.hasOwnProperty(c)&&b.push(c);return b}String.prototype.startsWith=function(a){return 0===this.indexOf(a)};
function xa(a){qa(G,a)}function ya(){var a=G;a.I=!0;a.J=!0;a=new Date;a.setTime(a.getTime()+3E5);var b=window.location.hostname.replace(/^www./i,"");E("adiErr","trackingErr",a,b,"/")}function za(){var a=G,b=new Date;b.setTime(b.getTime()+31536E6);var c=new Date;c.setTime(c.getTime()+parseInt(a.F,10));var f=a.v;E("adiV",a.m,b,f,"/");E("adiVi",a.h,c,f,"/");E("adiS",a.sessionId,c,f,"/");pingFailureCounter=0}function Aa(){var a=G;2<++aa&&clearInterval(a.D)}
function Ba(){var a=G;0<a.P&&(a.P--,O(a,!0))}if("undefined"===typeof isAdiTesting||"undefined"!==typeof isAdiTesting&&!isAdiTesting){var G=new B(adiInit),y=K()?2E3:Y()?5E3:6E3;ta()}adiFunc={Y:function(a,b){var c;isNaN(a)?c=!1:(c=parseInt(a),0>c||99<c||Q(b)?c=!1:(x[a]=b,c=!0));return c},W:function(){var a;a=G;var b=F("adiVi"),c=F("adiS");Q(c)||Q(b)||!da()?a=!1:(R(a.o,x,b,"customVariables;jsessionid="+c,"variables"),x={},a=!0);return a}};adiFunc.pushVariable=adiFunc.Y;adiFunc.flushVariables=adiFunc.W;
rTapNotifyDOMChange=function(a){a?1!==a.nodeType&&U("rTapNotifyDOMChange: The container specified is invalid - it must be a DOM element"):U("rTapNotifyDOMChange: You must specify a container of either the uppermost element added to the DOM or the element that your content was added to. \nIf you wish to search the entire document again, please explicitly specify the document body");return ea(a)};rTapClickToCall=function(a,b,c){return ka(a,b,c)};
})();