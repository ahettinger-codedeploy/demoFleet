function wsp_printCoupon(E){var F="iframe_"+E;
function D(){var G=document.getElementById(F);
if(G){G.parentNode.removeChild(G)
}}function C(L,G){var I,K,J;
if(navigator.appName=="Microsoft Internet Explorer"){I=window.frames[L];
K=I.window.document;
J=I.window
}else{I=document.getElementById(L);
K=I.contentDocument;
J=I.contentWindow
}var H=K.getElementsByTagName("head").item(0);
if(!H||!K.body||K.title!="coupon_html"){K.open("text/html");
K.write('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html>');
K.writeln('<head xmlns="http://www.w3.org/1999/xhtml">');
K.writeln("<title>coupon_html</title>");
K.writeln('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">');
K.writeln("<style>");
K.writeln("@media print { #table_border { border: 1px #000000 dashed; } }");
K.writeln("</style>");
K.writeln("</head>");
K.writeln("<body>");
K.writeln(G.innerHTML);
K.writeln("</body>");
K.writeln("</html>");
K.close();
window.setTimeout(function(){C(L)
},100);
return 
}J.focus();
if(J.attachEvent){if(!J.attachEvent("onafterprint",D)){setTimeout(D,5000)
}window.print()
}else{J.print();
setTimeout(D,5000)
}}var A=document.getElementById(E);
var B=document.createElement("iframe");
B.setAttribute("id",F);
B.setAttribute("border","0");
B.setAttribute("frameBorder","0");
B.setAttribute("marginWidth","0");
B.setAttribute("marginHeight","0");
B.setAttribute("leftMargin","0");
B.setAttribute("topMargin","0");
B.setAttribute("scrolling","no");
B.setAttribute("width",100);
B.setAttribute("height",100);
document.body.appendChild(B);
B.setAttribute("src",wsp_htmlref_blank);
C(F,A)
}
