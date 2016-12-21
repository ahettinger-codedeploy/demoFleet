<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->


<%

'==================================================

'Helie Lee (11/15/2010)
'2 Tier Fixed Price Group Discount
'Multiples of 6

'Buy multiples of 6 tickets
'---------------------------
'1st ticket = free
'2-6 ticket = $10.00
'Adult Only
'$0 surcharge

'==================================================

GroupQuantity = 10
GroupPrice = 10

'==================================================

If AllowDiscount = "Y" Then

        SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
        Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

        If Not rsEventCount.EOF Then

                If rsEventCount("SeatCount") >= GroupQuantity Then 'Apply the discount to this order
                	
                        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
                        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

                        If Int(rsDiscCount("LineCount")) = 1 Then 'Apply the discount to this item	
                            NewPrice = Price		
                        Else			
                            NewPrice = GroupPrice		
                        End If
                        	
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