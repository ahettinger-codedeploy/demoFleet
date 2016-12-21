
   // startup 
   
   $().ready(function()
   {

      // external links in new window
      $("#content a[href^='http://']").attr("target","_blank");

      // autocomplete

      $("#terms").autocomplete('/autocomplete.php',{width: 222,selectFirst: false,minChars: 3,cacheLength: 1});
      $("#terms").result(function(event,data,formatted) 
      {
         if (data) 
         { 
            $('#directhit').val(data[1]); 
            $('#search').submit();
         }
      });

      // date pickers
      
      $("#startshow").datepicker({ numberOfMonths: 2, altField: '#startdate', altFormat: 'yy-mm-dd', showButtonPanel: true }); 
      $("#endshow").datepicker({ numberOfMonths: 2, altField: '#enddate', altFormat: 'yy-mm-dd', showButtonPanel: true });

      // obstructing dialog box: http://www.jqueryscript.net/lightbox/Responsive-Accessible-jQuery-Modal-Plugin-Popup-Overlay.html
      
      $('#obstruction').popup({ transition: 'all 0.3s' });
      $('#obstruction').popup('show');

      // validate specified forms
      $('.validate').validate();

      // add word counters
      $('#companydesc').counter({ type: 'word', goal: 75 });
      $('#services').counter({ type: 'word', goal: 50 });
      $('#discount').counter({ type: 'word', goal: 25 });
      $('#description').counter({ type: 'word', goal: 100 });

   });

   // go-bar
 
   function gobar(selector)
   {
      var selectedURL = "selector.options[selector.selectedIndex].value";
      if (eval(selectedURL) != "") document.location = eval(selectedURL); 
   }
