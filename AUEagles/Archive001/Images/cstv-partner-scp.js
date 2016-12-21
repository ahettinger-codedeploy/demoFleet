
csCRdate = new Date();
csUsrTime  = csCRdate.toGMTString();
regexp = /\d\d\d\d/;
csUsrYear = regexp.exec(csUsrTime);
//document.write(csUsrYear);



var csPartnerLogoLink = '<a href="http://www.cstv.com" target="_blank"><img src="/PrivateLabel/AUEagles/Images/cstv-partner-logo-000000.gif" width="272" height="60" alt="Official Partner CSTV.com" border="0"></a><br><div class="twentyvert">&nbsp;</div>';
var csCopyYear = '<a href="#nogo" onClick="openCRwindow();" class="csdisclaimerlink">&copy;  '+csUsrYear+'</a>';
var csFeedback = '<a href="/feedback/'+oascodeToUse+'-feedback.html" class="csdisclaimerlink" target="_blank">Feedback</a>';
var csPrivacy = '<a href="http://www.cstv.com/ot/privacy.html" class="csdisclaimerlink" target="_blank">Privacy Policy</a>';
var csTerms = '<a href="http://www.cstv.com/ot/cs-tos.html" class="csdisclaimerlink" target="_blank">Terms of Service</a>';
var csRSS = '<a href="/rss/rss-index.html"><span style="border:1px solid;border-color:#FC9 #630 #630 #F96;padding:0 3px;font:bold 10px verdana,sans-serif;color:#FFF;background:#F60;text-decoration:none;margin:0;">XML</span></a> '
var csRSS1 = '<a href="/rss/rss-index.html" class="csdisclaimerlink">RSS Feeds</a>';


var cstvPartner = '<style>.csdisclaimerlink{color:#'+linkHexToUse+'; font-size:11px; font-family:arial, verdana, helvetica, sans-serif;}.csdisclaimerlink:hover{text-decoration:none;}</style>';
cstvPartner += '<span class="csdisclaimerlink">';

cstvPartner += csPartnerLogoLink;
cstvPartner += csCopyYear;
cstvPartner += " | ";
cstvPartner += csFeedback;
cstvPartner += " | ";
cstvPartner += csPrivacy;
cstvPartner += " | ";
cstvPartner += csTerms;
cstvPartner += " | ";
cstvPartner += csRSS;
cstvPartner += csRSS1;
cstvPartner += '</span>';

document.write(cstvPartner);

function openCRwindow(){
	if (typeof(heightTouse) != 'undefined' && heightTouse){
 	  popupHeight = heightTouse;
	} else {
	  popupHeight ="110";
	}
	
	if (typeof(otherCopyright) != 'undefined'){
		oascodeToUse = oascodeToUse;
		} else {
		oascodeToUse ='cs';
		}
	
window.open('http://www.fansonly.com/disclaimer_partner/' +oascodeToUse+ '-05-copyright.html?'+oasTitleToUse,'CopyrightWin','toolbar=no,resizable=no,scrollbars=no,width=350,height=' +popupHeight ); 
void(0);
}
