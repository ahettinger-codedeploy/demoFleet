<%

'CHANGE LOG - Update
'SSR 6/09/2011
'Updated season subscription parameters


'CHANGE LOG
'INCEPTION SLM
'5.21.11

%>


<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%



'==================================================

'Bragg Creek Performing Arts (6/9/2011)
'updated season subscription.  All tickets on the order
'receive discounted price if there is 1 valid season subscription 
'on that same order

'Buy 1 ticket to each of 5 productions
'get 15% off each ticket

'Valid Acts:

'Catherine MacLellan (64693)
'Soaring Strings w/Dinner (64694)
'Madison Violet (64695)
'Kellylee Evans w/Dinner (64696)
'Carlos del Junco (64698)
'Jenn Beaupre,Souijah Fyah w/High Quill (64699)
'Ron Sexsmith (64701)

'==================================================

'Set Discount Variables
Percentage = 15 'For Percentage Discount.  10 is 10% off, 20 is 20% off, etc
SeriesCount = 5 'Number of Productions in the this Season Subscription
ActCodeList = "64693,64694,64695,64696,64698,64699,64701" 'ActCodes of Productions which can be included in Season Subscription.

'Initialize Variables
Price = Clean(Request("Price"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))

'==================================================


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Get the color for this section (if needed for discount)
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)	
	Color = UCase(rsColor("Color"))	
	rsColor.Close
	Set rsColor = nothing
	

    'Count # of Acts on the order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

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

		    'Should the # of discounts at this price for these events < the total possible, discount price
		    If AppliedCount < NbrSubscriptions Then		    			 
		        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)			
            Else			
                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
	        End If
    	    
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

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>