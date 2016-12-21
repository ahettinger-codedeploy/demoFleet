  var screenWidth = document.getElementById("html").offsetWidth;
  var percentW = screenWidth / 100 - 8; percentW = 90 - (percentW * 2); 
  var trueWidth = Math.round(screenWidth * percentW / 100);

  var screenHeight = document.getElementById("html").offsetHeight;
  document.getElementById("container").style.height = (screenHeight - 208) + "px";
  document.getElementById("sidebar").style.height = (screenHeight - 208) + "px";

// cap header width
  if (trueWidth < 791 + 8 + 8) {trueWidth = 791 + 8 + 8}
  document.getElementById("body").style.width = trueWidth + "px";

// adjust supporting header graphic
  if (document.getElementById("mainTitle").offsetWidth + document.getElementById("maineAle").offsetWidth + 20 > trueWidth) {
    document.getElementById("maineAle").style.display = "none";
  }

// start slide show
  var address = document.location.toString();
  if (address.indexOf("photos") == -1) {
    window.setInterval("slideShow()", 3000);
  }