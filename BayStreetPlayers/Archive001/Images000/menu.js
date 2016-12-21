	<!-- Begin
	function movepic(img_name,img_src) {
	document[img_name].src=img_src;
	}
	
	function showlinks(linkname) {
		document[linkname].visible=true;
	}
	
	function reDo() { 
window.location.reload(); 
} window.onresize = reDo; 
//Define global variables 
var timerID = null; 
var timerOn = false; 
var timecount = 5000; 
// Change this to the time delay that you desire 
var what = null; 
var newbrowser = true; 
var check = false; 

function init() { 
if (document.layers) { 
layerRef="document.layers"; 
styleSwitch=""; 
visibleVar="show"; 
screenSize = window.innerWidth; 
what ="ns4"; 
} 
else if(document.all) { 
layerRef="document.all"; 
styleSwitch=".style"; 
visibleVar="visible"; 
screenSize = document.body.clientWidth + 18; 
what ="ie4"; 
} 
else if(document.getElementById) { 
layerRef="document.getElementByID"; 
styleSwitch=".style"; 
visibleVar="visible"; 
what="dom1"; 
} 
else { 
what="none"; 
newbrowser = false; 
} 
check = true; 
} 

// Toggles the layer visibility on 
function showLayer(layerName) { 
if(check) { 
if (what =="none") { 
return; 
} 
else if (what == "dom1") { 
document.getElementById(layerName).style.visibility="visible"; 
} 
else { 
eval(layerRef+'["'+layerName+'"]'+styleSwitch+'.visibility="visible"'); 
} 
} 
else { 
return; 
} 
} 

// Toggles the layer visibility off 
function hideLayer(layerName) { 
if(check) { 
if (what =="none") { 
return; 
} 
else if (what == "dom1") { 
document.getElementById(layerName).style.visibility="hidden"; 
} 
else { 
eval(layerRef+'["'+layerName+'"]'+styleSwitch+'.visibility="hidden"'); 
} 
} 
else { 
return; 
} 
} 

function hideAll() { 
hideLayer('aboutuslinks'); 
hideLayer('seasonlinks');
hideLayer('fobslinks');
hideLayer('auditionslinks');
hideLayer('newslinks');
hideLayer('yptlinks');
//Put all layers used in the nav here. 
//Copy the hideLayer() function above. 
} 

function startTime() { 
if (timerOn == false) { 
timerID=setTimeout( "hideAll()" , timecount); 
timerOn = true; 
} 
} 

function stopTime() { 
if (timerOn) { 
clearTimeout(timerID); 
timerID = null; 
timerOn = false; 
} 
} 

function onLoad() { 
init(); 
} 
	
	// End -->

