<%

'CHANGE LOG
'SSR 10/1/2013 - Created Discount
'SSR 10/4/2013 - Update

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'======================================

'Academy of Music Theatre 11/18/2013

'2014 Season Subscription Discount

'Minimum Purchase Requirement: 3 tickets

'1 ticket 
'for the required poduction
'-----------------------------
'98717 	 PVPA’s – Chicago The Musical


'1 ticket
'for 2 different productions
'-----------------------------
'98715 	 PVPA presents – The Merchant of Venice
'98713 	 PVPA presents- Our Country’s Good
'98714 	 PVPA’s Catalyst Dance Company
'98716 	 PVPA’s WOFA Show – Sona The Orphan
'98712 	 Winter Journey – PVPA’s Music Department Showcase
'98718 	 Bright Size Life – PVPA’s Music Department Showcase

'Discount Amount: 15%

'Automatic
'Ticket types must match
'Avail Online and offline.
'No change to service fees.


'SeatCode	SeatType
'1			Adult
'3			Senior
'6			Student
'3678		Adult cc
'3681		Student cc
'3682		Senior cc

'Note: For purposes of this season subscription discount, 
'AdultCC, StudentCC and SeniorCC will be treated as if they were Adult, Student and Senior 


'======================================

'Initialize Variables

BonusActCodeList = "98717"
ActCodeList = "98715,98713,98714,98716,98712,98718"

ReqActCount = 1
SeriesCount = 2

'--------------------------------------

'Season Subscription Discount


	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		Select Case SeatTypeCode
			Case 3678 
				ThisSeatTypeCode = 1
			Case 3682 
				ThisSeatTypeCode = 3
			Case 3681 
				ThisSeatTypeCode = 6
			Case Else
				ThisSeatTypeCode = SeatTypeCode
		End Select

		'ErrorLog("ThisSeatTypeCode   " & ThisSeatTypeCode  & "")

		If ThisSeatTypeCode = 1 OR ThisSeatTypeCode = 3  OR ThisSeatTypeCode = 6 Then
		
		
				'Count the number of season acts with matching ticket types.
				SQLBonusActCount = "SELECT COUNT(ActCode) AS BonusActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & BonusActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS BonusActCount"
				Set rsBonusActCount = OBJdbConnection.Execute(SQLBonusActCount)
				BonusActCount = rsBonusActCount("BonusActCount")
				rsBonusActCount.Close
				Set rsBonusActCount = nothing
				
				'ErrorLog("BonusActCount  " & BonusActCount & "")
			
				'Count the number of season acts with matching ticket types.
				SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
				Set rsActCount = OBJdbConnection.Execute(SQLActCount)
					ActCount = rsActCount("ActCount")
				rsActCount.Close
				Set rsActCount = nothing
				
				'ErrorLog("ActCount   " & ActCount  & "")
				

				If ActCount => SeriesCount AND BonusActCount => ReqActCount Then

					'MyPrice = Series(CInt(ActCount),CInt(ThisSeatTypeCode)) 

					''ErrorLog("MyPrice  " & MyPrice & "")

					'Determine how many sets of matching act code / ticket type  are on the order
					SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ", " & BonusActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
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

					'Determine the number of tickets which have been discounted
					SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
					Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
					AppliedCount = rsDiscCount("LineCount")        		
					rsDiscCount.Close
					Set rsDiscCount = nothing	
					
						SeriesCount = ActCount + NbrSubscriptions
						
						SeriesPercentage = 15

						If AppliedCount < NbrSubscriptions Then
						
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)		
						
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


		End If

	End If



Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>