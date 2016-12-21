<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

Page = "Survey"

SurveyNumber = 794
DiscountTypeNumber = 45936
SurveyClearDiscountTypeNumber = 37662

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

FirstHalfActCodes = "50468,50457,50472,50460,50465,50475" ',50350
SecondHalfActCodes = "50466,50458,50469,50462,50463,50473,50347"
ActCodeList1 = Split(FirstHalfActCodes,",")
ApplySeries1 = True
ApplySeries3 = True

ApplySeries2 = True
CountAct = 0

Series4ActCodes = "50350,50475,50465,50468"
Series4ActCodeList = Split(Series4ActCodes,",")
ApplySeries4 = True

For i = lbound(ActCodeList1) to ubound(ActCodeList1) 
    SQLEventDate = "SELECT Event.EventDate FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = " & ActCodeList1(i)
    Set rsEventDate = OBJdbConnection.Execute(SQLEventDate)
    If rsEventDate.EOF Then
        ApplySeries1 = False
        ApplySeries3 = False    
    Else
        If Weekday(rsEventDate("EventDate")) = 5 Then 'Thursday
            CountAct = CountAct + 1
        ElseIf Weekday(rsEventDate("EventDate")) = 6 Or Weekday(rsEventDate("EventDate")) = 7 Then 'Fri/Sat
            ApplySeries3 = False
        Else
            ApplySeries1 = False
        End If
    End If
    rsEventDate.Close
    Set rsEventDate = Nothing
Next

If CountAct < 6 Then 'Get PREVIEW nights
    ActCodeList2 = Split(SecondHalfActCodes,",")
    For i = lbound(ActCodeList2) to ubound(ActCodeList2) 
        SQLEventDate = "SELECT Event.EventDate FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = " & ActCodeList2(i)
        Set rsEventDate = OBJdbConnection.Execute(SQLEventDate)
        If Not rsEventDate.EOF Then
            CountAct = CountAct + 1
        End If
        rsEventDate.Close
        Set rsEventDate = Nothing
        If CountAct = 6 Then
            Exit For
        End If
    Next
End If

If CountAct < 6 Then
    ApplySeries2 = False
End If

For i = lbound(Series4ActCodeList) to ubound(Series4ActCodeList)
    SQLQuantity = "SELECT COUNT(LineNumber) AS TixCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = " & Series4ActCodeList(i)
    Set rsQuantity = OBJdbConnection.Execute(SQLQuantity)
    If rsQuantity("TixCount") = 0 Then
        ApplySeries4 = False    
    End If
    rsQuantity.Close
    Set rsQuantity = Nothing
Next

If ApplySeries2 = True Then 'Preview Friday or Thursday Series
    colorCnt = 0
    'check if same color
    SQLColor = "select color from section (NOLOCK) inner join seat (NOLOCK) on seat.eventcode = section.eventcode and seat.sectioncode = section.sectioncode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode where Seat.ordernumber = " & Session("OrderNumber") & " and Event.actcode IN(" & FirstHalfActCodes & "," & SecondHalfActCodes & ") GROUP BY COLOR"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	Do While Not rsColor.EOF
	    Color = UCase(rsColor("Color"))
	    colorCnt = colorCnt + 1
	    rsColor.movenext
	Loop
	rsColor.Close
	Set rsColor = Nothing
	If colorCnt = 1 Then
	    If Color = "BLUE" Then
	        NewPrice = 20
	    Else
	        NewPrice = 15
	    End If
	    
	    SQLUpdateQty = "SELECT ActCode, COUNT(ActCode) AS Qty FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.actcode IN(" & FirstHalfActCodes & "," & SecondHalfActCodes & ") GROUP BY ActCode ORDER BY Qty"
	    Set rsUpdateQty = OBJdbConnection.Execute(SQLUpdateQty)
	    MinTix = rsUpdateQty("Qty")
	    rsUpdateQty.Close
	    Set rsUpdateQty = Nothing
	    
	    Series2ActCodeList = Split(FirstHalfActCodes & "," & SecondHalfActCodes,",")
	    UpdateCount = 0
	    For i = lbound(Series2ActCodeList) to ubound(Series2ActCodeList)
	        SQLLineNo = "SELECT TOP(" & MinTix & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & Series2ActCodeList(i) & " ORDER BY LineNumber DESC"
            Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
            If Not rsLineNo.EOF Then
                Do While Not rsLineNo.EOF
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price - " & NewPrice & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                    rsLineNo.movenext
                Loop
                UpdateCount = UpdateCount + 1
            End If
            rsLineNo.Close
            Set rsLineNo = Nothing
            If UpdateCount = 6 Then
                Exit For
            End If
	    Next
	End If
ElseIf ApplySeries1 = True Or ApplySeries3 = True Then 'Friday or Saturday Series or Sunday Matinee Series
    colorCnt = 0
    'check if same color
    SQLColor = "select color from section (NOLOCK) inner join seat (NOLOCK) on seat.eventcode = section.eventcode and seat.sectioncode = section.sectioncode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode where Seat.ordernumber = " & Session("OrderNumber") & " and Event.actcode IN(" & FirstHalfActCodes & ") GROUP BY COLOR"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	Do While Not rsColor.EOF
	    Color = UCase(rsColor("Color"))
	    colorCnt = colorCnt + 1
	    rsColor.movenext
	Loop
	rsColor.Close
	Set rsColor = Nothing
	If colorCnt = 1 Then
	    SQLUpdateQty = "SELECT ActCode, COUNT(ActCode) AS Qty FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.actcode IN(" & FirstHalfActCodes & ") GROUP BY ActCode ORDER BY Qty"
	    Set rsUpdateQty = OBJdbConnection.Execute(SQLUpdateQty)
	    MinTix = rsUpdateQty("Qty")
	    rsUpdateQty.Close
	    Set rsUpdateQty = Nothing
	    
	    For i = lbound(ActCodeList1) to ubound(ActCodeList1)
	        If Color = "BLUE" Then
	            If ApplySeries1 = True Then
	                If i <> ubound(ActCodeList1) Then
	                    NewPrice = 26.5
	                End If
	            Else
	                If i <> ubound(ActCodeList1) Then
	                    NewPrice = 25
	                End If
	            End If
	        Else
	            If ApplySeries1 = True Then
	                If i <> ubound(ActCodeList1) Then
	                    NewPrice = 21
	                Else
	                    NewPrice = 19
	                End If
	            Else
	                If i <> ubound(ActCodeList1) Then
	                    NewPrice = 19
	                Else
	                    NewPrice = 20
	                End If
	            End If
	        End If
	    
	        SQLLineNo = "SELECT TOP(" & MinTix & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & ActCodeList1(i) & " ORDER BY LineNumber DESC"
            Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price - " & NewPrice & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                rsLineNo.movenext
            Loop
            rsLineNo.Close
            Set rsLineNo = Nothing
	    Next
	End If
ElseIf ApplySeries4 = True Then 'Musical Series
    colorCnt = 0
    'check if same color
    SQLColor = "select color from section (NOLOCK) inner join seat (NOLOCK) on seat.eventcode = section.eventcode and seat.sectioncode = section.sectioncode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode where Seat.ordernumber = " & Session("OrderNumber") & " and Event.actcode IN(" & Series4ActCodes & ") GROUP BY COLOR"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	Do While Not rsColor.EOF
	    Color = UCase(rsColor("Color"))
	    colorCnt = colorCnt + 1
	    rsColor.movenext
	Loop
	rsColor.Close
	Set rsColor = Nothing
	If colorCnt = 1 Then
	    If Color = "BLUE" Then
	        NewPrice = Price
	    Else
	        NewPrice = Price
	    End If
	    
	    SQLUpdateQty = "SELECT ActCode, COUNT(ActCode) AS Qty FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.actcode IN(" & Series4ActCodes & ") GROUP BY ActCode ORDER BY Qty"
	    Set rsUpdateQty = OBJdbConnection.Execute(SQLUpdateQty)
	    MinTix = rsUpdateQty("Qty")
	    rsUpdateQty.Close
	    Set rsUpdateQty = Nothing
	    
	    For i = lbound(Series4ActCodeList) to ubound(Series4ActCodeList)
	        SQLLineNo = "SELECT TOP(" & MinTix & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & Series4ActCodeList(i) & " ORDER BY LineNumber DESC"
            Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price - " & NewPrice & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                rsLineNo.movenext
            Loop
            rsLineNo.Close
            Set rsLineNo = Nothing
	    Next
	End If
Else 'No Subscription discount applied, reverse SurveyClear discounttypenumber
    ErrorLog("Camino Real Playhouse - Reverse SurveyClear Discount: " & SurveyClearDiscountTypeNumber & " for OrderNumber: " & Session("OrderNumber"))
    SQLNoDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & SurveyClearDiscountTypeNumber
    Set rsNoDiscount = OBJdbConnection.Execute(SQLNoDiscount)
End If

Call Continue

Sub Continue				
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If		
End Sub

%>