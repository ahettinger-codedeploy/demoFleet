(function(){var c=document,d="length",e=" translation",h=" using Google Translate?",i=".",j="Google has automatically translated this page to: ",k="Powered by ",l="Translate everything to ",m="Translate this page to: ",n="Translated to: ",o="Turn off ",p="Turn off for: ",q="View this page in: ",r="var ",t=this;function u(a,s){var f=a.split(i),b=t;!(f[0]in b)&&b.execScript&&b.execScript(r+f[0]);for(var g;f[d]&&(g=f.shift());)!f[d]&&void 0!==s?b[g]=s:b=b[g]?b[g]:b[g]={}}Math.floor(2147483648*Math.random()).toString(36);var v={"0":"Translate",1:"Cancel",2:"Close",3:function(a){return j+a},4:function(a){return n+a},5:"Error: The server could not complete your request. Try again later.",6:"Learn more",7:function(a){return k+a},8:"Translate",9:"Translation in progress",10:function(a){return m+(a+h)},11:function(a){return q+a},12:"Show original",13:"The content of this local file will be sent to Google for translation using a secure connection.",14:"The content of this secure page will be sent to Google for translation using a secure connection.",
15:"The content of this intranet page will be sent to Google for translation using a secure connection.",16:"Select Language",17:function(a){return o+(a+e)},18:function(a){return p+a},19:"Always hide",20:"Original text:",21:"Contribute a better translation",22:"Contribute",23:"Translate all",24:"Restore all",25:"Cancel all",26:"Translate sections to my language",27:function(a){return l+a},28:"Show original languages",29:"Options",30:"Turn off translation for this site",31:null,32:"Show alternative translations",
33:"Click on words above to get alternative translations",34:"Use",35:"Drag with shift key to reorder",36:"Click for alternate translations",37:"Hold down the shift key, click, and drag the words above to reorder.",38:"Thank you for contributing your translation suggestion to Google Translate.",39:"Manage translation for this site"};var w=window.google&&google.translate&&google.translate._const;
if(w){var x;a:{for(var y=[],z=["7,0.001,20120130"],A=0;A<z[d];++A){var B=z[A].split(","),C=B[0];if(C){var D=Number(B[1]);if(D&&!(0.1<D||0>D)){var E=Number(B[2]),F=new Date,G=1E4*F.getFullYear()+100*(F.getMonth()+1)+F.getDate();E&&!(E<G)&&y.push({version:C,a:D,b:E})}}}for(var H=0,I=window.location.href.match(/google\.translate\.element\.random=([\d\.]+)/),J=Number(I&&I[1])||Math.random(),A=0;A<y[d];++A){var K=y[A],H=H+K.a;if(1<=H)break;if(J<H){x=K.version;break a}}x="6"}var L="/translate_static/js/element/%s/element_main.js".replace("%s",
x);if("0"==x){var M=",translate_static,js,element,%s,element_main.js".split(",");M[M[d]-1]="main.js";L=M.join("/").replace("%s",x)}var N=("https:"==window.location.protocol?"https://":"http://")+w._pah+L,O=c.createElement("script");O.type="text/javascript";O.charset="UTF-8";O.src=N;var P=c.getElementsByTagName("head")[0];P||(P=c.body.parentNode.appendChild(c.createElement("head")));P.appendChild(O);u("google.translate.m",v);u("google.translate.v",x)};})()
