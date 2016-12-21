<%

'CHANGE LOG - Inception
'SSR 4/6/2011

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1091
SurveyFileName = "SeasonDiscount2011.asp"

'============================================================

'Visual Communiations
'Silvia’s Client
 
'Our friends at Visual Communications need a custom survey.  The current or past purchase of the following items entitles you to specific benefits.
 
'Please see below for the itemnumber and corresponding benefits that should be given automatically.

'VIP Events
'eventcode   eventdate  act
'----------- ---------- -------------------------------------------------------------------------------
'351974      2011-04-28 Opening Night Celebration - FAST FIVE - DGA 1 - 4/28 - 7PM
'353251      2011-05-05 CLOSING NIGHT CELEBRATION: LOVE IN DISGUISE (Lian ai tong gao) - CGV 1 - 5/5 - 7PM
'353253      2011-05-05 CLOSING NIGHT CELEBRATION: LOVE IN DISGUISE (Lian ai tong gao) - CGV 2 - 5/5 - 7PM
'353258 	 2011-05-05 CLOSING NIGHT CELEBRATION: LOVE IN DISGUISE (Lian ai tong gao) - CGV 3 - 5/5 - 7PM


'3260 VC SUPPORTER
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets


'3261 VC FRIEND 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to any event 
'Exclude: Opening Night, Closing Night


'3262 VC FILMMAKER 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'4 free tickets to any event. (exclude: Opening Night, Closing Night)


'3263 VC SPONSOR 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night
'6 free tickets to any event.
 

'3264 VC PATRON 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night
'8 free tickets to any event. (exclude: Opening Night, Closing Night)


'3265 VC BENEFACTOR
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night
'10 free tickets to any event (exclude: Opening Night, Closing Night)


'3266 VC DIRECTOR
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night

'============================================================

'Survey variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "asianfilmfestla"
End If

'============================================================

'Discount variables

DiscountTypeNumber = 56298

'100% Discount
SeriesPercentage = 1.0

'Membership Levels 
ItemNumberList = "3260,3261,3262,3263,3264,3265,3266"

'ClosingNight - VIP Events
CloseEventList = "353251, 353253, 353258"

'Opening Night - VIP Events
OpenEventList = "351974"


'============================================================

'Survey Start. 
'Check to see if Order Number exists.
'Skip Survey if Comp Order
'Request the form name and process requested action

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

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call MemberCheck
 End Select
 

OBJdbConnection.Close
Set OBJdbConnection = nothing

'==========================================================

Sub MemberCheck


'--------------------
'Duet Subscription
'--------------------

'Determine the original order date, for date based season subscriptions
'this allows re-opened orders to calculate based on the original order date

SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing

If CDate(OriginalDate) < CDate(ExpDate1) Then  

    'Count # of Acts on the order.
    SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList1 & ") AND OrderLine.SeatTypeCode = " & SeriesSeatType1 & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
    Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
    ActCount = rsActCount("ActCount")	
    rsActCount.Close
    Set rsActCount = nothing
    	
    If ActCount >= SeriesCount1 Then

        'Get the least number of tickets for any applicable ActCode
        SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList1 & ") AND OrderLine.SeatTypeCode = " & SeriesSeatType1 & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
        Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
        SingleSubscriptions = rsMinTicketCount("NumSubs")		
        rsMinTicketCount.Close
        Set rsMinTicketCount = nothing
    						
	    CountRemainder = (SingleSubscriptions Mod 2)	
		
        If CountRemainder = 0 Then
            NbrSubscriptions = SingleSubscriptions       
        Else
            NbrSubscriptions = (SingleSubscriptions - CountRemainder)
        End If	
    			
            If NbrSubscriptions >= 2 Then
    		
                'Get Act Code
                SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
                Set rsAct = OBJdbConnection.Execute(SQLAct)		
                ActCode = rsAct("ActCode")		
                rsAct.Close
                Set rsAct = nothing

                'Count # of existing seats which have discount applied for this act and seat type code
                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
                AppliedCount = rsDiscCount("LineCount")		
                rsDiscCount.Close
                Set rsDiscCount = nothing
            
	            If AppliedCount < NbrSubscriptions Then

                    NewPrice = Price - SeriesDiscount1	
                    
                    If NewPrice < 0 Then
                       NewPrice = 0
                    End If
                    
                    DiscountAmount = Price - NewPrice	
                    AppliedFlag = "Y"
                	    
                        
                    If Request("NewSurcharge") <> "" Then
                        Surcharge = NewSurcharge
                    Else
                       If Request("CalcServiceFee") <> "N" Then
                           Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
                       End If
                    End If	
            	        
	            End If
                
            End If	

        End If

End If

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