<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'=======================================================

'Boston Camarata (4/12/2013)

'2013 Season Subscription 
'2 Tier Season Subscription by Act Count


'Pricing
'==================

'Before 9/1/2013

'4 Productions - 20% Discount off each ticket
'3 Productions - 15% Discount off each ticket
'2 Productions - 5% Discount off each ticket
'1 Production - 5% Discount off each ticket

'After 9/1/2013

'4 Productions - 15% Discount off each ticket
'3 Productions - 10% Discount off each ticket


'Eligible Productions
'====================
'ActCode	Act
'91306   	Carmina Burana 
'91309   	Lovely Vine: Jeremiah Ingalls and the American Folk Hymn 
'91307   	Noël, Noël: A French Christmas 
'91308   	Portes du Ciel—Gates of Paradise 



'Eligible Ticket Type
'==================
'Price A Section

'**Note: Task calls for "Adult" ticket, but none of the events have an Adult ticket type


'Eligible Price Tier/Section
'==================
'All Sections

'** Note: Task calls for Orchestra Center seats only OR all seats at 1st price tier (gold sections)
'** but this is a GA event, so the "Price A Section" ticket was used instead.


'Offline/Online
'==================
'Discount available for both Box Office Orders and Internet Orders


'Service Fees
'==================
'No Change to the per ticket service fees.


'Automatic/Code Entry
'==================
'Automatic Discount
'Discount code entry not required


'Expiration
'==================
'No expiration


'Discount Limits
'==================
'Unlimited Discounts Allowed

'=======================================================


ActCodeList = "91306,91309,91307,91308"

EndDate = "9/01/2013"

'================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'Determine the original order date, for date based season subscriptions
'this allows re-opened orders to calculate based on the original order date

SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing

'Determine the number of acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND SeatTypeCode = 106 AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	ErrorLog("ActCount "&ActCount&"")
	
	
	If ActCount => 1 Then
		
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

		'If the number of discounted seats at this price for these events is less then the total possible, apply discount
		
		'Percentage Based On Act Count
		If ActCount = 4 Then 
			If CDate(OriginalDate) < CDate(EndDate) Then  		
				Percentage = 20
			Else
				Percentage = 15
			End If
		ElseIf  ActCount = 3 Then 
			If CDate(OriginalDate) < CDate(EndDate) Then	
				Percentage = 15
			Else
				Percentage = 10
			End If
		ElseIf  ActCount = 2 Then 
			If CDate(OriginalDate) < CDate(EndDate) Then	
				Percentage = 5
			Else
				Percentage = 0
			End If
		ElseIf  ActCount = 1 Then 
			If CDate(OriginalDate) < CDate(EndDate) Then	
				Percentage = 5
			Else
				Percentage = 0
			End If
		End If
		
		
		If AppliedCount < NbrSubscriptions Then		
		
			If SeatTypeCode = 106 Then

		        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)

                If Price > NewPrice Then
	                DiscountAmount = Clean(Request("Price")) - NewPrice
	                AppliedFlag = "Y"
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