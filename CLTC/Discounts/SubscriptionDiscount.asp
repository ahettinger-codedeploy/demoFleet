<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"
ActCodeArray = Array(62448,62445,62451,62449,62450,62447)
ActCountArray = ""
ActCnt = 0
ActCodeList = ""

For i = 0 to ubound(ActCodeArray)
    SQLProduction = "SELECT COUNT(LineNumber) AS TixCnt FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.ActCode = " & ActCodeArray(i)
    Set rsProduction = OBJdbConnection.Execute(SQLProduction)
    If CInt(rsProduction("TixCnt")) > 0 Then
        ActCnt = ActCnt + 1
        ActCodeList = ActCodeList & ActCodeArray(i) & ","
        ActCountArray = ActCountArray & rsProduction("TixCnt") & ","
    End If
    rsProduction.Close
    Set rsProduction = Nothing
Next

If ActCodeList <> "" Then
    ActCountArray = Left(ActCountArray,len(ActCountArray)-1)
    If CInt(ActCnt) = 5 Then 'if 5 actcodes, remove 1 from list
        ActCodeList = Left(ActCodeList,len(ActCodeList)-7)
    Else
        ActCodeList = Left(ActCodeList,len(ActCodeList)-1)
    End If
    ActOrderArray = Split(ActCodeList,",")
End If

If CInt(ActCnt) >= 4 Then
    NumberOfSub = Min(Array(ActCountArray))
    CurrentDate = CDate(FormatDateTime(Now(), vbShortDate))
    For i = 0 to ubound(ActOrderArray)
        SQLSubscription = "SELECT TOP(" & NumberOfSub & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.ActCode = " & ActOrderArray(i)
        Set rsSubscription = OBJdbConnection.Execute(SQLSubscription)
        Do While Not rsSubscription.EOF
            If CStr(Request("LineNumber")) = CStr(rsSubscription("LineNumber")) Then
                If CurrentDate < CDate("5/1/2011") Then 
                    If CInt(ActCnt < 6) Then '4 Actcodes
                        Select Case SeatTypeCode
                            Case "1"
                                NewPrice = 20
                            Case "27"
                                NewPrice = 17.5
                            Case "1119","763","761"
                                NewPrice = 13.75
                            Case Else
                                NewPrice = Price
                        End Select
                    Else
                        Select Case SeatTypeCode
                            Case "1"
                                NewPrice = 18
                            Case "27"
                                NewPrice = 16
                            Case "1119","763","761"
                                NewPrice = 12.5
                            Case Else
                                NewPrice = Price
                        End Select
                    End If
                ElseIf CurrentDate < CDate("7/1/2011") Then   
                    If CInt(ActCnt < 6) Then
                        Select Case SeatTypeCode
                            Case "1"
                                NewPrice = 21.25
                            Case "27"
                                NewPrice = 18.75
                            Case "1119","763","761"
                                NewPrice = 13.75
                            Case Else
                                NewPrice = Price
                        End Select
                    Else
                        Select Case SeatTypeCode
                            Case "1"
                                NewPrice = 19
                            Case "27"
                                NewPrice = 17
                            Case "1119","763","761"
                                NewPrice = 12.5
                            Case Else
                                NewPrice = Price
                        End Select
                    End If
                ElseIf CurrentDate < CDate("11/1/2011") Then
                    If CInt(ActCnt < 6) Then
                        Select Case SeatTypeCode
                            Case "1"
                                NewPrice = 22.5
                            Case "27"
                                NewPrice = 20
                            Case "1119","763","761"
                                NewPrice = 13.75
                            Case Else
                                NewPrice = Price
                        End Select
                    Else
                        Select Case SeatTypeCode
                            Case "1"
                                NewPrice = 20
                            Case "27"
                                NewPrice = 18.5
                            Case "1119","763","761"
                                NewPrice = 12.5
                            Case Else
                                NewPrice = Price
                        End Select
                    End If
                Else
                    NewPrice = Price
                End If
                If Price > NewPrice Then
                    DiscountAmount = Price - NewPrice
                    AppliedFlag = "Y"
                End If
            End If
            rsSubscription.movenext
        Loop
        rsSubscription.Close
        Set rsSubscription = Nothing
    Next
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>