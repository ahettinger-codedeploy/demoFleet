<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Bragg Creek Performing Arts (5/10/2010)
'UPDATE: Removed expiration date (and start date) from discount code


'Bragg Creek Performing Arts (4/30/2010)
'UPDATE: Changed start date from May 1 to April 30


'Bragg Creek Performing Arts (4/27/2010)
'2010 Season Subscription Discount
'Valid from May 1 2010 to May 10 2010
'All Ticket Types
'Automatic
'===================================

'Buy tickets for any 4 concerts, 10% discount
'Buy tickets for any 5 concerts, 11% discount
'Buy tickets for any 6 concerts, 12% discount
'Buy tickets for all 7 concerts, 15% discount


'Valid productions:

'ActCode     Act Name
'49776	    Marc Atkinson Electric Project 
'49777	    Mary Lou Fallis
'49778	    Delhi 2 Dublin
'49779	    Paul Rumbolt Evening Performance
'49780	    Suzie Vinnick with Rick Fines
'49781	    Dala Evening Performance
'49782	    Joel Plaskett


'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
AppliedFlag = "N"

'Set Discount Variables
ActCodeList = "49776,49777,49778,49779,49780,49781,49782" 'ActCodes of Productions which can be included in Season Subscription.
	
	'Determine the number of acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	Select Case ActCount				
	   Case 4 '4 Show Season Subscription
	       SeriesCount = 4
	       SeriesDiscount = 10
	   Case 5 '5 Show Season Subscription
	       SeriesCount = 5
	       SeriesDiscount = 11
	   Case 6 '6 Show Season Subscription
	      SeriesCount = 6
	      SeriesDiscount = 12
	   Case 7 '6 Show Season Subscription
	      SeriesCount = 7
	      SeriesDiscount = 15
	End Select
	
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
                                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesDiscount)/100), 2)
  			           End If
        					
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
    
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>