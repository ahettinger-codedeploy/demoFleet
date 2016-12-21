<%

'CHANGE LOG
'SSR  (7/02/2012) - Update: Replaced 6 act requirement with 6 ticket requirement
'SLM  (6/15/2012) - Added ticket type to ticket type list
'SSR  (5/16/2012) - Inception: Custom Discount Code Created. 


%>
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = CDbl(Clean(Request("Price")))
SeatTypeCode = CInt(CleanNumeric(Request("SeatTypeCode")))
NewPrice = Price
DiscountAmount = 0
Surcharge = CDbl(Clean(Request("Surcharge")))
AppliedFlag = "N"
OrderNumber = CleanNumeric(Request("OrderNumber"))
EventCode = CleanNumeric(Request("EventCode"))
DiscountTypeNumber = CleanNumeric(Request("DiscountTypeNumber"))
SectionCode = Clean(Request("SectionCode"))
DiscountCode = UCase(Clean(Request("DiscountCode")))

'====================================================================

'Bay View Association (1930)   

'Parameters: Buy  6 tickets for $120.00

'Eligible Acts

'ActCode    Production Name
'---------------------------
'78805	    On The Rocks - Project Trio
'78806	    On The Rocks - Motown In Motion
'78807	    On The Rocks - The Wonderbread Years
'78808	    On The Rocks - The Good Lovelies
'78809	    On The Rocks - Chapter 6
'78810	    On The Rocks - Blind Pilot
'78811	    On The Rocks - Tribute to ABBA 


'Eligible Tickets

'SeatCode   TicketType
'----------------------
'1          Adult
'6755       BV Member Adult

'Discount should be allowed Online and Offline

'Service fees: no change

'Additional tickets should not be discounted. Must be 6 tickets.

'The discount should be automatic.

'====================================================================

SeriesPrice = 20

SeriesCount = 6

SeriesTicketList = "1,6755" 

ActCodeList = "78810, 78809, 78806, 78805, 78808, 78807, 78811"

ExpDate = "06/30/13"

'====================================================================

'Determine the number of tickets with matching ticket types.
SQLActCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price >= " & SeriesPrice  & " AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND Event.ActCode IN (" & ActCodeList & ")"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)	

	If Not rsActCount.EOF Then

		If rsActCount("TicketCount") >= SeriesCount Then 'Apply the discount to this order
		
			'Count # of existing seats which have discount applied.
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

			If Int(rsDiscCount("LineCount") / SeriesCount) < Int(rsActCount("TicketCount") / SeriesCount) Then 'Apply the discount to this item

                If Clean(Request("Price")) >  NewPrice Then
		
				    NewPrice = 20

				    DiscountAmount = Clean(Request("Price")) - NewPrice

				    AppliedFlag = "Y"

                End If

			End If

		End If

	End If
					
rsActCount.Close
Set rsActCount = nothing
        

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
        
%>