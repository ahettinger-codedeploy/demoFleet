/* Copyright  2007 - 2010 YOOtheme GmbH, YOOtheme Proprietary Use License (http://www.yootheme.com/license) */

Warp.AccordionMenu=new Class({initialize:function(a,c,d){this.setOptions({accordion:"default",onActive:function(b){b.addClass("active");b.getFirst().addClass("active")},onBackground:function(b){b.removeClass("active");b.getFirst().removeClass("active")}},d);this.togs=a;this.elms=c;switch(this.options.accordion){case "slide":this.createSlide();break;default:this.createDefault()}},createDefault:function(){var a={};if(!$defined(this.options.display)&&!$defined(this.options.show))a={show:-1};$ES(this.togs).each(function(c,
d){if(c.hasClass("active"))a={show:d}}.bind(this));new Fx.Accordion(this.togs,this.elms,$extend(this.options,a))},createSlide:function(){$ES(this.togs).each(function(a,c){var d=a.getElement("span"),b=a.getElement(this.elms),e=new Fx.Slide(b,{transition:Fx.Transitions.linear,duration:250});a.hasClass("active")||this.options.display=="all"||this.options.display==c||e.hide();d.addEvent("click",function(){e.toggle().chain(function(){a.toggleClass("active");a.getFirst().toggleClass("active")})})}.bind(this))}});
Warp.AccordionMenu.implement(new Options); 
