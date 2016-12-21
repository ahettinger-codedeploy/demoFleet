<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%
'================================

'Update: Added valid ticket types for subscription discount

'Revised Parameters:

'2013 Season Subscription 
'2 Tier Season Subscription by Act Count


'Pricing
'---------------------

'Before 9/1/2013
'4 Productions - 20% Discount off each ticket
'3 Productions - 15% Discount off each ticket
'2 Productions - 05% Discount off each ticket (Early Bird)
'1 Production -  05% Discount off each ticket (Early Bird)


'After 9/1/2013
'4 Productions - 15% Discount off each ticket
'3 Productions - 10% Discount off each ticket


'Eligible Productions
'---------------------
'ActCode	Act
'91306   	Carmina Burana 
'91309   	Lovely Vine: Jeremiah Ingalls and the American Folk Hymn 
'91307   	Noël, Noël: A French Christmas 
'91308   	Portes du Ciel—Gates of Paradise 


'Eligible Ticket Types
'---------------------
'Ticket Type		Ticket Code
'Price A Section 	(106) 
'Price B Section 	(107) 
'Price C Section 	(108) 
'General Admission 	(564)


'Eligible Price Tier/Section
'---------------------
'Not Applicable - All events are General Admission


'Offline/Online
'---------------------
'Discount available for both Box Office Orders and Internet Orders


'Service Fees
'---------------------
'No change to the per ticket service fees.


'Automatic/Code Entry
'---------------------
'Automatic Discount
'Discount code entry not required


'Expiration
'---------------------
'Discount does not expire


'Discount Limits
'---------------------
'Discount does not have a maximum cap

'================================

ActCodeList = "91306,91309,91307,91308"

SeatTypeList = "106,107,108,564"

EndDate = "9/01/2013"


'First Discount Tier
SeriesCount01 = 		1	'Acts
SeriesPercentage01 = 	0	'Percentage

'Second Discount Tier
SeriesCount03 = 		3	'Acts
SeriesPercentage03 = 	10	'Percentage

'Third Discount Tier
SeriesCount04 = 		4	'Acts
SeriesPercentage04 = 	15	'Percentage 



If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'Determine the original order date, for date based season subscriptions
'this allows re-opened orders to calculate based on the original order date

SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing

'Determine the number of acts on this order.
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND SeatTypeCode IN (" & SeatTypeList & ")  AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
ActCount = rsActCount("ActCount")	
rsActCount.Close
Set rsActCount = nothing
	
ErrorLog("ActCount "&ActCount&" ")
	
	
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
		
		ErrorLog("AppliedCount "&AppliedCount&" ")
		ErrorLog("Subs "&NbrSubscriptions &" ")

		'If the number of discounted seats at this price for these events is less then the total possible, apply discount
		
		Select Case ActCount
			Case SeriesCount04
				Percentage = SeriesPercentage04
			Case SeriesCount03
				Percentage = SeriesPercentage03
			Case Else
				Percentage = SeriesPercentage01
		End Select
				
		If CDate(OriginalDate) < CDate(EndDate) Then
			Percentage = Percentage + 5
		End If
		
		If AppliedCount < NbrSubscriptions Then	

			Select Case SeatTypeCode
			
				Case "106","107","108","564"
				
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)

			End Select		
		
		
			If Price > NewPrice Then
				DiscountAmount = Clean(Request("Price")) - NewPrice
				AppliedFlag = "Y"
			End If  
				
		End If


	End If				
	    
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>