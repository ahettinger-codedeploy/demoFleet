<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1133
SurveyName = "TicketFeeSurvey.asp"
BoxOfficeByPass = False

MaxSurchargeAmount = 24

'============================================================

'Chamber Music Society of Detroit

'We need a custom discount/survey for Chamber Music Society of Detroit.
'Parameters: Total per ticket fees per order shall be capped at $24.00
'Eligible ActCodes / EventCodes: All productions/events
'Offline/Online: Online and Offline
'Automatic/Code Entry: Discount should be applied automatically
'Expiration: No expiration
'Restrictions: N/A
'Stephen Wogoman
'2487379980
'steve.wogaman@chambermusicdetroit.org
'Client Description: We do put a cap of $24 on per-ticket fees for each order 

'============================================================
 
'Verify that Order Number exists - if not bounce back to default page
'Verify that User Number exists - if so display management tabs

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

'Bypass this survey for Fax, Mail, Phone and Box Office Orders

If Session("OrderTypeNumber") <> 1 Then
    If BoxOfficeByPass Then
	    Call Continue
    End If
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
 End Select   

'==========================================================
	
Sub SurveyForm

'----------------------------------
'Clear and Reset any Service Fees
'-----------------------------------

SQLFeeMax = "SELECT SUM(Surcharge) AS TotalFees FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & ""
Set rsFeeMax = OBJdbConnection.Execute(SQLFeeMax)
TotalSurchargeAmount = rsFeeMax("TotalFees")
rsFeeMax.Close
Set rsFeeMax = Nothing

If TotalSurchargeAmount  > MaxSurchargeAmount Then

    SQLLineNo = "SELECT LineNumber, Surcharge FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " "
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        
        NewSurcharge = rsLineNo("Surcharge")
            
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF
            
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Surcharge = " & NewSurcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                
                TotalSurcharge =  TotalSurcharge + NewSurcharge
                                        		
		        If NewSurcharge > MaxSurchargeAmount - TotalSurcharge Then
                    NewSurcharge = MaxSurchargeAmount - TotalSurcharge
                End If
                                             
            rsLineNo.movenext
            Loop
	    End If
		
	rsLineNo.Close
	Set rsLineNo = Nothing
        
End If


Call Continue

End Sub

'==========================================================

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
        
End Sub 'Continue

'==========================================================

%>