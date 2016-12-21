<%

'CHANGE LOG - Inception
'SSR  (12/14/2011)
'Custom Discount Code Created. 

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'====================================================================

'Parameters
'Build Your Own Subscription
'Total number of productions to buy: 3

'Prices:
'Student Season: $22.00
'Alumni Season: $$22.00
'Senior Season: $28.00
'General Season $35.00

'Eligible ActCodes / EventCodes
'ActCodes: 96264, 96454, 96456
'Offline/Online
'Online and Offline
'Service Fees
'Do not re-calculate service fees

'Automatic/Code Entry
'Discount should be applied automatically
'Expiration
'No expiration
'Restrictions
'None

'Contact
'Leah Skeen
'360-992-2708
'lskeen@clark.edu

ActCodeList =  "96264, 96454, 96456"
SeriesCount = 3

'====================================================================

'Determine that it's okay to apply discounts.

If AllowDiscount = "Y" Then 

	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing
	
	'ErrorLog("ActCount "&ActCount&"")

	If ActCount => SeriesCount Then

		'Determine how many sets of matching act code are on the order
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
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
		
		'ErrorLog("AppliedCount "&AppliedCount&"")
		'ErrorLog("NbrSubscriptions "&NbrSubscriptions&"")

		'Should the number of possible discounts be less then the total possible go ahead and discount this ticket
		If AppliedCount < NbrSubscriptions Then
				
					'Enter Pricing Rules Here.
					Select Case SeatTypeCode 
						Case 3 	'Senior
							SeriesPrice = 28.00
						Case 4 	'General 
							SeriesPrice = 35.00
						Case 6 	'Student
							SeriesPrice = 22.00
						Case 380 'Alumni
							SeriesPrice = 22.00
					End Select
					
					'ErrorLog("SeriesPrice "&SeriesPrice&"")
					
					'Count # of applied tickets on this order
					SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
					Set rsCount = OBJdbConnection.Execute(SQLCount)
					TotalAppliedCount = rsCount("AppliedCount")
					rsCount.Close
					Set rsCount = nothing
					
					ErrorLog("TotalAppliedCount "&TotalAppliedCount&"")
				
					'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
					Remainder = TotalAppliedCount MOD SeriesCount

					'Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
					If Remainder = SeriesCount - 1 Then 
						NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice / SeriesCount, 2))
					Else
						'Standard rounding on all other tickets.
						NewPrice = Round(SeriesPrice/SeriesCount, 2)
					End If
										
					If Price > NewPrice Then
						DiscountAmount = Clean(Request("Price")) - NewPrice
						AppliedFlag = "Y"
					End If
		
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