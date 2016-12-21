<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Season Subscription Discount
'Daniel Arts Center - if 2 productions are purchased then tickets are $32.50 each
'Daniel Arts Center - if 4 productions are purchased then tickets are $30.00 each
'Sterling Art Institute - if 3 productions are purchased then tickets are $30.00 each 
'Senior tickets are not discounted

'Set Discount Variables
SeriesCount = 2 'Minimum number of productions at Daniel Arts Center
ActCodeList = "33449,33456,33457,33458" 'ActCodes of productions at Daniel Arts Center

ActCodeList2 = "39234,39235,39236" 'ActCodes of productions at Sterling Art Institute
SeriesCount2 = 3 ''Minimum number of productions at Sterling Art Institute

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'----------------------------------------------------	
'Check for subscription at Sterling Art Institute
'----------------------------------------------------	

	'Count # of Acts on the order.
	SQLActCount2 = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList2 & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount2 = OBJdbConnection.Execute(SQLActCount2)	
	ActCount2 = rsActCount2("ActCount")	
	rsActCount2.Close
	Set rsActCount2 = nothing

			
			
								If ActCount2 >= SeriesCount Then
			

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
									
											If ActCode = 39234 or ActCode = 39235 or ActCode = 39236 Then

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
																				Case 16 'Adult
																					NewPrice = 30
																				Case 3 'Senior
																					NewPrice = Price
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
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
ActCount = rsActCount("ActCount")	
rsActCount.Close
Set rsActCount = nothing
								
								
								If ActCount >= SeriesCount Then
								
											If ActCount >= 4 Then
											SeriesPrice = 30
											ElseIf ActCount >=2 Then
											SeriesPrice = 32.50
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
									
											If ActCode = 33449 Or ActCode = 33456 Or ActCode = 33457 Or ActCode = 33458 Then

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
																				Case 16 'Adult
																					NewPrice = SeriesPrice
																				Case 3 'Senior
																					NewPrice = Price
																		  End Select
																		  
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