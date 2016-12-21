function eshare_metakeywords(){
    if(eshare_description===undefined){
        metaCollection=document.getElementsByTagName("meta");
        for(i=0;i<metaCollection.length;i++){
            nameAttribute=metaCollection[i].name.search(/keywords/);
            if(nameAttribute!=-1){
                eshare_keywords=metaCollection[i].content;
                return eshare_keywords
            }
        }
    }else{
        return eshare_keywords
    }
}
function eshare_metadescription(){
    if(eshare_description===undefined){
        metaCollection=document.getElementsByTagName("meta");
        for(i=0;i<metaCollection.length;i++){
            nameAttribute=metaCollection[i].name.search(/description/);
            if(nameAttribute!=-1){
                eshare_description=metaCollection[i].content;
                return eshare_description
            }
        }
    }else{
        return eshare_description
    }
}
function eshare_url(){
    return sharedURL
}
function eshare_title(){
    return sharedTitle
}

function analytics_follow(e){
    _gaq.push(["emailit._trackEvent","E-MAILiT Follow",e,decodeURIComponent(sharedURL)]);
    if(get_analytics!==""){
        _gaq.push(["_trackEvent","E-MAILiT Follow",e,decodeURIComponent(sharedURL)])
    }
}

function update_social_services(){
    var n = share_services_new.split(",");   
    share_services="";
    for(var r=0;r<n.length;r++){
        if(share_services_new){
            var i=n[r];
            var s=i.replace(/_/gi," ");
            if(s=="G plus")s="Google+";
            var o=def_services_links[i];
            if(o!==undefined){
                o=o.replace(/{TITLE}/gi,eshare_title());
                o=o.replace(/{URL}/gi,eshare_url());
                o=o.replace(/{KEYWORDS}/gi,eshare_metakeywords());
                o=o.replace(/{DESCRIPTION}/gi,eshare_metadescription());
                var u="";
                if(s!="WordPress"){
                    u="_gaq.push(['emailit._trackEvent', 'E-MAILiT Share', '"+s+"', decodeURIComponent('"+sharedURL+"')]);";
                    if(get_analytics!==""){
                        u+="_gaq.push(['_trackEvent', 'E-MAILiT Share', '"+s+"', decodeURIComponent('"+sharedURL+"')]); "
                    }
                }
                if(s=="Email"){
                    var a='<li class="e_mailit_services_list"><a href="javascript:void(0)" class="link_serv" onclick="javascript:create_e_email(); count_shares(); return false;"><div class="E_mailit_'+i+'"></div><span class="e_mailit_services_text">'+s+"</span></a></li>"
                }else if(s=="WordPress"){
                    var a='<li class="e_mailit_services_list"><a href="javascript:void(0)" class="link_serv" onclick="javascript:create_e_WordPress(); count_shares();return false;"><div class="E_mailit_'+i+'"></div><span class="e_mailit_services_text">'+s+"</span></a></li>"
                }else if(s=="Pinterest"){
                    var a='<li class="e_mailit_services_list"><a href="'+o+'"  class="link_serv" onclick="'+u+'count_shares();"><div class="E_mailit_'+i+'"></div><span class="e_mailit_services_text">'+s+"</span></a></li>"
                }else{
                    var a='<li class="e_mailit_services_list"><a href="'+o+'"  class="link_serv" target="_blank" onclick="'+u+'count_shares();"><div class="E_mailit_'+i+'"></div><span class="e_mailit_services_text">'+s+"</span></a></li>"
                }
            }
            share_services=share_services+a
        }
    }    
}

function get_social_services(t){
    emailit_email_data='<div class="e_mailit_button_body_email"><div class="e_mailit_email_icon"></div><div class="e_mailit_share_back"></div><div class="e_mailit_close"></div><div class="e_mailit_wrapper"><div class="e_mailit_bar_promotion_email"><div class="e_mailit_promo_icon_open"></div><div class="e_mailit_promo_icon_close"></div><span class="e_mailit_promo">promo</span></div><iframe id="iframe_emailit_form_display"  scrolling="no" frameborder="0" style="height:346px;width:321px" >You need a Frames Capable browser to view this content.</iframe></div><div id="e_mailit_footer_button"><div id="e_mailit_sponsor"><a href="javascript:if(typeof window.create_button == \'undefined\'){(function(){var b=document.createElement(\'script\');b.type=\'text/javascript\';b.async=true;b.src=\'http://www.e-mailit.com/widget/button/js/bookmarklet.js\';var c=document.getElementsByTagName(\'head\')[0];c.appendChild(b)})();}else{create_button(\'bm_share\',\'no\');}void(0);" onclick="return false;" class="get_bookmarklet" title="Drag this to your Bookmarks Bar.">Get your own button for your browser!</a></div><div id="e_mailit_sign"><a href="http://www.e-mailit.com/widget/login" target="_blank">Sign in</a></div></div></div>';    
    if(id_code == "0"){
        share_services_new = "Email,Facebook,Twitter,Pinterest,LinkedIn,G_plus,WordPress,StumbleUpon,Reddit,Tumblr";  
        emailit_email_iframe_url="http://www.e-mailit.com/widget/button/recapchaiframe/email_form.php?document_location="+sharedURL+"&get_analytics=";
        follow_services="";
        load_iframe=    "http://www.e-mailit.com/def_net_ad?url="+document.location.href;    
        if(get_analytics!==""){
            _gaq.push(["_setAccount",get_analytics]);
            _gaq.push(["_trackPageview"])
        }
        
        return;
    }


    jQ14.getJSON(("https:"==document.location.protocol?"https://www":"http://www")+".e-mailit.com/widget/button/php/custom.php?customer="+t+"&document_location="+sharedURL+"&jsoncallback=?",function(t){
        n="";
        get_analytics=t.e_mailit_analytics;
        share_services_new = t.e_mailit_default_services;

        if(get_analytics!==""){
            _gaq.push(["_setAccount",get_analytics]);
            _gaq.push(["_trackPageview"])
        }

        emailit_email_iframe_url=t.e_mailit_iframe_url;
        follow_services=t.e_mailit_follow;
        load_iframe=t.e_mailit_iframe;
        if(load_iframe === "http://www.e-mailit.com/def_net_ad");
            load_iframe += "?url="+document.location.href;
    })
}

function e_mailit_remove(){
    jQ14("#e_mailit_overlay,#e_mailit_box").remove()
}
function get_ads(){
    _gaq.push(["emailit._trackEvent","E-MAILiT Promo","Open",decodeURIComponent(sharedURL)]);
    if(get_analytics!==""){
        _gaq.push(["_trackEvent","E-MAILiT Promo","Open",decodeURIComponent(sharedURL)])
    }
    jQ14("#iframe_emailit_display").remove();
    var e='<iframe id="iframe_emailit_display" src="'+load_iframe+'" scrolling="no" allowTransparency="true" FRAMEBORDER="0" style="display:none;">You need a Frames Capable browser to view this content.</iframe>';
    jQ14("#e_mailit_box").css("margin-left",function(e,t){
        return parseInt(t,10)-155+"px"
    });
    jQ14(".e_mailit_promo_icon_open").hide("fast",function(){
        jQ14(".e_mailit_promo_icon_close").show("fast")
    });
    jQ14(".e_mailit_ads").fadeIn(0);
    jQ14(".e_mailit_ads").prepend(e);
    jQ14("#iframe_emailit_display").fadeIn(0)
}
function remove_iframe(){
    _gaq.push(["emailit._trackEvent","E-MAILiT Promo","Close",decodeURIComponent(sharedURL)]);
    if(get_analytics!==""){
        _gaq.push(["_trackEvent","E-MAILiT Promo","Close",decodeURIComponent(sharedURL)])
    }
    jQ14("#e_mailit_box").css("margin-left",function(e,t){
        return parseInt(t,10)+155+"px"
    });
    jQ14(".e_mailit_promo_icon_close").hide("fast");
    jQ14(".e_mailit_promo_icon_open").show("fast");
    jQ14("#iframe_emailit_display").remove();
    jQ14(".e_mailit_ads").fadeOut(0)
}
function E_mailitDisplay(e){
    _gaq.push(["emailit._trackEvent","E-MAILiT Button","Open",decodeURIComponent(sharedURL)]);
    if(get_analytics!==""){
        _gaq.push(["_trackEvent","E-MAILiT Button","Open",decodeURIComponent(sharedURL)])
    }
}
function create_e_WordPress(){
    if(close_WordPress==0){
        jQ14(".e_mailit_button_body").slideUp("fast",function(){
            var e=['<div class="e_mailit_button_body_email">','<div class="e_mailit_sharelogo"></div>','<div class="e_mailit_share_back"></div>','<div class="e_mailit_close"></div>','<div class="e_mailit_wrapper">','<div class="e_mailit_bar_promotion_email">','<div class="e_mailit_promo_icon_open"></div>','<div class="e_mailit_promo_icon_close"></div>','<span class="e_mailit_promo">promo</span>',"</div>",'<div id="wordpress_emailit_button">','<form id="wordpress_form">','<div class="E_mailit_WordPress"></div><span id="text_wordpress_emailit">WordPress</span><br/>','<div class="input_wordpress" style="margin-top:15px;width:100%">http://<input name="" type="text" value="Blog URL" id="e_mailit_wordpress_input" /> /</div>','<input type="submit" name="e_mailit_wordpress_button" value="OK" id="e_mailit_wordpress_button">',"</form></div>","</div>",'<div id="e_mailit_footer_button"><div id="e_mailit_sponsor"><a href="javascript:if(typeof window.create_button == \'undefined\'){(function(){var b=document.createElement(\'script\');b.type=\'text/javascript\';b.async=true;b.src=\'http://www.e-mailit.com/widget/button/js/bookmarklet.js\';var c=document.getElementsByTagName(\'head\')[0];c.appendChild(b)})();}else{create_button(\'bm_share\',\'no\');}void(0);" onclick="return false;" class="get_bookmarklet" title="Drag this to your Bookmarks Bar.">Get your own button for your browser!</a></div><div id="e_mailit_sign"><a href="http://www.e-mailit.com/widget/login" target="_blank">Sign in</a></div></div></div>'];
            jQ14("#e_mailit_box").append(e.join(""));
		    jQ14(".get_bookmarklet").hover(function() {
			  jQ14("#bookmarklet_explain").fadeToggle();
			});
           
            jQ14(".e_mailit_close,#e_mailit_overlay").click(function(){
                jQ14("#e_mailit_overlay,#e_mailit_box").remove();
                close_WordPress=0
            });
            jQ14("#e_mailit_wordpress_input").focus(function(){
                jQ14("#e_mailit_wordpress_input").val("")
            });
            jQ14("#e_mailit_wordpress_input").focusout(function(){
                if(jQ14("#e_mailit_wordpress_input").val()==""){
                    jQ14("#e_mailit_wordpress_input").css({
                        "background-color":"#FFDBED"
                    });
                    i=1
                }else{
                    jQ14("#e_mailit_wordpress_input").css({
                        "background-color":"#f4f4f4"
                    });
                    i=0
                }
            });
            jQ14("#wordpress_form").submit(function(e){
                var t=jQ14("#e_mailit_wordpress_input").val();
                if(t===""||t==="Blog URL"){
                    jQ14("#e_mailit_wordpress_input").css({
                        "background-color":"#FFDBED"
                    });
                    i=1;
                    return false
                }else{
                    jQ14("#e_mailit_wordpress_input").css({
                        "background-color":"#f4f4f4"
                    });
                    i=0
                }
                if(i==1){
                    return false
                }else{
                    window.open("http://"+t+"/wp-admin/press-this.php?u="+sharedURL+"&t="+sharedTitle+"&s="+encodeURIComponent("")+"&v=2","t","toolbar=0,resizable=1,scrollbars=0,status=1,width=770,height=495,left=0,top=0");
                    _gaq.push(["emailit._trackEvent","E-MAILiT Share","Wordpress",decodeURIComponent(sharedURL)]);
                    if(get_analytics!==""){
                        _gaq.push(["_trackEvent","E-MAILiT Share","Wordpress",decodeURIComponent(sharedURL)])
                    }
                    return false
                }
            });
            if(jQ14("#e_mailit_box").offset()!=null){
                if(jQ14(".e_mailit_ads").css("display")=="none"){
                    jQ14(".e_mailit_promo_icon_close").hide("fast");
                    jQ14(".e_mailit_promo_icon_open").show("fast")
                }else{
                    jQ14(".e_mailit_promo_icon_open").hide("fast");
                    jQ14(".e_mailit_promo_icon_close").show("fast")
                }
                jQ14(".e_mailit_bar_promotion_email").click(function(){
                    if(jQ14(".e_mailit_ads").css("display")=="block"){
                        remove_iframe()
                    }else{
                        get_ads()
                    }
                });
                jQ14(".e_mailit_share_back").click(function(){
                    close_WordPress=0;
                    jQ14(".e_mailit_button_body_email").remove();
                    jQ14(".e_mailit_button_body").fadeIn("fast");
                    if(jQ14(".e_mailit_ads").css("display")=="none"){
                        jQ14(".e_mailit_promo_icon_close").hide("fast");
                        jQ14(".e_mailit_promo_icon_open").show("fast")
                    }else{
                        jQ14(".e_mailit_promo_icon_open").hide("fast");
                        jQ14(".e_mailit_promo_icon_close").show("fast")
                    }
                })
            }
        });
        close_WordPress=1
    }
}
function create_e_email(){
    if(close_email==0){
        _gaq.push(["emailit._trackEvent","E-MAILiT Email","Open",decodeURIComponent(sharedURL)]);
        if(get_analytics!==""){
            _gaq.push(["_trackEvent","E-MAILiT Email","Open",decodeURIComponent(sharedURL)])
        }
        jQ14(".e_mailit_button_body").slideUp("fast",function(){
            jQ14("#e_mailit_box").append(emailit_email_data);
		    jQ14(".get_bookmarklet").hover(function() {
			  jQ14("#bookmarklet_explain").fadeToggle();
			});
          
            jQ14(".e_mailit_close,#e_mailit_overlay").click(function(){
                jQ14("#e_mailit_overlay,#e_mailit_box").remove();
                close_email=0
            });
            if(jQ14("#e_mailit_box").offset()!=null){
                if(jQ14(".e_mailit_ads").css("display")=="none"){
                    jQ14(".e_mailit_promo_icon_close").hide("fast");
                    jQ14(".e_mailit_promo_icon_open").show("fast")
                }else{
                    jQ14(".e_mailit_promo_icon_open").hide("fast");
                    jQ14(".e_mailit_promo_icon_close").show("fast")
                }
                var e=document.getElementById("iframe_emailit_form_display");
                e.src="http://www.e-mailit.com/widget/button/recapchaiframe/email_form.php?document_location="+sharedURL+"&get_analytics="+get_analytics
                jQ14(".e_mailit_bar_promotion_email").click(function(){
                    if(jQ14(".e_mailit_ads").css("display")=="block"){
                        remove_iframe()
                    }else{
                        get_ads()
                    }
                });
                jQ14(".e_mailit_share_back").click(function(){
                    close_email=0;
                    jQ14(".e_mailit_button_body_email").remove();
                    jQ14(".e_mailit_button_body").fadeIn("fast");
                    if(jQ14(".e_mailit_ads").css("display")=="none"){
                        jQ14(".e_mailit_promo_icon_close").hide("fast");
                        jQ14(".e_mailit_promo_icon_open").show("fast")
                    }else{
                        jQ14(".e_mailit_promo_icon_open").hide("fast");
                        jQ14(".e_mailit_promo_icon_close").show("fast")
                    }
                })
            }
        });
        close_email=1
    }
}
function e_mailit(){
    if(typeof e_mailit_config!=="undefined"){
        if(e_mailit_config["ga_property_id"] != undefined)
            get_analytics = e_mailit_config["ga_property_id"];
    }	

    thirdPartyButtons();
    id_code = jQ14(".e_mailit_button").attr("id");
    if(!id_code) id_code = "0";

    get_social_services(id_code);
    
    jQ14(".e_mailit_button").each(function(){
        var e_mailit_button = jQ14(this);
        id_code = e_mailit_button.attr("id");
        var url2share = encodeURIComponent(e_mailit_button.attr("e-mailit:url"));
        if(url2share === "" || url2share === "undefined")
            url2share = encodeURIComponent(document.location.href);
        var title2share = encodeURIComponent(e_mailit_button.attr("e-mailit:title"));
        if(title2share === "" || title2share === "undefined")
            title2share = encodeURIComponent(document.title);    
        
        jQ14.getJSON(("https:"==document.location.protocol?"https://www":"http://www")+".e-mailit.com/widget/button/php/get_id.php?customer="+id_code+"&document_location="+url2share+"&document_title="+title2share+"&jsoncallback=?",function(e){
            var new_e_mailit_button = jQ14(e.e_mailit_id);
            new_e_mailit_button= e_mailit_button.replaceWith(new_e_mailit_button);
            
            if(typeof e_mailit_config!=="undefined"){
                if(e_mailit_config["display_counter"]===false)
                    jQ14(".e_mailit_counter_div").hide();
            }
            var topPix = jQ14(window).height() / 2;
            jQ14('#e_mailit_center_left').css('top', topPix);
            jQ14('.e_mailit_counter_float_left').css('top', topPix-30);
            jQ14('#e_mailit_center_right').css('top', topPix);
            jQ14('.e_mailit_counter_float_right').css('top', topPix-30);            
        })        
    });
}

function openButtonWithAds(){
	if(jQ14("#e_mailit_custom_position")){
		jQ14("#e_mailit_custom_position").mouseover();
		if(jQ14("#e_mailit_box").length === 0)
			jQ14("#e_mailit_custom_position").click();
		if(jQ14(".e_mailit_ads").css("display")!="block")
			jQ14(".e_mailit_bar_promotion").click();
	}	
}

function thirdPartyButtons(){
	    if((facebook_button=jQ14("span.e-mailit_facebook_share_btn:not(span.toolbox_buttons)")).length>0){

	    if (typeof (FB) != 'undefined') {
	    	
	        FB.init({ status: true, cookie: true, xfbml: true, appId: '299165376858838', version:'v2.0'});
	    } else {
	    	jQ14("body").prepend("<div id=\"fb-root\"></div>");
	        jQ14.getScript("http://connect.facebook.net/"+getLocale()+"/all.js", function () {
	            FB.init({ status: true, cookie: true, xfbml: true, appId: '299165376858838', version:'v2.0'});
	        });
	    }

        facebook_button.each(function(){
            var data_href = jQ14(this).attr("e-mailit:url");
            if(data_href !== "" && data_href !== undefined )
                data_href = ' data-href="'+data_href+'"';

            jQ14(this).append('<div class="fb-share-button"'+data_href+' data-type="button_count"></div>');
            jQ14(this).addClass("toolbox_buttons");
            jQ14(this).css("margin-right","14px");


			var track_href = jQ14(this).attr("e-mailit:url");
			if(track_href == "" || track_href == undefined )
				track_href = document.location.href; 
			jQ14(this).iframeTracker({
					blurCallback: function(){
					_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'facebook share', track_href]);
					if(get_analytics!==""){
						_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'facebook share', track_href]); 
					}
					setTimeout(function() {
						openButtonWithAds();
					}, 1000);	
				}
			});

        });
    }
    if((facebook_button=jQ14("span.e-mailit_facebook_btn:not(span.toolbox_buttons)")).length>0){

	    if (typeof (FB) != 'undefined') {
	        FB.init({ status: true, cookie: true, xfbml: true, appId: '299165376858838', version:'v2.0'});
			FB.Event.subscribe('edge.create',
		    	function(href, widget) {
		        	openButtonWithAds();
		    	}
			);	        
	    } else {
	    	jQ14("body").prepend("<div id=\"fb-root\"></div>");
	        jQ14.getScript("http://connect.facebook.net/"+getLocale()+"/all.js", function () {
	            FB.init({ status: true, cookie: true, xfbml: true, appId: '299165376858838', version:'v2.0'});
				FB.Event.subscribe('edge.create',
			    	function(href, widget) {
			        	openButtonWithAds();
			    	}
				);	            
	        });
	    }

        facebook_button.each(function(){
            var data_href = jQ14(this).attr("e-mailit:url");
            if(data_href !== "" && data_href !== undefined )
                data_href = ' data-href="'+data_href+'"';
			var include_share = jQ14(this).attr("e-mailit:include_share");
			if(include_share == "true")
				include_share = 'data-share="true"';                
            jQ14(this).append('<div class="fb-like"'+data_href+' data-send="false" '+include_share+' data-layout="button_count" data-show-faces="true" ></div>');
            jQ14(this).addClass("toolbox_buttons");
            jQ14(this).css("margin-right","14px");


			var track_href = jQ14(this).attr("e-mailit:url");
			if(track_href == "" || track_href == undefined )
				track_href = document.location.href; 
			jQ14(this).iframeTracker({
					blurCallback: function(){
					_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'facebook', track_href]);
					if(get_analytics!==""){
						_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'facebook', track_href]); 
					}
			
				}
			});

        });
    }
    if((twitter_button=jQ14("span.e-mailit_twitter_btn:not(span.toolbox_buttons)")).length>0){
        twitter_button.each(function(){
            var data_href = jQ14(this).attr("e-mailit:url");
            if(data_href !== "" && data_href !== undefined )
                data_href = ' data-url="'+data_href+'"';     
            var data_title = jQ14(this).attr("e-mailit:title");
            if(data_title !== "" && data_title !== undefined )
                data_title = ' data-text="'+data_title+'"';            
            jQ14(this).append('<a href="https://twitter.com/share"'+data_href+' '+data_title+' class="twitter-share-button" data-via="'+twitterVia+'">Tweet</a>');
            jQ14(this).addClass("toolbox_buttons");
			
			var track_href = jQ14(this).attr("e-mailit:url");
			if(track_href == "" || track_href == undefined )
				track_href = document.location.href; 
			jQ14(this).iframeTracker({
					blurCallback: function(){
					_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'twitter', track_href]);
					if(get_analytics!==""){
						_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'twitter', track_href]); 
					}
					setTimeout(function() {
						openButtonWithAds();
					}, 1000);						
				}
			});
        });
        var script = document.createElement("script");
        script.setAttribute("type", "text/javascript");
        script.setAttribute("async", "true");
        script.src = "http://platform.twitter.com/widgets.js";
        var head = document.getElementsByTagName('head')[0];
        head.insertBefore(script, head.firstChild);        
    }
    if((google_button=jQ14("span.e-mailit_google_btn:not(span.toolbox_buttons)")).length>0){
        google_button.each(function(){
            var data_href = jQ14(this).attr("e-mailit:url");
            if(data_href !== "" && data_href !== undefined )
                data_href = ' data-href=\"'+data_href+"\"";            
            jQ14(this).append("<div class=\"g-plusone\""+data_href+" data-size=\"medium\"></div><script type=\"text/javascript\"> (function() {    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;    po.src = 'https://apis.google.com/js/plusone.js';    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);  })();</script>");
            jQ14(this).addClass("toolbox_buttons");
			
			var track_href = jQ14(this).attr("e-mailit:url");
			if(track_href == "" || track_href == undefined )
				track_href = document.location.href; 
			jQ14(this).iframeTracker({
					blurCallback: function(){
					_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'google+', track_href]);
					if(get_analytics!==""){
						_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'google+', track_href]); 
					}
					setTimeout(function() {
						openButtonWithAds();
					}, 1000);					
				}
			});
        });
    }
    if((linkedin_button=jQ14("span.e-mailit_linkedin_btn:not(span.toolbox_buttons)")).length>0){
        linkedin_button.each(function(){
            var data_href = jQ14(this).attr("e-mailit:url");
            if(data_href !== "" && data_href !== undefined )
                data_href = ' data-url="'+data_href+'"';                
            jQ14(this).append('<script src="//platform.linkedin.com/in.js" type="text/javascript"></script><script type="IN/Share"'+data_href+' data-counter="right"></script>');
            jQ14(this).addClass("toolbox_buttons");
            jQ14(this).css("margin-right","13px")
			jQ14(this).click(function(){
				var data_href = jQ14(this).attr("e-mailit:url");
				if(data_href == "" || data_href == undefined )
					data_href = document.location.href; 
				_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'linkedin', data_href]);
				if(get_analytics!==""){
					_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'linkedin', data_href]); 
				}
				openButtonWithAds();				
			});			
        });
    }
    if((pinterest_button=jQ14("span.e-mailit_pinterest_btn:not(span.toolbox_buttons)")).length>0){
        jQ14("body").append('<script type="text/javascript" src="//assets.pinterest.com/js/pinit.js"></script>');
        pinterest_button.each(function(){
            jQ14(this).append('<a data-pin-config="beside" href="//pinterest.com/pin/create/button/" data-pin-do="buttonBookmark" ><img src="//assets.pinterest.com/images/pidgets/pin_it_button.png" /></a>');
            pinterest_button.addClass("toolbox_buttons");
            pinterest_button.css("margin-right","35px");
			jQ14(this).click(function(){
				var data_href = jQ14(this).attr("e-mailit:url");
				if(data_href == "" || data_href == undefined )
					data_href = document.location.href; 
				_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'pinterest', data_href]);
				if(get_analytics!==""){
					_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'pinterest', data_href]); 
				}
				openButtonWithAds();				
			});
        });
    }
    if((vkontakte_button=jQ14("span.e-mailit_vkontakte_btn:not(span.toolbox_buttons)")).length>0){
		var donevk = false;
		var script = document.createElement("script");
        script.setAttribute("type", "text/javascript");
        script.setAttribute("async", "true");
        script.src = "http://vk.com/js/api/share.js?86";
        var head = document.getElementsByTagName('head')[0];
		script.onload=script.onreadystatechange=function(){
			if(!donevk&&(!this.readyState||this.readyState=="loaded"||this.readyState=="complete")){
				vkontakte_button.each(function(){
					var data_href = jQ14(this).attr("e-mailit:url");
					if(data_href == "" || data_href == undefined )
						data_href = '';
					var data_title = jQ14(this).attr("e-mailit:title");
					if(data_title == "" || data_title == undefined )
						data_title = '';
					var scriptvk = document.createElement("script");
					scriptvk.setAttribute("type", "text/javascript");
					if(data_href != '')
						jQ14(this).append(VK.Share.button({url: data_href, title: data_title},{type: "round", text: "Share"}));					
					else
						jQ14(this).append(VK.Share.button(false,{type: "round", text: "Share"}));
					jQ14(this).addClass("toolbox_buttons");
					jQ14(this).css("margin-right","5px")
					
					jQ14(this).click(function(){
						var data_href = jQ14(this).attr("e-mailit:url");
						if(data_href == "" || data_href == undefined )
							data_href = document.location.href; 
						_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'vkontakte', data_href]);
						if(get_analytics!==""){
							_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'vkontakte', data_href]); 
						}
						openButtonWithAds();						
					});

				});
			
			}
		}
        head.insertBefore(script, head.firstChild);   
    }
    if((odnoklassniki_button=jQ14("span.e-mailit_odnoklassniki_btn:not(span.toolbox_buttons)")).length>0){
    	var id = 0;
        odnoklassniki_button.each(function(){
        	id++;
            var data_href = jQ14(this).attr("e-mailit:url");
            if(data_href === undefined )
                data_href = "";            
            jQ14(this).append("<div id=\"ok_shareWidget"+id+"\"></div><script>!function (d, id, did, st) {  var js = d.createElement(\"script\");  js.src = \"http://connect.ok.ru/connect.js\";  js.onload = js.onreadystatechange = function () {  if (!this.readyState || this.readyState == \"loaded\" || this.readyState == \"complete\") {    if (!this.executed) {      this.executed = true;      setTimeout(function () {        OK.CONNECT.insertShareWidget(id,did,st);      }, 0);    }  }};  d.documentElement.appendChild(js);}(document,\"ok_shareWidget"+id+"\",\"" + data_href +"\",\"{width:145,height:30,st:'rounded',sz:20,ck:1}\");</script>");
            jQ14(this).addClass("toolbox_buttons");
            jQ14(this).css("margin-right","5px")
			
			var track_href = jQ14(this).attr("e-mailit:url");
			if(track_href == "" || track_href == undefined )
				track_href = document.location.href; 
			jQ14(this).iframeTracker({
					blurCallback: function(){
					_gaq.push(['emailit._trackEvent', 'E-MAILiT 3rd party Share', 'odnoklassniki', track_href]);
					if(get_analytics!==""){
						_gaq.push(['_trackEvent', 'E-MAILiT 3rd party Share', 'odnoklassniki', track_href]); 
					}
					setTimeout(function() {
						openButtonWithAds();
					}, 1000);					
				}
			});
        });
    }    
}

function receiveMessage(event)
{
  // Do we trust the sender of this message?
  if (event.origin !== "http://www.e-mailit.com")
    return;
    
   if(event.data == "share"){
   	count_shares();
   }
   if(event.data == "pinterest"){
	void((function(d){var e=d.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src','//assets.pinterest.com/js/pinmarklet.js?r='+Math.random()*99999999);d.body.appendChild(e)})(document));
   }   
}

function create_button(t,n, url, title, button){
    currentButtonClicked = button;
    if(url !== undefined)
        sharedURL = encodeURIComponent(url);
    else
        sharedURL = encodeURIComponent(document.location.href);
    if(title !== undefined)
        sharedTitle = encodeURIComponent(title);
    else
        sharedTitle = encodeURIComponent(document.title);
        
    if(jQ14.browser.mobile){
	window.open("http://www.e-mailit.com/share/mobile.php?url="+sharedURL+"&title="+sharedTitle+"&UA_ID="+get_analytics);
	window.addEventListener("message", receiveMessage, false);
        return;
    }        
        
    update_social_services();
    var r=0;
    E_mailitDisplay(t);
    title_anal=t;
    overlay=jQ14('<div id="e_mailit_overlay"></div>');
    var i=jQ14("#e_mailit_overlay,#e_mailit_box");
    if(i.length>0){
        e_mailit_remove();
        return false
    }
    overlay=jQ14('<div id="e_mailit_overlay"></div>');
    var s=['<div id="e_mailit_box">','<div class="e_mailit_ads"><div id="footer_ads"><a href="http://www.e-mailit.com" target="_blank"><span id="logo_ads"> </span></a><span id="ads_here"><a href="http://www.e-mailit.com/advertise" target="_blank">About These Ads  <img src="http://www.e-mailit.com/widget/button/images/adsense-logo_10x10.png" alt="" title="" border=0 width=10 height=10></a></span></div></div>','<div class="e_mailit_button_body">','<div class="e_mailit_sharelogo"></div>','<div class="e_mailit_search"><div class="ui-widget"><input type="text" class="e_mailit_filterinput" size="10" maxlength="21"/></div></div>','<div class="e_mailit_close"></div>','<div class="e_mailit_wrapper">','<div class="e_mailit_bar_promotion">','<div class="e_mailit_promo_icon_open"></div>','<div class="e_mailit_promo_icon_close"></div>','<span class="e_mailit_promo">promo</span>',"</div>",'<div id="e_mailit_services">','<ul class="custom_list"></ul>','<ul class="all_list" style="display:none;"></ul>',"</div>",'<div class="e_mailit_all">','<div class="e_mailit_all_button"><div class="e_mailit_all_button_icon"></div> <div class="e_mailit_custom_button_icon" style="display:none"></div></div>',"</div>",'<div class="e_mailit_back_count_follow"></div>',"</div>",'<div id="e_mailit_footer_button"><div id="e_mailit_sponsor"><a href="javascript:if(typeof window.create_button == \'undefined\'){(function(){var b=document.createElement(\'script\');b.type=\'text/javascript\';b.async=true;b.src=\'http://www.e-mailit.com/widget/button/js/bookmarklet.js\';var c=document.getElementsByTagName(\'head\')[0];c.appendChild(b)})();}else{create_button(\'bm_share\',\'no\');}void(0);" onclick="return false;" class="get_bookmarklet" title="Drag this to your Bookmarks Bar.">Get your own button for your browser!</a></div><div id="e_mailit_sign"><a href="http://www.e-mailit.com/widget/login" target="_blank">Sign in</a></div></div></div>'];
    jQ14("body").append(s.join(""),overlay, '<div id="bookmarklet_explain" class=""><i class="icon-arrow-up"></i>Drag me into your Bookmarks Bar to quickly share any web page with friends.</div>');
    overlay.css({
        opacity:"0.8"
    });
    jQ14(".get_bookmarklet").hover(function() {
	  jQ14("#bookmarklet_explain").fadeToggle();
	});

    jQ14(".e_mailit_box").css("position","absolute");
    jQ14(".e_mailit_box").css("top",(jQ14(window).height()-jQ14(".e_mailit_box").height())/2+jQ14(window).scrollTop()+"px");
    jQ14(".e_mailit_box").css("left",(jQ14(window).width()-jQ14(".e_mailit_box").width())/2+jQ14(window).scrollLeft()+"px");
    if(n==="yes"){
        get_ads()
    }
    jQ14(".e_mailit_close,#e_mailit_overlay").click(function(){
        close_email=0;
        close_WordPress=0;
        jQ14("#e_mailit_overlay,#e_mailit_box").remove()
    });
    jQ14.expr[":"].Contains=function(e,t,n){
        return(e.textContent||e.innerText||"").toUpperCase().indexOf(n[3].toUpperCase())>=0
    };
        
    jQ14(".e_mailit_bar_promotion").click(function(){
        if(jQ14(".e_mailit_ads").css("display")=="block"){
            remove_iframe()
        }else{
            get_ads()
        }
    });
    jQ14(".e_mailit_all_button").click(function(){
    if(jQ14(".e_mailit_all_button_icon").css("display") == "block"){
        jQ14(".e_mailit_filterinput").removeAttr("value");
        jQ14(".e_mailit_services_list").find(".link_serv").parent().slideDown();
        jQ14(".custom_list").slideUp("fast");
        jQ14(".all_list").slideDown("fast");
        jQ14(".e_mailit_all_button_icon").slideUp("fast");
        jQ14(".e_mailit_custom_button_icon").slideDown("fast");
        jQ14("#e_mailit_services").css({
            overflow:"scroll",
            "overflow-y":"scroll",
            "overflow-x":"hidden"
        });
    }else{
        jQ14(".e_mailit_filterinput").removeAttr("value");
        jQ14(".e_mailit_services_list").find(".link_serv").parent().slideDown();
        jQ14(".all_list").slideUp("fast");
        jQ14(".custom_list").slideDown("fast");
        jQ14(".e_mailit_custom_button_icon").fadeOut("fast");
        jQ14(".e_mailit_all_button_icon").fadeIn("fast");
        jQ14("#e_mailit_services").css({
            overflow:"hidden"
        })
    }
    });

    jQ14(".e_mailit_filterinput").keyup(function(e){
        var t=jQ14(".e_mailit_filterinput").val();
        if(t===""||t.length<1){
            jQ14(".e_mailit_services_list").slideDown()
        }else{
            jQ14(".e_mailit_services_list").find(".link_serv:not(:Contains("+t+"))").parent().fadeOut(500);
            jQ14(".e_mailit_services_list").find(".link_serv:Contains("+t+")").parent().fadeIn(500)
        }
    });
    var o=def_services.split(",");
    for(var u=0;u<o.length;u++){
        if(def_services){
            var a=o[u];
            var f=a.replace(/_/gi," ");
            if(f=="G plus")f="Google+";
            var l=def_services_links[a];
            if(l!==undefined){
                l=l.replace(/{TITLE}/gi,eshare_title());
                l=l.replace(/{URL}/gi,eshare_url());
                l=l.replace(/{KEYWORDS}/gi,eshare_metakeywords());
                l=l.replace(/{DESCRIPTION}/gi,eshare_metadescription());
                var c="";
                if(f!="WordPress"){
                    c="_gaq.push(['emailit._trackEvent', 'E-MAILiT Share', '"+f+"', decodeURIComponent('"+sharedURL+"')]);";
                    if(get_analytics!==""){
                        c+="_gaq.push(['_trackEvent', 'E-MAILiT Share', '"+f+"', decodeURIComponent('"+sharedURL+"')]); "
                    }
                }
                if(f=="Email"){
                    var h='<li class="e_mailit_services_list"><a href="javascript:void(0)" class="link_serv" target="_blank" onclick="javascript:create_e_email(); count_shares();return false;"><div class="E_mailit_'+a+'"></div><span class="e_mailit_services_text">'+f+"</span></a></li>"
                }else if(f=="WordPress"){
                    var h='<li class="e_mailit_services_list"><a href="javascript:void(0)" class="link_serv" onclick="javascript:create_e_WordPress(); count_shares();return false;"><div class="E_mailit_'+a+'"></div><span class="e_mailit_services_text">'+f+"</span></a></li>"
                }else if(f=="Pinterest"){
                    var h='<li class="e_mailit_services_list"><a href="'+l+'"  class="link_serv" onclick="'+c+'count_shares();"><div class="E_mailit_'+a+'"></div><span class="e_mailit_services_text">'+f+"</span></a></li>"
                }else{
                    var h='<li class="e_mailit_services_list"><a href="'+l+'"  class="link_serv" target="_blank" onclick="'+c+'count_shares();"><div class="E_mailit_'+a+'"></div><span class="e_mailit_services_text">'+f+"</span></a></li>"
                }
                jQ14(h).appendTo(".all_list")
            }
        }
    }
    jQ14(share_services).appendTo(".custom_list");

    jQ14(follow_services).appendTo(".e_mailit_back_count_follow")
}

function count_shares(){
	if(jQ14(".e_mailit_ads").css("display")!="block")
		jQ14(".e_mailit_bar_promotion").click();

    var e=sharedURL;
    if(e.indexOf("#")!=-1)e=e.substr(0,e.indexOf("#"));
    jQ14.getJSON(("https:"==document.location.protocol?"https://www":"http://www")+".e-mailit.com/widget/button/php/counter.php?document_location="+e+"&jsoncallback=?",function(e){
        var closestCounter = jQ14(currentButtonClicked).parent().find(".e_mailit_counter_id");
        if(closestCounter){
            closestCounter.text(e.share_counter);
        }
    })
}
var jQ14;
var sharedURL;
var sharedTitle;
var emailit_email_data;
var emailit_email_iframe_url;
var share_services;
var share_services_new;
var follow_services;
var secondid;
var get_analytics;
var load_c;
var load_iframe;
var id_code;
var title_anal;
var close_ads=0;
var close_email=0;
var close_WordPress=0;
var currentButtonClicked;
var twitterVia = "EMAILiT";
if(!_gaq){
    secondid=""
}else{
    _gaq.push(function(){
        var e=_gat._getTrackerByName();
        var t=e._getAccount();
        secondid=t
    })
}
var _ga=_ga||{};

var _gaq=_gaq||[];
_gaq.push(["emailit._setAccount","UA-6640442-5"]);
_gaq.push(["emailit._trackPageview"]);

(function(){
    var e=document.createElement("script");
    e.type="text/javascript";
    e.async=true;
    e.src=("https:"==document.location.protocol?"https://":"http://")+"stats.g.doubleclick.net/dc.js";
    
    var t=document.getElementsByTagName("script")[0];
    t.parentNode.insertBefore(e,t)
})();


if(typeof e_mailit_config!=="undefined"){
    if(e_mailit_config["TwitterID"]!=="")
        twitterVia = e_mailit_config["TwitterID"];
}
var def_services="Adfty,Amazon,AOL_Mail,Arto,Baidu,Bitly,BizSugar,BlinkList,Blogger,Bloggy,Blogmarks,Blurpalicious,Bobrdobr,BonzoBox,Bookmarky,Bookmerken,Box,BuddyMarks,Buffer,Camyoo,Care2,Chiq,CiteULike,ClassicalPlace,Cndig,COSMiQ,Delicious,Digg,Diggita,Digo,Diigo,Douban,DZone,Email,Embarkons,Evernote,Fabulously40,Facebook,Fai_Informazione,Fark,FAVable,Favoriten,Favoritus,Folkd,Formspring,Foursquare,FriendFeed,funP,G_plus,GiveALink,Gmail,Good_Noows,Google,HTML_Validator,Identica,Instapaper,iWiW,Kaboodle,Kaevur,Kindle_It,LinkedIn,LiveJournal,LockerBlogger,Logger24,MailRu,Mashbord,Mendeley,Meneame,Mister_Wong,Moemesto,Myspace,N4G,Nasza_klasa,Netvouz,Newsvine,Nujij,Odnoklassniki,OKNOtizie,Wanelo,Outlook,PDF_Online,PDFmyURL,PhoneFavs,Pinterest,Pocket,Posteezy,PrintFriendly,Pusha,Quantcast,Qzone,Reddit,Rediff_MyPage,Sekoman,Sina_Weibo,Slashdot,SodaHead,Sonico,Startlap,Stuffpit,StumbleUpon,Stumpedia,Svejo,Symbaloo,Taringa,Technorati,The_Web_Blend,ThisNext,Transferr,Translate,Tuenti,Tumblr,Twitter,TypePad,Viadeo,Virb,VKontakte,Webnews,WhatsApp,Whois_Lookup,WordPress,Wykop,Xanga,Xing,Yahoo_Bookmarks,Yahoo_Mail,Yammer,Yardbarker,Yoolink,Zakladok,ZakladokNet";
var def_services_links = Array();
def_services_links.Amazon="http://www.amazon.com/gp/wishlist/static-add?u={URL}&t={TITLE}";
def_services_links.AOL_Mail="http://webmail.aol.com/25045/aol/en-us/Mail/compose-message.aspx?to=&subject={TITLE}&body={URL}";
def_services_links.Baidu="http://cang.baidu.com/do/add?it={TITLE}&iu={URL}&fr=ien&dc=";
def_services_links.Kindle_It="http://fivefilters.org/kindle-it/send.php?url={URL}&title={TITLE}";
def_services_links.Bitly="https://bitly.com/a/bitmarklet?u={URL}";
def_services_links.BizSugar="http://www.bizsugar.com/bizsugarthis.php?url={URL}";
def_services_links.BlinkList="http://www.blinklist.com/blink?u={URL}&t={TITLE}&d=";
def_services_links.Blogger="http://www.blogger.com/blog_this.pyra?t=&u={URL}&n={TITLE}";
def_services_links.Care2="http://www.care2.com/news/compose?sharehint=news&share[share_type]news&bookmarklet=Y&share[title]={TITLE}&share[link_url]={URL}&share[content]=";
def_services_links.CiteULike="http://www.citeulike.org/posturl?url={URL}&title={TITLE}";
def_services_links.PrintFriendly="http://www.printfriendly.com/print?url={URL}&title={TITLE}";
def_services_links.Buffer="http://bufferapp.com/add?url={URL}&title={TITLE}";
def_services_links.Instapaper="http://www.instapaper.com/edit?url={URL}&title={TITLE}&summary=";
def_services_links.Delicious="http://delicious.com/post?url={URL}&title={TITLE}&notes=";
def_services_links.Digg="http://digg.com/submit?partner=&url={URL}&title={TITLE}&bodytext=";
def_services_links.DZone="http://www.dzone.com/links/add.html?url={URL}&title={TITLE}&description=";
def_services_links.Email="mailto:?subject={TITLE}&body={URL}";
def_services_links.Evernote="http://www.evernote.com/clip.action?url={URL}&title={TITLE}";
def_services_links.Facebook="http://www.facebook.com/sharer.php?u={URL}&t={TITLE}";
def_services_links.Fark="http://www.fark.com/cgi/farkit.pl?u={URL}&h={TITLE}";
def_services_links.Favoritus="http://www.favoritus.com/post.php?lang=EN&gettitle={TITLE}&getlink={URL}";
def_services_links.FriendFeed="http://friendfeed.com/share?url={URL}&title={TITLE}";
def_services_links.Gmail="http://mail.google.com/mail/?view=cm&fs=1&to=&su={TITLE}&body={URL}&ui=1";
def_services_links.G_plus="https://plus.google.com/share?url={URL}&t={TITLE}";
def_services_links.Google="https://www.google.com/bookmarks/mark?op=add&bkmk={URL}&title={TITLE}&annotation=";
def_services_links.Translate="http://translate.google.com/translate?hl=en&u={URL}&tl=en&sl=auto";
def_services_links.Outlook="http://mail.live.com/default.aspx?rru=compose&subject={TITLE}&body={URL}";
def_services_links.MailRu="http://connect.mail.ru/login?connect=1&page=http://connect.mail.ru/share?share_url={URL}";
def_services_links.Identica="http://identi.ca/?action=newnotice&status_textarea=%E2%80%9C{TITLE}%E2%80%9d%3a%20{URL}";
def_services_links.LinkedIn="http://www.linkedin.com/shareArticle?mini=true&url={URL}&title={TITLE}&ro=false&summary=&source=";
def_services_links.LiveJournal="http://www.livejournal.com/update.bml?subject={TITLE}&event={URL}";
def_services_links.Meneame="http://www.meneame.net/submit.php?url={URL}";
def_services_links.Mister_Wong="http://www.mister-wong.com/index.php?action=addurl&bm_url={URL}&bm_description={TITLE}&bm_notice=";
def_services_links.OKNOtizie="http://oknotizie.virgilio.it/post?title={TITLE}&url={URL}";
def_services_links.Myspace="http://www.myspace.com/Modules/PostTo/Pages/?u={URL}&t={TITLE}&c=";
def_services_links.Mendeley="http://www.mendeley.com/import/?url={URL}&title={TITLE}";
def_services_links.Yammer="https://www.yammer.com/home/bookmarklet?bookmarklet_pop=1&u={URL}&t={TITLE}";
def_services_links.Netvouz="http://netvouz.com/action/submitBookmark?url={URL}&title={TITLE}&popup=no&description=";
def_services_links.Newsvine="http://www.newsvine.com/_tools/seed&save?u={URL}&h={TITLE}&s=";
def_services_links.Wanelo="http://wanelo.com/p/save?url={URL}&title={TITLE}";
def_services_links.Formspring="http://www.formspring.me/share?url={URL}&title={TITLE}";
def_services_links.FAVable="http://www.favable.com/oexchange?url={URL}&title={TITLE}&desc=";
def_services_links.Pinterest="javascript:void((function(d){var e=d.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src','//assets.pinterest.com/js/pinmarklet.js?r='+Math.random()*99999999);d.body.appendChild(e)})(document));";
def_services_links.Pocket="https://getpocket.com/save?url={URL}&title={TITLE}";
def_services_links.Reddit="http://www.reddit.com/submit?url={URL}/&title={TITLE}";
def_services_links.Sina_Weibo="http://v.t.sina.com.cn/share/share.php?url={URL}&title={TITLE}";
def_services_links.Slashdot="http://slashdot.org/submission?title={TITLE}&url={URL}&new=1";
def_services_links.Odnoklassniki="http://www.odnoklassniki.ru/dk?st.cmd=addShare&st.s=2&st.noresize=on&st._surl={URL}";
def_services_links.StumbleUpon="http://www.stumbleupon.com/submit?url={URL}&title={TITLE}";
def_services_links.Technorati="http://technorati.com/faves?add={URL}";
def_services_links.Tuenti="http://www.tuenti.com/share?url={URL}";
def_services_links.Tumblr="http://www.tumblr.com/share?v=3&u={URL}&t={TITLE}&s=";
def_services_links.Twitter="https://twitter.com/share?original_referer={URL} via @"+twitterVia+"&source=tweetbutton&text={TITLE}&url={URL}&via="+twitterVia+"&data-via="+twitterVia;
def_services_links.TypePad="http://www.typepad.com/services/quickpost/post?v=2&qp_show=ac&qp_title={TITLE}&qp_href={URL}&qp_text=";
def_services_links.VKontakte="http://vkontakte.ru/share.php?url={URL}&title={TITLE}&description=&image=";
def_services_links.WordPress="http://www.e-mailit.com/ext/wordpress/press_this/index.php?r={URL}&linkname={TITLE}&linknote=";
def_services_links.Xanga="http://www.xanga.com/private/editorplain.aspx?t={TITLE}&u={URL}";
def_services_links.Xing="https://www.xing.com/app/user?url={URL}&title={TITLE}&op=share";
def_services_links.Yahoo_Bookmarks="http://bookmarks.yahoo.com/toolbar/savebm?opener=tb&u={URL}&t={TITLE}&d=";
def_services_links.Yahoo_Mail="http://compose.mail.yahoo.com/?To=&Subject={TITLE}&Body={URL}";
def_services_links.Zakladok="http://www.100zakladok.ru/save/?bmurl={URL}&bmtitle={TITLE}";
def_services_links.Adfty="http://www.adfty.com/submit.php?url={URL}";
def_services_links.Arto="http://www.arto.com/section/linkshare/?lu={URL}&ln={TITLE}";
def_services_links.Bloggy="http://bloggy.se/home?status={TITLE}%20{URL}";
def_services_links.Blogmarks="http://blogmarks.net/my/new.php?mini=1&simple=1&url={URL}&title={TITLE}&content=";
def_services_links.Blurpalicious="http://www.blurpalicious.com/submit/?url={URL}&title={TITLE}&desc=";
def_services_links.Bobrdobr="http://bobrdobr.ru/addext.html?url={URL}&title={TITLE}&desc=";
def_services_links.BonzoBox="http://bonzobox.com/toolbar/add?u={URL}&t={TITLE}&desc=";
def_services_links.Bookmarky="http://www.bookmarky.cz/a.php?cmd=add&url={URL}&title={TITLE}";
def_services_links.Bookmerken="http://www.bookmerken.de/?url={URL}&title={TITLE}";
def_services_links.Box="https://www.box.net/api/1.0/import?import_as=link&url={URL}&name={TITLE}&description=";
def_services_links.BuddyMarks="http://buddymarks.com/add_bookmark.php?bookmark_title={TITLE}&bookmark_url={URL}&bookmark_desc=";
def_services_links.Camyoo="http://www.camyoo.com/note.html?url={URL}";
def_services_links.Chiq="http://chiq.com/create/affiliate?url={URL}&title={TITLE}&description=&c=1";
def_services_links.ClassicalPlace="http://www.classicalplace.com/?u={URL}&t={TITLE}&c=";
def_services_links.Cndig="http://www.cndig.org/submit/?url={URL}&title={TITLE}";
def_services_links.COSMiQ="http://www.cosmiq.de/lili/my/add?url={URL}";
def_services_links.Diggita="http://www.diggita.it/submit.php?url={URL}&title={TITLE}";
def_services_links.Digo="http://www.digo.it/submit?url={URL}&title={TITLE}";
def_services_links.Diigo="http://www.diigo.com/post?url={URL}&title={TITLE}&desc=";
def_services_links.Douban="http://www.douban.com/recommend/?url={URL}&title={TITLE}";
def_services_links.Embarkons="http://www.embarkons.com/sharer.php?u={URL}&t={TITLE}";
def_services_links.Fabulously40="http://fabulously40.com/writeblog?subject={TITLE}&body={URL}";
def_services_links.Fai_Informazione="http://fai.informazione.it/submit.aspx?url={URL}&title={TITLE}&desc=";
def_services_links.Favoriten="http://www.favoriten.de/url-hinzufuegen.html?bm_url={URL}&bm_title={TITLE}";
def_services_links.Folkd="http://www.folkd.com/submit/{URL}";
def_services_links.funP="http://funp.com/push/submit/?url={URL}";
def_services_links.GiveALink="http://givealink.org/bookmark/add?url={URL}&title={TITLE}";
def_services_links.Good_Noows="http://goodnoows.com/add/?url={URL}";
def_services_links.HTML_Validator="http://validator.w3.org/check?uri={URL}&charset=%28detect+automatically%29&doctype=Inline&group=0";
def_services_links.iWiW="http://iwiw.hu/pages/share/share.jsp?v=1&u={URL}&t={TITLE}";
def_services_links.Kaboodle="http://www.kaboodle.com/grab/addItemWithUrl?url={URL}&pidOrRid=pid=&redirectToKPage=true";
def_services_links.Kaevur="http://kaevur.com/submit.php?url={URL}";
def_services_links.LockerBlogger="http://www.lockerblogger.com/share.php?url={URL}&title={TITLE}&desc=";
def_services_links.Logger24="http://logger24.com/?url={URL}";
def_services_links.Mashbord="http://mashbord.com/plugin-add-bookmark?url={URL}";
def_services_links.Moemesto="http://moemesto.ru/post.php?url={URL}&title={TITLE}";
def_services_links.N4G="http://www.n4g.com/tips.aspx?url={URL}&title={TITLE}";
def_services_links.Nasza_klasa="http://nk.pl/sledzik?shout={URL}";
def_services_links.Nujij="http://nujij.nl/jij.lynkx?u={URL}&t={TITLE}&b=";
def_services_links.PDF_Online="http://savepageaspdf.pdfonline.com/pdfonline/pdfonline.asp?cURL={URL}";
def_services_links.PDFmyURL="http://pdfmyurl.com?url={URL}";
def_services_links.PhoneFavs="http://phonefavs.com/bookmarks?action=add&address={URL}&title={TITLE}";
def_services_links.Posteezy="http://posteezy.com/node/add/story?title={TITLE}&body={URL}";
def_services_links.Pusha="http://www.pusha.se/posta?url={URL}&title={TITLE}&description=";
def_services_links.Quantcast="http://www.quantcast.com/{URL}";
def_services_links.Qzone="http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url={URL}";
def_services_links.Rediff_MyPage="http://share.rediff.com/bookmark/addbookmark?title={TITLE}&bookmarkurl={URL}";
def_services_links.Sekoman="http://sekoman.lv/home?status={TITLE}&url={URL}";
def_services_links.SodaHead="http://www.sodahead.com/news/submit/?url={URL}&title={TITLE}";
def_services_links.Sonico="http://www.sonico.com/share.php?url={URL}&title={TITLE}";
def_services_links.Startlap="http://www.startlap.hu/sajat_linkek/addlink.php?url={URL}&title={TITLE}";
def_services_links.Stuffpit="http://www.stuffpit.com/add.php?produrl={URL}";
def_services_links.Stumpedia="http://www.stumpedia.com/submit?url={URL}";
def_services_links.Svejo="http://svejo.net/story/submit_by_url?url={URL}&title={TITLE}&summary=";
def_services_links.Symbaloo="http://www.symbaloo.com/en/add/?url={URL}&title={TITLE}";
def_services_links.Taringa="http://www.taringa.net/widgets/share.php?url={URL}";
def_services_links.The_Web_Blend="http://thewebblend.com/submit?url={URL}&title={TITLE}";
def_services_links.ThisNext="http://www.thisnext.com/pick/new/submit/url/?description=&name={TITLE}&url={URL}";
def_services_links.Transferr="http://www.transferr.com/link.php?url={URL}";
def_services_links.Viadeo="http://www.viadeo.com/shareit/share/?url={URL}&title={TITLE}&urlaffiliate=32005&encoding=UTF-8";
def_services_links.Virb="http://virb.com/share?external&v=2&url={URL}&title={TITLE}";
def_services_links.Webnews="http://www.webnews.de/einstellen?url={URL}&title={TITLE}";
def_services_links.Whois_Lookup="http://www.domaintools.com/go/?service=whois&q={URL}";
def_services_links.Wykop="http://www.wykop.pl/dodaj?url={URL}&title={TITLE}&desc=";
def_services_links.Yardbarker="http://www.yardbarker.com/author/new/?pUrl={URL}&pHead={TITLE}";
def_services_links.Yoolink="http://go.yoolink.to/addorshare?url_value={URL}&title={TITLE}";
def_services_links.ZakladokNet="http://zakladok.net/link/?u={URL}&t={TITLE}";
def_services_links.WhatsApp="whatsapp://send?text={URL}";
def_services_links.Foursquare="https://foursquare.com/intent/login?continue=/intent/venue.html?url={URL}&fl=true";

var eshare_keywords;
var eshare_description;
var css_button=document.createElement("link");
css_button.href=("https:"==document.location.protocol?"https://www":"http://www")+".e-mailit.com/widget/button/css/button.css";
css_button.rel="stylesheet";
css_button.type="text/css";
document.getElementsByTagName("head")[0].appendChild(css_button);
var css_services=document.createElement("link");
css_services.href=("https:"==document.location.protocol?"https://www":"http://www")+".e-mailit.com/widget/button/css/services.css";
css_services.rel="stylesheet";
css_services.type="text/css";
document.getElementsByTagName("head")[0].appendChild(css_services);
var _qevents = _qevents || [];
var v="1.4";
var done=false;
var script=document.createElement("script");
script.src=("https:"==document.location.protocol?"https://":"http://")+"ajax.googleapis.com/ajax/libs/jquery/"+v+"/jquery.min.js";
script.onload=script.onreadystatechange=function(){
    if(!done&&(!this.readyState||this.readyState=="loaded"||this.readyState=="complete")){
		(function(a){a.fn.iframeTracker=function(b){a.iframeTracker.handlersList.push(b);a(this).bind("mouseover",{handler:b},function(d){d.data.handler.over=true;try{d.data.handler.overCallback(this)}catch(c){}}).bind("mouseout",{handler:b},function(d){d.data.handler.over=false;try{d.data.handler.outCallback(this)}catch(c){}})};a.iframeTracker={focusRetriever:null,focusRetrieved:false,handlersList:[],isIE8AndOlder:false,init:function(){try{if(a.browser.msie==true&&a.browser.version<9){this.isIE8AndOlder=true}}catch(b){try{var d=navigator.userAgent.match(/(msie) ([\w.]+)/i);if(d[2]<9){this.isIE8AndOlder=true}}catch(c){}}a(window).focus();a(window).blur(function(f){a.iframeTracker.windowLoseFocus(f)});a("body").append('<div style="position:fixed; top:0; left:0; overflow:hidden;"><input style="position:absolute; left:-300px;" type="text" value="" id="focus_retriever" /></div>');this.focusRetriever=a("#focus_retriever");this.focusRetrieved=false;a(document).mousemove(function(f){if(document.activeElement.tagName=="IFRAME"){a.iframeTracker.focusRetriever.focus();a.iframeTracker.focusRetrieved=true}});if(this.isIE8AndOlder){this.focusRetriever.blur(function(f){f.stopPropagation();f.preventDefault();a.iframeTracker.windowLoseFocus(f)})}if(this.isIE8AndOlder){a("body").click(function(f){a(window).focus()});a("form").click(function(f){f.stopPropagation()})}},windowLoseFocus:function(d){for(var c in this.handlersList){if(this.handlersList[c].over==true){try{this.handlersList[c].blurCallback()}catch(b){}}}}};a(document).ready(function(){a.iframeTracker.init()})})(jQuery);	
        jQ14=jQuery.noConflict(true);
        (function(a){(jQ14.browser=jQ14.browser||{}).mobile=/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))})(navigator.userAgent||navigator.vendor||window.opera);
		(function() {
			var elem = document.createElement('script');
			elem.src = (document.location.protocol == "https:" ? "https://secure" : "http://edge") + ".quantserve.com/quant.js";
			elem.async = true;
			elem.type = "text/javascript";
			var scpt = document.getElementsByTagName('script')[0];
			scpt.parentNode.insertBefore(elem, scpt);
		})();
		_qevents.push({
		qacct:"p-kMqmfYc11Gn7T"
		});        
		jQ14('body').append('<noscript><div style="display:none;"><img src="//pixel.quantserve.com/pixel/p-kMqmfYc11Gn7T.gif" border="0" height="1" width="1" alt="Quantcast"/></div></noscript>');
        done=true;
        jQ14( document ).ready(function() {
	        e_mailit();
			if(typeof window.emailit_bookmarklet !== 'undefined'){
				create_button('bm_share','no');
			}
        });
    }
};

document.getElementsByTagName("head")[0].appendChild(script);

function getLocale()
{
	var lang = navigator.language || navigator.userLanguage; 
    var locs =  new Array('af_ZA','sq_AL','ar_AR','hy_AM','ay_BO','az_AZ','eu_ES','be_BY','bn_IN','bs_BA','bg_BG','ca_ES','ck_US','hr_HR','cs_CZ','da_DK','nl_NL','nl_BE','en_PI','en_GB','en_UD','en_US',
    'eo_EO','et_EE','fo_FO','tl_PH','fi_FI','fb_FI','fr_CA','fr_FR','gl_ES','ka_GE','de_DE','el_GR','gn_PY','gu_IN','he_IL','hi_IN','hu_HU','is_IS','id_ID','ga_IE','it_IT','ja_JP','jv_ID','kn_IN','kk_KZ',
    'km_KH','tl_ST','ko_KR','ku_TR','la_VA','lv_LV','fb_LT','li_NL','lt_LT','mk_MK','mg_MG','ms_MY','ml_IN','mt_MT','mr_IN','mn_MN','ne_NP','se_NO','nb_NO','nn_NO','ps_AF','fa_IR','pl_PL','pt_BR','pt_PT','pa_IN',
    'qu_PE','ro_RO','rm_CH','ru_RU','sa_IN','sr_RS','zh_CN','sk_SK','sl_SI','so_SO','es_LA','es_CL','es_CO','es_MX','es_ES','es_VE','sw_KE','sv_SE','sy_SY','tg_TJ','ta_IN','tt_RU','te_IN','th_TH','zh_HK','zh_TW',
    'tr_TR','uk_UA','ur_PK','uz_UZ','vi_VN','cy_GB','xh_ZA','yi_DE','zu_ZA');
	for(i = 0; i < locs.length; i++){
		var locale = locs[i];
		if(locale.indexOf(lang) == 0)
		    return locale;
	}
    return 'en_US';
}