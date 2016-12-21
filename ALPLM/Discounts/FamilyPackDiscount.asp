<%

'CHANGE LOG - Inception
'SSR 5/4/2012


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'------------------------------------

'Lincoln Presidential Library and Museum
'Family Pack Discount

'Family Pack Price of $10.00
'Family Pack is min 1 up to max 4 tickets
'4 tickets maximum discounted per event
'$0.00 tickets are not counted towards discount
 
SeriesCount1 = 1
SeriesCount2 = 2
SeriesCount3 = 3
SeriesCount4 = 4

SeriesPrice = 10
 
'------------------------------------
 
If AllowDiscount = "Y" Then 

	'Determine the number of required Tickets on order
	SQLEventCount = "SELECT COUNT(OrderLine.LineNumber) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.Price > 0"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

		If Not rsEventCount.EOF Then
			
			If rsEventCount("SeatCount") >=  SeriesCount4 Then
                        SeriesCount = SeriesCount4
                  ElseIf rsEventCount("SeatCount") =  SeriesCount3 Then
                        SeriesCount = SeriesCount3
                  ElseIf rsEventCount("SeatCount") =  SeriesCount2 Then
                        SeriesCount = SeriesCount2
                  ElseIf rsEventCount("SeatCount") =  SeriesCount1 Then
                        SeriesCount = SeriesCount1
                  End If

                  'Determine number of existing seats which have discount applied.
                  SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
                  Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
                  
                        If Int(rsDiscCount("LineCount") /SeriesCount) < Int(rsEventCount("SeatCount") / SeriesCount) Then 'Apply the discount to this item	
                                                      
                                    AppliedCount = Int(rsDiscCount("LineCount"))
                                    TotalCount   = Int(rsEventCount("SeatCount")) 

                                    'MOD function to determine the last ticket
                                    Remainder = AppliedCount MOD SeriesCount
                                    
                                    'Calculates the discount to be assign to last ticket.
                                    If Remainder = SeriesCount - 1 Then 
                                          NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice / SeriesCount, 2))
                                    Else
                                          'Standard rounding on all other tickets.
                                          NewPrice = Round(SeriesPrice/SeriesCount, 2)
                                    End If
                        
                                    DiscountAmount = Clean(Request("Price")) - NewPrice
                                                
                                    If Price > NewPrice Then

                                          If NewPrice < 0 Then 
                                                NewPrice = 0
                                          End if

                                          AppliedFlag = "Y"

                                          If Request("NewSurcharge") <> "" Then
                                                Surcharge = NewSurcharge	
                                          ElseIf Request("CalcServiceFee") <> "N" Then
                                                Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
                                          End If

                                    End If

                        End If
                        
                  rsDiscCount.Close
                  Set rsDiscCount = nothing

				
		End If
							
	rsEventCount.Close
	Set rsEventCount = nothing
	
End If


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>