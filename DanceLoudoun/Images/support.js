
(function($)
{var setDataSwitch={dragStart:"start.draggable",drag:"drag.draggable",dragStop:"stop.draggable",maxHeight:"maxHeight.resizable",minHeight:"minHeight.resizable",maxWidth:"maxWidth.resizable",minWidth:"minWidth.resizable",resizeStart:"start.resizable",resize:"drag.resizable",resizeStop:"stop.resizable"};$.widget("ui.simpleDialog",{options:{autoOpen:true,autoResize:true,bgiframe:false,buttons:{},closeOnEscape:true,draggable:true,height:150,minHeight:100,minWidth:150,modal:false,overlay:{},position:'center',positionMode:'absolute',resizable:true,stack:true,width:300,zIndex:1000},init:function()
{var self=this,options=this.options,resizeHandles=typeof options.resizable=='string'?options.resizable:'n,e,s,w,se,sw,ne,nw',previousContainer=(this.previousContainer=this.element.parent()),uiDialogContent=this.element.addClass('ui-dialog-content').css({top:'0',left:'0'}).wrap('<div/>'),uiDialog=(this.uiDialog=uiDialogContent.parent()).appendTo(document.body).hide().addClass('ui-dialog').addClass(options.dialogClass).addClass(uiDialogContent.attr('className')).removeClass('ui-dialog-content').css({position:options.positionMode,width:options.width,height:options.height,overflow:'hidden',zIndex:options.zIndex,padding:'0'}).attr('tabIndex',-1).css('outline',0).keydown(function(ev)
{if(options.closeOnEscape)
{var ESC=27;(ev.keyCode&&ev.keyCode==ESC&&self.close());}}).mousedown(function()
{})
this.isOpen=false;(options.bgiframe&&$.fn.bgiframe&&uiDialog.bgiframe());(options.autoOpen&&this.open());},setData:function(key,value)
{(setDataSwitch[key]&&this.uiDialog.data(setDataSwitch[key],value));switch(key)
{case"buttons":this.createButtons(value);break;case"draggable":this.uiDialog.draggable(value?'enable':'disable');break;case"height":this.uiDialog.height(value);break;case"position":this.position(value);break;case"resizable":(typeof value=='string'&&this.uiDialog.data('handles.resizable',value));this.uiDialog.resizable(value?'enable':'disable');break;case"title":$(".ui-dialog-title",this.uiDialogTitlebar).text(value);break;case"width":this.uiDialog.width(value);break;}
$.widget.prototype.setData.apply(this,arguments);},position:function(pos)
{var wnd=$(window),doc=$(document),pTop=doc.scrollTop(),pLeft=doc.scrollLeft(),minTop=pTop;var marginTop=0;var marginLeft=0;if($.inArray(pos,['center','top','right','bottom','left'])>=0)
{pos=[pos=='right'||pos=='left'?pos:'center',pos=='top'||pos=='bottom'?pos:'middle'];}
if(pos.constructor!=Array)
{pos=['center','middle'];}
if(pos[0].constructor==Number)
{pLeft+=pos[0];}else
{switch(pos[0])
{case'left':pLeft+=0;break;case'right':pLeft+=wnd.width()-this.uiDialog.width();break;default:case'center':pLeft='50%';marginLeft=-(this.uiDialog.width()/2);}}
if(pos[1].constructor==Number)
{pTop+=pos[1];}else
{switch(pos[1])
{case'top':pTop+=0;break;case'bottom':pTop+=wnd.height()-this.uiDialog.height();break;default:case'middle':pTop='50%';marginTop=-(this.uiDialog.height()/2);}}
if(pTop.charAt(pTop.length-1)!='%')
pTop=Math.max(pTop,minTop);this.uiDialog.css({top:pTop,left:pLeft,marginLeft:marginLeft,marginTop:marginTop});},size:function()
{var container=this.uiDialog,content=this.element;tbMargin=this._getSettingValue(content,'margin-top')+this._getSettingValue(content,'margin-bottom');lrMargin=this._getSettingValue(content,'margin-left')+this._getSettingValue(content,'margin-right');content.height(container.height()-tbMargin);content.width(container.width()-lrMargin);},open:function()
{if(this.isOpen){return;}
if(this.uiDialog==undefined)this.init();this.overlay=this.options.modal?new $.ui.simpleDialog.overlay(this):null;(this.uiDialog.next().length>0)&&this.uiDialog.appendTo('body');this.options.autoResize&&this.size();this.position(this.options.position);this.uiDialog.fadeIn("slow");this.moveToTop(true);var openEV=null;var openUI={options:this.options};this.element.triggerHandler("dialogopen",[openEV,openUI],this.options.open);this.isOpen=true;},moveToTop:function(force)
{var $this=this;if((this.options.modal&&!force)||(!this.options.stack&&!this.options.modal)){return this.element.triggerHandler("dialogfocus",[null,{options:this.options}],this.options.focus);}
var maxZ=this.options.zIndex,options=this.options;$('.ui-dialog:visible').each(function()
{maxZ=Math.max(maxZ,$this._getSettingValue($(this),'z-index')||options.zIndex);});if(maxZ=='NaN')maxZ=0;(this.overlay&&this.overlay.$el.css('z-index',++maxZ));this.uiDialog.css('z-index',++maxZ);this.element.triggerHandler("dialogfocus",[null,{options:this.options}],this.options.focus);},close:function()
{(this.overlay&&this.overlay.destroy());this.uiDialog.fadeOut("slow");var closeEV=null;var closeUI={options:this.options};this.element.triggerHandler("dialogclose",[closeEV,closeUI],this.options.close);$.ui.simpleDialog.overlay.resize();this.isOpen=false;},destroy:function()
{(this.overlay&&this.overlay.destroy());this.uiDialog.hide();this.element.unbind('.simpleDialog').removeData('dialog').removeClass('ui-dialog-content').hide().appendTo(this.previousContainer);this.uiDialog.remove();},createButtons:function(buttons)
{var self=this,hasButtons=false,uiDialogButtonPane=this.uiDialogButtonPane;uiDialogButtonPane.empty().hide();$.each(buttons,function(){return!(hasButtons=true);});if(hasButtons)
{uiDialogButtonPane.show();$.each(buttons,function(name,fn)
{$('<button/>').text(name).click(function(){fn.apply(self.element[0],arguments);}).appendTo(uiDialogButtonPane);});}},_getSettingValue:function(el,setting)
{var val=parseInt(el.css(setting),10);if(val='NaN')val=0;return val;}});$.extend($.ui.simpleDialog,{overlay:function(dialog)
{this.$el=$.ui.simpleDialog.overlay.create(dialog);}});$.extend($.ui.simpleDialog.overlay,{instances:[],events:$.map('focus,mousedown,mouseup,keydown,keypress,click'.split(','),function(e){return e+'.dialog-overlay';}).join(' '),create:function(dialog)
{if(this.instances.length===0)
{setTimeout(function()
{$('a, :input').bind($.ui.simpleDialog.overlay.events,function()
{var allow=false;var $dialog=$(this).parents('.ui-dialog');if($dialog.length)
{var $overlays=$('.ui-dialog-overlay');if($overlays.length)
{var maxZ=parseInt($overlays.css('z-index'),10);$overlays.each(function()
{maxZ=Math.max(maxZ,parseInt($(this).css('z-index'),10));});allow=parseInt($dialog.css('z-index'),10)>maxZ;}else
{allow=true;}}
return allow;});},1);if(dialog.options.closeOnEscape)
{$(document).bind('keydown.dialog-overlay',function(e)
{var ESC=27;(e.keyCode&&e.keyCode==ESC&&dialog.close());});}
$(window).bind('resize.dialog-overlay',$.ui.simpleDialog.overlay.resize);}
var $el=$('<div/>').appendTo(document.body).addClass('ui-dialog-overlay').css($.extend({borderWidth:0,margin:0,padding:0,position:dialog.options.positionMode,top:0,left:0,width:this.width(),height:this.height()},dialog.options.overlay));(dialog.options.bgiframe&&$.fn.bgiframe&&$el.bgiframe());this.instances.push($el);return $el;},destroy:function($el)
{this.instances.splice($.inArray(this.instances,$el),1);if(this.instances.length===0)
{$('a, :input').add([document,window]).unbind('.dialog-overlay');}
$el.remove();},height:function()
{if($.browser.msie&&$.browser.version<7)
{var scrollHeight=Math.max(document.documentElement.scrollHeight,document.body.scrollHeight);var offsetHeight=Math.max(document.documentElement.offsetHeight,document.body.offsetHeight);return(scrollHeight<offsetHeight)?$(window).height()+'px':scrollHeight+'px';}
else
{return $(window).height()+'px';}},width:function()
{if($.browser.msie&&$.browser.version<7)
{var scrollWidth=Math.max(document.documentElement.scrollWidth,document.body.scrollWidth);var offsetWidth=Math.max(document.documentElement.offsetWidth,document.body.offsetWidth);return(scrollWidth<offsetWidth)?$(window).width()+'px':scrollWidth+'px';}
else
{return $(window).width()+'px';}},resize:function()
{var $overlays=$([]);$.each($.ui.simpleDialog.overlay.instances,function()
{$overlays=$overlays.add(this);});$overlays.css({width:0,height:0}).css({width:$.ui.simpleDialog.overlay.width(),height:$.ui.simpleDialog.overlay.height()});}});$.extend($.ui.simpleDialog.overlay.prototype,{destroy:function()
{$.ui.simpleDialog.overlay.destroy(this.$el);}});})(jQuery);
