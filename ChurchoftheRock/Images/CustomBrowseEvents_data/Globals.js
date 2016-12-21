String.prototype.trim=function(){return this.replace(/^\s\s*/,"").replace(/\s\s*$/,"")};String.prototype.startsWith=function(a,b){if(b)return this.match("^"+a)==a;else{a=a.toLowerCase();return this.toLowerCase().match("^"+a)==a}};String.prototype.endsWith=function(a,b){if(b)return this.match(a+"$")==a;else{a=a.toLowerCase();return this.toLowerCase().match(a+"$")==a}};String.prototype.format=function(){var a=/\{\d+\}/g,b=arguments;return this.replace(a,function(a){return b[a.match(/\d+/)]})};Array.prototype.remove=function(a,c){var b=this.slice((c||a)+1||this.length);this.length=a<0?this.length+a:a;return this.push.apply(this,b)};Array.prototype.removeValue=function(c){for(var a=0,b=this.length;a<b;a++)if(this[a]===c)return this.remove(a);return this};Array.prototype.toList=function(b){var c="";if(!b)b=",";for(var a=0,d=this.length;a<d;a++)if(a===0)c=this[a];else c+=b+this[a];return c};var NS_XHTML="http://www.w3.org/1999/xhtml",NS_STATE="http://www.w3.org/2005/07/aaa";if(typeof Dea==="undefined"||null===Dea)var Dea={};Dea.emsData={};Dea.Mouse={};var _emsLabelsOnPage=null,iFrameDiag=null;Dea.Keys={PAGEUP:33,PAGEDOWN:34,END:35,HOME:36,LEFT:37,UP:38,RIGHT:39,DOWN:40,SPACE:32,TAB:9,BACKSPACE:8,DELETE:46,ENTER:13,INSERT:45,ESCAPE:27};Dea.isNumberKey=function(a){return a>47&&a<58?true:false};Dea.isNavKey=function(a){return a===Dea.Keys.LEFT||a===Dea.Keys.RIGHT||a===Dea.Keys.UP||a===Dea.Keys.DOWN||a===Dea.Keys.BACKSPACE||a===Dea.Keys.HOME||a===Dea.Keys.END||a===Dea.Keys.TAB?true:false};Dea.numberMask=function(b){var a=b.which||b.keyCode;return b.shiftKey&&a==35||b.shiftKey&&a==36||b.shiftKey&&a==37?false:b.ctrlKey&&a==118?true:Dea.isNumberKey(a)||Dea.isNavKey(a)};Dea.keyUpTypeVal=function(b,d){var a=b.target||b.srcElement,c=new RegExp(d);!c.test($(a).val())&&$(a).val("")};Dea.floatMask=function(b){var a=b.which||b.keyCode;return Dea.isNumberKey(a)||Dea.isNavKey(a)||a===46||a==44};Dea.suppressSubmitOnReturn=function(a){var b=a.which||a.keyCode;if(b===Dea.Keys.ENTER)return false};Dea.matchEmsDataId=function(b,c){for(var a=0,e=b.length;a<e;a++){var d=b[a].emsDataId||b[a].getAttribute("emsDataId");if(d===c)return b[a];else if(b[a].name===c)return b[a]}return null};Dea.Get=function(b,c){var a=b;if(typeof b==="string"){if(b.trim()===""||b==="undefined")return null;a=document.getElementById(b)}else if(typeof b==="function")a=b();if(a)return a;a=null;if(!c||c===null)c=document.getElementsByTagName("input");a=Dea.matchEmsDataId(c,b);if(a!==null)return a;c=document.getElementsByTagName("select");a=Dea.matchEmsDataId(c,b);if(a!==null)return a;c=document.getElementsByTagName("textarea");a=Dea.matchEmsDataId(c,b);return a!==null?a:null};Dea.setDisplay=function(a,c,e,f,b,d){a=Dea.Get(a);if(a){if(c==="none"||c==="hidden")a.setAttribute("aria-hidden","true");else a.setAttribute("aria-hidden","false");a.style.display=c;if(b&&b!==null)a.style.position=b;if(e&&e!==null)a.style.left=e;if(f&&f!==null)a.style.top=f;if(d&&d!==null)a.style.right=d}};Dea.findPos=function(a){a=Dea.Get(a);if(a){var b=curtop=0;if(a.offsetParent){b=a.offsetLeft;curtop=a.offsetTop;while(a=a.offsetParent){b+=a.offsetLeft;curtop+=a.offsetTop}}}return[b,curtop]};Dea.Css={classExists:function(a,b){a=Dea.Get(a);return(new RegExp("\\b"+b+"\\b")).test(a.className)},swapClass:function(a,b,c){a=Dea.Get(a);a.className=!Dea.Css.classExists(a,b)?a.className.replace(c,b):a.className.replace(b,c)},addClass:function(a,b){a=Dea.Get(a);if(!Dea.Css.classExists(a,b))a.className+=a.className?" "+b:b},removeClass:function(a,b){a=Dea.Get(a);if(a.className){var c=a.className.match(" "+b)?" "+b:b;a.className=a.className.replace(c,"")}}};Dea.emptyToMinusOne=function(a){return a?a===""?"-1":a:"-1"};Dea.setEmsData=function(f){for(var b=document.getElementsByTagName("input"),a=0,h=b.length;a<h;a++){var d=b[a].emsDataId||b[a].getAttribute("emsDataId"),g=b[a].isRequired||b[a].getAttribute("isRequired");if(d){if(g)if(b[a].value===""&&f!==true){alert(b[a].errorMsg);return false}if(b[a].type==="checkbox"||b[a].type==="radio")if(b[a].checked)Dea.emsData[d]="1";else Dea.emsData[d]="0";else Dea.emsData[d]=b[a].value}else if(b[a].name.substring(0,4)==="ems_")if(b[a].type==="checkbox")if(b[a].checked)Dea.emsData[b[a].name]="1";else Dea.emsData[b[a].name]="0";else Dea.emsData[b[a].name]=b[a].value}for(var c=document.getElementsByTagName("select"),a=0,h=c.length;a<h;a++){var d=c[a].emsDataId||c[a].getAttribute("emsDataId"),g=c[a].isRequired||c[a].getAttribute("isRequired");if(d){if(g)if((c[a].value===""||c[a].options[c[a].selectedIndex].text==="")&&f!==true){alert(c[a].errorMsg);return false}Dea.emsData[d]=Dea.emptyToMinusOne(c[a].value)}}for(var e=document.getElementsByTagName("textarea"),a=0,h=e.length;a<h;a++){var d=e[a].emsDataId||e[a].getAttribute("emsDataId"),g=e[a].isRequired||e[a].getAttribute("isRequired");if(d){if(g)if(e[a].value===""&&f!==true){alert(e[a].errorMsg);return false}Dea.emsData[d]=e[a].value}}return true};Dea.getValue=function(a,c,b){a=Dea.Get(a,c);return a?a.value.trim():b?b:""};Dea.setValue=function(a,c,b){a=Dea.Get(a,b);if(a)a.value=c};Dea.setHtml=function(a,b){a=Dea.Get(a);if(a)a.innerHTML=b};Dea.checkLength=function(b,c,d){if(Dea.Get(c).value.length<d)return true;else{var a=b.which||b.keyCode;return a===Dea.Keys.UP||a===Dea.Keys.RIGHT||a===Dea.Keys.LEFT||a===Dea.Keys.DOWN||a===Dea.Keys.BACKSPACE||a===Dea.Keys.DELETE?true:false}};Dea.showError=function(a,c,b){a=Dea.Get(a,c);if(a){if(b){if(typeof b==="string")b=Dea.Get(b,c);$(b).click()}var d=a.errorMsg||a.getAttribute("errorMsg");alert(d);a.focus()}};Dea.setDisabled=function(a,c,b){a=Dea.Get(a,b);if(a)a.disabled=c};Dea.hideSelectBoxes=function(){if(document.all)for(var b=document.getElementsByTagName("select"),a=0,c=b.length;a<c;a++)b[a].style.visibility="hidden"};Dea.displaySelectBoxes=function(){if(document.all)for(var b=document.getElementsByTagName("select"),a=0,c=b.length;a<c;a++)b[a].style.visibility="visible"};Dea.htmlDecode=function(a){if(a)if(a!=="undefined")return a.replace(/&amp;/g,"&").replace(/&lt;/g,"<").replace(/&gt;/g,">")};Dea.hideTimePicker=function(){var a=Dea.Get("timeDrop");if(a)if(!bLeaveTime){if(timeBuilt===true){Dea.setDisplay(a,"none");Dea.displaySelectBoxes();timeBuilt=false}}else timeBuilt===true&&Dea.hideSelectBoxes()};Dea.hidePickers=function(){if(Dea.Get("calendar")){!bShow&&hideCalendar();bShow=false}window.top.gPopupIsShown&&window.top.Dea.hideSelectBoxes();Dea.hideTimePicker()};Dea.clearLoading=function(){Dea.setDisplay("CallbackStatus","none")};Dea.errorCallback=function(b){try{var a=Dea.JSON.parse(b)}catch(c){a=b}if(typeof a.sendToPage!=="undefined"){window.location.href=a.sendToPage;return true}alert(b);Dea.clearLoading()};Dea.showLoading=function(){Dea.setDisplay("CallbackStatus","",null,"5px",null,"5px")};Dea.makeCallback=function(b,a){if(!a||a==="undefined")a=Dea.emsData;a.router=b;Dea.showLoading();Dea.pageCallback(a)};Dea.handleCallback=function(g,f){try{var a=Dea.JSON.parse(g)}catch(i){if(i.message==="script stack space quota is exhausted"){var a={},c=g.split('","'),d=c[0];d=d.substr(2,d.length-2);var b=d.split('":"');eval("emsResponse."+b[0]+' = "'+b[1]+'"');for(var h=1;h<c.length-1;h++){b=c[h].split('":"');eval("emsResponse."+b[0]+' = "'+b[1]+'"')}var e=c[c.length-1];e=e.substr(0,e.length-2);b=e.split('":"');eval("emsResponse."+b[0]+' = "'+b[1]+'"')}else a=g}if(typeof a.success!=="undefined")if(Number(a.success)===0)if(typeof a.msg!=="undefined"){alert(a.msg);if(typeof a.sendToPage!=="undefined"){window.location.href=a.sendToPage;return true}typeof Dea.pageHandleErrorCallback==="function"&&Dea.pageHandleErrorCallback(a,f);Dea.clearLoading();return true}if(typeof a.sendToPage!=="undefined"){window.location.href=a.sendToPage;return true}if(typeof a.isError!=="undefined")if(Number(a.isError)===1){alert(a.errorMsg);Dea.clearLoading();typeof Dea.pageHandleErrorCallback==="function"&&Dea.pageHandleErrorCallback(a,f);return true}!Dea.pageHandleCallback(a,f)&&alert("Unhandled callback "+f);if(typeof Dea.emsData.suppressImageWireUp=="undefined")Dea.addImageRollovers();else Dea.emsData.suppressImageWireUp==0&&Dea.addImageRollovers();Dea.clearLoading()};$.ctrl=function(c,b,a){$(document).keydown(function(d){if(!a)a=[];if(d.keyCode==c.charCodeAt(0)&&d.ctrlKey){b.apply(this,a);return false}})};Dea.setLabelRequired=function(b){if(_emsLabelsOnPage===null)_emsLabelsOnPage=document.getElementsByTagName("label");for(var a=0,c=_emsLabelsOnPage.length;a<c;a++)if(_emsLabelsOnPage[a].attributes["for"].value===b)if(_emsLabelsOnPage[a].innerHTML.indexOf('<span class="requiredAsterisk">*</span>')<0){_emsLabelsOnPage[a].innerHTML=_emsLabelsOnPage[a].innerHTML+'<span class="requiredAsterisk">*</span>';return}};$$=function(a){return $("#"+a)};Dea.addImageRollovers=function(){$("input[src*='btn-']").each(function(){Dea.addRollover($(this).attr("src"),$(this))});$("img[src*='btn-']").each(function(){Dea.addRollover($(this).attr("src"),$(this))})};Dea.calRollover=function(a){$("img[src='"+a+"']").each(function(){Dea.addRollover($(this).attr("src"),$(this))})};Dea.addRollover=function(b,a){function c(a){var c=a.substring(a.lastIndexOf("/")+1),b=c.split("-");return b.length>2?true:false}function d(c){var d=c.substring(c.lastIndexOf("/")+1),b=d.split("-"),a=b[1].split(".");return PathToRoot+"images/"+b[0]+"-"+a[0]+"-over."+a[1]}if(!c(b)){var e=d(b);$(a).css("cursor","pointer").hover(function(){$(a).attr("src",e)},function(){$(a).attr("src",b)})}};$(document).mousemove(function(a){Dea.Mouse.X=a.pageX;Dea.Mouse.Y=a.pageY});Dea.setPopup=function(){$("#emsBody").removeClass("emsBody");$("#FooterContainer").hide();$("#emsCon").removeClass("emsCon");$("div[class*=master]").removeClass()};Dea.wireupDialogs=function(a){$("#"+a+" a:not([class=sorter], [class=noDiag], [class=additionalEvents], [class=tandc])").live("click",function(d){d.preventDefault();var b=15,c=15,a="";if(this.href.indexOf("LocationDetails")>=0)a=ems_LocDetails;else if(this.href.indexOf("ResourceDetails")>=0)a=ems_ResourceDetails;else if(this.href.indexOf("BookingDetails")>=0)a=ems_BookingDetails;else if(this.href.indexOf("ReservationDetails")>=0)a=ems_ResDetails;else if(this.href.indexOf("UdfDetails")>=0)a=ems_AddInfo;$('<iframe id="externalSite"  frameborder="0" src="'+this.href+'" />').dialog({title:a,width:850,height:500,modal:true,resizable:true,autoResize:true}).width(850-b).height(500-c);return false})};Dea.iDialog=function(b,e,a){b=b||event;if(b)if(b.preventDefault)b.preventDefault();else b.returnValue=false;var c=15,d=15;iFrameDiag=$('<iframe id="externalSite"  frameborder="0" src="'+e+'" />');$.extend(a,{modal:true,resizable:false,autoResize:true});if(!a.width)a.width=500;if(!a.height)a.height=500;iFrameDiag.dialog(a).width(a.width-c).height(a.height-d);return false};Dea.showTip=function(a){$activeTipId=Dea.emsData.tipItemId;$("#tipDiv").html(a);$("#tipDiv").dialog({width:400,position:[Dea.mouseX,Dea.mouseY-$(window).scrollTop()]}).dialog("open")};Dea.anchorTimes=function(b,a){var c=$.timePicker("#"+b).getTime();$$(b).change(function(){if($$(b).val().length<ems_timeFormat.length)return;if($$(a).val()){var f=$.timePicker("#"+a).getTime()-c,d=$.timePicker("#"+b).getTime();$.timePicker("#"+a).setTime(new Date(new Date(d.getTime()+f)));c=d;$("#"+a).focus()}else{var d=$.timePicker("#"+b).getTime(),e=new Date(new Date(d.getTime()));e.setMinutes(e.getMinutes()+60);$.timePicker("#"+a).setTime(e);c=d;$("#"+a).focus()}})};Dea.setTabs=function(a){$("ul.ui-tabs-nav").after('<div class="ui-widget-header ui-state-active tabLine" style="height:.5em;"></div>');$("ul.ui-widget-header").removeClass("ui-widget-header");a&&$("#"+a).removeClass("ui-widget-content")};$(document).ready(function(){if(ems_useHelpIcon===1){$("#helpDialog").dialog({title:ems_Help,autoOpen:false,width:400,height:300,modal:false,resizable:true});$("#helpIco").attr({alt:ems_Help,title:ems_Help}).live("click",function(){$("#helpDialog").dialog("open")});($("#ctl00_DefaultHelp").is(":empty")||$("#ctl00_DefaultHelp").html()==null||$("#ctl00_DefaultHelp").html().trim()=="<br>")&&$("#helpIco").hide()}else $("#helpIco").hide();$(document).keydown(function(a){if(a.ctrlKey&&a.shiftKey&&a.keyCode==85)window.location.href="systemcheck.aspx"});$("body").append("<div id='tipDiv'></div>");$("#tipDiv").dialog({autoOpen:false,resizable:false});$(":button, input:submit, input:reset").button();Dea.addImageRollovers();$.idleTimer(ems_sessionMilli);$(document).bind("idle.idleTimer",function(){window.location.href=ems_timeOutUrl});$(".outMessage").dialog({modal:true,resizable:true,autoResize:true})})