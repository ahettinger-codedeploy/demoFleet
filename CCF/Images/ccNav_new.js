(function($){
    
    //Function for CCF Navigation
    $.fn.ccNav = function() {
        
        return this.each(function() {
            // this is the <ul>

            var container = $(this);
            container.inputFocused = false;
            container.mouseIsOver = false;
            container.okToOpen = true;
            container.timeOut;
            container.delay = 90;
            $(this).find(".navItem").each(
		// This is an <li class="navItem">
                function(){ 
                    var ccontainer = container;
                    $(this).hover(
                        function(){ 
                            
                             
                            if(ccontainer.okToOpen){
                                ccontainer.mouseIsOver = true;
                                openFlyOut($(this)); 
                                ccontainer.okToOpen=false;
                            }
                            else if($(this).hasClass("active")){
                                clearTimeout(ccontainer.timeOut);
                            }
                    
                        },
                        function(){ 
                            
                            if($(this).hasClass("active")){
                                var container = ccontainer;
                                var el = $(this);
                                var delayF = function(){
                                    container.mouseIsOver = false; 
                                    closeFlyOut(el);  
                                }
                                container.timeOut = setTimeout(delayF,container.delay);
                            }
                        }
                    );
                    $(this).mousemove(function(){
                    
                        if(!$(this).hasClass("active") && ccontainer.okToOpen){
                            ccontainer.mouseIsOver = true;
                            openFlyOut($(this));
                            ccontainer.okToOpen=false;
                        }
                    
                    });
                    var navLi = $(this);
                    $(this).find(":input").each(function(){ 
                        $(this).focus(function(){ ccontainer.okToOpen = false; ccontainer.inputFocused=true; });
                        $(this).blur(function(){ ccontainer.inputFocused=false; closeFlyOut(navLi); });
                    });
                    
                    
                });
            
            var openFlyOut = function(el){
                if(!container.inputFocused && container.okToOpen){
                    
                    
                    el.addClass("active");
                        
                    
                    
                }
            
            };
            
            var closeAndMoveOn = function(){
                
                container.find(".active").removeClass("active");
                container.okToOpen=true;
            };
            
            var closeFlyOut = function(el){
                
                if(!container.inputFocused && !container.mouseIsOver){
                    
                    closeAndMoveOn();                

                    //setTimeout(closeAndMoveOn, 1000);
                }
                
            
            };
        
         });

     };

})(jQuery);

