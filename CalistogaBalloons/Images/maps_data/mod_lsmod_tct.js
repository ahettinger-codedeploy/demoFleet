__gjsload_maps2__('ls', 'GAddMessages({13645:"English",13646:"Show English labels",14047:"Switch between labels in the local language and transliterated text."});\'use strict\';function gP(a,b,c,d){this.O=a;this.I=a.ba();this.H=c;this.G=p;this.j=b;this.D=p;this.nb=new ki(m);this.nb.pk();this.nb.j="layer";this.j?this.nb.show():this.nb.initialize();this.nb.Ub(p);this.nb.Sc(X(13645));this.nb.Hj(X(14047));this.nb.qg=100;this.nb.$a="langswitch";P(this.nb,Pa,C(this.C,this,k));P(this.nb,Qa,C(this.C,this,p));P(this.nb,Ua,C(this.GF,this));d.Uj(this.nb);L(this.I,wb,this,this.o);L(Ga.Da(),La,this,this.J);L(this.I,Bb,this,this.o);L(this.I,Ab,this,this.o);this.o()} var TKa=function(a,b){a.G!=b?(a.nb.Ub(b),a.G=b,SKa(a,b,a.j)):a.D||SKa(a,b,a.j)}; gP.prototype.J=function(a){"langswitch"==a&&this.o()}; gP.prototype.o=function(a){this.I.qb&&fl(this.I.wa())?TKa(this,p):Ga.Da().Gk("langswitch",this.I.ib(),C(function(a){TKa(this,a)}, this),a,this.I.ea())}; gP.prototype.GF=function(){this.C(1<this.nb.Ab())}; gP.prototype.C=function(a,b){if(this.j!=a&&this.nb.gc()){this.j=a;var c=this.I;c.D=this.j?Ok(Nk):"x-local";H(c,vc);To(this.H,b).F[28]=a;c={ct:"ls"};c.cd=a?"1":"0";this.O.be(m,c)}}; var SKa=function(a,b,c){var d=[];d.push("ls");d.push(a.D?"i:0":"i:1");d.push(b?"v:1":"v:0");d.push(c?"t:1":"t:0");a.D=k;a.O.Cd(d.join(","))};W(Vc,kba,function(a,b,c,d){new gP(a,b,c,d)}); W(Vc);', '', []);
__gjsload_maps2__('tct', 'GAddMessages({});\'use strict\';function Mcb(a){this.o=m;var b=this;dv([a.C,a.K],function(a,d){b.o=d;var e={arrowClick:C(b.C,b),textClick:C(b.D,b)};a.Pa("tt",m,e)}); this.j=document.getElementById("tactile-promo")} var Ncb=function(a,b){b?(cm(a.j,"tactile-promo"),R(a.j,"tactile-promo-collapsed")):(cm(a.j,"tactile-promo-collapsed"),R(a.j,"tactile-promo"));a.o&&(To(a.o).F[41]=b)}, Ocb=function(a){return 0<=bm(a.j).search("tactile-promo-collapsed")}; Mcb.prototype.C=function(){this.j&&Ncb(this,!Ocb(this))}; Mcb.prototype.D=function(){this.j&&Ocb(this)&&Ncb(this,p)};W("tct",nba,function(a){var b=new Mcb(a);a.ga.set(b)}); W("tct");', '', []);