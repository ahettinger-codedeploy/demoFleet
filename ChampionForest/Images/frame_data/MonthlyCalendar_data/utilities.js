function toArray(obj) {
	var arr;
	if (!obj.length || obj.length == 1) {
		arr = [ obj ];
	}
	else {
		arr = obj;
	}
	return arr;
}

function setSelectValue(element, toValue) {
	if(element.tagName != "SELECT") {
		return;
	}
	
	for (var i=0;i<element.options.length;i++) {
		if (element.options[i].value == toValue) {
			element.selectedIndex = i;
			return;
		}
	}
}

function getSelectValue(element) {
	var index = element.selectedIndex;
	if (index >= 0) {
		return element.options[index].value;
	}
	else {
		return '';
	}
}

function setCheckValue(element, toValue){
	var arr = toArray(element);
	for (var i=0; i<arr.length;i++){
		if (arr[i].value == toValue){
			arr[i].checked = true;
		}
	}
}

function setRadioValue(element, toValue) {
	var arr = toArray(element);
	for (var i=0;i<arr.length;i++) {
		if (arr[i].value == toValue) {
			arr[i].checked = true;
			return true;
		}
	}
	return false;
}

function getRadioValue(element) {
	var arr = toArray(element);

	for (var i=0;i<arr.length;i++) {
		if (arr[i].checked)
			return arr[i].value;
	}
	
	return '';
}

function checkboxHasValue(element) {
	var arr = toArray(element);
	for (var i=0;i<arr.length;i++) {
		if (arr[i].checked) {
			return true;
		}
	}
	return false;
}

function getHelp(intHelpID) {
	window.open("/help/Info.asp?intHelpID=" + intHelpID, "HelpPage", "resizable,width=400,height=400,scrollbars=yes")
}

function CurrentBrowser() {
	var ua = " " + window.navigator.userAgent;
	var msie = ua.indexOf("MSIE ");
	var navigator = ua.indexOf("Mozilla");
	var name = 'Unknown';
	var version = 0;

	if (msie >= 1)	{
			name = 'Internet Explorer';
			version = parseInt(ua.substring (msie+5, ua.indexOf (".", msie )));
	}	else if (navigator >= 1) {
			name = 'Netscape Navigator';
			parseInt(ua.substring(navigator+8, ua.indexOf(".", navigator)))
	}	
		
	this.name = name;
	this.version = version;
}	

function setBit(vntValue) {
	var strValue = new String(vntValue);
	
	if (strValue == 'false') 
		return 0;
	else if (strValue == 'true')
		return 1;
	else if (vntValue)
		return 1;
	else
		return 0;	
}

function formatCurrency(num) {
	if(isNaN(num))
		num = "0";

	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num*100+0.50000000001);
	cents = num%100;
	num = Math.floor(num/100).toString();
	if(cents<10)
	cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
	num = num.substring(0,num.length-(4*i+3))+
	num.substring(num.length-(4*i+3));
	return (((sign)?'':'-') + num + '.' + cents);
}

function formatDate(datInput, strFormat) {
	var tempDate = new Date(datInput);
	var tempReturnString = new String();
	var tempFormatString = new String();
	tempFormatString = strFormat
	var tempFormat = new Array();
	tempFormat = tempFormatString.split('*');
	var i = 0;
	var intYear = new String();
		
	var intMonth = tempDate.getMonth() + 1;
	var intDate = tempDate.getDate();
	var intDay = tempDate.getDay();
	intYear = tempDate.getFullYear();
	var intHour = tempDate.getHours();
	var intMinute = tempDate.getMinutes();
	var intSecond = tempDate.getSeconds();
	var strAmPm = new String();
	
	if (intHour == 0) {
		strAmPm = 'am';
		intHour = 12;
	} else if (intHour < 12) {
		strAmPm = 'am';
	} else if (intHour == 12) {
		strAmPm = 'pm';
	} else if (intHour > 12) {
		strAmPm = 'pm';
		intHour = intHour - 12;
	}
		
	var shortDays = new Array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
	var longDays = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
	var shortMonths = new Array('', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	var longMonths = new Array('', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
		
	for (i=0;i<tempFormat.length;i++) {

		switch(tempFormat[i]) {
			case 'DAY':		// Day: ex: MON, TUE, WED
				tempReturnString += shortDays[intDay].toUpperCase();
				break;

			case 'Day':		// Day: ex: Mon, Tue, Wed
				tempReturnString += shortDays[intDay];
				break;

			case 'day':		// Day: ex: mon, tue, wed
				tempReturnString += shortDays[intDay].toLowerCase();
				break;
				
			case 'FDAY':	// Full Day: ex: MONDAY, TUESDAY, WEDNESDAY
				tempReturnString += longDays[intDay].toUpperCase();
				break;					

			case 'Fday':	// Full Day: ex: Monday, Tuesday, Wednesday
				tempReturnString += longDays[intDay];
				break;					

			case 'fday':	// Full Day: ex: monday, tuesday, wednesday
				tempReturnString += longDays[intDay].toLowerCase();
				break;					

			case 'MONTH':	// Month: ex: JAN, FEB, MAR
				tempReturnString += shortMonths[intMonth].toUpperCase();
				break;					

			case 'Month':	// Month: ex: Jan, Feb, Mar
				tempReturnString += shortMonths[intMonth];
				break;					

			case 'month':	// Month: ex: jan, feb, mar
				tempReturnString += shortMonths[intMonth].toLowerCase();
				break;					
					
			case 'FMONTH':	// Full Month: ex: JANUARY, FEBRUARY, MARCH
				tempReturnString += longMonths[intMonth].toUpperCase();
				break;				

			case 'Fmonth':	// Full Month: ex: January, February, March
				tempReturnString += longMonths[intMonth];
				break;				

			case 'fmonth':	// Full Month: ex: january, february, march
				tempReturnString += longMonths[intMonth].toLowerCase();
				break;				

			case 'm':		// Month: ex: 1,2,3,..,12
				tempReturnString += intMonth;
				break;
				
			case 'mm':		// Two Digit Month: ex: 01,02,03,...,12
				tempReturnString += padWithZero(intMonth);
				break;					
				
			case 'd':		// Day: ex: 1,2,3,...20
				tempReturnString += intDate;
				break;
				
			case 'dd':		// Two Digit Day: ex: 01,02,03,...,20
				tempReturnString += padWithZero(intDate);
				break;
				
			case 'yy':		// Two Digit Year: ex: 99,00,01,02
				tempReturnString += intYear.toString().substring(2,4);
				break;
				
			case 'yyyy':	// Four Digit Year: ex: 1999,2000,2001,2002
				tempReturnString += intYear;
				break;
				
			case 'h':		// Hour: ex: 1,2,3,...,11
				tempReturnString += intHour;
				break;
				
			case 'hh':		// Two Digit Hour: ex: 01,02,03,...,11
				tempReturnString += padWithZero(intHour);
				break;
				
			case 'n':		// Minute: ex: 1,2,3,...,35
				tempReturnString += intMinute;
				break;
				
			case 'nn':		// Two Digit Minute: ex: 01,02,03,...,35
				tempReturnString += padWithZero(intMinute);
				break;
				
			case 's':		// Second: ex: 1,2,3,...,45
				tempReturnString += intSecond;
				break;
				
			case 'ss':		// Two Digit Second: ex: 01,02,03,...,45
				tempReturnString += padWithZero(intSecond);
				break;
				
			case 'a':
				tempReturnString += strAmPm.toLowerCase().substring(0,1);
				break;
				
			case 'A':
				tempReturnString += strAmPm.toUpperCase().substring(0,1);
				break;
				
			case 'am':
				tempReturnString += strAmPm.toLowerCase();
				break;
				
			case 'AM':
				tempReturnString += strAmPm.toUpperCase()
				break;
				
			case ':':		// Colon
				tempReturnString += ':';
				break;
				
			case '/':		// Slash Mark
				tempReturnString += '/';
				break;
				
			case '-':		// Dash Mark
				tempReturnString += '-';
				break;
				
			case ' ':		// Space
				tempReturnString += ' ';
				break;
				
			case ',':		// Comma
				tempReturnString += ',';
				break;
		}			
	}	
	return tempReturnString;	
}
	
function padWithZero(intNumber) {
	var returnString = new String();
	var intTempNumber = parseInt(intNumber);
		
	if (intTempNumber < 10) {
		returnString = '0' + intTempNumber.toString();
	} else {
		returnString = intTempNumber.toString();
	}
		
	return returnString;
}

function xmlEncode(obj) {
	var encoded = obj.value ? obj.value : obj.toString();

	encoded = encoded.replace(/[&]/g, "&amp;");
	encoded = encoded.replace(/[<]/g, "&lt;");
	encoded = encoded.replace(/[>]/g, "&gt;");
	encoded = encoded.replace(/[']/g, "&apos;");
	encoded = encoded.replace(/["]/g, "&quot;");
		
	return encoded;
}

function getCookieData(labelName){
	var labelLen = labelName.length;
	var cookieData = document.cookie;
	var cLen = cookieData.length;
	var i = 0;
	var cEnd;				
	
	while (i < cLen) {
		var j = i + labelLen;
		if (cookieData.substring(i, j) == labelName){
			cEnd = cookieData.indexOf(';', j);
			if (cEnd == -1){
				cEnd = cookieData.length;
			}
			return unescape(cookieData.substring(j+1, cEnd));
		}
		i++;			
	}
	return '';			
}
function showCalendar(sElementName) {
		var newWin = window.open("/eventwizard/showCalendar.asp?dFromDate=" + document.forms[0][sElementName].value + "&sElementName=" + sElementName, "newWin", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=190,height=150")
	}
function convertYear(obj){

	var strDate = obj.value;
	var offsetDate = strDate.lastIndexOf("/") + 1;
	var strLenDate = strDate.length;				
	var strYearDate = strDate.substring(offsetDate,strLenDate);	
				
	if (strYearDate.length == 2){					
		strYearDate = '20' + strYearDate;					
		strDate = String(strDate).substring(0, strLenDate - 2) + strYearDate;
	}		
	obj.value = strDate;
	return obj;
}

var include_utilities_loaded = true;
