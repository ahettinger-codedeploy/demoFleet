	COLUMBIAN=document.URL

var formno = "1181"
if (self == top) {
	if(JS > 1.0) {
		window.location.replace("http://www.columbiantheatre.com/main2.asp?linkURL=" + COLUMBIAN + "");
	} else {
		top.location = "http://www.columbiantheatre.com/main2.asp?linkURL=" + COLUMBIAN + "";
	}
}


//	if (top.location == self.location) {
//		if(jsVersion > 1.0) {
//			window.location.replace("main2.html?'+COLUMBIAN'")
//			// top.location.href = "main2.html?'+COLUMBIAN'"
//		}
//		else {
//			top.location.href = "main2.html?'+COLUMBIAN'"
//		}
//	}