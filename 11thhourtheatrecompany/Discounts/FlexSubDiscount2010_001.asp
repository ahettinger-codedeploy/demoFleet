<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->
<%


'==================================================
'11th Hour Theatre Company (10/22/2010)
'2010 Season Subscription

'Full Season Subscription - $80 per subscription (You save 20% - $100 value)
'	One ticket to all 4 shows!
'	tick, tick...BOOM! (in concert), RENT, Philly Rocks the 70’s, and The Great American Trailer Park Musical

'Three Show Subscription - $60 per subscription (You save 20% - $75 value)
'	One ticket to your choose of 3 shows!
'	tick, tick...BOOM! (in concert), RENT, Philly Rocks the 70’s, The Great American Trailer Park Musical

'Productions
'45459   Philly Rocks Your Playlist! 
'56326   PHILLY ROCKS! the 70’s 
'54743   RENT 
'56327   The Great American Trailer Park Musical 
'54742   tick, tick...BOOM! (in concert)

Percentage = 20 
SeriesCount = 3
ActCodeList = "45459,56326,54743,56327,54742"
SeriesSeatCode = "564"

'==================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
    'Determine the number of acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeriesSeatCode & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

		'Determine the number of possible subscriptions on this order
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
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

		
		    If AppliedCount < NbrSubscriptions Then
		    
		        Select Case SeatTypeCode
		            Case 564	    
		            NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
		        End Select
                        
                    If Price > NewPrice Then
	                DiscountAmount = Clean(Request("Price")) - NewPrice
	                AppliedFlag = "Y"
	                End If
    		        
                    If Request("NewSurcharge") <> "" Then
	                    Surcharge = NewSurcharge
                    Else
	                    If Request("CalcServiceFee") <> "N" Then
		                    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	                    End If
                    End If
    		End If
				
	End If	
											
End If


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>