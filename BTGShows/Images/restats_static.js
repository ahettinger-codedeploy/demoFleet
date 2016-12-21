var undefined;

var hrefloc = window.location.href;
var p = hrefloc.indexOf("://");
var protocol =  hrefloc.substring(0, p+1)

var iBase = protocol+"//"+ServerName+"/FCPISAPI/ISAPIExtn.dll/im/"+FCProAccountId+"/0?";
var sBase = protocol+"//"+ServerName+"/FCPISAPI/ISAPIExtn.dll/ss/"+FCProAccountId+"/0?";

function clearcookie(doc, name)
    {
    var c = name + "=; path=/; expires=Fri, 02-Jan-1970 00:00:00 GMT";
    document.cookie = c;
    }

function readcookie(doc, name)
    {
    var c = document.cookie;
    var l = name.length + 1;
    var p0 = c.indexOf(name + "=");

    if (p0 != -1)
        {
        var p1 = c.indexOf(";", p0);

        if (p1 == -1)
            p1 = c.length;

        var value = c.substring(p0 + l, p1);

        if (value.length > 0)
            return value;
        }

    return "";
    }

function isAbsolute(url)
    {
    var p = url.indexOf("://");
    return (p != -1);
    }

function hn(url)
    {
    url = url.toLowerCase();
    var p = url.indexOf("://");

    if (p != -1)
        url = url.substring(p + 3);

    p = url.indexOf("/");

    if (p != -1)
        url = url.substring(0, p);

    p = url.indexOf("?");

    if (p != -1)
        url = url.substring(0, p);

    if (url.replace)
        url = url.replace(/^www\./i, "");

    return url;
    }

function setref(url, handler)
    {
    var c = "LLINK=" + escape(url) + "; path=/";
    document.cookie = c;
    var win = window;

    if (isAbsolute(url) && (hn(win.location.href) != hn(url)))
        {
        var date = new Date();
        var epoch = Math.round(date.getTime() / 1000);
        var qs = "url=" + escape(win.location.href) + "&hr=" + escape(url) + "&ct=" + epoch;
        var i = new Image;
        i.src = sBase + qs;
        }

    if (handler)
        return handler();

    return true;
    }

function hrefclick()
    {
    return setref(this.href, this.oc);
    }

function actionclick()
    {
    return setref(this.action, this.oc);
    }

function rewrite(doc)
    {
    for (i = 0; i < doc.links.length; i++)
        {
        if (!doc.links[i].onclick)
            {
            doc.links[i].onclick = hrefclick;
            }
        }

    for (i = 0; i < doc.forms.length; i++)
        {
        if (!doc.forms[i].onsubmit)
            {
            doc.forms[i].onsubmit = actionclick;
            }
        }
    }

rewrite(document);
var win = window;
var url = iBase;

function sendImage_()
    {
    url += "&url=" + escape(win.location.href);

    try
        {
        if ((typeof httpReferer != 'undefined') && httpReferer.length > 0)
            {
            url += "&ref=" + escape(httpReferer);
            }        
	 else if (win.document.referrer && win.document.referrer.length > 0)
            {
            url += "&ref=" + escape(win.document.referrer);
            }
        else if (win.opener && win.opener.location)
            {
            url += "&ref=" + escape(win.opener.location.href);
            }

	
        }
    catch (e)
        {
        }

    document.write('<img name="rs_img" src="' + url + '">');
    }

function sendImageWithTop()
    {
    win = win.top;
    sendImage_();
    }

function sendImageWithoutTop(err, u, lineNo)
    {
    sendImage_();
    return true;
    }

function sendImage()
    {
    win.oldHandler = win.onerror;
    win.onerror = sendImageWithoutTop;
    var wtest = win.top;
    var t = wtest.location.href; // This will generate an error if cross-site
    win.onerror = win.oldHandler;
    sendImageWithTop();
    }

url += "s=" + screen.width + "." + screen.height + "." + screen.colorDepth;

if (typeof ovr != 'undefined')
    {
    if (ovr.length > 0)
        url += "&ovr=" + escape(ovr);
    }

var fcpclick = readcookie(document, "FCPCLICK");

if (fcpclick.length > 0)
    url += "&fcpclick=" + escape(fcpclick);

if (typeof revenue != 'undefined')
    {
    if (revenue.length > 0)
        url += "&rev=" + escape(revenue);
    }

if (typeof orderId != 'undefined')
    {
    if (orderId.length > 0)
        url += "&oid=" + escape(orderId);
    }

if (typeof correlator!= 'undefined')
    {
    if (correlator.length > 0)
        url += "&corl=" + escape(correlator);
    }

var c = document.cookie;
var p0 = c.indexOf("LLINK=");

if (p0 != -1)
    {
    var llink = readcookie(document, "LLINK");

    if (llink.length > 0)
        url += "&hr=" + llink;

    clearcookie(document, "LLINK");
    }



var app = navigator.appName;
var ver = navigator.appVersion;

if (app.indexOf("Microsoft Internet Explorer") >= 0)
    {
    app = "MSIE";

    if (ver.indexOf("MSIE") >= 0)
        {
        var m = ver.match(/MSIE (.*);/);

        if (m != null)
            {
            ver = m[1];

            if (ver.indexOf(";") >= 0)
                ver = ver.substr(0, ver.indexOf(";"));
            }
        }
    }

else if (app.indexOf("Netscape") >= 0)
    app = "Netscape";

url += "&app=" + app + "&ver=" + parseFloat(ver);

if (navigator.platform)
    {
    url += "&os=" + navigator.platform;
    }

if (navigator.cookieEnabled != undefined)
    {
    if (!navigator.cookieEnabled)
        url += "&cookie=0";
    }

var fcptrack = readcookie(document, "FCPTRACK");
var fs_uid = readcookie(document, "FS_UID");
var extras="";
if(fcptrack.length > 0 )
    extras += "&tr=" + escape(fcptrack);
if (fcpclick.length > 0)
    extras += "&cl=" + escape(fcpclick);

var pid = readcookie(document, "PID");
var cid = readcookie(document, "CID");
var sid = readcookie(document, "SID");
var bcmid = readcookie(document, "BCMID");
var cp1 = readcookie(document, "CP1");
var cp2 = readcookie(document, "CP2");
var cp3 = readcookie(document, "CP3");

if(pid.length > 0)
	extras += "&pid="+escape(pid);
if(cid.length > 0)
	extras += "&cid="+escape(cid);
if(sid.length > 0)
	extras += "&sid="+escape(sid);
if(bcmid.length > 0)
	extras += "&bcmid="+escape(bcmid);
if(cp1.length > 0)
	extras += "&cp1="+escape(cp1);
if(cp2.length > 0)
	extras += "&cp2="+escape(cp2);
if(cp3.length > 0)
	extras += "&cp3="+escape(cp3);


var date = new Date();
var epoch = Math.round(date.getTime() / 1000);
url += "&ct=" + epoch;

if (navigator.cookieEnabled != undefined)
    {
    if (navigator.cookieEnabled)
        {
        url += "&c="+fs_uid;
        url += extras;
        }
    }

sendImage();
