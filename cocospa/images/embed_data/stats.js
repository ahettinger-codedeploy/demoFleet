google.maps.__gjsload__('stats', function(_){'use strict';var vZ=function(a,b,c){var d=[];_.Fc(a,function(a,c){d.push(c+b+a)});return d.join(c)},wZ=function(a,b,c,d){var e={};e.host=window.document.location&&window.document.location.host||window.location.host;e.v=a;e.r=Math.round(1/b);c&&(e.client=c);d&&(e.key=d);return e},xZ=function(a){var b={};_.Fc(a,function(a,d){b[(0,window.encodeURIComponent)(d)]=(0,window.encodeURIComponent)(a).replace(/%7C/g,"|")});return vZ(b,":",",")},zZ=function(a,b,c,d){var e;e=_.N(_.R,23,500);var f;f=_.N(_.R,22,
2);this.C=a;this.F=b;this.G=e;this.l=f;this.B=c;this.m=d;this.f=new _.Ej;this.b=0;this.j=_.Ka();yZ(this)},yZ=function(a){window.setTimeout(function(){AZ(a);yZ(a)},Math.min(a.G*Math.pow(a.l,a.b),2147483647))},BZ=function(a,b,c){a.f.set(b,c)},AZ=function(a){var b=wZ(a.F,a.B,a.m,void 0);b.t=a.b+"-"+(_.Ka()-a.j);a.f.forEach(function(a,d){a=a();0<a&&(b[d]=Number(a.toFixed(2))+(_.fm()?"-if":""))});a.C.b({ev:"api_snap"},b);++a.b},CZ=function(a,b,c,d,e){this.m=a;this.C=b;this.l=c;this.f=d;this.j=e;this.b=
new _.Ej;this.B=_.Ka()},DZ=function(a,b,c){this.l=b;this.f=a+"/maps/gen_204";this.j=c},EZ=function(){this.b=new _.Ej},FZ=function(a){var b=0,c=0;a.b.forEach(function(a){b+=a.Ep;c+=a.bp});return c?b/c:0},GZ=function(a,b,c,d,e){this.B=a;this.C=b;this.m=c;this.j=d;this.l=e;this.f={};this.b=[]},HZ=function(a,b,c,d){this.j=a;_.z.bind(this.j,"set_at",this,this.l);_.z.bind(this.j,"insert_at",this,this.l);this.B=b;this.C=c;this.m=d;this.f=0;this.b={};this.l()},IZ=function(){this.j=_.P(_.R,6);this.b=new DZ(_.Mf[35]?
_.P(_.mf(_.R),11):_.Nv,_.Pi,window.document);new HZ(_.Bi,(0,_.p)(this.b.b,this.b),_.Yf,!!this.j);var a=_.P(new _.ff(_.R.data[3]),1);this.C=a.split(".")[1]||a;this.F={};this.B={};this.m={};this.G={};this.H=_.N(_.R,0,1);_.Oi&&(this.l=new zZ(this.b,this.C,this.H,this.j))};
CZ.prototype.F=function(a){var b=void 0,b=_.m(b)?b:1;this.b.isEmpty()&&window.setTimeout((0,_.p)(function(){var a=wZ(this.C,this.l,this.f,this.j);a.t=_.Ka()-this.B;var b=this.b;_.Fj(b);for(var e={},f=0;f<b.b.length;f++){var g=b.b[f];e[g]=b.I[g]}_.Gy(a,e);this.b.clear();this.m.b({ev:"api_maprft"},a)},this),500);b=this.b.get(a,0)+b;this.b.set(a,b)};
DZ.prototype.b=function(a,b){b=b||{};var c=_.uk().toString(36);b.src="apiv3";b.token=this.l;b.ts=c.substr(c.length-6);a.cad=xZ(b);a=vZ(a,"=","&");a=this.f+"?target=api&"+a;this.j.createElement("img").src=a;(b=_.Mc.__gm_captureCSI)&&b(a)};EZ.prototype.f=function(a,b,c){this.b.set(_.yb(a),{Ep:b,bp:c})};GZ.prototype.F=function(a){this.f[a]||(this.f[a]=!0,this.b.push(a),2>this.b.length&&_.Wy(this,this.G,500))};
GZ.prototype.G=function(){for(var a=wZ(this.C,this.m,this.j,this.l),b=0,c;c=this.b[b];++b)a[c]="1";a.hybrid=+((_.dl()||!_.cl())&&_.cl());this.b.length=0;this.B.b({ev:"api_mapft"},a)};HZ.prototype.l=function(){for(var a;a=this.j.removeAt(0);){var b=a.Go;a=a.timestamp-this.C;++this.f;this.b[b]||(this.b[b]=0);++this.b[b];if(20<=this.f&&!(this.f%5)){var c={};c.s=b;c.sr=this.b[b];c.tr=this.f;c.te=a;c.hc=this.m?"1":"0";this.B({ev:"api_services"},c)}}};IZ.prototype.V=function(a){a=_.yb(a);this.F[a]||(this.F[a]=new GZ(this.b,this.C,this.H,this.j));return this.F[a]};IZ.prototype.T=function(a){a=_.yb(a);this.B[a]||(this.B[a]=new CZ(this.b,this.C,1,this.j));return this.B[a]};IZ.prototype.f=function(a){if(this.l){this.m[a]||(this.m[a]=new _.Xz,BZ(this.l,a,function(){return b.ub()}));var b=this.m[a];return b}};IZ.prototype.M=function(a){if(this.l){this.G[a]||(this.G[a]=new EZ,BZ(this.l,a,function(){return FZ(b)}));var b=this.G[a];return b}};var JZ=new IZ;_.mc("stats",JZ);});