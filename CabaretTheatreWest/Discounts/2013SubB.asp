<%

'CHANGE LOG - Inception
'SSR 1/21/2013 Custom Season Subscription Discount Created. 

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->


<%

'==================================================
'Cabaret Theatre West (1/21/2013) 

'Valid season subscriptions must have 1 ticket to each production
'Valid season subscriptions must have all tickets be of the same ticket type
'Valid season subscriptions must have all tickets in the same section color

'Automatic Discount
'Service Fees remain the same

'Valid Acts
'ON BROADWAY (79076)
'IT'S ALL ABOUT LOVE (79077)
'A GRAND NIGHT FOR SINGING (79078)

'Blue Section Price
'Individual $55.00 
'Series Price: $165.00

'Gold Section Price
'Individual $40.00 
'Series Price: $120.00

'==================================================

ActCodeList = "79076,79077,79078"

SeriesCount = 3

BlueDiscount = 10

GoldDiscount = 5

StartDate = "12/15/2012"

'==================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.


		SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
		OriginalDate = rsDateCheck("OrderDate")
		rsDateCheck.Close
		Set rsDateCheck = nothing
		
		'ErrorLog("OriginalDate " & OriginalDate &"")


		If CDate(OriginalDate) > CDate(StartDate) Then  

				'Get the color for this section (needed for this discount to work)
				SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
				Set rsColor = OBJdbConnection.Execute(SQLColor)	
				Color = UCase(rsColor("Color"))	
				rsColor.Close
				Set rsColor = nothing	
				
				'ErrorLog("Color " & Color &"")


				'Counts the number of tickets to each act with matching Seat Type Code and matching Color
				SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND Color = '" & Color & "' AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND Color IN ('ADADARKBLUE','DARKBLUE','ADADARKGOLD','DARKGOLD') GROUP BY Event.ActCode) AS ActCount"
				Set rsActCount = OBJdbConnection.Execute(SQLActCount)
				ActCount = rsActCount("ActCount")
				rsActCount.Close
				Set rsActCount = nothing
				
				ErrorLog("	ActCount " & 	ActCount  &"")
						
				If ActCount >= SeriesCount Then
				
				'ErrorLog("SeriesCount " & 	SeriesCount  &"")
						
						'Get the least number of tickets for any applicable ActCode
						SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
						Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)			
						NbrSubscriptions = rsMinTicketCount("NumSubs")			
						rsMinTicketCount.Close
						Set rsMinTicketCount = nothing	

						'ErrorLog("NbrSubscriptions " & 	NbrSubscriptions  &"")						
								
						'Get Act Code
						SQLAct = "SELECT ActCode FROM Event (NOLOCK) INNER JOIN SECTION (NOLOCK) On Event.EventCode = Section.EventCode WHERE Event.EventCode = " & EventCode & " AND Section.Color IN ('ADADARKBLUE','DARKBLUE','ADADARKGOLD','DARKGOLD') Group By Event.ActCode"
						Set rsAct = OBJdbConnection.Execute(SQLAct)			
						ActCode = rsAct("ActCode")			
						rsAct.Close
						Set rsAct = nothing
						
						'ErrorLog("ActCode " & 	ActCode &"")	

						'Count # of existing seats which have discount applied for this act and seat type code
						SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
						Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
						AppliedCount = rsDiscCount("LineCount")		
						rsDiscCount.Close
						Set rsDiscCount = nothing	

						'ErrorLog("AppliedCount " & 	AppliedCount &"")							
								
						'If the # of discounts at this price for these events < the total possible, discount price
						
						If AppliedCount < NbrSubscriptions Then	

							'Count number of tickets which have been given a discount
							SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')" 
							Set rsCount = OBJdbConnection.Execute(SQLCount)
							Count = rsCount("AppliedCount")
							rsCount.Close
							Set rsCount = nothing
							
							Select Case Color
								Case "ADADARKBLUE" 'Orchestra & Mezzanine 
									DiscountAmount = BlueDiscount
								Case "DARKBLUE" 'Orchestra & Mezzanine 
									DiscountAmount = BlueDiscount
								Case "ADADARKGOLD" 'Main Floor 
									DiscountAmount = GoldDiscount  
								Case "DARKGOLD" 'Main Floor 
									DiscountAmount = GoldDiscount    				
							End Select			
							
							NewPrice = Clean(Request("Price")) - DiscountAmount
											
							If Request("NewSurcharge") <> "" Then
								Surcharge = NewSurcharge	
							ElseIf Request("CalcServiceFee") <> "N" Then
								Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
							End If
							
							AppliedFlag = "Y"
							
						End If
							
				End If
																	
		End If


End If
		
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>