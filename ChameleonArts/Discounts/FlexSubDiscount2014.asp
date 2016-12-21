
<%

'CHANGE LOG - Inception
'SSR 12/16/2013 - Created Discount
'SSR 12/17/2013 - Updated to allow passing of new surcharge


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Chameleon Arts Ensemble 

'2014 Season Subscription

'Purchase 1 ticket to at least 2 different productions
'15% discount
'Only applies to the Adult ticket type
'Tickets must be same price

'==================================================


AllowedSeatType = "1"
SeriesCount = 2
Percentage = 15


'-------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		'Determine the number of acts on this order.
		SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.Price = " & Price & " AND Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
		ActCount = rsActCount("ActCount")	
		rsActCount.Close
		Set rsActCount = nothing
		
		If ActCount = SeriesCount Then

			'Determine the number of possible subscriptions on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			NbrSubscriptions = rsMinTicketCount("NumSubs")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing
			
			'Get the ActCode
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)		
			ActCode = rsAct("ActCode")		
			rsAct.Close
			Set rsAct = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount
			
			If AppliedCount < NbrSubscriptions Then				
				
				Select Case SeatTypeCode
					Case AllowedSeatType                  
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)     		            
						If Price > NewPrice Then
							DiscountAmount = Clean(Request("Price")) - NewPrice
							Surcharge = (SeriesSurcharge / ActCount)
							AppliedFlag = "Y"
						End If                  
				End Select
				
				If Request("NewSurcharge") <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
				
			End If
			
		End If
	
	End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>