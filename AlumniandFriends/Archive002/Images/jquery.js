/*! http://mths.be/placeholder v2.0.7 by @mathias */
(function(e,t,n){function f(e){var t={},r=/^jQuery\d+$/;n.each(e.attributes,function(e,n){if(n.specified&&!r.test(n.name)){t[n.name]=n.value}});return t}function l(e,r){var i=this,s=n(i);if(i.value==s.attr("placeholder")&&s.hasClass("placeholder")){if(s.data("placeholder-password")){s=s.hide().next().show().attr("id",s.removeAttr("id").data("placeholder-id"));if(e===true){return s[0].value=r}s.focus()}else{i.value="";s.removeClass("placeholder");i==t.activeElement&&i.select()}}}function c(){var e,t=this,r=n(t),i=r,s=this.id;if(t.value==""){if(t.type=="password"){if(!r.data("placeholder-textinput")){try{e=r.clone().attr({type:"text"})}catch(o){e=n("<input>").attr(n.extend(f(this),{type:"text"}))}e.removeAttr("name").data({"placeholder-password":true,"placeholder-id":s}).bind("focus.placeholder",l);r.data({"placeholder-textinput":e,"placeholder-id":s}).before(e)}r=r.removeAttr("id").hide().prev().attr("id",s).show()}r.addClass("placeholder");r[0].value=r.attr("placeholder")}else{r.removeClass("placeholder")}}var r="placeholder"in t.createElement("input"),i="placeholder"in t.createElement("textarea"),s=n.fn,o=n.valHooks,u,a;if(r&&i){a=s.placeholder=function(){return this};a.input=a.textarea=true}else{a=s.placeholder=function(){var e=this;e.filter((r?"textarea":":input")+"[placeholder]").not(".placeholder").bind({"focus.placeholder":l,"blur.placeholder":c}).data("placeholder-enabled",true).trigger("blur.placeholder");return e};a.input=r;a.textarea=i;u={get:function(e){var t=n(e);return t.data("placeholder-enabled")&&t.hasClass("placeholder")?"":e.value},set:function(e,r){var i=n(e);if(!i.data("placeholder-enabled")){return e.value=r}if(r==""){e.value=r;if(e!=t.activeElement){c.call(e)}}else if(i.hasClass("placeholder")){l.call(e,true,r)||(e.value=r)}else{e.value=r}return i}};r||(o.input=u);i||(o.textarea=u);n(function(){n(t).delegate("form","submit.placeholder",function(){var e=n(".placeholder",this).each(l);setTimeout(function(){n(this).each(c)},10)})});n(e).bind("beforeunload.placeholder",function(){n(".placeholder").each(function(){this.value=""})})}})(this,document,jQuery)