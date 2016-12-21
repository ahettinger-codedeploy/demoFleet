
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

   });


