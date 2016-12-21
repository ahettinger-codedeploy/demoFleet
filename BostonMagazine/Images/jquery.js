/* 
JQVibrator 1.1.1
All Code - Copyright Tom Arnfeld 2009
http://tarnfeldweb.info/jqvibrate/
This notice must remain otherwise it is a breach of copyright
*/

	jQuery.fn.vibrate = function(direction,size) {
			if(direction == "ud") {
				$(this).animate({ marginTop:size }, 50);
    			$(this).animate({ marginTop:"-"+size+"px" }, 50);
    			$(this).animate({ marginTop:size }, 50);
    			$(this).animate({ marginTop:"-"+size+"px" }, 50);;
    			$(this).animate({ marginTop:size }, 50);
    			$(this).animate({ marginTop:"-"+size+"px" }, 50);
    			$(this).animate({ marginTop:"0px" }, 50);
			}
			else {
				if(direction == "lr") {
					$(this).animate({ marginLeft:size }, 50);
    				$(this).animate({ marginLeft:"-"+size+"px" }, 50);
    				$(this).animate({ marginLeft:size }, 50);
    				$(this).animate({ marginLeft:"-"+size+"px" }, 50);
    				$(this).animate({ marginLeft:size }, 50);
    				$(this).animate({ marginLeft:"-"+size+"px" }, 50);
    				$(this).animate({ marginLeft:"0px" }, 50);
				}
				else {
					console.log("Invalid Argument");
				}
			}
	
    		
		};