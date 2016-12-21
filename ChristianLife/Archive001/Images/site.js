$(document).ready(function() {
	$('ul.frontbanners, ul.sidebargallery').innerfade({
		timeout: 6500,
		speed: 2500
		});		
});



function ministries_popup_open() {
	//$('#ministries_popup').slideDown(100);
	$('#ministries_popup').show();
	sifr_replace_all();
	
	return false;
}

function ministries_popup_close() {
	//$('#ministries_popup').slideUp(100);
	$('#ministries_popup').hide();
	
	return false;
}

var media_popup_arr = new Object;

function open_service(watch_or_listen, obj) {
	var service_popup = window.open('/service_popup.html', 'service_popupss', 'toolbar=no,status=no,width=592,height=421,location=no,resizable=no');
	
	if($(obj).parents('div').is('.recent')) {
		var parent = $(obj).parents('div.recent');
	} else {
		var parent = $(obj).parents('tr');
	}
	
	$('input', parent).each(function() {
		var value = $(this).val();
		value = value.replace(/\'/g, '\\\'');
		eval('media_popup_arr.' + $(this).attr('name') + ' = \''+ value +'\';');	
	});
	
	media_popup_arr.watch_or_listen = watch_or_listen;
	
}

function watch_welcome() {
	$('div.welcome_message').hide();
	$('#welcome_message_player').show();
	
	var fo = new SWFObject("/FlowPlayerDark.swf", "FlowPlayer", "320", "268", "9.0.115", "#ffffff", true);
	fo.addVariable("config", "{ playList: [ {overlayId: 'play' }, { url: 'welcome2.mov' } ], loop: false, showMenu: false, initialScale: 'fit' }");
	fo.useExpressInstall('/expressinstall.swf');
	fo.addParam("allowFullScreen", "true");
	fo.write("welcome_message_player");
	
}

function watch_generic(which) {
	var div = $(which).parents('div.video_player');
	var rand = $('input[@name=random]', div).val();
	var video = $('input[@name=video]', div).val();
	
	div.hide();
	
	var player_id = 'player_' + rand;
	
	$('#' + player_id).show();
	
	var fo = new SWFObject("/FlowPlayerDark.swf", "FlowPlayer", "320", "268", "9.0.115", "#ffffff", true);
	fo.addVariable("config", "{ playList: [ {overlayId: 'play' }, { url: '/medialibrary/file/" + video + "/video.mov' } ], loop: false, showMenu: false, initialScale: 'fit' }");
	fo.useExpressInstall('/expressinstall.swf');
	fo.addParam("allowFullScreen", "true");
	fo.write(player_id);
}

$.preloadImages = function() {
	for(var i = 0; i<arguments.length; i++)	{
		$('<img>').attr('src', arguments[i]);
	}
}