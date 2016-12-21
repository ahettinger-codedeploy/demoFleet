// Generic PopUp Function
function popUp(wname,url,width,height,statusbar,scrollbars,resizable,toolbar){

	//define height and width if they are not passed
	//as arguments
	if(!height)
		height=300;
	if(!width)			
		width=500;
	if(!scrollbars)			
		scrollbars="yes";
	if(!resizable)			
		resizable="no";
	if(!toolbar)			
		toolbar="no";
	if(!statusbar)			
		toolbar="no";

	var theWidth = width;
	var theHeight = height;

		
	x = (640 - theWidth)/2, y = (480 - theHeight)/2;

  	if (screen) {
      		y = (screen.availHeight - theHeight)/2;
      		x = (screen.availWidth - theWidth)/2;
  		}
	if (screen.availWidth > 1800) { 
		x = ((screen.availWidth/2) - theWidth)/2; 
  		} 

		
	var settings = "status=" + statusbar + "toolbar=" + toolbar + ",resizable=" + resizable + ",height=" + height + ",width=" + width + ",scrollbars=" + scrollbars + ',width='+theWidth+',height='+theHeight+',screenX='+x+', screenY='+y+', top='+y+',left='+x;
	Testwin = window.open(url,wname,settings);
	Testwin.focus();
}

//  Generic Datepicker
	function calendarpopUp(strControl, formname)
	{
	var strURL = "datepicker.asp?CTRL=" + strControl + "&formname=" + formname;
	var strCurDate = document[formname](strControl).value;
	if (strCurDate.length > 0)
	strURL += "&INIT=" + strCurDate;
	windowDatePicker = window.open(strURL,"dp","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0," + "width=190,height=190,left=" + (window.event.screenX - 16) + ",top=" + (window.event.screenY - 100));
	windowDatePicker.focus();
	return false;
	}
	
function CallCenterpopUp(wname,url,width,height,statusbar,scrollbars,resizable,toolbar){

	//define height and width if they are not passed
	//as arguments
	if(!height)
		height=300;
	if(!width)			
		width=500;
	if(!scrollbars)			
		scrollbars="yes";
	if(!resizable)			
		resizable="no";
	if(!toolbar)			
		toolbar="no";
	if(!statusbar)			
		toolbar="no";

	var theWidth = width;
	var theHeight = height;

		
//	x = (640 - theWidth)/2, y = (480 - theHeight)/2;

//  	if (screen) {
//      		y = (screen.availHeight - theHeight)/2;
//      		x = (screen.availWidth - theWidth)/2;
//  		}
//	if (screen.availWidth > 1800) { 
//		x = ((screen.availWidth/2) - theWidth)/2; 
//  		} 
	x = 0;
	y = 0;

		
	var settings = "status=" + statusbar + "toolbar=" + toolbar + ",resizable=" + resizable + ",height=" + height + ",width=" + width + ",scrollbars=" + scrollbars + ',width='+theWidth+',height='+theHeight+',screenX='+x+', screenY='+y+', top='+y+',left='+x;
	Testwin = window.open(url,wname,settings);
	Testwin.focus();
}




// Date Validation Functions
function LeapYear(intYear) 
{
	if (intYear % 100 == 0) 
	{
		if (intYear % 400 == 0) 
		{ 
			return true; 
		}
	}
	else 
	{
		if ((intYear % 4) == 0) 
		{ 
			return true; 
		}
	}
	return false;
}
	
function chkdate(objName) 
{
var strDatestyle = "US"; //United States date style
//var strDatestyle = "EU";  //European date style
var strDate;
var strDateArray;
var strDay;
var strMonth;
var strYear;
var intday;
var intMonth;
var intYear;
var booFound = false;
var datefield = objName;
var strSeparatorArray = new Array("-"," ","/",".");
var intElementNr;
var err = 0;
var strMonthArray = new Array(12);
	strMonthArray[0] = "Jan";
	strMonthArray[1] = "Feb";
	strMonthArray[2] = "Mar";
	strMonthArray[3] = "Apr";
	strMonthArray[4] = "May";
	strMonthArray[5] = "Jun";
	strMonthArray[6] = "Jul";
	strMonthArray[7] = "Aug";
	strMonthArray[8] = "Sep";
	strMonthArray[9] = "Oct";
	strMonthArray[10] = "Nov";
	strMonthArray[11] = "Dec";
	strDate = datefield.value;
	if (strDate.length < 1) 
	{
		return true;
	}
	for (intElementNr = 0; intElementNr < strSeparatorArray.length; intElementNr++) 
	{
		if (strDate.indexOf(strSeparatorArray[intElementNr]) != -1) 
		{
			strDateArray = strDate.split(strSeparatorArray[intElementNr]);
			if (strDateArray.length != 3) 
			{
				err = 1;
				return false;
			}
			else 
			{
				strDay = strDateArray[0];
				strMonth = strDateArray[1];
				strYear = strDateArray[2];
			}
			booFound = true;
	   }
	}
	if (booFound == false) 
	{
		if (strDate.length>5) 
		{
			strDay = strDate.substr(0, 2);
			strMonth = strDate.substr(2, 2);
			strYear = strDate.substr(4);
		}
	}
	if (strYear.length == 2) 
	{
		strYear = '20' + strYear;
	}
	// US style
	if (strDatestyle == "US") 
	{
		strTemp = strDay;
		strDay = strMonth;
		strMonth = strTemp;
	}
	intday = parseInt(strDay, 10);
	if (isNaN(intday)) 
	{
		err = 2;
		return false;
	}
	intMonth = parseInt(strMonth, 10);
	if (isNaN(intMonth)) 
	{
		for (i = 0;i<12;i++) 
		{
			if (strMonth.toUpperCase() == strMonthArray[i].toUpperCase()) 
			{
				intMonth = i+1;
				strMonth = strMonthArray[i];
				i = 12;
		   }
		}
		if (isNaN(intMonth)) 
		{
			err = 3;
			return false;
		}
	}
	intYear = parseInt(strYear, 10);
	if (isNaN(intYear)) 
	{
		err = 4;
		return false;
	}
	if (intMonth>12 || intMonth<1) 
	{
		err = 5;
	return false;
	}
	if ((intMonth == 1 || intMonth == 3 || intMonth == 5 || intMonth == 7 || intMonth == 8 || intMonth == 10 || intMonth == 12) && (intday > 31 || intday < 1)) 
	{
		err = 6;
		return false;
	}
	if ((intMonth == 4 || intMonth == 6 || intMonth == 9 || intMonth == 11) && (intday > 30 || intday < 1)) 
	{
		err = 7;
	return false;
	}
	if (intMonth == 2) 
	{
		if (intday < 1) 
		{
			err = 8;
			return false;
		}
		if (LeapYear(intYear) == true) 
		{
			if (intday > 29) 
			{
				err = 9;
				return false;
			}
		}
		else 
		{
			if (intday > 28) 
			{
				err = 10;
				return false;
			}
		}
	}
	return true;
}
function checkdate(objName,thedate) 
{

var datefield = objName;
var datetext;
	if (chkdate(datefield) == false) 
	{
		//datefield.select();
		if (thedate == 'from')
		{
			datetext = 'from'
		}
		else
		{
			datetext = 'to'
		}
		alert("The " + datetext + " date is invalid.  Please try again.");
		//datefield.focus();
		return false;
	}
	else 
	{
		return true;
	}
}	

function doDateCheck(from, to) 
{
	if (checkdate(from,'from'))
	{
		if (checkdate(to,'to'))
		{
			if (Date.parse(from.value) <= Date.parse(to.value)) 
			{
				return true;
			}
			else 
			{
				if (from.value == "" || to.value == "") 
				{
					alert("Both dates must be entered.");
					return false;
				}
				else 
				{
					alert("To date must occur after the from date.");
					return false;
				}
			}
		}
	}
}		


//----------------------- Shopping Cart
	function cartselectall() {
		for (i=1;i<=parseInt(document.basket.NumTickets.value);++i) {
			sTicket = "delitem_"+i;
			if (document.basket[sTicket]) {
				document.basket[sTicket].checked = true;
			}
		}
	}
	
	function cartdeselectall() {
		for (i=1;i<=parseInt(document.basket.NumTickets.value);++i) {
			sTicket = "delitem_"+i;
			if (document.basket[sTicket]) {
				document.basket[sTicket].checked = false;
			}
		}
	}
	function cartcanceltickets() {
		var okay = 0
		
		for (i=1;i<=parseInt(document.basket.NumTickets.value);++i) {
			sTicket = "delitem_"+i;
			if (document.basket[sTicket]) {
				if (document.basket[sTicket].checked == true) {
					okay = 1;
					i = parseInt(document.basket.NumTickets.value)+1
				}
			}
		}		
		
		if (okay==1) {
			if (confirm('Are you sure that you want to remove the selected Tickets?')) {
				document.basket.activity.value="deltickets";
				document.basket.RemoveTickets.disabled= true;
				document.basket.submit();
			}
		} else {
			alert('No Tickets selected.');
		}	
	}		
	
	
