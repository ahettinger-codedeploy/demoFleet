/*    HTTP Host:  b.static.ak.fbcdn.net                                        */
/*    Generated:  November 24th 2009 9:53:04 AM PST                            */
/*      Machine:  10.16.139.103                                                */
/*       Source:  Local Cache                                                  */
/*     Location:  rsrc:4:88vsuu5r                                              */
/*       Locale:  nu_ll                                                        */
/*         Path:  js/e2iq7pq6sbkgg4kg.pkg.js                                   */

((location=='about:blank'&&(window.parent.eval_global||window.parent.eval))||(window.eval_global||window.eval))("function fbpage_set_fan_status(_L0,_L1,_L2,_L3,_L4,_L5,_L6){_L4=_L4?_L4:function(_L9){_fbpage_show_change_status_feedback(_L0,_L9.getPayload());};var _L7={'fbpage_id':_L1,'add':_L2,'reload':_L3};if(_L6!=null)copy_properties(_L7,_L6);var _L8=new AsyncRequest().setURI('\/ajax\/pages\/fan_status.php').setData(_L7).setHandler(_L4);if(_L5)_L8.setErrorHandler(_L5);_L8.send();return false;}function fbpage_set_favorite_status(_L0,_L1,_L2){var _L3=function(){_fbpage_show_change_status_feedback(_L0,this.getUserData());};var _L4={'fbpage_id':_L1,'add':_L2};var _L5=new AsyncRequest().setMethod('POST').setURI('\/ajax\/pages\/favorite_status.php').setData(_L4);new Dialog().setAsync(_L5).setCloseHandler(_L3).show();return false;}function _fbpage_show_change_status_feedback(_L0,_L1){if(!_L1||!_L0)return;if(_L1.reload){fbpage_reload_on_fan_status_changed(_L1.preserve_tab);}else fbpage_redraw_on_fan_status_changed(_L1.feedback);}function fbpage_reload_on_fan_status_changed(_L0){var uri=URI.getRequestURI();if(_L0)if(!uri.getQueryData().v&&window.profile_tab_controller)uri.addQueryData({'v':window.profile_tab_controller.currentView});goURI(uri,true);}function fbpage_redraw_on_fan_status_changed(_L0){if(!_L0)return;var _L1=document.createElement('span');_L1.innerHTML=_L0;CSS.setClass(_L1,'fan_status_inactive');elem.parentNode.replaceChild(_L1,elem);var _L2=function(){if(data.can_repeat_action)_L1.parentNode.replaceChild(elem,_L1);};animation(_L1).duration(3000).checkpoint().to('backgroundColor','#FFFFFF').duration(1000).ondone(_L2).go();}\nfunction ConnectWidget(_L0,_L1,_L2){copy_properties(this,{button:$(_L2),profile_id:_L1,viewer_id:_L0,status:null,popup:null,busy:false,new_fan:null});this.popup_uri=new URI('\/login.php');this.popup_uri.addQueryData({connect_id:this.profile_id,popup:true});this.button=$(_L2);this.button.listen('click',this.connectClickHandler.bind(this));this.fan_hidden=[];this.fan_shown=[];var _L3=DOM.scry(document,'div.connections');if(_L3.length>0){_L3=_L3[0];this.new_fan=DOM.find(_L3,'div.grid_item_plus');this.fan_shown.push(this.new_fan);this.fan_shown.push(DOM.find(_L3,'span.total_plus'));var _L4=DOM.scry(_L3,'span.total');var _L5=DOM.scry(_L3,'div.grid_item');if(_L5.length>1)this.fan_hidden.push(_L5[1]);this.fan_hidden.push(_L4[_L4.length-1]);}ConnectWidget.instances[_L2]=this;}ConnectWidget.instances={};ConnectWidget.prototype.setLoggedIn=function(_L0){this.viewer_id=_L0;return this;};ConnectWidget.prototype.connectClickHandler=function(e){e.kill();if(this.viewer_id!=0){this.connect();}else this.popUpLogin();};ConnectWidget.prototype.connect=function(){if(!this.busy){this.busy=true;fbpage_set_fan_status(this.button,this.profile_id,true,false,this.connectDoneHandler.bind(this),this.connectErrorHandler.bind(this),this.getAsyncData());}};ConnectWidget.prototype.disconnect=function(){if(!this.busy){this.busy=true;fbpage_set_fan_status(this.button,this.profile_id,false,false,this.connectUndoneHandler.bind(this),function(){},this.getAsyncData());}};ConnectWidget.prototype.getAsyncData=function(){var _L0={source:'connect'};if(ge('post_form_id'))_L0['post_form_id']=$('post_form_id').value;if(ge('fb_dtsg'))_L0['fb_dtsg']=$('fb_dtsg').value;return _L0;};ConnectWidget.prototype.popUpLogin=function(){window.open(this.popup_uri.toString(),'_blank','toolbar=0,status=0,width=626,height=400');};ConnectWidget.prototype.connectErrorHandler=function(_L0){if(_L0.error==kError_Async_NotLoggedIn){this.viewer_id=0;this.popUpLogin();}else if(_L0.error==kError_Async_PopUpCaptchaRequired){hide(this.button);var _L1=$N('a',{href:DOM.find(document,'div.name_block a').href,target:'_blank'},_tx(\"Verification is needed to connect.\"));this.status=$N('span',{className:'connect_span'},_L1);DOM.insertAfter(this.button,this.status);}else{hide(this.button);if(_L0.error==kError_ProfileConnect_AlreadyConnected){this.status=$N('span',{className:'connect_span'},_tx(\"You are a Fan.\"));}else this.status=$N('span',{className:'connect_span'},_L0.getErrorSummary()+': '+_L0.getErrorDescription());animation(this.status).from('opacity',0).to('opacity',1).go();DOM.insertAfter(this.button,this.status);}this.busy=false;};ConnectWidget.prototype.connectDoneHandler=function(_L0){var _L1=_L0.getPayload();if(!_L1||!_L1.feedback)return;this.status=$N('span',{className:'connect_span'},HTML(_L1.feedback));var _L2=$N('a',{className:'undo'},_tx(\"Undo\"));_L2.listen('click',function(e){e.kill();this.disconnect();}.bind(this));DOM.appendContent(this.status,_L2);animation(this.status).from('opacity',0).to('opacity',1).go();DOM.insertAfter(this.button,this.status);hide(this.button);if(this.new_fan!=null&&_L1.connect_fan_div){var _L3=$N('div',{},HTML(_L1.connect_fan_div));DOM.setContent(this.new_fan,DOM.find(_L3,'a'));}this.fan_shown.forEach(function(_L4){animation(_L4).from('opacity',0).to('opacity',1).go();CSS.removeClass(_L4,'hidden');});this.fan_hidden.forEach(function(_L4){CSS.addClass(_L4,'hidden');});this.busy=false;};ConnectWidget.prototype.connectUndoneHandler=function(_L0){var _L1=_L0.getPayload();DOM.remove(this.status);animation(this.button).from('opacity',0).to('opacity',1).go();show(this.button);this.fan_shown.forEach(function(_L2){CSS.addClass(_L2,'hidden');});this.fan_hidden.forEach(function(_L2){CSS.removeClass(_L2,'hidden');});this.busy=false;};ConnectWidget.loadStream=function(_L0,_L1){new AsyncRequest().setMethod('GET').setURI('\/ajax\/connect\/connect_widget.php').setData({id:_L0}).setReadOnly(true).setErrorHandler(function(){}).setTransportErrorHandler(function(){}).setHandler(function(_L2){payload=_L2.getPayload();DOM.setContent($(_L1),HTML(payload['stream_markup']));}.bind(this)).send();};ConnectWidget.loggedIn=function(_L0,_L1){if(ge('post_form_id')){DOM.replace($('post_form_id'),HTML(_L1));}else DOM.appendContent(DOM.find(document,'body'),HTML(_L1));for(var id in ConnectWidget.instances){ConnectWidget.instances[id].setLoggedIn(_L0);ConnectWidget.instances[id].connect();}};\n\nif (window.Bootloader) { Bootloader.done([\"js\\\/e2iq7pq6sbkgg4kg.pkg.js\"]); }")