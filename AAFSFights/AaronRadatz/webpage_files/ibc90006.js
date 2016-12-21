// v5.4.2, 2010-05-01 (partner 90006)
function wc(n,v,t){document.cookie=n+'='+v+'; path=/; expires='+t.toGMTString()+';'};function y(n){return(n>200?n:1900+n)}
function io(v,t){return v.indexOf(t)};function ss(s,i,j){return s.substring(i,j)};function cv(s){var i,e,c,t='';c=document.cookie
i=io(c,s);if(i>-1){s=c.indexOf('=',i)+1;e=c.indexOf(';',i);if(e<0)e=c.length;t=ss(c,s,e)};return t};function d(n){var s=''+n
return(s.length<2?'0'+s:s)};var a,b,e,g,l,m,o,p,q,q2,rtspd,t,u,w,x,z;r+='netpoll/imulti.asp?js=1&pn=90006&user='+escape(user)
if(id!='')r+='&id='+id;z=window.location.href;if(io(z,'http://')==0){z=ss(z,7,z.length);q=io(z,'?');if(q>0){p='&'+ss(z,q+1,
z.length)+'&';z=ss(z,0,q);q=io(p,'&RTci=');if(q>=0){p=ss(p,q+6,p.length);r+='&ci='+escape(ss(p,0,io(p,'&')))}};q=io(z,'#')
if(q>0)z=ss(z,0,q);q=io(z,'/');if(q>0)z=ss(z,q+1,z.length)};if(pp=='')pp=z;if(id=='')r+='&pp='+escape(pp);x='MSIE '
function RTol(){var s,i,t=new Date();s=t.valueOf()-rtspd;t.setTime(t.getTime()+36E5);if(s!=''){wc('RT_speed',s,t);i=(id=='')?'0':id
wc('RT_page',i,t);wc('RT_pagen',pp,t)}};a=navigator;b=a.appVersion.charAt(0);a=a.userAgent;p='RT_page';var dd=document
u='undefined';g=dd.referrer;r+='&l='+a.length;w=io(a,x);x=io(a,x+4);if(b>3){t=new Date();rtspd=t.valueOf();r+='&tt='+d(t.getMonth()
+1)+'%2F'+d(t.getDate())+'%2F'+y(t.getYear())+'+'+d(t.getHours())+'%3A'+d(t.getMinutes())+'&j='+(navigator.javaEnabled()?1:0)
q=cv(p);t.setTime(t.getTime()+36E5);m=parseInt(2E9*Math.random());if(q=='')q=0;wc(p,0,t);p+='n';q2=cv(p);if(q2=='')q2='-'
wc(p,'-',t);r+='&p='+q+'&p3='+q2+'&spd='+cv('RT_speed')+'&c='+(screen.pixelDepth?screen.pixelDepth:screen.colorDepth)+'&d='+m
+'&w='+screen.width+'&h='+screen.height+'&ck='+(cv(p)!=''?1:0);p='RT_id';t.setTime(t.getTime()+5E9);e=cv(p);l='';o=g;z=0
if((w>0&&x<0&&b>3&&io(a,'Mac_P')<0)||b>4){while(o!=u){l+='parent.';o=u;o=eval('try{'+l+'document\.referrer}catch(e){}');if(o==g)o=u
if(o!=u)g=o};if(eval('try{new ActiveXObject("AgControl.AgControl")}catch(e){}'))z=1};if(e=='')e=m;wc(p,e,t);r+='&b='+e
if(typeof window.onload==u||window.onload==null)window.onload=RTol};r+='&to='+to+'&ref='+escape(g);o=0;p=navigator.plugins
if(p)if(p['WPFe Plug-In'])z=1;l='Shockwave Flash';if(p)if(p[l+' 2.0']||p[l])o=1;for(a=7;a>1;a--){l=(a<3)?'':'.'+a
if(eval('try{new ActiveXObject("ShockwaveFlash.ShockwaveFlash'+l+'")}catch(e){}'))o=1};r+='&f='+o+'&sl='+z;var RTu=r
function RTsc(){var m,i,b,a=dd.getElementsByTagName('a');if(a){for(i=0;i<a.length;i++){b=a[i];if(b.name&&b.href&&!b.RT){
m='mousedown';b.RT=0;if(b.addEventListener){b.addEventListener(m,RTc,false)}else{if(b.attachEvent)b.attachEvent('on'+m,RTc)}}}}}
function RTc(e){var b,t,i,r=RTu;if(!e)var e=window.event;if(e.target){t=e.target}else if(e.srcElement)t=e.srcElement;for(i=0;i<10;
i++){if(t.nodeName.toLowerCase()!='a')t=t.parentNode};i=io(r,'&pp=');m=parseInt(2E9*Math.random());b=new Image();i=r.indexOf('&',i
+1);b.src=ss(r,0,i)+'+%3E+'+t.name+r.substring(i)+'&d2='+m};if(typeof cl!=u&&cl>0){RTsc();setTimeout('RTsc()',1000)}
if(typeof vl!=u&&vl!=''&&cv('RT_speed')=='')r+='&vl='+vl;
dd.write('<img src="'+r+'" width="5" height="5" style="position:absolute;bottom:0;right:0;" />')