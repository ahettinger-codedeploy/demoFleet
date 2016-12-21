/*1343092633,169775815*/

if (window.CavalryLogger) { CavalryLogger.start_js(["5YjJS"]); }

function ConnectWidget(a,b,c,d,e){copyProperties(this,{channel_url:e,like_mode:d,profile_id:b,viewer_id:a,status:null,popup:null,busy:false,new_fan:null,user_profile:null});this.fan_hidden=[];this.fan_shown=[];var f=DOM.scry(document,'div.connections');if(f.length>0){f=f[0];this.user_profile=DOM.find(f,'div.user_profile');this.new_fan=DOM.find(f,'div.grid_item_plus');this.fan_shown.push(this.new_fan);this.fan_shown.push(DOM.find(f,'span.total_plus'));var g=DOM.scry(f,'span.total'),h=DOM.scry(f,'div.grid_item');if(h.length>1)this.fan_hidden.push(h[1]);this.fan_hidden.push(g[g.length-1]);}if(!this.like_mode){this.button=$(c);this.popup_uri=new URI('/login.php');this.popup_uri.addQueryData({connect_id:this.profile_id,popup:true});Event.listen(this.button,'click',this.connectClickHandler.bind(this));}else Arbiter.subscribe('platform/like/connection',this.updateWidgetFromLike.bind(this));ConnectWidget.instances[c]=this;if(this.channel_url)XD.init({channelUrl:this.channel_url});}ConnectWidget.instances={};ConnectWidget.is_connect=true;ConnectWidget.prototype.setLoggedIn=function(a){this.viewer_id=a;return this;};ConnectWidget.prototype.connectClickHandler=function(a){a.kill();if(this.viewer_id!=0){this.connect();}else this.popUpLogin();};ConnectWidget.prototype.connect=function(){if(!this.busy){this.busy=true;fbpage_set_fan_status(this.button,this.profile_id,true,false,this.connectDoneHandler.bind(this),this.connectErrorHandler.bind(this),this.getAsyncData());}};ConnectWidget.prototype.disconnect=function(){if(!this.busy){this.busy=true;fbpage_set_fan_status(this.button,this.profile_id,false,false,this.connectUndoneHandler.bind(this),function(){},this.getAsyncData());}};ConnectWidget.prototype.getAsyncData=function(){var a={source:'connect',is_connect:ConnectWidget.is_connect,fan_origin:'external_connect'};if(Env.fb_dtsg)a.fb_dtsg=Env.fb_dtsg;return a;};ConnectWidget.prototype.popUpLogin=function(){window.open(this.popup_uri.toString(),'_blank','toolbar=0,status=0,width=626,height=400');};ConnectWidget.prototype.updateWidgetFromLike=function(a,b){if(!b.userProfile)return;if(this.user_profile){var c=DOM.find(this.user_profile,'img'),d=DOM.find(this.user_profile,'a'),e=DOM.find(this.user_profile,'div.name');c.src=b.userProfile.pic_square;d.href=b.userProfile.profile_url;DOM.setContent(e,b.userProfile.name);}var f;if(b.nowConnected){f='likeboxLiked';this.showNewFan();}else{f='likeboxUnliked';this.hideNewFan();}if(this.channel_url)XD.send({type:f});};ConnectWidget.prototype.connectErrorHandler=function(a){if(a.error==1357001){this.viewer_id=0;this.popUpLogin();}else if(a.error==1357013){CSS.hide(this.button);var b=DOM.create('a',{href:DOM.find(document,'div.name_block a').href,target:'_blank'},"Verification is needed to connect.");this.status=DOM.create('span',{className:'connect_span'},b);DOM.insertAfter(this.button,this.status);}else{CSS.hide(this.button);if(a.error==1431001){this.status=DOM.create('span',{className:'connect_span'},"You like this.");}else this.status=DOM.create('span',{className:'connect_span'},a.getErrorSummary()+': '+a.getErrorDescription());animation(this.status).from('opacity',0).to('opacity',1).go();DOM.insertAfter(this.button,this.status);}this.busy=false;};ConnectWidget.prototype.connectDoneHandler=function(a){var b=a.getPayload();if(!b||!b.feedback)return;this.status=DOM.create('span',{className:'connect_span'},HTML(b.feedback));var c=DOM.create('a',{className:'undo'},"Undo");Event.listen(c,'click',function(e){e.kill();this.disconnect();}.bind(this));DOM.appendContent(this.status,c);animation(this.status).from('opacity',0).to('opacity',1).go();DOM.insertAfter(this.button,this.status);CSS.hide(this.button);if(this.new_fan!=null&&b.connect_fan_div){var d=DOM.create('div',null,HTML(b.connect_fan_div));DOM.setContent(this.new_fan,DOM.find(d,'a'));}this.showNewFan();this.busy=false;};ConnectWidget.prototype.showNewFan=function(){this.fan_shown.forEach(function(a){if(!CSS.hasClass(a,'hidden_elem'))return;var b=Style.get(a,'width');Style.set(a,'width',0);Style.set(a,'opacity',0);CSS.show(a);animation(a).to('width',b).duration(100).checkpoint().to('opacity',1).duration(400).go();});this.fan_hidden.forEach(function(a){CSS.hide(a);});};ConnectWidget.prototype.connectUndoneHandler=function(a){var b=a.getPayload();DOM.remove(this.status);animation(this.button).from('opacity',0).to('opacity',1).go();CSS.show(this.button);this.hideNewFan();this.busy=false;};ConnectWidget.prototype.hideNewFan=function(){this.fan_shown.forEach(function(a){if(CSS.hasClass(a,'hidden_elem'))return;animation(a).to('opacity',0).duration(100).checkpoint(.25).to('width',0).duration(100).ondone(function(){Style.set(a,'width',null);CSS.hide(a);this.fan_hidden.forEach(function(b){CSS.show(b);});}.bind(this)).go();}.bind(this));};ConnectWidget.loadStream=function(a,b,c){new AsyncRequest().setMethod('GET').setURI('/ajax/connect/connect_widget.php').setData({id:a,uniqid:b,force_wall:c}).setReadOnly(true).setErrorHandler(bagofholding).send();};ConnectWidget.loggedIn=function(a){for(var b in ConnectWidget.instances){ConnectWidget.instances[b].setLoggedIn(a);ConnectWidget.instances[b].connect();}};ConnectWidget.setIsConnect=function(a){ConnectWidget.is_connect=a;};