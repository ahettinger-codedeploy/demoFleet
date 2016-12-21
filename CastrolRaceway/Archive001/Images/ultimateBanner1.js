var numberOfBanners = 5;
var pause       = 3000; 
var imageWidth  = 565;
var imageHeight = 100;
var dir         = "Images/";
var rotate      = "true";

var getBanner  = new Array("EMDA 2008 Banner Ad.jpg", "JBs-Ad.jpg", "For Sale Banner Ad.jpg", "stang_banner.gif", "CapitalGear_BannerAd.jpg");
var getSiteUrl = new Array(numberOfBanners); 
getSiteUrl[0]  = "http://www.emdacars.com/motorshow/";
getSiteUrl[1]  = "http://www.jbspowercentre.com";
getSiteUrl[2]  = "http://www.castrolraceway.com/contact.html";
getSiteUrl[3]  = "http://www.stangmotorsports.com";
getSiteUrl[4]  = "http://www.capitalgear.ca";

var pages   = new Array("index.htm","media.html");

var banners0 = new Array("3"); 
var banners1 = new Array("0","1","2","3"); 
var banners2 = new Array("3","4"); 
var banners3 = new Array("1","2","3");
var banners4 = new Array("0","2","4");
////////////////////////Nothing below this line need to be modified/////////////////////////////

var counter  = 0;
var nBanners = numberOfBanners;
var add      = "";
var b = new Banner(); 
b.desireBanners();

function Banner()
  {
  this.banner  = new Array(nBanners);  
  this.Url     = new Array(nBanners);                      
  this.banners = banners;
  this.address = address;
  this.desireBanners = desireBanners;
  this.setBanners = setBanners;
  }

function banners(tempBanner,i)
  {    
  this.banner[i]     = new Image(imageWidth,imageHeight);                 
  this.banner[i].src = dir + tempBanner; 
  }

function address(getUrl,i) 
  {this.Url[i] = getUrl;}

function desireBanners()
  {
  for (var i = 0; i < numberOfBanners; i++)
     {
     var loc    = location.pathname;
     var length = loc.length;
     var start  = loc.lastIndexOf('/') + 1;
     var desirPage = loc.substring(start,length);
     if (desirPage == pages[i])
       { 
       eval("nBanners = banners" + i +".length");
       for (var j = 0; j < nBanners; j++)
          {
          eval("this.banners(getBanner[banners" + i + "[" + j + "]]," + j + ")");
          eval("this.address(getSiteUrl[banners" + i + "[" + j + "]]," + j + ")");
          }
       return;
       }
     }
  for (var j = 0; j < nBanners; j++)
     {
     this.banners(getBanner[j],j);
     this.address(getSiteUrl[j],j);
     }
  }

function setBanners()  
  {
  document.img.src = this.banner[counter].src;   
  add = this.Url[counter];
  }

function displayBanners()
  {
  if (rotate == "false") {counter = Math.round(Math.random() * (nBanners - 1));}
  b.setBanners();
  if (rotate == "true")
    {
    counter++;                                 
    if (counter > (nBanners - 1)) {counter = 0;}
    setTimeout("displayBanners()",pause);
    }  
  }

function goTo() {document.location.href = add;}

function show() {window.status = add;}
// End -->