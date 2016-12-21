function bookmark(){
  if (document.all) {
    if (window.location.href.indexOf("http")) {
      alert("You cannot bookmark a page on your local computer.");
    } else {
      window.external.AddFavorite(document.location.href,document.title)
    }
  } else {
    alert("Please select CTRL-D to bookmark this page");
  }
}

function makeHomePage() {
	if (document.all){
	  document.body.style.behavior='url(#default#homepage)';
      document.body.setHomePage(document.location);
	}
}

function getCookie() {
  var cookieName = document.location;
  var cookieBox = document.cookie.split("; ");
  for (var i=0; i< cookieBox.length; i++) {
      var cookiePacket = cookieBox[i].split("=");
      if (cookieName == cookiePacket[0]) {
        return unescape(cookiePacket[1]);
      }
  }
  return 0;
}

function setCookie(myCookieState, isPersistant) {
  if (!myCookieState) {
    myCookieState = 0;
  }
  myCookieState++;
  myCookieInfo = document.location + "=" + myCookieState+ "; ";

  if (isPersistant == 1) {
    cookieExpiration = new Date();
    cookieExpiration.setFullYear(cookieExpiration.getFullYear() + 1);
    myCookieInfo = myCookieInfo + "expires="+cookieExpiration.toUTCString()+"; ";
  }
  document.cookie = myCookieInfo;
}
