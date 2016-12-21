js = {
	confirmVideoDelete: function(id){
		var video = $("video_"+id);
		var mess = confirm("Are you sure you want to delete this video file?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteVideo:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						video.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	

	confirmPhotoDelete: function(id){
		var photo = $("photo_"+id);
		var mess = confirm("Are you sure you want to delete this photo from the album?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deletePhoto:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						photo.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	
	
	confirmAlbumDelete: function(id){
		var album = $("album_"+id);
		var mess = confirm("Are you sure you want to delete this album and all its photos?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteAlbum:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						album.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	
	
	
	confirmClientDelete: function(id){
		var client = $("client_"+id);
		var mess = confirm("Are you sure you want to delete this client from the list?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteClient:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						client.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	
	
	confirmCharityDelete: function(id){
		var charity = $("charity_"+id);
		var mess = confirm("Are you sure you want to delete this charity from the list?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteCharity:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						charity.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	

	confirmAppearanceDelete: function(id){
		var charity = $("appearance_"+id);
		var mess = confirm("Are you sure you want to delete this appearance from the list?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteAppearance:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						charity.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	
	
	confirmBookDelete: function(id){
		var record = $("record_"+id);
		var mess = confirm("Are you sure you want to delete this book from the list?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteBook:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						record.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	
	
	confirmArticleDelete: function(id){
		var record = $("record_"+id);
		var mess = confirm("Are you sure you want to delete this article from the list?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteArticle:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						record.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	
	
	confirmWeddingServiceDelete: function(id){
		var service = $("WS_"+id);
		var mess = confirm("Are you sure you want to delete this service from the list?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteWeddingService:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						service.hide();
					}
				}
				);
		}else{
			return false;
		}
	},	
	
	
	confirmGalleryDelete: function(id){
		var video = $("gallery_"+id);
		var mess = confirm("Are you sure you want to delete this gallery and \n all the photos associated to it?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteGallery:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						video.hide();
					}
				}
				);
		}else{
			return false;
		}
	},
	
	confirmFavianaCategoryDelete: function(id){
		var video = $("video_"+id);
		var mess = confirm("Are you sure you want to delete this category?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteFavianaCategory:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						video.hide();
					}
				}
				);
		}else{
			return false;
		}
	},
	
	confirmMFWCategoryDelete: function(id){
		var video = $("video_"+id);
		var mess = confirm("Are you sure you want to delete this category?");
		var url="updatedb.php";
			
		var pars = Object.toQueryString({deleteMFWCategory:'true',id:id});
		if (mess){
			new Ajax.Request(
				url,
				{
					postBody:pars,
					asynchronous:true,
					onComplete: function(element){ 
						video.hide();
					}
				}
				);
		}else{
			return false;
		}
	},
	
	insertWeddingService: function(){
		var url="updatedb.php";
			
		new Ajax.Updater("success", url,{method: 'post', parameters: $('insertWeddingService').serialize() } );
  		$('insertWeddingService').reset();

	},
	
	
	validateForm:function(){
		var name = $F("name");
		var email = $F("email");
		var phone = $F("phone");
		var comments = $F("comment");
		
		return checkForEmptyField(name);
		return checkForEmptyField(email);
		return checkForEmptyField(phone);
		return checkForEmptyField(comments);
	},
	
	swapWidgetImages: function(){
		$$('#homeWidgetContainer img').each(function(item) {
			var originalImage = item.src;
			var ext =  originalImage.substr(-4);
			var newImage = originalImage.substr(0,originalImage.length - 4) + "_over" + ext;
			item.observe('mouseover', function() {
				item.setStyle({cursor:'pointer'});
				item.src = newImage;
			});
			
			item.observe('mouseout', function() {
				item.src = originalImage;
			});
		})
	},

	editFieldInPlace:function(id,evt,which){
		var thisClass = this;
		$(id).stopObserving(evt);
		var old = id.innerHTML;
		var fieldId = id.id+'_toSave';
		id.innerHTML = '<input type="text" value="'+old+'" id="'+fieldId+'" name="'+fieldId+'"/>';
		$(fieldId).focus();
		
		$(fieldId).observe('blur',function(){
			thisClass.saveFieldInPlace(this,evt,which);
		});

	},
	
	saveFieldInPlace:function(id,evt,which){
		var thisClass = this;
		var fieldValue = $(id).value;
		var containerId = $(id).id.replace("_toSave","");
		switch(which){
			case 1:
				thisClass.updateGalleryName(id);
			break;
			
			case 2:
				thisClass.updateAlbumName(id);
			break;
			
			case 3:
				thisClass.updateClientName(id);
			break;
			
		}
		$(containerId).innerHTML = fieldValue ;
		
		$(containerId).observe(evt,function(){
			thisClass.editFieldInPlace(this,evt,which);
		});
	},
	
	 
	updateGalleryName:function(field){
		var value = $(field).value;
		var tmp = $(field).id.replace("_toSave","");
		var id = tmp.replace("name_","");
		var url="updatedb.php";
		var pars = Object.toQueryString({updateGalleryName:'true',id:id, name:value});
		new Ajax.Request(
			url,{
				postBody:pars,
				asynchronous:true,
				onComplete: function(element){ 
				}
			});
	 },
	 
	updateAlbumName:function(field){
		var value = $(field).value;
		var tmp = $(field).id.replace("_toSave","");
		var id = tmp.replace("name_","");
		var url="updatedb.php";
		var pars = Object.toQueryString({updateAlbumName:'true',id:id, name:value});
		new Ajax.Request(
			url,{
				postBody:pars,
				asynchronous:true,
				onComplete: function(element){ 
				}
			});
	 },
	 
	updateClientName:function(field){
		var value = $(field).value;
		var tmp = $(field).id.replace("_toSave","");
		var id = tmp.replace("name_","");
		var url="updatedb.php";
		var pars = Object.toQueryString({updateClientName:'true',id:id, name:value});
		new Ajax.Request(
			url,{
				postBody:pars,
				asynchronous:true,
				onComplete: function(element){ 
				}
			});
	 }


};


function checkForEmptyField(f){
	if(f=='' ||	 f==' ') return false;
}

function setWYSIWYG(w,h){
	(w==null)?w = "": w=w;
	(h==null)?h = "": h=h;
	tinyMCE.init({
		// General options
		//mode : "specific_textareas",
		//editor_selector : "mceEditor",
		mode : "textareas",
		theme : "advanced",
		plugins : "pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,contextmenu,directionality,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist",

		// Theme options
		theme_advanced_buttons1 : "bold,italic,underline,removeformat,link",
		theme_advanced_buttons2: "",
		theme_advanced_buttons3: "",
		theme_advanced_buttons4: "",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : false,
		width:w,
		height:h,

		// Example content CSS (should be your site CSS)
		content_css : "css/content.css",

	});
}

function setVideoPlayer(container, dir,video){
	
	
	flowplayer(container, "../video/player/flowplayer.commercial-3.2.2.swf",  {
		key:'#$81ba2ef3601312fc6fa',
		clip: {
			url: dir + video,
			scaling:'fit'
		}
	});
		
}

function setVideoPlayerViaLink(container, dir,video){
		
	flowplayer(container, "../video/player/flowplayer.commercial-3.2.2.swf",  {
		key:'#$81ba2ef3601312fc6fa',
		clip: {
			url: dir + video,
			scaling:'fit'
		}
	});
		
}

function setVideoPlayerWithThumb(container, video,thumb){
	
	
	flowplayer(container, "../video/player/flowplayer.commercial-3.2.2.swf",  {
		key:'#$81ba2ef3601312fc6fa',
		clip: {
			url: video,
			scaling:'fit'
		}
	});
		
}


function addMoreFields(container,options){
	this.options = options || {};
	var field = document.createElement('input');
	var br = document.createElement('br');
	var className = this.options.class || "fields";
	field.name = this.options.name || "file";
	field.type = this.options.type || "file";
	field.addClassName(className);
	$(container).appendChild(field);
	$(container).appendChild(br);
}