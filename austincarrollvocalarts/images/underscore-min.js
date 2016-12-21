(function(){var n=this,t=n._,r={},e=Array.prototype,i=Object.prototype,u=Function.prototype,o=e.push,a=e.slice,c=e.concat,l=i.toString,s=i.hasOwnProperty,f=e.forEach,p=e.map,h=e.reduce,d=e.reduceRight,v=e.filter,m=e.every,g=e.some,y=e.indexOf,b=e.lastIndexOf,x=Array.isArray,j=Object.keys,w=u.bind,_=function(n){return n instanceof _?n:this instanceof _?void(this._wrapped=n):new _(n)};"undefined"!=typeof exports?("undefined"!=typeof module&&module.exports&&(exports=module.exports=_),exports._=_):n._=_,_.VERSION="1.6.0";var A=_.each=_.forEach=function(n,t,e){if(null==n)return n;if(f&&n.forEach===f)n.forEach(t,e);else if(n.length===+n.length){for(var i=0,u=n.length;u>i;i++)if(t.call(e,n[i],i,n)===r)return}else for(var o=_.keys(n),i=0,u=o.length;u>i;i++)if(t.call(e,n[o[i]],o[i],n)===r)return;return n};_.map=_.collect=function(n,t,r){var e=[];return null==n?e:p&&n.map===p?n.map(t,r):(A(n,function(n,i,u){e.push(t.call(r,n,i,u))}),e)};var M="Reduce of empty array with no initial value";_.reduce=_.foldl=_.inject=function(n,t,r,e){var i=arguments.length>2;if(null==n&&(n=[]),h&&n.reduce===h)return e&&(t=_.bind(t,e)),i?n.reduce(t,r):n.reduce(t);if(A(n,function(n,u,o){i?r=t.call(e,r,n,u,o):(r=n,i=!0)}),!i)throw new TypeError(M);return r},_.reduceRight=_.foldr=function(n,t,r,e){var i=arguments.length>2;if(null==n&&(n=[]),d&&n.reduceRight===d)return e&&(t=_.bind(t,e)),i?n.reduceRight(t,r):n.reduceRight(t);var u=n.length;if(u!==+u){var o=_.keys(n);u=o.length}if(A(n,function(a,c,l){c=o?o[--u]:--u,i?r=t.call(e,r,n[c],c,l):(r=n[c],i=!0)}),!i)throw new TypeError(M);return r},_.find=_.detect=function(n,t,r){var e;return k(n,function(n,i,u){return t.call(r,n,i,u)?(e=n,!0):void 0}),e},_.filter=_.select=function(n,t,r){var e=[];return null==n?e:v&&n.filter===v?n.filter(t,r):(A(n,function(n,i,u){t.call(r,n,i,u)&&e.push(n)}),e)},_.reject=function(n,t,r){return _.filter(n,function(n,e,i){return!t.call(r,n,e,i)},r)},_.every=_.all=function(n,t,e){t||(t=_.identity);var i=!0;return null==n?i:m&&n.every===m?n.every(t,e):(A(n,function(n,u,o){return(i=i&&t.call(e,n,u,o))?void 0:r}),!!i)};var k=_.some=_.any=function(n,t,e){t||(t=_.identity);var i=!1;return null==n?i:g&&n.some===g?n.some(t,e):(A(n,function(n,u,o){return i||(i=t.call(e,n,u,o))?r:void 0}),!!i)};_.contains=_.include=function(n,t){return null==n?!1:y&&n.indexOf===y?n.indexOf(t)!=-1:k(n,function(n){return n===t})},_.invoke=function(n,t){var r=a.call(arguments,2),e=_.isFunction(t);return _.map(n,function(n){return(e?t:n[t]).apply(n,r)})},_.pluck=function(n,t){return _.map(n,_.property(t))},_.where=function(n,t){return _.filter(n,_.matches(t))},_.findWhere=function(n,t){return _.find(n,_.matches(t))},_.max=function(n,t,r){if(!t&&_.isArray(n)&&n[0]===+n[0]&&n.length<65535)return Math.max.apply(Math,n);var e=-1/0,i=-1/0;return A(n,function(n,u,o){var a=t?t.call(r,n,u,o):n;a>i&&(e=n,i=a)}),e},_.min=function(n,t,r){if(!t&&_.isArray(n)&&n[0]===+n[0]&&n.length<65535)return Math.min.apply(Math,n);var e=1/0,i=1/0;return A(n,function(n,u,o){var a=t?t.call(r,n,u,o):n;i>a&&(e=n,i=a)}),e},_.shuffle=function(n){var t,r=0,e=[];return A(n,function(n){t=_.random(r++),e[r-1]=e[t],e[t]=n}),e},_.sample=function(n,t,r){return null==t||r?(n.length!==+n.length&&(n=_.values(n)),n[_.random(n.length-1)]):_.shuffle(n).slice(0,Math.max(0,t))};var O=function(n){return null==n?_.identity:_.isFunction(n)?n:_.property(n)};_.sortBy=function(n,t,r){return t=O(t),_.pluck(_.map(n,function(n,e,i){return{value:n,index:e,criteria:t.call(r,n,e,i)}}).sort(function(n,t){var r=n.criteria,e=t.criteria;if(r!==e){if(r>e||void 0===r)return 1;if(e>r||void 0===e)return-1}return n.index-t.index}),"value")};var E=function(n){return function(t,r,e){var i={};return r=O(r),A(t,function(u,o){var a=r.call(e,u,o,t);n(i,a,u)}),i}};_.groupBy=E(function(n,t,r){_.has(n,t)?n[t].push(r):n[t]=[r]}),_.indexBy=E(function(n,t,r){n[t]=r}),_.countBy=E(function(n,t){_.has(n,t)?n[t]++:n[t]=1}),_.sortedIndex=function(n,t,r,e){r=O(r);for(var i=r.call(e,t),u=0,o=n.length;o>u;){var a=u+o>>>1;r.call(e,n[a])<i?u=a+1:o=a}return u},_.toArray=function(n){return n?_.isArray(n)?a.call(n):n.length===+n.length?_.map(n,_.identity):_.values(n):[]},_.size=function(n){return null==n?0:n.length===+n.length?n.length:_.keys(n).length},_.first=_.head=_.take=function(n,t,r){return null==n?void 0:null==t||r?n[0]:0>t?[]:a.call(n,0,t)},_.initial=function(n,t,r){return a.call(n,0,n.length-(null==t||r?1:t))},_.last=function(n,t,r){return null==n?void 0:null==t||r?n[n.length-1]:a.call(n,Math.max(n.length-t,0))},_.rest=_.tail=_.drop=function(n,t,r){return a.call(n,null==t||r?1:t)},_.compact=function(n){return _.filter(n,_.identity)};var F=function(n,t,r){return t&&_.every(n,_.isArray)?c.apply(r,n):(A(n,function(n){_.isArray(n)||_.isArguments(n)?t?o.apply(r,n):F(n,t,r):r.push(n)}),r)};_.flatten=function(n,t){return F(n,t,[])},_.without=function(n){return _.difference(n,a.call(arguments,1))},_.partition=function(n,t){var r=[],e=[];return A(n,function(n){(t(n)?r:e).push(n)}),[r,e]},_.uniq=_.unique=function(n,t,r,e){_.isFunction(t)&&(e=r,r=t,t=!1);var i=r?_.map(n,r,e):n,u=[],o=[];return A(i,function(r,e){(t?e&&o[o.length-1]===r:_.contains(o,r))||(o.push(r),u.push(n[e]))}),u},_.union=function(){return _.uniq(_.flatten(arguments,!0))},_.intersection=function(n){var t=a.call(arguments,1);return _.filter(_.uniq(n),function(n){return _.every(t,function(t){return _.contains(t,n)})})},_.difference=function(n){var t=c.apply(e,a.call(arguments,1));return _.filter(n,function(n){return!_.contains(t,n)})},_.zip=function(){for(var n=_.max(_.pluck(arguments,"length").concat(0)),t=new Array(n),r=0;n>r;r++)t[r]=_.pluck(arguments,""+r);return t},_.object=function(n,t){if(null==n)return{};for(var r={},e=0,i=n.length;i>e;e++)t?r[n[e]]=t[e]:r[n[e][0]]=n[e][1];return r},_.indexOf=function(n,t,r){if(null==n)return-1;var e=0,i=n.length;if(r){if("number"!=typeof r)return e=_.sortedIndex(n,t),n[e]===t?e:-1;e=0>r?Math.max(0,i+r):r}if(y&&n.indexOf===y)return n.indexOf(t,r);for(;i>e;e++)if(n[e]===t)return e;return-1},_.lastIndexOf=function(n,t,r){if(null==n)return-1;var e=null!=r;if(b&&n.lastIndexOf===b)return e?n.lastIndexOf(t,r):n.lastIndexOf(t);for(var i=e?r:n.length;i--;)if(n[i]===t)return i;return-1},_.range=function(n,t,r){arguments.length<=1&&(t=n||0,n=0),r=arguments[2]||1;for(var e=Math.max(Math.ceil((t-n)/r),0),i=0,u=new Array(e);e>i;)u[i++]=n,n+=r;return u};var I=function(){};_.bind=function(n,t){var r,e;if(w&&n.bind===w)return w.apply(n,a.call(arguments,1));if(!_.isFunction(n))throw new TypeError;return r=a.call(arguments,2),e=function(){if(!(this instanceof e))return n.apply(t,r.concat(a.call(arguments)));I.prototype=n.prototype;var i=new I;I.prototype=null;var u=n.apply(i,r.concat(a.call(arguments)));return Object(u)===u?u:i}},_.partial=function(n){var t=a.call(arguments,1);return function(){for(var r=0,e=t.slice(),i=0,u=e.length;u>i;i++)e[i]===_&&(e[i]=arguments[r++]);for(;r<arguments.length;)e.push(arguments[r++]);return n.apply(this,e)}},_.bindAll=function(n){var t=a.call(arguments,1);if(0===t.length)throw new Error("bindAll must be passed function names");return A(t,function(t){n[t]=_.bind(n[t],n)}),n},_.memoize=function(n,t){var r={};return t||(t=_.identity),function(){var e=t.apply(this,arguments);return _.has(r,e)?r[e]:r[e]=n.apply(this,arguments)}},_.delay=function(n,t){var r=a.call(arguments,2);return setTimeout(function(){return n.apply(null,r)},t)},_.defer=function(n){return _.delay.apply(_,[n,1].concat(a.call(arguments,1)))},_.throttle=function(n,t,r){var e,i,u,o=null,a=0;r||(r={});var c=function(){a=r.leading===!1?0:_.now(),o=null,u=n.apply(e,i),e=i=null};return function(){var l=_.now();a||r.leading!==!1||(a=l);var s=t-(l-a);return e=this,i=arguments,0>=s?(clearTimeout(o),o=null,a=l,u=n.apply(e,i),e=i=null):o||r.trailing===!1||(o=setTimeout(c,s)),u}},_.debounce=function(n,t,r){var e,i,u,o,a,c=function(){var l=_.now()-o;t>l?e=setTimeout(c,t-l):(e=null,r||(a=n.apply(u,i),u=i=null))};return function(){u=this,i=arguments,o=_.now();var l=r&&!e;return e||(e=setTimeout(c,t)),l&&(a=n.apply(u,i),u=i=null),a}},_.once=function(n){var t,r=!1;return function(){return r?t:(r=!0,t=n.apply(this,arguments),n=null,t)}},_.wrap=function(n,t){return _.partial(t,n)},_.compose=function(){var n=arguments;return function(){for(var t=arguments,r=n.length-1;r>=0;r--)t=[n[r].apply(this,t)];return t[0]}},_.after=function(n,t){return function(){return--n<1?t.apply(this,arguments):void 0}},_.keys=function(n){if(!_.isObject(n))return[];if(j)return j(n);var t=[];for(var r in n)_.has(n,r)&&t.push(r);return t},_.values=function(n){for(var t=_.keys(n),r=t.length,e=new Array(r),i=0;r>i;i++)e[i]=n[t[i]];return e},_.pairs=function(n){for(var t=_.keys(n),r=t.length,e=new Array(r),i=0;r>i;i++)e[i]=[t[i],n[t[i]]];return e},_.invert=function(n){for(var t={},r=_.keys(n),e=0,i=r.length;i>e;e++)t[n[r[e]]]=r[e];return t},_.functions=_.methods=function(n){var t=[];for(var r in n)_.isFunction(n[r])&&t.push(r);return t.sort()},_.extend=function(n){return A(a.call(arguments,1),function(t){if(t)for(var r in t)n[r]=t[r]}),n},_.pick=function(n){var t={},r=c.apply(e,a.call(arguments,1));return A(r,function(r){r in n&&(t[r]=n[r])}),t},_.omit=function(n){var t={},r=c.apply(e,a.call(arguments,1));for(var i in n)_.contains(r,i)||(t[i]=n[i]);return t},_.defaults=function(n){return A(a.call(arguments,1),function(t){if(t)for(var r in t)n[r]===void 0&&(n[r]=t[r])}),n},_.clone=function(n){return _.isObject(n)?_.isArray(n)?n.slice():_.extend({},n):n},_.tap=function(n,t){return t(n),n};var S=function(n,t,r,e){if(n===t)return 0!==n||1/n==1/t;if(null==n||null==t)return n===t;n instanceof _&&(n=n._wrapped),t instanceof _&&(t=t._wrapped);var i=l.call(n);if(i!=l.call(t))return!1;switch(i){case"[object String]":return n==String(t);case"[object Number]":return n!=+n?t!=+t:0==n?1/n==1/t:n==+t;case"[object Date]":case"[object Boolean]":return+n==+t;case"[object RegExp]":return n.source==t.source&&n.global==t.global&&n.multiline==t.multiline&&n.ignoreCase==t.ignoreCase}if("object"!=typeof n||"object"!=typeof t)return!1;for(var u=r.length;u--;)if(r[u]==n)return e[u]==t;var o=n.constructor,a=t.constructor;if(o!==a&&!(_.isFunction(o)&&o instanceof o&&_.isFunction(a)&&a instanceof a)&&"constructor"in n&&"constructor"in t)return!1;r.push(n),e.push(t);var c=0,s=!0;if("[object Array]"==i){if(c=n.length,s=c==t.length)for(;c--&&(s=S(n[c],t[c],r,e)););}else{for(var f in n)if(_.has(n,f)&&(c++,!(s=_.has(t,f)&&S(n[f],t[f],r,e))))break;if(s){for(f in t)if(_.has(t,f)&&!c--)break;s=!c}}return r.pop(),e.pop(),s};_.isEqual=function(n,t){return S(n,t,[],[])},_.isEmpty=function(n){if(null==n)return!0;if(_.isArray(n)||_.isString(n))return 0===n.length;for(var t in n)if(_.has(n,t))return!1;return!0},_.isElement=function(n){return!(!n||1!==n.nodeType)},_.isArray=x||function(n){return"[object Array]"==l.call(n)},_.isObject=function(n){return n===Object(n)},A(["Arguments","Function","String","Number","Date","RegExp"],function(n){_["is"+n]=function(t){return l.call(t)=="[object "+n+"]"}}),_.isArguments(arguments)||(_.isArguments=function(n){return!(!n||!_.has(n,"callee"))}),"function"!=typeof/./&&(_.isFunction=function(n){return"function"==typeof n}),_.isFinite=function(n){return isFinite(n)&&!isNaN(parseFloat(n))},_.isNaN=function(n){return _.isNumber(n)&&n!=+n},_.isBoolean=function(n){return n===!0||n===!1||"[object Boolean]"==l.call(n)},_.isNull=function(n){return null===n},_.isUndefined=function(n){return void 0===n},_.has=function(n,t){return s.call(n,t)},_.noConflict=function(){return n._=t,this},_.identity=function(n){return n},_.constant=function(n){return function(){return n}},_.property=function(n){return function(t){return t[n]}},_.matches=function(n){return function(t){if(t===n)return!0;for(var r in n)if(n[r]!==t[r])return!1;return!0}},_.times=function(n,t,r){for(var e=Array(Math.max(0,n)),i=0;n>i;i++)e[i]=t.call(r,i);return e},_.random=function(n,t){return null==t&&(t=n,n=0),n+Math.floor(Math.random()*(t-n+1))},_.now=Date.now||function(){return(new Date).getTime()};var R={escape:{"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#x27;"}};R.unescape=_.invert(R.escape);var N={escape:new RegExp("["+_.keys(R.escape).join("")+"]","g"),unescape:new RegExp("("+_.keys(R.unescape).join("|")+")","g")};_.each(["escape","unescape"],function(n){_[n]=function(t){return null==t?"":(""+t).replace(N[n],function(t){return R[n][t]})}}),_.result=function(n,t){if(null==n)return void 0;var r=n[t];return _.isFunction(r)?r.call(n):r},_.mixin=function(n){A(_.functions(n),function(t){var r=_[t]=n[t];_.prototype[t]=function(){var n=[this._wrapped];return o.apply(n,arguments),B.call(this,r.apply(_,n))}})};var z=0;_.uniqueId=function(n){var t=++z+"";return n?n+t:t},_.templateSettings={evaluate:/<%([\s\S]+?)%>/g,interpolate:/<%=([\s\S]+?)%>/g,escape:/<%-([\s\S]+?)%>/g};var T=/(.)^/,D={"'":"'","\\":"\\","\r":"r","\n":"n","	":"t","\u2028":"u2028","\u2029":"u2029"},q=/\\|'|\r|\n|\t|\u2028|\u2029/g;_.template=function(n,t,r){var e;r=_.defaults({},r,_.templateSettings);var i=new RegExp([(r.escape||T).source,(r.interpolate||T).source,(r.evaluate||T).source].join("|")+"|$","g"),u=0,o="__p+='";n.replace(i,function(t,r,e,i,a){return o+=n.slice(u,a).replace(q,function(n){return"\\"+D[n]}),r&&(o+="'+\n((__t=("+r+"))==null?'':_.escape(__t))+\n'"),e&&(o+="'+\n((__t=("+e+"))==null?'':__t)+\n'"),i&&(o+="';\n"+i+"\n__p+='"),u=a+t.length,t}),o+="';\n",r.variable||(o="with(obj||{}){\n"+o+"}\n"),o="var __t,__p='',__j=Array.prototype.join,print=function(){__p+=__j.call(arguments,'');};\n"+o+"return __p;\n";try{e=new Function(r.variable||"obj","_",o)}catch(a){throw a.source=o,a}if(t)return e(t,_);var c=function(n){return e.call(this,n,_)};return c.source="function("+(r.variable||"obj")+"){\n"+o+"}",c},_.chain=function(n){return _(n).chain()};var B=function(n){return this._chain?_(n).chain():n};_.mixin(_),A(["pop","push","reverse","shift","sort","splice","unshift"],function(n){var t=e[n];_.prototype[n]=function(){var r=this._wrapped;return t.apply(r,arguments),"shift"!=n&&"splice"!=n||0!==r.length||delete r[0],B.call(this,r)}}),A(["concat","join","slice"],function(n){var t=e[n];_.prototype[n]=function(){return B.call(this,t.apply(this._wrapped,arguments))}}),_.extend(_.prototype,{chain:function(){return this._chain=!0,this},value:function(){return this._wrapped}}),"function"==typeof define&&define.amd&&define("underscore",[],function(){return _})}).call(this);