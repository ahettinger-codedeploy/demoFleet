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
var blankImage="http://americanbach.org/data.files/blank.gif";
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
var fontStyle=["normal 13px Trebuchet MS, Tahoma, Arial","normal 13px Trebuchet MS, Tahoma, Arial"];
var fontColor=["#FFFFFF","#EBB95D"];
var fontDecoration=["none","none"];
var fontColorDisabled="#544473";

//--- Appearance
var menuBackColor="#3393b6";
var menuBackImage="";
var menuBackRepeat="repeat";
var menuBorderColor="#FFFFFF";
var menuBorderWidth=1;
var menuBorderStyle="solid";

//--- Item Appearance
var itemBackColor=["#3393b6","#000000"];
var itemBackImage=["",""];
var beforeItemImage=["",""];
var afterItemImage=["",""];
var beforeItemImageW="";
var afterItemImageW="";
var beforeItemImageH="";
var afterItemImageH="";
var itemBorderWidth=1;
var itemBorderColor=["#3393b6","#EBB95D"];
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
var arrowImageSub=["http://americanbach.org/data.files/arr_white.gif",""];

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
    ["itemWidth=125px","itemHeight=21px","itemBackColor=transparent,transparent","itemBackImage=http://americanbach.org/data.files/btn_orange.gif,http://americanbach.org/data.files/btn_orange.gif","itemBorderWidth=0","fontStyle='normal 12px Arial','normal 12px Arial'","fontColor=#FFFFFF,#EBB95D","showByClick=0"],
];
var menuStyles = [
    ["menuBackColor=transparent","menuBorderWidth=0","itemSpacing=0","itemPadding=5px 6px 5px 6px","smOrientation=undefined"],
];

var menuItems = [

    ["Home","http://americanbach.org/index.htm", "", "", "", "", "0", "0", "", "", "", ],
    ["Performances","http://americanbach.org/sfbachfestival/index.html", "", "", "", "", "0", "0", "", "", "", ],
		["|ABS FESTIVAL & ACADEMY","http://americanbach.org/sfbachfestival/index.html", "", "", "", "", "", "", "", "", "", ],
    	["|2011-2012 SEASON","http://americanbach.org/seasons/11-12/index.htm", "", "", "", "", "", "", "", "", "", ],
/*		["|Gala Benefit","http://americanbach.org/seasons/10-11/Gala.htm", "", "", "", "", "", "", "", "", "", ],
		["|Handel's Messiah","http://americanbach.org/seasons/10-11/Messiah.htm", "", "", "", "", "", "", "", "", "", ],
		["|Now Does the Glorious Day Appear","http://americanbach.org/seasons/10-11/RoyalWomen.htm", "", "", "", "", "", "", "", "", "", ],
		["|April Follies","http://americanbach.org/seasons/10-11/AprilFollies.htm", "", "", "", "", "", "", "", "", "", ],   */
		["|SUBSCRIBE","http://americanbach.org/HowToSubscribe.htm", "", "", "", "", "", "", "", "", "", ],
            ["||How to Subscribe","http://americanbach.org/HowToSubscribe.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Subscriber Benefits","http://americanbach.org/Subscribe.htm", "", "", "", "", "", "", "", "", "", ],
/*            ["||SummerFest/Academy Subscriptions","http://americanbach.tix.com/Schedule.asp?OrganizationNumber=2641", "", "", "", "", "", "", "", "", "", ], */
        ["|TICKETS","http://americanbach.org/PurchaseTicketsOnline.htm", "", "", "", "", "", "", "", "", "", ],
            ["||How to Order","http://americanbach.org/Tickets.htm", "", "", "", "", "", "", "", "", "", ],
            ["||Purchase Tickets Online","http://americanbach.org/PurchaseTicketsOnline.htm", "", "", "", "", "", "", "", "", "", ],
/*        ["|SEASON BROCHURE",, "", "", "", "", "", "", "", "", "", ], 
            ["||View High Quality (12MB)","seasons/09-10/ABSbrochure_HQ.pdf", "", "", "", "", "", "", "", "", "", ],
            ["||View Smaller File (2MB)","seasons/09-10/ABSbrochure.pdf", "", "", "", "", "", "", "", "", "", ], */
            ["||Request a Season Brochure","http://americanbach.org/brochure.html", "", "", "", "", "", "", "", "", "", ],
    	["|Venues & Seating Charts","http://americanbach.org/Venues.htm", "", "", "", "", "", "", "", "", "", ],
	    ["|Press & Media Resources","http://americanbach.org/press/index.htm", "", "", "", "", "", "", "", "", "", ],
	["Recordings","http://americanbach.org/Discography.htm", "", "", "", "", "0", "0", "", "", "", ],
        ["|24/7 FREE Audio Player","http://americanbach.org/player/index.htm", "", "", "", "", "", "-1", "", "", "", ],
        ["|CD Store - Discography","http://americanbach.org/Discography.htm", "", "", "", "", "", "-1", "", "", "", ],
        ["|Our Newest Release: Ian Howell","http://americanbach.org/recordings/Howell.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Brandenburg Concertos","http://americanbach.org/recordings/Brandenburgs.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Handel's Messiah","http://americanbach.org/MessiahCD.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Beethoven's Ninth Symphony","http://americanbach.org/recordings/BeethovenNotes.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Featured Recordings","http://americanbach.org/FeaturedRecordings.htm", "", "", "", "", "", "", "", "", "", ],
		["|ABS on iTunes","itms://phobos.apple.com/WebObjects/MZSearch.woa/wa/advancedSearchResults?artistTerm=American Bach Soloists", "", "", "", "", "", "", "", "", "", ],
        ["|Jeffrey Thomas on KDFC","http://americanbach.org/kdfc.html", "", "", "", "", "", "", "", "", "", ],
    ["Education","http://americanbach.org/AboutEarlyInstruments.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|About Early Instruments","http://americanbach.org/AboutEarlyInstruments.htm", "", "", "", "", "", "", "", "", "", ],
        ["|ACADEMY","http://americanbach.org/academy/index.html", "", "", "", "", "", "", "", "", "", ],
        ["|Insights","http://americanbach.org/Insights.htm", "", "", "", "", "", "", "", "", "", ],
        ["|ABS Master Classes @ S.F. Conservatory","http://americanbach.org/MasterClasses.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Free Choral Workshops","http://americanbach.org/workshop/index.html", "", "", "", "", "", "", "", "", "", ],
        ["|K-12 Music Educators Program","http://americanbach.org/educators/index.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Links to Other Resources","http://americanbach.org/LinksToOtherResources.htm", "", "", "", "", "", "", "", "", "", ],
        ["|International Young Artists Competition","http://americanbach.org/competition/index.htm", "", "", "", "", "", "", "", "", "", ],
     ["Support","http://americanbach.org/Giving.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|Annual Support","http://americanbach.org/Giving.htm", "", "", "", "", "", "", "", "", "", ],
        	["||Individual Contributions","http://americanbach.org/Giving.htm", "", "", "", "", "", "", "", "", "", ],
        	["||Matching Gifts ","http://americanbach.org/MatchingGifts.htm", "", "", "", "", "", "", "", "", "", ],
        	["||Honor your Loved Ones","http://americanbach.org/HonorYourLovedOnes.htm", "", "", "", "", "", "", "", "", "", ],
        	["||Foundation Support","http://americanbach.org/FoundationSupport.htm", "", "", "", "", "", "", "", "", "", ],
        	["||Corporate Sponsorship","http://americanbach.org/CorporateSponsorships.htm", "", "", "", "", "", "", "", "", "", ],
       	["|Support the ABS ACADEMY","http://americanbach.org/academy/AcademySupport.html", "", "", "", "", "", "", "", "", "", ],
        ["|2010 Benefit: A ROYAL GALA","http://americanbach.org/seasons/10-11/Gala.htm", "", "", "", "", "", "", "", "", "", ],
        ["|GALA Auction Item Donation Form","http://americanbach.org/seasons/10-11/assets/Gala_Donation_Form_2010.pdf", "", "", "", "", "", "", "", "", "", ],
        ["|Planned Giving","http://americanbach.org/PlannedGiving.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Gifts in Kind","http://americanbach.org/GiftsInKind.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Vehicle Donations","http://americanbach.org/VehicleDonation.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Purchase Program Ads","http://americanbach.org/Assets/AdInfo/ABS_Program_Ads.pdf", "", "", "", "_blank", "", "", "", "", "", ],
	    ["|Volunteer","http://americanbach.org/Volunteers.htm", "", "", "", "", "", "-1", "", "", "", ],
        ["|Viral Marketing","http://americanbach.org/ViralMarketing.html", "", "", "", "", "", "", "", "", "", ],
   ["Explore","http://americanbach.org/WhatWeBelieve.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|What We Believe","http://americanbach.org/WhatWeBelieve.htm", "", "", "", "", "", "", "", "", "", ],
		["|Organizational History","http://americanbach.org/AboutUs.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Jeffrey Thomas, music director","http://americanbach.org/JeffreyThomas.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Artist Roster & Bios","http://americanbach.org/ArtistRoster.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Our Staff","http://americanbach.org/OurStaff.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Board of Directors, Advisory Council, & Founders","http://americanbach.org/BoardOfDirectors.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Career Opportunities","http://americanbach.org/careers/index.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Press & Media Resources","http://americanbach.org/press/index.htm", "", "", "", "", "", "", "", "", "", ],
	    ["|SITE SEARCH","http://americanbach.org/search.html", "", "", "", "", "", "", "", "", "", ],
    ["Contact ABS","http://americanbach.org/Contact.htm", "", "", "", "", "0", "", "", "", "", ],
        ["|Contact Us","http://americanbach.org/Contact.htm", "", "", "", "", "", "", "", "", "", ],
        ["|Join our e-mail list","http://americanbach.org/JoinEmail.html", "", "", "", "", "", "", "", "", "", ],
        ["|Follow our Tweets on Twitter","http://twitter.com/americanbach", "", "", "", "_blank", "", "", "", "", "", ],
        ["|Find us on Facebook","http://www.facebook.com/help/contact_generic.php#/pages/AMERICAN-BACH-SOLOISTS/51654693644", "", "", "", "_blank", "", "", "", "", "", ],
        ["|Request a Season Brochure","http://americanbach.org/brochure.html", "", "", "", "", "", "", "", "", "", ],
        ["|Submit Feedback","http://americanbach.org/feedbackForm.html", "", "", "", "", "", "", "", "", "", ],
        ["|SITE SEARCH","http://americanbach.org/search.html", "", "", "", "", "", "", "", "", "", ],
	["Press","http://americanbach.org/press/index.htm", "", "", "", "", "0", "", "", "", "", ],
];

dm_init();