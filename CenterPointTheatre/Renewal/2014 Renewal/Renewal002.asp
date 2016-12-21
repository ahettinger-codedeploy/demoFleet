<%
'CHANGE LOG
'JAI 7/11/13 -  Renewals for Centerpoint Legacy Theatre 2014.  Copied from generic.  Rogers Memorial (previous name)
%>
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<%

Server.ScriptTimeout = 60 * 30 '30 minutes
OBJdbConnection.CommandTimeout = 60 * 3 '3 Minutes
Call DBOpen(OBJdbConnection2)

'Allow Tix Users Only to run this
If Not CheckTixUser(Session("UserNumber")) Then
    Response.Redirect("/Management/Default.asp")
End If    

'----------------------------------------------
'Set Request Variables
ApplyDiscountFlag = UCase(Request("ApplyDiscount"))
RenewalCheckFlag = UCase(Request("RenewalCheck"))
IgnoreSoldTicketsFlag = UCase(Request("IgnoreSoldTickets"))
'------------------------------------------------------
'Set all Renewal variables

'Set user number equal to a specific Renewal Processing user set up for that client.
UserNumber = 18617 'Centerpoint Renewal Processing

'Set expiration date of order and the text to display in the IPAddress field.
OrderExpirationDate = "9/21/13"
RenewDescription = Left("CenterPoint2014", 15)

'Set Surcharge to be applied to all tickets
'If CalculateSurcharge = True, then the surcharge will be pulled from the correct renewal event/order type, seat type combination.
'CalculateSurcharge = True
Surcharge = 2.05

'Set delivery method and ship fee to be applied to all tickets
ShipCode = 4
ShipFee = 0

'Set order type to be applied to all orders
OrderTypeNumber = 7
BeginAfterOldOrderNumber = 0

'Apply a DiscountTypeNumber below if the orders are to have a discount applied.
'The Discount subroutine will use the same application logic as ShoppingCart
'The Discount must be applied to the organization and applicable events.
DiscountTypeNumber = 0

'First variable of EventArray must be updated to reflect the number of events from the previous year being renewed, minus 1.
'E.G., If there were two events previous year, the first number would be set to 1. 

Dim EventArray(47, 1)
EventArray(0,0) = 481619
EventArray(0,1) = 581356

EventArray(1,0) = 535073
EventArray(1,1) = 581356

EventArray(2,0) = 481620
EventArray(2,1) = 581374

EventArray(3,0) = 535080
EventArray(3,1) = 581374

EventArray(4,0) = 482932
EventArray(4,1) = 581976

EventArray(5,0) = 535082
EventArray(5,1) = 581976

EventArray(6,0) = 482941
EventArray(6,1) = 581364

EventArray(7,0) = 535081
EventArray(7,1) = 581364

EventArray(8,0) = 482947
EventArray(8,1) = 581343

EventArray(9,0) = 535083
EventArray(9,1) = 581343

EventArray(10,0) = 482962
EventArray(10,1) = 581369

EventArray(11,0) = 535084
EventArray(11,1) = 581369

EventArray(12,0) = 482925
EventArray(12,1) = 581360

EventArray(13,0) = 535085
EventArray(13,1) = 581360

EventArray(14,0) = 482912
EventArray(14,1) = 581375

EventArray(15,0) = 535088
EventArray(15,1) = 581375

EventArray(16,0) = 482935
EventArray(16,1) = 581977

EventArray(17,0) = 535091
EventArray(17,1) = 581977

EventArray(18,0) = 482944
EventArray(18,1) = 581365

EventArray(19,0) = 535094
EventArray(19,1) = 581365

EventArray(20,0) = 482948
EventArray(20,1) = 581348

EventArray(21,0) = 535097
EventArray(21,1) = 581348

EventArray(22,0) = 482963
EventArray(22,1) = 581370

EventArray(23,0) = 535100
EventArray(23,1) = 581370

EventArray(24,0) = 482926
EventArray(24,1) = 581361

EventArray(25,0) = 535086
EventArray(25,1) = 581361

EventArray(26,0) = 482914
EventArray(26,1) = 581398

EventArray(27,0) = 535089
EventArray(27,1) = 581398

EventArray(28,0) = 482937
EventArray(28,1) = 581978

EventArray(29,0) = 535092
EventArray(29,1) = 581978

EventArray(30,0) = 482945
EventArray(30,1) = 581366

EventArray(31,0) = 535095
EventArray(31,1) = 581366

EventArray(32,0) = 482949
EventArray(32,1) = 581352

EventArray(33,0) = 535098
EventArray(33,1) = 581352

EventArray(34,0) = 482965
EventArray(34,1) = 581371

EventArray(35,0) = 535101
EventArray(35,1) = 581371

EventArray(36,0) = 482928
EventArray(36,1) = 581363

EventArray(37,0) = 535087
EventArray(37,1) = 581363

EventArray(38,0) = 482917
EventArray(38,1) = 581400

EventArray(39,0) = 535090
EventArray(39,1) = 581400

EventArray(40,0) = 482939
EventArray(40,1) = 581979

EventArray(41,0) = 535093
EventArray(41,1) = 581979

EventArray(42,0) = 482946
EventArray(42,1) = 581368

EventArray(43,0) = 535096
EventArray(43,1) = 581368

EventArray(44,0) = 482950
EventArray(44,1) = 581353

EventArray(45,0) = 535099
EventArray(45,1) = 581353

EventArray(46,0) = 482966
EventArray(46,1) = 581373

EventArray(47,0) = 535102
EventArray(47,1) = 581373

For i = 0 To UBound(EventArray, 1)
    OldEventList = OldEventList & EventArray(i, 0) & ","
    NewEventList = NewEventList & EventArray(i, 1) & ","
Next
OldEventList = Left(OldEventList, Len(OldEventList) - 1)
NewEventList = Left(NewEventList, Len(NewEventList) - 1)

OrderCount = 0
TicketCount = 0
FailedCount = 0
DiscountCount = 0

'End of Renewal variables, but must also set SeatTypecodes in Function below
'--------------------------------------------------------

%>

<style type="text/css">
    
body, th, td
{
    font-family: "arial", "helvetica", Sans-Serif;
	font-size: 12px;
    line-height: 1 em;
}
th, td
{
    text-align: left;
}
</style>

<%

'Run Renewal steps
Response.Write "<b>Begin " & RenewDescription & " - " & Now() & "</b><BR><BR>"
Dim RenewalMismatch
RenewalMismatch = "N"
Call RenewalCheck()

If RenewalCheckFlag <> "Y" Then  'Do not run if only want renewal check
    If ApplyDiscountFlag = "Y" Then
        Call ApplyDiscount()
    Else
	    If RenewalMismatch <> "Y" Then
		    Call Renew()
	    End If	
	    If DiscountTypeNumber <> 0 Then
		    Call ApplyDiscount()
	    End If
    End If
	If OrderCount > 0 Or DiscountCount > 0 Then
		Call UpdateTotals()
	End If
End If

Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection)

Response.Write "<br /><b>End " & RenewDescription & " - " & Now() & "</b><BR>"
'End of run renewal steps


'-------------------------------------------------------------------
'The following lines must be manually modified before running this program.
'If there are any Seat Type conversions which need to take place, enter them here
'Otherwise, remove all Case statements other than Case Else
Public Function LookupNewSeatTypeCode(OldSeatTypeCode)

Select Case OldSeatTypeCode
Case 3 'Senior
	LookupNewSeatTypeCode = 307 'Senior/Student
Case Else
	LookupNewSeatTypeCode = OldSeatTypeCode
End Select

End Function



'----------------------------------------------------------------
Function LookupNewEventCode(OldEventCode)

For i = 0 To UBound(EventArray)
    If OldEventCode = EventArray(i, 0) Then
        LookupNewEventCode = EventArray(i, 1)
    End If
Next

End Function



'------------------------------------------------------------------------------------
Sub RenewalCheck()

For i = 0 To UBound(EventArray)

    LYEventCode = EventArray(i,0)
    TYEventCode = EventArray(i,1)

    SQLEvent = "SELECT Act FROM Act (NOLOCK) INNER JOIN Event (NOLOCK) ON Act.ActCode = Event.ActCode WHERE Event.EventCode = " & LYEventCode
    Set rsEvent = OBJdbConnection.Execute(SQLEvent)
    If Not rsEvent.EOF Then
        LYEvent = rsEvent("Act")
    Else
        LYEvent = "********************  Old Event Code Invalid  *******************"
    End If
    rsEvent.Close
    Set rsEvent = nothing
    SQLEvent = "SELECT Act FROM Act (NOLOCK) INNER JOIN Event (NOLOCK) ON Act.ActCode = Event.ActCode WHERE Event.EventCode = " & TYEventCode
    Set rsEvent = OBJdbConnection.Execute(SQLEvent)
    If Not rsEvent.EOF Then
        TYEvent = rsEvent("Act")
    Else
        TYEvent = "********************  Old Event Code Invalid  *******************"
    End If
    rsEvent.Close
    Set rsEvent = nothing

    Response.Write "<table><tr> " & vbCrLf 
    Response.Write "<td colspan=""3""><B>Renewal Events</b></td></tr>" & vbCrLf 
    Response.Write "<td>Old Event:</td><td>" & LYEventCode & "</td><td>" & LYEvent & "</td></tr>"
    Response.Write "<td>New Event:</td><td>" & TYEventCode & "</td><td>" & TYEvent & "</td></tr>"
    Response.Write "</table><br /> " & vbCrLf 

    SQLPrice = "SELECT DISTINCT LY.SeatTypeCode, LY.SeatType, LY.SectionCode, LY.Section FROM (SELECT Section.SectionCode, Section.Section, OrderLine.SeatTypeCode, SeatType.SeatType FROM Section (NOLOCK) INNER JOIN Seat (NOLOCK) ON Section.EventCode = Seat.EventCode AND Section.SectionCode = Seat.SectionCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE Seat.EventCode = " & LYEventCode & " AND Seat.StatusCode = 'S' GROUP BY OrderLine.SeatTypeCode, SeatType.SeatType, Section.SectionCode, Section.Section) AS LY LEFT JOIN (SELECT Section.SectionCode, Section.Section, SeatType.SeatTypeCode, SeatType.SeatType FROM Section (NOLOCK) INNER JOIN Price (NOLOCK) ON Section.EventCode = Price.EventCode AND Section.SectionCode = Price.SectionCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & TYEventCode & ") AS TY ON LY.SectionCode = TY.SectionCode AND LY.SeatTypeCode = TY.SeatTypeCode WHERE TY.SectionCode IS NULL"
	'ErrorLog( SQLPrice )
    Set rsPrice = OBJdbConnection.Execute(SQLPrice)
    Response.Write "<U><B>Price Records - Missing Section/SeatTypes</B></U><BR>" & vbCrLf
    Response.Write "<TABLE><TR><TH>Section Code</TH><TH>Section</TH><TH>Seat Type Code</TH><TH>Seat Type</TH></TR>" & vbCrLf

    If Not rsPrice.EOF Then
        Do Until rsPrice.EOF
            Response.Write "<TR><TD>" & rsPrice("SectionCode") & "</TD><TD>" & rsPrice("Section") & "</TD><TD>" & rsPrice("SeatTypeCode") & "</TD><TD>" & rsPrice("SeatType") & "</TD></TR>" & vbCrLf
            rsPrice.MoveNext
        Loop        
    Else
        Response.Write "<TR><TD COLSPAN=""4"">No Missing Price Records</TD></TR>" & vbCrLf
    
    End If

    Response.Write "</TABLE><br /><br />" & vbCrLf

    rsPrice.Close
    Set rsPrice = nothing
    
    SQLCheck = "SELECT DISTINCT LY.SectionCode, LY.Section, LY.Row, LY.Seat FROM (SELECT Seat.SectionCode, Section.Section, Row, Seat FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.EventCode = " & LYEventCode & " AND Seat.StatusCode = 'S') AS LY LEFT JOIN (SELECT Seat.SectionCode, Section.Section, Row, Seat FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.EventCode = " & TYEventCode & ") AS TY ON LY.SectionCode = TY.SectionCode AND LY.Row = TY.Row AND LY.Seat = TY.Seat WHERE TY.SectionCode IS NULL ORDER BY LY.SectionCode, LY.Row, LY.Seat"
    Set rsCheck = OBJdbConnection.Execute(SQLCheck)

    Response.Write "<U><B>Seat Records - Missing Seats</B></U><BR>" & vbCrLf
    Response.Write "<TABLE><TR><TH>Section Code</TH><TH>Section</TH><TH>Row</TH><TH>Seat</TH></TR>" & vbCrLf

    If Not rsCheck.EOF Then
        Do Until rsCheck.EOF
            Response.Write "<TR><TD>" & rsCheck("SectionCode") & "</TD><TD>" & rsCheck("Section") & "</TD><TD>" & rsCheck("Row") & "</TD><TD>" & rsCheck("Seat") & "</TD></TR>" & vbCrLf
            rsCheck.MoveNext
        Loop   
		RenewalMismatch = "Y"
    Else
        Response.Write "<TR><TD COLSPAN=""4"">No Missing Seats</TD></TR>" & vbCrLf
    End If         
    
    Response.Write "</TABLE><br /><br /><hr />" & vbCrLf

    rsCheck.close
    Set rsCheck = nothing
    
    Response.Flush
Next

End Sub 'RenewalCheck



'-----------------------------------------------------------------
Sub Renew()

Response.Write "<B><U>Begin Renewal</U></B><BR><BR>" & vbCrLf

SQLTickets = "SELECT OrderLine.OrderNumber, OrderLine.LineNumber, Seat.EventCode, Section.Section, Seat.SectionCode, Seat.Row, Seat.Seat, OrderLine.SeatTypeCode, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderHeader.CustomerNumber FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON Seat.OrderNumber = OrderHeader.OrderNumber WHERE Seat.EventCode IN (" & OldEventList & ") AND Seat.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND OrderHeader.OrderTypeNumber <> 5  AND OrderHeader.OrderNumber > " & BeginAfterOldOrderNumber & " ORDER BY OrderLine.OrderNumber, OrderLine.LineNumber"
Response.Write SQLTickets & "<BR>"
Set rsTickets = OBJdbConnection.Execute(SQLTickets)

Do Until rsTickets.EOF

	OldOrderNumber = rsTickets("OrderNumber")
	If OldOrderNumber <> LastOldOrderNumber Then 'It's a new order.

		LastOldOrderNumber = OldOrderNumber
		OrderCount = OrderCount + 1
		
		'Add the OrderHeader
		Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
		Set spInsertorderHeader.ActiveConnection = OBJdbConnection
		spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
		spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , rsTickets("CustomerNumber")) 'As Integer and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input.
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , UserNumber) 'As Integer and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, RenewDescription) 'As Varchar and Input
		spInsertOrderHeader.Execute

		OrderNumber = spInsertOrderHeader.Parameters("OrderNumber")
		LineNumber = 1
		
		Response.Write "<BR>Old Order Number = " & OldOrderNumber & " - New Order Number: " & OrderNumber & "<BR>"
		
	End If
	
	NewEventCode = LookupNewEventCode(rsTickets("EventCode"))
	
	'Find the matching seat with status 'H' or 'A'
    ItemNumber = 0
	SQLSeat = "SELECT TOP 1 ItemNumber, Event.EventCode, EventType, Map, SectionType FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.EventCode = " & NewEventCode & " AND Seat.SectionCode = '" & rsTickets("SectionCode") & "' AND Row = '" & rsTickets("Row") & "' AND Seat = '" & rsTickets("Seat") & "' AND Seat.StatusCode IN ('A', 'H')"
	'ErrorLog( SQLSeat)
	Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	If Not rsSeat.EOF Then
        ItemNumber = rsSeat("ItemNumber")
        Map = UCase(rsSeat("Map"))
        EventType = UCASE(rsSeat("EventType"))
        SectionType = UCase(rsSeat("SectionType"))
    End If

	'JAI 4/26/11 - Added SubFixedEvent for subscription tickets.
    'JAI 10/17/11 - Added check for GA sections when adding seats.
    If ItemNumber <> 0 Then
		If EventType = "SUBFIXEDEVENT" Then  'Subscription Event
			If Map = "GENERAL" Or SectionType = "GENERAL" Then 'General Admission Subscription
				StoredProcedureName = "spEventReserveSeatsSubFixedEvent"
				Set spGASub = Server.Createobject("Adodb.Command")
				Set spGASub.ActiveConnection = OBJdbConnection
				spGASub.Commandtype = 4 ' Value for Stored Procedure
				spGASub.Commandtext = StoredProcedureName
				spGASub.Parameters.Append spGASub.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spGASub.Parameters.Append spGASub.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
				spGASub.Parameters.Append spGASub.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
				spGASub.Parameters.Append spGASub.CreateParameter("SeatCount", 3, 1, , 1) 'As Integer and Input
				spGASub.Parameters.Append spGASub.CreateParameter("SectionCode", 200, 1, 5, rsTickets("SectionCode")) 'As Varchar and Input with Section Code for General Admission events.
				spGASub.Execute
				ReturnCode = spGASub.Parameters("ReturnCode")
			
	            SQLSeat = "SELECT TOP 1 Seat.ItemNumber FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.OrderNumber = OrderLine.OrderNumber AND Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & OrderNumber & " AND SectionCode = '" & rsTickets("SectionCode") & "' AND Row = '" & rsTickets("Row") & "' AND Seat = '" & rsTickets("Seat") & "' AND OrderLine.ItemType = 'SubFixedEvent' ORDER BY Seat.StatusDate DESC"
	            'ErrorLog( SQLSeat)
	            Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	            If Not rsSeat.EOF Then
                    ItemNumber = rsSeat("ItemNumber")
                Else
                    ReturnCode = 97
                End If

			Else 'Reserved Seating Subscription
				StoredProcedureName = "spSectionReserveSeatsSubFixedEvent"
				Set spReservedSub = Server.Createobject("Adodb.Command")
				Set spReservedSub.ActiveConnection = OBJdbConnection
				spReservedSub.Commandtype = 4 ' Value for Stored Procedure
				spReservedSub.Commandtext = StoredProcedureName
				spReservedSub.Parameters.Append spReservedSub.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spReservedSub.Parameters.Append spReservedSub.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
				spReservedSub.Parameters.Append spReservedSub.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
				spReservedSub.Parameters.Append spReservedSub.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input
				spReservedSub.Parameters.Append spReservedSub.CreateParameter("CommaDelimiter", 200, 1, 1, ",") 'As Varchar and Input
				spReservedSub.Parameters.Append spReservedSub.CreateParameter("ItemNumber", 200, 1, 5000, ItemNumber) 'As Varchar and Input
				spReservedSub.Parameters.Append spReservedSub.CreateParameter("SellHold", 200, 1, 1, "Y") 'As Varchar and Input
				spReservedSub.Execute
				ReturnCode = spReservedSub.Parameters("ReturnCode")
			End If
		Else  'Single event
			If Map = "GENERAL" Or SectionType = "GENERAL" Then 'General Admission Subscription
				StoredProcedureName = "spEventReserveSeats"
				Set spGAEvent = Server.Createobject("Adodb.Command")
				Set spGAEvent.ActiveConnection = OBJdbConnection
				spGAEvent.Commandtype = 4 ' Value for Stored Procedure
				spGAEvent.Commandtext = StoredProcedureName
				spGAEvent.Parameters.Append spGAEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spGAEvent.Parameters.Append spGAEvent.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
				spGAEvent.Parameters.Append spGAEvent.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
				spGAEvent.Parameters.Append spGAEvent.CreateParameter("SeatCount", 3, 1, , 1) 'As Integer and Input
				spGAEvent.Parameters.Append spGAEvent.CreateParameter("SectionCode", 200, 1, 5, rsTickets("SectionCode")) 'As Varchar and Input with Section Code for General Admission events.
				spGAEvent.Execute
				ReturnCode = spGAEvent.Parameters("ReturnCode")

	            SQLSeat = "SELECT TOP 1 Seat.ItemNumber FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.OrderNumber = OrderLine.OrderNumber AND Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & OrderNumber & " AND SectionCode = '" & rsTickets("SectionCode") & "' AND Row = '" & rsTickets("Row") & "' AND Seat = '" & rsTickets("Seat") & "' AND OrderLine.ItemType = 'Seat' ORDER BY Seat.StatusDate DESC"
	            'ErrorLog( SQLSeat)
	            Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	            If Not rsSeat.EOF Then
                    ItemNumber = rsSeat("ItemNumber")
                Else
                    ReturnCode = 98
                End If

			Else 'Reserved Seating single event
				StoredProcedureName = "spSectionReserveSeats"
				Set spReservedEvent = Server.Createobject("Adodb.Command")
				Set spReservedEvent.ActiveConnection = OBJdbConnection
				spReservedEvent.Commandtype = 4 ' Value for Stored Procedure
				spReservedEvent.Commandtext = StoredProcedureName
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("RowsUpdated", 3, 2) 'As Integer and Output
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("AcceptAvailable", 200, 1, 1, "N") 'As Varchar and Input
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("CommaDelimiter", 200, 1, 1, ",") 'As Varchar and Input
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("ItemNumber", 200, 1, 5000, ItemNumber) 'As Varchar and Input
				spReservedEvent.Parameters.Append spReservedEvent.CreateParameter("SellHold", 200, 1, 1, "Y") 'As Varchar and Input
				spReservedEvent.Execute
				ReturnCode = spReservedEvent.Parameters("ReturnCode")
			End If
		End If

		Response.Write "OldEventCode = " & rsTickets("EventCode") & " | NewEventCode = " & NewEventCode & " | OldOrderNumber = " & OldOrderNumber & " | NewOrderNumber = " & OrderNumber & " | ItemNumber = " & ItemNumber & " | ReturnCode = " & ReturnCode & "<BR>"
    Else
        ReturnCode = 99
    End If
	
	If ReturnCode = 0 Then 'It was successful
	
		'Update the Shipping Info, Price, SeatType and ShipType in OrderLine
		SeatTypeCode = LookupNewSeatTypeCode(rsTickets("SeatTypeCode")			    )
	
		'Get the price and surcharge
		Price = 0
		SQLPrice = "SELECT Price.Price, Seat.EventCode, LineNumber, OrderLine.ItemType, Price.Surcharge FROM Seat (NOLOCK) INNER JOIN Price (NOLOCK) ON Seat.EventCode = Price.EventCode AND Seat.SectionCode = Price.SectionCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.ItemNumber = " & ItemNumber & " AND Price.SeatTypeCode = " & SeatTypeCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
		'ErrorLog(SQLPrice)
		Set rsPrice = OBJdbConnection.Execute(SQLPrice)
        If Not rsPrice.EOF Then
		    Price = rsPrice("Price")
            If CalculateSurcharge Then
                Surcharge = rsPrice("Surcharge")
            End If
        Else
            Response.Write "Price Record Not Found - NewOrderNumber = " & OrderNumber & " | EventCode = " & NewEventCode & " | NewItemNumber = " & ItemNumber & " | SeatTypeCode = " & SeatTypeCode & "<BR><BR>"
            Exit Do
        End If

		SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Price & ", Surcharge = " & Surcharge & ", SeatTypeCode = " & SeatTypeCode & ", ShipCode = " & ShipCode & ", ShipFirstName = '" & Clean(rsTickets("ShipFirstName")) & "', ShipLastName = '" & Clean(rsTickets("ShipLastName")) & "', ShipAddress1 = '" & Clean(rsTickets("ShipAddress1")) & "', ShipAddress2 = '" & Clean(rsTickets("ShipAddress2")) & "', ShipCity = '" & Clean(rsTIckets("ShipCity")) & "', ShipState = '" & Clean(rsTickets("ShipState")) & "', ShipPostalCode = '" & Clean(rsTickets("ShipPostalCode")) & "', ShipCountry = '" & Clean(rsTickets("ShipCountry")) & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & rsPrice("LineNumber")
		Response.Write SQLUpdateOrderLine & "<BR>"
		Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)

		'REE 8/10/3 - Added Update to Child Lines - Price and Surcharge are added as individual tickets and discounts are applied to mark down to zero
		If rsPrice("ItemType") = "SubFixedEvent" Then
			'Get the original price
			SQLChildPrice = "SELECT Price.Price, Price.Surcharge, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber LEFT JOIN Price (NOLOCK) ON Seat.EventCode = Price.EventCode AND Seat.SectionCode = Price.SectionCode AND Price.SeatTypeCode = " & SeatTypeCode & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ParentLineNumber = " & rsPrice("LineNumber")
			Set rsChildPrice = OBJdbConnection.Execute(SQLChildPrice)
			
			Do Until rsChildPrice.EOF
				If Not IsNull(rsChildPrice("Price")) Then
					ChildPrice = rsChildPrice("Price")
				Else
					ChildPrice = 0
				End If
				ChildSurcharge = 0
				ChildDiscountAmount = ChildPrice + ChildSurcharge
				ChildDiscountTypeNumber = 37
				SQLUpdateChildLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & ChildPrice & ", Surcharge = " & ChildSurcharge & ", SeatTypeCode = " & SeatTypeCode & ", Discount = " & ChildDiscountAmount & ", DiscountTypeNumber = " & ChildDiscountTypeNumber & ", ShipCode = " & ShipCode & ", ShipFirstName = '" & Clean(rsTickets("ShipFirstName")) & "', ShipLastName = '" & Clean(rsTickets("ShipLastName")) & "', ShipAddress1 = '" & Clean(rsTickets("ShipAddress1")) & "', ShipAddress2 = '" & Clean(rsTickets("ShipAddress2")) & "', ShipCity = '" & Clean(rsTickets("ShipCity")) & "', ShipState = '" & Clean(rsTickets("ShipState")) & "', ShipPostalCode = '" & Clean(rsTickets("ShipPostalCode")) & "', ShipCountry = '" & Clean(rsTickets("ShipCountry")) & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & rsChildPrice("LineNumber")
				Set rsUpdateChildLine = OBJdbConnection.Execute(SQLUpdateChildLine)
				
				rsChildPrice.MoveNext
			Loop
			
			rsChildPrice.Close
			Set rsChildPrice = nothing
		End If
		
		rsPrice.Close
		Set rsPrice = nothing
		
		LineNumber = LineNumber + 1
		TicketCount = TicketCount + 1
		
	Else 'It failed
		
		Response.Write "Seat Import Failed - CustomerNumber = " & rsTickets("CustomerNumber") & " | Section = " & rsTickets("Section") & " | Row = " & rsTickets("Row") & " | Seat = " & rsTickets("Seat") & "<BR>" & vbCrLf
		FailedCount = FailedCount + 1
		
		If IgnoreSoldTicketsFlag <> "Y" Then
			Response.Write "***** Import Halted *****<BR>"
			Exit Do
		End If
	End If

    If TicketCount Mod 100 = 0 Then
	    Response.Flush
    End If
	rsTickets.MoveNext
Loop

Response.Write "<BR>Orders Added = " & OrderCount & "<BR>" & vbCrLf
Response.Write "Tickets Added = " & TicketCount & "<BR>" & vbCrLf
Response.Write "Failed Count = " & FailedCount & "<BR><BR>" & vbCrLf

End Sub 'Renew



'--------------------------------------------------------
Sub ApplyDiscount()

'If ApplyDiscount Request is set, clear discount fields before recalculating.
If ApplyDiscountFlag = "Y" Then
    SQLClearDiscounts = "UPDATE OrderLine SET DiscountTypeNumber = 0, Discount = 0 WHERE StatusCode = 'R' AND OrderNumber IN (SELECT OrderNumber FROM OrderHeader (NOLOCK) WHERE IPAddress = '" & RenewDescription & "')"
    Response.Write "Clear Discounts: " & SQLClearDiscounts & "<br />" & vbCrLf
    Set rsClearDiscounts = OBJdbConnection.Execute(SQLClearDiscounts)
End If

DiscountCount = 0

SQLNewTickets = "SELECT OrderLine.OrderNumber, OrderLine.LineNumber, Seat.EventCode, DiscountType.DiscountCode, OrderLine.Price, OrderLine.Surcharge, OrderLine.SeatTypeCode, Seat.SectionCode, OrderLine.ItemType, DiscountType.DiscountTypeNumber, DiscountType.DiscountScript FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON Seat.OrderNumber = OrderHeader.OrderNumber INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode INNER JOIN DiscountType (NOLOCK) ON DiscountEvents.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE Seat.EventCode IN (" & NewEventList & ") AND Seat.StatusCode = 'R' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND OrderHeader.IPAddress = '" & RenewDescription & "' AND DiscountType.DiscountTypeNumber = " & DiscountTypeNumber & " AND ISNULL(DiscountScript, '') <> ''  ORDER BY OrderLine.OrderNumber, Price DESC, LineNumber"
ErrorLog(SQLNewTickets)
Set rsNewTickets = OBJdbConnection.Execute(SQLNewTickets)
Response.Write "Apply Discounts<BR>" & vbCrLf

Do While Not rsNewTickets.EOF

	'Response.Write " Renewal - ON: " & rsNewTickets("OrderNumber") & " - LN: " & rsNewTickets("LineNumber") & "<BR>"
	Set objTransfer = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
	objTransfer.Open "GET", rsNewTickets("DiscountScript") & "&OrderNumber=" & rsNewTickets("OrderNumber") & "&LineNumber=" & rsNewTickets("LineNumber") & "&EventCode=" & rsNewTickets("EventCode") & "&DiscountCode=" & rsNewTickets("DiscountCode") & "&Price=" & rsNewTickets("Price") & "&Surcharge=" & rsNewTickets("Surcharge") & "&SeatTypeCode=" & rsNewTickets("SeatTypeCode") & "&SectionCode=" & rsNewTickets("SectionCode") & "&OrganizationNumber=" & Session("OrganizationNumber") & "&DiscountTypeNumber=" & rsNewTickets("DiscountTypeNumber") & "&OrderTypeNumber=" & OrderTypeNumber, False
	objTransfer.Send
	DiscountPage = objTransfer.responseText
	Set objTransfer = nothing
			
	NewPrice = Mid(DiscountPage, InStr(1, DiscountPage, "<NEWPRICE>") + 10, InStr(1, DiscountPage, "</NEWPRICE>") - InStr(1, DiscountPage, "<NEWPRICE>") - 10)
	DiscountAmount = Mid(DiscountPage, InStr(1, DiscountPage, "<DISCOUNTAMOUNT>") + 16, InStr(1, DiscountPage, "</DISCOUNTAMOUNT>") - InStr(1, DiscountPage, "<DISCOUNTAMOUNT>") - 16)
	Surcharge = Mid(DiscountPage, InStr(1, DiscountPage, "<SURCHARGE>") + 11, InStr(1, DiscountPage, "</SURCHARGE>") - InStr(1, DiscountPage, "<SURCHARGE>") - 11)
	AppliedFlag = Mid(DiscountPage, InStr(1, DiscountPage, "<APPLIEDFLAG>") + 13, InStr(1, DiscountPage, "</APPLIEDFLAG>") - InStr(1, DiscountPage, "<APPLIEDFLAG>") - 13)
	If InStr(1, DiscountPage, "<PRICE>") <> 0 Then
		Price = Mid(DiscountPage, InStr(1, DiscountPage, "<PRICE>") + 7, InStr(1, DiscountPage, "</PRICE>") - InStr(1, DiscountPage, "<PRICE>") - 7)
    Else 
        Price = rsNewTickets("Price")
	End If
	If InStr(1, DiscountPage, "<SEATTYPECODE>") <> 0 Then
		SeatTypeCode = Mid(DiscountPage, InStr(1, DiscountPage, "<SEATTYPECODE>") + 14, InStr(1, DiscountPage, "</SEATTYPECODE>") - InStr(1, DiscountPage, "<SEATTYPECODE>") - 14)
    Else
        SeatTypeCode = rsNewTickets("SeatTypeCode")
	End If
	
	Response.Write " Renewal - ON: " & rsNewTickets("OrderNumber") & " - LN: " & rsNewTickets("LineNumber") & " - PR: " & Price & " - SR: " & Surcharge & " - NP: " & NewPrice & " - DS: " & DiscountAmount & " - AF: " & AppliedFlag & "<BR>"
	If AppliedFlag = "Y" Then 'Calculate discount amount					
		DiscountAmount = Price - NewPrice
		DiscountTypeNumber = rsNewTickets("DiscountTypeNumber")

		SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Round(Price,2) & ", Surcharge = " & Round(Surcharge,2) & ", Discount = " & Round(DiscountAmount,2) & ", DiscountTypeNumber = " & DiscountTypeNumber & ", SeatTypeCode = " & SeatTypeCode & " WHERE OrderNumber = " & rsNewTickets("OrderNumber") & " AND LineNumber = " & rsNewTickets("LineNumber")
        'Response.Write "Apply Discount: " & SQLUpdateOrderLine & "<BR>" & vbCrLf
		Set rsUpdateOrderLine = OBJdbConnection2.Execute(SQLUpdateOrderLine)

		DiscountCount = DiscountCount + 1
	End If

    If DiscountCount Mod 100 = 0 Then
        Response.Flush
    End If
	rsNewTickets.MoveNext
Loop

rsNewTickets.Close
Set rsNewTickets = nothing

Response.Write "Discount Count = " & DiscountCount & "<BR><BR>" & vbCrLf

End Sub


'-----------------------------------------
Sub UpdateTotals()

'Update the OrderHeader
SQLUpdateTotals = "UPDATE OrderHeader WITH (ROWLOCK) SET SubTotal = SumPrice, OrderSurcharge = SumSurcharge, Discount = SumDiscount, ShipFee = " & ShipFee & ", Total = SumPrice + SumSurcharge + " & ShipFee & " - SumDiscount FROM OrderHeader INNER JOIN (SELECT OrderLine.OrderNumber, SUM(Price) AS SumPrice, SUM(Surcharge) AS SumSurcharge, SUM(Discount) AS SumDiscount FROM OrderLine (NOLOCK) GROUP BY OrderLine.OrderNumber) AS OL ON OrderHeader.OrderNumber = OL.OrderNumber WHERE OrderHeader.IPAddress = '" & RenewDescription & "' AND OrderHeader.StatusCode = 'R'"
Response.Write "Update Order Totals: " & SQLUpdateTotals & "<BR>"
Set rsUpdateTotals = OBJdbConnection.Execute(SQLUpdateTotals)

Response.Write "Totals Updated<BR><BR>" & vbCrLf

End Sub 'Update Totals



%>