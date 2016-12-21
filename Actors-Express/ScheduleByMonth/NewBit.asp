<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "Schedule"
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>
</HEAD>
<%= strBody %>


<!--#INCLUDE virtual="TopNavInclude.asp" -->

<BR>

<%

	
'The New Bit


	
					Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""http://www.tix.com/images/clear.gif""></TD></TR>" & vbCrLf
    	
					Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR><H3> SUBSCRIPTIONS 2</H3></TD></TR>"
	        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><SIZE=2> <B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""http://www.tix.com/images/clear.gif""></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""http://www.tix.com/images/clear.gif""></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""http://www.tix.com/images/clear.gif""></TD></TR>" & vbCrLf
  
Link = "http://www.tix.com/Event.asp?Event=114632"
             
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""http://www.tix.com/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><SIZE=1><A HREF=" & Link & ">Subscription</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD><SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
    			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""http://www.tix.com/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""http://www.tix.com/images/clear.gif""></TD></TR>" & vbCrLf
			                      
Response.Write "</TABLE>"
	
	



%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%


%>

