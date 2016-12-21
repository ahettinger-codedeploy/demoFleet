
// Localization for FormAssembly.com / wForms v3.2
// English (US) - January 31, 2012, 2:03 pm
if(typeof wFORMS.behaviors.validation.messages === 'undefined'){
    wFORMS.behaviors.validation.messages = {};
}

(function(){
    var key, tmp;
    for(key in (tmp = {
        oneRequired 	: "This section is required.",
        isRequired 		: "This field is required.",
        isAlpha 		: "The text must use alphabetic characters only (a-z, A-Z). Numbers are not allowed.",
        isEmail 		: "This does not appear to be a valid email address.",
        isInteger 		: "Please enter a number (without decimals).",
        isFloat 		: "Please enter a number (e.g. 1.9).",
        isAlphanum 		: "Please use alpha-numeric characters only [a-z 0-9].",
        isDate 			: "This does not appear to be a valid date.",
        isDateTime		: "This does not appear to be a valid date/time.",
        isTime	    	: "This does not appear to be a valid time.",
        isPhone			: "Please enter a valid phone number.",
        isCustom		: "Please enter a valid value.",
        notification_0	: "The form is not complete and has not been submitted yet. There is %% problem with your submission.",
        notification	: "The form is not complete and has not been submitted yet. There are %% problems with your submission.",
        isPasswordStrong: "Please choose a more secure password. Passwords must contain 8 or more characters, with at least 1 letter (a to z), 1 number (0 to 9), and 1 symbol (like \'%\', \'$\' or \'!\').",
        isPasswordMedium: "Please choose a more secure password. Passwords must contain 4 or more characters, with at least 1 letter (a to z) and 1 number (0 to 9).",
        isPasswordWeak  : "Your password cannot be empty.",
        isPasswordConfirmed : "Your password and confirmation field did not match.",
        rangeNumber    : {
            max: "The value must be smaller than the upper bound %1.",
            min: "The value must be greater than the lower bound %1."
        }
    })){
        wFORMS.behaviors.validation.messages[key] = tmp[key];
    }
})();

wFORMS.behaviors.repeat.MESSAGES = {
	ADD_CAPTION 	: "Add another response",
	ADD_TITLE 		: "Will duplicate this question or section.",
	REMOVE_CAPTION 	: "Remove",
	REMOVE_TITLE 	: "Will remove this question or section"
}

wFORMS.behaviors.paging.MESSAGES = {
	CAPTION_NEXT 	 : 'Next Page',
	CAPTION_PREVIOUS : 'Previous Page',
	CAPTION_UNLOAD	 : 'Any data entered on ANY PAGE of this form will be LOST'
}


// Alpha Input Validation:
wFORMS.behaviors.validation.instance.prototype.validateAlpha = function(element, value) {
	var reg =  /^[a-zA-Z\s]+$/;
	return this.isEmpty(value) || reg.test(value);
}
// Alphanumeric Input Validation:
wFORMS.behaviors.validation.instance.prototype.validateAlphanum = function(element, value) {
	var reg =  /^[\u0030-\u0039a-zA-Z\s]+$/;
	return this.isEmpty(value) || reg.test(value);
}

// Calendar
if(!wFORMS.helpers.calendar) {
	wFORMS.helpers.calendar = {};
}
if(!wFORMS.helpers.calendar.locale) {
	wFORMS.helpers.calendar.locale = {};
}
var cfg = wFORMS.helpers.calendar.locale;

cfg.TITLE 				= 'Select a date';
cfg.START_WEEKDAY 		= 0;
cfg.MONTHS_LONG			= [	'January',
							'February',
							'March',
							'April',
							'May',
							'June',
							'July',
							'August',
							'September',
							'October',
							'November',
							'December'
							];
cfg.WEEKDAYS_SHORT		= [ 'Su',
							'Mo',
							'Tu',
							'We',
							'Th',
							'Fr',
							'Sa'
							];
cfg.MDY_DAY_POSITION 		= 2;
cfg.MDY_MONTH_POSITION 		= 1;
cfg.MDY_YEAR_POSITION		= 3;
cfg.DATE_FIELD_DELIMITER	= '/';


wFORMS.behaviors.validation.instance.prototype.validateDate = function(element, value) {
   if(this.isEmpty(value)){
       return true;
   }
 
   var cfg = wFORMS.helpers.calendar.locale;
   
   var re = /^(\d{1,2})[\/\.\-](\d{1,2})[\/\.\-](\d{2,4})$/
   if (re.test(value)) {
      var dArr = value.split(/[\/\.\-]/);
      
      var yr = dArr[cfg.MDY_YEAR_POSITION-1]; 
      if(yr.length==2) yr = (yr>50) ? '19'+yr : '20'+yr;
      var mo = parseInt(dArr[cfg.MDY_MONTH_POSITION-1],10); 
      var dy = parseInt(dArr[cfg.MDY_DAY_POSITION-1],10);
      var d = new Date(yr,mo-1,dy);
      return (d.getMonth() + 1 == mo && 
    		  d.getDate() == dy && 
    		  d.getFullYear() == yr);
   }
   else {
	  return false;
   }
}
