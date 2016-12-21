<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'Aston Magna (1/21/2011)

'Daniel Arts Center Concert Series
'-----------------------------------

VenueCodeA = "11345,2470"
VenueCodeB = "9569"

ActCodeList =  "73075,73080,73342,73341,73074"
ActCodeList2 =  "73339,73076,73078"

RequiredSeatCode =  "564"

SeriesCount = 2

'==================================================

'ActCode    Act
'73075 	    40th Anniversary Gala (at Ozawa Hall)
'73339 	    40th Anniversary Gala (at Slosberg Auditorium)
'73080 	    Baroque a l’Italienne
'73342 	    Gran Partita
'73078 	    Gran Partita (at Slosberg Auditorium)
'73341 	    Music of three Bachs and Villa Lobos
'73076 	    Music of three Bachs and Villa Lobos (at Slosberg Auditorium)
'73074 	    Violin Extravaganza


'SeatCode    SeatType
'564         General Admission

'==================================================


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'----------------------------------------------------	
'Check for subscription at Sterling Art Institute
'----------------------------------------------------	

	'Count # of Acts on the order.
        SQLActCount2 = "SELECT COUNT(ActCode) AS ActCount2 FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND Event.ActCode IN (" & ActCodeList2 & ") GROUP BY Event.ActCode) AS ActCount2"
        Set rsActCount2 = OBJdbConnection.Execute(SQLActCount2)	
        ActCount2 = rsActCount2("ActCount2")	
        rsActCount2.Close
        Set rsActCount2 = nothing			
			
	If ActCount2 >= SeriesCount Then
	
				If ActCount2 = 3 Then
				SeriesDiscount = 5
				Else
				SeriesDiscount = 2.5
				End If


				'Get the least number of tickets for any applicable ActCode
				SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList2 & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
				Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
				NbrSubscriptions = rsMinTicketCount("NumSubs")		
				rsMinTicketCount.Close
				Set rsMinTicketCount = nothing
		
				'Get Act Code
				SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
				Set rsAct = OBJdbConnection.Execute(SQLAct)		
				ActCode = rsAct("ActCode")		
				rsAct.Close
				Set rsAct = nothing
		
				If ActCode = 73339 or ActCode = 73076 or ActCode = 73078 Then
			

						'Count # of existing seats which have discount applied for this act and seat type code
						SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
						Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
						AppliedCount = rsDiscCount("LineCount")		
						rsDiscCount.Close
						Set rsDiscCount = nothing

								'If the # of discounts at this price for these events < the total possible, discount price
								If AppliedCount < NbrSubscriptions Then		    
												
											'Fixed Amount Discount by Seat Type
												Select Case SeatTypeCode
													Case 564 'General Admission
                                                        NewPrice = Clean(Request("Price")) - SeriesDiscount		            	            
											    End Select
											  
											    If Price > NewPrice Then
											        DiscountAmount = Clean(Request("Price")) - NewPrice
											        AppliedFlag = "Y"
											    End If	
									        
								End If	
		
				End If

	End If	
			
'----------------------------------------------------	
'Check for subscription at  Daniel Arts Center
'----------------------------------------------------	
		
'Count # of Acts on the order.
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
ActCount = rsActCount("ActCount")	
rsActCount.Close
Set rsActCount = nothing
								
								
If ActCount >= SeriesCount Then

			If ActCount = 5 Then
			SeriesDiscount = 5
			ElseIf ActCount >=2 Then
			SeriesDiscount = 2.50
			End If

			'Get the least number of tickets for any applicable ActCode
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			NbrSubscriptions = rsMinTicketCount("NumSubs")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing
	
			'Get Act Code
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)		
			ActCode = rsAct("ActCode")		
			rsAct.Close
			Set rsAct = nothing
	
			If ActCode = 73075 Or ActCode = 73080 Or ActCode = 73342 Or ActCode = 73341 Or ActCode = 73074 Then

					'Count # of existing seats which have discount applied for this act and seat type code
					SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
					Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
					AppliedCount = rsDiscCount("LineCount")		
					rsDiscCount.Close
					Set rsDiscCount = nothing

							'If the # of discounts at this price for these events < the total possible, discount price
							If AppliedCount < NbrSubscriptions Then		    
											
										'Fixed Amount Discount by Seat Type
											Select Case SeatTypeCode
												Case 564 'General Admission
                                                    NewPrice = Clean(Request("Price")) - SeriesDiscount		            	            
										    End Select
										  
										    If Price > NewPrice Then
										        DiscountAmount = Clean(Request("Price")) - NewPrice
										        AppliedFlag = "Y"
										    End If	
										  
										If Price > NewPrice Then
										DiscountAmount = Clean(Request("Price")) - NewPrice
										AppliedFlag = "Y"
										End If	
								        
							End If	
	
			End If

End If	
'----------------------------------			
			
				
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>