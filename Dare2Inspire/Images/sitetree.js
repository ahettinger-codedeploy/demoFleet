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
var theSitetree=[ 
	['PAGE','7601',jdecode('Home'),jdecode(''),'/7601.html','true',[],''],
	['PAGE','23301',jdecode('Mission+and+Purpose'),jdecode(''),'/23301.html','true',[],''],
	['PAGE','7652',jdecode('Annual+Event'),jdecode(''),'/7652/index.html','true',[ 
		['PAGE','38601',jdecode('Application'),jdecode(''),'/7652/38601.html','true',[],''],
		['PAGE','40001',jdecode('Ticket+Reservation'),jdecode(''),'/7652/40001.html','false',[],''],
		['PAGE','49601',jdecode('Cruise+Raffle'),jdecode(''),'/7652/49601.html','true',[],''],
		['PAGE','33443',jdecode('Volunteer'),jdecode(''),'/7652/33443.html','true',[],'']
	],''],
	['PAGE','44101',jdecode('Photo+Gallery'),jdecode(''),'/44101.html','true',[],''],
	['PAGE','33464',jdecode('Contact'),jdecode(''),'/33464.html','true',[],'']];
var siteelementCount=9;
theSitetree.topTemplateName='Grace';
theSitetree.paletteFamily='CECDD0';
theSitetree.keyvisualId='-1';
theSitetree.keyvisualName='keyv.jpg';
theSitetree.fontsetId='32048';
theSitetree.graphicsetId='13873';
theSitetree.contentColor='484848';
theSitetree.contentBGColor='FFFFFF';
var localeDef={
  language: 'en',
  country: 'US'
};
var theTemplate={
				name: 			'Grace',
				paletteFamily: 	'CECDD0',
				keyvisualId: 	'-1',
				keyvisualName: 	'keyv.jpg',
				fontsetId: 		'32048',
				graphicsetId: 	'13873',
				contentColor: 	'484848',
				contentBGColor: 'FFFFFF',
				hasFlashNavigation: 'false',
				hasFlashLogo: 	'false',
				hasFlashCompanyname: 'false',
				hasFlashElements: 'false',
				hasCompanyname: 'false',
				a_color: 		'000000',
				b_color: 		'000000',
				c_color: 		'000000',
				d_color: 		'000000',
				e_color: 		'000000',
				f_color: 		'000000',
				hasCustomLogo: 	'true',
				contentFontFace:'Verdana, Arial, Helvetica, sans-serif',
				contentFontSize:'12',
				useFavicon:     'false'
			  };
var webappMappings = {};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '7601',
internalId:  '',
customField: '20090923-094533'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '7652',
internalId:  '',
customField: '20090923-094929'
};
webappMappings['7008']=webappMappings['7008-20022']={
webappId:    '7008',
documentId:  '40001',
internalId:  '20022',
customField: 'language:en;country:US;'
};
webappMappings['7008']=webappMappings['7008-19962']={
webappId:    '7008',
documentId:  '33443',
internalId:  '19962',
customField: 'language:en;country:US;'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '23301',
internalId:  '',
customField: '20090821-130230'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '40001',
internalId:  '',
customField: '20090821-123616'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '38601',
internalId:  '',
customField: '20090923-095039'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '33443',
internalId:  '',
customField: '20091007-130000'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '33464',
internalId:  '',
customField: '20091007-130026'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '44101',
internalId:  '',
customField: '20090821-152436'
};
webappMappings['5000']=webappMappings['5000-']={
webappId:    '5000',
documentId:  '49601',
internalId:  '',
customField: '20091011-082717'
};
var canonHostname = 'cmworker02.yourhostingaccount.com';
var accountId     = 'AENDU0INEH1P';
var companyName   = 'in-spire+%28v%29%3A+To+affect%2C+guide%2C+or+motivate+by+divine+influence';
var htmlTitle	  = 'Impact.+Inspire.+Imagine.';
var metaKeywords  = '';
var metaContents  = '';
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
