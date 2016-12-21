function ddmOut (num)
{
	if (num > 0)
	{
		rootNode = document.getElementById("dropdownrootitem" + num);
		if (rootPageForDDM != num)
			if (rootNode != null)
				if (rootNode.className == "dropdownrootitem" + num + "_over")
					rootNode.className = "dropdownrootitem" + num;
	}
}

function ddmOver (num)
{
	if (num > 0)
	{
		rootNode = document.getElementById("dropdownrootitem" + num);
		if (rootNode != null)
			if (rootNode.className == "dropdownrootitem" + num)
				rootNode.className = "dropdownrootitem" + num + "_over";
	}
}

startList = function() 
			{
				if (document.all&&document.getElementById)
				{
					cssdropdownRoot = document.getElementById("dropdownmenu");
					if (cssdropdownRoot != null)
					{
						for (x=0; x<cssdropdownRoot.childNodes.length; x++) 
						{
							node = cssdropdownRoot.childNodes[x];
							// code begins for sub-menu class change to make menu works for IE6. 
							if (node.nodeName=="LI") 
							{
								node.onmouseover=function()
								{
									this.className+=" over";
								}
								node.onmouseout=function()
								{
									this.className=this.className.replace(" over", "");
								}
							}
							// code ends for sub-menu class change to make menu works for IE6. 
						}
					}
					
					// This section of code is added for the new share button. 
					// =========================================================
					navRoot = document.getElementById("share");
					if (navRoot != null)
					{
						for (i=0; i<navRoot.childNodes.length; i++) 
						{
							node = navRoot.childNodes[i];
							if (node.nodeName=="DIV") 
							{
								node.onmouseover=function() {
									this.className+=" over";
								}
								node.onmouseout=function() {
								this.className=this.className.replace(" over", "");
								}
							}
						}
					}
					// =========================================================
				}
			}

if (window.attachEvent)
	window.attachEvent("onload", startList)
else
	window.onload=startList;



// The following scripts is to fix the problem that when user uses 1024 resolutions and mouse over the last 
// right hand drop down, the 3rd level menu open to the right which makes the page having horizontal scroll
// bar. We use javascript to dynamically turn on/off the extra CSS reference, dropdownmenu_1024.css. 
// You may set the browser width as you want in below. 
// ========================================================================================================
function dynamicLayout(){
    var browserWidth = getBrowserWidth();
    
    if (browserWidth <= 1530){
        var theStyleLink = document.getElementById('dropDownMenu_1024');
		theStyleLink.disabled = false;
    }
    else
    {
		var theStyleLink = document.getElementById('dropDownMenu_1024');
		theStyleLink.disabled = true;
    }
    
    if (browserWidth <= 1350){
        var theStyleLink = document.getElementById('dropDownMenu_800');
		theStyleLink.disabled = false;
    }
    else
    {
		var theStyleLink = document.getElementById('dropDownMenu_800');
		theStyleLink.disabled = true;
    }
}

function getBrowserWidth(){
    if (window.innerWidth){
        return window.innerWidth;}  
    else if (document.documentElement && document.documentElement.clientWidth != 0){
        return document.documentElement.clientWidth;    }
    else if (document.body){return document.body.clientWidth;}      
        return 0;
}

function addEvent( obj, type, fn ){ 
   if (obj.addEventListener){ 
      obj.addEventListener( type, fn, false );
   }
   else if (obj.attachEvent){ 
      obj["e"+type+fn] = fn; 
      obj[type+fn] = function(){ obj["e"+type+fn]( window.event ); } 
      obj.attachEvent( "on"+type, obj[type+fn] ); 
   } 
} 

//Run dynamicLayout function when page loads and when it resizes.
addEvent(window, 'load', dynamicLayout);
addEvent(window, 'resize', dynamicLayout);
// ========================================================================================================

// Delay function
// ========================================================================================================
var timeout1	= 2000;
var timeout2	= 2000;
var closetimer1	= 0;
var closetimer2	= 0;
var ddmenuitem1	= 0;
var ddmenuitem2	= 0;
var ddmenuitem1li	= 0;
var prevParentLiID = "";
var li_original_zIndex = 200;
var li_top_zIndex = 7000;

// open hidden layer
function mopen1(id,parentLiID)
{	
	// cancel both close timers
	if(ddmenuitem1)
		mcancelclosetime1();
	if(ddmenuitem2)
		mcancelclosetime2();

	// close both old layers
	if(ddmenuitem1) 
		ddmenuitem1.style.display = '';
	if(ddmenuitem2) 
		ddmenuitem2.style.display = '';

	if (prevParentLiID.length > 0)
	{
		ddmenuitem1li = document.getElementById(prevParentLiID);
		ddmenuitem1li.style.zIndex = li_original_zIndex;
		prevParentLiID = "";
	}

	if (parentLiID.length > 0)
	{
		ddmenuitem1li = document.getElementById(parentLiID);
		ddmenuitem1li.style.zIndex = li_top_zIndex;
		prevParentLiID = parentLiID;
	}

	// get new layer 1 and show it
	ddmenuitem1 = document.getElementById(id);
	if (ddmenuitem1 != null)
		ddmenuitem1.style.display = 'block';
}
function mopen2(id,parentLiID)
{	
	// cancel both close timers
	if(ddmenuitem1)
		mcancelclosetime1();
	if(ddmenuitem2)
		mcancelclosetime2();

	// close old layer 2
	if(ddmenuitem2) 
		ddmenuitem2.style.display = '';
	
	if (prevParentLiID.length > 0)
	{
		if (prevParentLiID != parentLiID)
		{
			ddmenuitem1li = document.getElementById(prevParentLiID);
			ddmenuitem1li.style.zIndex = li_original_zIndex;
			prevParentLiID = "";
		}
	}
	
	if (parentLiID.length > 0)
	{
		ddmenuitem1li = document.getElementById(parentLiID);
		ddmenuitem1li.style.zIndex = li_top_zIndex;
		prevParentLiID = parentLiID;
	}

	// get new layer 2 and show it
	ddmenuitem2 = document.getElementById(id);
	ddmenuitem2.style.display = 'block';
}

// close showed layer 1
function mclose1()
{
	if(ddmenuitem1) ddmenuitem1.style.display = '';
}

// close both showed layers
function mclose2()
{
	if(ddmenuitem1) ddmenuitem1.style.display = '';
	if(ddmenuitem2) ddmenuitem2.style.display = '';
}

// initialize close timer 1
function mclosetime1(id,parentLiID)
{
	ddmenuitem1 = document.getElementById(id);
	closetimer1 = window.setTimeout(mclose1, timeout1);
}

// initialize close timer 2
function mclosetime2(id,parentLiID)
{
	if (parentLiID.length > 0)
	{
		ddmenuitem1li = document.getElementById(parentLiID);
		ddmenuitem1li.style.zIndex = li_top_zIndex;
		prevParentLiID = parentLiID;
	}

	ddmenuitem2 = document.getElementById(id);
	closetimer2 = window.setTimeout(mclose2, timeout2);
}

// cancel close timer 1
function mcancelclosetime1()
{
	if(closetimer1)
	{
		window.clearTimeout(closetimer1);
		closetimer1 = null;
	}
}

// cancel close timer 2
function mcancelclosetime2()
{
	if(closetimer2)
	{
		window.clearTimeout(closetimer2);
		closetimer2 = null;
	}
}

// close layer when click-out
document.onclick = mclose2
// ========================================================================================================
