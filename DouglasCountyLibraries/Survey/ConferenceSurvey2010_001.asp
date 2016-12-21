<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

'Douglas County Libraries Foundation (8/09/2010)
'===============================================
'Event Add On Survey

'UPDATE:  If a customer buys any ticket to 
'Douglas County Libraries Writers Conference a
'second survey page will display to ask for a meal selection 


'Douglas County Libraries Foundation (7/22/2010)
'===============================================
'Event Add On Survey

'If a customer buys 1 "Conference + Pitch" ticket to
'Douglas County Libraries Writers Conference

'they are offered 1 "Pitch Session" ticket to any of these acts:

'ActCode    ActName             EventCount
'53246      Natalie Fischer     24 events
'53247      Anita Mumm          12 events
'53245      Terrie Wolf         24 events


'ratio of tickets in offer is 1-to-1
'offered event tickets are not discounted
'offered event tickets incurr no change in per ticket service fees
'offered event is not listed if no available seats
'patron will be sent back to shopping cart if no available seats

'===================================================

'Survey Variables

Page = "Survey"
SurveyNumber = 816
SurveyFileName = "ConferenceSurvey2010.asp"

RequiredEvent = 286720 'Douglas County Libraries Writers Conference 
RequiredSeatType = 4568 'Conference plus Agent Pitch Session
RequiredCount = 1

OfferActList = "53245,53246,53247" 'Natalie Fischer, Terrie Wolf, Anita Mumm
OfferSeatType = 4579 'Agent Pitch Session
OfferSection =  "GA" 'General Admission

Lunch01 = "On a Roll"
Lunch02 = "Wrap it Up"                   
Lunch03 = "Greek Isle Salad Bowl"
Lunch04 = "Greek Isle Salad Bowl w/Chicken"

'===============================================

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Clean(Request("FormName")) = "EventOffer" Then
	index = 1
	ErrorLog("EventCode: " & EventCode & " ")
	For Each EventCd In Request("EventCode")
	    If Request("Quantity")(index) <> "" And Request("Quantity")(index) <> "0" Then
	        Call EventListUpdate(CleanNumeric(Request("EventCode")(index)), Clean(Request("SectionCode")(index)), CleanNumeric(Request("Quantity")(index)), CleanNumeric(Request("SeatTypeCode")(index)))
	    End If
	    index = index + 1
	Next
	
	Call Continue
	
ElseIf Clean(Request("FormName")) = "MealListUpdate" Then
    Call MealListUpdate
    
Else
    Call MealList
    
End If

'========================================

Sub MealList

SQLTicketCount = "SELECT Count(LineNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & RequiredEvent & ""
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TotalTix = rsTicketCount("TotalTix")
rsTicketCount.Close
Set rsTicketCount = nothing

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= title %></title>

<SCRIPT LANGUAGE="JavaScript"'> 

<!-- Hide code from non-js browsers

function validateForm(){
if(document.Survey.["Lunch[]"].selectedIndex==0)
{
alert("Please select a meal.");
document.Survey.["Lunch[]"].focus();
return false;
}
return true;
}
// end hiding -->
</SCRIPT> 

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<table width="550" border="0" cellpadding="0" cellspacing="0">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td colspan="3" align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
    <B>Boxed Lunch Menu</B></FONT>
    </td>
</tr>
<tr>
    <td align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="1">
    <br />
    <B>On a Roll</b><br />
    Ham and Swiss Deli Sandwich on a Kaiser roll<br />
    Whole Fresh Fruit<br />
    Fudge Brownie<br />
    Potato Salad<br />
    Beverage<br />
    After Lunch Mint<br />
    <br />
    </td>
    <td>&nbsp;&nbsp;</td>
    <td align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="1">
    <br />
    <b>Wrap it Up</b><br />
    Roasted Chicken, Cheese<br />
    & Veggie Wrap w/Honey Mustard<br />
    Whole Fresh Fruit<br />
    Chocolate Chip Cookie<br />
    Chips<br />
    Beverage<br />
    After Lunch Mint<br />
    <br />
    </td>
<tr>
    <td align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="1">
    <b>Greek Isle Salad Bowl</b><br />
    mixed spring greens and romaine<br />
    tossed with feta, parmesan and romano cheeses,<br />
    fresh grape halves, broccoli, cauliflower,<br />
    sunflower seeds  and Italian honey dressing (gluten free)<br />
    Served with or without Chicken as requested<br />
    Whole Fresh Fruit Rice Pudding Cup<br />
    After Lunch Mint
     </td>
    <td>&nbsp;&nbsp;</td>
    <td align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="1">
    <B>Signature Storybook Salad Bowl</B><br />
    Baby spinach leaves and sliced strawberries tossed w/chopped sugared pecans<br />
    accompanied by our house poppy seed dressing (gluten free)<br />
    Served With or Without Roasted Chicken <br />
    Whole Fresh Fruit<br />             
    Rice Pudding Cup<br />                                                                                                                               
    Beverage<br />
    After Lunch Mint
    </td>
</tr>
</table>
<Br />
<br />

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="MealListUpdate">

<table width="300" border="0" cellpadding="0" cellspacing="0">
<tr bgcolor="<%=TableColumnHeadingBGColor%>">
    <td colspan="3" align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%=TableColumnHeadingFontColor%>" SIZE="4">
    <B>Your Meal Choice</B></FONT>
    </td>
</tr>
<tr>
    <td colspan="3">&nbsp;</td>
</tr>
<% 
    For i = 1 To TotalTix
%>
<tr>
    <td rowspan=2 width="5%" valign="middle" align="center">
        <FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2">
        <!--Line Number -->
        <h3><%=i%></h3>
    </td>
    <td >
        <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
        &nbsp;&nbsp;
    </td>
    <td >
        <br />
        <!--Meal Choice -->
         <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
        <select name="Lunch<%=i%>">
        <option value="0">Please select...</option> 
        <option value="<%=Lunch01%>" class=""><%=Lunch01%></option> 
        <option value="<%=Lunch02%>" class=""><%=Lunch02%></option> 
        <option value="<%=Lunch03%>" class=""><%=Lunch03%></option>
        <option value="<%=Lunch04%>" class=""><%=Lunch04%></option>
        </select>
        <br />
        <br />
    </td>
</tr>
<tr>
    <td colspan="3">
        <HR />
    </td>
</tr>
<%
    Next
%>    
</table>
<br />
<input type="submit" value="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%
End Sub ' SurveyForm

'================================

Sub MealListUpdate

    SQLTicketCount = "SELECT Count(LineNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & RequiredEvent & ""
    Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
    TotalTix = rsTicketCount("TotalTix")
    rsTicketCount.Close
    Set rsTicketCount = nothing

    For i = 1 To TotalTix
    
        If Request("Lunch" & i)   <> "" Then    
           
            'Insert selected events into survey
            SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & CleanNumeric(SurveyNumber) & ", " & CleanNumeric(Session("OrderNumber")) & ", " & CleanNumeric(Session("CustomerNumber")) & ", '" & Now() & "', " & i & ", '" & FixSingleQuotes(Request("Lunch" & i)) & "', '" & Clean("lunch") & "')"
            Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)	    
	    End If
		
    Next

    
    Call EventList  
  
End Sub   

'================================

function FixSingleQuotes(byval strString)
    Dim intIndex
    intIndex = Instr(strString, "'")
    While intIndex > 0 
    strString = Mid(strString,1,intIndex) & "'" & Mid(strString,intIndex+1)
    intIndex = InStr(intIndex+2, strString, "'")
    Wend
    FixSingleQuotes = strString
End function

'================================

Sub EventList

'Check order for required event and ticket type
SQLEventCheck = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEvent & " AND OrderLine.SeatTypeCode = " & RequiredSeatType & " AND OrderLine.ItemType = 'Seat' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsEventCheck = OBJdbConnection.Execute(SQLEventCheck)

If Not rsEventCheck.EOF Then
    
    'Check for available offer seats
    SQLOfferCheck = "SELECT COUNT(Seat.ItemNumber) AS OfferCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.Actcode IN (" & OfferActList & ") AND Seat.SectionCode IN ('" & OfferSection & "') AND Event.EventDate > GETDATE() AND Seat.StatusCode = 'A'"
    Set rsOfferCheck = OBJdbConnection.Execute(SQLOfferCheck)
    
        If Not rsOfferCheck.EOF Then   
            
            If rsEventCheck("TicketCount") > rsOfferCheck("OfferCount") Then
                Call OfferOut
            Else
                TotalTix = rsEventCheck("TicketCount")
            End If
            
        Else
            Call OfferOut
        End If 
        
    rsOfferCheck.Close
    Set rsOfferCheck = nothing

Else
    Call Continue
End If

rsEventCheck.Close
Set rsEventCheck = nothing

      
If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= title %></title>

<SCRIPT LANGUAGE="JavaScript"'> 

<!-- Hide code from non-js browsers

function validateForm(){
if(document.Survey.EventCode.selectedIndex==0)
{
alert("Please select an agent pitch session.");
document.Survey.EventCode.focus();
return false;
}
return true;
}
// end hiding -->
</SCRIPT> 

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
<center>
<table width="550" border="0" cellpadding="0" cellspacing="0">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td colspan="3" align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
    <B>Available Agent Sessions</B></FONT><br />
    <FONT FACE="<%= FontFace %>" COLOR="<%= TableCategoryFontColor%>" SIZE="2">
    Please select your agent pitch session(s) below</FONT><br />
    </td>
</tr>
<%

For i = 1 To TotalTix

%>
<tr>
    <td rowspan=2 width="5%" valign="middle" align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="3"><h3><%=i%></h3><br /><br />
    </td>
    <td ><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">&nbsp;&nbsp;</td>
    <td >
    <br />
    <SELECT NAME="EventCode">
    <OPTION VALUE="0"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">--Select Session--</FONT></OPTION><BR />
<% 
    SQLPackages = "SELECT Event.EventCode, Event.EventDate, Act.Act FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.ActCode IN(" & OfferActList & ") AND Event.EventDate > GETDATE() ORDER BY Event.EventDate"
    Set rsPackages = OBJdbConnection.Execute(SQLPackages)
        
    If Not rsPackages.EOF Then
        
        Do While Not rsPackages.EOF 
        
        SQLCountAvail = "SELECT COUNT(Seat.ItemNumber) AS CountAvail FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.EventCode = " & rsPackages("EventCode") & " AND Seat.SectionCode IN ('GA') AND Seat.StatusCode = 'A' GROUP BY Event.EventCode"
        Set rsCountAvail = OBJdbConnection.Execute(SQLCountAvail)
        
        If Not rsCountAvail.EOF Then  
%>
        <OPTION VALUE="<%=rsPackages("EventCode")%>"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%>&nbsp;with&nbsp;<%= rsPackages("Act") %></OPTION>
        <INPUT TYPE="hidden" NAME="SessionList" VALUE="<%=OfferSeatType%>"> 
<%
        End If    
  
	    rsCountAvail.Close
	    Set rsCountAvail = nothing
	        
        i = i 
        rsPackages.movenext         
        Loop   
         
    End If 
                   
    rsPackages.Close
    Set rsPackages = Nothing
%>
    </SELECT>  
    <br />
    <br />
    </td>
</tr>
<tr>
    <td colspan="3" align="center"><HR /></td>
</tr>
    
    <INPUT TYPE="hidden" NAME="Quantity" VALUE="<%=RequiredCount%>">
    <INPUT TYPE="hidden" NAME="SectionCode" VALUE="<%=OfferSection%>">
    <INPUT TYPE="hidden" NAME="SeatTypeCode" VALUE="<%=OfferSeatType%>"> 
   
<%

Next 

%>
 
<tr>
<td colspan="3" align="center">
<INPUT type="submit" value="Add To Cart" /></form>
</td></tr>
</table>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'AddOnSurvey


'=================================

Sub OfferOut

%>      
<HTML>
<HEAD>
<TITLE><%= Title %></TITLE>
</HEAD>
<%= strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<center>
<table>
<tr>
<td>
<center>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Sorry</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2">
There are not enough available tickets for <b><i>Agent Pitch Sessions</b></i> to process your request.<br />
<br />
Please click the button below to update your order<br />
</td>
</tr>
</table>

<%

If Session("UserNumber") = "" Then
	Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form2 name=form1>" & vbCrLf
End If

Response.Write "<INPUT TYPE=""submit"" VALUE=""Shopping Cart"" id=""form1"" name=""form1""></FORM>" & vbCrLf
Response.Write "</CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf

%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</body>
</html>

<%	

		
End Sub 'Warning Page

'=======================================

Sub EventListUpdate(EventCode, SectionCode, OfferQuantity, SeatTypeCd)


SQLTicketCount = "SELECT Count(LineNumber)AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & RequiredEvent & ""
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TotalTix = rsTicketCount("TotalTix")
rsTicketCount.Close
Set rsTicketCount = nothing

For i = 1 To TotalTix

If Request("SessionList" & i)   <> "" Then    
   
    'Insert selected events into survey
    SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & CleanNumeric(SurveyNumber) & ", " & CleanNumeric(Session("OrderNumber")) & ", " & CleanNumeric(Session("CustomerNumber")) & ", '" & Now() & "', " & i & ", '" & FixSingleQuotes(Request("SessionList" & i)) & "', '" & Clean("SessionList") & "')"
    Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)	    
End If
	
Next

'================================


If Clean(SectionCode) <> "" Then
	SectionCode = Clean(SectionCode)
Else
	SectionCode = "GA"
End If

If Session("OrderNumber") <> "" Then 'There's an order number.  Check the status of the order.
	SQLOrderHeader = "SELECT StatusCode From OrderHeader WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)
	If rsOrderHeader("StatusCode") = "S" Then Session("OrderNumber") = "" 'If the order has been completed, clear the Session("OrderNumber") and create a new one.
	rsOrderHeader.Close
	Set rsOrderHeader = Nothing
End If

'Create an Order Header if Necessary
If Session("OrderNumber") = "" Then 
	If Session("CustomerNumber") = "" Then
		CustomerNumber = 1
	Else
		CustomerNumber = Session("CustomerNumber")
	End If

	If Session("OrderTypeNumber") = "" Then
		OrderTypeNumber = 1
	Else
		OrderTypeNumber = Session("OrderTypeNumber")
	End If

	'REE 11/24/2 - Added ExpirationDate to OrderHeader

	'Set Default Expiration to 30 minutes from now using TimeOffset.  UnReserve will catch it 30 minutes from now.
	OrderExpirationDate = DateAdd("n", 30 + (TimeOffset() * -1), Now())

	'Get TimeZone Offset for VenueOwner Organization
	SQLLocalOffset = "SELECT OrganizationOptions.OrganizationNumber, OptionValue AS LocalOffset FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationOptions (NOLOCK) ON OrganizationVenue.OrganizationNumber = OrganizationOptions.OrganizationNumber WHERE Event.EventCode = " & EventCode & " AND OrganizationVenue.Owner <> 0 AND OrganizationOptions.OptionName = 'TimeZoneOffset'"
	Set rsLocalOffset = OBJdbConnection.Execute(SQLLocalOffset)

	'JAI 4/12/5 - Open OBJdbConnection2 for Loop reads.
	Call DBOpen(OBJdbConnection2)

	If Not rsLocalOffset.EOF Then 'Get Expiration Delay for VenueOwner Organization
		SQLExpirationDelay = "SELECT OptionValue As ExpirationDelay FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & rsLocalOffset("OrganizationNumber") & " AND OptionName = 'OrderExpirationDelay'"
		Set rsExpirationDelay = OBJdbConnection2.Execute(SQLExpirationDelay)
		
		If Not rsExpirationDelay.EOF Then 'Set the ExpirationDate based on Offset and Delay
			OrderExpirationDate = DateAdd("n", (rsLocalOffset("LocalOffset") - TimeOffset()) + rsExpirationDelay("ExpirationDelay"), Now())
		End If
		
		rsExpirationDelay.close
		Set rsExpirationDelay = nothing

	End If
	
	'JAI 4/12/5 - Close OBJdbConnection2
	Call DBClose(OBJdbConnection2)
	rsLocalOffset.close
	Set rsLocalOffset = nothing
	
	'REE 5/29/3 - Added the user IP Address
	IPAddress = Request.ServerVariables("REMOTE_ADDR")

	Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
	Set spInsertorderHeader.ActiveConnection = OBJdbConnection
	spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
	spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , CustomerNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , 0) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, IPAddress) 'As Varchar and Input
	spInsertOrderHeader.Execute

	Session("OrderNumber") = spInsertOrderHeader.Parameters("OrderNumber")

	If Session("OrderNumber") = 0 Then
		Message = "There was a problem processing your request.  Please try again later."
		ErrorLog(Message)
		Call AddOnSurvey
		Exit Sub
	End If

End If

'**********************
'Reserve the seats
'**********************
'REE 11/29/6 - Modified to include SubFixedEvent in count
SQLAvailable = "SELECT Count(LineNumber) AS ExistingSeats FROM Orderline (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Orderline.ItemNumber = Seat.ItemNumber WHERE Orderline.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & EventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
Set rsAvailable = OBJdbConnection.Execute(SQLAvailable)
ExistingSeatCount = rsAvailable("ExistingSeats")
rsAvailable.Close
Set rsAvailable = Nothing
TotalSeatCount = ExistingSeatCount + OfferQuantity

If TotalSeatCount <= MaxTickets Then 'Process Request

	EventType = ""
	SQLEventType = "SELECT EventType FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsEventType = OBJdbConnection.Execute(SQLEventType)
	If Not rsEventType.EOF Then
		EventType = rsEventType("EventType")
	End If
	rsEventType.Close
	Set rsEventType = nothing

	
	Select Case EventType
		Case "SubFixedEvent" 'Fixed Event Subscription

			Set spEventReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
			Set spEventReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
			spEventReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
			spEventReserveSeatsSubFixedEvent.Commandtext = "spEventReserveSeatsSubFixedEvent"
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SeatCount", 3, 1, , OfferQuantity) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeatsSubFixedEvent.Execute
			
			ReturnCode = spEventReserveSeatsSubFixedEvent.Parameters("ReturnCode")
		
		Case Else

			Set spEventReserveSeats = Server.Createobject("Adodb.Command")
			Set spEventReserveSeats.ActiveConnection = OBJdbConnection
			spEventReserveSeats.Commandtype = 4 ' Value for Stored Procedure
			spEventReserveSeats.Commandtext = "spEventReserveSeats"
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SeatCount", 3, 1, , OfferQuantity) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeats.Execute

			ReturnCode = spEventReserveSeats.Parameters("ReturnCode")
			
	End Select

	Select Case ReturnCode
		Case 0	'Stored Procedure executed properly.  Continue.
		
			For i = 1 To OfferQuantity

				'REE 6/21/5 - Added Seat Type Code to OrderLines.
				SQLPrice = "SELECT Price, PhoneOrderSurcharge, FaxOrderSurcharge, MailOrderSurcharge, BoxOfficeSurcharge, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & SeatTypeCd & " "
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
								
				Price = rsPrice("Price")
				
				Select Case Session("OrderTypeNumber")
                    Case 2
                    Surcharge = rsPrice("PhoneOrderSurcharge")
                    Case 3
                    Surcharge = rsPrice("FaxOrderSurcharge")
                    Case 4
                    Surcharge = rsPrice("MailOrderSurcharge")
                    Case 7
                    Surcharge = rsPrice("BoxOfficeSurcharge")
                    Case Else
                    Surcharge = rsPrice("Surcharge")
                End Select
										
				rsPrice.Close
				Set rsPrice = nothing
								
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & CleanNumeric(SeatTypeCd) & ", Price = " & Price & ", Surcharge = " & Surcharge & ", Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				
			
		Case Else
		
			Call EventList
			
	End Select
End If

End Sub

'==================================

Sub Continue
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
End Sub 'Continue

%>


