Type.registerNamespace('Evan.InstantEncore.Streaming');
Evan.InstantEncore.Streaming.AudioStreamingStatsWs=function() {
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.initializeBase(this);
this._timeout = 0;
this._userContext = null;
this._succeeded = null;
this._failed = null;
}
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.prototype={
_get_path:function() {
 var p = this.get_path();
 if (p) return p;
 else return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_path();},
Test:function(succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'Test',false,{},succeededCallback,failedCallback,userContext); },
AddStreamingRecord:function(listItemId,isSample,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddStreamingRecord',false,{listItemId:listItemId,isSample:isSample},succeededCallback,failedCallback,userContext); },
UpdateLastPosition:function(streamid,position,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'UpdateLastPosition',false,{streamid:streamid,position:position},succeededCallback,failedCallback,userContext); },
SetCompleted:function(streamid,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'SetCompleted',false,{streamid:streamid},succeededCallback,failedCallback,userContext); },
AudioUrlByItemId:function(itemid,mp3Encoding,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AudioUrlByItemId',false,{itemid:itemid,mp3Encoding:mp3Encoding},succeededCallback,failedCallback,userContext); },
AudioUrl:function(pid,recid,disc,trk,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AudioUrl',false,{pid:pid,recid:recid,disc:disc,trk:trk},succeededCallback,failedCallback,userContext); },
TrackIdFromPlaylist:function(playlistTrackNumber,playlistId,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'TrackIdFromPlaylist',false,{playlistTrackNumber:playlistTrackNumber,playlistId:playlistId},succeededCallback,failedCallback,userContext); },
RandomTrackIdFromPartner:function(aid,pid,recid,disc,trk,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'RandomTrackIdFromPartner',false,{aid:aid,pid:pid,recid:recid,disc:disc,trk:trk},succeededCallback,failedCallback,userContext); },
TrackInfo:function(pid,recid,disc,trk,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'TrackInfo',false,{pid:pid,recid:recid,disc:disc,trk:trk},succeededCallback,failedCallback,userContext); },
ListItemInfo:function(listItemId,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'ListItemInfo',false,{listItemId:listItemId},succeededCallback,failedCallback,userContext); },
AddTrackToQueue:function(itemid,webkitkey,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddTrackToQueue',false,{itemid:itemid,webkitkey:webkitkey},succeededCallback,failedCallback,userContext); },
AddTrackToQueueWithClear:function(itemid,webkitkey,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddTrackToQueueWithClear',false,{itemid:itemid,webkitkey:webkitkey},succeededCallback,failedCallback,userContext); },
AddWorkToQueue:function(strPks,webkitkey,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddWorkToQueue',false,{strPks:strPks,webkitkey:webkitkey},succeededCallback,failedCallback,userContext); },
AddWorkToQueueWithClear:function(strPks,webkitkey,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddWorkToQueueWithClear',false,{strPks:strPks,webkitkey:webkitkey},succeededCallback,failedCallback,userContext); },
AddAlbumToQueue:function(pid,webkitkey,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddAlbumToQueue',false,{pid:pid,webkitkey:webkitkey},succeededCallback,failedCallback,userContext); },
AddAlbumToQueueWithClear:function(pid,webkitkey,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddAlbumToQueueWithClear',false,{pid:pid,webkitkey:webkitkey},succeededCallback,failedCallback,userContext); },
NextListItemId:function(listItemId,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'NextListItemId',false,{listItemId:listItemId},succeededCallback,failedCallback,userContext); },
PreviousListItemId:function(listItemId,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'PreviousListItemId',false,{listItemId:listItemId},succeededCallback,failedCallback,userContext); },
AddStreamingRecordMobileWeb:function(itemid,isSample,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'AddStreamingRecordMobileWeb',false,{itemid:itemid,isSample:isSample},succeededCallback,failedCallback,userContext); },
ClearQueue:function(succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'ClearQueue',false,{},succeededCallback,failedCallback,userContext); }}
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.registerClass('Evan.InstantEncore.Streaming.AudioStreamingStatsWs',Sys.Net.WebServiceProxy);
Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance = new Evan.InstantEncore.Streaming.AudioStreamingStatsWs();
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_path = function(value) { Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.set_path(value); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.get_path = function() { return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_path(); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_timeout = function(value) { Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.set_timeout(value); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.get_timeout = function() { return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_timeout(); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_defaultUserContext = function(value) { Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.set_defaultUserContext(value); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.get_defaultUserContext = function() { return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_defaultUserContext(); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_defaultSucceededCallback = function(value) { Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.set_defaultSucceededCallback(value); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.get_defaultSucceededCallback = function() { return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_defaultSucceededCallback(); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_defaultFailedCallback = function(value) { Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.set_defaultFailedCallback(value); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.get_defaultFailedCallback = function() { return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_defaultFailedCallback(); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_enableJsonp = function(value) { Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.set_enableJsonp(value); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.get_enableJsonp = function() { return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_enableJsonp(); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_jsonpCallbackParameter = function(value) { Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.set_jsonpCallbackParameter(value); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.get_jsonpCallbackParameter = function() { return Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.get_jsonpCallbackParameter(); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.set_path("/AudioStreamingStatsWs.asmx");
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.Test= function(onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.Test(onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddStreamingRecord= function(listItemId,isSample,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddStreamingRecord(listItemId,isSample,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.UpdateLastPosition= function(streamid,position,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.UpdateLastPosition(streamid,position,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.SetCompleted= function(streamid,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.SetCompleted(streamid,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AudioUrlByItemId= function(itemid,mp3Encoding,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AudioUrlByItemId(itemid,mp3Encoding,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AudioUrl= function(pid,recid,disc,trk,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AudioUrl(pid,recid,disc,trk,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.TrackIdFromPlaylist= function(playlistTrackNumber,playlistId,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.TrackIdFromPlaylist(playlistTrackNumber,playlistId,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.RandomTrackIdFromPartner= function(aid,pid,recid,disc,trk,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.RandomTrackIdFromPartner(aid,pid,recid,disc,trk,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.TrackInfo= function(pid,recid,disc,trk,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.TrackInfo(pid,recid,disc,trk,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.ListItemInfo= function(listItemId,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.ListItemInfo(listItemId,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddTrackToQueue= function(itemid,webkitkey,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddTrackToQueue(itemid,webkitkey,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddTrackToQueueWithClear= function(itemid,webkitkey,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddTrackToQueueWithClear(itemid,webkitkey,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddWorkToQueue= function(strPks,webkitkey,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddWorkToQueue(strPks,webkitkey,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddWorkToQueueWithClear= function(strPks,webkitkey,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddWorkToQueueWithClear(strPks,webkitkey,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddAlbumToQueue= function(pid,webkitkey,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddAlbumToQueue(pid,webkitkey,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddAlbumToQueueWithClear= function(pid,webkitkey,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddAlbumToQueueWithClear(pid,webkitkey,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.NextListItemId= function(listItemId,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.NextListItemId(listItemId,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.PreviousListItemId= function(listItemId,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.PreviousListItemId(listItemId,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.AddStreamingRecordMobileWeb= function(itemid,isSample,onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.AddStreamingRecordMobileWeb(itemid,isSample,onSuccess,onFailed,userContext); }
Evan.InstantEncore.Streaming.AudioStreamingStatsWs.ClearQueue= function(onSuccess,onFailed,userContext) {Evan.InstantEncore.Streaming.AudioStreamingStatsWs._staticInstance.ClearQueue(onSuccess,onFailed,userContext); }
