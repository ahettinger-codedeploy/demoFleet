var nTCode=new Array;var AnimStep=0;var AnimHnd=0;var NSDelay=0;var MenusReady=false;var smHnd=0;var mhdHnd=0;var lsc=null;var imgObj=null;var IsContext=false;var IsFrames=false;var dxFilter=null;var AnimSpeed=35;var TimerHideDelay=200;var smDelay=150;var rmDelay=15;var scDelay=0;var cntxMenu='';var DoFormsTweak=true;var mibc=0;var mibm;var mibs=0;var nsOWH;var mFrame;var cFrame=self;var om=new Array;var nOM=0;var mX;var mY;var BV=parseFloat(navigator.appVersion.indexOf("MSIE")>0?navigator.appVersion.split(";")[1].substr(6):navigator.appVersion);var BN=navigator.appName;var nua=navigator.userAgent;var IsWin=(nua.indexOf('Win')!=-1);var IsMac=(nua.indexOf('Mac')!=-1);var KQ=(BN.indexOf('Konqueror')!=-1&&(BV>=5))||(nua.indexOf('Safari')!=-1);var OP=(nua.indexOf('Opera')!=-1&&BV>=4);var NS=(BN.indexOf('Netscape')!=-1&&(BV>=4&&BV<5)&&!OP);var SM=(BN.indexOf('Netscape')!=-1&&(BV>=5)||OP);var IE=(BN.indexOf('Explorer')!=-1&&(BV>=4)||SM||KQ);var IX=(IE&&IsWin&&!SM&&!OP&&(BV>=5.5)&&(dxFilter!=null)&&(nua.indexOf('CE')==-1));if(!eval(frames['self'])){frames.self=window;frames.top=top;}var tbO=new Array;var tbS=new Array;var tbB=new Array;var tbSpacing=new Array;var tbY=new Array;var tbAlignment=new Array;var tbMargins=new Array;var tbAttachTo=new Array;var tbK=new Array;var tbFollowHScroll=new Array;var tbFollowVScroll=new Array;var tbFPos=new Array;var lmcHS=null;var tbW=new Array;var tbH=new Array;var tbVisC=new Array;var sbHnd;var smfHnd;var tpl;var tbt;tbB[1]=1;tbSpacing[1]=1;tbY[1]=0;tbAlignment[1]=11;tbK[1]=0;tbFollowHScroll[1]=false;tbFollowVScroll[1]=false;tbMargins[1]=[0,0];tbFollowVScroll[1]=false;tbFPos[1]=[0,0];tbVisC[1]=new Function('return true;');tbW[1]=743;tbH[1]=25;var tbNum=1;var fx=0;nTCode[6]="cFrame.execURL('%%REP%%mission.htm','_self');";nTCode[7]="cFrame.execURL('%%REP%%governance.htm','_self');";nTCode[8]="cFrame.execURL('%%REP%%artisticprofessionals.htm','_self');";nTCode[9]="cFrame.execURL('%%REP%%technicalprofessionals.htm','_self');";nTCode[10]="cFrame.execURL('%%REP%%repertoire.htm','_self');";nTCode[11]="cFrame.execURL('%%REP%%membership.htm','_self');";nTCode[14]="cFrame.execURL('%%REP%%TheSchool.htm','_self');";nTCode[15]="cFrame.execURL('%%REP%%ScheduleofClasses.htm','_self');";nTCode[16]="cFrame.execURL('%%REP%%Season2006.htm','_self');";nTCode[17]="cFrame.execURL('%%REP%%GeneralSchoolInformation.htm','_self');";nTCode[18]="cFrame.execURL('%%REP%%Philharmonic.htm','_self');";nTCode[19]="cFrame.execURL('%%REP%%Nutcracker.htm','_self');";nTCode[20]="cFrame.execURL('%%REP%%giselle.htm','_self');";nTCode[21]="cFrame.execURL('%%REP%%FineArtsFiesta.htm','_self');";nTCode[22]="cFrame.execURL('%%REP%%YoungDancers.htm','_self');";nTCode[23]="cFrame.execURL('mailto:BNE@balletnortheast.org','_self');";nTCode[24]="cFrame.execURL('mailto:DBC@balletnortheast.org','_self');";nTCode[25]="cFrame.execURL('mailto:brian.newirth@balletnortheast.org','_self');";nTCode[1007]="cFrame.execURL('%%REP%%index9.htm','_self');";function f6(fr){if(!MenusReady){window.setTimeout("f6()",10);return false;}var mimg=false;var SMb;var lt=f14(cFrame);var wh=f1(cFrame);var er=(wh[0]==0);f18("sbHnd");for(var t=1;t<=tbNum;t++){SMb=(SM?tbB[t]:0);if(fr!=true){if(!tbO[t]){olt=lt;tbO[t]=f40("dmbTBBack"+t);if(!tbO[t]) mimg=true;else{if(NS){tbO[t].st=f40("dmbTB"+t,tbO[t]);tbS[t]=tbO[t];tbS[t].width=tbS[t].clip.width;tbS[t].height=tbS[t].clip.height;}else{tbO[t].st=f40("dmbTB"+t).style;tbS[t]=tbO[t].style;if(SM&&!OP){tbS[t].width=unic(tbS[t].width,wh[0])-2*SMb+"px";tbS[t].height=unic(tbS[t].height,wh[1])-2*SMb+"px";}FixCommands("dmbTB"+t,t);}}}}if(tbO[t]&&!er){tbl=0;tbt=0;switch(tbAlignment[t]){}tbS[t].left=tbl+(tbFollowHScroll[t]?olt[0]:0)+tbMargins[t][0]+(NS?"":"px");tbS[t].top =tbt +(tbFollowVScroll[t]?olt[1]:0)+tbMargins[t][1]+(NS?"":"px");if(tbK[t]==1){if(tbY[t]==0){tbO[t].st.left=tbS[t].left;tbS[t].left="0px";tbS[t].width=wh[0]+(tbFollowHScroll[t]?0:lt[0])-2*SMb+(NS?"":"px");}if(tbY[t]==1){tbO[t].st.top=tbS[t].top;tbS[t].top="0px";tbS[t].height=wh[1]+(tbFollowVScroll[t]?0:lt[1])-2*SMb+(NS?"":"px");}}tbS[t].visibility=(tbVisC[t]()?"visible":"hidden");if(tbFollowHScroll[t]||tbFollowVScroll[t]) if(f29(lt,wh,tbO[t])) mimg=false;}}if(NS||SM||mimg||er) sbHnd=window.setTimeout("f6()",100);return true;}function f28(t){var xy=[pri(tbO[t].st.left)+(NS?tbO[t].x:tbO[t].offsetLeft)+tbB[t],pri(tbO[t].st.top)+(NS?tbO[t].y:tbO[t].offsetTop)+tbB[t]];if(IE){var p=tbO[t];while(true){p=p.parentNode;if(!p) break;if(!p.style) break;if(p.style.position){xy[0]+=p.offsetLeft;xy[1]+=p.offsetTop;}}}return xy;}function unic(u,wh){var k=pri(u);return (NS?k:u.indexOf("%")==-1?k:wh*k/100);}function f29(lt,wh,tb){var s=[true,true];var v=pri(tb.top)+pri(tb.height);var h=pri(tb.left)+pri(tb.width);if(olt[0]!=lt[0]||olt[1]!=lt[1]){var d=[olt[0]-lt[0],olt[1]-lt[1]];if(d[0]<=0) if(h>=(lt[0]+wh[0])) s[0]=false;if(d[1]<=0) if(v>=(lt[1]+wh[1])) s[1]=false;var k=[pri(Math.abs(d[0]/20)+1)*(d[0]>0?-1:1),pri(Math.abs(d[1]/20)+1)*(d[1]>0?-1:1)];for(var i=0;i<2;i++) if(s[i]){olt[i]+=k[i];if(Math.abs(olt[i]-lt[i])<2) olt[i]=lt[i];}f18("sbHnd");sbHnd=window.setTimeout("f6(true)",10);return true;}return false;}function f30(n,al,mW,mH,t){var tbs0=tbY[t]==0;var tp=f28(t);var wh;if(NS){lmcHS.style=lmcHS;wh=[lmcHS.clip.width,lmcHS.clip.height];}else wh=[lmcHS.offsetWidth,lmcHS.offsetHeight];var acc=pri(tbs0?lmcHS.style.left:lmcHS.style.top);var x=(!tbs0&&IsFrames?-wh[0]:tp[0]);var y=(tbs0&&IsFrames?-wh[1]:tp[1]);if(tbs0) x+=acc;else y+=acc;switch(al){case 0:y+=wh[1];break;}if(IsFrames){x+=f14()[0];y+=f14()[1];}return [x,y];}function f8(mode,mc,bcolor){var mcN;if(mode==0){if(lmcHS) f8(1);mcN=mc.parentLayer.layers[mc.name.substr(0,mc.name.indexOf("EH"))+"N"];mcN.mcO=mc.parentLayer.layers[mc.name.substr(0,mc.name.indexOf("EH"))+"O"];if(mcN!=lmcHS) f36();if(nOM>1) if(mcN==om[nOM-1].sc) return false;mcN.mcO.visibility="show";mcN.visibility="hide";lmcHS=mcN;}else{mcN=lmcHS;mcN.visibility="show";mcN.mcO.visibility="hide";lmcHS=null;}return true;}function f39(){var dsn=true;var e="";var i,n;for(var t=1;t<=tbNum;t++) if(tbAlignment[t]==10){dsn=false;if(window.onload){e=window.onload.toString();n=e.indexOf("{");e=e.substr(n+1,e.lastIndexOf("}")-n-1);}e+=";f6();";window.onload=new Function(e);break;}if(!NS){window.onresize=f6;window.onscroll=f6;}if(dsn) f6();}f39();function f10(id){var mc=f40(id);if(nOM>1){if(mc==om[nOM-1].sc) return false;while(true){if(!nOM) return false;if(gpid(mc)==om[nOM].id) break;Hide();}if(nOM&&scDelay) mc.onmouseover();}}function f15(mode,mc){var mcN;var mn;f18("smHnd");if(!nOM) return false;if(mode==0&&om[nOM].sc!=null) f15(1);if(mode==0){mn=mc.name.substr(0,mc.name.indexOf("EH"));mcN=mc.parentLayer.layers[mn+"N"];mcN.mcO=mc.parentLayer.layers[mn+"O"];if(nOM>1) if(mc==om[nOM-1].sc) return false;while(!f38()&&nOM>1) Hide();om[nOM].sc=mcN;mcN.mcO.visibility="show";mcN.visibility="hide";}else{mcN=(mode==1)?om[nOM].sc:om[nOM].op;mcN.visibility="show";mcN.mcO.visibility="hide";om[nOM].sc=null;}return true;}function Hide(chk){var m;var cl=false;f18("mhdHnd");f18("AnimHnd");if(chk)if(f38()) return false;if(nOM){m=om[nOM];if(m.sc!=null){if(IE) HoverSel(1);if(NS) f15(1);}if(m.op!=null){if(IE) HoverSel(3);if(NS) f15(3);}f17(m,"hidden");f18("om[nOM].hsm");nOM--;cl=(nOM==0);if(cl) imgObj=null;}if(cl||chk){f18("smHnd");if(tbNum&&lmcHS) if(!lmcHS.disable){if(IE) hsHoverSel(1);if(NS) f8(1);}window.setTimeout("if(!lmcHS)window.status=''",TimerHideDelay);}if((nOM>0||lmcHS)&&!f24()) mhdHnd=window.setTimeout("Hide(1)",TimerHideDelay/20);return true;}function f17(m,s){if(IX) if(document.readyState=="complete"&&m.getAttribute("filters")!=null){if(!m.fs){m.fsn=m.filters.length;m.style.filter=dxFilter+m.style.filter;m.fs=true;}for(var i=0;i<m.filters.length-m.fsn;i++){m.filters[i].apply();m.style.visibility=s;m.filters[i].play();}}m.style.visibility=s;if(s=="hidden"&&!IX&&!NS) m.style.left=m.style.top="0px";f19(s=="visible"?"hidden":"visible");}function ShowMenu(mName,x,y,isc,hsimg,algn){if(!algn) algn=0;var f=["f21('"+mName+"',"+x+","+y+","+isc+",'"+hsimg+"',"+algn+")"];f18("smHnd");if(isc){if(nOM==0) return false;lsc=om[nOM].sc;f[1]="if(nOM)if(lsc==om[nOM].sc)";f[2]=smDelay;}else{if(nOM>0) if(om[1].id==mName) return false;f18("mhdHnd");if(algn<0&&!lmcHS) return false;f[1]="f36(1);";f[2]=f41();}smHnd=window.setTimeout(f[1]+f[0],f[2]);return true;}function f21(mName,x,y,isc,hsimg,algn){var xy;x=pri(x);y=pri(y);var Menu=f40(mName);if(!Menu) return false;if(Menu==om[nOM]) return false;if(NS) Menu.style=Menu;if(AnimHnd&&nOM>0){AnimStep=100;f35();}Menu.op=nOM>0?om[nOM].sc:null;Menu.sc=null;imgObj=null;if(isc){if(!NS) f10(om[nOM].sc.id);xy=f2(Menu,algn);var gs=om[nOM].gs;if(gs) xy[1]+=pri(gs.top);}else{Menu.pHS=lmcHS;xy=(algn<0?f30(x,y,NS?Menu.w:Menu.offsetWidth,NS?Menu.h:Menu.offsetHeight,-algn):[x,y]);if(hsimg){var hss=hsimg.split("|");imgObj=NS?f20(cFrame.document,hss[0]):cFrame.document.images[hss[0]];if(imgObj){if(hss[1]&2) xy[0]=f34(Menu,imgObj,algn)[0]+(IsFrames?f14()[0]:0)+f25()[0];if(hss[1]&1) xy[1]=f34(Menu,imgObj,algn)[1]+(IsFrames?f14()[1]:0)+f25()[1];}}}if(xy){x=xy[0];y=xy[1];}var pWH=[f1()[0]+f14()[0],f1()[1]+f14()[1]];if(IE) with(Menu.style){if(SM) display="none";left=f37(x,pri(width),pWH[0],0)+"px";top=f37(y,pri(height),pWH[1],1)+"px";if(!IX&&!SM&&IsWin) clip="rect(0 0 0 0)";}if(NS){Menu.clip.width=0;Menu.clip.height=0;Menu.moveToAbsolute(f37(x,Menu.w,pWH[0]),f37(y,Menu.h,pWH[1]));}Menu.style.zIndex=1000+tbNum+nOM;om[++nOM]=Menu;if(!NS) FixCommands(mName);if(SM) Menu.style.display="inline";if(!IX){if((IE&&IsWin&&!SM)||(NS&&Menu.style.clip.width==0)) AnimHnd=window.setTimeout("f35()",10);}f17(Menu,"visible");IsContext=false;smHnd=0;return true;}function f41(){return rmDelay/(nOM==0&&scDelay>0?4:1);}function f25(f){var mo=[0,0];if(!f) f=mFrame;if(IsMac&&IE&&!SM&&!KQ&&(BV>=5)) mo=[pri(f.document.body.leftMargin),pri(f.document.body.topMargin)];return mo;}function f2(mg,a){var x;var y;var pg=om[nOM];var sc=(NS?pg.sc:f40("O"+pg.sc.id.substr(1)));if(NS){pg.offsetLeft=pg.left;pg.offsetTop=pg.top;pg.offsetWidth=pg.w;pg.offsetHeight=pg.h;mg.offsetWidth=mg.w;mg.offsetHeight=mg.h;sc.offsetLeft=sc.left;sc.offsetTop=sc.top;sc.offsetWidth=sc.clip.width;sc.offsetHeight=sc.clip.height;}var lp=pg.offsetLeft+sc.offsetLeft;var tp=pg.offsetTop+sc.offsetTop;switch(a){}return [x,y];}function f35(){var r='';var nw=nh=0;if(AnimStep+AnimSpeed>100) AnimStep=100;switch(fx){case 1:if(IE) r="0 "+AnimStep+"% "+AnimStep+"% 0";if(NS) nw=AnimStep;nh=AnimStep;break;case 2:if(IE) r="0 100% "+AnimStep+"% 0";if(NS) nw=100;nh=AnimStep;break;case 3:if(IE) r="0 "+AnimStep+"% 100% 0";if(NS) nw=AnimStep;nh=100;break;case 0:if(IE) r="0 100% 100% 0";if(NS) nw=100;nh=100;break;}if(om[nOM]){with(om[nOM].style){if(IE) clip="rect("+r+")";if(NS){clip.width=w*(nw/100);clip.height=h*(nh/100);}}AnimStep+=AnimSpeed;if(AnimStep<=100) AnimHnd=window.setTimeout("f35()",25);else{f18("AnimHnd");AnimStep=0;AnimHnd=0;}}}function f12(){var m=(imgObj?imgObj:lmcHS);var tp=[0,0];var tbb;if(!m) return false;if(imgObj) if(imgObj.name.indexOf("dmbHSdyna")!=-1){imgObj=null;return false;}var x=mX;var y=mY;if(!imgObj){if(IE){if(BV<5&&!IsMac) m.parentNode=m.parentElement;}else m.parentNode=m.parentLayer;tp=f28(m.parentNode.id.substr(5));if(IE) m=m.style;}else{m.left=f31(imgObj)[0];m.top=f31(imgObj)[1];if(NS) m.clip=m;}var l=pri(m.left)+tp[0];var r=l+(IE?pri(m.width):m.clip.width);var t=pri(m.top)+tp[1];var b=t+(IE?pri(m.height):m.clip.height);if(IsFrames&&!NS){x-=f14()[0];y-=f14()[1];}return ((x>=l&&x<=r)&&(y>=t&&y<=b));}function f38(){var m=om[nOM];if(!m) return false;else if(IE) m=m.style;var l=pri(m.left);var r=l+(IE?pri(m.width):m.clip.width);var t=pri(m.top);var b=t+(IE?pri(m.height):m.clip.height);return ((mX>=l&&mX<=r)&&(mY>=t&&mY<=b));}function f4(e){if(IE){if(!SM){if(mFrame!=cFrame||event==null){var cfe=cFrame.window.event;var mfe=mFrame.window.event;if(IE&&IsMac) cfe=(cfe.type=="mousemove"?cfe:null);if(IE&&IsMac) mfe=(mfe.type=="mousemove"?mfe:null);if(mfe==null&&cfe==null) return;e=(cfe?cfe:mfe);}else e=event;}mX=e.clientX+lt[0];mY=e.clientY+lt[1];if(!KQ){f18("cFrame.iefwh");cFrame.iefwh=window.setTimeout("lt=f14()",100);}}if(NS){mX=e.pageX;mY=e.pageY;}}function f24(){var nOMb=nOM--;for(;nOM>0;nOM--) if(om[nOM].sc!=null) break;var im=f38();nOM=nOMb;return im||f38();}function f13(){return (lmcHS||imgObj?f12():(nOM==1?!(om[nOM].sc!=null):false))||(nOM>0?f24():false);}function f26(e){f4(e);if(!f13()&&mhdHnd==0) mhdHnd=window.setTimeout("mhdHnd=0;if(!f13())Hide()",TimerHideDelay);}function f19(state){var fe;if(IE&&(!SM||OP)&&DoFormsTweak){var m=om[nOM];if((BV>=5.5)&&!OP&&m&&!KQ) cIF(state=="visible"?"hidden":"visible");else if(nOM==1) for(var f=0;f<mFrame.document.forms.length;f++) for(var e=0;e<mFrame.document.forms[f].elements.length;e++){fe=mFrame.document.forms[f].elements[e];if(fe.type) if(fe.type.indexOf("select")==0) fe.style.visibility=state;}}}function execURL(url,tframe){var d=100;if(mibc&&!NS){d+=mibs * mibc;if(lmcHS) mibm=lmcHS;if(nOM) for(var n=nOM;n>0;n--) if(om[n].sc){mibm=om[n].sc;break;}if(mibm){mibm.n=mibc;f22();}}else f36();f33(escape(_purl(url)),tframe);}function f22(){mibm.bs=!Math.abs(mibm.bs);SwapMC(mibm.bs,mibm);mibc--;if(mibc>=0) window.setTimeout("f22()",mibs);else{mibc=mibm.n;mibm=null;f36();}}function f33(url,tframe){var w=eval("windo"+"w.ope"+"n");url=rStr(unescape(url));if(url.indexOf("javascript:")!=url.indexOf("vbscript:")) eval(url);else{switch(tframe){case "_self":if(IE&&!SM&&!KQ&&(BV>4)){var a=mFrame.document.createElement("A");a.href=url;mFrame.document.body.appendChild(a);a.click();}else mFrame.location.href=url;break;case "_blank":w(url,tframe);break;default:var f=rStr(tframe);var fObj=(tframe=='_parent'?mFrame.parent:eval(f));if(typeof(fObj)=="undefined") w(url,f.substr(8,f.length-10));else fObj.location.href=url;break;}}}function rStr(s){s=xrep(s,"%1E","'");s=xrep(s,"\x1E","'");if(OP&&s.indexOf("frames[")!=-1) s=xrep(s,String.fromCharCode(s.charCodeAt(7)),"'");return xrep(s,"\x1D","\x22");}function f23(e){eval(this.TCode);}function f36(dr){var o=lmcHS;if(dr) lmcHS=null;Hide();while(nOM>0) Hide();lmcHS=o;}function tHideAll(){f18("mhdHnd");mhdHnd=window.setTimeout("mhdHnd=0;if(!f24())f36();",TimerHideDelay);}function f14(f){if(!f) f=mFrame;if(IE) if(SM) return [OP?f.pageXOffset:f.scrollX,OP?f.pageYOffset:f.scrollY];else{var b=GetBodyObj(f);return (b?[b.scrollLeft,b.scrollTop]:[0,0]);}if(NS) return [f.pageXOffset,f.pageYOffset];}function f1(f){var k=0;if(!f) f=mFrame;if(NS||SM){return [f.innerWidth,f.innerHeight];}else{var b=GetBodyObj(f);return (b?[b.clientWidth,b.clientHeight]:[0,0]);}}function f3(s){return [(s.borderLeftStyle==""||s.borderLeftStyle=="none"?0:pri(s.borderLeftWidth))+(s.borderRightStyle==""||s.borderRightStyle=="none"?0:pri(s.borderRightWidth)),(s.borderTopStyle==""||s.borderTopStyle=="none"?0:pri(s.borderTopWidth))+(s.borderBottomStyle==""||s.borderBottomStyle=="none"?0:pri(s.borderBottomWidth))];}function f34(m,img,arl){var x=f31(img)[0];var y=f31(img)[1];var iWH=f32(img);var mW=(NS?m.w:m.offsetWidth);var mH=(NS?m.h:m.offsetHeight);switch(arl){case 0:y+=iWH[1];break;case 1:x+=iWH[0]-mW;y+=iWH[1];break;case 2:y-=mH;break;case 3:x+=iWH[0]-mW;y-=mH;break;case 4:x-=mW;break;case 5:x-=mW;y-=mH-iWH[1];break;case 6:x+=iWH[0];break;case 7:x+=iWH[0];y-=mH-iWH[1];break;case 8:x-=mW;y+=(iWH[1]-mH)/2;break;case 9:x+=iWH[0];y+=(iWH[1]-mH)/2;break;case 10:x+=(iWH[0]-mW)/2;y-=mH;break;case 11:x+=(iWH[0]-mW)/2;y+=iWH[1];break;}return [x,y];}function f31(img){var x;var y;if(NS){y=f7(cFrame,img.name,0,0);x=img.x+y[0];y=img.y+y[1];}else{y=f27(img);x=y[0];y=y[1];}return [x,y];}function f32(img){return [pri(img.width),pri(img.height)];}function f27(img){var xy=[img.offsetLeft,img.offsetTop];var ce=img.offsetParent;while(ce!=null){xy[0]+=ce.offsetLeft;xy[1]+=ce.offsetTop;ce=ce.offsetParent;}return xy;}function f20(d,img){var tmp;if(d.images[img]) return d.images[img];for(var i=0;i<d.layers.length;i++){tmp=f20(d.layers[i].document,img);if(tmp) return tmp;}return null;}function f7(d,img,ox,oy){var i;var tmp;if(d.left){ox+=d.left;oy+=d.top;}if(d.document.images[img]) return [ox,oy];for(i=0;i<d.document.layers.length;i++){tmp=f7(d.document.layers[i],img,ox,oy);if(tmp) return [tmp[0],tmp[1]];}return null;}function f0(e){if(IE){f4(e);IsContext=true;}else if(e.which==3){IsContext=true;mX=e.x;mY=e.y;}if(IsContext){f36();cFrame.f21(cntxMenu,mX-1,mY-1,false);return false;}return true;}function f11(){nOM=0;if(!SM) onerror=f16;if(!mFrame) mFrame=cFrame;if(typeof(mFrame)=="undefined"||(NS&&(++NSDelay<2))) window.setTimeout("f11()",10);else{IsFrames=(cFrame!=mFrame);if(NS){mFrame.captureEvents(Event.MOUSEMOVE);mFrame.onmousemove=f26;if(cntxMenu!=""){mFrame.window.captureEvents(Event.MOUSEDOWN);mFrame.window.onmousedown=f0;}nsOWH=f1();window.onresize=rHnd;f5();}if(IE){document.onmousemove=f26;mFrame.document.onmousemove=document.onmousemove;if(cntxMenu) mFrame.document.oncontextmenu=f0;if(IsFrames) mFrame.window.onunload=new Function("mFrame=null;f11()");cFrame.lt=[0,0];}if(typeof(cFrame.prtb)=='undefined'){cFrame.prtb=true;f6();}MenusReady=true;}return true;}function f16(sMsg,sUrl,sLine){if(sMsg.substr(0,16)!="Access is denied"&&sMsg!="Permission denied"&&sMsg.indexOf("cursor")==-1) alert("Java Script Error\n"+      "\nDescription:"+sMsg+      "\nSource:"+sUrl+      "\nLine:"+sLine);return true;}function f37(v,s,r,k){var n;if(nOM==0||k==1) n=(v+s>r)?r-s:v;else n=(v+s>r)?pri(om[nOM].style.left)-s:v;return (n<0)?0:n;}function f9(s){if(IsWin||!NS) return s;for(var i=54;i>1;i--) if(s.indexOf("point-size="+i)!=-1) s=xrep(s,"point-size="+i,"point-size="+(i+3));return s;}function f18(t,f){if(!f) cFrame.f=cFrame;if(eval(t)) eval("cFrame.f.clearTimeout("+t+");"+t+"=0");}function xrep(s,f,n){if(s) s=s.split(f).join(n);return s;}function rHnd(){var nsCWH=f1();if((nsCWH[0]!=nsOWH[0])||(nsCWH[1]!=nsOWH[1])) frames["top"].location.reload();}function f40(oName,f,sf){var obj=null;if(!f) if(IsFrames){if(!sf) sf=window.parent;for(var i=0;i<sf.frames.length;i++){f=sf.frames[i];if(!(obj=f40(oName,f))&&f.length) obj=f40(oName,null,f);if(obj) break;}if(obj){f.cFrame=cFrame;if(tbNum>0) f.hsHoverSel=hsHoverSel;f.execURL=execURL;}}else f=mFrame;if(NS) obj=f.document.layers[oName];else{obj=(BV>=5?f.document.getElementById(oName):f.document.all[oName]);if(obj) if(obj.id!=oName) obj=null;}return obj;}function gpid(o){return (BV>=5?o.parentNode.parentNode.id:o.parentElement.parentElement.id);}function f5(){for(var l=0;l<mFrame.document.layers.length;l++){var lo=mFrame.document.layers[l];if(lo.layers.length){lo.w=lo.clip.width;lo.h=lo.clip.height;for(var sx=0;sx<lo.layers.length;sx++) for(var sl=0;sl<lo.layers[sx].layers.length;sl++){var slo=mFrame.document.layers[l].layers[sx].layers[sl];if(slo.name.indexOf("EH")>0){slo.document.onmouseup=f23;slo.document.TCode=nTCode[slo.name.split("EH")[1]];}}for(var t=1;t<=tbNum;t++){tb=cFrame.document.layers['dmbTBBack'+t];for(var sl=0;sl<tb.layers['dmbTB'+t].layers.length;sl++){slo=tb.layers['dmbTB'+t].layers[sl];if(slo.name.indexOf('EH')>0){slo.document.onmouseup=f23;slo.document.TCode=nTCode[slo.name.split('EH')[1]];}}}}}}function NSpTB1(){if(!f40('dmbTB1ph')) window.setTimeout('NSpTB1()',100);else f40('dmbTB1ph').document.open();f40('dmbTB1ph').document.write(xrep(f9(f42(" dmbTBBack174325	4A4392998name=dmbTB13374319999> 1001EH100100161191001window.status=cFrame._purl(\'Sponsors\');cFrame.ShowMenu(\'Group007\',11);\"\"> 1001N00161191000	4A439242#8FFF2ED>1015115>11510The Performing Company 1001O00161191000	4A439242#8CC3300>1015115>11510The Performing Company 1002EH10021620141191001window.status=cFrame._purl(\'Degnan Ballet School\');cFrame.ShowMenu(\'Group006\',21);\"\"> 1002N1620141191000	4A439242#8FFF2ED>1013115>11310Season Performances 1002O1620141191000	4A439242#8CC3300>1013115>11310Season Performances 1003EH1003304086191001window.status=cFrame._purl(\'Ticket Sales\');cFrame.ShowMenu(\'grp04\',31);\"\"> 1003N304086191000	4A439242#8FFF2ED>107615>1760Ticket Sales 1003O304086191000	4A439242#8CC3300>107615>1760Ticket Sales 1004EH1004391079191001window.status=cFrame._purl(\'The School\');cFrame.ShowMenu(\'grp01\',41);\"\"> 1004N391079191000	4A439242#8FFF2ED>106915>1690The School 1004O391079191000	4A439242#8CC3300>106915>1690The School 1005EH10054710134191001window.status=cFrame._purl(\'Sponsors\');cFrame.ShowMenu(\'grp03\',51);\"\"> 1005N4710134191000	4A439242#8FFF2ED>1012415>11240Support/Fundraising 1005O4710134191000	4A439242#8CC3300>1012415>11240Support/Fundraising 1006EH1006606079191001window.status=cFrame._purl(\'Contact Us\');cFrame.ShowMenu(\'grp05\',61);\"\"> 1006N606079191000	4A439242#8FFF2ED>106915>1690Contact Us 1006O606079191000	4A439242#8CC3300>106915>1690Contact Us 1007EH1007686051191001window.status=cFrame._purl(\'Sponsors\');\"\"> 1007N686051191000	4A439242#8FFF2ED>104115>1410Home 1007O686051191000	4A439242#8CC3300>104115>1410Home")),'%'+'%REL%%',rimPath));f40('dmbTB1ph').document.close();f5();}if(NS) with(document){open();write(xrep(f9(f42(" grp03002221151000	4A43924A4392112201131001> 1EH122216211003 OnMouseOver=\"cFrame.f15(0,this);status=\'Under Construction\';cFrame.execURL(\'%%REP%%C:/AnnualCampaign.htm\',\'_self\'! 1N22216211002	4A4392>64#8FFF2ED>1020213>02020Annual Campaign 1O22216211002	4A439264#8CC3300>1020213>02020Annual Campaign 2EH2224216211003 OnMouseOver=\"cFrame.f15(0,this);cFrame.execURL(\'%%REP%%C:/Sponsors.htm\',\'_self\'! 2N224216211002	4A4392>64#8FFF2ED>1020213>02020Corporate Sponsors 2O224216211002	4A439264#8CC3300>1020213>02020Corporate Sponsors 3EH3246216211003 OnMouseOver=\"cFrame.f15(0,this);cFrame.execURL(\'%%REP%%C:/ProgAdv.htm\',\'_self\'! 3N246216211002	4A4392>64#8FFF2ED>1020213>02020Program Advertisements 3O246216211002	4A439264#8CC3300>1020213>02020Program Advertisements 4EH4268216211003 OnMouseOver=\"cFrame.f15(0,this);cFrame.execURL(\'%%REP%%C:/PDMemorialEndow.htm\',\'_self\'! 4N268216211002	4A4392>64#8FFF2ED>1020213>02020Peter Degnan Memorial Endowment 4O268216211002	4A439264#8CC3300>1020213>02020Peter Degnan Memorial Endowment 5EH5290216211003 OnMouseOver=\"cFrame.f15(0,this);cFrame.execURL(\'%%REP%%C:/OtherGiving.htm\',\'_self\'! 5N290216211002	4A4392>64#8FFF2ED>1020213>02020Other Giving 5O290216211002	4A439264#8CC3300>1020213>02020Other Giving Group007001581371000	4A43924A4392111561351001> 6EH622152211003 6N22152211002	4A4392>64#8FFF2ED>1013813>01380Mission & History 6O22152211002	4A439264#8CC3300>1013813>01380Mission & History 7EH7224152211003 7N224152211002	4A4392>64#8FFF2ED>1013813>01380Governance 7O224152211002	4A439264#8CC3300>1013813>01380Governance 8EH8246152211003 8N246152211002	4A4392>64#8FFF2ED>1013813>01380Artistic Professionals 8O246152211002	4A439264#8CC3300>1013813>01380Artistic Professionals 9EH9268152211003 9N268152211002	4A4392>64#8FFF2ED>1013813>01380Technical Professionals 9O268152211002	4A439264#8CC3300>1013813>01380Technical Professionals 10EH10290152211003 10N290152211002	4A4392>64#8FFF2ED>1013813>01380Repertoire 10O290152211002	4A439264#8CC3300>1013813>01380Repertoire 11EH112112152211003 11N2112152211002	4A4392>64#8FFF2ED>1013813>01380Membership & Auditions 11O2112152211002	4A439264#8CC3300>1013813>01380Membership & Auditions grp0400134491000	4A43924A439211132471001> 12EH1222128211003 OnMouseOver=\"cFrame.f15(0,this);status=\'Under Construction 12N22128211002	4A4392>64#8FFF2ED>1011413>01140Ticket Sales 12O22128211002	4A439264#8CC3300>1011413>01140Ticket Sales 13EH13224128211003 13N224128211002	4A4392>64#8FFF2ED>1011413>01140Season Subscription 13O224128211002	4A439264#8CC3300>1011413>01140Season Subscription grp0100175931000	4A43924A439211173911001> 14EH1422169211003 OnMouseOver=\"cFrame.f15(0,this);status=\'Degnan Ballet Center 14N22169211002	4A4392>64#8FFF2ED>1015513>01550Degnan Ballet Center 14O22169211002	4A439264#8CC3300>1015513>01550Degnan Ballet Center 15EH15224169211003 15N224169211002	4A4392>64#8FFF2ED>1015513>01550Schedule of Classes 15O224169211002	4A439264#8CC3300>1015513>01550Schedule of Classes 16EH16246169211003 16N246169211002	4A4392>64#8FFF2ED>1015513>01550Tuition and Sessions 16O246169211002	4A439264#8CC3300>1015513>01550Tuition and Sessions 17EH17268169211003 17N268169211002	4A4392>64#8FFF2ED>1015513>01550General School Information 17O268169211002	4A439264#8CC3300>1015513>01550General School Information Group006002541151000	4A43924A4392112521131001> 18EH1822248211003 18N22248211002	4A4392>64#8FFF2ED>1023413>02340The Northeast Pennsylvania Philharmonic 18O22248211002	4A439264#8CC3300>1023413>02340The Northeast Pennsylvania Philharmonic 19EH19224248211003 19N224248211002	4A4392>64#8FFF2ED>1023413>02340The Nutcracker 19O224248211002	4A439264#8CC3300>1023413>02340The Nutcracker 20EH20246248211003 20N246248211002	4A4392>64#8FFF2ED>1023413>02340Giselle 20O246248211002	4A439264#8CC3300>1023413>02340Giselle 21EH21268248211003 21N268248211002	4A4392>64#8FFF2ED>1023413>02340Fine Arts Fiesta 21O268248211002	4A439264#8CC3300>1023413>02340Fine Arts Fiesta 22EH22290248211003 22N290248211002	4A4392>64#8FFF2ED>1023413>02340Young Dancers\' Repertory 22O290248211002	4A439264#8CC3300>1023413>02340Young Dancers\' Repertory grp0500139711000	4A43924A439211137691001> 23EH2322133211003 23N22133211002	4A4392>64#8FFF2ED>1011913>01190Ballet Northeast 23O22133211002	4A439264#8CC3300>1011913>01190Ballet Northeast 24EH24224133211003 24N224133211002	4A4392>64#8FFF2ED>1011913>01190Degnan Ballet Center 24O224133211002	4A439264#8CC3300>1011913>01190Degnan Ballet Center 25EH25246133211003 25N246133211002	4A4392>64#8FFF2ED>1011913>01190Webmaster 25O246133211002	4A439264#8CC3300>1011913>01190Webmaster Group00800651000	4A43924A439211431001>")),'%'+'%REL%%',rimPath));close();}f42('');f11();function f42(code){code=xrep(code,""," left=");code=xrep(code,""," top=");code=xrep(code,""," width=");code=xrep(code,""," height=");code=xrep(code,""," z-index=");code=xrep(code,""," visibility=hidden><layer ");code=xrep(code,""," visibility=inherit>");code=xrep(code,"	"," bgColor=#");code=xrep(code,""," OnMouseOver=\"f8(0,this);");code=xrep(code,""," OnMouseOver=\"cFrame.f15(0,this);\">");code=xrep(code,"","><font face=");code=xrep(code,"","</font>");code=xrep(code,""," point-size=");code=xrep(code,""," color=#");code=xrep(code,"","><div align=left>");code=xrep(code,"","><div align=center>");code=xrep(code,"","</div>");code=xrep(code,"","<layer");code=xrep(code,"","</layer>");code=xrep(code,"","<ilayer");code=xrep(code,"","</ilayer>");code=xrep(code,"","name=MC");code=xrep(code,"","\';\">");code=xrep(code,""," visibility=hidden>");code=xrep(code,"","</b>");code=xrep(code,"","><b");code=xrep(code,"","bgColor=#");code=xrep(code,"",",0,false,\'\',-");code=xrep(code," "," name=");code=xrep(code,"!",");\">");code=xrep(code,"#","Tahoma");return code;}function xA(o, n){for(var i=1;i<nTCode.length;i++){if(nTCode[i])nTCode[i]=xrep(nTCode[i],o,n);}}function pri(n){return parseInt(n)}