// RESPONSIVE PAGELIST MENU VERSION 2
// AUTHOR BRENTON KELLY - CREATIVE SERVICES DEVELOPMENT MANAGER - SCHOOLWIRES, INC.
// VERSION 09.16.15

!function(A){A.fn.csRsPagelistMenu=function(e){var s={breakPoint:480,slideDirection:"left-to-right",primaryColor:"#1A1A1A",secondaryColor:"#0C0C0C",accentColor:"#BABABA",menuButtonParent:"#sp-content",showMenuBtnText:"no",menuBtnText:"Pages",siteID:"",allLoaded:function(){}};return e&&A.extend(s,e),this.each(function(){function e(){if(!A("div.ui-widget.app.pagenavigation:eq(0) ul.page-navigation").length)return!1;var e="",l="",o="";A("div.ui-widget.app.pagenavigation:eq(0) ul.page-navigation > li").each(function(){jQuery.trim(A("> a span",this).text());l=A(this).find("ul");var s=A(l).length?"<div class='rs-pagelist-menu-bullet'></div>":"";o=A(this).hasClass("active")?" active":"",e+=A("> a span",this).length?'<li class="rs-pagelist-menu-link'+o+'"><div class="rs-pagelist-menu-link-inner">'+s+A(this).html():'<li class="rs-pagelist-menu-link'+o+'"><div class="rs-pagelist-menu-link-inner">'+s+A(this).html()});var r='<div id="rs-pagelist-menu-bg" class="closed sw-native-hide"></div><div id="rs-pagelist-menu" class="closed sw-native-hide"><div id="rs-pagelist-menu-header"><div id="rs-pagelist-menu-search"><form id="rs-pagelist-menu-search-form" class="ui-clear"><input type="text" id="rs-pagelist-menu-search-input" value="Search" /><a href="#" id="rs-pagelist-menu-search-button"><span class="hidden">Go</span></a></form></div><a href="#" id="rs-pagelist-menu-close-btn"><span class="hidden">Close</span></a></div><div class="rs-pagelist-menu-links-list"><ul class="rs-pagelist-menu-links">'+e+"</ul></div>";A(a).append(r),A(".rs-pagelist-menu-link").each(function(){A(".bullet",this).remove(),A("ul",this).removeAttr("style"),A(".rs-pagelist-menu-link-inner > ul",this).addClass("rs-pagelist-submenu-links closed").prepend('<li class="rs-pagelist-submenu-header ui-clear"><div class="rs-pagelist-submenu-back">Back</div><div class="rs-pagelist-submenu-close"></div></li><li class="rs-pagelist-submenu-name"><h1>'+jQuery.trim(A(".rs-pagelist-menu-link-inner > a span",this).text())+"</h1></li>")});var g="";"yes"==s.showMenuBtnText&&(g="<span>"+s.menuBtnText+"</span>"),A(s.menuButtonParent).prepend("<div id='rs-pagelist-menu-btn' class='sw-native-hide'>"+g+"</div>"),i(),n(),t(),s.allLoaded.call(this)}function n(){A("#rs-pagelist-menu-btn").click(function(e){e.preventDefault();var n="left",t={left:"0px"};"right-to-left"==s.slideDirection&&(n="right",t={right:"0px"}),A("#rs-pagelist-menu-bg").fadeIn(function(){A("#rs-pagelist-menu-bg").removeClass("closed").addClass("open").removeAttr("style"),A("#rs-pagelist-menu").removeClass("closed").addClass("open"),A("#rs-pagelist-menu").animate(t,500)})}),A("#rs-pagelist-menu-close-btn").click(function(e){e.preventDefault();var n="left",t={left:"-320px"};"right-to-left"==s.slideDirection&&(n="right",t={right:"-320px"}),A("#rs-pagelist-menu").animate(t,500,function(){A("#rs-pagelist-menu").removeClass("open").addClass("closed"),A("#rs-pagelist-menu-bg").fadeOut(function(){A("#rs-pagelist-menu-bg").removeClass("open").addClass("closed").removeAttr("style")})})}),A("#rs-pagelist-menu-bg").click(function(){var e="left",n={left:"-320px"};"right-to-left"==s.slideDirection&&(e="right",n={right:"-320px"}),A(".rs-pagelist-submenu-links.open").length?A(".rs-pagelist-submenu-links.open").animate(n,500,function(){A(".rs-pagelist-submenu-links.open").removeClass("open").addClass("closed"),A("#rs-pagelist-menu").animate(n,500,function(){A("#rs-pagelist-menu").removeClass("open").addClass("closed"),A("#rs-pagelist-menu-bg").fadeOut(function(){A("#rs-pagelist-menu-bg").removeClass("open").addClass("closed").removeAttr("style")})})}):A("#rs-pagelist-menu").animate(n,500,function(){A("#rs-pagelist-menu").removeClass("open").addClass("closed"),A("#rs-pagelist-menu-bg").fadeOut(function(){A("#rs-pagelist-menu-bg").removeClass("open").addClass("closed").removeAttr("style")})})}),A(".rs-pagelist-submenu-close").click(function(){var e="left",n={left:"-320px"};"right-to-left"==s.slideDirection&&(e="right",n={right:"-320px"}),A(".rs-pagelist-submenu-links.open").animate(n,500,function(){A(".rs-pagelist-submenu-links.open").removeClass("open").addClass("closed"),A("#rs-pagelist-menu").animate(n,500,function(){A("#rs-pagelist-menu").removeClass("open").addClass("closed"),A("#rs-pagelist-menu-bg").fadeOut(function(){A("#rs-pagelist-menu-bg").removeClass("open").addClass("closed").removeAttr("style")})})})}),A(".rs-pagelist-submenu-back").click(function(){var e="left",n={left:"-320px"};"right-to-left"==s.slideDirection&&(e="right",n={right:"-320px"}),A(".rs-pagelist-submenu-links.open").animate(n,500,function(){A(".rs-pagelist-submenu-links.open").removeClass("open").addClass("closed")})}),A(".rs-pagelist-menu-bullet").click(function(){var e=A(this).parent().parent(),n="left",t={left:"0px"};"right-to-left"==s.slideDirection&&(n="right",t={right:"0px"}),A(".rs-pagelist-submenu-links",e).animate(t,500,function(){A(".rs-pagelist-submenu-links",e).removeClass("closed").addClass("open")})}),A("#rs-pagelist-menu-search-button").click(function(e){e.preventDefault(),window.location.href="/site/Default.aspx?PageType=6&SiteID="+s.siteID+"&SearchString="+A("#rs-pagelist-menu-search-form #rs-pagelist-menu-search-input").val()}),A("#rs-pagelist-menu-search-form").submit(function(e){e.preventDefault(),window.location.href="/site/Default.aspx?PageType=6&SiteID="+s.siteID+"&SearchString="+A("#rs-pagelist-menu-search-form #rs-pagelist-menu-search-input").val()}),A("#rs-pagelist-menu-search-input").focus(function(){"Search"==A(this).val()&&A(this).val("")}),A("#rs-pagelist-menu-search-input").blur(function(){""==A(this).val()&&A(this).val("Search")})}function t(){var n,t=A(window).width();switch(s.breakPoint){case 768:n=1023;break;case 640:n=767;break;case 480:n=639;break;case 320:n=479;break;default:n=s.breakPoint}n>=t&&(A("#rs-pagelist-menu").length||e())}function i(){var e;switch(s.breakPoint){case 768:e=1023;break;case 640:e=767;break;case 480:e=639;break;case 320:e=479;break;default:e=s.breakPoint}var n=document.createElement("style");if(n){n.setAttribute("type","text/css");var t=document.getElementsByTagName("head")[0];t&&t.insertBefore(n,t.childNodes[0]);var i="left";"right-to-left"==s.slideDirection&&(i="right");var a="top: 0px;";A(".sw-skipnav-outerbar").length&&(a="top: 30px;");var l="body {position: relative;}.hidden {display: none;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNSqOCaDZZVv73zpFSwE4Va2k.woff2) format('woff2');unicode-range: U+0460-052F, U+20B4, U+2DE0-2DFF, U+A640-A69F;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNStWlIHla9B101mdmTHF3-q0.woff2) format('woff2');unicode-range: U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNSlMRqIICSqEqsEoDxn8ddME.woff2) format('woff2');unicode-range: U+0900-097F, U+1CD0-1CF6, U+1CF8-1CF9, U+200B-200D, U+20A8, U+20B9, U+25CC;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNSqWHppw2c1XOp6B2yhU8z7c.woff2) format('woff2');unicode-range: U+1F00-1FFF;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNSuji7H8UD0RUWSM-55zrR4g.woff2) format('woff2');unicode-range: U+0370-03FF;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNSsw0n1X1lV_hRH3yZFpIE9Q.woff2) format('woff2');unicode-range: U+0102-0103, U+1EA0-1EF1, U+20AB;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNSiYtBUPDK3WL7KRKS_3q7OE.woff2) format('woff2');unicode-range: U+0100-024F, U+1E00-1EFF, U+20A0-20AB, U+20AD-20CF, U+2C60-2C7F, U+A720-A7FF;}@font-face {font-family: 'Open Sans';font-style: normal;font-weight: 600;src: local('Open Sans Semibold'), local('OpenSans-Semibold'), url(http://fonts.gstatic.com/s/opensans/v10/MTP_ySUJH_bn48VBG8sNShampu5_7CjHW5spxoeN3Vs.woff2) format('woff2');unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2212, U+2215, U+E0FF, U+EFFD, U+F000;}@font-face {font-family: 'rs-menu';src: url(//extend.schoolwires.com/creative/scripts/creative/responsive/creative-responsive-pagelist-menu-v2/rs-menu-files/rs-menu.eot);}@font-face {font-family: 'rs-menu';src: url(data:application/x-font-ttf;charset=utf-8;base64,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) format('truetype'),url(data:application/font-woff;charset=utf-8;base64,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) format('woff');font-weight: normal;font-style: normal;}.rs-menu-font {font-family: 'rs-menu';speak: none;font-size: 22px;font-style: normal;font-weight: normal;font-variant: normal;text-transform: none;line-height: 1;-webkit-font-smoothing: antialiased;-moz-osx-font-smoothing: grayscale;}#rs-pagelist-menu-bg, #rs-pagelist-menu.closed, #rs-pagelist-menu.open, #rs-pagelist-menu-btn {display: none;}#rs-pagelist-menu-bg {width: 100%;height: 100%;position: fixed;top: 0px;left: 0px;background: rgba(0, 0, 0, .7);z-index: 20000;}#rs-pagelist-menu {width: 320px;position: absolute;"+a+"bottom: 0px;"+i+": -320px;background: "+s.primaryColor+';z-index: 20000;overflow-x: hidden;overflow-y: auto;-moz-box-shadow: 0px 0px 100px rgba(0, 0, 0, .75);-webkit-box-shadow: 0px 0px 100px rgba(0, 0, 0, .75);box-shadow: 0px 0px 100px rgba(0, 0, 0, .75);}#rs-pagelist-menu-btn {position: relative;cursor: pointer;}#rs-pagelist-menu-btn:before {content: "n";font-size: 15px;color: #FFF;font-family: "rs-menu";display: inline-block;padding: 15px;background: rgba(0, 0, 0, .4);-moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;}#rs-pagelist-menu-btn span {display: inline-block;padding: 0px 0px 0px 10px;}#rs-pagelist-menu-header {position: relative;}#rs-pagelist-menu-close-btn {width: 45px;height: 45px;position: absolute;top: 0px;right: 0px;text-decoration: none;}#rs-pagelist-menu-close-btn:before {content: "C";font-family: "rs-menu";font-size: 13px;color: '+s.accentColor+';text-align: center;line-height: 45px;display: block;}#rs-pagelist-menu-search-button {width: 35px;height: 45px;text-decoration: none;position: absolute;top: 0px;left: 0px;}#rs-pagelist-menu-search-button:before {content: "s";font-family: "rs-menu";font-size: 12px;color: '+s.accentColor+";text-align: center;line-height: 45px;display: block;}#rs-pagelist-menu-search-input {width: 100%;font: 600 14px/1 'Open Sans', sans-serif;color: #FFF;background: transparent;height: 45px;margin: 0px;padding: 0px 45px 0px 35px;border: 0px;-moz-border-radius: 0px;-webkit-border-radius: 0px;border-radius: 0px;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;}#rs-pagelist-menu-search-input:focus {outline: none;}.rs-pagelist-submenu-links {width: 320px;position: absolute;top: 0px;bottom: 0px;"+i+": -320px;background: "+s.primaryColor+";z-index: 1;overflow-x: hidden;overflow-y: auto;}#rs-pagelist-menu ul {margin: 0px;padding: 0px;list-style: none;}.rs-pagelist-menu-links {background: #FFF;}.rs-pagelist-menu-links > li .rs-pagelist-menu-link-inner {margin: 0px 15px;border-top: solid 1px "+s.accentColor+";}.rs-pagelist-menu-links > li:first-child .rs-pagelist-menu-link-inner {border: none;}.rs-pagelist-menu-links > li a {display: block;font: 600 16px/1 'Open Sans', sans-serif;text-decoration: none;color: "+s.primaryColor+';padding: 15px 0px;margin: 0px 30px 0px 0px;position: relative;}.rs-pagelist-menu-bullet {width: 45px;height: 45px;float: right;margin: 0px -15px 0px 0px;position: relative;cursor: pointer;}.rs-pagelist-menu-bullet:before {content: "e";font-family: "rs-menu";font-size: 12px;color: '+s.accentColor+";text-align: center;line-height: 48px;display: block;}.rs-pagelist-submenu-links {width: 320px;position: absolute;top: 0px;bottom: 0px;"+i+": -320px;background: "+s.primaryColor+";z-index: 1;overflow-x: hidden;overflow-y: auto;}.rs-pagelist-submenu-links > li {margin: 0px 15px;border-top: solid 1px "+s.accentColor+";}.rs-pagelist-submenu-links > li.rs-pagelist-submenu-header, .rs-pagelist-submenu-links > li.rs-pagelist-submenu-name {margin: 0px;border: none;}.rs-pagelist-submenu-links > li.rs-pagelist-submenu-header {background: "+s.secondaryColor+";}.rs-pagelist-submenu-links > li.rs-pagelist-submenu-name {background: #FFF;}.rs-pagelist-submenu-links > li.rs-pagelist-submenu-name h1 {font: 600 16px/1 'Open Sans', sans-serif;text-decoration: none;text-transform: uppercase;color: "+s.primaryColor+';padding: 15px;}.rs-pagelist-submenu-back {height: 45px;float: left;font: 600 14px/45px \'Open Sans\', sans-serif;color: #FFF;cursor: pointer;margin: 0px 0px 0px 15px;}.rs-pagelist-submenu-back:before {content: "b";font-family: "rs-menu";font-size: 14px;line-height: 45px;color: '+s.accentColor+';display: inline-block;padding: 0px 10px 0px 0px;}.rs-pagelist-submenu-close {width: 45px;height: 45px;float: right;cursor: pointer;}.rs-pagelist-submenu-close:before {content: "C";font-family: "rs-menu";font-size: 13px;color: '+s.accentColor+";text-align: center;line-height: 45px;display: block;}.rs-pagelist-submenu-links li {border-top: solid 1px "+s.accentColor+";}.rs-pagelist-submenu-links li:nth-child(3) {border: none;}.rs-pagelist-submenu-links > li a {display: block;font: 600 14px/1 'Open Sans', sans-serif;text-decoration: none;color: #FFF;padding: 15px 0px;margin: 0px;position: relative;}.rs-pagelist-submenu-links > li > ul li a {padding: 15px 30px 15px 30px;}.rs-pagelist-submenu-links > li > ul li a:before {content: \"•\";display: inline-block;padding: 0px 5px 0px 0px;}.rs-pagelist-submenu-links > li > ul li > ul li a {padding: 15px 30px 15px 60px;}.rs-pagelist-submenu-links > li > ul li > ul li > ul li a {padding: 15px 30px 15px 90px;}.rs-pagelist-submenu-links > li > ul li > ul li > ul li > ul li a {padding: 15px 30px 15px 120px;}.rs-pagelist-submenu-links > li > ul li > ul li > ul li > ul li > ul li a {padding: 15px 30px 15px 150px;}@media (max-width: "+e+"px) {#rs-pagelist-menu-bg.open, #rs-pagelist-menu.open {display: block;}#rs-pagelist-menu, #rs-pagelist-menu-btn {display: block;}}",o=document.createTextNode(l);n.styleSheet?n.styleSheet.cssText=l:n.appendChild(o)}}var a=this;A(window).bind("resize",t);var l,o=A(window).width();switch(s.breakPoint){case 768:l=1023;break;case 640:l=767;break;case 480:l=639;break;case 320:l=479;break;default:l=s.breakPoint}l>=o&&(A("#rs-pagelist-menu").length||e())})}}(jQuery);