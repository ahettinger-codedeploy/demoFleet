<%
'CHANGE LOG
'SSR 8/1/2013 - Created discount
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


'============================================
'Bay Area Symphony (8/1/2013)

'2013 Season Subscription 
'Purchase 1 ticket to each of 4 productions:

'Act Codes
'-------------------
'94950   BARS 2014 Pride Concert
'95405   BARS: March 29-30
'94946   BARS: November 16-17
'94945   BARS: September 7, 2013

'Pricing
'-------------------
'20% Off

'Tickets must be in the same price category (color) and ticket types must match.
'Additional tickets do not get discounted.
'Do not recalc service fee.

'============================================

'Initialize Variables
SeriesCount = 4 'Number of Productions in the Subscription
SeriesPercentage = 20

NbrSubscriptions = 0
NbrTickets = 0

AllowedSeatTypeList = ""
AllowedSeatTypeCode = ""

SeatTypeCodeMatch = "Y"
SeatTypeMatchList = ""

SectionColorMatch = "Y"
Color = ""
ColorList = ""
SectionColorCode = ""

'--------------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	If AllowedSeatTypeCode <> "" Then
		AllowedSeatTypeList = " AND OrderLine.SeatTypeCode IN ("& AllowedSeatTypeCode &")"
	End If
	
	If SeatTypeCodeMatch <> "" Then		
		SeatTypeMatchList = " AND OrderLine.SeatTypeCode = " & SeatTypeCode & " "
	End If
	
	If SectionColorMatch <> "" Then		
	
		SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
		Set rsColor = OBJdbConnection.Execute(SQLColor)	
		Color = UCase(rsColor("Color"))	
		rsColor.Close
		Set rsColor = nothing	
				
		SQLColorList = "SELECT DISTINCT Color FROM Section (NOLOCK) INNER JOIN Seat ON Section.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & ""
		Set rsColorList = OBJdbConnection.Execute(SQLColorList)
		
			If Not rsColorList.EOF Then 
				Do Until rsColorList.EOF
					ColorList = ColorList & "'"& rsColorList("Color") &"',"
					rsColorList.MoveNext	
				Loop
			End If	

			If Len(ColorList) > 0 Then
				ColorList = Left(ColorList, len(ColorList) - 1)
			End If
		
		rsColorList.Close
		Set rsColorList = nothing  
		
		SectionColorCode = " AND Color = '" &Color& "' AND Color IN ("&ColorList&") "
			
	End If
			
	'Count # of applicable Acts on the order.
	SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = "& DiscountTypeNumber & AllowedSeatTypeList & SeatTypeMatchList & SectionColorCode &" AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then
	
		'Get the fewest number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
        If Not rsMinTicketCount.EOF Then
	        rsMinTicketCount.Move(SeriesCount - 1) 'Read ahead one less than the the SeriesCount records.  Check to see if there are SeriesCount different Acts are on order.
	        If Not rsMinTicketCount.EOF Then
        		NbrSubscriptions = rsMinTicketCount("NumSubs")
                NbrTickets = NbrSubscriptions * SeriesCount
	        End If
        End If
    	rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
				
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		rsAct.Close
		Set rsAct = nothing
		
		'Count # of existing seats which have discount applied for this act
		SQLDiscCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		AppliedCount = rsDiscCount("LineCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
		'Count total # of existing seats which have discount applied 
		SQLTotalCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsTotalCount = OBJdbConnection.Execute(SQLTotalCount)
		TotalCount = rsTotalCount("LineCount")
		rsTotalCount.Close
		Set rsTotalCount = nothing
		
		'If the # of discounts at this price for these events < the total possible, discount price
		If AppliedCount < NbrSubscriptions  Then
						
			If SeriesPercentage <> "" Then
			
				Percentage = SeriesPercentage
				NewPrice = round(Price * (1-CDbl(((Percentage)))/100), 2)
				DiscountAmount = Price - (round(Price * (1-CDbl(Clean(Request("Percentage")))/100), 2))
				AppliedFlag = "Y"
				
				If Request("NewSurcharge") <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
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
%>