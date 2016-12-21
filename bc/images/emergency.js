var $bc = {};

$bc.emergencyCallBack = function(data) {

  var item = data.getElementsByTagName('item')[0];
  
  var descriptionItems = item.getElementsByTagName('description');
  var description = '';
  
  if (descriptionItems.length > 0) {
    description = descriptionItems[0].firstChild.nodeValue;
  }  

  if (jQuery.trim(description) != '' && jQuery.trim(description.toUpperCase()) != 'INACTIVE') {
    $bc.addBanner(description);
  } else {
    
    /* change back to /rss/emergency.json when going to production */
    
    jQuery.getJSON('/rss/emergency.json?'+ (new Date()).getTime(), '', function(d) {
      if (d[0].status == 'on') {
        $bc.addBanner(d[0].headline + '. ' + d[0].message);
      }
    });
    
    
  }

}


$bc.addBanner = function(rave_message) {
  var div = document.createElement('div');
  div.id = "emergency_bar";
    
  var divInner = document.createElement('div');
  divInner.id = "emergency_message";
  divInner.appendChild(document.createTextNode(rave_message));
  
  div.appendChild(divInner);
        
  document.body.insertBefore(div, document.body.firstChild);
  
  setTimeout(function() {
	if ($('#emergency_bar').length > 0) {
	  $('#emergency_bar').clone().appendTo('.rave-alert');
	  $('.rave-alert').show();
    }  
  }, 1000)
  
}

/*
$bc.addEventSimple = function (obj,evt,fn) {
	if (obj.addEventListener)
		obj.addEventListener(evt,fn,false);
	else if (obj.attachEvent)
		obj.attachEvent('on'+evt,fn);
}


$bc.addEventSimple(window, 'load', function() {
  jQuery.get('/rss/rave.xml?'+ (new Date()).getTime(), '', $bc.emergencyCallBack, 'xml');
});*/

$(document).ready(function() {
  jQuery.get('/rss/rave.xml?'+ (new Date()).getTime(), '', $bc.emergencyCallBack, 'xml');
});



