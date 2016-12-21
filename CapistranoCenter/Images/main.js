/*
*	Rachael Ray
*	Contains utility / interface functions for Rachael Ray Show Season 2
*	
*	Requires jQuery library (http://www.jquery.com),
*	SWFObject (http://blog.deconcept.com/swfobject/),
*	sIFR (http://www.mikeindustries.com/sifr/)
*	
*	Taylan Pince (taylan@trapeze.com) - July 25, 2007
*/

jQuery.preloadImages = function() {
	var a = (typeof arguments[0] == 'object')? arguments[0] : arguments;
	for(var i = a.length -1; i > 0; i--) {
		jQuery("<img />").attr("src", a[i]);
	}
}

if (typeof trapeze == 'undefined') trapeze = new Object();

trapeze.RachaelRay = {
	
	set_cookie : function(name, val, days) {
		if (days) {
			var date = new Date();
			date.setTime(date.getTime() + (days*24*60*60*1000));
			var expires = "; expires="+date.toGMTString();
		} else {
			var expires = "";
		}
		document.cookie = name + "=" + val + expires + "; path=/";
	},
	
	get_cookie : function(name) {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for (var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		}
		return null;
	},
	
	del_cookie : function(name) {
		this.set_cookie(name, '', -1);
	},
	
	check_cookie : function() {
		if ($("#UserBoxSignInForm").size() > 0) {
			if (this.get_cookie('RR2CookieTester') == null) {
				this.set_cookie('RR2CookieTester', 'True', 0.25);
				if (this.get_cookie('RR2CookieTester') == null) {
					$("#UserBoxSignInForm").html("<p>Cookies are required for logging in to Club RR. Please enable them through your browser settings.</p>");
				}
			}
		}
	},
	
	section : function() {
		if ($("body").attr("class") && $("body").attr("class").indexOf("home") > -1) {
			return "home";
		} else {
			return "sub";
		}
	},
	
	sifr : function() {
		if (typeof sIFR == "function") {
			sIFR.replaceElement(named({sSelector:".page-title", sFlashSrc:this.assets_path + "fla/helvetica-neue-lt-th.swf", sColor:"#313131", sLinkColor:"#000000", sBgColor:"#FFFFFF", sHoverColor:"#CCCCCC", sWmode:"transparent", nPaddingTop:0, nPaddingBottom:0}));
			sIFR.replaceElement(named({sSelector:".section-title", sFlashSrc:this.assets_path + "fla/helvetica-neue-lt-th.swf", sColor:"#313131", sLinkColor:"#000000", sBgColor:"#FFFFFF", sHoverColor:"#CCCCCC", sWmode:"transparent", nPaddingTop:0, nPaddingBottom:4}));
			sIFR.replaceElement(named({sSelector:".date-title", sFlashSrc:this.assets_path + "fla/helvetica-neue-lt-th.swf", sColor:"#313131", sLinkColor:"#000000", sBgColor:"#FFFFFF", sHoverColor:"#CCCCCC", sWmode:"transparent", nPaddingTop:0, nPaddingBottom:0}));
		};
	},
	
	setup_video : function(videoId, videoPath, htmlId) {
		var so = new SWFObject(this.assets_path + "fla/player_small.swf", videoId, "331", "280", "8", "#FFFFFF");
		so.addParam("allowScriptAccess", "always");
		so.addParam("scale", "noscale");
		so.addParam("salign", "T");
		so.addParam("wmode", "transparent");
		so.addVariable("front", "false");
		so.addVariable("xmlPath", videoPath);
		so.addVariable("prefPath", this.assets_path + "xml/player-prefs.xml");
		so.addVariable("allowedDomain", window.location.hostname);
		so.write(htmlId);

		/*
		commented out, this needs to be handled in the swf not appended html
		~ patrick.may 2009.05.17
		var videoBox = $('#' + htmlId);
		var host = "http://" + location.hostname;
		var flashVars = '"xmlPath=' + host + '/show/view/667/player/&amp;prefPath=' +
				this.assets_path + 'xml/player-prefs.xml"';
		var playerPath = this.assets_path + 'fla/player_small.swf';
		var embedText = '<object width="331" height="280">' +
				'<param name="movie" value="' + playerPath + '"></param>' +
				'<param name="flashvars" value=' + flashVars + '></param>' +
				'<embed src="' + playerPath + '" type="application/x-shockwave-flash"' +
				'width="331" height="280" flashvars=' + flashVars + '></embed></object>';
		var embedId = htmlId + "embed";
		var embed = $("<input type=\"text\" />").attr("id", embedId);
		embed.attr("value", embedText).attr("readonly", "readonly");
		embed.click(function() {
				$("#" + embedId).focus().select();
			});
		$("<label>Embed </label>").attr("for", embedId).appendTo(videoBox);
		embed.appendTo(videoBox);*/
	},
	
	init_showcase : function(path) {
		if ($("#WeekShowcase").size() > 0) {
			sIFR && sIFR.replaceElement && sIFR.replaceElement(named({sSelector:"#WeekShowcaseBlurb h2", sFlashSrc:this.assets_path + "fla/helvetica-neue-lt-th.swf", sColor:"#313131", sLinkColor:"#000000", sBgColor:"#FFFFFF", sHoverColor:"#CCCCCC", sWmode:"transparent", nPaddingTop:4, nPaddingBottom:0}));
		}
		
		if ($("#WeekShowcaseVideo").size() > 0 && (document.player_path || path)) {
			this.setup_video("WeekShowcaseVideoPlayer", (path) ? path : document.player_path, "WeekShowcaseVideo");
		}
	},
	
	init_giveaway : function() {
		if ("object" == typeof videos) {
			for (var i = 0; i < videos.length; i++) {
				var video = videos[i];
				this.setup_video("SegmentVideoPlayer" + video.id, video.path, "SegmentVideo" + video.id);
			}
		} else if ($("#ComingUpVideo").size() > 0) {
			this.setup_video("ComingUpVideoPlayer", path, "ComingUpVideo");
		}
	},
	
	mark_last : function() {
		$("li:last-child").addClass("last-child");
	},
	
	mark_first : function() {
		$("li:first-child").addClass("first-child");
		$("li:nth-child(2)").addClass("second-child");
	},
	
	clean_hr : function() {
		$("hr").wrap('<div class="hr"></div>');
	},
	
	welcome : function() {
		if (navigator.platform.indexOf("Linux") == -1) {
		  if ($("#WelcomeBox").size() > 0) {
				var section = this.section();
				var sub = (section == "home") ? "" : "-sub";
				var so = new SWFObject(this.assets_path + "fla/welcome.swf", "WelcomeFlash", 315, 175, "8", "#FFFFFF");
				so.addParam("wmode", "transparent");
				so.addVariable("flower", this.assets_path + "img/wel-sunflower" + sub + ".png");
				so.addVariable("image", this.assets_path + "img/wel-rachael" + sub + ".jpg");
				so.addVariable("flv", this.assets_path + "flv/2108clubrrpromo.flv");
				so.addVariable("section", section);
				so.write("WelcomeBox");
			}
		}
	},
	
	sharebox : function() {
		$(".sharebox > a.share").click(function() {
			if ($(this).parent().find("ul").css("display") == "none") {
				$(this).css("background-position", "5px -12px");
				$(this).parent().find("ul").slideDown("fast");
				$(this).parent().find("div").css("display", "block");
			} else {
				$(this).css("background-position", "5px 0px");
				$(this).parent().find("ul").slideUp("fast");
				$(this).parent().find("div").css("display", "none");
			}
		}).attr("href", "javascript:void(0);");
	},

	promo_be_on_the_show : function() {
		if ($("#BeOnTheShowTV").size() > 0) {
			var so = new SWFObject(this.assets_path + "fla/beontheshow.swf", "PromoBeOnTheShowFlash", "224", "147", "8", "#FFFFFF");
			so.addParam("allowScriptAccess", "always");
			so.addParam("scale", "noscale");
			so.addParam("salign", "T");
			so.addParam("wmode", "transparent");
			so.addVariable("front", "false");
			so.write("BeOnTheShowTV");
		}
		
	},

	promo_cook_with_rach : function() {		
		if ($("#PromoCookWithRach").size() > 0) {
			var so = new SWFObject(this.assets_path + "fla/cookwithrach.swf", "PromoCookWithRachFlash", "613", "220", "8", "#FFFFFF");
			so.addParam("allowScriptAccess", "always");
			so.addParam("scale", "noscale");
			so.addParam("salign", "T");
			so.addParam("wmode", "transparent");
			so.addVariable("front", "false");
			so.write("PromoCookWithRach");
		}
	},
	
	orphan_navs : new Array("tips-and-stories", "buddies", "celeb-friends", "behind-the-scenes"),
	
	check_orphan_navs : function() {
		for (var item in this.orphan_navs) {
			var slug = this.orphan_navs[item];
			if ($("body." + slug).size() > 0) {
				$("#SubNavigation").find("a." + slug).addClass("active");
			}
		}
	},
		
	

	setNavigation : function() {
		if ($("#Navigation").size() > 0){			
			$("#Navigation > ul > li").hover(
				function () {
					$(this).find('ul').css('visibility', 'visible');
				}, 
				function () {
					$(this).find('ul').css('visibility', 'hidden');
				}
			);
			$("#Navigation > ul > li").each(function(){
				if ($(this).find('ul > li').size() > 0){
				  if ($(this).find('ul').outerWidth) {
  					if ($(this).find('ul').outerWidth() < $(this).outerWidth()) {
	  					$(this).find('ul').css('width', ($(this).outerWidth() - 4));
		  			}
		  		}
				}
			});			
		}
	},
	
	setStyleHome : function() {
		if ($("#MessageBoardBox").size() > 0) {
			$("#MessageBoardBox ul li").css('cursor', 'pointer').click(function() {
				window.location.href = $(this).find('h6 a').attr('href');
			});
		}
	},
	
	init : function() {
		this.welcome();
		this.mark_last();
		this.mark_first();
		this.clean_hr();
		this.sifr();
		this.init_showcase();
		this.init_giveaway();
		this.sharebox();
		this.promo_cook_with_rach();
		this.promo_be_on_the_show();
		this.check_cookie();
		this.check_orphan_navs();
		
		this.setNavigation();
		
		this.setStyleHome();
	}
	
};

$(function() {
	trapeze.RachaelRay.init();
});

//////////////////// scroll ////////////////////////////////////////////////////////////////////////////
jQuery.getPos = function (e)
{
	var l = 0;
	var t  = 0;
	var w = jQuery.intval(jQuery.css(e,'width'));
	var h = jQuery.intval(jQuery.css(e,'height'));
	var wb = e.offsetWidth;
	var hb = e.offsetHeight;
	while (e.offsetParent){
		l += e.offsetLeft + (e.currentStyle?jQuery.intval(e.currentStyle.borderLeftWidth):0);
		t += e.offsetTop  + (e.currentStyle?jQuery.intval(e.currentStyle.borderTopWidth):0);
		e = e.offsetParent;
	}
	l += e.offsetLeft + (e.currentStyle?jQuery.intval(e.currentStyle.borderLeftWidth):0);
	t  += e.offsetTop  + (e.currentStyle?jQuery.intval(e.currentStyle.borderTopWidth):0);
	return {x:l, y:t, w:w, h:h, wb:wb, hb:hb};
};
jQuery.getClient = function(e)
{
	if (e) {
		w = e.clientWidth;
		h = e.clientHeight;
	} else {
		w = (window.innerWidth) ? window.innerWidth : (document.documentElement && document.documentElement.clientWidth) ? document.documentElement.clientWidth : document.body.offsetWidth;
		h = (window.innerHeight) ? window.innerHeight : (document.documentElement && document.documentElement.clientHeight) ? document.documentElement.clientHeight : document.body.offsetHeight;
	}
	return {w:w,h:h};
};
jQuery.getScroll = function (e) 
{
	if (e) {
		t = e.scrollTop;
		l = e.scrollLeft;
		w = e.scrollWidth;
		h = e.scrollHeight;
	} else  {
		if (document.documentElement && document.documentElement.scrollTop) {
			t = document.documentElement.scrollTop;
			l = document.documentElement.scrollLeft;
			w = document.documentElement.scrollWidth;
			h = document.documentElement.scrollHeight;
		} else if (document.body) {
			t = document.body.scrollTop;
			l = document.body.scrollLeft;
			w = document.body.scrollWidth;
			h = document.body.scrollHeight;
		}
	}
	return { t: t, l: l, w: w, h: h };
};

jQuery.intval = function (v)
{
	v = parseInt(v);
	return isNaN(v) ? 0 : v;
};

jQuery.fn.ScrollTo = function(s) {
	o = jQuery.speed(s);
	return this.each(function(){
		new jQuery.fx.ScrollTo(this, o);
	});
};

jQuery.fx.ScrollTo = function (e, o)
{
	var z = this;
	z.o = o;
	z.e = e;
	z.p = jQuery.getPos(e);
	z.s = jQuery.getScroll();
	z.clear = function(){clearInterval(z.timer);z.timer=null};
	z.t=(new Date).getTime();
	z.step = function(){
		var t = (new Date).getTime();
		var p = (t - z.t) / z.o.duration;
		if (t >= z.o.duration+z.t) {
			z.clear();
			setTimeout(function(){z.scroll(z.p.y, z.p.x)},13);
		} else {
			st = ((-Math.cos(p*Math.PI)/2) + 0.5) * (z.p.y-z.s.t) + z.s.t;
			sl = ((-Math.cos(p*Math.PI)/2) + 0.5) * (z.p.x-z.s.l) + z.s.l;
			z.scroll(st, sl);
		}
	};
	z.scroll = function (t, l){window.scrollTo(l, t)};
	z.timer=setInterval(function(){z.step();},13);
};
