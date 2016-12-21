//©Xara Ltd
if(typeof(loc)=="undefined"||loc==""){var loc="";if(document.body&&document.body.innerHTML){var tt=document.body.innerHTML;var ml=tt.match(/["']([^'"]*)bold2.js["']/i);if(ml && ml.length > 1) loc=ml[1];}}

var bd=0
document.write("<style type=\"text/css\">");
document.write("\n<!--\n");
document.write(".bold2_menu {z-index:999;border-color:#000000;border-style:solid;border-width:"+bd+"px 0px "+bd+"px 0px;background-color:#ffffff;position:absolute;left:0px;top:0px;visibility:hidden;}");
document.write(".bold2_plain, a.bold2_plain:link, a.bold2_plain:visited{text-align:left;background-color:#ffffff;color:#660066;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:0px 0px 0px 0px;cursor:hand;display:block;font-size:10pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.bold2_plain:hover, a.bold2_plain:active{background-color:#ffffff;color:#ff0033;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:0px 0px 0px 0px;cursor:hand;display:block;font-size:10pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("\n-->\n");
document.write("</style>");

var fc=0xff0033;
var bc=0xffffff;
if(typeof(frames)=="undefined"){var frames=0;}

startMainMenu("bold2_left.gif",44,25,2,0,0)
mainMenuItem("bold2_b1",".gif",44,98,"http://www.acappellapops.com/home.asp","","Home",2,2,"bold2_plain");
mainMenuItem("bold2_b2",".gif",44,98,"http://acappellapops.com/about.shtml","","What we're all about",2,2,"bold2_plain");
mainMenuItem("bold2_b3",".gif",44,98,"http://www.acappellapops.com/quikview.asp","","Where We're Appearing",2,2,"bold2_plain");
mainMenuItem("bold2_b4",".gif",44,98,"http://www.acappellapops.com/galleries.shtml","","Photos and Sound Clips of the chorus",2,2,"bold2_plain");
mainMenuItem("bold2_b5",".gif",44,98,"http://www.acappellapops.com/contact.shtml","","Contact us for a performance or audition",2,2,"bold2_plain");
mainMenuItem("bold2_b6",".gif",44,98,"http://www.acappellapops.com/links.shtml","","Links to a cappella websites",2,2,"bold2_plain");
endMainMenu("bold2_right.gif",44,25)

startSubmenu("bold2_b6","bold2_menu",160);
submenuItem("A Cappella Links","http://www.acappellapops.com/links.shtml","","bold2_plain");
submenuItem("Yahoo Groups","http://groups.yahoo.com/group/acappellapops","_blank","bold2_plain");
submenuItem("Google A Cappella","http://groups.google.com/groups?q=group:rec.music.a-cappella","_blank","bold2_plain");
submenuItem("Members' Website","http://members.acappellapops.com/","","bold2_plain");
endSubmenu("bold2_b6");

startSubmenu("bold2_b5","bold2_menu",115);
submenuItem("Booking Info","http://www.acappellapops.com/booking.shtml","","bold2_plain");
submenuItem("Audition Info","http://www.acappellapops.com/auditions.shtml","","bold2_plain");
endSubmenu("bold2_b5");

startSubmenu("bold2_b4","bold2_menu",111);
submenuItem("Sound Clips","http://www.acappellapops.com/music.shtml","","bold2_plain");
submenuItem("Photos","http://www.acappellapops.com/photos.shtml","","bold2_plain");
endSubmenu("bold2_b4");

startSubmenu("bold2_b3","bold2_menu",204);
submenuItem("Where We're Appearing","http://www.acappellapops.com/quikview.asp","","bold2_plain");
submenuItem("Where We've Been","http://www.acappellapops.com/quikview.asp?cmd=been","","bold2_plain");
endSubmenu("bold2_b3");

loc="";
