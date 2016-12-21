function fixLayout()
{
	var cw = document.getElementById("page-box").offsetHeight + 42;
	if ( document.documentElement.clientHeight < cw )
	{
		document.getElementById("footer").style.position = "static";
		document.body.style.position = "static";
	}
	else
	{
		document.body.style.position ="relative";
		document.getElementById("footer").style.position = "absolute";
	}
}

if (window.addEventListener){
	window.addEventListener("resize", fixLayout, false);
}
else if (window.attachEvent){
	window.attachEvent("onload", fixLayout);
	window.attachEvent("onresize", fixLayout);
}