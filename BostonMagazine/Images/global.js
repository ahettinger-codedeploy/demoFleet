function hideNavOne(){
	$(".nav_one .nav_cell_box").css("display", "none");
	$("#vertical_ad").css("display", "none");
	$(".box_ads").css("display", "none");
	$(".sub_leaderboard").css("display", "none");
	$(".vert_ads").css("display", "none");
}

function restoreNavOne(){
	$(".nav_one .nav_cell_box").css("display", "block");
	$("#vertical_ad").css("display", "block");
	$(".box_ads").css("display", "block");
	$(".sub_leaderboard").css("display", "block");
	$(".vert_ads").css("display", "block");
}

function insertAfter(newElement, targetElement){
	var parent = targetElement.parentNode;
	if(parent.lastChild == targetElement){parent.appendChild(newElement);}else{
		parent.insertBefore(newElement, targetElement.nextSibling);
	}
}

function addClass(element,value) {
  if (!element.className) {
    element.className = value;
  } else {
    newClassName = element.className;
    newClassName+= " ";
    newClassName+= value;
    element.className = newClassName;
  }
}

/* end scripts by JK */ 


/* -----    addLoadEvent -----
	by SIMON WILLISON
	http://simon.incutio.com
-----------------------------------*/

function addLoadEvent(func){
	var oldonload = window.onload;
	if(typeof window.onload != 'function'){ 
		window.onload = func;
	}else{
		window.onload = function(){
			oldonload();
			func();
		}
	}
}

/* end scripts by SW */



/* -----    getElementsByClassName  -----
	by SCOTT SCHILLER
	http://www.schillmania.com
-----------------------------------*/

function getElementsByClassName(className,oParent) {
  var doc = (oParent||document);
  var matches = [];
  var nodes = doc.all||doc.getElementsByTagName('*');
  for (var i=0; i<nodes.length; i++) {
    if (nodes[i].className == className || nodes[i].className.indexOf(className)+1 || nodes[i].className.indexOf(className+' ')+1 || nodes[i].className.indexOf(' '+className)+1) {
      matches[matches.length] = nodes[i];
    }
  }
  return matches; // kids, don't play with fire. ;)
}

/* end scripts by SS */

function searchEventField() {

	if( document.getElementById( 'Event_Search' ) &&
		document.getElementById( 'Event_Search' ).elements[ 'content' ] &&
		document.getElementById( 'Event_Search' ).elements[ 'content' ].value == 'Keyword' ) {
		document.getElementById( 'Event_Search' ).elements[ 'content' ].value = '';
	}

}

function clear_input_field_value( field_id, str ) {
	var el = document.getElementById( field_id );
	if( el && el.value == str ) {
		el.value = "";
	}
}

/*Ask The Expert*/
function displayAskText(){
	document.getElementById("ask_expert_text").style.display = '';
	document.getElementById("ask_expert_form").style.display = 'none';
	document.getElementById("ask_expert_thanks").style.display = 'none';
}

function displayAskForm(){
	document.getElementById("ask_expert_text").style.display = 'none';
	document.getElementById("ask_expert_form").style.display = '';
	document.getElementById("ask_expert_thanks").style.display = 'none';
}

function displayAskThanks(){
	document.getElementById("ask_expert_text").style.display = 'none';
	document.getElementById("ask_expert_form").style.display = 'none';
	document.getElementById("ask_expert_thanks").style.display = '';
}

/*Nav*/
$(document).ready(function(){

	function activateCell(cell_id,status){
		switch(status){	
			case 'active':
				$("#"+cell_id).removeClass("inactive_tab");
				$("#"+cell_id).addClass("active_tab");
				break;
			case 'inactive':
				$("#"+cell_id).removeClass("active_tab");
				$("#"+cell_id).addClass("inactive_tab");
				break;
		}
	}

	function activateBoxTop(nav_id,status){
		switch(status){	
			case 'active':
				break;
			case 'inactive':
				$("#bt_"+nav_id).width("0px");
				break;
		}
	}

	function getNumber(id){
		if(!id){
			return '';
		}
		var re = /(\w+)_(\d+)/i;
		var tmp = id.match(re);
		var num = parseInt(tmp[2]);
		return num;
	}

	function showNavTab(nav_id){
		
		// Hack to make the Philly top nav areas only show after a delay
		//alert("HI! "+location.hostname+' '+location.hostname.indexOf('phillymag.com')+' '+location.hostname.indexOf('bostonmagazine.com')+' '+nav_id);
		if((location.hostname.indexOf('phillymag.com')>-1) && (typeof(NavTabTimer) != "undefined")) clearTimeout(NavTabTimer); // for the Philly nav delay hack
		if
		(
			(nav_id<6)
			&&
			(location.hostname.indexOf('phillymag.com')>-1)
		) NavTabTimer = setTimeout("$('#nav_tab_"+nav_id+"').show()", 500);
		else $("#nav_tab_"+nav_id).show();
	}

	function hideNavTab(nav_id){
		if((location.hostname.indexOf('phillymag.com')>-1) && (typeof(NavTabTimer) != "undefined")) clearTimeout(NavTabTimer); // for the Philly nav delay hack
		$("#nav_tab_"+nav_id).hide();
	}

	function setPrimaryBreakWidth(nav_id){
		var cell_id = "#nav_cell_"+nav_id;
		var cell_width = jQuery(cell_id).width();

		var pb_id = "#pb_"+nav_id;
		$(pb_id).width(cell_width-20);
	}

	function setBoxTop(nav_id){
		return '';
		var cell_id = "#nav_cell_"+nav_id;
		var cell_width = jQuery(cell_id).width();

		var tab_id = "#nav_tab_"+nav_id;
		var nav_width = jQuery(tab_id).width();

		var bt_id = "#bt_"+nav_id;
		var bt_width = Math.abs(nav_width-cell_width);

		$(bt_id).width(bt_width+20);
		$(bt_id).css("top",0+"px");
		$(bt_id).css("left",cell_width+"px");
	}

	function formatNav(nav_id){
		setPrimaryBreakWidth(nav_id);
		setBoxTop(nav_id);
	}

	/*Main Nav*/
	$(".main_nav td").hover(
		/*MouseOver*/
		function(){
			var cell_id = $(this).attr("id");
			var nav_id = getNumber(cell_id);
			if(!nav_id){
				return '';
			}
			activateCell(cell_id,'active');
			activateBoxTop(nav_id,'active');
			formatNav(nav_id);
			showNavTab(nav_id);
		},
		/*MouseOut*/
		function(){
			var cell_id = $(this).attr("id");
			var nav_id = getNumber(cell_id);
			if(!nav_id){
				return '';
			}
			activateCell(cell_id,'inactive');
			activateBoxTop(nav_id,'inactive');
			hideNavTab(nav_id);
		}
	);

});

/*Leaving Site Pop-up*/
$(document).ready(function(){

	/* 24 hour period */
	if($.cookie('pop_up_set') == 1){
		return;
	}

	$.cookie('pop_up_set', '1', {path: '/', expires: 1});

	var external_link = true;

	/*Tag all external links*/
	$.expr[':'].external = function(obj){
		return !obj.href.match(/^mailto\:/) && (obj.hostname != location.hostname);
	};

	$('a:external').addClass('external');

	$('a').click(function(){
		if(!$(this).hasClass("external")){
			external_link = false;	
		}
	});

	/*Image Input Types Forms*/
	$(':image').click(function(){
		external_link = false;	
	});

	
	$(window).unload(function(){

		// Turned this off from Tims request July 1, 2010
		return;

		if(external_link){
		
			/*Slideshows Exception*/
			if(location.href.indexOf('/display/') != -1){
				return;
			}

			/*Find A Dentist Exception*/
			if(location.href.indexOf('/health/dentist/find_a_dentist.html') != -1 && location.hostname == "www.phillymag.com"){
				return;
			}

			if(location.hostname == "www.bostonmagazine.com"){
				url = "/exit_popup.php";	
			}

			if(location.hostname == "www.phillymag.com"){
				url = "/exit_popup.php";	
			}

			if(url){

				var w = 355;
				var h = 275;
				var left = (screen.availWidth/2) - (w/2);
				var top = (screen.availHeight/2) - (h/2);

				window.open(url,"Subscribe","left="+left+", top="+top+", status=0, toolbar=0, width="+w+", height="+h+", titlebar=0, scrollbars=0, resizable=0, menubar=0");

			}
		}

	});
		
});
