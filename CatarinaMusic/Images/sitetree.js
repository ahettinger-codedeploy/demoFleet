/* [nodename, id, name, navigationtext, href, isnavigation, childs[], templatename] */

function jdecode(s) {
    s = s.replace(/\+/g, "%20")
    return unescape(s);
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
	['PAGE','601',jdecode('Catarina+New'),jdecode(''),'/601.html','true',[],''],
	['PAGE','652',jdecode('May+11th+Concert'),jdecode(''),'/652.html','true',[],''],
	['PAGE','673',jdecode('Buy+Tickets+Here'),jdecode(''),'/673.html','true',[],'']];
var siteelementCount=3;
theSitetree.topTemplateName='Fluent';
theSitetree.paletteFamily='9C2020';
theSitetree.keyvisualId='-1';
theSitetree.keyvisualName='keyv.jpg';
theSitetree.fontsetId='10644';
theSitetree.graphicsetId='10522';
theSitetree.contentColor='000000';
theSitetree.contentBGColor='FFFFFF';
var theTemplate={
				name: 			'Fluent',
				paletteFamily: 	'9C2020',
				keyvisualId: 	'-1',
				keyvisualName: 	'keyv.jpg',
				fontsetId: 		'10644',
				graphicsetId: 	'10522',
				contentColor: 	'000000',
				contentBGColor: 'FFFFFF',
				hasFlashNavigation: 'false',
				hasFlashLogo: 	'false',
				hasFlashCompanyname: 'false',
				a_color: 		'000000',
				b_color: 		'000000',
				c_color: 		'000000',
				d_color: 		'A4A5A4',
				e_color: 		'8D1D1D',
				f_color: 		'DF0404',
				hasCustomLogo: 	'false',
				contentFontFace:'Verdana, Arial, Helvetica, sans-serif',
				contentFontSize:'12'
			  };
var webappMappings = {};
webappMappings['1006']={
webappId:    '1006',
documentId:  '601',
internalId:  '1006',
customField: '1006'
};
var canonHostname = 'wsc.ehost-services.com';
var accountId     = 'AEN010INLWQY';
var companyName   = 'CATARINA+NEW';
var htmlTitle	  = 'Jazz+Saxophonist+Catarina+New';
var metaKeywords  = 'jazz%2C+saxophone%2C+sax+player%2C+female+saxophonist%2C+jazz+music%2C+jazz+musicians%2C+music+in+Palm+Springs%2C+Palm+Desert+music%2C+Indian+Wells+resort%2C+music+in+Indian+wells%2C+Marty+Steele%2C+Bill+Evans%2C+Reggie+Workman%2C+Kenny+Werner%2C+Hal+Galper%2C+David+Liebman%2C+Bob+Mintzer%2C+USC+jazz%2C+Southern+California+music%2C+smooth+jazz%2C+Music+Awards%2C+best+jazz+solo+artist%2C+Swedish+musician%2C+Mindi+Abair%2C+Mindy+Abear%2C+Candy+Dulfer%2C+Catarina+New%2C+Playboy+Jazz%2C+B.B.+Kings%2C+House+of+Blues%2C+Catarina+Music%2C+Katarina+New%2C';
var metaContents  = 'Jazz+saxophonist+Catarina+New+has+been+compared+to+Mindi+Abair+and+Candy+Dulfer.++She+is+the+winner+of+the+Southern+California+Music+Awards+in+the+category+of+Best+Jazz+Solo+Artist.+++Catarina+will+be+in+concert+at+the+MiraMonte+Resort+in+Indian+Wells%2C+CA+on+May+11%2C+2008+with+her+9+piece+jazz+band+presenting+Smooth++Groovy.++She+has+produced+two+CDs%3A++Dont+Stop+Now+and+The+Point+of+No+Return+%28in+collaboration+with+pianist+Marty+Steele%29.';
					                                                                    
theSitetree.getById = function(id, ar) {												
							if (typeof(ar) == 'undefined')                              
								ar = this;                                              
							for (var i=0; i < ar.length; i++) {                         
								if (ar[i][POS_ID] == id)                                
									return ar[i];                                       
								if (ar[i][POS_CHILDS].length > 0) {                     
									var result=this.getById(id, ar[i][POS_CHILDS]);     
									if (result != null)                                 
										return result;                                  
								}									                    
							}                                                           
							return null;                                                
					  };                                                                
					                                                                    
theSitetree.getParentById = function(id, ar) {                                        
						if (typeof(ar) == 'undefined')                              	
							ar = this;                                             		
						for (var i=0; i < ar.length; i++) {                        		
							for (var j = 0; j < ar[i][POS_CHILDS].length; j++) {   		
								if (ar[i][POS_CHILDS][j][POS_ID] == id) {          		
									// child found                                 		
									return ar[i];                                  		
								}                                                  		
								var result=this.getParentById(id, ar[i][POS_CHILDS]);   
								if (result != null)                                 	
									return result;                                  	
							}                                                       	
						}                                                           	
						return null;                                                	
					 }								                                    
					                                                                    
theSitetree.getName = function(id) {                                                  
						var elem = this.getById(id);                                    
						if (elem != null)                                               
							return elem[POS_NAME];                                      
						return null;	                                                
					  };			                                                    
theSitetree.getNavigationText = function(id) {                                        
						var elem = this.getById(id);                                    
						if (elem != null)                                               
							return elem[POS_NAVIGATIONTEXT];                            
						return null;	                                                
					  };			                                                    
					                                                                    
theSitetree.getHREF = function(id) {                                                  
						var elem = this.getById(id);                                    
						if (elem != null)                                               
							return elem[POS_HREF];                                      
						return null;	                                                
					  };			                                                    
					                                                                    
theSitetree.getIsNavigation = function(id) {                                          
						var elem = this.getById(id);                                    
						if (elem != null)                                               
							return elem[POS_ISNAVIGATION];                              
						return null;	                                                
					  };			                                                    
					                                                                    
theSitetree.getTemplateName = function(id, lastTemplateName, ar) {             		
	                                                                                 
	if (typeof(lastTemplateName) == 'undefined')                                     
		lastTemplateName = this.topTemplateName;	                                 
	if (typeof(ar) == 'undefined')                                                   
		ar = this;                                                                   
		                                                                             
	for (var i=0; i < ar.length; i++) {                                              
		var actTemplateName = ar[i][POS_TEMPLATENAME];                               
		                                                                             
		if (actTemplateName == '')                                                   
			actTemplateName = lastTemplateName;		                                 
		                                                                             
		if (ar[i][POS_ID] == id) {                                			         
			return actTemplateName;                                                  
		}	                                                                         
		                                                                             
		if (ar[i][POS_CHILDS].length > 0) {                                          
			var result=this.getTemplateName(id, actTemplateName, ar[i][POS_CHILDS]); 
			if (result != null)                                                      
				return result;                                                       
		}									                                         
	}                                                                                
	return null;                                                                     
	};                                                                               
/* EOF */					                                                            
