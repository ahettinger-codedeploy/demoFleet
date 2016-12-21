<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Season Discount = 2 tier price based on section color. Only counting Adult tickets to qualify for the season subscription. Blue section is odd amount, Gold section is percentage off


'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
OrderDate = Clean(Request("OrderDate"))
EventCode = Clean(Request("EventCode"))
SectionCode = Clean(Request("SectionCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))

'Initialize Discount Variables
ActCodeList = "0000" 'Exceptions 
SeriesCount = 3
SeatTypeCodeList = 1
SeriesBluePrice = 88
GoldPercentage = 20
StartDate = CDate("5/20/2009")


'Get the color for this section
SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE SectionCode = '" & SectionCode & "' AND EventCode = " & EventCode & " "
Set rsColor = OBJdbConnection.Execute(SQLColor)
	
Color = UCase(rsColor("Color"))

rsColor.Close
Set rsColor = nothing		


'Original Discount Structure or New Lower Price Discount Structure Check
OriginalDiscount = "N"

If OrderNumber < 5800635 Then
OriginalDiscount = "Y"
End If



'Offline/Online Order Type Check
OrderTypeFlag = "Y"

If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If

If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If


If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.
	

'Count # of Acts with specific SeatTypeCode minus ActCode exceptions.
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode NOT IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode IN (" & SeatTypeCodeList & ") GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)

ActCount = rsActCount("ActCount")

rsActCount.Close
Set rsActCount = nothing

	
	If ActCount >= SeriesCount Then

		'Get the least number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode NOT IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
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
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
		AppliedCount = rsDiscCount("LineCount")
		
		rsDiscCount.Close
		Set rsDiscCount = nothing

		'If the # of discounts at this price for these events < the total possible, discount price
		If AppliedCount < NbrSubscriptions Then
		
			If OriginalDiscount = "N" Then 'New Discount Structure
		
							Select Case Color
							Case "BLUE" 'Price Tier A
								
									Select Case SeatTypeCode
											Case 1 'Adult
										
													'MOD function to figure out the discount to assign to each ticket
													SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
													Set rsCount = OBJdbConnection.Execute(SQLCount)
													Count = rsCount("AppliedCount")
													rsCount.Close
													Set rsCount = nothing	

													Remainder = Count MOD SeriesCount
													
													If Remainder = SeriesCount - 1 Then 
													    NewPrice = SeriesBluePrice - ((SeriesCount - 1) * Round(SeriesBluePrice/SeriesCount, 2))
													Else
															'Standard rounding on all other tickets.
													    NewPrice = Round(SeriesBluePrice/SeriesCount, 2)
													End If
													
											Case 1388 'Half Price
													NewPrice = Price
													
											Case 5 'Child
													NewPrice = Price
													
											End Select
									
							Case "GOLD" 'Price Tier B
									Select Case SeatTypeCode
											Case 1 'Adult					
												NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(GoldPercentage)/100), 2)
												
											Case 1388 'Half Price
												NewPrice = Price
												
											Case 5 'Child
											  NewPrice = Price
											  
											End Select
							End Select
									
			Else  'Original Discount Structure
			
									Select Case SeatTypeCode
											Case 1 'Adult					
												NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(GoldPercentage)/100), 2)
												
											Case 1388 'Half Price
												NewPrice = Price
												
											Case 5 'Child
											  NewPrice = Price
											  
									End Select			
			
			End If						
	
		End If
										
	End If

	
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