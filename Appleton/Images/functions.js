
/* ************** SUPPORT FUNCTIONS *************** */

function go_back() {
	history.go(-1);
}

function printPage() {
	if (window.print)
		window.print()
	else
  		alert("Please press ctrl-P to print this page,\nafter pressing 'OK' to close this message box.");
}

function openWin(url) {
  myWin= open(url, "viewWindow", 
    "width=500,height=400,status=no,toolbar=no,menubar=no,location=no,screenX=500,screenY=250");
}

function txtBoxOnKeyPress(object, maxlength) {
	if ( object.value.length >= maxlength)	return false;
	return true;
}

function sendEmail(theAddress) {
	// decrypts email address to avoid email harvesting
	var newAddress = theAddress
	newAddress = theAddress.replace(/no-spam./g, '')
	location.href = 'mailto:' + newAddress;
}

/* ************** POPUP FUNCTION *************** */

var popup=null;
function popupwindow(which,name,width,height,toolbars)
{
	if(!width){
		width=600;
		height=460;
	}
	
	if(!name) name='popup_window';
	
	if(popup!=null)
		{
			popup.close();
		}

	if(toolbars) {
	    popup=window.open(which,name,'toolbar,location,directories,status,scrollbars,resizable=yes,copyhistory,width='+ width+ ',height='+height);
	} else {
	    popup=window.open(which,name,'toolbar=no,location=no,directories=no,status=yes,scrollbars,resizable=yes,copyhistory=no,width='+ width+ ',height='+height);
	}
}

/* ************** IMAGE ROLLOVER FUNCTIONS *************** */

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}