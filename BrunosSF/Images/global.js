/*******************************************************************************
	OLDIE - or Old IE. A script that finds the version of IE you're using,
	and redirects if lower than the set parameter.
	[[ Created by Ryan McLaughlin, www.DaoByDesign.com ]]
*******************************************************************************/
var browser		= navigator.appName
var ver			= navigator.appVersion
var thestart	= parseFloat(ver.indexOf("MSIE"))+1 //This finds the start of the MS version string.
var brow_ver	= parseFloat(ver.substring(thestart+4,thestart+7)) //This cuts out the bit of string we need.

if ((browser=="Microsoft Internet Explorer") && (brow_ver < 7)) // Allow IE7 and up
	{
	window.location="/redirect.html"; //URL to redirect to.
	}

// JavaScript Document


// rollover

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}


// reveal-hide layers

/*************************************************************************
  This code is from Dynamic Web Coding at http://www.dyn-web.com/
  Copyright 2001-3 by Sharon Paine 
  See Terms of Use at http://www.dyn-web.com/bus/terms.html
  regarding conditions under which you may use this code.
  This notice must be retained in the code as is!
*************************************************************************/

// resize fix for ns4
var origWidth, origHeight;
if (document.layers) {
	origWidth = window.innerWidth; origHeight = window.innerHeight;
	window.onresize = function() { if (window.innerWidth != origWidth || window.innerHeight != origHeight) history.go(0); }
}

var cur_lyr;	// holds id of currently visible layer
function swapLayers(id) {
  if (cur_lyr) hideLayer(cur_lyr);
  showLayer(id);
  cur_lyr = id;
}

function showLayer(id) {
  var lyr = getElemRefs(id);
  if (lyr && lyr.css) lyr.css.visibility = "visible";
}

function hideLayer(id) {
  var lyr = getElemRefs(id);
  if (lyr && lyr.css) lyr.css.visibility = "hidden";
}

function getElemRefs(id) {
	var el = (document.getElementById)? document.getElementById(id): (document.all)? document.all[id]: (document.layers)? getLyrRef(id,document): null;
	if (el) el.css = (el.style)? el.style: el;
	return el;
}