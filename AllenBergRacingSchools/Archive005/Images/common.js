// JavaScript Document


Cufon.replace('h1,h2,h3,h4,.btn_red,.btn_sm_red,.btn_gray');
Cufon.replace('#nav a',{hover: true, textShadow:'rgba(51, 51, 51, 0.3) 1px 1px',letterSpacing:'-0.1px'});

$('selector').load('/feed', Cufon.refresh);


$(document).ready(function() {
	$(".elipse_horiz").each(function() {
		autoEllipseText($(this),true);
	});
	$(".elipse_vert").each(function() {
		autoEllipseText($(this),false);
	});	
});


function autoEllipseText(element, horizontal)
{
	var size = 0;
	var text = element.html();
	//alert(text);
	var inSpan;
	var sizeElement = 0;
	
   if(horizontal) {
	   element.html('<span id="ellipsisSpan" style="white-space:nowrap;">' + text + '</span>'); // it's a one liner, wrap in a span
		sizeElement = $("#ellipsisSpan").width();
		size = parseInt(element.attr("val"));
   } else {
	   element.html('<div id="ellipsisSpan">' + text + '</div>'); // it's a one liner, wrap in a span
	   sizeElement = $("#ellipsisSpan").height();
	   size =  parseInt(element.attr("val"));
   }
   
   if(sizeElement > size)
   {
	  var i = 1;
	  $("#ellipsisSpan").html('');
	  sizeElement = 0;
	  var lastText = '';
	  while(sizeElement < (size) && i < text.length)
	  { 
	  	 
		 $("#ellipsisSpan").html(text.substr(0,i) + '...');
		 
		 if(horizontal) {
		 	sizeElement = $("#ellipsisSpan").width();
		 } else {
 			sizeElement = $("#ellipsisSpan").height();
		 }
		 if(sizeElement < (size) && i < text.length) lastText = text.substr(0,i) + '...';
		 i++; 
	  }
	
	  element.html(lastText.trim()); 
   } else {
   	   element.html(text);
   }
}

function noSpam(vName,vDomain){
	location.href = ("mailto:" + vName + "@" + vDomain);
};


String.prototype.trim = function() {
	a = this.replace(/^\s+/, '');
	return a.replace(/\s+$/, '');
};