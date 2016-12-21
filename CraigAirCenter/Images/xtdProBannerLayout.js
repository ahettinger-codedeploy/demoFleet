// JavaScript Document
var bnrsprofix = new Array();
var bnrsprofixp = new Array();
var bnrspro = new Array();

function render_xtd_ispro() {
	for(var k in bnrsprofix) {
		if(bnrsprofix[k] == 1) {
			xtdProBannerLayout(k,bnrsprofixp[k]['goback']);
		} 
	}
}

function xtdGetBrowser() {
	var browserAgent = navigator.userAgent;
	var b = "Other";
		
	if (browserAgent.indexOf("Mozilla") == 0) b = "Mozilla";	
	if (browserAgent.indexOf("MSIE 6") != -1) b = "IE6";
	if (browserAgent.indexOf("MSIE 7") != -1) b = "IE7";
	if (browserAgent.indexOf("Opera") != -1) b = "Opera";
	if (browserAgent.indexOf("Firefox/1") != -1) b = "Firefox1";
	if (browserAgent.indexOf("Firefox/2") != -1) b = "Firefox2";
	if (browserAgent.indexOf("Netscape") != -1) b = "Netscape";
	if (browserAgent.indexOf("Safari") != -1) b = "Safari";
	if (browserAgent.indexOf("Camino") != -1) b = "Camino";
		
	return b;
}

function xtdProBannerLayout(divId,goBack) {
	function xtdEmbed(divId,flashVars,src) {
		bnrspro.push(divId);
		var sEmbed = '<embed width="100%" height="100%"  name="' + divId + 'Swf" id="' + divId + "Swf\" flashvars='" + flashVars + "'" + 'scale="noscale" allowscriptaccess="sameDomain" wmode="transparent" quality="high" bgcolor="#336699" src="' + src + '" type="application/x-shockwave-flash" />';
		return sEmbed;
	}
	
	function isInTable(divId) {
		var holder = document.getElementById(divId);
		while( holder.parentNode != undefined ) {
			if ( holder.parentNode.nodeName == 'TD' || holder.parentNode.nodeName == 'TR' || holder.parentNode.nodeName == 'TABLE' ) {
				return true;		
			} else {
				holder = holder.parentNode;
			}
		}
		return false;
	}
	
	function needTableFix() {
		var browser = xtdGetBrowser();
		if (browser.indexOf("IE") == 0) return true;
		return false;
	}
	
	if(FlashDetect.majorAtLeast(8)){
		
		if( isInTable(divId) && needTableFix() && bnrsprofix[divId] == undefined ) {
			bnrsprofix[divId] = 1;
			bnrsprofixp[divId] = new Object();
			bnrsprofixp[divId]['goback'] = goBack;
			return ;								
		}
		
		eval("var tmpVar = " + divId);
		var oData = eval('(' + tmpVar  + ')');
		var aParam = new Array();
		var sParam = '';
		
		for(var k=0; k < oData.fields.length; k++) {
			var oFld = oData.fields[k];
			aParam.push(oFld.name + "=" + oFld.value);	
		}
		
		if(oData.objects) {
			for(var k=0; k < oData.objects.length; k++) {
				var oObj = oData.objects[k];
				aParam.push( oObj.name + "=" + oObj.data );	
			}
		}
		aParam.push('rel_path=' + goBack);
		sParam = aParam.join('&');
		
		var el = document.getElementById(divId);
		if(el.innerHTML) {
			 el.innerHTML = xtdEmbed(divId,sParam,goBack + 'includes/ImageShowPro/xtdbannerpro.swf');
		}
	}
}