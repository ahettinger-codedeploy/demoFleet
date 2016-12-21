/* [nodename, id, name, navigationtext, href, isnavigation, childs[], templatename] */

if (typeof(decodeURIComponent) == 'undefined') {
  decodeURIComponent = function(s) {
    return unescape(s);
  }
}

function jdecode(s) {
    s = s.replace(/\+/g, "%20")
    return decodeURIComponent(s);
}

var POS_NODENAME=0;
var POS_ID=1;
var POS_NAME=2;
var POS_NAVIGATIONTEXT=3;
var POS_HREF=4;
var POS_ISNAVIGATION=5;
var POS_CHILDS=6;
var POS_TEMPLATENAME=7;
var POS_TARGET=8;
var theSitetree=[ 
	['PAGE','5901',jdecode('Home'),jdecode(''), jdecode('%2F5901.html'), 'true',[],'',''],
	['PAGE','5952',jdecode('Schedule'),jdecode(''), jdecode('%2F5952.html'), 'true',[],'',''],
	['PAGE','12901',jdecode('Calendar'),jdecode(''), jdecode('%2F12901.html'), 'true',[],'',''],
	['PAGE','38601',jdecode('Special+Programs%2FParties'),jdecode(''), jdecode('%2F38601.html'), 'true',[],'',''],
	['PAGE','13901',jdecode('Rehearsal+%26+Recital'),jdecode(''), jdecode('%2F13901.html'), 'true',[],'',''],
	['PAGE','14501',jdecode('Tickets'),jdecode(''), jdecode('%2F14501.html'), 'true',[],'',''],
	['PAGE','14402',jdecode('Info+Rules%2FReg+Dress+Code'),jdecode(''), jdecode('%2F14402.html'), 'true',[],'',''],
	['PAGE','15501',jdecode('Registration+Form'),jdecode(''), jdecode('%2F15501.html'), 'true',[],'',''],
	['PAGE','15701',jdecode('DCPA+Company'),jdecode(''), jdecode('%2F15701.html'), 'true',[],'','']];
var siteelementCount=9;
theSitetree.topTemplateName='Blast';
theSitetree.paletteFamily='B50454';
theSitetree.keyvisualId='-1';
theSitetree.keyvisualName='keyv.jpg';
theSitetree.fontsetId='33276';
theSitetree.graphicsetId='14146';
theSitetree.contentColor='000000';
theSitetree.contentBGColor='FFFFFF';
var localeDef={
  language: 'en',
  country: 'US'
};
var prodDef={
  wl_name: 'endurance',
  product: 'WSCSYSSSSLY0XRNC'
};
var theTemplate={
				hasFlashNavigation: 'false',
				hasFlashLogo: 	'false',
				hasFlashCompanyname: 'false',
				hasFlashElements: 'false',
				hasCompanyname: 'false',
				name: 			'Blast',
				paletteFamily: 	'B50454',
				keyvisualId: 	'-1',
				keyvisualName: 	'keyv.jpg',
				fontsetId: 		'33276',
				graphicsetId: 	'14146',
				contentColor: 	'000000',
				contentBGColor: 'FFFFFF',
				a_color: 		'9D0447',
				b_color: 		'D66EAD',
				c_color: 		'000000',
				d_color: 		'000000',
				e_color: 		'000000',
				f_color: 		'000000',
				hasCustomLogo: 	'true',
				contentFontFace:'Trebuchet MS, Helvetica, sans-serif',
				contentFontSize:'12',
				useFavicon:     'true'
			  };
var webappMappings = {};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '5901',
internalId:  '',
customField: '20130209-080351'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '5952',
internalId:  '',
customField: '20130129-190105'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '12901',
internalId:  '',
customField: '20121125-190109'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '13901',
internalId:  '',
customField: '20130129-193627'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '14501',
internalId:  '',
customField: '20130205-184205'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '14402',
internalId:  '',
customField: '20130205-183632'
};
webappMappings['7008']=webappMappings['7008-11828']={
webappId:    '7008',
documentId:  '15501',
internalId:  '11828',
customField: 'language:en;country:US;'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '15501',
internalId:  '',
customField: '20130109-192923'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '38601',
internalId:  '',
customField: '20130206-182808'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '15701',
internalId:  '',
customField: '20130205-183733'
};
webappMappings['1006']=webappMappings['1006-1006']={
webappId:    '1006',
documentId:  '5901',
internalId:  '1006',
customField: '1006'
};
var webAppHostname = 'cgiwsc.enhancedsitebuilder.com:80';
var canonHostname = 'cmworker02.yourhostingaccount.com';
var accountId     = 'AENDU0I7CEPX';
var companyName   = 'Dance+Central+performing+arts';
var htmlTitle	  = 'Dance+Central+Performing+Arts+Pearl+River%2C+NY';
var metaKeywords  = 'Dance+class%0D%0ADance+lessons%0D%0Adance+studio%0D%0Apearl+river%0D%0Arockland+county';
var metaContents  = 'Dance+Central+Performing+Arts+is+a+dance+studio+located++Pearl+River%2C+New+York+offering+many+types+of+dance+classes+to+students+of+all+ages+and+levels+of+experience.';
theSitetree.getById = function(id, ar) {
	if (typeof(ar) == 'undefined'){
		ar = this;
	}
	for (var i=0; i < ar.length; i++) {
		if (ar[i][POS_ID] == id){
			return ar[i];
		}
		if (ar[i][POS_CHILDS].length > 0) {
			var result=this.getById(id, ar[i][POS_CHILDS]);
			if (result != null){
				return result;
			}
		}
	}
	return null;
};

theSitetree.getParentById = function(id, ar) {
	if (typeof(ar) == 'undefined'){
		ar = this;
	}
	for (var i=0; i < ar.length; i++) {
		for (var j = 0; j < ar[i][POS_CHILDS].length; j++) {
			if (ar[i][POS_CHILDS][j][POS_ID] == id) {
				// child found
				return ar[i];
			}
			var result=this.getParentById(id, ar[i][POS_CHILDS]);
			if (result != null){
				return result;
			}
		}
	}
	return null;
};

theSitetree.getName = function(id) {
	var elem = this.getById(id);
	if (elem != null){
		return elem[POS_NAME];
	}
	return null;
};

theSitetree.getNavigationText = function(id) {
	var elem = this.getById(id);
	if (elem != null){
		return elem[POS_NAVIGATIONTEXT];
	}
	return null;
};

theSitetree.getHREF = function(id) {
	var elem = this.getById(id);
	if (elem != null){
		return elem[POS_HREF];
	}
	return null;
};

theSitetree.getIsNavigation = function(id) {
	var elem = this.getById(id);
	if (elem != null){
		return elem[POS_ISNAVIGATION];
	}
	return null;
};

theSitetree.getTemplateName = function(id, lastTemplateName, ar) {
	if (typeof(lastTemplateName) == 'undefined'){
		lastTemplateName = this.topTemplateName;
	}
	if (typeof(ar) == 'undefined'){
		ar = this;
	}
	for (var i=0; i < ar.length; i++) {
		var actTemplateName = ar[i][POS_TEMPLATENAME];
		if (actTemplateName == ''){
			actTemplateName = lastTemplateName;
		}
		if (ar[i][POS_ID] == id) {
			return actTemplateName;
		}
		if (ar[i][POS_CHILDS].length > 0) {
			var result=this.getTemplateName(id, actTemplateName, ar[i][POS_CHILDS]);
			if (result != null){
				return result;
			}
		}
	}
	return null;
};

theSitetree.getByXx = function(lookup, xx, ar) {
    if (typeof(ar) == 'undefined'){
    	ar = this;
    }
    for (var i=0; i < ar.length; i++) {
        if (ar[i][xx] == lookup){
        	return ar[i];
        }
        if (ar[i][POS_CHILDS].length > 0) {
        	var result=this.getByXx(lookup, xx, ar[i][POS_CHILDS]);
            if (result != null){
                return result;
               }
        }
    }
    return null;
};

function gotoPage(lookup) {
	if(__path_prefix__ == "/servlet/CMServeRES" && typeof (changePage) == 'function'){
		changePage(lookup);
		return;
	}
	var page = theSitetree.getHREF(lookup);
	if (!page) {
		var testFor = [ POS_NAME, POS_NAVIGATIONTEXT ];
		for (var i=0 ; i < testFor.length ; i++) {
			var p = theSitetree.getByXx(lookup, testFor[i]);
			if (p != null) {
				page = p[POS_HREF];
				break;
			}
		}
	}
	document.location.href = (new URL(__path_prefix__ + page, true, true)).toString();
};
