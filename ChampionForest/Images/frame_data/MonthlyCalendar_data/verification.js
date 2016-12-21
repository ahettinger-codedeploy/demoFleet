function finishLater(theForm, theValidation) {
	if (theValidation != '') {
		if (!eval(theValidation)) {			
			return false;
		}		
	}
	if (confirm('This information will be saved and the event will be set to \'Not Yet Submitted.\'  It will be on your homepage until you do something else with it.  Press \'OK\' to contintue.')) {
		theForm.blnFinishLater.value = 'True';
		theForm.submit();
	}
}

function isDateValid(dateStr) {
	var strDate = allTrim(dateStr)

	// if empty, then okay
	if (strDate.length == 0) {
		return true;
	}

	if (strDate.length < 6) {
		return false;
	}

	// Assume they used a slash for the date.
	var dateArray = strDate.split("/");

	// See if they used dashes instead.
	if (dateArray.length == 1) {
		dateArray = strDate.split("-");
	}

	// If they didn't use either one.
	if (dateArray.length == 1) {
		return false;
	}
	
	// Make sure they didn't put in too many slashes.
	if (dateArray.length > 3) {
		return false;
	}

	for (var j = 0; j < dateArray.length; j++) {
		if (!isDigit(dateArray[j])) {
			return false;
		}
		if (j == 0) {
			if (dateArray[j] < 1 || dateArray[j] > 12) {
				return false;
			}
		}
		if (j == 1) {

			// We are dealing with months that only have 30 days in them.
			if (dateArray[0] == 4 || dateArray[0] == 6 || dateArray[0] == 9 || dateArray[0] == 11) {
				if (dateArray[j] < 1 || dateArray[j] > 30) {
					return false;
				}

			// We are dealing with February.
			} else if (dateArray[0] == 2) {
				if (dateArray[j] < 1 || dateArray[j] > 28) {
					if (((dateArray[2] % 4) == 0) && (dateArray[j] == 29)) {
						return true;
					} else {
						return false;
					}
				} else {
					return true;
				}

			// Make sure we are between 1 and 31 otherwise.
			} else {
				if (dateArray[j] < 1 || dateArray[j] > 31) {
					return false;
				}
			}
			
		
		
		}
		

	}
	return true;
}

function isDate(dateStr) {
	
	var strDate = allTrim(dateStr)

	if (strDate.length < 6) {
		return false;
	}

	// Assume they used a slash for the date.
	var dateArray = strDate.split("/");

	// See if they used dashes instead.
	if (dateArray.length == 1) {
		dateArray = strDate.split("-");
	}

	// If they didn't use either one.
	if (dateArray.length == 1) {
		return false;
	}

	// Make sure they didn't put in too many slashes.
	if (dateArray.length > 3) {
		return false;
	}

    //check the year and make sure it is okay. starts here 
    var offset = strDate.lastIndexOf("/") + 1;
    var strlen = strDate.length;

    var str = strDate.substring(offset,strlen);

    if (str.length > 2)
        {
        if (parseInt(str) < 1900)
            {
            return false;
            }
        else
            {
            if (parseInt(str) > 2100)
                {
                return false;
                }
            }
        }
        
    // date code ends here.
    
	for (var j = 0; j < dateArray.length; j++) {
		if (!isDigit(dateArray[j])) {
			return false;
		}
		
		if (j == 2) // Year
		    {
		    if (dateArray[2] == "" ) {
		        return false;
		        }

		    
		    }
		    
		if (j == 0) {
			if (dateArray[j] < 1 || dateArray[j] > 12) {
				return false;
			}
		}
		if (j == 1) {

			// We are dealing with months that only have 30 days in them.
			if (dateArray[0] == 4 || dateArray[0] == 6 || dateArray[0] == 9 || dateArray[0] == 11) {
				if (dateArray[j] < 1 || dateArray[j] > 30) {
					return false;
				}

			// We are dealing with February.
			} else if (dateArray[0] == 2) {
				if (dateArray[j] < 1 || dateArray[j] > 28) {
					if (((dateArray[2] % 4) == 0) && (dateArray[j] == 29)) {
						return true;
					} else {
						return false;
					}
				} else {
				    return true;
				}

			// Make sure we are between 1 and 31 otherwise.
			} else {
				if (dateArray[j] < 1 || dateArray[j] > 31) {
					return false;
				}
			}
		}

	}
	
	
	return true;
}

//-------------------------

function isDate8Digit(dateStr) {
	
	var strDate = allTrim(dateStr)

	if (strDate.length < 8) {
		return false;
	}

	// Assume they used a slash for the date.
	var dateArray = strDate.split("/");

	// See if they used dashes instead.
	if (dateArray.length == 1) {
		dateArray = strDate.split("-");
	}

	// If they didn't use either one.
	if (dateArray.length == 1) {
		return false;
	}

	// Make sure they didn't put in too many slashes.
	if (dateArray.length > 3) {
		return false;
	}

	for (var j = 0; j < dateArray.length; j++) {
		if (!isDigit(dateArray[j])) {
			return false;
		}
		if (j == 0) {
			if (dateArray[j] < 1 || dateArray[j] > 12) {
				return false;
			}
		}
		if (j == 1) {

			// We are dealing with months that only have 30 days in them.
			if (dateArray[0] == 4 || dateArray[0] == 6 || dateArray[0] == 9 || dateArray[0] == 11) {
				if (dateArray[j] < 1 || dateArray[j] > 30) {
					return false;
				}

			// We are dealing with February.
			} else if (dateArray[0] == 2) {
				if (dateArray[j] < 1 || dateArray[j] > 28) {
					if (((dateArray[2] % 4) == 0) && (dateArray[j] == 29)) {
						return true;
					} else {
						return false;
					}
				} else {
					return true;
				}

			// Make sure we are between 1 and 31 otherwise.
			} else {
				if (dateArray[j] < 1 || dateArray[j] > 31) {
					return false;
				}
			}
		}

	}
	return true;
}

//----------------





function isDigit(digitStr) {
	for (var i=0; i < digitStr.length; i++) {
		var digit = digitStr.charAt(i)
		if (digit < "0" || digit > "9")
			if (digit != ",")
				return false;
	}
	return true;
}


function isNumber(digitStr) {
	for (var i=0; i < digitStr.length; i++) {
		var digit = digitStr.charAt(i)
		if (digit < "0" || digit > "9")
			if (digit != ".")
				return false;
	}
	return true;
}

function isInt(digitStr) {
	for (var i=0; i < digitStr.length; i++) {
		var digit = digitStr.charAt(i)	
		if (digit < "0" || digit > "9"){
			return false;
		}
	}
	return true;
}

function isPosNumber(digitStr) {
    if (digitStr.charAt(0) == '-')
        {return false;}
        
	for (var i=0; i < digitStr.length; i++) {
		var digit = digitStr.charAt(i)
		if (digit < "0" || digit > "9")
			if (digit != ".")
				return false;
	}
	return true;
}

function verifyFormCurrency(intQuestionID, strQuestionText) {
	var oElement;
	oElement = document.forms[0]["QID" + intQuestionID];

	var str = new String(oElement.value);
	
	if (str.length == 0) {
		return '';	
	} else {
		str = replaceString(str, '$', '');
		
		if (isNumber(str)) {
			return '';
		} else {
			return 'The information you entered for the question \'' + strQuestionText + '\' is not valid.\nThis answer is required to be a CURRENCY value.\n\n';	
		}		
	}	
}

function getFront(strMain, strSearch) {
	foundOffset = strMain.indexOf(strSearch);
	
	if (foundOffset == -1) 
		return null;
	else
		return strMain.substring(0, foundOffset);	
}

function getEnd(strMain, strSearch) {
	foundOffset = strMain.indexOf(strSearch);
	
	if (foundOffset == -1)
		return null;
	else
		return strMain.substring(foundOffset+strSearch.length,strMain.length);	
}

function replaceString(strMain, strSearch, strReplace) {
	var front = getFront(strMain, strSearch);
	var end = getEnd(strMain, strSearch);
	
	if (front != null && end != null)
		return front + strReplace + end;
	else
		return strMain;	
	
}



function ValidEmail(EmailField) {
	var strValue = new String(EmailField.value);
	
    if (strValue.indexOf ('@',0) == -1 || strValue.indexOf ('.',0) == -1)  {
		return false;        
    } else {
		return true;
	}
}

function isPhone(obj, str) {
      // matches (999)-999-9999, (999) 999-9999, (999)999-999, etc.
      var regexp = /^((\((\d{3})\)|(\d{3}))[- ]?)?(\d{3})[- ]?(\d{4})(\D)*(\d{1,})?$/;
      //var regexp = /^((\((\d{3})\)|(\d{3}))[- ]?)?(\d{3})[- ]?(\d{4})(\D)*(\d{2,})?$/;
      //var regexp = /^((\((\d{3})\)|(\d{3}))[- ]?)?(\d{3})[- ]?(\d{4})$/;
      var newString = new String();

      // exec() returns an array:
      if ( regexp.exec( str ) ) {
		      
		obj.value = '';
				
        // one of $3 or $4 will be null:
        if ((RegExp.$3 == '') && (RegExp.$4 == '')) {
			obj.value = RegExp.$5 + '-' + RegExp.$6
        } else if (RegExp.$3 != '') {
			obj.value = '(' + RegExp.$3 + ') ' + RegExp.$5 + '-' + RegExp.$6
        } else if (RegExp.$4 != '') {
			obj.value = '(' + RegExp.$4 + ') ' + RegExp.$5 + '-' + RegExp.$6
        } else {
			obj.value = RegExp.$3 + RegExp.$4 + RegExp.$5 + RegExp.$6;
		}
				
		newString = obj.value;
				
		if (newString.length < 14) {
			return false;
		} else {
			if (RegExp.$8 != '')
				obj.value = obj.value + ' x' + RegExp.$8;
			return true;
		}
		        
      }
      return false;
		}



function lTrim(x) {
	while(x.charAt(0)==" ") x=x.substring(1,x.length)
 	return x
}

function rTrim(x) {
	while(x.charAt(x.length-1)==" ") x=x.substring(0,x.length-1)
 	return x
}

function allTrim(x) {
	x = rTrim(lTrim(x))
 	return x
}

function isPosInteger(inputVal) {
	inputStr = inputVal.toString()
	for (var i = 0; i < inputStr.length; i++) {
		var oneChar = inputStr.charAt(i)
		if (oneChar < "0" || oneChar > "9") {
			return false
		}
	}
	if (inputStr.length == 0) {
			return false;
	} else {
			return true
	}
}


function verifyFormNumber(intQuestionID, strQuestionText) {
	var oElement;
	oElement = document.forms[0]["QID" + intQuestionID];

	if (isPosInteger(oElement.value) || oElement.value == '')
		return '';
	else
		return 'The information you entered for the question \'' + strQuestionText + '\' is not valid.\nThis answer is required to be a NUMBER.\n\n';
}

function verifyFormDate(intQuestionID, strQuestionText) {
	var oElement;
	oElement = document.forms[0]["QID" + intQuestionID];

	if (isDate(oElement.value) || oElement.value == '')
		return '';
	else
		return 'The information you entered for the question \'' + strQuestionText + '\' is not valid.\nThis answer is required to be a DATE (mm/dd/yyyy).\n\n';
}

function checkLength(oElement) {

}

function QuestionRequired(intQuestionID, strQuestionText) {
	var inputType = new String('');
	var oElement;
	var strReturnText = new String('');

	oElement = document.forms[0]['QID' + intQuestionID]
	
	if (oElement) {
		if (oElement.type || oElement.length) {
			inputType = oElement.type;
			strReturnText = 'Please provide an answer for the following question: \'' + strQuestionText + '\'\n\n';

			if (inputType == 'text') {
				if (oElement.value == '')
					return strReturnText;
			} else if (inputType == 'select-one') {
				if (getSelectValue(oElement) == 'AID$0' || getSelectValue(oElement) == '')
					return strReturnText;
			} else if (inputType == 'select-multiple') {
				if (oElement.selectedIndex == -1)
					return strReturnText;
			} else if (inputType == 'textarea') {
				if (oElement.value == '')
					return strReturnText;
			} else if (inputType == 'radio') {
				if (!oElement.checked)
					return strReturnText;
			} else if (inputType == 'checkbox') {
				if (!oElement.checked)
					return strReturnText;
			} else if (oElement[0].type == 'radio') {
				if (getRadioValue(oElement) == '')
					return strReturnText;
			} else if (oElement[0].type == 'checkbox') {
				if (!checkboxHasValue(oElement)) 
					return strReturnText;
			} 

		}
	}

	return '';
}
	
function checkTextAreaSize(obj,intSize){				
	var strTextAreaValue = new String(obj.value);		
	if (strTextAreaValue.length > intSize){		
		alert('This is limited to ' + intSize + ' characters. You have reached this limit.');				
		obj.value = strTextAreaValue.substr(0,intSize);				
		return false;
	}			
}	
