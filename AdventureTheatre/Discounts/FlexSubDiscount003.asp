<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Initialize Variables
Price = Clean(Request("Price"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
DiscountTypeNumber = 30702
OrderNumber = Clean(Request("OrderNumber"))
ActCodeList = "27772,27983,28199,27985,28207,27990,28208,28824,28825,28822,28823,28846,28858,28851,28852,28850,28849,28198" 'ActCodes of Productions which can be included in Season Subscription.


'Count # of Acts on the order.
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	
ActCount = rsActCount("ActCount")
	
rsActCount.Close
Set rsActCount = nothing
		
		
'Get the least number of tickets for any applicable ActCode
SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
			
NbrSubscriptions = rsMinTicketCount("NumSubs")
			
rsMinTicketCount.Close
Set rsMinTicketCount = nothing
			
			
'Get Act Code
SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
Set rsAct = OBJdbConnection.Execute(SQLAct)
			
ActCode = rsAct("ActCode")
			
rsAct.Close
Set rsAct = nothing


'Count # of existing seats which have discount applied for this act and seat type code
SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
AppliedCount = rsDiscCount("LineCount")
		
rsDiscCount.Close
Set rsDiscCount = nothing
			
			
'If the # of discounts at this price for these events < the total possible, discount price
If AppliedCount < NbrSubscriptions Then		


		If ActCount = 6 Then
			
			Select Case SeatTypeCode 
			Case 1 'Adult
			NewPrice = 12
			Case 5 'Child
			NewPrice = 9.66
			End Select
															
		ElseIf ActCount = 5 Then
			
			Select Case SeatTypeCode 
			Case 1 'Adult
			NewPrice = 13.20
			Case 5 'Child
			NewPrice = 10.60
			End Select
									
		ElseIf ActCount = 4 Then
			
			Select Case SeatTypeCode 
			Case 1 'Adult
			NewPrice = 13.75
			Case 5 'Child
			NewPrice = 11.00
			End Select
						
		ElseIf ActCount = 3 Then
			
			Select Case SeatTypeCode 
			Case 1 'Adult
			NewPrice = 14.33
			Case 5 'Child
			NewPrice = 11.33
			End Select	
			

		End If
															
End If


If Price > NewPrice Then
	DiscountAmount = Clean(Request("Price")) - NewPrice
	AppliedFlag = "Y"
End If
			
	
If Request("NewSurcharge") <> "" Then
	Surcharge = NewSurcharge	
ElseIf Request("CalcServiceFee") <> "N" Then
	Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
End If
		

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>