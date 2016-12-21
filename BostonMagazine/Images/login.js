function readCookie(name) {
var n = name + "=";
var ca = document.cookie.split(';');
for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(n) == 0) return c.substring(n.length,c.length);
}
return null;
}

function mtlogin() {
        var mname = readCookie('mname');
		var mt_user;
		var author_name = '';
        if (mname) {
               document.write("Welcome, <b><!--a href=\"/members/" + mname + "\"-->"
                        + escape(mname)
                        + "<!--/a--></b>  | <a href=\"/login.html?logout=true&return="
                        + escape(document.location) + "\">Log Out</a>"
                    );
        } else {
               document.write("<b>You are not logged in</b> | <a href=\"/login.html?return="
                        + escape(document.location) + "\">Log In</a> | <a href=\"/register/index.html?return="
                        + escape(document.location) + "\">Register</a>"
                    );
        }
}
mtlogin();

