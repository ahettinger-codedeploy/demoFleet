webpackJsonp([17], {
  0: function(k, n, b) {
    b(2106);
    b(1093);
    b(1104);
    b(756);
    b(1103);
    b(1102);
    b(2347);
    b(1602);
    b(267);
    b(1544);
    b(1786);
    b(2373);
    b(2263);
    b(2371);
    b(2349);
    b(1071);
    b(965);
    b(517);
    b(516);
    b(295);
    b(1785);
    b(1784);
    b(225);
    b(983);
    b(1540);
    b(2215);
    b(2097);
    b(1590);
    b(2100);
    b(1608);
    b(1765);
    b(1761);
    b(1592);
    b(1693);
    b(1261);
    b(1097);
    b(1096);
    b(2101);
    b(2096);
    b(1088);
    b(1247);
    b(1089);
    b(990);
    b(989);
    b(1094);
    b(1090);
    b(1208);
    b(1689);
    b(1612);
    b(1694);
    b(2267);
    b(2358);
    b(1788);
    b(1787);
    b(2098);
    b(1763);
    b(1766);
    b(2099);
    b(1513);
    b(446);
    b(1244);
    b(2266);
    b(1762);
    b(2154);
    b(1769);
    b(1607);
    b(1233);
    b(1764)
  },
  225: function(k, n) {
    YUI.add("squarespace-spinner", function(b) {
      b.namespace("Squarespace").Spinner = b.Base.create("Spinner", b.Widget, [], {
        renderUI: function() {
          this.get("boundingBox").addClass(this.get("color"));
          0 < b.UA.ie && 10 > b.UA.ie && (this.get("contentBox").append(b.Node.create('<img class="sqs-ie-spinner" src="/universal/images-v6/configuration/crappy-ie-spinner.gif"/>')), this.get("boundingBox").addClass("degraded"));
          var h = this.get("size");
          b.Lang.isNumber(h) || this.get("boundingBox").addClass(h)
        },
        spin: function() {
          this.get("boundingBox").show()
        },
        stop: function() {
          this.get("boundingBox").hide()
        },
        addClass: function(b) {
          this.get("boundingBox").addClass(b)
        }
      }, {
        CSS_PREFIX: "sqs-spin",
        NS: "spinner",
        ATTRS: {
          size: {
            value: "default",
            setter: function(h) {
              b.Lang.isNumber(h) && (this.set("width", h), this.set("height", h));
              return h
            }
          },
          color: {
            value: "light"
          }
        }
      })
    }, "1.0", {
      requires: ["base-build", "widget"]
    })
  },
  267: function(k, n) {
    YUI.add("model", function(b, h) {
      function a() {
        a.superclass.constructor.apply(this,
          arguments)
      }
      var c = YUI.namespace("Env.Model"),
        d = b.Lang,
        e = b.Array,
        g = b.Object,
        f = "error";
      b.Model = b.extend(a, b.Base, {
        idAttribute: "id",
        _allowAdHocAttrs: !0,
        _isYUIModel: !0,
        initializer: function(a) {
          this.changed = {};
          this.lastChange = {};
          this.lists = []
        },
        destroy: function(b, f) {
          var d = this;
          "function" === typeof b && (f = b, b = null);
          d.onceAfter("destroy", function() {
            function a(c) {
              c || e.each(d.lists.concat(), function(a) {
                a.remove(d, b)
              });
              f && f.apply(null, arguments)
            }
            b && (b.remove || b["delete"]) ? d.sync("delete", b, a) : a()
          });
          return a.superclass.destroy.call(d)
        },
        generateClientId: function() {
          c.lastId || (c.lastId = 0);
          return this.constructor.NAME + "_" + (c.lastId += 1)
        },
        getAsHTML: function(a) {
          a = this.get(a);
          return b.Escape.html(d.isValue(a) ? String(a) : "")
        },
        getAsURL: function(a) {
          a = this.get(a);
          return encodeURIComponent(d.isValue(a) ? String(a) : "")
        },
        isModified: function() {
          return this.isNew() || !g.isEmpty(this.changed)
        },
        isNew: function() {
          return !d.isValue(this.get("id"))
        },
        load: function(a, b) {
          var d = this;
          "function" === typeof a && (b = a, a = {});
          a || (a = {});
          d.sync("read", a, function(e, c) {
            var g = {
                options: a,
                response: c
              },
              h;
            e ? (g.error = e, g.src = "load", d.fire(f, g)) : (d._loadEvent || (d._loadEvent = d.publish("load", {
              preventable: !1
            })), h = g.parsed = d._parse(c), d.setAttrs(h, a), d.changed = {}, d.fire("load", g));
            b && b.apply(null, arguments)
          });
          return d
        },
        parse: function(a) {
          if ("string" === typeof a) try {
            return b.JSON.parse(a)
          } catch (d) {
            return this.fire(f, {
              error: d,
              response: a,
              src: "parse"
            }), null
          }
          return a
        },
        save: function(a, b) {
          var d = this;
          "function" === typeof a && (b = a, a = {});
          a || (a = {});
          d._validate(d.toJSON(), function(e) {
            e ? b && b.call(null,
              e) : d.sync(d.isNew() ? "create" : "update", a, function(e, c) {
              var g = {
                  options: a,
                  response: c
                },
                h;
              e ? (g.error = e, g.src = "save", d.fire(f, g)) : (d._saveEvent || (d._saveEvent = d.publish("save", {
                preventable: !1
              })), c && (h = g.parsed = d._parse(c), d.setAttrs(h, a)), d.changed = {}, d.fire("save", g));
              b && b.apply(null, arguments)
            })
          });
          return d
        },
        set: function(a, b, d) {
          var f = {};
          f[a] = b;
          return this.setAttrs(f, d)
        },
        setAttrs: function(a, d) {
          var f = this.idAttribute,
            e, c, h, v;
          d = b.merge(d);
          v = d._transaction = {};
          "id" !== f && (a = b.merge(a), g.owns(a, f) ? a.id = a[f] :
            g.owns(a, "id") && (a[f] = a.id));
          for (c in a) g.owns(a, c) && this._setAttr(c, a[c], d);
          if (!g.isEmpty(v)) {
            f = this.changed;
            h = this.lastChange = {};
            for (c in v) g.owns(v, c) && (e = v[c], f[c] = e.newVal, h[c] = {
              newVal: e.newVal,
              prevVal: e.prevVal,
              src: e.src || null
            });
            d.silent || (this._changeEvent || (this._changeEvent = this.publish("change", {
              preventable: !1
            })), d.changed = h, this.fire("change", d))
          }
          return this
        },
        sync: function() {
          var a = e(arguments, 0, !0).pop();
          "function" === typeof a && a()
        },
        toJSON: function() {
          var a = this.getAttrs();
          delete a.clientId;
          delete a.destroyed;
          delete a.initialized;
          "id" !== this.idAttribute && delete a.id;
          return a
        },
        undo: function(a, b) {
          var d = this.lastChange,
            f = this.idAttribute,
            c = {},
            h;
          a || (a = g.keys(d));
          e.each(a, function(a) {
            g.owns(d, a) && (a = a === f ? "id" : a, h = !0, c[a] = d[a].prevVal)
          });
          return h ? this.setAttrs(c, b) : this
        },
        validate: function(a, b) {
          b && b()
        },
        addAttr: function(b, f, e) {
          var c = this.idAttribute,
            g;
          c && b === c && (c = this._isLazyAttr("id") || this._getAttrCfg("id"), g = f.value === f.defaultValue ? null : f.value, d.isValue(g) || (g = c.value === c.defaultValue ?
            null : c.value, d.isValue(g) || (g = d.isValue(f.defaultValue) ? f.defaultValue : c.defaultValue)), f.value = g, c.value !== g && (c.value = g, this._isLazyAttr("id") ? this._state.add("id", "lazy", c) : this._state.add("id", "value", g)));
          return a.superclass.addAttr.apply(this, arguments)
        },
        _parse: function(a) {
          return this.parse(a)
        },
        _validate: function(a, b) {
          function c(g) {
            d.isValue(g) ? (e.fire(f, {
              attributes: a,
              error: g,
              src: "validate"
            }), b(g)) : b()
          }
          var e = this;
          1 === e.validate.length ? c(e.validate(a, c)) : e.validate(a, c)
        },
        _setAttrVal: function(b,
          d, f, c, e, g) {
          var h = a.superclass._setAttrVal.apply(this, arguments),
            s = e && e._transaction,
            x = g && g.initializing;
          h && (s && !x) && (s[b] = {
            newVal: this.get(b),
            prevVal: f,
            src: e.src || null
          });
          return h
        }
      }, {
        NAME: "model",
        ATTRS: {
          clientId: {
            valueFn: "generateClientId",
            readOnly: !0
          },
          id: {
            value: null
          }
        }
      })
    }, "3.17.2", {
      requires: ["base-build", "escape", "json-parse"]
    })
  },
  295: function(k, n) {
    YUI.add("squarespace-widgets-alert", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Widgets.Alert = b.Base.create("alert", b.Squarespace.Widgets.Confirmation, [], {}, {
        CSS_PREFIX: "sqs-widgets-confirmation",
        TYPE: b.Squarespace.Widgets.Confirmation.TYPE,
        ANCHOR: b.Squarespace.Widgets.Confirmation.ANCHOR,
        show: function(a) {
          return new h(a)
        },
        ATTRS: {
          className: {
            value: "alert"
          },
          style: {
            value: b.Squarespace.Widgets.Confirmation.TYPE.CONFIRM_ONLY
          },
          "strings.confirm": {
            value: "Okay"
          }
        }
      })
    }, "1.0", {
      requires: ["base", "squarespace-widgets-confirmation"]
    })
  },
  433: function(k, n) {
    k.exports = {
      AF: "Afghanistan",
      AL: "Albania",
      DZ: "Algeria",
      AS: "American Samoa",
      AD: "Andorra",
      AO: "Angola",
      AI: "Anguilla",
      AQ: "Antarctica",
      AG: "Antigua and Barbuda",
      AR: "Argentina",
      AM: "Armenia",
      AW: "Aruba",
      AU: "Australia",
      AT: "Austria",
      AX: "Aland Islands",
      AZ: "Azerbaijan",
      BS: "Bahamas",
      BH: "Bahrain",
      BD: "Bangladesh",
      BB: "Barbados",
      BY: "Belarus",
      BE: "Belgium",
      BZ: "Belize",
      BJ: "Benin",
      BM: "Bermuda",
      BT: "Bhutan",
      BO: "Bolivia",
      BA: "Bosnia and Herzegovina",
      BW: "Botswana",
      BV: "Bouvet Island",
      BR: "Brazil",
      IO: "British Indian Ocean Territory",
      BN: "Brunei Darussalam",
      BG: "Bulgaria",
      BF: "Burkina Faso",
      BI: "Burundi",
      KH: "Cambodia",
      CA: "Canada",
      CI: "Cote d'Ivoire",
      CM: "Cameroon",
      CV: "Cape Verde",
      KY: "Cayman Islands",
      CF: "Central African Republic",
      TD: "Chad",
      CL: "Chile",
      CN: "China",
      CX: "Christmas Island",
      CC: "Cocos (Keeling) Islands",
      CO: "Colombia",
      KM: "Comoros",
      CG: "Congo",
      CD: "Congo, Democratic Republic",
      CK: "Cook Islands",
      CR: "Costa Rica",
      HR: "Croatia",
      CY: "Cyprus",
      CZ: "Czech Republic",
      DK: "Denmark",
      DJ: "Djibouti",
      DM: "Dominica",
      DO: "Dominican Republic",
      TL: "Timor-Leste",
      EC: "Ecuador",
      EG: "Egypt",
      SV: "El Salvador",
      GQ: "Equatorial Guinea",
      ER: "Eritrea",
      EE: "Estonia",
      ET: "Ethiopia",
      FK: "Falkland Islands (Malvinas)",
      FO: "Faroe Islands",
      FJ: "Fiji",
      FI: "Finland",
      FR: "France",
      GF: "French Guiana",
      PF: "French Polynesia",
      TF: "French Southern Territories",
      GA: "Gabon",
      GM: "Gambia",
      GE: "Georgia",
      DE: "Germany",
      GH: "Ghana",
      GI: "Gibraltar",
      GR: "Greece",
      GL: "Greenland",
      GD: "Grenada",
      GG: "Guernsey",
      GP: "Guadeloupe",
      GU: "Guam",
      GT: "Guatemala",
      GN: "Guinea",
      GW: "Guinea-Bissau",
      GY: "Guyana",
      HT: "Haiti",
      HM: "Heard and McDonald Islands",
      HN: "Honduras",
      HK: "Hong Kong",
      HU: "Hungary",
      IS: "Iceland",
      IN: "India",
      ID: "Indonesia",
      IQ: "Iraq",
      IE: "Ireland",
      IM: "Isle of Man",
      IL: "Israel",
      IT: "Italy",
      JM: "Jamaica",
      JP: "Japan",
      JE: "Jersey",
      JO: "Jordan",
      KZ: "Kazakhstan",
      KE: "Kenya",
      KI: "Kiribati",
      KP: "Korea (the Democratic People's Republic of)",
      KR: "Korea (the Republic of)",
      XK: "Kosovo",
      KW: "Kuwait",
      KG: "Kyrgyzstan",
      LA: "Laos",
      LV: "Latvia",
      LB: "Lebanon",
      LS: "Lesotho",
      LR: "Liberia",
      LY: "Libya",
      LI: "Liechtenstein",
      LT: "Lithuania",
      LU: "Luxembourg",
      MO: "Macau",
      MK: "Macedonia",
      MG: "Madagascar",
      MW: "Malawi",
      MY: "Malaysia",
      MV: "Maldives",
      ML: "Mali",
      MT: "Malta",
      MH: "Marshall Islands",
      MQ: "Martinique",
      MR: "Mauritania",
      MU: "Mauritius",
      YT: "Mayotte",
      MX: "Mexico",
      FM: "Micronesia",
      MD: "Moldova",
      MC: "Monaco",
      MN: "Mongolia",
      ME: "Montenegro",
      MS: "Montserrat",
      MA: "Morocco",
      MZ: "Mozambique",
      NA: "Namibia",
      NR: "Nauru",
      NP: "Nepal",
      NL: "Netherlands",
      AN: "Netherlands Antilles",
      NC: "New Caledonia",
      NZ: "New Zealand",
      NI: "Nicaragua",
      NE: "Niger",
      NG: "Nigeria",
      NU: "Niue",
      NF: "Norfolk Island",
      MP: "Northern Mariana Islands",
      NO: "Norway",
      OM: "Oman",
      PK: "Pakistan",
      PW: "Palau",
      PA: "Panama",
      PG: "Papua New Guinea",
      PS: "Palestine, State of",
      PY: "Paraguay",
      PE: "Peru",
      PH: "Philippines",
      PN: "Pitcairn",
      PL: "Poland",
      PT: "Portugal",
      PR: "Puerto Rico",
      QA: "Qatar",
      RE: "Reunion",
      RO: "Romania",
      RU: "Russian Federation",
      RW: "Rwanda",
      GS: "South Georgia and the South Sandwich Islands",
      BL: "Saint Barthelemy",
      KN: "Saint Kitts and Nevis",
      LC: "Saint Lucia",
      VC: "Saint Vincent and the Grenadines",
      WS: "Samoa",
      SM: "San Marino",
      ST: "Sao Tome and Principe",
      SA: "Saudi Arabia",
      SN: "Senegal",
      RS: "Serbia",
      SC: "Seychelles",
      SL: "Sierra Leone",
      SG: "Singapore",
      SK: "Slovakia",
      SI: "Slovenia",
      SB: "Solomon Islands",
      SO: "Somalia",
      ZA: "South Africa",
      ES: "Spain",
      LK: "Sri Lanka",
      SH: "Saint Helena",
      PM: "Saint Pierre and Miquelon",
      SR: "Suriname",
      SJ: "Svalbard and Jan Mayen Islands",
      SZ: "Swaziland",
      SE: "Sweden",
      CH: "Switzerland",
      TW: "Taiwan",
      TJ: "Tajikistan",
      TZ: "Tanzania",
      TH: "Thailand",
      TG: "Togo",
      TK: "Tokelau",
      TO: "Tonga",
      TT: "Trinidad and Tobago",
      TN: "Tunisia",
      TR: "Turkey",
      TM: "Turkmenistan",
      TC: "Turks and Caicos Islands",
      TV: "Tuvalu",
      UG: "Uganda",
      UA: "Ukraine",
      AE: "United Arab Emirates",
      GB: "United Kingdom",
      US: "United States",
      UM: "United States Minor Outlying Islands",
      UY: "Uruguay",
      UZ: "Uzbekistan",
      VU: "Vanuatu",
      VA: "Vatican City State (Holy See)",
      VE: "Venezuela",
      VN: "Vietnam",
      VG: "Virgin Islands (British)",
      VI: "Virgin Islands (U.S.)",
      WF: "Wallis and Futuna Islands",
      EH: "Western Sahara",
      YE: "Yemen",
      ZM: "Zambia",
      ZW: "Zimbabwe"
    }
  },
  435: function(k, n) {
    k.exports = {
      LIVE: 1,
      TEST_MODE: 2,
      NOT_CONNECTED: 3
    }
  },
  446: function(k, n) {
    YUI.add("squarespace-dialog-check-template", function(b) {
        var h = b.Handlebars;
        (function() {
          var a = h.template;
          (h.templates = h.templates || {})["dialog-check.html"] = a(function(a,
            b, e, g, f) {
            this.compilerInfo = [4, ">= 1.0.0"];
            e = this.merge(e, a.helpers);
            f = f || {};
            var l, h = this.escapeExpression;
            a = '<div class="check-element ';
            if ((g = e["if"].call(b, b.data, {
                hash: {},
                inverse: this.noop,
                fn: this.program(1, function(a, b) {
                  return "active"
                }, f),
                data: f
              })) || 0 === g) a += g;
            a += '">\n  ';
            if ((l = e["if"].call(b, (g = b.strings, null == g || !1 === g ? g : g.title), {
                hash: {},
                inverse: this.noop,
                fn: this.program(3, function(a, b) {
                  var f, d;
                  return f = "" + ('\n    <div class="title">' + h((d = (d = a.strings, null == d || !1 === d ? d : d.title), "function" ===
                    typeof d ? d.apply(a) : d)) + "</div>\n  ")
                }, f),
                data: f
              })) || 0 === l) a += l;
            a += "\n  ";
            if ((l = e["if"].call(b, (g = b.strings, null == g || !1 === g ? g : g.description), {
                hash: {},
                inverse: this.noop,
                fn: this.program(5, function(a, b) {
                  var d, f, e;
                  d = '\n    <div class="description">';
                  if ((e = (f = (f = a.strings, null == f || !1 === f ? f : f.description), "function" === typeof f ? f.apply(a) : f)) || 0 === e) d += e;
                  return d + "</div>\n  "
                }, f),
                data: f
              })) || 0 === l) a += l;
            return a + "\n</div>\n"
          })
        })();
        b.Handlebars.registerPartial("dialog-check.html".replace("/", "."), h.templates["dialog-check.html"])
      },
      "1.0", {
        requires: ["handlebars-base"]
      })
  },
  516: function(k, n) {
    YUI.add("squarespace-rendering", function(b) {
      b.Squarespace.Rendering = {
        getWidthForHeight: function(b, a, c) {
          return b / a * c
        },
        getHeightForWidth: function(b, a, c) {
          return a / b * c
        },
        getDimensionsFromNode: function(h) {
          if (h = h.getAttribute("data-image-dimensions")) {
            if (b.Lang.isString(h)) return h = h.split("x"), {
              width: parseInt(h[0], 10),
              height: parseInt(h[1], 10)
            }
          } else return {
            width: null,
            height: null
          }
        },
        getSquarespaceSizeForWidth: function(h) {
          b.config.win.devicePixelRatio &&
            (h *= b.config.win.devicePixelRatio);
          return 1500 < h ? "2500w" : 1E3 < h ? "1500w" : 750 < h ? "1000w" : 500 < h ? "750w" : 300 < h ? "500w" : 100 < h ? "300w" : "100w"
        },
        splitScriptsAndHTML: function(b) {
          for (var a = b.indexOf("<script>"), c = -1, d = "", e = "", g = 0;;) {
            c = b.indexOf("\x3c/script>", g);
            if (-1 == c || -1 == a) return {
              html: b,
              script: ""
            };
            var f = b.substring(a + 8, c),
              e = e + f,
              d = d + b.substring(g, a),
              g = c + 9,
              a = b.indexOf("<script>", g);
            if (-1 === a) return 0 === e.length && (e = null), d += b.substring(g), {
              html: d,
              script: e
            }
          }
        },
        getPixelSize: function(b) {
          b = b.split("x");
          return parseInt(b[0],
            10) * parseInt(b[1], 10)
        },
        scaleEmbed: function(b, a) {
          var c = /height="([0-9]+)"/.exec(b);
          if (!c) return b;
          var c = parseInt(c[1], 10),
            d = /width="([0-9]+)"/.exec(b);
          if (!d) return b;
          d = parseInt(d[1], 10);
          return b.replace(/height="([0-9]+)"/, 'height="' + c * (a / d) + '"').replace(/width="([0-9]+)"/, 'width="' + a + '"')
        },
        applyStyleToMap: function(b, a) {
          var c = new google.maps.StyledMapType(a, {
            name: "Custom"
          });
          b.mapTypes.set("custom", c);
          b.setMapTypeId("custom")
        },
        createGrayscaleMap: function(b) {
          this.applyStyleToMap(b, [{
            featureType: "landscape.man_made",
            elementType: "all",
            stylers: [{
              lightness: 51
            }]
          }, {
            featureType: "poi",
            elementType: "all",
            stylers: [{
              visibility: "off"
            }]
          }, {
            featureType: "road.local",
            elementType: "all",
            stylers: [{
              gamma: 2.51
            }]
          }, {
            featureType: "road.arterial",
            elementType: "all",
            stylers: [{
              gamma: 1.9
            }]
          }, {
            featureType: "water",
            elementType: "all",
            stylers: [{
              gamma: 1.36
            }]
          }, {
            featureType: "road.highway",
            elementType: "all",
            stylers: [{
              gamma: 1.33
            }]
          }, {
            featureType: "transit.station.rail",
            elementType: "all",
            stylers: [{
              visibility: "simplified"
            }]
          }, {
            featureType: "transit.station.bus",
            elementType: "all",
            stylers: [{
              visibility: "simplified"
            }]
          }, {
            featureType: "transit",
            elementType: "all",
            stylers: [{
              gamma: 1.2
            }, {
              hue: "#0033ff"
            }]
          }, {
            featureType: "administrative.neighborhood",
            elementType: "labels",
            stylers: [{
              gamma: 1.43
            }]
          }, {
            featureType: "water",
            elementType: "all",
            stylers: [{
              lightness: -47
            }]
          }, {
            featureType: "all",
            elementType: "all",
            stylers: [{
              saturation: -100
            }]
          }, {
            featureType: "road.arterial",
            elementType: "labels",
            stylers: [{
              lightness: 23
            }]
          }])
        },
        getIconUrl: function(b, a, c) {
          return "/universal/images-v6/icons/icon-" +
            b + "-" + a + "-" + c + ".png"
        },
        onMapConfigure: function(h) {
          if (h = b.one(h)) {
            var a = h.getAncestorData("layout-engine");
            h = h.getAncestorData("manager");
            a && h && a.lm.configureBlock(null, h.boundingEl)
          }
        },
        renderMap: function(h, a, c, d) {
          a = b.merge({
            location: {
              mapLat: 40.720882,
              mapLng: -74.000988,
              mapZoom: 12
            },
            vSize: 12
          }, a);
          if (h) {
            c = c || {};
            var e = h._node;
            if (e.__map) google.maps.event.trigger(e.__map, "resize");
            else {
              h.addClass("page-map");
              h.set("innerHTML", "&nbsp;");
              var g = b.bind(function() {
                e.__geocoder = new google.maps.Geocoder;
                e.__map =
                  new google.maps.Map(e, {
                    zoom: a.location.mapZoom,
                    center: new google.maps.LatLng(a.location.mapLat, a.location.mapLng),
                    mapTypeId: google.maps.MapTypeId.ROADMAP,
                    draggable: !0,
                    scrollwheel: !0,
                    disableDefaultUI: !0
                  });
                b.Lang.isUndefined(d) ? b.Squarespace.Rendering.createGrayscaleMap(e.__map) : this.applyStyleToMap(e.__map, d);
                var f = a.location,
                  g;
                f.addressLine1 || f.addressLine2 ? (g = f.addressLine1 + " " + f.addressLine2, f.addressCountry && (g += ", " + f.addressCountry)) : g = a.location.mapLat + "," + a.location.mapLng;
                if (a.location.markerLat &&
                  a.location.markerLng) {
                  var h = new google.maps.LatLng(a.location.markerLat, a.location.markerLng);
                  e.__marker = new google.maps.Marker({
                    map: e.__map,
                    animation: google.maps.Animation.DROP,
                    draggable: !1,
                    position: h,
                    title: f.addressTitle ? f.addressTitle + " " + g : g,
                    icon: {
                      url: "/universal/images-v6/icons/icon-map-marker-2x.png",
                      size: new google.maps.Size(52, 68),
                      scaledSize: new google.maps.Size(26, 34),
                      anchor: new google.maps.Point(13, 34)
                    }
                  });
                  b.Lang.isObject(c.infoWindow) && (e.__infoWindow = new google.maps.InfoWindow(b.merge({
                    pixelOffset: new google.maps.Size(-13,
                      10)
                  }, c.infoWindow)), c.infoWindow.autoOpen && e.__infoWindow.open(e.__map, e.__marker));
                  google.maps.event.addListener(e.__marker, "click", b.bind(function(a, f) {
                    if (e.__infoWindow) e.__infoWindow.open(e.__map, e.__marker);
                    else {
                      a = a.toUrlValue();
                      var d = f.getZoom(),
                        d = b.QueryString.stringify({
                          sll: a,
                          q: g,
                          z: d
                        });
                      window.open("http://maps.google.com/maps?" + d)
                    }
                  }, this, h, e.__map))
                }
                e.startEditing = function() {
                  e.__map.setOptions({
                    draggable: !0,
                    scrollwheel: !0,
                    disableDefaultUI: !1
                  });
                  e.__marker && e.__marker.setOptions({
                    draggable: !0
                  })
                };
                e.stopEditing = function() {
                  e.__map.setOptions({
                    draggable: !1,
                    scrollwheel: !1,
                    disableDefaultUI: !0
                  });
                  e.__marker && e.__marker.setOptions({
                    draggable: !1
                  })
                };
                b.one(e).fire("maps-loaded");
                google.maps.event.addListener(e.__map, "rightclick", b.bind(this.onMapConfigure, this, e))
              }, this);
              b.Squarespace.GoogleMap.loaded ? g() : (e.__loadingMap = !0, b.Squarespace.GoogleMap.on("load-success", function() {
                e.__loadingMap = !1;
                g()
              }), b.Squarespace.GoogleMap.load())
            }
          } else console.error("Page map node missing...")
        }
      }
    }, "1.0", {
      requires: []
    })
  },
  517: function(k, n) {
    YUI.add("datatype-date-format", function(b, h) {
      var a = function(a, b, c) {
          "undefined" === typeof c && (c = 10);
          for (b += ""; parseInt(a, 10) < c && 1 < c; c /= 10) a = b + a;
          return a.toString()
        },
        c = {
          formats: {
            a: function(a, b) {
              return b.a[a.getDay()]
            },
            A: function(a, b) {
              return b.A[a.getDay()]
            },
            b: function(a, b) {
              return b.b[a.getMonth()]
            },
            B: function(a, b) {
              return b.B[a.getMonth()]
            },
            C: function(b) {
              return a(parseInt(b.getFullYear() / 100, 10), 0)
            },
            d: ["getDate", "0"],
            e: ["getDate", " "],
            g: function(b) {
              return a(parseInt(c.formats.G(b) % 100,
                10), 0)
            },
            G: function(a) {
              var b = a.getFullYear(),
                g = parseInt(c.formats.V(a), 10);
              a = parseInt(c.formats.W(a), 10);
              a > g ? b++ : 0 === a && 52 <= g && b--;
              return b
            },
            H: ["getHours", "0"],
            I: function(b) {
              b = b.getHours() % 12;
              return a(0 === b ? 12 : b, 0)
            },
            j: function(b) {
              var c = new Date("" + b.getFullYear() + "/1/1 GMT");
              b = new Date("" + b.getFullYear() + "/" + (b.getMonth() + 1) + "/" + b.getDate() + " GMT") - c;
              b = parseInt(b / 6E4 / 60 / 24, 10) + 1;
              return a(b, 0, 100)
            },
            k: ["getHours", " "],
            l: function(b) {
              b = b.getHours() % 12;
              return a(0 === b ? 12 : b, " ")
            },
            m: function(b) {
              return a(b.getMonth() +
                1, 0)
            },
            M: ["getMinutes", "0"],
            p: function(a, b) {
              return b.p[12 <= a.getHours() ? 1 : 0]
            },
            P: function(a, b) {
              return b.P[12 <= a.getHours() ? 1 : 0]
            },
            s: function(a, b) {
              return parseInt(a.getTime() / 1E3, 10)
            },
            S: ["getSeconds", "0"],
            u: function(a) {
              a = a.getDay();
              return 0 === a ? 7 : a
            },
            U: function(b) {
              var e = parseInt(c.formats.j(b), 10);
              b = 6 - b.getDay();
              e = parseInt((e + b) / 7, 10);
              return a(e, 0)
            },
            V: function(b) {
              var e = parseInt(c.formats.W(b), 10),
                g = (new Date("" + b.getFullYear() + "/1/1")).getDay(),
                e = e + (4 < g || 1 >= g ? 0 : 1);
              53 === e && 4 > (new Date("" + b.getFullYear() +
                "/12/31")).getDay() ? e = 1 : 0 === e && (e = c.formats.V(new Date("" + (b.getFullYear() - 1) + "/12/31")));
              return a(e, 0)
            },
            w: "getDay",
            W: function(b) {
              var e = parseInt(c.formats.j(b), 10);
              b = 7 - c.formats.u(b);
              e = parseInt((e + b) / 7, 10);
              return a(e, 0, 10)
            },
            y: function(b) {
              return a(b.getFullYear() % 100, 0)
            },
            Y: "getFullYear",
            z: function(b) {
              b = b.getTimezoneOffset();
              var c = a(parseInt(Math.abs(b / 60), 10), 0),
                g = a(Math.abs(b % 60), 0);
              return (0 < b ? "-" : "+") + c + g
            },
            Z: function(a) {
              var b = a.toString().replace(/^.*:\d\d( GMT[+-]\d+)? \(?([A-Za-z ]+)\)?\d*$/, "$2").replace(/[a-z ]/g,
                "");
              4 < b.length && (b = c.formats.z(a));
              return b
            },
            "%": function(a) {
              return "%"
            }
          },
          aggregates: {
            c: "locale",
            D: "%m/%d/%y",
            F: "%Y-%m-%d",
            h: "%b",
            n: "\n",
            r: "%I:%M:%S %p",
            R: "%H:%M",
            t: "\t",
            T: "%H:%M:%S",
            x: "locale",
            X: "locale"
          },
          format: function(d, e) {
            e = e || {};
            if (!b.Lang.isDate(d)) return b.Lang.isValue(d) ? d : "";
            var g, f;
            g = e.format || "%Y-%m-%d";
            f = b.Intl.get("datatype-date-format");
            for (var l = function(a, b) {
                var d = c.aggregates[b];
                return "locale" === d ? f[b] : d
              }, h = function(e, g) {
                var l = c.formats[g];
                switch (b.Lang.type(l)) {
                  case "string":
                    return d[l]();
                  case "function":
                    return l.call(d, d, f);
                  case "array":
                    if ("string" === b.Lang.type(l[0])) return a(d[l[0]](), l[1]);
                  default:
                    return g
                }
              }; g.match(/%[cDFhnrRtTxX]/);) g = g.replace(/%([cDFhnrRtTxX])/g, l);
            g = g.replace(/%([aAbBCdegGHIjklmMpPsSuUVwWyYzZ%])/g, h);
            l = h = void 0;
            return g
          }
        };
      b.mix(b.namespace("Date"), c);
      b.namespace("DataType");
      b.DataType.Date = b.Date
    }, "3.17.2", {
      lang: "ar ar-JO ca ca-ES da da-DK de de-AT de-DE el el-GR en en-AU en-CA en-GB en-IE en-IN en-JO en-MY en-NZ en-PH en-SG en-US es es-AR es-BO es-CL es-CO es-EC es-ES es-MX es-PE es-PY es-US es-UY es-VE fi fi-FI fr fr-BE fr-CA fr-FR hi hi-IN hu id id-ID it it-IT ja ja-JP ko ko-KR ms ms-MY nb nb-NO nl nl-BE nl-NL pl pl-PL pt pt-BR ro ro-RO ru ru-RU sv sv-SE th th-TH tr tr-TR vi vi-VN zh-Hans zh-Hans-CN zh-Hant zh-Hant-HK zh-Hant-TW".split(" ")
    })
  },
  756: function(k, n) {
    YUI.add("widget-position-align", function(b, h) {
      function a(a) {}
      var c = b.Lang;
      a.ATTRS = {
        align: {
          value: null
        },
        centered: {
          setter: "_setAlignCenter",
          lazyAdd: !1,
          value: !1
        },
        alignOn: {
          value: [],
          validator: b.Lang.isArray
        }
      };
      a.TL = "tl";
      a.TR = "tr";
      a.BL = "bl";
      a.BR = "br";
      a.TC = "tc";
      a.RC = "rc";
      a.BC = "bc";
      a.LC = "lc";
      a.CC = "cc";
      a.prototype = {
        initializer: function() {
          this._posNode || b.error("WidgetPosition needs to be added to the Widget, before WidgetPositionAlign is added");
          b.after(this._bindUIPosAlign, this, "bindUI");
          b.after(this._syncUIPosAlign, this, "syncUI")
        },
        _posAlignUIHandles: null,
        destructor: function() {
          this._detachPosAlignUIHandles()
        },
        _bindUIPosAlign: function() {
          this.after("alignChange", this._afterAlignChange);
          this.after("alignOnChange", this._afterAlignOnChange);
          this.after("visibleChange", this._syncUIPosAlign)
        },
        _syncUIPosAlign: function() {
          var a = this.get("align");
          this._uiSetVisiblePosAlign(this.get("visible"));
          a && this._uiSetAlign(a.node, a.points)
        },
        align: function(a, b) {
          arguments.length ? this.set("align", {
            node: a,
            points: b
          }) : this._syncUIPosAlign();
          return this
        },
        centered: function(b) {
          return this.align(b, [a.CC, a.CC])
        },
        _setAlignCenter: function(b) {
          b && this.set("align", {
            node: !0 === b ? null : b,
            points: [a.CC, a.CC]
          });
          return b
        },
        _uiSetAlign: function(d, e) {
          if (!c.isArray(e) || 2 !== e.length) b.error("align: Invalid Points Arguments");
          else {
            var g = this._getRegion(d),
              f, l, h;
            if (g) {
              f = e[0];
              l = e[1];
              switch (l) {
                case a.TL:
                  h = [g.left, g.top];
                  break;
                case a.TR:
                  h = [g.right, g.top];
                  break;
                case a.BL:
                  h = [g.left, g.bottom];
                  break;
                case a.BR:
                  h = [g.right, g.bottom];
                  break;
                case a.TC:
                  h = [g.left + Math.floor(g.width / 2), g.top];
                  break;
                case a.BC:
                  h = [g.left + Math.floor(g.width / 2), g.bottom];
                  break;
                case a.LC:
                  h = [g.left, g.top + Math.floor(g.height / 2)];
                  break;
                case a.RC:
                  h = [g.right, g.top + Math.floor(g.height / 2)];
                  break;
                case a.CC:
                  h = [g.left + Math.floor(g.width / 2), g.top + Math.floor(g.height / 2)]
              }
              h && this._doAlign(f, h[0], h[1])
            }
          }
        },
        _uiSetVisiblePosAlign: function(a) {
          a ? this._attachPosAlignUIHandles() : this._detachPosAlignUIHandles()
        },
        _attachPosAlignUIHandles: function() {
          if (!this._posAlignUIHandles) {
            var a =
              this.get("boundingBox"),
              c = b.bind(this._syncUIPosAlign, this),
              g = [];
            b.Array.each(this.get("alignOn"), function(f) {
              var l = f.eventName;
              f = b.one(f.node) || a;
              l && g.push(f.on(l, c))
            });
            this._posAlignUIHandles = g
          }
        },
        _detachPosAlignUIHandles: function() {
          var a = this._posAlignUIHandles;
          a && ((new b.EventHandle(a)).detach(), this._posAlignUIHandles = null)
        },
        _doAlign: function(b, c, g) {
          var f = this._posNode,
            l;
          switch (b) {
            case a.TL:
              l = [c, g];
              break;
            case a.TR:
              l = [c - f.get("offsetWidth"), g];
              break;
            case a.BL:
              l = [c, g - f.get("offsetHeight")];
              break;
            case a.BR:
              l = [c - f.get("offsetWidth"), g - f.get("offsetHeight")];
              break;
            case a.TC:
              l = [c - f.get("offsetWidth") / 2, g];
              break;
            case a.BC:
              l = [c - f.get("offsetWidth") / 2, g - f.get("offsetHeight")];
              break;
            case a.LC:
              l = [c, g - f.get("offsetHeight") / 2];
              break;
            case a.RC:
              l = [c - f.get("offsetWidth"), g - f.get("offsetHeight") / 2];
              break;
            case a.CC:
              l = [c - f.get("offsetWidth") / 2, g - f.get("offsetHeight") / 2]
          }
          l && this.move(l)
        },
        _getRegion: function(a) {
          var c;
          a ? (a = b.Node.one(a)) && (c = a.get("region")) : c = this._posNode.get("viewportRegion");
          return c
        },
        _afterAlignChange: function(a) {
          (a =
            a.newVal) && this._uiSetAlign(a.node, a.points)
        },
        _afterAlignOnChange: function(a) {
          this._detachPosAlignUIHandles();
          this.get("visible") && this._attachPosAlignUIHandles()
        }
      };
      b.WidgetPositionAlign = a
    }, "3.17.2", {
      requires: ["widget-position"]
    })
  },
  965: function(k, n) {
    YUI.add("squarespace-json-template", function(b) {
      function h(a) {
        return a.replace(/([\{\}\(\)\[\]\|\^\$\-\+\?])/g, "\\$1")
      }

      function a(a, b) {
        var f = r[a + b];
        void 0 === f && (f = "(" + h(a) + "\\S.*?" + h(b) + "\n?)", f = RegExp(f, "g"));
        return f
      }

      function c(a, b) {
        var f = [{
          context: a,
          index: -1
        }];
        return {
          PushSection: function(a) {
            if (void 0 === a || null === a) return null;
            a = "@" == a ? f[f.length - 1].context : f[f.length - 1].context[a] || null;
            f.push({
              context: a,
              index: -1
            });
            return a
          },
          Pop: function() {
            f.pop()
          },
          next: function() {
            var a = f[f.length - 1]; - 1 == a.index && (a = {
              context: null,
              index: 0
            }, f.push(a));
            var b = f[f.length - 2].context;
            if (a.index == b.length) f.pop();
            else return a.context = b[a.index++], !0
          },
          _Undefined: function(a) {
            return void 0 === b ? null : b
          },
          _LookUpStack: function(a) {
            for (var b = f.length - 1;;) {
              var c = f[b];
              if ("@index" ==
                a) {
                if (-1 != c.index) return c.index
              } else if (c = c.context, "object" === typeof c && (c = c[a], void 0 !== c)) return c;
              b--;
              if (-1 >= b) return this._Undefined(a)
            }
          },
          get: function(a) {
            if ("@" == a) return f[f.length - 1].context;
            var b = a.split("."),
              c = this._LookUpStack(b[0]);
            if (1 < b.length)
              for (var e = 1; e < b.length; e++) {
                if (null === c) return "[JSONT: Can't resolve '" + a + "'.]";
                c = c[b[e]];
                if (void 0 === c) return this._Undefined(b[e])
              }
            return c
          }
        }
      }

      function d(a, b, f) {
        for (var c = 0; c < a.length; c++) {
          var e = a[c];
          if ("string" == typeof e) f(e);
          else(0, e[0])(e[1],
            b, f)
        }
      }

      function e(a, b, f) {
        var c;
        c = b.get(a.name);
        for (var e = 0; e < a.formatters.length; e++) {
          var d = a.formatters[e];
          c = (0, d[0])(c, b, d[1])
        }
        f(c)
      }

      function g(a, b, f) {
        var c = b.PushSection(a.section_name),
          e = !1;
        c && (e = !0);
        c && 0 === c.length && (e = !1);
        e ? (d(a.Statements(), b, f), b.Pop()) : (b.Pop(), d(a.Statements("or"), b, f))
      }

      function f(a, b, f) {
        for (var c = b.get("@"), e = 0; e < a.clauses.length; e++) {
          var g = a.clauses[e],
            l = g[1];
          if ((0, g[0][0])(c, b, g[0][1])) {
            d(l, b, f);
            break
          }
        }
      }

      function l(a, b, f) {
        var c = b.PushSection(a.section_name);
        if (c && 0 < c.length) {
          var c =
            c.length - 1,
            e = a.Statements();
          a = a.Statements("alternate");
          for (var g = 0; void 0 !== b.next(); g++) d(e, b, f), g != c && d(a, b, f)
        } else d(a.Statements("or"), b, f);
        b.Pop()
      }

      function u(c, d) {
        function h(a) {
          if (a.startsWith(m)) {
            var f = d.partials[a.substr(m.length)];
            if (f) return [function(a, c, e) {
              return b.JSONTemplate.evaluateJsonTemplate(f, a)
            }, null];
            throw {
              name: "BadPartialInclude",
              message: a.substr(m) + " is not a valid partial. Remember, loops are not supported (a partial include cannot be included inside itself)."
            };
          }
          var c = s.lookup(a);
          if (!c[0]) throw {
            name: "BadFormatter",
            message: a + " is not a valid formatter"
          };
          return c
        }

        function u(a) {
          var b = r.lookup(a);
          if (!b[0]) throw {
            name: "BadPredicate",
            message: a + " is not a valid predicate"
          };
          return b
        }
        var s = new v([q(b.JSONTemplate.DEFAULT_FORMATTERS), p(b.JSONTemplate.DEFAULT_PREFIX_FORMATTERS)]),
          r = v([q(b.JSONTemplate.DEFAULT_PREDICATES), p(b.JSONTemplate.DEFAULT_PARAMETRIC_PREDICATES)]),
          J = d.format_char || "|";
        if (":" != J && "|" != J) throw {
          name: "ConfigurationError",
          message: "Only format characters : and | are accepted"
        };
        var E = d.meta || "{}",
          F = E.length;
        if (1 == F % 2) throw {
          name: "ConfigurationError",
          message: E + " has an odd number of metacharacters"
        };
        for (var K = E.substring(0, F / 2), E = E.substring(F / 2, F), F = a(K, E), z = x({}), C = [z], L = K.length, y, t, H = 0;;) {
          y = F.exec(c);
          if (null === y) break;
          else t = y[0];
          y.index > H && (H = c.slice(H, y.index), z.Append(H));
          H = F.lastIndex;
          y = !1;
          "\n" == t.slice(-1) && (t = t.slice(null, -1), y = !0);
          t = t.slice(L, -L);
          if ("#" != t.charAt(0)) {
            if ("." == t.charAt(0)) {
              t = t.substring(1, t.length);
              var B = {
                "meta-left": K,
                "meta-right": E,
                space: " ",
                tab: "\t",
                newline: "\n"
              }[t];
              if (void 0 !== B) {
                z.Append(B);
                continue
              }
              if (B = t.match(I)) {
                t = B[3];
                B[1] ? (y = l, t = w({
                  section_name: t
                })) : (y = g, t = x({
                  section_name: t
                }));
                z.Append([y, t]);
                C.push(t);
                z = t;
                continue
              }
              var D;
              if (B = t.match(k)) {
                y = (D = B[1]) ? u(D) : null;
                z.NewOrClause(y);
                continue
              }
              var B = !1,
                G = t.match(n);
              if (G) {
                if (D = G[1], B = !0, -1 == D.indexOf("?")) {
                  y = [function(a) {
                    return function(b, f) {
                      var c, e, d;
                      if (-1 !== a.indexOf(" || ")) {
                        c = a.split("||");
                        for (d = 0; d < c.length; d++)
                          if (e = c[d].trim(), f.get(e)) return !0;
                        return !1
                      }
                      if (-1 !== a.indexOf(" && ")) {
                        c = a.split(" && ");
                        for (d = 0; d < c.length; d++)
                          if (e = c[d].trim(), !f.get(e)) return !1;
                        return !0
                      }
                      return f.get(a)
                    }
                  }(D), null];
                  t = A();
                  t.NewOrClause(y);
                  z.Append([f, t]);
                  C.push(t);
                  z = t;
                  continue
                }
              } else if ("?" == t.charAt(t.length - 1) || "?" == t.split(" ")[0].charAt(t.split(" ")[0].length - 1)) D = t, B = !0;
              if (B) {
                y = D ? u(D) : null;
                t = A();
                t.NewOrClause(y);
                z.Append([f, t]);
                C.push(t);
                z = t;
                continue
              }
              if ("alternates with" == t) {
                z.AlternatesWith();
                continue
              }
              if ("end" == t) {
                C.pop();
                if (0 < C.length) z = C[C.length - 1];
                else throw {
                  name: "TemplateSyntaxError",
                  message: "Got too many {end} statements"
                };
                continue
              }
            }
            G = t.split(J);
            if (1 == G.length) B = [h("str")];
            else {
              B = [];
              for (t = 1; t < G.length; t++) B.push(h(G[t]));
              t = G[0]
            }
            z.Append([e, {
              name: t,
              formatters: B
            }]);
            y && z.Append("\n")
          }
        }
        z.Append(c.slice(H));
        if (1 !== C.length) throw {
          name: "TemplateSyntaxError",
          message: "Got too few {end} statements."
        };
        return z
      }
      b.namespace("JSONTemplate");
      var m = "apply ",
        r = {};
      b.JSONTemplate.DEFAULT_FORMATTERS = b.Squarespace.TEMPLATE_FORMATTERS;
      b.JSONTemplate.DEFAULT_PREFIX_FORMATTERS = [].concat(b.Squarespace.TEMPLATE_PREFIX_FORMATTERS, [{
        name: "pluralize",
        func: function(a, b, f) {
          switch (f.length) {
            case 0:
              b = "";
              f = "s";
              break;
            case 1:
              b = "";
              f = f[0];
              break;
            case 2:
              b = f[0];
              f = f[1];
              break;
            default:
              throw {
                name: "EvaluationError",
                message: "pluralize got too many args"
              };
          }
          return 1 == a ? b : f
        }
      }, {
        name: "encode-space",
        func: function(a, b, f) {
          return a.replace(/\s/g, "&nbsp;")
        }
      }, {
        name: "truncate",
        func: function(a, b, f) {
          b = f[0] || 100;
          f = f[1] || "...";
          a && a.length > b && (a = a.substring(0, b), a = a.replace(/\w+$/, ""), a += f);
          return a
        }
      }, {
        name: "date",
        func: function(a, f, c) {
          var e = 0,
            e = (new Date(a)).getTimezoneOffset();
          if (!b.Lang.isNumber(a)) return "Invalid date.";
          if ("undefined" !== typeof TimezoneJS) {
            var d;
            try {
              d = new TimezoneJS.Date(a, f.get("website.timeZone"))
            } catch (g) {
              return "Invalid Timezone"
            }
            e = (isNaN(d.getTimezoneOffset()) ? 0 : d.getTimezoneOffset()) - e
          } else f = -parseInt(f.get("website.timeZoneOffset"), 10) / 6E4, d = (new Date).getTimezoneOffset(), e = f - d;
          a = new Date(a - 6E4 * e);
          c = c.join(" ");
          return b.DataType.Date.format(a, {
            format: c
          })
        }
      }, {
        name: "image",
        func: function(a, f, c) {
          var e;
          a.mediaFocalPoint && (e = a.mediaFocalPoint.x + "," + a.mediaFocalPoint.y);
          return '<img class="' + (c[0] ? c[0] : "thumb-image") + '" ' + (a.title ? 'alt="' + b.Squarespace.Escaping.escapeForHtmlTag(a.title) + '" ' : "") + ' data-image="' + a.assetUrl + '" data-image-dimensions="' + a.originalSize + '" data-image-focal-point="' + e + '"/>'
        }
      }, {
        name: "timesince",
        func: function(a, f, c) {
          if (!b.Lang.isNumber(a)) return "Invalid date.";
          c.join(" ");
          return '<span class="timesince" data-date="' + a + '">' + b.Squarespace.DateUtils.humanizeDate(a) + "</span>"
        }
      }, {
        name: "resizedHeightForWidth",
        func: function(a, b, f) {
          b = a.split("x");
          if (2 != b.length) return "Invalid source parameter.  Pass in 'originalSize'.";
          a = parseInt(b[0], 10);
          b = parseInt(b[1], 10);
          f = parseInt(f[0], 10) / a;
          return parseInt(b * f, 10)
        }
      }, {
        name: "resizedWidthForHeight",
        func: function(a, b, f) {
          b = a.split("x");
          if (2 != b.length) return "Invalid source parameter.  Pass in 'originalSize'.";
          a = parseInt(b[0], 10);
          b = parseInt(b[1], 10);
          f = parseInt(f[0], 10) / b;
          return parseInt(a * f, 10)
        }
      }, {
        name: "squarespaceThumbnailForWidth",
        func: function(a, f, c) {
          return b.Squarespace.Rendering.getSquarespaceSizeForWidth(parseInt(c[0],
            10))
        }
      }, {
        name: "squarespaceThumbnailForHeight",
        func: function(a, f, c) {
          f = a.split("x");
          if (2 != f.length) return "Invalid source parameter.  Pass in 'originalSize'.";
          a = parseInt(f[0], 10);
          f = parseInt(f[1], 10);
          c = parseInt(c[0], 10) / f;
          c = parseInt(a * c, 10);
          return b.Squarespace.Rendering.getSquarespaceSizeForWidth(c)
        }
      }, {
        name: "cycle",
        func: function(a, b, f) {
          return f[(a - 1) % f.length]
        }
      }]);
      var q = function(a) {
          return {
            lookup: function(b) {
              return [a[b] || null, null]
            }
          }
        },
        p = function(a) {
          return {
            lookup: function(b) {
              for (var f = 0; f < a.length; f++) {
                var c =
                  a[f].name,
                  e = a[f].func;
                if (b.slice(0, c.length) == c) return f = b.charAt(c.length), b = "" === f ? [] : b.split(f).slice(1), [e, b]
              }
              return [null, null]
            }
          }
        },
        v = function(a) {
          return {
            lookup: function(b) {
              for (var f = 0; f < a.length; f++) {
                var c = a[f].lookup(b);
                if (c[0]) return c
              }
              return [null, null]
            }
          }
        },
        s = function(a) {
          var b = {
            current_clause: [],
            Append: function(a) {
              b.current_clause.push(a)
            },
            AlternatesWith: function() {
              throw {
                name: "TemplateSyntaxError",
                message: "{.alternates with} can only appear with in {.repeated section ...}"
              };
            },
            NewOrClause: function(a) {
              throw {
                name: "NotImplemented"
              };
            }
          };
          return b
        },
        x = function(a) {
          var b = s(a);
          b.statements = {
            "default": b.current_clause
          };
          b.section_name = a.section_name;
          b.Statements = function(a) {
            return b.statements[a || "default"] || []
          };
          b.NewOrClause = function(a) {
            if (a) throw {
              name: "TemplateSyntaxError",
              message: "{.or} clause only takes a predicate inside predicate blocks"
            };
            b.current_clause = [];
            b.statements.or = b.current_clause
          };
          return b
        },
        w = function(a) {
          var b = x(a);
          b.AlternatesWith = function() {
            b.current_clause = [];
            b.statements.alternate = b.current_clause
          };
          return b
        },
        A = function(a) {
          var b =
            s(a);
          b.clauses = [];
          b.NewOrClause = function(a) {
            a = a || [function(a) {
              return !0
            }, null];
            b.current_clause = [];
            b.clauses.push([a, b.current_clause])
          };
          return b
        },
        I = /(repeated)?\s*(section)\s+(\S+)?/,
        k = /^or(?:[\s\-]+(.+))?/,
        n = /^if(?:[\s\-]+(.+))?/;
      b.JSONTemplate.Template = Class.create({
        initialize: function(a, b, f) {
          a = this.removeMultilineComments(a);
          this._options = b || {};
          this._program = u(a, this._options)
        },
        removeMultilineComments: function(a) {
          for (var b = a.search("{##"), f; 0 <= b;) f = a.substr(b), a = a.substr(0, b) + f.substr(f.search("##}") +
            3), b = a.search("{##");
          return a
        },
        render: function(a, b) {
          var f = c(a, this._options.undefined_str);
          d(this._program.Statements(), f, b)
        },
        expand: function(a) {
          var b = [];
          this.render(a, function(a) {
            b.push(a)
          });
          return b.join("")
        }
      });
      b.JSONTemplate.DEFAULT_PREDICATES = b.Squarespace.TEMPLATE_PREDICATES;
      b.JSONTemplate.DEFAULT_PARAMETRIC_PREDICATES = b.Squarespace.TEMPLATE_PARAMETRIC_PREDICATES;
      b.JSONTemplate.evaluateJsonTemplate = function(a, f, c) {
        return "string" != typeof a ? "JSON Template Error: Processing failed because no input was provided. (type: " +
          typeof a + ", template: " + JSON.stringify(a) + ", dictionary: " + JSON.stringify(f) + ", partials: " + JSON.stringify(c) + ")" : (new b.JSONTemplate.Template(a, {
            partials: c
          })).expand(f)
      }
    }, "1.0", {
      requires: "datatype-date-format json squarespace-common squarespace-date-utils squarespace-rendering squarespace-template-helpers squarespace-util".split(" ")
    })
  },
  983: function(k, n, b) {
    var h = b(89);
    YUI.add("squarespace-product-utils", function(a) {
      a.Squarespace.ProductUtils = {
        getProductAveragePrice: function(b) {
          b = b.get("structuredContent");
          if (b.get("productType") === h.DIGITAL) return b.get("priceCents");
          b = b.get("variants");
          return a.Array.reduce(b, 0, function(a, b) {
            return a + (b.onSale ? b.salePrice : b.price)
          }) / b.length
        },
        getProductEffectiveStock: function(b) {
          b = b.get("structuredContent");
          if (b.get("productType") === h.DIGITAL) return Number.MAX_VALUE;
          b = b.get("variants");
          var d = 0;
          a.Array.some(b, function(a) {
            if (a.unlimited) return d = Number.MAX_VALUE, !0;
            d += a.qtyInStock
          });
          return d
        },
        initializeVariantDropdowns: function() {
          a.all(".product-variants[data-variants]").each(function(b) {
            var d =
              JSON.parse(b.getAttribute("data-variants")),
              e = b.all("select"),
              g = b.siblings(".product-price").item(0),
              f;
            g && (f = g.getHTML());
            a.Squarespace.ProductUtils._checkVariantStockAndPrice(b, d, e, g, f);
            e.detach("change");
            e.each(function(l) {
              l.after("change", function(l) {
                a.Squarespace.ProductUtils._checkVariantStockAndPrice(b, d, e, g, f)
              }, this)
            }, this)
          }, this)
        },
        _checkVariantStockAndPrice: function(b, d, e, g, f) {
          b.removeAttribute("data-unselected-options");
          b.removeAttribute("data-selected-variant");
          b.removeAttribute("data-variant-in-stock");
          var l = b.one(".variant-out-of-stock");
          l && l.remove();
          var h = [],
            l = null,
            m = !1,
            r = {};
          e.each(function(a) {
            var b = a.get("value"),
              f = a.getAttribute("data-variant-option-name");
            0 === a.get("selectedIndex") ? h.push(f) : r[f] = b
          }, this);
          if (0 === h.length) {
            for (e = 0; e < d.length; e++) {
              f = d[e];
              var q = !0,
                p;
              for (p in r)
                if (r[p] != f.attributes[p]) {
                  q = !1;
                  break
                }
              if (q) {
                l = f;
                if (f.unlimited || 0 < f.qtyInStock) m = !0;
                break
              }
            }!l && g ? g.set("text", "Unavailable") : g && (g.empty(), l.onSale ? (g.setHTML(a.Squarespace.Commerce.moneyString(l.salePrice)), g.append(a.Node.create('<span> </span><span class="original-price">' +
              a.Squarespace.Commerce.moneyString(l.price) + "</span>"))) : g.setHTML(a.Squarespace.Commerce.moneyString(l.price)));
            l && !m && b.append(a.Node.create('<div class="variant-out-of-stock">Out of stock.</div>'))
          } else g && g.getHTML() !== f && g.empty().setHTML(f);
          b.setAttribute("data-unselected-options", JSON.stringify(h));
          l && b.setAttribute("data-selected-variant", JSON.stringify(l));
          m && b.setAttribute("data-variant-in-stock", m)
        }
      }
    }, "1.0", {
      requires: ["base", "node", "squarespace-commerce-utils"]
    })
  },
  989: function(k, n) {
    YUI.add("selector-css2",
      function(b, h) {
        var a = b.Selector,
          c = {
            _reRegExpTokens: /([\^\$\?\[\]\*\+\-\.\(\)\|\\])/,
            SORT_RESULTS: !0,
            _isXML: "DIV" !== b.config.doc.createElement("div").tagName,
            shorthand: {
              "\\#(-?[_a-z0-9]+[-\\w\\uE000]*)": "[id=$1]",
              "\\.(-?[_a-z]+[-\\w\\uE000]*)": "[className~=$1]"
            },
            operators: {
              "": function(a, c) {
                return "" !== b.DOM.getAttribute(a, c)
              },
              "~=": "(?:^|\\s+){val}(?:\\s+|$)",
              "|=": "^{val}-?"
            },
            pseudos: {
              "first-child": function(a) {
                return b.DOM._children(a.parentNode)[0] === a
              }
            },
            _bruteQuery: function(c, e, g) {
              var f = [],
                l = [],
                h;
              c =
                a._tokenize(c);
              var m = c[c.length - 1];
              b.DOM._getDoc(e);
              var r;
              if (m) {
                h = m.id;
                r = m.className;
                m = m.tagName || "*";
                if (e.getElementsByTagName) l = h && (e.all || 9 === e.nodeType || b.DOM.inDoc(e)) ? b.DOM.allById(h, e) : r ? e.getElementsByClassName(r) : e.getElementsByTagName(m);
                else {
                  h = [];
                  e = e.firstChild;
                  for (r = "*" === m; e;) {
                    for (; e;) "@" < e.tagName && (r || e.tagName === m) && l.push(e), h.push(e), e = e.firstChild;
                    for (; 0 < h.length && !e;) e = h.pop().nextSibling
                  }
                }
                l.length && (f = a._filterNodes(l, c, g))
              }
              return f
            },
            _filterNodes: function(c, e, g) {
              for (var f = 0, l,
                  h = e.length, m = h - 1, r = [], q = c[0], p = q, v = b.Selector.getters, s, x, w, A, I, k, f = 0; p = q = c[f++];) {
                m = h - 1;
                w = null;
                a: for (; p && p.tagName;) {
                  x = e[m];
                  I = x.tests;
                  if (l = I.length)
                    for (; k = I[--l];)
                      if (s = k[1], v[k[0]] ? A = v[k[0]](p, k[0]) : (A = p[k[0]], "tagName" === k[0] && !a._isXML && (A = A.toUpperCase()), "string" != typeof A && void 0 !== A && A.toString ? A = A.toString() : void 0 === A && p.getAttribute && (A = p.getAttribute(k[0], 2))), "=" === s && A !== k[2] || "string" !== typeof s && s.test && !s.test(A) || !s.test && "function" === typeof s && !s(p, k[0], k[2])) {
                        if (p = p[w])
                          for (; p &&
                            (!p.tagName || x.tagName && x.tagName !== p.tagName);) p = p[w];
                        continue a
                      }
                  m--;
                  if (l = x.combinator) {
                    w = l.axis;
                    for (p = p[w]; p && !p.tagName;) p = p[w];
                    l.direct && (w = null)
                  } else {
                    r.push(q);
                    if (g) return r;
                    break
                  }
                }
              }
              return r
            },
            combinators: {
              " ": {
                axis: "parentNode"
              },
              ">": {
                axis: "parentNode",
                direct: !0
              },
              "+": {
                axis: "previousSibling",
                direct: !0
              }
            },
            _parsers: [{
              name: "attributes",
              re: /^\uE003(-?[a-z]+[\w\-]*)+([~\|\^\$\*!=]=?)?['"]?([^\uE004'"]*)['"]?\uE004/i,
              fn: function(c, e) {
                var g = c[2] || "",
                  f = a.operators,
                  l = c[3] ? c[3].replace(/\\/g, "") : "";
                if ("id" ===
                  c[1] && "=" === g || "className" === c[1] && b.config.doc.documentElement.getElementsByClassName && ("~=" === g || "=" === g)) e.prefilter = c[1], c[3] = l, e[c[1]] = "id" === c[1] ? c[3] : l;
                g in f && (g = f[g], "string" === typeof g && (c[3] = l.replace(a._reRegExpTokens, "\\$1"), g = RegExp(g.replace("{val}", c[3]))), c[2] = g);
                if (!e.last || e.prefilter !== c[1]) return c.slice(1)
              }
            }, {
              name: "tagName",
              re: /^((?:-?[_a-z]+[\w-]*)|\*)/i,
              fn: function(b, c) {
                var g = b[1];
                a._isXML || (g = g.toUpperCase());
                c.tagName = g;
                if ("*" !== g && (!c.last || c.prefilter)) return ["tagName",
                  "=", g
                ];
                c.prefilter || (c.prefilter = "tagName")
              }
            }, {
              name: "combinator",
              re: /^\s*([>+~]|\s)\s*/,
              fn: function(a, b) {}
            }, {
              name: "pseudos",
              re: /^:([\-\w]+)(?:\uE005['"]?([^\uE005]*)['"]?\uE006)*/i,
              fn: function(b, c) {
                var g = a.pseudos[b[1]];
                return g ? (b[2] && (b[2] = b[2].replace(/\\/g, "")), [b[2], g]) : !1
              }
            }],
            _getToken: function(a) {
              return {
                tagName: null,
                id: null,
                className: null,
                attributes: {},
                combinator: null,
                tests: []
              }
            },
            _tokenize: function(c) {
              c = a._parseSelector(b.Lang.trim(c || ""));
              var e = a._getToken(),
                g = [],
                f = !1,
                l, h, m;
              a: do {
                f = !1;
                for (h =
                  0; m = a._parsers[h++];)
                  if (l = m.re.exec(c)) {
                    "combinator" !== m.name && (e.selector = c);
                    c = c.replace(l[0], "");
                    c.length || (e.last = !0);
                    a._attrFilters[l[1]] && (l[1] = a._attrFilters[l[1]]);
                    f = m.fn(l, e);
                    if (!1 === f) {
                      f = !1;
                      break a
                    } else f && e.tests.push(f);
                    if (!c.length || "combinator" === m.name) g.push(e), e = a._getToken(e), "combinator" === m.name && (e.combinator = b.Selector.combinators[l[1]]);
                    f = !0
                  }
              } while (f && c.length);
              if (!f || c.length) g = [];
              return g
            },
            _replaceMarkers: function(a) {
              a = a.replace(/\[/g, "\ue003");
              a = a.replace(/\]/g, "\ue004");
              a = a.replace(/\(/g, "\ue005");
              return a = a.replace(/\)/g, "\ue006")
            },
            _replaceShorthand: function(a) {
              var c = b.Selector.shorthand,
                g;
              for (g in c) c.hasOwnProperty(g) && (a = a.replace(RegExp(g, "gi"), c[g]));
              return a
            },
            _parseSelector: function(a) {
              var c = b.Selector._replaceSelector(a);
              a = c.selector;
              a = b.Selector._replaceShorthand(a);
              a = b.Selector._restore("attr", a, c.attrs);
              a = b.Selector._restore("pseudo", a, c.pseudos);
              a = b.Selector._replaceMarkers(a);
              return a = b.Selector._restore("esc", a, c.esc)
            },
            _attrFilters: {
              "class": "className",
              "for": "htmlFor"
            },
            getters: {
              href: function(a, c) {
                return b.DOM.getAttribute(a, c)
              },
              id: function(a, c) {
                return b.DOM.getId(a)
              }
            }
          };
        b.mix(b.Selector, c, !0);
        b.Selector.getters.src = b.Selector.getters.rel = b.Selector.getters.href;
        b.Selector.useNative && b.config.doc.querySelector && (b.Selector.shorthand["\\.(-?[_a-z]+[-\\w]*)"] = "[class~=$1]")
      }, "3.17.2", {
        requires: ["selector-native"]
      })
  },
  990: function(k, n) {
    YUI.add("selector-css3", function(b, h) {
      b.Selector._reNth = /^(?:([\-]?\d*)(n){1}|(odd|even)$)*([\-+]?\d*)$/;
      b.Selector._getNth =
        function(a, c, d, e) {
          b.Selector._reNth.test(c);
          c = parseInt(RegExp.$1, 10);
          var g = RegExp.$2,
            f = RegExp.$3,
            l = parseInt(RegExp.$4, 10) || 0;
          d = b.DOM._children(a.parentNode, d);
          f ? (c = 2, l = "odd" === f ? 1 : 0) : isNaN(c) && (c = g ? 1 : 0);
          if (0 === c) return e && (l = d.length - l + 1), d[l - 1] === a ? !0 : !1;
          0 > c && (e = !!e, c = Math.abs(c));
          if (e) {
            e = d.length - l;
            for (g = d.length; 0 <= e; e -= c)
              if (e < g && d[e] === a) return !0
          } else {
            e = l - 1;
            for (g = d.length; e < g; e += c)
              if (0 <= e && d[e] === a) return !0
          }
          return !1
        };
      b.mix(b.Selector.pseudos, {
        root: function(a) {
          return a === a.ownerDocument.documentElement
        },
        "nth-child": function(a, c) {
          return b.Selector._getNth(a, c)
        },
        "nth-last-child": function(a, c) {
          return b.Selector._getNth(a, c, null, !0)
        },
        "nth-of-type": function(a, c) {
          return b.Selector._getNth(a, c, a.tagName)
        },
        "nth-last-of-type": function(a, c) {
          return b.Selector._getNth(a, c, a.tagName, !0)
        },
        "last-child": function(a) {
          var c = b.DOM._children(a.parentNode);
          return c[c.length - 1] === a
        },
        "first-of-type": function(a) {
          return b.DOM._children(a.parentNode, a.tagName)[0] === a
        },
        "last-of-type": function(a) {
          var c = b.DOM._children(a.parentNode,
            a.tagName);
          return c[c.length - 1] === a
        },
        "only-child": function(a) {
          var c = b.DOM._children(a.parentNode);
          return 1 === c.length && c[0] === a
        },
        "only-of-type": function(a) {
          var c = b.DOM._children(a.parentNode, a.tagName);
          return 1 === c.length && c[0] === a
        },
        empty: function(a) {
          return 0 === a.childNodes.length
        },
        not: function(a, c) {
          return !b.Selector.test(a, c)
        },
        contains: function(a, b) {
          return -1 < (a.innerText || a.textContent || "").indexOf(b)
        },
        checked: function(a) {
          return !0 === a.checked || !0 === a.selected
        },
        enabled: function(a) {
          return void 0 !==
            a.disabled && !a.disabled
        },
        disabled: function(a) {
          return a.disabled
        }
      });
      b.mix(b.Selector.operators, {
        "^=": "^{val}",
        "$=": "{val}$",
        "*=": "{val}"
      });
      b.Selector.combinators["~"] = {
        axis: "previousSibling"
      }
    }, "3.17.2", {
      requires: ["selector-native", "selector-css2"]
    })
  },
  1071: function(k, n) {
    YUI.add("squarespace-async-form", function(b) {
        b.namespace("Squarespace.Widgets");
        var h = b.Squarespace.Widgets.AsyncForm = b.Base.create("AsyncForm", b.Squarespace.Widgets.SSWidget, [], {
          initializer: function() {
            this._typeGetterMap = {
              date: this._getMultiFieldVal,
              name: this._getMultiFieldVal,
              time: this._getMultiFieldVal,
              address: this._getMultiFieldVal,
              checkbox: this._getOptionFieldVal,
              likert: this._getLikertFieldVal,
              radio: this._getRadioFieldVal,
              select: this._getSelectVal,
              phone: this._getPhoneFieldVal
            };
            this._typeSetterMap = {
              date: this._setMultiFieldVal,
              name: this._setMultiFieldVal,
              time: this._setMultiFieldVal,
              address: this._setMultiFieldVal,
              checkbox: this._setOptionFieldVal,
              likert: this._setLikertFieldVal,
              radio: this._setRadioFieldVal,
              select: this._setSelectVal,
              phone: this._setPhoneFieldVal
            };
            this._defaultGetter = this._getSingleFieldVal;
            this._defaultSetter = this._setSingleFieldVal
          },
          renderUI: function() {
            h.superclass.renderUI.call(this);
            var a = this.get("form"),
              c = a.fields;
            b.Lang.isString(c[0]) && (c = b.Array.map(c, b.JSON.parse));
            var c = {
                showTitle: this.get("showTitle"),
                preventSubmit: this.get("preventDefaultSubmit") || this.get("preventAllSubmits"),
                hideSubmitButton: this.get("hideSubmitButton"),
                formId: a.id,
                formName: this.get("formName"),
                formFields: c,
                formSubmitButtonText: this.get("formSubmitButtonText"),
                formSubmissionMessage: a.parsedSubmissionMessage,
                formSubmissionHTML: a.submissionHTML
              },
              a = this.get("contentBox"),
              d = this.get("formTemplate").html,
              c = b.JSONTemplate.evaluateJsonTemplate(d, c);
            a.append(c);
            this._formEl = a.one("form");
            this._setFormData()
          },
          bindUI: function() {
            this._formEl.on("submit", function(a) {
              if (this.get("preventDefaultSubmit") && !this.get("preventAllSubmits")) {
                this._clearErrors();
                var c = this._validateForm(),
                  d = c.errors;
                0 < d.length ? this._renderErrors(d) : this.fetchValidatedFormSubmission(this.get("form").id,
                  b.bind(function() {
                    this.fire("submission", {
                      data: c.data
                    })
                  }, this), b.bind(function(a) {
                    var c = [];
                    b.Object.each(a.errors, function(a, b) {
                      c.push({
                        fieldId: b,
                        message: a
                      })
                    });
                    this._renderErrors(c)
                  }, this))
              }
              a.halt()
            }, this);
            this.after("formDataChange", this._setFormData, this)
          },
          setStateSaving: function() {
            var a = this.get("contentBox");
            a.addClass("saving");
            a.one('input[type="submit"]').set("value", "Saving...")
          },
          setStateEditing: function() {
            var a = this.get("contentBox"),
              b = this.get("formSubmitButtonText");
            a.one('input[type="submit"]').set("value",
              b);
            a.removeClass("saving")
          },
          getLocalValidationErrors: function() {
            return this._validateForm().errors
          },
          fetchValidatedFormSubmission: function(a, c, d) {
            b.Data.post({
              url: "/api/rest/forms/validate/" + a,
              headers: {
                "Content-Type": "application/json"
              },
              data: JSON.stringify(this.getFormData()),
              success: c,
              failure: d
            })
          },
          getFormData: function() {
            return this._validateForm().data
          },
          _renderErrors: function(a) {
            b.Array.each(a, function(a) {
              this.get("contentBox").one("#" + a.fieldId).one(".title").insert('<div class="field-error">' + a.message +
                "</div>", "before")
            }, this)
          },
          _clearErrors: function() {
            this.get("contentBox").all(".field-error").remove(!0)
          },
          _validateForm: function() {
            var a = {},
              b = [];
            this._formEl.all(".form-item").each(function(d) {
              var e = d.getAttribute("id");
              if (d = this._getFieldData(d)) {
                var g = d.error;
                g && b.push({
                  fieldId: e,
                  message: g
                });
                a[e] = d.data
              }
            }, this);
            return {
              data: a,
              errors: b
            }
          },
          _getFieldData: function(a) {
            var c = a.get("className").split(" "),
              d = null,
              e, g = !1;
            b.Array.each(c, function(a) {
              b.Object.hasKey(this._typeGetterMap, a) ? (d = a, e = this._typeGetterMap[d]) :
                "section" === a && (g = !0)
            }, this);
            if (!g) return null === d && (e = this._defaultGetter), e.call(this, a)
          },
          _getSingleFieldVal: function(a) {
            var c = a.one(".field-element");
            if (c) {
              var d = c.get("value"),
                e, d = !b.Lang.isValue(d) || "" === d;
              a.hasClass("required") && d && (e = "Required");
              return {
                data: c.get("value"),
                error: e
              }
            }
            return null
          },
          _getMultiFieldVal: function(a) {
            var c = [],
              d, e = !1;
            a.all(".field-element").each(function(a) {
              var f = a.get("value");
              b.Lang.isValue(f) && "" !== f && (e = !0);
              c.push(a.get("value"))
            });
            a.hasClass("required") && !e && (d = "Required");
            return {
              data: c,
              error: d
            }
          },
          _getOptionFieldVal: function(a) {
            var b = [],
              d;
            a.all("input").each(function(a) {
              a.get("checked") && b.push(a.get("value"))
            }, this);
            a.hasClass("required") && 0 === b.length && (d = "Required");
            return {
              data: b,
              error: d
            }
          },
          _getLikertFieldVal: function(a) {
            var c = {};
            a.all(".item").each(function(a) {
              var e;
              a.all("input").each(function(a) {
                a.get("checked") && (e = a.get("value"))
              });
              b.Lang.isValue(e) && (c[a.getAttribute("data-question")] = e)
            });
            return {
              data: c,
              error: void 0
            }
          },
          _getRadioFieldVal: function(a) {
            var c, d;
            a.all("input").each(function(a) {
              a.get("checked") &&
                (c = a.get("value"))
            }, this);
            a.hasClass("required") && !b.Lang.isValue(c) && (d = "Required");
            return {
              data: c,
              error: d
            }
          },
          _getSelectVal: function(a) {
            var c = a.one("select").get("value"),
              d, e = !b.Lang.isValue(c) || "" === c;
            a.hasClass("required") && e && (d = "Required");
            return {
              data: c,
              error: d
            }
          },
          _getPhoneFieldVal: function(a) {
            a = this._getMultiFieldVal(a);
            var b = a.data;
            b && 3 === b.length && b.unshift("");
            return a
          },
          _setFormData: function() {
            var a = this.get("formData");
            null !== a && this._formEl.all(".form-item").each(function(c) {
              var d = a[c.getAttribute("id")];
              if (d) {
                var e = d.value,
                  d = b.Lang.isValue(e) ? e : d.values || [];
                this._setFieldData(c, d)
              }
            }, this)
          },
          _setFieldData: function(a, c) {
            var d = a.get("className").split(" "),
              e = null,
              g, f;
            b.Array.each(d, function(d) {
              b.Object.hasKey(this._typeSetterMap, d) ? (e = d, g = this._typeSetterMap[e]) : "section" === d && (f = !0);
              if (!f) return null === e && (g = this._defaultSetter), g.call(this, a, c)
            }, this)
          },
          _setSingleFieldVal: function(a, b) {
            var d = a.one(".field-element");
            if (d) return d.set("value", b)
          },
          _setMultiFieldVal: function(a, b) {
            a.all(".field-element").each(function(a) {
              a.set("value",
                b[a.getData("title")])
            })
          },
          _setOptionFieldVal: function(a, b) {
            a.all("input").each(function(a) {
              -1 !== b.indexOf(a.get("value")) && a.setAttribute("checked", "checked")
            }, this)
          },
          _setLikertFieldVal: function(a, c) {
            a.all(".item").each(function(a) {
              var e = a.getAttribute("data-question"),
                e = c[e];
              b.Lang.isValue(e) && "" !== e && (e = parseInt(e, 10) + 2, a.all("input").item(e).setAttribute("checked", "checked"))
            })
          },
          _setRadioFieldVal: function(a, b) {
            a.all("input").each(function(a) {
                a.get("value") === b && a.setAttribute("checked", "checked")
              },
              this)
          },
          _setSelectVal: function(a, b) {
            a.one("select").set("value", b)
          },
          _setPhoneFieldVal: function(a, b) {
            3 === a.all(".field").size() && 4 === b.length && b.shift();
            this._setMultiFieldVal(a, b)
          }
        }, {
          CSS_PREFIX: "sqs-async-form",
          ATTRS: {
            form: {
              value: {
                fields: []
              },
              validator: b.Lang.isValue
            },
            formTemplate: {
              value: null
            },
            hideSubmitButton: {
              value: !1
            },
            formSubmitButtonText: {
              value: "Add to Cart"
            },
            formName: {
              value: "My Form Name"
            },
            formData: {
              value: null
            },
            showTitle: {
              value: !0
            },
            preventDefaultSubmit: {
              value: !0
            },
            preventAllSubmits: {
              value: !1
            }
          }
        })
      },
      "1.0", {
        requires: ["base", "node", "json", "squarespace-ss-widget", "squarespace-json-template"]
      })
  },
  1088: function(k, n) {
    YUI.add("autocomplete-base", function(b, h) {
      function a() {}
      var c = b.Escape,
        d = b.Lang,
        e = b.Array,
        g = b.Object,
        f = d.isFunction,
        l = d.isString,
        u = d.trim,
        m = b.Attribute.INVALID_VALUE,
        r = "_sourceSuccess";
      a.prototype = {
        initializer: function() {
          b.before(this._bindUIACBase, this, "bindUI");
          b.before(this._syncUIACBase, this, "syncUI");
          this.publish("clear", {
            defaultFn: this._defClearFn
          });
          this.publish("query", {
            defaultFn: this._defQueryFn
          });
          this.publish("results", {
            defaultFn: this._defResultsFn
          })
        },
        destructor: function() {
          this._acBaseEvents && this._acBaseEvents.detach();
          delete this._acBaseEvents;
          delete this._cache;
          delete this._inputNode;
          delete this._rawSource
        },
        clearCache: function() {
          this._cache && (this._cache = {});
          return this
        },
        sendRequest: function(a, f) {
          var c, e = this.get("source");
          a || "" === a ? this._set("query", a) : a = this.get("query") || "";
          e && (f || (f = this.get("requestTemplate")), c = f ? f.call(this, a) : a, e.sendRequest({
            query: a,
            request: c,
            callback: {
              success: b.bind(this._onResponse,
                this, a)
            }
          }));
          return this
        },
        _bindUIACBase: function() {
          var a = this.get("inputNode"),
            f = a && a.tokenInput;
          f && (a = f.get("inputNode"), this._set("tokenInput", f));
          a ? (this._inputNode = a, this._acBaseEvents = new b.EventHandle([a.on("valueChange", this._onInputValueChange, this), a.on("blur", this._onInputBlur, this), this.after("allowBrowserAutocompleteChange", this._syncBrowserAutocomplete), this.after("sourceTypeChange", this._afterSourceTypeChange), this.after("valueChange", this._afterValueChange)])) : b.error("No inputNode specified.")
        },
        _syncUIACBase: function() {
          this._syncBrowserAutocomplete();
          this.set("value", this.get("inputNode").get("value"))
        },
        _createArraySource: function(a) {
          var b = this;
          return {
            type: "array",
            sendRequest: function(f) {
              b[r](a.concat(), f)
            }
          }
        },
        _createFunctionSource: function(a) {
          var b = this;
          return {
            type: "function",
            sendRequest: function(f) {
              function c(a) {
                b[r](a || [], f)
              }
              var e;
              (e = a(f.query, c)) && c(e)
            }
          }
        },
        _createObjectSource: function(a) {
          var b = this;
          return {
            type: "object",
            sendRequest: function(f) {
              var c = f.query;
              b[r](g.owns(a, c) ? a[c] : [], f)
            }
          }
        },
        _functionValidator: function(a) {
          return null === a || f(a)
        },
        _getObjectValue: function(a, b) {
          if (a) {
            for (var f = 0, c = b.length; a && f < c; f++) a = a[b[f]];
            return a
          }
        },
        _parseResponse: function(a, b, f) {
          f = {
            data: f,
            query: a,
            results: []
          };
          var e = this.get("resultListLocator"),
            g = [],
            d = b && b.results,
            l, h, u, m;
          d && e && (d = e.call(this, d));
          if (d && d.length) {
            l = this.get("resultFilters");
            m = this.get("resultTextLocator");
            b = 0;
            for (e = d.length; b < e; ++b) h = d[b], u = m ? m.call(this, h) : h.toString(), g.push({
              display: c.html(u),
              raw: h,
              text: u
            });
            b = 0;
            for (e = l.length; b < e; ++b) {
              g =
                l[b].call(this, a, g.concat());
              if (!g) return;
              if (!g.length) break
            }
            if (g.length) {
              d = this.get("resultFormatter");
              b = this.get("resultHighlighter");
              if ((e = this.get("maxResults")) && 0 < e && g.length > e) g.length = e;
              if (b) {
                l = b.call(this, a, g.concat());
                if (!l) return;
                b = 0;
                for (e = l.length; b < e; ++b) h = g[b], h.highlighted = l[b], h.display = h.highlighted
              }
              if (d) {
                a = d.call(this, a, g.concat());
                if (!a) return;
                b = 0;
                for (e = a.length; b < e; ++b) g[b].display = a[b]
              }
            }
          }
          f.results = g;
          this.fire("results", f)
        },
        _parseValue: function(a) {
          var b = this.get("queryDelimiter");
          b && (a = a.split(b), a = a[a.length - 1]);
          return d.trimLeft(a)
        },
        _setEnableCache: function(a) {
          this._cache = a ? {} : null
        },
        _setLocator: function(a) {
          if (this._functionValidator(a)) return a;
          var b = this;
          a = a.toString().split(".");
          return function(f) {
            return f && b._getObjectValue(f, a)
          }
        },
        _setRequestTemplate: function(a) {
          if (this._functionValidator(a)) return a;
          a = a.toString();
          return function(b) {
            return d.sub(a, {
              query: encodeURIComponent(b)
            })
          }
        },
        _setResultFilters: function(a) {
          var c, g;
          if (null === a) return [];
          c = b.AutoCompleteFilters;
          g = function(a) {
            return f(a) ?
              a : l(a) && c && f(c[a]) ? c[a] : !1
          };
          return d.isArray(a) ? (a = e.map(a, g), e.every(a, function(a) {
            return !!a
          }) ? a : m) : (a = g(a)) ? [a] : m
        },
        _setResultHighlighter: function(a) {
          var c;
          if (this._functionValidator(a)) return a;
          c = b.AutoCompleteHighlighters;
          return l(a) && c && f(c[a]) ? c[a] : m
        },
        _setSource: function(c) {
          var e = this.get("sourceType") || d.type(c),
            g;
          if (c && f(c.sendRequest) || null === c || "datasource" === e) return this._rawSource = c;
          if (g = a.SOURCE_TYPES[e]) return this._rawSource = c, d.isString(g) ? this[g](c) : g(c);
          b.error("Unsupported source type '" +
            e + "'. Maybe autocomplete-sources isn't loaded?");
          return m
        },
        _sourceSuccess: function(a, b) {
          b.callback.success({
            data: a,
            response: {
              results: a
            }
          })
        },
        _syncBrowserAutocomplete: function() {
          var a = this.get("inputNode");
          "input" === a.get("nodeName").toLowerCase() && a.setAttribute("autocomplete", this.get("allowBrowserAutocomplete") ? "on" : "off")
        },
        _updateValue: function(a) {
          var b = this.get("queryDelimiter"),
            f, c;
          a = d.trimLeft(a);
          b && (f = u(b), c = e.map(u(this.get("value")).split(b), u), b = c.length, 1 < b && (c[b - 1] = a, a = c.join(f + " ")), a =
            a + f + " ");
          this.set("value", a)
        },
        _afterSourceTypeChange: function(a) {
          this._rawSource && this.set("source", this._rawSource)
        },
        _afterValueChange: function(b) {
          var f = b.newVal,
            c = this,
            e = b.src === a.UI_SRC,
            g, d;
          e || c._inputNode.set("value", f);
          g = c.get("minQueryLength");
          d = c._parseValue(f) || "";
          0 <= g && d.length >= g ? e ? (e = c.get("queryDelay"), g = function() {
            c.fire("query", {
              inputValue: f,
              query: d,
              src: b.src
            })
          }, e ? (clearTimeout(c._delay), c._delay = setTimeout(g, e)) : g()) : c._set("query", d) : (clearTimeout(c._delay), c.fire("clear", {
            prevVal: b.prevVal ?
              c._parseValue(b.prevVal) : null,
            src: b.src
          }))
        },
        _onInputBlur: function(a) {
          a = this.get("queryDelimiter");
          var b, f, c;
          if (a && !this.get("allowTrailingDelimiter")) {
            a = d.trimRight(a);
            c = f = this._inputNode.get("value");
            if (a)
              for (;
                (f = d.trimRight(f)) && (b = f.length - a.length) && f.lastIndexOf(a) === b;) f = f.substring(0, b);
            else f = d.trimRight(f);
            f !== c && this.set("value", f)
          }
        },
        _onInputValueChange: function(b) {
          b = b.newVal;
          b !== this.get("value") && this.set("value", b, {
            src: a.UI_SRC
          })
        },
        _onResponse: function(a, b) {
          if (a === (this.get("query") ||
              "")) this._parseResponse(a || "", b.response, b.data)
        },
        _defClearFn: function() {
          this._set("query", null);
          this._set("results", [])
        },
        _defQueryFn: function(a) {
          this.sendRequest(a.query)
        },
        _defResultsFn: function(a) {
          this._set("results", a.results)
        }
      };
      a.ATTRS = {
        allowBrowserAutocomplete: {
          value: !1
        },
        allowTrailingDelimiter: {
          value: !1
        },
        enableCache: {
          lazyAdd: !1,
          setter: "_setEnableCache",
          value: !0
        },
        inputNode: {
          setter: b.one,
          writeOnce: "initOnly"
        },
        maxResults: {
          value: 0
        },
        minQueryLength: {
          value: 1
        },
        query: {
          readOnly: !0,
          value: null
        },
        queryDelay: {
          value: 100
        },
        queryDelimiter: {
          value: null
        },
        requestTemplate: {
          setter: "_setRequestTemplate",
          value: null
        },
        resultFilters: {
          setter: "_setResultFilters",
          value: []
        },
        resultFormatter: {
          validator: "_functionValidator",
          value: null
        },
        resultHighlighter: {
          setter: "_setResultHighlighter",
          value: null
        },
        resultListLocator: {
          setter: "_setLocator",
          value: null
        },
        results: {
          readOnly: !0,
          value: []
        },
        resultTextLocator: {
          setter: "_setLocator",
          value: null
        },
        source: {
          setter: "_setSource",
          value: null
        },
        sourceType: {
          value: null
        },
        tokenInput: {
          readOnly: !0
        },
        value: {
          value: ""
        }
      };
      a._buildCfg = {
        aggregates: ["SOURCE_TYPES"],
        statics: ["UI_SRC"]
      };
      a.SOURCE_TYPES = {
        array: "_createArraySource",
        "function": "_createFunctionSource",
        object: "_createObjectSource"
      };
      a.UI_SRC = b.Widget && b.Widget.UI_SRC || "ui";
      b.AutoCompleteBase = a
    }, "3.17.2", {
      optional: ["autocomplete-sources"],
      requires: ["array-extras", "base-build", "escape", "event-valuechange", "node-base"]
    })
  },
  1089: function(k, n) {
    YUI.add("autocomplete-list", function(b, h) {
      var a = b.Lang,
        c = b.Node,
        d = b.Array,
        e = b.UA.ie && 7 > b.UA.ie,
        g = b.Base.create("autocompleteList",
          b.Widget, [b.AutoCompleteBase, b.WidgetPosition, b.WidgetPositionAlign], {
            ARIA_TEMPLATE: "<div/>",
            ITEM_TEMPLATE: "<li/>",
            LIST_TEMPLATE: "<ul/>",
            UI_EVENTS: function() {
              var a = b.merge(b.Node.DOM_EVENTS);
              delete a.valuechange;
              delete a.valueChange;
              return a
            }(),
            initializer: function() {
              var a = this.get("inputNode");
              a ? (this._inputNode = a, this._listEvents = [], this.DEF_PARENT_NODE = a.get("parentNode"), this._CLASS_ITEM = this.getClassName("item"), this._CLASS_ITEM_ACTIVE = this.getClassName("item", "active"), this._CLASS_ITEM_HOVER =
                this.getClassName("item", "hover"), this._SELECTOR_ITEM = "." + this._CLASS_ITEM, this.publish("select", {
                  defaultFn: this._defSelectFn
                })) : b.error("No inputNode specified.")
            },
            destructor: function() {
              for (; this._listEvents.length;) this._listEvents.pop().detach();
              this._ariaNode && this._ariaNode.remove().destroy(!0)
            },
            bindUI: function() {
              this._bindInput();
              this._bindList()
            },
            renderUI: function() {
              var a = this._createAriaNode(),
                c = this.get("boundingBox"),
                g = this.get("contentBox"),
                d = this._inputNode,
                h = this._createListNode(),
                q =
                d.get("parentNode");
              d.addClass(this.getClassName("input")).setAttrs({
                "aria-autocomplete": "list",
                "aria-expanded": !1,
                "aria-owns": h.get("id")
              });
              q.append(a);
              e && c.plug(b.Plugin.Shim);
              this._ariaNode = a;
              this._boundingBox = c;
              this._contentBox = g;
              this._listNode = h;
              this._parentNode = q
            },
            syncUI: function() {
              this._syncResults();
              this._syncVisibility()
            },
            hide: function() {
              return this.get("alwaysShowList") ? this : this.set("visible", !1)
            },
            selectItem: function(a, b) {
              if (a) {
                if (!a.hasClass(this._CLASS_ITEM)) return this
              } else if (a = this.get("activeItem"), !a) return this;
              this.fire("select", {
                itemNode: a,
                originEvent: b || null,
                result: a.getData("result")
              });
              return this
            },
            _activateNextItem: function() {
              var a = this.get("activeItem"),
                a = a ? a.next(this._SELECTOR_ITEM) || (this.get("circular") ? null : a) : this._getFirstItemNode();
              this.set("activeItem", a);
              return this
            },
            _activatePrevItem: function() {
              var a = this.get("activeItem"),
                a = a ? a.previous(this._SELECTOR_ITEM) : this.get("circular") && this._getLastItemNode();
              this.set("activeItem", a || null);
              return this
            },
            _add: function(f) {
              var c = [];
              d.each(a.isArray(f) ? f : [f], function(a) {
                c.push(this._createItemNode(a).setData("result", a))
              }, this);
              c = b.all(c);
              this._listNode.append(c.toFrag());
              return c
            },
            _ariaSay: function(b, c) {
              var e = this.get("strings." + b);
              this._ariaNode.set("text", c ? a.sub(e, c) : e)
            },
            _bindInput: function() {
              var a = this._inputNode,
                b, c;
              null === this.get("align") && (b = (b = this.get("tokenInput")) && b.get("boundingBox") || a, this.set("align", {
                node: b,
                points: ["tl", "bl"]
              }), !this.get("width") && (c = b.get("offsetWidth")) && this.set("width", c));
              this._listEvents =
                this._listEvents.concat([a.after("blur", this._afterListInputBlur, this), a.after("focus", this._afterListInputFocus, this)])
            },
            _bindList: function() {
              this._listEvents = this._listEvents.concat([b.one("doc").after("click", this._afterDocClick, this), b.one("win").after("windowresize", this._syncPosition, this), this.after({
                mouseover: this._afterMouseOver,
                mouseout: this._afterMouseOut,
                activeItemChange: this._afterActiveItemChange,
                alwaysShowListChange: this._afterAlwaysShowListChange,
                hoveredItemChange: this._afterHoveredItemChange,
                resultsChange: this._afterResultsChange,
                visibleChange: this._afterVisibleChange
              }), this._listNode.delegate("click", this._onItemClick, this._SELECTOR_ITEM, this)])
            },
            _clear: function() {
              this.set("activeItem", null);
              this._set("hoveredItem", null);
              this._listNode.get("children").remove(!0)
            },
            _createAriaNode: function() {
              return c.create(this.ARIA_TEMPLATE).addClass(this.getClassName("aria")).setAttrs({
                "aria-live": "polite",
                role: "status"
              })
            },
            _createItemNode: function(a) {
              var e = c.create(this.ITEM_TEMPLATE);
              return e.addClass(this._CLASS_ITEM).setAttrs({
                id: b.stamp(e),
                role: "option"
              }).setAttribute("data-text", a.text).append(a.display)
            },
            _createListNode: function() {
              var a = this.get("listNode") || c.create(this.LIST_TEMPLATE);
              a.addClass(this.getClassName("list")).setAttrs({
                id: b.stamp(a),
                role: "listbox"
              });
              this._set("listNode", a);
              this.get("contentBox").append(a);
              return a
            },
            _getFirstItemNode: function() {
              return this._listNode.one(this._SELECTOR_ITEM)
            },
            _getLastItemNode: function() {
              return this._listNode.one(this._SELECTOR_ITEM + ":last-child")
            },
            _syncPosition: function() {
              this._syncUIPosAlign();
              this._syncShim()
            },
            _syncResults: function(a) {
              a || (a = this.get("results"));
              this._clear();
              a.length && (this._add(a), this._ariaSay("items_available"));
              this._syncPosition();
              this.get("activateFirstItem") && !this.get("activeItem") && this.set("activeItem", this._getFirstItemNode())
            },
            _syncShim: e ? function() {
              var a = this._boundingBox.shim;
              a && a.sync()
            } : function() {},
            _syncVisibility: function(a) {
              this.get("alwaysShowList") && (a = !0, this.set("visible", a));
              "undefined" === typeof a && (a = this.get("visible"));
              this._inputNode.set("aria-expanded",
                a);
              this._boundingBox.set("aria-hidden", !a);
              a ? this._syncPosition() : (this.set("activeItem", null), this._set("hoveredItem", null), this._boundingBox.get("offsetWidth"));
              7 === b.UA.ie && b.one("body").addClass("yui3-ie7-sucks").removeClass("yui3-ie7-sucks")
            },
            _afterActiveItemChange: function(a) {
              var c = this._inputNode,
                e = a.newVal;
              (a = a.prevVal) && a._node && a.removeClass(this._CLASS_ITEM_ACTIVE);
              e ? (e.addClass(this._CLASS_ITEM_ACTIVE), c.set("aria-activedescendant", e.get("id"))) : c.removeAttribute("aria-activedescendant");
              this.get("scrollIntoView") && (c = e || c, (!c.inRegion(b.DOM.viewportRegion(), !0) || !c.inRegion(this._contentBox, !0)) && c.scrollIntoView())
            },
            _afterAlwaysShowListChange: function(a) {
              this.set("visible", a.newVal || 0 < this.get("results").length)
            },
            _afterDocClick: function(a) {
              var b = this._boundingBox;
              a = a.target;
              a !== this._inputNode && (a !== b && !a.ancestor("#" + b.get("id"), !0)) && this.hide()
            },
            _afterHoveredItemChange: function(a) {
              var b = a.newVal;
              (a = a.prevVal) && a.removeClass(this._CLASS_ITEM_HOVER);
              b && b.addClass(this._CLASS_ITEM_HOVER)
            },
            _afterListInputBlur: function() {
              this._listInputFocused = !1;
              this.get("visible") && (!this._mouseOverList && (9 !== this._lastInputKey || !this.get("tabSelect") || !this.get("activeItem"))) && this.hide()
            },
            _afterListInputFocus: function() {
              this._listInputFocused = !0
            },
            _afterMouseOver: function(a) {
              a = a.domEvent.target.ancestor(this._SELECTOR_ITEM, !0);
              this._mouseOverList = !0;
              a && this._set("hoveredItem", a)
            },
            _afterMouseOut: function() {
              this._mouseOverList = !1;
              this._set("hoveredItem", null)
            },
            _afterResultsChange: function(a) {
              this._syncResults(a.newVal);
              this.get("alwaysShowList") || this.set("visible", !!a.newVal.length)
            },
            _afterVisibleChange: function(a) {
              this._syncVisibility(!!a.newVal)
            },
            _onItemClick: function(a) {
              var b = a.currentTarget;
              this.set("activeItem", b);
              this.selectItem(b, a)
            },
            _defSelectFn: function(a) {
              a = a.result.text;
              this._inputNode.focus();
              this._updateValue(a);
              this._ariaSay("item_selected", {
                item: a
              });
              this.hide()
            }
          }, {
            ATTRS: {
              activateFirstItem: {
                value: !1
              },
              activeItem: {
                setter: b.one,
                value: null
              },
              alwaysShowList: {
                value: !1
              },
              circular: {
                value: !0
              },
              hoveredItem: {
                readOnly: !0,
                value: null
              },
              listNode: {
                writeOnce: "initOnly",
                value: null
              },
              scrollIntoView: {
                value: !1
              },
              strings: {
                valueFn: function() {
                  return b.Intl.get("autocomplete-list")
                }
              },
              tabSelect: {
                value: !0
              },
              visible: {
                value: !1
              }
            },
            CSS_PREFIX: b.ClassNameManager.getClassName("aclist")
          });
      b.AutoCompleteList = g;
      b.AutoComplete = g
    }, "3.17.2", {
      lang: ["en", "es", "hu", "it"],
      requires: "autocomplete-base event-resize node-screen selector-css3 shim-plugin widget widget-position widget-position-align".split(" "),
      skinnable: !0
    })
  },
  1090: function(k, n) {
    YUI.add("autocomplete-plugin",
      function(b, h) {
        function a(b) {
          b.inputNode = b.host;
          !b.render && !1 !== b.render && (b.render = !0);
          a.superclass.constructor.apply(this, arguments)
        }
        var c = b.Plugin;
        b.extend(a, b.AutoCompleteList, {}, {
          NAME: "autocompleteListPlugin",
          NS: "ac",
          CSS_PREFIX: b.ClassNameManager.getClassName("aclist")
        });
        c.AutoComplete = a;
        c.AutoCompleteList = a
      }, "3.17.2", {
        requires: ["autocomplete-list", "node-pluginhost"]
      })
  },
  1093: function(k, n) {
    YUI.add("overlay", function(b, h) {
      b.Overlay = b.Base.create("overlay", b.Widget, [b.WidgetStdMod, b.WidgetPosition,
        b.WidgetStack, b.WidgetPositionAlign, b.WidgetPositionConstrain
      ])
    }, "3.17.2", {
      requires: "widget widget-stdmod widget-position widget-position-align widget-stack widget-position-constrain".split(" "),
      skinnable: !0
    })
  },
  1094: function(k, n) {
    YUI.add("shim-plugin", function(b, h) {
      function a(a) {
        this.init(a)
      }
      a.CLASS_NAME = "yui-node-shim";
      a.TEMPLATE = '<iframe class="' + a.CLASS_NAME + '" frameborder="0" title="Node Stacking Shim"src="javascript:false" tabindex="-1" role="presentation"style="position:absolute; z-index:-1;"></iframe>';
      a.prototype = {
        init: function(a) {
          this._host = a.host;
          this.initEvents();
          this.insert();
          this.sync()
        },
        initEvents: function() {
          this._resizeHandle = this._host.on("resize", this.sync, this)
        },
        getShim: function() {
          return this._shim || (this._shim = b.Node.create(a.TEMPLATE, this._host.get("ownerDocument")))
        },
        insert: function() {
          var a = this._host;
          this._shim = a.insertBefore(this.getShim(), a.get("firstChild"))
        },
        sync: function() {
          var a = this._shim,
            b = this._host;
          a && a.setAttrs({
            width: b.getStyle("width"),
            height: b.getStyle("height")
          })
        },
        destroy: function() {
          var a =
            this._shim;
          a && a.remove(!0);
          this._resizeHandle.detach()
        }
      };
      a.NAME = "Shim";
      a.NS = "shim";
      b.namespace("Plugin");
      b.Plugin.Shim = a
    }, "3.17.2", {
      requires: ["node-style", "node-pluginhost"]
    })
  },
  1096: function(k, n) {
    YUI.add("text-data-wordbreak", function(b, h) {
        b.namespace("Text.Data").WordBreak = {
          aletter: "[A-Za-z\u00aa\u00b5\u00ba\u00c0-\u00d6\u00d8-\u00f6\u00f8-\u02c1\u02c6-\u02d1\u02e0-\u02e4\u02ec\u02ee\u0370-\u0374\u0376\u0377\u037a-\u037d\u0386\u0388-\u038a\u038c\u038e-\u03a1\u03a3-\u03f5\u03f7-\u0481\u048a-\u0527\u0531-\u0556\u0559\u0561-\u0587\u05d0-\u05ea\u05f0-\u05f3\u0620-\u064a\u066e\u066f\u0671-\u06d3\u06d5\u06e5\u06e6\u06ee\u06ef\u06fa-\u06fc\u06ff\u0710\u0712-\u072f\u074d-\u07a5\u07b1\u07ca-\u07ea\u07f4\u07f5\u07fa\u0800-\u0815\u081a\u0824\u0828\u0840-\u0858\u0904-\u0939\u093d\u0950\u0958-\u0961\u0971-\u0977\u0979-\u097f\u0985-\u098c\u098f\u0990\u0993-\u09a8\u09aa-\u09b0\u09b2\u09b6-\u09b9\u09bd\u09ce\u09dc\u09dd\u09df-\u09e1\u09f0\u09f1\u0a05-\u0a0a\u0a0f\u0a10\u0a13-\u0a28\u0a2a-\u0a30\u0a32\u0a33\u0a35\u0a36\u0a38\u0a39\u0a59-\u0a5c\u0a5e\u0a72-\u0a74\u0a85-\u0a8d\u0a8f-\u0a91\u0a93-\u0aa8\u0aaa-\u0ab0\u0ab2\u0ab3\u0ab5-\u0ab9\u0abd\u0ad0\u0ae0\u0ae1\u0b05-\u0b0c\u0b0f\u0b10\u0b13-\u0b28\u0b2a-\u0b30\u0b32\u0b33\u0b35-\u0b39\u0b3d\u0b5c\u0b5d\u0b5f-\u0b61\u0b71\u0b83\u0b85-\u0b8a\u0b8e-\u0b90\u0b92-\u0b95\u0b99\u0b9a\u0b9c\u0b9e\u0b9f\u0ba3\u0ba4\u0ba8-\u0baa\u0bae-\u0bb9\u0bd0\u0c05-\u0c0c\u0c0e-\u0c10\u0c12-\u0c28\u0c2a-\u0c33\u0c35-\u0c39\u0c3d\u0c58\u0c59\u0c60\u0c61\u0c85-\u0c8c\u0c8e-\u0c90\u0c92-\u0ca8\u0caa-\u0cb3\u0cb5-\u0cb9\u0cbd\u0cde\u0ce0\u0ce1\u0cf1\u0cf2\u0d05-\u0d0c\u0d0e-\u0d10\u0d12-\u0d3a\u0d3d\u0d4e\u0d60\u0d61\u0d7a-\u0d7f\u0d85-\u0d96\u0d9a-\u0db1\u0db3-\u0dbb\u0dbd\u0dc0-\u0dc6\u0f00\u0f40-\u0f47\u0f49-\u0f6c\u0f88-\u0f8c\u10a0-\u10c5\u10d0-\u10fa\u10fc\u1100-\u1248\u124a-\u124d\u1250-\u1256\u1258\u125a-\u125d\u1260-\u1288\u128a-\u128d\u1290-\u12b0\u12b2-\u12b5\u12b8-\u12be\u12c0\u12c2-\u12c5\u12c8-\u12d6\u12d8-\u1310\u1312-\u1315\u1318-\u135a\u1380-\u138f\u13a0-\u13f4\u1401-\u166c\u166f-\u167f\u1681-\u169a\u16a0-\u16ea\u16ee-\u16f0\u1700-\u170c\u170e-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176c\u176e-\u1770\u1820-\u1877\u1880-\u18a8\u18aa\u18b0-\u18f5\u1900-\u191c\u1a00-\u1a16\u1b05-\u1b33\u1b45-\u1b4b\u1b83-\u1ba0\u1bae\u1baf\u1bc0-\u1be5\u1c00-\u1c23\u1c4d-\u1c4f\u1c5a-\u1c7d\u1ce9-\u1cec\u1cee-\u1cf1\u1d00-\u1dbf\u1e00-\u1f15\u1f18-\u1f1d\u1f20-\u1f45\u1f48-\u1f4d\u1f50-\u1f57\u1f59\u1f5b\u1f5d\u1f5f-\u1f7d\u1f80-\u1fb4\u1fb6-\u1fbc\u1fbe\u1fc2-\u1fc4\u1fc6-\u1fcc\u1fd0-\u1fd3\u1fd6-\u1fdb\u1fe0-\u1fec\u1ff2-\u1ff4\u1ff6-\u1ffc\u2071\u207f\u2090-\u209c\u2102\u2107\u210a-\u2113\u2115\u2119-\u211d\u2124\u2126\u2128\u212a-\u212d\u212f-\u2139\u213c-\u213f\u2145-\u2149\u214e\u2160-\u2188\u24b6-\u24e9\u2c00-\u2c2e\u2c30-\u2c5e\u2c60-\u2ce4\u2ceb-\u2cee\u2d00-\u2d25\u2d30-\u2d65\u2d6f\u2d80-\u2d96\u2da0-\u2da6\u2da8-\u2dae\u2db0-\u2db6\u2db8-\u2dbe\u2dc0-\u2dc6\u2dc8-\u2dce\u2dd0-\u2dd6\u2dd8-\u2dde\u2e2f\u3005\u303b\u303c\u3105-\u312d\u3131-\u318e\u31a0-\u31ba\ua000-\ua48c\ua4d0-\ua4fd\ua500-\ua60c\ua610-\ua61f\ua62a\ua62b\ua640-\ua66e\ua67f-\ua697\ua6a0-\ua6ef\ua717-\ua71f\ua722-\ua788\ua78b-\ua78e\ua790\ua791\ua7a0-\ua7a9\ua7fa-\ua801\ua803-\ua805\ua807-\ua80a\ua80c-\ua822\ua840-\ua873\ua882-\ua8b3\ua8f2-\ua8f7\ua8fb\ua90a-\ua925\ua930-\ua946\ua960-\ua97c\ua984-\ua9b2\ua9cf\uaa00-\uaa28\uaa40-\uaa42\uaa44-\uaa4b\uab01-\uab06\uab09-\uab0e\uab11-\uab16\uab20-\uab26\uab28-\uab2e\uabc0-\uabe2\uac00-\ud7a3\ud7b0-\ud7c6\ud7cb-\ud7fb\ufb00-\ufb06\ufb13-\ufb17\ufb1d\ufb1f-\ufb28\ufb2a-\ufb36\ufb38-\ufb3c\ufb3e\ufb40\ufb41\ufb43\ufb44\ufb46-\ufbb1\ufbd3-\ufd3d\ufd50-\ufd8f\ufd92-\ufdc7\ufdf0-\ufdfb\ufe70-\ufe74\ufe76-\ufefc\uff21-\uff3a\uff41-\uff5a\uffa0-\uffbe\uffc2-\uffc7\uffca-\uffcf\uffd2-\uffd7\uffda-\uffdc]",
          midnumlet: "['\\.\u2018\u2019\u2024\ufe52\uff07\uff0e]",
          midletter: "[:\u00b7\u00b7\u05f4\u2027\ufe13\ufe55\uff1a]",
          midnum: "[,;;\u0589\u060c\u060d\u066c\u07f8\u2044\ufe10\ufe14\ufe50\ufe54\uff0c\uff1b]",
          numeric: "[0-9\u0660-\u0669\u066b\u06f0-\u06f9\u07c0-\u07c9\u0966-\u096f\u09e6-\u09ef\u0a66-\u0a6f\u0ae6-\u0aef\u0b66-\u0b6f\u0be6-\u0bef\u0c66-\u0c6f\u0ce6-\u0cef\u0d66-\u0d6f\u0e50-\u0e59\u0ed0-\u0ed9\u0f20-\u0f29\u1040-\u1049\u1090-\u1099\u17e0-\u17e9\u1810-\u1819\u1946-\u194f\u19d0-\u19d9\u1a80-\u1a89\u1a90-\u1a99\u1b50-\u1b59\u1bb0-\u1bb9\u1c40-\u1c49\u1c50-\u1c59\ua620-\ua629\ua8d0-\ua8d9\ua900-\ua909\ua9d0-\ua9d9\uaa50-\uaa59\uabf0-\uabf9]",
          cr: "\\r",
          lf: "\\n",
          newline: "[\x0B\f\u0085\u2028\u2029]",
          extend: "[\u0300-\u036f\u0483-\u0489\u0591-\u05bd\u05bf\u05c1\u05c2\u05c4\u05c5\u05c7\u0610-\u061a\u064b-\u065f\u0670\u06d6-\u06dc\u06df-\u06e4\u06e7\u06e8\u06ea-\u06ed\u0711\u0730-\u074a\u07a6-\u07b0\u07eb-\u07f3\u0816-\u0819\u081b-\u0823\u0825-\u0827\u0829-\u082d\u0859-\u085b\u0900-\u0903\u093a-\u093c\u093e-\u094f\u0951-\u0957\u0962\u0963\u0981-\u0983\u09bc\u09be-\u09c4\u09c7\u09c8\u09cb-\u09cd\u09d7\u09e2\u09e3\u0a01-\u0a03\u0a3c\u0a3e-\u0a42\u0a47\u0a48\u0a4b-\u0a4d\u0a51\u0a70\u0a71\u0a75\u0a81-\u0a83\u0abc\u0abe-\u0ac5\u0ac7-\u0ac9\u0acb-\u0acd\u0ae2\u0ae3\u0b01-\u0b03\u0b3c\u0b3e-\u0b44\u0b47\u0b48\u0b4b-\u0b4d\u0b56\u0b57\u0b62\u0b63\u0b82\u0bbe-\u0bc2\u0bc6-\u0bc8\u0bca-\u0bcd\u0bd7\u0c01-\u0c03\u0c3e-\u0c44\u0c46-\u0c48\u0c4a-\u0c4d\u0c55\u0c56\u0c62\u0c63\u0c82\u0c83\u0cbc\u0cbe-\u0cc4\u0cc6-\u0cc8\u0cca-\u0ccd\u0cd5\u0cd6\u0ce2\u0ce3\u0d02\u0d03\u0d3e-\u0d44\u0d46-\u0d48\u0d4a-\u0d4d\u0d57\u0d62\u0d63\u0d82\u0d83\u0dca\u0dcf-\u0dd4\u0dd6\u0dd8-\u0ddf\u0df2\u0df3\u0e31\u0e34-\u0e3a\u0e47-\u0e4e\u0eb1\u0eb4-\u0eb9\u0ebb\u0ebc\u0ec8-\u0ecd\u0f18\u0f19\u0f35\u0f37\u0f39\u0f3e\u0f3f\u0f71-\u0f84\u0f86\u0f87\u0f8d-\u0f97\u0f99-\u0fbc\u0fc6\u102b-\u103e\u1056-\u1059\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074\u1082-\u108d\u108f\u109a-\u109d\u135d-\u135f\u1712-\u1714\u1732-\u1734\u1752\u1753\u1772\u1773\u17b6-\u17d3\u17dd\u180b-\u180d\u18a9\u1920-\u192b\u1930-\u193b\u19b0-\u19c0\u19c8\u19c9\u1a17-\u1a1b\u1a55-\u1a5e\u1a60-\u1a7c\u1a7f\u1b00-\u1b04\u1b34-\u1b44\u1b6b-\u1b73\u1b80-\u1b82\u1ba1-\u1baa\u1be6-\u1bf3\u1c24-\u1c37\u1cd0-\u1cd2\u1cd4-\u1ce8\u1ced\u1cf2\u1dc0-\u1de6\u1dfc-\u1dff\u200c\u200d\u20d0-\u20f0\u2cef-\u2cf1\u2d7f\u2de0-\u2dff\u302a-\u302f\u3099\u309a\ua66f-\ua672\ua67c\ua67d\ua6f0\ua6f1\ua802\ua806\ua80b\ua823-\ua827\ua880\ua881\ua8b4-\ua8c4\ua8e0-\ua8f1\ua926-\ua92d\ua947-\ua953\ua980-\ua983\ua9b3-\ua9c0\uaa29-\uaa36\uaa43\uaa4c\uaa4d\uaa7b\uaab0\uaab2-\uaab4\uaab7\uaab8\uaabe\uaabf\uaac1\uabe3-\uabea\uabec\uabed\ufb1e\ufe00-\ufe0f\ufe20-\ufe26\uff9e\uff9f]",
          format: "[\u00ad\u0600-\u0603\u06dd\u070f\u17b4\u17b5\u200e\u200f\u202a-\u202e\u2060-\u2064\u206a-\u206f\ufeff\ufff9-\ufffb]",
          katakana: "[\u3031-\u3035\u309b\u309c\u30a0-\u30fa\u30fc-\u30ff\u31f0-\u31ff\u32d0-\u32fe\u3300-\u3357\uff66-\uff9d]",
          extendnumlet: "[_\u203f\u2040\u2054\ufe33\ufe34\ufe4d-\ufe4f\uff3f]",
          punctuation: "[!-#%-*,-\\/:;?@\\[-\\]_{}\u00a1\u00ab\u00b7\u00bb\u00bf;\u00b7\u055a-\u055f\u0589\u058a\u05be\u05c0\u05c3\u05c6\u05f3\u05f4\u0609\u060a\u060c\u060d\u061b\u061e\u061f\u066a-\u066d\u06d4\u0700-\u070d\u07f7-\u07f9\u0830-\u083e\u085e\u0964\u0965\u0970\u0df4\u0e4f\u0e5a\u0e5b\u0f04-\u0f12\u0f3a-\u0f3d\u0f85\u0fd0-\u0fd4\u0fd9\u0fda\u104a-\u104f\u10fb\u1361-\u1368\u1400\u166d\u166e\u169b\u169c\u16eb-\u16ed\u1735\u1736\u17d4-\u17d6\u17d8-\u17da\u1800-\u180a\u1944\u1945\u1a1e\u1a1f\u1aa0-\u1aa6\u1aa8-\u1aad\u1b5a-\u1b60\u1bfc-\u1bff\u1c3b-\u1c3f\u1c7e\u1c7f\u1cd3\u2010-\u2027\u2030-\u2043\u2045-\u2051\u2053-\u205e\u207d\u207e\u208d\u208e\u3008\u3009\u2768-\u2775\u27c5\u27c6\u27e6-\u27ef\u2983-\u2998\u29d8-\u29db\u29fc\u29fd\u2cf9-\u2cfc\u2cfe\u2cff\u2d70\u2e00-\u2e2e\u2e30\u2e31\u3001-\u3003\u3008-\u3011\u3014-\u301f\u3030\u303d\u30a0\u30fb\ua4fe\ua4ff\ua60d-\ua60f\ua673\ua67e\ua6f2-\ua6f7\ua874-\ua877\ua8ce\ua8cf\ua8f8-\ua8fa\ua92e\ua92f\ua95f\ua9c1-\ua9cd\ua9de\ua9df\uaa5c-\uaa5f\uaade\uaadf\uabeb\ufd3e\ufd3f\ufe10-\ufe19\ufe30-\ufe52\ufe54-\ufe61\ufe63\ufe68\ufe6a\ufe6b\uff01-\uff03\uff05-\uff0a\uff0c-\uff0f\uff1a\uff1b\uff1f\uff20\uff3b-\uff3d\uff3f\uff5b\uff5d\uff5f-\uff65]"
        }
      },
      "3.17.2", {
        requires: ["yui-base"]
      })
  },
  1097: function(k, n) {
    YUI.add("text-wordbreak", function(b, h) {
      var a = b.Text,
        c = a.Data.WordBreak,
        d = [RegExp(c.aletter), RegExp(c.midnumlet), RegExp(c.midletter), RegExp(c.midnum), RegExp(c.numeric), RegExp(c.cr), RegExp(c.lf), RegExp(c.newline), RegExp(c.extend), RegExp(c.format), RegExp(c.katakana), RegExp(c.extendnumlet)],
        e = RegExp("^" + c.punctuation + "$"),
        g = /\s/,
        f = {
          getWords: function(a, b) {
            var c = 0,
              d = f._classify(a),
              h = d.length,
              p = [],
              v = [],
              s, x, w;
            b || (b = {});
            b.ignoreCase && (a = a.toLowerCase());
            x = b.includePunctuation;
            for (w = b.includeWhitespace; c < h; ++c) s = a.charAt(c), p.push(s), f._isWordBoundary(d, c) && ((p = p.join("")) && ((w || !g.test(p)) && (x || !e.test(p))) && v.push(p), p = []);
            return v
          },
          getUniqueWords: function(a, c) {
            return b.Array.unique(f.getWords(a, c))
          },
          isWordBoundary: function(a, b) {
            return f._isWordBoundary(f._classify(a), b)
          },
          _classify: function(a) {
            for (var b, c = [], f = 0, e, g, h = a.length, s = d.length, x; f < h; ++f) {
              b = a.charAt(f);
              x = 12;
              for (e = 0; e < s; ++e)
                if ((g = d[e]) && g.test(b)) {
                  x = e;
                  break
                }
              c.push(x)
            }
            return c
          },
          _isWordBoundary: function(a,
            b) {
            var c, f = a[b],
              e = a[b + 1],
              g;
            if (0 > b || b > a.length - 1 && 0 !== b || 0 === f && 0 === e) return !1;
            g = a[b + 2];
            if (0 === f && (2 === e || 1 === e) && 0 === g) return !1;
            c = a[b - 1];
            return (2 === f || 1 === f) && 0 === e && 0 === c || (4 === f || 0 === f) && (4 === e || 0 === e) || (3 === f || 1 === f) && 4 === e && 4 === c || 4 === f && (3 === e || 1 === e) && 4 === g || (8 === f || 9 === f || 8 === c || 9 === c || 8 === e || 9 === e) || 5 === f && 6 === e ? !1 : 7 === f || 5 === f || 6 === f || 7 === e || 5 === e || 6 === e ? !0 : 10 === f && 10 === e || 11 === e && (0 === f || 4 === f || 10 === f || 11 === f) || 11 === f && (0 === e || 4 === e || 10 === e) ? !1 : !0
          }
        };
      a.WordBreak = f
    }, "3.17.2", {
      requires: ["array-extras",
        "text-data-wordbreak"
      ]
    })
  },
  1102: function(k, n) {
    YUI.add("widget-position-constrain", function(b, h) {
      function a(a) {}
      var c = b.Node,
        d;
      a.ATTRS = {
        constrain: {
          value: null,
          setter: "_setConstrain"
        },
        preventOverlap: {
          value: !1
        }
      };
      d = a._PREVENT_OVERLAP = {
        x: {
          tltr: 1,
          blbr: 1,
          brbl: 1,
          trtl: 1
        },
        y: {
          trbr: 1,
          tlbl: 1,
          bltl: 1,
          brtr: 1
        }
      };
      a.prototype = {
        initializer: function() {
          this._posNode || b.error("WidgetPosition needs to be added to the Widget, before WidgetPositionConstrain is added");
          b.after(this._bindUIPosConstrained, this, "bindUI")
        },
        getConstrainedXY: function(a,
          b) {
          b = b || this.get("constrain");
          var c = this._getRegion(!0 === b ? null : b),
            d = this._posNode.get("region");
          return [this._constrain(a[0], "x", d, c), this._constrain(a[1], "y", d, c)]
        },
        constrain: function(a, b) {
          var c, d;
          if (d = b || this.get("constrain")) c = a || this.get("xy"), d = this.getConstrainedXY(c, d), (d[0] !== c[0] || d[1] !== c[1]) && this.set("xy", d, {
            constrained: !0
          })
        },
        _setConstrain: function(a) {
          return !0 === a ? a : c.one(a)
        },
        _constrain: function(a, b, c, d) {
          if (d) {
            this.get("preventOverlap") && (a = this._preventOverlap(a, b, c, d));
            var h = "x" == b;
            b = h ? d.width : d.height;
            c = h ? c.width : c.height;
            var m = h ? d.left : d.top;
            d = h ? d.right - c : d.bottom - c;
            if (a < m || a > d) c < b ? a < m ? a = m : a > d && (a = d) : a = m
          }
          return a
        },
        _preventOverlap: function(a, b, c, l) {
          var h = this.get("align"),
            m = "x" === b,
            r, q, p, v, s;
          if (h && h.points && d[b][h.points.join("")]) {
            if (b = this._getRegion(h.node)) r = m ? c.width : c.height, q = m ? b.left : b.top, p = m ? b.right : b.bottom, v = m ? b.left - l.left : b.top - l.top, s = m ? l.right - b.right : l.bottom - b.bottom;
            a > q ? s < r && v > r && (a = q - r) : v < r && s > r && (a = p)
          }
          return a
        },
        _bindUIPosConstrained: function() {
          this.after("constrainChange",
            this._afterConstrainChange);
          this._enableConstraints(this.get("constrain"))
        },
        _afterConstrainChange: function(a) {
          this._enableConstraints(a.newVal)
        },
        _enableConstraints: function(a) {
          a ? (this.constrain(), this._cxyHandle = this._cxyHandle || this.on("constrain|xyChange", this._constrainOnXYChange)) : this._cxyHandle && (this._cxyHandle.detach(), this._cxyHandle = null)
        },
        _constrainOnXYChange: function(a) {
          a.constrained || (a.newVal = this.getConstrainedXY(a.newVal))
        },
        _getRegion: function(a) {
          var b;
          a ? (a = c.one(a)) && (b = a.get("region")) :
            b = this._posNode.get("viewportRegion");
          return b
        }
      };
      b.WidgetPositionConstrain = a
    }, "3.17.2", {
      requires: ["widget-position"]
    })
  },
  1103: function(k, n) {
    YUI.add("widget-stack", function(b, h) {
      function a(a) {}
      var c = b.Lang,
        d = b.UA,
        e = b.Node,
        g = b.Widget;
      a.ATTRS = {
        shim: {
          value: 6 == d.ie
        },
        zIndex: {
          value: 0,
          setter: "_setZIndex"
        }
      };
      a.HTML_PARSER = {
        zIndex: function(a) {
          return this._parseZIndex(a)
        }
      };
      a.SHIM_CLASS_NAME = g.getClassName("shim");
      a.STACKED_CLASS_NAME = g.getClassName("stacked");
      a.SHIM_TEMPLATE = '<iframe class="' + a.SHIM_CLASS_NAME +
        '" frameborder="0" title="Widget Stacking Shim" src="javascript:false" tabindex="-1" role="presentation"></iframe>';
      a.prototype = {
        initializer: function() {
          this._stackNode = this.get("boundingBox");
          this._stackHandles = {};
          b.after(this._renderUIStack, this, "renderUI");
          b.after(this._syncUIStack, this, "syncUI");
          b.after(this._bindUIStack, this, "bindUI")
        },
        _syncUIStack: function() {
          this._uiSetShim(this.get("shim"));
          this._uiSetZIndex(this.get("zIndex"))
        },
        _bindUIStack: function() {
          this.after("shimChange", this._afterShimChange);
          this.after("zIndexChange", this._afterZIndexChange)
        },
        _renderUIStack: function() {
          this._stackNode.addClass(a.STACKED_CLASS_NAME)
        },
        _parseZIndex: function(a) {
          a = !a.inDoc() || "static" === a.getStyle("position") ? "auto" : a.getComputedStyle("zIndex");
          return "auto" === a ? null : a
        },
        _setZIndex: function(a) {
          c.isString(a) && (a = parseInt(a, 10));
          c.isNumber(a) || (a = 0);
          return a
        },
        _afterShimChange: function(a) {
          this._uiSetShim(a.newVal)
        },
        _afterZIndexChange: function(a) {
          this._uiSetZIndex(a.newVal)
        },
        _uiSetZIndex: function(a) {
          this._stackNode.setStyle("zIndex",
            a)
        },
        _uiSetShim: function(a) {
          a ? (this.get("visible") ? this._renderShim() : this._renderShimDeferred(), 6 == d.ie && this._addShimResizeHandlers()) : this._destroyShim()
        },
        _renderShimDeferred: function() {
          this._stackHandles.shimdeferred = this._stackHandles.shimdeferred || [];
          this._stackHandles.shimdeferred.push(this.on("visibleChange", function(a) {
            a.newVal && this._renderShim()
          }))
        },
        _addShimResizeHandlers: function() {
          this._stackHandles.shimresize = this._stackHandles.shimresize || [];
          var a = this.sizeShim,
            b = this._stackHandles.shimresize;
          b.push(this.after("visibleChange", a));
          b.push(this.after("widthChange", a));
          b.push(this.after("heightChange", a));
          b.push(this.after("contentUpdate", a))
        },
        _detachStackHandles: function(a) {
          a = this._stackHandles[a];
          var b;
          if (a && 0 < a.length)
            for (; b = a.pop();) b.detach()
        },
        _renderShim: function() {
          var a = this._shimNode,
            b = this._stackNode;
          a || (a = this._shimNode = this._getShimTemplate(), b.insertBefore(a, b.get("firstChild")), this._detachStackHandles("shimdeferred"), this.sizeShim())
        },
        _destroyShim: function() {
          this._shimNode &&
            (this._shimNode.get("parentNode").removeChild(this._shimNode), this._shimNode = null, this._detachStackHandles("shimdeferred"), this._detachStackHandles("shimresize"))
        },
        sizeShim: function() {
          var a = this._shimNode,
            b = this._stackNode;
          a && (6 === d.ie && this.get("visible")) && (a.setStyle("width", b.get("offsetWidth") + "px"), a.setStyle("height", b.get("offsetHeight") + "px"))
        },
        _getShimTemplate: function() {
          return e.create(a.SHIM_TEMPLATE, this._stackNode.get("ownerDocument"))
        }
      };
      b.WidgetStack = a
    }, "3.17.2", {
      requires: ["base-build",
        "widget"
      ],
      skinnable: !0
    })
  },
  1104: function(k, n) {
    YUI.add("widget-stdmod", function(b, h) {
      function a(a) {}
      var c = b.Lang,
        d = b.Node,
        e = b.UA,
        g = b.Widget,
        f = b.Widget.UI_SRC;
      a.HEADER = "header";
      a.BODY = "body";
      a.FOOTER = "footer";
      a.AFTER = "after";
      a.BEFORE = "before";
      a.REPLACE = "replace";
      var l = a.HEADER,
        u = a.BODY,
        m = a.FOOTER,
        r = l + "Content",
        q = m + "Content",
        p = u + "Content";
      a.ATTRS = {
        headerContent: {
          value: null
        },
        footerContent: {
          value: null
        },
        bodyContent: {
          value: null
        },
        fillHeight: {
          value: a.BODY,
          validator: function(a) {
            return this._validateFillHeight(a)
          }
        }
      };
      a.HTML_PARSER = {
        headerContent: function(a) {
          return this._parseStdModHTML(l)
        },
        bodyContent: function(a) {
          return this._parseStdModHTML(u)
        },
        footerContent: function(a) {
          return this._parseStdModHTML(m)
        }
      };
      a.SECTION_CLASS_NAMES = {
        header: g.getClassName("hd"),
        body: g.getClassName("bd"),
        footer: g.getClassName("ft")
      };
      a.TEMPLATES = {
        header: '<div class="' + a.SECTION_CLASS_NAMES[l] + '"></div>',
        body: '<div class="' + a.SECTION_CLASS_NAMES[u] + '"></div>',
        footer: '<div class="' + a.SECTION_CLASS_NAMES[m] + '"></div>'
      };
      a.prototype = {
        initializer: function() {
          this._stdModNode =
            this.get("contentBox");
          b.before(this._renderUIStdMod, this, "renderUI");
          b.before(this._bindUIStdMod, this, "bindUI");
          b.before(this._syncUIStdMod, this, "syncUI")
        },
        _syncUIStdMod: function() {
          var a = this._stdModParsed;
          (!a || !a[r]) && this._uiSetStdMod(l, this.get(r));
          (!a || !a[p]) && this._uiSetStdMod(u, this.get(p));
          (!a || !a[q]) && this._uiSetStdMod(m, this.get(q));
          this._uiSetFillHeight(this.get("fillHeight"))
        },
        _renderUIStdMod: function() {
          this._stdModNode.addClass(g.getClassName("stdmod"));
          this._renderStdModSections();
          this.after("headerContentChange",
            this._afterHeaderChange);
          this.after("bodyContentChange", this._afterBodyChange);
          this.after("footerContentChange", this._afterFooterChange)
        },
        _renderStdModSections: function() {
          c.isValue(this.get(r)) && this._renderStdMod(l);
          c.isValue(this.get(p)) && this._renderStdMod(u);
          c.isValue(this.get(q)) && this._renderStdMod(m)
        },
        _bindUIStdMod: function() {
          this.after("fillHeightChange", this._afterFillHeightChange);
          this.after("heightChange", this._fillHeight);
          this.after("contentUpdate", this._fillHeight)
        },
        _afterHeaderChange: function(a) {
          a.src !==
            f && this._uiSetStdMod(l, a.newVal, a.stdModPosition)
        },
        _afterBodyChange: function(a) {
          a.src !== f && this._uiSetStdMod(u, a.newVal, a.stdModPosition)
        },
        _afterFooterChange: function(a) {
          a.src !== f && this._uiSetStdMod(m, a.newVal, a.stdModPosition)
        },
        _afterFillHeightChange: function(a) {
          this._uiSetFillHeight(a.newVal)
        },
        _validateFillHeight: function(b) {
          return !b || b == a.BODY || b == a.HEADER || b == a.FOOTER
        },
        _uiSetFillHeight: function(a) {
          a = this.getStdModNode(a);
          var b = this._currFillNode;
          b && a !== b && b.setStyle("height", "");
          a && (this._currFillNode =
            a);
          this._fillHeight()
        },
        _fillHeight: function() {
          if (this.get("fillHeight")) {
            var a = this.get("height");
            "" != a && "auto" != a && this.fillHeight(this.getStdModNode(this.get("fillHeight")))
          }
        },
        _uiSetStdMod: function(a, b, e) {
          if (c.isValue(b)) {
            var g = this.getStdModNode(a, !0);
            this._addStdModContent(g, b, e);
            this.set(a + "Content", this._getStdModContent(a), {
              src: f
            })
          } else this._eraseStdMod(a);
          this.fire("contentUpdate")
        },
        _renderStdMod: function(a) {
          var b = this.get("contentBox"),
            c = this._findStdModSection(a);
          c || (c = this._getStdModTemplate(a));
          this._insertStdModSection(b, a, c);
          this[a + "Node"] = c;
          return this[a + "Node"]
        },
        _eraseStdMod: function(a) {
          var b = this.getStdModNode(a);
          b && (b.remove(!0), delete this[a + "Node"])
        },
        _insertStdModSection: function(a, b, c) {
          var f = a.get("firstChild");
          b === m || !f ? a.appendChild(c) : b === l ? a.insertBefore(c, f) : (b = this[m + "Node"]) ? a.insertBefore(c, b) : a.appendChild(c)
        },
        _getStdModTemplate: function(b) {
          return d.create(a.TEMPLATES[b], this._stdModNode.get("ownerDocument"))
        },
        _addStdModContent: function(b, c, f) {
          switch (f) {
            case a.BEFORE:
              f =
                0;
              break;
            case a.AFTER:
              f = void 0;
              break;
            default:
              f = a.REPLACE
          }
          b.insert(c, f)
        },
        _getPreciseHeight: function(a) {
          var b = a ? a.get("offsetHeight") : 0;
          a && a.hasMethod("getBoundingClientRect") && (a = a.invoke("getBoundingClientRect")) && (b = a.bottom - a.top);
          return b
        },
        _findStdModSection: function(b) {
          return this.get("contentBox").one("> ." + a.SECTION_CLASS_NAMES[b])
        },
        _parseStdModHTML: function(a) {
          var c = this._findStdModSection(a);
          return c ? (this._stdModParsed || (this._stdModParsed = {}, b.before(this._applyStdModParsedConfig, this, "_applyParsedConfig")),
            this._stdModParsed[a + "Content"] = 1, c.get("innerHTML")) : null
        },
        _applyStdModParsedConfig: function(a, b, c) {
          if (a = this._stdModParsed) a[r] = !(r in b) && r in a, a[p] = !(p in b) && p in a, a[q] = !(q in b) && q in a
        },
        _getStdModContent: function(a) {
          return this[a + "Node"] ? this[a + "Node"].get("childNodes") : null
        },
        setStdModContent: function(a, b, c) {
          this.set(a + "Content", b, {
            stdModPosition: c
          })
        },
        getStdModNode: function(a, b) {
          var c = this[a + "Node"] || null;
          !c && b && (c = this._renderStdMod(a));
          return c
        },
        fillHeight: function(a) {
          if (a) {
            var b = this.get("contentBox"),
              f = [this.headerNode, this.bodyNode, this.footerNode],
              g, d = 0;
            g = 0;
            for (var l = !1, h = 0, u = f.length; h < u; h++)(g = f[h]) && (g !== a ? d += this._getPreciseHeight(g) : l = !0);
            l && ((e.ie || e.opera) && a.set("offsetHeight", 0), b = b.get("offsetHeight") - parseInt(b.getComputedStyle("paddingTop"), 10) - parseInt(b.getComputedStyle("paddingBottom"), 10) - parseInt(b.getComputedStyle("borderBottomWidth"), 10) - parseInt(b.getComputedStyle("borderTopWidth"), 10), c.isNumber(b) && (g = b - d, 0 <= g && a.set("offsetHeight", g)))
          }
        }
      };
      b.WidgetStdMod = a
    }, "3.17.2", {
      requires: ["base-build",
        "widget"
      ]
    })
  },
  1208: function(k, n) {
    YUI.add("squarespace-email-utils", function(b) {
      b.namespace("Squarespace");
      var h = b.Squarespace.EmailUtils = {
        VALID_EMAIL_REGEX: /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/,
        isValid: function(a) {
          return 3 > a.length || 256 < a.length ? !1 : h.VALID_EMAIL_REGEX.test(a)
        }
      }
    }, "1.0", {
      requires: []
    })
  },
  1233: function(k, n) {
    YUI.add("squarespace-plugin-numeric-formatter", function(b) {
      b.namespace("Squarespace.Plugin");
      var h = function() {
        var a = [];
        [9, 13, 8, 46, 37, 39, 48, 49, 50, 51, 52,
          53, 54, 55, 56, 57, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105
        ].forEach(function(b) {
          a[b] = !0
        });
        return a
      }();
      b.Squarespace.Plugin.NumericFormatter = b.Base.create("numericFormatter", b.Plugin.Base, [], {
        initializer: function() {
          b.Lang.isNumber(Number(this.get("host").get("value"))) ? this.set("data", Number(this.get("host").get("value"))) : this.set("data", 0);
          this.set("displayString", this._format(this.get("data")));
          this._bindUI();
          this._syncUI()
        },
        _format: function(a) {
          return this.get("displayFormatter")(a)
        },
        _syncUI: function() {
          var a =
            this.get("data"),
            c = this.get("displayString");
          this.get("hasFocus") ? this.get("host").set("value", 0 < a ? c : "") : (c = "", b.Lang.isNull(this.get("prefixUnit")) || (c += this.get("prefixUnit")), c += this._format(a), b.Lang.isNull(this.get("postfixUnit")) || (c += " " + this.get("postfixUnit")), this.get("host").set("value", c))
        },
        _bindUI: function() {
          var a = this.get("host");
          this.on("displayStringChange", this._syncUI, this);
          a.on("valuechange", this._onValueChange, this);
          a.on("keydown", this._onKeyDown, this);
          a.on("focus", this._onFocus,
            this);
          a.on("blur", this._onBlur, this)
        },
        _onFocus: function() {
          this.set("hasFocus", !0);
          this._syncUI();
          setTimeout(b.bind(function() {
            this.get("host").select()
          }, this), 0)
        },
        _onBlur: function() {
          this.set("hasFocus", !1);
          this.set("displayString", this._format(this.get("data")))
        },
        _onKeyDown: function(a) {
          if (a.shiftKey || !h[a.keyCode])
            if (!((110 === a.keyCode || 190 === a.keyCode) && -1 === this.get("host").get("value").indexOf(".")) && !isFinite(Number(String.fromCharCode(a.keyCode)))) a.stopPropagation(), a.preventDefault()
        },
        _onValueChange: function() {
          var a =
            this.get("host").get("value"),
            a = this._transformToData(a);
          this.set("data", a)
        },
        _displayFormatter: function(a) {
          return a
        },
        _transformToData: function(a) {
          var c;
          b.Lang.isUndefined(this.get("prefixUnit")) || (c = String(a).replace(RegExp(this.get("prefixUnit"))));
          b.Lang.isUndefined(this.get("postfixUnit")) || (c = String(a).replace(RegExp(this.get("postfixUnit"))));
          return Number(c)
        }
      }, {
        NS: "numericFormatterPlugin",
        ATTRS: {
          hasFocus: {
            value: !1
          },
          data: {
            value: null
          },
          displayString: {
            value: null
          },
          prefixUnit: {
            value: null
          },
          postfixUnit: {
            value: null
          },
          displayFormatter: {
            value: function(a) {
              return a
            }
          }
        }
      })
    }, "1.0", {
      requires: ["plugin", "squarespace-util"]
    })
  },
  1244: function(k, n) {
    YUI.add("squarespace-widgets-data-widget", function(b) {
        b.namespace("Squarespace.Widgets");
        var h = b.Squarespace.Widgets.DataWidget = b.Base.create("dataWidget", b.Squarespace.Widgets.SSWidget, [], {
          initializer: function(a) {
            a.dataState || (this.getProperty("ASYNC_DATA") ? this.set("dataState", this.getProperty("DATA_STATES").INITIALIZED) : this.set("dataState", this.getProperty("DATA_STATES").LOADED))
          },
          renderUI: function() {
            h.superclass.renderUI.call(this);
            this._updateDataStateClassName()
          },
          bindUI: function() {
            h.superclass.bindUI.call(this);
            var a = this.get("id");
            this.after(a + "|dataChange", function(a) {
              a.noSyncUI || this.syncUI()
            }, this);
            this.after(a + "|dataStateChange", this._updateDataStateClassName, this)
          },
          _updateDataStateClassName: function() {
            var a = this.get("boundingBox"),
              c = this.get("dataState");
            b.Object.each(this.getProperty("DATA_STATES"), function(b) {
              a.removeClass("data-state-" + b)
            });
            a.addClass("data-state-" +
              c)
          },
          setLoadingState: function() {
            return this.set("dataState", this.getProperty("DATA_STATES").LOADING)
          },
          setLoadedState: function() {
            return this.set("dataState", this.getProperty("DATA_STATES").LOADED)
          },
          setLoadFailedState: function() {
            return this.set("dataState", this.getProperty("DATA_STATES").LOAD_FAILED)
          },
          loadedSuccessfully: function() {
            return this.get("dataState") === this.getProperty("DATA_STATES").LOADED
          },
          isLoading: function() {
            return this.get("dataState") === this.getProperty("DATA_STATES").LOADING
          },
          loadFailed: function() {
            return this.get("dataState") ===
              this.getProperty("DATA_STATES").LOAD_FAILED
          }
        }, {
          CSS_PREFIX: "sqs-data-widget",
          ASYNC_DATA: !1,
          DATA_STATES: {
            INITIALIZED: "initialized",
            LOADING: "loading",
            LOADED: "loaded",
            LOAD_FAILED: "load-failed"
          },
          ATTRS: {
            data: {
              value: null,
              validator: function(a) {
                return b.Lang.isUndefined(a) ? (console.warn(this.name + ": Will not set data to undefined."), !1) : !0
              }
            },
            dataState: {
              valueFn: function() {
                return this.getProperty("DATA_STATES").INITIALIZED
              }
            },
            preventRenderTemplate: {
              value: !1,
              validator: b.Squarespace.AttrValidators.isBoolean
            }
          }
        })
      },
      "1.0", {
        requires: ["base", "node", "widget", "squarespace-ss-widget", "squarespace-attr-validators"]
      })
  },
  1247: function(k, n) {
    YUI.add("autocomplete-sources", function(b, h) {
      var a = b.AutoCompleteBase,
        c = b.Lang,
        d = "_sourceSuccess",
        e = "maxResults";
      b.mix(a.prototype, {
        _YQL_SOURCE_REGEX: /^(?:select|set|use)\s+/i,
        _beforeCreateObjectSource: function(a) {
          return a instanceof b.Node && "select" === a.get("nodeName").toLowerCase() ? this._createSelectSource(a) : b.JSONPRequest && a instanceof b.JSONPRequest ? this._createJSONPSource(a) :
            this._createObjectSource(a)
        },
        _createIOSource: function(a) {
          function c(f) {
            var e = f.request;
            if (h._cache && e in h._cache) h[d](h._cache[e], f);
            else m && m.isInProgress() && m.abort(), m = b.io(h._getXHRUrl(a, f), {
              on: {
                success: function(a, c) {
                  var g;
                  try {
                    g = b.JSON.parse(c.responseText)
                  } catch (l) {
                    b.error("JSON parse error", l)
                  }
                  g && (h._cache && (h._cache[e] = g), h[d](g, f))
                }
              }
            })
          }
          var e = {
              type: "io"
            },
            h = this,
            m, r, q;
          e.sendRequest = function(a) {
            r = a;
            q || (q = !0, b.use("io-base", "json-parse", function() {
              e.sendRequest = c;
              c(r)
            }))
          };
          return e
        },
        _createJSONPSource: function(a) {
          function c(b) {
            var f =
              b.request,
              e = b.query;
            if (h._cache && f in h._cache) h[d](h._cache[f], b);
            else a._config.on.success = function(a) {
              h._cache && (h._cache[f] = a);
              h[d](a, b)
            }, a.send(e)
          }
          var e = {
              type: "jsonp"
            },
            h = this,
            m, r;
          e.sendRequest = function(d) {
            m = d;
            r || (r = !0, b.use("jsonp", function() {
              a instanceof b.JSONPRequest || (a = new b.JSONPRequest(a, {
                format: b.bind(h._jsonpFormatter, h)
              }));
              e.sendRequest = c;
              c(m)
            }))
          };
          return e
        },
        _createSelectSource: function(a) {
          var b = this;
          return {
            type: "select",
            sendRequest: function(c) {
              var e = [];
              a.get("options").each(function(a) {
                e.push({
                  html: a.get("innerHTML"),
                  index: a.get("index"),
                  node: a,
                  selected: a.get("selected"),
                  text: a.get("text"),
                  value: a.get("value")
                })
              });
              b[d](e, c)
            }
          }
        },
        _createStringSource: function(a) {
          return this._YQL_SOURCE_REGEX.test(a) ? this._createYQLSource(a) : -1 !== a.indexOf("{callback}") ? this._createJSONPSource(a) : this._createIOSource(a)
        },
        _createYQLSource: function(a) {
          function f(f) {
            var u = f.query,
              m = h.get("yqlEnv"),
              r = h.get(e),
              w;
            w = c.sub(a, {
              maxResults: 0 < r ? r : 1E3,
              request: f.request,
              query: u
            });
            if (h._cache && w in h._cache) h[d](h._cache[w], f);
            else u = function(a) {
              h._cache &&
                (h._cache[w] = a);
              h[d](a, f)
            }, r = {
              proto: h.get("yqlProtocol")
            }, q ? (q._callback = u, q._opts = r, q._params.q = w, m && (q._params.env = m)) : q = new b.YQLRequest(w, {
              on: {
                success: u
              },
              allowCache: !1
            }, m ? {
              env: m
            } : null, r), q.send()
          }
          var h = this,
            u = {
              type: "yql"
            },
            m, r, q;
          h.get("resultListLocator") || h.set("resultListLocator", h._defaultYQLLocator);
          u.sendRequest = function(a) {
            m = a;
            r || (r = !0, b.use("yql", function() {
              u.sendRequest = f;
              f(m)
            }))
          };
          return u
        },
        _defaultYQLLocator: function(a) {
          (a = a && a.query && a.query.results) && c.isObject(a) ? (a = b.Object.values(a) || [], a = 1 === a.length ? a[0] : a, c.isArray(a) || (a = [a])) : a = [];
          return a
        },
        _getXHRUrl: function(a, b) {
          var d = this.get(e);
          b.query !== b.request && (a += b.request);
          return c.sub(a, {
            maxResults: 0 < d ? d : 1E3,
            query: encodeURIComponent(b.query)
          })
        },
        _jsonpFormatter: function(a, b, d) {
          var h = this.get(e),
            m = this.get("requestTemplate");
          m && (a += m(d));
          return c.sub(a, {
            callback: b,
            maxResults: 0 < h ? h : 1E3,
            query: encodeURIComponent(d)
          })
        }
      });
      b.mix(a.ATTRS, {
        yqlEnv: {
          value: null
        },
        yqlProtocol: {
          value: "http"
        }
      });
      b.mix(a.SOURCE_TYPES, {
        io: "_createIOSource",
        jsonp: "_createJSONPSource",
        object: "_beforeCreateObjectSource",
        select: "_createSelectSource",
        string: "_createStringSource",
        yql: "_createYQLSource"
      }, !0)
    }, "3.17.2", {
      optional: ["io-base", "json-parse", "jsonp", "yql"],
      requires: ["autocomplete-base"]
    })
  },
  1261: function(k, n) {
    YUI.add("highlight-base", function(b, h) {
      var a = b.Array,
        c = b.Escape,
        d = b.Text.WordBreak,
        e = b.Lang.isArray,
        g = {},
        f = {
          _REGEX: "(&[^;\\s]*)?(%needles)",
          _REPLACER: function(a, b, c) {
            return b && !/\s/.test(c) ? a : f._TEMPLATE.replace(/\{s\}/g, c)
          },
          _START_REGEX: "^(&[^;\\s]*)?(%needles)",
          _TEMPLATE: '<b class="' +
            b.ClassNameManager.getClassName("highlight") + '">{s}</b>',
          all: function(a, b, d) {
            var h = [],
              q, p, k, s, x, w;
            d || (d = g);
            q = !1 !== d.escapeHTML;
            x = d.startsWith ? f._START_REGEX : f._REGEX;
            w = d.replacer || f._REPLACER;
            b = e(b) ? b : [b];
            p = 0;
            for (k = b.length; p < k; ++p)(s = b[p]) && h.push(c.regex(q ? c.html(s) : s));
            q && (a = c.html(a));
            return !h.length ? a : a.replace(RegExp(x.replace("%needles", h.join("|")), d.caseSensitive ? "g" : "gi"), w)
          },
          allCase: function(a, c, e) {
            return f.all(a, c, b.merge(e || g, {
              caseSensitive: !0
            }))
          },
          start: function(a, c, e) {
            return f.all(a,
              c, b.merge(e || g, {
                startsWith: !0
              }))
          },
          startCase: function(a, b) {
            return f.start(a, b, {
              caseSensitive: !0
            })
          },
          words: function(b, h, m) {
            var r, q, p = f._TEMPLATE;
            m || (m = g);
            r = !!m.caseSensitive;
            h = a.hash(e(h) ? h : d.getUniqueWords(h, {
              ignoreCase: !r
            }));
            q = m.mapper || function(a, b) {
              return b.hasOwnProperty(r ? a : a.toLowerCase()) ? p.replace(/\{s\}/g, c.html(a)) : c.html(a)
            };
            b = d.getWords(b, {
              includePunctuation: !0,
              includeWhitespace: !0
            });
            return a.map(b, function(a) {
              return q(a, h)
            }).join("")
          },
          wordsCase: function(a, b) {
            return f.words(a, b, {
              caseSensitive: !0
            })
          }
        };
      b.Highlight = f
    }, "3.17.2", {
      requires: ["array-extras", "classnamemanager", "escape", "text-wordbreak"]
    })
  },
  1513: function(k, n) {
    YUI.add("squarespace-basic-check", function(b) {
      var h = function(a) {
        return function(b) {
          b.halt();
          a.call(this, b)
        }
      };
      b.namespace("Squarespace.Widgets");
      var a = b.Squarespace.Widgets.BasicCheck = b.Base.create("basicCheck", b.Squarespace.Widgets.DataWidget, [], {
        bindUI: function() {
          a.superclass.bindUI.call(this);
          this.get("boundingBox").on("click", h(this._toggleActive), this)
        },
        renderUI: function() {
          var a =
            this.get("contentBox");
          b.Lang.isValue(this.get("title")) && a.append('<div class="title">' + this.get("title") + "</div>");
          var d = b.Node.create('<div class="check-element"></div>');
          a.append(d);
          b.Lang.isValue(this.get("label")) && d.append('<div class="label">' + this.get("label") + "</div>")
        },
        syncUI: function() {
          a.superclass.syncUI.call(this);
          this.get("contentBox").one(".check-element").toggleClass("active", this.get("data"))
        },
        _toggleActive: function() {
          this.set("data", !this.get("data"))
        }
      }, {
        CSS_PREFIX: "sqs-basic-check",
        ATTRS: {
          data: {
            value: !1,
            validator: b.Lang.isBoolean
          },
          name: {
            value: null
          },
          title: {
            value: null
          },
          label: {
            value: null
          }
        }
      })
    }, "1.0", {
      requires: ["base", "squarespace-dialog-check-template", "squarespace-widgets-data-widget"]
    })
  },
  1540: function(k, n, b) {
    var h = b(304);
    YUI.add("squarespace-cart-utils", function(a) {
      var b, d, e;
      a.namespace("Squarespace.CartUtils");
      a.Squarespace.CartUtils = {
        initializeAddToCartButtons: function() {
          var d = a.Squarespace.Commerce.isExpressCheckout(),
            f = !1;
          a.all(".sqs-add-to-cart-button").each(function(b) {
            var c =
              b.one(".sqs-add-to-cart-button-inner");
            c.plug(a.Squarespace.Animations.Scalable, {
              duration: 0.2
            });
            d && "Add To Cart" === b.getData("original-label") && (c.setContent("Purchase"), b.setData("original-label", "Purchase"));
            b.hasClass("use-form") && (f = !0)
          }, this);
          f && !e && a.Squarespace.CartUtils._getAdditionalFieldsFormTemplateSchema(function(a) {
            e = a
          }, this);
          b || (b = a.one("body").delegate("click", a.Squarespace.CartUtils._addCartEntry, ".sqs-add-to-cart-button", this))
        },
        _addCartEntry: function(b) {
          var c = b.currentTarget;
          if (!c.get("parentNode").hasClass("cart-added")) {
            var e =
              function(b) {
                new a.Squarespace.Widgets.Alert({
                  "strings.title": "Unable to " + (a.Squarespace.Commerce.isExpressCheckout() ? "Purchase" : "Add") + " Item",
                  "strings.message": b
                })
              };
            b = function(a) {
              var b = "Please select the ",
                c = a.length;
              if (1 == c) b += a[0] + " option.";
              else if (2 == c) b += a[0] + " and " + a[1] + " options.";
              else
                for (var f = 0; f < c; f++) b = f == c - 1 ? b + ("and " + a[f] + " options.") : b + (a[f] + ", ");
              return b
            };
            var d = c.getAttribute("data-item-id"),
              h, r, q = a.one(c.get("parentNode").siblings(".product-variants").item(0));
            if (a.Lang.isValue(q)) {
              var p =
                JSON.parse(q.getAttribute("data-unselected-options")),
                k = p.length,
                s = q.getAttribute("data-selected-variant"),
                q = q.getAttribute("data-variant-in-stock"),
                s = s ? JSON.parse(s) : null,
                q = q ? !0 : !1;
              if (0 < k) {
                e(b(p));
                return
              }
              if (s)
                if (q) h = s;
                else {
                  e("Sorry, we do not have enough of that item available.");
                  return
                }
              else {
                e("Sorry, that item variant is unavailable. Please select another variant.");
                return
              }
            }
            if (b = c.get("parentNode").siblings(".product-quantity-input").item(0))
              if (r = a.one(b).one("input").get("value"), !a.Lang.isNumber(Number(r))) {
                e("Quantity must be a number.");
                return
              }
            c.hasClass("use-form") ? this._verifyItemInStock({
              itemId: d,
              variant: h,
              inStockCb: a.bind(function() {
                a.Squarespace.CartUtils._openAdditionalFieldsForm(c, function(b) {
                  a.Squarespace.CartUtils._goToCheckoutOrAddToCart(c, d, h, r, b, e)
                }, this)
              }, this),
              outOfStockCb: function() {
                e("Sorry, we do not have enough of that item available.")
              }
            }) : a.Squarespace.CartUtils._goToCheckoutOrAddToCart(c, d, h, r, null, e)
          }
        },
        _verifyItemInStock: function(b) {
          var c = a.Squarespace.Singletons.ShoppingCart;
          a.Data.get({
            url: a.Squarespace.API_ROOT +
              "commerce/inventory/stock/",
            data: {
              itemId: b.itemId
            },
            success: function(e) {
              a.Array.some(e.results, function(a) {
                return a.unlimited ? !0 : a.qtyInStock > c.totalForItem(b.itemId, b.variant)
              }) ? b.inStockCb() : b.outOfStockCb()
            }
          })
        },
        _goToCheckoutOrAddToCart: function(b, c, e, d, h, r) {
          a.Squarespace.CartUtils._setButtonStateAdding(b);
          if (a.Lang.isValue(d) && 0 !== d % 1) r("Quantity must be a whole number"), a.Squarespace.CartUtils._setButtonStateIdle(b);
          else {
            var q = a.Squarespace.Commerce.isExpressCheckout();
            a.Squarespace.Singletons.ShoppingCart.addEntry(c,
              e, d, h, q,
              function(c) {
                b.one(".sqs-add-to-cart-button-inner");
                c ? (r(c), a.later(1E3, this, function() {
                  a.Squarespace.CartUtils._setButtonStateIdle(b)
                })) : a.Squarespace.Commerce.isExpressCheckout() ? a.Squarespace.Commerce.goToCheckoutPage() : a.later(1E3, this, function() {
                  a.Lang.isNull(b._node) || (a.Squarespace.CartUtils._setButtonStateAdded(b), a.later(2E3, this, function() {
                    a.Squarespace.CartUtils._setButtonStateIdle(b)
                  }))
                })
              }, this)
          }
        },
        _setButtonStateAdding: function(b) {
          var c = b.one(".sqs-add-to-cart-button-inner");
          c.once("hidden",
            function() {
              c.empty();
              b.addClass("cart-adding");
              (new a.Squarespace.Spinner({
                size: 20,
                color: "light",
                render: c
              })).spin();
              c.append('<div class="status-text">Adding...</div>');
              c.show()
            }, this);
          c.hide()
        },
        _setButtonStateAdded: function(a) {
          var b = a.one(".sqs-add-to-cart-button-inner");
          b.empty();
          a.addClass("cart-added");
          b.append('<div class="status-text">Added!</div>')
        },
        _setButtonStateIdle: function(a) {
          var b = a.one(".sqs-add-to-cart-button-inner");
          b.once("hidden", function() {
            b.empty();
            a.removeClass("cart-adding");
            a.removeClass("cart-added");
            b.setContent(a.getData("original-label"));
            b.show()
          }, this);
          b.hide()
        },
        _openAdditionalFieldsForm: function(b, c, h) {
          d || (d = new a.Squarespace.Widgets.ModalLightbox({
            render: a.one("body")
          }));
          var u = a.JSON.parse(b.getData("form")),
            m = new a.Squarespace.Widgets.AsyncForm({
              form: u,
              formTemplate: e,
              formSubmitButtonText: b.getData("original-label"),
              formName: u.name,
              showTitle: !0
            });
          m.on("submission", function(a) {
            c && c.call(h || this, a.data);
            d.close()
          }, this);
          d.set("content", m);
          d.once("close", function() {
              m.destroy()
            },
            this);
          d.open()
        },
        _getAdditionalFieldsFormTemplateSchema: function(b, c) {
          a.Data.get({
            url: "/api/template/GetTemplateSchema",
            data: {
              componentType: "widget",
              type: h.FORM
            },
            success: function(a) {
              b.call(c || this, a)
            }
          }, this)
        }
      }
    }, "1.0", {
      requires: "base node json squarespace-commerce-utils squarespace-modal-lightbox squarespace-async-form squarespace-animations squarespace-spinner squarespace-widgets-alert".split(" ")
    })
  },
  1544: function(k, n, b) {
    var h = b(89),
      a = b(111);
    YUI.add("squarespace-commerce-analytics", function(b) {
        var d =
          new b.Base.create("commerceTrack", b.Base, [], {
            itemViewed: function(a) {
              this.fire("commerce-item-viewed", a)
            },
            itemAdded: function(a) {
              this.fire("commerce-item-added", a)
            },
            itemRemoved: function(a) {
              this.fire("commerce-item-removed", a)
            },
            itemModified: function(a) {
              this.fire("commerce-item-modified", a)
            },
            checkoutStarted: function(a) {
              this.fire("commerce-checkout-started", a)
            },
            checkoutConfirmed: function(a) {
              this.fire("commerce-checkout-confirmed", a)
            },
            contributionConfirmed: function(a) {
              this.fire("commerce-contribution-confirmed",
                a)
            }
          }, {
            ATTRS: {}
          });
        b.namespace("Squarespace");
        b.Squarespace.CommerceAnalytics = new d;
        var e = b.Base.create("commerceAnalytics", b.Base, [], {
            initializer: function() {
              this._events = [b.Squarespace.CommerceAnalytics.on("commerce-item-viewed", this._getProtectedTracker("onItemViewed"), this), b.Squarespace.CommerceAnalytics.on("commerce-item-added", this._getProtectedTracker("onItemAdded"), this), b.Squarespace.CommerceAnalytics.on("commerce-item-removed", this._getProtectedTracker("onItemRemoved"), this), b.Squarespace.CommerceAnalytics.on("commerce-item-modified",
                this._getProtectedTracker("onItemModified"), this), b.Squarespace.CommerceAnalytics.on("commerce-checkout-started", this._getProtectedTracker("onCheckoutStarted"), this), b.Squarespace.CommerceAnalytics.on("commerce-checkout-confirmed", this._getProtectedTracker("onCheckoutConfirmed"), this), b.Squarespace.CommerceAnalytics.on("commerce-contribution-confirmed", this._getProtectedTracker("onContributionConfirmed"), this)];
              this._setCartMode()
            },
            destructor: function() {
              b.Array.invoke(this._events, "detach")
            },
            _setCartMode: function() {
              var a = !0;
              try {
                a = Static.SQUARESPACE_CONTEXT.websiteSettings.storeSettings.testModeOn
              } catch (b) {}
              this.cartMode = a ? "test" : "live"
            },
            _getProtectedTracker: function(a) {
              return function(b) {
                try {
                  this[a].call(this, b)
                } catch (c) {}
              }
            },
            onItemViewed: function(a) {},
            onItemAdded: function(a) {},
            onItemRemoved: function(a) {},
            onItemModified: function(a) {},
            onCheckoutStarted: function(a) {},
            onCheckoutConfirmed: function(a) {},
            onContributionConfirmed: function(a) {}
          }, {
            ATTRS: {}
          }),
          d = b.Base.create("commerceAnalyticsInternal", e, [], {
            _createCartData: function(a) {
              return {
                CartOrderId: a.id,
                CartSubtotal: a.subtotalCents / 100,
                CartTax: a.taxCents / 100,
                CartCurrency: "USD",
                CartMode: this.cartMode
              }
            },
            _createProductData: function(a) {
              var b = a.productType;
              return {
                ProductId: a.itemId,
                ProductName: a.title,
                ProductType: b === h.PHYSICAL ? "PHYSICAL" : b === h.DIGITAL ? "DIGITAL" : "SERVICE",
                ProductSKU: a.chosenVariant ? a.chosenVariant.sku : "",
                ProductPrice: a.purchasePriceCents / 100,
                ProductQuantity: a.quantity
              }
            },
            _getItemVariantPrice: function(a) {
              return b.Object.hasKey(a, "onSale") && a.onSale ? (b.Object.hasKey(a, "salePrice") ? a.salePrice :
                a.salePriceCents) / 100 : (b.Object.hasKey(a, "price") ? a.price : a.priceCents) / 100
            },
            _getItemPrice: function(a) {
              var e = 0;
              b.Object.hasKey(a, "variants") && 0 < a.variants.length ? (b.Array.each(a.variants, function(a) {
                e += this._getItemVariantPrice(a)
              }, this), e /= a.variants.length) : e = this._getItemVariantPrice(a);
              return e
            },
            _createItemData: function(a) {
              return {
                ProductId: a.id,
                ProductName: a.title
              }
            },
            _createItemAddedData: function(a) {
              return b.merge(this._createCartData(a.shoppingCart), this._createProductData(a.newlyAdded))
            },
            _createItemRemovedData: function(a) {
              return b.merge(this._createCartData(a.shoppingCart),
                this._createProductData(a.updatedEntry))
            },
            _createItemModifiedData: function(a) {
              return b.merge(this._createCartData(a.shoppingCart), this._createProductData(a.updatedEntry))
            },
            _createItemCheckoutStartedData: function(a, e) {
              return b.merge(this._createCartData(a), this._createProductData(e))
            },
            _createItemCheckoutCompletedData: function(a, e) {
              return b.merge(this._createCartData(a), this._createProductData(e))
            },
            _track: function(a, e) {
              b.Squarespace.Analytics.trackInternal(a, e)
            },
            onItemViewed: function(a) {}
          }, {
            ATTRS: {}
          }),
          g = b.Base.create("commerceAnalyticsMixpanel", d, [], {
            _track: function(a, e) {
              b.Squarespace.Analytics.track(a, e)
            },
            onItemViewed: function(a) {
              this._track("shopper_product_viewed", this._createItemData(a))
            },
            onItemAdded: function(a) {
              this._track("shopper_product_added", this._createItemAddedData(a))
            },
            onItemRemoved: function(a) {
              this._track("shopper_product_removed", this._createItemRemovedData(a))
            },
            onItemModified: function(a) {
              this._track("shopper_product_modified", this._createItemModifiedData(a))
            },
            onCheckoutStarted: function(a) {
              b.each(a.entries,
                function(b) {
                  this._track("shopper_product_checkout_started", this._createItemCheckoutStartedData(a, b))
                }, this)
            },
            onCheckoutConfirmed: function(a) {
              b.each(a.purchasedCart.entries, function(b) {
                this._track("shopper_product_purchased", this._createItemCheckoutCompletedData(a.purchasedCart, b))
              }, this);
              this._track("shopper_order_submitted", {
                CartOrderId: a.purchasedCart.id,
                CartCurrency: "USD",
                CartGrandTotal: a.purchasedCart.grandTotalCents / 100,
                CartSubtotal: a.purchasedCart.subtotalCents / 100,
                CartTax: a.purchasedCart.taxCents /
                  100,
                CartShipping: a.purchasedCart.shippingCostCents / 100,
                CartTotalQuantity: a.purchasedCart.totalQuantity,
                CartMode: this.cartMode
              })
            },
            onContributionConfirmed: function(a) {
              this._track("donation_submitted", {
                Currency: "USD",
                Total: a.amountCents / 100,
                CartMode: this.cartMode
              })
            }
          }, {
            ATTRS: {}
          }),
          e = b.Base.create("commerceAnalyticsGoogle", e, [], {
            onCheckoutConfirmed: function(a) {
              _gaq && (_gaq.push(["_addTrans", a.id, "", a.purchasedCart.subtotalCents / 100, a.purchasedCart.taxCents / 100, a.purchasedCart.shippingCostCents / 100, a.customer.billingAddress.city,
                a.customer.billingAddress.state, a.customer.billingAddress.country
              ]), b.each(a.purchasedCart.entries, function(b) {
                _gaq.push(["_addItem", a.id, b.chosenVariant ? b.chosenVariant.sku : "digital", b.title, "", b.purchasePriceCents / 100, b.quantity])
              }), _gaq.push(["_trackTrans"]))
            }
          }, {
            ATTRS: {}
          });
        new d;
        new g;
        new e;
        b.Lang.isObject(Static) && b.Object.hasKey(Static, "SQUARESPACE_CONTEXT") && b.Object.hasKey(Static.SQUARESPACE_CONTEXT, "item") && Static.SQUARESPACE_CONTEXT.item.recordType === a.STORE_ITEM && b.Squarespace.CommerceAnalytics.itemViewed(Static.SQUARESPACE_CONTEXT.item)
      },
      "1.0", {
        requires: ["array-invoke", "event-custom", "node", "base", "squarespace-util"]
      })
  },
  1590: function(k, n, b) {
    var h = b(433),
      a = b(170);
    YUI.add("squarespace-localities", function(b) {
      b.namespace("Squarespace");
      b.Squarespace.Localities = {
        COUNTRY_OPTIONS: b.merge({
          "": {
            title: "Not Specified",
            empty: !0
          }
        }, a(h, function(a) {
          return {
            title: a
          }
        })),
        STATE_OPTIONS: {
          AL: {
            title: "Alabama"
          },
          AK: {
            title: "Alaska"
          },
          AZ: {
            title: "Arizona"
          },
          AR: {
            title: "Arkansas"
          },
          CA: {
            title: "California"
          },
          CO: {
            title: "Colorado"
          },
          CT: {
            title: "Connecticut"
          },
          DE: {
            title: "Delaware"
          },
          FL: {
            title: "Florida"
          },
          GA: {
            title: "Georgia"
          },
          HI: {
            title: "Hawaii"
          },
          ID: {
            title: "Idaho"
          },
          IL: {
            title: "Illinois"
          },
          IN: {
            title: "Indiana"
          },
          IA: {
            title: "Iowa"
          },
          KS: {
            title: "Kansas"
          },
          KY: {
            title: "Kentucky"
          },
          LA: {
            title: "Louisiana"
          },
          ME: {
            title: "Maine"
          },
          MD: {
            title: "Maryland"
          },
          MA: {
            title: "Massachusetts"
          },
          MI: {
            title: "Michigan"
          },
          MN: {
            title: "Minnesota"
          },
          MS: {
            title: "Mississippi"
          },
          MO: {
            title: "Missouri"
          },
          MT: {
            title: "Montana"
          },
          NE: {
            title: "Nebraska"
          },
          NV: {
            title: "Nevada"
          },
          NH: {
            title: "New Hampshire"
          },
          NJ: {
            title: "New Jersey"
          },
          NM: {
            title: "New Mexico"
          },
          NY: {
            title: "New York"
          },
          NC: {
            title: "North Carolina"
          },
          ND: {
            title: "North Dakota"
          },
          OH: {
            title: "Ohio"
          },
          OK: {
            title: "Oklahoma"
          },
          OR: {
            title: "Oregon"
          },
          PA: {
            title: "Pennsylvania"
          },
          RI: {
            title: "Rhode Island"
          },
          SC: {
            title: "South Carolina"
          },
          SD: {
            title: "South Dakota"
          },
          TN: {
            title: "Tennessee"
          },
          TX: {
            title: "Texas"
          },
          UT: {
            title: "Utah"
          },
          VT: {
            title: "Vermont"
          },
          VA: {
            title: "Virginia"
          },
          WA: {
            title: "Washington"
          },
          DC: {
            title: "Washington, District of Columbia"
          },
          WV: {
            title: "West Virginia"
          },
          WI: {
            title: "Wisconsin"
          },
          WY: {
            title: "Wyoming"
          },
          AA: {
            title: "Armed Forces Europe"
          },
          AE: {
            title: "Armed Forces Americas"
          },
          AP: {
            title: "Armed Forces Pacific"
          }
        }
      };
      b.Squarespace.Localities.COUNTRIES_TO_STATES = {
        US: b.Squarespace.Localities.STATE_OPTIONS,
        CA: {
          ON: {
            title: "Ontario"
          },
          QC: {
            title: "Quebec"
          },
          NS: {
            title: "Nova Scotia"
          },
          NB: {
            title: "New Brunswick"
          },
          MB: {
            title: "Manitoba"
          },
          BC: {
            title: "British Columbia"
          },
          PE: {
            title: "Prince Edward Island"
          },
          SK: {
            title: "Saskatchewan"
          },
          AB: {
            title: "Alberta"
          },
          NL: {
            title: "Newfoundland and Labrador"
          },
          NT: {
            title: "Northwest Territories"
          },
          YT: {
            title: "Yukon"
          },
          NU: {
            title: "Nunavut"
          }
        }
      };
      b.Squarespace.Localities.countryCodeFromName = function(a) {
        for (var e in b.Squarespace.Localities.COUNTRY_OPTIONS)
          if (b.Squarespace.Localities.COUNTRY_OPTIONS[e].title === a) return e
      };
      var d = function(a) {
          return b.Array.reduce(b.Object.keys(a).sort(), [], function(b, c) {
            b.push({
              label: a[c].title,
              value: c
            });
            return b
          })
        },
        e = function(a) {
          return a.sort(function(a, b) {
            return a.label < b.label ? -1 : 1
          })
        };
      b.Squarespace.Localities.getAllCountryNames = function() {
        var a = [];
        b.Object.each(b.Squarespace.Localities.COUNTRY_OPTIONS, function(b) {
          b.empty ||
            a.push(b.title)
        });
        return a
      };
      b.Squarespace.Localities.getNewCountryOptions = function() {
        return e(d(b.Squarespace.Localities.COUNTRY_OPTIONS))
      };
      b.Squarespace.Localities.getNewStateOptionsForCountry = function(a) {
        return e(d(b.Squarespace.Localities.COUNTRIES_TO_STATES[a]))
      };
      b.Squarespace.Localities.getAmericentricSortedCountryOptions = function() {
        var a = b.Array.filter(b.Squarespace.Localities.getNewCountryOptions(), function(a) {
          return "" !== a.value
        });
        a.sort(function(a, b) {
          return a.label > b.label ? 1 : a.label < b.label ?
            -1 : 0
        });
        return a
      }
    })
  },
  1592: function(k, n, b) {
    var h = b(1183);
    YUI.add("squarespace-mixins-google-places-autocomplete", function(a) {
      a.namespace("Squarespace.Mixins");
      var b = {
          POSTAL_CODE: "postal_code",
          COUNTRY: "country",
          LOCALITY: "locality",
          ROUTE: "route",
          STREET_NUMBER: "street_number",
          ADMIN_LEVEL_1: "administrative_area_level_1",
          SUBLOCALITY: "sublocality",
          POSTAL_TOWN: "postal_town",
          NEIGHBORHOOD: "neighborhood"
        },
        d = a.Object.values(b),
        e = a.Squarespace.Localities.COUNTRY_OPTIONS,
        g = ["geocode"];
      a.Squarespace.Mixins.GooglePlacesAutocomplete =
        a.Base.create("GooglePlacesAutocomplete", a.Base, [], {
          initializer: function() {
            this.publish("placeDetails");
            a.Do.after(this._afterRenderUI, this, "renderUI", this);
            a.Do.after(this._afterBindUI, this, "bindUI", this);
            this.after("render", this._enableBrowserAutoComplete, this);
            this.setAttrs({
              source: a.bind(this._accessAutocompleteService, this),
              enableCache: !1,
              resultTextLocator: "description",
              resultFilters: this._filterResults,
              resultFormatter: this._formatResults,
              minQueryLength: 3
            })
          },
          _afterRenderUI: function() {
            var a = this.get("contentBox");
            a.addClass("sqs-google-places-autocomplete-mixin");
            a.one(".sqs-scroll-ac-scroll-container").append('<div class="google-required-elements"><div class="google-attributions"></div><div class="powered-by-google"></div></div>')
          },
          _afterBindUI: function() {
            this.before("select", this._getDetailsForPrediction, this);
            this.on("placeDetails", this._fillWithAddressLine1, this);
            this._inputNode.on("focus", function() {
              this._inputNode.setAttribute("autocomplete", "off");
              this._inputIsFocused = !0
            }, this);
            this._inputNode.on("blur",
              function() {
                this._inputNode.setAttribute("autocomplete", "on");
                this._inputIsFocused = !1
              }, this)
          },
          _enableBrowserAutoComplete: function() {
            this._inputNode.setAttribute("autocomplete", "on")
          },
          _getDetailsForPrediction: function(b) {
            b.halt();
            var c = b.result.raw;
            this._accessPlaceDetailsService(c, function(b, e) {
              if (e === a.config.win.google.maps.places.PlacesServiceStatus.OK) {
                var d = this._extractPlaceComponents(b),
                  d = this._buildLocationPayload(d, c);
                this.fire("placeDetails", {
                  place: d
                })
              } else console.warn("Error communicating with Google Places API")
            })
          },
          _extractPlaceComponents: function(f) {
            return a.Array.reduce(f.address_components, {}, function(f, g) {
              var h = a.Array.find(g.types, function(b) {
                return -1 !== a.Array.indexOf(d, b)
              });
              f[h] = h ? h === b.ADMIN_LEVEL_1 ? g.short_name : h === b.COUNTRY ? e[g.short_name].title : g.long_name : "";
              return f
            })
          },
          _buildLocationPayload: function(e, d) {
            var g = a.Object.getValue(e, "street_number") || "",
              h = a.Object.getValue(e, "route") || "",
              r = a.Object.getValue(e, "country") || "",
              q = a.Object.getValue(e, "locality") || "",
              p = a.Object.getValue(e, "sublocality") ||
              "",
              k = a.Object.getValue(e, "neighborhood") || "",
              p = [a.Object.getValue(e, "postal_town") || "", q, p, k],
              q = a.Array.find(p, function(b) {
                return a.Array.find(d.terms, function(a) {
                  return a.value === b
                })
              }) || q,
              g = this._getPreferredStreetNumber(h, g),
              p = a.Object.getValue(e, b.ADMIN_LEVEL_1) || "",
              k = a.Object.getValue(e, b.POSTAL_CODE) || "",
              s = a.Array.filter([q, p, k], function(a) {
                return !!a
              }).join(", ").trim();
            return {
              address: (g + " " + h).trim(),
              country: r,
              city: q,
              state: p,
              zip: k,
              fullLocality: s
            }
          },
          _getPreferredStreetNumber: function(a, b) {
            var c =
              this.get("query"),
              e = a.split(" ")[0],
              e = c.toLowerCase().indexOf(e.toLowerCase()),
              c = c.substring(0, e).trim();
            return c.length > b.length ? c : b
          },
          _accessAutocompleteService: function(b, c) {
            this._autocompleteService ? this._performAutoComplete(b, c) : h().then(a.bind(function(a) {
              this._initAutocompleteService(a);
              this._performAutoComplete(b, c)
            }, this))
          },
          _initAutocompleteService: function(a) {
            this._autocompleteService = new a.places.AutocompleteService
          },
          _performAutoComplete: function(b, c) {
            var e = {
                input: b,
                types: g
              },
              d = a.bind(function() {
                this._inputIsFocused &&
                  c.apply(this, arguments)
              }, this);
            this._autocompleteService.getPlacePredictions(e, d)
          },
          _accessPlaceDetailsService: function(b, c) {
            this._placeDetailsService ? this._getPlaceDetails(b, c) : h().then(a.bind(function(a) {
              this._initPlaceDetailsService(a);
              this._getPlaceDetails(b, c)
            }, this))
          },
          _initPlaceDetailsService: function(a) {
            this._placeDetailsService = new a.places.PlacesService(this.get("contentBox").one(".google-attributions"))
          },
          _getPlaceDetails: function(b, c) {
            this._placeDetailsService.getDetails(b, a.bind(c, this))
          },
          _formatResults: function(b, c) {
            return a.Array.map(c, function(b) {
              var c = b.raw.terms,
                e = b.raw.matched_substrings,
                d = -1 !== a.Array.indexOf(b.raw.types, "street_address"),
                f = c[0].offset + c[0].value.length,
                c = c[1].offset + c[1].value.length,
                g = d ? c : f;
              return a.Array.map(b.text.split(""), function(a, c) {
                var d = ["google-ac-character"];
                this._indexWithinMatchedSubstring(c, e) && d.push("google-ac-matched-character");
                d = '<span class="' + d.join(" ").trim() + '">' + a + "</span>";
                return 0 === c ? '<div class="google-ac-address">' + d : c === g ? d +
                  "</div>" : c === g + 1 ? '<div class="google-ac-trailing">' + d : c === b.text.length ? d + "</div>" : d
              }, this).join("")
            }, this)
          },
          _indexWithinMatchedSubstring: function(b, c) {
            return a.Array.some(c, function(a) {
              return b >= a.offset && b < a.offset + a.length
            })
          },
          _filterResults: function(b, c) {
            return a.Array.filter(c, function(a) {
              return this._predictionHasRouteComponent(a.raw) && this._predictionContainsCountryInList(a.raw)
            }, this)
          },
          _predictionContainsCountryInList: function(b) {
            var c = this.get("countriesAllowed");
            return !a.Lang.isArray(c) ||
              0 === c.length ? !0 : a.Array.find(c, function(a) {
                return -1 !== b.description.indexOf(a)
              })
          },
          _predictionHasRouteComponent: function(e) {
            return -1 !== a.Array.indexOf(e.types, b.ROUTE)
          }
        }, {
          ATTRS: {
            countriesAllowed: {
              validator: a.Squarespace.AttrValidators.isNullOrArray
            }
          }
        })
    }, "1.0", {
      requires: "autocomplete-highlighters base event-custom squarespace-attr-validators squarespace-localities squarespace-util".split(" ")
    })
  },
  1602: function(k, n) {
    YUI.add("squarespace-models-shopping-cart", function(b) {
      b.namespace("Squarespace.Models");
      b.namespace("Squarespace.Singletons");
      var h = b.Squarespace.Models.ShoppingCart = b.Base.create("shoppingCart", b.Model, [], {
        initializer: function() {
          this.publish("item-added", {
            emitFacade: !0
          });
          this.publish("loaded", {
            emitFacade: !0
          });
          this.publish("recalculate-start", {
            emitFacade: !0
          });
          this.publish("recalculate-end", {
            emitFacade: !0
          });
          this._isRecalculating = this._readInProgress = !1;
          this.on("recalculate-start", function() {
            this._isRecalculating = !0
          }, this);
          this.on("recalculate-end", function() {
              this._isRecalculating = !1
            },
            this)
        },
        toJSON: function() {
          var a = h.superclass.toJSON.call(this),
            c = a.created;
          b.Lang.isNull(c) || (a.created = c.getTime());
          return a
        },
        sync: function(a, b, d) {
          switch (a) {
            case "read":
              this._read(b, d)
          }
        },
        load: function(a, c, d) {
          "function" === typeof a && (c = a, a = {});
          this._readinProgress ? this.after("load", c, d) : b.Model.prototype.load.call(this, a, c ? b.bind(c, d || this) : null)
        },
        isRecalculating: function() {
          return this._isRecalculating
        },
        hasEntry: function(a, c) {
          return b.Array.reduce(this.get("entries"), !1, function(d, e) {
            return b.Lang.isValue(c) ?
              d || e.itemId == a && c.sku == e.chosenVariant.sku : d || e.itemId == a
          })
        },
        addEntry: function(a, c, d, e, g, f, h) {
          b.Data.post({
            url: "/api/commerce/shopping-cart/entries" + (g ? "?isExpress=true" : ""),
            headers: {
              "Content-Type": "application/json"
            },
            data: b.JSON.stringify({
              itemId: a,
              sku: b.Lang.isValue(c) ? c.sku : null,
              quantity: d,
              additionalFields: b.JSON.stringify(e)
            }),
            success: function(a) {
              b.Squarespace.CommerceAnalytics.itemAdded(a);
              this.setAttrs(a.shoppingCart);
              this.fire("item-added");
              b.Lang.isFunction(f) && f.call(h || this, null, a.newlyAdded)
            },
            failure: function(a) {
              a.crumbFail && (b.Squarespace.Utils.areCookiesEnabled() ? a.error = "Your session has expired. Please reload the page and try again." : a.error = "Please enable cookies in your browser, reload the page, and try again.");
              b.Lang.isFunction(f) && f.call(h || this, a.message, null)
            }
          }, this)
        },
        updateFormSubmission: function(a, c, d, e) {
          var g = a.chosenVariant;
          this.fire("recalculate-start");
          b.Data.put({
            headers: {
              "Content-Type": "application/json"
            },
            url: b.Lang.sub("/api/commerce/shopping-cart/entries/{entryId}/additionalFields", {
              entryId: a.id
            }),
            data: b.JSON.stringify({
              itemId: a.itemId,
              sku: b.Lang.isValue(g) ? g.sku : null,
              additionalFields: b.JSON.stringify(c)
            }),
            success: function(a) {
              this.fire("recalculate-end");
              this.setAttrs(a.shoppingCart);
              b.Lang.isFunction(d) && d.call(e || this, null, a.updatedEntry)
            },
            failure: function(a) {
              this.fire("recalculate-end");
              b.Lang.isFunction(d) && d.call(e || this, a.message, null)
            }
          }, this)
        },
        updateQuantity: function(a, c, d, e) {
          var g = a.chosenVariant;
          this.fire("recalculate-start");
          b.Data.put({
              headers: {
                "Content-Type": "application/json"
              },
              url: b.Lang.sub("/api/commerce/shopping-cart/entries/{entryId}", {
                entryId: a.id
              }),
              data: b.JSON.stringify({
                itemId: a.itemId,
                sku: b.Lang.isValue(g) ? g.sku : null,
                quantity: c
              }),
              success: function(a) {
                this.fire("recalculate-end");
                0 === c ? b.Squarespace.CommerceAnalytics.itemRemoved(a) : b.Squarespace.CommerceAnalytics.itemModified(a);
                this.setAttrs(a.shoppingCart);
                b.Lang.isFunction(d) && d.call(e || this, null, a.updatedEntry)
              },
              failure: function(a) {
                this.fire("recalculate-end");
                b.Lang.isFunction(d) && d.call(e || this, a.message, null)
              }
            },
            this)
        },
        updateShippingLocation: function(a, c, d) {
          this.fire("recalculate-start");
          b.Data.put({
            url: "/api/commerce/shopping-cart/shipping-location",
            data: a,
            success: function(a) {
              this.fire("recalculate-end");
              this.setAttrs(a);
              b.Lang.isFunction(c) && c.call(d || this, null)
            },
            failure: function(a) {
              this.fire("recalculate-end");
              b.Lang.isFunction(c) && c.call(d || this, a.message, null)
            }
          }, this)
        },
        updateShippingMethod: function(a, c, d) {
          this.fire("recalculate-start");
          b.Data.put({
            url: "/api/commerce/shopping-cart/selected-shipping-option",
            data: {
              shippingOptionKey: a
            },
            success: function(a) {
              this.fire("recalculate-end");
              this.setAttrs(a);
              b.Lang.isFunction(c) && c.call(d || this, null)
            },
            failure: function(a) {
              this.fire("recalculate-end");
              b.Lang.isFunction(c) && c.call(d || this, a.message, null)
            }
          }, this)
        },
        addCoupon: function(a, c, d) {
          b.Data.post({
              url: "/api/commerce/shopping-cart/coupons",
              data: {
                promoCode: a
              },
              success: function(a) {
                this.setAttrs(a);
                b.Lang.isFunction(c) && c.call(d || this, null)
              },
              failure: function(a) {
                b.Lang.isFunction(c) && c.call(d || this, a.message, null)
              }
            },
            this)
        },
        removeCoupon: function(a, c, d) {
          b.Data.del({
            url: "/api/commerce/shopping-cart/coupons/" + a,
            success: function(a) {
              this.setAttrs(a);
              b.Lang.isFunction(c) && c.call(d || this, null)
            },
            failure: function(a) {
              b.Lang.isFunction(c) && c.call(d || this, a.message, null)
            }
          }, this)
        },
        updateCustomerInfo: function(a) {
          b.Data.put({
            url: "/api/commerce/shopping-cart/customer",
            data: {
              email: a
            },
            success: this.setAttrs.bind(this),
            failure: function(a) {
              console.warn("An error happened when adding the customer info: ", a)
            }
          }, this)
        },
        totalForItem: function(a,
          c) {
          var d = b.Lang.isValue(c);
          return b.Array.reduce(this.get("entries"), 0, function(b, g) {
            return g.item.id === a && (!d || d && g.chosenVariant.sku === c.sku) ? b + g.quantity : b
          })
        },
        hasShippingOptions: function() {
          var a = this.get("shippingOptions");
          return b.Lang.isArray(a) && 0 < a.length
        },
        hasShippingCountry: function() {
          return b.Lang.isString(this.get("shippingLocation").country)
        },
        _read: function(a, c) {
          this._readInProgress = !0;
          this.fire("loading");
          b.Data.get({
            url: "/api/commerce/shopping-cart",
            data: {
              mock: a.mock ? "true" : "false"
            },
            success: function(a) {
              this.fire("loaded");
              this._readInProgress = !1;
              c(null, a)
            },
            failure: function(a) {
              this.fire("loaded");
              this._readInProgress = !1;
              c(a.message, null)
            }
          }, this)
        }
      }, {
        ATTRS: {
          id: {
            validator: b.Lang.isString
          },
          websiteId: {
            validator: b.Lang.isString
          },
          orderId: {
            validator: b.Lang.isString
          },
          created: {
            getter: function(a) {
              return b.Lang.isValue(a) ? new Date(a) : null
            },
            setter: function(a) {
              return b.Lang.isDate(a) ? a.getTime() : a
            },
            validator: b.Lang.isNumber
          },
          isPurchased: {
            value: !1,
            validator: b.Lang.isBoolean
          },
          entries: {
            value: [],
            validator: b.Lang.isArray
          },
          shippingOptions: {
            value: [],
            validator: b.Lang.isArray
          },
          selectedShippingOption: {
            validator: b.Lang.isObject
          },
          shippingLocation: {
            validator: b.Lang.isObject
          },
          applicableTaxRules: {
            value: [],
            validator: b.Lang.isArray
          },
          coupons: {
            value: [],
            validator: b.Lang.isArray
          },
          validCoupons: {
            value: [],
            validator: b.Lang.isArray
          },
          invalidCoupons: {
            value: [],
            validator: b.Lang.isArray
          },
          subtotalCents: {
            validator: b.Lang.isNumber,
            value: 0
          },
          taxCents: {
            validator: b.Lang.isNumber,
            value: 0
          },
          shippingCostCents: {
            validator: b.Lang.isNumber,
            value: 0
          },
          discountCents: {
            validator: b.Lang.isNumber,
            value: 0
          },
          grandTotalCents: {
            validator: b.Lang.isNumber,
            value: 0
          },
          totalQuantity: {
            validator: b.Lang.isNumber,
            value: 0
          },
          hasDigital: {
            validator: b.Lang.isBoolean,
            value: !1
          },
          purelyDigital: {
            validator: b.Lang.isBoolean,
            value: !1
          },
          requiresShipping: {
            validator: b.Lang.isBoolean,
            value: !1
          }
        }
      });
      b.Squarespace.Singletons.ShoppingCart = new h
    }, "1.0", {
      requires: ["base", "model", "squarespace-commerce-utils", "squarespace-commerce-analytics", "squarespace-util"]
    })
  },
  1607: function(k, n) {
    YUI.add("squarespace-plugin-money-formatter",
      function(b) {
        b.namespace("Squarespace.Plugin");
        b.Squarespace.Plugin.MoneyFormatter = b.Base.create("moneyFormatter", b.Squarespace.Plugin.NumericFormatter, [], {
          _transformToData: function(b) {
            return Number(this.convertToCents(b))
          },
          convertToCents: function(b) {
            b = String(b).replace(/[^\d\.]/g, "");
            if ("" === b) return 0;
            b = b.split(".");
            var a = b[0];
            1 < b.length && (a += "." + b[1].substr(0, 2));
            return Math.round(100 * parseFloat(a, 10))
          }
        }, {
          NS: "moneyFormatterPlugin",
          ATTRS: {
            prefixUnit: {
              valueFn: function() {
                return b.Squarespace.Commerce.currencySymbol()
              }
            },
            displayFormatter: {
              value: b.Squarespace.Commerce.moneyFormat
            }
          }
        })
      }, "1.0", {
        requires: ["plugin", "squarespace-util", "squarespace-commerce-utils", "squarespace-plugin-numeric-formatter"]
      })
  },
  1608: function(k, n) {
    YUI.add("squarespace-plugin-pulsewarn", function(b) {
      b.namespace("Squarespace.Plugin");
      b.Squarespace.Plugin.PulseWarn = b.Base.create("pulseWarn", b.Plugin.Base, [], {
        initializer: function(h) {
          this.config = h;
          this.set("color", h.color);
          this.set("useClass", h.useClass);
          this.set("targetClass", h.targetClass);
          this.set("iterations",
            h.iterations);
          this.get("host").addClass("pulse-warnable");
          b.Lang.isUndefined(h.interval) || this.set("interval", h.interval);
          this._timer = null
        },
        destructor: function() {
          this._timer && (this._timer.cancel(), this._timer = null)
        },
        warn: function() {
          var h = this.get("host"),
            a = this.get("iterations"),
            c = h.getStyle("backgroundColor"),
            d = this.get("color");
          b.Lang.isNull(this._timer) || (this._timer.cancel(), this._timer = null);
          if (this.get("useClass")) {
            var e = this.get("targetClass"),
              c = this.get("interval");
            this.fire("start");
            h.addClass(e);
            this._timer = b.later(c, this, function() {
              0 === a ? (h.removeClass(e), this.fire("stop"), this._timer.cancel(), this._timer = null) : (h.hasClass(e) ? h.removeClass(e) : h.addClass(e), a--)
            }, {}, !0)
          } else {
            var g = new b.Anim({
                node: h,
                to: {
                  backgroundColor: d,
                  opacity: 0.8
                },
                easing: this.get("easingUp"),
                duration: this.get("duration")
              }),
              f = new b.Anim({
                node: h,
                to: {
                  backgroundColor: c,
                  opacity: 1
                },
                easing: this.get("easingDown"),
                duration: this.get("duration")
              });
            g.on("end", function() {
              0 < a && f.run();
              a--
            });
            f.on("end", function() {
                0 < a ? g.run() : this.fire("stop")
              },
              this);
            this.fire("start");
            g.run()
          }
        }
      }, {
        NS: "pulseWarn",
        ATTRS: {
          useClass: {
            value: !1
          },
          iterations: {
            value: 3
          },
          color: {
            value: "#c1b12e"
          },
          interval: {
            value: 2E3
          },
          duration: {
            value: 0.7
          },
          easingUp: {
            value: b.Easing.easeInSine
          },
          easingDown: {
            value: b.Easing.easeOutSine
          }
        }
      })
    }, "1.0", {
      requires: ["base", "plugin", "anim"]
    })
  },
  1612: function(k, n) {
    YUI.add("squarespace-scrolling-auto-complete-list", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Widgets.ScrollingAutoCompleteList = b.Base.create("ScrollingAutoCompleteList",
        b.AutoCompleteList, [], {
          initializer: function() {
            this.publish("keyboardContinue");
            this.publish("listMouseUp");
            this.publish("listMouseDown")
          },
          renderUI: function() {
            h.superclass.renderUI.call(this);
            var a = this._scrollNode = b.Node.create('<div class="' + this.getClassName() + '-scroll-container"></div>');
            this.get("listNode").wrap(a);
            a.hide();
            (a = this.get("className")) && this.get("contentBox").addClass(a)
          },
          bindUI: function() {
            h.superclass.bindUI.call(this);
            var a = this._scrollNode,
              b = this.get("inputNode");
            this.after("activeItemChange",
              function(a) {
                a.newVal && this._scrollToActiveItem()
              }, this);
            this.on("results", function(b) {
              0 < b.results.length ? a.show() : a.hide()
            }, this);
            this.on(["select", "clear"], function() {
              a.hide()
            });
            this.get("boundingBox").on(["focusoutside", "clickoutside"], function(b) {
              a.hide()
            });
            b.on("keydown", function(a) {
              switch (a.keyCode) {
                case 13:
                  this.selectItem();
                  this.fire("keyboardContinue");
                  break;
                case 9:
                  this.get("activeItem") && (this.selectItem(), this.fire("keyboardContinue"));
                  break;
                case 27:
                  this.hide();
                  break;
                case 38:
                  this._activatePrevItem();
                  break;
                case 40:
                  this._activateNextItem()
              }
            }, this);
            this._listNode.delegate("mouseup", function(a) {
              this.fire("listMouseUp");
              a.preventDefault()
            }, this._SELECTOR_ITEM, this);
            this._listNode.delegate("mousedown", function(a) {
              this.fire("listMouseDown")
            }, this._SELECTOR_ITEM, this)
          },
          _activateNextItem: function() {
            h.superclass._activateNextItem.call(this);
            b.Lang.isNull(this.get("activeItem")) && this.set("activeItem", this._getFirstItemNode())
          },
          _activatePrevItem: function() {
            h.superclass._activatePrevItem.call(this);
            b.Lang.isNull(this.get("activeItem")) &&
              this.set("activeItem", this._getLastItemNode())
          },
          _scrollToActiveItem: function() {
            this.get("activeItem").scrollIntoView();
            var a = this._scrollNode,
              b = a.get("scrollTop"),
              d = a.one("li:first-child").get("offsetHeight");
            a.set("scrollTop", d * Math.round(b / d))
          }
        }, {
          CSS_PREFIX: "sqs-scroll-ac",
          ATTRS: {
            className: {
              validator: b.Squarespace.AttrValidators.isNullOrString
            }
          }
        })
    }, "1.0", {
      requires: ["base", "autocomplete", "lang/autocomplete-list", "squarespace-attr-validators", "event-outside"]
    })
  },
  1689: function(k, n) {
    YUI.add("squarespace-widgets-google-places-autocomplete",
      function(b) {
        b.namespace("Squarespace.Widgets");
        b.Squarespace.Widgets.GooglePlacesAutocomplete = b.Base.create("GooglePlacesAutoCompleteWidget", b.Squarespace.Widgets.ScrollingAutoCompleteList, [b.Squarespace.Mixins.GooglePlacesAutocomplete], {}, {
          CSS_PREFIX: b.Squarespace.Widgets.ScrollingAutoCompleteList.CSS_PREFIX
        })
      }, "1.0", {
        requires: ["base", "squarespace-scrolling-auto-complete-list", "squarespace-mixins-google-places-autocomplete"]
      })
  },
  1693: function(k, n) {
    YUI.add("autocomplete-highlighters", function(b, h) {
      var a =
        b.Array,
        c = b.Highlight,
        d = b.mix(b.namespace("AutoCompleteHighlighters"), {
          charMatch: function(b, d, f) {
            var h = a.unique((f ? b : b.toLowerCase()).split(""));
            return a.map(d, function(a) {
              return c.all(a.text, h, {
                caseSensitive: f
              })
            })
          },
          charMatchCase: function(a, b) {
            return d.charMatch(a, b, !0)
          },
          phraseMatch: function(b, d, f) {
            return a.map(d, function(a) {
              return c.all(a.text, [b], {
                caseSensitive: f
              })
            })
          },
          phraseMatchCase: function(a, b) {
            return d.phraseMatch(a, b, !0)
          },
          startsWith: function(b, d, f) {
            return a.map(d, function(a) {
              return c.all(a.text, [b], {
                caseSensitive: f,
                startsWith: !0
              })
            })
          },
          startsWithCase: function(a, b) {
            return d.startsWith(a, b, !0)
          },
          subWordMatch: function(e, d, f) {
            var h = b.Text.WordBreak.getUniqueWords(e, {
              ignoreCase: !f
            });
            return a.map(d, function(a) {
              return c.all(a.text, h, {
                caseSensitive: f
              })
            })
          },
          subWordMatchCase: function(a, b) {
            return d.subWordMatch(a, b, !0)
          },
          wordMatch: function(b, d, f) {
            return a.map(d, function(a) {
              return c.words(a.text, b, {
                caseSensitive: f
              })
            })
          },
          wordMatchCase: function(a, b) {
            return d.wordMatch(a, b, !0)
          }
        })
    }, "3.17.2", {
      requires: ["array-extras",
        "highlight-base"
      ]
    })
  },
  1694: function(k, n) {
    YUI.add("lang/autocomplete-list", function(b) {
      b.Intl.add("autocomplete-list", "", {
        item_selected: "{item} selected.",
        items_available: "Suggestions are available. Use the up and down arrow keys to select suggestions."
      })
    }, "3.17.2")
  },
  1761: function(k, n) {
    YUI.add("squarespace-checkout-form-custom-form-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["checkout-form-custom-form.html"] = a(function(a, b, e, g, f) {
          this.compilerInfo = [4, ">= 1.0.0"];
          this.merge(e, a.helpers);
          var h;
          a = this.escapeExpression;
          return b = "" + ('<div class="title">' + a((h = (h = b.strings, null == h || !1 === h ? h : h.name), "function" === typeof h ? h.apply(b) : h)) + '<a class="edit-button">edit</a></div>\n\n<fieldset>\n\n  <div class="custom-form">\n  </div>\n\n  \x3c!-- Continue --\x3e\n  <div class="btn-container">\n    <div class="button continue-button">Continue</div>\n  </div>\n\n</fieldset>\n')
        })
      })();
      b.Handlebars.registerPartial("checkout-form-custom-form.html".replace("/",
        "."), h.templates["checkout-form-custom-form.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1762: function(k, n) {
    YUI.add("squarespace-checkout-form-payment-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["checkout-form-payment.html"] = a(function(a, b, e, g, f) {
          this.compilerInfo = [4, ">= 1.0.0"];
          e = this.merge(e, a.helpers);
          f = f || {};
          var h, k = this.escapeExpression,
            m = e.helperMissing;
          a = '<div class="title">\n  <a class="edit-button">edit</a>\n\n  <div class="cards">\n    <img src="https://static.squarespace.com/universal/images-v6/checkout/discover.png" />\n    <img src="https://static.squarespace.com/universal/images-v6/checkout/mastercard.png" />\n    <img src="https://static.squarespace.com/universal/images-v6/checkout/visa.png" />\n    <img src="https://static.squarespace.com/universal/images-v6/checkout/americanexpress.png" />\n  </div>\n\n  Billing\n</div>\n\n<fieldset>\n\n  <div class="subtitle">Billing Address</div>\n\n  \x3c!-- bill to shipping --\x3e\n  ';
          if ((g = e["if"].call(b, b.requiresShipping, {
              hash: {},
              inverse: this.noop,
              fn: this.program(1, function(a, b) {
                return '\n    <div class="bill-to-shipping">\n      <label>\n        <input name="billToShipping" class="field-element" type="checkbox" value="true"/>\n        Use Shipping Address\n      </label>\n    </div>\n  '
              }, f),
              data: f
            })) || 0 === g) a += g;
          h = {
            hash: {
              "short": "true"
            },
            data: f
          };
          a = a + '\n\n  \x3c!-- Billing Information --\x3e\n  <div id="billing-address">\n\n    \x3c!-- First Name --\x3e\n    <div id="billing-first-name" data-label="First Name" class="field first-name required">\n      <label>First Name</label>\n      <input name="billingFirstName" class="field-element" placeholder="First Name"\n          x-autocompletetype="given-name" type="text" spellcheck="false" maxlength="30" />\n    </div>\n\n\n    \x3c!-- Last Name --\x3e\n    <div id="billing-last-name" data-label="Last Name" class="field last-name required">\n      <label>Last Name</label>\n      <input name="billingLastName" class="field-element" placeholder="Last Name"\n          x-autocompletetype="surname"a type="text" spellcheck="false" maxlength="30" />\n    </div>\n\n\n    \x3c!-- Billing Address 1 --\x3e\n    <div id="billing-address-1" data-label="Address Line 1" class="field required">\n      <label>Address Line 1</label>\n      <input name="billingAddress1" class="field-element address-line1"\n          placeholder="Address Line 1" x-autocompletetype="address-line1" type="text" spellcheck="false" maxlength="50" />\n    </div>\n\n\n    \x3c!-- Billing Address 2 --\x3e\n    <div id="billing-address-2" data-label="Address Line 2" class="field">\n      <label>Address Line 2</label>\n      <input name="billingAddress2" class="field-element address-line2"\n          placeholder="Address Line 2" type="text" x-autocompletetype="address-line2" spellcheck="false" maxlength="50" />\n    </div>\n\n\n    \x3c!-- Country --\x3e\n    <div id="billing-country" data-label="Country" class="field country required">\n      <label>Country</label>\n      <select name="billingCountry" class="field-element" x-autocompletetype="country-name">\n      </select>\n    </div>\n\n\n    \x3c!-- City --\x3e\n    <div id="billing-city" data-label="City" class="field city required">\n      <label>City</label>\n      <input name="billingCity" class="field-element" placeholder="City" type="text"\n          spellcheck="false" maxlength="30" />\n    </div>\n\n\n    \x3c!-- State/Province --\x3e\n    <div id="billing-state" data-label="State/Province" class="field state required">\n      <label>State/Province</label>\n      <select name="billingState" class="field-element" x-autocompletetype="state">\n      </select>\n    </div>\n\n\n    \x3c!-- Zip Code --\x3e\n    <div id="billing-zip" data-label="Zip Code" class="field zip required">\n      <label>Zip / Postal</label>\n      <input name="billingZip" class="field-element" placeholder="Zip / Postal" type="text"\n          spellcheck="false" maxlength="10" />\n    </div>\n\n  </div>\n\n  <div class="subtitle">Secure Payment</div>\n\n  \x3c!--\n    Credit Card Fields\n    NOTA BENE: These INPUTs are left without \'name\' because we ABSOLUTELY must NOT\n    transmit these values to our own servers.\n  --\x3e\n  <div id="credit-card">\n\n    \x3c!-- Name --\x3e\n    <input name="cardHolderName" type="hidden" />\n\n    \x3c!-- Card Number --\x3e\n    <div id="card-number" data-label="Card Number" class="field required">\n      <label>Card Number</label>\n\n      <input class="field-element" size="20"\n          autocomplete="off" placeholder="Card Number" value="" />\n    </div>\n\n    \x3c!-- Expiry/CVC --\x3e\n    <div id="expiry-cvc">\n\n      \x3c!-- Expiry Month --\x3e\n      <div id="card-expiry-month" data-label="Exp. Mo." class="field">\n        <label>Exp. Mo.</label>\n        <select class="field-element" value="04" >\n          ' +
            (k((g = e["month-options"] || b["month-options"], g ? g.call(b, h) : m.call(b, "month-options", h))) + '\n        </select>\n      </div>\n\n      \x3c!-- Expiry Year --\x3e\n      <div id="card-expiry-year" data-label="Exp. Yr." class="field">\n        <label>Exp. Yr.</label>\n        <select class="field-element" value="2015" >\n          ');
          (h = e["year-options"]) ? h = h.call(b, {
            hash: {},
            data: f
          }): (h = b["year-options"], h = "function" === typeof h ? h.apply(b) : h);
          a += k(h) + '\n        </select>\n      </div>\n\n      \x3c!-- CVC --\x3e\n      <div id="cvc" data-label="CVC" class="field required">\n        <label>CVC</label>\n        <input class="field-element" size="4" autocomplete="off"\n            placeholder="CVC" value="" />\n      </div>\n\n    </div>\n\n  </div> \x3c!-- end #credit-card --\x3e\n\n\n  \x3c!-- Secure payment conditions --\x3e\n  <div id="comfort">\n    All transactions are secure and encrypted, and we never store your credit card information. Payments are\n    processed through Stripe. Payment information is also governed by\n    <a target="_blank" href="https://stripe.com/privacy">Stripe\'s privacy policy</a>.\n  </div>\n\n\n  \x3c!-- Place Order --\x3e\n  <div id="place-order">\n    <div id="place-order-button" class="button continue-button" value="Place Order" >' +
            k((g = (g = b.strings, null == g || !1 === g ? g : g.submitText), "function" === typeof g ? g.apply(b) : g)) + '</div>\n\n    <div class="wait-in-queue-message" style="display: none">\n      Due to heavy traffic, your payment will be accepted shortly. Please don\'t hit the "back" button or leave the page.\n    </div>\n\n    \x3c!-- hidden field to convey the Stripe Token so we may submit the charge --\x3e\n    <input name="stripeToken" type="hidden" />\n\n    \x3c!-- optional hidden fields --\x3e\n    ';
          if ((h = e.each.call(b,
              b.optionalHiddenFields, {
                hash: {},
                inverse: this.noop,
                fn: this.program(3, function(a, b) {
                  var c;
                  return c = "" + ('\n      <input name="' + k("function" === typeof a ? a.apply(a) : a) + '" type="hidden" />\n    ')
                }, f),
                data: f
              })) || 0 === h) a += h;
          return a += "\n\n  </div>\n\n</fieldset>\n"
        })
      })();
      b.Handlebars.registerPartial("checkout-form-payment.html".replace("/", "."), h.templates["checkout-form-payment.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1763: function(k, n) {
    YUI.add("squarespace-checkout-form-shipping-info-template",
      function(b) {
        var h = b.Handlebars;
        (function() {
          var a = h.template;
          (h.templates = h.templates || {})["checkout-form-shipping-info.html"] = a(function(a, b, e, g, f) {
            function h(a, b) {
              return 'checked="checked"'
            }
            this.compilerInfo = [4, ">= 1.0.0"];
            e = this.merge(e, a.helpers);
            f = f || {};
            var k, m = this;
            a = '<div class="title">\n  Contact &amp; Shipping\n  <a class="edit-button">edit</a>\n</div>\n\n<fieldset>\n\n    <div class="subtitle contact-info-subtitle">Your Email Address</div>\n    \x3c!-- Email Address --\x3e\n    <div id="email" data-label="Email Address" class="field email required">\n      <label>Email Address</label>\n      <input name="email" class="field-element" placeholder="Email"\n          x-autocompletetype="email" type="email" spellcheck="false" maxlength="50" type="email" />\n    </div>\n    <div class="description">Receipts and notifications will be sent to this email address.</div>\n\n    ';
            if ((b = e["if"].call(b, (k = b.optionalFields, null == k || !1 === k ? k : k.showMailingList), {
                hash: {},
                inverse: m.noop,
                fn: m.program(1, function(a, b) {
                    var c, d;
                    c = '\n      \x3c!-- Mailchimp (optional) --\x3e\n      <div class="join-mailing-list">\n        <label>\n          <input type="checkbox" name="joinMailingList" class="field-element" ';
                    if ((d = e["if"].call(a, a.enableMailingListOptInByDefault, {
                        hash: {},
                        inverse: m.noop,
                        fn: m.program(2, h, b),
                        data: b
                      })) || 0 === d) c += d;
                    return c + ' value="true"></input>\n          Join our mailing list\n        </label>\n      </div>\n    '
                  },
                  f),
                data: f
              })) || 0 === b) a += b;
            return a + '\n\n  <div class="subtitle shipping-address-subtitle">Shipping Address</div>\n\n  \x3c!-- Shipping Address --\x3e\n  <div id="shipping-address-wrapper">\n\n    <div class="shipping-fields">\n\n      \x3c!-- First Name --\x3e\n      <div id="shipping-first-name" data-label="First Name" class="field first-name required">\n        <label>First Name</label>\n        <input name="shippingFirstName" class="field-element"\n            placeholder="First Name" x-autocompletetype="given-name" type="text" spellcheck="false" maxlength="30" />\n      </div>\n\n\n      \x3c!-- Last Name --\x3e\n      <div id="shipping-last-name" data-label="Last Name" class="field last-name required">\n        <label>Last Name</label>\n        <input name="shippingLastName" class="field-element" placeholder="Last Name"\n            x-autocompletetype="surname" type="text" spellcheck="false" maxlength="30" />\n      </div>\n\n\n      \x3c!-- Shipping Address 1 --\x3e\n      <div id="shipping-address-1" data-label="Address Line 1" class="field address required">\n        <label>Address Line 1</label>\n        <input name="shippingAddress1" class="field-element address-line1" type="text"\n            x-autocompletetype="address-line1" placeholder="Street Address 1" spellcheck="false" maxlength="50" />\n      </div>\n\n\n      \x3c!-- Shipping Address 2 --\x3e\n      <div id="shipping-address-2" data-label="Address Line 2" class="field address">\n        <label>Address Line 2</label>\n        <input name="shippingAddress2" class="field-element address-line2" type="text"\n            placeholder="Street Address 2" x-autocompletetype="address-line2" spellcheck="false" maxlength="50" />\n      </div>\n\n\n      \x3c!-- Country --\x3e\n      <div id="shipping-country" data-label="Country" class="field country required">\n        <label>Country</label>\n        <select name="shippingCountry" class="field-element"\n            x-autocompletetype="country-name">\n        </select>\n      </div>\n\n\n      \x3c!-- City --\x3e\n      <div id="shipping-city" data-label="City" class="field city required">\n        <label>City</label>\n        <input name="shippingCity" class="field-element" placeholder="City"\n            x-autocompletetype="city" type="text" spellcheck="false" maxlength="30" />\n      </div>\n\n\n      \x3c!-- State/Province --\x3e\n      <div id="shipping-state" data-label="State/Province" class="field state required">\n        <label>State/Province</label>\n        <select name="shippingState" class="field-element"\n            x-autocompletetype="state">\n        </select>\n      </div>\n\n\n      \x3c!-- Zip Code --\x3e\n      <div id="shipping-zip" data-label="Zip Code" class="field zip required">\n        <label>Zip / Postal</label>\n        <input name="shippingZip" class="field-element"\n            x-autocompletetype="postal-code" placeholder="Zip / Postal" type="text" spellcheck="false" maxlength="10" />\n      </div>\n\n      <div id="phone" data-label="Phone Number" class="field phone">\n        <label>Phone Number</label>\n        <input name="phone" class="field-element" placeholder="Phone Number"\n            x-autocompletetype="phone" spellcheck="false" maxlength="20" type="tel" />\n      </div>\n\n    </div>\n\n\n  </div> \x3c!-- end #shipping-address --\x3e\n\n\n\n  \x3c!-- Continue --\x3e\n  <div class="btn-container">\n    <div class="button continue-button">Continue</div>\n  </div>\n\n</fieldset>\n'
          })
        })();
        b.Handlebars.registerPartial("checkout-form-shipping-info.html".replace("/", "."), h.templates["checkout-form-shipping-info.html"])
      }, "1.0", {
        requires: ["handlebars-base"]
      })
  },
  1764: function(k, n) {
    YUI.add("squarespace-checkout-saved-contribution-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["checkout-saved-contribution.html"] = a(function(a, b, e, g, f) {
          this.compilerInfo = [4, ">= 1.0.0"];
          e = this.merge(e, a.helpers);
          f = f || {};
          var h = this.escapeExpression;
          a = '<div class="saved-fieldset">\n\n  You will donate ';
          (g = e.donationAmount) ? g = g.call(b, {
            hash: {},
            data: f
          }): (g = b.donationAmount, g = "function" === typeof g ? g.apply(b) : g);
          if (g || 0 === g) a += g;
          a += " to ";
          (g = e.title) ? g = g.call(b, {
            hash: {},
            data: f
          }): (g = b.title, g = "function" === typeof g ? g.apply(b) : g);
          return a += h(g) + "\n\n</div>\n"
        })
      })();
      b.Handlebars.registerPartial("checkout-saved-contribution.html".replace("/", "."), h.templates["checkout-saved-contribution.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1765: function(k, n) {
    YUI.add("squarespace-checkout-saved-custom-form-template",
      function(b) {
        var h = b.Handlebars;
        (function() {
          var a = h.template;
          (h.templates = h.templates || {})["checkout-saved-custom-form.html"] = a(function(a, b, e, g, f) {
            this.compilerInfo = [4, ">= 1.0.0"];
            e = this.merge(e, a.helpers);
            f = f || {};
            a = '<div class="saved-fieldset">\n\n  ';
            if ((b = e.each.call(b, b.fields, {
                hash: {},
                inverse: this.noop,
                fn: this.program(1, function(a, b) {
                  var c, e;
                  c = "\n  <div>\n    ";
                  if ((e = "function" === typeof a ? a.apply(a) : a) || 0 === e) c += e;
                  return c + "\n  </div> \n  "
                }, f),
                data: f
              })) || 0 === b) a += b;
            return a + "\n\n</div>\n"
          })
        })();
        b.Handlebars.registerPartial("checkout-saved-custom-form.html".replace("/", "."), h.templates["checkout-saved-custom-form.html"])
      }, "1.0", {
        requires: ["handlebars-base"]
      })
  },
  1766: function(k, n) {
    YUI.add("squarespace-checkout-saved-shipping-info-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["checkout-saved-shipping-info.html"] = a(function(a, b, e, g, f) {
          function h(a, b) {
            var c;
            (c = e.shippingCity) ? c = c.call(a, {
              hash: {},
              data: b
            }): (c = a.shippingCity, c = typeof c === q ? c.apply(a) :
              c);
            return p(c)
          }

          function k(a, b) {
            var c, d;
            c = ",&nbsp;";
            (d = e.shippingState) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.shippingState, d = typeof d === q ? d.apply(a) : d);
            return c += p(d)
          }

          function m(a, b) {
            var c, d;
            c = "&nbsp;&nbsp;";
            (d = e.shippingZip) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.shippingZip, d = typeof d === q ? d.apply(a) : d);
            return c += p(d)
          }
          this.compilerInfo = [4, ">= 1.0.0"];
          e = this.merge(e, a.helpers);
          f = f || {};
          var r, q = "function",
            p = this.escapeExpression,
            n = this;
          g = e.blockHelperMissing;
          a = '<div class="saved-fieldset">\n\n  ';
          r = {
            hash: {},
            inverse: n.noop,
            fn: n.program(1, function(a, b) {
              var c, d;
              c = '\n\n    <div class="subtitle">Your Email Address</div>\n    <div>';
              (d = e.email) ? d = d.call(a, {
                hash: {},
                data: b
              }): (d = a.email, d = typeof d === q ? d.apply(a) : d);
              c += p(d) + '</div>\n    <br />\n    \n\n    <div class="subtitle">Shipping Address</div>\n    <div>\n      ';
              (d = e.shippingFirstName) ? d = d.call(a, {
                hash: {},
                data: b
              }): (d = a.shippingFirstName, d = typeof d === q ? d.apply(a) : d);
              c += p(d) + "&nbsp;";
              (d = e.shippingLastName) ? d = d.call(a, {
                hash: {},
                data: b
              }): (d = a.shippingLastName,
                d = typeof d === q ? d.apply(a) : d);
              c += p(d) + "\n    </div>\n    <div>";
              (d = e.shippingAddress1) ? d = d.call(a, {
                hash: {},
                data: b
              }): (d = a.shippingAddress1, d = typeof d === q ? d.apply(a) : d);
              c += p(d) + "</div>\n    <div>";
              (d = e.shippingAddress2) ? d = d.call(a, {
                hash: {},
                data: b
              }): (d = a.shippingAddress2, d = typeof d === q ? d.apply(a) : d);
              c += p(d) + "</div>\n\n    <div>\n      ";
              if ((d = e["if"].call(a, a.shippingCity, {
                  hash: {},
                  inverse: n.noop,
                  fn: n.program(2, h, b),
                  data: b
                })) || 0 === d) c += d;
              if ((d = e["if"].call(a, a.shippingState, {
                  hash: {},
                  inverse: n.noop,
                  fn: n.program(4,
                    k, b),
                  data: b
                })) || 0 === d) c += d;
              if ((d = e["if"].call(a, a.shippingZip, {
                  hash: {},
                  inverse: n.noop,
                  fn: n.program(6, m, b),
                  data: b
                })) || 0 === d) c += d;
              c += "\n    </div>\n\n    <div>";
              (d = e.shippingCountry) ? d = d.call(a, {
                hash: {},
                data: b
              }): (d = a.shippingCountry, d = typeof d === q ? d.apply(a) : d);
              c += p(d) + "</div>\n    <div>";
              (d = e.phone) ? d = d.call(a, {
                hash: {},
                data: b
              }): (d = a.phone, d = typeof d === q ? d.apply(a) : d);
              return c += p(d) + "</div>\n\n    <br />\n\n  "
            }, f),
            data: f
          };
          (f = e.requiresShipping) ? f = f.call(b, r): (f = b.requiresShipping, f = typeof f === q ? f.apply(b) :
            f);
          e.requiresShipping || (f = g.call(b, f, r));
          if (f || 0 === f) a += f;
          return a + "\n\n</div>\n"
        })
      })();
      b.Handlebars.registerPartial("checkout-saved-shipping-info.html".replace("/", "."), h.templates["checkout-saved-shipping-info.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1769: function(k, n) {
    YUI.add("squarespace-contribution-summary-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["contribution-summary.html"] = a(function(a, b, e, g, f) {
          function h(a, b) {
            var c, d;
            c = "\n<p>\n  ";
            (d = e.description) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.description, d = typeof d === p ? d.apply(a) : d);
            return c += v(d) + "\n</p>\n"
          }

          function k(a, b) {
            var c, d;
            c = '\n      <div class="suggested-contributions">\n        ';
            if ((d = e.each.call(a, a.suggestedContributions, {
                hash: {},
                inverse: s.noop,
                fn: s.program(5, m, b),
                data: b
              })) || 0 === d) c += d;
            return c + '\n\n        <div class="option">\n          <input type="radio" name="contribution" id="other" value="other" />\n          <label for="other">Other \n            &nbsp;<input type="text" placeholder="Enter Other Amount" name="contributionAmount" />\n          </label>\n          <br />\n        </div>\n      </div>\n    '
          }

          function m(a, b) {
            var c, d;
            c = '\n          <div class="option">\n            <input type="radio" name="contribution" id="';
            (d = e.amountCents) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.amountCents, d = typeof d === p ? d.apply(a) : d);
            c += v(d) + '" value="';
            (d = e.amountCents) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.amountCents, d = typeof d === p ? d.apply(a) : d);
            c += v(d) + '" />\n            <label for="';
            (d = e.amountCents) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.amountCents, d = typeof d === p ? d.apply(a) : d);
            c += v(d) + '"><span class="sqs-money-native">';
            (d = e.amountDollars) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.amountDollars, d = typeof d === p ? d.apply(a) : d);
            c += v(d) + "</span>&nbsp;";
            if ((d = e["if"].call(a, a.label, {
                hash: {},
                inverse: s.noop,
                fn: s.program(6, n, b),
                data: b
              })) || 0 === d) c += d;
            return c + "</label><br />\n          </div>\n        "
          }

          function n(a, b) {
            var c, d;
            c = "(";
            (d = e.label) ? d = d.call(a, {
              hash: {},
              data: b
            }): (d = a.label, d = typeof d === p ? d.apply(a) : d);
            return c += v(d) + ")"
          }

          function q(a, b) {
            return '\n    \n      <input type="text" placeholder="Enter Other Amount" name="contributionAmount" /><br />\n    '
          }
          this.compilerInfo = [4, ">= 1.0.0"];
          e = this.merge(e, a.helpers);
          f = f || {};
          a = "";
          var p = "function",
            v = this.escapeExpression,
            s = this;
          if ((b = e["with"].call(b, b.donatePage, {
              hash: {},
              inverse: s.noop,
              fn: s.program(1, function(a, b) {
                var c, d;
                c = '\n\n<div class="title">Your Contribution<a class="edit-button">edit</a></div>\n\n<fieldset>\n\n';
                if ((d = e["if"].call(a, a.description, {
                    hash: {},
                    inverse: s.noop,
                    fn: s.program(2, h, b),
                    data: b
                  })) || 0 === d) c += d;
                c += '\n\n<div class="choices">\n\n  <div class="title prompt"></div>\n  <div class="contribution-option-list">\n\n    \n    ';
                if ((d = e["if"].call(a, a.suggestedContributions, {
                    hash: {},
                    inverse: s.program(8, q, b),
                    fn: s.program(4, k, b),
                    data: b
                  })) || 0 === d) c += d;
                return c + '\n\n  </div>\n\n</div>\n\n\n\x3c!-- Continue --\x3e\n<div class="btn-container">\n  <div class="button continue-button">Continue</div>\n</div>\n\n</fieldset>\n'
              }, f),
              data: f
            })) || 0 === b) a += b;
          return a + "\n"
        })
      })();
      b.Handlebars.registerPartial("contribution-summary.html".replace("/", "."), h.templates["contribution-summary.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1784: function(k,
    n) {
    YUI.add("squarespace-full-page-shopping-cart-item-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["full-page-shopping-cart-item.html"] = a(function(a, b, e, g, f) {
          this.compilerInfo = [4, ">= 1.0.0"];
          e = this.merge(e, a.helpers);
          f = f || {};
          a = '<tr>\n\n  <td class="item">\n    <div class="item-image"></div>\n  </td>\n\n  <td class="item-desc"></td>\n\n  <td class="quantity">\n    ';
          if ((b = e["if"].call(b, b.isPhysicalProduct, {
              hash: {},
              inverse: this.program(3, function(a,
                b) {
                return '\n      <div class="not-applicable">N/A</div>\n    '
              }, f),
              fn: this.program(1, function(a, b) {
                return '\n      <input />\n      <div class="cooldown">&bull;</div>\n    '
              }, f),
              data: f
            })) || 0 === b) a += b;
          return a + '\n  </td>\n\n  <td class="price"></td>\n\n  <td class="remove">\n    <div class="remove-item">\u00d7</div>\n  </td>\n\n</tr>\n'
        })
      })();
      b.Handlebars.registerPartial("full-page-shopping-cart-item.html".replace("/", "."), h.templates["full-page-shopping-cart-item.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1785: function(k, n) {
    YUI.add("squarespace-full-page-shopping-cart-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["full-page-shopping-cart.html"] = a(function(a, b, e, g, f) {
          this.compilerInfo = [4, ">= 1.0.0"];
          this.merge(e, a.helpers);
          return '<div class="loading-spinner"></div>\n\n<h2>Shopping Cart</h2>\n\n<div class="cart-container">\n\n  <table>\n\n    <thead> \n      <tr>\n        <td class="item">Item</td>\n        <td></td>\n        <td class="quantity">Quantity</td>\n        <td class="price">Price</td>\n        <td></td>\n      </tr>\n    </thead>\n\n    <tbody></tbody>\n\n  </table>\n\n  <div class="subtotal">\n    <span class="label">Subtotal</span>\n    <span class="price"></span>\n  </div>\n\n  <div class="checkout">\n    <div class="checkout-button sqs-system-button sqs-editable-button">CHECKOUT</div>\n  </div>\n\n</div>\n\n<div class="empty-message">\n  You have nothing in your shopping cart.&nbsp;\n  <a href="/">Continue Shopping</a>\n</div>\n'
        })
      })();
      b.Handlebars.registerPartial("full-page-shopping-cart.html".replace("/", "."), h.templates["full-page-shopping-cart.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1786: function(k, n) {
    YUI.add("squarespace-pill-shopping-cart-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["pill-shopping-cart.html"] = a(function(a, b, e, g, f) {
          this.compilerInfo = [4, ">= 1.0.0"];
          this.merge(e, a.helpers);
          return '<div class="icon"></div>\n\n<div class="details">\n  <span class="total-quantity"></span>\n  <span class="suffix"></span>\n</div>\n\n<span class="subtotal">\n  <span class="price"></span>\n</span>\n'
        })
      })();
      b.Handlebars.registerPartial("pill-shopping-cart.html".replace("/", "."), h.templates["pill-shopping-cart.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  1787: function(k, n) {
    YUI.add("squarespace-shipping-options-list-option-template", function(b) {
        var h = b.Handlebars;
        (function() {
          var a = h.template;
          (h.templates = h.templates || {})["shipping-options-list-option.html"] = a(function(a, b, e, g, f) {
            this.compilerInfo = [4, ">= 1.0.0"];
            e = this.merge(e, a.helpers);
            f = f || {};
            var h = this.escapeExpression,
              k = e.helperMissing;
            a = '<div class="shipping-option ';
            if ((g = e["if"].call(b, b.showAlert, {
                hash: {},
                inverse: this.noop,
                fn: this.program(1, function(a, b) {
                  return "disabled"
                }, f),
                data: f
              })) || 0 === g) a += g;
            a += '">\n\n  <div class="option">\n\n    <label class="shipping-option-label">\n\n      <input type="radio" value="';
            (g = e.id) ? g = g.call(b, {
              hash: {},
              data: f
            }): (g = b.id, g = "function" === typeof g ? g.apply(b) : g);
            a += h(g) + '" title="';
            (g = e.name) ? g = g.call(b, {
              hash: {},
              data: f
            }): (g = b.name, g = "function" === typeof g ? g.apply(b) : g);
            a += h(g) + '" data-computed-cost="';
            (g = e.computedCost) ? g = g.call(b, {
              hash: {},
              data: f
            }): (g = b.computedCost, g = "function" === typeof g ? g.apply(b) : g);
            a += h(g) + '"\n          name="selectedShippingOption" ';
            if ((g = e["if"].call(b, b.showAlert, {
                hash: {},
                inverse: this.noop,
                fn: this.program(3, function(a, b) {
                  return 'disabled="true"'
                }, f),
                data: f
              })) || 0 === g) a += g;
            a += ' />\n      <span class="option-name" title="';
            (g = e.name) ? g = g.call(b, {
              hash: {},
              data: f
            }): (g = b.name, g = "function" === typeof g ? g.apply(b) : g);
            a += h(g) + '">';
            (g = e.name) ? g = g.call(b, {
              hash: {},
              data: f
            }): (g = b.name, g = "function" === typeof g ? g.apply(b) :
              g);
            a += h(g) + '</span>\n\n      <div class="shipping-failure">\n        <img src="/universal/images-v6/dialog/tiny-alert-inverted.png" />\n      </div>\n\n      <span class="cost">&mdash;&nbsp;<strong>';
            f = {
              hash: {},
              data: f
            };
            return a += h((g = e["money-string"] || b["money-string"], g ? g.call(b, b.computedCost, f) : k.call(b, "money-string", b.computedCost, f))) + "</strong></span>\n\n    </label>\n\n  </div>\n\n</div>"
          })
        })();
        b.Handlebars.registerPartial("shipping-options-list-option.html".replace("/", "."), h.templates["shipping-options-list-option.html"])
      },
      "1.0", {
        requires: ["handlebars-base"]
      })
  },
  1788: function(k, n) {
    YUI.add("squarespace-shipping-options-list-template", function(b) {
      var h = b.Handlebars;
      (function() {
        var a = h.template;
        (h.templates = h.templates || {})["shipping-options-list.html"] = a(function(a, b, e, g, f) {
          this.compilerInfo = [4, ">= 1.0.0"];
          this.merge(e, a.helpers);
          return '<div class="empty-message">\n  You cannot continue checkout because there are no shipping options available\n  for the country you\'ve selected.\n</div>\n\n<div class="loading-spinner"></div>\n<div class="options-container"></div>\n'
        })
      })();
      b.Handlebars.registerPartial("shipping-options-list.html".replace("/", "."), h.templates["shipping-options-list.html"])
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  2096: function(k, n) {
    YUI.add("squarespace-checkout-form-address", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Localities,
        a = h.COUNTRY_OPTIONS.US,
        c = h.COUNTRY_OPTIONS.CA,
        d = b.Squarespace.Widgets.CheckoutFormAddress = b.Base.create("checkoutFormAddress", b.Squarespace.Widgets.CheckoutFormSection, [], {
          renderUI: function() {
            d.superclass.renderUI.call(this);
            try {
              this._autoComplete = new b.Squarespace.Widgets.GooglePlacesAutocomplete({
                inputNode: this.get("contentBox").one("input.address-line1"),
                render: !0,
                countriesAllowed: this.get("countriesAllowed")
              })
            } catch (a) {
              console.error(a)
            }
          },
          bindUI: function() {
            d.superclass.bindUI.call(this);
            this._bindUseAddressForShippingChange();
            this._bindZipChange();
            this._bindCountryChange();
            this._bindStateChange();
            try {
              this._bindGoogleAutoComplete()
            } catch (a) {
              console.error(a)
            }
          },
          syncUI: function() {
            d.superclass.syncUI.call(this);
            this._populateCountrySelect();
            this._updateStateFieldForSelectedCountry();
            this._syncRequiredFieldsForSelectedCountry()
          },
          setValues: function(a) {
            d.superclass.setValues.call(this, a);
            this.get("useAddressForShipping") && this.fire("shippingLocationChange")
          },
          _bindUseAddressForShippingChange: function() {
            this.after("useAddressForShippingChange", function(a) {
              !0 === a.newVal && this.fire("shippingLocationChange")
            }, this)
          },
          _bindZipChange: function() {
            this.get("contentBox").one(".zip input").after("change", function() {
              this.get("useAddressForShipping") &&
                this.fire("shippingLocationChange")
            }, this)
          },
          _bindCountryChange: function() {
            this.get("contentBox").one(".country select").after("change", function() {
              this.syncUI();
              this.get("useAddressForShipping") && this.fire("shippingLocationChange")
            }, this)
          },
          _bindStateChange: function() {
            this.get("contentBox").delegate("change", function() {
              this.get("useAddressForShipping") && this.fire("shippingLocationChange")
            }, ".state .field-element", this)
          },
          _bindGoogleAutoComplete: function() {
            this._autoComplete.on("placeDetails", function(a) {
              this._setSelectedCountry(a.place.country);
              this.syncUI();
              this._populateFieldsFromAc(a.place)
            }, this);
            this._autoComplete.on(["keyboardContinue", "listMouseUp"], function() {
              this.get("contentBox").one("input.address-line2").focus()
            }, this)
          },
          _getSelectedCountry: function() {
            return this.get("contentBox").one(".country select").get("value")
          },
          _setSelectedCountry: function(a) {
            this.get("contentBox").one(".country select").set("value", a)
          },
          _getSelectedState: function() {
            return this.get("contentBox").one(".state select").get("value")
          },
          _countryRequiresStateAndZip: function(b) {
            return b ===
              a.title || b === c.title
          },
          _shouldValidateStateZipEnclosure: function() {
            return this._getSelectedCountry() === a.title
          },
          _syncRequiredFieldsForSelectedCountry: function() {
            this.get("contentBox").all(".state, .zip").toggleClass("required", this._countryRequiresStateAndZip(this._getSelectedCountry()))
          },
          _zipFieldIsInvalid: function(b) {
            var c = /^\d{5}(-\d{4})?$/;
            return this._getSelectedCountry() === a.title ? !c.test(b.one(".field-element").get("value").trim()) : !1
          },
          _emailFieldIsInvalid: function(a) {
            return !b.Squarespace.EmailUtils.isValid(a.one(".field-element").get("value"))
          },
          _validateField: function(a) {
            var b = d.superclass._validateField.call(this, a);
            if (b) return b;
            if (a.hasClass("zip") && this._zipFieldIsInvalid(a) || a.hasClass("email") && this._emailFieldIsInvalid(a)) return {
              type: this.getProperty("FIELD_ERROR_TYPES").VALIDATION,
              field: a
            }
          },
          _buildSingleOptionString: function(a) {
            return '<option value="' + a + '">' + a + "</option>"
          },
          _buildOptionString: function(a) {
            return b.Array.reduce(a, "", function(a, b) {
              return "Not Specified" === b ? a : a + this._buildSingleOptionString(b)
            }, this)
          },
          _getCountryTitles: function() {
            var a =
              b.Array.filter(b.Object.values(h.COUNTRY_OPTIONS), function(a) {
                return !a.empty
              });
            return b.Array.map(a, function(a) {
              return a.title
            })
          },
          _getStateCodesForSelectedCountry: function() {
            var a = h.countryCodeFromName(this._getSelectedCountry());
            if ("" === a || !b.Lang.isValue(a)) a = "US";
            a = h.COUNTRIES_TO_STATES[a];
            return b.Lang.isValue(a) ? (a = b.Object.keys(a), a.sort(), a) : []
          },
          _fetchAsyncValidatedErrors: function() {
            var a = this.getLocationForShipping();
            return !this._shouldValidateStateZipEnclosure() ? b.when([]) : new b.Promise(b.bind(function(c) {
              b.Data.get({
                url: b.Squarespace.API_ROOT +
                  "commerce/shipping/address/validate",
                headers: {
                  "Content-Type": "application/json"
                },
                data: {
                  state: a.state,
                  zip: a.zip
                },
                success: b.bind(function(a) {
                  a.stateOwnsZip ? c([]) : c([{
                    type: this.getProperty("FIELD_ERROR_TYPES").CUSTOM,
                    message: "ZIP Code does not belong to that State."
                  }])
                }, this)
              })
            }, this))
          },
          _populateCountrySelect: function() {
            var c = this.get("contentBox").one(".country select"),
              d = this._getSelectedCountry(),
              f = this.get("countriesAllowed");
            c.empty();
            0 === f.length ? c.setHTML(this._buildSingleOptionString(a.title)) :
              (c.setHTML(this._buildOptionString(f)), -1 !== b.Array.indexOf(f, d) ? c.set("value", d) : -1 !== b.Array.indexOf(f, a.title) ? c.set("value", a.title) : c.set("value", f[0]))
          },
          _updateStateFieldForSelectedCountry: function(a) {
            var c = this.get("contentBox").one(".state .field-element");
            a = b.Lang.isValue(a) ? h.countryCodeFromName(a) : h.countryCodeFromName(this._getSelectedCountry());
            var d;
            h.COUNTRIES_TO_STATES[a] ? c.test("select") || (d = b.Node.create('<select class="field-element state required" name="' + c.getAttribute("name") +
              '"></select>')) : c.test("input") || (d = b.Node.create('<input class="field-element state" placeholder="State" name="' + c.getAttribute("name") + '" />'));
            d && (d.plug(b.Squarespace.Plugin.PulseWarn, {
              iterations: 1,
              useClass: !0,
              targetClass: "warn",
              interval: 1300
            }), c.replace(d), c = d);
            if (c.test("select")) {
              d = this._getSelectedState();
              a = this._getStateCodesForSelectedCountry();
              c.empty();
              var l = this._buildSingleOptionString("") + this._buildOptionString(a);
              c.setHTML(l); - 1 !== b.Array.indexOf(a, d) && c.set("value", d)
            }
          }
        }, {
          CSS_PREFIX: "sqs-checkout-form-address",
          ATTRS: {
            strings: {
              value: null
            },
            countriesAllowed: {
              value: []
            },
            getCountriesAllowed: {
              value: function() {}
            },
            useAddressForShipping: {
              value: !1
            }
          }
        })
    }, "1.0", {
      requires: "autocomplete cookie node squarespace-email-utils squarespace-localities squarespace-util squarespace-checkout-form-section squarespace-widgets-google-places-autocomplete".split(" ")
    })
  },
  2097: function(k, n, b) {
    var h = b(304);
    YUI.add("squarespace-checkout-form-custom-form", function(a) {
      a.namespace("Squarespace.Widgets");
      var b = a.Squarespace.Widgets.CheckoutCustomForm =
        a.Base.create("CheckoutCustomForm", a.Squarespace.Widgets.CheckoutFormSection, [], {
          renderUI: function() {
            b.superclass.renderUI.call(this);
            var d = this.get("contentBox");
            a.Data.get({
              url: "/api/template/GetTemplateSchema",
              data: {
                componentType: "widget",
                type: h.FORM
              },
              success: function(b) {
                this._formWidget = new a.Squarespace.Widgets.AsyncForm({
                  form: this.get("customForm"),
                  formTemplate: b,
                  formSubmitButtonText: "Submit",
                  hideSubmitButton: !0,
                  showTitle: !1
                });
                this._formWidget.render(d.one(".custom-form"))
              }
            }, this)
          },
          syncUI: function() {
            b.superclass.syncUI.call(this);
            this.get("boundingBox").toggleClass("no-form", 0 === this.get("customForm").fields.length)
          },
          _renderSavedFieldset: function(b) {
            var c = this.getProperty("HANDLEBARS_SAVED_FIELDSET_TEMPLATE"),
              g = this.get("formId");
            this._formWidget.fetchValidatedFormSubmission(g, a.bind(function(f) {
              var g = [];
              a.Object.each(f, function(b, c) {
                g.push(a.Squarespace.Commerce.summaryFormFieldString(b))
              });
              this.get("contentBox").append(a.Squarespace.UITemplates.render(c, {
                fields: g
              }));
              b.call(this)
            }, this))
          },
          _getLocalErrors: function() {
            return []
          },
          _fetchAsyncValidatedErrors: function() {
            return new a.Promise(a.bind(function(b) {
              this._formWidget.fetchValidatedFormSubmission(this.get("formId"), function() {
                b([])
              }, a.bind(function(c) {
                var g = a.Array.map(a.Object.keys(c.errors), function(a) {
                  return {
                    type: this.getProperty("FIELD_ERROR_TYPES").FORM_FIELD,
                    fieldId: a,
                    message: c.errors[a]
                  }
                }, this);
                g.push({
                  type: this.getProperty("FIELD_ERROR_TYPES").CUSTOM,
                  message: "Your form has encountered a problem. Please scroll up to review."
                });
                g.push({
                  type: this.getProperty("FIELD_ERROR_TYPES").HEADER,
                  message: "Your form has encountered a problem. Please scroll down to review."
                });
                b(g)
              }, this))
            }, this))
          },
          getCustomFormSubmission: function() {
            return a.Lang.isValue(this._formWidget) ? this._formWidget.getFormData() : null
          }
        }, {
          CSS_PREFIX: "sqs-checkout-form-custom-form",
          HANDLEBARS_TEMPLATE: "checkout-form-custom-form.html",
          HANDLEBARS_SAVED_FIELDSET_TEMPLATE: "checkout-saved-custom-form.html",
          ATTRS: {
            "strings.name": {
              value: "More"
            },
            customForm: {
              value: {
                fields: []
              },
              validator: a.Lang.isValue
            },
            formId: {
              value: null
            }
          }
        })
    }, "1.0", {
      requires: "base node squarespace-localities squarespace-util squarespace-checkout-form-section squarespace-checkout-saved-custom-form-template squarespace-checkout-form-custom-form-template squarespace-mixins-google-places-autocomplete".split(" ")
    })
  },
  2098: function(k, n) {
    YUI.add("squarespace-checkout-form-customer-info", function(b) {
      b.namespace("Squarespace.Widgets");
      b.Squarespace.Widgets.CheckoutFormCustomerInfo = b.Base.create("CheckoutFormCustomerInfo", b.Base, [], {
        _bindCustomerInfoEvents: function() {
          var b =
            this.get("contentBox").one('input[name="email"]');
          b && this._registerEvent(b.on("blur", this._handleEmailBlur, this))
        },
        _handleEmailBlur: function(h) {
          h = (h = h.target) && h.get("value").trim();
          if (b.Squarespace.EmailUtils.isValid(h)) {
            var a = this.get("model");
            null !== a && a.updateCustomerInfo(h)
          }
        }
      }, {})
    }, "1.0", {
      requires: ["base", "node"]
    })
  },
  2099: function(k, n, b) {
    var h = b(435);
    YUI.add("squarespace-checkout-form-payment", function(a) {
      a.namespace("Squarespace.Widgets");
      var b = a.Squarespace.Widgets.CheckoutFormPayment = a.Base.create("checkoutFormPayment",
        a.Squarespace.Widgets.CheckoutFormAddress, [], {
          initializer: function() {
            this.get("requiresShipping") || this.set("useAddressForShipping", !0)
          },
          renderUI: function() {
            b.superclass.renderUI.call(this);
            var d = this.get("contentBox");
            this._creditCardInputs = {
              cardNumber: d.one("#card-number input"),
              cardExpiryMonth: d.one("#card-expiry-month select"),
              cardExpiryYear: d.one("#card-expiry-year select"),
              cvc: d.one("#cvc input")
            };
            this._creditCardFields = {
              cardNumber: d.one("#card-number"),
              cardExpiryMonth: d.one("#card-expiry-month"),
              cardExpiryYear: d.one("#card-expiry-year"),
              cvc: d.one("#cvc")
            };
            this._hiddenInputs = {
              cardHolderName: d.one('input[name="cardHolderName"]'),
              stripeToken: d.one('input[name="stripeToken"]')
            };
            a.Array.each(this.get("optionalHiddenFields"), function(b) {
              var c = d.one('input[name="' + b + '"]');
              if (a.Lang.isValue(c)) this._hiddenInputs[b] = c;
              else throw Error("Optional hidden field input element could not be found.");
            }, this);
            this._toggleLockedFields();
            this._syncBillingFieldsWithCheckbox()
          },
          bindUI: function() {
            b.superclass.bindUI.call(this);
            this.after("inTestModeChange", this._toggleLockedFields, this);
            this.get("requiresShipping") && this.get("contentBox").one('input[name="billToShipping"]').after("change", this._syncBillingFieldsWithCheckbox, this);
            this.after("stateChange", this._syncBillingFieldsWithCheckbox, this);
            this.after("paymentRequiredChange", this.syncUI, this);
            this._bindLockedToolTip()
          },
          syncUI: function() {
            b.superclass.syncUI.call(this);
            this._toggleRequiredFields()
          },
          _syncBillingFieldsWithCheckbox: function() {
            var a = this.get("contentBox").one("#billing-address");
            if (this.get("isLinkedToShipping")) {
              var b = this.get("shippingSection").getValues();
              this._updateStateFieldForSelectedCountry(b.shippingCountry);
              this._syncRequiredFieldsForSelectedCountry();
              this.setValues({
                billingFirstName: b.shippingFirstName,
                billingLastName: b.shippingLastName,
                billingAddress1: b.shippingAddress1,
                billingAddress2: b.shippingAddress2,
                billingCity: b.shippingCity,
                billingState: b.shippingState,
                billingZip: b.shippingZip,
                billingCountry: b.shippingCountry
              });
              a.toggleClass("locked", !0);
              a.all("input, select").each(function(a) {
                a.setAttribute("readonly", !0);
                a.setAttribute("disabled", "disabled")
              })
            } else a.toggleClass("locked", !1), a.all("input, select").each(function(a) {
              a.removeAttribute("readonly");
              a.removeAttribute("disabled")
            }), this.setValues({
              billingFirstName: "",
              billingLastName: "",
              billingAddress1: "",
              billingAddress2: "",
              billingCity: "",
              billingState: "",
              billingZip: ""
            })
          },
          setCreditCardValues: function(b) {
            a.Object.each(b, a.bind(function(a, b) {
              this._setFieldValue(this._creditCardInputs[b], a)
            }, this))
          },
          getCreditCardValues: function() {
            return this._extractValuesFromFields(this._creditCardInputs)
          },
          setHiddenValues: function(b) {
            a.Object.each(b, a.bind(function(a, b) {
              this._setFieldValue(this._hiddenInputs[b], a)
            }, this))
          },
          getValues: function() {
            var a = b.superclass.getValues.call(this);
            this._extractValuesFromFields(this._hiddenInputs);
            if (this.get("isLinkedToShipping")) {
              var e = this.get("shippingSection").getValues();
              a.cardHolderName = e.shippingFirstName + " " + e.shippingLastName
            } else a.cardHolderName = a.billingFirstName + " " + a.billingLastName;
            return a
          },
          _extractValuesFromFields: function(b) {
            return a.Array.hash(a.Object.keys(b),
              a.Array.map(a.Object.values(b), function(a) {
                return a.get("value")
              }))
          },
          getLocationForShipping: function() {
            var a = this.getValues();
            return {
              country: a.billingCountry,
              state: a.billingState,
              zip: a.billingZip
            }
          },
          _getSelectedCountry: function() {
            return this.get("isLinkedToShipping") ? this.get("shippingSection").getValues().shippingCountry : this.getValues().billingCountry
          },
          _onContinue: function() {
            this.fire("continue")
          },
          _populateFieldsFromAc: function(a) {
            this.setValues({
              billingAddress1: a.address,
              billingCountry: a.country,
              billingCity: a.city,
              billingState: a.state,
              billingZip: a.zip
            })
          },
          _toggleRequiredFields: function() {
            var a = this.get("paymentRequired"),
              b = this._creditCardFields;
            b.cvc.toggleClass("required", a);
            b.cardNumber.toggleClass("required", a)
          },
          _toggleLockedFields: function() {
            var a = this.get("inTestMode"),
              b = this.get("storeState") === h.NOT_CONNECTED,
              c = this.get("contentBox"),
              f = this._creditCardInputs,
              l = this._creditCardInputs.cardNumber;
            c.one("#credit-card").toggleClass("locked", a || b);
            a || b ? (this.setCreditCardValues({
              cardNumber: "4242424242424242",
              cardExpiryMonth: "4",
              cardExpiryYear: (new Date).getFullYear() + 1,
              cvc: "323"
            }), l.setAttribute("readonly", !0), f.cardExpiryMonth.setAttribute("disabled", "disabled"), f.cardExpiryYear.setAttribute("disabled", "disabled"), f.cvc.setAttribute("readonly", !0)) : (this.setCreditCardValues({
              cardNumber: "",
              cardExpiryMonth: (new Date).getMonth(),
              cardExpiryYear: (new Date).getFullYear(),
              cvc: ""
            }), l.removeAttribute("readonly"), f.cardExpiryMonth.removeAttribute("disabled"), f.cardExpiryYear.removeAttribute("disabled"), f.cvc.removeAttribute("readonly"))
          },
          _bindLockedToolTip: function() {
            this._creditCardInputs.cardNumber.on("click", function() {
              var b = this.get("contentBox").one("#credit-card");
              this.get("inTestMode") && new a.Squarespace.Widgets.Information({
                "strings.title": "Store Not Live",
                "strings.message": 'This store has not yet gone live. You may try the checkout process and place a test order. We have prefilled a "Test" credit card number for you.',
                hideAfterTime: 7E3,
                position: a.Squarespace.Widgets.Confirmation.ANCHOR.ELEMENT,
                anchor: b
              });
              this.get("storeState") ===
                h.NOT_CONNECTED && new a.Squarespace.Widgets.Information({
                  "strings.title": "Payments Not Connected",
                  "strings.message": "A payment gateway is not connected. Checkout will be disabled. Please go to Store Settings to connect Stripe.",
                  hideAfterTime: 7E3,
                  position: a.Squarespace.Widgets.Confirmation.ANCHOR.ELEMENT,
                  anchor: b
                })
            }, this)
          },
          showQueueExplanation: function() {
            this.get("contentBox").one(".wait-in-queue-message").show()
          },
          lock: function() {
            this.get("contentBox").one("#place-order-button").setContent(this.get("strings.pendingText")).set("disabled", !0)
          },
          unlock: function() {
            this.get("contentBox").one("#place-order-button").setContent(this.get("strings.submitText")).set("disabled", !1)
          }
        }, {
          CSS_PREFIX: "sqs-checkout-form-payment",
          HANDLEBARS_TEMPLATE: "checkout-form-payment.html",
          ATTRS: {
            strings: {
              value: {
                submitText: "Place Order",
                pendingText: "Placing Order ..."
              }
            },
            optionalHiddenFields: {
              value: []
            },
            isLinkedToShipping: {
              getter: function() {
                return this.get("requiresShipping") && this.get("billToShippingAddress")
              }
            },
            billToShippingAddress: {
              getter: function() {
                var b = this.get("contentBox").one('input[name="billToShipping"]');
                return !a.Lang.isValue(b) ? !1 : b.get("checked")
              }
            },
            inTestMode: {
              validator: a.Squarespace.AttrValidators.isBoolean
            },
            storeState: {
              value: null
            },
            shippingSection: {
              value: null
            },
            requiresShipping: {
              value: !1
            },
            paymentRequired: {
              value: !0
            }
          }
        })
    }, "1.0", {
      requires: "base node squarespace-attr-validators squarespace-basic-check squarespace-hb-date-options squarespace-checkout-form-section squarespace-checkout-form-payment-template squarespace-widgets-information".split(" ")
    })
  },
  2100: function(k, n) {
    YUI.add("squarespace-checkout-form-section",
      function(b) {
        b.namespace("Squarespace.Widgets");
        var h = b.Squarespace.Widgets.CheckoutFormSection = b.Base.create("checkoutFormSection", b.Squarespace.Widgets.SSWidget, [], {
          initializer: function() {
            this.publish("continue-clicked", {
              preventable: !0,
              defaultFn: this._onContinue
            })
          },
          renderUI: function() {
            h.superclass.renderUI.call(this);
            Modernizr && !Modernizr.input.placeholder && this.get("boundingBox").addClass("show-labels");
            this.get("contentBox").all(".field-element").plug(b.Squarespace.Plugin.PulseWarn, {
              iterations: 1,
              useClass: !0,
              targetClass: "warn",
              interval: 1300
            });
            switch (this.get("state")) {
              case "editing":
                this.setStateEditing();
                break;
              case "complete":
                this.setStateComplete();
                break;
              case "incomplete":
                this.setStateIncomplete()
            }
          },
          bindUI: function() {
            h.superclass.bindUI.call(this);
            if (b.Lang.isValue(this.get("model"))) this.get("model").on("change", this.syncUI, this);
            var a = this.get("contentBox");
            a.one(".continue-button").on("click", function() {
              this.fire("continue-clicked")
            }, this);
            a.one(".edit-button").on("click", this._onEdit,
              this)
          },
          setStateEditing: function() {
            var a = this.get("boundingBox");
            this._removeSaved();
            a.removeClass("complete");
            a.removeClass("incomplete");
            a.addClass("editing");
            this.set("state", "editing");
            return this
          },
          scrollIntoView: function() {
            this.get("boundingBox").scrollIntoView(!0)
          },
          setStateComplete: function() {
            var a = this.get("contentBox").one(".saved-fieldset");
            a && a.remove(!0);
            this._renderSavedFieldset(function() {
              var a = this.get("boundingBox");
              a.removeClass("editing");
              a.removeClass("incomplete");
              a.addClass("complete");
              this.set("state", "complete")
            });
            return this
          },
          _renderSavedFieldset: function(a) {
            var c = this.getProperty("HANDLEBARS_SAVED_FIELDSET_TEMPLATE");
            c && this.get("contentBox").append(b.Squarespace.UITemplates.render(c, this.getValues()));
            b.Lang.isValue(a) && a.call(this)
          },
          setStateIncomplete: function() {
            var a = this.get("boundingBox");
            this._removeSaved();
            this._clearErrors();
            a.removeClass("editing");
            a.removeClass("complete");
            a.addClass("incomplete");
            this.set("state", "incomplete");
            return this
          },
          getValues: function() {
            var a = {};
            this.get("contentBox").all(".field").each(function(b) {
              b = b.one(".field-element");
              var d = b.get("type"),
                e = b.get("name"),
                g = null,
                g = "checkbox" === d ? b.get("checked") : b.get("value").trim();
              "" === g && (g = null);
              a[e] = g
            }, this);
            return a
          },
          setValues: function(a) {
            this.get("contentBox").all(".field-element").each(function(c) {
              var d = c.get("name");
              b.Object.hasKey(a, d) && this._setFieldValue(c, a[d])
            }, this)
          },
          _setFieldValue: function(a, c) {
            if ("select-one" === a.get("type")) {
              var d = a.one('option[value="' + c + '"]');
              b.Lang.isValue(d) &&
                d.set("selected", !0)
            } else a.set("value", c)
          },
          renderErrors: function(a) {
            this._clearErrors();
            var c = [],
              d = [],
              e = [],
              g = [],
              f = [],
              h = [];
            b.Array.each(a, function(a) {
              var b = this.getProperty("FIELD_ERROR_TYPES"),
                k = a.type,
                m = a.field;
              m && this._renderFieldError(m);
              k === b.REQUIRED ? c.push(m.getData("label")) : k === b.VALIDATION ? d.push(m.getData("label")) : k === b.STRIPE ? e.push(a.message) : k === b.CUSTOM ? g.push(a.message) : k === b.FORM_FIELD ? f.push(a) : k === b.HEADER && h.push(a)
            }, this);
            var k = a = "",
              m = "",
              n = "";
            0 < c.length && (a = b.Array.dedupe(c).join(", ") +
              " required. ");
            0 < d.length && (k = b.Array.dedupe(d).join(", ") + " invalid.");
            0 < e.length && (m = b.Array.dedupe(e).join(". "));
            0 < g.length && (n = b.Array.dedupe(g).join(". "));
            a = b.Node.create('<div class="error-summary">' + a + k + m + n + "</div>");
            this.get("contentBox").one(".button").insert(a, "before");
            b.Array.each(f, function(a) {
              b.one("#" + a.fieldId).addClass("error").insert('<div class="form-field-error">' + a.message + "</div>", 0)
            });
            b.Array.each(h, function(a) {
              this.get("contentBox").one(".custom-form").insert('<div class="header-error">' +
                a.message + "</div>", 0)
            }, this)
          },
          _onContinue: function() {
            this.validate().then(b.bind(function(a) {
              0 < a.length ? this.renderErrors(a) : (this._clearErrors(), this.fire("continue"))
            }, this))
          },
          _onEdit: function() {
            this.fire("edit")
          },
          _fetchAsyncValidatedErrors: function() {
            return new b.Promise(function(a) {
              a([])
            })
          },
          _getLocalErrors: function() {
            var a = [];
            this.get("contentBox").all(".field").each(function(b) {
              b.hasClass("required") && (b = this._validateField(b)) && a.push(b)
            }, this);
            return a
          },
          validate: function() {
            var a = this._getLocalErrors();
            return new b.Promise(b.bind(function(c) {
              this._fetchAsyncValidatedErrors().then(b.bind(function(b) {
                b = a.concat(b);
                c(b)
              }, this))
            }, this))
          },
          _validateField: function(a) {
            var b = a.one(".field-element");
            b.get("name");
            if ("" === b.get("value").trim()) return {
              type: this.getProperty("FIELD_ERROR_TYPES").REQUIRED,
              field: a
            }
          },
          _clearErrors: function() {
            var a = this.get("contentBox");
            a.all(".error-summary, .form-field-error, .header-error").remove(!0);
            a.all(".field, .form-item").removeClass("error")
          },
          _renderFieldError: function(a) {
            var b =
              a.one(".field-element");
            b.pulseWarn.warn();
            a.addClass("error");
            b.once(["click", "change", "focus"], function() {
              a.removeClass("error")
            }, this)
          },
          _removeSaved: function() {
            var a = this.get("contentBox").one(".saved-fieldset");
            a && a.remove(!0)
          }
        }, {
          CSS_PREFIX: "sqs-checkout-form-section card",
          FIELD_ERROR_TYPES: {
            REQUIRED: 1,
            VALIDATION: 2,
            STRIPE: 3,
            CUSTOM: 4,
            FORM_FIELD: 5,
            HEADER: 6
          },
          ATTRS: {
            model: {
              value: null
            },
            state: {
              value: "incomplete"
            }
          }
        })
      }, "1.0", {
        requires: "node base thirdparty-modernizr squarespace-ss-widget squarespace-ui-templates squarespace-plugin-pulsewarn".split(" ")
      })
  },
  2101: function(k, n) {
    YUI.add("squarespace-checkout-form-shipping-info", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Widgets.CheckoutFormShippingInfo = b.Base.create("checkoutFormShipping", b.Squarespace.Widgets.CheckoutFormAddress, [b.Squarespace.Widgets.CheckoutFormCustomerInfo], {
        bindUI: function() {
          h.superclass.bindUI.call(this);
          this._bindCustomerInfoEvents()
        },
        _onContinue: function() {
          if (this.get("model").isRecalculating()) this.get("model").once("recalculate-end", function() {
              h.superclass._onContinue.call(this)
            },
            this);
          h.superclass._onContinue.call(this)
        },
        getValues: function() {
          var a = h.superclass.getValues.call(this);
          a.requiresShipping = this.get("model").get("requiresShipping");
          return a
        },
        setValues: function(a) {
          h.superclass.setValues.call(this, a);
          b.Object.hasKey(a, "selectedShippingOption") && this._shippingOptionsWidget.setSelectedOption(a.selectedShippingOption)
        },
        getLocationForShipping: function() {
          var a = this.getValues();
          return {
            country: a.shippingCountry,
            state: a.shippingState,
            zip: a.shippingZip
          }
        },
        _populateFieldsFromAc: function(a) {
          this.setValues({
            shippingAddress1: a.address,
            shippingCountry: a.country,
            shippingCity: a.city,
            shippingState: a.state,
            shippingZip: a.zip
          })
        }
      }, {
        CSS_PREFIX: "sqs-checkout-form-shipping-info",
        HANDLEBARS_TEMPLATE: "checkout-form-shipping-info.html",
        HANDLEBARS_SAVED_FIELDSET_TEMPLATE: "checkout-saved-shipping-info.html",
        ATTRS: {
          useAddressForShipping: {
            value: !0
          },
          optionalFields: {
            value: {
              showMailingList: !0
            }
          },
          enableMailingListOptInByDefault: {
            validator: b.Squarespace.AttrValidators.isBoolean
          }
        }
      })
    }, "1.0", {
      requires: "base node squarespace-checkout-form-address squarespace-models-shopping-cart squarespace-hb-money-string squarespace-shipping-options-list squarespace-checkout-form-customer-info squarespace-checkout-form-shipping-info-template squarespace-checkout-saved-shipping-info-template".split(" ")
    })
  },
  2106: function(k, n) {
    YUI.add("squarespace-commerce", function(b) {
      b.namespace("Squarespace.Commerce");
      var h = b.config.win.Static;
      b.Squarespace.Commerce.initializeCommerce = function() {
        b.Squarespace.ProductUtils.initializeVariantDropdowns();
        b.Squarespace.CartUtils.initializeAddToCartButtons();
        if (!b.Squarespace.Commerce.isExpressCheckout() && !b.Lang.isValue(b.one(".show-cart-page")) && !b.Lang.isValue(b.one(".sqs-custom-cart"))) {
          var a = b.one(".sqs-cart-dropzone");
          b.Lang.isNull(a) && (b.Lang.isValue(b.one(".absolute-cart-box")) ?
            a = b.one(".absolute-cart-box") : (a = b.Node.create('<div class="absolute-cart-box"></div>'), b.one(b.config.doc.body).append(a)));
          var c = a.one(".sqs-pill-shopping-cart");
          b.Widget.getByNode(c) || new b.Squarespace.Widgets.PillShoppingCart({
            model: b.Squarespace.Singletons.ShoppingCart,
            useLightCart: h.SQUARESPACE_CONTEXT.websiteSettings.storeSettings.useLightCart,
            render: a
          })
        }
        b.Lang.isValue(b.one(".sqs-custom-cart")) && b.all(".sqs-custom-cart").each(function(a) {
          (new b.Squarespace.Widgets.TemplateIntegratedShoppingCart({
            model: b.Squarespace.Singletons.ShoppingCart,
            boundingBox: a,
            srcNode: a
          })).render()
        });
        b.Lang.isNull(b.Cookie.get("CART")) ? b.all(".sqs-add-to-cart-button-wrapper").setStyle("visibility", "visible") : b.Squarespace.Singletons.ShoppingCart.load(function() {
          b.all(".sqs-add-to-cart-button-wrapper").setStyle("visibility", "visible")
        }, this);
        b.Lang.isValue(b.one("#sqs-shopping-cart-wrapper")) && new b.Squarespace.Widgets.FullPageShoppingCart({
          model: b.Squarespace.Singletons.ShoppingCart,
          linkItems: !0,
          render: b.one("#sqs-shopping-cart-wrapper")
        })
      };
      b.config.win.Squarespace.onInitialize(b,
        b.Squarespace.Commerce.initializeCommerce)
    }, "1.0", {
      requires: "event-base-ie overlay squarespace-pill-shopping-cart squarespace-template-integrated-shopping-cart squarespace-full-page-shopping-cart squarespace-product-utils squarespace-cart-utils squarespace-donate-form".split(" ")
    })
  },
  2154: function(k, n) {
    YUI.add("squarespace-contribution-summary", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Widgets.ContributionSummary = b.Base.create("ContributionSummary", b.Squarespace.Widgets.CheckoutFormSection, [], {
        _getHBTemplateContext: function() {
          var a = h.superclass._getHBTemplateContext.call(this);
          b.Array.each(a.donatePage.suggestedContributions, function(a) {
            a.amountDollars = b.Squarespace.Commerce.moneyFormat(a.amountCents)
          });
          return a
        },
        bindUI: function() {
          h.superclass.bindUI.call(this);
          var a = this.get("contentBox");
          a.delegate("click", function(b) {
            "other" == b.target.get("value") && a.one('input[name="contributionAmount"]').select()
          }, 'input[type="radio"]')
        },
        renderUI: function() {
          h.superclass.renderUI.call(this);
          var a =
            this.get("contentBox");
          a.one('input[name="contributionAmount"]').plug(b.Squarespace.Plugin.MoneyFormatter);
          var c = this.get("donatePage").suggestedContributions;
          b.Lang.isValue(c) && 0 < c.length ? a.one(".prompt").setContent("Select an amount:") : a.one(".prompt").setContent("Enter an amount:")
        },
        _getLocalErrors: function() {
          var a = h.superclass._getLocalErrors.call(this);
          return 50 > this.getDonationAmountCents() ? [{
            type: this.getProperty("FIELD_ERROR_TYPES").CUSTOM,
            message: "You must donate at least 0.50"
          }] : a
        },
        getDonationAmountCents: function() {
          var a =
            this.get("contentBox"),
            c = this.get("donatePage").suggestedContributions;
          return b.Lang.isValue(c) && 0 < c.length ? (c = this._getCheckedRadio(), !b.Lang.isValue(c) ? 0 : "other" == c.get("value") ? a.one('input[name="contributionAmount"]').moneyFormatterPlugin.get("data") : c.get("value")) : a.one('input[name="contributionAmount"]').moneyFormatterPlugin.get("data")
        },
        _getCheckedRadio: function() {
          var a;
          this.get("contentBox").one(".contribution-option-list").all('input[type="radio"]').each(function(b) {
            b.get("checked") && (a =
              b)
          });
          return a
        },
        getValues: function() {
          return {
            donationAmount: b.Squarespace.Commerce.moneyString(this.getDonationAmountCents()),
            title: this.get("donatePage").title
          }
        }
      }, {
        CSS_PREFIX: "sqs-contribution-summary",
        HANDLEBARS_TEMPLATE: "contribution-summary.html",
        HANDLEBARS_SAVED_FIELDSET_TEMPLATE: "checkout-saved-contribution.html",
        ATTRS: {
          strings: {
            value: {
              prompt: null
            }
          },
          donatePage: {
            value: null
          }
        }
      })
    }, "1.0", {
      requires: "base node squarespace-commerce-utils squarespace-ui-templates squarespace-hb-money-string squarespace-checkout-form-section squarespace-contribution-summary-template squarespace-plugin-money-formatter squarespace-async-form squarespace-checkout-saved-contribution-template".split(" ")
    })
  },
  2215: function(k, n, b) {
    var h = b(435);
    YUI.add("squarespace-donate-form", function(a) {
      a.namespace("Squarespace.Widgets");
      var b = a.Squarespace.Widgets.DonateForm = a.Base.create("DonateForm", a.Squarespace.Widgets.SSWidget, [], {
        initializer: function() {
          var b = this.get("donatePage");
          this._contributionSection = new a.Squarespace.Widgets.ContributionSummary({
            donatePage: b,
            state: "editing"
          });
          this._contactSection = new a.Squarespace.Widgets.CheckoutFormContactInfo({
            enableMailingListOptInByDefault: this.get("enableMailingListOptInByDefault"),
            optionalFields: this.get("optionalFields"),
            state: "incomplete"
          });
          this._customFormSection = new a.Squarespace.Widgets.CheckoutCustomForm({
            state: "incomplete",
            customForm: b.customForm,
            formId: b.customFormId
          });
          this._paymentSection = new a.Squarespace.Widgets.CheckoutFormPayment({
            strings: {
              submitText: b.buttonLabel,
              pendingText: "Submitting ..."
            },
            state: "incomplete",
            optionalHiddenFields: ["donationAmountCents", "donatePageId", "email", "phone", "joinMailingList"],
            inTestMode: this.get("inTestMode"),
            countriesAllowed: a.Squarespace.Localities.getAllCountryNames()
          });
          this.formSubmitted = !1
        },
        destructor: function() {
          this._contributionSection.destroy(!0);
          this._contributionSection = null;
          this._contactSection.destroy(!0);
          this._contactSection = null;
          this._customFormSection.destroy(!0);
          this._customFormSection = null;
          this._paymentSection.destroy(!0);
          this._paymentSection = null
        },
        renderUI: function() {
          b.superclass.renderUI.call(this);
          var d;
          d = a.Data.addCrumb("/commerce/submit-donation");
          d = a.Node.create('<form action="' + d + '" method="POST"></form>');
          d.append(a.Node.create('<input type="hidden" name="customFormSubmission" />'));
          this._contributionSection.render(a.one("#summary-wrapper"));
          this._contactSection.render(a.one("#summary-wrapper"));
          this._customFormSection.render(a.one("#summary-wrapper"));
          this._paymentSection.render(d);
          this._customFormSection.setStateIncomplete();
          this._paymentSection.setStateIncomplete();
          this.get("contentBox").append(d)
        },
        bindUI: function() {
          b.superclass.bindUI.call(this);
          var a = this._contributionSection,
            e = this._contactSection,
            g = this._customFormSection,
            f = this._paymentSection;
          a.on("continue", function() {
            a.setStateComplete();
            e.setStateEditing()
          });
          a.on("edit", function() {
            a.setStateEditing();
            e.setStateIncomplete();
            g.setStateIncomplete();
            f.setStateIncomplete()
          });
          e.on("edit", function() {
            e.setStateEditing();
            g.setStateIncomplete();
            f.setStateIncomplete()
          });
          e.on("continue", function() {
            e.setStateComplete();
            this._hasCustomForm() ? g.setStateEditing() : f.setStateEditing()
          }, this);
          g.on("continue", function() {
            g.setStateComplete();
            f.setStateEditing()
          });
          g.on("edit", function() {
            g.setStateEditing();
            f.setStateIncomplete()
          });
          f.on("continue", this._submit,
            this)
        },
        lock: function() {
          var a = this.get("contentBox");
          this.fire("lock");
          a.addClass("submitting");
          this._paymentSection.lock()
        },
        unlock: function() {
          var a = this.get("contentBox");
          this.fire("unlock");
          a.removeClass("submitting");
          this._paymentSection.unlock()
        },
        _hasCustomForm: function() {
          var b = this.get("donatePage").customForm;
          return !a.Lang.isValue(b) ? !1 : 0 < b.fields.length
        },
        _submit: function() {
          var b = this.get("donatePage"),
            c = a.bind(function(b) {
              b = this._paymentSection.getCreditCardValues();
              var c = this._paymentSection.getValues();
              Stripe.createToken({
                number: b.cardNumber,
                cvc: b.cvc,
                exp_month: b.cardExpiryMonth,
                exp_year: b.cardExpiryYear,
                name: c.cardHolderName,
                address_line1: c.billingAddress1,
                address_line2: c.billingAddress2,
                address_state: c.billingState,
                address_city: c.billingCity,
                address_country: c.billingCountry,
                address_zip: c.billingZip
              }, a.bind(this._stripeResponseHandler, this))
            }, this);
          this._validateSubmit().then(a.bind(function(g) {
            if (g)
              if (this.lock(), !0 === b.queuedSubmitEnabled) {
                var f = new a.Squarespace.TokenQueue;
                f.on("estimatedWaitChanged",
                  function() {
                    this._showCountdown(f.estimatedTime)
                  }, this);
                f.waitInQueue().then(a.bind(c, this))
              } else c()
          }, this))
        },
        _validateSubmit: function() {
          return new a.Promise(a.bind(function(b) {
            this._contributionSection.validate() || b(!1);
            this._paymentSection.validate().then(a.bind(function(c) {
              0 < c.length && (this._paymentSection.renderErrors(c), b(!1));
              50 > this._contributionSection.getDonationAmountCents() && (new a.Squarespace.Widgets.Alert({
                "strings.title": "Cannot Complete Donation",
                "strings.message": "Your contribution must be at least " +
                  a.Squarespace.Commerce.currencySymbol() + "0.50 to continue."
              }), b(!1));
              Static.SQUARESPACE_CONTEXT.websiteSettings.storeSettings.storeState === h.NOT_CONNECTED && (new a.Squarespace.Widgets.Alert({
                "strings.title": "Payments Not Connected",
                "strings.message": "This site has not connected a payment gateway. Transactions are disabled and you cannot complete this donation."
              }), b(!1));
              b(!0)
            }, this))
          }, this))
        },
        _stripeResponseHandler: function(a, b) {
          var c = b.error,
            f = this.get("contentBox").one("form"),
            h = this._contributionSection;
          if (c) this.unlock(), f = this._paymentSection, f.renderErrors([{
            type: f.getProperty("FIELD_ERROR_TYPES").STRIPE,
            message: c.message
          }]);
          else {
            var c = this._contactSection.getValues(),
              k = this._paymentSection.getValues();
            this._paymentSection.setHiddenValues({
              stripeToken: b.id,
              cardHolderName: k.cardHolderName,
              donationAmountCents: h.getDonationAmountCents(),
              email: c.email,
              joinMailingList: c.joinMailingList,
              phone: c.phone,
              donatePageId: this.get("donatePage").id
            });
            h = this._customFormSection.getCustomFormSubmission();
            f.one('input[name="customFormSubmission"]').set("value",
              JSON.stringify(h));
            this._submitForm()
          }
        },
        _submitForm: function() {
          var a = this.get("contentBox").one("form");
          !1 === this.formSubmitted && (this.formSubmitted = !0, a.submit())
        }
      }, {
        CSS_PREFIX: "sqs-checkout-form",
        ATTRS: {
          countriesAllowed: {
            value: []
          },
          optionalFields: {
            value: null
          },
          donatePage: {
            value: null
          },
          inTestMode: {
            value: !1
          },
          enableMailingListOptInByDefault: {
            validator: a.Squarespace.AttrValidators.isBoolean,
            value: !0
          }
        }
      })
    }, "1.0", {
      requires: "base node squarespace-attr-validators squarespace-ss-widget squarespace-util squarespace-commerce-utils squarespace-ui-base squarespace-checkout-form-custom-form squarespace-checkout-form-shipping-info squarespace-checkout-form-payment squarespace-contribution-summary squarespace-widgets-alert".split(" ")
    })
  },
  2263: function(k, n) {
    YUI.add("squarespace-full-page-shopping-cart", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Widgets.FullPageShoppingCart = b.Base.create("fullPageShoppingCart", b.Squarespace.Widgets.TableShoppingCart, [], {
        renderUI: function() {
          h.superclass.renderUI.call(this);
          this._spinner = new b.Squarespace.Spinner({
            render: this.get("contentBox").one(".loading-spinner"),
            size: 50,
            color: "dark"
          })
        },
        bindUI: function() {
          h.superclass.bindUI.call(this);
          var a = this.get("model");
          this.get("contentBox").one(".checkout-button").on("click",
            b.Squarespace.Commerce.goToCheckoutPage, this);
          a.on("recalculate-start", this._setLoadingState, this);
          a.on("recalculate-end", this._setLoadedState, this)
        },
        _setLoadingState: function() {
          var a = this.get("contentBox");
          a.all("input").setAttribute("disabled", !0);
          a.addClass("loading-cart")
        },
        _setLoadedState: function() {
          var a = this.get("contentBox");
          b.later(350, this, function() {
            a.all("input").removeAttribute("disabled");
            a.removeClass("loading-cart")
          })
        }
      }, {
        CSS_PREFIX: "sqs-fullpage-shopping-cart",
        HANDLEBARS_TEMPLATE: "full-page-shopping-cart.html",
        HANDLEBARS_ITEM_TEMPLATE: "full-page-shopping-cart-item.html"
      })
    }, "1.0", {
      requires: "base node cookie squarespace-commerce-utils squarespace-table-shopping-cart squarespace-full-page-shopping-cart-template squarespace-full-page-shopping-cart-item-template squarespace-spinner".split(" ")
    })
  },
  2266: function(k, n) {
    YUI.add("squarespace-hb-date-options", function(b) {
      b.Handlebars.registerHelper("month-options", function(h) {
        var a = "";
        b.Array.each("January February March April May June July August September October November December".split(" "),
          function(c, d) {
            var e = d + 1,
              g = e.toString();
            1 === g.length && (g = "0" + g);
            b.Lang.isUndefined(h.hash["short"]) && (g += " " + c);
            a += '<option value="' + e + '">' + g + "</option>"
          });
        return new b.Handlebars.SafeString(a)
      });
      b.Handlebars.registerHelper("year-options", function(h) {
        h = (new Date).getFullYear();
        for (var a = "", c = h; c < h + 10; c++) a += '<option value="' + c + '">' + c + "</option>";
        return new b.Handlebars.SafeString(a)
      }, this)
    }, "1.0", {
      requires: ["handlebars-base"]
    })
  },
  2267: function(k, n) {
    YUI.add("squarespace-hb-money-string", function(b) {
      b.Handlebars.registerHelper("money-string",
        function(h, a) {
          return new b.Handlebars.SafeString(b.Squarespace.Commerce.moneyString(h))
        })
    }, "1.0", {
      requires: ["handlebars-base", "squarespace-commerce-utils"]
    })
  },
  2347: function(k, n) {
    YUI.add("squarespace-pill-shopping-cart", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Widgets.PillShoppingCart = b.Base.create("pillShoppingCart", b.Squarespace.Widgets.SSWidget, [], {
        renderUI: function() {
          h.superclass.renderUI.call(this);
          this.get("boundingBox").plug(b.Squarespace.Animations.Scalable, {
            duration: 0.25
          });
          this._hide(!0);
          this.get("contentBox").addClass(this.get("useLightCart") ? "light" : "dark")
        },
        bindUI: function() {
          h.superclass.bindUI.call(this);
          this.get("model").on("change", this.syncUI, this);
          this.get("contentBox").on("click", function() {
            b.config.win.location = "/commerce/show-cart"
          })
        },
        syncUI: function() {
          h.superclass.syncUI.call(this);
          var a = this.get("model"),
            c = a.get("totalQuantity"),
            d = this.get("contentBox"),
            e = function() {
              d.one(".total-quantity").setContent(100 < c ? "100+" : c);
              d.one(".suffix").setContent(1 === c ? "item" :
                "items");
              d.one(".subtotal .price").setContent(b.Squarespace.Commerce.moneyString(a.get("subtotalCents"), !0))
            };
          0 < c ? (e(), this._show()) : (this._hide(), e())
        },
        _show: function() {
          var a = this.get("boundingBox");
          if (a.hasClass("sqs-scalable-hidden")) a.show();
          else {
            var c = b.Easing.easeOutStrong,
              d = new b.Anim({
                node: a,
                to: {
                  opacity: 0.7
                },
                duration: 0.2,
                easing: c
              }),
              e = new b.Anim({
                node: a,
                to: {
                  opacity: 1
                },
                duration: 0.5,
                easing: c
              });
            d.on("end", function() {
              e.run()
            });
            d.run()
          }
        },
        _hide: function(a) {
          var b = this.get("boundingBox");
          b.hasClass("sqs-scalable-hidden") ||
            b.hide(a)
        }
      }, {
        CSS_PREFIX: "sqs-pill-shopping-cart",
        HANDLEBARS_TEMPLATE: "pill-shopping-cart.html",
        ATTRS: {
          model: {
            value: null,
            validator: function(a) {
              return b.instanceOf(a, b.Squarespace.Models.ShoppingCart)
            }
          },
          useLightCart: {
            value: !1
          }
        }
      })
    }, "1.0", {
      requires: "base node cookie squarespace-ss-widget squarespace-commerce-utils squarespace-animations squarespace-models-shopping-cart squarespace-pill-shopping-cart-template".split(" ")
    })
  },
  2349: function(k, n) {
    YUI.add("squarespace-plugin-integer-restrictor", function(b) {
      b.namespace("Squarespace.Plugin");
      b.Squarespace.Plugin.IntegerRestrictor = b.Base.create("integerRestrictor", b.Plugin.Base, [], {
        initializer: function() {
          this.get("host").on("keydown", function(b) {
            var a = b.keyCode; - 1 !== [9, 13, 8, 46, 37, 39].indexOf(a) || (48 <= a && 57 >= a || 96 <= a && 105 >= a) || b.halt(!0)
          }, this)
        }
      }, {
        NS: "integerRestrictorPlugin"
      })
    }, "1.0", {
      requires: ["base", "plugin", "squarespace-ui-base"]
    })
  },
  2358: function(k, n, b) {
    b(999);
    YUI.add("squarespace-shipping-options-list", function(b) {
      b.namespace("Squarespace.Widgets");
      var a = b.Squarespace.Widgets.ShippingOptionsList =
        b.Base.create("shippingOptionsList", b.Squarespace.Widgets.SSWidget, [], {
          renderUI: function() {
            a.superclass.renderUI.call(this);
            this._spinner = new b.Squarespace.Spinner({
              render: this.get("contentBox").one(".loading-spinner"),
              size: 1 < this.get("model").get("shippingOptions").length ? 35 : 15,
              color: "dark"
            })
          },
          bindUI: function() {
            a.superclass.bindUI.call(this);
            var b = this.get("model"),
              d = this.get("contentBox");
            b.on("change", this.syncUI, this);
            b.on("recalculate-start", this._setLoadingState, this);
            b.on("recalculate-end",
              this._setLoadedState, this);
            this.on("shippingCountryChange", this.syncUI, this);
            d.delegate("click", function(a) {
              b.updateShippingMethod(a.target.get("value"))
            }, "input", this)
          },
          syncUI: function() {
            a.superclass.syncUI.call(this);
            var c = this.get("contentBox"),
              d = this.get("model"),
              e = d.get("shippingOptions"),
              g = (d = d.get("selectedShippingOption")) ? d.key : null,
              f = c.one(".options-container");
            c.all(".shipping-option").remove(!0);
            c.toggleClass("empty", 0 === e.length);
            b.Array.each(e, function(a, c) {
              var d = a.key,
                e = b.Squarespace.UITemplates.renderAsNodeOrDocFrag(this.getProperty("HANDLEBARS_SHIPPING_OPT_TEMPLATE"), {
                  name: a.name,
                  id: d,
                  computedCost: a.computedCost
                });
              (g && d === g || !g && 0 === c) && e.one("input").set("checked", !0);
              f.append(e)
            }, this)
          },
          getSelectedOption: function() {
            var a = this.get("contentBox").one("input:checked");
            if (b.Lang.isValue(a) && a.get("disabled")) return null;
            if (a) return {
              value: a.get("value"),
              title: a.get("title"),
              cost: Number(a.getData("computed-cost"))
            }
          },
          setSelectedOption: function(a) {
            this.get("contentBox").all("input").each(function(b) {
              b.set("checked", b.get("value") === a)
            }, this)
          },
          _setLoadingState: function() {
            var a =
              this.get("contentBox"),
              b = 1 < this.get("model").get("shippingOptions").length;
            this._spinner.set("size", b ? 35 : 15);
            a.all("input").setAttribute("disabled", !0);
            a.toggleClass("multiple-options", b);
            a.addClass("loading-options")
          },
          _setLoadedState: function() {
            b.later(350, this, function() {
              var a = this.get("contentBox");
              a.removeClass("loading-options");
              a.all(".shipping-option").each(function(a) {
                a.hasClass("disabled") || a.one("input").removeAttribute("disabled")
              }, this)
            })
          }
        }, {
          CSS_PREFIX: "sqs-shipping-options-list",
          HANDLEBARS_TEMPLATE: "shipping-options-list.html",
          HANDLEBARS_SHIPPING_OPT_TEMPLATE: "shipping-options-list-option.html",
          ATTRS: {
            model: {
              value: null,
              validator: function(a) {
                return b.instanceOf(a, b.Squarespace.Models.ShoppingCart)
              }
            }
          }
        })
    }, "1.0", {
      requires: "base node squarespace-ss-widget squarespace-models-shopping-cart squarespace-shipping-options-list-template squarespace-shipping-options-list-option-template squarespace-hb-money-string squarespace-spinner".split(" ")
    })
  },
  2371: function(k, n, b) {
    var h = b(89),
      a = b(304);
    YUI.add("squarespace-table-shopping-cart",
      function(b) {
        b.namespace("Squarespace.Widgets");
        var d = b.Squarespace.Widgets.TableShoppingCart = b.Base.create("tableShoppingCart", b.Squarespace.Widgets.SSWidget, [], {
          initializer: function() {
            this._getAdditionalFieldsFormTemplateSchema(function(a) {
              this._additionalFieldsFormTemplate = a
            }, this);
            this._additionalFieldsModalLightbox = new b.Squarespace.Widgets.ModalLightbox;
            this._formWidget = null
          },
          destructor: function() {
            this._additionalFieldsModalLightbox.destroy();
            this._formWidget && this._formWidget.destroy()
          },
          renderUI: function() {
            d.superclass.renderUI.call(this);
            this._additionalFieldsModalLightbox.render(b.one("body"))
          },
          bindUI: function() {
            d.superclass.bindUI.call(this);
            this.get("model").on("change", this.syncUI, this);
            var a = this.get("contentBox");
            a.delegate("click", function(b) {
              a.hasClass("loading-cart") || this._removeEntryRow(b.target.ancestor("tr"))
            }, ".remove-item", this);
            a.delegate("click", function(a) {
              a.target.select()
            }, ".quantity input", this);
            var g = 0,
              f;
            a.delegate("valuechange", function(a) {
              var d = a.target.get("parentNode");
              g += 1300;
              f && f.stop();
              d.one("input").setStyle("opacity",
                0.3);
              setTimeout(b.bind(function() {
                f = new b.Anim({
                  node: d.one("input"),
                  to: {
                    opacity: 1
                  },
                  easing: b.Easing.easeOutSine,
                  duration: 0.5
                });
                f.run();
                setTimeout(b.bind(function() {
                  g -= 1300;
                  0 === g && this._onQuantityChange(a)
                }, this), 1E3)
              }, this), 300)
            }, ".quantity input", this);
            a.delegate("click", this._onAdditionalFieldsEdit, ".additional-fields", this);
            this._additionalFieldsModalLightbox.on("close", function() {
              this._formWidget && this._formWidget.destroy()
            }, this)
          },
          syncUI: function() {
            d.superclass.syncUI.call(this);
            var a = this.get("model"),
              g = this.get("contentBox");
            g.one(".subtotal .price").setContent(b.Squarespace.Commerce.moneyString(a.get("subtotalCents")));
            g.one("tbody").empty();
            0 === a.get("totalQuantity") ? g.addClass("empty") : (g.removeClass("empty"), b.Array.each(a.get("entries"), function(a) {
              0 < a.quantity && this._appendEntryRow(a)
            }, this), this._focusedInputItemId && (a = this._getEntryRowByItemId(this._focusedInputItemId)) && a.one(".quantity input").focus());
            g.all(".cooldown").addClass("hidden")
          },
          showError: function(a, d) {
            new b.Squarespace.Widgets.Alert({
              "strings.title": a,
              "strings.message": d
            })
          },
          _appendEntryRow: function(a) {
            var d = a.item,
              f = d.items,
              l = d.structuredContent.productType,
              k = l === h.PHYSICAL,
              m = a.chosenVariant,
              n = b.Lang.isValue(m),
              q = b.Squarespace.UITemplates.renderAsNodeOrDocFrag(this.getProperty("HANDLEBARS_ITEM_TEMPLATE"), {
                isPhysicalProduct: k
              });
            q.setData("entry", a);
            q.setAttribute("data-item-id", d.id);
            n && q.setAttribute("data-chosen-variant-sku", m.sku);
            d = q.one(".item-image");
            f = b.Lang.isValue(f) && 0 < f.length ? f[0].assetUrl.replace("http://", "https://") + "?format=100w" :
              "/universal/images-v6/configuration/no-image.png";
            d.append('<img src="' + f + '" />');
            f = q.one(".item-desc");
            d = this.get("linkItems") ? '<a href="' + a.item.fullUrl + '">' + b.Escape.html(a.item.title) + "</a>" : "<div>" + b.Escape.html(a.item.title) + "</div>";
            f.append(d);
            var p;
            n ? p = '<div class="variant-info">' + b.Squarespace.Commerce.variantFormat(m) + "</div>" : l === h.DIGITAL && (p = '<div class="variant-info">Digital Download</div>');
            p && f.append(p);
            a.additionalFields && f.append('<div class="additional-fields"><a>Edit Details</a></div>');
            l = a.quantity;
            k && (k = q.one(".quantity input"), k.setAttrs({
              maxlength: 4,
              size: String(l).length,
              value: l
            }), k.plug(b.Squarespace.Plugin.IntegerRestrictor));
            q.one(".price").setContent(b.Squarespace.Commerce.moneyString(l * a.purchasePriceCents));
            this.get("contentBox").one("tbody").append(q)
          },
          _removeEntryRow: function(a) {
            a.plug(b.Squarespace.Animations.Fadeable, {
              duration: 0.25
            });
            a.once("hidden", function() {
              this._updateEntryQuantity(a.getData("entry"), 0)
            }, this);
            a.hide()
          },
          _getEntryRowByItemId: function(a) {
            var b;
            this.get("contentBox").all("tbody tr").each(function(c) {
              c.getData("entry").itemId ===
                a && (b = c)
            }, this);
            return b
          },
          _onQuantityChange: function(a) {
            var d = a.target;
            a = d.get("value");
            var f = d.ancestor("tr"),
              h = f.getData("entry"),
              k = Number(a),
              m = h.quantity;
            this._focusedInputItemId = h.itemId;
            "" === a || k === m || (0 === k ? (a = new b.Squarespace.Widgets.Confirmation({
              "strings.title": "Remove Item",
              "strings.message": "You have set this item's quantity to 0. This will remove it from your cart. Would you like to continue?"
            }), a.on("confirm", function() {
              this._removeEntryRow(f)
            }, this), a.on("cancel", function() {
              d.set("value",
                m)
            }, this)) : this._updateEntryQuantity(h, k, m, d))
          },
          _onAdditionalFieldsEdit: function(a) {
            if (this._additionalFieldsFormTemplate && !this.get("contentBox").hasClass("loading-cart")) {
              var d = a.target.ancestor("tr").getData("entry");
              a = d.item.structuredContent.additionalFieldsForm;
              var f = this._formWidget = new b.Squarespace.Widgets.AsyncForm({
                form: a,
                formTemplate: this._additionalFieldsFormTemplate,
                formSubmitButtonText: "Save",
                formData: b.JSON.parse(d.additionalFields),
                formName: a.name,
                showTitle: !0
              });
              f.on("submission",
                function(a) {
                  f.setStateSaving();
                  this.get("model").updateFormSubmission(d, a.data, function(a, b) {
                    f.setStateEditing();
                    this._additionalFieldsModalLightbox.close()
                  }, this)
                }, this);
              this._additionalFieldsModalLightbox.set("content", f);
              this._additionalFieldsModalLightbox.open()
            }
          },
          _updateEntryQuantity: function(a, b, c, d) {
            this.get("model").updateQuantity(a, b, function(a) {
              a && (this.showError("Unable to Update Quantity", a), d && d.inDoc() && d.set("value", c))
            }, this)
          },
          _getAdditionalFieldsFormTemplateSchema: function(d, g) {
            b.Data.get({
              url: "/api/template/GetTemplateSchema",
              data: {
                componentType: "widget",
                type: a.FORM
              },
              success: function(a) {
                d.call(g || this, a)
              }
            }, this)
          }
        }, {
          ATTRS: {
            model: {
              value: null,
              validator: function(a) {
                return b.instanceOf(a, b.Squarespace.Models.ShoppingCart)
              }
            },
            linkItems: {
              value: !1
            }
          }
        })
      }, "1.0", {
        requires: "anim base escape node squarespace-animations squarespace-commerce-utils squarespace-ui-base squarespace-ui-templates squarespace-models-shopping-cart squarespace-plugin-integer-restrictor squarespace-modal-lightbox squarespace-async-form squarespace-widgets-alert squarespace-widgets-confirmation".split(" ")
      })
  },
  2373: function(k, n) {
    YUI.add("squarespace-template-integrated-shopping-cart", function(b) {
      b.namespace("Squarespace.Widgets");
      var h = b.Squarespace.Widgets.TemplateIntegratedShoppingCart = b.Base.create("templateIntegratedShoppingCart", b.Widget, [], {
        bindUI: function() {
          h.superclass.bindUI.call(this);
          this.get("model").on("change", this.syncUI, this);
          this.get("model").after("loaded", this._markInitialized, this)
        },
        syncUI: function() {
          h.superclass.syncUI.call(this);
          var a = this.get("quantityEl"),
            c = this.get("subtotalEl"),
            d = this.get("model"),
            e = d.get("totalQuantity"),
            d = d.get("subtotalCents");
          b.Lang.isValue(a) && a.setContent(100 < e ? "100+" : e);
          b.Lang.isValue(c) && c.setContent(b.Squarespace.Commerce.moneyString(d))
        },
        _markInitialized: function() {
          this.get("boundingBox").addClass("sqs-cart-initialized")
        }
      }, {
        CSS_PREFIX: "sqs-template-integrated-shopping-cart",
        HTML_PARSER: {
          quantityEl: ".sqs-cart-quantity",
          subtotalEl: ".sqs-cart-subtotal"
        },
        ATTRS: {
          quantityEl: {
            value: null,
            validator: b.Squarespace.AttrValidators.isNullOrNode,
            writeOnce: "initOnly"
          },
          subtotalEl: {
            value: null,
            validator: b.Squarespace.AttrValidators.isNullOrNode,
            writeOnce: "initOnly"
          },
          model: {
            value: null,
            validator: function(a) {
              return b.instanceOf(a, b.Squarespace.Models.ShoppingCart)
            }
          }
        }
      })
    }, "1.0", {
      requires: "base node widget squarespace-attr-validators squarespace-commerce-utils squarespace-models-shopping-cart".split(" ")
    })
  }
});
