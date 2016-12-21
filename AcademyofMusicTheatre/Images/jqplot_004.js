/**
 * jqPlot
 * Pure JavaScript plotting plugin using jQuery
 *
 * Version: 1.0.0b2_r792
 *
 * Copyright (c) 2009-2011 Chris Leonello
 * jqPlot is currently available for use in all personal or commercial projects
 * under both the MIT (http://www.opensource.org/licenses/mit-license.php) and GPL
 * version 2.0 (http://www.gnu.org/licenses/gpl-2.0.html) licenses. This means that you can
 * choose the license that best suits your project and use it accordingly.
 *
 * Although not required, the author would appreciate an email letting him
 * know of any substantial use of jqPlot.  You can reach the author at:
 * chris at jqplot dot com or see http://www.jqplot.com/info.php .
 *
 * If you are feeling kind and generous, consider supporting the project by
 * making a donation at: http://www.jqplot.com/donate.php .
 *
 * sprintf functions contained in jqplot.sprintf.js by Ash Searle:
 *
 *     version 2007.04.27
 *     author Ash Searle
 *     http://hexmen.com/blog/2007/03/printf-sprintf/
 *     http://hexmen.com/js/sprintf.js
 *     The author (Ash Searle) has placed this code in the public domain:
 *     "This code is unrestricted: you are free to use it however you like."
 *
 */
(function (d) {
    d.jqplot.BarRenderer = function () {
        d.jqplot.LineRenderer.call(this)
    };
    d.jqplot.BarRenderer.prototype = new d.jqplot.LineRenderer();
    d.jqplot.BarRenderer.prototype.constructor = d.jqplot.BarRenderer;
    d.jqplot.BarRenderer.prototype.init = function (n, p) {
        this.barPadding = 8;
        this.barMargin = 10;
        this.barDirection = "vertical";
        this.barWidth = null;
        this.shadowOffset = 2;
        this.shadowDepth = 5;
        this.shadowAlpha = 0.08;
        this.waterfall = false;
        this.groups = 1;
        this.varyBarColor = false;
        this.highlightMouseOver = true;
        this.highlightMouseDown = false;
        this.highlightColors = [];
        this._type = "bar";
        if (n.highlightMouseDown && n.highlightMouseOver == null) {
            n.highlightMouseOver = false
        }
        d.extend(true, this, n);
        this.fill = true;
        if (this.waterfall) {
            this.fillToZero = false;
            this.disableStack = true
        }
        if (this.barDirection == "vertical") {
            this._primaryAxis = "_xaxis";
            this._stackAxis = "y";
            this.fillAxis = "y"
        } else {
            this._primaryAxis = "_yaxis";
            this._stackAxis = "x";
            this.fillAxis = "x"
        }
        this._highlightedPoint = null;
        this._plotSeriesInfo = null;
        this._dataColors = [];
        this._barPoints = [];
        var o = {
            lineJoin: "miter",
            lineCap: "round",
            fill: true,
            isarc: false,
            strokeStyle: this.color,
            fillStyle: this.color,
            closePath: this.fill
        };
        this.renderer.shapeRenderer.init(o);
        var m = {
            lineJoin: "miter",
            lineCap: "round",
            fill: true,
            isarc: false,
            angle: this.shadowAngle,
            offset: this.shadowOffset,
            alpha: this.shadowAlpha,
            depth: this.shadowDepth,
            closePath: this.fill
        };
        this.renderer.shadowRenderer.init(m);
        p.postInitHooks.addOnce(h);
        p.postDrawHooks.addOnce(i);
        p.eventListenerHooks.addOnce("jqplotMouseMove", b);
        p.eventListenerHooks.addOnce("jqplotMouseDown", a);
        p.eventListenerHooks.addOnce("jqplotMouseUp", k);
        p.eventListenerHooks.addOnce("jqplotClick", e);
        p.eventListenerHooks.addOnce("jqplotRightClick", l)
    };

    function g(s, o, n, v) {
        if (this.rendererOptions.barDirection == "horizontal") {
            this._stackAxis = "x";
            this._primaryAxis = "_yaxis"
        }
        if (this.rendererOptions.waterfall == true) {
            this._data = d.extend(true, [], this.data);
            var r = 0;
            var t = (!this.rendererOptions.barDirection || this.rendererOptions.barDirection == "vertical") ? 1 : 0;
            for (var p = 0; p < this.data.length; p++) {
                r += this.data[p][t];
                if (p > 0) {
                    this.data[p][t] += this.data[p - 1][t]
                }
            }
            this.data[this.data.length] = (t == 1) ? [this.data.length + 1, r] : [r, this.data.length + 1];
            this._data[this._data.length] = (t == 1) ? [this._data.length + 1, r] : [r, this._data.length + 1]
        }
        if (this.rendererOptions.groups > 1) {
            this.breakOnNull = true;
            var m = this.data.length;
            var u = parseInt(m / this.rendererOptions.groups, 10);
            var q = 0;
            for (var p = u; p < m; p += u) {
                this.data.splice(p + q, 0, [null, null]);
                q++
            }
            for (p = 0; p < this.data.length; p++) {
                if (this._primaryAxis == "_xaxis") {
                    this.data[p][0] = p + 1
                } else {
                    this.data[p][1] = p + 1
                }
            }
        }
    }
    d.jqplot.preSeriesInitHooks.push(g);
    d.jqplot.BarRenderer.prototype.calcSeriesNumbers = function () {
        var q = 0;
        var r = 0;
        var p = this[this._primaryAxis];
        var o, n, t;
        for (var m = 0; m < p._series.length; m++) {
            n = p._series[m];
            if (n === this) {
                t = m
            }
            if (n.renderer.constructor == d.jqplot.BarRenderer) {
                q += n.data.length;
                r += 1
            }
        }
        return [q, r, t]
    };
    d.jqplot.BarRenderer.prototype.setBarWidth = function () {
        var p;
        var m = 0;
        var n = 0;
        var r = this[this._primaryAxis];
        var w, q, u;
        var v = this._plotSeriesInfo = this.renderer.calcSeriesNumbers.call(this);
        m = v[0];
        n = v[1];
        var t = r.numberTicks;
        var o = (t - 1) / 2;
        if (r.name == "xaxis" || r.name == "x2axis") {
            if (this._stack) {
                this.barWidth = (r._offsets.max - r._offsets.min) / m * n - this.barMargin
            } else {
                this.barWidth = ((r._offsets.max - r._offsets.min) / o - this.barPadding * (n - 1) - this.barMargin * 2) / n
            }
        } else {
            if (this._stack) {
                this.barWidth = (r._offsets.min - r._offsets.max) / m * n - this.barMargin
            } else {
                this.barWidth = ((r._offsets.min - r._offsets.max) / o - this.barPadding * (n - 1) - this.barMargin * 2) / n
            }
        }
        return [m, n]
    };

    function f(n) {
        var p = [];
        for (var r = 0; r < n.length; r++) {
            var q = d.jqplot.getColorComponents(n[r]);
            var m = [q[0], q[1], q[2]];
            var s = m[0] + m[1] + m[2];
            for (var o = 0; o < 3; o++) {
                m[o] = (s > 570) ? m[o] * 0.8 : m[o] + 0.3 * (255 - m[o]);
                m[o] = parseInt(m[o], 10)
            }
            p.push("rgb(" + m[0] + "," + m[1] + "," + m[2] + ")")
        }
        return p
    }
    d.jqplot.BarRenderer.prototype.draw = function (D, J, p) {
        var G;
        var z = d.extend({}, p);
        var u = (z.shadow != undefined) ? z.shadow : this.shadow;
        var M = (z.showLine != undefined) ? z.showLine : this.showLine;
        var E = (z.fill != undefined) ? z.fill : this.fill;
        var o = this.xaxis;
        var H = this.yaxis;
        var x = this._xaxis.series_u2p;
        var I = this._yaxis.series_u2p;
        var C, B;
        this._dataColors = [];
        this._barPoints = [];
        if (this.barWidth == null) {
            this.renderer.setBarWidth.call(this)
        }
        var L = this._plotSeriesInfo = this.renderer.calcSeriesNumbers.call(this);
        var w = L[0];
        var v = L[1];
        var r = L[2];
        var F = [];
        if (this._stack) {
            this._barNudge = 0
        } else {
            this._barNudge = (-Math.abs(v / 2 - 0.5) + r) * (this.barWidth + this.barPadding)
        } if (M) {
            var t = new d.jqplot.ColorGenerator(this.negativeSeriesColors);
            var A = new d.jqplot.ColorGenerator(this.seriesColors);
            var K = t.get(this.index);
            if (!this.useNegativeColors) {
                K = z.fillStyle
            }
            var s = z.fillStyle;
            var q;
            var N;
            var n;
            if (this.barDirection == "vertical") {
                for (var G = 0; G < J.length; G++) {
                    if (this.data[G][1] == null) {
                        continue
                    }
                    F = [];
                    q = J[G][0] + this._barNudge;
                    n;
                    if (this._stack && this._prevGridData.length) {
                        n = this._prevGridData[G][1]
                    } else {
                        if (this.fillToZero) {
                            n = this._yaxis.series_u2p(0)
                        } else {
                            if (this.waterfall && G > 0 && G < this.gridData.length - 1) {
                                n = this.gridData[G - 1][1]
                            } else {
                                if (this.waterfall && G == 0 && G < this.gridData.length - 1) {
                                    if (this._yaxis.min <= 0 && this._yaxis.max >= 0) {
                                        n = this._yaxis.series_u2p(0)
                                    } else {
                                        if (this._yaxis.min > 0) {
                                            n = D.canvas.height
                                        } else {
                                            n = 0
                                        }
                                    }
                                } else {
                                    if (this.waterfall && G == this.gridData.length - 1) {
                                        if (this._yaxis.min <= 0 && this._yaxis.max >= 0) {
                                            n = this._yaxis.series_u2p(0)
                                        } else {
                                            if (this._yaxis.min > 0) {
                                                n = D.canvas.height
                                            } else {
                                                n = 0
                                            }
                                        }
                                    } else {
                                        n = D.canvas.height
                                    }
                                }
                            }
                        }
                    } if ((this.fillToZero && this._plotData[G][1] < 0) || (this.waterfall && this._data[G][1] < 0)) {
                        if (this.varyBarColor && !this._stack) {
                            if (this.useNegativeColors) {
                                z.fillStyle = t.next()
                            } else {
                                z.fillStyle = A.next()
                            }
                        } else {
                            z.fillStyle = K
                        }
                    } else {
                        if (this.varyBarColor && !this._stack) {
                            z.fillStyle = A.next()
                        } else {
                            z.fillStyle = s
                        }
                    } if (!this.fillToZero || this._plotData[G][1] >= 0) {
                        F.push([q - this.barWidth / 2, n]);
                        F.push([q - this.barWidth / 2, J[G][1]]);
                        F.push([q + this.barWidth / 2, J[G][1]]);
                        F.push([q + this.barWidth / 2, n])
                    } else {
                        F.push([q - this.barWidth / 2, J[G][1]]);
                        F.push([q - this.barWidth / 2, n]);
                        F.push([q + this.barWidth / 2, n]);
                        F.push([q + this.barWidth / 2, J[G][1]])
                    }
                    this._barPoints.push(F);
                    if (u && !this._stack) {
                        var y = d.extend(true, {}, z);
                        delete y.fillStyle;
                        this.renderer.shadowRenderer.draw(D, F, y)
                    }
                    var m = z.fillStyle || this.color;
                    this._dataColors.push(m);
                    this.renderer.shapeRenderer.draw(D, F, z)
                }
            } else {
                if (this.barDirection == "horizontal") {
                    for (var G = 0; G < J.length; G++) {
                        if (this.data[G][0] == null) {
                            continue
                        }
                        F = [];
                        q = J[G][1] - this._barNudge;
                        N;
                        if (this._stack && this._prevGridData.length) {
                            N = this._prevGridData[G][0]
                        } else {
                            if (this.fillToZero) {
                                N = this._xaxis.series_u2p(0)
                            } else {
                                if (this.waterfall && G > 0 && G < this.gridData.length - 1) {
                                    N = this.gridData[G - 1][1]
                                } else {
                                    if (this.waterfall && G == 0 && G < this.gridData.length - 1) {
                                        if (this._xaxis.min <= 0 && this._xaxis.max >= 0) {
                                            N = this._xaxis.series_u2p(0)
                                        } else {
                                            if (this._xaxis.min > 0) {
                                                N = 0
                                            } else {
                                                N = D.canvas.width
                                            }
                                        }
                                    } else {
                                        if (this.waterfall && G == this.gridData.length - 1) {
                                            if (this._xaxis.min <= 0 && this._xaxis.max >= 0) {
                                                N = this._xaxis.series_u2p(0)
                                            } else {
                                                if (this._xaxis.min > 0) {
                                                    N = 0
                                                } else {
                                                    N = D.canvas.width
                                                }
                                            }
                                        } else {
                                            N = 0
                                        }
                                    }
                                }
                            }
                        } if ((this.fillToZero && this._plotData[G][1] < 0) || (this.waterfall && this._data[G][1] < 0)) {
                            if (this.varyBarColor && !this._stack) {
                                if (this.useNegativeColors) {
                                    z.fillStyle = t.next()
                                } else {
                                    z.fillStyle = A.next()
                                }
                            }
                        } else {
                            if (this.varyBarColor && !this._stack) {
                                z.fillStyle = A.next()
                            } else {
                                z.fillStyle = s
                            }
                        }
                        F.push([N, q + this.barWidth / 2]);
                        F.push([N, q - this.barWidth / 2]);
                        F.push([J[G][0], q - this.barWidth / 2]);
                        F.push([J[G][0], q + this.barWidth / 2]);
                        this._barPoints.push(F);
                        if (u && !this._stack) {
                            var y = d.extend(true, {}, z);
                            delete y.fillStyle;
                            this.renderer.shadowRenderer.draw(D, F, y)
                        }
                        var m = '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6);
                        this._dataColors.push(m);
                        this.renderer.shapeRenderer.draw(D, F, z)
                    }
                }
            }
        }
        if (this.highlightColors.length == 0) {
            this.highlightColors = f(this._dataColors)
        } else {
            if (typeof (this.highlightColors) == "string") {
                var L = this.highlightColors;
                this.highlightColors = [];
                for (var G = 0; G < this._dataColors.length; G++) {
                    this.highlightColors.push(L)
                }
            }
        }
    };
    d.jqplot.BarRenderer.prototype.drawShadow = function (y, E, o) {
        var B;
        var v = (o != undefined) ? o : {};
        var r = (v.shadow != undefined) ? v.shadow : this.shadow;
        var G = (v.showLine != undefined) ? v.showLine : this.showLine;
        var z = (v.fill != undefined) ? v.fill : this.fill;
        var n = this.xaxis;
        var C = this.yaxis;
        var u = this._xaxis.series_u2p;
        var D = this._yaxis.series_u2p;
        var x, A, w, t, s, q;
        if (this._stack && this.shadow) {
            if (this.barWidth == null) {
                this.renderer.setBarWidth.call(this)
            }
            var F = this._plotSeriesInfo = this.renderer.calcSeriesNumbers.call(this);
            t = F[0];
            s = F[1];
            q = F[2];
            if (this._stack) {
                this._barNudge = 0
            } else {
                this._barNudge = (-Math.abs(s / 2 - 0.5) + q) * (this.barWidth + this.barPadding)
            } if (G) {
                if (this.barDirection == "vertical") {
                    for (var B = 0; B < E.length; B++) {
                        if (this.data[B][1] == null) {
                            continue
                        }
                        A = [];
                        var p = E[B][0] + this._barNudge;
                        var m;
                        if (this._stack && this._prevGridData.length) {
                            m = this._prevGridData[B][1]
                        } else {
                            if (this.fillToZero) {
                                m = this._yaxis.series_u2p(0)
                            } else {
                                m = y.canvas.height
                            }
                        }
                        A.push([p - this.barWidth / 2, m]);
                        A.push([p - this.barWidth / 2, E[B][1]]);
                        A.push([p + this.barWidth / 2, E[B][1]]);
                        A.push([p + this.barWidth / 2, m]);
                        this.renderer.shadowRenderer.draw(y, A, v)
                    }
                } else {
                    if (this.barDirection == "horizontal") {
                        for (var B = 0; B < E.length; B++) {
                            if (this.data[B][0] == null) {
                                continue
                            }
                            A = [];
                            var p = E[B][1] - this._barNudge;
                            var H;
                            if (this._stack && this._prevGridData.length) {
                                H = this._prevGridData[B][0]
                            } else {
                                H = 0
                            }
                            A.push([H, p + this.barWidth / 2]);
                            A.push([E[B][0], p + this.barWidth / 2]);
                            A.push([E[B][0], p - this.barWidth / 2]);
                            A.push([H, p - this.barWidth / 2]);
                            this.renderer.shadowRenderer.draw(y, A, v)
                        }
                    }
                }
            }
        }
    };

    function h(p, o, m) {
        for (var n = 0; n < this.series.length; n++) {
            if (this.series[n].renderer.constructor == d.jqplot.BarRenderer) {
                if (this.series[n].highlightMouseOver) {
                    this.series[n].highlightMouseDown = false
                }
            }
        }
        this.target.bind("mouseout", {
            plot: this
        }, function (q) {
            j(q.data.plot)
        })
    }

    function i() {
        if (this.plugins.barRenderer && this.plugins.barRenderer.highlightCanvas) {
            this.plugins.barRenderer.highlightCanvas.resetCanvas();
            this.plugins.barRenderer.highlightCanvas = null
        }
        this.plugins.barRenderer = {
            highlightedSeriesIndex: null
        };
        this.plugins.barRenderer.highlightCanvas = new d.jqplot.GenericCanvas();
        this.eventCanvas._elem.before(this.plugins.barRenderer.highlightCanvas.createElement(this._gridPadding, "jqplot-barRenderer-highlight-canvas", this._plotDimensions, this));
        this.plugins.barRenderer.highlightCanvas.setContext()
    }

    function c(t, r, p, o) {
        var n = t.series[r];
        var m = t.plugins.barRenderer.highlightCanvas;
        m._ctx.clearRect(0, 0, m._ctx.canvas.width, m._ctx.canvas.height);
        n._highlightedPoint = p;
        t.plugins.barRenderer.highlightedSeriesIndex = r;
        var q = {
            fillStyle: n.highlightColors[p]
        };
        n.renderer.shapeRenderer.draw(m._ctx, o, q);
        m = null
    }

    function j(o) {
        var m = o.plugins.barRenderer.highlightCanvas;
        m._ctx.clearRect(0, 0, m._ctx.canvas.width, m._ctx.canvas.height);
        for (var n = 0; n < o.series.length; n++) {
            o.series[n]._highlightedPoint = null
        }
        o.plugins.barRenderer.highlightedSeriesIndex = null;
        o.target.trigger("jqplotDataUnhighlight");
        m = null
    }

    function b(q, p, t, s, r) {
        if (s) {
            var o = [s.seriesIndex, s.pointIndex, s.data];
            var n = jQuery.Event("jqplotDataMouseOver");
            n.pageX = q.pageX;
            n.pageY = q.pageY;
            r.target.trigger(n, o);
            if (r.series[o[0]].highlightMouseOver && !(o[0] == r.plugins.barRenderer.highlightedSeriesIndex && o[1] == r.series[o[0]]._highlightedPoint)) {
                var m = jQuery.Event("jqplotDataHighlight");
                m.pageX = q.pageX;
                m.pageY = q.pageY;
                r.target.trigger(m, o);
                c(r, s.seriesIndex, s.pointIndex, s.points)
            }
        } else {
            if (s == null) {
                j(r)
            }
        }
    }

    function a(p, o, s, r, q) {
        if (r) {
            var n = [r.seriesIndex, r.pointIndex, r.data];
            if (q.series[n[0]].highlightMouseDown && !(n[0] == q.plugins.barRenderer.highlightedSeriesIndex && n[1] == q.series[n[0]]._highlightedPoint)) {
                var m = jQuery.Event("jqplotDataHighlight");
                m.pageX = p.pageX;
                m.pageY = p.pageY;
                q.target.trigger(m, n);
                c(q, r.seriesIndex, r.pointIndex, r.points)
            }
        } else {
            if (r == null) {
                j(q)
            }
        }
    }

    function k(o, n, r, q, p) {
        var m = p.plugins.barRenderer.highlightedSeriesIndex;
        if (m != null && p.series[m].highlightMouseDown) {
            j(p)
        }
    }

    function e(p, o, s, r, q) {
        if (r) {
            var n = [r.seriesIndex, r.pointIndex, r.data];
            var m = jQuery.Event("jqplotDataClick");
            m.pageX = p.pageX;
            m.pageY = p.pageY;
            q.target.trigger(m, n)
        }
    }

    function l(q, p, t, s, r) {
        if (s) {
            var o = [s.seriesIndex, s.pointIndex, s.data];
            var m = r.plugins.barRenderer.highlightedSeriesIndex;
            if (m != null && r.series[m].highlightMouseDown) {
                j(r)
            }
            var n = jQuery.Event("jqplotDataRightClick");
            n.pageX = q.pageX;
            n.pageY = q.pageY;
            r.target.trigger(n, o)
        }
    }
})(jQuery);