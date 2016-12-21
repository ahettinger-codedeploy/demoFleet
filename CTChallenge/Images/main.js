var _lastMenuElement = null;
var _timer = null;

function reload_page() { 
    window.location.reload(true); 
}

function findElement(id) {
    if (document.getElementById) {
        element = document.getElementById(id);
    }
    return element;
}

function setImage(id, url) {
    var element = findElement(id);
    if (element) {
        element.src = url;
    }
}

function showMenu(id) {
    setMenuVisible(id, 1);
}

function hideMenu(id) {
    _timer = setTimeout("setMenuVisible(" + id + ", 0);", 1500);
}

function setMenuVisible(id, isVisible) {
    if (_timer) {
        clearTimeout(_timer);
    }
    if (_lastMenuElement) {
        _lastMenuElement.style.display = 'none';
        _lastMenuElement = null;
    }
    var element = findElement(id);
    if (element) {
        element.style.display = (isVisible == 1) ? 'block' : 'none';
        if (isVisible == 1) {
            _lastMenuElement = element;
        }
    }
}

function toggleVisible(id) {
    var element = findElement(id);
    if (element) {
        if (element.style.display == 'none') {
            element.style.display = 'block';
        }
        else {
            element.style.display = 'none';
        }
    }
}

// DM mouseover stuff

function MM_showHideLayers() { //v9.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) 
  with (document) if (getElementById && ((obj=getElementById(args[i]))!=null)) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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

// active content stuff

//if (AC_FL_RunContent == 0) {
//    alert("This page requires AC_RunActiveContent.js.");
//} else {
//    AC_FL_RunContent(
//	    'codebase', 'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0',
//	    'width', '1000',
//	    'height', '110',
//	    'src', 'second_level',
//	    'quality', 'high',
//	    'pluginspage', 'http://www.macromedia.com/go/getflashplayer',
//	    'align', 'middle',
//	    'play', 'true',
//	    'loop', 'true',
//	    'scale', 'showall',
//	    'wmode', 'window',
//	    'devicefont', 'false',
//	    'id', 'second_level',
//	    'bgcolor', '#ffffff',
//	    'name', 'second_level',
//	    'menu', 'false',
//	    'allowFullScreen', 'false',
//	    'allowScriptAccess','sameDomain',
//	    'movie', 'second_level',
//	    'salign', ''
//	    ); //end AC code
//}
