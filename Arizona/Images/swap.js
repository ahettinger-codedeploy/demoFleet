
function rollOn(id)
{
	variable = document.getElementById(id);
	if(variable == null)
	{
		document.getElementById('navLabel').innerHTML = "Explore Our Schools";
	}
	else if(id == 'Theatre_Arts')
	{
		document.getElementById('navLabel').innerHTML = "School of Theatre Arts";
	}
	else if(id == 'Media_Arts')
	{
		document.getElementById('navLabel').innerHTML = "School of Media Arts";
	}
	else {	
		document.getElementById("navLabel").innerHTML = "School of " + id;
	}
}

		
<!-- rollover images using javascript. http://www.designplace.org. -->
function swap(){
	if (document.images){
		for (var x=0; x<swap.arguments.length; x+=2) {
			document[swap.arguments[x]].src = eval(swap.arguments[x+1] + ".src");
		}
	}
}