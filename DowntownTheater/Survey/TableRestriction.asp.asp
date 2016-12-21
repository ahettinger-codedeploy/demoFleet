<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 922
SurveyName = "TableRestriction.asp"

'ErrorLog("Line Number 0")

'========================================

'Cape Fear (12/3/2010)

'Survey counts the number of seats at each table.
'Requires that patron purchase all seats within a table. 

SectionList = "M9,M10,M11,M12,M13,F1,F8" 'Event Section to exclude

'========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber")<> "" Then
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If

If Clean(Request("FormName")) = "Continue" Then
    Call Continue
Else
    Call TableCheck
End If

'========================================

Sub TableCheck

ErrorLog("Line Number 1")

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.SectionCode NOT IN ('" & SectionList & "') AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

Do Until rsOrderSeats.EOF

ErrorLog("Line Number =2")

	SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
	Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
	
	    OrderSection = rsOrderSeats("Section")
	    OrderSectionCode = rsOrderSeats("SectionCode")
	    OrderEventCode = rsOrderSeats("EventCode")	
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")
	    SectionSeatCount = rsSectionSeats("SectionSeatCount")
	    
	    ErrorLog("Line Number =3")


	    If OrderSeatCount < SectionSeatCount Then 'Not all seats were selected.  Go to warning page	
		    rsSectionSeats.Close
		    Set rsSectionSeats = nothing		
		    Call WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)		
		    Exit Sub
		Else
		    Call Continue	
		    Exit Sub		
	    End If
				
	rsSectionSeats.Close
	Set rsSectionSeats = nothing
	
	rsOrderSeats.MoveNext

Loop
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

Call Continue

End Sub	
				
'=================================

Sub WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

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

<html>
<head>
<title><%= title %></title>
<head>

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<table width="600" cellpadding="5" cellspacing="10">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td>
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="5">
        <b>SORRY</b></FONT>
    </td>
</tr>
<tr bgcolor="<%=TableDataBGColor%>">
    <td align="center"> 
            <FONT FACE="<%= FontFace %>" COLOR="<%=TableColumnBGColor%>" SIZE="2">
            You have only selected <%= OrderSeatCount %> seat<%=s1%> at <b> <%= OrderSection %> </b>.</FONT><BR>
			Section <%= OrderSection %> requires that you purchase the remaining <%= RemainingSeatCount %> seat<%=s2%>  within the section.<br>
            <br />
            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
            Please select the remaining <%= RemainingSeatCount %> seat<%=s2%> in order to complete your purchase.</FONT><br />
			<br />
			Please go 'Back To Shopping' to add the remaining seats in this section or remove this section entirely from your Shopping Cart to continue.<br>
			<br>
        <%
        If Session("UserNumber") = "" Then 'Internet order
        %> 
          <CENTER>
              <FORM ACTION="/Section.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form2" name="form2"/>
                <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit2" name="form2" style="width:12em;">
              </FORM>   

              <FORM ACTION="/ShoppingCart.asp" METHOD="POST" id="form1" name="form1">
                <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit1" name="form1" style="width:12em;" />
              </FORM>
          </CENTER>
        <%
        Else 'Box Office Order
        %> 
          <CENTER>
          <FORM ACTION="/Management/SectionRowSelect.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form3" name="form1" />
            <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit3" name="form1" style="width:12em;">
          </FORM>

          <FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id="form4" name="form2">
            <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit4" name="form2" style="width:12em;" />
          </FORM>
          </CENTER>   
        <%
        End If
        %> 
    </td>
</tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%		
	
End Sub 'Warning Page

'========================================

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'========================================

%> 
