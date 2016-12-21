<%

'CHANGE LOG 

'SSR - 07/13/2013 - Created custom discount
'SSR - 06/17/2015 - Updated discount to allow all ticket types


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

'System will attempt the "Membership" discount first, 
'if no discount is granted it attempt the "Pick 3" discount.

'-----------------------
'Membership Discount
'-----------------------
'Patron receives a discount if they have purchased a membership under 2 possible conditions:

'1) Patron has membership item in the current order  or
'2) Patron has purchased a membership between July 1st of the past year and June 30 of the current year


'Valid Membership Types / Discounts
'----------------------------------------------------------
'Item   Type                Benefit

'4258	Orchestra Level		10% discount 
'4259	Plaza Level 		10% discount

'4261	Star Level			15% discount
'4262	Producer Level		15% discount 

	
'Restrictions
'----------------------------------------------------------
'Valid for any ticket type
'Available for both online and offline orders
'Discount has no expiration date
'Unlimited number of discounts allowed
'Automatic discount
'No change to service fees

'-----------------------
'Pick 3 Discount
'-----------------------
'Patron receives a discount if they have purchased 1 ticket to a required number of productions

'Number						Benefit
'-----------------------------------
'3 productions				10% discount



'Restrictions
'---------------------------------------
'Valid for any ticket type
'Available for both online and offline orders
'Discount has no expiration date
'Unlimited number of discounts allowed
'Automatic discount
'No change to service fees
'No discount for additional tickets

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

DIM DonationFound
DonationFound = False

DIM DonationItemNo
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
	

	NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
	DiscountAmount = Price - NewPrice
	AppliedFlag = "Y" 


Else

	SQLEventCount = "SELECT Seat.EventCode, COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (OrderLine.OrderNumber = " & OrderNumber & ") AND (Seat.EventCode IN (Select EventCode from DiscountEvents (nolock) where DiscountTypeNumber = " & DiscountTypeNumber & " )) GROUP BY Seat.EventCode ORDER BY COUNT(Seat.EventCode) DESC"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then
		rsEventCount.Move(2)
		If Not rsEventCount.EOF Then
			If rsEventCount("SeatCount") >= 1 Then
			
				Percentage = SeriesDiscount
			
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
				DiscountAmount = Price - NewPrice
				AppliedFlag = "Y" 

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