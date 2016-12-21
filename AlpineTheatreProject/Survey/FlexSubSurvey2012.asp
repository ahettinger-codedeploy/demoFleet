<%

'CHANGE LOG - Inception
'SSR Wednesday, July 06, 2011
'Custom Code 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1224
SurveyName = "FlexSubSurvey2012.asp"

'============================================================

'Alpine Theatre Project
'2012 Season Subscription

'DISCOUNT NAME: 2012Subscription

'DISCOUNT 1 (25% off):
'If at least 1 ticket is purchased to:
'Act #74823	Master Class
'Act #74824	Little Shop of Horrors
'Act #75208	Hedwig and the Angry Inch
'And in Tier 1 (Blue)

'DISCOUNT 2 (20% off)
'If at least 1 ticket is purchased to:
'Act #74823	Master Class
'Act #74824	Little Shop of Horrors
'Act #75208	Hedwig and the Angry Inch
'And in Tier 2 (Yellow)

'DISCOUNT 3 (10% off)
'If at least 1 ticket is purchased to:
'Act #74823	Master Class
'Act #74824	Little Shop of Horrors
'Act #75208	Hedwig and the Angry Inch
'And in Tier 3 (Green)

'ADDITIONAL DISCOUNT (20% off)
'If the patron has qualified for one of the discounts above, I would like them to be able to purchase tickets to Act #74830 Legends: Stephen Sondheim at a 20% discount. Is that possible to make that automatic as well?



'2011 New Season Subscription Discount
SeasonDiscountTypeNumber = 66191

ActCodeList = 74830

BonusPercentage = 20

SeasonDiscountType = 66191

'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

'============================================================
 
'Check to see if Order Number exists.
'Display management tabs for box office orders

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If	
Else
	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If	
End If

'============================================================

'Bypass this survey on Comp Orders

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call ApplyDiscount
 End Select
 

'==========================================================

Sub CheckSubscription
ErrorLog("Start CheckSubscription")

SeasonDiscountFound = False

'Check if there is a season discount code on the current order
SQLSeasonDiscount = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber IN (" & SeasonDiscountType & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " "
Set rsSeasonDiscount = OBJdbConnection.Execute(SQLSeasonDiscount)

If NOT rsSeasonDiscount.EOF Then 
   SeasonDiscountFound = True
End If

rsSeasonDiscount.Close
Set rsSeasonDiscount = nothing

ErrorLog("SeasonDiscountFound " & SeasonDiscountFound & "")


If  SeasonDiscountFound Then
    Call CheckBonusAct
Else
    Call Continue
End if


End Sub 'CheckCurrentOrder

'============================================================

Sub CheckBonusAct
ErrorLog("Start CheckBonusAct")

BonusActFound = False

SQLBonusActCheck = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE ActCode IN (" & ActCodeList  & ") AND OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " "
Set rsBonusActCheck = OBJdbConnection.Execute(SQLBonusActCheck)

    If Not rsBonusActCheck.EOF Then
        BonusActFound = True
    End If

rsBonusActCheck.Close
Set rsBonusActCheck = nothing

ErrorLog("BonusActFound " & BonusActFound & "")

'If discount found on past orders proceed to apply discount
'otherwise bypass restriction
If  BonusActFound Then 
	Call ProcessBonusDiscount
Else
	Call Continue
End If



End Sub 'CheckBonusAct

'============================================================

Sub ApplyDiscount

ErrorLog("start applying the discount")

FreeTicketCount = 0
ProductionList = Split(ActCodeList,",")
DiscountAmount = 10


'Determine the number of free tickets for each production
'--------------------------------------------------------
SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.DiscountTypeNumber = " & CleanNumeric(SeasonDiscountTypeNumber)
Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
SeasonTicketCount = (rsFreeTickets("TicketCount") / 3)
rsFreeTickets.Close
Set rsFreeTickets = nothing

ErrorLog("SeasonTicketCount " & SeasonTicketCount & "")


'Cycle through each production in the season
'Give discount to applicable tickets
'---------------------------------------------
For ActCd = lbound(ProductionList) to ubound(ProductionList)
    
    SQLDiscCheck = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
    Set rsDiscCheck = OBJdbConnection.Execute(SQLDiscCheck)
        
        If rsDiscCheck.EOF Then 
        
            SQLLineNo = "SELECT TOP(" & SeasonTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & ProductionList(ActCd) & " ORDER BY LineNumber DESC"
            Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        
            If Not rsLineNo.EOF Then 
                           
                Do While Not rsLineNo.EOF

                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & SeasonDiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                    rsLineNo.movenext
                    FreeTicketCount = FreeTicketCount + 1
                Loop

            End If
        
            rsLineNo.Close
            Set rsLineNo = Nothing
        
        End If
        
    rsDiscCheck.Close
    Set rsDiscCheck = Nothing        
        
    
Next

Call DBClose(OBJdbConnection)


Call Continue




End Sub 'ApplyDiscount

'============================================================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'============================================================

%>