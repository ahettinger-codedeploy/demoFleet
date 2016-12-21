var start = 
{init:function()
{if(window.Cygnus==null||window.Cygnus=="undefined")
{window.Cygnus=function(selector)
{if(this instanceof Cygnus)
return this.init(selector);else
return new Cygnus(selector);};Cygnus.prototype={init:function(s)
{return Cygnus.Stage.getContainerFromElement($j(s));}};;(function(jQuery)
{jQuery.extend({isPopulated:function(obj)
{var populated=(obj!=null&&obj!=undefined);if(populated&&obj.constructor==String)
{populated=(obj.length>0&&obj!="undefined");}
return populated;},parseParam:function(param,otherwise)
{if(!jQuery.isPopulated(otherwise))otherwise=null;if(jQuery.isPopulated(param))return param;else return otherwise;},cloneObject:function(obj)
{var newObj=null;if(obj==null)return newObj;switch(obj.constructor)
{case Array:newObj=[];for(var i=0;i<obj.length;i++)
{newObj[i]=jQuery.cloneObject(obj[i]);}
break;case String:newObj=obj.toString();break;default:newObj={};for(i in obj)
{if(typeof obj[i]=='object')
{newObj[i]=jQuery.cloneObject(obj[i]);}
else
newObj[i]=obj[i];}
break;}
return newObj;},convertToJson:function(obj)
{var str="{";for(var i in obj)
{var render="";if(typeof obj[i]=='object')
{render=jQuery.convertToJson(obj[i]);}
else
render="'"+obj[i]+"'";str+="'"+i+"' : "+render+", ";}
if(str!="{")str=str.substring(0,str.length-2);str+="}";return str;},htmlifyXml:function(xml,rootId)
{var re=new RegExp('<[^<]+?\\?>','g');xml=xml.replace(re,'');re=new RegExp('<([^/])([^< ]*)( ?)([^<]*?)>',"g");xml=xml.replace(re,'<div class="$1$2"$3$4>');re=new RegExp('</([^<]+?)>',"g");xml=xml.replace(re,'</div>');return jQuery('<div id="'+rootId+'">'+xml+'</div>').appendTo(document);},getQueryStringVariable:function(variable)
{if(!jQuery.isPopulated(variable))variable=="";variable=variable.toLowerCase();var query=window.location.search.substring(1).trim();var vars=query.split("&");for(var i=0;i<vars.length;i++)
{var pair=vars[i].split("=");var q=pair[0];if(!jQuery.isPopulated(q))q="";q=q.toLowerCase();if(q==variable)
{return pair[1];}}
return"";},replaceQueryStringVariable:function(variable,value)
{var uri=window.location.protocol+"//"+window.location.host+window.location.pathname;var qs="";var found=false;if(!jQuery.isPopulated(variable))variable=="";variable=variable.toLowerCase();var query=window.location.search.substring(1);if(query.length>0)
{var vars=query.split("&");for(var i=0;i<vars.length;i++)
{var pair=vars[i].split("=");var q=pair[0];if(!jQuery.isPopulated(q))q="";q=q.toLowerCase();if(q==variable)
{qs+="&"+pair[0]+"="+value;}
else
{qs+="&"+vars[i];}}
if(qs.length>0)qs=qs.substr(1);}
else
{qs=variable+"="+value;}
return uri+"?"+qs;},getTicks:function(options)
{if(!jQuery.isPopulated(options))return 0;var sTicks=1000;var mTicks=sTicks*60;var hTicks=mTicks*60;var dTicks=hTicks*24;var time=jQuery.isPopulated(options.seconds)?options.seconds*sTicks:0;time+=(jQuery.isPopulated(options.minutes)?options.minutes*mTicks:0);time+=(jQuery.isPopulated(options.hours)?options.hours*hTicks:0);time+=(jQuery.isPopulated(options.days)?options.days*dTicks:0);return time;},getGuid:function(length)
{length=jQuery.isPopulated(length)?length:7;var now=(new Date()).getTime();var charPool="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";var getBaseN=function(val)
{if(val==0)return"";var rightMost=val%charPool.length;var rightMostChar=charPool.charAt(rightMost);var remaining=Math.floor(val/charPool.length);return getBaseN(remaining)+rightMostChar;}
var guid=getBaseN(Math.floor(Math.random()*now));if(length>7)
{var randomLength=length-guid.length;for(var i=0;i<randomLength;i++)
{guid+=charPool.charAt(Math.floor(Math.random()*charPool.length));}}
else if(length<7)
{guid=guid.substring(0,7);}
return guid;},addCSS:function(cssCode)
{var styleElement=document.createElement("style");styleElement.type="text/css";if(styleElement.styleSheet)
{styleElement.styleSheet.cssText=cssCode;}else
{styleElement.appendChild(document.createTextNode(cssCode));}
document.getElementsByTagName("head")[0].appendChild(styleElement);},getMaxZIndex:function(elCompare)
{var max=0;if(jQuery.isPopulated(elCompare)&&jQuery(elCompare).length>0)
{max=elCompare.css("z-index").toString().stripCssUnit(true);}
if(max==0)
{var elements=(jQuery.browser.msie)?jQuery("body *"):jQuery("*:visible");elements.each(function(i,el)
{var $el=$j(el);var zIndex=$el.css('z-index').toString().stripCssUnit(true);if(el.style.position!='static'&&zIndex>max)
{max=zIndex;}});}
return max;},getPosition:function(options)
{if(!jQuery.isPopulated(options.anchor)||!jQuery.isPopulated(options.element))return null;options.offsetX=(jQuery.isPopulated(options.offsetX))?options.offsetX:0;options.offsetY=(jQuery.isPopulated(options.offsetY))?options.offsetY:0;options.positionX=(jQuery.isPopulated(options.positionX))?options.positionX:"";options.positionY=(jQuery.isPopulated(options.positionY))?options.positionY:"";var offsetAncestor=options.element.offsetParent();var ancestorLimited=offsetAncestor.css("overflow")=="hidden";var anchorPoint=(ancestorLimited)?options.anchor.position():options.anchor.offset();function getPositionForType(positionName,positionType)
{if(!jQuery.isPopulated(positionType)||(positionType.toLowerCase()!="x"&&positionType.toLowerCase()!="y"))positionType="x";positionType=positionType.toLowerCase();if(!jQuery.isPopulated(positionName))positionName="";positionName=positionName.toLowerCase();var dimension=positionType=="x"?"width":"height";var anchor=positionType=="x"?"left":"top";var offset="offset"+positionType.toUpperCase();var capped=dimension.substr(0,1).toUpperCase()+dimension.substr(1);var outerDimension="outer"+capped;var innerDimension="inner"+capped;var scrollAnchor="scroll"+anchor.substr(0,1).toUpperCase()+anchor.substr(1);var adjustedPosition=null;var getPositionInfo=function(positive)
{var adjusted=false;var pos=positive?getPositive():getNegative();if((positive?tooPositive(pos):tooNegative(pos)))
{var newPos=positive?getNegative():getPositive();if(!(positive?tooNegative(newPos):tooPositive(newPos)))
{pos=newPos;adjusted=true;}}
return{position:pos,adjusted:adjusted};}
var getPositive=function(){return anchorPoint[anchor]+options.anchor[outerDimension]()+options[offset];};var getNegative=function(){return anchorPoint[anchor]-options.element[outerDimension]()-options[offset];};var tooPositive=function(pos){return(pos+options.element[dimension]())>(jQuery(window)[dimension]()+jQuery(window)[scrollAnchor]());};var tooNegative=function(pos){return(ancestorLimited?(pos)<0:(pos)<jQuery(window)[scrollAnchor]());};var position=0;var positionInfo;switch(positionName)
{case"top":case"left":positionInfo=getPositionInfo(false);position=positionInfo.position;adjustedPosition=positionInfo.adjusted?(positionType=="x"?"right":"bottom"):null;break;case"bottom":case"right":positionInfo=getPositionInfo(true);position=positionInfo.position;adjustedPosition=positionInfo.adjusted?(positionType=="x"?"left":"top"):null;break;case"flush":position=anchorPoint[anchor]+options[offset];if(tooPositive(position))
{positionInfo=getPositionInfo(false);position=positionInfo.position;adjustedPosition=positionInfo.adjusted?(positionType=="x"?"right":"bottom"):null;}
break;case"center":default:position=anchorPoint[anchor]+(options.anchor[outerDimension]()/2)+options[offset];position-=(options.element[outerDimension]()/2);if(tooPositive(position))
{positionInfo=getPositionInfo(false);position=positionInfo.position;adjustedPosition=positionInfo.adjusted?(positionType=="x"?"right":"bottom"):null;}
break;}
return{position:position,adjustedPosition:adjustedPosition};}
var retVal={x:getPositionForType(options.positionX,"x"),y:getPositionForType(options.positionY,"y")};return retVal;},isAppleDevice:function()
{return(navigator.userAgent.match(/iPad|iPhone|iPod/i)!=null);},formatDollars:function(decimal)
{return'$'+parseFloat(decimal).toFixed(2);},replaceBlank:function(obj,defaultedValue)
{return jQuery.isPopulated(obj)?obj:jQuery.isPopulated(defaultedValue)?defaultedValue:"";}});jQuery.fn.extend({ghost:function(options)
{var clone=jQuery(this).clone();return jQuery(this).overlay(clone,options);},getCover:function(options)
{var parentIsBody=!(jQuery.isPopulated(options)&&jQuery.isPopulated(options.parentContainer));var parentContainer=!parentIsBody?options.parentContainer:document.body;var html=jQuery.isPopulated(options)&&jQuery.isPopulated(options.html)?options.html:'<div></div>';var div=jQuery(html).css({position:"absolute",display:"none",top:parentIsBody?jQuery(this).offset().top:jQuery(this).position().top,left:parentIsBody?jQuery(this).offset().left:jQuery(this).position().left,"z-index":jQuery(this).css("z-index").toString().adjustUnit(1,true,'')}).width(jQuery(this).width()).height(jQuery(this).height()).appendTo(parentContainer);return div;},overlay:function(ghost,options)
{ghost.css({position:"absolute",display:"none","z-index":options&&options.zIndex!=null?options.zIndex:jQuery.getMaxZIndex(this)+1,top:jQuery(this).offset().top+(options&&options.offsetY!=null?options.offsetY:0),left:jQuery(this).offset().left+(options&&options.offsetX!=null?options.offsetX:0)}).appendTo(document.body);if(options==null||(options!=null&&(options.parentDimensions||options.parentDimensions==undefined)))
{ghost.width(jQuery(this).width()).height(jQuery(this).height());}
if(options!=null)
{if($j.isPopulated(options.offsetWidth))ghost.width(ghost.width()+options.offsetWidth);if($j.isPopulated(options.offsetHeight))ghost.height(ghost.height()+options.offsetHeight);if($j.isPopulated(options.addClass))ghost.addClass(options.addClass);if($j.isPopulated(options.removeClass))ghost.removeClass(options.removeClass);if($j.isPopulated(options.preShow))options.preShow(ghost);}
return ghost;},flashFade:function(options)
{if(options==null)return;var ghost=(options.ghost==null)?jQuery(this).ghost():options.ghost;if(ghost.not(":visible"))
{var interval=(options.interval==null)?3000:options.interval;var postHideAction=function(){jQuery(this).remove();};switch(true)
{case(options.postHideAction=="none"):postHideAction=null;break;case(jQuery.isFunction(options.postHideAction)):postHideAction=options.postHideAction;break;}
jQuery(this).overlay(ghost,options).show().fadeOut(interval,postHideAction);}
return ghost;},flashTip:function(options)
{if(options==null)return;var ghost=(options.ghost==null)?jQuery(this).ghost():options.ghost;if(ghost.is(":not(:visible)")&&jQuery(this).is(":visible"))
{var postHideAction=function(){jQuery(this).remove();};switch(true)
{case(options.postHideAction=="none"):postHideAction=null;break;case(jQuery.isFunction(options.postHideAction)):postHideAction=options.postHideAction;break;}
if(options.parentDimensions==undefined)options.parentDimensions=false;var interval=(options.interval==null)?3000:options.interval;var closeAction=function()
{if(ghost.is(":visible"))ghost.fadeOut(1000,postHideAction);else if(jQuery.isFunction(postHideAction))postHideAction();};if(options.closeOnClick)ghost.click(closeAction);var postShow=function()
{window.clearTimeout(ghost.data("timeout"));ghost.data("timeout",window.setTimeout(closeAction,interval));};ghost=jQuery(this).overlay(ghost,options);ghost.close=closeAction;if($j.isPopulated(options.closeEvent))
{switch(options.closeEvent)
{case"mouseout":jQuery(this).mouseout(postShow);break;case"blur":jQuery(this).blur(postShow);break;}
postShow=null;}
if(options.instantShow)
ghost.show(0,postShow);else if($j.isPopulated(options.delay))
ghost.data("delayTimeout",window.setTimeout(function(){ghost.fadeIn("normal",postShow);},options.delay));else
ghost.fadeIn("normal",postShow);}
return ghost;},displayToggle:function(show,type,duration,callback)
{var action='show';var oldIE=$j.browser.msie&&(parseInt($j.browser.version.slice(0,1))<=7);duration=(oldIE||!$j.isPopulated(duration))?0:duration;if(show)
{action=(oldIE||!$j.isPopulated(type))?action:type=='fade'?'fadeIn':type=='slide'?'slideDown':action;}
else
{action=(oldIE||!$j.isPopulated(type))?'hide':type=='fade'?'fadeOut':type=='slide'?'slideUp':'hide';}
$j(this).each(function(i,el){$j(el)[action](duration,callback);});}});if(!jQuery.fn.prop)
{jQuery.fn.prop=function(attrName,attrValue)
{if(attrValue==undefined)
{return jQuery(this).attr(attrName);}
else
{if(attrValue===false)
return jQuery(this).removeAttr(attrName);else
return jQuery(this).attr(attrName,attrValue.toString());}}}
jQuery.fn.limitMaxlength=function(options){var settings=jQuery.extend({attribute:"maxlength",onLimit:function(){},onEdit:function(){}},options);var onEdit=function(){var textarea=jQuery(this);var maxlength=parseInt(textarea.attr(settings.attribute));if(textarea.val().length>maxlength){textarea.val(textarea.val().substr(0,maxlength));jQuery.proxy(settings.onLimit,this)();}
jQuery.proxy(settings.onEdit,this)(maxlength-textarea.val().length);}
this.each(onEdit);return this.bind('keyup.limitMaxlength keydown.limitMaxlength focus.limitMaxlength',onEdit).live('input.limitMaxlength paste.limitMaxlength',onEdit);}
String.prototype.isDomain=function()
{var re=new RegExp('^[a-zA-Z0-9-_\.]+?((\.[a-zA-Z]{2,4})?\.[a-zA-Z]{2,4})$','gi');var str=this.toString();return re.test(str);}
String.prototype.cleanTrunc=function(targetLength,isDomain)
{var temp=this.toString();var result=temp;if(temp.length>targetLength+3)
{if(isDomain==true)
{var tld="";var front=temp;var back=temp;if(temp.indexOf(".")>-1)tld=temp.substring(temp.lastIndexOf(".")+1);if(tld.length>0)
{temp=temp.substring(0,temp.length-(tld.length+1));if(temp.indexOf(".")>-1)
{var ttld=temp.substring(temp.lastIndexOf(".")+1);if(ttld.length<=4)
{tld=ttld+"."+tld;temp=temp.substring(0,temp.length-(ttld.length+1));}}}
front=front.substring(0,targetLength-(3+tld.length));result=front+"..."+tld;}
else
{result=temp.substring(0,targetLength-3)+"...";}}
return result;}
String.prototype.adjustUnit=function(adjustment,add,defaultUnit)
{var val=this.toString();if(val==null||val==undefined||val=='')return val;re=new RegExp('(px|pt|em|\%|auto)',"g");var num=val.replace(re,'');var unit=val.replace(num,'');if(num=="")num=0;if(unit=="auto"||unit=="")unit=(defaultUnit!=undefined&&defaultUnit!=null)?defaultUnit:"px";var adjusted;if(add)adjusted=(parseInt(num)+adjustment)+unit;else adjusted=(parseInt(num)-adjustment)+unit;if(adjusted=="0"+unit)adjusted="0";return adjusted;}
String.prototype.stripCssUnit=function(useZeroIfNonNumeric)
{var val=this.toString();if(val==null||val==undefined||val==''||val=='auto')
return useZeroIfNonNumeric?0:val;re=new RegExp('(px|pt|em|\%|\b)','g');var num=val.replace(re,'');if(num=='')num=0;var retVal=Number(num);return isNaN(retVal)?0:retVal;}
String.prototype.trimSplit=function(delim)
{var split=this.toString().split(delim);for(var i=0;i<split.length;i++)
{split[i]=split[i].trim();}
return split;}
String.prototype.trim=function()
{var str=this.toString().replace(/^\s\s*/,''),ws=/\s/,i=str.length;while(ws.test(str.charAt(--i)));return str.slice(0,i+1);}
String.prototype.unescapeHtmlEntities=function()
{var converter=jQuery('<span></span>').appendTo(document);var nexttry="";var result=this.toString();var done=false;do
{nexttry=result;converter.html(result);result=converter.text();if(result.indexOf("<")>-1||result.indexOf(">")>-1)nexttry=result;}while(result!=nexttry);converter.remove();return result;}
String.prototype.escapeHtml=function()
{var str=this.toString();var parts=str.split("\n");for(var i=0;i<parts.length;i++)
{parts[i]=jQuery('<div/>').text(parts[i]).html().replace(/"/g,"&quot;");}
return parts.join("\n");}
String.prototype.padLeft=function(padChar,length)
{var str=this.toString();for(var i=0;i<(length-str.length);i++)
{str=padChar+str;}
return str;}
String.prototype.padRight=function(padChar,length)
{var str=this.toString();for(var i=0;i<(length-str.length);i++)
{str+=padChar;}
return str;}
String.prototype.commafyNumber=function()
{var nStr=this.toString();nStr+='';x=nStr.split('.');x1=x[0];x2=x.length>1?'.'+x[1]:'';var rgx=/(\d+)(\d{3})/;while(rgx.test(x1))
{x1=x1.replace(rgx,'$1'+','+'$2');}
return x1+x2;}
Date.prototype.getElapsed=function()
{if(this.elapsed==null||this.elapsed==undefined)
{var seconds=function(elapsed)
{return Math.floor(elapsed/1000);};var minutes=function(elapsed)
{var val=seconds(elapsed);return{minutes:Math.floor(val/60),seconds:val%60};};var hours=function(elapsed)
{var val=minutes(elapsed);return{hours:Math.floor(val.minutes/60),minutes:val.minutes%60,seconds:val.seconds};};var days=function(elapsed)
{var val=hours(elapsed);return{days:Math.floor(val.hours/24),hours:val.hours%24,minutes:val.minutes,seconds:val.seconds};};var weeks=function(elapsed)
{var val=days(elapsed);return{weeks:Math.floor(val.days/7),days:val.days%7,hours:val.hours,minutes:val.minutes,seconds:val.seconds};};var years=function(elapsed)
{var val=days(elapsed);return{years:Math.floor(val.days/365),days:val.days%365,hours:val.hours,minutes:val.minutes,seconds:val.seconds};};this.elapsed=years((new Date())-this);}
return this.elapsed;}
Date.prototype.getElapsedFriendly=function(showTimeIfMoreThanDay)
{var monthNames=["January","February","March","April","May","June","July","August","September","October","November","December"];var dayNames=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];var start=this;var now=new Date();var elapsed=start.getElapsed();var text="";var isMoreThanDay=false;if(elapsed.years<1&&elapsed.days<1&&elapsed.hours<1&&elapsed.minutes<1)
{if(elapsed.seconds<0)elapsed.seconds=0;text=elapsed.seconds+" second"+(elapsed.seconds==1?"":"s")+" ago";}
else if(elapsed.years<1&&elapsed.days<1&&elapsed.hours<1)
{text=elapsed.minutes+" minute"+(elapsed.minutes==1?"":"s")+" ago";}
else if(elapsed.years<1&&elapsed.days<1)
{text=elapsed.hours+" hour"+(elapsed.hours==1?"":"s");text+=" ago";}
else if(elapsed.years<1&&elapsed.days==1)
{text="yesterday";isMoreThanDay=true;}
else if(elapsed.years<1&&elapsed.days<7&&elapsed.days>1)
{text=dayNames[start.getDay()];isMoreThanDay=true;}
else if(elapsed.years<1)
{text=monthNames[start.getMonth()]+" "+start.getDate();isMoreThanDay=true;}
else
{text=monthNames[start.getMonth()]+" "+start.getDate()+", "+start.getFullYear();isMoreThanDay=true;}
if(isMoreThanDay&&showTimeIfMoreThanDay)
{var hours=start.getHours();var ampm=(hours>=12?"pm":"am");hours=(hours>12?hours-12:hours);text+=", "+hours.toString().padLeft("0",2)+":"+start.getMinutes().toString().padLeft("0",2)+ampm;}
return text;}
Date.prototype.convertToLocalTime=function(timeZoneInMinutes)
{timeZoneInMinutes=(timeZoneInMinutes==null||timeZoneInMinutes==undefined||timeZoneInMinutes=="")?-(new Date()).getTimezoneOffset():timeZoneInMinutes;var milliseconds=this.getTime();var tzDiff=(((timeZoneInMinutes*60)*1000));var date=new Date();date.setTime(milliseconds+tzDiff);return date;}
Date.prototype.isToday=function()
{var now=new Date();var start=this;var elapsed=this.getElapsed();return elapsed.years<1&&(elapsed.days<1&&(now.getDate()==start.getDate()));}
Date.prototype.isYesterday=function()
{var now=new Date();var start=this;var elapsed=this.getElapsed();return elapsed.years<1&&(elapsed.days==1||(elapsed.days<1&&(now.getDate()!=start.getDate())));}
Date.prototype.isThisWeek=function()
{var elapsed=this.getElapsed();return elapsed.years<1&&elapsed.days<7;}
Date.prototype.getFriendlyIfRecent=function(dayMax,hideTime)
{if(dayMax==null||dayMax==""||dayMax==undefined)dayMax=0;var start=this;var now=new Date();var elapsed=this.getElapsed();var text="";if(elapsed.years<1)
{if(elapsed.days<1&&elapsed.hours<1&&elapsed.minutes<1)
{if(elapsed.seconds<0)elapsed.seconds=0;text=elapsed.seconds+" second"+(elapsed.seconds==1?"":"s")+" ago";}
else if(elapsed.days<1&&elapsed.hours<1)
{text=elapsed.minutes+" minute"+(elapsed.minutes==1?"":"s")+" ago";}
else if(elapsed.days<1&&(now.getDate()==start.getDate()))
{text=elapsed.hours+" hour"+(elapsed.hours==1?"":"s");text+=" ago";}
else if(elapsed.days<=dayMax)
{var dayNames=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];text=start.isYesterday()?"yesterday":(elapsed.days>1&&elapsed.days<7)?dayNames[start.getDay()]:elapsed.days+" days ago";}
if(text!=""&&!hideTime)text+=" @ "+start.getDisplayTime();}
return text;}
Date.prototype.getDisplayTime=function()
{var start=this;var hours=start.getHours();var ampm=(hours>=12?"pm":"am");hours=(hours>12?hours-12:hours);return hours.toString()+":"+start.getMinutes().toString().padLeft("0",2)+ampm;}
Date.prototype.getDisplayDateTime=function(showDayName,showTime)
{var monthNames=["January","February","March","April","May","June","July","August","September","October","November","December"];var dayNames=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];var start=this;var elapsed=this.getElapsed();var text="";if(showDayName)text=dayNames[start.getDay()]+", ";if(elapsed.years<1)
{text+=monthNames[start.getMonth()]+" "+start.getDate();isMoreThanDay=true;}
else
{text+=monthNames[start.getMonth()]+" "+start.getDate()+", "+start.getFullYear();isMoreThanDay=true;}
if(showTime)text+=" @ "+start.getDisplayTime();return text;}
Date.prototype.getElapsedForFeeds=function(friendlyDayMax,hideTime)
{if(friendlyDayMax==null||friendlyDayMax==""||friendlyDayMax==undefined)friendlyDayMax=0;var start=this;var todayOrYesterday=start.isToday()||start.isYesterday();var recent=this.getFriendlyIfRecent(friendlyDayMax,hideTime||(!hideTime&&!todayOrYesterday));var dateText=this.getDisplayDateTime(!todayOrYesterday&&start.isThisWeek(),!hideTime);return recent+(todayOrYesterday?'':((recent!=""?" - ":" ")+dateText));}})(jQuery);(function(jQuery)
{function f(n)
{return n<10?'0'+n:n;}
if(typeof Date.prototype.toJSON!=='function')
{Date.prototype.toJSON=function(key)
{return isFinite(this.valueOf())?this.getUTCFullYear()+'-'+
f(this.getUTCMonth()+1)+'-'+
f(this.getUTCDate())+'T'+
f(this.getUTCHours())+':'+
f(this.getUTCMinutes())+':'+
f(this.getUTCSeconds())+'Z':null;};String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(key)
{return this.valueOf();};}
var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string)
{escapable.lastIndex=0;return escapable.test(string)?'"'+string.replace(escapable,function(a)
{var c=meta[a];return typeof c==='string'?c:'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4);})+'"':'"'+string+'"';}
function str(key,holder)
{var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function')
{value=value.toJSON(key);}
if(typeof rep==='function')
{value=rep.call(holder,key,value);}
switch(typeof value)
{case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value)
{return'null';}
gap+=indent;partial=[];if(Object.prototype.toString.apply(value)==='[object Array]')
{length=value.length;for(i=0;i<length;i+=1)
{partial[i]=str(i,value)||'null';}
v=partial.length===0?'[]':gap?'[\n'+gap+
partial.join(',\n'+gap)+'\n'+
mind+']':'['+partial.join(',')+']';gap=mind;return v;}
if(rep&&typeof rep==='object')
{length=rep.length;for(i=0;i<length;i+=1)
{k=rep[i];if(typeof k==='string')
{v=str(k,value);if(v)
{partial.push(quote(k)+(gap?': ':':')+v);}}}}else
{for(k in value)
{if(Object.hasOwnProperty.call(value,k))
{v=str(k,value);if(v)
{partial.push(quote(k)+(gap?': ':':')+v);}}}}
v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+
mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}
jQuery.extend({jsonStringify:function(value,replacer,space)
{var i;gap='';indent='';if(typeof space==='number')
{for(i=0;i<space;i+=1)
{indent+=' ';}}else if(typeof space==='string')
{indent=space;}
rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number'))
{throw new Error('JSON.stringify');}
return str('',{'':value});},jsonParse:function(text,reviver)
{var j;function walk(holder,key)
{var k,v,value=holder[key];if(value&&typeof value==='object')
{for(k in value)
{if(Object.hasOwnProperty.call(value,k))
{v=walk(value,k);if(v!==undefined)
{value[k]=v;}else
{delete value[k];}}}}
return reviver.call(holder,key,value);}
cx.lastIndex=0;if(cx.test(text))
{text=text.replace(cx,function(a)
{return'\\u'+
('0000'+a.charCodeAt(0).toString(16)).slice(-4);});}
if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,'')))
{j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}
throw new SyntaxError('JSON.parse');}});})(jQuery);


(function($)
{$.lazy=function(options)
{var src=options.src,name=options.name,cache=options.cache,self,arg,object={};if($()[name])return;$.lazy.archive[src]={'status':'unloaded','que':[]};function loadCSS(src,callback,self,name,arg)
{$.lazy.archive[src].status="loading";var node=document.createElement('link');node.type='text/css';node.rel='stylesheet';node.href=src;node.media='screen';document.getElementsByTagName("head")[0].appendChild(node);$.lazy.archive[src].status='loaded';if(callback)
callback(self,name,arg);}
function loadJS(src,callback,self,name,arg)
{$.lazy.archive[src].status="loading";$.ajax({type:"GET",url:src,cache:cache,dataType:"script",success:function()
{$.lazy.archive[src].status='loaded';if(callback)
{callback(self,name,arg);}}});}
function loadPlugin(self,name,arg)
{function callback()
{if(typeof self=='object')
{self.each(function()
{if(arg.length>0)
{$(this)[name].apply(self,arg);}else
{$(this)[name]();}});}else
{$[name].apply(null,arg);}
$.each($.lazy.archive[src].que,function(i)
{var queItem=$.lazy.archive[src].que[i];object[queItem.name].apply(queItem.self,queItem.arguments);});$.lazy.archive[src].que=[];}
loadJS(src,callback,self,name,arg);}
object[name]=function()
{var self=this;arg=arguments;if($.lazy.archive[src].status==='loaded')
{$.each(this,function()
{$(this)[name].apply(self,arg);});}else if($.lazy.archive[src].status==='loading')
{$.lazy.archive[src].que.push({'name':name,'self':self,'arguments':arg});}else
{$.lazy.archive[src].status='loading';if(options.dependencies)
{var css=options.dependencies.css||[],js=options.dependencies.js||[];var total=css.length+js.length;function loadDependencies(array,callback,callbackCallback)
{var length=array.length,src;array=array.reverse();while(length--&&total--)
{src=array[length];if(typeof $.lazy.archive[src]=='undefined')
{$.lazy.archive[src]={'status':'unloaded','que':[]};}
if($.lazy.archive[src].status==='unloaded')
{if(!total)
{callback(src,function()
{loadPlugin(self,name,arg);});}else
{callback(src);}}else if(!total)
{loadPlugin(self,name,arg);}}}
loadDependencies(css,loadCSS);loadDependencies(js,loadJS);}else
{loadPlugin(self,name,arg);}}
return this;};jQuery.fn.extend(object);jQuery.extend(object);};$.lazy.archive={};})(jQuery);

;(function($j)
{var CygnusWidgetContainer={options:{type:null,log:true},_create:function()
{this.objectType="WidgetContainer";this.options.title=this.options.meta.Title;this.options.editTitle="Settings";this.options.anchor=(!$j.isPopulated(this.options.anchor))?$j("#"+this.options.id+"-anchor"):(this.options.anchor.constructor==String)?$j("#"+this.options.anchor):this.options.anchor;this.options.renderable=false;this.options.currentView=this.options.meta.View;this.options.closed=(this.options.meta.Shown!=1);this.options.removed=(this.options.meta.isDeleted==1);this.options.accessMethod=this.options.meta.AccessMethod;this.options.contentServiceUrl=this.options.meta.ContentServiceUrl;this.options.errorLoading=null;this.options.instanceLoaded=false;this.options.hidden=false;this.options.switchingContent=false;this.options.singleInstance=false;this.options.previousInstance=null;this.options.instances={};this.options.views={list:[]};for(var i=0;i<this.options.meta.Views.length;i++)
{this.options.views[this.options.meta.Views[i].Type]={flex:this.options.meta.Views[i].Flex,toggle:"none",popZIndex:true};this.options.views.list.push(this.options.meta.Views[i].Type);}
this.options.isHeaderEnabled=true;this.options.isEditConfigEnabled=false;this._setup();},_log:function(msg)
{if(!$j.isPopulated(this.options)||!$j.isPopulated(this.options.log))return;if(window.console&&console.log)
{console.log(msg);}},destroy:function()
{$j.Widget.prototype.destroy.call(this);},id:function(){return this.options.id;},type:function(){return this.options.type;},title:function(value){if($j.isPopulated(value))
{this.options.title=value;this.element.find(".widget-title").text(value);return this.element;}
else
{return this.options.title;}},anchor:function(value){if($j.isPopulated(value)){this.options.anchor=value;return this.element;}else{return this.options.anchor;}},contentServiceUrl:function(){return this.options.contentServiceUrl;},accessMethod:function(){return this.options.accessMethod;},views:function(){return this.options.views;},sizeable:function(){return this.options.sizeable;},renderable:function(){return this.options.isRenderable;},currentView:function(value){if($j.isPopulated(value)){this.options.currentView=value;return this.element;}else{return this.options.currentView;}},previousInstance:function(value){if($j.isPopulated(value)){this.options.previousInstance=value;return this.element;}else{return this.options.previousInstance;}},closed:function(value){if($j.isPopulated(value)){this.options.closed=value;return this.element;}else{return this.options.closed;}},removed:function(value){if($j.isPopulated(value)){this.options.removed=value;return this.element;}else{return this.options.removed;}},hidden:function(value){if($j.isPopulated(value)){this.options.hidden=value;return this.element;}else{return this.options.hidden;}},switchingContent:function(value){if($j.isPopulated(value)){this.options.switchingContent=value;return this.element;}else{return this.options.switchingContent;}},instanceElement:function(view){if($j.isPopulated(view)){this._setInstance(view);}return this._currentInstance();},instance:function(view){if($j.isPopulated(view)){this._setInstance(view);}
var instance=null;if($j.isPopulated(this._currentInstance()))instance=this._currentInstance().data("cygnusWidgetInstance");return instance;},errorLoading:function(value){if($j.isPopulated(value)){this.options.errorLoading=value;return this.element;}else{return this.options.errorLoading;}},getConfigData:function(property){return this.options.meta[property];},_setup:function()
{if(!this.containerElementInitialized&&this.isRenderable()&&!this.instanceLoaded)
{this._initRenderable();this._configure();this.containerElementInitialized=true;}},isRenderable:function()
{if(!$j.isPopulated(this.options.anchor)||this.options.anchor.length==0)this.options.anchor=$j("#"+this.options.id+"-anchor");this.options.renderable=(this.options.anchor.length>0);return this.options.renderable;},_initRenderable:function()
{if(this.options.renderable&&$j.isPopulated(this.element))
{this.element.addClass("widget-container").addClass("uninitialized").addClass("type-"+this.options.type).attr("id",this.options.id).appendTo(this.options.anchor);if($c.Stage.applicationSettings.showContainerControls)
{$c.Stage.log("adding container controls");var tbHtml='<div class="title-bar"><img class="widget-title-icon" style="display:none;" /><span class="widget-title">'+this.options.title.escapeHtml()+'</span>';if($c.Stage.applicationSettings.showToggleControl||$c.Stage.applicationSettings.showConfigControl||$c.Stage.applicationSettings.showCloseControl)
{tbHtml+='<div class="navigation">';if($c.Stage.applicationSettings.showToggleControl)tbHtml+='<span class="'+(this.options.closed?'maximize':'minimize')+'" onclick=""></span>';if($c.Stage.applicationSettings.showCloseControl)tbHtml+='<span class="close" onclick=""></span>';tbHtml+='</div>';}
tbHtml+='</div>';this.element.append(tbHtml+'<div class="loading-text" style="display:none; position:relative; text-align: center;"></div>')}
$c.Stage.log("added container to element.");}},editConfigEnabled:function(enabled)
{if($j.isPopulated(enabled))
{this.options.isEditConfigEnabled=enabled&&$c.Stage.applicationSettings.showConfigControl;if(enabled&&$c.Stage.applicationSettings.showConfigControl)
{var html='<span class="editConfig" onclick=""></span>';var target=$j(".navigation .close, .navigation-hover .close",this.element);if(target.length>0)$j(html).insertBefore(target);else $j(".navigation, .navigation-hover",this.element).append(html);$c.Stage.log("enabling the edit config button");}
else
{this.element.find(".editConfig").remove();$c.Stage.log("disabling the edit config button");}}
return this.options.isEditConfigEnabled;},_disableClicks:function()
{this.element.bind("click.wcprevention",function(e)
{return false;}).css("cursor","wait");},_enableClicks:function()
{this.element.unbind("click.wcprevention").css("cursor",'');},getInstance:function(view)
{var instance=null;if(!$j.isPopulated(view))
return instance;else
if(this.options.instances[view])instance=this.options.instances[view];return instance;},_setInstance:function(view,instance)
{if(!$j.isPopulated(this.options.instances))this.options.instances={};this.options.instances[view]=instance;this.options.currentView=view;},widgetContentName:function()
{var wcn=null;if($j.isPopulated(this.instance()))wcn=this.instance().widgetContentName();return wcn;},contentIsLoaded:function()
{return $j.isPopulated(this.widgetContentName());},instanceIsLoaded:function()
{return this.options.instanceLoaded;},isSizeable:function()
{var sizeCount=0;for(var i=0;i<this.options.views.length;i++)
{if(this.options.views[i].toggle=="size")sizeCount++;}
return(sizeCount>=2);},_currentInstance:function()
{return this.getInstance(this.options.currentView);},showLoadingDialog:function()
{this.element.addClass("loading-container");var loadingText=$j(".loading-text",this.element)
loadingText.html('Loading...');loadingText.show();var options={element:loadingText,container:this.element};$c.Stage.center(options);this._disableClicks();},hideLoadingDialog:function()
{$j(".loading-text",this.element).hide();this.element.removeClass("loading-container").removeClass("uninitialized");this._enableClicks();},reloadInstance:function(hideWidget)
{var instance=this._currentInstance();if(hideWidget)this.close();if($j.isPopulated(instance))
{var instanceBase=this.instance();instanceBase.isReloading(true);this.showLoadingDialog();var clientWidget=instanceBase.element.data(this.widgetContentName());if($j.isPopulated(clientWidget))clientWidget.destroy();$c.CommManager.getWidget(instanceBase);}},popZIndex:function()
{},resize:function()
{this._currentInstance().trigger("resize");var stageWidth=$c.Stage.stageWidth(),stageHeight=$c.Stage.stageHeight();this._currentInstance().css({width:0,height:0}).css({width:stageWidth,height:stageHeight});this.element.css({width:0,height:0}).css({width:stageWidth,height:stageHeight});$j(".scrollable",this._currentInstance()).scrollable().resize(stageWidth);var instance=this._currentInstance().data("cygnusWidgetInstance");instance.width(stageWidth);instance.height(stageHeight);},_configure:function(options)
{var el=this.element;var $this=this;var version=parseInt($j.browser.version.split(".")[0]);if($j.browser.msie&&(version==7))
{$j("a[target='_blank']").unbind("click.ie").bind("click.ie",function(){setTimeout(function(){$j(document.body).focus();},10);});}
$j(window).bind("closeAll",function(){$this.minimize();});$j(window).bind("openAll",function(){$this.maximize();});el.bind("obscure",function(){$this.obscure();});el.bind("reveal",function(){$this.reveal();});el.bind("resized",function(){$this.resized();});el.bind('contentUpdated',function(){if($c.Stage.applicationSettings.contentUpdated){$c.Stage.applicationSettings.contentUpdated();}
else if($c.Stage.applicationSettings.widgetEvents.contentUpdated){$c.Stage.applicationSettings.widgetEvents.contentUpdated($this.id(),$this.type());}});if($c.Stage.applicationSettings.applicationEvents.colorsChanged)
{el.bind($c.Stage.applicationSettings.applicationEvents.colorsChanged,function(e){var newColors=e.widgetColors;if(newColors.background)$c.Stage.applicationSettings.baseWidgetColors.background=newColors.background;if(newColors.textContent)$c.Stage.applicationSettings.baseWidgetColors.textContent=newColors.textContent;if(newColors.textTitle)$c.Stage.applicationSettings.baseWidgetColors.textTitle=newColors.textTitle;if(newColors.borderTitle)$c.Stage.applicationSettings.baseWidgetColors.borderTitle=newColors.borderTitle;if(newColors.textLink)$c.Stage.applicationSettings.baseWidgetColors.textLink=newColors.textLink;$this.changeColors($c.Stage.applicationSettings.baseWidgetColors);});}
el.bind("closingConfig",function(e,needsReload)
{$this.instance().mode('public');if(needsReload)$this.reloadInstance();else
{$this.editConfigEnabled(true);}
var elTitle=$this.element.find(".widget-title");if(elTitle.text!=$this.title())elTitle.text($this.title());if($c.Stage.applicationSettings.showCloseControl)$this.element.find(".close").show(0);if($j.isFunction($c.Stage.applicationSettings.widgetEvents.closedConfig))
$c.Stage.applicationSettings.widgetEvents.closedConfig($this.id(),$this.type());});el.bind("savedConfig",function(e,data)
{$this.savedConfig(data.success);});el.bind("cancelledConfig",function(e)
{$this.cancelledConfig();});el.bind("editedAppWidgetProperties",function(e,data)
{if($j.isPopulated(data)&&$j.isPopulated(data.appData))
{for(prop in data.appData)
{if(data.appData[prop].type=="base")
{$this[prop.toLowerCase()](data.appData[prop].value);}
$this.options.meta[prop]=data.appData[prop].value;}
if($j.isFunction($c.Stage.applicationSettings.widgetEvents.dataModified))
{$c.Stage.applicationSettings.widgetEvents.dataModified($this.id(),$this.type(),data.appData);}}});el.bind("widgetError",function(e,error)
{if(error)
{$c.Stage.log(error.error);$c.Stage.errorAlert(error.message);}});$j(".widget .widget-head",el).each(function()
{if(!$j(this).data("hasHandlers"))
{$j(this).dblclick(function()
{this.changeView();return false;}).hover(function(){$j(this).css({cursor:"move"});},function(){$j(this).css({cursor:"auto"});}).data("hasHandlers",true);}});var id=this.options.id;$j("#"+id+" .minimize, #"+id+" .maximize, #"+id+" .close, #"+id+" .editConfig").live("click",function()
{var $this=$j(this);var selector=$this.hasClass("minimize")?"minimize":$this.hasClass("maximize")?"maximize":$this.hasClass("close")?"close":$this.hasClass("editConfig")?"editConfig":"";$c.Stage.log(selector+" for "+id);$c(this)[selector]();}).live("mouseover",function(){$j(this).css({cursor:"pointer"});}).live("mouseout",function(){$j(this).css({cursor:"auto"});});el.unbind('dblclick').bind('dblclick',function(event){if($this.instance().mode()=='public'&&$j.isFunction($c.Stage.applicationSettings.widgetActions.doubleClick)){$c.Stage.applicationSettings.widgetActions.doubleClick($this.id(),$this.type(),event);}
return false;});if(options)
{if(options.callback&&$j.isFunction(options.callback))options.callback(this);}},PreviousInstance:function(view)
{this.objectType=WidgetInstance;this.view=view;},changeView:function(view,mode)
{if(!$j.isPopulated(view)||this.options.closed)
{if(this.options.closed)
{this.popZIndex();switchingContent=true;var configOpts=$j.isPopulated(this.options.prevView)&&$j.isPopulated(this.options.prevView.opts)?this.options.prevView.opts:null;if($j.isFunction(this.element.data("finishConfiguration")))
{if($j.isPopulated(this.options.prevView))this.options.prevView.element.fadeOut("slow");this.element.data("finishConfiguration")(configOpts);this.element.data("finishConfiguration",null);}
else
{if($j.isPopulated(mode)&&this.instance().mode()!=mode)this._changeMode(mode);this._currentInstance().fadeIn("slow");}
this.options.closed=false;$c.CommManager.widgetAction("open",this);return;}
view=this._getNextViewInToggle();}
if(view!=this.options.currentView)
{this.popZIndex();this.previousInstance=new PreviousInstance(this.options.currentView());$c.Stage.log("about to load instance for view "+view+" and mode "+mode);this.loadInstance(view,null,mode);}},_getNextViewInToggle:function()
{var view=this.options.currentView;var toggle=this.options.views[this.options.currentView].toggle;if(!(toggle=="none"||this.options.views.length<=1))
{var first=null;var next=false;var newView=null;for(var i=0;i<this.options.views.list.length;i++)
{var v=this.options.views[this.options.views.list[i]];if(first==null)first=v;if(v.toggle==toggle)
{if(next)
{newView=v;break;}
next=(v.Type==this.options.currentView);}}
if(newView==null)newView=first;view=newView.Type;}
return view;},_changeMode:function(mode)
{this.instance().mode(mode);switch(mode)
{case'edit':this.editConfig();break;}},minimize:function()
{$j(".minimize",this.element).addClass("maximize").removeClass("minimize");close();this._currentInstance().trigger("closed");},maximize:function()
{$j(".maximize",this.element).addClass("minimize").removeClass("maximize");this.changeView(this.options.currentView);this._currentInstance().trigger("opened");},editConfig:function(callback)
{var $this=this;if(this.options.isEditConfigEnabled)
{$c.CommManager.widgetAction('getAuth',this.instance(),{},function(data)
{var token=data.token;if($j.isPopulated(token))
{$this.authToken=token;$this.instance().mode('edit');$this._currentInstance().trigger("openingConfig");$this.editConfigEnabled(false);$this.element.find(".widget-title").html($this.options.editTitle);if($c.Stage.applicationSettings["hideCloseControlOnEdit"])$this.element.find(".close").hide();if($j.isFunction($c.Stage.applicationSettings.widgetEvents.openedConfig)){$c.Stage.applicationSettings.widgetEvents.openedConfig($this.id(),$this.type());}
if(callback)
callback();}},function(xhr,status,error)
{if(!$j.isPopulated(status))
{status='This action did not complete successfully. Please try again.';}
var msg='Could not save data.\nstatus: '+status+'\nerror: '+error;$c.Stage.log(msg);$c.Stage.errorAlert(msg);});}},saveConfig:function(loadContent)
{this.instance().saveConfig(loadContent);},cancelConfig:function(loadContent)
{this.instance().cancelConfig(loadContent);},savedConfig:function(success)
{if(success)
{if($j.isFunction($c.Stage.applicationSettings.saveConfigSuccess))
$c.Stage.applicationSettings.saveConfigSuccess(this.id());else if($j.isFunction($c.Stage.applicationSettings.widgetEvents.saveConfigSuccess))
$c.Stage.applicationSettings.widgetEvents.saveConfigSuccess(this.id(),this.type());}
else
{if($j.isFunction($c.Stage.applicationSettings.saveConfigFailed))
$c.Stage.applicationSettings.saveConfigFailed(this.id());else if($j.isFunction($c.Stage.applicationSettings.widgetEvents.saveConfigFailed))
$c.Stage.applicationSettings.widgetEvents.saveConfigFailed(this.id(),this.type());}
if($j.isPopulated(this.instance())){this.instance().savedConfig(success);}},cancelledConfig:function()
{if($j.isFunction($c.Stage.applicationSettings.cancelledConfig))
$c.Stage.applicationSettings.cancelledConfig(this.id());else if($j.isFunction($c.Stage.applicationSettings.widgetEvents.cancelledConfig))
$c.Stage.applicationSettings.widgetEvents.cancelledConfig(this.id(),this.type());if($j.isPopulated(this.instance()))
this.instance().cancelledConfig();},obscure:function()
{this._currentInstance().trigger("obscured");if($j.isFunction($c.Stage.applicationSettings.obscured))
$c.Stage.applicationSettings.obscured(this.id());else if($j.isFunction($c.Stage.applicationSettings.widgetEvents.obscured))
$c.Stage.applicationSettings.widgetEvents.obscured(this.id(),this.type());},reveal:function()
{if($j.isFunction($c.Stage.applicationSettings.revealed))
$c.Stage.applicationSettings.revealed(this.id());else if($j.isFunction($c.Stage.applicationSettings.widgetEvents.revealed))
$c.Stage.applicationSettings.widgetEvents.revealed(this.id(),this.type());this._currentInstance().trigger("revealed");},resized:function()
{this._currentInstance().trigger("resizedParent");if($j.isFunction($c.Stage.applicationSettings.widgetEvents.resizedWidgetContainer))
$c.Stage.applicationSettings.widgetEvents.resizedWidgetContainer(this.id(),this.type());},hide:function()
{this._currentInstance().fadeOut("slow");this.options.closed=true;},show:function(mode)
{this.changeView(null,mode);},close:function()
{if(!this.options.closed)
{if($j.isFunction($c.Stage.applicationSettings.closeControlAction))
{$c.Stage.applicationSettings.closeControlAction(this.id());}
else if($j.isFunction($c.Stage.applicationSettings.widgetActions.closeControlClick))
{$c.Stage.applicationSettings.widgetActions.closeControlClick(this.id());}
else
{this.hide();this._currentInstance().trigger("closed");$c.CommManager.widgetAction("close",this);}}},changeColors:function(colors)
{this._currentInstance().trigger({type:"changedColors",colors:colors});},setWidgetIcon:function(src)
{this.element.find(".widget-title-icon").attr("src",src).css("display","");},setEditTitle:function(title)
{this.options.editTitle=title;},remove:function(skipConfirm,success,error,options)
{var $this=this;options=options?options:{};var doit=function()
{$this.element.fadeOut("slow",function(){$j(this).remove();});$c.Stage.currentSpace().removeWidgetContainer($this);if(!$j.isFunction(success))success=function(){};if(!$j.isFunction(error))error=function(){};$c.CommManager.widgetAction("delete",$this,{},success,error);};if(skipConfirm)
{doit();}
else
{$c.Stage.showModalNotification({message:options.confirmMessage?options.confirmMessage:"Are you sure you want to remove this widget?  This cannot be undone.",title:options.confirmTitle?options.confirmTitle:"Remove Widget",buttons:[{type:'ok',caption:'OK',suppressClose:false,action:function(element,button)
{doit();element.simpleDialog("close");}},{type:'cancel',caption:'Cancel'}]});}},loadInstance:function(view,initialization,mode)
{this._setup();if(this.isRenderable())
{$c.Stage.log("widget is renerable - about to load");this.showLoadingDialog();var viewChanged=$j.isPopulated(this.options.previousInstance);var instance=viewChanged?this.getInstance(this.options.previousInstance.view):this._currentInstance();var oldInstance=null;this._disableClicks();var instanceBase;if($j.isPopulated(instance))
{instanceBase=instance.data("cygnusWidgetInstance");if(view==this.options.currentView&&instanceBase.initiated()&&!viewChanged&&!instanceBase.isReloading())return;if(instanceBase.initiated())oldInstance=instance;}
instance=this.getInstance(view);if(instance==null||instance==undefined)
{$c.Stage.log("initializing widget in "+mode+" mode and "+view+" view");if(!$j.isPopulated(mode))mode='public';instance=$j("<div></div>").appendTo(this.element).cygnusWidgetInstance({container:this,type:this.options.type,view:view,mode:mode,initialization:initialization});this._setInstance(view,instance);}
else
{instanceBase=instance.data("cygnusWidgetInstance");$c.Stage.log("loading instance for "+instanceBase.id()+" of type "+this.options.type);instanceBase.configure();var opts={width:(instanceBase.view()=="big"?$c.Stage.stageWidth():instanceBase.width())+"px"};if(instanceBase.height()!=0||instanceBase.view()=="big")opts.height=(instanceBase.view()=="big"?WidgetHelper.stageHeight():instanceBase.height())+"px";var showInstance=function(){if(!instanceBase.container().closed())instance.fadeIn("slow");};if(oldInstance!=null)
{switch(true)
{case viewChanged:oldInstance.css({position:'absolute'}).fadeOut("slow");instance.css({position:'absolute'});showInstance();break;default:oldInstance.fadeOut("slow",showInstance);break;}}
else
showInstance();this.element.data("newView",view);for(var i=0;i<this.options.views.list.length;i++)
{this.element.removeClass(this.options.views.list[i]);}
this.element.addClass(instanceBase.view());var displayIt=function(override)
{$c.Stage.log("about to display widget");instanceBase.container().hideLoadingDialog();var instOpts={width:opts.width,height:opts.height};if(!instanceBase.container().switchingContent())
{if(instanceBase.container().closed())
{instanceBase.container().element.css(instOpts);$c.Stage.currentSpace().clearReadyQueue(instanceBase.id());instanceBase.container().popZIndex();instance.fadeIn("slow");}
else
{$c.Stage.currentSpace().clearReadyQueue(instanceBase.id());}}
else
{if($j.isPopulated(override))
{instanceBase.container().element.css(override);opts.top=override.top;opts.left=override.left;}
instanceBase.container().switchingContent(false);instance.fadeIn("slow");instanceBase.container().element.animate(opts,{queue:false,duration:1000,complete:function(){instanceBase.container().shown();}});}
instanceBase.container().element.trigger("widgetShown",[instanceBase.container().id()]);};this.options.instanceLoaded=true;if(instanceBase.container().closed())
{instanceBase.container().currentView(view);instance.data("finishConfiguration",displayIt);instanceBase.container().hideLoadingDialog();}
else
{displayIt(null);}}}},shown:function()
{var $container=this;var view=this.element.data("newView");if(view==null||view==undefined||view.length<=0)return;this.element.data("newView","");this.currentView=view;var instance=this._currentInstance();if(instance==null||instance==undefined)return;var instanceBase=instance.data("cygnusWidgetInstance");if(instanceBase.initiated()||$j.isPopulated(this.previousInstance()))
{var params={view:view,x:instanceBase.left(),y:instanceBase.top()};if($j.isPopulated(this.previousInstance()))params.newtype=this.type;$c.CommManager.widgetAction("changeview",instanceBase,params)}
else instanceBase.initiated(true);instanceBase.isReloading(false);this.options.previousInstance=null;this.options.closed=false;$c.Stage.resetBoundaries();}}
$j.widget("ui.cygnusWidgetContainer",CygnusWidgetContainer);})(jQuery);

;(function($j)
{var CygnusWidgetInstance={options:{type:null,view:'normal',mode:'public',container:null,height:100,width:100,log:true},_create:function()
{this.objectType="WidgetInstance";this.options.initiated=false;this.options.isReloading=false;this.options.id=this._generateId();this._load(this.options.initialization);},_log:function(msg)
{if(!$j.isPopulated(this.options)||!$j.isPopulated(this.options.log))return;if(window.console&&console.log)
{console.log(msg);}},destroy:function()
{$j.Widget.prototype.destroy.call(this);},_generateId:function()
{return this.options.container.id()+"-"+this.options.type+"-"+this.options.view;},accessMethod:function()
{return this.options.container.accessMethod();},id:function(){return this.options.id;},type:function(){return this.options.type;},view:function(){return this.options.view;},mode:function(value){if($j.isPopulated(value)){this.options.mode=value;return this.element;}else{return this.options.mode;}},container:function(){return this.options.container;},height:function(value){if($j.isPopulated(value)){this.options.height=value;return this.element;}else{return this.options.height;}},width:function(value){if($j.isPopulated(value)){this.options.width=value;return this.element;}else{return this.options.width;}},initiated:function(value){if($j.isPopulated(value)){this.options.initiated=value;return this.element;}else{return this.options.initiated;}},isReloading:function(value){if($j.isPopulated(value)){this.options.isReloading=value;return this.element;}else{return this.options.isReloading;}},setWidgetContent:function(extensionName)
{this.options.extensionName=extensionName;},widgetContentName:function()
{return this.options.extensionName;},_load:function(initialization)
{this.options.container.showLoadingDialog();this.options.container.element.show();if($j.isPopulated(initialization))
{this.options.container.closed(!initialization.shown);if(!this.options.container.closed()&&!$c.Stage.currentSpace().initialized())this.options.container.closed(true);}
$c.CommManager.getWidget(this);if($c.Stage.evilBrowser)
{setTimeout(function()
{var last=$j(".widget-container:last");if(last!=this.options.container.element)last.after(this.options.container.element);},10);}},render:function(data)
{var el=this.options.container.element;el.removeClass("widget-error");var temp=this.element;temp.empty().addClass("widget-instance").attr("id",this.options.id).css("display","none");if($j.isPopulated(data.disabled)&&data.disabled)
{var msg=data.message?data.message:'This widget has been disabled.';temp.text(msg).css({'width':'100%','height':'50px'});setTimeout(function(){el.trigger("widgetPreShow",[this.id]);},100);}
else
{try
{if(!$j()[data.widgetName]&&$j.isPopulated(data.widgetCode))
{$c.Stage.log("new load for "+data.widgetName);try
{eval(data.widgetCode);$c.Stage.log(data.widgetName+' widget code executed');}
catch(e)
{$c.Stage.log(" Error name: "+e.name+". Error message: "+e.message);}}
if($j()[data.widgetName])
{$c.Stage.log("haven't loaded "+data.widgetName);this.setWidgetContent(data.widgetName);data.initData["instance"]=this;if(this.options.mode=="edit")data.initData["initMode"]="edit";$c.Stage.log("about to render "+data.widgetName+" in "+data.initData["initMode"]+" mode.");temp[data.widgetName](data.initData);$c.Stage.log("in instance before preshow trigger\n"+temp.html());setTimeout(function(){el.trigger("widgetPreShow",[this.id]);},100);}
else
{data.error=(data.error?data.error:{message:"Error while rendering."});throw("Unable to load widget! "+data.error);}}
catch(ex)
{el.trigger("widgetError",data.error);}}
temp.css({top:0,left:0});if(data.width&&data.width!="")temp.css("width",data.width);if(data.height&&data.height!="")temp.css("height",data.height);this.options.width=temp.width();this.options.height=temp.innerHeight();temp.css({top:null,left:null});if(data.error)el.addClass("widget-error");this.options.container.loadInstance(this.options.view);},configure:function()
{},saveConfig:function(loadContent)
{this.element[this.widgetContentName()]("saveConfig",loadContent);},cancelConfig:function(loadContent)
{this.element[this.widgetContentName()]("cancelConfig",loadContent);},savedConfig:function(success)
{},cancelledConfig:function()
{}}
$j.widget("ui.cygnusWidgetInstance",CygnusWidgetInstance);})(jQuery);

;(function($c,$j)
{var Stage=function()
{log("Cygnus logging on");var stage=this;this.spaces={};this.currentSpace=null;this.applicationSettings={showContainerControls:true,showConfigControl:false,showToggleControl:true,showCloseControl:true,hideCloseControlOnEdit:false,applicationEvents:{colorsChanged:undefined,closedAll:undefined,openedAll:undefined},widgetEvents:{saveConfigSuccess:undefined,saveConfigFailure:undefined,cancelledConfig:undefined,openedConfig:undefined,closedConfig:undefined,configSizeChanged:undefined,revealed:undefined,obscured:undefined,displayed:undefined,contentUpdated:undefined,widgetModalDisplayed:undefined,dataModified:undefined,error:undefined},widgetActions:{closeControlClick:undefined,doubleClick:undefined},applicationUtilityProviders:{getImages:undefined},actionUri:"action.ashx",proxyUri:"/plugins/cygnuswidget/proxyhandler.php",baseWidgetColors:{background:undefined,textTitle:undefined,textContent:undefined,textLink:undefined,borderTitle:undefined},widgetInitializeOptions:{},modalContainerCssClass:''};this.applicationWidgetEditProperties=null;this.applicationWidgetNonEditProperties=null;function configure()
{var version=parseInt($j.browser.version.split(".")[0]);stage.evilBrowser=($j.browser.msie&&(version<=6));if($j.isFunction(stage.customConfigure))stage.customConfigure();}
function resetBoundaries()
{$j(window).resize();}
function addSpace(id,title)
{if(!$j.isPopulated(stage.spaces))stage.spaces={};if(!$j.isPopulated(stage.spaces.list))stage.spaces.list=[];stage.spaces[id]=new Space(id,title);stage.spaces.list.push(id);stage.spaces[id].initialized=false;}
function loadSpace(id,title)
{if(!$j.isPopulated(stage.spaces))stage.spaces={};if(!$j.isPopulated(stage.spaces[id]))addSpace(id,title);stage.currentSpace=stage.spaces[id];stage.currentSpace.configure();stage.currentSpace.initialize();return stage.spaces[id];}
function registerDependency(options)
{var frameworkPath='//widget.starfieldtech.com/API.svc/support.js?script=';var lazyOpts={name:options.name};lazyOpts['src']=(!$j.isPopulated(options.src))?frameworkPath+options.name:options.src;if($j.isPopulated(options.dependencies))
{$j.each(options.dependencies,function(i,val)
{if(val.indexOf("http")<0)
options.dependencies[i]=frameworkPath+val;})
lazyOpts.dependencies={js:options.dependencies};}
$j.lazy(lazyOpts,true);}
function canUseStarfieldUI()
{return window.require!=undefined&&$j.isFunction(window.require);}
function showModalNotification(options)
{if(!$j.isPopulated(options))return;var element;var width=$j.isPopulated(options.width)?options.width:500;var dialogOptions={autoOpen:false,modal:true,position:'center',positionMode:options.positionMode||'absolute',autoResize:true,resizable:false,closeOnEscape:false,overlay:{background:'#000',opacity:0.70},width:width,zIndex:(options.zIndex?options.zIndex:$j.getMaxZIndex()+1)};var message=$j.isPopulated(options.message)?options.message:"Notification";var controls={};var controlDefs="";var buttonActions={execute:function(which)
{var btn=element.find('.'+this[which].buttonClass);var enabled=!btn.hasClass('disable');if($j.isPopulated(this[which])&&$j.isFunction(this[which])&&enabled)this[which](element,btn);}};var suppressClose;var onClick;if(!$j.isPopulated(options.buttons))
{suppressClose=$j.isPopulated(options.suppressClose)?options.suppressClose:false;onClick="var dialog = $j(this).parents('div.cygnus-notification-dialog'); dialog.data('buttonActions').execute('modalOk');"+(suppressClose?"":" dialog.simpleDialog('close');");controlDefs='<a class="button-modal-ok black-css3-button" href="#" onclick="'+onClick+'">'+($j.isPopulated(options.okCaption)?options.okCaption:'OK')+'</a>';buttonActions['modalOk']=$j.isPopulated(options.okAction)&&$j.isFunction(options.okAction)?options.okAction:function(){};buttonActions['modalOk'].buttonClass='button-modal-ok';}
else
{for(var i=0;i<options.buttons.length;i++)
{var button=options.buttons[i];var buttonName='button'+i;suppressClose=$j.isPopulated(button.suppressClose)?button.suppressClose:false;var buttonAttributes='';var attributes=button.attributes;if($j.isPopulated(attributes))
{for(var item in attributes)
buttonAttributes+=item+'="'+attributes[item]+'" ';buttonAttributes=' '+buttonAttributes;}
onClick="var btn = $j(this); var enabled = !btn.hasClass('disable'); var dialog = $j(this).parents('div.cygnus-notification-dialog'); dialog.data('buttonActions').execute('"+buttonName+"');"+(suppressClose?"":" if (enabled) dialog.simpleDialog('close');");controlDefs+='<a '+(button.id?'id="'+button.id+'" ':'')+'class="black-css3-button button-modal-'+($j.isPopulated(button.type)?button.type:"ok")+($j.isPopulated(button.enable)&&!button.enable?' disable':'')+'" href="#" onclick="'+onClick+'"'+($j.isPopulated(button.enable)&&!button.enable?' enabled="false"':'')+buttonAttributes+'>'+($j.isPopulated(button.caption)?button.caption:'OK')+'</a>';buttonActions[buttonName]=$j.isPopulated(button.action)&&$j.isFunction(button.action)?button.action:{};buttonActions[buttonName].buttonClass='button-modal-'+($j.isPopulated(button.type)?button.type:'ok');}}
var temp=$j('<div class="cygnus-notification-dialog" style="width: '+dialogOptions["width"]+'px; "></div>').appendTo(document.body).hide();var id=$j.isPopulated(options.id)?options.id:'spaceModalNotification';var html='<div class="modal-widget" id="'+id+'" style="width: '+dialogOptions["width"]+'px;">';html+='<div class="widget-head" id="spaceModalNotificationhead">';html+=($j.isPopulated(options.title)?options.title:"Notification");html+='<div class="widget-head-close"/>'
html+='</div>';html+='<div class="widget-body" id="spaceModalNotificationbody"><div class="widget-body-content">'+message.replace('\n','<br/>')+'</div>';if($j.isPopulated(options.buttonLineHtml))
{html+='<div style="position:relative;z-index:1;">'+options.buttonLineHtml+'</div>';}
html+='<div class="cygnus-notification-dialog-buttons">'+controlDefs+'</div></div></div>';temp.append(html);var contentDiv=temp.find('.widget-body-content');var contentMargin=contentDiv.css('margin-top');if(!$j.isPopulated(contentMargin)||contentMargin=='0px')
{contentDiv.css('margin','15px');}
var buttonWidth=0;var buttonDiv=temp.find(".cygnus-notification-dialog-buttons");buttonDiv.find("a").each(function(){buttonWidth+=stage.evilBrowser?$j(this).width():$j(this).outerWidth();});var margin=((stage.evilBrowser?(width-50):buttonDiv.width())-buttonWidth)/2;buttonDiv.css("margin-left",margin+'px');dialogOptions.height=temp.height();var self=this;temp.bind("dialogopen",function(e,ui)
{if($j.isPopulated(self.applicationSettings.modalContainerCssClass))
{temp.parent().addClass(self.applicationSettings.modalContainerCssClass);}
temp.show();});temp.bind("dialogclose",function(event,ui)
{$j(this).simpleDialog('destroy').remove();});temp.simpleDialog(dialogOptions);temp.data("buttonActions",buttonActions).simpleDialog('open');temp.find('.widget-head-close').click(function(){temp.simpleDialog('destroy').remove();});element=temp;if($j.isPopulated(options.callback)&&$j.isFunction(options.callback))options.callback(temp,this);return{element:element,closeIt:function(){element.simpleDialog('destroy').remove();},enableButton:function(buttonId,enable){if(typeof(enable)=='undefined')
enable=true;for(var i=0;i<options.buttons.length;i++){var btn=options.buttons[i];if(btn.id==buttonId){btn.enable=enable;var $btn=$j('#'+btn.id);if(enable)$btn.prop("enabled",true).removeClass("disable");else $btn.removeProp("enabled").addClass("disable");break;}}}};}
function errorAlert(message)
{showModalNotification({message:'<div>'+message+'</div>',title:"Error",okCaption:"OK"});return false;}
function alert(message,title)
{showModalNotification({message:'<div>'+message+'</div>',title:title,okCaption:"OK"});return false;}
function showSimpleModal(options)
{if(!$j.isPopulated(options))return;var element;var width=$j.isPopulated(options.width)?options.width:300;var isModalForWidget=$j.isPopulated(options.spawnedFromWidget)&&options.spawnedFromWidget;var overlay=$j.isPopulated(options.overlay)?options.overlay:{background:'#fff',opacity:0.60};var dialogOptions={autoOpen:false,modal:true,position:'center',positionMode:options.positionMode||'absolute',autoResize:true,resizable:false,overlay:overlay,width:width,zIndex:(options.zIndex?options.zIndex:$j.getMaxZIndex()+1)};var message=$j.isPopulated(options.message)?options.message:"Notification";var controls={};var controlDefs="";var buttonActions={execute:function(which,btn)
{if($j.isPopulated(this[which])&&$j.isFunction(this[which]))this[which](element,btn);}};var suppressClose;var onClick;if(!$j.isPopulated(options.buttons))
{suppressClose=$j.isPopulated(options.suppressClose)?options.suppressClose:false;onClick="var dialog = $j(this).parents('div.cygnus-simple-dialog'); dialog.data('buttonActions').execute('modalClose', jQuery('.button-modal-close'));"+(suppressClose?"":" dialog.simpleDialog('close');");controlDefs='<a class="button-modal-close" href="javascript:void(0);" onclick="'+onClick+'">'+($j.isPopulated(options.closeCaption)?options.closeCaption:'X')+'</a>';buttonActions['modalClose']=$j.isPopulated(options.closeAction)&&$j.isFunction(options.closeAction)?options.closeAction:null;}
var temp=$j('<div class="cygnus-simple-dialog'+($j.isPopulated(options.dialogClass)?" "+options.dialogClass:"")+'" style="width: '+dialogOptions["width"]+'px; "></div>').appendTo(document.body).hide();var html='<div'+(isModalForWidget?' class="modal-widget"':'')+' id="spaceSimpleModal" style="width: '+dialogOptions["width"]+'px;">';if(!$j.isPopulated(options.buttons))
{html+='<div class="cygnus-simple-dialog-buttons" style="margin: 0; overflow: hidden;">'+controlDefs+'</div>';}
html+='<div class="widget-body" id="spaceSimpleModalbody"><div>'+message;html+='</div>';temp.append(html);if($j.isPopulated(options.buttons))
{var btns=options.buttons;for(var i=0;i<btns.length;i++){if($j.isPopulated(btns[i].id)){buttonActions['button'+i]=$j.isPopulated(btns[i].action)&&$j.isFunction(btns[i].action)?btns[i].action:null;buttonActions['buttonDisabled'+i]=$j.isPopulated(btns[i].actionDisabled)&&$j.isFunction(btns[i].actionDisabled)?btns[i].actionDisabled:null;var btn=temp.find("#"+btns[i].id).unbind().data('buttonIdx',i);btn.click(function(){var idx=$j(this).data('buttonIdx');if(btns[idx].enable===true){var dialog=$j(this).parents('div.cygnus-simple-dialog');dialog.data('buttonActions').execute('button'+idx,$j(this));var suppressClose=$j.isPopulated(btns[idx].suppressClose)?btns[idx].suppressClose:false;if(!suppressClose)
dialog.simpleDialog('close');}else{var dialog=$j(this).parents('div.cygnus-simple-dialog');dialog.data('buttonActions').execute('buttonDisabled'+idx,$j(this));}});}}}
else
{var buttonWidth=0;var buttonDiv=temp.find(".cygnus-notification-dialog-buttons");buttonDiv.find("a").each(function(){buttonWidth+=stage.evilBrowser?$j(this).width():$j(this).outerWidth();});var margin=((stage.evilBrowser?(width-50):buttonDiv.width())-buttonWidth)/2;buttonDiv.css("margin-left",margin+'px');}
dialogOptions["height"]=(temp.height()<150?150:temp.height());temp.bind("dialogopen",function(e,ui)
{if($j.isPopulated(options.containerCssClass))
{temp.parent().addClass(options.containerCssClass);}
temp.show();});temp.bind("dialogclose",function(event,ui)
{$j(this).simpleDialog('destroy').remove();});temp.simpleDialog(dialogOptions);temp.data("buttonActions",buttonActions).simpleDialog('open');element=temp;if(isModalForWidget)
{if($j.isPopulated(this.applicationSettings.widgetModalDisplayAction))
this.applicationSettings.widgetModalDisplayAction(temp);else if($j.isPopulated(this.applicationSettings.widgetEvents.widgetModalDisplayed))
this.applicationSettings.widgetEvents.widgetModalDisplayed(temp);}
if($j.isPopulated(options.callback)&&$j.isFunction(options.callback))options.callback(element);return{element:element,closeIt:function(){element.simpleDialog('destroy').remove();},enableButton:function(buttonId,enable){if(typeof(enable)=='undefined')
enable=true;for(var i=0;i<options.buttons.length;i++){var btn=options.buttons[i];if(btn.id==buttonId){btn.enable=enable;break;}}}};}
function showBubble(message,target,options)
{if(!$j.isPopulated(options))options={};if(!$j.isPopulated(options.side))options.side="right";var showOnLeft=options.side!="right";var arrow=showOnLeft?"r":"l";var leftShownOffset=55;if(!$j.isPopulated(options.html))options.html='<div class="message-body"></div>';if(!$j.isPopulated(options.messageBodyClass))options.messageBodyClass="message-body";var bubble=$j(options.html);var bubbleContent=bubble.hasClass(options.messageBodyClass)?bubble:bubble.find("."+options.messageBodyClass);bubbleContent.html(message);options.ghost=bubble;options.closeOnClick=true;options.parentDimensions=false;if(!$j.isPopulated(options.width))options.width=225;options.ghost.width(options.width);if(!$j.isPopulated(options.offsetX))options.offsetX=0;var baseLeft=showOnLeft?-(options.width+leftShownOffset):target.width();options.offsetX=(options.offsetX==0?baseLeft:baseLeft+options.offsetX);if(!$j.isPopulated(options.offsetY))options.offsetY=-30;if(!$j.isPopulated(options.interval))options.interval=10000;return target.flashTip(options);}
function showGrowl(options)
{var message='';if(canUseStarfieldUI())
{var message=!$j.isPopulated(options.title)&&$j.isPopulated(options.message)?'':(options.message||'');var title=$j.isPopulated(options.title)?options.title:options.message;var icon=options.growlType||'';require(["starfield/sf.growl"],function()
{jQuery('<div />').sfGrowl({title_text:title,paragraph_html:message,fadetime:3000,icon:icon});});}
else
{var message=options.message||'';message=options.title?'<h1>'+options.title+'</h1>'+message:message;var anchor=$j("#bubbleAnchor");if($j("#bubbleAnchor").length==0)anchor=$j('<div id="#bubbleAnchor" style="position:absolute; top:0; right:0; height: 1px; width: 1px; zIndex:'+$j.getMaxZIndex()+'"></div>').appendTo(document.body);showBubble(message,anchor,{side:'left',interval:3000,offsetY:50,offsetX:-50});}}
function stageWidth()
{var scrollWidth=Math.max(document.documentElement.scrollWidth,document.body.scrollWidth);var offsetWidth=Math.max(document.documentElement.offsetWidth,document.body.offsetWidth);if(scrollWidth>offsetWidth)
{return $j(window).width()+'px';}else
{return scrollWidth+'px';}}
function stageHeight()
{var height=0;var scrollHeight=Math.max(document.documentElement.scrollHeight,document.body.scrollHeight);var offsetHeight=Math.max(document.documentElement.offsetHeight,document.body.offsetHeight);if(scrollHeight>offsetHeight)
{height=$j(window).height();}else
{height=scrollHeight;}
return height+'px';}
function center(options)
{var el=options["element"],parent=options&&options["container"]?options["container"]:$j(window),doc=$j(document),pTop=options&&options["container"]?0:doc.scrollTop(),pLeft=options&&options["container"]?0:doc.scrollLeft(),minTop=pTop,elWidth=options&&options["width"]?(options["width"].constructor==String?options["width"].stripCssUnit():options["width"]):el.outerWidth(),elHeight=options&&options["height"]?(options["height"].constructor==String?options["height"].stripCssUnit():options["height"]):el.outerHeight();pLeft+=(parent.width()-elWidth)/2;pTop+=(parent.height()-elHeight)/2;pTop=Math.max(pTop,minTop);el.css({top:pTop,left:pLeft});}
function getContainerFromElement(element)
{var container=null;var elContainer=null;if($j.isPopulated(element))
{var el=$j(element);if(el.hasClass("widget-container"))
{elContainer=el;}
else
{elContainer=el.parents(".widget-container");if(!$j.isPopulated(elContainer))
elContainer=$j(".widget-container",el);}
if($j.isPopulated(elContainer))
container=elContainer.data("cygnusWidgetContainer");}
if(!$j.isPopulated(elContainer))
{this.log("found the element and the container is "
+$j.isPopulated(container));}
return container;}
function log(msg,target)
{if(!($j.getQueryStringVariable("fred")=="on"))return;if($j.isPopulated(target))
{target.append("<div>"+msg+"</div>");}
else
{if(window.console&&console.log)
{console.log(msg);}}}
return{currentSpace:function(value)
{if($j.isPopulated(value))stage.currentSpace=value;return stage.currentSpace;},applicationSettings:applicationSettings,center:center,configure:configure,resetBoundaries:resetBoundaries,addSpace:addSpace,loadSpace:loadSpace,showModalNotification:showModalNotification,showSimpleModal:showSimpleModal,alert:alert,errorAlert:errorAlert,showBubble:showBubble,showGrowl:showGrowl,stageWidth:stageWidth,stageHeight:stageHeight,getContainerFromElement:getContainerFromElement,registerDependency:registerDependency,log:log};}
$c.Stage=Stage();})(Cygnus,jQuery);

;(function($c,$j)
{var CommManager=function()
{function widgetAction(action,sender,params,success,error)
{if(!$j.isPopulated(params))params={};if(!$j.isPopulated(sender)||!(sender.objectType=="WidgetContainer"||sender.objectType=="WidgetInstance"))
if(params.type==undefined||params.view==undefined)return;var scdParams=$j.extend(true,{},params);params["context"]="widget";params["userid"]=$c.UserId;if(!$j.isPopulated(params["action"]))
params["action"]=action;if(!$j.isPopulated(params["type"]))
params["type"]=sender.type();params=addApplicationData(params);if($j.isPopulated(sender))
{switch(sender.objectType)
{case"WidgetInstance":params["widgetId"]=sender.container().id();params["authToken"]=sender.container().authToken;if(!$j.isPopulated(params["view"]))params["view"]=sender.view();break;case"WidgetContainer":params["widgetId"]=sender.id();params["authToken"]=sender.authToken;if(!$j.isPopulated(params["view"]))params["view"]=sender.currentView()==null?sender.views[0]:sender.currentView();break;default:break;}}
var sendActionToApp=function()
{var opts={type:"POST",dataType:'json',data:params,url:$c.Stage.applicationSettings.actionUri,success:function(data){parseData(data,success);},error:$j.isFunction(error)?error:function(xhr,status,err){$c.Stage.log("status: "+status+"\nerror: "+err);}}
$c.Stage.log($j.jsonStringify(opts));$j.ajax(opts);};switch(action.toLowerCase())
{case"getdata":getWidget(sender,true,success);break;case"saveconfigdata":scdParams["purpose"]="saveconfig";scdParams["authToken"]=params["authToken"];getData(sender,sendActionToApp,scdParams,error);break;default:sendActionToApp();break;}}
function spaceAction(action,sender,params)
{if(!$j.isPopulated(params))params={};if(!(sender.constructor==Space||sender.constructor==Stage))
if(params.type==undefined||params.view==undefined)return;params["context"]="space";params["userid"]=$c.UserId;if(!$j.isPopulated(params["action"]))params["action"]=action;if(!$j.isPopulated(params["id"]))params["id"]=sender.id;params=addApplicationData(params);$j.post($c.Stage.applicationSettings.actionUri,params,function(data){parseData(data);});}
function sendRpcIframe(instance,metaData,successCallbackFunc){var contentServiceUrl=$c.Data.Spaces[$c.Stage.currentSpace().id].Widgets[instance.container().id()].ContentServiceUrl;if(window.location.href.toLowerCase().indexOf('https')==0)
contentServiceUrl=contentServiceUrl.replace('http://','https://');rpcProxyUrl=contentServiceUrl.substr(0,contentServiceUrl.lastIndexOf('/'))+'/rpcproxy.htm'+'?postUrl='+
encodeURIComponent(contentServiceUrl);var data={service:instance.type(),type:instance.type(),view:instance.view(),method:'POST',datatype:'json'};data=addAppParams(data);var params=buildPostParams(data,metaData);var iframeLoadFunc=function(){gd.rpc.addMessageListener(metaData.action+'Finished',function(args,event)
{if(event.source==iframeWindow)
{successCallbackFunc(args);}
iframe.remove();});var trunkDataStoreArray=new Array();var hitTimes=0;gd.rpc.addMessageListener('composeArgs',function(jsonStringTrunk,event){var paramPairs=jsonStringTrunk.split('&');var params={};for(var i=0;i<paramPairs.length;i++){var parts=paramPairs[i].split('=');params[decodeURIComponent(parts[0])]=parts[1];}
var trunkIndex=parseInt(params.ti);var trunkTotal=parseInt(params.tt);trunkDataStoreArray[trunkIndex]=params.a;hitTimes++;if(hitTimes==trunkTotal){var argsJsonString=decodeURIComponent(trunkDataStoreArray.join(""));var argsJson=argsJsonString?JSON.parse(argsJsonString):{};var origin=decodeURIComponent(params.o);gd.rpc.handleMessage(params.c,argsJson,{source:window.parent,origin:origin});trunkDataStoreArray=new Array();hitTimes=0;}});gd.rpc.sendMessage(iframeWindow,(iframe.attr('src')!=undefined)?iframe.attr('src'):'',metaData.action,params);};instance.container().element.append('<div style="height:1px; width:1px; overflow:hidden;"><iframe frameborder="0" allowtransparency="true" src="'+rpcProxyUrl+'" name="'+('hidden-frame-'+Math.floor(Math.random()*1000000000))+'" /></div>');var iframe=instance.container().element.find("iframe");if(iframe.length)
{var iframeWindow=iframe[0].contentWindow;iframe.bind("load",iframeLoadFunc);}}
function getWidget(instance,dataOnly,dataOnlyCallback)
{if(instance.objectType!="WidgetInstance")return;$c.Stage.log("about to retrieve widget "+instance.id()+" via "+instance.accessMethod()+" for space ");var metaData={action:'get',widgetId:instance.container().id(),widgetDefinitionId:instance.container().type(),spaceId:$c.Stage.currentSpace().id,userId:$c.UserId,applicationId:$c.ApplicationId,contentIsLoaded:dataOnly||instance.container().contentIsLoaded()};metaData=addApplicationData(metaData);var success=dataOnly?dataOnlyCallback:function(data){instance.render(data);};if(instance.accessMethod()=="jsonp"||instance.accessMethod()=="rpcpost")
{var jsonpUrl=buildUrlWithAccessMethod(instance.container().id(),instance.type(),instance.view(),metaData,"jsonp");if(instance.accessMethod()=="jsonp"||jsonpUrl.length<=2000){$j.ajax({dataType:'jsonp',data:'{}',jsonp:'jsoncallback',url:jsonpUrl,success:success,error:function(data){$c.Stage.errorAlert("error!!");}});}
else{sendRpcIframe(instance,metaData,function(data){parseData(data,success);});}}
else
{var opts={type:instance.accessMethod().replace("proxy",""),dataType:'json',url:buildUrl(instance.container().id(),instance.type(),instance.view(),metaData),success:function(data)
{parseData(data,success);},error:function(xmlHttpRequest,status,error)
{$c.Stage.log("Error Loading Widget via proxy\nstatus: "+status+"\nerror: "+error);}}
switch(instance.accessMethod())
{case"proxypost":var data={service:instance.type(),type:instance.type(),view:instance.view(),method:'POST',datatype:'json'};data=addAppParams(data);opts["data"]=buildPostParams(data,metaData);break;case"proxyget":case"json":default:break;}
if($j.getQueryStringVariable("fred")=="on")alert($j.convertToJson(opts));$j.ajax(opts);}}
function getSpace(space)
{if(space.objectType!=Space)return;var data={context:'space',action:'get',spaceId:space.id,userId:$c.UserId};data=addApplicationData(data);var opts={type:"POST",dataType:'json',url:$c.Stage.applicationSettings.actionUri,data:data,success:function(data)
{parseData(data,function(data)
{if($j.isPopulated(data.Space))
{if(!$j.isPopulated($c.Data.Spaces))$c.Data.Spaces={};if(!$j.isPopulated($c.Data.Spaces.list))$c.Data.Spaces.list=[];if($j.inArray(space.id,$c.Data.Spaces.list)<=-1)$c.Data.Spaces.list.push(space.id);$c.Data.Spaces[space.id]=data.Space[space.id];space.initialize();}});},error:function(xmlHttpRequest,status,error)
{alert("There was an error retrieving the page.\nerror: "+error+"\nstatus: "+status,"Error");}}
$j.ajax(opts);}
function getData(instance,callback,params,error)
{if(instance.objectType!="WidgetInstance")return;var service=instance.container().id();params=$j.isPopulated(params)?params:{};params["action"]='data';params["widgetId"]=instance.container().id();params["spaceId"]=$c.Stage.currentSpace().id;params["userId"]=$c.UserId;params["applicationId"]=$c.ApplicationId;params["widgetDefinitionId"]=instance.container().type();params=addApplicationData(params);if(instance.accessMethod()=="jsonp"||instance.accessMethod()=="rpcpost")
{var jsonpUrl=buildUrlWithAccessMethod(service,instance.type(),instance.view(),params,"jsonp");if(instance.accessMethod()=="jsonp"||jsonpUrl.length<=2000){$j.ajax({dataType:'jsonp',data:'{}',jsonp:'jsoncallback',url:jsonpUrl,success:callback,error:$j.isFunction(error)?error:function(xhr,status,err){alert("Communications error.");$c.Stage.log("status: "+status+"\nerror: "+err);}});}
else{sendRpcIframe(instance,params,function(data){parseData(data,callback);});}}
else
{var opts={type:instance.accessMethod().replace("proxy",""),dataType:'json',url:buildUrl(service,instance.type(),instance.view()),success:function(data){parseData(data,callback);},error:function(xmlHttpRequest,status,error)
{$c.Stage.log("Error getting data via proxy\nstatus: "+status+"\nerror: "+error);$c.Stage.errorAlert("There was an error retrieving data.");}}
switch(instance.accessMethod().toLowerCase())
{case"proxypost":var data={service:service,type:instance.type(),view:instance.view(),method:'POST',datatype:'json'};opts["data"]=buildPostParams(data,params);break;case"proxyget":default:opts["url"]=this.buildUrl(instance.type,instance.view,instance.keys);break;}
if($j.getQueryStringVariable("fred")=="on")
alert($j.convertToJson(opts));$j.ajax(opts);}}
function addApplicationData(params)
{if($j.isPopulated($c.CommManager.applicationData))
{for(var item in $c.CommManager.applicationData)
{params[item]=$c.CommManager.applicationData[item];}}
return params;}
function buildUrl(service,type,view,callerParams)
{var accessMethod=$c.Data.Spaces[$c.Stage.currentSpace().id].Widgets[service].AccessMethod.toLowerCase();return buildUrlWithAccessMethod(service,type,view,callerParams,accessMethod);}
function buildUrlWithAccessMethod(service,type,view,callerParams,accessMethod){var url=$c.Stage.applicationSettings.proxyUri;if(accessMethod=="jsonp")url=$c.Data.Spaces[$c.Stage.currentSpace().id].Widgets[service].ContentServiceUrl;var data={view:view};if(accessMethod=="proxyget")
{data["service"]=service;data["type"]=type;data["method"]="get";}
if(accessMethod=="proxyget"||accessMethod=="jsonp")url+=(url.indexOf("?")>-1?'&':'?')+buildGetParams(data,callerParams);return url;}
function buildGetParams(data,callerParams)
{data=buildPostParams(data,callerParams);var params="";if($j.isPopulated(data))
{for(var item in data)
{params+=encodeURIComponent(item)+"="+encodeURIComponent(data[item])+"&";}}
params=params.substring(0,params.length-1);return params;}
function buildPostParams(data,callerParams)
{if(data==null||data==undefined)data={};if($j.isPopulated(callerParams))
{for(var item in callerParams)
{data[item]=callerParams[item];}}
return data;}
function parseData(data,callback)
{if($j.isPopulated(data.error)&&$j.isPopulated(data.error.type)&&data.error.type=="SessionTimeout")
{$c.Stage.showModalNotification({message:"<div>"+data.error.message+"<br/><br/>You will be prompted to log in again before continuing.</div>",title:'Session Invalid',okAction:function(){window.location.reload();}});}
else if($j.isFunction(callback))callback(data);setupPostCall();}
function setupPreCall()
{$j(".notify-when-busy").addClass("busy");}
function setupPostCall()
{$j(".notify-when-busy").removeClass("busy");}
function addAppParams(params)
{return params;}
return{widgetAction:widgetAction,spaceAction:spaceAction,getWidget:getWidget,getSpace:getSpace,getData:getData};}
$c.CommManager=CommManager();})(Cygnus,jQuery);


function Space(id,title)
{id=$j.isPopulated(id)?id:$j.getGuid(8);var title=title;var list=[];var items={};var readyQueue={};var isViable=true;this.initialized=false;var $space=this;function initialize()
{if(!$space.initialized)
{if($j.isPopulated($c.Data.Spaces)&&$c.Data.Spaces[id])
{var list=$c.Data.Spaces[id].Widgets.list;for(var i=0;i<list.length;i++)
{loadWidgetContainer(list[i]);}
$space.initialized=true;$j(window).trigger('cygnusSpaceLoaded');}
else
{$c.CommManager.getSpace(this);}}}
function loadWidgetContainer(widgetId,anchor,mode)
{var wc=findWidgetContainer(widgetId);var loadIt=function(wc,view)
{if(wc!=null&&$j.isPopulated(anchor))
{wc.anchor(anchor);$c.Stage.log("anchor associated with widget container for "+wc.id()+":"+wc.type());}
if(wc!=null&&wc.isRenderable())
{$c.Stage.log("building widget container for "+wc.id()+":"+wc.type());wc.loadInstance(view,null,mode);}
else $c.Stage.log("not renderable: widget container for "+wc.id()+":"+wc.type());}
if(!$j.isPopulated(wc))
{var dataSpace=$c.Data.Spaces[id];var widget=dataSpace.Widgets[widgetId];$c.Stage.log("loadWidgetContainer for "+widgetId);var wcElement=addWidgetContainer(widget.Type,widget.Id,anchor);wc=wcElement.data("cygnusWidgetContainer");loadIt(wc,widget.View);}
else
{if(!wc.instanceIsLoaded())
{loadIt(wc,wc.currentView());}
else if(wc.instanceIsLoaded())
{if(wc.closed||wc.hidden)wc.show(mode);}}
return wc.element;}
function configure()
{}
function addWidgetContainer(type,widgetId,anchor)
{if(widgetId==null||widgetId==undefined)widgetId="w"+type+"-"+$j.getGuid(8);var widget=$c.Data.Spaces[id].Widgets[widgetId];if($j.isPopulated(widget))
{var wc=$j("<div></div>").cygnusWidgetContainer({type:type,id:widgetId,meta:widget,anchor:anchor});list.push(widgetId);wc.id=widgetId;$c.Stage.log("adding "+widgetId);items[widgetId]=wc.data("cygnusWidgetContainer");return wc;}
else
{$c.Stage.errorAlert("did not add widget container!\n"+widgetId);return null;}}
function removeWidgetContainer(wc)
{var wcId=wc.id();index=$j.inArray(wcId,list);if(index>-1)
list.splice(index,1);var item=items[wcId];item.destroy();delete items[wcId];}
function findWidgetContainer(widgetId)
{var item=items[widgetId];$c.Stage.log(($j.isPopulated(item))?"found "+widgetId:"missing "+widgetId);return items[widgetId];}
function findWidgetContentElement(widgetId)
{var wc=findWidgetContainer(widgetId);if(wc)
return wc.instanceElement();}
function addWidgetData(widget)
{$c.Data.Spaces[id].Widgets[widget.Id]=widget;}
function removeWidgetData(widgetId)
{delete $c.Data.Spaces[id].Widgets[widgetId];}
function widgetReady(element,callback)
{var id="";if(element.constructor==String)id=element;else id=($j(element).attr("id")!=undefined)?$j(element).attr("id"):'';this.readyQueue[id]=callback;}
function clearReadyQueue(id)
{var readyQueue=this.readyQueue;if($j.isPopulated(readyQueue))
{setTimeout(function()
{if($j.isFunction(readyQueue[id]))
{readyQueue[id]($j('#'+id));readyQueue[id]=null;}},10);}};return{objectType:Space,id:id,title:title,list:list,items:items,isViable:isViable,initialized:function(value){if($j.isPopulated(value))$space.initialized=value;return $space.initialized;},initialize:initialize,configure:configure,addWidgetContainer:addWidgetContainer,loadWidgetContainer:loadWidgetContainer,removeWidgetContainer:removeWidgetContainer,findWidgetContainer:findWidgetContainer,findWidgetContentElement:findWidgetContentElement,addWidgetData:addWidgetData,removeWidgetData:removeWidgetData,widgetReady:widgetReady,clearReadyQueue:clearReadyQueue}};


(function($)
{var BaseWidget={options:{instance:null,widgetId:'1',respondsToEvents:{windowResize:'resize',containerResize:'resizedParent',opened:'opened',closed:'closed',obscured:'obscured',revealed:'revealed',openingConfig:'openingConfig',savedConfig:'savedConfig',cancelledConfig:'cancelledConfig',removingWidget:'removingWidget',changedColors:'changedColors'},editConfigPanelClass:'widget-edit-config-panel',editConfigPanelFieldClass:'widget-edit-config-panel-field',editConfigPanelLabelClass:'widget-edit-config-panel-label',editConfigPanelLabelDescriptionClass:'description',editConfigPanelCheckboxLabelClass:'checkbox-label',editConfigPanelButtonClass:'widget-edit-config-panel-button',editConfigPanelButtonClassOkSave:'edit-config-save black-css3-button',editConfigPanelButtonClassCancel:'edit-config-cancel',editConfigPanelSaveOrCancelButtonsClass:'buttons',editConfigPanelFieldContainerClass:'field',editConfigPanelSectionDescriptionClass:'section-description',editConfigPanelFormErrorsClass:'error',editConfigPanelRequiredLegendClass:'required-legend',editConfigPanelRequiredColorClass:'required',editConfigPanelAppDataFieldClass:'appdata',editConfigPanelColorDataFieldClass:'color-setting',editConfigPanelColorDataSampleClass:'color-sample',waiter_message:'Searching...',waiter_waiterClass:'waiter',waiter_innerWaiterClass:'inner-waiter',waiter_waiterSpinClass:'waiter-spin',configData:{},log:true,cicodes:{}},homeUrl:'[serviceBasePath]',imageBasePath:'',cygnusInstance:null,cygnusContainer:null,cygnusStage:null,cygnusComm:null,containerClass:'',editPanelClass:'',isRevealed:false,oldEditPanelHeight:0,colorSelectorTokens:{'%title':'.widget-title','%titleborder':'.title-bar'},_super:function(method,args)
{if(args===undefined)
args=[];if($.cygnus.baseWidget.prototype[method]!=null&&$.cygnus.baseWidget.prototype[method]!=undefined)
return $.cygnus.baseWidget.prototype[method].apply(this,args);},_create:function()
{this._log("_create[cygnus.BaseWidget.js]"+this.widgetBaseClass+":"+this.options.widgetId);this._initCygnus();if(!$.isPopulated(this.cygnusInstance))
{this._log("this.cygnusInstance is NOT populated "+this.widgetBaseClass);this.destroy();return false;}
if($.isPopulated(this.options.widgetIcon))this.cygnusContainer.setWidgetIcon(this._getWidgetImagePath(this.options.widgetIcon));if($.isPopulated(this.options.editTitle))this.cygnusContainer.setEditTitle(this.options.editTitle);if($.isPopulated($c.Stage.applicationSettings.widgetInitializeOptions[this.cygnusContainer.type()]))
{$.extend(this.options,$c.Stage.applicationSettings.widgetInitializeOptions[this.cygnusContainer.type()]);}
this.containerClass=this.widgetBaseClass+"-container";this.editPanelClass=this.options.editConfigPanelClass;var $this=this;setTimeout(function(){$this.cygnusInstance.element.trigger($this.options.respondsToEvents.revealed)},1500);this.element.addClass(this.widgetBaseClass+this.options.widgetId).addClass(this.widgetBaseClass);for(var colorName in this.colorsDefault)
{var color=this.colorsDefault[colorName];for(var token in this.colorSelectorTokens)
{var expr=new RegExp("("+token+")(?=$|,)",'g');if($.isArray(color.selector))
{for(var i=0;i<color.selector.length;i++)
color.selector[i]=color.selector[i].replace(expr,this.colorSelectorTokens[token]);}
else color.selector=color.selector.replace(expr,this.colorSelectorTokens[token]);}}
if(!$j.isPopulated(this.options.configData))this.options.configData={};if(!$j.isPopulated(this.options.configData.colors))this.options.configData.colors={};},_init:function(){},destroy:function()
{this._log("destroying "+this.widgetBaseClass);this.element.removeClass(this.widgetBaseClass);this._unconfigureEvents();this.cygnusInstance.element.empty();$.Widget.prototype.destroy.call(this);},_initCygnus:function()
{this._log("_initCygnus "+this.widgetBaseClass+":"+this.options.widgetId);this.cygnusInstance=this.options.instance;this.cygnusContainer=this.options.instance.container();this.cygnusComm=$c.CommManager;this.cygnusStage=$c.Stage;},_configureEvents:function()
{var options=this.options;this.cygnusContainer.editConfigEnabled(true);this._log("_configureEvents");var widgetDiv=this.cygnusInstance.element;widgetDiv.bind(options.respondsToEvents.opened,{widget:this},this._openWidget).bind(options.respondsToEvents.closed,{widget:this},this._closeWidget).bind(options.respondsToEvents.obscured,{widget:this},this._obscureWidget).bind(options.respondsToEvents.revealed,{widget:this},this._revealWidget).bind(options.respondsToEvents.openingConfig,{widget:this},this._openConfig).bind(options.respondsToEvents.containerResize,{widget:this},this._resizedParent).bind(options.respondsToEvents.removingWidget,{widget:this},this.destroy).bind(options.respondsToEvents.savedConfig,{widget:this},this._savedConfig).bind(options.respondsToEvents.cancelledConfig,{widget:this},this._cancelledConfig).bind(options.respondsToEvents.changedColors,{widget:this},this._changedColors);},_unconfigureEvents:function()
{var options=this.options;this.element.removeClass(this.widgetBaseClass+options.widgetId).removeClass(this.widgetBaseClass);this.cygnusInstance.element.unbind(options.respondsToEvents.opened).unbind(options.respondsToEvents.closed).unbind(options.respondsToEvents.obscured).unbind(options.respondsToEvents.revealed).unbind(options.respondsToEvents.openingConfig).unbind(options.respondsToEvents.containerResize).unbind(options.respondsToEvents.removingWidget);},_configureAppEditConfigEvents:function()
{var $this=this;},_unconfigureAppEditConfigEvents:function()
{},_collectAppData:function()
{var appData=this.cygnusStage.applicationWidgetEditProperties;var configAppData={};var widgetId=this.options.widgetId;if($.isPopulated(appData))
{$('input.'+this.options.editConfigPanelAppDataFieldClass,$('.'+this.options.editConfigPanelClass,this.element)).each(function()
{var source=$(this);var dataId=(source.attr('id')!=undefined?source.attr('id'):'').replace(widgetId+'-','');var strippedInput='';if($.isPopulated(appData[dataId]))
{strippedInput=$('<div>').html(source.val()).text();}
configAppData[dataId]={value:strippedInput,type:appData[dataId].type};});}
this.options.configData['applicationWidgetEditProperties']=configAppData;this.options.configData['applicationWidgetNonEditProperties']=this.cygnusStage.applicationWidgetNonEditProperties;return appData;},_addAppDataValidation:function()
{var editPanel=this.element.find('.'+this.options.editConfigPanelClass);if(this.cygnusStage.applicationWidgetEditProperties)
{for(var key in this.cygnusStage.applicationWidgetEditProperties)
{var item=this.cygnusStage.applicationWidgetEditProperties[key];if(!$.isPopulated(item.excludeWidgetTypes)||!item.excludeWidgetTypes[this.cygnusInstance.type()])
{if(item.validate)
{editPanel.find('#'+this.options.widgetId+'-'+key).validation({uiMode:'inline',rules:function(elem,builtins,errorMgr)
{var value=elem.val();if(item.autoTrim||!$.isPopulated(item.autoTrim))
{value=value.trim();}
var result=item.validate(value);if(!result.configIsValid)
{errorMgr.addError('Invalid',result.message);}
return result.configIsValid;}});}}}}},_validateAppData:function()
{var appDataTemplate=this.cygnusStage.applicationWidgetEditProperties;var appData=this.options.configData['applicationWidgetEditProperties'];var allValid=true;var results=[];for(var item in appData)
{var validate=appDataTemplate[item].validate(appData[item].value);if(!validate.configIsValid)
{allValid=false;results[results.length]={item:item,message:validate.message};}}
return{configIsValid:allValid,configErrors:results};},_getEditAppConfigHtml:function()
{var html='';var config={};var widgetId=this.options.widgetId;var widgetType=this.cygnusInstance.type();if($.isPopulated(this.cygnusStage.applicationWidgetEditProperties))
{config=$.extend(config,this.cygnusStage.applicationWidgetEditProperties);for(field in this.cygnusStage.applicationWidgetEditProperties)
{var item=this.cygnusStage.applicationWidgetEditProperties[field];if(!$.isPopulated(item.excludeWidgetTypes)||!item.excludeWidgetTypes[widgetType])
{var val=this.cygnusContainer.getConfigData(field);if($.isPopulated(val))config[field].value=val;}
else
{delete config[field];}}}
for(var key in config)
{var setting=config[key];var overrides=setting.overrides&&setting.overrides[widgetType]?setting.overrides[widgetType]:{};var displayName=overrides.displayName?overrides.displayName:setting.displayName;var description=overrides.description?overrides.description:setting.description;html+='<div class="'+this.options.editConfigPanelFieldContainerClass+'">'+'<label for="'+widgetId+"-"+key+'">'+
displayName.escapeHtml()+
(setting.showRequiredSymbol?'<span class="'+this.options.editConfigPanelRequiredColorClass+'">*</span>':'')+'</label>';if(setting.description)
{html+='<label class="'+this.options.editConfigPanelLabelDescriptionClass+'">'+
description.escapeHtml()+'</label>';}
html+='<div>'+'<input class="'+this.options.editConfigPanelAppDataFieldClass+'" '+
(setting.maxLength?'maxlength="'+setting.maxLength+'" ':'')+'id="'+widgetId+"-"+key+'" '+'value="'+setting.value.escapeHtml()+'" />'+'</div>'+'</div>';}
return html;},_getEditAppConfigColorsHtml:function()
{var html='';var requests=this.colorsToRequest;var defaults=this.colorsDefault;if(!$.isPopulated(requests)||$.isEmptyObject(requests))return html;if(!$.isPopulated(defaults)||$.isEmptyObject(defaults))return html;var colors=$.extend(true,{},defaults);var colorsConfig=this.options.configData.colors;var widgetId=this.options.widgetId;var widgetType=this.cygnusInstance.type();var useColor=function(colorName,colorType)
{if(requests.all)return true;else if(requests[colorType])
{if(requests[colorType]=='all')return true;else if(requests[colorType][colorName])return true;}
else return false;};for(colorName in defaults)
{var colorData=defaults[colorName];if(useColor(colorName,colorData.type))
{if(colorsConfig)
{var val=colorsConfig[colorName];if($.isPopulated(val))colors[colorName].value=val;}}
else
{delete colors[colorName];}}
html+='<div class="'+this.options.editConfigPanelFieldContainerClass+'">';for(var key in colors)
{var setting=colors[key];var displayName=setting.displayName;html+='<div id="cp-'+widgetId+'-'+this.options.editConfigPanelColorDataFieldClass+'-'+key+'"'+' class="'+this.options.editConfigPanelColorDataFieldClass+'"'+' data:colorname="'+key+'"'+' data:selector="'+setting.selector+'"'+' data:value="'+setting.value.escapeHtml()+'" />'+'<label for="cp-'+widgetId+"-"+key+'" class="color-label">'+
displayName.escapeHtml()+' color:</label>';}
html+='</div>';return html;},_setupColorPicker:function()
{var $this=this;var defaults=this.colorsDefault;var colorsConfig=this.options.configData.colors;if($.isPopulated(defaults))
{for(var colorName in this.colorsDefault)
{colorsConfig[colorName]=defaults[colorName].value;}}
require("starfield/sf.colorpicker",function()
{$('.'+$this.options.editConfigPanelClass,$this.element).find('div.'+$this.options.editConfigPanelColorDataFieldClass).each(function(i,div)
{jDiv=$(div);var initColor=jDiv.attr('data:value');var colorName=jDiv.attr('data:colorname');$(div).sfColorPicker({initColor:initColor,canBeSetToNone:true,liveUpdates:true,onPersist:function(color,ui,element)
{colorsConfig[colorName]=color;$this._refreshWidgetColors();},onChange:function(color,changeType,ui,element)
{colorsConfig[colorName]=color;$this._refreshWidgetColors();},onOpen:function(element)
{$('.'+$this.options.editConfigPanelClass,$this.element).find('div.'+$this.options.editConfigPanelColorDataFieldClass+':not(#'+element.attr('id')+')').sfColorPicker('close');}});});});},_collectColorData:function()
{var $this=this;var defaults=this.colorsDefault;var colorsConfig=this.options.configData.colors;if($.isPopulated(defaults))
{for(var colorName in this.colorsDefault)
{colorsConfig[colorName]=defaults[colorName].value;}
$('input.'+this.options.editConfigPanelColorDataFieldClass,$('.'+this.options.editConfigPanelClass,this.element)).each(function()
{$this._updateColorConfigValue($(this));});}
return colorsConfig;},_applyWidgetColors:function(reset)
{var elRoot=this.cygnusContainer.element;var colors=this.getAppliedColors();var applyColor=function(selector,property,value)
{var el=selector?elRoot.find(selector):elRoot;value=reset?'':value;if(el.length>0)el.css(property,value);}
for(var colorName in colors)
{var color=colors[colorName];if(color.selector!=undefined&&color.selector!=null)
{if($.isArray(color.selector))
{if($.isArray(color.property))
{for(var i=0;i<color.selector.length;i++)
applyColor(color.selector[i],color.property[i],color.value);}}
else applyColor(color.selector,color.property,color.value);}}},getAppliedColors:function(colorsOnly)
{var applies=this.colorsToApply;if(!$.isPopulated(applies)||$.isEmptyObject(applies))return null;var defaults=this.colorsDefault;var colors=$.extend({},defaults)
var colorsConfig=this.options.configData.colors;for(var colorName in defaults)
{var value=this.getAppliedColor(colorName);if(value!=null)
{if(colorsOnly)
colors[colorName]=value;else
colors[colorName].value=value;}
else
delete colors[colorName];}
return colors;},getAppliedColor:function(colorName)
{var applies=this.colorsToApply;var value=null;if(!$.isPopulated(applies)||$.isEmptyObject(applies))return value;var defaults=this.colorsDefault;var colorsConfig=this.options.configData.colors;var useColor=function(colorName,colorType)
{if(applies.all)return true;else if(applies[colorType])
{if(applies[colorType]=='all')return true;else if(applies[colorType][colorName])return true;}
else return false;};if(useColor(colorName,defaults[colorName].type))
{value=colorsConfig[colorName]?colorsConfig[colorName]:defaults[colorName].value;}
return value;},_removeWidgetColors:function()
{this._applyWidgetColors(true);},_refreshWidgetColors:function()
{this._removeWidgetColors();this._applyWidgetColors();},_collectAppWidgetColors:function(colors)
{colors=!$.isPopulated(colors)?$c.Stage.applicationSettings.baseWidgetColors:colors;for(var colorName in this.colorsDefault)
{if(colors[colorName])this.colorsDefault[colorName].value=colors[colorName];}},_initWidgetColors:function()
{this._collectAppWidgetColors();this._applyWidgetColors();this._log('_initWidgetColors: '+this.widgetBaseClass+':'+this.options.widgetId);},_setAppWidgetColors:function(colors)
{this._collectAppWidgetColors(colors);},_openWidget:function()
{this._log('_openWidget: '+this.widgetBaseClass+':'+this.options.widgetId);},_closeWidget:function()
{this._log('_closeWidget: '+this.widgetBaseClass+':'+this.options.widgetId);},_obscureWidget:function(event)
{var $this=event.data.widget;$this._log('_obscureWidget: '+$this.widgetBaseClass+':'+$this.options.widgetId);$this.isRevealed=false;},_revealWidget:function(event)
{var $this=event.data.widget;$this._log('_revealWidget: '+$this.widgetBaseClass+':'+$this.options.widgetId);var revealed=$this.isRevealed;$this.isRevealed=true;$this._initWidgetColors();return revealed;},_resizedParent:function(event)
{var $this=event.data.widget;$this._log('resized parent for '+$this.widgetBaseClass+':'+$this.options.widgetId);},_openConfig:function(event)
{var $this=event.data.widget;$this._unconfigureAppEditConfigEvents();$("."+$this.options.editConfigPanelClass,$this.element).remove();$("."+$this.containerClass,$this.element).show();$this._log('_openConfig: '+$this.widgetBaseClass+':'+$this.options.widgetId);$this.oldConfigData=$.extend(true,{},$this.options.configData);$('.error-bubble').flyout('destroy');},_closeConfig:function(reload)
{var editClass="."+this.options.editConfigPanelClass;var containerClass="."+this.containerClass;if(reload)
{this.cygnusContainer.element.trigger("closingConfig",[true]);}
else
{this._unconfigureAppEditConfigEvents();$(editClass,this.element).remove();$(containerClass,this.element).show();this.cygnusContainer.element.trigger("closingConfig");}
this._refreshWidgetColors();},_savedConfig:function(success)
{this.cygnusContainer.element.trigger("savedConfig",{success:success,widgetId:this.id});},_cancelledConfig:function()
{this.cygnusContainer.element.trigger("cancelledConfig");},_changedColors:function(event)
{var $this=event.data.widget;$this._collectAppWidgetColors(event.colors);$this._removeWidgetColors();$this._applyWidgetColors();$this._log('_colorsChanged: '+$this.widgetBaseClass+':'+$this.options.widgetId);},_disableWidget:function(message)
{this._closeConfig(false);this._cancelledConfig();this.cygnusContainer.editConfigEnabled(false);this.cygnusInstance.render({'disabled':true,'message':message});},_getElement:function(source)
{return $(source).hasClass(this.widgetBaseClass)?source:$(source).parents(this.widgetBaseClass);},_getAppImagePath:function(imageFile)
{return""+imageFile;},_getWidgetImagePath:function(imageFile)
{return this.options.imageBasePath+'/'+imageFile;},_addCSS:function(cssCode)
{if($("."+this.widgetBaseClass).length<=1)
{var styleElement=document.createElement("style");styleElement.type="text/css";if(styleElement.styleSheet)
{styleElement.styleSheet.cssText=cssCode;}
else
{styleElement.appendChild(document.createTextNode(cssCode));}
document.getElementsByTagName("head")[0].appendChild(styleElement);}},_addStyleSheet:function(src)
{if($("."+this.widgetBaseClass).length<=1)
{var styleElement=document.createElement("link");styleElement.type="text/css";styleElement.href=src;styleElement.rel="stylesheet";document.getElementsByTagName("head")[0].appendChild(styleElement);}},_canUseStarfieldUI:function()
{return window.require!=undefined&&$.isFunction(window.require);},_log:function(msg)
{if(!$.isPopulated(this.options.log)||!this.options.log)return;$c.Stage.log(msg);},showWaiter:function()
{var innerWaiter=$('<div class="'+this.options.waiter_innerWaiterClass+'" />').append('<div class="'+this.options.waiter_waiterSpinClass+'" />').append('<div>'+this.options.waiter_message+'</div>');var waiter=$('<div id="'+this.widgetBaseClass+'-wait-'+this.options.widgetId+'" class="'+this.options.waiter_waiterClass+'" style="display:none;"  />').append(innerWaiter).appendTo(this.element);var anchor=this.element;if(anchor)
{var positionInfo=$.getPosition({element:waiter,anchor:anchor,positionX:'flush',positionY:'flush',offsetX:0,offsetY:0});var op=anchor.offsetParent();var newPos={top:Math.floor(positionInfo.y.position)-(op?op.offset().top:0),left:Math.floor(positionInfo.x.position)-(op?op.offset().left:0),width:anchor.width(),height:anchor.height()};if(newPos.top<0)newPos.top=positionInfo.y.position;if(newPos.left<0)newPos.left=positionInfo.x.position;if($.isPopulated(newPos.top))
{var innerWaiterTop=Math.floor((anchor.height()-94)/2);if(innerWaiterTop>0)
innerWaiter.css('top',innerWaiterTop);waiter.css(newPos).show();}}},hideWaiter:function()
{var waiter=$("."+this.options.waiter_waiterClass);waiter.hide().remove();},_triggerEditPanelHeightChangeEvent:function()
{var height=this.element.height();var width=this.element.width();if(this.oldEditPanelHeight!=height)
{this.oldEditPanelHeight=height;if($.isPopulated($c.Stage.applicationSettings.widgetEvents.configSizeChanged)&&$.isFunction($c.Stage.applicationSettings.widgetEvents.configSizeChanged))
{$c.Stage.applicationSettings.widgetEvents.configSizeChanged(this.options.widgetId,this.cygnusInstance.type(),{'width':width,'height':height});}
else if($.isPopulated(this.options.editPanelHeightChanged)&&$.isFunction(this.options.editPanelHeightChanged))
{this.options.editPanelHeightChanged(height);}}},getCiCode:function(key)
{var cicode=undefined;var $self=this;if($.isPopulated($self.options.cicodes))
{var data=$self.options.cicodes;if(data.hasOwnProperty(key))
{cicode=data[key];}}
return cicode;},logCicodeEvent:function(key)
{var $self=this;var cicode=$self.getCiCode(key);if($.isPopulated(cicode))
{var feo=new fbiEventObject(window.event,'click',cicode,'');fbiRecordFastballEvent(feo);}},transformCiCodes:function()
{this.element.find("*[cicode]").cicode({});}}
$.widget("cygnus.baseWidget",BaseWidget);})(jQuery);


(function($){var BaseWidget={options:{log:true},_super:function(method,args){if(args===undefined)
args=[];if($.cygnus.uiBaseWidget.prototype[method]!=null&&$.cygnus.uiBaseWidget.prototype[method]!=undefined)
{$.cygnus.uiBaseWidget.prototype[method].apply(this,args);}},_create:function(){var id=(this.element.attr("id")!=undefined)?this.element.attr("id"):'';id=(id.length>0)?"[id="+id+"]":" [class="+(this.element.attr("class")!=undefined?this.element.attr("class"):'')+"]";this._logIdentifier=this.widgetName+id;this._log("loading");this.element.addClass(this.widgetBaseClass);},_init:function(){},destroy:function(){this._log("destroying");this.element.removeClass(this.widgetBaseClass);this.element.empty();$.Widget.prototype.destroy.call(this);},_getImagePath:function(imageFile){return""+imageFile;},_addCSS:function(cssCode){if($("."+this.widgetBaseClass).length<=0){var styleElement=document.createElement("style");styleElement.type="text/css";if(styleElement.styleSheet){styleElement.styleSheet.cssText=cssCode;}
else{styleElement.appendChild(document.createTextNode(cssCode));}
document.getElementsByTagName("head")[0].appendChild(styleElement);}},_addStyleSheet:function(src){if($("."+this.widgetBaseClass).length<=1){var styleElement=document.createElement("link");styleElement.type="text/css";styleElement.href=src;styleElement.rel="stylesheet";document.getElementsByTagName("head")[0].appendChild(styleElement);}},_log:function(msg){if(!$.isPopulated(this.options.log)||!this.options.log)return;$c.Stage.log("{"+this._logIdentifier+"} "+msg);},getCiCode:function(key){var cicode=undefined;var $self=this;if($.isPopulated($self.options.cicodes)){var data=$self.options.cicodes;if(data.hasOwnProperty(key)){cicode=data[key];}}
return cicode;},logCicode:function(cicode){if($.isPopulated(cicode)){var feo=new fbiEventObject(window.event,'click',cicode,'');fbiRecordFastballEvent(feo);}},logCicodeEvent:function(key){var $self=this;var cicode=$self.getCiCode(key);this.logCicode(cicode);}}
$.widget("cygnus.uiBaseWidget",BaseWidget);})(jQuery);


(function($)
{var Flyout={options:{offsetX:0,offsetY:0,positionY:"bottom",positionX:"right",singleInstance:true,flyoutType:'flyout',anchor:undefined,point:undefined,log:true},flyoutIsClosed:true,_create:function()
{this._super("_create");this.element.css("zIndex",$.getMaxZIndex(this.options.anchor)+1);},_init:function()
{this._super("_init");this._positionElement();this.flyoutIsClosed=false;},destroy:function(callback)
{var $this=this;var finish=function()
{$this.element.removeClass($this.widgetBaseClass);if($.isPopulated($this.options.backgroundInfo))$this.element.corners("destroy");if($.isFunction(callback))callback($this.element);$this._super("destroy");}
if(!this.isClosed())
this.close(finish);else
finish();},_positionElement:function(animate)
{var $this=this;if($this.options.singleInstance)
{$(":"+$this.widgetBaseClass).not($this.element).each(function()
{var $other=$(this);if($other.flyout("type")==$this.options.flyoutType&&!$other.flyout("isClosed"))
{$other.flyout("close");}});}
$this.element.css("position","absolute");var newPos={};if($.isPopulated($this.options.point))
{var windowWidth=window.innerWidth||document.documentElement.clientWidth||document.body.offsetWidth;var windowHeight=window.innerHeight||document.documentElement.clientHeight||document.body.offsetHeight;var destPos={};var flyoutWidth=$this.element.width();var flyoutHeight=$this.element.height();if($this.options.positionX=="left")
{if($this.options.point.x<flyoutWidth)
{$this.options.positionX="right"}}
else if(flyoutWidth+$this.options.point.x>windowWidth)
{$this.options.positionX="left"}
if($this.options.positionY=="top")
{if($this.options.point.y<flyoutHeight)
{$this.options.positionY="bottom"}}
else if(flyoutHeight+$this.options.point.y>windowHeight)
{$this.options.positionX="top"}
newPos=newPos={top:($this.options.point.y-($this.options.positionY=="top"?flyoutHeight:0))+'px',left:($this.options.point.x-($this.options.positionX=="left"?flyoutWidth:0))+'px'};}
else if($.isPopulated($this.options.anchor))
{var positionInfo=$.getPosition({element:$this.element,anchor:$this.options.anchor,positionX:$this.options.positionX,positionY:$this.options.positionY,offsetX:$this.options.offsetX,offsetY:$this.options.offsetY});if(positionInfo.x.adjustedPosition!=null)$this.options.positionX=positionInfo.x.adjustedPosition;if(positionInfo.y.adjustedPosition!=null)$this.options.positionY=positionInfo.y.adjustedPosition;newPos={top:positionInfo.y.position,left:positionInfo.x.position};}
if($.isPopulated(newPos.top))
{if(animate)
{$this.element.animate({top:newPos.top,left:newPos.left},500);}
else $this.element.css(newPos);}
this.options.minWidth=this.element.width();},open:function(callback,newPoint)
{if(newPoint)this.options.point=newPoint;this._positionElement();this.element.fadeIn("slow",callback);this.flyoutIsClosed=false;},close:function(callback)
{this.element.fadeOut("slow",callback);this.flyoutIsClosed=true;},isOpen:function()
{return!this.flyoutIsClosed;},isClosed:function()
{return this.flyoutIsClosed;},type:function()
{return this.options.flyoutType;},reposition:function()
{var orig={top:this.element.offset().top,left:this.element.offset().left};this._positionElement();}}
$.widget("cygnus.flyout",$.cygnus.uiBaseWidget,Flyout);})(jQuery);


(function($){var Corners={options:{newWidth:198,newHeight:60,sizes:20,zIndex:0},_create:function(){var $this=this;var wbc=$this.widgetBaseClass;$this._super("_create");var bgClass=$this.options.backgroundClass;$this.element.prepend($('<div class="'+wbc+'-topleft"/>'));$this.element.prepend($('<div class="'+wbc+'-topright"/>'));$this.element.prepend($('<div class="'+wbc+'-topmiddle"/>'));$this.element.prepend($('<div class="'+wbc+'-leftbar"/>'));$this.element.prepend($('<div class="'+wbc+'-rightbar"/>'));$this.element.prepend($('<div class="'+wbc+'-bottomleft"/>'));$this.element.prepend($('<div class="'+wbc+'-bottomright"/>'));$this.element.prepend($('<div class="'+wbc+'-bottommiddle"/>'));if(!$.isPopulated(bgClass.topLeft)){$('.'+wbc+'-topleft, .'+wbc+'-topright, .'+wbc+'-topmiddle, .'+wbc+'-bottomleft, .'+wbc+'-bottomright, .'+wbc+'-bottommiddle, .'+wbc+'-leftbar, .'+wbc+'-rightbar',$this.element).addClass(bgClass);$this.element.addClass(bgClass).css({backgroundPosition:"-"+sizes.leftWidth+"px -"+sizes.topHeight+"px"});}
else{$this.element.find('.'+wbc+'-topleft').addClass(bgClass.topLeft);$this.element.find('.'+wbc+'-topright').addClass(bgClass.topRight);$this.element.find('.'+wbc+'-topmiddle').addClass(bgClass.topMiddle);$this.element.find('.'+wbc+'-leftbar').addClass(bgClass.leftSide);$this.element.find('.'+wbc+'-rightbar').addClass(bgClass.rightSide);$this.element.find('.'+wbc+'-bottomleft').addClass(bgClass.bottomLeft);$this.element.find('.'+wbc+'-bottomright').addClass(bgClass.bottomRight);$this.element.find('.'+wbc+'-bottommiddle').addClass(bgClass.bottomMiddle);$this.element.addClass(bgClass.contentArea);}},_init:function(){this._super("_init");},destroy:function(){this._super("destroy");}}
$.widget("cygnus.corners",$.cygnus.uiBaseWidget,Corners);})(jQuery);


(function($)
{var Validation={options:{rules:function(){return true;},uiMode:'bubbles',immediateValidation:true,invalidElementClass:'invalid',bubbleOptions:{offsetX:0,offsetY:5,positionX:'flush',positionY:'bottom',backgroundColor:'#FFFABF',borderColor:'#dfc15e',fontColor:'#000',factory:function(msg)
{return $('<div class="error-bubble"/>').addClass(this.widgetBaseClass+'-errorBubble').text(msg).corners({sizes:{topHeight:7,bottomHeight:7,leftWidth:7,rightWidth:7},backgroundClass:{contentArea:'bg',leftSide:'l',rightSide:'r',topLeft:'tl',topRight:'tr',topMiddle:'t',bottomLeft:'bl',bottomRight:'br',bottomMiddle:'b'}});}},inlineOptions:{errorElement:undefined,errorClass:'error'},failure:undefined,success:undefined,triggeringElements:[],entryEvents:'focus',changeEvents:'keyup, paste, change',exitEvents:'blur',waitTillDoneWithChange:false,log:true},errors:{},_setOption:function(key,value)
{var self=this;if(key=='bubbleOptions'||key=='inlineOptions')
{$.each(value,function(innerKey,value)
{self.options[key][innerKey]=value;});}else
{$.Widget.prototype._setOption.apply(this,arguments);}},rules:function(element)
{this.StringLengthMax=function(options)
{return($.isPopulated(options.max))?element.val().length<=options.max:true;}
this.StringLengthMin=function(options)
{return($.isPopulated(options.min))?element.val().length>=options.min:true;}
this.StringLength=function(options)
{return this.StringLengthMax(options)&&this.StringLengthMin(options);};this.Required=function(options)
{var value=$.trim(element.val()||'');return value.length>0&&(!$.isPopulated(options)||!$.isPopulated(options.defaultValue)||options.defaultValue!=value);};this.Numeric=function()
{return!isNaN(element.val());}
this.Positive=function()
{return parseFloat(element.val())>0;}
this.Format=function(options)
{if($.isPopulated(options.regex))
{var toMatch=element.val();if(options.trim)toMatch=toMatch.trim();return toMatch.match(options.regex);}
else
{return true;}}
this.NumericRangeHigh=function(options)
{return($.isPopulated(options.highNumericValidValue))?(this.Numeric()&&(parseFloat(element.val())<=options.highNumericValidValue)):true;}
this.NumericRangeLow=function(options)
{return($.isPopulated(options.lowNumericValidValue))?(this.Numeric()&&(parseFloat(element.val())>=options.lowNumericValidValue)):true;}
this.NumericRange=function(options)
{return this.NumericRangeHigh(options)&&this.NumericRangeLow(options);}
return this;},_create:function()
{this._super("_create");this.option(this.options);this.isWaiting=false;var $this=this;this.enable();this.errorManager={addError:function(errorKey,errorMessage)
{$this.errors[errorKey]=errorMessage;},clearErrors:function()
{$this.errors={};},removeError:function(errorKey)
{delete $this.errors[errorKey];}};},_init:function()
{this._super("_init");},destroy:function(callback)
{this._removeErrorBubble();this._super("destroy");},_resetValidation:function()
{if($.isFunction(this.reset))this.reset(this.element);},_removeErrorBubble:function()
{if(this.options.uiMode=="bubbles")
{var $this=this;if($.isPopulated(this.errorBubble)&&this.errorBubble.is(":cygnus-flyout"))
this.errorBubble.flyout("destroy",function(){$this.errorBubble.remove();});}},_removeAllErrorBubbles:function()
{if(this.options.uiMode=="bubbles")
{var bubbles=$j('.'+this.widgetBaseClass+'-errorBubble');bubbles.flyout("destroy",function(element){element.remove();});$j('.'+this.widgetBaseClass+'-errorBubble').remove();}},_controlEntry:function(e)
{if(this.options.immediateValidation)
{this.oldValue=this.element.val();}
else
{this.reset();}},_controlChanged:function(e)
{if(this.options.immediateValidation)
{var $this=this;var go=function()
{$this._removeAllErrorBubbles();$this.isWaiting=false;$this.showValidation();};if(e.type=='keyup'&&this.options.waitTillDoneWithChange)
{if($.isPopulated(this.waitHandle))clearInterval(this.waitHandle);this.isWaiting=true;this.waitHandle=setTimeout(function()
{if($this.oldValue==$this.element.val())go();},300);}
else
{go();}}else
{this.reset();}},_controlExit:function(e)
{if(this.options.immediateValidation)
{if(this.isWaiting)
{clearInterval(this.waitHandle);this.isWaiting=false;}
this._removeAllErrorBubbles();this.showValidation();}},_getEventList:function(eventString)
{var eventList="";if($.isPopulated(eventString)&&eventString.length>0)
{var list=eventString.split(',');var $this=this;$.each(list,function(i,item)
{eventList+=$.trim(item)+'.'+$this.widgetName;if(i<list.length-1)eventList+=" ";});}
return eventList;},_getErrorElement:function()
{if(!$.isPopulated(this._errorElement))
{if(this.options.inlineOptions.errorElement)
{this._errorElement=$(this.options.inlineOptions.errorElement);}else
{this._errorElement=$('<span/>').addClass(this.options.inlineOptions.errorClass).insertAfter(this.element);}}
return this._errorElement;},isValid:function()
{return this.validate();},showValidation:function(suppressValidate)
{if(!this.isWaiting)
{var valid=(suppressValidate)?!this.hasErrors():this.isValid();if(valid)this.success();else this.failure();return valid;}},failure:function()
{var message=null;var $this=this;for(error in this.errors)
{message=this.errors[error];break;}
message=($.isPopulated(message))?message:"Error";if(this.options.uiMode=='bubbles')
{this._removeErrorBubble();var bubbleOptions=this.options.bubbleOptions;this.errorBubble=bubbleOptions.factory.call(this,message).appendTo(document.body).bind("click.flyout",function(){$(this).flyout("close",function(){$(this).remove();})}).flyout({anchor:this.element,flyoutType:this.widgetName,offsetX:bubbleOptions.offsetX,offsetY:bubbleOptions.offsetY,positionX:bubbleOptions.positionX,positionY:bubbleOptions.positionY,singleInstance:false});this.element.parents().unbind("scroll").scroll(function(e)
{$this.errorBubble.bind("click.flyout",function(){$(this).flyout("close",function(){$(this).remove();})}).flyout({anchor:$this.element,flyoutType:$this.widgetName,offsetX:bubbleOptions.offsetX,offsetY:bubbleOptions.offsetY,positionX:bubbleOptions.positionX,positionY:bubbleOptions.positionY,singleInstance:false});});}
else if(this.options.uiMode=='inline')
{this._getErrorElement().text(message);}
if(this.options.invalidElementClass)
{this.element.addClass(this.options.invalidElementClass);}
if($.isFunction(this.options.failure))
{this.options.failure(this.element,message);}},validate:function()
{this.errorManager.clearErrors();if($.isPopulated(this.options.rules))
{this._log(this.options.rules);return this.options.rules(this.element,this.rules(this.element),this.errorManager);}
else
{return true;}},success:function()
{this.errorManager.clearErrors();if(this.options.uiMode=='bubbles')
{this.element.css({"border-color":this.originalBorderColor,"background-color":this.originalBackgroundColor,color:this.originalFontColor}).parents().unbind("scroll");this._removeErrorBubble();}
else if(this.options.uiMode=='inline')
{this._getErrorElement().empty();}
if(this.options.invalidElementClass)
{this.element.removeClass(this.options.invalidElementClass);}
if($.isFunction(this.options.success))
{this.options.success(this.element);}},reset:function()
{this.success();},showError:function(errorMessage)
{this.addError(errorMessage,errorMessage);this.failure();},addError:function(errorKey,errorMessage)
{this.errorManager.addError(errorKey,errorMessage);},clearErrors:function()
{this.errorManager.clearErrors();},removeError:function(errorKey)
{this.errorManager.removeError(errorKey);},hasErrors:function()
{var atLeastOne=false;for(key in this.errors)
{if($.isPopulated(this.errors[key]))
{atLeastOne=true;break;}}
return atLeastOne;},canValidate:function()
{return!this.isWaiting;},enable:function(enableValidation)
{var $this=this;if(enableValidation===undefined)enableValidation=true;var allElements=this.options.triggeringElements.slice();allElements.push(this.element);for(var i=0;i<allElements.length;i++)
{var element=$(allElements[i]);var fn=enableValidation?element.bind:element.unbind;var eventList=this._getEventList(this.options.changeEvents);if(eventList.length>0)
fn.call(element,eventList,function(e)
{$this._controlChanged(e);});eventList=this._getEventList(this.options.entryEvents);if(eventList.length>0)
fn.call(element,eventList,function(e)
{$this._controlEntry(e);});eventList=this._getEventList(this.options.exitEvents);if(eventList.length>0)
fn.call(element,eventList,function(e)
{$this._controlExit(e);});}
if(!enableValidation)
{this._removeAllErrorBubbles();}}}
$.widget("cygnus.validation",$.cygnus.uiBaseWidget,Validation);})(jQuery);


(function(b,k,y){var o="function",l="password",d="maxLength",g="type",a="",c=true,n="placeholder",e=false,w="watermark",j=w,i="watermarkClass",t="watermarkFocus",p="watermarkSubmit",r="watermarkMaxLength",h="watermarkPassword",f="watermarkText",m=/\r/g,v="input:data("+j+"),textarea:data("+j+")",q="input:text,input:password,input:search,textarea",s=["Page_ClientValidate"],u=e,x=n in document.createElement("input");b.watermark=b.watermark||{version:"3.1.2",runOnce:c,options:{className:w,useNative:c,hideBeforeUnload:c},hide:function(a){b(a).filter(v).each(function(){b.watermark._hide(b(this))})},_hide:function(b,q){var o=b[0],p=(o.value||a).replace(m,a),l=b.data(f)||a,n=b.data(r)||0,j=b.data(i);if(l.length&&p==l){o.value=a;if(b.data(h))if((b.attr(g)||a)==="text"){var e=b.data(h)||[],c=b.parent()||[];if(e.length&&c.length){c[0].removeChild(b[0]);c[0].appendChild(e[0]);b=e}}if(n){b.attr(d,n);b.removeData(r)}if(q){b.attr("autocomplete","off");k.setTimeout(function(){b.select()},1)}}j&&b.removeClass(j)},show:function(a){b(a).filter(v).each(function(){b.watermark._show(b(this))})},_show:function(e){var p=e[0],v=(p.value||a).replace(m,a),j=e.data(f)||a,q=e.attr(g)||a,s=e.data(i);if((v.length==0||v==j)&&!e.data(t)){u=c;if(e.data(h))if(q===l){var o=e.data(h)||[],n=e.parent()||[];if(o.length&&n.length){n[0].removeChild(e[0]);n[0].appendChild(o[0]);e=o;e.attr(d,j.length);p=e[0]}}if(q==="text"||q==="search"){var k=e.attr(d)||0;if(k>0&&j.length>k){e.data(r,k);e.attr(d,j.length)}}s&&e.addClass(s);p.value=j}else b.watermark._hide(e)},hideAll:function(){if(u){b.watermark.hide(q);u=e}},showAll:function(){b.watermark.show(q)}};b.fn.watermark=b.fn.watermark||function(s,r){var u="string";if(!this.length)return this;var w=e,v=typeof s===u;if(v)s=s.replace(m,a);if(typeof r==="object"){w=typeof r.className===u;r=b.extend({},b.watermark.options,r)}else if(typeof r===u){w=c;r=b.extend({},b.watermark.options,{className:r})}else r=b.watermark.options;if(typeof r.useNative!==o)r.useNative=r.useNative?function(){return c}:function(){return e};return this.each(function(){var z="dragleave",y="dragenter",B=this,e=b(B);if(!e.is(q))return;if(e.data(j)){if(v||w){b.watermark._hide(e);v&&e.data(f,s);w&&e.data(i,r.className)}}else{if(x&&r.useNative.call(B,e)&&(e.attr("tagName")||a)!=="TEXTAREA"){v&&e.attr(n,s);return}e.data(f,v?s:a);e.data(i,r.className);e.data(j,1);if((e.attr(g)||a)===l){var C=e.wrap("<span>").parent(),o=b(C.html().replace(/type=["']?password["']?/i,'type="text"'));o.data(f,e.data(f));o.data(i,e.data(i));o.data(j,1);o.attr(d,s.length);o.focus(function(){b.watermark._hide(o,c)}).bind(y,function(){b.watermark._hide(o)}).bind("dragend",function(){k.setTimeout(function(){o.blur()},1)});e.blur(function(){b.watermark._show(e)}).bind(z,function(){b.watermark._show(e)});o.data(h,e);e.data(h,o)}else e.focus(function(){e.data(t,1);b.watermark._hide(e,c)}).blur(function(){e.data(t,0);b.watermark._show(e)}).bind(y,function(){b.watermark._hide(e)}).bind(z,function(){b.watermark._show(e)}).bind("dragend",function(){k.setTimeout(function(){b.watermark._show(e)},1)}).bind("drop",function(d){var c=e[0],b=d.originalEvent.dataTransfer.getData("Text");if((c.value||a).replace(m,a).replace(b,a)===e.data(f))c.value=b;e.focus()});if(B.form){var u=B.form,A=b(u);if(!A.data(p)){A.submit(b.watermark.hideAll);if(u.submit){A.data(p,u.submit);u.submit=function(c,a){return function(){var d=a.data(p);b.watermark.hideAll();if(d.apply)d.apply(c,Array.prototype.slice.call(arguments));else d()}}(u,A)}else{A.data(p,1);u.submit=function(a){return function(){b.watermark.hideAll();delete a.submit;a.submit()}}(u)}}}}b.watermark._show(e)})};if(b.watermark.runOnce){b.watermark.runOnce=e;b.extend(b.expr[":"],{search:function(b){return"search"===(b.type||a)},data:function(c,d,a){return!!b.data(c,a[3])}});(function(c){b.fn.val=function(){var d=this;if(!d.length)return arguments.length?d:y;if(!arguments.length)if(d.data(j)){var e=(d[0].value||a).replace(m,a);return e===(d.data(f)||a)?a:e}else return c.apply(d,arguments);else{c.apply(d,arguments);b.watermark.show(d);return d}}})(b.fn.val);s.length&&b(function(){for(var a,c,d=s.length-1;d>=0;d--){a=s[d];c=k[a];if(typeof c===o)k[a]=function(a){return function(){b.watermark.hideAll();return a.apply(null,Array.prototype.slice.call(arguments))}}(c)}});b(k).bind("beforeunload",function(){b.watermark.options.hideBeforeUnload&&b.watermark.hideAll()})}})(jQuery,window);


(function($){$.widget('cygnus.charCounter',{options:{count:500,cssClass:'charCounter',errorCssClass:'error',formatFn:function(n){return n.toString()+' character'+(n==1?'':'s')+' remaining';},errorFormatFn:function(n){return'Exceeding allowed characters by '+n.toString();}},_create:function(){var widget=this;if(this.options.count)
this.element.attr('maxlength',this.options.count);var limitContainer=$('<div/>').addClass(this.options.cssClass).insertAfter(this.element);this.element.limitMaxlength({onEdit:function(remaining){if(remaining<0){limitContainer.text(widget.options.errorFormatFn(-remaining)).addClass(widget.options.errorCssClass);}
else{limitContainer.text(widget.options.formatFn(remaining)).removeClass(widget.options.errorCssClass);}}});}});}(jQuery));


(function($)
{$.widget('cygnus.linkify',{options:{fontColorParent:null,linkCssClass:null},_create:function()
{this.fontCss=($.isPopulated(this.options.fontColorParent))?' style="color: '+$(this.options.fontColorParent).css("color")+';"':'';this.linkClass=($.isPopulated(this.options.linkCssClass))?' class="'+this.options.linkCssClass+'"':'';this.transform(this.options.initText);},_init:function()
{},transform:function(initText)
{var widget=this;var allLines=(typeof(initText)!='undefined')?initText:$j.isPopulated(widget.element.html())?widget.element.html():'';var content=$('<div/>');var lines=allLines.split('\n');for(var i=0;i<lines.length;i++)
{content.append(this._replaceMonikersRecursive(lines[i]));content.append('<br/>');}
widget.element.html(content.html());},destroy:function()
{$.Widget.prototype.destroy.call(this);},_replaceMonikersRecursive:function(text)
{var monikerUrlRegex=/(\s|\(|>|^)(https?:\/\/)(.*?)($|\)|\<|\s)/m;var monikerEmailRegex=/[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/im;var matchUrl=monikerUrlRegex.exec(text);var matchEmail=monikerEmailRegex.exec(text);var result=$('<span/>');if(matchUrl&&(matchEmail==null||matchEmail.index>matchUrl.index))
{var link=$('<a target="_blank"'+this.linkClass+this.fontCss+'/>');var linkText=matchUrl[2]+matchUrl[3];linkText=linkText.substr(0,linkText.length-this._countPunctuation(linkText));link.attr('href',linkText);link.text(linkText);var startIdx=matchUrl.index+matchUrl[1].length;result.text(text.substr(0,startIdx)).append(link).append(this._replaceMonikersRecursive(text.substr(startIdx+linkText.length)));}else if(matchEmail)
{var link=$('<a target="_blank"'+this.linkClass+this.fontCss+'/>');var linkText=matchEmail[0];linkText=linkText.substr(0,linkText.length-this._countPunctuation(linkText));link.attr('href',"mailto:"+linkText);link.text(linkText);var startIdx=matchEmail.index;result.text(text.substr(0,startIdx)).append(link).append(this._replaceMonikersRecursive(text.substr(startIdx+linkText.length)));}else
{result.text(text);}
return result;},_countPunctuation:function(text)
{var count=0;for(i=text.length-1;i>=0;i--)
{switch(text.charAt(i))
{case'.':case',':case'!':case':':case'?':isPunc=true;break;default:isPunc=false;}
if(isPunc)
{count++;}else
{break;}}
return count;}});}(jQuery));

;(function($){var WizardTabs={options:{onInit:null,onCancel:null,onWizardFinish:null,onTabSelected:null,nextButtonText:'Next',backButtonText:'Back',finishButtonText:'Done',disableBtnClass:'sf-btn-dsabld',nextButtonEnabledManually:false,onTabSwitchFinished:null,onClick:null,cicodes:null},cancelButton:null,nextButton:null,backButton:null,myCaller:null,_create:function(){this._super("_create");var $this=this;$this.element.find('div[data-title]').addClass('sf-tabs-content');require("starfield/sf.tabs",function(){$this.element.sfTabs({mode:"wizard",onTabSelected:function(self,i,tab){var currentIndex=$this._getCurrentTabIndex();var isForward=(i>currentIndex);$this._determineOnClickValues(isForward,$this.myCaller,currentIndex,i);var tabSelectedCallback=$this.options.onTabSelected;if($.isFunction(tabSelectedCallback)&&!tabSelectedCallback(i,isForward,$this.myCaller)){$this.myCaller=undefined;return false;}
$this.myCaller=undefined;if(i==0){$this.backButton.addClass($this.options.disableBtnClass);$this.nextButton.text($this.options.nextButtonText);}
else if(i==($this._getTotalTabCount()-1)){$this.nextButton.text($this.options.finishButtonText);$this.backButton.removeClass($this.options.disableBtnClass);}
else{$this.nextButton.text($this.options.nextButtonText);$this.backButton.removeClass($this.options.disableBtnClass);}
if($.isFunction($this.options.onTabSwitchFinished)){setTimeout(function(){$this.options.onTabSwitchFinished();},1000);}}});var init=$this.options.onInit;if($.isFunction(init)){init();}});$this.cancelButton=$('<a href="javascript:void(0)" />').addClass('sf-dialog-link').text('Cancel').click(function(){$this._doOnClick($this._getCurrentTabIndex(),'cancel');var cancel=$this.options.onCancel;if($.isFunction(cancel))cancel();$this.destroy();});$this.backButton=$('<a href="javascript:void(0)" />').addClass('sf-btn-primary').text($this.options.backButtonText).addClass($this.options.disableBtnClass).click(function(){$this.back('button');});$this.nextButton=$('<a href="javascript:void(0)" />').addClass('sf-btn-primary').text($this.options.nextButtonText).click(function(){$this.next('button');});$this.element.append($('<div class="sf-dialog-content" />').append($('<div class="sf-dialog-buttons sf-dialog-buttons-right" />').css('width','100%').append($this.cancelButton).append($this.backButton).append($this.nextButton)));if($this.options.nextButtonEnabledManually)
$this.enableNextButton(false);},_init:function(){},_getCurrentTabIndex:function(){return this.element.sfTabs('getSelected');},_setCurrentTabIndex:function(index,caller){this.myCaller=caller;this.element.sfTabs('select',index);},_getTotalTabCount:function(){return this.element.find('.sf-tabs-content').length;},_doOnClick:function(index,source,caller)
{this._handleCiCode(index,source,caller);if($.isFunction(this.options.onClick)){this.options.onClick(index,source,caller);}},_determineOnClickValues:function(isForward,caller,currentIndex,proposedIndex){var index=currentIndex;var source='unknown';if(!$.isPopulated(caller)){source='tab';index=proposedIndex;}
else if(caller=='button'){if(isForward)
source='next';else
source='back';}
else{source=caller;}
this._doOnClick(index,source,caller);},destroy:function(){this.element.sfTabs("destroy");this._super("destroy");},enableNextButton:function(enable){if(enable==undefined||enable){this.nextButton.removeClass(this.options.disableBtnClass);}
else{this.nextButton.addClass(this.options.disableBtnClass);}},back:function(caller){if(this.backButton.is('.'+this.options.disableBtnClass))return;this._setCurrentTabIndex(this._getCurrentTabIndex()-1,caller);},next:function(caller){if(this.nextButton.is('.'+this.options.disableBtnClass))
return;var currentIndex=this._getCurrentTabIndex();if(currentIndex==(this._getTotalTabCount()-1)){this._doOnClick(currentIndex,'done',caller);var finish=this.options.onWizardFinish;if($.isFunction(finish))finish(caller);}
else{this._setCurrentTabIndex(this._getCurrentTabIndex()+1,caller);}},getCurrent:function(){return this._getCurrentTabIndex();},setCurrent:function(index,caller){this._setCurrentTabIndex(index,caller);},_handleCiCode:function(index,source,caller){var key='tab'+(index+1)+source;this.logCicodeEvent(key);}}
$.widget("cygnus.wizardTabs",$.cygnus.uiBaseWidget,WizardTabs);})(jQuery);


if(typeof(gd)=="undefined")gd={};if(!gd.rpc){gd.rpc=(function()
{var $this=this;var handler=function(event)
{try
{var message=JSON.parse(event.data);gd.rpc.handleMessage(message.command,message.args,event);}
catch(ex)
{}};if(window.addEventListener)
{addEventListener("message",handler,false);}else if(window.attachEvent)
{window.attachEvent('onmessage',handler);}
return{_handlers:{},addMessageListener:function(command,handler)
{if(!this._handlers[command])
{this._handlers[command]=[];}
this._handlers[command].push(handler);},removeMessageListener:function(command,handler)
{if(handler)
{var handlers=this._handlers[command]||[];for(var i=0;i<handlers.length;i++)
{if(handlers[i]==handler)
{this._handlers[command]=handlers.splice(i,1);break;}}}else
{this._handlers[command]=[];}},sendMessage:function(targetWindow,targetOrigin,command,args)
{if(targetWindow.postMessage)
{targetWindow.postMessage(JSON.stringify({command:command,args:args||{}}),targetOrigin);}else if(targetOrigin&&targetOrigin!='*')
{var targetWindowName;var iframes=document.getElementsByTagName("iframe");for(var i=0;i<iframes.length;i++)
{if(iframes[i].src&&iframes[i].src==targetOrigin)
{targetWindowName=iframes[i].name;break;}}
if(!targetWindowName)
{try
{targetWindowName=targetWindow.name;}catch(err){targetWindowName=''}}
var rpcSrc=targetOrigin.substr(0,targetOrigin.lastIndexOf('/'))+'/WindowRPC.ashx'+'?t='+encodeURIComponent(targetWindowName)+'&o='+encodeURIComponent(window.location)+'&c='+encodeURIComponent(command);if(args)
{var MaxUrlLength=2083;var argsJsonString=encodeURIComponent(JSON.stringify(args));var needSplit=((rpcSrc+'&a='+argsJsonString).length>MaxUrlLength);if(!needSplit)
{rpcSrc+='&a='+argsJsonString;var frame=document.createElement('iframe');frame.setAttribute('style','width: 1px; height: 1px; text-indent: -9000px;');frame.setAttribute('src',rpcSrc);frame.onload=function()
{document.removeChild(frame);};document.appendChild(frame);}
else
{var prefixLength=(rpcSrc+'&tt=00&ti=00&a=').toString().length;var trunkLength=MaxUrlLength-prefixLength;var trunkTotal=Math.floor(argsJsonString.length/trunkLength);if(argsJsonString.length%trunkLength>0)
trunkTotal++;for(var i=0;i<trunkTotal;i++)
{var startIndex=trunkLength*i;var endIndex=trunkLength*(i+1);var trunkArgs=(i<(trunkTotal-1))?argsJsonString.slice(startIndex,endIndex):argsJsonString.slice(startIndex);var trunkSrc=rpcSrc+'&a='+trunkArgs+'&tt='+trunkTotal+'&ti='+i;var frame=document.createElement('iframe');frame.setAttribute('style','width: 1px; height: 1px; text-indent: -9000px;');frame.setAttribute('src',trunkSrc);frame.onload=function()
{document.removeChild(frame);};document.appendChild(frame);}}}}else
{throw"Cannot send message via RPC.";}},handleMessage:function(command,args,event)
{if(this._handlers[command])
{for(var i=0;i<this._handlers[command].length;i++)
{this._handlers[command][i](args,event);}}}};})();}


if(!window.JSON)
{window.JSON={};}
(function()
{function f(n)
{return n<10?'0'+n:n;}
if(typeof Date.prototype.toJSON!=='function')
{Date.prototype.toJSON=function(key)
{return isFinite(this.valueOf())?this.getUTCFullYear()+'-'+
f(this.getUTCMonth()+1)+'-'+
f(this.getUTCDate())+'T'+
f(this.getUTCHours())+':'+
f(this.getUTCMinutes())+':'+
f(this.getUTCSeconds())+'Z':null;};String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(key)
{return this.valueOf();};}
var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string)
{escapable.lastIndex=0;return escapable.test(string)?'"'+string.replace(escapable,function(a)
{var c=meta[a];return typeof c==='string'?c:'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4);})+'"':'"'+string+'"';}
function str(key,holder)
{var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function')
{value=value.toJSON(key);}
if(typeof rep==='function')
{value=rep.call(holder,key,value);}
switch(typeof value)
{case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value)
{return'null';}
gap+=indent;partial=[];if(Object.prototype.toString.apply(value)==='[object Array]')
{length=value.length;for(i=0;i<length;i+=1)
{partial[i]=str(i,value)||'null';}
v=partial.length===0?'[]':gap?'[\n'+gap+
partial.join(',\n'+gap)+'\n'+
mind+']':'['+partial.join(',')+']';gap=mind;return v;}
if(rep&&typeof rep==='object')
{length=rep.length;for(i=0;i<length;i+=1)
{k=rep[i];if(typeof k==='string')
{v=str(k,value);if(v)
{partial.push(quote(k)+(gap?': ':':')+v);}}}}else
{for(k in value)
{if(Object.hasOwnProperty.call(value,k))
{v=str(k,value);if(v)
{partial.push(quote(k)+(gap?': ':':')+v);}}}}
v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+
mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}
if(typeof JSON.stringify!=='function')
{JSON.stringify=function(value,replacer,space)
{var i;gap='';indent='';if(typeof space==='number')
{for(i=0;i<space;i+=1)
{indent+=' ';}}else if(typeof space==='string')
{indent=space;}
rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number'))
{throw new Error('JSON.stringify');}
return str('',{'':value});};}
if(typeof JSON.parse!=='function')
{JSON.parse=function(text,reviver)
{var j;function walk(holder,key)
{var k,v,value=holder[key];if(value&&typeof value==='object')
{for(k in value)
{if(Object.hasOwnProperty.call(value,k))
{v=walk(value,k);if(v!==undefined)
{value[k]=v;}else
{delete value[k];}}}}
return reviver.call(holder,key,value);}
cx.lastIndex=0;if(cx.test(text))
{text=text.replace(cx,function(a)
{return'\\u'+
('0000'+a.charCodeAt(0).toString(16)).slice(-4);});}
if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,'')))
{j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}
throw new SyntaxError('JSON.parse');};}}());


Cygnus.Data = {
  "Spaces": {
    "list": [
      "WST775153kpzhXDHPQ"
    ],
    "WST775153kpzhXDHPQ": {
      "Id": "WST775153kpzhXDHPQ",
      "Title": "6279febb-065c-468f-b3d6-73066a85bb1f",
      "Widgets": {
        "list": [
          "WST77515WXkcUQyJvx"
        ],
        "WST77515WXkcUQyJvx": {
          "Id": "WST77515WXkcUQyJvx",
          "ContentServiceUrl": "https://widgetservices.secureserver.net/FacebookBuilder.ashx",
          "Type": "facebook",
          "AccessMethod": "jsonp",
          "View": "normal",
          "Title": "Facebook",
          "Shown": 1,
          "Status": 0,
          "ConfigData": null,
          "Views": [
            {
              "Type": "normal",
              "Flex": false,
              "Toggle": "none",
              "IsDeleted": 0
            }
          ],
          "OAuthCallbackUrl": "https://widgetservices.secureserver.net/FacebookBuilder.ashx?action=oauth&purpose=authorize",
          "OAuthClientId": "182044135139733",
          "OAuthClientSecret": "87f6607a6e5aa12ec79a3116cdc0a8b8"
        }
      }
    }
  }
}

Cygnus.UserId='77515';Cygnus.ApplicationId='WST';Cygnus.ImageBasePath='';Cygnus.Stage.registerDependency({name:'simpleDialog'});}
if(window.$c==null||window.$c=="undefined")
{window.$c=window.Cygnus;}
}}
; var $j = jQuery; $j(document).ready( function() { start.init(); $c.Stage.loadSpace($c.Data.Spaces.list[0], $c.Data.Spaces[$c.Data.Spaces.list[0]].Title); });