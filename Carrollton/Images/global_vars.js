// Button & Menu Options ---------------------------------//

// Use animation menus
// Requires scriptaculous
	var anim_menus = 0;

//Auto link buttons to overview pages
	var use_overview_pages = 0;

//Show sub-menus for current section( 0=no, 1=yes)
	var section_subs = 1;

//Other button definitions
//"btn_name,menu_name(|menu_direction),section_id,img_src,img_src_on"
//Ex. "ql_btn,ql_menu,0,uploaded/images/ql_btn.gif,uploaded/images/ql_btn.gif"
var otherBtns = new Array( );

// List other images that need to be pre-loaded
var otherImages = new Array();

//other JS functions to run onLoad
function loadJS(){

	if(pageid==1){createStories();}

fsRedirects = ["455,https://my.carrollton.org/SeniorApps/donation/unregistered/donateMaster.faces,_blank","436,https://my.carrollton.org/SeniorApps/registration/onlineRegistrationLogin.faces?appId=AD,_blank","2150,http://carrshpnt.carrollton.org:2048/login,_blank","2322,https://my.carrollton.org/SeniorApps,_blank"]

}
