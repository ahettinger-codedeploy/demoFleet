// Schoollist Dropdown Modification
// @author Joseph Karns - Web Developer 1, Schoolwires, Inc
// Last Updated on 07/14/12

(function($) {

	$.fn.modSchoollist = function(settings){
		//Settings
		var config = {
			'keywords'				: ['Elementary','High','Middle'],
			'useColumns'			: "no",
			'useHeadings'			: "yes",
			'leftoversHeading'		: "Alternate Schools",
			'changeSelectorText'	: "no",
			'multipleDropdowns'		: "no",
			'numOfDropdowns'		: 1,
			'keywordsInDropdowns'	: [["Elementary","1"],["Middle","2"],["High","2"]],
			'dropdownSelectorText'	: ['Select A School...'],
			'removeStyles'			: "no"
		};
		if (settings){$.extend(true, config, settings);}
		
		//Loop throught Schoollist li's
		return this.each(function() {
			//Global Variables
			var element = this;
			var hasMatch = 0;
			$("ul.sw-dropdown-list li", element).each(function() {
				var schoolName = String($("a", this).text());
				//Checks Each Li against keywords array
				for(var i = 0; i < config.keywords.length; i++){
					var currentKeyword = config.keywords[i];
					if(schoolName.match("" + currentKeyword + "")) {
						$(this).addClass(currentKeyword);
						var hasMatch = 1;	
					}
				}
				if (hasMatch != 1){
					$(this).addClass("Alternate");	
				}
			});
			$("ul.sw-dropdown-list li", element).each(function() {
				if($(this).hasClass("Alternate")){
					hasMatch = 0;
					return false;	
				} else {
					hasMatch = 1;
				}
			});
			//Arrange Schools in Order of Keywords
			for(var i = 0; i < config.keywords.length; i++){
				var currentKeyword = config.keywords[i];
				$("ul.sw-dropdown-list li." + currentKeyword + "", element).each(function() {
					$(this).appendTo("ul.sw-dropdown-list");
				});
			}
			//Check which options are on and run those functions
			if (config.useHeadings == "yes" && config.useColumns == "no" && config.multipleDropdowns == "no"){
				if(hasMatch != 1) {
					addHeadingsWithBreaks(1);
				} else {
					addHeadingsWithBreaks(0);
				}
				if (config.changeSelectorText == "yes") {
					$("div.sw-mystart-dropdown.schoollist div.selector, div.sw-mystart-dropdown.schoollist div.sw-dropdown div.sw-dropdown-selected").text(config.dropdownSelectorText[0]);
				}
			}
			if (config.useColumns == "yes" && config.multipleDropdowns == "no"){
				if(hasMatch != 1) {
					buildColumns(1);
				} else {
					buildColumns(0);
				}
				if (config.changeSelectorText == "yes") {
					$("div.sw-mystart-dropdown.schoollist div.selector, div.sw-mystart-dropdown.schoollist div.sw-dropdown div.sw-dropdown-selected").text(config.dropdownSelectorText[0]);
				}
			}
			if (config.useColumns == "no" && config.multipleDropdowns == "yes"){
				if(hasMatch != 1) {
					buildDropdowns(1);
				} else {
					buildDropdowns(0);
				}	
			}
			if (config.useColumns == "yes" && config.multipleDropdowns == "yes"){
				alert("Please Select Either useColumns Option or multipleDropdowns Option");
			}
			
			function addHeadingsWithBreaks(hasAlternates) {
				if(hasAlternates == 1) {
					for(var i = 0; i < config.keywords.length; i++){
						var currentKeyword = config.keywords[i];
						$("ul.sw-dropdown-list li." + currentKeyword + "", element).eq(0).before("<li class='" + currentKeyword +" heading'><a href='#'>" + currentKeyword + " Schools</a></li>");
						$("ul.sw-dropdown-list li." + currentKeyword + "", element).last().after("<br />");
					}
					$("ul.sw-dropdown-list li.Alternate", element).eq(0).before("<li class='Alternate heading'><a href='#'>" + config.leftoversHeading + "</a></li>");
					$("ul.sw-dropdown-list li.Alternate", element).last().after("<br />");
				} else {
					for(var i = 0; i < config.keywords.length; i++){
						var currentKeyword = config.keywords[i];
						$("ul.sw-dropdown-list li." + currentKeyword + "", element).eq(0).before("<li class='" + currentKeyword +" heading'><a href='#'>" + currentKeyword + " Schools</a></li>");
						if (i != (config.keywords.length - 1)) {
							$("ul.sw-dropdown-list li." + currentKeyword + "", element).last().after("<br />");
						}
					}
				}
			}
			
			function buildColumns(hasAlternates) {
				var structureCSS = {
					'position'	: 'relative',
					'float'		: 'left',
					'padding'	: '0px 5px',
					'margin'	: '0px',
					'width'		: '180px'	
				}
				for(var i = 0; i < config.keywords.length; i++){
					var currentKeyword = config.keywords[i];
					var currentStructure = "<li class='modSchoolList column " + currentKeyword + "'><ul style='padding: 0px; margin: 0px; list-style: none;'></ul></li>";
					$("ul.sw-dropdown-list", element).append(currentStructure);
					$("ul.sw-dropdown-list li." + currentKeyword + "", element).not("ul.sw-dropdown-list li.column." + currentKeyword + "", element).each(function() {
						$(this).appendTo("li.modSchoolList.column." + currentKeyword + " > ul");
					});
					//Add Headings
					if (config.useHeadings == "yes") {
						$("ul.sw-dropdown-list li.column." + currentKeyword + " > ul", element).prepend("<li class='" + currentKeyword +" heading'><a href='#'>" + currentKeyword + " Schools</a></li>");	
					}
				}
				if (hasAlternates == 1) {
					//var currentStructure = "<li class='modSchoolList column Alternate'><ul style='padding: 0px; margin: 0px; list-style: none;'></ul></li>";
					$("ul.sw-dropdown-list", element).append("<li class='modSchoolList column' />");
					$("ul.sw-dropdown-list li.modSchoolList.column:last").append("<ul style='padding: 0px; margin: 0px; list-style: none;' />");
					$("ul.sw-dropdown-list li.Alternate", element).each(function() {
						$(this).appendTo("li.modSchoolList.column:last > ul");
					});
					//Add Headings
					if (config.useHeadings == "yes") {
						$("ul.sw-dropdown-list li.column:last > ul", element).prepend("<li class='Alternate heading'><a href='#'>" + config.leftoversHeading + "</a></li>");	
					}
				}
				if (config.removeStyles == "no") {
					if (hasAlternates == 1) {
						$("ul.sw-dropdown-list").addClass("ui-clear").width((190 * (config.keywords.length + 1)) + 20);
					} else {
						$("ul.sw-dropdown-list").addClass("ui-clear").width((190 * config.keywords.length) + 20);
					}
					$("div.sw-dropdown", element).css("margin-top", $(element).outerHeight())
					$("div.sw-dropdown-selected", element).remove();
					$("li.modSchoolList.column").css(structureCSS);
				}
			}
			
			function buildDropdowns(hasAlternates) {
				if(config.numOfDropdowns > 1) {
					if(config.numOfDropdowns == config.keywords.length) {
						if (hasAlternates == 1) {
							for(var i = 0; i < config.keywords.length; i++){
								var currentKeyword = config.keywords[i];
								var currentSelector = config.dropdownSelectorText[i];
								if(currentSelector == undefined){
									currentSelector = "Select A School...";
								}
								var currentStructure =  "<div class='sw-mystart-dropdown schoollist " + currentKeyword + "'>" +
														"	<div class='selector'>" + currentSelector + "</div>" +
														"	<div class='sw-dropdown'>" +
														"		<div class='sw-dropdown-selected'>" + currentSelector + "</div>" +
														"		<ul class='sw-dropdown-list'>" +
														"		</ul>" +
														"	</div>" +
														"	<div class='sw-dropdown-arrow'></div>" +
														"</div>";
								$(element).parent().append(currentStructure);
								//Add Headings
								if (config.useHeadings == "yes") {
									$("ul.sw-dropdown-list li." + currentKeyword + "", element).eq(0).before("<li class='" + currentKeyword +" heading'><a href='#'>" + currentKeyword + " Schools</a></li>");	
								}
								$("ul.sw-dropdown-list li." + currentKeyword + "", element).each(function() {
									$(this).appendTo("div.sw-mystart-dropdown.schoollist." + currentKeyword + " ul.sw-dropdown-list");
								});
							}
							//Do Alternates
							var currentStructure =  "<div class='sw-mystart-dropdown schoollist Alternate'>" +
														"	<div class='selector'>" + config.leftoversHeading + "</div>" +
														"	<div class='sw-dropdown'>" +
														"		<div class='sw-dropdown-selected'>" + config.leftoversHeading + "</div>" +
														"		<ul class='sw-dropdown-list'>" +
														"		</ul>" +
														"	</div>" +
														"	<div class='sw-dropdown-arrow'></div>" +
														"</div>";
							$(element).parent().append(currentStructure);
							//Add Headings
							if (config.useHeadings == "yes") {
								$("ul.sw-dropdown-list li.Alternate", element).eq(0).before("<li class='Alternate heading'><a href='#'>" + config.leftoversHeading + " Schools</a></li>");	
							}
							$("ul.sw-dropdown-list li.Alternate", element).each(function() {
								$(this).appendTo("div.sw-mystart-dropdown.schoollist.Alternate ul.sw-dropdown-list");
							});
						} else {
							for(var i = 0; i < config.keywords.length; i++){
								var currentKeyword = config.keywords[i];
								var currentSelector = config.dropdownSelectorText[i];
								if(currentSelector == undefined){
									currentSelector = "Select A School...";
								}
								var currentStructure =  "<div class='sw-mystart-dropdown schoollist " + currentKeyword + "'>" +
														"	<div class='selector'>" + currentSelector + "</div>" +
														"	<div class='sw-dropdown'>" +
														"		<div class='sw-dropdown-selected'>" + currentSelector + "</div>" +
														"		<ul class='sw-dropdown-list'>" +
														"		</ul>" +
														"	</div>" +
														"	<div class='sw-dropdown-arrow'></div>" +
														"</div>";
								$(element).parent().append(currentStructure);
								//Add Headings
								if (config.useHeadings == "yes") {
									$("ul.sw-dropdown-list li." + currentKeyword + "", element).eq(0).before("<li class='" + currentKeyword +" heading'><a href='#'>" + currentKeyword + " Schools</a></li>");	
								}
								$("ul.sw-dropdown-list li." + currentKeyword + "", element).each(function() {
									$(this).appendTo("div.sw-mystart-dropdown.schoollist." + currentKeyword + " ul.sw-dropdown-list");
								});
							}
						}
						$("div.sw-mystart-dropdown.schoollist").eq(0).remove();
					} else {
						if (hasAlternates == 1) {
							for(var i = 1; i <= config.numOfDropdowns; i++){
								var currentSelector = config.dropdownSelectorText[i - 1];
								if(currentSelector == undefined){
									currentSelector = "Select A School...";
								}
								var currentStructure =  "<div class='sw-mystart-dropdown schoollist multiples'>" +
														"	<div class='selector'>" + currentSelector + "</div>" +
														"	<div class='sw-dropdown'>" +
														"		<div class='sw-dropdown-selected'>" + currentSelector + "</div>" +
														"		<ul class='sw-dropdown-list'>" +
														"		</ul>" +
														"	</div>" +
														"	<div class='sw-dropdown-arrow'></div>" +
														"</div>";
								$(element).parent().append(currentStructure);
							}
							for(var i = 0; i < config.keywords.length; i++){
								var currentKeyword = config.keywords[i];
								for(var j = 0; j < config.keywords.length; j++){
									if(currentKeyword == config.keywordsInDropdowns[j][0]){
										var currentDropdown = parseInt(config.keywordsInDropdowns[j][1]);
									}
								}
								//Add Headings
								if (config.useHeadings == "yes") {
									$("ul.sw-dropdown-list li." + currentKeyword + "", element).eq(0).before("<li class='" + currentKeyword +" heading'><a href='#'>" + currentKeyword + " Schools</a></li>");	
								}
								$("ul.sw-dropdown-list li." + currentKeyword + "", element).each(function() {
									$(this).appendTo($("div.sw-mystart-dropdown.schoollist ul.sw-dropdown-list").eq(currentDropdown));
								});
							}
							//Do Alternates
							var currentStructure =  "<div class='sw-mystart-dropdown schoollist Alternate'>" +
														"	<div class='selector'>" + config.leftoversHeading + "</div>" +
														"	<div class='sw-dropdown'>" +
														"		<div class='sw-dropdown-selected'>" + config.leftoversHeading + "</div>" +
														"		<ul class='sw-dropdown-list'>" +
														"		</ul>" +
														"	</div>" +
														"	<div class='sw-dropdown-arrow'></div>" +
														"</div>";
							$(element).parent().append(currentStructure);
							//Add Headings
							if (config.useHeadings == "yes") {
								$("ul.sw-dropdown-list li.Alternate", element).eq(0).before("<li class='Alternate heading'><a href='#'>" + config.leftoversHeading + " Schools</a></li>");	
							}
							$("ul.sw-dropdown-list li.Alternate", element).each(function() {
								$(this).appendTo("div.sw-mystart-dropdown.schoollist.Alternate ul.sw-dropdown-list");
							});
						} else {
							for(var i = 1; i <= config.numOfDropdowns; i++){
								var currentSelector = config.dropdownSelectorText[i - 1];
								if(currentSelector == undefined){
									currentSelector = "Select A School...";
								}
								var currentStructure =  "<div class='sw-mystart-dropdown schoollist multiples'>" +
														"	<div class='selector'>" + currentSelector + "</div>" +
														"	<div class='sw-dropdown'>" +
														"		<div class='sw-dropdown-selected'>" + currentSelector + "</div>" +
														"		<ul class='sw-dropdown-list'>" +
														"		</ul>" +
														"	</div>" +
														"	<div class='sw-dropdown-arrow'></div>" +
														"</div>";
								$(element).parent().append(currentStructure);	
							}
							for(var i = 0; i < config.keywords.length; i++){
								var currentKeyword = config.keywords[i];
								for(var j = 0; j < config.keywords.length; j++){
									if(currentKeyword == config.keywordsInDropdowns[j][0]){
										var currentDropdown = parseInt(config.keywordsInDropdowns[j][1]);
									}
								}
								//Add Headings
								if (config.useHeadings == "yes") {
									$("ul.sw-dropdown-list li." + currentKeyword + "", element).eq(0).before("<li class='" + currentKeyword +" heading'><a href='#'>" + currentKeyword + " Schools</a></li>");	
								}
								$("ul.sw-dropdown-list li." + currentKeyword + "", element).each(function() {
									$(this).appendTo($("div.sw-mystart-dropdown.schoollist ul.sw-dropdown-list").eq(currentDropdown));
								});
							}
						}
						$("div.sw-mystart-dropdown.schoollist").eq(0).remove();
					}
				}
			}
		});
	};
})(jQuery);