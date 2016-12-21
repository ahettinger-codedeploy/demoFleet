var arrowWidth = 55;
var arrowHeight = 55;
var shadowWidth = 5;
var xmlHttp;
var oElement;
var url;
var ttDisplayed = "N";
var MouseX = 0;
var MouseY = 0;

function winInfo(parm){

var iebody=(document.compatMode && document.compatMode != "BackCompat")? document.documentElement : document.body
var result;

switch(parm){
case "left":
    result = document.all? iebody.scrollLeft : window.pageXOffset
    break;
case "top":
    result = document.all? iebody.scrollTop : window.pageYOffset
    break;
case "width":
    result = document.all? iebody.offsetWidth : window.innerWidth
    break;
case "height":
    result = document.all? iebody.offsetHeight : window.innerHeight
    break;
case "right":
    result = winInfo("left") + winInfo("width");
    break;
case "bottom":
    result = winInfo("top") + winInfo("height");
    break;
}    
return result;
}                

function eventTooltip(url, obj){
oElement = obj;

ttDisplayed="Y";

url=url+"&sid="+Math.random();

xmlHttp=GetXmlHttpObject()
xmlHttp.onreadystatechange=stateChanged;
xmlHttp.open("GET",url,true);
xmlHttp.send(null);

}

function TixTooltip(tooltipText, obj){
    if( tooltipText != "" ) {
        oElement = obj;
        ttDisplayed="Y";
        document.getElementById("EventTooltip").innerHTML='<table width=400 border=1 cellpadding=5><tr><td><font size=1>' + tooltipText + '</font></td></tr></table>';
        showTooltip();
    }
}

function stateChanged() { 
if (xmlHttp.readyState==4){ 
    if(xmlHttp.status == 200){
        document.getElementById("EventTooltip").innerHTML=xmlHttp.responseText;
        if(xmlHttp.responseText.indexOf("Event information is unavailable") == -1){
            showTooltip();
            }
        }
    }
}

function GetXmlHttpObject()
{
var xmlHttp=null;
try
  {
  // Firefox, Opera 8.0+, Safari
  xmlHttp=new XMLHttpRequest();
  }
catch (e)
  {
  // Internet Explorer
  try
    {
    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
    }
  catch (e)
    {
    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
  }
return xmlHttp;
}

var IE = document.all?true:false;
//if (!IE) document.captureEvents(Event.MOUSEMOVE);
if (!IE) document.addEventListener("MOUSEMOVE", getMouseXY, true);
document.onmousemove = getMouseXY;

var tempX = 0;
var tempY = 0;
var winLeft = 0;
var winTop = 0;

function showTooltip(){

//var oElement = obj;

var windowLeft = winInfo("left")
var windowTop = winInfo("top")
var windowWidth = winInfo("width")
var windowHeight = winInfo("height")

//winLeft = windowLeft;
//winTop = windowTop;

var oLeftPos;
var oTopPos;

var ttWidth = 0;
var ttHeight = 0;
var ttTopPos = 0;
var ttLeftPos = 0;

oElement.onmousemove = getMouseXY;

var oLeftPos = MouseX;
var oTopPos = MouseY - windowTop;

var arrowX = "left";
var arrowY = "down";
var arrowLeftPos = MouseX + 5;
var arrowTopPos = MouseY - arrowHeight - 5;

var isIE6;    
isIE6 = navigator.userAgent.toLowerCase().indexOf('msie 6') != -1;

//If IE6 Change PNGs to GIFs
if(isIE6 == true){
    document.getElementById('BubbleTL').style.backgroundImage = "url(/images/BubbleTL.gif)";
    document.getElementById('BubbleTop').style.backgroundImage = "url(/images/BubbleTop.gif)";
    document.getElementById('BubbleTR').style.backgroundImage = "url(/images/BubbleTR.gif)";
    document.getElementById('BubbleLeft').style.backgroundImage = "url(/images/BubbleLeft.gif)";
    document.getElementById('BubbleRight').style.backgroundImage = "url(/images/BubbleRight.gif)";
    document.getElementById('BubbleBL').style.backgroundImage = "url(/images/BubbleBL.gif)";
    document.getElementById('BubbleBottom').style.backgroundImage = "url(/images/BubbleBottom.gif)";
    document.getElementById('BubbleBR').style.backgroundImage = "url(/images/BubbleBR.gif)";
    }

//Set default Tooltip Position.
ttLeftPos = arrowLeftPos + (arrowWidth - shadowWidth - 4);
ttTopPos = arrowTopPos - 10;

if(ttTopPos - winInfo("top") < 0){
    arrowY = "up";
    arrowTopPos = MouseY + 5;
    ttTopPos = arrowTopPos + 10;
    }
    
//Set initial Tooltip Positions before initial display.
document.getElementById("tooltipBox").style.position="absolute";
document.getElementById("tooltipBox").style.left=ttLeftPos + 'px';
document.getElementById("tooltipBox").style.top=ttTopPos + 'px';

if(ttDisplayed=="Y"){
    document.getElementById("tooltipBox").style.display = 'block';
    }

//Get Tooltip Width & Height after displaying it.
if (!document.defaultView) {
    ttWidth = document.getElementById("tooltipBox").offsetWidth;
    ttHeight = document.getElementById("tooltipBox").offsetHeight;
    }
else{
    ttWidth = parseInt(document.defaultView.getComputedStyle(document.getElementById("tooltipBox"), null).getPropertyValue('width'));
    ttHeight = parseInt(document.defaultView.getComputedStyle(document.getElementById("tooltipBox"), null).getPropertyValue('height'));
}

ttTopPos = MouseY - ttHeight/2;

//Move Tooltip if necessary
if (ttTopPos > arrowTopPos - shadowWidth - 10){
    ttTopPos = arrowTopPos - shadowWidth - 10;
    }
else {
    if (ttTopPos + ttHeight < arrowTopPos + arrowHeight){
        ttTopPos = arrowTopPos + arrowHeight - ttHeight + shadowWidth + 10;
        }
    }    
if (ttTopPos < windowTop){ //Tooltip is above the window.
    ttTopPos = windowTop; //Lower it to window top.
    }
else {
    if (ttTopPos + ttHeight > windowTop + windowHeight){ //Tooltip is below the window.
        ttTopPos = (windowTop + windowHeight) - ttHeight; //Raise it to window bottom.
        }
    }

if(ttLeftPos + ttWidth + arrowWidth - shadowWidth > winInfo("right")){  //Tooltip is to the right of the window.
    if(oLeftPos > ttWidth + arrowWidth - shadowWidth){ //Move it to the left if there's room
        ttLeftPos = oLeftPos - (ttWidth + arrowWidth - shadowWidth);
        arrowX = "right";
        arrowLeftPos = ttLeftPos + ttWidth - shadowWidth - 4;
        }
    else { //There's no room to the left or right.  Display it above or below the mouse.
        if(oTopPos > windowHeight/2){  //Mouse is closer to the bottom of the page.  Display it above.
            arrowX = "down";
            arrowY = "left";
            ttTopPos = MouseY - (ttHeight + arrowWidth - shadowWidth);
            arrowTopPos = MouseY - (arrowWidth + 4);
            arrowLeftPos = oLeftPos;
            }
        else { //Mouse is closer to the top of the page.  Display it below.
            arrowX = "up";
            arrowY = "left"
            ttTopPos = MouseY + (arrowWidth - shadowWidth - 2);  
            arrowTopPos = MouseY + 4;
            arrowLeftPos = oLeftPos;
            }
        ttLeftPos = oLeftPos - ttWidth/2;
        if (ttLeftPos < windowLeft){ //Tooltip is to the left of the window.
            ttLeftPos = windowLeft; //Move it to the left edge.
            }
        else{
            if(ttLeftPos + ttWidth > windowLeft + windowWidth){ //Tooltip is to the right of the window.
                ttLeftPos = windowLeft + windowWidth - ttWidth; //Move it to the right edge.
                }
            }
        }
    }

//Set final Tooltip Left position.
document.getElementById("tooltipBox").style.left=ttLeftPos + 'px';
document.getElementById("tooltipBox").style.top=ttTopPos + 'px';

//Display Arrow.
document.getElementById("arrow").style.position="absolute";
document.getElementById("arrow").style.left=arrowLeftPos + 'px';
document.getElementById("arrow").style.top=arrowTopPos + 'px';

//If IE6 Change PNGs to GIFs
if(isIE6 == true){
    document.arrowimg.src="/images/arrow" + arrowX + arrowY + ".gif";
    }
else{
    document.arrowimg.src="/images/arrow" + arrowX + arrowY + ".png";
    }

if (ttDisplayed == "Y"){
    document.getElementById("arrow").style.display = 'block';
    document.getElementById("tooltipBox").style.display = 'block';
    }    
}

function hideTooltip(){

ttDisplayed = "N";
document.getElementById("tooltipBox").style.display = 'none';
document.getElementById("arrow").style.display = 'none';

}

function findPosX(obj)
  {
    var curleft = 0;
    if(obj.offsetParent)
        while(1) 
        {
          curleft += obj.offsetLeft;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.x)
        curleft += obj.x;
    return curleft;
  }

function findPosY(obj)
  {
    var curtop = 0;
    if(obj.offsetParent)
        while(1)
        {
          curtop += obj.offsetTop;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.y)
        curtop += obj.y;
    return curtop;
  }

function getMouseXY(e) {

var e=(!e)?window.event:e;//IE:Moz

if (e.pageX){//Moz
    posx=e.pageX//+window.pageXOffset;
    posy=e.pageY//+window.pageYOffset;
}
else if(e.clientX){//IE
    /*if(document.documentElement){//IE 6+ strict mode
        posx=e.clientX+document.documentElement.scrollLeft;
        posy=e.clientY+document.documentElement.scrollTop;
    }
    else if(document.body){//Other IE
        posx=e.clientX+document.body.scrollLeft;
        posy=e.clientY+document.body.scrollTop;
    }*/
    posx=e.clientX+winLeft;
    posy=e.clientY+winTop;
}
else{return false}//old browsers
  
if (posx < 0){posx = 0;}
if (posy < 0){posy = 0;}  
MouseX = posx;
MouseY = posy;
return true;
}

if (document.all){
    window.onscroll = updateWindowCoordinates;
    }

function updateWindowCoordinates() {
    winLeft = winInfo("left");
    winTop = winInfo("top");
    }