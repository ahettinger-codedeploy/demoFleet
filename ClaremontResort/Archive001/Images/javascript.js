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
var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"] && (parseInt(navigator.appVersion) >= 4)) ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
if(plugin) plugin = parseInt(plugin.description.substring(plugin.description.indexOf(".")-1)) >= 7;
else if(navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0 && (navigator.userAgent.indexOf("Windows 95")>=0 || navigator.userAgent.indexOf("Windows 98")>=0 || navigator.userAgent.indexOf("Windows NT")>=0)) {
	document.write('<SCRIPT LANGUAGE="VBScript"\>\n');
	document.write('on error resume next\n');
	document.write('plugin = ( IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.7")))\n');
	document.write('</SCRIPT\>\n');
}
function SeeTable(div,way,timerNum){
	if(allow == 1){
		if(way != "hidden" && timerNum){ clearTimeout(eval("timer"+timerNum))};
		if(document.all){ if("document.all."+div) eval("document.all."+div+".style.visibility = '"+way+"'");
		}else if(document.getElementById){ eval('document.getElementById(\''+ div + '\').style.visibility = way');
		}else{
			if(way == "hidden") { way = "hide"}
			eval("window.document.Layer"+div+".visibility = '"+way+"'");
		}
	}
}
function NewWindow(name,url,width,height,str){
	this.name	= name;
	this.url	= url;
	this.width	= width;
	this.height	= height;
	this.str	= str;
	this.string = this.str+",width="+this.width+",height="+this.height
	
	this.openit	= openit;
}

var opsun	= "top=25,left=520,scrollbars=no,menu=no,resizable=yes,statusbar=no";
var opsun2	= "top=20,left=20,scrollbars=no,menu=no,resizable=yes,statusbar=no";
var opsun3	= "top=20,left=20,scrollbars=yes,menu=no,resizable=yes,statusbar=no";
var opsun4	= "width=550,height=500,resizable=no,scrollbars=yes,top=50,left=125";
var first	= new NewWindow('winda','https://reservations.synxis.com/opbe/rez.aspx?flashOk=1&lang=1&hotel=12263&chain=5150',790,556,opsun); 
var second	= new NewWindow('winda','http://dev.zcom2.com/TheClaremontResort/Websites/TheClaremontResortDotCom/2007Website/gallery.htm',610,500,opsun2);

function openit(dates){
	if(dates) this.url = this.url+"?date="+dates;
	var popup = window.open(this.url,this.name,this.string);
	eval(popup);
}


function Validate(frm){

	today = new Date();	
	//Create Start Date
	var	adults	= document.ReservationForm.adults[document.ReservationForm.adults.selectedIndex].value,
		rYear	= document.ReservationForm.StartDate_year[document.ReservationForm.StartDate_year.selectedIndex].value,
		rMonth	= document.ReservationForm.StartDate_month[document.ReservationForm.StartDate_month.selectedIndex].value,
		rDay	= document.ReservationForm.StartDate_day[document.ReservationForm.StartDate_day.selectedIndex].value,
		child	= document.ReservationForm.children[document.ReservationForm.children.selectedIndex].value,
		nights	= document.ReservationForm.nights[document.ReservationForm.nights.selectedIndex].value;
	
	dateStart 	= new Date( rYear, (rMonth-1), rDay );
	dateEnd		= new Date( rYear, (rMonth-1), rDay );
	dateSpread	= eval(parseInt(rDay) + parseInt(nights));
	dateEnd.setFullYear(rYear,(rMonth-1),(dateSpread))
	
	if (dateStart < today){
		alert( "Your Arrival Date cannot be on or before Today's date." );
		return false;
	}

	if ( document.ReservationForm.adults.value == "" ){
		alert( "You must select number of adults." );
		return false;
	}

	 var qs;
	 qs = "https://reservations.synxis.com/opbe/rez.aspx" 
	 + "?flashOk=1&lang=1&hotel=11015"
	 + "&group="
	 + "&arrive=" + rMonth + '/' + rDay + '/' + rYear
	 + "&depart=" + (dateEnd.getMonth()+1) + '/' + dateEnd.getDate() + '/' + dateEnd.getFullYear()
	 + "&adult=" + adults
	 + "&child=" + child
	 + "&step=2";

	 window.open(qs,"popup", "scrollbars=yes,location=yes,menu=no,height=600,width=800");
	return false;
}