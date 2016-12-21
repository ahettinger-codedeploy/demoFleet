// Flashtalking Pagefold Tracking v2.30.0
// www: http://www.flashtalking.com
// Date of last revision: 30th November 2010
// (c) Simplicity Marketing Ltd.  Flashtalking is a Trade Mark of Simplicity Marketing Ltd.
function ftpagefold(n){
	var pfobj=this;
	pfobj.ftStatBaseURL;
	pfobj.ftConfID="0";
	pfobj.ftGUID="99999999999999";
	pfobj.ftFoldAdId;
	pfobj.ftFoldAdHeight=0;
	pfobj.ftFoldAdType=1;
	getParams();
	function getScriptObj(){
		var scrobjs=document.body.getElementsByTagName("script");
		for(var i=scrobjs.length-1;i>=0;i--){
			var scrobj=scrobjs[i];
			var scrurl=scrobj.src;
			if(scrurl.indexOf("ftpagefold")!=-1){
				return scrurl;
			}
		}
	}
	function getParams(){
		var scrurl=getScriptObj();
		setParams(scrurl);
	}
	function Querystring(scrParams){
		var querystring=scrParams;
		var args=querystring.split('&');
		for(var i=0;i<args.length;i++){
			var pair=args[i].split('=');
			if(pair.length>1){
				for(var i2=2;i2<pair.length;i2++){
					pair[1]+="="+pair[i2];
				}
			}
			var temp=unescape(pair[0]).split('+');
			var temp0=temp.join(' ');
			temp=unescape(pair[1]).split('+');
			var temp1=temp.join(' ');
			this[temp0]=temp1;
		}
		this.get=Querystring_get;
	}
	function Querystring_get(strKey,strDefault){
		var value=this[strKey];
		if(value==null){value=strDefault;}
		return value;
	}
	function setParams(scrurl){
		var scrParams=scrurl.substr((scrurl.indexOf("#")+1),scrurl.length);
		var qs=new Querystring(scrParams);
		pfobj.ftStatBaseURL=qs.get("stat",pfobj.ftStatBaseURL);
		pfobj.ftConfID=qs.get("cfid",pfobj.ftConfID);
		pfobj.ftGUID=qs.get("guid",pfobj.ftGUID);
		pfobj.ftFoldAdId=qs.get("adid",pfobj.ftFoldAdId);
		pfobj.ftFoldAdHeight=parseInt(qs.get("h",pfobj.ftFoldAdHeight));
		pfobj.ftFoldAdType=parseInt(qs.get("adtype",pfobj.ftFoldAdType));
	}
	pfobj.ftAdPosX="null";
	pfobj.ftAdPosY="null";
	pfobj.ftpagewidth=0;
	pfobj.ftpageheight=0;
	pfobj.ftscrolltop=0;
	pfobj.ftscrollleft=0;
	pfobj.fttotalwidth=0;
	pfobj.fttotalheight=0;
	pfobj.ftnofold=0;
	pfobj.ftcompfold=0;
	pfobj.ftpartfold=0;
	pfobj.ftndfold=0;
	pfobj.ftlastfold="u";
	pfobj.fttimefold;
	pfobj.ftfoldtimer;
	pfobj.ftfoldevarr=new Array(0,0,0,0,0,0,0);
	pfobj.ftfoldhasn=false;
	pfobj.ftfoldintarr=new Array(20,50,100,175,300,600,1200,3000);
	pfobj.ftfoldcurint=0;
	pfobj.ftRandomNumber=n;
	pfobj.ftinframe=false;
	pfobj.ftfoldfrid="ftfold";
	pfobj.ftFoldTT=0;
	pfobj.ftFoldIT=0;	
	function ftmainFold(){
		if(!((typeof(pfobj.ftStatBaseURL)=="undefined")||((pfobj.ftStatBaseURL=="")||(pfobj.ftStatBaseURL=="undefined")))){
			var foldIsAvail=ftFoldAvail();			
			if(foldIsAvail){
				if(pfobj.ftinframe){
					ftInitFold();
				}else{
					ftaddOnload();
				}
			}else{
				ftFireFoldEvent("308");
				pfobj.ftfoldtimer=setInterval(function(){ftNDAdFold()},249);
			}
			var purl=getPageUrl(foldIsAvail);
			if(purl!=""){
				ftoutputPageURL(purl);
			}
		}
	}
	function ftFoldAvail(){	
		try{
			if(window!=top){
				var d=window.frameElement.offsetParent;
    				pfobj.ftinframe=true;
    				return true;
    			}
		}catch(e){
    			pfobj.ftinframe=true;
    			return false;
		}
		return true;
	}
	function ftInitFold(){
		ftGetAdPos();
		pfobj.ftfoldtimer=setInterval(function(){ftgetAdFold()},249);
	}
	function ftgetDimensions(){
		var tW=(pfobj.ftinframe)?window.parent:window;
		if(tW.innerWidth){
			pfobj.ftpagewidth=parseInt(tW.innerWidth);
			pfobj.ftpageheight=parseInt(tW.innerHeight);
			pfobj.ftscrolltop=parseInt(tW.pageYOffset);
			pfobj.ftscrollleft=parseInt(tW.pageXOffset);
			pfobj.fttotalwidth=parseInt(tW.document.body.scrollWidth);
			pfobj.fttotalheight=parseInt(tW.document.body.scrollHeight);
		}else{
			if(tW.document.documentElement&&tW.document.documentElement.clientHeight){
				pfobj.ftpagewidth=parseInt(tW.document.documentElement.clientWidth);
				pfobj.ftpageheight=parseInt(tW.document.documentElement.clientHeight);
				pfobj.ftscrolltop=parseInt(tW.document.documentElement.scrollTop);
				pfobj.ftscrollleft=parseInt(tW.document.documentElement.scrollLeft);
				pfobj.fttotalwidth=parseInt(tW.document.documentElement.scrollWidth);
				pfobj.fttotalheight=parseInt(tW.document.documentElement.scrollHeight);
			}else{
				if(tW.document.body){
					pfobj.ftpagewidth=parseInt(tW.document.body.clientWidth);
		 			pfobj.ftpageheight=parseInt(tW.document.body.clientHeight);
		 			pfobj.ftscrolltop=parseInt(tW.document.body.scrollTop);
					pfobj.ftscrollleft=parseInt(tW.document.body.scrollLeft);
					pfobj.fttotalwidth=parseInt(tW.document.body.scrollWidth);
		 			pfobj.fttotalheight=parseInt(tW.document.body.scrollHeight);
		 		}
			}
		}
	}
	function getAbsLeft(id){
		var objLeft=id.offsetLeft;
		var objParent;
		while(id.offsetParent!=null){
			objParent=id.offsetParent;			
			objLeft+=objParent.offsetLeft;
			id=objParent;
		}
		return objLeft;
	}
	function getAbsTop(id){
		var objTop=id.offsetTop;
		while(id.offsetParent!=null){
			objParent=id.offsetParent;
			objTop+=objParent.offsetTop;
			id=objParent;
		}
		return objTop;
	}
	function getElementRef(elementName){
		var elementRef="";
		var parwin=false;
		if(pfobj.ftinframe){
			parwin=true;
		}
		if(document.getElementById){
			if(document.getElementById(elementName)){
				elementRef=eval(document.getElementById(elementName));
			} else {
				if((parwin) && (window.parent.document.getElementById(elementName))){
					elementRef=eval(window.parent.document.getElementById(elementName));
				}
			}
		}else if(!document.getElementById&&document.all){
			if(eval("window."+elementName)){
				elementRef=eval("window."+elementName);
			}else{
				if((parwin)&&eval("window.parent."+elementName)){
					elementRef=eval("window.parent."+elementName);
				}
			}
		}else if(document.layers){
			if(document.layers[elementName]){
				elementRef=eval(document.layers[elementName]);
			}else{
				if((parwin)&&(window.parent.document.layers[elementName])){
					elementRef=eval(window.parent.document.layers[elementName]);
				}
			}
		}
		return elementRef;
	}
	function ftaddOnload(){
  		if(typeof(window.onload=='function')){
    			var preonload=window.onload;
			window.onload=function(){ftInitFold();if(preonload){preonload();}};
   		 }else{
	   	 	window.onload=ftInitFold;
  		  }
	}
	function ftGetAdPos(){
		if(!pfobj.ftinframe){
			pfobj.ftAdPosX=getAbsLeft(getElementRef(pfobj.ftFoldAdId));
			pfobj.ftAdPosY=getAbsTop(getElementRef(pfobj.ftFoldAdId));
		}else{
			if(pfobj.ftFoldAdType==1){
				pfobj.ftAdPosX=getAbsLeft(window.frameElement);
				pfobj.ftAdPosY=getAbsTop(window.frameElement);
			}else{
				pfobj.ftAdPosX=getAbsLeft(eval(pfobj.ftFoldAdId));
				pfobj.ftAdPosY=getAbsTop(eval(pfobj.ftFoldAdId));
			}
		}
	}
	function ftNDAdFold(){
		var firstrun=false;
		pfobj.ftFoldIT=pfobj.ftFoldTT+ftformatfoldtime(ftsetFoldTime());
		if(pfobj.ftlastfold=="u"){
			firstrun=true;
			pfobj.ftlastfold="z";
		}
		if(pfobj.ftfoldcurint<(pfobj.ftfoldintarr.length)){
			if(firstrun==false){
				if(pfobj.ftFoldIT>pfobj.ftfoldintarr[pfobj.ftfoldcurint]){
					ftoutputFold(pfobj.ftfoldintarr[pfobj.ftfoldcurint]);
					pfobj.ftFoldTT+=ftformatfoldtime((pfobj.ftnofold+pfobj.ftpartfold+pfobj.ftcompfold+pfobj.ftndfold));
					pfobj.ftnofold=0;
					pfobj.ftpartfold=0;
					pfobj.ftcompfold=0;
					pfobj.ftndfold=0;
					pfobj.ftfoldcurint+=1;
				}
			}
		}else{
			clearInterval(pfobj.ftfoldtimer);
		}
	}
	function ftgetAdFold(){
		var firstrun=false;
		ftgetDimensions();
		pfobj.ftFoldIT=pfobj.ftFoldTT+ftformatfoldtime(ftsetFoldTime());
		if(pfobj.ftlastfold=="u"){
			firstrun=true;
		}
		if(pfobj.ftfoldcurint<(pfobj.ftfoldintarr.length)){
			if(firstrun==false){
				if(pfobj.ftFoldIT>pfobj.ftfoldintarr[pfobj.ftfoldcurint]){
					ftoutputFold(pfobj.ftfoldintarr[pfobj.ftfoldcurint]);
					pfobj.ftFoldTT+=ftformatfoldtime((pfobj.ftnofold+pfobj.ftpartfold+pfobj.ftcompfold+pfobj.ftndfold));
					pfobj.ftnofold=0;
					pfobj.ftpartfold=0;
					pfobj.ftcompfold=0;
					pfobj.ftndfold=0;
					pfobj.ftfoldcurint+=1;
				}
			}
		}else{
			clearInterval(pfobj.ftfoldtimer);
		}
		var toff=false;
		var boff=false;
		var alloff=false;
		var adbottom=parseInt(pfobj.ftAdPosY)+(pfobj.ftFoldAdHeight);
		var viewbottom=parseInt(pfobj.ftscrolltop)+parseInt(pfobj.ftpageheight);
		if(adbottom>viewbottom){
			boff=true;
			if(parseInt(pfobj.ftAdPosY)>viewbottom){
				alloff=true;
			}
		}
		if(parseInt(pfobj.ftAdPosY)<parseInt(pfobj.ftscrolltop)){
			toff=true;
			if(parseInt(pfobj.ftscrolltop)>adbottom){
				alloff=true;
			}
		}
		if(alloff){
			pfobj.ftlastfold="c";
		}else{
			if(!boff){
				if(!toff){
					if(!pfobj.ftfoldhasn){
						if((pfobj.ftlastfold=="p")&&(pfobj.ftfoldevarr[2]!=1)){
							pfobj.ftfoldevarr[2]=1;
							if(pfobj.ftfoldevarr[3]==1){
								pfobj.ftfoldevarr[6]=1;
								ftFireFoldEvent("307");
							}else{
								ftFireFoldEvent("303");
							}
						}else{
						if(((pfobj.ftlastfold=="c")&&(pfobj.ftfoldevarr[5]!=1))&&((pfobj.ftfoldevarr[1]!=1)&&(pfobj.ftfoldevarr[4]!=1))){
								pfobj.ftfoldevarr[5]=1;
								ftFireFoldEvent("306");
							}
						}
					}
					pfobj.ftlastfold="n";
					pfobj.ftfoldhasn=true;
				}else{
					if(!pfobj.ftfoldhasn){
						if(((pfobj.ftlastfold=="c")&&(pfobj.ftfoldevarr[4]!=1))&&(pfobj.ftfoldevarr[3]==1)){
							pfobj.ftfoldevarr[4]=1;
							ftFireFoldEvent("305");
						}
					}
					pfobj.ftlastfold="p";
				}
			}else{
				if(!toff){
					if(!pfobj.ftfoldhasn){
						if(((pfobj.ftlastfold=="c")&&(pfobj.ftfoldevarr[4]!=1))&&(pfobj.ftfoldevarr[3]==1)){
							pfobj.ftfoldevarr[4]=1;
							ftFireFoldEvent("305");
						}
					}
					pfobj.ftlastfold="p";
				}
			}
		}
		if(firstrun){
			var evcode=0;
			switch (pfobj.ftlastfold){
				case "n":
					evcode="301";
					pfobj.ftfoldevarr[0]=1;
					break;
				case "p":
					evcode="302";
					pfobj.ftfoldevarr[1]=1;
					break;
				case "c":
					evcode="304";
					pfobj.ftfoldevarr[3]=1;
					break;
			}
			ftFireFoldEvent(evcode);
		}	
	}
	function ftFireFoldEvent(ev){
		var reportstr=pfobj.ftStatBaseURL+pfobj.ftConfID+"-"+ev+"-0-"+pfobj.ftGUID+"-"+pfobj.ftRandomNumber;
		var repimg=new Image();
		repimg.src=reportstr;
	}
	function ftsetFoldTime(){
		var dobj=new Date();
		switch (pfobj.ftlastfold){
			case "n":
				pfobj.ftnofold+=(dobj.getTime()-pfobj.fttimefold);
				break;
			case "p":
				pfobj.ftpartfold+=(dobj.getTime()-pfobj.fttimefold);
				break;
			case "c":
				pfobj.ftcompfold+=(dobj.getTime()-pfobj.fttimefold);
				break;
			case "z":
				pfobj.ftndfold+=(dobj.getTime()-pfobj.fttimefold);
				break;
		}
		pfobj.fttimefold=dobj.getTime();
		return (pfobj.ftnofold+pfobj.ftpartfold+pfobj.ftcompfold+pfobj.ftndfold);
	}
	function ftoutputFold(ci){
		var reportstr=pfobj.ftStatBaseURL+pfobj.ftConfID+"-310-0-"+pfobj.ftGUID+"-"+pfobj.ftRandomNumber+"-";
		var n=ftformatfoldtime(pfobj.ftnofold);
		var p=ftformatfoldtime(pfobj.ftpartfold);
		var c=ftformatfoldtime(pfobj.ftcompfold);
		var z=ftformatfoldtime(pfobj.ftndfold);
		reportstr+=n+"x"+p+"x"+c+"x"+z;
		var repimg=new Image();
		repimg.src=reportstr;
	}
	function ftformatfoldtime(t){
		t/=100;
		t=Math.ceil(t);
		return t;
	}
	function ftAdComplete(){
		clearInterval(pfobj.ftfoldtimer);
		if(pfobj.ftlastfold!="z"){
			ftgetAdFold();
		}else{
			ftNDAdFold();
		}
		pfobj.ftFoldTT+=ftformatfoldtime((pfobj.ftnofold+pfobj.ftpartfold+pfobj.ftcompfold+pfobj.ftndfold));
		ftoutputFold(pfobj.ftFoldTT);
	}
	function getPageUrl(fIsA){
		var purl="";
		if(fIsA){
			if(pfobj.ftinframe){
				purl=window.parent.document.location;
			}else{
				purl=window.document.location;
			}
		}else{
			purl=window.document.referrer;
		}
		return purl;
	}
	function formatPageURL(purl){
		purl=purl.toString();
		if(purl.length>200){
			purl=purl.substr(0,200);
		}
		purl=escape(purl);
		return purl;
	}
	function ftoutputPageURL(purl){
		var reportstr=pfobj.ftStatBaseURL+pfobj.ftConfID+"-314-0-"+pfobj.ftGUID+"-"+pfobj.ftRandomNumber+"-";
		reportstr+=formatPageURL(purl);	
		var repimg=new Image();
		repimg.src=reportstr;
	}	
	ftmainFold();
}
var ftpfRNum=Math.floor(Math.random()*1000000);
eval('var ftpft_'+ftpfRNum+'=new ftpagefold('+ftpfRNum+')');