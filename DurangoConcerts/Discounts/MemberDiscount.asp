<%

'CHANGE LOG 

'SSR - 07/13/2013 - Created custom discount
'SSR - 06/17/2015 - Updated to allow all ticket types
'SSR - 06/29/2015 - Updated valid dates for membershipo
'SSR - 06/30/2015 - Updated to allow only adult and individual ticket types


%>

<!--#include virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------------

'Fort Lewis College
'Membership Discount + 'Pick 3 Discount

'Discount will apply either a "Membership"  or a "Pick 3" discount.
'It will check to see if the order qualifies for the "Membership" discount and apply the discount.
'If the order does not qualify, it will then check to see if it qualifies for the "Pick 3" discount and apply it.

'///////////////////////
'MEMBERSHIP DISCOUNT
'///////////////////////

'Membership discount is applied to orders for patrons who have a valid membership.

'Valid membership requires:

'1) Patron has membership item in the current order  
'OR
'2) Patron has purchased a membership between July 1st of the past year and June 30 of the current year
'3) Patron must use the same email address across all orders in order for the discount to be correctly applied.


'Valid Membership Types / Discounts
'----------------------------------------------------------
'Item   Type                Benefit

'4258	Orchestra Level		10% discount 
'4259	Plaza Level 		10% discount

'4261	Star Level			15% discount
'4262	Producer Level		15% discount 


'Valid Ticket Types
'----------------------------------------------------------
'Code   Type     
'01		Adult          
'16 	Individual 

	
'Restrictions
'----------------------------------------------------------
'Available for both online and offline orders
'Discount has no expiration date
'Unlimited number of discounts allowed
'Discount is automatic
'Service Fees are not changed

'///////////////////////
'PICK 3 DISCOUNT
'///////////////////////

'"Pick 3" discount will be applied on orders in which patron has purchased
'1 ticket to each of 3 different productions.

'Once the 3 ticket requirement has been met, any additional tickets on the
'order will also qualify for the the "Pick 3" discount

'Ticket Count	Benefit
'-----------------------------------
'3				10% discount


'Valid Ticket Types
'----------------------------------------------------------
'Code   Type     
'01		Adult          
'16 	Individual 

'Restrictions
'---------------------------------------
'Available for both online and offline orders
'Discount has no expiration date
'Unlimited number of discounts allowed
'Discount is automatic
'Service Fees are not changed

'---------------------------------------------------------------

'SeriesCount
SeriesCount = 3

'Series Discount
SeriesDiscount	= 10

'Membership Types
ItemNumberList = "4258,4259,4261,4262"

'Membership Discount Levels
MemberDiscount1 = 10
MemberDiscount2 = 15

'Membership StartDate
DIM StartDate
m1=7
d1=1
y1=(Year(date)-1)
StartDate = DateSerial(y1,m1,d1)
'StartDate = "07/01/2014"

'Membership EndDate
DIM EndDate
m2=6
d2=30
y2=Year(date)
EndDate = DateSerial(y2,m2,d2)
'EndDate = "06/30/2015"

'Valid Ticket Types
ReqSeatType = "1,16,45"

DIM DonationFound
DonationFound = False

DIM DonationItemNo
DonationItemNo = ""

'-----------------------------------------

	'Get the customer number
	SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
	Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
		If Not rsMemberNumber.EOF Then
			CustomerFound = True
			CustomerNo = rsMemberNumber("CustomerNumber")
		End If
	rsMemberNumber.Close
	Set rsMemberNumber = nothing


	'Check for donations in current order
	SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & OrderNumber &""
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
		If Not rsMemberCurrent.EOF Then 'it is in order
			DonationFound = True
			DonationItemNo = rsMemberCurrent("ItemNumber")
		End If
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing


	'Check for donations in past orders for past year
	SQLMemberPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CustomerNo  & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderDate > '" & StartDate & "' AND OrderHeader.OrderDate < '" & EndDate & "' AND OrderHeader.OrderNumber <> " & OrderNumber & ""
	Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)
		If Not rsMemberPrevious.EOF Then
			DonationFound = True
			DonationItemNo = rsMemberPrevious("ItemNumber")
		End If
	rsMemberPrevious.Close
	Set rsMemberPrevious = nothing


	If DonationFound Then

		Select Case DonationItemNo
			Case 4258	'Orchestra Level discount  
			Percentage = MemberDiscount1
			Case 4259	'Plaza Level  discount 
			Percentage = MemberDiscount1
			Case 4261	'Star LeveL discount
			Percentage = MemberDiscount2
			Case 4262	'Producer Level discount
			Percentage = MemberDiscount2
		End Select

		Select Case SeatTypeCode
			Case 1,16
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
				DiscountAmount = Price - NewPrice
				AppliedFlag = "Y" 
		End Select

	Else

		SQLEventCount = "SELECT Seat.EventCode, COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (OrderLine.OrderNumber = " & OrderNumber & ") AND (Seat.EventCode IN (Select EventCode from DiscountEvents (nolock) where DiscountTypeNumber = " & DiscountTypeNumber & " )) AND OrderLine.SeatTypeCode IN (" & ReqSeatType & ") GROUP BY Seat.EventCode ORDER BY COUNT(Seat.EventCode) DESC"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

			If Not rsEventCount.EOF Then
				rsEventCount.Move(2)
				If Not rsEventCount.EOF Then
					If rsEventCount("SeatCount") >= 1 Then
					
						Select Case SeatTypeCode
							Case 1,16,45
							Percentage = SeriesDiscount
							NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
							DiscountAmount = Price - NewPrice
							AppliedFlag = "Y" 
						End Select

					End If
				End If
			End If

		rsEventCount.Close
		Set rsEventCount = nothing
		
	End If

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf



%>