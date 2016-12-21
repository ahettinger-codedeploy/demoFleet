function KMTrackClick()
{
	window.onerror = function() {
	        return true;
	}
	var theURL=''+top.document.URL;
	var theReferrer=''+top.document.referrer;
	var urlTest=theURL;
	var refTest=theReferrer;
	if(refTest.indexOf('/',10)!=-1) {
	        refTest=refTest.substring(0,refTest.indexOf('/',10));
	}
	if(urlTest.indexOf('/',10)!=-1) {
	        urlTest=urlTest.substring(0,urlTest.indexOf('/',10));
	}
	if(refTest!=urlTest) {
	  var a_php = "";
	  var first = true;
	  if (typeof(BlockedReferrers)!='undefined'){
	    for (var key in BlockedReferrers)
	    {
	    	if(first)
	    	{
	    		first = false;
	    	}
	    	else
	    	{
	    		a_php = a_php + ",";
	    	}
	            a_php = a_php + String(BlockedReferrers[key]);
	    }
	  }
	  var blockref = escape(a_php);
	  var ref=escape(theReferrer);
	  var url=escape(theURL);
	  log='http://tracking.keywordmax.com/tracking/log.php?id=138603711&loc=Homepage&enginevar=engine&keywordvar=keyword&blockengines=&blockref='+blockref+'&ref='+ref+'&url='+url+'&vcookie='+KMGetCookie("KMVisitor");
	  var logimage=new Image();
	  logimage.src=log;
	}
}
function KMSetCookie(name, value, expires, path, domain, secure)
{
          var expdate = new Date ();
    expdate.setTime(expdate.getTime() + (24 * 60 * 60 * 1000));
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}
function KMGetCookie(name)
{
	var dc = document.cookie;
	var prefix = name + "=";
	var begin = dc.indexOf("; " + prefix);
	if (begin == -1)
	{
    begin = dc.indexOf(prefix);
    if (begin != 0) return "10912111240311759436";
	}
	else
	{
    begin += 2;
	}
	var end = document.cookie.indexOf(";", begin);
	if (end == -1)
	{
    end = dc.length;
	}
	contents = dc.substring(begin + prefix.length, end);
	if(contents)
	{
		return unescape(contents);
	}
	return "10912111240311759436";
}
if (KMGetCookie("KMVisitor") == null)
{
  KMSetCookie("KMVisitor","10912111240311759436","Wed Dec 11 2019 12:41:42","/", "tracking.keywordmax.com",0);
}
KMTrackClick();
