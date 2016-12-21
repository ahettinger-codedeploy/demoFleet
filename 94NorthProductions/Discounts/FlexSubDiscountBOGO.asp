<%

'CHANGE LOG - Inception

'SSR - 10/30/15 - Custom Discount Created

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->
<%

'================================================================

'94 North Productions

'Purchase 1 ticket to 3 productions
'Series price = price of 2 tickets
'All tickets in each subscription must be the same ticket type

'Ticket Type				Code	Single Price	Series Price
'Adult Preferred 			65545		$49.95  	$99.90
'Senior Preferred 65+ 		65546		$46.95		$93.90
'Adult 						54126		$44.95		$89.90
'Senior 65+ 				65459		$41.95		$83.90
'Child under 12 			54146		$24.95		$49.90
'Child Preferred 			65919		$24.95		$49.90

'================================================================

	ActCodeList = "111574,111575,111613,118399,118602,118762,120169,120178,121431"

	DIM SeatType(5)
	DIM SeatPrice(5)
	DIM SeriesPrice
	DIM SeriesCount

	SeatType(0)		=	65545
	SeatPrice(0)	=	99.90

	SeatType(1)		=	65546
	SeatPrice(1)	=	93.90

	SeatType(2)		=	54126
	SeatPrice(2)	=	89.90

	SeatType(3)		=	65459
	SeatPrice(3)	=	83.90

	SeatType(4)		=	54146
	SeatPrice(4)	=	49.90

	SeatType(5)		=	65919
	SeatPrice(5)	=	49.90
	
	SeriesPrice		= 	0
	
	SeriesCount 	= 	3

'----------------------------------------------------------

	'Determine that it's okay to apply discounts.
	If AllowDiscount = "Y" Then 

		'Counts the number of tickets to each act with matching Seat Type Code
		'Determine the number of acts with matching ticket types.
		SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
		rsActCount.Close
		Set rsActCount = nothing
		
		ErrorLog("ActCount: " & ActCount & "")
				
		If ActCount >= SeriesCount Then
				
			'Get the least number of tickets for any applicable ActCode
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)			
			NbrSubscriptions = rsMinTicketCount("NumSubs")			
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing	
			
			ErrorLog("NbrSubscriptions : " & NbrSubscriptions  & "")
					
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
			
				ErrorLog("SeatTypeCode : " & SeatTypeCode  & "")
			
				For i = lBound(SeatType) To uBound(SeatType)

					If int(SeatTypeCode) = int(SeatType(i)) Then
						ErrorLog("SeatTypeCode : " & SeatTypeCode  & " match Seattype: " & SeatType(i) & "")
						SeriesPrice = SeatPrice(i)
					Else
						ErrorLog("SeatTypeCode : " & SeatTypeCode  & " no match Seattype: " & SeatType(i) & "")
					End If
					
				Next
				
				ErrorLog("SeriesPrice : " & SeriesPrice  & "")
				
				If SeriesPrice <> 0 Then

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
							
						DiscountAmount =  Clean(Request("Price")) - NewPrice
									
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