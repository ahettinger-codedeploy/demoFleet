
//J3Media, inc OOP slideshow
//07/20/06
//Josh Tischer
//josht@j-3media.com
// =======================================
//
//
// set the following variables
// =======================================
 
// Set slideShowSpeed (milliseconds)
var slideShowSpeed = 3000;

// Duration of crossfade (seconds)
var crossFadeDuration = 3;


// Specify the image files
var Pic = new Array() // don't touch this
// to add more images, just continue
// the pattern, adding to the array below
/*

Create & run a slide show

//create the slideshow
	var ss = new SlideShow("ss","SlideShow");
//Pic argument is an array of img src's
	ss.loadImgs(Pic);
//run the slideshow
	ss.run();

Functions that can be called on the slideshow object once its created
NOTE****
each functions argument ????_button is a this reference of a LINK tag
i.e. 
<a href="" onClick="ss.pause(this);return false;">Pause</a> 
*******************************************************
pause( pause_button) - pauses the slideshow
play( play_button) - starts the slideshow at the current position
stop( stop_button) - pauses the slideshow
goBack(back_button)- pauses the slideshow + shows the previous image
goForward( forward_button) - pauses the slideshow + shows the next image

*******************************************************************

Embed the following code to use the slide show
 ********************************************************** 
<img class="blackborder" id="SlideShow" name="SlideShow" alt="" src="../images/feature_listing.jpg"/>
<br>

<a href="" id="pause" onClick="return ss.pause(this,'button_down');">Pause</a> 
<a href="" id="play" class="button_down" onClick="return ss.play(this,'button_down');">play</a> 
<a href="" id="stop" onClick="return ss.stop(this,'button_down');">stop</a> 
<a href="" id="back" onClick="return ss.goBack(this,'button_down');">back</a> 
<a href="" id="forward"  onClick="return ss.goForward(this,'button_down');">forward</a>

<script language="javascript" type="text/javascript"> 
var Pic = new Array(); 
Pic[0] = '../images/feature_listing.jpg'; 
Pic[1] = '../images/feature_listing2.jpg'; 
Pic[2] = '../images/feature_listing3.jpg';  

var ss = new SlideShow("ss","SlideShow","pause,play,stop,back,forward");
ss.loadImgs(Pic);
ss.run();
 
</script>

end of sample slideshow
***********************************************************

 */
// =======================================
// do not edit anything below this line
// =======================================


/**************************
Arg1: name - Slide Show Object name of the javascript slideshow object i.e.  ss = new SlideShow( "ss", ??, ??)
Arg2: imgName - name & ID of Img object to use as the slideshow
Arg3: buttonIdList - list of ID's of each of the button names "pause,play,stop,back,forward"   
	used for button_down functions

*****************/
function SlideShow(name,imgName, buttonIdList)
{
	this.slideShowName = name;
	this.imageName = imgName;
	
	 this.preLoad = new Array();
	 //ID of timeout
	 this.t=0;
	 //index of current image in rotation
	 this.j = 0;
	 //total number of images in rotation
	 this.p = 0;
	 
	 //turn list into array
	 this.buttonList ="";
	 if(buttonIdList)
	 {
		 this.buttonList =buttonIdList.split(','); 
	 }
	 
	 
	 //Image Object 
	  this.obj = eval("document.images."+this.imageName);
	  
	    this.loadImgs=  function(Pic)
		{
		        this.p = Pic.length
				for (var i = 0;  i < this.p;  i++){
				   this.preLoad[i] = new Image()
				   this.preLoad[i].src =   Pic[ i]
				}
		}

		this.pause = function( pause_button , cssState)
		{  
				if(pause_button)
			 		this.buttonDown(pause_button, cssState);		
				
				if(this.t != 0)
				{
					clearTimeout(this.t);
					this.t =0; 
				}
		//so link doesnt go anywhere
		return false;
		}
		
		this.stop = function( stop_button, cssState)
		{  
			if(stop_button)
		 		this.buttonDown(stop_button, cssState);		
			this.pause();
		//so link doesnt go anywhere
		return false;
		}
		
		this.play = function( play_button, cssState)
		{  
			if(play_button)
		 	this.buttonDown(play_button, cssState);		
				if(this.t == 0)
				{
					this.t = setTimeout( name+'.run()', slideShowSpeed); 
				}
		
		//so link doesnt go anywhere
		return false;
		}
		this.goBack = function( back_button, cssState)
		{  
			if(back_button)
		 	this.buttonDown(back_button, cssState);		
		 
			if(this.j <= 0)
			{
				this.j = this.p-1;
			}
			else if(this.j >0 )
			{
				this.j = this.j -1;
			}
			else if(this.j > (this.p-1))
			{
				this.j = 0;
			}
		 
			this.pause();
			this.obj.src = this.preLoad[this.j].src;
		
		//so link doesnt go anywhere
		return false;
		}
		
		this.goForward = function( forward_button, cssState)
		{  
			if(forward_button)
		 		this.buttonDown(forward_button, cssState);		 	
		 
			if( this.j >= (this.p-1) )
			{
				this.j = 0
			}
			else 
			{
				this.j = this.j +1;
			}
		 
			this.pause();
			this.obj.src = this.preLoad[this.j].src;
			
		//so link doesnt go anywhere
		return false;
		}

		 this.run =function()
		 {
			
			 
			if(this.obj)
			{
			if (document.all){
				  this.obj.style.filter="blendTrans(duration=2)"
				  this.obj.style.filter="blendTrans(duration=crossFadeDuration)"
				  this.obj.filters.blendTrans.Apply()      
			   }
			   
			 
			   //document.links.SlideShowLink.href = LinkArray[j];
			   this.obj.src = this.preLoad[this.j].src;
			   if (document.all){
				  this.obj.filters.blendTrans.Play()
			   }
			}
			
			
			  this.j = this.j + 1;   
			   if (this.j > (this.p-1))
			   {
				 this.j=0; 
				 
			   } 
			 
			 this.t = setTimeout( this.slideShowName+'.run()', slideShowSpeed);
		
		}
		
		
		 
		//changes the style of the button to be in a down state
		this.buttonDown  = function(  buttonObj, cssState )
		{
				this.clearButtons();
				 
				if(buttonObj)
				{
					buttonObj.className = cssState;
				}
		 
		}
		
		//clears cssDown state of all the buttons
		this.clearButtons = function()
		{
			var curButton ="";
			for( var x =0; x < this.buttonList.length; x++)
			{ 
				curButton = this.buttonList[x];
				
				if(document.getElementById(curButton))
					document.getElementById(curButton).className="";
			}
		}
		
 
}