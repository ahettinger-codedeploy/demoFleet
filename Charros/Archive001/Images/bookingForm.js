function validateBookingForm(){
	
	var name = document.getElementById('name');
	var email = document.getElementById('email');
	var phone = document.getElementById('phone');
		
	if( name.value.length < 1 ){
		alert('Name is a required field.');
		return false;
	}
	
	if( email.value.length < 1 ){
		alert('E-Mail is a required field.');
		return false;
	}
	
	if( phone.value.length < 1 ){
		alert('Phone is a required field.');
		return false;
	}
	
	return true;
	
}

function popImage(width, height, img){
	
	window.open(img, "Banner Layout", 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=820,height=260');
	
}