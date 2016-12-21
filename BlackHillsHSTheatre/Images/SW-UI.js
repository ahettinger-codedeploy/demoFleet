//detailoverlay
//(function(c){c.fn.detailoverlay=function(m){c.extend({},c.fn.detailoverlay.defaults,m);return this.each(function(){function n(){b.appendTo("body");var c=a.offset();switch(a.attr("position")){case "left":var e=b.outerWidth?b.outerWidth():b.width();b.css({top:c.top+"px",left:c.left-e+"px"});break;case "right":var d=a.outerWidth?a.outerWidth():a.width();b.css({top:c.top+"px",left:c.left+d+"px"});break;case "bottomleft":var e=b.outerWidth?b.outerWidth():b.width(),d=a.outerWidth?a.outerWidth():a.width(), h=a.outerHeight?a.outerHeight():a.height();b.css({top:parseInt(c.top+h)+"px",left:parseInt(c.left+d)-e+"px"});break;case "bottom":h=a.outerHeight?a.outerHeight():a.height();b.css({top:parseInt(c.top+h)+"px",left:c.left+"px"});break;case "top":h=a.outerHeight?a.outerHeight():a.height(),b.css({top:parseInt(c.top-h)-k+"px",left:c.left+"px"})}}var a=c(this),b=c("#"+a.attr("targetDivID"));b.addClass("ui-detail-overlay-panel");var e=a.attr("actionClass");e===void 0&&(e="none");var i=a.attr("targetDivJS"); i===void 0&&(i="");var l=a.attr("onCloseJS");l===void 0&&(l="");var d=a.attr("isAbsolute");d===void 0&&(d="false");d=a.attr("position");d===void 0&&(d="left");var f="";if(d=="top"||d=="bottom"||d=="bottomleft")f="height";else if(d=="left"||d=="right")f="width";var m=b.width(),k=b.height();b.attr("id").indexOf("iconuploader")>=0&&(k=50);b.attr("id").indexOf("imageuploader")>=0&&(k=50);if(a.attr("actionType")=="hover"){a.unbind();var g,j;a.hover(function(){n();clearTimeout(g);b.is(":hidden")&&eval(i); j=setTimeout(function(){a.addClass(e);b.fadeIn()},200)},function(){clearTimeout(j);g=setTimeout(function(){a.removeClass(e);b.fadeOut()},200)});b.hover(function(){clearTimeout(g)},function(){g=setTimeout(function(){a.removeClass(e);b.fadeOut()},200)})}else a.unbind("click"),a.click(function(d){function g(b){var d=b.data.div,b=c(b.target);if(b.is("'#"+d.attr("id")+"'")||b.parents().is("'#"+d.attr("id")+"'"))c(document).one("click",{div:d},g);else j(a,d)}function j(b,a){a.is(":visible")&&(f=="width"? a.animate({width:"0"},"fast",function(){a.hide("fast",function(){eval(l)})}):f=="height"&&a.animate({height:"0"},"fast",function(){a.hide("fast",function(){eval(l)})}));b.removeClass(e)}n();d.preventDefault();if(c(this).hasClass(e))return j(a,b),a.removeClass(e),!1;c(".ui-detail-overlay").each(function(){c(this).hasClass(e)&&(c("#"+c(this).attr("targetDivID")).hide(),eval(c(this).attr("onCloseJS")),c(this).removeClass(e))});a.addClass(e);f=="width"?b.css({width:"0"}):f=="height"&&b.css({height:"0"}); f=="width"?b.animate({width:m+"px"},"fast",function(){eval(i);c(document).one("click",{div:b},g);b.show()}):f=="height"&&b.animate({height:k+"px"},"fast",function(){eval(i);c(document).one("click",{div:b},g);b.show()});return!1})})};c.fn.canceldetailoverlay=function(){return this.each(function(){c(this).unbind("mouseleave");c(this).addClass("active")})};c.fn.detailoverlay.defaults={actionType:""}})(jQuery);

(function ($) { $.fn.detailoverlay = function (options) { var opts = $.extend({}, $.fn.detailoverlay.defaults, options); return this.each(function () { function PositionDiv() { $div.appendTo("body"); var t = $button.offset(); switch ($button.attr("position")) { case "left": var i = $div.outerWidth ? $div.outerWidth() : $div.width(); $div.css({ top: t.top + "px", left: t.left - i + "px" }); break; case "right": var o = $button.outerWidth ? $button.outerWidth() : $button.width(); $div.css({ top: t.top + "px", left: t.left + o + "px" }); break; case "bottomleft": var i = $div.outerWidth ? $div.outerWidth() : $div.width(), o = $button.outerWidth ? $button.outerWidth() : $button.width(), e = $button.outerHeight ? $button.outerHeight() : $button.height(); $div.css({ top: parseInt(t.top + e) + "px", left: parseInt(t.left + o) - i + "px" }); break; case "bottom": var e = $button.outerHeight ? $button.outerHeight() : $button.height(); $div.css({ top: parseInt(t.top + e) + "px", left: t.left + "px" }); break; case "top": var e = $button.outerHeight ? $button.outerHeight() : $button.height(); $div.css({ top: parseInt(t.top - e) - height + "px", left: t.left + "px" }); break; case "topleft": var i = $div.outerWidth ? $div.outerWidth() : $div.width(), o = $button.outerWidth ? $button.outerWidth() : $button.width(), e = $button.outerHeight ? $button.outerHeight() : $button.height(), n = parseInt(t.top - e - 250) + "px", a = parseInt(t.left + o - 90) + "px"; $div.css({ top: n, left: a, display: "block" }) } } var $button = $(this), $div = $("#" + $button.attr("targetDivID")); $div.addClass("ui-detail-overlay-panel"); var actionClass = $button.attr("actionClass"); void 0 === actionClass && (actionClass = "none"); var callback = $button.attr("targetDivJS"); void 0 === callback && (callback = ""); var closeCallback = $button.attr("onCloseJS"); void 0 === closeCallback && (closeCallback = ""); var isAbsolute = $button.attr("isAbsolute"); void 0 === isAbsolute && (isAbsolute = "false"); var position = $button.attr("position"); void 0 === position && (position = "left"); var slideDirection = ""; "top" == position || "bottom" == position || "bottomleft" == position ? slideDirection = "height" : ("left" == position || "right" == position) && (slideDirection = "width"); var width = $div.width(), height = $div.height(); if ($div.attr("id").indexOf("iconuploader") >= 0 && (height = 50), $div.attr("id").indexOf("imageuploader") >= 0 && (height = 50), "hover" == $button.attr("actionType")) { $button.unbind(); var outTO, inTO; $button.hover(function (e) { PositionDiv(), clearTimeout(outTO), $div.is(":hidden") && eval(callback), inTO = setTimeout(function () { $button.addClass(actionClass), $div.fadeIn() }, 200) }, function () { clearTimeout(inTO), outTO = setTimeout(function () { $button.removeClass(actionClass), $div.fadeOut() }, 200) }), $div.hover(function () { clearTimeout(outTO) }, function () { outTO = setTimeout(function () { $button.removeClass(actionClass), $div.fadeOut() }, 200) }) } else $button.unbind("click"), $button.click(function (e) { function BindDocumentClick(t) { var i = t.data.div, o = $(t.target); o.is("'#" + i.attr("id") + "'") || o.parents().is("'#" + i.attr("id") + "'") ? $(document).one("click", { div: i }, BindDocumentClick) : ClosePanel($button, i) } function ClosePanel($button, $div) { $div.is(":visible") && ("width" == slideDirection ? $div.animate({ width: "0" }, "fast", function () { $div.hide("fast", function () { eval(closeCallback) }) }) : "height" == slideDirection && $div.animate({ height: "0" }, "fast", function () { $div.hide("fast", function () { eval(closeCallback) }) })), $button.removeClass(actionClass) } return PositionDiv(), e.preventDefault(), $(this).hasClass(actionClass) ? (ClosePanel($button, $div), $button.removeClass(actionClass), !1) : ($(".ui-detail-overlay").each(function () { $(this).hasClass(actionClass) && ($("#" + $(this).attr("targetDivID")).hide(), eval($(this).attr("onCloseJS")), $(this).removeClass(actionClass)) }), $button.addClass(actionClass), "width" == slideDirection ? $div.css({ width: "0" }) : "height" == slideDirection && $div.css({ height: "0" }), "width" == slideDirection ? $div.animate({ width: width + "px" }, "fast", function () { eval(callback), $(document).one("click", { div: $div }, BindDocumentClick), $div.show() }) : "height" == slideDirection && $div.animate({ height: height + "px" }, "fast", function () { eval(callback), $(document).one("click", { div: $div }, BindDocumentClick), $div.show() }), !1) }) }) }, $.fn.canceldetailoverlay = function () { return this.each(function () { $(this).unbind("mouseleave"), $(this).addClass("active") }) }, $.fn.detailoverlay.defaults = { actionType: "" } })(jQuery);

//detailoverlayinner
(function(c){c.fn.detailoverlayinner=function(m){c.extend({},c.fn.detailoverlayinner.defaults,m);return this.each(function(){function n(){b.appendTo("body");var c=a.offset();switch(a.attr("position")){case "left":var e=b.outerWidth?b.outerWidth():b.width();b.css({top:c.top+"px",left:c.left-e+"px"});break;case "right":var d=a.outerWidth?a.outerWidth():a.width();b.css({top:c.top+"px",left:c.left+d+"px"});break;case "bottomleft":var e=b.outerWidth?b.outerWidth():b.width(),d=a.outerWidth?a.outerWidth(): a.width(),h=a.outerHeight?a.outerHeight():a.height();b.css({top:parseInt(c.top+h)+"px",left:parseInt(c.left+d)-e+"px"});break;case "bottom":h=a.outerHeight?a.outerHeight():a.height();b.css({top:parseInt(c.top+h)+"px",left:c.left+"px"});break;case "top":h=a.outerHeight?a.outerHeight():a.height(),b.css({top:parseInt(c.top-h)-k+"px",left:c.left+"px"})}}var a=c(this),b=c("#"+a.attr("targetDivID"));b.addClass("ui-detail-overlay-panel");var e=a.attr("actionClass");e===void 0&&(e="none");var i=a.attr("targetDivJS"); i===void 0&&(i="");var l=a.attr("onCloseJS");l===void 0&&(l="");var d=a.attr("isAbsolute");d===void 0&&(d="false");d=a.attr("position");d===void 0&&(d="left");var f="";if(d=="top"||d=="bottom"||d=="bottomleft")f="height";else if(d=="left"||d=="right")f="width";var m=b.width(),k=b.height();b.attr("id").indexOf("iconuploader")>=0&&(k=50);b.attr("id").indexOf("imageuploader")>=0&&(k=50);if(a.attr("actionType")=="hover"){a.unbind();var g,j;a.hover(function(){n();clearTimeout(g);b.is(":hidden")&&eval(i); j=setTimeout(function(){a.addClass(e);b.fadeIn()},200)},function(){clearTimeout(j);g=setTimeout(function(){a.removeClass(e);b.fadeOut()},200)});b.hover(function(){clearTimeout(g)},function(){g=setTimeout(function(){a.removeClass(e);b.fadeOut()},200)})}else a.unbind("click"),a.click(function(d){function g(b){var d=b.data.div,b=c(b.target);if(b.is("'#"+d.attr("id")+"'")||b.parents().is("'#"+d.attr("id")+"'"))c(document).one("click",{div:d},g);else j(a,d)}function j(b,a){a.is(":visible")&&(f=="width"? a.animate({width:"0"},"fast",function(){a.hide("fast",function(){eval(l)})}):f=="height"&&a.animate({height:"0"},"fast",function(){a.hide("fast",function(){eval(l)})}));b.removeClass(e)}n();d.preventDefault();if(c(this).hasClass(e))return j(a,b),a.removeClass(e),!1;c(".ui-detail-overlayinner").each(function(){c(this).hasClass(e)&&(c("#"+c(this).attr("targetDivID")).hide(),eval(c(this).attr("onCloseJS")),c(this).removeClass(e))});a.addClass(e);f=="width"?b.css({width:"0"}):f=="height"&&b.css({height:"0"}); f=="width"?b.animate({width:m+"px"},"fast",function(){eval(i);c(document).one("click",{div:b},g);b.show()}):f=="height"&&b.animate({height:k+"px"},"fast",function(){eval(i);c(document).one("click",{div:b},g);b.show()});return!1})})};c.fn.canceldetailoverlayinner=function(){return this.each(function(){c(this).unbind("mouseleave");c(this).addClass("active")})};c.fn.detailoverlayinner.defaults={actionType:""}})(jQuery);

//menubutton
(function(a) { a.fn.menubutton = function(i) { function j(d) { function f(a) { a.data.menu.hide(); a.data.button.removeClass("active") } var c = a(this), e = c.attr("href").indexOf("#"), e = c.attr("href").substring(e), b = a(e), e = b.css("display") == "block", g = c.attr("positionabs") == "true" ? !0 : !1; d.preventDefault(); if (e) b.hide(), c.removeClass("active"), b.removeClass("active"); else { g && (a("body div[id=" + b.attr("id") + "]").remove(), b.appendTo("body")); a(b).has("div.ui-btn-menu-panel-detail").length === 0 && (a(b).find("ul").before('<div class="ui-btn-menu-panel-header" ></div>'), a(b).find("ul").after('<div class="ui-btn-menu-panel-footer" ></div>'), a(b).find("ul").wrap('<div class="ui-btn-menu-panel-detail" />')); a(".ui-btn-menu-panel").each(function() { a(this).is(":visible") && a(this).hide() }); a(".ui-btn-menu").each(function() { a(this).hasClass("active") && a(this).removeClass("active") }); c.addClass("active"); var d = g ? c.offset() : c.position(), e = c.outerHeight ? c.outerHeight() : c.height(), g = c.outerWidth ? c.outerWidth() : c.width(), h = c.attr("position"); h === void 0 && (h = "right"); g = h == "right" ? g - 140 : 0; b.addClass("active"); b.css({ top: d.top + e + "px", left: d.left + g + "px" }); b.click(function(a) { a.stopPropagation() }); b.show(1, function() { a(document).one("click", { button: c, menu: b }, f); b.find("a").bind("click", { button: c, menu: b }, f) }); b.show() } return !1 } a.extend({}, a.fn.menubutton.defaults, i); return this.each(function() { var d = a(this), f = d.attr("href").indexOf("#"), f = d.attr("href").substring(f); a(f).addClass("ui-btn-menu-panel"); d.attr("isBound") === void 0 && d.bind("click", j); d.attr("isBound", "true") }) }; a.fn.menubutton.defaults = { buttonType: ""} })(jQuery);

//validate
(function (c) {
    c.fn.validate = function (n) {
        var f = c.extend({}, c.fn.validate.defaults, n); c(".error-validation").remove(); var l = !1, g = "", h = 100; return this.each(function () {
            function k(b) {
                var e = b.attr("validationtype"), a = jQuery.trim(b.val()); switch (e) {
                    case "numeric": e = /^[0-9]+$/; "" === a || a.match(e) || d(b); break; case "range": var e = /^[0-9]+$/, f = void 0 === b.attr("min") ? 0 : b.attr("min"), g = void 0 === b.attr("max") ? Infinity : b.attr("max"); "" !== a && (parseInt(f) > a || parseInt(g) < a || !a.match(e)) && d(b); break; case "date": case "datetime": "" !==
                    a && ("datetime" == e && "false" == c("#" + b.attr("id") + "-date").attr("isValidDate") ? d(b) : "false" == b.attr("isValidDate") ? d(b) : ("" != b.attr("max") && void 0 !== b.attr("max") && (e = new Date(a), f = "#" != b.attr("max").substring(0, 1) ? new Date(b.attr("max")) : new Date(c(b.attr("max")).val()), e > f && d(b)), "" != b.attr("min") && void 0 !== b.attr("min") && (e = new Date(a), a = "#" != b.attr("min").substring(0, 1) ? new Date(b.attr("min")) : new Date(c(b.attr("min")).val()), e < a && d(b)))); break; case "email": "" !== a && (-1 == a.indexOf("@") || -1 == a.indexOf(".") ||
                    a.indexOf("@") > a.lastIndexOf(".") ? d(b) : "" == a.substring(0, a.indexOf("@")) || "" == c.trim(a.substring(a.indexOf("@") + 1, a.lastIndexOf("."))) || "" == c.trim(a.substring(a.lastIndexOf(".") + 1)) ? d(b) : "@@" == a.substring(a.indexOf("@"), a.indexOf("@") + 2) || ".." == a.substring(a.lastIndexOf(".") + 1, a.lastIndexOf(".") - 1) ? d(b) : -1 < a.indexOf(" ") && d(b)); break; case "url": a = a.split(";"); c.each(a, function () {
                        var a = c.trim(this); if ("" !== a && (-1 == a.indexOf("/") || "" == c.trim(a.substring(a.indexOf("/") + 1)) || 0 != a.indexOf("/") && (-1 == a.indexOf(".") ||
                        "http://" != a.substring(0, 7) && "https://" != a.substring(0, 8) && "ftp://" != a.substring(0, 6) || "http://" == a.substring(0, 7) && "" == a.substring(7, 8) || "https://" == a.substring(0, 8) && "" == a.substring(8, 9) || "ftp://" == a.substring(0, 6) && "" == a.substring(6, 7)))) return d(b), !1
                    }); break; case "singleurl": if ("" !== a && (-1 == a.indexOf("/") || "" == c.trim(a.substring(a.indexOf("/") + 1)) || 0 != a.indexOf("/") && (-1 == a.indexOf(".") || "http://" != a.substring(0, 7) && "https://" != a.substring(0, 8) && "ftp://" != a.substring(0, 6) || "http://" == a.substring(0,
                    7) && "" == a.substring(7, 8) || "https://" == a.substring(0, 8) && "" == a.substring(8, 9) || "ftp://" == a.substring(0, 6) && "" == a.substring(6, 7)))) return d(b), !1; break; case "wysiwyg": 5E5 < jQuery.trim(eval("Get" + b.attr("wysiwygid") + "HTML()")).length && d(b); break; case "friendlyurl": specValues = /\\|\/|:|\;|\*|\?|<|>|\#/gi; a.match(specValues) && d(b); break; case "friendlyurlfs": specValues = /\\|:|\;|\*|\?|<|>|\#|\%|\&|\+/gi; a.match(specValues) && d(b); break; case "enddatetime": "00:00" == c.trim(a) && d(b)
                }
            } function d(b) {
                0 < b.siblings(".counter:first").length ?
                b.siblings(".counter:first").after("<div class='error-validation'>" + b.attr("errormessage") + "</div>") : b.after("<div class='error-validation'>" + b.attr("errormessage") + "</div>"); l = !0; void 0 !== b.attr("tabstrip") && b.attr("tab") < h && (g = b.attr("tabstrip"), h = b.attr("tab"))
            } var m = c(this); m.find(".required").each(function () {
                if ("radio" != c(this).attr("validationtype") && "wysiwyg" != c(this).attr("validationtype")) "" != jQuery.trim(c(this).val()) ? k(c(this)) : d(c(this)); else if ("radio" == c(this).attr("validationtype")) {
                    var b =
                    c(this).attr("radioname"); void 0 === c("input[name^='" + b + "']:checked").val() && d(c(this))
                } else "wysiwyg" == c(this).attr("validationtype") && ("" != jQuery.trim(eval("Get" + c(this).attr("wysiwygid") + "HTML()")) ? k(c(this)) : d(c(this)))
            }); m.find(".optional").each(function () { k(c(this), !1) }); !1 === l ? f.onSuccess.call(this, f.params) : ("" != g && c("#" + g).tabs("select", parseInt(h)), f.onFail.call(this, f.params))
        })
    }; c.fn.validate.defaults = { onSuccess: function () { }, onFail: function () { }, params: {} }
})(jQuery);

//blockuserinteraction
(function(a){a.fn.blockinteraction=function(l){var f=a.extend({},a.fn.blockinteraction.defaults,l);return this.each(function(){if(a("#"+a(this).attr("id")+"-block-message").length>0)return false;var b=a(this);b.html();var e=b.outerHeight?b.outerHeight():b.height(),j=b.outerWidth?b.outerWidth():b.width(),c=b.offset(),k=b.attr("id")+"-block";if(f.isOverlay===true){e-=20;j-=20}f.isOverlay===false?a(document).ready(function(){a("body").append("<div id='"+b.attr("id")+"-block' class='blocker'></div>")}): b.append("<div id='"+b.attr("id")+"-block' class='blocker'></div>");var d=a("#"+b.attr("id")+"-block");d.css({position:"absolute",top:f.isOverlay===false?c.top:"31px",left:f.isOverlay===false?c.left:"10px",width:j+"px",height:e+"px",background:"transparent url('"+ staticURL + "/GlobalAssets/Images/loading-overlay.png')","z-index":"1002"});d.append("<span id='"+k+"-message' class='blocker'>"+f.message+"</span>");c=a("#"+b.attr("id")+"-block-message");c.css({padding:f.type==1?"10px":"30px","font-size":f.type== 1?"10pt":"18pt"});c.outerHeight?c.outerHeight():c.height();k=c.outerWidth?c.outerWidth():c.width();d=a(window).scrollTop();var i=d+a(window).height(),g=a(this).offset().top;e=g+e;var h=0;if(d>g&&i<e)h=d-g+20;else if(d<g&&i>e)h=20;else if(d>g&&i>e)h=d-g+20;else if(d<g&&i<e)h=20;c.css({"margin-top":h+"px","margin-left":j/2-k+"px",background:"transparent"})})};a.fn.blockinteraction.defaults={something:""};a.fn.unblockinteraction=function(){return this.each(function(){a(this);a(".blocker").remove()})}; a.fn.blockinteraction.defaults={message:"Please Wait...",type:2,isOverlay:false}})(jQuery);

//swalert
(function (b) {
    b.fn.swalert = function (h) {
        var d = b.extend({}, b.fn.swalert.defaults, h); return this.each(function (f, h) {
            function g() { b("div[id='" + c + "base']").fadeOut(); a.fadeOut(); a.remove(); k.focus() } b(this); var a, c, k = b("input.focus:first"); k.blur(); b("body").append('<div id="alert' + f + '" class="ui-sw-alert ' + d.alertType + '"></div>'); a = b("#alert" + f); c = a.attr("id"); a.append("<div class='ui-sw-alert top'></div>"); a.append("<div class='ui-sw-alert body'></div>"); a.append("<div class='ui-sw-alert footer'></div>");
            var e = "", e = "ok" == d.buttonType ? '<a id="' + c + 'ok" class="ui-btn-general-primary" tabindex="0"><span>OK</span></a>' : '<a id="' + c + 'yes" class="ui-btn-general-primary" tabindex="0"><span>Yes</span></a>' + ('<a id="' + c + 'no" class="ui-btn-general" tabindex="0"><span>No</span></a>'); $alertboxBody = a.find(".body"); $alertboxBody.append("<div class='ui-sw-alert icon " + d.alertType + "'></div>"); $alertboxBody.append("<div class='ui-sw-alert text'>" + function (a) {
                var c = /<\/([\s]*)script>/ig; return /<script.*?>/ig.test(a) ||
                c.test(a) ? b("<div/>").text(a).html() : a
            }(d.alertText) + "</div>"); $alertboxBody.append("<div class='ui-sw-alert buttons'>" + e + "</div>"); a.before('<div id="alert' + f + 'base" class="ui-dialog-overlay-base-modal" tabindex="-1">').after("</div>"); var e = b(window).width() / 2 - a.width() / 2, l = b(window).height() / 2 + b(window).scrollTop() - a.height(); b("#" + c + "base").css({ top: "0", bottom: "0" }).fadeIn(); a.css({ position: "absolute", "z-index": "99999", left: e + "px", top: l + "px", visibility: "visible" }); b("#" + c + "ok").bind("click", function () {
                g();
                d.onOk.call(this, d.params)
            }); b("#" + c + "ok").keydown(function (a) { a.stopImmediatePropagation(); 13 == a.keyCode && b(this).click() }); b("#" + c + "yes").bind("click", function () { g(); d.onYes.call(this, d.params) }); b("#" + c + "yes").keydown(function (a) { a.stopImmediatePropagation(); 13 == a.keyCode && b(this).click() }); b("#" + c + "no").bind("click", function () { g(); d.onNo.call(this, d.params) }); b("#" + c + "no").keydown(function (a) { a.stopImmediatePropagation(); 13 == a.keyCode && b(this).click() }); a.css("visibility", "visible"); b(".ui-dialog-overlay-base-modal").focus()
        })
    };
    b.fn.swalert.defaults = { alertText: "Are you sure?", titleText: "Alert", alertType: "information", buttonType: "ok", onYes: function () { }, onNo: function () { }, onOk: function () { }, params: {} }
})(jQuery);

//scrollto - added this here to fix issue with fast-clicking giving error due to external-combined being loaded on dom ready
(function (d) { var k = d.scrollTo = function (a, i, e) { d(window).scrollTo(a, i, e) }; k.defaults = { axis: 'xy', duration: parseFloat(d.fn.jquery) >= 1.3 ? 0 : 1 }; k.window = function (a) { return d(window)._scrollable() }; d.fn._scrollable = function () { return this.map(function () { var a = this, i = !a.nodeName || d.inArray(a.nodeName.toLowerCase(), ['iframe', '#document', 'html', 'body']) != -1; if (!i) return a; var e = (a.contentWindow || a).document || a.ownerDocument || a; return d.browser.safari || e.compatMode == 'BackCompat' ? e.body : e.documentElement }) }; d.fn.scrollTo = function (n, j, b) { if (typeof j == 'object') { b = j; j = 0 } if (typeof b == 'function') b = { onAfter: b }; if (n == 'max') n = 9e9; b = d.extend({}, k.defaults, b); j = j || b.speed || b.duration; b.queue = b.queue && b.axis.length > 1; if (b.queue) j /= 2; b.offset = p(b.offset); b.over = p(b.over); return this._scrollable().each(function () { var q = this, r = d(q), f = n, s, g = {}, u = r.is('html,body'); switch (typeof f) { case 'number': case 'string': if (/^([+-]=)?\d+(\.\d+)?(px|%)?$/.test(f)) { f = p(f); break } f = d(f, this); case 'object': if (f.is || f.style) s = (f = d(f)).offset() } d.each(b.axis.split(''), function (a, i) { var e = i == 'x' ? 'Left' : 'Top', h = e.toLowerCase(), c = 'scroll' + e, l = q[c], m = k.max(q, i); if (s) { g[c] = s[h] + (u ? 0 : l - r.offset()[h]); if (b.margin) { g[c] -= parseInt(f.css('margin' + e)) || 0; g[c] -= parseInt(f.css('border' + e + 'Width')) || 0 } g[c] += b.offset[h] || 0; if (b.over[h]) g[c] += f[i == 'x' ? 'width' : 'height']() * b.over[h] } else { var o = f[h]; g[c] = o.slice && o.slice(-1) == '%' ? parseFloat(o) / 100 * m : o } if (/^\d+$/.test(g[c])) g[c] = g[c] <= 0 ? 0 : Math.min(g[c], m); if (!a && b.queue) { if (l != g[c]) t(b.onAfterFirst); delete g[c] } }); t(b.onAfter); function t(a) { r.animate(g, j, b.easing, a && function () { a.call(this, n, b) }) } }).end() }; k.max = function (a, i) { var e = i == 'x' ? 'Width' : 'Height', h = 'scroll' + e; if (!d(a).is('html,body')) return a[h] - d(a)[e.toLowerCase()](); var c = 'client' + e, l = a.ownerDocument.documentElement, m = a.ownerDocument.body; return Math.max(l[h], m[h]) - Math.min(l[c], m[c]) }; function p(a) { return typeof a == 'object' ? a : { top: a, left: a} } })(jQuery);