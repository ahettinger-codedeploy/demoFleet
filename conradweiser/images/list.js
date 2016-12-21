// JAVASCRIPTS - UNIQUE TO THIS DOMAIN...
// LOAD *ALL* SCRIPTS COMMON TO ALL PAGES ...
var scr = new Array('noSpam','event-cache','sliding-menu','cal'); // 'preview','linx',,'fadeslideshow-1'

var now = new Date();

for(var i=0;i<scr.length;i++)
	{
	document.write('<script type="text/javascript" src="scripts/'+scr[i]+'.js?r='+now+'"></script>');
	}
	
function up() 
	{ 
	
	var up = "<a href='upload_files.php'";	
		up += " onMouseOver='document.images.upIcon.src=\"images/uploader_IN.gif\"' ";
		up += " onMouseOut='document.images.upIcon.src=\"images/uploader_OUT.gif\"'";
		up += "><img src='images/uploader_OUT.gif' id='upIcon' width='16px' style='margin: -3px 0 -2px 0;' /></a>";
	
	document.write(up); 
	
	} 