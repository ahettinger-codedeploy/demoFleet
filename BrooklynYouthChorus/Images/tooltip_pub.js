/* tooltip */


var offsetxpoint = 10; //Customize x offset of tooltip
var offsetypoint = -30; //Customize y offset of tooltip
var ie=document.all;
var ns6=document.getElementById && !document.all;
var enabletip = false;
if (ie||ns6)
var tippubobj = document.all? document.all["tool_tip_pub"] : document.getElementById? document.getElementById("tool_tip_pub") : "";

var tippubtextobj = document.all? document.all["tool_tip_pub_text"] : document.getElementById? document.getElementById("tool_tip_pub_text") : "";

//var tippubimgobj = document.all? document.all["tip_img"] : document.getElementById? document.getElementById("tip_img") : "";

var tip_pub_container_obj = document.all? document.all["tool_tip_pub_container"] : document.getElementById? document.getElementById("tool_tip_pub_container") : "";

function ietruebody(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function ddrivetip_pub(thetext,theimg,thesize) {
	if (thetext.length > 60 && !thesize) {
			tippubobj.style.width = '360px';
		} else if (thesize == 'wide') {
			tippubobj.style.width = '426px';
		} else if (thesize == 'xwide') {
			tippubobj.style.width = '476px';
		} else {
			tippubobj.style.width = '240px';
		}
		
		if (thetext.length < 30) {
		tippubtextobj.style.whiteSpace = 'nowrap';
		} else {
		tippubtextobj.style.whiteSpace = 'normal';
		}
		
	thecolor = "";
		if (ns6||ie){
			//if (typeof thecolor!="undefined" && thecolor!="") tippubobj.style.backgroundColor=thecolor
			tippubtextobj.innerHTML=thetext;
			/*tippubimgobj.src = '../img/common/x.gif';
			tippubimgobj.style.margin = '0px';
			if (theimg) {
			tippubimgobj.src = theimg;
			tippubimgobj.style.margin = '20px 0px 0px 0px';
			}*/
		div_width = tip_pub_container_obj.offsetWidth;
		div_height = tip_pub_container_obj.offsetHeight;
		
		enabletip=true
		return false
		}
	}


function positiontip_pub(e){
	if (enabletip){
	var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
	var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;
	//Find out how close the mouse is to the corner of the window
	var rightedge=ie&&!window.opera? ietruebody().clientWidth-event.clientX-offsetxpoint : window.innerWidth-e.clientX-offsetxpoint-20
	var bottomedge=ie&&!window.opera? ietruebody().clientHeight-event.clientY-offsetypoint : window.innerHeight-e.clientY-offsetypoint-20
	
	var leftedge=(offsetxpoint<0)? offsetxpoint*(-1) : -1000
	
	//if the horizontal distance isn't enough to accomodate the width of the context menu
	if (rightedge<tippubobj.offsetWidth)
	//move the horizontal position of the menu to the left by it's width
	tippubobj.style.left=ie? ietruebody().scrollLeft+event.clientX-tippubobj.offsetWidth+"px" : window.pageXOffset+e.clientX-tippubobj.offsetWidth+"px"
	else if (curX<leftedge)
	tippubobj.style.left="5px"
	else
	//position the horizontal position of the menu where the mouse is positioned
	tippubobj.style.left=curX+offsetxpoint+"px"
	
	//same concept with the vertical position
	if (bottomedge<tippubobj.offsetHeight)
	tippubobj.style.top=ie? ietruebody().scrollTop+event.clientY-tippubobj.offsetHeight-offsetypoint+"px" : window.pageYOffset+e.clientY-tippubobj.offsetHeight-offsetypoint+"px"
	else
	tippubobj.style.top=curY+offsetypoint+"px"
	show_div('tool_tip_pub');
	}
}

function hideddrivetip_pub(){
hide_div('tool_tip_pub');
enabletip=false;
}


document.onmousemove=positiontip_pub;