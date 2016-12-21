<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Aston Magna (3/24/2014)

'Build Your Own Subscription Discount by Venue Code and Act Code


'Slosberg Auditorium Concert Series
'-----------------------------------
' For 3-, 4 or 5-concert subscription(s) receive $3/$4/$5 respectively off the individual ticket price. 


'Daniel Arts Center Concert Series
'-----------------------------------
' For 3- or 4-concert subscription(s) receive $4/$5 respectively off the individual ticket price. 


' Olin Hall Concert Series
'-----------------------------------
' A 5-concert subscription is $130.00 ($26/ticket) (25%+ savings). 
' A 3- or 4-concert subscription(s) at $28/ticket (20% savings).  


' Valid Act Codes
'102438 C. P. E Bach 300th Birthday Celebration, and J. S. Bach’s Musical Offering 
'102456 Italian Trio sonatas, and a new work - “Aston Magna” - by Nico Muhly 
'102445 Music from a Turbulent 17th Century England 
'102449 Vice Squad: Baroque Skirmishes with Alcohol, Tobacco, Coffee, and Love
'102437 Winds of Romanticism 


' Valid Venue Codes
VenueCodeA = "9569"  'Slosberg Auditorium
VenueCodeB = "2470"  'Daniel Arts Center
VenueCodeC = "14591" 'Olin Hall

' Act Code List
ActCodeList =  "102438,102456,102445,102449,102437"

RequiredSeatCode =  "1"

'==================================================


	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
	
		'----------------------------------------------------	
		'Olin Hall Concert Series
		'----------------------------------------------------	

		'Count the number of season acts with matching ticket types.
		SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & "  AND OrderLine.SeatTypeCode = " & RequiredSeatCode & " AND Event.VenueCode = " & VenueCodeC & "  AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
		rsActCount.Close
		Set rsActCount = nothing

		'ErrorLog("Olin-ActCount "&ActCount&"")
				
		If ActCount >= 3  Then
		
			'Get the least number of tickets for allowed ActCodes
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.VenueCode = " & VenueCodeC & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			NbrSubscriptions = rsMinTicketCount("NumSubs")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing
			
			'ErrorLog("Olin-NbrSubscriptions "&NbrSubscriptions&"")
			
			'Get Act Code
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)		
			ActCode = rsAct("ActCode")		
			rsAct.Close
			Set rsAct = nothing
			
			'ErrorLog("Olin-ActCode "&ActCode&"")
			
			'Get Venue Code
			SQLVenue = "SELECT VenueCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsVenue = OBJdbConnection.Execute(SQLVenue)		
			VenueCode = rsVenue("VenueCode")		
			rsVenue.Close
			Set rsVenue = nothing
			
				'ErrorLog("Olin-VenueCode "&VenueCode&"")
					
				'Determine number of existing seats which have discount applied for this act and seat type code
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode = " & ActCode & " AND Event.VenueCode = " & VenueCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
				Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
				AppliedCount = rsDiscCount("LineCount")		
				rsDiscCount.Close
				Set rsDiscCount = nothing
				
				If AppliedCount < NbrSubscriptions Then		
				
					Select Case VenueCode
						Case 14591
							Select Case SeatTypeCode
								Case 1
									Select Case ActCount
										Case 3
											NewPrice = 26
										Case 4
											NewPrice = 28
										Case 5
											NewPrice = 28
									End Select
							End Select
					End Select
					
					DiscountAmount	= NewPrice - Clean(Request("Price"))	            	            

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
		'Slosberg Auditorium Concert Series
		'----------------------------------------------------	
		
		'Count the number of season acts with matching ticket types.
		SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & "  AND OrderLine.SeatTypeCode = " & RequiredSeatCode & " AND Event.VenueCode = " & VenueCodeA & "  AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
		rsActCount.Close
		Set rsActCount = nothing

		'ErrorLog("Slosberg-ActCount "&ActCount&"")
				
		If ActCount >= 3  Then
		
			'Get the least number of tickets for allowed ActCodes
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.VenueCode = " & VenueCodeA & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			NbrSubscriptions = rsMinTicketCount("NumSubs")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing
			
			'ErrorLog("Slosberg-NbrSubscriptions "&NbrSubscriptions&"")
			
			'Get Act Code
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)		
			ActCode = rsAct("ActCode")		
			rsAct.Close
			Set rsAct = nothing
			
			'ErrorLog("Slosberg-ActCode "&ActCode&"")
			
			'Get Venue Code
			SQLVenue = "SELECT VenueCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsVenue = OBJdbConnection.Execute(SQLVenue)		
			VenueCode = rsVenue("VenueCode")		
			rsVenue.Close
			Set rsVenue = nothing
			
				'ErrorLog("Slosberg-VenueCode "&VenueCode&"")
					
				'Determine number of existing seats which have discount applied for this act and seat type code
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode = " & ActCode & " AND Event.VenueCode = " & VenueCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
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
		'Daniel Arts Center Concert Series
		'----------------------------------------------------	
	
		'Count the number of season acts with matching ticket types.
		SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & "  AND OrderLine.SeatTypeCode = " & RequiredSeatCode & " AND Event.VenueCode = " & VenueCodeB & "  AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
		rsActCount.Close
		Set rsActCount = nothing

		'ErrorLog("Daniel-ActCount "&ActCount&"")
				
		If ActCount >= 3  Then
		
			'Get the least number of tickets for allowed ActCodes
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.VenueCode = " & VenueCodeB & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			NbrSubscriptions = rsMinTicketCount("NumSubs")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing
			
			'ErrorLog("Daniel-NbrSubscriptions "&NbrSubscriptions&"")
			
			'Get Act Code
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)		
			ActCode = rsAct("ActCode")		
			rsAct.Close
			Set rsAct = nothing
			
			'ErrorLog("Daniel-ActCode "&ActCode&"")
			
			'Get Venue Code
			SQLVenue = "SELECT VenueCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsVenue = OBJdbConnection.Execute(SQLVenue)		
			VenueCode = rsVenue("VenueCode")		
			rsVenue.Close
			Set rsVenue = nothing
			
			'ErrorLog("Daniel-VenueCode "&VenueCode&"")
					
					'Determine number of existing seats which have discount applied for this act and seat type code
					SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode = " & ActCode & " AND Event.VenueCode = " & VenueCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
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