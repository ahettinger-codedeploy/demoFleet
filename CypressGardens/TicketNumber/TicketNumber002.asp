<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->

<%

'Make sure the request is coming from Tix
IPAddress = Request.ServerVariables("REMOTE_ADDR")
If IPAddress = "127.0.0.1" Then 'The request is from Tix

	ItemNumber = CleanNumeric(Request("ItemNumber"))
	OrderNumber = CleanNumeric(Request("OrderNumber"))
	CustomerNumber = CleanNumeric(Request("CustomerNumber"))

	'Get TicketCode based on ActCode
	SQLActCode = "SELECT ActCode FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE ItemNumber = " & ItemNumber
	Set rsActCode = OBJdbConnection.Execute(SQLActCode)
	
	ActCode = rsActCode("ActCode")
	
	rsActCode.Close
	Set rsActCode = nothing
	
	Select Case ActCode
		Case 20783 'Cypress Gardens Garden Days Ticket
			TicketCode = 15
		Case 9662, 10508 'Cypress Gardens Platinum
			TicketCode = 11
		Case 23076, 23077 'Cypress Gardens Gold
			TicketCode = 1116
		Case 23074, 23075 'Cypress Gardens Passport
			TicketCode = 4001
		Case 9666 'Cypress Gardens One Day Adult
			TicketCode = 5001
		Case 9667 'Cypress Gardens One Day JR/SR
			TicketCode = 5002
		Case 13736, 13737 'Cypress Gardens 2007 Passport
			TicketCode = 14
		Case Else
			TicketCode = 0
	End Select
	
	If TicketCode <> 0 Then 'Use Wild Adventures Database
	
		Set dbCypressGardens = Server.CreateObject("ADODB.Connection")
		dbCypressGardens.CommandTimeout = 60
		dbCypressGardens.Open "Provider=SQLOLEDB; Data Source=74.223.179.35; Initial Catalog=TIX_TICKETS; Network=DBMSSOCN; User ID=tix; Password=qwaszxTT"

		Set spGetTicket = Server.Createobject("Adodb.Command")
		Set spGetTicket.ActiveConnection = dbCypressGardens
		spGetTicket.Commandtype = 4 ' Value for Stored Procedure
		spGetTicket.Commandtext = "GetUpdateTicket"
		spGetTicket.Parameters.Append spGetTicket.CreateParameter("ReturnCode", 3, 4) 'As Int and ParamReturnValue
		spGetTicket.Parameters.Append spGetTicket.CreateParameter("TicketNumber", 200, 2, 50) 'As VarChar and Output
		spGetTicket.Parameters.Append spGetTicket.CreateParameter("OrderNumber", 200, 1, 50, OrderNumber) 'As VarChar and Input
		spGetTicket.Parameters.Append spGetTicket.CreateParameter("TicketCode", 200, 1, 50, TicketCode) 'As VarChar and Input

		spGetTicket.Execute

		ReturnCode = spGetTicket.Parameters("ReturnCode")
		TicketNumber = spGetTicket.Parameters("TicketNumber")

		If ReturnCode <> 0 Or Len(TicketNumber) < 2 Then 'Error
			ErrorLog("E-Ticket Add Error - Return Code = " & ReturnCode & " | TicketNumber = " & TicketNumber)
			
			SQLAvailableCount = "SELECT TICKET_CODE, COUNT(TICKET_NUMBER) AS TicketCount FROM TICKETS (NOLOCK) WHERE ORDER_ID IS NULL GROUP BY TICKET_CODE ORDER BY TICKET_CODE"
			Set rsAvailableCount = dbCypressGardens.Execute(SQLAvailableCount)
			
			If Not rsAvailableCount.EOF Then
				AvailableTable = "<TABLE><TR><TH>Ticket Code</TH><TH>Available Quantity</TH></TR>" & vbCrLf
				Do Until rsAvailableCount.EOF
					AvailableTable = AvailableTable & "<TR><TD ALIGN=""right"">" & rsAvailableCount("TICKET_CODE") & "</TD><TD ALIGN=""right"">" & rsAvailableCount("TicketCount") & "</TD></TR>" & vbCrLf
					rsAvailableCount.MoveNext
				Loop
				AvailableTable = AvailableTable & "</TABLE>" & vbCrLf
			End If
			
			rsAvailableCount.Close
			Set rsAvailableCount = nothing
			
			Set objCDOSYSMail = Server.CreateObject("CDO.Message")
			Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

			objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
			objCDOSYSCon.Fields.Update

			'Update the CDOSYS Configuration
			Set objCDOSYSMail.Configuration = objCDOSYSCon
			objCDOSYSMail.From = "webmaster@tix.com" 
			'REE 3/31/5 - Added ReplyTo Address
			objCDOSYSMail.ReplyTo = "webmaster@tix.com"
			objCDOSYSMail.To = "fbuescher@cypressgardens.com"
			objCDOSYSMail.CC = "jasonhut1@bellsouth.net"
			objCDOSYSMail.BCC = "robert.edmison@tix.com"
			objCDOSYSMail.Subject = "E-Ticket Error" 
			objCDOSYSMail.HTMLBody = "There was an error producing the e-ticket number for Order #" & OrderNumber & "<BR><BR>This message was automatically generated.<BR><BR>" & AvailableTable
			objCDOSYSMail.Send

			'Close the server mail object
			Set objCDOSYSMail = Nothing
			Set objCDOSYSCon = Nothing 
		Else
			Response.Write "<TICKETNUMBER>" & TicketNumber & "</TICKETNUMBER>"
		End If

		dbCypressGardens.Close
		Set dbCypressGardens = nothing
	
	Else 'Use Tix generated TicketNumber

		SQLConcertSeason = "SELECT OrderLine.ItemNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN SubscriptionEvent WITH (NOLOCK) ON Event.EventCode = SubscriptionEvent.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemNumber = " & ItemNumber & " AND SubscriptionEvent.SubscriptionNumber = 85752 AND Event.ActCode = " & ActCode & " AND OrderLine.ItemType = 'SubSeat'"
		Set rsConcertSeason = OBJdbConnection.Execute(SQLConcertSeason)
		
		If Not rsConcertSeason.EOF Then
			ConcertSeasonChild = "Y"
		End If
		
		rsConcertSeason.Close
		Set rsConcertSeason = nothing
		
		If ConcertSeasonChild = "Y" Then 'It's a child concert season ticket.  Use the same ticket number for the parent and children.

			'Get the parent line number.
			SQLParentLineNum = "SELECT ParentLineNumber FROM OrderLine WITH (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND ItemNumber = " & ItemNumber
			Set rsParentLineNum = OBJdbConnection.Execute(SQLParentLineNum)
			
			If Not rsParentLineNum.EOF Then
				ParentLineNumber = rsParentLineNum("ParentLineNumber")
			End If
			
			rsParentLineNum.Close
			Set rsParentLineNum = nothing
			
			'See if the parent already has a ticket number.
			SQLParentTicket = "SELECT TicketNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Ticket WITH (NOLOCK) ON OrderLine.OrderNumber = Ticket.OrderNumber AND OrderLine.ItemNumber = Ticket.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber = " & ParentLineNumber
			Set rsParentTicket = OBJdbConnection.Execute(SQLParentTicket)
			
			If Not rsParentTicket.EOF Then 
				ParentTicketNumber = rsParentTicket("TicketNumber")
			Else
				ParentTicketNumber = 0
			End If
			
			rsParentTicket.Close
			Set rsParentTicket = nothing
			
			If ParentTicketNumber = 0 Then	'Add a ticket for the parent.

				SQLParentItemNum = "SELECT ItemNumber FROM OrderLine WITH (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & ParentLineNumber
				Set rsParentItemNum = OBJdbConnection.Execute(SQLParentItemNum)
					
				ParentItemNumber = rsParentItemNum("ItemNumber")
					
				rsParentItemNum.Close
				Set rsParentItemNum = nothing

				'Generate the Parent Ticket Number				
				Randomize()
				ParentTicketNumber = CStr(ParentItemNumber * 3) & CStr(Int((999999999999 - 100000000000 + 1) * Rnd + 100000000000))
				
				'Insert the Parent Ticket record
				SQLAddTicket = "INSERT Ticket(TicketNumber, ItemNumber, OrderNumber, StatusCode, StatusDate, CreationDate) VALUES('" & ParentTicketNumber & "', " & ItemNumber & ", " & OrderNumber & ", 'A', GETDATE(), GETDATE())"
				Set rsAddTicket = OBJdbConnection.Execute(SQLAddTicket)

			End If
			
			'Pass the same parent ticket number for use as the child.
			Response.Write "<TICKETNUMBER>" & ParentTicketNumber & "</TICKETNUMBER>"
		
		Else

			Randomize()
			TixNum = CStr(ItemNumber * 3) & CStr(Int((999999999999 - 100000000000 + 1) * Rnd + 100000000000))
	
			Response.Write "<TICKETNUMBER>" & TixNum & "</TICKETNUMBER>"
			
		End If
	
	End If

Else

	ErrorLog("E-Ticket Add Error - Unauthorized IP Address Attempt = " & IPAddress)

End If


%>


  