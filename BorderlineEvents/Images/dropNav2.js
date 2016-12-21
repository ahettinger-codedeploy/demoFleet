jQuery(function() {
if(jQuery('#cc-sa').length == 0) {
        var link = jQuery('.navTopItemGroup_1 a').attr('href'); //Gets domain name for later use
        sitemaplink = link + 'sitemap'; //URL for site map
        var compare2;
        var compare3;
                var compare4;
                var homecount = 0;
        jQuery('body').append('<div id="dropNav"><\/div>');// Makes somewhere for the site map to go
        jQuery('#dropNav').css('display','none'); //Ensures the pulled site map is not displayed
        jQuery('#mainNav1 li').append('<div class="shoes" style="position: absolute; z-index: 10000000000000000; text-transform: capitalize; text-align: center;"><\/div>');
        //Site map is loaded from site map page


        
        jQuery('#dropNav').load(sitemaplink + ' #content_area', function() {
                
                //Stats looking through each link within the sitemap, including subpages

                jQuery('#dropNav ul.sitemap li a').each(function() {
        
                        var slashCheck = jQuery(this).attr('href');  //Finds partial URL of current a
                        var count1 = slashCheck.match(/\//g); //Removes all chars except slashes
                        var count = count1.length; //Counts number of slashes to see if this a is a sub page
                                                
                                                homecount++;

                                                
                        
                        if(count == 3)
                        {
                                var subnavlink = jQuery(this).attr('href');  //Gets partial URL of a subpage
                                var slicer = link;
                                slicer = slicer.slice(0,-1); //Removes last slash for later use
                                var fullsubnavlink = slicer + subnavlink; //Combines two partial urls to make the full subnav URL
                                var exploded = subnavlink.split('/'); //Creates and array of all items between two slashes
                                var compare1 = link + exploded[1] + '/'; //Sets URL up to be compared
                                var correct = exploded[2].charAt(0).toUpperCase() + exploded[2].slice(1); //Variable used to make a text first letter uppercase
                                correct = correct.replace(/-/g, ' ');
                                var link2 = link + '/';
                                                                if(homecount==2)
                                                                {
                                                                                compare3 = exploded[1];
                                                                }

                                //Looks at each mainNav a to comapre to see if the subpage url is a match and adds in the proper a tags
                                

                                jQuery('#mainNav1 li').each(function(){
                                        
                                        compare2 = jQuery('a', this).attr('href');
                                                                                var cname = jQuery(this).attr('class');
                                        if(cname == 'navTopItemGroup_1')
                                                                                {
                                                                                                compare4 = link + compare3 + '/';
                                                                                                if(compare4 == compare1)
                                                                                                {
                                                                                                                jQuery('.shoes', this).append('<a class ="hideshow" href="' + fullsubnavlink + '">' + correct + '<\/a>');
                                                                jQuery('.hideshow').css('display','none');
                                                                                                }
                                                                                }
                                        
                                        if(compare1 == compare2)
                                        {
                                                
                                                jQuery('.shoes', this).append('<a class ="hideshow" href="' + fullsubnavlink + '">' + correct + '<\/a>');
                                                jQuery('.hideshow').css('display','none');
                                        }
                
                                });
                                       
                        }

                });

        });     
        


        jQuery('#mainNav1 li').hover(function() {  
                jQuery('.hideshow', this).css('display','block');
        },
         function() {
                jQuery('.hideshow', this).css('display','none');
        });
	}
}); 