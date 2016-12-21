
// Create global variables for browser type
var isIE = new Boolean(false);
var isNav = new Boolean(false);
var unSupported = new Boolean(false);
var layer = new String();
var style = new String();

// Determine if the browser is Internet Explorer, Navigator,
// or other. Also, set the layer variable depending on the
// type of access it needs.
function checkBrowser(){
  if(navigator.userAgent.indexOf("MSIE") != -1){
    isIE = true;
    layer = ".all";
    style = ".style";
  }else if(navigator.userAgent.indexOf("Nav") != -1){
    isNav = true;
    layer = ".layers";
    style = "";
  }else{
    unSupported = true;
  }
}

// Take the layer state passed in, and change it.
function changeState(layerRef, state){
  eval("document" + layer + "['" + layerRef + "']" + style + ".visibility = '" + state + "'");
}

//-------------------------------------------------------------------------------------


function ValidateTextSearchForm()
{

  if (document.TextSearchForm.sp.value == "")
  {
    alert("Please enter a value for the \"Search Term\" field.");
    document.TextSearchForm.sp.select();
    return (false);
  }

  if (document.TextSearchForm.sp.value.length < 3)
  {
    alert("Please enter at least 3 characters in the \"Search Term\" field.");
    document.TextSearchForm.sp.select();
    return (false);
  }

  var checkOK = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzƒŠŒŽšœžŸªµºÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ0123456789-# \t\r\n\f";
  var checkStr = document.TextSearchForm.sp.value;
  var allValid = true;
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
  }
  if (!allValid)
  {
    alert("Please enter only letter, digit, whitespace and \"#\" characters in the \"Search Term\" field.");
    document.TextSearchForm.sp.select();
    return (false);
  }
  return (true);
}


//-------------------------------------------------------------------------------------

    function show_hide(divid, show) {
        if (tbl = document.getElementById(divid)) {
            if (null == show) show = tbl.style.display == 'none';
            tbl.style.display = (show ? '' : 'none');
        }
    }

//-------------------------------------------------------------------------------------


function tallWindow(name)
{
  var tall_window = 
    window.open(name,"plain","width=625,height=800,scrollbars,resizable");
    tall_window.focus();
    return true;
}


//-------------------------------------------------------------------------------------


function singlevideoWindow(name)
{
  var singlevideoWindow = 
    window.open(name,"plain","width=525,height=410,scrollbars,resizable");
    singlevideoWindow.focus();
    return true;
}


//-------------------------------------------------------------------------------------


function largeWindow(name)
{
  var tall_window = 
    window.open(name,"plain","width=800,height=600,scrollbars,resizable");
    tall_window.focus();
    return true;
}


//-------------------------------------------------------------------------------------


function largevideoWindow(name)
{
  var largevideoWindow = 
    window.open(name,"plain","width=1200,height=800,scrollbars,resizable");
    largevideoWindow.focus();
    return true;
}
//-------------------------------------------------------------------------------------


function smallWindow(name)
{
  var small_window = 
    window.open(name,"plain","width=500,height=350,scrollbars,resizable");
    small_window.focus();
    return true;
}

//-------------------------------------------------------------------------------------

function mediumWindow(name)
{
  var medium_window = 
    window.open(name,"plain","width=640,height=480,scrollbars,resizable");
    medium_window.focus();
    return true;
}

//-------------------------------------------------------------------------------------

function longWindow(name)
{
  var long_window = 
    window.open(name,"plain","width=500,height=450,scrollbars,resizable");
    long_window.focus();
    return true;
}

//-------------------------------------------------------------------------------------

function pictureWindow(name)
{
  var picture_window = 
    window.open(name,"plain","width=650,height=700,scrollbars,resizable");
    picture_window.focus();
    return true;
}

//-------------------------------------------------------------------------------------

function NotWorkingYet()
{
   alert("The requested operation is not available.")
   return (false);
}

//-------------------------------------------------------------------------------------

function page_onchange()
	{
	document.Redirection.submit();
	return 0;
	}

//-------------------------------------------------------------------------------------
		
function ValidateDeliveryOptions()
{
//	var SourceRadioSelected = false;
//	for (i = 0;  i < document.DeliveryOptions.AddressSource.length;  i++)
//	{
//	  if (document.DeliveryOptions.AddressSource[i].checked)
//	      SourceRadioSelected = true;
//	}
	
//	if (!SourceRadioSelected)
//	{
//	  alert("Please select one of the \"Address Source\" options.");
//	  return (false);
//	}
	
	var value = null
//	for (i = 0; i < document.DeliveryOptions.AddressSource.length; i++)
//	{
//		if (document.DeliveryOptions.AddressSource[i].checked)
//		{
//			value = document.DeliveryOptions.AddressSource[i].value
//		}
//	}
	
	if (value == "MCBA")
	{
		alert("MCBA address import disabled. Please select a \"Text File\" option and specify a source file.");
		return (false);
	}
	
	if (document.DeliveryOptions.AddressSource.value == "TXT" && document.DeliveryOptions.AddressFile.value == "" && document.DeliveryOptions.AddressFileLoaded.value == "N")
	{
		alert("Please specify a file under the \"Address Source\" options.");
		document.DeliveryOptions.AddressFile.focus();
		return (false);
	}

	var FormatRadioSelected = false;
	for (i = 0;  i < document.DeliveryOptions.MailFormat.length;  i++)
	{
	  if (document.DeliveryOptions.MailFormat[i].checked)
	      FormatRadioSelected = true;
	}
	
	if (!FormatRadioSelected)
	{
	  alert("Please select one of the \"Mail Format\" options.");
	  return (false);
	}

	var FormatValue = null
	for (i = 0; i < document.DeliveryOptions.MailFormat.length; i++)
	{
		if (document.DeliveryOptions.MailFormat[i].checked)
		{
			FormatValue = document.DeliveryOptions.MailFormat[i].value
		}
	}

	if (FormatValue == 1)
	{
		//alert("HTML formatted mail not yet supported. Please select the \"Plain Text\" option and make sure your body source file is properly formatted.");
		//return (false);
	}
	
	if (document.DeliveryOptions.BodyFile.value == "" && document.DeliveryOptions.BodyFileLoaded.value == "N")
	{
		alert("Please specify a file for \"Body Source\".");
		document.DeliveryOptions.AddressFile.focus();
		return (false);
	}
	
	if (document.DeliveryOptions.Subject.value == "")
	{
		alert("The \"Subject\" field may not be left blank.");
		document.DeliveryOptions.Subject.focus();
		return (false);
	}

	if (document.DeliveryOptions.From.value == "")
	{
		alert("The \"From\" field may not be left blank.");
		document.DeliveryOptions.From.focus();
		return (false);
	}
	
	var checkOK = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzƒŠŒŽšœžŸªµºÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ&' \t\r\n\f";
	var checkStr = document.DeliveryOptions.From.value;
	var allValid = true;
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
	}
	if (!allValid)
	{
	  alert("Please enter only letter and whitespace characters in the \"From\" field.");
	  document.DeliveryOptions.From.focus();
	  return (false);
	}

	
	if (document.DeliveryOptions.ReplyTo.value == "")
	{
		alert("The \"Reply To\" field may not be left blank.");
		document.DeliveryOptions.ReplyTo.focus();
		return (false);
	}
	
	var emailStr = document.DeliveryOptions.ReplyTo.value;
	var checkTLD=1;
	var knownDomsPat=/^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum)$/;
	var emailPat=/^(.+)@(.+)$/;
	var specialChars="\\(\\)><@,;:\\\\\\\"\\.\\[\\]";
	var validChars="\[^\\s" + specialChars + "\]";
	var quotedUser="(\"[^\"]*\")";
	var ipDomainPat=/^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;
	var atom=validChars + '+';
	var word="(" + atom + "|" + quotedUser + ")";
	var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
	var domainPat=new RegExp("^" + atom + "(\\." + atom +")*$");
	var matchArray=emailStr.match(emailPat);

	if (matchArray==null) {

	alert("Email address seems incorrect (check @ and .'s)");
	document.DeliveryOptions.ReplyTo.select();
	return false;
	}
	var user=matchArray[1];
	var domain=matchArray[2];


	for (i=0; i<user.length; i++) {
	if (user.charCodeAt(i)>127) {
	alert("Ths email username contains invalid characters.");
	document.DeliveryOptions.ReplyTo.select();
	return false;
	   }
	}
	for (i=0; i<domain.length; i++) {
	if (domain.charCodeAt(i)>127) {
	alert("Ths email domain name contains invalid characters.");
	document.DeliveryOptions.ReplyTo.select();
	return false;
	   }
	}

	if (user.match(userPat)==null) {

	alert("The email username doesn't seem to be valid.");
	return false;
	}

	var IPArray=domain.match(ipDomainPat);
	if (IPArray!=null) {

	for (var i=1;i<=4;i++) {
	if (IPArray[i]>255) {
	alert("Email destination IP address is invalid!");
	document.DeliveryOptions.ReplyTo.select();
	return false;
	   }
	}
	return true;
	}

	var atomPat=new RegExp("^" + atom + "$");
	var domArr=domain.split(".");
	var len=domArr.length;
	for (i=0;i<len;i++) {
	if (domArr[i].search(atomPat)==-1) {
	alert("The email address domain name does not seem to be valid.");
	document.DeliveryOptions.ReplyTo.select();
	return false;
	   }
	}

	if (checkTLD && domArr[domArr.length-1].length!=2 &&
	domArr[domArr.length-1].search(knownDomsPat)==-1) {
	alert("The email address must end in a well-known domain or two letter " + "country.");
	document.DeliveryOptions.ReplyTo.select();
	return false;
	}

	if (len<2) {
	alert("The email address is missing a hostname.");
	document.DeliveryOptions.ReplyTo.select();
	return false;
	}
	
//	alert("js validation done");
	return (true);//set to TRUE when done testing
}



//-------------------------------------------------------------------------------------

function SendMailWarning()
{
	return confirm("A mass e-mail may take several minutes (roughly 1 minute per 400 addresses) to process and CANNOT BE ABORTED. Do you wish to continue?");
}

//-------------------------------------------------------------------------------------

function StartOverWarning()
{
	return confirm("Are you sure you wish to delete these settings and start the project over?");
}

//-------------------------------------------------------------------------------------

function DeleteProjectWarning()
{
	return confirm("Are you sure you wish to delete this project? This action cannot be reversed.");
}

//-------------------------------------------------------------------------------------

function ValidateUserOptions()
{

	if (document.UserOptions.EditFName.value == "" || document.UserOptions.EditFName.value == " ")
	{
		alert("The \"First Name\" field may not be left blank.");
		document.UserOptions.EditFName.focus();
		return (false);
	}
	
	if (document.UserOptions.EditLName.value == "" || document.UserOptions.EditFName.value == " ")
	{
		alert("The \"Last Name\" field may not be left blank.");
		document.UserOptions.EditLName.focus();
		return (false);
	}
	
	if (document.UserOptions.EditEmail.value == "" || document.UserOptions.EditEmail.value == " ")
	{
		alert("The \"Email\" field may not be left blank.");
		document.UserOptions.EditEmail.focus();
		return (false);
	}
	
	if (document.UserOptions.EditCompany.value == "-1")
	{
		alert("You must select a vaild option for \"Company\".");
		document.UserOptions.EditCompany.focus();
		return (false);
	}
	
	
	var AdminRadioSelected = false;
	for (i = 0;  i < document.UserOptions.admin.length;  i++)
	{
	  if (document.UserOptions.admin[i].checked)
	  {
	      AdminRadioSelected = true;
	  }
	}
	
	if (!AdminRadioSelected)
	{
	  alert("Please select one of the \"Administrator\" options.");
	  return (false);
	}
	
	var AdminValue = null
	for (i = 0; i < document.UserOptions.admin.length; i++)
	{
		if (document.UserOptions.admin[i].checked)
		{
			AdminValue = document.UserOptions.admin[i].value
		}
	}
	
	if (AdminValue == 1 && document.UserOptions.EditUserID.value == 0)
	{
		return confirm("Are you sure you want to make this user an administrator?");
	}
	
	var StatusRadioSelected = false;
	for (i = 0;  i < document.UserOptions.Status.length;  i++)
	{
	  if (document.UserOptions.Status[i].checked)
	  {
	      StatusRadioSelected = true;
	  }
	}
	
	if (!StatusRadioSelected)
	{
	  alert("Please select one of the \"Status\" options.");
	  return (false);
	}
	
	var StatusValue = null
	for (i = 0; i < document.UserOptions.Status.length; i++)
	{
		if (document.UserOptions.Status[i].checked)
		{
			StatusValue = document.UserOptions.Status[i].value
		}
	}
	
	if (StatusValue == 1)
	{
		return confirm("Are you sure you want to disable this user?");
	}

	return (true);//set to TRUE when done testing
}

