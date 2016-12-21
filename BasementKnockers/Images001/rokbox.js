/**
 * RokBox - Pops up all sort of media types, html, images, videos, audio, iframes.
 * 
 * @version		1.0
 * 
 * @author		Djamil Legato <djamil@rockettheme.com>
 * @copyright	Andy Miller @ Rockettheme, LLC
 */
 
Element.extend({"show":function(){return this.setStyle("display","");},"hide":function(){return this.setStyle("display","none");}});String.extend({"sameDomain":function(){var A=/^(http|https):\/\/([a-z-.0-9]+)[\/]{0,1}/i.exec(window.location);
var B=/^(http|https):\/\/([a-z-.0-9]+)[\/]{0,1}/i.exec(this);return A[2]===B[2];}});var RokBox=new Class({version:"1.0-beta",options:{"className":"rokbox","theme":"default","transition":Fx.Transitions.Quad.easeOut,"duration":200,"chase":40,"effect":"quicksilver","captions":true,"captionsDelay":800,"scrolling":false,"keyEvents":true,overlay:{"background":"#000","opacity":0.85,"zIndex":65550,"duration":200,"transition":Fx.Transitions.Quad.easeInOut},"frame-border":0,"content-padding":0,"arrows-height":50,defaultSize:{"width":640,"height":460},"autoplay":"true","controller":"false","bgcolor":"#f3f3f3","youtubeAutoplay":false,"vimeoColor":"00adef","vimeoPortrait":false,"vimeoTitle":false,"vimeoFullScreen":true,"vimeoByline":false},initialize:function(M){this.setOptions(M);
var H=new RegExp("^"+this.options.className),L=this.options.className,K=this;this.current=[];this.groups=new Hash({});this.changeGroup=false;this.swtch=false;
this.elements=$$("a").filter(function(S){var P=S.getProperty("rel"),Q=false,O=false;var R=(P||"").test(H);if(R){if(P){Q=P.match(/\([a-z0-9]+\)/g)||false;
}if(Q[0]){Q=Q[0].replace("(","").replace(")","");if(!this.groups.hasKey(Q)){this.groups.set(Q,[]);}var N=this.groups.get(Q);N.push(S);O=N.length;this.groups.set(Q,N);
}S.group=Q;S.idx=O;S.addEvent("click",this.click.bindWithEvent(S,[S.title,S.href,S.rel,this]));}return R;}.bind(this));var C=$merge(this.options.overlay,{"id":L+"-overlay","class":L+"-overlay"});
this.overlayObj=new Rokverlay(false,C).addEvent("onShow",function(){K.open(K.current);}).addEvent("onHide",function(){if(K.changeGroup){K.changeGroup=false;
var R=K.nextGroup[0],O=K.nextGroup[1],P=K.nextGroup[2],N=K.nextGroup[3],Q;if(O.getProperty("id").test("next")){Q=P[N];}else{Q=P[N-2];}K.click.delay(100,K,[false,Q.title,Q.href,Q.rel,K,Q]);
}});this.overlay=this.overlayObj.overlay.addEvent("click",function(){K.swtch=false;K.close();});this.wrapper=new Element("div",{"id":L+"-wrapper","class":L+"-"+this.options.theme}).inject(document.body).setStyles({"position":"absolute","zIndex":65555,"opacity":0}).hide();
var F=new Element("div",{"id":L+"-top","class":L+"-left"}).inject(this.wrapper);var G=new Element("div",{"class":L+"-right"}).inject(F);var B=new Element("div",{"class":L+"-center"}).inject(G);
var A=new Element("div",{"id":L+"-middle","class":L+"-left"}).inject(this.wrapper);var E=new Element("div",{"class":L+"-right"}).inject(A);this.center=new Element("div",{"class":L+"-center"}).inject(E);
var D=new Element("div",{"id":L+"-bottom","class":L+"-left"}).inject(this.wrapper);var I=new Element("div",{"class":L+"-right"}).inject(D);var J=new Element("div",{"class":L+"-center"}).inject(I);
new Element("div",{"class":"clr"}).inject(this.wrapper);this.closeButton=new Element("a",{"id":L+"-close","href":"#"}).setHTML("<span>[x] close</span>").inject(this.center);
this.closeButton.addEvent("click",function(N){new Event(N).stop();K.swtch=false;K.close(N);});this.fx={"wrapper":new Fx.Styles(this.wrapper,{"duration":this.options.duration,wait:true,"transition":this.options.transition,onComplete:function(){if(K.type=="image"){return ;
}if(!this.now.opacity&&K.overlayObj.open){K.wrapper.hide();if(!K.swtch){K.overlayObj.hide();}else{if(K.changeGroup){K.changeGroup=false;var R=K.nextGroup[0],O=K.nextGroup[1],P=K.nextGroup[2],N=K.nextGroup[3],Q;
if(O.getProperty("id").test("next")){Q=P[N];}else{Q=P[N-2];}K.click.delay(100,K,[false,Q.title,Q.href,Q.rel,K,Q]);}}}else{K.loadVideo.delay(50,K);}}}),"center":new Fx.Styles(this.center,{"duration":this.options.duration,wait:true,"transition":this.options.transition}),"height":new Fx.Style(this.center,"height",{"duration":this.options.duration,wait:true,"transition":this.options.transition})};
window.addEvent("resize",function(){K.reposition(K.wrapper);K.overlayObj.reposition();});if(this.options.scrolling){window.addEvent("scroll",function(){K.reposition(K.wrapper);
});}},click:function(E,G,A,J,I,F){if(E){new Event(E).stop();}var C=J.match(/([0-9]+\s?[0-9]+)/g)||[""];C=C[0].split(" ");var B=I.overflow();if(!F){F=false;
}var H=this.group||F.group;var D=I.closeButton.getStyle("height").toInt()||I.closeButton.getSize().size.y||0;J={width:(C[0]||I.options.defaultSize.width).toInt(),height:(C[1]||I.options.defaultSize.height).toInt()};
options2={width:(C[0]||I.options.defaultSize.width).toInt()+I.overflow(true),height:(C[1]||I.options.defaultSize.height).toInt()+I.overflow()+D};I.current=[this,G,A,J,H,this.idx||F.idx,options2];
if(!I.swtch){I.overlayObj.toggle();}else{I.open(I.current);}},overflow:function(B){var A=(this.options["frame-border"]*2)+(this.options["content-padding"]*2);
return A;},open:function(){arguments=arguments[0];var H=arguments;var B=arguments[0],I=arguments[1],A=arguments[2],K=arguments[3],L=arguments[6],J=this;
var G=J.closeButton.getStyle("height").toInt()||J.closeButton.getSize().size.y||0;var C=J.options["arrows-height"]||0;this.wrapper.setStyles({"width":L.width,"height":L.height+C+G}).show();
this.center.setStyles({"width":K.width,"height":K.height+G+C});if(J.options.captions&&this.caption){this.caption.hide().setStyle("height",0);}if(J.container){J.container.empty();
}var E=this.reposition(this.wrapper,L)[1];this.fx.wrapper.start(this.effects(this.options.effect,E).start).chain(function(){if(J.options.captions){(function(){var N=J.caption.getSize().size.y;
var M=J.center.getStyle("height").toInt();J.fx.height.start(M+N-C).chain(function(){J.caption.effect("opacity").start(1);if(J.options.keyEvents){J.evt=J.keyEvents.bindWithEvent(J.keyEvents);
window.addEvent("keypress",J.evt);}});}).delay(J.options.captionsDelay);}});var D=K.height+G+C;var F=this.effects(this.options.effect,E).start;if(F.width||F.height){this.fx.center.start({"width":($type(F.width)=="array")?[0,K.width]:K.width,"height":($type(F.height)=="array")?[0,D]:D});
}else{this.center.setStyles({"width":K.width,"height":D});}},close:function(E,F){var B=this,D;var A={"left":this.wrapper.getStyle("left").toInt(),"top":this.wrapper.getStyle("top").toInt()};
this.container.removeClass("spinner");this.unloadVideo();D=this.effects((F)?F:this.options.effect,A).end;if(this.options.captions){this.caption.effect("opacity").set(0);
}if(this.options.keyEvents){window.removeEvent("keypress",B.evt);}if(this.arrows){this.arrows.remove();}this.arrows=false;var C={};if($chk(D.width)){C.width=(D.width-B.overflow());
}if($chk(D.height)){C.height=D.height;}this.fx.center.start(C).chain(function(){B.fx.height.stop();if(B.caption){B.caption.setStyle("height","");}B.center.setStyles({"width":"","height":""});
B.container.setStyles({"width":"","height":""});});this.fx.wrapper.start(D);return this;},keyEvents:function(A){new Event(A);switch(A.key){case"left":if(this.arrows){this.prevArrow.fireEvent("click",A);
}break;case"right":if(this.arrows){this.nextArrow.fireEvent("click",A);}break;case"esc":this.close(A,"growl");break;}},reposition:function(F,D){var B=window.getSize();
if(!F){F=$(this.wrapper);}if(!D){var C=F.getSize().size;D={"width":C.x,"height":C.y};}var E=this.options["arrows-height"];var A={"top":B.scroll.y+(B.size.y/2)-(D.height/2)-F.getStyle("padding-top").toInt()-(E/2),"left":B.scroll.x+(B.size.x/2)-(D.width/2)-F.getStyle("padding-left").toInt()};
return[F.setStyles(A),A];},loadVideo:function(){if(this.container){this.container.remove();}if(this.caption){this.caption.hide();}var M=this.current[1],A=this.current[2],O=this.current[3],K=this.current[4],E=this.current[5],N=this.options.className;
var D=this.closeButton.getStyle("height").toInt()||this.closeButton.getSize().size.y||0;var B=this.options["arrows-height"]||0;this.type=false;if(A.match(/\.(gif|jpg|jpeg|png|bmp)$/i)||this.current[0].alt=="image"){this.type="image";
var L=this;this.object=new Asset.image(A,{id:"rokboxobject",onload:function(){O.width=this.width;O.height=this.height;L.container.setStyles(O);var P=this,Q=window.getSize();
var R=Q.scroll.y+(Q.size.y/2)-(this.height/2)-L.wrapper.getStyle("padding-top").toInt();if(R<0){R=0;}L.fx.wrapper.start({"left":Q.scroll.x+(Q.size.x/2)-(this.width/2)-(L.overflow(true)/2)-L.wrapper.getStyle("padding-left").toInt(),"width":this.width+L.overflow(true),"height":this.height+L.overflow()+B+D}).chain(function(){L.container.removeClass("spinner");
P.inject(L.container);});}});}else{if(A.match(/\.mov$/i)){this.type="qt";if(navigator.plugins&&navigator.plugins.length){this.object='<object id="rokboxobject" standby="loading..." type="video/quicktime" codebase="http://www.apple.com/qtactivex/qtplugin.cab" data="'+A+'" width="'+O.width+'" height="'+O.height+'"><param name="src" value="'+A+'" /><param name="scale" value="aspect" /><param name="controller" value="'+this.options.controller+'" /><param name="autoplay" value="'+this.options.autoplay+'" /><param name="bgcolor" value="'+this.options.bgcolor+'" /><param name="enablejavascript" value="true" /></object>';
}else{this.object='<object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" standby="loading..." codebase="http://www.apple.com/qtactivex/qtplugin.cab" width="'+O.width+'" height="'+O.height+'" id="rokboxobject"><param name="src" value="'+A+'" /><param name="scale" value="aspect" /><param name="controller" value="'+this.options.controller+'" /><param name="autoplay" value="'+this.options.autoplay+'" /><param name="bgcolor" value="'+this.options.bgcolor+'" /><param name="enablejavascript" value="true" /></object>';
}}else{if(A.match(/\.wmv/i)){this.type="wmv";if(navigator.plugins&&navigator.plugins.length){this.object='<object id="rokboxobject" standby="loading..." type="video/x-ms-wmv" data="'+A+'" width="'+O.width+'" height="'+O.height+'" /><param name="src" value="'+A+'" /><param name="autoStart" value="'+this.options.autoplay+'" /></object>';
}else{this.object='<object id="rokboxobject" standby="loading..." classid="CLSID:22D6f312-B0F6-11D0-94AB-0080C74C7E95" type="video/x-ms-wmv" data="'+A+'" width="'+O.width+'" height="'+O.height+'" /><param name="filename" value="'+A+'" /><param name="showcontrols" value="'+this.options.controller+'"><param name="autoStart" value="'+this.options.autoplay+'" /><param name="stretchToFit" value="true" /></object>';
}}else{if(A.match(/youtube\.com\/watch/i)){this.type="flash";var H=A.split("=");this.videoID=H[1];this.options.youtubeAutoplay=(this.options.youtubeAutoplay)?1:0;
this.object=new SWFObject("http://www.youtube.com/v/"+this.videoID+"&autoplay="+this.options.youtubeAutoplay,"rokboxobject",O.width,O.height,"9",this.options.bgcolor,"wmode","transparent");
this.object.addParam("allowscriptaccess","always");this.object.addParam("allowfullscreen","true");}else{if(A.match(/dailymotion\./i)){this.type="flash";
var H=A.split("_")[0].split("/");this.videoId=H[H.length-1];this.object=new SWFObject("http://www.dailymotion.com/swf/"+this.videoId+"&v3=1&colors=background:DDDDDD;glow:FFFFFF;foreground:333333;special:FFC300;&autoPlay=1&related=0","rokboxobject",O.width,O.height,"9",this.options.bgcolor);
this.object.addParam("allowscriptaccess","always");this.object.addParam("allowfullscreen","true");}else{if(A.match(/metacafe\.com\/watch/i)){this.type="flash";
var H=A.split("/");this.videoID=H[4];this.object=new SWFObject("http://www.metacafe.com/fplayer/"+this.videoID+"/.swf","rokboxobject",O.width,O.height,"9",this.options.bgcolor,"wmode","transparent");
this.object.addParam("allowscriptaccess","always");this.object.addParam("allowfullscreen","true");}else{if(A.match(/google\.com\/videoplay/i)){this.type="flash";
var H=A.split("=");this.videoID=H[1];this.object=new SWFObject("http://video.google.com/googleplayer.swf?docId="+this.videoID+"&autoplay=1&hl=en","rokboxobject",O.width,O.height,"9",this.options.bgcolor,"wmode","transparent");
this.object.addParam("allowscriptaccess","always");this.object.addParam("allowfullscreen","true");}else{if(A.match(/vimeo\.com\/[0-9]{1,}/i)){this.type="flash";
var H=A.split("/");this.videoID=H[3];this.options.vimeoFullScreen=(this.options.vimeoFullScreen)?1:0;this.options.vimeoTitle=(this.options.vimeoTitle)?1:0;
this.options.vimeoByline=(this.options.vimeoByline)?1:0;this.options.vimeoPortrait=(this.options.vimeoPortrait)?1:0;this.options.vimeoColor=(this.options.vimeoColor.match(/[0-9]{6}/))?this.options.vimeoColor:"00adef";
this.object=new SWFObject("http://www.vimeo.com/moogaloop.swf?clip_id="+this.videoID+"&amp;server=www.vimeo.com&amp;fullscreen="+this.options.vimeoFullScreen+"&amp;show_title="+this.options.vimeoTitle+"&amp;show_byline="+this.options.vimeoByline+"&amp;show_portrait="+this.options.vimeoPortrait+"&amp;color="+this.options.vimeoColor+"","rokboxobject",O.width,O.height,"9",this.options.bgcolor);
this.object.addParam("allowscriptaccess","always");this.object.addParam("allowfullscreen","true");}else{if(A.match(/\.swf/i)){this.type="flash";this.object=new SWFObject(A,"rokboxobject",O.width,O.height,"9",this.options.bgcolor,"wmode","transparent");
this.object.addParam("allowscriptaccess","always");this.object.addParam("allowfullscreen","true");}else{if(A.match(/\.mp3$/i)){this.type="audio";this.object='<object id="rokboxobject"" width="'+O.width+'" height="'+O.height+'" data="'+A+'"" type="'+((window.ie)?"application/x-mplayer2":"audio/mpeg")+'"><param value="'+A+'" name="src"/><param value="'+A+'" name="filename"/><param value="'+((window.ie)?"application/x-mplayer2":"audio/mpeg")+'" name="type"/><p>No plugin matched for playing: '+A+"</p></object>";
}else{if(A.match(/\.wav$/i)){this.type="audio";this.object='<object id="rokboxobject"" width="'+O.width+'" height="'+O.height+'" data="'+A+'"" type="'+((window.ie)?"application/x-mplayer2":"audio/wav")+'"><param value="'+A+'" name="src"/><param value="'+A+'" name="filename"/><param value="'+((window.ie)?"application/x-mplayer2":"audio/wav")+'" name="type"/><p>No plugin matched for playing: '+A+"</p></object>";
}else{if(A.sameDomain()&&A.match(/\.(html|php|xhtml|php3|php4|php5|shtml|asp|aspx)$/i)){this.type="html";this.object=new Element("div",{"id":"rokboxobject","class":"html"}).setStyles({"width":O.width,"height":O.height,"overflow":"auto"});
}else{if(!A.sameDomain()){this.type="iframe";var C="rokboxobject"+$time()+$random(0,100);this.object=new Element("iframe").setProperties({id:C,width:O.width,height:O.height,frameBorder:0,scrolling:"auto",src:A});
var L=this;this.object.onload=function(){L.container.removeClass("spinner");};}}}}}}}}}}}}}this.movie=$("rokboxobject");if(this.type){this.container=new Element("div",{"id":N+"-container","class":N+"-container"}).addClass("spinner").setStyles(O).injectInside(this.center);
if(this.type=="flash"){this.object.write(this.container);}else{if(this.type=="html"){this.object.inject(this.container);new Ajax(A,{"update":this.object,onComplete:function(){this.container.removeClass("spinner");
}.bind(this)}).request();}else{if(this.type=="iframe"){this.object.inject(this.container);}else{if(this.type!="image"){this.container.setHTML(this.object).removeClass("spinner");
}}}}if(K){var F=this.groups.get(K),L=this;if(F.length>1){if(!this.arrows){this.arrows=new Element("div",{"id":this.options.className+"-arrows"}).inject(this.center).hide();
if(E!=1){this.prevArrow=new Element("a",{"id":this.options.className+"-previous"}).inject(this.arrows).setHTML("<span>&lt; previous</span>");this.prevArrow.setProperties({"href":F[E-2].getProperty("href"),"title":F[E-2].getProperty("title")});
}if(E!=F.length){this.nextArrow=new Element("a",{"id":this.options.className+"-next"}).inject(this.arrows).setHTML("<span>next &gt;</span>");this.nextArrow.setProperties({"href":F[E].getProperty("href"),"title":F[E].getProperty("title")});
}if(E==1){this.prevArrow=new Element("a",{"id":this.options.className+"-previous","class":"inactive","href":"#"}).inject(this.arrows,"top").setHTML("<span>&lt; previous</span>");
}if(E==F.length){this.nextArrow=new Element("a",{"id":this.options.className+"-next","class":"inactive","href":"#"}).inject(this.arrows).setHTML("<span>next &gt;</span>");
}this.prevArrow.addEvent("click",function(P){P=new Event(P).stop();if(!this.hasClass("inactive")){L.changeGroup=true;L.nextGroup=[P,this,F,E];L.swtch=true;
L.close(P,"growl");}});this.nextArrow.addEvent("click",function(P){P=new Event(P).stop();if(!this.hasClass("inactive")){L.changeGroup=true;L.nextGroup=[P,this,F,E];
L.swtch=true;L.close(P,"growl");}});}this.arrows.show();}}if(this.options.captions){var G=this.getCaption(M)||[false,false];var I=G[0],J=G[1];if(this.caption){this.caption.empty().remove();
}this.caption=new Element("div",{"id":this.options.className+"-caption"}).inject(this.center).setStyle("opacity",0).adopt(I,J);}}},unloadVideo:function(){if(this.type){this.container.innerHTML="";
}this.movie=null;this.type=false;},getCaption:function(A){A=A.split(" :: ")||false;switch(A.length){case 0:return false;break;case 1:var C=false;var B=new Element("p").setText(A[0]);
break;case 2:var C=new Element("h2").setText(A[0]);var B=new Element("p").setText(A[1]);break;}return[C,B];},getGroup:function(B){var A=B.getProperty("rel"),C=false;
if(A){C=A.match(/\([a-z0-9]+\)/g)||false;}if(C[0]){C=C[0].replace("(","").replace(")","");}else{C=false;}return C;}});RokBox.implement(new Options,new Chain);
var Rokverlay=new Class({options:{"id":false,"class":false,"background":"#000000","opacity":0.7,"zIndex":65555,"duration":200,"transition":Fx.Transitions.Quad.easeInOut},initialize:function(B,A){this.where=$(B)||$(document.body);
this.setOptions(A);this.overlay=new Element("div",{"id":this.options.id||("rokverlay-"+$random(1,1000)),"class":this.options.id||("rokverlay-"+$random(1,1000)),"styles":{"opacity":0,"display":"none","position":"absolute","top":0,"left":0,"cursor":"pointer","background-color":this.options.background,"z-index":this.options.zIndex}}).inject(document.body);
this.fx=new Fx.Style(this.overlay,"opacity",{duration:this.options.duration,transition:this.options.transition});this.open=false;return this;},reposition:function(B){var A=this.where;
B=B||window.getSize().scrollSize;this.overlay.setStyles({top:A.getPosition().y||0,left:A.getPosition().x||0,width:window.getSize().size.x,height:B.y});
return this;},show:function(){var B=this.overlay,A=this;this.overlay.setStyle("display","");this.open=true;this.reposition().fx.start(this.options.opacity).chain(function(){A.fireEvent("onShow",B);
});return this;},hide:function(){var B=this.overlay,A=this;this.open=false;this.reposition().fx.start(0).chain(function(){B.setStyle("display","none");
A.fireEvent("onHide",B);});return this;},toggle:function(){this[this.open?"hide":"show"]();return this;}});Rokverlay.implement(new Options,new Events);



/**
 * SWFObject v1.5: Flash Player detection and embed - http://blog.deconcept.com/swfobject/
 *
 * SWFObject is (c) 2007 Geoff Stearns and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */
if(typeof deconcept=="undefined"){var deconcept=new Object();}if(typeof deconcept.util=="undefined"){deconcept.util=new Object();}if(typeof deconcept.SWFObjectUtil=="undefined"){deconcept.SWFObjectUtil=new Object();}deconcept.SWFObject=function(_1,id,w,h,_5,c,_7,_8,_9,_a){if(!document.getElementById){return;}this.DETECT_KEY=_a?_a:"detectflash";this.skipDetect=deconcept.util.getRequestParameter(this.DETECT_KEY);this.params=new Object();this.variables=new Object();this.attributes=new Array();if(_1){this.setAttribute("swf",_1);}if(id){this.setAttribute("id",id);}if(w){this.setAttribute("width",w);}if(h){this.setAttribute("height",h);}if(_5){this.setAttribute("version",new deconcept.PlayerVersion(_5.toString().split(".")));}this.installedVer=deconcept.SWFObjectUtil.getPlayerVersion();if(!window.opera&&document.all&&this.installedVer.major>7){deconcept.SWFObject.doPrepUnload=true;}if(c){this.addParam("bgcolor",c);}var q=_7?_7:"high";this.addParam("quality",q);this.setAttribute("useExpressInstall",false);this.setAttribute("doExpressInstall",false);var _c=(_8)?_8:window.location;this.setAttribute("xiRedirectUrl",_c);this.setAttribute("redirectUrl","");if(_9){this.setAttribute("redirectUrl",_9);}};deconcept.SWFObject.prototype={useExpressInstall:function(_d){this.xiSWFPath=!_d?"expressinstall.swf":_d;this.setAttribute("useExpressInstall",true);},setAttribute:function(_e,_f){this.attributes[_e]=_f;},getAttribute:function(_10){return this.attributes[_10];},addParam:function(_11,_12){this.params[_11]=_12;},getParams:function(){return this.params;},addVariable:function(_13,_14){this.variables[_13]=_14;},getVariable:function(_15){return this.variables[_15];},getVariables:function(){return this.variables;},getVariablePairs:function(){var _16=new Array();var key;var _18=this.getVariables();for(key in _18){_16[_16.length]=key+"="+_18[key];}return _16;},getSWFHTML:function(){var _19="";if(navigator.plugins&&navigator.mimeTypes&&navigator.mimeTypes.length){if(this.getAttribute("doExpressInstall")){this.addVariable("MMplayerType","PlugIn");this.setAttribute("swf",this.xiSWFPath);}_19="<embed type=\"application/x-shockwave-flash\" src=\""+this.getAttribute("swf")+"\" width=\""+this.getAttribute("width")+"\" height=\""+this.getAttribute("height")+"\" style=\""+this.getAttribute("style")+"\"";_19+=" id=\""+this.getAttribute("id")+"\" name=\""+this.getAttribute("id")+"\" ";var _1a=this.getParams();for(var key in _1a){_19+=[key]+"=\""+_1a[key]+"\" ";}var _1c=this.getVariablePairs().join("&");if(_1c.length>0){_19+="flashvars=\""+_1c+"\"";}_19+="/>";}else{if(this.getAttribute("doExpressInstall")){this.addVariable("MMplayerType","ActiveX");this.setAttribute("swf",this.xiSWFPath);}_19="<object id=\""+this.getAttribute("id")+"\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\""+this.getAttribute("width")+"\" height=\""+this.getAttribute("height")+"\" style=\""+this.getAttribute("style")+"\">";_19+="<param name=\"movie\" value=\""+this.getAttribute("swf")+"\" />";var _1d=this.getParams();for(var key in _1d){_19+="<param name=\""+key+"\" value=\""+_1d[key]+"\" />";}var _1f=this.getVariablePairs().join("&");if(_1f.length>0){_19+="<param name=\"flashvars\" value=\""+_1f+"\" />";}_19+="</object>";}return _19;},write:function(_20){if(this.getAttribute("useExpressInstall")){var _21=new deconcept.PlayerVersion([6,0,65]);if(this.installedVer.versionIsValid(_21)&&!this.installedVer.versionIsValid(this.getAttribute("version"))){this.setAttribute("doExpressInstall",true);this.addVariable("MMredirectURL",escape(this.getAttribute("xiRedirectUrl")));document.title=document.title.slice(0,47)+" - Flash Player Installation";this.addVariable("MMdoctitle",document.title);}}if(this.skipDetect||this.getAttribute("doExpressInstall")||this.installedVer.versionIsValid(this.getAttribute("version"))){var n=(typeof _20=="string")?document.getElementById(_20):_20;n.innerHTML=this.getSWFHTML();return true;}else{if(this.getAttribute("redirectUrl")!=""){document.location.replace(this.getAttribute("redirectUrl"));}}return false;}};deconcept.SWFObjectUtil.getPlayerVersion=function(){var _23=new deconcept.PlayerVersion([0,0,0]);if(navigator.plugins&&navigator.mimeTypes.length){var x=navigator.plugins["Shockwave Flash"];if(x&&x.description){_23=new deconcept.PlayerVersion(x.description.replace(/([a-zA-Z]|\s)+/,"").replace(/(\s+r|\s+b[0-9]+)/,".").split("."));}}else{if(navigator.userAgent&&navigator.userAgent.indexOf("Windows CE")>=0){var axo=1;var _26=3;while(axo){try{_26++;axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash."+_26);_23=new deconcept.PlayerVersion([_26,0,0]);}catch(e){axo=null;}}}else{try{var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");}catch(e){try{var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");_23=new deconcept.PlayerVersion([6,0,21]);axo.AllowScriptAccess="always";}catch(e){if(_23.major==6){return _23;}}try{axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");}catch(e){}}if(axo!=null){_23=new deconcept.PlayerVersion(axo.GetVariable("$version").split(" ")[1].split(","));}}}return _23;};deconcept.PlayerVersion=function(_29){this.major=_29[0]!=null?parseInt(_29[0], 10):0;this.minor=_29[1]!=null?parseInt(_29[1], 10):0;this.rev=_29[2]!=null?parseInt(_29[2], 10):0;};deconcept.PlayerVersion.prototype.versionIsValid=function(fv){if(this.major<fv.major){return false;}if(this.major>fv.major){return true;}if(this.minor<fv.minor){return false;}if(this.minor>fv.minor){return true;}if(this.rev<fv.rev){return false;}return true;};deconcept.util={getRequestParameter:function(_2b){var q=document.location.search||document.location.hash;if(_2b==null){return q;}if(q){var _2d=q.substring(1).split("&");for(var i=0;i<_2d.length;i++){if(_2d[i].substring(0,_2d[i].indexOf("="))==_2b){return _2d[i].substring((_2d[i].indexOf("=")+1));}}}return "";}};deconcept.SWFObjectUtil.cleanupSWFs=function(){var _2f=document.getElementsByTagName("OBJECT");for(var i=_2f.length-1;i>=0;i--){_2f[i].style.display="none";for(var x in _2f[i]){if(typeof _2f[i][x]=="function"){_2f[i][x]=function(){};}}}};if(deconcept.SWFObject.doPrepUnload){if(!deconcept.unloadSet){deconcept.SWFObjectUtil.prepUnload=function(){__flash_unloadHandler=function(){};__flash_savedUnloadHandler=function(){};window.attachEvent("onunload",deconcept.SWFObjectUtil.cleanupSWFs);};window.attachEvent("onbeforeunload",deconcept.SWFObjectUtil.prepUnload);deconcept.unloadSet=true;}}if(!document.getElementById&&document.all){document.getElementById=function(id){return document.all[id];};}var getQueryParamValue=deconcept.util.getRequestParameter;var FlashObject=deconcept.SWFObject;var SWFObject=deconcept.SWFObject;


/* Effects, modify if you know what you're doing */

RokBox.implement({	
	effects: function(type, position) {
		var effect = {};
		if (!position) position = 0;
				
		switch(type) {
			case 'growl': 
				effect = {
					'start': {
						'top': [position.top - this.options.chase, position.top],
						'opacity': 1
					},
					'end': {
						'top': this.wrapper.getStyle('top').toInt() + this.options.chase,
						'opacity': 0
					}
				};
				break;
			case 'quicksilver':
				var height = this.wrapper.getStyle('height').toInt(), width = this.wrapper.getStyle('width').toInt();
				effect = {
					'start': {
						'top': [position.top + (height / 2), position.top],
						'height': [0, height],
						'opacity': 1
					},
					'end': {
						'top': position.top + (height / 2),
						'left':  window.getSize().size.x / 2 - ((window.getSize().scrollSize.x - 10) / 2),
						'width': window.getSize().scrollSize.x - 30,
						'height': 0,
						'opacity': 0
					}
				};
				break;
			case 'explode':
				var height = this.wrapper.getStyle('height').toInt(), width = this.wrapper.getStyle('width').toInt();
				effect = {
					'start': {
						'height': [0, height],
						'width': [0, width],
						'opacity': 1,
						'top': [(window.getSize().size.y / 2) + window.getSize().scroll.y, position.top],
						'left': [(window.getSize().size.x / 2) + window.getSize().scroll.x, position.left]
					},
					'end': {
						'height': 0,
						'width': 0,
						'opacity': 0,
						'top': (window.getSize().size.y / 2) + window.getSize().scroll.y,
						'left': (window.getSize().size.x / 2) + window.getSize().scroll.x
					}
				};
				break;
			
			case 'fade':
				effect = {
					'start': { 'opacity': 1	},
					'end': { 'opacity': 0 }
				};
		}
		
		return effect;
	}
});