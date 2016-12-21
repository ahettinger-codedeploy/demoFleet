
/*
 Copyright 2002 (c) Milonic Solutions. All Rights Reserved.
*/

//The following line is critical for menu operation, and MUST APPEAR ONLY ONCE.
menunum=0;menus=new Array();_d=document;function addmenu(){menunum++;menus[menunum]=menu;}function dumpmenus(){mt="<script language=JavaScript>";for(a=1;a<menus.length;a++){mt+=" menu"+a+"=menus["+a+"];"}mt+="<\/script>";_d.write(mt)}
//Please leave the above line intact. The above also needs to be enabled if it not already enabled unless you have more than one _array.js file


////////////////////////////////////
// Editable properties START here //
////////////////////////////////////

timegap=100                   // The time delay for menus to remain visible
followspeed=5                 // Follow Scrolling speed
followrate=50                 // Follow Scrolling Rate
suboffset_top=0               // Sub menu offset Top position
suboffset_left=0             // Sub menu offset Left position



PlainStyle=[                  // PlainStyle is an array of properties. You can have as many property arrays as you need
"FFFFFF",                       // Mouse Off Font Color
"0",                     // Mouse Off Background Color (use zero for transparent in Netscape 6)
"FFFFFF",                     // Mouse On Font Color
"0",                     // Mouse On Background Color
"0",                     // Menu Border Color
"11",                         // Font Size (default is px but you can specify mm, pt or a percentage)
"normal",                     // Font Style (italic or normal)
"normal",                       // Font Weight (bold or normal)
"Verdana, Arial, Helvetica",// Font Name
3,                            // Menu Item Padding or spacing
,                  // Sub Menu Image (Leave this blank if not needed)
,                            // 3D Border & Separator bar
,                     // 3D High Color
,                     // 3D Low Color
,                     // Current Page Item Font Color (leave this blank to disable)
,                       // Current Page Item Background Color (leave this blank to disable)
,                             // Top Bar image (Leave this blank to disable)
,                     // Menu Header Font Color (Leave blank if headers are not needed)
,                     // Menu Header Background Color (Leave blank if headers are not needed)
"ffffff",                             // Menu Item Separator Color
]

Substyle=[                      // PlainStyle is an array of properties. You can have as many property arrays as you need
"000000",                       // Mouse Off Font Color
"eeeeee",                      // Mouse Off Background Color (use zero for transparent in Netscape 6)
"ffffff",                     // Mouse On Font Color
"000063",                     // Mouse On Background Color
"adadad",                     // Menu Border Color
"9",                         // Font Size (default is px but you can specify mm, pt or a percentage)
"normal",                       // Font Style (italic or normal)
"normal",                       // Font Weight (bold or normal)
"Verdana, Tahoma, Arial, Helvetica",// Font Name
4,                            // Menu Item Padding or spacing
,                             // Sub Menu Image (Leave this blank if not needed)
0,                            // 3D Border & Separator bar
"FFFF00",                     // 3D High Color
"CCFFFF",                     // 3D Low Color
,                     // Current Page Item Font Color (leave this blank to disable)
,                       // Current Page Item Background Color (leave this blank to disable)
,                  // Top Bar image (Leave this blank to disable)
"ffffff",                     // Menu Header Font Color (Leave blank if headers are not needed)
"000099",                     // Menu Header Background Color (Leave blank if headers are not needed)
"adadad",                             // Menu Item Separator Color
]


addmenu(menu=[
"boundmenu",                  // Menu Name - This is needed in order for this menu to be called
,                             // Menu Top - The Top position of this menu in pixels
,                             // Menu Left - The Left position of this menu in pixels
,                             // Menu Width - Menus width in pixels
0,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
PlainStyle,                   // Properties Array - this array is declared higher up as you can see above
1,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
"center",                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
,                             // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
1,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"&nbsp;&nbsp;&nbsp;&nbsp;People&nbsp;&nbsp;&nbsp;&nbsp;","show-menu=People","http://championforest.org/people/",,1
,"&nbsp;&nbsp;&nbsp;&nbsp;Ministries&nbsp;&nbsp;&nbsp;&nbsp;","show-menu=Ministries","http://championforest.org/ministries/",,1
,"&nbsp;&nbsp;&nbsp;&nbsp;Worship&nbsp;&nbsp;&nbsp;&nbsp;","show-menu=Worship","http://championforest.org/worship/",,1
,"&nbsp;&nbsp;&nbsp;&nbsp;Events&nbsp;&nbsp;&nbsp;&nbsp;","show-menu=Events","http://championforest.org/events/",,1
,"&nbsp;&nbsp;&nbsp;&nbsp;Library&nbsp;&nbsp;&nbsp;&nbsp;","show-menu=Library","http://championforest.org/library/",,1
,"&nbsp;&nbsp;&nbsp;&nbsp;Family&nbsp;&nbsp;Life&nbsp;Center&nbsp;&nbsp;","show-menu=FLC","http://championforest.org/familylife/",,1
,"&nbsp;&nbsp;&nbsp;&nbsp;About&nbsp;&nbsp;CFBC&nbsp;&nbsp;","show-menu=About","http://championforest.org/about/",,1
])

addmenu(menu=[
"People",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Preschool","show-menu=Preschool","http://championforest.org/people/preschool/",,0
,"Children","show-menu=Children","http://championforest.org/people/children/",,0
,"Students","show-menu=Students","http://championforest.org/people/students/",,0
,"College","show-menu=College","http://championforest.org/people/college/",,0
,"Single Adults","show-menu=SingleAdults","http://championforest.org/people/singleadults/",,0
,"Young Married Adults","show-menu=YMAdults","http://championforest.org/people/ymadults/",,0
,"Median Adults","show-menu=Median","http://championforest.org/people/medianadults/",,0
,"Prime Timers","show-menu=PrimeTimers","http://championforest.org/people/primetimers/",,0
,"Men","show-menu=Men","http://championforest.org/people/men/",,0
,"Women","show-menu=Women","http://championforest.org/people/women/",,0

])

addmenu(menu=[
"Preschool",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/preschool/events.shtml",,,0
,"Sunday Preschool Classes","http://championforest.org/people/preschool/sunday_preschool.shtml",,,0
,"Christian Preschool (weekdays)","http://championforest.org/people/preschool/christian_preschool.shtml",,,0
,"Mother's Day Out","http://championforest.org/people/preschool/mdo.shtml",,,0
,"Childcare","http://championforest.org/people/preschool/childcare/",,,0
,"Volunteer","http://championforest.org/people/preschool/volunteer.shtml",,,0
])

addmenu(menu=[
"Children",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/children/events.shtml",,,0
,"Sunday School Classes","http://championforest.org/people/children/sundayschool.shtml",,,0
,"Ministry Staff","http://championforest.org/people/children/staff.shtml",,,0
,"Childcare","http://championforest.org/people/preschool/childcare/",,,0
,"Volunteer","http://championforest.org/people/children/volunteer.shtml",,,0
])

addmenu(menu=[
"Students",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"element","http://championforest.org/people/students/element.shtml",,,0
,"Activities/Events","http://championforest.org/people/students/events.shtml",,,0
,"Bible Study","http://championforest.org/people/students/classes.shtml",,,0
,"Ministry Staff","http://championforest.org/people/students/staff.shtml",,,0
,"Volunteer","http://championforest.org/people/students/volunteer.shtml",,,0
])

addmenu(menu=[
"College",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/college/events.shtml",,,0
,"Bible Study","http://championforest.org/people/college/classes.shtml",,,0
,"Ministry Staff","http://championforest.org/people/college/staff.shtml",,,0
])

addmenu(menu=[
"SingleAdults",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/singleadults/events.shtml",,,0
,"Bible Study","http://championforest.org/people/singleadults/classes.shtml",,,0
,"Small Group Studies","http://championforest.org/people/singleadults/small_group.shtml",,,0
,"Ministry Staff","http://championforest.org/people/singleadults/staff.shtml",,,0
,"Volunteer","http://championforest.org/people/singleadults/volunteer.shtml",,,0
])

addmenu(menu=[
"YMAdults",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/ymadults/events.shtml",,,0
,"Bible Study","http://championforest.org/people/ymadults/classes.shtml",,,0
,"Volunteer","http://championforest.org/people/ymadults/volunteer.shtml",,,0
])

addmenu(menu=[
"Median",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/medianadults/events.shtml",,,0
,"Bible Study","http://championforest.org/people/medianadults/classes.shtml",,,0
,"Volunteer","http://championforest.org/people/medianadults/volunteer.shtml",,,0
])

addmenu(menu=[
"PrimeTimers",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/primetimers/events.shtml",,,0
,"Prayer Ministries","http://championforest.org/people/primetimers/prayer_ministries.shtml",,,0
,"Inreach","http://championforest.org/people/primetimers/inreach.shtml",,,0
,"Outreach","http://championforest.org/people/primetimers/outreach.shtml",,,0
,"Bible Study","http://championforest.org/people/primetimers/sunday_classes.shtml",,,0
,"Continued Learning","http://championforest.org/people/primetimers/learning.shtml",,,0
,"Volunteer","http://championforest.org/people/primetimers/volunteer.shtml",,,0
])

addmenu(menu=[
"Men",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/men/events.shtml",,,0
,"Small Groups","http://championforest.org/people/men/groups.shtml",,,0
,"Volunteer","http://championforest.org/people/men/volunteer.shtml",,,0
])

addmenu(menu=[
"Women",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Activities/Events","http://championforest.org/people/women/events.shtml",,,0
])


addmenu(menu=[
"Ministries",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Administration","http://championforest.org/ministries/administration.shtml","",,0
,"Audio/Visual Communications","http://championforest.org/ministries/communications.shtml","",,0
,"Certain Call","http://championforest.org/ministries/drama.shtml","",,0
,"Grief Share","http://championforest.org/ministries/grief.shtml","",,0
,"Home Schools","http://championforest.org/ministries/home_schools.shtml","",,0
,"Internationals","http://championforest.org/ministries/internationals.shtml","",,0
,"Missions","show-menu=Missions","http://championforest.org/ministries/missions/",,0
,"Music/Worship Ministry","show-menu=Music","http://championforest.org/ministries/music/",,0
,"Pastoral Ministries","http://championforest.org/ministries/pastoral.shtml","",,0
,"Prayer","show-menu=Prayer","http://championforest.org/ministries/prayer/",,0
,"Ushers/Greeters","http://championforest.org/ministries/ushers.shtml","",,0
,"Spiritual Growth","show-menu=SpiritualGrowth","http://championforest.org/ministries/spiritual.shtml",,0

])


addmenu(menu=[
"Prayer",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Prayer Requests","http://championforest.org/ministries/prayer/requests.shtml",,,0
,"Volunteers","http://championforest.org/ministries/prayer/volunteers.shtml",,,0
])

addmenu(menu=[
"Missions",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Local Activities","http://championforest.org/ministries/missions/local.shtml",,,0
,"National &amp; International Activities","http://championforest.org/ministries/missions/international.shtml",,,0
,"Gospel Lakes","http://championforest.org/ministries/missions/gospel_lakes.shtml",,,0
])

addmenu(menu=[
"SpiritualGrowth",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Volunteer","http://championforest.org/ministries/place.shtml",,,0
])

addmenu(menu=[
"Music",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Orchestra","http://championforest.org/ministries/music/adult_orchestra.shtml",,,0
,"Adult Choir","http://championforest.org/ministries/music/adult_choir.shtml",,,0
,"Praise Team Choirs","http://championforest.org/ministries/music/praise_team_choir.shtml",,,0
,"Children's Choir","http://championforest.org/ministries/music/childrens_choir.shtml",,,0
,"Youth Choirs","http://championforest.org/ministries/music/youth_choir.shtml",,,0
,"Ministry Staff","http://championforest.org/ministries/music/staff.shtml",,,0
])

addmenu(menu=[
"Worship",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Worship Times","http://championforest.org/worship/times/","",,0
,"Worship Online","http://championforest.org/worship/online/","",,0

])

addmenu(menu=[
"Events",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Calendar","http://championforest.org/events/calendar.shtml","",,0
,"Email Updates","http://championforest.org/events/email.shtml","",,0
,"Wednesday Night Meal","http://championforest.org/events/meal.shtml","",,0

])

addmenu(menu=[
"Library",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Online Catalog","http://65.67.139.98/","",,0
,"Volunteer","http://championforest.org/library/volunteer.shtml","",,0

])

addmenu(menu=[
"FLC",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Sports &amp; Activities","show-menu=Sports","http://championforest.org/familylife/activities/",,0
,"Facilities","show-menu=Facilities","http://championforest.org/familylife/facilities/",,0
,"Hours","http://championforest.org/familylife/hours.shtml","",,0
,"Membership","http://championforest.org/familylife/membership.shtml","",,0
,"Policies","show-menu=Policies","http://championforest.org/familylife/policies",,0
,"Volunteer","http://championforest.org/familylife/volunteer.shtml","",,0
])

addmenu(menu=[
"Sports",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Cruisin' with Christ","http://championforest.org/familylife/activities/cruisin.shtml","",,0
,"Fitness Classes","http://championforest.org/familylife/activities/aerobics.shtml","",,0
,"Girls' Volleyball","http://championforest.org/familylife/activities/girls_volleyball.shtml","",,0
,"Men's Softball","http://championforest.org/familylife/activities/mens_softball.shtml","",,0
,"Summer Fun &amp; Fitness for Kids","http://championforest.org/familylife/activities/kids_summer.shtml","",,0
,"T-Ball","http://championforest.org/familylife/activities/t_ball.shtml","",,0
])

addmenu(menu=[
"Facilities",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Cardio-Vascular Equipment","http://championforest.org/familylife/facilities/cardio.shtml","",,0
,"Aerobic Fitness Room","http://championforest.org/familylife/facilities/aerobics.shtml","",,0
,"Strength Training Equipment","http://championforest.org/familylife/facilities/strength.shtml","",,0
,"Adult Locker Rooms & Lounges","http://championforest.org/familylife/facilities/locker_rooms.shtml","",,0
,"Gymnasiums","http://championforest.org/familylife/facilities/gymnasiums.shtml","",,0
,"Jogging/Walking Track","http://championforest.org/familylife/facilities/track.shtml","",,0
,"Racquetball Courts","http://championforest.org/familylife/facilities/racquetball.shtml","",,0
,"Lobby Games","http://championforest.org/familylife/facilities/lobby_games.shtml","",,0
])

addmenu(menu=[
"Policies",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Nursery","http://championforest.org/familylife/policies/nursery.shtml","",,0
,"Control Center","http://championforest.org/familylife/policies/control_center.shtml","",,0
,"Infractions","http://championforest.org/familylife/policies/infractions.shtml","",,0
,"Dress Code","http://championforest.org/familylife/policies/dress_code.shtml","",,0
,"Group Reservations","http://championforest.org/familylife/policies/group_reservations.shtml","",,0
,"Cancellation Policy","http://championforest.org/familylife/policies/cancellation.shtml","",,0
])

addmenu(menu=[
"About",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Beliefs","http://championforest.org/about/beliefs/","",,0
,"Directions","http://championforest.org/about/directions/","",,0
,"Member Services","show-menu=Services","http://championforest.org/about/member_services/",,0
,"Staff","http://championforest.org/about/staff","",,0
,"Contact Us","http://championforest.org/about/contact/","",,0
,"Sitemap","http://championforest.org/about/sitemap/","",,0
])

addmenu(menu=[
"Services",
,
,
130,
1,
,
Substyle,
0,
,
,
0,
0,
0,
,
,
0,
0,
,
,
0,
,
,"Counseling","http://championforest.org/about/member_services/counseling.shtml","",,0
,"Childcare","http://championforest.org/people/preschool/childcare/","",,0
,"Prayer Requests","http://championforest.org/ministries/prayer/requests.shtml","",,0

])

dumpmenus();
	