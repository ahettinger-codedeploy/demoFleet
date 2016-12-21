var NSfTIF=window.NSfTIF||{};NSfTIF.cnr=8214;NSfTIF.pid=743;NSfTIF.reset=function(){NSfTIF.origin="NSfTIF";NSfTIF.pType="XP";
NSfTIF.section="undef/undef";NSfTIF.tax_id="1";NSfTIF.cr="";NSfTIF.sktg="Diverse/Diverse/Diverse";NSfTIF.keyword="";NSfTIF.cc="de";
NSfTIF.rc="de";NSfTIF.mandant="";NSfTIF.pTypeUid="XP";NSfTIF.frabo=true;NSfTIF.has_ads=true;NSfTIF.options={}};NSfTIF.reset();
NSfTIF.uidPixeltypeList={AP:"AP",CP:"CP",NP:"NP",SP:"SP",XP:"XP"};NSfTIF.sectionList={};NSfTIF.keywordMapping={};NSfTIF.sectionListOewa={};
NSfTIF._mapPgId2ContentClass=function(a){if(this._isDef(this.sectionList[a])){return this.sectionList[a]}else{return this._getIdCode()
}return""};NSfTIF._validateSection=function(a){a="/"+String(a).toLowerCase()+"/";a=a.replace(/\/\//g,"/");return a.substr(1,a.length-2)
};NSfTIF._setPTypeUid=function(a){if(this._isDef(this.uidPixeltypeList[a])){this.pTypeUid=a}else{this.pTypeUid="XP"}};NSfTIF._setSection=function(a){this.section=this._validateSection(a)
};NSfTIF._getIdCode=function(){var a="/"+this.section+"/";var b=a.length;for(var c in this.sectionList){if(b>=c.length&&a.substr(0,c.length)==c){this.tax_id=this.sectionList[c];
break}}return this.tax_id};NSfTIF._loadPixel=function(a){if(a){(new Image()).src=a}};NSfTIF._mapPgId2SKTG=function(a){if(this._isDef(this.sectionListOewa[a])){return this.sectionListOewa[a]
}else{return this._getIdCodeOewa()}return""};NSfTIF._getIdCodeOewa=function(){var a="/"+this.section+"/";var b=a.length;for(var c in this.sectionListOewa){if(b>=c.length&&a.substr(0,c.length)==c){this.sktg=this.sectionListOewa[c];
break}}return this.sktg};NSfTIF._replaceVariables=function(a){a=a.replace(/__SC__/g,this.section);a=a.replace(/__TYPE__/g,this.pType);
a=a.replace(/__CODE__/g,this.tax_id);a=a.replace(/__SKTG__/g,this.sktg);a=a.replace(/__CRG__/g,this.cr);a=a.replace(/__CR__/g,this.cr);
a=a.replace(/__CC__/g,this.cc);a=a.replace(/__REGION__/g,this.rc);a=a.replace(/__R__/g,escape(document.referrer));a=a.replace(/__D__/g,this._getRandom());
a=a.replace(/__MAND__/g,this.mandant);a=a.replace(/__UIDPTYPE__/g,this.pTypeUid);a=a.replace(/__CNR__/g,this.cnr);a=a.replace(/__PID__/g,this.pid);
a=a.replace(/__ORIGIN__/g,this.origin);for(var b in this.options){a=a.replace(new RegExp("__"+b.toUpperCase()+"__","g"),this.options[b])
}a=a.replace(/__[A-Z_]+__/g,"");return a};NSfTIF._rvmv=function(a){for(key in a){a[key]=NSfTIF._replaceVariables(a[key])}return a
};NSfTIF._isDef=function(b){return typeof(b)!="undefined"};NSfTIF.init=function(a){if(!this._isDef(a)){return}if(typeof a.frabo=="boolean"){this.frabo=a.frabo
}if(typeof a.has_ads=="boolean"){this.has_ads=a.has_ads}if(a.ptypeuid){this._setPTypeUid(a.ptypeuid)}if(a.cr){this.cr=a.cr
}if(a.cc){this.cc=a.cc.toLowerCase()}if(a.region){this.rc=a.region.toLowerCase()}this.initUniv(a);if(a.pageidentifier){this._setSection(a.pageidentifier)
}else{this._setSection("undef")}if(a.contentclass){this.tax_id=a.contentclass}if(a.sktg){this.sktg=a.sktg}};NSfTIF.initUniv=function(a){if(a){for(var b in a){if(b.match(/^[a-z_]+$/i)){this.options[b]=a[b]
}}}};NSfTIF.checkFraBo=function(){return this.frabo&&window.location.protocol=="http:"&&document.readyState!="complete"};
NSfTIF.rlsTrc=function(a){this._loadPixel(this._replaceVariables(a))};NSfTIF.rlsTrcRed=function(a){window.location=this._replaceVariables(a)
};NSfTIF._trim=function(a){return a.replace(/\s+$/,"").replace(/^\s+/,"")};NSfTIF._getRandom=function(){return Math.round(Math.random()*100000)
};NSfTIF.performance=function(a){if(a){this.init(a)}if(window.performance&&window.performance.timing){var b=function(){setTimeout(function(){var c=window.performance.timing;
var d=NSfTIF.options;d.navstart=c.navigationStart;d.lps1=c.redirectEnd-c.redirectStart;d.lps2=c.domainLookupStart-c.fetchStart;
d.lps3=c.domainLookupEnd-c.domainLookupStart;d.lps4=c.connectEnd-c.connectStart;d.lps5=c.responseStart-c.requestStart;d.lps6=c.responseEnd-c.responseStart;
d.lps7=c.domComplete-c.domLoading;d.lps8=c.loadEventEnd-c.loadEventStart;d.loadend=c.loadEventEnd;NSfTIF.rlsTrc("//pfmbox.1und1.de/p/?wid=__WID__&pageidentifier=__PAGEIDENTIFIER__&brand=__BRAND__&region=__REGION__&deviceclass=__DEVICECLASS__&tif=__CNR__&navstart=__NAVSTART__&lps1=__LPS1__&lps2=__LPS2__&lps3=__LPS3__&lps4=__LPS4__&lps5=__LPS5__&lps6=__LPS6__&lps7=__LPS7__&lps8=__LPS8__&loadend=__LOADEND__&referrer=__R__")
},0)};if(window.addEventListener){window.addEventListener("load",b,false)}else{if(window.attachEvent){window.attachEvent("onload",b)
}}}};NSfTIF._loadJavaScript=function(b){var a=document.createElement("script");a.setAttribute("type","text/javascript");a.setAttribute("src",b);
if(document.head){document.head.appendChild(a)}};NSfTIF._writeJS=function(a){document.write('<script type="text/javascript" src="'+a+'"><\/script>')
};if(!window.UIM){window.UIM={}}UIM.uim_init={};UIM.init=function(a){if(a){UIM.uim_init=a}};UIM.Pageview=function(a){NSfTIF.origin="UIM";
if(typeof(a)=="undefined"){NSfTIF.track(UIM.uim_init)}else{if(!a.site&&UIM.uim_init.site){a.site=UIM.uim_init.site}if(!a.pageidentifier&&a.section){a.pageidentifier=a.section
}NSfTIF.track(a)}NSfTIF.origin="NSfTIF"};var SMV={smvInit:function(a){NSfTIF.origin="SMV";NSfTIF.track(a);NSfTIF.origin="NSfTIF"
}};NSfTIF._loadPixel=function(c){var b=new RegExp("&[a-z0-9_-]+=&","gi");var a=c.replace(b,"&");while(a.length<c.length){c=a;
a=c.replace(b,"&")}(new Image()).src=a};