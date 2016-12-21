//©Xara Ltd
if(typeof(loc)=="undefined"||loc==""){var loc="";if(document.body&&document.body.innerHTML){var tt=document.body.innerHTML;var ml=tt.match(/["']([^'"]*)menubar.js["']/i);if(ml && ml.length > 1) loc=ml[1];}}

var bd=0
document.write("<style type=\"text/css\">");
document.write("\n<!--\n");
document.write(".menubar_menu {z-index:999;border-color:#000000;border-style:solid;border-width:"+bd+"px 0px "+bd+"px 0px;background-color:#3656cf;position:absolute;left:0px;top:0px;visibility:hidden;}");
document.write(".menubar_plain, a.menubar_plain:link, a.menubar_plain:visited{text-align:left;background-color:#3656cf;color:#ffffff;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.menubar_plain:hover, a.menubar_plain:active{background-color:#9aaae7;color:#000000;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("\n-->\n");
document.write("</style>");

var fc=0x000000;
var bc=0x9aaae7;
if(typeof(frames)=="undefined"){var frames=0;}

startMainMenu("",0,0,2,0,0)
mainMenuItem("menubar_b1",".gif",19,75,"http://www.ruckusinthecage.com","","HOME",2,2,"menubar_plain");
mainMenuItem("menubar_b2",".gif",19,75,"http://www.ruckusinthecage.com/tickets3.htm","","TICKETS",2,2,"menubar_plain");
mainMenuItem("menubar_b3",".gif",19,75,"http://www.ruckusinthecage.com/News.htm","","NEWS",2,2,"menubar_plain");
mainMenuItem("menubar_b4",".gif",19,75,"javascript:;","","RULES",2,2,"menubar_plain");
mainMenuItem("menubar_b5",".gif",19,75,"http://www.ruckusinthecage.com/Signup.htm","","SIGN UP",2,2,"menubar_plain");
mainMenuItem("menubar_b6",".gif",19,75,"javascript:;","","FIGHTERS ",2,2,"menubar_plain");
mainMenuItem("menubar_b7",".gif",19,75,"http://www.ruckusinthecage.com/Results.htm","","RESULTS",2,2,"menubar_plain");
mainMenuItem("menubar_b8",".gif",19,75,"http://www.ruckusinthecage.com/CageGirls.htm","","CAGE GIRLS",2,2,"menubar_plain");
mainMenuItem("menubar_b9",".gif",19,75,"http://www.ruckusinthecage.com/contact.html","","CONTACT ",2,2,"menubar_plain");
endMainMenu("",0,0);

startSubmenu("menubar_b6","menubar_menu",130);
submenuItem("Title Holders","http://www.ruckusinthecage.com/TitleHolders.htm","","menubar_plain");
submenuItem("Roanoke, VA - Apr. 12","http://www.ruckusinthecage.com/RoanokeInfo5.htm","","menubar_plain");
endSubmenu("menubar_b6");

startSubmenu("menubar_b4","menubar_menu",90);
submenuItem("North Carolina","http://www.ruckusinthecage.com/RulesNC.htm","","menubar_plain");
submenuItem("Virginia","http://www.ruckusinthecage.com/rules.htm","","menubar_plain");
endSubmenu("menubar_b4");

loc="";
