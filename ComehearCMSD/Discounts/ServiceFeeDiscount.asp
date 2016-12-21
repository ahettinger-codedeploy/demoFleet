<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================

'Garden Club Theatre (6/21/2010)

'Percentage Off With Max Discount Per Order

'Discount will discount each ticket at the stated percentage
'Total amount of discount on the order will max out at the stated amount

'===============================

'Discount Variables
MaxDollarAmount = 100
Percentage = 25

'===============================

SQLDiscCount = "SELECT SUM(OrderLine.Discount) AS DiscountAmount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & ""
Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
TotalDiscountAmount = rsDiscCount("DiscountAmount")
rsDiscCount.Close
Set rsDiscCount = nothing

ErrorLog("TotalDiscountAmount" & TotalDiscountAmount & "")

If TotalDiscountAmount <= 100 Then

		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
		
		DiscountAmount = Clean(Request("Price")) - NewPrice
		
		If DiscountAmount > MaxDollarAmount - TotalDiscountAmount Then
            DiscountAmount = MaxDollarAmount - TotalDiscountAmount
            NewPrice = Clean(Request("Price")) - DiscountAmount
        End If

        AppliedFlag = "Y"
        
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>

