(function(){var b=null;function f(a){if(a!=b)return escape(a.toString());return""}function h(a){if(a!=b)return a.toString().substring(0,256);return""}function j(a,c){var g=f(c);if(g!=""){var e=f(a);if(e!="")return"&".concat(e,"=",g)}return""}function k(a){if(typeof a!="number"&&typeof a!="string")return"";return f(a.toString())}
function l(a){if(!a)return"";a=a.google_conversion_items;if(!a)return"";for(var c=[],g=0,e=a.length;g<e;g++){var d=a[g],i=[];if(d){var m=k(d.value),n=k(d.quantity);if(!(m==b||n==b||m==""||n=="")){i.push(m);i.push(n);i.push(k(d.item_id));i.push(k(d.adwords_grouping));i.push(k(d.sku));c.push("("+i.join("*")+")")}}}return c.length>0?"item="+c.join(""):""}
function o(a,c,g){var e=[];if(a){var d=a.screen;if(d){e.push(j("u_h",d.height));e.push(j("u_w",d.width));e.push(j("u_ah",d.availHeight));e.push(j("u_aw",d.availWidth));e.push(j("u_cd",d.colorDepth))}a.history&&e.push(j("u_his",a.history.length))}g&&typeof g.getTimezoneOffset=="function"&&e.push(j("u_tz",-g.getTimezoneOffset()));if(c){typeof c.javaEnabled=="function"&&e.push(j("u_java",c.javaEnabled()));c.plugins&&e.push(j("u_nplug",c.plugins.length));c.mimeTypes&&e.push(j("u_nmime",c.mimeTypes.length))}return e.join("")}
function p(a,c){var g="";if(c){var e=c.referrer;if(a&&a.top&&c.location&&a.top.location==c.location){g+=j("ref",h(e));e=c.location}g+=j("url",h(e))}return g}function q(a){if(a&&a.location&&a.location.protocol&&a.location.protocol.toString().toLowerCase()=="https:")return"https:";return"http:"}function r(a,c){return q(a)+"//www.googleadservices.com/pagead/"+c}
function s(a,c,g){var e="/?";if(a.google_conversion_type=="landing")e="/extclk?";e=r(a,["conversion/",f(a.google_conversion_id),e,"random=",f(a.google_conversion_time)].join(""));var d;a:{d=a.google_conversion_language;if(d!=b){d=d.toString();if(2==d.length){d=j("hl",d);break a}if(5==d.length){d=j("hl",d.substring(0,2))+j("gl",d.substring(3,5));break a}}d=""}e+=[j("cv",a.google_conversion_js_version),j("fst",a.google_conversion_first_time),j("num",a.google_conversion_snippets),j("fmt",a.google_conversion_format),
j("value",a.google_conversion_value),j("label",a.google_conversion_label),j("oid",a.google_conversion_order_id),j("bg",a.google_conversion_color),d,j("guid","ON"),l(a),o(a,c,a.google_conversion_date),p(a,g)].join("");return e}
function t(a){if({ar:1,bg:1,cs:1,da:1,de:1,el:1,en_AU:1,en_US:1,en_GB:1,es:1,et:1,fi:1,fr:1,hi:1,hr:1,hu:1,id:1,is:1,it:1,iw:1,ja:1,ko:1,lt:1,nl:1,no:1,pl:1,pt_BR:1,pt_PT:1,ro:1,ru:1,sk:1,sl:1,sr:1,sv:1,th:1,tl:1,tr:1,vi:1,zh_CN:1,zh_TW:1}[a])return a+".html";return"en_US.html"}
function u(a,c,g){c=s(a,c,g);g=function(e,d,i){return'<img height="'+i+'" width="'+d+'" border="0" src="'+e+'" />'};return a.google_conversion_format==0?'<a href="'+(q(a)+"//services.google.com/sitestats/"+t(a.google_conversion_language)+"?cid="+f(a.google_conversion_id))+'" target="_blank">'+g(c,135,27)+"</a>":a.google_conversion_snippets>1||a.google_conversion_format==3?g(c,1,1):'<iframe name="google_conversion_frame" width="'+(a.google_conversion_format==2?200:300)+'" height="'+(a.google_conversion_format==
2?26:13)+'" src="'+c+'" frameborder="0" marginwidth="0" marginheight="0" vspace="0" hspace="0" allowtransparency="true" scrolling="no">'+g(c.replace(/\?random=/,"?frame=0&random="),1,1)+"</iframe>"};var v=window;
if(v)if(/[\?&;]google_debug/.exec(document.URL)!=b){var w=document.getElementsByTagName("head")[0];if(!w){w=document.createElement("head");document.getElementsByTagName("html")[0].insertBefore(w,document.getElementsByTagName("body")[0])}var x=document.createElement("script");x.src=r(window,"conversion_debug_overlay.js");w.appendChild(x)}else{try{var y;if(v.google_conversion_type=="landing"||!v.google_conversion_id)y=false;else{v.google_conversion_date=new Date;v.google_conversion_time=v.google_conversion_date.getTime();
if(typeof v.google_conversion_snippets=="number"&&v.google_conversion_snippets>0)v.google_conversion_snippets+=1;else v.google_conversion_snippets=1;if(typeof v.google_conversion_first_time!="number")v.google_conversion_first_time=v.google_conversion_time;v.google_conversion_js_version="6";if(v.google_conversion_format!=0&&v.google_conversion_format!=1&&v.google_conversion_format!=2&&v.google_conversion_format!=3)v.google_conversion_format=1;y=true}y&&document.write(u(v,navigator,document))}catch(z){}v.google_conversion_date=
b;v.google_conversion_time=b;v.google_conversion_js_version=b;v.google_conversion_id=b;v.google_conversion_value=b;v.google_conversion_label=b;v.google_conversion_language=b;v.google_conversion_format=b;v.google_conversion_color=b;v.google_conversion_type=b;v.google_conversion_order_id=b};})();
