jQuery(document).ready(function(){function a(e,t){var n=parseInt(e.slice(1),16),r=Math.round(2.55*t),i=(n>>16)+r,s=(n>>8&255)+r,o=(n&255)+r;return"#"+(16777216+(i<255?i<1?0:i:255)*65536+(s<255?s<1?0:s:255)*256+(o<255?o<1?0:o:255)).toString(16).slice(1)}var e=tpbr_settings.fixed;var t=tpbr_settings.message;var n=tpbr_settings.button_url;var r=tpbr_settings.button_text;var i=tpbr_settings.color;var s=tpbr_settings.status;var o=tpbr_settings.yn_button;var u=tpbr_settings.is_admin_bar;if(o=="button"){var f=a(i,-12);var l='<a id="tpbr_calltoaction" style="background:'+f+'; display:inline-block; padding:1px 10px 4px; color:white; text-decoration:none; margin: 0px 20px 1px;border-radius:3px; line-height:29px;" href="'+n+'">'+r+"</a>"}else{var l=""}if(e=="fixed"){if(u==="yes"){var c="position:fixed; z-index:99999; width:100%; left:0px; top:0; margin-top:32px;"}else{var c="position:fixed; z-index:99999; width:100%; left:0px; top:0;"}}if(e=="notfixed"){var c=""}if(e==""||e==null){var c=""}if(s=="active"){if(e=="fixed"){jQuery('<div style="height:44px; visibility:hidden;"></div><div id="tpbr_topbar" style="'+c+" background:"+i+'; padding:3px 20px 5px;"><div id="tpbr_box" style="line-height:40px; font-size:15px; font-family: Helvetica, Arial, sans-serif; text-align:center; width:100%; color:white; font-weight:300;">'+t+l+"</div></div>").prependTo("body")}else{jQuery('<div id="tpbr_topbar" style="'+c+" background:"+i+'; padding:3px 20px 5px;"><div id="tpbr_box" style="line-height:40px; text-align:center; width:100%; color:white; font-size:15px; font-family: Helvetica, Arial, sans-serif;  font-weight:300;">'+t+l+"</div></div>").prependTo("body")}}jQuery(".tpbr_close").click(function(){jQuery("#tpbr_topbar").slideUp(100)})})