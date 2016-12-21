<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->


<%

'==================================================

'Group Discount Fixed Price - 1 Group Count Tier by Multiple Ticket Types

'==================================================

GroupQuantity = 4

SeatCodeList = "7608,4902,4903"
	
AllowMultiEvent = "N"

If Clean(Request("AllowMultiEvent")) = "Y" Then
	SQLMultiEvent = ""
Else
	SQLMultiEvent = " AND Seat.EventCode = " & Clean(Request("EventCode")) & ""
End If

'---------------------------------------------------------

If AllowDiscount = "Y" Then

        SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND OrderLine.SeatTypeCode IN (" & SeatCodeList & ")"& SQLMultiEvent
        Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

			If Not rsEventCount.EOF Then

					If rsEventCount("SeatCount") >= GroupQuantity Then 'Apply the discount to this order
						
							SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & ""
							Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
							
								Select Case SeatTypeCode 
									Case 7608 'Individual Box Seat
										NewPrice = 40
									Case 4902 'Adult General Admission 
										NewPrice = 6.25
									Case 4903 'Junior General Admission
										NewPrice = 6.25
								End Select
								
							rsDiscCount.Close
							Set rsDiscCount = nothing
													
							DiscountAmount = Clean(Request("Price")) -  NewPrice

							If Request("CalcServiceFee") <> "N" Then
								Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
							End If

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