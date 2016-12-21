
/*
 * MonkCMS stuff
 */

function gotoSermon2() {
  var x=document.getElementById("sermonLists");
  var go=x.options[x.selectedIndex].value;

  window.location=go;
}

function gotoArticle() {
  var x=document.getElementById("articleLists");
  var go=x.options[x.selectedIndex].value;

  window.location=go;
}

function gotoContent(x) {
  var go=x.options[x.selectedIndex].value;

  window.location=go;
}

function wimpyPopPlayer(theFile,id,stuff) {
  window.open(theFile,id,stuff);
}

/*
 * Wrote this wrapper to stay compatible / eT Oct 2008
 */
function waspPopup (filename, width, height){
  window.open('http://my.ekklesia360.com/Clients/waspPopup.php?theFile='+filename+'&w='+width+'&h='+height,'_mediaplayer','width='+width+',height='+height);

}

function doJSEvents() {
  var links = document.getElementsByTagName("a");
  for (var i=0; i < links.length; i++) {
    if (links[i].className.match("mcmsSearch")) {
      links[i].onclick = function() {
        document.getElementById('searchForm').submit();
        return false;
      };
    }
    if (links[i].className.match("mcmsSearch2")) {
      links[i].onclick = function() {
        document.getElementById('searchForm2').submit();
        return false;
      };
    }
    if (links[i].className.match("thickbox")) {
      links[i].onmouseover = function() {
        window.status='';
		return true;
      };
    }
 }
  var inputs = document.getElementsByTagName("input");
  for (var i=0; i < inputs.length; i++) {
    if (inputs[i].className.match("clearClick")) {
      inputs[i].onfocus = function() {
        if (document.getElementById('search_term')) document.getElementById('search_term').value='';
        if (document.getElementById('search_term2')) document.getElementById('search_term2').value='';
        if (document.getElementById('newsletter_text')) document.getElementById('newsletter_text').value='';
        return false;
      };
    }
  }
}

//created separate function so with ajax filtering this can be initiated to add click handler to new links
function doMediaEvents(){
	var links = document.getElementsByTagName("a");
	for (var i=0; i < links.length; i++) { 
   		if (links[i].className.match("mcms_audioplayer") || links[i].className.match("mcms_videoplayer")) {
	      var player = new Object();
		    player[i] = new MonkMedia.popup(links[i]);
		}
	} 
  MonkMedia.popup.prototype.doOnClick = function(event,element){
       this.clickHandler();
       event.preventDefault ? event.preventDefault() : event.returnValue = false; //IE<9 uses event.returnValue 
  }  
}

function init(){ 
	if (!document.getElementsByTagName){
	  return false;
	}
	   doJSEvents();
	   doMediaEvents();
     if($(".bc_link").length > 0){
       $("head").append("<link rel='stylesheet' href='http://api.monkcms.com/Clients/bctooltip.css' media='screen' />");
       $(".bc_link").bcTooltip();
     }
}

window.onload=init;

function changeFieldValue(fieldName,fieldValue) {
  document.getElementById(fieldName).value=fieldValue;
}

function monkIsValidEmail(emailAddress) {
  atPos=emailAddress.indexOf("@");
  dotPos = emailAddress.indexOf(".", atPos);
  spacePos = emailAddress.indexOf(" ");
  if ((emailAddress.length > 0) && (atPos > 0) && (dotPos > atPos) && (spacePos == -1)) {
    return true;
  }
  alert("Please enter a valid email address.");
  return false;
} 
 
/*
   Monk Media Popup v.1 - a script to open window with videoplayer
   (c) 2010 Adam Randlett : monkdevelopment.com
*/  
//associates the audio or video anchor on click event 
//with a new instance of MonkMedia Popup object
function associateObjWithEvent(obj, methodName){
    return (function(e){
        e = e||window.event;
        return obj[methodName](e, this);
    });
}
//MonkMedia.popup object
var MonkMedia = MonkMedia || {};
MonkMedia.popup = MonkMedia.popup || function(obj){
   this.globalwidth='';
   this.globalheight='';
   this.options = {};
   this.element = obj;
   this.eurl = this.element.href;
   this.offsetHeight = 25; //acounts for window heading height
  
   this.gup = function(name){
		  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
		  var regexS = "[\\?&]"+name+"=([^&#]*)",
		  	  regex = new RegExp( regexS ),
		  	  results = regex.exec( this.eurl );
		  if( results === null ){
		    return "";
		  }else{
		    return results[1];
		  }
	};
	
	this.options = {
		width:this.gup('width'),
		height:this.gup('height'),
		playlist:this.gup('playlist'),
		template:this.gup('template') //"/_player/videoplayer.php"  
	};
	
    //assigns on click event with anchor element
	this.element.onclick = associateObjWithEvent(this, "doOnClick");   

	this.clickHandler = function(){
		if(this.options.playlist !== "false"){
			this.pwidth = 240;
			this.varwidth = Number(this.options.width) + this.pwidth;
			this.globalwidth = String(this.varwidth);  
		}else{
			this.globalwidth = this.options.width;
		} 
			
		this.globalheight = Number(this.options.height) + this.offsetHeight;
		this.indx = this.eurl.indexOf("?");
		this.attr = this.eurl.substring(this.indx);
		this.url = this.options.template +this.attr+"&target=MediaPlayer"; 
		
		window.open(this.url,"MediaPlayer","menubar=no,resizable=no,width="+this.globalwidth+",height="+this.globalheight+",scrollbars=no,status=no"); 
	};
};

/**
 *  jQuery plugin Biblecloud.com Popup
 */

(function(a,b,c,d){a.fn.bcTooltip=function(d){d=a.extend({},a.fn.bcTooltip.options,d);return this.each(function(e){function v(a){var b={},c=a[1].toLowerCase(),d=a[3],e=a[2],f=a[4]?a[4]:"",g=a[1];if(a[4]){var h=d.split("-");b.title=g+" "+e+":"+h[0]+"-"+h[1]+":"+f}else if(a[3]){b.title=g+" "+e+":"+d}else if(!a[3]&&a[2]){b.title=g+" "+e}else{b.title=g}b.version=a[0];return b}function u(a){var b=c.createElement("a");b.href=a;return{source:a,protocol:b.protocol.replace(":",""),host:b.hostname,port:b.port,query:b.search,params:function(){var a={},c=b.search.replace(/^\?/,"").split("&"),d=c.length,e=0,f;for(;e<d;e++){if(!c[e]){continue}f=c[e].split("=");a[f[0]]=f[1]}return a}(),file:(b.pathname.match(/\/([^\/?#]+)$/i)||[,""])[1],hash:b.hash.replace("#",""),path:b.pathname.replace(/^([^\/])/,"/$1"),relative:(b.href.match(/tp:\/\/[^\/]+(.+)/)||[,""])[1],segments:b.pathname.replace(/^\//,"").split("/")}}function t(a,b,c){var d=parseInt(a.width,10),e=parseInt(a.height,10),f=[];f.x=c.left+15;f.y=c.top-e;if(d>b.width||e>b.height){return f}f.x+=d;if(f.x>b.width-10){f.x=f.x}if(f.x<0){f.x=0}if(f.y<0){f.y=c.top-10}f.x-=d+3;return f}function s(){var c={},d;c.width=a(b).width();c.height=a(b).height();return c}function r(){var b=a("<div></div>");a(b).css({width:d.width,height:d.height,position:"absolute","z-index":"7777777",display:"none"});a(b).html("<div class='bctooltip_head'><div class='bctooltip_reference'></div><div class='bctooltip_version'></div><a href='' class='bc-link' target='_blank'>MORE</a></div><div class='bctooltip_verse'></div>");a(b).attr("id","bctooltip"+e);a(b).addClass("bctooltip");a(b).addClass(d.classname);a("body").append(a(b));return a(b)}var f=a(this),g=f.parent(),h=f.offset(),i=s(),j=u(f.attr("href")),k=r(),l=[],m=600,n,o={gen:"Genesis",exo:"Exodus",lev:"Leviticus",num:"Numbers",deu:"Deuteronomy",josh:"Joshua",jdgs:"Judges",ruth:"Ruth","1sm":"1 Samuel","2sm":"2 Samuel","1ki":"1 Kings","2ki":"2 Kings","1chr":"1 Chronicles","2chr":"2 Chronicles",ezra:"Ezra",neh:"Nehemiah",est:"Esther",job:"Job",psa:"Psalms",prv:"Proverbs",eccl:"Ecclesiastes",ssol:"Song of Solomon",isa:"Isaiah",jer:"Jeremiah",lam:"Lamentations",eze:"Ezekiel",dan:"Daniel",hos:"Hosea",joel:"Joel",amos:"Amos",obad:"Obadiah",jonah:"Jonah",mic:"Micah",nahum:"Nahum",hab:"Habakkuk",zep:"Zephaniah",hag:"Haggai",zec:"Zechariah",mal:"Malachi",mat:"Matthew",mark:"Mark",luke:"Luke",john:"John",acts:"Acts",rom:"Romans","1cor":"1 Corinthians","2cor":"2 Corinthians",gal:"Galatians",eph:"Ephesians",phi:"Philippians",col:"Colossians","1th":"1 Thessalonians","2th":"2 Thessalonians","1tim":"1 Timothy","2tim":"2 Timothy",titus:"Titus",phmn:"Philemon",heb:"Hebrews",jas:"James","1pet":"1 Peter","2pet":"2 Peter","1jn":"1 John","2jn":"2 John","3jn":"3 John",jude:"Jude",rev:"Revelation"},p=v(j.segments),q=f.attr("href");a("body").css({position:"relative"});k.find("a").attr("href",j.source);k.find(".bctooltip_reference").text(p.title);k.find(".bctooltip_version").text(p.version);k.find(".bctooltip_verse").html("Loading...");a.ajax({url:q+"?callback=?",crossDomain:true,type:"get",dataType:"jsonp",success:function(a){var b=j.relative.split("/").splice(2),c=[],d=[],e=b[0],f=b.length,g="";if(f===4){c[0]=b[2].split("-")[0];c[1]=b[3];d[0]=b[1];d[1]=b[2].split("-")[1]}else if(f===3){if(b[2].indexOf("-")){c[0]=b[2].split("-")[0];c[1]=b[2].split("-")[1]}else{c[0]=b[2]}d[0]=b[1]}else if(f<=2){d[0]=b[1]}if(c.length>1){for(var h=parseInt(c[0]);h<parseInt(c[0])+4;h++){if(a[h]){g+="<span>"+h+"</span>"+a[h-1]+" "}}}else{for(var h=1;h<4;h++){g+="<span>"+h+"</span>"+a[h-1]+" "}}k.find(".bctooltip_verse").html("").prepend(g)}});f.bind("mouseenter",function(){if(n){clearTimeout(n)}l=t({width:d.width,height:d.height},i,h);k.css({top:l.y,left:l.x});k.fadeIn("fast");k.bind("mouseenter",function(){clearTimeout(n)});k.bind("mouseleave",function(){n=setTimeout(function(){k.hide()},m)})});f.bind("mouseleave",function(){n=setTimeout(function(){k.hide();k.unbind("mouseenter");k.unbind("mouseleave")},m)});})};a.fn.bcTooltip.options={propertyName:"bctooltip",classname:"",width:"275",height:"135"}})(jQuery,window,document)