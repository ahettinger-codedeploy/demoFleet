<!--#include virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------------

'Fort Lewis College
'Past Donation Discount + 'Pick 3 Discount

'Shopping Cart will attempt the "Past Donation" discount first, 
'if no discount is granted it will then process the "Pick 3" discount.

'-----------------------
'Past Donation Discount
'-----------------------
'Patron receives discount based on membership/donation level purchased:

'Patron has membership/donation item in current order  or
'Patron has purchased membership/donation between July 1, 2013 and June 30, 2014.

'Item   Type                Benefit
'----------------------------------------------------------
'4258	Orchestra Level     10% discount       
'4261	Star Level     		15% discount

                    
'Restrictions
'---------------------------------------
'Valid for any ticket type
'Available for both online and offline orders
'Discount has no expiration date
'Unlimited number of discounts allowed
'Automatic discount
'No change to service fees



'---------------
'Pick 3 Discount
'---------------
'Patron receives discount based on number of productions purchased:

'Count						Benefit
'-----------------------------------
'3 or more productions		10% discount



'Restrictions
'---------------------------------------
'Valid for Individual ticket type only
'Available for both online and offline orders
'Discount has no expiration date
'Unlimited number of discounts allowed
'Automatic discount
'No change to service fees

'---------------------------------------------------------------

ItemNumberList = "4258,4259,4261,4262,4263"

StartDate = "6/1/2013"
EndDate = "6/30/2014"

MemberDiscount1 = 10
MemberDiscount2 = 15

ReqSeatType = 16

DonationFound = False
DonationItemNo = ""

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
SQLMemberPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CustomerNo  & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderDate > '06/30/2013' AND OrderHeader.OrderDate < '07/01/2014' AND OrderHeader.OrderNumber <> " & OrderNumber & ""
Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)
If Not rsMemberPrevious.EOF Then
	DonationFound = True
	DonationItemNo = rsMemberPrevious("ItemNumber")
End If
rsMemberPrevious.Close
Set rsMemberPrevious = nothing


If DonationFound Then

	Select Case DonationItemNo
		Case 4258	'Orchestra Level -10% discount  
		Percentage = MemberDiscount1
		Case 4259	'Plaza Level - 10% discount 
		Percentage = MemberDiscount1
		Case 4261	'Star Level - 15% discount
		Percentage = MemberDiscount2
		Case 4262	'Producer Level - 15% discount
		Percentage = MemberDiscount2
		Case 4263	'Headliner Level - 15% discount
		Percentage = MemberDiscount2
	End Select
	

	NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
	DiscountAmount = Price - NewPrice
	AppliedFlag = "Y" 


Else

	SQLEventCount = "SELECT Seat.EventCode, COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (OrderLine.OrderNumber = " & OrderNumber & ") AND OrderLine.SeatTypeCode = "& ReqSeatType & " AND (Seat.EventCode IN (Select EventCode from DiscountEvents (nolock) where DiscountTypeNumber = " & DiscountTypeNumber & " )) GROUP BY Seat.EventCode ORDER BY COUNT(Seat.EventCode) DESC"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then
		rsEventCount.Move(2)
		If Not rsEventCount.EOF Then
			If rsEventCount("SeatCount") >= 1 Then
			
			Select Case SeatTypeCode
				Case 16
					NewPrice = round(Price * .90, 2)
					DiscountAmount = Price - NewPrice
					AppliedFlag = "Y"
				Case Else
					NewPrice = Price
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