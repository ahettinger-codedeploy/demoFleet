!function(t){t.fn.hoverIntent=function(e,i,s){var n={interval:100,sensitivity:7,timeout:0};n="object"==typeof e?t.extend(n,e):t.isFunction(i)?t.extend(n,{over:e,out:i,selector:s}):t.extend(n,{over:e,out:e,selector:i});var o,r,a,l,h=function(t){o=t.pageX,r=t.pageY},c=function(e,i){return i.hoverIntent_t=clearTimeout(i.hoverIntent_t),Math.abs(a-o)+Math.abs(l-r)<n.sensitivity?(t(i).off("mousemove.hoverIntent",h),i.hoverIntent_s=1,n.over.apply(i,[e])):(a=o,l=r,i.hoverIntent_t=setTimeout(function(){c(e,i)},n.interval),void 0)},u=function(t,e){return e.hoverIntent_t=clearTimeout(e.hoverIntent_t),e.hoverIntent_s=0,n.out.apply(e,[t])},d=function(e){var i=jQuery.extend({},e),s=this;s.hoverIntent_t&&(s.hoverIntent_t=clearTimeout(s.hoverIntent_t)),"mouseenter"==e.type?(a=i.pageX,l=i.pageY,t(s).on("mousemove.hoverIntent",h),1!=s.hoverIntent_s&&(s.hoverIntent_t=setTimeout(function(){c(i,s)},n.interval))):(t(s).off("mousemove.hoverIntent",h),1==s.hoverIntent_s&&(s.hoverIntent_t=setTimeout(function(){u(i,s)},n.timeout)))};return this.on({"mouseenter.hoverIntent":d,"mouseleave.hoverIntent":d},n.selector)}}(jQuery),function(t,e){"use strict";var i,s=t.document,n=s.documentElement,o=t.Modernizr,r=function(t){return t.charAt(0).toUpperCase()+t.slice(1)},a="Moz Webkit O Ms".split(" "),l=function(t){var e,i=n.style;if("string"==typeof i[t])return t;t=r(t);for(var s=0,o=a.length;o>s;s++)if(e=a[s]+t,"string"==typeof i[e])return e},h=l("transform"),c=l("transitionProperty"),u={csstransforms:function(){return!!h},csstransforms3d:function(){var t=!!l("perspective");if(t&&"webkitPerspective"in n.style){var i=e("<style>@media (transform-3d),(-webkit-transform-3d){#modernizr{height:3px}}</style>").appendTo("head"),s=e('<div id="modernizr" />').appendTo("html");t=3===s.height(),s.remove(),i.remove()}return t},csstransitions:function(){return!!c}};if(o)for(i in u)o.hasOwnProperty(i)||o.addTest(i,u[i]);else{o=t.Modernizr={_version:"1.6ish: miniModernizr for Isotope"};var d,f=" ";for(i in u)d=u[i](),o[i]=d,f+=" "+(d?"":"no-")+i;e("html").addClass(f)}if(o.csstransforms){var p=o.csstransforms3d?{translate:function(t){return"translate3d("+t[0]+"px, "+t[1]+"px, 0) "},scale:function(t){return"scale3d("+t+", "+t+", 1) "}}:{translate:function(t){return"translate("+t[0]+"px, "+t[1]+"px) "},scale:function(t){return"scale("+t+") "}},m=function(t,i,s){var n,o,r=e.data(t,"isoTransform")||{},a={},l={};a[i]=s,e.extend(r,a);for(n in r)o=r[n],l[n]=p[n](o);var c=l.translate||"",u=l.scale||"",d=c+u;e.data(t,"isoTransform",r),t.style[h]=d};e.cssNumber.scale=!0,e.cssHooks.scale={set:function(t,e){m(t,"scale",e)},get:function(t){var i=e.data(t,"isoTransform");return i&&i.scale?i.scale:1}},e.fx.step.scale=function(t){e.cssHooks.scale.set(t.elem,t.now+t.unit)},e.cssNumber.translate=!0,e.cssHooks.translate={set:function(t,e){m(t,"translate",e)},get:function(t){var i=e.data(t,"isoTransform");return i&&i.translate?i.translate:[0,0]}}}var y,v;o.csstransitions&&(y={WebkitTransitionProperty:"webkitTransitionEnd",MozTransitionProperty:"transitionend",OTransitionProperty:"oTransitionEnd otransitionend",transitionProperty:"transitionend"}[c],v=l("transitionDuration"));var g,_=e.event,w=e.event.handle?"handle":"dispatch";_.special.smartresize={setup:function(){e(this).bind("resize",_.special.smartresize.handler)},teardown:function(){e(this).unbind("resize",_.special.smartresize.handler)},handler:function(t,e){var i=this,s=arguments;t.type="smartresize",g&&clearTimeout(g),g=setTimeout(function(){_[w].apply(i,s)},"execAsap"===e?0:100)}},e.fn.smartresize=function(t){return t?this.bind("smartresize",t):this.trigger("smartresize",["execAsap"])},e.Isotope=function(t,i,s){this.element=e(i),this._create(t),this._init(s)};var b=["width","height"],C=e(t);e.Isotope.settings={resizable:!0,layoutMode:"masonry",containerClass:"isotope",itemClass:"isotope-item",hiddenClass:"isotope-hidden",hiddenStyle:{opacity:0,scale:.001},visibleStyle:{opacity:1,scale:1},containerStyle:{position:"relative",overflow:"hidden"},animationEngine:"best-available",animationOptions:{queue:!1,duration:800},sortBy:"original-order",sortAscending:!0,resizesContainer:!0,transformsEnabled:!0,itemPositionDataEnabled:!1},e.Isotope.prototype={_create:function(t){this.options=e.extend({},e.Isotope.settings,t),this.styleQueue=[],this.elemCount=0;var i=this.element[0].style;this.originalStyle={};var s=b.slice(0);for(var n in this.options.containerStyle)s.push(n);for(var o=0,r=s.length;r>o;o++)n=s[o],this.originalStyle[n]=i[n]||"";this.element.css(this.options.containerStyle),this._updateAnimationEngine(),this._updateUsingTransforms();var a={"original-order":function(t,e){return e.elemCount++,e.elemCount},random:function(){return Math.random()}};this.options.getSortData=e.extend(this.options.getSortData,a),this.reloadItems(),this.offset={left:parseInt(this.element.css("padding-left")||0,10),top:parseInt(this.element.css("padding-top")||0,10)};var l=this;setTimeout(function(){l.element.addClass(l.options.containerClass)},0),this.options.resizable&&C.bind("smartresize.isotope",function(){l.resize()}),this.element.delegate("."+this.options.hiddenClass,"click",function(){return!1})},_getAtoms:function(t){var e=this.options.itemSelector,i=e?t.filter(e).add(t.find(e)):t,s={position:"absolute"};return i=i.filter(function(t,e){return 1===e.nodeType}),this.usingTransforms&&(s.left=0,s.top=0),i.css(s).addClass(this.options.itemClass),this.updateSortData(i,!0),i},_init:function(t){this.$filteredAtoms=this._filter(this.$allAtoms),this._sort(),this.reLayout(t)},option:function(t){if(e.isPlainObject(t)){this.options=e.extend(!0,this.options,t);var i;for(var s in t)i="_update"+r(s),this[i]&&this[i]()}},_updateAnimationEngine:function(){var t,e=this.options.animationEngine.toLowerCase().replace(/[ _\-]/g,"");switch(e){case"css":case"none":t=!1;break;case"jquery":t=!0;break;default:t=!o.csstransitions}this.isUsingJQueryAnimation=t,this._updateUsingTransforms()},_updateTransformsEnabled:function(){this._updateUsingTransforms()},_updateUsingTransforms:function(){var t=this.usingTransforms=this.options.transformsEnabled&&o.csstransforms&&o.csstransitions&&!this.isUsingJQueryAnimation;t||(delete this.options.hiddenStyle.scale,delete this.options.visibleStyle.scale),this.getPositionStyles=t?this._translate:this._positionAbs},_filter:function(t){var e=""===this.options.filter?"*":this.options.filter;if(!e)return t;var i=this.options.hiddenClass,s="."+i,n=t.filter(s),o=n;if("*"!==e){o=n.filter(e);var r=t.not(s).not(e).addClass(i);this.styleQueue.push({$el:r,style:this.options.hiddenStyle})}return this.styleQueue.push({$el:o,style:this.options.visibleStyle}),o.removeClass(i),t.filter(e)},updateSortData:function(t,i){var s,n,o=this,r=this.options.getSortData;t.each(function(){s=e(this),n={};for(var t in r)n[t]=i||"original-order"!==t?r[t](s,o):e.data(this,"isotope-sort-data")[t];e.data(this,"isotope-sort-data",n)})},_sort:function(){var t=this.options.sortBy,e=this._getSorter,i=this.options.sortAscending?1:-1,s=function(s,n){var o=e(s,t),r=e(n,t);return o===r&&"original-order"!==t&&(o=e(s,"original-order"),r=e(n,"original-order")),(o>r?1:r>o?-1:0)*i};this.$filteredAtoms.sort(s)},_getSorter:function(t,i){return e.data(t,"isotope-sort-data")[i]},_translate:function(t,e){return{translate:[t,e]}},_positionAbs:function(t,e){return{left:t,top:e}},_pushPosition:function(t,e,i){e=Math.round(e+this.offset.left),i=Math.round(i+this.offset.top);var s=this.getPositionStyles(e,i);this.styleQueue.push({$el:t,style:s}),this.options.itemPositionDataEnabled&&t.data("isotope-item-position",{x:e,y:i})},layout:function(t,e){var i=this.options.layoutMode;if(this["_"+i+"Layout"](t),this.options.resizesContainer){var s=this["_"+i+"GetContainerSize"]();this.styleQueue.push({$el:this.element,style:s})}this._processStyleQueue(t,e),this.isLaidOut=!0},_processStyleQueue:function(t,i){var s,n,r,a,l=this.isLaidOut&&this.isUsingJQueryAnimation?"animate":"css",h=this.options.animationOptions,c=this.options.onLayout;if(n=function(t,e){e.$el[l](e.style,h)},this._isInserting&&this.isUsingJQueryAnimation)n=function(t,e){s=e.$el.hasClass("no-transition")?"css":l,e.$el[s](e.style,h)};else if(i||c||h.complete){var u=!1,d=[i,c,h.complete],f=this;if(r=!0,a=function(){if(!u){for(var e,i=0,s=d.length;s>i;i++)e=d[i],"function"==typeof e&&e.call(f.element,t,f);u=!0}},this.isUsingJQueryAnimation&&"animate"===l)h.complete=a,r=!1;else if(o.csstransitions){for(var p,m=0,g=this.styleQueue[0],_=g&&g.$el;!_||!_.length;){if(p=this.styleQueue[m++],!p)return;_=p.$el}var w=parseFloat(getComputedStyle(_[0])[v]);w>0&&(n=function(t,e){e.$el[l](e.style,h).one(y,a)},r=!1)}}e.each(this.styleQueue,n),r&&a(),this.styleQueue=[]},resize:function(){this["_"+this.options.layoutMode+"ResizeChanged"]()&&this.reLayout()},reLayout:function(t){this["_"+this.options.layoutMode+"Reset"](),this.layout(this.$filteredAtoms,t)},addItems:function(t,e){var i=this._getAtoms(t);this.$allAtoms=this.$allAtoms.add(i),e&&e(i)},insert:function(t,e){this.element.append(t);var i=this;this.addItems(t,function(t){var s=i._filter(t);i._addHideAppended(s),i._sort(),i.reLayout(),i._revealAppended(s,e)})},appended:function(t,e){var i=this;this.addItems(t,function(t){i._addHideAppended(t),i.layout(t),i._revealAppended(t,e)})},_addHideAppended:function(t){this.$filteredAtoms=this.$filteredAtoms.add(t),t.addClass("no-transition"),this._isInserting=!0,this.styleQueue.push({$el:t,style:this.options.hiddenStyle})},_revealAppended:function(t,e){var i=this;setTimeout(function(){t.removeClass("no-transition"),i.styleQueue.push({$el:t,style:i.options.visibleStyle}),i._isInserting=!1,i._processStyleQueue(t,e)},10)},reloadItems:function(){this.$allAtoms=this._getAtoms(this.element.children())},remove:function(t,e){this.$allAtoms=this.$allAtoms.not(t),this.$filteredAtoms=this.$filteredAtoms.not(t);var i=this,s=function(){t.remove(),e&&e.call(i.element)};t.filter(":not(."+this.options.hiddenClass+")").length?(this.styleQueue.push({$el:t,style:this.options.hiddenStyle}),this._sort(),this.reLayout(s)):s()},shuffle:function(t){this.updateSortData(this.$allAtoms),this.options.sortBy="random",this._sort(),this.reLayout(t)},destroy:function(){var t=this.usingTransforms,e=this.options;this.$allAtoms.removeClass(e.hiddenClass+" "+e.itemClass).each(function(){var e=this.style;e.position="",e.top="",e.left="",e.opacity="",t&&(e[h]="")});var i=this.element[0].style;for(var s in this.originalStyle)i[s]=this.originalStyle[s];this.element.unbind(".isotope").undelegate("."+e.hiddenClass,"click").removeClass(e.containerClass).removeData("isotope"),C.unbind(".isotope")},_getSegments:function(t){var e,i=this.options.layoutMode,s=t?"rowHeight":"columnWidth",n=t?"height":"width",o=t?"rows":"cols",a=this.element[n](),l=this.options[i]&&this.options[i][s]||this.$filteredAtoms["outer"+r(n)](!0)||a;e=Math.floor(a/l),e=Math.max(e,1),this[i][o]=e,this[i][s]=l},_checkIfSegmentsChanged:function(t){var e=this.options.layoutMode,i=t?"rows":"cols",s=this[e][i];return this._getSegments(t),this[e][i]!==s},_masonryReset:function(){this.masonry={},this._getSegments();var t=this.masonry.cols;for(this.masonry.colYs=[];t--;)this.masonry.colYs.push(0)},_masonryLayout:function(t){var i=this,s=i.masonry;t.each(function(){var t=e(this),n=Math.ceil(t.outerWidth(!0)/s.columnWidth);if(n=Math.min(n,s.cols),1===n)i._masonryPlaceBrick(t,s.colYs);else{var o,r,a=s.cols+1-n,l=[];for(r=0;a>r;r++)o=s.colYs.slice(r,r+n),l[r]=Math.max.apply(Math,o);i._masonryPlaceBrick(t,l)}})},_masonryPlaceBrick:function(t,e){for(var i=Math.min.apply(Math,e),s=0,n=0,o=e.length;o>n;n++)if(e[n]===i){s=n;break}var r=this.masonry.columnWidth*s,a=i;this._pushPosition(t,r,a);var l=i+t.outerHeight(!0),h=this.masonry.cols+1-o;for(n=0;h>n;n++)this.masonry.colYs[s+n]=l},_masonryGetContainerSize:function(){var t=Math.max.apply(Math,this.masonry.colYs);return{height:t}},_masonryResizeChanged:function(){return this._checkIfSegmentsChanged()},_fitRowsReset:function(){this.fitRows={x:0,y:0,height:0}},_fitRowsLayout:function(t){var i=this,s=this.element.width(),n=this.fitRows;t.each(function(){var t=e(this),o=t.outerWidth(!0),r=t.outerHeight(!0);0!==n.x&&o+n.x>s&&(n.x=0,n.y=n.height),i._pushPosition(t,n.x,n.y),n.height=Math.max(n.y+r,n.height),n.x+=o})},_fitRowsGetContainerSize:function(){return{height:this.fitRows.height}},_fitRowsResizeChanged:function(){return!0},_cellsByRowReset:function(){this.cellsByRow={index:0},this._getSegments(),this._getSegments(!0)},_cellsByRowLayout:function(t){var i=this,s=this.cellsByRow;t.each(function(){var t=e(this),n=s.index%s.cols,o=Math.floor(s.index/s.cols),r=(n+.5)*s.columnWidth-t.outerWidth(!0)/2,a=(o+.5)*s.rowHeight-t.outerHeight(!0)/2;i._pushPosition(t,r,a),s.index++})},_cellsByRowGetContainerSize:function(){return{height:Math.ceil(this.$filteredAtoms.length/this.cellsByRow.cols)*this.cellsByRow.rowHeight+this.offset.top}},_cellsByRowResizeChanged:function(){return this._checkIfSegmentsChanged()},_straightDownReset:function(){this.straightDown={y:0}},_straightDownLayout:function(t){var i=this;t.each(function(){var t=e(this);i._pushPosition(t,0,i.straightDown.y),i.straightDown.y+=t.outerHeight(!0)})},_straightDownGetContainerSize:function(){return{height:this.straightDown.y}},_straightDownResizeChanged:function(){return!0},_masonryHorizontalReset:function(){this.masonryHorizontal={},this._getSegments(!0);var t=this.masonryHorizontal.rows;for(this.masonryHorizontal.rowXs=[];t--;)this.masonryHorizontal.rowXs.push(0)},_masonryHorizontalLayout:function(t){var i=this,s=i.masonryHorizontal;t.each(function(){var t=e(this),n=Math.ceil(t.outerHeight(!0)/s.rowHeight);if(n=Math.min(n,s.rows),1===n)i._masonryHorizontalPlaceBrick(t,s.rowXs);else{var o,r,a=s.rows+1-n,l=[];for(r=0;a>r;r++)o=s.rowXs.slice(r,r+n),l[r]=Math.max.apply(Math,o);i._masonryHorizontalPlaceBrick(t,l)}})},_masonryHorizontalPlaceBrick:function(t,e){for(var i=Math.min.apply(Math,e),s=0,n=0,o=e.length;o>n;n++)if(e[n]===i){s=n;break}var r=i,a=this.masonryHorizontal.rowHeight*s;this._pushPosition(t,r,a);var l=i+t.outerWidth(!0),h=this.masonryHorizontal.rows+1-o;for(n=0;h>n;n++)this.masonryHorizontal.rowXs[s+n]=l},_masonryHorizontalGetContainerSize:function(){var t=Math.max.apply(Math,this.masonryHorizontal.rowXs);return{width:t}},_masonryHorizontalResizeChanged:function(){return this._checkIfSegmentsChanged(!0)},_fitColumnsReset:function(){this.fitColumns={x:0,y:0,width:0}},_fitColumnsLayout:function(t){var i=this,s=this.element.height(),n=this.fitColumns;t.each(function(){var t=e(this),o=t.outerWidth(!0),r=t.outerHeight(!0);0!==n.y&&r+n.y>s&&(n.x=n.width,n.y=0),i._pushPosition(t,n.x,n.y),n.width=Math.max(n.x+o,n.width),n.y+=r})},_fitColumnsGetContainerSize:function(){return{width:this.fitColumns.width}},_fitColumnsResizeChanged:function(){return!0},_cellsByColumnReset:function(){this.cellsByColumn={index:0},this._getSegments(),this._getSegments(!0)},_cellsByColumnLayout:function(t){var i=this,s=this.cellsByColumn;t.each(function(){var t=e(this),n=Math.floor(s.index/s.rows),o=s.index%s.rows,r=(n+.5)*s.columnWidth-t.outerWidth(!0)/2,a=(o+.5)*s.rowHeight-t.outerHeight(!0)/2;i._pushPosition(t,r,a),s.index++})},_cellsByColumnGetContainerSize:function(){return{width:Math.ceil(this.$filteredAtoms.length/this.cellsByColumn.rows)*this.cellsByColumn.columnWidth}},_cellsByColumnResizeChanged:function(){return this._checkIfSegmentsChanged(!0)},_straightAcrossReset:function(){this.straightAcross={x:0}},_straightAcrossLayout:function(t){var i=this;t.each(function(){var t=e(this);i._pushPosition(t,i.straightAcross.x,0),i.straightAcross.x+=t.outerWidth(!0)})},_straightAcrossGetContainerSize:function(){return{width:this.straightAcross.x}},_straightAcrossResizeChanged:function(){return!0}},e.fn.imagesLoaded=function(t){function i(){t.call(n,o)}function s(t){var n=t.target;n.src!==a&&-1===e.inArray(n,l)&&(l.push(n),--r<=0&&(setTimeout(i),o.unbind(".imagesLoaded",s)))}var n=this,o=n.find("img").add(n.filter("img")),r=o.length,a="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==",l=[];return r||i(),o.bind("load.imagesLoaded error.imagesLoaded",s).each(function(){var t=this.src;this.src=a,this.src=t}),n};var x=function(e){t.console&&t.console.error(e)};e.fn.isotope=function(t,i){if("string"==typeof t){var s=Array.prototype.slice.call(arguments,1);this.each(function(){var i=e.data(this,"isotope");return i?e.isFunction(i[t])&&"_"!==t.charAt(0)?void i[t].apply(i,s):void x("no such method '"+t+"' for isotope instance"):void x("cannot call methods on isotope prior to initialization; attempted to call method '"+t+"'")})}else this.each(function(){var s=e.data(this,"isotope");s?(s.option(t),s._init(i)):e.data(this,"isotope",new e.Isotope(t,this,i))});return this}}(window,jQuery),function(t,e,i){function s(t){var e={},s=/^jQuery\d+$/;return i.each(t.attributes,function(t,i){i.specified&&!s.test(i.name)&&(e[i.name]=i.value)}),e}function n(t,e){var s=this,n=i(s);if(s.value==n.attr("placeholder")&&n.hasClass("placeholder"))if(n.data("placeholder-password")){if(n=n.hide().next().show().attr("id",n.removeAttr("id").data("placeholder-id")),t===!0)return n[0].value=e;n.focus()}else s.value="",n.removeClass("placeholder"),s==r()&&s.select()}function o(){var t,e=this,o=i(e),r=this.id;if(""==e.value){if("password"==e.type){if(!o.data("placeholder-textinput")){try{t=o.clone().attr({type:"text"})}catch(a){t=i("<input>").attr(i.extend(s(this),{type:"text"}))}t.removeAttr("name").data({"placeholder-password":o,"placeholder-id":r}).bind("focus.placeholder",n),o.data({"placeholder-textinput":t,"placeholder-id":r}).before(t)}o=o.removeAttr("id").hide().prev().attr("id",r).show()}o.addClass("placeholder"),o[0].value=o.attr("placeholder")}else o.removeClass("placeholder")}function r(){try{return e.activeElement}catch(t){}}var a,l,h="[object OperaMini]"==Object.prototype.toString.call(t.operamini),c="placeholder"in e.createElement("input")&&!h,u="placeholder"in e.createElement("textarea")&&!h,d=i.fn,f=i.valHooks,p=i.propHooks;c&&u?(l=d.placeholder=function(){return this},l.input=l.textarea=!0):(l=d.placeholder=function(){var t=this;return t.filter((c?"textarea":":input")+"[placeholder]").not(".placeholder").bind({"focus.placeholder":n,"blur.placeholder":o}).data("placeholder-enabled",!0).trigger("blur.placeholder"),t},l.input=c,l.textarea=u,a={get:function(t){var e=i(t),s=e.data("placeholder-password");return s?s[0].value:e.data("placeholder-enabled")&&e.hasClass("placeholder")?"":t.value},set:function(t,e){var s=i(t),a=s.data("placeholder-password");return a?a[0].value=e:s.data("placeholder-enabled")?(""==e?(t.value=e,t!=r()&&o.call(t)):s.hasClass("placeholder")?n.call(t,!0,e)||(t.value=e):t.value=e,s):t.value=e}},c||(f.input=a,p.value=a),u||(f.textarea=a,p.value=a),i(function(){i(e).delegate("form","submit.placeholder",function(){var t=i(".placeholder",this).each(n);setTimeout(function(){t.each(o)},10)})}),i(t).bind("beforeunload.placeholder",function(){i(".placeholder").each(function(){this.value=""})}))}(this,document,jQuery),jQuery(document).ready(function(t){t("input, textarea").placeholder()}),+function(t){"use strict";function e(i,s){var n,o=t.proxy(this.process,this);this.$element=t(t(i).is("body")?window:i),this.$body=t("body"),this.$scrollElement=this.$element.on("scroll.bs.scroll-spy.data-api",o),this.options=t.extend({},e.DEFAULTS,s),this.selector=(this.options.target||(n=t(i).attr("href"))&&n.replace(/.*(?=#[^\s]+$)/,"")||"")+" .x-nav li > a",this.offsets=t([]),this.targets=t([]),this.activeTarget=null,this.refresh(),this.process()}e.DEFAULTS={offset:10},e.prototype.refresh=function(){var e=this.$element[0]==window?"offset":"position";this.offsets=t([]),this.targets=t([]);{var i=this;this.$body.find(this.selector).map(function(){var s=t(this),n=s.data("target")||s.attr("href"),o=/^#\w/.test(n)&&t(n);return o&&o.length&&[[o[e]().top+(!t.isWindow(i.$scrollElement.get(0))&&i.$scrollElement.scrollTop()),n]]||null}).sort(function(t,e){return t[0]-e[0]}).each(function(){i.offsets.push(this[0]),i.targets.push(this[1])})}},e.prototype.process=function(){var t,e=this.$scrollElement.scrollTop()+this.options.offset,i=this.$scrollElement[0].scrollHeight||this.$body[0].scrollHeight,s=i-this.$scrollElement.height(),n=this.offsets,o=this.targets,r=this.activeTarget;if(e>=s)return r!=(t=o.last()[0])&&this.activate(t);for(t=n.length;t--;)r!=o[t]&&e>=n[t]&&(!n[t+1]||e<=n[t+1])&&this.activate(o[t])},e.prototype.activate=function(e){this.activeTarget=e,t(this.selector).parents(".current-menu-item").removeClass("current-menu-item");var i=this.selector+'[data-target="'+e+'"],'+this.selector+'[href="'+e+'"]',s=t(i).parents("li").addClass("current-menu-item");s.parent(".dropdown-menu").length&&(s=s.closest("li.dropdown").addClass("current-menu-item")),s.trigger("activate.bs.scrollspy")};var i=t.fn.scrollspy;t.fn.scrollspy=function(i){return this.each(function(){var s=t(this),n=s.data("bs.scrollspy"),o="object"==typeof i&&i;n||s.data("bs.scrollspy",n=new e(this,o)),"string"==typeof i&&n[i]()})},t.fn.scrollspy.Constructor=e,t.fn.scrollspy.noConflict=function(){return t.fn.scrollspy=i,this},t(window).on("load",function(){t('[data-spy="scroll"]').each(function(){var e=t(this);e.scrollspy(e.data())})})}(jQuery),jQuery(document).ready(function(t){function e(e,i,s){t("html, body").animate({scrollTop:t(e).offset().top-n-o+1},i,s)}var i=t("body"),s=i.outerHeight(),n=t("#wpadminbar").outerHeight(),o=t(".x-navbar-fixed-top-active .x-navbar").outerHeight(),r=location.href,a=r.indexOf("#"),l=r.substr(a);if(t(window).load(function(){-1!==a&&e(l,1,"linear")}),t('a[href*="#"]').on("touchstart click",function(i){if($href=t(this).attr("href"),notComments=-1===$href.indexOf("#comments"),notAccordion=-1===$href.indexOf("#collapse-"),notTabbedContent=-1===$href.indexOf("#tab-"),"#"!==$href&&notComments&&notAccordion&&notTabbedContent){var s=$href.split("#").pop(),n=t("#"+s);n.length>0&&(i.preventDefault(),e(n,850,"easeInOutExpo"))}}),i.hasClass("x-one-page-navigation-active")){i.scrollspy({target:".x-nav-wrap.desktop",offset:n+o}),t(window).resize(function(){i.scrollspy("refresh")});var h=0,c=setInterval(function(){h+=1;var t=i.outerHeight();t!==s&&i.scrollspy("refresh"),10===h&&clearInterval(c)},500)}}),jQuery(function(t){t(".x-slider-container.above .x-slider-scroll-bottom").on("touchstart click",function(e){e.preventDefault(),t("html, body").animate({scrollTop:t(".x-slider-container.above").outerHeight()},850,"easeInOutExpo")}),t(".x-slider-container.below .x-slider-scroll-bottom").on("touchstart click",function(e){e.preventDefault();var i=t(".masthead").outerHeight(),s=t(".x-navbar-fixed-top-active .x-navbar").outerHeight(),n=t(".x-slider-container.above").outerHeight(),o=t(".x-slider-container.below").outerHeight(),r=i+n+o-s;t("html, body").animate({scrollTop:r},850,"easeInOutExpo")})});