/******** AUTHOR : FAISAL CHISHTI **********/

 var timer = 0;
 var isRunning = false;
 var dropdownObj = null;
 var elementString = "";
 var compareElementString = "";
 var isShown = false;
 var timeout;
 var maxTime = 20;
 
 function showMenu() {
   if(elementString.length > 0 && compareElementString.length > 0)
   {
       if(elementString == compareElementString) {
           if(dropdownObj != null) {
               //$(dropdownObj).children("#submenu-container").css("opacity", "0.95").slideDown(450);
               $(dropdownObj).children("#submenu-container").fadeIn("slow");
               $(dropdownObj).children("a").addClass("current");
               isShown = true;
           }
       }
   }
 }
 
 function startTimer() {
   isRunning = true;
   timer = timer + 1;
   
   if(timer == maxTime - 1) {
       showMenu();
   }
   
   if (timer == maxTime) {
     timer = 0;
   }
   //$("#timer").html(timer);
   timeout = setTimeout("startTimer()", 1);
 }
 
 function stopTimer() {
   isRunning = false;
   clearTimeout(timeout);
   timer = 0;
   //$("#timer").html("timer stopped");
 }

function initMenu() {
    $("#nav ul li.dropdown-li").hover(
      function() {
        if(!isRunning) {
            startTimer();
            elementString = $(this).children("a").attr("class");
            dropdownObj = $(this);
        }
      },
      function() {
        if(isRunning) {
	        stopTimer();
	        if (dropdownObj != null && isShown) {
		        //$(this).children("#submenu-container").slideUp(700);
                        $(this).children("#submenu-container").fadeOut("slow");
                $(this).children("a").removeClass("current");
	        }
	        isShown = false;
	        dropdownObj = null;
	        elementString = "";
	        compareElementString = "";
	    }
      }
    );

	$("#nav ul li.dropdown-li").mousemove(
        function(e){
            compareElementString = $(this).children("a").attr("class");
	    }
	);
}