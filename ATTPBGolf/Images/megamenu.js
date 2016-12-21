
/* MEGA MENU LOAD AND HANDLER */
var megamenu_info = Array();
function load_megamenu(){
	var megamenu = document.getElementById('richmegamenu');
	for(var z = 0; z < megamenu.childNodes[0].childNodes.length; z++){
		if(megamenu.childNodes[0].childNodes[z].nodeName.toUpperCase() == 'LI'){
			var span = null;
			var ul = null;
			var div = null;
			for(var y = 0; y < megamenu.childNodes[0].childNodes[z].childNodes.length; y++){
				if(megamenu.childNodes[0].childNodes[z].childNodes[y].nodeName.toUpperCase() == 'SPAN'){
					span = megamenu.childNodes[0].childNodes[z].childNodes[y];
				}else if(megamenu.childNodes[0].childNodes[z].childNodes[y].nodeName.toUpperCase() == 'DIV' && megamenu.childNodes[0].childNodes[z].childNodes[y].className=='wrapper'){
					ul = megamenu.childNodes[0].childNodes[z].childNodes[y].childNodes[0];					
				}else if(megamenu.childNodes[0].childNodes[z].childNodes[y].nodeName.toUpperCase() == 'DIV'){
					div = megamenu.childNodes[0].childNodes[z].childNodes[y];					
				}
			}
			if(span != null){
				if(ul != null){
					ul.style.display = 'none';
					span.ul = ul;
					span.count = z;
					span.ul.count = z;
					span.show = function(){
						this.id = 'currentmega';
						this.ul.style.display = 'block';
					}
					span.hide = function(){
						this.id = '';
						this.ul.style.display = 'none';
					}
					span.onmouseover = function(){
						//megaMenuClose();
						clearTimeout(megamenu_info[this.count].display);
						megamenu_info[this.count].display = setTimeout('megaMenuClose();;megamenu_info['+this.count+'].show();',200);
					}
					span.onmouseout = function(){
						clearTimeout(megamenu_info[this.count].display);
						megamenu_info[this.count].display = setTimeout('megamenu_info['+this.count+'].hide();',200);
					}
					span.ul.onmouseover = span.onmouseover;
					span.ul.onmouseout = span.onmouseout;
				}
				megamenu_info[z] = span;
			}			
		}
	}
}
function megaMenuClose(){
	for(var i=0;i<megamenu_info.length;i++){
		clearTimeout(megamenu_info[i].display);
		if(typeof( megamenu_info[i].hide ) == 'function'){
			megamenu_info[i].hide();
		}
	}
}

if(window.addEventListener){
	window.addEventListener("load",load_megamenu,false);
}else if(window.attachEvent){
	window.attachEvent("onload",load_megamenu);
}
/*
if(typeof window.onload == 'function'){
	var tmponload = window.onload;
	window.onload = function(){
		tmponload();
		load_megamenu();
	};
}else{
	window.onload = load_megamenu;
}*/