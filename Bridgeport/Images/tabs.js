
//$( document ).ready(function() {
    
	$("#tab0").click(function() {
	if(!$("#ungradList").is(":visible"))
	{//disable all;
	 $("#gradList").hide();
	actOff('tab1');

	//show clicked
	$("#ungradList").show();
	actOn('tab0');
	}
});

$("#tab1").click(function() {
	//alert('hi');
	if(!$("#gradList").is(":visible"))
	{//disable all;
	 $("#ungradList").hide();
	actOff('tab0');

	//show clicked
	$("#gradList").show();
	actOn('tab1');
	}
});
	
$("#ungradAlpha").click(function() {
	//alert('hi');
	if(!$("#ungradProgramListing").is(":visible"))
	{//disable all;
	 $("#ungradSchoolListing").hide();
	actOff('ungradbySchool');

	//show clicked
	$("#ungradProgramListing").show();
	actOn('ungradAlpha');
	}
});

$("#ungradbySchool").click(function() {
	//alert('hi');
	if(!$("#ungradSchoolListing").is(":visible"))
	{//disable all;
	 $("#ungradProgramListing").hide();
	actOff('ungradAlpha');

	//show clicked
	$("#ungradSchoolListing").show();
	actOn('ungradbySchool');
	}
});

$("#gradAlpha").click(function() {
	//alert('hi');
	if(!$("#gradProgramListing").is(":visible"))
	{//disable all;
	 $("#gradSchoolListing").hide();
	actOff('ungradbySchool');

	//show clicked
	$("#gradProgramListing").show();
	actOn('gradAlpha');
	}
});

$("#gradbySchool").click(function() {
	//alert('hi');
	if(!$("#gradSchoolListing").is(":visible"))
	{//disable all;
	 $("#gradProgramListing").hide();
	actOff('gradAlpha');

	//show clicked
	$("#gradSchoolListing").show();
	actOn('gradbySchool');
	}
});
	
//});

function actOn($v) {
node = document.getElementById($v);
 if (!$(node).hasClass("active")) {
    $(node).addClass("active")   
 }
}
function actOff($v) {
node = document.getElementById($v);
 if ($(node).hasClass("active")) {
    $(node).removeClass("active")   
 }
}