window._pa = window._pa || {};
_pa.segments = [{"name":"All visitors","id":443620,"regex":".*"},{"name":"Job Postings","id":1414929,"regex":"/job\\-postings.*/?([?#].*)*$"},{"name":"Careers","id":1554787,"regex":"/careers\\-datasphere.*/?([?#].*)*$"},{"name":"Dynamic Ad Clicks","id":2457887,"regex":"\\?.*utm_source=AD_PERFECTAUD"},{"name":"DSCN visitors","id":443623,"regex":".*"}];
_pa.conversions = [{"name":"Payment page view","id":"50750","regex":"/clkn/https/payments\\.datasphere\\.com/form/?([?#].*)*$"}];
_pa.conversionEvents = [];
_pa.segmentEvents = [];
_pa.thirdPartyTags = [];
_pa.thirdPartyTagEvents = [];
_pa.allVisitorsSegmentId = 443620;
_pa.clickThroughWindow = 30;
_pa.viewThroughWindow = 30;
_pa.rtbId = '1577';
_pa.siteId = '507e0153f16a97000200001c';
_pa.crossDevice = true;
!function(){function fireAppnexusSegment(e,a,t){if(null==t||isNaN(t))var r=_pa.pixelHost+"seg?t=2&add="+e;else var r=_pa.pixelHost+"seg?t=2&add="+e+":"+t;_pa.createImageTag("segments",e,r,a)}function rtbSegmentUrl(e){var a=_pa.paRtbHost+"seg/?add="+e;return a+="&source=js_tag",_pa.rtbId&&(a+="&a_id="+_pa.rtbId),_pa.obscureIP&&(a+="&obscure_ip=1"),a}function fireRtbSegment(e,a){var t=rtbSegmentUrl(e);fireRtb?_pa.createImageTag("paRtbSegments",e,t,a):rtbToFire.push({id:e,name:a})}function initRtb(){if(fireRtb=!0,0!==rtbToFire.length){for(var e=[],a=[],t=0;t<rtbToFire.length;t++){var r=rtbToFire[t],n=r.id,o=r.name;e.push(n),a.push(o)}var n=e.join(","),o=a.join(","),i=rtbSegmentUrl(n);_pa.createImageTag("paRtbSegments",n,i,o)}}function fireConversion(e,a,t){a=a||_pa.orderId,t=t||_pa.revenue;var r=e.id,n=e.name,o=_pa.rtbId;if(constructAndPlaceConversionPixels(r,n,a,t,o),e.cofires)for(var i=0;i<e.cofires.length;i++){var p=e.cofires[i];constructAndPlaceConversionPixels(p.appnexus_id,p.name,a,t,p.rtb_id)}}function rtbConversionUrl(e,a,t){var r=_pa.paRtbHost+"px/?id="+e+t;return r+="&source=js_tag",a&&(r+="&a_id="+a),_pa.obscureIP&&(r+="&obscure_ip=1"),"number"==typeof _pa.clickThroughWindow&&(r+="&click_through_window="+_pa.clickThroughWindow),"number"==typeof _pa.viewThroughWindow&&(r+="&view_through_window="+_pa.viewThroughWindow),r}function constructAndPlaceConversionPixels(e,a,t,r,n){var o="";t&&""!==t&&(t=t.toString().replace(/@.*/,"@"),o+="&order_id="+encodeURIComponent(t)),r&&""!==r&&(o+="&value="+encodeURIComponent(r)),o+="&other="+function(){for(var e="",a="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",t=0;16>t;t++){var r=Math.floor(Math.random()*a.length);e+=a.charAt(r)}return e}();var i=_pa.pixelHost+"px?t=2&id="+e+o,p=rtbConversionUrl(e,n,o);_pa.createImageTag("conversions",e,i,a),_pa.createImageTag("paRtbConversions",e,p,a)}function fireThirdPartyTag(thirdPartyTag){switch(thirdPartyTag.type){case"image_tag":_pa.createImageTag("thirdPartyTag",void 0,thirdPartyTag.content,thirdPartyTag.name);break;case"script_tag":loadScript(thirdPartyTag.content);break;case"script_text":try{eval(thirdPartyTag.content)}catch(e){}}}function callFromPq(e){for(var a=e.shift(),t=a.split("."),r=_pa,n=0;n<t.length;n++)r=r[t[n]];var o=r.apply(_pa,e);return executeCallbacks(a,e),o}function executeCallbacks(e,a){var t=_pa.callbacks[e];if("undefined"!=typeof t)for(var r=0;r<t.length;r++)t[r].apply(_pa,a)}function withCallbacks(){for(var e,a=Array.prototype.slice.call(arguments,0),t=a.shift(),r=t.split("."),n=_pa,o=0;o<r.length;o++)n=n[r[o]],e=r[o];n.apply(_pa,a),executeCallbacks(e,a)}function testUserAgent(){var e=window.navigator.userAgent;(/MSIE 7/.test(e)||/(iPod|iPhone|iPad)/.test(e)&&/AppleWebKit/.test(e))&&(_pa.skip=!0)}function setUser(){var e=("https:"==document.location.protocol?"https:":"http:")+"//pixel-geo.prfct.co/tagjs",a=[];_pa.rtbId&&a.push("a_id="+_pa.rtbId),_pa.obscureIP&&a.push("obscure_ip=1"),a.push("source=js_tag"),a.length>0&&(e+="?"+a.join("&")),loadScript(e)}function loadScript(e){var a=document.createElement("script");a.type="text/javascript",a.async=!0,a.src=e,_pa.head.appendChild(a)}_pa.head=document.getElementsByTagName("head")[0]||document.getElementsByTagName("body")[0];var fireRtb=!1,rtbToFire=[];_pa.ready={looper:!1,onload:!1};var typesToFireRightAway=["conversions","paRtbConversions"];_pa.fired={segments:[],conversions:[]},_pa.url=document.location.href,_pa.pixelHost=("https:"===document.location.protocol?"https://secure":"http://ib")+".adnxs.com/",_pa.paRtbHost=("https:"===document.location.protocol?"https://":"http://")+"pixel-geo.prfct.co/",_pa.callbacks={},testUserAgent(),_pa.init=function(){setUser(),_pa.detect(),_pa.initQ(),initRtb()},_pa.addFired=function(e,a){"undefined"==typeof _pa.fired[e]&&(_pa.fired[e]=[]),_pa.fired[e].push(a)},_pa.detect=function(){for(var e=0;e<_pa.segments.length;e++){var a=_pa.segments[e];_pa.url.match(new RegExp(a.regex,"i"))&&withCallbacks("fireSegment",a)}for(var e=0;e<_pa.conversions.length;e++){var t=_pa.conversions[e];_pa.url.match(new RegExp(t.regex,"i"))&&fireConversion(t)}for(var e=0;e<_pa.thirdPartyTags.length;e++){var r=_pa.thirdPartyTags[e];_pa.url.match(new RegExp(r.regex,"i"))&&fireThirdPartyTag(r)}_pa.productId&&_pa.trackProduct(_pa.productId)},_pa.track=function(e,a){a="undefined"!=typeof a?a:{};var t=_pa.trackSegments(e,a),r=_pa.trackConversions(e,a),n=_pa.trackThirdPartyTags(e);return t||r||n},_pa.trackSegments=function(e,a){for(var t=!1,r=0;r<_pa.segmentEvents.length;r++){var n=_pa.segmentEvents[r];n.name===e&&(t=!0,withCallbacks("fireSegment",n,a.segment_value))}return t},_pa.trackConversions=function(e,a){for(var t=!1,r=0;r<_pa.conversionEvents.length;r++){var n=_pa.conversionEvents[r];n.name===e&&(t=!0,fireConversion(n,a.orderId,a.revenue))}return t},_pa.trackThirdPartyTags=function(e){for(var a=!1,t=0;t<_pa.thirdPartyTagEvents.length;t++){var r=_pa.thirdPartyTagEvents[t];r.event===e&&(a=!0,fireThirdPartyTag(r))}return a},_pa.trackProduct=function(e){if(e&&0!==encodeURIComponent(e).length&&(_pa.productId=e,_pa.allVisitorsSegmentId)){var a=_pa.allVisitorsSegmentId+":"+encodeURIComponent(_pa.productId),t=rtbSegmentUrl(a);_pa.createImageTag("paRtbSegments",_pa.allVisitorsSegmentId,t,"product track")}},_pa.fireLoadEvents=function(){if("undefined"!=typeof _pa.onLoadEvent)if("function"==typeof _pa.onLoadEvent)_pa.onLoadEvent();else if("string"==typeof _pa.onLoadEvent)for(var e=_pa.onLoadEvent.split(","),a=0;a<e.length;a++){var t=e[a];_pa.track(t)}},_pa.createImageTag=function(e,a,t,r){if(!_pa.skip){for(var n=!1,o=0;o<typesToFireRightAway.length;o++)e===typesToFireRightAway[o]&&(n=!0);_pa.pixelPlacer.place(t,n),_pa.addFired(e,{id:a,name:r})}},_pa.looperReady=function(){_pa.ready.looper=!0,_pa.fireWhenReady()},_pa.fireWhenReady=function(){_pa.ready.looper&&_pa.ready.onload&&(_pa.fireLoadEvents(),_pa.pixelPlacer.activate())},_pa.fireSegment=function(e,a){fireAppnexusSegment(e.id,e.name,a),fireRtbSegment(e.id,e.name)},_pa.initQ=function(){if("undefined"!=typeof window._pq)for(var e=0;e<_pq.length;e++){var a=_pq[e];callFromPq(a)}window._pq={push:function(e){return callFromPq(e)}}},_pa.addListener=function(e,a){"undefined"==typeof _pa.callbacks[e]&&(_pa.callbacks[e]=[]),_pa.callbacks[e].push(a)},_pa.removeListener=function(e,a){for(var t=_pa.callbacks[e],r=t.length;r--;)t[r]===a&&t.splice(r,1)},_pa.pixelPlacer=function(){function e(){n=!0,t()}function a(e,a){n||a?r(e):o.push(e)}function t(){for(var e;e=o.pop();)r(e)}function r(e){var a=document.createElement("img");a.src=e,a.width=1,a.height=1,a.border=0,_pa.head.appendChild(a)}var n=!1,o=[];return{activate:e,place:a}}();var partnerCriteria={cd:function(){return _pa.crossDevice}};_pa.setPartners=function(e){var a,t;for(var r in e){if(a=e[r],t=!0,"object"==typeof a)for(var n;n<a.length;n++){var o=a[n];criteriaFunction=partnerCriteria[o],t=t&&criteriaFunction()}t&&_pa.pixelPlacer.place(_pa.paRtbHost+"cs/?partnerId="+r)}}}();	(function() {
	_pa.partner_tags = {"datasphere":true,"pa_rtb":true,"canned_banners":{"id":15,"campaign_id":1109}};
	function createPartnerTags(partner_tags){
		if (partner_tags.canned_banners != null){
			loadCannedBanners(partner_tags.canned_banners);
		}
	}
	
		function loadCannedBanners(data) {
			var protocol = ("https:" === document.location.protocol ? "https://" : "http://");
			createCBScriptTag("partner_tags", "cannedbanners_pixel", protocol, data.id, data.campaign_id);
		}
		function createCBScriptTag(type, id, protocol, client_id, campaign_id) {
			var t = document.createElement('script');
			t.src = protocol + "dynamic.cannedbanners.com/tag/?clientId=" + client_id + "&campaignId=" + campaign_id;
			t.id = id;
			_pa.head.appendChild(t);
			_pa.addFired(type, {id: client_id, name: "canned_banners_script"});
		}
	
	
	
		_pa.datasphere = {
			track: function(businessId) {
				var src = "//dyn-cookies.perfectaudience.com/datasphere/" + businessId;
				_pa.trackProduct(businessId);
				_pa.createImageTag('datasphere', businessId, src, businessId);
			}
		};
	
	
	
	
	createPartnerTags(_pa.partner_tags);
})();

(function(){
	_pa.init();
	if (_pa.initAfterLoad) {
		if (window.document && window.document.readyState === "complete") {
			_pa.ready.onload = true;
			_pa.fireWhenReady();
		} else {
			function hookLoad(handler) {
				if(window.addEventListener) {
					window.addEventListener("load", handler, false);
				} else if(window.attachEvent) {
					window.attachEvent("onload", handler);
				}
			}
			hookLoad(function() {
				_pa.ready.onload = true;
				_pa.fireWhenReady();
			});
		}
	} else {
		_pa.ready.onload = true;
		_pa.fireWhenReady();
	}
})();