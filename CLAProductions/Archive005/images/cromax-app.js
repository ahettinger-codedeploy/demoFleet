/*! $.noUiSlider
 *  Documentation available at:
 *  http://refreshless.com/nouislider/
 *
 *  Copyright Léon Gersen, https://twitter.com/LeonGersen
 *  Released under the WTFPL license
 *  http://www.wtfpl.net/about/
 */
(function(f){if(f.zepto&&!f.fn.removeData)throw new ReferenceError("Zepto is loaded without the data module.");f.fn.noUiSlider=function(x){function n(a,c,d){f.isArray(a)||(a=[a]);f.each(a,function(){"function"===typeof this&&this.call(c,d)})}function s(a){return a instanceof f||f.zepto&&f.zepto.isZ(a)}function y(a){a.preventDefault();var c=0===a.type.indexOf("touch"),d=0===a.type.indexOf("mouse"),b=0===a.type.indexOf("pointer"),h,l,e=a;0===a.type.indexOf("MSPointer")&&(b=!0);a.originalEvent&&(a=a.originalEvent);
c&&(h=a.changedTouches[0].pageX,l=a.changedTouches[0].pageY);if(d||b)b||void 0!==window.pageXOffset||(window.pageXOffset=document.documentElement.scrollLeft,window.pageYOffset=document.documentElement.scrollTop),h=a.clientX+window.pageXOffset,l=a.clientY+window.pageYOffset;return f.extend(e,{pointX:h,pointY:l,cursor:d})}function p(a,c,d,b,h){a=a.replace(/\s/g,q+" ")+q;if(h)return c.on(a,f.proxy(d,f.extend(c,b)));b.handler=d;return c.on(a,f.proxy(function(b){if(this.target.hasClass("noUi-state-tap")||
this.target.attr("disabled"))return!1;this.handler(y(b))},b))}function k(a){return!isNaN(parseFloat(a))&&isFinite(a)}function z(){var a=parseFloat(this.style[f(this).data("style")]);return isNaN(a)?-1:a}function A(a){var c=this.target;if(void 0===a)return this.element.data("value");!0===a?a=this.element.data("value"):this.element.data("value",a);f.each(this.elements,function(){if("function"===typeof this)this.call(c,a);else this[0][this[1]](a)})}function B(){var a=[null,null];a[this.which]=this.val();
this.target.val(a,!0)}function C(a,c){var d={handles:{r:!0,t:function(b){b=parseInt(b,10);return 1===b||2===b}},range:{r:!0,t:function(b,a,c){if(2!==b.length)return!1;b=[parseFloat(b[0]),parseFloat(b[1])];if(!k(b[0])||!k(b[1])||"range"===c&&b[0]===b[1]||b[1]<b[0])return!1;a[c]=b;return!0}},start:{r:!0,t:function(b,a,c){return 1===a.handles?(f.isArray(b)&&(b=b[0]),b=parseFloat(b),a.start=[b],k(b)):d.range.t(b,a,c)}},connect:{t:function(b,a){return 1===a.handles?"lower"===b||"upper"===b:"boolean"===
typeof b}},orientation:{t:function(b){return"horizontal"===b||"vertical"===b}},margin:{r:!0,t:function(b,a,c){b=parseFloat(b);a[c]=100*b/(a.range[1]-a.range[0]);return k(b)}},direction:{r:!0,t:function(b,a,c){switch(b){case "ltr":a[c]=0;break;case "rtl":a[c]=1;break;default:return!1}return!0}},serialization:{r:!0,t:function(b,a,c){function d(a){return s(a)||"string"===typeof a||"function"===typeof a||!1===a||s(a[0])&&"function"===typeof a[0][a[1]]}function e(a){var b=[[],[]];d(a)?b[0].push(a):f.each(a,
function(a,c){1<a||(d(c)?b[a].push(c):b[a]=b[a].concat(c))});return b}if(b.to){var m,k;b.to=e(b.to,0);a.direction&&b.to[1].length&&b.to.reverse();for(m=0;m<a.handles;m++)for(k=0;k<b.to[m].length;k++){if(!d(b.to[m][k]))return!1;b.to[m][k]||b.to[m].splice(k,1)}a[c].to=b.to}else a[c].to=[[],[]];if(b.resolution)switch(b.resolution){case 1:case 0.1:case 0.01:case 0.001:case 1E-4:case 1E-5:break;default:return!1}else a[c].resolution=0.01;if(!b.mark)a[c].mark=".";else if("."!==b.mark&&","!==b.mark)return!1;
return!0}},slide:{t:function(a){return"function"===typeof a}},set:{t:function(a,c){return d.slide.t(a,c)}},block:{t:function(a,c){return d.slide.t(a,c)}},step:{t:function(a,c,d){a=parseFloat(a);c[d]=a;return k(a)}}};f.each(d,function(b,d){var e=a[b],f=e||0===e;if(d.r&&!f||f&&!d.t(e,a,b))throw console&&console.log&&console.group&&(console.group("Invalid noUiSlider initialisation:"),console.log("Option:\t",b),console.log("Value:\t",e),console.log("Slider(s):\t",c),console.groupEnd()),new RangeError("noUiSlider");
})}function D(a,c){a=a.toFixed(c.decimals);return a.replace(".",c.serialization.mark)}function E(a,c,d){if(c)return!1;var b=a.data("target");b.hasClass(e[14])||(d||(b.addClass(e[15]),setTimeout(function(){b.removeClass(e[15])},600)),b.addClass(e[14]),n(a.data("options").block,b));return!1}function u(a,c,d){var b=a.data("options"),h=a.data("base"),f=h.data("handles"),g,t=a[0].gPct();c=0>c?0:100<c?100:c;if(!k(c)||c===t)return!1;b.step&&(g=100*b.step/(b.range[1]-b.range[0]),c=Math.round(c/g)*g);if(c===
t)return!1;1<f.length&&(a[0]===f[1][0]?(g=f[0][0].gPct()+b.margin,c=c<g?g:c):(g=f[1][0].gPct()-b.margin,c=c>g?g:c));c=0>c?0:100<c?100:c;if(c===t)return E(h,d,!b.margin);h.data("target").removeClass(e[14]);a.css(a.data("style"),c+"%");a[0]===f[0][0]&&a.children("."+e[2]).toggleClass(e[13],50<c);b.direction&&(c=100-c);a.data("store").val(D(c*(b.range[1]-b.range[0])/100+b.range[0],b));return!0}function F(a,c,d){if(s(c)){var b=[];a.data("options").direction&&(d=d?0:1);c.each(function(){p("change",f(this),
B,{target:a.data("target"),handle:a,which:d},!0);b.push([f(this),"val"])});return b}"string"===typeof c&&(c=[f('<input type="hidden" name="'+c+'">').appendTo(a).addClass(e[3]).change(function(a){a.stopPropagation()}),"val"]);return[c]}function G(a,c,d){var b=[];f.each(d.to[c],function(e){b=b.concat(F(a,d.to[c][e],c))});return{element:a,elements:b,target:a.data("target"),val:A}}function H(a){var c=this.base,d;"left"===this.handle.data("style")?(a=a.pointX-this.startEvent.pointX,d=c.width()):(a=a.pointY-
this.startEvent.pointY,d=c.height());a=this.position+100*a/d;u(this.handle,a)&&n(c.data("options").slide,c.data("target"))}function I(a){this.handle.children("."+e[2]).removeClass(e[4]);a.cursor&&v.css("cursor","").off(q);w.off(q);this.target.removeClass(e[14]).change();n(this.handle.data("options").set,this.target)}function J(a){this.handle.children("."+e[2]).addClass(e[4]);a.stopPropagation();p(r.move,w,H,{startEvent:a,position:this.handle[0].gPct(),base:this.base,target:this.target,handle:this.handle});
p(r.end,w,I,{base:this.base,target:this.target,handle:this.handle});a.cursor&&(v.css("cursor","default"),v.on("selectstart"+q,function(){return!1}))}function K(a){if(!this.base.find("."+e[4]).length){var c,d,b=this.base;d=b.data("handles");var f=d[0].data("style");a=a["left"===f?"pointX":"pointY"];var l="left"===f?b.width():b.height(),g=[],k=b.offset();for(c=0;c<d.length;c++)g.push(d[c].offset());c=1===d.length?0:(g[0][f]+g[1][f])/2;d=1===d.length||a<c?d[0]:d[1];b.addClass(e[5]);setTimeout(function(){b.removeClass(e[5])},
300);u(d,100*(a-k[f])/l);n([d.data("options").slide,d.data("options").set],b.data("target"));b.data("target").change()}}function L(){var a=f(this).data("base"),c=[];f.each(a.data("handles"),function(){c.push(f(this).data("store").val())});return 1===c.length?c[0]:a.data("options").direction?c.reverse():c}function M(a,c){f.isArray(a)||(a=[a]);return this.each(function(){var d=Array.prototype.slice.call(f(this).data("base").data("handles"),0),b=d[0].data("options"),e,l;1<d.length&&(d[2]=d[0]);b.direction&&
a.reverse();for(l=0;l<d.length;l++)if(e=a[l%2],null!==e&&void 0!==e){"string"===f.type(e)&&(e=e.replace(",","."));var g=b.range;e=parseFloat(e);e=100*(0>g[0]?e+Math.abs(g[0]):e-g[0])/(g[1]-g[0]);b.direction&&(e=100-e);u(d[l],e,!0)||d[l].data("store").val(!0);!0===c&&n(b.set,f(this))}})}var w=f(document),v=f("body"),q=".nui",N=f.fn.val,e="noUi-base noUi-origin noUi-handle noUi-input noUi-active noUi-state-tap noUi-target -lower -upper noUi-connect noUi-vertical noUi-horizontal noUi-background noUi-z-index noUi-block noUi-state-blocked noUi-rtl".split(" "),
r=window.navigator.pointerEnabled?{start:"pointerdown",move:"pointermove",end:"pointerup"}:window.navigator.msPointerEnabled?{start:"MSPointerDown",move:"MSPointerMove",end:"MSPointerUp"}:{start:"mousedown touchstart",move:"mousemove touchmove",end:"mouseup touchend"};f.fn.val=function(){return this.hasClass(e[6])?arguments.length?M.apply(this,arguments):L.apply(this):N.apply(this,arguments)};return function(a){a=f.extend({handles:2,margin:0,direction:"ltr",orientation:"horizontal"},a)||{};a.serialization=
a.serialization||{};C(a,this);return this.each(function(){var c=f(this).addClass(e[6]),d,b,h=f("<div/>").appendTo(c);d=a.direction;b=[e[0]];var l=[[e[1],e[1]+e[d?8:7]],[e[1],e[1]+e[d?7:8]]],g=[[e[2],e[2]+e[d?8:7]],[e[2],e[2]+e[d?7:8]]];a.connect?(d&&("lower"===a.connect?a.connect="upper":"upper"===a.connect&&(a.connect="lower")),"lower"===a.connect?(b.push(e[9],e[9]+e[7]),l[0].push(e[12])):(b.push(e[9]+e[8],e[12]),l[0].push(e[9]))):b.push(e[12]);var k=a,m=a.serialization.resolution,m=m.toString().split(".");
k.decimals="1"===m[0]?0:m[1].length;"vertical"===a.orientation?b.push(e[10]):b.push(e[11]);h.addClass(b.join(" ")).data({target:c,options:a,handles:[]});c.data("base",h);d&&c.addClass(e[16]);for(d=0;d<a.handles;d++)b=f("<div><div/></div>").appendTo(h),b.addClass(l[d].join(" ")),b.children().addClass(g[d].join(" ")),p(r.start,b.children(),J,{base:h,target:c,handle:b}),b.data({base:h,target:c,options:a,style:"vertical"===a.orientation?"top":"left"}),b.data({store:G(b,d,a.serialization)}),b[0].gPct=
z,h.data("handles").push(b);c.val(a.start);p(r.start,h,K,{base:h,target:c})})}.call(this,x)}})(window.jQuery||window.Zepto);




(function ($) {
    "use strict";


    // Initialize the lightbox
    $.cromaPay = function(el) {
        this.$el = $(el);
        this._init();
    };


     $.cromaPay.prototype = {

        _init: function() {


            // list of reusable classes
            this.cllist         = [
                 /* 0  */  'body'
                 /* 1  */  ,'cro-clicker'
                 /* 2  */  ,'.cro_paypal_range_slider'
                 /* 3  */  ,'cro-min'
                 /* 4  */  ,'cro-max'
                 /* 5  */  ,'cro-def'
                 /* 6  */  ,'.cro-serializer'
                 /* 7  */  ,'.cro-serialized'
                 /* 8  */  ,'[data-cro-clicker="freqClik"]'
                 /* 9  */  ,'cro_don_freq_active'
                 /* 10  */ ,'.cro_freqput'
                 /* 11  */ ,'.cro_donations_validate'
                 /* 12  */ ,'.cro_errmess'
                 /* 13  */ ,'[data-cro-serialize="true"]'
                 /* 14  */ ,'.cro_paypalpop'
                 /* 15  */ ,'.cro_spinholder'
                 /* 16  */ ,'.cro_poppanel'
                 /* 17  */ ,'cro-step'
                 /* 18  */ ,'cro_poanel'
                 
            ];

            // find the body as base for the page
            this.base           = $( this.cllist[0] );
            this.slider         = this.$el.find(  this.cllist[2] );
            this.slider         = this.$el.find(  this.cllist[2] );
            this.min            = this.slider.data(  this.cllist[3] );
            this.max            = this.slider.data(  this.cllist[4] );
            this.def            = this.slider.data(  this.cllist[5] );
            this.seriator       = this.$el.find(  this.cllist[6] );
            this.seriating      = this.$el.find(  this.cllist[7] );
            this.freqClick      = this.$el.find(  this.cllist[8] );
            this.freqPut        = this.$el.find(  this.cllist[10] );
            this.valiDateme     = this.$el.find(  this.cllist[11] );
            this.errMess        = this.$el.find(  this.cllist[12] );
            this.popMod         = this.$el.find(  this.cllist[14] );
            this.popSpin        = this.$el.find(  this.cllist[15] );
            this.popPanel       = this.$el.find(  this.cllist[16] );
            this.step           = this.slider.data(  this.cllist[17] );


            this._deleGate();

            this.valiDateme.val('');

            this._nouiSlide();

        },


        _nouiSlide: function() {
            var self            = this;

            self.slider.noUiSlider({
                range: [self.min, self.max]
                ,start: self.def
                ,step: self.step
                ,handles: 1
                ,serialization: {
                    to: self.seriator
                    ,resolution: 1,
                }
             });

        },

        _Valreq: function() {
             var self   = this,
                 valq   = 0;

            self.valiDateme.each(function() {
                $(this).css('border','1px solid rgba(0,0,0,0.8)');
                if ($(this).val() == '') {
                    valq = valq + 1;
                    $(this).css('border','1px solid red');
                }
            });

            return valq;

        },
        _subMitter: function() {
            var self    = this,
                data    = 'action=cromax_paypal_ajaxdatas&type=cro_do_paypaldonation&nonce=' + cro_query.cro_nonces,
                serStr  = '';

                self.popMod.show();
                self.popSpin.show();

                self.$el.find('input').each(function() {
                    serStr += '&' + $(this).attr('name') + '=' + $(this).val();
                });

            $.post(cro_query.ajaxurl, data + serStr, function(response) {

                self.popPanel.html(response);
                self.popSpin.hide();

            });

        },

        // the click manager that performs the functions after the clicks
        _manageParts: function(node, el) {
            var self            = this,
                

            funcTree        = {
                
                freqClik: function() {
                    var elval = el.data('cro-val');
                    self.freqClick.removeClass(   self.cllist[9] ); 
                    el.addClass(   self.cllist[9]  );
                    self.freqPut.val(elval);       
                },
                PaySubm: function() {
                    if (self._Valreq() == 0) {
                        self._subMitter();
                        self.errMess.hide();
                    } else {
                        self.errMess.show();
                    }
                }

            };

            funcTree[node]();   
        },


        // the delegater function that manages the clicks
        _deleGate: function() {
            var self            = this;
            
            $(this.base).on('click.lightClicker', function(e) {

                // event listener and binder for clicks
                if (typeof $(e.target).data( self.cllist[1]) !== 'undefined' ) {

                    e.preventDefault();

                    var clickTarget = $( e.target ).data( self.cllist[1] );
                    self._manageParts( clickTarget,$( e.target ) ); 
                }

            }); 

            // prevent events from executing when chained   
            return false;
        }

    };

    $.fn.cromaPay = function() {
        new $.cromaPay($(this));
    };

})( jQuery, window );







jQuery(document).ready(function($) {

	/** This is the main JQuery file for the plugin.
		It handles the small functions needed and also binds our larger.
		Editing these files wihtout a good knowledge of Javascript & JQuery can Render your Theme useless.
	**/ 

    if ($('.cro_paypalouter').length >= 1) {
        $('.cro_paypalouter').cromaPay();
    }


    $('.cromaxModal').each(function() {
        var target = $('.main');
        $(this).detach().appendTo(target);
    });



    /**  Tabs code **/

    $('.cro_tab_container').each(function() {
        var firstactiveli = $(this).find('li:first');
        var firstactivediv = $(this).find('.tab-pane:first');

        firstactiveli.addClass('cro_activeli');
        firstactivediv.addClass('cro_activediv');
    });

    $('ul.nav-tabs li').click(function() {
        var divvie = $(this).find('a').attr('href');
        $(this).parent('ul').find('.cro_activeli').removeClass('cro_activeli');
        $(this).addClass('cro_activeli');
        $(this).parents('.cro_tab_container').find('.cro_activediv').removeClass('cro_activediv');
        $(divvie).addClass('cro_activediv');
        return false;

    });


    $('.cro_accordion_container')
        .find('.cro_accordion_single:eq( 0 )')
        .addClass('cro_activepane')
        .find('.accordion-cnt').slideDown('slow');

    $('.accordion-pane').click(function() {
        if ($(this).parents('.cro_activepane').length === 0) {
            $(this).parents('.cro_accordion_container').find('.cro_activepane').find('.accordion-cnt').slideUp('slow');
            $(this).parents('.cro_accordion_container').find('.cro_activepane').removeClass('cro_activepane');
            $(this).parents('.cro_accordion_single').addClass('cro_activepane');
            $(this).parents('.cro_accordion_single').find('.accordion-cnt').slideDown('slow');
        } 
    });


    if ($('#map-div').length != 0  ) {
        var streetaddress   = $('#map-div').data('addr'),
            lt              = $('#map-div').data('lt'),
            lg              = $('#map-div').data('lg'),
            zoom            = $('#map-div').data('zoom'),
            mapsIcon        = $('#map-div').data('icon'),
            geocoder,styledMap,myLatlng,
            MPstyles        = [{
                                stylers: [
                                    { hue: '#fff' },
                                    { saturation: -100 }
                                ]},{
                                featureType: "road",
                                elementType: "geometry",
                                stylers: [
                                    { lightness: 0}
                                ]},{
                                    featureType: "road",
                                    elementType: "labels"
                                }];


        if ( lt == "" ||  lg == ""){
            geocoder        = new google.maps.Geocoder();
            styledMap       = new google.maps.StyledMapType(MPstyles,{name: "Styled Map"});

            geocoder.geocode( { 'address': streetaddress}, function(results, status) {

                if (status == google.maps.GeocoderStatus.OK) {

                    var mapOptions = { 
                            zoom: zoom, 
                            scrollwheel: false,
                            draggable: false,
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            mapTypeControlOptions: {
                                mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'map_style']
                           }

                        };
                    var map = new google.maps.Map(document.getElementById('map-div'), mapOptions);
                    map.setCenter(results[0].geometry.location);
                    var marker = new google.maps.Marker({
                        map: map,
                        position: results[0].geometry.location,
                        icon: mapsIcon
                    });
                    map.mapTypes.set('map_style', styledMap);
                    map.setMapTypeId('map_style');

                } else {
                    alert("geocode of "+ streetaddress +" failed:"+status);
                }
            });
        } else {

            styledMap       = new google.maps.StyledMapType(MPstyles,{name: "Styled Map"});
            myLatlng        = new google.maps.LatLng(parseFloat(lt),parseFloat(lg));


            var mapOptions  = { 
                                zoom: zoom, 
                                scrollwheel: false,
                                draggable: false,
                                mapTypeId: google.maps.MapTypeId.ROADMAP,
                                center: myLatlng,
                                mapTypeControlOptions: {
                                mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'map_style']
                                }
                            };
            var map         = new google.maps.Map(document.getElementById('map-div'), mapOptions);
            
            var marker      = new google.maps.Marker({
                                map: map,
                                position: myLatlng,
                                icon: mapsIcon
                            });

            map.mapTypes.set('map_style', styledMap);
            map.setMapTypeId('map_style');
            
        }
    }


    if ($('#map-drv').length != 0  ) {
        var streetaddress   = $('#map-drv').data('addr'),
            lt              = $('#map-drv').data('lt'),
            lg              = $('#map-drv').data('lg'),
            mapContainer    = document.getElementById("map-drv"),
            dirContainer    = document.getElementById("dir-container"),
            fromInput       = document.getElementById("from-input"),
            toInput         = document.getElementById("to-input"),
            map;


        var unitSystem = google.maps.DirectionsUnitSystem.IMPERIAL;     
        if (cro_mmapmetrics && cro_mmapmetrics === '2'){
            unitSystem = google.maps.DirectionsUnitSystem.METRIC;   
        }

        if ( lt == "" ||  lg == ""){
            
            geocoder        = new google.maps.Geocoder();
            geocoder.geocode( { 'address': streetaddress}, function(results, status) {

                var mapOptions = { 
                            zoom: 16, 
                            center: results[0].geometry.location,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                    };
                map = new google.maps.Map(mapContainer, mapOptions);

                var marker = new google.maps.Marker({
                    position: results[0].geometry.location, 
                    map: map
                }); 


                $('#cro_driveclick').click(function() {
                    getDirections();
                }); 


                function getDirections() {

                    var fromStr             = fromInput.value,
                        toStr               = toInput.value,
                        directionsService   = new google.maps.DirectionsService(),
                        directionsDisplay   = new google.maps.DirectionsRenderer(),
                        dirRequest  = {
                            origin: fromStr,
                            destination: toStr,
                            travelMode: google.maps.DirectionsTravelMode.DRIVING,
                            unitSystem: google.maps.DirectionsUnitSystem.METRIC,
                            provideRouteAlternatives: true
                        };
                    directionsService.route(dirRequest, function(result, status) {
                        if (status == google.maps.DirectionsStatus.OK) {
                            directionsDisplay.setDirections(result);
                            directionsDisplay.setPanel(dirContainer);
                            directionsDisplay.setMap(map);
                        }
                    });

                }
                           
            });


        } else {


            myLatlng        = new google.maps.LatLng(parseFloat(lt),parseFloat(lg));

            var mapOptions = { 
                        zoom: 16, 
                        center: myLatlng,
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                };
                
            map = new google.maps.Map(mapContainer, mapOptions);

            var marker = new google.maps.Marker({
                position: myLatlng, 
                   map: map
            }); 


            $('#cro_driveclick').click(function() {
                getDirections();
            }); 


            function getDirections() {
                var fromStr             = fromInput.value,
                    toStr               = myLatlng,
                    directionsService   = new google.maps.DirectionsService(),
                    directionsDisplay   = new google.maps.DirectionsRenderer(),
                    dirRequest  = {
                        origin: fromStr,
                        destination: toStr,
                        travelMode: google.maps.DirectionsTravelMode.DRIVING,
                        unitSystem: google.maps.DirectionsUnitSystem.METRIC,
                        provideRouteAlternatives: true
                    };
                    
                directionsService.route(dirRequest, function(result, status) {
                    if (status == google.maps.DirectionsStatus.OK) {
                        directionsDisplay.setDirections(result);
                        directionsDisplay.setPanel(dirContainer);
                        directionsDisplay.setMap(map);
                     }
                });

            }

        }
    }

    if ($('#map-str').length != 0  ) {
        var lts              = $('#map-str').data('lt'),
            lgs              = $('#map-str').data('lg'),
            azoom           = $('#map-str').data('zoom'),
            orient          = $('#map-str').data('orient'),
            myLatlng        = new google.maps.LatLng(lts,lgs),
            panoramaOptions = {
                                addressControl: false,
                                position: myLatlng,
                                pov: {
                                    heading: orient,
                                    pitch: 0,
                                },
                                zoom: azoom
                            };


        panorama = new  google.maps.StreetViewPanorama(document.getElementById("map-str"), panoramaOptions);
        panorama.setVisible(true);
    }

});