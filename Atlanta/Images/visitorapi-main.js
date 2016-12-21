var visitor = new Visitor("usdm"); // same as s.visitorNamespace
visitor.trackingServer = "metric.atlanta.net"; // same as s.trackingServer

var serverDomVAPI=location.hostname;


if (serverDomVAPI!=="atlanta.usdmdev.net")
	{
		var omniAccount="usdmatlantaglobal";
		var gaDomain="atlanta.net";
		var gaPGPrefix ='';
		var gaMicroSite='';
	} 

	else 
	{
		var omniAccount="usdmatlantanetdev";
		var gaDomain="atlanta.net";
		var gaPGPrefix ='';
		var gaMicroSite='';
	} 

var docReferrer = document.referrer;
var gaReferrer = '';
if(docReferrer.indexOf("atlanta.net") < 0)
	{
		if(docReferrer != null)
		{
			gaReferrer = docReferrer;
			try{console.log('Tracking ga referral '+docReferrer)}catch(err){};
		} else
		{
			gaReferrer = 'no referral string';
			try{console.log('Tracking ga referral typed or bookmarked '+docReferrer)}catch(err){};
		}					
	}

//var omniAccount="usdmatlantanet";

/*
 ============== DO NOT ALTER ANYTHING BELOW THIS LINE ! ============

 Adobe Visitor API for JavaScript version: 1.1
 Copyright 1996-2013 Adobe, Inc. All Rights Reserved
 More info available at http://www.omniture.com
*/
function Visitor(k){var a=this;a.version="1.1";var f=window;f.s_c_in||(f.s_c_il=[],f.s_c_in=0);a._c="Visitor";a._il=f.s_c_il;a._in=f.s_c_in;a._il[a._in]=a;f.s_c_in++;var i=f.document,h=f.z;h||(h=null);var j=f.A;j||(j=!0);var l=f.w;l||(l=!1);a.s=function(){var a;!a&&f.location&&(a=f.location.hostname);if(a)if(/^[0-9.]+$/.test(a))a="";else{var d=a.split("."),b=d.length-1,e=b-1;1<b&&2>=d[b].length&&0>",am,aq,ax,cc,cf,cg,ch,cv,cz,de,dj,dk,eu,fm,fo,ga,gd,gf,gl,gm,gq,gs,gw,hm,li,lu,md,mh,mp,mq,ms,ne,nl,nu,pm,si,sk,sm,sr,su,tc,td,tf,tg,tk,tv,va,vg,vu,wf,yt,".indexOf(","+
d[b]+",")&&e--;if(0<e)for(a="";b>=e;)a=d[b]+(a?".":"")+a,b--}return a};a.cookieRead=function(a){var d=(";"+i.cookie).split(" ").join(";"),b=d.indexOf(";"+a+"="),e=0>b?b:d.indexOf(";",b+1);return 0>b?"":decodeURIComponent(d.substring(b+2+a.length,0>e?d.length:e))};a.cookieWrite=function(c,d,b){var e=a.cookieLifetime,g,d=""+d,e=e?(""+e).toUpperCase():"";b&&"SESSION"!=e&&"NONE"!=e?(g=""!=d?parseInt(e?e:0):-60)?(b=new Date,b.setTime(b.getTime()+1E3*g)):1==b&&(b=new Date,g=b.getYear(),b.setYear(g+2+(1900>
g?1900:0))):b=0;return c&&"NONE"!=e?(i.cookie=c+"="+encodeURIComponent(d)+"; path=/;"+(b?" expires="+b.toGMTString()+";":"")+(a.k?" domain="+a.k+";":""),a.cookieRead(c)==d):0};a.b=h;a.j=function(a,d){try{"function"==typeof a?a.apply(f,d):a[1].apply(a[0],d)}catch(b){}};a.u=function(c,d){d&&(a.b==h&&(a.b={}),void 0==a.b[c]&&(a.b[c]=[]),a.b[c].push(d))};a.p=function(c,d){if(a.b!=h){var b=a.b[c];if(b)for(;0<b.length;)a.j(b.shift(),d)}};a.c=h;a.t=function(c,d,b){!d&&b&&b();var e=i.getElementsByTagName("HEAD")[0],
g=i.createElement("SCRIPT");g.type="text/javascript";g.setAttribute("async","async");g.src=d;e.firstChild?e.insertBefore(g,e.firstChild):e.appendChild(g);a.c==h&&(a.c={});a.c[c]=setTimeout(b,a.loadTimeout)};a.q=function(c){a.c!=h&&a.c[c]&&(clearTimeout(a.c[c]),a.c[c]=0)};a.l=l;a.m=l;a.isAllowed=function(){if(!a.l&&(a.l=j,a.cookieRead(a.cookieName)||a.cookieWrite(a.cookieName,"T",1)))a.m=j;return a.m};a.a=h;a.n=l;a.i=function(){if(!a.n){a.n=j;var c=a.cookieRead(a.cookieName),d,b,e,g,f=new Date;if(c&&
"T"!=c){c=c.split("|");1==c.length%2&&c.pop();for(d=0;d<c.length;d+=2)if(b=c[d].split("-"),e=b[0],g=c[d+1],b=1<b.length?parseInt(b[1]):0,e&&g&&(!b||f.getTime()<1E3*b))a.f(e,g,1),0<b&&(a.a["expire"+e]=b)}if(!a.d("MCAID")&&(c=a.cookieRead("s_vi")))c=c.split("|"),1<c.length&&0<=c[0].indexOf("v1")&&(g=c[1],d=g.indexOf("["),0<=d&&(g=g.substring(0,d)),g&&g.match(/^[0-9a-fA-F\-]+$/)&&a.f("MCAID",g))}};a.v=function(){var c="",d,b;for(d in a.a)!Object.prototype[d]&&a.a[d]&&"expire"!=d.substring(0,6)&&(b=a.a[d],
c+=(c?"|":"")+d+(a.a["expire"+d]?"-"+a.a["expire"+d]:"")+"|"+b);a.cookieWrite(a.cookieName,c,1)};a.d=function(c){return a.a!=h?a.a[c]:h};a.f=function(c,d,b){a.a==h&&(a.a={});a.a[c]=d;b||a.v()};a.o=function(c,d){var b=new Date;b.setTime(b.getTime()+1E3*d);a.a==h&&(a.a={});a.a["expire"+c]=Math.floor(b.getTime()/1E3)};a.r=function(a){if(a&&("object"==typeof a&&(a=a.visitorID?a.visitorID:a.id?a.id:a.uuid?a.uuid:""+a),a&&(a=a.toUpperCase(),"NOTARGET"==a&&(a="NONE")),!a||"NONE"!=a&&!a.match(/^[0-9a-fA-F\-]+$/)))a=
"";return a};a.g=function(c,d){var b;a.q(c);b=a.d(c);b||(b=a.r(d))&&a.f(c,b);if("object"==typeof d){var e=86400;"MCAAMID"==c&&(void 0!=d.id_sync_ttl&&d.id_sync_ttl&&(e=parseInt(d.id_sync_ttl)),a.o(c,e),a.o("MCAAMLH",e),d.dcs_region&&a.f("MCAAMLH",d.dcs_region))}a.p(c,["NONE"!=b?b:""])};a.e=h;a.h=function(c,d,b){if(a.isAllowed()){a.i();var e=a.d(c);if(e)return"NONE"==e&&a.j(b,[""]),"NONE"!=e?e:"";if(a.e==h||void 0==a.e[c])a.e==h&&(a.e={}),a.e[c]=j,a.t(c,d,function(){if(!a.d(c)){var b="";if("MCMID"==
c){var d=b="",e,f,h=10,i=10;for(e=0;19>e;e++)f=Math.floor(Math.random()*h),b+="0123456789".substring(f,f+1),h=0==e&&9==f?3:10,f=Math.floor(Math.random()*i),d+="0123456789".substring(f,f+1),i=0==e&&9==f?3:10;b+=d}a.g(c,b)}});a.u(c,b)}return""};a.setMarketingCloudVisitorID=function(c){a.g("MCMID",c)};a.getMarketingCloudVisitorID=function(c){var d=a.marketingCloudServer,b="";a.loadSSL&&a.marketingCloudServerSecure&&(d=a.marketingCloudServerSecure);d&&(b="http"+(a.loadSSL?"s":"")+"://"+d+"/id?d_rtbd=json&d_cid="+
encodeURIComponent(a.namespace)+"&d_cb=s_c_il%5B"+a._in+"%5D.setMarketingCloudVisitorID");return a.h("MCMID",b,c)};a.setAudienceManagerVisitorID=function(c){a.g("MCAAMID",c)};a.getAudienceManagerVisitorID=function(c){var d=a.audienceManagerServer,b="";a.loadSSL&&a.audienceManagerServerSecure&&(d=a.audienceManagerServerSecure);d&&(b="http"+(a.loadSSL?"s":"")+"://"+d+"/id?d_rtbd=json&d_cb=s_c_il%5B"+a._in+"%5D.setAudienceManagerVisitorID");return a.h("MCAAMID",b,c)};a.getAudienceManagerLocationHint=
function(){a.i();var c=a.d("MCAAMLH");return c?c:0};a.setAnalyticsVisitorID=function(c){a.i();a.g("MCAID",c)};a.getAnalyticsVisitorID=function(c){var d=a.trackingServer,b="";a.loadSSL&&a.trackingServerSecure&&(d=a.trackingServerSecure);d&&(b="http"+(a.loadSSL?"s":"")+"://"+d+"/id?callback=s_c_il%5B"+a._in+"%5D.setAnalyticsVisitorID");return a.h("MCAID",b,c)};a.getVisitorID=function(c){return a.getMarketingCloudVisitorID(c)};a.namespace=k;a.cookieName="AMCV_"+k;a.k=a.s();a.loadSSL=0<=f.location.protocol.toLowerCase().indexOf("https");
a.loadTimeout=500;a.marketingCloudServer=a.audienceManagerServer="dpm.demdex.net"}Visitor.getInstance=function(k){var a,f=window.s_c_il,i;if(f)for(i=0;i<f.length;i++)if((a=f[i])&&"Visitor"==a._c&&a.namespace==k)return a;return new Visitor(k)};
