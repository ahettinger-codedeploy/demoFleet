/*    HTTP Host:  b.static.ak.fbcdn.net                                        */
/*    Generated:  November 29th 2009 7:56:46 PM PST                            */
/*      Machine:  10.16.140.109                                                */
/*       Source:  Global Cache                                                 */
/*     Location:  js/4ncnwcdryx6o8ss0.pkg.js h:erfrf1vd                        */
/*       Locale:  nu_ll                                                        */
/*         Path:  js/4ncnwcdryx6o8ss0.pkg.js                                   */

((location=='about:blank'&&(window.parent.eval_global||window.parent.eval))||(window.eval_global||window.eval))("function InstrumentedLogger(_L0){if(this===window)return new InstrumentedLogger(_L0);if(InstrumentedLogger._instances[_L0])return InstrumentedLogger._instances[_L0];copy_properties(this,{id:_L0,_phases:{}});return InstrumentedLogger._instances[_L0]=this;}copy_properties(InstrumentedLogger,{_instances:{}});copy_properties(InstrumentedLogger.prototype,{beginPhase:function(_L0){if(this._phases[_L0]&&this._phases[_L0].start)this.endPhase(_L0);if(typeof(this._phases[_L0])=='undefined')this._phases[_L0]={start:0,count:0,duration:0};this._phases[_L0].start=new Date().getTime();return this;},endPhase:function(_L0){var _L1=this._phases[_L0];if(_L1&&_L1.start){_L1.count++;_L1.duration+=new Date().getTime()-_L1.start;_L1.start=null;}return this;},dumpAndReset:function(){this.dump();return this.reset();},dump:function(){for(var _L0 in this._phases){var p=this._phases[_L0];var _L2=(this.id?this.id+'::':'')+_L0;Util.warn(' %s %f ms [%d ms \/ %d]',_L2,p.duration\/p.count,p.duration,p.count);}return this;},get:function(_L0){if(this._phases[_L0])return this._phases[_L0].duration\/this._phases[_L0].count;return 0;},reset:function(){this._phases={};return this;}});InstrumentedLogger.prototype.b=InstrumentedLogger.prototype.beginPhase;InstrumentedLogger.prototype.e=InstrumentedLogger.prototype.endPhase;InstrumentedLogger.prototype.d=InstrumentedLogger.prototype.dump;InstrumentedLogger.prototype.D=InstrumentedLogger.prototype.dumpAndReset;InstrumentedLogger.prototype.r=InstrumentedLogger.prototype.reset;var IL=InstrumentedLogger;\nfunction static_source(){this.values=null;this.index=null;this.index_includes_hints=false;this.exclude_ids={};this.parent.construct(this);}static_source.extend('typeahead_source');static_source.prototype.enumerable=true;static_source.prototype.filter_excluded=function(_L0){return _L0.filter((function(_L1){return !this.exclude_ids[_L1.i];}).bind(this));};static_source.prototype.build_index=function(){var _L0=[];var _L1=this.values;var _L2=_L1.length&&typeof _L1[0].i=='undefined';for(var i=0,il=_L1.length;i<il;i++){var _L5=typeahead_source.tokenize(_L1[i].t);for(var j=0,jl=_L5.length;j<jl;j++)_L0.push({t:_L5[j],o:_L1[i]});if(this.index_includes_hints&&_L1[i].s){var _L5=typeahead_source.tokenize(_L1[i].s);for(var j=0,jl=_L5.length;j<jl;j++)_L0.push({t:_L5[j],o:_L1[i]});}if(_L2)_L1[i].i=i;}_L0.sort(function(a,b){return (a.t==b.t)?0:(a.t<b.t?-1:1);});this.index=_L0;this.ready();};static_source.prototype._sort_text_obj=function(a,b){if(a.e&&!b.e)return 1;if(!a.e&&b.e)return -1;return a.t.localeCompare(b.t);};static_source.prototype.search_value=function(_L0){if(!this.is_ready)return;var _L1;if(_L0==''){_L1=this.values;}else{var _L2=typeahead_source.tokenize(_L0).sort(typeahead_source._sort);var _L3=this.index;var lo=0;var hi=this.index.length-1;var p=Math.floor(hi\/2);while(lo<=hi){if(_L3[p].t>=_L2[0]){hi=p-1;}else lo=p+1;p=Math.floor(lo+((hi-lo)\/2));}var _L1=[];var _L7={};var _L8=typeof _ignoreList!='undefined';for(var i=lo;i<_L3.length&&_L3[i].t.lastIndexOf(_L2[0],0)!=-1;i++){var _La=_L3[i].o.flid?_L3[i].o.flid:_L3[i].o.i;if(typeof _L7[_La]!='undefined'){continue;}else _L7[_La]=true;if((!_L8||!_ignoreList[_La])&&!this.exclude_ids[_La]&&(_L2.length==1||typeahead_source.check_match(_L2,_L3[i].o.t)))_L1.push(_L3[i].o);}}_L1.sort(this._sort_text_obj.bind(this));if(this.owner&&this.owner.max_results)_L1=_L1.slice(0,this.owner.max_results);return _L1;};static_source.prototype.set_exclude_ids=function(ids){this.exclude_ids=ids;};\nfunction search_friend_source(_L0,_L1){this.get_param=_L0;this.parent.construct(this);if(!_L1)this.initialize();}search_friend_source.extend('static_source');search_friend_source.prototype.text_noinput=search_friend_source.prototype.text_placeholder=search_friend_source.prototype.text_nomatch='';search_friend_source.prototype.updated_pics={};search_friend_source.prototype.search_limit=5;search_friend_source.prototype._allowed_types=null;search_friend_source.prototype.do_dark_test=false;search_friend_source.prototype.initialize=function(_L0){var _L1=(new Date()).getTime();new AsyncRequest().setMethod('GET').setReadOnly(true).setURI('\/ajax\/typeahead_search.php?'+this.get_param).setErrorHandler(function(){}).setTransportErrorHandler(function(){}).setHandler(function(_L2){var _L3=_L2.getPayload();this.values=_L3.entries;search_friend_source.url_templates=this.templates=_L3.templates;this.build_index.bind(this).defer();search_typeahead_log(this.udata,'getdata',_L1);var _L4=((new Date()).getTime()\/1000)-60*5;if(_L3.gen_time<_L4)new AsyncRequest().setMethod('GET').setReadOnly(true).setURI('\/ajax\/recent_pics.php').setData({ref_time:_L3.gen_time}).setErrorHandler(function(){}).setTransportErrorHandler(function(){}).setHandler(function(_L2){this.updated_pics=_L2.getPayload().updated_pics;}.bind(this)).send();if(_L0)_L0();}.bind(this)).send();};search_friend_source.loaded_images={};search_friend_source.TYPES={USER:'u',CONNECTION:'c',FOLLOWER:'fl',PAGE:'p',APP:'a',GROUP:'g',EVENT:'e',SEARCH:'search',WEB:'web'};search_friend_source.prototype.build_index=function(){var _L0=this.history?this.history.entries:undefined;if(_L0!=undefined)this.values=this.values.each(function(_L1){_L1.o=_L0[_L1.i]!=undefined?_L0[_L1.i]:_L1.o;return _L1;});this.parent.build_index();};search_friend_source.image_load=function(_L0,_L1,_L2){var _L3=(new Date()).getTime();search_friend_source.loaded_images[_L2]=true;if((_L3-_L1)<100){CSS.setOpacity(_L0,1);}else animation(_L0).to('opacity',1).duration(100).go();};search_friend_source.prototype.gen_html=function(_L0,_L1){var _L2=_L0.it;if(!_L2&&_L0.ty&&this.templates[_L0.ty])_L2=this.templates[_L0.ty].icon;if(this.updated_pics[_L0.i])_L2=this.updated_pics[_L0.i];switch(_L0.ty){case search_friend_source.TYPES.USER:case search_friend_source.TYPES.CONNECTION:case search_friend_source.TYPES.PAGE:if(!_L2){return ['<div>',typeahead_source.highlight_found(_L0.t,_L1),'<\/div><div><small>',_L0.n||'&nbsp;','<\/small><\/div>'].join('');}else{if(!search_friend_source.loaded_images[_L0.i]){var _L3=(new Date()).getTime();var _L4=sprintf('onload=\"search_friend_source.image_load(this, %d, %d);\" style=\"opacity:0;filter:alpha(opacity=0);\"',_L3,_L0.i);}return ['<img ',_L4,' alt=\"\" src=\"',_L2,'\"\/>','<div class=\"with_pic\"><span>',typeahead_source.highlight_found(_L0.t,_L1),'<\/span><small>',_L0.n||'&nbsp;','<\/small><\/div>'].join('');}break;case search_friend_source.TYPES.SEARCH:return ['<div class=\"app\"><div class=\"icon\" style=\"background-image: url(',_L2,')\">&nbsp;<\/div>','<span>',_L0.t,'<\/span><\/div>'].join('');break;default:return ['<div class=\"app clearfix\"><div class=\"icon\" style=\"background-image: url(',_L2,')\">&nbsp;<\/div>','<span>',typeahead_source.highlight_found(_L0.t,_L1),'<\/span><\/div>'].join('');}};search_friend_source.prototype.allowTypes=function(_L0){this._allowed_types=_L0;return this;};search_friend_source.prototype.search_value=function(_L0){if(this.do_dark_test)new AsyncSignal('\/ajax\/search\/typeahead_dark.php',{query:_L0}).send();var _L1;var _L2=false;var _L3=typeahead_source.tokenize(_L0);for(var i=0;i<_L3.length;i++)if(_L3[i]!=''){_L2=true;break;}if(_L2){this.owner.less_than_n_chars=false;_L1=this.parent.search_value(_L0);}else if(this.is_ready){this.owner.less_than_n_chars=true;_L1=[];}var _L5=(_L1&&_L1.length)?false:true;if(_L1)for(var i=0;i<_L1.length;i++)if((_L1[i].ty!=search_friend_source.TYPES.USER)&&(_L1[i].ty!=search_friend_source.TYPES.CONNECTION)){_L5=true;break;}var _L6=this.search_limit;if(_L1)_L6-=_L1.length;if(_L1&&_L5&&_L2&&search_friend_source.WEBSEARCH_USER){_L1.push({t:_tx(\"Search Facebook\"),ty:search_friend_source.TYPES.SEARCH,i:_L0});_L1.push({t:_tx(\"Search the Web\"),ty:search_friend_source.TYPES.WEB,i:_L0});}if(_L1&&this._allowed_types)_L1=_L1.filter(function(_L7){return this._allowed_types.contains(_L7.ty);}.bind(this));return _L1;};search_friend_source.prototype._sort_text_obj=function(a,b){var _L2=this.history?this.history.entries:undefined;if(_L2!=undefined){a.o=_L2[a.i]||a.o;b.o=_L2[b.i]||b.o;}if(a.o!=b.o)return a.o-b.o;return a.t.localeCompare(b.t);};search_friend_source.WEBSEARCH_USER=false;\nfunction Template(_L0){copy_properties(this,{_templateSource:_L0});}copy_properties(Template,{_operatorRepeat:function(s,_L1){var _L2='';var _L3=s.match(\/([^:]*):(.*)\/);if(!_L3){Util.warn('Invalid template call: %s',s);}else if(!TemplateRegistry.hasTemplate(_L3[2])){Util.warn('Template not available: %s',s);}else if(_L1[_L3[1]]){var _L4=TemplateRegistry.getTemplate(_L3[2]);var _L5=arrayize(_L1[_L3[1]]);_L2+=_L5.map(function(_L4,_L1){return _L4.render(_L1);}.curry(_L4)).join(' ');}return _L2;}});copy_properties(Template.prototype,{getSource:function(){return this._templateSource;},render:function(_L0){var _L1=function(_L2,_L3,_L4,key){switch(_L4){case 'H':return _L2[key]||'';case 'R':return Template._operatorRepeat(key,_L2);default:return _L2[key]?htmlize(_L2[key]):'';}return _L2[key]?translator(_L2[key]):'';}.curry(_L0||{});return this._templateSource.replace(\/\\$(H|R)?{([^\\}]*)\\}\/g,_L1);}});var TemplateRegistry={_storage:{},registerTemplate:function(_L0,_L1){if(typeof(_L1)==\"string\")_L1=new Template(_L1);this._storage[_L0]=_L1;return this;},unregisterTemplate:function(_L0){delete this._storage[_L0];},hasTemplate:function(_L0){return _L0 in this._storage;},getTemplate:function(_L0){if(this.hasTemplate(_L0))return this._storage[_L0];return null;},registerServerSideTemplate:function(_L0,_L1,_L2,_L3){_L1=_L1||bagofholding;_L2=!!_L2;_L3=!!_L3;if(this.hasTemplate(_L0)){_L1();return this;}var _L4=new AsyncRequest(_L0).setReadOnly(true).setMethod('GET').setOption('asynchronous',!_L2).setOption('suppressEvaluation',!_L3);if(!_L2)_L4.setErrorHandler(this._registerErrorHandler.bind(this,_L0)).setHandler(this._registerHandler.bind(this,_L0,_L3,_L1));_L4.send();if(_L2){var _L5=this._stripHasteComments(_L4.transport.responseText);this.registerTemplate(_L0,new Template(_L5));_L1();}return this;},_registerErrorHandler:function(_L0,_L1){Util.warn('Failed to register template \"%s\"',_L0);},_registerHandler:function(_L0,_L1,_L2,_L3){var _L4=_L3.getPayload();var _L5=null;if(_L1){if(_L4.template)_L5=_L4.template;}else _L5=this._stripHasteComments(_L4.responseText);if(_L5){this.registerTemplate(_L0,_L5);_L2();}else Util.error('No template found in response payload');},_stripHasteComments:function(_L0){return _L0.replace(\/^\\s*\\\/\\*\\*?(.|\\n)*\\*\\\/\/m,'');},_onRegisterTemplate:function(_L0,_L1){if(_L0=='template\/registerTemplate'){if(!_L1||!_L1.name||!_L1.template){Util.warn('TemplateRegister: Invalid template data.');}else this.registerTemplate(_L1.name,_L1.template);return false;}Util.warn('TemplateRegister: Invalid arbiter message type: %s',_L0);return true;}};Arbiter.subscribe('template\/registerTemplate',TemplateRegistry._onRegisterTemplate.bind(TemplateRegistry),Arbiter.SUBSCRIBE_ALL);\nfunction TemplateObject(_L0,_L1){_L1=_L1||{};if(!(_L0 instanceof Template))if(TemplateRegistry.hasTemplate(_L0)){_L0=TemplateRegistry.getTemplate(_L0);}else if(_L0 instanceof URI){TemplateRegistry.registerServerSideTemplate(_L0.toString(),null,true);_L0=TemplateRegistry.getTemplate(_L0);}if(_L0==null)throw new Error(\"Template could not be found\");var _L2=_L0.render(_L1);copy_properties(this,{_nodes:HTML(_L2).getNodes(),_template:_L0,_rendered:_L2});TemplateObject.bindNodes(this._nodes,this);}copy_properties(TemplateObject,{bindNodes:function(_L0,_L1){var _L2=[];for(var i=0;i<_L0.length;i++)if(_L0[i].nodeType==DOM.NODE_TYPES.ELEMENT){_L2.push(_L0[i]);var _L4=_L0[i].getElementsByTagName('*');_L2=_L2.concat(to_array(_L4));}for(var i=0;i<_L2.length;i++){var _L5=_L2[i].getAttribute('bindPoint');var _L6=_L2[i].getAttribute('listen');if(_L5)if(hasArrayNature(_L1[_L5])){_L1[_L5].push(_L2[i]);}else _L1[_L5]=_L2[i];if(_L6)_L6.replace(\/(\\w+) *: *(\\w+)\/g,function(_L7,_L8,_L9,_La){if(typeof(this[_La])==\"function\"){Event.listen(_L7,_L9,bind(this,this[_La]));}else Event.listen(_L7,_L9,bind(this,TemplateObject._eventWrapper,_La));}.bind(_L1,_L2[i]));}},_eventWrapper:function(_L0,_L1){if(typeof(this[_L0])==\"function\"){return this[_L0](_L1);}else{Util.warn('Event wrapper [%s] not defined for template object',_L0);return true;}}});copy_properties(TemplateObject.prototype,{getNodes:function(){return this._nodes;},getRendered:function(){return this._rendered;}});\nArbiter.inform(\"template\\\/registerTemplate\", {\"name\":\"\\\/templates\\\/UIActionMenu.tmpl\",\"template\":\"\\n<div class=\\\"UIActionMenu\\\" bindPoint=\\\"root\\\">\\n  <a class=\\\"UIActionMenu_Wrap\\\" bindPoint=\\\"wrap\\\" href=\\\"#\\\">\\n    <span class=\\\"UIActionMenu_Icon\\\" bindPoint=\\\"icon\\\"><\\\/span>\\n    <span class=\\\"UIActionMenu_Text\\\" bindPoint=\\\"text\\\"><\\\/span>\\n    <span class=\\\"UIActionMenu_Chevron\\\"><\\\/span>\\n  <\\\/a>\\n  <div class=\\\"UIActionMenu_Menu\\\" bindPoint=\\\"menu\\\"><\\\/div>\\n<\\\/div>\\n\"}, Arbiter.BEHAVIOR_PERSISTENT);\nfunction UIActionMenu(_L0){this.root=null;this.wrap=null;this.icon=null;this.text=null;this.menu=null;this._title=_L0;this._contentCallback=bagofholding;this._selectList=null;this.parent.construct(this,URI('\/templates\/UIActionMenu.tmpl'));this._initialize();}UIActionMenu.extend('TemplateObject');copy_properties(UIActionMenu,{ICONS:{LOCK:'UIActionMenu_Lock',PEOPLE:'UIActionMenu_People'},COLORS:{BLUE:'UIActionMenu_Blue'}});UIActionMenu.mixin('Arbiter',{_initialize:function(){var _L0=false,_L1=null;_L1=Event.listen(this.root,'mousedown',function(){this.buildMenu();_L1.remove();}.bind(this));if(ua.ie()){Event.listen(this.root,'mousedown',function(_L2){if(this.menuVisible()&&!DOM.contains(this.menu,_L2.getTarget()))document.body.focus();}.bind(this));Event.listen(this.root,{'activate':this.showMenu.bind(this),'deactivate':this.hideMenu.bind(this),'selectstart':Event.kill});}else{this.input=$N('input',{type:'button'});DOM.prependContent(this.wrap,this.input);Event.listen(this.root,'mousedown',function(_L2){var _L3=_L2.getTarget();if(DOM.contains(this.menu,_L3)){if(!DOM.isNode(_L3,'input'))setTimeout(function(){this.input.focus();}.bind(this),100);_L0=true;return;}this.toggleMenu();this.input.focus();return false;}.bind(this));Event.listen(this.input,'blur',function(_L2){if(_L0){_L0=false;return;}this.hideMenu();}.bind(this));}Event.listen(this.wrap,'click',function(_L2){_L2.kill();});},menuVisible:function(){return CSS.hasClass(this.root,'UIActionMenu_Active');},hideMenu:function(){CSS.removeClass(this.root,'UIActionMenu_Active');return this;},showMenu:function(){this.inform('menuActivated');CSS.addClass(this.root,'UIActionMenu_Active');return this;},toggleMenu:function(){if(this.menuVisible()){return this.hideMenu();}else return this.showMenu();},setAlignRight:function(_L0){CSS.conditionClass(this.root,'UIActionMenu_AlignRight',_L0);return this;},setContentCallback:function(fn){this._contentCallback=fn;return this;},setSuppressButton:function(_L0){CSS.conditionClass(this.root,'UIActionMenu_SuppressButton',_L0);return this;},setSuppressText:function(_L0){CSS.conditionClass(this.root,'UIActionMenu_SuppressText',_L0);return this;},setColor:function(_L0){switch(_L0){case UIActionMenu.COLORS.BLUE:if(this.color)CSS.removeClass(this.root,this.color);CSS.addClass(this.root,_L0);this.color=_L0;break;default:if(this.color){CSS.removeClass(this.root,this.color);this.color=null;}}return this;},setIcon:function(_L0){switch(_L0){case UIActionMenu.ICONS.LOCK:case UIActionMenu.ICONS.PEOPLE:CSS.addClass(this.root,'UIActionMenu_IconIncluded');CSS.addClass(this.icon,_L0);break;default:CSS.removeClass(this.root,'UIActionMenu_IconIncluded');Util.error('invalid icon passed to `UIActionMenu.setIcon`');}return this;},_getContent:function(){var _L0=this._contentCallback();if(this.input){var _L1=DOM.scry(_L0,'input');_L1.each(function(_L2){Event.listen(_L2,'blur',function(){this.input.focus();}.bind(this));},this);}return _L0;},setTitle:function(_L0){this._title=_L0;DOM.setContent(this.text,this._title);return this;},setTooltip:function(_L0){if(this.tooltip){if(_L0){DOM.setContent(this.tooltip.firstChild,_L0);}else{DOM.remove(this.tooltip);CSS.removeClass(this.wrap,'uiTooltip');this.tooltip=null;}}else{this.tooltip=$N('span',{className:'uiTooltipWrap'},$N('span',{className:'uiTooltipText'},_L0));CSS.addClass(this.wrap,'uiTooltip');DOM.prependContent(this.wrap,this.tooltip);}return this;},getNodes:function(){DOM.setContent(this.text,this._title);return [this.root];},buildMenu:function(){DOM.setContent(this.menu,this._getContent());return this;},useSelectList:function(_L0,_L1,_L2){_L2=_L2||UISelectList.MULTI_SELECT_MODE;this.setContentCallback(function(){this._selectList=new UISelectList().setMode(_L2).setCallback(function(_L3,key){this.hideMenu();_L1&&_L1(_L3,key);}.bind(this)).addItems(_L0);return this._selectList.getElement();}.bind(this));return this;},resetSelectList:function(){this._selectList&&this._selectList.reset();},getSelectList:function(){return this._selectList;}});\n\nif (window.Bootloader) { Bootloader.done([\"js\\\/4ncnwcdryx6o8ss0.pkg.js\"]); }")