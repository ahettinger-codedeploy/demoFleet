function BookMark()
{
	var pagetitle_str = "Artivist Film Festival"; // default title
	var title_nodes = document.getElementsByTagName("title");
	if (null != title_nodes) { if (null != title_nodes[0].innerHTML) { pagetitle_str = title_nodes[0].innerHTML  } }
	
	// bookmark
	if (window.external) { window.external.AddFavorite(document.location.href, pagetitle_str); }
	else if (window.sidebar) { window.sidebar.addPanel(pagetitle_str, document.location.href, ""); }
	else { alert("Presee Ctrl+D to Bookmark this Page."); }
}

function TodaysDate()
{
	var todaysdate_node = document.getElementById("TodaysDate");
	if (null != todaysdate_node)
	{
		var m_names = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		var d_names = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
		
		var d = new Date();
		var curr_year = d.getFullYear();
		var curr_month = d.getMonth();
		var curr_date = d.getDate();
		var curr_day = d.getDay();

		todaysdate_node.innerHTML = d_names[curr_day] + " " + m_names[curr_month] + " " + curr_date + ", " + curr_year;
	}
}