function msga(x){
var daReferrer = document.referrer; 
var ename = x;
var subject = "Art Los Angeles Contemporary Webmail"; 

var mailto_link = 'mailto:'+ename+'@artlosangelesfair.com?subject='+subject;

win = window.open(mailto_link,'emailWindow'); 
if (win && win.open &&!win.closed) win.close(); 
}

function msgf(x){

var daReferrer = document.referrer; 
var ename = x;
var subject = "Art Los Angeles Contemporary Webmail"; 

var mailto_link = 'mailto:'+ename+'@fairgroundsllc.com?subject='+subject;

win = window.open(mailto_link,'emailWindow'); 
if (win && win.open &&!win.closed) win.close(); 
}


function msgb(){

var daReferrer = document.referrer; 
var subject = "Art Los Angeles Contemporary Webmail"; 

var mailto_link = 'mailto:hscheck@bwr-la.com?subject='+subject;

win = window.open(mailto_link,'emailWindow'); 
if (win && win.open &&!win.closed) win.close(); 
}

function msgt(x){
var daReferrer = document.referrer; 
var ename = x;
var subject = "Travel Inquiry / Art Los Angeles Contemporary "; 

var mailto_link = 'mailto:'+ename+'@turontravel.com?subject='+subject;

win = window.open(mailto_link,'emailWindow'); 
if (win && win.open &&!win.closed) win.close(); 
}


function stateswitch(x) {
	if ( x == "Canada" ) {
		document.getElementById("province").style.display = "block";
		document.getElementById("state").style.display = "none";
		document.getElementById("australianstate").style.display = "none";
		document.getElementById("stateinput").style.display = "none";
		document.getElementById("mexicanstate").style.display = "none";
	}
	else if ( x == "United States" ) {
		document.getElementById("state").style.display = "block";
		document.getElementById("province").style.display = "none";
		document.getElementById("australianstate").style.display = "none";
		document.getElementById("stateinput").style.display = "none";
		document.getElementById("mexicanstate").style.display = "none";
	}
	else if ( x == "Australia" ) {
		document.getElementById("australianstate").style.display = "block";
		document.getElementById("province").style.display = "none";
		document.getElementById("state").style.display = "none";
		document.getElementById("stateinput").style.display = "none";
		document.getElementById("mexicanstate").style.display = "none";
	}
	else if ( x == "Mexico" ) {
		document.getElementById("mexicanstate").style.display = "block";
		document.getElementById("province").style.display = "none";
		document.getElementById("state").style.display = "none";
		document.getElementById("stateinput").style.display = "none";
		document.getElementById("australianstate").style.display = "none";
	}
	else {
		document.getElementById("stateinput").style.display = "block";
		document.getElementById("australianstate").style.display = "none";
		document.getElementById("province").style.display = "none";
		document.getElementById("state").style.display = "none";
		document.getElementById("mexicanstate").style.display = "none";
		document.forms["mailinglist"].stateinput.value = '';
	}
}