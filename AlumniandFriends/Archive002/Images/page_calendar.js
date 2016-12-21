function calendar_ajax_get(elem, termID, pagedLoop) {
    
    if (termID<0){
       termID  =$('#term-id').val();
    }
    
   
    var monthID             = $('#month-id').val();
    var yearID              = $('#year-id').val();
    
    var $content_wrapper    = "#calendar-events-wrapper";
    var postLimit           = $('#limit').val();

    
    jQuery(".loading-page").show();
    
    jQuery.ajax({
        type: 'POST',
        url: ajaxHandler.ajaxurl,
        data: { "action": "load-calendar-events",
                term: termID,
                limit: postLimit,
                month: monthID,
                year: yearID,
                paged:pagedLoop
        },
        
        success: function(response) {
            jQuery($content_wrapper).html(response);
            jQuery(".loading-page").hide();
            
            
            // Go back to top
            $('html, body').animate({

                scrollTop: $(".breadcrumb").offset().top

            },1000);
            
            return false;
        }
    });
}

function calendar_ajax_getByMonth(elem,month, termID, pagedLoop) {
    
    if (termID<0){
       termID = $('#term-id').val();
    }
    
    
    var monthID             = month;
    var yearID              = $('#year-id').val();
    
    var $content_wrapper    = "#calendar-events-wrapper";
    var postLimit           = $('#limit').val();
    
    // Add class current to the category menu item being displayed so you can style it with css
    jQuery("#events-years-filter a").removeClass("active");
    jQuery(elem).addClass("active");
    
    
    jQuery("#loading-animation").show();
    
    jQuery.ajax({
        type: 'POST',
        url: ajaxHandler.ajaxurl,
        data: { "action": "load-calendar-events",
                term: termID,
                limit: postLimit,
                month: monthID,
                year: yearID,
                paged:pagedLoop
        },
        
        success: function(response) {
            jQuery($content_wrapper).html(response);
            jQuery("#loading-animation").hide();
            return false;
        }
    });
}

function calendar_ajax_ByCateg(elem, termID, pagedLoop) {
    
    var yearID              = $('#year-id').val();
    var $content_wrapper    = "#calendar-events-wrapper";
    var postLimit           = $('#limit').val();
    
    // Add class current to the category menu item being displayed so you can style it with css
    jQuery("#events-categs-filter a").removeClass("active");
    jQuery("#events-years-filter a").removeClass("active");
    jQuery(elem).addClass("active");
    
    
    jQuery("#loading-animation").show();
    
    jQuery.ajax({
        type: 'POST',
        url: ajaxHandler.ajaxurl,
        data: { "action": "load-calendar-events",
                term: termID,
                limit: postLimit,
                year: yearID,
                paged:pagedLoop
        },
        
        success: function(response) {
            jQuery($content_wrapper).html(response);
            jQuery("#loading-animation").hide();
            return false;
        }
    });
}