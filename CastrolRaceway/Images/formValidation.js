/*
1.	Removing spaces form both sides.
		checkTrim(txtString)
2.  Validation for field which should not be empty
		isEmpty(fieldname,fieldvalue)
    Validation for field which should not be selected
      isSelected(fieldname,fieldvalue)		
3.  Validation for field which can contain only alphanumeric value
		hasOnlyAlphaNumeric(fieldname , fieldvalue)
		hasOnlyAlphaNumericwithDot(fieldname , fieldvalue)
		hasOnlyAlphaNumericWithSymbol(fieldname , fieldvalue)
		isValidString(fieldname , fieldvalue)
4. 	Validation for field which cannot contain Space inbetween.
		isSpace(fieldname, fieldvalue)
5. 	Validation for field which cannot start with number
		isStartsWithNumber(fieldname , fieldvalue)
6. 	Validation for field which can allow only alphabets
		hasOnlyAlphabets(fieldname ,fieldvalue)
		hasOnlyAlphabetsAndSpecificChar(fieldname , fieldvalue)
7. 	Validation for field which allows only numbers
		hasOnlyNumeric(fieldname , fieldvalue)
		hasOnlyNumericAndSpecificChar(fieldname , fieldvalue)
		hasOnlyNumericAndComma(fieldname , fieldvalue)
8. 	Validation for length of the field
		isTooLong(fieldName,checkStr,length)
		isTooShort(fieldName,checkStr,length)
9. 	Check for Valid Email.
		validateEmail(fieldname, fieldvalue)
10.	Validation for two field to be same 			
		isDuplicate(firstValue, secondValue)
11.	returns true if it is a valid phone Number
		isValidPhoneNO(fieldname , fieldvalue)
		validatePhone(fieldname, frmField)
		check_usphone(phonenumber, useareacode)
12.	Validate Date
		validateSingleDate(dtDate)
		validateDate(startDate,endDate)
		isDateBefore(date1Name,date1Value,date2Name,date2Value)
		isDateAfter(date1Name,date1Value,date2Name,date2Value)
13.	Validation for field which cannot contains symebol
		isValidString(fieldname , fieldvalue)
14.	Validation for field which contains file name
		isValidFileName(fieldname , fieldvalue)]
15.	Validation for field which allows only float numbers - allow also negative values
		isValidFloat(fieldname , fieldvalue)
16.	Validation for field which allows only float numbers
		isFloat(fieldname , fieldvalue)
17.	Validation for special characters like < and >.
		isValid(fieldname , fieldvalue)
18.	Credit card validations for diffrent cards
		CheckCardNumber(frmObj)
*/ 
///text counter
function textCounter(field, countfield, maxlimit) {
  if (field.value.length > maxlimit)
      {field.value = field.value.substring(0, maxlimit);}
      else
      {countfield.value = maxlimit - field.value.length;}
  }
  
function checkTrim(txtString)
{
	txtString = LTrim(txtString);
	txtString = RTrim(txtString);
	return txtString;
}

//returns the string after deleting the trailing spaces
function LTrim(txtString) 
{
	ctr = 0;
	while( ctr < txtString.length && (txtString.substring(ctr,ctr+1) == " "))
	{
		ctr=ctr+1;
	}
	return txtString.substring(ctr);
}

// returns the string after deleting the leading spaces
function RTrim(txtString) 
{
	ctr = txtString.length;
	while( ctr > 0  && (txtString.substring(ctr,ctr-1) == " "))
	{
		ctr = ctr - 1;
	}
	return txtString.substring(0,ctr);
}

//Validation for field which should not be empty
function isEmpty(fieldname,fieldvalue)
{
	
	var str=checkTrim(fieldvalue)
	if(str.length==0)
	{
		alert(fieldname + ' cannot be blank ');
		return true;
	}
	return false;
}
//Validation for field which should not be selected
function isSelected(fieldname,fieldvalue)
{
	var str=checkTrim(fieldvalue)
	if(str.length==0)
	{
		alert(fieldname + ' not selected ');
		return true;
	}
	return false;
}

//Validation for field which can contain only alphanumeric value
function hasOnlyAlphaNumeric(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))|| ((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z') )))
		{
			alert(fieldname+' contains only alphanumeric values \n\nValid Characters :(A to Z),(a to z) and (0 to 9) ');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyAlphaNumericWithDotUnderScore(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))|| ((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z') )||(str.charAt(i) <= '.')||(str.charAt(i) <= '_')))
		{
			alert(fieldname+' contains only alphanumeric values \n\nValid Characters :(A to Z),(a to z),(0 to 9), Dot and Underscore');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyAlphaNumericwithDot(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))|| ((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z') )||(str.charAt(i) == '.')||(str.charAt(i) <= ' ')))
		{
			alert(fieldname+' contains only alphanumeric values \n\nValid Characters :(A to Z),(a to z) and (0 to 9) ');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyAlphaNumericWithSymbol(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||(str.charAt(i) <= '@')||((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))|| ((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z') )||(str.charAt(i) <= ' ')))
		{
			alert(fieldname+' contains only alphanumeric values \n\nValid Characters :(A to Z),(a to z) and (0 to 9) and @');
			return false;
		}
		i++;
	}
	return true;
}

//Validation for field which cannot contain Space inbetween.
function isSpace(fieldname , fieldvalue)
{
	var str=fieldvalue
	if((str).indexOf(" ")!=-1)
	{
		alert('Space is not allowed in '+fieldname);
		return false;
	}
	return true;
}

//Validation for field which cannot start with number
function isStartsWithNumber(fieldname , fieldvalue)
{
	var numbers = "0123456789";
	startsWithNumber=false;
	var str = checkTrim(fieldvalue)
	for(i=0;i<numbers.length;i++)
	{	
	   if(str.charAt(0)==numbers.charAt(i))
	   {
	   	alert(fieldname+' cannot start with number');
       	return false;
	   }
	}
	return true;
}

//Validation for field which can allow only alphabets
function hasOnlyAlphabets(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z'))))
		{
			alert(fieldname+' can contain only alphabets\n\nValid Characters: (A to Z),(a to z) ');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyAlphabetsWithSpace(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z'))|| (str.charAt(i) == " ")))
		{
			alert(fieldname+' can contain only alphabets\n\nValid Characters: (A to Z),(a to z) And Space ');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyAlphabetsAndSpecificChar(fieldname , fieldvalue) {
	var str = fieldvalue;
	i = 0;
	while(i < str.length) {
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z') || (str.charAt(i) == " ") || (str.charAt(i) == "-") || (str.charAt(i) == "_") || (str.charAt(i) == ",") || (str.charAt(i) == ".") || (str.charAt(i) == "!") || (str.charAt(i) == "$") ||(str.charAt(i) == "'") || (str.charAt(i) >= "0") && (str.charAt(i) <= "9")))) {
			alert(fieldname+' can contain only alphabets\n\nValid Characters :(A to Z),(a to z),(0 to 9),($,_,!,.,-)whitespace and hyphen ');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyAlphabetsAndSpecificCharBrackets(fieldname , fieldvalue)
{
	var fieldString = checkTrim(fieldvalue);
	var checkString = '~^><';
	
	for(i=0;i<fieldString.length;i++) {
		for(j=0;j<checkString.length;j++) {
		   	if(fieldString.charAt(i) == checkString.charAt(j)) {
		   		alert('Invalid '+fieldname+'');
    	   		return false;
			}
	   }
	}
	return true;
}
function isUrlName(fieldname , fieldvalue)
{
	var fieldString = checkTrim(fieldvalue);
	var checkString = '~^><&%@#$!*(){}[],\',\\,\",?,:,;, ,';
	
	for(i=0;i<fieldString.length;i++) {
		for(j=0;j<checkString.length;j++) {
		   	if(fieldString.charAt(i) == checkString.charAt(j)) {
		   		alert('Invalid '+fieldname+'');
    	   		return false;
			}
	   }
	}
	return true;
}
/*function hasOnlyAlphabetsAndSpecificCharBrackets(fieldname , fieldvalue) {
	var str = fieldvalue;
	i = 0;
	while(i < str.length) {
		if(!(((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z'))||((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z') || (str.charAt(i) == " ") || (str.charAt(i) == "-") || (str.charAt(i) == "_") || (str.charAt(i) == ",") || (str.charAt(i) == ".") || (str.charAt(i) == "!") || (str.charAt(i) == "$") || (str.charAt(i) == "(") || (str.charAt(i) == ")") || (str.charAt(i) == "[") || (str.charAt(i) == "]") || (str.charAt(i) == "@") || (str.charAt(i) == "#") || (str.charAt(i) == "+") || (str.charAt(i) == ";") || (str.charAt(i) == "\\")||(str.charAt(i) == "'") || (str.charAt(i) >= "0") && (str.charAt(i) <= "9")))) {
			alert(fieldname+' can contain only alphabets\n\nValid Characters :(A to Z),(a to z),(0 to 9),($,_,!,.,-,@,#,+,[,],(,),;)whitespace and hyphen ');
			return false;
		}
		i++;
	}
	return true;
}
*/
//Validation for field which allows only numbers
function hasOnlyNumeric(fieldname , fieldvalue)
{
	var str = fieldvalue;
	var i = 0;
	while(i < str.length)
	{
		if(!((str.charAt(i) >= "0") && (str.charAt(i) <= "9")))
		{
			alert(fieldname+' can contain only numeric value');
			return false;
		} else {
			i = i + 1;
		}
	}
	return true;
}

function hasOnlyNumericAndSpecificChar(fieldname , fieldvalue) {
	var str = fieldvalue;
	i = 0;
	while(i < str.length) {
		if(!((str.charAt(i) >= "0") && (str.charAt(i) <= "9") || (str.charAt(i) == "-") || (str.charAt(i) == " ") || (str.charAt(i) == ",") || (str.charAt(i) == "(") || (str.charAt(i) == ")") || (str.charAt(i) == "+") || ((str.charAt(i) >= 'a') && (str.charAt(i) <= 'z')) || ((str.charAt(i) >= 'A') && (str.charAt(i) <= 'Z')) ) ) {
			alert(fieldname+' can contain only numeric value,whitespace and hyphen');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyNumericAndComma(fieldname , fieldvalue) {
	var str = fieldvalue;
	i = 0;
	while(i < str.length) {
		if(!((str.charAt(i) >= "0") && (str.charAt(i) <= "9") || (str.charAt(i) == ",") ) ) {
			alert(fieldname+' can contain only numeric value and comma');
			return false;
		}
		i++;
	}
	return true;
}

function hasOnlyNumericAndDot(fieldname , fieldvalue) {
	var str = fieldvalue;
	i = 0;
	while(i < str.length) {
		if(!((str.charAt(i) >= "0") && (str.charAt(i) <= "9") || (str.charAt(i) == ".") ) ) {
			alert(fieldname+' can contain only numeric value and dot');
			return false;
		}
		i++;
	}
	return true;
}

//Validation for length of the field
function isTooLong(fieldName,checkStr,length)
{
	checkStr = checkTrim(checkStr);
	if((checkStr.length)>length)
	{
		alert (fieldName+' cannot exceed ' + length + ' character');
		return true; // true if the length exceeds
	}
	else 
		return false;  // else false
}

//Validation for length of the field
function isTooShort(fieldName,checkStr,length)
{
	checkStr = checkTrim(checkStr);
	if((checkStr.length) < length)
	{
		alert (fieldName+' cannot shorter than ' + length + ' character');
		return true; // true if the length short
	}
	else 
		return false;  // else false
}

//Check for Valid Email.
function validateEmail(fieldname,frmField) {
	
    //Validating the email field
    //var emailRegxp = /^([\w]+)(.[\w]+){1,4}@([\w]+)(.[\w]+)([.][\w]{2,3}){1,2}$/;
	var emailRegxp = /^([\w-']+(?:\.[\w-']+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/ ;
	//var emailRegxp = /^[A-Za-z][A-Za-z0-9_'-.]+((?:\.[\w-']+)*)@([\w-]+(?:\.[\w-]+)*)(\.[\w]{2,3}){1,2}$/;
	if (!frmField.match(emailRegxp)) {
        alert('Invalid '+fieldname+' ');
        return (false);
    }
    return(true);
}/*
function validateEmail(fieldname, fieldvalue) {
	var fieldString = checkTrim(fieldvalue);
	var checkString = " ~!$%^*()+=?><,;#&|\/:";
	
	for(i=0;i<fieldString.length;i++) {
		for(j=0;j<checkString.length;j++) {
		   	if(fieldString.charAt(i) == checkString.charAt(j)) {
		   		alert('Invalid '+fieldname+'');
    	   		return false;
			}
	   }
	}
	return true;
}
*/
//Validation for two field to be same 			
function isDuplicate(firstValue, secondValue)
{
	if(firstValue == secondValue)
		return true;
	else
		return false;
}

//returns true if it is a valid phone Number
function isValidPhoneNO(fieldname , fieldvalue)
{
	
	var str = fieldvalue;
  var checkOK = "0123456789-";
  var checkStr = checkTrim(str);
  var allValid = true;
  var allNum = "";
  for (i = 0;  i < checkStr.length;  i++)
  {
    ch = checkStr.charAt(i);
    for (j = 0;  j < checkOK.length;  j++)
      if (ch == checkOK.charAt(j))
        break;
    if (j == checkOK.length)
    {
      allValid = false;
      break;
    }
    if (ch != ",")
      allNum += ch;
  }
  if (allValid)
      return (true);
  else
  alert('Please enter valid '+fieldname +'\n\n e.g. XXX-XXX-XXXX');
  	  return (false);
}

//Phone Validation
function validatePhone(fieldname, frmField) {
    //Validating the Phone field
    //return isValid(fieldname, frmField);
	var fieldString = checkTrim(frmField.value);
	var checkString = " ~!$%^*@=?><,;&|\/:";
	
	for(i=0;i<fieldString.length;i++) {
		for(j=0;j<checkString.length;j++) {
		   	if(fieldString.charAt(i) == checkString.charAt(j)) {
		   		alert('Invalid '+fieldname+'');
    	   		return false;
			}
	   }
	}
	return true;
}

function check_usphone(phonenumber,useareacode) 
{ 
	if(!useareacode)useareacode=1; 
	if((phonenumber.match(/^[ ]*[(]{0,1}[ ]*[0-9]{3,3}[ ]*[)]{0,1}[-]{0,1}[ ]*[0-9]{3,3}[ ]*[-]{0,1}[ ]*[0-9]{4,4}[ ]*$/)==null) && ((useareacode!=1) && (phonenumber.match(/^[ ]*[0-9]{3,3}[ ]*[-]{0,1}[ ]*[0-9]{4,4}[ ]*$/)==null))) return false; 
	return true; 
} 

// Validate Single Date
function validateSingleDate(dtDate)
{
	if(dtDate=="")
	{
		alert("Date cannot be empty");
		return false;
	}
	var month;
	var dat;
	var year;
	var firstIndex;
	var secIndex;
	var str = dtDate;
	var i = 0;
	var count=0;
	
	if(str.charAt(0)=="0" && str.charAt(1)=="0")
	{
		alert("Please enter valid Month");
		return false;
	}
	if(str.charAt(3)=="0" && str.charAt(4)=="0")
	{
		alert("Please enter valid Date");
		return false;
	}
	if(str.charAt(6)=="0" && str.charAt(7)=="0" && str.charAt(8)=="0" && str.charAt(9)=="0")
	{
		alert("Please enter valid Year");
		return false;
	}
	if(str.charAt(2)!="/")
	{
		alert("Please enter valid Date (e.g. 02/07/2002)");
		return false;
	}
	
	if(str.charAt(5)!="/")
	{
		alert("Please enter valid Date (e.g. 02/07/2002)");
		return false;
	}
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))|| (str.charAt(i) == '/')))
		{
			alert("Please enter valid Date (e.g. 12/27/2002)");
			return false;
		}
		else
		{
			if(str.charAt(i) == '/')
			count=count+1;
		}
		i++;
	}
	if(count>2)
	{
		alert("Please enter valid Date (e.g. 12/27/2002)");
		return false;
	}
	month=dtDate.substring(0,2);
	dat=dtDate.substring(3,5);
	year=dtDate.substring(6,10);
	if(month>12)
	{
		alert("Please enter valid Date (e.g. 12/27/2002)");
		return false;
	}
	if(month==1 || month==3 ||month==5||month==7||month==8||month==10||month==12)
	{
		if(dat>31)
		{
			alert("Please enter valid Date (e.g. 12/27/2002)");
			return false;
		}
	}
	if(month==2 || month==4 ||month==6||month==9||month==11)
	{
		if(dat>30)
		{
			alert("Please enter valid Date (e.g. 12/27/2002)");
			return false;
		}
	}
	if((year%4==0 && year%100!=0) || year%400==0)
	{
		if(month==2)
		{
			if(dat>29)
			{
				alert("Please enter valid Date (e.g. 12/27/2002)");
				return false;
			}
		}
	}
	else
	{
		if(month==2)
		{
			if(dat>28)
			{
				alert("Please enter valid Date (e.g. 12/27/2002)");
				return false;
			}	
		}
	}
	if(year < 1900 || year > 2050)
	{
		alert("Please enter year between 1900 and 2050");
		return false;
	}
	return true;
}

// Validate Date
function validateDate(startDate,endDate)
{
	
	var TodayDate
	var stDate
	TodayDate = new Date()
	stDate = new Date(startDate)
	enDate = new Date(endDate)
			
	if (TodayDate < stDate)
	{
		alert("From Date cannot be the future date")
		return false;
	}
	if (TodayDate < enDate)
	{
		alert("To Date cannot be the future date")
		return false;
	}
	if (enDate < stDate)
	{
		alert("Invalid Date range selection");
		return false;
	}
	return true;
}

// Validate Date
function isDateBefore(date1Name,date1Value,date2Name,date2Value)
{
	//check that the renew date is not lesser than the date rented
	var vDate1 = convertStringToDate(date1Value,5);
	var vDate2= convertStringToDate(date2Value,5);
	
	if(vDate1<vDate2)
	{
		alert(date1Name+" cannot be earlier than the "+date2Name+".");
		return false;
	}
	return true;
}

// Validate Date
function isDateAfter(date1Name,date1Value,date2Name,date2Value)
{
	//check that the renew date is not lesser than the date rented
	var vDate1 = convertStringToDate(date1Value,5);
	var vDate2= convertStringToDate(date2Value,5);
	
	if(vDate1>vDate2)
	{
		alert(date1Name+" cannot be later than the "+date2Name+".");
		return false;
	}
	return true;
}

//Validation for field which cannot contains symebol
function isValidString(fieldname , fieldvalue)
{
	var fieldString = checkTrim(fieldvalue);
	var checkString = '~!@$%^*()-+=?><"';
	
	for(i=0;i<fieldString.length;i++) {
		for(j=0;j<checkString.length;j++) {
		   	if(fieldString.charAt(i) == checkString.charAt(j)) {
		   		alert('Invalid '+fieldname+'');
    	   		return false;
			}
	   }
	}
	return true;
}

//Validation for field which contains file name
function isValidFileName(fieldname , fieldvalue)
{
	var fieldString = checkTrim(fieldvalue);
	var checkString = "\"~!@#$%^&*()+=|[]{}?><,:;'/\\";
	
	for(i=0;i<fieldString.length;i++) {
		for(j=0;j<checkString.length;j++) {
		   	if(fieldString.charAt(i) == checkString.charAt(j)) {
		   		alert('Invalid '+fieldname+'');
    	   		return false;
			}
	   }
	}
	return true;
}

//Validation for field which allows only float numbers - allow also negative values
function isValidFloat(fieldname , fieldvalue)
{
	var str = fieldvalue;
	var str1;
	i = 0;
	j=0;
	while(i < str.length)
	{
		if((!((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))) && (str.charAt(i) != ".") && (str.charAt(i) != "-"))
		{
			alert(fieldname+' is not valid\n\n e.g -57.55');
			return false;
		}

		if(str.charAt(i) == ".")
			j++;
			
		if(str.charAt(i) == "-"){
			if( i != 0 ){
				alert(fieldname+' is not valid\n\n e.g 57.55');
				return false;
			}
		}
		i++;
	}
	if(j>1)
	{
		alert(fieldname+' is not valid\n\n e.g 57.55');
		return false;
	}
	if(str.indexOf('.')>=0)
	{
		str1=str.substring(str.indexOf('.'),str.length-1);
		if(str1.length>2)
		{
			alert(fieldname+' is not valid\n\n e.g 57.55');
			return false;
		}
	}
	return true;
}

//Validation for field which allows only numbers
function isFloat(fieldname , fieldvalue)
{
	var str = fieldvalue;
	var str1;
	i = 0;
	j=0;
	if(str.charAt(0)==".")
	{
		alert(fieldname+' is not valid\n\n e.g 57.55');
		return false;
	}
	while(i < str.length)
	{
		if((!((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))) && (str.charAt(i) != "."))
		{
			alert(fieldname+' is not valid\n\n e.g 57.55');
			return false;
		}
		if(str.charAt(i) == ".")
			j++;
		i++;
	}
	if(j>1)
	{
		alert(fieldname+' is not valid\n\n e.g 57.55');
		return false;
	}
	if(str.indexOf('.')>=0)
	{
		str1=str.substring(str.indexOf('.'),str.length-1);
		if(str1.length>2)
		{
			alert(fieldname+' is not valid\n\nOnly 2 digits allowed after the decimal');
			return false;
		}
	}
	return true;
}

//Validation for field which can not allow < and > and ".
function isValid(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if((str.charAt(i) == '<') || (str.charAt(i) == '>') || (str.charAt(i) == '\"') || (str.charAt(i) == '\'') || (str.charAt(i) == ' '))
		{
			alert('Invalid '+ fieldname+'');
			return false;
		}
		i++;
	}
	return true;
}

function chkNAN(char2chk)
{
	var validNum = "0123456789"; 
	if (validNum.indexOf(char2chk) == "-1")
	{
		alert("You have entered a non-numeric character.");
		return false;
	}
} 

/*Credit card validations for diffrent cards */
<!-- Original:  Simon Tneoh (tneohcb@pc.jaring.my) -->
<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Begin
var Cards = new makeArray(8);
Cards[0] = new CardType("MasterCard", "51,52,53,54,55", "16");
var MasterCard = Cards[0];
Cards[1] = new CardType("VisaCard", "4", "13,16");
var VisaCard = Cards[1];
Cards[2] = new CardType("AmExCard", "34,37", "15");
var AmExCard = Cards[2];
Cards[3] = new CardType("DinersClubCard", "30,36,38", "14");
var DinersClubCard = Cards[3];
Cards[4] = new CardType("DiscoverCard", "6011", "16");
var DiscoverCard = Cards[4];
Cards[5] = new CardType("enRouteCard", "2014,2149", "15");
var enRouteCard = Cards[5];
Cards[6] = new CardType("JCBCard", "3088,3096,3112,3158,3337,3528", "16");
var JCBCard = Cards[6];
var LuhnCheckSum = Cards[7] = new CardType();

/*************************************************************************\
CheckCardNumber(form)
function called when users click the "check" button.
\*************************************************************************/
function CheckCardNumber(form) {
	var tmpyear;
	if (form.cardNumber.value.length == 0) {
		alert("Please enter a Card Number.");
		form.cardNumber.focus();
		return false;
	}
	if (form.cardExpYear.value.length == 0) {
		alert("Please enter the Expiration Year.");
		form.cardExpYear.focus();
		return false;
	}
	if (form.cardExpYear.value > 96)
		tmpyear = "19" + form.cardExpYear.value;
	else if (form.cardExpYear.value < 21)
		tmpyear = "20" + form.cardExpYear.value;
	else {
		alert("The Expiration Year is not valid.");
		return false;
	}

	tmpmonth = form.cardExpMonth.options[form.cardExpMonth.selectedIndex].value;
	// The following line doesn't work in IE3, you need to change it
	// to something like "(new CardType())...".
	// if (!CardType().isExpiryDate(tmpyear, tmpmonth)) {
	if (!(new CardType()).isExpiryDate(tmpyear, tmpmonth)) {
		alert("This card has already expired.");
		return false;
	}
	card = form.ccType.options[form.ccType.selectedIndex].value;
	var retval = eval(card + ".checkCardNumber(\"" + form.cardNumber.value +
	"\", " + tmpyear + ", " + tmpmonth + ");");
	cardname = "";
	if(retval) {
		// comment this out if used on an order form
		//alert("This card number appears to be valid.");
	} else {
		// The cardnumber has the valid luhn checksum, but we want to know which
		// cardtype it belongs to.
		for (var n = 0; n < Cards.size; n++) {
			if (Cards[n].checkCardNumber(form.cardNumber.value, tmpyear, tmpmonth)) {
				cardname = Cards[n].getCardType();
				break;
			}
		}
		if (cardname.length > 0) {
			alert("This is not a " + card + " number.");
		} else {
			alert("This card number is not valid.");
	  	}
   }
   return retval;
}
/*************************************************************************\
Object CardType([String cardtype, String rules, String len, int year, 
                                        int month])
cardtype    : type of card, eg: MasterCard, Visa, etc.
rules       : rules of the cardnumber, eg: "4", "6011", "34,37".
len         : valid length of cardnumber, eg: "16,19", "13,16".
year        : year of expiry date.
month       : month of expiry date.
eg:
var VisaCard = new CardType("Visa", "4", "16");
var AmExCard = new CardType("AmEx", "34,37", "15");
\*************************************************************************/
function CardType() {
	var n;
	var argv = CardType.arguments;
	var argc = CardType.arguments.length;
	
	this.objname = "object CardType";
	
	var tmpcardtype = (argc > 0) ? argv[0] : "CardObject";
	var tmprules = (argc > 1) ? argv[1] : "0,1,2,3,4,5,6,7,8,9";
	var tmplen = (argc > 2) ? argv[2] : "13,14,15,16,19";
	
	this.setCardNumber = setCardNumber;  // set CardNumber method.
	this.setCardType = setCardType;  // setCardType method.
	this.setLen = setLen;  // setLen method.
	this.setRules = setRules;  // setRules method.
	this.setExpiryDate = setExpiryDate;  // setExpiryDate method.
	
	this.setCardType(tmpcardtype);
	this.setLen(tmplen);
	this.setRules(tmprules);
	if (argc > 4)
	this.setExpiryDate(argv[3], argv[4]);
	
	this.checkCardNumber = checkCardNumber;  // checkCardNumber method.
	this.getExpiryDate = getExpiryDate;  // getExpiryDate method.
	this.getCardType = getCardType;  // getCardType method.
	this.isCardNumber = isCardNumber;  // isCardNumber method.
	this.isExpiryDate = isExpiryDate;  // isExpiryDate method.
	this.luhnCheck = luhnCheck;// luhnCheck method.

	return this;
}

/*************************************************************************\
boolean checkCardNumber([String cardnumber, int year, int month])
return true if cardnumber pass the luhncheck and the expiry date is
valid, else return false.
\*************************************************************************/
function checkCardNumber() {
	var argv = checkCardNumber.arguments;
	var argc = checkCardNumber.arguments.length;
	var cardnumber = (argc > 0) ? argv[0] : this.cardnumber;
	var year = (argc > 1) ? argv[1] : this.year;
	var month = (argc > 2) ? argv[2] : this.month;
	
	this.setCardNumber(cardnumber);
	this.setExpiryDate(year, month);
	
	if (!this.isCardNumber())
		return false;
	if (!this.isExpiryDate())
		return false;
	
	return true;
}
/*************************************************************************\
String getCardType()
return the cardtype.
\*************************************************************************/
function getCardType() {
	return this.cardtype;
}
/*************************************************************************\
String getExpiryDate()
return the expiry date.
\*************************************************************************/
function getExpiryDate() {
	return this.month + "/" + this.year;
}
/*************************************************************************\
boolean isCardNumber([String cardnumber])
return true if cardnumber pass the luhncheck and the rules, else return
false.
\*************************************************************************/
function isCardNumber() {
	var argv = isCardNumber.arguments;
	var argc = isCardNumber.arguments.length;
	var cardnumber = (argc > 0) ? argv[0] : this.cardnumber;
	if (!this.luhnCheck())
		return false;
	
	for (var n = 0; n < this.len.size; n++)
		if (cardnumber.toString().length == this.len[n]) {
		for (var m = 0; m < this.rules.size; m++) {
			var headdigit = cardnumber.substring(0, this.rules[m].toString().length);
			if (headdigit == this.rules[m])
				return true;
			}
			return false;
	}
	return false;
}

/*************************************************************************\
boolean isExpiryDate([int year, int month])
return true if the date is a valid expiry date,
else return false.
\*************************************************************************/
function isExpiryDate() {
	var argv = isExpiryDate.arguments;
	var argc = isExpiryDate.arguments.length;
	
	year = argc > 0 ? argv[0] : this.year;
	month = argc > 1 ? argv[1] : this.month;
	
	if (!isNum(year+""))
		return false;
	if (!isNum(month+""))
		return false;
		
	today = new Date();
	expiry = new Date(year, month);
	if (today.getTime() > expiry.getTime())
		return false;
	else
		return true;
}

/*************************************************************************\
boolean isNum(String argvalue)
return true if argvalue contains only numeric characters,
else return false.
\*************************************************************************/
function isNum(argvalue) {
	argvalue = argvalue.toString();
	
	if (argvalue.length == 0)
		return false;
	
	for (var n = 0; n < argvalue.length; n++)
		if (argvalue.substring(n, n+1) < "0" || argvalue.substring(n, n+1) > "9")
			return false;
	
	return true;
}

/*************************************************************************\
boolean luhnCheck([String CardNumber])
return true if CardNumber pass the luhn check else return false.
Reference: http://www.ling.nwu.edu/~sburke/pub/luhn_lib.pl
\*************************************************************************/
function luhnCheck() {
	var argv = luhnCheck.arguments;
	var argc = luhnCheck.arguments.length;
	
	var CardNumber = argc > 0 ? argv[0] : this.cardnumber;
	
	if (! isNum(CardNumber)) {
		return false;
	}
	
	var no_digit = CardNumber.length;
	var oddoeven = no_digit & 1;
	var sum = 0;
	
	for (var count = 0; count < no_digit; count++) {
		var digit = parseInt(CardNumber.charAt(count));
		if (!((count & 1) ^ oddoeven)) {
			digit *= 2;
		if (digit > 9)
			digit -= 9;
		}
		sum += digit;
	}
	if (sum % 10 == 0)
		return true;
	else
		return false;
}

/*************************************************************************\
ArrayObject makeArray(int size)
return the array object in the size specified.
\*************************************************************************/
function makeArray(size) {
	this.size = size;
	return this;
}

/*************************************************************************\
CardType setCardNumber(cardnumber)
return the CardType object.
\*************************************************************************/
function setCardNumber(cardnumber) {
	this.cardnumber = cardnumber;
	return this;
}

/*************************************************************************\
CardType setCardType(cardtype)
return the CardType object.
\*************************************************************************/
function setCardType(cardtype) {
	this.cardtype = cardtype;
	return this;
}

/*************************************************************************\
CardType setExpiryDate(year, month)
return the CardType object.
\*************************************************************************/
function setExpiryDate(year, month) {
	this.year = year;
	this.month = month;
	return this;
}

/*************************************************************************\
CardType setLen(len)
return the CardType object.
\*************************************************************************/
function setLen(len) {
	// Create the len array.
	if (len.length == 0 || len == null)
	len = "13,14,15,16,19";
	
	var tmplen = len;
	n = 1;
	while (tmplen.indexOf(",") != -1) {
		tmplen = tmplen.substring(tmplen.indexOf(",") + 1, tmplen.length);
		n++;
	}
	this.len = new makeArray(n);
	n = 0;
	while (len.indexOf(",") != -1) {
		var tmpstr = len.substring(0, len.indexOf(","));
		this.len[n] = tmpstr;
		len = len.substring(len.indexOf(",") + 1, len.length);
		n++;
	}
	this.len[n] = len;
	return this;
}

/*************************************************************************\
CardType setRules()
return the CardType object.
\*************************************************************************/
function setRules(rules) {
	// Create the rules array.
	if (rules.length == 0 || rules == null)
		rules = "0,1,2,3,4,5,6,7,8,9";
	  
	var tmprules = rules;
	n = 1;
	while (tmprules.indexOf(",") != -1) {
		tmprules = tmprules.substring(tmprules.indexOf(",") + 1, tmprules.length);
		n++;
	}
	this.rules = new makeArray(n);
	n = 0;
	while (rules.indexOf(",") != -1) {
		var tmpstr = rules.substring(0, rules.indexOf(","));
		this.rules[n] = tmpstr;
		rules = rules.substring(rules.indexOf(",") + 1, rules.length);
		n++;
	}
	this.rules[n] = rules;
	
	return this;
}
/*Credit card validations for diffrent cards */

function getSelectedCount(frm, FieldID, FieldType)
{
	var total = 0;
	
	for(var i = 0; i < frm.length; i++) {
		var element = frm.elements[i];
		var type = element.type;
		var id = element.id;
		if(type == FieldType && id == FieldID && element.checked == true) {
			total = parseInt(total) + 1;
		}
	}
	
	total = parseInt(total);
	return total;
}
function validate_url(fieldvalue) {
	
     var theurl=checkTrim(fieldvalue);
     var tomatch= /http:\/\/[A-Za-z0-9\.-]{3,}\.[A-Za-z]{3}/
     if (tomatch.test(theurl))
     {
         //window.alert("URL OK.");
         return true;
     }
     else
     {
         window.alert("URL invalid. Try again.");
         return false; 
     }
}