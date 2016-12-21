<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Committee of French Speaking Societies (6/14/2010)
'===================================================
'Fixed Price Discount with max number of discounts per ticket type

'SeatCode   Seat Name
'(4449)     Bleu tickets - the first 100 @ $15.00 each
'(4450)     Blanc tickets - the first 50 tickets @ $75.00 each
'(4451)     Rouge tickets - the first 25 tickets @ 150 each


'Discount Variables
OneSeatCode = 4449 'Bleu tickets
OneSystemUsage = 10
OnePrice = 15

TwoSeatCode = 4450 'Blanc tickets
TwoSystemUsage  = 10
TwoPrice = 75

ThreeSeatCode = 4451 'Rouge tickets
ThreeSystemUsage = 10
ThreePrice = 150


'Determine if there are valid tickets on order
SQLTicketCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND SeatTypeCode IN (" & OneSeatCode & ", " & TwoSeatCode & "," & ThreeSeatCode & ")"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
NbrTickets = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

If NbrTickets >= 1 Then

        HistoryBeginDate = CDate("6/13/2010")

        'Determine how many discounts have already been given
        SQLDiscCount = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND SeatTypeCode IN (" & OneSeatCode & ", " & TwoSeatCode & "," & ThreeSeatCode & ") AND OrderLine.StatusDate >= '" & HistoryBeginDate & "'"           	
        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
        
        If Not rsDiscCount.EOF Then
        
            Call DBOpen(OBJdbConnection2)
    		
            OneTotal = 0
            TwoTotal = 0
            ThreeTotal = 0       
            
            Do Until rsDiscCount.EOF
            
               'Ticket Type One
                If rsDiscCount("SeatTypeCode") = OneSeatCode Then
                OneTotal = OneTotal + 1
                End If
                
               'Ticket Type Two
                If rsDiscCount("SeatTypeCode") = TwoSeatCode Then
                TwoTotal = TwoTotal + 1
                End If
                
                'Ticket Type Three
                If rsDiscCount("SeatTypeCode") = ThreeSeatCode Then
                ThreeTotal = ThreeTotal + 1
                End If
            
            rsDiscCount.MoveNext
            
            Loop
            
        End If
       
                  
        'Apply the discount

              Select Case SeatTypeCode
                Case 4449
                    If OneTotal <= OneSystemUsage Then
                        FixedPrice = OnePrice
                    Else
                        NewPrice = Price
                    End If
                Case 4450
                    If TwoTotal <= TwoSystemUsage Then
                        FixedPrice = TwoPrice
                    Else
                        NewPrice = Price
                    End If
               Case 4451
                    If ThreeTotal <= ThreeSystemUsage Then
                        FixedPrice = ThreePrice
                    Else
                        FixedPrice = Price
                    End If
            End Select 
 
            
            rsDiscCount.Close
            Set rsDiscCount = nothing 

            
            If Price > 0 Then
                NewPrice = FixedPrice
                AppliedFlag = "Y"
            End If

            If NewPrice < 0 Then
               NewPrice = 0
            End If

            DiscountAmount = Price - NewPrice
            
              


End If
        
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>