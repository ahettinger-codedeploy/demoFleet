// Form Validator Version 2.0 by Viper9kx

// initialize global variables
var submitcount=0;

// check for IE3
var isIE3 = (navigator.appVersion.substr(0,0)+"4.0 (compatible; MSIE 6.0; Win)".indexOf('MSIE 3') != -1);

/***************************************************************
** define and instantiate validation objects
** the validation object accepts the following parameters:
**
**   realName: name used in the alerts (same as label on the page)
**
**   formEltName: this must be the name of the corresponding
**       HTML form element; make it the same as the object name
**
**   eltType: element type (we have to create this since IE3
**       doesn't support the type property for for elements)
**     text
**     textarea
**     checkbox
**     radio
**     select
**
**   uptoSnuff: function call that's evaluated during validation check
**     isText(str)
**     isSelect(formObj)
**     isRadio(formObj)
**     isCheck(formObj, form, [index of first checkbox in group],
**         [number of checkboxes])
**     isEmail(str)
**     isState(str)
**     isZipCode(str)
**     isPhoneNum(str)
**     isDate(str)
**
**   format: text representation of required format;
**       pass 'null' if no required format;
**       used in alert as an aid to user
**
**   submitcount: is used to enusre that form is submitted 
**       only once. user must select start over to submit an
**       additional form.
**  ## NOTE: BE SURE TO INCLUDE THIS CODE SNIPPET WITHIN THE FORM
**       DEFINITION IN THE WEB PAGE HTML: onReset="submitcount=0;"
***************************************************************/

// object definition
function validation(realName, formEltName, eltType, upToSnuff, format) {
  this.realName = realName;
  this.formEltName = formEltName;
  this.eltType = eltType;
  this.upToSnuff = upToSnuff;
  this.format = format;
}

// create a new object for each form element you need to validate
var realFname = new validation('first name', 'realFname', 'text', 'isText(str)', null);
var realLname = new validation('last name', 'realLname', 'text', 'isText(str)', null);
var phoneNum = new validation('phone number', 'phoneNum', 'text', 'isPhoneNum(str)', 'xxx-xxx-xxxx');
var email = new validation('email address', 'email', 'text', 'isEmail(str)', null);
var FirstName = new validation('First Name', 'FirstName', 'select', 'isText(str)', null);
var LastName = new validation('Last Name', 'LastName', 'select', 'isText(str)', null);
var address = new validation('Address', 'address', 'select', 'isText(str)', null);
var city = new validation('City', 'city', 'text', 'isText(str)', null);
var state = new validation('U.S. state code', 'state', 'text', 'isText(str)', null);
var zipcode = new validation('zip code', 'zipcode', 'text', 'isText(str)', null);
var StudentEmail = new validation('Student Email', 'StudentEmail', 'text', 'isText(str)', null);
var instrument = new validation('Instrument', 'instrument', 'text', 'isText(str)', null);
var school = new validation('School', 'school', 'text', 'isText(str)', null);
var grade = new validation('Grade', 'grade', 'text', 'isText(str)', null);
var DateOfBirth = new validation('Date Of Birth', 'DateOfBirth', 'text', 'isText(str)', null);
var CurrentAge = new validation('Current Age', 'CurrentAge', 'text', 'isText(str)', null);
var FatherName = new validation('Father Name', 'FatherName', 'text', 'isText(str)', null);
var MotherName = new validation('Mother Name', 'MotherName', 'text', 'isText(str)', null);
var FatherEmployer = new validation('Father Employer', 'FatherEmployer', 'text', 'isText(str)', null);
var MotherEmployer = new validation('Mother Employer', 'MotherEmployer', 'text', 'isText(str)', null);
var FatherWork = new validation('Father Work', 'FatherWork', 'text', 'isText(str)', null);
var MotherWork = new validation('Mother Work', 'MotherWork', 'text', 'isText(str)', null);
var FatherEmail = new validation('Father Email', 'FatherEmail', 'text', 'isText(str)', null);
var MotherEmail = new validation('Mother Email', 'MotherEmail', 'text', 'isText(str)', null);

/***************************************************************
** Define the elts array:
** Add a new item to the array for each object you create above
** Make sure the value of the array element is the same as
** the name of the object, and that the array elements are listed
** in the same order the corresponding objects appear in the form
** (it's more clear to the user that way)
***************************************************************/
var elts = new Array(
               realFname,
               realLname,
               phoneNum,
               email,
               FirstName,
               LastName,
               address,
               city,
               state,
               zipcode,
               StudentEmail,
               instrument,
               school,
               grade,
               DateOfBirth,
               CurrentAge,
               FatherName,
               MotherName,
               FatherEmployer,
               MotherEmployer,
               FatherWork,
               MotherWork,
               FatherEmail,
               MotherEmail
               );

/***************************************************************
** The main function keeps track of which fields the user missed
** or filled in incorrectly, and alerts the user so they can go
** back and fix what's wrong.
** Set allAtOnce to true if you want this "validation help" to
** alert the user to all mistakes at once; set it to false if
** you want it to show one mistake at a time
***************************************************************/
var allAtOnce = false;

/***************************************************************
** change text for alerts here
** unspecified field (text): "Please include [field name]."
** unspecified field (other): "Please choose [field name]."
** invalid text field entries: "[field value] is an invalid [field name]!"
** help with format: "Use this format: "
***************************************************************/
var beginRequestAlertForText = "Please include ";
var beginRequestAlertGeneric = "Please choose ";
var endRequestAlert = ".";
var beginInvalidAlert = " is an invalid ";
var endInvalidAlert = "!";
var beginFormatAlert = "  Use this format: ";

/***************************************************************
** these functions validate the string or form object passed in,
** and return true or false based on whether the test succeeds or fails
**
** validate existence of input
**   isText(str): verifies text input or textarea is not empty
**   isSelect(formObj): verifies item from a select menu is chosen
**   isRadio(formObj): verifies one of a group of radio buttons is chosen
**   isCheck(formObj, form, [begin], [num]): verifies at least one
**       of a group of checkboxes is checked
**     for [begin], fill in the index number in the elements array
**         of the first checkbox (remember to start counting from zero)
**     for [num], fill in the number of checkboxes in the group
**
** validate text in text input or textarea matches pattern
**   isEmail(str): verifies email address (contains "@" and ".")
**   isState(str): verifies U.S. State Code
**   isZipCode(str): verifies zip code of form xxxxx or xxxxx-xxxx
**   isPhoneNum(str): verifies phone number of form xxx-xxx-xxxx
**   isDate(str): verifies date of form mm/dd/yyyy
***************************************************************/

function isText(str) {
  return (str != "");
}

function isSelect(formObj) {
  return (formObj.selectedIndex != 0);
}

function isRadio(formObj) {
  for (j=0; j<formObj.length; j++) {
    if (formObj[j].checked) {
      return true;
    }
  }
  return false;
}

function isCheck(formObj, form, begin, num) {
  for (j=begin; j<begin+num; j++) {
    if (form.elements[j].checked) {
      return true;
    }
  }
  return false;
}

function isEmail(str) {
  /* The following variable tells the rest of the function whether or not
  to verify that the address ends in a two-letter country or well-known
  TLD.  1 means check it, 0 means don't. */

  var checkTLD=1;

  /* The following is the list of known TLDs that an e-mail address must end with. */

  var knownDomsPat=/^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum)$/;

  /* The following pattern is used to check if the entered e-mail address
  fits the user@domain format.  It also is used to separate the username
  from the domain. */

  var emailPat=/^(.+)@(.+)$/;

  /* The following string represents the pattern for matching all special
  characters.  We don't want to allow special characters in the address. 
  These characters include ( ) < > @ , ; : \ " . [ ] */

  var specialChars="\\(\\)><@,;:\\\\\\\"\\.\\[\\]";

  /* The following string represents the range of characters allowed in a 
  username or domainname.  It really states which chars aren't allowed.*/

  var validChars="\[^\\s" + specialChars + "\]";

  /* The following pattern applies if the "user" is a quoted string (in
  which case, there are no rules about which characters are allowed
  and which aren't; anything goes).  E.g. "jiminy cricket"@disney.com
  is a legal e-mail address. */

  var quotedUser="(\"[^\"]*\")";

  /* The following pattern applies for domains that are IP addresses,
  rather than symbolic names.  E.g. joe@[123.124.233.4] is a legal
  e-mail address. NOTE: The square brackets are required. */

  var ipDomainPat=/^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;

  /* The following string represents an atom (basically a series of non-special characters.) */

  var atom=validChars + '+';

  /* The following string represents one word in the typical username.
  For example, in john.doe@somewhere.com, john and doe are words.
  Basically, a word is either an atom or quoted string. */

  var word="(" + atom + "|" + quotedUser + ")";

  // The following pattern describes the structure of the user

  var userPat=new RegExp("^" + word + "(\\." + word + ")*$");

  /* The following pattern describes the structure of a normal symbolic
  domain, as opposed to ipDomainPat, shown above. */

  var domainPat=new RegExp("^" + atom + "(\\." + atom +")*$");

  /* Finally, let's start trying to figure out if the supplied address is valid. */

  /* Begin with the coarse pattern to simply break up user@domain into
  different pieces that are easy to analyze. */

  var matchArray=str.match(emailPat);

  if (matchArray==null) {

    /* Too many/few @'s or something; basically, this address doesn't
    even fit the general mold of a valid e-mail address. */

    // alert("Email address seems incorrect (check @ and .'s)");
    return false;
    }
  var user=matchArray[1];
  var domain=matchArray[2];

  // Start by checking that only basic ASCII characters are in the strings (0-127).

  for (i=0; i<user.length; i++) {
    if (user.charCodeAt(i)>127) {
      // alert("Ths username contains invalid characters.");
      return false;
      }
    }
  for (i=0; i<domain.length; i++) {
    if (domain.charCodeAt(i)>127) {
      // alert("Ths domain name contains invalid characters.");
      return false;
      }
    }

  // See if "user" is valid 

  if (user.match(userPat)==null) {
    // user is not valid
    // alert("The username doesn't seem to be valid.");
    return false;
    }

  /* if the e-mail address is at an IP address (as opposed to a symbolic
  host name) make sure the IP address is valid. */

  var IPArray=domain.match(ipDomainPat);
  if (IPArray!=null) {

    // this is an IP address

    for (var i=1;i<=4;i++) {
      if (IPArray[i]>255) {
        // alert("Destination IP address is invalid!");
        return false;
        }
      }
    return true;
    }

  // Domain is symbolic name.  Check if it's valid.
 
  var atomPat=new RegExp("^" + atom + "$");
  var domArr=domain.split(".");
  var len=domArr.length;
  for (i=0;i<len;i++) {
    if (domArr[i].search(atomPat)==-1) {
      // alert("The domain name does not seem to be valid.");
      return false;
      }
    }

  /* domain name seems valid, but now make sure that it ends in a
  known top-level domain (like com, edu, gov) or a two-letter word,
  representing country (uk, nl), and that there's a hostname preceding 
  the domain or country. */

  if (checkTLD && domArr[domArr.length-1].length!=2 && domArr[domArr.length-1].search(knownDomsPat)==-1) {
    // alert("The address must end in a well-known domain or two letter " + "country.");
    return false;
    }

  // Make sure there's a host name preceding the domain.

  if (len<2) {
    // alert("This address is missing a hostname!");
    return false;
    }

  // If we've gotten this far, everything's valid!
  return true;
  }

function isState(str) {
  str = str.toUpperCase();
  return ( (str == "AK") || (str == "AL") || (str == "AR") || (str == "AZ") || (str == "CA") || (str == "CO") || (str == "CT") || (str == "DC") || (str == "DE") || (str == "FL") || (str == "GA") || (str == "HI") || (str == "IA") || (str == "ID") || (str == "IL") || (str == "IN") || (str == "KS") || (str == "KY") || (str == "LA") || (str == "MA") || (str == "MD") || (str == "ME") || (str == "MI") || (str == "MN") || (str == "MO") || (str == "MS") || (str == "MT") || (str == "NB") || (str == "NC") || (str == "ND") || (str == "NH") || (str == "NJ") || (str == "NM") || (str == "NV") || (str == "NY") || (str == "OH") || (str == "OK") || (str == "OR") || (str == "PA") || (str == "RI") || (str == "SC") || (str == "SD") || (str == "TN") || (str == "TX") || (str == "UT") || (str == "VA") || (str == "VT") || (str == "WA") || (str == "WI") || (str == "WV") || (str == "WY") );
}

function isZipCode(str) {
  var l = str.length;
  if ((l != 5) && (l != 10)) { return false }
  for (j=0; j<l; j++) {
    if ((l == 10) && (j == 5)) {
      if (str.charAt(j) != "-") { return false }
    } else {
      if ((str.charAt(j) < "0") || (str.charAt(j) > "9")) { return false }
    }
  }
  return true;
}

function isPhoneNum(str) {
  if (str.length != 12) { return false }
  for (j=0; j<str.length; j++) {
    if ((j == 3) || (j == 7)) {
      if (str.charAt(j) != "-") { return false }
    } else {
      if ((str.charAt(j) < "0") || (str.charAt(j) > "9")) { return false }
    }
  }
  return true;
}

function isDate(str) {
  if (str.length != 10) { return false }

  for (j=0; j<str.length; j++) {
    if ((j == 2) || (j == 5)) {
      if (str.charAt(j) != "/") { return false }
    } else {
      if ((str.charAt(j) < "0") || (str.charAt(j) > "9")) { return false }
    }
  }

  var month = str.charAt(0) == "0" ? parseInt(str.substring(1,2)) : parseInt(str.substring(0,2));
  var day = str.charAt(3) == "0" ? parseInt(str.substring(4,5)) : parseInt(str.substring(3,5));
  var begin = str.charAt(6) == "0" ? (str.charAt(7) == "0" ? (str.charAt(8) == "0" ? 9 : 8) : 7) : 6;
  var year = parseInt(str.substring(begin, 10));

  if (day == 0) { return false }
  if (month == 0 || month > 12) { return false }
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
    if (day > 31) { return false }
  } else {
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      if (day > 30) { return false }
    } else {
      if (year%4 != 0) {
        if (day > 28) { return false }
      } else {
        if (day > 29) { return false }
      }
    }
  }
  return true;
}

/***************************************************************
** The validateForm() function validates the form elements
** previously defined as validation objects and as members of
** the elts array. We loop through the elts array, testing each
** element in turn, and alerting the user when they've missed
** a required field
***************************************************************/

function validateForm(form) {
  var formEltName = "";
  var formObj = "";
  var str = "";
  var realName = "";
  var alertText = "";
  var firstMissingElt = null;
  var hardReturn = "\r\n";

  for (i=0; i<elts.length; i++) {
    formEltName = elts[i].formEltName;
    formObj = eval("form." + formEltName);
    realName = elts[i].realName;

    if (elts[i].eltType == "text") {
      str = formObj.value;

      if (eval(elts[i].upToSnuff)) continue;

      if (str == "") {
        if (allAtOnce) {
          alertText += beginRequestAlertForText + realName + endRequestAlert + hardReturn;
          if (firstMissingElt == null) {firstMissingElt = formObj};
        } else {
          alertText = beginRequestAlertForText + realName + endRequestAlert + hardReturn;
          alert(alertText);
        }
      } else {
        if (allAtOnce) {
          alertText += str + beginInvalidAlert + realName + endInvalidAlert + hardReturn;
        } else {
          alertText = str + beginInvalidAlert + realName + endInvalidAlert + hardReturn;
        }
        if (elts[i].format != null) {
          alertText += beginFormatAlert + elts[i].format + hardReturn;
        }
        if (allAtOnce) {
          if (firstMissingElt == null) {firstMissingElt = formObj};
        } else {
          alert(alertText);
        }
      }
    } else {
      if (eval(elts[i].upToSnuff)) continue;
      if (allAtOnce) {
        alertText += beginRequestAlertGeneric + realName + endRequestAlert + hardReturn;
        if (firstMissingElt == null) {firstMissingElt = formObj};
      } else {
        alertText = beginRequestAlertGeneric + realName + endRequestAlert + hardReturn;
        alert(alertText);
      }
    }
    if (!isIE3) {
      var goToObj = (allAtOnce) ? firstMissingElt : formObj;
      if (goToObj.select) goToObj.select();
      if (goToObj.focus) goToObj.focus();
    }
    if (!allAtOnce) {return false};
  }
  if (allAtOnce) {
    if (alertText != "") {
      alert(alertText);
      return false;
    }
  } 
  if (submitcount == 0)
    {
    submitcount++;
    // alert("I am valid!"); //remove this when you use the code
    return true; //and change this to return true
    }
  else 
    {
    alert("This form has already been submitted.  Thanks!");
    return false;
    }
}
