function flashMovie(src,wt,ht,flashVars){
	if(!flashVars){
		var flashVars = "";
	}
	document.write(""+
"<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\""+wt+"\" height=\""+ht+"\" id=\"flash_movie\" align=\"middle\">"+
"<param name=\"FlashVars\" value=\""+flashVars+"\" />"+
"<param name=\"wmode\" value=\"transparent\" />"+
"<param name=\"allowScriptAccess\" value=\"sameDomain\" />"+
"<param name=\"movie\" value=\""+src+"\" />"+
"<param name=\"menu\" value=\"false\" />"+
"<param name=\"quality\" value=\"high\" />"+
"<param name=\"salign\" value=\"lt\" />"+
"<param name=\"bgcolor\" value=\"#ffffff\" />"+
"<embed wmode=\"transparent\" src=\""+src+"\" menu=\"false\" flashVars=\""+flashVars+"\" quality=\"high\" salign=\"lt\" bgcolor=\"#ffffff\" width=\""+wt+"\" height=\""+ht+"\" name=\""+src+"\" align=\"middle\" allowScriptAccess=\"sameDomain\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" />"+
"</object>");
}

function windowsMedia(url,wt,ht){
document.write(""+
"<object id=\"Player\" classid=\"clsid:6BF52A52-394A-11D3-B153-00C04F79FAA6\""+ 
	"type=\"application/x-oleobject\" align=\"center\""+
	"standby=\"Loading a Visual Communicator video. Please wait.\""+
	"width=\""+wt+"\" height=\""+ht+"\">"+
	"<param name=\"wmode\" value=\"transparent\">"+
	"<param name=\"URL\" value=\""+url+"\">"+
	"<param name=\"rate\" value=\"1\">"+
	"<param name=\"balance\" value=\"0\">"+
	"<param name=\"currentPosition\" value=\"0\">"+
	"<param name=\"defaultFrame\" value=\"\">"+
	"<param name=\"playCount\" value=\"1\">"+
	"<param name=\"autoStart\" value=\"1\">"+
	"<param name=\"currentMarker\" value=\"0\">"+
	"<param name=\"invokeURLs\" value=\"1\">"+
	"<param name=\"baseURL\" value=\"\">"+
	"<param name=\"volume\" value=\"75\">"+
	"<param name=\"mute\" value=\"0\">"+
	"<param name=\"uiMode\" value=\"full\">"+
	"<param name=\"stretchToFit\" value=\"1\">"+
	"<param name=\"windowlessVideo\" value=\"0\">"+
	"<param name=\"enabled\" value=\"-1\">"+
	"<param name=\"enableContextMenu\" value=\"1\">"+
	"<param name=\"fullScreen\" value=\"0\">"+
	"<param name=\"enableErrorDialogs\" value=\"0\">"+
	"<param name=\"displaySize\" Value=\"0\">"+
	"<embed type=\"application/x-mplayer2\" "+
	  "name=\"Player\""+
	  "pluginspage=\"http://www.microsoft.com/Windows/Downloads/Contents/Products/MediaPlayer/\""+
	  "src=\""+url+"\""+
	  "width=\""+wt+"\""+
	  "height=\""+ht+"\""+
	  "autostart=\"1\""+
	  "volume=\"75\""+
	  "mute=\"0\""+
	  "showcontrols=\"1\""+
	  "invokeURLs=\"1\""+
	  "displaySize=\"0\">"+
	"</embed>"+
"</object>");
}
function swapUrl(url){
	document.getElementById("linko").href = url;
}
// simple function for alternating element bg colors
function Alternate(_parent,_chain){
	this.master = document.getElementById(_parent);
	this.nodes = _chain.split('.');
	this.scaffold(this.master,0);
}
Alternate.prototype.scaffold = function(_el,_index){
	var md = 'cell0';
	for(var i=0; i < _el.getElementsByTagName(this.nodes[_index]).length; i++){
		if(this.nodes[_index+1]){
			this.scaffold(_el.getElementsByTagName(this.nodes[_index])[i],_index+1);
		}else{
			(md == 0) ? (md = 1) : (md = 0)
			_el.getElementsByTagName(this.nodes[_index])[i].setAttribute('class','cell'+md);
			//nodes[i].setAttribute('class','cell'+md);
		}
	}
}