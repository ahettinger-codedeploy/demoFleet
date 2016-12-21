<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))

ApplyDiscountOK = True
EventCodes = "266996,264232,267000"
EventCodeList = Split(EventCodes,",")

For i = lbound(EventCodeList) to ubound(EventCodeList)
    SQLQuantity = "SELECT COUNT(LineNumber) AS TixCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCodeList(i)
    Set rsQuantity = OBJdbConnection.Execute(SQLQuantity)
    If rsQuantity("TixCount") = 0 Then
        ApplyDiscountOK = False    
    End If
    rsQuantity.Close
    Set rsQuantity = Nothing
Next

If ApplyDiscountOK Then
    'Get color of 264232
	SQLColor = "select color from section (NOLOCK) inner join seat (NOLOCK) on seat.eventcode = section.eventcode and seat.sectioncode = section.sectioncode where ordernumber = " & OrderNumber & " and section.eventcode = 264232"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	Color = UCase(rsColor("Color"))
	rsColor.Close
	Set rsColor = Nothing
	
	'Apply Discount where SeatTypeCode of 264232 = adults (1)
	SQLSeatTypeCd = "SELECT OrderLine.SeatTypeCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = 264232"
	Set rsSeatTypeCd = OBJdbConnection.Execute(SQLSeatTypeCd)
	SeatTypeCd = ""
	If Not rsSeatTypeCd.EOF Then
	    SeatTypeCd = rsSeatTypeCd("SeatTypeCode")
	End If
	rsSeatTypeCd.Close
	Set rsSeatTypeCd = Nothing
	
	If SeatTypeCd = "1" Then 'Adults
        Select Case Color
	        Case "DARKBLUE" 'Price Tier A
    	        NewPrice = Price - 4
    	        If Price > NewPrice Then
		            DiscountAmount = Price - NewPrice
		            AppliedFlag = "Y"
	            End If			
	        Case "DARKGOLD" 'Price Tier B
		        If EventCode = "264232" Then
		            NewPrice = Price - 4
		        Else
		            NewPrice = Price - 3
		        End If
    	        If Price > NewPrice Then
		            DiscountAmount = Price - NewPrice
		            AppliedFlag = "Y"
	            End If	    
            Case "DARKGREEN" 'Price Tier C
		        NewPrice = Price - 3
    	        If Price > NewPrice Then
		            DiscountAmount = Price - NewPrice
		            AppliedFlag = "Y"
	            End If	    
	    End Select
	End If
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>