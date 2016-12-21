// Copyright (C) 2012 Jay Salvat
// The above copyright notice and this permission notice shall be included in
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
(function(t){function e(i,s){var n={align:"center",valign:"center"};if(t.extend(n,s),i.height()==0)return console.log("pecouille"),i.load(function(){e(t(this),s)}),void 0;var o,a,r,l=t(window).width(),h=t(window).height(),c=i.width(),u=i.height(),d=h/l,p=u/c;d>p?(o=h/p,a=h):(o=l,a=l*p),r={width:o+"px",height:a+"px",top:"auto",bottom:"auto",left:"auto",right:"auto"},isNaN(parseInt(n.valign))?n.valign=="top"?r.top=0:n.valign=="bottom"?r.bottom=0:r.top=(h-a)/2:r.top=0-(a-h)/100*parseInt(n.valign)+"px",isNaN(parseInt(n.align))?n.align=="left"?r.left=0:n.align=="right"?r.right=0:r.left=(l-o)/2:r.left=0-(o-l)/100*parseInt(n.align)+"px",i.css(r)}function i(){l.prependTo("body").fadeIn()}function s(){l.fadeOut("fast",function(){t(this).remove()})}function n(){return t("body").css("backgroundImage")?t("body").css("backgroundImage").replace(/url\("?(.*?)"?\)/i,"$1"):void 0}var o,a=t("<img />").addClass("vegas-background"),r=t("<div />").addClass("vegas-overlay"),l=t("<div />").addClass("vegas-loading"),h=t(),c=null,u=[],d=0,p=5e3,f=function(){},g={init:function(o){var r={src:n(),align:"center",valign:"center",fade:0,loading:!0,load:function(){},complete:function(){}};t.extend(r,t.vegas.defaults.background,o),r.loading&&i();var l=a.clone();return l.css({position:"fixed",left:"0px",top:"0px"}).bind("load",function(){l!=h&&(t(window).bind("load resize.vegas",function(){e(l,r)}),h.is("img")?(h.stop(),l.hide().insertAfter(h).fadeIn(r.fade,function(){t(".vegas-background").not(this).remove(),t("body").trigger("vegascomplete",[this,d-1]),r.complete.apply(l,[d-1])})):l.hide().prependTo("body").fadeIn(r.fade,function(){t("body").trigger("vegascomplete",[this,d-1]),r.complete.apply(this,[d-1])}),h=l,e(h,r),r.loading&&s(),t("body").trigger("vegasload",[h.get(0),d-1]),r.load.apply(h.get(0),[d-1]),d&&(t("body").trigger("vegaswalk",[h.get(0),d-1]),r.walk.apply(h.get(0),[d-1])))}).attr("src",r.src),t.vegas},destroy:function(e){return e&&"background"!=e||(t(".vegas-background, .vegas-loading").remove(),t(window).unbind("resize.vegas"),h=t()),"overlay"==e&&t(".vegas-overlay").remove(),t.vegas},overlay:function(e){var i={src:null,opacity:null};return t.extend(i,t.vegas.defaults.overlay,e),r.remove(),r.css({margin:"0",padding:"0",position:"fixed",left:"0px",top:"0px",width:"100%",height:"100%"}),i.src&&r.css("backgroundImage","url("+i.src+")"),i.opacity&&r.css("opacity",i.opacity),r.prependTo("body"),t.vegas},slideshow:function(e,i){var s={step:d,delay:p,preload:!1,backgrounds:u,walk:f};if(t.extend(s,t.vegas.defaults.slideshow,e),s.backgrounds!=u&&(e.step||(s.step=0),e.walk||(s.walk=function(){}),s.preload&&t.vegas("preload",s.backgrounds)),u=s.backgrounds,p=s.delay,d=s.step,f=s.walk,clearInterval(o),!u.length)return t.vegas;var n=function(){0>d&&(d=u.length-1),(d>=u.length||!u[d-1])&&(d=0);var e=u[d++];e.walk=s.walk,typeof e.fade=="undefined"&&(e.fade=s.fade),e.fade>s.delay&&(e.fade=s.delay),t.vegas(e)};return n(),i||(c=!1,t("body").trigger("vegasstart",[h.get(0),d-1])),c||(o=setInterval(n,s.delay)),t.vegas},next:function(){var e=d;return d&&(t.vegas("slideshow",{step:d},!0),t("body").trigger("vegasnext",[h.get(0),d-1,e-1])),t.vegas},previous:function(){var e=d;return d&&(t.vegas("slideshow",{step:d-2},!0),t("body").trigger("vegasprevious",[h.get(0),d-1,e-1])),t.vegas},jump:function(e){var i=d;return d&&(t.vegas("slideshow",{step:e},!0),t("body").trigger("vegasjump",[h.get(0),d-1,i-1])),t.vegas},stop:function(){var e=d;return d=0,c=null,clearInterval(o),t("body").trigger("vegasstop",[h.get(0),e-1]),t.vegas},pause:function(){return c=!0,clearInterval(o),t("body").trigger("vegaspause",[h.get(0),d-1]),t.vegas},get:function(t){return null==t||"background"==t?h.get(0):"overlay"==t?r.get(0):"step"==t?d-1:"paused"==t?c:void 0},preload:function(e){var i=[];for(var s in e)if(e[s].src){var n=document.createElement("img");n.src=e[s].src,i.push(n)}return t.vegas}};t.vegas=function(e){return g[e]?g[e].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof e&&e?(t.error("Method "+e+" does not exist"),void 0):g.init.apply(this,arguments)},t.vegas.defaults={background:{},slideshow:{},overlay:{}}})(jQuery);