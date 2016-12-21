if(typeof jslang=="undefined"){LoadLangVAsync("EN")}else{if(jslang=="JP"){jslang="JA"}if(jslang=="CS"){jslang="CZ"}if(jslang=="SI"){jslang="SL"}LoadLangVAsync(jslang)}function LoadLangVAsync(b){if(top==window&&window.master=="ctl00_"){setTimeout(function(){LoadLangV(b)},300)}else{LoadLangV(b)}}function LoadLangV(b){if(document.getElementById("RADEDITORSTYLESHEET0")){return}var c=document.createElement("script");c.setAttribute("src","/BcJsLang/ValidationFunctions.aspx?lang="+b);c.setAttribute("charset","utf-8");c.setAttribute("type","text/javascript");document.getElementsByTagName("head")[0].appendChild(c)}function formfield(d,h){switch(h){case"firstupper":var e=true;var f=true;for(var b=1;b<d.length;b++){var j=d.charCodeAt(b);if(j>=65&&j<=90){f=false}if(j>=97&&j<=127){e=false}}if(e||f){var g=d.split(" ");d="";for(var b=0;b<g.length;b++){if(g[b].length>=1){d=d+" "+g[b].substring(0,1).toUpperCase()+g[b].substring(1).toLowerCase()}}}d=d.replace(".","");d=d.replace(",","");break;case"firstupperspecial":var g=d.split(" ");d="";for(var b=0;b<g.length;b++){if(g[b].length>=1){d=d+" "+g[b].substring(0,1).toUpperCase()+g[b].substring(1)}}break;case"alllower":d=d.toLowerCase();break;case"allupper":d=d.toUpperCase();break;default:break}if(d.substring(0,1)==" "){d=d.substring(1)}return d}function isCurrency(e,b){var f="";if(e.length==0){f="- "+b+validatelang.Currency.MustNumber}else{for(var d=0;d<e.length;d++){var g=e.charAt(d);if((g<"0")||(g>"9")){if(g!="."&&g!=","){f="- "+b+validatelang.Currency.NoSymbol}}}}return f}function isNumeric(e,b){var f="";if(e.length==0){f="- "+b+validatelang.Number.MustNumber}else{var d;for(d=0;d<e.length;d++){var g=e.charAt(d);if((g<"0")||(g>"9")){f="- "+b+validatelang.Number.NoDecimal;return f}}}return f}function isFloat(e,b){var f="";var d;if(e.length==0){f="- "+b+validatelang.Float.MustNumber}else{for(d=0;d<e.length;d++){var g=e.charAt(d);if(((g<"0")||(g>"9"))){if(g!="."&&g!=","){f="- "+b+validatelang.Float.MustNumber;return f}}}}return f}function isEmpty(c,b){var d="";if(c.trim().length==0){d=validatelang.Enter.PleaseEnter+b+"\n"}return d}function checkDropdown(c,b){var d="";if(c.length==0||c==" "){d=validatelang.Select.PleaseSelect+b+"\n"}return d}function checkEmail(c){var b="";if(c.length>0){var e=/^[^@]+@[^@]+\.[^@]{2,6}$/;if(!(e.test(c))){b=validatelang.Email.ValidEmail}else{var d=/[\(\)\<\>\,\;\:\\\"\[\]]/;if(c.match(d)){b=validatelang.Email.Illegal}}}else{b=validatelang.Email.ValidEmail}return b}function checkSelected(b,d){var e="- "+d+validatelang.Select.MustSelect;if(b.length>0){for(var c=0;c<b.length;c++){if(b[c].disabled==false&&b[c].checked==true){e=""}}}else{if(b.disabled==false&&b.checked==true){e=""}}return e}function getRadioSelected(b){if(b.length>0){for(var c=0;c<b.length;c++){if(b[c].disabled==false&&b[c].checked==true){return b[c].value}}}else{if(b.disabled==false&&b.checked==true){return b.value}}return null}function checkSelectedX(d,b){var e="- "+b+validatelang.Select.MustSelect;var c=document.getElementById(d);var g=c.getElementsByTagName("td");var h;for(var f=0;f<g.length;f++){h=g[f].firstChild;if(h&&(h.type=="checkbox"||h.type=="radio")){if(h.disabled==false&&h.checked==true){e=""}}}return e}function checkSpaces(d,b){var e="";for(var c=0;c<d.length;c++){if(d.charAt(c)==" "){e="- "+b+validatelang.Others.CannotContain+validatelang.Others.WhiteSpace}}return e}function checkUrlChar(d,b){var e="";for(i=0;i<d.length;i++){var f=d.charAt(i);switch(f){case"/":case"\\":case"#":case"?":case":":case"@":case"=":case"&":case'"':case"|":case"_":case".":case"%":e="- "+b+validatelang.Others.CannotContain+"["+f+"] "+validatelang.Others.Character;return e}}return e}function isInteger(d){var b;if(d.length==0){return false}for(b=0;b<d.length;b++){var e=d.charAt(b);if(((e<"0")||(e>"9"))){return false}}return true}function checkDate(e,b){var c="";if(e.length==0){c=validatelang.Enter.PleaseEnter+b+validatelang.CheckDate.ValidDate;return c}return c}function appendBreak(b){return b=b+"\n"}String.prototype.trim=function(){a=this.replace(/^\s+/,"");return a.replace(/\s+$/,"")};function addEventSimple(c,d,b){if(c.addEventListener){c.addEventListener(d,b,false)}else{if(c.attachEvent){c.attachEvent("on"+d,b)}}}function sendRequestSync(b,e,f){var c=createXMLHTTPObject();if(!c){return}var d=(f)?"POST":"GET";c.open(d,b,false);c.setRequestHeader("User-Agent","XMLHTTP/1.0");if(f){c.setRequestHeader("Content-type","application/x-www-form-urlencoded")}c.send(f);if(c.status===200){return c.responseText}}var XMLHttpFactories=[function(){return new XMLHttpRequest()},function(){return new ActiveXObject("Msxml2.XMLHTTP")},function(){return new ActiveXObject("Msxml3.XMLHTTP")},function(){return new ActiveXObject("Microsoft.XMLHTTP")}];function createXMLHTTPObject(){var d=false;for(var c=0;c<XMLHttpFactories.length;c++){try{d=XMLHttpFactories[c]()}catch(b){continue}break}return d}for(var i=0;i<document.forms.length;i++){initCaptchaOnForm(document.forms[i])}function initCaptchaOnForm(b){if(b._CaptchaHookedUp){return}if(!b.CaptchaV2){return}if(!b.CaptchaHV2){return}b._CaptchaHookedUp=true}function captchaIsInvalid(j,e,b){if((j._CaptchaTextValidated===true)&&(j._CaptchaTextIsInvalid===false)){return""}if(typeof j.ReCaptchaChallenge!="undefined"){var h=Recaptcha.get_challenge();var g=Recaptcha.get_response();if(g.trim().length==0){return"- "+e}j.ReCaptchaAnswer.value=Recaptcha.get_response();j.ReCaptchaChallenge.value=Recaptcha.get_challenge();var d=sendRequestSync("/ValidateCaptcha.ashx?key="+h+"&answer="+g+"&imageVerificationType=recaptcha");j._CaptchaTextIsInvalid=d=="false";j._CaptchaTextValidated=true;if(j._CaptchaTextIsInvalid){regenerateCaptcha(j)}}else{var h=j.CaptchaHV2.value;var g=j.CaptchaV2.value;var c=6;if(g.trim().length==0){return"- "+e}if(g.length!=c){j._CaptchaTextIsInvalid=true}else{var d=sendRequestSync("/ValidateCaptcha.ashx?key="+h+"&answer="+g);j._CaptchaTextIsInvalid=d=="false";j._CaptchaTextValidated=true;if(j._CaptchaTextIsInvalid){regenerateCaptcha(j)}}}if(j._CaptchaTextIsInvalid){return"- "+b}return""}function regenerateCaptcha(m){m._CaptchaTextValidated=false;m._CaptchaTextIsInvalid=true;if(typeof m.ReCaptchaChallenge!="undefined"){Recaptcha.reload()}else{var l=sendRequestSync("/CaptchaHandler.ashx?Regenerate=true&rand="+Math.random());m.CaptchaHV2.value=l;m.CaptchaV2.value="";var d=m.getElementsByTagName("img");if(d.length==0){if((m.parentNode.nodeName.toLowerCase()=="p")&&(m.parentNode.nextSibling)&&(m.parentNode.nextSibling.nodeName.toLowerCase()=="table")&&(m.parentNode.nextSibling.className=="webform")){d=m.parentNode.nextSibling.getElementsByTagName("img")}}for(var c=0;c<d.length;c++){var b=d[c].src;var e=b.toLowerCase();if(e.indexOf("/captchahandler.ashx")>-1){var j=e.indexOf("?id=")+4;var k=e.indexOf("&",j);var g=b.substring(j,k);var h=b.replace(g,l);d[c].src=h;break}}}}function isNumericIfVisible(e,b){var f="";if(e.style.display=="inline"){if(e.value.length==0){f="- "+b+validatelang.Number.MustNumber}else{var d;for(d=0;d<e.value.length;d++){var g=e.value.charAt(d);if((g<"0")||(g>"9")){f="- "+b+validatelang.Number.NoDecimal;return f}}}}return f}function checkIPAddress(b){var c=/^\s*((0|[1-9]\d?|1\d{2}|2[0-4]\d|25[0-5])\.){3}(0|[1-9]\d?|1\d{2}|2[0-4]\d|25[0-5])\s*$/;if(c.test(b)){return""}return validatelang.IP.Illegal};