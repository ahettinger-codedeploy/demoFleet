function gup(e){e=e.replace(/[\[]/,"\\[").replace(/[\]]/,"\\]");var t="[\\?&]"+e+"=([^&#]*)";var n=new RegExp(t);var r=n.exec(window.location.href);if(r==null)return"";else return r[1]}_cq_analytics=function(){return new _sw_analytics};_sw_analytics=function(){return{id:null,d:document,crypto:new _sw_crypto,hit:new _sw_hit_info,cookie:new _sw_cookie,user:new _sw_user_info,transaction:null,use_connect:true,connect_lead_id:null,debug:false,b:false,use_tradedesk:false,tradedesk_info:null,use_mongoose:function(e){this.is_mongoose=true;this.mongoose_code=e},pl:0,pc:0,set_beta:function(e){this.b=e},get_domain:function(){if(this.hit.domain!=null){return this.hit.domain}else{return this.d.domain}},get_page:function(){if(this.hit.page!=null){return this.hit.page}else{return this.d.location.href}},set_goal:function(e){this.hit.set_goal(e)},get_os:function(){try{var e=navigator.userAgent;var t=new RegExp(/\([^\)]*\)/gi);var n=t.exec(e)[0];n=n.replace(/(\(|\))/gi,"");n=n.split("; ");if(e.toLowerCase().indexOf("opera")>-1){osv=n[0]}else{osv=n[2]}return osv}catch(r){return"-"}},get_browser:function(){var e=navigator.userAgent;var t=new RegExp(/\([^\)]*\)/gi);var n=t.exec(e);if(n){uapl=n[0].replace(/(\(|\))/gi,"").split("; ");if(uapl&&uapl.length>1){if(uapl[1].toLowerCase()=="u"|uapl[1].toLowerCase()=="i"|uapl[1].toLowerCase()=="n"){enctype=uapl[1]}else{enctype="-"}if(e.toLowerCase().indexOf("msie")>-1){vers=uapl[1]}oa=e.replace(n,"");oa=oa.replace(/(\(|\))/gi,"");oa=oa.replace(/\s{2,}/gi," ");if(oa){oa=oa.split(" ");if(oa.length>2){vers=oa[2]}if(e.toLowerCase().indexOf("safari")>-1){vers=oa[6]}if(e.toLowerCase().indexOf("opera")>-1){vers=oa[0]}if(e.toLowerCase().indexOf("chrome")>-1){vers=oa[5]}}}else{vers="unknown"}}else{if(navigator.appName){vers=navigator.appName+" "+naviigator.appVersion}else{vers="unknown"}}return vers},get_flash:function(){var fver="0";var flash;if(navigator.plugins&&navigator.plugins.length){for(var ve=0;ve<navigator.plugins.length;ve++){if(navigator.plugins[ve].name.indexOf("Shockwave Flash")!=-1){fver=navigator.plugins[ve].description.split("Shockwave Flash ")[1];break}}}else if(window.ActiveXObject){for(var v=10;v>=2;v--){try{flash=eval("new ActiveXObject('ShockwaveFlash.ShockwaveFlash."+v+"');");if(flash){fver=v+".0";break}}catch(e){}}}return fver},get_java:function(){var e=0;return e},get_referrer:function(){var e=this.d.referrer;if(e&&e!=""){return e}else{return"-"}},get_plugins:function(){var e="";if(navigator.plugins&&navigator.plugins.length>0){this.pc=navigator.plugins.length;for(var t=0;t<navigator.plugins.length;t++){e+=this.handle_undefined(navigator.plugins[t].name)+this.handle_undefined(navigator.plugins[t].description)+this.handle_undefined(navigator.plugins[t].filename);for(var n=0;n<navigator.plugins[t].length;n++){e+=this.handle_undefined(navigator.plugins[t][n].description)+this.handle_undefined(navigator.plugins[t][n].type)}}}else if(window.ActiveXObject){e=this.get_plugins_ie()}return e},get_plugins_ie:function(){var e=["AcroPDF.PDF","PDF.PdfCtrl","ShockwaveFlash.ShockwaveFlash","QuickTime.QuickTime","rmocx.RealPlayer G2 Control","rmocx.RealPlayer G2 Control.1","RealPlayer.RealPlayer(tm) ActiveX Control (32-bit)","RealVideo.RealVideo(tm) ActiveX Control (32-bit)","RealPlayer","SWCtl.SWCtl","WMPlayer.OCX","AgControl.AgControl"];var t="";this.pc=0;for(var n=0;n<e.length;n++){try{control=new ActiveXObject(e[n]);t+=e[n];this.pc++}catch(r){continue}try{t+=control.GetVariable("$version")}catch(r){}try{t+=control.GetVersions()}catch(r){}try{t+=control.QuickTimeVersion.toString(16)}catch(r){}try{t+=control.GetVersionInfo()}catch(r){}try{t+=control.ShockwaveVersion("")}catch(r){}try{t+=!control.versionInfo?"":control.versionInfo}catch(r){}}return t},get_fp:function(){return this.crypto.hash(this.get_raw_fp())},get_raw_fp:function(){var e=new Date("1/1/2011");var t="GMT"+e.getTimezoneOffset()/60*-1;var n=this.get_plugins();var r=navigator.userAgent;this.pl=n.length;return n+r+t+screen.width+screen.height+screen.colorDepth},handle_undefined:function(e){if(e=="undefined"){return""}else{return e}},create_dom_img:function(e,t){var n=new Image(1,1);n.src=e;n.onload=function(){n.onload=null;if(typeof t=="function"){t(null,e)}};n.onerror=function(){n.onerror=null;if(typeof t=="function"){t(new Error("Pixel load failure"),e)}};if(this.is_mongoose){this.init_mongoose()}},debug_hit:function(e){var t=document.getElementById("_sw_debug");if(t==null){var n=document.createElement("div");n.attributes["id"]="_sw_debug";document.appendChild(n);t=document.getElementById("_sw_debug")}t.innerHTML=e.replace(/\&/gi,"<br/>")},register_page_view:function(e){if(this.use_tradedesk){if(this.debug)this.query_tradedesk_debug();else this.query_tradedesk(e)}else{var t=this.get_page_view_url();if(this.debug)this.debug_hit(t);else this.create_dom_img(t,e)}},get_page_view_url:function(){var e="_sw_yolaid="+this.id;e+="&_sw_uid="+this.user.get_sw_uid();e+="&_sw_fp="+this.get_fp();e+="&_sw_pl="+this.pl;e+="&_sw_pc="+this.pc;e+="&_sw_dat=";var t=(navigator.cookieEnabled?1:0)+"|";t+=this.get_domain()+"|";t+=this.get_page().replace(/\|/gi,"&")+"|";t+=(navigator.browserLanguage!=null?navigator.browserLanguage:navigator.language)+"|";t+=screen.width+"|";t+=screen.height+"|";t+=screen.colorDepth+"|";t+=this.get_browser()+"|";t+=this.get_os()+"|";t+=(this.get_java()!=-1?1:0)+"|";t+=this.get_java()+"|";t+=(this.get_flash()!=-1?1:0)+"|";t+=this.get_flash()+"|";t+=this.get_referrer().replace(/\|/gi,"&")+"|";t+=this.user.get_site_unique_id()+"|";t+=(this.hit.goal!=""?this.hit.goal:"-")+"|";if(this.use_tradedesk&&this.tradedesk_info!=null){t+=this.tradedesk_info.TDID}else{t+="-"}if(this.connect_lead_id!=null){t+="|"+this.connect_lead_id}else{t+="|-"}var n=new Date;var r=e+_sw_b6.e(t);if(this.transaction!=null){r+=this.transaction.get_transaction_b6()}r+="&to="+n.getMilliseconds();this.user.set_sw_uid(this.user.get_sw_uid());_dp=window.location.protocol;var i=(this.b?"beta":"")+"analytics.sitewit.com/images/cq_blank.gif?"+r;switch(_dp){case"http:":i="http://"+i;break;case"https:":i="https://"+i;break}return i},query_tradedesk:function(e){var t=document.getElementsByTagName("head")[0]||document.documentElement;var n=document.createElement("script");var r="https:"==document.location.protocol?"https://insight.":"http://insight.";n.setAttribute("src",r+"adsrvr.org/track/evnt?fmt=2&callback=sw.td_callback");n.setAttribute("type","text/javascript");n.onerror=function(){sw.td_callback(null,e)};t.appendChild(n)},td_callback:function(e,t){this.tradedesk_info=e;var n=this.get_page_view_url();this.create_dom_img(n,t)},query_tradedesk_debug:function(){var e=document.getElementsByTagName("head")[0]||document.documentElement;var t=document.createElement("script");var n="https:"==document.location.protocol?"https://insight.":"http://insight.";t.setAttribute("src",n+"adsrvr.org/track/evnt?fmt=2&callback=sw.td_callback");t.setAttribute("type","text/javascript");t.onerror=function(){sw.td_callback_debug(null)};e.appendChild(t)},td_callback_debug:function(e){this.tradedesk_info=e;var t=this.get_page_view_url();this.debug_hit(t)},create_transaction:function(e,t,n,r,i,s,o){this.transaction=new _sw_transaction;this.transaction.orderid=e;this.transaction.affiliation=t;this.transaction.subtotal=n;this.transaction.tax=r;this.transaction.city=i;this.transaction.state=s;this.transaction.country=o;return this.transaction},init_mongoose:function(){function r(){mm_onload="1";default_number="";var e=window.onload;var t=document.createElement("script");var n="https:"==document.location.protocol?"https://":"http://";t.src=unescape(n+"www.mongoosemetrics.com/jsfiles/js-correlation/mm-control.php?"+mm_variables);t.type="text/javascript";document.getElementsByTagName("head").item(0).appendChild(t);t.onload=function(){if(!t.loaded){var n=window.onload;keyword_ppc=gup("utm_term");if(keyword_ppc=="{keyword:nil}"||keyword_ppc=="nil"){keyword_ppc=""}if(n!=null){n();window.onload=e}}};t.onreadystatechange=function(){if((t.readyState==="loaded"||t.readyState==="complete")&&!t.loaded){var n=window.onload;keyword_ppc=gup("utm_term");if(keyword_ppc=="{keyword:nil}"||keyword_ppc=="nil"){keyword_ppc=""}if(n!=null){n();window.onload=e}}}}var e=gup("mm_campaign");if(e==undefined||e==""){mm_c=this.mongoose_code}mm_debug=0;custom1=this.id;if(this.user){custom2=this.user.get_sw_uid()}var t=document.createElement("script");var n="https:"==document.location.protocol?"https://":"http://";t.src=n+"www.mongoosemetrics.com/jsfiles/js-correlation/mm-getvar.js";t.type="text/javascript";t.onload=function(){if(!t.loaded){r()}};t.onreadystatechange=function(){if((t.readyState==="loaded"||t.readyState==="complete")&&!t.loaded){r()}};document.getElementsByTagName("head").item(0).appendChild(t)}}};_sw_cookie=function(){return{me:null,_sw_cookie:function(){me=this},write:function(e,t,n){var r=location.hostname;var i=r.split(".");if(n){var s=new Date;s.setTime(s.getTime()+n*24*60*60*1e3);var o="; expires="+s.toGMTString()}else{var o=""}if(i.length>2){r=i[i.length-2]+"."+i[i.length-1]}document.cookie=e+"="+t+o+"; path=/; domain="+r},read:function(e){var t=e+"=";var n=document.cookie.split(";");for(var r=0;r<n.length;r++){var i=n[r];while(i.charAt(0)==" "){i=i.substring(1,i.length)}if(i.indexOf(t)==0){return i.substring(t.length,i.length)}}return""},clear:function(e){this.write(e,"")}}};_sw_user_info=function(){return{c:new _sw_cookie,get_sw_uid:function(){var e=this.c.read("_swa_u");if(e==""){return"c45c2bcb-c5f3-413b-84cb-95d583ff0396"}else{return e}},get_site_unique_id:function(){return _sw_b6.d(this.c.read("_swa_su"))},set_site_unique_id:function(e){this.c.write("_swa_su",_sw_b6.e(e),1e3)},set_sw_uid:function(e){this.c.write("_swa_u",e,1e3)}}};_sw_hit_info=function(){return{page:null,domain:null,goal:"",set_page:function(e){this.page=e},set_domain:function(e){this.domain=e},set_goal:function(e){this.goal=e}}};_sw_item=function(){return{orderid:null,sku:null,productname:null,category:null,price:null,quantity:null}};_sw_transaction=function(){return{orderid:null,affiliation:null,subtotal:null,tax:null,city:null,state:null,country:null,items:new Array,add_item:function(e,t,n,r,i){itm=new _sw_item;itm.orderid=this.orderid;itm.sku=e;itm.name=t;itm.category=n;itm.price=r;itm.quantity=i;this.items.push(itm)},get_transaction_b6:function(){var e=this.orderid+"|"+(this.affiliation?this.affiliation.toString():"").replace(/\|/gi," ")+"|"+this.subtotal+"|"+this.tax+"|"+this.city+"|"+this.state+"|"+this.country;e=_sw_b6.e(e);var t="";for(x=0;x<this.items.length;x++){itm=this.items[x];t+=itm.orderid+"|"+itm.sku+"|"+(itm.name?itm.name.toString():"").replace(/\|/gi," ")+"|"+(itm.category?itm.category.toString():"").replace(/\|/gi," ")+"|"+itm.price+"|"+itm.quantity+":::"}t=_sw_b6.e(t);return"&_sw_trans="+e+"&_sw_itms="+t}}};_sw_crypto=function(){return{rot_l:function(e,t){var n=e<<t|e>>>32-t;return n},lsb_hex:function(e){var t="";var n;var r;for(var i=0;i<=6;i+=2){n=e>>>i*4+4&15;r=e>>>i*4&15;t+=n.toString(16)+r.toString(16)}return t},to_hex:function(e){var t="";var n;for(var r=7;r>=0;r--){n=e>>>r*4&15;t+=n.toString(16)}return t},toUTF8:function(e){var t="";e=e.replace(/\r\n/g,"\n");for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192)+String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224)+String.fromCharCode(r>>6&63|128)+String.fromCharCode(r&63|128)}}return t},hash:function(e){var t,n,r,i,s,o,u,a,f;var l=new Array(80);var c=1732584193;var h=4023233417;var p=2562383102;var d=271733878;var v=3285377520;e=this.toUTF8(e);var m=e.length;var g=new Array;for(n=0;n<m-3;n+=4){r=e.charCodeAt(n)<<24|e.charCodeAt(n+1)<<16|e.charCodeAt(n+2)<<8|e.charCodeAt(n+3);g.push(r)}switch(m%4){case 0:n=2147483648;break;case 1:n=e.charCodeAt(m-1)<<24|8388608;break;case 2:n=e.charCodeAt(m-2)<<24|e.charCodeAt(m-1)<<16|32768;break;case 3:n=e.charCodeAt(m-3)<<24|e.charCodeAt(m-2)<<16|e.charCodeAt(m-1)<<8|128;break}g.push(n);while(g.length%16!=14)g.push(0);g.push(m>>>29);g.push(m<<3&4294967295);for(t=0;t<g.length;t+=16){for(n=0;n<16;n++)l[n]=g[t+n];for(n=16;n<=79;n++)l[n]=this.rot_l(l[n-3]^l[n-8]^l[n-14]^l[n-16],1);i=c;s=h;o=p;u=d;a=v;for(n=0;n<=19;n++){f=this.rot_l(i,5)+(s&o|~s&u)+a+l[n]+1518500249&4294967295;a=u;u=o;o=this.rot_l(s,30);s=i;i=f}for(n=20;n<=39;n++){f=this.rot_l(i,5)+(s^o^u)+a+l[n]+1859775393&4294967295;a=u;u=o;o=this.rot_l(s,30);s=i;i=f}for(n=40;n<=59;n++){f=this.rot_l(i,5)+(s&o|s&u|o&u)+a+l[n]+2400959708&4294967295;a=u;u=o;o=this.rot_l(s,30);s=i;i=f}for(n=60;n<=79;n++){f=this.rot_l(i,5)+(s^o^u)+a+l[n]+3395469782&4294967295;a=u;u=o;o=this.rot_l(s,30);s=i;i=f}c=c+i&4294967295;h=h+s&4294967295;p=p+o&4294967295;d=d+u&4294967295;v=v+a&4294967295}var f=this.to_hex(c)+this.to_hex(h)+this.to_hex(p)+this.to_hex(d)+this.to_hex(v);return f.toLowerCase()}}};var _sw_b6={_k:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",e:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=_sw_b6.ue(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._k.charAt(s)+this._k.charAt(o)+this._k.charAt(u)+this._k.charAt(a)}return t},d:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._k.indexOf(e.charAt(f++));o=this._k.indexOf(e.charAt(f++));u=this._k.indexOf(e.charAt(f++));a=this._k.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=this.ud(t);return t},ue:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},ud:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};var _swInitPageRegister=function(){sw.id="8A4986CA2C2DD9ED012C2F6A0F7E21DB";if(typeof swPreRegister=="function"){swPreRegister()}sw.register_page_view();if(typeof swPostRegister=="function"){swPostRegister()}try{switch(sw.get_browser().split("/")[0]){case"Firefox":if(parseInt(sw.get_browser().split("/")[1])<6){sw.use_connect=false}break}}catch(e){}if(sw.use_connect){var t="https:"==document.location.protocol?"https://"+(sw.b?"beta":"")+"connect.":"http://"+(sw.b?"beta":"")+"connect.";!function(e,t,n){function r(){for(;u[0]&&"loaded"==u[0][l];)o=u.shift(),o[f]=!a.parentNode.insertBefore(o,a)}for(var i,s,o,u=[],a=e.scripts[0],f="onreadystatechange",l="readyState";i=n.shift();)s=e.createElement(t),"async"in a?(s.async=!1,e.head.appendChild(s)):a[l]?(u.push(s),s[f]=r):e.write("<"+t+' src="'+i+'" defer></'+t+">"),s.src=i}(document,"script",[t+"sitewit.com/js/"+sw.id+"/sw_connect.js?"+(location.search.indexOf("swc")>0?"ts="+Math.floor(Math.random()*1e5)+"&":"")+"&ispartner=yola"])}};if(typeof sw=="undefined"){var sw=new _sw_analytics}else if(typeof sw!="object"){sw=new _sw_analytics}_swInitPageRegister();