/*
	PureDOM explorer 3.1
	written by Christian Heilmann (http://icant.co.uk)
	Please refer to the pde homepage for updates: http://www.onlinetools.org/tools/puredom/
	Free for non-commercial use. Changes welcome, but no distribution without 
	the consent of the author.
	
	//TN modified file for better functionality
*/
//TN if not declared through PHP file then uncomment following:
/*var pdeImgURL = "/images/";
var pdeOpenMessage = "close section";
var pdeClosedMessage = "open section";
*/


pde={
	// CSS classes
	pdeClass:'pde',
	hideClass:'pdehide',
	showClass:'pdeshow',
	parentClass:'parent',
	currentClass:'current',
	// images added to the parent links
	openImage: pdeImgURL+pdeImgOpen,
	closedImage: pdeImgURL+pdeImgClose,
	expimageClass: 'expandminimize',//TN added
	openMessage:pdeOpenMessage,
	closedMessage:pdeClosedMessage,
    keepCurrentOpen:true,// boolean to keep the section with the STRONG open or not.
	linkParent:false,// Assign "true" to make link unactive as a link but so that it collapses the section instead 
	init:function(){
		//TN added for toggle feature
		var toogleaction = pdeReadCookie('pde_action');
		var a, m;
		if (toogleaction != 1) { 
			a = 'open';
			m = openAllMessage;
		} else {
			a = 'close';
			m = closeAllMessage;
		}
		//TN EOF
		pde.createClone(a);
		if(!document.getElementById || !document.createTextNode){return;}
		/*
		//TN test to make menu work better
		var pdeNavRoot = document.getElementById("pde");
		for (i=0; i<pdeNavRoot.childNodes.length; i++) {
			var n = pdeNavRoot.childNodes[i];
			if (n.nodeName=="LI") {
				//alert(i);
			}
		}
		//TN EOF test
		*/
		var uls=document.getElementsByTagName('ul');
		for(var i=0;i<uls.length;i++){//start uls loop
			var inneruls,parentLI,lia,nodetxt;//TN added ,lia,nodetxt
			if(!pde.cssjs('check',uls[i],pde.pdeClass)){continue;}
			var inneruls=uls[i].getElementsByTagName('ul');
			
			for(var j=0;j<inneruls.length;j++){//start pde uls loop
				parentLI=inneruls[j].parentNode;
				
				lia = parentLI.getElementsByTagName('a')[0];//TN added
				
				  //TN alt without span:if(parentLI.getElementById("pdeselected")){
					  //if(parentLI.id == "pdeselected"){
				
				 if(parentLI.getElementsByTagName('b')[0]){//start if span
				 //if(lia.id == "pdelinkselected"){
					 
					//if(parentLI.id == "pdeselected"){
					//	 lia = parentLI.getElementsByTagName('span')[0];//TN added
					//}
					//TN edited and moved "continue" to later (so exp img show): if(pde.keepCurrentOpen === true){continue;}
						pde.cssjs('add',parentLI,pde.currentClass);
						
						//this adds open/close image as new block element: parentLI.insertBefore(pde.clone.cloneNode(true),parentLI.firstChild);
						
						nodetxt=lia.firstChild;//TN added
						lia.insertBefore(pde.clone.cloneNode(true),nodetxt);//TN added
						//TN edit clone image
						if(pde.keepCurrentOpen === false){
							parentLI.getElementsByTagName('img')[0].src=pde.closedImage;
							parentLI.getElementsByTagName('img')[0].alt=pde.closedMessage;
							parentLI.getElementsByTagName('img')[0].title=pde.closedMessage;
							parentLI.getElementsByTagName('img')[0].className = pde.expimageClass;
						} else {
							parentLI.getElementsByTagName('img')[0].src=pde.openImage;
							parentLI.getElementsByTagName('img')[0].alt=pde.openMessage;
							parentLI.getElementsByTagName('img')[0].title=pde.openMessage;
							parentLI.getElementsByTagName('img')[0].className = pde.expimageClass;
						}
						//TN assign functions to img
						pde.addEvent(parentLI.getElementsByTagName('img')[0],'click',pde.showhide,false);
						pde.addEvent(parentLI.getElementsByTagName('img')[0],'mouseover',pde.roll_over,false);
						pde.addEvent(parentLI.getElementsByTagName('img')[0],'mouseout',pde.roll_out,false);
						parentLI.getElementsByTagName('img')[0].onclick=function(){return false;} // Safari hack
						if(pde.keepCurrentOpen === true){
						if(pde.linkParent){
							//TN changed following "a"'s to 0 (zero) reference as I removed the first <a> tag from clone
							pde.addEvent(parentLI.getElementsByTagName('a')[0],'click',pde.showhide,false);
							parentLI.getElementsByTagName('a')[0].onclick=function(){return false;} // Safari hack
						}
						//TN EOF
					//continue;
					continue;} //TN moved eof continue to here so that selected img would print
				} else {//end if span
					
					pde.cssjs('add',parentLI,pde.parentClass);	
					//if(pde.keepCurrentOpen === true){continue;}
					nodetxt=lia.firstChild;//TN added
					//alert('nodetext'+nodetxt.nodeValue);
					//parentLI.getElementsByTagName('span')[0].firstChild.nodeValue;
					lia.insertBefore(pde.clone.cloneNode(true),nodetxt);//TN added
					pde.addEvent(parentLI.getElementsByTagName('img')[0],'click',pde.showhide,false);
					pde.addEvent(parentLI.getElementsByTagName('img')[0],'mouseover',pde.roll_over,false);
					pde.addEvent(parentLI.getElementsByTagName('img')[0],'mouseout',pde.roll_out,false);
					parentLI.getElementsByTagName('img')[0].className = pde.expimageClass;
					parentLI.getElementsByTagName('img')[0].onclick=function(){return false;} // Safari hack
					if(pde.linkParent){
						//TN changed following "a"'s to 0 (zero) reference as I removed the first <a> tag from clone
						pde.addEvent(parentLI.getElementsByTagName('a')[0],'click',pde.showhide,false);
						parentLI.getElementsByTagName('a')[0].onclick=function(){return false;} // Safari hack
					}
					
				}
				if(toogleaction != 1){
					pde.cssjs('add',inneruls[j],pde.hideClass);
				}
				
				
			}//end pde uls loop
		}//end uls loop
		//TN switch text for expand or collapse
		pdallink = document.getElementById('expandcollapsemenu');//TN added
		if(pdallink){//only change if expand collapse all is found
			pdalltxt = document.getElementById('pdetogglealltext');//TN added
			pdallink.onclick = function () {pde_All(a);}
			toggletxt=document.getElementById('pdetogglealltext');
			toggletxt.replaceChild(document.createTextNode(m),toggletxt.firstChild);
		}
	},
	showhide:function(e){
		var image,message;
		var elm=pde.getTarget(e);
		var ul=elm.parentNode.getElementsByTagName('ul')[0];
		var img=elm.parentNode.getElementsByTagName('img')[0];
		if(pde.cssjs('check',ul,pde.hideClass)){
			message=pde.openMessage;
			image=pde.openImage;
			pde.cssjs('remove',elm.parentNode.getElementsByTagName('ul')[0],pde.hideClass);
			pde.cssjs('add',elm.parentNode.getElementsByTagName('ul')[0],pde.showClass);
		} else {
			message=pde.closedMessage;
			image=pde.closedImage;
			pde.cssjs('remove',elm.parentNode.getElementsByTagName('ul')[0],pde.showClass);
			pde.cssjs('add',elm.parentNode.getElementsByTagName('ul')[0],pde.hideClass);
		}
		img.setAttribute('src',image);
		img.setAttribute('alt',message);
		img.setAttribute('title',message);
		img.className = pde.expimageClass;
		//TN mouseover/mouseout:
		pde.addEvent(img,'mouseover',pde.roll_over,false);
		pde.addEvent(img,'mouseout',pde.roll_out,false);
		//TN EOF mouseover/mouseout
		pde.cancelClick(e);
	},
	createClone:function(a){//TN added a to pass by reference for toggle
		pde.clone=document.createElement('img');
		var img_a, msg_a;
		if(a == 'close'){
			img_a = pde.openImage;
			msg_a = pde.openMessage;
		} else {
			img_a = pde.closedImage;
			msg_a = pde.closedMessage;
		}
		pde.clone.src=img_a;
		pde.clone.alt=msg_a;
		pde.clone.title=msg_a;
		pde.clone.className = pde.expimageClass;
	},
/* helper methods */
	getTarget:function(e){
		var target = window.event ? window.event.srcElement : e ? e.target : null;
		if (!target){return false;}
		if (target.nodeName.toLowerCase() != 'a'){target = target.parentNode;}
		return target;
	},
	cancelClick:function(e){
		if (window.event){
			window.event.cancelBubble = true;
			window.event.returnValue = false;
			return;
		}
		if (e){
			e.stopPropagation();
			e.preventDefault();
		}
	},
	addEvent: function(elm, evType, fn, useCapture){
		if (elm.addEventListener) 
		{
			elm.addEventListener(evType, fn, useCapture);
			return true;
		} else if (elm.attachEvent) {
			var r = elm.attachEvent('on' + evType, fn);
			return r;
		} else {
			elm['on' + evType] = fn;
		}
	},
	//TN added mouseover/mouseout function:
    roll_over: function(e){
		var elm=pde.getTarget(e);
		var img=elm.parentNode.getElementsByTagName('img')[0];
		var imagehover,hover_img_n_ext;
		if(img.src.lastIndexOf('_hover.gif') > 0){
			hover_img_n_ext = '';
		} else {
			hover_img_n_ext = '_hover';
		}
		imagehover = img.src.substring(0,img.src.lastIndexOf('.gif'))+hover_img_n_ext+'.gif';
		img.src = imagehover;
	},
	
	roll_out: function(e){
		var elm=pde.getTarget(e);
		var img=elm.parentNode.getElementsByTagName('img')[0];
		var imagehover;
		if(img.src.lastIndexOf('_hover.gif') > 0){
			imagehover = img.src.substring(0,img.src.lastIndexOf('_hover.gif'))+'.gif';
			img.src = imagehover;
		} else {
			img.src = img.src;
		}
	},

	
	//TN EOF
	cssjs:function(a,o,c1,c2){
		switch (a){
			case 'swap':
				o.className=!pde.cssjs('check',o,c1)?o.className.replace(c2,c1):o.className.replace(c1,c2);
			break;
			case 'add':
				if(!pde.cssjs('check',o,c1)){o.className+=o.className?' '+c1:c1;}
			break;
			case 'remove':
				var rep=o.className.match(' '+c1)?' '+c1:c1;
				o.className=o.className.replace(rep,'');
			break;
			case 'check':
				return new RegExp("(^|\s)" + c1 + "(\s|$)").test(o.className)
			break;
		}
	}
}
//TN function to close/open all menu items:
//credits: http://www.johnbarclay.com/programming/resources.html
function pde_All(pde_action) {
/*  return; CSS class names, change if needed */
	var hp='pdehide';
	var sp='pdeshow';
	var parentClass='parent';

	var d,uls,i,cookieVal,childClass,imgs,pdall,a,toggleimg,allMessage;//TN added imgs,pdall,a,toggleimg,allMessage
	
	if(!document.getElementById && !document.createTextNode){return;}

	d=document.getElementById('pde');
	
	if (!d){return;}

	if (pde_action == 'open') { 
		cookieVal = '1';
		childClass = sp;
		a = 'close';
		toggleimg = pdeImgOpen;
		allMessage = closeAllMessage;
	} else {
		cookieVal = '0';
		childClass = hp;
		a = 'open';
		toggleimg = pdeImgClose;
		allMessage = openAllMessage;
	}
	//TN set cookie so that menu remains close or open if user clicked on the toggle
	pdeCreateCookie('pde_action',cookieVal,365);

	//TN to switch expander img src
	imgs=d.getElementsByTagName('img');
	for (i=0;i<imgs.length;i++){
		var expImg = imgs[i].parentNode.firstChild;
		if(expImg.className == "expandminimize"){//only switch xpander img's
			expImg.src= pdeImgURL+toggleimg;
		}
	}
	
	uls=d.getElementsByTagName('ul');

	for (i=0;i<uls.length;i++){
		var pli = uls[i].parentNode;
		pli.className = parentClass;
		var myThis = uls[i].parentNode.firstChild;
		//myThis.parentNode.getElementsByTagName('ul')[0].className = '';//TN remove whatever classname previously assigned (as elements can have multiple classnames)
		//myThis.parentNode.getElementsByTagName('ul')[0].className = childClass;
		pli.getElementsByTagName('ul')[0].className = '';//TN remove whatever classname previously assigned (as elements can have multiple classnames)
		pli.getElementsByTagName('ul')[0].className = childClass;
	}
	//TN switch text for expand or collapse
	pdallink = document.getElementById('expandcollapsemenu');//TN added
	pdalltxt = document.getElementById('pdetogglealltext');//TN added
	pdallink.onclick = function () {pde_All(a);}
	toggletxt=document.getElementById('pdetogglealltext');
	toggletxt.replaceChild(document.createTextNode(allMessage),toggletxt.firstChild);
}
//TN cookie functions:
//credits: http://www.quirksmode.org/js/cookies.html
function pdeCreateCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function pdeReadCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function pdeEraseCookie(name) {
	pdeCreateCookie(name,"",-1);
}
//TN moved to DOM load: pde.addEvent(window, 'load', pde.init, false);