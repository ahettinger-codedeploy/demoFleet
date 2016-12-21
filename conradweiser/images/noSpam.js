var e = [
	[0,"Web Master","twirebach@echovalleygraphics.com"],
];
	
	
function noSpam(n) {
	var eMail = e[n][2];
	if(e[n][1] == '' ) { name = eMail; }
	else { var name = e[n][1]; }
	document.write('<a href=\"mailto:'+eMail+'\">'+name+'</a>');
}

function eml(a,b) {
	var c = a+"&#64;conradweiser.org";
	if(b=='') { b = c; }
	document.write('<a href="mailto:'+c+'">'+b+'</a>');
    }
    
function e2(a,b,c) {
	document.write('<a href="mailto:'+a+'&#64;'+b+'.'+c+'">'+a+'&#64;'+b+'.'+c+'</a>');
    }