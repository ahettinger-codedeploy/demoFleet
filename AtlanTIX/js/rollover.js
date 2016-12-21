
if (document.images) {
  image1on = new Image();
    image1on.src = "/privatelabel/atlantix/images/topnav_showguide_on.gif";
  image1off = new Image();
    image1off.src = "/privatelabel/atlantix/images/topnav_showguide_off.gif";
  image2on = new Image();
    image2on.src = "/privatelabel/atlantix/images/topnav_atlantix_on.gif";
  image2off = new Image();
    image2off.src = "/privatelabel/atlantix/images/topnav_atlantix_off.gif";
  image3on = new Image();
    image3on.src = "/privatelabel/atlantix/images/topnav_jobs_on.gif";
  image3off = new Image();
    image3off.src = "/privatelabel/atlantix/images/topnav_jobs_off.gif";    
  image4on = new Image();
    image4on.src = "/privatelabel/atlantix/images/topnav_auditions_on.gif";
  image4off = new Image();
    image4off.src = "/privatelabel/atlantix/images/topnav_auditions_off.gif";
}

function changeImages() {
  if (document.images) {
    for (var i=0; i<changeImages.arguments.length; i+=2) {
      document[changeImages.arguments[i]].src = eval(changeImages.arguments[i+1] + ".src");
    }
  }
}

