/* SLIDER
author: Jason Logan
*******************************/
var Slider = function(id, option) {
  this.create(id, option);
}
var SliderArray = new Array();

$.extend(Slider.prototype, {
	_id : '',
	_self : 0,
	_elem : '',
	/* Editable Options */
	_autoSlide : 2000,
	_moveCount : 1,
	_showArrows : true,
	_showNumbers : true,
	_leftDirection : true,
	_continuous : false,
	_effect : 'none', /*none,fade,slide,wipe*/
	_wipeImage : '',
	/* End Editable Options */
	_leftArrow : '',
	_rightArrow : '',
	_numbers : '',
	_numberList : '',
	_slides :'',
	_slidewidth : '',
	_slidecontainer : '',
	_current : 0,
	_timer : 0,
	_navbar :'',
	
	create: function(id, option){
		this._id = id;
		this._self = SliderArray.length;
		this._elem = $(id)[0];
		this._slides = $('ul.slides>li',this._elem);
		this._slidecontainer = $('ul.slides',this._elem).first();
		this._slidewidth = $(this._slides).css('width').replace('px','');
		if(typeof(option)!="undefined"){
			if(typeof(option.moveCount)!="undefined"){this._moveCount = option.moveCount;}
			if(typeof(option.showArrows)!="undefined"){this._showArrows = option.showArrows;}
			if(typeof(option.showNumbers)!="undefined"){this._showNumbers = option.showNumbers;}
			if(typeof(option.autoSlide)!="undefined"){this._autoSlide = option.autoSlide;}
			if(typeof(option.effect)!="undefined"){this._effect = option.effect;}
			if(typeof(option.leftDirection)!="undefined"){this._leftDirection = option.leftDirection;}
			if(typeof(option.wipeImage)!="undefined"){this._wipeImage = option.wipeImage;}
			if(typeof(option.continuous)!="undefined"){this._continuous = option.continuous;}
		}
		// ARROWS
		if(this._showArrows){
			this._leftArrow = $('<div class="arrow-left">&lt;</div>').bind('click', {direction:(this._leftDirection?1:-1), obj:this}, this.moveSlides);
			this._rightArrow = $('<div class="arrow-right">&gt;</div>').bind('click', {direction:(!this._leftDirection?1:-1), obj:this}, this.moveSlides);
			$(this._elem).append(this._leftArrow);
			$(this._elem).append(this._rightArrow);
		}
		// AUTO SLIDE
		if(this._autoSlide != 0){
			this._timer = setTimeout('SliderArray['+this._self+'].autoMoveSlide('+this._self+');',this._autoSlide);
		}
		// NUMBERS
		if(this._showNumbers){
			this._numbers = new Array();
			this._numberList = $(document.createElement('ul')).addClass('numbers');
			for(x=0;x<Math.ceil(this._slides.length / this._moveCount);x++){
				this._numbers[x] = $(document.createElement('li')).html(x+1).bind('click', {slide:x, obj:this}, this.selectSlide);
				if(x == 0){$(this._numbers[x]).addClass('active');}
				this._numberList.append(this._numbers[x]);
			}
			$(this._elem).append(this._numberList);
		}
		
		// GROWING EFFECT (WIPE ONLY)
		if($('.grow', this._elem).length > 0){
			for(x=0;x<this._slides.length;x++){
				test1 = $('.grow', $(this._slides[x]))
				if(test1.length > 0){
					this._slides[x].grow = test1;
					for(y=0;y<this._slides[x].grow.length;y++){
						this._slides[x].grow[y].baseheight = $(this._slides[x].grow[y]).height();
						this._slides[x].grow[y].basewidth = $(this._slides[x].grow[y]).width();
						$(this._slides[x].grow[y]).height(this._slides[x].grow[y].baseheight * 0.8 + 'px');
						$(this._slides[x].grow[y]).width(this._slides[x].grow[y].basewidth * 0.8 + 'px');
						if(x==0){
							$(this._slides[x].grow[y]).animate({'width':this._slides[x].grow[y].basewidth,'height':this._slides[x].grow[y].baseheight},{'duration':1000,'easing':'linear','queue':false});
						}
					}
				}
			}
		}
		
		// ZOOM EFFECT (WIPE ONLY)
		if($('.zoom', this._elem).length > 0){
			basesize = 0.85;
			for(x=0;x<this._slides.length;x++){
				test1 = $('.zoom img', $(this._slides[x]))
				if(test1.length > 0){
					this._slides[x].zoom = test1;
					$(this._slides[x]).css('position','absolute');
					for(y=0;y<this._slides[x].zoom.length;y++){
						this._slides[x].zoom[y].baseheight = $(this._slides[x].zoom[y]).height();
						this._slides[x].zoom[y].basewidth = $(this._slides[x].zoom[y]).width();
						$(this._slides[x].zoom[y]).height((this._slides[x].zoom[y].baseheight * basesize) + 'px');
						$(this._slides[x].zoom[y]).width((this._slides[x].zoom[y].basewidth * basesize) + 'px');
						off = $(this._slides[x].zoom[y]).position();
						if (navigator.appName == 'Microsoft Internet Explorer')
						{
							$(this._slides[x].zoom[y]).parent().parent().append($('<img style="visibility:hidden; width:'+this._slides[x].zoom[y].basewidth+'px; height:'+this._slides[x].zoom[y].baseheight+'px;" />'));
						}else{
							$(this._slides[x].zoom[y]).parent().parent().append($('<div style="display:inline-block; vertical-align:middle; width:'+this._slides[x].zoom[y].basewidth+'px; height:'+this._slides[x].zoom[y].baseheight+'px;" />'));							
						}
						
						this._slides[x].zoom[y].basesize = basesize;
						$(this._slides[x].zoom[y]).css(
							{
								'padding-top':(this._slides[x].zoom[y].baseheight * (1-basesize)/2) + 'px',
								'padding-bottom':(this._slides[x].zoom[y].baseheight * (1-basesize)/2) + 'px',
								'padding-left':(this._slides[x].zoom[y].basewidth * (1-basesize)/2) + 'px',
								'padding-right':(this._slides[x].zoom[y].basewidth * (1-basesize)/2) + 'px',
								'top':off.top,
								'left':off.left,
								'position':'absolute'
							});
						$(this._slides[x].zoom[y]).bind('mouseover', function(){
							$(this).animate(
								{
									'width':this.basewidth + 'px',
									'height':this.baseheight + 'px',
									'padding-top':0,
									'padding-bottom':0,
									'padding-left':0,
									'padding-right':0
								},
								{
									'duration':200,
									'easing':'linear'
								}
							);
						});
						$(this._slides[x].zoom[y]).bind('mouseout', function(){
							$(this).animate(
								{
									'width':this.basewidth*this.basesize + 'px',
									'height':this.baseheight*this.basesize + 'px',
									'padding-top':this.baseheight*(1-basesize)/2 + 'px',
									'padding-bottom':this.baseheight*(1-basesize)/2 + 'px',
									'padding-left':this.basewidth*(1-basesize)/2 + 'px',
									'padding-right':this.basewidth*(1-basesize)/2 + 'px'
								},
								{
									'duration':200,
									'easing':'linear'
								}
							);
						});
					}
				}
			}
		}
		
		// WIPE EFFECT
		if(this._effect == 'wipe'){
			co = this._moveCount;
			$(this._slides).css({'position':'absolute','top':0,
				'display':function(index){
					return(Math.floor(index / co) == 0? 'block':'none');
				},
				'left':0});
			this._wiperWidth = $(this._elem).css('width').replace('px','')*2;
			this._wiper = $(
			'<div style="'+
				'position:absolute; top:0; left:'+$(this._elem).css('width').replace('px','')*-2+'px;'+
				'width:'+this._wiperWidth+'px; '+
				'height:'+$(this._elem).css('height')+';'+
				'background:url('+this._wipeImage+');'+
				'">'+
			'</div>');
			$(this._elem).append(this._wiper);
		// FADE EFFECT
		}else if(this._effect != 'fade'){
			$(this._slides).css({'position':'absolute','top':0,'left':function(index){jQuery.data(this,'left', $(this).css('width').replace('px','')*1); return index * $(this).css('width').replace('px',''); }});
		// OTHER EFFECTS
		}else{
			co = this._moveCount;
			$(this._slides).css({'position':'absolute','top':0,
				'opacity':function(index){
					return(Math.floor(index / co) == 0? 1:0);
				},
				'display':function(index){
					return(Math.floor(index / co) == 0? 'block':'none');
				},
				'left':0});
		}
		
		// NAVBAR
		if($('.navbar', this._elem).length > 0){
			if($('.navbar a', this._elem).length > 0){
				nav = $('.navbar a', this._elem);
				for(x=0;x<nav.length;x++){
					$(nav[x]).bind('mouseover', {slide:x, obj:this}, this.pause).bind('mouseout', {slide:x, obj:this}, this.unpause);
				}
			}
			if($('.navbar span', this._elem).length > 0){
				nav = $('.navbar span', this._elem);
				for(x=0;x<nav.length;x++){
					$(nav[x]).bind('click', {slide:x, obj:this}, this.selectSlide);
				}
			}
			if($('.navbar a, .navbar span', this._elem).length > 0){
				this._navbar = $('.navbar a, .navbar span', this._elem);
				$(this._navbar[0]).addClass('active');
			}
		}
		
		// PAUSE
		if($('.pause', this._elem).length > 0){
			$('.pause', this._elem).bind('mouseover', {slide:-1, obj:this}, this.pause).bind('mouseout', {slide:-1, obj:this}, this.unpause);
		}
		
	},
	moveSlides: function(eve){
		if(eve.data.obj._autoSlide != 0){clearTimeout(eve.data.obj._timer);}
		if($(':animated',eve.data.obj._elem).length == 0 && $(':visible',eve.data.obj._elem).length > 0){
			if(eve.data.direction != 0){
				if(eve.data.obj._effect == 'none'){
					$(eve.data.obj._slides).css('left', 
						function(index){
							left = $(this).css('left').replace('px','')*1;
							movespace = eve.data.direction*eve.data.obj._slidewidth*eve.data.obj._moveCount;
							if(left + movespace < 0){
								move = left + movespace + ((eve.data.obj._slides.length % eve.data.obj._moveCount) + eve.data.obj._slides.length) * eve.data.obj._slidewidth;
							}else if(left + movespace >= ((eve.data.obj._slides.length % eve.data.obj._moveCount) + eve.data.obj._slides.length) * eve.data.obj._slidewidth){
								move = left + movespace - ((eve.data.obj._slides.length % eve.data.obj._moveCount) + eve.data.obj._slides.length) * eve.data.obj._slidewidth;
							}else{
								move = left + movespace;
							}
							return move;
						}
					);
				}else if(eve.data.obj._effect == 'slide'){
					
					for(x = 0; x<eve.data.obj._slides.length; x++){
						$(eve.data.obj._slides).css('left',
							function(index, value){
								left = $(this).css('left').replace('px','')*1;
								newleft = left;
								if(!(left >=0 && left < eve.data.obj._moveCount*eve.data.obj._slidewidth)){
									if(eve.data.direction > 0){
										if((left>=0)){
											newleft = (left - ((eve.data.obj._slides.length % eve.data.obj._moveCount != 0 && !eve.data.obj._continuous?(eve.data.obj._moveCount - (eve.data.obj._slides.length % eve.data.obj._moveCount)):0) + eve.data.obj._slides.length) * eve.data.obj._slidewidth);
									
									
										}
									}else if(eve.data.direction < 0){
										if((left<0)){
											newleft = (left + ((eve.data.obj._slides.length % eve.data.obj._moveCount != 0 && !eve.data.obj._continuous?(eve.data.obj._moveCount - (eve.data.obj._slides.length % eve.data.obj._moveCount)):0) + eve.data.obj._slides.length) * eve.data.obj._slidewidth);
										}
									}
								}
								return newleft;
							}					
						);
						movespace = eve.data.direction*eve.data.obj._slidewidth*eve.data.obj._moveCount;
						$(eve.data.obj._slides[x]).animate({'left':'+='+movespace},{'duration':'slow','queue':false});
					}
				}else if(eve.data.obj._effect == 'fade'){
					for(x=0;x<eve.data.obj._slides.length;x++){
						nextslide = eve.data.obj._current - eve.data.direction;
						if(nextslide < 0){
							nextslide += Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
						}else if(nextslide >= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount)){
							nextslide -= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
						}
						if(Math.floor(x / eve.data.obj._moveCount) == nextslide){
							$(eve.data.obj._slides[x]).css('display','block');
							$(eve.data.obj._slides[x]).animate({'opacity':'1'},{'duration':'slow','queue':false});
						}else if(Math.floor(x / eve.data.obj._moveCount) == eve.data.obj._current){
							$(eve.data.obj._slides[x]).animate({'opacity':'0'},{'duration':'slow','queue':false,'complete':function(){$(this).css('display','none');}});
						}
					}
				}else if(eve.data.obj._effect == 'wipe'){
					eve.data.obj._wiper.eve = eve; 
					nextslide = eve.data.obj._current - eve.data.direction;
					if(nextslide < 0){
						nextslide += Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
					}else if(nextslide >= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount)){
						nextslide -= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
					}
					
					ttimeout = "$(SliderArray['"+eve.data.obj._self+"']._slides["+eve.data.obj._current+"]).css('display','none'); "+
					"$(SliderArray['"+eve.data.obj._self+"']._slides["+nextslide+"]).css('display','block'); "
					
					
					if(eve.data.obj._slides[nextslide].grow){
						for(y=0; y < eve.data.obj._slides[nextslide].grow.length;y++){
							$(eve.data.obj._slides[nextslide].grow[y]).animate({'width': eve.data.obj._slides[nextslide].grow[y].basewidth,'height': eve.data.obj._slides[nextslide].grow[y].baseheight},3000, 'linear');
							
						}
					}
					
					if(eve.data.obj._slides[eve.data.obj._current].grow){
						for(y=0; y<eve.data.obj._slides[eve.data.obj._current].grow.length; y++){
							ttimeout +=	"$(SliderArray['"+eve.data.obj._self+"']._slides["+eve.data.obj._current+"].grow["+y+"]).height('" + eve.data.obj._slides[eve.data.obj._current].grow[y].baseheight * 0.8 + "px');";
							ttimeout +=	"$(SliderArray['"+eve.data.obj._self+"']._slides["+eve.data.obj._current+"].grow["+y+"]).width('" + eve.data.obj._slides[eve.data.obj._current].grow[y].basewidth * 0.8 + "px');";
						}
						
						//ttimeout +=	"$(SliderArray['"+eve.data.obj._self+"']._slides["+eve.data.obj._current+"].grow[y]).height(SliderArray['"+eve.data.obj._self+"']._slides["+eve.data.obj._current+"].grow[y].baseheight * 0.8 + 'px');$(SliderArray['"+eve.data.obj._self+"']._slides["+eve.data.obj._current+"].grow[y]).height(SliderArray['"+eve.data.obj._self+"']._slides["+eve.data.obj._current+"].grow[y].basewidth * 0.8 + 'px'); "	
					}
					
					setTimeout(ttimeout,2000);
					
					$(eve.data.obj._wiper).animate({'left':(eve.data.obj._wiperWidth)+'px'},{'duration':5000,'easing':'linear','queue':false,'complete':function(){$(eve.data.obj._wiper).css('left',eve.data.obj._wiperWidth*-1);}});
				}
				if(eve.data.obj._showNumbers){
					nextslide = eve.data.obj._current - eve.data.direction;
					if(nextslide < 0){
						nextslide += Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
					}else if(nextslide >= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount)){
						nextslide -= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
					}
					$(eve.data.obj._numbers[eve.data.obj._current]).removeClass('active');
					$(eve.data.obj._numbers[nextslide]).addClass('active');
				}
				if(eve.data.obj._navbar){
					nextslide = eve.data.obj._current - eve.data.direction;
					if(nextslide < 0){
						nextslide += Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
					}else if(nextslide >= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount)){
						nextslide -= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
					}
					$(eve.data.obj._navbar[eve.data.obj._current]).removeClass('active');
					$(eve.data.obj._navbar[nextslide]).addClass('active');
				}
				eve.data.obj._current -= eve.data.direction;
				if(eve.data.obj._current < 0){
					eve.data.obj._current += Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
				}else if(eve.data.obj._current >= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount)){
					eve.data.obj._current -= Math.ceil(eve.data.obj._slides.length / eve.data.obj._moveCount);
				}
				
			}
		}
		if(eve.data.obj._autoSlide != 0){eve.data.obj._timer = setTimeout('SliderArray['+eve.data.obj._self+'].autoMoveSlide('+eve.data.obj._self+');',eve.data.obj._autoSlide);}
	},
	selectSlide: function(eve){
		if(eve.data.slide != eve.data.obj._current){
			eve.data.direction = (eve.data.slide - eve.data.obj._current) *-1;
			eve.data.obj.moveSlides(eve);
		}
	},
	autoMoveSlide: function(id){
		eve = {data:{}};
		eve.data.obj = SliderArray[id];
		eve.data.direction = (!this._leftDirection?1:-1);
		SliderArray[id].moveSlides(eve);
	},
	pause: function(eve){
		clearTimeout(eve.data.obj._timer);
		tmp = eve.data.obj._autoSlide;
		eve.data.obj._autoSlide = 0;
		if(eve.data.slide!=-1){
			eve.data.obj.selectSlide(eve);
		}
		eve.data.obj._autoSlide = tmp;
	},
	unpause: function(eve){
		tmp = eve.data.obj._autoSlide;
		eve.data.obj._autoSlide = 0;
		if(eve.data.slide!=-1){
			eve.data.obj.selectSlide(eve);
		}
		eve.data.obj._autoSlide = tmp;		
		eve.data.obj._timer = setTimeout('SliderArray['+eve.data.obj._self+'].autoMoveSlide('+eve.data.obj._self+');',eve.data.obj._autoSlide);
	}
});
