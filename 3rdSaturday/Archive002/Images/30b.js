var s_un,s_ios=0,s_code='',code='',pageName,server,channel,pageType,
pageValue,product,prop1,prop2,prop3,prop4,prop5,prop6,prop7,prop8,
prop9,prop10,prop11,prop12,prop13,prop14,prop15,prop16,prop17,prop18,
prop19,prop20,
s_vb,s_e=false,s_n=navigator,s_u=s_n.userAgent,s_apn=s_n.appName,s_w=
s_n.appVersion,s_apv,s_i,s_ie=s_w.indexOf('MSIE '),s_ns6=s_u.indexOf(
'Netscape6/');if(s_w.indexOf('Opera')>=0||s_u.indexOf('Opera')>=0)
s_apn='Opera';if(s_ie>0){s_apv=parseInt(s_i=s_w.substring(s_ie+5));if(
s_apv>3)s_apv=parseFloat(s_i);}else if(s_ns6>0)s_apv=parseFloat(
s_u.substring(s_ns6+10));else s_apv=parseFloat(s_w);if(s_apv>=4&&s_apn
!='Opera'&&(s_ns6<0||s_apv>=6.1))s_ios=1;function s_it(un){var imn=
's_i_'+un;if(s_ios&&!document.images[imn])document.write('<im'
+'g name="'+imn+'" height=1 width=1>')}function s_rep(s,o,n){var c=
s.indexOf(o);while(c>=0){s=s.substr(0,c)+n+s.substr(c+1,s.length);c=
s.indexOf(o)}return s}function s_esc(s){return s_rep(escape(s),'+',
'%2B')}function s_et(){window.onerror=window.oe;s_e=1;s_code=s_dc(
s_un);if(s_code)document.write(s_code);s_e=0;return true}
function s_dc(un){s_un=un;var unc=s_rep(un,'_','-'),imn='s_i_'+un,r=''
,r_d=0;if(!s_e){
/*@cc_on@if(@_jscript_version>=5){try{r=parent.document.referrer;}catch(e){s_e=1}r_d=1}@end@*/
if(!r_d){if(s_u.indexOf('Mac')>=0&&s_u.indexOf('MSIE 4')>=0)r=
document.referrer;else{window.oe=window.onerror;window.onerror=s_et;r=
parent.document.referrer}}}r=r?r:(s_e?'External Frame Referrer':'NULL'
);document.cookie='s_cc=true';var tm=new Date,sess='ss'+Math.floor(
tm.getTime()/10800000)%10+tm.getTime()%10000000000000,s='',c='',v='',
p='',bw='',bh='',j='1.0',vb=s_vb?s_vb:'',a=s_apn+' '+s_apv,g=
window.location.href,o=navigator.platform,yr=tm.getYear(),t=
tm.getDate()+'/'+tm.getMonth()+'/'+(yr<1900?yr+1900:yr)+' '
+tm.getHours()+':'+tm.getMinutes()+':'+tm.getSeconds()+' '+tm.getDay()
+' '+tm.getTimezoneOffset(),k=document.cookie.indexOf('s_cc=')>=0?'Y':
'N',hp='',ct='';if(s_apv>=4)s=screen.width+'x'+screen.height;if(s_apn
=='Netscape'||s_apn=='Opera'){if(s_apv>=3){j='1.1';var i1=0,i2=0,sta;
while(i2<30&&i1<navigator.plugins.length){sta=
navigator.plugins[i1].name;if(sta.length>100)sta=sta.substring(0,100);
sta+=';';if(p.indexOf(sta)<0)p+=sta;i1++;i2++}v=navigator.javaEnabled(
)?'Y':'N'}if(s_apv>=4){j='1.2';c=screen.pixelDepth;bw=
window.innerWidth;bh=window.innerHeight}if(s_apv>=4.06)j='1.3'}else if
(s_apn=='Microsoft Internet Explorer'){if(s_apv<4)r='NULL';if(s_apv>=4
){v=navigator.javaEnabled()?'Y':'N';j='1.2';c=screen.colorDepth}if(
s_apv>=5){bw=document.documentElement.offsetWidth;bh=
document.documentElement.offsetHeight;j='1.3';if(s_u.indexOf('Mac')<0)
{document.body.addBehavior("#default#homePage");hp=
document.body.isHomePage(location.href)?"Y":"N";
document.body.addBehavior("#default#clientCaps");ct=
document.body.connectionType}}} 
code='http://stats.superstats.com/b/ss/'+un+'/1/c4.3/'
+sess+'?'+(s_apn!='Opera'?'[AQB]':'')+'&box=code.superstats.com'
+(r?'&r='+s_esc(r):'')+(s?'&s='+s_esc(s):'')+(c?'&c='+s_esc(c):'')+(o?
'&o='+s_esc(o):'')+(j?'&j='+j:'')+(v?'&v='+v:'')+(k?'&k='+k:'')+(bw?
'&bw='+bw:'')+(bh?'&bh='+bh:'')+(t?'&t='+s_esc(t):'')+(vb?'&vb='+vb:''
)+(ct?'&ct='+s_esc(ct):'')+(hp?'&hp='+hp:'')+(pageName?'&pageName='
+s_esc(pageName):'')+(server?'&server='+s_esc(server):'')+(channel?
'&ch='+s_esc(channel):'')+(pageType?'&pageType='+s_esc(pageType):'')+(
pageValue?'&pageValue='+s_esc(pageValue):'')+(product?'&product='
+s_esc(product):'')+(prop1?'&c1='+s_esc(prop1):'')+(prop2?'&c2='
+s_esc(prop2):'')+(prop3?'&c3='+s_esc(prop3):'')+(prop4?'&c4='+s_esc(
prop4):'')+(prop5?'&c5='+s_esc(prop5):'')+(prop6?'&c6='+s_esc(prop6):
'')+(prop7?'&c7='+s_esc(prop7):'')+(prop8?'&c8='+s_esc(prop8):'')+(
prop9?'&c9='+s_esc(prop9):'')+(prop10?'&c10='+s_esc(prop10):'')+(
prop11?'&c11='+s_esc(prop11):'')+(prop12?'&c12='+s_esc(prop12):'')+(
prop13?'&c13='+s_esc(prop13):'')+(prop14?'&c14='+s_esc(prop14):'')+(
prop15?'&c15='+s_esc(prop15):'')+(prop16?'&c16='+s_esc(prop16):'')+(
prop17?'&c17='+s_esc(prop17):'')+(prop18?'&c18='+s_esc(prop18):'')+(
prop19?'&c19='+s_esc(prop19):'')+(prop20?'&c20='+s_esc(prop20):'')
+(g?'&g='+s_esc(g):'')+(a?'&a='+s_esc(a):'')+(p?'&p='+s_esc(p):'')+(
s_apn!='Opera'?'[AQE]':'');if(s_ios&&document.images[imn]){
document.images[imn].src=code;code=''}else code='<im'+'g sr'+'c="'
+code+'" width=1 height=1>';return code}
s_it('vsign_4261781');s_code=code=s_dc('vsign_4261781')
