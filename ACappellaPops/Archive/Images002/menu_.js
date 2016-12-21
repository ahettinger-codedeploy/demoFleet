if(typeof(loc)=="undefined"||loc==""){var loc="";if(document.body&&document.body.innerHTML){var tt=document.body.innerHTML.toLowerCase();var last=tt.indexOf("menu_.js\"");if(last>0){var first=tt.lastIndexOf("\"",last);if(first>0&&first<last)loc=document.body.innerHTML.substr(first+1,last-first-1);}}}

var bd=0
document.write("<style type=\"text/css\">");
document.write("\n<!--\n");
document.write(".menu__menu {border-color:#000000;border-style:solid;border-width:"+bd+"px 0px "+bd+"px 0px;background-color:#d9000e;position:absolute;left:0px;top:0px;visibility:hidden;}");
document.write("a.menu__plain:link, a.menu__plain:visited{text-align:left;background-color:#d9000e;color:#ffffff;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("a.menu__plain:hover, a.menu__plain:active{background-color:#0fe900;color:#000000;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("\n-->\n");
document.write("</style>");

var fc=0x000000;
var bc=0x0fe900;
if(typeof(frames)=="undefined"){var frames=0;}

startMainMenu("images/menu__top.jpg",27,122,1,0,0)
mainMenuItem("images/menu__b1",".jpg",41,122,"http://www.acappellapops.com/","","Home",2,2,"menu__plain");
mainMenuItem("images/menu__b2",".jpg",41,122,"http://www.acappellapops.com/introduction.shtml","","About Us",2,2,"menu__plain");
mainMenuItem("images/menu__b3",".jpg",41,122,"http://www.acappellapops.com/quikview.asp","","Calendar",1,2,"menu__plain");
mainMenuItem("images/menu__b4",".jpg",41,122,"http://www.acappellapops.com/music.shtml","","Our Music",2,2,"menu__plain");
mainMenuItem("images/menu__b5",".jpg",41,122,"http://www.acappellapops.com/XcNews.asp","","Chorus News",2,2,"menu__plain");
mainMenuItem("images/menu__b6",".jpg",41,122,"http://www.acappellapops.com/album.shtml","","Photo Album",2,2,"menu__plain");
mainMenuItem("images/menu__b7",".jpg",41,122,"http://www.acappellapops.com/membersonly.shtml","","Members Only",2,2,"menu__plain");
mainMenuItem("images/menu__b8",".jpg",41,122,"http://www.acappellapops.com/links.shtml","","A Cappella Links",1,2,"menu__plain");
endMainMenu("images/menu__bottom.jpg",27,122)

startSubmenu("menu__b8","menu__menu",163);
submenuItem("Yahoo Groups","http://groups.yahoo.com/group/acappellapops","_blank","menu__plain");
submenuItem("Google A Cappella Forum","http://groups.google.com/groups?q=group:rec.music.a-cappella","_blank","menu__plain");
endSubmenu("menu__b8");

startSubmenu("menu__b3","menu__menu",124);
submenuItem("Where We've Been","quikview.asp?cmd=been","","menu__plain");
endSubmenu("menu__b3");

loc="";
