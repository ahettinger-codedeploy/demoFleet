// checks the given email form field against the database
// if the email address already exists, return false
function check_email(fld,results)
{
	listName='checkemail';
	var r=document.getElementById(results);
	if(fld.value=='') {
		if(r) r.innerHTML=' ';
	return true;
	}
	reqType=2; // set the xml req mode
	var params='req=checkemail&email='+fld.value;
	var ok=getXmlDocument(params);
	if(ok==0 || ok==fld.value) {
		return true;
		if(r) r.innerHTML=' ';
		}
		
	alert('The email address you specified already exists.');
	//else r.innerHTML='Email address already exists.';
	fld.value='';
	fld.focus();
	return false;

}

function enableButtons()
{
return;
	var aInputs = document.getElementsByTagName("INPUT");
	for ( var i = 0; i < aInputs.length; i++ ) {
		if (aInputs[i].type == "button") {
			aInputs[i].disabled=false;
		}
	}
   return;


}
function disableButtons()
{
return;
	var aInputs = document.getElementsByTagName("INPUT");
	for ( var i = 0; i < aInputs.length; i++ ) {
		if (aInputs[i].type == "button") {
			aInputs[i].disabled=true;
		}
	}
   return;


}

/**
* Default function.  Usually would be overriden by the component
*/
function submitbutton(formname,pressbutton,listmode) {


	
	if(pressbutton.indexOf('delete')>=0)
	{
		if(!confirm('Are you sure you want to delete the item(s)?  This is an unrecoverable operation.'))
		   return false;
	}
	if(pressbutton.indexOf('save')>=0 || pressbutton.indexOf('apply')>=0)
	{
		disableButtons();
	}
	if(window.doFormPost)
	{
	   if(!doFormPost(formname,pressbutton)) return false;  
	}
	submitform(formname,pressbutton,listmode);
}

function getSelectedRadio( srcName ) {
	var aInputs = document.getElementsByTagName("INPUT");
	for ( var i = 0; i < aInputs.length; i++ ) {
		if (aInputs[i].name.substr(0, 3) == "sel") {
			if(aInputs[i].checked) return aInputs[i].value;
		}
	}
   return null;
}

function disableAll( srcName ) {
	var aInputs = document.getElementsByTagName("INPUT");
	for ( var i = 0; i < aInputs.length; i++ ) {
		if (aInputs[i].name.indexOf(srcName)==0) {
			aInputs[i].disabled=true;
		}
	}
   return null;
}


function enableAll( srcName ) {
	var aInputs = document.getElementsByTagName("INPUT");
	for ( var i = 0; i < aInputs.length; i++ ) {
		if (aInputs[i].name.indexOf(srcName)==0) {
			aInputs[i].disabled=false;
		}
	}
   return null;
}


function checkAll( srcName ) {
	var aInputs = document.getElementsByTagName("INPUT");
	for ( var i = 0; i < aInputs.length; i++ ) {
		if (aInputs[i].name.indexOf(srcName)==0) {
			aInputs[i].checked=true;
		}
	}
   return null;
}


function uncheckAll( srcName ) {
	var aInputs = document.getElementsByTagName("INPUT");
	for ( var i = 0; i < aInputs.length; i++ ) {
		if (aInputs[i].name.indexOf(srcName)==0) {
			aInputs[i].checked=false;
		}
	}
   return null;
}

/**
* Submit the admin form
*/
function submitform(formname,pressbutton,listmode){

	var objForm = document.getElementById (formname);
	objForm.action.value=pressbutton+'_'+formname;
	if(listmode=='1' || listmode=='true') {
		val=getSelectedRadio('sel');
		if(val!=null)  {
		try {
			objForm.itm.value=val;
			objForm.onsubmit();
		}
		catch(e){}
		objForm.submit();
	} 
	else
	{
		alert("Please select an item from the list for " + pressbutton);
	}
	} else
	{
		objForm.submit();
	}
}
