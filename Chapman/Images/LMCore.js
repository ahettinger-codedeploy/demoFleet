/**********************************************
 LMCore.js
 Basic ActiveCampus JavaScript functions including
    imageswapper, popup, external site frame, and quicklinks
 Author:  M. Dempster 3/2/01
 Copyright:  LiquidMatrix Corp.
**********************************************/

/**********************************************
 Browser control variables  
 These variables determine which browser is being used
**********************************************/ 
var isNav = (document.layers) ? true:false				//Layers compliant browser (Netscape 4.x)
var isIE = (document.all) ? true:false				//IE4/5 compliant browser 
var isMac = (navigator.appVersion.indexOf('Mac') != -1) ? true : false //Mac based browser
var isDOM = (document.getElementById) ? true:false	   	//DOM Compliant browser (NS6, Opera 5)
var isOther = (!isNav&&!isDOM&&!isIE) ? true:false				//Other browser (NS3, Lynx)

/**********************************************
 Global Variables  
 Variables used in ALL pages, or by multiple JS functions
**********************************************/ 
var preloadFlag = false 								//Determines if images for swapping in page are loaded

/**********************************************
 newImage(stringexp)    
 arg:  
 	use:  Required
	Datatype:  String
	A valid string expression (An image filename, with path)
 Return:  JS image object
 Description:  Creates an image object containing the file found at arg
**********************************************/ 
function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

/**********************************************
 changeImages([stringexp, (obj2|str2)])    
 Return:  Nothing
 Description:   Replaces image found at reference stringexp with specified image obj2 or str2.  Image may
 				may be pulled from an Image Object (eg: Imageobj.src) or a string (eg: "/images/x.gif").
 Tips:  You may use any number of argument pairs to swap multiple images at the same time.  Arguments MUST be 
  		paired;  args not paired will result in an error.
**********************************************/ 
function changeImages() {
  	if (document.images && (preloadFlag == true)) {
		for (var i=0; i<changeImages.arguments.length; i+=2) {
			document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
		}
	}
}

/**********************************************
 jumpto(formobj, stringexp)
 form:  
 	use:  Required
	Datatype:  JS Form Obj
	A valid reference to a form object on the page.
 name:  
 	use:  Required
	Datatype:  String
	A valid reference to a select control.    
 Return:  Nothing
 Description:   Takes the value of the selected item in selector name, and forwards browser to that value.  
 				During the forward process, it resets the selector to default (index=0)
 Tips:  Normally, form is passed this.form, which is a generic reference to the form enclosing name
**********************************************/ 
function jumpto(form, name) {
	var myindex= eval('form.'+ name + '.selectedIndex');			//Gets index of user selection in Stringexp
    var myval=eval('form.' + name + '.options[myindex].value');		//Gets value at myindex
    eval('form.'+ name + '.selectedIndex = 0');						//Resets selected index to 0 (default)
	if (myval != "") {
        
	     location.href=myval;									//If value is local, send this window to new page.
       
    }
}


/**********************************************
 popup(stringexp, stringexp, integer, integer, stringexp, stringexp, )
 Note:  All vars are type STring and are required
 URL:  Valid URL of a webpage (determines page to be shown in new window)
 Name: String (determines name of new window)
 wwidth: Integer (determines width of new window)
 wheight: Integer (determined height of new window)
 wresize: 0 or 1 (determines if window can be resized or not)
 wscrolls:  yes or no (determines if scrollbars will be created on window)
 Return:  Nothing
 Description:   Pops open new window with parameters specified above.
 10/13/2003: M. Thomas removed name as parameter and replaced with today_date so that window name is different
             each time and new windows open instead of using window already open which may be in the background.
**********************************************/ 
function popup(url, name, wwidth, wheight, wresize, wscrolls){
	var today_date = new Date();
	today_date = today_date.getSeconds();
    eval("window.open('" + url + "','" + today_date + "','toolbar=no,menubar=no,address=no,status=no,dependent=no,resizable=" + wresize + ",scrollbars=" + wscrolls + ",height=" + wheight + ",width=" + wwidth + "')");
}

/**********************************************
 popupFull(stringexp, stringexp, integer, integer,)
 NOTE: M. Thomas created this from popup function above. This version is called
	from the openFullExternal.asp page to open a fully functional browser window
 Note:  All vars are type STring and are required
 URL:  Valid URL of a webpage (determines page to be shown in new window)
 Name: String (determines name of new window)
 wwidth: Integer (determines width of new window)
 wheight: Integer (determined height of new window)

 Return:  Nothing
 Description:   Pops open new, fully operational browser win	dow 
     with parameters specified above. all menus, buttons, status bar, scrolls bars turned on.
**********************************************/
function popupFull(url){
	var today_date = new Date();
	today_date = today_date.getSeconds();
    eval("window.open('" + url + "','" + today_date + "','toolbar=yes,menubar=yes,location=yes,status=yes,dependent=no,resizable=yes,scrollbars=yes,height=500,width=700')");
}

/**********************************************
 external(stringexp)
 url:  
 	use:  Required
	Datatype: String
	A valid reference to a web site address   
 Return:  Nothing
 Description:   Takes the value of URL, and creates a new window containing the External site frame, which displays the address specified
**********************************************/ 
function external(url){
    eval("window.open('/external.asp?URL=" + escape(url) + "','ACEXT','toolbar=yes,menubar=yes,address=yes,status=yes,dependent=no,resizable=1,height=540,width=760')");
}


/**********************************************
 autojump(formobj,formobj,stringexp,integer)
 formname:    
 	use:  Required
	Datatype: JS Form Object
	A valid reference to a form  
 thisfield:    
 	use:  Required
	Datatype: JS Form Control object
	A valid reference to a form control contained within formname
 fieldname:    
 	use:  Required
	Datatype: String
	A valid reference to a name of form control within formname  
 maxlen:    
 	use:  Required
	Datatype: Integer    
 Return:  Nothing
 Description:   On keypress in thisfield, tests to see if the length of the data entered is longer than maxlen.
 				If so, switch focus to fieldname.
 Tips:  Normally, formname and thisfield are passed "this.form" and "this" respectively, referencing the currently selected control and form.
**********************************************/ 
function autojump(formname, thisfield, fieldname, maxlen) {
	maxlen = (isNav) ? maxlen - 1:maxlen						//If NS4.0, length needs to be truncated by 1
	if (thisfield.value.length >= maxlen) {						//On keypress, if value is longer than maxlen
		formname.elements[fieldname].focus();					//Focus on fieldname
	}
}


/**********************************************
 adjustIFrameSize(windowobj)
 iframeWindow:    
 	use:  Required
	Datatype: JS Window Object
	A valid reference to a window object   
 Return:  Nothing
 Description:   This function, when called from the onload handler of an iframe will resize that iframe to the height and width of it's current content.
 Tips:  This function is called as parent.adjustIFrameSize(window) from the iframe to be resized.
**********************************************/ 
function adjustIFrameSize (iframeWindow) {
  if (iframeWindow.document.height) {
    var iframeElement = parent.document.getElementById(iframeWindow.name);
    iframeElement.style.height = (iframeWindow.document.height+2) + 'px';
    iframeElement.style.width = iframeWindow.document.width + 'px';
  }
  else if (document.all) {
    var iframeElement = parent.document.all[iframeWindow.name];
    if (iframeWindow.document.compatMode &&  iframeWindow.document.compatMode != 'BackCompat') 
    {
      iframeElement.style.height = iframeWindow.document.documentElement.scrollHeight + 'px';
      iframeElement.style.width = iframeWindow.document.documentElement.scrollWidth + 'px';
    }
    else {
      iframeElement.style.height = iframeWindow.document.body.scrollHeight +  'px';
      iframeElement.style.width = iframeWindow.document.body.scrollWidth + 'px';
    }
  }
}




