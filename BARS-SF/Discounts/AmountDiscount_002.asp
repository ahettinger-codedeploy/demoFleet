<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Bay Area Symphony Orchestra (3/10/2010)
'========================================
'Subscriber discount code
'Each code is valid for:
'$20.00 off each ticket
'Maximum of 10 discounted tickets
'Discount code can only be used once.

'Initialize Variables
Surcharge = Clean(Request("Surcharge"))
NewSurcharge = Clean(Request("Surcharge"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
EventCode = Clean(Request("EventCode"))
OrderNumber = Clean(Request("OrderNumber"))
Price = Clean(Request("Price"))
NewPrice = Clean(Request("Price"))

SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"

'Initialize Discount Parameters
ActCodeList = "47645,47646"
QtyToDisc = 10 
SeatTypeList = "2117,2040"

DiscountAmount = 20

'Determine number of tickets already discounted on these productions with this discount type number
SQLPastCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber NOT IN (" & OrderNumber & ") AND ActCode IN (" & ActCodeList & ") AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
Set rsPastCount = OBJdbConnection.Execute(SQLPastCount)
TicketCount = rsPastCount("LineCount")
rsPastCount.Close
Set rsPastCount = nothing

If TicketCount = 0 Then

			'Determine number of tickets on this order which have been given a discounted price
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode IN(" & SeatTypeList & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " "
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
										
		        'Give discounts to remaining tickets							
		        If rsDiscCount("LineCount") < QtyToDisc Then 			    
	    		    Select Case SeatTypeCode  
	    		    Case 2117
		                NewPrice = Clean(Request("Price")) - DiscountAmount              	
	                Case 2040
		                NewPrice = Clean(Request("Price")) - DiscountAmount
		            End Select
			    Else
				    NewPrice = Clean(Request("Price"))
			    End If
						
			rsDiscCount.Close
			Set rsDiscCount = nothing
			
	            If Price > NewPrice Then
		            DiscountAmount = Clean(Request("Price")) - NewPrice
		            AppliedFlag = "Y"
	            End If
					
		        If Request("NewSurcharge") <> "" Then
			        Surcharge = NewSurcharge
		        End If
			
End If   
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>