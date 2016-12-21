<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Atlas Performing Arts Center - Flex Series Subscription: Opera 2010 (3/1/2010)
'===============================================================================
'Must purchase 1 ticket to each of 9 productions to qualify for discount
'Each ticket is discounted by 20%
'Qualifying act codes are:
'46943   Opera in Cinema at the Atlas: Carmen 
'46980   Opera in Cinema at the Atlas: Don Carlo 
'46971   Opera in Cinema at the Atlas: Don Giovanni 
'46974   Opera in Cinema at the Atlas: Falstaff 
'46939   Opera in Cinema at the Atlas: La Traviata 
'46983   Opera in Cinema at the Atlas: Norma 
'46973   Opera in Cinema at the Atlas: Otello 
'46959   Opera in Cinema at the Atlas: Rigoletto 
'46948   Opera in Cinema at the Atlas: Roméo et Juliette

'Automatic discount
'No discount on additional tickets - discount only on complete subs
'No recalc fees


'Initialize Variables
SeatTypeCode = Clean(Request("SeatTypeCode"))
ActCode = Clean(Request("ActCode"))
Price = Clean(Request("Price"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
AppliedFlag = "N"

'Set Discount Variables
Percentage = 20 'For Percentage Discount.  10 is 10% off, 20 is 20% off, etc
SeriesCount = 9 'Number of Productions in the this Season Subscription
ActCodeList = "46943,46980,46971,46974,46939,46983,46973,46959,46948" 'ActCodes of Productions which can be included in Season Subscription.


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Get the color for this section (if needed for discount)
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)	
	Color = UCase(rsColor("Color"))	
	rsColor.Close
	Set rsColor = nothing
	
	'Determine the number of acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

					'Determine the number of possible subscriptions on this order
					SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
					Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
					NbrSubscriptions = rsMinTicketCount("NumSubs")		
					rsMinTicketCount.Close
					Set rsMinTicketCount = nothing
		
					'Get the ActCode
					SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
					Set rsAct = OBJdbConnection.Execute(SQLAct)		
					ActCode = rsAct("ActCode")		
					rsAct.Close
					Set rsAct = nothing

					'Count the number of seats which have been discounted
					SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
					Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
					AppliedCount = rsDiscCount("LineCount")		
					rsDiscCount.Close
					Set rsDiscCount = nothing

					'If the number of discounted seats at this price for these events is less then the total possible, apply discount
		
					If AppliedCount < NbrSubscriptions Then								
								

				    NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)	
										
					      
					End If												

					DiscountAmount = Clean(Request("Price")) - NewPrice

					If NewPrice < 0 Then
						NewPrice = 0
					End If

					AppliedFlag = "Y"
				
					If Request("NewSurcharge") <> "" Then
						Surcharge = NewSurcharge
					Else
						If Request("CalcServiceFee") <> "N" Then
							Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
						End If
					End If
	
	End If	
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>