<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'2011 Camino Real Playhouse 

'Automatic Discount

'IMPROV Season Subscription (10/12/2011)
'Discount given if patron buys 1 ticket for 2, 3 or 4+ Acts

'Valid Productions
'71340	ADVANCED IMPROVISATION (JAN 18 to FEB 22)
'71343	ADVANCED IMPROVISATION (JUL 18 to AUG 22) 
'71341	ADVANCED IMPROVISATION (MAR 14 to APR 18)
'71342	ADVANCED IMPROVISATION (MAY 16 to JUN 20)
'71344	ADVANCED IMPROVISATION (SEPT 19 to OCT 24) 
'71345	INTRODUCTION TO IMPROVISATION (JAN 19 to FEB 23)
'71348	INTRODUCTION TO IMPROVISATION (JUL 19 to AUG 23) 
'71346	INTRODUCTION TO IMPROVISATION (MAR 15 to APR 19)
'71347	INTRODUCTION TO IMPROVISATION (MAY 17 to JUN 21)
'71349	INTRODUCTION TO IMPROVISATION (SEPT 20 to OCT 25) 

'2 Act Series Pricing
'$410.00 per series ($205 per ticket price)

'3 Act Series Pricing
'$600 per series ($200 per ticket price)

'4 Act Series Pricing
'$780 per series ($195 per ticket price)

SeriesCount = 2
TicketPrice2 = 205
TicketPrice3 = 200
TicketPrice4 = 195
ActCodeList = "71340,71341,71342,71343,71344,71345,71346,71347,71348,71349"

'========================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Count # of Acts on the order.  Exclude Gift Certificates.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing	
	
	'4 Event Pricing
	If ActCount => 4 Then 
		SeriesCount = 4
		FixedPrice = TicketPrice4
			
	'3 Event Pricing	
	ElseIf ActCount = 3 Then 
		SeriesCount = 3
		FixedPrice = TicketPrice3
				
	'2 Event Pricing	
	ElseIf ActCount = 2 Then 
		SeriesCount = 2
		FixedPrice = TicketPrice2		
	End If
	
	
	If ActCount >= SeriesCount Then	    

		'Get the least number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
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
            
            NewPrice = FixedPrice	
            
            If Price > NewPrice Then
                DiscountAmount = Price - NewPrice
                AppliedFlag = "Y"
            End If
			
		Else  
		              	
            NewPrice = Price
            
        End If     
										
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>