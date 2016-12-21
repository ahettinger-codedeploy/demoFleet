;(function ($) {
    "use strict";


    // Initialize the lightbox
    $.cromaLightbox = function(el) {
        this.$el = $(el);
        this._init();
    };


    // Bind it to the javascript prototype
    $.cromaLightbox.prototype = {
        _init: function() {
            
            var ctr         = 0;
   

           // list of reusable classes
            this.cllist         = [
                 /* 0 */  'body',
                 /* 1 */  '.croma_lightbox',
                 /* 2 */  '.croma_mainbox',
                 /* 3 */  '.croma_listbox',
                 /* 4 */  'cro-clicker',
                 /* 5 */  'cro_activepic',
                 /* 6 */  '.croma_tinyleft',
                 /* 7 */  '.croma_tinyright',
                 /* 8 */  '.croma_galtitle'
            ];



            // find the body as base for the page
            this.base       = $( this.cllist[0] );
            this.list       = '';
            this.number     = 0;
            this.strip      = 0;
            this.firstimage = this.$el.attr('href');



            // get a list of all the images that will qualify
            this.elem       = this.base.find('a').filter(function() {return /\.(png|gif|jpg|jpeg)$/i.test(this.href);});

            
            var self        = this;

            this.elem.each(function() {
                var elemhrf = $(this).attr('href');
                self.number = (elemhrf == self.firstimage)? ctr : self.number ;
                ctr++;
            });
  
            // store the number of elements in the slideshow
            this.listlgt    = this.elem.length;


            // set up the elements of the lightbox that needs to be added.
            var classList   = [ 'croma_mainbox'
                                ,'croma_listbox'
                                ,'croma_tinyleft'
                                ,'croma_tinyright'
                                ,'croma_bigleft'
                                ,'croma_bigright'
                                ,'croma_boxclose'
                                , 'croma_galtitle'
                            ];



            // add the lightbox div to the body
            $('<div/>', {class: 'croma_lightbox'}).appendTo( this.cllist[0]).fadeIn('slow');
            this.lightbox   = this.base.find( this.cllist[1] );



            // activate the delegater
            this._deleGate();


            // create the elements and add it to the lightbox
            for (var i = 0; i < classList.length; i++) {
                $('<div/>', { class: classList[i], data: 'cro_clicker' } )
                .attr('data-cro-clicker',classList[i].substr(6))
                .appendTo( this.lightbox );
            }


            // creat the thumbnails list.
            for (var i = 0; i < this.elem.length; i++) {
                var telem   = $(this.elem[i]).find('img').attr('src'),
                    telref  = $(this.elem[i]).attr('href');

                if (typeof telem != 'undefined') {
                    this.list += '<li><img src="' + telem + '" data-cro-listimg="' + telref + '" data-cro-clicker="imgClick" /></li>';
                }

            }


            // add the list of images to the listbox
            this.base.find( this.cllist[3] ).html('<ul>' + this.list +  '</ul>');


            var rep = this;

            // add run the image manager and the list manager once
            this._addImage(this.number);
            this._stripControl(this.strip);


            $(window).resize(function() {
                rep. _stripControl(rep.number);
                rep._imageSizer();
            });

        },



        // add a image ot the lightbox
        _addImage: function(number) {
            var self            = this,
                img             = new Image(),
                imgsrc          = '',
                mainbox         = self.lightbox.find( this.cllist[2] ),
                listbox         = self.lightbox.find( this.cllist[3] ),
                mboxwidth       = mainbox.width(),
                mboxhgt         = mainbox.height(),
                visibility;



            // add a table to the box for the image centering
            mainbox.html('<table id="cro_imgwrapper"><tr><td><i class="icon-asterisk"></i></td></tr></table>');

            // unset the activeclass
            self.lightbox.find( '.' + this.cllist[5] ).removeClass( this.cllist[5] );

            // if the numbers get out of range, reset them & update the numberholder
            number              = (number < 0) ? self.listlgt - 1 : number ;
            number              = (number == self.listlgt) ? 0 : number ;
            self.number         = number;


            // set the thumbnailstrip length;
            listbox.find('ul').css('width',(160*self.listlgt) + 20 + 'px')


            // get the source of the image
            imgsrc              =   self.lightbox.find('li:eq(' + number +  ')')
                                    .children('img')
                                    .addClass( this.cllist[5] )
                                    .data('cro-listimg');



            // bind the image and add the settings
            $(img).bind('load', function() {

                // append the mainbox to the viewer
                mainbox.find('td').prepend(this).find('i').remove();

                // get the image title if set & add to the lightbox
                var title = self.base.find("a[href='" + imgsrc +  "']").find('img').attr('data-cro-title');
                self.lightbox.find( self.cllist[8] ).html('<p>' + title + '</p>');

                self._imageSizer();
                

            }).attr('src', imgsrc); 

                
        },


        // add a image ot the lightbox
        _stripControl: function(number) {
            var self            = this,
                mainbox         = self.lightbox.find( this.cllist[2] ),
                mboxwidth       = mainbox.width(),
                squaresshow     = Math.ceil(mboxwidth/160),
                listbox         = self.lightbox.find( this.cllist[3] ),
                listwidth       = listbox.width(),
                ulwidth         = listbox.find('ul').width(),
                padnum          = Math.floor((listwidth-ulwidth) /2),
                visibility;


            // if the thumbnail strip get out of range, reset them & update the numberholder
            number              = (self.strip === 0) ? 0 : self.strip ;
            number              = (self.strip == self.listlgt) ? self.listlgt - 1 : self.strip ;
            self.strip          = number;


            // show or hide the tiny left button
            visibility = (self.strip + squaresshow >= self.listlgt)? 'hidden' : 'visible' ;
            self.lightbox.find( self.cllist[7] ).css('visibility',visibility);


            // show or hide the tiny right button
            visibility = (self.strip <= 0)? 'hidden' : 'visible' ;
            self.lightbox.find( self.cllist[6] ).css('visibility',visibility);


            listbox.find('ul').css('left',0 - self.strip*160 + 'px');


                        // center the thumbstrip
            if (listwidth >= ulwidth) {
                listbox.find('ul').css('margin-left', padnum + 'px');
            }



        },


        // add a image ot the lightbox
        _imageSizer: function() {
            var self            = this,
                mainbox         = self.lightbox.find( this.cllist[2] ),
                mainimg         = mainbox.find('img'),
                mboxwidth       = mainbox.width(),
                mboxhgt         = mainbox.height(),
                imgwdt          = mainimg.width(),
                imghdt          = mainimg.height(),
                ratio           = imgwdt/imghdt,
                widthreduce     = mboxwidth -50,
                heightreduce    = Math.floor(widthreduce/ratio);
      

            // if the width is too much
            if (imgwdt > mboxwidth && imghdt < mboxhgt) {
                mainimg.css('width', mboxwidth -50 + 'px');
            } 


            // if the height is too much
            if (imgwdt < mboxwidth && imghdt > mboxhgt) {
                 mainimg.css('height', mboxhgt -50 + 'px');
            } 


            // if the width and height is too much
            if (imgwdt > mboxwidth && imghdt > mboxhgt) {

                if (heightreduce > mboxhgt) {
                    heightreduce =  mboxhgt -50;
                    widthreduce = Math.floor(heightreduce*ratio);
                }

                mainimg.css('width', widthreduce + 'px');
                mainimg.css('height', heightreduce  + 'px');

            } 

        },


        // the click manager that performs the functions after the clicks
        _manageParts: function(node, el) {
            var self            = this,
                

                funcTree        = {
                

                    // close and remove the lightbox
                    boxclose: function () { 
                       el.parents( self.cllist[1] ).remove();
                    },

                    // add the previous number
                    bigleft: function () { 
                       self.number--;
                       self._addImage(self.number);
                    },

                    // add the next number
                    bigright: function () { 
                       self.number++;
                       self._addImage(self.number);
                    },

                    // add the previous number
                    tinyleft: function () { 
                       self.strip--;
                       self._stripControl(self.strip);
                    },

                    // add the next number
                    tinyright: function () { 
                       self.strip++;
                       self._stripControl(self.strip);
                    },

                    imgClick: function () {
                         self.number = self.base.find( self.cllist[3] ).find('img').index(el);
                         self._addImage(self.number);
                    }

            };


            funcTree[node]();   

        },

        // the delegater function that manages the clicks
        _deleGate: function() {
            var self            = this;
            
            $(this.lightbox).on('click.lightClicker', function(e) {


                // event listener and binder for clicks
                if (typeof $(e.target).data( self.cllist[4]) !== 'undefined' ) {


                    var clickTarget = $( e.target ).data( self.cllist[4] );
                    self._manageParts( clickTarget,$( e.target ) ); 

                }


            }); 

            // prevent events from executing when chained   
            return false;
        }
        
    };

    $.fn.cromaLightbox = function() {
        new $.cromaLightbox($(this));
    };

})( jQuery, window );








jQuery(document).ready(function($) {

	/** This is the main JQuery file for the theme.
		It handles the small functions needed and also binds our larger.
		Editing these files wihtout a good knowledge of Javascript & JQuery can Render your Theme useless.
	**/ 


    /********************************************************************************** MEDIACAST SHOW PLAYER ON CLICK */
    $('.cro_mediacast_playerpart i').click(function() {
            var $this = $(this);
            $this.parents('.type-mediacast').find('.cro_playerholder').css('visibility','visible').css('height','40px');
    });




     /*************************************************************************************************** STICKEY MENU */
     var sptop = ($('#wpadminbar').length >= 1)?  32 :  0 ;
    $(".cro_menurow").sticky({
        topSpacing:sptop
    });


    /***************************************************************************************************** MAP HEADER */
     if ($('.croma_streetmapheader').length >= 1) {

        $('.cro_minimalheaderheader').css('display','none');

    }





    /*********************************************************************************************** CALENDAR FUNCTIONS */

    // set hte global div for the function
    var caldiv      = $('.cromax_tablecal');

     $(document).on("click", ".agendir i", function(){ 

        // set the variables
        var $this       = $(this),
            timings     = $this.parent('li').data('cro-agendir'),
            data        = { action: 'cromax_cal_ajaxdatas', 
                            type: 'cro_moveagenda', 
                            nonce: cro_query.cro_nonces, 
                            option1: timings};


         $.post(cro_query.ajaxurl, data, function(response) {

             $('.cromax_agendacal').html(response);

        });
    });



    $(document).on("click", ".caldir i", function(){ 
       
        // set the variables
        var $this       = $(this),
            timings     = $this.parent('li').data('cro-caldir'),
            data        = { action: 'cromax_cal_ajaxdatas', 
                            type: 'cro_movecal', 
                            nonce: cro_query.cro_nonces, 
                            option1: timings};
        

        $.post(cro_query.ajaxurl, data, function(response) {
            
            var wdt     = caldiv.width();

            caldiv.html(response);
            
            cro_hgtr(caldiv);
            if (wdt < 560) {
                $('ul.calday').hide();
                $('li.empty').hide();
            } else {
                $('ul.calday').show();
                $('li.empty').show();
            }
        });
    });

    if (caldiv.length >= 1) {
        cro_hgtr(caldiv);

        $(window).resize(function() {
            var wdt = caldiv.width();

            if (wdt < 560) {
                $('ul.calday').hide();
                $('li.empty').hide();
            } else {
                $('ul.calday').show();
                $('li.empty').show();
            }

        });
    }


    var wdt = caldiv.width();

    if (wdt < 560) {
        $('ul.calday').hide();
        $('li.empty').hide();
    } 


    function cro_hgtr(el){
        var $this = el;
        
        $this.each(function() {
            var hgt = 0;
            $('ul.maincal li').each(function() {
                var thgt = $(this).height();
                if (thgt > hgt) {
                    hgt = thgt;
                }
            });

            if (hgt > 120){
                $(this).find('.maincal li').find('.daybox').css('height', hgt + 'px');
            }

        });
    }





    /********************************************************************************** FIX GALLERY TITLES FOR LIGHTBOX */

    $('dl.gallery-item').each(function() {
        var alter = $(this).find('img').attr('alt'),
            imtarget = $(this).find('img');


        imtarget.attr('data-cro-title',alter);



    });




    /********************************************************************************************* IMAGE BANNER CLICKER */
    $('li.cro_fpage_img').click(function() {
        var targ = $(this).data('cro-linktarg'),
            link = $(this).data('cro-linker');


        if (targ == 2 && link) {
            window.open(link);
        } else if (targ == 1 && link) {
            window.location = link;
        }


    });




    /************************************************************************************************** COUNTDOWN TIMER */
    function croAnim(){ 


        // IF THERE'S A COUNTDOWN
        if ($('ul.cro_timervalue').length !== 0) {
            

            // GET ALL THE INSTANCES OF THE TIMER
            $('ul.cro_timervalue').each(function() {
                
                var $this       = $(this),
                    timesets    = $this.data('cro-countdownvalue'),               
                    now         = new Date(),
                    tset        = Math.floor(now / 1000),
                    counter1    = timesets - tset;
                    

                // CALCULATE SECONDS
                var seconds1    = Math.floor(counter1 % 60);  
                    seconds1    = (seconds1 < 10 && seconds1 >= 0) ? '0'+ seconds1 : seconds1;


                // CALCULATE MINUTES                
                counter1        =counter1/60;
                var minutes1    =Math.floor(counter1 % 60);
                minutes1        = (minutes1 < 10 && minutes1 >= 0) ? '0'+ minutes1 : minutes1;

                
                // CALCULATE HOURS
                counter1=counter1/60;
                var hours1=Math.floor(counter1 % 24);
                hours1 = (hours1 < 10 && hours1 >= 0) ? '0'+ hours1 : hours1;
            

                // CALCULATE DAYS
                counter1    =counter1/24;
                var days1   =Math.floor(counter1);
                days1       = (days1 < 10 && days1 >= 0) ? '0'+ days1 : days1;

 

                // ADD THE VALUES TO THE CORRECT DIVS
                $this.find('span.secondnumber').html(seconds1);
                $this.find('span.minutenumber').html(minutes1);
                $this.find('span.hournumber').html(hours1);
                $this.find('span.daynumber').html(days1); 


            });
        }
    }


    // CREATE A INTERVAL FOR THE TIMER
    croInit = setInterval(croAnim, 100);




    /************************************************************************************************** PAGE Animations */



    var getWindowW = $(window).width();


    if (getWindowW  >= 750) {


        $(window).load(function(){


            $('.animated').appear(function() {
        
                var elem        = $(this),
                animation   = elem.data('cro-anim-data');

            
                if ( !elem.hasClass('cro_animnot') ) {

                    var animationDelay = elem.data('cro-anim-delay');

                    if ( animationDelay ) {
            
                        setTimeout(function(){

                            elem.addClass( animation + " cro_animnot" );

                        }, animationDelay);

            
                    } else {
                    
                        elem.addClass( animation + " cro_animnot" );
            
                    }
                }
    
            }); 


            $('.cro_parra').appear(function() {
                var elem        = $(this);
                console.log(elem.offset().top);
            });

        });

    } else {

         $('.animated').removeClass('animated');

    }




     /************************************************************************************************** INVOKE THE LIGHTBOX */
     $('.cro_frontpage_gal').each(function() {
        $(this).find("ul li").slice( $(this).data('cro-showgals') ).hide();
     });



     $('a').click(function(event) {
        var $this = $(this);
        if ($this.attr('href') && $this.attr('href').match(/(.png|.gif|.jpg|.jpeg)$/) ) {
            event.preventDefault();
            $this.cromaLightbox($this);
        }

     });


     /******************************************************************************************************** MOBILE MENU */




    var ulParent = $('#croma-mobilenav').find('ul:first');

    ulParent.children('li').each(function() {
        if ($(this).find('ul').length >= 1) {
            $(this).addClass('cro_haschildren');
            $(this).children('a').addClass('cro_hastoggle');
        }
    });

    $('a.cro_hastoggle').click(function() {
        if (!$(this).parent('li').find('ul').hasClass('cro_has_visibility')) {
            ulParent.find('ul.cro_has_visibility').slideToggle('slow').removeClass('cro_has_visibility');
            $(this).parent('li').find('ul').slideToggle('slow').addClass('cro_has_visibility');
            return false;
        }
    });


    $(document).foundation();


     /******************************************************************************************************** SUPERFISH MENU */


    /** dropdown menu functions **/
    $('.croma-primarynav ul').superfish({
            delay:       1000,                            // one second delay on mouseout
            animation:   {opacity:'show',height:'show'},  // fade-in and slide-down animation
            speed:       'fast',                          // faster animation speed
            autoArrows:  true                               // disable generation of arrow mark-up
    });


    /** dropdown menu functions **/
    $('.croma-topbarnav ul').superfish({
            delay:       500,                            // one second delay on mouseout
            animation:   {opacity:'show',height:'show'},  // fade-in and slide-down animation
            speed:       'fast',                          // faster animation speed
            autoArrows:  true                               // disable generation of arrow mark-up
    });





    /******************************************************************************************************** RESPONSIVE VIDEO */

    $('.post').fitVids();



    /***************************************************************************************** MOBILE BANNER CLICK WORKAROOUND */

    $('span.calendarcoverspan').on({ 'touchstart' : function(){ 

        var atargetname     = $(this).parent('a');
        var atargetlink     = atargetname.attr('href');

        document.location.href=atargetlink;
  
        return false;

    } });



    /************************************************************************************************** RESPONSIVE CAROUSELS */


    if ($('.cro_frontpage_cal').length !== 0) {

        $('.cro_frontpage_cal').find('ul').each(function() {
            var $this   = $(this),
                lgt     = $this.children('li').length;
            
            if (lgt >= 5) {
                var mwdt        = $(this).width();
                var nxtcal      = $(this).parents('.cro_frontpage_cal').find('.cro_wnext').find('i');
                var prvcal      = $(this).parents('.cro_frontpage_cal').find('.cro_wprev').find('i');
                var owl         = $this;
                var dirholder   = $(this).parents('.cro_frontpage_cal').find('.cro_directional').show();

                owl.owlCarousel({
                    autoPlay : true,
                    pagination: false,
                    items : 4,
                    itemsDesktop : [1199, 4],
                    itemsDesktopSmall : [979, 3],
                    itemsTablet : [768, 3],
                    itemsMobile : [479, 1],
                });

                 $(nxtcal).click(function(){
                    owl.trigger('owl.next');
                })

                $(prvcal).click(function(){
                    owl.trigger('owl.prev');
                })
            }

        });


    }


    $('.cro_frontpage_scroll').each(function() {
        var el      = $(this).find('ul');


        el.owlCarousel({
            singleItem: true,
            autoHeight: true,
            autoPlay : true,
            pagination : true
        });

    });


});