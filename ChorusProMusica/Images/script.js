/* Author: Patricia Quintin
 * v.2.0
*/
var j = jQuery.noConflict();

j(document).ready(function(){

	// Main Navigation - depends on superfish-1.4.8-yui
	if (j("ul.sf-menu").length) {
		j("ul.sf-menu").supersubs({
				minWidth:15,
				maxWidth:30,
				extraWidth:1 
		}).superfish({delay:400,speed:200 })
	}

	// show placeholders in IE
	j('input, textarea').placeholder({blankSubmit: true});

	// open stuff
	j('.toggler').click(function(){
		var myLink = j(this).attr('href');
		var myTarget = j(document).find('div#'+myLink);
		var myTargetSibs = j(document).find('div#'+myLink).siblings('.des');
		j(myTarget).slideToggle();
		if(myTargetSibs.length){
			j(myTargetSibs).find('h2').toggleClass('opened');
		}
		return false;
	});
	
	// close stuff
	j('.close').click(function(){
		var closeLink = j(this).attr('href');
		var closeTarget = j(document).find('div#'+closeLink);
		j(closeTarget).slideUp();
		return false;
	});
		
	//fade siblings on hover
	/*j(".social a, #flickr li").live({
		mouseenter:
		 function() {
			j(this).siblings().stop().animate({opacity: 0.5}, "200"); 
		 },
		mouseleave:
		 function() {
			j(this).siblings().stop().animate({opacity: 1.0}, "200");   
		 }
		}
   );*/

	// slide show 
		j('.slides').cycle({
		fx: 'fade', 
		timeout: 8000,
		cleartypeNoBg: true,
		pager:  '.controls, .slidetabs',
		// put bullets in the controls
		pagerAnchorBuilder: function(idx, slide) {
				return '<li><a href="#"></a></li>';     
		}
	});
 	var arr=[];
	j('.tabtext').each(function(){
		arr.push(this);
	})
	j('.slidetabs li:nth-child(1)').html(arr[0]);
	j('.slidetabs li:nth-child(2)').html(arr[1]);
	j('.slidetabs li:nth-child(3)').html(arr[2]);
	j('.slidetabs li:nth-child(4)').html(arr[3]);
	j('.slidetabs li:nth-child(5)').html(arr[4]);

	j('.slidetabs li a').click(function(){
		window.location.href = j(this).attr('href');
	});
	
	//tab widget
	j('.activetab').show();
	j('#tabnav li').click(function (e) {
			var jmyId = j(this).find('a').attr('href');
			var jmyTab = j('#tabs').find('div#'+jmyId);	
			j(this).addClass('activetab');
			j(this).siblings('li').removeClass('activetab');	
			j(jmyTab).siblings('div.tab').hide();	
			j(jmyTab).fadeIn();
			e.preventDefault();		
	});

	// go back to previous page
	j('a.back').click(function(){ 
			parent.history.back(); 
			return false; 
	}); 	

	// open external links in new window
	j('a').each(function() {
		j.expr[':'].external = function(obj){
			return !obj.href.match(/^mailto\:/)
			&& (obj.hostname != location.hostname)
			&& !obj.href.match(/^javascript\:/)
			&& !obj.href.match(/^http\:\/\/www.youtube.com\//)
			&& !obj.href.match(/^http\:\/\/choruspromusica.s3.amazonaws.com\//)
		};
		j('a:external').addClass('external').attr('target','_blank');
	});


});