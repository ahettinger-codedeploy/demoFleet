<%
'CHANGE LOG
'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================================

'Academy of Music (1/7/2014)

'Event Series Discount

'Our friends at Academy of Music would like a new custom discount:
'25% off each ticket when the following are true:
'1 ticket to each of these events is on the order:
'#613554; #613550; #613551 PVPA- Our Country’s Good or #613608; #613609 PVPA Catalysts or #613610; #613611; #613612 PVPA  Merchant of Venice or #613619; #613622 PVPA WOFA show or #613628; #613629 Bright Size Life- PVPA Music.
'Do not recalc the fees.
'Discount to be applied automatically
'Contact
'Jessica Abbate
'boxoffice@academyofmusictheatre.com
'Thanks!

'==================================================================

'Package #1: PVPA-Our Country’s Good
EventList1 = "613554,613550,613551"

'Package #2: PVPA-Catalysts
EventList2 = "613608, 613609"

'Package #3: PVPA-Merchant of Venice
EventList3 = "613610,613611,613612"

'Package #4: PVPA-WOFA show
EventList4 = "613619,613622" 

'Package #5: PVPA-Bright Size Life
EventList5 = "613628,613629"


If AllowDiscount = "Y" Then 'It's okay to apply to this order.


	'------------------------------------------


	'Package #1: PVPA-Our Country’s Good

	SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventList1 & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS EventCount"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
	EventCount = rsEventCount("EventCount")	
	rsEventCount.Close
	Set rsEventCount = nothing 
		
	If EventCount >= 3 Then
	
	Select Case EventCode
	
		Case 613554,613550,613551
			
				If Clean(Request("Percentage")) <> "" Then
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
				ElseIf Clean(Request("FixedPrice")) <> "" Then
					NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
				Else
					NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
				End If	
				
				If NewPrice < 0 Then
					NewPrice = 0
				End If
				
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

				If NewSurcharge <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
				
				AppliedFlag = "Y"
				
		End Select

	End If
	
	'------------------------------------------
	
	'Package #2: PVPA-Catalysts

	SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventList2 & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS EventCount"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
	EventCount = rsEventCount("EventCount")	
	rsEventCount.Close
	Set rsEventCount = nothing 
		
	If EventCount >= 2 Then
	
	Select Case EventCode
	
		Case 613608, 613609
			
				If Clean(Request("Percentage")) <> "" Then
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
				ElseIf Clean(Request("FixedPrice")) <> "" Then
					NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
				Else
					NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
				End If	
				
				If NewPrice < 0 Then
					NewPrice = 0
				End If
				
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

				If NewSurcharge <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
				
				AppliedFlag = "Y"
				
		End Select

	End If
	
	'------------------------------------------
	
	'Package #3: PVPA-Catalysts

	SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventList2 & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS EventCount"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
	EventCount = rsEventCount("EventCount")	
	rsEventCount.Close
	Set rsEventCount = nothing 
		
	If EventCount >= 2 Then
	
	Select Case EventCode
	
		Case 613608, 613609
			
				If Clean(Request("Percentage")) <> "" Then
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
				ElseIf Clean(Request("FixedPrice")) <> "" Then
					NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
				Else
					NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
				End If	
				
				If NewPrice < 0 Then
					NewPrice = 0
				End If
				
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

				If NewSurcharge <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
				
				AppliedFlag = "Y"
				
		End Select

	End If
	
	'------------------------------------------
		
	'Package #4: PVPA-WOFA show

	SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventList4 & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS EventCount"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
	EventCount = rsEventCount("EventCount")	
	rsEventCount.Close
	Set rsEventCount = nothing 
		
	If EventCount >= 2 Then
	
	Select Case EventCode
	
		Case 613619,613622
			
				If Clean(Request("Percentage")) <> "" Then
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
				ElseIf Clean(Request("FixedPrice")) <> "" Then
					NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
				Else
					NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
				End If	
				
				If NewPrice < 0 Then
					NewPrice = 0
				End If
				
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

				If NewSurcharge <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
				
				AppliedFlag = "Y"
				
		End Select

	End If
	
	'------------------------------------------
		
	'Package #5: PVPA-Bright Size Life

	SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventList5 & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS EventCount"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
	EventCount = rsEventCount("EventCount")	
	rsEventCount.Close
	Set rsEventCount = nothing 
		
	If EventCount >= 2 Then
	
	Select Case EventCode
	
		Case 613628,613629
			
				If Clean(Request("Percentage")) <> "" Then
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
				ElseIf Clean(Request("FixedPrice")) <> "" Then
					NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
				Else
					NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
				End If	
				
				If NewPrice < 0 Then
					NewPrice = 0
				End If
				
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

				If NewSurcharge <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
				
				AppliedFlag = "Y"
				
		End Select

	End If
	
	
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>