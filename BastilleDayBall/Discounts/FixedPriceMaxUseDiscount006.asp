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

        'Determine the number of tickets which have already been discounted
        SQLCount = "SELECT DISTINCT (SELECT Count(*) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4449) as TicketOneCount, (SELECT Count(*) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4450) as TicketTwoCount, (SELECT Count(*) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4451)as TicketThreeCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = 46229 AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ") AND OrderLine.StatusDate >= '6/1/2010' Group by Orderline.SeatTypeCode"
        Set rsCount = OBJdbConnection.Execute(SQLCount)
        
        TicketCountOne = rsCount("TicketOneCount")
        TicketCountTwo = rsCount("TicketTwoCount")
        TicketCountThree = rsCount("TicketThreeCount")
        
       rsCount.Close
       Set rsCount = nothing 
       
       
        'Determine number of tickets which have been discounted
        SQLDiscCount = "SELECT DISTINCT (SELECT Count (*) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4449) as OneCount, (SELECT Count (*) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4450) as TwoCount, (SELECT Count (*) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4451) as ThreeCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber
        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
        
        DiscCountOne = rsDiscCount("OneCount")
        DiscCountTwo = rsDiscCount("TwoCount")
        DiscCountThree = rsDiscCount("ThreeCount")
        
       rsDiscCount.Close
       Set rsDiscCount = nothing 
        
        

       If DiscCountOne  < (OneSystemUsage -  TicketCountOne) Then         
		    Select Case SeatTypeCode
			    Case 4449
			    NewPrice = 15
            End Select
       Else
        	Select Case SeatTypeCode
			    Case 4449
			    NewPrice = Price
            End Select            
       End If
       
       
       If Int DiscCountTwo  < Int(TwoSystemUsage -  TicketCountTwo) Then         
		    Select Case SeatTypeCode
			    Case 4450
			    NewPrice = 75
            End Select
       Else
        	Select Case SeatTypeCode
			    Case 4450
			    NewPrice = Price
            End Select            
       End If
       
      If Int DiscCountThree < Int(ThreeSystemUsage -  TicketCountThree) Then         
		    Select Case SeatTypeCode
			    Case 4451
			    NewPrice = 150
            End Select
       Else
        	Select Case SeatTypeCode
			    Case 4451
			    NewPrice = Price
            End Select            
       End If
                   

        AppliedFlag = "Y"

    DiscountAmount = Price - NewPrice        
              


End If


        
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>