//Fade-in image slideshow- By Dynamic Drive
//For full source code and more DHTML scripts, visit http://www.dynamicdrive.com
//This credit MUST stay intact for use

var slideshow_width='170px' //SET IMAGE WIDTH
var slideshow_height='682px' //SET IMAGE HEIGHT
var pause=3000 //SET PAUSE BETWEEN SLIDE (3000=3 seconds)

var fadeimages=new Array()
//SET IMAGE PATHS. Extend or contract array as needed
fadeimages[0]="images/home-01.jpg"
fadeimages[1]="images/home-02.jpg"
fadeimages[2]="images/home-03.jpg"
fadeimages[3]="images/home-04.jpg"
fadeimages[4]="images/home-05.jpg"
fadeimages[5]="images/home-06.jpg"
fadeimages[6]="images/home-07.jpg"
fadeimages[7]="images/home-08.jpg"
fadeimages[8]="images/home-09.jpg"

////NO need to edit beyond here/////////////

var preloadedimages=new Array()
for (p=0;p<fadeimages.length;p++){
preloadedimages[p]=new Image()
preloadedimages[p].src=fadeimages[p]
}

var ie4=document.all
var dom=document.getElementById

var curpos=10
var degree=10
var curcanvas="canvas0"
var curimageindex=0
var nextimageindex=1

function fadepic(){
if (curpos<100){
curpos+=10
if (tempobj.filters)
tempobj.filters.alpha.opacity=curpos
else if (tempobj.style.MozOpacity)
tempobj.style.MozOpacity=curpos/100
}
else{
clearInterval(dropslide)
nextcanvas=(curcanvas=="canvas0")? "canvas0" : "canvas1"
tempobj=ie4? eval("document.all."+nextcanvas) : document.getElementById(nextcanvas)
tempobj.innerHTML='<img src="'+fadeimages[nextimageindex]+'">'
nextimageindex=(nextimageindex<fadeimages.length-1)? nextimageindex+1 : 0
setTimeout("rotateimage()",pause)
}
}

function rotateimage(){
if (ie4||dom){
resetit(curcanvas)
var crossobj=tempobj=ie4? eval("document.all."+curcanvas) : document.getElementById(curcanvas)
crossobj.style.zIndex++
var temp='setInterval("fadepic()",50)'
dropslide=eval(temp)
curcanvas=(curcanvas=="canvas0")? "canvas1" : "canvas0"
}
else
document.images.defaultslide.src=fadeimages[curimageindex]
curimageindex=(curimageindex<fadeimages.length-1)? curimageindex+1 : 0
}

function resetit(what){
curpos=10
var crossobj=ie4? eval("document.all."+what) : document.getElementById(what)
if (crossobj.filters)
crossobj.filters.alpha.opacity=curpos
else if (crossobj.style.MozOpacity)
crossobj.style.MozOpacity=curpos/100
}

function startit(){
var crossobj=ie4? eval("document.all."+curcanvas) : document.getElementById(curcanvas)
crossobj.innerHTML='<img src="'+fadeimages[curimageindex]+'">'
rotateimage()
}
