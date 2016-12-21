(function($) {
	var control_div;

	$.zoogle_player = {
		defaults: {
			use_cookies : true,
			controls : true,
			index: 0,
			data: {},
			onChange: function() {},
			autoplay : false,
			loop : true,
			shuffle : false
		}
	};
	
	$.fn.playFile = function(url, onSoundComplete) {
		var id = $(this).attr('id');
		var player_div = "#" + id + "_jplayer";
		if ( typeof(onSoundComplete) == "function" ) {
			$(player_div).jPlayer("onSoundComplete", onSoundComplete);
		}
		$(player_div).
			jPlayer("setFile", url).
			jPlayer("play");
	};

	// $.fn.player = function() {
	// 	var id = $(this).attr('id');
	// 	var player_div = "#" + id + "_jplayer";
	// 	return $(player_div);
	// };



	$.fn.initMusicPlayer = function(settings) {
		settings = $.extend({}, $.zoogle_player.defaults, settings);
		var target = this;
		var id = $(this).attr('id');

		//
		// start with a random track if shuffle is on
		//
		if ( settings.shuffle == true && settings.data.length > 1 ) {
			settings.index = Math.floor(Math.random() * settings.data.length);
		}

		$(this).data("playList", settings.data);
		$(this).data("playItem", settings.index);

		var player_div = id + "_jplayer";

		$(this).after("<div id='" + player_div + "' zplayer='1'></div>");

		$("#" + player_div).jPlayer({
			customCssIds : true,
			swfPath: "/common/js/jplayer",
			ready: function() {
				if ( settings.playlist ) {
					displayPlayList("#" + id);
				}
				if ( settings.controls ) {
					playListInit(settings.autoplay); // Parameter is a boolean for autoplay.
				}
			}
		});

		if ( settings.controls ) {
			$("#player_volume_bar").slider({
				step : 5,
				value : 80,
				slide : function(event, ui) {
					setVolumeBar(ui.value);
					$("#" + player_div).jPlayer("volume", ui.value);
					if ( ui.value <= 0 ) {
						$(control_div + " #player_volume_max").css("display", "block");
						$(control_div + " #player_volume_min").css("display", "none");
					}
					else {
						$(control_div + " #player_volume_max").css("display", "none");
						$(control_div + " #player_volume_min").css("display", "block");
					}
				}
			});

			$("#" + player_div).
				jPlayer("cssId", "play", "player_play")
				.jPlayer("cssId", "pause", "player_pause")
				.jPlayer("cssId", "stop", "player_stop")
				.jPlayer("cssId", "loadBar", "player_progress_load_bar")
				.jPlayer("cssId", "playBar", "player_progress_play_bar")
				.jPlayer("onProgressChange", 
					function(loadPercent, playedPercentRelative, playedPercentAbsolute, playedTime, totalTime) {
						var playlist = $(target).data("playList");
						var playItem = $(target).data("playItem");
						
						// record how much of the track has been played 
						$(target).data("amountPlayed", playedPercentAbsolute);
						var myTotalTime;
						if ( typeof(playlist[playItem].duration) == "undefined" || playlist[playItem].duration == 0 ) {
							myTotalTime = new Date(totalTime);					
							$("#total_time").text(formatTime(myTotalTime));
						}
						else {
							myTotalTime = new Date(playlist[playItem].duration*1000);
						}

						var myPlayedTime = new Date(playedTime);				
						$("#play_time").text(formatTime(myPlayedTime)); // + "/" + formatTime(myTotalTime));
					
						if ( settings.use_cookies && myPlayedTime.getUTCSeconds() > 0 ) {
							var cookieData = playItem + "-" + playedTime;
							$.cookie("state_" + player_div, cookieData);
						}
					}
				)
				.jPlayer("onSoundComplete", updatePlayerState );

			setVolumeBar(80);

			var control_div = "#" + id;
			$(control_div + " #player_play").click( function() {
				$.stopOtherPlayers("#" + player_div);
			 	$("#" + player_div).jPlayer("play");
				trackPlay();
			});
			$(control_div + " #player_pause").click( function() {
			 	$.stopOtherPlayers("#" + player_div);
			 	$("#" + player_div).jPlayer("pause");
			});

			$(control_div + " #ctrl_prev").click( function() {
				playListPrev();
				return false;
			});

			$(control_div + " #player_volume_min").click( function() {
				$($("#" + player_div)).data("oldVolume", $($("#" + player_div)).data("jPlayer.config").volume);
				$($("#" + player_div)).jPlayer("volume", 0);
				$("#player_volume_bar").slider('value', 0);
				$(control_div + " #player_volume_max").css("display", "block");
				$(control_div + " #player_volume_min").css("display", "none");
				return false;
			});
			$(control_div + " #player_volume_max").click( function() {
				$($("#" + player_div)).jPlayer("volume", $($("#" + player_div)).data("oldVolume"));
				$(control_div + " #player_volume_max").css("display", "none");
				$(control_div + " #player_volume_min").css("display", "block");
				$("#player_volume_bar").slider('value', $($("#" + player_div)).data("oldVolume"));
				return false;
			});
					
			$(control_div + " #ctrl_next").click( function() {
				playListNext();
				return false;
			});
		} // if ( controls )

		function formatTime(t) {

if ( isNaN( t.getTime() ) ) {  // d.valueOf() could also work
    return "";
  }

			var ptMin = (t.getUTCMinutes() < 10) ? "0" + t.getUTCMinutes() : t.getUTCMinutes();
			var ptSec = (t.getUTCSeconds() < 10) ? "0" + t.getUTCSeconds() : t.getUTCSeconds();

			return ptMin+":"+ptSec;
		}

		function setVolumeBar(tmpVolume) {
			var maxWidth = jQuery("#player_volume_bar").width();
			var newWidth = tmpVolume / 100 * maxWidth;
			jQuery("#player_volume_bar_value").css("width", newWidth);
		}


		function displayPlayList(dest) {
			var playlist = $(target).data("playList");
			var playItem = $(target).data("playItem");

			var show_playlist = settings.playlist && $(settings.playlist).length > 0 ;
			if ( show_playlist ) {
				for (i=0; i < playlist.length; i++) {
					if ( playlist[i].download ) {
						var dlFunction = playlist[i].onDownload;
						var dlLink = $('<a class="download_link"></a>').text("Download").
							attr({ 'href': playlist[i].download, 'target': '_new' }).
							click (function() {
								// trigger any events
								if ( typeof(dlFunction) == "function" ) {
									dlFunction();
								}
							});
						$("#playlist_item_" + i).append(dlLink);
					}
					$(settings.playlist + " #playlist_item_"+i).data( "index", i ).hover(
						function() {
							if (playItem != $(this).data("index")) {
								$(this).addClass("playlist_hover");
							}
						},
						function() {
							$(this).removeClass("playlist_hover");
						}
					).click( function() {
						var index = $(this).data("index");
						playListChange( index );
					});
				}
			}
		}
		
		function playListInit(autoplay) {
			var playlist = $(target).data("playList");
			var playItem = $(target).data("playItem");
			if(autoplay) {
				playListChange( playItem );
			} else {
				playListConfig( playItem );
			}
		}

		function trackPlay() {
			var oldIndex = -1;
			var playItem = $(target).data("playItem");
			if ( oldIndex != playItem ) {
				var playlist = $(target).data("playList");
				// trigger any events
				if ( playlist[playItem].onPlay ) {
					playlist[playItem].onPlay("play");
				}
				oldIndex = playItem;
			}
		}
	
		function playListConfig( index ) {
			var playlist = $(target).data("playList");
			var playItem = $(target).data("playItem");

			// update current track name
			$(control_div + " #player_current_track span").html(playlist[index].name);
			$(control_div + " #player_current_track").trigger('marquee');

			if ( typeof(playlist[index].duration) != "undefined" && playlist[index].duration > 0 ) {
				var myTotalTime = new Date(playlist[index].duration*1000);
				$("#total_time").text(formatTime(myTotalTime));
			}

			// update playlist
			var show_playlist = settings.playlist && $(settings.playlist).length > 0 ;
			if ( show_playlist ) {
				$(settings.playlist + " #playlist_item_"+playItem).removeClass("playlist_current");
				$(settings.playlist + " #playlist_item_"+index).addClass("playlist_current");
			}

			//
			// setup dl/lyric links
			//
			var dl_html = "";
			if ( playlist[index].download ) {
				dl_html = "<a href='" + playlist[index].download + "' target='_new'>download MP3</a>";
				$(control_div + " #download_link").html(dl_html);
				$(control_div + " #download_link").show();
			}
			else { 
				$(control_div + " #download_link").hide();
			}
			// trigger any events
			if ( playlist[index].onDownload ) {
				$(control_div + " #download_link").click( playlist[index].onDownload );
			}
			// start playing the new file
			$(target).data("playItem", index);
			$("#" + player_div).jPlayer("setFile", playlist[index].mp3);
		}
	

		function playListChange( index ) {
			$.stopOtherPlayers("#" + player_div);
			playListConfig( index );

			$("#" + player_div).jPlayer("play");
			trackPlay();

			if ( $('#playlist_list').size() > 1) {
				$('#playlist_list')[0].scrollTo("#playlist_item_" + index);
			}

		}
	
		function updatePlayerState() {
			var playlist = $(target).data("playList");
			var playItem = $(target).data("playItem");

			if ( playItem+1 < playlist.length || settings.loop ) {
				playListNext();
			}
			else {
				$("#" + player_div).stop();
			}
		}
		
		function playListNext() {
			var playlist = $(target).data("playList");
			var playItem = $(target).data("playItem");
			var index = playItem;
			var oldIndex = index;
			if ( playlist[playItem].onSkip ) {
				var amt = $(target).data("amountPlayed");
				playlist[playItem].onSkip( amt );
			}
			if ( settings.shuffle == true && playlist.length > 1 ) {
				while ( index == oldIndex ) {
					index = Math.floor(Math.random() * playlist.length);
				}
			}
			else {
				index = (playItem+1 < playlist.length) ? playItem+1 : 0;
			}
			playListChange( index );
		}
	
		function playListPrev() {
			var playlist = $(target).data("playList");
			var playItem = $(target).data("playItem");
			var index = (playItem-1 >= 0) ? playItem-1 : playlist.length-1;
			playListChange( index );
		}
	}; // initMusicPlayer

	$.stopOtherPlayers = function(id) {
		var my_parent = $.rootWindow();
		if ( my_parent != null && my_parent.frames.length > 0 ) {
			for ( var i = 0; i < my_parent.frames.length; i++ ) {
				try {
					if ( typeof(my_parent.frames[i].stopPlayer) != "undefined" ) {
						my_parent.frames[i].stopPlayer();
					}
				}
				catch(e) {
					// Do nothing.
				}
			}
		}

		try {
			if ( typeof(stopPlayer) == "function" ) {
				stopPlayer(id);
			}
		}
		catch(e) {
			// Do nothing.
		}
	};

	$.rootWindow = function() {
		var my_parent = null;
		try {
			my_parent = window.parent;
		}
		catch(e) {
			my_parent = window;
		}
		
		return my_parent;
	};

})(jQuery);
