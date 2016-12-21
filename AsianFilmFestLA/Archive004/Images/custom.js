/* Menu */
function mainmenu(){
    jQuery(function($){
    $(" #mp-primary-menu ul ").css({display: "none"}); // Opera Fix
    $(" #mp-primary-menu li").hover(function(){
            $(this).find('ul:first').css({visibility: "visible",display: "none"}).show(400);
            },function(){
            $(this).find('ul:first').css({visibility: "hidden"});
            });
     });
}

 
jQuery(document).ready(function($){                  
    mainmenu();
});

jQuery(function($){              
    $('img.alignright').parent('a').addClass('right');
    $('img.alignleft').parent('a').addClass('left');
});

jQuery(function($){              
    $('.hastip').tooltipsy();
});


jQuery(function($){
    $('.scroll').bind('click',function(event){
        var $anchor = $(this);                   
        $('html, body').stop().animate({
        scrollTop: $($anchor.attr('href')).offset().top
    }, 1500,'easeInOutQuad'); 
        event.preventDefault();
    });
});

jQuery(function($){    
    $('iframe, object, embed').each(function(){
      var url = $(this).attr("src");
      if(url.indexOf("?") != -1)
            {
                 $(this).attr("src",url+"&wmode=transparent");
            }else{
                $(this).attr("src",url+"?wmode=transparent");
            }
      });
});


 

/* Links */
/*
jQuery(function($){

	hover = '.social-icons span, a:not(.button, .more-link, .no-effect, #logo, .jp-audio a, #nav-container a, .notif a, .zoom)';
	  $(hover).hover(function() { 
	      $(this).stop().animate({'opacity': 0.7}, 'fast');
	      },function() { 
	      $(this).stop().animate({'opacity': 1}, 'fast');
	  });  

});
*/

if( jQuery().isotope ) {
      
      jQuery(function() {

              var container = jQuery('.isotope'),
                  optionFilter = jQuery('#filter-store'),
                  optionFilterLinks = optionFilter.find('a');
              
              optionFilterLinks.attr('href', '#');
              
              optionFilterLinks.click(function(){
                  var selector = jQuery(this).attr('data-filter');
                  container.isotope({ 
                      filter : '.' + selector, 
                      itemSelector : '.isotope-item',
                      layoutMode : 'fitRows',
                      animationEngine : 'best-available'
                  });
                  
                  // Highlight the correct filter
                  optionFilterLinks.removeClass('active');
                  jQuery(this).addClass('active');
                  return false;
              });
            
      });
    
  }


jQuery(function($){
          $('.zoom img').hover(function() { 
              $(this).stop().animate({'opacity': 0.4}, 'fast');
              },function() { 
              $(this).stop().animate({'opacity': 1}, 'fast');
         });
});

jQuery(function($){

  $( ".tabgroup" ).tabs({ fx: { opacity: 'toggle' }});
  $( ".accordion" ).accordion({ animated: 'bounceslide' });
});

jQuery(function($){

    div = '.search-form, .widget_search';
    input = '.search-form input, .widget_search input';
    $(input).focus(function(){
          $(this).animate({'color':'#000000'});
          $(this).parent().parent().animate({'background-color': '#ccc'});  
      });
      $(input).blur(function(){
          $(this).animate({'color':'#434448'});
          $(this).parent().parent().animate({'background-color': '#b5b5b5'});        
      });

    $(input).each(function(){
        var defaultText = $(this).val();
        $(this).focus(function(){        
            if($(this).val()==defaultText){
                $(this).val("");
            }
        });
       
    $(this).blur(function(){
            if($(this).val()==""){
               $(this).val(defaultText);
            }
        });
    });
});

jQuery(function($){
  $('.notif .close').click(function() {
      $(this).parent().parent().slideUp();
      return false;
      });
  });

jQuery(function($){
     $("#contactsubmit").click(function(){        
        valid = true;
        if(!$('input[name=antispam]').val()==""){
            valid = false;
        }

        if($("#inputname").val()==""){
            valid = false;
           $("#inputname").parent().parent().addClass('error'); 
           $("#inputname").next('div').css({visibility: "visible",display: "none"}).show(400);
               $("#inputname").focus(function(){
               $("#inputname").next('div').fadeOut();
               $("#inputname").parent().parent().removeClass('error');
           });
        }
        
        if($("#inputsubject").val()==""){
            valid = false;
           $("#inputsubject").parent().parent().addClass('error'); 
           $("#inputsubject").next('div').css({visibility: "visible",display: "none"}).show(400);
               $("#inputsubject").focus(function(){
               $("#inputsubject").next('div').fadeOut();
               $("#inputsubject").parent().parent().removeClass('error');
           });
        }

        if($("#inputemail").val()==""){
            valid = false;
           $("#inputemail").parent().parent().addClass('error');
           $("#inputemail").next('div').css({visibility: "visible",display: "none"}).show(400);
           $("#inputemail").focus(function(){
               $("#inputemail").next('div').fadeOut();
               $("#inputemail").parent().parent().removeClass('error');
           });
        }
        else if(!$("#inputemail").val().match(/^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/)){
           valid = false; 
           $("#inputemail").parent().parent().addClass('error');
           $("#inputemail").next().next('div').css({visibility: "visible",display: "none"}).show(400);
           $("#inputemail").focus(function(){
               $("#inputemail").parent().parent().removeClass('error');
               $("#inputemail").next().next('div').fadeOut(); 
           });
        }
        
        if($("#inputmessage").val()==""){
            valid = false;
           $("#inputmessage").parent().parent().addClass('error');
           $("#inputmessage").next('div').css({visibility: "visible",display: "none"}).show(400);
           $("#inputmessage").focus(function(){
               $("#inputmessage").next('div').fadeOut();
               $("#inputmessage").parent().parent().removeClass('error');
           });
        }
        
        return valid;
     });
});

/* Css hacks for IE and other fixes */

jQuery(function($){  
    $('.widget-row div.grid_4:first-child').addClass('alpha');
    $('.widget-row div.grid_4:nth-child(3)').addClass('omega');

    $('.grid_8 .widget-row div.grid_4:first-child').addClass('alpha');
    $('.grid_8 .widget-row div.grid_4:nth-child(2)').addClass('omega');
    
    $('#blog .post div.separator, .item div.separator').last().hide();
    $('#store .item-single div.separator').last().hide();
    $('aside .widget .separator').last().hide();

    //$('span.blog-link:first-child').addClass('first-blog-link');
});