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
CombinedPrice = 20


SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.SeatTypeCode = 2980 AND OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND EventCode = 167879"
Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)
NoTixAct1 = rsAct1Count("LineCount")
rsAct1Count.Close
Set rsAct1Count = nothing

'at least 3 tickets on order, make total to be $20 total
If NoTixAct1 >= 3 Then
    'get the LineNumber of the last ticket on order
    SQLLastTicket = "SELECT MAX(LineNumber) AS LastLineNo FROM OrderLine (NOLOCK) WHERE OrderNumber = " & CleanNumeric(OrderNumber)
    Set rsLastTicket = OBJdbConnection.Execute(SQLLastTicket)
    LastLineNo = rsLastTicket("LastLineNo")
    rsLastTicket.Close
    Set rsLastTicket = Nothing
        
    SQLDiscountPackage = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.SeatTypeCode = 2980 AND OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND EventCode = 167879 AND OrderLine.LineNumber = " & CleanNumeric(Request("LineNumber"))
    Set rsDiscountPackage = OBJdbConnection.Execute(SQLDiscountPackage)
    If Not rsDiscountPackage.EOF Then
        If Request("OrderTypeNumber") = "1" Then
		    CombinedFee = 7.5
	    ElseIf Request("OrderTypeNumber") = "2" Then
		    CombinedFee = 4
	    ElseIf Request("OrderTypeNumber") = "3" Then
		    CombinedFee = 4.5
	    Else
		    CombinedFee = 0
	    End If
	           	
        If rsDiscountPackage("LineNumber") <> LastLineNo Then
		    PriceRemainder = 0
		    FeeRemainder = 0
		Else
		    PriceRemainder = CombinedPrice - (Round(CombinedPrice/NoTixAct1,2) * NoTixAct1)
		    FeeRemainder = CombinedFee - (Round(CombinedFee/NoTixAct1,2) * NoTixAct1)
		End If
    		
        NewPrice = Round(CombinedPrice/NoTixAct1,2) + PriceRemainder
        
        If Price > NewPrice Then
	        DiscountAmount = Price - NewPrice
	        AppliedFlag = "Y"
        End If
				
		Surcharge = Round(CombinedFee/NoTixAct1,2) + FeeRemainder
    End If
    rsDiscountPackage.Close
    Set rsDiscountPackage = Nothing
End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>