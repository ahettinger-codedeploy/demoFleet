function tabbar(action,hl) {
document.form.jsaction.value = action;
document.form.newhl.value = hl;
document.form.submit();
}

function formchanged ()
	{
	document.form.form_changed.value = 'yes';
	}


// Set Focus on the first field that contains an error
function errfocus (fieldname)
		{
		document.forms[0].elements[fieldname].focus();
		}

// Rückfrage (Ja,Nein) auslösen, Aktion zwischenspeichern


// Aktion über URL-Variable verschicken.
	function ActionSubmit(action) {
		document.forms[0].jsaction.value = action;
		document.forms[0].submit();
	}

function formsubmit(action,message) {
	if (message != '')
		{if (confirm (message) == true)
			{
			document.forms[0].action = document.forms[0].action + "?action=" + action;
			document.forms[0].submit();
			}
		}
	else
		{
		document.forms[0].action = document.forms[0].action + "?action=" + action;
		document.forms[0].submit();
		}
}

	<!-- begin to hide script contents from old browsers
	function checksearch()
	  {
		var searchlen = document.forms[0].searchterm.value;
		if(searchlen == "")
			{
			alert("Please type in keyword(s) to search!");
			}
		else {
				ActionSubmit('act_content_search');
			 }
	  }
	// end hiding script from old browsers -->



	function popitup(destination,win_name,win_dim) 
	{
			window.open (destination ,win_name,win_dim + ',' + 'resizable=no,scrollbars=no,toolbar=no,Left=250,Top=250,status=no,directories=no,menubar=no,location=tabelle');
 	}

	function newwindow(destination,win_name,win_dim) 
	{
			window.open (destination ,win_name,win_dim + ',' + 'resizable=yes,scrollbars=yes,toolbar=no,Left=250,Top=250,status=no,directories=no,menubar=no,location=tabelle');
 	}

	if (document.layers) document.captureEvents(Event.KEYPRESS); 
	// needed if you wish to cancel the key

	document.onkeypress = keyhandler;
	
	function keyhandler(e) {
	    if (document.layers){
	        Key = e.which;
			ename = e.target.name;}
	    else{
	        Key = window.event.keyCode;
			ename = window.event.srcElement.name;}

//        alert("Key pressed! ASCII-value: " + Key + " - " + event.srcElement.name);

	    if (Key == 13 && (ename == "searchterm" || ename == "searchterm")){
			var searchlen = document.forms[0].searchterm.value;
			if(searchlen == "")
				{
				alert("Please type in keyword(s) to search!");
			    if (document.layers)
					return false;
		    	else
					window.event.returnValue = false;
				}
			else {
					for(var iii=0; iii < document.forms[0].elements.length; iii++){
						if(document.forms[0].elements[iii].type == "submit"){
							document.forms[0].elements[iii].name = "act_content_search";
							}
						}	
					ActionSubmit('act_content_search');
				 }
			}
	}

function noSpamMailLink(user,domain,tld,param) {
	locationstring = "mailto:" + user + "@" + domain + "." + tld + param;
	window.location = locationstring;
}

// using this function to load the object externally
// this will make the object active on load
// other wise IE requires user to click on the object to make it active

function CreateControl(DivID,content)
{
  var d = document.getElementById(DivID);
  d.innerHTML = content;
}