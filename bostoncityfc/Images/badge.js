(function() {// Localize jQuery variable
var jQuery;
/******** Load jQuery if not present *********/
if (window.jQuery === undefined) {
    var script_tag = document.createElement('script');
    script_tag.setAttribute("type","text/javascript");
    script_tag.setAttribute("src",
        "//ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js");
    if (script_tag.readyState) {
      script_tag.onreadystatechange = function () { // For old versions of IE
          if (this.readyState == 'complete' || this.readyState == 'loaded') {
              scriptLoadHandler();
          }
      };
    } else { // Other browsers
      script_tag.onload = scriptLoadHandler;
    }
    // Try to find the head, otherwise default to the documentElement
    (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
} else { // The jQuery version on the window is the one we want to use
    jQuery = window.jQuery;
    main();
}

/******** Called once jQuery has loaded ******/
function scriptLoadHandler() { // Restore $ and window.jQuery to their previous values and store the new jQuery in our local jQuery variable
    jQuery = window.jQuery.noConflict(true);
    main(); // Call our main function
}

/******** Our main function ********/
function main() {
    jQuery(document).ready(function($) {
      // DEFINIE EXTERNAL URLS

      var monitor = $("#sucuri-s").attr("data-s");

      var badgeURL = "https://sucuri.net/monitoring/badge.css";
      var verifyURL = "https://monitor" + monitor + ".sucuri.net/verify.php";

      // LOAD CSS
      var css_link = $("<link>", {
          rel: "stylesheet",
          type: "text/css",
          href: badgeURL
      });
      css_link.appendTo('head');

      // DEFINE CLICK EVENT
      function SucuriPopup(pageURL, title, w, h) {
          // var site = window.location.host;
          var left = ((screen.width - w) / 2) - 100;
          var top = (screen.height - h) / 4;
          pageURL = pageURL;
          // + "?site=" + site;
          var targetWin = window.open(pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
      }

      // DEFINE HTML
      var template = '\
      <div id="sucuri-badge">\
        <div class="sucuri-badge-symbol"></div>\
        <span class="sucuri-badge-text">secured by</span>\
        <div class="sucuri-badge-logo"></div>\
      </div>';

      // ADD HTML
      var position = $("#sucuri-s").attr("data-p");

      if(position == "relative" || position == "o"){
        $("#sucuri-s").after(template);
      }else{
        $("body").append(template);
      }

      var badge = $("body").find("#sucuri-badge");

      var color = $("#sucuri-s").attr("data-c");
      var type = $("#sucuri-s").attr("data-t");
      var siteId = $("#sucuri-s").attr("data-i");

      if(position == "l" || position == "left"){
        position = "left";
      }else if(position == "r" || position == "right"){
        position = "right";
      }
      else{
        position = "relative";
      }

      if(color == "d" || color == "dark"){color = "dark";}else{color = "light";}

      if(type == "s" || type == "secure"){type = "secure";}
      else if(type == "t" || type == "tick"){type = "tick";}
      else{type = "flame";}

      var position = "sucuri-" + position;
      var color = "sucuri-" + color;
      var type = "sucuri-" + type;

      badge.removeClass("sucuri-right, sucuri-left");
      badge.addClass(position).addClass(color).find(".sucuri-badge-symbol").addClass(type);

      // ATTACH CLICK EVENT
      $(document).delegate('#sucuri-badge', 'click', function(event) {
        SucuriPopup(verifyURL + "?r=" + siteId, 'Sucuri', 705, 800);
      });

    });
}
})(); // We call our anonymous function immediately