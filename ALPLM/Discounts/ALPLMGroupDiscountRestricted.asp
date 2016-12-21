<%
'CHANGE LOG

'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'SSR 1/10/14 - Updated discount script.
'SSR 4/8/15 - Updated discount script.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==========================================

'Lincoln Presidential Library and Museum
'Restricted Group Discount

'Fixed Price discount with New Seat Type Code
'based on ActCode

'Discount use is restricted to specific user numbers.

'-----------------------
'Discount Code: GROUP
'-----------------------
'ActCode: 			37939 (Museum Admission)
'New price: 		$7.00
'New SeatTypeCode: 	2533 (Group)

'ActCode: 			99336 (Museum Admission - FULL EXPERIENCE)
'New price: 		$10.00
'New SeatTypeCode: 	8481 (Group - FULL EXPERIENCE)

'===========================================

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		SQLUserNo = "SELECT UserNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & OrderNumber
		Set rsUserNo = OBJdbConnection.Execute(SQLUserNo)
			If Not rsUserNo.EOF Then
				UserNo = rsUserNo("UserNumber")
			End If
		rsUserNo.Close
		Set rsUserNo = Nothing

		'SLM 6/1/9 - Restricted discount to specific users
		AllowedUser = "N"
		
		If CInt(UserNo) = 9479 OR CInt(UserNo) = 9641 OR CInt(UserNo) = 9654 OR CInt(UserNo) = 9652 OR CInt(UserNo) = 263 OR CInt(UserNo) = 1212 Then
			AllowedUser = "Y"
		End If

		If AllowedUser = "Y" Then 'It's okay to apply to this order type and seat type.

			'Get Act Code
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)
			ActCode = rsAct("ActCode")
			rsAct.Close
			Set rsAct = nothing
															
			Select Case ActCode
				Case "37939","114129" '(Museum Admission, Museum Admission - 2-Day) 
					'New Fixed Price
					FixedPrice = 7
					'Assign New Ticket Type: Group
					SeatTypeCode = 2533
				Case "99336","114130" '(Museum Admission - FULL EXPERIENCE, Museum Admission - FULL EXPERIENCE - 2-Day)
					'New Fixed Price
					FixedPrice = 10
					'Assign New Ticket Type: Group - FULL
					SeatTypeCode = 8481
			End Select
			
			If FixedPrice <> "" Then
				NewPrice = FixedPrice
			Else
				NewPrice = Round(Clean(Request("Price")),2)
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

		End If

	End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<SEATTYPECODE>" & SeatTypeCode & "</SEATTYPECODE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>