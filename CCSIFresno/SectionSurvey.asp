<%

'CHANGE LOG - Inception
'SSR 6/7/2011
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 1113
SurveyFileName = "SectionSurvey.asp"

'===============================================

'Omaha Fashion Week (6/7/2011)

'Survey restricts purchase single seat purchase of table seats.
'Patron must purchase each seat at the table.
'Survey looks at both the section color and the section name
'because not all seats in the that section color are restricted

'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.

If Session("OrderNumber") = "" Then

	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If
	
Else

	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If
	
End If

Call TableCheck

'===============================================

Sub TableCheck

SQLOrderSeats = "SELECT Seat.EventCode, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color = '1BLUE' AND Left(Section.Section,3) = 'VIP' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

If Not rsOrderSeats.EOF Then

    Do Until rsOrderSeats.EOF

	    SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
	    Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
    	
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")	    
	    
	    SectionSeatCount = rsSectionSeats("SectionSeatCount")
	    
	    If OrderSeatCount < SectionSeatCount Then 'Not all seats were selected.  Go to warning page
    	
		    rsSectionSeats.Close
		    Set rsSectionSeats = nothing
    		
		    Call WarningPage
    		
		    Exit Sub
    					
	    End If
    				
	    rsSectionSeats.Close
	    Set rsSectionSeats = nothing
    	
    rsOrderSeats.MoveNext
    Loop

End If
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

Call Continue

End Sub 'TableCheck

'=================================

Sub WarningPage

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= title %></title>

<%

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "omahafashionweek"
End If

%>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 400px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 15px;
	padding-right: 15px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: center;
}
#rounded-corner td.data-left
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 15px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: left;
}
#rounded-corner td.data-right
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 15px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: right;
}
</style>

</head>
<body>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->


<table id="rounded-corner" summary="surveypage" >
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><b>SORRY</b></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>

<%

ErrorLog("Line Number 222")

SQLOrderSeats = "SELECT Seat.EventCode, Seat.SectionCode, Section.Section, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color = '1BLUE' AND Left(Section.Section,3) = 'VIP' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

If Not rsOrderSeats.EOF Then

    Do Until rsOrderSeats.EOF

        SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
        Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)  	
    	
	    OrderEventCode = rsOrderSeats("EventCode")
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")
	    OrderSection = rsOrderSeats("Section")	    
	    SectionSeatCount = rsSectionSeats("SectionSeatCount")

	    If OrderSeatCount < SectionSeatCount Then 'Not all seats were selected.  Go to warning page
	    
	    RemainingSeatCount = (SectionSeatCount - OrderSeatCount)
	   
        If OrderSeatCount = 1 Then
	         s1 = ""
        Else
	         s1 = "s"
        End If

        If RemainingSeatCount = 1 Then
            RemainingSeatCount = ""
	        s2 = ""
        Else
	         s2 = "s"
        End If
    	
    	%>
        <tr>
            <td colspan = 4 class="data">
                You have only selected <b><%= rsOrderSeats("OrderSeatCount") %> seat<%=s1%></b> at <%= rsOrderSeats("Section") %>.
                <br />
                <br />
                Please select the remaining <%= RemainingSeatCount %> seat<%=s2%>.
            </td>
        </tr>
        <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer" colspan="2">&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
    	<%
    	
    	OrderSectionCode = rsOrderSeats("SectionCode")
    	
    					
	    End If
    				
	    rsSectionSeats.Close
	    Set rsSectionSeats = nothing
    	
    rsOrderSeats.MoveNext
    Loop

End If
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

If Session("UserNumber") = "" Then 'Internet order
%> 
<tr>
    <td colspan=4 class="schedule">
    <center><br />
    <FORM ACTION="/Section.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form5" name="form2"/>
    <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit5" name="form2" style="width:12em;">
    </FORM>   

    <FORM ACTION="/ShoppingCart.asp" METHOD="POST" id="form6" name="form1">
    <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit6" name="form1" style="width:12em;" />
    </FORM>
    </center>
    </td>
</tr>
<%
Else 'Box Office Order
%> 
<tr>
    <td colspan=4 class="schedule">
    <center><br />
    <FORM ACTION="/Management/SectionRowSelect.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form7" name="form1" />
    <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit7" name="form1" style="width:12em;">
    </FORM>

    <FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id="form8" name="form2">
    <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit8" name="form2" style="width:12em;" />
    </FORM>
    </center>
    </td>
</tr>  
<%
End If
%> 
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%		
	
End Sub 'Warning Page

'========================================

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'=================================
%>



