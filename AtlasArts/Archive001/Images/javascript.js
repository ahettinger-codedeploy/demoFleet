// JavaScript Document
function loader() {
	MM_preloadImages('/PrivateLabel/AtlasArts/images/nav_season_on.jpg','/PrivateLabel/AtlasArts/images/nav_performances_on.jpg','/PrivateLabel/AtlasArts/images/nav_tickets_on.jpg','/PrivateLabel/AtlasArts/images/nav_plan_on.jpg','/PrivateLabel/AtlasArts/images/nav_rent_on.jpg','/PrivateLabel/AtlasArts/images/nav_support_on.jpg','/PrivateLabel/AtlasArts/images/nav_about_on.jpg');
	}

function printWindow(){
   bV = parseInt(navigator.appVersion)
   if (bV >= 4) window.print()
}

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

function clearemail()  {
	document.emailsignup.email.value="";	
}

function CheckSignup()
{
	var errs = '';

	if (document.user_details.first_name.value == '')			errs = errs+'\nPlease enter your first name.\n'
	if (document.user_details.last_name.value == '')			errs = errs+'\nPlease enter your last name.\n'
	if (document.user_details.email.value == '')				errs = errs+'\nPlease enter your email address.\n'
	
	if (errs == '') document.user_details.submit();
	else alert(errs);
}

