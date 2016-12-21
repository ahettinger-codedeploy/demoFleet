//-- general functions
//-----------------------------------------------------------------------------------------------------
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-----------------------------------------------------------------------------------------------------
function MM_findObj(n, d) { //v3.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}
//-----------------------------------------------------------------------------------------------------
function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-----------------------------------------------------------------------------------------------------
function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-----------------------------------------------------------------------------------------------------
function zPopWindow(zURL,zName,xSize,ySize,zOptLevel) {
	// a zOptLevel value of 1 yields a window with no ornamentation, bars, menus etc
	// a zOptLevel value of 2 yields the same window as 1, but with scroll bars
	// a zOptLevel value of 3 (or nothing, or anything but 1 or 2) yields a window with full menus, etc
	W = screen.width;
	H = screen.height;
	if (!xSize) { xSize = W / 1.25; }
	if (!ySize) { ySize = H / 1.25; }
	if (!zName) { zName = "NewWindow"; }
	xPos = (W - xSize) / 2;
	yPos = (H - ySize) / 2;

	if (zOptLevel == 1) {
		var zWinOpts = 'height=' + ySize + ',width=' + xSize + ',left=' + xPos + ',top=' + yPos + 'screenX=' + xPos + ',screenY=' + yPos;
	} else if  (zOptLevel == 2) {
		var zWinOpts = 'height=' + ySize + ',width=' + xSize + ',scrollbars=yes,left=' + xPos + ',top=' + yPos + 'screenX=' + xPos + ',screenY=' + yPos;
    } else {
		var zWinOpts = 'height=' + ySize + ',width=' + xSize + ',resizable=yes,toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,left=' + xPos + ',top=' + yPos + 'screenX=' + xPos + ',screenY=' + yPos;
	}

	var PopWin = window.open(zURL,zName,zWinOpts);

}
//-----------------------------------------------------------------------------------------------------