(function(a){function b(f,c){var g,e,h;f=f.split(".");c=c.split(".");e=Math.min(f.length,c.length);for(g=0;g<e;g++){h=parseInt(f[g],10)-parseInt(c[g],10);if(h!==0){return h}}return f.length-c.length}a.fn.lightbox=function(l){var w=a.extend({},a.fn.lightbox.defaults,l);if(a("#overlay").is(":visible")){a(window).trigger("resize")}function r(){f();q(this);return false}if(b(a.fn.jquery,"1.7")>0){return a(this).on("click",r)}else{return a(this).live("click",r)}function f(){a(window).bind("orientationchange",s);a(window).bind("resize",s);a("#overlay").remove();a("#lightbox").remove();w.isIE8=x();w.inprogress=false;w.auto=-1;var C=w.strings;var B='<div id="outerImageContainer"><div id="imageContainer"><iframe id="lightboxIframe" /><img id="lightboxImage"><div id="hoverNav"><a href="javascript://" title="'+C.prevLinkTitle+'" id="prevLink"></a><a href="javascript://" id="nextLink" title="'+C.nextLinkTitle+'"></a></div><div id="jqlb_loading"><a href="javascript://" id="loadingLink"><div id="jqlb_spinner"></div></a></div></div></div>';var E='<div id="imageDataContainer" class="clearfix"><div id="imageData"><div id="imageDetails"><span id="caption"></span><p id="controls"><span id="numberDisplay"></span> <span id="downloadLink"><a href="" target="'+w.linkTarget+'">'+C.download+'</a></span></p></div><div id="bottomNav">';if(w.displayHelp){E+='<span id="helpDisplay">'+C.help+"</span>"}E+='<a href="javascript://" id="bottomNavClose" title="'+C.closeTitle+'"><div id="jqlb_closelabel"></div></a></div></div></div>';var D;if(w.navbarOnTop){D='<div id="overlay"></div><div id="lightbox">'+E+B+"</div>";a("body").append(D);a("#imageDataContainer").addClass("ontop")}else{D='<div id="overlay"></div><div id="lightbox">'+B+E+"</div>";a("body").append(D)}a("#overlay").click(function(){k()}).hide();a("#lightbox").click(function(){k()}).hide();a("#loadingLink").click(function(){k();return false});a("#bottomNavClose").click(function(){k();return false});a("#outerImageContainer").width(w.widthCurrent).height(w.heightCurrent);a("#imageDataContainer").width(w.widthCurrent);if(!w.imageClickClose){a("#lightboxImage").click(function(){return false});a("#hoverNav").click(function(){return false})}}function s(B){if(w.resizeTimeout){clearTimeout(w.resizeTimeout);w.resizeTimeout=false}w.resizeTimeout=setTimeout(function(){A()},50)}function z(){var C=a(document).height();if(w.isIE8&&C>4096){C=4096}var B=a(window).height()-w.adminBarHeight;return new Array(a(document).width(),C,a(window).width(),B,a(document).height())}function x(){var C=false;if(document.createElement){var B=document.createElement("div");if(B&&B.querySelectorAll){B.innerHTML='<object><param name=""></object>';C=B.querySelectorAll("param").length!=1}B=null}return C}function h(){var C=0;var B=0;if(self.pageYOffset){B=self.pageYOffset;C=self.pageXOffset}else{if(document.documentElement&&document.documentElement.scrollTop){B=document.documentElement.scrollTop;C=document.documentElement.scrollLeft}else{if(document.body){B=document.body.scrollTop;C=document.body.scrollLeft}}}if(w.adminBarHeight&&parseInt(a("#wpadminbar").css("top"),10)===0){B+=w.adminBarHeight}return new Array(C,B)}function q(G){var F=z();var C=h();var D=0;a("#overlay").hide().css({width:F[0]+"px",height:F[1]+"px",opacity:w.overlayOpacity}).fadeIn(400);if(w.isIE8&&F[1]==4096){if(C[1]>=1000){D=C[1]-1000;if((F[4]-(C[1]+3096))<0){D-=(C[1]+3096)-F[4]}a("#overlay").css({top:D+"px"})}}var E=0;var B=[];w.downloads={};a("a").each(function(){if(!this.href||(this.rel!=G.rel)){return}var L="";var I="";var N="";var H=a(this);var K=H.children("img:first-child");if(this.title){L=this.title}else{if(K.attr("title")){L=K.attr("title")}else{if(K.attr("alt")){L=K.attr("alt")}}}if(H.parent().next(".gallery-caption").html()){var M=H.parent().next(".gallery-caption");I=M.html();N=M.text()}else{if(H.next(".wp-caption-text").html()){I=H.next(".wp-caption-text").html();N=H.next(".wp-caption-text").text()}}L=a.trim(L);N=a.trim(N).replace("&#8217;","&#039;").replace("’","'");if(L.toLowerCase()==N.toLowerCase()){L=I;I=""}var J="";if(L!=""){J='<span id="titleText">'+L+"</span>"}if(I!=""){if(L!=""){J+="<br />"}J+='<span id="captionText">'+I+"</span>"}if(w.displayDownloadLink||H.attr("data-download")){w.downloads[B.length]=H.attr("data-download")}B.push(new Array(this.href,w.displayTitle?J:"",B.length))});if(B.length>1){for(i=0;i<B.length;i++){for(j=B.length-1;j>i;j--){if(B[i][0]==B[j][0]){B.splice(j,1)}}}while(B[E][0]!=G.href){E++}}w.imageArray=B;n(C[1],C[0]).show();y(E);u()}function n(B,C){if(w.resizeSpeed>0){return a("#lightbox").animate({top:B+"px",left:C+"px"},250,"linear")}return a("#lightbox").css({top:B+"px",left:C+"px"})}function y(B){if(w.inprogress!=false){return}w.inprogress=true;w.activeImage=B;a("#jqlb_loading").show();a("#lightboxImage").hide();a("#hoverNav").hide();a("#prevLink").hide();a("#nextLink").hide();m()}function m(){w.imgPreloader=new Image();w.imgPreloader.onload=function(){a("#lightboxImage").attr("src",w.imageArray[w.activeImage][0]);A();g()};w.imgPreloader.src=w.imageArray[w.activeImage][0]}function A(){if(!w.imgPreloader){return}var E=w.imgPreloader.width;var B=w.imgPreloader.height;var G=z();var M=(G[2]<G[0])?G[0]:G[2];a("#overlay").css({width:M+"px",height:G[1]+"px"});var K=(G[3])-(a("#imageDataContainer").height()+(2*w.borderSize));var L=(G[2])-(2*w.borderSize);if(w.fitToScreen){var C=K-w.marginSize;var N=L-w.marginSize;if(a(window).width()>500){C-=w.marginSize;N-=w.marginSize}var H=1;if(B>C){H=C/B}E=E*H;B=B*H;H=1;if(E>N){H=N/E}E=Math.round(E*H);B=Math.round(B*H)}var F=h();var D=F[1]+(K*0.5);var I=D-B*0.5;var J=F[0];a("#lightboxImage").width(E).height(B);p(E,B,I,J)}function p(E,C,G,F){w.widthCurrent=a("#outerImageContainer").outerWidth();w.heightCurrent=a("#outerImageContainer").outerHeight();var B=Math.max(300,E+(w.borderSize*2));var D=(C+(w.borderSize*2));w.xScale=(B/w.widthCurrent)*100;w.yScale=(D/w.heightCurrent)*100;n(G,F);d();a("#imageDataContainer").animate({width:B},w.resizeSpeed,"linear");a("#outerImageContainer").animate({width:B,height:D},w.resizeSpeed,"linear",function(){e()});if(w.imageArray.length>1){a("#hoverNav").show();a("#prevLink").show();a("#nextLink").show()}a("#prevLink,#nextLink").height(C)}function e(){a("#imageData").show();a("#caption").show();a("#jqlb_loading").hide();if(w.resizeSpeed>0){a("#lightboxImage").fadeIn("fast",function(){o()})}else{a("#lightboxImage").show();o()}w.inprogress=false}function o(){if(w.auto!=-1){clearTimeout(w.auto);w.auto=setTimeout(function(){y((w.activeImage==(w.imageArray.length-1))?0:w.activeImage+1)},w.slidehowSpeed)}c()}function g(){if(w.imageArray.length>1){preloadNextImage=new Image();preloadNextImage.src=w.imageArray[(w.activeImage==(w.imageArray.length-1))?0:w.activeImage+1][0];preloadPrevImage=new Image();preloadPrevImage.src=w.imageArray[(w.activeImage==0)?(w.imageArray.length-1):w.activeImage-1][0]}else{if((w.imageArray.length-1)>w.activeImage){preloadNextImage=new Image();preloadNextImage.src=w.imageArray[w.activeImage+1][0]}if(w.activeImage>0){preloadPrevImage=new Image();preloadPrevImage.src=w.imageArray[w.activeImage-1][0]}}}function d(){a("#numberDisplay").html("");a("#caption").html("").hide();var C=w.imageArray;var B=w.strings;var G=w.activeImage;var F=C[G][2];if(C[G][1]&&w.showInfo){a("#caption").html(C[G][1]).show()}var H=(C.length>1&&w.showInfo)?B.image+(G+1)+B.of+C.length:"";if(w.slidehowSpeed&&C.length>1){var D=(w.auto===-1)?B.play:B.pause;H+=' <a id="playpause" href="#">'+D+"</a>"}if(w.displayDownloadLink||w.downloads[F]){var E=w.downloads[F]?w.downloads[F]:C[G][0];a("#downloadLink").show().children().attr("href",E)}else{a("#downloadLink").hide()}if(H!=""){a("#numberDisplay").html(H).show()}}function u(){if(w.imageArray.length>1){a("#prevLink").click(function(){y((w.activeImage==0)?(w.imageArray.length-1):w.activeImage-1);return false});a("#nextLink").click(function(){y((w.activeImage==(w.imageArray.length-1))?0:w.activeImage+1);return false});if(a.fn.touchwipe){a("#imageContainer").touchwipe({wipeLeft:function(){y((w.activeImage==(w.imageArray.length-1))?0:w.activeImage+1)},wipeRight:function(){y((w.activeImage==0)?(w.imageArray.length-1):w.activeImage-1)},min_move_x:20,preventDefaultEvents:true})}if(w.slidehowSpeed){a("#numberDisplay").unbind("click").click(function(){if(w.auto!=-1){a(this).children("a").text(w.strings.play);clearTimeout(w.auto);w.auto=-1}else{a(this).children("a").text(w.strings.pause);w.auto=setTimeout(function(){y((w.activeImage==(w.imageArray.length-1))?0:w.activeImage+1)},w.slidehowSpeed)}return false})}c()}}function k(){t();clearTimeout(w.auto);w.auto=-1;a("#lightbox").hide();a("#overlay").fadeOut()}function v(E){var F=E.data.opts;var B=E.keyCode;var C=27;var D=String.fromCharCode(B).toLowerCase();if((D=="x")||(D=="o")||(D=="c")||(B==C)){k()}else{if((D=="p")||(B==37)){t();y((F.activeImage==0)?(F.imageArray.length-1):F.activeImage-1)}else{if((D=="n")||(B==39)){t();y((F.activeImage==(F.imageArray.length-1))?0:F.activeImage+1)}}}return false}function c(){a(document).unbind("keydown").bind("keydown",{opts:w},v)}function t(){a(document).unbind("keydown")}};a.fn.lightbox.defaults={showInfo:false,adminBarHeight:0,overlayOpacity:0.8,borderSize:10,imageArray:new Array,activeImage:null,inprogress:false,widthCurrent:250,heightCurrent:250,xScale:1,yScale:1,displayTitle:true,imageClickClose:true,followScroll:false,isIE8:false};a(document).ready(doLightBox)})(jQuery);function doLightBox(){var a=(typeof JQLBSettings=="object");var d,b,c=0;if(a&&JQLBSettings.slideshowSpeed){d=parseInt(JQLBSettings.slideshowSpeed)}if(a&&JQLBSettings.resizeSpeed){b=parseInt(JQLBSettings.resizeSpeed)}if(a&&JQLBSettings.marginSize){c=parseInt(JQLBSettings.marginSize)}var e={help:" Browse images with your keyboard: Arrows or P(revious)/N(ext) and X/C/ESC for close.",prevLinkTitle:"previous image",nextLinkTitle:"next image",closeTitle:"close image gallery",image:"Image ",of:" of ",download:"Download",pause:"(pause slideshow)",play:"(play slideshow)"};jQuery('a[rel^="lightbox"]').lightbox({adminBarHeight:jQuery("#wpadminbar").height()||0,linkTarget:(a&&JQLBSettings.linkTarget.length)?JQLBSettings.linkTarget:"_self",showInfo:(a&&JQLBSettings.showInfo=="0")?false:true,displayHelp:(a&&JQLBSettings.help.length)?true:false,marginSize:(a&&c)?c:0,fitToScreen:(a&&JQLBSettings.fitToScreen=="1")?true:false,resizeSpeed:(a&&b>=0)?b:400,slidehowSpeed:(a&&d>=0)?d:4000,displayDownloadLink:(a&&JQLBSettings.displayDownloadLink=="0")?false:true,navbarOnTop:(a&&JQLBSettings.navbarOnTop=="0")?false:true,strings:(a&&typeof JQLBSettings.help=="string")?JQLBSettings:e})};