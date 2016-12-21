<!-- Begin

// Document name = menu.js, draft 6
// Edit only items between quotes in ahref="xxxx" and name between carats < and >.
// NOTE: If you use a ' add a slash before it like this \'

// USE lowercase FOR ALL OPTIONS ONLY

var showimage1		= "no"		//  SHOW FIRST SIDEBAR IMAGE
var showimage2		= "no"		//  SHOW SECOND SIDEBAR IMAGE
var linkstop 		= "yes" 		//  START LINKS AT THE VERY TOP

document.write('<DIV id="menulocation" style="z-index: 10;">');
document.write('<TABLE cellpadding="0" cellspacing="0" border="0" width="154"><tr><td class="menutrans">');
   if (linkstop == "no") {
document.write('<img src="/PrivateLabel/DancePalace/Images/menu-top.gif" width="152" height="90"><br>');
}
document.write('<ul id="top-nav">');

// START MENU LINKS - EDIT BELOW THIS AREA

// Home menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/index.html">home</a></li>');

//Event Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/event.html">events</a>');
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/event.html">Annual Events</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/bulletin.pdf">Current Bulletin</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/thiswk.html">This Week</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/tix.html">Tickets</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/auction.html">Auctions</a></li>');
document.write('    </ul>');
document.write('  </li>');

// Calendar Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/1.html">calendars</a>');
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/1.html">January</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/2.html">Febuary</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/3.html">March</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/4.html">April</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/5.html">May</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/6.html">June</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/7.html">July</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/8.html">August</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/9.html">September</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/10.html">October</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/11.html">November</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/12.html">December</a></li>');
document.write('    </ul>');
document.write('  </li>');

// Programs Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/class.html">programs</a>'); 
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/class.html">Classes & Workshops</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/camp.html">Dance Palace Camp</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/serv.html">Community Services</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/lobby.html">Lobby Gallery</a></li>');
document.write('    </ul>');
document.write('  </li>');

// Volunteers Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/vol.html">volunteers</a>');
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/vol.html">Opportunities</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/volmon.html">Volunteer Of The Month</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/volsurv.html">Volunteer Survey</a></li>');
document.write('    </ul>');
document.write('  </li>');

// Facilities Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/frent.html">facilities</a>');
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/frent.html">Rental Rates</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/ffloor.html">Floor Plan</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/fpriv.html">Private Functions</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/fpol.html">Policies & Info</a></li>');
document.write('    </ul>');
document.write('  </li>');

// About Us Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/bod.html">about us</a>');
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/bod.html">Board of Directors</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/staff.html">Staff</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/hist.html">History</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/mail.html">Join Our Mailing List</a></li>');
document.write('    </ul>');
document.write('  </li>');

//Contributions Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/mem.html">contributions</a>');
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/mem.html">Membership</a></li>');
document.write('      <li><a href="give.html">Planned Giving</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/veh.html">Vehicle Donations</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/escript.html">E Script</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/stock.html">Stocks & Bonds</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/wish.html">Wish List</a></li>');
document.write('    </ul>');
document.write('  </li>');

// Directions Menu

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/ebay.html">directions</a>');
document.write('    <ul id="sub-nav">');
document.write('      <li><a href="http://www.dancepalace.org/ebay.html">East Bay</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/sanraf.html">San Rafael</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/nov.html">Novato</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/pet.html">Petaluma</a></li>');
document.write('      <li><a href="http://www.dancepalace.org/rosa.html">Santa Rosa</a></li>');
document.write('    </ul>');
document.write('  </li>');

//LINKS MENU//

document.write('  <li class="menuT"><a href="http://www.dancepalace.org/links.html">links</a></li>');

// END LINKS //

document.write('</ul>');
document.write('</td></tr><tr><td align="right">');

//  End -->


document.write('</td></tr></table></DIV>');


// COPYRIGHT 2005 © Keith Mathews
// Unauthorized use or sale of this script is strictly prohibited by law

// YOU DO NOT NEED TO EDIT BELOW THIS LINE

function IEHoverPseudo() {
IEHoverPseudo();
	var navItems = document.getElementById("top-nav").getElementsByTagName("li");
	
	for (var i=0; i<navItems.length; i++) {
		if(navItems[i].className == "menuT") {
			navItems[i].onmouseover=function() { this.className += " over"; }
			navItems[i].onmouseout=function() { this.className = "menuT"; }
		}
	}

}
//window.onload = IEHoverPseudo;