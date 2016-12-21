(function(a){a.EasingSliderLite=function(b){var c=this,d;c.el=b;c.$el=a(c.el);c.$viewport=c.$el.find(".easingsliderlite-viewport");c.$container=c.$viewport.find(".easingsliderlite-slides-container");c.$slides=c.$container.find(".easingsliderlite-slide");c.$images=c.$slides.find(".easingsliderlite-image");c.options=d=a.extend({},a.EasingSliderLite.defaults,a.parseJSON(c.$el.attr("data-options")));c.current=0;c.previous=0;c.count=c.$slides.length;c.width=d.dimensions.width;c.height=d.dimensions.height;c.$el.data("easingsliderlite",c);c.initialize=function(){c.$container.css({display:""});c.useCSS3=(d.general.enableCSS3)?c._supportsCSS3():false;if(c.useCSS3){c.$el.addClass("use-css3")}if(d.dimensions.responsive){c._setupResponsive()}c.supportsTouch=("ontouchstart" in document.documentElement&&d.general.enableTouch)?true:false;c.clickEvent=(c.supportsTouch)?"touchstart.easingsliderlite":"click.easingsliderlite";if(d.navigation.arrows){c._setupArrows()}if(d.navigation.pagination){c._setupPagination()}c.$slides.eq(c.current).addClass("active");c.$el.bind("beforetransition",function(){c.$slides.removeClass("active").eq(c.current).addClass("active")});if(d.playback.enabled){c.$el.one("onload",c.startPlayback)}c._preload();c.$el.trigger("initialize",c)};c._supportsCSS3=function(){var f=document.createElement("div"),g=["perspectiveProperty","WebkitPerspective","MozPerspective","OPerspective","msPerspective"];for(var e in g){if(typeof f.style[g[e]]!=="undefined"){c.vendorPrefix=g[e].replace("Perspective","").toLowerCase();return true}}return false};c._setupResponsive=function(){c.$el.addClass("is-responsive");a(window).bind("resize.easingsliderlite",function(h,i){clearTimeout(c.resizeEnd);c.resizeEnd=setTimeout(function(){a(window).trigger("resizeend");delete c.resizeEnd},50);var g=c.$viewport.outerWidth(),e=c.$viewport.outerHeight();if(g===c.width&&!i){return}c.width=g;c.height=e;if(d.transitions.effect=="slide"){var f={};if(c.useCSS3){f["-"+c.vendorPrefix+"-transition-duration"]="0ms";f["-"+c.vendorPrefix+"-transform"]="translate3d(-"+(c.current*c.width)+"px, 0, 0)"}else{f.left="-"+(c.current*c.width)+"px"}c.$container.css(f);a(window).one("resizeend",function(){f["-"+c.vendorPrefix+"-transition-duration"]=d.transitions.duration+"ms";c.$container.css(f)})}c.$slides.css({width:g+"px",height:e+"px"})});a(window).trigger("resize.easingsliderlite",true)};c._setupArrows=function(){var e=a(".easingsliderlite-next"),f=a(".easingsliderlite-prev"),g=a().add(e).add(f);e.bind(c.clickEvent,function(h){c.nextSlide();return false});f.bind(c.clickEvent,function(h){c.prevSlide();return false});if(d.navigation.arrows_hover){g.addClass("has-hover")}else{c.$el.one("onload",function(){g.css({opacity:1})})}c.$el.trigger("setuparrows",c)};c._setupPagination=function(){var e=a(".easingsliderlite-pagination"),f=e.children("div");f.bind(c.clickEvent,function(g){c.goToSlide(a(this).index());return false});f.eq(c.current).addClass("active").removeClass("inactive");c.$el.bind("beforetransition",function(){f.removeClass("active").addClass("inactive").eq(c.current).addClass("active").removeClass("inactive")});if(d.navigation.pagination_hover){e.addClass("has-hover")}else{c.$el.one("onload",function(){e.css({opacity:1})})}c.$el.trigger("setuppagination",c)};c._preload=function(){var f=0;var e=function(){f++;if(f>=c.count){c.$el.find(".easingsliderlite-preload").animate({opacity:0},{duration:400,complete:function(){a(this).remove();c.$el.trigger("onload")}})}};c.$images.each(function(g,h){preloadImage=new Image();preloadImage.onload=e;preloadImage.onerror=e;preloadImage.src=h.src})};c._transition=function(){c._beforeTransition();clearTimeout(c.afterTransition);c.afterTransition=setTimeout(function(){c._afterTransition();delete c.afterTransition},d.transitions.duration);if(d.transitions.effect=="slide"){if(c.useCSS3){var e={};e["-"+c.vendorPrefix+"-transition-duration"]=d.transitions.duration;e["-"+c.vendorPrefix+"-transform"]="translate3d(-"+(c.width*c.current)+"px, 0, 0)";c.$container.css(e)}else{c.$container.animate({left:"-"+(c.width*c.current)+"px"},d.transitions.duration)}}else{if(d.transitions.effect=="fade"){if(c.current===c.previous){return}c.order=(c.order)?c.order+1:1;c.$el.unbind("aftertransition._transition").one("aftertransition._transition",function(){c.$slides.each(function(f){var g=(f===c.current)?{"z-index":""}:{opacity:0,display:"none","z-index":""};a(this).css(g)});delete c.order;delete c.animationClear});c.$slides.eq(c.current).css({opacity:"0",display:"block","z-index":c.order}).animate({opacity:"1"},d.transitions.duration)}else{c.$el.trigger("transition",c,d.transitions.effect)}}};c._beforeTransition=function(){if(d.playback.enabled){clearTimeout(c.playbackTimer)}c.$el.trigger("beforetransition",c)};c._afterTransition=function(){if(d.playback.enabled){c.startPlayback({silent:true})}c.$el.trigger("aftertransition",c)};c.startPlayback=function(e){e=a.extend({},{silent:false},e);if(!d.playback.enabled){d.playback.enabled=true}c.runtime=new Date();
c.pauseTime=d.playback.pause;c.playbackTimer=setTimeout(function(){c.nextSlide()},c.pauseTime);if(!e.silent){c.$el.trigger("startplayback",c)}};c.endPlayback=function(e){e=a.extend({},{silent:false},e);if(d.playback.enabled){d.playback.enabled=false}clearTimeout(c.playbackTimer);if(!e.silent){c.$el.trigger("endplayback",c)}};c.pausePlayback=function(e){e=a.extend({},{silent:false},e);clearTimeout(c.playbackTimer);c.runtime=Math.ceil(new Date()-c.runtime);if(!e.silent){c.$el.trigger("pauseplayback",c)}};c.resumePlayback=function(e){e=a.extend({},{silent:false},e);c.pauseTime=Math.ceil(c.pauseTime-c.runtime);c.runtime=new Date();c.playbackTimer=setTimeout(function(){c.nextSlide()},c.pauseTime);if(!e.silent){c.$el.trigger("resumeplayback",c)}};c.nextSlide=function(e){e=a.extend({},{silent:false},e);c.previous=c.current;c.current=(c.current==(c.count-1))?0:(c.current+1);c._transition(c.current,c.previous);if(!e.silent){c.$el.trigger("nextslide",c)}};c.prevSlide=function(e){e=a.extend({},{silent:false},e);c.previous=c.current;c.current=(c.current==0)?(c.count-1):(c.current-1);c._transition(c.current,c.previous);if(!e.silent){c.$el.trigger("prevslide",c)}};c.goToSlide=function(e,f){f=a.extend({},{silent:false},f);if(c.$slides.eq(e).length==0){return}c.previous=c.current;c.current=e;c._transition(c.current,c.previous,true);if(!f.silent){c.$el.trigger("gotoslide",c,e)}};c=a.extend({},c,a.EasingSliderLite.extensions);c.initialize()};a.EasingSliderLite.defaults={general:{enableCSS3:true},navigation:{arrows:true,arrows_hover:true,arrows_position:"inside",pagination:true,pagination_hover:true,pagination_position:"inside",pagination_location:"bottom-left"},dimensions:{width:500,height:200,responsive:true},transitions:{effect:"slide",duration:500},playback:{enabled:false,pause:1000}};a.EasingSliderLite.extensions={};a.fn.EasingSliderLite=function(){return this.each(function(){new a.EasingSliderLite(this)})};a(document).ready(function(){a(".easingsliderlite").EasingSliderLite()})})(jQuery);