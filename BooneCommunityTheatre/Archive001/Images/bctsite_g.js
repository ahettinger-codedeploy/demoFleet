/*--- Avanquest WebEasy Document Script ---*/

IE=(navigator.appName.indexOf('Microsoft') >= 0);
NS=(navigator.appName.indexOf('Netscape') >= 0);
OP=(navigator.userAgent.indexOf('Opera') >= 0);
V4=(parseInt(navigator.appVersion) >= 4);
V5=(parseInt(navigator.appVersion)>=5);
V5=(V5||navigator.appVersion.indexOf("MSIE 5")!=-1);
V5=(V5||navigator.appVersion.indexOf("MSIE 6")!=-1);
MAC=(navigator.userAgent.indexOf('Mac')!=-1);


IDP={}; IDP[0]=0;
isOvr=0;

function OnWeOver(snd,txc,txv,img,imv,ref,flag)
{	if(!isOvr) return;
	if(!V4) return;
	if(typeof(IDP.my.location.href)!='string') return;
	if(img && imv)
	{	if(flag)
		{	if(ref)
			{	imv.pos=1;
				if(IDP.my.location.href.lastIndexOf(ref) >= 0) imv.pos=imv.max;
				--imv.pos;
			}
			if(++imv.pos > imv.max) imv.pos=(imv.max)?1:0;
			eval(img+'="'+imv[imv.pos].src+'"');
		}else
		{	eval( img+'="'+imv[0].src+'"' );
		}
	}
	if(txc)
	{	img=document.linkColor;
		if(flag)
		{	if(ref && (IDP.my.location.href.lastIndexOf(ref) >= 0)) img=document.vlinkColor;
		}else if (IE || (NS && V5))
		{	for (var cn=document.styleSheets.length-1; cn >= 0; --cn)
			{	var cs = NS ? document.styleSheets[cn].cssRules : document.styleSheets[cn].rules;
				for (var sn = cs.length - 1; sn >= 0; --sn)
				{	if (cs[sn].selectorText == txv) { img=cs[sn].style.color; cn=sn=0; }
				}
			}
		}
		eval(txc+'="'+img+'"');
	}
}

function OnWeResize()
{
	if (!NS || !V4 || V5) return;
	window.location.href = window.location.href;
}


/*--- EndOfFile ---*/
