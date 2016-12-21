/*
 * 	Easy Slider 1.7 - jQuery plugin
 *	written by Alen Grakalic	
 *	http://cssglobe.com/post/4004/easy-slider-15-the-easiest-jquery-plugin-for-sliding
 *
 *	Copyright (c) 2009 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
 
/*
 *	markup example for $("#slider").easySlider();
 *	
 * 	<div id="slider">
 *		<ul>
 *			<li><img src="images/01.jpg" alt="" /></li>
 *			<li><img src="images/02.jpg" alt="" /></li>
 *			<li><img src="images/03.jpg" alt="" /></li>
 *			<li><img src="images/04.jpg" alt="" /></li>
 *			<li><img src="images/05.jpg" alt="" /></li>
 *		</ul>
 *	</div>
 *
 */

(function($) {

	$.fn.easySlider = function(options){
	  
		// default configuration properties
		var defaults = {			
			prevId: 		'prevBtn',
			prevText: 		'Previous',
			nextId: 		'nextBtn',	
			nextText: 		'Next',
			controlsShow:	true,
			controlsBefore:	'',
			controlsAfter:	'',	
			controlsFade:	true,
			firstId: 		'firstBtn',
			firstText: 		'First',
			firstShow:		false,
			lastId: 		'lastBtn',	
			lastText: 		'Last',
			lastShow:		false,				
			vertical:		false,
			speed: 			800,
			auto:			false,
			pause:			2000,
			continuous:		false, 
			numeric: 		false,
			numericId: 		'controls'
		}; 
		
		var options = $.extend(defaults, options);  
				
		this.each(function() {  
			var obj = $(this); 				
			var s = $("li", obj).length;
			var w = $("li", obj).width(); 
			var h = $("li", obj).height(); 
			var clickable = true;
			obj.width(w); 
			obj.height(h); 
			obj.css("overflow","hidden");
			var ts = s-1;
			var t = 0;
			$("ul", obj).css('width',s*w);			
			
			if(options.continuous){
				$("ul", obj).prepend($("ul li:last-child", obj).clone().css("margin-left","-"+ w +"px"));
				$("ul", obj).append($("ul li:nth-child(2)", obj).clone());
				$("ul", obj).css('width',(s+1)*w);
			};				
			
			if(!options.vertical) $("li", obj).css('float','left');
								
			if(options.controlsShow){
				var html = options.controlsBefore;				
				if(options.numeric){
					html += '<ol id="'+ options.numericId +'"></ol>';
				} else {
					if(options.firstShow) html += '<span id="'+ options.firstId +'"><a href=\"javascript:void(0);\">'+ options.firstText +'</a></span>';
					html += ' <span id="'+ options.prevId +'"><a href=\"javascript:void(0);\">'+ options.prevText +'</a></span>';
					html += ' <span id="'+ options.nextId +'"><a href=\"javascript:void(0);\">'+ options.nextText +'</a></span>';
					if(options.lastShow) html += ' <span id="'+ options.lastId +'"><a href=\"javascript:void(0);\">'+ options.lastText +'</a></span>';				
				};
				
				html += options.controlsAfter;						
				$(obj).after(html);										
			};
			
			if(options.numeric){									
				for(var i=0;i<s;i++){						
					$(document.createElement("li"))
						.attr('id',options.numericId + (i+1))
						.html('<a rel='+ i +' href=\"javascript:void(0);\">'+ (i+1) +'</a>')
						.appendTo($("#"+ options.numericId))
						.click(function(){							
							animate($("a",$(this)).attr('rel'),true);
						}); 												
				};							
			} else {
				$("a","#"+options.nextId).click(function(){		
					animate("next",true);
				});
				$("a","#"+options.prevId).click(function(){		
					animate("prev",true);				
				});	
				$("a","#"+options.firstId).click(function(){		
					animate("first",true);
				});				
				$("a","#"+options.lastId).click(function(){		
					animate("last",true);				
				});				
			};
			
			function setCurrent(i){
				i = parseInt(i)+1;
				$("li", "#" + options.numericId).removeClass("current");
				$("li#" + options.numericId + i).addClass("current");
			};
			
			function adjust(){
				if(t>ts) t=0;		
				if(t<0) t=ts;	
				if(!options.vertical) {
					$("ul",obj).css("margin-left",(t*w*-1));
				} else {
					$("ul",obj).css("margin-left",(t*h*-1));
				}
				clickable = true;
				if(options.numeric) setCurrent(t);
			};
			
			function animate(dir,clicked){
				if (clickable){
					clickable = false;
					var ot = t;				
					switch(dir){
						case "next":
							t = (ot>=ts) ? (options.continuous ? t+1 : ts) : t+1;						
							break; 
						case "prev":
							t = (t<=0) ? (options.continuous ? t-1 : 0) : t-1;
							break; 
						case "first":
							t = 0;
							break; 
						case "last":
							t = ts;
							break; 
						default:
							t = dir;
							break; 
					};	
					var diff = Math.abs(ot-t);
					var speed = diff*options.speed;						
					if(!options.vertical) {
						p = (t*w*-1);
						$("ul",obj).animate(
							{ marginLeft: p }, 
							{ queue:false, duration:speed, complete:adjust }
						);				
					} else {
						p = (t*h*-1);
						$("ul",obj).animate(
							{ marginTop: p }, 
							{ queue:false, duration:speed, complete:adjust }
						);					
					};
					
					if(!options.continuous && options.controlsFade){					
						if(t==ts){
							$("a","#"+options.nextId).hide();
							$("a","#"+options.lastId).hide();
						} else {
							$("a","#"+options.nextId).show();
							$("a","#"+options.lastId).show();					
						};
						if(t==0){
							$("a","#"+options.prevId).hide();
							$("a","#"+options.firstId).hide();
						} else {
							$("a","#"+options.prevId).show();
							$("a","#"+options.firstId).show();
						};					
					};				
					
					if(clicked) clearTimeout(timeout);
					if(options.auto && dir=="next" && !clicked){;
						timeout = setTimeout(function(){
							animate("next",false);
						},diff*options.speed+options.pause);
					};
			
				};
				
			};
			// init
			var timeout;
			if(options.auto){;
				timeout = setTimeout(function(){
					animate("next",false);
				},options.pause);
			};		
			
			if(options.numeric) setCurrent(0);
		
			if(!options.continuous && options.controlsFade){					
				$("a","#"+options.prevId).hide();
				$("a","#"+options.firstId).hide();				
			};				
			
		});
	  
	};

})(jQuery);

/*
 * @ description: Plugin to display 960.gs gridlines See http://960.gs/
 * @author: badlyDrawnToy sharp / http://www.badlydrawntoy.com
 * @license: Creative Commons License - ShareAlike http://creativecommons.org/licenses/by-sa/3.0/
 * @version: 1.0 20th April 2009
*/
(function($){$.fn.addGrid=function(cols,options){var defaults={default_cols:12,z_index:999,img_path:'/images/',opacity:.6};var opts=$.extend(defaults,options);var cols=cols!=null&&(cols===12||cols===16)?cols:12;var cols=cols===opts.default_cols?'12_col':'16_col';return this.each(function(){var $el=$(this);var height=$el.height();var wrapper=$('<div id="'+opts.grid_id+'"/>').appendTo($el).css({'display':'none','position':'absolute','top':0,'z-index':(opts.z_index-1),'height':height,'opacity':opts.opacity,'width':'100%'});$('<div/>').addClass('container_12').css({'margin':'0 auto','width':'960px','height':height,'background-image':'url('+opts.img_path+cols+'.png)','background-repeat':'repeat-y'}).appendTo(wrapper);$('<div>grid on</div>').appendTo($el).css({'position':'absolute','top':28,'left':0,'z-index':opts.z_index,'background':'#222','color':'#fff','padding':'3px 6px','width':'40px','text-align':'center'}).hover(function(){$(this).css("cursor","pointer");},function(){$(this).css("cursor","default");}).toggle(function(){$(this).text("grid off");$('#'+opts.grid_id).slideDown();},function(){$(this).text("grid on");$('#'+opts.grid_id).slideUp();});});};})(jQuery);

/*!
 * jQuery Cycle Lite Plugin
 * http://malsup.com/jquery/cycle/lite/
 * Copyright (c) 2008 M. Alsup
 * Version: 1.0 (06/08/2008)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * Requires: jQuery v1.2.3 or later
 */
(function(D){var A="Lite-1.0";D.fn.cycle=function(E){return this.each(function(){E=E||{};if(this.cycleTimeout){clearTimeout(this.cycleTimeout)}this.cycleTimeout=0;this.cyclePause=0;var I=D(this);var J=E.slideExpr?D(E.slideExpr,this):I.children();var G=J.get();if(G.length<2){if(window.console&&window.console.log){window.console.log("terminating; too few slides: "+G.length)}return }var H=D.extend({},D.fn.cycle.defaults,E||{},D.metadata?I.metadata():D.meta?I.data():{});H.before=H.before?[H.before]:[];H.after=H.after?[H.after]:[];H.after.unshift(function(){H.busy=0});var F=this.className;H.width=parseInt((F.match(/w:(\d+)/)||[])[1])||H.width;H.height=parseInt((F.match(/h:(\d+)/)||[])[1])||H.height;H.timeout=parseInt((F.match(/t:(\d+)/)||[])[1])||H.timeout;if(I.css("position")=="static"){I.css("position","relative")}if(H.width){I.width(H.width)}if(H.height&&H.height!="auto"){I.height(H.height)}var K=0;J.css({position:"absolute",top:0,left:0}).hide().each(function(M){D(this).css("z-index",G.length-M)});D(G[K]).css("opacity",1).show();if(D.browser.msie){G[K].style.removeAttribute("filter")}if(H.fit&&H.width){J.width(H.width)}if(H.fit&&H.height&&H.height!="auto"){J.height(H.height)}if(H.pause){I.hover(function(){this.cyclePause=1},function(){this.cyclePause=0})}D.fn.cycle.transitions.fade(I,J,H);J.each(function(){var M=D(this);this.cycleH=(H.fit&&H.height)?H.height:M.height();this.cycleW=(H.fit&&H.width)?H.width:M.width()});J.not(":eq("+K+")").css({opacity:0});if(H.cssFirst){D(J[K]).css(H.cssFirst)}if(H.timeout){if(H.speed.constructor==String){H.speed={slow:600,fast:200}[H.speed]||400}if(!H.sync){H.speed=H.speed/2}while((H.timeout-H.speed)<250){H.timeout+=H.speed}}H.speedIn=H.speed;H.speedOut=H.speed;H.slideCount=G.length;H.currSlide=K;H.nextSlide=1;var L=J[K];if(H.before.length){H.before[0].apply(L,[L,L,H,true])}if(H.after.length>1){H.after[1].apply(L,[L,L,H,true])}if(H.click&&!H.next){H.next=H.click}if(H.next){D(H.next).bind("click",function(){return C(G,H,H.rev?-1:1)})}if(H.prev){D(H.prev).bind("click",function(){return C(G,H,H.rev?1:-1)})}if(H.timeout){this.cycleTimeout=setTimeout(function(){B(G,H,0,!H.rev)},H.timeout+(H.delay||0))}})};function B(J,E,I,K){if(E.busy){return }var H=J[0].parentNode,M=J[E.currSlide],L=J[E.nextSlide];if(H.cycleTimeout===0&&!I){return }if(I||!H.cyclePause){if(E.before.length){D.each(E.before,function(N,O){O.apply(L,[M,L,E,K])})}var F=function(){if(D.browser.msie){this.style.removeAttribute("filter")}D.each(E.after,function(N,O){O.apply(L,[M,L,E,K])})};if(E.nextSlide!=E.currSlide){E.busy=1;D.fn.cycle.custom(M,L,E,F)}var G=(E.nextSlide+1)==J.length;E.nextSlide=G?0:E.nextSlide+1;E.currSlide=G?J.length-1:E.nextSlide-1}if(E.timeout){H.cycleTimeout=setTimeout(function(){B(J,E,0,!E.rev)},E.timeout)}}function C(E,F,I){var H=E[0].parentNode,G=H.cycleTimeout;if(G){clearTimeout(G);H.cycleTimeout=0}F.nextSlide=F.currSlide+I;if(F.nextSlide<0){F.nextSlide=E.length-1}else{if(F.nextSlide>=E.length){F.nextSlide=0}}B(E,F,1,I>=0);return false}D.fn.cycle.custom=function(K,H,I,E){var J=D(K),G=D(H);G.css({opacity:0});var F=function(){G.animate({opacity:1},I.speedIn,I.easeIn,E)};J.animate({opacity:0},I.speedOut,I.easeOut,function(){J.css({display:"none"});if(!I.sync){F()}});if(I.sync){F()}};D.fn.cycle.transitions={fade:function(F,G,E){G.not(":eq(0)").css("opacity",0);E.before.push(function(){D(this).show()})}};D.fn.cycle.ver=function(){return A};D.fn.cycle.defaults={timeout:4000,speed:1000,next:null,prev:null,before:null,after:null,height:"auto",sync:1,fit:0,pause:0,delay:0,slideExpr:null}})(jQuery)

jQuery(document).ready(function($) { 
  
  //swap form values when active
  swapValues = [];
  $(".swap_value").each(function(i){
      swapValues[i] = $(this).val();
      $(this).focus(function(){
          if ($(this).val() == swapValues[i]) {
              $(this).val("");
          }
      }).blur(function(){
          if ($.trim($(this).val()) === "") {
              $(this).val(swapValues[i]);
          }
      });
  });
  
  // enable gridder
  var domain = 'http://' + window.location.hostname + '/';
	var gridderOptions= {
    img_path: domain+'wp-content/themes/ashford/images/',
		z_index: 999,
		opacity:.6
	};
	$("body.loggedin").addGrid(16, gridderOptions);
    
  // validation for squeeze heros
  if ($('body.hero_squeeze')) {
    //$('.hero_type_squeeze strict input','body.hero_squeeze').val('');
    var destination = $('.hero_type_squeeze a','body.hero_squeeze').attr('href');
    $('.hero_type_squeeze a','body.hero_squeeze').removeAttr('href');
    $('.hero_type_squeeze a.strict','body.hero_squeeze').click(function() {
      var email = $('.hero_type_squeeze input','body.hero_squeeze').val();
      var filter = /^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/;
      if (!filter.test(email)) { 
        $('.hero_type_squeeze input','body.hero_squeeze').css('border','red 1px solid');
        return false;
      } else {
        url = window.location;
        window.location = url+'?email='+email+'&redirect='+destination;
        $('.hero_type_squeeze input','body.hero_squeeze').attr('disabled','disabled');
        $('.hero_type_squeeze a','body.hero_squeeze').hide();
        $('.hero_type_squeeze #hero_button_loading','body.hero_squeeze').show();
      }
    });
    $('.hero_type_squeeze a.not_strict','body.hero_squeeze').click(function() {
      var email = $('.hero_type_squeeze input','body.hero_squeeze').val();
      var filter = /^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/;
      if (!filter.test(email)) { 
        url = window.location;
        window.location = destination;
        $('.hero_type_squeeze input','body.hero_squeeze').attr('disabled','disabled');
        $('.hero_type_squeeze a','body.hero_squeeze').hide();
        $('.hero_type_squeeze #hero_button_loading','body.hero_squeeze').show();
      } else {
        url = window.location;
        window.location = url+'?email='+email+'&redirect='+destination;
        $('.hero_type_squeeze input','body.hero_squeeze').attr('disabled','disabled');
        $('.hero_type_squeeze a','body.hero_squeeze').hide();
        $('.hero_type_squeeze #hero_button_loading','body.hero_squeeze').show();
      }
    });
  }
  
  // add hover class for mega menus
  $('.mega_tab_item','#navigation').hover(
    function () {
      $(this).addClass("hover");
    },
    function () {
      $(this).removeClass("hover");
    }
  );
  $('.mega_tab_box','#navigation').hover(
    function () {
      $(this).parent().addClass("hover box_hover");
    },
    function () {
      $(this).parent().removeClass("hover box_hover");
    }
  );

  // enable tabs
  $(".tab_content").hide(); //Hide all content
  $("ul.tabs li:first").addClass("active").show(); //Activate first tab
  $(".tab_content:first").show(); //Show first tab content
  $("ul.tabs li").click(function() {

    $("ul.tabs li").removeClass("active"); //Remove any "active" class
    $(this).addClass("active"); //Add "active" class to selected tab
    $(".tab_content").hide(); //Hide all tab content

    var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
    $(activeTab).fadeIn(); //Fade in the active ID content
    return false;
  });
  
  $("body.hero_slider #slider").easySlider({
    auto: true, 
    //continuous: true,
    numeric: true
  });
  $("body.hero_slideshow #slider").easySlider({
    auto: true, 
    //continuous: true,
    prevText: 		'',
    nextText: 		''
  });
  $("body.hero_carousel #slider").easySlider({
    //auto: true, 
    //continuous: true,
    prevText: 		'',
    nextText: 		''
  });
  $("body.hero_rotator #rotator").cycle();
  
  // opens external links in menus in new window
  $('.menu-item-type-custom a').click(function(){
    window.open(this.href);
    return false;
  });
  
  // fix for ie psuedo class :last-child
  $('body.ie #bottom div.widget:last-child').css('margin-right','0');
  $('body.ie #top_row_inner div.widget:last-child').css('margin-right','0');
  $('body.ie #bottom_row_inner div.widget:last-child').css('margin-right','0');
  
  
  // Load Tweet Button Script
  var e = document.createElement('script');
  e.type="text/javascript"; e.async = true;
  e.src = 'http://platform.twitter.com/widgets.js';
  document.getElementsByTagName('head')[0].appendChild(e);
  // Load LinkedIn button
  var e = document.createElement('script');
  e.type="text/javascript"; e.async = true;
  e.src = 'http://platform.linkedin.com/in.js';
  document.getElementsByTagName('head')[0].appendChild(e);
  // Load Plus One Button
  var e = document.createElement('script');
  e.type="text/javascript"; e.async = true;
  e.src = 'https://apis.google.com/js/plusone.js';
  document.getElementsByTagName('head')[0].appendChild(e);

  
   // opens all links when content is being viewed in Facebook in a separate tab
  $('body.isFacebook a').click(function(){
    window.open(this.href);
    return false;
  });
  
});