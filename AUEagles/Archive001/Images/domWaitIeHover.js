function domFunction(f, a){
	var n = 0;
	var t = setInterval(function(){
		var c = true;
		n++;	
		if(typeof document.getElementsByTagName != 'undefined' && (document.getElementsByTagName('body')[0] != null || document.body != null)){	
			c = false;			
			if(typeof a == 'object') {
				for(var i in a){
					if((a[i] == 'id' && document.getElementById(i) == null) || (a[i] == 'tag' && document.getElementsByTagName(i).length < 1)){
						c = true;
						break;
					}
				}
			}
			if(!c){
				f();
				clearInterval(t);
			}
		}
		if(n >= 60){
			clearInterval(t);
		}
	}, 10);
};
function IEHoverPseudoTop() {
	var navItems = document.getElementById("nav").getElementsByTagName("li");
	for (var i=0; i<navItems.length; i++) {
		if(navItems[i].className == "parent") {
			navItems[i].onmouseover=function() { this.className += " over"; }
			navItems[i].onmouseout=function() { this.className = "parent"; }
		}
	}
}
var loadIEHoverPseudoTop = new domFunction(IEHoverPseudoTop, { 'nav' : 'id' });
