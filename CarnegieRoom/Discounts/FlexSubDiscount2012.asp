<%
    'CHANGE LOG
    'TTT 2/9/12 - Created custom subscription discount
%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

If CDate(FormatDateTime(Now(), vbShortDate)) < CDate("04/21/2012") Then

    'ActCodeList = "74528,74543,74547,74531,74301,74527,74536,74520,74540,74544,74523,74534,74524,74522,74525,74532,74545,74535,74526,74537,74542,74521,74529,74530,74539,74546,74533"
    ActCodeList = "74528,74615,74635,74543,74547,74301,74527,75045,74616,74536,74520,74540,74544,74523,74636,74542,74534,74524,74522,74525,74532,74545,74617,74535,74526,74537,74521,74529,74539,74546,74614,74612,74613,74533,74618,75044"
    ActCodes = ""
    ActCodeQty = ""
    ActCount = 0
    
    SQLActCount = "SELECT Event.ActCode, COUNT(Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode"
    Set rsActCount = OBJdbConnection.Execute(SQLActCount)
    Do While Not rsActCount.EOF
        If CInt(rsActCount("ActCount")) > 0 Then
            ActCodes = ActCodes & rsActCount("ActCode") & ","
            ActCodeQty = ActCodeQty & rsActCount("ActCount") & ","
            ActCount = ActCount + 1
        End If
        rsActCount.MoveNext
    Loop
    rsActCount.Close
    Set rsActCount = nothing

    NumberOfSub = 0
    If ActCodes <> "" Then
        ActCodes = Left(ActCodes, Len(ActCodes) - 1)
        ActCodeQty = Left(ActCodeQty, Len(ActCodeQty) -1)
        NumberOfSub = Min(Split(ActCodeQty,","))
    End If 

    If CInt(ActCount) = 3 Or CInt(ActCount) = 5 Then
    
        If CInt(ActCount) = 3 Then
            PriceAdult = 15
            PriceYoungAdult = 10
        Else
            PriceAdult = 12
            PriceYoungAdult = 9
        End If

        ActCodeArray = Split(ActCodes, ",")
        For i = LBound(ActCodeArray) To UBound(ActCodeArray)
            SQLActDiscount = "SELECT TOP(" & NumberOfSub & ") OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode = " & ActCodeArray(i)
            Set rsActDisCount = OBJdbConnection.Execute(SQLActDiscount)
            Do While Not rsActDisCount.EOF
                If CStr(Request("LineNumber")) = CStr(rsActDisCount("LineNumber")) Then
                    If SeatTypeCode = 1 Then
                        NewPrice = PriceAdult
                    ElseIf SeatTypeCode = 6442 Then
                        NewPrice = PriceYoungAdult
                    End If
                    If Price > NewPrice Then
                        DiscountAmount = Price - NewPrice
                        AppliedFlag = "Y"
                    End If                    
                End If
                rsActDisCount.MoveNext
            Loop
            rsActDisCount.Close
            Set rsActDisCount = Nothing
        Next

    End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>
