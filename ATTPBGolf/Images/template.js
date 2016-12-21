/* Javscript Document  */

$(document).ready(function(){
	$('.left-timeline li').append('<div class="timeline-left-floaty"></div>');
	$('.right-timeline li').append('<div class="timeline-right-floaty"></div>');
	
	///
	
	$(".contact-form select").uniform();
	
	if(document.getElementById('map-canvas')){
      var map;
      function initialize() {
        var mapDiv = document.getElementById('map-canvas');
        map = new google.maps.Map(mapDiv, {
          center: new google.maps.LatLng(36.216345, -120.751465),
          zoom: 6,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });
      
        google.maps.event.addListenerOnce(map, 'tilesloaded', addMarkers);

      }
      function addMarkers() {
        var bounds = map.getBounds();
        var southWest = bounds.getSouthWest();
        var northEast = bounds.getNorthEast();
        var lngSpan = northEast.lng() - southWest.lng();
        var latSpan = northEast.lat() - southWest.lat();
     
        
		  
		     var latLng = new google.maps.LatLng(36.596373, -121.867476);
          var marker = new google.maps.Marker({
            position: latLng,
            map: map
          });
      
      }
      google.maps.event.addDomListener(window, 'load', initialize);
	}
	
	////
	
	if(document.getElementById('Email')){
		var email = document.getElementById('Email');
		email.onblur = function(){
			if( this.value == '' ){
				this.value = 'Enter email address...';
			}
		}
		email.onfocus = function(){
			if( this.value == 'Enter email address...' ){
				this.value = '';
			}
		}
	}
	
	if(document.getElementById('style-guide-tabs')){
		var styleGuideTabs = new Tabs('style-guide-tabs');
	}
	if(document.getElementById('homepage-tabs')){
		var styleGuideTabs = new Tabs('homepage-tabs');
	}
	if(document.getElementById('players-tabs')){
		var styleGuideTabs = new Tabs('players-tabs');
	}
	if(document.getElementById('birdies-faq-tabs')){
		var styleGuideTabs = new Tabs('birdies-faq-tabs');
	}
	if(document.getElementById('press-release-tabs')){
		var styleGuideTabs = new Tabs('press-release-tabs');
	}
	
	$("#btn-our-sites").click(function(){
		if($('#our-sites').hasClass("our-sites-active")){
			$('#our-sites').removeClass("our-sites-active");
			$('#btn-our-sites').removeClass("active-button");
			$('#our-sites').slideUp(350, function() {});
		}else{
			$('#our-sites').slideDown(350, function() {
	        $('#our-sites').addClass("our-sites-active"); 
			$('#btn-our-sites').addClass("active-button"); 
		});
		}
	});
	
	if(document.getElementById('countdown')){
		var myCountdown = new Countdown('countdown');
	}
	
	initHovers();


	
});

function toggleTicket(id){
	if(document.getElementById(id)){
		var moreInfo = false;
		var more = false;
		var div = document.getElementById(id);
		var divs = div.getElementsByTagName('div');
		for(var i=0;i<divs.length;i++){
			if(hasClass(divs[i],'more-info')){
				var moreInfo = divs[i];
			}
		}
		var as = div.getElementsByTagName('a');
		for(var i=0;i<as.length;i++){
			if(hasClass(as[i],'toggle-ticket')){
				var more = as[i];
			}
		}
		if(moreInfo.style.display != 'block'){
			moreInfo.style.display = 'block';
			more.innerHTML = 'less info -';
		}else{
			moreInfo.style.display = 'none';
			more.innerHTML = 'more info +';
		}
	}
}

function toggleStat(id,a){
	if(document.getElementById(id)){
		var div = document.getElementById(id);
		if(div.style.display != 'block'){
			div.style.display = 'block';
			addClass(a,'selected');
			a.innerHTML = a.innerHTML.replace('<span>More Info</span>','<span>Less Info</span>');
		}else{
			div.style.display = 'none';
			removeClass(a,'selected');
			a.innerHTML = a.innerHTML.replace('<span>Less Info</span>','<span>More Info</span>');
		}
	}
}

function initHovers(){
	$('.cta-caption-hover').each(function(index){
		$(this).css({ bottom: -1 * parseInt($(this).css('height')) });
	});
	$('.rollover').hover(function(){
		var captionHover = $(this).find('.cta-caption-hover')[0];
		var caption = $(this).find('.cta-caption')[0];
		$(captionHover).animate({bottom: 0}, {queue:false});
		$(caption).animate({left: -1 * ( parseInt($(caption).css('width')) + parseInt($(caption).css('padding-left')) + parseInt($(caption).css('padding-right')) ) }, {queue:false});
	}, function(){
		var captionHover = $(this).find('.cta-caption-hover')[0];
		var caption = $(this).find('.cta-caption')[0];
		$(captionHover).animate({bottom: -1 * ( parseInt($(captionHover).css('height')) + parseInt($(captionHover).css('padding-top')) + parseInt($(captionHover).css('padding-bottom')) )}, {queue:false});
		$(caption).animate({left: 0 }, {queue:false});
	});
} 

function Countdown(id){
	if(document.getElementById(id)){
		this.wrapper = document.getElementById(id);
		
		this.winId = "Countdown-" + Math.random().toString().substr(2);
		window[this.winId] = this;//grr scope on settimeout
		
		this.startDate = new Date();
		this.startTime = this.startDate.getTime();
		
		this.endDate = new Date(2014, 2, 6, 0, 0, 0, 0);
		this.endTime = this.endDate.getTime();
		
		this.step();
	}
}
Countdown.prototype.step = function(){
		clearTimeout(this.stepTimeout);
		var curDate = new Date();
		var curTime = curDate.getTime();
		
		var diff = this.endTime - curTime;
		
		var days = diff;
		days = days / (24*60*60*1000);
		days = Math.floor(days);
		
		var hours = diff - (days * (24*60*60*1000));
		hours = hours / (60*60*1000);
		hours = Math.floor(hours);
		
		var minutes = diff - (days * (24*60*60*1000)) - (hours * (60*60*1000));
		minutes = minutes / (60*1000);
		minutes = Math.floor(minutes);
		
		var seconds = diff - (days * (24*60*60*1000)) - (hours * (60*60*1000)) - (minutes * (60*1000));
		seconds = seconds / (1000);
		seconds = Math.floor(seconds);
		
		var html = '';
		html += '<p class="h2-dotted">The Countdown is on!</p>';
		html += '<div class="countdown-col"><span class="number">' + days + '</span><br /><span class="unit">days</span></div>';
		html += '<div class="countdown-col"><span class="number">' + hours + '</span><br /><span class="unit">hours</span></div>';
		html += '<div class="countdown-col"><span class="number">' + minutes + '</span><br /><span class="unit">minutes</span></div>';
		html += '<div class="countdown-col"><span class="number">' + seconds + '</span><br /><span class="unit">seconds</span></div>';
		html += '<div class="clr"></div>';
		
		this.wrapper.innerHTML = html;
		
		this.stepTimeout = setTimeout('window["'+this.winId+'"].step();', 500);
}

function Tabs(id){
	if(document.getElementById(id)){
		this.wrapper = document.getElementById(id);
		
		this.wrapper.style.display = 'block';
		
		this.tabs = new Array();
		
		this.navWrapper = document.createElement('ul');
		this.navWrapper.className = 'tabs-nav-wrapper';
		this.wrapper.insertBefore(this.navWrapper,this.wrapper.firstChild);
		
		this.divs = this.wrapper.getElementsByTagName('div');
		for(var i=0;i<this.divs.length;i++){
			if(hasClass(this.divs[i],'tab')){
				this.tabs[this.tabs.length] = this.divs[i];
			}
		}
		for(var i=0;i<this.tabs.length;i++){
			var p = this.tabs[i].getElementsByTagName('p');
			for(var ii=0;ii<p.length;ii++){
				if(hasClass(p[ii],'tab-nav')){
					this.tabs[i].nav = document.createElement('li');
					this.tabs[i].nav.innerHTML = p[ii].innerHTML;
					this.tabs[i].removeChild(p[ii]);
					this.tabs[i].nav.num = i;
					this.tabs[i].nav.cls = this;
					this.tabs[i].nav.onclick = function(){
						this.cls.setTab(this.num);
					}
					this.navWrapper.appendChild(this.tabs[i].nav);
				}	
			}
		}
		
		addClass(this.tabs[this.tabs.length-1].nav, 'last');
		
		var startTab = 0;
		if(window.location.hash){
			var hash = window.location.hash.substring(1);
			if(hash.indexOf('tab') > -1){
				startTab = parseInt( hash.substring(3) ) - 1;
			}
		}
		this.setTab(startTab);
	}
}
Tabs.prototype.setTab = function(tab){
	for(var i=0;i<this.tabs.length;i++){
		this.tabs[i].style.display = 'none';
		removeClass(this.tabs[i].nav,'selected');
	}
	this.tabs[tab].style.display = '';
	addClass(this.tabs[tab].nav,'selected');
}

function Fader(){
	this.containerId = 'footer-slider';
	this.btnPrevId = 'footer-slider-btn-left';
	this.btnNextId = 'footer-slider-btn-right';
	this.curSlide = 0;
	this.lastSlide = 0;
	this.startTime = 0;
	this.stepDuration = 400;
	this.slides = new Array();
}
Fader.prototype.init = function(){
	
	this.winId = "Fader-" + Math.random().toString().substr(2);
	window[this.winId] = this;//grr scope on settimeout
	
	this.container = document.getElementById(this.containerId);
	this.btnPrev = document.getElementById(this.btnPrevId);
	this.btnPrev.Fader = this;
	this.btnPrev.prevSlide = function(){
		if((this.Fader.curSlide - 1) < 0){
			this.Fader.setSlide(this.Fader.slides.length - 1);
		}else{
			this.Fader.setSlide(this.Fader.curSlide - 1);
		}
	}
	this.btnPrev.onclick = function(){
		this.prevSlide();
	}
	
	this.btnNext = document.getElementById(this.btnNextId);
	this.btnNext.Fader = this;
	this.btnNext.nextSlide = function(){
		if((this.Fader.curSlide + 1) >= this.Fader.slides.length){
			this.Fader.setSlide(0);
		}else{
			this.Fader.setSlide(this.Fader.curSlide + 1);
		}
	}
	this.btnNext.onclick = function(){
		this.nextSlide();
	}
	
	var divs = this.container.getElementsByTagName('div');
	for(var i=0;i<divs.length;i++){
		if(hasClass(divs[i],'slide')){
			this.slides.push(divs[i]);
//			divs[i].style.position = 'absolute';
//			divs[i].style.left = '0';
//			divs[i].style.top = '0';
		}
	}
	
//	this.dotsWrapper = document.createElement('ul');
//	this.dotsWrapper.className = 'dots-wrapper';
//	this.dotsWrapper.style.left = '50%';
//	this.dotsWrapper.style.marginLeft = '-' + Math.round( 15 * this.slides.length / 2 ) + 'px';
//	this.container.appendChild(this.dotsWrapper);
//	this.dots = new Array();
//	for(var i=0;i<this.slides.length;i++){
//		var dot = document.createElement('li');
//		dot.innerHTML = '&bull;';
//		dot.Fader = this;
//		dot.num = i;
//		dot.onclick = function(){
//			this.Fader.setSlide(this.num);
//		}
//		this.dotsWrapper.appendChild(dot);
//		this.dots.push(dot);
//	}
	
	if(this.slides.length <= 1){
		this.btnNext.style.display = 'none';
		this.btnPrev.style.display = 'none';
//		this.dotsWrapper.style.display = 'none';
	}else{
		this.btnNext.style.display = 'block';
		this.btnPrev.style.display = 'block';
		this.setSlide(this.curSlide);
		this.startAutoSlide();
	}
}
Fader.prototype.setOpacity = function(obj, start, end, cur){
	obj.startOpacity = start;
	obj.endOpacity = end;
	obj.curOpacity = cur;
	obj.style.filter = 'alpha(opacity=' + cur + ')';
	obj.style.MozOpacity = cur/100;
	obj.style.opacity = cur/100;
	
	if(obj.style.opacity == 1){
		obj.style.opacity = '';
	}
}
Fader.prototype.startAutoSlide = function(){
	this.autoSlide = setTimeout('window["'+this.winId+'"].btnNext.nextSlide();', 8000);
}
Fader.prototype.setSlide = function(num){
	for(var i=0;i<this.slides.length;i++){
		this.slides[i].style.zIndex = 0;
		this.setOpacity(this.slides[i],0,0,0);
//		this.dots[i].className = '';
	}
	if(this.curSlide != num){
		this.lastSlide = this.curSlide;
		this.curSlide = num;
		
		this.slides[this.lastSlide].style.zIndex = 1;
		this.setOpacity(this.slides[this.lastSlide],100,0,100);
		
		this.setOpacity(this.slides[this.curSlide],0,100,0);
		this.slides[this.curSlide].style.zIndex = 2;
		
		this.startTime = (new Date()).getTime();
		this.step();
	}else{
		this.setOpacity(this.slides[num],100,100,100);//First run and double click
		this.slides[num].style.zIndex = 2;
	}
//	this.dots[num].className = 'active';
}
Fader.prototype.step = function(){
	clearTimeout(this.animation);
	clearTimeout(this.autoSlide)
	var now = (new Date()).getTime();
	
	this.slides[this.curSlide].curOpacity = this.slides[this.curSlide].startOpacity + (this.slides[this.curSlide].endOpacity - this.slides[this.curSlide].startOpacity) * (now - this.startTime) / this.stepDuration;
	this.slides[this.lastSlide].curOpacity = this.slides[this.lastSlide].startOpacity + (this.slides[this.lastSlide].endOpacity - this.slides[this.lastSlide].startOpacity) * (now - this.startTime) / this.stepDuration;
	
	if(now - this.startTime > this.stepDuration){
		this.slides[this.curSlide].curOpacity = this.slides[this.curSlide].endOpacity;
		this.slides[this.lastSlide].curOpacity = this.slides[this.lastSlide].endOpacity;
	}
	if(this.slides[this.curSlide].curOpacity > 100){
		this.slides[this.curSlide].curOpacity = 100;
	}
	if(this.slides[this.lastSlide].curOpacity > 100){
		this.slides[this.lastSlide].curOpacity = 100;
	}
	if(this.slides[this.curSlide].curOpacity < 0){
		this.slides[this.curSlide].curOpacity = 0;
	}
	if(this.slides[this.lastSlide].curOpacity < 0){
		this.slides[this.lastSlide].curOpacity = 0;
	}
	
	this.setOpacity(this.slides[this.curSlide], this.slides[this.curSlide].startOpacity, this.slides[this.curSlide].endOpacity, parseInt(this.slides[this.curSlide].curOpacity));
	this.setOpacity(this.slides[this.lastSlide], this.slides[this.lastSlide].startOpacity, this.slides[this.lastSlide].endOpacity, parseInt(this.slides[this.lastSlide].curOpacity));
	
	if(this.slides[this.curSlide].curOpacity != this.slides[this.curSlide].endOpacity){
		this.animation = setTimeout('window["'+this.winId+'"].step();', 10);
	}else{
		this.setOpacity(this.slides[this.lastSlide],0,0,0);
		this.startAutoSlide();
	}
}
function hasClass(o,cls){var classes = o.className.split(' ');for(var i=0;i<classes.length;i++){if(classes[i] == cls){return true;}}return false;}
function addClass(o,cls){var classes = o.className.split(' ');classes.push(cls);o.className = classes.join(' ');}
function removeClass(o,cls){var classes = o.className.split(' ');var temp = new Array();for(var i=0;i<classes.length;i++){if(classes[i] == cls){classes.splice(i,1);}}o.className = classes.join(' ');}