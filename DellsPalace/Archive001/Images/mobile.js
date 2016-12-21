jQuery(document).ready(function (e) {
    function n(e) {
        return "none" == e.css("display") ? !1 : !0
    }

    function s() {
        e(".sdrn_parent_item_li").each(function () {
            var n = e(this),
                s = 0,
                i = n.find(".sdrn_icon_par").first(),
                t = n.find("a.sdrn_parent_item").first();
            s = h.hasClass("top") ? window.innerWidth : m.innerWidth(), 0 == n.find(".sdrn_clear").length && t.after('<br class="sdrn_clear"/>')
        })
    }

    function i() {
        h.find("ul.sub-menu").each(function () {
            var s = e(this),
                i = s.parent("li").find(".sdrn_icon_par"),
                t = s.parent("li");
            n(s) && s.slideUp(300), i.removeClass("sdrn_par_opened"), i.removeClass(h.attr("data-custom_icon_open")), i.addClass(h.attr("data-custom_icon")), t.removeClass("sdrn_no_border_bottom")
        })
    }

    function t() {
        window.scrollBy(1, 1), window.scrollBy(-1, -1), g = h.width(), y = window.innerHeight < p.height() ? p.height() : window.innerHeight, x = window.innerWidth < p.width() ? p.width() : window.innerWidth, p.hasClass("menu_is_opened") && (h.hasClass("sdrn_jquery") && (i(), p.hasClass("sdrn_left") && (p.css({
            left: g
        }), p.scrollLeft(0)), e.sidr("close", "sdrn_menu"), _.removeClass("menu_is_opened"), p.removeClass("menu_is_opened")), h.hasClass("sdrn_css3") && (i(), _.removeClass("menu_is_opened"), p.removeClass("menu_is_opened")))
    }

    function a(s) {
        s.length > 0 && e.each(s, function (s, i) {
            if (0 == W) {
                var t = parseInt(i.css("top"), 0) >= 0 ? parseInt(i.css("top"), 0) : 0,
                    a = e("#wpadminbar");
                n(a) && n(_) && i.css({
                    top: t + 42 + a.height()
                }), n(a) && !n(_) && i.css({
                    top: t + a.height()
                }), !n(a) && n(_) && i.css({
                    top: t + 42
                }), n(a) || n(_) || i.css({
                    top: t
                }), i.css({
                    "z-index": 900
                }), i.addClass("fixed_animation")
            }
        }), W = !0
    }

    function r() {
        var s = e("#wpadminbar");
        n(s) && (e("#sdrn_menu.left ul#sdrn_menu_ul, #sdrn_menu.right ul#sdrn_menu_ul").css({
            "padding-top": 42 + s.height()
        }), e("#sdrn_bar").css({
            top: s.height()
        }))
    }

    function d() {
        h.hasClass("sdrn_jquery") && (e.sidr("close", "sdrn_menu"), _.removeClass("menu_is_opened"), p.removeClass("menu_is_opened")), h.hasClass("sdrn_css3") && (i(), _.removeClass("menu_is_opened"), p.removeClass("menu_is_opened"), e(".fixed_animation").removeClass("fixed_animation_moved"))
    }

    function o() {
        h.hasClass("sdrn_jquery") && (e.sidr("open", "sdrn_menu"), _.addClass("menu_is_opened"), p.addClass("menu_is_opened")), h.hasClass("sdrn_css3") && (_.addClass("menu_is_opened"), p.addClass("menu_is_opened"), e(".fixed_animation").addClass("fixed_animation_moved"))
    }
    var _ = e("#sdrn_bar"),
        l = _.outerHeight(!0),
        c = _.attr("data-from_width"),
        h = e("#sdrn_menu"),
        m = e("#sdrn_menu_ul"),
        u = h.find("a"),
        p = e("body"),
        f = e("html"),
        w = 300,
        C = e("#wpadminbar"),
        v = _.length > 0 && h.length > 0 ? !0 : !1,
        g = h.width(),
        b = h.attr("data-expand_sub_with_parent"),
        y = window.innerHeight < p.height() ? p.height() : window.innerHeight,
        x = window.innerWidth < p.width() ? p.width() : window.innerWidth,
        k = [],
        W = !1,
        j = navigator.userAgent,
        q = !1,
        S = !1;
    if (-1 != j.indexOf("Chrome") && (q = !0), -1 != j.indexOf("Firefox") && (S = !0), f.addClass("sdrn_" + Detect({
        useUA: !0
    })), v) {
        m.find("li").first().css({
            "border-top": "none"
        }), e(document).mouseup(function (s) {
            h.is(s.target) || 0 !== h.has(s.target).length || n(h) && (h.hasClass("sdrn_jquery") && (i(), e.sidr("close", "sdrn_menu"), _.removeClass("menu_is_opened"), p.removeClass("menu_is_opened")), h.hasClass("sdrn_css3") && (i(), _.removeClass("menu_is_opened"), p.removeClass("menu_is_opened"), e(".fixed_animation").removeClass("fixed_animation_moved")))
        }), h.find("ul.sub-menu").each(function () {
            var n = e(this),
                s = n.prev("a"),
                i = s.parent("li").first();
            s.addClass("sdrn_parent_item"), i.addClass("sdrn_parent_item_li");
            var t = s.before('<span class="sdrn_icon sdrn_icon_par icon_default ' + h.attr("data-custom_icon") + '"></span> ').find(".sdrn_icon_par");
            n.hide()
        }), h.hasClass("sdrn_custom_icons") && e("#sdrn_menu span.sdrn_icon").removeClass("icon_default"), h.find("#sdrn_menu_ul a[data-cii=1]").each(function () {
            var n = e(this),
                s = n.attr("data-fa_icon"),
                i = n.attr("data-icon_color"),
                t = n.find("div").first(),
                a = n.attr("data-icon_src");
            a || (t.addClass("sdrn_item_custom_icon"), t.addClass("sdrn_item_custom_icon_fa"), t.addClass(s), t.css({
                color: i
            })), a && (t.addClass("sdrn_item_custom_icon"), t.html('<img src="' + a + '" width="23" height="23" alt="cii">'))
        }), s(), e(".sdrn_icon_par").on("click", function (n) {
            n.preventDefault();
            var s = e(this),
                i = s.parent("li").find("ul.sub-menu").first();
            i.slideToggle(300), s.toggleClass("sdrn_par_opened"), "" != h.attr("data-custom_icon") && (s.toggleClass(h.attr("data-custom_icon_open")), "" != h.attr("data-custom_icon_open") && s.toggleClass(h.attr("data-custom_icon"))), s.parent("li").first().toggleClass("sdrn_no_border_bottom")
        });
        var B = e("meta[name=viewport]");
       
	   
	   
	   
	   
	   
	   
	   
if (B = B.length ? B : e('<meta name="viewport" />').appendTo("head"), "no" == h.attr("data-zooming") ? B.attr("content", "user-scalable=no, width=device-width, maximum-scale=1, minimum-scale=1") : B.attr("content", "user-scalable=yes, width=device-width, initial-scale=1.0, minimum-scale=1"), S ? screen.addEventListener("orientationchange", function () {
            t()
        }) : 0, h.hasClass("left") || h.hasClass("right")) {
            
			
			if (h.hasClass("sdrn_jquery")) {
                var D = h.hasClass("left") ? "left" : "right";
                _.sidr({
                    name: "sdrn_menu",
                    side: D,
                    speed: w
                })
            }
            if (r(), h.hasClass("sdrn_css3")) {
                h.show();
                var M = p.wrapInner('<div id="sdrn_wrapper">').find("#sdrn_wrapper"),
                    A = M.wrapInner('<div id="sdrn_wrapper_inner">').find("#sdrn_wrapper_inner");
                h.insertBefore(M), _.insertBefore(M), C.insertBefore(M);
                var O = A.find("> *").filter(function () {
                    return "fixed" === e(this).css("position")
                }).each(function () {
                    var n = e(this);
                    p.append(n), k.push(n)
                });
                a(k), p.height() < e(window).height() && (p.height(e(window).height()), M.height(e(window).height())), M.css("" == p.css("background") || p.css("background-color").indexOf("0)") >= 0 ? {
                    background: "#fff"
                } : {
                    background: p.css("background")
                })
            }
            _.on("click", function () {
                i(), _.toggleClass("_opened_"), _.hasClass("_opened_") ? (_.addClass("menu_is_opened"), p.addClass("menu_is_opened"), e(".fixed_animation").addClass("fixed_animation_moved")) : (_.removeClass("menu_is_opened"), p.removeClass("menu_is_opened"), e(".fixed_animation").removeClass("fixed_animation_moved"))
            }), u.on("click", function (n) {
                if (n.preventDefault(), "yes" == b && e(this).parent().hasClass("sdrn_parent_item_li")) return void e(this).prev("span.sdrn_icon").trigger("click");
                var s = e(this).attr("href");
                h.hasClass("sdrn_jquery") && e.sidr("close", "sdrn_menu"), h.hasClass("sdrn_css3") && (i(), _.removeClass("menu_is_opened"), p.removeClass("menu_is_opened"), e(".fixed_animation").removeClass("fixed_animation_moved")), setTimeout(function () {
                    window.location.href = s
                }, w)
            }), "yes" == h.attr("data-swipe_actions") && e(window).touchwipe({
                wipeLeft: function () {
                    h.hasClass("left") && d(), h.hasClass("right") && o()
                },
                wipeRight: function () {
                    h.hasClass("left") && o(), h.hasClass("right") && d()
                },
                preventDefaultEvents: !1
            }), e(window).resize(function () {
                x = window.innerWidth < p.width() ? p.width() : window.innerWidth, x > c && n(h) && (i(), h.hasClass("sdrn_jquery") && e.sidr("close", "sdrn_menu"), h.hasClass("sdrn_css3") && (_.removeClass("menu_is_opened"), p.removeClass("menu_is_opened"), e(".fixed_animation").removeClass("fixed_animation_moved"))), r(), a(k)
            })
        } else h.hasClass("top") && (p.prepend(h), r(), _.on("click", function (n) {
            e("html, body").animate({
                scrollTop: 0
            }, w), i(), h.stop(!0, !1).slideToggle(w)
        }), u.on("click", function (n) {
            if (n.preventDefault(), "yes" == b && e(this).parent().hasClass("sdrn_parent_item_li")) return console.log("s"), void e(this).prev("span.sdrn_icon_par").trigger("click");
            var s = e(this).attr("href");
            h.slideUp(w, function () {
                window.location.href = s
            })
        }), e(window).resize(function () {
            x = window.innerWidth < p.width() ? p.width() : window.innerWidth, x > c && n(h) && (i(), h.slideUp(w, function () {}))
        }))
    }
});
var Detect = function (e) {
    void 0 === e && (e = {}), this.init = function () {
        return this.mm = window.matchMedia, this.mm && !e.useUA ? (this.method = "media queries", this.type = n()) : (this.method = "user agent strings", this.type = r()), e.verbose ? [this.type, this.method] : this.type
    };
    var n = function () {
        return t(320) && a(480) ? "smartphone" : t(768) && a(1024) ? "tablet" : "desktop"
    }, s = function (e, n) {
            return window.matchMedia("screen and (" + e + "-device-width: " + n + "px)").matches
        }, t = function (e) {
            return s("min", e)
        }, a = function (e) {
            return s("max", e)
        }, r = function () {
            var e = navigator.userAgent;
            for (tablets = [/Android 3/i, /iPad/i], i = 0, l = tablets.length; l > i; i++)
                if (e.match(tablets[i])) return "tablet";
            for (smartphones = [/Mobile/i, /Android/i, /iPhone/i, /BlackBerry/i, /Windows Phone/i, /Windows Mobile/i, /Maemo/i, /PalmSource/i, /SymbianOS/i, /SymbOS/i, /Nokia/i, /MOT-/i, /JDME/i, /Series 60/i, /S60/i, /SonyEricsson/i], i = 0, l = smartphones.length; l > i; i++)
                if (e.match(smartphones[i])) return "smartphone";
            return "desktop"
        };
    return this.init()
};
//# sourceMappingURL=./mobile.nav.frontend-ck.map