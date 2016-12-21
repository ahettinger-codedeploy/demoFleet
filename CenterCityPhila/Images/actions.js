var arrSlides;
var arrTimeouts;
var flgAllow = true;
var arrPhotoViewerSlides;
var numCurrentPhotoViewerSlide = 0;

function manualSlideshow() {
	
	arrPhotoViewerSlides = $$('div#PhotoViewer div.PhotoSlide');
	numPhotoViewerSlides = arrPhotoViewerSlides.length;
	if (numPhotoViewerSlides > 1)
	{
		arrPhotoViewerSlides.each(function(objImage, numIndex)
		{
			if (numIndex == 0)
			{
				objImage.setProperty('id', 'Showing');
			}
			else
			{
				objImage.setStyle("display", "none");
			}		});
	}
}

function reAllow()
{
	flgAllow = true;
}

function closeIfStillOpen(a_strTabId, a_numIndex)
{
	var objTab = $(a_strTabId);
	var objSlider = $ES('.SlideDetailContainer', objTab)[0];
	
	if (objSlider.getStyle('margin-top') == '0px')
	{
		arrSlides[a_numIndex].slideOut();
	}
}

function startSlideshow(argId, numDelay) {
	
	var objImages = $$('div#' + argId + ' img.SectionImage');
	var numImages = objImages.length;
	
	if (numImages > 1)
	{
		objImages.each(function(objImage, numIndex)
		{
			objImage.setStyle("z-index", (numImages - numIndex));
		});
		
		setTimeout("SlideShow('" + argId + "', 0)", numDelay);
	}
}

function SlideShow(argId, argIndex) {
	
	var objImages = $$('div#' + argId + ' img.SectionImage');
	
	var numIndex = argIndex;
	var numImages = objImages.length;
	var objEffect = new Fx.Style(objImages[numIndex], 'opacity', 
		{
			duration: 750,
			onComplete: function()
			{
				objImages.each(function(objImage, numIndex2)
				{
					if (numIndex == numIndex2)
					{
						objImage.setStyle("z-index", 1);
						objImage.setStyle("display", "block");
						objImage.setStyle("opacity", 1);
					}
					else
					{
						objImage.setStyle("z-index", parseFloat(objImage.getStyle('z-index')) + 1);
					}
				});

				numIndex++;
				if (numIndex == numImages) 
				{
					numIndex = 0;
				}

				setTimeout("SlideShow('" + argId + "'," + numIndex + ")", 5000);
				
			}
		}).start(0);
}

window.addEvent('domready', function() 
{
	var mySelect = new elSelect( {container : 'CustomSelect'});
	var objMenu = $$('div.elSelect div.selected')[0];
	
	// add hover classes for non-anchor hover states in IE6
	objMenu.addEvent('mouseover', function(e)
	{
		objMenu.addClass('selectedHover');
	});
	
	objMenu.addEvent('mouseout', function(e)
	{
		objMenu.removeClass('selectedHover');
	});
	
	$('HeaderGoButton').addEvent('mouseover', function() 
	{
		$('HeaderGoButton').addClass('HeaderGoButtonHover');
	});
	
	$('HeaderGoButton').addEvent('mouseout', function() 
	{
		$('HeaderGoButton').removeClass('HeaderGoButtonHover');
	});
	
	$('ActionFormGoButton').addEvent('mouseover', function() 
	{
		$('ActionFormGoButton').addClass('ActionFormGoButtonHover');
	});
	
	$('ActionFormGoButton').addEvent('mouseout', function() 
	{
		$('ActionFormGoButton').removeClass('ActionFormGoButtonHover');
	});
	
	$$('div.optionsContainer div.option').each(function(objOption){
		
		objOption.addEvent('mouseover', function()
		{
			objOption.addClass('optionHover');
		});
		
		objOption.addEvent('mouseout', function()
		{
			objOption.removeClass('optionHover');
		});
		
	});
	
	// clear search field when focusing it
	$('HeaderSearchField').addEvent('focus', function()
	{
		if ($('HeaderSearchField').value == "Search our site")
		{
			$('HeaderSearchField').value = "";
		}
	});

	// reset search field if it is empty when you unfocus it
	$('HeaderSearchField').addEvent('blur', function()
	{
		if ($('HeaderSearchField').value == "")
		{
			$('HeaderSearchField').value = "Search our site";
		}
	});
	
	// initialize slideshows for homepage
	startSlideshow('BusinessColumn', 5000);
	startSlideshow('LifeColumn', 6000);
	startSlideshow('AboutUsColumn', 7000);
	
	// for landing page
	startSlideshow('ContentColumn', 5000);
	
	// for tertiary photoviewers
	manualSlideshow();
	
	if ($('LeftArrow'))
	{
		$('LeftArrow').addEvent('click', function()
		{
			var numNextPhotoViewerSlide;
			
			if (numCurrentPhotoViewerSlide == 0)
			{
				numNextPhotoViewerSlide = numPhotoViewerSlides - 1;
			}
			else
			{
				numNextPhotoViewerSlide = numCurrentPhotoViewerSlide - 1;
			}
	
			$('Showing').setStyle('display', 'none');
			$('Showing').setProperty('id', '');
			arrPhotoViewerSlides[numNextPhotoViewerSlide].setStyle('display', 'block');
			arrPhotoViewerSlides[numNextPhotoViewerSlide].setProperty('id', 'Showing');
			numCurrentPhotoViewerSlide = numNextPhotoViewerSlide;
			
			$('ExpandArrow').setProperty('href', $ES('a.hidden','Showing')[0].getProperty('href'));
		});
		
		$('RightArrow').addEvent('click', function()
		{
			var numNextPhotoViewerSlide;
			
			if (numCurrentPhotoViewerSlide == numPhotoViewerSlides - 1)
			{
				numNextPhotoViewerSlide = 0;
			}
			else
			{
				numNextPhotoViewerSlide = numCurrentPhotoViewerSlide + 1;
			}
	
			$('Showing').setStyle('display', 'none');
			$('Showing').setProperty('id', '');
			arrPhotoViewerSlides[numNextPhotoViewerSlide].setStyle('display', 'block');
			arrPhotoViewerSlides[numNextPhotoViewerSlide].setProperty('id', 'Showing');
			numCurrentPhotoViewerSlide = numNextPhotoViewerSlide;
			$('ExpandArrow').setProperty('href', $ES('a.hidden','Showing')[0].getProperty('href'));
		});
		
		$('ExpandArrow').addEvent('click', function()
		{
			// expand to lightbox
		});
	}

	// initialize variables for 'curtains'
	var arrTabs = $ES('div#ColumnContainer div.Column div.ColumnTab');
	arrSlides = new Array(arrTabs.length);
	arrTimeouts = new Array(arrTabs.length);

	arrTabs.each(function(objAbove, numIndex)
	{
		var objHeader = $ES('h3', objAbove)[0];
		var objSlider = $ES('.SlideDetailContainer', objAbove)[0];
		arrSlides[numIndex] = new Fx.Slide(objSlider, {duration: 200});
		
		arrSlides[numIndex].hide();

		objAbove.addEvent('mouseenter', function(e)
		{
			if (flgAllow)
			{
				clearTimeout(arrTimeouts[numIndex]);
				e = new Event(e);
				arrSlides[numIndex].slideIn();
				e.stop();
			}
		});
		
		objAbove.addEvent('mouseleave', function(e)
		{
			if (flgAllow)
			{
				e = new Event(e);
				arrSlides[numIndex].slideOut();
				e.stop();
	
				arrTimeouts[numIndex] = setTimeout("closeIfStillOpen('" + objAbove.getParent().id + "'," + numIndex + ")", 1000);
			}
		});
	});

});