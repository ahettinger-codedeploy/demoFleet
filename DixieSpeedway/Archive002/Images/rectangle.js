//©Xara Ltd
if(typeof(loc)=="undefined"||loc==""){var loc="";if(document.body&&document.body.innerHTML){var tt=document.body.innerHTML;var ml=tt.match(/["']([^'"]*)rectangle.js["']/i);if(ml && ml.length > 1) loc=ml[1];}}

var bd=0
document.write("<style type=\"text/css\">");
document.write("\n<!--\n");
var tr="filter:alpha(opacity=75);-moz-opacity:0.75;";if(IE5) tr="";
document.write(".rectangle_menu {"+tr+"z-index:999;border-color:#000000;border-style:solid;border-width:"+bd+"px 0px "+bd+"px 0px;background-color:#000000;position:absolute;left:0px;top:0px;visibility:hidden;}");
document.write(".rectangle_plain, a.rectangle_plain:link, a.rectangle_plain:visited{text-align:left;background-color:#000000;color:#ffffff;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:11px 0px 11px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.rectangle_plain:hover, a.rectangle_plain:active{background-color:#ff0000;color:#000000;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:11px 0px 11px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.rectangle_l:link, a.rectangle_l:visited{text-align:left;background:#000000 url("+loc+"rectangle_l.gif) no-repeat right;color:#ffffff;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:11px 0px 11px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.rectangle_l:hover, a.rectangle_l:active{background:#ff0000 url("+loc+"rectangle_l2.gif) no-repeat right;color: #000000;text-decoration:none;border-color:#000000;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:11px 0px 11px 0px;cursor:hand;display:block;font-size:8pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("\n-->\n");
document.write("</style>");

var fc=0x000000;
var bc=0xff0000;
if(typeof(frames)=="undefined"){var frames=6;if(frames>0)animate();}

startMainMenu("",0,0,2,0,0)
mainMenuItem("rectangle_b1",".gif",20,66,loc+"/indexX.php","","Home",2,2,"rectangle_plain");
mainMenuItem("rectangle_b2",".gif",20,69,"javascript:;","","Press",2,2,"rectangle_plain");
mainMenuItem("rectangle_b3",".gif",20,90,loc+"/schedule.php","","Schedule",2,2,"rectangle_plain");
mainMenuItem("rectangle_b4",".gif",20,79,"http://racing01.50webs.com/praterphoto/Home.html","_blank","Points",2,2,"rectangle_plain");
mainMenuItem("rectangle_b5",".gif",20,125,"javascript:;","","Gallery",2,2,"rectangle_plain");
mainMenuItem("rectangle_b6",".gif",20,103,"javascript:;","","Driver Info",2,2,"rectangle_plain");
mainMenuItem("rectangle_b7",".gif",20,109,loc+"/advertising.php","","Advertising",2,2,"rectangle_plain");
mainMenuItem("rectangle_b8",".gif",20,95,loc+"/sponsors.php","","Sponsors",2,2,"rectangle_plain");
mainMenuItem("rectangle_b9",".gif",20,78,loc+"/search.php","","Search",2,2,"rectangle_plain");
mainMenuItem("rectangle_b10",".gif",20,87,loc+"/contact.php","","Contact",2,2,"rectangle_plain");
endMainMenu("",0,0);

startSubmenu("rectangle_b6_2","rectangle_menu",144);
submenuItem("Track Rules",loc+"/Uploads/TrackRules.pdf","_blank","rectangle_plain");
submenuItem("LateModels",loc+"/Uploads/SuperLateModel.pdf","_blank","rectangle_plain");
submenuItem("Late Model Drawing",loc+"/Uploads/LateModelDrawings.pdf","_blank","rectangle_plain");
submenuItem("Limited Late Models",loc+"/Uploads/LimitedLateModel.pdf","_blank","rectangle_plain");
submenuItem("Crate Late Models",loc+"/Uploads/CrateLateModels.pdf","_blank","rectangle_plain");
submenuItem("Super Bomber",loc+"/Uploads/SuperBomber.pdf","_blank","rectangle_plain");
submenuItem("Economy Bomber",loc+"/Uploads/EconomyBomber.pdf","_blank","rectangle_plain");
submenuItem("Cruiser",loc+"/Uploads/CruiserCars.pdf","_blank","rectangle_plain");
submenuItem("6-Cylinder Demo Car",loc+"/Uploads/V6Demo.pdf","_blank","rectangle_plain");
submenuItem("Full-size Demo Car",loc+"/Uploads/FullSizeCarDemo.pdf","_blank","rectangle_plain");
submenuItem("Dixie Pony",loc+"/Uploads/DixiePony.pdf","_blank","rectangle_plain");
submenuItem("Protest and Claim Rules",loc+"/Uploads/ProtestandClaim.pdf","_blank","rectangle_plain");
endSubmenu("rectangle_b6_2");

startSubmenu("rectangle_b6","rectangle_menu",126);
submenuItem("Attention Drivers",loc+"/drivernotes.php","","rectangle_plain");
mainMenuItem("rectangle_b6_2","Rules",0,0,"javascript:;","","",1,1,"rectangle_l");
submenuItem("Tires",loc+"/buytires.php","","rectangle_plain");
submenuItem("Results",loc+"/results.php","","rectangle_plain");
submenuItem("Point Standings",loc+"/points.php","","rectangle_plain");
submenuItem("Press Releases",loc+"/news.php","","rectangle_plain");
endSubmenu("rectangle_b6");

startSubmenu("rectangle_b5","rectangle_menu",125);
submenuItem("Area Map","http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=Woodstock,+GA&sll=36.456636,-95.712891&sspn=51.192203,78.662109&ie=UTF8&hq=&hnear=Woodstock,+Cherokee,+Georgia&ll=34.101571,-84.519196&spn=0.838067,1.229095&z=10","","rectangle_plain");
submenuItem("Facility Map",loc+"/Uploads/TrackDiagram.pdf","_blank","rectangle_plain");
submenuItem("Directions",loc+"/directions.php","","rectangle_plain");
submenuItem("Fan FAQ",loc+"/faq.php","","rectangle_plain");
submenuItem("Store",loc+"/store.php","","rectangle_plain");
submenuItem("Lodging",loc+"/lodging.php","","rectangle_plain");
submenuItem("Facebook","http://www.facebook.com/pages/Woodstock-GA/Dixie-Speedway/470064400710","_blank","rectangle_plain");
submenuItem("Camping",loc+"/camping.php","","rectangle_plain");
submenuItem("Weather","http://www.weather.com/weather/local/USGA0631?from=search_city","_blank","rectangle_plain");
submenuItem("E-News Sign-Up","http://visitor.constantcontact.com/manage/optin?v=001Qo1SzxA2oRSxqMkmpO9AYmoBTHj76iVpKOvPYfaVsrp1QgyGLNSW3E_aWFWYRxwpu2Y4fBAM__l6qZegZN-znw%3D%3D","_blank","rectangle_plain");
submenuItem("Text Alerts Sign-Up","http://my.rainedout.com/13102802124b6070b4be2c1/","_blank","rectangle_plain");
submenuItem("History","http://www.youtube.com/watch?v=J3R--JbhLRk","_blank","rectangle_plain");
endSubmenu("rectangle_b5");

startSubmenu("rectangle_b2_3","rectangle_menu",36);
submenuItem("2009",loc+"/2009newsarchives.php","","rectangle_plain");
submenuItem("2008",loc+"/2008newsarchives.php","","rectangle_plain");
endSubmenu("rectangle_b2_3");

startSubmenu("rectangle_b2","rectangle_menu",119);
submenuItem("Results",loc+"/results.php","","rectangle_plain");
submenuItem("Press Releases",loc+"/news.php","","rectangle_plain");
mainMenuItem("rectangle_b2_3","News Archives",0,0,"javascript:;","","",1,1,"rectangle_l");
submenuItem("VIP Credentials",loc+"/vipcredentials.php","","rectangle_plain");
endSubmenu("rectangle_b2");

loc="";
