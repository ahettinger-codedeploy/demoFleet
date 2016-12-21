(function($){function toIntegersAtLease(n){return n<10?"0"+n:n}Date.prototype.toJSON=function(date){return this.getUTCFullYear()+"-"+toIntegersAtLease(this.getUTCMonth())+"-"+toIntegersAtLease(this.getUTCDate())
};var escapeable=/["\\\x00-\x1f\x7f-\x9f]/g;var meta={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"};
$.quoteString=function(string){if(escapeable.test(string)){return'"'+string.replace(escapeable,function(a){var c=meta[a];
if(typeof c==="string"){return c}c=a.charCodeAt();return"\\u00"+Math.floor(c/16).toString(16)+(c%16).toString(16)
})+'"'}return'"'+string+'"'};$.toJSON=function(o,compact){var type=typeof(o);if(type=="undefined"){return"undefined"
}else{if(type=="number"||type=="boolean"){return o+""}else{if(o===null){return"null"}}}if(type=="string"){return $.quoteString(o)
}if(type=="object"&&typeof o.toJSON=="function"){return o.toJSON(compact)}if(type!="function"&&typeof(o.length)=="number"){var ret=[];
for(var i=0;i<o.length;i++){ret.push($.toJSON(o[i],compact))}if(compact){return"["+ret.join(",")+"]"}else{return"["+ret.join(", ")+"]"
}}if(type=="function"){throw new TypeError("Unable to convert object of type 'function' to json.")}var ret=[];
for(var k in o){var name;type=typeof(k);if(type=="number"){name='"'+k+'"'}else{if(type=="string"){name=$.quoteString(k)
}else{continue}}var val=$.toJSON(o[k],compact);if(typeof(val)!="string"){continue}if(compact){ret.push(name+":"+val)
}else{ret.push(name+": "+val)}}return"{"+ret.join(", ")+"}"};$.compactJSON=function(o){return $.toJSON(o,true)
};$.evalJSON=function(src){return eval("("+src+")")};$.secureEvalJSON=function(src){var filtered=src;
filtered=filtered.replace(/\\["\\\/bfnrtu]/g,"@");filtered=filtered.replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]");
filtered=filtered.replace(/(?:^|:|,)(?:\s*\[)+/g,"");if(/^[\],:{}\s]*$/.test(filtered)){return eval("("+src+")")
}else{throw new SyntaxError("Error parsing JSON, source is not valid.")}}})(jQuery);window.apsinth={util:{},msg:{}};
if(window.console==null){window.console={log:function(){},error:function(){},warn:function(){},debug:function(){}}
}jQuery.ui||(function(p){var j=p.fn.remove,o=p.browser.mozilla&&(parseFloat(p.browser.version)<1.9);p.ui={version:"1.7.2",plugin:{add:function(c,b,e){var a=p.ui[c].prototype;
for(var d in e){a.plugins[d]=a.plugins[d]||[];a.plugins[d].push([b,e[d]])}},call:function(d,b,c){var e=d.plugins[b];
if(!e||!d.element[0].parentNode){return}for(var a=0;a<e.length;a++){if(d.options[e[a][0]]){e[a][1].apply(d.element,c)
}}}},contains:function(a,b){return document.compareDocumentPosition?a.compareDocumentPosition(b)&16:a!==b&&a.contains(b)
},hasScroll:function(a,c){if(p(a).css("overflow")=="hidden"){return false}var d=(c&&c=="left")?"scrollLeft":"scrollTop",b=false;
if(a[d]>0){return true}a[d]=1;b=(a[d]>0);a[d]=0;return b},isOverAxis:function(b,c,a){return(b>c)&&(b<(c+a))
},isOver:function(e,c,f,a,d,b){return p.ui.isOverAxis(e,f,d)&&p.ui.isOverAxis(c,a,b)},keyCode:{BACKSPACE:8,CAPS_LOCK:20,COMMA:188,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38}};
if(o){var m=p.attr,n=p.fn.removeAttr,k="http://www.w3.org/2005/07/aaa",r=/^aria-/,q=/^wairole:/;p.attr=function(c,d,b){var a=b!==undefined;
return(d=="role"?(a?m.call(this,c,d,"wairole:"+b):(m.apply(this,arguments)||"").replace(q,"")):(r.test(d)?(a?c.setAttributeNS(k,d.replace(r,"aaa:"),b):m.call(this,c,d.replace(r,"aaa:"))):m.apply(this,arguments)))
};p.fn.removeAttr=function(a){return(r.test(a)?this.each(function(){this.removeAttributeNS(k,a.replace(r,""))
}):n.call(this,a))}}p.fn.extend({remove:function(){p("*",this).add(this).each(function(){p(this).triggerHandler("remove")
});return j.apply(this,arguments)},enableSelection:function(){return this.attr("unselectable","off").css("MozUserSelect","").unbind("selectstart.ui")
},disableSelection:function(){return this.attr("unselectable","on").css("MozUserSelect","none").bind("selectstart.ui",function(){return false
})},scrollParent:function(){var a;if((p.browser.msie&&(/(static|relative)/).test(this.css("position")))||(/absolute/).test(this.css("position"))){a=this.parents().filter(function(){return(/(relative|absolute|fixed)/).test(p.curCSS(this,"position",1))&&(/(auto|scroll)/).test(p.curCSS(this,"overflow",1)+p.curCSS(this,"overflow-y",1)+p.curCSS(this,"overflow-x",1))
}).eq(0)}else{a=this.parents().filter(function(){return(/(auto|scroll)/).test(p.curCSS(this,"overflow",1)+p.curCSS(this,"overflow-y",1)+p.curCSS(this,"overflow-x",1))
}).eq(0)}return(/fixed/).test(this.css("position"))||!a.length?p(document):a}});p.extend(p.expr[":"],{data:function(a,b,c){return !!p.data(a,c[3])
},focusable:function(b){var a=b.nodeName.toLowerCase(),c=p.attr(b,"tabindex");return(/input|select|textarea|button|object/.test(a)?!b.disabled:"a"==a||"area"==a?b.href||!isNaN(c):!isNaN(c))&&!p(b)["area"==a?"parents":"closest"](":hidden").length
},tabbable:function(a){var b=p.attr(a,"tabindex");return(isNaN(b)||b>=0)&&p(a).is(":focusable")}});function l(a,f,e,b){function c(g){var h=p[a][f][g]||[];
return(typeof h=="string"?h.split(/,?\s+/):h)}var d=c("getter");if(b.length==1&&typeof b[0]=="string"){d=d.concat(c("getterSetter"))
}return(p.inArray(e,d)!=-1)}p.widget=function(b,c){var a=b.split(".")[0];b=b.split(".")[1];p.fn[b]=function(e){var g=(typeof e=="string"),f=Array.prototype.slice.call(arguments,1);
if(g&&e.substring(0,1)=="_"){return this}if(g&&l(a,b,e,f)){var d=p.data(this[0],b);return(d?d[e].apply(d,f):undefined)
}return this.each(function(){var h=p.data(this,b);(!h&&!g&&p.data(this,b,new p[a][b](this,e))._init());
(h&&g&&p.isFunction(h[e])&&h[e].apply(h,f))})};p[a]=p[a]||{};p[a][b]=function(e,f){var d=this;this.namespace=a;
this.widgetName=b;this.widgetEventPrefix=p[a][b].eventPrefix||b;this.widgetBaseClass=a+"-"+b;this.options=p.extend({},p.widget.defaults,p[a][b].defaults,p.metadata&&p.metadata.get(e)[b],f);
this.element=p(e).bind("setData."+b,function(h,i,g){if(h.target==e){return d._setData(i,g)}}).bind("getData."+b,function(g,h){if(g.target==e){return d._getData(h)
}}).bind("remove",function(){return d.destroy()})};p[a][b].prototype=p.extend({},p.widget.prototype,c);
p[a][b].getterSetter="option"};p.widget.prototype={_init:function(){},destroy:function(){this.element.removeData(this.widgetName).removeClass(this.widgetBaseClass+"-disabled "+this.namespace+"-state-disabled").removeAttr("aria-disabled")
},option:function(b,a){var c=b,d=this;if(typeof b=="string"){if(a===undefined){return this._getData(b)
}c={};c[b]=a}p.each(c,function(f,e){d._setData(f,e)})},_getData:function(a){return this.options[a]},_setData:function(b,a){this.options[b]=a;
if(b=="disabled"){this.element[a?"addClass":"removeClass"](this.widgetBaseClass+"-disabled "+this.namespace+"-state-disabled").attr("aria-disabled",a)
}},enable:function(){this._setData("disabled",false)},disable:function(){this._setData("disabled",true)
},_trigger:function(b,a,g){var e=this.options[b],d=(b==this.widgetEventPrefix?b:this.widgetEventPrefix+b);
a=p.Event(a);a.type=d;if(a.originalEvent){for(var c=p.event.props.length,f;c;){f=p.event.props[--c];a[f]=a.originalEvent[f]
}}this.element.trigger(a,g);return !(p.isFunction(e)&&e.call(this.element[0],a,g)===false||a.isDefaultPrevented())
}};p.widget.defaults={disabled:false};p.ui.mouse={_mouseInit:function(){var a=this;this.element.bind("mousedown."+this.widgetName,function(b){return a._mouseDown(b)
}).bind("click."+this.widgetName,function(b){if(a._preventClickEvent){a._preventClickEvent=false;b.stopImmediatePropagation();
return false}});if(p.browser.msie){this._mouseUnselectable=this.element.attr("unselectable");this.element.attr("unselectable","on")
}this.started=false},_mouseDestroy:function(){this.element.unbind("."+this.widgetName);(p.browser.msie&&this.element.attr("unselectable",this._mouseUnselectable))
},_mouseDown:function(b){b.originalEvent=b.originalEvent||{};if(b.originalEvent.mouseHandled){return}(this._mouseStarted&&this._mouseUp(b));
this._mouseDownEvent=b;var c=this,a=(b.which==1),d=(typeof this.options.cancel=="string"?p(b.target).parents().add(b.target).filter(this.options.cancel).length:false);
if(!a||d||!this._mouseCapture(b)){return true}this.mouseDelayMet=!this.options.delay;if(!this.mouseDelayMet){this._mouseDelayTimer=setTimeout(function(){c.mouseDelayMet=true
},this.options.delay)}if(this._mouseDistanceMet(b)&&this._mouseDelayMet(b)){this._mouseStarted=(this._mouseStart(b)!==false);
if(!this._mouseStarted){b.preventDefault();return true}}this._mouseMoveDelegate=function(e){return c._mouseMove(e)
};this._mouseUpDelegate=function(e){return c._mouseUp(e)};p(document).bind("mousemove."+this.widgetName,this._mouseMoveDelegate).bind("mouseup."+this.widgetName,this._mouseUpDelegate);
(p.browser.safari||b.preventDefault());b.originalEvent.mouseHandled=true;return true},_mouseMove:function(a){if(p.browser.msie&&!a.button){return this._mouseUp(a)
}if(this._mouseStarted){this._mouseDrag(a);return a.preventDefault()}if(this._mouseDistanceMet(a)&&this._mouseDelayMet(a)){this._mouseStarted=(this._mouseStart(this._mouseDownEvent,a)!==false);
(this._mouseStarted?this._mouseDrag(a):this._mouseUp(a))}return !this._mouseStarted},_mouseUp:function(a){p(document).unbind("mousemove."+this.widgetName,this._mouseMoveDelegate).unbind("mouseup."+this.widgetName,this._mouseUpDelegate);
if(this._mouseStarted){this._mouseStarted=false;this._preventClickEvent=(a.target==this._mouseDownEvent.target);
this._mouseStop(a)}return false},_mouseDistanceMet:function(a){return(Math.max(Math.abs(this._mouseDownEvent.pageX-a.pageX),Math.abs(this._mouseDownEvent.pageY-a.pageY))>=this.options.distance)
},_mouseDelayMet:function(a){return this.mouseDelayMet},_mouseStart:function(a){},_mouseDrag:function(a){},_mouseStop:function(a){},_mouseCapture:function(a){return true
}};p.ui.mouse.defaults={cancel:null,distance:1,delay:0}})(jQuery);(jQuery.ui&&jQuery.ui.draggable)||(function(b){b.widget("ui.draggable",b.extend({},b.ui.mouse,{_init:function(){if(this.options.helper=="original"&&!(/^(?:r|a|f)/).test(this.element.css("position"))){this.element[0].style.position="relative"
}(this.options.addClasses&&this.element.addClass("ui-draggable"));(this.options.disabled&&this.element.addClass("ui-draggable-disabled"));
this._mouseInit()},destroy:function(){if(!this.element.data("draggable")){return}this.element.removeData("draggable").unbind(".draggable").removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled");
this._mouseDestroy()},_mouseCapture:function(a){var d=this.options;if(this.helper||d.disabled||b(a.target).is(".ui-resizable-handle")){return false
}this.handle=this._getHandle(a);if(!this.handle){return false}return true},_mouseStart:function(a){var d=this.options;
this.helper=this._createHelper(a);this._cacheHelperProportions();if(b.ui.ddmanager){b.ui.ddmanager.current=this
}this._cacheMargins();this.cssPosition=this.helper.css("position");this.scrollParent=this.helper.scrollParent();
this.offset=this.element.offset();this.offset={top:this.offset.top-this.margins.top,left:this.offset.left-this.margins.left};
b.extend(this.offset,{click:{left:a.pageX-this.offset.left,top:a.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()});
this.originalPosition=this._generatePosition(a);this.originalPageX=a.pageX;this.originalPageY=a.pageY;
if(d.cursorAt){this._adjustOffsetFromHelper(d.cursorAt)}if(d.containment){this._setContainment()}this._trigger("start",a);
this._cacheHelperProportions();if(b.ui.ddmanager&&!d.dropBehaviour){b.ui.ddmanager.prepareOffsets(this,a)
}this.helper.addClass("ui-draggable-dragging");this._mouseDrag(a,true);return true},_mouseDrag:function(a,e){this.position=this._generatePosition(a);
this.positionAbs=this._convertPositionTo("absolute");if(!e){var f=this._uiHash();this._trigger("drag",a,f);
this.position=f.position}if(!this.options.axis||this.options.axis!="y"){this.helper[0].style.left=this.position.left+"px"
}if(!this.options.axis||this.options.axis!="x"){this.helper[0].style.top=this.position.top+"px"}if(b.ui.ddmanager){b.ui.ddmanager.drag(this,a)
}return false},_mouseStop:function(f){var e=false;if(b.ui.ddmanager&&!this.options.dropBehaviour){e=b.ui.ddmanager.drop(this,f)
}if(this.dropped){e=this.dropped;this.dropped=false}if((this.options.revert=="invalid"&&!e)||(this.options.revert=="valid"&&e)||this.options.revert===true||(b.isFunction(this.options.revert)&&this.options.revert.call(this.element,e))){var a=this;
b(this.helper).animate(this.originalPosition,parseInt(this.options.revertDuration,10),function(){a._trigger("stop",f);
a._clear()})}else{this._trigger("stop",f);this._clear()}return false},_getHandle:function(a){var d=!this.options.handle||!b(this.options.handle,this.element).length?true:false;
b(this.options.handle,this.element).find("*").andSelf().each(function(){if(this==a.target){d=true}});
return d},_createHelper:function(f){var e=this.options;var a=b.isFunction(e.helper)?b(e.helper.apply(this.element[0],[f])):(e.helper=="clone"?this.element.clone():this.element);
if(!a.parents("body").length){a.appendTo((e.appendTo=="parent"?this.element[0].parentNode:e.appendTo))
}if(a[0]!=this.element[0]&&!(/(fixed|absolute)/).test(a.css("position"))){a.css("position","absolute")
}return a},_adjustOffsetFromHelper:function(a){if(a.left!=undefined){this.offset.click.left=a.left+this.margins.left
}if(a.right!=undefined){this.offset.click.left=this.helperProportions.width-a.right+this.margins.left
}if(a.top!=undefined){this.offset.click.top=a.top+this.margins.top}if(a.bottom!=undefined){this.offset.click.top=this.helperProportions.height-a.bottom+this.margins.top
}},_getParentOffset:function(){this.offsetParent=this.helper.offsetParent();var a=this.offsetParent.offset();
if(this.cssPosition=="absolute"&&this.scrollParent[0]!=document&&b.ui.contains(this.scrollParent[0],this.offsetParent[0])){a.left+=this.scrollParent.scrollLeft();
a.top+=this.scrollParent.scrollTop()}if((this.offsetParent[0]==document.body)||(this.offsetParent[0].tagName&&this.offsetParent[0].tagName.toLowerCase()=="html"&&b.browser.msie)){a={top:0,left:0}
}return{top:a.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:a.left+(parseInt(this.offsetParent.css("borderLeftWidth"),10)||0)}
},_getRelativeOffset:function(){if(this.cssPosition=="relative"){var a=this.element.position();return{top:a.top-(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:a.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}
}else{return{top:0,left:0}}},_cacheMargins:function(){this.margins={left:(parseInt(this.element.css("marginLeft"),10)||0),top:(parseInt(this.element.css("marginTop"),10)||0)}
},_cacheHelperProportions:function(){this.helperProportions={width:this.helper.outerWidth(),height:this.helper.outerHeight()}
},_setContainment:function(){var f=this.options;if(f.containment=="parent"){f.containment=this.helper[0].parentNode
}if(f.containment=="document"||f.containment=="window"){this.containment=[0-this.offset.relative.left-this.offset.parent.left,0-this.offset.relative.top-this.offset.parent.top,b(f.containment=="document"?document:window).width()-this.helperProportions.width-this.margins.left,(b(f.containment=="document"?document:window).height()||document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top]
}if(!(/^(document|window|parent)$/).test(f.containment)&&f.containment.constructor!=Array){var h=b(f.containment)[0];
if(!h){return}var g=b(f.containment).offset();var a=(b(h).css("overflow")!="hidden");this.containment=[g.left+(parseInt(b(h).css("borderLeftWidth"),10)||0)+(parseInt(b(h).css("paddingLeft"),10)||0)-this.margins.left,g.top+(parseInt(b(h).css("borderTopWidth"),10)||0)+(parseInt(b(h).css("paddingTop"),10)||0)-this.margins.top,g.left+(a?Math.max(h.scrollWidth,h.offsetWidth):h.offsetWidth)-(parseInt(b(h).css("borderLeftWidth"),10)||0)-(parseInt(b(h).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left,g.top+(a?Math.max(h.scrollHeight,h.offsetHeight):h.offsetHeight)-(parseInt(b(h).css("borderTopWidth"),10)||0)-(parseInt(b(h).css("paddingBottom"),10)||0)-this.helperProportions.height-this.margins.top]
}else{if(f.containment.constructor==Array){this.containment=f.containment}}},_convertPositionTo:function(j,d){if(!d){d=this.position
}var l=j=="absolute"?1:-1;var k=this.options,a=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&b.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,i=(/(html|body)/i).test(a[0].tagName);
return{top:(d.top+this.offset.relative.top*l+this.offset.parent.top*l-(b.browser.safari&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollTop():(i?0:a.scrollTop()))*l)),left:(d.left+this.offset.relative.left*l+this.offset.parent.left*l-(b.browser.safari&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():i?0:a.scrollLeft())*l))}
},_generatePosition:function(n){var k=this.options,a=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&b.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,j=(/(html|body)/i).test(a[0].tagName);
if(this.cssPosition=="relative"&&!(this.scrollParent[0]!=document&&this.scrollParent[0]!=this.offsetParent[0])){this.offset.relative=this._getRelativeOffset()
}var o=n.pageX;var p=n.pageY;if(this.originalPosition){if(this.containment){if(n.pageX-this.offset.click.left<this.containment[0]){o=this.containment[0]+this.offset.click.left
}if(n.pageY-this.offset.click.top<this.containment[1]){p=this.containment[1]+this.offset.click.top}if(n.pageX-this.offset.click.left>this.containment[2]){o=this.containment[2]+this.offset.click.left
}if(n.pageY-this.offset.click.top>this.containment[3]){p=this.containment[3]+this.offset.click.top}}if(k.grid){var l=this.originalPageY+Math.round((p-this.originalPageY)/k.grid[1])*k.grid[1];
p=this.containment?(!(l-this.offset.click.top<this.containment[1]||l-this.offset.click.top>this.containment[3])?l:(!(l-this.offset.click.top<this.containment[1])?l-k.grid[1]:l+k.grid[1])):l;
var m=this.originalPageX+Math.round((o-this.originalPageX)/k.grid[0])*k.grid[0];o=this.containment?(!(m-this.offset.click.left<this.containment[0]||m-this.offset.click.left>this.containment[2])?m:(!(m-this.offset.click.left<this.containment[0])?m-k.grid[0]:m+k.grid[0])):m
}}return{top:(p-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+(b.browser.safari&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollTop():(j?0:a.scrollTop())))),left:(o-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+(b.browser.safari&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():j?0:a.scrollLeft())))}
},_clear:function(){this.helper.removeClass("ui-draggable-dragging");if(this.helper[0]!=this.element[0]&&!this.cancelHelperRemoval){this.helper.remove()
}this.helper=null;this.cancelHelperRemoval=false},_trigger:function(a,f,e){e=e||this._uiHash();b.ui.plugin.call(this,a,[f,e]);
if(a=="drag"){this.positionAbs=this._convertPositionTo("absolute")}return b.widget.prototype._trigger.call(this,a,f,e)
},plugins:{},_uiHash:function(a){return{helper:this.helper,position:this.position,absolutePosition:this.positionAbs,offset:this.positionAbs}
}}));b.extend(b.ui.draggable,{version:"1.7.2",eventPrefix:"drag",defaults:{addClasses:true,appendTo:"parent",axis:false,cancel:":input,option",connectToSortable:false,containment:false,cursor:"auto",cursorAt:false,delay:0,distance:1,grid:false,handle:false,helper:"original",iframeFix:false,opacity:false,refreshPositions:false,revert:false,revertDuration:500,scope:"default",scroll:true,scrollSensitivity:20,scrollSpeed:20,snap:false,snapMode:"both",snapTolerance:20,stack:false,zIndex:false}});
b.ui.plugin.add("draggable","connectToSortable",{start:function(j,h){var i=b(this).data("draggable"),g=i.options,a=b.extend({},h,{item:i.element});
i.sortables=[];b(g.connectToSortable).each(function(){var c=b.data(this,"sortable");if(c&&!c.options.disabled){i.sortables.push({instance:c,shouldRevert:c.options.revert});
c._refreshItems();c._trigger("activate",j,a)}})},stop:function(h,f){var g=b(this).data("draggable"),a=b.extend({},f,{item:g.element});
b.each(g.sortables,function(){if(this.instance.isOver){this.instance.isOver=0;g.cancelHelperRemoval=true;
this.instance.cancelHelperRemoval=false;if(this.shouldRevert){this.instance.options.revert=true}this.instance._mouseStop(h);
this.instance.options.helper=this.instance.options._helper;if(g.options.helper=="original"){this.instance.currentItem.css({top:"auto",left:"auto"})
}}else{this.instance.cancelHelperRemoval=false;this.instance._trigger("deactivate",h,a)}})},drag:function(j,g){var h=b(this).data("draggable"),a=this;
var i=function(r){var d=this.offset.click.top,e=this.offset.click.left;var t=this.positionAbs.top,o=this.positionAbs.left;
var q=r.height,f=r.width;var c=r.top,s=r.left;return b.ui.isOver(t+d,o+e,c,s,q,f)};b.each(h.sortables,function(c){this.instance.positionAbs=h.positionAbs;
this.instance.helperProportions=h.helperProportions;this.instance.offset.click=h.offset.click;if(this.instance._intersectsWith(this.instance.containerCache)){if(!this.instance.isOver){this.instance.isOver=1;
this.instance.currentItem=b(a).clone().appendTo(this.instance.element).data("sortable-item",true);this.instance.options._helper=this.instance.options.helper;
this.instance.options.helper=function(){return g.helper[0]};j.target=this.instance.currentItem[0];this.instance._mouseCapture(j,true);
this.instance._mouseStart(j,true,true);this.instance.offset.click.top=h.offset.click.top;this.instance.offset.click.left=h.offset.click.left;
this.instance.offset.parent.left-=h.offset.parent.left-this.instance.offset.parent.left;this.instance.offset.parent.top-=h.offset.parent.top-this.instance.offset.parent.top;
h._trigger("toSortable",j);h.dropped=this.instance.element;h.currentItem=h.element;this.instance.fromOutside=h
}if(this.instance.currentItem){this.instance._mouseDrag(j)}}else{if(this.instance.isOver){this.instance.isOver=0;
this.instance.cancelHelperRemoval=true;this.instance.options.revert=false;this.instance._trigger("out",j,this.instance._uiHash(this.instance));
this.instance._mouseStop(j,true);this.instance.options.helper=this.instance.options._helper;this.instance.currentItem.remove();
if(this.instance.placeholder){this.instance.placeholder.remove()}h._trigger("fromSortable",j);h.dropped=false
}}})}});b.ui.plugin.add("draggable","cursor",{start:function(h,g){var a=b("body"),f=b(this).data("draggable").options;
if(a.css("cursor")){f._cursor=a.css("cursor")}a.css("cursor",f.cursor)},stop:function(a,f){var e=b(this).data("draggable").options;
if(e._cursor){b("body").css("cursor",e._cursor)}}});b.ui.plugin.add("draggable","iframeFix",{start:function(a,f){var e=b(this).data("draggable").options;
b(e.iframeFix===true?"iframe":e.iframeFix).each(function(){b('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>').css({width:this.offsetWidth+"px",height:this.offsetHeight+"px",position:"absolute",opacity:"0.001",zIndex:1000}).css(b(this).offset()).appendTo("body")
})},stop:function(a,d){b("div.ui-draggable-iframeFix").each(function(){this.parentNode.removeChild(this)
})}});b.ui.plugin.add("draggable","opacity",{start:function(h,g){var a=b(g.helper),f=b(this).data("draggable").options;
if(a.css("opacity")){f._opacity=a.css("opacity")}a.css("opacity",f.opacity)},stop:function(a,f){var e=b(this).data("draggable").options;
if(e._opacity){b(f.helper).css("opacity",e._opacity)}}});b.ui.plugin.add("draggable","scroll",{start:function(f,e){var a=b(this).data("draggable");
if(a.scrollParent[0]!=document&&a.scrollParent[0].tagName!="HTML"){a.overflowOffset=a.scrollParent.offset()
}},drag:function(i,h){var j=b(this).data("draggable"),g=j.options,a=false;if(j.scrollParent[0]!=document&&j.scrollParent[0].tagName!="HTML"){if(!g.axis||g.axis!="x"){if((j.overflowOffset.top+j.scrollParent[0].offsetHeight)-i.pageY<g.scrollSensitivity){j.scrollParent[0].scrollTop=a=j.scrollParent[0].scrollTop+g.scrollSpeed
}else{if(i.pageY-j.overflowOffset.top<g.scrollSensitivity){j.scrollParent[0].scrollTop=a=j.scrollParent[0].scrollTop-g.scrollSpeed
}}}if(!g.axis||g.axis!="y"){if((j.overflowOffset.left+j.scrollParent[0].offsetWidth)-i.pageX<g.scrollSensitivity){j.scrollParent[0].scrollLeft=a=j.scrollParent[0].scrollLeft+g.scrollSpeed
}else{if(i.pageX-j.overflowOffset.left<g.scrollSensitivity){j.scrollParent[0].scrollLeft=a=j.scrollParent[0].scrollLeft-g.scrollSpeed
}}}}else{if(!g.axis||g.axis!="x"){if(i.pageY-b(document).scrollTop()<g.scrollSensitivity){a=b(document).scrollTop(b(document).scrollTop()-g.scrollSpeed)
}else{if(b(window).height()-(i.pageY-b(document).scrollTop())<g.scrollSensitivity){a=b(document).scrollTop(b(document).scrollTop()+g.scrollSpeed)
}}}if(!g.axis||g.axis!="y"){if(i.pageX-b(document).scrollLeft()<g.scrollSensitivity){a=b(document).scrollLeft(b(document).scrollLeft()-g.scrollSpeed)
}else{if(b(window).width()-(i.pageX-b(document).scrollLeft())<g.scrollSensitivity){a=b(document).scrollLeft(b(document).scrollLeft()+g.scrollSpeed)
}}}}if(a!==false&&b.ui.ddmanager&&!g.dropBehaviour){b.ui.ddmanager.prepareOffsets(j,i)}}});b.ui.plugin.add("draggable","snap",{start:function(h,g){var a=b(this).data("draggable"),f=a.options;
a.snapElements=[];b(f.snap.constructor!=String?(f.snap.items||":data(draggable)"):f.snap).each(function(){var c=b(this);
var d=c.offset();if(this!=a.element[0]){a.snapElements.push({item:this,width:c.outerWidth(),height:c.outerHeight(),top:d.top,left:d.left})
}})},drag:function(r,D){var J=b(this).data("draggable"),B=J.options;var d=B.snapTolerance;var i=D.offset.left,l=i+J.helperProportions.width,K=D.offset.top,L=K+J.helperProportions.height;
for(var o=J.snapElements.length-1;o>=0;o--){var t=J.snapElements[o].left,E=t+J.snapElements[o].width,F=J.snapElements[o].top,C=F+J.snapElements[o].height;
if(!((t-d<i&&i<E+d&&F-d<K&&K<C+d)||(t-d<i&&i<E+d&&F-d<L&&L<C+d)||(t-d<l&&l<E+d&&F-d<K&&K<C+d)||(t-d<l&&l<E+d&&F-d<L&&L<C+d))){if(J.snapElements[o].snapping){(J.options.snap.release&&J.options.snap.release.call(J.element,r,b.extend(J._uiHash(),{snapItem:J.snapElements[o].item})))
}J.snapElements[o].snapping=false;continue}if(B.snapMode!="inner"){var M=Math.abs(F-L)<=d;var a=Math.abs(C-K)<=d;
var H=Math.abs(t-l)<=d;var G=Math.abs(E-i)<=d;if(M){D.position.top=J._convertPositionTo("relative",{top:F-J.helperProportions.height,left:0}).top-J.margins.top
}if(a){D.position.top=J._convertPositionTo("relative",{top:C,left:0}).top-J.margins.top}if(H){D.position.left=J._convertPositionTo("relative",{top:0,left:t-J.helperProportions.width}).left-J.margins.left
}if(G){D.position.left=J._convertPositionTo("relative",{top:0,left:E}).left-J.margins.left}}var I=(M||a||H||G);
if(B.snapMode!="outer"){var M=Math.abs(F-K)<=d;var a=Math.abs(C-L)<=d;var H=Math.abs(t-i)<=d;var G=Math.abs(E-l)<=d;
if(M){D.position.top=J._convertPositionTo("relative",{top:F,left:0}).top-J.margins.top}if(a){D.position.top=J._convertPositionTo("relative",{top:C-J.helperProportions.height,left:0}).top-J.margins.top
}if(H){D.position.left=J._convertPositionTo("relative",{top:0,left:t}).left-J.margins.left}if(G){D.position.left=J._convertPositionTo("relative",{top:0,left:E-J.helperProportions.width}).left-J.margins.left
}}if(!J.snapElements[o].snapping&&(M||a||H||G||I)){(J.options.snap.snap&&J.options.snap.snap.call(J.element,r,b.extend(J._uiHash(),{snapItem:J.snapElements[o].item})))
}J.snapElements[o].snapping=(M||a||H||G||I)}}});b.ui.plugin.add("draggable","stack",{start:function(a,h){var f=b(this).data("draggable").options;
var g=b.makeArray(b(f.stack.group)).sort(function(c,d){return(parseInt(b(c).css("zIndex"),10)||f.stack.min)-(parseInt(b(d).css("zIndex"),10)||f.stack.min)
});b(g).each(function(c){this.style.zIndex=f.stack.min+c});this[0].style.zIndex=f.stack.min+g.length}});
b.ui.plugin.add("draggable","zIndex",{start:function(h,g){var a=b(g.helper),f=b(this).data("draggable").options;
if(a.css("zIndex")){f._zIndex=a.css("zIndex")}a.css("zIndex",f.zIndex)},stop:function(a,f){var e=b(this).data("draggable").options;
if(e._zIndex){b(f.helper).css("zIndex",e._zIndex)}}})})(jQuery);(jQuery.ui&&jQuery.ui.droppable)||(function(b){b.widget("ui.droppable",{_init:function(){var d=this.options,a=d.accept;
this.isover=0;this.isout=1;this.options.accept=this.options.accept&&b.isFunction(this.options.accept)?this.options.accept:function(c){return c.is(a)
};this.proportions={width:this.element[0].offsetWidth,height:this.element[0].offsetHeight};b.ui.ddmanager.droppables[this.options.scope]=b.ui.ddmanager.droppables[this.options.scope]||[];
b.ui.ddmanager.droppables[this.options.scope].push(this);(this.options.addClasses&&this.element.addClass("ui-droppable"))
},destroy:function(){var a=b.ui.ddmanager.droppables[this.options.scope];for(var d=0;d<a.length;d++){if(a[d]==this){a.splice(d,1)
}}this.element.removeClass("ui-droppable ui-droppable-disabled").removeData("droppable").unbind(".droppable")
},_setData:function(a,d){if(a=="accept"){this.options.accept=d&&b.isFunction(d)?d:function(c){return c.is(d)
}}else{b.widget.prototype._setData.apply(this,arguments)}},_activate:function(d){var a=b.ui.ddmanager.current;
if(this.options.activeClass){this.element.addClass(this.options.activeClass)}(a&&this._trigger("activate",d,this.ui(a)))
},_deactivate:function(d){var a=b.ui.ddmanager.current;if(this.options.activeClass){this.element.removeClass(this.options.activeClass)
}(a&&this._trigger("deactivate",d,this.ui(a)))},_over:function(d){var a=b.ui.ddmanager.current;if(!a||(a.currentItem||a.element)[0]==this.element[0]){return
}if(this.options.accept.call(this.element[0],(a.currentItem||a.element))){if(this.options.hoverClass){this.element.addClass(this.options.hoverClass)
}this._trigger("over",d,this.ui(a))}},_out:function(d){var a=b.ui.ddmanager.current;if(!a||(a.currentItem||a.element)[0]==this.element[0]){return
}if(this.options.accept.call(this.element[0],(a.currentItem||a.element))){if(this.options.hoverClass){this.element.removeClass(this.options.hoverClass)
}this._trigger("out",d,this.ui(a))}},_drop:function(h,g){var a=g||b.ui.ddmanager.current;if(!a||(a.currentItem||a.element)[0]==this.element[0]){return false
}var f=false;this.element.find(":data(droppable)").not(".ui-draggable-dragging").each(function(){var c=b.data(this,"droppable");
if(c.options.greedy&&b.ui.intersect(a,b.extend(c,{offset:c.element.offset()}),c.options.tolerance)){f=true;
return false}});if(f){return false}if(this.options.accept.call(this.element[0],(a.currentItem||a.element))){if(this.options.activeClass){this.element.removeClass(this.options.activeClass)
}if(this.options.hoverClass){this.element.removeClass(this.options.hoverClass)}this._trigger("drop",h,this.ui(a));
return this.element}return false},ui:function(a){return{draggable:(a.currentItem||a.element),helper:a.helper,position:a.position,absolutePosition:a.positionAbs,offset:a.positionAbs}
}});b.extend(b.ui.droppable,{version:"1.7.2",eventPrefix:"drop",defaults:{accept:"*",activeClass:false,addClasses:true,greedy:false,hoverClass:false,scope:"default",tolerance:"intersect"}});
b.ui.intersect=function(a,v,r){if(!v.offset){return false}var B=(a.positionAbs||a.position.absolute).left,C=B+a.helperProportions.width,s=(a.positionAbs||a.position.absolute).top,t=s+a.helperProportions.height;
var z=v.offset.left,D=z+v.proportions.width,l=v.offset.top,u=l+v.proportions.height;switch(r){case"fit":return(z<B&&C<D&&l<s&&t<u);
break;case"intersect":return(z<B+(a.helperProportions.width/2)&&C-(a.helperProportions.width/2)<D&&l<s+(a.helperProportions.height/2)&&t-(a.helperProportions.height/2)<u);
break;case"pointer":var y=((a.positionAbs||a.position.absolute).left+(a.clickOffset||a.offset.click).left),w=((a.positionAbs||a.position.absolute).top+(a.clickOffset||a.offset.click).top),A=b.ui.isOver(w,y,l,z,v.proportions.height,v.proportions.width);
return A;break;case"touch":return((s>=l&&s<=u)||(t>=l&&t<=u)||(s<l&&t>u))&&((B>=z&&B<=D)||(C>=z&&C<=D)||(B<z&&C>D));
break;default:return false;break}};b.ui.ddmanager={current:null,droppables:{"default":[]},prepareOffsets:function(l,j){var a=b.ui.ddmanager.droppables[l.options.scope];
var k=j?j.type:null;var i=(l.currentItem||l.element).find(":data(droppable)").andSelf();droppablesLoop:for(var m=0;
m<a.length;m++){if(a[m].options.disabled||(l&&!a[m].options.accept.call(a[m].element[0],(l.currentItem||l.element)))){continue
}for(var n=0;n<i.length;n++){if(i[n]==a[m].element[0]){a[m].proportions.height=0;continue droppablesLoop
}}a[m].visible=a[m].element.css("display")!="none";if(!a[m].visible){continue}a[m].offset=a[m].element.offset();
a[m].proportions={width:a[m].element[0].offsetWidth,height:a[m].element[0].offsetHeight};if(k=="mousedown"){a[m]._activate.call(a[m],j)
}}},drop:function(a,f){var e=false;b.each(b.ui.ddmanager.droppables[a.options.scope],function(){if(!this.options){return
}if(!this.options.disabled&&this.visible&&b.ui.intersect(a,this,this.options.tolerance)){e=this._drop.call(this,f)
}if(!this.options.disabled&&this.visible&&this.options.accept.call(this.element[0],(a.currentItem||a.element))){this.isout=1;
this.isover=0;this._deactivate.call(this,f)}});return e},drag:function(a,d){if(a.options.refreshPositions){b.ui.ddmanager.prepareOffsets(a,d)
}b.each(b.ui.ddmanager.droppables[a.options.scope],function(){if(this.options.disabled||this.greedyChild||!this.visible){return
}var i=b.ui.intersect(a,this,this.options.tolerance);var c=!i&&this.isover==1?"isout":(i&&this.isover==0?"isover":null);
if(!c){return}var h;if(this.options.greedy){var j=this.element.parents(":data(droppable):eq(0)");if(j.length){h=b.data(j[0],"droppable");
h.greedyChild=(c=="isover"?1:0)}}if(h&&c=="isover"){h.isover=0;h.isout=1;h._out.call(h,d)}this[c]=1;this[c=="isout"?"isover":"isout"]=0;
this[c=="isover"?"_over":"_out"].call(this,d);if(h&&c=="isout"){h.isout=0;h.isover=1;h._over.call(h,d)
}})}}})(jQuery);(jQuery.ui&&jQuery.ui.resizable)||(function(f){f.widget("ui.resizable",f.extend({},f.ui.mouse,{_init:function(){var m=this,b=this.options;
this.element.addClass("ui-resizable");f.extend(this,{_aspectRatio:!!(b.aspectRatio),aspectRatio:b.aspectRatio,originalElement:this.element,_proportionallyResizeElements:[],_helper:b.helper||b.ghost||b.animate?b.helper||"ui-resizable-helper":null});
if(this.element[0].nodeName.match(/canvas|textarea|input|select|button|img/i)){if(/relative/.test(this.element.css("position"))&&f.browser.opera){this.element.css({position:"relative",top:"auto",left:"auto"})
}this.element.wrap(f('<div class="ui-wrapper" style="overflow: hidden;"></div>').css({position:this.element.css("position"),width:this.element.outerWidth(),height:this.element.outerHeight(),top:this.element.css("top"),left:this.element.css("left")}));
this.element=this.element.parent().data("resizable",this.element.data("resizable"));this.elementIsWrapper=true;
this.element.css({marginLeft:this.originalElement.css("marginLeft"),marginTop:this.originalElement.css("marginTop"),marginRight:this.originalElement.css("marginRight"),marginBottom:this.originalElement.css("marginBottom")});
this.originalElement.css({marginLeft:0,marginTop:0,marginRight:0,marginBottom:0});this.originalResizeStyle=this.originalElement.css("resize");
this.originalElement.css("resize","none");this._proportionallyResizeElements.push(this.originalElement.css({position:"static",zoom:1,display:"block"}));
this.originalElement.css({margin:this.originalElement.css("margin")});this._proportionallyResize()}this.handles=b.handles||(!f(".ui-resizable-handle",this.element).length?"e,s,se":{n:".ui-resizable-n",e:".ui-resizable-e",s:".ui-resizable-s",w:".ui-resizable-w",se:".ui-resizable-se",sw:".ui-resizable-sw",ne:".ui-resizable-ne",nw:".ui-resizable-nw"});
if(this.handles.constructor==String){if(this.handles=="all"){this.handles="n,e,s,w,se,sw,ne,nw"}var a=this.handles.split(",");
this.handles={};for(var l=0;l<a.length;l++){var c=f.trim(a[l]),n="ui-resizable-"+c;var i=f('<div class="ui-resizable-handle '+n+'"></div>');
if(/sw|se|ne|nw/.test(c)){i.css({zIndex:++b.zIndex})}if("se"==c){i.addClass("ui-icon ui-icon-gripsmall-diagonal-se")
}this.handles[c]=".ui-resizable-"+c;this.element.append(i)}}this._renderAxis=function(j){j=j||this.element;
for(var g in this.handles){if(this.handles[g].constructor==String){this.handles[g]=f(this.handles[g],this.element).show()
}if(this.elementIsWrapper&&this.originalElement[0].nodeName.match(/textarea|input|select|button/i)){var q=f(this.handles[g],this.element),k=0;
k=/sw|ne|nw|se|n|s/.test(g)?q.outerHeight():q.outerWidth();var h=["padding",/ne|nw|n/.test(g)?"Top":/se|sw|s/.test(g)?"Bottom":/^e$/.test(g)?"Right":"Left"].join("");
j.css(h,k);this._proportionallyResize()}if(!f(this.handles[g]).length){continue}}};this._renderAxis(this.element);
this._handles=f(".ui-resizable-handle",this.element).disableSelection();this._handles.mouseover(function(){if(!m.resizing){if(this.className){var g=this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i)
}m.axis=g&&g[1]?g[1]:"se"}});if(b.autoHide){this._handles.hide();f(this.element).addClass("ui-resizable-autohide").hover(function(){f(this).removeClass("ui-resizable-autohide");
m._handles.show()},function(){if(!m.resizing){f(this).addClass("ui-resizable-autohide");m._handles.hide()
}})}this._mouseInit()},destroy:function(){this._mouseDestroy();var b=function(c){f(c).removeClass("ui-resizable ui-resizable-disabled ui-resizable-resizing").removeData("resizable").unbind(".resizable").find(".ui-resizable-handle").remove()
};if(this.elementIsWrapper){b(this.element);var a=this.element;a.parent().append(this.originalElement.css({position:a.css("position"),width:a.outerWidth(),height:a.outerHeight(),top:a.css("top"),left:a.css("left")})).end().remove()
}this.originalElement.css("resize",this.originalResizeStyle);b(this.originalElement)},_mouseCapture:function(b){var a=false;
for(var c in this.handles){if(f(this.handles[c])[0]==b.target){a=true}}return this.options.disabled||!!a
},_mouseStart:function(l){var b=this.options,m=this.element.position(),n=this.element;this.resizing=true;
this.documentScroll={top:f(document).scrollTop(),left:f(document).scrollLeft()};if(n.is(".ui-draggable")||(/absolute/).test(n.css("position"))){n.css({position:"absolute",top:m.top,left:m.left})
}if(f.browser.opera&&(/relative/).test(n.css("position"))){n.css({position:"relative",top:"auto",left:"auto"})
}this._renderProxy();var a=d(this.helper.css("left")),k=d(this.helper.css("top"));if(b.containment){a+=f(b.containment).scrollLeft()||0;
k+=f(b.containment).scrollTop()||0}this.offset=this.helper.offset();this.position={left:a,top:k};this.size=this._helper?{width:n.outerWidth(),height:n.outerHeight()}:{width:n.width(),height:n.height()};
this.originalSize=this._helper?{width:n.outerWidth(),height:n.outerHeight()}:{width:n.width(),height:n.height()};
this.originalPosition={left:a,top:k};this.sizeDiff={width:n.outerWidth()-n.width(),height:n.outerHeight()-n.height()};
this.originalMousePosition={left:l.pageX,top:l.pageY};this.aspectRatio=(typeof b.aspectRatio=="number")?b.aspectRatio:((this.originalSize.width/this.originalSize.height)||1);
var c=f(".ui-resizable-"+this.axis).css("cursor");f("body").css("cursor",c=="auto"?this.axis+"-resize":c);
n.addClass("ui-resizable-resizing");this._propagate("start",l);return true},_mouseDrag:function(A){var w=this.helper,y=this.options,r={},b=this,u=this.originalMousePosition,o=this.axis;
var a=(A.pageX-u.left)||0,c=(A.pageY-u.top)||0;var v=this._change[o];if(!v){return false}var s=v.apply(this,[A,a,c]),t=f.browser.msie&&f.browser.version<7,z=this.sizeDiff;
if(this._aspectRatio||A.shiftKey){s=this._updateRatio(s,A)}s=this._respectSize(s,A);this._propagate("resize",A);
w.css({top:this.position.top+"px",left:this.position.left+"px",width:this.size.width+"px",height:this.size.height+"px"});
if(!this._helper&&this._proportionallyResizeElements.length){this._proportionallyResize()}this._updateCache(s);
this._trigger("resize",A,this.ui());return false},_mouseStop:function(q){this.resizing=false;var p=this.options,b=this;
if(this._helper){var r=this._proportionallyResizeElements,t=r.length&&(/textarea/i).test(r[0].nodeName),s=t&&f.ui.hasScroll(r[0],"left")?0:b.sizeDiff.height,n=t?0:b.sizeDiff.width;
var a={width:(b.size.width-n),height:(b.size.height-s)},o=(parseInt(b.element.css("left"),10)+(b.position.left-b.originalPosition.left))||null,c=(parseInt(b.element.css("top"),10)+(b.position.top-b.originalPosition.top))||null;
if(!p.animate){this.element.css(f.extend(a,{top:c,left:o}))}b.helper.height(b.size.height);b.helper.width(b.size.width);
if(this._helper&&!p.animate){this._proportionallyResize()}}f("body").css("cursor","auto");this.element.removeClass("ui-resizable-resizing");
this._propagate("stop",q);if(this._helper){this.helper.remove()}return false},_updateCache:function(b){var a=this.options;
this.offset=this.helper.offset();if(e(b.left)){this.position.left=b.left}if(e(b.top)){this.position.top=b.top
}if(e(b.height)){this.size.height=b.height}if(e(b.width)){this.size.width=b.width}},_updateRatio:function(c,j){var b=this.options,a=this.position,k=this.size,l=this.axis;
if(c.height){c.width=(k.height*this.aspectRatio)}else{if(c.width){c.height=(k.width/this.aspectRatio)
}}if(l=="sw"){c.left=a.left+(k.width-c.width);c.top=null}if(l=="nw"){c.top=a.top+(k.height-c.height);
c.left=a.left+(k.width-c.width)}return c},_respectSize:function(v,B){var y=this.helper,z=this.options,b=this._aspectRatio||B.shiftKey,c=this.axis,E=e(v.width)&&z.maxWidth&&(z.maxWidth<v.width),u=e(v.height)&&z.maxHeight&&(z.maxHeight<v.height),A=e(v.width)&&z.minWidth&&(z.minWidth>v.width),a=e(v.height)&&z.minHeight&&(z.minHeight>v.height);
if(A){v.width=z.minWidth}if(a){v.height=z.minHeight}if(E){v.width=z.maxWidth}if(u){v.height=z.maxHeight
}var C=this.originalPosition.left+this.originalSize.width,o=this.position.top+this.size.height;var w=/sw|nw|w/.test(c),D=/nw|ne|n/.test(c);
if(A&&w){v.left=C-z.minWidth}if(E&&w){v.left=C-z.maxWidth}if(a&&D){v.top=o-z.minHeight}if(u&&D){v.top=o-z.maxHeight
}var t=!v.width&&!v.height;if(t&&!v.left&&v.top){v.top=null}else{if(t&&!v.top&&v.left){v.left=null}}return v
},_proportionallyResize:function(){var a=this.options;if(!this._proportionallyResizeElements.length){return
}var i=this.helper||this.element;for(var k=0;k<this._proportionallyResizeElements.length;k++){var c=this._proportionallyResizeElements[k];
if(!this.borderDif){var l=[c.css("borderTopWidth"),c.css("borderRightWidth"),c.css("borderBottomWidth"),c.css("borderLeftWidth")],b=[c.css("paddingTop"),c.css("paddingRight"),c.css("paddingBottom"),c.css("paddingLeft")];
this.borderDif=f.map(l,function(j,g){var h=parseInt(j,10)||0,o=parseInt(b[g],10)||0;return h+o})}if(f.browser.msie&&!(!(f(i).is(":hidden")||f(i).parents(":hidden").length))){continue
}c.css({height:(i.height()-this.borderDif[0]-this.borderDif[2])||0,width:(i.width()-this.borderDif[1]-this.borderDif[3])||0})
}},_renderProxy:function(){var i=this.element,a=this.options;this.elementOffset=i.offset();if(this._helper){this.helper=this.helper||f('<div style="overflow:hidden;"></div>');
var j=f.browser.msie&&f.browser.version<7,c=(j?1:0),b=(j?2:-1);this.helper.addClass(this._helper).css({width:this.element.outerWidth()+b,height:this.element.outerHeight()+b,position:"absolute",left:this.elementOffset.left-c+"px",top:this.elementOffset.top-c+"px",zIndex:++a.zIndex});
this.helper.appendTo("body").disableSelection()}else{this.helper=this.element}},_change:{e:function(a,b,c){return{width:this.originalSize.width+b}
},w:function(c,k,l){var a=this.options,j=this.originalSize,b=this.originalPosition;return{left:b.left+k,width:j.width-k}
},n:function(c,k,l){var a=this.options,j=this.originalSize,b=this.originalPosition;return{top:b.top+l,height:j.height-l}
},s:function(a,b,c){return{height:this.originalSize.height+c}},se:function(a,b,c){return f.extend(this._change.s.apply(this,arguments),this._change.e.apply(this,[a,b,c]))
},sw:function(a,b,c){return f.extend(this._change.s.apply(this,arguments),this._change.w.apply(this,[a,b,c]))
},ne:function(a,b,c){return f.extend(this._change.n.apply(this,arguments),this._change.e.apply(this,[a,b,c]))
},nw:function(a,b,c){return f.extend(this._change.n.apply(this,arguments),this._change.w.apply(this,[a,b,c]))
}},_propagate:function(a,b){f.ui.plugin.call(this,a,[b,this.ui()]);(a!="resize"&&this._trigger(a,b,this.ui()))
},plugins:{},ui:function(){return{originalElement:this.originalElement,element:this.element,helper:this.helper,position:this.position,size:this.size,originalSize:this.originalSize,originalPosition:this.originalPosition}
}}));f.extend(f.ui.resizable,{version:"1.7.2",eventPrefix:"resize",defaults:{alsoResize:false,animate:false,animateDuration:"slow",animateEasing:"swing",aspectRatio:false,autoHide:false,cancel:":input,option",containment:false,delay:0,distance:1,ghost:false,grid:false,handles:"e,s,se",helper:false,maxHeight:null,maxWidth:null,minHeight:10,minWidth:10,zIndex:1000}});
f.ui.plugin.add("resizable","alsoResize",{start:function(c,b){var h=f(this).data("resizable"),a=h.options;
_store=function(g){f(g).each(function(){f(this).data("resizable-alsoresize",{width:parseInt(f(this).width(),10),height:parseInt(f(this).height(),10),left:parseInt(f(this).css("left"),10),top:parseInt(f(this).css("top"),10)})
})};if(typeof(a.alsoResize)=="object"&&!a.alsoResize.parentNode){if(a.alsoResize.length){a.alsoResize=a.alsoResize[0];
_store(a.alsoResize)}else{f.each(a.alsoResize,function(j,g){_store(j)})}}else{_store(a.alsoResize)}},resize:function(n,l){var o=f(this).data("resizable"),c=o.options,m=o.originalSize,a=o.originalPosition;
var b={height:(o.size.height-m.height)||0,width:(o.size.width-m.width)||0,top:(o.position.top-a.top)||0,left:(o.position.left-a.left)||0},p=function(h,g){f(h).each(function(){var j=f(this),i=f(this).data("resizable-alsoresize"),k={},r=g&&g.length?g:["width","height","top","left"];
f.each(r||["width","height","top","left"],function(v,q){var u=(i[q]||0)+(b[q]||0);if(u&&u>=0){k[q]=u||null
}});if(/relative/.test(j.css("position"))&&f.browser.opera){o._revertToRelativePosition=true;j.css({position:"absolute",top:"auto",left:"auto"})
}j.css(k)})};if(typeof(c.alsoResize)=="object"&&!c.alsoResize.nodeType){f.each(c.alsoResize,function(h,g){p(h,g)
})}else{p(c.alsoResize)}},stop:function(b,a){var c=f(this).data("resizable");if(c._revertToRelativePosition&&f.browser.opera){c._revertToRelativePosition=false;
el.css({position:"relative"})}f(this).removeData("resizable-alsoresize-start")}});f.ui.plugin.add("resizable","animate",{stop:function(r,b){var a=f(this).data("resizable"),q=a.options;
var s=a._proportionallyResizeElements,v=s.length&&(/textarea/i).test(s[0].nodeName),u=v&&f.ui.hasScroll(s[0],"left")?0:a.sizeDiff.height,o=v?0:a.sizeDiff.width;
var t={width:(a.size.width-o),height:(a.size.height-u)},p=(parseInt(a.element.css("left"),10)+(a.position.left-a.originalPosition.left))||null,c=(parseInt(a.element.css("top"),10)+(a.position.top-a.originalPosition.top))||null;
a.element.animate(f.extend(t,c&&p?{top:c,left:p}:{}),{duration:q.animateDuration,easing:q.animateEasing,step:function(){var g={width:parseInt(a.element.css("width"),10),height:parseInt(a.element.css("height"),10),top:parseInt(a.element.css("top"),10),left:parseInt(a.element.css("left"),10)};
if(s&&s.length){f(s[0]).css({width:g.width,height:g.height})}a._updateCache(g);a._propagate("resize",r)
}})}});f.ui.plugin.add("resizable","containment",{start:function(A,b){var C=f(this).data("resizable"),v=C.options,t=C.element;
var z=v.containment,u=(z instanceof f)?z.get(0):(/parent/.test(z))?t.parent().get(0):z;if(!u){return}C.containerElement=f(u);
if(/document/.test(z)||z==document){C.containerOffset={left:0,top:0};C.containerPosition={left:0,top:0};
C.parentData={element:f(document),left:0,top:0,width:f(document).width(),height:f(document).height()||document.body.parentNode.scrollHeight}
}else{var o=f(u),w=[];f(["Top","Right","Left","Bottom"]).each(function(g,h){w[g]=d(o.css("padding"+h))
});C.containerOffset=o.offset();C.containerPosition=o.position();C.containerSize={height:(o.innerHeight()-w[3]),width:(o.innerWidth()-w[1])};
var c=C.containerOffset,B=C.containerSize.height,p=C.containerSize.width,y=(f.ui.hasScroll(u,"left")?u.scrollWidth:p),a=(f.ui.hasScroll(u)?u.scrollHeight:B);
C.parentData={element:u,left:c.left,top:c.top,width:y,height:a}}},resize:function(B,c){var E=f(this).data("resizable"),z=E.options,C=E.containerSize,o=E.containerOffset,u=E.size,t=E.position,b=E._aspectRatio||B.shiftKey,D={top:0,left:0},A=E.containerElement;
if(A[0]!=document&&(/static/).test(A.css("position"))){D=o}if(t.left<(E._helper?o.left:0)){E.size.width=E.size.width+(E._helper?(E.position.left-o.left):(E.position.left-D.left));
if(b){E.size.height=E.size.width/z.aspectRatio}E.position.left=z.helper?o.left:0}if(t.top<(E._helper?o.top:0)){E.size.height=E.size.height+(E._helper?(E.position.top-o.top):E.position.top);
if(b){E.size.width=E.size.height*z.aspectRatio}E.position.top=E._helper?o.top:0}E.offset.left=E.parentData.left+E.position.left;
E.offset.top=E.parentData.top+E.position.top;var v=Math.abs((E._helper?E.offset.left-D.left:(E.offset.left-D.left))+E.sizeDiff.width),a=Math.abs((E._helper?E.offset.top-D.top:(E.offset.top-o.top))+E.sizeDiff.height);
var w=E.containerElement.get(0)==E.element.parent().get(0),y=/relative|absolute/.test(E.containerElement.css("position"));
if(w&&y){v-=E.parentData.left}if(v+E.size.width>=E.parentData.width){E.size.width=E.parentData.width-v;
if(b){E.size.height=E.size.width/E.aspectRatio}}if(a+E.size.height>=E.parentData.height){E.size.height=E.parentData.height-a;
if(b){E.size.width=E.size.height*E.aspectRatio}}},stop:function(w,h){var b=f(this).data("resizable"),v=b.options,r=b.position,o=b.containerOffset,y=b.containerPosition,u=b.containerElement;
var t=f(b.helper),a=t.offset(),c=t.outerWidth()-b.sizeDiff.width,s=t.outerHeight()-b.sizeDiff.height;
if(b._helper&&!v.animate&&(/relative/).test(u.css("position"))){f(this).css({left:a.left-y.left-o.left,width:c,height:s})
}if(b._helper&&!v.animate&&(/static/).test(u.css("position"))){f(this).css({left:a.left-y.left-o.left,width:c,height:s})
}}});f.ui.plugin.add("resizable","ghost",{start:function(c,b){var j=f(this).data("resizable"),a=j.options,i=j.size;
j.ghost=j.originalElement.clone();j.ghost.css({opacity:0.25,display:"block",position:"relative",height:i.height,width:i.width,margin:0,left:0,top:0}).addClass("ui-resizable-ghost").addClass(typeof a.ghost=="string"?a.ghost:"");
j.ghost.appendTo(j.helper)},resize:function(c,b){var h=f(this).data("resizable"),a=h.options;if(h.ghost){h.ghost.css({position:"relative",height:h.size.height,width:h.size.width})
}},stop:function(c,b){var h=f(this).data("resizable"),a=h.options;if(h.ghost&&h.helper){h.helper.get(0).removeChild(h.ghost.get(0))
}}});f.ui.plugin.add("resizable","grid",{resize:function(v,c){var a=f(this).data("resizable"),s=a.options,p=a.size,r=a.originalSize,q=a.originalPosition,b=a.axis,o=s._aspectRatio||v.shiftKey;
s.grid=typeof s.grid=="number"?[s.grid,s.grid]:s.grid;var t=Math.round((p.width-r.width)/(s.grid[0]||1))*(s.grid[0]||1),u=Math.round((p.height-r.height)/(s.grid[1]||1))*(s.grid[1]||1);
if(/^(se|s|e)$/.test(b)){a.size.width=r.width+t;a.size.height=r.height+u}else{if(/^(ne)$/.test(b)){a.size.width=r.width+t;
a.size.height=r.height+u;a.position.top=q.top-u}else{if(/^(sw)$/.test(b)){a.size.width=r.width+t;a.size.height=r.height+u;
a.position.left=q.left-t}else{a.size.width=r.width+t;a.size.height=r.height+u;a.position.top=q.top-u;
a.position.left=q.left-t}}}}});var d=function(a){return parseInt(a,10)||0};var e=function(a){return !isNaN(parseInt(a,10))
}})(jQuery);(function(Z,ac){function aa(){}function I(a){ab=[a]}function R(a){Y.insertBefore(a,Y.firstChild)
}function S(a,c,b){return a&&a.apply(c.context||c,b)}function T(a){return/\?/.test(a)?"&":"?"}var Q="async",J="charset",M="",N="error",K="_jqjsp",F="on",P=F+"click",O=F+N,ad=F+"load",V=F+"readystatechange",C="removeChild",X="<script/>",G="success",D="timeout",E=Z.browser,Y=Z("head")[0]||document.documentElement,H={},U=0,ab,W={callback:K,url:location.href};
function L(b){b=Z.extend({},W,b);var d=b.complete,p=b.dataFilter,h=b.callbackParameter,c=b.callback,n=b.cache,k=b.pageCache,l=b.charset,a=b.url,i=b.data,e=b.timeout,f,j=0,m=aa;
b.abort=function(){!j++&&m()};if(S(b.beforeSend,b,[b])===false||j){return b}a=a||M;i=i?((typeof i)=="string"?i:Z.param(i,b.traditional)):M;
a+=i?(T(a)+i):M;h&&(a+=T(a)+encodeURIComponent(h)+"=?");!n&&!k&&(a+=T(a)+"_"+(new Date()).getTime()+"=");
a=a.replace(/=\?(&|$)/,"="+c+"$1");function g(q){!j++&&ac(function(){m();k&&(H[a]={s:[q]});p&&(q=p.apply(b,[q]));
S(b.success,b,[q,G]);S(d,b,[b,G])},0)}function o(q){!j++&&ac(function(){m();k&&q!=D&&(H[a]=q);S(b.error,b,[b,q]);
S(d,b,[b,q])},0)}k&&(f=H[a])?(f.s?g(f.s[0]):o(f)):ac(function(s,t,r){if(!j){r=e>0&&ac(function(){o(D)
},e);m=function(){r&&clearTimeout(r);s[V]=s[P]=s[ad]=s[O]=null;Y[C](s);t&&Y[C](t)};window[c]=I;s=Z(X)[0];
s.id=K+U++;if(l){s[J]=l}function q(u){(s[P]||aa)();u=ab;ab=undefined;u?g(u[0]):o(N)}if(E.msie){s.event=P;
s.htmlFor=s.id;s[V]=function(){/loaded|complete/.test(s.readyState)&&q()}}else{s[O]=s[ad]=q;E.opera?((t=Z(X)[0]).text="jQuery('#"+s.id+"')[0]."+O+"()"):s[Q]=Q
}s.src=a;R(s);t&&R(t)}},0);return b}L.setup=function(a){Z.extend(W,a)};Z.jsonp=L})(jQuery,setTimeout);
apsinth.msg.main_MessageDialog={close:"Close",save:"Save",cancel:"Cancel",abort:"No",discard:"Discard",reset:"Reset",ok:"OK"};
apsinth.msg.main_Error={requestError:"An error has occurred. Please try again later."};apsinth.lang="en_US";
var AjaxUtil=Klazz.extend({errorHandler:null,initialize:function(a){this.errorHandler=a},postRequest:function(a,c,d,b){this._executeRequest(true,a,c,this._handleAjaxSuccess,this._handleAjaxError,d,b)
},getRequest:function(a,c,d,b){this._executeRequest(false,a,c,this._handleAjaxSuccess,this._handleAjaxError,d,b)
},rpcRequest:function(b,g,e,f,c,a){var d={jsonrpc:"2.0",method:g,params:e,id:AjaxUtil.requestId++};this._executeRequest(true,b,d,this._handleAjaxRpcSuccess,this._handleAjaxError,f,c,a)
},evalJSON:function(text){try{return eval("("+text+")")}catch(exc){throw new Error("Parsing JSON failed - "+exc+"\n[[START]]"+text+"[[END]]")
}},_escape_unicode:function(a){a=a.replace(/\u0080/g,"&euro;");return a},_executeRequest:function(b,c,g,e,i,l,m,d){if(m){l=l.bind(m)
}var f=apsinth.util.ErrorUtil.wrap(e,this).curry(l);var h=apsinth.util.ErrorUtil.wrap(i,this).curry(l);
var k=null;var a=null;if(b){var j=jQuery.toJSON(g);j=j.replace("#","\\u0023","g");j=encodeURIComponent(j);
a="post";k=j}else{a="get";k=g}jQuery.ajax({url:c,type:a,data:k,beforeSend:function(){},success:f,error:h})
},_handleResponse:function(d,b,c){try{if(b.html){b.html=this._escape_unicode(b.html)}d(b,c);if(c&&!c.handled){this._handleError(c)
}}catch(a){if(this.errorHandler){this.errorHandler(a)}}},_handleError:function(a){if(this.errorHandler){this.errorHandler(a)
}else{if(console){console.log(a)}}},_handleAjaxSuccess:function(e,d){if(e){var b;var c=null;try{b=this.evalJSON(d);
if(b.status!="OK"){c={httpCode:d.status,errors:b.errors,exception:b.exception,handled:false}}}catch(a){c={httpCode:d.status,errors:["Parsing JSON response from '"+d.url+"' failed:\n"+d,a],handled:false}
}this._handleResponse(e,b,c)}},_handleAjaxRpcSuccess:function(h,g){if(h){var c;var d=null;var b=null;
try{c=this.evalJSON(g);b=c.result;if((c.error&&c.error!="null")||(c.result instanceof Array&&c.result.status&&c.result.status!="OK")){var e=(c.error.data&&c.error.data.exception)?c.error.data.exception:null;
var f=(c.error&&c.error.message)?c.error.message:null;b=c;d={httpCode:g.status,errors:[f],exception:e,handled:false}
}}catch(a){d={httpCode:g.status,errors:["Parsing JSON response from '"+g.url+"' failed:\n"+g,a],handled:false}
}this._handleResponse(h,b,d)}},_handleAjaxError:function(c,b){if(c){var a={httpCode:b.status,errors:[b.statusText],handled:false};
this._handleResponse(c,null,a)}}});AjaxUtil.requestId=0;apsinth.util.EventingMixin={mixin:function(a){if(a._lstMap==null){a._lstMap={};
a.bind=this._onBind;a.unbind=this._onUnbind;a.trigger=this._onTrigger;a.toHandler=this.toHandler}},toHandler:function(b,a){if(a==null){a=this
}return function(d){try{if(d!=null&&d.target!=null&&d.originalEvent!=null&&d.currentTarget==null){d.currentTarget=this
}b.apply(a,arguments)}catch(c){apsinth.util.ErrorUtil.onError("Calling handler failed",c)}}},_onBind:function(c,b,a,d){if(c==null){throw new Error("type is null")
}if(b==null){throw new Error("handler is null")}var e=this._lstMap[c];if(e==null){e=this._lstMap[c]=[]
}e.push({handler:b,scope:a,data:d})},_onUnbind:function(f,e,d,g){var h=this._lstMap[f];var a=false;if(h!=null){for(var b=0;
b<h.length;b++){var c=h[b];if(c.handler==e&&c.scope==d&&c.data==g){h.splice(b,1);a=true;break}}}if(!a&&window.console){console.warn("Unbinding handler for "+f+" failed. Handler not found:",e)
}},_onTrigger:function(e,b){var f=this._lstMap[e];if(f!=null){for(var c=0;c<f.length;c++){var d=f[c];
try{d.handler.call(d.scope,b,d.data)}catch(a){apsinth.util.ErrorUtil.onError("Calling "+e+" handler failed",a)
}}}}};apsinth.util.Blocker=function(a){this._options=jQuery.extend({},this._defaultOptions,a)};var clazz=apsinth.util.Blocker;
var proto=clazz.prototype;proto._defaultOptions={visible:false,zIndex:1,onClick:null};proto.show=function(){this.flashContentPrepare();
var b=this._options;if(this._blockerJQ==null){this._blockerJQ=jQuery(document.createElement("div"));jQuery(document.body).append(this._blockerJQ);
this._blockerJQ.addClass("apsinth-blocker").css({zIndex:b.zIndex});if(b.onClick){this._blockerJQ.click(b.onClick)
}}var a;a=apsinth.util.DomUtil.getViewRect();if(apsinth.util.Browser.isIe6){this._positionBlockerPane(a);
jQuery(window).bind("resize scroll",this._getWindowResizeScrollHandler())}if(b.visible){this._blockerJQ.fadeTo(0,0).addClass("apsinth-blocker-visible").fadeTo("normal",0.2)
}else{this._blockerJQ.show()}this._showIe6Iframe(this._blockerJQ,a)};proto.hide=function(){this.flashContentUnprepare();
if(this._blockerJQ){var b=this._options;if(b.visible){var a=this;this._blockerJQ.fadeOut("normal",function(){if(a._blockerJQ){a._blockerJQ.remove();
a._blockerJQ=null}if(a._iframeFixJQ){a._iframeFixJQ.remove();a._iframeFixJQ=null}})}else{this._blockerJQ.remove();
this._blockerJQ=null;if(this._iframeFixJQ){this._iframeFixJQ.remove();this._iframeFixJQ=null}}if(apsinth.util.Browser.isIe6){jQuery(window).unbind("resize scroll",this._getWindowResizeScrollHandler())
}}};proto._showIe6Iframe=function(b,a){if(!this._iframeFixJQ){this._iframeFixJQ=jQuery('<iframe src="javascript:\'<html></html>\'" style="filter:alpha(opacity=0.0);">');
this._iframeFixJQ.addClass("apsinth-blocker").hide();this._iframeFixJQ.css({zIndex:b.css("zIndex")-1});
if(apsinth.util.Browser.isIe6){this._iframeFixJQ.css({position:"absolute"})}}this._positionIe6Iframe(a);
b.before(this._iframeFixJQ);this._iframeFixJQ.show()};proto._positionIe6Iframe=function(a){this._positionElementJQ(this._iframeFixJQ,a)
};proto._positionBlockerPane=function(a){this._positionElementJQ(this._blockerJQ,a)};proto._positionElementJQ=function(b,a){if(b){if(apsinth.util.Browser.isIe6){b.css({width:a.width,height:a.height,top:a.y,left:a.x})
}else{b.css({width:a.width,height:a.height,top:0,left:0})}}};proto._getWindowResizeScrollHandler=function(){if(!this._windowResizeScrollHandler){var a=this;
this._windowResizeScrollHandler=function(){var b=apsinth.util.DomUtil.getViewRect();a._positionIe6Iframe(b);
a._positionBlockerPane(b)}}return this._windowResizeScrollHandler};proto.flashContentPrepare=function(){for(var e=document.embeds,d=0,c;
c=e[d];d++){c.setAttribute("wmode","transparent");var a=c.nextSibling,b=c.parentNode;b.removeChild(c);
b.insertBefore(c,a)}};proto.flashContentUnprepare=function(){for(var e=document.embeds,d=0,c;c=e[d];d++){var f=c.getAttribute("wmode");
c.removeAttribute("wmode");var a=c.nextSibling,b=c.parentNode;b.removeChild(c);if(f){c.setAttribute("wmode",f)
}b.insertBefore(c,a)}};apsinth.util.DomUtil={placeInView:function(d,c,b){if(b==null){b=this.getViewRect()
}var a=c.x+c.width;var e=c.y+c.height;if((b.x+b.width)<(a+d.width)&&b.x<=(c.x-d.width)){a=c.x-d.width
}if((b.y+b.height)<(e+d.height)&&b.y<=(c.y-d.height)){e=c.y-d.height}return{x:Math.round(a),y:Math.round(e),width:d.width,height:d.height}
},getViewRect:function(){var b=jQuery(window);var a={x:b.scrollLeft(),y:b.scrollTop()};if(document.documentElement){a.width=document.documentElement.clientWidth;
a.height=document.documentElement.clientHeight}else{var c=jQuery(document.body);a.width=c.innerWidth();
a.height=c.innerHeight()}return a}};apsinth.util.ErrorUtil={onError:function(){var h="";for(var c=0;c<arguments.length;
c++){var a=arguments[c];var b=null;if(a instanceof Error){b=a.toString()+"\n"+this.getStackTraceFromError(a).join("\n")
}else{if(typeof a=="string"){b=a.trim()}else{if(typeof a=="object"){b="";if(a.message){b+=a.message}else{if(a.errors&&a.errors.length>0){b+=a.errors.join("\n")
}}if(a.exception||(a.httpCode&&a.httpCode!=200)){b+="\n(See console for details)";if(console&&console.log){if(a.httpCode&&a.httpCode!=200){console.log("HTTP Code:"+a.httpCode)
}if(a.exception){console.log(a.exception)}}}}else{if(a){if(console&&console.log){console.log(a)}}}}}if(h.length>0&&b){h+="\n"
}if(b){h+=b}}if(!apsinth.debug){h=apsinth.msg.main_Error.requestError}else{if(h.length==0){h="Error during request, see console"
}}var d=(jQuery)?jQuery:(top.jQuery?top.jQuery:false);var g=function(e){if(console&&console.log){console.log(e)
}};try{if(d&&d(top.window).humanMsg){d(top.window).humanMsg(h.replace(/\n/gm,"<br/>"))}else{g(h)}}catch(f){g(h)
}},getStackTraceFromError:function(c){var g=[];if(c.stack!=null){var e=/@(.+):(\d+)$/gm;var f;while((f=e.exec(c.stack))!=null){var b=f[1];
var a=f[2];var d=this.fileNameToClassName(b);g.push(d+":"+a)}}return g},fileNameToClassName:function(d){var c="/mod/";
var a=d.indexOf(c);var b=(a==-1)?d:d.substring(a+c.length).replace(/\//g,".").replace(/\.js$/,"");return b
},wrap:function(b,a){return function(){try{return b.apply(a||this,arguments)}catch(c){apsinth.util.ErrorUtil.onError(c)
}}}};apsinth.util.TextUtil={trim:function(a){return a.replace(/^\s+|\s+$/g,"")},escapeHTML:function(a){return a.replace(/<|>|&|"/gi,function(b){switch(b){case"<":return"&lt;";
case">":return"&gt;";case"&":return"&amp;";case'"':return"&quot;"}})},escapeRegexpChars:function(a){return a.replace(/([.*+?\^${}()|\[\]\/\\])/g,"\\$1")
}};apsinth.util.Layer=function(c,b){if(c==false){return}apsinth.util.EventingMixin.mixin(this);b=jQuery.extend({},this._defaultOptions,b);
this._usingUiDialog=b.usingUiDialog;if(c==null){c=jQuery(document.createElement("div"));this._autoCreatedMainJQ=true
}this._mainJQ=c;if(!this._usingUiDialog){var d=b.zIndex;if(d==null){d=b.isDialog?apsinth.util.Layer._zIndex.dialog:apsinth.util.Layer._zIndex.control
}c.css("z-index",d);var a={zIndex:d-1};if(b.visibleBlocker){a.visible=true;a.onClick=this.toHandler(this.shake)
}else{a.visible=false;a.onClick=this.toHandler(this.hide)}this._blocker=new apsinth.util.Blocker(a)}else{this._dlgClassName=b.dlgClassName||"diy_dialog";
this._dlg=c[this._dlgClassName](jQuery.extend({zIndex:d,modal:b.visibleBlocker,autoOpen:false,resizable:false},b.dlgOptions))
}};var clazz=apsinth.util.Layer;var proto=clazz.prototype;clazz._zIndex={dialog:110,control:210};proto._defaultOptions={visibleBlocker:true,isDialog:true,usingUiDialog:false,dlgOptions:null};
proto._active=false;proto.getContent=function(){return this._mainJQ};proto.isActive=function(){return this._active
};proto.showBelow=function(e,d,c,a){var b=(d?e.outerWidth():null);if(c){b+=c}var f=e.offset();this.show(jQuery.extend({x:f.left,y:f.top+e.outerHeight(),width:b},a))
};proto.showAbove=function(d,c,f,a){var b=(c?d.innerWidth():null);var e=d.offset();this.show(jQuery.extend({x:e.left,y:e.top,width:b+f},a))
};proto.showLeftOf=function(c,b,a){var d=c.offset();this.show({x:d.left+b,y:d.top+a,alignRight:true})
};proto.show=function(l){l=jQuery.extend({x:0,y:0,centerX:false,centerY:false,alignRight:false,winWidthMargin:50,winHeightMargin:50,width:null,height:null,addParentWidth:false,addParentHeight:false,addWinWidth:false,addWinHeight:false,effect:"slide",minWidth:0,reposition:false,zIndex:null},l);
if(!this._usingUiDialog){this._blocker.show();if(this._autoCreatedMainJQ){jQuery(document.body).append(this._mainJQ)
}else{if(!l.reposition){this._mainJQ.show()}}this._mainJQ.addClass("apsinth-dialog")}else{if(this._autoCreatedMainJQ){}else{if(!l.reposition){this._mainJQ[this._dlgClassName]("open")
}}}var c=(document.documentElement?document.documentElement.clientWidth:window.innerWidth);var d=(document.documentElement?document.documentElement.clientHeight:window.innerHeight);
var a=l.width;if(l.addParentWidth){a+=this._mainJQ.parent().width()}if(l.addWinWidth){a+=c-l.winWidthMargin
}if(a!=null){a=Math.max(a,l.minWidth)}var i=l.height;if(l.addParentHeight){i+=this._mainJQ.parent().height()
}if(l.addWinHeight){i+=d-l.winHeightMargin}var b=this._mainJQ.find("img.origImg").attr("complete");if(this._mainJQ.find("img.origImg").length>0&&!b){this.options=l;
var j=this;window.setTimeout(function(){j.show(j.options)},1000);return}var h=l.x;if(l.alignRight){h-=this._mainJQ.width()
}else{if(l.centerX){h+=(c-(a?a:this._mainJQ.width()))/2}}var g=l.y;if(l.centerY){g+=this.getScrollTop()+(d-(i?i:this._mainJQ.height()))/2
}var e=[Math.round(h)+"px",Math.round(g)+"px"];if(!this._usingUiDialog){this._mainJQ.css({left:e[0],top:e[1]})
}else{this._mainJQ[this._dlgClassName]("option","position",e)}var k={};if(a!=null){k.width=Math.round(a)+"px"
}if(i!=null){k.height=Math.round(i)+"px"}if(!this._usingUiDialog){this._mainJQ.css(k)}else{this._mainJQ[this._dlgClassName]("option",k)
}if(l.zIndex!==null){if(!this._usingUiDialog){this._mainJQ.css("zIndex",l.zIndex)}else{this._mainJQ[this._dlgClassName]("option","zIndex",l.zIndex)
}}var j=this;var f=function(){j._active=true};if(jQuery(document.body).hasClass("facebookTab")&&typeof FB!="undefined"&&typeof FB.Canvas!="undefined"&&typeof FB.Canvas.getPageInfo=="function"){var j=this;
FB.Canvas.getPageInfo(function(m){var n;if(l.centerY){g=l.y+m.scrollTop-m.offsetTop+(m.clientHeight-(i?i:j._mainJQ.height()))/2;
n=Math.round(g)+"px"}j._mainJQ.css("top",n);j.scrollIntoView();if(!j._usingUiDialog){if(l.effect=="slide"){j._mainJQ.slideUp(0).slideDown(undefined,f)
}else{if(l.effect=="fade"){j._mainJQ.fadeOut(0).fadeIn(undefined,f)}else{j._mainJQ.show();f()}}}else{j._mainJQ[this._dlgClassName]("open");
f()}jQuery(j).trigger("showLayer")});return}this.scrollIntoView();if(!this._usingUiDialog){if(l.effect=="slide"){this._mainJQ.slideUp(0).slideDown(undefined,f)
}else{if(l.effect=="fade"){this._mainJQ.fadeOut(0).fadeIn(undefined,f)}else{this._mainJQ.show();f()}}}else{this._mainJQ[this._dlgClassName]("open");
f()}jQuery(this).trigger("showLayer")};proto.scrollIntoView=function(){var f=this._mainJQ.offset().top;
var a=this._mainJQ.outerHeight();var c=this.getScrollTop();var b=window.document.body.clientHeight||window.innerHeight;
var e=10;var d=c;if(f+a+e>d+b){d=f+a+e-b}if(f-e<d){d=f-e}if(d!=c){window.scrollTo(0,d)}};proto.getScrollTop=function(){return window.pageYOffset||window.document.body.scrollTop||window.document.documentElement.scrollTop
};proto.hide=function(){this._active=false;var a=this;if(!this._usingUiDialog){this._blocker.hide();this._mainJQ.slideUp(undefined,jQuery.proxy(this.doHide,this))
}else{this.doHide()}jQuery(this).trigger("hideLayer")};proto.doHide=function(){if(this._autoCreatedMainJQ){this._mainJQ.remove()
}else{if(!this._usingUiDialog){this._mainJQ.hide()}else{this._mainJQ[this._dlgClassName]("close")}}};
proto.shake=function(){if(this._usingUiDialog){return}if(this._shaking){return}this.scrollIntoView();
var b=20;var d=100;var a=this;var c=function(){a._shaking=false};this._shaking=true;this._mainJQ.animate({left:"-="+b+"px"},d).animate({left:"+="+(2*b)+"px"},d).animate({left:"-="+(2*b)+"px"},d).animate({left:"+="+b+"px"},d,undefined,c)
};proto.destroy=function(){if(this._usingUiDialog){this._mainJQ.remove()}};apsinth.util.Tabs=function(d,a){a=a||".tabnav";
this.tabParentJQ=d;var c=this;var e=d.find(a+" li > a");var b=jQuery(e[0]).attr("href");this.selectedTab=b.substr(b.indexOf("#")+1);
e.click(function(f){f.preventDefault();e.each(function(){var i=jQuery(this);apsinth.util.Tabs.setButtonStyle(false,i,d);
c._paneForBtn(i).hide()});var k=jQuery(this);apsinth.util.Tabs.setButtonStyle(true,k,d);var g=c._paneForBtn(k).show();
var j=k.attr("href");c.selectedTab=j.substr(j.indexOf("#")+1);if(c._tabChangedLstArr){for(var h=0;h<c._tabChangedLstArr.length;
h++){c._tabChangedLstArr[h].listener.call(c._tabChangedLstArr[h].context,g)}}}).each(function(f){var g=jQuery(this);
if(f==0){apsinth.util.Tabs.setButtonStyle(true,g,d)}else{c._paneForBtn(g).hide()}})};var clazz=apsinth.util.Tabs;
var proto=clazz.prototype;clazz.setButtonStyle=function(b,d,c){var a=b?"1px solid "+c.css("backgroundColor"):"";
d.css({borderBottom:a})};proto._paneForBtn=function(b){var a=b.attr("href");return this.tabParentJQ.find("."+a.substr(a.indexOf("#")+1))
};proto.bindTabChanged=function(a,b){b=b||this;if(this._tabChangedLstArr==null){this._tabChangedLstArr=[]
}this._tabChangedLstArr.push({listener:a,context:b})};apsinth.util.Browser={isIe:/MSIE/i.test(navigator.userAgent),isIe6:/MSIE 6/i.test(navigator.userAgent)};
apsinth.ApsinthModule=Modul.extend({CONFIG_MIN_WIDTH:300,proxy:null,static_proxy:null,handler_proxy:null,view_proxy:null,configSaveHandler:"config",mainView:"main",data:null,data_admin:null,configIsOpen:false,appendError:false,errorTarget:"auto",fieldErrorsTarget:"auto",loadMainViewAfterSave:true,ajaxUtil:null,initialize:function(d,c,b,f){try{apsinth.util.EventingMixin.mixin(this);
this.instance_id=c;this.module_name=b;this.mode=f;this.internalContainerId="NGH"+d;this.idPrefix=this.internalContainerId;
var e=window["__NGHModuleInstanceData"+d];this.moduleServer=e.server;this.data=e.data_web;this.data_admin=e.data_admin;
this.proxy=(window.webserverProtocol&&(window.webserverProtocol=="https://")?sslServerUrl:"")+"/proxy";
this.static_proxy=this.proxy+"/static";this.handler_proxy=this.proxy+"/handler";this.view_proxy=this.proxy+"/view";
this._super(d);this.bind("open-config",this._setMinWidthStyles,this);this.bind("close-config",this._removeMinWidthStyles,this);
this.ajaxUtil=new AjaxUtil(this.toHandler(this.onError))}catch(a){apsinth.util.ErrorUtil.onError(a)}},initView_main:function(){(apsinth.util.ErrorUtil.wrap(this._initMainView,this))()
},initView_config:function(){(apsinth.util.ErrorUtil.wrap(this._initConfigView,this))();this._initDefaultInputValues()
},_initMainView:function(){},_initConfigView:function(){},getMainJQ:function(){return jQuery("#modul_"+this.moduleId+"_content")
},getConfigJQ:function(){return jQuery("#modul_"+this.moduleId+"_config")},getBasisId:function(){return window.script_basisID
},replaceInternalLinks:function(b){var a=new RegExp('href\\s*=\\s*"http://page-(\\d+)/"',"g");return b.replace(a,'href="/app/'+this.getBasisId()+'/$1"')
},getFilesUrl:function(a,b){if(typeof b=="undefined"){b=this.module_name}return this.proxy+"/static/mod/"+b+"/files/"+a
},getUploadUrl:function(d){if(typeof d=="undefined"){d=this.module_name}var c=this.getBasisId();var b=(new Array(9-c.length+1).join("0")+c);
var a=(window.webserverProtocol&&(window.webserverProtocol=="https://")?window.sslServerUrl:"")+"/remotemodules/";
if(this.mode=="admin"){a+=b.substr(0,3)+"/"+b.substr(3,3)+"/"+b.substr(6,3)+"/"}a+=d+"/"+this.instance_id;
return a},getHandlerUrl:function(c,b){var a=this.handler_proxy+"?mod.module="+this.module_name+"&mod.handler="+c+"&mod.instance_id="+this.instance_id+(this.mode=="admin"?"&mod.admin=1":"")+"&mod.locale="+apsinth.lang;
return this.buildUrl(a,b)},getViewUrl:function(a,c){var b=this.view_proxy+"?mod.module="+this.module_name+"&mod.view="+a+"&mod.instance_id="+this.instance_id+"&mod.externalModuleId="+this.moduleId+(this.mode=="admin"?"&mod.admin=1":"")+"&mod.locale="+apsinth.lang;
return this.buildUrl(b,c)},buildUrl:function(b,a){if(typeof a=="object"){jQuery.each(a,function(c,d){b+="&"+encodeURIComponent(c)+"="+encodeURIComponent(d)
})}return b},getData:function(c,a,d,b){this.ajaxUtil.getRequest(this.getHandlerUrl(c),a,d,b)},getView:function(a,b,d,c){this.ajaxUtil.getRequest(this.getViewUrl(a),b,d,c)
},callRpc:function(c,a,e,b){var d=this.module_name+"."+c;if(!a){a={}}a["mod.instance_id"]=this.instance_id;
a["mod.locale"]=apsinth.lang;a["mod.externalModuleId"]=this.moduleId;if(this.mode=="admin"){a["mod.admin"]=1
}this.ajaxUtil.rpcRequest(this.proxy+"/rpc/",d,a,e,b)},sendData:function(b,c,d,a){this.ajaxUtil.postRequest(this.getHandlerUrl(b),c,d,a)
},onError:function(b,a){apsinth.util.ErrorUtil.onError(b,a)},save:apsinth.util.ErrorUtil.wrap(function(){jQuery(".error-msg").hide();
this._removeDefaultInputValues();if(!this.validateConfig()){this._initDefaultInputValues();return}var a={data:this.getConfigData(),mod_saveEdit:1};
this._initDefaultInputValues();var b="private."+this.configSaveHandler;this.callRpc(b,a,this.toHandler(this.onConfigSaved),this)
}),onConfigSaved:function(c,b){if(b){this.onConfigSaveFailed(b)}else{if((c.status==="FAIL")&&(c.errors)){this.onValidationFailed(c)
}else{this.close(false,false,undefined,true);if(this.loadMainViewAfterSave){this.showLoading();var a=this;
this.reloadMainView(null,function(){a.hideLoading()})}}}},getDiyForm:function(){var a=this.getConfigJQ().find("form");
if(!a.is(":diy-form")){a.diy_form({appendMessage:this.appendError,messageTarget:this.errorTarget})}return a
},clearErrors:function(){this.getDiyForm().diy_form("clearErrors")},onValidationFailed:function(c){var b=this.getDiyForm(),a=this;
b.diy_form("clearErrors");jQuery.each(c.errors,function(d,h){var f=[];jQuery.each(h,function(e,i){f.push(i)
});f=f.join("<br/>");var g=b.find('input[name="'+d+'"]');if(g.length>0){if(g.attr("type")=="text"&&!g.is(":diy-formField")){g.diy_textField()
}if(a.fieldErrorsTarget=="auto"||a.fieldErrorsTarget=="field"||a.fieldErrorsTarget=="both"){b.diy_form("addError",f,g)
}}else{if(a.fieldErrorsTarget=="auto"){b.diy_form("addError",f)}}if(a.fieldErrorsTarget=="general"||a.fieldErrorsTarget=="both"){b.diy_form("addError",f)
}})},onConfigSaveFailed:function(c){var g="";var j=[];var a=[];if(c.errors instanceof Array){for(var d=0,f=c.errors.length;
d<f;d++){var h=c.errors[d];if(h instanceof Object&&h.field){a.push(h)}else{j.push(h)}}var b="";if(a&&a instanceof Array&&a.length>0){b="\n<br/> - User-side errors:\n<br/>";
for(var d=0,f=a.length;d<f;d++){b+=" "+a[d].message+"\n<br/>"}}g=" - Server-side error:\n"+j.join("\n")+b
}if(c.httpCode!=200){g+="\nHTTP Code: "+c.httpCode}if(c.exception){console.log(c.exception)}if(a.length>0&&this.getConfigJQ().find(".x-error-msg").size()>0){this._handleUserErrors(a)
}else{apsinth.util.ErrorUtil.onError("Saving config failed"+g)}c.handled=true},_handleUserErrors:function(e){if(!e&&!(e instanceof Object)){return
}var d=this.getConfigJQ();if(d.find(".x-error-msg").size()>0){var c="<ul>";for(var a=0,b=e.length;a<b;
a++){c+="<li>"+e[a].message+"</li>"}c+="</ul>";d.find(".x-error-msg").html(c).hide();d.find(".x-error-msg").html(c).fadeIn("100")
}},reloadMainView:function(b,d,c){var a=this;var e="public.view"+a.mainView.substring(0,1).toUpperCase()+a.mainView.substr(1);
this.callRpc(e,b,function(f,g){if(g){if(g.errors&&g.errors instanceof Array&&g.errors.length>0){a.onError(g.errors.join("\n"))
}}else{if(d){d(f)}}if(f.html){a.getMainJQ().html(f.html);a.getMainJQ().trigger("contentUpdated");a.initView_main();
if(c){c()}}})},open:apsinth.util.ErrorUtil.wrap(function(){if(typeof(Modul.prototype.open)==="function"){Modul.prototype.open.apply(this,arguments)
}if(!this.configIsOpen&&this.hasConfigView){this.trigger("open-config",this);this.configIsOpen=true}}),close:apsinth.util.ErrorUtil.wrap(function(){if(typeof(Modul.prototype.close)==="function"){Modul.prototype.close.apply(this,arguments)
}this.clearErrors();this.trigger("close-config",this);this.configIsOpen=false}),validateConfig:function(){return true
},getConfigData:function(){return null},_iFrameJQ:null,_iFrame:function(d){var b=null;if(this._iFrameJQ===null){var a=this;
b="ewoao"+Math.floor(Math.random()*123456);var f=a.getConfigJQ();var e=null;if(jQuery.browser.msie){e=jQuery('<iframe src="about:blank" id="'+b+'" name="'+b+'" style="display: none;" />')
}else{var c=document.createElement("iframe");c.setAttribute("style","display:none");c.setAttribute("id",b);
c.setAttribute("name",b);e=jQuery(c)}e.load((function(){var g=Array.prototype.slice.call(arguments,0);
g=g.concat([d]);return a.loaded.apply(a,g)}));f.append(e);this._iFrameJQ=e}else{b=this._iFrameJQ.attr("name")
}return b},upload:apsinth.util.ErrorUtil.wrap(function(d,c){d=jQuery(d);var a=this;var e=d.find("input[type=file]:first");
var b=a._iFrame(d);if(e.val()===""){return false}d.attr("action",a.getHandlerUrl(c));d.attr("target",b);
if(typeof(a.uploadStart)=="function"){return a.uploadStart()}else{return true}}),loaded:function(f,e){var d=f.currentTarget;
var b=this;var h=null;if(d.contentDocument){h=d.contentDocument}else{if(d.contentWindow){h=d.contentWindow.document
}else{h=window.frames[id].document}}contentJQ=jQuery(h);try{var c=contentJQ.contents().find("body").html();
if(c!=""){response=jQuery.evalJSON(c);if(response.status&&response.status!="OK"){var g={errors:(response.errors?response.errors:null)};
e.trigger("uploadError");b._uploadError(g)}else{if(typeof(b.uploadComplete)=="function"){e.trigger("uploadSuccess");
b.uploadComplete(response)}}}}catch(a){b._uploadError(a)}},_uploadError:function(a){if(typeof(this.uploadError)=="function"){this.uploadError(a)
}else{var b=apsinth.msg.conf_Upload.uploadError;if(a&&a.errors&&a.errors instanceof Array&&a.errors.length>0){b+=":\n";
b+=a.errors.join("\n")}this.onError(b)}},uploadComplete:function(a){},uploadStart:function(){},_setMinWidthStyles:function(){var a=this.getConfigJQ();
if(a.width()<this.CONFIG_MIN_WIDTH){this._minWidthSet=true;a.css({width:this.CONFIG_MIN_WIDTH});this.setOpenStyle();
this.trigger("width-adjusted")}else{if(a.width()==this.CONFIG_MIN_WIDTH){a.css("width","auto")}}},_removeMinWidthStyles:function(){if(this._minWidthSet){this._minWidthSet=false;
var b=this.getConfigJQ();b.css("width","auto");if(this._moduleElPosition){var a=jQuery("#modul_"+this.moduleId);
a.css("position",this._moduleElPosition);a.css("z-index","")}this.getMainJQ().css("backgroundColor","transparent")
}},_initDefaultInputValues:function(b){var b=b||this.getConfigJQ();var a=b.find("input[data-default-value]");
a.each(function(e,d){var g=(d===document.activeElement&&(d.type||d.href));d=jQuery(d);var f=d.val();var c=d.attr("data-default-value");
if((f==""||f==null||f=="null")&&c!=""){if(!g){d.addClass("apsinth-default-value");d.val(c)}d.bind("change.defaultValues",function(k){var i=jQuery(k.currentTarget);
var j=i.val();var h=i.attr("data-default-value");if(h){if(j==""){i.addClass("apsinth-default-value");
i.val(h)}else{if(j!=h){i.removeClass("apsinth-default-value")}}}});d.bind("focus.defaultValues",function(k){var i=jQuery(k.currentTarget);
var j=i.val();var h=i.attr("data-default-value");if(h&&j==h){i.val("");i.removeClass("apsinth-default-value")
}});d.bind("blur.defaultValues",function(k){var i=jQuery(k.currentTarget);var j=i.val();var h=i.attr("data-default-value");
if(h&&j==""){i.addClass("apsinth-default-value");i.val(h)}})}})},_removeDefaultInputValues:function(){var b=this.getConfigJQ();
var a=b.find("input[data-default-value]");a.each(function(e,d){d=jQuery(d);var f=d.val();var c=d.attr("data-default-value");
if(c&&f==c&&d.hasClass("apsinth-default-value")){d.removeClass("apsinth-default-value");d.val("");d.unbind("change.defaultValues");
d.unbind("focus.defaultValues");d.unbind("blur.defaultValues")}})}});(function($){$.extend($.ui,{datepicker16:{version:"1.6"}});
var PROP_NAME="datepicker16";function Datepicker(){this.debug=false;this._curInst=null;this._keyEvent=false;
this._disabledInputs=[];this._datepickerShowing=false;this._inDialog=false;this._mainDivId="ui-datepicker16-div";
this._inlineClass="ui-datepicker-inline";this._appendClass="ui-datepicker-append";this._triggerClass="ui-datepicker-trigger";
this._dialogClass="ui-datepicker-dialog";this._promptClass="ui-datepicker-prompt";this._disableClass="ui-datepicker-disabled";
this._unselectableClass="ui-datepicker-unselectable";this._currentClass="ui-datepicker-current-day";this._dayOverClass="ui-datepicker-days-cell-over";
this._weekOverClass="ui-datepicker-week-over";this.regional=[];this.regional[""]={clearText:"Clear",clearStatus:"Erase the current date",closeText:"Close",closeStatus:"Close without change",prevText:"&#x3c;Prev",prevStatus:"Show the previous month",prevBigText:"&#x3c;&#x3c;",prevBigStatus:"Show the previous year",nextText:"Next&#x3e;",nextStatus:"Show the next month",nextBigText:"&#x3e;&#x3e;",nextBigStatus:"Show the next year",currentText:"Today",currentStatus:"Show the current month",monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],monthNamesShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],monthStatus:"Show a different month",yearStatus:"Show a different year",weekHeader:"Wk",weekStatus:"Week of the year",dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],dayNamesShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],dayNamesMin:["Su","Mo","Tu","We","Th","Fr","Sa"],dayStatus:"Set DD as first week day",dateStatus:"Select DD, M d",dateFormat:"mm/dd/yy",firstDay:0,initStatus:"Select a date",isRTL:false};
this._defaults={showOn:"focus",showAnim:"show",showOptions:{},defaultDate:null,appendText:"",buttonText:"...",buttonImage:"",buttonImageOnly:false,closeAtTop:true,mandatory:false,hideIfNoPrevNext:false,navigationAsDateFormat:false,showBigPrevNext:false,gotoCurrent:false,changeMonth:true,changeYear:true,showMonthAfterYear:false,yearRange:"-10:+10",changeFirstDay:true,highlightWeek:false,showOtherMonths:false,showWeeks:false,calculateWeek:this.iso8601Week,shortYearCutoff:"+10",showStatus:false,statusForDate:this.dateStatus,minDate:null,maxDate:null,duration:"normal",beforeShowDay:null,beforeShow:null,onSelect:null,onChangeMonthYear:null,onClose:null,numberOfMonths:1,showCurrentAtPos:0,stepMonths:1,stepBigMonths:12,rangeSelect:false,rangeSeparator:" - ",altField:"",altFormat:"",constrainInput:true};
$.extend(this._defaults,this.regional[""]);this.dpDiv=$('<div id="'+this._mainDivId+'" style="display: none;"></div>')
}$.extend(Datepicker.prototype,{markerClassName:"hasDatepicker",log:function(){if(this.debug){console.log.apply("",arguments)
}},setDefaults:function(settings){extendRemove(this._defaults,settings||{});return this},_attachDatepicker:function(target,settings){var inlineSettings=null;
for(var attrName in this._defaults){var attrValue=target.getAttribute("date:"+attrName);if(attrValue){inlineSettings=inlineSettings||{};
try{inlineSettings[attrName]=eval(attrValue)}catch(err){inlineSettings[attrName]=attrValue}}}var nodeName=target.nodeName.toLowerCase();
var inline=(nodeName=="div"||nodeName=="span");if(!target.id){target.id="dp"+(++this.uuid)}var inst=this._newInst($(target),inline);
inst.settings=$.extend({},settings||{},inlineSettings||{});if(nodeName=="input"){this._connectDatepicker(target,inst)
}else{if(inline){this._inlineDatepicker(target,inst)}}},_newInst:function(target,inline){var id=target[0].id.replace(/([:\[\]\.])/g,"\\\\$1");
return{id:id,input:target,selectedDay:0,selectedMonth:0,selectedYear:0,drawMonth:0,drawYear:0,inline:inline,dpDiv:(!inline?this.dpDiv:$('<div class="'+this._inlineClass+'"></div>'))}
},_connectDatepicker:function(target,inst){var input=$(target);if(input.hasClass(this.markerClassName)){return
}var appendText=this._get(inst,"appendText");var isRTL=this._get(inst,"isRTL");if(appendText){input[isRTL?"before":"after"]('<span class="'+this._appendClass+'">'+appendText+"</span>")
}var showOn=this._get(inst,"showOn");if(showOn=="focus"||showOn=="both"){input.focus(this._showDatepicker)
}if(showOn=="button"||showOn=="both"){var buttonText=this._get(inst,"buttonText");var buttonImage=this._get(inst,"buttonImage");
var trigger=$(this._get(inst,"buttonImageOnly")?$("<img/>").addClass(this._triggerClass).attr({src:buttonImage,alt:buttonText,title:buttonText}):$('<button type="button"></button>').addClass(this._triggerClass).html(buttonImage==""?buttonText:$("<img/>").attr({src:buttonImage,alt:buttonText,title:buttonText})));
input[isRTL?"before":"after"](trigger);trigger.click(function(){if($.datepicker16._datepickerShowing&&$.datepicker16._lastInput==target){$.datepicker16._hideDatepicker()
}else{$.datepicker16._showDatepicker(target)}return false})}input.addClass(this.markerClassName).keydown(this._doKeyDown).keypress(this._doKeyPress).bind("setData.datepicker16",function(event,key,value){inst.settings[key]=value
}).bind("getData.datepicker16",function(event,key){return this._get(inst,key)});$.data(target,PROP_NAME,inst)
},_inlineDatepicker:function(target,inst){var divSpan=$(target);if(divSpan.hasClass(this.markerClassName)){return
}divSpan.addClass(this.markerClassName).append(inst.dpDiv).bind("setData.datepicker16",function(event,key,value){inst.settings[key]=value
}).bind("getData.datepicker16",function(event,key){return this._get(inst,key)});$.data(target,PROP_NAME,inst);
this._setDate(inst,this._getDefaultDate(inst));this._updateDatepicker(inst);this._updateAlternate(inst)
},_dialogDatepicker:function(input,dateText,onSelect,settings,pos){var inst=this._dialogInst;if(!inst){var id="dp"+(++this.uuid);
this._dialogInput=$('<input type="text" id="'+id+'" size="1" style="position: absolute; top: -100px;"/>');
this._dialogInput.keydown(this._doKeyDown);$("body").append(this._dialogInput);inst=this._dialogInst=this._newInst(this._dialogInput,false);
inst.settings={};$.data(this._dialogInput[0],PROP_NAME,inst)}extendRemove(inst.settings,settings||{});
this._dialogInput.val(dateText);this._pos=(pos?(pos.length?pos:[pos.pageX,pos.pageY]):null);if(!this._pos){var browserWidth=window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth;
var browserHeight=window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight;
var scrollX=document.documentElement.scrollLeft||document.body.scrollLeft;var scrollY=document.documentElement.scrollTop||document.body.scrollTop;
this._pos=[(browserWidth/2)-100+scrollX,(browserHeight/2)-150+scrollY]}this._dialogInput.css("left",this._pos[0]+"px").css("top",this._pos[1]+"px");
inst.settings.onSelect=onSelect;this._inDialog=true;this.dpDiv.addClass(this._dialogClass);this._showDatepicker(this._dialogInput[0]);
if($.blockUI){$.blockUI(this.dpDiv)}$.data(this._dialogInput[0],PROP_NAME,inst);return this},_destroyDatepicker:function(target){var $target=$(target);
if(!$target.hasClass(this.markerClassName)){return}var nodeName=target.nodeName.toLowerCase();$.removeData(target,PROP_NAME);
if(nodeName=="input"){$target.siblings("."+this._appendClass).remove().end().siblings("."+this._triggerClass).remove().end().removeClass(this.markerClassName).unbind("focus",this._showDatepicker).unbind("keydown",this._doKeyDown).unbind("keypress",this._doKeyPress)
}else{if(nodeName=="div"||nodeName=="span"){$target.removeClass(this.markerClassName).empty()}}},_enableDatepicker:function(target){var $target=$(target);
if(!$target.hasClass(this.markerClassName)){return}var nodeName=target.nodeName.toLowerCase();if(nodeName=="input"){target.disabled=false;
$target.siblings("button."+this._triggerClass).each(function(){this.disabled=false}).end().siblings("img."+this._triggerClass).css({opacity:"1.0",cursor:""})
}else{if(nodeName=="div"||nodeName=="span"){$target.children("."+this._disableClass).remove()}}this._disabledInputs=$.map(this._disabledInputs,function(value){return(value==target?null:value)
})},_disableDatepicker:function(target){var $target=$(target);if(!$target.hasClass(this.markerClassName)){return
}var nodeName=target.nodeName.toLowerCase();if(nodeName=="input"){target.disabled=true;$target.siblings("button."+this._triggerClass).each(function(){this.disabled=true
}).end().siblings("img."+this._triggerClass).css({opacity:"0.5",cursor:"default"})}else{if(nodeName=="div"||nodeName=="span"){var inline=$target.children("."+this._inlineClass);
var offset=inline.offset();var relOffset={left:0,top:0};inline.parents().each(function(){if($(this).css("position")=="relative"){relOffset=$(this).offset();
return false}});$target.prepend('<div class="'+this._disableClass+'" style="'+($.browser.msie?"background-color: transparent; ":"")+"width: "+inline.width()+"px; height: "+inline.height()+"px; left: "+(offset.left-relOffset.left)+"px; top: "+(offset.top-relOffset.top)+'px;"></div>')
}}this._disabledInputs=$.map(this._disabledInputs,function(value){return(value==target?null:value)});
this._disabledInputs[this._disabledInputs.length]=target},_isDisabledDatepicker:function(target){if(!target){return false
}for(var i=0;i<this._disabledInputs.length;i++){if(this._disabledInputs[i]==target){return true}}return false
},_getInst:function(target){try{return $.data(target,PROP_NAME)}catch(err){throw"Missing instance data for this datepicker"
}},_optionDatepicker:function(target,name,value){var settings=name||{};if(typeof name=="string"){settings={};
settings[name]=value}var inst=this._getInst(target);if(inst){if(this._curInst==inst){this._hideDatepicker(null)
}extendRemove(inst.settings,settings);var date=new Date();extendRemove(inst,{rangeStart:null,endDay:null,endMonth:null,endYear:null,selectedDay:date.getDate(),selectedMonth:date.getMonth(),selectedYear:date.getFullYear(),currentDay:date.getDate(),currentMonth:date.getMonth(),currentYear:date.getFullYear(),drawMonth:date.getMonth(),drawYear:date.getFullYear()});
this._updateDatepicker(inst)}},_changeDatepicker:function(target,name,value){this._optionDatepicker(target,name,value)
},_refreshDatepicker:function(target){var inst=this._getInst(target);if(inst){this._updateDatepicker(inst)
}},_setDateDatepicker:function(target,date,endDate){var inst=this._getInst(target);if(inst){this._setDate(inst,date,endDate);
this._updateDatepicker(inst);this._updateAlternate(inst)}},_getDateDatepicker:function(target){var inst=this._getInst(target);
if(inst&&!inst.inline){this._setDateFromField(inst)}return(inst?this._getDate(inst):null)},_doKeyDown:function(event){var inst=$.datepicker16._getInst(event.target);
var handled=true;inst._keyEvent=true;if($.datepicker16._datepickerShowing){switch(event.keyCode){case 9:$.datepicker16._hideDatepicker(null,"");
break;case 13:var sel=$("td."+$.datepicker16._dayOverClass+", td."+$.datepicker16._currentClass,inst.dpDiv);
if(sel[0]){$.datepicker16._selectDay(event.target,inst.selectedMonth,inst.selectedYear,sel[0])}else{$.datepicker16._hideDatepicker(null,$.datepicker16._get(inst,"duration"))
}return false;break;case 27:$.datepicker16._hideDatepicker(null,$.datepicker16._get(inst,"duration"));
break;case 33:$.datepicker16._adjustDate(event.target,(event.ctrlKey?-$.datepicker16._get(inst,"stepBigMonths"):-$.datepicker16._get(inst,"stepMonths")),"M");
break;case 34:$.datepicker16._adjustDate(event.target,(event.ctrlKey?+$.datepicker16._get(inst,"stepBigMonths"):+$.datepicker16._get(inst,"stepMonths")),"M");
break;case 35:if(event.ctrlKey||event.metaKey){$.datepicker16._clearDate(event.target)}handled=event.ctrlKey||event.metaKey;
break;case 36:if(event.ctrlKey||event.metaKey){$.datepicker16._gotoToday(event.target)}handled=event.ctrlKey||event.metaKey;
break;case 37:if(event.ctrlKey||event.metaKey){$.datepicker16._adjustDate(event.target,-1,"D")}handled=event.ctrlKey||event.metaKey;
if(event.originalEvent.altKey){$.datepicker16._adjustDate(event.target,(event.ctrlKey?-$.datepicker16._get(inst,"stepBigMonths"):-$.datepicker16._get(inst,"stepMonths")),"M")
}break;case 38:if(event.ctrlKey||event.metaKey){$.datepicker16._adjustDate(event.target,-7,"D")}handled=event.ctrlKey||event.metaKey;
break;case 39:if(event.ctrlKey||event.metaKey){$.datepicker16._adjustDate(event.target,+1,"D")}handled=event.ctrlKey||event.metaKey;
if(event.originalEvent.altKey){$.datepicker16._adjustDate(event.target,(event.ctrlKey?+$.datepicker16._get(inst,"stepBigMonths"):+$.datepicker16._get(inst,"stepMonths")),"M")
}break;case 40:if(event.ctrlKey||event.metaKey){$.datepicker16._adjustDate(event.target,+7,"D")}handled=event.ctrlKey||event.metaKey;
break;default:handled=false}}else{if(event.keyCode==36&&event.ctrlKey){$.datepicker16._showDatepicker(this)
}else{handled=false}}if(handled){event.preventDefault();event.stopPropagation()}},_doKeyPress:function(event){var inst=$.datepicker16._getInst(event.target);
if($.datepicker16._get(inst,"constrainInput")){var chars=$.datepicker16._possibleChars($.datepicker16._get(inst,"dateFormat"));
var chr=String.fromCharCode(event.charCode==undefined?event.keyCode:event.charCode);return event.ctrlKey||(chr<" "||!chars||chars.indexOf(chr)>-1)
}},_showDatepicker:function(input){input=input.target||input;if(input.nodeName.toLowerCase()!="input"){input=$("input",input.parentNode)[0]
}if($.datepicker16._isDisabledDatepicker(input)||$.datepicker16._lastInput==input){return}var inst=$.datepicker16._getInst(input);
var beforeShow=$.datepicker16._get(inst,"beforeShow");extendRemove(inst.settings,(beforeShow?beforeShow.apply(input,[input,inst]):{}));
$.datepicker16._hideDatepicker(null,"");$.datepicker16._lastInput=input;$.datepicker16._setDateFromField(inst);
if($.datepicker16._inDialog){input.value=""}if(!$.datepicker16._pos){$.datepicker16._pos=$.datepicker16._findPos(input);
$.datepicker16._pos[1]+=input.offsetHeight}var isFixed=false;$(input).parents().each(function(){isFixed|=$(this).css("position")=="fixed";
return !isFixed});if(isFixed&&$.browser.opera){$.datepicker16._pos[0]-=document.documentElement.scrollLeft;
$.datepicker16._pos[1]-=document.documentElement.scrollTop}var offset={left:$.datepicker16._pos[0],top:$.datepicker16._pos[1]};
$.datepicker16._pos=null;inst.rangeStart=null;inst.dpDiv.css({position:"absolute",display:"block",top:"-1000px"});
$.datepicker16._updateDatepicker(inst);inst.dpDiv.width($.datepicker16._getNumberOfMonths(inst)[1]*$(".ui-datepicker",inst.dpDiv[0])[0].offsetWidth);
offset=$.datepicker16._checkOffset(inst,offset,isFixed);inst.dpDiv.css({position:($.datepicker16._inDialog&&$.blockUI?"static":(isFixed?"fixed":"absolute")),display:"none",left:offset.left+"px",top:offset.top+"px"});
if(!inst.inline){var showAnim=$.datepicker16._get(inst,"showAnim")||"show";var duration=$.datepicker16._get(inst,"duration");
var postProcess=function(){$.datepicker16._datepickerShowing=true;if($.browser.msie&&parseInt($.browser.version,10)<7){$("iframe.ui-datepicker-cover").css({width:inst.dpDiv.width()+4,height:inst.dpDiv.height()+4})
}};if($.effects&&$.effects[showAnim]){inst.dpDiv.show(showAnim,$.datepicker16._get(inst,"showOptions"),duration,postProcess)
}else{inst.dpDiv[showAnim](duration,postProcess)}if(duration==""){postProcess()}if(inst.input[0].type!="hidden"){inst.input[0].focus()
}$.datepicker16._curInst=inst}},_updateDatepicker:function(inst){var dims={width:inst.dpDiv.width()+4,height:inst.dpDiv.height()+4};
inst.dpDiv.empty().append(this._generateHTML(inst)).find("iframe.ui-datepicker-cover").css({width:dims.width,height:dims.height});
var numMonths=this._getNumberOfMonths(inst);inst.dpDiv[(numMonths[0]!=1||numMonths[1]!=1?"add":"remove")+"Class"]("ui-datepicker-multi");
inst.dpDiv[(this._get(inst,"isRTL")?"add":"remove")+"Class"]("ui-datepicker-rtl");if(inst.input&&inst.input[0].type!="hidden"&&inst==$.datepicker16._curInst){$(inst.input[0]).focus()
}},_checkOffset:function(inst,offset,isFixed){var pos=inst.input?this._findPos(inst.input[0]):null;var browserWidth=window.innerWidth||(document.documentElement?document.documentElement.clientWidth:document.body.clientWidth);
var browserHeight=window.innerHeight||(document.documentElement?document.documentElement.clientHeight:document.body.clientHeight);
var scrollX=document.documentElement.scrollLeft||document.body.scrollLeft;var scrollY=document.documentElement.scrollTop||document.body.scrollTop;
if(this._get(inst,"isRTL")||(offset.left+inst.dpDiv.width()-scrollX)>browserWidth){offset.left=Math.max((isFixed?0:scrollX),pos[0]+(inst.input?inst.input.width():0)-(isFixed?scrollX:0)-inst.dpDiv.width()-(isFixed&&$.browser.opera?document.documentElement.scrollLeft:0))
}else{offset.left-=(isFixed?scrollX:0)}if((offset.top+inst.dpDiv.height()-scrollY)>browserHeight){offset.top=Math.max((isFixed?0:scrollY),pos[1]-(isFixed?scrollY:0)-(this._inDialog?0:inst.dpDiv.height())-(isFixed&&$.browser.opera?document.documentElement.scrollTop:0))
}else{offset.top-=(isFixed?scrollY:0)}return offset},_findPos:function(obj){while(obj&&(obj.type=="hidden"||obj.nodeType!=1)){obj=obj.nextSibling
}var position=$(obj).offset();return[position.left,position.top]},_hideDatepicker:function(input,duration,noDate){var inst=this._curInst;
if(!inst||(input&&inst!=$.data(input,PROP_NAME))){return}var elemJQ=this._get(inst,"element");var noEndDate=this._get(inst,"noEndDate");
if(noDate){elemJQ.val(noEndDate)}var rangeSelect=this._get(inst,"rangeSelect");if(rangeSelect&&inst.stayOpen){this._selectDate("#"+inst.id,this._formatDate(inst,inst.currentDay,inst.currentMonth,inst.currentYear))
}inst.stayOpen=false;if(this._datepickerShowing){duration=(duration!=null?duration:this._get(inst,"duration"));
var showAnim=this._get(inst,"showAnim");var postProcess=function(){$.datepicker16._tidyDialog(inst)};
if(duration!=""&&$.effects&&$.effects[showAnim]){inst.dpDiv.hide(showAnim,$.datepicker16._get(inst,"showOptions"),duration,postProcess)
}else{inst.dpDiv[(duration==""?"hide":(showAnim=="slideDown"?"slideUp":(showAnim=="fadeIn"?"fadeOut":"hide")))](duration,postProcess)
}if(duration==""){this._tidyDialog(inst)}var onClose=this._get(inst,"onClose");if(onClose){onClose.apply((inst.input?inst.input[0]:null),[(inst.input?inst.input.val():""),inst])
}this._datepickerShowing=false;this._lastInput=null;inst.settings.prompt=null;if(this._inDialog){this._dialogInput.css({position:"absolute",left:"0",top:"-100px"});
if($.blockUI){$.unblockUI();$("body").append(this.dpDiv)}}this._inDialog=false}this._curInst=null},_tidyDialog:function(inst){inst.dpDiv.removeClass(this._dialogClass).unbind(".ui-datepicker");
$("."+this._promptClass,inst.dpDiv).remove()},_checkExternalClick:function(event){if(!$.datepicker16._curInst){return
}var $target=$(event.target);if(($target.parents("#"+$.datepicker16._mainDivId).length==0)&&!$target.hasClass($.datepicker16.markerClassName)&&!$target.hasClass($.datepicker16._triggerClass)&&$.datepicker16._datepickerShowing&&!($.datepicker16._inDialog&&$.blockUI)){$.datepicker16._hideDatepicker(null,"")
}},_adjustDate:function(id,offset,period){var target=$(id);var inst=this._getInst(target[0]);this._adjustInstDate(inst,offset,period);
this._updateDatepicker(inst)},_gotoToday:function(id){var target=$(id);var inst=this._getInst(target[0]);
if(this._get(inst,"gotoCurrent")&&inst.currentDay){inst.selectedDay=inst.currentDay;inst.drawMonth=inst.selectedMonth=inst.currentMonth;
inst.drawYear=inst.selectedYear=inst.currentYear}else{var date=new Date();inst.selectedDay=date.getDate();
inst.drawMonth=inst.selectedMonth=date.getMonth();inst.drawYear=inst.selectedYear=date.getFullYear()}this._notifyChange(inst);
this._adjustDate(target)},_selectMonthYear:function(id,select,period){var target=$(id);var inst=this._getInst(target[0]);
inst._selectingMonthYear=false;inst["selected"+(period=="M"?"Month":"Year")]=inst["draw"+(period=="M"?"Month":"Year")]=parseInt(select.options[select.selectedIndex].value,10);
this._notifyChange(inst);this._adjustDate(target)},_clickMonthYear:function(id){var target=$(id);var inst=this._getInst(target[0]);
if(inst.input&&inst._selectingMonthYear&&!$.browser.msie){inst.input[0].focus()}inst._selectingMonthYear=!inst._selectingMonthYear
},_changeFirstDay:function(id,day){var target=$(id);var inst=this._getInst(target[0]);inst.settings.firstDay=day;
this._updateDatepicker(inst)},_selectDay:function(id,month,year,td){if($(td).hasClass(this._unselectableClass)){return
}var target=$(id);var inst=this._getInst(target[0]);var rangeSelect=this._get(inst,"rangeSelect");if(rangeSelect){inst.stayOpen=!inst.stayOpen;
if(inst.stayOpen){$(".ui-datepicker td",inst.dpDiv).removeClass(this._currentClass);$(td).addClass(this._currentClass)
}}inst.selectedDay=inst.currentDay=$("a",td).html();inst.selectedMonth=inst.currentMonth=month;inst.selectedYear=inst.currentYear=year;
if(inst.stayOpen){inst.endDay=inst.endMonth=inst.endYear=null}else{if(rangeSelect){inst.endDay=inst.currentDay;
inst.endMonth=inst.currentMonth;inst.endYear=inst.currentYear}}this._selectDate(id,this._formatDate(inst,inst.currentDay,inst.currentMonth,inst.currentYear));
if(inst.stayOpen){inst.rangeStart=this._daylightSavingAdjust(new Date(inst.currentYear,inst.currentMonth,inst.currentDay));
this._updateDatepicker(inst)}else{if(rangeSelect){inst.selectedDay=inst.currentDay=inst.rangeStart.getDate();
inst.selectedMonth=inst.currentMonth=inst.rangeStart.getMonth();inst.selectedYear=inst.currentYear=inst.rangeStart.getFullYear();
inst.rangeStart=null;if(inst.inline){this._updateDatepicker(inst)}}}},_clearDate:function(id){var target=$(id);
var inst=this._getInst(target[0]);if(this._get(inst,"mandatory")){return}inst.stayOpen=false;inst.endDay=inst.endMonth=inst.endYear=inst.rangeStart=null;
this._selectDate(target,"")},_selectDate:function(id,dateStr){var target=$(id);var inst=this._getInst(target[0]);
dateStr=(dateStr!=null?dateStr:this._formatDate(inst));if(this._get(inst,"rangeSelect")&&dateStr){dateStr=(inst.rangeStart?this._formatDate(inst,inst.rangeStart):dateStr)+this._get(inst,"rangeSeparator")+dateStr
}if(inst.input){inst.input.val(dateStr)}this._updateAlternate(inst);var onSelect=this._get(inst,"onSelect");
if(onSelect){onSelect.apply((inst.input?inst.input[0]:null),[dateStr,inst])}else{if(inst.input){inst.input.trigger("change")
}}if(inst.inline){this._updateDatepicker(inst)}else{if(!inst.stayOpen){this._hideDatepicker(null,this._get(inst,"duration"));
this._lastInput=inst.input[0];if(typeof(inst.input[0])!="object"){inst.input[0].focus()}this._lastInput=null
}}},_updateAlternate:function(inst){var altField=this._get(inst,"altField");if(altField){var altFormat=this._get(inst,"altFormat")||this._get(inst,"dateFormat");
var date=this._getDate(inst);dateStr=(isArray(date)?(!date[0]&&!date[1]?"":this.formatDate(altFormat,date[0],this._getFormatConfig(inst))+this._get(inst,"rangeSeparator")+this.formatDate(altFormat,date[1]||date[0],this._getFormatConfig(inst))):this.formatDate(altFormat,date,this._getFormatConfig(inst)));
$(altField).each(function(){$(this).val(dateStr)})}},noWeekends:function(date){var day=date.getDay();
return[(day>0&&day<6),""]},iso8601Week:function(date){var checkDate=new Date(date.getFullYear(),date.getMonth(),date.getDate());
var firstMon=new Date(checkDate.getFullYear(),1-1,4);var firstDay=firstMon.getDay()||7;firstMon.setDate(firstMon.getDate()+1-firstDay);
if(firstDay<4&&checkDate<firstMon){checkDate.setDate(checkDate.getDate()-3);return $.datepicker16.iso8601Week(checkDate)
}else{if(checkDate>new Date(checkDate.getFullYear(),12-1,28)){firstDay=new Date(checkDate.getFullYear()+1,1-1,4).getDay()||7;
if(firstDay>4&&(checkDate.getDay()||7)<firstDay-3){return 1}}}return Math.floor(((checkDate-firstMon)/86400000)/7)+1
},dateStatus:function(date,inst){return $.datepicker16.formatDate($.datepicker16._get(inst,"dateStatus"),date,$.datepicker16._getFormatConfig(inst))
},parseDate:function(format,value,settings){if(format==null||value==null){throw"Invalid arguments"}value=(typeof value=="object"?value.toString():value+"");
if(value==""){return null}var shortYearCutoff=(settings?settings.shortYearCutoff:null)||this._defaults.shortYearCutoff;
var dayNamesShort=(settings?settings.dayNamesShort:null)||this._defaults.dayNamesShort;var dayNames=(settings?settings.dayNames:null)||this._defaults.dayNames;
var monthNamesShort=(settings?settings.monthNamesShort:null)||this._defaults.monthNamesShort;var monthNames=(settings?settings.monthNames:null)||this._defaults.monthNames;
var year=-1;var month=-1;var day=-1;var doy=-1;var literal=false;var lookAhead=function(match){var matches=(iFormat+1<format.length&&format.charAt(iFormat+1)==match);
if(matches){iFormat++}return matches};var getNumber=function(match){lookAhead(match);var origSize=(match=="@"?14:(match=="y"?4:(match=="o"?3:2)));
var size=origSize;var num=0;while(size>0&&iValue<value.length&&value.charAt(iValue)>="0"&&value.charAt(iValue)<="9"){num=num*10+parseInt(value.charAt(iValue++),10);
size--}if(size==origSize){throw"Missing number at position "+iValue}return num};var getName=function(match,shortNames,longNames){var names=(lookAhead(match)?longNames:shortNames);
var size=0;for(var j=0;j<names.length;j++){size=Math.max(size,names[j].length)}var name="";var iInit=iValue;
while(size>0&&iValue<value.length){name+=value.charAt(iValue++);for(var i=0;i<names.length;i++){if(name==names[i]){return i+1
}}size--}throw"Unknown name at position "+iInit};var checkLiteral=function(){if(value.charAt(iValue)!=format.charAt(iFormat)){throw"Unexpected literal at position "+iValue
}iValue++};var iValue=0;for(var iFormat=0;iFormat<format.length;iFormat++){if(literal){if(format.charAt(iFormat)=="'"&&!lookAhead("'")){literal=false
}else{checkLiteral()}}else{switch(format.charAt(iFormat)){case"d":day=getNumber("d");break;case"D":getName("D",dayNamesShort,dayNames);
break;case"o":doy=getNumber("o");break;case"m":month=getNumber("m");break;case"M":month=getName("M",monthNamesShort,monthNames);
break;case"y":year=getNumber("y");break;case"@":var date=new Date(getNumber("@"));year=date.getFullYear();
month=date.getMonth()+1;day=date.getDate();break;case"'":if(lookAhead("'")){checkLiteral()}else{literal=true
}break;default:checkLiteral()}}}if(year==-1){year=new Date().getFullYear()}else{if(year<100){year+=new Date().getFullYear()-new Date().getFullYear()%100+(year<=shortYearCutoff?0:-100)
}}if(doy>-1){month=1;day=doy;do{var dim=this._getDaysInMonth(year,month-1);if(day<=dim){break}month++;
day-=dim}while(true)}var date=this._daylightSavingAdjust(new Date(year,month-1,day));if(date.getFullYear()!=year||date.getMonth()+1!=month||date.getDate()!=day){throw"Invalid date"
}return date},ATOM:"yy-mm-dd",COOKIE:"D, dd M yy",ISO_8601:"yy-mm-dd",RFC_822:"D, d M y",RFC_850:"DD, dd-M-y",RFC_1036:"D, d M y",RFC_1123:"D, d M yy",RFC_2822:"D, d M yy",RSS:"D, d M y",TIMESTAMP:"@",W3C:"yy-mm-dd",formatDate:function(format,date,settings){if(!date){return""
}var dayNamesShort=(settings?settings.dayNamesShort:null)||this._defaults.dayNamesShort;var dayNames=(settings?settings.dayNames:null)||this._defaults.dayNames;
var monthNamesShort=(settings?settings.monthNamesShort:null)||this._defaults.monthNamesShort;var monthNames=(settings?settings.monthNames:null)||this._defaults.monthNames;
var lookAhead=function(match){var matches=(iFormat+1<format.length&&format.charAt(iFormat+1)==match);
if(matches){iFormat++}return matches};var formatNumber=function(match,value,len){var num=""+value;if(lookAhead(match)){while(num.length<len){num="0"+num
}}return num};var formatName=function(match,value,shortNames,longNames){return(lookAhead(match)?longNames[value]:shortNames[value])
};var output="";var literal=false;if(date){for(var iFormat=0;iFormat<format.length;iFormat++){if(literal){if(format.charAt(iFormat)=="'"&&!lookAhead("'")){literal=false
}else{output+=format.charAt(iFormat)}}else{switch(format.charAt(iFormat)){case"d":output+=formatNumber("d",date.getDate(),2);
break;case"D":output+=formatName("D",date.getDay(),dayNamesShort,dayNames);break;case"o":var doy=date.getDate();
for(var m=date.getMonth()-1;m>=0;m--){doy+=this._getDaysInMonth(date.getFullYear(),m)}output+=formatNumber("o",doy,3);
break;case"m":output+=formatNumber("m",date.getMonth()+1,2);break;case"M":output+=formatName("M",date.getMonth(),monthNamesShort,monthNames);
break;case"y":output+=(lookAhead("y")?date.getFullYear():(date.getYear()%100<10?"0":"")+date.getYear()%100);
break;case"@":output+=date.getTime();break;case"'":if(lookAhead("'")){output+="'"}else{literal=true}break;
default:output+=format.charAt(iFormat)}}}}return output},_possibleChars:function(format){var chars="";
var literal=false;for(var iFormat=0;iFormat<format.length;iFormat++){if(literal){if(format.charAt(iFormat)=="'"&&!lookAhead("'")){literal=false
}else{chars+=format.charAt(iFormat)}}else{switch(format.charAt(iFormat)){case"d":case"m":case"y":case"@":chars+="0123456789";
break;case"D":case"M":return null;case"'":if(lookAhead("'")){chars+="'"}else{literal=true}break;default:chars+=format.charAt(iFormat)
}}}return chars},_get:function(inst,name){return inst.settings[name]!==undefined?inst.settings[name]:this._defaults[name]
},_setDateFromField:function(inst){var dateFormat=this._get(inst,"dateFormat");var dates=inst.input?inst.input.val().split(this._get(inst,"rangeSeparator")):null;
inst.endDay=inst.endMonth=inst.endYear=null;var date=defaultDate=this._getDefaultDate(inst);if(dates.length>0){var settings=this._getFormatConfig(inst);
if(dates.length>1){date=this.parseDate(dateFormat,dates[1],settings)||defaultDate;inst.endDay=date.getDate();
inst.endMonth=date.getMonth();inst.endYear=date.getFullYear()}try{date=this.parseDate(dateFormat,dates[0],settings)||defaultDate
}catch(event){this.log(event);date=defaultDate}}inst.selectedDay=date.getDate();inst.drawMonth=inst.selectedMonth=date.getMonth();
inst.drawYear=inst.selectedYear=date.getFullYear();inst.currentDay=(dates[0]?date.getDate():0);inst.currentMonth=(dates[0]?date.getMonth():0);
inst.currentYear=(dates[0]?date.getFullYear():0);this._adjustInstDate(inst)},_getDefaultDate:function(inst){var date=this._determineDate(this._get(inst,"defaultDate"),new Date());
var minDate=this._getMinMaxDate(inst,"min",true);var maxDate=this._getMinMaxDate(inst,"max");date=(minDate&&date<minDate?minDate:date);
date=(maxDate&&date>maxDate?maxDate:date);return date},_determineDate:function(date,defaultDate){var offsetNumeric=function(offset){var date=new Date();
date.setDate(date.getDate()+offset);return date};var offsetString=function(offset,getDaysInMonth){var date=new Date();
var year=date.getFullYear();var month=date.getMonth();var day=date.getDate();var pattern=/([+-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g;
var matches=pattern.exec(offset);while(matches){switch(matches[2]||"d"){case"d":case"D":day+=parseInt(matches[1],10);
break;case"w":case"W":day+=parseInt(matches[1],10)*7;break;case"m":case"M":month+=parseInt(matches[1],10);
day=Math.min(day,getDaysInMonth(year,month));break;case"y":case"Y":year+=parseInt(matches[1],10);day=Math.min(day,getDaysInMonth(year,month));
break}matches=pattern.exec(offset)}return new Date(year,month,day)};date=(date==null?defaultDate:(typeof date=="string"?offsetString(date,this._getDaysInMonth):(typeof date=="number"?(isNaN(date)?defaultDate:offsetNumeric(date)):date)));
date=(date&&date.toString()=="Invalid Date"?defaultDate:date);if(date){date.setHours(0);date.setMinutes(0);
date.setSeconds(0);date.setMilliseconds(0)}return this._daylightSavingAdjust(date)},_daylightSavingAdjust:function(date){if(!date){return null
}date.setHours(date.getHours()>12?date.getHours()+2:0);return date},_setDate:function(inst,date,endDate){var clear=!(date);
var origMonth=inst.selectedMonth;var origYear=inst.selectedYear;date=this._determineDate(date,new Date());
inst.selectedDay=inst.currentDay=date.getDate();inst.drawMonth=inst.selectedMonth=inst.currentMonth=date.getMonth();
inst.drawYear=inst.selectedYear=inst.currentYear=date.getFullYear();if(this._get(inst,"rangeSelect")){if(endDate){endDate=this._determineDate(endDate,null);
inst.endDay=endDate.getDate();inst.endMonth=endDate.getMonth();inst.endYear=endDate.getFullYear()}else{inst.endDay=inst.currentDay;
inst.endMonth=inst.currentMonth;inst.endYear=inst.currentYear}}if(origMonth!=inst.selectedMonth||origYear!=inst.selectedYear){this._notifyChange(inst)
}this._adjustInstDate(inst);if(inst.input){inst.input.val(clear?"":this._formatDate(inst)+(!this._get(inst,"rangeSelect")?"":this._get(inst,"rangeSeparator")+this._formatDate(inst,inst.endDay,inst.endMonth,inst.endYear)))
}},_getDate:function(inst){var startDate=(!inst.currentYear||(inst.input&&inst.input.val()=="")?null:this._daylightSavingAdjust(new Date(inst.currentYear,inst.currentMonth,inst.currentDay)));
if(this._get(inst,"rangeSelect")){return[inst.rangeStart||startDate,(!inst.endYear?inst.rangeStart||startDate:this._daylightSavingAdjust(new Date(inst.endYear,inst.endMonth,inst.endDay)))]
}else{return startDate}},_generateHTML:function(inst){var today=new Date();today=this._daylightSavingAdjust(new Date(today.getFullYear(),today.getMonth(),today.getDate()));
var showStatus=this._get(inst,"showStatus");var initStatus=this._get(inst,"initStatus")||"&#xa0;";var isRTL=this._get(inst,"isRTL");
var clear=(this._get(inst,"mandatory")?"":'<div class="ui-datepicker-clear"><a onclick="jQuery.datepicker16._clearDate(\'#'+inst.id+"');\""+this._addStatus(showStatus,inst.id,this._get(inst,"clearStatus"),initStatus)+">"+this._get(inst,"clearText")+"</a></div>");
var controls='<div class="ui-datepicker-control">'+(isRTL?"":clear)+'<div class="ui-datepicker-close"><a onclick="jQuery.datepicker16._hideDatepicker();"'+this._addStatus(showStatus,inst.id,this._get(inst,"closeStatus"),initStatus)+">"+this._get(inst,"closeText")+"</a></div>"+(isRTL?clear:"")+"</div>";
var prompt=this._get(inst,"prompt");var closeAtTop=this._get(inst,"closeAtTop");var hideIfNoPrevNext=this._get(inst,"hideIfNoPrevNext");
var navigationAsDateFormat=this._get(inst,"navigationAsDateFormat");var showBigPrevNext=this._get(inst,"showBigPrevNext");
var numMonths=this._getNumberOfMonths(inst);var showCurrentAtPos=this._get(inst,"showCurrentAtPos");var stepMonths=this._get(inst,"stepMonths");
var stepBigMonths=this._get(inst,"stepBigMonths");var isMultiMonth=(numMonths[0]!=1||numMonths[1]!=1);
var currentDate=this._daylightSavingAdjust((!inst.currentDay?new Date(9999,9,9):new Date(inst.currentYear,inst.currentMonth,inst.currentDay)));
var minDate=this._getMinMaxDate(inst,"min",true);var maxDate=this._getMinMaxDate(inst,"max");var drawMonth=inst.drawMonth-showCurrentAtPos;
var drawYear=inst.drawYear;if(drawMonth<0){drawMonth+=12;drawYear--}if(maxDate){var maxDraw=this._daylightSavingAdjust(new Date(maxDate.getFullYear(),maxDate.getMonth()-numMonths[1]+1,maxDate.getDate()));
maxDraw=(minDate&&maxDraw<minDate?minDate:maxDraw);while(this._daylightSavingAdjust(new Date(drawYear,drawMonth,1))>maxDraw){drawMonth--;
if(drawMonth<0){drawMonth=11;drawYear--}}}var prevText=this._get(inst,"prevText");prevText=(!navigationAsDateFormat?prevText:this.formatDate(prevText,this._daylightSavingAdjust(new Date(drawYear,drawMonth-stepMonths,1)),this._getFormatConfig(inst)));
var prevBigText=(showBigPrevNext?this._get(inst,"prevBigText"):"");prevBigText=(!navigationAsDateFormat?prevBigText:this.formatDate(prevBigText,this._daylightSavingAdjust(new Date(drawYear,drawMonth-stepBigMonths,1)),this._getFormatConfig(inst)));
var prev='<div class="ui-datepicker-prev">'+(this._canAdjustMonth(inst,-1,drawYear,drawMonth)?(showBigPrevNext?"<a onclick=\"jQuery.datepicker16._adjustDate('#"+inst.id+"', -"+stepBigMonths+", 'M');\""+this._addStatus(showStatus,inst.id,this._get(inst,"prevBigStatus"),initStatus)+">"+prevBigText+"</a>":"")+"<a onclick=\"jQuery.datepicker16._adjustDate('#"+inst.id+"', -"+stepMonths+", 'M');\""+this._addStatus(showStatus,inst.id,this._get(inst,"prevStatus"),initStatus)+">"+prevText+"</a>":(hideIfNoPrevNext?"":(showBigPrevNext?"<label>"+prevBigText+"</label>":"")+"<label>"+prevText+"</label>"))+"</div>";
var nextText=this._get(inst,"nextText");nextText=(!navigationAsDateFormat?nextText:this.formatDate(nextText,this._daylightSavingAdjust(new Date(drawYear,drawMonth+stepMonths,1)),this._getFormatConfig(inst)));
var nextBigText=(showBigPrevNext?this._get(inst,"nextBigText"):"");nextBigText=(!navigationAsDateFormat?nextBigText:this.formatDate(nextBigText,this._daylightSavingAdjust(new Date(drawYear,drawMonth+stepBigMonths,1)),this._getFormatConfig(inst)));
var next='<div class="ui-datepicker-next">'+(this._canAdjustMonth(inst,+1,drawYear,drawMonth)?"<a onclick=\"jQuery.datepicker16._adjustDate('#"+inst.id+"', +"+stepMonths+", 'M');\""+this._addStatus(showStatus,inst.id,this._get(inst,"nextStatus"),initStatus)+">"+nextText+"</a>"+(showBigPrevNext?"<a onclick=\"jQuery.datepicker16._adjustDate('#"+inst.id+"', +"+stepBigMonths+", 'M');\""+this._addStatus(showStatus,inst.id,this._get(inst,"nextBigStatus"),initStatus)+">"+nextBigText+"</a>":""):(hideIfNoPrevNext?"":"<label>"+nextText+"</label>"+(showBigPrevNext?"<label>"+nextBigText+"</label>":"")))+"</div>";
var currentText=this._get(inst,"currentText");var gotoDate=(this._get(inst,"gotoCurrent")&&inst.currentDay?currentDate:today);
currentText=(!navigationAsDateFormat?currentText:this.formatDate(currentText,gotoDate,this._getFormatConfig(inst)));
var html=(closeAtTop&&!inst.inline?controls:"")+'<div class="ui-datepicker-links">'+(isRTL?next:prev)+(this._isInRange(inst,gotoDate)?'<div class="ui-datepicker-current"><a onclick="jQuery.datepicker16._gotoToday(\'#'+inst.id+"');\""+this._addStatus(showStatus,inst.id,this._get(inst,"currentStatus"),initStatus)+">"+currentText+"</a></div>":"")+(isRTL?prev:next)+"</div>"+(prompt?'<div class="'+this._promptClass+'"><span>'+prompt+"</span></div>":"");
var firstDay=parseInt(this._get(inst,"firstDay"),10);firstDay=(isNaN(firstDay)?0:firstDay);var changeFirstDay=this._get(inst,"changeFirstDay");
var dayNames=this._get(inst,"dayNames");var dayNamesShort=this._get(inst,"dayNamesShort");var dayNamesMin=this._get(inst,"dayNamesMin");
var monthNames=this._get(inst,"monthNames");var beforeShowDay=this._get(inst,"beforeShowDay");var highlightWeek=this._get(inst,"highlightWeek");
var showOtherMonths=this._get(inst,"showOtherMonths");var showWeeks=this._get(inst,"showWeeks");var calculateWeek=this._get(inst,"calculateWeek")||this.iso8601Week;
var weekStatus=this._get(inst,"weekStatus");var status=(showStatus?this._get(inst,"dayStatus")||initStatus:"");
var dateStatus=this._get(inst,"statusForDate")||this.dateStatus;var endDate=inst.endDay?this._daylightSavingAdjust(new Date(inst.endYear,inst.endMonth,inst.endDay)):currentDate;
var defaultDate=this._getDefaultDate(inst);for(var row=0;row<numMonths[0];row++){for(var col=0;col<numMonths[1];
col++){var selectedDate=this._daylightSavingAdjust(new Date(drawYear,drawMonth,inst.selectedDay));html+='<div class="ui-datepicker-one-month'+(col==0?" ui-datepicker-new-row":"")+'">'+this._generateMonthYearHeader(inst,drawMonth,drawYear,minDate,maxDate,selectedDate,row>0||col>0,showStatus,initStatus,monthNames)+'<table class="ui-datepicker" cellpadding="0" cellspacing="0"><thead><tr class="ui-datepicker-title-row">'+(showWeeks?"<td"+this._addStatus(showStatus,inst.id,weekStatus,initStatus)+">"+this._get(inst,"weekHeader")+"</td>":"");
for(var dow=0;dow<7;dow++){var day=(dow+firstDay)%7;var dayStatus=(status.indexOf("DD")>-1?status.replace(/DD/,dayNames[day]):status.replace(/D/,dayNamesShort[day]));
html+="<td"+((dow+firstDay+6)%7>=5?' class="ui-datepicker-week-end-cell"':"")+">"+(!changeFirstDay?"<span":"<a onclick=\"jQuery.datepicker16._changeFirstDay('#"+inst.id+"', "+day+');"')+this._addStatus(showStatus,inst.id,dayStatus,initStatus)+' title="'+dayNames[day]+'">'+dayNamesMin[day]+(changeFirstDay?"</a>":"</span>")+"</td>"
}html+="</tr></thead><tbody>";var daysInMonth=this._getDaysInMonth(drawYear,drawMonth);if(drawYear==inst.selectedYear&&drawMonth==inst.selectedMonth){inst.selectedDay=Math.min(inst.selectedDay,daysInMonth)
}var leadDays=(this._getFirstDayOfMonth(drawYear,drawMonth)-firstDay+7)%7;var numRows=(isMultiMonth?6:Math.ceil((leadDays+daysInMonth)/7));
var printDate=this._daylightSavingAdjust(new Date(drawYear,drawMonth,1-leadDays));for(var dRow=0;dRow<numRows;
dRow++){html+='<tr class="ui-datepicker-days-row">'+(showWeeks?'<td class="ui-datepicker-week-col"'+this._addStatus(showStatus,inst.id,weekStatus,initStatus)+">"+calculateWeek(printDate)+"</td>":"");
for(var dow=0;dow<7;dow++){var daySettings=(beforeShowDay?beforeShowDay.apply((inst.input?inst.input[0]:null),[printDate]):[true,""]);
var otherMonth=(printDate.getMonth()!=drawMonth);var unselectable=otherMonth||!daySettings[0]||(minDate&&printDate<minDate)||(maxDate&&printDate>maxDate);
html+='<td class="ui-datepicker-days-cell'+((dow+firstDay+6)%7>=5?" ui-datepicker-week-end-cell":"")+(otherMonth?" ui-datepicker-other-month":"")+((printDate.getTime()==selectedDate.getTime()&&drawMonth==inst.selectedMonth&&inst._keyEvent)||(defaultDate.getTime()==printDate.getTime()&&defaultDate.getTime()==selectedDate.getTime())?" "+$.datepicker16._dayOverClass:"")+(unselectable?" "+this._unselectableClass:"")+(otherMonth&&!showOtherMonths?"":" "+daySettings[1]+(printDate.getTime()>=currentDate.getTime()&&printDate.getTime()<=endDate.getTime()?" "+this._currentClass:"")+(printDate.getTime()==today.getTime()?" ui-datepicker-today":""))+'"'+((!otherMonth||showOtherMonths)&&daySettings[2]?' title="'+daySettings[2]+'"':"")+(unselectable?(highlightWeek?" onmouseover=\"jQuery(this).parent().addClass('"+this._weekOverClass+"');\" onmouseout=\"jQuery(this).parent().removeClass('"+this._weekOverClass+"');\"":""):" onmouseover=\"jQuery(this).addClass('"+this._dayOverClass+"')"+(highlightWeek?".parent().addClass('"+this._weekOverClass+"')":"")+";"+(!showStatus||(otherMonth&&!showOtherMonths)?"":"jQuery('#ui-datepicker-status-"+inst.id+"').html('"+(dateStatus.apply((inst.input?inst.input[0]:null),[printDate,inst])||initStatus)+"');")+'" onmouseout="jQuery(this).removeClass(\''+this._dayOverClass+"')"+(highlightWeek?".parent().removeClass('"+this._weekOverClass+"')":"")+";"+(!showStatus||(otherMonth&&!showOtherMonths)?"":"jQuery('#ui-datepicker-status-"+inst.id+"').html('"+initStatus+"');")+'" onclick="jQuery.datepicker16._selectDay(\'#'+inst.id+"',"+drawMonth+","+drawYear+', this);"')+">"+(otherMonth?(showOtherMonths?printDate.getDate():"&#xa0;"):(unselectable?printDate.getDate():"<a>"+printDate.getDate()+"</a>"))+"</td>";
printDate.setDate(printDate.getDate()+1);printDate=this._daylightSavingAdjust(printDate)}html+="</tr>"
}drawMonth++;if(drawMonth>11){drawMonth=0;drawYear++}html+="</tbody></table></div>"}}var elemJQ=jQuery(inst.input);
var endDateClass=this._get(inst,"endDateClass");var repetitionEndDateClass=this._get(inst,"repetitionEndDateClass");
if(elemJQ.hasClass(endDateClass)||elemJQ.hasClass(repetitionEndDateClass)){var noEndDateButton=this._get(inst,"noEndDateButton");
html+='<div class="cancel-date"><input class="cancel" type="button" value="'+noEndDateButton+"\" onclick=\"jQuery.datepicker16._hideDatepicker('','',true);\" /></div>"
}html+=(showStatus?'<div style="clear: both;"></div><div id="ui-datepicker-status-'+inst.id+'" class="ui-datepicker-status">'+initStatus+"</div>":"")+(!closeAtTop&&!inst.inline?controls:"")+'<div style="clear: both;"></div>'+($.browser.msie&&parseInt($.browser.version,10)<7&&!inst.inline?'<iframe src="javascript:false;" class="ui-datepicker-cover"></iframe>':"");
inst._keyEvent=false;return html},_generateMonthYearHeader:function(inst,drawMonth,drawYear,minDate,maxDate,selectedDate,secondary,showStatus,initStatus,monthNames){minDate=(inst.rangeStart&&minDate&&selectedDate<minDate?selectedDate:minDate);
var changeMonth=this._get(inst,"changeMonth");var changeYear=this._get(inst,"changeYear");var showMonthAfterYear=this._get(inst,"showMonthAfterYear");
var html='<div class="ui-datepicker-header">';var monthHtml="";if(secondary||!changeMonth){monthHtml+=monthNames[drawMonth]
}else{var inMinYear=(minDate&&minDate.getFullYear()==drawYear);var inMaxYear=(maxDate&&maxDate.getFullYear()==drawYear);
monthHtml+='<select class="ui-datepicker-new-month" onchange="jQuery.datepicker16._selectMonthYear(\'#'+inst.id+"', this, 'M');\" onclick=\"jQuery.datepicker16._clickMonthYear('#"+inst.id+"');\""+this._addStatus(showStatus,inst.id,this._get(inst,"monthStatus"),initStatus)+">";
for(var month=0;month<12;month++){if((!inMinYear||month>=minDate.getMonth())&&(!inMaxYear||month<=maxDate.getMonth())){monthHtml+='<option value="'+month+'"'+(month==drawMonth?' selected="selected"':"")+">"+monthNames[month]+"</option>"
}}monthHtml+="</select>"}if(!showMonthAfterYear){html+=monthHtml+(secondary||changeMonth||changeYear?"&#xa0;":"")
}if(secondary||!changeYear){html+=drawYear}else{var years=this._get(inst,"yearRange").split(":");var year=0;
var endYear=0;if(years.length!=2){year=drawYear-10;endYear=drawYear+10}else{if(years[0].charAt(0)=="+"||years[0].charAt(0)=="-"){year=endYear=new Date().getFullYear();
year+=parseInt(years[0],10);endYear+=parseInt(years[1],10)}else{year=parseInt(years[0],10);endYear=parseInt(years[1],10)
}}year=(minDate?Math.max(year,minDate.getFullYear()):year);endYear=(maxDate?Math.min(endYear,maxDate.getFullYear()):endYear);
html+='<select class="ui-datepicker-new-year" onchange="jQuery.datepicker16._selectMonthYear(\'#'+inst.id+"', this, 'Y');\" onclick=\"jQuery.datepicker16._clickMonthYear('#"+inst.id+"');\""+this._addStatus(showStatus,inst.id,this._get(inst,"yearStatus"),initStatus)+">";
for(;year<=endYear;year++){html+='<option value="'+year+'"'+(year==drawYear?' selected="selected"':"")+">"+year+"</option>"
}html+="</select>"}if(showMonthAfterYear){html+=(secondary||changeMonth||changeYear?"&#xa0;":"")+monthHtml
}html+="</div>";return html},_addStatus:function(showStatus,id,text,initStatus){return(showStatus?" onmouseover=\"jQuery('#ui-datepicker-status-"+id+"').html('"+(text||initStatus)+"');\" onmouseout=\"jQuery('#ui-datepicker-status-"+id+"').html('"+initStatus+"');\"":"")
},_adjustInstDate:function(inst,offset,period){var year=inst.drawYear+(period=="Y"?offset:0);var month=inst.drawMonth+(period=="M"?offset:0);
var day=Math.min(inst.selectedDay,this._getDaysInMonth(year,month))+(period=="D"?offset:0);var date=this._daylightSavingAdjust(new Date(year,month,day));
var minDate=this._getMinMaxDate(inst,"min",true);var maxDate=this._getMinMaxDate(inst,"max");date=(minDate&&date<minDate?minDate:date);
date=(maxDate&&date>maxDate?maxDate:date);inst.selectedDay=date.getDate();inst.drawMonth=inst.selectedMonth=date.getMonth();
inst.drawYear=inst.selectedYear=date.getFullYear();if(period=="M"||period=="Y"){this._notifyChange(inst)
}},_notifyChange:function(inst){var onChange=this._get(inst,"onChangeMonthYear");if(onChange){onChange.apply((inst.input?inst.input[0]:null),[inst.selectedYear,inst.selectedMonth+1,inst])
}},_getNumberOfMonths:function(inst){var numMonths=this._get(inst,"numberOfMonths");return(numMonths==null?[1,1]:(typeof numMonths=="number"?[1,numMonths]:numMonths))
},_getMinMaxDate:function(inst,minMax,checkRange){var date=this._determineDate(this._get(inst,minMax+"Date"),null);
return(!checkRange||!inst.rangeStart?date:(!date||inst.rangeStart>date?inst.rangeStart:date))},_getDaysInMonth:function(year,month){return 32-new Date(year,month,32).getDate()
},_getFirstDayOfMonth:function(year,month){return new Date(year,month,1).getDay()},_canAdjustMonth:function(inst,offset,curYear,curMonth){var numMonths=this._getNumberOfMonths(inst);
var date=this._daylightSavingAdjust(new Date(curYear,curMonth+(offset<0?offset:numMonths[1]),1));if(offset<0){date.setDate(this._getDaysInMonth(date.getFullYear(),date.getMonth()))
}return this._isInRange(inst,date)},_isInRange:function(inst,date){var newMinDate=(!inst.rangeStart?null:this._daylightSavingAdjust(new Date(inst.selectedYear,inst.selectedMonth,inst.selectedDay)));
newMinDate=(newMinDate&&inst.rangeStart<newMinDate?inst.rangeStart:newMinDate);var minDate=newMinDate||this._getMinMaxDate(inst,"min");
var maxDate=this._getMinMaxDate(inst,"max");return((!minDate||date>=minDate)&&(!maxDate||date<=maxDate))
},_getFormatConfig:function(inst){var shortYearCutoff=this._get(inst,"shortYearCutoff");shortYearCutoff=(typeof shortYearCutoff!="string"?shortYearCutoff:new Date().getFullYear()%100+parseInt(shortYearCutoff,10));
return{shortYearCutoff:shortYearCutoff,dayNamesShort:this._get(inst,"dayNamesShort"),dayNames:this._get(inst,"dayNames"),monthNamesShort:this._get(inst,"monthNamesShort"),monthNames:this._get(inst,"monthNames")}
},_formatDate:function(inst,day,month,year){if(!day){inst.currentDay=inst.selectedDay;inst.currentMonth=inst.selectedMonth;
inst.currentYear=inst.selectedYear}var date=(day?(typeof day=="object"?day:this._daylightSavingAdjust(new Date(year,month,day))):this._daylightSavingAdjust(new Date(inst.currentYear,inst.currentMonth,inst.currentDay)));
return this.formatDate(this._get(inst,"dateFormat"),date,this._getFormatConfig(inst))}});function extendRemove(target,props){$.extend(target,props);
for(var name in props){if(props[name]==null||props[name]==undefined){target[name]=props[name]}}return target
}function isArray(a){return(a&&(($.browser.safari&&typeof a=="object"&&a.length)||(a.constructor&&a.constructor.toString().match(/\Array\(\)/))))
}$.fn.datepicker16=function(options){if(!$.datepicker16.initialized){$(document.body).append($.datepicker16.dpDiv).mousedown($.datepicker16._checkExternalClick);
$.datepicker16.initialized=true}var otherArgs=Array.prototype.slice.call(arguments,1);if(typeof options=="string"&&(options=="isDisabled"||options=="getDate")){return $.datepicker16["_"+options+"Datepicker"].apply($.datepicker16,[this[0]].concat(otherArgs))
}return this.each(function(){typeof options=="string"?$.datepicker16["_"+options+"Datepicker"].apply($.datepicker16,[this].concat(otherArgs)):$.datepicker16._attachDatepicker(this,options)
})};$.datepicker16=new Datepicker();$.datepicker16.initialized=false;$.datepicker16.uuid=new Date().getTime();
$.datepicker16.version="1.6"})(jQuery);window.counter={msg:{}};var Counter=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:355,_showingSubSelector:false,_colorSelectionDim:{box:null,picker:null},initialize:function(c,b,a,d){this._super(c,b,a,d)
},_initMainView:function(){},_initConfigView:function(){var c=this;this._selectedColor=this.data_admin.border_color;
var d=this.getConfigJQ();var a=d.find(".skins-tab");this._skinsTabWidth=a.width();d.find(".counternavtabs").tabs();
window.setTimeout(this.toHandler(function(){c._colorSelector=d.find(".apsinth-colorselector").colorPicker({mode:"button",showButtons:true,showStyledTitle:false,color:"#"+this._selectedColor,onColorSelect:function(e){c.getMainJQ().find(".ngh-counter").css("borderColor","#"+e)
},onColorAccept:this.toHandler(function(e){d.find("#"+this.idPrefix+"_border_color").val(e);this._selectedColor=e;
c.getMainJQ().find(".ngh-counter").css("borderColor","#"+e)})})}),0);this._skinSelector=new counter.SkinSelector(this,a,this.data_admin.skinMeta);
this._skinSelector.setSelectedSkin(this.data_admin.skin);d.find("#"+this.idPrefix+"_counter_value").keyup(this._onCounterValueKeyup).blur(this._onCounterValueBlur);
var b=this.toHandler(this._reloadPreview);jQuery("div#"+this.idPrefix+"_nr_digits_combobox").diy_combobox({editable:false,select:b});
jQuery("div#"+this.idPrefix+"_border_thick_combobox").diy_combobox({editable:false,select:b});jQuery("#"+this.idPrefix+"_th_sep_yes, #"+this.idPrefix+"_th_sep_no, #"+this.idPrefix+"_zero_digits_yes, #"+this.idPrefix+"_zero_digits_no").diy_radiobox();
this._initPreviewHandler(d);this.bind("open-config",this._onOpen,this);this.bind("width-adjusted",this._onWidthAdjusted,this)
},_onOpen:function(){if(this._skinSelector!=null){this._skinSelector.onShow()}},scroller:function(g){var f=jQuery(this);
var h=f.offset();var c=f.height();var d=h.top+(c/2);var a=h.top+c;var b=f.scrollTop();if(g.pageY<d-50&&b>0){f.scrollTop(b-9)
}else{if(g.pageY>d+50){f.scrollTop(b+9)}}},getConfigData:function(){var c=this.getConfigJQ();var b="#"+this.idPrefix;
var a=c.find(b+"_counter_value").val();if(a==""){a=0}return{nr_digits:c.find(b+"_nr_digits").val(),border_thick:c.find(b+"_border_thick").val(),counter_value:a,zero_digits:c.find("input[name='zero_digits']:checked").val(),th_sep:c.find("input[name='th_sep']:checked").val(),skin:this._skinSelector.getSelectedSkin(),border_color:this._selectedColor}
},_initDomRemovalPoller:function(){if(this._domRemovalPoller){return}var a=this;this._domRemovalPoller=window.setInterval(function(){if(a.getConfigJQ().find(".skins-tab").length==0){window.clearInterval(a._domRemovalPoller);
a._onDomRemoval()}},250)},_onDomRemoval:function(){var c=this._getOnDomRemovalElements();for(var b=0,a=c.length;
b<a;b++){c[b].remove()}},_addOnDomRemovalElement:function(a){if(!this._onDomRemovalElements){this._onDomRemovalElements=[]
}this._onDomRemovalElements.push(a)},_getOnDomRemovalElements:function(){return this._onDomRemovalElements?this._onDomRemovalElements:[]
},_onCounterValueKeyup:function(){if(jQuery(this).val().match(/^\d*$/g)==null){jQuery(this).val(jQuery(this).val().replace(/[^0-9]/g,""))
}},_onCounterValueBlur:function(){if(jQuery(this).val()==""){jQuery(this).val(0)}},_onTabChange:function(a){if(a.hasClass("skins-tab")){this._skinSelector.updateSkins()
}},_onWidthAdjusted:function(){if(apsinth.util.Browser.isIe6){this.getConfigJQ().find(".ngh-counter-config .skins-tab .label").css("float","none")
}},_initPreviewHandler:function(d){var b=this;var c=this._skinSelector._onVariantSelected.bind(this._skinSelector);
this._skinSelector._onVariantSelected=function(e){c(e);b._reloadPreview(d)};var a=this.toHandler(this._reloadPreview);
d.find("#"+this.idPrefix+"_border_thick").change(a);d.find("#"+this.idPrefix+"_counter_value").change(a);
d.find("#"+this.idPrefix+"_nr_digits").change(a);d.find("#"+this.idPrefix+"_zero_digits_yes").change(a);
d.find("#"+this.idPrefix+"_zero_digits_no").change(a);d.find("#"+this.idPrefix+"_th_sep_yes").change(a);
d.find("#"+this.idPrefix+"_th_sep_no").change(a)},_reloadPreview:function(){var a=this.getConfigData();
a["mod.admin"]=1;this.reloadMainView(a)}});counter.Counter=Counter;window.rssaggreg={msg:{}};var RSSAggregator=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:450,CATALOG_FEED_URL:"http://api.feedzilla.com/v1/categories/%catId%/subcategories/%subId%/articles.rss",newRssTabs:null,newRssSettingsJQ:null,newRssSettingsLayer:null,feeds:new Hashmap({}),feedIdOffset:0,initialize:function(c,b,a,d){this._super(c,b,a,d);
this.msg=rssaggreg.msg.conf_RssAgreg},_initMainView:function(){var a=this;var b=this.getMainJQ();var c={imgresize:(jQuery.browser.webkit||jQuery.browser.mozilla||jQuery.browser.opera)?true:false};
this.callRpc("public.viewArticles",c,function(d,e){if(!e){b.html(d.html)}else{b.html('<div style="border: 1px solid red; padding: 5px;">RSS: '+apsinth.msg.main_Error.requestError+"</div>");
a.hideLoading()}},this)},_initConfigView:function(){var b=this.getConfigJQ();b.find(".wrapper_num_articles").diy_combobox({editable:false,borders:false});
b.find("a.viewStyle").click(this.toHandler(function(d){var c=jQuery(d.currentTarget);if(!c.hasClass("selected")){b.find("a.viewStyle.active").removeClass("active");
c.addClass("active");this.refreshFeedView()}}));b.find("a.new-feed").click(this.toHandler(this.showAddNewLayer));
this.initDeleteFeedsButtons(b);this.feeds=new Hashmap(this.data_admin.feedInfo);var a=0;jQuery.each(this.feeds,function(c){a++
});this.feedIdOffset=a;this.feeds=new Hashmap();this.feeds.setHashmapObject(this.data_admin.feedInfo)
},initDeleteFeedsButtons:function(a){a.find('a.ewoao_rss_removeFeedButton[rel="removeUserFeed"]').addClass(" ui-button-borderless").button({text:false,icons:{primary:"ui-icon-trash"}}).click(this.toHandler(this.removeFeed))
},getConfigData:function(){var b=this.getConfigJQ();var a=b.find('select[name="num_articles"]').val();
if(parseInt(a)<1){b.find('select[name="num_articles"]').val(1);a=1}return{num_articles:a,user_feeds:this.feeds.collect(),view_mode:b.find("a.viewStyle.active").attr("rel")}
},addCatalogFeed:function(){var b=this.newRssSettingsJQ.find('select[rel="catalog-category"]').val();
var c=this.newRssSettingsJQ.find('select[rel="catalog-subcategory"]').val();if(b!==""&&c!==""){var a=this.CATALOG_FEED_URL.replace(/%catId%/,b).replace(/%subId%/,c);
return this.addFeeds([a])}return true},addManualFeeds:function(){var a=[];this.newRssSettingsJQ.find(".new-rss-manual-input").each(function(){var b=jQuery(this).val();
if(b!==jQuery(this).attr("data-default-value")){a.push(b)}});this.addFeeds(a)},addFeeds:function(b){this.showLoading(this.newRssSettingsJQ);
var a=this.newRssSettingsJQ.diy_form({appendMessage:true,messageTarget:this.newRssSettingsJQ.find(".form-error")});
a.diy_form("clearErrors");this.callRpc("private.viewListitemFeed",{urls:b},function(e,f){this.hideLoading(this.newRssSettingsJQ);
if(!f){var g=jQuery(e.html);var c=e.data.feedInfo;var d=this;var h=this.getConfigJQ().find("ul.ewoao_rss_user_feeds");
jQuery.each(g,function(k,m){var j=jQuery(m).find("li");var l=c[k];if(typeof(l)=="undefined"){return}l.id="feed_"+(d.feedIdOffset++);
j.attr("id",d.idPrefix+"_"+l.id);h.append(j);d.initDeleteFeedsButtons(j);d.feeds.set(l.id,l)});this.newRssSettingsLayer.hide()
}else{a.diy_form("addError",f.errors.join("<br/>"));f.handled=true;this.getDialog().find(".button-save").button("option","disabled",false)
}},this)},getDialog:function(){if(this.newRssSettingsLayer){return this.newRssSettingsLayer._dlg[this.newRssSettingsLayer._dlgClassName]("widget")
}else{return false}},removeFeed:function(b){var a=jQuery(jQuery(b.currentTarget).parents("li")[0]);var c=a.attr("id").substr(this.idPrefix.length+1);
a.remove();this.feeds.unset(c);b.preventDefault()},showAddNewLayer:function(){this.callRpc("private.viewNew",null,function(d,g){if(!g&&d&&d.html){var h=this;
var k=this.getConfigJQ().find(".feed_list");this.newRssSettingsLayer=new apsinth.util.Layer(null,{usingUiDialog:true,zIndex:1000001,dlgOptions:{title:this.msg.newFeedTitle,buttons:[{text:apsinth.msg.main_MessageDialog.close,click:this.toHandler(function(){this.newRssSettingsLayer.hide()
},this),"class":"button-cancel"},{"class":"button-save",text:apsinth.msg.main_MessageDialog.ok,click:this.toHandler(function(m){jQuery(m.target).button({disabled:true});
this.saveNewFeeds()})}]}});this.newRssSettingsLayer.showAbove(k,true,-25,{minWidth:600});this.newRssSettingsJQ=this.newRssSettingsLayer.getContent();
this.newRssSettingsJQ.addClass("new-feed-settings");this.newRssSettingsJQ.html(d.html);this.newRssSettingsJQ.data("ownerModule",this);
this.newRssTabs=this.newRssSettingsJQ.find(".new_rss_tabs");this.newRssTabs.tabs();var l=this.newRssSettingsJQ.find('select[rel="catalog-category"]');
var i=this.newRssSettingsJQ.find(".catalog-category-combobox");var a=this.newRssSettingsJQ.find('select[rel="catalog-subcategory"]');
var c=this.newRssSettingsJQ.find(".catalog-subcategory-combobox");i.add(c).diy_combobox({editable:false,select:function(){jQuery(this).find("select").change()
},disabled:true});l.html('<option value="0">'+a.attr("loadingvalue")+"...</option>");i.diy_combobox("option","rawValue",0);
this.callRpc("private.catalogFeeds",{req:"categories"},function(m,n){if(!n&&m&&m.categories){l.html('<option value="0">'+l.attr("defaultvalue")+"</option>");
i.diy_combobox("option","rawValue",0);jQuery.each(m.categories,function(o,p){l.append('<option value="'+o+'">'+this+"</option>")
});i.diy_combobox("option","disabled",false);if(h.trigger instanceof Function){h.trigger("onload",h)}}else{if(n){n.handled=true
}l.html('<option value="0">---</option>');i.diy_combobox("option","rawValue",0)}},this);that=this;i.diy_combobox("option","change",function(n,m){c.diy_combobox("option","disabled",true);
if(typeof m.rawValue!="undefined"&&m.rawValue==0){a.find("option").html("---");c.diy_combobox("option","rawValue",0);
return}a.find("option").html(a.attr("loadingvalue")+"...");c.diy_combobox("option","rawValue",0);that.callRpc("private.catalogFeeds",{req:"subcategories",category:m.rawValue},function(o,p){if(!p&&o&&o.categories){a.find("option").html(a.attr("defaultvalue"));
c.diy_combobox("option","rawValue",0);a.html("");a.append('<option value="0">'+a.attr("defaultvalue")+"</option>");
jQuery.each(o.categories,function(q,r){a.append('<option value="'+q+'">'+this+"</option>")});c.diy_combobox("option","rawValue",0);
c.diy_combobox("option","disabled",false);if(h.trigger instanceof Function){h.trigger("onload",h)}}})
});this.newManualRssFormItem=this.newRssSettingsJQ.find(".new-rss-manual-section .form-item")[0].outerHTML;
var h=this;var j=function(){var m=jQuery(this).parents(".new-rss-manual-section").find(".item_delete");
if(m.length==2){m.button("option","disabled",true)}jQuery(this).parents(".form-item").remove()};var b=this.newRssSettingsJQ.find(".item_delete");
var e=b.length==1;var f=function(m){m.addClass(" ui-button-borderless").button({text:false,disabled:e,icons:{primary:"ui-icon-trash"}}).click(j)
};f(b);this.newRssSettingsJQ.find(".item_add").button({icons:{primary:"ui-icon-plusthick"}}).click(function(o){o.preventDefault();
var n=jQuery(this).parents(".form-item");n.before(h.newManualRssFormItem);var m=n.prev(".form-item");
f(m.find(".item_delete"));jQuery(this).parents(".new-rss-manual-section").find(".item_delete").button("option","disabled",false);
h._initDefaultInputValues(m)});this._initDefaultInputValues(this.newRssSettingsJQ);if(this.trigger instanceof Function){this.trigger("onload",this)
}}},this)},saveNewFeeds:function(){switch(this.newRssTabs.tabs("option","selected")){case 0:this.addCatalogFeed();
break;case 1:this.addManualFeeds();break}},refreshFeedView:function(){this.showLoading();var a=(this.mode=="admin"?this.getConfigData():{});
a.imgresize=(jQuery.browser.webkit||jQuery.browser.mozilla||jQuery.browser.opera)?true:false;this.callRpc("public.viewArticles",a,function(b,c){if(!c){this.getMainJQ().html(b.html);
this.hideLoading()}},this)},addFeedsAfterReload:function(a){}});var DocViewer=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:550,_docChanged:null,initialize:function(c,b,a,d){this._super(c,b,a,d)
},_initMainView:function(){function b(c){c=c||window.event;if(c.preventDefault){c.preventDefault()}c.returnValue=false
}var a=this.getMainJQ()[0];if(a.addEventListener){a.addEventListener((jQuery.browser.mozilla?"DOMMouseScroll":"mousewheel"),b,false)
}else{a.onmousewheel=b}},validateConfig:function(){return true},_initConfigView:function(){var a=this.getConfigJQ();
a.find(".ngh-docviewer-config .mod-bar-primary-section a").click(this.toHandler(function(b){a.find(".active").removeClass("active");
jQuery(b.currentTarget).addClass("active")}));a.find(".mod-bar-primary input[type='checkbox']").diy_checkbox();
this._uploadJQ=a.find(".upload-file-item").diy_uploadField({change:function(){jQuery(this).closest("form").submit()
}});this._docChanged=false},getConfigData:function(){var c=this.getConfigJQ();var a;var b=this.getFlashElem();
if(b&&b.zoomResponse){a=b.zoomResponse()}else{a=100}return{viewstyle:c.find(".ngh-docviewer-config .mod-bar-primary-section a.active").attr("rel"),allowdownload:c.find("input[name=ngh-docviewer-allowDownload]:checked").length,allowprint:c.find("input[name=ngh-docviewer-allowPrint]:checked").length,tempDoc:this._docChanged?1:0,zoom:a}
},uploadStart:function(){var c=this.getConfigJQ();var b=c.find(".ngh-docviewer-config");b.loadingBox().show();
var a=c.find("form");a.diy_form({messageTarget:c.find("#custom_error_placeholder_"+this.moduleId)});a.diy_form("clearErrors")
},uploadComplete:function(b){var a=this;var e=this.getConfigJQ();var d=e.find(".ngh-docviewer-config");
d.loadingBox().hide();var c=e.find("form");c.diy_form({messageTarget:e.find("#custom_error_placeholder_"+this.moduleId)});
c.diy_form("clearErrors");this._docChanged=true;this.reloadMainView({zoom:0,tempDoc:1})},uploadError:function(b){var d=this.getConfigJQ();
var c=d.find(".ngh-docviewer-config");c.loadingBox().hide();var a=d.find("form");a.diy_form({messageTarget:d.find("#custom_error_placeholder_"+this.moduleId)});
if(b.errors){a.diy_form("addError",b.errors.join(", "))}},setHeight:function(a){var b=this.getFlashElem();
if(b){jQuery(b).attr("height",a+"px")}},getFlashElem:function(){var a="docviewer_"+this.moduleId;return document[a]||window[a]
},close:function(a,b){b=(typeof b=="undefined")||(b!==false);if(b&&this._docChanged){this.callRpc("private.canceledit")
}this._docChanged=false;this._super.apply(this,arguments)}});DocViewer.onViewerClicked=function(a){mm[a].open()
};window.prodpres={msg:{}};var ProductPresentation=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:595,keywords_loaded:0,msg:null,msg_main:null,eventhandlers_registered:false,layout:null,detailVisible:false,settingsActive:false,text2ImageUrl:"",maileditorId:"maileditor-area",termseditorId:"terms",ackeditorId:"ack_text",errorTarget:".form-error",fieldErrorsTarget:"both",busy:false,initialize:function(c,b,a,d){this._super(c,b,a,d);
this.msg_main=prodpres.msg.main_ProdPres;this.msg=prodpres.msg.conf_ProdPres},_initMainView:function(){var a=this;
var b=this.getMainJQ();this._attachMainViewEventHandlers()},_initConfigView:function(){var a=this;var b=this.getConfigJQ();
this.view_upload=b.find(".view_upload");b.find(".error-msg").hide();this.textareaId="pp"+this.moduleId+"-"+Math.floor(Math.random()*1000000);
b.find('[name="description"]').attr("id",this.textareaId);b.find('[name="getContent"]').attr("id","link_"+this.textareaId);
b.find(".industry-template").click(this.toHandler(function(c){this.selectTemplate("industry");c.preventDefault()
}));b.find(".customer-template").click(this.toHandler(function(c){this.selectTemplate("customer");c.preventDefault()
}));b.find(".switch-layout1").click(this.toHandler(function(c){c.preventDefault()}));b.find(".switch-layout2").click(this.toHandler(function(c){c.preventDefault()
}));b.find(".switch-layout3").click(this.toHandler(function(c){c.preventDefault()}));a.mainTabbar=this.getConfigJQ().find(".maintabbar");
if(a.mainTabbar){a.mainTabbar.tabs()}this.getConfigJQ().find("#productPresentationImageLimit").quickhelp("",false,true,true);
a.uploadLayer=null;b.find(".uploadflash").click(this.toHandler(function(c){if(a.busy){return false}a.busy=true;
a.showConfigLoading();a.callRpc("private.viewUploadlayer","",function(e,d){a.busy=false;a.hideConfigLoading();
if(!d){a.uploadLayer=new apsinth.util.Layer(null,{usingUiDialog:true,zIndex:100000,dlgOptions:{title:a.msg.imageUploadLayerTitle,buttons:[{text:a.msg.uploadCancel,click:a.toHandler(function(h){this.uploadLayer.hide()
}),"class":"button-cancel"}]}});a.uploadLayer.showAbove(b,true,-25,{minWidth:425});var g=a.uploadLayer.getContent();
g.addClass("pp-upload-dialog-content");g[0].innerHTML=e.html;a.uploadTabbarJQ=g.find(".pp-upload-tabs");
a.uploadTabbarJQ.tabs();a.uploadTabbarJQ.bind("tabsselect",function(h,i){if(i.index==1){g.find(".pp-multi-uploader").diy_multipleUpload("resetIfFlashReloadBug")
}});if(a.data_admin.gbAvailiable==0){g.find(".pp-tab-gbupload").remove()}if(!a.data_admin.userHasPurchases||a.data_admin.gbAvailiable==0){g.find(".pp-tab-pdupload").css("display","none");
if(a.data_admin.gbAvailiable==0){g.find(".pp-tab-pdupload").remove()}}if(!a.data_admin.gbAvailiable==0){g.find(".pp-tab-gbupload").click(a.toHandler(function(){this.loadGallery("gallery")
}));g.find(".pp-tab-pdupload").click(a.toHandler(function(){this.loadGallery("purchasedImages")}))}var f=g.find(".pp-multi-uploader");
f.diy_multipleUpload({uploadUrl:a.proxy+"/rpc/product_presentation/public/upload",postParams:{"mod.instance_id":f.attr("data-instance-id"),"mod.handler":"upload","mod.locale":apsinth.lang,"mod.externalModuleId":a.moduleId,DIY_SB:a.getSession()||""},allUploadsComplete:function(h,i){if(i&&i.status=="error"){a.onValidationFailed({errors:{general:{general:i.message}}})
}else{a.clearErrors()}a.onFlashUploadDone()},serverResponseParser:function(j){var h=jQuery.parseJSON(j),i={};
if(h.result&&h.result.status=="OK"){i.status="success"}else{i.status="error";if(h.result&&h.result.errors){i.message=h.result.errors.join("<br/>")
}}return i},swfUploadSettings:{file_upload_limit:5},fileTypes:"*.jpg;*.jpeg;*.gif;*.png;*.JPG;*.JPEG;*.GIF;*.PNG",fileSizeLimit:"5 MB",texts:{sendingFiles:a.msg.multiuploader_uploadingTXT,fileTypesDescription:"PNG, GIF, JPG",noFilesMessage:a.msg.multiuploader_noFilesMessage}})
}});c.preventDefault()}));this.mainTabbar.bind("tabsselect",this.toHandler(function(c,d){if(d.index==2){if(!this.keywords_loaded){this.viewSearchKeywords();
this.keywords_loaded=1}}if(d.index==1){this.postUpload()}}));if(!this.eventhandlers_registered){this.eventhandlers_registered=true;
this.registerEventHandlers()}},loadGallery:function(c){var d=this.uploadLayer.getContent();if("development"==OAO_.configObject.system_env&&false){OAO_.loadWidget(this.getBasisId(),"pp_"+this.instance_id,"product_presentation",{selection:c,contractId:"000000000",customerId:"000000000",techorderId:"000000000",instance:this,config:{moduleId:this.moduleId,instanceId:this.instance_id}},d.find("#pp_"+c+"-"+a.instance_id),this.galleryCallback)
}else{var b=OAO_.configObject.jimdoHost+"/galleryWidget.getIdset?websiteId="+this.getBasisId();var a=this;
jQuery.ajaxSetup({contentType:"application/x-www-form-urlencoded; charset=UTF-8"});jQuery.getJSON("/app/module/galleryproxy/?h="+b,{},function(e){var f=jQuery.parseJSON(e.data);
OAO_.loadWidget(a.getBasisId(),"pp_"+a.instance_id,"product_presentation",{selection:c,contractId:f.contractId,customerId:f.customerId,techorderId:f.techorderId,instance:a,config:{moduleId:a.moduleId,instanceId:a.instance_id}},d.find("#pp_"+c+"-"+a.instance_id),a.galleryCallback)
})}},_callbackLoadGraphicsboostWidged:function(c,d,a,b){return function(e){OAO_.loadWidget(a,"pp_"+b,"product_presentation",{selection:c,contractId:e.extContractId,customerId:e.customerId,techorderId:e.techorderId,instance:this,config:{instanceId:this.instance_id}},d.find("#pp_"+c+"-"+self.instance_id),this.galleryCallback)
}},registerEventHandlers:function(){var d=this.getConfigJQ();var b=this.toHandler(this.refreshMainView);
var a=this;d.find("#"+this.idPrefix+"_headline_type1").diy_radiobox().change(b);d.find("#"+this.idPrefix+"_headline_type2").diy_radiobox().change(b);
d.find("#"+this.idPrefix+"_show_shoppingbasket_button_yes").diy_radiobox().change(b);d.find("#"+this.idPrefix+"_show_shoppingbasket_button_no").diy_radiobox().change(b);
var e=d.find(".tax-info-box");if(e.length>0){var c=e.html();e.html("");e.quickhelp(c,false,true,true)
}d.find(".switch-layout1").click(function(){a._setLayout(1)});d.find(".switch-layout2").click(function(){a._setLayout(2)
});d.find(".switch-layout3").click(function(){a._setLayout(3)});d.find("a.options").click(this.toHandler(this.showSettings))
},showSettings:function(a){if(this.settingsActive===true){return false}this.settingsActive=true;this.callRpc("private.viewSettings",null,function(b,c){if(!c){var d=this.showSettingsLayer(b.html);
this.initSettingsHandlers(d);this.text2ImageUrl=b.data.text2ImageUrl;this.maileditor.setupMaileditor(this,d);
tinyMCE.execCommand("mceAddControl",false,this.termseditorId);jQuery("#"+this.termseditorId).data("__cclinkSettings",{targetForInternal:"_blank"});
tinyMCE.execCommand("mceAddControl",false,this.ackeditorId);this.searchCriteriaHandler(d.find("#"+this.idPrefix+"_search-keys-tab"));
if(a){d.find("a[href='#"+this.idPrefix+"_"+a+"']").click()}}},this);return true},showSettingsLayer:function(a){var c=this.getConfigJQ();
var b=this.getMainJQ();this.settingsLayer=new apsinth.util.Layer(null,{usingUiDialog:true,zIndex:100000,dlgOptions:{title:this.msg.settingsLayerTitle,buttons:[{text:this.msg.close,click:this.toHandler(function(){if(!this.dirty){this._closeSettings();
return}if(!this.settingsConfirmDialogJQ){this.settingsConfirmDialogJQ=this.settingsJQ.find(".settings_close.warning-content");
this.settingsConfirmDialogJQ.diy_confirmationDialog({buttons:[{text:apsinth.msg.main_MessageDialog.abort,click:this.toHandler(function(){this.settingsConfirmDialogJQ.diy_confirmationDialog("close")
},this),"class":"button-cancel"},{text:apsinth.msg.main_MessageDialog.discard,click:this.toHandler(function(){this._closeSettings();
this.settingsConfirmDialogJQ.diy_confirmationDialog("close")},this)}]})}else{this.settingsConfirmDialogJQ.diy_confirmationDialog("open")
}},this),"class":"button-cancel"},{text:apsinth.msg.main_MessageDialog.save,click:this.toHandler(function(d){this._settingsFormSubmit()
})}]}});this.settingsLayer.getContent().addClass("pp-settings-dialog-content");this.settingsLayer.showAbove(c,true,-25,{minWidth:900,x:(jQuery(document).width()-800)/2,y:b.offset().top+50});
this.settingsJQ=this.settingsLayer.getContent();this.settingsJQ.html(a);cms.help.GuidedAssistant._instance._initSiteAdminButtonByClass(cms.help.GuidedAssistant.options.modulesLinkClass);
return this.settingsJQ},initSettingsHandlers:function(b){b.find('input[type="checkbox"]').diy_checkbox();
b.find('input[type="radio"]').diy_radiobox();var a=this;this.settingsTabbar=b.find("#"+this.idPrefix+"_settings_tabbar");
this.settingsTabbar.tabs();if(!b.find("#payment_type-paymentpp").attr("checked")){b.find("#pp_account_field").hide()
}b.find("#payment_type-paymentpp").click(this.toHandler(function(c){if(b.find("#payment_type-paymentpp").attr("checked")){b.find("#pp_account_field").show()
}else{b.find("#pp_account_field").hide()}}));this._shipppingCostGreyOut();b.find("input[id^='shipping_type']").click(this.toHandler(function(){this._shipppingCostGreyOut()
},this));this._shippingTaxGreyOut();b.find("input[id^='tax_calculation']").click(this.toHandler(function(){this._shippingTaxGreyOut()
},this));var a=this;this.settingsTabbar.bind("tabsselect",function(c,d){if(!a.settingsFormValidated){a._settingsFormValidate(d);
return false}else{a.settingsFormValidated=false}});if(b.find("#terms_active-no").diy_radiobox("option","checked")){b.find(".terms_field").hide()
}b.find("input[id^='terms_active']").click(function(){if(b.find("#terms_active-no").diy_radiobox("option","checked")){b.find(".terms_field").hide()
}else{b.find(".terms_field").show()}});this.setSettingsCloseHandler(b)},setSettingsCloseHandler:function(a){this.dirty=false;
a.find("input, textarea").bind("click keydown change",this.toHandler(function(){this.dirty=true},this));
a.find("#settingsForm iframe").contents().find("body").bind("click",this.toHandler(function(){this.dirty=true
},this))},_shipppingCostGreyOut:function(){if(this.settingsJQ.find("#shipping_type-perorder").attr("checked")){this.settingsJQ.find("#shipping_cnd_from").removeAttr("disabled");
this.settingsJQ.find("#shipping_cnd_free").removeAttr("disabled")}else{this.settingsJQ.find("#shipping_cnd_from").attr("disabled","disabled");
this.settingsJQ.find("#shipping_cnd_free").attr("disabled","disabled")}},_shippingTaxGreyOut:function(){if(this.settingsJQ.find("#tax_calculation_yes").length==0){return true
}if(this.settingsJQ.find("#tax_calculation_yes").diy_radiobox("option","checked")){this.settingsJQ.find("#shipping_taxContainerSelection").find(":diy-checkbox").diy_checkbox("option","disabled",false);
jQuery(".calculate_tax").hide()}else{this.settingsJQ.find("#shipping_taxContainerSelection").find(":diy-checkbox").diy_checkbox("option","disabled",true);
this.settingsJQ.find("#tax_calculation_no").diy_radiobox("option","checked",true);jQuery(".calculate_tax").show()
}},_closeSettings:function(){try{tinyMCE.execCommand("mceRemoveControl",false,this.maileditorId);tinyMCE.execCommand("mceCleanup",false,this.maileditorId)
}catch(a){}try{tinyMCE.execCommand("mceRemoveControl",false,this.termseditorId);tinyMCE.execCommand("mceCleanup",false,this.maileditorId)
}catch(a){}try{tinyMCE.execCommand("mceRemoveControl",false,this.ackeditorId);tinyMCE.execCommand("mceCleanup",false,this.maileditorId)
}catch(a){}this.settingsLayer.hide();this.settingsActive=false},_setLayout:function(b){var a=this.toHandler(this.refreshMainView);
var c=this.getConfigJQ();this.layout=b;c.find("a[class^='switch-layout']").removeClass("active");c.find("a.switch-layout"+b).addClass("active");
a()},_onSettingsTabChange:function(a){},_showExtraInfo:function(b){var d=this.getMainJQ();var a=false;
if(d.find(".product-presentation.product-presentation-preview").length){var c=d.find(".product-presentation.product-presentation-preview").width();
if(c===430){a=true}}var e=(this.mode=="admin"?this.getConfigData():{});if(b){e.thumbsMediumSmall=a;e.viewMode="full"
}if(typeof(d.data("showAll"))!=="undefined"&&d.data("showAll")!=null&&e.viewMode=="full"&&this.mode!="admin"){d.html(d.data("showAll"));
if(a===true){d.find(".product-presentation-2 .thumbs a").addClass("medium_small")}this._setupMainView()
}else{if(typeof(d.data("showPart"))!="undefined"&&d.data("showAll")!=null&&e.viewMode!="full"&&this.mode!="admin"){d.html(d.data("showPart"));
this._setupMainView()}else{this.callRpc("public.viewMain",e,function(f,g){if(!g&&f.html){this.detailVisible=b;
d.html(f.html);if(e.viewMode=="full"){d.data("showAll",f.html)}else{d.data("showPart",f.html)}this._setupMainView();
if(a===true){d.find(".product-presentation-2 .thumbs a").addClass("medium_small")}}},this)}}},_setupMainView:function(){var c=this.getMainJQ();
var d=c.find(".description");var b=c.find(".product-presentation");var a=b.hasClass("product-presentation-1");
this._attachMainViewEventHandlers()},_attachImageLightbox:function(a){if(jQuery.fn.tinyLightbox){a.tinyLightbox({item:"a.showOriginalImage",pathAttr:"href",descrAttr:"title",keyNavigation:false,hideNavigation:true})
}},_attachMainViewEventHandlers:function(){var d=this.getMainJQ();var i=this;d.find(".moreinfo").click(this.toHandler(function(j){this._showExtraInfo(true);
j.preventDefault()}));d.find(".lessinfo").click(this.toHandler(function(j){this._showExtraInfo(false);
j.preventDefault()}));var h=d.find(".product-presentation");var c=h.find(".lightboxData img");var e=h.find(".thumbs a");
var a=h.find(".default_image");var b=h.hasClass("product-presentation-2");this._attachImageLightbox(h);
if(!b){var g=a.parent().attr("index",0).click(this.toHandler(function(k){var j=jQuery(k.currentTarget).attr("index");
d.find(c.get(j)).click();k.preventDefault()}));d.find("a.showOriginalImage").click(this.toHandler(function(j){}))
}var f=null;if(b){f=this.toHandler(function(j){this.showImage(jQuery(j.currentTarget));j.preventDefault()
},this)}else{f=this.toHandler(function(j){a.attr("src",jQuery(j.currentTarget).attr("href"));g.attr("index",jQuery(j.currentTarget).data("index"));
e.removeClass("active");var k=d.find("a.showOriginalImage");k.removeClass("active");jQuery(j.currentTarget).addClass("active");
k.attr("href",jQuery(j.currentTarget).attr("href").replace(/\d+x\d+_/,"800x600_"));k.attr("title",jQuery(j.currentTarget).attr("title"));
k.find("img").attr("alt",jQuery(j.currentTarget).find("img").attr("alt"));this._attachImageLightbox(h);
j.preventDefault()},this)}e.each(function(j){jQuery(this).data("index",j);jQuery(this).click(f)});if(d.find("a:[id^='pid']").attr("href")!=="javascript:"){d.find("a:[id^='pid']").attr("href",this._getSSHHref(false)).click(this.toHandler(function(k){k.preventDefault();
var j=jQuery(k.currentTarget).attr("id").split("_");i._addToCart(j[1],1)}))}},galleryCallback:function(a,b){if(b.success){a.postUpload();
a.refreshMainView()}else{gbUploadJQ.html("fehler")}},getTextareaId:function(){return this.textareaId},refreshMainView:function(){var a=this;
this.showLoading();var b=(this.mode=="admin"?this.getConfigData():{});if(this.detailVisible){b.viewMode="full"
}this.reloadMainView(b,function(){a._setupMainView();a.hideLoading()})},getConfigData:function(){tinyMCE.get(this.textareaId).save();
var d=this.getConfigJQ();var c=(d.find('[name="description"]').val()).replace("<del></del>","");var b={name:d.find('input[name="name"]').val(),headline_type:d.find('input[name="headline_type"]:checked').val()||"",description:c,price:d.find('input[name="price"]').val(),show_shoppingbasket_button:d.find('input[name="show-shoppingbasket-button"]:checked').val(),price_info:d.find('input[name="price_info"]').val(),images:{id:[],caption:[],alttag:[],ordering:[]},keywords:{id:[],value:[]}};
if(typeof d.find('input[name="tax"]').val()=="undefined"){b.tax=0}else{b.tax=d.find('input[name="tax"]').val()
}d.find(".detailview").each(function(e){b.images.id[e]=jQuery("input[name='image_id']",this).val();b.images.caption[e]=jQuery("input[name='image_caption']",this).val();
b.images.alttag[e]=jQuery("input[name='image_alttag']",this).val();b.images.ordering[e]=e});var a=d.find('select[name="value[]"]');
d.find("input[name='active[]']").map(function(e){if(jQuery(this).is(":checked")){b.keywords.id.push(jQuery(this).val());
b.keywords.value.push(jQuery(":selected",a[e]).val())}});if(this.layout!==null){b.layout=this.layout}return b
},showOriginalImage:function(){var b=this.getMainJQ();var a=b.find("a.active");this.showImage(a[0])},showImage:function(c){var a=c.attr("href"),e=c.attr("title"),b=this.getMainJQ();
a=a.replace(/\d+x\d+_/,"800x600_");this.originalImageLayer=new apsinth.util.Layer(null,{zIndex:100000});
this.originalImageJQ=this.originalImageLayer.getContent();this.originalImageJQ.append('<div class="originalImageLayer" style="margin: auto;"><img class="origImg" src="'+a+'" /><span>'+e+'</span><a class="ccclose">'+this.msg_main.close+"</a></div>");
var d=b.offset();this.originalImageLayer.show({centerX:true,y:document.documentElement.scrollTop+10,reposition:true});
this.originalImageJQ.find(".ccclose").click(this.toHandler(function(f){this.originalImageLayer.hide()
}))},selectTemplate:function(b){var a=this;var c=a.getConfigJQ();if(a.busy){return false}a.busy=true;
a.showConfigLoading();this.showLoading();this.callRpc("private.viewTemplate",{type:b},function(e,d){a.busy=false;
a.hideConfigLoading();if(e){a.selectTemplateLayer=new apsinth.util.Layer(null,{usingUiDialog:true,zIndex:100000,dlgOptions:{title:a.msg[b+"-template-header"],buttons:[{text:apsinth.msg.main_MessageDialog.cancel,click:a.toHandler(function(){a.selectTemplateLayer.hide();
a.selectTemplateJQ=null}),"class":"button-cancel"},{text:apsinth.msg.main_MessageDialog.save,click:a.toHandler(function(g){var f=a.selectTemplateJQ.find('input[name="template_id"]:checked').val();
if(f){a.saveTemplate(b,f)}else{a.selectTemplateLayer.hide();a.selectTemplateJQ=null}}),id:a.idPrefix+"_save_template_btn"}]}});
a.selectTemplateJQ=a.selectTemplateLayer.getContent();a.selectTemplateJQ.addClass("pp-templates-dialog-content");
a.selectTemplateJQ.data("ownerModule",a);a.selectTemplateJQ.append(e.html);a.selectTemplateLayer.showAbove(c,true,-25,{minWidth:425});
a.selectTemplateSaveButton=jQuery("#"+a.idPrefix+"_save_template_btn");a.selectTemplateSaveButton.hide();
a.selectTemplateJQ.find('input[name="template_id"]').diy_radiobox().click(a.toHandler(function(f){a.selectTemplateSaveButton.show()
}))}a.hideLoading();if(a.trigger instanceof Function){a.trigger("onload",this)}})},confirmTemplateChange:function(b,a){if(confirm(this.msg.override)){this.saveTemplate(b,a)
}else{this.selectTemplateLayer.hide();this.selectTemplateJQ=null}},saveTemplate:function(c,b){var a=this;
var d=this.getConfigJQ();this.callRpc("private.templates",{type:c,template_id:b},function(f,e){if(!e){a.selectTemplateLayer.hide();
a.selectTemplateJQ=null;a.refreshMainView();a.callRpc("private.config",{read:true},function(h,g){if(!g){d.find('input[name="name"]').val(h.name);
tinyMCE.get(a.textareaId).setContent(h.description);a.viewSearchKeywords()}if(a.trigger instanceof Function){a.trigger("onload",this)
}})}})},postUpload:function(){var a=this;if(a.uploadLayer!==null){a.uploadLayer.hide();a.uploadLayer=null
}var b=this.getConfigJQ();this.callRpc("private.viewUpload",{},function(d,e){if(!e){a.view_upload.html(d.html);
if(b.find(".detailview").size()==0){a.view_upload.html(a.msg.textNoImagesPresent)}else{if(b.find(".detailview").size()>=5){b.find("#productPresentationUpload").hide();
b.find("#productPresentationImageLimit").show()}var g=b.find(".detailview");if(g.size()>=5){b.find("#productPresentationUpload").hide();
b.find("#productPresentationImageLimit").show()}}var h=function(i,j){return a.toHandler(function(k){if(a.rotateInProgress){return
}a.rotateInProgress=true;a.showConfigLoading();a.rotateImage(jQuery(k.target).attr("imgId"),j,function(){a.hideConfigLoading();
a.rotateInProgress=false});k.preventDefault()})};var f=jQuery(".rotate-l",a.view_upload);f.click(h(f,-90));
var c=jQuery(".rotate-r",a.view_upload);c.click(h(c,90));jQuery(".delete",a.view_upload).click(a.toHandler(function(i){a.deleteImage(jQuery(i.currentTarget).attr("imgId"));
i.preventDefault()}));jQuery(".edit",a.view_upload).click(a.toHandler(function(i){a.editImage(jQuery(i.currentTarget).attr("imgId"));
i.preventDefault()}));jQuery(".img-up",a.view_upload).click(a.toHandler(function(k){var j=jQuery(k.currentTarget).parent().parent();
var i=j.prev();i.insertAfter(j);k.preventDefault()}));jQuery(".img-down",a.view_upload).click(a.toHandler(function(k){var j=jQuery(k.currentTarget).parent().parent();
var i=j.next();i.insertBefore(j);k.preventDefault()}));jQuery(".sortable",a.view_upload).sortable({opacity:0.7,helper:"original",tolerance:"pointer"})
}})},rotateImage:function(b,d,f,c){var a=this;var e=this.getConfigJQ();this.callRpc("private.img",{action:"rotate",degree:d,imageId:b},function(i,h){if(!h){var g=e.find("#img_"+b);
g.attr("src",g.attr("src").split("?")[0]+"?"+Math.random());a.refreshMainView()}if(f){f.apply(c||a,arguments)
}})},deleteImage:function(b){var a=this;var c=this.getConfigJQ();this.callRpc("private.img",{action:"delete",imageId:b},function(e,d){if(!d){c.find("#col_"+b).remove();
if(c.find(".detailview").size()<5){c.find("#productPresentationUpload").show();c.find("#productPresentationImageLimit").hide();
if(c.find(".detailview").size()==0){a.view_upload.html(a.msg.textNoImagesPresent)}}a.refreshMainView()
}})},editImage:function(b){var a=this;if(window.diy.cms.PictureManipulation){window.diy.cms.PictureManipulation.show({load:{type:"remote",moduleId:a.moduleId,moduleName:"product_presentation",instanceId:a.instance_id,imageId:b}})
}},viewUpdateCallback:function(){this.postUpload();this.refreshMainView()},viewSearchKeywords:function(){var c=this.getConfigJQ();
var b=c.find("#"+this.idPrefix+"_editSettings");var a=function(){this.unbind("saveSettings",a,this);this.viewSearchKeywords()
};this.callRpc("private.viewArticleKeywords",{},function(e,d){if(!d){b.html(e.html);b.find('input[type="checkbox"]').diy_checkbox();
b.find("select").parent().diy_combobox({editable:false});b.find("a").click(this.toHandler(function(){this.showSettings("search-keys-tab")
}));this.bind("saveSettings",a,this)}},this)},searchCriteriaHandler:function(a){this.general_value='<div class="form-item keyword_container clearfix"><input type="text" class="keyword_value" name="" value=""/><button class="keyword_delete"></button></div>';
a.find(".criteria-value-col").each(this.toHandler(function(c,b){this.searchCriteriaKeywordHandler(jQuery(b))
},this))},searchCriteriaKeywordHandler:function(c){var a=this;var e=function(){var f=jQuery(this).parents(".criteria-value-col").find(".keyword_delete");
if(f.length==2){f.button("option","disabled",true)}jQuery(this).parents(".form-item").remove()};var d=c.find(".keyword_delete");
var b=d.length==1;d.addClass(" ui-button-borderless").button({text:false,disabled:b,icons:{primary:"ui-icon-trash"}}).click(e);
c.find(".keyword_add").button({icons:{primary:"ui-icon-plusthick"}}).click(function(h){h.preventDefault();
var g=jQuery(this).parents(".form-item");g.before(a.general_value);var f=g.prev(".form-item");f.find(".keyword_value").attr("name",g.parent().attr("data-params")).val("");
f.find(".keyword_delete").addClass(" ui-button-borderless").button({text:false,disabled:b,icons:{primary:"ui-icon-trash"}});
jQuery(this).parents(".criteria-value-col").find(".keyword_delete").button("option","disabled",false);
f.find(".keyword_delete").click(e)})},getSession:function(){var b="DIY_SB=";var a=document.cookie.split(";");
for(var d=0;d<a.length;d++){var e=a[d];while(e.charAt(0)==" "){e=e.substring(1,e.length)}if(e.indexOf(b)==0){return e.substring(b.length,e.length)
}}return null},onFlashUploadDone:function(){try{this.refreshMainView();this.postUpload()}catch(a){this.onError("Handling upload done failed",a)
}},onFlashUploadCancel:function(){try{this.uploadLayer.hide()}catch(a){this.onError("Handling upload cancel failed",a)
}},onFlashUploadError:function(b,a){this.onError("Flash upload error",b,a)},sendSessionToFlashUpload:function(){var a="uploadSWF_"+this.moduleId;
var b=document[a]||window[a];b.sendSessionID(this.getSession())},_settingsFormValidate:function(b){var c=this.settingsLayer.getContent().find(".ui-tabs-panel:visible").attr("data-TabName");
var a=this.settingsLayer.getContent().find('[data-TabName="'+c+'"]');var d=this._getSettingsForm(a);this.callRpc("private.validateSettings",{tab:c,form:d},function(i,g){var f=this;
var h=jQuery("#settingsForm");h.diy_form({messageTarget:".form-error"});h.diy_form("clearErrors");if(!g&&i&&!i.errors){this.settingsFormValidated=true;
this.settingsTabbar.tabs("select",b.index)}else{var e="";jQuery.each(i.errors,function(j,k){jQuery.each(k,function(m,l){if(j!=="msg"){if(i.hook&&i.hook.id){j=i.hook.id
}f._showValidationError(j,l)}else{e+="<br />"+l}})});e&&h.diy_form("addError",e)}},this)},_showValidationError:function(d,b){var a=jQuery("#settingsForm");
var c=a.find('input[name="'+d+'"]');if(c.attr("type")=="text"&&!c.is(":diy-formField")){c.diy_textField()
}a.diy_form("addError",b,c)},_getSettingsForm:function(d){var a=this;var c={};var b;var e;inputs="input";
textareas="textarea";d.find(inputs).each(function(g,k){b=jQuery(k).attr("name");var j=false;switch(jQuery(k).attr("type")){case"checkbox":if(jQuery(k).is(":checked")){e=1
}else{e=false}break;case"radio":e=jQuery("input[name="+jQuery(k).attr("name")+"]:checked").val();break;
default:e=jQuery(k).val();j=true;break}var f=b.indexOf("[]");if(f!==-1){b=b.substr(0,f);if(typeof(c[b])!=="object"){c[b]=[]
}if(e||j){var h=jQuery(k).val();c[b].push(h)}}else{c[b]=e}});c.email_template=a.maileditor.getText();
c.terms=tinyMCE.get(a.termseditorId).getContent();c.ack_text=tinyMCE.get(a.ackeditorId).getContent();
return c},_settingsFormSubmit:function(){var a=this;var c=this.settingsLayer.getContent();var b=this._getSettingsForm(c);
this.callRpc("private.saveSettings",{form:b},function(g,e){var f=jQuery("#settingsForm");f.diy_form({messageTarget:".form-error"});
f.diy_form("clearErrors");if(!e&&g&&!g.errors){this._closeSettings();this.trigger("saveSettings")}else{var d="";
jQuery.each(g.errors,function(h,j){jQuery.each(j,function(k,i){if(h!=="msg"){if(g.hook&&g.hook.id){h=g.hook.id
}a._showValidationError(h,i)}else{d+="<br />"+i}})});d&&f.diy_form("addError",d)}},this)},maileditor:{context:null,setupMaileditor:function(b,d){var i=this;
var a=null;var f=false;this.context=b;b.maileditorId="med"+b.moduleId+"-"+Math.floor(Math.random()*1000000);
d.find(".maileditor-area").attr("id",b.maileditorId);d.find("#"+b.maileditorId).val(this.preparePlaceholderText(d.find("#"+b.maileditorId).val()));
d.find(".maileditor-restore").val(this.preparePlaceholderText(d.find(".maileditor-restore").val()));var e=tinyMCE.settings;
tinyMCE.settings=jQuery.extend({},e,{width:750,height:280,theme_cc_toolbar_location:"none",theme_cc_statusbar_location:"none",theme_cc_resize_horizontal:false,theme_cc_resizing_use_cookie:false});
tinyMCE.execCommand("mceAddControl",false,b.maileditorId);tinyMCE.settings=e;i.setText(d.find("#"+b.maileditorId).val());
jQuery("#maileditor-placeholder-combobox").diy_combobox({editable:false,select:function(k,j){if(j.rawValue!=0){var l=j.label;
if(tinymce.isIE){tinyMCE.activeEditor.selection.moveToBookmark(a)}tinyMCE.execInstanceCommand(c,"mceInsertContent",false,i.createPlaceholderHtml(l));
if(tinymce.isIE){a=tinyMCE.get(c).selection.getBookmark("simple")}jQuery(this).diy_combobox("option","rawValue","0")
}}});d.find(".maileditor-edit-button").button();d.find(".maileditor-preview-button").button();d.find(".maileditor-reset-button").button();
var h;var g;h=function(j){j.preventDefault();d.find(".maileditor-preview").hide();d.find(".maileditor-edit-button").hide();
d.find(".maileditor-preview-button").show();d.find(".maileditor-reset-button").button("option","disabled",false);
d.find("#maileditor-placeholder-combobox").diy_combobox("option","disabled",false);tinyMCE.get(b.maileditorId).show()
};if(tinymce.isIE){tinyMCE.get(b.maileditorId).onClick.add(function(j,k){f=true});tinyMCE.get(b.maileditorId).onKeyDown.add(function(j,k){f=true
});jQuery(tinyMCE.get(b.maileditorId).contentAreaContainer).mouseleave(function(){if(f){a=tinyMCE.get(b.maileditorId).selection.getBookmark("simple")
}f=false})}g=function(j){j.preventDefault();b.showLoading();b.callRpc("private.previewMail",{emailtext:i.getText(),convertHtmlToText:true},function(l,m){var k=jQuery("iframe:[id^='med']").contents().find("p br").length;
jQuery("#settingsForm .maileditor-preview").height(k*26);d.find(".maileditor-preview").val(l);d.find(".maileditor-preview").show();
d.find(".maileditor-preview-button").hide();d.find(".maileditor-edit-button").show();d.find(".maileditor-reset-button").button("option","disabled",true);
d.find("#maileditor-placeholder-combobox").diy_combobox("option","disabled",true);tinyMCE.get(b.maileditorId).hide();
d.find(".maileditor-area").hide();b.hideLoading()})};jQuery(".maileditor-preview-button").click(g);jQuery(".maileditor-edit-button").click(h);
jQuery(".maileditor-reset-button").click(b.toHandler(function(j){j.preventDefault();if(!this.mailResetConfirmDialogJQ){this.mailResetConfirmDialogJQ=this.settingsJQ.find(".email_reset.warning-content");
this.mailResetConfirmDialogJQ.diy_confirmationDialog({buttons:[{text:apsinth.msg.main_MessageDialog.abort,click:this.toHandler(function(){this.mailResetConfirmDialogJQ.diy_confirmationDialog("close")
},this),"class":"button-cancel"},{text:apsinth.msg.main_MessageDialog.reset,click:this.toHandler(function(){tinyMCE.execInstanceCommand(this.maileditorId,"mceSetContent",false,jQuery(".maileditor-restore").val());
this.mailResetConfirmDialogJQ.diy_confirmationDialog("close")},this)}]})}else{this.mailResetConfirmDialogJQ.diy_confirmationDialog("open")
}}));var c=b.maileditorId},preparePlaceholderText:function(a){return a.replace(/\$(([a-zA-Z_]|[^\x00-\x80])+)/g,this.createPlaceholderHtml("$1"))
},finishPlaceholderText:function(b){var a=jQuery(document.createElement("div"));a.html(b);a.find("img.placeholder").each(function(){jQuery(this).replaceWith("$"+jQuery(this).attr("alt"))
});b=a.html();return b},html2Text:function(b){b.replace(/<\/div>/g,"\r\n\r\n");b.replace(/<\/p>/g,"\r\n\r\n");
b.replace(/<br>/g,"\r\n");b.replace(/<br\/>/g,"\r\n");var a=/<(?:.|\s)*?>/g;b=b.replace(a,"");b=b.replace(/&nbsp;/g," ");
b=b.replace(/&amp;/g,"&");return b},text2Html:function(a){a=a.replace(/(\r\n|[\r\n])/g,"<br/>");a=a.replace(/\s/g,"&nbsp;");
a=a.replace(/&/g,"&amp;");a=a.replace(/\t/g,"&nbsp;&nbsp;&nbsp;&nbsp;");return a},createPlaceholderHtml:function(c){var b=this.context.text2ImageUrl+"?type=gif&text=";
var a='<img class="placeholder '+c+'" alt="'+c+'" src="'+b+c+'" style="display:inline;" />';return a},getText:function(){return this.finishPlaceholderText(tinyMCE.get(this.context.maileditorId).getContent())
},setText:function(b){var a=this.preparePlaceholderText(b);jQuery("#"+this.context.maileditorId).val(a);
tinyMCE.get(this.context.maileditorId).setContent(a)}},_addToCart:function(a,b){this.callRpc("public.AddToCart",{product:[a,b]},function(d,c){if(!c&&d.status&&d.status==="OK"){window.location.href=this._getSSHHref(true)
}else{if(!this._errDlg){this._errDlg=new apsinth.util.Layer("<div>"+Error+"</div>")}this._errDlg.showAbove(this.getMainJQ(),true,this.DIALOG_DELTA_WIDTH)
}},this)},_getSSHHref:function(c){var a="";if(typeof TestingInterface==="object"){a="?mode=live&mod.locale=de_DE&module-name=shoppingbasket&basisID="+this.getBasisId()+"&page=101&toggleLinkColor=darkblue"
}else{if("undefined"!=typeof(sslServerUrl)){a=sslServerUrl}a+="/cart";if(c){var b=document.cookie.match(/(PHPSESSID|DIY_SB)=([^; ]+)/);
a+="?"+b[1]+"="+b[2]}}return a},postAction:function(a){if(a.hideShoppingCart==true){jQuery(document).trigger("diy.cms.EmotionHeader.shopHasProducts",0)
}},open:function(){this._super();tinyMCE.execCommand("mceAddControl",false,this.textareaId);if(this.mainTabbar){this.postUpload()
}},close:function(){if(typeof this.textareaId!="undefined"&&tinyMCE.get(this.textareaId)){tinyMCE.execCommand("mceRemoveControl",false,this.textareaId)
}this._super.apply(this,arguments)},onConfigSaved:function(b,a){this._super(b,a);if(b.status==="OK"){jQuery(document).trigger("diy.cms.EmotionHeader.shopHasProducts",{instance_id:this.instance_id,moduleId:this.moduleId})
}}});prodpres.msg.main_ProdPres={close:"Close"};window.prodsearch={msg:{}};var ProductSearch=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:300,msg:null,searchResultLayerVisible:false,settingsLayer:null,loadMainViewAfterSave:true,initialize:function(c,b,a,d){this._super(c,b,a,d)
},_initMainView:function(){this.msg=prodsearch.msg.conf_ProdSearch;this.msg_main=prodsearch.msg.main_ProdSearch;
var a=this;var c=this.getMainJQ();var b=c.find('form[name="search"]')[0];c.find(".error-msg").hide();
c.find('input[name="submit"]').click(this.toHandler(function(){if(a.searchResultLayerVisible){return}a.searchResultLayerVisible=true;
c.find('input[name="search"]').blur();var d=jQuery(b).formParams(false);this.callRpc("public.viewMain",d,function(f,e){if(!e){a.searchResultLayer=new apsinth.util.Layer(null,{zIndex:100000});
a.searchResultJQ=a.searchResultLayer.getContent();a.searchResultJQ.append('<div class="popup-header">'+a.msg_main.results+'</div><div class="popup-content">'+f.html+'<a class="ccclose">'+a.msg_main.close+"</a></div>");
a.searchResultLayer.show({centerX:true,centerY:true,width:600});a.searchResultJQ.find(".ccclose").click(a.toHandler(function(){a.searchResultLayer.hide();
a.searchResultJQ=null;a.searchResultLayerVisible=false}))}})}))},_initConfigView:function(){var a=this;
var b=this.getConfigJQ();b.find(".add_keyword").button().click(this.toHandler(function(c){this.editKeywords(this.toHandler(this.reloadMainView));
c.preventDefault()}));b.find('#set_search_options_checkboxes input[type="checkbox"]').diy_checkbox()},validateConfig:function(){var c=this.getConfigData();
var b=Number(c.show_search_field)+Number(c.detail_search)+Number(c.show_sorting);var d=this.getConfigJQ();
var a=d.find("form");a.diy_form({messageTarget:"#custom_error_placeholder"});if(b){a.diy_form("clearErrors");
return true}a.diy_form("addError",d.find(".error-msg").html());return false},getConfigData:function(){var c=this.getConfigJQ();
var b={show_search_field:c.find('input[name="show_search_field"]:checked').val()||"",detail_search:c.find('input[name="detail_search"]:checked').val()||"",show_sorting:c.find('[name="show_sorting"]:checked').val()||""};
var a=[];c.find('input[name="selectedKeywords"]:checked').each(function(){a.push(jQuery(this).val())});
b.searchKeywords=a;return b},$:function(a){return jQuery(a,this.modul)},editKeywords:function(b){var a=this;
this.callRpc("private.viewKeyword",{},function(d,c){if(!c&&null===a.settingsLayer){var e=a.showSettingsLayer(d.html,b);
a.searchCriteriaHandler(e.find("div.product-search-keyword"))}})},showSettingsLayer:function(b,e){var d=this.getConfigJQ();
var c=this.getMainJQ();var a=this;this.settingsLayer=new apsinth.util.Layer(null,{usingUiDialog:true,zIndex:100000,dlgOptions:{title:this.msg["edit-keywords"],closeOnEscape:false,buttons:[{text:this.msg.close,click:this.toHandler(function(){this.settingsLayer.hide();
this.settingsLayer=null;return},this),"class":"button-cancel"},{text:this.msg.ok,click:this.toHandler(function(g){var f={};
jQuery("#product-search-keyword-form input").each(function(k,m){var n=jQuery(m).val();var j=jQuery(m).attr("name");
var h=j.indexOf("[]");if(h!==-1){j=j.substr(0,h);if(typeof(f[j])!=="object"){f[j]=[]}var l=jQuery(m).val();
f[j].push(l)}else{f[j]=n}});this.callRpc("private.keyword",{form:f},function(i,h){if(!h){a.settingsLayer.hide();
a.settingsLayer=null;if(e){e(i)}}})})}]}});this.settingsLayer.getContent().addClass("pp-settings-dialog-content");
this.settingsLayer.showAbove(d,true,-25,{width:485,x:(jQuery(document).width()-485)/2,y:c.offset().top});
this.settingsJQ=this.settingsLayer.getContent();this.settingsJQ.html(b);cms.help.GuidedAssistant._instance._initSiteAdminButtonByClass(cms.help.GuidedAssistant.options.modulesLinkClass);
return this.settingsJQ},searchCriteriaHandler:function(a){this.general_value=a.find(".criteria-value-col .keyword_container")[0].outerHTML;
a.find(".criteria-value-col").each(this.toHandler(function(c,b){this.searchCriteriaKeywordHandler(jQuery(b))
},this))},searchCriteriaKeywordHandler:function(c){var a=this;var e=function(){var f=jQuery(this).parents(".criteria-value-col").find(".keyword_delete");
if(f.length==2){f.button("option","disabled",true)}jQuery(this).parents(".form-item").remove()};var d=c.find(".keyword_delete");
var b=d.length==1;d.addClass(" ui-button-borderless").button({text:false,disabled:b,icons:{primary:"ui-icon-trash"}}).click(e);
c.find(".keyword_add").button({icons:{primary:"ui-icon-plusthick"}}).click(function(h){h.preventDefault();
var g=jQuery(this).parents(".form-item");g.before(a.general_value);var f=g.prev(".form-item");f.find(".keyword_value").attr("name",g.parent().attr("data-params")).val("");
f.find(".keyword_delete").addClass(" ui-button-borderless").button({text:false,disabled:b,icons:{primary:"ui-icon-trash"}});
jQuery(this).parents(".criteria-value-col").find(".keyword_delete").button("option","disabled",false);
f.find(".keyword_delete").click(e)})}});prodsearch.msg.main_ProdSearch={close:"close",results:"Search Results"};
window.evtcal={util:{},main:{},config:{},msg:{}};evtcal.msg.util_DateField={"date-field-format":"MM/dd/yyyy","date-field-format.jquery":"mm/dd/yy","error.enter-date":"Please enter a date. Example:",none:"none","no-endDate":"No end date"};
evtcal.msg.util_DateFormat={"day-name.abbreviated.0":"Sun","day-name.abbreviated.1":"Mon","day-name.abbreviated.2":"Tue","day-name.abbreviated.3":"Wed","day-name.abbreviated.4":"Thu","day-name.abbreviated.5":"Fri","day-name.abbreviated.6":"Sat","day-name.wide.0":"Sunday","day-name.wide.1":"Monday","day-name.wide.2":"Tuesday","day-name.wide.3":"Wednesday","day-name.wide.4":"Thursday","day-name.wide.5":"Friday","day-name.wide.6":"Saturday","day-name.narrow.0":"S","day-name.narrow.1":"W","day-name.narrow.2":"T","day-name.narrow.3":"W","day-name.narrow.4":"T","day-name.narrow.5":"F","day-name.narrow.6":"S","month-name.abbreviated.1":"Jan","month-name.abbreviated.2":"Feb","month-name.abbreviated.3":"Mar","month-name.abbreviated.4":"Apr","month-name.abbreviated.5":"May","month-name.abbreviated.6":"Jun","month-name.abbreviated.7":"Jul","month-name.abbreviated.8":"Aug","month-name.abbreviated.9":"Sep","month-name.abbreviated.10":"Oct","month-name.abbreviated.11":"Nov","month-name.abbreviated.12":"Dec","month-name.wide.1":"January","month-name.wide.2":"February","month-name.wide.3":"March","month-name.wide.4":"April","month-name.wide.5":"May","month-name.wide.6":"June","month-name.wide.7":"July","month-name.wide.8":"August","month-name.wide.9":"September","month-name.wide.10":"October","month-name.wide.11":"November","month-name.wide.12":"December"};
evtcal.msg.util_FormUtil={"error-hint":"Please correct your entries","error.enter-text":"Please enter a text.","error.enter-int":"Please enter a number"};
evtcal.msg.util_TimeField={"time-combo-format":"hh:mm a","time-field-format":"h:mm a","no-time":"none","error.enter-time":"Please enter a time. Example:"};
evtcal.msg.util_RepetitionField={none:"Once",daily:"Daily",weekly:"Weekly",biweekly:"Every 14 days",monthly:"Monthly",yearly:"Yearly"};
evtcal.msg.main_EventDialog={close:"Close"};evtcal.msg.main_ImageDialog={close:"Close"};evtcal.msg.main_ListItem={"date-format":"EEEE, MMMM d","time-format":"h:mm a",until:"to","edit-button":"Edit Event","delete-button":"Delete event"};
evtcal.msg.main_ListView={"month-title-dateformat":"MMMM yyyy","no-events":"No appointments available","no-event-planned":"No appointments have been planned for this month yet"};
evtcal.msg.main_MonthView={"month-title-dateformat":"MMMM yyyy","dayname-dateformat":"EEE","weekname-dateformat":"'CW' w","prev-month":"Last month","next-month":"Next month",event:"Appointment",events:"Event"};
evtcal.msg.main_WeekView={"show-in-dlg":"Full-screen","go-to-week":"Go to week...","week-title-dateformat":"MMMM d yyyy","week-title-dateformat-short":"MM/dd/yy","dayname-dateformat":"EEE, MM dd","dayname-dateformat-short":"EEE, dd.","daytime-dateformat":"hh:mm a","duration-dateformat":"EEE, h:mm a"};
evtcal.msg.main_WeekViewDialog={close:"Close"};var EventCalendar=apsinth.ApsinthModule.extend({_EventModel:null,_events:null,loadMainViewAfterSave:false,_initMainView:function(){if(this._mainView!=null){throw new Error("Main view is already initialized")
}try{this._EventModel=evtcal.main.EventModel;this._events=this.data.events;this._convertDates();this._model=new this._EventModel(this);
this._model.setData(this._events,this.data.config);var b=this.getMainJQ().children(".event-calendar");
this._model.imgPath=this.getUploadUrl();this._mainView=new evtcal.main.MainView(b,this._model)}catch(a){apsinth.util.ErrorUtil.onError(a)
}},_convertDates:function(){for(var c=0,b=this._events.length,a;c<b;c++){a=this._events[c];a.fromDate=this._EventModel.isoStrToDate(a.fromDate);
a.toDate=this._EventModel.isoStrToDate(a.toDate);a.repetitionEndDate=this._EventModel.isoStrToDate(a.repetitionEndDate)
}},_initConfigView:function(){if(this._mainView==null){throw new Error("Main view must be initialized first")
}if(this._configView!=null){throw new Error("Config view is already initialized")}try{evtcal.util.DateField.EMPTY_IMG_URL=this.getFilesUrl("img/empty.gif");
var b=this.getConfigJQ().find(".evtcal-config-view:first");this._configView=new evtcal.config.ConfigView(b,this._mainView,this._model)
}catch(a){apsinth.util.ErrorUtil.onError(a)}},onDelete:function(){jQuery(".evtcal-edit-dlg").hide()},getConfigData:function(){this._lastConfigData=this._configView.getDataChanges();
return this._lastConfigData},onConfigSaved:function(g,a){if(a==null){var f=g.data;if(f.events.length!=this._lastConfigData.eventChanges.length){throw new Error("Server response doesn't match to the sent changes")
}else{for(var b=0;b<this._lastConfigData.eventChanges.length;b++){var e=this._lastConfigData.eventChanges[b];
var c=(e.tempId!=null)?e.tempId:e.id;var d=this._model.getEventById(c);if(d){d.imageChanged=false}if(e.tempId!=null){this._model.setEventId(e.tempId,f.events[b].id)
}}this._configView.resetChanges()}this._lastConfigData=null;apsinth.ApsinthModule.prototype.onConfigSaved.apply(this,arguments)
}},_checkForServerError:function(b,c){if(c=="success"){c=null}var a=null;if(c){a=c}else{if(b==null){a="no data provided"
}else{if(b.errorMsg){a="Server-side error: "+b.errorMsg}}}if(a){apsinth.util.ErrorUtil.onError(new Error("Calling server failed: "+a))
}return a!=null},viewUpdateCallback:function(b,a){this._configView._editEventDlg._imageChanged=true;this._configView._editEventDlg._updateImageThumbnail(a)
},uploadStart:function(){var b=this;var c=jQuery(document.body).find("#event-upload-dlg");var a=c.find("#evtcal_uploadForm_"+this.moduleId);
a.diy_form("clearErrors");c.loadingBox().show()},uploadComplete:function(b){var a=this;var c=a._configView._editEventDlg.uploadJQ.find("#event-upload-dlg");
c.loadingBox().hide();a._configView._editEventDlg._uploadStatus="ok";a._configView._editEventDlg._imageExt=b.data.extension;
if(b.data.isNew!=0){a._configView._editEventDlg._eventId=b.data.isNew;a._configView._editEventDlg._eventInfo.id=b.data.isNew
}a._configView._editEventDlg.uploadLayer.hide();a._configView._editEventDlg._onSaveClicked()},uploadError:function(c){var d=this._configView._editEventDlg.uploadJQ.find("#event-upload-dlg");
d.loadingBox().hide();var a=d.find("#evtcal_uploadForm_"+this.moduleId);if(c.errors){for(var b=0;b<c.errors.length;
++b){a.diy_form("addError",c.errors[b],"#uploadWrapper_"+this.moduleId)}}},close:function(a,b){if(!this.getIsInEditMode()){return
}b=(typeof b=="undefined")||(b!==false);if(b&&this._configView){if(this._configView){this._configView.destroy()
}var d=this.getConfigData().eventChanges;var e=[];for(var c=0;c<d.length;++c){var f=d[c];if(f.id&&f.has_image&&f.imageChanged){e.push(f.id)
}}this.callRpc("private.canceledit",{events:e})}this._super.apply(this,arguments)}});evtcal.EventCalendar=EventCalendar;
var clazz=evtcal.EventCalendar;clazz.DEFAULT_COLOR_LIGHT="#eaeaea";clazz.FIRST_DAY_IN_WEEK=(apsinth.lang=="en_US")?0:1;
evtcal.util.LangUtil={removeFromArr:function(a,c){var b=this.arrIndexOf(a,c);if(b!=-1){a.splice(b,1)}},arrIndexOf:function(a,d){for(var c=0,b=a.length;
c<b;c++){if(a[c]==d){return c}}return -1},cloneMap:function(a){var b={};jQuery.each(a,function(c,d){b[c]=d
});return b}};evtcal.util.DateFormat=function(a){if(a==null){throw new Error("format is null")}this._format=a
};var clazz=evtcal.util.DateFormat;var proto=clazz.prototype;proto.msg=evtcal.msg.util_DateFormat;clazz.ASSUME_YEAR_2000_THRESHOLD=30;
clazz.AM_MARKER="am";clazz.PM_MARKER="pm";clazz._initParseRules=function(){var e=evtcal.util.DateFormat;
if(e._parseRules!=null){return}e._parseRules=[];var b=function(h,i){i=parseInt(i,10);if(i<e.ASSUME_YEAR_2000_THRESHOLD){i+=2000
}else{if(i<100){i+=1900}}h.year=i};var d=function(h,i){h.month=parseInt(i,10)-1};var a=function(h,i){h.ispm=(i==e.PM_MARKER)
};var g=function(h,i){h.hour=parseInt(i,10)%24};var c=function(h,i){h.hour=parseInt(i,10)%12};var f=function(h,i){return
};e._parseRules.push({pattern:"yyyy",regex:"(\\d\\d(\\d\\d)?)",groups:2,manipulator:b});e._parseRules.push({pattern:"yy",regex:"(\\d\\d)",manipulator:b});
e._parseRules.push({pattern:"M",regex:"(\\d\\d?)",manipulator:d});e._parseRules.push({pattern:"MM",regex:"(\\d\\d?)",manipulator:d});
e._parseRules.push({pattern:"dd",regex:"(\\d\\d?)",field:"day"});e._parseRules.push({pattern:"d",regex:"(\\d\\d?)",field:"day"});
e._parseRules.push({pattern:"a",regex:"("+e.AM_MARKER+"|"+e.PM_MARKER+")",manipulator:a});e._parseRules.push({pattern:"HH",regex:"(\\d\\d?)",field:"hour"});
e._parseRules.push({pattern:"H",regex:"(\\d\\d?)",field:"hour"});e._parseRules.push({pattern:"kk",regex:"(\\d\\d?)",manipulator:g});
e._parseRules.push({pattern:"k",regex:"(\\d\\d?)",manipulator:g});e._parseRules.push({pattern:"KK",regex:"(\\d\\d?)",field:"hour"});
e._parseRules.push({pattern:"K",regex:"(\\d\\d?)",field:"hour"});e._parseRules.push({pattern:"hh",regex:"(\\d\\d?)",manipulator:c});
e._parseRules.push({pattern:"h",regex:"(\\d\\d?)",manipulator:c});e._parseRules.push({pattern:"mm",regex:"(\\d\\d?)",field:"min"});
e._parseRules.push({pattern:"m",regex:"(\\d\\d?)",field:"min"});e._parseRules.push({pattern:"ss",regex:"(\\d\\d?)",field:"sec"});
e._parseRules.push({pattern:"s",regex:"(\\d\\d?)",field:"sec"});e._parseRules.push({pattern:"SSS",regex:"(\\d\\d?\\d?)",field:"ms"});
e._parseRules.push({pattern:"SS",regex:"(\\d\\d?\\d?)",field:"ms"});e._parseRules.push({pattern:"S",regex:"(\\d\\d?\\d?)",field:"ms"});
e._parseRules.push({pattern:"Z",regex:"((\\+|\\-)\\d\\d:?\\d\\d)",manipulator:f});e._parseRules.push({pattern:"z",regex:"([a-zA-Z]+)",manipulator:f})
};proto._fillNumber=function(a,b){var c=""+a;while(c.length<b){c="0"+c}return c};proto._getDayInYear=function(b){var c=new Date(b.getTime());
var a=c.getDate();while(c.getMonth()!=0){c.setDate(-1);a+=c.getDate()+1}return a};proto._thursdayOfSameWeek=function(a){return new Date(a.getTime()+(3-((a.getDay()+6)%7))*86400000)
};proto._getWeekInYear=function(a){if(apsinth.lang=="en_US"){return this._getWeekInYearUS(a)}else{return this._getWeekInYearISO(a)
}};proto._getWeekInYearUS=function(c){var b=new Date(c.getFullYear(),0,1);var f=new Date(c.getFullYear(),11,31);
var e=this._mod(b.getDay()-1,7);var a=(c-b)/86400000;var d=(f-c)/86400000;return d<7?1:Math.ceil((a+e+1)/7)
};proto._mod=function(a,b){return((a%b)+b)%b};proto._getWeekInYearISO=function(a){var d=this._thursdayOfSameWeek(a);
var b=d.getFullYear();var c=this._thursdayOfSameWeek(new Date(b,0,4));return Math.floor(1.5+(d.getTime()-c.getTime())/86400000/7)
};proto.format=function(f){var r=evtcal.util.DateFormat;var q=f.getFullYear();var l=f.getMonth();var p=f.getDate();
var g=f.getDay();var n=f.getHours();var h=f.getMinutes();var o=f.getSeconds();var b=f.getMilliseconds();
var k=f.getTimezoneOffset()/60;this._initFormatTree();var e="";for(var j=0;j<this._formatTree.length;
j++){var m=this._formatTree[j];if(m.type=="literal"){e+=m.text}else{var c=m.character;var a=m.size;var d="?";
switch(c){case"y":if(a==2){d=this._fillNumber(q%100,2)}else{if(a==4){d=q}}break;case"D":d=this._fillNumber(this._getDayInYear(f),a);
break;case"d":d=this._fillNumber(p,a);break;case"w":d=this._fillNumber(this._getWeekInYear(f),a);break;
case"E":if(a==2){d=this.getDayName("narrow",g)}else{if(a==3){d=this.getDayName("abbreviated",g)}else{if(a==4){d=this.getDayName("wide",g)
}}}break;case"M":if(a==1||a==2){d=this._fillNumber(l+1,a)}else{if(a==3){d=this.getMonthName("abbreviated",l)
}else{if(a==4){d=this.getMonthName("wide",l)}}}break;case"a":d=(n<12)?r.AM_MARKER:r.PM_MARKER;break;case"H":d=this._fillNumber(n,a);
break;case"k":d=this._fillNumber((n==0)?24:n,a);break;case"K":d=this._fillNumber(n%12,a);break;case"h":d=this._fillNumber(((n%12)==0)?12:(n%12),a);
break;case"m":d=this._fillNumber(h,a);break;case"s":d=this._fillNumber(o,a);break;case"S":d=this._fillNumber(b,a);
break;case"z":if(a==1){d="GMT"+((k<0)?"-":"+")+this._fillNumber(k)+":00"}else{if(a==2){d=r.MEDIUM_TIMEZONE_NAMES[k]
}else{if(a==3){d=r.FULL_TIMEZONE_NAMES[k]}}}break;case"Z":d=((k<0)?"-":"+")+this._fillNumber(k,2)+"00"
}e+=d}}return e};proto.parse=function(d){this._initParseFeed();var a=this._parseFeed.regex.exec(d);if(a==null){throw new Error("Date string '"+d+"' does not match the date format: "+this._format)
}var b={year:1970,month:0,day:1,hour:0,ispm:false,min:0,sec:0,ms:0};var e=1;for(var f=0;f<this._parseFeed.usedRules.length;
f++){var h=this._parseFeed.usedRules[f];var j=a[e];if(h.field!=null){b[h.field]=parseInt(j,10)}else{h.manipulator(b,j)
}e+=(h.groups==null)?1:h.groups}var g=(b.ispm)?(b.hour+12):b.hour;var c=new Date(b.year,b.month,b.day,g,b.min,b.sec,b.ms);
if(b.month!=c.getMonth()||b.year!=c.getFullYear()){throw new Error("Error parsing date '"+d+"': the value for day or month is too large")
}if(g!=c.getHours()||b.min!=c.getMinutes()){throw new Error("Error parsing date '"+d+"': the value for hour or minute is too large")
}return c};proto._initFormatTree=function(){if(this._formatTree!=null){return}this._formatTree=[];var d;
var c=0;var g="";var f=this._format;var e="default";var b=0;while(b<f.length){var h=f.charAt(b);switch(e){case"quoted_literal":if(h=="'"){if(b+1>=f.length){b++;
break}var a=f.charAt(b+1);if(a=="'"){g+=h;b++}else{b++;e="unkown"}}else{g+=h;b++}break;case"wildcard":if(h==d){c++;
b++}else{this._formatTree.push({type:"wildcard",character:d,size:c});d=null;c=0;e="default"}break;default:if((h>="a"&&h<="z")||(h>="A"&&h<="Z")){d=h;
e="wildcard"}else{if(h=="'"){if(b+1>=f.length){g+=h;b++;break}var a=f.charAt(b+1);if(a=="'"){g+=h;b++
}b++;e="quoted_literal"}else{e="default"}}if(e!="default"){if(g.length>0){this._formatTree.push({type:"literal",text:g});
g=""}}else{g+=h;b++}break}}if(d!=null){this._formatTree.push({type:"wildcard",character:d,size:c})}else{if(g.length>0){this._formatTree.push({type:"literal",text:g})
}}};proto._initParseFeed=function(){if(this._parseFeed!=null){return}var k=this._format;var m=evtcal.util.DateFormat;
m._initParseRules();this._initFormatTree();var p=[];var d="^";for(var n=0;n<this._formatTree.length;n++){var f=this._formatTree[n];
if(f.type=="literal"){d+=apsinth.util.TextUtil.escapeRegexpChars(f.text)}else{var b=f.character;var a=f.size;
var h;for(var j=0;j<m._parseRules.length;j++){var e=m._parseRules[j];if(b==e.pattern.charAt(0)&&a==e.pattern.length){h=e;
break}}if(h==null){var o="";for(var c=0;c<a;c++){o+=b}throw new Error("Malformed date format: "+k+". Wildcard "+o+" is not supported")
}else{p.push(h);d+=h.regex}}}d+="$";var g;try{g=new RegExp(d)}catch(l){throw new Error("Malformed date format: "+k)
}this._parseFeed={regex:g,usedRules:p,pattern:d}};proto.getDayName=function(b,a){return this.msg["day-name."+b+"."+a]
};proto.getMonthName=function(a,b){return this.msg["month-name."+a+"."+(b+1)]};clazz.getDayNamesMin=function(){var c=evtcal.msg.util_DateFormat;
var a=[];for(var b=0;b<7;b++){a.push(c["day-name.abbreviated."+b])}return a};clazz.getMonthNames=function(){var c=evtcal.msg.util_DateFormat;
var a=[];for(var b=1;b<=12;b++){a.push(c["month-name.wide."+b])}return a};evtcal.main.EventDialog=function(a,b){apsinth.util.Layer.call(this,null,{zIndex:130});
var f=this.getContent();f.addClass("event-calendar").addClass("evtcal-event-dlg").html('<div></div><a class="ccclose">'+this.msg.close+"</a>");
var e=f.children("div:first");var d=b.getColorCodesAsMap();var c=new evtcal.main.ListItem(e,a,b);c.setShowDetails(true,false);
f.find(".ccclose").click(this.toHandler(this.hide))};var clazz=evtcal.main.EventDialog;var proto=clazz.prototype=new apsinth.util.Layer(false);
proto.constructor=clazz;proto.msg=evtcal.msg.main_EventDialog;evtcal.main.EventModel=function(a){apsinth.util.EventingMixin.mixin(this);
this._module=a};var clazz=evtcal.main.EventModel;var proto=clazz.prototype;clazz.dateToKey=function(a){return a.getFullYear()*10000+a.getMonth()*100+a.getDate()
};clazz.keyToDate=function(b){var c=Math.floor(b/10000);var d=Math.floor(b/100)%100;var a=b%100;return new Date(c,d,a)
};clazz.isoStrToDate=function(a){return(a==null)?null:new Date(parseInt(a.substring(0,4),10),parseInt(a.substring(5,7),10)-1,parseInt(a.substring(8,10),10))
};clazz._isoStrFormat=new evtcal.util.DateFormat("yyyy-MM-dd");clazz.dateToIsoStr=function(a){return(a==null)?null:this._isoStrFormat.format(a)
};clazz.sortEvents=function(a){a.sort(function(c,b){var d=c.fromDate.getTime()-b.fromDate.getTime();if(d==0){if(c.fromTime&&b.fromTime){return c.fromTime-b.fromTime
}else{if(c.fromTime){return 1}else{if(b.fromTime){return -1}else{return 0}}}}else{return d}})};clazz.isRepeatingEvent=function(a){return a.repetition!=""&&a.repetition!="none"
};proto.replaceInternalLinks=function(a){return this._module.replaceInternalLinks(a)};proto.setData=function(d,c){this._events=d;
this._config=c;this._nonRepeatingEventsPerDayMap=null;this._colorCodeMap=null;this._repeatingEvents=null;
var b=new Date();var a=new Date(b.getFullYear(),b.getMonth(),b.getDate());var e=24*60*60*1000;this._deletionTime=a.getTime()-c.maxAgeDays*e;
this._listviewHorizonTime=a.getTime()+c.listviewHorizonDays*e;this.trigger("change",this)};proto.getConfig=function(){return this._config
};proto.hasEvents=function(){return this._events!=null&&this._events.length!=0};proto.getRawEvents=function(){return this._events
};proto.getEventById=function(c){for(var b=0,a=this._events.length;b<a;b++){if(this._events[b].id==c){return this._events[b]
}}return null};proto.setEventId=function(a,b){this.getEventById(a).id=b};proto.getItemizedEvents=function(w,d){var o=[];
if(this._events!=null){var k=evtcal.main.EventModel;var t,c;for(var u=0,r=this._events.length;u<r;u++){t=this._events[u];
c=t.toDate?t.toDate.getTime():t.fromDate.getTime();if(k.isRepeatingEvent(t)){var f=new Date(t.fromDate.getTime());
var b=t.repetitionEndType!="none"&&t.repetitionEndDate?t.repetitionEndDate.getTime():null;var p=b&&b<d?b+1:d;
var g={year:t.fromDate.getFullYear(),month:t.fromDate.getMonth(),day:t.fromDate.getDate(),hour:t.fromDate.getHours(),second:t.fromDate.getSeconds()};
var m,n;for(var s=1;f.getTime()<p;s++){m=f.getTime()-t.fromDate.getTime();n=c+m;if(n>=w){var h=jQuery.extend({},t);
h.fromDate=new Date(t.fromDate.getTime()+m);if(h.toDate){h.toDate=new Date(t.toDate.getTime()+m)}o.push(h)
}switch(t.repetition){case"daily":f=new Date(g.year,g.month,g.day+s,g.hour,g.second);break;case"weekly":f=new Date(g.year,g.month,g.day+s*7,g.hour,g.second);
break;case"biweekly":f=new Date(g.year,g.month,g.day+s*14,g.hour,g.second);break;case"monthly":var v=f.getFullYear();
var e=f.getMonth();var q=this.daysInMonth(e+1,v);if(g.day>q){f=new Date(g.year,g.month+s,q,g.hour,g.second)
}else{f=new Date(g.year,g.month+s,g.day,g.hour,g.second)}break;case"yearly":var a=this.daysInMonth(g.month,g.year+s);
if(g.day>a){f=new Date(g.year+s,g.month,a,g.hour,g.second)}else{f=new Date(g.year+s,g.month,g.day,g.hour,g.second)
}break;default:throw new Error("Unknown repetition: "+t.repetition)}}}else{if(c>=w&&t.fromDate.getTime()<d){o.push(t)
}}}evtcal.main.EventModel.sortEvents(o)}return o};proto.daysInMonth=function(b,a){return 32-new Date(a,b,32).getDate()
};proto.getRepeatingEvents=function(){if(this._repeatingEvents==null){var d=this._repeatingEvents=[];
if(this._events!=null){var a=evtcal.main.EventModel;for(var b=0;b<this._events.length;b++){var c=this._events[b];
if(a.isRepeatingEvent(c)){d.push(c)}}}}return this._repeatingEvents};proto.getDeletionTime=function(){return this._deletionTime
};proto.getListviewHorizonTime=function(){return this._listviewHorizonTime};proto.getEventCountForDay=function(c){if(this._nonRepeatingEventsPerDayMap==null){var j=this._nonRepeatingEventsPerDayMap={};
if(this._events!=null){var o=evtcal.main.EventModel;for(var h=0,e=this._events.length;h<e;h++){var b=this._events[h];
if(!o.isRepeatingEvent(b)){var q=evtcal.main.EventModel.dateToKey(b.fromDate);var p=j[q];j[q]=(p==null?1:p+1)
}}}}var a=this._nonRepeatingEventsPerDayMap[evtcal.main.EventModel.dateToKey(c)];if(a==null){a=0}var f=24*60*60*1000;
var g=this.getRepeatingEvents();var s=c.getTime();var d=Math.floor(s/f);for(var h=0;h<g.length;h++){var b=g[h];
var n=b.fromDate.getTime();if(n<=s){var m=false;switch(b.repetition){case"daily":m=true;break;case"weekly":case"biweekly":var r=Math.floor(n/f);
var k=(b.repetition=="weekly")?7:14;m=(r%k)==(d%k);break;case"monthly":m=(c.getDate()==b.fromDate.getDate());
break;case"yearly":m=(c.getDate()==b.fromDate.getDate())&&(c.getMonth()==b.fromDate.getMonth());break;
default:throw new Error("Unknown repetition: "+b.repetition)}if(m){a++}}}return a};proto.getColorCodesAsMap=function(){if(this._colorCodeMap==null){var b={};
var d=this._config.colorCodes;for(var a=0;a<d.length;a++){var c=d[a];b[c.id]=c}this._colorCodeMap=b}return this._colorCodeMap
};evtcal.main.ImageDialog=function(b,c){apsinth.util.Layer.call(this,null,{zIndex:150});var e=this.getContent();
var a="?cache="+Math.floor(Math.random()*10000);var d='<div class="img-area"><img src="'+c.imgPath+"/normal_"+c.getConfig().instance_id+"_"+b.id+"."+b.image_ext+a+'" /></div><div class="title">'+b.title+'</div><a class="ccclose">'+this.msg.close+"</a>";
e.addClass("event-calendar").addClass("evtcal-image-dlg").html(d);e.find("img").load(this.toHandler(this._onImgLoad));
e.find(".ccclose").click(this.toHandler(this.hide))};var clazz=evtcal.main.ImageDialog;var proto=clazz.prototype=new apsinth.util.Layer(false);
proto.constructor=clazz;proto.msg=evtcal.msg.main_EventDialog;proto._imgLoaded=false;proto._showOnImgLoaded=false;
proto._onImgLoad=function(a){this._imgLoaded=true;if(this._showOnImgLoaded){this.showOnImgLoaded()}};
proto.showOnImgLoaded=function(){if(this._imgLoaded){this.show({centerX:true,centerY:true,effect:"fade"})
}else{this._showOnImgLoaded=true}};evtcal.main.MainView=function(b,a){apsinth.util.EventingMixin.mixin(this);
this._model=a;this._mainJQ=b;this._viewJQ=b.children(".evtcal-list-view");this._tabBtnJQ=jQuery(".tabnav a",b).click(this.toHandler(this._onTabChange,this));
this._legend=new evtcal.main.LegendView(b.children(".evtcal-legend"),a);a.bind("change",this._onModelChange,this);
this._updateView(a.getConfig().layout)};var clazz=evtcal.main.MainView;var proto=clazz.prototype;clazz.LAYOUT_TYPE={retracted:"retracted",extended:"extended",monthly:"monthly",weekly:"weekly"};
proto._updateView=function(b,a){if(!b){b=this._model.getConfig().layout}apsinth.util.Tabs.setButtonStyle(false,this._tabBtnJQ,this._mainJQ);
apsinth.util.Tabs.setButtonStyle(true,this._getTabByLayout(b),this._mainJQ);if(b!=this._lastLayout){if(this._view!=null){this._view.cleanUp()
}var c=evtcal.main.MainView.LAYOUT_TYPE;switch(b){case c.retracted:case c.extended:this._viewJQ.attr("class","evtcal-list-view");
a=jQuery.extend({},{layout:b},a);this._view=new evtcal.main.ListView(this._viewJQ,a,this._model);break;
case c.weekly:this._viewJQ.attr("class","");this._view=new evtcal.main.WeekView(this._viewJQ,a,this._model);
break;case c.monthly:this._viewJQ.attr("class","");this._view=new evtcal.main.MonthView(this._viewJQ,a,this._model);
this._view.bind("changeTab",this._onChangeTab,this);break;default:throw new Error("Using unknown layout type '"+b+"'")
}this._lastLayout=b}};proto._onChangeTab=function(a){this._updateView(a.layoutType,a.options)};proto._onModelChange=function(a){this._model=a;
this._updateView()};proto._onTabChange=function(a){var b=this._getLayoutFromTab(a.target.className);if(b){this.trigger("tabChange",{layoutType:b});
this._updateView(b)}else{throw new Error("Missing tab value in main template")}};proto._getLayoutFromTab=function(a){var d=evtcal.main.MainView.LAYOUT_TYPE;
var c=null;if(a&&a!=""){for(var b in d){if(a.indexOf(d[b])!=-1){c=d[b]}}}return c};proto._getTabByLayout=function(b){if(!this._layout2tab){var a=this;
this._layout2tab={};this._tabBtnJQ.each(function(){a._layout2tab[a._getLayoutFromTab(this.className)]=jQuery(this)
})}return this._layout2tab[b]};proto.setHeight=function(a,b){this._view.setHeight(a,b)};evtcal.main.ListView=function(c,b,a){this._mainJQ=c;
this._options=jQuery.extend({},this._defaultOptions,b);this._model=a;a.bind("change",this._updateView,this);
this._updateView()};var clazz=evtcal.main.ListView;var proto=clazz.prototype;clazz.ANIMATE_SHOW_DETAILS=true;
clazz.MIN_HEIGHT=150;proto.msg=evtcal.msg.main_ListView;proto._monthTitleFormat=new evtcal.util.DateFormat(proto.msg["month-title-dateformat"]);
proto._defaultOptions={layout:evtcal.main.MainView.LAYOUT_TYPE.retracted,fixedHeight:null,fillEmptyMonths:true,titlesAsLinks:true,showEditButtons:false,useRawEvents:false};
proto.cleanUp=function(){this._model.unbind("change",this._updateView,this)};proto.setEditItemListener=function(b,a){this._editItemListener={handler:b,scope:a};
this._updateView()};proto.setDeleteItemListener=function(b,a){this._deleteItemListener={handler:b,scope:a};
this._updateView()};proto.setHeight=function(a,b){if(this._options.fixedHeight){a=this._options.fixedHeight
}if(a!=this._height){this._mainJQ[b?"animate":"css"]({height:(typeof a=="number")?(a+"px"):a});this._height=a
}};proto._updateView=function(){var d=this._model.getConfig();if(!this._model.hasEvents()){this.setHeight("auto")
}else{this.setHeight(d.height,true)}this._mainJQ.empty();var m;if(this._options.useRawEvents){m=this._model.getRawEvents()
}else{m=this._model.getItemizedEvents(this._model.getDeletionTime(),this._model.getListviewHorizonTime())
}var c=new Date();var e=c.getMonth();var f=c.getFullYear();var j=null;var h=null;for(var g=0;g<m.length;
g++){var b=m[g];var k=b.fromDate.getMonth();var l=b.fromDate.getFullYear();if(k!=j||l!=h){if(h!=null&&this._options.fillEmptyMonths){this._fillEmptyMonths(j,h,k,l)
}var a=(k==e&&l==f);this._addMonthTitle(k,l,a);h=l;j=k}this._addListItem(b)}if(m.length==0){this._mainJQ.append('<div class="note">'+this.msg["no-events"]+"</div>")
}else{this._mainJQ.append("<br/>")}};proto._fillEmptyMonths=function(g,d,a,b){var f=g;var c=d;var e=true;
while(c<b||f<a){if(!e){this._addMonthTitle(f,c);this._addListItem({type:"msg",title:this.msg["no-event-planned"]})
}e=false;f++;if(f>=12){f=0;c++}}};proto._addMonthTitle=function(e,c,b){var d=new Date(c,e,1);var a='<div class="month-title';
if(b){a+=" current-month"}a+='">'+this._monthTitleFormat.format(d)+"</div>";this._mainJQ.append(a)};proto._addListItem=function(a){var g=jQuery(document.createElement("div"));
this._mainJQ.append(g);var c=this._model.getConfig();var f=!this._options.showEditButtons&&(this._options.layout==evtcal.main.MainView.LAYOUT_TYPE.extended);
var b=!f&&this._options.titlesAsLinks;var e=this._model.getColorCodesAsMap();var d=new evtcal.main.ListItem(g,a,this._model,b,this._options.showEditButtons);
d.setTitleClickListener(this._onItemTitleClicked,this);if(f){d.setShowDetails(true,false)}if(this._options.showEditButtons){if(this._editItemListener){d.setEditClickListener(this._editItemListener.handler,this._editItemListener.scope)
}if(this._deleteItemListener){d.setDeleteClickListener(this._deleteItemListener.handler,this._deleteItemListener.scope)
}}};proto._onItemTitleClicked=function(a){if(this._detailItem!=null){this._detailItem.setShowDetails(false,evtcal.main.ListView.ANIMATE_SHOW_DETAILS)
}a.setShowDetails(true,evtcal.main.ListView.ANIMATE_SHOW_DETAILS);this._detailItem=a};evtcal.main.ListItem=function(c,e,f,b,g){apsinth.util.EventingMixin.mixin(this);
this._itemData=e;this._model=f;var d=apsinth.util.TextUtil;var j=evtcal.main.ListItem;var k=[];k.push('<div class="colorbox"');
if(e.type!="msg"){var l=this._model.getColorCodesAsMap();var a=l[e.colorId];k.push(' style="background-color:');
k.push(a?a.color:this._model.getConfig().defaultcolor);k.push('"');if(a){k.push(' title="');k.push(d.escapeHTML(a.desc));
k.push('"')}}k.push("></div>");if(g){k.push('<div class="edit-area">');k.push('<div class="mini-button edit-button ui-icon ui-icon-1and1-edit" title="');
k.push(d.escapeHTML(this.msg["edit-button"]));k.push('"></div>');k.push('<div class="mini-button delete-button ui-icon ui-icon-1and1-delete" title="');
k.push(d.escapeHTML(this.msg["delete-button"]));k.push('"></div>');k.push("</div>")}k.push('<div class="item-content">');
if(e.fromDate){k.push('<div class="date">');k.push(d.escapeHTML(j.formatDate(e.fromDate)));if(e.fromTime){k.push(", ");
k.push(d.escapeHTML(j.formatTime(e.fromTime)))}if(e.toDate){k.push(" "+this.msg.until+" ");k.push(d.escapeHTML(j.formatDate(e.toDate)));
if(e.toTime){k.push(", ");k.push(d.escapeHTML(j.formatTime(e.toTime)))}}k.push("</div>")}k.push("</div>");
c.addClass("list-item").append(k.join(""));this._colorboxJQ=c.children(".colorbox");this._contentJQ=c.children(".item-content");
var i=this._createClickHandler();var h=jQuery(document.createElement(b?"a":"div"));if(e.type=="msg"){h.addClass("msg")
}else{if(b){h.attr("href","javascript:");h.addClass("title");h.click(i)}else{h.addClass("title")}}h.append(document.createTextNode(e.title));
this._contentJQ.append(h);this._titleJQ=h;if(g){c.find(".mini-button").click(i)}};var clazz=evtcal.main.ListItem;
var proto=clazz.prototype;proto.msg=evtcal.msg.main_ListItem;proto._showingDetails=false;proto.getItemData=function(){return this._itemData
};proto._createClickHandler=function(){var a=this;return function(c){var d=jQuery(this);try{if(d.hasClass("title")){a._callListener(a._titleClickListener)
}else{if(d.hasClass("edit-button")){a._callListener(a._editClickListener)}else{if(d.hasClass("delete-button")){a._callListener(a._deleteClickListener,jQuery(this))
}}}}catch(b){apsinth.util.ErrorUtil.onError(b)}}};proto._callListener=function(a,b){if(a!=null){a.handler.call(a.scope,this,b)
}};proto.setTitleClickListener=function(b,a){this._titleClickListener={handler:b,scope:a}};proto.setEditClickListener=function(b,a){this._editClickListener={handler:b,scope:a}
};proto.setDeleteClickListener=function(b,a){this._deleteClickListener={handler:b,scope:a}};proto.setShowDetails=function(b,c){if(b==this._showingDetails){return
}this._showingDetails=b;if(b){if(this._detailJQ==null){var e=apsinth.util.TextUtil;this._detailJQ=jQuery(document.createElement("div"));
this._detailJQ.addClass("detail");var a=[];a.push('<div class="title">');a.push(e.escapeHTML(this._itemData.title));
a.push("</div>");if(this._itemData.desc){a.push('<div class="detail-text">')}if(this._itemData.has_image){var d=this._itemData.imageChanged;
var f=this._model.imgPath+"/"+(d?"edit_":"")+"normal_"+this._model.getConfig().instance_id+"_"+this._itemData.id+"."+this._itemData.image_ext+"?cache="+Math.floor(Math.random()*10000);
a.push('<img class="evtcal-list-img" src="');a.push(this._model.imgPath);a.push("/"+(d?"edit_":"")+"thumb_");
a.push(this._model._config.instance_id);a.push("_");a.push(this._itemData.id);a.push(".");a.push(this._itemData.image_ext);
a.push("?cache=");a.push(Math.floor(Math.random()*10000));a.push('" animate="');a.push(c);a.push('" bigitem="');
a.push(f);a.push('" data-desc="');a.push(this._model.replaceInternalLinks(this._itemData.title));a.push('"/>')
}if(this._itemData.desc){a.push(this._model.replaceInternalLinks(this._itemData.desc)+"</div>")}if(this._itemData.has_image){a.push('<div style="clear: both;"></div>')
}this._detailJQ.html(a.join(""));this._contentJQ.append(this._detailJQ);if(this._itemData.has_image){this._detailJQ.find(".evtcal-list-img").load(this.toHandler(this._onImgLoaded,this)).click(this.toHandler(this._onImgClicked,this))
}}this._titleJQ.hide();this._detailJQ.show()}else{if(this._detailJQ!=null){this._detailJQ.hide()}this._titleJQ.show()
}this._setColorBoxHeight(b,c)};proto._setColorBoxHeight=function(e,b){var c={};if(e){var d=this._contentJQ.height();
if(d>0){c.height=(d-8)+"px"}if(b){var a=this;window.setTimeout(function(){if(evtcal.main.ListItem._normalColorBoxHeight==null){evtcal.main.ListItem._normalColorBoxHeight=a._colorboxJQ.height()
}a._colorboxJQ.animate(c)})}else{this._colorboxJQ.css(c)}}else{c={height:evtcal.main.ListItem._normalColorBoxHeight+"px"};
if(b){this._colorboxJQ.animate(c)}else{this._colorboxJQ.css(c)}}this.trigger("rendercomplete")};proto._onImgLoaded=function(a){this._setColorBoxHeight(true,a.target.getAttribute("animate")=="true");
if(jQuery.fn.tinyLightbox){this._contentJQ.tinyLightbox({item:"img",pathAttr:"bigitem",descrAttr:"data-desc",keyNavigation:false,hideNavigation:true})
}};proto._onImgClicked=function(){};clazz.getDateFormat=function(){if(clazz._dateformat==null){var a=evtcal.msg.main_ListItem["date-format"];
clazz._dateformat=new evtcal.util.DateFormat(a)}return clazz._dateformat};clazz.getTimeFormat=function(){if(clazz._timeformat==null){var a=evtcal.msg.main_ListItem["time-format"];
clazz._timeformat=new evtcal.util.DateFormat(a)}return clazz._timeformat};clazz.formatDate=function(a){return this.getDateFormat().format(a)
};clazz.formatTime=function(c){var a=Math.floor(c/60);var d=c%60;var b=new Date(2000,1,1,a,d);return this.getTimeFormat().format(b)
};evtcal.main.LegendView=function(b,a){this._mainJQ=b;this._model=a;a.bind("change",this._updateView,this);
this._updateView()};var clazz=evtcal.main.LegendView;var proto=clazz.prototype;proto._visible=true;proto.cleanUp=function(){this._model.unbind("change",this._updateView,this)
};proto._updateView=function(){var b=this._model.getConfig();if(!this._visible||b==null||b.colorCodes.length==0){this._mainJQ.hide()
}else{var d=apsinth.util.TextUtil;var a=[];var f=b.colorCodes;for(var c=0;c<f.length;c++){var e=f[c];
a.push('<div class="legend-item">');a.push('<div class="colorbox" style="background-color:');a.push(e.color);
a.push('"></div>');a.push('<div class="desc">');a.push(e.desc?d.escapeHTML(e.desc):"&#160;");a.push("</div>");
a.push("</div>")}a.push('<div class="evtcal-clear">');this._mainJQ.html(a.join(""));this._mainJQ.show()
}};proto.setVisible=function(a){this._visible=a;this._updateView()};evtcal.main.DetailViewMixin={mixin:function(b){for(var a in this){if(a!="mixin"){b[a]=this[a]
}}},_showDetailLayer:function(a,g,e,b){if(this._detailJQ==null){this._detailJQ=jQuery(document.createElement("div")).css({position:"absolute",zIndex:100002}).attr("class","evtcal-detail-layer event-calendar").html("<div></div>");
jQuery(document.body).append(this._detailJQ)}else{this._detailJQ.show()}if(this._shownEvent!=e){this._shownEvent=e;
this._detailSize=null;if(apsinth.util.Browser.isIe6){this._detailJQ.css("height","auto")}else{this._detailJQ.css({width:"auto",height:"auto"})
}var f=this._detailJQ.children().empty();var d=b.getColorCodesAsMap();var c=new evtcal.main.ListItem(f,e,b,false,false);
c.setShowDetails(true,false);c.bind("rendercomplete",this._onListItemReady,this,{posX:a,posY:g})}else{this._alignDetailLayer(a,g)
}},_onListItemReady:function(a,b){this._alignDetailLayer(b.posX,b.posY)},_alignDetailLayer:function(a,d){var b=this;
function c(){var e={x:a-5,y:d-5,width:30,height:30};var f=apsinth.util.DomUtil.placeInView(b._detailSize,e);
b._detailJQ.css({left:f.x+"px",top:f.y+"px"})}if(this._detailSize==null){this._detailJQ.css({left:0,top:0,visibility:"hidden"});
window.setTimeout(function(){b._detailSize={width:b._detailJQ.outerWidth()};b._detailJQ.css({width:b._detailJQ.width()});
b._detailJQ.css({visibility:"visible"});c()})}else{c()}},_cleanUpDetailLayer:function(){if(this._detailJQ!=null){this._detailJQ.remove();
this._detailJQ=null}},_hideDetailLayer:function(){if(this._detailJQ!=null){this._detailJQ.hide()}},_showDetailDialog:function(b,a){var c=new evtcal.main.EventDialog(b,a);
c.show({centerX:true,centerY:true,width:400,zIndex:100002});this._hideDetailLayer()}};evtcal.main.EventGrid=function(b,a){evtcal.main.DetailViewMixin.mixin(this);
this._options=jQuery.extend({},evtcal.main.EventGrid.options,a);this._mainJQ=jQuery("<div/>").width(this._options.width).addClass("eventGrid");
this._model=b;this._itemizedEventMap={}};evtcal.main.EventGrid.options={slotHeight:5,slotMargin:3,lineBorderWidth:1,lineBorderColorDefault:"gray",lineBorderColorHover:"black",rowSelector:".evtcal-month-view .week",offset:{top:0,left:0},width:454};
evtcal.main.EventGrid.prototype={getMainJQ:function(){return this._mainJQ},setPosition:function(a){this._mainJQ.css({top:a.top,left:a.left})
},cleanUp:function(){this._cleanUpDetailLayer()},update:function(e){if(!this._model.hasEvents()){this._mainJQ.css("display","none");
return}this._itemizedEventMap={};var c="#modul_"+this._model._module.moduleId+"_content";var p=jQuery(c);
var b=p.find(this._options.rowSelector);var z=[];var w=604800000;var K=this._mainJQ.innerWidth()/7;var t=b.innerHeight();
var J=Math.round((t-this._options.slotHeight)/2);var E=t-J;var A=this._options.slotHeight+this._options.slotMargin+2*this._options.lineBorderWidth;
var G="margin-top:"+J+"px";var o=this._model.getColorCodesAsMap();var s,d,n,H,r,m;var F,I=e.getTime();
var f,h=e;this._mainJQ.height((t*b.length)+"px");for(var D=0,v=b.length;D<v;D++){f=new Date(h.getFullYear(),h.getMonth(),h.getDate()+7);
F=f.getTime();d=this._model.getItemizedEvents(I,F);if(d.length!=0){this._addTimeFields(d);s=jQuery(b.get(D));
H=evtcal.util.Event.setSlot("fromDateTime","toDateTime",d);n=s.position().top-this._options.offset.top+J;
r=H*A;if(E<r){m=r-E;s.height(s.height()+m);this._mainJQ.height(this._mainJQ.height()+m)}z.push("<div style='position: absolute; top:"+n+"px;' class='slotBox'>");
var C,u,a,q,g;for(var B=0,y=d.length;B<y;B++){C=d[B];g=D+"."+B;this._itemizedEventMap[g]=C;u=this._getLineData(I,C.fromDateTime,C.toDateTime,K);
z.push("<div eventId='");z.push(C.id);z.push("' data-itemId='");z.push(g);z.push("' class='eventLine' style='width:");
z.push(u.width);z.push("px;left:");z.push(u.left);if(C.slot!=0){z.push("px;top:");z.push(C.slot*A)}z.push("px;height:");
z.push(this._options.slotHeight);z.push("px;border-width:");z.push(this._options.lineBorderWidth);z.push("px;border-color:");
z.push(this._options.lineBorderColorDefault);z.push(";background-color:");q=o[C.colorId];z.push(q?q.color:this._model.getConfig().defaultcolor);
z.push(";'/>")}z.push("</div>")}I=F;h=f}this._mainJQ.html(z.join("")).css("display","block");this._prepareEvents(this._mainJQ.find(".eventLine"))
},_prepareEvents:function(b){var a=apsinth.util.EventingMixin;b.mousemove(a.toHandler(this._onMouseMoveEventLine,this)).mouseout(a.toHandler(this._onMouseOutEventLine,this)).click(a.toHandler(this._onClickEventLine,this))
},_onMouseMoveEventLine:function(c){try{var h=jQuery(c.target).attr("data-itemId");var f=this._itemizedEventMap[h];
this._showDetailLayer(c.pageX,c.pageY,f,this._model);var e=jQuery(c.target).attr("eventId");var g=this._mainJQ.find("[eventId="+e+"]");
for(var d=0,b=g.length;d<b;d++){g.get(d).style.borderColor=this._options.lineBorderColorHover}}catch(a){apsinth.util.ErrorUtil.onError(a)
}},_onMouseOutEventLine:function(c){try{this._hideDetailLayer();var e=jQuery(c.target).attr("eventId");
var f=this._mainJQ.find("[eventId="+e+"]");for(var d=0,b=f.length;d<b;d++){f.get(d).style.borderColor=this._options.lineBorderColorDefault
}}catch(a){apsinth.util.ErrorUtil.onError(a)}},_onClickEventLine:function(b){try{var d=jQuery(b.target).attr("data-itemId");
var c=this._itemizedEventMap[d];this._showDetailDialog(c,this._model)}catch(a){apsinth.util.ErrorUtil.onError(a)
}},_getLineData:function(i,g,h,k){var c=86400000;var d=Math.round(this._utcDiff(new Date(g),new Date(i))/c);
var b=Math.round(this._utcDiff(new Date(h),new Date(i))/c);var a=d<0?-1:this._options.slotMargin;var f=b>6?-1:this._options.slotMargin;
var j=d<0?0:d;var e=b>6?6:b;return{width:(e-j+1)*k-a-f-2*this._options.lineBorderWidth,left:k*j+a}},_addTimeFields:function(d){for(var b=0,a=d.length,c;
b<a;b++){c=d[b];c.fromDateTime=c.fromDate.getTime();c.toDateTime=c.toDate?c.toDate.getTime():c.fromDateTime
}},_utcDiff:function(g,e){var f=[g,e];var b=[new Date(),new Date()];for(var c=0;c<=1;c++){var a=f[c];
var d=b[c];d.setUTCFullYear(a.getFullYear(),a.getMonth(),a.getDate());d.setHours(a.getHours(),a.getMinutes(),a.getSeconds(),a.getMilliseconds())
}return b[0]-b[1]}};evtcal.util.Event={setSlot:function(l,d,f,a,k){a=(a!=null)?a:0;k=(k!=null)?k:(f.length-1);
var c=[];for(var b=a;b<=k;b++){var m=f[b];var j=m[l];var h=m[d];var g=null;for(var e=0;e<c.length;e++){if(c[e]<j){g=e;
break}}if(g==null){g=c.length;c.push(h)}else{c[g]=h}m.slot=g}return c.length}};evtcal.main.MonthView=function(c,b,a){apsinth.util.EventingMixin.mixin(this);
this._mainJQ=c.addClass("evtcal-month-view-box");this._options=b;this._shownDate=new Date();this._model=a;
a.bind("change",this._updateView,this);this._updateView()};var clazz=evtcal.main.MonthView;var proto=clazz.prototype;
proto.msg=evtcal.msg.main_MonthView;proto._monthTitleFormat=new evtcal.util.DateFormat(proto.msg["month-title-dateformat"]);
proto._daynameFormat=new evtcal.util.DateFormat(proto.msg["dayname-dateformat"]);proto._weeknameFormat=new evtcal.util.DateFormat(proto.msg["weekname-dateformat"]);
proto.cleanUp=function(){this._model.unbind("change",this._updateView,this);this._eventGrid.cleanUp()
};proto.setShownDate=function(a){this._shownDate=a;this._updateView()};proto._updateView=function(){this._updateCalendarView();
this._updateEvents()};proto._updateCalendarView=function(){var a=apsinth.util.TextUtil;var m=[];m.push('<table class="evtcal-month-view" cellpadding="0" cellspacing="0">');
m.push('<tr class="title"><td colspan="8"><h1>');m.push(this._monthTitleFormat.format(this._shownDate));
m.push('</h1><div class="btn next-month">');m.push(a.escapeHTML(this.msg["next-month"]));m.push('</div><div class="btn prev-month">');
m.push(a.escapeHTML(this.msg["prev-month"]));m.push('</div><div class="evtcal-clear"></div></td></tr>');
var c=this._shownDate.getMonth();var o=evtcal.EventCalendar.FIRST_DAY_IN_WEEK;var s=new Date(this._shownDate.getFullYear(),c,1);
var j=s.getDay();var e=1+((7-j)%7);m.push('<tr class="daynames"><td class="dayname-spacer">&nbsp;</td>');
for(var p=0;p<7;p++){var n=(p+o)%7;s.setDate(e+n);m.push('<td class="dayname">');m.push(this._daynameFormat.format(s));
m.push("</td>")}m.push("</tr>");var r=new Date();var b=r.getFullYear();var h=r.getMonth();var v=r.getDate();
var q=(7+j-o)%7;s=new Date(this._shownDate.getFullYear(),this._shownDate.getMonth(),1-q);for(var l=0;
l<6;l++){m.push('<tr class="week" startDate="');m.push(evtcal.main.EventModel.dateToKey(s));m.push('"><td class="weekname"><a>');
m.push(this._weeknameFormat.format(s));m.push("</a></td>");for(var p=0;p<7;p++){var d=s.getFullYear();
var t=s.getMonth();var f=s.getDate();var k=s.getDay();var u=(d==b&&t==h&&f==v);var g=(k==0||k==6);m.push('<td class="day');
if(t!=c){if(g){m.push(" other-month-weekend")}else{m.push(" other-month")}}else{if(g){m.push(" weekend")
}}if(u){m.push(" today")}m.push('">'+f);m.push("</td>");s.setDate(s.getDate()+1)}m.push("</tr>")}m.push("</table>");
this._mainJQ.html(m.join("")).css({height:"auto"});this._mainJQ.find(".week:last td.day").css("border-bottom-width",0);
this._mainJQ.find(".prev-month").mousedown(this._preventDefaultHandler).click(this.toHandler(this._onPrevMonth,this));
this._mainJQ.find(".next-month").mousedown(this._preventDefaultHandler).click(this.toHandler(this._onNextMonth,this));
this._mainJQ.find(".weekname").mousedown(this._preventDefaultHandler).click(this.toHandler(this._onWeekClicked,this))
};proto._updateEvents=function(){if(!this._eventGrid){this._eventGrid=this._createEventGrid()}this._mainJQ.append(this._eventGrid.getMainJQ());
if(!this._eventGridPositionSet){this._eventGrid.setPosition(this._getEventGridPosition());this._eventGridPositionSet=true
}var b=this._mainJQ.find(".evtcal-month-view .week:first").attr("startdate");var a=evtcal.main.EventModel.keyToDate(b);
this._eventGrid.update(a)};proto._createEventGrid=function(){var a={};var d=this._mainJQ.find(".evtcal-month-view").position();
var b=this._mainJQ.find(".evtcal-month-view td.day:first").position();var c=this._mainJQ.find(".evtcal-month-view td.day:last");
a={weekRowSelector:".evtcal-month-view .week",width:c.position().left+c.width()-b.left,offset:{top:b.top-d.top,left:b.left-d.left}};
return new evtcal.main.EventGrid(this._model,a)};proto._getEventGridPosition=function(){return this._mainJQ.find(".evtcal-month-view td.day:first").position()
};proto._onPrevMonth=function(){this.setShownDate(new Date(this._shownDate.getFullYear(),this._shownDate.getMonth()-1,1))
};proto._onNextMonth=function(){this.setShownDate(new Date(this._shownDate.getFullYear(),this._shownDate.getMonth()+1,1))
};proto._onWeekClicked=function(a){var c=jQuery(a.target).parents(".week");var b={layoutType:evtcal.main.MainView.LAYOUT_TYPE.weekly,options:{startDate:evtcal.main.EventModel.keyToDate(c.attr("startdate"))}};
this.trigger("changeTab",b)};evtcal.main.WeekView=function(c,b,a){apsinth.util.EventingMixin.mixin(this);
evtcal.main.DetailViewMixin.mixin(this);this._mainJQ=c;this._options=jQuery.extend({},this._defaultOptions,b);
this._model=a;a.bind("change",this.updateView,this,true);c.addClass("evtcal-week-view");this._mainHeight=this._options.shownInDialog?this._mainJQ.height():a.getConfig().height;
this._mainJQ.height(this._mainHeight);this._createSkeleton();this.setShownDate(this._options.startDate);
this.updateView()};var clazz=evtcal.main.WeekView;var proto=clazz.prototype;proto.msg=evtcal.msg.main_WeekView;
proto._weekTitleFormat=new evtcal.util.DateFormat(proto.msg["week-title-dateformat"]);proto._weekTitleFormatShort=new evtcal.util.DateFormat(proto.msg["week-title-dateformat-short"]);
proto._daynameFormat=new evtcal.util.DateFormat(proto.msg["dayname-dateformat"]);proto._daynameFormatShort=new evtcal.util.DateFormat(proto.msg["dayname-dateformat-short"]);
proto._daytimeFormat=new evtcal.util.DateFormat(proto.msg["daytime-dateformat"]);proto._durationFormat=new evtcal.util.DateFormat(proto.msg["duration-dateformat"]);
proto._defaultOptions={mainBorderTop:1,dayTimeWidth:40,daytimePadX:1,marginRight:25,initialMultiRowHeight:65,multiEventHeight:28,eventPadX:6,eventPadY:6,eventBorderLeft:1,eventBorderRight:1,dayMarginLeft:1,dayMarginRight:1,eventMarginLeft:0,eventMarginRight:1,eventMarginTop:1,eventMarginBottom:1,eventWeekOverlap:10,slotHeight:17,slotPadX:1,startDate:new Date(),shownInDialog:false,singleEventScrollerTop:null};
proto.setHeight=function(a,b){if(this._options.shownInDialog){return}if(a!=this._mainHeight){this._mainJQ[b?"animate":"css"]({height:(typeof a=="number")?(a+"px"):a});
this._mainHeight=a;this._setMultiEventHeight(jQuery(".evtcal-week-view .multi-event-scroller").height())
}};proto.cleanUp=function(){this._cleanUpDetailLayer()};proto.setShownDate=function(a){this._shownDate=a;
this.updateView(null,true)};proto.onSizeChanged=function(){this.updateView()};proto._onPrevWeek=function(){var a=new Date(this._shownDate.getTime());
a.setDate(a.getDate()-7);this.setShownDate(a)};proto._onNextWeek=function(){var a=new Date(this._shownDate.getTime());
a.setDate(a.getDate()+7);this.setShownDate(a)};proto._showInDlg=function(){var a=new evtcal.main.WeekViewDialog(this._shownDate,this._model);
a.show({centerX:true,centerY:true,addWinWidth:true,addWinHeight:true,winWidthMargin:260,winHeightMargin:140,effect:"fade",zIndex:100001,singleEventScrollerTop:this._singleEventScrollerJQ.scrollTop()})
};proto._showGotoWeek=function(){var h=evtcal.util.DateFormat;var a="yy-m-d";var c=jQuery.datepicker16.formatDate(a,this._shownDate);
var i=this;function d(l,k){var j=new Date(k.selectedYear,k.selectedMonth,k.selectedDay);i.setShownDate(j)
}var b={firstDay:evtcal.EventCalendar.FIRST_DAY_IN_WEEK,dayNamesMin:h.getDayNamesMin(),monthNames:h.getMonthNames(),showAnim:"slideDown",dateFormat:a};
var f=this._gotoWeekBtn.offset();var g=f.left-80;var e=f.top+this._gotoWeekBtn.outerHeight();jQuery(document.body).datepicker16("dialog",c,d,b,[g,e])
};proto._onSliderDrag=function(c){c.preventDefault();var b=c.pageY;var e=this._multiEventScrollerJQ.height();
var d;if(jQuery.browser.msie){d=document.body.onselectstart;document.body.onselectstart=function(){c.cancelBubble=true;
return false}}var f=this.toHandler(function(g){this._setMultiEventHeight(e+g.pageY-b)});var a=this.toHandler(function(){this._sliderBlocker.remove();
this._sliderBlocker=null;if(jQuery.browser.msie){document.body.onselectstart=d}});this._sliderBlocker=jQuery(document.createElement("div"));
jQuery(document.body).append(this._sliderBlocker);this._sliderBlocker.addClass("evtcal-slider-blocker").mousemove(f).mouseup(a).mouseout(a)
};proto._createSkeleton=function(){var c=evtcal.EventCalendar.FIRST_DAY_IN_WEEK;var g=this._options;var a=[];
a.push('<div class="title">');a.push('<span class="btn prev-week"></span> - <span class="btn next-week"></span>');
a.push('<div class="btn-right go-to-week">');a.push(this.msg["go-to-week"]);a.push("</div>");if(!g.shownInDialog){a.push('<div class="btn-right show-in-dlg">');
a.push(this.msg["show-in-dlg"]);a.push("</div>")}a.push('<div class="evtcal-clear"></div>');a.push("</div>");
a.push('<div class="daynames"><div class="dayname-spacer">&nbsp;</div>');for(var e=0;e<7;e++){a.push('<div class="dayname"></div>')
}a.push('<div class="evtcal-clear"></div></div>');a.push('<div class="multi-event-scroller"><div class="multi-event-bg">');
a.push('<div class="dayname-spacer">&nbsp;</div>');for(var e=0;e<7;e++){var d=(7+c+e)%7;a.push('<div class="day');
if(d==0||d==6){a.push(" day-weekend")}a.push('">&nbsp;</div>')}a.push('<div class="evtcal-clear"></div></div>');
a.push('<div class="event-canvas" style="left:');a.push(g.dayTimeWidth);a.push('px"></div></div>');a.push('<div class="slider">&nbsp;</div>');
a.push('<div class="single-event-scroller"><div class="single-event-bg">');a.push('<div class="daytime-col">');
var h=new Date(2000,1,1);for(var b=0;b<24;b++){a.push('<div style="height:');a.push(g.slotHeight*2);a.push('px">');
h.setHours(b);h.setMinutes(0);a.push(this._daytimeFormat.format(h));a.push("</div>")}a.push("</div>");
for(var e=0;e<7;e++){var d=(7+c+e)%7;a.push('<div class="day-column');if(d==0||d==6){a.push(" day-column-weekend")
}a.push('" style="height:');a.push(48*g.slotHeight);a.push('px">&nbsp;</div>')}a.push('<div class="evtcal-clear"></div></div>');
a.push('<div class="event-canvas" style="left:');a.push(g.dayTimeWidth);a.push('px"></div></div>');this._mainJQ.html(a.join(""));
var f=this._mainJQ.children(".title");this._prevWeekBtn=f.children(".prev-week").click(this.toHandler(this._onPrevWeek));
this._nextWeekBtn=f.children(".next-week").click(this.toHandler(this._onNextWeek));if(!g.shownInDialog){this._gotoWeekBtn=f.children(".show-in-dlg").click(this.toHandler(this._showInDlg))
}this._gotoWeekBtn=f.children(".go-to-week").click(this.toHandler(this._showGotoWeek));this._daynameJQ=this._mainJQ.children(".daynames").children(".dayname");
this._multiEventScrollerJQ=this._mainJQ.children(".multi-event-scroller");this._multiEventBgJQ=this._multiEventScrollerJQ.children(".multi-event-bg");
this._multiEventCanvasJQ=this._multiEventScrollerJQ.children(".event-canvas");this._sliderJQ=this._mainJQ.children(".slider");
this._singleEventScrollerJQ=this._mainJQ.children(".single-event-scroller");this._singleEventCanvasJQ=this._singleEventScrollerJQ.children(".event-canvas");
this._sliderJQ.mousedown(this.toHandler(this._onSliderDrag));this.updateDimensions();if(this._options.singleEventScrollerTop){this._singleEventScrollerJQ[0].scrollTop=this._options.singleEventScrollerTop
}else{this._singleEventScrollerJQ[0].scrollTop=8*2*g.slotHeight}};proto.updateDimensions=function(){var a=this._options;
if(jQuery(".apsinth-dialog .evtcal-week-view").length){this._dayWidth=Math.floor((jQuery(".apsinth-dialog .evtcal-week-view").width()-a.dayTimeWidth-a.marginRight)/7)
}else{this._dayWidth=Math.floor((jQuery(".event-calendar").width()-a.dayTimeWidth-a.marginRight)/7)}var b=this._dayWidth-a.slotPadX;
var c=a.dayTimeWidth-a.daytimePadX;this._mainJQ.find(".dayname-spacer").width(c);this._mainJQ.find(".daytime-col").width(c);
this._mainJQ.find(".dayname").width(b);this._mainJQ.find(".day").width(b);this._mainJQ.find(".day-column").width(b);
this._mainJQ.find(".event-canvas").width(7*this._dayWidth);this._mainHeight=this._mainJQ.height();this._setMultiEventHeight(jQuery(".evtcal-week-view .multi-event-scroller").height())
};proto.updateView=function(u,M){var t=this._options;var m=this._dayWidth;var k=this._model.getColorCodesAsMap();
var f=86400000;var c=evtcal.EventCalendar.FIRST_DAY_IN_WEEK;var s=this._shownDate;var H=(7+s.getDay()-c)%7;
var D=new Date(s.getFullYear(),s.getMonth(),s.getDate()-H);var y=D.getTime();var w=new Date(D.getFullYear(),D.getMonth(),D.getDate()+6);
var v=new Date(D.getFullYear(),D.getMonth(),D.getDate()+7).getTime();if(t.shownInDialog){var L=this._weekTitleFormat;
this._prevWeekBtn.text(L.format(D));this._nextWeekBtn.text(L.format(w))}else{var r="dd.mm.y";var p=jQuery.datepicker16.formatDate(r,D);
var n=jQuery.datepicker16.formatDate(r,w);this._prevWeekBtn.text(p);this._nextWeekBtn.text(n)}var b=new Date(D.getTime());
var j=t.shownInDialog?this._daynameFormat:this._daynameFormatShort;var h=this;this._daynameJQ.each(function(i,l){jQuery(l).text(j.format(b));
b.setDate(b.getDate()+1)});this._updateMetaData(y,v,M);var J=this._metaData;var a=t.eventMarginTop+t.eventPadY+t.eventMarginBottom;
var C=t.dayMarginLeft+t.eventMarginLeft+t.eventPadX+t.eventMarginRight+t.dayMarginRight;var A=[];for(var I=0,G=J.multiEvents.length;
I<G;I++){var K=J.multiEvents[I];var q=K.weekFromDay*m+t.dayMarginLeft+t.eventMarginLeft;var F=(K.weekToDay-K.weekFromDay+1)*m-C;
A.push('<div class="event" ngh-idx="');A.push(I);A.push('" style="');if(K.fromDay!=K.weekFromDay){q-=t.eventWeekOverlap;
F+=t.eventWeekOverlap+t.eventBorderLeft;A.push("border-left:none;")}if(K.toDay!=K.weekToDay){F+=t.eventWeekOverlap+t.eventBorderRight;
A.push("border-right:none;")}A.push("left:");A.push(q);A.push("px;top:");A.push(K.slot*t.multiEventHeight+t.eventMarginTop);
A.push("px;width:");A.push(F);A.push("px;background-color:");var N=k[K.event.colorId];A.push(N?N.color:this._model.getConfig().defaultcolor);
A.push('">');A.push(K.event.title);if(K.fromDay!=K.toDay&&K.event.fromTime){A.push("<br>(");A.push(this._durationFormat.format(this._getEventDate(K.event,"from")));
A.push(" - ");A.push(this._durationFormat.format(this._getEventDate(K.event,"to")));A.push(")")}A.push("</div>")
}this._multiEventCanvasJQ.html(A.join(""));this._prepareEvents(true,this._multiEventCanvasJQ.children("div.event"));
if(jQuery(".apsinth-dialog .evtcal-week-view").length){var B=jQuery(".apsinth-dialog .evtcal-week-view").height()
}else{var B=jQuery(".evtcal-week-view").height()}var o=this._multiEventCanvasJQ.find(".event").height();
this._setMultiEventHeight(o+a);var d=t.eventMarginLeft+t.eventPadX+t.eventMarginRight;var z=m-t.dayMarginLeft-t.dayMarginRight;
var A=[];var e=t.slotHeight/30;for(var I=0,G=J.singleEvents.length;I<G;I++){var K=J.singleEvents[I];var E=Math.round(z*K.slot/K.slotCount);
var g=Math.round(z*(K.slot+1)/K.slotCount);A.push('<div class="event" ngh-idx="');A.push(I);A.push('" style="left:');
A.push(K.day*m+t.dayMarginLeft+E+t.eventMarginLeft);A.push("px;top:");A.push(Math.round(K.fromTime*e)+t.eventMarginTop);
A.push("px;width:");A.push(g-E-d);A.push("px;height:");A.push(Math.round((K.toTime-K.fromTime+1)*e)-a);
A.push("px;background-color:");var N=k[K.event.colorId];A.push(N?N.color:evtcal.EventCalendar.DEFAULT_COLOR_LIGHT);
A.push('">');A.push(K.event.title);A.push("<br>(");A.push(this._daytimeFormat.format(this._getEventDate(K.event,"from")));
if(K.event.toTime){A.push(" - ");A.push(this._daytimeFormat.format(this._getEventDate(K.event,"to")))
}A.push(")</div>")}this._singleEventCanvasJQ.html(A.join(""));this._prepareEvents(false,this._singleEventCanvasJQ.children("div.event"))
};proto._prepareEvents=function(b,a){a.mousemove(this.toHandler(function(c){var e=parseInt(jQuery(c.currentTarget).attr("ngh-idx"),10);
var d=(b?this._metaData.multiEvents:this._metaData.singleEvents);this._showDetailLayer(c.pageX,c.pageY,d[e].event,this._model)
})).mouseout(this.toHandler(function(c){this._hideDetailLayer()})).click(this.toHandler(function(c){var e=parseInt(jQuery(c.currentTarget).attr("ngh-idx"),10);
var d=(b?this._metaData.multiEvents:this._metaData.singleEvents);this._showDetailDialog(d[e].event,this._model)
}))};proto._getEventDate=function(b,c){var a=new Date(b[c+"Date"]);var d=b[c+"Time"];a.setHours(Math.floor(d/60));
a.setMinutes(d%60);return a};proto._utcDiff=function(g,e){var f=[g,e];var b=[new Date(),new Date()];for(var c=0;
c<=1;c++){var a=f[c];var d=b[c];d.setUTCFullYear(a.getFullYear(),a.getMonth(),a.getDate());d.setHours(a.getHours(),a.getMinutes(),a.getSeconds(),a.getMilliseconds())
}return b[0]-b[1]};proto._updateMetaData=function(n,a,g){if(this._metaData==null||g){var m=86400000;var u=this._options.multiEventHeight;
var j=[];var t=[];var b=this._model.getItemizedEvents(n,a);for(var q=0,o=b.length;q<o;q++){var p=b[q];
if(p.fromTime!=null&&(p.toDate==null||p.toDate.getTime()==p.fromDate.getTime())){t.push({day:Math.floor(this._utcDiff(p.fromDate,new Date(n))/m),fromTime:p.fromTime,toTime:Math.max(p.toTime,p.fromTime+30)-1,event:p})
}else{var s=(p.toDate?p.toDate:p.fromDate);var f=Math.floor(this._utcDiff(p.fromDate,new Date(n))/m);
var c=Math.floor(this._utcDiff(s,new Date(n))/m);j.push({fromDay:f,toDay:c,weekFromDay:Math.max(0,f),weekToDay:Math.min(6,c),event:p})
}}var k=evtcal.util.Event.setSlot("fromDay","toDay",j);var e=null;var h=-1;var d=0;for(var q=0,o=t.length;
q<o;q++){var r=t[q];if(e==r.day&&r.fromTime<=h){h=Math.max(h,r.toTime)}else{this._finishEventCollition(t,d,q-1);
e=r.day;h=r.toTime;d=q}}this._finishEventCollition(t,d,t.length-1);this._metaData={multiEvents:j,multiEventSlotCount:k,singleEvents:t}
}};proto._finishEventCollition=function(f,e,a){if(e==a){var d=f[e];d.slot=0;d.slotCount=1}else{if(e<a){var c=evtcal.util.Event.setSlot("fromTime","toTime",f,e,a);
for(var b=e;b<=a;b++){f[b].slotCount=c}}}};proto._setMultiEventHeight=function(b){var c=this;var a=null;
var d=function(){var g=false;try{var f=c._mainJQ.offset().top+c._mainHeight-c._multiEventScrollerJQ.offset().top+c._options.mainBorderTop;
var i=3;var e=c._multiEventCanvasJQ.height();b=Math.max(0,Math.min(f-i,b));c._multiEventScrollerJQ.height(b);
c._multiEventBgJQ.height(Math.max(e,b));c._singleEventScrollerJQ.height(f-i-b);g=true}catch(h){}if(g==true){clearInterval(a)
}};a=setInterval(d,100)};evtcal.main.WeekViewDialog=function(a,b){apsinth.util.Layer.call(this);this._model=b;
this._startDate=a;var c=this.getContent();c.html('<div></div><div class="evtcal-legend" style="margin-bottom:10px"></div><a class="ccclose">'+this.msg.close+"</a>");
this._weekViewJQ=c.children("div:first");this._legendJQ=c.children(".evtcal-legend");this._legendView=new evtcal.main.LegendView(this._legendJQ,b);
c.find(".ccclose").click(this.toHandler(this.hide));this._resizeHandler=this.toHandler(this._onWindowResize);
jQuery(window).bind("resize",this._resizeHandler)};var clazz=evtcal.main.WeekViewDialog;var proto=clazz.prototype=new apsinth.util.Layer(false);
proto.constructor=clazz;proto.msg=evtcal.msg.main_WeekViewDialog;proto._onWindowResize=function(a){apsinth.util.Layer.prototype.show.call(this,this._showOptions);
var b=this.getContent();this._weekViewJQ.height(b.height()-this._legendJQ.height()-40);this._weekView.updateDimensions();
this._weekView.updateView()};proto.show=function(a){apsinth.util.Layer.prototype.show.call(this,a);this._showOptions=a;
if(this._legendJQ.css("display")=="none"){this._legendJQ.css("display","block")}var c=this.getContent();
this._weekViewJQ.height(c.height()-this._legendJQ.height()-40);var b={startDate:this._startDate,shownInDialog:true,singleEventScrollerTop:a.singleEventScrollerTop};
this._weekView=new evtcal.main.WeekView(this._weekViewJQ,b,this._model)};proto.hide=function(){apsinth.util.Layer.prototype.hide.apply(this,arguments);
jQuery(window).unbind("resize",this._resizeHandler);this._weekView.cleanUp();this._legendView.cleanUp()
};window.edcont={};var EditorialContent=apsinth.ApsinthModule.extend({DIALOG_DELTA_WIDTH:-24,initialize:function(c,b,a,d){this._super(c,b,a,d)
},_initMainView:function(){var a=this.getMainJQ();if(!this.data){return}var b=this.mode=="admin"?this.getConfigData().category_id:this.data.category_id;
switch(b){case"stockticker":new edcont.Stockticker(a);break;default:this._teaserViewJQ=a.find(".teaser-view");
this._detailViewJQ=a.find(".detail-view");break}},_initConfigView:function(){var c=this.getConfigJQ();
var b=c.find(".terms-box");if(b.length>0){b.children(".terms-btn").click(this.toHandler(function(){this.blockSettings(false);
this._termsConfirmed=true}));b.children(".terms-link").click(this.toHandler(function(d){d.preventDefault();
this.showTermsDialog()}))}c.find(".ccoption a").click(this.toHandler(this._onLayoutButtonClick));c.find("a.category-title").click(this.toHandler(function(f){var d=jQuery(f.currentTarget);
c.find("a.category-title").removeClass("selected");d.addClass("selected");c.find(".categories div").hide();
c.find(".categories #"+d.attr("rel")).fadeIn()}));c.find(".categories label").click(this.toHandler(this._onCatLabelClick));
var a=this.toHandler(this._reloadPreview);c.find(".categories input").change(a);c.find("select.ewoaoarticle_amount").change(a);
c.find("#ewoao_show_with_pic").change(a);this.bind("open-config",this._onOpen,this);this._updateToolbar(this.data)
},_onLayoutButtonClick:function(a){var d=this.getConfigJQ();var c=d.find("#ewoao_selected_option");var b=c.val();
if(this.data.hasImage&&this.data.hasDetails){d.find(".layout-"+b+"-active")[0].className="layout-"+b;
a.currentTarget.className+="-active";c.val(a.currentTarget.rel);this._reloadPreview()}},_onCatLabelClick:function(a){var c=jQuery(a.currentTarget);
var b=c.prev("input");b[0].checked=true;this._reloadPreview()},_onOpen:function(){var a=this.getConfigJQ().find(".terms-box");
if(a.length>0&&!this._termsConfirmed){this.blockSettings(true)}},blockSettings:function(f){var e=this.getConfigJQ();
var b=e.find(".config-body-blocker");if(f){var a=e.find(".config-body")[0];var d={left:a.offsetLeft+"px",top:a.offsetTop+"px",width:a.offsetWidth+"px",height:a.offsetHeight+"px"};
b.css(d).show();var c={height:a.offsetHeight+"px"};b.children(".config-blocker-bg").fadeTo(0,0.25).css(c)
}else{b.fadeOut()}},showTermsDialog:function(){if(this._termsDlg==null){var a=this.getConfigJQ().find(".edcont-terms-dialog");
jQuery(document.body).append(a);this._termsDlg=new apsinth.util.Layer(a);var b=a.find(".terms-text");
if(b.children().length==0){this.callRpc("public.viewTerms","",function(d,c){if(!c){b.html(d.html)}})}}this._termsDlg.showBelow(this.getMainJQ(),true,this.DIALOG_DELTA_WIDTH)
},hideTermsDialog:function(){if(this._termsDlg!=null){this._termsDlg.hide()}},showDetail:function(b){var d=this.mode=="admin"?this.getConfigData():{};
var a=this;var c=this.getMainJQ();d.article=b;this.callRpc("public.viewArticle",d,function(e,f){a._lastScrollY=(window.pageYOffset||document.documentElement.scrollTop);
if(!f){a._teaserViewJQ.hide();a._detailViewJQ.html(e.html).show();window.scrollTo(0,a._detailViewJQ.offset().top-20);
c.find(".back-btn").click(a.toHandler(a.showTeasers))}})},showPage:function(b){var d=this.mode=="admin"?this.getConfigData():{};
var a=this;var c=this.getMainJQ();d.pageId=b;this.callRpc("public.viewMain",d,function(e,f){a._lastScrollY=(window.pageYOffset||document.documentElement.scrollTop);
if(!f){a.getMainJQ().html(e.html).show()}})},showTeasers:function(){this._teaserViewJQ.show();this._detailViewJQ.hide();
window.scrollTo(0,this._lastScrollY)},getConfigData:function(){var c=this.getConfigJQ();var b=c.find("#termsRead");
var a=c.find("input[name='category']:checked").val();return{view_style:c.find("#ewoao_selected_option").val(),category_id:(a==undefined)?"":a,show_img:c.find("#ewoao_show_with_pic").attr("checked")?1:0,user_agreement:(b.length==0||b.attr("checked"))?1:0,article_amount:c.find(".ewoaoarticle_amount > option:selected").val()}
},_reloadPreview:function(){this.reloadMainView(this.getConfigData(),this.toHandler(this._onReloadPreview),this.toHandler(this._onAfterReloadPreview))
},_onReloadPreview:function(a){this.data=a.data;this._updateToolbar(a.data)},_onAfterReloadPreview:function(){if(this.trigger instanceof Function){this.trigger("onload",this)
}},_updateToolbar:function(c){var d=this.getConfigJQ();var a=c&&c.hasImage&&c.hasDetails;var b=d.find("#ewoao_selected_option").val();
d.find(".ccoption a").attr("disabled",!a);d.find(".ccoption a").each(function(){var i=jQuery(this);var e=i.attr("rel");
var g="layout-"+e;var f=g+"-active";var h=g+"-disabled";if(a){i.removeClass(h);i.addClass(e==b?f:g)}else{i.removeClass(g);
i.removeClass(f);i.addClass(h)}});d.find(".ccoption a").fadeTo(0,(a?1:0.5));d.find("#ewoao_show_with_pic").attr("disabled",!c||!c.hasImage);
d.find(".ewoaoarticle_amount").attr("disabled",!c||!c.hasMultipleArticles)}});edcont.EditorialContent=EditorialContent;
edcont.Stockticker=function(c){var d=c.find(".ticker");var b=c.innerWidth();for(var a=0;a<d.length;a++){this._createMarquee(d[a],b,(2-a)*30)
}};var clazz=edcont.Stockticker;var proto=clazz.prototype;proto.fps=25;proto._createMarquee=function(e,c,g){var h=jQuery(e);
var a=h.outerWidth()*-1;var b=new Date().getTime();var f;var d=window.setInterval(function(){var k=new Date().getTime();
var i=c-Math.round(g*(k-b)/1000);if(i<a){b=k;var j=h.parents("body").length!=0;if(!j){window.clearInterval(d)
}}if(i!=f){e.style.left=i+"px";f=i}},Math.floor(1000/this.fps))};Weeklyhoroscopes={openHoroscope:function(a){jQuery("#"+a).css("display","block");
jQuery("#edcont-weeklyhoroscopes-header").css("display","none")},closeHoroscope:function(a){jQuery("#"+a).css("display","none");
jQuery("#edcont-weeklyhoroscopes-header").css("display","block")}};var Weather=apsinth.ApsinthModule.extend({errorTarget:"#custom_error_placeholder",_initMainView:function(){var a=this.getMainJQ()
},initialize:function(c,b,a,d){this._super(c,b,a,d)},_initConfigView:function(){var a=this.getConfigJQ();
a.find("a.mod-bar-button").click(this.toHandler(this._onConfigButtonClick))},getConfigData:function(){var b=this.getConfigJQ();
var a={zipcode:b.find(".apsinth_weather_zipcode").val(),viewalign:b.find(".apsinth_weather_viewalign").val()};
return a},_onConfigButtonClick:function(a){var d=this.getConfigJQ();var c=this.getMainJQ();var b=jQuery(a.currentTarget);
d.find("a.mod-bar-button").each(function(){var e=jQuery(this);var f=e.attr("rel");e.removeClass("layout-"+f+"-active");
e.removeClass("layout-"+f);if(e.attr("rel")==b.attr("rel")){e.addClass("layout-"+f+"-active");d.find(".apsinth_weather_viewalign").val(e.attr("rel"));
c.find(".apsinth-weather").removeClass("viewalign-left");c.find(".apsinth-weather").removeClass("viewalign-center");
c.find(".apsinth-weather").removeClass("viewalign-right");c.find(".apsinth-weather").addClass("viewalign-"+e.attr("rel"))
}else{e.addClass("layout-"+f)}})}});var Newsletter=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:537,tinyMceLoaded:false,initialize:function(c,b,a,d){this._super(c,b,a,d)
},_initMainView:function(){},_initConfigView:function(){var a=this.getConfigJQ();a.find('input[type="checkbox"]').diy_checkbox();
a.find("#"+this.idPrefix+"newsletter_tabs_container").tabs();a.find("#"+this.idPrefix+"button_open_marketing_tool").button();
this.registerEventHandlers(a)},registerEventHandlers:function(d){var a=this.toHandler(this._reloadPreview);
d.find("input[type='checkbox']").click(a);var b=d.find("[name='subscriptionFeedback']");var c=b.attr("id");
this.bind("close-config",function(){if(this.tinyMceLoaded){tinyMCE.execCommand("mceRemoveControl",false,c);
this.tinyMceLoaded=false;d.find("div.newsletter-config a.tabform").click()}},this);var e=this.toHandler(function(){if(!this.tinyMceLoaded){tinyMCE.execCommand("mceAddControl",false,c);
this.tinyMceLoaded=true}});this.bind("open-config",function(){selectedTab=d.find("#"+this.idPrefix+"newsletter_tabs_container").tabs("option","selected");
if(selectedTab==1&&!this.tinyMceLoaded){tinyMCE.execCommand("mceAddControl",false,c);this.tinyMceLoaded=true
}},this);d.find("div.newsletter-config a.tabsettings").click(e)},getConfigData:function(){var a=this.getConfigJQ();
var b=tinyMCE.get(a.find("[name='subscriptionFeedback']").attr("id"));if(b){b.save()}return{showSalutation:a.find("input[name='showSalutation']:checked").val()?1:0,showFirstName:a.find("input[name='showFirstName']:checked").val()?1:0,showLastName:a.find("input[name='showLastName']:checked").val()?1:0,showCompany:a.find("input[name='showCompany']:checked").val()?1:0,optInMailSubject:a.find("[name='optInMailSubject']").val(),optInMailText:a.find("[name='optInMailText']").val(),subscriptionFeedback:a.find("[name='subscriptionFeedback']").val()}
},subscribe:function(){var d=this.getMainJQ();var c={};var b=this;var a=function(){var e=jQuery(this);
c[e.attr("name")]=e.val()};d.find(".newsletter-form-field input[type='text']").each(a);d.find(".newsletter-form-field select").each(a);
this.callRpc("public.subscribe",c,function(e,f){if(e.errors){b.showMainViewError(e.errors.join("<br/>"));
b.getMainJQ().find(".refresh").click()}else{if(e.html){d.html(e.html)}}})},showMainViewWarning:function(b){var a=jQuery(this.getMainJQ().find(".newsletter-warning"));
a.find(".newsletter-warning-text").html(b);a.fadeIn(400,function(){window.setTimeout(function(){a.fadeOut(400)
},5000)})},showMainViewError:function(b){var a=jQuery(this.getMainJQ().find(".newsletter-error"));a.find(".newsletter-error-text").html(b);
a.fadeIn(400,function(){window.setTimeout(function(){a.fadeOut(400)},5000)})},_reloadPreview:function(){this.reloadMainView(this.getConfigData())
}});window.shoppingbasket={msg:{}};var Shoppingbasket=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:500,msg_main:null,tax_activeAdress:"inv",tax_cityCheck:0,tax_stateCheck:0,tax_zipCheck:0,initialize:function(c,b,a,d){this._super(c,b,a,d);
this.msg_main=shoppingbasket.msg.main_Shoppingbasket},_initMainView:function(){var a=this;var b=this.getMainJQ();
a._setTaxHandler("inv");b.find("#del_addr").parent().parent().nextAll("tr:has(td:[id^='del'])").hide();
b.find("#del_addr").click(this.toHandler(function(){if(b.find("#del_addr").attr("checked")){b.find("#del_addr").parent().parent().nextAll("tr:has(td:[id^='del'])").show();
a._setTaxHandler("del")}else{b.find("#del_addr").parent().parent().nextAll("tr:has(td:[id^='del'])").hide();
a._setTaxHandler("inv")}}));b.find("input[id^='count_']").keydown(this.toHandler(function(c){revertCount=jQuery(c.target).val()
}));b.find("input[id^='count_']").keyup(this.toHandler(function(d){if(jQuery(d.target).val()!=="0"){this._refreshPrices(d)
}else{if(confirm(this.msg_main.delete_article)){var c=jQuery(d.currentTarget).attr("id").split("_");this._deleteArticle(c[1],jQuery(d.target).parent().parent())
}else{if(revertCount){jQuery(d.target).val(revertCount)}}}}));b.find("input[id^='delete_art_']").click(this.toHandler(function(d){if(confirm(this.msg_main.delete_article)){var c=jQuery(d.currentTarget).attr("id").split("_");
this._deleteArticle(c[2],jQuery(d.target).parent().parent())}else{}},this));b.find("#submit").click(this.toHandler(function(c){this._formSubmit()
},this));b.find("#terms_accept_link").click(this.toHandler(function(c){this.callRpc("public.getTerms",null,function(e,d){if(!d&&e&&!e.errors&&e.terms_text){jQuery(".terms-dialog .dlg-text .terms_text").html(e.terms_text);
a._showDialog("terms")}})},this));b.find("#shoppingBasketDialogs").hide()},_initConfigView:function(){var b=this.getConfigJQ();
var a=this;b.find("#payment_pp").click(this.toHandler(function(c){if(b.find("#payment_pp").attr("checked")){b.find("#fieldset-pp_data").show()
}else{b.find("#fieldset-pp_data").hide()}}));(new apsinth.util.Tabs(b)).bindTabChanged(function(c){a._onTabChange(c)
})},_onTabChange:function(a){if(a.hasClass("skins-tab")){this._skinSelector.updateSkins()}},getConfigData:function(){var a=this.getConfigJQ();
this.bind("open-config",this._onOpen,this)},_refreshPrices:function(c){var a=this;var b=[];jQuery("#shoppingBasketTable tbody tr").each(function(d,e){var g=jQuery(e).find("td input[id^='id']").val();
var f=jQuery(e).find("td input[id^='count']").val();b.push([g,f])});if(jQuery("#localeGenuine").val()=="en_CA"||jQuery("#localeGenuine").val()=="en_US"){if(Shoppingbasket.tax_activeAdress=="inv"){activeCity=jQuery("#inv_city").val();
activeState=jQuery("#inv_state").val();activeZip=jQuery("#inv_pc").val()}else{if(Shoppingbasket.tax_activeAdress=="del"){activeCity=jQuery("#del_city").val();
activeState=jQuery("#del_state").val();activeZip=jQuery("#del_pc").val()}}a.callRpc("public.update",{orders:b,city:activeCity,state:activeState,zip:activeZip},function(e,d){if(!d&&e.status&&e.status==="OK"){a._updateView(e)
}else{a._showErrorDlg(a.msg_main.update_errors)}},this)}else{a.callRpc("public.update",{orders:b},function(e,d){if(!d&&e.status&&e.status==="OK"){a._updateView(e)
}else{a._showErrorDlg(a.msg_main.update_errors)}},this)}},_deleteArticle:function(a,c){var b=[];jQuery("#shoppingBasketTable tbody tr").each(function(d,e){if(!jQuery(e).find("#id_"+a).length){var g=jQuery(e).find("td input[id^='id']").val();
var f=jQuery(e).find("td input[id^='count']").val();b.push([g,f])}});if(jQuery("#localeGenuine").val()=="en_CA"||jQuery("#localeGenuine").val()=="en_US"){if(Shoppingbasket.tax_activeAdress=="inv"){activeCity=jQuery("#inv_city").val();
activeState=jQuery("#inv_state").val();activeZip=jQuery("#inv_pc").val()}else{if(Shoppingbasket.tax_activeAdress=="del"){activeCity=jQuery("#del_city").val();
activeState=jQuery("#del_state").val();activeZip=jQuery("#del_pc").val()}}this.callRpc("public.update",{orders:b,city:activeCity,state:activeState,zip:activeZip},function(e,d){if(!d&&e.status&&e.status==="OK"){jQuery(c).remove();
this._updateView(e)}else{this._showErrorDlg(this.msg_main.update_errors)}},this)}else{this.callRpc("public.update",{orders:b},function(e,d){if(!d&&e.status&&e.status==="OK"){jQuery(c).remove();
this._updateView(e)}else{this._showErrorDlg(this.msg_main.update_errors)}},this)}},_updateView:function(d){var c=this.getMainJQ();
var a=this;var b;c.find("#nodata").remove();if(d.nodata){c.find("#shoppingBasketTable tbody").append('<tr id="nodata"><td colspan="7">'+a.msg_main.no_items+"</td></tr>");
c.find("#price_subtotal").html("");c.find("#price_shipping").html("");c.find("#price_total").html("");
c.find("#price_total_vat").html("");c.find("#amount").html("")}else{if(d.products){c.find("td[id^='price_total_']").each(function(f,j){var g=j.id.split("_");
if(g[2]){for(var h in d.products){if(d.products[h].instance_id==g[2]){jQuery(j).html(d.products[h].price_total);
b=d.products[h].currency}}}})}if(d.price_subtotal){c.find("#price_subtotal").html(d.price_subtotal)}if(d.price_shipping){c.find("#price_shipping").html(d.price_shipping)
}var e=d.price_total.replace(b,"");if(d.price_total){c.find("#price_total").html(d.price_total);c.find("#amount").val(d.price_total_clean);
if(c.find("#localeGenuine").val()=="en_CA"||c.find("#localeGenuine").val()=="en_US"){c.find("td#taxContainer_totalValue").html(d.price_total);
c.find("#externalTax").val(d.externalTax);c.find("#amount").val(e)}}if(d.price_total_vat){c.find("#price_total_vat").html(d.price_total_vat);
if(c.find("#localeGenuine").val()=="en_CA"||c.find("#localeGenuine").val()=="en_US"){c.find("#taxContainer_taxValue").html(d.price_total_vat);
c.find("#externalTax").val(d.externalTax);c.find("#amount").val(e)}}}},_formSubmit:function(){var b=this;
var e=this.getMainJQ();var c={};var a=false;jQuery("#shoppingBasketTable tbody tr").each(function(g,h){var k=jQuery(h).find("td input[id^='id']").val();
var j=jQuery(h).find("td input[id^='count']").val();if(k&&j){a=true;c[k]=j}});var d={};jQuery("#shoppingBasketForm input").each(function(h,j){var g=jQuery(j).attr("name");
if(jQuery(j).attr("type")=="checkbox"){if(jQuery(j).is(":checked")){d[g]=1}else{d[g]=false}}else{if(jQuery(j).attr("type")=="radio"){if(jQuery(j).is(":checked")){d[g]=jQuery(j).val()
}}else{d[g]=jQuery(j).val()}}});jQuery("#shoppingBasketForm select").each(function(h,j){var g=jQuery(j).attr("name");
d[g]=jQuery(j).val()});if(!a){alert(b.msg_main.no_items);return false}if(jQuery("#externalTax").length>0){var f=jQuery("#externalTax").val()
}else{var f=""}b.callRpc("public.checkOut",{orders:c,form:d,externalTax:f},function(j,h){e.find(".error_icon").remove();
if(!h&&j&&!j.errors){e.find(".error-hint").hide();if(j.ack_text){jQuery(".ack-dialog .dlg-text .ack_text").html(j.ack_text)
}if(j.paypal){var i="<a href='https://www.paypal.com/us/cgi-bin/webscr?business="+encodeURIComponent(jQuery("#ppForm #business").val())+"&item_name="+encodeURIComponent(jQuery("#ppForm #business").val())+"&currency_code="+escape(jQuery("#ppForm #currency_code").val())+"&amount="+encodeURIComponent(jQuery("#ppForm #amount").val())+"&cmd="+encodeURIComponent(jQuery("#ppForm #cmd").val())+"' target='_blank'>"+b.msg_main.paypal_link+"</a>";
jQuery(".ack-dialog .dlg-text").append("<br/>"+b.msg_main.paypal_link_text+"<br /><br />"+i);e.find("#ppForm").submit()
}b._showDialog("ack");return true}else{if(j&&j.errors){var g=this.msg_main.form_errors;jQuery.each(j.errors,function(k,l){jQuery.each(l,function(n,m){if(k!=="msg"){b._showValidationError(k,m)
}else{g+="<br />"+m}})});e.find(".error-hint").html(g).show();return false}}},this);return true},_showErrorDlg:function(c){var b=this.getMainJQ();
var a=this;if(a._errorDlg===null){var d=b.find(".shoppingbasket-error-dialog");b.find(document.body).append(d);
a._errorDlg=new apsinth.util.Layer(d)}},_implodeRecursive:function(c){var a="";var b=this;jQuery(c).each(function(d,f){if(typeof(f)==="string"){a+=f
}else{a+=b._implodeRecursive(f)}});return a},_showDialog:function(a){var b=this.getMainJQ().find("#shoppingBasketDialogs");
jQuery(document.body).append(b);jQuery("."+a+"-dialog").show();this.getMainJQ().find("."+a+"-dialog").show();
if(this.sbDgl===undefined){this.sbDgl=new apsinth.util.Layer(b)}b.find(".ccclose, .homepage").click(this.toHandler(function(c){b.find("[class$=dialog]").hide();
this.sbDgl.hide();if(a==="ack"){window.location.href=nonSslServerUrl}},this));this.sbDgl.showAbove(this.getMainJQ(),true,0)
},_hideDialog:function(){},_showValidationError:function(e,d){var c=this.getMainJQ();d=d.replace(/\'/g,"");
var b=document.createElement("span");jQuery(b).addClass("error_icon");jQuery(b).html(" ");var a=c.find("#"+e);
if(a.length&&jQuery(c.find("[name='"+e+"']")).attr("type")!=="radio"){if(jQuery(a).next().length){jQuery(a).next().after(b)
}else{jQuery(a).after(b)}}else{c.find("#"+e+"-label + td").append(b)}jQuery(b).bind("mouseover",this.toHandler(function(k){var n=jQuery('<span class="error_popup"></span>');
n.text(d);jQuery(k.target).append(n);var f=jQuery(window).width();jQuery(".error_popup").show();var h=jQuery(".error_popup").offset().left;
var m=jQuery(".error_popup").width();var g=h+m;if(g>=f){var l=(f-h)-20;jQuery(".error_popup").width(l);
var i=jQuery(".error_popup").html();var j=/(.*?)\s+(.*)(\s).*/;var o=j.exec(i);i=i.replace(RegExp.$1,RegExp.$1+"<br/>");
jQuery(".error_popup").html(i);jQuery(".error_popup").css({"word-wrap":"break-word","white-space":"normal"})
}},this));jQuery(b).bind("mouseout",this.toHandler(function(f){jQuery(".error_popup").hide();jQuery(".error_popup").remove()
},this))},_setTaxHandler:function(a){var d=this.getMainJQ();var c=d.find("#localeGenuine").val();Shoppingbasket.tax_activeAdress=a;
if(a=="inv"){currentCity=d.find("#inv_city");currentState=d.find("#inv_state");currentZip=d.find("#inv_pc")
}else{currentCity=d.find("#del_city");currentState=d.find("#del_state");currentZip=d.find("#del_pc")}if(c=="en_CA"||c=="en_US"){this._resetTaxHandler(a);
var b=this;d.find("div.taxContainer").css("display","block");d.find("td#taxContainer_taxValue").html("$ 0.00");
d.find("td#taxContainer_totalValue").html(d.find("td#price_total").html());currentCity.focusout(function(){b._revalidateTaxField(a,"City",currentCity,c)
});currentState.change(function(){b._revalidateTaxField(a,"State",currentState,c)});currentZip.focusout(function(){b._revalidateTaxField(a,"Zip",currentZip,c)
});if(Shoppingbasket.tax_cityCheck!=0||Shoppingbasket.tax_stateCheck!=0||Shoppingbasket.tax_zipCheck!=0){b._revalidateTaxField(a,"City",currentCity,c);
b._revalidateTaxField(a,"State",currentState,c);b._revalidateTaxField(a,"Zip",currentZip,c)}}},_revalidateTaxField:function(b,e,a,d){var c=this.getMainJQ();
switch(e){case"City":if(a.val().length>0){c.find("img#city_good").css("display","inline");Shoppingbasket.tax_cityCheck=1
}else{c.find("img#city_good").css("display","none");Shoppingbasket.tax_cityCheck=0}break;case"State":if(a.val()!="default"){c.find("img#state_good").css("display","inline");
Shoppingbasket.tax_stateCheck=1}else{c.find("img#state_good").css("display","none");Shoppingbasket.tax_stateCheck=0
}break;case"Zip":if(d=="en_CA"){regex=/^[0-9A-Z]{3}[ ]*[0-9A-Z]{3}$/i}else{if(d=="en_US"){regex=/^([0-9]{5}|[0-9]{5}[-]?[0-9]{4})$/
}}result=regex.exec(a.val());if(result){c.find("img#zip_good").css("display","inline");Shoppingbasket.tax_zipCheck=1
}else{c.find("img#zip_good").css("display","none");Shoppingbasket.tax_zipCheck=0}break}if(Shoppingbasket.tax_cityCheck==1&&Shoppingbasket.tax_stateCheck==1&&Shoppingbasket.tax_zipCheck==1){this._refreshPrices()
}else{c.find("#taxContainer_taxValue").html("$ 0.00");c.find("#taxContainer_totalValue").html(c.find("td#price_total").html())
}},_resetTaxHandler:function(a){var b=this.getMainJQ();if(a=="inv"){b.find("#del_city").focusout(function(){});
b.find("#del_state").focusout(function(){});b.find("#del_pc").focusout(function(){});b.find("div.taxContainer").css("top","-260px")
}else{b.find("#inv_city").focusout(function(){});b.find("#inv_state").focusout(function(){});b.find("#inv_pc").focusout(function(){});
b.find("div.taxContainer").css("top","-177px")}b.find("img#zip_good").css("display","none");b.find("img#state_good").css("display","none");
b.find("img#city_good").css("display","none");Shoppingbasket.tax_cityCheck=0;Shoppingbasket.tax_stateCheck=0;
Shoppingbasket.tax_zipCheck=0}});shoppingbasket.msg.main_Shoppingbasket={delete_article:"Delete item?",form_errors:"An error has occurred.",no_items:"No items in the shopping cart.",paypal_link:"Pay via PayPal",paypal_link_text:"Please click this link if your browser does not automatically open a new window for the PayPal payment:"};
var ProfisellerNews=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:300,initialize:function(c,b,a,d){this._super(c,b,a,d)
},_setMinWidthStyles:function(){var a=document.getElementById("modul_"+this.moduleId);var b=document.getElementById("modul_"+this.moduleId+"_formdiv");
var c=jQuery("#modul_"+this.moduleId).css("width");a.style.width=c;b.style.width=c;b.position="relative"
}});var ProfisellerBanner=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:300,initialize:function(c,b,a,d){this._super(c,b,a,d)
},getConfigData:function(){var a=this.getConfigJQ();return{hActiveImageId:a.find("#hActiveImageId").val()}
},_initMainView:function(){},_initConfigView:function(){var a=this.getConfigJQ();a.find("[name='BannerImage']").click(this.toHandler(function(b){this.changeImageStatus(b)
}))},changeImageStatus:function(a){var c=this.getConfigJQ();var b=a.target.parentNode;jQuery("#"+b.parentNode.id).find("img").attr("class","profiseller_banner_admin_image selectable-box");
a.target.className="profiseller_banner_admin_image_active selectable-box no-hover-on-active selected";
c.find("#hActiveImageId").val(a.target.id)}});var ProfisellerTeaser=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:300,initialize:function(c,b,a,d){this._super(c,b,a,d)
},getConfigData:function(){var a=this.getConfigJQ();return{hActiveImageIdLeft:a.find("#hActiveImageIdLeft").val(),hActiveImageIdRight:a.find("#hActiveImageIdRight").val()}
},_initMainView:function(){},_initConfigView:function(){var a=this;var b=this.getConfigJQ();b.find("[name='TeaserImage']").click(this.toHandler(function(c){this.changeImageStatus(c)
}))},changeImageStatus:function(a){var c=this.getConfigJQ();var b=a.target.parentNode;jQuery(b.parentNode).find("img").removeClass("selected");
jQuery(a.target).addClass("selected");if(b.parentNode.id.indexOf("Left")!=-1){c.find("#hActiveImageIdLeft").val(a.target.id)
}else{c.find("#hActiveImageIdRight").val(a.target.id)}}});window.FacebookModule={msg:{},jsInjected:false};
var Facebook=apsinth.ApsinthModule.extend({errorTarget:".facebook_error_placeholder",CONFIG_MIN_WIDTH:480,initialize:function(c,b,a,d){this._super(c,b,a,d)
},validateConfig:function(){var b=true;var c=this.getConfigJQ();var a={badge:c.find('input[name="badge"]').attr("checked")?1:0,badge_show_photo:c.find('input[name="badge_show_photo"]').attr("checked")?1:0,badge_show_name:c.find('input[name="badge_show_name"]').attr("checked")?1:0,badge_show_fans:c.find('input[name="badge_show_fans"]').attr("checked")?1:0};
this.form.diy_form("clearErrors");if(a.badge&&!a.badge_show_photo&&!a.badge_show_name&&!a.badge_show_fans){this.form.diy_form("addError",FacebookModule.msg.error.invalid_badge_options);
b=false}return b},getConfigData:function(){var b=this.getConfigJQ();var a={like_box:b.find('input[name="like_box"]').attr("checked")?1:0,page_url:b.find('input[name="page_url"]').val(),show_faces:b.find('input[name="show_faces"]').attr("checked")?1:0,show_stream:b.find('input[name="show_stream"]').attr("checked")?1:0,like_button:b.find('input[name="like_button"]').attr("checked")?1:0,color:b.find('select[name="color"]').val(),badge:b.find('input[name="badge"]').attr("checked")?1:0,badge_url:b.find('input[name="badge_url"]').val(),badge_show_photo:b.find('input[name="badge_show_photo"]').attr("checked")?1:0,badge_show_name:b.find('input[name="badge_show_name"]').attr("checked")?1:0,badge_show_fans:b.find('input[name="badge_show_fans"]').attr("checked")?1:0};
return a},_injectFacebookScript:function(e,a,f){var c,b=e.getElementsByTagName(a)[0];if(e.getElementById(f)){return
}c=e.createElement(a);c.id=f;c.src="//connect.facebook.net/"+apsinth.lang+"/all.js#xfbml=1";b.parentNode.insertBefore(c,b)
},_initFacebookSDK:function(){if(false==FacebookModule.jsInjected){jQuery(document.body).append('<div id="fb-root"></div>');
this._injectFacebookScript(document,"script","facebook-jssdk");FacebookModule.jsInjected=true}},_initMainView:function(){var g=this.getMainJQ();
var b=g.width();var e=g.find(".fb-like-box");var a=g.find(".fb-like");var d=g.find(".facebook-badge");
this.initMainViewBadges(d,b);if(e.length>0||a.length>0){this._initFacebookSDK()}if(window.FB){this.initMainViewWidgets(e,a,b)
}else{var h=document.getElementById("facebook-jssdk");var f=this;var c=function(){if(!this.readyState||this.readyState=="loaded"||this.readyState=="complete"){f.toHandler(function(){f.initMainViewWidgets(e,a,b)
})()}};jQuery(h).load(c);jQuery(h).bind("readystatechange",c)}},initMainViewBadges:function(e,a){if(e){for(var d=0;
d<e.length;d++){var b=jQuery(e[d]).attr("id");var f=jQuery(e[d]).attr("data-user");if(b&&f){this.loadBadge(b,f)
}}if(a<350){var e=this.getMainJQ().find(".horizontal");e.removeClass("horizontal").addClass("vertical")
}else{var c=a-(e.outerWidth()-e.width());e.css("width",c+"px")}}},initMainViewWidgets:function(c,b,a){if(c){c.attr("data-width",a)
}if(b){b.attr("data-width",a);var d=35;if(a<225){d=20;b.attr("data-layout","button_count")}else{if(a<450){d=60
}}FB.Event.subscribe("xfbml.render",function(){var e={width:a+"px",height:d+"px"};b.find("iframe").css(e);
b.css(e)})}if(this.mode=="admin"&&window.FB){FB.XFBML.parse(this.getMainJQ().get(0))}},_initConfigView:function(){var a=this.getConfigJQ();
this.disableToggleInit("like_box","likeBox");this.disableToggleInit("like_button","likeButton");this.disableToggleInit("badge","badge");
jQuery("#modul_"+this.moduleId+" .wrapper-color").diy_combobox({editable:false});a.find(".form-item input.checkbox").diy_checkbox();
a.find("input[type='text'], textarea").diy_textField();this.form=a.find("form").diy_form({messageTarget:this.errorTarget})
},disableToggleInit:function(a,b){var e=this.getConfigJQ();var d=e.find('input[name="'+a+'"]');var c=e.find("."+b+" .facebook-optionset-disable input, ."+b+" .facebook-optionset-disable select");
if(!d.attr("checked")){c.attr("disabled","disabled");c.filter('input[type="checkbox"]').diy_checkbox({disabled:true})
}d.change(function(f){if(d.attr("checked")){c.removeAttr("disabled");c.filter('input[type="checkbox"]').diy_checkbox({disabled:false})
}else{c.attr("disabled","disabled");c.filter('input[type="checkbox"]').diy_checkbox({disabled:true})}})
},loadBadge:function(b,c){var d="https://graph.facebook.com/"+c;var a=jQuery("#"+b);if(!a){return}jQuery.jsonp({url:d,callbackParameter:"callback",callback:b,success:this.toHandler(function(h){if(h){var k=h.id;
var e=h.name;var g="http://graph.facebook.com/"+k+"/picture?type=normal";var f=h.likes;var j=a.find(".profile-image");
j.attr("src",g);j.find(".profile-image").attr("alt",e);a.find(".badge-name").html(e);var i=a.find(".badge-fans");
if(f&&i){i.html(this.numberFormat(f))}else{a.find(".badge-fans-container").remove()}if(j[0]){j.load(function(){a.find(".badge-loader").hide();
a.find(".badge-data").css("visibility","visible")})}else{a.find(".badge-loader").hide();a.find(".badge-data").css("visibility","visible")
}}}),error:function(){}})},numberFormat:function(b){b+="";x=b.split(".");x1=x[0];x2=x.length>1?"."+x[1]:"";
var a=/(\d+)(\d{3})/;while(a.test(x1)){x1=x1.replace(a,"$1,$2")}return x1+x2}});window.TwitterModule={util:{},main:{},config:{},msg:{}};
var Twitter=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:580,settings:{widget:null,widget_type:null,widget_title:null,widget_search:null,widget_profile_username:null,widget_list_username:null,widget_list_id:null,follow:null,follow_username:null,follow_type:null,tweet:null},msg:null,listsRetrievedUsername:null,listsRetrievedTime:null,widget:null,form:null,initialize:function(c,b,a,d){this._super(c,b,a,d);
this.msg=TwitterModule.msg},readSettings:function(){var b=this.getConfigJQ();var a=this.settings;this._removeDefaultInputValues();
this.form.diy_form("clearErrors");a.widget=b.find('input[name="widget"]').attr("checked")?1:0;a.widget_type=b.find('input[name="widget_type"]:checked').val();
a.widget_tweets=b.find('input[name="widget_tweets"]').val();a.widget_title=b.find('input[name="widget_title"]').val();
a.widget_search=b.find('input[name="widget_search"]').val();a.widget_profile_username=b.find('input[name="widget_profile_username"]').val();
a.widget_list_username=b.find('input[name="widget_list_username"]').val();a.widget_list_id=b.find('select[name="widget_list_name"]').val();
a.follow=b.find('input[name="follow"]').attr("checked")?1:0;a.follow_username=b.find('input[name="follow_username"]').val();
a.follow_type=b.find('select[name="follow_type"]').val();a.tweet=b.find('input[name="tweet"]').attr("checked")?1:0;
this._initDefaultInputValues()},validateConfig:function(){this.readSettings();var a=this.settings;var b=true;
if(a.widget){if(!a.widget_type){this.form.diy_form("addError",this.msg.config_error.no_widget);b=false
}switch(a.widget_type){case"search":if(!a.widget_search||a.widget_search.replace(/\s/g,"")==""){this.form.diy_form("addError",this.msg.config_error.no_search_query,'input[name="widget_search"]');
b=false}break;case"list":if(!a.widget_list_username||a.widget_list_username.replace(/\s/g,"")==""){this.form.diy_form("addError",this.msg.config_error.no_list_username,'input[name="widget_list_username"]');
b=false}if(!a.widget_list_id||a.widget_list_id.replace(/\s/g,"")==""){this.form.diy_form("addError",this.msg.config_error.no_list,'input[name="widget_list_username"] + .twitter-config-compobox-placeholder');
b=false}break;case"profile":if(!a.widget_profile_username||a.widget_profile_username.replace(/\s/g,"")==""){this.form.diy_form("addError",this.msg.config_error.no_profile_username,'input[name="widget_profile_username"]');
b=false}}if(!a.widget_tweets||a.widget_tweets<1||a.widget_tweets>100){this.form.diy_form("addError",this.msg.config_error.invalid_tweet_count);
b=false}}else{if(a.follow){if(!a.follow_username||a.follow_username.replace(/\s/g,"")==""){this.form.diy_form("addError",this.msg.config_error.no_follow_username,'input[name="follow_username"]');
b=false}if(!a.follow_type||a.follow_type.replace(/\s/g,"")==""){this.form.diy_form("addError",this.msg.config_error.no_follow_type);
b=false}}}return b},getConfigData:function(){var a=this.getConfigJQ();return this.settings},_initMainView:function(){var c=this.getMainJQ();
var b=c.find(".twtr-widget-base");if(b.length>0){this.initWidget(b[0])}TWTR1and1.UseExternalIntentHandler=true;
var a=c.find(".twitter-tweet-button");if(a.length>0||b.length>0){if(typeof twttr!="undefined"&&twttr.widgets&&twttr.widgets.load){twttr.widgets.load()
}else{var d=jQuery('<script type="text/javascript" src="http://platform.twitter.com/widgets.js"><\/script>');
c.find(".twitter-container").append(d)}}},initWidget:function(a){var a=jQuery(a);var b={elementId:a.attr("id"),type:a.attr("data-param-type"),rpp:a.attr("data-param-rpp"),interval:a.attr("data-param-interval"),search:a.attr("data-param-search"),avatars:a.attr("data-param-avatars"),username:a.attr("data-param-username"),listId:a.attr("data-param-list-id")};
this.widget=new TWTR1and1.Widget({version:2,id:b.elementId,type:b.type,rpp:b.rpp,interval:b.interval,search:b.search,width:"auto",height:300,module:this,features:{scrollbar:true,loop:true,live:true,hashtags:true,timestamp:true,avatars:b.avatars,behavior:"all"}});
switch(b.type){case"profile":this.widget.setUser(b.username);break;case"list":this.widget.setList(b.username,b.listId);
break}this.widget.render().start()},_initConfigView:function(){var a=this.getConfigJQ();a.find('input[type="checkbox"]').diy_checkbox();
a.find('input[type="radio"]').diy_radiobox();a.find("div.twitter-config-compobox-placeholder").diy_combobox();
a.find("button.widget-list-find-button").button();a.find("input[type='text'], select").diy_textField();
this.form=a.find("form").diy_form({messageTarget:".form-error"});this.bind("open-config",this.toHandler(this.configOpenHandler),this)
},configOpenHandler:function(a){var c=this.getConfigJQ();this.triggerGetLists();c.find("input.twtr-widget-select-checkbox").change(this.toHandler(this.toggleInputs));
c.find("input.twtr-follow-select-checkbox").change(this.toHandler(this.toggleInputs));var b;c.find('input[name="widget_list_username"]').change(this.toHandler(this.triggerGetLists));
c.find('input[name="widget_list_username"]').keyup(this.toHandler(function(){if(b){clearTimeout(b)}b=setTimeout(this.toHandler(this.triggerGetLists),1000)
}));c.find("input.twtr-widget-select-checkbox").change(this.toHandler(this.triggerGetLists));c.find("input[name=widget_type].widget_type_list").change(this.toHandler(this.triggerGetLists));
c.find("button.widget-list-find-button").click(this.toHandler(function(d){d.preventDefault();this.readSettings();
var f=this.settings.widget_list_username;if(!this.settings.widget||this.settings.widget_type!="list"){this.form.diy_form("addError",this.msg.config_error.list_widget_not_selected)
}else{if(!f){this.form.diy_form("addError",this.msg.config_error.no_list_username)}else{this.triggerGetLists(d)
}}}))},toggleInputs:function(d){var b=!(jQuery(d.target).attr("checked"));var c=jQuery(d.target).attr("data-toggle-class");
var e=this.getConfigJQ();var a=e.find("."+c);if(a){a.find("input, select, button").each(function(g,f){if(f.type&&f.type!="checkbox"){if(b){if(jQuery(f).is(":diy-radiobox")){jQuery(f).button("option","disabled",true)
}if(jQuery(f).is(".widget-list-find-button")){jQuery(f).button("option","disabled",true)}jQuery(f).attr("disabled","disabled")
}else{if(jQuery(f).is(":diy-radiobox")){jQuery(f).button("option","disabled",false)}if(jQuery(f).is(".widget-list-find-button")){jQuery(f).button("option","disabled",false)
}jQuery(f).removeAttr("disabled")}}})}},triggerGetLists:function(){var f=this.getConfigJQ();this.readSettings();
var g=this.settings.widget_list_username;var d=f.find('select[name="widget_list_name"]');var b=d.val()||f.find('input[name="widget_list_id_selected"]').val();
var e=f.find("button.widget-list-find-button");var a=f.find("img.widget-list-loading");var c=this.msg.config_error.list_jsonp_failed;
e.hide();if(this.settings.widget&&this.settings.widget_type=="list"&&g&&g!=f.find('input[name="widget_list_username"]').attr("data-default-value")){jQuery("#twitter"+this.idPrefix+"__widgetListSelect_combox").hide();
a.css("display","inline");this.getLists(g,d,a,e,b)}else{d.attr("disabled","disabled");a.hide();jQuery("#twitter"+this.idPrefix+"__widgetListSelect_combox").show()
}},getLists:function(f,b,g,j,e){var c=new Date();var h=this;var a=this.idPrefix;if(c.getTime()<=this.listsRetrievedTime+30000&&this.listsRetrievedUsername==f){i();
return}function i(){g.hide();j.hide();jQuery("#twitter"+a+"__widgetListSelect_combox").show()}function d(){jQuery("#twitter"+a+"__widgetListSelect_combox").hide();
g.hide();j.show()}jQuery.jsonp({url:"http://api.twitter.com/1/"+f+"/lists.json",callbackParameter:"callback",success:this.toHandler(function(n){var p=false;
if(n&&n.lists){var k=n.lists;if(k.length>0){b.removeAttr("disabled");var l="";var o="";for(var m=0;m<k.length;
m++){if(m in k){o=k[m].slug==e?'selected="selected"':"";l+='<option value="'+k[m].slug+'" '+o+" >"+k[m].name+"</option>"
}}b.html(l);p=true;this.listsRetrievedTime=c.getTime();this.listsRetrievedUsername=f}if(!p){h.form.diy_form("addError",this.msg.config_error.no_lists);
l+='<option value="">'+this.msg.config_error.no_lists+"</option>";b.html(l);b.attr("disabled","disabled");
i()}else{i()}}else{h.form.diy_form("addError",this.msg.config_error.no_lists);i();b.attr("disabled","disabled")
}}),error:this.toHandler(function(){h.form.diy_form("addError",this.msg.config_error.list_jsonp_failed);
d()})})},onDelete:function(){if(this.widget){this.widget.stop();this.widget.removeEvents();this.widget=null
}}});TWTR1and1=window.TWTR1and1||{};if(!Array.forEach){Array.prototype.filter=function(f,g){var e=g||window;
var b=[];for(var d=0,c=this.length;d<c;++d){if(!f.call(e,this[d],d,this)){continue}b.push(this[d])}return b
};Array.prototype.indexOf=function(b,c){var c=c||0;for(var a=0;a<this.length;++a){if(this[a]===b){return a
}}return -1}}(function(){if(TWTR1and1&&TWTR1and1.Widget){return}function f(l,o,k){for(var n=0,m=l.length;
n<m;++n){o.call(k||window,l[n],n,l)}}function b(i,k,j){this.el=i;this.prop=k;this.from=j.from;this.to=j.to;
this.time=j.time;this.callback=j.callback;this.animDiff=this.to-this.from}b.canTransition=function(){var i=document.createElement("twitter");
i.style.cssText="-webkit-transition: all .5s linear;";return !!i.style.webkitTransitionProperty}();b.prototype._setStyle=function(i){switch(this.prop){case"opacity":this.el.style[this.prop]=i;
this.el.style.filter="alpha(opacity="+i*100+")";break;default:this.el.style[this.prop]=i+"px";break}};
b.prototype._animate=function(){var i=this;this.now=new Date();this.diff=this.now-this.startTime;if(this.diff>this.time){this._setStyle(this.to);
if(this.callback){this.callback.call(this)}clearInterval(this.timer);return}this.percentage=(Math.floor((this.diff/this.time)*100)/100);
this.val=(this.animDiff*this.percentage)+this.from;this._setStyle(this.val)};b.prototype.start=function(){var i=this;
this.startTime=new Date();this.timer=setInterval(function(){i._animate.call(i)},15)};TWTR1and1.Widget=function(i){this.init(i)
};TWTR1and1.UseExternalIntentHandler=false;(function(){var z={};var u=location.protocol.match(/https/);
var w=/^.+\/profile_images/;var E="https://s3.amazonaws.com/twitter_production/profile_images";var F=function(P){return u?P.replace(w,E):P
};var O={};var M=function(Q){var P=O[Q];if(!P){P=new RegExp("(?:^|\\s+)"+Q+"(?:\\s+|$)");O[Q]=P}return P
};var j=function(T,X,U,V){var X=X||"*";var U=U||document;var Q=[],P=U.getElementsByTagName(X),W=M(T);
for(var R=0,S=P.length;R<S;++R){if(W.test(P[R].className)){Q[Q.length]=P[R];if(V){V.call(P[R],P[R])}}}return Q
};var N=function(){var P=navigator.userAgent;return{ie:P.match(/MSIE\s([^;]*)/)}}();var n=function(P){if(typeof P=="string"){return document.getElementById(P)
}return P};var H=function(P){return P.replace(/^\s+|\s+$/g,"")};var D=function(){var P=self.innerHeight;
var Q=document.compatMode;if((Q||N.ie)){P=(Q=="CSS1Compat")?document.documentElement.clientHeight:document.body.clientHeight
}return P};var L=function(R,P){var Q=R.target||R.srcElement;return P(Q)};var B=function(Q){try{if(Q&&3==Q.nodeType){return Q.parentNode
}else{return Q}}catch(P){}};var C=function(Q){var P=Q.relatedTarget;if(!P){if(Q.type=="mouseout"){P=Q.toElement
}else{if(Q.type=="mouseover"){P=Q.fromElement}}}return B(P)};var I=function(Q,P){P.parentNode.insertBefore(Q,P.nextSibling)
};var J=function(Q){try{Q.parentNode.removeChild(Q)}catch(P){}};var G=function(P){return P.firstChild
};var i=function(R){var Q=C(R);while(Q&&Q!=this){try{Q=Q.parentNode}catch(P){Q=this}}if(Q!=this){return true
}return false};var m=function(){if(document.defaultView&&document.defaultView.getComputedStyle){return function(Q,T){var S=null;
var R=document.defaultView.getComputedStyle(Q,"");if(R){S=R[T]}var P=Q.style[T]||S;return P}}else{if(document.documentElement.currentStyle&&N.ie){return function(P,R){var Q=P.currentStyle?P.currentStyle[R]:null;
return(P.style[R]||Q)}}}}();var K={has:function(P,Q){return new RegExp("(^|\\s)"+Q+"(\\s|$)").test(n(P).className)
},add:function(P,Q){if(!this.has(P,Q)){n(P).className=H(n(P).className)+" "+Q}},remove:function(P,Q){if(this.has(P,Q)){n(P).className=n(P).className.replace(new RegExp("(^|\\s)"+Q+"(\\s|$)","g"),"")
}}};var k={add:function(R,Q,P){if(R.addEventListener){R.addEventListener(Q,P,false)}else{R.attachEvent("on"+Q,function(){P.call(R,window.event)
})}},remove:function(R,Q,P){if(R.removeEventListener){R.removeEventListener(Q,P,false)}else{R.detachEvent("on"+Q,P)
}}};var t=function(){function Q(S){return parseInt((S).substring(0,2),16)}function P(S){return parseInt((S).substring(2,4),16)
}function R(S){return parseInt((S).substring(4,6),16)}return function(S){return[Q(S),P(S),R(S)]}}();var o={bool:function(P){return typeof P==="boolean"
},def:function(P){return !(typeof P==="undefined")},number:function(P){return typeof P==="number"&&isFinite(P)
},string:function(P){return typeof P==="string"},fn:function(P){return typeof P==="function"},array:function(P){if(P){return o.number(P.length)&&o.fn(P.splice)
}return false}};var s=["January","February","March","April","May","June","July","August","September","October","November","December"];
var A=function(S){var V=new Date(S);if(N.ie){V=Date.parse(S.replace(/( \+)/," UTC$1"))}var Q="";var P=function(){var W=V.getHours();
if(W>0&&W<13){Q="am";return W}else{if(W<1){Q="am";return 12}else{Q="pm";return W-12}}}();var R=V.getMinutes();
var U=V.getSeconds();function T(){var W=new Date();if(W.getDate()!=V.getDate()||W.getYear()!=V.getYear()||W.getMonth()!=V.getMonth()){return" - "+s[V.getMonth()]+" "+V.getDate()+", "+V.getFullYear()
}else{return""}}return P+":"+R+Q+T()};var y=function(V){var X=new Date();var T=new Date(V);if(N.ie){T=Date.parse(V.replace(/( \+)/," UTC$1"))
}var W=X-T;var Q=1000,R=Q*60,S=R*60,U=S*24,P=U*7;if(isNaN(W)||W<0){return""}if(W<Q*2){return"right now"
}if(W<R){return Math.floor(W/Q)+" seconds ago"}if(W<R*2){return"about 1 minute ago"}if(W<S){return Math.floor(W/R)+" minutes ago"
}if(W<S*2){return"about 1 hour ago"}if(W<U){return Math.floor(W/S)+" hours ago"}if(W>U&&W<U*2){return"yesterday"
}if(W<U*365){return Math.floor(W/U)+" days ago"}else{return"over a year ago"}};var q=function(T){if(!T){return
}var P=TwitterModule.msg.main_time.lt_1min;var Y=TwitterModule.msg.main_time.exactly_1min;var U=TwitterModule.msg.main_time.mins;
var V=TwitterModule.msg.main_time.exactly_1hour;var Q=TwitterModule.msg.main_time.hours;var S=TwitterModule.msg.main_time.exactly_1day;
var R=TwitterModule.msg.main_time.days;var W=new Date(T);if(N.ie){W=Date.parse(T.replace(/( \+)/," UTC$1"))
}var Z=(arguments.length>1)?arguments[1]:new Date();var X=parseInt((Z.getTime()-W)/1000);if(X<60){return P
}else{if(X<120){return Y}else{if(X<(60*60)){return U.replace("%1",(parseInt(X/60)).toString())}else{if(X<(120*60)){return V
}else{if(X<(24*60*60)){return Q.replace("%1",(parseInt(X/3600)).toString())}else{if(X<(48*60*60)){return S
}else{return R.replace("%1",(parseInt(X/86400)).toString())}}}}}}};var l={link:function(P){return P.replace(/\b(((https*\:\/\/)|www\.)[^\"\']+?)(([!?,.\)]+)?(\s|$))/g,function(V,U,S,R,Q){var T=S.match(/w/)?"http://":"";
return'<a class="twtr-hyperlink" target="_blank" href="'+T+U+'">'+((U.length>25)?U.substr(0,24)+"...":U)+"</a>"+Q
})},at:function(P){return P.replace(/\B[@＠]([a-zA-Z0-9_]{1,20})/g,function(Q,R){return'@<a target="_blank" class="twtr-atreply" href="http://twitter.com/intent/user?screen_name='+R+'">'+R+"</a>"
})},list:function(P){return P.replace(/\B[@＠]([a-zA-Z0-9_]{1,20}\/\w+)/g,function(Q,R){return'@<a target="_blank" class="twtr-atreply" href="http://twitter.com/'+R+'">'+R+"</a>"
})},hash:function(P){return P.replace(/(^|\s+)#(\w+)/gi,function(Q,R,S){return R+'<a target="_blank" class="twtr-hashtag" href="http://twitter.com/search?q=%23'+S+'">#'+S+"</a>"
})},clean:function(P){return this.hash(this.at(this.list(this.link(P))))}};function v(Q,R,P){this.job=Q;
this.decayFn=R;this.interval=P;this.decayRate=1;this.decayMultiplier=1.25;this.maxDecayTime=3*60*1000
}v.prototype={start:function(){this.stop().run();return this},stop:function(){if(this.worker){window.clearTimeout(this.worker)
}return this},run:function(){var P=this;this.job(function(){P.decayRate=P.decayFn()?Math.max(1,P.decayRate/P.decayMultiplier):P.decayRate*P.decayMultiplier;
var Q=P.interval*P.decayRate;Q=(Q>=P.maxDecayTime)?P.maxDecayTime:Q;Q=Math.floor(Q);P.worker=window.setTimeout(function(){P.run.call(P)
},Q)})},destroy:function(){this.stop();this.decayRate=1;return this}};function p(Q,P,R){this.time=Q||6000;
this.loop=P||false;this.repeated=0;this.callback=R;this.haystack=[]}p.prototype={set:function(P){this.haystack=P
},add:function(P){this.haystack.unshift(P)},start:function(){if(this.timer){return this}this._job();var P=this;
this.timer=setInterval(function(){P._job.call(P)},this.time);return this},stop:function(){if(this.timer){window.clearInterval(this.timer);
this.timer=null}return this},_next:function(){var P=this.haystack.shift();if(P&&this.loop){this.haystack.push(P)
}return P||null},_job:function(){var P=this._next();if(P){this.callback(P)}return this}};function r(R){function P(){if(R.needle.metadata&&R.needle.metadata.result_type&&R.needle.metadata.result_type=="popular"){return'<span class="twtr-popular">'+R.needle.metadata.recent_retweets+"+ "+TwitterModule.msg.main_content.recent_retweets+"</span>"
}else{return""}}var Q='<div class="twtr-tweet-wrap">         <div class="twtr-avatar">           <div class="twtr-img"><a target="_blank" href="http://twitter.com/intent/user?screen_name='+R.user+'"><img alt="'+R.user+' profile" src="'+F(R.avatar)+'"></a></div>         </div>         <div class="twtr-tweet-text">           <p>             <a target="_blank" href="http://twitter.com/intent/user?screen_name='+R.user+'" class="twtr-user">'+R.user+"</a> "+R.tweet+'             <em>            <a target="_blank" class="twtr-timestamp" time="'+R.timestamp+'" href="http://twitter.com/'+R.user+"/status/"+R.id+'">'+R.created_at+'</a> &middot;            <a target="_blank" class="twtr-reply" href="http://twitter.com/intent/tweet?in_reply_to='+R.id+'">'+TwitterModule.msg.main_content.reply+'</a> &middot;             <a target="_blank" class="twtr-rt" href="http://twitter.com/intent/retweet?tweet_id='+R.id+'">'+TwitterModule.msg.main_content.retweet+'</a> &middot;             <a target="_blank" class="twtr-fav" href="http://twitter.com/intent/favorite?tweet_id='+R.id+'">'+TwitterModule.msg.main_content.favorite+"</a>             </em> "+P()+"           </p>         </div>       </div>";
var S=document.createElement("div");S.id="tweet-id-"+ ++r._tweetCount;S.className="twtr-tweet";S.innerHTML=Q;
this.element=S}r._tweetCount=0;z.loadStyleSheet=function(R,Q){if(!TWTR1and1.Widget.loadingStyleSheet){TWTR1and1.Widget.loadingStyleSheet=true;
var P=document.createElement("link");P.href=R;P.rel="stylesheet";P.type="text/css";document.getElementsByTagName("head")[0].appendChild(P);
var S=setInterval(function(){var T=m(Q,"position");if(T=="relative"){clearInterval(S);S=null;TWTR1and1.Widget.hasLoadedStyleSheet=true
}},50)}};(function(){var P=false;z.css=function(S){var R=document.createElement("style");R.type="text/css";
if(N.ie){R.styleSheet.cssText=S}else{var T=document.createDocumentFragment();T.appendChild(document.createTextNode(S));
R.appendChild(T)}function Q(){document.getElementsByTagName("head")[0].appendChild(R)}if(!N.ie||P){Q()
}else{window.attachEvent("onload",function(){P=true;Q()})}}})();TWTR1and1.Widget.isLoaded=false;TWTR1and1.Widget.loadingStyleSheet=false;
TWTR1and1.Widget.hasLoadedStyleSheet=false;TWTR1and1.Widget.WIDGET_NUMBER=0;TWTR1and1.Widget.matches={mentions:/^@[a-zA-Z0-9_]{1,20}\b/,any_mentions:/\b@[a-zA-Z0-9_]{1,20}\b/};
TWTR1and1.Widget.jsonP=function(Q,P,R){Q=Q.replace(R,"?");jQuery.jsonp({url:Q,success:function(T){var S=R.replace("TWTR1and1.Widget.","");
TWTR1and1.Widget[S](T)},error:function(T,S){if(P){jQuery("#"+P).html('<div class="twtr-error-message">'+TwitterModule.msg.main_error.jsonp_failed+"</div>")
}}})};TWTR1and1.Widget.prototype=function(){var S=u?"https://":"http://";var V=window.location.hostname.match(/twitter\.com/)?(window.location.hostname+":"+window.location.port):"twitter.com";
var U=S+"search."+V+"/search.";var W=S+"api."+V+"/1/statuses/user_timeline.";var R=S+V+"/favorites/";
var T=S+"api."+V+"/1/";var Q=180000;var P=u?"https://twitter-widgets.s3.amazonaws.com/j/1/default.gif":"http://widgets.twimg.com/j/1/default.gif";
return{init:function(Y){var X=this;this._widgetNumber=++TWTR1and1.Widget.WIDGET_NUMBER;TWTR1and1.Widget["receiveCallback_"+this._widgetNumber]=function(Z){X._prePlay.call(X,Z)
};this.moduleInstance=Y.module;this._cb="TWTR1and1.Widget.receiveCallback_"+this._widgetNumber;this.opts=Y;
this._base=U;this._isRunning=false;this._hasOfficiallyStarted=false;this._hasNewSearchResults=false;this._rendered=false;
this._profileImage=false;this._isCreator=!!Y.creator;this._setWidgetType(Y.type);this.timesRequested=0;
this.runOnce=false;this.newResults=false;this.results=[];this.jsonMaxRequestTimeOut=19000;this.showedResults=[];
this.sinceId=1;this.source="TWITTERINC_WIDGET";this.id=Y.id||"twtr-widget-"+this._widgetNumber;this.tweets=0;
this.setDimensions(Y.width,Y.height);this.interval=Y.interval||180000;this.format="json";this.rpp=Y.rpp||50;
this.subject=Y.subject||"";this.title=Y.title||"";this.setFooterText(Y.footer);this.setSearch(Y.search);
this._setUrl();this.theme=Y.theme?Y.theme:this._getDefaultTheme();if(!Y.id){throw"Please provide a content id"
}this.widgetEl=n(this.id);if(Y.id){K.add(this.widgetEl,"twtr-widget")}if(Y.version>=2&&!TWTR1and1.Widget.hasLoadedStyleSheet){if(u){z.loadStyleSheet("https://twitter-widgets.s3.amazonaws.com/j/2/widget.css",this.widgetEl)
}else{if(Y.creator){z.loadStyleSheet("/stylesheets/widgets/widget.css",this.widgetEl)}else{z.loadStyleSheet("http://widgets.twimg.com/j/2/widget.css",this.widgetEl)
}}}this.occasionalJob=new v(function(Z){X.decay=Z;X._getResults.call(X)},function(){return X._decayDecider.call(X)
},Q);this._ready=o.fn(Y.ready)?Y.ready:function(){};this._isRelativeTime=true;this._tweetFilter=false;
this._avatars=true;this._isFullScreen=false;this._isLive=true;this._isScroll=false;this._loop=true;this._showTopTweets=(this._isSearchWidget)?true:false;
this._behavior="default";this.setFeatures(this.opts.features);this.intervalJob=new p(this.interval,this._loop,function(Z){X._normalizeTweet(Z)
});return this},setDimensions:function(X,Y){this.wh=(X&&Y)?[X,Y]:[250,300];if(X=="auto"||X=="100%"){this.wh[0]="100%"
}else{this.wh[0]=((this.wh[0]<150)?150:this.wh[0])+"px"}this.wh[1]=((this.wh[1]<100)?100:this.wh[1])+"px";
return this},setRpp:function(X){var X=parseInt(X);this.rpp=(o.number(X)&&(X>0&&X<=100))?X:30;return this
},_setWidgetType:function(X){this._isSearchWidget=false,this._isProfileWidget=false,this._isFavsWidget=false,this._isListWidget=false;
switch(X){case"profile":this._isProfileWidget=true;break;case"search":this._isSearchWidget=true,this.search=this.opts.search;
break;case"faves":case"favs":this._isFavsWidget=true;break;case"list":case"lists":this._isListWidget=true;
break}return this},setFeatures:function(Y){if(Y){if(o.def(Y.filters)){this._tweetFilter=Y.filters}if(o.def(Y.dateformat)){this._isRelativeTime=!!(Y.dateformat!=="absolute")
}if(o.def(Y.fullscreen)&&o.bool(Y.fullscreen)){if(Y.fullscreen){this._isFullScreen=true;this.wh[0]="100%";
this.wh[1]=(D()-90)+"px";var Z=this;k.add(window,"resize",function(ac){Z.wh[1]=D();Z._fullScreenResize()
})}}if(o.def(Y.loop)&&o.bool(Y.loop)){this._loop=Y.loop}if(o.def(Y.behavior)&&o.string(Y.behavior)){switch(Y.behavior){case"all":this._behavior="all";
break;case"preloaded":this._behavior="preloaded";break;default:this._behavior="default";break}}if(o.def(Y.toptweets)&&o.bool(Y.toptweets)){this._showTopTweets=Y.toptweets;
var X=(this._showTopTweets)?"inline-block":"none";z.css("#"+this.id+" .twtr-popular { display: "+X+"; }")
}if(!o.def(Y.toptweets)){this._showTopTweets=true;var X=(this._showTopTweets)?"inline-block":"none";z.css("#"+this.id+" .twtr-popular { display: "+X+"; }")
}if(o.def(Y.avatars)&&o.bool(Y.avatars)){if(!Y.avatars){z.css("#"+this.id+" .twtr-avatar, #"+this.id+" .twtr-user { display: none; } #"+this.id+" .twtr-tweet-text { margin-left: 0; }");
this._avatars=false}else{var aa=(this._isFullScreen)?"90px":"40px";z.css("#"+this.id+" .twtr-avatar { display: block; } #"+this.id+" .twtr-user { display: inline; } #"+this.id+" .twtr-tweet-text { margin-left: "+aa+"; }");
this._avatars=true}}else{if(this._isProfileWidget){this.setFeatures({avatars:false});this._avatars=false
}else{this.setFeatures({avatars:true});this._avatars=true}}if(o.def(Y.hashtags)&&o.bool(Y.hashtags)){(!Y.hashtags)?z.css("#"+this.id+" a.twtr-hashtag { display: none; }"):""
}if(o.def(Y.timestamp)&&o.bool(Y.timestamp)){var ab=Y.timestamp?"block":"none";z.css("#"+this.id+" em { display: "+ab+"; }")
}if(o.def(Y.live)&&o.bool(Y.live)){this._isLive=Y.live}if(o.def(Y.scrollbar)&&o.bool(Y.scrollbar)){this._isScroll=Y.scrollbar
}}else{if(this._isProfileWidget){this.setFeatures({avatars:false});this._avatars=false}if(this._isProfileWidget||this._isFavsWidget){this.setFeatures({behavior:"all"})
}}return this},_fullScreenResize:function(){var X=j("twtr-timeline","div",document.body,function(Y){Y.style.height=(D()-90)+"px"
})},setTweetInterval:function(X){this.interval=X;return this},setBase:function(X){this._base=X;return this
},setUser:function(Y,X){this.username=Y;this.realname=X||" ";if(this._isFavsWidget){this.setBase(R+Y+".")
}else{if(this._isProfileWidget){this.setBase(W+this.format+"?screen_name="+Y)}}this.setSearch(" ");return this
},setList:function(Y,X){this.listslug=X.replace(/ /g,"-").toLowerCase();this.username=Y;this.setBase(T+Y+"/lists/"+this.listslug+"/statuses.");
this.setSearch(" ");return this},setProfileImage:function(Z){this._profileImage=Z;var X=this.moduleInstance.getMainJQ().find(".twtr-profile-img")[0];
var Y=this.moduleInstance.getMainJQ().find(".twtr-profile-img-anchor")[0];var aa=this.moduleInstance.getMainJQ().find(".twtr-profile-img-clear")[0];
if(X&&Y){X.src=F(Z);Y.href="http://twitter.com/intent/user?screen_name="+this.username;jQuery(Y).show();
jQuery(aa).show()}return this},setTitle:function(X){this.title=X;if(this.widgetEl.getElementsByTagName("h3")&&this.widgetEl.getElementsByTagName("h3")[0]){this.widgetEl.getElementsByTagName("h3")[0].innerHTML=this.title
}return this},setCaption:function(X){this.subject=X;if(this.widgetEl.getElementsByTagName("h4")&&this.widgetEl.getElementsByTagName("h4")[0]){this.widgetEl.getElementsByTagName("h4")[0].innerHTML=this.subject
}return this},setFooterText:function(X){this.footerText=(o.def(X)&&o.string(X))?X:"";if(this._rendered){this.byClass("twtr-join-conv","a").innerHTML=this.footerText
}return this},setSearch:function(X){this.searchString=X||"";this.search=encodeURIComponent(this.searchString);
this._setUrl();if(this._rendered){}return this},_getWidgetPath:function(){if(this._isProfileWidget){return this.username
}else{if(this._isFavsWidget){return this.username+"/favorites"}else{if(this._isListWidget){return this.username+"/lists/"+this.listslug
}else{return"#search?q="+this.search}}}},_setUrl:function(){var Y=this;function X(){return"&"+(+new Date)+"=cachebust"
}function Z(){return(Y.sinceId==1)?"":"&since_id="+Y.sinceId+"&refresh=true"}if(this._isProfileWidget){this.url=this._base+"&callback="+this._cb+"&include_rts=true&count="+this.rpp+Z()+"&clientsource="+this.source
}else{if(this._isFavsWidget||this._isListWidget){this.url=this._base+this.format+"?callback="+this._cb+Z()+"&include_rts=true&clientsource="+this.source
}else{this.url=this._base+this.format+"?q="+this.search+"&include_rts=true&callback="+this._cb+"&rpp="+this.rpp+Z()+"&clientsource="+this.source;
if(!this.runOnce){this.url+="&result_type=mixed"}}}this.url+=X();return this},_getRGB:function(X){return t(X.substring(1,7))
},setTheme:function(ac,X){var aa=this;var Y=" !important";var ab=((window.location.hostname.match(/twitter\.com/))&&(window.location.pathname.match(/goodies/)));
if(X||ab){Y=""}this.theme={shell:{background:function(){return ac.shell.background||aa._getDefaultTheme().shell.background
}(),color:function(){return ac.shell.color||aa._getDefaultTheme().shell.color}()},tweets:{background:function(){return ac.tweets.background||aa._getDefaultTheme().tweets.background
}(),color:function(){return ac.tweets.color||aa._getDefaultTheme().tweets.color}(),links:function(){return ac.tweets.links||aa._getDefaultTheme().tweets.links
}()}};var Z="#"+this.id+" .twtr-doc,                      #"+this.id+" .twtr-hd a,                      #"+this.id+" h3,                      #"+this.id+" h4,                      #"+this.id+" .twtr-popular {            background-color: "+this.theme.shell.background+Y+";            color: "+this.theme.shell.color+Y+";          }          #"+this.id+" .twtr-popular {            color: "+this.theme.tweets.color+Y+";            background-color: rgba("+this._getRGB(this.theme.shell.background)+", .3)"+Y+";          }          #"+this.id+" .twtr-tweet a {            color: "+this.theme.tweets.links+Y+";          }          #"+this.id+" .twtr-bd, #"+this.id+" .twtr-timeline i a,           #"+this.id+" .twtr-bd p {            color: "+this.theme.tweets.color+Y+";          }          #"+this.id+" .twtr-new-results,           #"+this.id+" .twtr-results-inner,           #"+this.id+" .twtr-timeline {            background: "+this.theme.tweets.background+Y+";          }";
if(N.ie){Z+="#"+this.id+" .twtr-tweet { background: "+this.theme.tweets.background+Y+"; }"}return this
},byClass:function(aa,X,Y){var Z=j(aa,X,n(this.id));return(Y)?Z:Z[0]},render:function(){var Z=this;if(!TWTR1and1.Widget.hasLoadedStyleSheet){window.setTimeout(function(){Z.render.call(Z)
},50);return this}this.setTheme(this.theme,this._isCreator);if(this._isProfileWidget){K.add(this.widgetEl,"twtr-widget-profile")
}if(this._isScroll){K.add(this.widgetEl,"twtr-scroll")}if(!this._isLive&&!this._isScroll){this.wh[1]="auto"
}if(this._isSearchWidget&&this._isFullScreen){document.title="Twitter search: "+escape(this.searchString)
}this.widgetEl.innerHTML=this._getWidgetHtml();var Y=this.byClass("twtr-timeline","div");if(this._isLive&&!this._isFullScreen){var aa=function(ab){if(Z._behavior==="all"){return
}if(i.call(this,ab)){Z.pause.call(Z)}};var X=function(ab){if(Z._behavior==="all"){return}if(i.call(this,ab)){Z.resume.call(Z)
}};this.removeEvents=function(){k.remove(Y,"mouseover",aa);k.remove(Y,"mouseout",X)};k.add(Y,"mouseover",aa);
k.add(Y,"mouseout",X)}this._rendered=true;this._ready();return this},removeEvents:function(){},_getDefaultTheme:function(){return{shell:{background:"#8ec1da",color:"#ffffff"},tweets:{background:"#ffffff",color:"#444444",links:"#1985b5"}}
},_getWidgetHtml:function(){var Z=this;function ab(){if(Z._isProfileWidget){return'<a target="_blank" href="http://twitter.com/" class="twtr-profile-img-anchor"><img alt="profile" class="twtr-profile-img" src="'+P+'"></a>                      <h3></h3>                      <h4></h4>'
}else{return"<h3>"+Z.title+"</h3><h4>"+Z.subject+"</h4>"}}function Y(){return Z._isFullScreen?" twtr-fullscreen":""
}var aa=u?"https://twitter-widgets.s3.amazonaws.com/i/widget-logo.png":"http://widgets.twimg.com/i/widget-logo.png";
if(this._isFullScreen){aa="https://twitter-widgets.s3.amazonaws.com/i/widget-logo-fullscreen.png"}var X='<div class="twtr-doc'+Y()+'" style="width: '+this.wh[0]+';">            <div class="twtr-bd">              <div class="twtr-timeline" style="height: '+this.wh[1]+';">                <div class="twtr-tweets">                  <div class="twtr-reference-tweet"></div>                  <!-- tweets show here -->                </div>              </div>            </div>          </div>';
return X},_appendTweet:function(X){this._insertNewResultsNumber();I(X,this.byClass("twtr-reference-tweet","div"));
return this},_slide:function(Y){var Z=this;var X=G(Y).offsetHeight;if(this.runOnce){new b(Y,"height",{from:0,to:X,time:500,callback:function(){Z._fade.call(Z,Y)
}}).start()}return this},_fade:function(X){var Y=this;if(b.canTransition){X.style.webkitTransition="opacity 0.5s ease-out";
X.style.opacity=1;return this}new b(X,"opacity",{from:0,to:1,time:500}).start();return this},_chop:function(){if(this._isScroll){return this
}var ac=this.byClass("twtr-tweet","div",true);var ad=this.byClass("twtr-new-results","div",true);if(ac.length){for(var Z=ac.length-1;
Z>=0;Z--){var ab=ac[Z];var aa=parseInt(ab.offsetTop);if(aa>parseInt(this.wh[1])){J(ab)}else{break}}if(ad.length>0){var X=ad[ad.length-1];
var Y=parseInt(X.offsetTop);if(Y>parseInt(this.wh[1])){J(X)}}}return this},_appendSlideFade:function(Y){var X=Y||this.tweet.element;
this._chop()._appendTweet(X)._slide(X);return this},_createTweet:function(X){X.timestamp=X.created_at;
X.created_at=this._isRelativeTime?q(X.created_at):A(X.created_at);this.tweet=new r(X);if(this._isLive&&this.runOnce){this.tweet.element.style.opacity=0;
this.tweet.element.style.filter="alpha(opacity:0)";this.tweet.element.style.height="0"}return this},_getResults:function(){var X=this;
this.timesRequested++;this.jsonRequestRunning=true;this.jsonRequestTimer=window.setTimeout(function(){if(X.jsonRequestRunning){clearTimeout(X.jsonRequestTimer);
X.jsonRequestTimer=null}X.jsonRequestRunning=false;X.newResults=false;if(X.decay){X.decay()}},this.jsonMaxRequestTimeOut);
TWTR1and1.Widget.jsonP(X.url,X.id,X._cb)},clear:function(){var Y=this.byClass("twtr-tweet","div",true);
var X=this.byClass("twtr-new-results","div",true);Y=Y.concat(X);f(Y,function(Z){J(Z)});return this},_sortByMagic:function(X){var Y=this;
if(this._tweetFilter){if(this._tweetFilter.negatives){X=X.filter(function(Z){if(!Y._tweetFilter.negatives.test(Z.text)){return Z
}})}if(this._tweetFilter.positives){X=X.filter(function(Z){if(Y._tweetFilter.positives.test(Z.text)){return Z
}})}}switch(this._behavior){case"all":this._sortByLatest(X);break;case"preloaded":default:this._sortByDefault(X);
break}if(this._isLive&&this._behavior!=="all"){this.intervalJob.set(this.results);this.intervalJob.start()
}return this},_loadTopTweetsAtTop:function(Z){var aa=[],ab=[],Y=[];f(Z,function(ac){if(ac.metadata&&ac.metadata.result_type&&ac.metadata.result_type=="popular"){ab.push(ac)
}else{aa.push(ac)}});var X=ab.concat(aa);return X},_sortByLatest:function(X){this.results=X;this.results=this.results.slice(0,this.rpp);
this.results=this._loadTopTweetsAtTop(this.results);this.results.reverse();return this},_sortByDefault:function(Y){var Z=this;
var X=function(ab){return new Date(ab).getTime()};this.results.unshift.apply(this.results,Y);f(this.results,function(ab){if(!ab.views){ab.views=0
}});this.results.sort(function(ac,ab){if(X(ac.created_at)>X(ab.created_at)){return -1}else{if(X(ac.created_at)<X(ab.created_at)){return 1
}else{return 0}}});this.results=this.results.slice(0,this.rpp);this.results=this._loadTopTweetsAtTop(this.results);
var aa=this.results;this.results=this.results.sort(function(ac,ab){if(ac.views<ab.views){return -1}else{if(ac.views>ab.views){return 1
}}return 0});if(!this._isLive){this.results.reverse()}},_prePlay:function(Y){if(this.jsonRequestTimer){clearTimeout(this.jsonRequestTimer);
this.jsonRequestTimer=null}if(Y.error){this.newResults=false}else{if(Y.results&&Y.results.length>0){this.response=Y;
this.newResults=true;this.sinceId=Y.max_id_str;this._sortByMagic(Y.results);if(this.isRunning()){this._play()
}}else{if((this._isProfileWidget||this._isFavsWidget||this._isListWidget)&&o.array(Y)&&Y.length){this.newResults=true;
if(!this._profileImage&&this._isProfileWidget){var X=Y[0].user.screen_name;this.setProfileImage(Y[0].user.profile_image_url)
}this.sinceId=Y[0].id_str;this._sortByMagic(Y);if(this.isRunning()){this._play()}}else{this.newResults=false
}}}this._setUrl();if(this._isLive){this.decay()}},_play:function(){var X=this;if(this.runOnce){this._hasNewSearchResults=true
}if(this._avatars){this._preloadImages(this.results)}if(this._isRelativeTime&&(this._behavior=="all"||this._behavior=="preloaded")){f(this.byClass("twtr-timestamp","a",true),function(Y){Y.innerHTML=q(Y.getAttribute("time"))
})}if(!this._isLive||this._behavior=="all"||this._behavior=="preloaded"){if(!this.byClass("twtr-reference-tweet","div")){this.stop();
return}f(this.results,function(Z){if(Z.retweeted_status){Z=Z.retweeted_status}if(X._isProfileWidget){Z.from_user=Z.user.screen_name;
Z.profile_image_url=Z.user.profile_image_url}if(X._isFavsWidget||X._isListWidget){Z.from_user=Z.user.screen_name;
Z.profile_image_url=Z.user.profile_image_url}Z.id=Z.id_str;X._createTweet({id:Z.id,user:Z.from_user,tweet:l.clean(Z.text),avatar:Z.profile_image_url,created_at:Z.created_at,needle:Z});
var Y=X.tweet.element;(X._behavior=="all")?X._appendSlideFade(Y):X._appendTweet(Y)});if(this._behavior!="preloaded"){return this
}}return this},_normalizeTweet:function(Y){var X=this;Y.views++;if(this._isProfileWidget){Y.from_user=X.username;
Y.profile_image_url=Y.user.profile_image_url}if(this._isFavsWidget||this._isListWidget){Y.from_user=Y.user.screen_name;
Y.profile_image_url=Y.user.profile_image_url}if(this._isFullScreen){Y.profile_image_url=Y.profile_image_url.replace(/_normal\./,"_bigger.")
}Y.id=Y.id_str;this._createTweet({id:Y.id,user:Y.from_user,tweet:l.clean(Y.text),avatar:Y.profile_image_url,created_at:Y.created_at,needle:Y})._appendSlideFade()
},_insertNewResultsNumber:function(){if(!this._hasNewSearchResults){this._hasNewSearchResults=false;return
}if(this.runOnce&&this._isSearchWidget){var aa=this.response.total>this.rpp?this.response.total:this.response.results.length;
var X=aa>1?"s":"";var Z=(this.response.warning&&this.response.warning.match(/adjusted since_id/))?"more than":"";
var Y=document.createElement("div");K.add(Y,"twtr-new-results");Y.innerHTML='<div class="twtr-results-inner"> &nbsp; </div>';
I(Y,this.byClass("twtr-reference-tweet","div"));this._hasNewSearchResults=false}},_preloadImages:function(X){if(this._isProfileWidget||this._isFavsWidget||this._isListWidget){f(X,function(Z){var Y=new Image();
Y.src=F(Z.user.profile_image_url)})}else{f(X,function(Y){(new Image()).src=F(Y.profile_image_url)})}},_decayDecider:function(){var X=false;
if(!this.runOnce){this.runOnce=true;X=true}else{if(this.newResults){X=true}}return X},start:function(){var X=this;
if(!this._rendered){setTimeout(function(){X.start.call(X)},50);return this}if(!this._isLive){this._getResults()
}else{this.occasionalJob.start()}this._isRunning=true;this._hasOfficiallyStarted=true;return this},stop:function(){this.occasionalJob.stop();
if(this.intervalJob){this.intervalJob.stop()}this._isRunning=false;return this},pause:function(){if(this.isRunning()&&this.intervalJob){this.intervalJob.stop();
K.add(this.widgetEl,"twtr-paused");this._isRunning=false}if(this._resumeTimer){clearTimeout(this._resumeTimer);
this._resumeTimer=null}return this},resume:function(){var X=this;if(!this.isRunning()&&this._hasOfficiallyStarted&&this.intervalJob){this._resumeTimer=window.setTimeout(function(){X.intervalJob.start();
X._isRunning=true;K.remove(X.widgetEl,"twtr-paused")},2000)}return this},isRunning:function(){return this._isRunning
},destroy:function(){this.stop();this.clear();this.runOnce=false;this._hasOfficiallyStarted=false;this._profileImage=false;
this._isLive=true;this._tweetFilter=false;this._isScroll=false;this.newResults=false;this._isRunning=false;
this.sinceId=1;this.results=[];this.showedResults=[];this.occasionalJob.destroy();if(this.jsonRequestRunning){clearTimeout(this.jsonRequestTimer)
}K.remove(this.widgetEl,"twtr-scroll");this.removeEvents();return this}}}()})();var e=/twitter\.com(\:\d{2,4})?\/intent\/(\w+)/,h={tweet:true,retweet:true,favorite:true},g="scrollbars=yes,resizable=yes,toolbar=no,location=yes",d=screen.height,c=screen.width;
function a(p){if(TWTR1and1.UseExternalIntentHandler===true){return}p=p||window.event;var o=p.target||p.srcElement,j,k,i,n,l;
while(o&&o.nodeName.toLowerCase()!=="a"){o=o.parentNode}if(o&&o.nodeName.toLowerCase()==="a"&&o.href){j=o.href.match(e);
if(j){k=550;i=(j[2] in h)?420:560;n=Math.round((c/2)-(k/2));l=0;if(d>i){l=Math.round((d/2)-(i/2))}window.open(o.href,"intent",g+",width="+k+",height="+i+",left="+n+",top="+l);
p.returnValue=false;p.preventDefault&&p.preventDefault()}}}if(document.addEventListener){document.addEventListener("click",a,false)
}else{if(document.attachEvent){document.attachEvent("onclick",a)}}})();TwitterModule.msg.main_time={lt_1min:"Less than one minute ago",exactly_1min:"One minute ago",mins:"%1 minutes ago",exactly_1hour:"One hour ago",hours:"%1 hours ago",exactly_1day:"One day ago",days:"%1 days ago"};
TwitterModule.msg.main_content={recent_retweets:"Retweets",reply:"Reply",retweet:"Retweet",favorite:"Favourite"};
TwitterModule.msg.main_error={jsonp_failed:"Unable to load element. Please try again later"};var SocialBookmark=apsinth.ApsinthModule.extend({errorTarget:"#custom_error_placeholder",CONFIG_MIN_WIDTH:300,initialize:function(c,b,a,d){this._super(c,b,a,d)
},_initMainView:function(){var a=this.getMainJQ();if(this.mode!="admin"){a.find("a.remote-social-networks-link").each(this.replaceLink)
}else{a.find("a.remote-social-networks-link").click(function(b){b.preventDefault()})}jQuery('.remote-cms-social-networks li input[type="checkbox"]').diy_checkbox()
},replaceLink:function(c,d){var e=jQuery(d);var a=e.attr("data-location");if(a){var f=document.getElementsByTagName("title")[0].innerHTML;
var b=document.location;a=unescape(a);f=encodeURIComponent(f);b=encodeURIComponent(b);a=a.replace("{{title}}",f);
a=a.replace("{{url}}",b);e.attr("href",a)}},_setMinWidthStyles:function(){var a=document.getElementById("modul_"+this.moduleId);
var b=document.getElementById("modul_"+this.moduleId+"_formdiv");var c=jQuery("#modul_"+this.moduleId).css("width");
a.style.width=c;b.style.width=c;b.position="relative"},getConfigData:function(){var a=this.getConfigJQ().find(".remote-cms-social-networks-checkbox:checked").map(function(){return jQuery(this).attr("name")
});return a}});window.FormModule={msg:{},fieldConfig:{},Field:function(){},FieldArray:function(){}};FormModule.msg.error={max_email:"You can specify up to 3 e-mail addresses as recipients.",email_required:"Enter at least 1 recipient e-mail address.",empty_enabled_fields:"All activated fields must have names.",captchafield:"Captcha (spam protection code)"};
var Form=apsinth.ApsinthModule.extend({CONFIG_MIN_WIDTH:550,fields:new FormModule.FieldArray(),fieldGroups:{},fieldConfig:{},deletableEventsSet:false,maxEmails:3,maxDeletableFields:5,errorTarget:".form-error",initialize:function(c,b,a,d){this._super(c,b,a,d)
},_initMainView:function(){var b=this;var a=this.getMainJQ();a.find("form[data-form-id="+b.moduleId+"]").submit(function(d){b.hideAllErrors();
if(b.mode==="admin"){return false}if(!b.validateFields()){return false}var c=b.getFieldsData();var f={fields:c};
f.proxyRequestPath=window.location.pathname;if(b.getMainJQ().find("[name=captcha]").size()>0){f.captcha=b.getMainJQ().find("[name=captcha]").val()
}b.callRpc("public.submitForm",f,function(e,g){if(e.status){b.getMainJQ().find(".form-headline, form").hide();
b.getMainJQ().find(".form-success").show();b.getMainJQ().find(".form-success-content").html(e.message)
}else{if(e.error&&e.error==="notvalid"){b.showAllErrors(e.ids);b.getMainJQ().find(".refresh").click()
}else{if(e.error&&e.error==="sendfailed"){b.showSendError();b.getMainJQ().find(".refresh").click()}}}});
return false})},validateFields:function(){var b=[];var c=true;this.getMainJQ().find("[data-field-id]").removeClass("error").each(function(d){var e=jQuery(this);
if(e.is("[data-field-required]")){var f=jQuery.trim(e.val()||"");if(f===""){e.addClass("error");c=false;
b.push(e.attr("data-field-id"))}else{if(e.is("[data-field-email]")){if(!/^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/.test(f)){c=false;
e.addClass("error");b.push(e.attr("data-field-id"))}}}}});if(this.getMainJQ().find("input[name=captcha]").size()===1){var a=this.getMainJQ().find("input[name=captcha]").val();
if(jQuery.trim(a)==""){c=false;b.push("captcha")}}this.showAllErrors(b);return c},showAllErrors:function(e){if(e.length===0){return
}var c=this.getMainJQ().find(".form-errors").show().find("ul");var b=[];for(var a=0;a<e.length;a++){if(e[a]==="captcha"){b.push(FormModule.msg.error.captchafield);
this.getMainJQ().find("[name=captcha]").addClass("error");continue}var d=jQuery("[data-field-id="+e[a]+"]").is("textarea")?"textarea":"text";
b.push(this.getMainJQ().find("label[for=mod-form-"+this.moduleId+"-"+d+"-"+e[a]+"]").find("span").text())
}c.append("<li>"+b.join("</li><li>")+"</li>")},showSendError:function(){this.getMainJQ().find(".form-error-send").show()
},hideAllErrors:function(){this.getMainJQ().find(".form-errors").hide().find("ul").empty();this.getMainJQ().find("[name=captcha]").removeClass("error");
this.getMainJQ().find(".form-error-send").hide()},getFieldsData:function(){var a={};this.getMainJQ().find("[data-field-id]").each(function(b){var d=jQuery(this);
var c=d.attr("data-field-id");if(d.is("textarea")||d.is("input[type=text]")){a[c]=d.val()}else{if(d.is("input[type=checkbox]")){a[c]=d.is(":checked")
}}});return a},_initConfigView:function(){var a=this.getConfigJQ();this.initFields(FormModule.fieldConfig[this.moduleId]);
a.find("input[type='text'], textarea").diy_textField();this.form=a.find("form").diy_form({messageTarget:".form-error"});
this.clearError()},getSettings:function(){var c=this.getConfigJQ();var b={email:c.find("input[name=email]").val(),captcha:c.find("input[name=captcha]").is(":checked"),headline:c.find("textarea[name=headline]").val(),fields:[]};
for(var a in this.fields){if(this.fields[a].getId&&!this.fields[a].deleted){b.fields.push({id:this.fields[a].getId(),name:this.fields[a].getName(),type_id:this.fields[a].getTypeId(),required:this.fields[a].getRequired(),enabled:this.fields[a].getEnabled(),deletable:this.fields[a].getDeletable()})
}}return b},validateConfig:function(){var e=true;var f=this.getConfigJQ();var d=this.getSettings();this.clearError();
if(!d.email){this.showError(FormModule.msg.error.email_required,'input[name="email"]');e=false}else{if(d.email.split(",").length>this.maxEmails){this.showError(FormModule.msg.error.max_email,'input[name="email"]');
e=false}}var c=0;for(var b in this.fields){if(b==parseInt(b)&&this.fields[b].getId&&!this.fields[b].deleted&&this.fields[b].getEnabled()&&this.fields[b].getName().length==0){var a=this.fields[b].getHtml().find(".name-input");
if(a.attr("type")=="text"&&!a.is(":diy-formField")){a.diy_textField()}c++;this.showError(FormModule.msg.error.empty_enabled_fields,this.fields[b].getHtml().find(".name-input"))
}}if(c){this.showError(FormModule.msg.error.empty_enabled_fields);e=false}return e},getConfigData:function(){var b=this.getConfigJQ();
var a=this.getSettings();return a},onConfigSaved:function(b,a){this._super(b,a);if(b.fields){this.initFields(b.fields)
}},clearError:function(){this.form.diy_form("clearErrors")},showError:function(b,a){this.form.diy_form("addError",b,a)
},initFields:function(a){this.setFieldData(a);this.renderFields()},setFieldData:function(a){this.fieldConfig=a
},renderFields:function(){this.getConfigJQ().find("[name=captcha]").diy_checkbox();jQuery("#form-fields-"+this.moduleId).html(" ");
this.fields=new FormModule.FieldArray();this.fieldGroups={};jQuery.each(this.fieldConfig,this.toHandler(this.renderFieldGroup));
this.refreshDeletableButtons();this.setDeletableEvents()},renderFieldGroup:function(c,a){var e;var g;
switch(parseInt(c)){case FormModule.Field.typeText:e="field-text";g=FormModule.msg.config.fields;break;
case FormModule.Field.typeCheckbox:e="field-checkbox";g=FormModule.msg.config.checkboxes;break;case FormModule.Field.typeTextarea:e="field-textarea";
g=FormModule.msg.config.textareas;break}var b=jQuery('<div class="form-field-container form-item"/>');
var f=jQuery('<span class="form-label" />');b.addClass(e);b.addClass("field-type-"+c);f.text(g+":");b.append(f);
this.fieldGroups[c]=new FormModule.FieldArray();jQuery("#form-fields-"+this.moduleId).append(b);var d=0;
jQuery.each(a,this.toHandler(function(k,h){var j=new FormModule.Field(h);var i=j.getHtml();b.append(i);
if(d===0&&c==FormModule.Field.typeText){i.find(".field-quickhelp").addClass("field-quickhelp-required").quickhelp(FormModule.msg.config.tooltip_required,true)
}this.fields.push(j);this.fieldGroups[c].push(j);d++}))},refreshDeletableButtons:function(){var a;var e;
var f;var d;for(var b in this.fieldGroups){a=this.fieldGroups[b];e=[];for(var c in a){d=a[c];if(d.deletable){d.getHtml().addClass("field-line-with-buttons").find(".field-buttons").attr("data-field-index",c).attr("data-field-type",b);
e.push(d.getHtml())}}if(e.length==1){d=e.pop();jQuery(d).find(".field-button-add").css("display","block");
jQuery(d).find(".field-button-delete").css("display","none")}else{if(e.length>1){jQuery.each(e,function(h,g){g.find(".field-button-add").hide();
g.find(".field-button-delete").css("display","block")});if(e.length<this.maxDeletableFields){jQuery(e.pop()).find(".field-button-add").css("display","block")
}}}}this._initDefaultInputValues()},setDeletableEvents:function(){if(!this.deletableEventsSet){this.deletableEventsSet=true;
jQuery(document).unbind(".formAddRemove"+this.instance_id);this.getConfigJQ().find(".field-button-add").live("click.formAddRemove"+this.instance_id,this.toHandler(this.addFieldHandler));
this.getConfigJQ().find(".field-button-delete").live("click.formAddRemove"+this.instance_id,this.toHandler(this.removeFieldHandler))
}},addField:function(b){if(!this.fieldGroups[b]){return}var a=this.getConfigJQ().find(".field-type-"+b);
var d=new FormModule.Field();d.typeId=parseInt(b);d.deletable=true;var c=d.getHtml();a.append(c);this.fields.push(d);
this.fieldGroups[b].push(d);this.refreshDeletableButtons()},removeField:function(a,b){if(!this.fieldGroups[a][b]){return
}this.fieldGroups[a][b].deleted=true;this.fieldGroups[a][b].getHtml().remove();this.fieldGroups[a].remove(parseInt(b));
this.refreshDeletableButtons()},addFieldHandler:function(c){var b=jQuery(c.currentTarget);var a=b.parent().attr("data-field-type");
if(a){this.addField(a)}},removeFieldHandler:function(d){var c=jQuery(d.currentTarget);var a=c.parent().attr("data-field-type");
var b=c.parent().attr("data-field-index");if(a){this.removeField(a,b)}}});

apsinth.version='branches/release-sprint50-';apsinth.debug=false;
