//////////////////////////////////////////////////////////////////////////////
// openslideshow.js - Implement openslideshow feature for WST Photo Album plugin
// ---------------------------------------------------------------------------
// JAR 2006.06.20: Moved from C# code, clean up, fix bugs, and document.
//////////////////////////////////////////////////////////////////////////////


/****************************** IMMEDIATE CODE ******************************/

//------------------------------------------
// Configure constants for slideshow applet
//------------------------------------------

_slideShowURL = "plugins/albums/slideshow/slideshow.html";
_ssWinWdFudge = 112;
_ssWinHtFudge = 220;
_screenFudge = 40;
_minWinWd = 440;
_minWinHt = 360;

//-----------------------------------------------
// Create slides array for recording slides data
//-----------------------------------------------

_slides = new Array();

//------------------------------
// Init album and image indexes
//------------------------------

_currentSlideGroup = 0; // Which album on a page?
_currentSlideIndex = 0; // Which image in album?
_windowHeight = 0;      // Height of window (calculated in openSlideShow())


/***************************** PUBLIC FUNCTIONS *****************************/

//------------------------------------------
// Generic function to return URL parameter
//------------------------------------------

function getURLParam(sParam)
{
  var sRet="", sHref=window.location.href;
  if (sHref.indexOf("?") > -1 )
  {
    var sQueryString = sHref.substr(sHref.indexOf("?") + 1);
    var aQueryString = sQueryString.split("&");
    for (var i=0; i<aQueryString.length; i++)
    {
      if (aQueryString[i].indexOf(sParam + "=") >= 0)
      {
        var aParam = aQueryString[i].split("=");
        sRet = aParam[1];	
        break;
      }
    }
  }
  return sRet;
} 

//-------------------------
// The Slide "constructor"
//-------------------------

function Slide(width,height,url,caption) 
{
  this.width = width;    // actual image width
  this.height = height;  // actual image height
  this.url = url;
  this.caption = caption;
  this.slideHt = 0; // presentation height, calculated in openSlideShow()
  this.slideWd = 0; // presentation width, calculated in openSlideSHow()
}

//-----------------------------------------
// Sets focus to appropriate album in page
//-----------------------------------------

function onLoadBodyAlbums()
{
  var activeAlbum = getURLParam("aa");
  if (activeAlbum.length > 0)
  {
    activeAlbum = parseInt(activeAlbum,10);
    var albumNavName = "album" + activeAlbum + "_nav"; 
    var albumNav = document.getElementById(albumNavName);
    if (albumNav) 
      window.location.replace("#" + albumNavName);
  }
}

//--------------------------------------------------------------------------
// Opens a new window with the selected album/image in the slideshow applet
//--------------------------------------------------------------------------

function openSlideShow(imageGroup,initialIndex) 
{
  // Set selected album/slide variables:
  _currentSlideGroup = imageGroup;
  _currentSlideIndex = initialIndex;

  // Find max image dims:
  var i, album=_slides[_currentSlideGroup], maxWd=0, maxHt=0;
  for (i=0; i<album.length; i++)
  {
    maxWd = Math.max(maxWd,album[i].width);
    maxHt = Math.max(maxHt,album[i].height);
  }

  // Determine optimal size of slideshow window:
  var winWidth = Math.max(Math.min(maxWd+_ssWinWdFudge,screen.availWidth-_screenFudge),_minWinWd);
  var winHeight = Math.max(Math.min(maxHt+_ssWinHtFudge,screen.availHeight-_screenFudge),_minWinHt);
  
  // Adjust presentation dimensions for images (squash if necessary):
  for (i=0; i<album.length; i++)
  {   
    album[i].slideWd = album[i].width;
    album[i].slideHt = album[i].height;
  
    var slideWd=album[i].width, slideHt=album[i].height;
    var extraWd=slideWd+_ssWinWdFudge-winWidth, extraHt=slideHt+_ssWinHtFudge-winHeight;
    if (extraWd>0 || extraHt>0)
    {
      // See which of width or height is most offensive and adjust accordingly:
      var squash = (extraWd > extraHt ? 
        (winWidth-_ssWinWdFudge) / slideWd :
	(winHeight-_ssWinHtFudge) / slideHt);
      album[i].slideWd *= squash;
      album[i].slideHt *= squash;
    }
  }
  
  // Set this variable for slideshow use:
  _windowHeight = winHeight;

  // Open slideshow window/url:
  var slideWindow = window.open(_slideShowURL,"wst_slideshow",
    "scrollbars=yes,titlebar=no,location=no,status=no,toolbar=no,resizable=yes,width=" + 
    winWidth + ",height=" + winHeight);
  slideWindow.focus();
}

/* end of file */
