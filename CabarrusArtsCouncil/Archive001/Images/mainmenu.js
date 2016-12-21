function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}
function changeImagesArray(array) {
	if (preloadFlag == true) {
		var d = document; var img;
		for (var i=0; i<array.length; i+=2) {
			img = null; var n = array[i];
			if (d.images) {img = d.images[n];}
			if (!img && d.getElementById) {img = d.getElementById(n);}
			if (img) {img.src = array[i+1];}
		}
	}
}
function changeImages() {
	changeImagesArray(changeImages.arguments);
}
var preloadFlag = false;
function preloadImages() {
	if (document.images) {
		pre_calendar02 = newImage('/media/media/calendar02.jpg');
		pre_staff02 = newImage('/media/media/staff02.jpg');
		pre_photogallery02 = newImage('/media/media/photogallery02.jpg');
		pre_home02 = newImage('/media/media/home02.jpg');
		pre_about02 = newImage('/media/media/about02.jpg');
		pre_news02 = newImage('/media/media/news02.jpg');
		pre_programs02 = newImage('/media/media/programs02.jpg');
		pre_grants02 = newImage('/media/media/grants02.jpg');
		pre_volunteers02 = newImage('/media/media/volunteers02.jpg');
		pre_contributions02 = newImage('/media/media/contributions02.jpg');
		pre_comments02 = newImage('/media/media/comments02.jpg');
		pre_links02 = newImage('/media/media/links02.jpg');
		pre_contact02 = newImage('/media/media/contact02.jpg');
		pre_galleries02 = newImage('/media/media/galleries02.jpg');
		pre_shopping02 = newImage('/media/media/shopping02.jpg');
		pre_theatre02 = newImage('/media/media/theatre02.jpg');
		preloadFlag = true;
	}
}