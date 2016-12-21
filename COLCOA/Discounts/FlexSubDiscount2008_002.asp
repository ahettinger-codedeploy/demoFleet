<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
i=0

'REE 8/10/4 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If




'Count # of existing seats which have discount applied for this act and seat type code
	SQLDiscCount2 = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount2 = OBJdbConnection.Execute(SQLDiscCount2)
    TotalDiscount = Int(rsDiscCount2("LineCount"))
    rsDiscCount2.Close
    Set rsDiscCount2 = nothing
   


If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.


'Expiration Date Functionality
	If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
		ExpirationDate = CDate(Clean(Request("ExpirationDate")))
	Else 'There is no expiration.  Add one to the current date so that it does not expire.
		ExpirationDate = DateAdd("d", 1, Now())
	End If

	'Start Date Functionality
	If Clean(Request("StartDate")) <> "" Then 'The discount has a start date
		StartDate = CDate(Clean(Request("StartDate")))
	Else 'There is no start date.  Subtract one from the current date so that it's valid now.
		StartDate = DateAdd("d", -1, Now())
	End If

	If Now() > StartDate And Now() < ExpirationDate Then
	
    
	
	'Count # of seats 3-DAY pass
	SQL3DAYCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode IN (25281,25282,25350)"
	Set rs3DAYCount = OBJdbConnection.Execute(SQL3DAYCount)
	Count3Day = Int(rs3DAYCount("LineCount")/2)
	rs3DAYCount.Close
	Set rs3DAYCount = nothing
	    
	'Count # of seats for VIP
	SQLVIPCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode IN (25345,25268,25353)"
	Set rsVIPCount = OBJdbConnection.Execute(SQLVIPCount)
	CountVIP = Int(rsVIPCount("LineCount")/2)
	rsVIPCount.Close
	Set rsVIPCount = nothing
	
	'Count # of seats for CampSite
	SQLCampSiteCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 25279"
	Set rsCampSiteCount = OBJdbConnection.Execute(SQLCampSiteCount)
	CountCampSite = Int(rsCampSiteCount("LineCount"))
	rsCampSiteCount.Close
	Set rsCampSiteCount = nothing

	'Get Act Code
	SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsAct = OBJdbConnection.Execute(SQLAct)
	ActCode = rsAct("ActCode")
	rsAct.Close
	Set rsAct = nothing

	'Find number of subscriptions by selecting event with min # of tickets at this price 
	NbrSubscriptions = Min(Array(Count3Day + CountVIP,CountCampSite)) * 2

    Select Case ActCode
    Case 25281,25282,25350
            ActCount = Count3Day
    Case 25345,25268,25353
            ActCount = CountVIP
    End Select
    
    
If TotalDiscount < NbrSubscriptions  then
    'Check to see if more discounts can be applied
    If NbrSubscriptions > 0 Then
		'Count # of existing seats which have discount applied for this act
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
        NoTix = rsDiscCount("LineCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing

		'If the # of discounts at this price for these events < the total possible, discount price
		If NoTix < Min(Array(ActCount * 2,NbrSubscriptions)) Then
            NewPrice = 5       
		End If
										
	End If
End if

	If Price > NewPrice Then
		DiscountAmount = Price - NewPrice
		AppliedFlag = "Y"
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