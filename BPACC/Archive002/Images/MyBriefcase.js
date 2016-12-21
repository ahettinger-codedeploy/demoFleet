function RemoveURLAjax(url) {
	return PageMethods.RemoveURL(url, 
        function(result) {
        	if (!result) {
        		$get("removeAll").style.display = 'none';
        		$get("next").style.display = 'none';
        		$get("noData").innerHTML = '<p class="empty">No Items</p>';
        	}
        }
    );
}

function RemoveURL() {
	var url = "";
	var markingBoxes = document.getElementsByName('removeItems');
	for (var j = 0; j < markingBoxes.length; j++) {
		if (markingBoxes[j].checked) {
			url = url + "," + markingBoxes[j].value;
			$get(markingBoxes[j].value).style.display = 'none';
		}
	}
	RemoveURLAjax(url);
}

function addToBriefcase() {
	var url = location.href;
	addLinkToBriefcase(url, true);
}

function addLinkToBriefcase(url, ispage) {
	AddToBriefCaseAjax(url, ispage);
}

function AddToBriefCaseAjax(url, isPage) {
	$.ajax({
		type: "POST",
		url: "/common/modules/MyBriefCase/MyBriefCase.aspx/AddToBriefCase",
		data: "{'url':'" + url + "', 'isPage':'" + isPage + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(result) {
			var temp = result.d;
			if (temp) {
				alert('This item has been added to your briefcase');
				var iframeURL = $('#MyBriefcaseDialog').attr('src');
				$('#MyBriefcaseDialog').attr('src', iframeURL);
			}
			else
				alert('This item already exists in your briefcase');
		}
	});
}