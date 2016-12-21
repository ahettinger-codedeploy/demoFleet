function ShowFlash(ept) {
  
  if(ept==1) {
  var content='<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="866" height="240" id="fb" align="middle">'+
                '<param name="allowScriptAccess" value="sameDomain" />'+
                '<param name="movie" value="flashplayer.swf" />'+
                '<param name="quality" value="high" />'+            
                '<param name="wmode" value="opaque" />'+          
                '<embed src="flashplayer.swf" wmode="opaque" quality="high" width="866" height="240" name="fb" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />'+
                '</object>';
  } else if(ept==2){
      var content='<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="233" height="121" id="fb" align="middle">'+
                '<param name="allowScriptAccess" value="sameDomain" />'+
                '<param name="movie" value="shop_banner.swf" />'+
                '<param name="quality" value="high" />'+            
                '<param name="wmode" value="transparent" />'+          
                '<embed src="shop_banner.swf" wmode="transparent" quality="high" width="233" height="121" name="fb" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />'+
                '</object>';  
  } else if(ept==3) {
   var content='<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="325" height="238" id="fb" align="middle">'+
                '<param name="allowScriptAccess" value="sameDomain" />'+
                '<param name="movie" value="artivist.swf" />'+
                '<param name="quality" value="high" />'+            
                '<param name="wmode" value="transparent" />'+          
                '<embed src="artivist.swf" wmode="transparent" quality="high" width="325" height="238" name="fb" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />'+
                '</object>';  
  }
  document.write(content);
}
