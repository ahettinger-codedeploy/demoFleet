jQuery(document).ready(function($){

	/************************** START OF GOOGLE ANALYTICS UNIVERSAL ANALYTICS SECTION **************************/
		//BASIC PAGE CODE FUNCTION
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		var gaPagePathName=location.pathname.toLowerCase();//does not include query string  
			var gaDirectoryList=gaPagePathName.split("/");
			var gadirLevel1=gaDirectoryList[1];
		var gaPageName = gaPGPrefix+gaPagePathName;
		//NOTE gaPGPrefix is set at the site level via the visitorapi javascript files
		var gaPageFullURL=location.href.toLowerCase();  
		var gaAccountSet = 'UA-42428861-1';
		var gaReferrerSet = gaReferrer;
				var cleanRef = gaReferrer.replace(/^(https?):\/\//i,'').replace(/www./i,'');
				var pareseOutQuery = cleanRef.split("?");
				var parsedPathDirectories = pareseOutQuery[0].split("/");
				var RefDomainOnly = parsedPathDirectories[0];


		//Read GA Visitor ID cookie
		function getCookie(c_name)
			{
				var i,x,y,ARRcookies=document.cookie.split(";");
				for (i=0;i<ARRcookies.length;i++)
				{
				  x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
				  y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
				  x=x.replace(/^\s+|\s+$/g,"");
				  if (x==c_name)
					{
					return unescape(y);
					}
				}
			}			


		if($('body div.404page')[0])
			{
				gaPageName = '404 error: '+gaPageName;
			} else if ($('body.500')[0])
			{
				gaPageName = '500 error: '+gaPageName;
			} 

		//Set the Content Grouping variables 
		var gaContent='';

		if($('body').attr("data-track-page-category")) 
			{gaContent=$('body').attr("data-track-page-category");				
			} else if (gadirLevel1=='events')
			{gaContent='events';
			} else if (gadirLevel1=='blog'||gadirLevel1=='blog_old')
			{gaContent='blog';
			} else if (gadirLevel1=='partner')
			{gaContent='member detail';
			} else if (typeof(gaMicroSite) != 'undefined' && gaMicroSite != null)
			{gaContent = gaMicroSite;}

				
		//SEND THE GA PAGE VIEW EVENT WITH SEVERAL CUSTOM AND DYNAMIC VARIABLES 
		if (typeof(gaDomain) != 'undefined' && gaDomain != null)
			{
				var gaDomainSet = gaDomain;

				ga('create',gaAccountSet,gaDomainSet,{'allowLinker': true});
				ga('require', 'linker');
				ga('linker:autoLink', ['atlanta.net', 'iamatl.net','atlfiles.com','bronzelensfilmfestival.com','atlantameetings.com']);
				if(typeof(gaContent) != 'undefined' && gaContent != null)
					{
						ga('set', 'contentGroup2', gaContent); 				
					}else if(typeof(gaContent) != 'undefined' && gaContent != null)
					{
						ga('set', 'contentGroup2', 'unspecified');
					}

				if (gaPageName=='/misc/thanks-for-registering/')
					{
						ga('send', 'pageview',
								{
									'page': gaPageName,
									'dimension1':  gaPageFullURL,
									'dimension2':  gaReferrer,		
									'dimension3':  RefDomainOnly,		
									'dimension4':  getCookie('_ga'),
									'metric1': 1
									
								});
					} else
					{
						ga('send', 'pageview',
								{
									'page': gaPageName,
									'dimension1':  gaPageFullURL,
									'dimension2':  gaReferrer,		
									'dimension3':  RefDomainOnly,		
									'dimension4':  getCookie('_ga')
								});		
					} 
					
			}

			
			//try{console.log('Tracking ga referral full '+gaReferrer)}catch(err){};
			//try{console.log('Tracking ga referral domain only '+RefDomainOnly)}catch(err){};

			
	/************************** END OF GOOGLE ANALYTICS UNIVERSAL ANALYTICS SECTION **************************/
});


s = new AppMeasurement()

if (typeof(omniAccount) != 'undefined' && omniAccount != null)
	{
		s.account=omniAccount;
	} else {
		s.account="usdmatlantaglobal";
	}

s.visitorNamespace = "usdm"
//try{console.log('TRACKING::: app code load ')}catch(err){}
/******** VISITOR ID SERVICE CONFIG - REQUIRES VisitorAPI.js ********/
s.visitor = Visitor.getInstance("usdm") // same as s.VisitorNamespace
var isPageLoad="true"


/************************** CONFIG SECTION **************************/
/* You may add or alter any code config here. */
/* Link Tracking Config */
s.trackDownloadLinks=false
s.trackExternalLinks=false
s.trackInlineStats=true
s.linkDownloadFileTypes="exe,zip,wav,mp3,mov,mpg,avi,wmv,pdf,doc,docx,xls,xlsx,ppt,pptx"
s.linkInternalFilters="javascript: atlanta.net,acvb.com,acvbfoundation.com,attend.atlanta.com,blffa.com,secure.atlanta.net,adtechus.com,usdmdev.net,usdm.net,iamatl.net,atlfiles.com,bronzelensfilmfestival.com,bronzelens.com,atlantameetings.com,tel:8772852682,tel:4045216600"
s.linkLeaveQueryString=false
s.linkTrackVars="None"
s.linkTrackEvents="None"
var pagePathName=location.pathname.toLowerCase();//does not include query string
	/* Defines the file name and the first directory level*/
	var DirectoryList=pagePathName.split("/");
	var dirLevel1=DirectoryList[1];
	var dirLevel2=DirectoryList[2];


/************************ ADDITIONAL FEATURES *************************/

		var optsStatic=new Array();
		
	/* Google Plus*/
		function trackgplus(data){
			if(data.state=="on"){
					optsStatic.clickName="social: click to share: google plus: share";
					optsStatic.eventsList="event8";
					OmniClickStatic(optsStatic);
			};
		}

		
		function OmniClickStatic(optsStatic){
		s.linkTrackVars = 'eVar14,events,prop14';
		s.linkTrackEvents = optsStatic.eventsList;
		s.events= optsStatic.eventsList;
		s.eVar14 = optsStatic.clickName;
		s.prop14 = 'customlinks: '+optsStatic.clickName;
		s.tl(this, 'o', optsStatic.clickName);	
		}

/************************ DO PLUGINS ************************

/* uncomment below to use doPlugins */
s.usePlugins=true
function s_doPlugins(s) {

	/* Defines the file name and the first directory level*/
	//var DirectoryList=pagePathName.split("/");
	//var dirLevel1=DirectoryList[1];
	//var dirLevel2=DirectoryList[2];
	
	/* Page Name to Path only */
	if(!s.pageName) 
		{
			if(microSite=='main')
				{
					s.pageName=pagePathName;
				}
			else if(microSite=='atlfiles')
				{
					s.pageName='/atlfiles'+pagePathName;
					s.prop36=s.eVar36 ='atl files';
				}
			else if(microSite=='iamatl')
				{
					s.pageName='/iamatl'+pagePathName;
					s.prop36=s.eVar36 ='iamatl';
				}
			else if(microSite=='bronzelens')
				{
					s.pageName='/bronzelens'+pagePathName;
					s.prop36=s.eVar36 ='bronze lens';
				}
			else if(microSite=='meetings')
				{
					if(dirLevel1=='meetings')
					{
						s.pageName=pagePathName;
						s.prop36=s.eVar36 ='meeting planner';
					} else
					{
						s.pageName='/meetings'+pagePathName;
						s.prop36=s.eVar36 ='meeting planner';
					}
				}
			else if(microSite=='conference')
				{
					s.pageName='/conference'+pagePathName;
					s.prop36=s.eVar36 ='conference sites';
					s.prop39=s.eVar39=dirLevel1;
				}
			else if(microSite=='conference-attend')
				{
					s.pageName='/conference/attend'+pagePathName;
					s.prop36=s.eVar36 ='conference sites';
					s.prop39='attend';
				}
			else if(microSite=='media-room')
				{
					s.pageName='/media-room'+pagePathName;
				}
			else if(microSite=='mobile')
				{
					s.pageName='/mobile'+pagePathName;
					s.prop36=s.eVar36 ='mobile';
				}
		} else {};


	/* Set Page View Event */
	if(isPageLoad='true'){
					s.events=s.apl(s.events,'event2',',',2);
					isPageLoad='false'
					}


	/* Copies Page Name or URL to eVar conversion variable */
	if(s.eVar8==null) 
		{ 
		if(!s.pageName) {s.eVar8="D=g"}//includes query string
		else {s.eVar8="D=pageName"}
		}

	/* URL to prop48 to include query string */
	s.prop48='D=g';//includes query string	
	
	/* Set server variable to domain name */
	s.server=location.hostname.toLowerCase();	

	if(s.server=="atlanta.usdmdev.net")
	{
	s.abort = true;
	}
	
	/* Call to the getVisitStart v2.0 plugin which returns 1 on first page of visit otherwise 0 */
	s.prop8=s.getVisitStart("s_visit");
	if (s.prop8=="1"){
		s.eVar16="1";
		s.events=s.apl(s.events,'event7',',',2);
		}else{};


	/* Percent of Page Viewed */
		s.prop4=s.getPreviousValue(s.pageName,"s_pv");
		if (s.prop4){
			s.prop5=s.getPercentPageViewed();
		}

	/* Set Page Load Time */ 
		s.prop10=s_getLoadTime();
		s.events=s.apl(s.events,'event18',',',2);
		s.products=";;;;event18="+s.prop10;
		
	/* External Campaign Referral Tracking */
	if(!s.campaign){
		s.campaign = s.Util.getQueryParam("ucid");
		s.campaign = s.getValOnce(s.campaign,'s_campaign',0)
	}

	/* Event pathing */
	if(!s.prop14)
	{	if(!s.pageName) {
			if(s.campaign) 
				{s.prop14=s.campaign+ ':: ' +s.pageURL}
				else{s.prop14=s.pageURL} 
		} else if (s.pageName) {  
			if(s.campaign)  
				{s.prop14=s.campaign+ ':: ' +s.pageName}
				else{s.prop14=s.pageName}
		}
	}
	
	/* Site Search */
	if(!s.prop7 && pagePathName=="/search/")
		{
			s.prop7 = s.Util.getQueryParam("q");
			s.prop7 = s.prop7.toLowerCase();
			s.prop7 = s.getValOnce(s.prop7,'s_prop7',0);
			s.eVar7=s.prop7;
			var t_search=s.getValOnce(s.eVar7,'ev7',0);
			if(t_search)
				{
				   s.events=s.apl(s.events,"event1",",",2);
				   /* uncomment the next line if merchandising the search term */
				   //s.products=s.apl(s.products,";",",",2);
				}
		}

	/* Set Time Parting Variables set to Central Standard Time aka -6*/
	var theDate=new Date()
	var currentYear=(theDate.getFullYear())
	s.prop11=s.eVar11=s.getTimeParting('h','-6',currentYear); // Set hour 
	s.prop12=s.eVar12=s.getTimeParting('d','-6',currentYear); // Set day
	s.prop13=s.eVar13=s.getTimeParting('w','-6',currentYear); // Set Weekend / Weekday

	/* Site Section & SubSections and Content Type Copy props to eVars */
	if(s.channel&&!s.eVar9) s.eVar9=s.channel;//site section & channel
	if(s.prop1&&!s.eVar1) s.eVar1=s.prop1;//sub section 1
	if(s.prop2&&!s.eVar2) s.eVar2=s.prop2;//sub section 2
	if(s.prop3&&!s.eVar3) s.eVar3=s.prop3;//sub section 3
	if(s.prop6&&!s.eVar6) s.eVar6=s.prop6;//content type

	/* Sets visitor id to sprop & evar */
	s.prop56=s.eVar56="D=s_vi"	

	
	if(pagePathName=="/misc/thanks-for-registering/")
	{
			s.events=s.apl(s.events,'event3',',',2);
	}
	
}
s.doPlugins=s_doPlugins 



//Click tracking 
	jQuery(document).ready(function($){

		pageTracking();


		
		function pageTracking()
		{
			if($('body div.404page')[0])
				{
					s.pageType="errorPage";
					s.pageName="404 error: "+location.href.toLowerCase();	
				} else if ($('body.500')[0])
				{
					s.pageType="errorPage";
					s.pageName="500 error: "+location.href.toLowerCase();	
				} 			

			if($('body').attr("data-track-page-category")) 
				{
					s.prop36=s.eVar36=$('body').attr("data-track-page-category");
				} else if (dirLevel1=='events')
				{	
					s.prop36=s.eVar36='events';
				} else if (dirLevel1=='blog'||dirLevel1=='blog_old')
				{	
					s.prop36=s.eVar36='blog';
				} else if (dirLevel1=='partner')
				{	
					s.prop36=s.eVar36='member detail';
				}
										
			var s_code=s.t();
				if(s_code)
				{
					$('body').append(s_code);
				}
		}
		
	
	
		//click tracking function base
		var opts=new Array();
		var pagePathName1=location.pathname.toLowerCase();//does not include query string
		
		function OmniClickOpts($clickedLink,opts){
			var eventList = "event5";
				if 	(opts.eventList != null && opts.eventList)
				{
					eventList = opts.eventList;
				}
			s.linkTrackVars = 'eVar14,events,prop14';
			s.linkTrackEvents = eventList;
			s.events= eventList;
			s.eVar14 = opts.linkCLICKNAME;
			s.prop14 = 'customlinks: '+opts.linkCLICKNAME;
			s.tl($clickedLink, 'o', opts.linkURL);
			s.clearVars();
			opts.eventList=eventList="" ;
		}
		
		
		//Home page click areas tracking
		if(pagePathName=='/'||pagePathName=='/test/page.html'||$('body').hasClass("data-track-homepage"))
		{
				//Home Page top nav
				$('[data-track-hp="top nav"] a, div#siteSearch input[type="submit"],a#logo').not('div#shareThis a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: top navigation';
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: top navigation');
					});
				
				//Home Page large header slider
				//$('div#homeSlider a.learnMore').click(function(){
				$('[data-track-hp="header slider"] a.learnMore').click(function(){
					var sliderTitle=$(this).closest('div.sliderCopy').find('span:first').text().toLowerCase();
					opts.linkCLICKNAME = opts.linkURL = 'home page: header slider: '+sliderTitle;
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: header slider: '+sliderTitle);
					});

				//Home Page quick links slider in header
				//$('div.secondarySlider.block-carousel a.learnMore').click(function(){
				$('[data-track-hp="promo slider"].secondarySlider.block-carousel a.learnMore').click(function(){
					var sliderTitle=$(this).closest('div.secondarySliderCopy').find('h2').html().toLowerCase();
					opts.linkCLICKNAME = opts.linkURL = 'home page: quick links slider: '+sliderTitle;
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: quick links slider: '+sliderTitle);
					});				
		
				//Home Page Welcome to Atlanta
				$('[data-track-hp="welcome"] a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: welcome to atlanta content block';
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: welcome to atlanta content block');
				});	
				
				//Home Page search hotels
				$('[data-track-hp="hotel widget"] a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: find a hotel search submit';
					opts.eventList="event9" 
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: find a hotel search submit');
					});

				//Home Page City Pass Content Block
				$('[data-track-hp="city pass"] a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: citypass content block';
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: citypass content block');
				});
				
				//Home Page Atlanta Now
				$('[data-track-hp="atlanta now"] a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: atlanta now guide: view online';
					opts.eventList="event30" 
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: atlanta now guide: view online');
				});

				//Home Page Event Listing
				$('[data-track-hp="events"] a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: events listing content block';
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: events listing content block');
				});				

					
				//Home Page secondary slider at bottom
				//$('div.secondarySlider.normal-carousel a.learnMore').click(function(){
				$('[data-track-hp="promo slider"].secondarySlider.normal-carousel a.learnMore').click(function(){
					var sliderTitle=$(this).closest('div.secondarySliderCopy').find('h2').html().toLowerCase();
					opts.linkCLICKNAME = opts.linkURL = 'home page: promo slider: '+sliderTitle+": "+$(this).attr('href');
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: promo slider: '+sliderTitle+": "+$(this).attr('href'));
				});	

				//Home Page Blog Listing
				$('[data-track-hp="blog"] a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: blog listings content block';
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: blog listings content block');
				});			
			
				//Home Page Footer
				//$('[data-track-hp="footer"] a').not('li.atlanta-citypass a').click(function(){
				$('[data-track-hp="footer"] a').click(function(){
					opts.linkCLICKNAME = opts.linkURL = 'home page: footer navigation';
					OmniClickOpts($(this),opts);
					ga('send', 'event','home page activity','home page: footer navigation');
				});	
		}

		//Exit Links:: settings for customized default exit link tracking
		var isInternal = new RegExp("(javascript:)|(atlanta.net)|(acvb.com)|(acvbfoundation.com)|(attend.atlanta.com)|(blffa.com)|(myatlanta.com)|(secure.atlanta.net)|(adtechus.com)|(iamatl.net)|(atlfiles.com)|(bronzelensfilmfestival.com)|(bronzelens.com)|(atlantameetings.com)|(tel:8772852682)|(tel:4045216600)|(usdm.net)|(usdmdev.net)|(atlanta.usdmdev.net)|(plus.google.com)|(twitter.com)|(facebook.com)|(youtube.com)|(instagram.com)|(flickr)|(feeds.feedburner.com)|(pinterest.com)|(epaperflip.com)|(yourtour.com)|(googleapis.com)|(atlantameetings.net)", "i");	
		//googleapis.com is listed due to the youtube api running on the atlfiles site which is counting as a click to play on each load of home page on that site
		
		//Exit Links:: execute exit link tracking for links that are not already being tracked
		$('a').not('a[data-track-mem-id], [data-track-hp="atlanta now"] a, li.atlanta-citypass a, a[data-avid], a[data-track-camp-link-type]').click(function(){
				var linkHREF = $(this).prop('href');
				linkHREF = linkHREF.replace(/^(https?):\/\//i,'').replace(/www./i,'');
				var parsedHREFQ = linkHREF.split("?");
				var parsedHREFH = parsedHREFQ[0].split("/");
				var domOnly = parsedHREFH[0];
				var testresult = isInternal.test(domOnly);
				if (!isInternal.test(domOnly)) 
					{
						s.clearVars();
						s.tl(this, 'e', linkHREF);
						ga('send', 'event','exit links',linkHREF);
						try {console.log("Tracking::: exit link tracking fired ")}catch(err){};
		//Exit Links:: Online Guide Viewer
					} else if (domOnly=="epaperflip.com"||domOnly=="viewer.epaperflip.com"||domOnly=="www.epaperflip.com")
					{
						opts.linkCLICKNAME = 'guide: view online';
						opts.linkURL = $(this).attr('href');
						opts.eventList="event30"
						OmniClickOpts($(this),opts);
						ga('send', 'event','travel planner','guide: view online',{'metric6':1});
		//Exit Links:: Your Tour
					} else if (domOnly=="yourtour.com"||domOnly=="www.yourtour.com")
					{
						opts.linkCLICKNAME = opts.linkURL = 'yourtour exit link';
						opts.eventList="event5";
						OmniClickOpts($(this),opts);
						ga('send', 'event','yourtour','yourtour exit link');
					}		
		});
			
		
		//Member link tracking
		$('a[data-track-mem-id]').click(function(){
				var memPage=$(this).closest('[data-track-mem-page]').attr('data-track-mem-page');
				memPage = memPage.replace(/_/g, ' ');

				var memLinkType=$(this).attr('data-track-mem-type');
				var memID=$(this).attr('data-track-mem-id');
				var memURL=$(this).attr('href');

			
				var vlinkCLICKNAME = opts.linkURL = 'mem: '+memPage+": "+memLinkType+": "+memID+": "+memURL.substr(0,100);
				opts.linkCLICKNAME = vlinkCLICKNAME.toLowerCase();
				opts.eventList="event74"
				OmniClickOpts($(this),opts);
				ga('send', 'event','member link clicks','mem: '+memPage+": "+memLinkType+": "+memID+": "+memURL.substr(0,100),{'metric4':1});
		});	

		//Campaign Member link tracking or tracking of links that have avid values assigned in the link
		$('a[data-avid]').click(function(){
			var avidAttr = $(this).attr('data-avid');
			if (avidAttr !== '')
				{
					var memID=$(this).attr('data-avid');
					var campPage=campName;
					campPage = campPage.replace(/_/g, ' ');

					var memLinkType='visit website';
					var memURL=$(this).attr('href');

					var vlinkCLICKNAME = opts.linkURL = 'mem: '+campPage+": "+memLinkType+": "+memID+": "+memURL.substr(0,100);
					opts.linkCLICKNAME = vlinkCLICKNAME.toLowerCase();
					opts.eventList="event74"
					OmniClickOpts($(this),opts);	
					ga('send', 'event','member link clicks','mem: '+campPage+": "+memLinkType+": "+memID+": "+memURL.substr(0,100),{'metric4':1});
				} else if (avidAttr =='')
				{
					var campPage=campName;
					var campURL=$(this).attr('href').toLowerCase();
					try{console.log('TRACKING::: href '+campURL)}catch(err){}
					var strBlog = "http://www.atlanta.net/blog/"
					try{console.log('TRACKING::: href '+campURL.indexOf(strBlog))}catch(err){}
					if(campURL.indexOf(strBlog) == 0)
						{
							var campLinkType='click to blog post';
						} else 
						{
							var campLinkType='click to internal page';
						} 						
						
					var vlinkCLICKNAME = opts.linkURL = campPage+": "+campLinkType+": "+campURL.substr(0,100);
					opts.linkCLICKNAME = vlinkCLICKNAME.toLowerCase();
					opts.eventList="event5"
					OmniClickOpts($(this),opts);				
					ga('send', 'event','media - '+campPage,campPage+": "+campLinkType+": "+campURL.substr(0,100));
				}
		});	
		
		//Campaing tracking of links without avid values assigned in the link
		$('a[data-track-camp-link-type]').click(function(){

			var campPage=campName;
			var campLinkType=$(this).attr('data-track-camp-link-type');
			var campURL=$(this).attr('href');
		
			var vlinkCLICKNAME = opts.linkURL = campPage+": "+campLinkType+": "+campURL.substr(0,100);
			opts.linkCLICKNAME = vlinkCLICKNAME.toLowerCase();
			opts.eventList="event5"
			OmniClickOpts($(this),opts)
			ga('send', 'event','media - '+campPage,campPage+": "+campLinkType+": "+campURL.substr(0,100));
		});						
					




		
			
		//CityPass in Footer
		$('li.atlanta-citypass a').click(function(){
				try {console.log("Tracking::: citypass link in footer tracking fired ")}catch(err){};
				opts.linkCLICKNAME = opts.linkURL = 'mem: site content: visit website: 00055932: '+$(this).attr('href');
				opts.eventList="event74"
				OmniClickOpts($(this),opts);
				ga('send', 'event','member link clicks','mem: site content: visit website: 00055932: '+$(this).attr('href'),{'metric4':1});
		});


		//Social Exit link tracking
		$('div#footerSocial a, div#headerSocialDropdown a').click(function(){
				var socialName=$(this).attr('class');
				opts.linkCLICKNAME = opts.linkURL = 'social: exit to profile: '+ socialName.replace('social','').toLowerCase()+': '+$(this).attr('href');
				opts.eventList="event19"
				OmniClickOpts($(this),opts);
				ga('send', 'event','social exits','social: exit to profile: '+ socialName.replace('social','').toLowerCase()+': '+$(this).attr('href'),{'metric2':1});
		});
		
	
	
	});
	


	jQuery(window).load(function(){
		var optsLoad = new Array();
		
		//click tracking function base
		function OmniClickOptsL(optsLoad){
		s.linkTrackVars = 'eVar14,events,prop14';
		s.linkTrackEvents = optsLoad.eventList;
		s.events= optsLoad.eventList;
		s.eVar14 = optsLoad.linkCLICKNAME;
		s.prop14 = 'customlinks: '+optsLoad.linkCLICKNAME;
		s.tl(this, 'o', optsLoad.linkURL);	
		}

		//Ad Model link tracking the leaderboard addresses the following slots 
		//970x90 970x450 970x  rich media top & bottom leaderboards 
		//300x250 blocks 
		//160x600 right and left rail skyscrapers
		//hotel packages

		jQuery('div[data-track-custom="ad-block"] a').click(function(){
						optsLoad.linkCLICKNAME="click on ad slot";
						optsLoad.linkURL=$(this).attr('href');
						optsLoad.eventList="event10";
						try {console.log("Tracking::: ad tech link tracking with href linkURL"+optsLoad.linkURL)}catch(err){};
						OmniClickOptsL(optsLoad);
						ga('send', 'event','ad model clicks','click on ad slot',{'metric5':1});
				});	

		jQuery('section[data-track-custom="ad-block"]').click(function(){
						optsLoad.linkCLICKNAME=optsLoad.linkURL="click on ad slot";
						optsLoad.eventList="event10";
						try {console.log("Tracking::: ad tech link tracking with href linkURL"+optsLoad.linkURL)}catch(err){};
						OmniClickOptsL(optsLoad);
						ga('send', 'event','ad model clicks','click on ad slot',{'metric5':1});
				});	

				
		if (typeof(FB) != 'undefined' && FB != null ) {
			FB.Event.subscribe('edge.create',
				function(response) {
					optsLoad.linkCLICKNAME=optsLoad.linkURL="social: click to share: facebook: like";
					optsLoad.eventList="event8";
					OmniClickOptsL(optsLoad);
					ga('send', 'social','facebook','like',response,{'metric3':1});
				}); 
		}

		if (typeof(FB) != 'undefined' && FB != null ) {
			FB.Event.subscribe('message.send',
				function(response) {
					optsLoad.linkCLICKNAME=optsLoad.linkURL="social: click to share: facebook: share";
					optsLoad.eventList="event8";
					OmniClickOptsL(optsLoad);
					ga('send', 'social','facebook','share',response,{'metric3':1});
				}); 
		}

		if (typeof(twttr) != 'undefined' && twttr != null ) {
			twttr.ready(function (twttr) {
				twttr.events.bind('tweet', function(event) {
					optsLoad.linkCLICKNAME=optsLoad.linkURL="social: click to share: twitter: tweet";
					optsLoad.eventList="event8";
					OmniClickOptsL(optsLoad);
					ga('send', 'social','twitter','tweet',s.pageName,{'metric3':1});

				});
			});
		}

			
	});

	
/* WARNING: Changing any of the below variables will cause drastic changes to how your visitor data is collected.  Changes should only be made when instructed to do so by your account manager.*/
s.trackingServer="metric.atlanta.net" //TRACKING::: should this be migrated back to 3rd party??



/************************** PLUGINS SECTION *************************/

/* s_getLoadTime v1.36 - Get page load time in units of 1/10 seconds */
function s_getLoadTime(){if(!window.s_loadT){var b=new Date().getTime(),o=window.performance?performance.timing:0,a=o?o.requestStart:window.inHeadTS||0;s_loadT=a?Math.round((b-a)/100):''}return s_loadT}

/* Plugin: getValOnce 0.2 - get a value once per session or number of days */
s.getValOnce=new Function("v","c","e",""
+"var s=this,k=s.c_r(c),a=new Date;e=e?e:0;if(v){a.setTime(a.getTime("
+")+e*86400000);s.c_w(c,v,e?a:0);}return v==k?'':v");

/* Plugin: getVisitStart v2.0 - returns 1 on first page of visit otherwise 0 */
s.getVisitStart=new Function("c",""
+"var s=this,v=1,t=new Date;t.setTime(t.getTime()+1800000);if(s.c_r(c"
+")){v=0}if(!s.c_w(c,1,t)){s.c_w(c,1,0)}if(!s.c_r(c)){v=0}return v;"); 

/* Plugin: getTimeParting 1.3 - Set timeparting values based on time zone */
s.getTimeParting=new Function("t","z","y",""
+"dc=new Date('1/1/2000');f=15;ne=8;if(dc.getDay()!=6||"
+"dc.getMonth()!=0){return'Data Not Available'}else{;z=parseInt(z);"
+"if(y=='2009'){f=8;ne=1};gmar=new Date('3/1/'+y);dsts=f-gmar.getDay("
+");gnov=new Date('11/1/'+y);dste=ne-gnov.getDay();spr=new Date('3/'"
+"+dsts+'/'+y);fl=new Date('11/'+dste+'/'+y);cd=new Date();"
+"if(cd>spr&&cd<fl){z=z+1}else{z=z};utc=cd.getTime()+(cd.getTimezoneO"
+"ffset()*60000);tz=new Date(utc + (3600000*z));thisy=tz.getFullYear("
+");var days=['Sunday','Monday','Tuesday','Wednesday','Thursday','Fr"
+"iday','Saturday'];if(thisy!=y){return'Data Not Available'}else{;thi"
+"sh=tz.getHours();thismin=tz.getMinutes();thisd=tz.getDay();var dow="
+"days[thisd];var ap='AM';var dt='Weekday';var mint='00';if(thismin>3"
+"0){mint='30'}if(thish>=12){ap='PM';thish=thish-12};if (thish==0){th"
+"ish=12};if(thisd==6||thisd==0){dt='Weekend'};var timestring=thish+'"
+":'+mint+ap;var daystring=dow;var endstring=dt;if(t=='h'){return tim"
+"estring}if(t=='d'){return daystring};if(t=='w'){return en"
+"dstring}}};"
);

/* Plugin Utility: apl v1.1 */
s.apl=new Function("l","v","d","u",""
+"var s=this,m=0;if(!l)l='';if(u){var i,n,a=s.split(l,d);for(i=0;i<a."
+"length;i++){n=a[i];m=m||(u==1?(n==v):(n.toLowerCase()==v.toLowerCas"
+"e()));}}if(!m)l=l?l+d+v:v;return l");
/* Utility Function: split v1.5 (JS 1.0 compatible) */
s.split=new Function("l","d",""
+"var i,x=0,a=new Array;while(l){i=l.indexOf(d);i=i>-1?i:l.length;a[x"
+"++]=l.substring(0,i);l=l.substring(i+d.length);}return a");
 
/* Plugin: getPercentPageViewed v1.2  */
var wid=window;
s.getPercentPageViewed=new Function("",""
+"var s=this;if(typeof(s.linkType)=='undefined'||s.linkType=='e'){var"
+" v=s.c_r('s_ppv');s.c_w('s_ppv',0);return v;}");
s.getPPVCalc=new Function("",""
+"var s=s_c_il["+s._in+"],dh=Math.max(Math.max(s.d.body.scrollHeight,"
+"s.d.documentElement.scrollHeight),Math.max(s.d.body.offsetHeight,s."
+"d.documentElement.offsetHeight),Math.max(s.d.body.clientHeight,s.d."
+"documentElement.clientHeight)),vph=wid.innerHeight||(s.d.documentE"
+"lement.clientHeight||s.d.body.clientHeight),st=wid.pageYOffset||("
+"wid.document.documentElement.scrollTop||wid.document.body.scrollTo"
+"p),vh=st+vph,pv=Math.round(vh/dh*100),cp=s.c_r('s_ppv');if(pv>100){"
+"s.c_w('s_ppv','');}else if(pv>cp){s.c_w('s_ppv',pv);}");
s.getPPVSetup=new Function("",""
+"var s=this;if(wid.addEventListener){wid.addEventListener('load',s"
+".getPPVCalc,false);wid.addEventListener('scroll',s.getPPVCalc,fals"
+"e);wid.addEventListener('resize',s.getPPVCalc,false);}else if(wid"
+".attachEvent){wid.attachEvent('onload',s.getPPVCalc);wid.attachEv"
+"ent('onscroll',s.getPPVCalc);wid.attachEvent('onresize',s.getPPVCa"
+"lc);}");
s.getPPVSetup();

/* Plugin: getPreviousValue_v1.0 - return previous value of designated variable (requires split utility) */
s.getPreviousValue=new Function("v","c","el",""
+"var s=this,t=new Date,i,j,r='';t.setTime(t.getTime()+1800000);if(el"
+"){if(s.events){i=s.split(el,',');j=s.split(s.events,',');for(x in i"
+"){for(y in j){if(i[x]==j[y]){if(s.c_r(c)) r=s.c_r(c);v?s.c_w(c,v,t)"
+":s.c_w(c,'no value',t);return r}}}}}else{if(s.c_r(c)) r=s.c_r(c);v?"
+"s.c_w(c,v,t):s.c_w(c,'no value',t);return r}"); 
 
 
/****************************** MODULES *****************************/
// copy and paste implementation modules (Media, Integrate) here
// AppMeasurement_Module_Media.js - Media Module, included in AppMeasurement zip
// AppMeasurement_Module_Integrate.js - Integrate Module, included in AppMeasurement zip



/*
 ============== DO NOT ALTER ANYTHING BELOW THIS LINE ! ===============

 AppMeasurement for JavaScript version: 1.2.4
 Copyright 1996-2013 Adobe, Inc. All Rights Reserved
 More info available at http://www.omniture.com
*/
function AppMeasurement(){var s=this;s.version="1.2.4";var w=window;if(!w.s_c_in)w.s_c_il=[],w.s_c_in=0;s._il=w.s_c_il;s._in=w.s_c_in;s._il[s._in]=s;w.s_c_in++;s._c="s_c";var k=w.hb;k||(k=null);var m=w,i,n;try{i=m.parent;for(n=m.location;i&&i.location&&n&&""+i.location!=""+n&&m.location&&""+i.location!=""+m.location&&i.location.host==n.host;)m=i,i=m.parent}catch(p){}s.Sa=function(s){try{console.log(s)}catch(a){}};s.ka=function(s){return""+parseInt(s)==""+s};s.replace=function(s,a,c){if(!s||s.indexOf(a)<
0)return s;return s.split(a).join(c)};s.escape=function(b){var a,c;if(!b)return b;b=encodeURIComponent(b);for(a=0;a<7;a++)c="+~!*()'".substring(a,a+1),b.indexOf(c)>=0&&(b=s.replace(b,c,"%"+c.charCodeAt(0).toString(16).toUpperCase()));return b};s.unescape=function(b){if(!b)return b;b=b.indexOf("+")>=0?s.replace(b,"+"," "):b;try{return decodeURIComponent(b)}catch(a){}return unescape(b)};s.Ja=function(){var b=w.location.hostname,a=s.fpCookieDomainPeriods,c;if(!a)a=s.cookieDomainPeriods;if(b&&!s.da&&
!/^[0-9.]+$/.test(b)&&(a=a?parseInt(a):2,a=a>2?a:2,c=b.lastIndexOf("."),c>=0)){for(;c>=0&&a>1;)c=b.lastIndexOf(".",c-1),a--;s.da=c>0?b.substring(c):b}return s.da};s.c_r=s.cookieRead=function(b){b=s.escape(b);var a=" "+s.d.cookie,c=a.indexOf(" "+b+"="),e=c<0?c:a.indexOf(";",c);b=c<0?"":s.unescape(a.substring(c+2+b.length,e<0?a.length:e));return b!="[[B]]"?b:""};s.c_w=s.cookieWrite=function(b,a,c){var e=s.Ja(),d=s.cookieLifetime,f;a=""+a;d=d?(""+d).toUpperCase():"";c&&d!="SESSION"&&d!="NONE"&&((f=a!=
""?parseInt(d?d:0):-60)?(c=new Date,c.setTime(c.getTime()+f*1E3)):c==1&&(c=new Date,f=c.getYear(),c.setYear(f+5+(f<1900?1900:0))));if(b&&d!="NONE")return s.d.cookie=b+"="+s.escape(a!=""?a:"[[B]]")+"; path=/;"+(c&&d!="SESSION"?" expires="+c.toGMTString()+";":"")+(e?" domain="+e+";":""),s.cookieRead(b)==a;return 0};s.D=[];s.C=function(b,a,c){if(s.ea)return 0;if(!s.maxDelay)s.maxDelay=250;var e=0,d=(new Date).getTime()+s.maxDelay,f=s.d.fb,g=["webkitvisibilitychange","visibilitychange"];if(!f)f=s.d.gb;
if(f&&f=="prerender"){if(!s.N){s.N=1;for(c=0;c<g.length;c++)s.d.addEventListener(g[c],function(){var b=s.d.fb;if(!b)b=s.d.gb;if(b=="visible")s.N=0,s.delayReady()})}e=1;d=0}else c||s.q("_d")&&(e=1);e&&(s.D.push({m:b,a:a,t:d}),s.N||setTimeout(s.delayReady,s.maxDelay));return e};s.delayReady=function(){var b=(new Date).getTime(),a=0,c;for(s.q("_d")&&(a=1);s.D.length>0;){c=s.D.shift();if(a&&!c.t&&c.t>b){s.D.unshift(c);setTimeout(s.delayReady,parseInt(s.maxDelay/2));break}s.ea=1;s[c.m].apply(s,c.a);s.ea=
0}};s.setAccount=s.sa=function(b){var a,c;if(!s.C("setAccount",arguments))if(s.account=b,s.allAccounts){a=s.allAccounts.concat(b.split(","));s.allAccounts=[];a.sort();for(c=0;c<a.length;c++)(c==0||a[c-1]!=a[c])&&s.allAccounts.push(a[c])}else s.allAccounts=b.split(",")};s.foreachVar=function(b,a){var c,e,d,f,g="";d=e="";if(s.lightProfileID)c=s.H,(g=s.lightTrackVars)&&(g=","+g+","+s.Q.join(",")+",");else{c=s.c;if(s.pe||s.linkType)if(g=s.linkTrackVars,e=s.linkTrackEvents,s.pe&&(d=s.pe.substring(0,1).toUpperCase()+
s.pe.substring(1),s[d]))g=s[d].eb,e=s[d].cb;g&&(g=","+g+","+s.z.join(",")+",");e&&g&&(g+=",events,")}a&&(a=","+a+",");for(e=0;e<c.length;e++)d=c[e],(f=s[d])&&(!g||g.indexOf(","+d+",")>=0)&&(!a||a.indexOf(","+d+",")>=0)&&b(d,f)};s.X=function(b,a,c,e,d){var f="",g,j,w,q,i=0;b=="contextData"&&(b="c");if(a){for(g in a)if(!Object.prototype[g]&&(!d||g.substring(0,d.length)==d)&&a[g]&&(!c||c.indexOf(","+(e?e+".":"")+g+",")>=0)){w=!1;if(i)for(j=0;j<i.length;j++)g.substring(0,i[j].length)==i[j]&&(w=!0);if(!w&&
(f==""&&(f+="&"+b+"."),j=a[g],d&&(g=g.substring(d.length)),g.length>0))if(w=g.indexOf("."),w>0)j=g.substring(0,w),w=(d?d:"")+j+".",i||(i=[]),i.push(w),f+=s.X(j,a,c,e,w);else if(typeof j=="boolean"&&(j=j?"true":"false"),j){if(e=="retrieveLightData"&&d.indexOf(".contextData.")<0)switch(w=g.substring(0,4),q=g.substring(4),g){case "transactionID":g="xact";break;case "channel":g="ch";break;case "campaign":g="v0";break;default:s.ka(q)&&(w=="prop"?g="c"+q:w=="eVar"?g="v"+q:w=="list"?g="l"+q:w=="hier"&&(g=
"h"+q,j=j.substring(0,255)))}f+="&"+s.escape(g)+"="+s.escape(j)}}f!=""&&(f+="&."+b)}return f};s.La=function(){var b="",a,c,e,d,f,g,j,w,i="",k="",m=c="";if(s.lightProfileID)a=s.H,(i=s.lightTrackVars)&&(i=","+i+","+s.Q.join(",")+",");else{a=s.c;if(s.pe||s.linkType)if(i=s.linkTrackVars,k=s.linkTrackEvents,s.pe&&(c=s.pe.substring(0,1).toUpperCase()+s.pe.substring(1),s[c]))i=s[c].eb,k=s[c].cb;i&&(i=","+i+","+s.z.join(",")+",");k&&(k=","+k+",",i&&(i+=",events,"));s.events2&&(m+=(m!=""?",":"")+s.events2)}for(c=
0;c<a.length;c++){d=a[c];f=s[d];e=d.substring(0,4);g=d.substring(4);!f&&d=="events"&&m&&(f=m,m="");if(f&&(!i||i.indexOf(","+d+",")>=0)){switch(d){case "timestamp":d="ts";break;case "dynamicVariablePrefix":d="D";break;case "visitorID":d="vid";break;case "marketingCloudVisitorID":d="mid";break;case "analyticsVisitorID":d="aid";break;case "audienceManagerVisitorID":d="aamid";break;case "audienceManagerLocationHint":d="aamlh";break;case "pageURL":d="g";if(f.length>255)s.pageURLRest=f.substring(255),f=
f.substring(0,255);break;case "pageURLRest":d="-g";break;case "referrer":d="r";break;case "vmk":case "visitorMigrationKey":d="vmt";break;case "visitorMigrationServer":d="vmf";s.ssl&&s.visitorMigrationServerSecure&&(f="");break;case "visitorMigrationServerSecure":d="vmf";!s.ssl&&s.visitorMigrationServer&&(f="");break;case "charSet":d="ce";break;case "visitorNamespace":d="ns";break;case "cookieDomainPeriods":d="cdp";break;case "cookieLifetime":d="cl";break;case "variableProvider":d="vvp";break;case "currencyCode":d=
"cc";break;case "channel":d="ch";break;case "transactionID":d="xact";break;case "campaign":d="v0";break;case "resolution":d="s";break;case "colorDepth":d="c";break;case "javascriptVersion":d="j";break;case "javaEnabled":d="v";break;case "cookiesEnabled":d="k";break;case "browserWidth":d="bw";break;case "browserHeight":d="bh";break;case "connectionType":d="ct";break;case "homepage":d="hp";break;case "plugins":d="p";break;case "events":m&&(f+=(f!=""?",":"")+m);if(k){g=f.split(",");f="";for(e=0;e<g.length;e++)j=
g[e],w=j.indexOf("="),w>=0&&(j=j.substring(0,w)),w=j.indexOf(":"),w>=0&&(j=j.substring(0,w)),k.indexOf(","+j+",")>=0&&(f+=(f?",":"")+g[e])}break;case "events2":f="";break;case "contextData":b+=s.X("c",s[d],i,d);f="";break;case "lightProfileID":d="mtp";break;case "lightStoreForSeconds":d="mtss";s.lightProfileID||(f="");break;case "lightIncrementBy":d="mti";s.lightProfileID||(f="");break;case "retrieveLightProfiles":d="mtsr";break;case "deleteLightProfiles":d="mtsd";break;case "retrieveLightData":s.retrieveLightProfiles&&
(b+=s.X("mts",s[d],i,d));f="";break;default:s.ka(g)&&(e=="prop"?d="c"+g:e=="eVar"?d="v"+g:e=="list"?d="l"+g:e=="hier"&&(d="h"+g,f=f.substring(0,255)))}f&&(b+="&"+d+"="+(d.substring(0,3)!="pev"?s.escape(f):f))}d=="pev3"&&s.g&&(b+=s.g)}return b};s.u=function(s){var a=s.tagName;if(""+s.pb!="undefined"||""+s.Xa!="undefined"&&(""+s.Xa).toUpperCase()!="HTML")return"";a=a&&a.toUpperCase?a.toUpperCase():"";a=="SHAPE"&&(a="");a&&((a=="INPUT"||a=="BUTTON")&&s.type&&s.type.toUpperCase?a=s.type.toUpperCase():
!a&&s.href&&(a="A"));return a};s.ga=function(s){var a=s.href?s.href:"",c,e,d;c=a.indexOf(":");e=a.indexOf("?");d=a.indexOf("/");if(a&&(c<0||e>=0&&c>e||d>=0&&c>d))e=s.protocol&&s.protocol.length>1?s.protocol:l.protocol?l.protocol:"",c=l.pathname.lastIndexOf("/"),a=(e?e+"//":"")+(s.host?s.host:l.host?l.host:"")+(h.substring(0,1)!="/"?l.pathname.substring(0,c<0?0:c)+"/":"")+a;return a};s.F=function(b){var a=s.u(b),c,e,d="",f=0;if(a){c=b.protocol;e=b.onclick;if(b.href&&(a=="A"||a=="AREA")&&(!e||!c||c.toLowerCase().indexOf("javascript")<
0))d=s.ga(b);else if(e)d=s.replace(s.replace(s.replace(s.replace(""+e,"\r",""),"\n",""),"\t","")," ",""),f=2;else if(a=="INPUT"||a=="SUBMIT"){if(b.value)d=b.value;else if(b.innerText)d=b.innerText;else if(b.textContent)d=b.textContent;f=3}else if(b.src&&a=="IMAGE")d=b.src;if(d)return{id:d.substring(0,100),type:f}}return 0};s.mb=function(b){for(var a=s.u(b),c=s.F(b);b&&!c&&a!="BODY";)if(b=b.parentElement?b.parentElement:b.parentNode)a=s.u(b),c=s.F(b);if(!c||a=="BODY")b=0;if(b&&(a=b.onclick?""+b.onclick:
"",a.indexOf(".tl(")>=0||a.indexOf(".trackLink(")>=0))b=0;return b};s.Va=function(){var b,a,c=s.linkObject,e=s.linkType,d=s.linkURL,f,g;s.R=1;if(!c)s.R=0,c=s.j;if(c){b=s.u(c);for(a=s.F(c);c&&!a&&b!="BODY";)if(c=c.parentElement?c.parentElement:c.parentNode)b=s.u(c),a=s.F(c);if(!a||b=="BODY")c=0;if(c){var j=c.onclick?""+c.onclick:"";if(j.indexOf(".tl(")>=0||j.indexOf(".trackLink(")>=0)c=0}}else s.R=1;!d&&c&&(d=s.ga(c));d&&!s.linkLeaveQueryString&&(f=d.indexOf("?"),f>=0&&(d=d.substring(0,f)));if(!e&&
d){var i=0,k=0,m;if(s.trackDownloadLinks&&s.linkDownloadFileTypes){j=d.toLowerCase();f=j.indexOf("?");g=j.indexOf("#");f>=0?g>=0&&g<f&&(f=g):f=g;f>=0&&(j=j.substring(0,f));f=s.linkDownloadFileTypes.toLowerCase().split(",");for(g=0;g<f.length;g++)(m=f[g])&&j.substring(j.length-(m.length+1))=="."+m&&(e="d")}if(s.trackExternalLinks&&!e&&(j=d.toLowerCase(),s.ja(j))){if(!s.linkInternalFilters)s.linkInternalFilters=w.location.hostname;f=0;s.linkExternalFilters?(f=s.linkExternalFilters.toLowerCase().split(","),
i=1):s.linkInternalFilters&&(f=s.linkInternalFilters.toLowerCase().split(","));if(f){for(g=0;g<f.length;g++)m=f[g],j.indexOf(m)>=0&&(k=1);k?i&&(e="e"):i||(e="e")}}}s.linkObject=c;s.linkURL=d;s.linkType=e;if(s.trackClickMap||s.trackInlineStats)if(s.g="",c){e=s.pageName;d=1;c=c.sourceIndex;if(!e)e=s.pageURL,d=0;if(w.s_objectID)a.id=w.s_objectID,c=a.type=1;if(e&&a&&a.id&&b)s.g="&pid="+s.escape(e.substring(0,255))+(d?"&pidt="+d:"")+"&oid="+s.escape(a.id.substring(0,100))+(a.type?"&oidt="+a.type:"")+"&ot="+
b+(c?"&oi="+c:"")}};s.Ma=function(){var b=s.R,a=s.linkType,c=s.linkURL,e=s.linkName;if(a&&(c||e))a=a.toLowerCase(),a!="d"&&a!="e"&&(a="o"),s.pe="lnk_"+a,s.pev1=c?s.escape(c):"",s.pev2=e?s.escape(e):"",b=1;s.abort&&(b=0);if(s.trackClickMap||s.trackInlineStats){a={};c=0;var d=s.cookieRead("s_sq"),f=d?d.split("&"):0,g,j,w;d=0;if(f)for(g=0;g<f.length;g++)j=f[g].split("="),e=s.unescape(j[0]).split(","),j=s.unescape(j[1]),a[j]=e;e=s.account.split(",");if(b||s.g){b&&!s.g&&(d=1);for(j in a)if(!Object.prototype[j])for(g=
0;g<e.length;g++){d&&(w=a[j].join(","),w==s.account&&(s.g+=(j.charAt(0)!="&"?"&":"")+j,a[j]=[],c=1));for(f=0;f<a[j].length;f++)w=a[j][f],w==e[g]&&(d&&(s.g+="&u="+s.escape(w)+(j.charAt(0)!="&"?"&":"")+j+"&u=0"),a[j].splice(f,1),c=1)}b||(c=1);if(c){d="";g=2;!b&&s.g&&(d=s.escape(e.join(","))+"="+s.escape(s.g),g=1);for(j in a)!Object.prototype[j]&&g>0&&a[j].length>0&&(d+=(d?"&":"")+s.escape(a[j].join(","))+"="+s.escape(j),g--);s.cookieWrite("s_sq",d)}}}return b};s.Na=function(){if(!s.bb){var b=new Date,
a=m.location,c,e,d,f=d=e=c="",g="",w="",i="1.2",k=s.cookieWrite("s_cc","true",0)?"Y":"N",n="",p="",o=0;if(b.setUTCDate&&(i="1.3",o.toPrecision&&(i="1.5",c=[],c.forEach))){i="1.6";d=0;e={};try{d=new Iterator(e),d.next&&(i="1.7",c.reduce&&(i="1.8",i.trim&&(i="1.8.1",Date.parse&&(i="1.8.2",Object.create&&(i="1.8.5")))))}catch(r){}}c=screen.width+"x"+screen.height;d=navigator.javaEnabled()?"Y":"N";e=screen.pixelDepth?screen.pixelDepth:screen.colorDepth;g=s.w.innerWidth?s.w.innerWidth:s.d.documentElement.offsetWidth;
w=s.w.innerHeight?s.w.innerHeight:s.d.documentElement.offsetHeight;b=navigator.plugins;try{s.b.addBehavior("#default#homePage"),n=s.b.nb(a)?"Y":"N"}catch(t){}try{s.b.addBehavior("#default#clientCaps"),p=s.b.connectionType}catch(u){}if(b)for(;o<b.length&&o<30;){if(a=b[o].name)a=a.substring(0,100)+";",f.indexOf(a)<0&&(f+=a);o++}s.resolution=c;s.colorDepth=e;s.javascriptVersion=i;s.javaEnabled=d;s.cookiesEnabled=k;s.browserWidth=g;s.browserHeight=w;s.connectionType=p;s.homepage=n;s.plugins=f;s.bb=1}};
s.I={};s.loadModule=function(b,a){var c=s.I[b];if(!c){c=w["AppMeasurement_Module_"+b]?new w["AppMeasurement_Module_"+b](s):{};s.I[b]=s[b]=c;c.ua=function(){return c.wa};c.xa=function(a){if(c.wa=a)s[b+"_onLoad"]=a,s.C(b+"_onLoad",[s,c],1)||a(s,c)};try{Object.defineProperty?Object.defineProperty(c,"onLoad",{get:c.ua,set:c.xa}):c._olc=1}catch(e){c._olc=1}}a&&(s[b+"_onLoad"]=a,s.C(b+"_onLoad",[s,c],1)||a(s,c))};s.q=function(b){var a,c;for(a in s.I)if(!Object.prototype[a]&&(c=s.I[a])){if(c._olc&&c.onLoad)c._olc=
0,c.onLoad(s,c);if(c[b]&&c[b]())return 1}return 0};s.Qa=function(){var b=Math.floor(Math.random()*1E13),a=s.visitorSampling,c=s.visitorSamplingGroup;c="s_vsn_"+(s.visitorNamespace?s.visitorNamespace:s.account)+(c?"_"+c:"");var e=s.cookieRead(c);if(a){e&&(e=parseInt(e));if(!e){if(!s.cookieWrite(c,b))return 0;e=b}if(e%1E4>v)return 0}return 1};s.J=function(b,a){var c,e,d,f,g,w;for(c=0;c<2;c++){e=c>0?s.aa:s.c;for(d=0;d<e.length;d++)if(f=e[d],(g=b[f])||b["!"+f]){if(!a&&(f=="contextData"||f=="retrieveLightData")&&
s[f])for(w in s[f])g[w]||(g[w]=s[f][w]);s[f]=g}}};s.qa=function(b,a){var c,e,d,f;for(c=0;c<2;c++){e=c>0?s.aa:s.c;for(d=0;d<e.length;d++)f=e[d],b[f]=s[f],!a&&!b[f]&&(b["!"+f]=1)}};s.Ia=function(s){var a,c,e,d,f,g=0,w,i="",k="";if(s&&s.length>255&&(a=""+s,c=a.indexOf("?"),c>0&&(w=a.substring(c+1),a=a.substring(0,c),d=a.toLowerCase(),e=0,d.substring(0,7)=="http://"?e+=7:d.substring(0,8)=="https://"&&(e+=8),c=d.indexOf("/",e),c>0&&(d=d.substring(e,c),f=a.substring(c),a=a.substring(0,c),d.indexOf("google")>=
0?g=",q,ie,start,search_key,word,kw,cd,":d.indexOf("yahoo.co")>=0&&(g=",p,ei,"),g&&w)))){if((s=w.split("&"))&&s.length>1){for(e=0;e<s.length;e++)d=s[e],c=d.indexOf("="),c>0&&g.indexOf(","+d.substring(0,c)+",")>=0?i+=(i?"&":"")+d:k+=(k?"&":"")+d;i&&k?w=i+"&"+k:k=""}c=253-(w.length-k.length)-a.length;s=a+(c>0?f.substring(0,c):"")+"?"+w}return s};s.za=!1;s.$=!1;s.kb=function(b){s.marketingCloudVisitorID=b;s.$=!0;s.A()};s.K=!1;s.Y=!1;s.ta=function(b){s.analyticsVisitorID=b;s.Y=!0;s.A()};s.ya=!1;s.Z=!1;
s.jb=function(b){s.audienceManagerVisitorID=b;if(s.audienceManagerVisitorID&&s.visitor.getAudienceManagerLocationHint)s.audienceManagerLocationHint=s.visitor.getAudienceManagerLocationHint();s.Z=!0;s.A()};s.isReadyToTrack=function(){var b=!0,a=s.visitor;if(a&&a.isAllowed()){if(!s.K&&!s.analyticsVisitorID&&a.getAnalyticsVisitorID&&(s.analyticsVisitorID=a.getAnalyticsVisitorID([s,s.ta]),!s.analyticsVisitorID))s.K=!0;if(s.za&&!s.$&&!s.marketingCloudVisitorID||s.K&&!s.Y&&!s.analyticsVisitorID||s.ya&&
!s.Z&&!s.audienceManagerVisitorID)b=!1}return b};s.k=k;s.l=0;s.callbackWhenReadyToTrack=function(b,a,c){var e;e={};e.Da=b;e.Ca=a;e.Aa=c;if(s.k==k)s.k=[];s.k.push(e);if(s.l==0)s.l=setInterval(s.A,100)};s.A=function(){var b;if(s.isReadyToTrack()){if(s.l)clearInterval(s.l),s.l=0;if(s.k!=k)for(;s.k.length>0;)b=s.k.shift(),b.Ca.apply(b.Da,b.Aa)}};s.va=function(b){var a,c,e=k,d=k;if(!s.isReadyToTrack()){a=[];if(b!=k)for(c in e={},b)e[c]=b[c];d={};s.qa(d,!0);a.push(e);a.push(d);s.callbackWhenReadyToTrack(s,
s.track,a);return!0}return!1};s.Ka=function(){var b=s.cookieRead("s_fid"),a="",c="",e;e=8;var d=4;if(!b||b.indexOf("-")<0){for(b=0;b<16;b++)e=Math.floor(Math.random()*e),a+="0123456789ABCDEF".substring(e,e+1),e=Math.floor(Math.random()*d),c+="0123456789ABCDEF".substring(e,e+1),e=d=16;b=a+"-"+c}s.cookieWrite("s_fid",b,1)||(b=0);return b};s.t=s.track=function(b,a){var c,e=new Date,d="s"+Math.floor(e.getTime()/108E5)%10+Math.floor(Math.random()*1E13),f=e.getYear();f="t="+s.escape(e.getDate()+"/"+e.getMonth()+
"/"+(f<1900?f+1900:f)+" "+e.getHours()+":"+e.getMinutes()+":"+e.getSeconds()+" "+e.getDay()+" "+e.getTimezoneOffset());s.q("_s");if(!s.C("track",arguments)){if(!s.va(b)){a&&s.J(a);b&&(c={},s.qa(c,0),s.J(b));if(s.Qa()){if(!s.analyticsVisitorID&&!s.marketingCloudVisitorID)s.fid=s.Ka();s.Va();s.usePlugins&&s.doPlugins&&s.doPlugins(s);if(s.account){if(!s.abort){if(s.trackOffline&&!s.timestamp)s.timestamp=Math.floor(e.getTime()/1E3);e=w.location;if(!s.pageURL)s.pageURL=e.href?e.href:e;if(!s.referrer&&
!s.ra)s.referrer=m.document.referrer,s.ra=1;s.referrer=s.Ia(s.referrer);s.q("_g")}s.Ma()&&!s.abort&&(s.Na(),f+=s.La(),s.Ua(d,f));s.abort||s.q("_t")}}b&&s.J(c,1)}s.timestamp=s.linkObject=s.j=s.linkURL=s.linkName=s.linkType=w.ob=s.pe=s.pev1=s.pev2=s.pev3=s.g=0}};s.tl=s.trackLink=function(b,a,c,e,d){s.linkObject=b;s.linkType=a;s.linkName=c;if(d)s.i=b,s.p=d;return s.track(e)};s.trackLight=function(b,a,c,e){s.lightProfileID=b;s.lightStoreForSeconds=a;s.lightIncrementBy=c;return s.track(e)};s.clearVars=
function(){var b,a;for(b=0;b<s.c.length;b++)if(a=s.c[b],a.substring(0,4)=="prop"||a.substring(0,4)=="eVar"||a.substring(0,4)=="hier"||a.substring(0,4)=="list"||a=="channel"||a=="events"||a=="eventList"||a=="products"||a=="productList"||a=="purchaseID"||a=="transactionID"||a=="state"||a=="zip"||a=="campaign")s[a]=void 0};s.Ua=function(b,a){var c,e=s.trackingServer;c="";var d=s.dc,f="sc.",g=s.visitorNamespace;if(e){if(s.trackingServerSecure&&s.ssl)e=s.trackingServerSecure}else{if(!g)g=s.account,e=g.indexOf(","),
e>=0&&(g=g.ib(0,e)),g=g.replace(/[^A-Za-z0-9]/g,"");c||(c="2o7.net");d=d?(""+d).toLowerCase():"d1";c=="2o7.net"&&(d=="d1"?d="112":d=="d2"&&(d="122"),f="");e=g+"."+d+"."+f+c}c=s.ssl?"https://":"http://";c+=e+"/b/ss/"+s.account+"/"+(s.mobile?"5.":"")+"1/JS-"+s.version+(s.ab?"T":"")+"/"+b+"?AQB=1&ndh=1&"+a+"&AQE=1";s.Pa&&(c=c.substring(0,2047));s.Ga(c);s.O()};s.Ga=function(b){s.e||s.Oa();s.e.push(b);s.P=s.r();s.pa()};s.Oa=function(){s.e=s.Ra();if(!s.e)s.e=[]};s.Ra=function(){var b,a;if(s.U()){try{(a=
w.localStorage.getItem(s.S()))&&(b=w.JSON.parse(a))}catch(c){}return b}};s.U=function(){var b=!0;if(!s.trackOffline||!s.offlineFilename||!w.localStorage||!w.JSON)b=!1;return b};s.ha=function(){var b=0;if(s.e)b=s.e.length;s.v&&b++;return b};s.O=function(){if(!s.v)if(s.ia=k,s.T)s.P>s.G&&s.na(s.e),s.W(500);else{var b=s.Ba();if(b>0)s.W(b);else if(b=s.fa())s.v=1,s.Ta(b),s.Ya(b)}};s.W=function(b){if(!s.ia)b||(b=0),s.ia=setTimeout(s.O,b)};s.Ba=function(){var b;if(!s.trackOffline||s.offlineThrottleDelay<=
0)return 0;b=s.r()-s.ma;if(s.offlineThrottleDelay<b)return 0;return s.offlineThrottleDelay-b};s.fa=function(){if(s.e.length>0)return s.e.shift()};s.Ta=function(b){if(s.debugTracking){var a="AppMeasurement Debug: "+b;b=b.split("&");var c;for(c=0;c<b.length;c++)a+="\n\t"+s.unescape(b[c]);s.Sa(a)}};s.Ya=function(b){var a;if(!a)a=new Image,a.alt="";a.ca=function(){try{if(s.V)clearTimeout(s.V),s.V=0;if(a.timeout)clearTimeout(a.timeout),a.timeout=0}catch(b){}};a.onload=a.$a=function(){a.ca();s.Fa();s.L();
s.v=0;s.O()};a.onabort=a.onerror=a.Ha=function(){a.ca();(s.trackOffline||s.T)&&s.v&&s.e.unshift(s.Ea);s.v=0;s.P>s.G&&s.na(s.e);s.L();s.W(500)};a.onreadystatechange=function(){a.readyState==4&&(a.status==200?a.$a():a.Ha())};s.ma=s.r();a.src=b;if(a.abort)s.V=setTimeout(a.abort,5E3);s.Ea=b;s.lb=w["s_i_"+s.replace(s.account,",","_")]=a;if(s.useForcedLinkTracking&&s.B||s.p){if(!s.forcedLinkTrackingTimeout)s.forcedLinkTrackingTimeout=250;s.M=setTimeout(s.L,s.forcedLinkTrackingTimeout)}};s.Fa=function(){if(s.U()&&
!(s.la>s.G))try{w.localStorage.removeItem(s.S()),s.la=s.r()}catch(b){}};s.na=function(b){if(s.U()){s.pa();try{w.localStorage.setItem(s.S(),w.JSON.stringify(b)),s.G=s.r()}catch(a){}}};s.pa=function(){if(s.trackOffline){if(!s.offlineLimit||s.offlineLimit<=0)s.offlineLimit=10;for(;s.e.length>s.offlineLimit;)s.fa()}};s.forceOffline=function(){s.T=!0};s.forceOnline=function(){s.T=!1};s.S=function(){return s.offlineFilename+"-"+s.visitorNamespace+s.account};s.r=function(){return(new Date).getTime()};s.ja=
function(s){s=s.toLowerCase();if(s.indexOf("#")!=0&&s.indexOf("about:")!=0&&s.indexOf("opera:")!=0&&s.indexOf("javascript:")!=0)return!0;return!1};s.setTagContainer=function(b){var a,c,e;s.ab=b;for(a=0;a<s._il.length;a++)if((c=s._il[a])&&c._c=="s_l"&&c.tagContainerName==b){s.J(c);if(c.lmq)for(a=0;a<c.lmq.length;a++)e=c.lmq[a],s.loadModule(e.n);if(c.ml)for(e in c.ml)if(s[e])for(a in b=s[e],e=c.ml[e],e)if(!Object.prototype[a]&&(typeof e[a]!="function"||(""+e[a]).indexOf("s_c_il")<0))b[a]=e[a];if(c.mmq)for(a=
0;a<c.mmq.length;a++)e=c.mmq[a],s[e.m]&&(b=s[e.m],b[e.f]&&typeof b[e.f]=="function"&&(e.a?b[e.f].apply(b,e.a):b[e.f].apply(b)));if(c.tq)for(a=0;a<c.tq.length;a++)s.track(c.tq[a]);c.s=s;break}};s.Util={urlEncode:s.escape,urlDecode:s.unescape,cookieRead:s.cookieRead,cookieWrite:s.cookieWrite,getQueryParam:function(b,a,c){var e;a||(a=s.pageURL?s.pageURL:w.location);c||(c="&");if(b&&a&&(a=""+a,e=a.indexOf("?"),e>=0&&(a=c+a.substring(e+1)+c,e=a.indexOf(c+b+"="),e>=0&&(a=a.substring(e+c.length+b.length+
1),e=a.indexOf(c),e>=0&&(a=a.substring(0,e)),a.length>0))))return s.unescape(a);return""}};s.z=["timestamp","dynamicVariablePrefix","visitorID","marketingCloudVisitorID","analyticsVisitorID","audienceManagerVisitorID","audienceManagerLocationHint","fid","vmk","visitorMigrationKey","visitorMigrationServer","visitorMigrationServerSecure","charSet","visitorNamespace","cookieDomainPeriods","fpCookieDomainPeriods","cookieLifetime","pageName","pageURL","referrer","contextData","currencyCode","lightProfileID",
"lightStoreForSeconds","lightIncrementBy","retrieveLightProfiles","deleteLightProfiles","retrieveLightData","pe","pev1","pev2","pev3","pageURLRest"];s.c=s.z.concat(["purchaseID","variableProvider","channel","server","pageType","transactionID","campaign","state","zip","events","events2","products","tnt"]);s.Q=["timestamp","charSet","visitorNamespace","cookieDomainPeriods","cookieLifetime","contextData","lightProfileID","lightStoreForSeconds","lightIncrementBy"];s.H=s.Q.slice(0);s.aa=["account","allAccounts",
"debugTracking","visitor","trackOffline","offlineLimit","offlineThrottleDelay","offlineFilename","usePlugins","doPlugins","configURL","visitorSampling","s.visitorSamplingGroup","linkObject","linkURL","linkName","linkType","trackDownloadLinks","trackExternalLinks","trackClickMap","trackInlineStats","linkLeaveQueryString","linkTrackVars","linkTrackEvents","linkDownloadFileTypes","linkExternalFilters","linkInternalFilters","useForcedLinkTracking","forcedLinkTrackingTimeout","trackingServer","trackingServerSecure",
"ssl","abort","mobile","dc","lightTrackVars","maxDelay"];for(i=0;i<=75;i++)s.c.push("prop"+i),s.H.push("prop"+i),s.c.push("eVar"+i),s.H.push("eVar"+i),i<6&&s.c.push("hier"+i),i<4&&s.c.push("list"+i);i=["resolution","colorDepth","javascriptVersion","javaEnabled","cookiesEnabled","browserWidth","browserHeight","connectionType","homepage","plugins"];s.c=s.c.concat(i);s.z=s.z.concat(i);s.ssl=w.location.protocol.toLowerCase().indexOf("https")>=0;s.charSet="UTF-8";s.contextData={};s.offlineThrottleDelay=
0;s.offlineFilename="AppMeasurement.offline";s.ma=0;s.P=0;s.G=0;s.la=0;s.linkDownloadFileTypes="exe,zip,wav,mp3,mov,mpg,avi,wmv,pdf,doc,docx,xls,xlsx,ppt,pptx";s.w=w;s.d=w.document;try{s.Pa=navigator.appName=="Microsoft Internet Explorer"}catch(o){}s.L=function(){if(s.M)w.clearTimeout(s.M),s.M=k;s.i&&s.B&&s.i.dispatchEvent(s.B);if(s.p)if(typeof s.p=="function")s.p();else if(s.i&&s.i.href)s.d.location=s.i.href;s.i=s.B=s.p=0};s.oa=function(){s.b=s.d.body;if(s.b)if(s.o=function(b){var a,c,e,d,f;if(!(s.d&&
s.d.getElementById("cppXYctnr")||b&&b.Wa)){if(s.ba)if(s.useForcedLinkTracking)s.b.removeEventListener("click",s.o,!1);else{s.b.removeEventListener("click",s.o,!0);s.ba=s.useForcedLinkTracking=0;return}else s.useForcedLinkTracking=0;s.j=b.srcElement?b.srcElement:b.target;try{if(s.j&&(s.j.tagName||s.j.parentElement||s.j.parentNode))if(e=s.ha(),s.track(),e<s.ha()&&s.useForcedLinkTracking&&b.target){for(d=b.target;d&&d!=s.b&&d.tagName.toUpperCase()!="A"&&d.tagName.toUpperCase()!="AREA";)d=d.parentNode;
if(d&&(f=d.href,s.ja(f)||(f=0),c=d.target,b.target.dispatchEvent&&f&&(!c||c=="_self"||c=="_top"||c=="_parent"||w.name&&c==w.name))){try{a=s.d.createEvent("MouseEvents")}catch(g){a=new w.MouseEvent}if(a){try{a.initMouseEvent("click",b.bubbles,b.cancelable,b.view,b.detail,b.screenX,b.screenY,b.clientX,b.clientY,b.ctrlKey,b.altKey,b.shiftKey,b.metaKey,b.button,b.relatedTarget)}catch(i){a=0}if(a)a.Wa=1,b.stopPropagation(),b.Za&&b.Za(),b.preventDefault(),s.i=b.target,s.B=a}}}}catch(k){}s.j=0}},s.b&&s.b.attachEvent)s.b.attachEvent("onclick",
s.o);else{if(s.b&&s.b.addEventListener){if(navigator&&(navigator.userAgent.indexOf("WebKit")>=0&&s.d.createEvent||navigator.userAgent.indexOf("Firefox/2")>=0&&w.MouseEvent))s.ba=1,s.useForcedLinkTracking=1,s.b.addEventListener("click",s.o,!0);s.b.addEventListener("click",s.o,!1)}}else setTimeout(s.oa,30)};s.oa()}
function s_gi(s){var w,k=window.s_c_il,m,i=s.split(","),n,p,o=0;if(k)for(m=0;!o&&m<k.length;){w=k[m];if(w._c=="s_c"&&w.account)if(w.account==s)o=1;else{if(!w.allAccounts)w.allAccounts=w.account.split(",");for(n=0;n<i.length;n++)for(p=0;p<w.allAccounts.length;p++)i[n]==w.allAccounts[p]&&(o=1)}m++}o||(w=new AppMeasurement);w.setAccount(s);return w}AppMeasurement.getInstance=s_gi;window.s_objectID||(window.s_objectID=0);
function s_pgicq(){var s=window,w=s.s_giq,k,m,i;if(w)for(k=0;k<w.length;k++)m=w[k],i=s_gi(m.oun),i.setAccount(m.un),i.setTagContainer(m.tagContainerName);s.s_giq=0}s_pgicq();
