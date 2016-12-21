	//-- ##################################################################
//-- Contents of this file are copyright 2006 Dell Inc
//-- ##################################################################

var monBlock	= null;
var monImg		= null;
var monIdx		= 0;
var monContainer= null;
var monTimeout	= 7000;
var monEffect	= 2;
var monHref;
var monSrc;
var monCaption;

function montage( href, src, caption, width, height, animate )
{
	if( monBlock )
	{
		return;
	}
		
	monHref		= href;
	monSrc		= src;
	monCaption	= caption;
	
	// this is the case for browsers that don't support filters...
	var cycle	= Math.floor( Math.random() * href.length );

	// switch off animation if we're not on broadband
	var m_montage	= ( typeof(animate) != "undefined" ? animate : hasBroadband() );				
	if( m_montage == false || src.length <= 1 || !isDHTML )
	{
		document.writeln( montagePicker( cycle ) );
		return;
	}
	
	// go build all of the nested DIVs out
	monIdx		= cycle;
	
	var nextImage	= (monIdx + 1) % src.length;

	if( height > 0 ) { document.writeln( "<div id=\"container\" style=\"width:" + width +"px;height:" + height + "px\">" ); }
	else { document.writeln( "<div id=\"container\" style=\"width:" + width +"px\">" ); }

	for( i = 0; i < src.length; i++ )
	{
		// set up a placeholder
		document.write( "<div id=\"montage" + i + "\" style=\"display:none\">" );
		
		if( i == nextImage )
		{
			// only prefetch the first image we will display
			document.write( montagePicker( i ) );
		}
		
		document.write( "</div>" );
	}

	document.writeln( "</div>" );

	// pull the images out
	monBlock	= new Array( src.length );
	monImg		= new Array( src.length );

	for( i = 0; i < src.length; i++ )
	{
		monBlock[i]	= document.getElementById( "montage" + i );
		
		if( i == nextImage )
		{
			monImg[i] = document.getElementById( "monimg" + i );
		}
		else
		{
			monImg[i] = null;
		}
	}

	monContainer = document.getElementById("container");
	
	montageEffects();
}

function montageEffects()
{
	var nextImage	= (monIdx + 1) % monImg.length;
	
	// run the transition	
	if( readIEVer() >= 4.0 && monEffect > 0 )
	{
		try
		{
			if( monEffect == 1 )
			{
				monContainer.style.filter = "blendTrans(duration=0.6)";
				monContainer.filters(0).apply();
 				montageSelect( nextImage );
				monContainer.filters(0).play();
			}
			else
			{
				monContainer.style.filter = "blendTrans(duration=1.5) revealTrans(duration=1.0,transition=7)";
				monContainer.filters(0).apply();
				monContainer.filters(1).apply();
 				montageSelect( nextImage );
				monContainer.filters(0).play();
				monContainer.filters(1).play();
			}
		}
		catch( e ) { montageSelect( nextImage ); }
	}
	else
	{
		montageSelect( nextImage );
	}

	// asked to be called again a little later
	setTimeout( "montagePrep()", monTimeout - 1500 );
	setTimeout( "montageSwap()", monTimeout );
}

function montageSelect( nextImage )
{
	monBlock[monIdx].style.display = "none";
	monIdx = nextImage;
	monBlock[monIdx].style.display = "block";
}		

function montagePrep()
{
	// prefetch the next image if we don't already have it
	var nextImage	= (monIdx + 1) % monImg.length;

	if( !monImg[nextImage] )
	{
		monBlock[nextImage].innerHTML = montagePicker( nextImage );
		monImg[nextImage] = document.getElementById( "monimg" + nextImage );
	}
}

function montageSwap()
{
	if( monImg[monIdx].complete )
	{
		// move the image index along
		montageEffects();
	}
	else
	{
		// check again 3 seconds later
		setTimeout( "montageSwap()", 3000 );
	}
}

function montagePicker( cycle )
{
	var divHtml;

	if( monHref[cycle] != null ) 
	{
		divHtml = "<A href=\"" + monHref[cycle] + "\"><IMG src=\"" + monSrc[cycle] + "\" alt=\"" + monCaption[cycle] + "\" BORDER=\"0\" ID=\"monimg" + cycle + "\"></a>";
	}
	else
	{
		divHtml = "<IMG src=\"" + monSrc[cycle] + "\" ID=\"monimg" + cycle + "\">";
	}
	
	return divHtml;
}

function hasBroadband()
{
	if( readIEVer() < 5.0 )
	{
		return false;
	}
	
	try
	{
		document.body.addBehavior ("#default#clientCaps");
	
		return ( typeof(document.body.connectionType) != "undefined" && document.body.connectionType == "lan" );
	}
	catch( e )
	{
		return false;
	}
}