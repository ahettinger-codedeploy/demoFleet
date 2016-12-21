oM=new makeCM("oM"); 
oM.offlineRoot="" 
oM.resizeCheck=1; 
oM.rows=1;  
oM.onlineRoot=""; 
oM.pxBetween =0; 
oM.fillImg="cm_fill.gif"; 
oM.fromTop=-10; 
oM.fromLeft=0; 
oM.wait=300; 
oM.zIndex=400;
oM.useBar=0; 
oM.barWidth="cmpage.x2+250"; 
oM.barHeight="menu"; 
oM.barX=-25000;
oM.barY="menu"; 
oM.barClass="clBar";
oM.barBorderX=0; 
oM.barBorderY=0;

oM.level[0]=new cm_makeLevel(153,20,"clT","clTover",1,1,"clB",0,"bottom",0,-1,0,0,0);
oM.level[1]=new cm_makeLevel(153,25,"clS","clSover",1,1,"clB",0,"right",-1,5,"images/menu_arrow.gif",10,10);
oM.level[2]=new cm_makeLevel(151,25,"clS2","clS2over",1,1,"clB",0,"right",0,0,"images/menu_arrow.gif",10,10);
oM.level[3]=new cm_makeLevel(160,20);

/******************************************
Menu item creation:
myCoolMenu.makeMenu(name, parent_name, text, link, target, width, height, regImage, overImage, regClass, 
overClass , align, rows, nolink, onclick, onmouseover, onmouseout) 
*************************************/

oM.makeMenu('m1','','ABOUT US','/index.htm');
	oM.makeMenu('m11','m1','Calendars','/calendar.htm');
		//oM.makeMenu('m111','m11','School','calendar.htm');
		//oM.makeMenu('m112','m11','Competition','calendar.htm');
	//oM.makeMenu('m12','m1','Our Policy','/policy.htm');
	oM.makeMenu('m13','m1','Owners\' Profiles','/profiles.htm');
	oM.makeMenu('m14','m1','School Information','/info.htm');
	oM.makeMenu('m15','m1','Office Hours','/info.htm#hours');


oM.makeMenu('m2','','PARENTS','');
	oM.makeMenu('m23','m2','Dance Camp','/camp.htm');
	oM.makeMenu('m24','m2','Classes','/classes.htm');
	oM.makeMenu('m25','m2','Class Schedule','/2009_class_sched.htm');
	oM.makeMenu('m26','m2','Dress Code','/dress_code.htm');
	oM.makeMenu('m27','m2','Tips','');
		oM.makeMenu('m271','m27','Choose Studio','/studioreport.htm');
		oM.makeMenu('m272','m27','Music Lessons','/privatelessons.htm');
	oM.makeMenu('m28','m2','Testimonials','');
		oM.makeMenu('m281','m28','Alumni','/testimonials.htm#alumni');
		oM.makeMenu('m282','m28','Parents','/testimonials.htm#parents');
		oM.makeMenu('m283','m28','Professionals','/testimonials.htm#pros');

oM.makeMenu('m3','','COMPANY','');
	oM.makeMenu('m31','m3','News','/news.htm');
 	oM.makeMenu('m32','m3','Dates','/secure/company_dates.htm');
	oM.makeMenu('m33','m3','Schedule','/secure/company_sched.htm');


oM.makeMenu('m4','','COMPETITION','/secure/company_dates.htm');
	//oM.makeMenu('m41','m4','News','/index.htm');
	//oM.makeMenu('m42','m4','Directions','/index.htm');
	//oM.makeMenu('m43','m4','Option 3','index.htm');

oM.makeMenu('m5','','DOCUMENTS','');
	//oM.makeMenu('m51','m5','Tuition Fees','/fees.htm');
	oM.makeMenu('m52','m5','Private Policy','/policy_doc.htm');
	oM.makeMenu('m53','m5','Group Policy','/group_policy_doc.htm');
	//oM.makeMenu('m54','m5','Option 1','index.htm');



var avail="190+((cmpage.x2-235)/7)";
oM.menuPlacement="left"
oM.construct()