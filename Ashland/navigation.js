	var NoOffFirstLineMenus=11;			// Number of first level items
	var LowBgColor='#230E4F';			// Background color when mouse is not over
	var LowSubBgColor='white';			// Background color when mouse is not over on subs
	var HighBgColor='#230E4F';			// Background color when mouse is over
	var HighSubBgColor='#230E4F';			// Background color when mouse is over on subs
	var FontLowColor='white';			// Font color when mouse is not over
	var FontSubLowColor='#230E4F';			// Font color subs when mouse is not over
	var FontHighColor='white';			// Font color when mouse is over
	var FontSubHighColor='white';			// Font color subs when mouse is over
	var BorderColor='#230E4F';			// Border color
	var BorderSubColor='#230E4F';			// Border color for subs
	var BorderWidth=1;				// Border width
	var BorderBtwnElmnts=1;			// Border between elements 1 or 0
	var FontFamily="sans-serif"	// Font family menu items
	var FontSize="12px";				// Font size menu items
	var FontSizeNav="9";				// Pixel size for Netscape 4.x browsers
	var FontBold=0;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered='left';			// Item text position 'left', 'center' or 'right'
	var MenuCentered='center';			// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';		// Menu vertical position 'top', 'middle','bottom' or static
	var ChildOverlap=0;				// horizontal overlap child/ parent
	var ChildVerticalOverlap=0;			// vertical overlap child/ parent
	var StartTop=10;				// Menu offset x coordinate
	var StartLeft=-5;				// Menu offset y coordinate
	var VerCorrect=0;				// Multiple frames y correction
	var HorCorrect=2;				// Multiple frames x correction
	var LeftPaddng=2;				// Left padding
	var TopPaddng=1;				// Top padding
	var FirstLineHorizontal=1;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
	var MenuFramesVertical=1;			// Frames in cols or rows 1 or 0
	var DissapearDelay=800;			// delay before menu folds in
	var TakeOverBgColor=0;			// Menu frame takes over background color subitem frame
	var FirstLineFrame='navig';			// Frame where first level appears
	var SecLineFrame='space';			// Frame where sub levels appear
	var DocTargetFrame='space';			// Frame where target documents appear
	var TargetLoc='MenuPos';				// span id for relative positioning
	var HideTop=0;				// Hide first level when loading new document 1 or 0
	var MenuWrap=1;				// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;			// Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;			// menu tree checking on or off 1 or 0
	var ShowArrow=1;				// Uses arrow gifs when 1
	var KeepHilite=1;				// Keep selected path highligthed
	var Arrws=['/PrivateLabel/Ashland/images/arrow-right.gif',5,10,'/PrivateLabel/Ashland/images/arrow.gif',9,10,'/PrivateLabel/Ashland/images/arrow.gif',9,10];	// Arrow source, width and height

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}
function AfterCloseAll(){return}

//	MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//	For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"

Menu1=new Array("Prospective Students","","",7,16,136);
	Menu1_1=new Array("This is AU","http://www3.ashland.edu/about/index.html","",0,16,179);	
	Menu1_2=new Array("Campus Visits","","",4);
		Menu1_2_1=new Array("Area Hotels", "http://www3.ashland.edu/about/areahotels.html","",0,16,150);	
		Menu1_2_2=new Array("Directions to Ashland University", "http://www3.ashland.edu/about/directions.html","",0);
		Menu1_2_3=new Array("Campus Map", "http://www.ashland.edu/admission/map_index.html","",0);
		Menu1_2_4=new Array("Virtual Tour", "http://www.ashland.edu/admission/tour_index.html","",0);
	Menu1_3=new Array("Majors","http://www3.ashland.edu/academics/","",0);
//	Menu1_4=new Array("Meet The Faculty", "http://www3.ashland.edu/academics/facultyProfiles.php","",0);
	Menu1_4=new Array("Athletics","http://www.ashland.edu/athletics","",0);
	Menu1_5=new Array("Admissions","http://www.ashland.edu/admission/ugradadmin.html","",0);
	Menu1_6=new Array("Graduate Programs","http://www3.ashland.edu/academics/graduatePrograms.html","",5);
		Menu1_6_1=new Array("Seminary","http://www.ashland.edu/seminary/","",0,16,198);
		Menu1_6_2=new Array("Bachelor's Plus Program", "http://www.ashland.edu/colleges/education/bachplus.html","",0);
		Menu1_6_3=new Array("Doctor of Education", "http://www.ashland.edu/colleges/education/ded/ded.html","",0);
		Menu1_6_4=new Array("Master of Education", "http://www.ashland.edu/colleges/education/med/med.html","",0);
		Menu1_6_5=new Array("Master of Business Administration", "http://www.ashland.edu/colleges/business/mba/mbahome.html","",0);
	Menu1_7=new Array("International Student Services", "http://www.ashland.edu/iss/","",0);
Menu2=new Array("","","",0,16,9);
Menu3=new Array("Current Students","","",9,16,113);
	Menu3_1=new Array("WebAdvisor","http://www.ashland.edu/webadv_browser.html","",0,16,160);
	Menu3_2=new Array("EagleWeb","http://eagleweb.ashland.edu","",0);	
	Menu3_3=new Array("Academic Programs", "http://www3.ashland.edu/academics/","",0);
	Menu3_4=new Array("WebCT - Online Courses","http://orion.ashland.edu:8900/webct/public/home.pl","",0);	
	Menu3_5=new Array("Athletics", "http://www.ashland.edu/athletics/","",0);
	Menu3_6=new Array("Campus Life","http://www3.ashland.edu/about/campuslife.html","",5);
		Menu3_6_1=new Array("Residence Life", "http://www.ashland.edu/reslife/reslife.html","",0,16,140);
		Menu3_6_2=new Array("Religious Life", "http://www.ashland.edu/rellife/index.html","",0);
		Menu3_6_3=new Array("Student Activities", "http://www.ashland.edu/stuact/stuact.htm","",0);
		Menu3_6_4=new Array("Student Affairs", "http://www.ashland.edu/stuaff/stdaff.html","",0);
		Menu3_6_5=new Array("Dining on Campus", "http://www3.ashland.edu/stuserv/dining/index.php","",0);
	Menu3_7=new Array("Services & Information","","",10);
		Menu3_7_1=new Array("Bookstore","http://www.ashland.edu/bookstore/bookhome.html","",0,16,180);
		Menu3_7_2=new Array("Career Development Center", "http://www.ashland.edu/cardev/cardev.html","",0);
		Menu3_7_3=new Array("Consumer Information", "http://www3.ashland.edu/about/consumerInfo.html","",0);
		Menu3_7_4=new Array("Financial Aid", "http://www.ashland.edu/finaid/finaidhome.html","",0);
		Menu3_7_5=new Array("Library", "http://www.ashland.edu/library/","",0);
		Menu3_7_6=new Array("Health Center", "http://www.ashland.edu/stuaff/Health/health.htm","",0);
		Menu3_7_7=new Array("Information Technology", "http://tech.ashland.edu/","",0);
		Menu3_7_8=new Array("International Student Services", "http://www.ashland.edu/iss/","",0);
		Menu3_7_9=new Array("Safety Services", "http://www.ashland.edu/stuserv/safser.html","",0);
		Menu3_7_10=new Array("Writing Center", "http://www.ashland.edu/stuserv/writing/wcent.html","",0);
	Menu3_8=new Array("Opportunities","","",2);
		Menu3_8_1=new Array("Study Abroad", "http://www.ashland.edu/cardev/cdc/abroad/mission.html","",0,16,160);
		Menu3_8_2=new Array("Tour the World with AU", "http://www3.ashland.edu/about/tourtheworld.html","",0);
	Menu3_9=new Array("News & Events","","",3);
		Menu3_9_1=new Array("News Releases", "http://www.ashland.edu/news2.html","",0,16,150);
		Menu3_9_2=new Array("Commencement", "http://www3.ashland.edu/about/commencement/","",0);
		//Menu3_9_2=new Array("Institutional Newsletter", "http://www3.ashland.edu/journals/aunews.html","",0);
		Menu3_9_3=new Array("Events Calendar", "http://calendar.ashland.edu","",0);
		//Menu3_9_3=new Array("Pine Whispers Yearbook", "http://www.ashland.edu/stuact/PineWhispers/pw_index.html","",0);
Menu4=new Array("","","",0,16,9);
Menu5=new Array("Alumni & Parents","","",8,16,112);
	Menu5_1=new Array("Alumni & Parent Programs", "http://www.ashland.edu/alumni/alumni.htm","",0,16,190);
	Menu5_2=new Array("Make A Contribution", "http://www.ashland.edu/develop/develop.htm","",4);
		Menu5_2_1=new Array("Office of Development", "http://www.ashland.edu/develop/develop.htm","",0,16,185);
 		Menu5_2_2=new Array("Annual Fund", "http://www.ashland.edu/alumni/fund.htm","",0); 
 		Menu5_2_3=new Array("Building on Strength Campaign", "http://www.ashland.edu/develop/Campaign.htm","",0); 
 		Menu5_2_4=new Array("Estate Programs", "http://www.ashland.edu/estate/legacy.htm","",0); 
	Menu5_3=new Array("Bookstore","http://www.ashland.edu/bookstore/bookhome.html","",0);
	Menu5_4=new Array("Commencement", "http://www3.ashland.edu/about/commencement/","",0);
 	Menu5_5=new Array("Pine Whispers Yearbook", "http://www.ashland.edu/stuact/PineWhispers/pw_index.html","",0);
 	Menu5_6=new Array("Request Admissions Information", "http://www.ashland.edu/admission/infofrm_index.html","",0); 
 	Menu5_7=new Array("Request Transcripts", "http://www.ashland.edu/colleges/transcrpt.html","",0); 
	Menu5_8=new Array("News & Events","","",2);
		Menu5_8_1=new Array("News Releases", "http://www.ashland.edu/news2.html","",0,16,140);
		//Menu5_8_2=new Array("Institutional Newsletter", "http://www3.ashland.edu/journals/aunews.html","",0);
		Menu5_8_2=new Array("Events Calendar", "http://calendar.ashland.edu","",0);
Menu6=new Array("","","",0,16,9);
Menu7=new Array("Visitors","","",9,16,58);
	Menu7_1=new Array("This is AU","http://www3.ashland.edu/about/index.html","",0,16,165);	
	Menu7_2=new Array("Live WebCams","","",2);
		Menu7_2_1=new Array("Construction Eaglecam", "http://198.30.217.41/eaglecam/webCam.asp","",0,16,150);	
		Menu7_2_2=new Array("Quadrangle Eaglecam", "http://198.30.217.41/eaglecam/quad-eaglecam.asp","",0);
	Menu7_3=new Array("Visit the University","","",4);
		Menu7_3_1=new Array("Area Hotels", "http://www3.ashland.edu/about/areahotels.html","",0,16,150);	
		Menu7_3_2=new Array("Directions to Ashland University", "http://www3.ashland.edu/about/directions.html","",0);
		Menu7_3_3=new Array("Campus Map", "http://www.ashland.edu/admission/map_index.html","",0);
		Menu7_3_4=new Array("Virtual Tour", "http://www.ashland.edu/admission/tour_index.html","",0);
	Menu7_4=new Array("Community Information", "http://www3.ashland.edu/about/campusInfo.html","",0);
	Menu7_5=new Array("Employment Opportunities", "http://www.higheredjobs.com/institution/universitySearch.cfm?University=Ashland%20University","",0);
	Menu7_6=new Array("Bookstore", "http://www.ashland.edu/bookstore/bookhome.html","",0);
	Menu7_7=new Array("Tour the World with AU", "http://www3.ashland.edu/about/tourtheworld.html","",0);
	Menu7_8=new Array("News & Events","","",2);
		Menu7_8_1=new Array("News Releases", "http://www.ashland.edu/news2.html","",0,16,140);
		//Menu7_8_2=new Array("Institutional Newsletter", "http://www3.ashland.edu/journals/aunews.html","",0);
		Menu7_8_2=new Array("Events Calendar", "http://calendar.ashland.edu","",0);
	Menu7_9=new Array("125th Anniversary", "http://celebrate.ashland.edu","",0);
Menu8=new Array("","","",0,16,9);
Menu9=new Array("Professionals","","",10,16,96);
	Menu9_1=new Array("Professional Development Workshops", "http://www.ashland.edu/colleges/education/profdev/profdvlp.html","",0,16,220);
	Menu9_2=new Array("Corporate Development Services", "http://www.ashland.edu/cds/","",0);
	Menu9_3=new Array("Telego Center (Prof. Educators)", "http://www.ashland.edu/colleges/education/edimprove/edimprove.html","",0);
	Menu9_4=new Array("Bachelor's Plus Program", "http://www.ashland.edu/colleges/education/bachplus.html","",0);
	Menu9_5=new Array("Doctor of Education", "http://www.ashland.edu/colleges/education/ded/ded.html","",0);
	Menu9_6=new Array("Master of Education", "http://www.ashland.edu/colleges/education/med/med.html","",0);
	Menu9_7=new Array("Master of Business Administration", "http://www.ashland.edu/colleges/education/med/med.html","",0);
	Menu9_8=new Array("Nursing (RN to BSN)", "http://www.ashland.edu/colleges/arts_sci/nursing/nursing.html","",0);
	Menu9_9=new Array("Evening/Weekend Business Program", "http://www.ashland.edu/colleges/business/eveweek/evwechome.html","",0);
	Menu9_10=new Array("Ashland Theological Seminary","http://www.ashland.edu/seminary/","",0);
Menu10=new Array("","","",0,16,9);
Menu11=new Array("Centers & Campuses","","",4,16,138);
	Menu11_1=new Array("Ashbrook Center","http://www.ashbrook.org/","",0,16,180);
	Menu11_2=new Array("Ashland Theological Seminary","http://www.ashland.edu/seminary/","",0);
	Menu11_3=new Array("Gill Center","http://www.ashland.edu/gill/home.html","",0);

//	Menu11_4=new Array("Off Campus Centers","http://www3.ashland.edu/offcamp/index.html","",6);
//		Menu11_4_1=new Array("Information & Directions","http://www3.ashland.edu/offcamp/index.html","",0,16,160);
//		Menu11_4_2=new Array("Elyria","http://www.ashland.edu/offcamp/elyria/elyriahome.html","",0);
//		Menu11_4_3=new Array("Columbus","http://www.ashland.edu/offcamp/cols/colshome.html","",0);
//		Menu11_4_4=new Array("Massillon/Stark","http://www.ashland.edu/offcamp/stark/starkhome.html","",0);
//		Menu11_4_5=new Array("Other Sites","http://www3.ashland.edu/offcamp/othersites.html","",0);
//		Menu11_4_6=new Array("Professional Development", "http://www3.ashland.edu/colleges/education/profdev/index.html","",0,16,220);
	Menu11_4=new Array("Telego Center","http://www.ashland.edu/colleges/education/edimprove/edImprovement.htm","",0);




/*********************************************************************************************************************************************
*	(c) Ger Versluis 2000 version 5.41 24 December 2001						*
*	HV Menu found on Dynamic Drive ONLY may be used on both commercial and non commerical sites	*
*	For info write to menus@burmees.nl							        *
*       This script featured on Dynamic Drive DHTML code library: http://www.dynamicdrive.com
**********************************************************************************************************************************************/

	var AgntUsr=navigator.userAgent.toLowerCase();
	var DomYes=document.getElementById?1:0;
	var NavYes=AgntUsr.indexOf('mozilla')!=-1&&AgntUsr.indexOf('compatible')==-1?1:0;
	var ExpYes=AgntUsr.indexOf('msie')!=-1?1:0;
	var Opr=AgntUsr.indexOf('opera')!=-1?1:0;
	var DomNav=DomYes&&NavYes?1:0;
 	var DomExp=DomYes&&ExpYes?1:0;
	var Nav4=NavYes&&!DomYes&&document.layers?1:0;
	var Exp4=ExpYes&&!DomYes&&document.all?1:0;
	var PosStrt=(NavYes||ExpYes)&&!Opr?1:0;

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
	var M_StrtTp=StartTop,M_StrtLft=StartLeft;
	var StaticPos=0;
	var LftXtra=DomNav?LeftPaddng:0;
	var TpXtra=DomNav?TopPaddng:0;
	var M_Hide=Nav4?'hide':'hidden';
	var M_Show=Nav4?'show':'visible';
	var Par=parent.frames[0]&&FirstLineFrame!=SecLineFrame?parent:window;
	var Doc=Par.document;
	var Bod=Doc.body;
	var Trigger=NavYes?Par:Bod;

	MenuTextCentered=MenuTextCentered==1||MenuTextCentered=='center'?'center':MenuTextCentered==0||MenuTextCentered!='right'?'left':'right';
	WbMstrAlrts=["Item not defined: ","Item needs height: ","Item needs width: "];

	if(Trigger.onload)Dummy=Trigger.onload;
	if(DomNav&&!Opr)Trigger.addEventListener('load',Go,false);
	else Trigger.onload=Go;

function Dummy(){return}

function CnclSlct(){return false}

function RePos(){
	FrstWinWdth=ExpYes?FrstLoc.document.body.clientWidth:FrstLoc.innerWidth;
	FrstWinHght=ExpYes?FrstLoc.document.body.clientHeight:FrstLoc.innerHeight;
	ScWinWdth=ExpYes?ScLoc.document.body.clientWidth:ScLoc.innerWidth;
	ScWinHght=ExpYes?ScLoc.document.body.clientHeight:ScLoc.innerHeight;
	if(MenuCentered=='justify'&&FirstLineHorizontal){
		FrstCntnr.style.width=FrstWinWdth;
		ClcJus();
		var P=FrstCntnr.FrstMbr,W=Menu1[5],i;
		for(i=0;i<NoOffFirstLineMenus;i++){P.style.width=W;P=P.PrvMbr}}
	StaticPos=-1;
	if(TargetLoc)ClcTrgt();
	if(MenuCentered)ClcLft();
	if(MenuVerticalCentered)ClcTp();
	PosMenu(FrstCntnr,StartTop,StartLeft)}

function UnLoaded(){
	if(CloseTmr)clearTimeout(CloseTmr);
	Loadd=0; Creatd=0;
	if(HideTop){
		var FCStyle=Nav4?FrstCntnr:FrstCntnr.style;
		FCStyle.visibility=M_Hide}}

function ReDoWhole(){
	if(ScWinWdth!=ScLoc.innerWidth||ScWinHght!=ScLoc.innerHeight||FrstWinWdth!=FrstLoc.innerWidth||FrstWinHght!=FrstLoc.innerHeight)Doc.location.reload()}

function Check(WMnu,NoOf){
	var i,array,ArrayLoc;
	ArrayLoc=parent.frames[0]?parent.frames[FirstLineFrame]:self;
	for(i=0;i<NoOf;i++){
		array=WMnu+eval(i+1);
		if(!ArrayLoc[array]){WbMstrAlrt(0,array); return false}
		if(i==0){	if(!ArrayLoc[array][4]){WbMstrAlrt(1,array); return false}
			if(!ArrayLoc[array][5]){WbMstrAlrt(2,array); return false}}
		if(ArrayLoc[array][3])if(!Check(array+'_',ArrayLoc[array][3])) return false}
	return true}

function WbMstrAlrt(No,Xtra){
	return confirm(WbMstrAlrts[No]+Xtra+'   ')}

function Go(){
	Dummy();
	if(Loadd||!PosStrt)return;
	BeforeStart();
	Creatd=0; Loadd=1;
	status='Building menu';
	if(FrstCreat){
		if(FirstLineFrame =="" || !parent.frames[FirstLineFrame]){
			FirstLineFrame=SecLineFrame;
			if(FirstLineFrame =="" || !parent.frames[FirstLineFrame]){
				FirstLineFrame=SecLineFrame=DocTargetFrame;
				if(FirstLineFrame =="" || !parent.frames[FirstLineFrame])FirstLineFrame=SecLineFrame=DocTargetFrame=''}}
		if(SecLineFrame =="" || !parent.frames[SecLineFrame]){
			SecLineFrame=DocTargetFrame;
			if(SecLineFrame =="" || !parent.frames[SecLineFrame])SecLineFrame=DocTargetFrame=FirstLineFrame}
		if(DocTargetFrame =="" || !parent.frames[DocTargetFrame])DocTargetFrame=SecLineFrame;
		if(WebMasterCheck){	if(!Check('Menu',NoOffFirstLineMenus)){status='build aborted';return}}
		FrstLoc=FirstLineFrame!=""?parent.frames[FirstLineFrame]:window;
		ScLoc=SecLineFrame!=""?parent.frames[SecLineFrame]:window;
		DcLoc=DocTargetFrame!=""?parent.frames[DocTargetFrame]:window;
		if (FrstLoc==ScLoc) AcrssFrms=0;
		if (AcrssFrms)FirstLineHorizontal=MenuFramesVertical?0:1;
		FrstWinWdth=ExpYes?FrstLoc.document.body.clientWidth:FrstLoc.innerWidth;
		FrstWinHght=ExpYes?FrstLoc.document.body.clientHeight:FrstLoc.innerHeight;
		ScWinWdth=ExpYes?ScLoc.document.body.clientWidth:ScLoc.innerWidth;
		ScWinHght=ExpYes?ScLoc.document.body.clientHeight:ScLoc.innerHeight;
		if(Nav4){	CntrTxt=MenuTextCentered!='left'?"<div align='"+MenuTextCentered+"'>":"";
			TxtClose="</font>"+MenuTextCentered!='left'?"</div>":""}}
	FirstColPos=Nav4?FrstLoc.document:FrstLoc.document.body;
	SecColPos=Nav4?ScLoc.document:ScLoc.document.body;
	DocColPos=Nav4?DcLoc.document:ScLoc.document.body;
	if (TakeOverBgColor)FirstColPos.bgColor=AcrssFrms?SecColPos.bgColor:DocColPos.bgColor;
	if(MenuCentered=='justify'&&FirstLineHorizontal)ClcJus();
	if(FrstCreat){
		FrstCntnr=CreateMenuStructure('Menu',NoOffFirstLineMenus);
		FrstCreat=AcrssFrms?0:1}
	else CreateMenuStructureAgain('Menu',NoOffFirstLineMenus);
	if(TargetLoc)ClcTrgt();
	if(MenuCentered)ClcLft();
	if(MenuVerticalCentered)ClcTp();
	PosMenu(FrstCntnr,StartTop,StartLeft);
	IniFlg=1;
	Initiate();
	Creatd=1;
	ScLdAgainWin=ExpYes?ScLoc.document.body:ScLoc;
	ScLdAgainWin.onunload=UnLoaded;
	Trigger.onresize=Nav4?ReDoWhole:RePos;
	AfterBuild();
	if(MenuVerticalCentered=='static'&&!AcrssFrms)setInterval('KeepPos()',250);
	status='Welcome to the Ashland University Website.'}

function KeepPos(){
	var TS=ExpYes?FrstLoc.document.body.scrollTop:FrstLoc.pageYOffset;
	if(TS!=StaticPos){
		var FCStyle=Nav4?FrstCntnr:FrstCntnr.style;
		FCStyle.top=FrstCntnr.OrgTop=StartTop+TS;StaticPos=TS}}

function ClcJus(){
	var a=BorderBtwnElmnts?1:2,b=BorderBtwnElmnts?BorderWidth:0;
	var Size=Math.round(((FrstWinWdth-a*BorderWidth)/NoOffFirstLineMenus)-b),i,j;
	for(i=1;i<NoOffFirstLineMenus+1;i++){j=eval('Menu'+i);j[5]=Size}
	StartLeft=0}

function ClcTrgt(){
	var TLoc=Nav4?FrstLoc.document.layers[TargetLoc]:DomYes?FrstLoc.document.getElementById(TargetLoc):FrstLoc.document.all[TargetLoc];
	StartTop=M_StrtTp;
	StartLeft=M_StrtLft;
	if(DomYes){
		while(TLoc){StartTop+=TLoc.offsetTop;StartLeft+=TLoc.offsetLeft;TLoc=TLoc.offsetParent}}
	else{	StartTop+=Nav4?TLoc.pageY:TLoc.offsetTop;StartLeft+=Nav4?TLoc.pageX:TLoc.offsetLeft}}

function ClcLft(){
	if(MenuCentered!='left'&&MenuCentered!='justify'){
		var Size=FrstWinWdth-(!Nav4?parseInt(FrstCntnr.style.width):FrstCntnr.clip.width);
		StartLeft=M_StrtLft;
		StartLeft+=MenuCentered=='right'?Size:Size/2}}

function ClcTp(){
	if(MenuVerticalCentered!='top'&&MenuVerticalCentered!='static'){
		var Size=FrstWinHght-(!Nav4?parseInt(FrstCntnr.style.height):FrstCntnr.clip.height);
		StartTop=M_StrtTp;
		StartTop+=MenuVerticalCentered=='bottom'?Size:Size/2}}

function PosMenu(CntnrPntr,Tp,Lt){
	var Topi,Lefti,Hori;
	var Cntnr=CntnrPntr;
	var Mmbr=Cntnr.FrstMbr;
	var CntnrStyle=!Nav4?Cntnr.style:Cntnr;
	var MmbrStyle=!Nav4?Mmbr.style:Mmbr;
	var PadL=Mmbr.value.indexOf('<')==-1?LftXtra:0;
	var PadT=Mmbr.value.indexOf('<')==-1?TpXtra:0;
	var MmbrWt=!Nav4?parseInt(MmbrStyle.width)+PadL:MmbrStyle.clip.width;
	var MmbrHt=!Nav4?parseInt(MmbrStyle.height)+PadT:MmbrStyle.clip.height;
	var CntnrWt=!Nav4?parseInt(CntnrStyle.width):CntnrStyle.clip.width;
	var CntnrHt=!Nav4?parseInt(CntnrStyle.height):CntnrStyle.clip.height;
	var SubTp,SubLt;
	RcrsLvl++;
	if (RcrsLvl==1 && AcrssFrms)!MenuFramesVertical?Tp=FrstWinHght-CntnrHt+(Nav4?4:0):Lt=RightToLeft?0:FrstWinWdth-CntnrWt+(Nav4?4:0);
	if (RcrsLvl==2 && AcrssFrms)!MenuFramesVertical?Tp=0:Lt=RightToLeft?ScWinWdth-CntnrWt:0;
	if (RcrsLvl==2 && AcrssFrms){Tp+=VerCorrect;Lt+=HorCorrect}
	CntnrStyle.top=RcrsLvl==1?Tp:0;
	Cntnr.OrgTop=Tp;
	CntnrStyle.left=RcrsLvl==1?Lt:0;
	Cntnr.OrgLeft=Lt;
	if (RcrsLvl==1 && FirstLineHorizontal){
		Hori=1;Lefti=CntnrWt-MmbrWt-2*BorderWidth;Topi=0}
	else{	Hori=Lefti=0;Topi=CntnrHt-MmbrHt-2*BorderWidth}
	while(Mmbr!=null){
		MmbrStyle.left=Lefti+BorderWidth;
		MmbrStyle.top=Topi+BorderWidth;
		if(Nav4)Mmbr.CmdLyr.moveTo(Lefti+BorderWidth,Topi+BorderWidth);
		if(Mmbr.ChildCntnr){
			if(RightToLeft)ChldCntnrWdth=Nav4?Mmbr.ChildCntnr.clip.width:parseInt(Mmbr.ChildCntnr.style.width);
			if(Hori){	SubTp=Topi+MmbrHt+2*BorderWidth;
				SubLt=RightToLeft?Lefti+MmbrWt-ChldCntnrWdth:Lefti}
			else{	SubLt=RightToLeft?Lefti-ChldCntnrWdth+ChildOverlap*MmbrWt+BorderWidth:Lefti+(1-ChildOverlap)*MmbrWt+BorderWidth;
				SubTp=RcrsLvl==1&&AcrssFrms?Topi:Topi+ChildVerticalOverlap*MmbrHt}
			PosMenu(Mmbr.ChildCntnr,SubTp,SubLt)}
		Mmbr=Mmbr.PrvMbr;
		if(Mmbr){	MmbrStyle=!Nav4?Mmbr.style:Mmbr;
			PadL=Mmbr.value.indexOf('<')==-1?LftXtra:0;
			PadT=Mmbr.value.indexOf('<')==-1?TpXtra:0;
			MmbrWt=!Nav4?parseInt(MmbrStyle.width)+PadL:MmbrStyle.clip.width;
			MmbrHt=!Nav4?parseInt(MmbrStyle.height)+PadT:MmbrStyle.clip.height;
			Hori?Lefti-=BorderBtwnElmnts?(MmbrWt+BorderWidth):(MmbrWt):Topi-=BorderBtwnElmnts?(MmbrHt+BorderWidth):(MmbrHt)}}
	RcrsLvl--}

function Initiate(){
	if(IniFlg){	Init(FrstCntnr);IniFlg=0;
		if(ShwFlg)AfterCloseAll();ShwFlg=0}}

function Init(CntnrPntr){
	var Mmbr=CntnrPntr.FrstMbr;
	var MCStyle=Nav4?CntnrPntr:CntnrPntr.style;
	RcrsLvl++;
	MCStyle.visibility=RcrsLvl==1?M_Show:M_Hide;
	while(Mmbr!=null){
		if(Mmbr.Hilite){Mmbr.Hilite=0;if(KeepHilite)LowItem(Mmbr)}
		if(Mmbr.ChildCntnr) Init(Mmbr.ChildCntnr);
		Mmbr=Mmbr.PrvMbr}
	RcrsLvl--}

function ClearAllChilds(Pntr){
	var CPCCStyle;
	while (Pntr){
		if(Pntr.Hilite){
			Pntr.Hilite=0;
			if(KeepHilite)LowItem(Pntr);
			if(Pntr.ChildCntnr){
				CPCCStyle=Nav4?Pntr.ChildCntnr:Pntr.ChildCntnr.style;
				CPCCStyle.visibility=M_Hide;
				ClearAllChilds(Pntr.ChildCntnr.FrstMbr)}
			break}
		Pntr=Pntr.PrvMbr}}

function GoTo(){
	if(this.LinkTxt){
		status='';
		var HP=Nav4?this.LowLyr:this;
		LowItem(HP);
		this.LinkTxt.indexOf('javascript:')!=-1?eval(this.LinkTxt):DcLoc.location.href=this.LinkTxt}}

function HiliteItem(P){
	if(Nav4){
		if(P.ro)P.document.images[P.rid].src=P.ri2;
		else{	if(P.HiBck)P.bgColor=P.HiBck;
			if(P.value.indexOf('<img')==-1){
				P.document.write(P.Ovalue);
				P.document.close()}}}
	else{	if(P.ro){	var Lc=P.Level==1?FrstLoc:ScLoc;
			Lc.document.images[P.rid].src=P.ri2}
		else{	if(P.HiBck)P.style.backgroundColor=P.HiBck;
			if(P.HiFntClr)P.style.color=P.HiFntClr}}
	P.Hilite=1}

function LowItem(P){
	if(P.ro){	if(Nav4)P.document.images[P.rid].src=P.ri1;
		else{	var Lc=P.Level==1?FrstLoc:ScLoc;
			Lc.document.images[P.rid].src=P.ri1}}
	else{	if(Nav4){	if(P.LoBck)P.bgColor=P.LoBck;
			if(P.value.indexOf('<img')==-1){
				P.document.write(P.value);
				P.document.close()}}
		else{	if(P.LoBck)P.style.backgroundColor=P.LoBck;
			if(P.LwFntClr)P.style.color=P.LwFntClr}}}

function OpenMenu(){	
	if(!Loadd||!Creatd) return;
	var TpScrlld=ExpYes?ScLoc.document.body.scrollTop:ScLoc.pageYOffset;
	var LScrlld=ExpYes?ScLoc.document.body.scrollLeft:ScLoc.pageXOffset;
	var CCnt=Nav4?this.LowLyr.ChildCntnr:this.ChildCntnr;
	var ThisHt=Nav4?this.clip.height:parseInt(this.style.height);
	var ThisWt=Nav4?this.clip.width:parseInt(this.style.width);
	var ThisLft=AcrssFrms&&this.Level==1&&!FirstLineHorizontal?0:Nav4?this.Container.left:parseInt(this.Container.style.left);
	var ThisTp=AcrssFrms&&this.Level==1&&FirstLineHorizontal?0:Nav4?this.Container.top:parseInt(this.Container.style.top);
	var HP=Nav4?this.LowLyr:this;
	CurrntOvr=this;
	IniFlg=0;
	ClearAllChilds(this.Container.FrstMbr);
	HiliteItem(HP);
	if(CCnt!=null){
		if(!ShwFlg){ShwFlg=1;	BeforeFirstOpen()}
		var CCW=Nav4?this.LowLyr.ChildCntnr.clip.width:parseInt(this.ChildCntnr.style.width);
		var CCH=Nav4?this.LowLyr.ChildCntnr.clip.height:parseInt(this.ChildCntnr.style.height);
		var ChCntTL=Nav4?this.LowLyr.ChildCntnr:this.ChildCntnr.style;
		var SubLt=AcrssFrms&&this.Level==1?CCnt.OrgLeft+ThisLft+LScrlld:CCnt.OrgLeft+ThisLft;
		var SubTp=AcrssFrms&&this.Level==1?CCnt.OrgTop+ThisTp+TpScrlld:CCnt.OrgTop+ThisTp;
		if(MenuWrap){
			if(RightToLeft){
				if(SubLt<LScrlld)SubLt=this.Level==1?LScrlld:SubLt+(CCW+(1-2*ChildOverlap)*ThisWt);
				if(SubLt+CCW>ScWinWdth+LScrlld)SubLt=ScWinWdth+LScrlld-CCW}
			else{	if(SubLt+CCW>ScWinWdth+LScrlld)SubLt=this.Level==1?ScWinWdth+LScrlld-CCW:SubLt-(CCW+(1-2*ChildOverlap)*ThisWt);
				if(SubLt<LScrlld)SubLt=LScrlld}
			if(SubTp+CCH>TpScrlld+ScWinHght)SubTp=this.Level==1?SubTp=TpScrlld+ScWinHght-CCH:SubTp-CCH+(1-2*ChildVerticalOverlap)*ThisHt;
			if(SubTp<TpScrlld)SubTp=TpScrlld}
		ChCntTL.top=SubTp;ChCntTL.left=SubLt;ChCntTL.visibility=M_Show}
	status=this.LinkTxt}

function OpenMenuClick(){
	if(!Loadd||!Creatd) return;
	var HP=Nav4?this.LowLyr:this;
	CurrntOvr=this;
	IniFlg=0;
	ClearAllChilds(this.Container.FrstMbr);
	HiliteItem(HP);
	status=this.LinkTxt}

function CloseMenu(){
	if(!Loadd||!Creatd) return;
	if(!KeepHilite){
		var HP=Nav4?this.LowLyr:this;
		LowItem(HP)}
	status='';
	if(this==CurrntOvr){
		IniFlg=1;
		if(CloseTmr)clearTimeout(CloseTmr);
		CloseTmr=setTimeout('Initiate(CurrntOvr)',DissapearDelay)}}

function CntnrSetUp(Wdth,Hght,NoOff){
	var x=RcrsLvl==1?BorderColor:BorderSubColor;
	this.FrstMbr=null;
	this.OrgLeft=this.OrgTop=0;
	if(x)this.bgColor=x;
	if(Nav4){	this.visibility='hide';
		this.resizeTo(Wdth,Hght)}
	else{	if(x)this.style.backgroundColor=x;
		this.style.width=Wdth;
		this.style.height=Hght;
		this.style.fontFamily=FontFamily;
		this.style.fontWeight=FontBold?'bold':'normal';
		this.style.fontStyle=FontItalic?'italic':'normal';
		this.style.fontSize=FontSize;
		this.style.zIndex=RcrsLvl+Ztop}}

function MbrSetUp(MmbrCntnr,PrMmbr,WhatMenu,Wdth,Hght){
	var Location=RcrsLvl==1?FrstLoc:ScLoc;
	var MemVal=eval(WhatMenu+'[0]');
	var t,T,L,W,H,S;
	var a,b,c,d;
	this.PrvMbr=PrMmbr;
	this.Level=RcrsLvl;
	this.LinkTxt=eval(WhatMenu+'[1]');
	this.Container=MmbrCntnr;
	this.ChildCntnr=null;
	this.Hilite=0;
	this.style.overflow='hidden';
	this.style.cursor=ExpYes&&(this.LinkTxt||(RcrsLvl==1&&UnfoldsOnClick))?'hand':'default';
	this.ro=0;
	if(MemVal.indexOf('rollover')!=-1){
		this.ro=1;
		this.ri1=MemVal.substring(MemVal.indexOf(':')+1,MemVal.lastIndexOf(':'));
		this.ri2=MemVal.substring(MemVal.lastIndexOf(':')+1,MemVal.length);
		this.rid=WhatMenu+'i';MemVal="<img src='"+this.ri1+"' name='"+this.rid+"'>"}
	this.value=MemVal;
	if(RcrsLvl==1){
		a=LowBgColor;
		b=HighBgColor;
		c=FontLowColor;
		d=FontHighColor}
	else{	a=LowSubBgColor;
		b=HighSubBgColor;
		c=FontSubLowColor;
		d=FontSubHighColor}
	this.LoBck=a;
	this.LwFntClr=c;
	this.HiBck=b;
	this.HiFntClr=d;
	this.style.color=this.LwFntClr;
	if(this.LoBck)this.style.backgroundColor=this.LoBck;
	this.style.textAlign=MenuTextCentered;
	if(eval(WhatMenu+'[2]'))this.style.backgroundImage="url(\'"+eval(WhatMenu+'[2]')+"\')";
	if(MemVal.indexOf('<')==-1){
		this.style.width=Wdth-LftXtra;
		this.style.height=Hght-TpXtra;
		this.style.paddingLeft=LeftPaddng;
		this.style.paddingTop=TopPaddng}
	else{	this.style.width=Wdth;
		this.style.height=Hght}
	if(MemVal.indexOf('<')==-1&&DomYes){
		t=Location.document.createTextNode(MemVal);
		this.appendChild(t)}
	else this.innerHTML=MemVal;
	if(eval(WhatMenu+'[3]')&&ShowArrow){
		a=RcrsLvl==1&&FirstLineHorizontal?3:RightToLeft?6:0;
		S=Arrws[a];
		W=Arrws[a+1];
		H=Arrws[a+2];
		T=RcrsLvl==1&&FirstLineHorizontal?Hght-H-2:(Hght-H)/2;
		L=RightToLeft?2:Wdth-W-2;
		if(DomYes){
			t=Location.document.createElement('img');
			this.appendChild(t);
			t.style.position='absolute';
			t.src=S;
			t.style.width=W;
			t.style.height=H;
			t.style.top=T;
			t.style.left=L}
		else{  MemVal+="<div style='position:absolute; top:"+T+"; z-index:1; left:"+L+"; width:"+W+"; height:"+H+";visibility:inherit'><img src='"+S+"'></div>";
			this.innerHTML=MemVal}}
	if(ExpYes){this.onselectstart=CnclSlct;
		this.onmouseover=RcrsLvl==1&&UnfoldsOnClick?OpenMenuClick:OpenMenu;
		this.onmouseout=CloseMenu;
		this.onclick=RcrsLvl==1&&UnfoldsOnClick&&eval(WhatMenu+'[3]')?OpenMenu:GoTo	}
	else{	RcrsLvl==1&&UnfoldsOnClick?this.addEventListener('mouseover',OpenMenuClick,false):this.addEventListener('mouseover',OpenMenu,false);
		this.addEventListener('mouseout',CloseMenu,false);
		RcrsLvl==1&&UnfoldsOnClick&&eval(WhatMenu+'[3]')?this.addEventListener('click',OpenMenu,false):this.addEventListener('click',GoTo,false)}}

function NavMbrSetUp(MmbrCntnr,PrMmbr,WhatMenu,Wdth,Hght){
	var a,b,c,d;
	if(RcrsLvl==1){
		a=LowBgColor;
		b=HighBgColor;
		c=FontLowColor;
		d=FontHighColor}
	else {	a=LowSubBgColor;
		b=HighSubBgColor;
		c=FontSubLowColor;
		d=FontSubHighColor	}
	this.value=eval(WhatMenu+'[0]');
	this.ro=0;
	if(this.value.indexOf('rollover')!=-1){
		this.ro=1;
		this.ri1=this.value.substring(this.value.indexOf(':')+1,this.value.lastIndexOf(':'));
		this.ri2=this.value.substring(this.value.lastIndexOf(':')+1,this.value.length);
		this.rid=WhatMenu+'i';this.value="<img src='"+this.ri1+"' name='"+this.rid+"'>"}
	if(LeftPaddng&&this.value.indexOf('<')==-1&&MenuTextCentered=='left')this.value='&nbsp\;'+this.value;
	if(FontBold)this.value=this.value.bold();
	if(FontItalic)this.value=this.value.italics();
	this.Ovalue=this.value;
	this.value=this.value.fontcolor(c);
	this.Ovalue=this.Ovalue.fontcolor(d);
	this.value=CntrTxt+"<font face='"+FontFamily+"'point-size='"+FontSizeNav+"'>"+this.value+TxtClose;
	this.Ovalue=CntrTxt+"<font face='"+FontFamily+"' point-size='"+FontSizeNav+"' >"+this.Ovalue+TxtClose;
	this.LoBck=a;
	this.HiBck=b;
	this.ChildCntnr=null;
	this.PrvMbr=PrMmbr;
	this.Hilite=0;
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
	this.CmdLyr.onmouseover=RcrsLvl==1&&UnfoldsOnClick?OpenMenuClick:OpenMenu;
	this.CmdLyr.onmouseout=CloseMenu;
	this.CmdLyr.captureEvents(Event.MOUSEUP);
	this.CmdLyr.onmouseup=RcrsLvl==1&&UnfoldsOnClick&&eval(WhatMenu+'[3]')?OpenMenu:GoTo;
	this.CmdLyr.LowLyr=this;
	this.CmdLyr.resizeTo(Wdth,Hght);
	this.CmdLyr.Container=MmbrCntnr;
	if(eval(WhatMenu+'[3]')&&ShowArrow){
		a=RcrsLvl==1&&FirstLineHorizontal?3:RightToLeft?6:0;
		this.CmdLyr.ImgLyr=new Layer(Arrws[a+1],this.CmdLyr);
		this.CmdLyr.ImgLyr.visibility='inherit';
		this.CmdLyr.ImgLyr.top=RcrsLvl==1&&FirstLineHorizontal?Hght-Arrws[a+2]-2:(Hght-Arrws[a+2])/2;
		this.CmdLyr.ImgLyr.left=RightToLeft?2:Wdth-Arrws[a+1]-2;
		this.CmdLyr.ImgLyr.width=Arrws[a+1];
		this.CmdLyr.ImgLyr.height=Arrws[a+2];
		ImgStr="<img src='"+Arrws[a]+"' width='"+Arrws[a+1]+"' height='"+Arrws[a+2]+"'>";
		this.CmdLyr.ImgLyr.document.write(ImgStr);
		this.CmdLyr.ImgLyr.document.close()}}

function CreateMenuStructure(MName,NumberOf){
	RcrsLvl++;
	var i,NoOffSubs,Mbr,Wdth=0,Hght=0;
	var PrvMmbr=null;
	var WMnu=MName+'1';
	var MenuWidth=eval(WMnu+'[5]');
	var MenuHeight=eval(WMnu+'[4]');
	var Location=RcrsLvl==1?FrstLoc:ScLoc;
	if (RcrsLvl==1&&FirstLineHorizontal){
		for(i=1;i<NumberOf+1;i++){
			WMnu=MName+eval(i);
			Wdth=eval(WMnu+'[5]')?Wdth+eval(WMnu+'[5]'):Wdth+MenuWidth}
		Wdth=BorderBtwnElmnts?Wdth+(NumberOf+1)*BorderWidth:Wdth+2*BorderWidth;Hght=MenuHeight+2*BorderWidth}
	else{	for(i=1;i<NumberOf+1;i++){
			WMnu=MName+eval(i);
			Hght=eval(WMnu+'[4]')?Hght+eval(WMnu+'[4]'):Hght+MenuHeight}
		Hght=BorderBtwnElmnts?Hght+(NumberOf+1)*BorderWidth:Hght+2*BorderWidth;Wdth=MenuWidth+2*BorderWidth}
	if(DomYes){
		var MmbrCntnr=Location.document.createElement("div");
		MmbrCntnr.style.position='absolute';
		MmbrCntnr.style.visibility='hidden';
		Location.document.body.appendChild(MmbrCntnr)}
	else{	if(Nav4) var MmbrCntnr=new Layer(Wdth,Location)
		else{	WMnu+='c';
			Location.document.body.insertAdjacentHTML("AfterBegin","<div id='"+WMnu+"' style='visibility:hidden; position:absolute;'><\/div>");
			var MmbrCntnr=Location.document.all[WMnu]}}
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
		Wdth=RcrsLvl==1&&FirstLineHorizontal?eval(WMnu+'[5]')?eval(WMnu+'[5]'):MenuWidth:MenuWidth;
		Hght=RcrsLvl==1&&FirstLineHorizontal?MenuHeight:eval(WMnu+'[4]')?eval(WMnu+'[4]'):MenuHeight;
		if(DomYes){
			Mbr=Location.document.createElement("div");
			Mbr.style.position='absolute';
			Mbr.style.visibility='inherit';
			MmbrCntnr.appendChild(Mbr)}
		else Mbr=Nav4?new Layer(Wdth,MmbrCntnr):Location.document.all[WMnu];
		Mbr.SetUp=Nav4?NavMbrSetUp:MbrSetUp;
		Mbr.SetUp(MmbrCntnr,PrvMmbr,WMnu,Wdth,Hght);
		if(NoOffSubs) Mbr.ChildCntnr=CreateMenuStructure(WMnu+'_',NoOffSubs);
		PrvMmbr=Mbr}
	MmbrCntnr.FrstMbr=Mbr;
	RcrsLvl--;
	return(MmbrCntnr)}

function CreateMenuStructureAgain(MName,NumberOf){
	var i,WMnu,NoOffSubs,PrvMmbr,Mbr=FrstCntnr.FrstMbr;
	RcrsLvl++;
	for(i=NumberOf;i>0;i--){ WMnu=MName+eval(i);NoOffSubs=eval(WMnu+'[3]');PrvMmbr=Mbr;if(NoOffSubs)Mbr.ChildCntnr=CreateMenuStructure(WMnu+'_',NoOffSubs);Mbr=Mbr.PrvMbr}RcrsLvl--
}