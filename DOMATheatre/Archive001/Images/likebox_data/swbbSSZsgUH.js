/*1314585157,176820662*/

if (window.CavalryLogger) { CavalryLogger.start_js(["KQ3gR"]); }

function ConnectSocialWidget(a,b){ConnectSocialWidget.setInstance(b,this);ConnectSocialWidget.delayUntilDisplayed(function(){this.initializeObject.call(this,a,b);}.bind(this));}copy_properties(ConnectSocialWidget,{OPT_IN_FACEBOOK_APP_ID:'127760087237610',TYPE_ACTIVITY:'A',TYPE_RECOMMENDATIONS:'R',TYPE_LIKEBOX:'L',instances:{},setInstance:function(b,a){ConnectSocialWidget.instances[b]=a;},getInstance:function(a){return ConnectSocialWidget.instances[a];},popups:{},login:function(a,b){ConnectSocialWidget.popups[b]={popup:PlatformOptInPopup.open('login','opt.in')};},aDelayedFunctions:[],delayUntilDisplayed:function(a){ConnectSocialWidget.aDelayedFunctions.push(a);if(ConnectSocialWidget.aDelayedFunctions.length===1){if(!ConnectSocialWidget.ndTestDim){var b=document.createElement('div'),c={position:'absolute',width:'1px',height:'1px',overflow:'hidden',top:'0px'};for(var d in c)if(typeof c[d]==='string')CSS.setStyle(b,d,c[d]);document.body.appendChild(b);ConnectSocialWidget.ndTestDim=b;}ConnectSocialWidget.testForDisplay();}},testForDisplay:function(){var a=Vector2.getElementDimensions(ConnectSocialWidget.ndTestDim).y;if(a!==0){ConnectSocialWidget.aDelayedFunctions.forEach(function(b){b();});ConnectSocialWidget.aDelayedFunctions=[];}else ConnectSocialWidget.testForDisplay.defer(100);},listenForLogin:function(){if(!ConnectSocialWidget.listenerAttached){Arbiter.subscribe('platform/socialplugins/login',function(a){if(a.user!==Env.user)document.location.reload();});ConnectSocialWidget.listenerAttached=true;}}});copy_properties(ConnectSocialWidget.prototype,{initializeObject:function(e,g){var d=DOM.scry(document.body,e.sOverflowContainerSelector)[0],c=DOM.scry(d,'.fbConnectWidgetFooter')[0],a=c?Vector2.getElementDimensions(c).y:0,f=e.sOverflowItemsSelector,b=DOM.scry(document.body,e.sStreamContainerSelector)[0];this.fRemoveOverflowElements=this.removeOverflowElements.bind(this,d,b,f,-a);copy_properties(this,{bInitialized:true,sWidgetId:g,iFooterHeight:a,ndTop:d,ndFooter:c,ndContentContainer:b,oQueryParams:new URI(window.location.href).getQueryData(),bComboMode:e.bComboMode,sOverflowItemsSelector:f});copy_properties(this.oQueryParams,{post_form_id:Env.post_form_id,user:Env.user});this.fRemoveOverflowElements();CSS.setStyle(b,'visibility','visible');animation(b).from('opacity',0).to('opacity',1).duration(200).go();ConnectSocialWidget.listenForLogin();new ClickThroughMonitor({ndTop:this.ndContentContainer,fValidateLink:this.getElementTop.bind(this),fGetMonitorData:function(h){var i={site:this.oQueryParams.site,type:this.getLinkType(),plugin:this.getPluginType(),social:(DOM.scry(h,'^div.fbSocial').length>0),pos:this.getItemPosition(this.getElementTop(h)),signature:this.getItemSignature(this.getElementTop(h))};if(this.oQueryParams.api_key)i.api_key=this.oQueryParams.api_key;return i;}.bind(this)});},getElementTop:function(b){var a=DOM.scry(b,'^'+this.sOverflowItemsSelector);return a[0];},getItemPosition:function(d){var a=DOM.scry(this.ndContentContainer,this.sOverflowItemsSelector),c=a.length,b=a.indexOf(d)+1;return b+'/'+c;},getItemSignature:function(c){var a=c.className.split(' ');for(var b=0;b<a.length;b++)if(a[b].startsWith("RES_"))return a[b].substring(4);return '';},removeOverflowElements:function(h,g,i,d,e){var f,a=i?DOM.scry(g,i):$A(g.childNodes);if(!e){var d=d||0,b=Vector2.getElementDimensions(h).y+d,c=Vector2.getElementPosition(h).y;e=b+c;}while(a.length>0&&(f=$(a.pop()))&&(Vector2.getElementDimensions(f).y+Vector2.getElementPosition(f).y)>e)DOM.remove(f);},login:function(){ConnectSocialWidget.login(this.appID,this.sWidgetId);},toggleLogin:function(){DOM.scry(this.ndTop,'.fbToggleLogin').forEach(function(a){CSS.toggle(a);});this.fRemoveOverflowElements();}});function ActivityWidget(a,b){this.parent.construct(this,a,b);}Class.extend(ActivityWidget,'ConnectSocialWidget');ActivityWidget.REQUEST_INTERVAL=15*1000;ActivityWidget.ACTIVITY_HEIGHT=45;ActivityWidget.MAX_INTERVAL=30;ActivityWidget.MAX_ITEMS=24;copy_properties(ActivityWidget.prototype,{initializeObject:function(a,b){this.parent.initializeObject.call(this,a,b);this.oQueryParams.nb_activities=Math.min(ActivityWidget.MAX_ITEMS,Math.round((this.oQueryParams.height||300)/ActivityWidget.ACTIVITY_HEIGHT));this.oQueryParams.newest=a.iNewestStoryTime||0;},getLinkType:function(){return ConnectSocialWidget.TYPE_ACTIVITY;},getPluginType:function(){return ConnectSocialWidget.TYPE_ACTIVITY;},removeOverflowElements:function(){if(this.bComboMode&&!this.bFirstRound){this.bFirstRound=true;var d=Vector2.getElementPosition(this.ndTop).y,b=Vector2.getElementDimensions(document.body).y-(d+this.iFooterHeight),c=Math.round(b/2),a=$A(arguments);a[a.length]=c;ConnectSocialWidget.prototype.removeOverflowElements.apply(this,a);}else ConnectSocialWidget.prototype.removeOverflowElements.apply(this,arguments);},hasFriendsActivity:function(){return DOM.scry(this.ndContentContainer,'div.fbFriendsActivity')[0].childNodes.length>0;},hasContent:function(){return DOM.scry(this.ndTop,this.sOverflowItemsSelector).length>0;},getEmptyMessage:function(){return DOM.find(this.ndContentContainer,'div.fbEmptyWidget');},showEmptyMessage:function(){var a=this.getEmptyMessage();if(a)CSS.show(a);}});function RecommendationsWidget(a,b){this.parent.construct(this,a,b);}Class.extend(RecommendationsWidget,'ConnectSocialWidget');copy_properties(RecommendationsWidget.prototype,{getLinkType:function(){return ConnectSocialWidget.TYPE_RECOMMENDATIONS;},getPluginType:function(){return this.sActivityParent?ConnectSocialWidget.TYPE_ACTIVITY:ConnectSocialWidget.TYPE_RECOMMENDATIONS;},initializeObject:function(a,b){this.parent.initializeObject.call(this,a,b);this.sActivityParent=a.sActivityParent;this.cropImages(DOM.scry(this.ndContentContainer,".fbImageContainer img"),RecommendationsWidget.IMAGE_HEIGHT,true);this.cropImages(DOM.scry(this.ndContentContainer,"img.fbGalleryImage"),RecommendationsWidget.GALLERY_IMAGE_HEIGHT,false);},cropImages:function(a,d,b){if(a.length>0){var c=function(event){RecommendationsWidget.image_resize({image:event.getTarget(),dimension:d,centerimage:b});};a.forEach(function(e){if(e.complete){RecommendationsWidget.image_resize({image:e,dimension:d,centerimage:b});}else Event.listen(e,'load',c);});}},hasContent:function(){return this.ndContentContainer.childNodes.length>0;},getParent:function(){if(this.sActivityParent)return ConnectSocialWidget.getInstance(this.sActivityParent);},showRecommendationsSeparator:function(){var b=this.getParent();if(b&&b.hasContent()){var a=DOM.scry(this.ndTop,'div.fbRecommendationsSeparator')[0];CSS.show(a);CSS.setStyle(a,'visibility','visible');}return this;},removeOverflowElements:function(){ConnectSocialWidget.prototype.removeOverflowElements.apply(this,arguments);if(this.sActivityParent&&!this.hasContent()){var a=DOM.scry(this.ndTop,'div.fbRecommendationsSeparator')[0];CSS.hide(a);}}});RecommendationsWidget.IMAGE_HEIGHT=35;RecommendationsWidget.GALLERY_IMAGE_HEIGHT=105;function LikeBoxWidget(a,b){this.parent.construct(this,a,b);}Class.extend(LikeBoxWidget,'ConnectSocialWidget');copy_properties(LikeBoxWidget.prototype,{getLinkType:function(){return ConnectSocialWdiget.TYPE_LIKEBOX;},getPluginType:function(){return ConnectSocialWidget.TYPE_LIKEBOX;}});RecommendationsWidget.image_resize=function(l){var j=l.image,k=Vector2.getElementDimensions(j),c=k.y,i=k.x,g=l.dimension,m=g+'px',a=l.centerimage;if(c<=5||i<=5)return;var f=c/i;if(f<.5||f>2)return;if(c===i){CSS.setStyle(j,'width',m);}else if(c<i){var e=g/c,d=-Math.round((i-c)*e/2);CSS.setStyle(j,'height',m);a&&CSS.setStyle(j,'marginLeft',d+'px');}else{var e=g/i,h=-Math.round((c-i)*e/2);CSS.setStyle(j,'width',m);a&&CSS.setStyle(j,'marginTop',h+'px');}CSS.setStyle(j,'visibility','visible');CSS.setStyle(j.parentNode,'background','transparent');var b=Parent.byClass(j,'fbRecommendation');if(b)CSS.removeClass(b,'invisible_elem');};ClickThroughMonitor=function(a){copy_properties(this,{ndTop:a.ndTop||document.body,fValidateLink:a.fValidateLink||function(){return true;},fGetMonitorData:a.fGetMonitorData||function(){return {};}});Event.listen(this.ndTop,'mousedown',this.onMouseDown.bind(this));};ClickThroughMonitor.CALL_BACK_SOCIAL_PLUGINS=2;copy_properties(ClickThroughMonitor.prototype,{getMonitoredLink:function(event){var a=event.getTarget(),b=Parent.byTag(a,'a');if(b&&CSS.hasClass(b,'fbMonitor')&&this.fValidateLink(b)){return b;}else return null;},getMonitorData:function(a){var b=this.fGetMonitorData(a);if(document.referrer!=='')b.referrer=document.referrer;b.cb=ClickThroughMonitor.CALL_BACK_SOCIAL_PLUGINS;return b;},onMouseDown:function(event){var a=this.getMonitoredLink(event);if(a)UntrustedLink.bootstrap(a,Env.lhsh,event,this.getMonitorData.bind(this));}});
function fbpage_set_fan_status(c,f,a,h,g,d,e){g=g?g:function(j){_fbpage_show_change_status_feedback(c,j.getPayload());};var b={fbpage_id:f,add:a,reload:h};if(e!=null)copy_properties(b,e);var i=new AsyncRequest().setURI('/ajax/pages/fan_status.php').setData(b).setNectarModuleDataSafe(c).setHandler(g);if(d)i.setErrorHandler(d);i.send();return false;}function fbpage_set_favorite_status(d,e,a){var f=function(){_fbpage_show_change_status_feedback(d,this.getUserData());};var c={fbpage_id:e,add:a};var b=new AsyncRequest().setMethod('POST').setURI('/ajax/pages/favorite_status.php').setData(c);new Dialog().setAsync(b).setCloseHandler(f).show();return false;}function _fbpage_show_change_status_feedback(b,a){if(!a||!b)return;if(a.reload){fbpage_reload_on_fan_status_changed(a.preserve_tab);}else fbpage_redraw_on_fan_status_changed(b,a.feedback);}function fbpage_reload_on_fan_status_changed(a){var c=URI.getRequestURI();if(a){var b=window.FutureSideNav?FutureSideNav.getInstance().selected.textKey:Arbiter.query('SideNav.selectedKey');if(!c.getQueryData().sk&&b)c.addQueryData({sk:b});}window.location.href=c;}function fbpage_redraw_on_fan_status_changed(a,b){if(!b)return;var d=document.createElement('span');d.innerHTML=b;CSS.setClass(d,'fan_status_inactive');a.parentNode.replaceChild(d,a);var c=function(){if(data.can_repeat_action)d.parentNode.replaceChild(a,d);};animation(d).duration(3000).checkpoint().to('backgroundColor','#FFFFFF').duration(1000).ondone(c).go();}
function ConnectWidget(h,f,a,e,b){copy_properties(this,{channel_url:b,like_mode:e,profile_id:f,viewer_id:h,status:null,popup:null,busy:false,new_fan:null,user_profile:null});this.fan_hidden=[];this.fan_shown=[];var c=DOM.scry(document,'div.connections');if(c.length>0){c=c[0];this.user_profile=DOM.find(c,'div.user_profile');this.new_fan=DOM.find(c,'div.grid_item_plus');this.fan_shown.push(this.new_fan);this.fan_shown.push(DOM.find(c,'span.total_plus'));var g=DOM.scry(c,'span.total');var d=DOM.scry(c,'div.grid_item');if(d.length>1)this.fan_hidden.push(d[1]);this.fan_hidden.push(g[g.length-1]);}if(!this.like_mode){this.button=$(a);this.popup_uri=new URI('/login.php');this.popup_uri.addQueryData({connect_id:this.profile_id,popup:true});Event.listen(this.button,'click',this.connectClickHandler.bind(this));}else Arbiter.subscribe('platform/like/connection',this.updateWidgetFromLike.bind(this));ConnectWidget.instances[a]=this;if(this.channel_url)XD.init({channelUrl:this.channel_url});}ConnectWidget.instances={};ConnectWidget.is_connect=true;ConnectWidget.prototype.setLoggedIn=function(a){this.viewer_id=a;return this;};ConnectWidget.prototype.connectClickHandler=function(a){a.kill();if(this.viewer_id!=0){this.connect();}else this.popUpLogin();};ConnectWidget.prototype.connect=function(){if(!this.busy){this.busy=true;fbpage_set_fan_status(this.button,this.profile_id,true,false,this.connectDoneHandler.bind(this),this.connectErrorHandler.bind(this),this.getAsyncData());}};ConnectWidget.prototype.disconnect=function(){if(!this.busy){this.busy=true;fbpage_set_fan_status(this.button,this.profile_id,false,false,this.connectUndoneHandler.bind(this),function(){},this.getAsyncData());}};ConnectWidget.prototype.getAsyncData=function(){var a={source:'connect',is_connect:ConnectWidget.is_connect};if(ge('post_form_id'))a.post_form_id=$('post_form_id').value;if(env_get('fb_dtsg'))a.fb_dtsg=env_get('fb_dtsg');return a;};ConnectWidget.prototype.popUpLogin=function(){window.open(this.popup_uri.toString(),'_blank','toolbar=0,status=0,width=626,height=400');};ConnectWidget.prototype.updateWidgetFromLike=function(b,f){if(!f.userProfile)return;if(this.user_profile){var c=DOM.find(this.user_profile,'img');var a=DOM.find(this.user_profile,'a');var e=DOM.find(this.user_profile,'div.name');c.src=f.userProfile.pic_square;a.href=f.userProfile.profile_url;DOM.setContent(e,f.userProfile.name);}var d;if(f.nowConnected){d='likeboxLiked';this.showNewFan();}else{d='likeboxUnliked';this.hideNewFan();}if(this.channel_url)XD.send({type:d});};ConnectWidget.prototype.connectErrorHandler=function(b){if(b.error==1357001){this.viewer_id=0;this.popUpLogin();}else if(b.error==1357013){CSS.hide(this.button);var a=$N('a',{href:DOM.find(document,'div.name_block a').href,target:'_blank'},_tx("Verification is needed to connect."));this.status=$N('span',{className:'connect_span'},a);DOM.insertAfter(this.button,this.status);}else{CSS.hide(this.button);if(b.error==1431001){this.status=$N('span',{className:'connect_span'},_tx("You like this."));}else this.status=$N('span',{className:'connect_span'},b.getErrorSummary()+': '+b.getErrorDescription());animation(this.status).from('opacity',0).to('opacity',1).go();DOM.insertAfter(this.button,this.status);}this.busy=false;};ConnectWidget.prototype.connectDoneHandler=function(c){var b=c.getPayload();if(!b||!b.feedback)return;this.status=$N('span',{className:'connect_span'},HTML(b.feedback));var d=$N('a',{className:'undo'},_tx("Undo"));Event.listen(d,'click',function(e){e.kill();this.disconnect();}.bind(this));DOM.appendContent(this.status,d);animation(this.status).from('opacity',0).to('opacity',1).go();DOM.insertAfter(this.button,this.status);CSS.hide(this.button);if(this.new_fan!=null&&b.connect_fan_div){var a=$N('div',{},HTML(b.connect_fan_div));DOM.setContent(this.new_fan,DOM.find(a,'a'));}this.showNewFan();this.busy=false;};ConnectWidget.prototype.showNewFan=function(){this.fan_shown.forEach(function(b){if(!CSS.hasClass(b,'hidden_elem'))return;var a=CSS.getStyle(b,'width');CSS.setStyle(b,'width',0);CSS.setStyle(b,'opacity',0);CSS.show(b);animation(b).to('width',a).duration(100).checkpoint().to('opacity',1).duration(400).go();});this.fan_hidden.forEach(function(a){CSS.hide(a);});};ConnectWidget.prototype.connectUndoneHandler=function(b){var a=b.getPayload();DOM.remove(this.status);animation(this.button).from('opacity',0).to('opacity',1).go();CSS.show(this.button);this.hideNewFan();this.busy=false;};ConnectWidget.prototype.hideNewFan=function(){this.fan_shown.forEach(function(a){if(CSS.hasClass(a,'hidden_elem'))return;animation(a).to('opacity',0).duration(100).checkpoint(.25).to('width',0).duration(100).ondone(function(){CSS.setStyle(a,'width',null);CSS.hide(a);this.fan_hidden.forEach(function(b){CSS.show(b);});}.bind(this)).go();}.bind(this));};ConnectWidget.loadStream=function(c,a,b){new AsyncRequest().setMethod('GET').setURI('/ajax/connect/connect_widget.php').setData({id:c,uniqid:a,force_wall:b}).setReadOnly(true).setErrorHandler(bagofholding).send();};ConnectWidget.loggedIn=function(c,a){if(ge('post_form_id')){DOM.replace($('post_form_id'),HTML(a));}else DOM.appendContent(DOM.find(document,'body'),HTML(a));for(var b in ConnectWidget.instances){ConnectWidget.instances[b].setLoggedIn(c);ConnectWidget.instances[b].connect();}};ConnectWidget.setIsConnect=function(a){ConnectWidget.is_connect=a;};
var PlaceActionLink={start_claim_link:function(b){var a=new AsyncRequest().setMethod('POST').setURI('/ajax/places/claim/start_claim.php').setData({id:b});new Dialog().setAsync(a).show();return false;},refer_claim_link:function(b){var a=new AsyncRequest().setMethod('POST').setURI('/ajax/places/claim/refer_claim.php').setData({id:b});new Dialog().setAsync(a).show();return false;}};