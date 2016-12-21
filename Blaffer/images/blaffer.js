// JavaScript Document
var pArr = new Array(0,1,2,3,4,5,6);
//
function swapBackground(el,clr) {
	document.getElementById(el).style.backgroundColor = clr;
}
//
function swapBackgroundOver(el,img) {
	document.getElementById(el).style.backgroundImage = 'url(/clients/blaffer/images/nav_on/'+img+'.gif)';
}
//
function swapBackgroundOut(el,img) {
	document.getElementById(el).style.backgroundImage = 'url(/clients/blaffer/images/nav_off/'+img+'.gif)';
}
//
function switchBackground(el,cl,tc) {
	document.getElementById(el).style.backgroundColor = cl;
	document.getElementById(el).style.color = tc;
}
//
function goLink(lnk) {
	document.location = lnk;
}
//
function popSub(num) {
	for (var n in pArr) {
		var conID = 'p'+pArr[n];
		document.getElementById(conID).style.display = 'none';
		document.getElementById(conID).style.visibility = 'hidden';
	}
	for (i = 0; i < 7; i ++) {
		if (i != num) {
			swapBackgroundOut('tn'+i,'topnav_0'+i);
		}
	}
	var conID = 'p'+num;
	document.getElementById(conID).style.display = 'block';
	document.getElementById(conID).style.visibility = 'visible';
	swapBackgroundOver('tn'+num,'topnav_0'+num);
}
//
function hideAll() {
	for (i = 0; i < 7; i ++) {
		var conID = 'p'+pArr[i];
		document.getElementById(conID).style.display = 'none';
		document.getElementById(conID).style.visibility = 'hidden';
		swapBackgroundOut('tn'+i,'topnav_0'+i);
	}
}
//
function buildPop(num,ttl) {
	var str = '';
	str += '<div class="popmenu" id="p'+num+'">';
	str += '<div class="sublinks">';
	var arr = eval('nav'+num+'arr');
	for (i = 0; i < arr.length; i ++) {
		str += '<div class="sublink" onMouseOver="switchBackground(\'tl'+num+i+'\',\'#ffffff\',\'#00b9fe\')" ';
		str += 'onMouseOut="switchBackground(\'tl'+num+i+'\',\'#dad9ca\',\'#000000\')" onClick="goLink(\''+arr[i][0]+'\')" ';
		str += 'id="tl'+num+i+'" title="'+arr[i][2]+'">';
		str += arr[i][2]+'<a href="'+arr[i][0]+'">'+arr[i][2]+'</a></div>';
	}
	str += '</div></div>';
	document.write(str);
}
//
function buildPop_backup(num,ttl) {
	var str = '';
	str += '<div class="popmenu" id="p'+num+'">';
	str += '<div class="sublinks">';
	var arr = eval('nav'+num+'arr');
	for (i = 0; i < arr.length; i ++) {
		str += '<div class="sublink" onMouseOver="swapBackgroundOver(\'sl'+num+i+'\',\''+arr[i][1]+'\');"';
		str += ' onMouseOut="swapBackgroundOut(\'sl'+num+i+'\',\''+arr[i][1]+'\');"';
		str += ' onClick="goLink(\''+arr[i][0]+'\')" id="sl'+num+i+'" title="'+arr[i][2]+'">';
		str += '<a href="'+arr[i][0]+'">'+arr[i][2]+'</a></div>';
	}
	str += '</div></div>';
	document.write(str);
}
//
var nav1arr = new Array();
nav1arr.push(['http://www.class.uh.edu/blaffer/about_blaffer.html','SN_about','About the Museum']);
nav1arr.push(['http://www.class.uh.edu/blaffer/director_letter.html','SN_director_letter','Director&rsquo;s Letter']);
nav1arr.push(['http://www.class.uh.edu/blaffer/staff.html','SN_staff','Staff']);
nav1arr.push(['http://www.class.uh.edu/blaffer/history.html','SN_history','History']);
nav1arr.push(['http://www.class.uh.edu/blaffer/employment.html','SN_employment','Employment']);
nav1arr.push(['http://www.class.uh.edu/blaffer/press_room.html','SN_press_room','Press Releases']);
nav1arr.push(['http://www.class.uh.edu/blaffer/image_room.html','SN_image_room','Press /clients/blaffer/images']);
nav1arr.push(['http://www.class.uh.edu/blaffer/blaffer_magazine.html','SN_blaffer_magazine','Blaffer Magazine']);
nav1arr.push(['http://www.class.uh.edu/blaffer/interactive_media.html','SN_interactive_media','Interactive/Social Media']);

//
var nav3arr = new Array();
nav3arr.push(['http://www.class.uh.edu/blaffer/exhibitions.html','SN_current_exhibitions','Current Exhibitions']);
nav3arr.push(['http://www.class.uh.edu/blaffer/upcoming_exhibitions.html','SN_upcoming_exhibitions','Upcoming Exhibitions']);
nav3arr.push(['http://www.class.uh.edu/blaffer/past_exhibitions_2011.html','SN_past_exhibitions','Past Exhibitions']);
nav3arr.push(['http://www.class.uh.edu/blaffer/traveling_exhibitions.html','SN_traveling_exhibitions','Traveling Exhibitions']);
nav3arr.push(['http://www.class.uh.edu/blaffer/catalogues.html','SN_catalogues','Catalogues']);
//
var nav4arr = new Array();
nav4arr.push(['http://www.class.uh.edu/blaffer/support.html','SN_support','Donate']);
nav4arr.push(['http://www.class.uh.edu/blaffer/individual_memberships.html','SN_individual_memberships','Become a Member!']);
nav4arr.push(['http://www.class.uh.edu/blaffer/orporate_sponsorships.html','SN_corporate_sponsorships','Corporate Sponsorships']);
nav4arr.push(['http://www.class.uh.edu/blaffer/social_events.html','SN_social_events','Social Events']);
nav4arr.push(['http://www.class.uh.edu/blaffer/annual_fund.html','SN_annual_fund','Annual Fund']);
//
var nav5arr = new Array();
nav5arr.push(['programs.html','SN_art_focus','Art Focus']);
//nav5arr.push(['tours.html','SN_tours','Tours']);
nav5arr.push(['http://www.class.uh.edu/blaffer/adult_programs.html','SN_adult_programs','Adult Programs']);
nav5arr.push(['http://www.class.uh.edu/blaffer/youth_programs.html','SN_youth_programs','Youth Programs']);
nav5arr.push(['http://www.class.uh.edu/blaffer/student_programs.html','SN_student_programs','Student Programs']);
nav5arr.push(['http://www.class.uh.edu/blaffer/faculty_programs.html','SN_faculty_programs','Faculty Programs']);
nav5arr.push(['http://www.class.uh.edu/blaffer/blaffer_alumni_group.html','SN_blaffer_alumni_group','Blaffer Alumni Group']);
//
var nav6arr = new Array();
nav6arr.push(['http://www.class.uh.edu/blaffer/hours.html','SN_hours','Hours']);
//nav6arr.push(['directions.html','SN_directions','Directions']);
nav6arr.push(['http://www.class.uh.edu/blaffer/guided_tours.html','SN_guided_tours','Guided Tours']);
//
/* Build the gallery */
function gallClick(num) {
	for (i = 0; i < captionArray.length; i ++) {
		if (i == num) {
			document.getElementById('gb'+i).style.display = 'block';
			document.getElementById('gb'+i).style.visibility = 'visible';
			document.getElementById('gc'+i).style.display = 'block';
			document.getElementById('gc'+i).style.visibility = 'visible';
		} else {
			document.getElementById('gb'+i).style.display = 'none';
			document.getElementById('gb'+i).style.visibility = 'hidden';
			document.getElementById('gc'+i).style.display = 'none';
			document.getElementById('gc'+i).style.visibility = 'hidden';
		}
	}
	
}
//
function buildGallery(fold) {
	var gs;
	if (fold != "") {
		gs = "";
		gs += '<table border="0" width="270" cellpadding="0" cellspacing="0">';
		// build the big image
		gs += '<tr><td colspan="7" class="galbig">';
		for (i = 0; i < captionArray.length; i ++) {
			gs += '<div class="galhide" id="gb'+i+'"><img src="'+fold+'/big_'+(i+1)+'.jpg" width="269" height="200" title="'+captionArray[i][0]+'" alt="'+captionArray[i][0]+'"></div>';
		}
		gs += '</td></tr>';
		// build the captions
		gs += '<tr><td colspan="7" class="galcapbox" valign="top">';
		for (i = 0; i < captionArray.length; i ++) {
			gs += '<div class="galcapt" id="gc'+i+'">'+captionArray[i][1]+'</div>';
		}
		gs += '</td></tr>';
		// build the thumb rows
		var tc = 0;
		var rc = 0;
		for (i = 0; i < captionArray.length; i ++) {
			if (tc == 0) {	
				gs += '<tr>';
			}
			gs += '<td width="56" class="galthumb" onMouseOver="gallClick(\''+i+'\')">';
			gs += '<img src="'+fold+'/thumb_'+(i+1)+'.jpg" alt="'+captionArray[i][0]+'" title="'+captionArray[i][0]+'" width="56" height="56" border="0"></td>';
			tc ++;
			if (tc == 4) {
				gs += '</tr>';
				rc ++;
				tc = 0;
			} else {
				gs += '<td width="13"><img src="/clients/blaffer/images/nodot.gif" alt=" " width="13" height="15" /></td>';
			}
		}
		if (tc < 4) {
			for (i = tc; i < 4; i ++) {
				gs += '<td width="56"><img src="/clients/blaffer/images/nodot.gif" width="58" height="56" border="0"></td>';
				if (i < 4) {
					gs += '<td width="13"><img src="/clients/blaffer/images/nodot.gif" alt=" " width="13" height="15" /></td>';
				}
			}
			gs += '</tr>';
		}
		gs += '</table>';
		//
		document.write(gs);
		gallClick(0);
	}
}
//
function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}