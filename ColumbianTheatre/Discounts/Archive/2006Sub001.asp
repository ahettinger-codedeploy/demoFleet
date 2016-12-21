<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))


'REE 8/10/4 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If
	
If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.
	'Count # of seats for 1STSHOW
	SQL1STSHOWCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 7650"
	Set rs1STSHOWCount = OBJdbConnection.Execute(SQL1STSHOWCount)

	'Count # of seats for 2NDSHOW
	SQL2NDSHOWCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 7657"
	Set rs2NDSHOWCount = OBJdbConnection.Execute(SQL2NDSHOWCount)

	'Count # of seats for 3RDSHOW
	SQL3RDSHOWCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 7376"
	Set rs3RDSHOWCount = OBJdbConnection.Execute(SQL3RDSHOWCount)
	
	'Count # of seats for 4THSHOW
	SQL4THSHOWCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 7656"
	Set rs4THSHOWCount = OBJdbConnection.Execute(SQL4THSHOWCount)
	
	'Count # of seats for 5THSHOW
	SQL5THSHOWCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 7710"
	Set rs5THSHOWCount = OBJdbConnection.Execute(SQL5THSHOWCount)

	'Check if there is a possible subscription
	If rs1STSHOWCount("LineCount") >= 1 And rs2NDSHOWCount("LineCount") >= 1 And rs3RDSHOWCount("LineCount") >= 1 And rs4THSHOWCount("LineCount") >= 1 And rs5THSHOWCount("LineCount") >= 1 Then

		'Find number of subscriptions by selecting event with lowest # of tickets at this price 
		NbrSubscriptions = Min(Array(rs1STSHOWCount("LineCount"),rs2NDSHOWCount("LineCount"),rs3RDSHOWCount("LineCount"),rs4THSHOWCount("LineCount"),rs5THSHOWCount("LineCount")))
									
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)

		'Count # of existing seats which have discount applied for this act and seat type code
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & rsAct("ActCode") & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		'If the # of discounts at this price for these events < the total possible, discount price
		If rsDiscCount("LineCount") < NbrSubscriptions Then
			
			Select Case Price
			Case 5
				NewPrice = 3
			Case 9
				NewPrice = 7
			Case 10
				NewPrice = 8
			Case 15
				NewPrice = 12
			Case 18
				NewPrice = 15
			Case 19.75
				NewPrice = 17.75
			Case 20
				NewPrice = 17
			Case 20.75
				NewPrice = 18.75
			Case 35.25
				NewPrice = 32.25
			Case 37.25
				NewPrice = 34.25
			End Select
		End If
										
		rsDiscCount.Close
		Set rsDiscCount = nothing
		rsAct.Close
		Set rsAct = nothing
	End If

							
	rs1STSHOWCount.Close
	Set rs1STSHOWCount = nothing
	rs2NDSHOWCount.Close
	Set rs2NDSHOWCount = nothing
	rs3RDSHOWCount.Close
	Set rs3RDSHOWCount = nothing
	rs4THSHOWCount.Close
	Set rs4THSHOWCount = nothing
	rs5THSHOWCount.Close
	Set rs5THSHOWCount = nothing
	
	If Price > NewPrice Then
		DiscountAmount = Price - NewPrice
		AppliedFlag = "Y"
	Else
		NewPrice = Price
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>