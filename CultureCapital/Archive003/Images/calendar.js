
   // set up XML request object, ActiveX for IE

   function createRequestObject() 
   {
      var ro;
      if (window.XMLHttpRequest) 
      {
         try 
         {
            ro = new XMLHttpRequest();
         } 
         catch(e) 
         {
            ro = false;
         }
      } 
      else if (window.ActiveXObject) 
      {
         ro = new ActiveXObject("Microsoft.XMLHTTP");
      }
      return ro;
   }

   var http = createRequestObject();


   // send a request to server

   function sndMonth(yrmo) 
   {
      http.open('get', '/calendarAJAX.php?month='+yrmo);
      http.onreadystatechange = updateMonth;
      http.send(null);
   }

   // handle response from server

   function updateMonth() 
   {
      if (http.readyState == 4)
      {
         var response = http.responseText;
         document.getElementById('calendar').innerHTML = response;
      }
   }

   // default date control is start date

   datePrefix = 'start';

   // display date control

   function openDateControl(vers)
   {
      // determine version (start/end) and set title

      datePrefix = vers;
      var titleText = 'Select Start Date...';
      if (datePrefix == 'end') titleText = 'Select End Date...';
      document.getElementById('dateControlTitle').innerHTML = titleText;

      // distance scrolled down

      var d = 0;
      if (window.pageYOffset)
      { 
         d = window.pageYOffset; 
      }
      else if (document.documentElement && document.documentElement.scrollTop)
      {
         d = document.documentElement.scrollTop;
      }
      else if (document.body)
      {
         d = document.body.scrollTop;
      }

      // available window width

      var wx = 0;
      var wy = 0;
		
      if (window.innerWidth)
      {
         wx = window.innerWidth;
         wy = window.innerHeight;
      }
      else if (document.documentElement && document.documentElement.clientWidth)
      {
         wx = document.documentElement.clientWidth;
         wy = document.documentElement.clientHeight;
      }
      else if (document.body)
      {
         wx = document.body.clientWidth;
         wy = document.body.clientHeight;
      }

      // position and display box

      box = document.getElementById("dateControl");
      // box.style.left = (wx - 476)/2 - 10;
      // box.style.top = (wy - 400)/2 + d - 67;
      box.style.left = 245;
      box.style.top = 35;
      box.style.display = "block";      

      // hide selectors for busted IE
      sel1 = document.getElementById("category");
      sel1.style.display = "none";
      sel2 = document.getElementById("rcode");
      sel2.style.display = "none";
   }

   // hide date control

   function closeDateControl()
   {
      box = document.getElementById("dateControl");
      box.style.display = "none";

      // show selectors for busted IE
      sel1 = document.getElementById("category");
      sel1.style.display = "block";
      sel2 = document.getElementById("rcode");
      sel2.style.display = "block";
   }

   // set date from control

   function setDate(ymd,desc)
   {
      document.getElementById(datePrefix + "date").value = ymd;
      document.getElementById(datePrefix + "desc").innerHTML = desc;
      closeDateControl();
      // opener.document.editform.title.focus();
   }


