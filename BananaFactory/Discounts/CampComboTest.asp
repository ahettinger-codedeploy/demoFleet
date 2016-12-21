<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<HTML>
<HEAD>
<TITLE>Camp Combo Test</TITLE>
</HEAD>
<BODY>
<%

Dim EAMEventCode
Dim EPMEventCode

EAMEventCode = Array(89913, 89918, 89924, 89927, 89937, 89940, 89945, 89949, 89953, 89968, 89972, 89977)
EPMEventCode = Array(89915, 89919, 89925, 89928, 89938, 89942, 89947, 89950, 89954, 89970, 89974, 89978)

Response.Write "<TABLE>"
Response.Write "<TR><TD>EAM EventCode</TD><TD>EPM EventCode</TD><TD>EAM Count</TD><TD>EPM Count</TD><TD>Min Count</TD><TD>Order Number</TD></TR>" & vbCrLf

For ComboNum = 0 To 11

	'Count # of Acts on the order.
	SQLActCount = "SELECT EAM.OrderNumber, EAMSeatCount, EPMSeatCount FROM (SELECT Event.EventCode, OrderLine.OrderNumber, COUNT(Seat.ItemNumber) AS EAMSeatCount FROM Event INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON OrderLine.ItemNumber = Seat.ItemNumber WHERE Event.EventCode = " & EAMEventCode(ComboNum) & " GROUP BY Event.EventCode, OrderLine.OrderNumber) AS EAM INNER JOIN (SELECT  Event.EventCode, OrderLine.OrderNumber, COUNT(Seat.ItemNumber) AS EPMSeatCount FROM Event  INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON OrderLine.ItemNumber = SEat.ItemNumber WHERE Event.EventCode = " & EPMEventCode(ComboNum) & " GROUP BY Event.EventCode, OrderLine.OrderNumber) AS EPM ON EAM.OrderNumber = EPM.OrderNumber"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	
	If Not rsActCount.EOF Then
	
		EAMCount = rsActCount("EAMSeatCount")
		EPMCount = rsActCount("EPMSeatCount")
		MinCount = Min(Array(EAMCount, EPMCount))
		OrderNumber = rsActCount("OrderNumber")
	
	Else
		
		EAMCount = 0
		EPMCount = 0
		MinCount = 0
		OrderNumber = ""
	
	End If
	
	rsActCount.Close
	Set rsActCount = nothing
	
	Response.Write "<TR><TD>" & EAMEventCode(ComboNum) & "</TD>"
	Response.Write "<TD>" & EPMEventCode(ComboNum) & "</TD>"
	Response.Write "<TD>" & EAMCount & "</TD>"
	Response.Write "<TD>" & EPMCount & "</TD>"
	Response.Write "<TD>" & MinCount & "</TD>" & vbCrLf
	Response.Write "<TD>" & OrderNumber & "</TD></TR>" & vbCrLf

Next	

Response.Write "</TABLE>" & vbCrLf
%>

</BODY>
</HTML>
  