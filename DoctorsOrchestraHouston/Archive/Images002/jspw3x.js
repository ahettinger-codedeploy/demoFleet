// jspw3x.js version 1.4.12===1.0.0
var gJspw3Obj="",gJspw3nm=0;function massage(wi,hi,g,t,l,n,v,b,clo){wi-=0;if(t != '')t-=0;if(l != '')l-=0;if(!window.isOther){var isOther=(navigator.userAgent.toLowerCase().indexOf("firebird")!=-1)?'fb':'';if(!isOther && (navigator.appName.toLowerCase()=='netscape')&&(parseInt(navigator.appVersion)==4))isOther='n4';window.isOther=isOther;}else var isOther=window.isOther;if(isOther != 'n4' && screen.availHeight){var h=screen.availHeight-30-7;if(isOther=='fb')h-=22;var w=screen.availWidth-10;}else{var adj=10;var h=screen.height;var w=screen.width;if(w<740)h=0.90*h-adj;if(w>=740 & w<835)h=0.91*h-adj;if(w>=835)h=0.93*h-adj;w-=adj;}if(Math.abs(l)>w-100)l=(l/Math.abs(l))*(w-100);if(Math.abs(l)<1&&Math.abs(l)>0.001)l=l*w;if(Math.abs(t)>h-100)t=(t/Math.abs(t))*(h-100);if(Math.abs(t)<1&&Math.abs(t)>0.001)t=t*h;if(n&&v.length>2){n=(n=='js')?0:1;v=v.split('.')[0]*(v.split('.')[1]-0+n);if(v>0)v+=15;}else v=0;var cnh=(hi-0)+v+(clo-0);if(!b){var rw=1,rh=1;if(wi>w)rw=w/wi;if(cnh>h)rh=h/cnh;wi=wi*Math.min(rh,rw);cnh=cnh*Math.min(rh,rw);var rh=1,rw=1;if(cnh>h-Math.abs(t))rh=(h-Math.abs(t))/cnh;if(wi>w-Math.abs(l))rw=(w-Math.abs(l))/wi;cnh=cnh*Math.min(rh,rw);wi=wi*Math.min(rh,rw);}var wh=Math.max(Math.min((cnh-0+2*g),(h-Math.abs(t))),100);var ww=Math.max(Math.min((wi-0+2*g),(w-Math.abs(l))),100);var pt=(h-wh)/2;var pl=(w-ww)/2;if(t!=''){if(t>=0){pt=t;}else pt=h+t-wh;}if(l!=''){if(l>=0){pl=l;}else pl=w+l-ww;}	if(pt<0)pt=0;if(pt>h-wh)pt=h-wh;if(pl<0)pl=0;if(pl>w-ww)pl=w-ww;return [parseInt(ww),parseInt(wh),parseInt(pt),parseInt(pl),parseInt(wi),parseInt(cnh-v-(clo-0))]}