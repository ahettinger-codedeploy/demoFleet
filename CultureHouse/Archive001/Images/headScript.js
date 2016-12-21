var loadDone = "no";
var elementsLoaded = "no";

//loadImg();

function loadImg() {
  if (document.images) {
    babycoff	= new Image();	babycoff.src	= "/images/babyc1.gif";
    babycon	= new Image();	babycon.src	= "/images/babyc2.gif";
    loadDone = "yes";
  }
}
function show(currElem) {
  if (elementsLoaded == "yes") {
    stdBrowser = (document.getElementById) ? true : false;
    if (currElem) {
      popUpWin = (stdBrowser) ? document.getElementById(currElem).style : eval("document." + currElem);
      popUpWin.visibility = "visible";
    }
  }
}
function hide(currElem) {
  if (elementsLoaded == "yes") {
    stdBrowser = (document.getElementById) ? true : false;
    if (currElem) {
      popUpWin = (stdBrowser) ? document.getElementById(currElem).style : eval("document." + currElem);
      popUpWin.visibility = "hidden";
    }
  }
}
function cImg() {
  if (loadDone == "yes") {
    if (document.images) {
      for (var i=0; i<cImg.arguments.length; i+=2) {
        document[cImg.arguments[i]].src = eval(cImg.arguments[i+1] + ".src");
      }
    }
  }
}
