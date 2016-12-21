<%

'CHANGE LOG - Inception
'SSR 6/14/2011
'Discount Script Updated. 


'CHANGE LOG - Inception
'SSR 5/25/2011
'Custom Season Subscription Discount Created. 

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'=======================================================
'Columbian Theatre (6/14/2011)
'Season Subscription Discount 2011

'Update: ticket types do  not need to match.



'Columbian Theatre (5/25/2011)
'Season Subscription Discount 2011

'It should start on June 1st, 2011
'$3 off each ticket if they buy all 5 shows 
'Productions included
'The Wiz - 64745
'A Christmas Survival Guide - 64746
'Boeing-Boeing - 64747 - removed 8/17/11
'Don't Dress For Dinner -68957 -added 8/17/11
'Funny Business - 64751
'The 25th Annual Putnam County Spelling Bee - 64752
'Contact:
'Aleasha
'aleasha@columbiantheatre.com


'=======================================================

'Season Subscription
'----------------------
'Buy 1 ticket to each of 5 productions and receive $3.00 off each ticket


'Valid Act Codes
'----------------
'The Wiz - 64745
'A Christmas Survival Guide - 64746
'Boeing-Boeing - 64747 - removed 8/17/11
'Don't Dress For Dinner -68957 -added 8/17/11
'Funny Business - 64751
'The 25th Annual Putnam County Spelling Bee - 64752


'Service Fees
'-------------------
'No change to service fees


'Number of Productions in the this season subscription
'-----------------------------------------------------
SeriesCount = 5 


'Amount of per ticket discount to give
'---------------------------------------
SeriesDiscount = 3.00


'ActCodes of Productions included in Season Subscription.
'---------------------------------------------------------
ActCodeList = "64745,64746,68957,64751,64752" 


'Valid Seat Type Code
'--------------------
'Any ticket type


'Begin Date
'-----------
StartDate = "6/01/2011"

'=======================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'Determine the original order date, for date based season subscriptions
'this allows re-opened orders to calculate based on the original order date

SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing


If CDate(OriginalDate) > CDate(StartDate) Then  

    'Count the number of Acts on the order with the same seat type code.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

		'Determine the number of possible subscriptions on the order
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
		NbrSubscriptions = rsMinTicketCount("NumSubs")		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
		
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
		ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing

		'Count the number of existing seats which have discount applied for this act and seat type code
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing

		'Should the number of discounts at this price for these events < the total possible, discount price
		If AppliedCount < NbrSubscriptions Then		    
			
			'Enter Season Ticket pricing rules here.
				    
		     NewPrice = Clean(Request("Price")) - SeriesDiscount
		    
		     If NewPrice < 0 Then
		        NewPrice = 0
		     End If
		    
		     If Price > NewPrice Then
                AppliedFlag = "Y"
             End If
		    
		     DiscountAmount = Clean(Request("Price")) - NewPrice

		End If	
											
	End If
	
End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>