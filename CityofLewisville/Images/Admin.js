//Global variables
//Date divider character
var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function get_Object(id) {
    var object = null;
    if (document.layers) {
        object = document.layers[id];
    } else if (document.all) {
        object = document.all[id];
    } else if (document.getElementById) {
        object = document.getElementById(id);
    }
    return object;
}

//Makes "title" element have same value as "name"
function fillTitle() {
    //document.all.title.value = document.all.name.value;
    get_Object("title").value = get_Object("name").value;
}

//Integer check
function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function isValidNum(str)
{
	var objRegExp  =  /(^\d*$)/;
  	return objRegExp.test(str);		
}

function isValidNumber(str)
{
	var objRegExp  =  /(^(\d*\.?\d*)$)/;
  	return objRegExp.test(str);		
}

//Opens a calendar picker, requires a field and a default date
function calendarPicker(strField, defdate)
{
	window.open('Modules/DatePicker.aspx?defdate=' + defdate + '&field=' + strField,'calendarPopup','width=190,height=146,resizable=no');
}

//Date validator, based on SmartWebby.com (http://www.smartwebby.com/dhtml/)
function validDate(sender, args)
{
	if (args.Value.length > 0)
		args.IsValid = isDate(args.Value);
	else
		args.IsValid = true;
}

	function stripCharsInBag(s, bag)
	{
		var i;
		var returnString = "";
		// Search through string's characters one by one.
		// If character is not in bag, append to returnString.
		for (i = 0; i < s.length; i++)
		{   
			var c = s.charAt(i);
			if (bag.indexOf(c) == -1) returnString += c;
		}
		return returnString;
	}

	function daysInFebruary (year)
	{
		// February has 29 days in any year evenly divisible by four,
		// EXCEPT for centurial years which are not also divisible by 400.
		return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
	}

	function DaysArray(n)
	{
		for (var i = 1; i <= n; i++)
		{
			this[i] = 31;
			if (i==4 || i==6 || i==9 || i==11)
				this[i] = 30
			if (i==2)
				this[i] = 29
		} 
	return this;
	}

	function isDate(dtStr)
	{
		var daysInMonth = DaysArray(12);
		var pos1 = dtStr.indexOf(dtCh);
		var pos2 = dtStr.indexOf(dtCh,pos1 + 1);
		var strMonth = dtStr.substring(0,pos1);
		var strDay = dtStr.substring(pos1 + 1,pos2);
		var strYear = dtStr.substring(pos2 + 1);
		strYr = strYear;
		if (strDay.charAt(0) == "0" && strDay.length > 1)
			strDay = strDay.substring(1);
		if (strMonth.charAt(0) == "0" && strMonth.length > 1)
			strMonth = strMonth.substring(1);
		for (var i = 1; i <= 3; i++)
		{
			if (strYr.charAt(0) == "0" && strYr.length > 1)
				strYr=strYr.substring(1);
		}
		month = parseInt(strMonth);
		day = parseInt(strDay);
		year = parseInt(strYr);
		if (pos1 == -1 || pos2 == -1)
		{
			//alert("The date format should be: mm/dd/yyyy");
			return false;
		}
		if (strMonth.length < 1 || month < 1 || month > 12)
		{
			//alert("Please enter a valid month.");
			return false;
		}
		if (strDay.length < 1 || day < 1 || day > 31 || (month == 2 && day > daysInFebruary(year)) || day > daysInMonth[month])
		{
			//alert("Please enter a valid day.");
			return false;
		}
		if (strYear.length != 4 || year == 0 || year < minYear || year > maxYear)
		{
			//alert("Please enter a valid 4 digit year between " + minYear + " and " + maxYear + ".");
			return false;
		}
		if (dtStr.indexOf(dtCh,pos2 + 1) != -1 || isInteger(stripCharsInBag(dtStr, dtCh)) == false)
		{
			//alert("Please enter a valid date with the format mm/dd/yyyy.");
			return false;
		}
		return true;
	}

function fillEndDate()
{
	if ((document.all.endDate.value == '') && document.all.startDate.value != '')
		document.all.endDate.value = document.all.startDate.value;
}

function validateStartEndTime(sender, args)
{
	var startDate = document.getElementById("startDate_date").value;
	var endDate = document.getElementById("endDate_date").value;
	var startTime = document.getElementById("startTime_hour").value + ':' + document.getElementById("startTime_minute").value + ':00 ' + document.getElementById("startTime_xm").value
	var endTime = document.getElementById("endTime_hour").value + ':' + document.getElementById("endTime_minute").value + ':00 ' + document.getElementById("endTime_xm").value
	
	if (Date.parse(startDate) == Date.parse(endDate))
	{
		if ((startTime != '::00 ') && (endTime != '::00 '))
		{
			if (Date.parse(startDate + ' ' + startTime) > Date.parse(endDate + ' ' + endTime))
			{
				args.IsValid = false;
			}
			else
			{
				args.IsValid = true;
			}
		}
	}
	else
	{
		args.IsValid = true;
	}
}

function validateSocialNetworkMessageLength(sender, args)
{
	args.IsValid = (args.Value.length <= 110);
}																			  
							
/**************************************************************************/
/**  implementation for View Drop Down Handler                           **/
/**************************************************************************/ 
//Process onchange event from View Drop Down Control
function SetPageByView(strTypeID, strContentGroupID, strViewID, categoryIDsHiddenClientID, categoryCheckedIDsHiddenClientID, showCategoryFilterHiddenCheckBoxID, constrainAreaDivCientID, redirectDivClientID, checkedBoxList, categoryFormLabelType, checkAllCatEnabled)
{
	strViewID = strViewID.replace(/^\s+|\s+$/g,"");
    if (strViewID == '1' || strViewID == '') {
        ShowAssignedArea(redirectDivClientID, true);
        ShowAssignedArea(constrainAreaDivCientID,false);
    } else {
        ShowAssignedArea(redirectDivClientID, false);
        ShowAssignedArea(constrainAreaDivCientID,true);
    }
	switch(strViewID)
	{
	    case '40':
	        ToggleDisplayLeftNavOption(true);
	        ShowRssFeedData(false);
	        ShowIframeUrlData(true);
	        ShowDepartmentConstrainDiv(false);
	        ShowTwitterAccountData(strViewID, checkedBoxList);
	        break;
	    // Nero - 11/15/2010 - Hide Display LeftNav Option for Service Request  
	    case '37':
	        ToggleDisplayLeftNavOption(false);
	        ShowRssFeedData(false);
	        ShowIframeUrlData(false);
	        ShowDepartmentConstrainDiv(true);
	        ShowCategoryData(strTypeID, strContentGroupID, strViewID, categoryIDsHiddenClientID, categoryCheckedIDsHiddenClientID, showCategoryFilterHiddenCheckBoxID, checkedBoxList, categoryFormLabelType, checkAllCatEnabled);
	        break;
	    case '30':
	        ToggleDisplayLeftNavOption(true);
	        ShowRssFeedData(true);
	        ShowIframeUrlData(false);
	        ShowDepartmentConstrainDiv(false);
	        ShowTwitterAccountData(strViewID, checkedBoxList);
			break;
		case '29':
		    ToggleDisplayLeftNavOption(true);
		    ShowRssFeedData(false);
		    ShowIframeUrlData(false);
		    ShowDepartmentConstrainDiv(false);
		    ShowTwitterAccountData(strViewID, checkedBoxList);
		    break;
		case '24':
		case '33':
		case '39':
		    ToggleDisplayLeftNavOption(true);
		    ShowRssFeedData(false);
		    ShowIframeUrlData(false);
		    ShowDepartmentConstrainDiv(false);
		    ShowCategoryData(strTypeID, strContentGroupID, strViewID, categoryIDsHiddenClientID, categoryCheckedIDsHiddenClientID, showCategoryFilterHiddenCheckBoxID, checkedBoxList, categoryFormLabelType, checkAllCatEnabled);
		    break;
		default:
		    ToggleDisplayLeftNavOption(true);
		    ShowRssFeedData(false);
		    ShowIframeUrlData(false);
		    ShowDepartmentConstrainDiv(true);
			ShowCategoryData(strTypeID,strContentGroupID,strViewID,categoryIDsHiddenClientID,categoryCheckedIDsHiddenClientID,showCategoryFilterHiddenCheckBoxID,checkedBoxList,categoryFormLabelType,checkAllCatEnabled);
	}
}
function ShowAssignedArea(areaID, display) {
    var ele = document.getElementById(areaID);
    if (ele) {
        ele.style.display = display ? "block" : "none";
    }
}
							
/**************************************************************************/
/**  implementation for Rss Feed textbox switch                          **/
/**************************************************************************/
var RssFeedDivClientID;
var RssFeedTextBoxClientID;
var RssFeedTextBoxValue;
function ShowRssFeedData(display)
{
	var rssFeedDiv = document.getElementById(RssFeedDivClientID);
	var rssFeedBox = document.getElementById(RssFeedTextBoxClientID);
	if (rssFeedDiv != null) rssFeedDiv.style.display = display ? "block" : "none";
	if (rssFeedBox != null) rssFeedBox.value = display ? RssFeedTextBoxValue : "http://www.asdgfvbxxzb.avn";
}

/**************************************************************************/
/**  implementation for Iframe Url textbox switch                        **/
/**************************************************************************/
var IFrameUrlDivClientID;
var IFrameUrlTextBoxClientID;
var IFrameUrlTextBoxValue;

function ShowIframeUrlData(display) {
    var iFrameUrlDiv = document.getElementById(IFrameUrlDivClientID);
    var iFrameUrlBox = document.getElementById(IFrameUrlTextBoxClientID);

    if (iFrameUrlDiv != null) iFrameUrlDiv.style.display = display ? "block" : "none";
    if (iFrameUrlBox != null) iFrameUrlBox.value = display ? IFrameUrlTextBoxValue : "http://www.asdgfvbxxzb.avn";
}

/**************************************************************************/
/**  implementation for DepartmentConstrainDiv switch                    **/
/**************************************************************************/

var DepartmentConstrainDivClientID;

function ShowDepartmentConstrainDiv(display) {
    var departmentConstrainDiv = document.getElementById(DepartmentConstrainDivClientID);
    if (departmentConstrainDiv != null) departmentConstrainDiv.style.display = display ? "block" : "none";
}

/**************************************************************************/
/** AJAX implementation for TwitterAccount Checkboxes                    **/
/**************************************************************************/
				  
var TwitterAccountIDsHiddenClientID;
var TwitterAccountCheckedIDsHiddenClientID;
var CheckedBoxList_TwitterAccount;

// This function initializes all the global variables and makes the ajax call. 
function ShowTwitterAccountData(strViewID,checkedBoxList)
{
	CheckedBoxList_TwitterAccount = checkedBoxList;
	
	if ((strViewID.length > 0) && (strViewID != '0'))
	{
		var url = 'Modules/GetCheckBoxList.aspx?viewID=' + strViewID;
		xmlHttp = GetXmlHttpObject(stateChangeHandler);
		xmlHttp_Get(xmlHttp, url);
	}
	else
	{
		document.getElementById('twitterAccountsDiv').innerHTML = '';
	}
}

function SetTwitterAccountCheckBox ()
{
	if ((CheckedBoxList_TwitterAccount != null) && (CheckedBoxList_TwitterAccount.length > 0))
	{
		var checkedBox = new Array ();
		checkedBox = CheckedBoxList_TwitterAccount.split (",");
		var twitterAccountCheckBox=document.getElementsByName("TwitterAccountCheckBox");
		for (var i = 0; i < checkedBox.length; i++)
		{
			for (var j = 0; j < twitterAccountCheckBox.length; j++)
			{
				if (twitterAccountCheckBox[j].value == checkedBox[i])
				{
					twitterAccountCheckBox[j].checked = 1;
					break;
				}
			}
		}
	}
}

function FillInTwitterAccountIDs (catid)
{
	if( catid != null )
	{
		var TwitterAccountIDsHidden = document.getElementById (TwitterAccountIDsHiddenClientID);
		TwitterAccountIDsHidden.value = catid;
	}
}

function FillInTwitterAccountCheckedIDs ()
{
	var x=document.getElementsByName("TwitterAccountCheckBox");
	var result = "";
	for (var i=0; i < x.length; i++)
	{
		if (x[i].checked)
			result += x[i].value + "(,%)";
	}
	if (result.length > 0)
	{
		result = result.substring (0, result.length - 4);
	}
	var TwitterAccountCheckedIDsHidden = document.getElementById(TwitterAccountCheckedIDsHiddenClientID);
	TwitterAccountCheckedIDsHidden.value = result;
}

function BuildTwitterAccountList ( jsonObj )
{
	var catid = jsonObj.twitterAccount.id;
	var catname = jsonObj.twitterAccount.name;
	
	var result = "";
	
	if( catid != null && catname != null )
	{
	
		result = "<SPAN class=\"form_label\">Twitter Account<br /></SPAN>";

		result += "<SPAN class=\"form_field\">";
		result += "<div class=\"checkbox_container\">";
		result += "<table class=\"div_style\" border=\"0\">";
		var rowCount = 0;
		for (var i = 0; i < catid.length; i++)
		{
			if (rowCount == 0)
				result += "<tr>";
			result += "<td><input onclick=\"FillInTwitterAccountCheckedIDs();\" name=\"TwitterAccountCheckBox\" type=\"checkbox\" value=\"" + catid[i] + "\" />" + catname[i] + "</td>";
			
			if (rowCount == 2)
				result += "</tr>";
			else if (i == catid.length - 1)
				result += "<td></td></tr>";
			rowCount++;
			if (rowCount >= 3)
				rowCount = 0;
		}

		result += "</table></div></span>";
	
	}
	return result;
}

function SetTwitterAccountList( jsonObj )
{	 
	if( jsonObj != null )
	{
		var twitterAccountsDiv = document.getElementById("twitterAccountsDiv");
		if ( twitterAccountsDiv != null )
		{
			twitterAccountsDiv.innerHTML = BuildTwitterAccountList ( jsonObj );
			twitterAccountsDiv.style.display = "block";
			
			SetTwitterAccountCheckBox ();
			FillInTwitterAccountIDs ( jsonObj.twitterAccount.id );
			FillInTwitterAccountCheckedIDs();
		}
if (typeof DisableTwitterAccountListArea == "function")
DisableTwitterAccountListArea();
	}
	else
	{
		var twitterAccountsDiv = document.getElementById("twitterAccountsDiv");	 
		if ( twitterAccountsDiv != null )
		{
			twitterAccountsDiv.innerHTML = "";
			twitterAccountsDiv.style.display = "none";
			FillInCatEmptyIDs ();
		}
	}
}


/**************************************************************************/
/** AJAX implementation for Category Checkboxes                          **/
/**************************************************************************/
// Global Variables
var xmlHttp;
var CategoryIDsHiddenClientID;
var CategoryCheckedIDsHiddenClientID;
var ShowCategoryFilterHiddenCheckBoxID;
var CheckedBoxList;
var CategoryFormLabelType = 1; //1 for advanced components; 2 for Page Component View
var CheckAllCatEnabled = false;

// This function initializes all the global variables and makes the ajax call. 
function ShowCategoryData(strTypeID,strContentGroupID,strViewID,categoryIDsHiddenClientID,categoryCheckedIDsHiddenClientID,showCategoryFilterHiddenCheckBoxID,checkedBoxList,categoryFormLabelType,checkAllCatEnabled)
{
	if (categoryIDsHiddenClientID.length > 0)
		CategoryIDsHiddenClientID = categoryIDsHiddenClientID;
	if (categoryCheckedIDsHiddenClientID.length > 0)
		CategoryCheckedIDsHiddenClientID = categoryCheckedIDsHiddenClientID;
	if (showCategoryFilterHiddenCheckBoxID.length > 0)
		ShowCategoryFilterHiddenCheckBoxID = showCategoryFilterHiddenCheckBoxID;
	CheckedBoxList = checkedBoxList;
	
	CategoryFormLabelType = categoryFormLabelType;
	CheckAllCatEnabled = checkAllCatEnabled;
	if ((strViewID.length > 0) && (strViewID != '0'))
	{
		var url = 'Modules/GetCheckBoxList.aspx?viewID=' + strViewID;
		xmlHttp = GetXmlHttpObject(stateChangeHandler);
		xmlHttp_Get(xmlHttp, url);
	}
	else if ((strContentGroupID.length > 0) && (strTypeID.length > 0))
	{
		var url = 'Modules/GetCheckBoxList.aspx?typeID=' + strTypeID + '&contentGroupID=' + strContentGroupID;
		xmlHttp = GetXmlHttpObject(stateChangeHandler);
		xmlHttp_Get(xmlHttp, url);
	}
	else
	{
		document.getElementById('categoryAJAXDiv').innerHTML = '';
	}
}
			  
//Edited: Tie
//this handler will fire both twitter account list and category list.
//jsonObj is formatted like {catgory:{id:[], name:['']}, twitterAccount:{id:[], name:['']} }
function stateChangeHandler()
{
	if (xmlHttp.readyState == 4 || xmlHttp.readyState == 'complete')
	{
		var str = xmlHttp.responseText; //gets the response text from GetCheckBoxList.aspx
		var jsonObj = null;
		if ((str.length > 0) && (str != "null"))
		{		 
			jsonObj = eval('('+str+')');
		}
		if( jsonObj != null )
		{
			SetTwitterAccountList(jsonObj);
			SetCategoryList(jsonObj);
		}
	}
	else
	{
	}
}

function SetCategoryList( jsonObj )
{
	if( jsonObj != null )
	{
		var categoryAJAXDiv = document.getElementById("categoryAJAXDiv");
		if ( categoryAJAXDiv != null )
		{
			categoryAJAXDiv.innerHTML = BuildCategoryList ( jsonObj );
			categoryAJAXDiv.style.display = "block";
			
			SetCatCheckBox ();
			FillInCatIDs ( jsonObj.catgory.id );
			FillInCatCheckedIDs();
			
			SetShowCategoryFilter();
			if (CategoryFormLabelType != 1)
				FillInShowCategoryFilter();
			if (CheckAllCatEnabled)
				ReverseCheckAllCategoryCheckBoxes ();
		}
		
if (typeof DisableCategoryArea == "function")
DisableCategoryArea();
	}
	else
	{
		var categoryAJAXDiv = document.getElementById("categoryAJAXDiv");
		categoryAJAXDiv.innerHTML = "";
		categoryAJAXDiv.style.display = "none";
		FillInCatEmptyIDs ();
	}
}

function xmlHttp_Get(xmlhttp, url)
{
	xmlhttp.open('GET', url, true);
	xmlhttp.setRequestHeader("If-Modified-Since", "Fri, 31 Dec 1999 23:59:59 GMT");//This line of code solves the cache issue in IE. 
	xmlhttp.send(null);
}

function GetXmlHttpObject(handler)
{
	var objXmlHttp = null;
	if (navigator.userAgent.indexOf('MSIE') >= 0) // is IE
	{
		// Check IE5 or later. 
		var strObjName = (navigator.appVersion.indexOf("MSIE 5.5")!=-1) ? 'Microsoft.XMLHTTP' : 'Msxml2.XMLHTTP';
		try
		{
			objXmlHttp = new ActiveXObject(strObjName);
			objXmlHttp.onreadystatechange = handler;
		}
		catch(e)
		{
			alert('IE detected, but object could not be created. Verify that active scripting and activeX controls are enabled');
			return;
		}
	}
	else if ((navigator.userAgent.indexOf("Opera6")!=-1)||(navigator.userAgent.indexOf("Opera/6")!=-1))
	{
		// Opera
		alert('Opera detected. The page may not behave as expected.'); 
		return;
	}
	else
	{
		// Mozilla | Netscape | Safari 
		objXmlHttp = new XMLHttpRequest(); 
		objXmlHttp.onload = handler; 
		objXmlHttp.onerror = handler;
	}
	
	return objXmlHttp;
}

//Edited: Tie
//jsonObj is formatted like {catgory:{id:[], name:['']}, twitterAccount:{id:[], name:['']} }
function BuildCategoryList ( jsonObj )
{
	var catid = jsonObj.catgory.id;
	var catname = jsonObj.catgory.name;
	
	var result = "";
	
	if( catid != null && catname != null )
	{
		if (CategoryFormLabelType == 1)
			result = "<SPAN class=\"form_label\">Category</SPAN>";
		else
		{
			result = "<SPAN class=\"form_label\">";
			result += "Category Constraint<br />";
			result += "<span style='font-weight:normal;font-size:10px;line-height:10px;!important'>";
			result += "Please leave all categories unchecked if you do not want to define any constraints.</span>";
			result += "</SPAN>";
		}
		result += "<SPAN class=\"form_field\">";
		result += "<div class=\"checkbox_container\">";
		result += "<table class=\"div_style\" border=\"0\">";
		var rowCount = 0;
		for (var i = 0; i < catid.length; i++)
		{
			if (rowCount == 0)
				result += "<tr>";
			result += "<td><input onclick=\"FillInCatCheckedIDs();\" name=\"CategoryCheckBox\" type=\"checkbox\" value=\"" + catid[i] + "\" />" + catname[i] + "</td>";
			
			if (rowCount == 2)
				result += "</tr>";
			else if (i == catid.length - 1)
				result += "<td></td></tr>";
			rowCount++;
			if (rowCount >= 3)
				rowCount = 0;
		}
        result += "</table></div>";
        if (CategoryFormLabelType != 1)
            result += "<div><input id=\"showCategoryFilter\" name=\"showCategoryFilter\" type=\"checkbox\" onclick=\"FillInShowCategoryFilter();\" checked=\"checked\" /> Show Category Filter</div>";
        if (CheckAllCatEnabled)
            result += "<div style=\"display:none;\"><input id=\"checkAllCat\" type=\"checkbox\" onclick=\"CheckAllCategoryCheckBoxes();\" /> Select All Categories</div>";
        }
        result += "</span>";
	return result;
}

// This function fills in the hidden textbox "CategoryIDsHidden" in CategoryCheckBox.ascx
// All corresponding categories will be filled in. 
// It is being called in stateChangeHandler() of this js file. 
function FillInCatIDs (catid)
{
	if( catid != null )
	{
		var CategoryIDsHidden = document.getElementById (CategoryIDsHiddenClientID);
		CategoryIDsHidden.value = catid;
	}
}

// This function fills in the hidden textbox "CategoryCheckedIDsHidden" in CategoryCheckBox.ascx
// Only checked categories will be filled in. 
// It is being called in stateChangeHandler() of this js file, every time a category checkbox is being clicked,
// or when the checkAllCat checkbox is being clicked. 
function FillInCatCheckedIDs ()
{
	var x=document.getElementsByName("CategoryCheckBox");
	var result = "";
	for (var i=0; i < x.length; i++)
	{
		if (x[i].checked)
			result += x[i].value + "(,%)";
	}			
	if (result.length > 0)
	{
		result = result.substring (0, result.length - 4);
	}
	var CategoryCheckedIDsHidden = document.getElementById(CategoryCheckedIDsHiddenClientID);
	CategoryCheckedIDsHidden.value = result;
				
	if (CheckAllCatEnabled)
		ReverseCheckAllCategoryCheckBoxes ();
}

// This function empties the hidden textbox "CategoryIDsHidden" and "CategoryCheckedIDsHidden" 
// in CategoryCheckBox.ascx. 
// It is being called in stateChangeHandler() of this js file if the response text from
// GetCheckBoxList.aspx is empty or null. 
function FillInCatEmptyIDs ()
{
	var CategoryIDsHidden = document.getElementById (CategoryIDsHiddenClientID);
	CategoryIDsHidden.value = "";
	var CategoryCheckedIDsHidden = document.getElementById(CategoryCheckedIDsHiddenClientID);
	CategoryCheckedIDsHidden.value = "";
}

// This function determines which category checkbox(e)s should be checked based on the CheckedBoxList. 
// It is being called in stateChangeHandler() of this js file. 
function SetCatCheckBox ()
{
	if ((CheckedBoxList != null) && (CheckedBoxList.length > 0))
	{
		//alert(document.getElementsByName("CategoryCheckBox"));
		var checkedBox = new Array ();
		checkedBox = CheckedBoxList.split (",");
		var categoryCheckBox=document.getElementsByName("CategoryCheckBox");
		for (var i = 0; i < checkedBox.length; i++)
		{
			for (var j = 0; j < categoryCheckBox.length; j++)
			{
				if (categoryCheckBox[j].value == checkedBox[i])
				{
					categoryCheckBox[j].checked = 1;
					break;
				}
			}
		}
	}
}


// Used for the "Show Category Filter" Checkbox
// =====================================================================
function FillInShowCategoryFilter ()
{			
	var ShowCategoryFilter = document.getElementById ("showCategoryFilter");
	if(ShowCategoryFilter!=null)
	{
		var ShowCategoryFilterHiddenCheckBox = document.getElementById (ShowCategoryFilterHiddenCheckBoxID); 
		ShowCategoryFilterHiddenCheckBox.checked = ShowCategoryFilter.checked;   
	}
}

function SetShowCategoryFilter()
{
	var ShowCategoryFilter = document.getElementById("showCategoryFilter");
	var ShowCategoryFilterHiddenCheckBox = document.getElementById(ShowCategoryFilterHiddenCheckBoxID);
	
	if ( ShowCategoryFilter != null )
		ShowCategoryFilter.checked = (ShowCategoryFilterHiddenCheckBox != null && ShowCategoryFilterHiddenCheckBox.checked);
}

/*
function SetShowCategoryFilter (isChecked)
{
	var ShowCategoryFilter = document.getElementsById("showCategoryFilter");
	var ShowCategoryFilterHiddenCheckBox = document.getElementById(ShowCategoryFilterHiddenCheckBoxID);
	
	ShowCategoryFilter.checked = isChecked;
	ShowCategoryFilterHiddenCheckBox.checked = ShowCategoryFilter.checked;
}
*/
//
// =====================================================================


// Used for the "Select All Categories" Checkbox
// =====================================================================

// This function checks all the category checkboxes if the checkAllCat checkbox
// is being checked, and would uncheck all the category checkboxes if otherwise. 
function CheckAllCategoryCheckBoxes ()
{
	var checkAllCat = document.getElementById ("checkAllCat");
	var categoryCheckBox=document.getElementsByName("CategoryCheckBox");
	if (categoryCheckBox.length > 0)
	{
		for (var j = 0; j < categoryCheckBox.length; j++)
		{
			categoryCheckBox[j].checked = checkAllCat.checked;
		}
	}
	FillInCatCheckedIDs ();
}

// This function checks if all the category checkboxes are checked. 
// It checks the checkAllCat checkbox if it does, and would uncheck it if otherwise. 
function ReverseCheckAllCategoryCheckBoxes ()
{
	var checkAllCat = document.getElementById ("checkAllCat");
	var categoryCheckBox=document.getElementsByName("CategoryCheckBox");
	var flag = true;
	if (categoryCheckBox.length > 0)
	{
		for (var j = 0; j < categoryCheckBox.length; j++)
		{
			if (categoryCheckBox[j].checked != 1)
			{
				flag = false;
				break;
			}
		}
	}
	if (flag)
		checkAllCat.checked = 1;
	else
		checkAllCat.checked = 0;
}
// =====================================================================
/**************************************************************************/
/** AJAX implementation for Category Checkboxes ENDs                     **/
/**************************************************************************/







/**************************************************************************/
/** AJAX implementation for Social Network Category Checkboxes           **/
/**************************************************************************/
// Global Variables
var xmlHttp_SocialNetwork;
var SocialNetworkCategoryIDsHiddenClientID;
var SocialNetworkCategoryCheckedIDsHiddenClientID;
var ShowSocialNetworkCategoryFilterHiddenCheckBoxID;
var CheckedBoxList_SocialNetwork;
var CheckAllSocialNetworkCatEnabled = false;

// This function initializes all the global variables and makes the ajax call. 
function ShowSocialNetworkCategoryData(strTypeID,strContentGroupID,strViewID,categoryIDsHiddenClientID,categoryCheckedIDsHiddenClientID,showSocialNetworkCategoryFilterHiddenCheckBoxID,checkedBoxList,checkAllSocialNetworkCatEnabled)
{
	if (categoryIDsHiddenClientID.length > 0)
		SocialNetworkCategoryIDsHiddenClientID = categoryIDsHiddenClientID;
	if (categoryCheckedIDsHiddenClientID.length > 0)
		SocialNetworkCategoryCheckedIDsHiddenClientID = categoryCheckedIDsHiddenClientID;
	if (showSocialNetworkCategoryFilterHiddenCheckBoxID.length > 0)
		ShowSocialNetworkCategoryFilterHiddenCheckBoxID = showSocialNetworkCategoryFilterHiddenCheckBoxID;
	CheckedBoxList_SocialNetwork = checkedBoxList;
	CheckAllSocialNetworkCatEnabled = checkAllSocialNetworkCatEnabled;
	if ((strViewID.length > 0) && (strViewID != '0'))
	{
		var url = 'Modules/GetCheckBoxList.aspx?viewID=' + strViewID + '&sn=1';
		xmlHttp_SocialNetwork = GetXmlHttpObject_SocialNetwork(stateChangeHandler_SocialNetwork);
		xmlHttp_SocialNetwork_Get(xmlHttp_SocialNetwork, url);
	}
	else if ((strContentGroupID.length > 0) && (strTypeID.length > 0))
	{
		var url = 'Modules/GetCheckBoxList.aspx?typeID=' + strTypeID + '&contentGroupID=' + strContentGroupID + '&sn=1';
		xmlHttp_SocialNetwork = GetXmlHttpObject_SocialNetwork(stateChangeHandler_SocialNetwork);
		xmlHttp_SocialNetwork_Get(xmlHttp_SocialNetwork, url);
	}
	else
	{
		document.getElementById('socialNetworkCategoryAJAXDiv').innerHTML = '';
		ToggleDivDisplay ("socialNetworkCategoryDiv2", "none");
	}
}

function stateChangeHandler_SocialNetwork()
{
	if (xmlHttp_SocialNetwork.readyState == 4 || xmlHttp_SocialNetwork.readyState == 'complete')
	{
		var str = xmlHttp_SocialNetwork.responseText; //gets the response text from GetSocialNetworkCategoryCheckBoxList.aspx   
		var jsonObj = null;
		if ((str.length > 0) && (str != "null"))
		{		   
			jsonObj = eval('('+str+')');
		}
		if( jsonObj != null )
		{
			var temp = new Array ();
			temp = str.split ("[++]");
			var socialNetworkCategoryAJAXDiv = document.getElementById("socialNetworkCategoryAJAXDiv");
			if ( socialNetworkCategoryAJAXDiv != null )
			{
				socialNetworkCategoryAJAXDiv.innerHTML = BuildSocialNetworkCategoryList ( jsonObj );
				socialNetworkCategoryAJAXDiv.style.display = "block";
				ToggleDivDisplay ("socialNetworkCategoryDiv2", "block");
				
				SetSocialNetworkCatCheckBox ();
				FillInSocialNetworkCatIDs ( jsonObj.catgory.id );
				FillInSocialNetworkCatCheckedIDs();
				
				SetShowSocialNetworkCategoryFilter();
				//if (SocialNetworkCategoryFormLabelType != 1)
				//	FillInShowSocialNetworkCategoryFilter();
				if (CheckAllSocialNetworkCatEnabled)
					ReverseCheckAllSocialNetworkCategoryCheckBoxes ();
			}
		}
		else
		{
			var socialNetworkCategoryAJAXDiv = document.getElementById("socialNetworkCategoryAJAXDiv");
			socialNetworkCategoryAJAXDiv.innerHTML = "";
			socialNetworkCategoryAJAXDiv.style.display = "none";
			ToggleDivDisplay ("socialNetworkCategoryDiv2", "none");
			FillInSocialNetworkCatEmptyIDs ();
		}
	}
	else
	{
	}
}

function xmlHttp_SocialNetwork_Get(xmlhttp, url)
{
	xmlhttp.open('GET', url, true);
	xmlhttp.setRequestHeader("If-Modified-Since", "Fri, 31 Dec 1999 23:59:59 GMT");//This line of code solves the cache issue in IE. 
	xmlhttp.send(null);
}

function GetXmlHttpObject_SocialNetwork(handler)
{
	var objXmlHttp = null;
	if (navigator.userAgent.indexOf('MSIE') >= 0) // is IE
	{
		// Check IE5 or later. 
		var strObjName = (navigator.appVersion.indexOf("MSIE 5.5")!=-1) ? 'Microsoft.XMLHTTP' : 'Msxml2.XMLHTTP';
		try
		{
			objXmlHttp = new ActiveXObject(strObjName);
			objXmlHttp.onreadystatechange = handler;
		}
		catch(e)
		{
			alert('IE detected, but object could not be created. Verify that active scripting and activeX controls are enabled');
			return;
		}
	}
	else if ((navigator.userAgent.indexOf("Opera6")!=-1)||(navigator.userAgent.indexOf("Opera/6")!=-1))
	{
		// Opera
		alert('Opera detected. The page may not behave as expected.'); 
		return;
	}
	else
	{
		// Mozilla | Netscape | Safari 
		objXmlHttp = new XMLHttpRequest(); 
		objXmlHttp.onload = handler; 
		objXmlHttp.onerror = handler;
	}
	
	return objXmlHttp;
}


function BuildSocialNetworkCategoryList ( jsonObj )
{
	var catid = jsonObj.catgory.id;
	var catname = jsonObj.catgory.name;
	
	var result = "";
	
	if( catid != null && catname != null )
	{
		result +="<SPAN class=\"form_label\">Social Network Category";
		result += "<img src=\"_gfx/social_icons_all.gif\" alt=\"Social Network Category\" />";
		result += "</SPAN>";

		result += "<SPAN class=\"form_field\">";

		if (CheckAllSocialNetworkCatEnabled)
			result += "<div style=\"display:none;\"><input id=\"checkAllSocialNetworkCat\" type=\"checkbox\" onclick=\"CheckAllSocialNetworkCategoryCheckBoxes();\" /> Select All Social Network Categories</div>";
		result += "<div class=\"checkbox_container\">";
		result += "<table class=\"div_style\" border=\"0\">";
		var rowCount = 0;
		for (var i = 0; i < catid.length; i++)
		{
			if (rowCount == 0)
				result += "<tr>";
			result += "<td><input onclick=\"FillInSocialNetworkCatCheckedIDs();\" name=\"SocialNetworkCategoryCheckBox\" type=\"checkbox\" value=\"" + catid[i] + "\" />" + catname[i] + "</td>";
			
			if (rowCount == 2)
				result += "</tr>";
			else if (i == catid.length - 1)
				result += "<td></td></tr>";
			rowCount++;
			if (rowCount >= 3)
				rowCount = 0;
		}
		
		result += "</table></div></span>";
	}
	return result;
}

// This function fills in the hidden textbox "SocialNetworkCategoryIDsHidden" in SocialNetworkCategoryCheckBox.ascx
// All corresponding categories will be filled in. 
// It is being called in stateChangeHandler_SocialNetwork() of this js file. 
function FillInSocialNetworkCatIDs ( catid )
{
	if( catid != null )
	{
		var SocialNetworkCategoryIDsHidden = document.getElementById (SocialNetworkCategoryIDsHiddenClientID);
		SocialNetworkCategoryIDsHidden.value = catid;
	}
}

// This function fills in the hidden textbox "SocialNetworkCategoryCheckedIDsHidden" in SocialNetworkCategoryCheckBox.ascx
// Only checked categories will be filled in. 
// It is being called in stateChangeHandler_SocialNetwork() of this js file, every time a category checkbox is being clicked,
// or when the checkAllSocialNetworkCat checkbox is being clicked. 
function FillInSocialNetworkCatCheckedIDs ()
{
	var x=document.getElementsByName("SocialNetworkCategoryCheckBox");
	var result = "";
	var checkedFlag = false;
	for (var i=0; i < x.length; i++)
	{
		if (x[i].checked)
		{
			result += x[i].value + "(,%)";
			checkedFlag = true;
		}
	}
	if (result.length > 0)
	{
		result = result.substring (0, result.length - 4);
	}
	var SocialNetworkCategoryCheckedIDsHidden = document.getElementById(SocialNetworkCategoryCheckedIDsHiddenClientID);
	SocialNetworkCategoryCheckedIDsHidden.value = result;
	
	if (CheckAllSocialNetworkCatEnabled)
		ReverseCheckAllSocialNetworkCategoryCheckBoxes ();
	
	if (checkedFlag)
		ToggleDivDisplay ("socialNetworkMessageDiv", "block");
	else
		ToggleDivDisplay ("socialNetworkMessageDiv", "none");
}

// This function empties the hidden textbox "SocialNetworkCategoryIDsHidden" and "SocialNetworkCategoryCheckedIDsHidden" 
// in SocialNetworkCategoryCheckBox.ascx. 
// It is being called in stateChangeHandler_SocialNetwork() of this js file if the response text from
// GetSocialNetworkCategoryCheckBoxList.aspx is empty or null. 
function FillInSocialNetworkCatEmptyIDs ()
{
	var SocialNetworkCategoryIDsHidden = document.getElementById (SocialNetworkCategoryIDsHiddenClientID);
	SocialNetworkCategoryIDsHidden.value = "";
	var SocialNetworkCategoryCheckedIDsHidden = document.getElementById(SocialNetworkCategoryCheckedIDsHiddenClientID);
	SocialNetworkCategoryCheckedIDsHidden.value = "";
}

// This function determines which category checkbox(e)s should be checked based on the CheckedBoxList_SocialNetwork. 
// It is being called in stateChangeHandler_SocialNetwork() of this js file. 
function SetSocialNetworkCatCheckBox ()
{
	if ((CheckedBoxList_SocialNetwork != null) && (CheckedBoxList_SocialNetwork.length > 0))
	{
		//alert(document.getElementsByName("SocialNetworkCategoryCheckBox"));
		var checkedBox = new Array ();
		checkedBox = CheckedBoxList_SocialNetwork.split (",");
		var categoryCheckBox=document.getElementsByName("SocialNetworkCategoryCheckBox");
		for (var i = 0; i < checkedBox.length; i++)
		{
			for (var j = 0; j < categoryCheckBox.length; j++)
			{
				if (categoryCheckBox[j].value == checkedBox[i])
				{
					categoryCheckBox[j].checked = 1;
					break;
				}
			}
		}
	}
}


// Used for the "Show SocialNetworkCategory Filter" Checkbox
// =====================================================================
function FillInShowSocialNetworkCategoryFilter ()
{
	var ShowSocialNetworkCategoryFilter = document.getElementById ("showSocialNetworkCategoryFilter");
	var ShowSocialNetworkCategoryFilterHiddenCheckBox = document.getElementById (ShowSocialNetworkCategoryFilterHiddenCheckBoxID);
	ShowSocialNetworkCategoryFilterHiddenCheckBox.checked = ShowSocialNetworkCategoryFilter.checked;
}

function SetShowSocialNetworkCategoryFilter()
{
	var ShowSocialNetworkCategoryFilter = document.getElementById("showSocialNetworkCategoryFilter");
	var ShowSocialNetworkCategoryFilterHiddenCheckBox = document.getElementById(ShowSocialNetworkCategoryFilterHiddenCheckBoxID);
	
	if ( ShowSocialNetworkCategoryFilter != null )
		ShowSocialNetworkCategoryFilter.checked = (ShowSocialNetworkCategoryFilterHiddenCheckBox != null && ShowSocialNetworkCategoryFilterHiddenCheckBox.checked);
}

// =====================================================================


// Used for the "Select All SocialNetworkCategories" Checkbox
// =====================================================================

// This function checks all the category checkboxes if the checkAllSocialNetworkCat checkbox
// is being checked, and would uncheck all the category checkboxes if otherwise. 
function CheckAllSocialNetworkCategoryCheckBoxes ()
{
	var checkAllSocialNetworkCat = document.getElementById ("checkAllSocialNetworkCat");
	var categoryCheckBox=document.getElementsByName("SocialNetworkCategoryCheckBox");
	if (categoryCheckBox.length > 0)
	{
		for (var j = 0; j < categoryCheckBox.length; j++)
		{
			categoryCheckBox[j].checked = checkAllSocialNetworkCat.checked;
		}
	}
	FillInSocialNetworkCatCheckedIDs ();
}

// This function checks if all the category checkboxes are checked. 
// It checks the checkAllSocialNetworkCat checkbox if it does, and would uncheck it if otherwise. 
function ReverseCheckAllSocialNetworkCategoryCheckBoxes ()
{
	var checkAllSocialNetworkCat = document.getElementById ("checkAllSocialNetworkCat");
	var categoryCheckBox=document.getElementsByName("SocialNetworkCategoryCheckBox");
	var flag = true;
	if (categoryCheckBox.length > 0)
	{
		for (var j = 0; j < categoryCheckBox.length; j++)
		{
			if (categoryCheckBox[j].checked != 1)
			{
				flag = false;
				break;
			}
		}
	}
	if(checkAllSocialNetworkCat!=null)
	{
		if (flag)
			checkAllSocialNetworkCat.checked = 1;
		else
			checkAllSocialNetworkCat.checked = 0;
	}
}

// =====================================================================

function ToggleDivDisplay (id, display)
{
	var socialNetworkMessageDiv = document.getElementById (id);
	if (socialNetworkMessageDiv != null)
	{
		socialNetworkMessageDiv.style.display = display;
	}
	return true;
}

function SetRssURL (display, url)
{
	var rssURLDiv = document.getElementById ("rssURLDiv");
	if (rssURLDiv != null)
	{
		rssURLDiv.style.display = display;
	}
	var rssURLTextBox = document.getElementById ("rssURLTextBox");
	if (rssURLTextBox != null)
	{
		rssURLTextBox.value = url;
		rssURLTextBox.select();
	}
	return true;
}

/**************************************************************************/
/** AJAX implementation for Social Network Category Checkboxes ENDs      **/
/**************************************************************************/








/******************Manage Form Optional Settings************************/
//this function switches the optional settings fieldset visibility.
function toggleOptionalSettings(tab, fieldset)
{
	var imgTab = tab.firstChild;
	if ( imgTab != "undefined" && imgTab.tagName == "IMG" )
	{
		if ( imgTab.src.indexOf("open") > -1 )
		{
			imgTab.src = imgTab.src.replace("open", "closed");
			fieldset.style.display = "none";
		}
		else
		{
			imgTab.src = imgTab.src.replace("closed", "open");
			fieldset.style.display = "block";
		}
	}
}