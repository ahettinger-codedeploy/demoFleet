function domainCheck(domain, domainExt)
{
	var isType = false;

	for(i = 0; i < domainExt.length; i++)
	{
		re = new RegExp("\\"+domainExt[i]+"$");
		if (domain.match(re))
		{
			isType = true;
			break;
		} 
	}	
	
	return isType;
}

var ref = document.referrer;

if ( ref.length <= 0 )
    ref = window.location;

if(location.protocol == "https:")
{     
  var url="https://a12.alphagodaddy.com/?ref=" + escape(ref) + "&url=" + escape(window.location) + "&leo=0";
} else {
  var url="http://a12.alphagodaddy.com/?ref=" + escape(ref) + "&url=" + escape(window.location) + "&leo=0";
}

var htmlStr = '<iframe id="conash3D0" frameborder=0 border=0 width="100%" height="115px" marginwidth=0 marginheight=0 allowtransparency=true vspace=0 hspace=0 scrolling=no src="' + url + 
'"></iframe>';

// to include other domain types to be filtered, add it to the list of array items.
var domainExt = new Array(".mobi");

if ( domainCheck(document.domain, domainExt) == false )
{
	if ( document.body.insertAdjacentHTML )
	{
		document.body.insertAdjacentHTML('AfterBegin', htmlStr);
	}
	else
	{
		var r = document.createRange();
		r.setStartBefore(document.body);

		var parsedHTML = r.createContextualFragment(htmlStr);

		document.body.insertBefore(parsedHTML, document.body.firstChild);
	}

	document.body.style.margin = '0px';
	document.body.style.padding = '0px';
}
