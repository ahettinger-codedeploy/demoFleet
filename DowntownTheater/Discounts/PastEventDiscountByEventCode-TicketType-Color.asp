<%


'CHANGE LOG

'SSR - 08/24/15 - Created custom discount script
'SSR - 08/26/15 - Updated the ticket count query.


'============================================================

'San Deigo Junior Theater
'2015 Season Subscription 
'Past Event Discount


'If patron buys 1 ticket to a subscription event, they are entitled 
'to specific number of free tickets at 100% off

'EVENT CODE		EVENT NAME
'-----------------------------------
'782460			Pick 3 Subscription
'782461			Pick 4 Subscription
'782463			Pick 5 Subscription

'SEAT		ACT		TICKET		PRICE
'CODE		COUNT	TYPE		TIER
'-----------------------------------
'65849		3 		Adult 		Blue	
'67480		3 		Adult 		Gold	
'65850		3 		Child 		Blue	
'67482		3 		Child 		Gold	
'67483		3 		Senior 		Blue	
'67481		3 		Senior 		Gold

'67484		4 		Adult 		Blue	
'65851		4 		Adult 		Gold	
'67485		4 		Child 		Blue	
'65852		4 		Child 		Gold	
'67486		4 		Senior 		Blue	
'67487		4 		Senior 		Gold
					
'67492		5 		Adult 		Blue	
'67488		5 		Adult 		Gold	
'67493		5 		Child 		Blue	
'67489		5 		Child 		Gold	
'67494		5 		Senior 		Blue	
'67491		5 		Senior 		Gold


'SEAT		TICKET
'CODE		TYPE
'-----------------------------------
'1			Adult
'23			Senior (60 and over)
'1314		Youth (2-14)

'Offline/Online
'-----------------------------------
'Discount available for both online and offline orders


'Service Fees
'-----------------------------------
'New Per Ticket Surcharge: $0.00 per ticket
'New Per Order Delivery Surcharge: $0.00 per order


'Automatic/Code Entry
'-----------------------------------
'Automatic Discount: code entry not required


'Discount Code
'-----------------------------------
'2015sub


'Expiration
'-----------------------------------
'No expiration


'Discount Limits
'-----------------------------------
'Unlimited discounts



%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


DIM CustomerNumber
CustomerNumber = fnCustomerNumber

If CustomerNumber = 1 OR CustomerNumber = "" Then
	AllowDiscount = "N"
End If

DIM SubscriptionEventList
SubscriptionEventList = "782460,782461,782463"

DIM SeriesPercentage
SeriesPercentage = 100

DIM AdultBlue
AdultBlue = 0

DIM ChildBlue
ChildBlue = 0

DIM SeniorBlue
SeniorBlue = 0

DIM AdultGold
AdultBlue = 0

DIM ChildGold
ChildBlue = 0

DIM SeniorGold
SeniorBlue = 0

DIM NewPrice
NewPrice = 0

DIM NewShipFee
NewShipFee = 0

DIM Color

DIM Tier1_Color
Tier1_Color = "BLUE"

DIM Tier2_Color
Tier2_Color = "GOLD"

DIM AllowedCount
DIM SeriesCount
DIM AppliedSeriesCount
DIM AppliedActCount

AllowedCount = 0
SeriesCount = 0
AppliedSeriesCount = 0
AppliedActCount = 0

'-----------------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
		'Determine the number of subscriptions
		SQLMemberCurrent = "SELECT OrderLine.SeatTypeCode FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & SubscriptionEventList & ")  AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & SubscriptionEventList & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
		Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
		
			If Not rsMemberCurrent.EOF Then
				Do While Not rsMemberCurrent.EOF
				
					Select Case rsMemberCurrent("SeatTypeCode")

						'Pick 3 Acts Season Subscription
						Case 65849
								AdultBlue		= AdultBlue			+ 1
								AdultBlueSeries = AdultBlueSeries 	+ 3
						Case 67480		
								AdultGold		= AdultGold			+ 1	
								AdultGoldSeries = AdultGoldSeries 	+ 3
						Case 65850
								ChildBlue		= ChildBlue			+ 1
								ChildBlueSeries = ChildBlueSeries 	+ 3
						Case 67482		
								ChildGold		= ChildGold			+ 1
								ChildGoldSeries = ChildGoldSeries 	+ 3
						Case 67483
								SeniorBlue		= SeniorBlue		+ 1
								SeniorBlueSeries = SeniorBlueSeries + 3
						Case 67481		
								SeniorGold		 = SeniorGold		+ 1
								SeniorGoldSeries = SeniorGoldSeries + 3
								
						'Pick 4 Acts Season Subscription	
						Case 67484
								AdultBlue		= AdultBlue			+ 1
								AdultBlueSeries = AdultBlueSeries 	+ 4
						Case 65851		
								AdultGold		= AdultGold			+ 1	
								AdultGoldSeries = AdultGoldSeries 	+ 4
						Case 67485
								ChildBlue		= ChildBlue			+ 1
								ChildBlueSeries = ChildBlueSeries 	+ 4
						Case 65852		
								ChildGold		= ChildGold			+ 1
								ChildGoldSeries = ChildGoldSeries 	+ 4
						Case 67486
								SeniorBlue		= SeniorBlue		+ 1
								SeniorBlueSeries = SeniorBlueSeries + 4
						Case 67487		
								SeniorGold		= SeniorGold		+ 1
								SeniorGoldSeries = SeniorGoldSeries + 4
						
						'Pick 5 Acts Season Subscription						
						Case 67492
								AdultBlue		= AdultBlue			+ 1
								AdultBlueSeries = AdultBlueSeries 	+ 5
						Case 67488		
								AdultGold		= AdultGold			+ 1	
								AdultGoldSeries = AdultGoldSeries 	+ 5
						Case 67493
								ChildBlue		= ChildBlue			+ 1
								ChildBlueSeries = ChildBlueSeries 	+ 5
						Case 67489		
								ChildGold		= ChildGold			+ 1
								ChildGoldSeries = ChildGoldSeries 	+ 5
						Case 67494
								SeniorBlue		= SeniorBlue		+ 1
								SeniorBlueSeries = SeniorBlueSeries + 5
						Case 67491		
								SeniorGold		= SeniorGold		+ 1
								SeniorGoldSeries = SeniorGoldSeries + 5

					End Select

				rsMemberCurrent.MoveNext	
				Loop		
			End If

		rsMemberCurrent.Close
		Set rsMemberCurrent = nothing
				
		''errorlog("AdultGoldCount: " & AdultGold & " AdultBlueCount: " & AdultBlue & "")
		''errorlog(" SeniorBlueCount: " & SeniorBlue & " SeniorBlueSeries: " & SeniorBlueSeries & "")
		''errorlog("ChildGoldCount: " & SeniorGold & " ChildBlueCount: " & ChildBlue & "")

		'-----------------------------------------------------------------
		
		'Get the color for this section (needed for this discount to work)
		SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
		Set rsColor = OBJdbConnection.Execute(SQLColor)	
			Color = UCase(rsColor("Color"))				
		rsColor.Close
		Set rsColor = nothing
		
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
			ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing 
		
		Select Case Color
			Case "GOLD"
				Select Case SeatTypeCode
					Case 1
					AllowedCount = AdultGold
					SeriesCount =  AdultGoldSeries
					SeatType = "Adult"
					Case 23
					AllowedCount = SeniorGold
					SeriesCount =  SeniorGoldSeries
					SeatType = "Senior"
					Case 1314
					AllowedCount = ChildGold
					SeriesCount =  ChildGoldSeries
					SeatType = "Child"
				End Select
			Case "BLUE"
				Select Case SeatTypeCode
					Case 1
					AllowedCount = AdultBlue
					SeriesCount =  AdultBlueSeries
					SeatType = "Adult"
					Case 23
					AllowedCount = SeniorBlue
					SeriesCount =  SeniorBlueSeries
					SeatType = "Senior"
					Case 1314
					AllowedCount = ChildBlue
					SeriesCount =  ChildBlueSeries
					SeatType = "Child"
				End Select
		End Select

		'-----------------------------------------------------------------
		
		'Count the number of tickets already discounted
		SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND Color = '" & Color & "' AND Color IN ('" & Tier1_Color & "','" & Tier2_Color & "')) OR (OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R' AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND Color = '" & Color & "' AND Color IN ('" & Tier1_Color & "','" & Tier2_Color & "'))"
		Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
			AppliedSeriesCount = rsApplied("TicketCount")		
		rsApplied.Close
		Set rsApplied = nothing
		
		''errorlog("AppliedSeriesCount " & AppliedSeriesCount & "")

		'Count the number of tickets already discounted
		SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE (CustomerNumber = " & CustomerNumber & " AND Event.ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND Color = '" & Color & "' AND Color IN ('" & Tier1_Color & "','" & Tier2_Color & "')) OR (OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R' AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND Color = '" & Color & "' AND Color IN ('" & Tier1_Color & "','" & Tier2_Color & "'))"
		Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
			AppliedActCount = rsApplied("TicketCount")		
		rsApplied.Close
		Set rsApplied = nothing
		
		''errorlog("AppliedActCount " & AppliedActCount & "")
		
		''errorlog("SeatType: " & SeatType & " Color: " & Color & " Act: " & fnActName(Actcode) & " AllowedActCount: " & AllowedCount & " AppliedActCount: " & AppliedActCount & " AllowedSeriesCount: " & SeriesCount & " AppliedSeriesCount: " & AppliedSeriesCount & "")
		
		If AppliedSeriesCount < SeriesCount Then	
			'errorlog("SeatType: " & SeatType & " Color: " & Color & " AppliedSeriesCount  " & AppliedSeriesCount  & " less than AllowedSeriesCount " & SeriesCount & " CONTINUE")	
			
			If AppliedActCount < AllowedCount Then	

				'errorlog("SeatType: " & SeatType & " Color: " & Color & " Act: " & fnActName(Actcode) & " AllowedActCount: " & AllowedCount & " less then AppliedActCount: " & AppliedActCount & " DISCOUNT")			
				
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
				Surcharge = 0
				AppliedFlag = "Y"
				
			Else
			
				'errorlog("SeatType: " & SeatType & " Color: " & Color & " Act: " & fnActName(Actcode) & " AllowedActCount: " & AllowedCount & " greater then AppliedActCount: " & AppliedActCount & " no discount")	
			
			End If	
			
		Else
			'errorlog("SeatType: " & SeatType & " Color: " & Color & " AppliedSeriesCount  " & AppliedSeriesCount  & " greater than AllowedSeriesCount " & SeriesCount & " do not continue")	
		End If
		'-----------------------------------------------------------------

	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'-----------------------------------------------------------------

	Public Function fnCustomerNumber

		DIM strResults

		If Request("CustomerNumber") = "" Then 
			SQLOrderCustomer = "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & OrderNumber
			Set rsOrderCustomer = OBJdbConnection.Execute(SQLOrderCustomer)
				If Not rsOrderCustomer.EOF Then
					strResults = rsOrderCustomer("CustomerNumber")
				End If
			rsOrderCustomer.Close
			Set rsOrderCustomer = nothing
		Else
			strResults = CleanNumeric(Request("CustomerNumber"))
		End If
		
		fnCustomerNumber = strResults

	End Function

'---------------------------------------------------------

PUBLIC FUNCTION fnActName(Actcode)

	SQLLookUp = "SELECT Act.Act FROM Act (NOLOCK) WHERE ActCode = " & ActCode & ""
	Set rsLookUp = OBJdbConnection.Execute(SQLLookUp)			
		strResults = rsLookUp("Act")
	rsLookUp.Close
	Set rsLookUp = nothing

	fnActName = strResults
	
END FUNCTION		

'-------------------------------------------------


%>