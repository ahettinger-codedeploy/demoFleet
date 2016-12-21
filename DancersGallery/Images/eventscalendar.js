/**
 * Scripts to have pop ups over the event links
 */

function InitJQuery(){

jQuery.bt.defaults.closeWhenOthersOpen = true;
 
  var pop = jQuery('div.pop');
  
  if (pop.length > 0)
  (
   
   pop.each(function() {
   var target = jQuery(this);   
   
   target.bt(
   {
    ajaxPath: ["jQuery(this).attr('href')"],
    strokeStyle: '#aec8e8',
    fill: '#fff',
    strokeWidth: 2,
    trigger:'click',
    positions:['left', 'right', 'top', 'bottom'],
    width: 400
   }
   );
    }
   )
   )

var popattendees = jQuery('span.popattendees');
  
  if (popattendees.length > 0)
  (   

    jQuery('span.popattendees').each(function() {
  
   var target = jQuery(this);   
   
   target.bt(
   {
    ajaxPath: ["jQuery(this).attr('href')"],
    strokeStyle: '#aec8e8',
    fill: '#fff',
    strokeWidth: 2,
    trigger: 'click',    
    width: 760
   }
   );
  })
  );

var poplink = jQuery('span.poplink');
  
  if (poplink.length > 0)
  (   

    jQuery('span.poplink').each(function() {
  
   var target = jQuery(this);   
   
   target.bt(
   {
    ajaxPath: ["jQuery(this).attr('href')"],
    strokeStyle: '#aec8e8',
    fill: '#fff',
    strokeWidth: 2,
    trigger: 'click',
    width: 500
   }
   );
  
 }
 )
 );
 
 
if (jQuery('a.btnTop').length > 0)
  (jQuery('a.btnTop').bt({
    strokeStyle: '#aec8e8',
    fill: '#fff',
    strokeWidth: 2,
    trigger:['mouseover', 'click'],
    positions:['bottom'],
    cssStyles: {width: 'auto'}
    }));

if (jQuery('input.evtSearchTxt').length > 0)
  (jQuery('input.evtSearchTxt').bt({
    strokeStyle: '#aec8e8',
    fill: '#fff',
    strokeWidth: 2,
    trigger:['mouseover', 'click'],
    width: 100,
    positions:['bottom'],
    cssStyles: {width: 'auto'}
    }));
    
var trAttendee = jQuery('tr.MyAttendee');

trAttendee.each(function() {
    
})

jQuery(trAttendee).hover(function () {
      jQuery(this).css({'background-color' : 'yellow'});
      }, function () {
      var cssObj = {'background-color' : '#F7F6F3'}
      jQuery(this).css(cssObj);
    })
  
jQuery(trAttendee).click(function() {
          
          var tds = jQuery(this).find('td');
          var i = 0;
          tds.each(function() {
            if (i==0){var ctl=jQuery('.AttendeeFirstName'); ctl.val(jQuery(this).text())};
            if (i==1){var ctl=jQuery('.AttendeeLastName'); ctl.val(jQuery(this).text())};
            if (i==2){var ctl=jQuery('.AttendeePhone'); ctl.val(jQuery(this).text())};
            if (i==3){var ctl=jQuery('.AttendeeEmail'); ctl.val(jQuery(this).text())};
            if (i==4){var ctl=jQuery('.AttendeeFax'); ctl.val(jQuery(this).text())};
            if (i==5){var ctl=jQuery('.AttendeeCompany'); ctl.val(jQuery(this).text())};
            if (i==6){var ctl=jQuery('.AttendeeAddress'); ctl.val(jQuery(this).text())};           
            i = i+1;
            })
         
   });    

}
