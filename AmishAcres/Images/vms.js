(function(g,e){e.bcLoaded=true;var b=function(){return new Date().getTime()},d=function(m,k,j){var n,l=m.indexOf(k+"=");if(l!=-1){l+=k.length+1;n=m.indexOf(j,l);return m.substring(l,n==-1?m.length:n)}},f=function(j){return d(g.cookie,j,";")},i=function(k,m,o){var j=o&&new Date(b()+o),l=g.location.host,n=l.indexOf(".");l=n==l.lastIndexOf(".")?"."+l:l.substring(n);g.cookie=k+"="+m+(o?";expires="+j.toUTCString():"")+";domain="+(e._bcvm.domain||l)+";path="+(e._bcvm.path||"/")},c=function(j){return d(g.location.href,j,"&")},a=function(l){var m={};for(var j in l){m[j]=l[j]}return m};host=".boldchat.com/aid/";e._bcvm=e._bcvm||{getCookie:f,setCookie:i,addEvent:function(m,p,l){var j="on"+p,k=m[j];if(m.addEventListener){m.addEventListener(p,l,false)}else{if(m.attachEvent){m.attachEvent(j,l)}else{m[j]=function(n){l(n);return k(n)}}}},loadScript:function(l){var j=g.getElementsByTagName("head")[0]||g.body;var k=g.createElement("script");k.id="bcvm_script_"+new Date().getTime();k.async=true;k.type="text/javascript";k.src=l;j.appendChild(k)},textButtons:{},getPageViewer:function(al){var H=setTimeout,af=clearTimeout,p=new Image(),aA=[],az=0,L=new Image(),am=function(){return(K?2:1)*(az>=60000?(az>=600000?(az>=3600000?(az>=14400000?(az>=43200000?300:180):120):60):30):(az>=10000?(az>=30000?30:30):30))*1000},J=g.location.protocol,Y="https:"==J?"https://":"http://",T=(J=="https:"||J=="http:")&&true,z,v,K=false,ac,U=false,t,l,av,F,r,k="",D,W,ax,B="SecureParameters",M={VisitRef:"vr",VisitInfo:"vi",VisitName:"vn",VisitPhone:"vp",VisitEmail:"ve"},V={WindowParameters:"&",OpenParameters:","},ad={OpenParameters:"op",InvitationID:"idid",InvitationDefID:"idid",WindowScheme:"cp",CharSet:".cs",CustomUrl:"curl",ChatWidth:"cwidth",ChatHeight:"cheight",CallWidth:"pwidth",CallHeight:"pheight",ChatWindowID:"cwdid",ChatWindowDefID:"cwdid",CallWindowDefID:"pwdid",Language:"lc",Difficulty:"Difficulty",Urgency:"Urgency"},ai={ConversionCodeID:"ccid",ConversionAmount:"ca",ConversionRef:"cr",ConversionInfo:"ci"},au={WindowScheme:Y,ChatWidth:640,ChatHeight:480,CallWidth:480,CallHeight:360},ae={},ab=function(){return Math.floor(parseFloat(al)*99/1000000+(b()-1332800000000)+Math.random()*1000000)+""+Math.floor(1000+Math.random()*(10000-1000))},j=function(aB){e._bcvm.domain=aB},G=function(aB){e._bcvm.path=aB},Q=function(aC,aB,aD){ac=aD;k=u("wdid",ag("WebsiteDefID")||ag("WebsiteID"))+u("pvid",ac);N(aC,aB);q=true;aj()},N=function(aC,aB){av=ag("WebsiteDefID")||ag("WebsiteID")||al;F="_bcvm_vid_"+av;r="_bcvm_vrid_"+av;t=aB||T&&f(F)||c(F)||t;l=aC||T&&f(r)||c(r)||l;if(t&&T){i(F,t)}if(l&&T){i(r,l,365*86400000)}},ar=function(aC,aB){N();var aD=aC.indexOf("#");return aC.substring(0,aD==-1?aC.length:aD)+(aC.indexOf("?")==-1?"?":"")+(T?u("_bcvm_vrid_","true"):"")+u(F,t)+u(r,l)+(aB?"":u("curl",au.CustomUrl)+"&"+(au.WindowParameters||""))+(aD==-1?"":aC.substring(aD))},s=function(aC,aB){for(var aD=0;aD<aa.length;aD++){aC=aa[aD](aC,aB)}return aC},aa=[ar],P=function(aB){aa.push(aB)},ak=function(aB){for(var aC=0;aC<aa.length;aC++){if(aa[aC]==aB){aa.splice(aC,1)}}},at=function(){return ac},C=function(aB){al=aB;e._bcvm.host=host+al},ao=function(aC,aG){if(!aC){return{}}var aF=aC.split(aG),aB,aE,aD={};for(aB=0;aB<aF.length;aB++){aE=aF[aB].indexOf("=");aD[aE==-1?aF[aB]:aF[aB].substring(0,aE)]=aE==-1?null:aF[aB].substring(aE+1)}return aD},n=function(aF,aD,aH){if(!aH){return aD||aF}var aB=ao(aF,aH),aC=ao(aD,aH),aG="";for(var aE in aC){if(!aB[aE]||aC[aE]){aB[aE]=aC[aE]}}for(var aE in aB){if(aG!=""){aG+=aH}aG+=aE+(aB[aE]==null?"":"="+aB[aE])}return aG},x=function(aD,aB,aC){au[aD]=aC?aB:n(au[aD],aB,V[aD])},ag=function(aD,aC){var aB=(aC?aC[aD]:null)||(aC&&aC.id&&ae[aC.id]?ae[aC.id][aD]:null)||au[aD]||"";return aB},y=function(aH,aD){var aC={};var aG=ag("WindowParameters",aD);if(aG&&aG.length){var aF=aG.split(V.WindowParameters);for(var aB=0;aB<aF.length;aB++){var aE=aF[aB].split("=");aC[aE[0]&&decodeURIComponent(aE[0])]=aE[1]&&decodeURIComponent(aE[1])}}return ag(aH,aD)||aC[aH]||aC[M[aH]]||aC[ad[aH]]},u=function(aD,aB,aC){return aB&&aB!=""?(aC?"?":"&")+aD+"="+(encodeURIComponent||escape)(typeof aB=="function"?aB():aB):""},R=function(aE,aD){var aC="",aB;for(var aF in aE){aC+=u(aE[aF],ag(aF,aD))}return aC},m=function(){i("bc_pv_end",ac,30000)},aq=function(){K=false;var aB=am()-(b()-v-az);if(z){af(z);z=null;if(aB>0){z=H(Z,aB)}else{ah()}}},S=function(){K=true},ap={id:"pageView"},ay=function(){var aC=p.width&7,aB=p.height;O(aB,aC)},E=null,O=function(aB,aC){if(aC==2){af(z);z=null}if(aC==3){w(D,"")}},Z=function(){ah()},ah=function(aB){az=b()-v;var aC=s(Y+"vmp"+host+al+"/bc.vm?blur="+K+"&poll="+(5000+2*am())+k+"&"+b());p.src=aC;if(!aB){z=H(Z,am())}},X=function(aB,aC){w(null,null,aB,aC)},q=true,aj=function(){var aF=e._bcvma||[],aC=aF.length||0;e._bcvma=[];for(var aD=0;aD<aF.length||0;aD++){var aH=aF[aD],aE=(aH||[])[0];if(aE=="pageViewed"&&aD<aC){ae[ap.id]=a(au);aF.push(aH)}else{var aB=h[aE];if(aB){aB(aH[1],aH[2])}}}if(q){var aG=e._bcct||[];e._bcct=[];for(var aD=0;aD<aG.length;aD++){I(aG[aD])}}},A=function(aB){e._bcct=e._bcct||[];e._bcct.push(aB)},I=function(aD,aF,aC){if(aF&&aD[B]){return true}for(var aE in ai){x(aE,null,true)}for(var aE in aD){if(aD[aE]&&aD[aE]!=""){x(aE,aD[aE])}}if(!aC){aC=ag(B)}if(typeof aC=="function"){aC=aC(function(aG){I(aD,aF,aG)},"conversion");if(!aC){return}}if(!aF){var aB=new Image();aB.src=s(Y+"vms"+host+al+"/bc.vci?"+b()+(k||u("wdid",ag("WebsiteDefID")||ag("WebsiteID")))+R(M)+R(ai)+u("secured",aC));aA.push(aB)}},an=function(){var aD=screen,aE=e.devicePixelRatio||(aD.deviceXDPI||1)/(aD.logicalXDPI||1),aB=aE,aH=g.createElement("div"),aC="height: 1in; left: -100%; position: absolute; top: -100%; width: 10%;";aH.setAttribute("style",aC);try{g.body.appendChild(aH)}catch(aG){try{g.body.insertBefore(aH,g.body.firstChild)}catch(aG){}}if(Math.abs(aD.width/aH.offsetWidth/10-aB)/aB<0.2){aB=1}var aF=(aD&&aD.width&&aD.height?"&swidth="+(aD.width*aB)+"&sheight="+(aD.height*aB):"")+(aH&&aH.offsetWidth?"&sdpi="+(96*aE):"");try{g.body.removeChild(aH)}catch(aG){}return aF},w=function(aC,aK,aD,aL,aH,aF){if(!aF){aF=ag(B,ap)}if(typeof aF=="function"){aF=aF(function(aN){w(aC,aK,aD,aL,aH,aN)},"visit");if(!aF){return}}var aG=[],aJ,aM=ac||f("bc_pv_end"),aE=e.hideBox||e.bt_hideAnimationImpl;if(!aD&&!aH){q=false;aG=e._bcct||[];e._bcct=aG}if(aM){i("bc_pv_end","",0)}D=aC||g.location.href;ax=aK||g.referrer;if(D.indexOf("bc_ignore_vm")!=-1){aH=true}az=0;v=b();if(z&&!aH){af(z)}var aI=aG[0]&&I(aG[0],true);if(aG[0]&&!aI){e._bcct=aG.splice(1)}p.onload=ay;if(!aD&&!aH){ac=null}k=u("wdid",ag("WebsiteDefID",ap)||ag("WebsiteID",ap))+u("pvid",ac);var aB=s(Y+"vms"+host+al+"/bc.pv?blur="+K+"&vm="+!aH+"&poll="+(5000+2*am())+an()+(aD?u("reinvite",aD)+u("adi",aL):u("vpvid",c("vpvid"))+u("pve",aM)+u("url",D)+u("referrer",ax)+R(M,ap))+u("secured",aF)+k+R(ad,ap)+(aI?"":R(ai))+"&"+b());_bcvm.loadScript(aB.replace("?","?script=true&securevm=true&"));if(!aH){z=H(Z,am())}},aw=function(aB){if(_bcvmw){_bcvmw.customChatWindow=aB}},o=function(){return l};_bcvm.addEvent(e,"beforeunload",m);_bcvm.addEvent(e,"focus",aq);_bcvm.addEvent(e,"blur",S);_bcvm.pageViewer={set:Q,doExperiments:at,setAccountID:C,setDomain:j,setPath:G,pageViewed:w,load:aj,reinvite:X,check:O,getParameter:ag,getWindowParameter:y,setParameter:x,setCustomChatWindow:aw,getVisitorID:o,addConversion:A,conversion:I,link:s,removeLink:ak,addLink:P};return _bcvm.pageViewer},select:function(m){if(!g.getElementsByTagName){return[]}m=m.replace(/\s*([^\w])\s*/g,"$1");var D=[],q=m.split(","),z,L,k,J,p;var q=m.split(",");var y=function(S,P){if(!P){P="*"}z=[];for(var Q=0,o=S.length;p=S[Q],Q<o;Q++){var l;if(P=="*"){l=p.all?p.all:p.getElementsByTagName("*")}else{l=p.getElementsByTagName(P)}for(var j=0,R=l.length;j<R;j++){z.push(l[j])}}};COMMA:for(var M=0,v=q.length;L=q[M],M<v;M++){var n=[g],A=L.split(" ");SPACE:for(var K=0,u=A.length;k=A[K],K<u;K++){var t=k.indexOf("["),r=k.indexOf("]"),s=k.indexOf("#");if(s+1&&!(s>t&&s<r)){var E=k.split("#"),O=E[0],B=E[1],x=g.getElementById(B);if(!x||(O&&x.nodeName.toLowerCase()!=O)){continue COMMA}n=[x];continue SPACE}s=k.indexOf(".");if(s+1&&!(s>t&&s<r)){var E=k.split("."),O=E[0],I=E[1];y(n,O);n=[];for(var H=0,N=z.length;J=z[H],H<N;H++){if(J.className&&J.className.match(new RegExp("(^|s)"+I+"(s|$)"))){n.push(J)}}continue SPACE}if(k.indexOf("[")+1){if(k.match(/^(\w*)\[(\w+)([=~\|\^\$\*]?)=?['"]?([^\]'"]*)['"]?\]$/)){var O=RegExp.$1,G=RegExp.$2,w=RegExp.$3,F=RegExp.$4}y(n,O);n=[];for(var H=0,N=z.length;J=z[H],H<N;H++){if(w=="="&&J.getAttribute(G)!=F){continue}if(w=="~"&&!J.getAttribute(G).match(new RegExp("(^|\\s)"+F+"(\\s|$)"))){continue}if(w=="|"&&!J.getAttribute(G).match(new RegExp("^"+F+"-?"))){continue}if(w=="^"&&J.getAttribute(G).indexOf(F)!=0){continue}if(w=="$"&&J.getAttribute(G).lastIndexOf(F)!=(J.getAttribute(G).length-F.length)){continue}if(w=="*"&&!(J.getAttribute(G).indexOf(F)+1)){continue}else{if(!J.getAttribute(G)){continue}}n.push(J)}continue SPACE}y(n,k);n=z}for(var C=0,N=n.length;C<N;C++){D.push(n[C])}}return D}};var h=e.pageViewer||e._bcvm.getPageViewer();e.pageViewer=h;e.pageViewer.load()})(document,window);