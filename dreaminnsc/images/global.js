function setCookie(e, t, i) {
    var n = new Date;
    n.setTime(n.getTime() + 24 * i * 60 * 60 * 1e3);
    var o = "; expires=" + n.toGMTString();
    document.cookie = e + "=" + t + o
}

function getParam(e) {
    var t = RegExp("[?&]" + e + "=([^&]*)").exec(window.location.search);
    return t && decodeURIComponent(t[1].replace(/\+/g, " "))
}

function readCookie(e) {
    for (var t = e + "=", i = document.cookie.split(";"), n = 0; n < i.length; n++) {
        for (var o = i[n];
            " " == o.charAt(0);) o = o.substring(1, o.length);
        if (0 == o.indexOf(t)) return o.substring(t.length, o.length)
    }
    return null
}

function _gaLink(e) {
    return url = e.href, _gaq.push(function () {
        "_blank" == e.target ? window.open(_gat._getTrackers()[0]._getLinkerUrl(url)) : _gaq.push(["_link", url])
    }), !1
}

function equalize(e, t, i) {
    "use strict";
    if (t = t || ".group", i = i || ".equalize", $(t).length > 0) var n = $(t).length;
    $(t).each(function () {
        var e = 0;
        $(i, this).css("height", "auto"), $(i, this).each(function () {
            $(this).innerHeight() > e && (e = $(this).innerHeight())
        }), $(i, this).innerHeight(e), n--
    }), 0 === n && (console.log("Heights equalized"), "function" == typeof e ? e() : console.log())
}! function (e, t) {
    "function" == typeof define && define.amd ? define(t) : "object" == typeof exports ? module.exports = t() : e.ScrollMagic = t()
}(this, function () {
    "use strict";
    var e = function () {
        o.log(2, "(COMPATIBILITY NOTICE) -> As of ScrollMagic 2.0.0 you need to use 'new ScrollMagic.Controller()' to create a new controller instance. Use 'new ScrollMagic.Scene()' to instance a scene.")
    };
    e.version = "2.0.5", window.addEventListener("mousewheel", function () {});
    var t = "data-scrollmagic-pin-spacer";
    e.Controller = function (n) {
        var s, r, a = "ScrollMagic.Controller",
            l = "FORWARD",
            c = "REVERSE",
            d = "PAUSED",
            u = i.defaults,
            h = this,
            p = o.extend({}, u, n),
            f = [],
            g = !1,
            m = 0,
            v = d,
            y = !0,
            b = 0,
            w = !0,
            k = function () {
                for (var t in p) u.hasOwnProperty(t) || (E(2, 'WARNING: Unknown option "' + t + '"'), delete p[t]);
                if (p.container = o.get.elements(p.container)[0], !p.container) throw E(1, "ERROR creating object " + a + ": No valid scroll container supplied"), a + " init failed.";
                y = p.container === window || p.container === document.body || !document.body.contains(p.container), y && (p.container = window), b = C(), p.container.addEventListener("resize", M), p.container.addEventListener("scroll", M), p.refreshInterval = parseInt(p.refreshInterval) || u.refreshInterval, _(), E(3, "added new " + a + " controller (v" + e.version + ")")
            },
            _ = function () {
                p.refreshInterval > 0 && (r = window.setTimeout(I, p.refreshInterval))
            },
            x = function () {
                return p.vertical ? o.get.scrollTop(p.container) : o.get.scrollLeft(p.container)
            },
            C = function () {
                return p.vertical ? o.get.height(p.container) : o.get.width(p.container)
            },
            T = this._setScrollPos = function (e) {
                p.vertical ? y ? window.scrollTo(o.get.scrollLeft(), e) : p.container.scrollTop = e : y ? window.scrollTo(e, o.get.scrollTop()) : p.container.scrollLeft = e
            },
            S = function () {
                if (w && g) {
                    var e = o.type.Array(g) ? g : f.slice(0);
                    g = !1;
                    var t = m;
                    m = h.scrollPos();
                    var i = m - t;
                    0 !== i && (v = i > 0 ? l : c), v === c && e.reverse(), e.forEach(function (t, i) {
                        E(3, "updating Scene " + (i + 1) + "/" + e.length + " (" + f.length + " total)"), t.update(!0)
                    }), 0 === e.length && p.loglevel >= 3 && E(3, "updating 0 Scenes (nothing added to controller)")
                }
            },
            D = function () {
                s = o.rAF(S)
            },
            M = function (e) {
                E(3, "event fired causing an update:", e.type), "resize" == e.type && (b = C(), v = d), g !== !0 && (g = !0, D())
            },
            I = function () {
                if (!y && b != C()) {
                    var e;
                    try {
                        e = new Event("resize", {
                            bubbles: !1,
                            cancelable: !1
                        })
                    } catch (t) {
                        e = document.createEvent("Event"), e.initEvent("resize", !1, !1)
                    }
                    p.container.dispatchEvent(e)
                }
                f.forEach(function (e, t) {
                    e.refresh()
                }), _()
            },
            E = this._log = function (e, t) {
                p.loglevel >= e && (Array.prototype.splice.call(arguments, 1, 0, "(" + a + ") ->"), o.log.apply(window, arguments))
            };
        this._options = p;
        var A = function (e) {
            if (e.length <= 1) return e;
            var t = e.slice(0);
            return t.sort(function (e, t) {
                return e.scrollOffset() > t.scrollOffset() ? 1 : -1
            }), t
        };
        return this.addScene = function (t) {
            if (o.type.Array(t)) t.forEach(function (e, t) {
                h.addScene(e)
            });
            else if (t instanceof e.Scene) {
                if (t.controller() !== h) t.addTo(h);
                else if (f.indexOf(t) < 0) {
                    f.push(t), f = A(f), t.on("shift.controller_sort", function () {
                        f = A(f)
                    });
                    for (var i in p.globalSceneOptions) t[i] && t[i].call(t, p.globalSceneOptions[i]);
                    E(3, "adding Scene (now " + f.length + " total)")
                }
            } else E(1, "ERROR: invalid argument supplied for '.addScene()'");
            return h
        }, this.removeScene = function (e) {
            if (o.type.Array(e)) e.forEach(function (e, t) {
                h.removeScene(e)
            });
            else {
                var t = f.indexOf(e);
                t > -1 && (e.off("shift.controller_sort"), f.splice(t, 1), E(3, "removing Scene (now " + f.length + " left)"), e.remove())
            }
            return h
        }, this.updateScene = function (t, i) {
            return o.type.Array(t) ? t.forEach(function (e, t) {
                h.updateScene(e, i)
            }) : i ? t.update(!0) : g !== !0 && t instanceof e.Scene && (g = g || [], -1 == g.indexOf(t) && g.push(t), g = A(g), D()), h
        }, this.update = function (e) {
            return M({
                type: "resize"
            }), e && S(), h
        }, this.scrollTo = function (i, n) {
            if (o.type.Number(i)) T.call(p.container, i, n);
            else if (i instanceof e.Scene) i.controller() === h ? h.scrollTo(i.scrollOffset(), n) : E(2, "scrollTo(): The supplied scene does not belong to this controller. Scroll cancelled.", i);
            else if (o.type.Function(i)) T = i;
            else {
                var s = o.get.elements(i)[0];
                if (s) {
                    for (; s.parentNode.hasAttribute(t);) s = s.parentNode;
                    var r = p.vertical ? "top" : "left",
                        a = o.get.offset(p.container),
                        l = o.get.offset(s);
                    y || (a[r] -= h.scrollPos()), h.scrollTo(l[r] - a[r], n)
                } else E(2, "scrollTo(): The supplied argument is invalid. Scroll cancelled.", i)
            }
            return h
        }, this.scrollPos = function (e) {
            return arguments.length ? (o.type.Function(e) ? x = e : E(2, "Provided value for method 'scrollPos' is not a function. To change the current scroll position use 'scrollTo()'."), h) : x.call(h)
        }, this.info = function (e) {
            var t = {
                size: b,
                vertical: p.vertical,
                scrollPos: m,
                scrollDirection: v,
                container: p.container,
                isDocument: y
            };
            return arguments.length ? void 0 !== t[e] ? t[e] : void E(1, 'ERROR: option "' + e + '" is not available') : t
        }, this.loglevel = function (e) {
            return arguments.length ? (p.loglevel != e && (p.loglevel = e), h) : p.loglevel
        }, this.enabled = function (e) {
            return arguments.length ? (w != e && (w = !!e, h.updateScene(f, !0)), h) : w
        }, this.destroy = function (e) {
            window.clearTimeout(r);
            for (var t = f.length; t--;) f[t].destroy(e);
            return p.container.removeEventListener("resize", M), p.container.removeEventListener("scroll", M), o.cAF(s), E(3, "destroyed " + a + " (reset: " + (e ? "true" : "false") + ")"), null
        }, k(), h
    };
    var i = {
        defaults: {
            container: window,
            vertical: !0,
            globalSceneOptions: {},
            loglevel: 2,
            refreshInterval: 100
        }
    };
    e.Controller.addOption = function (e, t) {
        i.defaults[e] = t
    }, e.Controller.extend = function (t) {
        var i = this;
        e.Controller = function () {
            return i.apply(this, arguments), this.$super = o.extend({}, this), t.apply(this, arguments) || this
        }, o.extend(e.Controller, i), e.Controller.prototype = i.prototype, e.Controller.prototype.constructor = e.Controller
    }, e.Scene = function (i) {
        var s, r, a = "ScrollMagic.Scene",
            l = "BEFORE",
            c = "DURING",
            d = "AFTER",
            u = n.defaults,
            h = this,
            p = o.extend({}, u, i),
            f = l,
            g = 0,
            m = {
                start: 0,
                end: 0
            },
            v = 0,
            y = !0,
            b = function () {
                for (var e in p) u.hasOwnProperty(e) || (k(2, 'WARNING: Unknown option "' + e + '"'), delete p[e]);
                for (var t in u) I(t);
                D()
            },
            w = {};
        this.on = function (e, t) {
            return o.type.Function(t) ? (e = e.trim().split(" "), e.forEach(function (e) {
                var i = e.split("."),
                    n = i[0],
                    o = i[1];
                "*" != n && (w[n] || (w[n] = []), w[n].push({
                    namespace: o || "",
                    callback: t
                }))
            })) : k(1, "ERROR when calling '.on()': Supplied callback for '" + e + "' is not a valid function!"), h
        }, this.off = function (e, t) {
            return e ? (e = e.trim().split(" "), e.forEach(function (e, i) {
                var n = e.split("."),
                    o = n[0],
                    s = n[1] || "",
                    r = "*" === o ? Object.keys(w) : [o];
                r.forEach(function (e) {
                    for (var i = w[e] || [], n = i.length; n--;) {
                        var o = i[n];
                        !o || s !== o.namespace && "*" !== s || t && t != o.callback || i.splice(n, 1)
                    }
                    i.length || delete w[e]
                })
            }), h) : (k(1, "ERROR: Invalid event name supplied."), h)
        }, this.trigger = function (t, i) {
            if (t) {
                var n = t.trim().split("."),
                    o = n[0],
                    s = n[1],
                    r = w[o];
                k(3, "event fired:", o, i ? "->" : "", i || ""), r && r.forEach(function (t, n) {
                    s && s !== t.namespace || t.callback.call(h, new e.Event(o, t.namespace, h, i))
                })
            } else k(1, "ERROR: Invalid event name supplied.");
            return h
        }, h.on("change.internal", function (e) {
            "loglevel" !== e.what && "tweenChanges" !== e.what && ("triggerElement" === e.what ? C() : "reverse" === e.what && h.update())
        }).on("shift.internal", function (e) {
            _(), h.update()
        });
        var k = this._log = function (e, t) {
            p.loglevel >= e && (Array.prototype.splice.call(arguments, 1, 0, "(" + a + ") ->"), o.log.apply(window, arguments))
        };
        this.addTo = function (t) {
            return t instanceof e.Controller ? r != t && (r && r.removeScene(h), r = t, D(), x(!0), C(!0), _(), r.info("container").addEventListener("resize", T), t.addScene(h), h.trigger("add", {
                controller: r
            }), k(3, "added " + a + " to controller"), h.update()) : k(1, "ERROR: supplied argument of 'addTo()' is not a valid ScrollMagic Controller"), h
        }, this.enabled = function (e) {
            return arguments.length ? (y != e && (y = !!e, h.update(!0)), h) : y
        }, this.remove = function () {
            if (r) {
                r.info("container").removeEventListener("resize", T);
                var e = r;
                r = void 0, e.removeScene(h), h.trigger("remove"), k(3, "removed " + a + " from controller")
            }
            return h
        }, this.destroy = function (e) {
            return h.trigger("destroy", {
                reset: e
            }), h.remove(), h.off("*.*"), k(3, "destroyed " + a + " (reset: " + (e ? "true" : "false") + ")"), null
        }, this.update = function (e) {
            if (r)
                if (e)
                    if (r.enabled() && y) {
                        var t, i = r.info("scrollPos");
                        t = p.duration > 0 ? (i - m.start) / (m.end - m.start) : i >= m.start ? 1 : 0, h.trigger("update", {
                            startPos: m.start,
                            endPos: m.end,
                            scrollPos: i
                        }), h.progress(t)
                    } else E && f === c && $(!0);
            else r.updateScene(h, !1);
            return h
        }, this.refresh = function () {
            return x(), C(), h
        }, this.progress = function (e) {
            if (arguments.length) {
                var t = !1,
                    i = f,
                    n = r ? r.info("scrollDirection") : "PAUSED",
                    o = p.reverse || e >= g;
                if (0 === p.duration ? (t = g != e, g = 1 > e && o ? 0 : 1, f = 0 === g ? l : c) : 0 > e && f !== l && o ? (g = 0, f = l, t = !0) : e >= 0 && 1 > e && o ? (g = e, f = c, t = !0) : e >= 1 && f !== d ? (g = 1, f = d, t = !0) : f !== c || o || $(), t) {
                    var s = {
                            progress: g,
                            state: f,
                            scrollDirection: n
                        },
                        a = f != i,
                        u = function (e) {
                            h.trigger(e, s)
                        };
                    a && i !== c && (u("enter"), u(i === l ? "start" : "end")), u("progress"), a && f !== c && (u(f === l ? "start" : "end"), u("leave"))
                }
                return h
            }
            return g
        };
        var _ = function () {
                m = {
                    start: v + p.offset
                }, r && p.triggerElement && (m.start -= r.info("size") * p.triggerHook), m.end = m.start + p.duration
            },
            x = function (e) {
                if (s) {
                    var t = "duration";
                    M(t, s.call(h)) && !e && (h.trigger("change", {
                        what: t,
                        newval: p[t]
                    }), h.trigger("shift", {
                        reason: t
                    }))
                }
            },
            C = function (e) {
                var i = 0,
                    n = p.triggerElement;
                if (r && n) {
                    for (var s = r.info(), a = o.get.offset(s.container), l = s.vertical ? "top" : "left"; n.parentNode.hasAttribute(t);) n = n.parentNode;
                    var c = o.get.offset(n);
                    s.isDocument || (a[l] -= r.scrollPos()), i = c[l] - a[l]
                }
                var d = i != v;
                v = i, d && !e && h.trigger("shift", {
                    reason: "triggerElementPosition"
                })
            },
            T = function (e) {
                p.triggerHook > 0 && h.trigger("shift", {
                    reason: "containerResize"
                })
            },
            S = o.extend(n.validate, {
                duration: function (e) {
                    if (o.type.String(e) && e.match(/^(\.|\d)*\d+%$/)) {
                        var t = parseFloat(e) / 100;
                        e = function () {
                            return r ? r.info("size") * t : 0
                        }
                    }
                    if (o.type.Function(e)) {
                        s = e;
                        try {
                            e = parseFloat(s())
                        } catch (i) {
                            e = -1
                        }
                    }
                    if (e = parseFloat(e), !o.type.Number(e) || 0 > e) throw s ? (s = void 0, ['Invalid return value of supplied function for option "duration":', e]) : ['Invalid value for option "duration":', e];
                    return e
                }
            }),
            D = function (e) {
                e = arguments.length ? [e] : Object.keys(S), e.forEach(function (e, t) {
                    var i;
                    if (S[e]) try {
                        i = S[e](p[e])
                    } catch (n) {
                        i = u[e];
                        var s = o.type.String(n) ? [n] : n;
                        o.type.Array(s) ? (s[0] = "ERROR: " + s[0], s.unshift(1), k.apply(this, s)) : k(1, "ERROR: Problem executing validation callback for option '" + e + "':", n.message)
                    } finally {
                        p[e] = i
                    }
                })
            },
            M = function (e, t) {
                var i = !1,
                    n = p[e];
                return p[e] != t && (p[e] = t, D(e), i = n != p[e]), i
            },
            I = function (e) {
                h[e] || (h[e] = function (t) {
                    return arguments.length ? ("duration" === e && (s = void 0), M(e, t) && (h.trigger("change", {
                        what: e,
                        newval: p[e]
                    }), n.shifts.indexOf(e) > -1 && h.trigger("shift", {
                        reason: e
                    })), h) : p[e]
                })
            };
        this.controller = function () {
            return r
        }, this.state = function () {
            return f
        }, this.scrollOffset = function () {
            return m.start
        }, this.triggerPosition = function () {
            var e = p.offset;
            return r && (e += p.triggerElement ? v : r.info("size") * h.triggerHook()), e
        };
        var E, A;
        h.on("shift.internal", function (e) {
            var t = "duration" === e.reason;
            (f === d && t || f === c && 0 === p.duration) && $(), t && O()
        }).on("progress.internal", function (e) {
            $()
        }).on("add.internal", function (e) {
            O()
        }).on("destroy.internal", function (e) {
            h.removePin(e.reset)
        });
        var $ = function (e) {
                if (E && r) {
                    var t = r.info(),
                        i = A.spacer.firstChild;
                    if (e || f !== c) {
                        var n = {
                                position: A.inFlow ? "relative" : "absolute",
                                top: 0,
                                left: 0
                            },
                            s = o.css(i, "position") != n.position;
                        A.pushFollowers ? p.duration > 0 && (f === d && 0 === parseFloat(o.css(A.spacer, "padding-top")) ? s = !0 : f === l && 0 === parseFloat(o.css(A.spacer, "padding-bottom")) && (s = !0)) : n[t.vertical ? "top" : "left"] = p.duration * g, o.css(i, n), s && O()
                    } else {
                        "fixed" != o.css(i, "position") && (o.css(i, {
                            position: "fixed"
                        }), O());
                        var a = o.get.offset(A.spacer, !0),
                            u = p.reverse || 0 === p.duration ? t.scrollPos - m.start : Math.round(g * p.duration * 10) / 10;
                        a[t.vertical ? "top" : "left"] += u, o.css(A.spacer.firstChild, {
                            top: a.top,
                            left: a.left
                        })
                    }
                }
            },
            O = function () {
                if (E && r && A.inFlow) {
                    var e = f === c,
                        t = r.info("vertical"),
                        i = A.spacer.firstChild,
                        n = o.isMarginCollapseType(o.css(A.spacer, "display")),
                        s = {};
                    A.relSize.width || A.relSize.autoFullWidth ? e ? o.css(E, {
                        width: o.get.width(A.spacer)
                    }) : o.css(E, {
                        width: "100%"
                    }) : (s["min-width"] = o.get.width(t ? E : i, !0, !0), s.width = e ? s["min-width"] : "auto"), A.relSize.height ? e ? o.css(E, {
                        height: o.get.height(A.spacer) - (A.pushFollowers ? p.duration : 0)
                    }) : o.css(E, {
                        height: "100%"
                    }) : (s["min-height"] = o.get.height(t ? i : E, !0, !n), s.height = e ? s["min-height"] : "auto"), A.pushFollowers && (s["padding" + (t ? "Top" : "Left")] = p.duration * g, s["padding" + (t ? "Bottom" : "Right")] = p.duration * (1 - g)), o.css(A.spacer, s)
                }
            },
            H = function () {
                r && E && f === c && !r.info("isDocument") && $()
            },
            P = function () {
                r && E && f === c && ((A.relSize.width || A.relSize.autoFullWidth) && o.get.width(window) != o.get.width(A.spacer.parentNode) || A.relSize.height && o.get.height(window) != o.get.height(A.spacer.parentNode)) && O()
            },
            N = function (e) {
                r && E && f === c && !r.info("isDocument") && (e.preventDefault(), r._setScrollPos(r.info("scrollPos") - ((e.wheelDelta || e[r.info("vertical") ? "wheelDeltaY" : "wheelDeltaX"]) / 3 || 30 * -e.detail)))
            };
        this.setPin = function (e, i) {
            var n = {
                pushFollowers: !0,
                spacerClass: "scrollmagic-pin-spacer"
            };
            if (i = o.extend({}, n, i), e = o.get.elements(e)[0], !e) return k(1, "ERROR calling method 'setPin()': Invalid pin element supplied."), h;
            if ("fixed" === o.css(e, "position")) return k(1, "ERROR calling method 'setPin()': Pin does not work with elements that are positioned 'fixed'."), h;
            if (E) {
                if (E === e) return h;
                h.removePin()
            }
            E = e;
            var s = E.parentNode.style.display,
                r = ["top", "left", "bottom", "right", "margin", "marginLeft", "marginRight", "marginTop", "marginBottom"];
            E.parentNode.style.display = "none";
            var a = "absolute" != o.css(E, "position"),
                l = o.css(E, r.concat(["display"])),
                c = o.css(E, ["width", "height"]);
            E.parentNode.style.display = s, !a && i.pushFollowers && (k(2, "WARNING: If the pinned element is positioned absolutely pushFollowers will be disabled."), i.pushFollowers = !1), window.setTimeout(function () {
                E && 0 === p.duration && i.pushFollowers && k(2, "WARNING: pushFollowers =", !0, "has no effect, when scene duration is 0.")
            }, 0);
            var d = E.parentNode.insertBefore(document.createElement("div"), E),
                u = o.extend(l, {
                    position: a ? "relative" : "absolute",
                    boxSizing: "content-box",
                    mozBoxSizing: "content-box",
                    webkitBoxSizing: "content-box"
                });
            if (a || o.extend(u, o.css(E, ["width", "height"])), o.css(d, u), d.setAttribute(t, ""), o.addClass(d, i.spacerClass), A = {
                    spacer: d,
                    relSize: {
                        width: "%" === c.width.slice(-1),
                        height: "%" === c.height.slice(-1),
                        autoFullWidth: "auto" === c.width && a && o.isMarginCollapseType(l.display)
                    },
                    pushFollowers: i.pushFollowers,
                    inFlow: a
                }, !E.___origStyle) {
                E.___origStyle = {};
                var f = E.style,
                    g = r.concat(["width", "height", "position", "boxSizing", "mozBoxSizing", "webkitBoxSizing"]);
                g.forEach(function (e) {
                    E.___origStyle[e] = f[e] || ""
                })
            }
            return A.relSize.width && o.css(d, {
                width: c.width
            }), A.relSize.height && o.css(d, {
                height: c.height
            }), d.appendChild(E), o.css(E, {
                position: a ? "relative" : "absolute",
                margin: "auto",
                top: "auto",
                left: "auto",
                bottom: "auto",
                right: "auto"
            }), (A.relSize.width || A.relSize.autoFullWidth) && o.css(E, {
                boxSizing: "border-box",
                mozBoxSizing: "border-box",
                webkitBoxSizing: "border-box"
            }), window.addEventListener("scroll", H), window.addEventListener("resize", H), window.addEventListener("resize", P), E.addEventListener("mousewheel", N), E.addEventListener("DOMMouseScroll", N), k(3, "added pin"), $(), h
        }, this.removePin = function (e) {
            if (E) {
                if (f === c && $(!0), e || !r) {
                    var i = A.spacer.firstChild;
                    if (i.hasAttribute(t)) {
                        var n = A.spacer.style,
                            s = ["margin", "marginLeft", "marginRight", "marginTop", "marginBottom"];
                        margins = {}, s.forEach(function (e) {
                            margins[e] = n[e] || ""
                        }), o.css(i, margins)
                    }
                    A.spacer.parentNode.insertBefore(i, A.spacer), A.spacer.parentNode.removeChild(A.spacer), E.parentNode.hasAttribute(t) || (o.css(E, E.___origStyle), delete E.___origStyle)
                }
                window.removeEventListener("scroll", H), window.removeEventListener("resize", H), window.removeEventListener("resize", P), E.removeEventListener("mousewheel", N), E.removeEventListener("DOMMouseScroll", N), E = void 0, k(3, "removed pin (reset: " + (e ? "true" : "false") + ")")
            }
            return h
        };
        var L, W = [];
        return h.on("destroy.internal", function (e) {
            h.removeClassToggle(e.reset)
        }), this.setClassToggle = function (e, t) {
            var i = o.get.elements(e);
            return 0 !== i.length && o.type.String(t) ? (W.length > 0 && h.removeClassToggle(), L = t, W = i, h.on("enter.internal_class leave.internal_class", function (e) {
                var t = "enter" === e.type ? o.addClass : o.removeClass;
                W.forEach(function (e, i) {
                    t(e, L)
                })
            }), h) : (k(1, "ERROR calling method 'setClassToggle()': Invalid " + (0 === i.length ? "element" : "classes") + " supplied."), h)
        }, this.removeClassToggle = function (e) {
            return e && W.forEach(function (e, t) {
                o.removeClass(e, L)
            }), h.off("start.internal_class end.internal_class"), L = void 0, W = [], h
        }, b(), h
    };
    var n = {
        defaults: {
            duration: 0,
            offset: 0,
            triggerElement: void 0,
            triggerHook: .5,
            reverse: !0,
            loglevel: 2
        },
        validate: {
            offset: function (e) {
                if (e = parseFloat(e), !o.type.Number(e)) throw ['Invalid value for option "offset":', e];
                return e
            },
            triggerElement: function (e) {
                if (e = e || void 0) {
                    var t = o.get.elements(e)[0];
                    if (!t) throw ['Element defined in option "triggerElement" was not found:', e];
                    e = t
                }
                return e
            },
            triggerHook: function (e) {
                var t = {
                    onCenter: .5,
                    onEnter: 1,
                    onLeave: 0
                };
                if (o.type.Number(e)) e = Math.max(0, Math.min(parseFloat(e), 1));
                else {
                    if (!(e in t)) throw ['Invalid value for option "triggerHook": ', e];
                    e = t[e]
                }
                return e
            },
            reverse: function (e) {
                return !!e
            },
            loglevel: function (e) {
                if (e = parseInt(e), !o.type.Number(e) || 0 > e || e > 3) throw ['Invalid value for option "loglevel":', e];
                return e
            }
        },
        shifts: ["duration", "offset", "triggerHook"]
    };
    e.Scene.addOption = function (t, i, o, s) {
        t in n.defaults ? e._util.log(1, "[static] ScrollMagic.Scene -> Cannot add Scene option '" + t + "', because it already exists.") : (n.defaults[t] = i, n.validate[t] = o, s && n.shifts.push(t))
    }, e.Scene.extend = function (t) {
        var i = this;
        e.Scene = function () {
            return i.apply(this, arguments), this.$super = o.extend({}, this), t.apply(this, arguments) || this
        }, o.extend(e.Scene, i), e.Scene.prototype = i.prototype, e.Scene.prototype.constructor = e.Scene
    }, e.Event = function (e, t, i, n) {
        n = n || {};
        for (var o in n) this[o] = n[o];
        return this.type = e, this.target = this.currentTarget = i, this.namespace = t || "", this.timeStamp = this.timestamp = Date.now(), this
    };
    var o = e._util = function (e) {
        var t, i = {},
            n = function (e) {
                return parseFloat(e) || 0
            },
            o = function (t) {
                return t.currentStyle ? t.currentStyle : e.getComputedStyle(t)
            },
            s = function (t, i, s, r) {
                if (i = i === document ? e : i, i === e) r = !1;
                else if (!f.DomElement(i)) return 0;
                t = t.charAt(0).toUpperCase() + t.substr(1).toLowerCase();
                var a = (s ? i["offset" + t] || i["outer" + t] : i["client" + t] || i["inner" + t]) || 0;
                if (s && r) {
                    var l = o(i);
                    a += "Height" === t ? n(l.marginTop) + n(l.marginBottom) : n(l.marginLeft) + n(l.marginRight)
                }
                return a
            },
            r = function (e) {
                return e.replace(/^[^a-z]+([a-z])/g, "$1").replace(/-([a-z])/g, function (e) {
                    return e[1].toUpperCase()
                })
            };
        i.extend = function (e) {
            for (e = e || {}, t = 1; t < arguments.length; t++)
                if (arguments[t])
                    for (var i in arguments[t]) arguments[t].hasOwnProperty(i) && (e[i] = arguments[t][i]);
            return e
        }, i.isMarginCollapseType = function (e) {
            return ["block", "flex", "list-item", "table", "-webkit-box"].indexOf(e) > -1
        };
        var a = 0,
            l = ["ms", "moz", "webkit", "o"],
            c = e.requestAnimationFrame,
            d = e.cancelAnimationFrame;
        for (t = 0; !c && t < l.length; ++t) c = e[l[t] + "RequestAnimationFrame"], d = e[l[t] + "CancelAnimationFrame"] || e[l[t] + "CancelRequestAnimationFrame"];
        c || (c = function (t) {
            var i = (new Date).getTime(),
                n = Math.max(0, 16 - (i - a)),
                o = e.setTimeout(function () {
                    t(i + n)
                }, n);
            return a = i + n, o
        }), d || (d = function (t) {
            e.clearTimeout(t)
        }), i.rAF = c.bind(e), i.cAF = d.bind(e);
        var u = ["error", "warn", "log"],
            h = e.console || {};
        for (h.log = h.log || function () {}, t = 0; t < u.length; t++) {
            var p = u[t];
            h[p] || (h[p] = h.log)
        }
        i.log = function (e) {
            (e > u.length || 0 >= e) && (e = u.length);
            var t = new Date,
                i = ("0" + t.getHours()).slice(-2) + ":" + ("0" + t.getMinutes()).slice(-2) + ":" + ("0" + t.getSeconds()).slice(-2) + ":" + ("00" + t.getMilliseconds()).slice(-3),
                n = u[e - 1],
                o = Array.prototype.splice.call(arguments, 1),
                s = Function.prototype.bind.call(h[n], h);
            o.unshift(i), s.apply(h, o)
        };
        var f = i.type = function (e) {
            return Object.prototype.toString.call(e).replace(/^\[object (.+)\]$/, "$1").toLowerCase()
        };
        f.String = function (e) {
            return "string" === f(e)
        }, f.Function = function (e) {
            return "function" === f(e)
        }, f.Array = function (e) {
            return Array.isArray(e)
        }, f.Number = function (e) {
            return !f.Array(e) && e - parseFloat(e) + 1 >= 0
        }, f.DomElement = function (e) {
            return "object" == typeof HTMLElement ? e instanceof HTMLElement : e && "object" == typeof e && null !== e && 1 === e.nodeType && "string" == typeof e.nodeName
        };
        var g = i.get = {};
        return g.elements = function (t) {
            var i = [];
            if (f.String(t)) try {
                t = document.querySelectorAll(t)
            } catch (n) {
                return i
            }
            if ("nodelist" === f(t) || f.Array(t))
                for (var o = 0, s = i.length = t.length; s > o; o++) {
                    var r = t[o];
                    i[o] = f.DomElement(r) ? r : g.elements(r)
                } else(f.DomElement(t) || t === document || t === e) && (i = [t]);
            return i
        }, g.scrollTop = function (t) {
            return t && "number" == typeof t.scrollTop ? t.scrollTop : e.pageYOffset || 0
        }, g.scrollLeft = function (t) {
            return t && "number" == typeof t.scrollLeft ? t.scrollLeft : e.pageXOffset || 0
        }, g.width = function (e, t, i) {
            return s("width", e, t, i)
        }, g.height = function (e, t, i) {
            return s("height", e, t, i)
        }, g.offset = function (e, t) {
            var i = {
                top: 0,
                left: 0
            };
            if (e && e.getBoundingClientRect) {
                var n = e.getBoundingClientRect();
                i.top = n.top, i.left = n.left, t || (i.top += g.scrollTop(), i.left += g.scrollLeft())
            }
            return i
        }, i.addClass = function (e, t) {
            t && (e.classList ? e.classList.add(t) : e.className += " " + t)
        }, i.removeClass = function (e, t) {
            t && (e.classList ? e.classList.remove(t) : e.className = e.className.replace(new RegExp("(^|\\b)" + t.split(" ").join("|") + "(\\b|$)", "gi"), " "))
        }, i.css = function (e, t) {
            if (f.String(t)) return o(e)[r(t)];
            if (f.Array(t)) {
                var i = {},
                    n = o(e);
                return t.forEach(function (e, t) {
                    i[e] = n[r(e)]
                }), i
            }
            for (var s in t) {
                var a = t[s];
                a == parseFloat(a) && (a += "px"), e.style[r(s)] = a
            }
        }, i
    }(window || {});
    return e.Scene.prototype.addIndicators = function () {
        return e._util.log(1, "(ScrollMagic.Scene) -> ERROR calling addIndicators() due to missing Plugin 'debug.addIndicators'. Please make sure to include plugins/debug.addIndicators.js"), this
    }, e.Scene.prototype.removeIndicators = function () {
        return e._util.log(1, "(ScrollMagic.Scene) -> ERROR calling removeIndicators() due to missing Plugin 'debug.addIndicators'. Please make sure to include plugins/debug.addIndicators.js"), this
    }, e.Scene.prototype.setTween = function () {
        return e._util.log(1, "(ScrollMagic.Scene) -> ERROR calling setTween() due to missing Plugin 'animation.gsap'. Please make sure to include plugins/animation.gsap.js"), this
    }, e.Scene.prototype.removeTween = function () {
        return e._util.log(1, "(ScrollMagic.Scene) -> ERROR calling removeTween() due to missing Plugin 'animation.gsap'. Please make sure to include plugins/animation.gsap.js"), this
    }, e.Scene.prototype.setVelocity = function () {
        return e._util.log(1, "(ScrollMagic.Scene) -> ERROR calling setVelocity() due to missing Plugin 'animation.velocity'. Please make sure to include plugins/animation.velocity.js"), this
    }, e.Scene.prototype.removeVelocity = function () {
        return e._util.log(1, "(ScrollMagic.Scene) -> ERROR calling removeVelocity() due to missing Plugin 'animation.velocity'. Please make sure to include plugins/animation.velocity.js"), this
    }, e
}), "function" != typeof Object.create && (Object.create = function (e) {
    function t() {}
    return t.prototype = e, new t
});
var ua = {
    toString: function () {
        return navigator.userAgent
    },
    test: function (e) {
        return this.toString().toLowerCase().indexOf(e.toLowerCase()) > -1
    }
};
ua.version = (ua.toString().toLowerCase().match(/[\s\S]+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [])[1], ua.webkit = ua.test("webkit"), ua.gecko = ua.test("gecko") && !ua.webkit, ua.opera = ua.test("opera"), ua.ie = ua.test("msie") && !ua.opera, ua.ie6 = ua.ie && document.compatMode && "undefined" == typeof document.documentElement.style.maxHeight, ua.ie7 = ua.ie && document.documentElement && "undefined" != typeof document.documentElement.style.maxHeight && "undefined" == typeof XDomainRequest, ua.ie8 = ua.ie && "undefined" != typeof XDomainRequest;
var domReady = function () {
        var e = [],
            t = function () {
                if (!arguments.callee.done) {
                    arguments.callee.done = !0;
                    for (var t = 0; t < e.length; t++) e[t]()
                }
            };
        return document.addEventListener && document.addEventListener("DOMContentLoaded", t, !1), ua.ie && (! function () {
                try {
                    document.documentElement.doScroll("left")
                } catch (e) {
                    return void setTimeout(arguments.callee, 50)
                }
                t()
            }(), document.onreadystatechange = function () {
                "complete" === document.readyState && (document.onreadystatechange = null, t())
            }), ua.webkit && document.readyState && ! function () {
                "loading" !== document.readyState ? t() : setTimeout(arguments.callee, 10)
            }(), window.onload = t,
            function (t) {
                return "function" == typeof t && (e[e.length] = t), t
            }
    }(),
    cssHelper = function () {
        var e, t = {
                BLOCKS: /[^\s{][^{]*\{(?:[^{}]*\{[^{}]*\}[^{}]*|[^{}]*)*\}/g,
                BLOCKS_INSIDE: /[^\s{][^{]*\{[^{}]*\}/g,
                DECLARATIONS: /[a-zA-Z\-]+[^;]*:[^;]+;/g,
                RELATIVE_URLS: /url\(['"]?([^\/\)'"][^:\)'"]+)['"]?\)/g,
                REDUNDANT_COMPONENTS: /(?:\/\*([^*\\\\]|\*(?!\/))+\*\/|@import[^;]+;)/g,
                REDUNDANT_WHITESPACE: /\s*(,|:|;|\{|\})\s*/g,
                MORE_WHITESPACE: /\s{2,}/g,
                FINAL_SEMICOLONS: /;\}/g,
                NOT_WHITESPACE: /\S+/g
            },
            i = !1,
            n = [],
            o = function (e) {
                "function" == typeof e && (n[n.length] = e)
            },
            s = function () {
                for (var t = 0; t < n.length; t++) n[t](e)
            },
            r = {},
            a = function (e, t) {
                if (r[e]) {
                    var i = r[e].listeners;
                    if (i)
                        for (var n = 0; n < i.length; n++) i[n](t)
                }
            },
            l = function (e, t, i) {
                if (ua.ie && !window.XMLHttpRequest && (window.XMLHttpRequest = function () {
                        return new ActiveXObject("Microsoft.XMLHTTP")
                    }), !XMLHttpRequest) return "";
                var n = new XMLHttpRequest;
                try {
                    n.open("get", e, !0), n.setRequestHeader("X_REQUESTED_WITH", "XMLHttpRequest")
                } catch (o) {
                    return void i()
                }
                var s = !1;
                setTimeout(function () {
                    s = !0
                }, 5e3), document.documentElement.style.cursor = "progress", n.onreadystatechange = function () {
                    4 !== n.readyState || s || (!n.status && "file:" === location.protocol || n.status >= 200 && n.status < 300 || 304 === n.status || navigator.userAgent.indexOf("Safari") > -1 && "undefined" == typeof n.status ? t(n.responseText) : i(), document.documentElement.style.cursor = "", n = null)
                }, n.send("")
            },
            c = function (e) {
                return e = e.replace(t.REDUNDANT_COMPONENTS, ""), e = e.replace(t.REDUNDANT_WHITESPACE, "$1"), e = e.replace(t.MORE_WHITESPACE, " "), e = e.replace(t.FINAL_SEMICOLONS, "}")
            },
            d = {
                mediaQueryList: function (e) {
                    var i = {},
                        n = e.indexOf("{"),
                        o = e.substring(0, n);
                    e = e.substring(n + 1, e.length - 1);
                    for (var s = [], r = [], a = o.toLowerCase().substring(7).split(","), l = 0; l < a.length; l++) s[s.length] = d.mediaQuery(a[l], i);
                    var c = e.match(t.BLOCKS_INSIDE);
                    if (null !== c)
                        for (l = 0; l < c.length; l++) r[r.length] = d.rule(c[l], i);
                    return i.getMediaQueries = function () {
                        return s
                    }, i.getRules = function () {
                        return r
                    }, i.getListText = function () {
                        return o
                    }, i.getCssText = function () {
                        return e
                    }, i
                },
                mediaQuery: function (e, i) {
                    e = e || "";
                    for (var n, o = !1, s = [], r = !0, a = e.match(t.NOT_WHITESPACE), l = 0; l < a.length; l++) {
                        var c = a[l];
                        if (n || "not" !== c && "only" !== c)
                            if (n) {
                                if ("(" === c.charAt(0)) {
                                    var d = c.substring(1, c.length - 1).split(":");
                                    s[s.length] = {
                                        mediaFeature: d[0],
                                        value: d[1] || null
                                    }
                                }
                            } else n = c;
                        else "not" === c && (o = !0)
                    }
                    return {
                        getList: function () {
                            return i || null
                        },
                        getValid: function () {
                            return r
                        },
                        getNot: function () {
                            return o
                        },
                        getMediaType: function () {
                            return n
                        },
                        getExpressions: function () {
                            return s
                        }
                    }
                },
                rule: function (e, t) {
                    for (var i = {}, n = e.indexOf("{"), o = e.substring(0, n), s = o.split(","), r = [], a = e.substring(n + 1, e.length - 1).split(";"), l = 0; l < a.length; l++) r[r.length] = d.declaration(a[l], i);
                    return i.getMediaQueryList = function () {
                        return t || null
                    }, i.getSelectors = function () {
                        return s
                    }, i.getSelectorText = function () {
                        return o
                    }, i.getDeclarations = function () {
                        return r
                    }, i.getPropertyValue = function (e) {
                        for (var t = 0; t < r.length; t++)
                            if (r[t].getProperty() === e) return r[t].getValue();
                        return null
                    }, i
                },
                declaration: function (e, t) {
                    var i = e.indexOf(":"),
                        n = e.substring(0, i),
                        o = e.substring(i + 1);
                    return {
                        getRule: function () {
                            return t || null
                        },
                        getProperty: function () {
                            return n
                        },
                        getValue: function () {
                            return o
                        }
                    }
                }
            },
            u = function (i) {
                if ("string" == typeof i.cssHelperText) {
                    var n = {
                            mediaQueryLists: [],
                            rules: [],
                            selectors: {},
                            declarations: [],
                            properties: {}
                        },
                        o = n.mediaQueryLists,
                        s = n.rules,
                        r = i.cssHelperText.match(t.BLOCKS);
                    if (null !== r)
                        for (var a = 0; a < r.length; a++) "@media " === r[a].substring(0, 7) ? (o[o.length] = d.mediaQueryList(r[a]), s = n.rules = s.concat(o[o.length - 1].getRules())) : s[s.length] = d.rule(r[a]);
                    var l = n.selectors,
                        c = function (e) {
                            for (var t = e.getSelectors(), i = 0; i < t.length; i++) {
                                var n = t[i];
                                l[n] || (l[n] = []), l[n][l[n].length] = e
                            }
                        };
                    for (a = 0; a < s.length; a++) c(s[a]);
                    var u = n.declarations;
                    for (a = 0; a < s.length; a++) u = n.declarations = u.concat(s[a].getDeclarations());
                    var h = n.properties;
                    for (a = 0; a < u.length; a++) {
                        var p = u[a].getProperty();
                        h[p] || (h[p] = []), h[p][h[p].length] = u[a]
                    }
                    return i.cssHelperParsed = n, e[e.length] = i, n
                }
            },
            h = function (e, t) {
                return e.cssHelperText = c(t || e.innerHTML), u(e)
            },
            p = function () {
                i = !0, e = [];
                for (var n = [], o = function () {
                        for (var e = 0; e < n.length; e++) u(n[e]);
                        var t = document.getElementsByTagName("style");
                        for (e = 0; e < t.length; e++) h(t[e]);
                        i = !1, s()
                    }, r = document.getElementsByTagName("link"), a = 0; a < r.length; a++) {
                    var d = r[a];
                    d.getAttribute("rel").indexOf("style") > -1 && d.href && 0 !== d.href.length && !d.disabled && (n[n.length] = d)
                }
                if (n.length > 0) {
                    var p = 0,
                        f = function () {
                            p++, p === n.length && o()
                        },
                        g = function (e) {
                            var i = e.href;
                            l(i, function (n) {
                                n = c(n).replace(t.RELATIVE_URLS, "url(" + i.substring(0, i.lastIndexOf("/")) + "/$1)"), e.cssHelperText = n, f()
                            }, f)
                        };
                    for (a = 0; a < n.length; a++) g(n[a])
                } else o()
            },
            f = {
                mediaQueryLists: "array",
                rules: "array",
                selectors: "object",
                declarations: "array",
                properties: "object"
            },
            g = {
                mediaQueryLists: null,
                rules: null,
                selectors: null,
                declarations: null,
                properties: null
            },
            m = function (e, t) {
                if (null !== g[e]) {
                    if ("array" === f[e]) return g[e] = g[e].concat(t);
                    var i = g[e];
                    for (var n in t) t.hasOwnProperty(n) && (i[n] ? i[n] = i[n].concat(t[n]) : i[n] = t[n]);
                    return i
                }
            },
            v = function (t) {
                g[t] = "array" === f[t] ? [] : {};
                for (var i = 0; i < e.length; i++) m(t, e[i].cssHelperParsed[t]);
                return g[t]
            };
        domReady(function () {
            for (var e = document.body.getElementsByTagName("*"), t = 0; t < e.length; t++) e[t].checkedByCssHelper = !0;
            document.implementation.hasFeature("MutationEvents", "2.0") || window.MutationEvent ? document.body.addEventListener("DOMNodeInserted", function (e) {
                var t = e.target;
                1 === t.nodeType && (a("DOMElementInserted", t), t.checkedByCssHelper = !0)
            }, !1) : setInterval(function () {
                for (var e = document.body.getElementsByTagName("*"), t = 0; t < e.length; t++) e[t].checkedByCssHelper || (a("DOMElementInserted", e[t]), e[t].checkedByCssHelper = !0)
            }, 1e3)
        });
        var y = function (e) {
            return "undefined" != typeof window.innerWidth ? window["inner" + e] : "undefined" != typeof document.documentElement && "undefined" != typeof document.documentElement.clientWidth && 0 != document.documentElement.clientWidth ? document.documentElement["client" + e] : void 0
        };
        return {
            addStyle: function (e, t) {
                var i = document.createElement("style");
                return i.setAttribute("type", "text/css"), document.getElementsByTagName("head")[0].appendChild(i), i.styleSheet ? i.styleSheet.cssText = e : i.appendChild(document.createTextNode(e)), i.addedWithCssHelper = !0, "undefined" == typeof t || t === !0 ? cssHelper.parsed(function (t) {
                    var n = h(i, e);
                    for (var o in n) n.hasOwnProperty(o) && m(o, n[o]);
                    a("newStyleParsed", i)
                }) : i.parsingDisallowed = !0, i
            },
            removeStyle: function (e) {
                return e.parentNode.removeChild(e)
            },
            parsed: function (t) {
                i ? o(t) : "undefined" != typeof e ? "function" == typeof t && t(e) : (o(t), p())
            },
            mediaQueryLists: function (e) {
                cssHelper.parsed(function (t) {
                    e(g.mediaQueryLists || v("mediaQueryLists"))
                })
            },
            rules: function (e) {
                cssHelper.parsed(function (t) {
                    e(g.rules || v("rules"))
                })
            },
            selectors: function (e) {
                cssHelper.parsed(function (t) {
                    e(g.selectors || v("selectors"))
                })
            },
            declarations: function (e) {
                cssHelper.parsed(function (t) {
                    e(g.declarations || v("declarations"))
                })
            },
            properties: function (e) {
                cssHelper.parsed(function (t) {
                    e(g.properties || v("properties"))
                })
            },
            broadcast: a,
            addListener: function (e, t) {
                "function" == typeof t && (r[e] || (r[e] = {
                    listeners: []
                }), r[e].listeners[r[e].listeners.length] = t)
            },
            removeListener: function (e, t) {
                if ("function" == typeof t && r[e])
                    for (var i = r[e].listeners, n = 0; n < i.length; n++) i[n] === t && (i.splice(n, 1), n -= 1)
            },
            getViewportWidth: function () {
                return y("Width")
            },
            getViewportHeight: function () {
                return y("Height")
            }
        }
    }();
domReady(function () {
    var e, t = {
            LENGTH_UNIT: /[0-9]+(em|ex|px|in|cm|mm|pt|pc)$/,
            RESOLUTION_UNIT: /[0-9]+(dpi|dpcm)$/,
            ASPECT_RATIO: /^[0-9]+\/[0-9]+$/,
            ABSOLUTE_VALUE: /^[0-9]*(\.[0-9]+)*$/
        },
        i = [],
        n = function () {
            var e = "css3-mediaqueries-test",
                t = document.createElement("div");
            t.id = e;
            var i = cssHelper.addStyle("@media all and (width) { #" + e + " { width: 1px !important; } }", !1);
            document.body.appendChild(t);
            var o = 1 === t.offsetWidth;
            return i.parentNode.removeChild(i), t.parentNode.removeChild(t), n = function () {
                return o
            }, o
        },
        o = function () {
            e = document.createElement("div"), e.style.cssText = "position:absolute;top:-9999em;left:-9999em;margin:0;border:none;padding:0;width:1em;font-size:1em;", document.body.appendChild(e), 16 !== e.offsetWidth && (e.style.fontSize = 16 / e.offsetWidth + "em"), e.style.width = ""
        },
        s = function (t) {
            e.style.width = t;
            var i = e.offsetWidth;
            return e.style.width = "", i
        },
        r = function (e, i) {
            var n = e.length,
                o = "min-" === e.substring(0, 4),
                r = !o && "max-" === e.substring(0, 4);
            if (null !== i) {
                var a, l;
                if (t.LENGTH_UNIT.exec(i)) a = "length", l = s(i);
                else if (t.RESOLUTION_UNIT.exec(i)) {
                    a = "resolution", l = parseInt(i, 10);
                    var c = i.substring((l + "").length)
                } else t.ASPECT_RATIO.exec(i) ? (a = "aspect-ratio", l = i.split("/")) : t.ABSOLUTE_VALUE ? (a = "absolute", l = i) : a = "unknown"
            }
            var d, u;
            if ("device-width" === e.substring(n - 12, n)) return d = screen.width, null !== i ? "length" === a ? o && d >= l || r && l > d || !o && !r && d === l : !1 : d > 0;
            if ("device-height" === e.substring(n - 13, n)) return u = screen.height, null !== i ? "length" === a ? o && u >= l || r && l > u || !o && !r && u === l : !1 : u > 0;
            if ("width" === e.substring(n - 5, n)) return d = document.documentElement.clientWidth || document.body.clientWidth, null !== i ? "length" === a ? o && d >= l || r && l > d || !o && !r && d === l : !1 : d > 0;
            if ("height" === e.substring(n - 6, n)) return u = document.documentElement.clientHeight || document.body.clientHeight, null !== i ? "length" === a ? o && u >= l || r && l > u || !o && !r && u === l : !1 : u > 0;
            if ("device-aspect-ratio" === e.substring(n - 19, n)) return "aspect-ratio" === a && screen.width * l[1] === screen.height * l[0];
            if ("color-index" === e.substring(n - 11, n)) {
                var h = Math.pow(2, screen.colorDepth);
                return null !== i ? "absolute" === a ? o && h >= l || r && l > h || !o && !r && h === l : !1 : h > 0
            }
            if ("color" === e.substring(n - 5, n)) {
                var p = screen.colorDepth;
                return null !== i ? "absolute" === a ? o && p >= l || r && l > p || !o && !r && p === l : !1 : p > 0
            }
            if ("resolution" === e.substring(n - 10, n)) {
                var f;
                return f = s("dpcm" === c ? "1cm" : "1in"), null !== i ? "resolution" === a ? o && f >= l || r && l > f || !o && !r && f === l : !1 : f > 0
            }
            return !1
        },
        a = function (e) {
            var t = e.getValid(),
                i = e.getExpressions(),
                n = i.length;
            if (n > 0) {
                for (var o = 0; n > o && t; o++) t = r(i[o].mediaFeature, i[o].value);
                var s = e.getNot();
                return t && !s || s && !t
            }
        },
        l = function (e) {
            for (var t = e.getMediaQueries(), n = {}, o = 0; o < t.length; o++) a(t[o]) && (n[t[o].getMediaType()] = !0);
            var s = [],
                r = 0;
            for (var l in n) n.hasOwnProperty(l) && (r > 0 && (s[r++] = ","), s[r++] = l);
            s.length > 0 && (i[i.length] = cssHelper.addStyle("@media " + s.join("") + "{" + e.getCssText() + "}", !1))
        },
        c = function (e) {
            for (var t = 0; t < e.length; t++) l(e[t]);
            ua.ie ? (document.documentElement.style.display = "block", setTimeout(function () {
                document.documentElement.style.display = ""
            }, 0), setTimeout(function () {
                cssHelper.broadcast("cssMediaQueriesTested")
            }, 100)) : cssHelper.broadcast("cssMediaQueriesTested")
        },
        d = function () {
            for (var e = 0; e < i.length; e++) cssHelper.removeStyle(i[e]);
            i = [], cssHelper.mediaQueryLists(c)
        },
        u = 0,
        h = function () {
            var e = cssHelper.getViewportWidth(),
                t = cssHelper.getViewportHeight();
            if (ua.ie) {
                var i = document.createElement("div");
                i.style.position = "absolute", i.style.top = "-9999em", i.style.overflow = "scroll", document.body.appendChild(i), u = i.offsetWidth - i.clientWidth, document.body.removeChild(i)
            }
            var o, s = function () {
                var i = cssHelper.getViewportWidth(),
                    s = cssHelper.getViewportHeight();
                (Math.abs(i - e) > u || Math.abs(s - t) > u) && (e = i, t = s, clearTimeout(o), o = setTimeout(function () {
                    n() ? cssHelper.broadcast("cssMediaQueriesTested") : d()
                }, 500))
            };
            window.onresize = function () {
                var e = window.onresize || function () {};
                return function () {
                    e(), s()
                }
            }()
        },
        p = document.documentElement;
    return p.style.marginLeft = "-32767px", setTimeout(function () {
            p.style.marginTop = ""
        }, 2e4),
        function () {
            n() ? p.style.marginLeft = "" : (cssHelper.addListener("newStyleParsed", function (e) {
                c(e.cssHelperParsed.mediaQueryLists)
            }), cssHelper.addListener("cssMediaQueriesTested", function () {
                ua.ie && (p.style.width = "1px"), setTimeout(function () {
                    p.style.width = "", p.style.marginLeft = ""
                }, 0), cssHelper.removeListener("cssMediaQueriesTested", arguments.callee)
            }), o(), d()), h()
        }
}());
try {
    document.execCommand("BackgroundImageCache", !1, !0)
} catch (e) {}! function (e, t, i) {
    function n(i) {
        var n = t.console;
        s[i] || (s[i] = !0, e.migrateWarnings.push(i), n && n.warn && !e.migrateMute && (n.warn("JQMIGRATE: " + i), e.migrateTrace && n.trace && n.trace()))
    }

    function o(t, i, o, s) {
        if (Object.defineProperty) try {
            return void Object.defineProperty(t, i, {
                configurable: !0,
                enumerable: !0,
                get: function () {
                    return n(s), o
                },
                set: function (e) {
                    n(s), o = e
                }
            })
        } catch (r) {}
        e._definePropertyBroken = !0, t[i] = o
    }
    e.migrateVersion = "1.3.0";
    var s = {};
    e.migrateWarnings = [], e.migrateMute = !0, !e.migrateMute && t.console && t.console.log && t.console.log("JQMIGRATE: Logging is active"), e.migrateTrace === i && (e.migrateTrace = !0), e.migrateReset = function () {
        s = {}, e.migrateWarnings.length = 0
    }, "BackCompat" === document.compatMode && n("jQuery is not compatible with Quirks Mode");
    var r = e("<input/>", {
            size: 1
        }).attr("size") && e.attrFn,
        a = e.attr,
        l = e.attrHooks.value && e.attrHooks.value.get || function () {
            return null
        },
        c = e.attrHooks.value && e.attrHooks.value.set || function () {
            return i
        },
        d = /^(?:input|button)$/i,
        u = /^[238]$/,
        h = /^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i,
        p = /^(?:checked|selected)$/i;
    o(e, "attrFn", r || {}, "jQuery.attrFn is deprecated"), e.attr = function (t, o, s, l) {
        var c = o.toLowerCase(),
            f = t && t.nodeType;
        return l && (a.length < 4 && n("jQuery.fn.attr( props, pass ) is deprecated"), t && !u.test(f) && (r ? o in r : e.isFunction(e.fn[o]))) ? e(t)[o](s) : ("type" === o && s !== i && d.test(t.nodeName) && t.parentNode && n("Can't change the 'type' of an input or button in IE 6/7/8"), !e.attrHooks[c] && h.test(c) && (e.attrHooks[c] = {
            get: function (t, n) {
                var o, s = e.prop(t, n);
                return s === !0 || "boolean" != typeof s && (o = t.getAttributeNode(n)) && o.nodeValue !== !1 ? n.toLowerCase() : i
            },
            set: function (t, i, n) {
                var o;
                return i === !1 ? e.removeAttr(t, n) : (o = e.propFix[n] || n, o in t && (t[o] = !0), t.setAttribute(n, n.toLowerCase())), n
            }
        }, p.test(c) && n("jQuery.fn.attr('" + c + "') might use property instead of attribute")), a.call(e, t, o, s))
    }, e.attrHooks.value = {
        get: function (e, t) {
            var i = (e.nodeName || "").toLowerCase();
            return "button" === i ? l.apply(this, arguments) : ("input" !== i && "option" !== i && n("jQuery.fn.attr('value') no longer gets properties"), t in e ? e.value : null)
        },
        set: function (e, t) {
            var i = (e.nodeName || "").toLowerCase();
            return "button" === i ? c.apply(this, arguments) : ("input" !== i && "option" !== i && n("jQuery.fn.attr('value', val) no longer sets properties"), void(e.value = t))
        }
    };
    var f, g, m = e.fn.init,
        v = e.parseJSON,
        y = /^\s*</,
        b = /^([^<]*)(<[\w\W]+>)([^>]*)$/;
    e.fn.init = function (t, o, s) {
        var r, a;
        return t && "string" == typeof t && !e.isPlainObject(o) && (r = b.exec(e.trim(t))) && r[0] && (y.test(t) || n("$(html) HTML strings must start with '<' character"), r[3] && n("$(html) HTML text after last tag is ignored"), "#" === r[0].charAt(0) && (n("HTML string cannot start with a '#' character"), e.error("JQMIGRATE: Invalid selector string (XSS)")), o && o.context && (o = o.context), e.parseHTML) ? m.call(this, e.parseHTML(r[2], o && o.ownerDocument || o || document, !0), o, s) : ("#" === t && (n("jQuery( '#' ) is not a valid selector"), t = []), a = m.apply(this, arguments), t && t.selector !== i ? (a.selector = t.selector, a.context = t.context) : (a.selector = "string" == typeof t ? t : "", t && (a.context = t.nodeType ? t : o || document)), a)
    }, e.fn.init.prototype = e.fn, e.parseJSON = function (e) {
        return e ? v.apply(this, arguments) : (n("jQuery.parseJSON requires a valid JSON string"), null)
    }, e.uaMatch = function (e) {
        e = e.toLowerCase();
        var t = /(chrome)[ \/]([\w.]+)/.exec(e) || /(webkit)[ \/]([\w.]+)/.exec(e) || /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(e) || /(msie) ([\w.]+)/.exec(e) || e.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(e) || [];
        return {
            browser: t[1] || "",
            version: t[2] || "0"
        }
    }, e.browser || (f = e.uaMatch(navigator.userAgent), g = {}, f.browser && (g[f.browser] = !0, g.version = f.version), g.chrome ? g.webkit = !0 : g.webkit && (g.safari = !0), e.browser = g), o(e, "browser", e.browser, "jQuery.browser is deprecated"), e.boxModel = e.support.boxModel = "CSS1Compat" === document.compatMode, o(e, "boxModel", e.boxModel, "jQuery.boxModel is deprecated"), o(e.support, "boxModel", e.support.boxModel, "jQuery.support.boxModel is deprecated"), e.sub = function () {
        function t(e, i) {
            return new t.fn.init(e, i)
        }
        e.extend(!0, t, this), t.superclass = this, t.fn = t.prototype = this(), t.fn.constructor = t, t.sub = this.sub, t.fn.init = function (n, o) {
            var s = e.fn.init.call(this, n, o, i);
            return s instanceof t ? s : t(s)
        }, t.fn.init.prototype = t.fn;
        var i = t(document);
        return n("jQuery.sub() is deprecated"), t
    }, e.fn.size = function () {
        return n("jQuery.fn.size() is deprecated; use the .length property"), this.length
    };
    var w = !1;
    e.swap && e.each(["height", "width", "reliableMarginRight"], function (t, i) {
        var n = e.cssHooks[i] && e.cssHooks[i].get;
        n && (e.cssHooks[i].get = function () {
            var e;
            return w = !0, e = n.apply(this, arguments), w = !1, e
        })
    }), e.swap = function (e, t, i, o) {
        var s, r, a = {};
        w || n("jQuery.swap() is undocumented and deprecated");
        for (r in t) a[r] = e.style[r], e.style[r] = t[r];
        s = i.apply(e, o || []);
        for (r in t) e.style[r] = a[r];
        return s
    }, e.ajaxSetup({
        converters: {
            "text json": e.parseJSON
        }
    });
    var k = e.fn.data;
    e.fn.data = function (t) {
        var o, s, r = this[0];
        return !r || "events" !== t || 1 !== arguments.length || (o = e.data(r, t), s = e._data(r, t), o !== i && o !== s || s === i) ? k.apply(this, arguments) : (n("Use of jQuery.fn.data('events') is deprecated"), s)
    };
    var _ = /\/(java|ecma)script/i;
    e.clean || (e.clean = function (t, i, o, s) {
        i = i || document, i = !i.nodeType && i[0] || i, i = i.ownerDocument || i, n("jQuery.clean() is deprecated");
        var r, a, l, c, d = [];
        if (e.merge(d, e.buildFragment(t, i).childNodes), o)
            for (l = function (e) {
                    return !e.type || _.test(e.type) ? s ? s.push(e.parentNode ? e.parentNode.removeChild(e) : e) : o.appendChild(e) : void 0
                }, r = 0; null != (a = d[r]); r++) e.nodeName(a, "script") && l(a) || (o.appendChild(a), "undefined" != typeof a.getElementsByTagName && (c = e.grep(e.merge([], a.getElementsByTagName("script")), l), d.splice.apply(d, [r + 1, 0].concat(c)), r += c.length));
        return d
    });
    var x = e.event.add,
        C = e.event.remove,
        T = e.event.trigger,
        S = e.fn.toggle,
        D = e.fn.live,
        M = e.fn.die,
        I = e.fn.load,
        E = "ajaxStart|ajaxStop|ajaxSend|ajaxComplete|ajaxError|ajaxSuccess",
        A = new RegExp("\\b(?:" + E + ")\\b"),
        $ = /(?:^|\s)hover(\.\S+|)\b/,
        O = function (t) {
            return "string" != typeof t || e.event.special.hover ? t : ($.test(t) && n("'hover' pseudo-event is deprecated, use 'mouseenter mouseleave'"), t && t.replace($, "mouseenter$1 mouseleave$1"))
        };
    e.event.props && "attrChange" !== e.event.props[0] && e.event.props.unshift("attrChange", "attrName", "relatedNode", "srcElement"), e.event.dispatch && o(e.event, "handle", e.event.dispatch, "jQuery.event.handle is undocumented and deprecated"), e.event.add = function (e, t, i, o, s) {
        e !== document && A.test(t) && n("AJAX events should be attached to document: " + t), x.call(this, e, O(t || ""), i, o, s)
    }, e.event.remove = function (e, t, i, n, o) {
        C.call(this, e, O(t) || "", i, n, o)
    }, e.each(["load", "unload", "error"], function (t, i) {
        e.fn[i] = function () {
            var e = Array.prototype.slice.call(arguments, 0);
            return n("jQuery.fn." + i + "() is deprecated"), "load" === i && "string" == typeof arguments[0] ? I.apply(this, arguments) : (e.splice(0, 0, i), arguments.length ? this.bind.apply(this, e) : (this.triggerHandler.apply(this, e), this))
        }
    }), e.fn.toggle = function (t, i) {
        if (!e.isFunction(t) || !e.isFunction(i)) return S.apply(this, arguments);
        n("jQuery.fn.toggle(handler, handler...) is deprecated");
        var o = arguments,
            s = t.guid || e.guid++,
            r = 0,
            a = function (i) {
                var n = (e._data(this, "lastToggle" + t.guid) || 0) % r;
                return e._data(this, "lastToggle" + t.guid, n + 1), i.preventDefault(), o[n].apply(this, arguments) || !1
            };
        for (a.guid = s; r < o.length;) o[r++].guid = s;
        return this.click(a)
    }, e.fn.live = function (t, i, o) {
        return n("jQuery.fn.live() is deprecated"), D ? D.apply(this, arguments) : (e(this.context).on(t, this.selector, i, o), this)
    }, e.fn.die = function (t, i) {
        return n("jQuery.fn.die() is deprecated"), M ? M.apply(this, arguments) : (e(this.context).off(t, this.selector || "**", i), this)
    }, e.event.trigger = function (e, t, i, o) {
        return i || A.test(e) || n("Global events are undocumented and deprecated"), T.call(this, e, t, i || document, o)
    }, e.each(E.split("|"), function (t, i) {
        e.event.special[i] = {
            setup: function () {
                var t = this;
                return t !== document && (e.event.add(document, i + "." + e.guid, function () {
                    e.event.trigger(i, Array.prototype.slice.call(arguments, 1), t, !0)
                }), e._data(this, i, e.guid++)), !1
            },
            teardown: function () {
                return this !== document && e.event.remove(document, i + "." + e._data(this, i)), !1
            }
        }
    }), e.event.special.ready = {
        setup: function () {
            n("'ready' event is deprecated")
        }
    };
    var H = e.fn.andSelf || e.fn.addBack,
        P = e.fn.find;
    if (e.fn.andSelf = function () {
            return n("jQuery.fn.andSelf() replaced by jQuery.fn.addBack()"), H.apply(this, arguments)
        }, e.fn.find = function (e) {
            var t = P.apply(this, arguments);
            return t.context = this.context, t.selector = this.selector ? this.selector + " " + e : e, t
        }, e.Callbacks) {
        var N = e.Deferred,
            L = [
                ["resolve", "done", e.Callbacks("once memory"), e.Callbacks("once memory"), "resolved"],
                ["reject", "fail", e.Callbacks("once memory"), e.Callbacks("once memory"), "rejected"],
                ["notify", "progress", e.Callbacks("memory"), e.Callbacks("memory")]
            ];
        e.Deferred = function (t) {
            var i = N(),
                o = i.promise();
            return i.pipe = o.pipe = function () {
                var t = arguments;
                return n("deferred.pipe() is deprecated"), e.Deferred(function (n) {
                    e.each(L, function (s, r) {
                        var a = e.isFunction(t[s]) && t[s];
                        i[r[1]](function () {
                            var t = a && a.apply(this, arguments);
                            t && e.isFunction(t.promise) ? t.promise().done(n.resolve).fail(n.reject).progress(n.notify) : n[r[0] + "With"](this === o ? n.promise() : this, a ? [t] : arguments)
                        })
                    }), t = null
                }).promise()
            }, i.isResolved = function () {
                return n("deferred.isResolved is deprecated"), "resolved" === i.state()
            }, i.isRejected = function () {
                return n("deferred.isRejected is deprecated"), "rejected" === i.state()
            }, t && t.call(i, i), i
        }
    }
}(jQuery, window),
function (e) {
    "function" == typeof define && define.amd ? define(["jquery"], e) : e(jQuery)
}(function (e) {
    function t(t, n) {
        var o, s, r, a = t.nodeName.toLowerCase();
        return "area" === a ? (o = t.parentNode, s = o.name, t.href && s && "map" === o.nodeName.toLowerCase() ? (r = e("img[usemap='#" + s + "']")[0], !!r && i(r)) : !1) : (/^(input|select|textarea|button|object)$/.test(a) ? !t.disabled : "a" === a ? t.href || n : n) && i(t)
    }

    function i(t) {
        return e.expr.filters.visible(t) && !e(t).parents().addBack().filter(function () {
            return "hidden" === e.css(this, "visibility")
        }).length
    }

    function n(e) {
        for (var t, i; e.length && e[0] !== document;) {
            if (t = e.css("position"), ("absolute" === t || "relative" === t || "fixed" === t) && (i = parseInt(e.css("zIndex"), 10), !isNaN(i) && 0 !== i)) return i;
            e = e.parent()
        }
        return 0
    }

    function o() {
        this._curInst = null, this._keyEvent = !1, this._disabledInputs = [], this._datepickerShowing = !1, this._inDialog = !1, this._mainDivId = "ui-datepicker-div", this._inlineClass = "ui-datepicker-inline", this._appendClass = "ui-datepicker-append", this._triggerClass = "ui-datepicker-trigger", this._dialogClass = "ui-datepicker-dialog", this._disableClass = "ui-datepicker-disabled", this._unselectableClass = "ui-datepicker-unselectable", this._currentClass = "ui-datepicker-current-day", this._dayOverClass = "ui-datepicker-days-cell-over", this.regional = [], this.regional[""] = {
            closeText: "Done",
            prevText: "Prev",
            nextText: "Next",
            currentText: "Today",
            monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            monthNamesShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
            dayNamesShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            dayNamesMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
            weekHeader: "Wk",
            dateFormat: "mm/dd/yy",
            firstDay: 0,
            isRTL: !1,
            showMonthAfterYear: !1,
            yearSuffix: ""
        }, this._defaults = {
            showOn: "focus",
            showAnim: "fadeIn",
            showOptions: {},
            defaultDate: null,
            appendText: "",
            buttonText: "...",
            buttonImage: "",
            buttonImageOnly: !1,
            hideIfNoPrevNext: !1,
            navigationAsDateFormat: !1,
            gotoCurrent: !1,
            changeMonth: !1,
            changeYear: !1,
            yearRange: "c-10:c+10",
            showOtherMonths: !1,
            selectOtherMonths: !1,
            showWeek: !1,
            calculateWeek: this.iso8601Week,
            shortYearCutoff: "+10",
            minDate: null,
            maxDate: null,
            duration: "fast",
            beforeShowDay: null,
            beforeShow: null,
            onSelect: null,
            onChangeMonthYear: null,
            onClose: null,
            numberOfMonths: 1,
            showCurrentAtPos: 0,
            stepMonths: 1,
            stepBigMonths: 12,
            altField: "",
            altFormat: "",
            constrainInput: !0,
            showButtonPanel: !1,
            autoSize: !1,
            disabled: !1
        }, e.extend(this._defaults, this.regional[""]), this.regional.en = e.extend(!0, {}, this.regional[""]), this.regional["en-US"] = e.extend(!0, {}, this.regional.en), this.dpDiv = s(e("<div id='" + this._mainDivId + "' class='ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>"))
    }

    function s(t) {
        var i = "button, .ui-datepicker-prev, .ui-datepicker-next, .ui-datepicker-calendar td a";
        return t.delegate(i, "mouseout", function () {
            e(this).removeClass("ui-state-hover"), -1 !== this.className.indexOf("ui-datepicker-prev") && e(this).removeClass("ui-datepicker-prev-hover"), -1 !== this.className.indexOf("ui-datepicker-next") && e(this).removeClass("ui-datepicker-next-hover")
        }).delegate(i, "mouseover", r)
    }

    function r() {
        e.datepicker._isDisabledDatepicker(u.inline ? u.dpDiv.parent()[0] : u.input[0]) || (e(this).parents(".ui-datepicker-calendar").find("a").removeClass("ui-state-hover"), e(this).addClass("ui-state-hover"), -1 !== this.className.indexOf("ui-datepicker-prev") && e(this).addClass("ui-datepicker-prev-hover"), -1 !== this.className.indexOf("ui-datepicker-next") && e(this).addClass("ui-datepicker-next-hover"))
    }

    function a(t, i) {
        e.extend(t, i);
        for (var n in i) null == i[n] && (t[n] = i[n]);
        return t
    }
    e.ui = e.ui || {}, e.extend(e.ui, {
        version: "1.11.4",
        keyCode: {
            BACKSPACE: 8,
            COMMA: 188,
            DELETE: 46,
            DOWN: 40,
            END: 35,
            ENTER: 13,
            ESCAPE: 27,
            HOME: 36,
            LEFT: 37,
            PAGE_DOWN: 34,
            PAGE_UP: 33,
            PERIOD: 190,
            RIGHT: 39,
            SPACE: 32,
            TAB: 9,
            UP: 38
        }
    }), e.fn.extend({
        scrollParent: function (t) {
            var i = this.css("position"),
                n = "absolute" === i,
                o = t ? /(auto|scroll|hidden)/ : /(auto|scroll)/,
                s = this.parents().filter(function () {
                    var t = e(this);
                    return n && "static" === t.css("position") ? !1 : o.test(t.css("overflow") + t.css("overflow-y") + t.css("overflow-x"))
                }).eq(0);
            return "fixed" !== i && s.length ? s : e(this[0].ownerDocument || document)
        },
        uniqueId: function () {
            var e = 0;
            return function () {
                return this.each(function () {
                    this.id || (this.id = "ui-id-" + ++e)
                })
            }
        }(),
        removeUniqueId: function () {
            return this.each(function () {
                /^ui-id-\d+$/.test(this.id) && e(this).removeAttr("id")
            })
        }
    }), e.extend(e.expr[":"], {
        data: e.expr.createPseudo ? e.expr.createPseudo(function (t) {
            return function (i) {
                return !!e.data(i, t)
            }
        }) : function (t, i, n) {
            return !!e.data(t, n[3])
        },
        focusable: function (i) {
            return t(i, !isNaN(e.attr(i, "tabindex")))
        },
        tabbable: function (i) {
            var n = e.attr(i, "tabindex"),
                o = isNaN(n);
            return (o || n >= 0) && t(i, !o)
        }
    }), e("<a>").outerWidth(1).jquery || e.each(["Width", "Height"], function (t, i) {
        function n(t, i, n, s) {
            return e.each(o, function () {
                i -= parseFloat(e.css(t, "padding" + this)) || 0, n && (i -= parseFloat(e.css(t, "border" + this + "Width")) || 0), s && (i -= parseFloat(e.css(t, "margin" + this)) || 0)
            }), i
        }
        var o = "Width" === i ? ["Left", "Right"] : ["Top", "Bottom"],
            s = i.toLowerCase(),
            r = {
                innerWidth: e.fn.innerWidth,
                innerHeight: e.fn.innerHeight,
                outerWidth: e.fn.outerWidth,
                outerHeight: e.fn.outerHeight
            };
        e.fn["inner" + i] = function (t) {
            return void 0 === t ? r["inner" + i].call(this) : this.each(function () {
                e(this).css(s, n(this, t) + "px")
            })
        }, e.fn["outer" + i] = function (t, o) {
            return "number" != typeof t ? r["outer" + i].call(this, t) : this.each(function () {
                e(this).css(s, n(this, t, !0, o) + "px")
            })
        }
    }), e.fn.addBack || (e.fn.addBack = function (e) {
        return this.add(null == e ? this.prevObject : this.prevObject.filter(e))
    }), e("<a>").data("a-b", "a").removeData("a-b").data("a-b") && (e.fn.removeData = function (t) {
        return function (i) {
            return arguments.length ? t.call(this, e.camelCase(i)) : t.call(this)
        }
    }(e.fn.removeData)), e.ui.ie = !!/msie [\w.]+/.exec(navigator.userAgent.toLowerCase()), e.fn.extend({
        focus: function (t) {
            return function (i, n) {
                return "number" == typeof i ? this.each(function () {
                    var t = this;
                    setTimeout(function () {
                        e(t).focus(), n && n.call(t)
                    }, i)
                }) : t.apply(this, arguments)
            }
        }(e.fn.focus),
        disableSelection: function () {
            var e = "onselectstart" in document.createElement("div") ? "selectstart" : "mousedown";
            return function () {
                return this.bind(e + ".ui-disableSelection", function (e) {
                    e.preventDefault()
                })
            }
        }(),
        enableSelection: function () {
            return this.unbind(".ui-disableSelection")
        },
        zIndex: function (t) {
            if (void 0 !== t) return this.css("zIndex", t);
            if (this.length)
                for (var i, n, o = e(this[0]); o.length && o[0] !== document;) {
                    if (i = o.css("position"), ("absolute" === i || "relative" === i || "fixed" === i) && (n = parseInt(o.css("zIndex"), 10), !isNaN(n) && 0 !== n)) return n;
                    o = o.parent()
                }
            return 0
        }
    }), e.ui.plugin = {
        add: function (t, i, n) {
            var o, s = e.ui[t].prototype;
            for (o in n) s.plugins[o] = s.plugins[o] || [], s.plugins[o].push([i, n[o]])
        },
        call: function (e, t, i, n) {
            var o, s = e.plugins[t];
            if (s && (n || e.element[0].parentNode && 11 !== e.element[0].parentNode.nodeType))
                for (o = 0; o < s.length; o++) e.options[s[o][0]] && s[o][1].apply(e.element, i)
        }
    };
    var l = 0,
        c = Array.prototype.slice;
    e.cleanData = function (t) {
        return function (i) {
            var n, o, s;
            for (s = 0; null != (o = i[s]); s++) try {
                n = e._data(o, "events"), n && n.remove && e(o).triggerHandler("remove")
            } catch (r) {}
            t(i)
        }
    }(e.cleanData), e.widget = function (t, i, n) {
        var o, s, r, a, l = {},
            c = t.split(".")[0];
        return t = t.split(".")[1], o = c + "-" + t, n || (n = i, i = e.Widget), e.expr[":"][o.toLowerCase()] = function (t) {
            return !!e.data(t, o)
        }, e[c] = e[c] || {}, s = e[c][t], r = e[c][t] = function (e, t) {
            return this._createWidget ? void(arguments.length && this._createWidget(e, t)) : new r(e, t)
        }, e.extend(r, s, {
            version: n.version,
            _proto: e.extend({}, n),
            _childConstructors: []
        }), a = new i, a.options = e.widget.extend({}, a.options), e.each(n, function (t, n) {
            return e.isFunction(n) ? void(l[t] = function () {
                var e = function () {
                        return i.prototype[t].apply(this, arguments)
                    },
                    o = function (e) {
                        return i.prototype[t].apply(this, e)
                    };
                return function () {
                    var t, i = this._super,
                        s = this._superApply;
                    return this._super = e, this._superApply = o, t = n.apply(this, arguments), this._super = i, this._superApply = s, t
                }
            }()) : void(l[t] = n)
        }), r.prototype = e.widget.extend(a, {
            widgetEventPrefix: s ? a.widgetEventPrefix || t : t
        }, l, {
            constructor: r,
            namespace: c,
            widgetName: t,
            widgetFullName: o
        }), s ? (e.each(s._childConstructors, function (t, i) {
            var n = i.prototype;
            e.widget(n.namespace + "." + n.widgetName, r, i._proto)
        }), delete s._childConstructors) : i._childConstructors.push(r), e.widget.bridge(t, r), r
    }, e.widget.extend = function (t) {
        for (var i, n, o = c.call(arguments, 1), s = 0, r = o.length; r > s; s++)
            for (i in o[s]) n = o[s][i], o[s].hasOwnProperty(i) && void 0 !== n && (e.isPlainObject(n) ? t[i] = e.isPlainObject(t[i]) ? e.widget.extend({}, t[i], n) : e.widget.extend({}, n) : t[i] = n);
        return t
    }, e.widget.bridge = function (t, i) {
        var n = i.prototype.widgetFullName || t;
        e.fn[t] = function (o) {
            var s = "string" == typeof o,
                r = c.call(arguments, 1),
                a = this;
            return s ? this.each(function () {
                var i, s = e.data(this, n);
                return "instance" === o ? (a = s, !1) : s ? e.isFunction(s[o]) && "_" !== o.charAt(0) ? (i = s[o].apply(s, r), i !== s && void 0 !== i ? (a = i && i.jquery ? a.pushStack(i.get()) : i, !1) : void 0) : e.error("no such method '" + o + "' for " + t + " widget instance") : e.error("cannot call methods on " + t + " prior to initialization; attempted to call method '" + o + "'")
            }) : (r.length && (o = e.widget.extend.apply(null, [o].concat(r))), this.each(function () {
                var t = e.data(this, n);
                t ? (t.option(o || {}), t._init && t._init()) : e.data(this, n, new i(o, this))
            })), a
        }
    }, e.Widget = function () {}, e.Widget._childConstructors = [], e.Widget.prototype = {
        widgetName: "widget",
        widgetEventPrefix: "",
        defaultElement: "<div>",
        options: {
            disabled: !1,
            create: null
        },
        _createWidget: function (t, i) {
            i = e(i || this.defaultElement || this)[0], this.element = e(i), this.uuid = l++, this.eventNamespace = "." + this.widgetName + this.uuid, this.bindings = e(), this.hoverable = e(), this.focusable = e(), i !== this && (e.data(i, this.widgetFullName, this), this._on(!0, this.element, {
                remove: function (e) {
                    e.target === i && this.destroy()
                }
            }), this.document = e(i.style ? i.ownerDocument : i.document || i), this.window = e(this.document[0].defaultView || this.document[0].parentWindow)), this.options = e.widget.extend({}, this.options, this._getCreateOptions(), t), this._create(), this._trigger("create", null, this._getCreateEventData()), this._init()
        },
        _getCreateOptions: e.noop,
        _getCreateEventData: e.noop,
        _create: e.noop,
        _init: e.noop,
        destroy: function () {
            this._destroy(), this.element.unbind(this.eventNamespace).removeData(this.widgetFullName).removeData(e.camelCase(this.widgetFullName)), this.widget().unbind(this.eventNamespace).removeAttr("aria-disabled").removeClass(this.widgetFullName + "-disabled ui-state-disabled"), this.bindings.unbind(this.eventNamespace), this.hoverable.removeClass("ui-state-hover"), this.focusable.removeClass("ui-state-focus")
        },
        _destroy: e.noop,
        widget: function () {
            return this.element
        },
        option: function (t, i) {
            var n, o, s, r = t;
            if (0 === arguments.length) return e.widget.extend({}, this.options);
            if ("string" == typeof t)
                if (r = {}, n = t.split("."), t = n.shift(), n.length) {
                    for (o = r[t] = e.widget.extend({}, this.options[t]), s = 0; s < n.length - 1; s++) o[n[s]] = o[n[s]] || {}, o = o[n[s]];
                    if (t = n.pop(), 1 === arguments.length) return void 0 === o[t] ? null : o[t];
                    o[t] = i
                } else {
                    if (1 === arguments.length) return void 0 === this.options[t] ? null : this.options[t];
                    r[t] = i
                }
            return this._setOptions(r), this
        },
        _setOptions: function (e) {
            var t;
            for (t in e) this._setOption(t, e[t]);
            return this
        },
        _setOption: function (e, t) {
            return this.options[e] = t, "disabled" === e && (this.widget().toggleClass(this.widgetFullName + "-disabled", !!t), t && (this.hoverable.removeClass("ui-state-hover"), this.focusable.removeClass("ui-state-focus"))), this
        },
        enable: function () {
            return this._setOptions({
                disabled: !1
            })
        },
        disable: function () {
            return this._setOptions({
                disabled: !0
            })
        },
        _on: function (t, i, n) {
            var o, s = this;
            "boolean" != typeof t && (n = i, i = t, t = !1), n ? (i = o = e(i), this.bindings = this.bindings.add(i)) : (n = i, i = this.element, o = this.widget()), e.each(n, function (n, r) {
                function a() {
                    return t || s.options.disabled !== !0 && !e(this).hasClass("ui-state-disabled") ? ("string" == typeof r ? s[r] : r).apply(s, arguments) : void 0
                }
                "string" != typeof r && (a.guid = r.guid = r.guid || a.guid || e.guid++);
                var l = n.match(/^([\w:-]*)\s*(.*)$/),
                    c = l[1] + s.eventNamespace,
                    d = l[2];
                d ? o.delegate(d, c, a) : i.bind(c, a)
            })
        },
        _off: function (t, i) {
            i = (i || "").split(" ").join(this.eventNamespace + " ") + this.eventNamespace, t.unbind(i).undelegate(i), this.bindings = e(this.bindings.not(t).get()), this.focusable = e(this.focusable.not(t).get()), this.hoverable = e(this.hoverable.not(t).get())
        },
        _delay: function (e, t) {
            function i() {
                return ("string" == typeof e ? n[e] : e).apply(n, arguments)
            }
            var n = this;
            return setTimeout(i, t || 0)
        },
        _hoverable: function (t) {
            this.hoverable = this.hoverable.add(t), this._on(t, {
                mouseenter: function (t) {
                    e(t.currentTarget).addClass("ui-state-hover")
                },
                mouseleave: function (t) {
                    e(t.currentTarget).removeClass("ui-state-hover")
                }
            })
        },
        _focusable: function (t) {
            this.focusable = this.focusable.add(t), this._on(t, {
                focusin: function (t) {
                    e(t.currentTarget).addClass("ui-state-focus")
                },
                focusout: function (t) {
                    e(t.currentTarget).removeClass("ui-state-focus")
                }
            })
        },
        _trigger: function (t, i, n) {
            var o, s, r = this.options[t];
            if (n = n || {}, i = e.Event(i), i.type = (t === this.widgetEventPrefix ? t : this.widgetEventPrefix + t).toLowerCase(), i.target = this.element[0], s = i.originalEvent)
                for (o in s) o in i || (i[o] = s[o]);
            return this.element.trigger(i, n), !(e.isFunction(r) && r.apply(this.element[0], [i].concat(n)) === !1 || i.isDefaultPrevented())
        }
    }, e.each({
        show: "fadeIn",
        hide: "fadeOut"
    }, function (t, i) {
        e.Widget.prototype["_" + t] = function (n, o, s) {
            "string" == typeof o && (o = {
                effect: o
            });
            var r, a = o ? o === !0 || "number" == typeof o ? i : o.effect || i : t;
            o = o || {}, "number" == typeof o && (o = {
                duration: o
            }), r = !e.isEmptyObject(o), o.complete = s, o.delay && n.delay(o.delay), r && e.effects && e.effects.effect[a] ? n[t](o) : a !== t && n[a] ? n[a](o.duration, o.easing, s) : n.queue(function (i) {
                e(this)[t](), s && s.call(n[0]), i()
            })
        }
    });
    var d = (e.widget, !1);
    e(document).mouseup(function () {
        d = !1
    });
    e.widget("ui.mouse", {
        version: "1.11.4",
        options: {
            cancel: "input,textarea,button,select,option",
            distance: 1,
            delay: 0
        },
        _mouseInit: function () {
            var t = this;
            this.element.bind("mousedown." + this.widgetName, function (e) {
                return t._mouseDown(e)
            }).bind("click." + this.widgetName, function (i) {
                return !0 === e.data(i.target, t.widgetName + ".preventClickEvent") ? (e.removeData(i.target, t.widgetName + ".preventClickEvent"), i.stopImmediatePropagation(), !1) : void 0
            }), this.started = !1
        },
        _mouseDestroy: function () {
            this.element.unbind("." + this.widgetName), this._mouseMoveDelegate && this.document.unbind("mousemove." + this.widgetName, this._mouseMoveDelegate).unbind("mouseup." + this.widgetName, this._mouseUpDelegate)
        },
        _mouseDown: function (t) {
            if (!d) {
                this._mouseMoved = !1, this._mouseStarted && this._mouseUp(t), this._mouseDownEvent = t;
                var i = this,
                    n = 1 === t.which,
                    o = "string" == typeof this.options.cancel && t.target.nodeName ? e(t.target).closest(this.options.cancel).length : !1;
                return n && !o && this._mouseCapture(t) ? (this.mouseDelayMet = !this.options.delay, this.mouseDelayMet || (this._mouseDelayTimer = setTimeout(function () {
                    i.mouseDelayMet = !0
                }, this.options.delay)), this._mouseDistanceMet(t) && this._mouseDelayMet(t) && (this._mouseStarted = this._mouseStart(t) !== !1, !this._mouseStarted) ? (t.preventDefault(), !0) : (!0 === e.data(t.target, this.widgetName + ".preventClickEvent") && e.removeData(t.target, this.widgetName + ".preventClickEvent"), this._mouseMoveDelegate = function (e) {
                    return i._mouseMove(e)
                }, this._mouseUpDelegate = function (e) {
                    return i._mouseUp(e)
                }, this.document.bind("mousemove." + this.widgetName, this._mouseMoveDelegate).bind("mouseup." + this.widgetName, this._mouseUpDelegate), t.preventDefault(), d = !0, !0)) : !0
            }
        },
        _mouseMove: function (t) {
            if (this._mouseMoved) {
                if (e.ui.ie && (!document.documentMode || document.documentMode < 9) && !t.button) return this._mouseUp(t);
                if (!t.which) return this._mouseUp(t)
            }
            return (t.which || t.button) && (this._mouseMoved = !0), this._mouseStarted ? (this._mouseDrag(t), t.preventDefault()) : (this._mouseDistanceMet(t) && this._mouseDelayMet(t) && (this._mouseStarted = this._mouseStart(this._mouseDownEvent, t) !== !1, this._mouseStarted ? this._mouseDrag(t) : this._mouseUp(t)), !this._mouseStarted)
        },
        _mouseUp: function (t) {
            return this.document.unbind("mousemove." + this.widgetName, this._mouseMoveDelegate).unbind("mouseup." + this.widgetName, this._mouseUpDelegate), this._mouseStarted && (this._mouseStarted = !1, t.target === this._mouseDownEvent.target && e.data(t.target, this.widgetName + ".preventClickEvent", !0), this._mouseStop(t)), d = !1, !1
        },
        _mouseDistanceMet: function (e) {
            return Math.max(Math.abs(this._mouseDownEvent.pageX - e.pageX), Math.abs(this._mouseDownEvent.pageY - e.pageY)) >= this.options.distance
        },
        _mouseDelayMet: function () {
            return this.mouseDelayMet
        },
        _mouseStart: function () {},
        _mouseDrag: function () {},
        _mouseStop: function () {},
        _mouseCapture: function () {
            return !0
        }
    });
    ! function () {
        function t(e, t, i) {
            return [parseFloat(e[0]) * (p.test(e[0]) ? t / 100 : 1), parseFloat(e[1]) * (p.test(e[1]) ? i / 100 : 1)]
        }

        function i(t, i) {
            return parseInt(e.css(t, i), 10) || 0
        }

        function n(t) {
            var i = t[0];
            return 9 === i.nodeType ? {
                width: t.width(),
                height: t.height(),
                offset: {
                    top: 0,
                    left: 0
                }
            } : e.isWindow(i) ? {
                width: t.width(),
                height: t.height(),
                offset: {
                    top: t.scrollTop(),
                    left: t.scrollLeft()
                }
            } : i.preventDefault ? {
                width: 0,
                height: 0,
                offset: {
                    top: i.pageY,
                    left: i.pageX
                }
            } : {
                width: t.outerWidth(),
                height: t.outerHeight(),
                offset: t.offset()
            }
        }
        e.ui = e.ui || {};
        var o, s, r = Math.max,
            a = Math.abs,
            l = Math.round,
            c = /left|center|right/,
            d = /top|center|bottom/,
            u = /[\+\-]\d+(\.[\d]+)?%?/,
            h = /^\w+/,
            p = /%$/,
            f = e.fn.position;
        e.position = {
                scrollbarWidth: function () {
                    if (void 0 !== o) return o;
                    var t, i, n = e("<div style='display:block;position:absolute;width:50px;height:50px;overflow:hidden;'><div style='height:100px;width:auto;'></div></div>"),
                        s = n.children()[0];
                    return e("body").append(n), t = s.offsetWidth, n.css("overflow", "scroll"), i = s.offsetWidth, t === i && (i = n[0].clientWidth), n.remove(), o = t - i
                },
                getScrollInfo: function (t) {
                    var i = t.isWindow || t.isDocument ? "" : t.element.css("overflow-x"),
                        n = t.isWindow || t.isDocument ? "" : t.element.css("overflow-y"),
                        o = "scroll" === i || "auto" === i && t.width < t.element[0].scrollWidth,
                        s = "scroll" === n || "auto" === n && t.height < t.element[0].scrollHeight;
                    return {
                        width: s ? e.position.scrollbarWidth() : 0,
                        height: o ? e.position.scrollbarWidth() : 0
                    }
                },
                getWithinInfo: function (t) {
                    var i = e(t || window),
                        n = e.isWindow(i[0]),
                        o = !!i[0] && 9 === i[0].nodeType;
                    return {
                        element: i,
                        isWindow: n,
                        isDocument: o,
                        offset: i.offset() || {
                            left: 0,
                            top: 0
                        },
                        scrollLeft: i.scrollLeft(),
                        scrollTop: i.scrollTop(),
                        width: n || o ? i.width() : i.outerWidth(),
                        height: n || o ? i.height() : i.outerHeight()
                    }
                }
            }, e.fn.position = function (o) {
                if (!o || !o.of) return f.apply(this, arguments);
                o = e.extend({}, o);
                var p, g, m, v, y, b, w = e(o.of),
                    k = e.position.getWithinInfo(o.within),
                    _ = e.position.getScrollInfo(k),
                    x = (o.collision || "flip").split(" "),
                    C = {};
                return b = n(w), w[0].preventDefault && (o.at = "left top"), g = b.width, m = b.height, v = b.offset, y = e.extend({}, v), e.each(["my", "at"], function () {
                    var e, t, i = (o[this] || "").split(" ");
                    1 === i.length && (i = c.test(i[0]) ? i.concat(["center"]) : d.test(i[0]) ? ["center"].concat(i) : ["center", "center"]), i[0] = c.test(i[0]) ? i[0] : "center", i[1] = d.test(i[1]) ? i[1] : "center", e = u.exec(i[0]), t = u.exec(i[1]), C[this] = [e ? e[0] : 0, t ? t[0] : 0], o[this] = [h.exec(i[0])[0], h.exec(i[1])[0]];
                }), 1 === x.length && (x[1] = x[0]), "right" === o.at[0] ? y.left += g : "center" === o.at[0] && (y.left += g / 2), "bottom" === o.at[1] ? y.top += m : "center" === o.at[1] && (y.top += m / 2), p = t(C.at, g, m), y.left += p[0], y.top += p[1], this.each(function () {
                    var n, c, d = e(this),
                        u = d.outerWidth(),
                        h = d.outerHeight(),
                        f = i(this, "marginLeft"),
                        b = i(this, "marginTop"),
                        T = u + f + i(this, "marginRight") + _.width,
                        S = h + b + i(this, "marginBottom") + _.height,
                        D = e.extend({}, y),
                        M = t(C.my, d.outerWidth(), d.outerHeight());
                    "right" === o.my[0] ? D.left -= u : "center" === o.my[0] && (D.left -= u / 2), "bottom" === o.my[1] ? D.top -= h : "center" === o.my[1] && (D.top -= h / 2), D.left += M[0], D.top += M[1], s || (D.left = l(D.left), D.top = l(D.top)), n = {
                        marginLeft: f,
                        marginTop: b
                    }, e.each(["left", "top"], function (t, i) {
                        e.ui.position[x[t]] && e.ui.position[x[t]][i](D, {
                            targetWidth: g,
                            targetHeight: m,
                            elemWidth: u,
                            elemHeight: h,
                            collisionPosition: n,
                            collisionWidth: T,
                            collisionHeight: S,
                            offset: [p[0] + M[0], p[1] + M[1]],
                            my: o.my,
                            at: o.at,
                            within: k,
                            elem: d
                        })
                    }), o.using && (c = function (e) {
                        var t = v.left - D.left,
                            i = t + g - u,
                            n = v.top - D.top,
                            s = n + m - h,
                            l = {
                                target: {
                                    element: w,
                                    left: v.left,
                                    top: v.top,
                                    width: g,
                                    height: m
                                },
                                element: {
                                    element: d,
                                    left: D.left,
                                    top: D.top,
                                    width: u,
                                    height: h
                                },
                                horizontal: 0 > i ? "left" : t > 0 ? "right" : "center",
                                vertical: 0 > s ? "top" : n > 0 ? "bottom" : "middle"
                            };
                        u > g && a(t + i) < g && (l.horizontal = "center"), h > m && a(n + s) < m && (l.vertical = "middle"), r(a(t), a(i)) > r(a(n), a(s)) ? l.important = "horizontal" : l.important = "vertical", o.using.call(this, e, l)
                    }), d.offset(e.extend(D, {
                        using: c
                    }))
                })
            }, e.ui.position = {
                fit: {
                    left: function (e, t) {
                        var i, n = t.within,
                            o = n.isWindow ? n.scrollLeft : n.offset.left,
                            s = n.width,
                            a = e.left - t.collisionPosition.marginLeft,
                            l = o - a,
                            c = a + t.collisionWidth - s - o;
                        t.collisionWidth > s ? l > 0 && 0 >= c ? (i = e.left + l + t.collisionWidth - s - o, e.left += l - i) : c > 0 && 0 >= l ? e.left = o : l > c ? e.left = o + s - t.collisionWidth : e.left = o : l > 0 ? e.left += l : c > 0 ? e.left -= c : e.left = r(e.left - a, e.left)
                    },
                    top: function (e, t) {
                        var i, n = t.within,
                            o = n.isWindow ? n.scrollTop : n.offset.top,
                            s = t.within.height,
                            a = e.top - t.collisionPosition.marginTop,
                            l = o - a,
                            c = a + t.collisionHeight - s - o;
                        t.collisionHeight > s ? l > 0 && 0 >= c ? (i = e.top + l + t.collisionHeight - s - o, e.top += l - i) : c > 0 && 0 >= l ? e.top = o : l > c ? e.top = o + s - t.collisionHeight : e.top = o : l > 0 ? e.top += l : c > 0 ? e.top -= c : e.top = r(e.top - a, e.top)
                    }
                },
                flip: {
                    left: function (e, t) {
                        var i, n, o = t.within,
                            s = o.offset.left + o.scrollLeft,
                            r = o.width,
                            l = o.isWindow ? o.scrollLeft : o.offset.left,
                            c = e.left - t.collisionPosition.marginLeft,
                            d = c - l,
                            u = c + t.collisionWidth - r - l,
                            h = "left" === t.my[0] ? -t.elemWidth : "right" === t.my[0] ? t.elemWidth : 0,
                            p = "left" === t.at[0] ? t.targetWidth : "right" === t.at[0] ? -t.targetWidth : 0,
                            f = -2 * t.offset[0];
                        0 > d ? (i = e.left + h + p + f + t.collisionWidth - r - s, (0 > i || i < a(d)) && (e.left += h + p + f)) : u > 0 && (n = e.left - t.collisionPosition.marginLeft + h + p + f - l, (n > 0 || a(n) < u) && (e.left += h + p + f))
                    },
                    top: function (e, t) {
                        var i, n, o = t.within,
                            s = o.offset.top + o.scrollTop,
                            r = o.height,
                            l = o.isWindow ? o.scrollTop : o.offset.top,
                            c = e.top - t.collisionPosition.marginTop,
                            d = c - l,
                            u = c + t.collisionHeight - r - l,
                            h = "top" === t.my[1],
                            p = h ? -t.elemHeight : "bottom" === t.my[1] ? t.elemHeight : 0,
                            f = "top" === t.at[1] ? t.targetHeight : "bottom" === t.at[1] ? -t.targetHeight : 0,
                            g = -2 * t.offset[1];
                        0 > d ? (n = e.top + p + f + g + t.collisionHeight - r - s, (0 > n || n < a(d)) && (e.top += p + f + g)) : u > 0 && (i = e.top - t.collisionPosition.marginTop + p + f + g - l, (i > 0 || a(i) < u) && (e.top += p + f + g))
                    }
                },
                flipfit: {
                    left: function () {
                        e.ui.position.flip.left.apply(this, arguments), e.ui.position.fit.left.apply(this, arguments)
                    },
                    top: function () {
                        e.ui.position.flip.top.apply(this, arguments), e.ui.position.fit.top.apply(this, arguments)
                    }
                }
            },
            function () {
                var t, i, n, o, r, a = document.getElementsByTagName("body")[0],
                    l = document.createElement("div");
                t = document.createElement(a ? "div" : "body"), n = {
                    visibility: "hidden",
                    width: 0,
                    height: 0,
                    border: 0,
                    margin: 0,
                    background: "none"
                }, a && e.extend(n, {
                    position: "absolute",
                    left: "-1000px",
                    top: "-1000px"
                });
                for (r in n) t.style[r] = n[r];
                t.appendChild(l), i = a || document.documentElement, i.insertBefore(t, i.firstChild), l.style.cssText = "position: absolute; left: 10.7432222px;", o = e(l).offset().left, s = o > 10 && 11 > o, t.innerHTML = "", i.removeChild(t)
            }()
    }();
    e.ui.position, e.widget("ui.accordion", {
        version: "1.11.4",
        options: {
            active: 0,
            animate: {},
            collapsible: !1,
            event: "click",
            header: "> li > :first-child,> :not(li):even",
            heightStyle: "auto",
            icons: {
                activeHeader: "ui-icon-triangle-1-s",
                header: "ui-icon-triangle-1-e"
            },
            activate: null,
            beforeActivate: null
        },
        hideProps: {
            borderTopWidth: "hide",
            borderBottomWidth: "hide",
            paddingTop: "hide",
            paddingBottom: "hide",
            height: "hide"
        },
        showProps: {
            borderTopWidth: "show",
            borderBottomWidth: "show",
            paddingTop: "show",
            paddingBottom: "show",
            height: "show"
        },
        _create: function () {
            var t = this.options;
            this.prevShow = this.prevHide = e(), this.element.addClass("ui-accordion ui-widget ui-helper-reset").attr("role", "tablist"), t.collapsible || t.active !== !1 && null != t.active || (t.active = 0), this._processPanels(), t.active < 0 && (t.active += this.headers.length), this._refresh()
        },
        _getCreateEventData: function () {
            return {
                header: this.active,
                panel: this.active.length ? this.active.next() : e()
            }
        },
        _createIcons: function () {
            var t = this.options.icons;
            t && (e("<span>").addClass("ui-accordion-header-icon ui-icon " + t.header).prependTo(this.headers), this.active.children(".ui-accordion-header-icon").removeClass(t.header).addClass(t.activeHeader), this.headers.addClass("ui-accordion-icons"))
        },
        _destroyIcons: function () {
            this.headers.removeClass("ui-accordion-icons").children(".ui-accordion-header-icon").remove()
        },
        _destroy: function () {
            var e;
            this.element.removeClass("ui-accordion ui-widget ui-helper-reset").removeAttr("role"), this.headers.removeClass("ui-accordion-header ui-accordion-header-active ui-state-default ui-corner-all ui-state-active ui-state-disabled ui-corner-top").removeAttr("role").removeAttr("aria-expanded").removeAttr("aria-selected").removeAttr("aria-controls").removeAttr("tabIndex").removeUniqueId(), this._destroyIcons(), e = this.headers.next().removeClass("ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content ui-accordion-content-active ui-state-disabled").css("display", "").removeAttr("role").removeAttr("aria-hidden").removeAttr("aria-labelledby").removeUniqueId(), "content" !== this.options.heightStyle && e.css("height", "")
        },
        _setOption: function (e, t) {
            return "active" === e ? void this._activate(t) : ("event" === e && (this.options.event && this._off(this.headers, this.options.event), this._setupEvents(t)), this._super(e, t), "collapsible" !== e || t || this.options.active !== !1 || this._activate(0), "icons" === e && (this._destroyIcons(), t && this._createIcons()), void("disabled" === e && (this.element.toggleClass("ui-state-disabled", !!t).attr("aria-disabled", t), this.headers.add(this.headers.next()).toggleClass("ui-state-disabled", !!t))))
        },
        _keydown: function (t) {
            if (!t.altKey && !t.ctrlKey) {
                var i = e.ui.keyCode,
                    n = this.headers.length,
                    o = this.headers.index(t.target),
                    s = !1;
                switch (t.keyCode) {
                    case i.RIGHT:
                    case i.DOWN:
                        s = this.headers[(o + 1) % n];
                        break;
                    case i.LEFT:
                    case i.UP:
                        s = this.headers[(o - 1 + n) % n];
                        break;
                    case i.SPACE:
                    case i.ENTER:
                        this._eventHandler(t);
                        break;
                    case i.HOME:
                        s = this.headers[0];
                        break;
                    case i.END:
                        s = this.headers[n - 1]
                }
                s && (e(t.target).attr("tabIndex", -1), e(s).attr("tabIndex", 0), s.focus(), t.preventDefault())
            }
        },
        _panelKeyDown: function (t) {
            t.keyCode === e.ui.keyCode.UP && t.ctrlKey && e(t.currentTarget).prev().focus()
        },
        refresh: function () {
            var t = this.options;
            this._processPanels(), t.active === !1 && t.collapsible === !0 || !this.headers.length ? (t.active = !1, this.active = e()) : t.active === !1 ? this._activate(0) : this.active.length && !e.contains(this.element[0], this.active[0]) ? this.headers.length === this.headers.find(".ui-state-disabled").length ? (t.active = !1, this.active = e()) : this._activate(Math.max(0, t.active - 1)) : t.active = this.headers.index(this.active), this._destroyIcons(), this._refresh()
        },
        _processPanels: function () {
            var e = this.headers,
                t = this.panels;
            this.headers = this.element.find(this.options.header).addClass("ui-accordion-header ui-state-default ui-corner-all"), this.panels = this.headers.next().addClass("ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom").filter(":not(.ui-accordion-content-active)").hide(), t && (this._off(e.not(this.headers)), this._off(t.not(this.panels)))
        },
        _refresh: function () {
            var t, i = this.options,
                n = i.heightStyle,
                o = this.element.parent();
            this.active = this._findActive(i.active).addClass("ui-accordion-header-active ui-state-active ui-corner-top").removeClass("ui-corner-all"), this.active.next().addClass("ui-accordion-content-active").show(), this.headers.attr("role", "tab").each(function () {
                var t = e(this),
                    i = t.uniqueId().attr("id"),
                    n = t.next(),
                    o = n.uniqueId().attr("id");
                t.attr("aria-controls", o), n.attr("aria-labelledby", i)
            }).next().attr("role", "tabpanel"), this.headers.not(this.active).attr({
                "aria-selected": "false",
                "aria-expanded": "false",
                tabIndex: -1
            }).next().attr({
                "aria-hidden": "true"
            }).hide(), this.active.length ? this.active.attr({
                "aria-selected": "true",
                "aria-expanded": "true",
                tabIndex: 0
            }).next().attr({
                "aria-hidden": "false"
            }) : this.headers.eq(0).attr("tabIndex", 0), this._createIcons(), this._setupEvents(i.event), "fill" === n ? (t = o.height(), this.element.siblings(":visible").each(function () {
                var i = e(this),
                    n = i.css("position");
                "absolute" !== n && "fixed" !== n && (t -= i.outerHeight(!0))
            }), this.headers.each(function () {
                t -= e(this).outerHeight(!0)
            }), this.headers.next().each(function () {
                e(this).height(Math.max(0, t - e(this).innerHeight() + e(this).height()))
            }).css("overflow", "auto")) : "auto" === n && (t = 0, this.headers.next().each(function () {
                t = Math.max(t, e(this).css("height", "").height())
            }).height(t))
        },
        _activate: function (t) {
            var i = this._findActive(t)[0];
            i !== this.active[0] && (i = i || this.active[0], this._eventHandler({
                target: i,
                currentTarget: i,
                preventDefault: e.noop
            }))
        },
        _findActive: function (t) {
            return "number" == typeof t ? this.headers.eq(t) : e()
        },
        _setupEvents: function (t) {
            var i = {
                keydown: "_keydown"
            };
            t && e.each(t.split(" "), function (e, t) {
                i[t] = "_eventHandler"
            }), this._off(this.headers.add(this.headers.next())), this._on(this.headers, i), this._on(this.headers.next(), {
                keydown: "_panelKeyDown"
            }), this._hoverable(this.headers), this._focusable(this.headers)
        },
        _eventHandler: function (t) {
            var i = this.options,
                n = this.active,
                o = e(t.currentTarget),
                s = o[0] === n[0],
                r = s && i.collapsible,
                a = r ? e() : o.next(),
                l = n.next(),
                c = {
                    oldHeader: n,
                    oldPanel: l,
                    newHeader: r ? e() : o,
                    newPanel: a
                };
            t.preventDefault(), s && !i.collapsible || this._trigger("beforeActivate", t, c) === !1 || (i.active = r ? !1 : this.headers.index(o), this.active = s ? e() : o, this._toggle(c), n.removeClass("ui-accordion-header-active ui-state-active"), i.icons && n.children(".ui-accordion-header-icon").removeClass(i.icons.activeHeader).addClass(i.icons.header), s || (o.removeClass("ui-corner-all").addClass("ui-accordion-header-active ui-state-active ui-corner-top"), i.icons && o.children(".ui-accordion-header-icon").removeClass(i.icons.header).addClass(i.icons.activeHeader), o.next().addClass("ui-accordion-content-active")))
        },
        _toggle: function (t) {
            var i = t.newPanel,
                n = this.prevShow.length ? this.prevShow : t.oldPanel;
            this.prevShow.add(this.prevHide).stop(!0, !0), this.prevShow = i, this.prevHide = n, this.options.animate ? this._animate(i, n, t) : (n.hide(), i.show(), this._toggleComplete(t)), n.attr({
                "aria-hidden": "true"
            }), n.prev().attr({
                "aria-selected": "false",
                "aria-expanded": "false"
            }), i.length && n.length ? n.prev().attr({
                tabIndex: -1,
                "aria-expanded": "false"
            }) : i.length && this.headers.filter(function () {
                return 0 === parseInt(e(this).attr("tabIndex"), 10)
            }).attr("tabIndex", -1), i.attr("aria-hidden", "false").prev().attr({
                "aria-selected": "true",
                "aria-expanded": "true",
                tabIndex: 0
            })
        },
        _animate: function (e, t, i) {
            var n, o, s, r = this,
                a = 0,
                l = e.css("box-sizing"),
                c = e.length && (!t.length || e.index() < t.index()),
                d = this.options.animate || {},
                u = c && d.down || d,
                h = function () {
                    r._toggleComplete(i)
                };
            return "number" == typeof u && (s = u), "string" == typeof u && (o = u), o = o || u.easing || d.easing, s = s || u.duration || d.duration, t.length ? e.length ? (n = e.show().outerHeight(), t.animate(this.hideProps, {
                duration: s,
                easing: o,
                step: function (e, t) {
                    t.now = Math.round(e)
                }
            }), void e.hide().animate(this.showProps, {
                duration: s,
                easing: o,
                complete: h,
                step: function (e, i) {
                    i.now = Math.round(e), "height" !== i.prop ? "content-box" === l && (a += i.now) : "content" !== r.options.heightStyle && (i.now = Math.round(n - t.outerHeight() - a), a = 0)
                }
            })) : t.animate(this.hideProps, s, o, h) : e.animate(this.showProps, s, o, h)
        },
        _toggleComplete: function (e) {
            var t = e.oldPanel;
            t.removeClass("ui-accordion-content-active").prev().removeClass("ui-corner-top").addClass("ui-corner-all"), t.length && (t.parent()[0].className = t.parent()[0].className), this._trigger("activate", null, e)
        }
    });
    e.extend(e.ui, {
        datepicker: {
            version: "1.11.4"
        }
    });
    var u;
    e.extend(o.prototype, {
        markerClassName: "hasDatepicker",
        maxRows: 4,
        _widgetDatepicker: function () {
            return this.dpDiv
        },
        setDefaults: function (e) {
            return a(this._defaults, e || {}), this
        },
        _attachDatepicker: function (t, i) {
            var n, o, s;
            n = t.nodeName.toLowerCase(), o = "div" === n || "span" === n, t.id || (this.uuid += 1, t.id = "dp" + this.uuid), s = this._newInst(e(t), o), s.settings = e.extend({}, i || {}), "input" === n ? this._connectDatepicker(t, s) : o && this._inlineDatepicker(t, s)
        },
        _newInst: function (t, i) {
            var n = t[0].id.replace(/([^A-Za-z0-9_\-])/g, "\\\\$1");
            return {
                id: n,
                input: t,
                selectedDay: 0,
                selectedMonth: 0,
                selectedYear: 0,
                drawMonth: 0,
                drawYear: 0,
                inline: i,
                dpDiv: i ? s(e("<div class='" + this._inlineClass + " ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>")) : this.dpDiv
            }
        },
        _connectDatepicker: function (t, i) {
            var n = e(t);
            i.append = e([]), i.trigger = e([]), n.hasClass(this.markerClassName) || (this._attachments(n, i), n.addClass(this.markerClassName).keydown(this._doKeyDown).keypress(this._doKeyPress).keyup(this._doKeyUp), this._autoSize(i), e.data(t, "datepicker", i), i.settings.disabled && this._disableDatepicker(t))
        },
        _attachments: function (t, i) {
            var n, o, s, r = this._get(i, "appendText"),
                a = this._get(i, "isRTL");
            i.append && i.append.remove(), r && (i.append = e("<span class='" + this._appendClass + "'>" + r + "</span>"), t[a ? "before" : "after"](i.append)), t.unbind("focus", this._showDatepicker), i.trigger && i.trigger.remove(), n = this._get(i, "showOn"), ("focus" === n || "both" === n) && t.focus(this._showDatepicker), ("button" === n || "both" === n) && (o = this._get(i, "buttonText"), s = this._get(i, "buttonImage"), i.trigger = e(this._get(i, "buttonImageOnly") ? e("<img/>").addClass(this._triggerClass).attr({
                src: s,
                alt: o
            }) : e("<button type='button'></button>").addClass(this._triggerClass).html(s ? e("<img/>").attr({
                src: s,
                alt: o,
                title: o
            }) : o)), t[a ? "before" : "after"](i.trigger), i.trigger.click(function () {
                return e.datepicker._datepickerShowing && e.datepicker._lastInput === t[0] ? e.datepicker._hideDatepicker() : e.datepicker._datepickerShowing && e.datepicker._lastInput !== t[0] ? (e.datepicker._hideDatepicker(), e.datepicker._showDatepicker(t[0])) : e.datepicker._showDatepicker(t[0]), !1
            }))
        },
        _autoSize: function (e) {
            if (this._get(e, "autoSize") && !e.inline) {
                var t, i, n, o, s = new Date(2009, 11, 20),
                    r = this._get(e, "dateFormat");
                r.match(/[DM]/) && (t = function (e) {
                    for (i = 0, n = 0, o = 0; o < e.length; o++) e[o].length > i && (i = e[o].length, n = o);
                    return n
                }, s.setMonth(t(this._get(e, r.match(/MM/) ? "monthNames" : "monthNamesShort"))), s.setDate(t(this._get(e, r.match(/DD/) ? "dayNames" : "dayNamesShort")) + 20 - s.getDay())), e.input.attr("size", this._formatDate(e, s).length)
            }
        },
        _inlineDatepicker: function (t, i) {
            var n = e(t);
            n.hasClass(this.markerClassName) || (n.addClass(this.markerClassName).append(i.dpDiv), e.data(t, "datepicker", i), this._setDate(i, this._getDefaultDate(i), !0), this._updateDatepicker(i), this._updateAlternate(i), i.settings.disabled && this._disableDatepicker(t), i.dpDiv.css("display", "block"))
        },
        _dialogDatepicker: function (t, i, n, o, s) {
            var r, l, c, d, u, h = this._dialogInst;
            return h || (this.uuid += 1, r = "dp" + this.uuid, this._dialogInput = e("<input type='text' id='" + r + "' style='position: absolute; top: -100px; width: 0px;'/>"), this._dialogInput.keydown(this._doKeyDown), e("body").append(this._dialogInput), h = this._dialogInst = this._newInst(this._dialogInput, !1), h.settings = {}, e.data(this._dialogInput[0], "datepicker", h)), a(h.settings, o || {}), i = i && i.constructor === Date ? this._formatDate(h, i) : i, this._dialogInput.val(i), this._pos = s ? s.length ? s : [s.pageX, s.pageY] : null, this._pos || (l = document.documentElement.clientWidth, c = document.documentElement.clientHeight, d = document.documentElement.scrollLeft || document.body.scrollLeft, u = document.documentElement.scrollTop || document.body.scrollTop, this._pos = [l / 2 - 100 + d, c / 2 - 150 + u]), this._dialogInput.css("left", this._pos[0] + 20 + "px").css("top", this._pos[1] + "px"), h.settings.onSelect = n, this._inDialog = !0, this.dpDiv.addClass(this._dialogClass), this._showDatepicker(this._dialogInput[0]), e.blockUI && e.blockUI(this.dpDiv), e.data(this._dialogInput[0], "datepicker", h), this
        },
        _destroyDatepicker: function (t) {
            var i, n = e(t),
                o = e.data(t, "datepicker");
            n.hasClass(this.markerClassName) && (i = t.nodeName.toLowerCase(), e.removeData(t, "datepicker"), "input" === i ? (o.append.remove(), o.trigger.remove(), n.removeClass(this.markerClassName).unbind("focus", this._showDatepicker).unbind("keydown", this._doKeyDown).unbind("keypress", this._doKeyPress).unbind("keyup", this._doKeyUp)) : ("div" === i || "span" === i) && n.removeClass(this.markerClassName).empty(), u === o && (u = null))
        },
        _enableDatepicker: function (t) {
            var i, n, o = e(t),
                s = e.data(t, "datepicker");
            o.hasClass(this.markerClassName) && (i = t.nodeName.toLowerCase(), "input" === i ? (t.disabled = !1, s.trigger.filter("button").each(function () {
                this.disabled = !1
            }).end().filter("img").css({
                opacity: "1.0",
                cursor: ""
            })) : ("div" === i || "span" === i) && (n = o.children("." + this._inlineClass), n.children().removeClass("ui-state-disabled"), n.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", !1)), this._disabledInputs = e.map(this._disabledInputs, function (e) {
                return e === t ? null : e
            }))
        },
        _disableDatepicker: function (t) {
            var i, n, o = e(t),
                s = e.data(t, "datepicker");
            o.hasClass(this.markerClassName) && (i = t.nodeName.toLowerCase(), "input" === i ? (t.disabled = !0, s.trigger.filter("button").each(function () {
                this.disabled = !0
            }).end().filter("img").css({
                opacity: "0.5",
                cursor: "default"
            })) : ("div" === i || "span" === i) && (n = o.children("." + this._inlineClass), n.children().addClass("ui-state-disabled"), n.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", !0)), this._disabledInputs = e.map(this._disabledInputs, function (e) {
                return e === t ? null : e
            }), this._disabledInputs[this._disabledInputs.length] = t)
        },
        _isDisabledDatepicker: function (e) {
            if (!e) return !1;
            for (var t = 0; t < this._disabledInputs.length; t++)
                if (this._disabledInputs[t] === e) return !0;
            return !1
        },
        _getInst: function (t) {
            try {
                return e.data(t, "datepicker")
            } catch (i) {
                throw "Missing instance data for this datepicker"
            }
        },
        _optionDatepicker: function (t, i, n) {
            var o, s, r, l, c = this._getInst(t);
            return 2 === arguments.length && "string" == typeof i ? "defaults" === i ? e.extend({}, e.datepicker._defaults) : c ? "all" === i ? e.extend({}, c.settings) : this._get(c, i) : null : (o = i || {}, "string" == typeof i && (o = {}, o[i] = n), void(c && (this._curInst === c && this._hideDatepicker(), s = this._getDateDatepicker(t, !0), r = this._getMinMaxDate(c, "min"), l = this._getMinMaxDate(c, "max"), a(c.settings, o), null !== r && void 0 !== o.dateFormat && void 0 === o.minDate && (c.settings.minDate = this._formatDate(c, r)), null !== l && void 0 !== o.dateFormat && void 0 === o.maxDate && (c.settings.maxDate = this._formatDate(c, l)), "disabled" in o && (o.disabled ? this._disableDatepicker(t) : this._enableDatepicker(t)), this._attachments(e(t), c), this._autoSize(c), this._setDate(c, s), this._updateAlternate(c), this._updateDatepicker(c))))
        },
        _changeDatepicker: function (e, t, i) {
            this._optionDatepicker(e, t, i)
        },
        _refreshDatepicker: function (e) {
            var t = this._getInst(e);
            t && this._updateDatepicker(t)
        },
        _setDateDatepicker: function (e, t) {
            var i = this._getInst(e);
            i && (this._setDate(i, t), this._updateDatepicker(i), this._updateAlternate(i))
        },
        _getDateDatepicker: function (e, t) {
            var i = this._getInst(e);
            return i && !i.inline && this._setDateFromField(i, t), i ? this._getDate(i) : null
        },
        _doKeyDown: function (t) {
            var i, n, o, s = e.datepicker._getInst(t.target),
                r = !0,
                a = s.dpDiv.is(".ui-datepicker-rtl");
            if (s._keyEvent = !0, e.datepicker._datepickerShowing) switch (t.keyCode) {
                case 9:
                    e.datepicker._hideDatepicker(), r = !1;
                    break;
                case 13:
                    return o = e("td." + e.datepicker._dayOverClass + ":not(." + e.datepicker._currentClass + ")", s.dpDiv), o[0] && e.datepicker._selectDay(t.target, s.selectedMonth, s.selectedYear, o[0]), i = e.datepicker._get(s, "onSelect"), i ? (n = e.datepicker._formatDate(s), i.apply(s.input ? s.input[0] : null, [n, s])) : e.datepicker._hideDatepicker(), !1;
                case 27:
                    e.datepicker._hideDatepicker();
                    break;
                case 33:
                    e.datepicker._adjustDate(t.target, t.ctrlKey ? -e.datepicker._get(s, "stepBigMonths") : -e.datepicker._get(s, "stepMonths"), "M");
                    break;
                case 34:
                    e.datepicker._adjustDate(t.target, t.ctrlKey ? +e.datepicker._get(s, "stepBigMonths") : +e.datepicker._get(s, "stepMonths"), "M");
                    break;
                case 35:
                    (t.ctrlKey || t.metaKey) && e.datepicker._clearDate(t.target), r = t.ctrlKey || t.metaKey;
                    break;
                case 36:
                    (t.ctrlKey || t.metaKey) && e.datepicker._gotoToday(t.target), r = t.ctrlKey || t.metaKey;
                    break;
                case 37:
                    (t.ctrlKey || t.metaKey) && e.datepicker._adjustDate(t.target, a ? 1 : -1, "D"), r = t.ctrlKey || t.metaKey, t.originalEvent.altKey && e.datepicker._adjustDate(t.target, t.ctrlKey ? -e.datepicker._get(s, "stepBigMonths") : -e.datepicker._get(s, "stepMonths"), "M");
                    break;
                case 38:
                    (t.ctrlKey || t.metaKey) && e.datepicker._adjustDate(t.target, -7, "D"), r = t.ctrlKey || t.metaKey;
                    break;
                case 39:
                    (t.ctrlKey || t.metaKey) && e.datepicker._adjustDate(t.target, a ? -1 : 1, "D"), r = t.ctrlKey || t.metaKey, t.originalEvent.altKey && e.datepicker._adjustDate(t.target, t.ctrlKey ? +e.datepicker._get(s, "stepBigMonths") : +e.datepicker._get(s, "stepMonths"), "M");
                    break;
                case 40:
                    (t.ctrlKey || t.metaKey) && e.datepicker._adjustDate(t.target, 7, "D"), r = t.ctrlKey || t.metaKey;
                    break;
                default:
                    r = !1
            } else 36 === t.keyCode && t.ctrlKey ? e.datepicker._showDatepicker(this) : r = !1;
            r && (t.preventDefault(), t.stopPropagation())
        },
        _doKeyPress: function (t) {
            var i, n, o = e.datepicker._getInst(t.target);
            return e.datepicker._get(o, "constrainInput") ? (i = e.datepicker._possibleChars(e.datepicker._get(o, "dateFormat")), n = String.fromCharCode(null == t.charCode ? t.keyCode : t.charCode), t.ctrlKey || t.metaKey || " " > n || !i || i.indexOf(n) > -1) : void 0
        },
        _doKeyUp: function (t) {
            var i, n = e.datepicker._getInst(t.target);
            if (n.input.val() !== n.lastVal) try {
                i = e.datepicker.parseDate(e.datepicker._get(n, "dateFormat"), n.input ? n.input.val() : null, e.datepicker._getFormatConfig(n)), i && (e.datepicker._setDateFromField(n), e.datepicker._updateAlternate(n), e.datepicker._updateDatepicker(n))
            } catch (o) {}
            return !0
        },
        _showDatepicker: function (t) {
            if (t = t.target || t, "input" !== t.nodeName.toLowerCase() && (t = e("input", t.parentNode)[0]), !e.datepicker._isDisabledDatepicker(t) && e.datepicker._lastInput !== t) {
                var i, o, s, r, l, c, d;
                i = e.datepicker._getInst(t), e.datepicker._curInst && e.datepicker._curInst !== i && (e.datepicker._curInst.dpDiv.stop(!0, !0), i && e.datepicker._datepickerShowing && e.datepicker._hideDatepicker(e.datepicker._curInst.input[0])), o = e.datepicker._get(i, "beforeShow"), s = o ? o.apply(t, [t, i]) : {}, s !== !1 && (a(i.settings, s), i.lastVal = null, e.datepicker._lastInput = t, e.datepicker._setDateFromField(i), e.datepicker._inDialog && (t.value = ""), e.datepicker._pos || (e.datepicker._pos = e.datepicker._findPos(t), e.datepicker._pos[1] += t.offsetHeight), r = !1, e(t).parents().each(function () {
                    return r |= "fixed" === e(this).css("position"), !r
                }), l = {
                    left: e.datepicker._pos[0],
                    top: e.datepicker._pos[1]
                }, e.datepicker._pos = null, i.dpDiv.empty(), i.dpDiv.css({
                    position: "absolute",
                    display: "block",
                    top: "-1000px"
                }), e.datepicker._updateDatepicker(i), l = e.datepicker._checkOffset(i, l, r), i.dpDiv.css({
                    position: e.datepicker._inDialog && e.blockUI ? "static" : r ? "fixed" : "absolute",
                    display: "none",
                    left: l.left + "px",
                    top: l.top + "px"
                }), i.inline || (c = e.datepicker._get(i, "showAnim"), d = e.datepicker._get(i, "duration"), i.dpDiv.css("z-index", n(e(t)) + 1), e.datepicker._datepickerShowing = !0, e.effects && e.effects.effect[c] ? i.dpDiv.show(c, e.datepicker._get(i, "showOptions"), d) : i.dpDiv[c || "show"](c ? d : null), e.datepicker._shouldFocusInput(i) && i.input.focus(), e.datepicker._curInst = i))
            }
        },
        _updateDatepicker: function (t) {
            this.maxRows = 4, u = t, t.dpDiv.empty().append(this._generateHTML(t)), this._attachHandlers(t);
            var i, n = this._getNumberOfMonths(t),
                o = n[1],
                s = 17,
                a = t.dpDiv.find("." + this._dayOverClass + " a");
            a.length > 0 && r.apply(a.get(0)), t.dpDiv.removeClass("ui-datepicker-multi-2 ui-datepicker-multi-3 ui-datepicker-multi-4").width(""), o > 1 && t.dpDiv.addClass("ui-datepicker-multi-" + o).css("width", s * o + "em"), t.dpDiv[(1 !== n[0] || 1 !== n[1] ? "add" : "remove") + "Class"]("ui-datepicker-multi"), t.dpDiv[(this._get(t, "isRTL") ? "add" : "remove") + "Class"]("ui-datepicker-rtl"), t === e.datepicker._curInst && e.datepicker._datepickerShowing && e.datepicker._shouldFocusInput(t) && t.input.focus(), t.yearshtml && (i = t.yearshtml, setTimeout(function () {
                i === t.yearshtml && t.yearshtml && t.dpDiv.find("select.ui-datepicker-year:first").replaceWith(t.yearshtml), i = t.yearshtml = null
            }, 0))
        },
        _shouldFocusInput: function (e) {
            return e.input && e.input.is(":visible") && !e.input.is(":disabled") && !e.input.is(":focus")
        },
        _checkOffset: function (t, i, n) {
            var o = t.dpDiv.outerWidth(),
                s = t.dpDiv.outerHeight(),
                r = t.input ? t.input.outerWidth() : 0,
                a = t.input ? t.input.outerHeight() : 0,
                l = document.documentElement.clientWidth + (n ? 0 : e(document).scrollLeft()),
                c = document.documentElement.clientHeight + (n ? 0 : e(document).scrollTop());
            return i.left -= this._get(t, "isRTL") ? o - r : 0, i.left -= n && i.left === t.input.offset().left ? e(document).scrollLeft() : 0, i.top -= n && i.top === t.input.offset().top + a ? e(document).scrollTop() : 0, i.left -= Math.min(i.left, i.left + o > l && l > o ? Math.abs(i.left + o - l) : 0), i.top -= Math.min(i.top, i.top + s > c && c > s ? Math.abs(s + a) : 0), i
        },
        _findPos: function (t) {
            for (var i, n = this._getInst(t), o = this._get(n, "isRTL"); t && ("hidden" === t.type || 1 !== t.nodeType || e.expr.filters.hidden(t));) t = t[o ? "previousSibling" : "nextSibling"];
            return i = e(t).offset(), [i.left, i.top]
        },
        _hideDatepicker: function (t) {
            var i, n, o, s, r = this._curInst;
            !r || t && r !== e.data(t, "datepicker") || this._datepickerShowing && (i = this._get(r, "showAnim"), n = this._get(r, "duration"), o = function () {
                e.datepicker._tidyDialog(r)
            }, e.effects && (e.effects.effect[i] || e.effects[i]) ? r.dpDiv.hide(i, e.datepicker._get(r, "showOptions"), n, o) : r.dpDiv["slideDown" === i ? "slideUp" : "fadeIn" === i ? "fadeOut" : "hide"](i ? n : null, o), i || o(), this._datepickerShowing = !1, s = this._get(r, "onClose"), s && s.apply(r.input ? r.input[0] : null, [r.input ? r.input.val() : "", r]), this._lastInput = null, this._inDialog && (this._dialogInput.css({
                position: "absolute",
                left: "0",
                top: "-100px"
            }), e.blockUI && (e.unblockUI(), e("body").append(this.dpDiv))), this._inDialog = !1)
        },
        _tidyDialog: function (e) {
            e.dpDiv.removeClass(this._dialogClass).unbind(".ui-datepicker-calendar")
        },
        _checkExternalClick: function (t) {
            if (e.datepicker._curInst) {
                var i = e(t.target),
                    n = e.datepicker._getInst(i[0]);
                (i[0].id !== e.datepicker._mainDivId && 0 === i.parents("#" + e.datepicker._mainDivId).length && !i.hasClass(e.datepicker.markerClassName) && !i.closest("." + e.datepicker._triggerClass).length && e.datepicker._datepickerShowing && (!e.datepicker._inDialog || !e.blockUI) || i.hasClass(e.datepicker.markerClassName) && e.datepicker._curInst !== n) && e.datepicker._hideDatepicker()
            }
        },
        _adjustDate: function (t, i, n) {
            var o = e(t),
                s = this._getInst(o[0]);
            this._isDisabledDatepicker(o[0]) || (this._adjustInstDate(s, i + ("M" === n ? this._get(s, "showCurrentAtPos") : 0), n), this._updateDatepicker(s))
        },
        _gotoToday: function (t) {
            var i, n = e(t),
                o = this._getInst(n[0]);
            this._get(o, "gotoCurrent") && o.currentDay ? (o.selectedDay = o.currentDay, o.drawMonth = o.selectedMonth = o.currentMonth, o.drawYear = o.selectedYear = o.currentYear) : (i = new Date, o.selectedDay = i.getDate(), o.drawMonth = o.selectedMonth = i.getMonth(), o.drawYear = o.selectedYear = i.getFullYear()), this._notifyChange(o), this._adjustDate(n)
        },
        _selectMonthYear: function (t, i, n) {
            var o = e(t),
                s = this._getInst(o[0]);
            s["selected" + ("M" === n ? "Month" : "Year")] = s["draw" + ("M" === n ? "Month" : "Year")] = parseInt(i.options[i.selectedIndex].value, 10), this._notifyChange(s), this._adjustDate(o)
        },
        _selectDay: function (t, i, n, o) {
            var s, r = e(t);
            e(o).hasClass(this._unselectableClass) || this._isDisabledDatepicker(r[0]) || (s = this._getInst(r[0]), s.selectedDay = s.currentDay = e("a", o).html(), s.selectedMonth = s.currentMonth = i, s.selectedYear = s.currentYear = n, this._selectDate(t, this._formatDate(s, s.currentDay, s.currentMonth, s.currentYear)))
        },
        _clearDate: function (t) {
            var i = e(t);
            this._selectDate(i, "")
        },
        _selectDate: function (t, i) {
            var n, o = e(t),
                s = this._getInst(o[0]);
            i = null != i ? i : this._formatDate(s), s.input && s.input.val(i), this._updateAlternate(s), n = this._get(s, "onSelect"), n ? n.apply(s.input ? s.input[0] : null, [i, s]) : s.input && s.input.trigger("change"), s.inline ? this._updateDatepicker(s) : (this._hideDatepicker(), this._lastInput = s.input[0], "object" != typeof s.input[0] && s.input.focus(), this._lastInput = null)
        },
        _updateAlternate: function (t) {
            var i, n, o, s = this._get(t, "altField");
            s && (i = this._get(t, "altFormat") || this._get(t, "dateFormat"), n = this._getDate(t), o = this.formatDate(i, n, this._getFormatConfig(t)), e(s).each(function () {
                e(this).val(o)
            }))
        },
        noWeekends: function (e) {
            var t = e.getDay();
            return [t > 0 && 6 > t, ""]
        },
        iso8601Week: function (e) {
            var t, i = new Date(e.getTime());
            return i.setDate(i.getDate() + 4 - (i.getDay() || 7)), t = i.getTime(), i.setMonth(0), i.setDate(1), Math.floor(Math.round((t - i) / 864e5) / 7) + 1
        },
        parseDate: function (t, i, n) {
            if (null == t || null == i) throw "Invalid arguments";
            if (i = "object" == typeof i ? i.toString() : i + "", "" === i) return null;
            var o, s, r, a, l = 0,
                c = (n ? n.shortYearCutoff : null) || this._defaults.shortYearCutoff,
                d = "string" != typeof c ? c : (new Date).getFullYear() % 100 + parseInt(c, 10),
                u = (n ? n.dayNamesShort : null) || this._defaults.dayNamesShort,
                h = (n ? n.dayNames : null) || this._defaults.dayNames,
                p = (n ? n.monthNamesShort : null) || this._defaults.monthNamesShort,
                f = (n ? n.monthNames : null) || this._defaults.monthNames,
                g = -1,
                m = -1,
                v = -1,
                y = -1,
                b = !1,
                w = function (e) {
                    var i = o + 1 < t.length && t.charAt(o + 1) === e;
                    return i && o++, i
                },
                k = function (e) {
                    var t = w(e),
                        n = "@" === e ? 14 : "!" === e ? 20 : "y" === e && t ? 4 : "o" === e ? 3 : 2,
                        o = "y" === e ? n : 1,
                        s = new RegExp("^\\d{" + o + "," + n + "}"),
                        r = i.substring(l).match(s);
                    if (!r) throw "Missing number at position " + l;
                    return l += r[0].length, parseInt(r[0], 10)
                },
                _ = function (t, n, o) {
                    var s = -1,
                        r = e.map(w(t) ? o : n, function (e, t) {
                            return [
                                [t, e]
                            ]
                        }).sort(function (e, t) {
                            return -(e[1].length - t[1].length)
                        });
                    if (e.each(r, function (e, t) {
                            var n = t[1];
                            return i.substr(l, n.length).toLowerCase() === n.toLowerCase() ? (s = t[0], l += n.length, !1) : void 0
                        }), -1 !== s) return s + 1;
                    throw "Unknown name at position " + l
                },
                x = function () {
                    if (i.charAt(l) !== t.charAt(o)) throw "Unexpected literal at position " + l;
                    l++
                };
            for (o = 0; o < t.length; o++)
                if (b) "'" !== t.charAt(o) || w("'") ? x() : b = !1;
                else switch (t.charAt(o)) {
                    case "d":
                        v = k("d");
                        break;
                    case "D":
                        _("D", u, h);
                        break;
                    case "o":
                        y = k("o");
                        break;
                    case "m":
                        m = k("m");
                        break;
                    case "M":
                        m = _("M", p, f);
                        break;
                    case "y":
                        g = k("y");
                        break;
                    case "@":
                        a = new Date(k("@")), g = a.getFullYear(), m = a.getMonth() + 1, v = a.getDate();
                        break;
                    case "!":
                        a = new Date((k("!") - this._ticksTo1970) / 1e4), g = a.getFullYear(), m = a.getMonth() + 1, v = a.getDate();
                        break;
                    case "'":
                        w("'") ? x() : b = !0;
                        break;
                    default:
                        x()
                }
                if (l < i.length && (r = i.substr(l), !/^\s+/.test(r))) throw "Extra/unparsed characters found in date: " + r;
            if (-1 === g ? g = (new Date).getFullYear() : 100 > g && (g += (new Date).getFullYear() - (new Date).getFullYear() % 100 + (d >= g ? 0 : -100)), y > -1)
                for (m = 1, v = y;;) {
                    if (s = this._getDaysInMonth(g, m - 1), s >= v) break;
                    m++, v -= s
                }
            if (a = this._daylightSavingAdjust(new Date(g, m - 1, v)), a.getFullYear() !== g || a.getMonth() + 1 !== m || a.getDate() !== v) throw "Invalid date";
            return a
        },
        ATOM: "yy-mm-dd",
        COOKIE: "D, dd M yy",
        ISO_8601: "yy-mm-dd",
        RFC_822: "D, d M y",
        RFC_850: "DD, dd-M-y",
        RFC_1036: "D, d M y",
        RFC_1123: "D, d M yy",
        RFC_2822: "D, d M yy",
        RSS: "D, d M y",
        TICKS: "!",
        TIMESTAMP: "@",
        W3C: "yy-mm-dd",
        _ticksTo1970: 24 * (718685 + Math.floor(492.5) - Math.floor(19.7) + Math.floor(4.925)) * 60 * 60 * 1e7,
        formatDate: function (e, t, i) {
            if (!t) return "";
            var n, o = (i ? i.dayNamesShort : null) || this._defaults.dayNamesShort,
                s = (i ? i.dayNames : null) || this._defaults.dayNames,
                r = (i ? i.monthNamesShort : null) || this._defaults.monthNamesShort,
                a = (i ? i.monthNames : null) || this._defaults.monthNames,
                l = function (t) {
                    var i = n + 1 < e.length && e.charAt(n + 1) === t;
                    return i && n++, i
                },
                c = function (e, t, i) {
                    var n = "" + t;
                    if (l(e))
                        for (; n.length < i;) n = "0" + n;
                    return n
                },
                d = function (e, t, i, n) {
                    return l(e) ? n[t] : i[t]
                },
                u = "",
                h = !1;
            if (t)
                for (n = 0; n < e.length; n++)
                    if (h) "'" !== e.charAt(n) || l("'") ? u += e.charAt(n) : h = !1;
                    else switch (e.charAt(n)) {
                        case "d":
                            u += c("d", t.getDate(), 2);
                            break;
                        case "D":
                            u += d("D", t.getDay(), o, s);
                            break;
                        case "o":
                            u += c("o", Math.round((new Date(t.getFullYear(), t.getMonth(), t.getDate()).getTime() - new Date(t.getFullYear(), 0, 0).getTime()) / 864e5), 3);
                            break;
                        case "m":
                            u += c("m", t.getMonth() + 1, 2);
                            break;
                        case "M":
                            u += d("M", t.getMonth(), r, a);
                            break;
                        case "y":
                            u += l("y") ? t.getFullYear() : (t.getYear() % 100 < 10 ? "0" : "") + t.getYear() % 100;
                            break;
                        case "@":
                            u += t.getTime();
                            break;
                        case "!":
                            u += 1e4 * t.getTime() + this._ticksTo1970;
                            break;
                        case "'":
                            l("'") ? u += "'" : h = !0;
                            break;
                        default:
                            u += e.charAt(n)
                    }
                    return u
        },
        _possibleChars: function (e) {
            var t, i = "",
                n = !1,
                o = function (i) {
                    var n = t + 1 < e.length && e.charAt(t + 1) === i;
                    return n && t++, n
                };
            for (t = 0; t < e.length; t++)
                if (n) "'" !== e.charAt(t) || o("'") ? i += e.charAt(t) : n = !1;
                else switch (e.charAt(t)) {
                    case "d":
                    case "m":
                    case "y":
                    case "@":
                        i += "0123456789";
                        break;
                    case "D":
                    case "M":
                        return null;
                    case "'":
                        o("'") ? i += "'" : n = !0;
                        break;
                    default:
                        i += e.charAt(t)
                }
                return i
        },
        _get: function (e, t) {
            return void 0 !== e.settings[t] ? e.settings[t] : this._defaults[t]
        },
        _setDateFromField: function (e, t) {
            if (e.input.val() !== e.lastVal) {
                var i = this._get(e, "dateFormat"),
                    n = e.lastVal = e.input ? e.input.val() : null,
                    o = this._getDefaultDate(e),
                    s = o,
                    r = this._getFormatConfig(e);
                try {
                    s = this.parseDate(i, n, r) || o
                } catch (a) {
                    n = t ? "" : n
                }
                e.selectedDay = s.getDate(), e.drawMonth = e.selectedMonth = s.getMonth(), e.drawYear = e.selectedYear = s.getFullYear(), e.currentDay = n ? s.getDate() : 0, e.currentMonth = n ? s.getMonth() : 0, e.currentYear = n ? s.getFullYear() : 0, this._adjustInstDate(e)
            }
        },
        _getDefaultDate: function (e) {
            return this._restrictMinMax(e, this._determineDate(e, this._get(e, "defaultDate"), new Date))
        },
        _determineDate: function (t, i, n) {
            var o = function (e) {
                    var t = new Date;
                    return t.setDate(t.getDate() + e), t
                },
                s = function (i) {
                    try {
                        return e.datepicker.parseDate(e.datepicker._get(t, "dateFormat"), i, e.datepicker._getFormatConfig(t))
                    } catch (n) {}
                    for (var o = (i.toLowerCase().match(/^c/) ? e.datepicker._getDate(t) : null) || new Date, s = o.getFullYear(), r = o.getMonth(), a = o.getDate(), l = /([+\-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g, c = l.exec(i); c;) {
                        switch (c[2] || "d") {
                            case "d":
                            case "D":
                                a += parseInt(c[1], 10);
                                break;
                            case "w":
                            case "W":
                                a += 7 * parseInt(c[1], 10);
                                break;
                            case "m":
                            case "M":
                                r += parseInt(c[1], 10), a = Math.min(a, e.datepicker._getDaysInMonth(s, r));
                                break;
                            case "y":
                            case "Y":
                                s += parseInt(c[1], 10), a = Math.min(a, e.datepicker._getDaysInMonth(s, r))
                        }
                        c = l.exec(i)
                    }
                    return new Date(s, r, a)
                },
                r = null == i || "" === i ? n : "string" == typeof i ? s(i) : "number" == typeof i ? isNaN(i) ? n : o(i) : new Date(i.getTime());
            return r = r && "Invalid Date" === r.toString() ? n : r, r && (r.setHours(0), r.setMinutes(0), r.setSeconds(0), r.setMilliseconds(0)), this._daylightSavingAdjust(r)
        },
        _daylightSavingAdjust: function (e) {
            return e ? (e.setHours(e.getHours() > 12 ? e.getHours() + 2 : 0), e) : null
        },
        _setDate: function (e, t, i) {
            var n = !t,
                o = e.selectedMonth,
                s = e.selectedYear,
                r = this._restrictMinMax(e, this._determineDate(e, t, new Date));
            e.selectedDay = e.currentDay = r.getDate(), e.drawMonth = e.selectedMonth = e.currentMonth = r.getMonth(), e.drawYear = e.selectedYear = e.currentYear = r.getFullYear(), o === e.selectedMonth && s === e.selectedYear || i || this._notifyChange(e), this._adjustInstDate(e), e.input && e.input.val(n ? "" : this._formatDate(e))
        },
        _getDate: function (e) {
            var t = !e.currentYear || e.input && "" === e.input.val() ? null : this._daylightSavingAdjust(new Date(e.currentYear, e.currentMonth, e.currentDay));
            return t
        },
        _attachHandlers: function (t) {
            var i = this._get(t, "stepMonths"),
                n = "#" + t.id.replace(/\\\\/g, "\\");
            t.dpDiv.find("[data-handler]").map(function () {
                var t = {
                    prev: function () {
                        e.datepicker._adjustDate(n, -i, "M")
                    },
                    next: function () {
                        e.datepicker._adjustDate(n, +i, "M")
                    },
                    hide: function () {
                        e.datepicker._hideDatepicker()
                    },
                    today: function () {
                        e.datepicker._gotoToday(n)
                    },
                    selectDay: function () {
                        return e.datepicker._selectDay(n, +this.getAttribute("data-month"), +this.getAttribute("data-year"), this), !1
                    },
                    selectMonth: function () {
                        return e.datepicker._selectMonthYear(n, this, "M"), !1
                    },
                    selectYear: function () {
                        return e.datepicker._selectMonthYear(n, this, "Y"), !1
                    }
                };
                e(this).bind(this.getAttribute("data-event"), t[this.getAttribute("data-handler")])
            })
        },
        _generateHTML: function (e) {
            var t, i, n, o, s, r, a, l, c, d, u, h, p, f, g, m, v, y, b, w, k, _, x, C, T, S, D, M, I, E, A, $, O, H, P, N, L, W, R, j = new Date,
                F = this._daylightSavingAdjust(new Date(j.getFullYear(), j.getMonth(), j.getDate())),
                z = this._get(e, "isRTL"),
                B = this._get(e, "showButtonPanel"),
                Y = this._get(e, "hideIfNoPrevNext"),
                q = this._get(e, "navigationAsDateFormat"),
                U = this._getNumberOfMonths(e),
                K = this._get(e, "showCurrentAtPos"),
                Q = this._get(e, "stepMonths"),
                V = 1 !== U[0] || 1 !== U[1],
                X = this._daylightSavingAdjust(e.currentDay ? new Date(e.currentYear, e.currentMonth, e.currentDay) : new Date(9999, 9, 9)),
                G = this._getMinMaxDate(e, "min"),
                J = this._getMinMaxDate(e, "max"),
                Z = e.drawMonth - K,
                ee = e.drawYear;
            if (0 > Z && (Z += 12, ee--), J)
                for (t = this._daylightSavingAdjust(new Date(J.getFullYear(), J.getMonth() - U[0] * U[1] + 1, J.getDate())), t = G && G > t ? G : t; this._daylightSavingAdjust(new Date(ee, Z, 1)) > t;) Z--, 0 > Z && (Z = 11, ee--);
            for (e.drawMonth = Z, e.drawYear = ee, i = this._get(e, "prevText"), i = q ? this.formatDate(i, this._daylightSavingAdjust(new Date(ee, Z - Q, 1)), this._getFormatConfig(e)) : i, n = this._canAdjustMonth(e, -1, ee, Z) ? "<a class='ui-datepicker-prev ui-corner-all' data-handler='prev' data-event='click' title='" + i + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "e" : "w") + "'>" + i + "</span></a>" : Y ? "" : "<a class='ui-datepicker-prev ui-corner-all ui-state-disabled' title='" + i + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "e" : "w") + "'>" + i + "</span></a>", o = this._get(e, "nextText"), o = q ? this.formatDate(o, this._daylightSavingAdjust(new Date(ee, Z + Q, 1)), this._getFormatConfig(e)) : o, s = this._canAdjustMonth(e, 1, ee, Z) ? "<a class='ui-datepicker-next ui-corner-all' data-handler='next' data-event='click' title='" + o + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "w" : "e") + "'>" + o + "</span></a>" : Y ? "" : "<a class='ui-datepicker-next ui-corner-all ui-state-disabled' title='" + o + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "w" : "e") + "'>" + o + "</span></a>", r = this._get(e, "currentText"), a = this._get(e, "gotoCurrent") && e.currentDay ? X : F, r = q ? this.formatDate(r, a, this._getFormatConfig(e)) : r, l = e.inline ? "" : "<button type='button' class='ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all' data-handler='hide' data-event='click'>" + this._get(e, "closeText") + "</button>", c = B ? "<div class='ui-datepicker-buttonpane ui-widget-content'>" + (z ? l : "") + (this._isInRange(e, a) ? "<button type='button' class='ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all' data-handler='today' data-event='click'>" + r + "</button>" : "") + (z ? "" : l) + "</div>" : "", d = parseInt(this._get(e, "firstDay"), 10), d = isNaN(d) ? 0 : d, u = this._get(e, "showWeek"), h = this._get(e, "dayNames"), p = this._get(e, "dayNamesMin"), f = this._get(e, "monthNames"), g = this._get(e, "monthNamesShort"), m = this._get(e, "beforeShowDay"), v = this._get(e, "showOtherMonths"), y = this._get(e, "selectOtherMonths"), b = this._getDefaultDate(e), w = "", _ = 0; _ < U[0]; _++) {
                for (x = "", this.maxRows = 4, C = 0; C < U[1]; C++) {
                    if (T = this._daylightSavingAdjust(new Date(ee, Z, e.selectedDay)), S = " ui-corner-all", D = "", V) {
                        if (D += "<div class='ui-datepicker-group", U[1] > 1) switch (C) {
                            case 0:
                                D += " ui-datepicker-group-first", S = " ui-corner-" + (z ? "right" : "left");
                                break;
                            case U[1] - 1:
                                D += " ui-datepicker-group-last", S = " ui-corner-" + (z ? "left" : "right");
                                break;
                            default:
                                D += " ui-datepicker-group-middle", S = ""
                        }
                        D += "'>"
                    }
                    for (D += "<div class='ui-datepicker-header ui-widget-header ui-helper-clearfix" + S + "'>" + (/all|left/.test(S) && 0 === _ ? z ? s : n : "") + (/all|right/.test(S) && 0 === _ ? z ? n : s : "") + this._generateMonthYearHeader(e, Z, ee, G, J, _ > 0 || C > 0, f, g) + "</div><table class='ui-datepicker-calendar'><thead><tr>", M = u ? "<th class='ui-datepicker-week-col'>" + this._get(e, "weekHeader") + "</th>" : "", k = 0; 7 > k; k++) I = (k + d) % 7, M += "<th scope='col'" + ((k + d + 6) % 7 >= 5 ? " class='ui-datepicker-week-end'" : "") + "><span title='" + h[I] + "'>" + p[I] + "</span></th>";
                    for (D += M + "</tr></thead><tbody>", E = this._getDaysInMonth(ee, Z), ee === e.selectedYear && Z === e.selectedMonth && (e.selectedDay = Math.min(e.selectedDay, E)), A = (this._getFirstDayOfMonth(ee, Z) - d + 7) % 7, $ = Math.ceil((A + E) / 7), O = V && this.maxRows > $ ? this.maxRows : $, this.maxRows = O, H = this._daylightSavingAdjust(new Date(ee, Z, 1 - A)), P = 0; O > P; P++) {
                        for (D += "<tr>", N = u ? "<td class='ui-datepicker-week-col'>" + this._get(e, "calculateWeek")(H) + "</td>" : "", k = 0; 7 > k; k++) L = m ? m.apply(e.input ? e.input[0] : null, [H]) : [!0, ""], W = H.getMonth() !== Z, R = W && !y || !L[0] || G && G > H || J && H > J, N += "<td class='" + ((k + d + 6) % 7 >= 5 ? " ui-datepicker-week-end" : "") + (W ? " ui-datepicker-other-month" : "") + (H.getTime() === T.getTime() && Z === e.selectedMonth && e._keyEvent || b.getTime() === H.getTime() && b.getTime() === T.getTime() ? " " + this._dayOverClass : "") + (R ? " " + this._unselectableClass + " ui-state-disabled" : "") + (W && !v ? "" : " " + L[1] + (H.getTime() === X.getTime() ? " " + this._currentClass : "") + (H.getTime() === F.getTime() ? " ui-datepicker-today" : "")) + "'" + (W && !v || !L[2] ? "" : " title='" + L[2].replace(/'/g, "&#39;") + "'") + (R ? "" : " data-handler='selectDay' data-event='click' data-month='" + H.getMonth() + "' data-year='" + H.getFullYear() + "'") + ">" + (W && !v ? "&#xa0;" : R ? "<span class='ui-state-default'>" + H.getDate() + "</span>" : "<a class='ui-state-default" + (H.getTime() === F.getTime() ? " ui-state-highlight" : "") + (H.getTime() === X.getTime() ? " ui-state-active" : "") + (W ? " ui-priority-secondary" : "") + "' href='#'>" + H.getDate() + "</a>") + "</td>", H.setDate(H.getDate() + 1), H = this._daylightSavingAdjust(H);
                        D += N + "</tr>"
                    }
                    Z++, Z > 11 && (Z = 0, ee++), D += "</tbody></table>" + (V ? "</div>" + (U[0] > 0 && C === U[1] - 1 ? "<div class='ui-datepicker-row-break'></div>" : "") : ""), x += D
                }
                w += x
            }
            return w += c, e._keyEvent = !1, w
        },
        _generateMonthYearHeader: function (e, t, i, n, o, s, r, a) {
            var l, c, d, u, h, p, f, g, m = this._get(e, "changeMonth"),
                v = this._get(e, "changeYear"),
                y = this._get(e, "showMonthAfterYear"),
                b = "<div class='ui-datepicker-title'>",
                w = "";
            if (s || !m) w += "<span class='ui-datepicker-month'>" + r[t] + "</span>";
            else {
                for (l = n && n.getFullYear() === i, c = o && o.getFullYear() === i, w += "<select class='ui-datepicker-month' data-handler='selectMonth' data-event='change'>", d = 0; 12 > d; d++)(!l || d >= n.getMonth()) && (!c || d <= o.getMonth()) && (w += "<option value='" + d + "'" + (d === t ? " selected='selected'" : "") + ">" + a[d] + "</option>");
                w += "</select>"
            }
            if (y || (b += w + (!s && m && v ? "" : "&#xa0;")), !e.yearshtml)
                if (e.yearshtml = "", s || !v) b += "<span class='ui-datepicker-year'>" + i + "</span>";
                else {
                    for (u = this._get(e, "yearRange").split(":"), h = (new Date).getFullYear(), p = function (e) {
                            var t = e.match(/c[+\-].*/) ? i + parseInt(e.substring(1), 10) : e.match(/[+\-].*/) ? h + parseInt(e, 10) : parseInt(e, 10);
                            return isNaN(t) ? h : t
                        }, f = p(u[0]), g = Math.max(f, p(u[1] || "")), f = n ? Math.max(f, n.getFullYear()) : f, g = o ? Math.min(g, o.getFullYear()) : g, e.yearshtml += "<select class='ui-datepicker-year' data-handler='selectYear' data-event='change'>"; g >= f; f++) e.yearshtml += "<option value='" + f + "'" + (f === i ? " selected='selected'" : "") + ">" + f + "</option>";
                    e.yearshtml += "</select>", b += e.yearshtml, e.yearshtml = null
                }
            return b += this._get(e, "yearSuffix"), y && (b += (!s && m && v ? "" : "&#xa0;") + w), b += "</div>"
        },
        _adjustInstDate: function (e, t, i) {
            var n = e.drawYear + ("Y" === i ? t : 0),
                o = e.drawMonth + ("M" === i ? t : 0),
                s = Math.min(e.selectedDay, this._getDaysInMonth(n, o)) + ("D" === i ? t : 0),
                r = this._restrictMinMax(e, this._daylightSavingAdjust(new Date(n, o, s)));
            e.selectedDay = r.getDate(), e.drawMonth = e.selectedMonth = r.getMonth(), e.drawYear = e.selectedYear = r.getFullYear(), ("M" === i || "Y" === i) && this._notifyChange(e)
        },
        _restrictMinMax: function (e, t) {
            var i = this._getMinMaxDate(e, "min"),
                n = this._getMinMaxDate(e, "max"),
                o = i && i > t ? i : t;
            return n && o > n ? n : o
        },
        _notifyChange: function (e) {
            var t = this._get(e, "onChangeMonthYear");
            t && t.apply(e.input ? e.input[0] : null, [e.selectedYear, e.selectedMonth + 1, e])
        },
        _getNumberOfMonths: function (e) {
            var t = this._get(e, "numberOfMonths");
            return null == t ? [1, 1] : "number" == typeof t ? [1, t] : t
        },
        _getMinMaxDate: function (e, t) {
            return this._determineDate(e, this._get(e, t + "Date"), null)
        },
        _getDaysInMonth: function (e, t) {
            return 32 - this._daylightSavingAdjust(new Date(e, t, 32)).getDate()
        },
        _getFirstDayOfMonth: function (e, t) {
            return new Date(e, t, 1).getDay()
        },
        _canAdjustMonth: function (e, t, i, n) {
            var o = this._getNumberOfMonths(e),
                s = this._daylightSavingAdjust(new Date(i, n + (0 > t ? t : o[0] * o[1]), 1));
            return 0 > t && s.setDate(this._getDaysInMonth(s.getFullYear(), s.getMonth())), this._isInRange(e, s)
        },
        _isInRange: function (e, t) {
            var i, n, o = this._getMinMaxDate(e, "min"),
                s = this._getMinMaxDate(e, "max"),
                r = null,
                a = null,
                l = this._get(e, "yearRange");
            return l && (i = l.split(":"), n = (new Date).getFullYear(), r = parseInt(i[0], 10), a = parseInt(i[1], 10), i[0].match(/[+\-].*/) && (r += n), i[1].match(/[+\-].*/) && (a += n)), (!o || t.getTime() >= o.getTime()) && (!s || t.getTime() <= s.getTime()) && (!r || t.getFullYear() >= r) && (!a || t.getFullYear() <= a)
        },
        _getFormatConfig: function (e) {
            var t = this._get(e, "shortYearCutoff");
            return t = "string" != typeof t ? t : (new Date).getFullYear() % 100 + parseInt(t, 10), {
                shortYearCutoff: t,
                dayNamesShort: this._get(e, "dayNamesShort"),
                dayNames: this._get(e, "dayNames"),
                monthNamesShort: this._get(e, "monthNamesShort"),
                monthNames: this._get(e, "monthNames")
            }
        },
        _formatDate: function (e, t, i, n) {
            t || (e.currentDay = e.selectedDay, e.currentMonth = e.selectedMonth, e.currentYear = e.selectedYear);
            var o = t ? "object" == typeof t ? t : this._daylightSavingAdjust(new Date(n, i, t)) : this._daylightSavingAdjust(new Date(e.currentYear, e.currentMonth, e.currentDay));
            return this.formatDate(this._get(e, "dateFormat"), o, this._getFormatConfig(e))
        }
    }), e.fn.datepicker = function (t) {
        if (!this.length) return this;
        e.datepicker.initialized || (e(document).mousedown(e.datepicker._checkExternalClick), e.datepicker.initialized = !0), 0 === e("#" + e.datepicker._mainDivId).length && e("body").append(e.datepicker.dpDiv);
        var i = Array.prototype.slice.call(arguments, 1);
        return "string" != typeof t || "isDisabled" !== t && "getDate" !== t && "widget" !== t ? "option" === t && 2 === arguments.length && "string" == typeof arguments[1] ? e.datepicker["_" + t + "Datepicker"].apply(e.datepicker, [this[0]].concat(i)) : this.each(function () {
            "string" == typeof t ? e.datepicker["_" + t + "Datepicker"].apply(e.datepicker, [this].concat(i)) : e.datepicker._attachDatepicker(this, t)
        }) : e.datepicker["_" + t + "Datepicker"].apply(e.datepicker, [this[0]].concat(i))
    }, e.datepicker = new o, e.datepicker.initialized = !1, e.datepicker.uuid = (new Date).getTime(), e.datepicker.version = "1.11.4";
    var h = (e.datepicker, e.widget("ui.tabs", {
            version: "1.11.4",
            delay: 300,
            options: {
                active: null,
                collapsible: !1,
                event: "click",
                heightStyle: "content",
                hide: null,
                show: null,
                activate: null,
                beforeActivate: null,
                beforeLoad: null,
                load: null
            },
            _isLocal: function () {
                var e = /#.*$/;
                return function (t) {
                    var i, n;
                    t = t.cloneNode(!1), i = t.href.replace(e, ""), n = location.href.replace(e, "");
                    try {
                        i = decodeURIComponent(i)
                    } catch (o) {}
                    try {
                        n = decodeURIComponent(n)
                    } catch (o) {}
                    return t.hash.length > 1 && i === n
                }
            }(),
            _create: function () {
                var t = this,
                    i = this.options;
                this.running = !1, this.element.addClass("ui-tabs ui-widget ui-widget-content ui-corner-all").toggleClass("ui-tabs-collapsible", i.collapsible), this._processTabs(), i.active = this._initialActive(), e.isArray(i.disabled) && (i.disabled = e.unique(i.disabled.concat(e.map(this.tabs.filter(".ui-state-disabled"), function (e) {
                    return t.tabs.index(e)
                }))).sort()), this.options.active !== !1 && this.anchors.length ? this.active = this._findActive(i.active) : this.active = e(), this._refresh(), this.active.length && this.load(i.active)
            },
            _initialActive: function () {
                var t = this.options.active,
                    i = this.options.collapsible,
                    n = location.hash.substring(1);
                return null === t && (n && this.tabs.each(function (i, o) {
                    return e(o).attr("aria-controls") === n ? (t = i, !1) : void 0
                }), null === t && (t = this.tabs.index(this.tabs.filter(".ui-tabs-active"))), (null === t || -1 === t) && (t = this.tabs.length ? 0 : !1)), t !== !1 && (t = this.tabs.index(this.tabs.eq(t)), -1 === t && (t = i ? !1 : 0)), !i && t === !1 && this.anchors.length && (t = 0), t
            },
            _getCreateEventData: function () {
                return {
                    tab: this.active,
                    panel: this.active.length ? this._getPanelForTab(this.active) : e()
                }
            },
            _tabKeydown: function (t) {
                var i = e(this.document[0].activeElement).closest("li"),
                    n = this.tabs.index(i),
                    o = !0;
                if (!this._handlePageNav(t)) {
                    switch (t.keyCode) {
                        case e.ui.keyCode.RIGHT:
                        case e.ui.keyCode.DOWN:
                            n++;
                            break;
                        case e.ui.keyCode.UP:
                        case e.ui.keyCode.LEFT:
                            o = !1, n--;
                            break;
                        case e.ui.keyCode.END:
                            n = this.anchors.length - 1;
                            break;
                        case e.ui.keyCode.HOME:
                            n = 0;
                            break;
                        case e.ui.keyCode.SPACE:
                            return t.preventDefault(), clearTimeout(this.activating), void this._activate(n);
                        case e.ui.keyCode.ENTER:
                            return t.preventDefault(), clearTimeout(this.activating), void this._activate(n === this.options.active ? !1 : n);
                        default:
                            return
                    }
                    t.preventDefault(), clearTimeout(this.activating), n = this._focusNextTab(n, o), t.ctrlKey || t.metaKey || (i.attr("aria-selected", "false"), this.tabs.eq(n).attr("aria-selected", "true"), this.activating = this._delay(function () {
                        this.option("active", n)
                    }, this.delay))
                }
            },
            _panelKeydown: function (t) {
                this._handlePageNav(t) || t.ctrlKey && t.keyCode === e.ui.keyCode.UP && (t.preventDefault(), this.active.focus())
            },
            _handlePageNav: function (t) {
                return t.altKey && t.keyCode === e.ui.keyCode.PAGE_UP ? (this._activate(this._focusNextTab(this.options.active - 1, !1)), !0) : t.altKey && t.keyCode === e.ui.keyCode.PAGE_DOWN ? (this._activate(this._focusNextTab(this.options.active + 1, !0)), !0) : void 0
            },
            _findNextTab: function (t, i) {
                function n() {
                    return t > o && (t = 0), 0 > t && (t = o), t
                }
                for (var o = this.tabs.length - 1; - 1 !== e.inArray(n(), this.options.disabled);) t = i ? t + 1 : t - 1;
                return t
            },
            _focusNextTab: function (e, t) {
                return e = this._findNextTab(e, t), this.tabs.eq(e).focus(), e
            },
            _setOption: function (e, t) {
                return "active" === e ? void this._activate(t) : "disabled" === e ? void this._setupDisabled(t) : (this._super(e, t), "collapsible" === e && (this.element.toggleClass("ui-tabs-collapsible", t), t || this.options.active !== !1 || this._activate(0)), "event" === e && this._setupEvents(t), void("heightStyle" === e && this._setupHeightStyle(t)))
            },
            _sanitizeSelector: function (e) {
                return e ? e.replace(/[!"$%&'()*+,.\/:;<=>?@\[\]\^`{|}~]/g, "\\$&") : ""
            },
            refresh: function () {
                var t = this.options,
                    i = this.tablist.children(":has(a[href])");
                t.disabled = e.map(i.filter(".ui-state-disabled"), function (e) {
                    return i.index(e)
                }), this._processTabs(), t.active !== !1 && this.anchors.length ? this.active.length && !e.contains(this.tablist[0], this.active[0]) ? this.tabs.length === t.disabled.length ? (t.active = !1, this.active = e()) : this._activate(this._findNextTab(Math.max(0, t.active - 1), !1)) : t.active = this.tabs.index(this.active) : (t.active = !1, this.active = e()), this._refresh()
            },
            _refresh: function () {
                this._setupDisabled(this.options.disabled), this._setupEvents(this.options.event), this._setupHeightStyle(this.options.heightStyle), this.tabs.not(this.active).attr({
                    "aria-selected": "false",
                    "aria-expanded": "false",
                    tabIndex: -1
                }), this.panels.not(this._getPanelForTab(this.active)).hide().attr({
                    "aria-hidden": "true"
                }), this.active.length ? (this.active.addClass("ui-tabs-active ui-state-active").attr({
                    "aria-selected": "true",
                    "aria-expanded": "true",
                    tabIndex: 0
                }), this._getPanelForTab(this.active).show().attr({
                    "aria-hidden": "false"
                })) : this.tabs.eq(0).attr("tabIndex", 0)
            },
            _processTabs: function () {
                var t = this,
                    i = this.tabs,
                    n = this.anchors,
                    o = this.panels;
                this.tablist = this._getList().addClass("ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all").attr("role", "tablist").delegate("> li", "mousedown" + this.eventNamespace, function (t) {
                    e(this).is(".ui-state-disabled") && t.preventDefault()
                }).delegate(".ui-tabs-anchor", "focus" + this.eventNamespace, function () {
                    e(this).closest("li").is(".ui-state-disabled") && this.blur()
                }), this.tabs = this.tablist.find("> li:has(a[href])").addClass("ui-state-default ui-corner-top").attr({
                    role: "tab",
                    tabIndex: -1
                }), this.anchors = this.tabs.map(function () {
                    return e("a", this)[0]
                }).addClass("ui-tabs-anchor").attr({
                    role: "presentation",
                    tabIndex: -1
                }), this.panels = e(), this.anchors.each(function (i, n) {
                    var o, s, r, a = e(n).uniqueId().attr("id"),
                        l = e(n).closest("li"),
                        c = l.attr("aria-controls");
                    t._isLocal(n) ? (o = n.hash, r = o.substring(1), s = t.element.find(t._sanitizeSelector(o))) : (r = l.attr("aria-controls") || e({}).uniqueId()[0].id, o = "#" + r, s = t.element.find(o), s.length || (s = t._createPanel(r), s.insertAfter(t.panels[i - 1] || t.tablist)), s.attr("aria-live", "polite")), s.length && (t.panels = t.panels.add(s)), c && l.data("ui-tabs-aria-controls", c), l.attr({
                        "aria-controls": r,
                        "aria-labelledby": a
                    }), s.attr("aria-labelledby", a)
                }), this.panels.addClass("ui-tabs-panel ui-widget-content ui-corner-bottom").attr("role", "tabpanel"), i && (this._off(i.not(this.tabs)), this._off(n.not(this.anchors)), this._off(o.not(this.panels)))
            },
            _getList: function () {
                return this.tablist || this.element.find("ol,ul").eq(0)
            },
            _createPanel: function (t) {
                return e("<div>").attr("id", t).addClass("ui-tabs-panel ui-widget-content ui-corner-bottom").data("ui-tabs-destroy", !0)
            },
            _setupDisabled: function (t) {
                e.isArray(t) && (t.length ? t.length === this.anchors.length && (t = !0) : t = !1);
                for (var i, n = 0; i = this.tabs[n]; n++) t === !0 || -1 !== e.inArray(n, t) ? e(i).addClass("ui-state-disabled").attr("aria-disabled", "true") : e(i).removeClass("ui-state-disabled").removeAttr("aria-disabled");
                this.options.disabled = t
            },
            _setupEvents: function (t) {
                var i = {};
                t && e.each(t.split(" "), function (e, t) {
                    i[t] = "_eventHandler"
                }), this._off(this.anchors.add(this.tabs).add(this.panels)), this._on(!0, this.anchors, {
                    click: function (e) {
                        e.preventDefault()
                    }
                }), this._on(this.anchors, i), this._on(this.tabs, {
                    keydown: "_tabKeydown"
                }), this._on(this.panels, {
                    keydown: "_panelKeydown"
                }), this._focusable(this.tabs), this._hoverable(this.tabs)
            },
            _setupHeightStyle: function (t) {
                var i, n = this.element.parent();
                "fill" === t ? (i = n.height(), i -= this.element.outerHeight() - this.element.height(), this.element.siblings(":visible").each(function () {
                    var t = e(this),
                        n = t.css("position");
                    "absolute" !== n && "fixed" !== n && (i -= t.outerHeight(!0))
                }), this.element.children().not(this.panels).each(function () {
                    i -= e(this).outerHeight(!0)
                }), this.panels.each(function () {
                    e(this).height(Math.max(0, i - e(this).innerHeight() + e(this).height()))
                }).css("overflow", "auto")) : "auto" === t && (i = 0, this.panels.each(function () {
                    i = Math.max(i, e(this).height("").height())
                }).height(i))
            },
            _eventHandler: function (t) {
                var i = this.options,
                    n = this.active,
                    o = e(t.currentTarget),
                    s = o.closest("li"),
                    r = s[0] === n[0],
                    a = r && i.collapsible,
                    l = a ? e() : this._getPanelForTab(s),
                    c = n.length ? this._getPanelForTab(n) : e(),
                    d = {
                        oldTab: n,
                        oldPanel: c,
                        newTab: a ? e() : s,
                        newPanel: l
                    };
                t.preventDefault(), s.hasClass("ui-state-disabled") || s.hasClass("ui-tabs-loading") || this.running || r && !i.collapsible || this._trigger("beforeActivate", t, d) === !1 || (i.active = a ? !1 : this.tabs.index(s), this.active = r ? e() : s, this.xhr && this.xhr.abort(), c.length || l.length || e.error("jQuery UI Tabs: Mismatching fragment identifier."), l.length && this.load(this.tabs.index(s), t), this._toggle(t, d))
            },
            _toggle: function (t, i) {
                function n() {
                    s.running = !1, s._trigger("activate", t, i)
                }

                function o() {
                    i.newTab.closest("li").addClass("ui-tabs-active ui-state-active"), r.length && s.options.show ? s._show(r, s.options.show, n) : (r.show(), n())
                }
                var s = this,
                    r = i.newPanel,
                    a = i.oldPanel;
                this.running = !0, a.length && this.options.hide ? this._hide(a, this.options.hide, function () {
                    i.oldTab.closest("li").removeClass("ui-tabs-active ui-state-active"), o()
                }) : (i.oldTab.closest("li").removeClass("ui-tabs-active ui-state-active"), a.hide(), o()), a.attr("aria-hidden", "true"), i.oldTab.attr({
                    "aria-selected": "false",
                    "aria-expanded": "false"
                }), r.length && a.length ? i.oldTab.attr("tabIndex", -1) : r.length && this.tabs.filter(function () {
                    return 0 === e(this).attr("tabIndex")
                }).attr("tabIndex", -1), r.attr("aria-hidden", "false"), i.newTab.attr({
                    "aria-selected": "true",
                    "aria-expanded": "true",
                    tabIndex: 0
                })
            },
            _activate: function (t) {
                var i, n = this._findActive(t);
                n[0] !== this.active[0] && (n.length || (n = this.active), i = n.find(".ui-tabs-anchor")[0], this._eventHandler({
                    target: i,
                    currentTarget: i,
                    preventDefault: e.noop
                }))
            },
            _findActive: function (t) {
                return t === !1 ? e() : this.tabs.eq(t)
            },
            _getIndex: function (e) {
                return "string" == typeof e && (e = this.anchors.index(this.anchors.filter("[href$='" + e + "']"))), e
            },
            _destroy: function () {
                this.xhr && this.xhr.abort(), this.element.removeClass("ui-tabs ui-widget ui-widget-content ui-corner-all ui-tabs-collapsible"), this.tablist.removeClass("ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all").removeAttr("role"), this.anchors.removeClass("ui-tabs-anchor").removeAttr("role").removeAttr("tabIndex").removeUniqueId(), this.tablist.unbind(this.eventNamespace), this.tabs.add(this.panels).each(function () {
                    e.data(this, "ui-tabs-destroy") ? e(this).remove() : e(this).removeClass("ui-state-default ui-state-active ui-state-disabled ui-corner-top ui-corner-bottom ui-widget-content ui-tabs-active ui-tabs-panel").removeAttr("tabIndex").removeAttr("aria-live").removeAttr("aria-busy").removeAttr("aria-selected").removeAttr("aria-labelledby").removeAttr("aria-hidden").removeAttr("aria-expanded").removeAttr("role")
                }), this.tabs.each(function () {
                    var t = e(this),
                        i = t.data("ui-tabs-aria-controls");
                    i ? t.attr("aria-controls", i).removeData("ui-tabs-aria-controls") : t.removeAttr("aria-controls")
                }), this.panels.show(), "content" !== this.options.heightStyle && this.panels.css("height", "")
            },
            enable: function (t) {
                var i = this.options.disabled;
                i !== !1 && (void 0 === t ? i = !1 : (t = this._getIndex(t), i = e.isArray(i) ? e.map(i, function (e) {
                    return e !== t ? e : null
                }) : e.map(this.tabs, function (e, i) {
                    return i !== t ? i : null
                })), this._setupDisabled(i))
            },
            disable: function (t) {
                var i = this.options.disabled;
                if (i !== !0) {
                    if (void 0 === t) i = !0;
                    else {
                        if (t = this._getIndex(t), -1 !== e.inArray(t, i)) return;
                        i = e.isArray(i) ? e.merge([t], i).sort() : [t]
                    }
                    this._setupDisabled(i)
                }
            },
            load: function (t, i) {
                t = this._getIndex(t);
                var n = this,
                    o = this.tabs.eq(t),
                    s = o.find(".ui-tabs-anchor"),
                    r = this._getPanelForTab(o),
                    a = {
                        tab: o,
                        panel: r
                    },
                    l = function (e, t) {
                        "abort" === t && n.panels.stop(!1, !0), o.removeClass("ui-tabs-loading"), r.removeAttr("aria-busy"), e === n.xhr && delete n.xhr
                    };
                this._isLocal(s[0]) || (this.xhr = e.ajax(this._ajaxSettings(s, i, a)), this.xhr && "canceled" !== this.xhr.statusText && (o.addClass("ui-tabs-loading"), r.attr("aria-busy", "true"), this.xhr.done(function (e, t, o) {
                    setTimeout(function () {
                        r.html(e), n._trigger("load", i, a), l(o, t)
                    }, 1)
                }).fail(function (e, t) {
                    setTimeout(function () {
                        l(e, t)
                    }, 1)
                })))
            },
            _ajaxSettings: function (t, i, n) {
                var o = this;
                return {
                    url: t.attr("href"),
                    beforeSend: function (t, s) {
                        return o._trigger("beforeLoad", i, e.extend({
                            jqXHR: t,
                            ajaxSettings: s
                        }, n))
                    }
                }
            },
            _getPanelForTab: function (t) {
                var i = e(t).attr("aria-controls");
                return this.element.find(this._sanitizeSelector("#" + i))
            }
        }), e.widget("ui.tooltip", {
            version: "1.11.4",
            options: {
                content: function () {
                    var t = e(this).attr("title") || "";
                    return e("<a>").text(t).html()
                },
                hide: !0,
                items: "[title]:not([disabled])",
                position: {
                    my: "left top+15",
                    at: "left bottom",
                    collision: "flipfit flip"
                },
                show: !0,
                tooltipClass: null,
                track: !1,
                close: null,
                open: null
            },
            _addDescribedBy: function (t, i) {
                var n = (t.attr("aria-describedby") || "").split(/\s+/);
                n.push(i), t.data("ui-tooltip-id", i).attr("aria-describedby", e.trim(n.join(" ")))
            },
            _removeDescribedBy: function (t) {
                var i = t.data("ui-tooltip-id"),
                    n = (t.attr("aria-describedby") || "").split(/\s+/),
                    o = e.inArray(i, n); - 1 !== o && n.splice(o, 1), t.removeData("ui-tooltip-id"), n = e.trim(n.join(" ")), n ? t.attr("aria-describedby", n) : t.removeAttr("aria-describedby")
            },
            _create: function () {
                this._on({
                    mouseover: "open",
                    focusin: "open"
                }), this.tooltips = {}, this.parents = {}, this.options.disabled && this._disable(), this.liveRegion = e("<div>").attr({
                    role: "log",
                    "aria-live": "assertive",
                    "aria-relevant": "additions"
                }).addClass("ui-helper-hidden-accessible").appendTo(this.document[0].body)
            },
            _setOption: function (t, i) {
                var n = this;
                return "disabled" === t ? (this[i ? "_disable" : "_enable"](), void(this.options[t] = i)) : (this._super(t, i), void("content" === t && e.each(this.tooltips, function (e, t) {
                    n._updateContent(t.element)
                })))
            },
            _disable: function () {
                var t = this;
                e.each(this.tooltips, function (i, n) {
                    var o = e.Event("blur");
                    o.target = o.currentTarget = n.element[0], t.close(o, !0)
                }), this.element.find(this.options.items).addBack().each(function () {
                    var t = e(this);
                    t.is("[title]") && t.data("ui-tooltip-title", t.attr("title")).removeAttr("title")
                })
            },
            _enable: function () {
                this.element.find(this.options.items).addBack().each(function () {
                    var t = e(this);
                    t.data("ui-tooltip-title") && t.attr("title", t.data("ui-tooltip-title"))
                })
            },
            open: function (t) {
                var i = this,
                    n = e(t ? t.target : this.element).closest(this.options.items);
                n.length && !n.data("ui-tooltip-id") && (n.attr("title") && n.data("ui-tooltip-title", n.attr("title")), n.data("ui-tooltip-open", !0), t && "mouseover" === t.type && n.parents().each(function () {
                    var t, n = e(this);
                    n.data("ui-tooltip-open") && (t = e.Event("blur"), t.target = t.currentTarget = this, i.close(t, !0)), n.attr("title") && (n.uniqueId(), i.parents[this.id] = {
                        element: this,
                        title: n.attr("title")
                    }, n.attr("title", ""))
                }), this._registerCloseHandlers(t, n), this._updateContent(n, t))
            },
            _updateContent: function (e, t) {
                var i, n = this.options.content,
                    o = this,
                    s = t ? t.type : null;
                return "string" == typeof n ? this._open(t, e, n) : (i = n.call(e[0], function (i) {
                    o._delay(function () {
                        e.data("ui-tooltip-open") && (t && (t.type = s), this._open(t, e, i))
                    })
                }), void(i && this._open(t, e, i)))
            },
            _open: function (t, i, n) {
                function o(e) {
                    c.of = e, r.is(":hidden") || r.position(c)
                }
                var s, r, a, l, c = e.extend({}, this.options.position);
                if (n) {
                    if (s = this._find(i)) return void s.tooltip.find(".ui-tooltip-content").html(n);
                    i.is("[title]") && (t && "mouseover" === t.type ? i.attr("title", "") : i.removeAttr("title")), s = this._tooltip(i), r = s.tooltip, this._addDescribedBy(i, r.attr("id")), r.find(".ui-tooltip-content").html(n), this.liveRegion.children().hide(), n.clone ? (l = n.clone(), l.removeAttr("id").find("[id]").removeAttr("id")) : l = n, e("<div>").html(l).appendTo(this.liveRegion), this.options.track && t && /^mouse/.test(t.type) ? (this._on(this.document, {
                        mousemove: o
                    }), o(t)) : r.position(e.extend({
                        of: i
                    }, this.options.position)), r.hide(), this._show(r, this.options.show), this.options.show && this.options.show.delay && (a = this.delayedShow = setInterval(function () {
                        r.is(":visible") && (o(c.of), clearInterval(a))
                    }, e.fx.interval)), this._trigger("open", t, {
                        tooltip: r
                    })
                }
            },
            _registerCloseHandlers: function (t, i) {
                var n = {
                    keyup: function (t) {
                        if (t.keyCode === e.ui.keyCode.ESCAPE) {
                            var n = e.Event(t);
                            n.currentTarget = i[0], this.close(n, !0)
                        }
                    }
                };
                i[0] !== this.element[0] && (n.remove = function () {
                    this._removeTooltip(this._find(i).tooltip)
                }), t && "mouseover" !== t.type || (n.mouseleave = "close"), t && "focusin" !== t.type || (n.focusout = "close"), this._on(!0, i, n)
            },
            close: function (t) {
                var i, n = this,
                    o = e(t ? t.currentTarget : this.element),
                    s = this._find(o);
                return s ? (i = s.tooltip, void(s.closing || (clearInterval(this.delayedShow), o.data("ui-tooltip-title") && !o.attr("title") && o.attr("title", o.data("ui-tooltip-title")), this._removeDescribedBy(o), s.hiding = !0, i.stop(!0), this._hide(i, this.options.hide, function () {
                    n._removeTooltip(e(this))
                }), o.removeData("ui-tooltip-open"), this._off(o, "mouseleave focusout keyup"), o[0] !== this.element[0] && this._off(o, "remove"), this._off(this.document, "mousemove"), t && "mouseleave" === t.type && e.each(this.parents, function (t, i) {
                    e(i.element).attr("title", i.title), delete n.parents[t]
                }), s.closing = !0, this._trigger("close", t, {
                    tooltip: i
                }), s.hiding || (s.closing = !1)))) : void o.removeData("ui-tooltip-open")
            },
            _tooltip: function (t) {
                var i = e("<div>").attr("role", "tooltip").addClass("ui-tooltip ui-widget ui-corner-all ui-widget-content " + (this.options.tooltipClass || "")),
                    n = i.uniqueId().attr("id");
                return e("<div>").addClass("ui-tooltip-content").appendTo(i), i.appendTo(this.document[0].body), this.tooltips[n] = {
                    element: t,
                    tooltip: i
                }
            },
            _find: function (e) {
                var t = e.data("ui-tooltip-id");
                return t ? this.tooltips[t] : null
            },
            _removeTooltip: function (e) {
                e.remove(), delete this.tooltips[e.attr("id")]
            },
            _destroy: function () {
                var t = this;
                e.each(this.tooltips, function (i, n) {
                    var o = e.Event("blur"),
                        s = n.element;
                    o.target = o.currentTarget = s[0], t.close(o, !0), e("#" + i).remove(), s.data("ui-tooltip-title") && (s.attr("title") || s.attr("title", s.data("ui-tooltip-title")), s.removeData("ui-tooltip-title"))
                }), this.liveRegion.remove()
            }
        }), "ui-effects-"),
        p = e;
    e.effects = {
            effect: {}
        },
        function (e, t) {
            function i(e, t, i) {
                var n = u[t.type] || {};
                return null == e ? i || !t.def ? null : t.def : (e = n.floor ? ~~e : parseFloat(e), isNaN(e) ? t.def : n.mod ? (e + n.mod) % n.mod : 0 > e ? 0 : n.max < e ? n.max : e)
            }

            function n(t) {
                var i = c(),
                    n = i._rgba = [];
                return t = t.toLowerCase(), f(l, function (e, o) {
                    var s, r = o.re.exec(t),
                        a = r && o.parse(r),
                        l = o.space || "rgba";
                    return a ? (s = i[l](a), i[d[l].cache] = s[d[l].cache], n = i._rgba = s._rgba, !1) : void 0
                }), n.length ? ("0,0,0,0" === n.join() && e.extend(n, s.transparent), i) : s[t]
            }

            function o(e, t, i) {
                return i = (i + 1) % 1, 1 > 6 * i ? e + (t - e) * i * 6 : 1 > 2 * i ? t : 2 > 3 * i ? e + (t - e) * (2 / 3 - i) * 6 : e
            }
            var s, r = "backgroundColor borderBottomColor borderLeftColor borderRightColor borderTopColor color columnRuleColor outlineColor textDecorationColor textEmphasisColor",
                a = /^([\-+])=\s*(\d+\.?\d*)/,
                l = [{
                    re: /rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,
                    parse: function (e) {
                        return [e[1], e[2], e[3], e[4]]
                    }
                }, {
                    re: /rgba?\(\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,
                    parse: function (e) {
                        return [2.55 * e[1], 2.55 * e[2], 2.55 * e[3], e[4]]
                    }
                }, {
                    re: /#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/,
                    parse: function (e) {
                        return [parseInt(e[1], 16), parseInt(e[2], 16), parseInt(e[3], 16)]
                    }
                }, {
                    re: /#([a-f0-9])([a-f0-9])([a-f0-9])/,
                    parse: function (e) {
                        return [parseInt(e[1] + e[1], 16), parseInt(e[2] + e[2], 16), parseInt(e[3] + e[3], 16)]
                    }
                }, {
                    re: /hsla?\(\s*(\d+(?:\.\d+)?)\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,
                    space: "hsla",
                    parse: function (e) {
                        return [e[1], e[2] / 100, e[3] / 100, e[4]]
                    }
                }],
                c = e.Color = function (t, i, n, o) {
                    return new e.Color.fn.parse(t, i, n, o)
                },
                d = {
                    rgba: {
                        props: {
                            red: {
                                idx: 0,
                                type: "byte"
                            },
                            green: {
                                idx: 1,
                                type: "byte"
                            },
                            blue: {
                                idx: 2,
                                type: "byte"
                            }
                        }
                    },
                    hsla: {
                        props: {
                            hue: {
                                idx: 0,
                                type: "degrees"
                            },
                            saturation: {
                                idx: 1,
                                type: "percent"
                            },
                            lightness: {
                                idx: 2,
                                type: "percent"
                            }
                        }
                    }
                },
                u = {
                    "byte": {
                        floor: !0,
                        max: 255
                    },
                    percent: {
                        max: 1
                    },
                    degrees: {
                        mod: 360,
                        floor: !0
                    }
                },
                h = c.support = {},
                p = e("<p>")[0],
                f = e.each;
            p.style.cssText = "background-color:rgba(1,1,1,.5)", h.rgba = p.style.backgroundColor.indexOf("rgba") > -1, f(d, function (e, t) {
                t.cache = "_" + e, t.props.alpha = {
                    idx: 3,
                    type: "percent",
                    def: 1
                }
            }), c.fn = e.extend(c.prototype, {
                parse: function (o, r, a, l) {
                    if (o === t) return this._rgba = [null, null, null, null], this;
                    (o.jquery || o.nodeType) && (o = e(o).css(r), r = t);
                    var u = this,
                        h = e.type(o),
                        p = this._rgba = [];
                    return r !== t && (o = [o, r, a, l], h = "array"), "string" === h ? this.parse(n(o) || s._default) : "array" === h ? (f(d.rgba.props, function (e, t) {
                        p[t.idx] = i(o[t.idx], t)
                    }), this) : "object" === h ? (o instanceof c ? f(d, function (e, t) {
                        o[t.cache] && (u[t.cache] = o[t.cache].slice())
                    }) : f(d, function (t, n) {
                        var s = n.cache;
                        f(n.props, function (e, t) {
                            if (!u[s] && n.to) {
                                if ("alpha" === e || null == o[e]) return;
                                u[s] = n.to(u._rgba)
                            }
                            u[s][t.idx] = i(o[e], t, !0)
                        }), u[s] && e.inArray(null, u[s].slice(0, 3)) < 0 && (u[s][3] = 1, n.from && (u._rgba = n.from(u[s])))
                    }), this) : void 0
                },
                is: function (e) {
                    var t = c(e),
                        i = !0,
                        n = this;
                    return f(d, function (e, o) {
                        var s, r = t[o.cache];
                        return r && (s = n[o.cache] || o.to && o.to(n._rgba) || [], f(o.props, function (e, t) {
                            return null != r[t.idx] ? i = r[t.idx] === s[t.idx] : void 0
                        })), i
                    }), i
                },
                _space: function () {
                    var e = [],
                        t = this;
                    return f(d, function (i, n) {
                        t[n.cache] && e.push(i)
                    }), e.pop()
                },
                transition: function (e, t) {
                    var n = c(e),
                        o = n._space(),
                        s = d[o],
                        r = 0 === this.alpha() ? c("transparent") : this,
                        a = r[s.cache] || s.to(r._rgba),
                        l = a.slice();
                    return n = n[s.cache], f(s.props, function (e, o) {
                        var s = o.idx,
                            r = a[s],
                            c = n[s],
                            d = u[o.type] || {};
                        null !== c && (null === r ? l[s] = c : (d.mod && (c - r > d.mod / 2 ? r += d.mod : r - c > d.mod / 2 && (r -= d.mod)), l[s] = i((c - r) * t + r, o)))
                    }), this[o](l)
                },
                blend: function (t) {
                    if (1 === this._rgba[3]) return this;
                    var i = this._rgba.slice(),
                        n = i.pop(),
                        o = c(t)._rgba;
                    return c(e.map(i, function (e, t) {
                        return (1 - n) * o[t] + n * e
                    }))
                },
                toRgbaString: function () {
                    var t = "rgba(",
                        i = e.map(this._rgba, function (e, t) {
                            return null == e ? t > 2 ? 1 : 0 : e
                        });
                    return 1 === i[3] && (i.pop(), t = "rgb("), t + i.join() + ")"
                },
                toHslaString: function () {
                    var t = "hsla(",
                        i = e.map(this.hsla(), function (e, t) {
                            return null == e && (e = t > 2 ? 1 : 0), t && 3 > t && (e = Math.round(100 * e) + "%"), e
                        });
                    return 1 === i[3] && (i.pop(), t = "hsl("), t + i.join() + ")"
                },
                toHexString: function (t) {
                    var i = this._rgba.slice(),
                        n = i.pop();
                    return t && i.push(~~(255 * n)), "#" + e.map(i, function (e) {
                        return e = (e || 0).toString(16), 1 === e.length ? "0" + e : e
                    }).join("")
                },
                toString: function () {
                    return 0 === this._rgba[3] ? "transparent" : this.toRgbaString()
                }
            }), c.fn.parse.prototype = c.fn, d.hsla.to = function (e) {
                if (null == e[0] || null == e[1] || null == e[2]) return [null, null, null, e[3]];
                var t, i, n = e[0] / 255,
                    o = e[1] / 255,
                    s = e[2] / 255,
                    r = e[3],
                    a = Math.max(n, o, s),
                    l = Math.min(n, o, s),
                    c = a - l,
                    d = a + l,
                    u = .5 * d;
                return t = l === a ? 0 : n === a ? 60 * (o - s) / c + 360 : o === a ? 60 * (s - n) / c + 120 : 60 * (n - o) / c + 240, i = 0 === c ? 0 : .5 >= u ? c / d : c / (2 - d), [Math.round(t) % 360, i, u, null == r ? 1 : r]
            }, d.hsla.from = function (e) {
                if (null == e[0] || null == e[1] || null == e[2]) return [null, null, null, e[3]];
                var t = e[0] / 360,
                    i = e[1],
                    n = e[2],
                    s = e[3],
                    r = .5 >= n ? n * (1 + i) : n + i - n * i,
                    a = 2 * n - r;
                return [Math.round(255 * o(a, r, t + 1 / 3)), Math.round(255 * o(a, r, t)), Math.round(255 * o(a, r, t - 1 / 3)), s]
            }, f(d, function (n, o) {
                var s = o.props,
                    r = o.cache,
                    l = o.to,
                    d = o.from;
                c.fn[n] = function (n) {
                    if (l && !this[r] && (this[r] = l(this._rgba)), n === t) return this[r].slice();
                    var o, a = e.type(n),
                        u = "array" === a || "object" === a ? n : arguments,
                        h = this[r].slice();
                    return f(s, function (e, t) {
                        var n = u["object" === a ? e : t.idx];
                        null == n && (n = h[t.idx]), h[t.idx] = i(n, t)
                    }), d ? (o = c(d(h)), o[r] = h, o) : c(h)
                }, f(s, function (t, i) {
                    c.fn[t] || (c.fn[t] = function (o) {
                        var s, r = e.type(o),
                            l = "alpha" === t ? this._hsla ? "hsla" : "rgba" : n,
                            c = this[l](),
                            d = c[i.idx];
                        return "undefined" === r ? d : ("function" === r && (o = o.call(this, d), r = e.type(o)), null == o && i.empty ? this : ("string" === r && (s = a.exec(o), s && (o = d + parseFloat(s[2]) * ("+" === s[1] ? 1 : -1))), c[i.idx] = o, this[l](c)))
                    })
                })
            }), c.hook = function (t) {
                var i = t.split(" ");
                f(i, function (t, i) {
                    e.cssHooks[i] = {
                        set: function (t, o) {
                            var s, r, a = "";
                            if ("transparent" !== o && ("string" !== e.type(o) || (s = n(o)))) {
                                if (o = c(s || o), !h.rgba && 1 !== o._rgba[3]) {
                                    for (r = "backgroundColor" === i ? t.parentNode : t;
                                        ("" === a || "transparent" === a) && r && r.style;) try {
                                        a = e.css(r, "backgroundColor"), r = r.parentNode
                                    } catch (l) {}
                                    o = o.blend(a && "transparent" !== a ? a : "_default")
                                }
                                o = o.toRgbaString()
                            }
                            try {
                                t.style[i] = o
                            } catch (l) {}
                        }
                    }, e.fx.step[i] = function (t) {
                        t.colorInit || (t.start = c(t.elem, i), t.end = c(t.end), t.colorInit = !0), e.cssHooks[i].set(t.elem, t.start.transition(t.end, t.pos))
                    }
                })
            }, c.hook(r), e.cssHooks.borderColor = {
                expand: function (e) {
                    var t = {};
                    return f(["Top", "Right", "Bottom", "Left"], function (i, n) {
                        t["border" + n + "Color"] = e
                    }), t
                }
            }, s = e.Color.names = {
                aqua: "#00ffff",
                black: "#000000",
                blue: "#0000ff",
                fuchsia: "#ff00ff",
                gray: "#808080",
                green: "#008000",
                lime: "#00ff00",
                maroon: "#800000",
                navy: "#000080",
                olive: "#808000",
                purple: "#800080",
                red: "#ff0000",
                silver: "#c0c0c0",
                teal: "#008080",
                white: "#ffffff",
                yellow: "#ffff00",
                transparent: [null, null, null, 0],
                _default: "#ffffff"
            }
        }(p),
        function () {
            function t(t) {
                var i, n, o = t.ownerDocument.defaultView ? t.ownerDocument.defaultView.getComputedStyle(t, null) : t.currentStyle,
                    s = {};
                if (o && o.length && o[0] && o[o[0]])
                    for (n = o.length; n--;) i = o[n], "string" == typeof o[i] && (s[e.camelCase(i)] = o[i]);
                else
                    for (i in o) "string" == typeof o[i] && (s[i] = o[i]);
                return s
            }

            function i(t, i) {
                var n, s, r = {};
                for (n in i) s = i[n], t[n] !== s && (o[n] || (e.fx.step[n] || !isNaN(parseFloat(s))) && (r[n] = s));
                return r
            }
            var n = ["add", "remove", "toggle"],
                o = {
                    border: 1,
                    borderBottom: 1,
                    borderColor: 1,
                    borderLeft: 1,
                    borderRight: 1,
                    borderTop: 1,
                    borderWidth: 1,
                    margin: 1,
                    padding: 1
                };
            e.each(["borderLeftStyle", "borderRightStyle", "borderBottomStyle", "borderTopStyle"], function (t, i) {
                e.fx.step[i] = function (e) {
                    ("none" !== e.end && !e.setAttr || 1 === e.pos && !e.setAttr) && (p.style(e.elem, i, e.end), e.setAttr = !0)
                }
            }), e.fn.addBack || (e.fn.addBack = function (e) {
                return this.add(null == e ? this.prevObject : this.prevObject.filter(e))
            }), e.effects.animateClass = function (o, s, r, a) {
                var l = e.speed(s, r, a);
                return this.queue(function () {
                    var s, r = e(this),
                        a = r.attr("class") || "",
                        c = l.children ? r.find("*").addBack() : r;
                    c = c.map(function () {
                        var i = e(this);
                        return {
                            el: i,
                            start: t(this)
                        }
                    }), s = function () {
                        e.each(n, function (e, t) {
                            o[t] && r[t + "Class"](o[t])
                        })
                    }, s(), c = c.map(function () {
                        return this.end = t(this.el[0]), this.diff = i(this.start, this.end), this
                    }), r.attr("class", a), c = c.map(function () {
                        var t = this,
                            i = e.Deferred(),
                            n = e.extend({}, l, {
                                queue: !1,
                                complete: function () {
                                    i.resolve(t)
                                }
                            });
                        return this.el.animate(this.diff, n), i.promise()
                    }), e.when.apply(e, c.get()).done(function () {
                        s(), e.each(arguments, function () {
                            var t = this.el;
                            e.each(this.diff, function (e) {
                                t.css(e, "")
                            })
                        }), l.complete.call(r[0])
                    })
                })
            }, e.fn.extend({
                addClass: function (t) {
                    return function (i, n, o, s) {
                        return n ? e.effects.animateClass.call(this, {
                            add: i
                        }, n, o, s) : t.apply(this, arguments)
                    }
                }(e.fn.addClass),
                removeClass: function (t) {
                    return function (i, n, o, s) {
                        return arguments.length > 1 ? e.effects.animateClass.call(this, {
                            remove: i
                        }, n, o, s) : t.apply(this, arguments)
                    }
                }(e.fn.removeClass),
                toggleClass: function (t) {
                    return function (i, n, o, s, r) {
                        return "boolean" == typeof n || void 0 === n ? o ? e.effects.animateClass.call(this, n ? {
                            add: i
                        } : {
                            remove: i
                        }, o, s, r) : t.apply(this, arguments) : e.effects.animateClass.call(this, {
                            toggle: i
                        }, n, o, s)
                    }
                }(e.fn.toggleClass),
                switchClass: function (t, i, n, o, s) {
                    return e.effects.animateClass.call(this, {
                        add: i,
                        remove: t
                    }, n, o, s)
                }
            })
        }(),
        function () {
            function t(t, i, n, o) {
                return e.isPlainObject(t) && (i = t, t = t.effect), t = {
                    effect: t
                }, null == i && (i = {}), e.isFunction(i) && (o = i, n = null, i = {}), ("number" == typeof i || e.fx.speeds[i]) && (o = n, n = i, i = {}), e.isFunction(n) && (o = n, n = null), i && e.extend(t, i), n = n || i.duration, t.duration = e.fx.off ? 0 : "number" == typeof n ? n : n in e.fx.speeds ? e.fx.speeds[n] : e.fx.speeds._default, t.complete = o || i.complete, t
            }

            function i(t) {
                return !t || "number" == typeof t || e.fx.speeds[t] ? !0 : "string" != typeof t || e.effects.effect[t] ? e.isFunction(t) ? !0 : "object" != typeof t || t.effect ? !1 : !0 : !0
            }
            e.extend(e.effects, {
                version: "1.11.4",
                save: function (e, t) {
                    for (var i = 0; i < t.length; i++) null !== t[i] && e.data(h + t[i], e[0].style[t[i]])
                },
                restore: function (e, t) {
                    var i, n;
                    for (n = 0; n < t.length; n++) null !== t[n] && (i = e.data(h + t[n]), void 0 === i && (i = ""), e.css(t[n], i))
                },
                setMode: function (e, t) {
                    return "toggle" === t && (t = e.is(":hidden") ? "show" : "hide"), t
                },
                getBaseline: function (e, t) {
                    var i, n;
                    switch (e[0]) {
                        case "top":
                            i = 0;
                            break;
                        case "middle":
                            i = .5;
                            break;
                        case "bottom":
                            i = 1;
                            break;
                        default:
                            i = e[0] / t.height
                    }
                    switch (e[1]) {
                        case "left":
                            n = 0;
                            break;
                        case "center":
                            n = .5;
                            break;
                        case "right":
                            n = 1;
                            break;
                        default:
                            n = e[1] / t.width
                    }
                    return {
                        x: n,
                        y: i
                    }
                },
                createWrapper: function (t) {
                    if (t.parent().is(".ui-effects-wrapper")) return t.parent();
                    var i = {
                            width: t.outerWidth(!0),
                            height: t.outerHeight(!0),
                            "float": t.css("float")
                        },
                        n = e("<div></div>").addClass("ui-effects-wrapper").css({
                            fontSize: "100%",
                            background: "transparent",
                            border: "none",
                            margin: 0,
                            padding: 0
                        }),
                        o = {
                            width: t.width(),
                            height: t.height()
                        },
                        s = document.activeElement;
                    try {
                        s.id
                    } catch (r) {
                        s = document.body
                    }
                    return t.wrap(n), (t[0] === s || e.contains(t[0], s)) && e(s).focus(), n = t.parent(), "static" === t.css("position") ? (n.css({
                        position: "relative"
                    }), t.css({
                        position: "relative"
                    })) : (e.extend(i, {
                        position: t.css("position"),
                        zIndex: t.css("z-index")
                    }), e.each(["top", "left", "bottom", "right"], function (e, n) {
                        i[n] = t.css(n), isNaN(parseInt(i[n], 10)) && (i[n] = "auto")
                    }), t.css({
                        position: "relative",
                        top: 0,
                        left: 0,
                        right: "auto",
                        bottom: "auto"
                    })), t.css(o), n.css(i).show()
                },
                removeWrapper: function (t) {
                    var i = document.activeElement;
                    return t.parent().is(".ui-effects-wrapper") && (t.parent().replaceWith(t), (t[0] === i || e.contains(t[0], i)) && e(i).focus()), t
                },
                setTransition: function (t, i, n, o) {
                    return o = o || {}, e.each(i, function (e, i) {
                        var s = t.cssUnit(i);
                        s[0] > 0 && (o[i] = s[0] * n + s[1])
                    }), o
                }
            }), e.fn.extend({
                effect: function () {
                    function i(t) {
                        function i() {
                            e.isFunction(s) && s.call(o[0]), e.isFunction(t) && t()
                        }
                        var o = e(this),
                            s = n.complete,
                            a = n.mode;
                        (o.is(":hidden") ? "hide" === a : "show" === a) ? (o[a](), i()) : r.call(o[0], n, i)
                    }
                    var n = t.apply(this, arguments),
                        o = n.mode,
                        s = n.queue,
                        r = e.effects.effect[n.effect];
                    return e.fx.off || !r ? o ? this[o](n.duration, n.complete) : this.each(function () {
                        n.complete && n.complete.call(this)
                    }) : s === !1 ? this.each(i) : this.queue(s || "fx", i)
                },
                show: function (e) {
                    return function (n) {
                        if (i(n)) return e.apply(this, arguments);
                        var o = t.apply(this, arguments);
                        return o.mode = "show", this.effect.call(this, o)
                    }
                }(e.fn.show),
                hide: function (e) {
                    return function (n) {
                        if (i(n)) return e.apply(this, arguments);
                        var o = t.apply(this, arguments);
                        return o.mode = "hide", this.effect.call(this, o)
                    }
                }(e.fn.hide),
                toggle: function (e) {
                    return function (n) {
                        if (i(n) || "boolean" == typeof n) return e.apply(this, arguments);
                        var o = t.apply(this, arguments);
                        return o.mode = "toggle", this.effect.call(this, o)
                    }
                }(e.fn.toggle),
                cssUnit: function (t) {
                    var i = this.css(t),
                        n = [];
                    return e.each(["em", "px", "%", "pt"], function (e, t) {
                        i.indexOf(t) > 0 && (n = [parseFloat(i), t])
                    }), n
                }
            })
        }(),
        function () {
            var t = {};
            e.each(["Quad", "Cubic", "Quart", "Quint", "Expo"], function (e, i) {
                t[i] = function (t) {
                    return Math.pow(t, e + 2)
                }
            }), e.extend(t, {
                Sine: function (e) {
                    return 1 - Math.cos(e * Math.PI / 2)
                },
                Circ: function (e) {
                    return 1 - Math.sqrt(1 - e * e)
                },
                Elastic: function (e) {
                    return 0 === e || 1 === e ? e : -Math.pow(2, 8 * (e - 1)) * Math.sin((80 * (e - 1) - 7.5) * Math.PI / 15)
                },
                Back: function (e) {
                    return e * e * (3 * e - 2)
                },
                Bounce: function (e) {
                    for (var t, i = 4; e < ((t = Math.pow(2, --i)) - 1) / 11;);
                    return 1 / Math.pow(4, 3 - i) - 7.5625 * Math.pow((3 * t - 2) / 22 - e, 2)
                }
            }), e.each(t, function (t, i) {
                e.easing["easeIn" + t] = i, e.easing["easeOut" + t] = function (e) {
                    return 1 - i(1 - e)
                }, e.easing["easeInOut" + t] = function (e) {
                    return .5 > e ? i(2 * e) / 2 : 1 - i(-2 * e + 2) / 2
                }
            })
        }();
    e.effects, e.effects.effect.blind = function (t, i) {
        var n, o, s, r = e(this),
            a = /up|down|vertical/,
            l = /up|left|vertical|horizontal/,
            c = ["position", "top", "bottom", "left", "right", "height", "width"],
            d = e.effects.setMode(r, t.mode || "hide"),
            u = t.direction || "up",
            h = a.test(u),
            p = h ? "height" : "width",
            f = h ? "top" : "left",
            g = l.test(u),
            m = {},
            v = "show" === d;
        r.parent().is(".ui-effects-wrapper") ? e.effects.save(r.parent(), c) : e.effects.save(r, c), r.show(), n = e.effects.createWrapper(r).css({
            overflow: "hidden"
        }), o = n[p](), s = parseFloat(n.css(f)) || 0, m[p] = v ? o : 0, g || (r.css(h ? "bottom" : "right", 0).css(h ? "top" : "left", "auto").css({
            position: "absolute"
        }), m[f] = v ? s : o + s), v && (n.css(p, 0), g || n.css(f, s + o)), n.animate(m, {
            duration: t.duration,
            easing: t.easing,
            queue: !1,
            complete: function () {
                "hide" === d && r.hide(), e.effects.restore(r, c), e.effects.removeWrapper(r), i()
            }
        })
    }, e.effects.effect.bounce = function (t, i) {
        var n, o, s, r = e(this),
            a = ["position", "top", "bottom", "left", "right", "height", "width"],
            l = e.effects.setMode(r, t.mode || "effect"),
            c = "hide" === l,
            d = "show" === l,
            u = t.direction || "up",
            h = t.distance,
            p = t.times || 5,
            f = 2 * p + (d || c ? 1 : 0),
            g = t.duration / f,
            m = t.easing,
            v = "up" === u || "down" === u ? "top" : "left",
            y = "up" === u || "left" === u,
            b = r.queue(),
            w = b.length;
        for ((d || c) && a.push("opacity"), e.effects.save(r, a), r.show(), e.effects.createWrapper(r), h || (h = r["top" === v ? "outerHeight" : "outerWidth"]() / 3), d && (s = {
                opacity: 1
            }, s[v] = 0, r.css("opacity", 0).css(v, y ? 2 * -h : 2 * h).animate(s, g, m)), c && (h /= Math.pow(2, p - 1)), s = {}, s[v] = 0, n = 0; p > n; n++) o = {}, o[v] = (y ? "-=" : "+=") + h, r.animate(o, g, m).animate(s, g, m), h = c ? 2 * h : h / 2;
        c && (o = {
            opacity: 0
        }, o[v] = (y ? "-=" : "+=") + h, r.animate(o, g, m)), r.queue(function () {
            c && r.hide(), e.effects.restore(r, a), e.effects.removeWrapper(r), i()
        }), w > 1 && b.splice.apply(b, [1, 0].concat(b.splice(w, f + 1))), r.dequeue()
    }, e.effects.effect.clip = function (t, i) {
        var n, o, s, r = e(this),
            a = ["position", "top", "bottom", "left", "right", "height", "width"],
            l = e.effects.setMode(r, t.mode || "hide"),
            c = "show" === l,
            d = t.direction || "vertical",
            u = "vertical" === d,
            h = u ? "height" : "width",
            p = u ? "top" : "left",
            f = {};
        e.effects.save(r, a), r.show(), n = e.effects.createWrapper(r).css({
            overflow: "hidden"
        }), o = "IMG" === r[0].tagName ? n : r, s = o[h](), c && (o.css(h, 0), o.css(p, s / 2)), f[h] = c ? s : 0, f[p] = c ? 0 : s / 2, o.animate(f, {
            queue: !1,
            duration: t.duration,
            easing: t.easing,
            complete: function () {
                c || r.hide(), e.effects.restore(r, a), e.effects.removeWrapper(r), i()
            }
        })
    }, e.effects.effect.drop = function (t, i) {
        var n, o = e(this),
            s = ["position", "top", "bottom", "left", "right", "opacity", "height", "width"],
            r = e.effects.setMode(o, t.mode || "hide"),
            a = "show" === r,
            l = t.direction || "left",
            c = "up" === l || "down" === l ? "top" : "left",
            d = "up" === l || "left" === l ? "pos" : "neg",
            u = {
                opacity: a ? 1 : 0
            };
        e.effects.save(o, s), o.show(), e.effects.createWrapper(o), n = t.distance || o["top" === c ? "outerHeight" : "outerWidth"](!0) / 2, a && o.css("opacity", 0).css(c, "pos" === d ? -n : n), u[c] = (a ? "pos" === d ? "+=" : "-=" : "pos" === d ? "-=" : "+=") + n, o.animate(u, {
            queue: !1,
            duration: t.duration,
            easing: t.easing,
            complete: function () {
                "hide" === r && o.hide(), e.effects.restore(o, s), e.effects.removeWrapper(o), i()
            }
        })
    }, e.effects.effect.explode = function (t, i) {
        function n() {
            b.push(this), b.length === u * h && o()
        }

        function o() {
            p.css({
                visibility: "visible"
            }), e(b).remove(), g || p.hide(), i()
        }
        var s, r, a, l, c, d, u = t.pieces ? Math.round(Math.sqrt(t.pieces)) : 3,
            h = u,
            p = e(this),
            f = e.effects.setMode(p, t.mode || "hide"),
            g = "show" === f,
            m = p.show().css("visibility", "hidden").offset(),
            v = Math.ceil(p.outerWidth() / h),
            y = Math.ceil(p.outerHeight() / u),
            b = [];
        for (s = 0; u > s; s++)
            for (l = m.top + s * y, d = s - (u - 1) / 2, r = 0; h > r; r++) a = m.left + r * v, c = r - (h - 1) / 2, p.clone().appendTo("body").wrap("<div></div>").css({
                position: "absolute",
                visibility: "visible",
                left: -r * v,
                top: -s * y
            }).parent().addClass("ui-effects-explode").css({
                position: "absolute",
                overflow: "hidden",
                width: v,
                height: y,
                left: a + (g ? c * v : 0),
                top: l + (g ? d * y : 0),
                opacity: g ? 0 : 1
            }).animate({
                left: a + (g ? 0 : c * v),
                top: l + (g ? 0 : d * y),
                opacity: g ? 1 : 0
            }, t.duration || 500, t.easing, n)
    }, e.effects.effect.fade = function (t, i) {
        var n = e(this),
            o = e.effects.setMode(n, t.mode || "toggle");
        n.animate({
            opacity: o
        }, {
            queue: !1,
            duration: t.duration,
            easing: t.easing,
            complete: i
        })
    }, e.effects.effect.fold = function (t, i) {
        var n, o, s = e(this),
            r = ["position", "top", "bottom", "left", "right", "height", "width"],
            a = e.effects.setMode(s, t.mode || "hide"),
            l = "show" === a,
            c = "hide" === a,
            d = t.size || 15,
            u = /([0-9]+)%/.exec(d),
            h = !!t.horizFirst,
            p = l !== h,
            f = p ? ["width", "height"] : ["height", "width"],
            g = t.duration / 2,
            m = {},
            v = {};
        e.effects.save(s, r), s.show(), n = e.effects.createWrapper(s).css({
            overflow: "hidden"
        }), o = p ? [n.width(), n.height()] : [n.height(), n.width()], u && (d = parseInt(u[1], 10) / 100 * o[c ? 0 : 1]), l && n.css(h ? {
            height: 0,
            width: d
        } : {
            height: d,
            width: 0
        }), m[f[0]] = l ? o[0] : d, v[f[1]] = l ? o[1] : 0, n.animate(m, g, t.easing).animate(v, g, t.easing, function () {
            c && s.hide(), e.effects.restore(s, r), e.effects.removeWrapper(s), i()
        })
    }, e.effects.effect.highlight = function (t, i) {
        var n = e(this),
            o = ["backgroundImage", "backgroundColor", "opacity"],
            s = e.effects.setMode(n, t.mode || "show"),
            r = {
                backgroundColor: n.css("backgroundColor")
            };
        "hide" === s && (r.opacity = 0), e.effects.save(n, o), n.show().css({
            backgroundImage: "none",
            backgroundColor: t.color || "#ffff99"
        }).animate(r, {
            queue: !1,
            duration: t.duration,
            easing: t.easing,
            complete: function () {
                "hide" === s && n.hide(), e.effects.restore(n, o), i()
            }
        })
    }, e.effects.effect.size = function (t, i) {
        var n, o, s, r = e(this),
            a = ["position", "top", "bottom", "left", "right", "width", "height", "overflow", "opacity"],
            l = ["position", "top", "bottom", "left", "right", "overflow", "opacity"],
            c = ["width", "height", "overflow"],
            d = ["fontSize"],
            u = ["borderTopWidth", "borderBottomWidth", "paddingTop", "paddingBottom"],
            h = ["borderLeftWidth", "borderRightWidth", "paddingLeft", "paddingRight"],
            p = e.effects.setMode(r, t.mode || "effect"),
            f = t.restore || "effect" !== p,
            g = t.scale || "both",
            m = t.origin || ["middle", "center"],
            v = r.css("position"),
            y = f ? a : l,
            b = {
                height: 0,
                width: 0,
                outerHeight: 0,
                outerWidth: 0
            };
        "show" === p && r.show(), n = {
            height: r.height(),
            width: r.width(),
            outerHeight: r.outerHeight(),
            outerWidth: r.outerWidth()
        }, "toggle" === t.mode && "show" === p ? (r.from = t.to || b, r.to = t.from || n) : (r.from = t.from || ("show" === p ? b : n), r.to = t.to || ("hide" === p ? b : n)), s = {
            from: {
                y: r.from.height / n.height,
                x: r.from.width / n.width
            },
            to: {
                y: r.to.height / n.height,
                x: r.to.width / n.width
            }
        }, ("box" === g || "both" === g) && (s.from.y !== s.to.y && (y = y.concat(u), r.from = e.effects.setTransition(r, u, s.from.y, r.from), r.to = e.effects.setTransition(r, u, s.to.y, r.to)), s.from.x !== s.to.x && (y = y.concat(h), r.from = e.effects.setTransition(r, h, s.from.x, r.from), r.to = e.effects.setTransition(r, h, s.to.x, r.to))), ("content" === g || "both" === g) && s.from.y !== s.to.y && (y = y.concat(d).concat(c), r.from = e.effects.setTransition(r, d, s.from.y, r.from), r.to = e.effects.setTransition(r, d, s.to.y, r.to)), e.effects.save(r, y), r.show(), e.effects.createWrapper(r), r.css("overflow", "hidden").css(r.from), m && (o = e.effects.getBaseline(m, n), r.from.top = (n.outerHeight - r.outerHeight()) * o.y, r.from.left = (n.outerWidth - r.outerWidth()) * o.x, r.to.top = (n.outerHeight - r.to.outerHeight) * o.y, r.to.left = (n.outerWidth - r.to.outerWidth) * o.x), r.css(r.from), ("content" === g || "both" === g) && (u = u.concat(["marginTop", "marginBottom"]).concat(d), h = h.concat(["marginLeft", "marginRight"]), c = a.concat(u).concat(h), r.find("*[width]").each(function () {
            var i = e(this),
                n = {
                    height: i.height(),
                    width: i.width(),
                    outerHeight: i.outerHeight(),
                    outerWidth: i.outerWidth()
                };
            f && e.effects.save(i, c), i.from = {
                height: n.height * s.from.y,
                width: n.width * s.from.x,
                outerHeight: n.outerHeight * s.from.y,
                outerWidth: n.outerWidth * s.from.x
            }, i.to = {
                height: n.height * s.to.y,
                width: n.width * s.to.x,
                outerHeight: n.height * s.to.y,
                outerWidth: n.width * s.to.x
            }, s.from.y !== s.to.y && (i.from = e.effects.setTransition(i, u, s.from.y, i.from), i.to = e.effects.setTransition(i, u, s.to.y, i.to)), s.from.x !== s.to.x && (i.from = e.effects.setTransition(i, h, s.from.x, i.from), i.to = e.effects.setTransition(i, h, s.to.x, i.to)), i.css(i.from), i.animate(i.to, t.duration, t.easing, function () {
                f && e.effects.restore(i, c)
            })
        })), r.animate(r.to, {
            queue: !1,
            duration: t.duration,
            easing: t.easing,
            complete: function () {
                0 === r.to.opacity && r.css("opacity", r.from.opacity), "hide" === p && r.hide(), e.effects.restore(r, y), f || ("static" === v ? r.css({
                    position: "relative",
                    top: r.to.top,
                    left: r.to.left
                }) : e.each(["top", "left"], function (e, t) {
                    r.css(t, function (t, i) {
                        var n = parseInt(i, 10),
                            o = e ? r.to.left : r.to.top;
                        return "auto" === i ? o + "px" : n + o + "px"
                    })
                })), e.effects.removeWrapper(r), i()
            }
        })
    }, e.effects.effect.scale = function (t, i) {
        var n = e(this),
            o = e.extend(!0, {}, t),
            s = e.effects.setMode(n, t.mode || "effect"),
            r = parseInt(t.percent, 10) || (0 === parseInt(t.percent, 10) ? 0 : "hide" === s ? 0 : 100),
            a = t.direction || "both",
            l = t.origin,
            c = {
                height: n.height(),
                width: n.width(),
                outerHeight: n.outerHeight(),
                outerWidth: n.outerWidth()
            },
            d = {
                y: "horizontal" !== a ? r / 100 : 1,
                x: "vertical" !== a ? r / 100 : 1
            };
        o.effect = "size", o.queue = !1, o.complete = i, "effect" !== s && (o.origin = l || ["middle", "center"], o.restore = !0), o.from = t.from || ("show" === s ? {
            height: 0,
            width: 0,
            outerHeight: 0,
            outerWidth: 0
        } : c), o.to = {
            height: c.height * d.y,
            width: c.width * d.x,
            outerHeight: c.outerHeight * d.y,
            outerWidth: c.outerWidth * d.x
        }, o.fade && ("show" === s && (o.from.opacity = 0, o.to.opacity = 1), "hide" === s && (o.from.opacity = 1, o.to.opacity = 0)), n.effect(o)
    }, e.effects.effect.puff = function (t, i) {
        var n = e(this),
            o = e.effects.setMode(n, t.mode || "hide"),
            s = "hide" === o,
            r = parseInt(t.percent, 10) || 150,
            a = r / 100,
            l = {
                height: n.height(),
                width: n.width(),
                outerHeight: n.outerHeight(),
                outerWidth: n.outerWidth()
            };
        e.extend(t, {
            effect: "scale",
            queue: !1,
            fade: !0,
            mode: o,
            complete: i,
            percent: s ? r : 100,
            from: s ? l : {
                height: l.height * a,
                width: l.width * a,
                outerHeight: l.outerHeight * a,
                outerWidth: l.outerWidth * a
            }
        }), n.effect(t)
    }, e.effects.effect.pulsate = function (t, i) {
        var n, o = e(this),
            s = e.effects.setMode(o, t.mode || "show"),
            r = "show" === s,
            a = "hide" === s,
            l = r || "hide" === s,
            c = 2 * (t.times || 5) + (l ? 1 : 0),
            d = t.duration / c,
            u = 0,
            h = o.queue(),
            p = h.length;
        for ((r || !o.is(":visible")) && (o.css("opacity", 0).show(), u = 1), n = 1; c > n; n++) o.animate({
            opacity: u
        }, d, t.easing), u = 1 - u;
        o.animate({
            opacity: u
        }, d, t.easing), o.queue(function () {
            a && o.hide(), i()
        }), p > 1 && h.splice.apply(h, [1, 0].concat(h.splice(p, c + 1))), o.dequeue()
    }, e.effects.effect.shake = function (t, i) {
        var n, o = e(this),
            s = ["position", "top", "bottom", "left", "right", "height", "width"],
            r = e.effects.setMode(o, t.mode || "effect"),
            a = t.direction || "left",
            l = t.distance || 20,
            c = t.times || 3,
            d = 2 * c + 1,
            u = Math.round(t.duration / d),
            h = "up" === a || "down" === a ? "top" : "left",
            p = "up" === a || "left" === a,
            f = {},
            g = {},
            m = {},
            v = o.queue(),
            y = v.length;
        for (e.effects.save(o, s), o.show(), e.effects.createWrapper(o), f[h] = (p ? "-=" : "+=") + l, g[h] = (p ? "+=" : "-=") + 2 * l, m[h] = (p ? "-=" : "+=") + 2 * l, o.animate(f, u, t.easing), n = 1; c > n; n++) o.animate(g, u, t.easing).animate(m, u, t.easing);
        o.animate(g, u, t.easing).animate(f, u / 2, t.easing).queue(function () {
            "hide" === r && o.hide(), e.effects.restore(o, s), e.effects.removeWrapper(o), i()
        }), y > 1 && v.splice.apply(v, [1, 0].concat(v.splice(y, d + 1))), o.dequeue()
    }, e.effects.effect.slide = function (t, i) {
        var n, o = e(this),
            s = ["position", "top", "bottom", "left", "right", "width", "height"],
            r = e.effects.setMode(o, t.mode || "show"),
            a = "show" === r,
            l = t.direction || "left",
            c = "up" === l || "down" === l ? "top" : "left",
            d = "up" === l || "left" === l,
            u = {};
        e.effects.save(o, s), o.show(), n = t.distance || o["top" === c ? "outerHeight" : "outerWidth"](!0), e.effects.createWrapper(o).css({
            overflow: "hidden"
        }), a && o.css(c, d ? isNaN(n) ? "-" + n : -n : n), u[c] = (a ? d ? "+=" : "-=" : d ? "-=" : "+=") + n, o.animate(u, {
            queue: !1,
            duration: t.duration,
            easing: t.easing,
            complete: function () {
                "hide" === r && o.hide(), e.effects.restore(o, s), e.effects.removeWrapper(o), i()
            }
        })
    }, e.effects.effect.transfer = function (t, i) {
        var n = e(this),
            o = e(t.to),
            s = "fixed" === o.css("position"),
            r = e("body"),
            a = s ? r.scrollTop() : 0,
            l = s ? r.scrollLeft() : 0,
            c = o.offset(),
            d = {
                top: c.top - a,
                left: c.left - l,
                height: o.innerHeight(),
                width: o.innerWidth()
            },
            u = n.offset(),
            h = e("<div class='ui-effects-transfer'></div>").appendTo(document.body).addClass(t.className).css({
                top: u.top - a,
                left: u.left - l,
                height: n.innerHeight(),
                width: n.innerWidth(),
                position: s ? "fixed" : "absolute"
            }).animate(d, t.duration, t.easing, function () {
                h.remove(), i()
            })
    }
}),
function (e, t, i, n) {
    "use strict";
    var o = i("html"),
        s = i(e),
        r = i(t),
        a = i.fancybox = function () {
            a.open.apply(this, arguments)
        },
        l = navigator.userAgent.match(/msie/i),
        c = null,
        d = t.createTouch !== n,
        u = function (e) {
            return e && e.hasOwnProperty && e instanceof i
        },
        h = function (e) {
            return e && "string" === i.type(e)
        },
        p = function (e) {
            return h(e) && e.indexOf("%") > 0
        },
        f = function (e) {
            return e && !(e.style.overflow && "hidden" === e.style.overflow) && (e.clientWidth && e.scrollWidth > e.clientWidth || e.clientHeight && e.scrollHeight > e.clientHeight)
        },
        g = function (e, t) {
            var i = parseInt(e, 10) || 0;
            return t && p(e) && (i = a.getViewport()[t] / 100 * i), Math.ceil(i)
        },
        m = function (e, t) {
            return g(e, t) + "px"
        };
    i.extend(a, {
        version: "2.1.5",
        defaults: {
            padding: 15,
            margin: 20,
            width: 800,
            height: 600,
            minWidth: 100,
            minHeight: 100,
            maxWidth: 9999,
            maxHeight: 9999,
            pixelRatio: 1,
            autoSize: !0,
            autoHeight: !1,
            autoWidth: !1,
            autoResize: !0,
            autoCenter: !d,
            fitToView: !0,
            aspectRatio: !1,
            topRatio: .5,
            leftRatio: .5,
            scrolling: "auto",
            wrapCSS: "",
            arrows: !0,
            closeBtn: !0,
            closeClick: !1,
            nextClick: !1,
            mouseWheel: !0,
            autoPlay: !1,
            playSpeed: 3e3,
            preload: 3,
            modal: !1,
            loop: !0,
            ajax: {
                dataType: "html",
                headers: {
                    "X-fancyBox": !0
                }
            },
            iframe: {
                scrolling: "auto",
                preload: !0
            },
            swf: {
                wmode: "transparent",
                allowfullscreen: "true",
                allowscriptaccess: "always"
            },
            keys: {
                next: {
                    13: "left",
                    34: "up",
                    39: "left",
                    40: "up"
                },
                prev: {
                    8: "right",
                    33: "down",
                    37: "right",
                    38: "down"
                },
                close: [27],
                play: [32],
                toggle: [70]
            },
            direction: {
                next: "left",
                prev: "right"
            },
            scrollOutside: !0,
            index: 0,
            type: null,
            href: null,
            content: null,
            title: null,
            tpl: {
                wrap: '<div class="fancybox-wrap" tabIndex="-1"><div class="fancybox-skin"><div class="fancybox-outer"><div class="fancybox-inner"></div></div></div></div>',
                image: '<img class="fancybox-image" src="{href}" alt="" />',
                iframe: '<iframe id="fancybox-frame{rnd}" name="fancybox-frame{rnd}" class="fancybox-iframe" frameborder="0" vspace="0" hspace="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen' + (l ? ' allowtransparency="true"' : "") + "></iframe>",
                error: '<p class="fancybox-error">The requested content cannot be loaded.<br/>Please try again later.</p>',
                closeBtn: '<a title="Close" class="fancybox-item fancybox-close" href="javascript:;"></a>',
                next: '<a title="Next" class="fancybox-nav fancybox-next" href="javascript:;"><span></span></a>',
                prev: '<a title="Previous" class="fancybox-nav fancybox-prev" href="javascript:;"><span></span></a>'
            },
            openEffect: "fade",
            openSpeed: 250,
            openEasing: "swing",
            openOpacity: !0,
            openMethod: "zoomIn",
            closeEffect: "fade",
            closeSpeed: 250,
            closeEasing: "swing",
            closeOpacity: !0,
            closeMethod: "zoomOut",
            nextEffect: "elastic",
            nextSpeed: 250,
            nextEasing: "swing",
            nextMethod: "changeIn",
            prevEffect: "elastic",
            prevSpeed: 250,
            prevEasing: "swing",
            prevMethod: "changeOut",
            helpers: {
                overlay: !0,
                title: !0
            },
            onCancel: i.noop,
            beforeLoad: i.noop,
            afterLoad: i.noop,
            beforeShow: i.noop,
            afterShow: i.noop,
            beforeChange: i.noop,
            beforeClose: i.noop,
            afterClose: i.noop
        },
        group: {},
        opts: {},
        previous: null,
        coming: null,
        current: null,
        isActive: !1,
        isOpen: !1,
        isOpened: !1,
        wrap: null,
        skin: null,
        outer: null,
        inner: null,
        player: {
            timer: null,
            isActive: !1
        },
        ajaxLoad: null,
        imgPreload: null,
        transitions: {},
        helpers: {},
        open: function (e, t) {
            return e && (i.isPlainObject(t) || (t = {}), !1 !== a.close(!0)) ? (i.isArray(e) || (e = u(e) ? i(e).get() : [e]), i.each(e, function (o, s) {
                var r, l, c, d, p, f, g, m = {};
                "object" === i.type(s) && (s.nodeType && (s = i(s)), u(s) ? (m = {
                    href: s.data("fancybox-href") || s.attr("href"),
                    title: s.data("fancybox-title") || s.attr("title"),
                    isDom: !0,
                    element: s
                }, i.metadata && i.extend(!0, m, s.metadata())) : m = s), r = t.href || m.href || (h(s) ? s : null), l = t.title !== n ? t.title : m.title || "", c = t.content || m.content, d = c ? "html" : t.type || m.type, !d && m.isDom && (d = s.data("fancybox-type"), d || (p = s.prop("class").match(/fancybox\.(\w+)/), d = p ? p[1] : null)), h(r) && (d || (a.isImage(r) ? d = "image" : a.isSWF(r) ? d = "swf" : "#" === r.charAt(0) ? d = "inline" : h(s) && (d = "html", c = s)), "ajax" === d && (f = r.split(/\s+/, 2), r = f.shift(), g = f.shift())), c || ("inline" === d ? r ? c = i(h(r) ? r.replace(/.*(?=#[^\s]+$)/, "") : r) : m.isDom && (c = s) : "html" === d ? c = r : d || r || !m.isDom || (d = "inline", c = s)), i.extend(m, {
                    href: r,
                    type: d,
                    content: c,
                    title: l,
                    selector: g
                }), e[o] = m
            }), a.opts = i.extend(!0, {}, a.defaults, t), t.keys !== n && (a.opts.keys = t.keys ? i.extend({}, a.defaults.keys, t.keys) : !1), a.group = e, a._start(a.opts.index)) : void 0
        },
        cancel: function () {
            var e = a.coming;
            e && !1 !== a.trigger("onCancel") && (a.hideLoading(), a.ajaxLoad && a.ajaxLoad.abort(), a.ajaxLoad = null, a.imgPreload && (a.imgPreload.onload = a.imgPreload.onerror = null), e.wrap && e.wrap.stop(!0, !0).trigger("onReset").remove(), a.coming = null, a.current || a._afterZoomOut(e))
        },
        close: function (e) {
            a.cancel(), !1 !== a.trigger("beforeClose") && (a.unbindEvents(), a.isActive && (a.isOpen && e !== !0 ? (a.isOpen = a.isOpened = !1, a.isClosing = !0, i(".fancybox-item, .fancybox-nav").remove(), a.wrap.stop(!0, !0).removeClass("fancybox-opened"), a.transitions[a.current.closeMethod]()) : (i(".fancybox-wrap").stop(!0).trigger("onReset").remove(), a._afterZoomOut())))
        },
        play: function (e) {
            var t = function () {
                    clearTimeout(a.player.timer)
                },
                i = function () {
                    t(), a.current && a.player.isActive && (a.player.timer = setTimeout(a.next, a.current.playSpeed))
                },
                n = function () {
                    t(), r.unbind(".player"), a.player.isActive = !1, a.trigger("onPlayEnd")
                },
                o = function () {
                    a.current && (a.current.loop || a.current.index < a.group.length - 1) && (a.player.isActive = !0, r.bind({
                        "onCancel.player beforeClose.player": n,
                        "onUpdate.player": i,
                        "beforeLoad.player": t
                    }), i(), a.trigger("onPlayStart"))
                };
            e === !0 || !a.player.isActive && e !== !1 ? o() : n()
        },
        next: function (e) {
            var t = a.current;
            t && (h(e) || (e = t.direction.next), a.jumpto(t.index + 1, e, "next"))
        },
        prev: function (e) {
            var t = a.current;
            t && (h(e) || (e = t.direction.prev), a.jumpto(t.index - 1, e, "prev"))
        },
        jumpto: function (e, t, i) {
            var o = a.current;
            o && (e = g(e), a.direction = t || o.direction[e >= o.index ? "next" : "prev"], a.router = i || "jumpto", o.loop && (0 > e && (e = o.group.length + e % o.group.length), e %= o.group.length), o.group[e] !== n && (a.cancel(), a._start(e)))
        },
        reposition: function (e, t) {
            var n, o = a.current,
                s = o ? o.wrap : null;
            s && (n = a._getPosition(t), e && "scroll" === e.type ? (delete n.position, s.stop(!0, !0).animate(n, 200)) : (s.css(n), o.pos = i.extend({}, o.dim, n)))
        },
        update: function (e) {
            var t = e && e.type,
                i = !t || "orientationchange" === t;
            i && (clearTimeout(c), c = null), a.isOpen && !c && (c = setTimeout(function () {
                var n = a.current;
                n && !a.isClosing && (a.wrap.removeClass("fancybox-tmp"), (i || "load" === t || "resize" === t && n.autoResize) && a._setDimension(), "scroll" === t && n.canShrink || a.reposition(e), a.trigger("onUpdate"), c = null)
            }, i && !d ? 0 : 300))
        },
        toggle: function (e) {
            a.isOpen && (a.current.fitToView = "boolean" === i.type(e) ? e : !a.current.fitToView, d && (a.wrap.removeAttr("style").addClass("fancybox-tmp"), a.trigger("onUpdate")), a.update())
        },
        hideLoading: function () {
            r.unbind(".loading"), i("#fancybox-loading").remove()
        },
        showLoading: function () {
            var e, t;
            a.hideLoading(), e = i('<div id="fancybox-loading"><div></div></div>').click(a.cancel).appendTo("body"), r.bind("keydown.loading", function (e) {
                27 === (e.which || e.keyCode) && (e.preventDefault(), a.cancel())
            }), a.defaults.fixed || (t = a.getViewport(), e.css({
                position: "absolute",
                top: .5 * t.h + t.y,
                left: .5 * t.w + t.x
            }))
        },
        getViewport: function () {
            var t = a.current && a.current.locked || !1,
                i = {
                    x: s.scrollLeft(),
                    y: s.scrollTop()
                };
            return t ? (i.w = t[0].clientWidth, i.h = t[0].clientHeight) : (i.w = d && e.innerWidth ? e.innerWidth : s.width(), i.h = d && e.innerHeight ? e.innerHeight : s.height()), i
        },
        unbindEvents: function () {
            a.wrap && u(a.wrap) && a.wrap.unbind(".fb"), r.unbind(".fb"), s.unbind(".fb")
        },
        bindEvents: function () {
            var e, t = a.current;
            t && (s.bind("orientationchange.fb" + (d ? "" : " resize.fb") + (t.autoCenter && !t.locked ? " scroll.fb" : ""), a.update), e = t.keys, e && r.bind("keydown.fb", function (o) {
                var s = o.which || o.keyCode,
                    r = o.target || o.srcElement;
                return 27 === s && a.coming ? !1 : void(o.ctrlKey || o.altKey || o.shiftKey || o.metaKey || r && (r.type || i(r).is("[contenteditable]")) || i.each(e, function (e, r) {
                    return t.group.length > 1 && r[s] !== n ? (a[e](r[s]), o.preventDefault(), !1) : i.inArray(s, r) > -1 ? (a[e](), o.preventDefault(), !1) : void 0
                }))
            }), i.fn.mousewheel && t.mouseWheel && a.wrap.bind("mousewheel.fb", function (e, n, o, s) {
                for (var r = e.target || null, l = i(r), c = !1; l.length && !(c || l.is(".fancybox-skin") || l.is(".fancybox-wrap"));) c = f(l[0]), l = i(l).parent();
                0 === n || c || a.group.length > 1 && !t.canShrink && (s > 0 || o > 0 ? a.prev(s > 0 ? "down" : "left") : (0 > s || 0 > o) && a.next(0 > s ? "up" : "right"), e.preventDefault())
            }))
        },
        trigger: function (e, t) {
            var n, o = t || a.coming || a.current;
            if (o) {
                if (i.isFunction(o[e]) && (n = o[e].apply(o, Array.prototype.slice.call(arguments, 1))), n === !1) return !1;
                o.helpers && i.each(o.helpers, function (t, n) {
                    n && a.helpers[t] && i.isFunction(a.helpers[t][e]) && a.helpers[t][e](i.extend(!0, {}, a.helpers[t].defaults, n), o)
                }), r.trigger(e)
            }
        },
        isImage: function (e) {
            return h(e) && e.match(/(^data:image\/.*,)|(\.(jp(e|g|eg)|gif|png|bmp|webp|svg)((\?|#).*)?$)/i)
        },
        isSWF: function (e) {
            return h(e) && e.match(/\.(swf)((\?|#).*)?$/i)
        },
        _start: function (e) {
            var t, n, o, s, r, l = {};
            if (e = g(e), t = a.group[e] || null, !t) return !1;
            if (l = i.extend(!0, {}, a.opts, t), s = l.margin, r = l.padding, "number" === i.type(s) && (l.margin = [s, s, s, s]), "number" === i.type(r) && (l.padding = [r, r, r, r]), l.modal && i.extend(!0, l, {
                    closeBtn: !1,
                    closeClick: !1,
                    nextClick: !1,
                    arrows: !1,
                    mouseWheel: !1,
                    keys: null,
                    helpers: {
                        overlay: {
                            closeClick: !1
                        }
                    }
                }), l.autoSize && (l.autoWidth = l.autoHeight = !0), "auto" === l.width && (l.autoWidth = !0), "auto" === l.height && (l.autoHeight = !0), l.group = a.group, l.index = e, a.coming = l, !1 === a.trigger("beforeLoad")) return void(a.coming = null);
            if (o = l.type, n = l.href, !o) return a.coming = null, a.current && a.router && "jumpto" !== a.router ? (a.current.index = e, a[a.router](a.direction)) : !1;
            if (a.isActive = !0, ("image" === o || "swf" === o) && (l.autoHeight = l.autoWidth = !1, l.scrolling = "visible"), "image" === o && (l.aspectRatio = !0), "iframe" === o && d && (l.scrolling = "scroll"),
                l.wrap = i(l.tpl.wrap).addClass("fancybox-" + (d ? "mobile" : "desktop") + " fancybox-type-" + o + " fancybox-tmp " + l.wrapCSS).appendTo(l.parent || "body"), i.extend(l, {
                    skin: i(".fancybox-skin", l.wrap),
                    outer: i(".fancybox-outer", l.wrap),
                    inner: i(".fancybox-inner", l.wrap)
                }), i.each(["Top", "Right", "Bottom", "Left"], function (e, t) {
                    l.skin.css("padding" + t, m(l.padding[e]))
                }), a.trigger("onReady"), "inline" === o || "html" === o) {
                if (!l.content || !l.content.length) return a._error("content")
            } else if (!n) return a._error("href");
            "image" === o ? a._loadImage() : "ajax" === o ? a._loadAjax() : "iframe" === o ? a._loadIframe() : a._afterLoad()
        },
        _error: function (e) {
            i.extend(a.coming, {
                type: "html",
                autoWidth: !0,
                autoHeight: !0,
                minWidth: 0,
                minHeight: 0,
                scrolling: "no",
                hasError: e,
                content: a.coming.tpl.error
            }), a._afterLoad()
        },
        _loadImage: function () {
            var e = a.imgPreload = new Image;
            e.onload = function () {
                this.onload = this.onerror = null, a.coming.width = this.width / a.opts.pixelRatio, a.coming.height = this.height / a.opts.pixelRatio, a._afterLoad()
            }, e.onerror = function () {
                this.onload = this.onerror = null, a._error("image")
            }, e.src = a.coming.href, e.complete !== !0 && a.showLoading()
        },
        _loadAjax: function () {
            var e = a.coming;
            a.showLoading(), a.ajaxLoad = i.ajax(i.extend({}, e.ajax, {
                url: e.href,
                error: function (e, t) {
                    a.coming && "abort" !== t ? a._error("ajax", e) : a.hideLoading()
                },
                success: function (t, i) {
                    "success" === i && (e.content = t, a._afterLoad())
                }
            }))
        },
        _loadIframe: function () {
            var e = a.coming,
                t = i(e.tpl.iframe.replace(/\{rnd\}/g, (new Date).getTime())).attr("scrolling", d ? "auto" : e.iframe.scrolling).attr("src", e.href);
            i(e.wrap).bind("onReset", function () {
                try {
                    i(this).find("iframe").hide().attr("src", "//about:blank").end().empty()
                } catch (e) {}
            }), e.iframe.preload && (a.showLoading(), t.one("load", function () {
                i(this).data("ready", 1), d || i(this).bind("load.fb", a.update), i(this).parents(".fancybox-wrap").width("100%").removeClass("fancybox-tmp").show(), a._afterLoad()
            })), e.content = t.appendTo(e.inner), e.iframe.preload || a._afterLoad()
        },
        _preloadImages: function () {
            var e, t, i = a.group,
                n = a.current,
                o = i.length,
                s = n.preload ? Math.min(n.preload, o - 1) : 0;
            for (t = 1; s >= t; t += 1) e = i[(n.index + t) % o], "image" === e.type && e.href && ((new Image).src = e.href)
        },
        _afterLoad: function () {
            var e, t, n, o, s, r, l = a.coming,
                c = a.current,
                d = "fancybox-placeholder";
            if (a.hideLoading(), l && a.isActive !== !1) {
                if (!1 === a.trigger("afterLoad", l, c)) return l.wrap.stop(!0).trigger("onReset").remove(), void(a.coming = null);
                switch (c && (a.trigger("beforeChange", c), c.wrap.stop(!0).removeClass("fancybox-opened").find(".fancybox-item, .fancybox-nav").remove()), a.unbindEvents(), e = l, t = l.content, n = l.type, o = l.scrolling, i.extend(a, {
                    wrap: e.wrap,
                    skin: e.skin,
                    outer: e.outer,
                    inner: e.inner,
                    current: e,
                    previous: c
                }), s = e.href, n) {
                    case "inline":
                    case "ajax":
                    case "html":
                        e.selector ? t = i("<div>").html(t).find(e.selector) : u(t) && (t.data(d) || t.data(d, i('<div class="' + d + '"></div>').insertAfter(t).hide()), t = t.show().detach(), e.wrap.bind("onReset", function () {
                            i(this).find(t).length && t.hide().replaceAll(t.data(d)).data(d, !1)
                        }));
                        break;
                    case "image":
                        t = e.tpl.image.replace("{href}", s);
                        break;
                    case "swf":
                        t = '<object id="fancybox-swf" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%"><param name="movie" value="' + s + '"></param>', r = "", i.each(e.swf, function (e, i) {
                            t += '<param name="' + e + '" value="' + i + '"></param>', r += " " + e + '="' + i + '"'
                        }), t += '<embed src="' + s + '" type="application/x-shockwave-flash" width="100%" height="100%"' + r + "></embed></object>"
                }
                u(t) && t.parent().is(e.inner) || e.inner.append(t), a.trigger("beforeShow"), e.inner.css("overflow", "yes" === o ? "scroll" : "no" === o ? "hidden" : o), a._setDimension(), a.reposition(), a.isOpen = !1, a.coming = null, a.bindEvents(), a.isOpened ? c.prevMethod && a.transitions[c.prevMethod]() : i(".fancybox-wrap").not(e.wrap).stop(!0).trigger("onReset").remove(), a.transitions[a.isOpened ? e.nextMethod : e.openMethod](), a._preloadImages()
            }
        },
        _setDimension: function () {
            var e, t, n, o, s, r, l, c, d, u, h, f, v, y, b, w = a.getViewport(),
                k = 0,
                _ = !1,
                x = !1,
                C = a.wrap,
                T = a.skin,
                S = a.inner,
                D = a.current,
                M = D.width,
                I = D.height,
                E = D.minWidth,
                A = D.minHeight,
                $ = D.maxWidth,
                O = D.maxHeight,
                H = D.scrolling,
                P = D.scrollOutside ? D.scrollbarWidth : 0,
                N = D.margin,
                L = g(N[1] + N[3]),
                W = g(N[0] + N[2]);
            if (C.add(T).add(S).width("auto").height("auto").removeClass("fancybox-tmp"), e = g(T.outerWidth(!0) - T.width()), t = g(T.outerHeight(!0) - T.height()), n = L + e, o = W + t, s = p(M) ? (w.w - n) * g(M) / 100 : M, r = p(I) ? (w.h - o) * g(I) / 100 : I, "iframe" === D.type) {
                if (y = D.content, D.autoHeight && 1 === y.data("ready")) try {
                    y[0].contentWindow.document.location && (S.width(s).height(9999), b = y.contents().find("body"), P && b.css("overflow-x", "hidden"), r = b.outerHeight(!0))
                } catch (R) {}
            } else(D.autoWidth || D.autoHeight) && (S.addClass("fancybox-tmp"), D.autoWidth || S.width(s), D.autoHeight || S.height(r), D.autoWidth && (s = S.width()), D.autoHeight && (r = S.height()), S.removeClass("fancybox-tmp"));
            if (M = g(s), I = g(r), d = s / r, E = g(p(E) ? g(E, "w") - n : E), $ = g(p($) ? g($, "w") - n : $), A = g(p(A) ? g(A, "h") - o : A), O = g(p(O) ? g(O, "h") - o : O), l = $, c = O, D.fitToView && ($ = Math.min(w.w - n, $), O = Math.min(w.h - o, O)), f = w.w - L, v = w.h - W, D.aspectRatio ? (M > $ && (M = $, I = g(M / d)), I > O && (I = O, M = g(I * d)), E > M && (M = E, I = g(M / d)), A > I && (I = A, M = g(I * d))) : (M = Math.max(E, Math.min(M, $)), D.autoHeight && "iframe" !== D.type && (S.width(M), I = S.height()), I = Math.max(A, Math.min(I, O))), D.fitToView)
                if (S.width(M).height(I), C.width(M + e), u = C.width(), h = C.height(), D.aspectRatio)
                    for (;
                        (u > f || h > v) && M > E && I > A && !(k++ > 19);) I = Math.max(A, Math.min(O, I - 10)), M = g(I * d), E > M && (M = E, I = g(M / d)), M > $ && (M = $, I = g(M / d)), S.width(M).height(I), C.width(M + e), u = C.width(), h = C.height();
                else M = Math.max(E, Math.min(M, M - (u - f))), I = Math.max(A, Math.min(I, I - (h - v)));
            P && "auto" === H && r > I && f > M + e + P && (M += P), S.width(M).height(I), C.width(M + e), u = C.width(), h = C.height(), _ = (u > f || h > v) && M > E && I > A, x = D.aspectRatio ? l > M && c > I && s > M && r > I : (l > M || c > I) && (s > M || r > I), i.extend(D, {
                dim: {
                    width: m(u),
                    height: m(h)
                },
                origWidth: s,
                origHeight: r,
                canShrink: _,
                canExpand: x,
                wPadding: e,
                hPadding: t,
                wrapSpace: h - T.outerHeight(!0),
                skinSpace: T.height() - I
            }), !y && D.autoHeight && I > A && O > I && !x && S.height("auto")
        },
        _getPosition: function (e) {
            var t = a.current,
                i = a.getViewport(),
                n = t.margin,
                o = a.wrap.width() + n[1] + n[3],
                s = a.wrap.height() + n[0] + n[2],
                r = {
                    position: "absolute",
                    top: n[0],
                    left: n[3]
                };
            return t.autoCenter && t.fixed && !e && s <= i.h && o <= i.w ? r.position = "fixed" : t.locked || (r.top += i.y, r.left += i.x), r.top = m(Math.max(r.top, r.top + (i.h - s) * t.topRatio)), r.left = m(Math.max(r.left, r.left + (i.w - o) * t.leftRatio)), r
        },
        _afterZoomIn: function () {
            var e = a.current;
            e && (a.isOpen = a.isOpened = !0, a.wrap.css("overflow", "visible").addClass("fancybox-opened"), a.update(), (e.closeClick || e.nextClick && a.group.length > 1) && a.inner.css("cursor", "pointer").bind("click.fb", function (t) {
                i(t.target).is("a") || i(t.target).parent().is("a") || (t.preventDefault(), a[e.closeClick ? "close" : "next"]())
            }), e.closeBtn && i(e.tpl.closeBtn).appendTo(a.skin).bind("click.fb", function (e) {
                e.preventDefault(), a.close()
            }), e.arrows && a.group.length > 1 && ((e.loop || e.index > 0) && i(e.tpl.prev).appendTo(a.outer).bind("click.fb", a.prev), (e.loop || e.index < a.group.length - 1) && i(e.tpl.next).appendTo(a.outer).bind("click.fb", a.next)), a.trigger("afterShow"), e.loop || e.index !== e.group.length - 1 ? a.opts.autoPlay && !a.player.isActive && (a.opts.autoPlay = !1, a.play()) : a.play(!1))
        },
        _afterZoomOut: function (e) {
            e = e || a.current, i(".fancybox-wrap").trigger("onReset").remove(), i.extend(a, {
                group: {},
                opts: {},
                router: !1,
                current: null,
                isActive: !1,
                isOpened: !1,
                isOpen: !1,
                isClosing: !1,
                wrap: null,
                skin: null,
                outer: null,
                inner: null
            }), a.trigger("afterClose", e)
        }
    }), a.transitions = {
        getOrigPosition: function () {
            var e = a.current,
                t = e.element,
                i = e.orig,
                n = {},
                o = 50,
                s = 50,
                r = e.hPadding,
                l = e.wPadding,
                c = a.getViewport();
            return !i && e.isDom && t.is(":visible") && (i = t.find("img:first"), i.length || (i = t)), u(i) ? (n = i.offset(), i.is("img") && (o = i.outerWidth(), s = i.outerHeight())) : (n.top = c.y + (c.h - s) * e.topRatio, n.left = c.x + (c.w - o) * e.leftRatio), ("fixed" === a.wrap.css("position") || e.locked) && (n.top -= c.y, n.left -= c.x), n = {
                top: m(n.top - r * e.topRatio),
                left: m(n.left - l * e.leftRatio),
                width: m(o + l),
                height: m(s + r)
            }
        },
        step: function (e, t) {
            var i, n, o, s = t.prop,
                r = a.current,
                l = r.wrapSpace,
                c = r.skinSpace;
            ("width" === s || "height" === s) && (i = t.end === t.start ? 1 : (e - t.start) / (t.end - t.start), a.isClosing && (i = 1 - i), n = "width" === s ? r.wPadding : r.hPadding, o = e - n, a.skin[s](g("width" === s ? o : o - l * i)), a.inner[s](g("width" === s ? o : o - l * i - c * i)))
        },
        zoomIn: function () {
            var e = a.current,
                t = e.pos,
                n = e.openEffect,
                o = "elastic" === n,
                s = i.extend({
                    opacity: 1
                }, t);
            delete s.position, o ? (t = this.getOrigPosition(), e.openOpacity && (t.opacity = .1)) : "fade" === n && (t.opacity = .1), a.wrap.css(t).animate(s, {
                duration: "none" === n ? 0 : e.openSpeed,
                easing: e.openEasing,
                step: o ? this.step : null,
                complete: a._afterZoomIn
            })
        },
        zoomOut: function () {
            var e = a.current,
                t = e.closeEffect,
                i = "elastic" === t,
                n = {
                    opacity: .1
                };
            i && (n = this.getOrigPosition(), e.closeOpacity && (n.opacity = .1)), a.wrap.animate(n, {
                duration: "none" === t ? 0 : e.closeSpeed,
                easing: e.closeEasing,
                step: i ? this.step : null,
                complete: a._afterZoomOut
            })
        },
        changeIn: function () {
            var e, t = a.current,
                i = t.nextEffect,
                n = t.pos,
                o = {
                    opacity: 1
                },
                s = a.direction,
                r = 200;
            n.opacity = .1, "elastic" === i && (e = "down" === s || "up" === s ? "top" : "left", "down" === s || "right" === s ? (n[e] = m(g(n[e]) - r), o[e] = "+=" + r + "px") : (n[e] = m(g(n[e]) + r), o[e] = "-=" + r + "px")), "none" === i ? a._afterZoomIn() : a.wrap.css(n).animate(o, {
                duration: t.nextSpeed,
                easing: t.nextEasing,
                complete: a._afterZoomIn
            })
        },
        changeOut: function () {
            var e = a.previous,
                t = e.prevEffect,
                n = {
                    opacity: .1
                },
                o = a.direction,
                s = 200;
            "elastic" === t && (n["down" === o || "up" === o ? "top" : "left"] = ("up" === o || "left" === o ? "-" : "+") + "=" + s + "px"), e.wrap.animate(n, {
                duration: "none" === t ? 0 : e.prevSpeed,
                easing: e.prevEasing,
                complete: function () {
                    i(this).trigger("onReset").remove()
                }
            })
        }
    }, a.helpers.overlay = {
        defaults: {
            closeClick: !0,
            speedOut: 200,
            showEarly: !0,
            css: {},
            locked: !d,
            fixed: !0
        },
        overlay: null,
        fixed: !1,
        el: i("html"),
        create: function (e) {
            e = i.extend({}, this.defaults, e), this.overlay && this.close(), this.overlay = i('<div class="fancybox-overlay"></div>').appendTo(a.coming ? a.coming.parent : e.parent), this.fixed = !1, e.fixed && a.defaults.fixed && (this.overlay.addClass("fancybox-overlay-fixed"), this.fixed = !0)
        },
        open: function (e) {
            var t = this;
            e = i.extend({}, this.defaults, e), this.overlay ? this.overlay.unbind(".overlay").width("auto").height("auto") : this.create(e), this.fixed || (s.bind("resize.overlay", i.proxy(this.update, this)), this.update()), e.closeClick && this.overlay.bind("click.overlay", function (e) {
                return i(e.target).hasClass("fancybox-overlay") ? (a.isActive ? a.close() : t.close(), !1) : void 0
            }), this.overlay.css(e.css).show()
        },
        close: function () {
            var e, t;
            s.unbind("resize.overlay"), this.el.hasClass("fancybox-lock") && (i(".fancybox-margin").removeClass("fancybox-margin"), e = s.scrollTop(), t = s.scrollLeft(), this.el.removeClass("fancybox-lock"), s.scrollTop(e).scrollLeft(t)), i(".fancybox-overlay").remove().hide(), i.extend(this, {
                overlay: null,
                fixed: !1
            })
        },
        update: function () {
            var e, i = "100%";
            this.overlay.width(i).height("100%"), l ? (e = Math.max(t.documentElement.offsetWidth, t.body.offsetWidth), r.width() > e && (i = r.width())) : r.width() > s.width() && (i = r.width()), this.overlay.width(i).height(r.height())
        },
        onReady: function (e, t) {
            var n = this.overlay;
            i(".fancybox-overlay").stop(!0, !0), n || this.create(e), e.locked && this.fixed && t.fixed && (n || (this.margin = r.height() > s.height() ? i("html").css("margin-right").replace("px", "") : !1), t.locked = this.overlay.append(t.wrap), t.fixed = !1), e.showEarly === !0 && this.beforeShow.apply(this, arguments)
        },
        beforeShow: function (e, t) {
            var n, o;
            t.locked && (this.margin !== !1 && (i("*").filter(function () {
                return "fixed" === i(this).css("position") && !i(this).hasClass("fancybox-overlay") && !i(this).hasClass("fancybox-wrap")
            }).addClass("fancybox-margin"), this.el.addClass("fancybox-margin")), n = s.scrollTop(), o = s.scrollLeft(), this.el.addClass("fancybox-lock"), s.scrollTop(n).scrollLeft(o)), this.open(e)
        },
        onUpdate: function () {
            this.fixed || this.update()
        },
        afterClose: function (e) {
            this.overlay && !a.coming && this.overlay.fadeOut(e.speedOut, i.proxy(this.close, this))
        }
    }, a.helpers.title = {
        defaults: {
            type: "float",
            position: "bottom"
        },
        beforeShow: function (e) {
            var t, n, o = a.current,
                s = o.title,
                r = e.type;
            if (i.isFunction(s) && (s = s.call(o.element, o)), h(s) && "" !== i.trim(s)) {
                switch (t = i('<div class="fancybox-title fancybox-title-' + r + '-wrap">' + s + "</div>"), r) {
                    case "inside":
                        n = a.skin;
                        break;
                    case "outside":
                        n = a.wrap;
                        break;
                    case "over":
                        n = a.inner;
                        break;
                    default:
                        n = a.skin, t.appendTo("body"), l && t.width(t.width()), t.wrapInner('<span class="child"></span>'), a.current.margin[2] += Math.abs(g(t.css("margin-bottom")))
                }
                t["top" === e.position ? "prependTo" : "appendTo"](n)
            }
        }
    }, i.fn.fancybox = function (e) {
        var t, n = i(this),
            o = this.selector || "",
            s = function (s) {
                var r, l, c = i(this).blur(),
                    d = t;
                s.ctrlKey || s.altKey || s.shiftKey || s.metaKey || c.is(".fancybox-wrap") || (r = e.groupAttr || "data-fancybox-group", l = c.attr(r), l || (r = "rel", l = c.get(0)[r]), l && "" !== l && "nofollow" !== l && (c = o.length ? i(o) : n, c = c.filter("[" + r + '="' + l + '"]'), d = c.index(this)), e.index = d, a.open(c, e) !== !1 && s.preventDefault())
            };
        return e = e || {}, t = e.index || 0, o && e.live !== !1 ? r.undelegate(o, "click.fb-start").delegate(o + ":not('.fancybox-item, .fancybox-nav')", "click.fb-start", s) : n.unbind("click.fb-start").bind("click.fb-start", s), this.filter("[data-fancybox-start=1]").trigger("click"), this
    }, r.ready(function () {
        var t, s;
        i.scrollbarWidth === n && (i.scrollbarWidth = function () {
            var e = i('<div style="width:50px;height:50px;overflow:auto"><div/></div>').appendTo("body"),
                t = e.children(),
                n = t.innerWidth() - t.height(99).innerWidth();
            return e.remove(), n
        }), i.support.fixedPosition === n && (i.support.fixedPosition = function () {
            var e = i('<div style="position:fixed;top:20px;"></div>').appendTo("body"),
                t = 20 === e[0].offsetTop || 15 === e[0].offsetTop;
            return e.remove(), t
        }()), i.extend(a.defaults, {
            scrollbarWidth: i.scrollbarWidth(),
            fixed: i.support.fixedPosition,
            parent: i("body")
        }), t = i(e).width(), o.addClass("fancybox-lock-test"), s = i(e).width(), o.removeClass("fancybox-lock-test"), i("<style type='text/css'>.fancybox-margin{margin-right:" + (s - t) + "px;}</style>").appendTo("head")
    })
}(window, document, jQuery),
function (e) {
    var t = !1;
    if ("function" == typeof define && define.amd && (define(e), t = !0), "object" == typeof exports && (module.exports = e(), t = !0), !t) {
        var i = window.Cookies,
            n = window.Cookies = e();
        n.noConflict = function () {
            return window.Cookies = i, n
        }
    }
}(function () {
    function e() {
        for (var e = 0, t = {}; e < arguments.length; e++) {
            var i = arguments[e];
            for (var n in i) t[n] = i[n]
        }
        return t
    }

    function t(i) {
        function n(t, o, s) {
            var r;
            if ("undefined" != typeof document) {
                if (arguments.length > 1) {
                    if (s = e({
                            path: "/"
                        }, n.defaults, s), "number" == typeof s.expires) {
                        var a = new Date;
                        a.setMilliseconds(a.getMilliseconds() + 864e5 * s.expires), s.expires = a
                    }
                    try {
                        r = JSON.stringify(o), /^[\{\[]/.test(r) && (o = r)
                    } catch (l) {}
                    return o = i.write ? i.write(o, t) : encodeURIComponent(String(o)).replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent), t = encodeURIComponent(String(t)), t = t.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent), t = t.replace(/[\(\)]/g, escape), document.cookie = [t, "=", o, s.expires ? "; expires=" + s.expires.toUTCString() : "", s.path ? "; path=" + s.path : "", s.domain ? "; domain=" + s.domain : "", s.secure ? "; secure" : ""].join("")
                }
                t || (r = {});
                for (var c = document.cookie ? document.cookie.split("; ") : [], d = /(%[0-9A-Z]{2})+/g, u = 0; u < c.length; u++) {
                    var h = c[u].split("="),
                        p = h.slice(1).join("=");
                    '"' === p.charAt(0) && (p = p.slice(1, -1));
                    try {
                        var f = h[0].replace(d, decodeURIComponent);
                        if (p = i.read ? i.read(p, f) : i(p, f) || p.replace(d, decodeURIComponent), this.json) try {
                            p = JSON.parse(p)
                        } catch (l) {}
                        if (t === f) {
                            r = p;
                            break
                        }
                        t || (r[f] = p)
                    } catch (l) {}
                }
                return r
            }
        }
        return n.set = n, n.get = function (e) {
            return n.call(n, e)
        }, n.getJSON = function () {
            return n.apply({
                json: !0
            }, [].slice.call(arguments))
        }, n.defaults = {}, n.remove = function (t, i) {
            n(t, "", e(i, {
                expires: -1
            }))
        }, n.withConverter = t, n
    }
    return t(function () {})
}), ! function (e) {
    "use strict";
    "function" == typeof define && define.amd ? define(["jquery"], e) : "undefined" != typeof exports ? module.exports = e(require("jquery")) : e(jQuery)
}(function (e) {
    "use strict";
    var t = window.Slick || {};
    t = function () {
        function t(t, n) {
            var o, s = this;
            s.defaults = {
                accessibility: !0,
                adaptiveHeight: !1,
                appendArrows: e(t),
                appendDots: e(t),
                arrows: !0,
                asNavFor: null,
                prevArrow: '<button type="button" data-role="none" class="slick-prev" aria-label="Previous" tabindex="0" role="button">Previous</button>',
                nextArrow: '<button type="button" data-role="none" class="slick-next" aria-label="Next" tabindex="0" role="button">Next</button>',
                autoplay: !1,
                autoplaySpeed: 3e3,
                centerMode: !1,
                centerPadding: "50px",
                cssEase: "ease",
                customPaging: function (e, t) {
                    return '<button type="button" data-role="none" role="button" aria-required="false" tabindex="0">' + (t + 1) + "</button>"
                },
                dots: !1,
                dotsClass: "slick-dots",
                draggable: !0,
                easing: "linear",
                edgeFriction: .35,
                fade: !1,
                focusOnSelect: !1,
                infinite: !0,
                initialSlide: 0,
                lazyLoad: "ondemand",
                mobileFirst: !1,
                pauseOnHover: !0,
                pauseOnDotsHover: !1,
                respondTo: "window",
                responsive: null,
                rows: 1,
                rtl: !1,
                slide: "",
                slidesPerRow: 1,
                slidesToShow: 1,
                slidesToScroll: 1,
                speed: 500,
                swipe: !0,
                swipeToSlide: !1,
                touchMove: !0,
                touchThreshold: 5,
                useCSS: !0,
                useTransform: !1,
                variableWidth: !1,
                vertical: !1,
                verticalSwiping: !1,
                waitForAnimate: !0,
                zIndex: 1e3
            }, s.initials = {
                animating: !1,
                dragging: !1,
                autoPlayTimer: null,
                currentDirection: 0,
                currentLeft: null,
                currentSlide: 0,
                direction: 1,
                $dots: null,
                listWidth: null,
                listHeight: null,
                loadIndex: 0,
                $nextArrow: null,
                $prevArrow: null,
                slideCount: null,
                slideWidth: null,
                $slideTrack: null,
                $slides: null,
                sliding: !1,
                slideOffset: 0,
                swipeLeft: null,
                $list: null,
                touchObject: {},
                transformsEnabled: !1,
                unslicked: !1
            }, e.extend(s, s.initials), s.activeBreakpoint = null, s.animType = null, s.animProp = null, s.breakpoints = [], s.breakpointSettings = [], s.cssTransitions = !1, s.hidden = "hidden", s.paused = !1, s.positionProp = null, s.respondTo = null, s.rowCount = 1, s.shouldClick = !0, s.$slider = e(t), s.$slidesCache = null, s.transformType = null, s.transitionType = null, s.visibilityChange = "visibilitychange", s.windowWidth = 0, s.windowTimer = null, o = e(t).data("slick") || {}, s.options = e.extend({}, s.defaults, o, n), s.currentSlide = s.options.initialSlide, s.originalSettings = s.options, "undefined" != typeof document.mozHidden ? (s.hidden = "mozHidden", s.visibilityChange = "mozvisibilitychange") : "undefined" != typeof document.webkitHidden && (s.hidden = "webkitHidden", s.visibilityChange = "webkitvisibilitychange"), s.autoPlay = e.proxy(s.autoPlay, s), s.autoPlayClear = e.proxy(s.autoPlayClear, s), s.changeSlide = e.proxy(s.changeSlide, s), s.clickHandler = e.proxy(s.clickHandler, s), s.selectHandler = e.proxy(s.selectHandler, s), s.setPosition = e.proxy(s.setPosition, s), s.swipeHandler = e.proxy(s.swipeHandler, s), s.dragHandler = e.proxy(s.dragHandler, s), s.keyHandler = e.proxy(s.keyHandler, s), s.autoPlayIterator = e.proxy(s.autoPlayIterator, s), s.instanceUid = i++, s.htmlExpr = /^(?:\s*(<[\w\W]+>)[^>]*)$/, s.registerBreakpoints(), s.init(!0), s.checkResponsive(!0)
        }
        var i = 0;
        return t
    }(), t.prototype.addSlide = t.prototype.slickAdd = function (t, i, n) {
        var o = this;
        if ("boolean" == typeof i) n = i, i = null;
        else if (0 > i || i >= o.slideCount) return !1;
        o.unload(), "number" == typeof i ? 0 === i && 0 === o.$slides.length ? e(t).appendTo(o.$slideTrack) : n ? e(t).insertBefore(o.$slides.eq(i)) : e(t).insertAfter(o.$slides.eq(i)) : n === !0 ? e(t).prependTo(o.$slideTrack) : e(t).appendTo(o.$slideTrack), o.$slides = o.$slideTrack.children(this.options.slide), o.$slideTrack.children(this.options.slide).detach(), o.$slideTrack.append(o.$slides), o.$slides.each(function (t, i) {
            e(i).attr("data-slick-index", t)
        }), o.$slidesCache = o.$slides, o.reinit()
    }, t.prototype.animateHeight = function () {
        var e = this;
        if (1 === e.options.slidesToShow && e.options.adaptiveHeight === !0 && e.options.vertical === !1) {
            var t = e.$slides.eq(e.currentSlide).outerHeight(!0);
            e.$list.animate({
                height: t
            }, e.options.speed)
        }
    }, t.prototype.animateSlide = function (t, i) {
        var n = {},
            o = this;
        o.animateHeight(), o.options.rtl === !0 && o.options.vertical === !1 && (t = -t), o.transformsEnabled === !1 ? o.options.vertical === !1 ? o.$slideTrack.animate({
            left: t
        }, o.options.speed, o.options.easing, i) : o.$slideTrack.animate({
            top: t
        }, o.options.speed, o.options.easing, i) : o.cssTransitions === !1 ? (o.options.rtl === !0 && (o.currentLeft = -o.currentLeft), e({
            animStart: o.currentLeft
        }).animate({
            animStart: t
        }, {
            duration: o.options.speed,
            easing: o.options.easing,
            step: function (e) {
                e = Math.ceil(e), o.options.vertical === !1 ? (n[o.animType] = "translate(" + e + "px, 0px)", o.$slideTrack.css(n)) : (n[o.animType] = "translate(0px," + e + "px)", o.$slideTrack.css(n))
            },
            complete: function () {
                i && i.call()
            }
        })) : (o.applyTransition(), t = Math.ceil(t), o.options.vertical === !1 ? n[o.animType] = "translate3d(" + t + "px, 0px, 0px)" : n[o.animType] = "translate3d(0px," + t + "px, 0px)", o.$slideTrack.css(n), i && setTimeout(function () {
            o.disableTransition(), i.call()
        }, o.options.speed))
    }, t.prototype.asNavFor = function (t) {
        var i = this,
            n = i.options.asNavFor;
        n && null !== n && (n = e(n).not(i.$slider)), null !== n && "object" == typeof n && n.each(function () {
            var i = e(this).slick("getSlick");
            i.unslicked || i.slideHandler(t, !0)
        })
    }, t.prototype.applyTransition = function (e) {
        var t = this,
            i = {};
        t.options.fade === !1 ? i[t.transitionType] = t.transformType + " " + t.options.speed + "ms " + t.options.cssEase : i[t.transitionType] = "opacity " + t.options.speed + "ms " + t.options.cssEase, t.options.fade === !1 ? t.$slideTrack.css(i) : t.$slides.eq(e).css(i)
    }, t.prototype.autoPlay = function () {
        var e = this;
        e.autoPlayTimer && clearInterval(e.autoPlayTimer), e.slideCount > e.options.slidesToShow && e.paused !== !0 && (e.autoPlayTimer = setInterval(e.autoPlayIterator, e.options.autoplaySpeed))
    }, t.prototype.autoPlayClear = function () {
        var e = this;
        e.autoPlayTimer && clearInterval(e.autoPlayTimer)
    }, t.prototype.autoPlayIterator = function () {
        var e = this;
        e.options.infinite === !1 ? 1 === e.direction ? (e.currentSlide + 1 === e.slideCount - 1 && (e.direction = 0), e.slideHandler(e.currentSlide + e.options.slidesToScroll)) : (e.currentSlide - 1 === 0 && (e.direction = 1), e.slideHandler(e.currentSlide - e.options.slidesToScroll)) : e.slideHandler(e.currentSlide + e.options.slidesToScroll)
    }, t.prototype.buildArrows = function () {
        var t = this;
        t.options.arrows === !0 && (t.$prevArrow = e(t.options.prevArrow).addClass("slick-arrow"), t.$nextArrow = e(t.options.nextArrow).addClass("slick-arrow"), t.slideCount > t.options.slidesToShow ? (t.$prevArrow.removeClass("slick-hidden").removeAttr("aria-hidden tabindex"), t.$nextArrow.removeClass("slick-hidden").removeAttr("aria-hidden tabindex"), t.htmlExpr.test(t.options.prevArrow) && t.$prevArrow.prependTo(t.options.appendArrows), t.htmlExpr.test(t.options.nextArrow) && t.$nextArrow.appendTo(t.options.appendArrows), t.options.infinite !== !0 && t.$prevArrow.addClass("slick-disabled").attr("aria-disabled", "true")) : t.$prevArrow.add(t.$nextArrow).addClass("slick-hidden").attr({
            "aria-disabled": "true",
            tabindex: "-1"
        }))
    }, t.prototype.buildDots = function () {
        var t, i, n = this;
        if (n.options.dots === !0 && n.slideCount > n.options.slidesToShow) {
            for (i = '<ul class="' + n.options.dotsClass + '">', t = 0; t <= n.getDotCount(); t += 1) i += "<li>" + n.options.customPaging.call(this, n, t) + "</li>";
            i += "</ul>", n.$dots = e(i).appendTo(n.options.appendDots), n.$dots.find("li").first().addClass("slick-active").attr("aria-hidden", "false")
        }
    }, t.prototype.buildOut = function () {
        var t = this;
        t.$slides = t.$slider.children(t.options.slide + ":not(.slick-cloned)").addClass("slick-slide"), t.slideCount = t.$slides.length, t.$slides.each(function (t, i) {
            e(i).attr("data-slick-index", t).data("originalStyling", e(i).attr("style") || "")
        }), t.$slider.addClass("slick-slider"), t.$slideTrack = 0 === t.slideCount ? e('<div class="slick-track"/>').appendTo(t.$slider) : t.$slides.wrapAll('<div class="slick-track"/>').parent(), t.$list = t.$slideTrack.wrap('<div aria-live="polite" class="slick-list"/>').parent(), t.$slideTrack.css("opacity", 0), (t.options.centerMode === !0 || t.options.swipeToSlide === !0) && (t.options.slidesToScroll = 1), e("img[data-lazy]", t.$slider).not("[src]").addClass("slick-loading"), t.setupInfinite(), t.buildArrows(), t.buildDots(), t.updateDots(), t.setSlideClasses("number" == typeof t.currentSlide ? t.currentSlide : 0), t.options.draggable === !0 && t.$list.addClass("draggable")
    }, t.prototype.buildRows = function () {
        var e, t, i, n, o, s, r, a = this;
        if (n = document.createDocumentFragment(), s = a.$slider.children(), a.options.rows > 1) {
            for (r = a.options.slidesPerRow * a.options.rows, o = Math.ceil(s.length / r), e = 0; o > e; e++) {
                var l = document.createElement("div");
                for (t = 0; t < a.options.rows; t++) {
                    var c = document.createElement("div");
                    for (i = 0; i < a.options.slidesPerRow; i++) {
                        var d = e * r + (t * a.options.slidesPerRow + i);
                        s.get(d) && c.appendChild(s.get(d))
                    }
                    l.appendChild(c)
                }
                n.appendChild(l)
            }
            a.$slider.html(n), a.$slider.children().children().children().css({
                width: 100 / a.options.slidesPerRow + "%",
                display: "inline-block"
            })
        }
    }, t.prototype.checkResponsive = function (t, i) {
        var n, o, s, r = this,
            a = !1,
            l = r.$slider.width(),
            c = window.innerWidth || e(window).width();
        if ("window" === r.respondTo ? s = c : "slider" === r.respondTo ? s = l : "min" === r.respondTo && (s = Math.min(c, l)), r.options.responsive && r.options.responsive.length && null !== r.options.responsive) {
            o = null;
            for (n in r.breakpoints) r.breakpoints.hasOwnProperty(n) && (r.originalSettings.mobileFirst === !1 ? s < r.breakpoints[n] && (o = r.breakpoints[n]) : s > r.breakpoints[n] && (o = r.breakpoints[n]));
            null !== o ? null !== r.activeBreakpoint ? (o !== r.activeBreakpoint || i) && (r.activeBreakpoint = o, "unslick" === r.breakpointSettings[o] ? r.unslick(o) : (r.options = e.extend({}, r.originalSettings, r.breakpointSettings[o]), t === !0 && (r.currentSlide = r.options.initialSlide), r.refresh(t)), a = o) : (r.activeBreakpoint = o, "unslick" === r.breakpointSettings[o] ? r.unslick(o) : (r.options = e.extend({}, r.originalSettings, r.breakpointSettings[o]), t === !0 && (r.currentSlide = r.options.initialSlide), r.refresh(t)), a = o) : null !== r.activeBreakpoint && (r.activeBreakpoint = null, r.options = r.originalSettings, t === !0 && (r.currentSlide = r.options.initialSlide), r.refresh(t), a = o), t || a === !1 || r.$slider.trigger("breakpoint", [r, a])
        }
    }, t.prototype.changeSlide = function (t, i) {
        var n, o, s, r = this,
            a = e(t.target);
        switch (a.is("a") && t.preventDefault(), a.is("li") || (a = a.closest("li")), s = r.slideCount % r.options.slidesToScroll !== 0, n = s ? 0 : (r.slideCount - r.currentSlide) % r.options.slidesToScroll, t.data.message) {
            case "previous":
                o = 0 === n ? r.options.slidesToScroll : r.options.slidesToShow - n, r.slideCount > r.options.slidesToShow && r.slideHandler(r.currentSlide - o, !1, i);
                break;
            case "next":
                o = 0 === n ? r.options.slidesToScroll : n, r.slideCount > r.options.slidesToShow && r.slideHandler(r.currentSlide + o, !1, i);
                break;
            case "index":
                var l = 0 === t.data.index ? 0 : t.data.index || a.index() * r.options.slidesToScroll;
                r.slideHandler(r.checkNavigable(l), !1, i), a.children().trigger("focus");
                break;
            default:
                return
        }
    }, t.prototype.checkNavigable = function (e) {
        var t, i, n = this;
        if (t = n.getNavigableIndexes(), i = 0, e > t[t.length - 1]) e = t[t.length - 1];
        else
            for (var o in t) {
                if (e < t[o]) {
                    e = i;
                    break
                }
                i = t[o]
            }
        return e
    }, t.prototype.cleanUpEvents = function () {
        var t = this;
        t.options.dots && null !== t.$dots && (e("li", t.$dots).off("click.slick", t.changeSlide), t.options.pauseOnDotsHover === !0 && t.options.autoplay === !0 && e("li", t.$dots).off("mouseenter.slick", e.proxy(t.setPaused, t, !0)).off("mouseleave.slick", e.proxy(t.setPaused, t, !1))), t.options.arrows === !0 && t.slideCount > t.options.slidesToShow && (t.$prevArrow && t.$prevArrow.off("click.slick", t.changeSlide), t.$nextArrow && t.$nextArrow.off("click.slick", t.changeSlide)), t.$list.off("touchstart.slick mousedown.slick", t.swipeHandler), t.$list.off("touchmove.slick mousemove.slick", t.swipeHandler), t.$list.off("touchend.slick mouseup.slick", t.swipeHandler), t.$list.off("touchcancel.slick mouseleave.slick", t.swipeHandler), t.$list.off("click.slick", t.clickHandler), e(document).off(t.visibilityChange, t.visibility), t.$list.off("mouseenter.slick", e.proxy(t.setPaused, t, !0)), t.$list.off("mouseleave.slick", e.proxy(t.setPaused, t, !1)), t.options.accessibility === !0 && t.$list.off("keydown.slick", t.keyHandler), t.options.focusOnSelect === !0 && e(t.$slideTrack).children().off("click.slick", t.selectHandler), e(window).off("orientationchange.slick.slick-" + t.instanceUid, t.orientationChange), e(window).off("resize.slick.slick-" + t.instanceUid, t.resize), e("[draggable!=true]", t.$slideTrack).off("dragstart", t.preventDefault), e(window).off("load.slick.slick-" + t.instanceUid, t.setPosition), e(document).off("ready.slick.slick-" + t.instanceUid, t.setPosition)
    }, t.prototype.cleanUpRows = function () {
        var e, t = this;
        t.options.rows > 1 && (e = t.$slides.children().children(), e.removeAttr("style"), t.$slider.html(e))
    }, t.prototype.clickHandler = function (e) {
        var t = this;
        t.shouldClick === !1 && (e.stopImmediatePropagation(), e.stopPropagation(), e.preventDefault())
    }, t.prototype.destroy = function (t) {
        var i = this;
        i.autoPlayClear(), i.touchObject = {}, i.cleanUpEvents(), e(".slick-cloned", i.$slider).detach(), i.$dots && i.$dots.remove(), i.$prevArrow && i.$prevArrow.length && (i.$prevArrow.removeClass("slick-disabled slick-arrow slick-hidden").removeAttr("aria-hidden aria-disabled tabindex").css("display", ""), i.htmlExpr.test(i.options.prevArrow) && i.$prevArrow.remove()), i.$nextArrow && i.$nextArrow.length && (i.$nextArrow.removeClass("slick-disabled slick-arrow slick-hidden").removeAttr("aria-hidden aria-disabled tabindex").css("display", ""), i.htmlExpr.test(i.options.nextArrow) && i.$nextArrow.remove()), i.$slides && (i.$slides.removeClass("slick-slide slick-active slick-center slick-visible slick-current").removeAttr("aria-hidden").removeAttr("data-slick-index").each(function () {
            e(this).attr("style", e(this).data("originalStyling"))
        }), i.$slideTrack.children(this.options.slide).detach(), i.$slideTrack.detach(), i.$list.detach(), i.$slider.append(i.$slides)), i.cleanUpRows(), i.$slider.removeClass("slick-slider"), i.$slider.removeClass("slick-initialized"), i.unslicked = !0, t || i.$slider.trigger("destroy", [i])
    }, t.prototype.disableTransition = function (e) {
        var t = this,
            i = {};
        i[t.transitionType] = "", t.options.fade === !1 ? t.$slideTrack.css(i) : t.$slides.eq(e).css(i)
    }, t.prototype.fadeSlide = function (e, t) {
        var i = this;
        i.cssTransitions === !1 ? (i.$slides.eq(e).css({
            zIndex: i.options.zIndex
        }), i.$slides.eq(e).animate({
            opacity: 1
        }, i.options.speed, i.options.easing, t)) : (i.applyTransition(e), i.$slides.eq(e).css({
            opacity: 1,
            zIndex: i.options.zIndex
        }), t && setTimeout(function () {
            i.disableTransition(e), t.call()
        }, i.options.speed))
    }, t.prototype.fadeSlideOut = function (e) {
        var t = this;
        t.cssTransitions === !1 ? t.$slides.eq(e).animate({
            opacity: 0,
            zIndex: t.options.zIndex - 2
        }, t.options.speed, t.options.easing) : (t.applyTransition(e), t.$slides.eq(e).css({
            opacity: 0,
            zIndex: t.options.zIndex - 2
        }))
    }, t.prototype.filterSlides = t.prototype.slickFilter = function (e) {
        var t = this;
        null !== e && (t.$slidesCache = t.$slides, t.unload(), t.$slideTrack.children(this.options.slide).detach(), t.$slidesCache.filter(e).appendTo(t.$slideTrack), t.reinit())
    }, t.prototype.getCurrent = t.prototype.slickCurrentSlide = function () {
        var e = this;
        return e.currentSlide
    }, t.prototype.getDotCount = function () {
        var e = this,
            t = 0,
            i = 0,
            n = 0;
        if (e.options.infinite === !0)
            for (; t < e.slideCount;) ++n, t = i + e.options.slidesToScroll, i += e.options.slidesToScroll <= e.options.slidesToShow ? e.options.slidesToScroll : e.options.slidesToShow;
        else if (e.options.centerMode === !0) n = e.slideCount;
        else
            for (; t < e.slideCount;) ++n, t = i + e.options.slidesToScroll, i += e.options.slidesToScroll <= e.options.slidesToShow ? e.options.slidesToScroll : e.options.slidesToShow;
        return n - 1
    }, t.prototype.getLeft = function (e) {
        var t, i, n, o = this,
            s = 0;
        return o.slideOffset = 0, i = o.$slides.first().outerHeight(!0), o.options.infinite === !0 ? (o.slideCount > o.options.slidesToShow && (o.slideOffset = o.slideWidth * o.options.slidesToShow * -1, s = i * o.options.slidesToShow * -1), o.slideCount % o.options.slidesToScroll !== 0 && e + o.options.slidesToScroll > o.slideCount && o.slideCount > o.options.slidesToShow && (e > o.slideCount ? (o.slideOffset = (o.options.slidesToShow - (e - o.slideCount)) * o.slideWidth * -1, s = (o.options.slidesToShow - (e - o.slideCount)) * i * -1) : (o.slideOffset = o.slideCount % o.options.slidesToScroll * o.slideWidth * -1, s = o.slideCount % o.options.slidesToScroll * i * -1))) : e + o.options.slidesToShow > o.slideCount && (o.slideOffset = (e + o.options.slidesToShow - o.slideCount) * o.slideWidth, s = (e + o.options.slidesToShow - o.slideCount) * i), o.slideCount <= o.options.slidesToShow && (o.slideOffset = 0, s = 0), o.options.centerMode === !0 && o.options.infinite === !0 ? o.slideOffset += o.slideWidth * Math.floor(o.options.slidesToShow / 2) - o.slideWidth : o.options.centerMode === !0 && (o.slideOffset = 0, o.slideOffset += o.slideWidth * Math.floor(o.options.slidesToShow / 2)), t = o.options.vertical === !1 ? e * o.slideWidth * -1 + o.slideOffset : e * i * -1 + s, o.options.variableWidth === !0 && (n = o.slideCount <= o.options.slidesToShow || o.options.infinite === !1 ? o.$slideTrack.children(".slick-slide").eq(e) : o.$slideTrack.children(".slick-slide").eq(e + o.options.slidesToShow), t = o.options.rtl === !0 ? n[0] ? -1 * (o.$slideTrack.width() - n[0].offsetLeft - n.width()) : 0 : n[0] ? -1 * n[0].offsetLeft : 0, o.options.centerMode === !0 && (n = o.slideCount <= o.options.slidesToShow || o.options.infinite === !1 ? o.$slideTrack.children(".slick-slide").eq(e) : o.$slideTrack.children(".slick-slide").eq(e + o.options.slidesToShow + 1), t = o.options.rtl === !0 ? n[0] ? -1 * (o.$slideTrack.width() - n[0].offsetLeft - n.width()) : 0 : n[0] ? -1 * n[0].offsetLeft : 0,
            t += (o.$list.width() - n.outerWidth()) / 2)), t
    }, t.prototype.getOption = t.prototype.slickGetOption = function (e) {
        var t = this;
        return t.options[e]
    }, t.prototype.getNavigableIndexes = function () {
        var e, t = this,
            i = 0,
            n = 0,
            o = [];
        for (t.options.infinite === !1 ? e = t.slideCount : (i = -1 * t.options.slidesToScroll, n = -1 * t.options.slidesToScroll, e = 2 * t.slideCount); e > i;) o.push(i), i = n + t.options.slidesToScroll, n += t.options.slidesToScroll <= t.options.slidesToShow ? t.options.slidesToScroll : t.options.slidesToShow;
        return o
    }, t.prototype.getSlick = function () {
        return this
    }, t.prototype.getSlideCount = function () {
        var t, i, n, o = this;
        return n = o.options.centerMode === !0 ? o.slideWidth * Math.floor(o.options.slidesToShow / 2) : 0, o.options.swipeToSlide === !0 ? (o.$slideTrack.find(".slick-slide").each(function (t, s) {
            return s.offsetLeft - n + e(s).outerWidth() / 2 > -1 * o.swipeLeft ? (i = s, !1) : void 0
        }), t = Math.abs(e(i).attr("data-slick-index") - o.currentSlide) || 1) : o.options.slidesToScroll
    }, t.prototype.goTo = t.prototype.slickGoTo = function (e, t) {
        var i = this;
        i.changeSlide({
            data: {
                message: "index",
                index: parseInt(e)
            }
        }, t)
    }, t.prototype.init = function (t) {
        var i = this;
        e(i.$slider).hasClass("slick-initialized") || (e(i.$slider).addClass("slick-initialized"), i.buildRows(), i.buildOut(), i.setProps(), i.startLoad(), i.loadSlider(), i.initializeEvents(), i.updateArrows(), i.updateDots()), t && i.$slider.trigger("init", [i]), i.options.accessibility === !0 && i.initADA()
    }, t.prototype.initArrowEvents = function () {
        var e = this;
        e.options.arrows === !0 && e.slideCount > e.options.slidesToShow && (e.$prevArrow.on("click.slick", {
            message: "previous"
        }, e.changeSlide), e.$nextArrow.on("click.slick", {
            message: "next"
        }, e.changeSlide))
    }, t.prototype.initDotEvents = function () {
        var t = this;
        t.options.dots === !0 && t.slideCount > t.options.slidesToShow && e("li", t.$dots).on("click.slick", {
            message: "index"
        }, t.changeSlide), t.options.dots === !0 && t.options.pauseOnDotsHover === !0 && t.options.autoplay === !0 && e("li", t.$dots).on("mouseenter.slick", e.proxy(t.setPaused, t, !0)).on("mouseleave.slick", e.proxy(t.setPaused, t, !1))
    }, t.prototype.initializeEvents = function () {
        var t = this;
        t.initArrowEvents(), t.initDotEvents(), t.$list.on("touchstart.slick mousedown.slick", {
            action: "start"
        }, t.swipeHandler), t.$list.on("touchmove.slick mousemove.slick", {
            action: "move"
        }, t.swipeHandler), t.$list.on("touchend.slick mouseup.slick", {
            action: "end"
        }, t.swipeHandler), t.$list.on("touchcancel.slick mouseleave.slick", {
            action: "end"
        }, t.swipeHandler), t.$list.on("click.slick", t.clickHandler), e(document).on(t.visibilityChange, e.proxy(t.visibility, t)), t.$list.on("mouseenter.slick", e.proxy(t.setPaused, t, !0)), t.$list.on("mouseleave.slick", e.proxy(t.setPaused, t, !1)), t.options.accessibility === !0 && t.$list.on("keydown.slick", t.keyHandler), t.options.focusOnSelect === !0 && e(t.$slideTrack).children().on("click.slick", t.selectHandler), e(window).on("orientationchange.slick.slick-" + t.instanceUid, e.proxy(t.orientationChange, t)), e(window).on("resize.slick.slick-" + t.instanceUid, e.proxy(t.resize, t)), e("[draggable!=true]", t.$slideTrack).on("dragstart", t.preventDefault), e(window).on("load.slick.slick-" + t.instanceUid, t.setPosition), e(document).on("ready.slick.slick-" + t.instanceUid, t.setPosition)
    }, t.prototype.initUI = function () {
        var e = this;
        e.options.arrows === !0 && e.slideCount > e.options.slidesToShow && (e.$prevArrow.show(), e.$nextArrow.show()), e.options.dots === !0 && e.slideCount > e.options.slidesToShow && e.$dots.show(), e.options.autoplay === !0 && e.autoPlay()
    }, t.prototype.keyHandler = function (e) {
        var t = this;
        e.target.tagName.match("TEXTAREA|INPUT|SELECT") || (37 === e.keyCode && t.options.accessibility === !0 ? t.changeSlide({
            data: {
                message: "previous"
            }
        }) : 39 === e.keyCode && t.options.accessibility === !0 && t.changeSlide({
            data: {
                message: "next"
            }
        }))
    }, t.prototype.lazyLoad = function () {
        function t(t) {
            e("img[data-lazy]", t).each(function () {
                var t = e(this),
                    i = e(this).attr("data-lazy"),
                    n = document.createElement("img");
                n.onload = function () {
                    t.animate({
                        opacity: 0
                    }, 100, function () {
                        t.attr("src", i).animate({
                            opacity: 1
                        }, 200, function () {
                            t.removeAttr("data-lazy").removeClass("slick-loading")
                        })
                    })
                }, n.src = i
            })
        }
        var i, n, o, s, r = this;
        r.options.centerMode === !0 ? r.options.infinite === !0 ? (o = r.currentSlide + (r.options.slidesToShow / 2 + 1), s = o + r.options.slidesToShow + 2) : (o = Math.max(0, r.currentSlide - (r.options.slidesToShow / 2 + 1)), s = 2 + (r.options.slidesToShow / 2 + 1) + r.currentSlide) : (o = r.options.infinite ? r.options.slidesToShow + r.currentSlide : r.currentSlide, s = o + r.options.slidesToShow, r.options.fade === !0 && (o > 0 && o--, s <= r.slideCount && s++)), i = r.$slider.find(".slick-slide").slice(o, s), t(i), r.slideCount <= r.options.slidesToShow ? (n = r.$slider.find(".slick-slide"), t(n)) : r.currentSlide >= r.slideCount - r.options.slidesToShow ? (n = r.$slider.find(".slick-cloned").slice(0, r.options.slidesToShow), t(n)) : 0 === r.currentSlide && (n = r.$slider.find(".slick-cloned").slice(-1 * r.options.slidesToShow), t(n))
    }, t.prototype.loadSlider = function () {
        var e = this;
        e.setPosition(), e.$slideTrack.css({
            opacity: 1
        }), e.$slider.removeClass("slick-loading"), e.initUI(), "progressive" === e.options.lazyLoad && e.progressiveLazyLoad()
    }, t.prototype.next = t.prototype.slickNext = function () {
        var e = this;
        e.changeSlide({
            data: {
                message: "next"
            }
        })
    }, t.prototype.orientationChange = function () {
        var e = this;
        e.checkResponsive(), e.setPosition()
    }, t.prototype.pause = t.prototype.slickPause = function () {
        var e = this;
        e.autoPlayClear(), e.paused = !0
    }, t.prototype.play = t.prototype.slickPlay = function () {
        var e = this;
        e.paused = !1, e.autoPlay()
    }, t.prototype.postSlide = function (e) {
        var t = this;
        t.$slider.trigger("afterChange", [t, e]), t.animating = !1, t.setPosition(), t.swipeLeft = null, t.options.autoplay === !0 && t.paused === !1 && t.autoPlay(), t.options.accessibility === !0 && t.initADA()
    }, t.prototype.prev = t.prototype.slickPrev = function () {
        var e = this;
        e.changeSlide({
            data: {
                message: "previous"
            }
        })
    }, t.prototype.preventDefault = function (e) {
        e.preventDefault()
    }, t.prototype.progressiveLazyLoad = function () {
        var t, i, n = this;
        t = e("img[data-lazy]", n.$slider).length, t > 0 && (i = e("img[data-lazy]", n.$slider).first(), i.attr("src", null), i.attr("src", i.attr("data-lazy")).removeClass("slick-loading").load(function () {
            i.removeAttr("data-lazy"), n.progressiveLazyLoad(), n.options.adaptiveHeight === !0 && n.setPosition()
        }).error(function () {
            i.removeAttr("data-lazy"), n.progressiveLazyLoad()
        }))
    }, t.prototype.refresh = function (t) {
        var i, n, o = this;
        n = o.slideCount - o.options.slidesToShow, o.options.infinite || (o.slideCount <= o.options.slidesToShow ? o.currentSlide = 0 : o.currentSlide > n && (o.currentSlide = n)), i = o.currentSlide, o.destroy(!0), e.extend(o, o.initials, {
            currentSlide: i
        }), o.init(), t || o.changeSlide({
            data: {
                message: "index",
                index: i
            }
        }, !1)
    }, t.prototype.registerBreakpoints = function () {
        var t, i, n, o = this,
            s = o.options.responsive || null;
        if ("array" === e.type(s) && s.length) {
            o.respondTo = o.options.respondTo || "window";
            for (t in s)
                if (n = o.breakpoints.length - 1, i = s[t].breakpoint, s.hasOwnProperty(t)) {
                    for (; n >= 0;) o.breakpoints[n] && o.breakpoints[n] === i && o.breakpoints.splice(n, 1), n--;
                    o.breakpoints.push(i), o.breakpointSettings[i] = s[t].settings
                }
            o.breakpoints.sort(function (e, t) {
                return o.options.mobileFirst ? e - t : t - e
            })
        }
    }, t.prototype.reinit = function () {
        var t = this;
        t.$slides = t.$slideTrack.children(t.options.slide).addClass("slick-slide"), t.slideCount = t.$slides.length, t.currentSlide >= t.slideCount && 0 !== t.currentSlide && (t.currentSlide = t.currentSlide - t.options.slidesToScroll), t.slideCount <= t.options.slidesToShow && (t.currentSlide = 0), t.registerBreakpoints(), t.setProps(), t.setupInfinite(), t.buildArrows(), t.updateArrows(), t.initArrowEvents(), t.buildDots(), t.updateDots(), t.initDotEvents(), t.checkResponsive(!1, !0), t.options.focusOnSelect === !0 && e(t.$slideTrack).children().on("click.slick", t.selectHandler), t.setSlideClasses(0), t.setPosition(), t.$slider.trigger("reInit", [t]), t.options.autoplay === !0 && t.focusHandler()
    }, t.prototype.resize = function () {
        var t = this;
        e(window).width() !== t.windowWidth && (clearTimeout(t.windowDelay), t.windowDelay = window.setTimeout(function () {
            t.windowWidth = e(window).width(), t.checkResponsive(), t.unslicked || t.setPosition()
        }, 50))
    }, t.prototype.removeSlide = t.prototype.slickRemove = function (e, t, i) {
        var n = this;
        return "boolean" == typeof e ? (t = e, e = t === !0 ? 0 : n.slideCount - 1) : e = t === !0 ? --e : e, n.slideCount < 1 || 0 > e || e > n.slideCount - 1 ? !1 : (n.unload(), i === !0 ? n.$slideTrack.children().remove() : n.$slideTrack.children(this.options.slide).eq(e).remove(), n.$slides = n.$slideTrack.children(this.options.slide), n.$slideTrack.children(this.options.slide).detach(), n.$slideTrack.append(n.$slides), n.$slidesCache = n.$slides, void n.reinit())
    }, t.prototype.setCSS = function (e) {
        var t, i, n = this,
            o = {};
        n.options.rtl === !0 && (e = -e), t = "left" == n.positionProp ? Math.ceil(e) + "px" : "0px", i = "top" == n.positionProp ? Math.ceil(e) + "px" : "0px", o[n.positionProp] = e, n.transformsEnabled === !1 ? n.$slideTrack.css(o) : (o = {}, n.cssTransitions === !1 ? (o[n.animType] = "translate(" + t + ", " + i + ")", n.$slideTrack.css(o)) : (o[n.animType] = "translate3d(" + t + ", " + i + ", 0px)", n.$slideTrack.css(o)))
    }, t.prototype.setDimensions = function () {
        var e = this;
        e.options.vertical === !1 ? e.options.centerMode === !0 && e.$list.css({
            padding: "0px " + e.options.centerPadding
        }) : (e.$list.height(e.$slides.first().outerHeight(!0) * e.options.slidesToShow), e.options.centerMode === !0 && e.$list.css({
            padding: e.options.centerPadding + " 0px"
        })), e.listWidth = e.$list.width(), e.listHeight = e.$list.height(), e.options.vertical === !1 && e.options.variableWidth === !1 ? (e.slideWidth = Math.ceil(e.listWidth / e.options.slidesToShow), e.$slideTrack.width(Math.ceil(e.slideWidth * e.$slideTrack.children(".slick-slide").length))) : e.options.variableWidth === !0 ? e.$slideTrack.width(5e3 * e.slideCount) : (e.slideWidth = Math.ceil(e.listWidth), e.$slideTrack.height(Math.ceil(e.$slides.first().outerHeight(!0) * e.$slideTrack.children(".slick-slide").length)));
        var t = e.$slides.first().outerWidth(!0) - e.$slides.first().width();
        e.options.variableWidth === !1 && e.$slideTrack.children(".slick-slide").width(e.slideWidth - t)
    }, t.prototype.setFade = function () {
        var t, i = this;
        i.$slides.each(function (n, o) {
            t = i.slideWidth * n * -1, i.options.rtl === !0 ? e(o).css({
                position: "relative",
                right: t,
                top: 0,
                zIndex: i.options.zIndex - 2,
                opacity: 0
            }) : e(o).css({
                position: "relative",
                left: t,
                top: 0,
                zIndex: i.options.zIndex - 2,
                opacity: 0
            })
        }), i.$slides.eq(i.currentSlide).css({
            zIndex: i.options.zIndex - 1,
            opacity: 1
        })
    }, t.prototype.setHeight = function () {
        var e = this;
        if (1 === e.options.slidesToShow && e.options.adaptiveHeight === !0 && e.options.vertical === !1) {
            var t = e.$slides.eq(e.currentSlide).outerHeight(!0);
            e.$list.css("height", t)
        }
    }, t.prototype.setOption = t.prototype.slickSetOption = function (t, i, n) {
        var o, s, r = this;
        if ("responsive" === t && "array" === e.type(i))
            for (s in i)
                if ("array" !== e.type(r.options.responsive)) r.options.responsive = [i[s]];
                else {
                    for (o = r.options.responsive.length - 1; o >= 0;) r.options.responsive[o].breakpoint === i[s].breakpoint && r.options.responsive.splice(o, 1), o--;
                    r.options.responsive.push(i[s])
                }
        else r.options[t] = i;
        n === !0 && (r.unload(), r.reinit())
    }, t.prototype.setPosition = function () {
        var e = this;
        e.setDimensions(), e.setHeight(), e.options.fade === !1 ? e.setCSS(e.getLeft(e.currentSlide)) : e.setFade(), e.$slider.trigger("setPosition", [e])
    }, t.prototype.setProps = function () {
        var e = this,
            t = document.body.style;
        e.positionProp = e.options.vertical === !0 ? "top" : "left", "top" === e.positionProp ? e.$slider.addClass("slick-vertical") : e.$slider.removeClass("slick-vertical"), (void 0 !== t.WebkitTransition || void 0 !== t.MozTransition || void 0 !== t.msTransition) && e.options.useCSS === !0 && (e.cssTransitions = !0), e.options.fade && ("number" == typeof e.options.zIndex ? e.options.zIndex < 3 && (e.options.zIndex = 3) : e.options.zIndex = e.defaults.zIndex), void 0 !== t.OTransform && (e.animType = "OTransform", e.transformType = "-o-transform", e.transitionType = "OTransition", void 0 === t.perspectiveProperty && void 0 === t.webkitPerspective && (e.animType = !1)), void 0 !== t.MozTransform && (e.animType = "MozTransform", e.transformType = "-moz-transform", e.transitionType = "MozTransition", void 0 === t.perspectiveProperty && void 0 === t.MozPerspective && (e.animType = !1)), void 0 !== t.webkitTransform && (e.animType = "webkitTransform", e.transformType = "-webkit-transform", e.transitionType = "webkitTransition", void 0 === t.perspectiveProperty && void 0 === t.webkitPerspective && (e.animType = !1)), void 0 !== t.msTransform && (e.animType = "msTransform", e.transformType = "-ms-transform", e.transitionType = "msTransition", void 0 === t.msTransform && (e.animType = !1)), void 0 !== t.transform && e.animType !== !1 && (e.animType = "transform", e.transformType = "transform", e.transitionType = "transition"), e.transformsEnabled = e.options.useTransform && null !== e.animType && e.animType !== !1
    }, t.prototype.setSlideClasses = function (e) {
        var t, i, n, o, s = this;
        i = s.$slider.find(".slick-slide").removeClass("slick-active slick-center slick-current").attr("aria-hidden", "true"), s.$slides.eq(e).addClass("slick-current"), s.options.centerMode === !0 ? (t = Math.floor(s.options.slidesToShow / 2), s.options.infinite === !0 && (e >= t && e <= s.slideCount - 1 - t ? s.$slides.slice(e - t, e + t + 1).addClass("slick-active").attr("aria-hidden", "false") : (n = s.options.slidesToShow + e, i.slice(n - t + 1, n + t + 2).addClass("slick-active").attr("aria-hidden", "false")), 0 === e ? i.eq(i.length - 1 - s.options.slidesToShow).addClass("slick-center") : e === s.slideCount - 1 && i.eq(s.options.slidesToShow).addClass("slick-center")), s.$slides.eq(e).addClass("slick-center")) : e >= 0 && e <= s.slideCount - s.options.slidesToShow ? s.$slides.slice(e, e + s.options.slidesToShow).addClass("slick-active").attr("aria-hidden", "false") : i.length <= s.options.slidesToShow ? i.addClass("slick-active").attr("aria-hidden", "false") : (o = s.slideCount % s.options.slidesToShow, n = s.options.infinite === !0 ? s.options.slidesToShow + e : e, s.options.slidesToShow == s.options.slidesToScroll && s.slideCount - e < s.options.slidesToShow ? i.slice(n - (s.options.slidesToShow - o), n + o).addClass("slick-active").attr("aria-hidden", "false") : i.slice(n, n + s.options.slidesToShow).addClass("slick-active").attr("aria-hidden", "false")), "ondemand" === s.options.lazyLoad && s.lazyLoad()
    }, t.prototype.setupInfinite = function () {
        var t, i, n, o = this;
        if (o.options.fade === !0 && (o.options.centerMode = !1), o.options.infinite === !0 && o.options.fade === !1 && (i = null, o.slideCount > o.options.slidesToShow)) {
            for (n = o.options.centerMode === !0 ? o.options.slidesToShow + 1 : o.options.slidesToShow, t = o.slideCount; t > o.slideCount - n; t -= 1) i = t - 1, e(o.$slides[i]).clone(!0).attr("id", "").attr("data-slick-index", i - o.slideCount).prependTo(o.$slideTrack).addClass("slick-cloned");
            for (t = 0; n > t; t += 1) i = t, e(o.$slides[i]).clone(!0).attr("id", "").attr("data-slick-index", i + o.slideCount).appendTo(o.$slideTrack).addClass("slick-cloned");
            o.$slideTrack.find(".slick-cloned").find("[id]").each(function () {
                e(this).attr("id", "")
            })
        }
    }, t.prototype.setPaused = function (e) {
        var t = this;
        t.options.autoplay === !0 && t.options.pauseOnHover === !0 && (t.paused = e, e ? t.autoPlayClear() : t.autoPlay())
    }, t.prototype.selectHandler = function (t) {
        var i = this,
            n = e(t.target).is(".slick-slide") ? e(t.target) : e(t.target).parents(".slick-slide"),
            o = parseInt(n.attr("data-slick-index"));
        return o || (o = 0), i.slideCount <= i.options.slidesToShow ? (i.setSlideClasses(o), void i.asNavFor(o)) : void i.slideHandler(o)
    }, t.prototype.slideHandler = function (e, t, i) {
        var n, o, s, r, a = null,
            l = this;
        return t = t || !1, l.animating === !0 && l.options.waitForAnimate === !0 || l.options.fade === !0 && l.currentSlide === e || l.slideCount <= l.options.slidesToShow ? void 0 : (t === !1 && l.asNavFor(e), n = e, a = l.getLeft(n), r = l.getLeft(l.currentSlide), l.currentLeft = null === l.swipeLeft ? r : l.swipeLeft, l.options.infinite === !1 && l.options.centerMode === !1 && (0 > e || e > l.getDotCount() * l.options.slidesToScroll) ? void(l.options.fade === !1 && (n = l.currentSlide, i !== !0 ? l.animateSlide(r, function () {
            l.postSlide(n)
        }) : l.postSlide(n))) : l.options.infinite === !1 && l.options.centerMode === !0 && (0 > e || e > l.slideCount - l.options.slidesToScroll) ? void(l.options.fade === !1 && (n = l.currentSlide, i !== !0 ? l.animateSlide(r, function () {
            l.postSlide(n)
        }) : l.postSlide(n))) : (l.options.autoplay === !0 && clearInterval(l.autoPlayTimer), o = 0 > n ? l.slideCount % l.options.slidesToScroll !== 0 ? l.slideCount - l.slideCount % l.options.slidesToScroll : l.slideCount + n : n >= l.slideCount ? l.slideCount % l.options.slidesToScroll !== 0 ? 0 : n - l.slideCount : n, l.animating = !0, l.$slider.trigger("beforeChange", [l, l.currentSlide, o]), s = l.currentSlide, l.currentSlide = o, l.setSlideClasses(l.currentSlide), l.updateDots(), l.updateArrows(), l.options.fade === !0 ? (i !== !0 ? (l.fadeSlideOut(s), l.fadeSlide(o, function () {
            l.postSlide(o)
        })) : l.postSlide(o), void l.animateHeight()) : void(i !== !0 ? l.animateSlide(a, function () {
            l.postSlide(o)
        }) : l.postSlide(o))))
    }, t.prototype.startLoad = function () {
        var e = this;
        e.options.arrows === !0 && e.slideCount > e.options.slidesToShow && (e.$prevArrow.hide(), e.$nextArrow.hide()), e.options.dots === !0 && e.slideCount > e.options.slidesToShow && e.$dots.hide(), e.$slider.addClass("slick-loading")
    }, t.prototype.swipeDirection = function () {
        var e, t, i, n, o = this;
        return e = o.touchObject.startX - o.touchObject.curX, t = o.touchObject.startY - o.touchObject.curY, i = Math.atan2(t, e), n = Math.round(180 * i / Math.PI), 0 > n && (n = 360 - Math.abs(n)), 45 >= n && n >= 0 ? o.options.rtl === !1 ? "left" : "right" : 360 >= n && n >= 315 ? o.options.rtl === !1 ? "left" : "right" : n >= 135 && 225 >= n ? o.options.rtl === !1 ? "right" : "left" : o.options.verticalSwiping === !0 ? n >= 35 && 135 >= n ? "left" : "right" : "vertical"
    }, t.prototype.swipeEnd = function (e) {
        var t, i = this;
        if (i.dragging = !1, i.shouldClick = i.touchObject.swipeLength > 10 ? !1 : !0, void 0 === i.touchObject.curX) return !1;
        if (i.touchObject.edgeHit === !0 && i.$slider.trigger("edge", [i, i.swipeDirection()]), i.touchObject.swipeLength >= i.touchObject.minSwipe) switch (i.swipeDirection()) {
            case "left":
                t = i.options.swipeToSlide ? i.checkNavigable(i.currentSlide + i.getSlideCount()) : i.currentSlide + i.getSlideCount(), i.slideHandler(t), i.currentDirection = 0, i.touchObject = {}, i.$slider.trigger("swipe", [i, "left"]);
                break;
            case "right":
                t = i.options.swipeToSlide ? i.checkNavigable(i.currentSlide - i.getSlideCount()) : i.currentSlide - i.getSlideCount(), i.slideHandler(t), i.currentDirection = 1, i.touchObject = {}, i.$slider.trigger("swipe", [i, "right"])
        } else i.touchObject.startX !== i.touchObject.curX && (i.slideHandler(i.currentSlide), i.touchObject = {})
    }, t.prototype.swipeHandler = function (e) {
        var t = this;
        if (!(t.options.swipe === !1 || "ontouchend" in document && t.options.swipe === !1 || t.options.draggable === !1 && -1 !== e.type.indexOf("mouse"))) switch (t.touchObject.fingerCount = e.originalEvent && void 0 !== e.originalEvent.touches ? e.originalEvent.touches.length : 1, t.touchObject.minSwipe = t.listWidth / t.options.touchThreshold, t.options.verticalSwiping === !0 && (t.touchObject.minSwipe = t.listHeight / t.options.touchThreshold), e.data.action) {
            case "start":
                t.swipeStart(e);
                break;
            case "move":
                t.swipeMove(e);
                break;
            case "end":
                t.swipeEnd(e)
        }
    }, t.prototype.swipeMove = function (e) {
        var t, i, n, o, s, r = this;
        return s = void 0 !== e.originalEvent ? e.originalEvent.touches : null, !r.dragging || s && 1 !== s.length ? !1 : (t = r.getLeft(r.currentSlide), r.touchObject.curX = void 0 !== s ? s[0].pageX : e.clientX, r.touchObject.curY = void 0 !== s ? s[0].pageY : e.clientY, r.touchObject.swipeLength = Math.round(Math.sqrt(Math.pow(r.touchObject.curX - r.touchObject.startX, 2))), r.options.verticalSwiping === !0 && (r.touchObject.swipeLength = Math.round(Math.sqrt(Math.pow(r.touchObject.curY - r.touchObject.startY, 2)))), i = r.swipeDirection(), "vertical" !== i ? (void 0 !== e.originalEvent && r.touchObject.swipeLength > 4 && e.preventDefault(), o = (r.options.rtl === !1 ? 1 : -1) * (r.touchObject.curX > r.touchObject.startX ? 1 : -1), r.options.verticalSwiping === !0 && (o = r.touchObject.curY > r.touchObject.startY ? 1 : -1), n = r.touchObject.swipeLength, r.touchObject.edgeHit = !1, r.options.infinite === !1 && (0 === r.currentSlide && "right" === i || r.currentSlide >= r.getDotCount() && "left" === i) && (n = r.touchObject.swipeLength * r.options.edgeFriction, r.touchObject.edgeHit = !0), r.options.vertical === !1 ? r.swipeLeft = t + n * o : r.swipeLeft = t + n * (r.$list.height() / r.listWidth) * o, r.options.verticalSwiping === !0 && (r.swipeLeft = t + n * o), r.options.fade === !0 || r.options.touchMove === !1 ? !1 : r.animating === !0 ? (r.swipeLeft = null, !1) : void r.setCSS(r.swipeLeft)) : void 0)
    }, t.prototype.swipeStart = function (e) {
        var t, i = this;
        return 1 !== i.touchObject.fingerCount || i.slideCount <= i.options.slidesToShow ? (i.touchObject = {}, !1) : (void 0 !== e.originalEvent && void 0 !== e.originalEvent.touches && (t = e.originalEvent.touches[0]), i.touchObject.startX = i.touchObject.curX = void 0 !== t ? t.pageX : e.clientX, i.touchObject.startY = i.touchObject.curY = void 0 !== t ? t.pageY : e.clientY, void(i.dragging = !0))
    }, t.prototype.unfilterSlides = t.prototype.slickUnfilter = function () {
        var e = this;
        null !== e.$slidesCache && (e.unload(), e.$slideTrack.children(this.options.slide).detach(), e.$slidesCache.appendTo(e.$slideTrack), e.reinit())
    }, t.prototype.unload = function () {
        var t = this;
        e(".slick-cloned", t.$slider).remove(), t.$dots && t.$dots.remove(), t.$prevArrow && t.htmlExpr.test(t.options.prevArrow) && t.$prevArrow.remove(), t.$nextArrow && t.htmlExpr.test(t.options.nextArrow) && t.$nextArrow.remove(), t.$slides.removeClass("slick-slide slick-active slick-visible slick-current").attr("aria-hidden", "true").css("width", "")
    }, t.prototype.unslick = function (e) {
        var t = this;
        t.$slider.trigger("unslick", [t, e]), t.destroy()
    }, t.prototype.updateArrows = function () {
        var e, t = this;
        e = Math.floor(t.options.slidesToShow / 2), t.options.arrows === !0 && t.slideCount > t.options.slidesToShow && !t.options.infinite && (t.$prevArrow.removeClass("slick-disabled").attr("aria-disabled", "false"), t.$nextArrow.removeClass("slick-disabled").attr("aria-disabled", "false"), 0 === t.currentSlide ? (t.$prevArrow.addClass("slick-disabled").attr("aria-disabled", "true"), t.$nextArrow.removeClass("slick-disabled").attr("aria-disabled", "false")) : t.currentSlide >= t.slideCount - t.options.slidesToShow && t.options.centerMode === !1 ? (t.$nextArrow.addClass("slick-disabled").attr("aria-disabled", "true"), t.$prevArrow.removeClass("slick-disabled").attr("aria-disabled", "false")) : t.currentSlide >= t.slideCount - 1 && t.options.centerMode === !0 && (t.$nextArrow.addClass("slick-disabled").attr("aria-disabled", "true"), t.$prevArrow.removeClass("slick-disabled").attr("aria-disabled", "false")))
    }, t.prototype.updateDots = function () {
        var e = this;
        null !== e.$dots && (e.$dots.find("li").removeClass("slick-active").attr("aria-hidden", "true"), e.$dots.find("li").eq(Math.floor(e.currentSlide / e.options.slidesToScroll)).addClass("slick-active").attr("aria-hidden", "false"))
    }, t.prototype.visibility = function () {
        var e = this;
        document[e.hidden] ? (e.paused = !0, e.autoPlayClear()) : e.options.autoplay === !0 && (e.paused = !1, e.autoPlay())
    }, t.prototype.initADA = function () {
        var t = this;
        t.$slides.add(t.$slideTrack.find(".slick-cloned")).attr({
            "aria-hidden": "true",
            tabindex: "-1"
        }).find("a, input, button, select").attr({
            tabindex: "-1"
        }), t.$slideTrack.attr("role", "listbox"), t.$slides.not(t.$slideTrack.find(".slick-cloned")).each(function (i) {
            e(this).attr({
                role: "option",
                "aria-describedby": "slick-slide" + t.instanceUid + i
            })
        }), null !== t.$dots && t.$dots.attr("role", "tablist").find("li").each(function (i) {
            e(this).attr({
                role: "presentation",
                "aria-selected": "false",
                "aria-controls": "navigation" + t.instanceUid + i,
                id: "slick-slide" + t.instanceUid + i
            })
        }).first().attr("aria-selected", "true").end().find("button").attr("role", "button").end().closest("div").attr("role", "toolbar"), t.activateADA()
    }, t.prototype.activateADA = function () {
        var e = this;
        e.$slideTrack.find(".slick-active").attr({
            "aria-hidden": "false"
        }).find("a, input, button, select").attr({
            tabindex: "0"
        })
    }, t.prototype.focusHandler = function () {
        var t = this;
        t.$slider.on("focus.slick blur.slick", "*", function (i) {
            i.stopImmediatePropagation();
            var n = e(this);
            setTimeout(function () {
                t.isPlay && (n.is(":focus") ? (t.autoPlayClear(), t.paused = !0) : (t.paused = !1, t.autoPlay()))
            }, 0)
        })
    }, e.fn.slick = function () {
        var e, i, n = this,
            o = arguments[0],
            s = Array.prototype.slice.call(arguments, 1),
            r = n.length;
        for (e = 0; r > e; e++)
            if ("object" == typeof o || "undefined" == typeof o ? n[e].slick = new t(n[e], o) : i = n[e].slick[o].apply(n[e].slick, s), "undefined" != typeof i) return i;
        return n
    }
});
var isMobile = {
        Android: function () {
            return navigator.userAgent.match(/Android/i) && navigator.userAgent.match(/Mobile/i)
        },
        BlackBerry: function () {
            return navigator.userAgent.match(/BlackBerry/i)
        },
        iOS: function () {
            return navigator.userAgent.match(/iPhone|iPod/i)
        },
        Opera: function () {
            return navigator.userAgent.match(/Opera Mini/i)
        },
        Windows: function () {
            return navigator.userAgent.match(/IEMobile/i)
        },
        any: function () {
            return isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows()
        }
    },
    sym_share = {
        addThisUserid: "ra-55ae99e6304f4e8b",
        shareButtonSelector: ".share-btn",
        init: function () {
            var e = $(".addthis_button_compact"),
                t = $(this.shareButtonSelector);
            t.on("click", function (t) {
                t.preventDefault();
                var i = "http://s7.addthis.com/js/300/addthis_widget.js#pubid=ra-55ae99e6304f4e8b";
                $.getScript(i, function () {
                    if (console.log(i), addthis) var t = 0,
                        n = window.setInterval(function () {
                            addthis.toolbox(".addthis_toolbox"), t > 50 && window.clearInterval(n), e[0].onclick && (e.trigger("click"), window.clearInterval(n)), t += 1
                        }, 300)
                })
            })
        }
    };
document.createElement("header"), document.createElement("footer"), document.createElement("section"), document.createElement("nav"),
    function (e) {
        e.fn.placeholder = function () {
            "undefined" == typeof document.createElement("input").placeholder && e("[placeholder]").focus(function () {
                var t = e(this);
                t.val() == t.attr("placeholder") && (t.val(""), t.removeClass("placeholder"))
            }).blur(function () {
                var t = e(this);
                ("" == t.val() || t.val() == t.attr("placeholder")) && (t.addClass("placeholder"), t.val(t.attr("placeholder")))
            }).blur().parents("form").submit(function () {
                e(this).find("[placeholder]").each(function () {
                    var t = e(this);
                    t.val() == t.attr("placeholder") && t.val("")
                })
            })
        }
    }(jQuery);
var _responsive = !1;
if ("undefined" != typeof responsive) var _responsive = responsive;
$(window).bind("load", function () {
    $("#loading").fadeOut(300), $("#start-content").fadeIn(1), $(document).ready(function () {
        function e(e, t, i) {
            e.addEventListener ? e.addEventListener(t, i) : e.attachEvent && e.attachEvent("on" + t, i)
        }

        function t(e) {
            e = e || window.event;
            var t = e.target || e.srcElement;
            t && t.action && ga("linker:decorate", t)
        }
        var i = !1;
        if (console.log(_responsive), $(window).resize(function () {
                $(window).width() < 768 && !i && !_responsive && (Cookies.set("forceMobile", 1, {
                    path: "/"
                }), i = !0, console.log("redirecting..."), window.location = window.location)
            }), $("#booking-form").length > 0) {
            var n = document.getElementById("booking-form");
            e(n, "submit", t)
        }
        $(".pop-book").on("click", function () {
            ga("send", "event", "popup", "click", "book now")
        }), $(".pop-web").on("click", function () {
            ga("send", "event", "popup", "click", "website")
        }), $(".fancybox").fancybox({
            padding: 0
        }), $(".fancybox_iframe").fancybox({
            type: "iframe",
            scrolling: "no",
            titleShow: !1,
            padding: 0
        }), $(".fancybox_youtube").click(function () {
            return $.fancybox({
                padding: 0,
                autoScale: !1,
                transitionIn: "none",
                transitionOut: "none",
                title: this.title,
                width: 680,
                height: 495,
                href: this.href.replace(new RegExp("watch\\?v=", "i"), "v/"),
                type: "swf",
                swf: {
                    wmode: "transparent",
                    allowfullscreen: "true"
                }
            }), !1
        }), $(".scroll").click(function () {
            var e = $(this).attr("href");
            return $("html, body").animate({
                scrollTop: $(e).offset().top - $("header").height()
            }, 1e3), !1
        }), $(".datepicker").datepicker(), setTimeout(function () {
            var e = new ScrollMagic.Controller;
            $(".animate-fade").each(function () {
                new ScrollMagic.Scene({
                    triggerElement: this.children[0],
                    triggerHook: .9
                }).setClassToggle(this, "fade-in").addTo(e)
            })
        }, 500), $("ul.blog-archive li a.year").click(function () {
            return $(this).hasClass("current") ? $(this).siblings("ul").slideUp("slow", function () {
                $(this).removeClass("current")
            }) : $(this).siblings("ul").slideToggle("slow", function () {
                $(this).toggleClass("current")
            }), !1
        }), $("#email-signup a#emailSignup").click(function () {
            var e = $("input[name=first_name_signup]"),
                t = $("input[name=last_name_signup]"),
                i = $("#email-signup input[name=email_address_signup]"),
                n = "firstname=" + e.val() + "&lastname=" + t.val() + "&email_address=" + i.val() + "&list_id=" + list_id;
            return $.ajax({
                url: FRONTEND_ROOT + "ajax/email-signup.php",
                type: "GET",
                data: n,
                cache: !1,
                success: function (e) {
                    var t = $("#customMessage").length ? $("#customMessage").val() : "";
                    t = "" == t ? "Thank you for your interest." : t + ". Thank you for your interest.", 1 == e ? ($("#email-signup #email-error").addClass("success"), $("#email-signup #email-error").html("<p>Thank you for your interest.</p>"), $("#email-signup #email-error").fadeIn("slow"), $("#email-signup input").fadeOut("slow"), $("#email-signup label").fadeOut("slow"), $("#email-signup a#emailSignup").fadeOut("slow"), setTimeout(function () {
                        $("#email-signup #email-error").fadeOut("slow")
                    }, 5e3), ga("send", "event", "form", "click", "specials")) : ($("#email-signup #email-error").html(e), $("#email-signup #email-error").fadeIn("slow"))
                }
            }), !1
        }), $(document).on("click", "#postLoadMore", function () {
            var e = $(".post").length,
                t = SITE_ROOT + "ajax/functions.php",
                i = $(this).attr("data-blog-id"),
                n = $(this).attr("data-per-page"),
                o = $(this).attr("data-params");
            return $.post(t + "?" + o, {
                offset: e,
                blogid: i,
                perpage: n,
                operation: "post_pagination"
            }, function (e) {
                "" == e ? $("#postLoadMore").fadeOut() : $("#divPosts").append(e)
            }, "html"), !1
        }), $("#booking-form").submit(function () {
            var e = [],
                t = {};
            $(".hasDatepicker", $("#booking-form")).each(function (t, i) {
                var n = $(i).val();
                e.push(n)
            }), t.operation = "process_checkout", t.checkin = e[0], t.checkout = e[1], t.device = "D", t.raw = $("#booking-form").serialize(), $.post(site_url + "ajax/functions.php", t, function (e) {}, "json")
        })
    })
});