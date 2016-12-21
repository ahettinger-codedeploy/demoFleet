/**********************************************
 LMAnimate.js
 Advances ActiveCampus JavaScript functions for
    DHTML animation tasks, including positioning, dimensions, and visibility.
 Author:  M. Dempster 8/20/02
 Copyright:  LiquidMatrix Corp.
**********************************************/
/**********************************************
 createReference(stringexp)    
 stringexp:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  A reference to an object style.
 Description:   Creates a string reference to the style of an HTML element on the page.  Since each browser does Obj 
 				referencing differently, we have to branch it.
**********************************************/ 
function createReference(Element) {
	if (isDOM && !isIE) {
		oRef = eval("document.getElementById('" + Element + "').style")
	} else if (isNav) {
		oRef = eval("document.layers['" + Element + "']")
	} else {
		oRef = eval("document.all." + Element + ".style")
	}
	return oRef
}

/**********************************************
 setElementVisibility(stringexp1, stringexp2)    
 stringexp 1 and 2:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  none
 Description:  Sets the Visibility property (given in Stringexp2) for the element ID specifiec in Stringexp1.  This can be set to either
 				visible or hidden.
**********************************************/ 
function setElementVisibility(Element, state) {
	oElement = createReference(Element)
	if (isNav) { state = state.toUpperCase() == "VISIBLE" ? "show":"hide" }		//Because NAV4 does visibility states differently, swap to corresponding word.
	oElement.visibility = state.toLowerCase(); 
}

/**********************************************
 getElementVisibility(stringexp)    
 stringexp:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  none
 Description:  Gets the Visibility property for the element ID specifiec in Stringexp. 
**********************************************/ 
function getElementVisibility(Element) {
	oElement = createReference(Element)
	elementVis = oElement.visibility;
	return elementVis
}

/**********************************************
 setElementDisplay(stringexp1, stringexp2)    
 stringexp 1 and 2:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  none
 Description:  Sets the Display property (given in Stringexp2) for the element ID specifiec in Stringexp1.  This can be set to any valid 
 				display style (e.g. Block, inline, none)
**********************************************/ 
function setElementDisplay(Element, state) {
	oElement = createReference(Element)
    if (!isNav) { oElement.display = state.toLowerCase(); }		//This function does not work in NAV4!
}



/**********************************************
 getElementDisplay(stringexp1)    
 stringexp:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  none
 Description:  Gets the Display property for the element ID specifiec in Stringexp.  
**********************************************/ 
function getElementDisplay(Element, state) {
	oElement = createReference(Element)
    if (!isNav) { elementDisp = oElement.display }		//This function does not work in NAV4!
	return elementDisp
}


/**********************************************
 setElementPosition(stringexp1, integer1, integer2)    
 stringexp  
 	use:  Required
	Datatype:  String
	A valid string expression
 integer 1 and 2  
 	use:  Required
	Datatype:  Integer
	A valid integer
 Description:   This function moves the element in Stringexp to the coordinates specified by ints 1 and 2.  You must specify both X and Y coords.
**********************************************/ 
function setElementPosition(Element, elX, elY) {
	oElement = createReference(Element)
    if (isIE) {  												
		oElement.pixelTop = elY
		oElement.pixelLeft = elX
	} else {
        oElement.left = elX + 'px'
		oElement.top = elY + 'px'
	}
}


/**********************************************
 getElementPosition(stringexp1, stringexp2)    
 stringexp 1 and 2:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  Integer
 Description:   This function retrieves the coordinate (stringexp2) for the element ID specified in Stringexp1.  Stringexp2 must be set to left or top.
**********************************************/ 
function getElementPosition(Element, side) {
	oElement = createReference(Element)
    if (isIE) {  												//String manip:  Make sure side is Left or Top...IE doesn't understand all lower case.
		elementPos = eval('oElement.pixel' + (side.toUpperCase()).substring(0,1) + (side.toLowerCase()).substring(1,side.length))	
	} else if (isDOM) {
        elementPos = parseInt(eval('oElement.' + side.toLowerCase()))
    } else {
		elementPos = eval('oElement.' + side.toLowerCase())
	}
    return elementPos
}

/**********************************************
 getPageOffset(obj1, stringexp2)    
 Obj1:
 	use:required
	Datatype:  Object
	A valid object reference
 stringexp 2:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  Integer
 Description:   This function retrieves the coordinate (stringexp2) for the element  specified in obj1.  
 				Obj1 musty be an object reference in form document.all.ID or document.getElementbyId('ID') 
				as appropriate for the given browser.Stringexp2 must be set to left or top.
**********************************************/ 
function getPageOffset(el, coord) {
	var x;
	// Return the x coordinate of an element relative to the page.
	if (coord == "left") {
		x = el.offsetLeft;
		if (el.offsetParent != null){
			x += getPageOffset(el.offsetParent, 'left');
		}
	} else {
		x =  el.offsetTop;
		if (el.offsetParent != null){
			x += getPageOffset(el.offsetParent, 'top');
		}
	}
	return x;
}

/**********************************************
 getElementDimension(stringexp1, stringexp2)    
 stringexp 1 and 2:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  Integer
 Description:   This function retrieves the dimension (stringexp2) for the element ID specified in Stringexp1.  Stringexp2 must be set to width or height.
**********************************************/ 
function getElementDimension(Element, dim) {
    oElement = createReference(Element)
    if (isIE) {												//String manip:  Make sure side is Left or Top...IE doesn't understand all lower case.
		elementDim = eval('oElement.pixel' + (dim.toUpperCase()).substring(0,1) + (dim.toLowerCase()).substring(1,dim.length))
	} else if (isDOM) {
        elementDim = parseInt(eval('oElement.' + dim.toLowerCase()))
    } else {
		elementDim = eval('oElement.document.' + dim.toLowerCase())
	}
    return elementDim
}

/**********************************************
 getElementUNPOSDimension(stringexp1, stringexp2)    
 stringexp 1 and 2:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  Integer
 Description:   This function retrieves the dimension (stringexp2) for the UNDIMENSIONED element ID specified in Stringexp1.  Stringexp2 must be set to width or height.
**********************************************/ 
function getElementUNPOSDimension(Element, dim) {
	oElement = createReference(Element)
    if (isIE && !isMac) {	
		if (dim == "width") {
			dim = "scrollWidth"
		} else {
			dim = "scrollHeight"
		}						
		elementDim = eval('document.all.' + Element + '.' + dim);
	} else {
		if (dim == "width") {
			dim = "offsetWidth"
		} else {
			dim = "offsetHeight"
		}	
		elementDim = eval('document.getElementById("' + Element + '").' + dim);	
    }
    return elementDim
}

/**********************************************
 setElementClass([stringexp, str2])    
 Return:  Nothing
 Description:   Replaces style class of element found at reference stringexp with specified class str2.  Class may
 				may be specified in page, or in external stylesheet, but a class name MUST be used.
 Tips:  You may use any number of argument pairs to swap multiple classes at the same time.  Arguments MUST be 
  		paired;  args not paired will result in an error.
**********************************************/ 
function setElementClass() {
    for (var i=0; i<setElementClass.arguments.length; i+=2) {
		if (isIE) { 
			eval('document.all.' + setElementClass.arguments[i] + '.className = "' + setElementClass.arguments[i+1] + '"'); 
		} else if (isDOM) {
			eval('document.getElementById(\'' + setElementClass.arguments[i] + '\').className = "' + setElementClass.arguments[i+1] + '"'); 
		}
	}
}