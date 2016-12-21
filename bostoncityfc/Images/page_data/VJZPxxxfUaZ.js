/*!CK:3549061595!*//*1454966394,*/

if (self.CavalryLogger) { CavalryLogger.start_js(["WNek9"]); }

__d('MountedContextMenu.react',['ContextualLayer.react','DOMQuery','Event','Focus','LayerHideOnEscape','PopoverMenu.react','PopoverMenuInterface','React','ReactDOM','ReactElement','ReactLayeredComponentMixin','SubscriptionsHandler','cx','isNode'],function a(b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u){'use strict';if(c.__markCompiled)c.__markCompiled();var v=Object.prototype.hasOwnProperty,w=o.PropTypes;function x(z,aa,ba,ca,da){var ea=ba.getContent().getBoundingClientRect(),fa=ba.getContext().getBoundingClientRect(),ga=z-fa.left,ha=aa-fa.top;switch(da){case 'left':ga-=ea.width;break;case 'center':ga-=fa.width*.5;break;case 'right':ga-=fa.width-ea.width;break;default:throw new Error('invalid alignment');}switch(ca){case 'above':break;case 'left':ga+=ea.width;ha-=ea.height*.5;break;case 'right':ga-=ea.width;ha-=ea.height*.5;break;case 'below':ha-=fa.height;break;default:throw new Error('invalid position');}return {offsetX:ga,offsetY:ha};}var y=o.createClass({displayName:'MountedContextMenu',mixins:[r],propTypes:{disableFocusOutline:w.bool,menu:function(z,aa,ba){if(!v.call(z,aa))return new Error(ba+'.'+aa+' is required');var ca=z[aa],da=ca&&ca.type;if(!(da&&da.prototype instanceof n))return new Error(aa+' must implement PopoverMenuInterface');},mountedTriggerElem:function(z,aa,ba){if(!v.call(z,aa)){return new Error(ba+'.'+aa+' is required');}else if(!u(z[aa]))return new Error(ba+'.'+aa+' must be a raw DOM node');}},getDefaultProps:function(){return {disableFocusOutline:false};},getInitialState:function(){return {shown:false,lastOpenedX:0,lastOpenedY:0,offsetX:0,offsetY:0};},_getTriggerDOMNode:function(){return this.props.mountedTriggerElem;},_getMenuDOMNode:function(){var z=this.refs.popover.getMenu();return z&&z.getRoot();},_getLayer:function(){return this.refs.menuLayer.layer;},renderLayers:function(){var z=this.props.menu,aa=z.props.onItemClick,ba=this;z=q.cloneAndReplaceProps(z,babelHelpers._extends({},z.props,{onItemClick:function(){ba.hide();return aa&&aa.apply(this,arguments);}}));return {menu:o.createElement(h,{alignment:'right',behaviors:[l],contextRef:(function(){return this._getTriggerDOMNode();}).bind(this),offsetX:this.state.offsetX,offsetY:this.state.offsetY,position:'below',ref:'menuLayer',shown:this.state.shown},o.createElement(m,{alignh:'left',menu:z,position:'below',ref:'popover'},o.createElement('div',{className:"_4345",ref:'fakeTrigger'})))};},render:function(){if(this.props.mountedTriggerElem)return null;},_updatePosition:function(z,aa){var ba=this._getLayer(),ca=ba.getOrientation(),da=ca.getPosition(),ea=ca.getAlignment(),fa=x(z,aa,ba,da,ea),ga=fa.offsetX,ha=fa.offsetY;ba.setOffsetX(ga).setOffsetY(ha);this.setState({offsetX:ga,offsetY:ha});},_onContextMenu:function(z){var aa=z.clientX,ba=z.clientY;z.preventDefault();z.stopPropagation();this.showAt(aa,ba);},_onMousedownAnywhere:function(z){var aa=this._getMenuDOMNode(),ba=aa&&i.contains(aa,z.target),ca=z.button===0;if(!(ba&&ca))this.hide();},_onRealTriggerFocus:function(){if(this.props.disableFocusOutline)k.setWithoutOutline(this._getTriggerDOMNode());},_onFakeTriggerFocus:function(){var z=this._getTriggerDOMNode();if(this.props.disableFocusOutline){k.setWithoutOutline(z);}else k.set(z);if(this.state.shown)this.hide();},_onWindowBlur:function(){this.hide();},componentDidMount:function(){var z=this._getTriggerDOMNode(),aa=p.findDOMNode(this.refs.fakeTrigger),ba=this._getLayer(),ca=this.refs.popover;this._subscriberHandler=new s();this._subscriberHandler.addSubscriptions(j.listen(z,'contextmenu',this._onContextMenu),j.listen(document.body,'mousedown',this._onMousedownAnywhere),j.listen(z,'focus',this._onRealTriggerFocus),j.listen(aa,'focus',this._onFakeTriggerFocus),j.listen(window,'blur',this._onWindowBlur),ba.subscribe('show',(function(){var da=this.state.lastOpenedX,ea=this.state.lastOpenedY;this._updatePosition(da,ea);ca.showPopover();}).bind(this)),ba.subscribe('hide',function(){ca.hidePopover();}));},componentWillUnmount:function(){this._subscriberHandler&&this._subscriberHandler.release();},show:function(){this.setState({shown:true});},showAt:function(z,aa){this.setState({lastOpenedX:z,lastOpenedY:aa});this.show();},hide:function(){this.setState({shown:false});}});f.exports=y;},null);
__d('VideoPlayerHTML5ContextMenu.react',['ContextualLayer.react','DOMQuery','Event','Focus','FullScreen','getFullScreenElement','Keys','LayerAutoFocus','LayerHideOnEscape','MountedContextMenu.react','React','ReactDOM','ReactLayeredComponentMixin','ReactXUIMenu','SubscriptionsHandler','VideoContextMenuGK','cx','fbt','isNode'],function a(b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z){'use strict';if(c.__markCompiled)c.__markCompiled();var aa=Object.prototype.hasOwnProperty,ba=u.Item,ca=r.PropTypes,da=.35,ea=6,fa=60,ga=r.createClass({displayName:'VideoPlayerHTML5ContextMenu',mixins:[t],propTypes:{videoElem:function(ha,ia,ja){if(!aa.call(ha,ia)){return new Error(ja+'.'+ia+' is required');}else if(!z(ha[ia]))return new Error(ja+'.'+ia+' must be a raw DOM node');},paused:ca.bool,muted:ca.bool,permalinkURL:ca.string,onTogglePause:ca.func.isRequired,onToggleMute:ca.func.isRequired},getInitialState:function(){return {permalinkVisible:false,fullscreened:false,screenWidth:screen.width,screenHeight:screen.height};},componentDidMount:function(){var ha=this.refs.permalinkLayer.layer;this._subscriberHandler=new v();this._subscriberHandler.addSubscriptions(l.subscribe('changed',this._onFullScreenChanged),ha.subscribe('hide',this._onHidePermalinkOverlay),ha.subscribe('show',this._onShowPermalinkOverlay));},componentWillUnmount:function(){this._subscriberHandler&&this._subscriberHandler.release();},_onFullScreenChanged:function(){var ha=m(),ia=this.props.videoElem,ja=!!(l.isFullScreen()&&ha&&ia&&i.contains(ha,ia));this.setState({fullscreened:ja});},_renderTogglePauseLabel:function(){if(this.props.paused){return y._("Play");}else return y._("Pause");},_renderToggleMuteLabel:function(){if(this.props.muted){return y._("Unmute");}else return y._("Mute");},_onTogglePause:function(){this.props.onTogglePause&&this.props.onTogglePause();},_onToggleMute:function(){this.props.onToggleMute&&this.props.onToggleMute();},_onShowPermalinkOverlay:function(){k.set(s.findDOMNode(this.refs.permalinkText));this.setState({permalinkVisible:true});},_onHidePermalinkOverlay:function(){this.setState({permalinkVisible:false});},_onPermalinkTextFocus:function(){s.findDOMNode(this.refs.permalinkText).select();},_onPermalinkTextKeyDown:function(ha){if(j.getKeyCode(ha)==n.ESC)this.setState({permalinkVisible:false});},_onPermalinkTextMouseUp:function(ha){ha.preventDefault();},_getVideoDimensions:function(){var ha,ia;if(this.state.fullscreened){ha=this.state.screenWidth;ia=this.state.screenHeight;}else{var ja=this.props.videoElem.getBoundingClientRect();ha=ja.width;ia=ja.height;}return {width:ha,height:ia};},_renderPermalinkLayerContent:function(ha){var ia=this.props.permalinkURL;if(ia){var ja={width:ha+'px'};return (r.createElement('div',{className:"_26oo",style:ja},r.createElement('input',{className:"_26op autofocus",onFocus:this._onPermalinkTextFocus,onKeyDown:this._onPermalinkTextKeyDown,onMouseUp:this._onPermalinkTextMouseUp,readOnly:true,ref:'permalinkText',type:'text',value:ia}),r.createElement('button',{className:"_26oq",onClick:this._onHidePermalinkOverlay},y._("Close"))));}},renderLayers:function(){var ha=this.props.permalinkURL&&this.state.permalinkVisible,ia=0,ja=0,ka=null,la=this._getVideoDimensions(),ma=la.width,na=la.height,oa=ma*da;ia=ma/2-oa/2;ja=-na+ea;if(this.state.fullscreened)ja+=fa;ka=this._renderPermalinkLayerContent(oa);return {permalinkOverlay:r.createElement(h,{alignment:'left',behaviors:[p,o],contextRef:(function(){return this.props.videoElem;}).bind(this),offsetX:ia,offsetY:ja,position:'below',ref:'permalinkLayer',shown:ha},ka)};},_renderPermalinkCopyOption:function(){if(this.props.permalinkURL)return (r.createElement(ba,{onclick:this._onShowPermalinkOverlay,ref:'permalinkMenuItem'},y._("Show video URL")));},render:function(){var ha=r.createElement(u,{className:w.menuRedesign?"_45di":''},r.createElement(ba,{onclick:this._onTogglePause},this._renderTogglePauseLabel()),r.createElement(ba,{onclick:this._onToggleMute},this._renderToggleMuteLabel()),this._renderPermalinkCopyOption(),this.props.children);return (r.createElement(q,{mountedTriggerElem:this.props.videoElem,menu:ha,ref:'menu'}));}});f.exports=ga;},null);
__d('VideoContextMenu',['EventListener','Bootloader','URI','React','ReactDOM','VideoPlayerHTML5ContextMenu.react','VideoPlayerReason','UserAgent','CurrentUser'],function a(b,c,d,e,f,g,h,i,j,k,l,m,n,o,p){if(c.__markCompiled)c.__markCompiled();function q(r,s,t){'use strict';this.$VideoContextMenu1=r;this.$VideoContextMenu2=t;this.$VideoContextMenu3=s;this.$VideoContextMenu4={};this.$VideoContextMenu5=null;if(this.$VideoContextMenu2.permalinkURL)this.$VideoContextMenu5=new j(this.$VideoContextMenu2.permalinkURL).getQualifiedURI().toString();var u=['muteVideo','unmuteVideo','changeVolume','beginPlayback','pausePlayback','finishPlayback'];r.addListener('optionsChange',(function(){return this.$VideoContextMenu6();}).bind(this));this.$VideoContextMenu6();u.forEach((function(v){return (r.addListener(v,(function(){return this.$VideoContextMenu7();}).bind(this)));}).bind(this));h.listen(this.$VideoContextMenu1.getVideoNode(),'contextmenu',this.$VideoContextMenu8.bind(this));}q.prototype.$VideoContextMenu9=function(r,s,t,u){'use strict';i.loadModules(["VideoComponentOptionMenuItems"],(function(v){if(!this.$VideoContextMenu10)this.$VideoContextMenu10=new v(this.$VideoContextMenu1,(function(){return this.$VideoContextMenu7();}).bind(this));this.$VideoContextMenu10.addComponentOptionMenuItem(r,s,t,u);}).bind(this));};q.prototype.$VideoContextMenu6=function(){'use strict';if(this.$VideoContextMenu1.hasOption('DebugOverlay','hidden'))this.$VideoContextMenu9('DebugOverlay','hidden','Show Debug Information','Hide Debug Information');};q.prototype.$VideoContextMenu7=function(){'use strict';if(this.$VideoContextMenu11)this.$VideoContextMenu12();};q.prototype.$VideoContextMenu13=function(r,s){'use strict';if(!this.$VideoContextMenu10)return undefined;return this.$VideoContextMenu10.getComponentOptionMenuItem(r,s);};q.prototype.$VideoContextMenu12=function(){'use strict';var r=this.$VideoContextMenu13('DebugOverlay','hidden'),s=this.$VideoContextMenu1.getVideoNode();this.$VideoContextMenu11=l.render(k.createElement(m,{videoElem:s,paused:!this.$VideoContextMenu1.isState('playing'),muted:this.$VideoContextMenu1.isMuted(),permalinkURL:this.$VideoContextMenu5,onTogglePause:(function(){return this.$VideoContextMenu14();}).bind(this),onToggleMute:(function(){return this.$VideoContextMenu15();}).bind(this)},r),this.$VideoContextMenu3);};q.prototype.$VideoContextMenu15=function(){'use strict';if(this.$VideoContextMenu1.isMuted()){this.$VideoContextMenu1.unmute();}else this.$VideoContextMenu1.mute();};q.prototype.$VideoContextMenu14=function(){'use strict';var r=n.USER;if(!this.$VideoContextMenu1.isState('playing')){this.$VideoContextMenu1.play(r);}else this.$VideoContextMenu1.pause(r);};q.prototype.$VideoContextMenu8=function(r){'use strict';var s=p.isEmployee()&&(o.isPlatform('Mac OS X')?r.getModifiers().meta:r.getModifiers().ctrl);if(s&&this.$VideoContextMenu11){var t=this.$VideoContextMenu1.getVideoNode();l.unmountComponentAtNode(t);delete this.$VideoContextMenu11;}else if(!s&&!this.$VideoContextMenu11){r.preventDefault();this.$VideoContextMenu12();}};f.exports=q;},null);