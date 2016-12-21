imgFiles = new Array("topnav_ab_js_js-on.gif",
                     "topnav_js_sa2_js-on.gif",
                     "topnav_js_sa_js-on.gif",
                     "topnav_ab_js_ab-on.gif",
                     "topnav_cs_ab2_ab-on.gif",
                     "topnav_cs_ab_ab-on.gif",
                     "topnav_cs_ns_ab_ab-on.gif",
                     "topnav_cs_ab2_cs-on.gif",
                     "topnav_cs_ns_ab_cs-on.gif",
                     "topnav_cs_ab_cs-on.gif",
                     "topnav_js_sa2_sa-on.gif",
                     "topnav_js_sa_sa-on.gif",
                     "topnav_sa_sa-on.gif",
                     "topnav_cs_ns_ab_ns-on.gif",
                     "topnav_bo_ns_ns-on.gif",
                     "topnav_bo_ns_bo-on.gif");

areacodes = new Array("ab", "sa", "bo", "js", "ns", "cs", "sh");
AC = new Object;
AC.ab = "about";
AC.sa = "archive";
AC.bo = "boxoffice";
AC.js = "join";
AC.ns = "now_showing";
AC.cs = "season";
AC.sh = "shows";
AC.home = "";
current_area = "";
setCurrent = "";

function figureCode()
{
  current_area = "home";
  for (i = 0; i < areacodes.length; i++)
  {
    if (String(document.location.pathname).indexOf("/" + eval("AC." + areacodes[i]) + "/") != -1)
    {
      if (areacodes[i] == "sh") current_area = "home";
	  	else current_area = areacodes[i];
    }
  }
}

function preLoad()
{
  preloadArray = new Array();
  for (i = 0; i < imgFiles.length; i++)
  {
    preloadArray[i] = new Image;
    preloadArray[i].src = "/topnav/" + imgFiles[i];
  }
  // alert ("Preload done.");
}

function turnOn(area)
{
  if (!current_area)
  {
    figureCode();
    turnOff(current_area);
  }
  if (setCurrent)
  {
    clearTimeout(setCurrent);
    setCurrent = "";
  }
  if (navigator.userAgent.indexOf("WebTV/1.2") == -1)
  {
    for (var i = 0; i < document.images.length; i++)
    {
      img = document.images[i];
      if (img.name)
      {
        oldSrc = new String(img.src);
        // alert ("Checking " + img.name + " for '" + area + "'.");
        if (String(img.name).indexOf("_" + area) != -1)
        {
          // Check if '-on' is already there before adding - I.E. 4.x bug
          if ((oldSrc.lastIndexOf("-on.gif")) == -1)
            newSrc = oldSrc.substring(0,oldSrc.lastIndexOf(".gif")) + "_" + area + "-on.gif";
          else
            newSrc = oldSrc;
          // alert (oldSrc + " -> " + newSrc);
          img.src = newSrc;
        }
      }
    }
  }
}

function turnOff(area)
{
  if (navigator.userAgent.indexOf("WebTV/1.2") == -1)
  {
    for (var i = 0; i < document.images.length; i++)
    {
      img = document.images[i];
      if (img.name)
      {
        oldSrc = new String(img.src);
        if (String(img.name).indexOf("_" + area) != -1)
        {
          if (1)
            newSrc = oldSrc.substring(0,oldSrc.lastIndexOf("-on.gif") - 3) + ".gif";
          else
            newSrc = oldSrc;
          // alert (oldSrc + " -> " + newSrc);
          img.src = newSrc;
        }
      }
    }
  }
  setCurrent = setTimeout("turnOn(current_area);current_area=''", 1000);
}
