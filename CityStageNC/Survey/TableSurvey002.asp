<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

Page = "Survey"
SurveyNumber = 906
SurveyName = "TableSurvey.asp"

'========================================

'Cape Fear (12/3/2010)

'Survey restricts purchase single purchase of table seats.
'Patron must purchase each seat at the table.

'========================================


'Check to see if Order Number exists.  
Check to see if User Number exists.

'If there is a User Number (But not Call Center User)
'Then bypass the survey restriction

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If
Else
	If Session("UserNumber") = "" Then
		Call TableCheck
    ElseIf Session("UserNumber") = 24 Then
		Call TableCheck
	Else
	    Page = "Management"
	    Call Continue
	End If
End If



'========================================

Sub TableCheck

SQLOrderSeats = "SELECT Seat.EventCode, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color = 'DARKBLUE' AND Left(Seat.SectionCode,3) = 'TBL' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode"
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



<style type="text/css"> 
body
{
font-family: Arial Verdana, Sans-serif;}
}
.category 
{ 	
padding-top:5px; 
padding-bottom:5px; 
padding-left:5px; 
padding-right:5px; 

text-align: left;
font-size: medium;
font-weight: 700;

border-width:10px;
border-style:solid;
border-color: transparent;
border-collapse:collapse;
}
.data
{ 
padding-top: 5px; 
padding-bottom: 5px; 
padding-left: 5px; 
padding-right: 5px; 

text-align: center;
font-size: x-small;
font-weight: 400;

border-width: 10px;
border-style: solid;
border-color: transparent;
border-collapse: collapse;
}
.schedule
{ 	
padding-top: 5px; 
padding-bottom: 5px; 
padding-left: 5px; 
padding-right: 5px; 

text-align: center;
font-size: x-small;
font-weight: 400;

border-width: 10px;
border-style: solid;
border-color: transparent;
border-collapse: collapse;
}
</style>

<% If Session("UserNumber")<> "" Then %>

<style type="text/css">
.category 
{ 
background-color: #008400;
color: #ffffff;
}
.data
{ 
background-color: #f1f1f1;
color: #000000;
}
.schedule
{ 
background-color: #ffffff;
color: #000000;
}
</style>

<% Else %>

<style type="text/css">
.category 
{ 
background-color: <%=TableCategoryBGColor%>;
color: <%=TableCategoryFontColor%>;
}
.data
{ 
background-color: <%=TableDataBGColor%>;
color: <%=TableDataFontColor%>;
}
.schedule
{ 
background-color: <%=BGColor%>;
color: <%=FontColor%>;
}
</style>

<% End If %>

</head>
<body>

<%= strBody %>
<!--#include virtual="TopNavInclude.asp"-->

<table width=500 cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td class="category">SORRY</td>
    </tr>

<%

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') AND Section.Color = 'DARKBLUE' AND Left(Seat.SectionCode,3) = 'TBL' GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
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
            <td class="data">
                You have only selected <b><%= rsOrderSeats("OrderSeatCount") %> seat<%=s1%></b> at <%= rsOrderSeats("Section") %>.
                <br />
                <br />
                Please select the remaining <%= RemainingSeatCount %> seat<%=s2%>.
            </td>
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
    <td class="schedule">
    <FORM ACTION="/Section.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form5" name="form2"/>
    <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit5" name="form2" style="width:12em;">
    </FORM>   

    <FORM ACTION="/ShoppingCart.asp" METHOD="POST" id="form6" name="form1">
    <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit6" name="form1" style="width:12em;" />
    </FORM>
    </td>
</tr>
<%
Else 'Box Office Order
%> 
<tr>
    <td class="schedule">
    <FORM ACTION="/Management/SectionRowSelect.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form7" name="form1" />
    <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit7" name="form1" style="width:12em;">
    </FORM>

    <FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id="form8" name="form2">
    <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit8" name="form2" style="width:12em;" />
    </FORM>
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



