/* Global Drawer functions
--------------------------------------------- 
// OPEN
function OpenDrawer(element){ 
	//remove the five-spacer
	//$('five-spacer').hide();
	$('drawer-content').removeClassName('closed');
	$('drawer-link').toggleClassName("on");
	new Effect.SlideDown(element, {
		duration:.7,
		afterFinish: function(effect)
			{ 
				$('drawer-content').addClassName('open');
			} 
		});
}

//CLOSE
function CloseDrawer(element){
	$('drawer-content').removeClassName('open');
	$('drawer-link').toggleClassName("on");
	new Effect.SlideUp(element, {
    		duration:.7,
    		afterFinish: function(effect)
				{ 
   					$('drawer-content').addClassName('closed');
				} 
			}); 
}

// Set general settings for the drawer
document.observe('dom:loaded',function(){
	$('drawer-content').addClassName('closed');
	//test();
	Event.observe($('drawer-link'), 'click', function() {
		if( $('drawer-content').hasClassName('closed') ) {
			OpenDrawer('drawer-content');
		}
		else if( $('drawer-content').hasClassName('open') ) {
			CloseDrawer('drawer-content');
		}
	});
	
	//this makes the drawer drift to the height of five-spacer
	Event.observe($('drawer-link'), 'mouseover', function() {
		//only drift down if drawer-content is not shown
		if( $('drawer-content').hasClassName('closed') ) {
			Effect.SlideDown('five-spacer', {duration:.20});
			return false;
		}
	});
	
	//this makes the drawer drift to the height of five-spacer
	Event.observe($('drawer-link'), 'mouseout', function() {
		if( $('drawer-content').hasClassName('closed') ) {
			Effect.SlideUp('five-spacer', {duration:.08});
			//return false;
			//$('five-spacer').hide();
			return false;
		}

	});
	//Event.observe($$('div').hasClassName('page-title'), 'mouseover', function() {
		//		CloseDrawer('drawer-content');
	//});
	//Event.observe($('main-container'), 'mouseover', function() {
		//CloseDrawer('drawer-content');
	//});
}); */

/* General Global functions
--------------------------------------------- */
function BlindEffect(element){
    new Effect.toggle(element, 'Blind', {duration:.7}); 
}

function ToggleFeatures(){
	/* This line dynamically removes the width setting from the tertiary div...having a width in ie6 makes the elements show up as the drawer is closing*/
	$('tertiary-news').setStyle({width: 'auto'});
	//new Effect.toggle($('tertiary-news-container'), 'Blind', {duration:.7});
	var isIE7 = /msie|MSIE 7/.test(navigator.userAgent);
	if(isIE7 == true) {
		//$('tertiary-news').toggle();
		new Effect.toggle($('tertiary-news-container'), 'Slide', { duration:.7});
	}
	else {
		/* This line dynamically removes the width setting from the tertiary div...having a width in ie6 makes the elements show up as the drawer is closing*/
		$('tertiary-news').setStyle({width: 'auto'});
		new Effect.toggle($('tertiary-news-container'), 'Blind', {duration:.7});
	}
		
	$('toggle-features-button').toggleClassName("on");
	$('toggle-features-button').toggleClassName("off");
}

function ToggleMail(){
	new Effect.toggle($('mail-more'), 'Blind', {duration:.7});
}

function ToggleMail2(){
	new Effect.toggle($('mail-more2'), 'Blind', {duration:.7});
}

function ToggleGallery(){
	new Effect.toggle($('gallery-more'), 'Blind', {duration:.7});
	$('toggle-gallery-button').toggleClassName("on");
}

function ToggleFullList(){
	new Effect.toggle($('full-list-more'), 'Blind', {duration:.7});
	$('toggle-list-button').toggleClassName("on");
}


/* HOMEPAGE ROLLOVERS SECONDARY CONTENT
--------------------------------------------- */
//HANDLES MOUSEOVERS FOR THE HOMEPAGE
function secondaryNewsRollOver(sourceElement) {

	//this if/else is a quick and dirty patch to use the proper container.  An ie6 bug is stopping me from using one container
	/*
	 *	COMMONSPOT - commented out section to remove difference b/w secondary and tertiary news.
	 */
	//if(sourceElement.up(0).identify() == 'secondary-news') {
		var rolloverContainer = $('rollover-container');
		var rolloverTarget = $('rollover-container-target');
		//$('secondary-news').setStyle({zIndex:'500'});
		//$('tertiary-news').setStyle({zIndex: '500'});
		//$('tertiary-news').setStyle({width: '654px'}); /* this width statement needed to overcome an ie6 only bug*/
	//}
	//else {
	//	var rolloverContainer = $('rollover-container2');
	//	var rolloverTarget = $('rollover-container-target2');	
	//	$('tertiary-news').setStyle({zIndex: '1000'});
	//	$('secondary-news').setStyle({zIndex: '500'});
	//	$('tertiary-news').setStyle({width: '654px'}); /* this width statement needed to overcome an ie6 only bug*/
	//}
	
	//if the rollover container is not empty, blow away anything in there
	if(rolloverTarget.empty()==false) {
		var arr = rolloverTarget.descendants();
			arr.each(function(node){
			node.remove();
		});
	}
	
	rolloverContainer.show();
	rolloverContainer.clonePosition(sourceElement, {offsetLeft: -31, offsetTop: -31, setHeight: false});
	rolloverTarget.insert(sourceElement.innerHTML);
	
	// adjust hieght according to content
	var theHeight = sourceElement.down(3).getHeight();
	$('rollover-container').setStyle({height: theHeight+140+'px'});

	/*
	 *	COMMONSPOT - Comment out for the 2nd roll over container
	 */	
	//$('rollover-container2').setStyle({height: theHeight+140+'px'});
	
}

//APPENDS MORE AND MORE EVENTS TO THE MORE CALENDAR EVENTS
function appendCalDetails(urlString) {
	var allNodes = $$("ul");
	var iterations = 1;
	for(i = 0; i < allNodes.length; i++) {
		if(allNodes[i].hasClassName("ajaxed")) {
			iterations++;
		}
	}
	if (iterations <=10){
		new Ajax.Updater('calendar-coming-soon-accordion-holder', '/customcf/calendar/getEvents.cfm?ajax=1&page='+iterations+urlString, {
		method: 'get',
		evalScripts: true,
		insertion: Insertion.Bottom
		});
	} else {
		alert('You have reached the maximum number of pages');
	}
}

//TEST TO SEE IF THERE HAS BEEN A USER VALUE ENTERED IN THE SEARCHFIELD
function testSearchField(inputvalue,target,validvalue) {
	/*WE SHOULD REALLY MAKE THIS SMARTER...validvalue should be handled via the back end/cms so that the script works with all input boxes*/
	if(inputvalue == validvalue) {
		target.value="";
	}
}

/* CAROUSELS
--------------------------------------------- */
var carouselTimer
//hack to detect mouse position
var noScroll = false;

//this function starts the timer on the carousel (clearing it first)
function timeCarousel(maxElements) {
	//set the slide time to live in milliseconds
	var slideTime = 7000;
	clearTimeout(carouselTimer);
	carouselTimer = setTimeout("upCarousel(maxElements)",slideTime);
}

//this function advances the carousel only if the mouse is in the area
function upCarousel(maxElements) {
	//only move if the mouse is not in the area
	if(noScroll == false) {
		if(Math.round(hCarousel.currentIndex()) < maxElements) {
			hCarousel.scrollTo(hCarousel.currentIndex()+1);	
		}
		else {
			hCarousel.scrollTo(0);	
		}
	}
}

//this function mounts the listeners for the carousels
function listenToCarousel(carouselId) {
	Event.observe(carouselId, 'mouseover', function() {
		noScroll = true;
	});
	Event.observe($('carousel-direct-nav'), 'mouseover', function() {
		noScroll = true;
	});
	Event.observe(carouselId, 'mouseout', function() {
		noScroll = false;
		timeCarousel(maxElements);
	});
	Event.observe($('carousel-direct-nav'), 'mouseout', function() {
		noScroll = false;
		timeCarousel(maxElements);
	});
}


/* EVENT HANDLERS AND SIFR REPLACES
--------------------------------------------- */
document.observe('dom:loaded',function(){

	// set variable for browser name
	var browserName=navigator.appName;
	
	// check if the browser is opera
	 if(browserName == "Opera") {
	 
	 //alert("Opera In The HOUSE");
	 
	 if(typeof sIFR == "function"){
		//$$('h2').toggleClassName("sIFR-alternate");
		sIFR.rollback("h2");
		sIFR.rollback("h3");
		sIFR.rollback("span");
		//$('toggle-features-button').toggleClassName("off");
		} 
	 
	} else {

	if(typeof sIFR == "function"){
		sIFR.replaceElement(named({sSelector:"h1.sifr-head", sFlashSrc:"/flash/gotham.swf", sColor:"#504d48", sLinkColor:"#504d48", 
		sBgColor:"#f8f5ee", sHoverColor:"#C90016", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=left&offsetTop=0",
		sWmode:"transparent"}));
		
		sIFR.replaceElement(named({sSelector:"h1.sifr-head-nobg", sFlashSrc:"/flash/gotham.swf", sColor:"#333333", sLinkColor:"#333333", 
		sBgColor:"#ffffff", sHoverColor:"#333333", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=left&offsetTop=0",
		sWmode:"transparent"}));
		
		sIFR.replaceElement(named({sSelector:"h1.sifr-short", sFlashSrc:"/flash/gotham.swf", sColor:"#504d48", sLinkColor:"#504d48", 
		sBgColor:"#f8f5ee", sHoverColor:"#C90016", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=left&offsetTop=0",
		sWmode:"transparent"}));
		
		sIFR.replaceElement(named({sSelector:"h3.sifr-head-heavy", sFlashSrc:"/flash/gotham.swf", sColor:"#ffffff",
		sLinkColor:"#ffffff", sBgColor:"#ffffff", sHoverColor:"#CCCCCC", nPaddingTop:0, nPaddingBottom:0,
		sFlashVars:"textalign=left&offsetTop=0", sWmode:"transparent"}));

		sIFR.replaceElement(named({sSelector:"h3.sifr-head-light", sFlashSrc:"/flash/gothamlight.swf", sColor:"#ffffff", 
		sLinkColor:"#000000", sBgColor:"#ffffff", sHoverColor:"#C90016", nPaddingTop:0, nPaddingBottom:0, 
		sFlashVars:"textalign=left&offsetTop=0", sWmode:"transparent"}));
		
		sIFR.replaceElement(named({sSelector:"h3.sifr-head2", sFlashSrc:"/flash/gotham.swf", sColor:"#333", sLinkColor:"#333", 
		sBgColor:"#ffffff", sHoverColor:"#CCCCCC", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=left&offsetTop=0", 
		sWmode:"transparent"}));
		
		sIFR.replaceElement(named({sSelector:"h2.sifr-head", sFlashSrc:"/flash/gotham.swf", sColor:"#333333", sLinkColor:"#333333", 
		sBgColor:"#FFFFFF", sHoverColor:"#CCCCCC", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=left&offsetTop=0", 
		sWmode:"transparent"}));

		// AU By the Numbers
		/* sIFR.replaceElement(named({sSelector:"span.sifr-stat-large", sFlashSrc:"/flash/gotham.swf", sColor:"#333333", sLinkColor:"#000000", 
		sBgColor:"#f8f5ee", sHoverColor:"#000000", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=left&offsetTop=0", 
		sWmode:"transparent"}));
		
		sIFR.replaceElement(named({sSelector:"span.sifr-stat-small", sFlashSrc:"/flash/gotham.swf", sColor:"#333333", sLinkColor:"#000000", 
		sBgColor:"#f8f5ee", sHoverColor:"#000000", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=right&offsetTop=5", 
		sWmode:"transparent"})); */
		
		// replaces gotham light heads
 		sIFR.replaceElement(named({sSelector:"h3.sifr-head-dark", sFlashSrc:"/flash/gothamlight.swf", sColor:"#666666", sLinkColor:"#000000",
 		sBgColor:"#FFFFFF", sHoverColor:"#CCCCCC", nPaddingTop:0, nPaddingBottom:0, sFlashVars:"textalign=left&offsetTop=0",
 		sWmode:"transparent"}));

 		sIFR.replaceElement(named({sSelector:"h3.sifr-head-red", sFlashSrc:"/flash/gothamlight.swf", sColor:"#C90016", 
		sLinkColor:"#000000", sBgColor:"#ffffff", sHoverColor:"#333333", nPaddingTop:0, nPaddingBottom:0, 
		sFlashVars:"textalign=left&offsetTop=0", sWmode:"transparent"}));


 		/* sIFR.replaceElement(named({sSelector:".slideContent h3", sFlashSrc:"/flash/gothamlight.swf", sColor:"#ffffff", 
		sLinkColor:"#000000", sBgColor:"#ffffff", sHoverColor:"#C90016", nPaddingTop:0, nPaddingBottom:0, 
		sFlashVars:"textalign=left&offsetTop=0", sWmode:"transparent"}));

		sIFR.replaceElement(named({sSelector:".heroContent h3", sFlashSrc:"/flash/gothamlight.swf", sColor:"#ffffff", 
		sLinkColor:"#000000", sBgColor:"#ffffff", sHoverColor:"#C90016", nPaddingTop:0, nPaddingBottom:0, 
		sFlashVars:"textalign=left&offsetTop=0", sWmode:"transparent"})); */
	};
	
	}

	//check if we have an scal instance
	//if ($('calendarwidget')) {
	//	var options = Object.extend({
	//        titleformat:'mmmm yyyy',
	//        dayheadlength:3,
	//        prevbutton: '<img src="/images/scal/prev.gif" />',
	//        nextbutton: '<img src="/images/scal/next.gif" />',
	//        weekdaystart:0,
	//        planner: false
	//   });	
    //var updateyear = function(d){ $('calendarwidget').value = d.format('mmmm dd, yyyy'); };		
    //var Cal = new scal('calendarwidget', 'scal_update', options);
	//}
});

function loadTextOverlaySecondary(divFldId, imgFldID, txtOverlayFldID){

	var divFldVal = "div#" + divFldId;
	var imgFldVal = "img#" + imgFldID;
	var txtOverlayFldVal = "#" + txtOverlayFldID;
	var div = "";
	var position = "";
	
	jQuery(divFldVal).bind("mouseover",function(){
     	jQuery(txtOverlayFldVal).css("z-index", 15);
    });
    jQuery(txtOverlayFldVal).bind("mouseover",function(){
     	jQuery(txtOverlayFldVal).css("z-index", 15);
    });
    jQuery("div#rollover-container").bind("mouseout",function(){
      	jQuery(txtOverlayFldVal).css("z-index", 5);
    });
    
    position = jQuery(imgFldVal).position();
	//alert( "left: " + position.left + ", top: " + position.top );
	div = jQuery(txtOverlayFldVal);
	div.show();
	div.addClass("textOverlay_sec");
	div.css("top", position.top + 75);
	div.css("left", position.left);    
}

function loadTextOverlayHero(imgFldID, txtOverlayFldID){

	var imgFldVal = "img#" + imgFldID;
	var txtOverlayFldVal = "#" + txtOverlayFldID;
	var div = "";
	var position = "";
	
	//position = jQuery(imgFldVal).position();
    position = jQuery("div#homepage-hero").position();
	//alert( "left: " + position.left + ", top: " + position.top );
	div = jQuery(txtOverlayFldVal);
	div.show();
	div.addClass("textOverlay_hero");
	div.css("top", position.top + 245);
	div.css("left", position.left + 19);
}