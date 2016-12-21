<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================



'Online and offline
'Do not re-calc the fees


PackageCount = 5
EventCodeList = "369643,369636,369644,369639,369642,369647,369648"
Percentage = 15 

'==================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

    'Determine the color for this section (needed for this discount to work)
    SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
    Set rsColor = OBJdbConnection.Execute(SQLColor)	
    Color = UCase(rsColor("Color"))	
    rsColor.Close
    Set rsColor = nothing

	'Determine the number of events on this order.
	SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND Color = '" & Color & "' AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
	EventCount = rsEventCount("EventCount")	
	rsEventCount.Close
	Set rsEventCount = nothing
	
	If EventCount => PackageCount Then



			'Get the EventCode
			SQLEvent = "SELECT EventCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)		
			EventCode = rsEvent("EventCode")		
			rsEvent.Close
			Set rsEvent = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < Nbrpackages Then	
    
                        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
                        
	                    If Price > NewPrice Then
    	                    
	                    DiscountAmount = Clean(Request("Price")) - NewPrice
    	                    
                        If Request("NewSurcharge") <> "" Then
	                        Surcharge = NewSurcharge
                        Else
	                        If Request("CalcServiceFee") <> "N" Then
		                        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	                        End If
                        End If	                    
    	                    
	                    AppliedFlag = "Y"	                    
                    
                    Else
                    
	                    NewPrice = Price
	                    
                    End If
			      
			End If	
	
	End If	
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>