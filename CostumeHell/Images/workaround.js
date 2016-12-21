///////////////////////////////////////////////////////
// Executes only when the page has been fully loaded
///////////////////////////////////////////////////////

var defaultSearchLine    = 'Search Costume Hell...';
var defaultSubscribeLine = 'Enter your email address...';

$(function() {

  // $('.rounded, .tagline, .avatar img').bg(3);
  // $('.block, .body').bg(8);
  
  // Angels
  var an_timer_id = null;

  var an_api = $("#top-block div.scrollable").scrollable({api:true, speed: 700, easing: 'linear', size:4});
  
  $("#top-block .prev").mouseover(
    function () {
      an_api.prev();
      if (!an_timer_id) {
        an_timer_id = setInterval(function() { an_api.prev(); }, 700);
      }
    }
  );
  
  $("#top-block .next").mouseover(
    function () {
      an_api.next();
      if (!an_timer_id) {
        an_timer_id = setInterval(function() { an_api.next(); }, 700);
      }
    }
  );

  $("#top-block .prev, #top-block .next, #top-block").mouseleave(
    function () {
      an_scrolling = 0;
      clearInterval(an_timer_id); 
      an_timer_id = null;
    }
  );

  an_api.getItemWrap().load("/_ajax/header/angels.php", { param:12234 }, function() {
    an_api.reload().start();
  });
  
  $("#shopping-cart-container").load("/_ajax/header/shopping-cart.php");
  
  // $("#footer-block").load("/_ajax/header/footer.php");


  // Popup
  $("a.popup").overlay({
    onBeforeLoad: function() {  
      var wrap = this.getContent().find("div.wrap"); 
      wrap.html('<img src="' + this.getTrigger().attr("href") + '" alt="" /><br /><p style="text-align:center">' + this.getTrigger().attr("title") + '</p>'); 
    },
    target: "#overlay",
    // close: "#overlay",
    speed: "fast"
  }); 


  $("#search-line").focus(function() {
    if ($(this).val() == defaultSearchLine) $(this).val('');
  });
  
  $("#search-line").blur(function() {
    if (!$(this).val()) $(this).val(defaultSearchLine);
  });
  
  $("#search-form").submit(function() {
    $("#search-line").focus();
    
    if ($("#search-line").val()) {
      return true;
    } else {
      alert("Nothing to search!");
      return false;
    }
  });
  


  $("#subscribe-line").focus(function() {
    if ($(this).val() == defaultSubscribeLine) $(this).val('');
  });
  
  $("#subscribe-line").blur(function() {
    if (!$(this).val()) $(this).val(defaultSubscribeLine);
  });
  
  $("#subscribe-form").submit(function() {
    $("#subscribe-line").focus();
    
    if ($("#subscribe-line").val()) {
      return true;
    } else {
      alert("Please specify an email address to subscribe!");
      return false;
    }
  });
  
  $("#search-line").blur();
  $("#subscribe-line").blur();
});


var block_rate = function(b, r) {
  $("#block-rate" + b).load('/_ajax/block/vote.php', { a:'vote', id:b, rate:r });
  
  return false;
}
