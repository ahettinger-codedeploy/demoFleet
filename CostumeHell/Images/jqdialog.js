/**
	Kailash Nadh,	http://kailashnadh.name
	August 2009
	Smooth popup dialog for jQuery

	License:	GNU Public License: http://www.fsf.org/copyleft/gpl.html
**/

var jqDialog=new function(){this.strOk='Ok';this.strYes='Yes';this.strNo='No';this.strCancel='Cancel';this.strX='X';this.closeTimer=null;this.width=0;this.height=0;this.divBoxName='jqDialog_box';this.divBox=null;this.divContentName='jqDialog_content';this.divContent=null;this.divOptionsName='jqDialog_options';this.divOptions=null;this.btCloseName='jqDialog_close';this.btClose=null;this.btYesName='jqDialog_yes';this.btYes=null;this.btNoName='jqDialog_no';this.btNo=null;this.btOkName='jqDialog_ok';this.btOk=null;this.btCancel='jqDialog_ok';this.btCancel=null;this.inputName='jqDialog_input';this.input=null;this.confirm=function(message,callback_yes,callback_no){this.createDialog(message);this.btYes.show();this.btNo.show();this.btYes.focus();this.btOk.hide();this.btCancel.hide();this.btYes.unbind().click(function(){jqDialog.close();if(callback_yes)callback_yes();});this.btNo.unbind().click(function(){jqDialog.close();if(callback_no)callback_no();});};this.prompt=function(message,content,callback_ok,callback_cancel){this.createDialog($("<p>").append(message).append($("<p>").append(this.input.val(content))));this.btYes.hide();this.btNo.hide();this.btOk.show();this.btOk.focus();this.btCancel.show();this.btOk.unbind().click(function(){jqDialog.close();if(callback_ok)callback_ok(jqDialog.input.val());});this.btCancel.unbind().click(function(){jqDialog.close();if(callback_cancel)callback_cancel();});};this.alert=function(content,callback_ok){this.createDialog(content);this.btYes.hide();this.btNo.hide();this.btOk.show();this.btOk.focus();this.btOk.unbind().click(function(){jqDialog.close();if(callback_ok)
callback_ok();});};this.content=function(content,close_seconds){this.createDialog(content);this.divOptions.hide();};this.notify=function(content,close_seconds){this.content(content);this.btClose.focus();if(close_seconds)
this.closeTimer=setTimeout(function(){jqDialog.close();},close_seconds*1000);};this.createDialog=function(content){clearTimeout(this.closeTimer);this.divOptions.show();this.divContent.html(content);this.divBox.fadeIn('fast');this.maintainPosition();};this.close=function(){this.divBox.fadeOut('fast');this.clearPosition();};this.clearPosition=function(){$(window).scroll().remove();};this.makeCenter=function(){$(jqDialog.divBox).css({top:((($(window).height()/2)-(($(jqDialog.divBox).height())/2)))+($(document).scrollTop())+'px',left:((($(window).width()/2)-(($(jqDialog.divBox).width())/2)))+($(document).scrollLeft())+'px',});};this.maintainPosition=function(){$(window).scroll(function(){jqDialog.makeCenter();});}
this.init=function(){this.divBox=$("<div>").attr({id:this.divBoxName});this.divContent=$("<div>").attr({id:this.divContentName});this.divOptions=$("<div>").attr({id:this.divOptionsName});this.btYes=$("<button>").attr({id:this.btYesName}).append(document.createTextNode(this.strYes));this.btNo=$("<button>").attr({id:this.btNoName}).append(document.createTextNode(this.strNo));this.btOk=$("<button>").attr({id:this.btOkName}).append(document.createTextNode(this.strOk));this.btCancel=$("<button>").attr({id:this.btCancelName}).append(document.createTextNode(this.strCancel));this.input=$("<input>").attr({id:this.inputName}).append(document.createTextNode(this.input));this.btClose=$("<button>").attr({id:this.btCloseName}).append(document.createTextNode(this.strX)).click(function(){jqDialog.close();});this.divBox.append(this.btClose).append(this.divContent).append(this.divOptions.append(this.btYes).append(this.btNo).append(this.btOk).append(this.btCancel));this.divBox.hide();$('body').append(this.divBox);this.makeCenter();};};$(window).load(function(){jqDialog.init();});