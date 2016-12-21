<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->
<%

Dim EAMEventCode
Dim EPMEventCode

EventCode = CDbl(EventCode)

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	EAMEventCode = Array(89913, 89918, 89924, 89927, 89937, 89940, 89945, 89949, 89953, 89968, 89973, 89977)
	EPMEventCode = Array(89915, 89919, 89925, 89928, 89938, 89942, 89947, 89950, 89954, 89970, 89974, 89978)
	
	EAMEvent = 0
	For i = 0 To 11
		If EventCode = EAMEventCode(i) Then
			EAMEvent = EventCode
			EPMEvent = EPMEventCode(i)
		End If
	Next
	If EAMEvent = 0 Then 'It wasn't in the EAM list. Check the EPM list
		For i = 0 To 11
			If EventCode = EPMEventCode(i) Then
				EPMEvent = EventCode
				EAMEvent = EAMEventCode(i)
			End If
		Next
	End If
	
	If EAMEvent <> 0 Then

		SQLActCount = "SELECT EAM.OrderNumber, EAMSeatCount, EPMSeatCount FROM (SELECT Event.EventCode, OrderLine.OrderNumber, COUNT(Seat.ItemNumber) AS EAMSeatCount FROM Event INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EAMEvent & " GROUP BY Event.EventCode, OrderLine.OrderNumber) AS EAM INNER JOIN (SELECT  Event.EventCode, OrderLine.OrderNumber, COUNT(Seat.ItemNumber) AS EPMSeatCount FROM Event  INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON OrderLine.ItemNumber = SEat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EPMEvent & " GROUP BY Event.EventCode, OrderLine.OrderNumber) AS EPM ON EAM.OrderNumber = EPM.OrderNumber"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	
		If Not rsActCount.EOF Then
	
			EAMCount = rsActCount("EAMSeatCount")
			EPMCount = rsActCount("EPMSeatCount")
			NbrSubscriptions = Min(Array(EAMCount, EPMCount))
			OrderNumber = rsActCount("OrderNumber")
	
		Else
			
			EAMCount = 0
			EPMCount = 0
			NbrSubscriptions = 0
			OrderNumber = ""
	
		End If
	
		rsActCount.Close
		Set rsActCount = nothing
		
		If NbrSubscriptions > 0 Then
		
			'Count # of existing seats which have discount applied for this act and seat type code
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
			AppliedCount = rsDiscCount("LineCount")
		
			rsDiscCount.Close
			Set rsDiscCount = nothing
			
			'If the # of discounts at this price for these events < the total possible, discount price
			If AppliedCount < NbrSubscriptions Then
				If EventCode = 89927 Or EventCode = 89928 Then
					NewPrice = Price - 10
				Else
					NewPrice = Price - 7.50
				End If
			End If
			
		End If
		
	End If
	
	If Price > NewPrice Then
		DiscountAmount = Price - NewPrice
		AppliedFlag = "Y"
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>