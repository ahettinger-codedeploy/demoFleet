$(document).ready(function(){
	var $body = $('body');

	if (! $body.hasClass('home')){
		$('<div class="drawer"></div>').prependTo($body);
		$('<div class="close">').appendTo('.drawer');
		$('.top-search').clone().prependTo('body');
		$('.nav-main').clone().appendTo('.drawer');
		$('.top-bar').clone().appendTo('.drawer');
	}

	$('.top-bar > .fsElementContent > .fsElement').wrap('<li>');
	$('.top-bar > .fsElementContent').wrapInner('<ul>');
	$('#fsPoweredByFinalsite').appendTo('#fsFooter .fsBanner');
	
	$body.on('click', '.top-bar .mobile.search, .mobile.search-trigger', function(){
		$body.addClass('search-open');
	});
	
	$body.on('click', '.top-search footer', function(){
		$body.removeClass('search-open');
	});

	if (! $body.hasClass('home')){
		$('.drawer-trigger').on('click', function(e) {
			$body.addClass('nav-open');
			e.stopPropagation();
		});

		$(document).on('click', function (e) {
			$body.removeClass('nav-open');
		});

		$('.close').on('click', function(){
			$body.removeClass('nav-open');
		});

	}

	if ($body.hasClass('home')){

		$('.right').each(function(){
			var rsrc = $(this).find('img').attr('src');
			$(this).css('background-image', 'url('+ rsrc +')');
		});

		$body.on('click', '.top-bar .mobile.menu', function(){
			$body.addClass('nav-open');
		});

		$body.on('click', '.quick-links footer', function(){
			$body.removeClass('nav-open');
		});

	}

	$('.fsNews.fsList article').each(function(){
		var nsrc = $(this).find('.fsThumbnail img').attr('src');
		$(this).find('.fsThumbnail').css('background-image', 'url('+ nsrc +')');
		$(this).wrapInner('<div class="news-post">');
		$(this).find('.fsThumbnail').insertBefore($(this).find('.news-post'));
	});
	
function appendNewsThumbnails() {
  setTimeout(function() {
    $('.fsNews.fsList .fsListItems:last article').each(function(){
      var nsrc = $(this).find('.fsThumbnail img').attr('src');
      $(this).find('.fsThumbnail').css('background-image', 'url('+ nsrc +')');
      $(this).wrapInner('<div class="news-post">');
      $(this).find('.fsThumbnail').insertBefore($(this).find('.news-post'));
    });

	// Rebind event since new Load More button is added each time it is clicked
    $('.fsLoadMoreButton').on('click', function() {
      appendNewsThumbnails();
    });

  }, 2000)
}

$('.fsLoadMoreButton').on('click', function() {
  appendNewsThumbnails();
});

	if($('.interior-banner').length){
		var is = $('.interior-banner img').attr('src');
		$('.interior-banner').css('background', 'url('+ is +')');
	}

});


function getFacebook(e,t,n){var n=n||5,r="/cf_endpoints/facebook.cfm?id="+e;$.getJSON(r,function(e){function r(e,t){var n=t.object_id,r="/cf_endpoints/facebook.cfm?action=photo&id="+n;$j.getJSON(r,function(t){photo_src=t.source,e.prepend('<div class="entry-photo"><img src="'+photo_src+'" ></div>')})}for(var a=e.data,o=0;o<a.length&&n>=o;o++){var i=a[o],c=i.message,s=(i.link,i.status_type);if(void 0!=c&&n>0&&("added_photos"===s||"shared_story"===s)){var l='<article class="facebook-post">';l+='<div class="entry-content">'+i.message+"</div>",l+='<a class="read-more" href="'+i.link+'" target="_blank">Read More</a>',l+="</article>",$(l).appendTo(t),n--,i.picture&&r(post,i)}}})}function socialFeedsInit(){var e=[{url:"http://www.facebook.com/feeds/page.php?format=atom10&id=59975660449",classname:"facebook",target:"#facebook-feed",number:3,loaded:!1}];for(i=0;i<e.length;i++)loadFeed(e[i]);var t=setInterval(function(){$("body").data("twttr-rendered")===!0&&($(".fsTwitter").each(function(){renderTweets(this)}),clearInterval(t))},100)}function loadFeed(e){var t=escape(e.url),n=e.classname,r="http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&callback=?&q="+t+"&num="+e.number,a=$(e.target);$.getJSON(r,function(r){if(200===r.responseStatus){for(var o=r.responseData.feed.entries,i=0;i<o.length;i++){var c=o[i],s=c.link,l='<div class="entry '+n+'-entry">';l+='<div class="entry-title"><a href="'+c.link+'" target="_blank">'+c.title+"</a></div>",l+='<div class="entry-content">'+c.content+"</div>",l+="</div>";var u=$(l).appendTo(a);switch(e.classname){case"instagram":$("img",u).eq(1).appendTo(u).wrap('<div class="img-wrap"><a href="'+s+'" target="_blank">');break;case"facebook":$("img",u).each(function(e){e>0&&$(this).remove()})}}e.loaded=!0}else console.log("failed to load :"+t)})}function renderTweets(e){var t=setInterval(function(){if($('iframe[id*="twitter"]').contents().find(".tweet").length>0){clearInterval(t);var n=$(e).find('iframe[id*="twitter"]').contents(),r=n.find(".tweet"),a=3;$(e).append('<ul class="tweets">'),r.each(function(t){a+1>t&&$(this).appendTo($(e).find(".tweets"))})}},100)}function backgroundImage(e){backgroundElement=e,$(backgroundElement).each(function(){var e=$(this).find("img").attr("src");$(this).css("background-image","url("+e+")")})}function date(){var e,t,n=".date-container",r=new Date,a=r.getYear(),o=r.getDay(),i=r.getMonth(),c=r.getDate(),s=r.getHours();e=s%12||12,t=12>s?"am":"pm";var l=r.getMinutes()<10?"0"+r.getMinutes():r.getMinutes();1e3>a&&(a+=1900),10>c&&(c="0"+c);var u=new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"),d=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),f='<div class="date"><div class="day">'+u[o]+',</div><div class="month"> '+d[i]+" "+c+'</div><div class="time">'+e+":"+l+" "+t+"</div></div>";$(n).html(f)}!function(e,t,n,r){e.fn.doubleTapToGo=function(r){return"ontouchstart"in t||navigator.msMaxTouchPoints||navigator.userAgent.toLowerCase().match(/windows phone os 7/i)?(this.each(function(){var t=!1;e(this).on("click",function(n){var r=e(this);r[0]!=t[0]&&(n.preventDefault(),t=r)}),e(n).on("click touchstart MSPointerDown",function(n){for(var r=!0,a=e(n.target).parents(),o=0;o<a.length;o++)a[o]==t[0]&&(r=!1);r&&(t=!1)})}),this):!1}}(jQuery,window,document),$(".home-photos .fsMediaCustomPlayer, .landing-slider .fsMediaCustomPlayer").each(function(){var e=$(this),t=e.data("playlisturl");$.get(t,function(t){$(t.objects).each(function(){var t='<div class="slide" style="background-image: url('+this.full_path+');">';t+="</div>",e.append(t)}),$(e).slick({fade:!0,arrows:!1,autoplay:!0})})}),function(e){e.useOverview=function(t,n){var r={nav:" ul:eq(0)",tier:2},a=this;a.settings={};var t=(e(t),t);a.init=function(){a.settings=e.extend({},r,n),e(">li",t).each(function(){var t=e("ul a",this).eq(0).attr("href");e(">a",this).attr("href",t)})},a.foo_public_method=function(){};a.init()},e.fn.useOverview=function(t){return this.each(function(){if(void 0==e(this).data("useOverview")){var n=new e.useOverview(this,t);e(this).data("useOverview",n)}})}}(jQuery),window.Modernizr=function(e,t,n){function r(e){y.cssText=e}function a(e,t){return typeof e===t}function o(e,t){return!!~(""+e).indexOf(t)}function i(e,t){for(var r in e){var a=e[r];if(!o(a,"-")&&y[a]!==n)return"pfx"==t?a:!0}return!1}function c(e,t,r){for(var o in e){var i=t[e[o]];if(i!==n)return r===!1?e[o]:a(i,"function")?i.bind(r||t):i}return!1}function s(e,t,n){var r=e.charAt(0).toUpperCase()+e.slice(1),o=(e+" "+k.join(r+" ")+r).split(" ");return a(t,"string")||a(t,"undefined")?i(o,t):(o=(e+" "+S.join(r+" ")+r).split(" "),c(o,t,n))}var l,u,d,f="2.8.3",p={},m=!0,h=t.documentElement,v="modernizr",g=t.createElement(v),y=g.style,b={}.toString,w=" -webkit- -moz- -o- -ms- ".split(" "),E="Webkit Moz O ms",k=E.split(" "),S=E.toLowerCase().split(" "),T={svg:"http://www.w3.org/2000/svg"},$={},C=[],j=C.slice,x=function(e,n,r,a){var o,i,c,s,l=t.createElement("div"),u=t.body,d=u||t.createElement("body");if(parseInt(r,10))for(;r--;)c=t.createElement("div"),c.id=a?a[r]:v+(r+1),l.appendChild(c);return o=["­",'<style id="s',v,'">',e,"</style>"].join(""),l.id=v,(u?l:d).innerHTML+=o,d.appendChild(l),u||(d.style.background="",d.style.overflow="hidden",s=h.style.overflow,h.style.overflow="hidden",h.appendChild(d)),i=n(l,e),u?l.parentNode.removeChild(l):(d.parentNode.removeChild(d),h.style.overflow=s),!!i},M=function(t){var n=e.matchMedia||e.msMatchMedia;if(n)return n(t)&&n(t).matches||!1;var r;return x("@media "+t+" { #"+v+" { position: absolute; } }",function(t){r="absolute"==(e.getComputedStyle?getComputedStyle(t,null):t.currentStyle).position}),r},N={}.hasOwnProperty;d=a(N,"undefined")||a(N.call,"undefined")?function(e,t){return t in e&&a(e.constructor.prototype[t],"undefined")}:function(e,t){return N.call(e,t)},Function.prototype.bind||(Function.prototype.bind=function(e){var t=this;if("function"!=typeof t)throw new TypeError;var n=j.call(arguments,1),r=function(){if(this instanceof r){var a=function(){};a.prototype=t.prototype;var o=new a,i=t.apply(o,n.concat(j.call(arguments)));return Object(i)===i?i:o}return t.apply(e,n.concat(j.call(arguments)))};return r}),$.flexbox=function(){return s("flexWrap")},$.flexboxlegacy=function(){return s("boxDirection")},$.touch=function(){var n;return"ontouchstart"in e||e.DocumentTouch&&t instanceof DocumentTouch?n=!0:x(["@media (",w.join("touch-enabled),("),v,")","{#modernizr{top:9px;position:absolute}}"].join(""),function(e){n=9===e.offsetTop}),n},$.cssanimations=function(){return s("animationName")},$.csscolumns=function(){return s("columnCount")},$.csstransforms=function(){return!!s("transform")},$.csstransforms3d=function(){var e=!!s("perspective");return e&&"webkitPerspective"in h.style&&x("@media (transform-3d),(-webkit-transform-3d){#modernizr{left:9px;position:absolute;height:3px;}}",function(t,n){e=9===t.offsetLeft&&3===t.offsetHeight}),e},$.csstransitions=function(){return s("transition")},$.video=function(){var e=t.createElement("video"),n=!1;try{(n=!!e.canPlayType)&&(n=new Boolean(n),n.ogg=e.canPlayType('video/ogg; codecs="theora"').replace(/^no$/,""),n.h264=e.canPlayType('video/mp4; codecs="avc1.42E01E"').replace(/^no$/,""),n.webm=e.canPlayType('video/webm; codecs="vp8, vorbis"').replace(/^no$/,""))}catch(r){}return n},$.audio=function(){var e=t.createElement("audio"),n=!1;try{(n=!!e.canPlayType)&&(n=new Boolean(n),n.ogg=e.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/,""),n.mp3=e.canPlayType("audio/mpeg;").replace(/^no$/,""),n.wav=e.canPlayType('audio/wav; codecs="1"').replace(/^no$/,""),n.m4a=(e.canPlayType("audio/x-m4a;")||e.canPlayType("audio/aac;")).replace(/^no$/,""))}catch(r){}return n},$.svg=function(){return!!t.createElementNS&&!!t.createElementNS(T.svg,"svg").createSVGRect},$.inlinesvg=function(){var e=t.createElement("div");return e.innerHTML="<svg/>",(e.firstChild&&e.firstChild.namespaceURI)==T.svg},$.svgclippaths=function(){return!!t.createElementNS&&/SVGClipPath/.test(b.call(t.createElementNS(T.svg,"clipPath")))};for(var P in $)d($,P)&&(u=P.toLowerCase(),p[u]=$[P](),C.push((p[u]?"":"no-")+u));return p.addTest=function(e,t){if("object"==typeof e)for(var r in e)d(e,r)&&p.addTest(r,e[r]);else{if(e=e.toLowerCase(),p[e]!==n)return p;t="function"==typeof t?t():t,"undefined"!=typeof m&&m&&(h.className+=" "+(t?"":"no-")+e),p[e]=t}return p},r(""),g=l=null,function(e,t){function n(e,t){var n=e.createElement("p"),r=e.getElementsByTagName("head")[0]||e.documentElement;return n.innerHTML="x<style>"+t+"</style>",r.insertBefore(n.lastChild,r.firstChild)}function r(){var e=y.elements;return"string"==typeof e?e.split(" "):e}function a(e){var t=g[e[h]];return t||(t={},v++,e[h]=v,g[v]=t),t}function o(e,n,r){if(n||(n=t),u)return n.createElement(e);r||(r=a(n));var o;return o=r.cache[e]?r.cache[e].cloneNode():m.test(e)?(r.cache[e]=r.createElem(e)).cloneNode():r.createElem(e),!o.canHaveChildren||p.test(e)||o.tagUrn?o:r.frag.appendChild(o)}function i(e,n){if(e||(e=t),u)return e.createDocumentFragment();n=n||a(e);for(var o=n.frag.cloneNode(),i=0,c=r(),s=c.length;s>i;i++)o.createElement(c[i]);return o}function c(e,t){t.cache||(t.cache={},t.createElem=e.createElement,t.createFrag=e.createDocumentFragment,t.frag=t.createFrag()),e.createElement=function(n){return y.shivMethods?o(n,e,t):t.createElem(n)},e.createDocumentFragment=Function("h,f","return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&("+r().join().replace(/[\w\-]+/g,function(e){return t.createElem(e),t.frag.createElement(e),'c("'+e+'")'})+");return n}")(y,t.frag)}function s(e){e||(e=t);var r=a(e);return y.shivCSS&&!l&&!r.hasCSS&&(r.hasCSS=!!n(e,"article,aside,dialog,figcaption,figure,footer,header,hgroup,main,nav,section{display:block}mark{background:#FF0;color:#000}template{display:none}")),u||c(e,r),e}var l,u,d="3.7.0",f=e.html5||{},p=/^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i,m=/^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i,h="_html5shiv",v=0,g={};!function(){try{var e=t.createElement("a");e.innerHTML="<xyz></xyz>",l="hidden"in e,u=1==e.childNodes.length||function(){t.createElement("a");var e=t.createDocumentFragment();return"undefined"==typeof e.cloneNode||"undefined"==typeof e.createDocumentFragment||"undefined"==typeof e.createElement}()}catch(n){l=!0,u=!0}}();var y={elements:f.elements||"abbr article aside audio bdi canvas data datalist details dialog figcaption figure footer header hgroup main mark meter nav output progress section summary template time video",version:d,shivCSS:f.shivCSS!==!1,supportsUnknownElements:u,shivMethods:f.shivMethods!==!1,type:"default",shivDocument:s,createElement:o,createDocumentFragment:i};e.html5=y,s(t)}(this,t),p._version=f,p._prefixes=w,p._domPrefixes=S,p._cssomPrefixes=k,p.mq=M,p.testProp=function(e){return i([e])},p.testAllProps=s,p.testStyles=x,h.className=h.className.replace(/(^|\s)no-js(\s|$)/,"$1$2")+(m?" js "+C.join(" "):""),p}(this,this.document),function(e,t,n){function r(e){return"[object Function]"==v.call(e)}function a(e){return"string"==typeof e}function o(){}function i(e){return!e||"loaded"==e||"complete"==e||"uninitialized"==e}function c(){var e=g.shift();y=1,e?e.t?m(function(){("c"==e.t?f.injectCss:f.injectJs)(e.s,0,e.a,e.x,e.e,1)},0):(e(),c()):y=0}function s(e,n,r,a,o,s,l){function u(t){if(!p&&i(d.readyState)&&(b.r=p=1,!y&&c(),d.onload=d.onreadystatechange=null,t)){"img"!=e&&m(function(){E.removeChild(d)},50);for(var r in C[n])C[n].hasOwnProperty(r)&&C[n][r].onload()}}var l=l||f.errorTimeout,d=t.createElement(e),p=0,v=0,b={t:r,s:n,e:o,a:s,x:l};1===C[n]&&(v=1,C[n]=[]),"object"==e?d.data=n:(d.src=n,d.type=e),d.width=d.height="0",d.onerror=d.onload=d.onreadystatechange=function(){u.call(this,v)},g.splice(a,0,b),"img"!=e&&(v||2===C[n]?(E.insertBefore(d,w?null:h),m(u,l)):C[n].push(d))}function l(e,t,n,r,o){return y=0,t=t||"j",a(e)?s("c"==t?S:k,e,t,this.i++,n,r,o):(g.splice(this.i++,0,e),1==g.length&&c()),this}function u(){var e=f;return e.loader={load:l,i:0},e}var d,f,p=t.documentElement,m=e.setTimeout,h=t.getElementsByTagName("script")[0],v={}.toString,g=[],y=0,b="MozAppearance"in p.style,w=b&&!!t.createRange().compareNode,E=w?p:h.parentNode,p=e.opera&&"[object Opera]"==v.call(e.opera),p=!!t.attachEvent&&!p,k=b?"object":p?"script":"img",S=p?"script":k,T=Array.isArray||function(e){return"[object Array]"==v.call(e)},$=[],C={},j={timeout:function(e,t){return t.length&&(e.timeout=t[0]),e}};f=function(e){function t(e){var t,n,r,e=e.split("!"),a=$.length,o=e.pop(),i=e.length,o={url:o,origUrl:o,prefixes:e};for(n=0;i>n;n++)r=e[n].split("="),(t=j[r.shift()])&&(o=t(o,r));for(n=0;a>n;n++)o=$[n](o);return o}function i(e,a,o,i,c){var s=t(e),l=s.autoCallback;s.url.split(".").pop().split("?").shift(),s.bypass||(a&&(a=r(a)?a:a[e]||a[i]||a[e.split("/").pop().split("?")[0]]),s.instead?s.instead(e,a,o,i,c):(C[s.url]?s.noexec=!0:C[s.url]=1,o.load(s.url,s.forceCSS||!s.forceJS&&"css"==s.url.split(".").pop().split("?").shift()?"c":n,s.noexec,s.attrs,s.timeout),(r(a)||r(l))&&o.load(function(){u(),a&&a(s.origUrl,c,i),l&&l(s.origUrl,c,i),C[s.url]=2})))}function c(e,t){function n(e,n){if(e){if(a(e))n||(d=function(){var e=[].slice.call(arguments);f.apply(this,e),p()}),i(e,d,t,0,l);else if(Object(e)===e)for(s in c=function(){var t,n=0;for(t in e)e.hasOwnProperty(t)&&n++;return n}(),e)e.hasOwnProperty(s)&&(!n&&!--c&&(r(d)?d=function(){var e=[].slice.call(arguments);f.apply(this,e),p()}:d[s]=function(e){return function(){var t=[].slice.call(arguments);e&&e.apply(this,t),p()}}(f[s])),i(e[s],d,t,s,l))}else!n&&p()}var c,s,l=!!e.test,u=e.load||e.both,d=e.callback||o,f=d,p=e.complete||o;n(l?e.yep:e.nope,!!u),u&&n(u)}var s,l,d=this.yepnope.loader;if(a(e))i(e,0,d,0);else if(T(e))for(s=0;s<e.length;s++)l=e[s],a(l)?i(l,0,d,0):T(l)?f(l):Object(l)===l&&c(l,d);else Object(e)===e&&c(e,d)},f.addPrefix=function(e,t){j[e]=t},f.addFilter=function(e){$.push(e)},f.errorTimeout=1e4,null==t.readyState&&t.addEventListener&&(t.readyState="loading",t.addEventListener("DOMContentLoaded",d=function(){t.removeEventListener("DOMContentLoaded",d,0),t.readyState="complete"},0)),e.yepnope=u(),e.yepnope.executeStack=c,e.yepnope.injectJs=function(e,n,r,a,s,l){var u,d,p=t.createElement("script"),a=a||f.errorTimeout;p.src=e;for(d in r)p.setAttribute(d,r[d]);n=l?c:n||o,p.onreadystatechange=p.onload=function(){!u&&i(p.readyState)&&(u=1,n(),p.onload=p.onreadystatechange=null)},m(function(){u||(u=1,n(1))},a),s?p.onload():h.parentNode.insertBefore(p,h)},e.yepnope.injectCss=function(e,n,r,a,i,s){var l,a=t.createElement("link"),n=s?c:n||o;a.href=e,a.rel="stylesheet",a.type="text/css";for(l in r)a.setAttribute(l,r[l]);i||(h.parentNode.insertBefore(a,h),m(n,0))}}(this,document),Modernizr.load=function(){yepnope.apply(window,[].slice.call(arguments,0))};