// FRAME ELIMINATOR
// Checks to see if the site is being framed, and pulls the site out.
if (window.location!=top.location) {
	top.location = window.location;
}
	 
	 
	 
	 
	 
// OPEN WINDOW FUNCTION
// pulls in customized link, width, height, scrollability
function popUpNew(Page, Width, Height, Scroll) {
window.open(Page,"popUpWindow",'width='+Width+',height='+Height+',toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars='+Scroll+',copyhistory=no,resizable=yes');
  }
// the rest...
// toolbar - icons;  location - URL address bar;  directories - links bar;   status - progress bar at bottom;
// menubar - File, Edit, etc;  copyhistory - retains history list from parent window;  resizable - allows resizing


// OPEN SIZED WINDOW FUNCTION
// pops up an image in a window sized to that image
function popUpPic(sPicURL) {    
			window.open( "popup.htm?"+sPicURL, "", "resizable=1,HEIGHT=200,WIDTH=200");    
		}  
		
		

// FIX N4 CSS ISSUE	
// Netscape 4 has a nasty bug of forgetting an external stylesheet is attached when the browswer is resized
// This script compensates for Netscape's shortsightedness
if (document.layers) {
	origWidth = innerWidth;
	origHeight = innerHeight;
	}

function reloadPage () {
	if (innerWidth != origWidth || innerHeight != origHeight) {
		location.reload();
		}
	}

if (document.layers) onresize = reloadPage;



// SCROLLBAR CHANGES COLOR  
// Makes the color of the scrollbars match the background, if color entered correctly
function changeScrollbarColor(C) {
   if (document.all) {
      document.body.style.scrollbarBaseColor = C;
   }
}



//SET NEW Z-INDEX LEVEL
//Change a DIVs Z Level on the page
function setZIndex(objectName, newIndex) {
	var refObject = findDOM(objectName,1);
	refObject.zIndex = newIndex;

}


// POP UP WINDOW HEAD QUARTERS
function newsWindow(url) {
	var optionsArray = new Array(10);
	var i, z, optionsList, optionVal, commandString;
	optionsArray[0] = ["",""];
	optionsArray[1] = ["height","575"];
	optionsArray[2] = ["width","555"];
	optionsArray[3] = ["location","no"];
	optionsArray[4] = ["menubar","no"];
	optionsArray[5] = ["resizable","no"];
	optionsArray[6] = ["scrollbars","yes"];
	optionsArray[7] = ["toolbar","no"];
	optionsArray[8] = ["status","no"];
	optionsArray[9] = ["directories","no"];
	optionsList = "";
	for ( i = 1; i < arguments.length; i++ ) {
		if (arguments[i] != 'z') {
			optionVal = arguments[i];
		} else {
			optionVal = optionsArray[i][1];
		}
		optionsList += optionsArray[i][0]+"="+optionVal+",";
	}
	for ( i = arguments.length; i < optionsArray.length; i++ ) 
	{

		optionsList += optionsArray[i][0]+"="+optionsArray[i][1]+",";

	}
	commandString = "window.open('"+url+"','new_window','"+optionsList+"');";


//	alert(commandString);

	eval(commandString);

}
	
	

// POP UP WINDOW HEAD QUARTERS
function photoWindow(url) {
	var optionsArray = new Array(10);
	var i, z, optionsList, optionVal, commandString;
	optionsArray[0] = ["",""];
	optionsArray[1] = ["height","575"];
	optionsArray[2] = ["width","670"];
	optionsArray[3] = ["location","no"];
	optionsArray[4] = ["menubar","no"];
	optionsArray[5] = ["resizable","yes"];
	optionsArray[6] = ["scrollbars","yes"];
	optionsArray[7] = ["toolbar","no"];
	optionsArray[8] = ["status","no"];
	optionsArray[9] = ["directories","no"];
	optionsList = "";
	for ( i = 1; i < arguments.length; i++ ) {
		if (arguments[i] != 'z') {
			optionVal = arguments[i];
		} else {
			optionVal = optionsArray[i][1];
		}
		optionsList += optionsArray[i][0]+"="+optionVal+",";
	}
	for ( i = arguments.length; i < optionsArray.length; i++ ) 
	{

		optionsList += optionsArray[i][0]+"="+optionsArray[i][1]+",";

	}
	commandString = "window.open('"+url+"','new_window','"+optionsList+"');";


//	alert(commandString);

	eval(commandString);

}
	
	

	
// ANTI-SPAM
	function antispam(domain, name) {
    	document.location = "mailto:" + name + "@" + domain;
	}
// -->





function show(object) {
    if (document.getElementById && document.getElementById(object) != null){
         node = document.getElementById(object).style.display='block';
    }
	else if (document.layers && document.layers[object] != null){
        document.layers[object].display = 'block';
    }
	else if (document.all){
        document.all[object].style.display = 'block';
    }
}

function hide(object) {
    if (document.getElementById && document.getElementById(object) != null){
        node = document.getElementById(object).style.display='none';
    }
	else if (document.layers && document.layers[object] != null){
        document.layers[object].display = 'none';
    }
	else if (document.all){
        document.all[object].style.display = 'none';
    }
}


	
function blog(){
    show("blog");
    hide("castcrew");
    hide("synopsis");
	}

function castcrew(){
    hide("blog");
    show("castcrew");
    hide("synopsis");
	}

function synopsis(){
    hide("blog");
    hide("castcrew");
    show("synopsis");
	}


function statusmessage(text){
   window.status = text;
}



function clearstatus(){
  window.status = "";
}



 