<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

Page = "Survey"
SurveyNumber = 1129
DiscountTypeNumber = 56967
SurveyClearDiscountTypeNumber = 37662

'==================================================

'2011 Camino Real Playhouse 


'Automatic Discount #1
'-------------------------------------------------

'CHOICE Season Subscription (4/18/2011)
'Discount given if patron buys 1 ticket to each of the 6 Acts

'Valid Productions
'63145   FOOLS
'63115   CHAOS AT THE CANNERY
'63110   INSPECTING CAROL
'63114   SHOWOFF! 2012
'63129   STEEL MAGNOLIAS
'63134   CHICAGO

'6 Act Series Pricing:
'Blue Section 
'Premium Seating - $165.00 per series ($27.50 per ticket)

'6 Act Series Pricing:
'Gold Section 
'Individual - $135.00 per series ($22.50 per ticket)



'Automatic Discount #2
'-------------------------------------------------

'IMPROV Season Subscription (10/12/2011)
'Discount given if patron buys 1 ticket for 2, 3 or 4 Acts

'Valid Productions
'71340	ADVANCED IMPROVISATION (JAN 18 to FEB 22)
'71343	ADVANCED IMPROVISATION (JUL 18 to AUG 22) 
'71341	ADVANCED IMPROVISATION (MAR 14 to APR 18)
'71342	ADVANCED IMPROVISATION (MAY 16 to JUN 20)
'71344	ADVANCED IMPROVISATION (SEPT 19 to OCT 24) 
'71345	INTRODUCTION TO IMPROVISATION (JAN 19 to FEB 23)
'71348	INTRODUCTION TO IMPROVISATION (JUL 19 to AUG 23) 
'71346	INTRODUCTION TO IMPROVISATION (MAR 15 to APR 19)
'71347	INTRODUCTION TO IMPROVISATION (MAY 17 to JUN 21)
'71349	INTRODUCTION TO IMPROVISATION (SEPT 20 to OCT 25) 

'2 Act Series Pricing
'$410.00 per series ($15 per ticket discount)

'3 Act Series Pricing
'$600 per series ($20 per ticket discount)

'4 Act Series Pricing
'$780 per series ($25 per ticket discount)


'==================================================

'Discount Variables

CHOICEActCodes = "63145,63115,63110,63114,63129,63134"
CHOICEActCodeList = Split(CHOICEActCodes,",")
ApplyCHOICE = True

CountAct = 0
colorCnt = 0

ColorList = "'BLUE','GOLD'"

'==================================================


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'==================================================

'Determine which Series Discount Applies

For i = lbound(CHOICEActCodeList) to ubound(CHOICEActCodeList)
    SQLQuantity = "SELECT COUNT(LineNumber) AS TixCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = " & CHOICEActCodeList(i)
    Set rsQuantity = OBJdbConnection.Execute(SQLQuantity)
    If rsQuantity("TixCount") = 6 Then
        ApplyCHOICE = True    
    End If
    rsQuantity.Close
    Set rsQuantity = Nothing
Next


'==================================================


If ApplyCHOICE Then

        colorCnt = 0
           
        'check if same color
        SQLColor = "select color from section (NOLOCK) inner join seat (NOLOCK) on seat.eventcode = section.eventcode and seat.sectioncode = section.sectioncode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode where Seat.ordernumber = " & Session("OrderNumber") & " and Event.actcode IN(" & CHOICEActCodes & ") GROUP BY COLOR"
        Set rsColor = OBJdbConnection.Execute(SQLColor)
        Do While Not rsColor.EOF
            Color = UCase(rsColor("Color"))
            colorCnt = colorCnt + 1
            rsColor.movenext
        Loop
        rsColor.Close
        Set rsColor = Nothing
        	
        If colorCnt = 1 Then
        	
            If Color = "BLUE" Then
                NewPrice = 27.50
            Else
                NewPrice = 22.50
            End If
        	    
            SQLUpdateQty = "SELECT ActCode, COUNT(ActCode) AS Qty FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.actcode IN(" & CHOICEActCodes & ") GROUP BY ActCode ORDER BY Qty"
            Set rsUpdateQty = OBJdbConnection.Execute(SQLUpdateQty)
            MinTix = rsUpdateQty("Qty")
            rsUpdateQty.Close
            Set rsUpdateQty = Nothing
        	    
            For i = lbound(CHOICEActCodeList) to ubound(CHOICEActCodeList)
                SQLLineNo = "SELECT TOP(" & MinTix & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & CHOICEActCodeList(i) & " ORDER BY LineNumber DESC"
                Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
                
                Do While Not rsLineNo.EOF
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price - " & NewPrice & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                    rsLineNo.movenext
                Loop
                
                rsLineNo.Close
                Set rsLineNo = Nothing
            Next	
            
        Else 

            ErrorLog("Camino Real Playhouse - Reverse SurveyClear Discount: " & SurveyClearDiscountTypeNumber & " for OrderNumber: " & Session("OrderNumber"))
            SQLNoDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & SurveyClearDiscountTypeNumber
            Set rsNoDiscount = OBJdbConnection.Execute(SQLNoDiscount)
            
        End If

End If

Call Continue

'==================================================

Sub Continue
				
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    		
End Sub

'==================================================

%>