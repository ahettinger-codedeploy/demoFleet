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

'Organization			BAY POINTE BALLET

'Discount Type:       	Custom Flex Subscription Discount
	
'Description:         	2016 Season Subscription
	
'Discount Code:       	2015-2016sub
	
'Code Entry:          	Automatic
	
'Available Internet:  	YES
	
'Available Box Office:	YES
	
'Valid Ticket Types:  	SEAT CODE       SEAT NAME
'						-----           ------
'						51746           Adult   
'						51747           Child 12 & under 
'						51763           Senior 62 & over        
'						67107           Youth 13 - 18 
	
'Valid Productions:   	ACT CODE        ACT NAME
'						-----           ------
'						117152          Dracula
'						117470          In The Mood
'						117026           Nutcracker
	
	
'Pricing:				SECTION	ADULT   SENIOR  YOUTH   CHILD
'-------				--------------------------------------
'						Blue	$126.00	$115.50 $115.50 $105.00 
'						Gold 	$94.50 	$84.00  $84.00  $73.50 
'						Green	$64.00 	$52.50  $52.50  $42.00 


'Add Tickets:
'						Additional tickets are discounted at 30% off per ticket.

	
	
'Restrictions: 			Subscriptions can be any combination of ticket types (needed to allow for add ticket disc)
'						Tickets do not need to be in the same price tier (needed to allow for add ticket disc)
'      	 				Not valid for the following performances
	
'						EVENT CODE      EVENT NAME      EVENT VENUE
'						------------------------------------------
'						772735          Dracula         Victoria Theatre 
'						772736          Dracula         Victoria Theatre 
'						772737          Dracula         Victoria Theatre 
'						772738          Dracula         Victoria Theatre 
	
'Start Date/Time:     	Now

'End Date/Time			Now
	
'Service Fee:         	No Service Fee Change

'=========================================================

SeriesCount = 3

ActCodeList = "117152,117470,117026"

SeatTypeA = "51746" 'Adult
SeatTypeB = "51763" 'Senior
SeatTypeC = "67107" 'Youth
SeatTypeD = "51747" 'Child

Tier1_Color = "DARKBLUE"
Tier2_Color = "DARKGOLD"
Tier3_Color = "DARKGREEN"

Tier1_PriceA = "126.00"
Tier2_PriceA = "94.50"
Tier3_PriceA = "64.00"

Tier1_PriceB = "115.50"
Tier2_PriceB = "84.00"
Tier3_PriceB = "52.50"

Tier1_PriceC = "115.50"
Tier2_PriceC = "84.00"
Tier3_PriceC = "52.50"

Tier1_PriceD = "105.00"
Tier2_PriceD = "73.50"
Tier3_PriceD = "42.00"

Percentage = 30

'----------------------------------------------------------

	'Get the color for this section (needed for this discount to work)
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)	
	Color = UCase(rsColor("Color"))	
	rsColor.Close
	Set rsColor = nothing

	'Counts the number of tickets to each act with matching Seat Type Code and matching Color
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND Color IN ('DARKBLUE','DARKGOLD','DARKGREEN') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing
	
	ErrorLog("ActCount: " & ActCount & "")
			
	If ActCount >= SeriesCount Then
	
			'Tier 1 Series 
			'------------------
			Select Case Color
			Case Tier1_Color
				Select Case SeatTypeCode
				Case SeatTypeA
					SeriesPrice = Tier1_PriceA
				Case SeatTypeB
					SeriesPrice = Tier1_PriceB
				Case SeatTypeC
					SeriesPrice = Tier1_PriceC
				Case SeatTypeD
					SeriesPrice = Tier1_PriceD
				End Select
			End Select 

			
			'Tier 2 Series 
			'------------------
			Select Case Color
			Case Tier2_Color
				Select Case SeatTypeCode
				Case SeatTypeA
					SeriesPrice = Tier2_PriceA
				Case SeatTypeB
					SeriesPrice = Tier2_PriceB
				Case SeatTypeC
					SeriesPrice = Tier2_PriceC
				Case SeatTypeD
					SeriesPrice = Tier2_PriceD
				End Select
			End Select 
			
			'Tier 3 Series 
			'------------------
			Select Case Color
			Case Tier3_Color
				Select Case SeatTypeCode
				Case SeatTypeA
					SeriesPrice = Tier3_PriceA
				Case SeatTypeB
					SeriesPrice = Tier3_PriceB
				Case SeatTypeC
					SeriesPrice = Tier3_PriceC
				Case SeatTypeD
					SeriesPrice = Tier3_PriceD
				End Select
			End Select 
			
		'Get the least number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
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
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing			
		
			If AppliedCount < NbrSubscriptions Then	

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
					
					AppliedFlag = "Y"
					
			Else
			
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
				
				AppliedFlag = "Y"
			
			End If
			
			If AppliedFlag = "Y" Then
					
				DiscountAmount =  Clean(Request("Price")) - NewPrice
							
				If Request("NewSurcharge") <> "" Then
					Surcharge = NewSurcharge	
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
				End If
						
			End If
																
	End If
		
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>