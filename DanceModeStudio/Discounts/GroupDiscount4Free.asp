<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))



SQLMaxCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber IN (" & DiscountTypeNumber & ") AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ")"
Set rsMaxCount = OBJdbConnection.Execute(SQLMaxCount)

TicketCount = rsMaxCount("LineCount")

rsMaxCount.Close
Set rsMaxCount = nothing
		
If TicketCount = 0 Then

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber IN (" & DiscountTypeNumber & ") AND OrderLine.OrderNumber IN (" & OrderNumber & ")"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
		If rsDiscCount("LineCount") < 8 Then

		
					If rsDiscCount("LineCount") < 4 Then 
						NewPrice = 0
						DiscountAmount = Price - NewPrice
						Surcharge = 0
						AppliedFlag = "Y"
					Else 
						NewPrice = 12
						DiscountAmount = Price - NewPrice
						Surcharge = 0
						AppliedFlag = "Y"
					End If	
									
					rsDiscCount.Close
					Set rsDiscCount = nothing 
		
		End If                     
			
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>