/*
Copyright (c) 2008, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.net/yui/license.txt
version: 2.5.1
*/
if(typeof YAHOO=="undefined"||!YAHOO){var YAHOO={};}YAHOO.namespace=function(){var A=arguments,E=null,C,B,D;for(C=0;C<A.length;C=C+1){D=A[C].split(".");E=YAHOO;for(B=(D[0]=="YAHOO")?1:0;B<D.length;B=B+1){E[D[B]]=E[D[B]]||{};E=E[D[B]];}}return E;};YAHOO.log=function(D,A,C){var B=YAHOO.widget.Logger;if(B&&B.log){return B.log(D,A,C);}else{return false;}};YAHOO.register=function(A,E,D){var I=YAHOO.env.modules;if(!I[A]){I[A]={versions:[],builds:[]};}var B=I[A],H=D.version,G=D.build,F=YAHOO.env.listeners;B.name=A;B.version=H;B.build=G;B.versions.push(H);B.builds.push(G);B.mainClass=E;for(var C=0;C<F.length;C=C+1){F[C](B);}if(E){E.VERSION=H;E.BUILD=G;}else{YAHOO.log("mainClass is undefined for module "+A,"warn");}};YAHOO.env=YAHOO.env||{modules:[],listeners:[]};YAHOO.env.getVersion=function(A){return YAHOO.env.modules[A]||null;};YAHOO.env.ua=function(){var C={ie:0,opera:0,gecko:0,webkit:0,mobile:null,air:0};var B=navigator.userAgent,A;if((/KHTML/).test(B)){C.webkit=1;}A=B.match(/AppleWebKit\/([^\s]*)/);if(A&&A[1]){C.webkit=parseFloat(A[1]);if(/ Mobile\//.test(B)){C.mobile="Apple";}else{A=B.match(/NokiaN[^\/]*/);if(A){C.mobile=A[0];}}A=B.match(/AdobeAIR\/([^\s]*)/);if(A){C.air=A[0];}}if(!C.webkit){A=B.match(/Opera[\s\/]([^\s]*)/);if(A&&A[1]){C.opera=parseFloat(A[1]);A=B.match(/Opera Mini[^;]*/);if(A){C.mobile=A[0];}}else{A=B.match(/MSIE\s([^;]*)/);if(A&&A[1]){C.ie=parseFloat(A[1]);}else{A=B.match(/Gecko\/([^\s]*)/);if(A){C.gecko=1;A=B.match(/rv:([^\s\)]*)/);if(A&&A[1]){C.gecko=parseFloat(A[1]);}}}}}return C;}();(function(){YAHOO.namespace("util","widget","example");if("undefined"!==typeof YAHOO_config){var B=YAHOO_config.listener,A=YAHOO.env.listeners,D=true,C;if(B){for(C=0;C<A.length;C=C+1){if(A[C]==B){D=false;break;}}if(D){A.push(B);}}}})();YAHOO.lang=YAHOO.lang||{isArray:function(B){if(B){var A=YAHOO.lang;return A.isNumber(B.length)&&A.isFunction(B.splice);}return false;},isBoolean:function(A){return typeof A==="boolean";},isFunction:function(A){return typeof A==="function";},isNull:function(A){return A===null;},isNumber:function(A){return typeof A==="number"&&isFinite(A);},isObject:function(A){return(A&&(typeof A==="object"||YAHOO.lang.isFunction(A)))||false;},isString:function(A){return typeof A==="string";},isUndefined:function(A){return typeof A==="undefined";},hasOwnProperty:function(A,B){if(Object.prototype.hasOwnProperty){return A.hasOwnProperty(B);}return !YAHOO.lang.isUndefined(A[B])&&A.constructor.prototype[B]!==A[B];},_IEEnumFix:function(C,B){if(YAHOO.env.ua.ie){var E=["toString","valueOf"],A;for(A=0;A<E.length;A=A+1){var F=E[A],D=B[F];if(YAHOO.lang.isFunction(D)&&D!=Object.prototype[F]){C[F]=D;}}}},extend:function(D,E,C){if(!E||!D){throw new Error("YAHOO.lang.extend failed, please check that "+"all dependencies are included.");}var B=function(){};B.prototype=E.prototype;D.prototype=new B();D.prototype.constructor=D;D.superclass=E.prototype;if(E.prototype.constructor==Object.prototype.constructor){E.prototype.constructor=E;}if(C){for(var A in C){D.prototype[A]=C[A];}YAHOO.lang._IEEnumFix(D.prototype,C);}},augmentObject:function(E,D){if(!D||!E){throw new Error("Absorb failed, verify dependencies.");}var A=arguments,C,F,B=A[2];if(B&&B!==true){for(C=2;C<A.length;C=C+1){E[A[C]]=D[A[C]];}}else{for(F in D){if(B||!E[F]){E[F]=D[F];}}YAHOO.lang._IEEnumFix(E,D);}},augmentProto:function(D,C){if(!C||!D){throw new Error("Augment failed, verify dependencies.");}var A=[D.prototype,C.prototype];for(var B=2;B<arguments.length;B=B+1){A.push(arguments[B]);}YAHOO.lang.augmentObject.apply(this,A);},dump:function(A,G){var C=YAHOO.lang,D,F,I=[],J="{...}",B="f(){...}",H=", ",E=" => ";if(!C.isObject(A)){return A+"";}else{if(A instanceof Date||("nodeType" in A&&"tagName" in A)){return A;}else{if(C.isFunction(A)){return B;}}}G=(C.isNumber(G))?G:3;if(C.isArray(A)){I.push("[");for(D=0,F=A.length;D<F;D=D+1){if(C.isObject(A[D])){I.push((G>0)?C.dump(A[D],G-1):J);}else{I.push(A[D]);}I.push(H);}if(I.length>1){I.pop();}I.push("]");}else{I.push("{");for(D in A){if(C.hasOwnProperty(A,D)){I.push(D+E);if(C.isObject(A[D])){I.push((G>0)?C.dump(A[D],G-1):J);}else{I.push(A[D]);}I.push(H);}}if(I.length>1){I.pop();}I.push("}");}return I.join("");},substitute:function(Q,B,J){var G,F,E,M,N,P,D=YAHOO.lang,L=[],C,H="dump",K=" ",A="{",O="}";for(;;){G=Q.lastIndexOf(A);if(G<0){break;}F=Q.indexOf(O,G);if(G+1>=F){break;}C=Q.substring(G+1,F);M=C;P=null;E=M.indexOf(K);if(E>-1){P=M.substring(E+1);M=M.substring(0,E);}N=B[M];if(J){N=J(M,N,P);}if(D.isObject(N)){if(D.isArray(N)){N=D.dump(N,parseInt(P,10));}else{P=P||"";var I=P.indexOf(H);if(I>-1){P=P.substring(4);}if(N.toString===Object.prototype.toString||I>-1){N=D.dump(N,parseInt(P,10));}else{N=N.toString();}}}else{if(!D.isString(N)&&!D.isNumber(N)){N="~-"+L.length+"-~";L[L.length]=C;}}Q=Q.substring(0,G)+N+Q.substring(F+1);}for(G=L.length-1;G>=0;G=G-1){Q=Q.replace(new RegExp("~-"+G+"-~"),"{"+L[G]+"}","g");}return Q;},trim:function(A){try{return A.replace(/^\s+|\s+$/g,"");}catch(B){return A;}},merge:function(){var D={},B=arguments;for(var C=0,A=B.length;C<A;C=C+1){YAHOO.lang.augmentObject(D,B[C],true);}return D;},later:function(H,B,I,D,E){H=H||0;B=B||{};var C=I,G=D,F,A;if(YAHOO.lang.isString(I)){C=B[I];}if(!C){throw new TypeError("method undefined");}if(!YAHOO.lang.isArray(G)){G=[D];}F=function(){C.apply(B,G);};A=(E)?setInterval(F,H):setTimeout(F,H);return{interval:E,cancel:function(){if(this.interval){clearInterval(A);}else{clearTimeout(A);}}};},isValue:function(B){var A=YAHOO.lang;return(A.isObject(B)||A.isString(B)||A.isNumber(B)||A.isBoolean(B));}};YAHOO.util.Lang=YAHOO.lang;YAHOO.lang.augment=YAHOO.lang.augmentProto;YAHOO.augment=YAHOO.lang.augmentProto;YAHOO.extend=YAHOO.lang.extend;YAHOO.register("yahoo",YAHOO,{version:"2.5.1",build:"984"});
(function(){var T=function(){};var E=YAHOO.util;var U=/^(?:([-]?\d*)(n){1}|(odd|even)$)*([-+]?\d*)$/;T.prototype={document:window.document,attrAliases:{"for":"htmlFor"},shorthand:{"\\#(-?[_a-z]+[-\\w]*)":"[id=$1]","\\.(-?[_a-z]+[-\\w]*)":"[class~=$1]"},operators:{"=":function(W,X){return W===X;},"!=":function(W,X){return W!==X;},"~=":function(W,Y){var X=" ";return(X+W+X).indexOf((X+Y+X))>-1;},"|=":function(W,X){return G("^"+X+"[-]?").test(W);},"^=":function(W,X){return W.indexOf(X)===0;},"$=":function(W,X){return W.lastIndexOf(X)===W.length-X.length;},"*=":function(W,X){return W.indexOf(X)>-1;},"":function(W,X){return W;}},pseudos:{"root":function(W){return W===W.ownerDocument.documentElement;},"nth-child":function(W,X){return R(W,X);},"nth-last-child":function(W,X){return R(W,X,null,true);},"nth-of-type":function(W,X){return R(W,X,W.tagName);},"nth-last-of-type":function(W,X){return R(W,X,W.tagName,true);},"first-child":function(W){return F(W.parentNode)[0]===W;},"last-child":function(X){var W=F(X.parentNode);return W[W.length-1]===X;},"first-of-type":function(W,X){return F(W.parentNode,W.tagName.toLowerCase())[0];},"last-of-type":function(X,Y){var W=F(X.parentNode,X.tagName.toLowerCase());return W[W.length-1];},"only-child":function(X){var W=F(X.parentNode);return W.length===1&&W[0]===X;},"only-of-type":function(W){return F(W.parentNode,W.tagName.toLowerCase()).length===1;},"empty":function(W){return W.childNodes.length===0;},"not":function(W,X){return !T.test(W,X);},"contains":function(W,Y){var X=W.innerText||W.textContent||"";return X.indexOf(Y)>-1;},"checked":function(W){return W.checked===true;}},test:function(a,Y){a=T.document.getElementById(a)||a;if(!a){return false;}var X=Y?Y.split(","):[];if(X.length){for(var Z=0,W=X.length;Z<W;++Z){if(V(a,X[Z])){return true;}}return false;}return V(a,Y);},filter:function(Z,Y){Z=Z||[];var b,X=[],c=C(Y);if(!Z.item){for(var a=0,W=Z.length;a<W;++a){if(!Z[a].tagName){b=T.document.getElementById(Z[a]);if(b){Z[a]=b;}else{}}}}X=Q(Z,C(Y)[0]);B();return X;},query:function(X,Y,Z){var W=H(X,Y,Z);return W;}};var H=function(c,h,j,a){var l=(j)?null:[];if(!c){return l;}var Y=c.split(",");if(Y.length>1){var k;for(var d=0,e=Y.length;d<e;++d){k=arguments.callee(Y[d],h,j,true);l=j?k:l.concat(k);}I();return l;}if(h&&!h.nodeName){h=T.document.getElementById(h);if(!h){return l;}}h=h||T.document;var g=C(c);var f=g[N(g)],W=[],Z,X,b=g.pop()||{};if(f){X=P(f.attributes);}if(X){if(X===b.id){W=[T.document.getElementById(X)]||h;}else{Z=T.document.getElementById(X);if(h===T.document||L(Z,h)){if(Z&&V(Z,null,f)){h=Z;}}else{return l;}}}if(h&&!W.length){W=h.getElementsByTagName(b.tag);}if(W.length){l=Q(W,b,j,a);}B();return l;};var L=function(){if(document.documentElement.contains&&!YAHOO.env.ua.webkit<422){return function(X,W){return W.contains(X);};}else{if(document.documentElement.compareDocumentPosition){return function(X,W){return !!(W.compareDocumentPosition(X)&16);};}else{return function(Y,X){var W=Y.parentNode;while(W){if(Y===W){return true;}W=W.parentNode;}return false;};}}}();var Q=function(Z,b,c,Y){var X=c?null:[];for(var a=0,W=Z.length;a<W;a++){if(!V(Z[a],"",b,Y)){continue;}if(c){return Z[a];}if(Y){if(Z[a]._found){continue;}Z[a]._found=true;M[M.length]=Z[a];}X[X.length]=Z[a];}return X;};var V=function(c,X,a,Y){a=a||C(X).pop()||{};if(!c.tagName||(a.tag!=="*"&&c.tagName.toUpperCase()!==a.tag)||(Y&&c._found)){return false;}if(a.attributes.length){var b;for(var Z=0,W=a.attributes.length;Z<W;++Z){b=c.getAttribute(a.attributes[Z][0],2);if(b===undefined){return false;}if(T.operators[a.attributes[Z][1]]&&!T.operators[a.attributes[Z][1]](b,a.attributes[Z][2])){return false;}}}if(a.pseudos.length){for(var Z=0,W=a.pseudos.length;Z<W;++Z){if(T.pseudos[a.pseudos[Z][0]]&&!T.pseudos[a.pseudos[Z][0]](c,a.pseudos[Z][1])){return false;}}}return(a.previous&&a.previous.combinator!==",")?O[a.previous.combinator](c,a):true;};var M=[];var K=[];var S={};var I=function(){for(var X=0,W=M.length;X<W;++X){try{delete M[X]._found;}catch(Y){M[X].removeAttribute("_found");}}M=[];};var B=function(){if(!document.documentElement.children){return function(){for(var X=0,W=K.length;X<W;++X){delete K[X]._children;}K=[];};}else{return function(){};}}();var G=function(X,W){W=W||"";if(!S[X+W]){S[X+W]=new RegExp(X,W);}return S[X+W];};var O={" ":function(X,W){while(X=X.parentNode){if(V(X,"",W.previous)){return true;}}return false;},">":function(X,W){return V(X.parentNode,null,W.previous);},"+":function(Y,X){var W=Y.previousSibling;while(W&&W.nodeType!==1){W=W.previousSibling;}if(W&&V(W,null,X.previous)){return true;}return false;},"~":function(Y,X){var W=Y.previousSibling;while(W){if(W.nodeType===1&&V(W,null,X.previous)){return true;}W=W.previousSibling;}return false;}};var F=function(){if(document.documentElement.children){return function(X,W){return(W)?X.children.tags(W):X.children||[];};}else{return function(a,X){if(a._children){return a._children;}var Z=[],b=a.childNodes;for(var Y=0,W=b.length;Y<W;++Y){if(b[Y].tagName){if(!X||b[Y].tagName.toLowerCase()===X){Z[Z.length]=b[Y];}}}a._children=Z;K[K.length]=a;return Z;};}}();var R=function(X,h,k,c){if(k){k=k.toLowerCase();}U.test(h);var g=parseInt(RegExp.$1,10),W=RegExp.$2,d=RegExp.$3,e=parseInt(RegExp.$4,10)||0,j=[];var f=F(X.parentNode,k);if(d){g=2;op="+";W="n";e=(d==="odd")?1:0;}else{if(isNaN(g)){g=(W)?1:0;}}if(g===0){if(c){e=f.length-e+1;}if(f[e-1]===X){return true;}else{return false;}}else{if(g<0){c=!!c;g=Math.abs(g);}}if(!c){for(var Y=e-1,Z=f.length;Y<Z;Y+=g){if(Y>=0&&f[Y]===X){return true;}}}else{for(var Y=f.length-e,Z=f.length;Y>=0;Y-=g){if(Y<Z&&f[Y]===X){return true;}}}return false;};var P=function(X){for(var Y=0,W=X.length;Y<W;++Y){if(X[Y][0]=="id"&&X[Y][1]==="="){return X[Y][2];}}};var N=function(Y){for(var X=0,W=Y.length;X<W;++X){if(P(Y[X].attributes)){return X;}}return -1;};var D={tag:/^((?:-?[_a-z]+[\w-]*)|\*)/i,attributes:/^\[([a-z]+\w*)+([~\|\^\$\*!=]=?)?['"]?([^'"\]]*)['"]?\]*/i,pseudos:/^:([-\w]+)(?:\(['"]?(.+)['"]?\))*/i,combinator:/^\s*([>+~]|\s)\s*/};
var C=function(W){var Y={},b=[],c,a=false,X;W=A(W);do{a=false;for(var Z in D){if(!YAHOO.lang.hasOwnProperty(D,Z)){continue;}if(Z!="tag"&&Z!="combinator"){Y[Z]=Y[Z]||[];}if(X=D[Z].exec(W)){a=true;if(Z!="tag"&&Z!="combinator"){if(Z==="attributes"&&X[1]==="id"){Y.id=X[3];}Y[Z].push(X.slice(1));}else{Y[Z]=X[1];}W=W.replace(X[0],"");if(Z==="combinator"||!W.length){Y.attributes=J(Y.attributes);Y.pseudos=Y.pseudos||[];Y.tag=Y.tag?Y.tag.toUpperCase():"*";b.push(Y);Y={previous:Y};}}}}while(a);return b;};var J=function(X){var Y=T.attrAliases;X=X||[];for(var Z=0,W=X.length;Z<W;++Z){if(Y[X[Z][0]]){X[Z][0]=Y[X[Z][0]];}if(!X[Z][1]){X[Z][1]="";}}return X;};var A=function(X){var Y=T.shorthand;var Z=X.match(D.attributes);if(Z){X=X.replace(D.attributes,"REPLACED_ATTRIBUTE");}for(var b in Y){if(!YAHOO.lang.hasOwnProperty(Y,b)){continue;}X=X.replace(G(b,"gi"),Y[b]);}if(Z){for(var a=0,W=Z.length;a<W;++a){X=X.replace("REPLACED_ATTRIBUTE",Z[a]);}}return X;};if(YAHOO.env.ua.ie){T.prototype.attrAliases["class"]="className";}T=new T();T.patterns=D;E.Selector=T;})();YAHOO.register("selector",YAHOO.util.Selector,{version:"2.5.1",build:"984"});
YAHOO.namespace("lang");YAHOO.lang.JSON={_ESCAPES:/\\["\\\/bfnrtu]/g,_VALUES:/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,_BRACKETS:/(?:^|:|,)(?:\s*\[)+/g,_INVALID:/^[\],:{}\s]*$/,_SPECIAL_CHARS:/["\\\x00-\x1f\x7f-\x9f]/g,_PARSE_DATE:/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z$/,_CHARS:{"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},_applyFilter:function(C,B){var A=function(E,D){var F,G;if(D&&typeof D==="object"){for(F in D){if(YAHOO.lang.hasOwnProperty(D,F)){G=A(F,D[F]);if(G===undefined){delete D[F];}else{D[F]=G;}}}}return B(E,D);};if(YAHOO.lang.isFunction(B)){A("",C);}return C;},isValid:function(A){if(!YAHOO.lang.isString(A)){return false;}return this._INVALID.test(A.replace(this._ESCAPES,"@").replace(this._VALUES,"]").replace(this._BRACKETS,""));},dateToString:function(B){function A(C){return C<10?"0"+C:C;}return'"'+B.getUTCFullYear()+"-"+A(B.getUTCMonth()+1)+"-"+A(B.getUTCDate())+"T"+A(B.getUTCHours())+":"+A(B.getUTCMinutes())+":"+A(B.getUTCSeconds())+'Z"';},stringToDate:function(B){if(this._PARSE_DATE.test(B)){var A=new Date();A.setUTCFullYear(RegExp.$1,(RegExp.$2|0)-1,RegExp.$3);A.setUTCHours(RegExp.$4,RegExp.$5,RegExp.$6);return A;}},parse:function(s,filter){if(this.isValid(s)){return this._applyFilter(eval("("+s+")"),filter);}throw new SyntaxError("parseJSON");},stringify:function(C,K,F){var E=YAHOO.lang,H=E.JSON,D=H._CHARS,A=this._SPECIAL_CHARS,B=[];var I=function(N){if(!D[N]){var J=N.charCodeAt();D[N]="\\u00"+Math.floor(J/16).toString(16)+(J%16).toString(16);}return D[N];};var M=function(J){return'"'+J.replace(A,I)+'"';};var L=H.dateToString;var G=function(J,T,R){var W=typeof J,P,Q,O,N,U,V,S;if(W==="string"){return M(J);}if(W==="boolean"||J instanceof Boolean){return String(J);}if(W==="number"||J instanceof Number){return isFinite(J)?String(J):"null";}if(J instanceof Date){return L(J);}if(E.isArray(J)){for(P=B.length-1;P>=0;--P){if(B[P]===J){return"null";}}B[B.length]=J;S=[];if(R>0){for(P=J.length-1;P>=0;--P){S[P]=G(J[P],T,R-1)||"null";}}B.pop();return"["+S.join(",")+"]";}if(W==="object"){if(!J){return"null";}for(P=B.length-1;P>=0;--P){if(B[P]===J){return"null";}}B[B.length]=J;S=[];if(R>0){if(T){for(P=0,O=0,Q=T.length;P<Q;++P){if(typeof T[P]==="string"){U=G(J[T[P]],T,R-1);if(U){S[O++]=M(T[P])+":"+U;}}}}else{O=0;for(N in J){if(typeof N==="string"&&E.hasOwnProperty(J,N)){U=G(J[N],T,R-1);if(U){S[O++]=M(N)+":"+U;}}}}}B.pop();return"{"+S.join(",")+"}";}return undefined;};F=F>=0?F:1/0;return G(C,K,F);}};YAHOO.register("json",YAHOO.lang.JSON,{version:"2.5.1",build:"984"});
YAHOO.util.CustomEvent=function(D,B,C,A){this.type=D;this.scope=B||window;this.silent=C;this.signature=A||YAHOO.util.CustomEvent.LIST;this.subscribers=[];if(!this.silent){}var E="_YUICEOnSubscribe";if(D!==E){this.subscribeEvent=new YAHOO.util.CustomEvent(E,this,true);}this.lastError=null;};YAHOO.util.CustomEvent.LIST=0;YAHOO.util.CustomEvent.FLAT=1;YAHOO.util.CustomEvent.prototype={subscribe:function(B,C,A){if(!B){throw new Error("Invalid callback for subscriber to '"+this.type+"'");}if(this.subscribeEvent){this.subscribeEvent.fire(B,C,A);}this.subscribers.push(new YAHOO.util.Subscriber(B,C,A));},unsubscribe:function(D,F){if(!D){return this.unsubscribeAll();}var E=false;for(var B=0,A=this.subscribers.length;B<A;++B){var C=this.subscribers[B];if(C&&C.contains(D,F)){this._delete(B);E=true;}}return E;},fire:function(){var D=this.subscribers.length;if(!D&&this.silent){return true;}var H=[].slice.call(arguments,0),F=true,C,I=false;if(!this.silent){}var B=this.subscribers.slice();for(C=0;C<D;++C){var K=B[C];if(!K){I=true;}else{if(!this.silent){}var J=K.getScope(this.scope);if(this.signature==YAHOO.util.CustomEvent.FLAT){var A=null;if(H.length>0){A=H[0];}try{F=K.fn.call(J,A,K.obj);}catch(E){this.lastError=E;}}else{try{F=K.fn.call(J,this.type,H,K.obj);}catch(G){this.lastError=G;}}if(false===F){if(!this.silent){}return false;}}}return true;},unsubscribeAll:function(){for(var A=this.subscribers.length-1;A>-1;A--){this._delete(A);}this.subscribers=[];return A;},_delete:function(A){var B=this.subscribers[A];if(B){delete B.fn;delete B.obj;}this.subscribers.splice(A,1);},toString:function(){return"CustomEvent: "+"'"+this.type+"', "+"scope: "+this.scope;}};YAHOO.util.Subscriber=function(B,C,A){this.fn=B;this.obj=YAHOO.lang.isUndefined(C)?null:C;this.override=A;};YAHOO.util.Subscriber.prototype.getScope=function(A){if(this.override){if(this.override===true){return this.obj;}else{return this.override;}}return A;};YAHOO.util.Subscriber.prototype.contains=function(A,B){if(B){return(this.fn==A&&this.obj==B);}else{return(this.fn==A);}};YAHOO.util.Subscriber.prototype.toString=function(){return"Subscriber { obj: "+this.obj+", override: "+(this.override||"no")+" }";};if(!YAHOO.util.Event){YAHOO.util.Event=function(){var H=false;var I=[];var J=[];var G=[];var E=[];var C=0;var F=[];var B=[];var A=0;var D={63232:38,63233:40,63234:37,63235:39,63276:33,63277:34,25:9};return{POLL_RETRYS:2000,POLL_INTERVAL:20,EL:0,TYPE:1,FN:2,WFN:3,UNLOAD_OBJ:3,ADJ_SCOPE:4,OBJ:5,OVERRIDE:6,lastError:null,isSafari:YAHOO.env.ua.webkit,webkit:YAHOO.env.ua.webkit,isIE:YAHOO.env.ua.ie,_interval:null,_dri:null,DOMReady:false,startInterval:function(){if(!this._interval){var K=this;var L=function(){K._tryPreloadAttach();};this._interval=setInterval(L,this.POLL_INTERVAL);}},onAvailable:function(P,M,Q,O,N){var K=(YAHOO.lang.isString(P))?[P]:P;for(var L=0;L<K.length;L=L+1){F.push({id:K[L],fn:M,obj:Q,override:O,checkReady:N});}C=this.POLL_RETRYS;this.startInterval();},onContentReady:function(M,K,N,L){this.onAvailable(M,K,N,L,true);},onDOMReady:function(K,M,L){if(this.DOMReady){setTimeout(function(){var N=window;if(L){if(L===true){N=M;}else{N=L;}}K.call(N,"DOMReady",[],M);},0);}else{this.DOMReadyEvent.subscribe(K,M,L);}},addListener:function(M,K,V,Q,L){if(!V||!V.call){return false;}if(this._isValidCollection(M)){var W=true;for(var R=0,T=M.length;R<T;++R){W=this.on(M[R],K,V,Q,L)&&W;}return W;}else{if(YAHOO.lang.isString(M)){var P=this.getEl(M);if(P){M=P;}else{this.onAvailable(M,function(){YAHOO.util.Event.on(M,K,V,Q,L);});return true;}}}if(!M){return false;}if("unload"==K&&Q!==this){J[J.length]=[M,K,V,Q,L];return true;}var Y=M;if(L){if(L===true){Y=Q;}else{Y=L;}}var N=function(Z){return V.call(Y,YAHOO.util.Event.getEvent(Z,M),Q);};var X=[M,K,V,N,Y,Q,L];var S=I.length;I[S]=X;if(this.useLegacyEvent(M,K)){var O=this.getLegacyIndex(M,K);if(O==-1||M!=G[O][0]){O=G.length;B[M.id+K]=O;G[O]=[M,K,M["on"+K]];E[O]=[];M["on"+K]=function(Z){YAHOO.util.Event.fireLegacyEvent(YAHOO.util.Event.getEvent(Z),O);};}E[O].push(X);}else{try{this._simpleAdd(M,K,N,false);}catch(U){this.lastError=U;this.removeListener(M,K,V);return false;}}return true;},fireLegacyEvent:function(O,M){var Q=true,K,S,R,T,P;S=E[M].slice();for(var L=0,N=S.length;L<N;++L){R=S[L];if(R&&R[this.WFN]){T=R[this.ADJ_SCOPE];P=R[this.WFN].call(T,O);Q=(Q&&P);}}K=G[M];if(K&&K[2]){K[2](O);}return Q;},getLegacyIndex:function(L,M){var K=this.generateId(L)+M;if(typeof B[K]=="undefined"){return -1;}else{return B[K];}},useLegacyEvent:function(L,M){if(this.webkit&&("click"==M||"dblclick"==M)){var K=parseInt(this.webkit,10);if(!isNaN(K)&&K<418){return true;}}return false;},removeListener:function(L,K,T){var O,R,V;if(typeof L=="string"){L=this.getEl(L);}else{if(this._isValidCollection(L)){var U=true;for(O=L.length-1;O>-1;O--){U=(this.removeListener(L[O],K,T)&&U);}return U;}}if(!T||!T.call){return this.purgeElement(L,false,K);}if("unload"==K){for(O=J.length-1;O>-1;O--){V=J[O];if(V&&V[0]==L&&V[1]==K&&V[2]==T){J.splice(O,1);return true;}}return false;}var P=null;var Q=arguments[3];if("undefined"===typeof Q){Q=this._getCacheIndex(L,K,T);}if(Q>=0){P=I[Q];}if(!L||!P){return false;}if(this.useLegacyEvent(L,K)){var N=this.getLegacyIndex(L,K);var M=E[N];if(M){for(O=0,R=M.length;O<R;++O){V=M[O];if(V&&V[this.EL]==L&&V[this.TYPE]==K&&V[this.FN]==T){M.splice(O,1);break;}}}}else{try{this._simpleRemove(L,K,P[this.WFN],false);}catch(S){this.lastError=S;return false;}}delete I[Q][this.WFN];delete I[Q][this.FN];I.splice(Q,1);return true;},getTarget:function(M,L){var K=M.target||M.srcElement;return this.resolveTextNode(K);},resolveTextNode:function(L){try{if(L&&3==L.nodeType){return L.parentNode;}}catch(K){}return L;},getPageX:function(L){var K=L.pageX;if(!K&&0!==K){K=L.clientX||0;if(this.isIE){K+=this._getScrollLeft();}}return K;},getPageY:function(K){var L=K.pageY;if(!L&&0!==L){L=K.clientY||0;if(this.isIE){L+=this._getScrollTop();}}return L;},getXY:function(K){return[this.getPageX(K),this.getPageY(K)];},getRelatedTarget:function(L){var K=L.relatedTarget;
if(!K){if(L.type=="mouseout"){K=L.toElement;}else{if(L.type=="mouseover"){K=L.fromElement;}}}return this.resolveTextNode(K);},getTime:function(M){if(!M.time){var L=new Date().getTime();try{M.time=L;}catch(K){this.lastError=K;return L;}}return M.time;},stopEvent:function(K){this.stopPropagation(K);this.preventDefault(K);},stopPropagation:function(K){if(K.stopPropagation){K.stopPropagation();}else{K.cancelBubble=true;}},preventDefault:function(K){if(K.preventDefault){K.preventDefault();}else{K.returnValue=false;}},getEvent:function(M,K){var L=M||window.event;if(!L){var N=this.getEvent.caller;while(N){L=N.arguments[0];if(L&&Event==L.constructor){break;}N=N.caller;}}return L;},getCharCode:function(L){var K=L.keyCode||L.charCode||0;if(YAHOO.env.ua.webkit&&(K in D)){K=D[K];}return K;},_getCacheIndex:function(O,P,N){for(var M=0,L=I.length;M<L;M=M+1){var K=I[M];if(K&&K[this.FN]==N&&K[this.EL]==O&&K[this.TYPE]==P){return M;}}return -1;},generateId:function(K){var L=K.id;if(!L){L="yuievtautoid-"+A;++A;K.id=L;}return L;},_isValidCollection:function(L){try{return(L&&typeof L!=="string"&&L.length&&!L.tagName&&!L.alert&&typeof L[0]!=="undefined");}catch(K){return false;}},elCache:{},getEl:function(K){return(typeof K==="string")?document.getElementById(K):K;},clearCache:function(){},DOMReadyEvent:new YAHOO.util.CustomEvent("DOMReady",this),_load:function(L){if(!H){H=true;var K=YAHOO.util.Event;K._ready();K._tryPreloadAttach();}},_ready:function(L){var K=YAHOO.util.Event;if(!K.DOMReady){K.DOMReady=true;K.DOMReadyEvent.fire();K._simpleRemove(document,"DOMContentLoaded",K._ready);}},_tryPreloadAttach:function(){if(F.length===0){C=0;clearInterval(this._interval);this._interval=null;return ;}if(this.locked){return ;}if(this.isIE){if(!this.DOMReady){this.startInterval();return ;}}this.locked=true;var Q=!H;if(!Q){Q=(C>0&&F.length>0);}var P=[];var R=function(T,U){var S=T;if(U.override){if(U.override===true){S=U.obj;}else{S=U.override;}}U.fn.call(S,U.obj);};var L,K,O,N,M=[];for(L=0,K=F.length;L<K;L=L+1){O=F[L];if(O){N=this.getEl(O.id);if(N){if(O.checkReady){if(H||N.nextSibling||!Q){M.push(O);F[L]=null;}}else{R(N,O);F[L]=null;}}else{P.push(O);}}}for(L=0,K=M.length;L<K;L=L+1){O=M[L];R(this.getEl(O.id),O);}C--;if(Q){for(L=F.length-1;L>-1;L--){O=F[L];if(!O||!O.id){F.splice(L,1);}}this.startInterval();}else{clearInterval(this._interval);this._interval=null;}this.locked=false;},purgeElement:function(O,P,R){var M=(YAHOO.lang.isString(O))?this.getEl(O):O;var Q=this.getListeners(M,R),N,K;if(Q){for(N=Q.length-1;N>-1;N--){var L=Q[N];this.removeListener(M,L.type,L.fn);}}if(P&&M&&M.childNodes){for(N=0,K=M.childNodes.length;N<K;++N){this.purgeElement(M.childNodes[N],P,R);}}},getListeners:function(M,K){var P=[],L;if(!K){L=[I,J];}else{if(K==="unload"){L=[J];}else{L=[I];}}var R=(YAHOO.lang.isString(M))?this.getEl(M):M;for(var O=0;O<L.length;O=O+1){var T=L[O];if(T){for(var Q=0,S=T.length;Q<S;++Q){var N=T[Q];if(N&&N[this.EL]===R&&(!K||K===N[this.TYPE])){P.push({type:N[this.TYPE],fn:N[this.FN],obj:N[this.OBJ],adjust:N[this.OVERRIDE],scope:N[this.ADJ_SCOPE],index:Q});}}}}return(P.length)?P:null;},_unload:function(Q){var K=YAHOO.util.Event,N,M,L,P,O,R=J.slice();for(N=0,P=J.length;N<P;++N){L=R[N];if(L){var S=window;if(L[K.ADJ_SCOPE]){if(L[K.ADJ_SCOPE]===true){S=L[K.UNLOAD_OBJ];}else{S=L[K.ADJ_SCOPE];}}L[K.FN].call(S,K.getEvent(Q,L[K.EL]),L[K.UNLOAD_OBJ]);R[N]=null;L=null;S=null;}}J=null;if(I){for(M=I.length-1;M>-1;M--){L=I[M];if(L){K.removeListener(L[K.EL],L[K.TYPE],L[K.FN],M);}}L=null;}G=null;K._simpleRemove(window,"unload",K._unload);},_getScrollLeft:function(){return this._getScroll()[1];},_getScrollTop:function(){return this._getScroll()[0];},_getScroll:function(){var K=document.documentElement,L=document.body;if(K&&(K.scrollTop||K.scrollLeft)){return[K.scrollTop,K.scrollLeft];}else{if(L){return[L.scrollTop,L.scrollLeft];}else{return[0,0];}}},regCE:function(){},_simpleAdd:function(){if(window.addEventListener){return function(M,N,L,K){M.addEventListener(N,L,(K));};}else{if(window.attachEvent){return function(M,N,L,K){M.attachEvent("on"+N,L);};}else{return function(){};}}}(),_simpleRemove:function(){if(window.removeEventListener){return function(M,N,L,K){M.removeEventListener(N,L,(K));};}else{if(window.detachEvent){return function(L,M,K){L.detachEvent("on"+M,K);};}else{return function(){};}}}()};}();(function(){var EU=YAHOO.util.Event;EU.on=EU.addListener;
/* DOMReady: based on work by: Dean Edwards/John Resig/Matthias Miller */
if(EU.isIE){YAHOO.util.Event.onDOMReady(YAHOO.util.Event._tryPreloadAttach,YAHOO.util.Event,true);var n=document.createElement("p");EU._dri=setInterval(function(){try{n.doScroll("left");clearInterval(EU._dri);EU._dri=null;EU._ready();n=null;}catch(ex){}},EU.POLL_INTERVAL);}else{if(EU.webkit&&EU.webkit<525){EU._dri=setInterval(function(){var rs=document.readyState;if("loaded"==rs||"complete"==rs){clearInterval(EU._dri);EU._dri=null;EU._ready();}},EU.POLL_INTERVAL);}else{EU._simpleAdd(document,"DOMContentLoaded",EU._ready);}}EU._simpleAdd(window,"load",EU._load);EU._simpleAdd(window,"unload",EU._unload);EU._tryPreloadAttach();})();}YAHOO.util.EventProvider=function(){};YAHOO.util.EventProvider.prototype={__yui_events:null,__yui_subscribers:null,subscribe:function(A,C,F,E){this.__yui_events=this.__yui_events||{};var D=this.__yui_events[A];if(D){D.subscribe(C,F,E);}else{this.__yui_subscribers=this.__yui_subscribers||{};var B=this.__yui_subscribers;if(!B[A]){B[A]=[];}B[A].push({fn:C,obj:F,override:E});}},unsubscribe:function(C,E,G){this.__yui_events=this.__yui_events||{};var A=this.__yui_events;if(C){var F=A[C];if(F){return F.unsubscribe(E,G);}}else{var B=true;for(var D in A){if(YAHOO.lang.hasOwnProperty(A,D)){B=B&&A[D].unsubscribe(E,G);}}return B;}return false;},unsubscribeAll:function(A){return this.unsubscribe(A);},createEvent:function(G,D){this.__yui_events=this.__yui_events||{};var A=D||{};var I=this.__yui_events;if(I[G]){}else{var H=A.scope||this;var E=(A.silent);var B=new YAHOO.util.CustomEvent(G,H,E,YAHOO.util.CustomEvent.FLAT);
I[G]=B;if(A.onSubscribeCallback){B.subscribeEvent.subscribe(A.onSubscribeCallback);}this.__yui_subscribers=this.__yui_subscribers||{};var F=this.__yui_subscribers[G];if(F){for(var C=0;C<F.length;++C){B.subscribe(F[C].fn,F[C].obj,F[C].override);}}}return I[G];},fireEvent:function(E,D,A,C){this.__yui_events=this.__yui_events||{};var G=this.__yui_events[E];if(!G){return null;}var B=[];for(var F=1;F<arguments.length;++F){B.push(arguments[F]);}return G.fire.apply(G,B);},hasEvent:function(A){if(this.__yui_events){if(this.__yui_events[A]){return true;}}return false;}};YAHOO.util.KeyListener=function(A,F,B,C){if(!A){}else{if(!F){}else{if(!B){}}}if(!C){C=YAHOO.util.KeyListener.KEYDOWN;}var D=new YAHOO.util.CustomEvent("keyPressed");this.enabledEvent=new YAHOO.util.CustomEvent("enabled");this.disabledEvent=new YAHOO.util.CustomEvent("disabled");if(typeof A=="string"){A=document.getElementById(A);}if(typeof B=="function"){D.subscribe(B);}else{D.subscribe(B.fn,B.scope,B.correctScope);}function E(J,I){if(!F.shift){F.shift=false;}if(!F.alt){F.alt=false;}if(!F.ctrl){F.ctrl=false;}if(J.shiftKey==F.shift&&J.altKey==F.alt&&J.ctrlKey==F.ctrl){var G;if(F.keys instanceof Array){for(var H=0;H<F.keys.length;H++){G=F.keys[H];if(G==J.charCode){D.fire(J.charCode,J);break;}else{if(G==J.keyCode){D.fire(J.keyCode,J);break;}}}}else{G=F.keys;if(G==J.charCode){D.fire(J.charCode,J);}else{if(G==J.keyCode){D.fire(J.keyCode,J);}}}}}this.enable=function(){if(!this.enabled){YAHOO.util.Event.addListener(A,C,E);this.enabledEvent.fire(F);}this.enabled=true;};this.disable=function(){if(this.enabled){YAHOO.util.Event.removeListener(A,C,E);this.disabledEvent.fire(F);}this.enabled=false;};this.toString=function(){return"KeyListener ["+F.keys+"] "+A.tagName+(A.id?"["+A.id+"]":"");};};YAHOO.util.KeyListener.KEYDOWN="keydown";YAHOO.util.KeyListener.KEYUP="keyup";YAHOO.util.KeyListener.KEY={ALT:18,BACK_SPACE:8,CAPS_LOCK:20,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,LEFT:37,META:224,NUM_LOCK:144,PAGE_DOWN:34,PAGE_UP:33,PAUSE:19,PRINTSCREEN:44,RIGHT:39,SCROLL_LOCK:145,SHIFT:16,SPACE:32,TAB:9,UP:38};YAHOO.register("event",YAHOO.util.Event,{version:"2.5.1",build:"984"});
/*
 * A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
 * Digest Algorithm, as defined in RFC 1321.
 * Version 2.1 Copyright (C) Paul Johnston 1999 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for more info.
 */

/*
 * Configurable variables. You may need to tweak these to be compatible with
 * the server-side, but the defaults work in most cases.
 */
var hexcase = 0;  /* hex output format. 0 - lowercase; 1 - uppercase        */
var b64pad  = ""; /* base-64 pad character. "=" for strict RFC compliance   */
var chrsz   = 8;  /* bits per input character. 8 - ASCII; 16 - Unicode      */

/*
 * These are the functions you'll usually want to call
 * They take string arguments and return either hex or base-64 encoded strings
 */
function hex_md5(s){ return binl2hex(core_md5(str2binl(s), s.length * chrsz));}
function b64_md5(s){ return binl2b64(core_md5(str2binl(s), s.length * chrsz));}
function str_md5(s){ return binl2str(core_md5(str2binl(s), s.length * chrsz));}
function hex_hmac_md5(key, data) { return binl2hex(core_hmac_md5(key, data)); }
function b64_hmac_md5(key, data) { return binl2b64(core_hmac_md5(key, data)); }
function str_hmac_md5(key, data) { return binl2str(core_hmac_md5(key, data)); }

/*
 * Perform a simple self-test to see if the VM is working
 */
function md5_vm_test()
{
  return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
}

/*
 * Calculate the MD5 of an array of little-endian words, and a bit length
 */
function core_md5(x, len)
{
  /* append padding */
  x[len >> 5] |= 0x80 << ((len) % 32);
  x[(((len + 64) >>> 9) << 4) + 14] = len;

  var a =  1732584193;
  var b = -271733879;
  var c = -1732584194;
  var d =  271733878;

  for(var i = 0; i < x.length; i += 16)
  {
    var olda = a;
    var oldb = b;
    var oldc = c;
    var oldd = d;

    a = md5_ff(a, b, c, d, x[i+ 0], 7 , -680876936);
    d = md5_ff(d, a, b, c, x[i+ 1], 12, -389564586);
    c = md5_ff(c, d, a, b, x[i+ 2], 17,  606105819);
    b = md5_ff(b, c, d, a, x[i+ 3], 22, -1044525330);
    a = md5_ff(a, b, c, d, x[i+ 4], 7 , -176418897);
    d = md5_ff(d, a, b, c, x[i+ 5], 12,  1200080426);
    c = md5_ff(c, d, a, b, x[i+ 6], 17, -1473231341);
    b = md5_ff(b, c, d, a, x[i+ 7], 22, -45705983);
    a = md5_ff(a, b, c, d, x[i+ 8], 7 ,  1770035416);
    d = md5_ff(d, a, b, c, x[i+ 9], 12, -1958414417);
    c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
    b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
    a = md5_ff(a, b, c, d, x[i+12], 7 ,  1804603682);
    d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
    c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
    b = md5_ff(b, c, d, a, x[i+15], 22,  1236535329);

    a = md5_gg(a, b, c, d, x[i+ 1], 5 , -165796510);
    d = md5_gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
    c = md5_gg(c, d, a, b, x[i+11], 14,  643717713);
    b = md5_gg(b, c, d, a, x[i+ 0], 20, -373897302);
    a = md5_gg(a, b, c, d, x[i+ 5], 5 , -701558691);
    d = md5_gg(d, a, b, c, x[i+10], 9 ,  38016083);
    c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
    b = md5_gg(b, c, d, a, x[i+ 4], 20, -405537848);
    a = md5_gg(a, b, c, d, x[i+ 9], 5 ,  568446438);
    d = md5_gg(d, a, b, c, x[i+14], 9 , -1019803690);
    c = md5_gg(c, d, a, b, x[i+ 3], 14, -187363961);
    b = md5_gg(b, c, d, a, x[i+ 8], 20,  1163531501);
    a = md5_gg(a, b, c, d, x[i+13], 5 , -1444681467);
    d = md5_gg(d, a, b, c, x[i+ 2], 9 , -51403784);
    c = md5_gg(c, d, a, b, x[i+ 7], 14,  1735328473);
    b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);

    a = md5_hh(a, b, c, d, x[i+ 5], 4 , -378558);
    d = md5_hh(d, a, b, c, x[i+ 8], 11, -2022574463);
    c = md5_hh(c, d, a, b, x[i+11], 16,  1839030562);
    b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
    a = md5_hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
    d = md5_hh(d, a, b, c, x[i+ 4], 11,  1272893353);
    c = md5_hh(c, d, a, b, x[i+ 7], 16, -155497632);
    b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
    a = md5_hh(a, b, c, d, x[i+13], 4 ,  681279174);
    d = md5_hh(d, a, b, c, x[i+ 0], 11, -358537222);
    c = md5_hh(c, d, a, b, x[i+ 3], 16, -722521979);
    b = md5_hh(b, c, d, a, x[i+ 6], 23,  76029189);
    a = md5_hh(a, b, c, d, x[i+ 9], 4 , -640364487);
    d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
    c = md5_hh(c, d, a, b, x[i+15], 16,  530742520);
    b = md5_hh(b, c, d, a, x[i+ 2], 23, -995338651);

    a = md5_ii(a, b, c, d, x[i+ 0], 6 , -198630844);
    d = md5_ii(d, a, b, c, x[i+ 7], 10,  1126891415);
    c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
    b = md5_ii(b, c, d, a, x[i+ 5], 21, -57434055);
    a = md5_ii(a, b, c, d, x[i+12], 6 ,  1700485571);
    d = md5_ii(d, a, b, c, x[i+ 3], 10, -1894986606);
    c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
    b = md5_ii(b, c, d, a, x[i+ 1], 21, -2054922799);
    a = md5_ii(a, b, c, d, x[i+ 8], 6 ,  1873313359);
    d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
    c = md5_ii(c, d, a, b, x[i+ 6], 15, -1560198380);
    b = md5_ii(b, c, d, a, x[i+13], 21,  1309151649);
    a = md5_ii(a, b, c, d, x[i+ 4], 6 , -145523070);
    d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
    c = md5_ii(c, d, a, b, x[i+ 2], 15,  718787259);
    b = md5_ii(b, c, d, a, x[i+ 9], 21, -343485551);

    a = safe_add(a, olda);
    b = safe_add(b, oldb);
    c = safe_add(c, oldc);
    d = safe_add(d, oldd);
  }
  return Array(a, b, c, d);

}

/*
 * These functions implement the four basic operations the algorithm uses.
 */
function md5_cmn(q, a, b, x, s, t)
{
  return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s),b);
}
function md5_ff(a, b, c, d, x, s, t)
{
  return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
}
function md5_gg(a, b, c, d, x, s, t)
{
  return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
}
function md5_hh(a, b, c, d, x, s, t)
{
  return md5_cmn(b ^ c ^ d, a, b, x, s, t);
}
function md5_ii(a, b, c, d, x, s, t)
{
  return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
}

/*
 * Calculate the HMAC-MD5, of a key and some data
 */
function core_hmac_md5(key, data)
{
  var bkey = str2binl(key);
  if(bkey.length > 16) bkey = core_md5(bkey, key.length * chrsz);

  var ipad = Array(16), opad = Array(16);
  for(var i = 0; i < 16; i++)
  {
    ipad[i] = bkey[i] ^ 0x36363636;
    opad[i] = bkey[i] ^ 0x5C5C5C5C;
  }

  var hash = core_md5(ipad.concat(str2binl(data)), 512 + data.length * chrsz);
  return core_md5(opad.concat(hash), 512 + 128);
}

/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */
function safe_add(x, y)
{
  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
}

/*
 * Bitwise rotate a 32-bit number to the left.
 */
function bit_rol(num, cnt)
{
  return (num << cnt) | (num >>> (32 - cnt));
}

/*
 * Convert a string to an array of little-endian words
 * If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
 */
function str2binl(str)
{
  var bin = Array();
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < str.length * chrsz; i += chrsz)
    bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32);
  return bin;
}

/*
 * Convert an array of little-endian words to a string
 */
function binl2str(bin)
{
  var str = "";
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < bin.length * 32; i += chrsz)
    str += String.fromCharCode((bin[i>>5] >>> (i % 32)) & mask);
  return str;
}

/*
 * Convert an array of little-endian words to a hex string.
 */
function binl2hex(binarray)
{
  var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i++)
  {
    str += hex_tab.charAt((binarray[i>>2] >> ((i%4)*8+4)) & 0xF) +
           hex_tab.charAt((binarray[i>>2] >> ((i%4)*8  )) & 0xF);
  }
  return str;
}

/*
 * Convert an array of little-endian words to a base-64 string
 */
function binl2b64(binarray)
{
  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i += 3)
  {
    var triplet = (((binarray[i   >> 2] >> 8 * ( i   %4)) & 0xFF) << 16)
                | (((binarray[i+1 >> 2] >> 8 * ((i+1)%4)) & 0xFF) << 8 )
                |  ((binarray[i+2 >> 2] >> 8 * ((i+2)%4)) & 0xFF);
    for(var j = 0; j < 4; j++)
    {
      if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
      else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
    }
  }
  return str;
}

var Typostream = {

	styledElements: {},
	idCounter: 0,

	getStyle: function(x,styleProp)
	{
		
		if (x.currentStyle)
		{
			var stylePropWords = styleProp.split(/\-/g);
			styleProp = stylePropWords[0];
			for(var i = 1; i < stylePropWords.length; i++)
				styleProp += stylePropWords[i].substring(0,1).toUpperCase() + stylePropWords[i].substring(1);
			var y = x.currentStyle[styleProp];
		}
		else if (window.getComputedStyle)
			var y = document.defaultView.getComputedStyle(x,null).getPropertyValue(styleProp);
		return y;
	},

	applySelector: function(selector, specificity, styles)
	{
		if(selector.match(/:hover$/))
		{
			
			var nodes = YAHOO.util.Selector.query(selector.replace(/:hover$/, ''));
			for(var n = 0; n < nodes.length; n++)
			{
				var node = nodes[n];
				
				//make sure it has an id
				if(!node.id)
					node.id = 'typostream-anon-' + (Typostream.idCounter++);
				
				//add to flat list of styled elements
				Typostream.styledElements[node.id] = node;

				//create property list
				if(!node.typostreamHoverPropertyList)
				{
					node.typostreamHoverPropertyList = {};
					node.typostreamHoverStyles = {};
				}

				for(var prop in styles)
				{
					if(node.typostreamHoverPropertyList[prop] && node.typostreamHoverPropertyList[prop].specificity > specificity)
						continue;
					
					if(node.typostreamHoverPropertyList[prop])
					{
						node.typostreamHoverPropertyList[prop].specificity = specificity;
						node.typostreamHoverPropertyList[prop].value = styles[prop];
						node.typostreamHoverStyles[prop] = styles[prop];
					}
					else
					{
						node.typostreamHoverPropertyList[prop] = {
							specificity: specificity,
							value: styles[prop]
						};
						node.typostreamHoverStyles[prop] = styles[prop];
					}
				}
			}			
		}
		else
		{
			var nodes = YAHOO.util.Selector.query(selector);
			for(var n = 0; n < nodes.length; n++)
			{
				var node = nodes[n];
				
				//make sure it has an id
				if(!node.id)
					node.id = 'typostream-anon-' + (Typostream.idCounter++);
				
				//add to flat list of styled elements
				Typostream.styledElements[node.id] = node;

				//create property list
				if(!node.typostreamPropertyList)
				{
					node.typostreamPropertyList = {};
					node.typostreamStyles = {};
				}

				for(var prop in styles)
				{
					if(node.typostreamPropertyList[prop] && node.typostreamPropertyList[prop].specificity > specificity)
						continue;
					
					if(node.typostreamPropertyList[prop])
					{
						node.typostreamPropertyList[prop].specificity = specificity;
						node.typostreamPropertyList[prop].value = styles[prop];
						node.typostreamStyles[prop] = styles[prop];
					}
					else
					{
						node.typostreamPropertyList[prop] = {
							specificity: specificity,
							value: styles[prop]
						};
						node.typostreamStyles[prop] = styles[prop];
					}
				}
			}
		}
	},

	applyStyles: function()
	{
		//calculate DPI
		var dpiDiv = document.createElement('div');
		dpiDiv.style.width = '1in';
		dpiDiv.style.height = '1px';
		document.body.appendChild(dpiDiv);
		var dpiWidth = dpiDiv.offsetWidth;
		document.body.removeChild(dpiDiv);
		Typostream.dpi = dpiWidth;
		for(var id in Typostream.styledElements)
		{
			var node = Typostream.styledElements[id];
			Typostream.applyRecurse(node, node.typostreamStyles, node.typostreamHoverStyles);
			
		}
	},

	applyRecurse: function(node, styles, hoverStyles)
	{
		for(var i = 0; i < node.childNodes.length; i++)
		{
			var cnode = node.childNodes[i];
			if(cnode.nodeType == 3)
			{
				//calculate width
				var span = document.createElement('span');
				span.style.fontSize = Typostream.getStyle(node, 'font-size');
				span.style.display = 'inline';
				span.appendChild(document.createTextNode("| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | "));
				node.replaceChild(span, cnode);
				var nodeWidth = span.offsetWidth;

				node.replaceChild(cnode, span);
				var currentNode = node;
				while(currentNode && nodeWidth == 0)
				{
					var parent = currentNode.parentNode;
					parent.replaceChild(span, currentNode);
					nodeWidth = span.offsetWidth;
					parent.replaceChild(currentNode, span);
					currentNode = parent;
				}
				
				//var nodeWidth = node.offsetWidth - parseInt(Typostream.getStyle(node, 'padding-left')) - parseInt(Typostream.getStyle(node, 'padding-right'))
				
				var q = {
					account: Typostream.account,
					sheet: Typostream.sheet,
					text: cnode.nodeValue,
					styles: styles,
					width: nodeWidth,
					dpi: Typostream.dpi
				};

				var inheritedHoverStyles = {};
				for(var rule in styles)
					inheritedHoverStyles[rule] = styles[rule];
				
				if(hoverStyles)
					for(var rule in hoverStyles)
						inheritedHoverStyles[rule] = hoverStyles[rule];

				var hoverQ = {
					account: Typostream.account,
					sheet: Typostream.sheet,
					text: cnode.nodeValue,
					styles: inheritedHoverStyles,
					width: nodeWidth,
					dpi: Typostream.dpi
				};

				if(!hoverStyles)
					hoverQ = null;
				
				Typostream.replaceElement(cnode, q, hoverQ);
			}
			else if(cnode.nodeType == 1)
			{
				var nStyles = styles;
				var nHoverStyles = hoverStyles;
				if(cnode.typostreamStyles)
					for(var sel in cnode.typostreamStyles)
						nStyles[sel] = cnode.typostreamStyles[sel];
				if(cnode.typostreamHoverStyles)
					for(var sel in cnode.typostreamHoverStyles)
						nHoverStyles[sel] = cnode.typostreamHoverStyles[sel];
				Typostream.applyRecurse(cnode, nStyles, nHoverStyles);
			}
		}
	},

	replaceElement: function(el, q, hoverQ)
	{
		if(!q.text.match(/[^\s]/))
			return;
		var qJSON = YAHOO.lang.JSON.stringify(q);
		
		var img = document.createElement("img");
		img.alt = q.text;
		img.src = "http://type.blazonco.com/account/" + Typostream.account + "/" + hex_md5(qJSON) + ".png?q=" + escape(qJSON).replace(/\+/, '%2B');
		img.style.borderWidth = "0";
		img.className = 'typostream-replacement';
		el.parentNode.replaceChild(img, el);

		if(Typostream.ie6 && !q.styles['background-color'])
		{
			//fix PNG brokenness
			if(img.width && img.height)
			{
				var height = img.offsetHeight;
				var width = img.offsetWidth;
				img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + img.src + "', sizingMethod='crop')";
				img.src = 'http://static.blazonco.com/scripts/ie6/blank.gif';

				img.style.height = height + 'px';
				img.style.width = width + 'px';
			}
			else
			{
				img.onload = function(imgC)
				{
					return function()
					{
						imgC.onload = null;
						var height = imgC.offsetHeight;
						var width = imgC.offsetWidth;
						imgC.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + imgC.src + "', sizingMethod='crop')";
						imgC.src = 'http://static.blazonco.com/scripts/ie6/blank.gif';

						imgC.style.height = height + 'px';
						imgC.style.width = width + 'px';
					};
				}(img);
			}
		}

		if(hoverQ)
		{
			
			var hoverQJSON = YAHOO.lang.JSON.stringify(hoverQ);
			var hoverImg = document.createElement('img');
			hoverImg.alt = q.text;
			hoverImg.src = 'http://type.blazonco.com/account/' + Typostream.account + '/' + hex_md5(hoverQJSON) + '.png?q=' + escape(hoverQJSON).replace(/\+/, '%2B');
			hoverImg.style.borderWidth = '0';
			hoverImg.className = 'typostream-hover';
			hoverImg.style.display = 'none';
			if(img.nextSibling)
				img.parentNode.insertBefore(hoverImg, img.nextSibling);
			else
				img.parentNode.appendChild(hoverImg);

			YAHOO.util.Event.addListener(img.parentNode, 'mouseover', function(e)
			{
				img.style.display = 'none'
				hoverImg.style.display = 'inline';
			});

			YAHOO.util.Event.addListener(img.parentNode, 'mouseout', function(e)
			{
				img.style.display = 'inline';
				hoverImg.style.display = 'none';
			});
		}
	}

};

