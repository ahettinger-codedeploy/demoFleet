/* (c) 2008, 2009, 2010 Add This, LLC */
if(!window._ate){var _atd="www.addthis.com/",_atr="//s7.addthis.com/",_atn="//l.addthiscdn.com/",_euc=encodeURIComponent,_duc=decodeURIComponent,_atc={dr:0,ver:250,loc:0,enote:"",cwait:500,tamp:-1,xamp:0,camp:1,vamp:1,famp:0.02,pamp:0.2,damp:1,abf:!!window.addthis_do_ab};(function(){try{var F=window.location;if(F.protocol.indexOf("file")===0){_atr="http:"+_atr}if(F.hostname.indexOf("localhost")!=-1){_atc.loc=1}}catch(L){}var J=navigator.userAgent.toLowerCase(),M=document,t=window,H=M.location,O={win:/windows/.test(J),xp:/windows nt 5.1/.test(J)||/windows nt 5.2/.test(J),osx:/os x/.test(J),chr:/chrome/.test(J),iph:/iphone/.test(J),ipa:/ipad/.test(J),saf:/safari/.test(J),web:/webkit/.test(J),opr:/opera/.test(J),msi:(/msie/.test(J))&&!(/opera/.test(J)),ffx:/firefox/.test(J),ff2:/firefox\/2/.test(J),ie6:/msie 6.0/.test(J),ie7:/msie 7.0/.test(J),mod:-1},f={vst:[],rev:"78223",bro:O,show:1,dl:H,upm:!!t.postMessage&&(""+t.postMessage).toLowerCase().indexOf("[native code]")!==-1,camp:_atc.camp-Math.random(),xamp:_atc.xamp-Math.random(),vamp:_atc.vamp-Math.random(),pamp:_atc.pamp-Math.random(),afamp:_atc.afamp-Math.random(),ab:"-",seq:1,inst:1,wait:500,tmo:null,cvt:[],avt:null,sttm:new Date().getTime(),max:4294967295,sid:0,sub:!!window.at_sub,dbm:0,uid:null,spt:"static/r07/widget19.png",api:{},imgz:[],hash:window.location.hash};M.ce=M.createElement;M.gn=M.getElementsByTagName;window._ate=f;var u=function(r,p,q,d){if(!r){return q}if(r instanceof Array||(r.length&&(typeof r!=="function"))){for(var l=0,a=r.length,b=r[0];l<a;b=r[++l]){q=p.call(d||r,q,b,l,r)}}else{for(var e in r){q=p.call(d||r,q,r[e],e,r)}}return q},A=Array.prototype.slice,C=function(b){return A.apply(b,A.call(arguments,1))},B=function(a){return(""+a).replace(/(^\s+|\s+$)/g,"")},K=function(a,b){return u(C(arguments,1),function(e,d){return u(d,function(p,l,i){p[i]=l;return p},e)},a)},m=function(b,a){return u(b,function(i,e,d){d=B(d);if(d){i.push(_euc(d)+"="+_euc(B(e)))}return i},[]).join(a||"&")},j=function(b,a){return u((b||"").split(a||"&"),function(p,r){try{var l=r.split("="),i=B(_duc(l[0])),d=B(_duc(l.slice(1).join("=")));if(i){p[i]=d}}catch(q){}return p},{})},Q=function(){var a=C(arguments,0),d=a.shift(),b=a.shift();return function(){return d.apply(b,a.concat(C(arguments,0)))}},G=function(b,e,a,d){if(!e){return}if(we){e[(b?"detach":"attach")+"Event"]("on"+a,d)}else{e[(b?"remove":"add")+"EventListener"](a,d,false)}},k=function(d,a,b){G(0,d,a,b)},g=function(d,a,b){G(1,d,a,b)},c={reduce:u,slice:C,strip:B,extend:K,toKV:m,fromKV:j,bind:Q,listen:k,unlisten:g};f.util=c;K(f,c);(function(r,w,R){var p,T=r.util;function s(W,V,Y,U,X){this.type=W;this.triggerType=V||W;this.target=Y||U;this.triggerTarget=U||Y;this.data=X||{}}T.extend(s.prototype,{constructor:s,bubbles:false,preventDefault:T.noop,stopPropagation:T.noop,clone:function(){return new this.constructor(this.type,this.triggerType,this.target,this.triggerTarget,T.extend({},this.data))}});function i(U,V){this.target=U;this.queues={};this.defaultEventType=V||s}function a(U){var V=this.queues;if(!V[U]){V[U]=[]}return V[U]}function q(U,V){this.getQueue(U).push(V)}function e(V,W){var X=this.getQueue(V),U=X.indexOf(W);if(U!==-1){X.splice(U,1)}}function b(U,Y,X,W){var V=this;if(!W){setTimeout(function(){V.dispatchEvent(new V.defaultEventType(U,U,Y,V.target,X))},10)}else{V.dispatchEvent(new V.defaultEventType(U,U,Y,V.target,X))}}function S(V){for(var W=0,Y=V.target,X=this.getQueue(V.type),U=X.length;W<U;W++){X[W].call(Y,V.clone())}}function d(W,V){if(!V){return}for(var U in l){V[U]=T.bind(l[U],this)}return V}var l={constructor:i,getQueue:a,addEventListener:q,removeEventListener:e,dispatchEvent:S,fire:b,decorate:d};T.extend(i.prototype,l);r.event={PolyEvent:s,EventDispatcher:i}})(f,f.api,f);f.ed=new f.event.EventDispatcher(f);var o={isBound:0,isReady:0,readyList:[],onReady:function(){if(!o.isReady){o.isReady=1;var a=o.readyList.concat(window.addthis_onload||[]);for(var b=0;b<a.length;b++){a[b].call(window)}o.readyList=[]}},addLoad:function(a){var b=t.onload;if(typeof t.onload!="function"){t.onload=a}else{t.onload=function(){if(b){b()}a()}}},bindReady:function(){if(x.isBound||_atc.xol){return}x.isBound=1;if(M.addEventListener&&!O.opr){M.addEventListener("DOMContentLoaded",x.onReady,false)}var a=window.addthis_product;if(a&&a.indexOf("f")>-1){x.onReady();return}if(O.msi&&window==top){(function(){if(x.isReady){return}try{M.documentElement.doScroll("left")}catch(d){setTimeout(arguments.callee,0);return}x.onReady()})()}if(O.opr){M.addEventListener("DOMContentLoaded",function(){if(x.isReady){return}for(var d=0;d<M.styleSheets.length;d++){if(M.styleSheets[d].disabled){setTimeout(arguments.callee,0);return}}x.onReady()},false)}if(O.saf){var b;(function(){if(x.isReady){return}if(M.readyState!="loaded"&&M.readyState!="complete"){setTimeout(arguments.callee,0);return}if(b===undefined){var d=M.gn("link");for(var e=0;e<d.length;e++){if(d[e].getAttribute("rel")=="stylesheet"){b++}}var l=M.gn("style");b+=l.length}if(M.styleSheets.length!=b){setTimeout(arguments.callee,0);return}x.onReady()})()}x.addLoad(x.onReady)},append:function(b,a){x.bindReady();if(x.isReady){b.call(window,[])}else{x.readyList.push(function(){return b.call(window,[])})}}},x=o,P=f;K(f,{plo:[],lad:function(a){f.plo.push(a)}});K(f,{pub:function(){return _euc((window.addthis_config||{}).username||window.addthis_pub||"")},igv:function(a,b){if(!t.addthis_share){t.addthis_share={}}if(!addthis_share.url){addthis_share.url=(t.addthis_url||a||"").split("#{").shift()}if(!addthis_share.title){addthis_share.title=(t.addthis_title||b||"").split("#{").shift()}if(!t.addthis_config){t.addthis_config={username:t.addthis_pub}}else{if(addthis_config.data_use_cookies===false){_atc.xck=1}}}});if(!_atc.ost){if(!t.addthis_conf){t.addthis_conf={}}for(var I in addthis_conf){_atc[I]=addthis_conf[I]}_atc.ost=1}(function(b,l,e){var q,p=document,a=b.util;b.ckv=a.fromKV(p.cookie,";");function i(d){return a.fromKV(p.cookie,";")[d]}if(!b.cookie){b.cookie={}}b.cookie.rck=i})(f,f.api,f);K(f,{qtp:[],xtp:function(){var b=f,d;while(d=b.qtp.pop()){b.trk(d)}},gat:function(){},atf:null,get_atssh:function(){var e=document,b=f,i=e.getElementById("_atssh");if(!i){i=e.ce("div");i.style.visibility="hidden";i.id="_atssh";b.opp(i.style);e.body.insertBefore(i,e.body.firstChild)}return i},ctf:function(i){var p=document,e=window,b=f,q,l=Math.floor(Math.random()*1000);div=b.get_atssh();if(!b.bro.msi){q=p.ce("iframe");q.id="_atssh"+l}else{if(b.bro.ie6&&!i&&p.location.protocol.indexOf("https")==0){i="javascript:''"}div.innerHTML='<iframe id="_atssh'+l+'" width="1" height="1" name="_atssh'+l+'" '+(i?'src="'+i+'"':"")+">";q=p.getElementById("_atssh"+l)}b.opp(q.style);q.frameborder=q.style.border=0;q.style.top=q.style.left=0;return q},off:function(){return Math.floor((new Date().getTime()-f.sttm)/100).toString(16)},oms:function(d){var b=f;if(d&&d.data&&d.data.service){if(!b.upm){if(b.dcp){return}b.dcp=1}b.trk({gen:300,sh:d.data.service})}},omp:function(b,d,e){var a={};if(b){a.sh=b}if(d){a.cm=d}if(e){a.cs=e}f.img("sh","3",null,a)},trk:function(e){var d=f,i=d.dr,b=(d.rev||"");if(!e){return}if(i){i=i.split("http://").pop()}e.xck=_atc.xck?1:0;e.xxl=1;e.sid=d.ssid();e.pub=d.pub();e.ssl=d.ssl||0;e.du=d.tru(d.du||d.dl.href);if(d.dt){e.dt=d.dt}if(d.cb){e.cb=d.cb}e.lng=d.lng();e.ver=_atc.ver;if(!d.upm&&d.uid){e.uid=d.uid}e.pc=window.addthis_product||"men-"+_atc.ver;if(i){e.dr=d.tru(i)}if(d.dh){e.dh=d.dh}if(b){e.rev=b}if(d.xfr){if(d.upm){if(d.atf){d.atf.contentWindow.postMessage(m(e),"*")}}else{var l=d.get_atssh();base="static/r07/sh19.html"+(false?"?t="+new Date().getTime():"");if(d.atf){l.removeChild(l.firstChild)}d.atf=d.ctf();d.atf.src=_atr+base+"#"+m(e);l.appendChild(d.atf)}}else{f.qtp.push(e)}},img:function(l,r,b,p,q){if(!window.at_sub&&!_atc.xtr){var d=f,e=p||{};e.evt=l;if(b){e.ext=b}d.avt=e;if(q===1){d.xmi(true)}else{d.sxm(true)}}},cuid:function(){return((f.sttm/1000)&f.max).toString(16)+("00000000"+(Math.floor(Math.random()*(f.max+1))).toString(16)).slice(-8)},ssid:function(){if(f.sid===0){f.sid=f.cuid()}return f.sid},sta:function(){var b=f;return"AT-"+(b.pub()?b.pub():"unknown")+"/-/"+b.ab+"/"+b.ssid()+"/"+(b.seq++)+(b.uid!==null?"/"+b.uid:"")},cst:function(a){return"CXNID=2000001.521545608054043907"+(a||2)+"NXC"},fcv:function(b,a){return _euc(b)+"="+_euc(a)+";"+f.off()},cev:function(b,a){f.cvt.push(f.fcv(b,a));f.sxm(true)},sxm:function(a){if(f.tmo!==null){clearTimeout(f.tmo)}if(a){f.tmo=f.sto("_ate.xmi(false)",f.wait)}},xmi:function(r){var b=f,p=b.dl?b.dl.hostname:"";if(b.cvt.length>0||b.avt){b.sxm(false);if(_atc.xtr){return}var l=b.avt||{};l.ce=b.cvt.join(",");b.cvt=[];b.avt=null;b.trk(l);if(r){var q=document,e=q.ce("iframe");e.id="_atf";f.opp(e.style);q.body.appendChild(e);e=q.getElementById("_atf")}}}});K(f,{_rec:[],rec:function(e){if(!e){return}var q=j(e),b=f,d=b.atf,l=b._rec,w;if(q.ssh){b.ssh(q.ssh)}if(q.uid){b.uid=q.uid}if(q.dbm){b.dbm=q.dbm}if(q.rdy){b.xfr=1;b.xtp();return}for(var R=0;R<l.length;R++){l[R](q)}},xfr:!f.upm||!f.bro.ffx,ssh:function(b){f.gssh=1;var a=window.addthis_ssh=_duc(b);f._ssh=a.split(",")},com:function(a){if(window.parent&&window.postMessage){window.parent.postMessage(a,"*")}else{f.ifm(a)}},ifm:function(b){if(addthis_wpl){var d=(addthis_wpl.split("#"))[0];window.parent.location.href=d+"#at"+b}return false},pmh:function(a){if(a.origin.slice(-12)==".addthis.com"){f.rec(a.data)}}});K(f,{lng:function(){return window.addthis_language||(window.addthis_config||{}).ui_language||(f.bro.msi?navigator.userLanguage:navigator.language)},iwb:function(a){var b={th:1,pl:1,sl:1,gl:1,hu:1,is:1,nb:1,se:1,su:1};return !!b[a]},ivl:function(a){var b={af:1,afr:"af",ar:1,ara:"ar",az:1,aze:"az",be:1,bye:"be",bg:1,bul:"bg",bn:1,ben:"bn",bs:1,bos:"bs",ca:1,cat:"ca",cs:1,ces:"cs",cze:"cs",cy:1,cym:"cy",da:1,dan:"da",de:1,deu:"de",ger:"de",el:1,gre:"el",ell:"ell",es:1,esl:"es",spa:"spa",et:1,est:"et",eu:1,fa:1,fas:"fa",per:"fa",fi:1,fin:"fi",fo:1,fao:"fo",fr:1,fra:"fr",fre:"fr",ga:1,gae:"ga",gdh:"ga",gl:1,glg:"gl",he:1,heb:"he",hi:1,hin:"hin",hr:1,cro:"hr",hu:1,hun:"hu",id:1,ind:"id",is:1,ice:"is",it:1,ita:"it",ja:1,jpn:"ja",ko:1,kor:"ko",ku:1,lb:1,ltz:"lb",lt:1,lit:"lt",lv:1,lav:"lv",mk:1,mac:"mk",mak:"mk",mn:1,ml:1,ms:1,msa:"ms",may:"ms",nb:1,nl:1,nla:"nl",dut:"nl",no:1,nn:1,nno:"no",oc:1,oci:"oc",pl:1,pol:"pl",pt:1,por:"pt",ro:1,ron:"ro",rum:"ro",ru:1,rus:"ru",sk:1,slk:"sk",slo:"sk",sl:1,slv:"sl",sq:1,alb:"sq",sr:1,se:1,ser:"sr",su:1,sv:1,sve:"sv",sw:1,swe:"sv",ta:1,tam:"ta",te:1,teg:"te",th:1,tha:"th",tl:1,tgl:"tl",tr:1,tur:"tr",uk:1,ukr:"uk",ur:1,urd:"ur",vi:1,vie:"vi","zh-hk":1,"chi-hk":"zh-hk","zho-hk":"zh-hk","zh-tr":1,"chi-tr":"zh-tr","zho-tr":"zh-tr","zh-tw":1,"chi-tw":"zh-tw","zho-tw":"zh-tw",zh:1,chi:"zh",zho:"zh"};if(b[a]){return b[a]}a=a.split("-").shift();if(b[a]){if(b[a]===1){return a}else{return b[a]}}return 0},gvl:function(a){var b=f.ivl(a)||"en";if(b===1){b=a}return b},alg:function(e,d){var a=(e||f.lng()||"en").toLowerCase(),b=f.ivl(a);if(a.indexOf("en")!==0&&(!f.pll||d)){if(b){if(b!==1){a=b}f.pll=f.ajs("static/r07/lang02/"+a+".js")}}}});K(f,{trim:function(a,b){try{a=a.replace(/^[\s\u3000]+|[\s\u3000]+$/g,"");if(b){a=_euc(a)}}catch(b){}return a},trl:[],tru:function(b,a){var d="";if(b){d=b.substr(0,300);if(d!=b){f.trl.push(a)}}return d},sto:function(b,a){return setTimeout(b,a)},opp:function(a){a.width=a.height="1px";a.position="absolute";a.zIndex=100000},jlr:{},ajs:function(a){if(!f.jlr[a]){var b=M.ce("script");b.src=_atr+a;M.gn("head")[0].appendChild(b);f.jlr[a]=1;return b}return 1},jlo:function(){try{var q=document,b=f,p=b.lng(),i=function(d){var a=new Image();f.imgz.push(a);a.src=d};b.alg(p);if(!b.pld){if(b.bro.ie6){i(_atr+b.spt);i(_atr+"static/t00/logo1414.gif");i(_atr+"static/t00/logo88.gif");if(window.addthis_feed){i("static/r05/feed00.gif",1)}}if(b.pll&&!window.addthis_translations){b.sto(function(){b.pld=b.ajs("static/r07/menu55.js")},10)}else{b.pld=b.ajs("static/r07/menu55.js")}}}catch(l){}},ao:function(b,l,i,d,e,a){f.lad(["open",b,l,i,d,e,a]);f.jlo();return false},ac:function(){},as:function(b,d,a){f.lad(["send",b,d,a]);f.jlo()}});(function(e,l,q){var w=document,r=1,a=["cbea","kkk","zvys","phz"];function b(d){return d.replace(/[a-zA-Z]/g,function(i){return String.fromCharCode((i<="Z"?90:122)>=(i=i.charCodeAt(0)+13)?i:i-26)})}for(var p=0;p<a.length;p++){a[p]=" "+b(a[p])+" "}function s(i){var T=0,S;i=(i||"").toLowerCase()+" ";if(!i){return T}for(var d=0;d<a.length;d++){S=a[d];if(i==S.replace(/ /g,"")||i.indexOf(S)>-1||i.indexOf(S.replace(/^ /g,""))===0){T|=r}}return T}function R(){var V=(t.addthis_title||w.title),S=s(V),U=w.all?w.all.tags("META"):w.getElementsByTagName?w.getElementsByTagName("META"):new Array();if(U&&U.length){for(var T=0;T<U.length;T++){var d=U[T]||{},X=(d.name||"").toLowerCase(),W=d.content;if(X=="description"||X=="keywords"){S|=s(W)}}}return S}if(!e.ad){e.ad={}}e.ad.cla=R})(f,f.api,f);var t=window,N=t.addthis_config||{};function n(){var a=M.ce("link");a.rel="stylesheet";a.type="text/css";a.href=_atr+"static/r07/widget38.css";a.media="all";M.gn("head")[0].appendChild(a)}function h(){try{if(_atc.xol&&!_atc.xcs){n()}var ae=f,q=ae.bro.msi,b=0,T=M.title,U=M.referer||M.referrer||"",S=H?H.href:null,r=S,ab=H.hostname,ad=S?S.indexOf("sms_ss"):-1,X=(f.lng().split("-")).shift(),p=(H.href.indexOf(_atr)==-1&&!ae.sub),Y=M.gn("link"),d=_atr+"static/r07/sh19.html#",V=S&&S.indexOf("https")===0?1:0,s,af,R=function(){af.pc=window.addthis_product||"men"+_atc.ver};for(var Z=0;Z<Y.length;Z++){var W=Y[Z];if(W.rel&&W.rel=="canonical"&&W.href){r=W.href}}r=r.split("#{").shift();ae.igv(r,M.title||"");ae.dr=ae.tru(U,"fr");ae.du=ae.tru(r,"fp");ae.dt=T=t.addthis_share.title;ae.cb=ae.ad.cla();ae.dh=H.hostname;ae.ssl=V;af={cb:ae.cb,ab:ae.ab,dh:ae.dh,dr:ae.dr,du:ae.du,dt:T,inst:ae.inst,lng:ae.lng(),pc:t.addthis_product||"men",pub:ae.pub(),ssl:V,sid:f.ssid(),srd:_atc.damp,srf:_atc.famp,srp:_atc.pamp,srx:_atc.xamp,ver:_atc.ver,xck:_atc.xck||0};if(ae.trl.length){af.trl=ae.trl.join(",")}if(ae.rev){af.rev=ae.rev}if(ad>-1&&S.indexOf(_atd+"book")==-1){var w=[];var aa=S.substr(ad);aa=aa.split("&").shift().split("#").shift().split("=").pop();af.sr=aa;if(ae.vamp>=0&&!ae.sub&&aa.length){w.push(ae.fcv("plv",Math.round(1/_atc.vamp)));w.push(ae.fcv("rsc",aa));af.ce=w.join(",")}}if(ae.upm){af.xd=1;if(f.bro.ffx){af.xld=1}}if(p){if(ae.upm){if(q){f.sto(function(){R();ae.atf=s=ae.ctf(d+m(af))},f.wait);t.attachEvent("onmessage",ae.pmh)}else{s=ae.ctf();t.addEventListener("message",ae.pmh,false)}if(f.bro.ffx){s.src=d;f.qtp.push(af)}else{if(!q){f.sto(function(){R();s.src=d+m(af)},f.wait)}}}else{s=ae.ctf();f.sto(function(){R();s.src=d+m(af)},f.wait)}if(s){ae.atf=s=ae.get_atssh().appendChild(s)}}if(t.addthis_language||N.ui_language){ae.alg()}if(ae.plo.length>0){ae.jlo()}}catch(ac){}}f.ed.addEventListener("addthis.menu.share",f.oms);t._ate=P;t._adr=x;try{var E=M.gn("script"),v=E[E.length-1],y=v.src.indexOf("#")>-1?v.src.replace(/^[^\#]+\#?/,""):v.src.replace(/^[^\?]+\??/,""),z=j(y);if(z.pub||z.username){t.addthis_pub=_duc(z.pub?z.pub:z.username)}if(t.addthis_pub&&t.addthis_config){t.addthis_config.username=t.addthis_pub}if(z.domready){_atc.dr=1}if(z.async){_atc.xol=1}if(_atc.ver===120){var D="atb"+f.cuid();M.write('<span id="'+D+'"></span>');f.igv();f.lad(["span",D,addthis_share.url||"[url]",addthis_share.title||"[title]"])}if(t.addthis_clickout){f.lad(["cout"])}if(!_atc.xol&&!_atc.xcs&&N.ui_use_css!==false){n()}}catch(L){}o.bindReady();o.append(h)})();function addthis_open(){if(typeof iconf=="string"){iconf=null}return _ate.ao.apply(_ate,arguments)}function addthis_close(){_ate.ac()}function addthis_sendto(){_ate.as.apply(_ate,arguments);return false}if(_atc.dr){_adr.onReady()}}else{_ate.inst++}if(_atc.abf){addthis_open(document.getElementById("ab"),"emailab",window.addthis_url||"[URL]",window.addthis_title||"[TITLE]")};var snark=0;if(!window.addthis||window.addthis.nodeType!==undefined){window.addthis=(function(){var g={aim:"AIM",a1webmarks:"A1&#8209;Webmarks",aim:"AIM Share",amazonwishlist:"Amazon",aolmail:"AOL Mail",aviary:"Aviary Capture",domaintoolswhois:"Whois Lookup",googlereader:"Google Reader",googletranslate:"Google Translate",linkagogo:"Link-a-Gogo",meneame:"Men&eacute;ame",misterwong:"Mister Wong",mailto:"Email App",myaol:"myAOL",myspace:"MySpace",readitlater:"Read It Later",stumbleupon:"StumbleUpon",typepad:"TypePad",wordpress:"WordPress",yahoobkm:"Y! Bookmarks",yahoomail:"Y! Mail"},i=document,f=i.gn("body").item(0),h=_ate.util.bind,c=_ate.ed,b=function(d,n){var o;if(window._atw&&_atw.list){o=_atw.list[d]}else{if(g[d]){o=g[d]}else{o=(n?d:(d.substr(0,1).toUpperCase()+d.substr(1)))}}return o.replace(/&nbsp;/g," ")},l=function(d,w,u,t,v){w=w.toUpperCase();var r=(d==f&&addthis.cache[w]?addthis.cache[w]:(d||f||i.body).getElementsByTagName(w)),q=[],s,p;if(d==f){addthis.cache[w]=r}if(v){for(s=0;s<r.length;s++){p=r[s];if(p.className.indexOf(u)>-1){q.push(p)}}}else{u=u.replace(/\-/g,"\\-");var n=new RegExp("(^|\\s)"+u+(t?"\\w*":"")+"(\\s|$)");for(s=0;s<r.length;s++){p=r[s];if(n.test(p.className)){q.push(p)}}}return(q)},m=i.getElementsByClassname||l;function k(d){if(typeof d=="string"){var n=d.substr(0,1);if(n=="#"){d=i.getElementById(d.substr(1))}else{if(n=="."){d=m(f,"*",d.substr(1))}else{}}}if(!d){d=[]}else{if(!(d instanceof Array)){d=[d]}}return d}function a(n,d){return function(){addthis.plo.push({call:n,args:arguments,ns:d})}}function j(o){var n=this,d=this.queue=[];this.name=o;this.call=function(){d.push(arguments)};this.call.queuer=this;this.flush=function(r,q){for(var p=0;p<d.length;p++){r.apply(q||n,d[p])}return r}}return{ost:0,cache:{},plo:[],links:[],ems:[],init:_adr.onReady,_Queuer:j,_queueFor:a,_select:k,_gebcn:l,button:a("button"),toolbox:a("toolbox"),update:a("update"),util:{getServiceName:b},addEventListener:h(_ate.ed.addEventListener,_ate.ed),removeEventListener:h(_ate.ed.removeEventListener,_ate.ed)}})()}_adr.append((function(){if(!window.addthis.ost){_ate.extend(addthis,_ate.api);var d=document,u=undefined,w=window,unaccent=function(s){if(s.indexOf("&")>-1){s=s.replace(/&([aeiou]).+;/g,"$1")}return s},customServices={},globalConfig=w.addthis_config,globalShare=w.addthis_share,upConfig={},upShare={},body=d.gn("body").item(0),mrg=function(o,n){if(n&&o!==n){for(var k in n){if(o[k]===u){o[k]=n[k]}}}},addevts=function(o,ss,au){var oldclick=o.onclick||function(){},genshare=function(){_ate.ed.fire("addthis.menu.share",window.addthis||{},{service:ss})};if(o.conf.data_ga_tracker||addthis_config.data_ga_tracker||o.conf.data_ga_property||addthis_config.data_ga_property){o.onclick=function(){_ate.gat(ss,au,o.conf,o.share);genshare();oldclick()}}else{o.onclick=function(){genshare();oldclick()}}},rpl=function(o,n){var r={};for(var k in o){if(n[k]){r[k]=n[k]}else{r[k]=o[k]}}return r},addthis=window.addthis,genieu=function(share){return"mailto:?subject="+_euc(share.title?share.title:"%20")+"&body="+_euc(share.title?share.title:"")+(share.title?"%0D%0A":"")+_euc(share.url)+"%0D%0A%0D%0AShared via AddThis.com"},b_title={email:"Email",mailto:"Email",print:"Print",favorites:"Save to Favorites",twitter:"Tweet This",digg:"Digg This",more:"View more services"},json={email_vars:1,templates:1,services_custom:1},nosend={feed:1,more:1,email:1,mailto:1},nowindow={feed:1,email:1,mailto:1,print:1,more:1,favorites:1},a_config=["username","services_custom","services_exclude","services_compact","services_expanded","ui_click","ui_hide_embed","ui_delay","ui_hover_direction","ui_language","ui_offset_top","ui_offset_left","ui_header_color","ui_header_background","ui_icons","ui_cobrand","data_use_cookies","data_track_clickback","data_track_linkback"],a_share=["url","title","templates","email_template","email_vars","html","swfurl","width","height","screenshot","author","description","content"],_svcurl=function(config,share){var sv=config.services instanceof Array?config.services[0]:config.services||"";return"http://"+_atd+"bookmark.php?v="+_atc.ver+"&pub="+_euc(_ate.pub())+"&s="+sv+(share.url?"&url="+_euc(share.url):"")+(share.title?"&title="+_euc(share.title):"")+"&tt=0"},_makeButton=function(w,h,alt,url){var img=d.ce("img");img.width=w;img.height=h;img.border=0;img.alt=alt;img.src=url;return img},_parseAttributes=function(el,attrs,overrides,childWins){var rv={};overrides=overrides||{};for(var i=0;i<attrs.length;i++){if(overrides[attrs[i]]&&!childWins){rv[attrs[i]]=overrides[attrs[i]]}else{if(el){var p="addthis:"+attrs[i],v=el.getAttribute?el.getAttribute(p)||el[p]:el[p];if(v){rv[attrs[i]]=v}else{if(overrides[attrs[i]]){rv[attrs[i]]=overrides[attrs[i]]}}if(rv[attrs[i]]==="true"){rv[attrs[i]]=true}else{if(rv[attrs[i]]==="false"){rv[attrs[i]]=false}}}}if(rv[attrs[i]]!==undefined&&json[attrs[i]]&&(typeof rv[attrs[i]]=="string")){eval("var e = "+rv[attrs[i]]);rv[attrs[i]]=e}}return rv},_processCustomServices=function(conf){var acs=(conf||{}).services_custom;if(!acs){return}if(!(acs instanceof Array)){acs=[acs]}for(var i=0;i<acs.length;i++){var service=acs[i];if(service.name&&service.icon&&service.url){service.code=service.url=service.url.replace(/ /g,"");if(service.code.indexOf("http")===0){service.code=service.code.substr((service.code.indexOf("https")===0?8:7))}service.code=service.code.split("?").shift().split("/").shift().toLowerCase();customServices[service.code]=service}}},_select=addthis._select,_getCustomService=function(ss,conf){return customServices[ss]||{}},_getATtributes=function(el,config,share,childWins){var rv={conf:config||{},share:share||{}};rv.conf=_parseAttributes(el,a_config,config,childWins);rv.share=_parseAttributes(el,a_share,share,childWins);return rv},_render=function(what,conf,attrs){_ate.igv();if(what){conf=conf||{};attrs=attrs||{};var config=conf.conf||globalConfig,share=conf.share||globalShare,onmouseover=attrs.onmouseover,onmouseout=attrs.onmouseout,onclick=attrs.onclick,internal=attrs.internal,ss=attrs.singleservice;if(ss){config.product="tbx-"+_atc.ver;if(onclick===u){onclick=nosend[ss]?function(el,config,share){var s=rpl(share,upShare);return addthis_open(el,ss,s.url,s.title,rpl(config,upConfig),s)}:nowindow[ss]?function(el,config,share){var s=rpl(share,upShare);return addthis_sendto(ss,rpl(config,upConfig),s)}:null}}else{if(!attrs.noevents){if(!attrs.nohover){if(onmouseover===u){onmouseover=function(el,config,share){return addthis_open(el,"",null,null,config,share)}}if(onmouseout===u){onmouseout=function(el){return addthis_close()}}if(onclick===u){onclick=function(el,config,share){return addthis_sendto("more",config,share)}}}else{if(onclick===u){onclick=function(el,config,share){return addthis_open(el,"more",null,null,config,share)}}}}}what=_select(what);for(var i=0;i<what.length;i++){var o=what[i],oattr=_getATtributes(o,config,share,true)||{};mrg(oattr.conf,globalConfig);mrg(oattr.share,globalShare);o.conf=oattr.conf;o.share=oattr.share;if(o.conf.ui_language){_ate.alg(o.conf.ui_language)}_processCustomServices(o.conf);if((!o.conf||!o.conf.ui_click)&&!_ate.bro.ipa){if(onmouseover){o.onmouseover=function(){return onmouseover(this,this.conf,this.share)}}if(onmouseout){o.onmouseout=function(){return onmouseout(this)}}if(onclick){o.onclick=function(){return onclick(this,this.conf,this.share)}}}else{if(onclick){if(ss){o.onclick=function(){return onclick(this,this.conf,this.share)}}else{o.onclick=function(){return addthis_open(this,"",null,null,this.conf,this.share)}}}}if(o.tagName.toLowerCase()=="a"){if(ss){var customService=_getCustomService(ss,o.conf);o.conf.product="tbx-"+_atc.ver;if(customService&&customService.code&&customService.icon){if(o.firstChild&&o.firstChild.className.indexOf("at300bs")>-1){o.firstChild.style.background="url("+customService.icon+") no-repeat top left"}}if(!nowindow[ss]){var t=_ate.trim,template=o.share.templates&&o.share.templates[ss]?o.share.templates[ss]:"",url=o.share.url||addthis_share.url,title=o.share.title||addthis_share.title,swfurl=o.share.swfurl||addthis_share.swfurl,width=o.share.width||addthis_share.width,height=o.share.height||addthis_share.height,description=o.share.description||addthis_share.description,screenshot=o.share.screenshot||addthis_share.screenshot;o.href="//"+_atd+"bookmark.php?pub="+t(addthis_config.username||o.conf.username||_ate.pub(),1)+"&v="+_atc.ver+"&source=tbx-"+_atc.ver+"&tt=0&s="+ss+"&url="+_euc(url||"")+"&title="+t(title||"",1)+"&content="+t(o.share.content||addthis_share.content||"",1)+(template?"&template="+_euc(template):"")+(o.conf.data_track_clickback||o.conf.data_track_linkback?"&sms_ss=1":"")+"&lng="+(o.conf.ui_language||_ate.lng()||"xy").split("-").shift()+(description?"&description="+t(description,1):"")+(swfurl?"&swfurl="+_euc(swfurl):"")+(attrs.issh?"&ips=1":"")+(width?"&width="+_euc(width):"")+(height?"&height="+_euc(height):"")+(screenshot?"&screenshot="+_euc(screenshot):"")+(customService&&customService.url?"&acn="+_euc(customService.name)+"&acc="+_euc(customService.code)+"&acu="+_euc(customService.url):"")+(_ate.uid?"&uid="+_euc(_ate.uid):"");addevts(o,ss,url);o.target="_blank";addthis.links.push(o)}else{if(ss=="mailto"||(ss=="email"&&(o.conf.ui_use_mailto||_ate.bro.iph||_ate.bro.ipa))){o.onclick=function(){};o.href=genieu(o.share);addevts(o,ss,url);addthis.ems.push(o)}}if(!o.title||o.at_titled){o.title=unaccent(b_title[ss]?b_title[ss]:"Send to "+addthis.util.getServiceName(ss,!customService));o.at_titled=1}}}var app;switch(internal){case"img":if(!o.hasChildNodes()){var lang=(o.conf.ui_language||_ate.lng()).split("-").shift(),validatedLang=_ate.ivl(lang);if(!validatedLang){lang="en"}else{if(validatedLang!==1){lang=validatedLang}}app=_makeButton(_ate.iwb(lang)?150:125,16,"Share",_atr+"static/btn/v2/lg-share-"+lang.substr(0,2)+".gif")}break}if(app){o.appendChild(app)}}}},buttons=addthis._gebcn(body,"A","addthis_button_",true,true),_renderToolbox=function(collection,config,share,reprocess){for(var i=0;i<collection.length;i++){var b=collection[i];if(b==null){continue}if(reprocess!==false||!b.ost){var attr=_getATtributes(b,config,share,true),hc=0,a="at300",c=b.className||"",s=c.match(/addthis_button_([\w\.]+)(?:\s|$)/),options=u,sv=s&&s.length?s[1]:0;mrg(attr.conf,globalConfig);mrg(attr.share,globalShare);if(sv){if(sv==="tweetmeme"){b.innerHTML='<iframe frameborder="0" width="50" height="61" scrolling="no" allowTransparency="true" scrollbars="no"'+(_ate.bro.ie6?" src=\"javascript:''\"":"")+"></iframe>";var tm=b.firstChild;tm.src="http://api.tweetmeme.com/button.js?url="+_euc(attr.share.url)}else{if(sv==="facebook_like"){var fblike,passthrough="",fblike_attr=[];for(var j=0;j<b.attributes.length;j++){fblike_attr=b.attributes[j].name.split("fb:like:");if(fblike_attr.length==2){passthrough+="&"+_euc(fblike_attr.pop())+"="+_euc(b.attributes[j].value)}}if(!_ate.bro.msi){fblike=d.ce("iframe")}else{b.innerHTML='<iframe frameborder="0" scrolling="no" allowTransparency="true" scrollbars="no"'+(_ate.bro.ie6?" src=\"javascript:''\"":"")+"></iframe>";fblike=b.firstChild}fblike.style.overflow="hidden";fblike.style.border="none";fblike.style.borderWidth="0px";fblike.style.width="82px";fblike.style.height="25px";fblike.style.marginTop="-2px";fblike.src="//www.facebook.com/plugins/like.php?href="+_euc(attr.share.url)+"&layout=button_count&show_faces=false&width=100&action=like&font=arial"+passthrough;if(!_ate.bro.msi){b.appendChild(fblike)}}else{if(sv.indexOf("preferred")>-1){window.addthis_product="tbx-"+_atc.ver;s=c.match(/addthis_button_preferred_([0-9]+)(?:\s|$)/);var svidx=((s&&s.length)?Math.min(12,Math.max(1,parseInt(s[1]))):1)-1;if(window._atw){var excl=_atw.conf.services_exclude,locopts=_atw.loc,opts=addthis_options.replace(",more","").split(",");if(svidx<opts.length){sv=opts[svidx];locopts=locopts.replace(sv,"").replace(",,","").replace(/,$|^,/,"")}else{if(typeof locopts!="array"){locopts=locopts.split(",")}do{if(svidx<locopts.length){sv=locopts[svidx]}else{break}}while(excl.indexOf(svidx++)==-1)}b._ips=1;if(b.className.indexOf(sv)==-1){b.className+=" addthis_button_"+sv}}else{if(attr.conf.ui_language||window.addthis_language){_ate.alg(attr.conf.ui_language)}_ate.plo.push(["deco",_renderToolbox,[b],config,share,true]);if(_ate.gssh){_ate.pld=_ate.ajs("static/r07/menu55.js")}else{if(!_ate.pld){_ate.pld=1;var loadmenu=function(){_ate.pld=_ate.ajs("static/r07/menu55.js")};if(_ate.upm){_ate._rec.push(function(data){if(data.ssh){loadmenu()}});_ate.sto(loadmenu,500)}else{loadmenu()}}}continue}}}}if(!b.childNodes.length){var sp=d.ce("span");b.appendChild(sp);sp.className=a+"bs at15t_"+sv}else{if(b.childNodes.length==1){var cn=b.childNodes[0];if(cn.nodeType==3){var sp=d.ce("span"),tv=cn.nodeValue;b.insertBefore(sp,cn);sp.className=a+"bs at15t_"+sv}}else{hc=1}}if(sv==="compact"){if(!hc&&c.indexOf(a)==-1){b.className+=" "+a+"m"}}else{if(sv==="expanded"){if(!hc&&c.indexOf(a)==-1){b.className+=" "+a+"m"}options={nohover:true,singleservice:"more"}}else{if(!hc&&c.indexOf(a)==-1){b.className+=" "+a+"b"}options={singleservice:sv}}}if(b._ips){if(!options){options={}}options.issh=true}_render([b],attr,options);b.ost=1;window.addthis_product="tbx-"+_atc.ver}}}},gat=function(s,au,conf,share){var pageTracker=conf.data_ga_tracker,propertyId=conf.data_ga_property;if(propertyId&&typeof(window._gat)=="object"){pageTracker=_gat._getTracker(propertyId)}if(pageTracker&&typeof(pageTracker)=="string"){pageTracker=window[pageTracker]}if(pageTracker&&typeof(pageTracker)=="object"){var gaUrl=au||(share||{}).url||location.href;if(gaUrl.toLowerCase().replace("https","http").indexOf("http%3a%2f%2f")==0){gaUrl=_duc(gaUrl)}try{pageTracker._trackEvent("addthis",s,gaUrl)}catch(e){try{pageTracker._initData();pageTracker._trackEvent("addthis",s,gaUrl)}catch(e){}}}};_ate.gat=gat;addthis.update=function(which,what,value){if(which=="share"){if(!window.addthis_share){window.addthis_share={}}window.addthis_share[what]=value;upShare[what]=value;for(var i in addthis.links){var o=addthis.links[i],rx=new RegExp("&"+what+"=(.*)&"),ns="&"+what+"="+_euc(value)+"&";o.href=o.href.replace(rx,ns);if(o.href.indexOf(what)==-1){o.href+=ns}}for(var i in addthis.ems){var o=addthis.ems[i];o.href=genieu(addthis_share)}}else{if(which=="config"){if(!window.addthis_config){window.addthis_config={}}window.addthis_config[what]=value;upConfig[what]=value}}};addthis._render=_render;addthis.button=function(what,config,share){_render(what,{conf:config,share:share},{internal:"img"})};addthis.toolbox=function(what,config,share){var toolboxes=_select(what);for(var i=0;i<toolboxes.length;i++){var tb=toolboxes[i],attr=_getATtributes(tb,config,share),sp=d.ce("div"),c;if(tb){c=tb.getElementsByTagName("a");if(c){_renderToolbox(c,attr.conf,attr.share)}tb.appendChild(sp)}sp.className="atclear"}};addthis.ready=function(){var at=addthis,a=".addthis_";if(at.ost){return}at.ost=1;addthis.toolbox(a+"toolbox");addthis.button(a+"button");_renderToolbox(buttons,null,null,false);_ate.ed.fire("addthis.ready",addthis);for(var i=0,plo=at.plo,q;i<plo.length;i++){q=plo[i];(q.ns?at[q.ns]:at)[q.call].apply(this,q.args)}};window.addthis=addthis;window.addthis.ready()}}));_ate.extend(addthis,{user:(function(){var f=_ate,c=addthis,g={},d=0,j;function i(a,k){return f.reduce(["getID","getServiceShareHistory"],a,k)}function h(a,k){return function(l){setTimeout(function(){l(f[a]||k)},0)}}function b(){if(d){return}if(j!==null){clearTimeout(j)}j=null;d=1;i(function(l,a,k){g[a]=g[a].queuer.flush(h.apply(c,l[k]),c);return l},[["uid",""],["_ssh",[]]])}f._rec.push(b);j=setTimeout(b,5000);g.getPreferredServices=function(a){if(window._atw){a(addthis_options.split(","))}else{f.plo.push(["pref",a]);_ate.alg();if(f.gssh){f.pld=f.ajs("static/r07/menu55.js")}else{if(!f.pld){f.pld=1;_ate._rec.push(function(k){if(k.ssh){_ate.pld=_ate.ajs("static/r07/menu55.js")}})}}}};return i(function(k,a){k[a]=(new c._Queuer(a)).call;return k},g)})()});