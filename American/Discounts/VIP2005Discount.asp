<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = CDbl(Clean(Request("Price")))
DiscountAmount = 0
Surcharge = CDbl(Clean(Request("Surcharge")))
AppliedFlag = "N"
'REE 10/26/4 - Added NewSurcharge
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))


'Get Act Code
SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
Set rsAct = OBJdbConnection.Execute(SQLAct)

'Count # of existing seats which have discount applied for this act
SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE ActCode = " & rsAct("ActCode") & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND Orderline.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

rsAct.Close
Set rsAct = nothing

'If the # of discounts at this price for these events < the total possible, discount price
If rsDiscCount("LineCount") < 2 Then

	NewPrice = 0
	DiscountAmount = Clean(Request("Price")) - NewPrice
			
	'REE 10/26/4 - Added NewSurcharge
	If Request("NewSurcharge") <> "" Then
		Surcharge = NewSurcharge
	Else
		If Request("CalcServiceFee") <> "N" Then
			'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
		End If
	End If
			
	AppliedFlag = "Y"

End If	
rsDiscCount.Close
Set rsDiscCount = nothing


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>