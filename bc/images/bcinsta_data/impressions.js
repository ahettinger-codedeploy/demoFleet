!function(){Function&&Function.prototype&&Function.prototype.bind&&(/MSIE [678]/.test(navigator.userAgent)||!function(t){function e(r){if(n[r])return n[r].exports;var o=n[r]={exports:{},id:r,loaded:!1};return t[r].call(o.exports,o,o.exports,e),o.loaded=!0,o.exports}var n={};return e.m=t,e.c=n,e.p="https://platform.twitter.com/",e(0)}([function(t,e,n){!function(){var t=n(1),e=n(2),r=n(3),o=n(34);r.exposeApiAndBind(o.init("impressions",{}),e,t,o.base)}()},function(t,e){t.exports=document},function(t,e){t.exports=window},function(t,e,n){function r(t){return t=t||{},_.isType("string",t)?{context:t}:{context:t.context,partner:t.partner}}function o(t,e,n){var o;n=r(n),e=e||t.body,_.isType("array",e)||(e=[e]),0!==e.length&&(_.isType("string",e[0])&&(o=a(e,n)),e[0].nodeType==Node.ELEMENT_NODE&&(o=i(e)),o&&(h.scribePartnerTweetAudienceImpression(),m.flushClientEvents()))}function i(t){var e,n=[];return _.toRealArray(t).forEach(function(t){t.nodeType===Node.ELEMENT_NODE&&(d.present(t,T)?n.push(t):n=n.concat(_.toRealArray(t.getElementsByClassName(T))))}),_.toRealArray(n).forEach(function(t){var n=s(t);t.setAttribute(x,""),n&&(a([n.tweetId],r(n),t),e=!0)}),e}function s(t){var e={};if(null===t.getAttribute(x))return e.tweetId=t.getAttribute("data-twitter-tweet-id"),e.context=t.getAttribute("data-twitter-tweet-context"),e.partner=t.getAttribute("data-partner"),e.tweetId&&e.tweetId.length>0?e:void 0}function a(t,e,n){var r,o,i;return e=e||{},r={widget_origin:w.rootDocumentLocation()},o=e.context,i=e.partner||v.val("partner"),_.isType("array",t)||(t=[t]),t=t.filter(function(t){return _.isType("string",t)}),_.isType("string",o)&&(r.description=o),r.item_ids=t,r.item_details={},i&&(r.message=i),t.forEach(function(t){r.item_details[t]=A}),f(t,o,i,n),m.enqueueClientEvent(N,r)}function c(t){_.isType("function",t)&&b.push(t)}function u(t){var e=b.indexOf(t);e>-1&&b.splice(e,1)}function f(t,e,n,r){b.forEach(function(o){o.call(null,{tweetIds:t,context:e,partner:n,srcElement:r})})}function l(t,e,n,r){var i=new y;g.exposeReadyPromise(i.promise,t,"_e"),_.aug(t,{logTweets:E(o,e,n),attachDebugger:c,detachDebugger:u}),i.promise.then(function(){t.logTweets()}),p(function(){i.resolve(r||t)})}var p=n(4),d=n(5),v=n(7),m=n(8),h=n(23),g=n(24),y=n(26),w=n(12),_=n(6),E=n(25),b=[],T="twitter-custom-tweet",x="data-twitter-logged",A={item_type:0},N={page:"partnertweet",action:"results"};t.exports={exposeApiAndBind:l,logTweets:o,enqueueTweetsByIds:a,enqueueTweetsFromNodes:i,attachDebugger:c,detachDebugger:u}},function(t,e,n){function r(){u=1;for(var t=0,e=f.length;e>t;t++)f[t]()}var o,i,s,a=n(1),c=n(2),u=0,f=[],l=!1,p=a.createElement("a");/^loade|c/.test(a.readyState)&&(u=1),a.addEventListener&&a.addEventListener("DOMContentLoaded",i=function(){a.removeEventListener("DOMContentLoaded",i,l),r()},l),p.doScroll&&a.attachEvent("onreadystatechange",o=function(){/^c/.test(a.readyState)&&(a.detachEvent("onreadystatechange",o),r())}),s=p.doScroll?function(t){c.self!=c.top?u?t():f.push(t):!function(){try{p.doScroll("left")}catch(e){return setTimeout(function(){s(t)},50)}t()}()}:function(t){u?t():f.push(t)},t.exports=s},function(t,e,n){function r(t){return new RegExp("\\b"+t+"\\b","g")}function o(t,e){return t.classList?void t.classList.add(e):void(r(e).test(t.className)||(t.className+=" "+e))}function i(t,e){return t.classList?void t.classList.remove(e):void(t.className=t.className.replace(r(e)," "))}function s(t,e,n){return void 0===n&&t.classList&&t.classList.toggle?t.classList.toggle(e,n):(n?o(t,e):i(t,e),n)}function a(t,e,n){return t.classList&&c(t,e)?(i(t,e),void o(t,n)):void(t.className=t.className.replace(r(e),n))}function c(t,e){return t.classList?t.classList.contains(e):f.contains(u(t),e)}function u(t){return f.toRealArray(t.classList?t.classList:t.className.match(l))}var f=n(6),l=/\b([\w-_]+)\b/g;t.exports={add:o,remove:i,replace:a,toggle:s,present:c,list:u}},function(t,e,n){function r(t){return l(arguments).slice(1).forEach(function(e){i(e,function(e,n){t[e]=n})}),t}function o(t){return i(t,function(e,n){c(n)&&(o(n),u(n)&&delete t[e]),(void 0===n||null===n||""===n)&&delete t[e]}),t}function i(t,e){for(var n in t)(!t.hasOwnProperty||t.hasOwnProperty(n))&&e(n,t[n]);return t}function s(t){return{}.toString.call(t).match(/\s([a-zA-Z]+)/)[1].toLowerCase()}function a(t,e){return t==s(e)}function c(t){return t===Object(t)}function u(t){if(!c(t))return!1;if(Object.keys)return!Object.keys(t).length;for(var e in t)if(t.hasOwnProperty(e))return!1;return!0}function f(t,e){d.setTimeout(function(){t.call(e||null)},0)}function l(t){return t?Array.prototype.slice.call(t):[]}function p(t,e){return t&&t.indexOf?t.indexOf(e)>-1:!1}var d=n(2);t.exports={aug:r,async:f,compact:o,contains:p,forIn:i,isObject:c,isEmptyObject:u,toType:s,isType:a,toRealArray:l}},function(t,e,n){function r(t){var e,n,r,o=0;for(i={},t=t||s,e=t.getElementsByTagName("meta");n=e[o];o++)/^twitter:/.test(n.name)&&(r=n.name.replace(/^twitter:/,""),i[r]=n.content)}function o(t){return i[t]}var i,s=n(1);r(),t.exports={init:r,val:o}},function(t,e,n){function r(t,e,n){return o(t,e,n,2)}function o(t,e,n,r){var o=!h.isObject(t),i=e?!h.isObject(e):!1;o||i||s(m.formatClientEventNamespace(t),m.formatClientEventData(e,n,r),m.CLIENT_EVENT_ENDPOINT)}function i(t,e,n,r){var i=m.extractTermsFromDOM(t.target||t.srcElement);i.action=r||"click",o(i,e,n)}function s(t,e,n){var r,o;n&&h.isObject(t)&&h.isObject(e)&&(r=m.flattenClientEventPayload(t,e),o={l:m.stringify(r)},r.dnt&&(o.dnt=1),p(v.url(n,o)))}function a(t,e,n,r){var o,i=!h.isObject(t),s=e?!h.isObject(e):!1;if(!i&&!s)return o=m.flattenClientEventPayload(m.formatClientEventNamespace(t),m.formatClientEventData(e,n,r)),c(o)}function c(t){return y.push(t),y}function u(){var t,e;return y.length>1&&a({page:"widgets_js",component:"scribe_pixel",action:"batch_log"},{}),t=y,y=[],e=t.reduce(function(e,n,r){var o=e.length,i=o&&e[o-1],s=r+1==t.length;return s&&n.event_namespace&&"batch_log"==n.event_namespace.action&&(n.message=["entries:"+r,"requests:"+o].join("/")),f(n).forEach(function(t){var n=l(t);(!i||i.urlLength+n>g)&&(i={urlLength:_,items:[]},e.push(i)),i.urlLength+=n,i.items.push(t)}),e},[]),e.map(function(t){var e={l:t.items};return d.enabled()&&(e.dnt=1),p(v.url(m.CLIENT_EVENT_ENDPOINT,e))})}function f(t){return Array.isArray(t)||(t=[t]),t.reduce(function(t,e){var n,r=m.stringify(e),o=l(r);return g>_+o?t=t.concat(r):(n=m.splitLogEntry(e),n.length>1&&(t=t.concat(f(n)))),t},[])}function l(t){return encodeURIComponent(t).length+3}function p(t){var e=new Image;return e.src=t}var d=n(9),v=n(15),m=n(18),h=n(6),g=2083,y=[],w=v.url(m.CLIENT_EVENT_ENDPOINT,{dnt:0,l:""}),_=encodeURIComponent(w).length;t.exports={_enqueueRawObject:c,scribe:s,clientEvent:o,clientEvent2:r,enqueueClientEvent:a,flushClientEvents:u,interaction:i}},function(t,e,n){function r(){p=!0}function o(t,e){return p?!0:f.asBoolean(l.val("dnt"))?!0:!a||1!=a.doNotTrack&&1!=a.msDoNotTrack?u.isUrlSensitive(e||s.host)?!0:c.isFramed()&&u.isUrlSensitive(c.rootDocumentLocation())?!0:(t=d.test(t||i.referrer)&&RegExp.$1,t&&u.isUrlSensitive(t)?!0:!1):!0}var i=n(1),s=n(10),a=n(11),c=n(12),u=n(17),f=n(16),l=n(7),p=!1,d=/https?:\/\/([^\/]+).*/i;t.exports={setOn:r,enabled:o}},function(t,e){t.exports=location},function(t,e){t.exports=navigator},function(t,e,n){function r(t){return t&&c.isType("string",t)&&(u=t),u}function o(){return f}function i(){return u!==f}var s=n(10),a=n(13),c=n(6),u=a.getCanonicalURL()||s.href,f=u;t.exports={isFramed:i,rootDocumentLocation:r,currentDocumentLocation:o}},function(t,e,n){function r(t,e){var n,r;return e=e||a,/^https?:\/\//.test(t)?t:/^\/\//.test(t)?e.protocol+t:(n=e.host+(e.port.length?":"+e.port:""),0!==t.indexOf("/")&&(r=e.pathname.split("/"),r.pop(),r.push(t),t="/"+r.join("/")),[e.protocol,"//",n,t].join(""))}function o(){for(var t,e=s.getElementsByTagName("link"),n=0;t=e[n];n++)if("canonical"==t.rel)return r(t.href)}function i(){for(var t,e,n,r=s.getElementsByTagName("a"),o=s.getElementsByTagName("link"),i=[r,o],a=0,u=0,f=/\bme\b/;t=i[a];a++)for(u=0;e=t[u];u++)if(f.test(e.rel)&&(n=c.screenName(e.href)))return n}var s=n(1),a=n(10),c=n(14);t.exports={absolutize:r,getCanonicalURL:o,getScreenNameFromPage:i}},function(t,e,n){function r(t){return"string"==typeof t&&y.test(t)&&RegExp.$1.length<=20}function o(t){return r(t)?RegExp.$1:void 0}function i(t,e){var n=g.decodeURL(t);return e=e||!1,n.screen_name=o(t),n.screen_name?g.url("https://twitter.com/intent/"+(e?"follow":"user"),n):void 0}function s(t){return i(t,!0)}function a(t){return"string"==typeof t&&b.test(t)}function c(t,e){return e=void 0===e?!0:e,a(t)?(e?"#":"")+RegExp.$1:void 0}function u(t){return"string"==typeof t&&w.test(t)}function f(t){return u(t)&&RegExp.$1}function l(t){return _.test(t)}function p(t){return E.test(t)}function d(t){return T.test(t)}function v(t){return A.test(t)&&RegExp.$1}function m(t){return x.test(t)&&RegExp.$1}function h(t){return T.test(t)&&RegExp.$1}var g=n(15),y=/(?:^|(?:https?\:)?\/\/(?:www\.)?twitter\.com(?:\:\d+)?(?:\/intent\/(?:follow|user)\/?\?screen_name=|(?:\/#!)?\/))@?([\w]+)(?:\?|&|$)/i,w=/(?:^|(?:https?\:)?\/\/(?:www\.)?twitter\.com(?:\:\d+)?\/(?:#!\/)?[\w_]+\/status(?:es)?\/)(\d+)/i,_=/^http(s?):\/\/(\w+\.)*twitter\.com([\:\/]|$)/i,E=/^http(s?):\/\/pbs\.twimg\.com\//,b=/^#?([^.,<>!\s\/#\-\(\)\'\"]+)$/,T=/twitter\.com(?:\:\d{2,4})?\/intent\/(\w+)/,x=/^https?:\/\/(?:www\.)?twitter\.com\/\w+\/timelines\/(\d+)/i,A=/^https?:\/\/(?:www\.)?twitter\.com\/i\/moments\/(\d+)/i;t.exports={isHashTag:a,hashTag:c,isScreenName:r,screenName:o,isStatus:u,status:f,intentForProfileURL:i,intentForFollowURL:s,isTwitterURL:l,isTwimgURL:p,isIntentURL:d,regexen:{profile:y},momentId:v,collectionId:m,intentType:h}},function(t,e,n){function r(t){return encodeURIComponent(t).replace(/\+/g,"%2B").replace(/'/g,"%27")}function o(t){return decodeURIComponent(t)}function i(t){var e=[];return f.forIn(t,function(t,n){var o=r(t);f.isType("array",n)||(n=[n]),n.forEach(function(t){u.hasValue(t)&&e.push(o+"="+r(t))})}),e.sort().join("&")}function s(t){var e,n={};return t?(e=t.split("&"),e.forEach(function(t){var e=t.split("="),r=o(e[0]),i=o(e[1]);return 2==e.length?f.isType("array",n[r])?void n[r].push(i):r in n?(n[r]=[n[r]],void n[r].push(i)):void(n[r]=i):void 0}),n):{}}function a(t,e){var n=i(e);return n.length>0?f.contains(t,"?")?t+"&"+i(e):t+"?"+i(e):t}function c(t){var e=t&&t.split("?");return 2==e.length?s(e[1]):{}}var u=n(16),f=n(6);t.exports={url:a,decodeURL:c,decode:s,encode:i,encodePart:r,decodePart:o}},function(t,e,n){function r(t){return void 0!==t&&null!==t&&""!==t}function o(t){return s(t)&&t%1===0}function i(t){return s(t)&&!o(t)}function s(t){return r(t)&&!isNaN(t)}function a(t){return r(t)&&"array"==v.toType(t)}function c(t){return v.contains(h,t)}function u(t){return v.contains(m,t)}function f(t){return r(t)?u(t)?!0:c(t)?!1:!!t:!1}function l(t){return s(t)?t:void 0}function p(t){return i(t)?t:void 0}function d(t){return o(t)?parseInt(t,10):void 0}var v=n(6),m=[!0,1,"1","on","ON","true","TRUE","yes","YES"],h=[!1,0,"0","off","OFF","false","FALSE","no","NO"];t.exports={hasValue:r,isInt:o,isFloat:i,isNumber:s,isArray:a,isTruthValue:u,isFalseValue:c,asInt:d,asFloat:p,asNumber:l,asBoolean:f}},function(t,e,n){function r(t){return t in a?a[t]:a[t]=s.test(t)}function o(){return r(i.host)}var i=n(10),s=/^[^#?]*\.(gov|mil)(:\d+)?([#?].*)?$/i,a={};t.exports={isUrlSensitive:r,isHostPageSensitive:o}},function(t,e,n){function r(t,e){var n;return e=e||{},t&&t.nodeType===Node.ELEMENT_NODE?((n=t.getAttribute("data-scribe"))&&n.split(" ").forEach(function(t){var n=t.trim().split(":"),r=n[0],o=n[1];r&&o&&!e[r]&&(e[r]=o)}),r(t.parentNode,e)):e}function o(t){return v.aug({client:"tfw"},t||{})}function i(t,e,n){var r=t&&t.widget_origin||l.referrer;return t=s("tfw_client_event",t,r),t.client_version=g,t.format_version=void 0!==n?n:1,e||(t.widget_origin=r),t}function s(t,e,n){return e=e||{},v.aug({},e,{_category_:t,triggered_on:e.triggered_on||+new Date,dnt:d.enabled(n)})}function a(t,e){var n={};return e=e||{},e.association_namespace=o(t),n[E]=e,n}function c(t,e){return v.aug({},e,{event_namespace:t})}function u(t){var e,n=Array.prototype.toJSON;return delete Array.prototype.toJSON,e=p.stringify(t),n&&(Array.prototype.toJSON=n),e}function f(t){if(t.item_ids&&t.item_ids.length>1){var e=Math.floor(t.item_ids.length/2),n=t.item_ids.slice(0,e),r={},o=t.item_ids.slice(e),i={};n.forEach(function(e){r[e]=t.item_details[e]}),o.forEach(function(e){i[e]=t.item_details[e]});var s=[v.aug({},t,{item_ids:n,item_details:r}),v.aug({},t,{item_ids:o,item_details:i})];return s}return[t]}var l=n(1),p=n(19),d=n(9),v=n(6),m=n(20),h=n(21),g=m.version,y=h.get("endpoints.rufous")||"https://syndication.twitter.com/i/jot",w=h.get("endpoints.rufousAudience")||"https://syndication.twitter.com/i/jot/syndication",_=h.get("endpoints.rufousRedirect")||"https://platform.twitter.com/jot.html",E=1;t.exports={extractTermsFromDOM:r,flattenClientEventPayload:c,formatGenericEventData:s,formatClientEventData:i,formatClientEventNamespace:o,formatTweetAssociation:a,splitLogEntry:f,stringify:u,AUDIENCE_ENDPOINT:w,CLIENT_EVENT_ENDPOINT:y,RUFOUS_REDIRECT:_}},function(t,e,n){var r=n(2),o=r.JSON;t.exports={stringify:o.stringify||o.encode,parse:o.parse||o.decode}},function(t,e){t.exports={version:"1caccb10:1453413307309"}},function(t,e,n){var r=n(22);t.exports=new r("__twttr")},function(t,e,n){function r(t){return a.isType("string",t)?t.split("."):a.isType("array",t)?t:[]}function o(t,e){var n=r(e),o=n.slice(0,-1);return o.reduce(function(t,e,n){if(t[e]=t[e]||{},!a.isObject(t[e]))throw new Error(o.slice(0,n+1).join(".")+" is already defined with a value.");return t[e]},t)}function i(t,e){e=e||s,e[t]=e[t]||{},Object.defineProperty(this,"base",{value:e[t]}),Object.defineProperty(this,"name",{value:t})}var s=n(2),a=n(6);a.aug(i.prototype,{get:function(t){var e=r(t);return e.reduce(function(t,e){return a.isObject(t)?t[e]:void 0},this.base)},set:function(t,e,n){var i=r(t),s=o(this.base,t),a=i.slice(-1);return n&&a in s?s[a]:s[a]=e},init:function(t,e){return this.set(t,e,!0)},unset:function(t){var e=r(t),n=this.get(e.slice(0,-1));n&&delete n[e.slice(-1)]},aug:function(t){var e=this.get(t),n=a.toRealArray(arguments).slice(1);if(e="undefined"!=typeof e?e:{},n.unshift(e),!n.every(a.isObject))throw new Error("Cannot augment non-object.");return this.set(t,a.aug.apply(null,n))},call:function(t){var e=this.get(t),n=a.toRealArray(arguments).slice(1);if(!a.isType("function",e))throw new Error("Function "+t+"does not exist.");return e.apply(null,n)},fullPath:function(t){var e=r(t);return e.unshift(this.name),e.join(".")}}),t.exports=i},function(t,e,n){function r(){return f.formatGenericEventData("syndicated_impression",{})}function o(){c("tweet")}function i(){c("timeline")}function s(){c("video")}function a(){c("partnertweet")}function c(t){l.isHostPageSensitive()||p[t]||(p[t]=!0,u.scribe(f.formatClientEventNamespace({page:t,action:"impression"}),r(),f.AUDIENCE_ENDPOINT))}var u=n(8),f=n(18),l=n(17),p={};t.exports={scribeAudienceImpression:c,scribePartnerTweetAudienceImpression:a,scribeTweetAudienceImpression:o,scribeTimelineAudienceImpression:i,scribeVideoAudienceImpression:s}},function(t,e,n){function r(t,e,n){e.ready=o(t.then,t),n&&Array.isArray(e[n])&&(e[n].forEach(o(t.then,t)),delete e[n])}var o=n(25);t.exports={exposeReadyPromise:r}},function(t,e,n){var r=n(6);t.exports=function(t,e){var n=Array.prototype.slice.call(arguments,2);return function(){var o=r.toRealArray(arguments);return t.apply(e,n.concat(o))}}},function(t,e,n){function r(){var t=this;this.promise=new o(function(e,n){t.resolve=e,t.reject=n})}var o=n(27);t.exports=r},function(t,e,n){var r=n(28).Promise,o=n(2),i=n(32);t.exports=i.hasPromiseSupport()?o.Promise:r},function(t,e,n){var r;(function(t){/*!
	 * @overview es6-promise - a tiny implementation of Promises/A+.
	 * @copyright Copyright (c) 2014 Yehuda Katz, Tom Dale, Stefan Penner and contributors (Conversion to ES6 API by Jake Archibald)
	 * @license   Licensed under MIT license
	 *            See https://raw.githubusercontent.com/jakearchibald/es6-promise/master/LICENSE
	 * @version   2.3.0
	 */
(function(){"use strict";function o(t){return"function"==typeof t||"object"==typeof t&&null!==t}function i(t){return"function"==typeof t}function s(t){return"object"==typeof t&&null!==t}function a(t){J=t}function c(t){G=t}function u(){var t=process.nextTick,e=process.versions.node.match(/^(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)$/);return Array.isArray(e)&&"0"===e[1]&&"10"===e[2]&&(t=setImmediate),function(){t(v)}}function f(){return function(){z(v)}}function l(){var t=0,e=new Z(v),n=document.createTextNode("");return e.observe(n,{characterData:!0}),function(){n.data=t=++t%2}}function p(){var t=new MessageChannel;return t.port1.onmessage=v,function(){t.port2.postMessage(0)}}function d(){return function(){setTimeout(v,1)}}function v(){for(var t=0;W>t;t+=2){var e=et[t],n=et[t+1];e(n),et[t]=void 0,et[t+1]=void 0}W=0}function m(){try{var t=n(30);return z=t.runOnLoop||t.runOnContext,f()}catch(e){return d()}}function h(){}function g(){return new TypeError("You cannot resolve a promise with itself")}function y(){return new TypeError("A promises callback cannot return that same promise.")}function w(t){try{return t.then}catch(e){return it.error=e,it}}function _(t,e,n,r){try{t.call(e,n,r)}catch(o){return o}}function E(t,e,n){G(function(t){var r=!1,o=_(n,e,function(n){r||(r=!0,e!==n?x(t,n):N(t,n))},function(e){r||(r=!0,P(t,e))},"Settle: "+(t._label||" unknown promise"));!r&&o&&(r=!0,P(t,o))},t)}function b(t,e){e._state===rt?N(t,e._result):e._state===ot?P(t,e._result):O(e,void 0,function(e){x(t,e)},function(e){P(t,e)})}function T(t,e){if(e.constructor===t.constructor)b(t,e);else{var n=w(e);n===it?P(t,it.error):void 0===n?N(t,e):i(n)?E(t,e,n):N(t,e)}}function x(t,e){t===e?P(t,g()):o(e)?T(t,e):N(t,e)}function A(t){t._onerror&&t._onerror(t._result),I(t)}function N(t,e){t._state===nt&&(t._result=e,t._state=rt,0!==t._subscribers.length&&G(I,t))}function P(t,e){t._state===nt&&(t._state=ot,t._result=e,G(A,t))}function O(t,e,n,r){var o=t._subscribers,i=o.length;t._onerror=null,o[i]=e,o[i+rt]=n,o[i+ot]=r,0===i&&t._state&&G(I,t)}function I(t){var e=t._subscribers,n=t._state;if(0!==e.length){for(var r,o,i=t._result,s=0;s<e.length;s+=3)r=e[s],o=e[s+n],r?C(n,r,o,i):o(i);t._subscribers.length=0}}function L(){this.error=null}function R(t,e){try{return t(e)}catch(n){return st.error=n,st}}function C(t,e,n,r){var o,s,a,c,u=i(n);if(u){if(o=R(n,r),o===st?(c=!0,s=o.error,o=null):a=!0,e===o)return void P(e,y())}else o=r,a=!0;e._state!==nt||(u&&a?x(e,o):c?P(e,s):t===rt?N(e,o):t===ot&&P(e,o))}function j(t,e){try{e(function(e){x(t,e)},function(e){P(t,e)})}catch(n){P(t,n)}}function S(t,e){var n=this;n._instanceConstructor=t,n.promise=new t(h),n._validateInput(e)?(n._input=e,n.length=e.length,n._remaining=e.length,n._init(),0===n.length?N(n.promise,n._result):(n.length=n.length||0,n._enumerate(),0===n._remaining&&N(n.promise,n._result))):P(n.promise,n._validationError())}function D(t){return new at(this,t).promise}function F(t){function e(t){x(o,t)}function n(t){P(o,t)}var r=this,o=new r(h);if(!H(t))return P(o,new TypeError("You must pass an array to race.")),o;for(var i=t.length,s=0;o._state===nt&&i>s;s++)O(r.resolve(t[s]),void 0,e,n);return o}function M(t){var e=this;if(t&&"object"==typeof t&&t.constructor===e)return t;var n=new e(h);return x(n,t),n}function U(t){var e=this,n=new e(h);return P(n,t),n}function k(){throw new TypeError("You must pass a resolver function as the first argument to the promise constructor")}function B(){throw new TypeError("Failed to construct 'Promise': Please use the 'new' operator, this object constructor cannot be called as a function.")}function $(t){this._id=pt++,this._state=void 0,this._result=void 0,this._subscribers=[],h!==t&&(i(t)||k(),this instanceof $||B(),j(this,t))}function V(){var t;if("undefined"!=typeof global)t=global;else if("undefined"!=typeof self)t=self;else try{t=Function("return this")()}catch(e){throw new Error("polyfill failed because global object is unavailable in this environment")}var n=t.Promise;(!n||"[object Promise]"!==Object.prototype.toString.call(n.resolve())||n.cast)&&(t.Promise=dt)}var q;q=Array.isArray?Array.isArray:function(t){return"[object Array]"===Object.prototype.toString.call(t)};var z,J,Y,H=q,W=0,G=({}.toString,function(t,e){et[W]=t,et[W+1]=e,W+=2,2===W&&(J?J(v):Y())}),K="undefined"!=typeof window?window:void 0,X=K||{},Z=X.MutationObserver||X.WebKitMutationObserver,Q="undefined"!=typeof process&&"[object process]"==={}.toString.call(process),tt="undefined"!=typeof Uint8ClampedArray&&"undefined"!=typeof importScripts&&"undefined"!=typeof MessageChannel,et=new Array(1e3);Y=Q?u():Z?l():tt?p():void 0===K?m():d();var nt=void 0,rt=1,ot=2,it=new L,st=new L;S.prototype._validateInput=function(t){return H(t)},S.prototype._validationError=function(){return new Error("Array Methods must be provided an Array")},S.prototype._init=function(){this._result=new Array(this.length)};var at=S;S.prototype._enumerate=function(){for(var t=this,e=t.length,n=t.promise,r=t._input,o=0;n._state===nt&&e>o;o++)t._eachEntry(r[o],o)},S.prototype._eachEntry=function(t,e){var n=this,r=n._instanceConstructor;s(t)?t.constructor===r&&t._state!==nt?(t._onerror=null,n._settledAt(t._state,e,t._result)):n._willSettleAt(r.resolve(t),e):(n._remaining--,n._result[e]=t)},S.prototype._settledAt=function(t,e,n){var r=this,o=r.promise;o._state===nt&&(r._remaining--,t===ot?P(o,n):r._result[e]=n),0===r._remaining&&N(o,r._result)},S.prototype._willSettleAt=function(t,e){var n=this;O(t,void 0,function(t){n._settledAt(rt,e,t)},function(t){n._settledAt(ot,e,t)})};var ct=D,ut=F,ft=M,lt=U,pt=0,dt=$;$.all=ct,$.race=ut,$.resolve=ft,$.reject=lt,$._setScheduler=a,$._setAsap=c,$._asap=G,$.prototype={constructor:$,then:function(t,e){var n=this,r=n._state;if(r===rt&&!t||r===ot&&!e)return this;var o=new this.constructor(h),i=n._result;if(r){var s=arguments[r-1];G(function(){C(r,o,s,i)})}else O(n,o,t,e);return o},"catch":function(t){return this.then(null,t)}};var vt=V,mt={Promise:dt,polyfill:vt};n(31).amd?(r=function(){return mt}.call(e,n,e,t),!(void 0!==r&&(t.exports=r))):"undefined"!=typeof t&&t.exports&&(t.exports=mt)}).call(this)}).call(e,n(29)(t))},function(t,e){t.exports=function(t){return t.webpackPolyfill||(t.deprecate=function(){},t.paths=[],t.children=[],t.webpackPolyfill=1),t}},function(t,e){},function(t,e){t.exports=function(){throw new Error("define cannot be used indirect")}},function(t,e,n){function r(t){return t=t||h,t.devicePixelRatio?t.devicePixelRatio>=1.5:t.matchMedia?t.matchMedia("only screen and (min-resolution: 144dpi)").matches:!1}function o(t){return t=t||T,/(Trident|MSIE \d)/.test(t)}function i(t){return t=t||T,/MSIE 9/.test(t)}function s(t){return t=t||T,/(iPad|iPhone|iPod)/.test(t)}function a(t){return t=t||T,/^Mozilla\/5\.0 \(Linux; (U; )?Android/.test(t)}function c(){return x}function u(t,e){return t=t||h,e=e||T,t.postMessage&&!(o(e)&&t.opener)}function f(t){t=t||m;try{return!!t.plugins["Shockwave Flash"]||!!new ActiveXObject("ShockwaveFlash.ShockwaveFlash")}catch(e){return!1}}function l(t,e,n){return t=t||h,e=e||m,n=n||T,"ontouchstart"in t||/Opera Mini/.test(n)||e.msMaxTouchPoints>0}function p(){var t=v.body.style;return void 0!==t.transition||void 0!==t.webkitTransition||void 0!==t.mozTransition||void 0!==t.oTransition||void 0!==t.msTransition}function d(){return!!(h.Promise&&h.Promise.resolve&&h.Promise.reject&&h.Promise.all&&h.Promise.race&&function(){var t;return new h.Promise(function(e){t=e}),_.isType("function",t)}())}var v=n(1),m=n(11),h=n(2),g=n(4),y=n(33),w=n(16),_=n(6),E=n(7),b=n(21),T=m.userAgent,x=!1,A=!1,N="twitter-csp-test";b.set("verifyCSP",function(t){var e=v.getElementById(N);A=!0,x=!!t,e&&e.parentNode.removeChild(e)}),g(function(){var t;return w.asBoolean(E.val("widgets:csp"))?x=!0:(t=v.createElement("script"),t.id=N,t.text=b.fullPath("verifyCSP")+"(false);",v.body.appendChild(t),void h.setTimeout(function(){A||(y.warn('TWITTER: Content Security Policy restrictions may be applied to your site. Add <meta name="twitter:widgets:csp" content="on"> to supress this warning.'),y.warn("TWITTER: Please note: Not all embedded timeline and embedded Tweet functionality is supported when CSP is applied."))},5e3))}),t.exports={retina:r,anyIE:o,ie9:i,ios:s,android:a,cspEnabled:c,flashEnabled:f,canPostMessage:u,touch:l,cssTransitions:p,hasPromiseSupport:d}},function(t,e,n){function r(){u("info",p.toRealArray(arguments))}function o(){u("warn",p.toRealArray(arguments))}function i(){u("error",p.toRealArray(arguments))}function s(t){m&&(v[t]=c())}function a(t){var e;m&&(v[t]?(e=c(),r("_twitter",t,e-v[t])):i("timeEnd() called before time() for id: ",t))}function c(){return l.performance&&+l.performance.now()||+new Date}function u(t,e){if(l[d]&&l[d][t])switch(e.length){case 1:l[d][t](e[0]);break;case 2:l[d][t](e[0],e[1]);break;case 3:l[d][t](e[0],e[1],e[2]);break;case 4:l[d][t](e[0],e[1],e[2],e[3]);break;case 5:l[d][t](e[0],e[1],e[2],e[3],e[4]);break;default:0!==e.length&&l[d].warn&&l[d].warn("too many params passed to logger."+t)}}var f=n(10),l=n(2),p=n(6),d=["con","sole"].join(""),v={},m=p.contains(f.href,"tw_debug=true");t.exports={info:r,warn:o,error:i,time:s,timeEnd:a}},function(t,e,n){var r=n(22);t.exports=new r("twttr")}]))}();