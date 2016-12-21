var thisbrowser17540305
var hidetimer17540305 = null;
if(document.layers){ thisbrowser17540305='NN4'; }
if(document.all){ thisbrowser17540305='IE'; }
if(!document.all && document.getElementById){ thisbrowser17540305='NN6'; }
function showmenu17540305(menuname)
{
if(thisbrowser17540305=='NN4') document.layers[menuname].visibility = 'visible';
if(thisbrowser17540305=='IE') document.all[menuname].style.visibility = 'visible';
if(thisbrowser17540305=='NN6') document.getElementById(menuname).style.visibility = 'visible';
}
function hidemenu17540305(menuname)
{
if(thisbrowser17540305=='NN4') document.layers[menuname].visibility = 'hidden';
if(thisbrowser17540305=='IE') document.all[menuname].style.visibility = 'hidden';
if(thisbrowser17540305=='NN6') document.getElementById(menuname).style.visibility = 'hidden';
}
function hilite17540305(menuitem) 
{
if(thisbrowser17540305=='IE') document.all[menuitem].style.backgroundColor = '#402B5E';
if(thisbrowser17540305=='NN6') document.getElementById(menuitem).style. backgroundColor = '#402B5E';
if(hidetimer17540305) clearTimeout(hidetimer17540305);}
function unhilite17540305(menuitem) 
{
if(thisbrowser17540305=='IE') document.all[menuitem].style.backgroundColor = '#000B70';
if(thisbrowser17540305=='NN6') document.getElementById(menuitem).style. backgroundColor = '#000B70';
if(hidetimer17540305) clearTimeout(hidetimer17540305);hidetimer17540305 = setTimeout("hideall17540305();",1000);}
function hideall17540305()
{
}
function time17540305()
{
if(hidetimer17540305) clearTimeout(hidetimer17540305);hidetimer17540305 = setTimeout("hideall17540305();",1000);
}
document.open();
document.write('<STYLE TYPE="text/css">#layerbg17540305 {POSITION:absolute; z-index:-1; LEFT:5px; TOP:400px; width:130px; height:200px; }</STYLE>');
document.write('<div id=layerbg17540305 onMouseOver="hideall17540305();"><table cellspacing=0 cellpadding=0 width="100%" height="100%"><tr><td>&nbsp;</td></tr></table></div>');
document.write('<STYLE TYPE="text/css">#DIV17540305 {POSITION:absolute; LEFT:10px; TOP:310px;}</STYLE>');
document.write('<STYLE TYPE="text/css">a.MNA17540305 {text-decoration:none; color:#FFFFFF; font-weight: 700; font-family: Verdana; font-size:11px; font-style:normal;} </STYLE>');
document.write('<STYLE TYPE="text/css">P.MN17540305 {color:#FFFFFF; font-weight: 700; font-family: Verdana; font-size:11px; font-style:normal;} </STYLE>');
document.write('<STYLE TYPE="text/css">a.MNA17540305:hover {text-decoration:none; color:#F20008; }</STYLE>');
document.write('<STYLE TYPE="text/css">a.SMNA17540305 {text-decoration:none; color:#FCFCFC; font-weight: 700; font-family: Verdana; font-size:12px; font-style:normal;} </STYLE>');
document.write('<STYLE TYPE="text/css">a.SMNA17540305:hover {text-decoration:none; color:#11FF00; }</STYLE>');
document.write('<STYLE TYPE="text/css">P.SMN17540305 {text-decoration:none; color:#FCFCFC; font-weight: 700; font-family: Verdana; font-size:12px; font-style:normal;} </STYLE>');
document.write('<STYLE TYPE="text/css">table.SMT17540305 {background:#FF070C; border:1 ridge #B20006; }');
document.write('td.MTD17540305 {padding-left:4; padding-right:4; background:#000B70; border:0 inset #FAF9FF; }');
document.write('.MTI17540305 {color:#FFFFFF; font-weight: 700; font-family: Verdana; font-size: 11px; font-style:normal;}');
document.write('.MSI17540305 {color:#FCFCFC; font-weight: 700; font-family: Verdana; font-size: 12px; font-style:normal;}</STYLE>');
document.write('<div id=DIV17540305><table border=0 cellspacing=0 cellpadding=0 width=120><TR><TD ><table border=0 cellspacing=0 cellpadding=3 class="MT17540305"  width="100%">');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://durangoconcerts.tix.com" target="_self" title="">TICKETS</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://chronos.fortlewis.edu/wv3b/wv3b_servlet/urd/run/wv_event.MonthList?evfilter=26051,ebdviewmode=grid" target="_blank" title="">CALENDAR</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/newslet.html" target="_self" title="">NEWSLETTER</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/seating.html" target="_self" title="">SEATING CHART</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="" target="_self" title=""></a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/gentech.html" target="_self" title="">GENERAL INFO</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/rentalinfo.html" target="_self" title="">TECHNICAL INFO</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/personnel.html" target="_self" title="">CONTACT US</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="" target="_self" title=""></a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/maps.html" target="_self" title="">MAPS</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/durango.html" target="_self" title="">DURANGO</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/benefactors.htm" target="_self" title="">CONCERT HALL BENEFACTORS</a></td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td align=LEFT width="100%" height=20 bgcolor=#000000>');document.write('<a class="MNA17540305" onMouseOver="hideall17540305();" onMouseOut="time17540305();" href="http://www.durangoconcerts.com/non-profit_alliances.htm" target="_self" title="">NON-PROFIT ALLIANCES</a></td>');
document.write('</tr>');
document.write('</table></TD></TR></table></div><p>');

document.close();
