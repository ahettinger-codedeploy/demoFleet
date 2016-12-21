// --- style names ---
var itemStylesNames=[];
var menuStylesNames=[];

//--- Common
var isHorizontal=1;
var smOrientation=0;
var smViewType=0;
var smColumns=1;
var pressedItem=-2;
var itemCursor="pointer";
var itemTarget="_self";
var statusString="link";
var blankImage="images/spacer.gif";
//--- Dimensions
var menuWidth="";
var smWidth="";
var smHeight="";

//--- Positioning
var absolutePos=0;
var posX=0;
var posY=0;
var topDX=0;
var topDY=1;
var DX=-5;
var DY=0;

//--- Appearance
var menuBackColor="";
var menuBackImage="";
var menuBorderColor="#000000";
var menuBorderWidth=0;
var menuBorderStyle="solid";

//--- Font
var fontStyle="normal 11px Trebuchet MS, Tahoma";
var fontColor=["#DDDDDD","#FFFFFF"];
var fontDecoration=["none","none"];
var fontColorDisabled="#AAAAAA";

//--- Item Appearance
var itemBackColor=["",""];
var itemBackImage=["",""];
var itemBorderWidth=0;
var itemBorderColor=["#444444","#888888"];
var itemBorderStyle=["solid","solid"];
var itemSpacing=2;
var itemPadding=1;
var itemAlign="right";
var subMenuAlign="right";

//--- Floatable Menu
var floatable=0;
var floatIterations=6;
var floatableX=1;
var floatableY=1;

//--- Movable Menu
var movable=0;
var moveWidth=12;
var moveHeight=20;
var moveColor="#ff0000";
var moveImage="";
var moveCursor="move";
var smMovable=0;
var closeBtnW=15;
var closeBtnH=15;
var closeBtn="";

//--- Icons
var iconTopWidth=16;
var iconTopHeight=16;
var iconWidth=16;
var iconHeight=16;
var arrowWidth=8;
var arrowHeight=16;
var arrowImageMain=["",""];
var arrowImageSub=["",""];

//--- Transitional Effects & Filters
var transparency="93";
var transition=24;
var transOptions="";
var transDuration=350;
var shadowLen=3;
var shadowColor="#666666";
var shadowTop=0;

//--- Separators
var separatorImage="";
var separatorWidth="100%";
var separatorHeight="3";
var separatorAlignment="left";
var separatorVImage="";
var separatorVWidth="3";
var separatorVHeight="100%";

//--- CSS Support (CSS-based Menu)
var cssStyle=0;
var cssSubmenu="";
var cssItem=["",""];
var cssItemText=["",""];

//--- Advanced
var saveNavigationPath=1;
var showByClick=0;
var noWrap=1;
var pathPrefix_img="";
var pathPrefix_link="";
var smShowPause=200;
var smHidePause=1000;
var dm_writeAll=0;

//--- Keystrokes Support
var keystrokes=0;

//--- Dynamic Menu
var dynamic=0;

//--- MAC OS Additional (IE only)
var macIEoffX=10;
var macIEoffY=15;
var macIEtopDX=0;
var macIEtopDY=2;
var macIEDX=-3;
var macIEDY=0;

var itemStyles = [
        ["fontStyle=normal 14px Arial, Tahoma"],     // style with index 0
		["itemBackColor=#444444,#666666", "itemBorderWidth=1", "itemBorderStyle=solid,solid", "itemBorderColor=#444444,#888888", ],     // style with index 1
]; 
var menuStyles = [
        [ ],     // style with index 0
		["menuBorderWidth=1", "menuBorderStyle=solid", "menuBorderColor=#000000", "menuBackColor=#444444", ],     // style with index 1
]; 