function BB_isEnterKey(evt)
{
	var e;
	if (arguments.length == 0)
		e = window.event; // Note:  This happens when ASP.NET attaches a validator to the same control that we attach BB_clickbutton to.  In this case, ASP.NET is rewriting the function so that we lose the "evt" argument, but can use "event".  This was introduced when we converted from ASP.NET 1.1 to 2.0.
	else
		e = arguments[0] ? arguments[0] : window.event;
	
	if(!e) return false;
	var key = 0;
	if (e.keyCode) { key = e.keyCode; } // for moz/fb, if keyCode==0 use 'which'
	else if (typeof(e.which)!= 'undefined') { key = e.which; }

	if (key == 13) {
		return true;
	} else {
		return false;
	}
}