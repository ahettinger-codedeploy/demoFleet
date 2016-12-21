<%

'CHANGE LOG - Inception
'SSR 8/25/2011
'Custom Season Discount

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->
<%

'================================================================

'Canton Symphony 

'2013 Season Subscription
'3 Tier Section Color Discount by Series Price


'Valid Acts
'------------------------------------------
'92747 	 13-14 Pops - PROJECT Trio
'92748 	 13-14 Pops - A Very Canton Christmas
'92749 	 13-14 Pops - Matt Corey with special guest Elec Simon



'Tier 1 Series 
'------------------
'1GOLD SECTION - $75


'Tier 2 Series 
'------------------
'2SILVER SECTION - $65


'Tier 3 Series 
'-------------------
'BRONZE SECTION - $50


'Valid subscriptions must have 1 ticket to all 3 productions
'Valid subscriptions must be of the same ticket type
'Valid subscriptions must be within the same price tier
'Only complete subscriptions are discounted.
'Do not re-calc Tix fees

'Contact
'Irene Barker
'IBarker@cantonsymphony.org

'Thanks!


'================================================================

SeriesCount = 3

ActCodeList = "92747,92748,92749"

SeatTypeA = "1" 

Tier1_Color = "1GOLD"
Tier1_Price = "75"

Tier2_Color = "2SILVER"
Tier2_Price = "65"

Tier3_Color = "BRONZE"
Tier3_Price = "50"


'================================================================

'Get the color for this section (needed for this discount to work)
SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
Set rsColor = OBJdbConnection.Execute(SQLColor)	
Color = UCase(rsColor("Color"))	
rsColor.Close
Set rsColor = nothing

'ErrorLog("Color "&Color&" ")

'Counts the number of tickets to each act with matching Seat Type Code and matching Color
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND Color = '" & Color & "' AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND Color IN ('"&Tier1_Color&"', '"&Tier2_Color&"', '"&Tier3_Color&"') GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
ActCount = rsActCount("ActCount")
rsActCount.Close
Set rsActCount = nothing


'ErrorLog("ActCount "&ActCount&" ")
		
	If ActCount >= SeriesCount Then
			
		'Get the least number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)			
		NbrSubscriptions = rsMinTicketCount("NumSubs")			
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing	
				
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
		ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing 
			
		'Count # of existing seats which have discount applied for this act and seat type code
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing			
		
		If AppliedCount < NbrSubscriptions Then	
		
			'Tier 1 Series 
			'------------------
			Select Case Color
			
				Case Tier1_Color
					SeriesPrice = Tier1_Price
			
				Case Tier2_Color
					SeriesPrice = Tier2_Price
			
				Case Tier3_Color
					SeriesPrice = Tier3_Price
					
			End Select 

			'Count number of tickets which have been given a discount
			SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')" 
			Set rsCount = OBJdbConnection.Execute(SQLCount)
			Count = rsCount("AppliedCount")
			rsCount.Close
			Set rsCount = nothing
			
			Remainder = Count MOD SeriesCount				        

				If Remainder = SeriesCount - 1 Then 
					NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
				Else
					NewPrice = Round(SeriesPrice/SeriesCount, 2)
				End If
				
				If Price > NewPrice Then
				
					AppliedFlag = "Y"
						
					DiscountAmount =  Clean(Request("Price")) - NewPrice
								
					If Request("NewSurcharge") <> "" Then
						Surcharge = NewSurcharge	
					ElseIf Request("CalcServiceFee") <> "N" Then
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