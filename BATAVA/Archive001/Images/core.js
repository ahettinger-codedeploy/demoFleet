var msets=false;var msetm=true;mindex=0;thispage=0;thisparent=0;var popm=false;var dii=document.images;function mset(){if(typeof (funcOnPageLoad)!="undefined"){funcOnPageLoad()}if(dii["i"+thispage]!=null){dii["i"+thispage].src=bd+"sel_"+thispage+".gif?r="+Math.floor(Math.random()*100000)}if(thisparent!=0&&dii["i"+thisparent]!=null){dii["i"+thisparent].src=bd+"sel_"+thisparent+".gif"}if(mindex==0){return }var A=irootsite+"/menu/over_";if(msetm&&msetm==true){for(x=1;x<mi.length;x++){i=mi[x];mi[x]=new Image();mi[x].src=A+i+".gif"}}if(msets&&msets==true){for(x=1;x<ms.length;x++){i=ms[x];ms[x]=new Image();ms[x].src=A+i+".gif"}}}function ovp(A,B){pom=true}function ot(A){if(popm){otpop(A);return }if(dii["i"+A]==null){return }if(A!=thispage){dii["i"+A].src=bd+A+".gif"}else{dii["i"+A].src=bd+"sel_"+A+".gif"}}function ov(A,B){if(popm){ovpop(A,B);return }dii["i"+A].src=bd+"over_"+A+".gif"}function iflashi(C,A,B,E){var D=document;pn="<PARAM NAME=";sz='WIDTH="'+A+'" HEIGHT="'+B+'"';D.writeln('<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,0,0" '+sz+' id="tf" name="tf" ALIGN="">');D.writeln(pn+'movie VALUE="'+C+'">');if(E==true){D.writeln(pn+"ALIGN VALUE=L>");D.writeln(pn+"SALIGN VALUE=TL>")}D.writeln(pn+"Loop VALUE=true>");D.writeln(pn+"quality VALUE=best>");D.writeln(pn+'"wmode" value="transparent">');D.writeln(pn+"scale VALUE=noscale>");D.writeln(pn+"play VALUE=true>");D.writeln('<EMBED src="'+C+'" quality=best '+sz+' wmode="transparent" align="left" salign="TL"  scale="noscale" scalemode="noscale" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></EMBED>');D.writeln("</OBJECT>")}function iembedi(A){document.write(A)}function ezPOpen(A){ezgu(A,"_self","")}function ezgu(B,A,C){window.open(siteurl+B,A,C)};