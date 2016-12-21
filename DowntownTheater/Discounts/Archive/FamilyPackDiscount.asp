<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

<!--CHANGE LOG-->
<!--SSR 3/07/2011 - Initial Development-->

'==================================================
'Garland School District

'Buy 1 Get 1 Free 

'Buy 1 Adult ticket Get 1 ticket free
'Required ticket must be Adult
'Free ticket may be either Adult or Child
'Child tickets are discounted first, then Adult

AdultSeatList = 1
ChildSeatList = 5

'==================================================

'Initialize Discount Variables
Price = CDbl(Clean(Request("Price")))
SeatTypeCode = CInt(CleanNumeric(Request("SeatTypeCode")))
NewPrice = Price
DiscountAmount = 0
Surcharge = CDbl(Clean(Request("Surcharge")))
AppliedFlag = "N"
OrderNumber = CleanNumeric(Request("OrderNumber"))
EventCode = CleanNumeric(Request("EventCode"))
DiscountTypeNumber = CleanNumeric(Request("DiscountTypeNumber"))
SectionCode = Clean(Request("SectionCode"))
DiscountCode = UCase(Clean(Request("DiscountCode")))

'==================================================


'Determine the number of Adult tickets on this order
SQLAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS AdultCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultSeatList & ")"
Set rsAdultCount = OBJdbConnection.Execute(SQLAdultCount)
AdultCount = rsAdultCount("AdultCount")
rsAdultCount.Close
Set rsAdultCount = Nothing


'Determine the number of Child tickets on this order
SQLChildCount = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & ChildSeatList & ")"
Set rsChildCount = OBJdbConnection.Execute(SQLChildCount)
ChildCount = rsChildCount("ChildCount")
rsChildCount.Close
Set rsChildCount = Nothing

'Determine the number of free child tickets
If ChildCount > AdultCount Then
    FreeChildCount = AdultCount
Else
    FreeChildCount = ChildCount
End If


'-----------------------------------------------------------------
'Determine the number of free adult tickets
'Frist, remove the Adult tickets which are paired with the Child tickets
'----------------------------------------------------------------

AdultCount1 = (AdultCount-ChildCount) 

'-----------------------------------------------------------------
'If there is at least another pair of Adult tickets left, continue
'----------------------------------------------------------------

If AdultCount1 => 2 Then

'-----------------------------------------------------------------
'Divide remaining tickets by 2 to determine if they are even number
'----------------------------------------------------------------

AdultRemainder = (AdultCount1 Mod 2)

'-----------------------------------------------------------------
'If AdultRemainder = 0 then there is an even number of tickets
'Divide remaining tickets by 2 to determine # free Adult tickets
'----------------------------------------------------------------

If AdultRemainder = 0 Then
    FreeAdultCount = ((AdultCount-ChildCount) / 2)
    
'-----------------------------------------------------------------
'If AdultRemainder not = 0 then there is an odd number of tickets
'Use AdultRemainder as the closest whole number for # of free tickets
'----------------------------------------------------------------
    
Else
    FreeAdultCount = AdultRemainder
End If
Else
    FreeAdultCount = 0
End If

'-----------------------------------------------------------------
'Combine the number of free child and free adult tickets
'for the final total of free tickets on the order
'----------------------------------------------------------------

FreeTicketCount = FreeChildCount + FreeAdultCount


'Discount the number of Free tickets from the event
SQLApplyDiscount = "SELECT TOP (" & FreeTicketCount  & ") OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND Seat.SectionCode = 'GA' ORDER BY OrderLine.Price"
Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
Do While Not rsApplyDiscount.EOF
    If CInt(Request("LineNumber")) = CInt(rsApplyDiscount("LineNumber")) Then
        NewPrice = 0
        Surcharge = 0
        If Price > NewPrice Then
            DiscountAmount = Price - NewPrice
        End If
        AppliedFlag = "Y"
    End If
    rsApplyDiscount.movenext
Loop
rsApplyDiscount.Close
Set rsApplyDiscount = Nothing


	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>