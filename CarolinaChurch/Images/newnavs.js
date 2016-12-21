if(typeof(loc)=="undefined"||loc==""){var loc="";if(document.body&&document.body.innerHTML){var tt=document.body.innerHTML.toLowerCase();var last=tt.indexOf("newnavs.js\"");if(last>0){var first=tt.lastIndexOf("\"",last);if(first>0&&first<last)loc=document.body.innerHTML.substr(first+1,last-first-1);}}}

var bd=0
document.write("<style type=\"text/css\">");
document.write("\n<!--\n");
document.write(".newnavs_menu {border-color:black;border-style:solid;border-width:"+bd+"px 0px "+bd+"px 0px;background-color:#cc0000;position:absolute;left:0px;top:0px;visibility:hidden;}");
document.write("a.newnavs_plain:link, a.newnavs_plain:visited{text-align:left;background-color:#cc0000;color:#ffffff;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("a.newnavs_plain:hover, a.newnavs_plain:active{background-color:#e57f7f;color:#ffffff;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("a.newnavs_l:link, a.newnavs_l:visited{text-align:left;background:#cc0000 url("+loc+"newnavs_l.gif) no-repeat right;;color:#ffffff;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("a.newnavs_l:hover, a.newnavs_l:active{background:#e57f7f url("+loc+"newnavs_l.gif) no-repeat right;color: #ffffff;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("\n-->\n");
document.write("</style>");

var fc=0xffffff;
var bc=0xe57f7f;
if(typeof(frames)=="undefined"){var frames=0;}

startMainMenu("newnavs_left.gif",18,15,2,0,0)
mainMenuItem("newnavs_b1",".gif",18,93,"http://www.carolinachurch.org/home.htm","","Home",2,2,"newnavs_plain");
mainMenuItem("newnavs_b2",".gif",18,93,"javascript:;","","About C.M.B.C.",2,2,"newnavs_plain");
mainMenuItem("newnavs_b3",".gif",18,93,"javascript:;","","Ministries",2,2,"newnavs_plain");
mainMenuItem("newnavs_b4",".gif",18,93,"javascript:;","","Events",2,2,"newnavs_plain");
mainMenuItem("newnavs_b5",".gif",18,93,"http://e-giving.org/start.asp?id=2045","","Online Giving",2,2,"newnavs_plain");
endMainMenu("newnavs_right.gif",18,15)

startSubmenu("newnavs_b4","newnavs_menu",93);
submenuItem("Church Calendar","http://www.mychurchevents.com/calendar/calendar.aspx?ci=L6L6M7H2I3L6G1G1","","newnavs_plain");
submenuItem("Special Events","http://www.carolinastage.org/","","newnavs_plain");
endSubmenu("newnavs_b4");

startSubmenu("newnavs_b3_7","newnavs_menu",92);
submenuItem("Drama","javascript:;","","newnavs_plain");
submenuItem("Audio and Media","javascript:;","","newnavs_plain");
submenuItem("C.M.B.C. Choirs","javascript:;","","newnavs_plain");
endSubmenu("newnavs_b3_7");

startSubmenu("newnavs_b3","newnavs_menu",213);
submenuItem("Intercessory Prayer","http://www.carolinachurch.org/Ministries-Leadership.htm#Intercessory_Prayer_Ministry","","newnavs_plain");
submenuItem("First and Last Impressions","http://www.carolinachurch.org/Ministries-Leadership.htm#First_&_Last_Impressions_Ministry","","newnavs_plain");
submenuItem("Outreach","http://www.carolinachurch.org/Ministries-Leadership.htm#Outreach_Ministry","","newnavs_plain");
submenuItem("Men's Ministry","http://www.carolinachurch.org/Ministries-Leadership.htm#Men’s_Ministry","","newnavs_plain");
submenuItem("Women's Ministry","http://www.carolinachurch.org/Ministries-Leadership.htm#Women’s_Ministry","","newnavs_plain");
submenuItem("Traffic and Security","http://www.carolinachurch.org/Ministries-Leadership.htm#Traffic_&_Security_Ministry","","newnavs_plain");
mainMenuItem("newnavs_b3_7","Music and Fine Arts",0,0,"http://www.carolinachurch.org/Ministries-Leadership.htm#Music_&_Fine_Arts_Ministry","","",1,1,"newnavs_l");
submenuItem("Armour-bearers Ministry","http://www.carolinachurch.org/Ministries-Leadership.htm#Armorbearers_Ministry","","newnavs_plain");
submenuItem("Young-at-Heart Ministry","http://www.carolinachurch.org/Ministries-Leadership.htm#Young-at-Heart","","newnavs_plain");
submenuItem("Ushers Ministry","http://www.carolinachurch.org/Ministries-Leadership.htm#Ushers_Ministry","","newnavs_plain");
submenuItem("Youth and Young Adult - The Chosen","http://www.carolinachurch.org/Ministries-Leadership.htm#Youth_&_Young_Adult_Ministry_-_The_Chosen","","newnavs_plain");
submenuItem("Culinary Ministry","http://www.carolinachurch.org/Ministries-Leadership.htm#Culinary_Ministry","","newnavs_plain");
endSubmenu("newnavs_b3");

startSubmenu("newnavs_b2_3","newnavs_menu",94);
submenuItem("What We Believe","http://www.carolinachurch.org/WhatWeBelieve.htm","","newnavs_plain");
submenuItem("Why Do We...","http://www.carolinachurch.org/WhyDoWe.htm","","newnavs_plain");
endSubmenu("newnavs_b2_3");

startSubmenu("newnavs_b2_1","newnavs_menu",122);
submenuItem("Pastor","http://www.carolinachurch.org/pastor.htm","","newnavs_plain");
submenuItem("Our First Lady","http://www.carolinachurch.org/First%20Lady.htm","","newnavs_plain");
submenuItem("Ministerial Staff","http://www.carolinachurch.org/MinisterialStaff.htm","","newnavs_plain");
submenuItem("Deacons and Trustees","http://www.carolinachurch.org/Ministries-Leadership.htm#Deacons","","newnavs_plain");
submenuItem("Administrative Staff","http://www.carolinachurch.org/AdminStaff.htm","","newnavs_plain");
endSubmenu("newnavs_b2_1");

startSubmenu("newnavs_b2","newnavs_menu",122);
mainMenuItem("newnavs_b2_1","Our Leadership",0,0,"javascript:;","","",1,1,"newnavs_l");
submenuItem("Mission and Vision","http://www.carolinachurch.org/History.htm","","newnavs_plain");
mainMenuItem("newnavs_b2_3","Who We Are",0,0,"javascript:;","","",1,1,"newnavs_l");
submenuItem("Our History","http://www.carolinachurch.org/History.htm","","newnavs_plain");
submenuItem("Service Times","http://www.carolinachurch.org/Service Times.htm","","newnavs_plain");
submenuItem("Directions","http://www.carolinachurch.org/Directions.htm","","newnavs_plain");
endSubmenu("newnavs_b2");

loc="";
