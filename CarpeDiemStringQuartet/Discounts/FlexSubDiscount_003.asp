<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Initialize Variables
Price = Clean(Request("Price"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))

SeriesCount = 3
ActCodeList = "0000" 'Exceptions for Columbian (Gift Certificates)

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Get the color for this section (if needed for discount)
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	
	Color = UCase(rsColor("Color"))
	
	rsColor.Close
	Set rsColor = nothing
	


	'Count # of Acts on the order.  Exclude Gift Certificates.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode NOT IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
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


				'Calculate Ticket Price because 3 does not divide into 80 evenly

				CombinedPrice = 80
				'Get AppliedCount
				SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
				Set rsCount = OBJdbConnection.Execute(SQLCount)

				Count = rsCount("AppliedCount")
				rsCount.Close
				Set rsCount = nothing

				Remainder = Count MOD SeriesCount

				If Remainder = SeriesCount - 1 Then
				    NewPrice = CombinedPrice - ((SeriesCount - 1) * Round(CombinedFee/SeriesCount, 2))
				Else
				    NewPrice = Round(CombinedPrice/SeriesCount, 2)
				End If

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