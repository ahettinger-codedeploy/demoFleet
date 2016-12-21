$(document).ready(function() {						   

	jQuery(".subnavcontainer").hide();
	 
     jQuery(".drop").hover(
       function() {  
         var children = jQuery(this).children(".subnavcontainer");

         if (children.is(":hidden")) 
         {
           children.slideDown();

         }},
       function() {
          var children = jQuery(this).children(".subnavcontainer");
          children.slideUp();
       });
});