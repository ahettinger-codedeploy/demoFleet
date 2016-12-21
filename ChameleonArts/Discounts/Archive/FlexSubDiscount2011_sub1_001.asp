<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%
'==================================================

'Chameleon Arts Ensemble (1/13/2011)

'2011 Season Subscription Sub 1

'The first one (Sub2011), I’d like to have the following parameters:
'20% off
'Adult Tickets
'must purchase tickets to 2 or more concerts
'In addition, I’d like to be able to override the usual $1.50 per ticket service charge for these packages and simply assign $1.50 for the entire purchase.


'Purchase 1 ticket to at least 2 (or 3) productions
'Adult ticket only
'20% off each ticket
'$1.50 fee per subscription
'fee split between the number of tickets on the order
'Manual discount

SeriesCount = 2
Percentage = 20
SeriesSurcharge = 1.50

'================================

        'Get the color for this section (needed for this discount to work)
        SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
        Set rsColor = OBJdbConnection.Execute(SQLColor)	
        Color = UCase(rsColor("Color"))	
        rsColor.Close
        Set rsColor = nothing

        'Determine the number of acts on this order.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Section.Color = '" & Color & "' AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
        ActCount = rsActCount("ActCount")	
        rsActCount.Close
        Set rsActCount = nothing

        'Determine the number of possible subscriptions on this order
        SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND DiscountTypeNumber <> " & DiscountTypeNumber & "  GROUP BY Event.ActCode) AS TicketCount"
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

		'The number of discounted seats at this price for these events is less then the total possible, apply discount
		
		If AppliedCount < NbrSubscriptions Then				
            
                 Select Case SeatTypeCode
                    Case 1                    
		                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)     		            
		                If Price > NewPrice Then
	                        DiscountAmount = Clean(Request("Price")) - NewPrice
	                        Surcharge = (SeriesSurcharge / ActCount)
	                        AppliedFlag = "Y"
	                    End If                  
                 End Select
	        
	    End If
	  

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>