$(document).ready(function () {
	// alert 
	$(".news-alert").hide();
	$(".news-alert").fadeIn("slow");

	$('.alert-close').click(function() {
		if ($(".news-alert").is(":visible")){
			$(".alert-close").empty().append("News Alert");
		}else{
			$(".alert-close").empty().append("Close");
		}
		$('.news-alert').slideToggle('slow');
		$(this).toggleClass("alert-open");
		return false;
	});
	
	// interactive 
	$("#interactive .news li").each(function (i) {
		i = i+1;
		$(this).addClass("item"+i);
	});
	$("#interactive .news li.item1").prepend("<img class='frame' src='/images/home/frame-orange.png' >");
	$("#interactive .news li.item2").prepend("<img class='frame' src='/images/home/frame-red.png' >");
	$("#interactive .news li.item3").prepend("<img class='frame' src='/images/home/frame-purple.png' >");
	$("#interactive .news li.item4").prepend("<img class='frame' src='/images/home/frame-blue.png' >");
	$("#interactive .news li.item5").prepend("<img class='frame' src='/images/home/frame-pink.png' >");
	$('#interactive').append('<div id="controls"><a href="#" id="paging-prev">Prev</a><a href="#" id="paging-next">Next</a></div>');
	$('#interactive').append('<div id="pager"></div>');
	loadControls();
	$('#interactive .news').cycle({
		fx: 'fade',  
		speed: 500,  
		timeout: 17500,
		next: '#paging-next',
		prev: '#paging-prev',
		pager: '#pager',
		pause: 1, 
		cleartypeNoBg: true  
	});
	$(window).resize(function() {
	loadControls();
		if ($(window).width() > 1200) {
			$('#interactive #control').show();
		} else { 
			$('#interactive #control').hide();
		}
		});
	function loadControls() {
		if ($(window).width() > 1200) {
			$('#interactive #controls').show();
		} else { 
			$('#interactive #controls').hide();
		}
	}
	
	// news
	$('#tabNews ul.news li').each(function () {
		$(this).find('.readmore').appendTo($(this).find('p'));
	});
	$('#tabNews ul.news li p').wrap('<div class="wrapper" />');
	$('#tabNews ul.news').accordion({
		autoHeight : false
	});
		
	// calendar 
	$('.calendar .list dl dd').each(function () {
		if($(this).prev().get(0).nodeName != 'DT') {
			var $date_dt = $(this).closest('dl').find('dt:first').clone();
			$(this).before($date_dt);
		}
	});
	
	$('dl.calendar-day dt')
		.unwrap()
		.each(function () {
			$(this)
				.add($(this).next())
				.wrapAll('<dl class="calendar-day"></dl>');
		});
	
	$('dl.calendar-day').wrapAll('<div id="calendar-list"></div>').group({
		'size': '3',
		'wrapElem': '<div class="calendar-row"></div>' 	
	});
	
	$('dl.calendar-day:first-child').addClass('first-child');
	$('div.calendar-row').each(function () {
		$(this)
			.find('dl.calendar-day')
			.eq($(this).find('dl.calendar-day').length-1)
				.addClass('last-child');
	});
	$('dl.calendar-day.first-child.last-child')
		.removeClass('first-child last-child')
		.addClass('only-child');
		
	$('dl.calendar-day dd').attr('class','');
	
	$('div.calendar-row:even').each(function () {
		$(this)
			.add($(this).next())
			.wrapAll('<div class="calendar-set"></div>');
	});
	
	// fast facts
	$('#fast-facts li').wrapInner('<div class="fact-wrapper"></div>'); // wrapper for border
	$('#fast-facts').append('<div id="facts-controls"><a href="#" id="facts-prev">Prev</a><a href="#" id="facts-next">Next</a></div>');
	$('#fast-facts .news').cycle({
		fx: 'fade',  
		speed: 500,  
		timeout: 7500,
		next: '#facts-next',
		prev: '#facts-prev',
		random:  1, 
		pause:  1, 
		cleartypeNoBg: true  
	});
	var strFastFacts = ''; // Limit the character count on news captions
	var lenFastFacts = 265; // Limit the character count on news captions	
	$('#home #fast-facts ul li .fact-wrapper p').each(function () {
		strFastFacts = $(this).text();
		if(strFastFacts.length >= lenFastFacts) {
			$(this).text((strFastFacts.indexOf(' ', lenFastFacts) === -1) ? $(this).text() : strFastFacts.substring(0, strFastFacts.indexOf(' ', lenFastFacts)) + '...');
		}
	})
});

// Key handlers
$(document).keydown(function(e){
	if (e.metaKey || e.ctrlKey) {
	} else {
	if (e.keyCode == 37) { 
		$("#paging-prev").click();
	   return false;
	}
	if (e.keyCode == 39) { 
		$("#paging-next").click();
	   return false;
	}
	}
});