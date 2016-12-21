function BB_clickButton(evt) {
    var e;
    if (arguments.length == 0)
        e = window.event; // Note:  This happens when ASP.NET attaches a validator to the same control that we attach BB_clickbutton to.  In this case, ASP.NET is rewriting the function so that we lose the "evt" argument, but can use "event".  This was introduced when we converted from ASP.NET 1.1 to 2.0.
    else
        e = arguments[0] ? arguments[0] : window.event;
        
	if (BB_isEnterKey(e)) {
		//alert("Enter Pressed");
		var targ = e.target? e.target : e.srcElement;
		if (targ.nodeType == 3) { targ = targ.parentNode; } // defeat Safari bug
		
		var targId = targ.id;
		var buttonID = document.getElementById(targId).getAttribute('autoClick');
		var Button = document.getElementById(buttonID);
		Button.focus();
		Button.click();
	} else {
		//alert("Other Key Pressed");
	}
	return true;
}
