<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 544

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Bypass this survey if Comp Order
If Session("OrderTypeNumber") = 5 Then
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

'Check for Discounts/Passes/Packages
CurrentCompCount = 0

'Check for Festival Pass (4-Flex)
SQLFestivalPass = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = 176696 AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND GetDate() < DateAdd(day, 365, OrderDate)"
Set rsFestivalPass = OBJdbConnection.Execute(SQLFestivalPass)
FestivalPassCount = rsFestivalPass("TicketCount")
rsFestivalPass.Close
Set rsFestivalPass = nothing

'Check for Full Season (5-Show)
SQLFullSeason = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = 184597 AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND GetDate() < DateAdd(day, 365, OrderDate)"
Set rsFullSeason = OBJdbConnection.Execute(SQLFullSeason)
FullSeasonCount = rsFullSeason("TicketCount")
rsFullSeason.Close
Set rsFullSeasone = nothing

'Check for 4-Show Season
SQLFourShowSeason = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = 176697 AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND GetDate() < DateAdd(day, 365, OrderDate)"
Set rsFourShowSeason = OBJdbConnection.Execute(SQLFourShowSeason)
FourShowSeasonCount = rsFourShowSeason("TicketCount")
rsFourShowSeason.Close
Set rsFourShowSeasone = nothing

'Check for 3-Show Season
SQLThreeShowSeason = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = 176698 AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND GetDate() < DateAdd(day, 365, OrderDate)"
Set rsThreeShowSeason = OBJdbConnection.Execute(SQLThreeShowSeason)
ThreeShowSeasonCount = rsThreeShowSeason("TicketCount")
rsThreeShowSeason.Close
Set rsThreeShowSeason = nothing

CompCountAllowed = 0
OrderModified = FALSE
    
If FestivalPassCount > 0 Then 'Festival Pass Customer
    CompCountAllowed = 4 * FestivalPassCount 'Number of free screenings allowed

    SQLCompCount = "SELECT COUNT(OrderLine.ItemNumber) AS CompCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.Price - OrderLine.Discount = 0 AND OrderLine.StatusCode IN ('R', 'S') AND OrderTypeNumber <> 5 AND SurveyNumber = " & SurveyNumber
    Set rsCompCount = OBJdbConnection.Execute(SQLCompCount)
    CompCount = rsCompCount("CompCount")
    rsCompCount.Close
    Set rsCompCount = nothing
    
    Do Until CompCount >= CompCountAllowed     
        SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = 0, Surcharge = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber IN (SELECT Top 1 LineNumber FROM OrderLine (ROWLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND (OrderLine.Price <> 0) AND Event.SurveyNumber = " & SurveyNumber & " ORDER BY OrderLine.Price DESC)"
        Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)
        CompCount = CompCount + 1
        OrderModified = TRUE
    Loop	
    
ElseIf FullSeasonCount > 0 Then 'Full Season customer
    CompCountAllowed = 5 * FullSeasonCount 'Number of free screenings allowed
    ActCompAllowed = 1 * FullSeasonCount  'Per Act
    
    SQLCompCount = "SELECT COUNT(OrderLine.ItemNumber) AS CompCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.Price - OrderLine.Discount = 0 AND OrderLine.StatusCode IN ('R', 'S') AND OrderTypeNumber <> 5 AND SurveyNumber = " & SurveyNumber
    Set rsCompCount = OBJdbConnection.Execute(SQLCompCount)
    CompCount = rsCompCount("CompCount")
    rsCompCount.Close
    Set rsCompCount = nothing
    
    ActCompCount = 0
    ActLimit = FALSE
    Do Until CompCount >= CompCountAllowed Or ActCompCount >= ActCompAllowed OR ActLimit
	    
        SQLActCompCount = "SELECT TOP 1 Event.ActCode, COALESCE(CompCount,0) AS CompCount1 FROM Event (NOLOCK) LEFT JOIN (SELECT Event.ActCode, COUNT(LineNumber) AS CompCount FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.Price - OrderLine.Discount = 0 AND OrderLine.StatusCode IN ('R', 'S') INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber AND (CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode GROUP BY Event.ActCode) AS List ON Event.ActCode = List.ActCode WHERE Event.EventCode IN (SELECT DISTINCT Event.EventCode FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.StatusCode IN ('R', 'S') AND SurveyNumber = " & SurveyNumber & " AND OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND COALESCE(CompCount,0) < " & ActCompAllowed & " ORDER BY COALESCE(CompCount,0), Event.ActCode"
        Set rsActCompCount = OBJdbConnection.Execute(SQLActCompCount)
        If Not rsActCompCount.EOF Then
            ActCode = rsActCompCount("ActCode")
            ActCompCount = rsActCompCount("CompCount1")
            rsActCompCount.Close
            Set rsActCompCount = nothing
	        If ActCompCount < ActCompAllowed Then 'If current Comp count for this act less than allowed, proceed
	            SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = 0, Surcharge = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber IN (SELECT Top 1 LineNumber FROM OrderLine (ROWLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND (OrderLine.Price <> 0) AND Event.ActCode= " & ActCode & ")"
	            Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)
                CompCount = CompCount + 1
		        OrderModified = TRUE
            End If
        Else
            ActLimit = TRUE
        End If
    Loop	
    
ElseIf FourShowSeasonCount > 0 Then 'Four Show Season customer
    CompCountAllowed = 4 * FourShowSeasonCount 'Number of free screenings allowed
    ActCompAllowed = 1 * FourShowSeasonCount  'Per Act
    
    SQLCompCount = "SELECT COUNT(OrderLine.ItemNumber) AS CompCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.Price - OrderLine.Discount = 0 AND OrderLine.StatusCode IN ('R', 'S') AND OrderTypeNumber <> 5 AND SurveyNumber = " & SurveyNumber
    Set rsCompCount = OBJdbConnection.Execute(SQLCompCount)
    CompCount = rsCompCount("CompCount")
    rsCompCount.Close
    Set rsCompCount = nothing
    
    ActCompCount = 0
    ActLimit = FALSE
    Do Until CompCount >= CompCountAllowed Or ActCompCount >= ActCompAllowed OR ActLimit
	    
        SQLActCompCount = "SELECT TOP 1 Event.ActCode, COALESCE(CompCount,0) AS CompCount1 FROM Event (NOLOCK) LEFT JOIN (SELECT Event.ActCode, COUNT(LineNumber) AS CompCount FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.Price - OrderLine.Discount = 0 AND OrderLine.StatusCode IN ('R', 'S') INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber AND (CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode GROUP BY Event.ActCode) AS List ON Event.ActCode = List.ActCode WHERE Event.EventCode IN (SELECT DISTINCT Event.EventCode FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.StatusCode IN ('R', 'S') AND SurveyNumber = " & SurveyNumber & " AND Event.ActCode IN (34162,34152,34161,34149) AND OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND COALESCE(CompCount,0) < " & ActCompAllowed & " ORDER BY COALESCE(CompCount,0), Event.ActCode"
        Set rsActCompCount = OBJdbConnection.Execute(SQLActCompCount)
        If Not rsActCompCount.EOF Then
            ActCode = rsActCompCount("ActCode")
            ActCompCount = rsActCompCount("CompCount1")
            rsActCompCount.Close
            Set rsActCompCount = nothing
	        If ActCompCount < ActCompAllowed Then 'If current Comp count for this act less than allowed, proceed
	            SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = 0, Surcharge = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber IN (SELECT Top 1 LineNumber FROM OrderLine (ROWLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND (OrderLine.Price <> 0) AND Event.ActCode= " & ActCode & ")"
	            Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)
                CompCount = CompCount + 1
		        OrderModified = TRUE
            End If
        Else
            ActLimit = TRUE
        End If
    Loop	
    
ElseIf ThreeShowSeasonCount > 0 Then '3-Show Season customer
    CompCountAllowed = 3 * ThreeShowSeasonCount 'Number of free screenings allowed
    ActCompAllowed = 1 * ThreeShowSeasonCount  'Per Act
    
    SQLCompCount = "SELECT COUNT(OrderLine.ItemNumber) AS CompCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.Price - OrderLine.Discount = 0 AND OrderLine.StatusCode IN ('R', 'S') AND OrderTypeNumber <> 5 AND SurveyNumber = " & SurveyNumber
    Set rsCompCount = OBJdbConnection.Execute(SQLCompCount)
    CompCount = rsCompCount("CompCount")
    rsCompCount.Close
    Set rsCompCount = nothing
    
    ActCompCount = 0
    ActLimit = FALSE
    Do Until CompCount >= CompCountAllowed Or ActCompCount >= ActCompAllowed OR ActLimit
	    
        SQLActCompCount = "SELECT TOP 1 Event.ActCode, COALESCE(CompCount,0) AS CompCount1 FROM Event (NOLOCK) LEFT JOIN (SELECT Event.ActCode, COUNT(LineNumber) AS CompCount FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.Price - OrderLine.Discount = 0 AND OrderLine.StatusCode IN ('R', 'S') INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber AND (CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode GROUP BY Event.ActCode) AS List ON Event.ActCode = List.ActCode WHERE Event.EventCode IN (SELECT DISTINCT Event.EventCode FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.StatusCode IN ('R', 'S') AND SurveyNumber = " & SurveyNumber & " AND Event.ActCode IN (34162,34152,34161,34149) AND OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND COALESCE(CompCount,0) < " & ActCompAllowed & " ORDER BY COALESCE(CompCount,0), Event.ActCode"
        Set rsActCompCount = OBJdbConnection.Execute(SQLActCompCount)
        If Not rsActCompCount.EOF Then
            ActCode = rsActCompCount("ActCode")
            ActCompCount = rsActCompCount("CompCount1")
            rsActCompCount.Close
            Set rsActCompCount = nothing
	        If ActCompCount < ActCompAllowed Then 'If current Comp count for this act less than allowed, proceed
	            SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = 0, Surcharge = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber IN (SELECT Top 1 LineNumber FROM OrderLine (ROWLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND (OrderLine.Price <> 0) AND Event.ActCode= " & ActCode & ")"
	            Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)
                CompCount = CompCount + 1
		        OrderModified = TRUE
            End If
        Else
            ActLimit = TRUE
        End If
    Loop	
    
End If

If OrderModified Then 'Need to update OrderHeader

	'Calculate Subtotal and Surcharge
	SQLOrderLine = "SELECT Price, Surcharge, Discount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
	If rsOrderLine.EOF Then 'There aren't any order lines pending
		Session("OrderNumber") = ""
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		'REE 11/24/2 - Modified to redirect to Default
		Response.Redirect("Default.asp")
	Else
		Surcharge = 0
		Price = 0
		Discount = 0
		Do Until rsOrderLine.EOF
			Surcharge = Surcharge + rsOrderLine("Surcharge")
			Price = Price + rsOrderLine("Price")
			Discount = Discount + rsOrderLine("Discount")
			rsOrderLine.MoveNext
		Loop
		
		SQLOrderHeader = "SELECT ShipFee FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
		Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)
		
		'Update OrderHeader
		SQLUpdateHeader = "UPDATE OrderHeader WITH (ROWLOCK) SET Subtotal = " & Price & ", OrderSurcharge = " & Surcharge & ", Discount = " & Discount & ", Total = " & Price + Surcharge + rsOrderHeader("ShipFee") - Discount & ", StatusDate = '" & Now() & "' WHERE OrderNumber = " & Session("OrderNumber")
		Set UpdateHeader = OBJdbConnection.Execute(SQLUpdateHeader)	
	End If					
	rsOrderLine.Close
	Set rsOrderLine = nothing

End If

OBJdbConnection.Close
Set OBJdbConnection = nothing
						
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		
%>
