
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function openWindow( mypage, myname, w, h, scroll ) {
	var winl = ( screen.width - w ) / 2;
	var wint = ( screen.height - h ) / 2;
	winprops = 'height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll+',resizable'
	win = window.open( mypage, myname, winprops )
	if ( parseInt( navigator.appVersion ) >= 4 ) {
		win.window.focus();
	}
}

function closeWindow() {
	window.close();
}

function printWindow() {
	window.print();
}

MM_preloadImages('images/inside/menu_Home_rlvr.gif','images/inside/menu_Club_Information_rlvr.gif','images/inside/menu_Upcoming_Events_rlvr.gif','images/inside/menu_Private_Parties_rlvr.gif','images/inside/menu_Photo_Gallery_rlvr.gif','images/inside/menu_Vip_Registration_rlvr.gif','images/inside/menu_Contact_rlvr.gif')

function signUpWindow()
{
	//openWindow('signUp.aspx','signup',210,410,'no');
}
function reservationWindow()
{
	openWindow('reservations.aspx','reservations',400,400,'no');
}
function popUp()
{ 
	openWindow('nye_2005.html','nye',325,650,'no');
}
