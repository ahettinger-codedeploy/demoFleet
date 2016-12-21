$(document).ready(function () {
	// mega nav 
	$('#nav-main ul ul')
		.each(function () {
			$(this)
				.find('li')
				.wrapAll('<span class="link-group"></span>');
			$(this)
				.find(('.spotlight'))
				.wrapAll('<span class="spotlight-group"></span>');
	});
	$('.spotlight-group')
		.each(function () {
			$(this).prependTo($(this).parent().parent());
	});
	$('.link-group')
		.each(function () {
			$(this).find('li:even')
				.each(function () {
					$(this)
						.add($(this).next())
						.wrapAll('<span></span>');
				});	
	}); 
	
	// search
	$("#nav-link-search-toggle").removeAttr("href");
	$("#nav-li-search-toggle").mouseover(function(){
		$(".search div#search-area").animate({height: 'toggle'}, 250, function() {});
	});
	$("input#q").focus(function() {
		if( this.value == "What are you looking for?" ) {
			this.value = "";
		}
	}).blur(function() {
		if( !this.value.length ) {
			this.value = "What are you looking for?";
		}
	});
		
	// best place pop up
	$("#best-place-profiles ul li h4 a").removeAttr("href");
    $("#best-place a[rel='thebestplaceforgirls']").prettyPhoto({
		theme: 'best_place_theme', 
		default_width: 1000,
		default_height: 550,
		allow_resize: false
	}); 	
	var strBestPlace = ''; // Limit the character count on news captions
	var lenBestPlace = 260; // Limit the character count on news captions	
	$('#best-place-profiles ul li .caption p').each(function () {
		strBestPlace = $(this).text();
		if(strBestPlace.length >= lenBestPlace) {
			$(this).text((strBestPlace.indexOf(' ', lenBestPlace) === -1) ? $(this).text() : strBestPlace.substring(0, strBestPlace.indexOf(' ', lenBestPlace)) + '...');
		}
	});
	$('#best-place-profiles ul li .thumb img').each(function(){ //remove height/width of image
        $(this).removeAttr('width')
        $(this).removeAttr('height');
    });
	$('#best-place-profiles ul').after('<ul id="slide-nav">').cycle({ // run slideshow and output paging
		fx: 'fade', 
		speed: 500, 
		timeout: 10000, 
		pause: 1,
		pager: '#slide-nav', 
		pagerAnchorBuilder: function(idx, slide) { 
			return '<li><a href="#"><img src="/images/common/best-placeholder.gif" /></a></li>'; 
		} 
	});
		$('#best-place-profiles').find('ul.news li').each(function () { // set smaller thumbs for paging 
		$('#slide-nav').find('li:eq(' + $(this).index() + ') img').attr('src', $(this).find('.thumb img').attr('src'));
	});
	$('#best-place-profiles #slide-nav li img').each(function () { // set the height/width of thumbs for paging 
		if($(this).width() > $(this).height()) {
			$(this).css({
				'height': '100%',
				'width': 'auto'
			});
		} else {
			$(this).css({
				'height': 'auto',
				'width': '100%'
			});
		}
	});
	$('#best-place-profiles #slide-nav li').append('<span></span>'); // add span for yellow border/indicator 
	
	// meet us page 
	$('#meet-us-profiles ul li').each(function(){
		var current = $(this);
		var anchor = current.find('a').first().attr('href');
		if(anchor){
		  var wrapped = $(current).wrapInner('<a class="detail-hover" href="' + anchor + '"></a>');
		}
	});
	$('#meet-us-profiles ul li h4').before('<span class="profile-indicator"></span>');
	$('#meet-us-profiles ul li h4').before('<div class="thumb thumb-placeholder"><a><img src="/images/common/best-placeholder.gif" /></a></div>'); // add empty thumb
    $('#meet-us-profiles ul li:nth-child(7n+1)').addClass('profile1'); // add css class for every 7th item 
    $('#meet-us-profiles ul li:nth-child(7n+2)').addClass('profile2');
    $('#meet-us-profiles ul li:nth-child(7n+3)').addClass('profile3');
    $('#meet-us-profiles ul li:nth-child(7n+4)').addClass('profile4');
    $('#meet-us-profiles ul li:nth-child(7n+5)').addClass('profile5');
    $('#meet-us-profiles ul li:nth-child(7n+6)').addClass('profile6');
    $('#meet-us-profiles ul li:nth-child(7n)').addClass('profile7');
	var strMeetUs = ''; // Limit the character count on news captions
	var lenMeetUs = 160; // Limit the character count on news captions	
	$('#meet-us-profiles ul li .caption').each(function () {
		strMeetUs = $(this).text();
		if(strMeetUs.length >= lenMeetUs) {
			$(this).text((strMeetUs.indexOf(' ', lenMeetUs) === -1) ? $(this).text() : strMeetUs.substring(0, strMeetUs.indexOf(' ', lenMeetUs)) + '...');
		}
	});
	
	$('#content blockquote').wrapInner('<div class="blockquote-wrapper"></div>'); // wrapper for blockquote 
	
	$(".faq .showall, .faq .hideall, ").addClass("button"); //make FAQ Show/Hide button
	
	$("table.styled tr:nth-child(odd)").addClass("alt");  // Add alt class to alternating rows on styled tables
    $(".table-container td a").parent().addClass("event"); // Add event class to month view 
    $(".table-container td h4").parent().parent().parent().addClass("event"); // Add event class to month view
    if ($("#gallery-form #select-gallery").children().length <= 2) { $("#gallery-form").addClass("none"); $("#gallery-form select").addClass("none"); }
	
	$('#content a[href^="mailto:"]').addClass('email'); // Auto class email links

    $(".gallery-attachment").each(function () { 
        if ($("dl.image-list dt", this).length > 1) { $(".gallery-directional", this).removeClass("none"); }

        $("dl.image-list dt:first", this).addClass("active");
        $("dl.image-list dd:first", this).addClass("active");
        $("dl.image-list dt:not(.active)", this).addClass("none");
        $("dl.image-list dd:not(.active)", this).addClass("none");

        var changeButtons = function (context) {
            // Change display state of buttons
            // If not first child or last child: display next and prev
            if (!$("dl.image-list dt:first", context).hasClass("active") && !$("dl.image-list dt:last", context).hasClass("active")) {
                $(".gallery-previous a", context).removeClass("disabled");
                $(".gallery-next a", context).removeClass("disabled");
            }
            // If first child: display next, disable prev
            if ($("dl.image-list dt:first", context).is(".active")) {
                $(".gallery-next a", context).removeClass("disabled");
                $(".gallery-previous a", context).addClass("disabled");
            }
            // If last child: display prev, disable next
            if ($("dl.image-list dt:last", context).is(".active")) {
                $(".gallery-previous a", context).removeClass("disabled");
                $(".gallery-next a", context).addClass("disabled");
            }

            SI_clearFooter();
        }

        var updateImages = function (context) {
            $("dl.image-list dt.active", context).addClass("none");
            $("dl.image-list dd.active", context).addClass("none");
            $("dl.image-list dt.active", context).removeClass("active");
            $("dl.image-list dd.active", context).removeClass("active");
        }

        $(".gallery-next a", this).click(function () {
            if (!$(this).hasClass("disabled")) {
                var nextImg = $("dl.image-list dd.active");
                updateImages($(this).closest(".gallery-attachment"));
                nextImg.next().removeClass("none");
                nextImg.next().next().removeClass("none");
                nextImg.next().addClass("active");
                nextImg.next().next().addClass("active");
                changeButtons($(this).closest(".gallery-attachment"));
            }
        });
        $(".gallery-previous a", this).click(function () {
            if (!$(this).hasClass("disabled")) {
                var prevImg = $("dl dt.active");
                updateImages($(this).closest(".gallery-attachment"));
                prevImg.prev().addClass("active");
                prevImg.prev().prev().addClass("active");
                prevImg.prev().removeClass("none");
                prevImg.prev().prev().removeClass("none");
                changeButtons($(this).closest(".gallery-attachment"));
            }
        });

        /* Add alt class to gallery thumbnails - Not being used yet */
        $(".gallery-thumbnails ul li:odd", this).addClass("alt");
    
    });

});