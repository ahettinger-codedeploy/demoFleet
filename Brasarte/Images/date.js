<!--
function startclock() {
var mnames = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
var dnames = new Array('Sun','Mon','Tue','Wed','Thu','Fri','Sat'); 
var ntime  = new Date();

var nhour = ntime.getHours();
var nmin  = ntime.getMinutes();
var nsec  = ntime.getSeconds();
var nday  = ntime.getDate();
var nyear = ntime.getYear();

if (nyear< 1900) { nyear += 1900; }
if (nsec < 10)   { nsec="0"+nsec; }
if (nmin < 10)   { nmin="0"+nmin; }
if (nday < 10)   { nday="0"+nday; }

if (document.getElementById("myclock")) {
	document.getElementById("myclock").innerHTML = dnames[ntime.getDay()] + ", " + nday  +  " " + mnames[ntime.getMonth()] + " " + nyear + " @ " + nhour + ":" + nmin + ":" + nsec + "&nbsp;";
	}
setTimeout('startclock()', 1000);
}
//-->