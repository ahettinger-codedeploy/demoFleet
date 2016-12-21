<%

'CHANGE LOG - Inception
'SSR (9/12/2011)
'Custom Discount Code

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'Anderson Symphony Orchestra
'Family Pack Discount

'SilviaTIX: omg!
'SilviaTIX: dana stone is killing me
'SilviaTIX: killing me
'sergiotix: Anderson Symphony?
'SilviaTIX: yes
'sergiotix: what is she asking for?
'SilviaTIX: she sent in a discount code request
'SilviaTIX: i asked follow-up questions...one week ago!
'SilviaTIX: just got the answers today
'SilviaTIX: and, of course, she wants it available for tomorrow
'SilviaTIX: she copied you on the initial email
'sergiotix: want me to knock it out real quick?
'SilviaTIX: it seems simple, but let me take a quick look
'sergiotix: is it a subscription?
'SilviaTIX: free student with paid adult, plus the adult ticket gets 20% off
'sergiotix: omg
'SilviaTIX: what?
'sergiotix: super easy
'SilviaTIX: okay...let me write it up


'Client would like  a discount that does the following:
'1 Free Student Ticket (any section) with the Purchase of 1 Adult Ticket (any section)
'AND we’d like the adult tickets in the order to be 20% off.
'Code Name: ForKids
'Active after October 2 and through March 2013.
'Attach to Halloween 10/27 ASO, Christmas 12/8 ASO, Legend Rituals and Folklore 2/9 ASO
'Do not recalc the fees
'Contact
'Dana Stone
'dana@andersonsymphony.org


'-------------------------------------------------------------

'Discount Parameters

AdultSeatList = 1  'Senior (55 and over), Veteran, VIP, Premium Seating 
ChildSeatList = 1119 'Child

PackageQuantity = 2

ChildDiscount = 100
AdultDiscount = 20

ExpirationDate = "04/01/2013"


'=================================================================

'Check to see if discount has reached expirationdate.
'Use the original order date, rather than today's date as
'this allows the order to be re-opened without losing the discounted pricing

SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalOrderDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing

If CDate(OriginalOrderDate) < CDate(ExpirationDate) Then  


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

If AdultCount => (PackageQuantity / 2 ) AND ChildCount => (PackageQuantity / 2 ) Then

    If ChildCount > AdultCount Then
        NewCount = AdultCount
    End If
    
    If AdultCount > ChildCount Then
        NewCount = ChildCount
    End If
    
    If AdultCount = ChildCount Then
        NewCount = AdultCount
    End If

    CountRemainder = (NewCount Mod 2)

    If CountRemainder = 0 Then
        QuanityDiscount = NewCount       
    Else
        QuanityDiscount = CountRemainder
    End If

'Discount the Child tickets from the event
SQLApplyDiscount = "SELECT TOP (" & QuanityDiscount & ") OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN ( " & ChildSeatList & " ) ORDER BY OrderLine.Price"
Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)

Do While Not rsApplyDiscount.EOF

    If CInt(Request("LineNumber")) = CInt(rsApplyDiscount("LineNumber")) Then
        
        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(ChildDiscount)/100), 2)
        
        If Price > NewPrice Then
            DiscountAmount = Price - NewPrice
        End If
        
        AppliedFlag = "Y"
        
        If Request("CalcServiceFee") <> "N" Then
        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
        End If
        
    End If

rsApplyDiscount.movenext
Loop

rsApplyDiscount.Close
Set rsApplyDiscount = Nothing


'Discount the Adult tickets from the event
SQLApplyDiscount = "SELECT TOP (" & QuanityDiscount & ") OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN ( " & AdultSeatList & " ) ORDER BY OrderLine.Price"
Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)

Do While Not rsApplyDiscount.EOF

    If CInt(Request("LineNumber")) = CInt(rsApplyDiscount("LineNumber")) Then
        
        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(AdultDiscount)/100), 2)
        
        If Price > NewPrice Then
            DiscountAmount = Price - NewPrice
        End If
        
        AppliedFlag = "Y"
        
        'If Request("CalcServiceFee") <> "N" Then
        'Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
        'End If
        
    End If

rsApplyDiscount.movenext
Loop

rsApplyDiscount.Close
Set rsApplyDiscount = Nothing


End If

End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>