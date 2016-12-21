function BB_noEnterKey(evt)
{
	var e;
	if (arguments.length == 0)
		e = window.event; // Note:  This happens when ASP.NET attaches a validator to the same control that we attach this script to.  In this case, ASP.NET is rewriting the function so that we lose the "evt" argument, but can use "event".  This was introduced when we converted from ASP.NET 1.1 to 2.0.
	else
		e = arguments[0] ? arguments[0] : window.event;
		
	if (BB_isEnterKey(e)) {
		return false;
	} else {
		return true;
	}
}
