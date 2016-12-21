/*
FIRO v1.0

CREDITS

Copyright 2006 Champion Forest Baptist Church
Created by Andrew Maddox
http://www.championforest.org/source

Concept based from sIFR (Copyright 2004 - 2006 Mike Davidson, Shaun Inman, Tomas Jogin and Mark Wubben);
Javascript Functions used from Jeremy Keiths' DOM Scripting

This software is licensed under the CC-GNU LGPL <http://creativecommons.org/licenses/LGPL/2.1/>

*/

// EDIT THIS

var flashLocation = "/f/firo.swf"; // The location of the FLASH file

// DO NOT EDIT BELOW THIS LINE

function insertAfter(newElement,targetElement) {
  var parent = targetElement.parentNode;
  if (parent.lastChild == targetElement) {
    parent.appendChild(newElement);
  } else {
    parent.insertBefore(newElement,targetElement.nextSibling);
  }
}

function getImageName() {
	if (!document.getElementsByTagName) return false;
	testBrowser();
	if(uBrowser=="safari") {
		uBrowser="fail";
	}
	//Start Flash Detection
	var flashVersion = 7;
	if(uBrowser=="ie") {
		var tempObj = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
		var arrVersion = tempObj.GetVariable("$version").split(" ")[1].split(",");
		installedVersion = parseInt(arrVersion[0]) || 0;
		if(installedVersion<flashVersion) {
			return false;
		}
	} else {
		var pluginDesc = navigator.plugins["Shockwave Flash"].description;
		installedVersion = parseInt( pluginDesc.charAt( pluginDesc.indexOf(".")-1 ) );
		if(installedVersion<flashVersion) {
			return false;
		}
	}

	if(uBrowser!="fail") {
		var imgs = document.getElementsByTagName("img");
		for(i=0; i<imgs.length; i++) {
			if(imgs[i].className=="flash") {
				imgs[i].style.display = "none";
				var imgSrc = imgs[i].getAttribute("src");
				var ranNum = Math.random();

				var pN;
				if(ranNum<=.5) {
					pN = -1;
				} else {
					pN = 1;
				}
				var rAngle = Math.round(pN*(7*Math.random()));
				var angle = 0.017453293*rAngle;
				var imgHeight = imgs[i].height+22;
				var imgWidth = imgs[i].width+22;
				
				var aHeight = imgs[i].height;
				var aWidth = imgs[i].width;
	
				var newHeightA = Math.cos((Math.abs(angle)))*imgHeight;
				var newHeightB = Math.sin((Math.abs(angle)))*imgWidth;
				
				var newWidthA = Math.sin((Math.abs(angle)))*imgHeight;
				var newWidthB = Math.cos((Math.abs(angle)))*imgWidth;
				
				var newHeight = Math.ceil(newHeightA+newHeightB);
				var newWidth = Math.ceil(newWidthA+newWidthB);
				
				var imgOffsetX = Math.ceil(newWidthA+11);
				var imgOffsetY = Math.ceil(newHeightB+11);
				var imgVars = "imgLoc="+imgSrc+"&angle="+rAngle+"&stageHeight="+newHeight+"&stageWidth="+newWidth+"&smHeight="+imgOffsetY+"&smWidth="+imgOffsetX+"&imgHeight="+aHeight+"&imgWidth="+aWidth;
				
				var node = document.createElement("span");
/*				var sFlashSrc = "/f/firo.swf";
				node.innerHTML = ['<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" sifr="true" width="', newWidth, '" height="', newHeight, '" class="sIFR-flash">',
    				                    '<param name="movie" value="', sFlashSrc, "?", imgVars, '"></param>',
    				                    '<param name="quality" value="best"></param>',
    				                    '<param name="wmode" value="transparent"></param>',
    				                    '<param name="bgcolor" value="#ffffff"></param>',
    				                  '</object>'].join('');

				insertAfter(node,imgs[i]); */
				
				if(uBrowser=="opera"){
					nodeFlash = document.createElement("object");
					nodeFlash.setAttribute("data", flashLocation);
					createObjectParameter(nodeFlash, "quality", "best");
					createObjectParameter(nodeFlash, "wmode", "transparent");
					createObjectParameter(nodeFlash, "bgcolor", "#ffffff");
				} else if (uBrowser!="safari") {
					var nodeFlash = document.createElement("embed");
					nodeFlash.setAttribute("src", flashLocation);
					nodeFlash.setAttribute("quality", "best");
					nodeFlash.setAttribute("flashvars", imgVars);
					nodeFlash.setAttribute("wmode", "transparent");
					nodeFlash.setAttribute("bgcolor", "#ffffff");
					nodeFlash.setAttribute("pluginspace", "http://www.macromedia.com/go/getflashplayer");
					nodeFlash.setAttribute("scale", "noscale");
				} else if(uBrowser=="safari") {
					var nodeFlash = document.createElement("object");
					nodeFlash.setAttribute("data", flashLocation);
					nodeFlash.setAttribute("flashvars", imgVars);
					createObjectParameter(nodeFlash, "quality", "best");
					createObjectParameter(nodeFlash, "wmode", "transparent");
					createObjectParameter(nodeFlash, "bgcolor", "#ffffff");
					createObjectParameter(nodeFlash, "scale", "noscale");		
				}; 
				nodeFlash.setAttribute("type", "application/x-shockwave-flash");

				if(uBrowser=="opera"){
					createObjectParameter(nodeFlash, "flashvars", imgVars);
				} else if(uBrowser!="safari") {
					nodeFlash.setAttribute("flashvars", imgVars);
				} else if(uBrowser=="safari") {
					createObjectParameter(nodeFlash, "flashvars", imgVars);
					createObjectParameter(nodeFlash, "height", newHeight);
					createObjectParameter(nodeFlash, "width", newWidth);
				};
				nodeFlash.setAttribute("width", newWidth);
				nodeFlash.setAttribute("height", newHeight);
				nodeFlash.setAttribute("class", "right");
				
				if(uBrowser!="safari") {
					if(uBrowser=="ie") {
							node.appendChild(nodeFlash);
							insertAfter(node,imgs[i]);
							node.innerHTML += "";
					} else {
						insertAfter(nodeFlash,imgs[i]);
					}
				} else {
					node.style.display = "block";
					node.appendChild(nodeFlash);
					insertAfter(node,imgs[i]);
					node.innerHTML += "";
				}; 
			}
		}
	} else {
		// other stuff here
	}
}

function createObjectParameter(nodeObject, sName, sValue){
	var node = document.createElement("param");
	node.setAttribute("name", sName);	
	node.setAttribute("value", sValue);
	nodeObject.appendChild(node);
};

function testBrowser() {
	var userAgent =  navigator.userAgent.toLowerCase();
	if(userAgent.indexOf("firefox")!=-1) {
		uBrowser = "ff";
	} else if (userAgent.indexOf("opera")!=-1){
		uBrowser = "opera"
	} else if (userAgent.indexOf("msie")!=-1) {
		uBrowser = "ie"
	} else if (userAgent.indexOf("safari")!=-1) {
		uBrowser = "safari"
	} else {
		uBrowser = "fail";
	}
}

addLoadEvent(getImageName);