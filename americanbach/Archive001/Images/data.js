/*
   Deluxe Menu Data File
   Created by Deluxe Tuner v3.2
   http://deluxe-menu.com
*/

var key="165b1615exid";

// -- Deluxe Tuner Style Names
var itemStylesNames=["Top Item",];
var menuStylesNames=["Top Menu",];
// -- End of Deluxe Tuner Style Names

//--- Common
var isHorizontal=1;
var smColumns=1;
var smOrientation=0;
var dmRTL=0;
var pressedItem=-2;
var itemCursor="default";
var itemTarget="_self";
var statusString="link";
var blankImage="http://www.americanbach.org/data.files/blank.gif";
var pathPrefix_img="";
var pathPrefix_link="";

//--- Dimensions
var menuWidth="";
var menuHeight="23px";
var smWidth="";
var smHeight="";

//--- Positioning
var absolutePos=0;
var posX="10px";
var posY="10px";
var topDX=0;
var topDY=-2;
var DX=-1;
var DY=0;
var subMenuAlign="center";
var subMenuVAlign="top";

//--- Font
var fontStyle=["normal 13px Arial","normal 13px Arial"];
var fontColor=["#FFFFFF","#FFCC33"];
var fontDecoration=["none","none"];
var fontColorDisabled="#544473";

//--- Appearance
var menuBackColor="#333333";
var menuBackImage="";
var menuBackRepeat="repeat";
var menuBorderColor="#FFFFFF";
var menuBorderWidth=1;
var menuBorderStyle="solid";

//--- Item Appearance
var itemBackColor=["#333333","#000000"];
var itemBackImage=["",""];
var beforeItemImage=["",""];
var afterItemImage=["",""];
var beforeItemImageW="";
var afterItemImageW="";
var beforeItemImageH="";
var afterItemImageH="";
var itemBorderWidth=1;
var itemBorderColor=["#333333","#FFFFFF"];
var itemBorderStyle=["solid","solid"];
var itemSpacing=6;
var itemPadding="4px";
var itemAlignTop="center";
var itemAlign="left";

//--- Icons
var iconTopWidth=16;
var iconTopHeight=16;
var iconWidth=16;
var iconHeight=16;
var arrowWidth=7;
var arrowHeight=7;
var arrowImageMain=["",""];
var arrowWidthSub=0;
var arrowHeightSub=0;
var arrowImageSub=["http://www.americanbach.org/data.files/arr_white.gif",""];

//--- Separators
var separatorImage="";
var separatorWidth="100%";
var separatorHeight="3px";
var separatorAlignment="left";
var separatorVImage="";
var separatorVWidth="3px";
var separatorVHeight="100%";
var separatorPadding="0px";

//--- Floatable Menu
var floatable=0;
var floatIterations=6;
var floatableX=1;
var floatableY=1;
var floatableDX=15;
var floatableDY=15;

//--- Movable Menu
var movable=0;
var moveWidth=12;
var moveHeight=20;
var moveColor="#DECA9A";
var moveImage="";
var moveCursor="move";
var smMovable=0;
var closeBtnW=15;
var closeBtnH=15;
var closeBtn="";

//--- Transitional Effects & Filters
var transparency="90";
var transition=27;
var transOptions="gradientSize=0.4, wipestyle=1, motion=forward";
var transDuration=500;
var transDuration2=200;
var shadowLen=5;
var shadowColor="#666666";
var shadowTop=0;

//--- CSS Support (CSS-based Menu)
var cssStyle=0;
var cssSubmenu="";
var cssItem=["",""];
var cssItemText=["",""];

//--- Advanced
var dmObjectsCheck=0;
var saveNavigationPath=1;
var showByClick=0;
var noWrap=1;
var smShowPause=200;
var smHidePause=1000;
var smSmartScroll=1;
var topSmartScroll=0;
var smHideOnClick=1;
var dm_writeAll=1;
var useIFRAME=0;
var dmSearch=0;

//--- AJAX-like Technology
var dmAJAX=0;
var dmAJAXCount=0;
var ajaxReload=0;

//--- Dynamic Menu
var dynamic=0;

//--- Keystrokes Support
var keystrokes=0;
var dm_focus=1;
var dm_actKey=113;

//--- Sound
var onOverSnd="";
var onClickSnd="";

var itemStyles = [
    ["itemWidth=105px","itemHeight=21px","itemBackColor=transparent,transparent","itemBackImage=http://www.americanbach.org/data.files/btn_black.gif,http://www.americanbach.org/data.files/btn_black2.gif","itemBorderWidth=0","fontStyle='normal 12px Arial','normal 12px Arial'","fontColor=#DDBB00,#FFFFFF","showByClick=0"],
];
var menuStyles = [
    ["menuBackColor=transparent","menuBorderWidth=0","itemSpacing=0","itemPadding=5px 6px 5px 6px","smOrientation=undefined"],
];

var menuItems = [

    ["HOME","http://www.americanbach.org/index.htm", "", "", "", "", "0", "0", "", "", "", ],
    ["LISTEN","http://americanbach.org/Discography.htm", "", "", "", "", "0", "0", "", "", "", ],
        ["|24/7 FREE Audio Player","http://americanbach.org/player/index.htm", "", "", "", "", "", "-1", "", "", "", ],
        ["|CD Store - Discography","http://americanbach.org/Discography.htm", "", "", "", "", "", "-1", "", "", "", ],
        ["|Our Newest Release: Ian Howell","http://www.americanbach.org/recordings/Howell.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Brandenburg Concertos","http://www.americanbach.org/recordings/Brandenburgs.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Handel's Messiah","http://www.americanbach.org/MessiahCD.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Beethoven's Ninth Symphony","http://www.americanbach.org/recordings/BeethovenNotes.htm", "", "", "", "", "", "", "", "", "", ],
        ["|ABS on Magnatune.com","http://www.americanbach.org/magnatune/index.htm", "", "", "", "", "", "", "", "", "", ],
        ["|ABS on iTunes","itms://phobos.apple.com/WebObjects/MZSearch.woa/wa/advancedSearchResults?artistTerm=American Bach Soloists", "", "", "", "", "", "", "", "", "", ],
        ["|Jeffrey Thomas on KDFC","http://americanbach.org/kdfc.html", "", "", "", "", "", "", "", "", "", ],
    ["ATTEND","http://www.americanbach.org/seasons/09-10/index.htm", "", "", "", "", "0", "0", "", "", "", ],
        ["|CONCERTS","http://www.americanbach.org/seasons/09-10/index.htm", "", "", "", "", "", "", "", "", "", ],
            ["||2009-2010 Season","http://www.americanbach.org/seasons/09-10/index.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Important News about SummerFest","http://www.americanbach.org/SummerFest.htm", "", "", "", "", "", "", "", "", "", ],
        ["|SUBSCRIBE","http://americanbach.org/HowToSubscribe.htm", "", "", "", "", "", "", "", "", "", ],
            ["||How to Subscribe","http://americanbach.org/HowToSubscribe.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Subscriber Benefits","http://www.americanbach.org/Subscribe.htm", "", "", "", "", "", "", "", "", "", ],
        ["|TICKETS","http://www.americanbach.org/PurchaseTicketsOnline.htm", "", "", "", "", "", "", "", "", "", ],
            ["||How to Order","http://www.americanbach.org/Tickets.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Purchase Tickets Online","http://www.americanbach.org/PurchaseTicketsOnline.htm", "", "", "", "", "", "", "", "", "", ],
        ["|ABS Master Classes","http://www.americanbach.org/MasterClasses.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Venues & Seating Charts","http://www.americanbach.org/Venues.htm", "", "", "", "", "", "", "", "", "", ],
        ["|K-12 Music Educators Program","http://www.americanbach.org/educators/index.htm", "", "", "", "", "", "", "", "", "", ],
    ["SUPPORT","http://www.americanbach.org/Giving.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|Individual Contributions","http://www.americanbach.org/Giving.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Matching Gifts ","http://www.americanbach.org/MatchingGifts.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Honor your Loved Ones","http://www.americanbach.org/HonorYourLovedOnes.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Foundation Support","http://www.americanbach.org/FoundationSupport.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Corporate Gifts","http://www.americanbach.org/CorporateSponsorships.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Planned Giving","http://www.americanbach.org/PlannedGiving.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Gifts in Kind","http://www.americanbach.org/GiftsInKind.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Vehicle Donations","http://www.americanbach.org/VehicleDonation.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Purchase Program Ads","http://www.americanbach.org/Assets/AdInfo/ABS_Program_Ads.pdf", "", "", "", "_blank", "", "", "", "", "", ],
    ["LEARN","http://americanbach.org/WhatWeBelieve.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|What We Believe","http://americanbach.org/WhatWeBelieve.htm", "", "", "", "", "", "", "", "", "", ],
        ["|ABOUT ABS","http://americanbach.org/AboutUs.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Organizational Bio","http://americanbach.org/AboutUs.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Jeffrey Thomas, music director","http://www.americanbach.org/JeffreyThomas.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Artist Roster & Bios","http://www.americanbach.org/ArtistRoster.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Our Staff","http://www.americanbach.org/OurStaff.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Board of Directors & Founders","http://www.americanbach.org/BoardOfDirectors.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Career Opportunities","http://www.americanbach.org/careers/index.htm", "", "", "", "", "", "", "", "", "", ],
        ["|ABS Master Classes @ S.F. Conservatory","http://www.americanbach.org/MasterClasses.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Free Choral Workshop - Mass in B Minor","http://www.americanbach.org/workshop/index.html", "", "", "", "", "", "", "", "", "", ],
        ["|About Early Instruments","http://www.americanbach.org/ASimplePrimerOnEarlyInstruments.htm", "", "", "", "", "", "", "", "", "", ],
        ["|K-12 Music Educators Program","http://www.americanbach.org/educators/index.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Noteworthy - ABS' annual newsletter","http://www.americanbach.org/Noteworthy-June2008.pdf", "", "", "", "_blank", "", "", "", "", "", ],
        ["|Links to Other Resources","http://www.americanbach.org/LinksToOtherResources.htm", "", "", "", "", "", "", "", "", "", ],
        ["|International Young Artists Competition","http://www.americanbach.org/competition/index.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Press and Media Resources","http://www.americanbach.org/press/index.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Concert Program Book Archives","http://www.americanbach.org/ProgramBooklets/", "", "", "", "_blank", "", "", "", "", "", ],
    ["PARTICIPATE","http://americanbach.org/Volunteers.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|Volunteer","http://americanbach.org/Volunteers.htm", "", "", "", "", "", "-1", "", "", "", ],
        ["|Viral Marketing","http://americanbach.org/ViralMarketing.html", "", "", "", "", "", "", "", "", "", ],
        ["|Career Opportunities","http://americanbach.org/careers/index.htm", "", "", "", "", "", "", "", "", "", ],
    ["HELP","http://www.americanbach.org/Contact.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|Contact Us","http://www.americanbach.org/Contact.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Venues & Seating Charts","http://www.americanbach.org/Venues.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Join our e-mail list","http://www.patronmail.com/pmailweb/PatronSetup?oid=426", "", "", "", "_blank", "", "", "", "", "", ],
        ["|Request a Season Brochure","http://www.americanbach.org/brochure.html", "", "", "", "", "", "", "", "", "", ],
        ["|Submit Feedback","http://www.americanbach.org/feedbackForm.html", "", "", "", "", "", "", "", "", "", ],
        ["|Press Resources","http://www.americanbach.org/PressMediaResources.htm", "", "", "", "", "", "", "", "", "", ],
    ["AUDIO PLAYER","http://www.americanbach.org/player/index.htm", "", "", "", "", "0", "", "", "", "", ],
];

dm_init();