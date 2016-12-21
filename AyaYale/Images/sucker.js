sfHover = function() {
  var sfEls
  if (document.getElementById("sidebar-left")){
    sfEls = document.getElementById("sidebar-left").getElementsByTagName("LI");
    for (var i=0; i<sfEls.length; i++) {
      sfEls[i].onmouseover=function() {
        this.className+=" sfhover";
      }
      sfEls[i].onmouseout=function() {
        this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
      }
    }
  }


  var sfEls2 = document.getElementById("topnavbar").getElementsByTagName("LI");
  for (var i=0; i<sfEls2.length; i++) {
    sfEls2[i].onmouseover=function() {
      this.className+=" sfhover";
    }
    sfEls2[i].onmouseout=function() {
      this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
    }
  }
 
}

if (window.attachEvent) window.attachEvent("onload", sfHover);


