<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->


<%

MaxSurCharge = 6

If AllowDiscount = "Y" Then

        SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
        Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

        If Not rsEventCount.EOF Then

                If rsEventCount("SeatCount") >= 1 Then 
                                               
                        NewPrice = (Price - (MaxSurCharge / rsEventCount("SeatCount"))	
                                               	
                        DiscountAmount = Clean(Request("Price")) - NewPrice

                        AppliedFlag = "Y"
                
                End If
        		
        End If
        
        rsEventCount.Close
        Set rsEventCount = nothing
	
End If
				


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>