/*
 * jQuery UI Accordion 1.8.13
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Accordion
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js 
 */
(function (c) {
    c.widget("ui.accordion", { options: { active: 0, animated: "slide", autoHeight: true, clearStyle: false, collapsible: false, event: "click", fillSpace: false, header: "> li > :first-child,> :not(li):even", icons: { header: "ui-icon-triangle-1-e", headerSelected: "ui-icon-triangle-1-s" }, navigation: false, navigationFilter: function () { return this.href.toLowerCase() === location.href.toLowerCase() } }, _create: function () {
        var a = this, b = a.options; a.running = 0; a.element.addClass("ui-accordion ui-widget ui-helper-reset").children("li").addClass("ui-accordion-li-fix");
        a.headers = a.element.find(b.header).addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all").bind("mouseenter.accordion", function () { b.disabled || c(this).addClass("ui-state-hover") }).bind("mouseleave.accordion", function () { b.disabled || c(this).removeClass("ui-state-hover") }).bind("focus.accordion", function () { b.disabled || c(this).addClass("ui-state-focus") }).bind("blur.accordion", function () { b.disabled || c(this).removeClass("ui-state-focus") }); a.headers.next().addClass("ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom");
        if (b.navigation) { var d = a.element.find("a").filter(b.navigationFilter).eq(0); if (d.length) { var h = d.closest(".ui-accordion-header"); a.active = h.length ? h : d.closest(".ui-accordion-content").prev() } } a.active = a._findActive(a.active || b.active).addClass("ui-state-default ui-state-active").toggleClass("ui-corner-all").toggleClass("ui-corner-top"); a.active.next().addClass("ui-accordion-content-active"); a._createIcons(); a.resize(); a.element.attr("role", "tablist"); a.headers.attr("role", "tab").bind("keydown.accordion",
function (f) { return a._keydown(f) }).next().attr("role", "tabpanel"); a.headers.not(a.active || "").attr({ "aria-expanded": "false", "aria-selected": "false", tabIndex: -1 }).next().hide(); a.active.length ? a.active.attr({ "aria-expanded": "true", "aria-selected": "true", tabIndex: 0 }) : a.headers.eq(0).attr("tabIndex", 0); c.browser.safari || a.headers.find("a").attr("tabIndex", -1); b.event && a.headers.bind(b.event.split(" ").join(".accordion ") + ".accordion", function (f) { a._clickHandler.call(a, f, this); f.preventDefault() })
    }, _createIcons: function () {
        var a =
this.options; if (a.icons) { c("<span></span>").addClass("ui-icon " + a.icons.header).prependTo(this.headers); this.active.children(".ui-icon").toggleClass(a.icons.header).toggleClass(a.icons.headerSelected); this.element.addClass("ui-accordion-icons") }
    }, _destroyIcons: function () { this.headers.children(".ui-icon").remove(); this.element.removeClass("ui-accordion-icons") }, destroy: function () {
        var a = this.options; this.element.removeClass("ui-accordion ui-widget ui-helper-reset").removeAttr("role"); this.headers.unbind(".accordion").removeClass("ui-accordion-header ui-accordion-disabled ui-helper-reset ui-state-default ui-corner-all ui-state-active ui-state-disabled ui-corner-top").removeAttr("role").removeAttr("aria-expanded").removeAttr("aria-selected").removeAttr("tabIndex");
        this.headers.find("a").removeAttr("tabIndex"); this._destroyIcons(); var b = this.headers.next().css("display", "").removeAttr("role").removeClass("ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content ui-accordion-content-active ui-accordion-disabled ui-state-disabled"); if (a.autoHeight || a.fillHeight) b.css("height", ""); return c.Widget.prototype.destroy.call(this)
    }, _setOption: function (a, b) {
        c.Widget.prototype._setOption.apply(this, arguments); a == "active" && this.activate(b); if (a == "icons") {
            this._destroyIcons();
            b && this._createIcons()
        } if (a == "disabled") this.headers.add(this.headers.next())[b ? "addClass" : "removeClass"]("ui-accordion-disabled ui-state-disabled")
    }, _keydown: function (a) {
        if (!(this.options.disabled || a.altKey || a.ctrlKey)) {
            var b = c.ui.keyCode, d = this.headers.length, h = this.headers.index(a.target), f = false; switch (a.keyCode) {
                case b.RIGHT: case b.DOWN: f = this.headers[(h + 1) % d]; break; case b.LEFT: case b.UP: f = this.headers[(h - 1 + d) % d]; break; case b.SPACE: case b.ENTER: this._clickHandler({ target: a.target }, a.target);
                    a.preventDefault()
            } if (f) { c(a.target).attr("tabIndex", -1); c(f).attr("tabIndex", 0); f.focus(); return false } return true
        }
    }, resize: function () {
        var a = this.options, b; if (a.fillSpace) {
            if (c.browser.msie) { var d = this.element.parent().css("overflow"); this.element.parent().css("overflow", "hidden") } b = this.element.parent().height(); c.browser.msie && this.element.parent().css("overflow", d); this.headers.each(function () { b -= c(this).outerHeight(true) }); this.headers.next().each(function () {
                c(this).height(Math.max(0, b - c(this).innerHeight() +
c(this).height()))
            }).css("overflow", "auto")
        } else if (a.autoHeight) { b = 0; this.headers.next().each(function () { b = Math.max(b, c(this).height("").height()) }).height(b) } return this
    }, activate: function (a) { this.options.active = a; a = this._findActive(a)[0]; this._clickHandler({ target: a }, a); return this }, _findActive: function (a) { return a ? typeof a === "number" ? this.headers.filter(":eq(" + a + ")") : this.headers.not(this.headers.not(a)) : a === false ? c([]) : this.headers.filter(":eq(0)") }, _clickHandler: function (a, b) {
        var d = this.options;
        if (!d.disabled) if (a.target) {
            a = c(a.currentTarget || b); b = a[0] === this.active[0]; d.active = d.collapsible && b ? false : this.headers.index(a); if (!(this.running || !d.collapsible && b)) {
                var h = this.active; j = a.next(); g = this.active.next(); e = { options: d, newHeader: b && d.collapsible ? c([]) : a, oldHeader: this.active, newContent: b && d.collapsible ? c([]) : j, oldContent: g }; var f = this.headers.index(this.active[0]) > this.headers.index(a[0]); this.active = b ? c([]) : a; this._toggle(j, g, e, b, f); h.removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all").children(".ui-icon").removeClass(d.icons.headerSelected).addClass(d.icons.header);
                if (!b) { a.removeClass("ui-state-default ui-corner-all").addClass("ui-state-active ui-corner-top").children(".ui-icon").removeClass(d.icons.header).addClass(d.icons.headerSelected); a.next().addClass("ui-accordion-content-active") }
            }
        } else if (d.collapsible) {
            this.active.removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all").children(".ui-icon").removeClass(d.icons.headerSelected).addClass(d.icons.header); this.active.next().addClass("ui-accordion-content-active"); var g = this.active.next(),
e = { options: d, newHeader: c([]), oldHeader: d.active, newContent: c([]), oldContent: g }, j = this.active = c([]); this._toggle(j, g, e)
        }
    }, _toggle: function (a, b, d, h, f) {
        var g = this, e = g.options; g.toShow = a; g.toHide = b; g.data = d; var j = function () { if (g) return g._completed.apply(g, arguments) }; g._trigger("changestart", null, g.data); g.running = b.size() === 0 ? a.size() : b.size(); if (e.animated) {
            d = {}; d = e.collapsible && h ? { toShow: c([]), toHide: b, complete: j, down: f, autoHeight: e.autoHeight || e.fillSpace} : { toShow: a, toHide: b, complete: j, down: f, autoHeight: e.autoHeight ||
e.fillSpace
            }; if (!e.proxied) e.proxied = e.animated; if (!e.proxiedDuration) e.proxiedDuration = e.duration; e.animated = c.isFunction(e.proxied) ? e.proxied(d) : e.proxied; e.duration = c.isFunction(e.proxiedDuration) ? e.proxiedDuration(d) : e.proxiedDuration; h = c.ui.accordion.animations; var i = e.duration, k = e.animated; if (k && !h[k] && !c.easing[k]) k = "slide"; h[k] || (h[k] = function (l) { this.slide(l, { easing: k, duration: i || 700 }) }); h[k](d)
        } else { if (e.collapsible && h) a.toggle(); else { b.hide(); a.show() } j(true) } b.prev().attr({ "aria-expanded": "false",
            "aria-selected": "false", tabIndex: -1
        }).blur(); a.prev().attr({ "aria-expanded": "true", "aria-selected": "true", tabIndex: 0 }).focus()
    }, _completed: function (a) { this.running = a ? 0 : --this.running; if (!this.running) { this.options.clearStyle && this.toShow.add(this.toHide).css({ height: "", overflow: "" }); this.toHide.removeClass("ui-accordion-content-active"); if (this.toHide.length) this.toHide.parent()[0].className = this.toHide.parent()[0].className; this._trigger("change", null, this.data) } }
    }); c.extend(c.ui.accordion, { version: "1.8.13",
        animations: { slide: function (a, b) {

            // For websites using layout v1
            if (typeof window.SI_clearFooter == 'function') {
                clearTimeout(null);
                setTimeout(function () {
                    SI_clearFooter();
                }, 1000);
            }

            a = c.extend({ easing: "swing", duration: 300 }, a, b); if (a.toHide.size()) if (a.toShow.size()) {
                var d = a.toShow.css("overflow"), h = 0, f = {}, g = {}, e; b = a.toShow; e = b[0].style.width; b.width(parseInt(b.parent().width(), 10) - parseInt(b.css("paddingLeft"), 10) - parseInt(b.css("paddingRight"), 10) - (parseInt(b.css("borderLeftWidth"), 10) || 0) - (parseInt(b.css("borderRightWidth"), 10) || 0)); c.each(["height", "paddingTop", "paddingBottom"], function (j, i) {
                    g[i] = "hide"; j = ("" + c.css(a.toShow[0], i)).match(/^([\d+-.]+)(.*)$/);
                    f[i] = { value: j[1], unit: j[2] || "px" }
                }); a.toShow.css({ height: 0, overflow: "hidden" }).show(); a.toHide.filter(":hidden").each(a.complete).end().filter(":visible").animate(g, { step: function (j, i) { if (i.prop == "height") h = i.end - i.start === 0 ? 0 : (i.now - i.start) / (i.end - i.start); a.toShow[0].style[i.prop] = h * f[i.prop].value + f[i.prop].unit }, duration: a.duration, easing: a.easing, complete: function () { a.autoHeight || a.toShow.css("height", ""); a.toShow.css({ width: e, overflow: d }); a.complete() } })
            } else a.toHide.animate({ height: "hide",
                paddingTop: "hide", paddingBottom: "hide"
            }, a); else a.toShow.animate({ height: "show", paddingTop: "show", paddingBottom: "show" }, a)
        }, bounceslide: function (a) { this.slide(a, { easing: a.down ? "easeOutBounce" : "swing", duration: a.down ? 1E3 : 200 }) }
        }
    })
})(jQuery);
;