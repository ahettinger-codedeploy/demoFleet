var nTCode=new Array;var AnimStep=0;var AnimHnd=0;var NSDelay=0;var MenusReady=false;var smHnd=0;var mhdHnd=0;var lsc=null;var imgObj=null;var IsContext=false;var IsFrames=false;var dxFilter=null;var AnimSpeed=35;var TimerHideDelay=200;var smDelay=150;var rmDelay=15;var scDelay=0;var cntxMenu='';var DoFormsTweak=true;var mibc=0;var mibm;var mibs=50;var nsOWH;var mFrame;var cFrame=self;var om=new Array;var nOM=0;var mX;var mY;var BV=parseFloat(navigator.appVersion.indexOf("MSIE")>0?navigator.appVersion.split(";")[1].substr(6):navigator.appVersion);var BN=navigator.appName;var nua=navigator.userAgent;var IsWin=(nua.indexOf('Win')!=-1);var IsMac=(nua.indexOf('Mac')!=-1);var KQ=(BN.indexOf('Konqueror')!=-1&&(BV>=5))||(nua.indexOf('Safari')!=-1);var OP=(nua.indexOf('Opera')!=-1&&BV>=4);var NS=(BN.indexOf('Netscape')!=-1&&(BV>=4&&BV<5)&&!OP);var SM=(BN.indexOf('Netscape')!=-1&&(BV>=5)||OP);var IE=(BN.indexOf('Explorer')!=-1&&(BV>=4)||SM||KQ);if(nua.indexOf("Netscape/8.1")!=-1) document.open=new Function('');var IX=(IE&&IsWin&&!SM&&!OP&&(BV>=5.5)&&(dxFilter!=null)&&(nua.indexOf('CE')==-1));if(!eval(frames['self'])){frames.self=window;frames.top=top;}var tbO=new Array;var tbS=new Array;var tbBorder=new Array;var tbSpacing=new Array;var tbStyle=new Array;var tbAlignment=new Array;var tbMargins=new Array;var tbAttachTo=new Array;var tbSpanning=new Array;var tbFollowHScroll=new Array;var tbFollowVScroll=new Array;var tbFPos=new Array;var lmcHS=null;var tbWidth=new Array;var tbHeight=new Array;var tbVisC=new Array;var sbHnd;var smfHnd;var tpl;var tbt;tbBorder[1]=1;tbSpacing[1]=3;tbStyle[1]=0;tbAlignment[1]=1;tbSpanning[1]=0;tbFollowHScroll[1]=false;tbFollowVScroll[1]=false;tbMargins[1]=[1,132];tbFollowVScroll[1]=false;tbFPos[1]=[0,0];tbVisC[1]=new Function('return true;');tbAttachTo[1]='marker.gif|0';tbWidth[1]=702;tbHeight[1]=38;var tbNum=1;var fx=0;function SetupToolbar(fr){if(!MenusReady){window.setTimeout("SetupToolbar()",10);return false;}var mimg=false;var SMb;var lt=GetLeftTop(cFrame);var wh=GetWidthHeight(cFrame);var er=(wh[0]==0);ClearTimer("sbHnd");for(var t=1;t<=tbNum;t++){SMb=(SM?tbBorder[t]:0);if(fr!=true){if(!tbO[t]){olt=lt;tbO[t]=GetObj("dmbTBBack"+t);if(!tbO[t]) mimg=true;else{if(NS){tbO[t].st=GetObj("dmbTB"+t,tbO[t]);tbS[t]=tbO[t];tbS[t].width=tbS[t].clip.width;tbS[t].height=tbS[t].clip.height;}else{tbO[t].t=GetObj("dmbTB"+t);tbO[t].st=tbO[t].t.style;tbS[t]=tbO[t].style;if(SM&&!OP){tbS[t].width=unic(tbS[t].width,wh[0])-2*SMb+"px";tbS[t].height=unic(tbS[t].height,wh[1])-2*SMb+"px";}FixCommands("dmbTB"+t,t);}}}}if(tbO[t]&&!er){tbl=0;tbt=0;switch(tbAlignment[t]){case 0:break;case 1:tbl=tbStyle[t]==0?(wh[0]-tbWidth[t])/2:(wh[0]-pri(tbS[t].width))/2-SMb;break;case 2:tbl=tbStyle[t]==0?wh[0]-tbWidth[t]:(wh[0]-pri(tbS[t].width))-SMb;break;case 3:tbt=tbStyle[t]==0?(wh[1]-tbHeight[t])/2:(wh[1]-pri(tbS[t].height))/2-SMb;break;case 4:tbl=tbStyle[t]==0?(wh[0]-tbWidth[t])/2:(wh[0]-pri(tbS[t].width))/2-SMb;tbt=tbStyle[t]==0?(wh[1]-tbHeight[t])/2:(wh[1]-pri(tbS[t].height))/2-SMb;break;case 5:tbl=tbStyle[t]==0?wh[0]-tbWidth[t]:(wh[0]-pri(tbS[t].width))-2*SMb;tbt=tbStyle[t]==0?(wh[1]-tbHeight[t])/2:(wh[1]-pri(tbS[t].height))/2-SMb;break;case 6:tbt=(tbStyle[t]==0?wh[1]-pri(tbS[t].height):wh[1]-pri(tbS[t].height))-2*SMb;break;case 7:tbl=tbStyle[t]==0?(wh[0]-tbWidth[t])/2:(wh[0]-pri(tbS[t].width))/2-SMb;tbt=(tbStyle[t]==0?wh[1]-pri(tbS[t].height):wh[1]-pri(tbS[t].height))-2*SMb;break;case 8:tbl=tbStyle[t]==0?wh[0]-tbWidth[t]:(wh[0]-pri(tbS[t].width))-2*SMb;tbt=(tbStyle[t]==0?wh[1]-pri(tbS[t].height):wh[1]-pri(tbS[t].height))-2*SMb;break;case 9:tbl=tbFPos[t][0];tbt=tbFPos[t][1];break;case 10:var imgObj=NS?FindImage(cFrame.document,tbAttachTo[t].split("|")[0]):cFrame.document.images[tbAttachTo[t].split("|")[0]];if(!imgObj){imgObj=GetObj(tbAttachTo[t].split("|")[0]);if(imgObj&&!NS) if(imgObj.style.left) imgObj=imgObj.style;}if(imgObj){tbl=AutoPos(tbO[t],imgObj,pri(tbAttachTo[t].split("|")[1]))[0]+MacOffset(cFrame)[0];tbt =AutoPos(tbO[t],imgObj,pri(tbAttachTo[t].split("|")[1]))[1]+MacOffset(cFrame)[1];}else mimg=true;break;}if(SM){tbl+=-10;tbt+=0;}tbS[t].left=tbl+(tbFollowHScroll[t]?olt[0]:0)+tbMargins[t][0]+(NS?"":"px");tbS[t].top =tbt +(tbFollowVScroll[t]?olt[1]:0)+tbMargins[t][1]+(NS?"":"px");if(tbSpanning[t]==1){if(tbStyle[t]==0){tbO[t].st.left=tbS[t].left;tbS[t].left="0px";tbS[t].width=wh[0]+(tbFollowHScroll[t]?0:lt[0])-2*SMb+(NS?"":"px");}if(tbStyle[t]==1){tbO[t].st.top=tbS[t].top;tbS[t].top="0px";tbS[t].height=wh[1]+(tbFollowVScroll[t]?0:lt[1])-2*SMb+(NS?"":"px");}}tbS[t].visibility=(tbVisC[t]()?"visible":"hidden");tbS[t].display=(tbVisC[t]()?"":"none");if(tbFollowHScroll[t]||tbFollowVScroll[t]) if(ScrollTB(lt,wh,tbO[t])) mimg=false;}}if(NS||SM||mimg||er) sbHnd=window.setTimeout("SetupToolbar()",100);return true;}function getTBPos(t){var xy=[0,0];if(IE){var p=tbO[t].t;while(p){xy[0]+=p.offsetLeft;xy[1]+=p.offsetTop;p=p.offsetParent;}}return xy;}function unic(u,wh){var k=pri(u);return (NS?k:u.indexOf("%")==-1?k:wh*k/100);}function ScrollTB(lt,wh,tb){var s=[true,true];var v=pri(tb.top)+pri(tb.height);var h=pri(tb.left)+pri(tb.width);if(olt[0]!=lt[0]||olt[1]!=lt[1]){var d=[olt[0]-lt[0],olt[1]-lt[1]];if(d[0]<=0) if(h>=(lt[0]+wh[0])) s[0]=false;if(d[1]<=0) if(v>=(lt[1]+wh[1])) s[1]=false;var k=[pri(Math.abs(d[0]/20)+1)*(d[0]>0?-1:1),pri(Math.abs(d[1]/20)+1)*(d[1]>0?-1:1)];for(var i=0;i<2;i++) if(s[i]){olt[i]+=k[i];if(Math.abs(olt[i]-lt[i])<2) olt[i]=lt[i];}ClearTimer("sbHnd");sbHnd=window.setTimeout("SetupToolbar(true)",10);return true;}return false;}function GetHSPos(n,al,mW,mH,t){var tbs0=tbStyle[t]==0;var tp=getTBPos(t);var wh;if(NS){lmcHS.style=lmcHS;wh=[lmcHS.clip.width,lmcHS.clip.height];}else wh=[lmcHS.offsetWidth,lmcHS.offsetHeight];var acc=pri(tbs0?lmcHS.style.left:lmcHS.style.top);var x=(!tbs0&&IsFrames?-wh[0]:tp[0]);var y=(tbs0&&IsFrames?-wh[1]:tp[1]);if(tbs0) x+=acc;else y+=acc;switch(al){case 0:y+=wh[1];break;case 1:x-=(mW-wh[0]);y+=wh[1];break;case 2:y-=mH;break;case 3:x-=(mW-wh[0]);y-=mH;break;case 4:x-=mW;break;case 5:x-=mW;y+=(wh[1]-mH);break;case 6:x+=wh[0];break;case 7:x+=wh[0];y+=(wh[1]-mH);break;case 8:x-=mW;y+=(wh[1]-mH)/2;break;case 9:x+=wh[0];y+=(wh[1]-mH)/2;break;case 10:x+=(wh[0]-mW)/2;y-=mH;break;case 11:x+=(wh[0]-mW)/2;y+=wh[1];break;}if(IsFrames){x+=GetLeftTop()[0];y+=GetLeftTop()[1];}return [x,y];}function hsHoverSel(mode,e){var mc;var fh=false;ClearTimer("smHnd");ClearTimer("smfHnd");if(mode==0){mc=GetCurCmd(e);if(!mc) return false;if(lmcHS==mc) return false;if(lmcHS) hsHoverSel(1,0,1);if(mc!=lmcHS){if(!mc.onmouseover) fh=true;else if(mc.onmouseover.toString().indexOf("ShowMenu")==-1) fh=true;if(fh) smHnd=window.setTimeout("HideAll(1)",mDelay());}FixCursor(mc);lmcHS=mc;}else{mc=lmcHS;lmcHS=null;}SwapMC(mode,mc);return true;}function InitTB(){var dsn=true;var e="";var i,n;for(var t=1;t<=tbNum;t++) if(tbAlignment[t]==10){dsn=false;if(window.onload){e=window.onload.toString();n=e.indexOf("{");e=e.substr(n+1,e.lastIndexOf("}")-n-1);}e+=";SetupToolbar();";window.onload=new Function(e);break;}if(!NS){window.onresize=SetupToolbar;window.onscroll=SetupToolbar;}if(dsn) SetupToolbar();}InitTB();function GetCurCmd(e){var cc=e;while(cc.id==""){cc=cc.parentElement;if(cc==null) break;}return cc;}function HoverSel(mode,e){var mc;var lc;if(nOM==0) return false;ClearTimer("smHnd");if((om[1].pHS != lmcHS)&&om[1].pHS){if(lmcHS) hsHoverSel(1,0,1);lmcHS=om[1].pHS;SwapMC(mode,om[1].pHS);}if(mode==0){if(om[nOM].sc!=null) HoverSel(1);if(nOM>1) if(om[nOM-1].sc!=null){om[nOM-1].ssc=om[nOM-1].sc;SwapMC(1,om[nOM-1].sc);}mc=GetCurCmd(e);if(scDelay){if(!mc.onmouseout) mc.onmouseout=new Function("if(nOM)om[nOM].hsm=window.setTimeout(\"HideSubMenus('"+mc.id+"')\",scDelay)");for(var i=1;i<=nOM;i++) ClearTimer("om["+i+"].hsm");}else HideSubMenus(mc.id);om[nOM].sc=mc;if(nOM>1) if(om[nOM-1].id != gpid(mc)) SwapMC(0,om[nOM-1].ssc);FixCursor(mc);}else{mc=(mode==1)?om[nOM].sc:om[nOM].op;om[nOM].sc=null;}SwapMC(mode,mc);return true;}function HideSubMenus(id){var mc=GetObj(id,mFrame);if(nOM>1){if(mc==om[nOM-1].sc) return false;while(true){if(!nOM) return false;if(gpid(mc)==om[nOM].id) break;Hide();}if(nOM&&scDelay) mc.onmouseover();}}function SwapMC(mode,mc){var id=mc.id.substr(1);var n1=GetObj((mode!=0?"O":"N")+id);n1.style.visibility="hidden";var n2=GetObj((mode==0?"O":"N")+id);n2.style.visibility="inherit";if(mode==0&&!n1.c){n1.c=true;n1=(BV<5?n1.all.tags("DIV"):n1.getElementsByTagName("DIV"))[0];if(n1) (BV<5?n2.all.tags("DIV"):n2.getElementsByTagName("DIV"))[0].innerHTML=n1.innerHTML;}}function Hide(chk){var m;var cl=false;ClearTimer("mhdHnd");ClearTimer("AnimHnd");if(chk)if(InMenu()) return false;if(nOM){m=om[nOM];if(m.sc!=null){if(IE) HoverSel(1);if(NS) NSHoverSel(1);}if(m.op!=null){if(IE) HoverSel(3);if(NS) NSHoverSel(3);}ToggleMenu(m,"hidden");ClearTimer("om[nOM].hsm");nOM--;cl=(nOM==0);if(cl) imgObj=null;}if(cl||chk){ClearTimer("smHnd");if(tbNum&&lmcHS) if(!lmcHS.disable){if(IE) hsHoverSel(1);if(NS) hsNSHoverSel(1);}window.setTimeout("if(!lmcHS)window.status=''",TimerHideDelay);}if((nOM>0||lmcHS)&&!InSelMenu()) mhdHnd=window.setTimeout("Hide(1)",TimerHideDelay/20);return true;}function ToggleMenu(m,s){if(IX) if(document.readyState=="complete"&&m.getAttribute("filters")!=null){if(!m.fs){m.fsn=m.filters.length;m.style.filter=dxFilter+m.style.filter;m.fs=true;}for(var i=0;i<m.filters.length-m.fsn;i++){m.filters[i].apply();m.style.visibility=s;m.filters[i].play();}}m.style.visibility=s;if(s=="hidden"&&!IX&&!NS) m.style.left=m.style.top="0px";FormsTweak(s=="visible"?"hidden":"visible");}function ShowMenu(mName,x,y,isc,hsimg,algn){if(!algn) algn=0;var f=["ShowMenu2('"+mName+"',"+x+","+y+","+isc+",'"+hsimg+"',"+algn+")"];ClearTimer("smHnd");if(isc){if(nOM==0) return false;lsc=om[nOM].sc;f[1]="if(nOM)if(lsc==om[nOM].sc)";f[2]=smDelay;}else{if(nOM>0) if(om[1].id==mName) return false;ClearTimer("mhdHnd");if(algn<0&&!lmcHS) return false;f[1]="HideAll(1);";f[2]=mDelay();}smHnd=window.setTimeout(f[1]+f[0],f[2]);return true;}function ShowMenu2(mName,x,y,isc,hsimg,algn){var xy;x=pri(x);y=pri(y);var Menu=GetObj(mName);if(!Menu) return false;if(Menu==om[nOM]) return false;if(NS) Menu.style=Menu;if(AnimHnd&&nOM>0){AnimStep=100;void(0);}Menu.op=nOM>0?om[nOM].sc:null;Menu.sc=null;imgObj=null;if(isc){if(!NS) HideSubMenus(om[nOM].sc.id);xy=GetSubMenuPos(Menu,algn);if(SM){xy[0]+=0;xy[1]+=0;}var gs=om[nOM].gs;if(gs) xy[1]+=pri(gs.top);}else{if(algn<0&&!lmcHS) return false;Menu.pHS=lmcHS;xy=(algn<0?GetHSPos(x,y,NS?Menu.w:Menu.offsetWidth,NS?Menu.h:Menu.offsetHeight,-algn):[x,y]);if(hsimg){var hss=hsimg.split("|");imgObj=NS?FindImage(cFrame.document,hss[0]):cFrame.document.images[hss[0]];if(imgObj){if(hss[1]&2) xy[0]=AutoPos(Menu,imgObj,algn)[0]+(IsFrames?GetLeftTop()[0]:0)+MacOffset()[0];if(hss[1]&1) xy[1]=AutoPos(Menu,imgObj,algn)[1]+(IsFrames?GetLeftTop()[1]:0)+MacOffset()[1];}}if(SM){xy[0]+=0;xy[1]+=0;}}if(xy){x=xy[0];y=xy[1];}var pWH=[GetWidthHeight()[0]+GetLeftTop()[0],GetWidthHeight()[1]+GetLeftTop()[1]];if(IE) with(Menu.style){if(SM) display="none";left=FixPos(x,pri(width),pWH[0],0)+"px";top=FixPos(y,pri(height),pWH[1],1)+"px";}if(NS){Menu.moveToAbsolute(FixPos(x,Menu.w,pWH[0],0),FixPos(y,Menu.h,pWH[1],1));}Menu.style.zIndex=1000+tbNum+nOM;om[++nOM]=Menu;if(!NS) FixCommands(mName);if(SM) Menu.style.display="inline";if(!IX){if((IE&&IsWin&&!SM)||(NS&&Menu.style.clip.width==0)) AnimHnd=window.setTimeout("void(0)",10);}ToggleMenu(Menu,"visible");IsContext=false;smHnd=0;return true;}function mDelay(){return rmDelay/(nOM==0&&scDelay>0?4:1);}function MacOffset(f){var mo=[0,0];if(!f) f=mFrame;if(IsMac&&IE&&!SM&&!KQ&&(BV>=5)) mo=[pri(f.document.body.leftMargin),pri(f.document.body.topMargin)];return mo;}function aNaN(n){n=pri(n);return isNaN(n)?0:n;}function GetSubMenuPos(mg,a){var x;var y;var pg=om[nOM];var sc=(NS?pg.sc:GetObj("O"+pg.sc.id.substr(1)));if(NS){pg.offsetLeft=pg.left;pg.offsetTop=pg.top;pg.offsetWidth=pg.w;pg.offsetHeight=pg.h;mg.offsetWidth=mg.w;mg.offsetHeight=mg.h;sc.offsetLeft=sc.left;sc.offsetTop=sc.top;sc.offsetWidth=sc.clip.width;sc.offsetHeight=sc.clip.height;}var lp=pg.offsetLeft+sc.offsetLeft;var tp=pg.offsetTop+sc.offsetTop;switch(a){case 0:x=lp;y=tp+sc.offsetHeight;break;case 1:x=lp+sc.offsetWidth-mg.offsetWidth;y=tp+sc.offsetHeight;break;case 2:x=lp;y=tp-mg.offsetHeight;break;case 3:x=lp+sc.offsetWidth-mg.offsetWidth;y=tp-mg.offsetHeight;break;case 4:x=lp-mg.offsetWidth;y=tp;break;case 5:x=lp-mg.offsetWidth;y=tp+sc.offsetHeight-mg.offsetHeight;break;case 6:x=lp+sc.offsetWidth;y=tp;break;case 7:x=lp+sc.offsetWidth;y=tp+sc.offsetHeight-mg.offsetHeight;break;case 8:x=lp-mg.offsetWidth;y=tp+(sc.offsetHeight-mg.offsetHeight)/2;break;case 9:x=lp+sc.offsetWidth;y=tp+(sc.offsetHeight-mg.offsetHeight)/2;break;case 10:x=lp+(sc.offsetWidth-mg.offsetWidth)/2;y=tp-mg.offsetHeight;break;case 11:x=lp+(sc.offsetWidth-mg.offsetWidth)/2;y=tp+sc.offsetHeight;break;}return [x,y];}function FixCommands(mName,t){var b;var en=true;var m=GetObj(mName);var wh;if(!m.fixed){m.fixed=true;if(!t) t=0;if(IE&&(!SM||OP)) en=(document.compatMode=="CSS1Compat");if(en&&t>0&&(!SM||OP)){b=GetBorderSize(tbS[t]);tbS[t].width=Math.abs(aNaN(tbS[t].width)-b[0])+"px";tbS[t].height=Math.abs(aNaN(tbS[t].height)-b[1])+"px";}var sd=(BV<5?m.all.tags("DIV"):m.getElementsByTagName("DIV"));for(var i=0;i<(sd.length);(t>0?i+=2:i++)){sd[i].noWrap=true;if(en) with(sd[i].style){b=GetBorderSize(sd[i].style);if(pri(width)&&pri(height)){width=pri(width)-b[0]+"px";height=pri(height)-b[1]+"px";}}}}}function InTBHotSpot(){var m=(imgObj?imgObj:lmcHS);var tp=[0,0];var tbb;if(!m) return false;if(imgObj) if(imgObj.name.indexOf("dmbHSdyna")!=-1){imgObj=null;return false;}var x=mX;var y=mY;if(!imgObj){if(IE){if(BV<5&&!IsMac) m.parentNode=m.parentElement;}else m.parentNode=m.parentLayer;var i=m.parentNode.id.substr(5);tp=getTBPos(i);if(IE) m=m.style;}else{m.left=GetImgXY(imgObj)[0];m.top=GetImgXY(imgObj)[1];if(NS) m.clip=m;}var l=pri(m.left)+tp[0];var r=l+(IE?pri(m.width):m.clip.width);var t=pri(m.top)+tp[1];var b=t+(IE?pri(m.height):m.clip.height);if(IsFrames&&!NS){x-=GetLeftTop()[0];y-=GetLeftTop()[1];}return ((x>=l&&x<=r)&&(y>=t&&y<=b));}function InMenu(){var m=om[nOM];if(!m) return false;else if(IE) m=m.style;var l=pri(m.left);var r=l+(IE?pri(m.width):m.clip.width);var t=pri(m.top);var b=t+(IE?pri(m.height):m.clip.height);return ((mX>=l&&mX<=r)&&(mY>=t&&mY<=b));}function SetPointerPos(e){if(IE){if(!SM){if(mFrame!=cFrame||event==null){var cfe=cFrame.window.event;var mfe=mFrame.window.event;if(IE&&IsMac) cfe=(cfe.type=="mousemove"?cfe:null);if(IE&&IsMac) mfe=(mfe.type=="mousemove"?mfe:null);if(mfe==null&&cfe==null) return;e=(cfe?cfe:mfe);}else e=event;}mX=e.clientX+lt[0];mY=e.clientY+lt[1];if(!KQ){ClearTimer("cFrame.iefwh");cFrame.iefwh=window.setTimeout("lt=GetLeftTop()",100);}}if(NS){mX=e.pageX;mY=e.pageY;}}function InSelMenu(){var nOMb=nOM--;for(;nOM>0;nOM--) if(om[nOM].sc!=null) break;var im=InMenu();nOM=nOMb;return im||InMenu();}function IsOverMenus(){return (lmcHS||imgObj?InTBHotSpot():(nOM==1?!(om[nOM].sc!=null):false))||(nOM>0?InSelMenu():false);}function HideMenus(e){SetPointerPos(e);if(!IsOverMenus()&&mhdHnd==0) mhdHnd=window.setTimeout("mhdHnd=0;if(!IsOverMenus())Hide()",TimerHideDelay);}function FormsTweak(state){var fe;if(IE&&(!SM||OP)&&DoFormsTweak){var m=om[nOM];if((BV>=5.5)&&!OP&&m&&!KQ) cIF(state=="visible"?"hidden":"visible");else if(nOM==1) for(var f=0;f<mFrame.document.forms.length;f++) for(var e=0;e<mFrame.document.forms[f].elements.length;e++){fe=mFrame.document.forms[f].elements[e];if(fe.type) if(fe.type.indexOf("select")==0) fe.style.visibility=state;}}}function cIF(state){var mfd=mFrame.document;if(mfd.readyState=="complete"){if((mfd.getElementsByTagName("SELECT").length==0)&&(mfd.getElementsByTagName("IFRAME").length==0)) return;var m=om[nOM];var iname=m.id+"iframe";var i=GetObj(iname);if(!i){i=mfd.createElement("?");i.id=iname+"pobj";mfd.body.insertBefore(i);i=mfd.createElement("IFRAME");if(location.protocol=="https:") i.src="/ifo.htm";i.id=iname;i.style.position="absolute";i.style.filter="progid:DXImageTransform.Microsoft.Alpha(opacity=0)";mfd.getElementById(iname+"pobj").insertBefore(i);}with(i.style){m=m.style;left=m.left;top=m.top;width=m.width;height=m.height;zIndex=m.zIndex-1;visibility=state;}}}function execURL(url,tframe){var d=100;if(mibc&&!NS){d+=mibs * mibc;if(lmcHS) mibm=lmcHS;if(nOM) for(var n=nOM;n>0;n--) if(om[n].sc){mibm=om[n].sc;break;}if(mibm){mibm.n=mibc;BlinkItem();}}else HideAll();execURL2(escape(_purl(url)),tframe);}function BlinkItem(){if(!mibm) return;mibm.bs=!Math.abs(mibm.bs);SwapMC(mibm.bs,mibm);mibc--;if(mibc>=0) window.setTimeout("BlinkItem()",mibs);else{mibc=mibm.n;mibm=null;HideAll();}}function execURL2(url,tframe){var w=eval("windo"+"w.ope"+"n");url=rStr(unescape(url));if(url.indexOf("javascript:")!=url.indexOf("vbscript:")) eval(url);else{switch(tframe){case "_self":if(IE&&!SM&&!KQ&&(BV>4)){var a=mFrame.document.createElement("A");a.href=url;mFrame.document.body.appendChild(a);a.click();}else mFrame.location.href=url;break;case "_blank":w(url,tframe);break;default:var f=rStr(tframe);var fObj=(tframe=='_parent'?mFrame.parent:eval(f));if(typeof(fObj)=="undefined") w(url,f.substr(8,f.length-10));else fObj.location.href=url;break;}}}function rStr(s){s=xrep(s,"%1E","'");s=xrep(s,"\x1E","'");if(OP&&s.indexOf("frames[")!=-1) s=xrep(s,String.fromCharCode(s.charCodeAt(7)),"'");return xrep(s,"\x1D","\x22");}function HideAll(dr){var o=lmcHS;if(dr) lmcHS=null;Hide();while(nOM>0) Hide();lmcHS=o;}function tHideAll(){ClearTimer("mhdHnd");mhdHnd=window.setTimeout("mhdHnd=0;if(!InSelMenu())HideAll();",TimerHideDelay);}function GetLeftTop(f){if(!f) f=mFrame;if(IE) if(SM) return [OP?f.pageXOffset:f.scrollX,OP?f.pageYOffset:f.scrollY];else{var b=GetBodyObj(f);return (b?[b.scrollLeft,b.scrollTop]:[0,0]);}if(NS) return [f.pageXOffset,f.pageYOffset];}function GetWidthHeight(f){var k=0;if(!f) f=mFrame;if(NS||SM){return [f.innerWidth,f.innerHeight];}else{var b=GetBodyObj(f);return (b?[b.clientWidth,b.clientHeight]:[0,0]);}}function GetBodyObj(f){if(!f.bo) f.bo=(f.document.compatMode=="BackCompat"||BV<6||IsMac)?f.document.body:f.document.documentElement;return f.bo;}function GetBorderSize(s){return [(s.borderLeftStyle==""||s.borderLeftStyle=="none"?0:pri(s.borderLeftWidth))+(s.borderRightStyle==""||s.borderRightStyle=="none"?0:pri(s.borderRightWidth)),(s.borderTopStyle==""||s.borderTopStyle=="none"?0:pri(s.borderTopWidth))+(s.borderBottomStyle==""||s.borderBottomStyle=="none"?0:pri(s.borderBottomWidth))];}function AutoPos(m,img,arl){var x=GetImgXY(img)[0];var y=GetImgXY(img)[1];var iWH=GetImgWH(img);var mW=(NS?m.w:m.offsetWidth);var mH=(NS?m.h:m.offsetHeight);switch(arl){case 0:y+=iWH[1];break;case 1:x+=iWH[0]-mW;y+=iWH[1];break;case 2:y-=mH;break;case 3:x+=iWH[0]-mW;y-=mH;break;case 4:x-=mW;break;case 5:x-=mW;y-=mH-iWH[1];break;case 6:x+=iWH[0];break;case 7:x+=iWH[0];y-=mH-iWH[1];break;case 8:x-=mW;y+=(iWH[1]-mH)/2;break;case 9:x+=iWH[0];y+=(iWH[1]-mH)/2;break;case 10:x+=(iWH[0]-mW)/2;y-=mH;break;case 11:x+=(iWH[0]-mW)/2;y+=iWH[1];break;}return [x,y];}function GetImgXY(img){var x;var y;if(NS){y=GetImgOffset(cFrame,img.name,0,0);x=img.x+y[0];y=img.y+y[1];}else{y=getOffset(img);x=y[0];y=y[1];}return [x,y];}function GetImgWH(img){return [pri(img.width),pri(img.height)];}function getOffset(img){var xy=[img.offsetLeft,img.offsetTop];var ce=img.offsetParent;while(ce!=null){xy[0]+=ce.offsetLeft;xy[1]+=ce.offsetTop;ce=ce.offsetParent;}return xy;}function ShowContextMenu(e){if(IE){SetPointerPos(e);IsContext=true;}else if(e.which==3){IsContext=true;mX=e.x;mY=e.y;}if(IsContext){HideAll();cFrame.ShowMenu2(cntxMenu,mX-1,mY-1,false);return false;}return true;}function SetUpEvents(){nOM=0;if(!SM) onerror=errHandler;if(!mFrame) mFrame=cFrame;if(typeof(mFrame)=="undefined"||(NS&&(++NSDelay<2))) window.setTimeout("SetUpEvents()",10);else{IsFrames=(cFrame!=mFrame);if(NS){mFrame.captureEvents(Event.MOUSEMOVE);mFrame.onmousemove=HideMenus;if(cntxMenu!=""){mFrame.window.captureEvents(Event.MOUSEDOWN);mFrame.window.onmousedown=ShowContextMenu;}nsOWH=GetWidthHeight();window.onresize=rHnd;PrepareEvents();}if(IE){document.onmousemove=HideMenus;mFrame.document.onmousemove=document.onmousemove;if(cntxMenu) mFrame.document.oncontextmenu=ShowContextMenu;if(IsFrames) mFrame.window.onunload=new Function("mFrame=null;SetUpEvents()");cFrame.lt=[0,0];}MenusReady=true;}return true;}function errHandler(sMsg,sUrl,sLine){if(sMsg.substr(0,16)!="Access is denied"&&sMsg!="Permission denied"&&sMsg.indexOf("cursor")==-1) alert("Java Script Error\n"+      "\nDescription:"+sMsg+      "\nSource:"+sUrl+      "\nLine:"+sLine);return true;}function FixPos(v,s,r,k){var n;if(nOM==0||k==1) n=(v+s>r)?r-s:v;else n=(v+s>r)?pri(om[nOM].style.left)-s:v;return (n<0)?0:n;}function ClearTimer(t,f){if(!f) cFrame.f=cFrame;if(eval(t)) eval("cFrame.f.clearTimeout("+t+");"+t+"=0");}function xrep(s,f,n){if(s) s=s.split(f).join(n);return s;}function FixCursor(mc){if(!OP){var os=GetObj("O"+mc.id.substr(1)).style;var s=os.cursor;if(s=="") os.cursor=(BV<6?"hand":s.split("cursor:url(")[1].split(")")[0]);}}function GetObj(oName,f,sf,r){var obj=null;if(!f) if(IsFrames&&tbNum){if(!sf) sf=window.parent;for(var i=0;i<sf.frames.length;i++){f=sf.frames[i];if(!(obj=GetObj(oName,f))&&f.length) if(obj=GetObj(oName,null,f,true)){f=obj[1];obj=obj[0];}if(obj) break;}if(obj){f.cFrame=cFrame;if(tbNum>0){if(NS)     f.hsNSHoverSel=hsNSHoverSel;else     f.hsHoverSel=hsHoverSel;}f.execURL=execURL;}}else f=mFrame;if(NS) obj=f.document.layers[oName];else{obj=(BV>=5?f.document.getElementById(oName):f.document.all[oName]);if(obj) if(obj.id!=oName) obj=null;}return r?[obj,f]:obj;}function gpid(o){return (BV>=5?o.parentNode.parentNode.id:o.parentElement.parentElement.id);}if(IE) with(document){open();write(xrep(Expand("<div id=dmbTBBack1overflow:hidden;z-index:998;visibility:hidden;width:70238px;-moz-opacity:0.96Shadow(direction=135,strength=2,color=#891919) Alpha(96);border:1px solid ;\"><div id=dmbTB1 style=\"position:relative;z-index:999;left:1px;top:1pxAlpha(96);width:70234px;\"001top:005434*11$http://www.cantonsymphony.org\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org\',\'_self#9483Home><div&1001top:005434*11http://www.cantonsymphony.org\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org\',\'_self#9483002top:05712334*11; Group002\',2,11,false,\'\',-1);\"11173Concerts and <br>tickets><div&1002top:05712334*11 !Group002\',2,11,false,\'\',-1);\"11173003top:01835234*11; Group040\',3,11,false,\'\',-1);\"http://www.cantonsymphony.org/news.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/news.htm\',\'_self#9463News><div&1003top:01835234*11 !Group040\',3,11,false,\'\',-1);\"http://www.cantonsymphony.org/news.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/news.htm\',\'_self#9463004top:02388834*11; Group005\',4,11,false,\'\',-1);\"9823Musicians><div&1004top:02388834*11 !Group005\',4,11,false,\'\',-1);\"9823005top:03298134*11; Group008\',5,11,false,\'\',-1);\"9753About Us><div&1005top:03298134*11 !Group008\',5,11,false,\'\',-1);\"9753006top:04137334*11; Group010\',6,11,false,\'\',-1);\"9673Support><div&1006top:04137334*11 !Group010\',6,11,false,\'\',-1);\"9673007top:04899134*11; Group006\',7,11,false,\'\',-1);\"9853Education><div&1007top:04899134*11 !Group006\',7,11,false,\'\',-1);\"9853008top:058311534*11$http://www.cantonsymphony.org/employment.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/employment.htm\',\'_self#11093Employment/<br>Auditions><div&1008top:058311534*11http://www.cantonsymphony.org/employment.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/employment.htm\',\'_self#11093>>"),'%'+'%REL%%',rimPath));close();}if(IE) with(document){open();write(xrep(Expand("<div id=\"Group039002-1	\"Group039frmt002-1px#1F0506;\">Group00200127288	\"Group002frmt00127288px#1F0506;\"0112534*110%11231Classical <br>Concerts0112534*11&0http://www.cantonsymphony.org/classicalconcerts.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/classicalconcerts.htm\',\'_self#1123135112534*111%11231Cameo<br> Concerts35112534*11&1http://www.cantonsymphony.org/cameoconcerts.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/cameoconcerts.htm\',\'_self#1123170112534*112%11231Casual Friday<br>Concerts70112534*11&2http://www.cantonsymphony.org/casualFridays.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/casualFridays.htm\',\'_self#11231105112518*113%11231Santa at the Symphony105112518*11&3http://www.cantonsymphony.org/familychristmasglitter.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/familychristmasglitter.htm\',\'_self#11231124112518*114%11231Holiday Brass124112518*11&4http://www.cantonsymphony.org/holidaybrass.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/holidaybrass.htm\',\'_self#11231143112534*115%11231Choral<br>Concerts143112534*11&5http://www.cantonsymphony.org/choralconcerts.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/choralconcerts.htm\',\'_self#11231178112518*116%11231Youth Symphony178112518*11&6http://www.cantonsymphony.org/youthsymphony.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/youthsymphony.htm\',\'_self#11231197112534*117%11231Educational <br>Programs197112534*11&7http://www.cantonsymphony.org/educationprograms.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/educationprograms.htm\',\'_self#11231232112518*118%11231Seating Charts232112518*11&8http://www.cantonsymphony.org/charts.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/charts.htm\',\'_self#11231251112518*119%11231Search for Tickets251112518*11&9https://secure.velvetseat.com/clients/default.asp?clientId=236043\',\'_self# OnDblClick=\"cFrame.execURL(\'https://secure.velvetseat.com/clients/default.asp?clientId=236043\',\'_self#11231270112518*1110%11231Our Venues270112518*11&10http://www.cantonsymphony.org/venues.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/venues.htm\',\'_self#11231>Group00600134180	\"Group006frmt00134180px#1F0506;\"0113218*1111SubGrp_Con012(6);\"11301 Concerts0113218*11&11http://www.cantonsymphony.org/educationprograms.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/educationprograms.htm\',\'_self#1130119113234*1112%11301Teachers\' <br>Guides19113234*11&12http://www.cantonsymphony.org/teachersguides.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/teachersguides.htm\',\'_self#1130154113234*1113%11301Youth <br>Symphony54113234*11&13http://www.cantonsymphony.org/youthsymphony.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/youthsymphony.htm\',\'_self#1130189113218*1114%11301Steel Band89113218*11&14http://www.cantonsymphony.org/steelband.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/steelband.htm\',\'_self#11301108113234*1115%11301Listen@the Library <br>Storytelling for children108113234*11&15http://www.cantonsymphony.org/listenlibrarychildren.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/listenlibrarychildren.htm\',\'_self#11301143113218*1116%11301Sites for Children143113218*11&16http://www.cantonsymphony.org/children.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/children.htm\',\'_self#11301162113218*1117SubGrp_AduPro013(6);\"11301Adult Programs162113218*11&17adulteducation.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'%%REP%%adulteducation.htm\',\'_self#11301>Group0100010575	\"Group010frmt0010575px#1F0506;\"0110318*1118SubGrp_Vol037(6);\"11011Volunteer!0110318*11&18\',\'_self#1101119110318*1119%11011Corporate Support19110318*11&19http://www.cantonsymphony.org/corporatesponsorships.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/corporatesponsorships.htm\',\'_self#1101138110318*1120%11011Education Support38110318*11&20http://www.cantonsymphony.org/educationsponsorships.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/educationsponsorships.htm\',\'_self#1101157110318*1121%11011Individual Giving57110318*11&21http://www.cantonsymphony.org/contribute.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/contribute.htm\',\'_self#11011>Group0080084110	\"Group008frmt0084110px#1F0506;\"018218*1122%1801History018218*11&22http://www.cantonsymphony.org/history.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/history.htm\',\'_self#18011918218*1123%1801Trustees1918218*11&23http://www.cantonsymphony.org/trustees.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/trustees.htm\',\'_self#18013818234*1124%1801Administrative <br>Staff3818234*11&24http://www.cantonsymphony.org/administrativestaff.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/administrativestaff.htm\',\'_self#18017318218*1125%1801Our Venues7318218*11&25http://www.cantonsymphony.org/venues.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/venues.htm\',\'_self#18019218218*1126%1801Contact Us9218218*11&26http://www.cantonsymphony.org/contactus.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/contactus.htm\',\'_self#1801>Group0050010991	\"Group005frmt0010991px#1F0506;\"0110718*1127SubGrp_TheCon039(6);\"11051Conductors   0110718*11&27\',\'_self# OnDblClick=\"cFrame.execURL(\'%%REP%%archivednewsreleases.htm\',\'_self#1105119110718*1128%11051Orchestra Members19110718*11&28http://www.cantonsymphony.org/orchestraroster.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/orchestraroster.htm\',\'_self#1105138110718*1129%11051Chorus38110718*11&29http://www.cantonsymphony.org/chorus.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'%%REP%%\',\'_self#1105157110734*1130%11051Youth <br>Symphony57110734*11&30http://www.cantonsymphony.org/youthsymphony.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/youthsymphony.htm\',\'_self#11051>Group040006049	\"Group040frmt006049px#1F0506;\"015824*1131%4447Current015824*11&31http://www.cantonsymphony.org/news.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantosymphony.org/news.htm\',\'_self#44472515824*1132%4447Archived2515824*11&32http://www.cantonsymphony.org/news/archive20067/archivednewsreleases2006-2007.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/news/archive20067/archivednewsreleases2006-2007.htm\',\'_self#4447>Group038002-1	\"Group038frmt002-1px#1F0506;\">SubGrp_TheCon0390013674	\"SubGrp_TheCon039frmt0013674px#1F0506;\"0113424*1133%41207Gerhardt Zimmermann0113424*11&33http://www.cantonsymphony.org/zimmermann.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/zimmermann.htm\',\'_self#4120725113424*1134%41207C. M. Shearer25113424*11&34http://www.cantonsymphony.org/shearer.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/shearer.htm\',\'_self#4120750113424*1135%41207Matthew Brown50113424*11&35http://www.cantonsymphony.org/brown.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/brown.htm\',\'_self#41207>SubGrp_Vol0370011524	\"SubGrp_Vol037frmt0011524px#1F0506;\"0111324*1136%4997Symphony League0111324*11&36http://www.cantonsymphony.org/symphonyleague.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/Symphonyleague.htm\',\'_self#4997>SubGrp_Con012002-1	\"SubGrp_Con012frmt002-1px#1F0506;\">SubGrp_AduPro0130013874	\"SubGrp_AduPro013frmt0013874px#1F0506;\"0113624*1137%41227Conversations in Music0113624*11&37http://www.cantonsymphony.org/conversations.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/conversations.htm\',\'_self#4122725113624*1138%41227Listen@the Liberary25113624*11&38http://www.cantonsymphony.org/listenlibrary.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/listenlibrary.htm\',\'_self#4122750113624*1139%41227Performance Preludes50113624*11&39preludes.htm\',\'_self# OnDblClick=\"cFrame.execURL(\'http://www.cantonsymphony.org/preludes.htm\',\'_self#41227>>"),'%'+'%REL%%',rimPath));close();}Expand('');SetUpEvents();
function Expand(c){var x;x="#000000";c=xrep(c,"",x);x="#FFFFFF";c=xrep(c,"",x);x="#CA1802";c=xrep(c,"",x);x="\" style=\"position:absolute;top:";c=xrep(c,"",x);x="px;left:";c=xrep(c,"",x);x="px;width:";c=xrep(c,"",x);x="px;height:";c=xrep(c,"",x);x="px;visibility:hidden;";c=xrep(c,"	",x);x="progid:DXImageTransform.Microsoft.";c=xrep(c,"",x);x="opacity=";c=xrep(c,"",x);x=";background-color:";c=xrep(c,"",x);x="px;white-space:nowrap;font-family:";c=xrep(c,"",x);x=";font-size:";c=xrep(c,"",x);x="px;font-weight:normal;font-style:normal;text-decoration:none;color:";c=xrep(c,"",x);x="px;font-weight:bold;font-style:normal;text-decoration:none;color:";c=xrep(c,"",x);x=";\" id=N";c=xrep(c,"",x);x="><div style=\"position:absolute;top:";c=xrep(c,"",x);x="px;\" align=left>";c=xrep(c,"",x);x="px;\" align=center>";c=xrep(c,"",x);x=";cursor:default;visibility:hidden;\"";c=xrep(c,"",x);x="</div></div";c=xrep(c,"",x);x=" OnClick=\"cFrame.execURL(\'%%REP%%";c=xrep(c,"",x);x=" OnClick=\"cFrame.execURL(\'";c=xrep(c,"",x);x="><div id=\"";c=xrep(c,"",x);x=" OnMouseOver=\"cFrame.HoverSel(0,this);cFrame.ShowMenu(\'";c=xrep(c,"",x);x=";filter:";c=xrep(c,"",x);x="><div id=N1";c=xrep(c,"",x);x=" style=\"position:absolute;";c=xrep(c,"",x);x="\" OnMouseOver=\"hsHoverSel(0,this);cFrame.ShowMenu(\'";c=xrep(c," ",x);x="OnMouseOver=\"cFrame.ShowMenu(\'";c=xrep(c,"!",x);x="\');\"";c=xrep(c,"#",x);x=";\" OnMouseOver=\"hsHoverSel(0,this);\"";c=xrep(c,"$",x);x=" OnMouseOver=\"cFrame.HoverSel(0,this);\"";c=xrep(c,"%",x);x=" id=O";c=xrep(c,"&",x);x="\',0,0,true,\'\',";c=xrep(c,"(",x);x="\'Trebuchet MS\'";c=xrep(c,"*",x);return c;}function pri(n){return parseInt(n)}