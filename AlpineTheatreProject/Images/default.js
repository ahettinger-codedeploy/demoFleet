function ThrowErrorPic(theimage,num){
		if(num ==1){
			theimage.src = "images/tourphotos/noimage.jpg";
		}else if(num==2){
			theimage.src = "images/default_images/no_product_photo.jpg";
		}else{
			theimage.src = "images/NoImage_ICON.gif";
		}

}

function CloseLightBox(){
	
	if(document.getElementById('LightBox')){
		document.getElementById('lightBoxBlockerDiv').style.display='none';
		document.getElementById('lightBoxBlockerDiv').style.visibility='hidden';
		
		document.getElementById('LightBox').style.display='none';
		document.getElementById('LightBox').style.visibility='hidden';
	}
}

var currentPhoto=0;
function LoadImage(name){
//if(document.getElementById('middleimage')){
//document.getElementById('middleimage').src='cms/image_bank/mediumcrop/'+name;
//}
}

function ShowLightBox(photonum){
	
	currentPhoto=photonum;
	
	if(document.getElementById('LightBox')){
		document.getElementById('lightBoxBlockerDiv').style.display='block';
		document.getElementById('lightBoxBlockerDiv').style.visibility='visible';
		document.getElementById('LightBox').style.display='block';
		document.getElementById('LightBox').style.visibility='visible';
		//alert(document.scroll);
		window.scroll(0,50);
		//SetHighlight(currentPhoto);
		//alert(document.getElementById('Photo'+currentPhoto));
		ChangePhoto(document.getElementById('Photo'+currentPhoto),currentPhoto);
		
		
		
		
	}
}

function ChangePhoto(thesrc,num){
	//objectdump(thesrc);
	//alert(thesrc.title);
	if(thesrc.title){
	document.getElementById('LightBoxImage').src='images/fashion_scene/nov2007/'+thesrc.title;
	}else{
		document.getElementById('LightBoxImage').src='cms/image_bank/large/'+thesrc.name;
	}
	//alert(thesrc);
	document.getElementById('photoalt').innerHTML=alttags[num];
	
}

function SetHighlight(num){
		//alert(num);
	for(i=0; i <= totalImages;i++){
		document.getElementById('numLink'+i).style.border='none';
	}
	
	document.getElementById('numLink'+num).style.border='solid #FFFFFF 1px;';
}

function SetPhoto(num){
	currentPhoto=num;
	//SetHighlight(currentPhoto);
	
	ChangePhoto(document.getElementById('Photo'+currentPhoto),currentPhoto);
}


function PreviousPhoto(){
			currentPhoto--;
			
			//alert(totalImages);
			if(currentPhoto < 0 ){
				currentPhoto=totalImages;	
			}
			//alert(currentPhoto);
			//	SetHighlight(currentPhoto);
			ChangePhoto(document.getElementById('Photo'+currentPhoto),currentPhoto);
		
}

function NextPhoto(){
			currentPhoto++;
			//alert(currentPhoto);
			
			if(currentPhoto > totalImages){
				currentPhoto=0;	
			}
			//SetHighlight(currentPhoto);
			ChangePhoto(document.getElementById('Photo'+currentPhoto),currentPhoto);
		
}



function ShowImageThumb(number,src,dir){
	if(dir==1){
		path='tourphotos';
		xadjust=20;yadjust=-125;
	}else if (dir ==2){
		path='tourphotos';
		xadjust=-370;yadjust=-125;
	}else if (dir ==3){
		path='large';
		xadjust=-72;yadjust=-15;
	}else{
		path='thumb';
		xadjust=-72;yadjust=-15;
	}
	thediv=document.getElementById('imgHolder');
	theimage=document.getElementById('imgHolderImage');
	if(number){
		//show
		theimage.src='images/'+path+'/'+src+'.jpg';
		//alert('cms/image_bank/'+path+'/'+src);
		thediv.style.left=document.cursorX+xadjust;
		thediv.style.top=document.cursorY+yadjust;
		thediv.className='ShowImageDiv';
				
	}else{
		//hide
		thediv.className='hiddenDiv';
	}


}
function ShowDn(num,nav,button,withwidget){
//alert(withwidget);
document.images[button].src=eval(nav+'_button_dn['+num+'].src');
if(withwidget !== ''){
//alert('fff'+withwidget+'ff');
	//document.images['widget0'].src= widget_dn[withwidget].src;
	document.images['widget' + num].src = widget_dn[withwidget].src;
}

}
function ShowUp(num,nav,button,withwidget){
document.images[button].src=eval(nav+'_button_up['+num+'].src');
if(withwidget  !== ''){
	document.images['widget' + num].src = widget_up[withwidget].src;
}
}


	 var cwin = null;
	 function openWin(theUrl, name, width, height, tools) {
	 	if(cwin && cwin.open && !cwin.closed){
			cwin.close();
		}
	   cwin = window.open('', name,
	  tools+'width=' + width + ',height='+height);
	  if (cwin != null) {
	   if (cwin.opener == null)
	    cwin.opener = self;
	   cwin.location.href= theUrl;
	
	    cwin.focus();
	  }
	 }
	 function closeWin(theWin) {
	  theWin.close();
	 }
function show(object) 
  {
  if(navigator.vendor && navigator.vendor.indexOf("Apple") >=0){
  document.getElementById(object).style.display = 'inline-block';
  }else{
  document.getElementById(object).style.display = 'block';
  }
   
   document.getElementById(object).style.visibility = 'visible';
 
  }
           
 function hide(object) 
  {
  
   document.getElementById(object).style.display = 'none';
   document.getElementById(object).style.visibility = 'hidden';

  }
  function isEMailAddress(str)
{
		return isValidText(str,"^([\\w\\._-]+)@([\\w_-]+\\.)+([\\w_]+)$");
}


function getPosition(e) {
    e = e || window.event;
    var cursor = {x:0, y:0};
    if (e.pageX || e.pageY) {
        cursor.x = e.pageX;
        cursor.y = e.pageY;
    } 
    else {
        var de = document.documentElement;
        var b = document.body;
        cursor.x = e.clientX + 
            (de.scrollLeft || b.scrollLeft) - (de.clientLeft || 0);
        cursor.y = e.clientY + 
            (de.scrollTop || b.scrollTop) - (de.clientTop || 0);
    }
    //return cursor;
	document.cursorX=cursor.x;
	document.cursorY=cursor.y;
}
document.onmousemove=getPosition;



function isValidText(str,regex)
{
	if (window.RegExp){
		if (typeof(regex)=='string')
			regex=new RegExp(regex);
		return regex.test(str);
	}else{
		window.alert("RegExp not available!");
		return true;
	}
}


