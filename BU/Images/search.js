function goSearch() {
  // catch empty search
  var nonEmpty = /\w+/;
nonEmpty.test(document.searchbox.qt.value);
  if(!nonEmpty.test(document.searchbox.qt.value)) {
     alert('Please supply a search term.');
         return;
  }
  // NOTE: Replace www.bu.edu/your-site-here <http://www.bu.edu/your-site-here>  in the declaration below
  // with the actual web address to your site
   if (document.searchbox.q[0].checked) {
      var searchurl="http://search.bu.edu/dept/query.html?qp=url:www.bu.edu/sargent&qt="+document.searchbox.qt.value+"&col=main";
          }
   if (document.searchbox.q[1].checked) {
      var searchurl="http://www.bu.edu/phpbin/webph/index.php?search_for="+document.searchbox.qt.value;
          }
         window.location.href = searchurl;
         return false;
}

  // this function is needed to work around 
  // a bug in IE related to element attributes
  function hasClass(obj) {
     var result = false;
     if (obj.getAttributeNode("class") != null) {
         result = obj.getAttributeNode("class").value;
     }
     return result;
  }   

 function stripe(tableClass,oddClass,evenClass) {

    // the flag we'll use to keep track of 
    // whether the current row is odd or even
    var even = false;
  
    // if arguments are provided to specify the colours
    // of the even & odd rows, then use the them;
    // otherwise use the following defaults:
    var evenColor = arguments[1] ? arguments[1] : "#fff";
    var oddColor = arguments[2] ? arguments[2] : "#eee";
  
    // obtain a reference to the desired table
    // if no such table exists, abort
//    var table = document.getElementById(id);
  //  if (! table) { return; }
	
	var tables = document.getElementsByTagName('table');
	
	for (p=0;p<tables.length;p++)
	{
		var elementClass = tables[p].getAttribute("class");
		elementClass = elementClass ? elementClass : tables[p].getAttribute("className");
		
		if(elementClass == tableClass) {
			even = false;
	
			// by definition, tables can have more than one tbody
			// element, so we'll have to get the list of child
			// &lt;tbody&gt;s 
			var tbodies = tables[p].getElementsByTagName("tbody");
		
			// and iterate through them...
			for (var h = 0; h < tbodies.length; h++) {
		
			 // find all the &lt;tr&gt; elements... 
			  var trs = tbodies[h].getElementsByTagName("tr");
			  
			  // ... and iterate through them
			  for (var i = 0; i < trs.length; i++) {
		
				// avoid rows that have a class attribute
				// or backgroundColor style
				if (! hasClass(trs[i]) &&
					! trs[i].style.backgroundColor) {
				  
				  // get all the cells in this row...
				  var tds = trs[i].getElementsByTagName("td");
				
				  // and iterate through them...
				  for (var j = 0; j < tds.length; j++) {
				
					var mytd = tds[j];
		
					// avoid cells that have a class attribute
					// or backgroundColor style
					if (! hasClass(mytd) &&
						! mytd.style.backgroundColor) {
						mytd.className = 
						even ? evenClass : oddClass;
					
					}
				  }
				}
				// flip from odd to even, or vice-versa
				even =  ! even;
			  }
			}
		}
	}
  }