/***********************************************
* Pop-it menu- © Dynamic Drive (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/

var defaultMenuWidth="260px" //set default menu width.


var linkset=new Array()

linkset[0]='<a href="cmsch.html"><li>Schedule</li></a>'
linkset[0]+='<a href="cmsch.html#fares"><li>Fares</li></a>'
linkset[0]+='<a href="cmtsl.html"><li>Train Station Locations</li></a>'
linkset[0]+='<a href="cmpht.html"><li>Photos</li></a>'

linkset[1]='<a href="rtsch.html"><li>Schedule</li></a>'
linkset[1]+='<a href="rtsch.html#fares"><li>Fares</li></a>'
linkset[1]+='<a href="rttsl.html"><li>Train Station Locations</li></a>'
linkset[1]+='<a href="rtpht.html"><li>Photos</li></a>'

linkset[2]='<a href="pres.html"><li>The President&acute;s Page</li></a>'
linkset[2]+='<a href="special.html"><li>Special Events</li></a>'

linkset[2]+='<a href="special.html#wine"><li>An Afternoon Wine Experience!</li></a>'

linkset[2]+='<a href="charter.html"><li>Charter Trains</li></a>'
linkset[2]+='<a href="santa.html"><li>The Santa Express</li></a>'
linkset[2]+='<a href="nostalgia.html"><li>Nostalgia</li></a>'
linkset[2]+='<a href="freight.html"><li>Freight Rail Service</li></a>'
linkset[2]+='<a href="links.html"><li>Links</li></a>'
linkset[2]+='<a href="customer_photos.html"><li>Customer Photos</li></a>'
linkset[2]+='<a href="mailing.html"><li>Mailing List/Contact Information</li></a>'


////No need to edit beyond here

var ie5=document.all && !window.opera
var ns6=document.getElementById

if (ie5||ns6)
document.write('<div id="popitmenu" onMouseover="clearhidemenu();" onMouseout="dynamichide(event)"></div>')

function iecompattest(){
return (document.compatMode && document.compatMode.indexOf("CSS")!=-1)? document.documentElement : document.body
}

function showmenu(e, which, optWidth){
if (!document.all&&!document.getElementById)
return
clearhidemenu()
menuobj=ie5? document.all.popitmenu : document.getElementById("popitmenu")
menuobj.innerHTML=which
menuobj.style.width=(typeof optWidth!="undefined")? optWidth : defaultMenuWidth
menuobj.contentwidth=menuobj.offsetWidth
menuobj.contentheight=menuobj.offsetHeight
eventX=ie5? event.clientX : e.clientX
eventY=ie5? event.clientY : e.clientY
//Find out how close the mouse is to the corner of the window
var rightedge=ie5? iecompattest().clientWidth-eventX : window.innerWidth-eventX
var bottomedge=ie5? iecompattest().clientHeight-eventY : window.innerHeight-eventY
//if the horizontal distance isn't enough to accomodate the width of the context menu
if (rightedge<menuobj.contentwidth)
//move the horizontal position of the menu to the left by it's width
menuobj.style.left=ie5? iecompattest().scrollLeft+eventX-menuobj.contentwidth+"px" : window.pageXOffset+eventX-menuobj.contentwidth+"px"
else
//position the horizontal position of the menu where the mouse was clicked
menuobj.style.left=ie5? iecompattest().scrollLeft+eventX+"px" : window.pageXOffset+eventX+"px"
//same concept with the vertical position
if (bottomedge<menuobj.contentheight)
menuobj.style.top=ie5? iecompattest().scrollTop+eventY-menuobj.contentheight+"px" : window.pageYOffset+eventY-menuobj.contentheight+"px"
else
menuobj.style.top=ie5? iecompattest().scrollTop+event.clientY+"px" : window.pageYOffset+eventY+"px"
menuobj.style.visibility="visible"
return false
}

function contains_ns6(a, b) {
//Determines if 1 element in contained in another- by Brainjar.com
while (b.parentNode)
if ((b = b.parentNode) == a)
return true;
return false;
}

function hidemenu(){
if (window.menuobj)
menuobj.style.visibility="hidden"
}

function dynamichide(e){
if (ie5&&!menuobj.contains(e.toElement))
hidemenu()
else if (ns6&&e.currentTarget!= e.relatedTarget&& !contains_ns6(e.currentTarget, e.relatedTarget))
hidemenu()
}

function delayhidemenu(){
delayhide=setTimeout("hidemenu()",500)
}

function clearhidemenu(){
if (window.delayhide)
clearTimeout(delayhide)
}

if (ie5||ns6)
document.onclick=hidemenu
