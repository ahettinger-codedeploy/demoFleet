<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Committee of French Speaking Societies (6/14/2010)
'===================================================
'Fixed Price Discount with Max System Usage by Ticket Type

'SeatCode   Ticket Type    Fixed Price     Max
'4449       Bleu ticket    $15.00          100
'4450       Blanc ticket   $75.00          50
'4451       Rouge ticket   $150.00         25


'Discount Variables
HistoryBeginDate = CDate("6/13/2010")

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
        
        'Apply the discount

              Select Case SeatTypeCode
                Case 4449
                
                    'Determine the number of tickets which have already been discounted
                    SQLDiscCountOne = "SELECT Count(*) as TicketCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = 46229 AND OrderLine.SeatTypeCode = 4449 AND OrderLine.StatusDate >= '6/1/2010'"
                    Set rsDiscCountOne = OBJdbConnection.Execute(SQLDiscCountOne)        
                    TicketOneCount = rsDiscCountOne("TicketCount")        
                    rsDiscCountOne.Close
                    Set rsDiscCountOne = nothing 
        
                    If TicketOneCount <= OneSystemUsage Then
                        FixedPrice = OnePrice
                    Else
                        NewPrice = Price
                    End If
                    
                Case 4450
                
                    'Determine the number of tickets which have already been discounted
                    SQLDiscCountTwo = "SELECT Count(*) as TicketCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = 46229 AND OrderLine.SeatTypeCode = 4450 AND OrderLine.StatusDate >= '6/1/2010'"
                    Set rsDiscCountTwo = OBJdbConnection.Execute(SQLDiscCountTwo)        
                    TicketTwoCount = rsDiscCountTwo("TicketCount")        
                    rsDiscCountTwo.Close
                    Set rsDiscCountTwo = nothing 
        
                    If TicketTwoCount <= TwoSystemUsage Then
                        FixedPrice = TwoPrice
                    Else
                        NewPrice = Price
                    End If
                    
                    
               Case 4451
               
                    'Determine the number of tickets which have already been discounted
                    SQLDiscCountThree = "SELECT Count(*) as TicketCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = 46229 AND OrderLine.SeatTypeCode = 4451 AND OrderLine.StatusDate >= '6/1/2010'"
                    Set rsDiscCountThree = OBJdbConnection.Execute(SQLDiscCountThree)        
                    TicketThreeCount = rsDiscCountThree("TicketCount")        
                    rsDiscCountThree.Close
                    
                    Set rsDiscCountThree = nothing 
                    If TicketThreeCount <= ThreeSystemUsage Then
                        FixedPrice = ThreePrice
                    Else
                        FixedPrice = Price
                    End If
            End Select 
 
            


            
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