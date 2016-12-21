Event.observe ( window, "load", function() {
    $$('.nav_menu_root').each(function(item) {
        Event.observe(item, "mouseover", function() {           
                        
            // Default background on mouse over
            item.style.backgroundImage = "url('/tennis/images/menu/menu_bg_tennis.jpg')";
            
            $A(item.childNodes).each(function(node) {
                if (node.className == "nav_menu_subitems") {
                    node.style.display = "block";
                }
            });            
        });
        
        Event.observe(item, "mouseout", function() {
            item.style.backgroundImage = "";
            
            $A(item.childNodes).each(function(node) {
                if (node.className == "nav_menu_subitems") {
                    node.style.display = "none";
                }
            });    
        });        
    });
});