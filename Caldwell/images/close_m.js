function CloseM(theId)
{

var z =8;

var activeA = new Array();

var mnues = new Array();

mnues[0]= document.getElementById("megamenu1");
mnues[1]= document.getElementById("megamenu2");
mnues[2]= document.getElementById("megamenu3");
mnues[3]= document.getElementById("megamenu4");
mnues[4]= document.getElementById("megamenu5");
mnues[5]= document.getElementById("megamenu6");
mnues[6]= document.getElementById("megamenu7");

 aObj = document.getElementById('main_menu').getElementsByTagName('a');
  for(i=0;i<aObj.length;i++)
  {
  activeA.push(aObj[i]); 
  }


	if(theId=="contentContainer")
	shide();
	
	else
	{
	
		if (theId=="megaanchor" && mnues[0].style.display=="none")
		{
		z=0;
		shide();
		
		return;
		}
		
		if (theId=="megaanchor2" && mnues[1].style.display=="none")
				{
		z=1;
		shide();
		return;
		}
		if (theId=="megaanchor3" && mnues[2].style.display=="none")
				{
		z=2;
		shide();
		return;
		}

		if (theId=="megaanchor4" && mnues[3].style.display=="none")
				{
		z=3;
		shide();
		return;
		}
		
		if (theId=="megaanchor5" && mnues[4].style.display=="none")
			{
		z=4;
		shide();
		return;
		}
		
		if (theId=="megaanchor6" && mnues[5].style.display=="none")
				{
		z=5;
		shide();
		return;
		}
		
		/*  if (theId=="megaanchor7" && mnues[6].style.display=="none")
				{
		z=6;
		shide();
		return;
		}*/

	}

	
	function shide()
	{
	/*  if(mnues[5].style.display=="block")
	{
	document.getElementById("sports_vid").src="";
	document.getElementById("sports_vid").src="http://www.youtube.com/embed/i3jmeIKQQVM?rel=0";
	}*/
	
		for (i=0;i<6;i++)
		{	
			if( i != z)
			mnues[i].style.display="none";		
			
		}
		
		
		 for (i=0;i<6;i++)
		{	
			
			activeA[i].style.color="#FFFFFF";
		
			
		}
		
		document.getElementById("outlineiframeshim").style.display="none";
		


     }
     
     
}
