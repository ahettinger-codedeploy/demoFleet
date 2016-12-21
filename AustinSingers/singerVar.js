
	var NoOffFirstLineMenus=6;			// Number of first level items
	var LowBgColor='white';				// Background color when mouse is not over
	var LowSubBgColor='lightgrey';			// Background color when mouse is not over on subs
	var HighBgColor='navy';			        // Background color when mouse is over
	var HighSubBgColor='navy';			// Background color when mouse is over on subs
	var FontLowColor='navy';			// Font color when mouse is not over
	var FontSubLowColor='navy';			// Font color subs when mouse is not over
	var FontHighColor='white';			// Font color when mouse is over
	var FontSubHighColor='white';			// Font color subs when mouse is over
	var BorderColor='black';			// Border color
	var BorderSubColor='black';			// Border color for subs
	var BorderWidth=1;				// Border width
	var BorderBtwnElmnts=1;				// Border between elements 1 or 0
	var FontFamily="arial,comic sans ms,technical"	// Font family menu items
	var FontSize=8;					// Font size menu items
	var FontBold=1;					// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered='left';			// Item text position 'left', 'center' or 'right'
	var MenuCentered='left';			// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';			// Menu vertical position 'top', 'middle','bottom' or static
	var ChildOverlap=.2;				// horizontal overlap child/ parent
	var ChildVerticalOverlap=.2;			// vertical overlap child/ parent
	var StartTop=0;					// Menu offset x coordinate
	var StartLeft=0;				// Menu offset y coordinate
	var VerCorrect=0;				// Multiple frames y correction
	var HorCorrect=0;				// Multiple frames x correction
	var LeftPaddng=3;				// Left padding
	var TopPaddng=2;				// Top padding
	var FirstLineHorizontal=1;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
	var MenuFramesVertical=1;			// Frames in cols or rows 1 or 0
	var DissapearDelay=1000;			// delay before menu folds in
	var TakeOverBgColor=1;				// Menu frame takes over background color subitem frame
	var FirstLineFrame='navig';			// Frame where first level appears
	var SecLineFrame='space';			// Frame where sub levels appear
	var DocTargetFrame='space';			// Frame where target documents appear
	var TargetLoc='MenuPos';			// span id for relative positioning
	var HideTop=0;					// Hide first level when loading new document 1 or 0
	var MenuWrap=1;					// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;				// Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;				// menu tree checking on or off 1 or 0
	var ShowArrow=1;				// Uses arrow gifs when 1
	var KeepHilite=1;				// Keep selected path highligthed
	var Arrws=['images/tri.gif',5,10,'images/tridown.gif',10,5,'images/trileft.gif',5,10];	// Arrow source, width and height

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}
function AfterCloseAll(){return}


// Menu tree
//	MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//	For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"

Menu1=new Array("Performances","","",2,20,124);
	Menu1_1=new Array("Upcoming Events","http://www.austinsingers.org/perf.htm","",0,20,240);
	Menu1_2=new Array("Past Performances","http://www.austinsingers.org/pastPerf.htm",20,0);
	

Menu2=new Array("Membership","http://www.austinsingers.org/members.htm","",0);

Menu3=new Array("Order Tickets","http://www.austinsingers.org/ticket.htm","",0);

Menu4=new Array("About Us","","",4,20,124);
       Menu4_1=new Array("Board", "http://www.austinsingers.org/board.htm","",0,20,240);
       Menu4_2=new Array("Staff", "http://www.austinsingers.org/staff.htm","",0,20,0);
       Menu4_3=new Array("Mission and History", "http://www.austinsingers.org/missHistory.htm","",0,20,0);
       Menu4_4=new Array("See and Hear Us", "http://www.austinsingers.org/scrapbook.htm","",0,20,0);


Menu5=new Array("Support Us","","",2,20,124);
       Menu5_1=new Array("Make a Donation","http://www.austinsingers.org/makeDon.htm","",0,20,240);
       Menu5_2=new Array("Donors and Sponsors","http://www.austinsingers.org/donorSponsors.htm","",0,20,0);

Menu6=new Array("Contact Us","javascript:top.location.href='http://www.austinsingers.org/contact.htm'","",0);




