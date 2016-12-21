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
DiscountTypeNumber = 46229

SeatCodeOne = 4449 'Bleu tickets
SystemUsageOne = 100
PriceOne = 15

TwoSeatCode = 4450 'Blanc tickets
TwoSystemUsage  = 50
TwoPrice = 75

ThreeSeatCode = 4451 'Rouge tickets
ThreeSystemUsage = 25
ThreePrice = 150

Call DBOpen(OBJdbConnection)
Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)
Call DBOpen(OBJdbConnection4)
Call DBOpen(OBJdbConnection5)
Call DBOpen(OBJdbConnection6)


'Determine number of Ticket Type One
SQLCountOne = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND ItemType = 'Seat' AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ") AND OrderLine.SeatTypeCode IN (" & SeatCodeOne & " )"
Set rsCountOne = OBJdbConnection.Execute(SQLCountOne)
NbrTicketsOne = rsCountOne("TicketCount")
rsCountOne.Close
Set rsCountOne = nothing

'Determine number of Ticket Type Two
SQLCountTwo = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND ItemType = 'Seat' AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ") AND OrderLine.SeatTypeCode IN (" & SeatCodeTwo & " )"
Set rsCountTwo = OBJdbConnection2.Execute(SQLCountTwo)
NbrTicketsTwo = rsCountTwo("TicketCount")
rsCountTwo.Close
Set rsCountTwo = nothing

'Determine number of Ticket Type Three
SQLCountThree = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND ItemType = 'Seat' AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ") AND OrderLine.SeatTypeCode IN (" & SeatCodeThree & " )"
Set rsCountThree = OBJdbConnection3.Execute(SQLCountThree)
NbrTicketsThree = rsCountThree("TicketCount")
rsCountThree.Close
Set rsCountThree = nothing


        'Determine number of One tickets which have been discounted
        SQLDiscCountOne = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & SeatCodeOne & ")"
        Set rsDiscCountOne = OBJdbConnection4.Execute(SQLDiscCountOne)

        If Int(rsDiscCountOne("LineCount")) < Int(OneSystemUsage - NbrTicketsOne) Then 
        
		    Select Case SeatTypeCode
			    Case SeatCodeOne
			    NewPrice = PriceOne
            End Select
       Else
        	Select Case SeatTypeCode
			    Case SeatCodeOne
			    NewPrice = Price
            End Select
            
       End If
       
       
       rsDiscCountOne.Close
	   Set rsDiscCountOne = nothing
	   
	   
	   
	   'Determine number of Two tickets which have been discounted
        SQLDiscCountTwo = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & SeatCodeTwo & ")"
        Set rsDiscCountTwo = OBJdbConnection5.Execute(SQLDiscCountTwo)

        If Int(rsDiscCountTwo("LineCount")) < Int(TwoSystemUsage - NbrTicketsTwo) Then 
        
		    Select Case SeatTypeCode
			    Case SeatCodeTwo
			    NewPrice = PriceTwo
            End Select
       Else
        	Select Case SeatTypeCode
			    Case SeatCodeTwo
			    NewPrice = Price
            End Select
            
       End If
       
       
       rsDiscCountTwo.Close
	   Set rsDiscCountTwo = nothing
	   
	   
	   'Determine number of Three tickets which have been discounted
       SQLDiscCountThree = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & SeatCodeThree & ")"
       Set rsDiscCountThree = OBJdbConnection6.Execute(SQLDiscCountThree)

        If Int(rsDiscCountThree("LineCount")) < Int(ThreeSystemUsage - NbrTicketsThree) Then 
        
		    Select Case SeatTypeCode
			    Case SeatCodeThree
			    NewPrice = PriceThree
            End Select
       Else
        	Select Case SeatTypeCode
			    Case SeatCodeThree
			    NewPrice = Price
            End Select
            
       End If
       
       
       rsDiscCountThree.Close
	   Set rsDiscCountThree = nothing
        
        If Price > NewPrice Then
            DiscountAmount = Clean(Request("Price")) - NewPrice
            AppliedFlag = "Y"
        End If
    	        
Call DBClose(OBJdbConnection)
Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection4)
Call DBClose(OBJdbConnection5)
Call DBClose(OBJdbConnection6)
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>