/*automatically highlight the feed url in the feed url input box*/

function SelectAll(id)
{
    document.getElementById(id).select();
}



/*
Auto center window script- Eric King (http://redrival.com/eak/index.shtml)
Permission granted to Dynamic Drive to feature script in archive
For full source, usage terms, and 100's more DHTML scripts, visit http://dynamicdrive.com
*/

var win = null;
function NewWindow(mypage,myname,w,h,scroll){
LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
settings =
'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',resizable'
win = window.open(mypage,myname,settings)
}

function popup(a,width,height,menubar)	{
	if(typeof menubar == "undefined")
		window.open( a, "ASMSU","status=1,height="+ height +",width="+ width +",resizable=1,scrollbars=0");
	else
		window.open( a, "ASMSU","status=1,height="+ height +",width="+ width +",resizable=1,scrollbars=1,menubar=1");
}
function signupnewsletter()
{
	var emailRegEx = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	var email = document.getElementById("txtemail");
	str = email.value;
	if(email.value=='')
	{
		alert('Email can not be left blank.');
		email.focus();
		return false;
	}
	if(str.match(emailRegEx)){
		var ajax = getXMLHttpRequest();
		var randomnumber=Math.floor(Math.random()*1000);
		var url = "signup.php?t="+ randomnumber +"&email=" + str; 
		//alert(url);
		data='';
		ajax.open("GET", url, false);
		ajax.send(null);
		try
		{
			data = ajax.responseText;
			//alert(data);
			if(data=='1')
			{
				popUp('modules.php?name=Pages&sp_id=57&op=popup');
				email.value='';
			}
			else
				alert(data);
		}
		catch (ex)
		{}	
	}
	else{
		alert('Enter a valid email address.');
		email.focus();
		return false;
	}
	return false;
}
function popUp(URL) {

eval("page" + 10 + " = window.open(URL, '" + 10 + "', ' toolbar=1,scrollbars=1,location=1,statusbar=1,menubar=1,resizable=1,width=300,height=200,left = 390,top = 150');");

}

function callProductionParameters(str)
{
	var divMain = document.getElementById("divMain");
	var divHeader = document.getElementById("divHeader");
	switch(str)
	{
		case 'Cast':
			divMain.style.display='';
			divHeader.style.display='none';
			break;
		default:
			divMain.style.display='none';divHeader.style.display='';
			divHeader.innerHTML='<span class="productionheader">'+str+'<br></span>';
			break;			
	}
	document.getElementById("divCast").style.display='none';
	document.getElementById("divSchedule").style.display='none';
	document.getElementById("divArticles").style.display='none';
	document.getElementById("divTicket Pricing").style.display='none';
	var newdiv = 'div'+str;
		document.getElementById(newdiv).style.display='';
	document.getElementById("castBios").className='productionButtons';
	document.getElementById("schedule").className='productionButtons';
	document.getElementById("articles").className='productionButtons';
	document.getElementById("pricing").className='productionButtons';
	document.getElementById("castBios").style.zIndex='48';
	document.getElementById("schedule").style.zIndex='48';
	document.getElementById("articles").style.zIndex='48';
	document.getElementById("pricing").style.zIndex='48';
	switch(str)
	{
		case 'Cast':
			document.getElementById("castBios").className='productionButtons pb_selected';
			document.getElementById("castBios").style.zIndex='50';			
			document.getElementById("divMainCast").style.display='';
			Set_Cookie( 'castbio', 'yes', '', '/', '', '' );
			
			break;
		case 'Schedule':
			document.getElementById("schedule").className='productionButtons pb_selected';
			document.getElementById("schedule").style.zIndex='50';
			break;
		case 'Articles':
			document.getElementById("articles").className='productionButtons pb_selected';
			document.getElementById("articles").style.zIndex='50';
			break;
		case 'Ticket Pricing':
			document.getElementById("pricing").className='productionButtons pb_selected';
			document.getElementById("pricing").style.zIndex='50';
			break;
	}
}
function Set_Cookie( name, value, expires, path, domain, secure ) 
{
// set time, it's in milliseconds

var today = new Date();
today.setTime( today.getTime() );
if ( expires )
{
expires = expires * 1000 * 60 * 60 * 24;
}
var expires_date = new Date( today.getTime() + (expires) );

document.cookie = name + "=" +escape( value ) +
( ( expires ) ? ";expires=" + expires_date.toGMTString() : "" ) + 
( ( path ) ? ";path=" + path : "" ) + 
( ( domain ) ? ";domain=" + domain : "" ) +
( ( secure ) ? ";secure" : "" );
}
function Get_Cookie( check_name ) {
	// first we'll split this cookie up into name/value pairs
	// note: document.cookie only returns name=value, not the other components
	var a_all_cookies = document.cookie.split( ';' );
	var a_temp_cookie = '';
	var cookie_name = '';
	var cookie_value = '';
	var b_cookie_found = false; // set boolean t/f default f
	
	for ( i = 0; i < a_all_cookies.length; i++ )
	{
		// now we'll split apart each name=value pair
		a_temp_cookie = a_all_cookies[i].split( '=' );
		
		
		// and trim left/right whitespace while we're at it
		cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');
	
		// if the extracted name matches passed check_name
		if ( cookie_name == check_name )
		{
			b_cookie_found = true;
			// we need to handle case where cookie has no value but exists (no = sign, that is):
			if ( a_temp_cookie.length > 1 )
			{
				cookie_value = unescape( a_temp_cookie[1].replace(/^\s+|\s+$/g, '') );
			}
			// note that in cases where cookie is initialized but no value, null is returned
			return cookie_value;
			break;
		}
		a_temp_cookie = null;
		cookie_name = '';
	}
	if ( !b_cookie_found )
	{
		return null;
	}
}	
function Delete_Cookie( name, path, domain ) {
if ( Get_Cookie( name ) ) document.cookie = name + "=" +
( ( path ) ? ";path=" + path : "") +
( ( domain ) ? ";domain=" + domain : "" ) +
";expires=Thu, 01-Jan-1970 00:00:01 GMT";
}