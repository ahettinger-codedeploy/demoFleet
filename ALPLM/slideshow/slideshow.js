								//configure the paths of the images, plus corresponding target links
											slideshowimages( "/clients/alplm/slideshow/civilwar.gif", "/clients/alplm/slideshow/magicaladventure.jpg","/clients/alplm/slideshow/RRS_HomePageBanner.jpg","/clients/alplm/slideshow/veteransday.jpg","/clients/alplm/slideshow/wdyr.jpg")

											//configure the speed of the slideshow, in miliseconds
											var slideshowspeed = 10000

											var whichlink = 0
											var whichimage = 0

											function slideit() {
												if (!document.images)
													return
												document.images.slide.src = slideimages[whichimage].src
												whichlink = whichimage
												if (whichimage < slideimages.length - 1)
												whichimage++
													else
														whichimage = 0
												setTimeout("slideit()", slideshowspeed)
											}
													slideit()