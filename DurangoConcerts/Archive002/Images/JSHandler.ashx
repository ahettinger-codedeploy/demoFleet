(function(J){var c=0.75;var H=600;var ab=300;var f=4000;var L=250;var o=40;var D="update_text";var R="start_timer";var ak="ie6_init";var p="ie6_cleanup";var ae="lightbox_open";var ai="lightbox_close";var V="<div id='ImageScrollerLightBox9181'><div id='overlay'/>					<div id='lightbox'>						<div class='preloader'/>						<div class='inner-box'>							<div class='content'/>							<div class='timer'/>							<div class='desc'><div class='inner-text'/></div>							<div class='btn-panel'><div id='back-btn'/></div>							<div class='btn-panel'><div id='fwd-btn'/></div>						</div>						<div class='cpanel'>							<div id='play-btn'/>							<div id='info'/>							<div id='close-btn'/>						</div>					</div>					</div>";var M={rotate:true,delay:f,easing:"",transition_speed:H,display_dbuttons:true,display_number:true,display_timer:true,display_caption:true,caption_align:"bottom",cont_nav:true,auto_fit:true};var S;var G;var g;var ad;var t;var U;var A;var I;var Q;var s;var X;var w;var j;var T;var aa;var e;var af;var v;var h;var aj;var ag;var b;J(document).ready(function(){E()});J.fn.wtLightBox=function(am){var an=J(this);var al=J.extend(true,{},M,am);an.data({rotate:al.rotate,delay:q(al.delay,f),duration:q(al.transition_speed,H),"display-timer":al.display_timer,"display-dbuttons":al.display_dbuttons,"display-num":al.display_number,"cont-nav":al.cont_nav,"display-text":al.display_caption,"text-align":al.caption_align.toLowerCase(),"auto-fit":al.auto_fit,easing:al.easing}).each(function(ar){var aq;var ap;var ao=J(this).attr("rel");if(ao&&ao!=""){aq=an.filter("[rel="+ao+"]");ap=aq.index(J(this))}else{aq=J(this);ap=0}J(this).bind("click",{index:ap,group:aq,obj:an},r)});return this};var E=function(){b=null;J("body").append(V);S=J("#overlay").click(N);G=J("#lightbox");ad=G.find("div.preloader");I=G.find("div.inner-box");j=I.find("div.timer").data("pct",1);g=I.find("div.desc");s=I.find("#back-btn");w=I.find("#fwd-btn");Q=I.find("div.btn-panel").has(s);X=I.find("div.btn-panel").has(w);t=G.find("div.cpanel").bind("click",ac);U=t.find("#play-btn");A=t.find("#info");ag=G.outerWidth()-G.width();l()};var r=function(aq){aj=false;aa=J(aq.data.obj);e=J(aq.data.group);af=aq.data.index;v=e.size();h=aa.data("cont-nav");var am=aa.data("text-align");var ap=aa.data("display-text");var al;var ao;var ar;var an;if(v>1){al=aa.data("rotate");ao=aa.data("display-timer");an=aa.data("display-dbuttons");ar=aa.data("display-num")}else{al=ao=an=ar=false}if(al){G.bind(R,y);U.toggleClass("pause",aj).show()}else{G.unbind(R);U.hide()}if(ao){j.css(am=="top"?"bottom":"top",0).css("visibility","visible")}else{j.css({visibility:"hidden"})}if(an){Q.css("visibility","visible");X.css("visibility","visible")}else{Q.css("visibility","hidden");X.css("visibility","hidden")}if(ar){A.css("visibility","visible")}else{A.css("visibility","hidden")}if(ap){G.unbind(D).bind(D,P);g.show()}else{G.unbind(D);g.hide()}G.data("visible",true).trigger(ak);J(document).unbind("keyup",K).bind("keyup",K);S.stop(true,true).css("opacity",c).show();G.css({width:L,height:L,"margin-left":-L/2,"margin-top":-L/2}).show();F(af);J(document).trigger(ae);return false};var N=function(){k();G.data("visible",false).trigger(p);J(document).unbind("keyup",K).unbind("keyup",a);i();g.stop(true).hide();G.stop(true).hide();S.stop(true).fadeOut("fast");J(document).trigger(ai);return false};var F=function(am){T=J(e.get(am));i();g.stop(true).hide();var al=J("<img/>");J("div.content",I).empty().append(al);al.css("opacity",0).attr("src",T.attr("href"));if(al[0].complete||al[0].readyState=="complete"){ad.hide();Z(al)}else{ad.show();al.load(function(){ad.hide();Z(al)})}};var Z=function(am){if(G.data("visible")){if(aa.data("auto-fit")){ah(am[0])}var an=am[0].width;var ar=am[0].height;var aq=ar+t.height();var al=x(an,aq);var ap=-(an+ag)/2;var ao=-(aq+(ag/2))/2;G.stop(true).animate({"margin-left":ap,"margin-top":ao,width:an,height:aq},al,aa.data("easing"),function(){I.height(ar);A.html((af+1)+" / "+v);G.trigger(D);C();am.animate({opacity:1},"normal",function(){if(jQuery.browser.msie){this.style.removeAttribute("filter")}G.trigger(R)})})}};var P=function(){var am=T.attr("title");if(!am||am==""){am=T.data("text")}if(am&&am!=""){g.find("div.inner-text").html(am);var al=aa.data("text-align");g.stop().css("top",al=="bottom"?I.height():-g.height()).show().animate({top:al=="bottom"?I.height()-g.height():0},"normal")}};var ah=function(al){var am;var ao=J(window).width()-ag-o;var an=J(window).height()-ag/2-t.height()-o;if(al.width>ao){am=al.height/al.width;al.width=ao;al.height=am*ao}if(al.height>an){am=al.width/al.height;al.width=am*an;al.height=an}};var C=function(){J(document).unbind("keyup",a).bind("keyup",a);t.show();var am=Math.round(I.width()/2);Q.css({width:am,height:"100%"}).unbind().hover(W,O);if(!h&&af==0){Q.css("cursor","default")}else{Q.bind("click",Y).css("cursor","pointer");s.show()}var al=I.width()-Q.width();X.css({width:al,height:"100%"}).unbind().hover(u,m);if(!h&&af==v-1){X.css("cursor","default")}else{X.bind("click",d).css("cursor","pointer");w.show()}};var i=function(){J(document).unbind("keyup",a);t.hide();s.hide();w.hide()};var ac=function(al){switch(J(al.target).attr("id")){case"play-btn":n();break;case"close-btn":N();break}};var n=function(){aj=!aj;U.toggleClass("pause",aj);aj?G.trigger(R):B();return false};var Y=function(){if(Q.css("visibility")=="visible"){k();if(af>0){af--}else{if(h){af=v-1}else{return}}F(af)}return false};var d=function(){if(X.css("visibility")=="visible"){k();if(af<v-1){af++}else{if(h){af=0}else{return}}F(af)}return false};var z=function(){k();af=(af<v-1)?af+1:0;F(af)};var W=function(){s.stop().animate({"margin-left":0},ab)};var O=function(){s.stop().animate({"margin-left":-s.width()},ab)};var u=function(){w.stop().animate({"margin-left":-w.width()},ab)};var m=function(){w.stop().animate({"margin-left":0},ab)};var a=function(al){switch(al.keyCode){case 37:case 80:Y();break;case 39:case 78:d();break;case 32:n();break}};var K=function(al){switch(al.keyCode){case 27:case 67:case 88:N()}};var x=function(ao,al){var an=Math.abs(G.width()-ao);var am=Math.abs(G.height()-al);return Math.max(aa.data("duration"),an,am)};var l=function(){if(jQuery.browser.msie){if(parseInt(jQuery.browser.version)<=6){var am,al;S.css({position:"absolute",width:J(document).width(),height:J(document).height()});G.css("position","absolute");J(window).bind("resize",function(){if(al!=document.documentElement.clientHeight||am!=document.documentElement.clientWidth){S.css({width:J(document).width(),height:J(document).height()})}am=document.documentElement.clientWidth;al=document.documentElement.clientHeight});G.bind(ak,function(){J("body").find("select").addClass("hide-selects")}).bind(p,function(){J("body").find("select").removeClass("hide-selects")})}}};var y=function(){if(aj&&b==null){var al=Math.round(j.data("pct")*aa.data("delay"));j.animate({width:I.width()+1},al,"linear");b=setTimeout(z,al)}};var k=function(){clearTimeout(b);b=null;j.stop(true).width(0).data("pct",1)};var B=function(){clearTimeout(b);b=null;var al=1-(j.width()/(I.width()+1));j.stop(true).data("pct",al)};var q=function(al,am){if(!isNaN(al)&&al>0){return al}return am}})(jQuery);