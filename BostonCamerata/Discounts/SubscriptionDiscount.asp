<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"
ActCodeList = ""
ActCodes = "67414, 66219, 66220, 54359"
EventCodes = "378104, 387050, 387051, 387052, 387054, 378146, 378147"
DiscountTypeNumber = "59658"

'Get ActCodes in the list
SQLActCode = "SELECT Event.ActCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodes & ") GROUP BY Event.ActCode ORDER BY Event.ActCode"
Set rsActCode = OBJdbConnection.Execute(SQLActCode)
Do While Not rsActCode.EOF
    ActCodeList = ActCodeList & rsActCode("ActCode") & ","
    rsActCode.movenext
Loop
rsActCode.Close
Set rsActCode = nothing

If ActCodeList <> "" Then
    ActCodeList = Left(ActCodeList,len(ActCodeList)-1)    
End If
ActCodeArray = Split(ActCodeList,",")
ActCodeCount = UBound(ActCodeArray) + 1

ExpirationDate = CDate(Clean(Request("ExpirationDate")))

MaxDiscountsPerOrder = CInt(Clean(Request("MaxDiscountsPerOrder")))
MaxDiscountsPerOrderOK = "Y"
If MaxDiscountsPerOrder <> 0 Then
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	If TicketCount >= MaxDiscountsPerOrder Then
		MaxDiscountsPerOrderOK = "N"
	End If
End If

If CInt(ActCodeCount) >= 3 And Now() < ExpirationDate And MaxDiscountsPerOrderOK = "Y" Then
    If InStr(EventCodes, Request("EventCode")) Then 'Event belongs to list
        If SeatTypeCode = "1119" Then 'Student (w/ ID)
            NewPrice = Price
        Else
            NewPrice = Price * 0.8
        End If
        
        If Price > NewPrice Then
            DiscountAmount = Price - NewPrice
            AppliedFlag = "Y"
        End If
        
        If Request("CalcServiceFee") = "Y" Then
		    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
	    End If
	End If
End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>