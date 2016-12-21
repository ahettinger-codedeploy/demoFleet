/* Rollover Function */

function swapImage(imageID, imagePath) {
	var imgID;
	imgID = document.getElementById(imageID);
	imgID.src = imagePath;
}

// Spam-proof email by deanq.com
// Copyright © 2003. deanq.com
function email(who,domain,subject) {
  if (!domain) var domain = "pacific.edu";
  if (!subject) var subject = " ";
  var attrib = "width=1,height=1,resizable=1,toolbar=0,menubar=0,left=2000,top=2000,screenX=2000,screenY=2000,scrollbars=0";
  MyWindow=window.open('', "email", attrib);
  MyWindow.document.write("<HTML><HEAD><TITLE> <\/TITLE><META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'><\/HEAD><BODY leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad=\"javascript:location.href='mailto:" + who + "@" + domain + "?subject=" + subject + "'\" onBlur='window.close()' onFocus='window.close()'><\/BODY><\/HTML>");
  MyWindow.window.resizeTo(1, 1);
  MyWindow.document.title = " ";
  MyWindow.document.close();
}	

// Admission-specific popups to support flash detection

function tourpopup()
{	
	MM_openBrWindow('/admission/flash/onlinetour_detect.html','flashpopup','width=768,height=500');
	return false;
	window.focus()
}

function experiencepopup()
{	
	MM_openBrWindow('/admission/flash/pacific_experience_detect.html','flashpopup','width=768,height=500');
	return false;
	window.focus()
}

// Support for Photo Tour

// Set the category variable as the page loads
var category = 'Academics';

// Define some templates
var miniNavText = "Viewing [currentNum] of [totalNum] in [category]<br />";
var miniNavBoth = '<a href="[prevHref]">&lt;&lt; Previous</a> &nbsp;&nbsp; <a href="[nextHref]">Next &gt;&gt;</a>';
var miniNavPrevOnly = '<a href="[prevHref]">&lt;&lt; Previous</a> &nbsp;&nbsp; Next &gt;&gt;';
var miniNavNextOnly = '&lt;&lt; Previous &nbsp;&nbsp; <a href="[nextHref]">Next &gt;&gt;</a>';
var miniNavNeither = '&lt;&lt; Previous &nbsp;&nbsp; Next &gt;&gt;';

// Construct array of image locations
var images = new Array();
images["Academics"] = new Array('Images/about/photo_tour/Academics/', '0032-BUScls-02js.jpg','0039-BUScls-02.jpg','IMG_1040_0191.jpg','Study1.jpg','Ncomputer.jpg');
images["The Quad Community"] = new Array('Images/about/photo_tour/ResidenceHalls/quad/','0001-JohnB-04lm.jpg','0002-quad-97ep.jpg','DSC_1273.jpg','IMG_7643.jpg','IMG_7686.jpg','JohnB.jpg');
images["Fraternity and Sorority Communities"] = new Array('Images/about/photo_tour/ResidenceHalls/greek/', 'AlphaPhi.jpg','deltadeltadelta.jpg','DeltaGamma.jpg','DSC_1337.jpg','OmegaDeltaUpsilon.jpg','Pike.jpg','SigmaChi.jpg');
images["Grace Covell Hall"] = new Array('Images/about/photo_tour/ResidenceHalls/grace/', '0014-RESsw-03-sg.jpg','DSC_1308.jpg','DSC_1324.jpg','IMG_7584.jpg','IMG_7797.jpg');
images["Brookside Hall Apartments"] = new Array('Images/about/photo_tour/ResidenceHalls/brookside/', 'Brookside.jpg','IMG_7717.jpg','IMG_7733.jpg','Monagan.jpg','NBrookside.jpg');
images["Townhouse Apartments"] = new Array('Images/about/photo_tour/ResidenceHalls/townhouse/', 'TownhouseB.jpg','TownhouseC.jpg');
images["McConchie Residence Hall"] = new Array('Images/about/photo_tour/ResidenceHalls/mcconchie/', 'McConchie.jpg');
images["Manor Apartment Community"] = new Array('Images/about/photo_tour/ResidenceHalls/manor/', 'Manor.jpg','Manor_Courtyard2.jpg','Manor_Courtyard.jpg');
images["Life at Pacific"] = new Array('Images/about/photo_tour/StudentLife/', '0002-quad-02-js.jpg','DSC_1343.jpg','IMG_7677.jpg','Ndorm_life.jpg','Nrock_climb.jpg');
images["Pacific Stockton Campus"] = new Array('Images/about/photo_tour/PacificCampus/', '0006-ROSwbr-02.jpg','0015-AERand-98.jpg','1064-16-ANDros-97.jpg','Nchapel.jpg','PA300061.jpg');
images["Athletics"] = new Array('Images/about/photo_tour/Athletics/', 'klein_field.jpg','mens_basketball_overhead.jpg','pool.jpg','powercat.jpg','spanos_basketball.jpg');
images["Dining Services"] = new Array('Images/about/photo_tour/Dining/', '0001-STLdin-00js.jpg','0002-STLdin-00js.jpg','0002-STLsmt-01lm.jpg','0005-STLdin-00js.jpg','law-dining.jpg');

// Construct array of captions
var captions = new Array();
captions["Academics"] = new Array('','Office hours are a great way to stay on top of your classes','Who says work can\'t be fun?','A little late night review at the library','There are always people around to study with','Hard at work');
captions["The Quad Community"] = new Array('','Jessie Ballantyne House','Eiselen House','A room (single) prior to move-in day','One of the residence hall lounges (soon to be remodeled!)','Eiselen House','John Ballantyne House');
captions["Fraternity and Sorority Communities"] = new Array('', 'Alpha Phi Sorority House','Tri Delta Sorority House','Delta Gamma Sorority House','Kappa Alpha Theta Sorority House','Omega Delta Upsilon Fraternity House','Pi Kappa Alpha Fraternity House','Sigma Chi Fraternity House');
captions["Grace Covell Hall"] = new Array('', 'Southwest Hall','A room (double) in Southwest Hall','A room (single) in Southwest Hall','Grace Covell Hall','Southwest Hall');
captions["Brookside Hall Apartments"] = new Array('', 'Brookside Hall Apartments Hall','Monagan Hall','Welcome to Brookside Hall Apartments','Monagan Hall','Out front of Brookside Hall Apartments Hall');
captions["Townhouse Apartments"] = new Array('', 'Townhouse Apartments, block B','Townhouse Apartments, block C');
captions["McConchie Residence Hall"] = new Array('', 'McConchie Hall');
captions["Manor Apartment Community"] = new Array('', 'Manor Hall','Manor Hall houses a beautiful courtyard in its center','Manor Hall\'s courtyard');
captions["Life at Pacific"] = new Array('', 'These students break from their hard work to strike a pose','Alpha Phi girls have a good laugh in their common room','Almost done with that essay!','Many students add a personal touch to their rooms','The rock wall is just one of many services offered at Baun Fitness Center');
captions["Pacific Stockton Campus"] = new Array('', 'Pacific\'s prized Rose Garden','Lush greenery can be found all over Pacific\'s campus','Another glimpse of the relaxing plant life around campus','The chapel here on campus','A common sight around campus - beautiful in the fall');
captions["Athletics"] = new Array('', 'A game of baseball at Klein Field','The guys go head to head in an intense basketball game','Swimmers dive in at our pool','Power Cat firing t-shirts in to a spirited crowd','Spanos Center provides the big-stadium feel');
captions["Dining Services"] = new Array('', 'The Quad Dining Hall provides good food and a relaxing environment','You\'ve got to eat to be successful','Pacific\'s own: the Summit Cafe','Always bustling at the dining hall','Students enjoy a quick snack at the Summit Cafe');

// Function to change category and display the first image
function setCategory(cat) {
	category = cat;
	displayPic(1);
}

// Function to display the image
function displayPic(picID) {
	nextPicID = picID+1;
	prevPicID = picID-1;
	
	var caption = captions[category][picID];
	
	picURL = images[category][0];
	picURL+= images[category][picID];
	
	totalImages = images[category].length -1;
	
	// Choose what mini nav template to use
	if(picID == 1) {
		if(picID == totalImages) {
			var tpl = miniNavNeither;
		}else{
			var tpl = miniNavNextOnly;
			var nextHref = "javascript:displayPic("+nextPicID+")";
			tpl = tpl.replace('[nextHref]', nextHref);
		}
	}else if(picID == totalImages) {
		var tpl = miniNavPrevOnly;
		var prevHref = "javascript:displayPic("+prevPicID+")";
		tpl = tpl.replace('[prevHref]', prevHref);
	}else{
		var tpl = miniNavBoth;
		var nextHref = "javascript:displayPic("+nextPicID+")";
		tpl = tpl.replace('[nextHref]', nextHref);
		var prevHref = "javascript:displayPic("+prevPicID+")";
		tpl = tpl.replace('[prevHref]', prevHref);
	}
	
	document.getElementById("mini-nav").innerHTML = tpl;
	
	strHTML = '<p>Viewing <b>';
	strHTML+= picID;
	strHTML+= ' of ';
	strHTML+= totalImages;
	strHTML+= '</b> in <b>';
	strHTML+= category;
	strHTML+= '</b><br />';
	strHTML+= '<div style="background-color:#EDE8DD;margin-top:10px;margin-bottom:10px;">';
	strHTML+= caption;
	strHTML+= '</div>';
	strHTML+= '<img src="';
	strHTML+= picURL;
	strHTML+= '" />';
	document.getElementById("display").innerHTML = (strHTML);	
}

// If this page has a display div, display a picture when the page loads
if(document.getElementById("display")) {
	 displayPic(1);
}


// Support for Google Maps

