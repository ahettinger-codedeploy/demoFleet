<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'Helie Lee (11/15/2010)
'2 Tier Fixed Price Group Discount

'Group Rate for orders with 10 or more tickets
'1st ticket price = No discount
'2-10+ tickets price = $10.00

'==================================================

GroupTier1 = 1 'Number of tickets to discount in price tier 1
GroupTier2 = 9 'Number of tickets required to make Group Quantity

GroupPrice1 = Price 'No change
GroupPrice2 = 10    '$10.00 ticket price

SeatCodeList = 1  'Adult ticket only

'==================================================

If AllowDiscount = "Y" Then

    SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & " AND OrderLine.SeatTypeCode IN (" & SeatCodeList & ")"
    Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
    TicketCount = rsEventCount("SeatCount")
    rsEventCount.Close
    Set rsEventCount = nothing
        
    ErrorLog("TicketCount:  " & TicketCount & "")

        'Determine if there are enough tickets to qualify for the discount
        If TicketCount => (GroupTier1 + GroupTier2) Then 

                'Determine number of tickets per event on this order which have been given a discounted price
                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & " AND OrderLine.SeatTypeCode IN (" & SeatCodeList & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " "
                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)	

                'Determine if this ticket receives a discount		
                
                If rsDiscCount("LineCount") < Fix(TicketCount / (Fix(GroupTier1)+GroupTier2)) Then 'Apply the discount
	                 Select Case SeatTypeCode
                        Case SeatCodeList
                        NewPrice = GroupPrice1
                     End Select		
                Else
	                 Select Case SeatTypeCode
                        Case SeatCodeList
                        NewPrice = GroupPrice2
                     End Select	
                End If					
                    							
                rsDiscCount.Close
                Set rsDiscCount = nothing               
               
			    DiscountAmount = Price - NewPrice
			
			    'Determine if the per ticket fee should be changed.
			    If Request("CalcServiceFee") <> "N" Then
				 Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
			    End If
				
			    AppliedFlag = "Y"
        							
        End If
    
    
End If

					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>