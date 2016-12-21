/* Portfolio */
jQuery(function($){
  $(".box p").css({opacity:0});
  $(".cover").css({ opacity:0.7});

          //Partial Sliding (Only show some of background)
          $('.box').hover(function(){
            $(".cover", this).stop().animate({top:'90px', opacity:1},{queue:false,duration:400, easing:'easeOutQuart'});
            $(this).find("p").stop().animate({opacity:1},{queue:false,duration:400, easing:'easeOutQuart'});
          }, function() {
            $(".cover", this).stop().animate({top:'0px', opacity:0.7},{queue:false,duration:400, easing:'easeOutQuart'});
            $(this).find("p").stop().animate({opacity:0},{queue:false,duration:400, easing:'easeOutQuart'});
          });

          $('.box a').css({'opacity': 0.7});
          $('.box a').hover(function() { 
              $(this).stop().animate({'opacity': 1}, 'fast');
              },function() { 
              $(this).stop().animate({'opacity': 0.7}, 'fast');
          });

});



jQuery(function($){
          $('.zoom img').hover(function() { 
              $(this).stop().animate({'opacity': 0.4}, 'fast');
              },function() { 
              $(this).stop().animate({'opacity': 1}, 'fast');
         });
});

jQuery(function($){
  
        var items = $('#stage li'),
        itemsByTags = {};
  // Looping though all the li items:
  
  items.each(function(i){
    var elem = $(this),
      tags = elem.data('tags').split(',');
    
    // Adding a data-id attribute. Required by the Quicksand plugin:
    elem.attr('data-id',i);
    
    $.each(tags,function(key,value){
      
      // Removing extra whitespace:
      value = $.trim(value);
      
      if(!(value in itemsByTags)){
        // Create an empty array to hold this item:
        itemsByTags[value] = [];
      }
      
      // Each item is added to one array per tag:
      itemsByTags[value].push(elem);
    });
    
  });

  // Creating the "Everything" option in the menu:
  createList('All',items);

  // Looping though the arrays in itemsByTags:
  $.each(itemsByTags,function(k,v){
    createList(k,v);
  });
  
  $('#filter a').live('click',function(e){
    var link = $(this);
    
    link.addClass('active').siblings().removeClass('active');
    
    // Using the Quicksand plugin to animate the li items.
    // It uses data('list') defined by our createList function:
    
    $('#stage').quicksand(link.data('list').find('li'), 
                  {
                    duration: 1000
                  }, function() { 
                     /* Callback function */
                     //To switch directions up/down and left/right just place a "-" in front of the top/left attribute
        //Partial Sliding (Only show some of background)
        $('.box').hover(function(){
          $(".cover", this).stop().animate({top:'90px', opacity:1},{queue:false,duration:400, easing:'easeOutQuart'});
          $(this).find("p").stop().animate({opacity:1},{queue:false,duration:400, easing:'easeOutQuart'});
        }, function() {
          $(".cover", this).stop().animate({top:'0px', opacity:0.7},{queue:false,duration:400, easing:'easeOutQuart'});
          $(this).find("p").stop().animate({opacity:0},{queue:false,duration:400, easing:'easeOutQuart'});
        });

        $('.box a').css({'opacity': 0.7});
        $('.box a').hover(function() { 
            $(this).stop().animate({'opacity': 1}, 'fast');
            },function() { 
            $(this).stop().animate({'opacity': 0.7}, 'fast');
        });
                  });
                        e.preventDefault();
  });
  
  $('#filter a:first').click();
  
  function createList(text,items){
    
    // This is a helper function that takes the
    // text of a menu button and array of li items
    
    // Creating an empty unordered list:
    var ul = $('<ul>',{'class':'hidden'});
    
    $.each(items,function(){
      // Creating a copy of each li item
      // and adding it to the list:
      
      $(this).clone().appendTo(ul);
    });

    ul.appendTo('#container');

    // Creating a menu item. The unordered list is added
    // as a data parameter (available via .data('list'):
    
    var a = $('<a>',{
      html: text,
      href:'#',
      data: {list:ul}
    }).appendTo('#filter');
  }
               
});

jQuery(function($){
          $(".fancybox").fancybox({
          openEffect  : 'elastic',
            closeEffect : 'elastic',
            helpers : {
              title : {
                type : 'inside'
              }
            }
        });
        });