<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'Aston Magna (2/12/2013)

'Daniel Arts Center Concert Series
'-----------------------------------

VenueCodeA = "9569"
VenueCodeB = "2470"

ActCodeList =  "88841,88842,88843,88844,88846"

RequiredSeatCode =  "1"

'==================================================

'Hello Support,

'We need a custom discount for Aston Magna (1063)
'Parameters
'Build Your Own:
'Purchase a  2-, 3-, or 4-concert subscription to Aston Magna Saturday evening concerts and receive $3/$4/$5 respectively off the individual ticket price. Senior ticket type excluded.
'Event Codes: 545727, 545729, 545732, 545734
'Purchase a 2-, 3-, 4 or 5-concert subscription to Aston Magna Thursday night concerts and receive$2/$3/$4/$5 respectively off the individual ticket price. Senior ticket type excluded.
'Event Codes: 545726, 545728, 545730, 545731, 545733  
'Eligible ActCodes / EventCodes
'See Above
'Offline/Online
'Online and Offline
'Service Fees
'Re-calculate service fees

'Additional Tickets


'Automatic/Code Entry
'Discount should be applied automatically
'Expiration
'No expiration
'Restrictions
'Senior ticket type excluded from discount

'Contact
'Susan Obel
'susanobel@gmail.com

'Client Description
'When you purchase a  2-, 3-, or 4-concert subscription to Aston Magna Saturday evening concerts at the Daniel Arts Center in Great Barrington during the 2013 Festival season, you will receive $3/$4/$5 respectively off the individual ticket price.  All seats are general admission.  The discount will be reflected at checkout. There is no additional discount off the Senior ticket price, which is the maximum discount available.
'When you purchase a 2-, 3-, 4 or 5-concert subscription to Aston Magna Thursday night concerts at the Slosberg Auditorium at Brandeis University during the 2013 Festival season, you will receive$2/$3/$4/$5 respectively off the individual ticket price.  All seats are general admission.   The discount will be reflected at checkout. There is no additional discount off the Senior ticket price, which is the maximum discount available.

'==================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'----------------------------------------------------	
'Slosberg Auditorium at Brandeis University 
'----------------------------------------------------	

	'Count the number of season acts with matching ticket types.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & "  AND OrderLine.SeatTypeCode = 1 AND Event.VenueCode = 9569  AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing

	ErrorLog("ActCount "&ActCount&"")
			
	If ActCount >= 2  Then
	
		'Get the least number of tickets for allowed ActCodes
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.VenueCode = 9569 AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
		NbrSubscriptions = rsMinTicketCount("NumSubs")		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
		
		ErrorLog("NbrSubscriptions "&NbrSubscriptions&"")
		
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
		ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing
		
		ErrorLog("ActCode "&ActCode&"")
		
		'Get Venue Code
		SQLVenue = "SELECT VenueCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsVenue = OBJdbConnection.Execute(SQLVenue)		
		VenueCode = rsVenue("VenueCode")		
		rsVenue.Close
		Set rsVenue = nothing
		
		ErrorLog("VenueCode "&VenueCode&"")
				
				'Determine number of existing seats which have discount applied for this act and seat type code
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
				Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
				AppliedCount = rsDiscCount("LineCount")		
				rsDiscCount.Close
				Set rsDiscCount = nothing
				
				If AppliedCount < NbrSubscriptions Then		
				
					Select Case VenueCode
					Case 9569
						Select Case SeatTypeCode
							Case 1
							Select Case ActCount
								Case 2
									DiscountAmount = 2
								Case 3
									DiscountAmount = 3
								Case 4
									DiscountAmount = 4
								Case 5
									DiscountAmount = 5
							End Select
						End Select
					End Select
					
					NewPrice = Clean(Request("Price")) - DiscountAmount	            	            

					If Price > NewPrice Then
						DiscountAmount = Clean(Request("Price")) - NewPrice
						AppliedFlag = "Y"
					End If	
				
					If Request("NewSurcharge") <> "" Then
						Surcharge = NewSurcharge
					Else
						If Request("CalcServiceFee") <> "N" Then
						Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
						End If
					End If
					
					
				End If
				

		
	End If	
	
'----------------------------------------------------	
	'Count the number of season acts with matching ticket types.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & "  AND OrderLine.SeatTypeCode = 1 AND Event.VenueCode = 2470  AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing

	ErrorLog("ActCount "&ActCount&"")
			
	If ActCount >= 2  Then
	
		'Get the least number of tickets for allowed ActCodes
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.VenueCode = 2470 AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
		NbrSubscriptions = rsMinTicketCount("NumSubs")		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
		
		ErrorLog("NbrSubscriptions "&NbrSubscriptions&"")
		
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
		ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing
		
		ErrorLog("ActCode "&ActCode&"")
		
		'Get Venue Code
		SQLVenue = "SELECT VenueCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsVenue = OBJdbConnection.Execute(SQLVenue)		
		VenueCode = rsVenue("VenueCode")		
		rsVenue.Close
		Set rsVenue = nothing
		
		ErrorLog("VenueCode "&VenueCode&"")
				
				'Determine number of existing seats which have discount applied for this act and seat type code
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
				Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
				AppliedCount = rsDiscCount("LineCount")		
				rsDiscCount.Close
				Set rsDiscCount = nothing
				
				If AppliedCount < NbrSubscriptions Then		
				
					Select Case VenueCode
					Case 2470
						Select Case SeatTypeCode
							Case 1
							Select Case ActCount
								Case 2
									DiscountAmount = 3
								Case 3
									DiscountAmount = 4
								Case 4
									DiscountAmount = 5
							End Select
						End Select
					End Select
					
					NewPrice = Clean(Request("Price")) - DiscountAmount	            	            

					If Price > NewPrice Then
						DiscountAmount = Clean(Request("Price")) - NewPrice
						AppliedFlag = "Y"
					End If	
				
					If Request("NewSurcharge") <> "" Then
						Surcharge = NewSurcharge
					Else
						If Request("CalcServiceFee") <> "N" Then
						Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
						End If
					End If
					
					
				End If
				

		
	End If	
	'---------------------------------------------

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>