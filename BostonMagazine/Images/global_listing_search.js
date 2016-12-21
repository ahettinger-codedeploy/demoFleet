$(document).ready(function(){

	/*Intitialize*/
	loadGLContent();
	loadGLLines();
	$(".listings").show();	

	/*All Link Submit*/
	$(".all_link").click(function(){
		var form_id = $(this).attr("title");
		$("#"+form_id).submit();
		return false;
	});

	/*Href Form Submit*/
	$(".gl_link").click(function(){
		var form_id = $(this).attr("title");

		var id = $(this).attr("id");
		if(id){
			var variables = id.split(",");
			jQuery.each(variables, function() {
				var tmp = this.split("::");
				var field = tmp[0];
				var value = tmp[1];
				/*Set Vars*/
				$("#"+field).val(value);
			});
		}		

		/*Submit Form*/
		$("#"+form_id).submit();
		return false;
	});
		

	/*Show|Hide Content*/
	$(".title_type").click(function(){
		var id = $(this).attr("id");
		var re = /(\w+)_(\d+)/i;
		var content = id.match(re);
		content_id = "#gl_content_"+parseInt(content[2]);

		var display = $(content_id).css("display");  
		if(display == 'block'){
			$("#"+id).removeClass("title_type_arrow_down");
			$("#"+id).addClass("title_type_arrow_right");
			$(content_id).hide();
		}else{
			$("#"+id).removeClass("title_type_arrow_right");
			$("#"+id).addClass("title_type_arrow_down");
			$(content_id).show();
		}

		/*Set Cookie*/
		setGLContentCookie();
	});

	function setGLContentCookie(){
		var content_boxes = $(".gl_content");
		var i=0;
		var gl_content_hide = new Array();
		jQuery.each(content_boxes, function() {
			var box_id = $(this).attr("id");
			var re = /(\w+)_(\d+)/i;
			var content = box_id.match(re);
			var box_num = parseInt(content[2]); 
			var content_id = "#gl_content_"+box_num;
			var display = $(content_id).css("display");  
			if(display == 'none'){
				gl_content_hide[i] = box_num;
				i++;
			}
		});
		var gl_content_cookie = gl_content_hide.join(",");
		$.cookie("gl_content",gl_content_cookie,{expires:7,path:'/'});
	}

	function loadGLContent(){
		var gl_content_cookie = $.cookie("gl_content");

		//Set Data
		if(gl_content_cookie){
			var gl_content_hide = gl_content_cookie.split(",");
		}else{
			var node_idx = parseInt($("#node_idx").html());
			switch(node_idx){ 
				case 97:
					/*Boston Home*/
					var gl_content_hide = new Array();
					break;
				case 196: 
					/*Philly Home*/
					var gl_content_hide = new Array(2,3,4,5,6,11);
					break;
			}
		}

		//No Data
		if(!gl_content_hide){
			return;
		}

		/*Set Display Attributes*/
		showGobalListings();
		jQuery.each(gl_content_hide, function() {
			/*Hide*/
			var gl_content_id = "#gl_content_"+this;
			$(gl_content_id).hide();
			/*Arrow*/
			var gl_title_id = "#gl_title_"+this;
			$(gl_title_id).removeClass("title_type_arrow_down");
			$(gl_title_id).addClass("title_type_arrow_right");
		});
	}

	function showGobalListings(){
		$(".title_type").show();
	}

	function hideGobalListings(){
		$(".title_type").hide();
	}

	/*Show|Hide Lines*/
	$(".gl_lines").click(function(){
		var id = $(this).attr("id");
		var re = /(\w+)_(\d+)_(\d+)/i;
		var content = id.match(re);
		var cnt = parseInt(content[2]); 
		var line_cnt = parseInt(content[3]);
		content_id = "#gl_content_"+cnt;
		content_item_id = "#gl_content_item_"+cnt+"_"+line_cnt;
		lines_id = "#gl_lines_"+cnt+"_"+line_cnt;
		lines_content_id = "#gl_lines_content_"+cnt+"_"+line_cnt;

		var classes = $(lines_id).attr("class");  

		var display = $(lines_content_id).css("display");  
		if(display == 'block'){
			$(content_item_id).removeClass("arrow_down");
			$(content_item_id).addClass("arrow_right");
			$(lines_content_id).hide();
		}else{
			$(content_item_id).removeClass("arrow_right");
			$(content_item_id).addClass("arrow_down");
			$(lines_content_id).show();
		}

		/*Set Cookie*/
		setGLLinesCookie();
	});

	function setGLLinesCookie(){
		var content_boxes = $(".lines");
		var i=0;
		var gl_lines_content_hide = new Array();
		jQuery.each(content_boxes, function() {
			var box_id = $(this).attr("id");
			if(box_id){
				var re = /(\w+)_(\d+)_(\d+)/i;
				var content = box_id.match(re);
				var cnt = parseInt(content[2]); 
				var lines_cnt = parseInt(content[3]); 
				var content_id = "#gl_lines_content_"+cnt+"_"+lines_cnt;
				var display = $(content_id).css("display");
				if(display == 'none'){
					gl_lines_content_hide[i] = cnt+"_"+lines_cnt;
					i++;
				}
			}
		});
		var gl_lines_content_cookie = gl_lines_content_hide.join(",");
		$.cookie("gl_lines_content",gl_lines_content_cookie,{expires:7,path:'/'});
	}

	function loadGLLines(){

		var gl_lines_content_cookie = $.cookie("gl_lines_content");

		if(gl_lines_content_cookie){
			var gl_content_hide = gl_lines_content_cookie.split(",");
		}else{
			var node_idx = parseInt($("#node_idx").html());
			switch(node_idx){ 
				case 97:
					/*Boston Home*/
					var gl_content_hide = new Array('1_2','2_2','3_2','4_2','5_2','6_2');
					break;
				case 196: 
					/*Philly Home*/
					var gl_content_hide = new Array('1_2');
					break;
			}
		}

		if(!gl_content_hide){
			return;
		}

		/*Set Display Attributes*/
		showGobalListings();
		jQuery.each(gl_content_hide, function() {
			/*Hide*/
			var gl_lines_content_id = "#gl_lines_content_"+this;
			$(gl_lines_content_id).hide();
			/*Arrow*/
			var gl_content_item_id = "#gl_content_item_"+this;
			$(gl_content_item_id).removeClass("arrow_down");
			$(gl_content_item_id).addClass("arrow_right");
		});

	}

});
