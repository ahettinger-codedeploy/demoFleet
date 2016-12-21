/* Website global functions */
function checkNavLocation()
{
	var navLocation = window.location.toString()
	var nNavAboutValid =  navLocation.indexOf("aboutpacific.asp",0)
	if(nNavAboutValid != -1) {
		MM_swapImage('Image16','','images/homelinksover_01.gif',1)
		}
	var nNavAcademicsValid =  navLocation.indexOf("academics.asp",0)
	if(nNavAcademicsValid != -1) {
		MM_swapImage('Image31','','images/homelinksover_03.gif',1)
		}
	var nNavAdmissionsValid =  navLocation.indexOf("admissions.asp",0)
	if(nNavAdmissionsValid != -1) {
		MM_swapImage('Image30','','images/homelinksover_02.gif',1)
		}
	var nNavAlumniValid =  navLocation.indexOf("alumni.asp",0)
	if(nNavAlumniValid != -1) {
		MM_swapImage('Image23','','images/homelinksover_08.gif',1)
		}
	var nNavStudentValid =  navLocation.indexOf("studentlife.asp",0)
	if(nNavStudentValid != -1) {
		MM_swapImage('Image19','','images/homelinksover_04.gif',1)
		}
	var nNavAthleticsValid =  navLocation.indexOf("athletics.asp",0)
	if(nNavAthleticsValid != -1) {
		MM_swapImage('Image20','','images/homelinksover_05.gif',1)
		}
	var nNavNewsValid =  navLocation.indexOf("news.asp",0)
	if(nNavNewsValid != -1) {
		MM_swapImage('Image21','','images/homelinksover_06.gif',1)
		}
	var nNavGivingValid =  navLocation.indexOf("giving.asp",0)
	if(nNavGivingValid != -1) {
		MM_swapImage('Image24','','images/homelinksover_09.gif',1)
		}
	var nNavIntranetValid =  navLocation.indexOf("intranet.asp",0)
	if(nNavIntranetValid != -1) {
		MM_swapImage('Image26','','images/homelinksover_11.gif',1)
		}
	var nNavEmploymentValid =  navLocation.indexOf("employment.asp",0)
	if(nNavEmploymentValid != -1) {
		MM_swapImage('Image22','','images/homelinksover_07.gif',1)
		}
	var nNavLibraryValid =  navLocation.indexOf("library.asp",0)
	if(nNavLibraryValid != -1) {
		MM_swapImage('Image25','','images/homelinksover_10.gif',1)
		}
		
	updatesiteStatus();
		
}

function updatesiteStatus()
{
	window.status = "University of the Pacific: Gateway to the Campus"
}


