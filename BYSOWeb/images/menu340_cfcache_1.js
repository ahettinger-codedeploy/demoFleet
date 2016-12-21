
	
	/*	(c) Ger Versluis 2000 version 5 October 9th 2001	*
	*	You may remove all comments for faster loading	*/		

	var NoOffFirstLineMenus=6;		// Number of first level items
	var LowBgColor='';				// Background color when mouse is not over on Top
	var LowSubBgColor='ffffff';		// Background color when mouse is not over on subs
	var HighBgColor='';				// Background color when mouse is over on Top
	var HighSubBgColor='868686';	// Background color when mouse is over on subs
	var FontLowColor='000000';		// Font color when mouse is not over on Top
	var FontSubLowColor='000000';	// Font color subs when mouse is not over on Sub
	var FontHighColor='FDB914';		// Font color when mouse is over on Top
	var FontSubHighColor='000000';	// Font color subs when mouse is over on Sub
	var BorderColor='';				// Border color for Top
	var BorderSubColor='F4F5F5';	// Border color for subs
	var BorderWidth=0;				// Border width for Top
	var BorderSubWidth=1;			// Border width for subs
	var BorderBtwnElmnts=0;			// Border between elements 1 or 0 for Top
	var BorderBtwnSubElmnts=1;		// Border between elements 1 or 0 for Subs
	var FontFamily="arial,verdana,comic sans ms,technical"	// Font family menu items
	var FontSize=8;					// Font size menu items
	var FontBold=0;					// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered='left';	// Item text position 'left', 'center' or 'right'
	var MenuCentered='left';		// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';	// Menu vertical position 'top', 'middle' or 'bottom'
	var ChildOverlap=.0;			// horizontal overlap child/ parent
	var ChildVerticalOverlap=.0;	// vertical overlap child/ parent
	var StartTop=122;					// Menu offset x coordinate
	var StartLeft=100;				// Menu offset y coordinate
	var StartLeftNS=78;				// Menu offset y coordinate in NS
	var VerCorrect=0;				// Multiple frames y correction
	var HorCorrect=0;				// Multiple frames x correction
	var LeftPaddng=5;				// Left padding
	var TopPaddng=3;				// Top padding
	var FirstLineHorizontal=1;		// First level items layout horizontal 1 or 0
	var MenuFramesVertical=1;		// Frames in cols or rows 1 or 0
	var DissapearDelay=1000;		// delay before menu folds in
	var TakeOverBgColor=1;			// Menu frame takes over background color subitem frame
	var FirstLineFrame='navig';		// Frame where first level appears
	var SecLineFrame='space';		// Frame where sub levels appear
	var DocTargetFrame='space';		// Frame where target documents appear
	var TargetLoc='';				// DIV id for relative positioning (refer to config.htm for info)
	var HideTop=0;					// Hide first level when loading new document 1 or 0
	var MenuWrap=1;					// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;			// Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;			// menu tree checking on or off 1 or 0
    var Transparency=92;            // menu transparency
	var hidepicklist=1;				// hides all the select boxes on the page
	var multicolor=0;				// different colors for each level
	var LowSubBgColorArray=new Array("F86B03","1F828B","99CC33","6A2F57","787878","9F9F66") ;	// Background color Array when mouse is not over on subs
	var HighSubBgColorArray=new Array("eeeeee","1F828B","99CC33","6A2F57","787878","9F9F66") ;	// Background color Array  when mouse is over on subs

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}
function AfterCloseAll(){return}


		var NoOffFirstLineMenus=8; // Number of first level items
		Menu1=new Array("<img src='/PrivateLabel/BYSOWeb/Images/11.gif' border='0'>","","",11,30,116);Menu1_1=new Array("A Message from the Music Director","http://www.bysoweb.org/pages/3_a_message_from_the_music_director.cfm","",0,23,208);Menu1_2=new Array("BYSO Today","http://www.bysoweb.org/pages/174_byso_today.cfm","",0,23,208);Menu1_3=new Array("BYSO's History","http://www.bysoweb.org/pages/4_byso_s_history.cfm","",0,23,208);Menu1_4=new Array("Approaching our 50th Anniversary","http://www.bysoweb.org/pages/175_approaching_our_50th_anniversary.cfm","",0,23,208);Menu1_5=new Array("Boston University Affiliation","http://www.bysoweb.org/pages/5_boston_university_affiliation.cfm","",0,23,208);Menu1_6=new Array("Board of Directors","http://www.bysoweb.org/pages/6_board_of_directors.cfm","",0,23,208);Menu1_7=new Array("Artistic Staff","http://www.bysoweb.org/pages/7_artistic_staff.cfm","",0,23,208);Menu1_8=new Array("Administrative Staff","http://www.bysoweb.org/pages/8_administrative_staff.cfm","",0,23,208);Menu1_9=new Array("Jobs","http://www.bysoweb.org/pages/430_jobs.cfm","",0,23,208);Menu1_10=new Array("Contact Us","http://www.bysoweb.org/pages/9_contact_us.cfm","",0,23,208);Menu1_11=new Array("Photo Credits","http://www.bysoweb.org/pages/215_photo_credits.cfm","",0,23,208);Menu2=new Array("<img src='/PrivateLabel/BYSOWeb/Images/67.gif' border='0'>","","",11,30,122);Menu2_1=new Array("Our Programs","http://www.bysoweb.org/pages/218_our_programs.cfm","",0,23,196);Menu2_2=new Array("Boston Youth Symphony","http://www.bysoweb.org/pages/11_boston_youth_symphony.cfm","",0,23,196);Menu2_3=new Array("Repertory Orchestra","http://www.bysoweb.org/pages/12_repertory_orchestra.cfm","",0,23,196);Menu2_4=new Array("Junior Repertory Orchestra","http://www.bysoweb.org/pages/13_junior_repertory_orchestra.cfm","",0,23,196);Menu2_5=new Array("Young People's String Orchestra","http://www.bysoweb.org/pages/14_young_people_s_string_orchestra.cfm","",0,23,196);Menu2_6=new Array("Preparatory Wind Ensemble","http://www.bysoweb.org/pages/15_preparatory_wind_ensemble.cfm","",0,23,196);Menu2_7=new Array("Summer Camp","http://www.bysoweb.org/pages/16_summer_camp.cfm","",0,23,196);Menu2_8=new Array("International Tour","http://www.bysoweb.org/pages/17_international_tour.cfm","",2,23,196);Menu2_8_1=new Array("Senior Orchestra to Tour Spain and Portugal in June 2006","javascript:newwindow('http://www.bysoweb.org/download/35_tour_2006.pdf','content','width=,height=');","",0,41,270);Menu2_8_2=new Array("GBYSO tours Estonia, Latvia and Russia in June 2004","javascript:newwindow('http://www.bysoweb.org/download/39_2004_tour_release.pdf','content','width=,height=');","",0,41,270);Menu2_9=new Array("Chamber Music","http://www.bysoweb.org/pages/18_chamber_music.cfm","",0,23,196);Menu2_10=new Array("Intensive Community Program","http://www.bysoweb.org/pages/19_intensive_community_program.cfm","",0,23,196);Menu2_11=new Array("General Details","http://www.bysoweb.org/pages/81_general_details.cfm","",0,23,196);Menu3=new Array("<img src='/PrivateLabel/BYSOWeb/Images/34.gif' border='0'>","","",7,30,81);Menu3_1=new Array("Concerts","http://www.bysoweb.org/pages/21_concerts.cfm","",0,23,183);Menu3_2=new Array("Buy Tickets Now!","http://www.bysoweb.org/pages/338_buy_tickets_now_.cfm","",0,23,183);Menu3_3=new Array("2006-07 Season at a Glance","http://www.bysoweb.org/pages/302_2006_07_season_at_a_glance.cfm","",0,23,183);Menu3_4=new Array("Upcoming Concerts","http://www.bysoweb.org/","",0,23,183);Menu3_5=new Array("Ticket Information and Venues","http://www.bysoweb.org/pages/23_ticket_information_and_venues.cfm","",0,23,183);Menu3_6=new Array("Subscription Information","http://www.bysoweb.org/pages/24_subscription_information.cfm","",0,23,183);Menu3_7=new Array("Program Book Advertising","http://www.bysoweb.org/pages/25_program_book_advertising.cfm","",3,23,183);Menu3_7_1=new Array("2006-2007 Ad Rates","http://www.bysoweb.org/pages/207_2006_2007_ad_rates.cfm","",0,23,130);Menu3_7_2=new Array("List of Advertisers","http://www.bysoweb.org/pages/208_list_of_advertisers.cfm","",0,23,130);Menu3_7_3=new Array("Advertising Contract","javascript:newwindow('http://www.bysoweb.org/download/42_ad_contract_0607.pdf','content','width=,height=');","",0,23,130);Menu4=new Array("<img src='/PrivateLabel/BYSOWeb/Images/40.gif' border='0'>","","",9,30,78);Menu4_1=new Array("Ways to Give","http://www.bysoweb.org/pages/27_ways_to_give.cfm","",0,23,130);Menu4_2=new Array("Annual Fund","http://www.bysoweb.org/pages/28_annual_fund.cfm","",0,23,130);Menu4_3=new Array("Tribute Gifts","http://www.bysoweb.org/pages/31_tribute_gifts.cfm","",0,23,130);Menu4_4=new Array("Endowment Fund","http://www.bysoweb.org/pages/32_endowment_fund.cfm","",0,23,130);Menu4_5=new Array("Planned Gifts","http://www.bysoweb.org/pages/33_planned_gifts.cfm","",0,23,130);Menu4_6=new Array("Corporate Support","http://www.bysoweb.org/pages/34_corporate_support.cfm","",0,23,130);Menu4_7=new Array("In-Kind Donations","http://www.bysoweb.org/pages/35_in_kind_donations.cfm","",0,23,130);Menu4_8=new Array("Contact Us","http://www.bysoweb.org/pages/36_contact_us.cfm","",0,23,130);Menu4_9=new Array("Donate Now","http://www.bysoweb.org/pages/37_donate_now.cfm","",0,23,130);Menu5=new Array("<img src='/PrivateLabel/BYSOWeb/Images/51.gif' border='0'>","","",6,30,81);Menu5_1=new Array("Welcome","http://www.bysoweb.org/pages/39_welcome.cfm","",0,23,130);Menu5_2=new Array("Alumni News & Events","http://www.bysoweb.org/pages/40_alumni_news_events.cfm","",0,23,130);Menu5_3=new Array("Where Are They Now","http://www.bysoweb.org/pages/41_where_are_they_now.cfm","",0,23,130);Menu5_4=new Array("Online Exhibitions","http://www.bysoweb.org/pages/42_online_exhibitions.cfm","",0,23,130);Menu5_5=new Array("Alumni Support","http://www.bysoweb.org/pages/43_alumni_support.cfm","",0,23,130);Menu5_6=new Array("Contact Us","http://www.bysoweb.org/pages/44_contact_us.cfm","",0,23,130);Menu6=new Array("<img src='/PrivateLabel/BYSOWeb/Images/56.gif' border='0'>","","",1,30,68);Menu6_1=new Array("BYSO News","http://www.bysoweb.org/pages/46_byso_news.cfm","",0,23,130);Menu7=new Array("<img src='/PrivateLabel/BYSOWeb/Images/61.gif' border='0'>","","",4,30,104);Menu7_1=new Array("Auditions Welcome","http://www.bysoweb.org/pages/50_auditions_welcome.cfm","",0,23,177);Menu7_2=new Array("Audition Details","http://www.bysoweb.org/pages/51_audition_details.cfm","",0,23,177);Menu7_3=new Array("Audition Requirements","http://www.bysoweb.org/pages/52_audition_requirements.cfm","",0,23,177);Menu7_4=new Array("Audition Standard Repertoire","http://www.bysoweb.org/pages/53_audition_standard_repertoire.cfm","",0,23,177);Menu8=new Array("<img src='/PrivateLabel/BYSOWeb/Images/64.gif' border='0'>","","",19,30,88);Menu8_1=new Array("Season Schedule","http://www.bysoweb.org/pages/222_season_schedule.cfm","",0,23,227);Menu8_2=new Array("Weekly Rehearsal Schedule","http://www.bysoweb.org/pages/56_weekly_rehearsal_schedule.cfm","",0,23,227);Menu8_3=new Array("From the Top","http://www.bysoweb.org/pages/534_from_the_top.cfm","",0,23,227);Menu8_4=new Array("BYS String Parts","http://www.bysoweb.org/pages/519_bys_string_parts.cfm","",0,23,227);Menu8_5=new Array("Techmail","http://www.bysoweb.org/pages/57_techmail.cfm","",0,23,227);Menu8_6=new Array("Absence Form","http://www.bysoweb.org/pages/221_absence_form.cfm","",0,23,227);Menu8_7=new Array("CD Online Submission Form","http://www.bysoweb.org/pages/375_cd_online_submission_form.cfm","",0,23,227);Menu8_8=new Array("CD Order Forms","http://www.bysoweb.org/pages/298_cd_order_forms.cfm","",0,23,227);Menu8_9=new Array("Parents Committee Welcome Letter","http://www.bysoweb.org/pages/226_parents_committee_welcome_letter.cfm","",0,23,227);Menu8_10=new Array("Parent Committee Cookbook","http://www.bysoweb.org/pages/261_parent_committee_cookbook.cfm","",0,23,227);Menu8_11=new Array("Parent Committee Calendar","http://www.bysoweb.org/pages/62_parent_committee_calendar.cfm","",0,23,227);Menu8_12=new Array("Parent Committee Forms","http://www.bysoweb.org/pages/65_parent_committee_forms.cfm","",0,23,227);Menu8_13=new Array("Parent Hosted Dinners","http://www.bysoweb.org/pages/66_parent_hosted_dinners.cfm","",0,23,227);Menu8_14=new Array("Summer Music Programs","http://www.bysoweb.org/pages/67_summer_music_programs.cfm","",0,23,227);Menu8_15=new Array("Pursuit of Music After the BYSO","http://www.bysoweb.org/pages/68_pursuit_of_music_after_the_byso.cfm","",0,23,227);Menu8_16=new Array("Support through Amazon.com purchases","http://www.bysoweb.org/pages/69_support_through_amazon_com_purchases.cfm","",0,23,227);Menu8_17=new Array("Map to Symphony Hall","http://www.bysoweb.org/download/61_symphony_hall_map_and_directions.pdf","",0,23,227);Menu8_18=new Array("Concert Etiquette","http://www.bysoweb.org/download/98_concert_etiquette.pdf","",0,23,227);Menu8_19=new Array("Helpful Links for New Parents","http://www.bysoweb.org/pages/82_helpful_links_for_new_parents.cfm","",0,23,227);

/*********************************************************************************************************************************************
*	(c) Ger Versluis 2000 version 5 9 October 2001						*
*	You may use this script on non commercial sites.						*
*	For info write to menus@burmees.nl							*
*       This script featured on Dynamic Drive DHTML code library: http://www.dynamicdrive.com
**********************************************************************************************************************************************/

// Gobal variables	

	var AgntUsr=navigator.userAgent.toLowerCase();
	var DomYes=(document.getElementById)?1:0;
	var NavYes=(AgntUsr.indexOf('mozilla')!=-1&&AgntUsr.indexOf('compatible')==-1)?1:0;
	var ExpYes=(AgntUsr.indexOf('msie')!=-1)?1:0;
	var Opr5=(AgntUsr.indexOf('opera 5')!=-1||AgntUsr.indexOf('opera/5')!=-1)?1:0;
	var DomNav=(DomYes&&NavYes)?1:0;
 	var DomExp=(DomYes&&ExpYes)?1:0;
	var Nav4=(NavYes&&!DomYes&&document.layers)?1:0;
	var Exp4=(ExpYes&&!DomYes&&document.all)?1:0;
	var PosStrt=((NavYes||ExpYes)&&!Opr5)?1:0;

	var FrstLoc,ScLoc,DcLoc;
	var ScWinWdth,ScWinHght,FrstWinWdth,FrstWinHght;
	var ScLdAgainWin;
	var FirstColPos,SecColPos,DocColPos;
	var RcrsLvl=0;
	var FrstCreat=1,Loadd=0,Creatd=0,IniFlg,AcrssFrms=1;
	var FrstCntnr=null,CurrntOvr=null,CloseTmr=null;
	var CntrTxt,TxtClose,ImgStr;
	var Ztop=100;
	var ShwFlg=0;
	var M_StrtTp=StartTop,M_StrtLft=(NavYes)?StartLeftNS:StartLeft;
	var LftXtra=(DomNav)?LeftPaddng:0;
	var TpXtra=(DomNav)?TopPaddng:0;
	var M_Hide=(Nav4)?'hide':'hidden';
	var M_Show=(Nav4)?'show':'visible';
	var Par=(parent.frames[0]&&FirstLineFrame!=SecLineFrame)?parent:window;
	var Doc=Par.document;
	var Bod=Doc.body;
	var Trigger=(NavYes)?Par:Bod;

	MenuTextCentered=(MenuTextCentered==1||MenuTextCentered=='center')?'center':(MenuTextCentered==0||MenuTextCentered!='right')?'left':'right';
	WbMstrAlrts=["No such frame: ","Item not defined: ","Item needs height: ","Item needs width: ","Item Oke ","Menu tree oke"];

	if(Trigger.onload)Dummy=Trigger.onload;
	if(DomNav&&!Opr5)Trigger.addEventListener('load',Go,false);else Trigger.onload=Go;

function hideselect()
{
	var elmID = "SELECT";
	var x = 0;
	var y = 0;
	for (i = 0; i < document.all.tags(elmID).length; i++)
	{
		obj = document.all.tags(elmID)[i];
		if (! obj || ! obj.offsetParent)
			continue;

		// Find the element's offsetTop and offsetLeft relative to the BODY tag.
		objLeft   = obj.offsetLeft;
		objTop    = obj.offsetTop;
		objParent = obj.offsetParent;
		while (objParent.tagName.toUpperCase() != "BODY")
		{
			objLeft  += objParent.offsetLeft;
			objTop   += objParent.offsetTop;
			objParent = objParent.offsetParent;
		}
		// Adjust the element's offsetTop relative to the dropdown menu
		objTop = objTop - y;

		if (x > (objLeft + obj.offsetWidth) || objLeft > (x + this.offsetWidth))
			;
		else if (objTop > this.offsetHeight)
			;
		else if ((y + this.offsetHeight) <= 80)
			;
		else if (obj.name == 'sel_contentID')
			;
		else
			obj.style.visibility = "hidden";
	}
}
function displayselect()
{
var i = 0;
for (i = 0; i < document.forms[0].elements.length; i++) 
	{ 
		strTag=document.forms[0].elements.item(i).tagName;
	if (strTag == "SELECT") {
    	document.forms[0].elements.item(i).style.visibility = "visible";
		}
	}
}

function Dummy(){return}		// Executes user onload when found

function CnclSlct(){return false}		// Prevents text select on menu items.

function RePos(){			// Repositions menu after resize IE and NS6
	var FrstCntnrStyle=(!Nav4)?FrstCntnr.style:FrstCntnr;
	FrstWinWdth=(ExpYes)?FrstLoc.document.body.clientWidth:FrstLoc.innerWidth;
	FrstWinHght=(ExpYes)?FrstLoc.document.body.clientHeight:FrstLoc.innerHeight;
	ScWinWdth=(ExpYes)?ScLoc.document.body.clientWidth:ScLoc.innerWidth;
	ScWinHght=(ExpYes)?ScLoc.document.body.clientHeight:ScLoc.innerHeight;
	if(TargetLoc)ClcTrgt();
	if(MenuCentered)ClcLft();
	if(MenuVerticalCentered)ClcTp();
	PosMenu(FrstCntnr,StartTop,StartLeft)}

function UnLoaded(){			// Disables menu when document gets unloaded
	if(typeof(CloseTmr)!='undefined'&&CloseTmr)clearTimeout(CloseTmr);
	Loadd=0; Creatd=0;
	if(HideTop){
	var FCStyle=(Nav4)?FrstCntnr:FrstCntnr.style;
	FCStyle.visibility=M_Hide}}

function ReDoWhole(){		// Reloads after resize NS4 only
	if(ScWinWdth!=ScLoc.innerWidth||ScWinHght!=ScLoc.innerHeight||FrstWinWdth!=FrstLoc.innerWidth||FrstWinHght!=FrstLoc.innerHeight)
	Doc.location.reload()}

function Check(WMnu,NoOf){		// Checks menu tree
	var i,Hg,Wd,La,Li,Nof,array,ArrayLoc;
	ArrayLoc=(parent.frames[0])?parent.frames[FirstLineFrame]:self;
	for(i=0;i<NoOf;i++){
		array=WMnu+eval(i+1);
		if(!ArrayLoc[array]){WbMstrAlrt(1,array); return false}
		La=ArrayLoc[array][0]; Li=ArrayLoc[array][1]; Nof=ArrayLoc[array][3];
		if(i==0){	if(!ArrayLoc[array][4]){WbMstrAlrt(2,array); return false}
			if(!ArrayLoc[array][5]){WbMstrAlrt(3,array); return false}}
			Hg=ArrayLoc[array][4]; Wd=ArrayLoc[array][5];
		if(!WbMstrAlrt(4,'\n\n'+array+'\nwidth: '+Wd+'\nheight: '+Hg+'\nLabel: '+La+'\nLink: '+Li+'\nNo of sub items: '+Nof)){WebMasterCheck=0; return true}
		if(ArrayLoc[array][3])if(!Check(array+'_',ArrayLoc[array][3])) return false}
	return true}	

function WbMstrAlrt(No,Xtra){
	if(WebMasterCheck)return confirm(WbMstrAlrts[No]+Xtra+'   ')}

function Go(){			// Main function
	Dummy();
	if(Loadd||!PosStrt)return;
	BeforeStart();
	Creatd=0; Loadd=1;
	status='Building menu';
	if(FrstCreat){
		if(FirstLineFrame =="" || !parent.frames[FirstLineFrame]){WbMstrAlrt(0,FirstLineFrame); FirstLineFrame=SecLineFrame}
		if(FirstLineFrame =="" || !parent.frames[FirstLineFrame]){WbMstrAlrt(0,SecLineFrame); FirstLineFrame=SecLineFrame=DocTargetFrame}
		if(FirstLineFrame =="" || !parent.frames[FirstLineFrame]){WbMstrAlrt(0,DocTargetFrame); FirstLineFrame=SecLineFrame=DocTargetFrame=''}
		if(SecLineFrame =="" || !parent.frames[SecLineFrame])SecLineFrame=DocTargetFrame;
		if(SecLineFrame =="" || !parent.frames[SecLineFrame])SecLineFrame=DocTargetFrame=FirstLineFrame;
		if(DocTargetFrame =="" || !parent.frames[DocTargetFrame])DocTargetFrame=SecLineFrame;
		if(WebMasterCheck){if(!Check('Menu',NoOffFirstLineMenus))return;else WbMstrAlrt(5,'')}
		FrstLoc=(FirstLineFrame!="")?parent.frames[FirstLineFrame]:window;
		ScLoc=(SecLineFrame!="")?parent.frames[SecLineFrame]:window;
		DcLoc=(DocTargetFrame!="")?parent.frames[DocTargetFrame]:window;
		if (FrstLoc==ScLoc) AcrssFrms=0;
		if (AcrssFrms)FirstLineHorizontal=(MenuFramesVertical)?0:1;
		FrstWinWdth=(ExpYes)?FrstLoc.document.body.clientWidth:FrstLoc.innerWidth;
		FrstWinHght=(ExpYes)?FrstLoc.document.body.clientHeight:FrstLoc.innerHeight;
		ScWinWdth=(ExpYes)?ScLoc.document.body.clientWidth:ScLoc.innerWidth;
		ScWinHght=(ExpYes)?ScLoc.document.body.clientHeight:ScLoc.innerHeight;
		if(Nav4){CntrTxt=(MenuTextCentered!='left')?"<div align='"+MenuTextCentered+"'>":"";TxtClose="</font>"+(MenuTextCentered!='left')?"</div>":""}}
	FirstColPos=(Nav4)?FrstLoc.document:FrstLoc.document.body;
	SecColPos=(Nav4)?ScLoc.document:ScLoc.document.body;
	DocColPos=(Nav4)?DcLoc.document:ScLoc.document.body;
	if (TakeOverBgColor)FirstColPos.bgColor=(AcrssFrms)?SecColPos.bgColor:DocColPos.bgColor;
	if(FrstCreat){FrstCntnr=CreateMenuStructure('Menu',NoOffFirstLineMenus);
	FrstCreat=(AcrssFrms)?0:1}
	else CreateMenuStructureAgain('Menu',NoOffFirstLineMenus);
		if(TargetLoc)ClcTrgt();
		if(MenuCentered) ClcLft();
		if(MenuVerticalCentered) ClcTp();
	PosMenu(FrstCntnr,StartTop,StartLeft);
	IniFlg=1;Initiate();Creatd=1; 
	ScLdAgainWin=(ExpYes)?ScLoc.document.body:ScLoc;
	ScLdAgainWin.onunload=UnLoaded;
	//if(ExpYes)FrstLoc.document.body.onselectstart=CnclSlct;
	Trigger.onresize=(Nav4)?ReDoWhole:RePos;
	AfterBuild();
	status='Menu ready for use'}

function ClcTrgt(){			// Calculates StartTop and Left when positioning is relative
	var TLoc=(Nav4)?FrstLoc.document.layers[TargetLoc]:(DomYes)?FrstLoc.document.getElementById(TargetLoc):FrstLoc.document.all[TargetLoc];
	StartTop=M_StrtTp; StartLeft=M_StrtLft;
	StartTop+=(Nav4)?TLoc.pageY:TLoc.offsetTop;
	StartLeft+=(Nav4)?TLoc.pageX:TLoc.offsetLeft}

function ClcLft(){			// Calculates StartTop and Left when menu is centered
	if(MenuCentered!='left'){
		var Size=FrstWinWdth-((!Nav4)?parseInt(FrstCntnr.style.width):FrstCntnr.clip.width);
		StartLeft=M_StrtLft;
		StartLeft+=(MenuCentered=='right')?Size:Size/2}}

function ClcTp(){			// Calculates StartTop and Left when menu is centered
	if(MenuVerticalCentered!='top'){	
		var Size=FrstWinHght-((!Nav4)?parseInt(FrstCntnr.style.height):FrstCntnr.clip.height);
		StartTop=M_StrtTp;
		StartTop+=(MenuVerticalCentered=='bottom')?Size:Size/2}}

function PosMenu(CntnrPntr,Tp,Lt){	// Positions menu elements
	var Topi,Lefti,Hori;
	var Cntnr=CntnrPntr;
	var Mmbr=Cntnr.FrstMbr;
	var CntnrStyle=(!Nav4)?Cntnr.style:Cntnr;
	var MmbrStyle=(!Nav4)?Mmbr.style:Mmbr;
	var PadL=(Mmbr.value.indexOf('<')==-1)?LftXtra:0;
	var PadT=(Mmbr.value.indexOf('<')==-1)?TpXtra:0;
	var MmbrWt=(!Nav4)?parseInt(MmbrStyle.width)+PadL:MmbrStyle.clip.width;
	var MmbrHt=(!Nav4)?parseInt(MmbrStyle.height)+PadT:MmbrStyle.clip.height;
	var CntnrWt=(!Nav4)?parseInt(CntnrStyle.width):CntnrStyle.clip.width;
	var CntnrHt=(!Nav4)?parseInt(CntnrStyle.height):CntnrStyle.clip.height;
	var SubTp,SubLt;
	RcrsLvl++;
	if (RcrsLvl==1 && AcrssFrms)(!MenuFramesVertical)?Tp=FrstWinHght-CntnrHt+((Nav4)?4:0):Lt=(RightToLeft)?0:FrstWinWdth-CntnrWt+((Nav4)?4:0);
	if (RcrsLvl==2 && AcrssFrms)(!MenuFramesVertical)?Tp=0:Lt=(RightToLeft)?ScWinWdth-CntnrWt:0;
	if (RcrsLvl==2 && AcrssFrms){Tp+=VerCorrect;Lt+=HorCorrect}
	CntnrStyle.top=(RcrsLvl==1)?Tp:0;Cntnr.OrgTop=Tp;
	CntnrStyle.left=(RcrsLvl==1)?Lt:0;	Cntnr.OrgLeft=Lt;
	if (RcrsLvl==1 && FirstLineHorizontal){Hori=1; Lefti=CntnrWt-MmbrWt-2*BorderWidth;Topi=0}
	else{Hori=Lefti=0; Topi=CntnrHt-MmbrHt-2*BorderSubWidth}
	while(Mmbr!=null){
		PadL=(Mmbr.value.indexOf('<')==-1)?LftXtra:0;
		PadT=(Mmbr.value.indexOf('<')==-1)?TpXtra:0;
		MmbrStyle.left=Lefti+((RcrsLvl==1)?BorderWidth:BorderSubWidth);
		MmbrStyle.top=Topi+((RcrsLvl==1)?BorderWidth:BorderSubWidth);
		if(Nav4)Mmbr.CmdLyr.moveTo(Lefti+((RcrsLvl==1)?BorderWidth:BorderSubWidth),Topi+((RcrsLvl==1)?BorderWidth:BorderSubWidth));
		if(Mmbr.ChildCntnr){
			if(RightToLeft)ChldCntnrWdth=(Nav4)?Mmbr.ChildCntnr.clip.width:parseInt(Mmbr.ChildCntnr.style.width);
			if(Hori){	SubTp=Topi+MmbrHt+2*((RcrsLvl==1)?BorderWidth:BorderSubWidth); 
				SubLt=(RightToLeft)?Lefti+MmbrWt-ChldCntnrWdth:Lefti}
			else{	SubLt=(RightToLeft)?Lefti-ChldCntnrWdth+ChildOverlap*MmbrWt+BorderSubWidth:Lefti+(1-ChildOverlap)*MmbrWt+BorderSubWidth; 
				SubTp=(RcrsLvl==1&&AcrssFrms)?Topi:Topi+ChildVerticalOverlap*MmbrHt}
			PosMenu(Mmbr.ChildCntnr,SubTp,SubLt)}
			Mmbr=Mmbr.PrvMbr;
		if(Mmbr){	MmbrStyle=(!Nav4)?Mmbr.style:Mmbr;
			MmbrWt=(!Nav4)?parseInt(MmbrStyle.width)+PadL:MmbrStyle.clip.width;
			MmbrHt=(!Nav4)?parseInt(MmbrStyle.height)+PadT:MmbrStyle.clip.height;
			(Hori)?Lefti-=((RcrsLvl==1)?BorderBtwnElmnts:BorderBtwnSubElmnts)?(MmbrWt+BorderSubWidth):(MmbrWt):Topi-=((RcrsLvl==1)?BorderBtwnElmnts:BorderBtwnSubElmnts)?(MmbrHt+BorderSubWidth):(MmbrHt)}}
	RcrsLvl--}

function Initiate(){			// Resets menu's visiblity
	if(IniFlg){Init(FrstCntnr);IniFlg=0;if(ShwFlg)AfterCloseAll();ShwFlg=0}}

function Init(CntnrPntr){
	var Mmbr=CntnrPntr.FrstMbr;
	var MCStyle=(Nav4)?CntnrPntr:CntnrPntr.style;
	RcrsLvl++;
	MCStyle.visibility=(RcrsLvl==1)?M_Show:M_Hide;
	CntnrPntr.Sflg=(RcrsLvl==1)?1:0;
	while(Mmbr!=null){
		if(Mmbr.ChildCntnr) Init(Mmbr.ChildCntnr);
		Mmbr=Mmbr.PrvMbr}
	RcrsLvl--}

function ClearAllChilds(Pntr,ChldPntr){	// Hides no longer wanted elements
	var CPCCStyle;
	while (Pntr){
		if(Pntr.ChildCntnr&&Pntr.ChildCntnr.Sflg){
			CPCCStyle=(Nav4)?Pntr.ChildCntnr:Pntr.ChildCntnr.style;
			if(Pntr.ChildCntnr!=ChldPntr){CPCCStyle.visibility=M_Hide;Pntr.ChildCntnr.Sflg=0}
			ClearAllChilds(Pntr.ChildCntnr.FrstMbr,ChldPntr)}
		Pntr=Pntr.PrvMbr}}	

function GoTo(){			// Triggered by mouse click
	if(this.LinkTxt){
		status=''; 
		if(Nav4){if(this.LowLyr.LoBck)this.LowLyr.bgColor=this.LowLyr.LoBck;if(this.LowLyr.value.indexOf('<img')==-1){this.LowLyr.document.write(this.LowLyr.value);this.LowLyr.document.close()}}
		else{if(this.LoBck)this.style.backgroundColor=this.LoBck; if(this.LwFntClr)this.style.color=this.LwFntClr}
		(this.LinkTxt.indexOf('javascript:')!=-1)?eval(this.LinkTxt):DcLoc.location.href=this.LinkTxt}}

function OpenMenu(){			// Triggered by mouse over
	if(ExpYes && hidepicklist){hideselect();}
	if(!Loadd||!Creatd) return;
	var TpScrlld=(ExpYes)?ScLoc.document.body.scrollTop:ScLoc.pageYOffset;
	var LScrlld=(ExpYes)?ScLoc.document.body.scrollLeft:ScLoc.pageXOffset;
	var CCnt=(Nav4)?this.LowLyr.ChildCntnr:this.ChildCntnr;
	var ThisHt=(Nav4)?this.clip.height:parseInt(this.style.height);
	var ThisWt=(Nav4)?this.clip.width:parseInt(this.style.width);
	var ThisLft=(AcrssFrms&&this.Level==1&&!FirstLineHorizontal)?0:(Nav4)?this.Container.left:parseInt(this.Container.style.left);
	var ThisTp=(AcrssFrms&&this.Level==1&&FirstLineHorizontal)?0:(Nav4)?this.Container.top:parseInt(this.Container.style.top);
	var CRoll=(Nav4)?this.LowLyr.ro:this.ro;
	CurrntOvr=this; IniFlg=0;
	ClearAllChilds(this.Container.FrstMbr,CCnt);
	if(CRoll){	if(Nav4)this.LowLyr.document.images[this.LowLyr.rid].src=this.LowLyr.ri2;
		else {var Lc=(this.Level==1)?FrstLoc:ScLoc;Lc.document.images[this.rid].src=this.ri2}}
	else{	if(Nav4){if(this.LowLyr.HiBck)this.LowLyr.bgColor=this.LowLyr.HiBck;if(this.LowLyr.value.indexOf('<img')==-1){this.LowLyr.document.write(this.LowLyr.Ovalue);this.LowLyr.document.close()}}
		else{if(this.HiBck)this.style.backgroundColor=this.HiBck;if(this.HiFntClr)this.style.color=this.HiFntClr}}
	if(CCnt!=null){
		if(!ShwFlg){ShwFlg=1;BeforeFirstOpen()}
		CCnt.Sflg=1;
		var CCW=(Nav4)?this.LowLyr.ChildCntnr.clip.width:parseInt(this.ChildCntnr.style.width);
		var CCH=(Nav4)?this.LowLyr.ChildCntnr.clip.height:parseInt(this.ChildCntnr.style.height);
		var ChCntTL=(Nav4)?this.LowLyr.ChildCntnr:this.ChildCntnr.style;
		var SubLt=(AcrssFrms&&this.Level==1)?CCnt.OrgLeft+ThisLft+LScrlld:CCnt.OrgLeft+ThisLft;
		var SubTp=(AcrssFrms&&this.Level==1)?CCnt.OrgTop+ThisTp+TpScrlld:CCnt.OrgTop+ThisTp;
		if(MenuWrap){
			if(RightToLeft){if(SubLt<LScrlld)SubLt=(this.Level==1)?LScrlld:SubLt+(CCW+(1-2*ChildOverlap)*ThisWt);
				if(SubLt+CCW>ScWinWdth+LScrlld)SubLt=ScWinWdth+LScrlld-CCW}
			else{	if(SubLt+CCW>ScWinWdth+LScrlld)SubLt=(this.Level==1)?ScWinWdth+LScrlld-CCW:SubLt-(CCW+(1-2*ChildOverlap)*ThisWt);
				if(SubLt<LScrlld)SubLt=LScrlld}
			if(SubTp+CCH>TpScrlld+ScWinHght)SubTp=(this.Level==1)?SubTp=TpScrlld+ScWinHght-CCH:SubTp-CCH+(1-2*ChildVerticalOverlap)*ThisHt;
			if(SubTp<TpScrlld)SubTp=TpScrlld}
		ChCntTL.top=SubTp;ChCntTL.left=SubLt;ChCntTL.visibility=M_Show}
	status=this.LinkTxt}	

function OpenMenuClick(){			// Triggered by mouse over
	if(!Loadd||!Creatd) return;
	var CCnt=(Nav4)?this.LowLyr.ChildCntnr:this.ChildCntnr;
	var CRoll=(Nav4)?this.LowLyr.ro:this.ro;
	CurrntOvr=this; IniFlg=0;
	ClearAllChilds(this.Container.FrstMbr,CCnt);
	if(CRoll){	if(Nav4)this.LowLyr.document.images[this.LowLyr.rid].src=this.LowLyr.ri2;
		else {var Lc=(this.Level==1)?FrstLoc:ScLoc;Lc.document.images[this.rid].src=this.ri2}}
	else{	if(Nav4){if(this.LowLyr.HiBck)this.LowLyr.bgColor=this.LowLyr.HiBck;if(this.LowLyr.value.indexOf('<img')==-1){this.LowLyr.document.write(this.LowLyr.Ovalue);this.LowLyr.document.close()}}
		else{if(this.HiBck)this.style.backgroundColor=this.HiBck;if(this.HiFntClr)this.style.color=this.HiFntClr}}
	status=this.LinkTxt}	

function CloseMenu(){		// Triggered by mouse out
	if(ExpYes && hidepicklist==1){displayselect();}
	if(!Loadd||!Creatd) return;
	var CRoll=(Nav4)?this.LowLyr.ro:this.ro;
	if(CRoll){	if(Nav4)this.LowLyr.document.images[this.LowLyr.rid].src=this.LowLyr.ri1;
		else {var Lc=(this.Level==1)?FrstLoc:ScLoc;Lc.document.images[this.rid].src=this.ri1}}
	else{	if(Nav4){if(this.LowLyr.LoBck)this.LowLyr.bgColor=this.LowLyr.LoBck;if(this.LowLyr.value.indexOf('<img')==-1){this.LowLyr.document.write(this.LowLyr.value);this.LowLyr.document.close()}}
		else{if(this.LoBck)this.style.backgroundColor=this.LoBck;if(this.LwFntClr)this.style.color=this.LwFntClr}}
	status='';
	if(this==CurrntOvr){IniFlg=1;if (CloseTmr) clearTimeout(CloseTmr);CloseTmr=setTimeout('Initiate(CurrntOvr)',DissapearDelay)}}

function CntnrSetUp(Wdth,Hght,NoOff){	// Sets up layer that holds group of elements
	var x=(RcrsLvl==1)?BorderColor:BorderSubColor;
	this.FrstMbr=null;
	this.OrgLeft=this.OrgTop=0;
	this.Sflg=0;
	if(x)this.bgColor=x;
	if(Nav4){this.visibility='hide';this.resizeTo(Wdth,Hght)}
	else{if(x)this.style.backgroundColor=x;
		this.style.width=Wdth;
		this.style.height=Hght;
		this.style.fontFamily=FontFamily;
		this.style.fontWeight=(FontBold)?'bold':'normal';
		this.style.fontStyle=(FontItalic)?'italic':'normal';
		this.style.fontSize=FontSize+'pt';
		this.style.zIndex=RcrsLvl+Ztop}}

function MbrSetUp(MmbrCntnr,PrMmbr,WhatMenu,Wdth,Hght){ // Sets up element IE & NS6
	var Location=(RcrsLvl==1)?FrstLoc:ScLoc;
	var MemVal=eval(WhatMenu+'[0]');
	var t,T,L,W,H,S;
	var a,b,c,d;
	this.PrvMbr=PrMmbr;
	this.Level=RcrsLvl;
	this.LinkTxt=eval(WhatMenu+'[1]');
	this.Container=MmbrCntnr;
	this.ChildCntnr=null;
	this.style.overflow='hidden';
	this.style.cursor=(ExpYes&&(this.LinkTxt||(RcrsLvl==1&&UnfoldsOnClick)))?'hand':'default';
	this.ro=0;
	if(MemVal.indexOf('rollover')!=-1){
		this.ro=1;this.ri1=MemVal.substring(MemVal.indexOf(':')+1,MemVal.lastIndexOf(':'));
		this.ri2=MemVal.substring(MemVal.lastIndexOf(':')+1,MemVal.length);
		this.rid=WhatMenu+'i';MemVal="<img src='"+this.ri1+"' name='"+this.rid+"'>"}
	this.value=MemVal;
	if(RcrsLvl==1){a=LowBgColor; b=HighBgColor; c=FontLowColor; d=FontHighColor}
	else if(multicolor==1){var startAt=WhatMenu.indexOf('_')-1;var endAt=startAt+1;var colorIndex=(WhatMenu.substring(startAt,endAt)>LowSubBgColorArray.length)?0:WhatMenu.substring(startAt,endAt)-1;a=LowSubBgColorArray[colorIndex]; b=HighSubBgColor; c=FontSubLowColor; d=FontSubHighColor}
	else {a=LowSubBgColor; b=HighSubBgColor; c=FontSubLowColor; d=FontSubHighColor}
	this.LoBck=a;
	this.LwFntClr=c;
	this.HiBck=b;
	this.HiFntClr=d; 
	this.style.color=this.LwFntClr;
	if(this.LoBck)this.style.backgroundColor=this.LoBck;
	this.style.textAlign=MenuTextCentered;
	if(eval(WhatMenu+'[2]'))this.style.backgroundImage="url(\'"+eval(WhatMenu+'[2]')+"\')";
	if(MemVal.indexOf('<')==-1){this.style.width=Wdth-LftXtra;this.style.height=Hght-TpXtra;
		this.style.paddingLeft=LeftPaddng;this.style.paddingTop=TopPaddng}
	else{	this.style.width=Wdth; this.style.height=Hght}
	if(MemVal.indexOf('<')==-1&&DomYes){t=Location.document.createTextNode(MemVal);this.appendChild(t)}
	else this.innerHTML=MemVal;
	if(eval(WhatMenu+'[3]')){
		
		S=(RcrsLvl==1&&FirstLineHorizontal)?'/PrivateLabel/BYSOWeb/Images/tridown.gif':(RightToLeft)?'/PrivateLabel/BYSOWeb/Images/trileft.gif':'/PrivateLabel/BYSOWeb/Images/tri.gif';
		
		W=(RcrsLvl==1&&FirstLineHorizontal)?17:17;
		H=(RcrsLvl==1&&FirstLineHorizontal)?9:9;
		T=(RcrsLvl==1&&FirstLineHorizontal)?Hght-11:Hght/2-2;
		L=(RcrsLvl==1&&FirstLineHorizontal)?Wdth-12:Wdth-11;
		if(DomYes){t=Location.document.createElement('img'); this.appendChild(t); t.style.position='absolute'; t.src=S; t.style.width=W; t.style.height=H; t.style.top=T; t.style.left=L}
		else{MemVal+="<div style='position:absolute; top:"+T+"; left:"+L+"; width:"+W+"; height:"+H+";visibility:inherit'><img src='"+S+"'></div>"; this.innerHTML=MemVal}}
	if(ExpYes){
		this.onmouseover=(RcrsLvl==1&&UnfoldsOnClick)?OpenMenuClick:OpenMenu;
		this.onmouseout=CloseMenu; 
		this.onclick=(RcrsLvl==1&&UnfoldsOnClick&&eval(WhatMenu+'[3]'))?OpenMenu:GoTo}
	else{
		(RcrsLvl==1&&UnfoldsOnClick)?this.addEventListener('mouseover',OpenMenuClick,false):this.addEventListener('mouseover',OpenMenu,false); 
		this.addEventListener('mouseout',CloseMenu,false); 
		(RcrsLvl==1&&UnfoldsOnClick&&eval(WhatMenu+'[3]'))?this.addEventListener('click',OpenMenu,false):this.addEventListener('click',GoTo,false)}}

function NavMbrSetUp(MmbrCntnr,PrMmbr,WhatMenu,Wdth,Hght){ // Sets up element IE & NS6
	var a,b,c,d;
	if(RcrsLvl==1){a=LowBgColor; b=HighBgColor; c=FontLowColor; d=FontHighColor}
	else if(multicolor==1){var startAt=WhatMenu.indexOf('_')-1;var endAt=startAt+1;var colorIndex=(WhatMenu.substring(startAt,endAt)>LowSubBgColorArray.length)?0:WhatMenu.substring(startAt,endAt)-1;a=LowSubBgColorArray[colorIndex]; b=HighSubBgColor; c=FontSubLowColor; d=FontSubHighColor}
	else {a=LowSubBgColor; b=HighSubBgColor; c=FontSubLowColor; d=FontSubHighColor}
	this.value=eval(WhatMenu+'[0]');
	this.ro=0;
	if(this.value.indexOf('rollover')!=-1){
		this.ro=1;this.ri1=this.value.substring(this.value.indexOf(':')+1,this.value.lastIndexOf(':'));
		this.ri2=this.value.substring(this.value.lastIndexOf(':')+1,this.value.length);
		this.rid=WhatMenu+'i';this.value="<img src='"+this.ri1+"' name='"+this.rid+"'>"}
	if(LeftPaddng&&this.value.indexOf('<')==-1&&MenuTextCentered=='left')this.value='&nbsp\;'+this.value;
	if(FontBold)this.value=this.value.bold();
	if(FontItalic)this.value=this.value.italics();
	this.Ovalue=this.value;
	this.value=this.value.fontcolor(c);
	this.Ovalue=this.Ovalue.fontcolor(d);
	this.value=CntrTxt+"<font face='"+FontFamily+"' point-size='"+FontSize+"'>"+this.value+TxtClose;
	this.Ovalue=CntrTxt+"<font face='"+FontFamily+"' point-size='"+FontSize+"'>"+this.Ovalue+TxtClose;
	this.LoBck=a;
	this.HiBck=b;
	this.ChildCntnr=null;
	this.PrvMbr=PrMmbr;
	this.visibility='inherit';
	if(this.LoBck)this.bgColor=this.LoBck;
	this.resizeTo(Wdth,Hght);
	if(!AcrssFrms&&eval(WhatMenu+'[2]'))this.background.src=eval(WhatMenu+'[2]');
	this.document.write(this.value);
	this.document.close();
	this.CmdLyr=new Layer(Wdth,MmbrCntnr);
	this.CmdLyr.Level=RcrsLvl;
	this.CmdLyr.LinkTxt=eval(WhatMenu+'[1]');
	this.CmdLyr.visibility='inherit';
	this.CmdLyr.onmouseover=(RcrsLvl==1&&UnfoldsOnClick)?OpenMenuClick:OpenMenu;
	this.CmdLyr.onmouseout=CloseMenu;
	this.CmdLyr.captureEvents(Event.MOUSEUP);
	this.CmdLyr.onmouseup=(RcrsLvl==1&&UnfoldsOnClick&&eval(WhatMenu+'[3]'))?OpenMenu:GoTo;
	this.CmdLyr.LowLyr=this;
	this.CmdLyr.resizeTo(Wdth,Hght);
	this.CmdLyr.Container=MmbrCntnr;
	if(eval(WhatMenu+'[3]')){
		this.CmdLyr.ImgLyr=new Layer(10,this.CmdLyr);
		this.CmdLyr.ImgLyr.visibility='inherit';
		this.CmdLyr.ImgLyr.top=(RcrsLvl==1&&FirstLineHorizontal)?Hght-11:Hght/2-2;
		this.CmdLyr.ImgLyr.left=(RcrsLvl==1&&FirstLineHorizontal)?Wdth-12:Wdth-11;
		this.CmdLyr.ImgLyr.width=(RcrsLvl==1&&FirstLineHorizontal)?7:13;
		this.CmdLyr.ImgLyr.height=(RcrsLvl==1&&FirstLineHorizontal)?15:5;
		ImgStr=(RcrsLvl==1&&FirstLineHorizontal)?"<img src='/PrivateLabel/BYSOWeb/Images/tridown.gif'>":(RightToLeft)?"<img src='/PrivateLabel/BYSOWeb/Images/trileft.gif'>":"<img src='/PrivateLabel/BYSOWeb/Images/tri.gif'>";
		this.CmdLyr.ImgLyr.document.write(ImgStr);
		this.CmdLyr.ImgLyr.document.close()}}

function CreateMenuStructure(MName,NumberOf){
	RcrsLvl++;
	var i,NoOffSubs,Mbr,Wdth=0,Hght=0;
	var PrvMmbr=null;
	var WMnu=MName+'1';
	var MenuWidth=eval(WMnu+'[5]');
	var MenuHeight=eval(WMnu+'[4]');
	var Location=(RcrsLvl==1)?FrstLoc:ScLoc;
	if (RcrsLvl==1&&FirstLineHorizontal){
		for(i=1;i<NumberOf+1;i++){WMnu=MName+eval(i);Wdth=(eval(WMnu+'[5]'))?Wdth+eval(WMnu+'[5]'):Wdth+MenuWidth}
		Wdth=(BorderBtwnElmnts)?Wdth+(NumberOf+1)*BorderWidth:Wdth+2*BorderWidth;Hght=MenuHeight+2*BorderWidth}
	else{	for(i=1;i<NumberOf+1;i++){WMnu=MName+eval(i);Hght=(eval(WMnu+'[4]'))?Hght+eval(WMnu+'[4]'):Hght+MenuHeight}
		Hght=((RcrsLvl==1)?BorderBtwnElmnts:BorderBtwnSubElmnts)?Hght+(NumberOf+1)*BorderSubWidth:Hght+2*BorderSubWidth;Wdth=MenuWidth+2*BorderSubWidth}
	if(DomYes){
		var MmbrCntnr=Location.document.createElement("div");
		MmbrCntnr.style.position='absolute';
		MmbrCntnr.style.visibility='hidden';
		if (RcrsLvl!=1)MmbrCntnr.style.filter='alpha(opacity='+Transparency+')';
		Location.document.body.appendChild(MmbrCntnr)}
	else	if(Nav4) var MmbrCntnr=new Layer(Wdth,Location)
		else{	WMnu+='c';
			Location.document.body.insertAdjacentHTML("AfterBegin","<div id='"+WMnu+"' style='visibility:hidden; position:absolute;'><\/div>"); 
			var MmbrCntnr=Location.document.all[WMnu]}
	MmbrCntnr.SetUp=CntnrSetUp;
	MmbrCntnr.SetUp(Wdth,Hght,NumberOf);
	if(Exp4){	MmbrCntnr.InnerString='';
		for(i=1;i<NumberOf+1;i++){
			WMnu=MName+eval(i);
			MmbrCntnr.InnerString+="<div id='"+WMnu+"' style='position:absolute;'><\/div>"}
		MmbrCntnr.innerHTML=MmbrCntnr.InnerString}
	for(i=1;i<NumberOf+1;i++){
		WMnu=MName+eval(i);
		NoOffSubs=eval(WMnu+'[3]');
		Wdth=(RcrsLvl==1&&FirstLineHorizontal)?(eval(WMnu+'[5]'))?eval(WMnu+'[5]'):MenuWidth:MenuWidth;
		Hght=(RcrsLvl==1&&FirstLineHorizontal)?MenuHeight:(eval(WMnu+'[4]'))?eval(WMnu+'[4]'):MenuHeight;
		if(DomYes){Mbr=Location.document.createElement("div");
			Mbr.style.position='absolute';
			Mbr.style.visibility='inherit';
			MmbrCntnr.appendChild(Mbr)}
		else Mbr=(Nav4)?new Layer(Wdth,MmbrCntnr):Location.document.all[WMnu];
		Mbr.SetUp=(Nav4)?NavMbrSetUp:MbrSetUp;
		Mbr.SetUp(MmbrCntnr,PrvMmbr,WMnu,Wdth,Hght);
		if(NoOffSubs) Mbr.ChildCntnr=CreateMenuStructure(WMnu+'_',NoOffSubs);
		PrvMmbr=Mbr}
	MmbrCntnr.FrstMbr=Mbr;
	RcrsLvl--;
	return(MmbrCntnr)}

function CreateMenuStructureAgain(MName,NumberOf){
	var i,WMnu,NoOffSubs;
	var PrvMmbr,Mbr=FrstCntnr.FrstMbr;
	RcrsLvl++;
	for(i=NumberOf;i>0;i--){
		WMnu=MName+eval(i);
		NoOffSubs=eval(WMnu+'[3]');
		PrvMmbr=Mbr;
		if(NoOffSubs)Mbr.ChildCntnr=CreateMenuStructure(WMnu+'_',NoOffSubs);
		Mbr=Mbr.PrvMbr}
	RcrsLvl--}

