<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Initialize Variables
Price = Clean(Request("Price"))
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))


'Count # of seats for Saturday Gala performances
	SQLGalaCount = "SELECT COUNT EventCode AS TicketCount FROM Event (NOOCK) WHERE EventCode IN (265287,269196,269525,269527,269526,269197,269198)"
	Set rsGalaCount = OBJdbConnection.Execute(SQLGalaCount)
	GalaCount = rsGalaCount ("TicketCount")
	rsGalaCount.Close
	
	
'Count the number of seats in blue section
	SQLBlue = "SELECT COUNT Color As SectionCount FROM Section(NOLOCK) WHERE EventCode IN (265287,269196,269525,269527,269526,269197,269198) AND COLOR = 'BLUE'"
	Set rsBlue = OBJdbConnection.Execute(SQLBlue)
	BlueCount = rsBlue("SectionCount")
	rsBlue.Close
	Set rsBlue = nothing
		
		
'Count the number of seats in gold section
	SQLGold = "SELECT COUNT Color As SectionCount FROM Section(NOLOCK) WHERE EventCode IN (265287,269196,269525,269527,269526,269197,269198) AND COLOR = 'GOLD'"
	Set rsGold = OBJdbConnection.Execute(SQLGold)
	GoldCount = rsGold("SectionCount")
	rsGold.Close
	Set rsGold = nothing
	
	
' Determine subscription type
If Galacount = 7 AND BlueCount = 7 Then 	
	    SeriesName = "Gala" 
	    SeriesPrice = 235
	    SeriesCount = 7
ElseIf Galacount = 7 AND GoldCount = 7 Then 
	    SeriesName = "Gala" 
	    SeriesPrice = 200
	    SeriesCount = 7
End If


    'Count # of Acts on the order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & SeatTypeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
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

		'If the # of discounts at this price for these events < the total possible, discount price
		If AppliedCount < NbrSubscriptions Then		  
		
		        'Count number of tickets which have been given a discount
		        SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		        Set rsCount = OBJdbConnection.Execute(SQLCount)
		        Count = rsCount("AppliedCount")
		        rsCount.Close
		        Set rsCount = nothing  
	      

		        Remainder = Count MOD SeriesCount
		        If Remainder = SeriesCount - 1 Then 
		            NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
		        Else
			          NewPrice = Round(SeriesPrice/SeriesCount, 2)
		        End If
		        

	            If Price > NewPrice Then
		            DiscountAmount = Clean(Request("Price")) - NewPrice
		            AppliedFlag = "Y"
	            End If
	

        End If

 End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>