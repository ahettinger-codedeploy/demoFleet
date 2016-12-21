/*

copyright @ 2010 Steven Albarracin www.stevenalbarracin.com

*/

var SlideShow = Class.create({	
	initialize:function(dir,photo_id,credit_id,backButton,forwardButton,options){
		this.directory = dir;
		this.blankImage = "images/img_photo_none.jpg";
		this.leftButtonSrc = "images/slide_left.jpg";
		this.leftButtonNoneSrc = "images/slide_left_none.jpg";
		this.rightButtonSrc = "images/slide_right.jpg";
		this.rightButtonNoneSrc = "images/slide_right_none.jpg";
		this.photos = [];
		this.credits = [];
		this.widths = [];
		this.heights = [];
		this.photosExist = false;
		for(var i= 0; i < options['photo'].length; i++){
			this.photosExist = true;
			this.photos[i] = options['photo'][i];
			//this.credits[i] = options['credit'][i];
			this.widths[i] = options['width'][i];
			this.heights[i] = options['height'][i];
		}
		this.preloadImages(options['photo']);
		this.activeIndex = 0;
		this.lastIndex = this.photos.length -1;
		this.lbutton = $(backButton);
		this.rbutton = $(forwardButton);
		this.image = $(photo_id);
		this.credit = $(credit_id);
		this.imagePopUpLink = $('lightbox_link');
		this.setDefault();
	},
	
	nextImage:function(){
		//this.image.src = "";
		if(this.activeIndex != this.lastIndex) this.activeIndex = this.activeIndex +1;
		if(this.activeIndex == this.lastIndex) {this.rbutton.src = this.rightButtonNoneSrc; this.rbutton.removeClassName('pointer');}
		if(this.activeIndex != 0) {this.lbutton.src = this.leftButtonSrc; this.lbutton.addClassName('pointer');}
		
		this.image.src = this.directory+this.photos[this.activeIndex];
		this.image.width = this.widths[this.activeIndex];
		this.image.height = this.heights[this.activeIndex];
		this.imagePopUpLink.href = this.directory+this.photos[this.activeIndex];
		//this.credit.innerHTML = "Photo by "+this.credits[this.activeIndex];
	},
	
	prevImage:function(){
		//this.image.src = "";
		if(this.activeIndex != 0) this.activeIndex = this.activeIndex - 1;
		if(this.activeIndex != this.lastIndex) this.rbutton.src = this.rightButtonSrc;
		if(this.activeIndex == 0) {this.lbutton.src = this.leftButtonNoneSrc;this.lbutton.removeClassName('pointer');}
		
		this.image.src = this.directory+this.photos[this.activeIndex];
		this.image.width = this.widths[this.activeIndex];
		this.image.height = this.heights[this.activeIndex];
		this.imagePopUpLink.href = this.directory+this.photos[this.activeIndex];
		//this.credit.innerHTML = "Photo by "+this.credits[this.activeIndex];
	},
	
	setDefault:function(){
		if(this.photosExist){
			this.image.src =  this.directory+this.photos[0];
			//this.credit.innerHTML = "Photo by "+this.credits[0];
			this.image.width = this.widths[0];
			this.image.height = this.heights[0];
			this.lbutton.setAttribute("onclick","slideshow.prevImage()");
			this.rbutton.setAttribute("onclick","slideshow.nextImage()");
			this.rbutton.addClassName('pointer');
		}else{
			this.showBlankImage();
		}
	},
	
	showBlankImage:function(){
		this.image.src =  this.blankImage;
		//this.credit.innerHTML = "";
		this.image.width = 470;
		this.image.height = 375;
		this.rbutton.src = this.rightButtonNoneSrc;
		this.lbutton.src = this.leftButtonNoneSrc;
	},
	
	preloadImages:function(arr){
		var images =  new Array;
		for(var i= 0; i < arr.length; i++){
			images[i] = this.directory + arr[i];
		}

		
		imagesQueue = imagesQ;
		imagesQueue.queue_images(images);
		imagesQueue.process_queue();
	}
});



