/*
 * FILE: player.js
 * 
 * Description: javascript functions needed for the media player (player.cfm)
 * 
 */

//--- JQuery ---\\
if (!$j) $j = jQuery.noConflict();

// Initialize the Dialogs
$j(document).ready(function(){
	$j("#shareDialog").dialog({ 
		autoOpen: false, 
		modal: true, 
		width: 410,
		title: 'Media Share',
		zIndex: 0
	 });
		
	$j("#embedDialog").dialog({ 
		autoOpen: false,
		modal: true,
		width: 425,
		resizeable: false,
		title: 'Embed Media'
	});
	
	$j("#searchDialog").dialog({ 
		autoOpen: false, 
		modal: true, 
		width: 425,
		height: 350,
		title: 'Media Search'
	});
	
});

/*
 * buildMediaHtml()
 * Outputs the media html embed for sharing
 */ 
function buildMediaHtml(divID,playerName,aspectRatio,embedWidth,embedHeight,flashVars){
	var embedHTML = '';
	var currWidth = embedWidth;
	var currHeight = embedHeight;
	
	
	embedHTML += '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="' + currWidth + '" height="' + currHeight + '" id="FlashID" alt="Finalsite Media Player">';
	embedHTML += '<param name="movie" value="'+playerName+'">';
	embedHTML += '<param name="flashvars" value="' + flashVars + '">';
	embedHTML += '<param name="quality" value="high">';
	embedHTML += '<param name="wmode" value="opaque">';
	embedHTML += '<param name="swfversion" value="10.0">';
	embedHTML += '<param name="allowFullScreen" value="true">';
	embedHTML += '<!-- 9.0.45.0 This param tag prompts users with Flash Player 6.0 r65 and higher to download the latest version of Flash Player. Delete it if you don\'t want users to see the prompt. -->';
	embedHTML += '<param name="expressinstall" value="scripts/expressInstall.swf">';
	embedHTML += '<!-- Next object tag is for non-IE browsers. So hide it from IE using IECC. -->';
	
	if (!$j.browser.msie) {
		//embedHTML += '<!--[if !IE]>-->';
		embedHTML += '<object type="application/x-shockwave-flash" data="'+playerName+'" width="' + currWidth + '" height="' + currHeight + '" border="#ffffff">';
		//embedHTML += '<!--<![endif]-->';
	}
	embedHTML += '<param name="flashvars" value="' + flashVars + '">';
	embedHTML += '<param name="quality" value="high">';
	embedHTML += '<param name="wmode" value="opaque">';
	embedHTML += '<param name="swfversion" value="10.0">';
	embedHTML += '<param name="expressinstall" value="scripts/expressInstall.swf">';
	embedHTML += '<param name="allowFullScreen" value="true">';
	embedHTML += '<!-- The browser displays the following alternative content for users with Flash Player 6.0 and older. -->';
	embedHTML += '<div>';
	embedHTML += '<h4>Content on this page requires Adobe Flash Player 10 or newer.</h4>';
	embedHTML += '<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" width="112" height="33" /></a></p>';
	embedHTML += '</div>';
	
	if (!$j.browser.msie) {
		//embedHTML += '<!--[if !IE]>-->';
		embedHTML += '</object>';
		//embedHTML += '<!--<![endif]-->';
	}
	
	embedHTML += '</object>';
	
	//theDiv.innerHTML = writeJS(playername,data1,currWidth,currHeight,auto_tog,random_tog,loop_tog,delay_num,data7);
	
	return embedHTML;
}

/*
 * writeMediaHtml()
 * Outputs the media html embed and determines maximum embed size based on parent Div
 */ 
function writeMediaHtml(divID, playerName, aspectRatio, embedWidth, embedHeight, flashVars){
	var embedHTML = buildMediaHtml(divID, playerName, aspectRatio, embedWidth, embedHeight, flashVars);
	
	$j('#'+divID).html(embedHTML);
}

/*
 * queueMediaPlayer()
 * Adds the writeMediaHtml() calls the to domOnReady event to minimize the performance impact of the loading flash player(s)
 */ 
function queueMediaPlayer(divID, playername, embedWidth, embedHeight, aspectRatio, flashvars, params, attributes, minVersion){
	$j(document).ready(function(){
		embedFlash(divID,playername,embedWidth,embedHeight,aspectRatio, flashvars, params, attributes, minVersion)
	});
}

var share_url_channel;
var share_url_folder;
var share_url_group;
var share_url_object;

// Functions that open the selected dialog
function openShare(){
	var share_title = '';
	var share_description = '';
	
	share_url_channel = mediaUrl+'/cf_media2/index.cfm?chnl='+arguments[0];
	share_url_folder = mediaUrl+'/cf_media2/index.cfm?cat='+arguments[1];
	share_url_group = mediaUrl+'/cf_media2/index.cfm?g='+arguments[2];
	share_url_object = mediaUrl+'/cf_media2/index.cfm?obj='+arguments[3];
	var basepath = '';
	
	if (arguments[4])
		share_title = arguments[4];
	
	if (arguments[5])
		share_description = arguments[5];
	
	if(window.location.href.indexOf('cf_media2') == -1){
		basepath = 'cf_media2/';
	}
	
	$j.get(basepath+'podcast.cfm', { obj: arguments[3] },
		function(data){
			if($j.trim(data) == ''){
				$j('#mediaRssContent').css('display','none');
				$j('#feedurls').html('<div style="text-align:center">RSS feeds are unavailable for this media.</div>');
			} else {
				$j('#mediaRssContent').css('display','block');
				$j('#feedurls').html(data);
			}
	});
	
	$j('#selSwitchShare').val('object');
	$j('#getlinkspan').val(share_url_object);
	
	// addThis update links
	$j('#addthis_medialinks a').each(function (i) {
		if(this.id) {
			$j('#'+this.id).attr('addthis:url',share_url_object);
			$j('#'+this.id).attr('addthis:title',share_title);
			$j('#'+this.id).attr('addthis:description',share_description);
		}
	});
	
	if (addthis && typeof addthis.toolbox == "function") addthis.toolbox(".addthis_toolbox");
	
	$j('#shareDialog').dialog('open');
}

function switchShare(switchTo) {
	switch (switchTo) {
		case 'channel':
			$j('#getlinkspan').val(share_url_channel);
			break;
		case 'folder':
			$j('#getlinkspan').val(share_url_folder);
			break;
		case 'group':
			$j('#getlinkspan').val(share_url_group);
			break;
		default:
			$j('#getlinkspan').val(share_url_object);
	}
}

function openEmbed(siteurl, channelId, categoryId, groupId, objectId){
	var embedCopy = '';
	var flashVars = 'siteurl='+ siteurl +'&mediaChannelID='+channelId+'&mediaCategoryID='+categoryId+'&mediaGroupID='+groupId+'&mediaObjectID='+objectId+'&mini=true&autoPlay=false';
	
	$j('#embedFlashvars').val(flashVars);
	$j('#embedSiteurl').val(siteurl);
	
	switch ($j('"embedSize":checked').val()) {
		case "large":
			updateEmbed(800, 450);
			break;
		case "medium":
			updateEmbed(640, 360);
			break;
		default:
			updateEmbed(320, 180);
	}
	
	// Modal Popup
	$j('#embedDialog').dialog('open');
}
function openSearch(){
	$j('#searchDialog').dialog('open');
	$j('#media_keyword').focus();
}

function closeShare(){
	$j('#shareContent').css('display','block');
	$j('#emailSuccess').css('display','none');
	$j('#shareDialog').dialog('close');
}

function updateEmbed(newWidth, newHeight){
	embedCopy = buildMediaHtml('fsMediaPlayer',$j('#embedSiteurl').val()+'/cf_media2/mediaPlayer.swf',(newWidth/newHeight),newWidth,newHeight,$j('#embedFlashvars').val());
	
	// Update embed contents
	$j('#embedCodeText').val('<div id="fsMediaPlayer">' + embedCopy + '</div>');
}

/*
* Media Search
*/
function mediaSearch(){
	var searchPhrase = $j('#media_keyword').attr("value");
	var basepath = '';
	
	if(window.location.href.indexOf('cf_media2') == -1){
		basepath = 'cf_media2/';
	}
	
	$j.get(basepath+'ajaxsearch.cfm', {mediaSearch: searchPhrase}, function (data){	
		// Update embed contents
		$j('#searchDialogResults').html(data);
	
		// Modal Popup
		//$j('#searchDialog').dialog('open');
	}, 'html');

}

/*
 * submitStaf()
 */
function submitStaf(){
	var stafForm = $j('#stafForm');
	var honeyPot = $j('#confirmSubmit');
	var sendername = $j('#sendername');
	var toemail = $j('#toemail');
	var sharesubject = $j('#sharesubject');
	var sendmessage = $j('#sendmessage');
	var sendmsgBtn = $j('#sendmsg');
	
	if(window.location.href.indexOf('cf_media2') == -1){
		basepath = 'cf_media2/';
	} else {
		basepath = '';
	}
	
	if(honeyPot.val() == ''){
		$j.post(basepath+"staf.cfm", { sendername: sendername.val(), toemail: toemail.val(), sharesubject: sharesubject.val(), sendmessage: sendmessage.val() },
			function(data){
				$j('#shareContent').css('display','none');
				$j('#emailSuccess').css('display','block');
				
				// Reset Form
				sendername.val('');
				toemail.val('');
				sharesubject.val('');
				sendmessage.val('');
				sendmsgBtn.val('SEND');
				sendmsgBtn.disabled = false;
			}
		);
	}
}

//e is event object passed from function invocation	var characterCode literal character code will be stored in this variable
function checkEnter(e){ 
	
	if(e && e.which){ //if which property of event object is supported (NN4)
		e = e;
		characterCode = e.which; //character code is contained in NN4's which property
	} else {
		e = event;
		characterCode = e.keyCode; //character code is contained in IE's keyCode property
	}
	
	if(characterCode == 13){ //if generated character code is equal to ascii 13 (if enter key)
		mediaSearch();
		return false;
	} else {
		return true;
	}
	
}