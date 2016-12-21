/***********************************************
* Multi-drop Fade-in image slideshow script- 
*	Pretty much written by Bob Sandberg @ Nuevodesign.com
* While borrowing techniques from some scripts at 
* © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/
function rotatingImage(params){
	this.id				 = params.id.replace(/[\r\n\t ]+/g,'_');
	this.canvasId0 = params.id + '_canvas0';
	this.canvasId1 = params.id + '_canvas1';
	
	document.write('<div id="'+this.id+'" class=RI_Div style="height=100%;width:100%;border:solid 1 black;">');
	document.write('<div id="'+this.canvasId0+'" class=RI_Canvas style="filter:alpha(opacity=10);-moz-opacity:10;"></div>');
	document.write('<div id="'+this.canvasId1+'" class=RI_Canvas style="filter:alpha(opacity=10);-moz-opacity:10;visibility:hidden"></div>');
	document.write('</div>');

  this.cdiv   =document.getElementById(this.id);
  this.canvas0=document.getElementById(this.canvasId0);
  this.canvas1=document.getElementById(this.canvasId1);

  this.cdiv.ri = this; // reference from rendered object, back to this

	this.curcanvas = this.canvasId0;
	this.currcanvas= this.canvas0;
	this.nextcanvas= this.canvas1;
	this.pause		= params.pause;
	this.images	  = params.images;
	this.titles		= params.titles;
	this.links		= params.links;
	this.targets	= params.targets;
	this.chain		= params.chain;
	
  this.cdiv.style.border	= params.border;
  this.cdiv.style.width		= params.width;
  this.cdiv.style.height	= params.height;

	this.currimageindex=this.images.length-1;
	this.nextimageindex=this.images.length-1;
	this.nextchainindex=0;
	this.opacity=10;
	this.ii=0; // for debugging

	this.swapcanvas = function(){
		var holdcanvas  	= this.currcanvas;		
		this.currcanvas		= this.nextcanvas;
		this.nextcanvas		= holdcanvas;
	}

	this.setimageopacity = function(){
		if (this.nextcanvas.filters)
			this.nextcanvas.filters.alpha.opacity=this.opacity;
		else if (this.nextcanvas.style.MozOpacity)
			this.nextcanvas.style.MozOpacity=this.opacity/101;
	}
	
	this.fadein = function(){
		if (this.opacity<100){
			this.opacity+=5;
			this.setimageopacity();		
		}
		else{
			clearInterval(this.dropslide);
			this.swapcanvas();
			this.nextcanvas.style.visibility="hidden";
		}
	}

	this.resetnext = function(){
		this.opacity=10;
		this.setimageopacity();		
		this.nextcanvas.style.zIndex++;
		this.nextcanvas.style.visibility="visible";
	}

	this.rotate = function(){
		this.nextimageindex=(this.nextimageindex<this.images.length-1)? this.nextimageindex+1 : 0;
		this.nextcanvas.innerHTML=this.insertimage(this.nextimageindex);
		this.resetnext();
		this.dropslide = setInterval("document.getElementById('"+this.id+"').ri.fadein()",50);
	}

  this.insertimage = function(i){
		var tempcontainer='';
		if( this.images[i]!="" )
		{
			var dolink = (this.links.length > i)   && (this.links[i]   != "")
			var dotarg = (this.targets.length > i) && (this.targets[i] != "")
			var dotitle= (this.titles.length > i) && (this.titles[i] != "")
			if( dolink )
			{
				tempcontainer = '<a href="'+this.links[i]+'"';
				tempcontainer+= (dotarg) ? ' target="'+this.targets[i]+'">' : '>';
			}
			
			tempcontainer += '<img src="'+this.images[i]+'" border="0" ';
			tempcontainer += dotitle ? "title='"+this.titles[i]+"' " : "";
			tempcontainer += dotitle ? "alt='"+this.titles[i]+"' " : "";
			tempcontainer += ">"
			tempcontainer += dolink ? '' : '</a>';
		}
		return tempcontainer;
	}

	this.startit = function(){
		this.currcanvas.innerHTML=this.insertimage(this.currimageindex);
		this.nextcanvas.innerHTML=this.insertimage(this.nextimageindex);
		this.swapcanvas();
		this.rotate();
		
		if( this.chain == null )
			setInterval("document.getElementById('"+this.id+"').ri.rotate()", this.pause);
	}

	this.startit();	
}

function rotatingImageGroup(group,idx,period){

		if( group.length == 0 )
			return;
			
		if( idx < 0 || group.length <= idx )
			return;

		// Rotate just the one being pointed to now.
		// alert( 'Rotate ' + group[idx] );
		// idx = 1;
		var ri = document.getElementById( group[idx] ).ri;
		ri.rotate();

		// Now increment index
		idx = (idx<group.length-1) ? idx+1 : 0;

		// Now resubmit this function at the timeout period
		var i;
		var groupString="['"+group[0]+"'";
		
		for(i=1;i<group.length;i++)
		{
			groupString+=",'"+group[i]+"'";
		}
		groupString+="]";

				
		XTOString = "rotatingImageGroup("+groupString+","+idx+","+period+")";
		
		setTimeout(XTOString,period);
}
