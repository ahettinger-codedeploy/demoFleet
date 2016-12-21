$(window).load(function () {
  GetandSetHeight();
});

$(window).on('resize', function(){
  GetandSetHeight();
}).trigger('resize');

// Get Max height and remove useless elements
function GetandSetHeight() {
  var xMax = (document.getElementById("linkList").clientHeight - 110) + "px";
  var eventsList = document.getElementById("eventList");

  eventsList.setAttribute("style", "height:" + xMax + ";");
  
  return xMax;
}