
bcutil = {};

function showdetails(params)
{
   url = '/services/plugin/misc/ShowDetails.jsp?' + params;
    

   var w = 200 ;
   var h = 200 ;
   var l = (screen.width / 2) - (w / 2) ;
   var t = (screen.height / 2) - (h / 2) ;
   window2=window.open(url, 'ShowDetails', 'width=' + w + ',height=' + h + ', top=' + t + ', left=' + l + ', scrollbars=1, resizeable=1')
}

function addParameter(url, paramname, value)
{
	var start = url.indexOf(paramname);
	if (start > -1)
	{
		var endpos = url.indexOf('&', start);
		if (endpos == -1) endpos = url.length;
		url = url.substring(0, start - 1) + url.substring(endpos);
	}

	start = url.indexOf("?");
	if (start > -1)
	{
		url = url + "&" + paramname + "=" + value;		
	} else
	{
		url = url + "?" + paramname + "=" + value;
	}

	return url;
}

function checkall(list, field)
{
	var cnt = list.length;
	var setchecked = field.checked;
	for (var i=0; i<cnt; i++)
	{
		if (list[i] !== field)
		{
			list[i].checked = setchecked;
			list[i].disabled = false;
		}
	}
}

function check(list, field)
{
	var cnt = list.length;
	// find all
	var allchecked = true;
	var allcheckedfield = null;
	for (var i=0; i<cnt; i++)
	{
		if (list[i].value === "all")
		{
			allcheckedfield = list[i];
		} else
		{
			if (! list[i].checked) allchecked = false;
		}

		if (allcheckedfield && (!allchecked)) break;
	}

	allcheckedfield.checked = allchecked;
}

function setModified()
{
	if (document.getElementsByName('modified')[0]) document.getElementsByName('modified')[0].value='1';
}

bcutil.openWindow = function(url, name)
{
    if (!window.popups) window.popups = {};
    if (window.popups[name])
    {
        window.popups[name].close();	
        window.popups[name] = null;
    }
    
    window.popups[name] = window.open(url, name);
}
