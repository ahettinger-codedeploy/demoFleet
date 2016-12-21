function closePopup(whatDiv) {
	if(document.getElementById(whatDiv)) {
		var popups = document.getElementById(whatDiv);
		popups.style.display = "none";
	}
}

function initNav() {
	if(!document.getElementById('nav')) return false;
	var navHolder = document.getElementById('nav');
	var lis = navHolder.getElementsByTagName('li');
	for(i=0; i<lis.length; i++) {
		lis[i].onmouseover = function() {
			if(undefined!==window.closeTheThing) {
				clearTimeout(closeTheThing);
			}
			var liPartialName = this.id.substring(3, this.id.length);
			var popupName = "s"+liPartialName;
			if((document.getElementById(popupName))) {
				var popups = document.getElementById(popupName);
				popups.style.display = "block";
			}
			for(j=0; j<lis.length; j++) {
				var liPName = lis[j].id.substring(3, lis[j].id.length);
				var pName = "s"+liPName;
				if(document.getElementById(pName)) {
					var ps = document.getElementById(pName);
					if(ps!=popups) {
						ps.style.display = "none";
					}
				}
			}
		}		
		lis[i].onmouseout = function() {
			var liPartialName = this.id.substring(3, this.id.length);
			var popupName = "s"+liPartialName;
			var closeIt = "closePopup('"+popupName+"')";
			closeTheThing = setTimeout(closeIt, 250)  
		}
	}
	
	// to keep boxes open //
	var navPop = document.getElementsByTagName('div');
	for(i=0; i<navPop.length; i++) {
		var navClass = navPop[i].className.substring(0, 6);
		if(navClass=="navpop") {
			navPop[i].onmouseover = function() {
				if(undefined!==window.closeTheThing) {
					clearTimeout(closeTheThing);
				}
				this.style.display = "block";
				thisID = this.id;
				linkID = "np-"+thisID.substring(1, thisID.length);
				
				if(document.getElementById(linkID)) {
					linkClass = document.getElementById(linkID);
					linkClass.className = "hovered";
				}
			}
			navPop[i].onmouseout = function() {
				thisID = this.id;
				linkID = "np-"+thisID.substring(1, thisID.length);
				if(document.getElementById(linkID)) {
					linkClass = document.getElementById(linkID);
					linkClass.className = "";
				}
				var closeIt = "closePopup('"+thisID+"')";
				closeTheThing = setTimeout(closeIt, 60) 
			}
		}
	}
}

function subnavSwitch() {
	$("#breadcrumb a").mouseover(function() {
		var idNum = this.id.replace(/[^0-9]/g, ''); 
		if($("#mlData div:visible").attr("id")) {
			var curNum = ($("#mlData div:visible").attr("id")).replace(/[^0-9]/g, '');
		} else {
			var curNum = "";	
		}

		if(idNum && idNum!=curNum) {
			$("#mlData div").hide();
			$("#breadcrumb a").removeClass("paged");
			$(this).addClass("paged");
			$("#ml-"+idNum).fadeIn(200);
		}


		if(idNum) { // If not Home Link
			return false;
		}
	});
}

function animateSearch() {
	$("#i-search").click(function() {
		$("#searchbox").slideToggle(150);
		$("#navinput").focus();
		return false;
	});
	
	
	
	$("#searchclose").click(function() { $("#searchbox").slideUp(150); return false; });
}

function makeToolTips() {
	$('#frontads a').tooltip({ 
		 track: true, 
		 delay: 0, 
		 showURL: false, 
		 opacity: 1, 
		 fixPNG: true, 
		 showBody: " - ", 
		 extraClass: "fancy", 
		 top: -45, 
		 left: -15
	});	
}

function clearSlider() {
	var elements = Array("sl-new","sl-thisweek","sl-devotionals","sl-sermons");
	for(i=0;i<elements.length;i++) {
		$("#"+elements[i]).removeClass("paged");	
	}
}

function makeSlider() {
	if($('#slider')) {
		$('#sliderLoad').load('/inc/homepage.inc.php');
		$('#slidernav a').click(function() {
			clearSlider();
			$(this).parent().addClass('paged');
			return false;
		});
		// Homepage Slide
		
		$('#sl-new a').click(function() {
			$('#sliderMover').animate({"left": 0}, "slow");
			$('#sliderContent').animate({"height": 190}, "slow");
		});
		
		$('#sl-thisweek a').click(function() {
			$('#sliderMover').animate({"left": -840}, "slow");
			$('#sliderContent').animate({"height": 278}, "slow");
		});
		
		$('#sl-devotionals a').click(function() {
			$('#sliderMover').animate({"left": -1680}, "slow");
			$('#sliderContent').animate({"height": 190}, "slow");
		});
		
		$('#sl-sermons a').click(function() {
			$('#sliderMover').animate({"left": -2520}, "slow");
			$('#sliderContent').animate({"height": 190}, "slow");
		});
	}	
}

function sundaySchool() {
	if($('.ssBody')) {
		$('.ssBody').hide();
		$('.ssTitle a').click(function() {

			$(this).toggleClass("paged");
			var openTitle = "ssBody"+this.title;
			$('#'+openTitle).slideToggle(200);
			return false;
		});
	}	
}

function makeLinksWork() {
	// LINK ACTIONS
	$('a[@href^="mailto:"]').addClass('imail');
	$('a[@href^="http://"]').addClass('iext');
	$('a[@href$=".pdf"]').addClass('ipdf');
	$('a[@href$=".doc"]').addClass('iword');
	$('a[@href$=".ppt"]').addClass('ipowerpoint');
	
	$('a[@rel="external"]').click(function(){
		window.open(this.href);
		return false;
	});
		  
	$('.video').click(function(){
		window.open(this.href);
		return false;
	});	
}

function dropDowns() {
	if($("#f-categorySelect")) {
		$("#f-categorySelect").change(function() {
			window.open("/lifeu/?cat=" + this.value, "_parent");
		});
	}	
	
	if($("#f-classSelect")) {
		$("#f-classSelect").change(function() {
			window.open("/class/classes.php?cat=" + this.value, "_parent");
		});
	}
	
	if($("#reloadElement1")) {
		$("#reloadElement1").change(function() {
			window.open("/serve/cfbc/all/?sortBy=" + this.value, "_parent");
		});
	}
	
	if($("#f-jumpTo")) {
		$("#f-jumpTo").change(function() {
			window.open(this.value, "_parent");
		});
	}
	
}


$(document).ready(function() {
	initNav();
	animateSearch();
	subnavSwitch();
	makeSlider();
	sundaySchool();
	makeLinksWork();
	dropDowns();
});