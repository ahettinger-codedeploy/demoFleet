<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SectionCode = Clean(Request("SectionCode"))

GroupPrice = 102.92
GroupCount = 4

	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then
				If rsEventCount("SeatCount") >= GroupCount Then 		

					SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
					Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

							If Int(rsDiscCount("LineCount") / GroupCount) < Int(rsEventCount("SeatCount") / GroupCount) Then 'Apply the discount to this item	

								Select Case Section
								
								Case GENAD' General Admission
								'Calculates the per ticket discount
								Remainder = Count MOD GroupCount
								If Remainder = GroupCount - 1 Then 
								    NewPrice = GroupPrice - ((GroupCount - 1) * Round(GroupPrice/GroupCount, 2))
								Else
									  NewPrice = Round(GroupPrice/GroupCount, 2)
								End If
												
								End Select	

								DiscountAmount = Clean(Request("Price")) - NewPrice

										If Request("CalcServiceFee") <> "N" Then

											Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
								
										End If
								
								AppliedFlag = "Y"
								
							End If
							
				End If
				
	End If
	

					
	rsEventCount.Close
	Set rsEventCount = nothing



Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>