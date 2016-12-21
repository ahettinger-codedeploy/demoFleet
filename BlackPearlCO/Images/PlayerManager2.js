var windowName = "iemusicplayer";
var windowParams = "toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=315,height=620,left=100,top=100";
var winRef;
var playerPageName = "player.aspx";
//var playerPageName = "MockMusicPlayer.aspx";


function addAlbum(pid, playNow, webkitkey) {
    setWinRef();
    if (isWindowOpen()) {
        Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddAlbumToQueue(pid, webkitkey, addSucceeded, addFailed, playNow);
    } else {
        Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddAlbumToQueueWithClear(pid, webkitkey, addSucceeded, addFailed, playNow);
    }
}

function addWork(strPks, playNow, webkitkey) {
    setWinRef();
    if (isWindowOpen()) {
        Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddWorkToQueue(strPks, webkitkey, addSucceeded, addFailed, playNow);
    } else {
        Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddWorkToQueueWithClear(strPks, webkitkey, addSucceeded, addFailed, playNow);
    }
}

function addTrack(itemid, playNow, webkitkey) {
    setWinRef();
    if (isWindowOpen()) {
        Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddTrackToQueue(itemid, webkitkey, addSucceeded, addFailed, playNow);
    } else {
        Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddTrackToQueueWithClear(itemid, webkitkey, addSucceeded, addFailed, playNow);
    }
}

function addSucceeded(returnArgs, userContext) {
    listItemId = returnArgs[0];
    playerUrl = returnArgs[1];
    openPlayer(listItemId, playerUrl, userContext);
}

function addFailed(result) {
}

function openPlayer(listItemIdToPlay, playerUrl, startPlaying) {
    if (isWindowOpen() == false) {
        winRef.location = playerUrl;
    } else {
        if (startPlaying) {
            winRef.setListItem(listItemIdToPlay);
        } else {
            winRef.refreshGui();
        }
    }

    winRef.focus();
}

function isWindowOpen() {
    try {
        if (winRef.location.href.indexOf(playerPageName) > 0) {
            return true;
        } else {
            return false;
        }
    }
    catch (e) {
        return false;
    }
}

function setWinRef() {
    try {
        winRef = window.open("", windowName, windowParams);
    } catch (e) {
        winRef = window.open("about:blank", windowName, windowParams);
    }
}

function instantEncorePlayItem(playUrl) {
    winRef = null;
    try {
        winRef = window.open("", windowName, windowParams);
    } catch (e) {
        winRef = window.open("about:blank", windowName, windowParams);
    }
    winRef.location = playUrl;
}
