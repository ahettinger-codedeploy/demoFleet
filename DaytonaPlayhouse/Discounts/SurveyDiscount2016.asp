<%
'CHANGE LOG
'TTT 3/10/16 - Created for Tix2 survey 
%>
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->
<%
Tix2SurveyNumber = 2136
Dim EventActQty(1,2)
EventActQty(0,0) = "846980" 'Subscription Package Flex - 2016-17
EventActQty(1,0) = "846982" 'Subscription Package Flex - Renaissance
EventActQty(0,1) = "125182,125184,125186,125187,125354,125355"
EventActQty(1,1) = "125183,125185,125356"
EventActQty(0,2) = 6
EventActQty(1,2) = 3
FlexBothEvent = "846981" 'Subscription Package Flex - Both
TicketTypes = "8120,8121"

SQLCurrentCustomer = "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & OrderNumber
Set rsCurrentCustomer = OBJdbConnection.Execute(SQLCurrentCustomer)
If Not rsCurrentCustomer.EOF Then
	CustomerNumber = rsCurrentCustomer("CustomerNumber")
End If
rsCurrentCustomer.Close
Set rsCurrentCustomer = nothing

If CustomerNumber = "1" Then
    AllowDiscount = "N"
End If

ApplicableDiscount = 0
SQLDiscountCount = "SELECT Answer FROM SurveyAnswers (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND SurveyNumber = " & Tix2SurveyNumber & " AND Question = 'Please select the number of tickets to redeem'"
Set rsDiscountCount = OBJdbConnection.Execute(SQLDiscountCount)
If Not rsDiscountCount.EOF Then
	ApplicableDiscount = rsDiscountCount("Answer")
End If
rsDiscountCount.Close
Set rsDiscountCount = nothing

If ApplicableDiscount <= 0 Then
    AllowDiscount = "N"
End If

If AllowDiscount = "Y" Then 'It's okay to apply to this order.
    SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType = 'Seat' AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TotalAppliedCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
    If CInt(TotalAppliedCount) < CInt(ApplicableDiscount) Then
        For i = 0 to 1
            ApplicableMaxApply = 0
            'Determine if required event is on the current order or has already been purchased.
            ParentCount = 0
            SQLParentTickets = "SELECT COUNT(*) AS ParentCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE ((OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderHeader.OrderNumber <> " & OrderNumber & " AND OrderLine.StatusCode = 'S') OR OrderHeader.OrderNumber = " & OrderNumber & ") AND Seat.EventCode IN(" & FlexBothEvent & "," & EventActQty(i,0) & ") AND OrderLine.ItemType = 'Seat' AND OrderLine.SeatTypeCode IN (" & TicketTypes & ")"
            Set rsParentTickets = OBJdbConnection.Execute(SQLParentTickets)
            If Not rsParentTickets.EOF Then
                ParentCount = rsParentTickets("ParentCount")
            End If
            rsParentTickets.Close
            Set rsParentTickets = nothing

            If ParentCount > 0 Then
                'Determine number of discounted tickets already given to the patron
                ChildCount = 0
                SQLChildTickets = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType = 'Seat' AND Event.ActCode IN (" & EventActQty(i,1) & ")"
                Set rsChildTickets = OBJdbConnection.Execute(SQLChildTickets)
                If Not rsChildTickets.EOF Then
                    ChildCount = rsChildTickets("ChildCount")
                End If
                rsChildTickets.Close
                Set rsChildTickets = nothing

                ApplicableMaxApply = (ParentCount * EventActQty(i,2)) - ChildCount
                If ApplicableMaxApply > 0 Then
                    If CInt(ApplicableDiscount) > CInt(ApplicableMaxApply) Then
                        ApplicableDiscount = ApplicableMaxApply
                    End If
                    Call ProcessDiscount(ApplicableDiscount, EventActQty(i,1))
                End If
            End If
        Next
    End If
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

Sub ProcessDiscount(TotalApply, ActCodes)
    'Check how many already been applied to this order
    SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode IN(" & ActCodes & ") AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	AppliedCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing

    If AppliedCount < TotalApply Then
        'Apply discount to highest price first
        SQLLineNo = "SELECT TOP(" & TotalApply - AppliedCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType = 'Seat' AND Event.ActCode IN (" & ActCodes & ") AND DiscountTypeNumber = 0 AND Discount = 0 ORDER BY Price DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        Do While Not rsLineNo.EOF
            If CStr(LineNumber) = CStr(rsLineNo("LineNumber")) Then
                NewPrice = 0
                DiscountAmount = Price

                If NewSurcharge <> "" Then
		            Surcharge = NewSurcharge
	            ElseIf Request("CalcServiceFee") <> "N" Then
		            Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	            End If
		
	            AppliedFlag = "Y"
            End If
            rsLineNo.movenext
        Loop
        rsLineNo.Close
	    Set rsLineNo = nothing
    End If
End Sub
%>