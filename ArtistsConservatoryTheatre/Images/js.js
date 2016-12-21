function photoShow(location,width,height){
	window.open(location,'','width='+width+',height='+height+',location=no,menubar=no,toolbar=no,status=no');
}
function getCurrentPage(){
	var sPath = window.location.pathname;
	var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
	return sPage;
}
function emailsignup(registererror){
	var checkEmail = document.emailsignup.txtemail.value
	if( checkEmail == "" || 
	   	checkEmail.indexOf('@') == -1 ||
		checkEmail.indexOf("<script") != -1 ||
		( checkEmail.charAt(checkEmail.length-4) != '.' && checkEmail.charAt(checkEmail.length-3) != '.')
	){
		window.alert("" + registererror);
		return false;
	} else {
		document.emailsignup.submit();
	}
}
function emailsignup2(registererror){
	emailsignup(registererror);
}
function ValidateReactie(errormessage){
	var naam = document.frmreactie.txtnaam.value;
	var titel = document.frmreactie.txttitel.value;
	var tekst = document.frmreactie.txttekst.value;		
	
	if(naam == "" || titel == "" || tekst == "")
	window.alert("" + errormessage);
	else
	{
		document.frmreactie.txtsubmit.value = "submit";
		document.frmreactie.submit();
	}

}
function ValidateOnderwerp(error){
	var onderwerp = document.frmthread.txtonderwerp.value;
	
	if(onderwerp == "")
	window.alert("" + error);
	else
	document.frmthread.submit();

}
function OpenProductFotos(id){
	window.open('productfotos.php?id=' + id,'','width=670,height=500,location=no,menubar=no,toolbar=no,status=no,scrollbars=yes');
}
sfHover = function() {
	try {
		var sfEls = document.getElementById("nav").getElementsByTagName("LI");	
		for (var i=0; i<sfEls.length; i++) {
			sfEls[i].onmouseover=function() {
				this.className+=" sfhover";
			}
			sfEls[i].onmouseout=function() {
				this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
			}
		}
	} catch (error) {}
	try {		
		var sfEls = document.getElementById("nav2").getElementsByTagName("LI");	
		for (var i=0; i<sfEls.length; i++) {
			sfEls[i].onmouseover=function() {
				this.className+=" sfhover";
			}
			sfEls[i].onmouseout=function() {
				this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
			}
		}
	} catch (error) {}
}

function opacity(id, opacStart, opacEnd, millisec) { 
    var speed = Math.round(millisec / 100); 
    var timer = 0; 

    if(opacStart > opacEnd) { 
        for(i = opacStart; i >= opacEnd; i--) { 
            setTimeout("changeOpac(" + i + ",'" + id + "')",(timer * speed)); 
            timer++; 
        } 
    } else if(opacStart < opacEnd) { 
        for(i = opacStart; i <= opacEnd; i++) 
            { 
            setTimeout("changeOpac(" + i + ",'" + id + "')",(timer * speed)); 
            timer++; 
        } 
    } 
}
function changeOpac(opacity, id) { 
    var object = document.getElementById(id).style; 
    object.opacity = (opacity / 100); 
    object.MozOpacity = (opacity / 100); 
    object.KhtmlOpacity = (opacity / 100); 
    object.filter = "alpha(opacity=" + opacity + ")"; 
}
function ImageViewer()
{
	document.getElementById("slide").style.display = "";
	document.getElementById("noslide").style.display = "none";
	document.getElementById("previous_link").style.display = "";
	document.getElementById("next_link").style.display = "";
	run = 1;
	teller = parseInt(document.getElementById("hiddenteller").value);
	if( teller == 0 )
		document.getElementById("previous_link").style.display = "none";		
	else
		document.getElementById("previous_link").style.display = "";
	if( teller == p - 1 )
		document.getElementById("next_link").style.display = "none";		
	else
		document.getElementById("next_link").style.display = "";		
}
function Next()
{
	document.getElementById("next_link").style.display = "";	
	document.getElementById("previous_link").style.display = "";		
	teller = parseInt(document.getElementById("hiddenteller").value);
	if(teller < p - 1)
	{
		document.getElementById("hiddenteller").value = teller + 1;
		var image = Pic[teller + 1];
		document.images.SlideShow.src = "images/dbimages/photobook/" + image;	
	    document.images.SlideShow.width = Width[teller + 1]
	    document.images.SlideShow.height = Height[teller + 1]								
		if(teller == p-2)
		{
			document.getElementById("next_link").style.display = "none";			
		}		
	}
}
function Previous()
{
	document.getElementById("previous_link").style.display = "";	
	document.getElementById("next_link").style.display = "";		
	teller = parseInt(document.getElementById("hiddenteller").value);
	if(teller > 0)
	{
		document.getElementById("hiddenteller").value = teller - 1;
		var image = Pic[teller - 1];
		document.images.SlideShow.src = "images/dbimages/photobook/" + image;
	    document.images.SlideShow.width = Width[teller - 1]
	    document.images.SlideShow.height = Height[teller - 1]					
		if(teller == 1)
		{
			document.getElementById("previous_link").style.display = "none";		
		}		
	}
}
function runSlideShow(){
	if( run == 0 ){
		document.getElementById("previous_link").style.display = "none";
		document.getElementById("next_link").style.display = "none";
		document.getElementById("slide").style.display = "none";
		document.getElementById("noslide").style.display = "";
	   if (document.all){
		  document.images.SlideShow.style.filter="blendTrans(duration=2)"
		  document.images.SlideShow.style.filter="blendTrans(duration=3)"
		  document.images.SlideShow.filters.blendTrans.Apply()      
	   }
	   document.images.SlideShow.src = "images/dbimages/photobook/" + Pic[j]
	   document.images.SlideShow.width = Width[j]
	   document.images.SlideShow.height = Height[j]
	   if (document.all){
		  document.images.SlideShow.filters.blendTrans.Play()
	   }
	   document.getElementById("hiddenimage").value = j;
	   document.getElementById("hiddenteller").value = j
	   j = j + 1
	   if (j > (p-1)) j=0
	   t = setTimeout('runSlideShow()', 3000)
	}
}
function startSlideShow(){
	run = 0;
	runSlideShow();
}
if (window.attachEvent) window.attachEvent("onload", sfHover);