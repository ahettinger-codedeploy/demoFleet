
/*
Milonic DHTML Menu - JavaScript Website Navigation System.
Copyright 2004 (c) Milonic Solutions Limited. All Rights Reserved.
Version 5+ Data File structure is the property of Milonic Solutions Ltd and must only be used in Milonic DHTML Products
This is a commercial software product, please visit http://www.milonic.com/ for more information.
See http://www.milonic.com/license.php for Commercial License Agreement
All Copyright statements must always remain in place in all files at all times
*******  PLEASE NOTE: THIS IS NOT FREE SOFTWARE, IT MUST BE LICENSED FOR ALL USE  ******* 
*/

_menuCloseDelay=500           // The time delay for menus to remain visible on mouse out
_menuOpenDelay=10           // The time delay before menus open on mouse over
_subOffsetTop=5               // Sub menu top offset
_subOffsetLeft=-10            // Sub menu left offset



with(menuStyle=new mm_style()){
onbgcolor="#D3D2B6";
oncolor="#000000";
offbgcolor="#ffffff";
offcolor="#000000";
bordercolor="#D3D2B6";
borderstyle="solid";
borderwidth=1;
separatorcolor="#D3D2B6";
separatorsize="1";
padding=3;
fontsize="75%";
fontstyle="normal";
fontfamily="Verdana, Tahoma, Arial";
pagecolor="black";
pagebgcolor="#ffffff";
headercolor="#000000";
headerbgcolor="#ffffff";
subimage="/PrivateLabel/CobbSymphony/Images/arrow.gif";
subimagepadding="2";
overfilter="Fade(duration=0.2);Alpha(opacity=90);Shadow(color='#777777', Direction=135, Strength=5)";
outfilter="randomdissolve(duration=0.3)";
}






with(milonic=new menuname("Links")){
style=menuStyle;
aI("url=http://www.cobbsymphony.com/history.html;status=History;image=/PrivateLabel/CobbSymphony/Images/3a.gif;");
aI("url=http://www.cobbsymphony.com/boardoftrustees.html;status=Board of Trustees;image=/PrivateLabel/CobbSymphony/Images/3b.gif;");
aI("url=http://www.cobbsymphony.com/theconductor.html;status=The Conductor;image=/PrivateLabel/CobbSymphony/Images/3c.gif;");
aI("url=http://www.cobbsymphony.com/guestartists.html;status=Guest Artists;image=/PrivateLabel/CobbSymphony/Images/3d.gif;");
aI("url=http://www.cobbsymphony.com/orchestrapersonnel.html;status=Orchestra Personnel;image=/PrivateLabel/CobbSymphony/Images/3e.gif;")
}

with(milonic=new menuname("Links2")){
style=menuStyle;
aI("url=http://www.cobbsymphony.com/supportthecso.html;status=Support the CSO;image=/PrivateLabel/CobbSymphony/Images/4c.gif;");
aI("url=http://www.cobbsymphony.com/oursponsors.html;status=Our Sponsors;image=/PrivateLabel/CobbSymphony/Images/4a.gif;");
aI("url=http://www.cobbsymphony.com/sponsorshiplevels.html;status=Sponsorship Levels;image=/PrivateLabel/CobbSymphony/Images/4b.gif;");
}

with(milonic=new menuname("Links3")){
style=menuStyle;
aI("url=http://www.cobbsymphony.com/inthespotlight.html;status=In the Spotlight;image=/PrivateLabel/CobbSymphony/Images/5a.gif;");
aI("url=http://www.cobbsymphony.com/newsreleases.html;status=News Releases;image=/PrivateLabel/CobbSymphony/Images/5b.gif;");
aI("url=http://www.cobbsymphony.com/csoguildnews.html;status=CSO Guild News;image=/PrivateLabel/CobbSymphony/Images/5c.gif;");
}

drawMenus();

