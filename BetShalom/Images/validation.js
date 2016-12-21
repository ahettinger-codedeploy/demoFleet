var msgInvalidNumber = 'Invalid number \n\n';
var msgInvalidColor  = 'Invalid color \n\n The color must either be a hexidecimal value (##RRGGBB) or a named color (red,white,etc)';
var err = 0;
	
function getCheckboxList(pCtrl,pChecked) {

	if (pChecked==null)pChecked=1;
	
	if (pCtrl) {
		if (pCtrl.length) {
			var vList='';
			
			for (var vI=0; vI<pCtrl.length; vI++) {
				if ( (pCtrl[vI].checked && pChecked) || (!pCtrl[vI].checked && !pChecked) ) {
					vList=vList + pCtrl[vI].value + ',';
				}
			}		
			
			// remove the trailing comma
			if (vList.substring(vList.length-1,vList.length) == ',') {
				vList = vList.slice(0,vList.length-1);
			}
			
			return vList;
		}
		else {
			if ( (pCtrl.checked && pChecked) || (!pCtrl.checked && !pChecked) )
				return pCtrl.value;
		}
	}
	
	return '';
}

function setCheckboxList(pCtrl, pValue) {

	if (pCtrl.length) {
		var vList='';
		
		for (var vI=0; vI<pCtrl.length; vI++) {
			if (!pCtrl[vI].disabled) {
				if (pCtrl[vI].checked != pValue) {
					pCtrl[vI].checked = pValue;
				}
			}
		}		
	}
	else {
		if (!pCtrl.disabled) {	
			if (pCtrl.checked != pValue) {
				pCtrl.checked = pValue;
			}
		}
	}
	
	return true;

}

function setCheckboxState(pCtrl, pState) {

	if (pCtrl.length) {
		for (var vI=0; vI < pCtrl.length; vI++) {
			pCtrl[vI].disabled = !pState;
		}		
	}
	else {
		pCtrl.disabled = !pState;
	}
	
	return true;

}

function getSelectList(pCtrl) {

	if (pCtrl) {
		if (pCtrl.options.length) {
			var vList='';
			
			for (var vI=0; vI<pCtrl.options.length; vI++) {
				if (pCtrl.options[vI].selected) {
					vList = vList + pCtrl.options[vI].value + ',';
				}
			}		
			
			// remove the trailing comma
			if (vList.substring(vList.length-1, vList.length) == ',') {
				vList = vList.slice(0, vList.length-1);
			}
			
			return vList;
		}
		else {
			return '';
		}
	}
	
	return '';
}
	
function getSelectedCount(pCtrl) {

	var vCount=0;
	
	if (pCtrl) {
		if (pCtrl.length) {
			for (var vI=0; vI<pCtrl.length; vI++) {
				if (pCtrl[vI].checked)
					vCount++;
			}		
		}
		else {
			if (pCtrl.checked) 
				vCount=1;
		}
	}
	
	return vCount;
}
	
function getRadioValue(pCtrl) {

	if (pCtrl) {
		if (pCtrl.length) {
			for (var vI=0; vI<pCtrl.length; vI++) {
				if (pCtrl[vI].checked) {
					return pCtrl[vI].value;
				}
			}		
		}
		else {
			return pCtrl.value;
		}
	}
}
	
function hasValue(obj, obj_type) {

	if (!obj) {
		return false;
	}
	
    if (obj_type == "TEXT" || obj_type == "PASSWORD") {
	
    	if (trim(obj.value).length == 0) 
      		return false;
    	else 
      		return true;
			
   	}
    else if (obj_type == "SELECT") {
	
        for (i=0; i < obj.length; i++) {
			if (obj.options[i].selected && obj.options[i].value != '') 
				return true;
		}

       	return false;	
		
	}
    else if (obj_type == "SINGLE_VALUE_RADIO" || obj_type == "SINGLE_VALUE_CHECKBOX") {

		if (obj.checked)
			return true;
		else
       		return false;	
			
	}
    else if (obj_type == "RADIO" || obj_type == "CHECKBOX") {
		if (obj.length) {
	        for (i=0; i < obj.length; i++) {
				if (obj[i].checked)
					return true;
			}
		}
		else {
			return obj.checked;
		}
		
       	return false;	
	}
	
	return false;
}

function isDate(objName) {
  var objRegExp  = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/
  var objRegExp2 = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{2}$/
 
  strValue=objName.value;
  //check to see if in correct format
  if(!objRegExp.test(strValue) && !objRegExp2.test(strValue))
    return false; //doesn't match pattern, bad date
  else{
    var strSeparator = '/';//strValue.substring(2,3) //find date separator
    var arrayDate = strValue.split(strSeparator); //split date into month, day, year
    //create a lookup for months not equal to Feb.
    var arrayLookup = { '01' : 31,'03' : 31, '04' : 30,'05' : 31,'06' : 30,'07' : 31,
                        '08' : 31,'09' : 30,'10' : 31,'11' : 30,'12' : 31}
    var intDay = parseInt(arrayDate[1],10); 

    //check if month value and day value agree
    if(arrayLookup[arrayDate[0]] != null) {
      if(intDay <= arrayLookup[arrayDate[0]] && intDay != 0)
        return true; //found in lookup table, good date
    }
    
    //check for February
    var intYear = parseInt(arrayDate[2],10);
    var intMonth = parseInt(arrayDate[0],10);

	//valid month number?
	if (intMonth <= 12) {
	    if( ((intYear % 4 == 0 && intDay <= 29) || (intYear % 4 != 0 && intDay <=28)) && intDay !=0)
	      return true; //Feb. had valid number of days
	}
  }
  return false; //any other values, bad date
}

function parseDate(strValue) {
  var objRegExp  = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/
  var objRegExp2 = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{2}$/
  
  var dte = new Date();
  
  //check to see if in correct format
  if(!objRegExp.test(strValue) && !objRegExp2.test(strValue))
    return dte; //doesn't match pattern, bad date
  else{
    var strSeparator = '/';//strValue.substring(2,3) //find date separator
    var arrayDate = strValue.split(strSeparator); //split date into month, day, year
    //create a lookup for months not equal to Feb.
    var arrayLookup = { '01' : 31,'03' : 31, '04' : 30,'05' : 31,'06' : 30,'07' : 31,
                        '08' : 31,'09' : 30,'10' : 31,'11' : 30,'12' : 31}

    var intDay = parseInt(arrayDate[1],10); 
    var intYear = parseInt(arrayDate[2],10);
    var intMonth = parseInt(arrayDate[0],10);

    //check if month value and day value agree
    if(arrayLookup[arrayDate[0]] != null) {
      if(intDay <= arrayLookup[arrayDate[0]] && intDay != 0) {
		dte.setMonth(intMonth-1);
		dte.setDate(intDay);
		dte.setYear(intYear);
	  
        return dte; //found in lookup table, good date
	  }
    }

    //check for February

	//valid month number?
	if (intMonth <= 12) {
	    if( ((intYear % 4 == 0 && intDay <= 29) || (intYear % 4 != 0 && intDay <=28)) && intDay !=0) {
	      dte.setMonth(intMonth-1);
		  dte.setDate(intDay);
		  dte.setYear(intYear);
		  
		  return dte;
		}
	}
  }
  return dte; //any other values, bad date
}

function isTime(objName) {
  var objRegExp  = /^\d{1,2}\:\d{1,2}(\ AM|\ PM|\ am|\ pm)/
 
  strValue=objName.value.toUpperCase();
	
  //check to see if in correct format
  if(!objRegExp.test(strValue))
    return false; //doesn't match pattern, bad time
  else{
	
	var arrayTime = strValue.split(':');

	var intHour = parseInt(arrayTime[0], 10); 
	var intMin  = parseInt(arrayTime[1], 10); 

	if (strValue.indexOf('AM') != -1 && strValue.indexOf('AM') + 2 < strValue.length )
		return false;
		
	if (strValue.indexOf('PM') != -1 && strValue.indexOf('PM') + 2 < strValue.length )
		return false;
		
	if ( (intHour >= 1 && intHour <= 12) && (intMin >= 0 && intMin <= 59) )
      return true;
	  
  }
  
  return false; //any other values, bad time
}

function isValidFilename(objName) {

	var i;
	var chr;
	var chrs		='?*\'"\\\/%';
	var objValue	=objName.value;
	var retVal		='';

	for (i=0; i<chrs.length; i++) {
		chr=chrs.charAt(i);

		if (objValue.indexOf(chr) != -1) {
			retVal=retVal + chr + '\n';
		}	
	}

	return retVal;
}

function isValidFileExtension(fileName, fileTypesList) {

	fileTypes = fileTypesList.split(",");
	dots = fileName.split(".");

	//get the part AFTER the LAST period.
	fileType = "." + dots[dots.length-1].toLowerCase();

	return (fileTypes.join(".").indexOf(fileType) != -1);
}

function isLeapYear(intYear) {

	if (intYear % 100 == 0) {
		if (intYear % 400 == 0) { return true; }
	}
	else {
		if ((intYear % 4) == 0) { return true; }
	}

	return false;
}

function isNumeric(objName) {

	var strString;
	var strValidChars = "$%0123456789.,-";
	var strChar;
	
	strString = objName.value;
	
   	//  test strString consists of valid characters listed above
   	for (i = 0; i < strString.length; i++) {
      	strChar = strString.charAt(i);
      	if (strValidChars.indexOf(strChar) == -1) {
         	return false
      	}
   	}

	return true;   
}

function getFileExtension(objName) {
	var objValue=objName.value;
	
	if (objValue.length >= 3) {
		return objValue.substring(objValue.length-3,objValue.length).toLowerCase();
	}
	else return '';	
}

function isColor(objName) {

	var strColor;
	
	strColor = objName.value;

	//
	// A color can either be entered as a hexidecimal value or a named value
	// like white or red.
	//
	
	// does the value start with a #?
	if (strColor.charAt(0) == '#') {
		// make sure the hexidecimal value is the proper length
		if (strColor.length == 7)
			return true;
	}
	else {
		// maybe the value is still a hexidecimal color without the pound
		if (isNumeric(objName)) {
			// add the pound character
			objName.value = '#' + strColor;
			return true;
		}
		
		// perhaps the user entered a named color value, not really any
		// good way to verify this, for now we will make sure the value
		// doesn't have any numbers in it
		for (var i=0; i<strColor.length-1; i++) {
			if (parseInt(strColor.charAt(i)))
				return false;
		}
		
		return true;
	}
	
	return false;
}


function checkTextLength(Limit, objName) {
		
	// Use me to validate the length of a text area.  
	// I require Limit, the numer of characters I am limiting the 
	// text area to, and objName, the text area control I am checking.
	// I will check the length and trim the text area's value if it exceeds Limit.
 		
	if(objName.value.length > Limit - 1 ) {
   		alert('You can only enter ' + Limit + ' characters in this field.');
   		objName.value = objName.value.substring(0, (Limit - 1));
	}
}


function RemoveItemFromList(pList, pItem) {
	var listArray = pList.split(',');
	var newList = '';
	
	for (i=0; i < listArray.length; i++) {
		if (listArray[i] != pItem) {
			newList = AddItemToList(newList, listArray[i]);
		}
	}
	return newList;
}

function AddItemToList(pList, pItem) {
	if (pList.length != 0) {
		pList = pList + ',' + pItem;
	} else {
		pList = pItem;
	}
	return pList;
}

function StringContainsCharacters(pString, pChars) {

	// Returns the invalid characters, otherwise ''
	var invalid = '';
	
	for (var i = 0; (i < pChars.length); i++) {
		if (pString.indexOf(pChars.substr(i, 1)) != -1) {
			invalid = invalid + pChars.substr(i, 1);
		}
	}
	// The characters were not found so it is ok
	return invalid;
}

function InvalidCharacters(pString) {

	// Returns the invalid characters, otherwise ''
	return StringContainsCharacters(pString, '/\\\'",?~!@#$#%^&*()-+{}[]<>_=`'); 
	
}

function RemoveCharacters(pString, pChars) {

	// Returns the string with the specified chars removed
	var result = pString;
	var j = 0;
	
	// Remove the characters
	for (var i = 0; (i < pChars.length); i++) {
		while (result.indexOf(pChars.substr(i, 1)) != -1) {
			j = result.indexOf(pChars.substr(i, 1));
			result = result.substr(0, j) + result.substr(j + 1, result.length - j - 1);
		}
	}
	// Return the result
	return result;
}
function RemoveInvalidCharacters(pString) {
	return RemoveCharacters(pString, '/\\\'",?~!@#$#%^&*()-+{}[]<>=`');
}

function getSelectList(pCtrl) {

	if (pCtrl) {
		if (pCtrl.options.length) {
			var vList='';
			
			for (var vI=0; vI<pCtrl.options.length; vI++) {
				if (pCtrl.options[vI].selected) {
					vList = vList + pCtrl.options[vI].value + ',';
				}
			}		
			
			// remove the trailing comma
			if (vList.substring(vList.length-1, vList.length) == ',') {
				vList = vList.slice(0, vList.length-1);
			}
			
			return vList;
		}
		else {
			return '';
		}
	}
	
	return '';
}

function isValidEmailAddress(s) {
	var temp = s.replace(/\s/g, "")
	return temp.match(/^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/);
}
