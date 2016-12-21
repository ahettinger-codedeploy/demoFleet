(function($){Drupal.behaviors.viewsSlideshowSingleFrame=function(context){$('.views_slideshow_singleframe_main:not(.viewsSlideshowSingleFrame-processed)',context).addClass('viewsSlideshowSingleFrame-processed').each(function(){var fullId='#'+$(this).attr('id');if(!Drupal.settings.viewsSlideshowSingleFrame||!Drupal.settings.viewsSlideshowSingleFrame[fullId]){return;}
var settings=Drupal.settings.viewsSlideshowSingleFrame[fullId];settings.targetId='#'+$(fullId+" :first").attr('id');settings.paused=false;settings.opts={speed:settings.speed,timeout:parseInt(settings.timeout),delay:parseInt(settings.delay),sync:settings.sync==1,random:settings.random==1,pause:false,allowPagerClickBubble:(settings.pager_hover==1||settings.pager_click_to_page),prev:(settings.controls>0)?'#views_slideshow_singleframe_prev_'+settings.vss_id:null,next:(settings.controls>0)?'#views_slideshow_singleframe_next_'+settings.vss_id:null,pager:(settings.pager>0)?'#views_slideshow_singleframe_pager_'+settings.vss_id:null,nowrap:parseInt(settings.nowrap),pagerAnchorBuilder:function(idx,slide){var classes='pager-item pager-num-'+(idx+1);if(idx==0){classes+=' first';}
if($(slide).siblings().length==idx){classes+=' last';}
if(idx%2){classes+=' odd';}
else{classes+=' even';}
var theme='viewsSlideshowPager'+settings.pager_type;return Drupal.theme.prototype[theme]?Drupal.theme(theme,classes,idx,slide,settings):'';},after:function(curr,next,opts){if(settings.image_count){$('#views_slideshow_singleframe_image_count_'+settings.vss_id+' span.num').html(opts.currSlide+1);$('#views_slideshow_singleframe_image_count_'+settings.vss_id+' span.total').html(opts.slideCount);}},before:function(curr,next,opts){if(settings.remember_slide){createCookie(settings.vss_id,opts.currSlide+1,settings.remember_slide_days);}
if(settings.fixed_height==0){var $ht=$(this).height();$(this).parent().animate({height:$ht});}},cleartype:(settings.ie.cleartype=='true')?true:false,cleartypeNoBg:(settings.ie.cleartypenobg=='true')?true:false}
if(settings.remember_slide){var startSlide=readCookie(settings.vss_id);if(startSlide==null){startSlide=0;}
settings.opts.startingSlide=startSlide;}
if(settings.pager_hover==1){settings.opts.pagerEvent='mouseover';settings.opts.pauseOnPagerHover=true;}
if(settings.effect=='none'){settings.opts.speed=1;}
else{settings.opts.fx=settings.effect;}
if(settings.pause==1){$('#views_slideshow_singleframe_teaser_section_'+settings.vss_id).hover(function(){$(settings.targetId).cycle('pause');},function(){if(settings.paused==false){$(settings.targetId).cycle('resume');}});}
if(settings.pause_on_click==1){$('#views_slideshow_singleframe_teaser_section_'+settings.vss_id).click(function(){viewsSlideshowSingleFramePause(settings);});}
if(settings.advanced!="\n"){settings.advanced.toString();var advanced=settings.advanced.split("\n");for(i=0;i<advanced.length;i++){var prop='';var value='';var property=advanced[i].split(":");for(j=0;j<property.length;j++){if(j==0){prop=property[j];}
else if(j==1){value=property[j];}
else{value+=":"+property[j];}}
if(value=='true'||value=='false'||IsNumeric(value)){value=eval(value);}
else{var func=value.match(/function\s*\((.*?)\)\s*\{(.*)\}/i);if(func){value=new Function(func[1].match(/(\w+)/g),func[2]);}}
if(typeof(value)=="function"&&prop in settings.opts){var callboth=function(before_func,new_func){return function(){before_func.apply(null,arguments);new_func.apply(null,arguments);};};settings.opts[prop]=callboth(settings.opts[prop],value);}
else{settings.opts[prop]=value;}}}
$(settings.targetId).cycle(settings.opts);if(settings.start_paused){viewsSlideshowSingleFramePause(settings);}
if(settings.pause_when_hidden){var checkPause=function(settings){var visible=viewsSlideshowSingleFrameIsVisible(settings.targetId,settings.pause_when_hidden_type,settings.amount_allowed_visible);if(visible&&settings.paused){viewsSlideshowSingleFrameResume(settings);}
else if(!visible&&!settings.paused){viewsSlideshowSingleFramePause(settings);}}
$(window).scroll(function(){checkPause(settings);});$(window).resize(function(){checkPause(settings);});}
$('#views_slideshow_singleframe_image_count_'+settings.vss_id).show();if(settings.controls>0){$('#views_slideshow_singleframe_controls_'+settings.vss_id).show();$('#views_slideshow_singleframe_playpause_'+settings.vss_id).click(function(e){if(settings.paused){viewsSlideshowSingleFrameResume(settings);}
else{viewsSlideshowSingleFramePause(settings);}
e.preventDefault();});}});}
viewsSlideshowSingleFramePause=function(settings){var resume=Drupal.t('Resume');$(settings.targetId).cycle('pause');if(settings.controls>0){$('#views_slideshow_singleframe_playpause_'+settings.vss_id).addClass('views_slideshow_singleframe_play').addClass('views_slideshow_play').removeClass('views_slideshow_singleframe_pause').removeClass('views_slideshow_pause').text(resume);}
settings.paused=true;}
viewsSlideshowSingleFrameResume=function(settings){var pause=Drupal.t('Pause');$(settings.targetId).cycle('resume');if(settings.controls>0){$('#views_slideshow_singleframe_playpause_'+settings.vss_id).addClass('views_slideshow_singleframe_pause').addClass('views_slideshow_pause').removeClass('views_slideshow_singleframe_play').removeClass('views_slideshow_play').text(pause);}
settings.paused=false;}
Drupal.theme.prototype.viewsSlideshowPagerThumbnails=function(classes,idx,slide,settings){var href='#';if(settings.pager_click_to_page){href=$(slide).find('a').attr('href');}
var img=$(slide).find('img');return'<div class="'+classes+'"><a href="'+href+'"><img src="'+$(img).attr('src')+'" alt="'+$(img).attr('alt')+'" title="'+$(img).attr('title')+'"/></a></div>';}
Drupal.theme.prototype.viewsSlideshowPagerNumbered=function(classes,idx,slide,settings){var href='#';if(settings.pager_click_to_page){href=$(slide).find('a').attr('href');}
return'<div class="'+classes+'"><a href="'+href+'">'+(idx+1)+'</a></div>';}
function IsNumeric(sText){var ValidChars="0123456789";var IsNumber=true;var Char;for(var i=0;i<sText.length&&IsNumber==true;i++){Char=sText.charAt(i);if(ValidChars.indexOf(Char)==-1){IsNumber=false;}}
return IsNumber;}
function createCookie(name,value,days){if(days){var date=new Date();date.setTime(date.getTime()+(days*24*60*60*1000));var expires="; expires="+date.toGMTString();}
else{var expires="";}
document.cookie=name+"="+value+expires+"; path=/";}
function readCookie(name){var nameEQ=name+"=";var ca=document.cookie.split(';');for(var i=0;i<ca.length;i++){var c=ca[i];while(c.charAt(0)==' ')c=c.substring(1,c.length);if(c.indexOf(nameEQ)==0){return c.substring(nameEQ.length,c.length);}}
return null;}
function eraseCookie(name){createCookie(name,"",-1);}
function viewsSlideshowSingleFrameIsVisible(elem,type,amountVisible){var docViewTop=$(window).scrollTop();var docViewBottom=docViewTop+$(window).height();var docViewLeft=$(window).scrollLeft();var docViewRight=docViewLeft+$(window).width();var elemTop=$(elem).offset().top;var elemHeight=$(elem).height();var elemBottom=elemTop+elemHeight;var elemLeft=$(elem).offset().left;var elemWidth=$(elem).width();var elemRight=elemLeft+elemWidth;var elemArea=elemHeight*elemWidth;var missingLeft=0;var missingRight=0;var missingTop=0;var missingBottom=0;if(elemLeft<docViewLeft){missingLeft=docViewLeft-elemLeft;}
if(elemRight>docViewRight){missingRight=elemRight-docViewRight;}
if(elemTop<docViewTop){missingTop=docViewTop-elemTop;}
if(elemBottom>docViewBottom){missingBottom=elemBottom-docViewBottom;}
if(type=='full'){return((elemBottom>=docViewTop)&&(elemTop<=docViewBottom)&&(elemBottom<=docViewBottom)&&(elemTop>=docViewTop)&&(elemLeft>=docViewLeft)&&(elemRight<=docViewRight)&&(elemLeft<=docViewRight)&&(elemRight>=docViewLeft));}
else if(type=='vertical'){var verticalShowing=elemHeight-missingTop-missingBottom;if(amountVisible.indexOf('%')){return(((verticalShowing/elemHeight)*100)>=parseInt(amountVisible));}
else{return(verticalShowing>=parseInt(amountVisible));}}
else if(type=='horizontal'){var horizontalShowing=elemWidth-missingLeft-missingRight;if(amountVisible.indexOf('%')){return(((horizontalShowing/elemWidth)*100)>=parseInt(amountVisible));}
else{return(horizontalShowing>=parseInt(amountVisible));}}
else if(type=='area'){var areaShowing=(elemWidth-missingLeft-missingRight)*(elemHeight-missingTop-missingBottom);if(amountVisible.indexOf('%')){return(((areaShowing/elemArea)*100)>=parseInt(amountVisible));}
else{return(areaShowing>=parseInt(amountVisible));}}}})(jQuery);