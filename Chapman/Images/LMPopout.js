/**********************************************
 NAVPopout.js
 Javascript menu system:  Menus appear on mouseover
    next to link touched.  
 Author:  M. Dempster 8/22/02
 Modified: M. Dempster 2/08/03  (Autopositioning)
 Copyright:  LiquidMatrix Corp.
**********************************************/
/**********************************************
 Menu tracking variables
 These variables are used to determine when to shut off menus
**********************************************/ 
var currentMenu = ""		//Lists the ID of the menu currently shown
var XShift = -8				//Holds number of pixels to shift popout on X coord
var YShift = 12				//Holds number of pixels to shift popout on Y coord
var XMacShift = 0			//Holds fudge factor for Mac X margin misread.
var YMacShift = 18          //Holds fudge factor for Mac Y margin misread.
var onMenuLink = false		//NAV4 only:  Lets you know if you're still on a triggering link.


/**********************************************
 openMenu(stringexp)    
 stringexp:  
 	use:  Required
	Datatype:  String
	A valid string expression
 Return:  none
 Description:  sets the visibility style of the Element specified by stringexp to visible.
 			   In addition, tracks that element for later deactivation.
**********************************************/ 
function openMenu(event, Element) {
	if (document.getElementById(Element) || document.all.Element ) { 
		if (isIE) {												
		  current = window.event.srcElement;					//Set current to menu trigger moused over.
		}
		else {
		  current = event.currentTarget;						//Set current to menu trigger moused over.
		}
		var elContainerWidth = getElementUNPOSDimension('navigationContainer', 'width');
		var elMenuWidth = getElementUNPOSDimension(Element, 'width');
		var elX = getPageOffset(current, 'left')
		var elY = getPageOffset(current, 'top')
		if ((isMac) && (isIE)) {													// Kludge for margining in IE5 Mac:  I can't convince it to get the offset + margin position.  *shrug* 
			if (((elX+XShift) + elMenuWidth) > elContainerWidth) {
				setElementPosition(Element, (elContainerWidth - elMenuWidth + 11 + XMacShift), (elY + YShift + YMacShift))
			} else {
				setElementPosition(Element, (elX+XShift+XMacShift), (elY+YShift+YMacShift)) 
			}
			
			
		} else {
			if (((elX+XShift) + elMenuWidth) > elContainerWidth) {
				setElementPosition(Element, (elContainerWidth - elMenuWidth + 11), (elY + YShift))
			} else {
				setElementPosition(Element, (elX + XShift), (elY + YShift))
			}
		}
		if (currentMenu != "") setElementVisibility(currentMenu, 'hidden');			//If there is a menu currently showing, set it's visibility to hidden.
		setElementVisibility(Element, 'visible');									//Set the visibility of the menu specified to visible.
		currentMenu = Element;														//Set currentMenu to be the menu we're opening now.
	}													
}

/**********************************************
 closeMenu(event, stringexp)    
 stringexp:
 	use:  Required
	Datatype:  String
	A valid string expression
 event:  
 	use:  required
	Datatype:  A browser Event
	A vaid browser event reference for capture.
 Return:  none
 Description:  Closes the specified menu when the mouse moves out of the Div 
 			  and set currentMenu to nothing. 
 Tips:  This function is called like:  closeMenu(event, 'TESTDIV1').  You must ALWAYS specify the word event as the first arg.
**********************************************/ 
function closeMenu(event, Element) {
	if (currentMenu != "") {
		var current, related, container;									//Set Varibles to track targets of event (Note:  Understanding the DOM model is KEY for this!)
		if (isIE) {												
		  current = eval("document.all." + Element);			//Set current to menu specified in Element.
		  related = window.event.toElement;						//Set related to the element we're mousing into.
		  container = eval("document.all.navigationContainer");
		}
		else {
		  current = event.currentTarget;						//Set current to the element that the mouseout is specified on.  (Could be done with a listener)
		  related = event.relatedTarget;						//Set related to the element we're mousing into.
		  container = eval("document.getElementById('navigationContainer')");
		}
		 if (current != related && !nodeContains(current, related)) {	//If current isn't what we're mousing into, and the element we ARE mousing into doesn't contain related, then hide current, and set the currentMenu var to nothing. 
		   	if (Element == 'navigationContainer') {
				idstring = related.id;
				if ((idstring.indexOf('Menu') == -1) && (!nodeContains(container, related))) {
			 		if (currentMenu != "") setElementVisibility(currentMenu, 'hidden');
					currentMenu = ""
				}
			} else {
				idstring = related.id;
				if ((idstring.indexOf('navigationContainer') == -1) && (!nodeContains(container, related))) {
			 		current.style.visibility = "hidden";					   
					currentMenu = "";
				}
				
			}
		}
	}
}

/**********************************************
 nodeContains(obj1, obj2)    
 obj1:
 	use:  Required
	Datatype:  Object reference
	A valid HTML object (ex.  Document.all.Elementname)
 obj2:
 	use:  Required
	Datatype:  Object reference
	A valid HTML object (ex.  Document.all.Elementname)
 Return:  Boolean
 Description:  Looks for two objects.  Loops through B's parent nodes one by one.  If A equals a 
 			   parentNode of B, then return true; A contains B.  Else, return false. 
**********************************************/ 
function nodeContains(a, b) {
	strLoop = ""		
	while (b.parentNode)
		if ((b = b.parentNode) == a)
      		return true;
	return false;
}

