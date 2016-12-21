// JavaScript Document
var pre_obj
var xx,ii
var current_menu
(function($){

$.fn.navMenu = function(){
var pre_obj
var enable_menu_for={"0":"true","1":"true","2":"true","3":"true","4":"true"};
var curr
var ul = jQuery('div.nav ul');
var div = $('div#menuDiv div')

$('div.top').bind('mouseover',$.fn.navMenu.hideMenu)
$('div#menuDiv').bind('mouseout',function (){if(xx){clearInterval(ii);ii='';document.onmouseover='';} })

var li_a = ul.find('li a')

li_a.each( function(index, ele){

	if(enable_menu_for[index]=="true"){
		$(ele).attr('alt',index)
		
		if(index!=0 && index!=1 && index!=4)
		$(ele).attr('href',"javascript:void(0)")
		
//		$(ele).bind('mouseover',showMenu)
		$(ele).bind('mouseover',$.fn.navMenu.onmove)
		$(ele).bind('mouseout',$.fn.navMenu.onmove)
		
		
	}
	

} );
}

$.extend($.fn.navMenu,{

timecount:0,
pre_obj:'',

showMenuDelay : function (event,obj){
	$.fn.navMenu.timecount++;
	$.fn.navMenu.pre_obj=obj;
	if($.fn.navMenu.timecount>=100){
		$.fn.navMenu.showMenu(event,obj)
		clearInterval(ii);
		ii=1
	}
},

showMenu : function (event,obj){
	
	$("h1#logo").show();
	$.fn.navMenu.pre_obj=obj;
	//alert(obj.attr('alt'))

//event.preventDefault();

//$.fn.navMenu.onmove(true)

/*clearing the autosuggest*/
as_json1.clearSuggestions()
as_json.clearSuggestions()
/**/


if($('dl#system-message').html()!=null){
	$('dl#system-message').css('display','none')
}


var chi_divs = $("div#menuDiv").children("div")

$('div#menuDiv').css('display','block');

//url("../images/nav_h.jpg") repeat-x scroll left top transparent

//url("../images/nav_arrow_h.jpg") no-repeat scroll center 38px transparent

//ajax-loader.gif

if($(obj).attr('alt')!=undefined){
curr = $(obj).attr('alt');

current_menu = curr

var ul = jQuery('div.nav ul');
//ul.find('li a').css('background','url("/chicagoplays_svn/templates/chicagoplays/images/nav.jpg") repeat-x scroll left top transparent')
ul.find('li a').css('background','none')
ul.find('li a').find('span').css('background','url("'+jsbaseurl+'/templates/chicagoplays/images/nav_arrow.jpg") no-repeat scroll center 38px transparent')


$(obj).css('background','url("'+jsbaseurl+'/templates/chicagoplays/images/nav_h.jpg") repeat-x scroll left top transparent')
$(obj).find('span').css('background','url("'+jsbaseurl+'/templates/chicagoplays/images/nav_arrow_h.jpg") no-repeat scroll center 38px transparent')
}


//$(obj).find('span').css('background','url("/chicagoplays/templates/chicagoplays/images/ajax-loader.gif") no-repeat scroll center 38px transparent')

$(chi_divs[curr]).hover($.fn.navMenu.showMenu,$.fn.navMenu.hideMenu)

if(chi_divs[curr].style.display=='block'){
	$("h1#logo").hide();
	return
	//$(chi_divs[curr]).slideUp('slow',function(){})

}


var chix_divs = $("div#menuDiv").children("div").fadeOut('fast',function(){});

	//$(chi_divs[$(this).attr('alt')]).slideToggle('slow',function(){})
	if(chi_divs[curr].style.display=='none'){
	$(chi_divs[curr]).slideDown('fast',function(){$("h1#logo").hide();})
	//$(this).css('background','url("../images/nav_h.jpg") left top repeat-x');
	}



	//event.preventDefault();
},

hideMenu : function(obj) {
	clearInterval(ii);
	$.fn.navMenu.timecount=0;
	ii=''

	if($('.as_header').html()!=null){ //added condition for autosuggest ishit:softweb:20100629
		return false;	
	}
	
//	$.fn.navMenu.onmove(false)
	
	if($(obj).attr('alt')!=undefined){
		curr = $(obj).attr('alt');
		current_menu = curr
	}
	
	var chi_divs = $("div#menuDiv").children("div")

	if(typeof(curr)=='undefined'){
		return false;	
	}

//	if(curr!=undefined){
	if(typeof(curr)!=undefined){
	
	$(chi_divs[curr]).slideUp('slow',function(){
	var ul = jQuery('div.nav ul');										  
	 // ul.find('li a').css('background','url("/chicagoplays_svn/templates/chicagoplays/images/nav.jpg") repeat-x scroll left top transparent');
	  ul.find('li a').css('background','none');
	  ul.find('li a').find('span').css('background','url("'+jsbaseurl+'/templates/chicagoplays/images/nav_arrow.jpg") no-repeat scroll center 38px transparent');
	  	
		//ajax-loader
		
		if($('dl#system-message').html()!=null){
			$('dl#system-message').css('display','block')
		}

	 })
	
	}
	
	$("h1#logo").show();
	//$("div#menuDiv").children("div").fadeOut('slow',function(){});
	
},

onmove:function(event){

	var ev = event
	var obj = $(this)
	
	document.onmouseover=function(){
	if(event.type=='mouseover'){	

		if(ev.target.innerHTML == obj.find('span').html()){
			$(obj).find('span').css('background','url("'+jsbaseurl+'/templates/chicagoplays/images/ajax-loader.gif") no-repeat scroll center 38px transparent')

			if(!ii){
				$.fn.navMenu.pre_obj=obj;
				ii = setInterval(function(){$.fn.navMenu.showMenuDelay(ev,obj)},1) 
//				xx= setTimeout(function(){$.fn.navMenu.showMenu(ev,obj)},1000)
			}
			else{
				if($.fn.navMenu.pre_obj && $.fn.navMenu.timecount<100){
					if($.fn.navMenu.pre_obj.find('span').html() != ev.target.innerHTML){
						$($.fn.navMenu.pre_obj).find('span').css('background','url("'+jsbaseurl+'/templates/chicagoplays/images/nav_arrow.jpg") no-repeat scroll center 38px transparent')
						//alert(ii)
						clearInterval(ii);
						//$.fn.navMenu.timecount=0;
						ii=''
						ii = setInterval(function(){$.fn.navMenu.showMenuDelay(ev,obj)},1) 
						//xx= setTimeout(function(){$.fn.navMenu.showMenu(ev,obj)},1000)
					}else
					{
						clearInterval(ii);
						ii=1;
						$.fn.navMenu.showMenu(ev,obj)	
					}
				}else{
				
					clearInterval(ii);
					ii=1;
					$.fn.navMenu.showMenu(ev,obj)	
				}
			
				
				//clearTimeout(xx);
			}
		}
	}else{

			if($(obj).attr('alt')!=undefined){
				var curr = $(obj).attr('alt');
				current_menu = curr
			}

			var chi_divs = $("div#menuDiv").children("div")
			if(chi_divs[curr].style.display=='none'){
				//clearTimeout(xx);
				//xx='';
				clearInterval(ii);
				$.fn.navMenu.timecount=0;
				ii=''
				$.fn.navMenu.hideMenu(obj)
				document.onmouseover='';
			}
		}
	}

}


});




})(jQuery);