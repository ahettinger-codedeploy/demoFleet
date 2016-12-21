/**
 * This is the main JS file. It initializes some plugins and contains the functionality
 * for the send email form.
 * 
 * Author: Pexeto
 * http://pexeto.com/
 */

var searchClicked=false;

var nullNameError="Please insert your name";
var nullEmailError="Please insert your email";
var nullQuestionError="Please insert your question";
var invalidEmailError="Please insert a valid email address";

var urlToPhp = "http://yourdomain/sendEmail.php";

var valid=true;

$(function(){
	//$('ul#menuUl').superfish();
	$('ul.sf-menu').superfish();
	
 	Cufon.replace('h1');
	Cufon.replace('h2');
	Cufon.replace('h3');
	Cufon.replace('caption');
		
	setSearchInputClickHandler();
	validateSendEmailForm();

//	positionUlChildren();
	
	$("a[rel^='prettyPhoto']").prettyPhoto({
		theme: 'light_rounded' /* light_rounded / dark_rounded / light_square / dark_square */
	});
	
	setInfo();
	
});

/**
 *	Removes the text in the search text box when clicked on it.
 */
function setSearchInputClickHandler(){
	$("#searchInput").click(function(){
		if(searchClicked==false){
			this.value='';
			searchClicked=true;
		}
	});
}

/**
 *	Validates the send email form.
 */
function validateSendEmailForm(){
    $("#sendButton").click(function(){
    
		
		//clear previous messages
		$("#nameError").hide();
		$("#emailError").hide();
		$("#questionError").hide();
		valid=true;  
		
		//verify whether the name text box is empty
		if(document.getElementById("nameTextBox").value=="" || document.getElementById("nameTextBox").value==null){
			$("#nameError").show();
			valid=false;
		}

		//verify whether the question text area is empty
		if(document.getElementById("questionTextArea").value=="" || document.getElementById("questionTextArea").value==null){
			$("#questionError").show();
			valid=false;
		}
		
		//verify whether the inserted email address is valid
		var email = document.getElementById("emailTextBox").value;
		if(!isValidEmailAddress(email)) {
			$("#emailError").show();
			valid=false;
		}
		
		//verify whether the email text box is empty
		if(document.getElementById("emailTextBox").value=="" || document.getElementById("emailTextBox").value==null){
			$("#emailError").show();
			valid=false;
		}
		
		
		
		var name=document.getElementById("nameTextBox").value;
		var question=document.getElementById("questionTextArea").value;

		//if the inserted data is valid, then sumbit the form
		if(valid==true){
			urlToPhp=document.getElementById("url").value;
			var emailToSend=document.getElementById("emailToSend").value;
			
			var dataString = 'name='+ name + '&question=' + question + '&email=' + email + '&emailToSend=' + emailToSend;    

			$.ajax({  
				type: "POST",  
				url: urlToPhp,  
				data: dataString,  
				success: function() {  
				$("label#message").show();
				$("label#message").append("<br/><br/>");
				$("#submitForm").each(function(){
					this.reset();
				});
				}
			}); 
		}
    });
}

/**
 *	Positions the dropdown children of the menu.
 */
function positionUlChildren(){
	$("#menu ul li").each(function(i){
		var childUl=$(this).find("ul");
		var left=$(this).find("a").offset().left-$("#menu").offset().left;
		childUl.css({left:left});
		
		
		childUl.hover(function(){
			$(this).parent("li").find("a").addClass("selected");
		},function(){
			$(this).parent("li").find("a").removeClass("selected");
		});
	});
	
	$("#menu ul li ul li").each(function(i){
		var childUl=$(this).find("ul");
		var left=$(this).find("a").offset().left-$("#menu").offset().left+327;
		var top=$(this).offset().top;
		
		childUl.css({left:left});
	});
	
}

function setInfo(){
	$("#portfolio div.portfolioItem").hover(function(){
		var info=$(this).find("div.portfolioItemInfo");	
		info.stop().animate({bottom:"4px"}, 500);
	},
	function(){
		var info=$(this).find("div.portfolioItemInfo");
		info.stop().animate({bottom:"-85px"}, 500);
	});
}

function isValidEmailAddress(emailAddress) {
	var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
	return pattern.test(emailAddress);
}
