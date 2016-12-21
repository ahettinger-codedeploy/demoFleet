var _FRAMED_MUSICPLAYER_LOADED;
if (!_FRAMED_MUSICPLAYER_LOADED)
{
	_FRAMED_MUSICPLAYER_LOADED = 1;
	function closeFramedMusicPlayer() {
		parent.location.replace("index.cfm?mpf=close&bp=" + escape(parent.mainFrame.location));
	}
	
	/**
	 * rename the page the user is hitting with an fr_ in the front so that the frameset is loaded
	 */
	function openFramedMusicPlayer() {
		filename = document.location.pathname.split("/").pop();
		if ( filename == "" ) {
			tmpPath = document.location.pathname + "fr_index.cfm";
		}
		else {
			tmpPath = document.location.pathname.replace(filename, "fr_" + filename);
		}
		newLocation = "http://" + document.location.hostname + tmpPath + window.location.search;
		document.location.replace(newLocation);
	}

	function isMusicPlayerOpen() {
		if (parent == self) return false;
		try {
			if (parent._MUSICPLAYER_FRAME) return true;
		} catch (ex) {
			// We're currently in a frameset that is outside of our own domain and
			// trying to read from it caused a security error.
		}
		return false;
	}
}
