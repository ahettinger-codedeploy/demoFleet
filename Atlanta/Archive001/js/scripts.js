
function openPDSearch () {  
  var searchValue = document.getElementById('leftBarSearchValue').value;
  windowName = 'pdSearch' + (new Date().getTime());
  if(searchValue.length > 0)
	 // window.open ('http://search.atlanta.net/sp?p=quest&keywords='+searchValue, windowName, "width=780,height=700,resizable=1,scrollbars=1");
	 	  window.location.href = 'http://search.atlanta.net/sp?p=quest&keywords='+searchValue;

  return false;	 
}

function searchKeyHandler() 
{
	if (window.event && window.event.keyCode == 13)
	{
	   event.returnValue=false;
	   event.cancel = true;
	   openPDSearch();
	}
	else
		return true;
}

function openSendToFriend2(url)
{
  window.open('/SendToAFriend.aspx?SendToFriendURL=' + url, 'emailfriend', 'scrollbars=yes,width=458,height=450');
}

function openSendToFriend(url)
{
  window.open('/email_user/emailform.asp?page=' + url, 'emailfriend', 'scrollbars=yes,width=558,height=450');
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } if (errors) alert('The following error(s) occurred:\n'+errors);
  document.MM_returnValue = (errors == '');
}

function doubleDDJump()
{
	var dd1 = document.getElementById('Search1_categoryDropDownSmall');
	
	if (dd1.options[dd1.selectedIndex].value != '')
	{
	  	if(dd1.options[dd1.selectedIndex].value.indexOf('?') > -1)
			window.location.href=dd1.options[dd1.selectedIndex].value +'&area=' + document.getElementById('Search1_areaListDropDown').options[document.getElementById('Search1_areaListDropDown').selectedIndex].value;
		else if(dd1.options[dd1.selectedIndex].value.indexOf('.aspx') > -1)
		{
			window.location.href=dd1.options[dd1.selectedIndex].value +'?area=' + document.getElementById('Search1_areaListDropDown').options[document.getElementById('Search1_areaListDropDown').selectedIndex].value;
		}
		else
			window.location.href=dd1.options[dd1.selectedIndex].value;		
	}
	else
	{
	  alert("Please Select a Category to refine your search parameters");
	}
	return false;
}

function checkRequired(x)
{
  return true;
}