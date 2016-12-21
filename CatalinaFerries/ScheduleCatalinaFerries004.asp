<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

'=======================
'SetVariables
'=======================
If Not IsNumeric(Request("DepartureActCode")) Or Request("DepartureActCode") = "" Then
    DepartureActCode = 66492
    ReturnActCode = 66503
Else
    If Request("DepartureActCode") = 66492 Then
        DepartureActCode = 66492
        ReturnActCode = 66503
    Else
        DepartureActCode = 66503
        ReturnActCode = 66492
    End If        
End If 

If DepartureActCode = 66492 Then
    DepartureTime = "9:00 AM"
    ReturnTime = "5:00 PM"
Else
    DepartureTime = "5:00 PM"
    ReturnTime = "9:00 AM"
End If    

If Request("TripType") = "OneWay" Then
    TripType = "OneWay"
    OneWayChecked = "checked"
    RoundTripChecked = ""
Else
    TripType = "RoundTrip"
    OneWayChecked = ""
    RoundTripChecked = "checked"
End If   

If Request("DepartureDate") <> "" And IsDate(Request("DepartureDate")) Then
    DepartureDateDefault = CDate(FormatDateTime(Request("DepartureDate"), vbShortDate))

    SQLEvent = "SELECT Event.EventCode, COUNT(*) AS QtyAvail FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Event.ActCode = " & CLng(DepartureActCode) & " AND Event.EventDate = '" & DepartureDateDefault & " " & DepartureTime & "' AND Seat.StatusCode = 'A' GROUP BY Event.EventCode"
    Set rsEvent = OBJdbConnection.Execute(SQLEvent)

    If Not rsEvent.EOF Then
        DepartureEventCode = rsEvent("EventCode")
        DepartureQtyAvail = "<br />Available Seats: " & rsEvent("QtyAvail")
    Else
        DepartureEventCode = 0
        DepartureQtyAvail = "<br /><font color=""#990000""><b>Unavailable - Please select another date.</b></font>"
    End If
    
    rsEvent.Close
    Set rsEvent = nothing  

Else
    DepartureDateDefault = FormatDateTime(Now(), vbShortDate)
    DepartureEventCode = 0
    DepartureQtyAvail = ""
End If

If Request("ReturnDate") <> "" And IsDate(Request("ReturnDate")) Then
    ReturnDateDefault = CDate(FormatDateTime(Request("ReturnDate"), vbShortDate))

    SQLEvent = "SELECT Event.EventCode, COUNT(*) AS QtyAvail FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Event.ActCode = " & CLng(ReturnActCode) & " AND Event.EventDate = '" & ReturnDateDefault & " " & ReturnTime & "' AND Seat.StatusCode = 'A' GROUP BY Event.EventCode"
    Set rsEvent = OBJdbConnection.Execute(SQLEvent)

    If Not rsEvent.EOF Then
        ReturnEventCode = rsEvent("EventCode")
        ReturnQtyAvail = "<br />Available Seats: " & rsEvent("QtyAvail")
    Else
        ReturnEventCode = 0
        ReturnQtyAvail = "<br /><font color=""#990000""><b>Unavailable - Please select another date.</b></font>"
    End If
    
    rsEvent.Close
    Set rsEvent = nothing  
Else    
    ReturnDateDefault = FormatDateTime(Now(), vbShortDate)
    ReturnEventCode = 0
    ReturnQtyAvail = ""
End If

Dim arrTicketType(50, 3)
arrNum = 0


SQLTicketType = "SELECT SeatType.SeatTypeCode, SeatType.SeatType, Price.Price FROM SeatType (NOLOCK) INNER JOIN Price (NOLOCK) ON SeatType.SeatTypeCode = Price.SeatTypeCode INNER JOIN Event (NOLOCK) ON Price.EventCode = Event.EventCode WHERE Event.ActCode = " & DepartureActCode & " GROUP BY SeatType.SeatTypeCode, SeatType.SeatType, Price.Price ORDER BY Price.Price DESC"
Set rsTicketType = OBJdbConnection.Execute(SQLTicketType)

Do Until rsTicketType.EOF
    arrTicketType(arrNum, 0) = rsTicketType("SeatTypeCode")
    arrTicketType(arrNum, 1) = rsTicketType("SeatType")
    arrTicketType(arrNum, 2) = rsTicketType("Price")

    arrNum = arrNum + 1

    rsTicketType.MoveNext
Loop    

rsTicketType.Close
Set rsTicketType = nothing

If Request("SectionCode") <> "" Then
    SectionCode = Clean(Request("SectionCode"))
Else
    SectionCode = "GA"
End If    

'=======================
'End SetVariables
'=======================

'=======================
'Main Control
'=======================

If LCase(Request("btnSubmit")) = "add to cart" Then
    Call AddToCart
Else
    Call DisplayForm("")
End If    

'=======================
'End Main Control
'=======================

Sub DisplayForm(Message)
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>

<style type="text/css">

.CriteriaField
{
    font-family: Verdana, Arial, Helvetica;
    color: <%= FontColor %>;
    font-size: small;
    text-align: left;
}
.CriteriaFieldTitle
{
    font-family: Verdana, Arial, Helvetica;
    color: <%= TableCategoryBGColor %>;
    font-size: small;
    font-weight: bold;
}
</style>
</HEAD>

<%
If Message = "" Then
    Response.Write strBody & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""alert('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
End If
%>


<!--#INCLUDE virtual="TopNavInclude.asp" -->

<BR>

<%

If PopupCalendarFlag <> "Y" Then
%>
    <script src="/Javascript/ValidateDateInput.js" type="text/javascript" ></script>
    <script src="/Javascript/PopupCalendar.js" language="javascript" type="text/javascript"></script>
    <link href="/CSS/PopupCalendar.css" rel="stylesheet" type="text/css" />
<%
    PopupCalendarFlag = "Y"    
End If    
%>
<form action="ScheduleCatalinaFerries.asp" method="post">
<table width="700" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2">
        <fieldset style="width: 700px; text-align: center" class="CriteriaField">
        <legend class="CriteriaFieldTitle"><b>Trip Type</b></legend>
        <font size="2">
        <select name="DepartureActCode" onchange="this.form.submit();">
        
        <%
        SQLAct = "SELECT ActCode, Act FROM Act (NOLOCK) WHERE ActCode IN (66492, 66503) ORDER BY Act DESC"
        Set rsAct = OBJdbConnection.Execute(SQLAct)
        
        Do Until rsAct.EOF
            If CLng(Request("DepartureActCode")) = rsAct("ActCode") Then
                SelectedFlag = "SELECTED"
            Else
                SelectedFlag = ""
            End If                
            Response.Write "<option value=""" & rsAct("ActCode") & """ " & SelectedFlag & ">" & rsAct("Act") & "</option>" & vbCrLf
            rsAct.MoveNext
        Loop 
        
        rsAct.Close
        Set rsAct = nothing           
        %>
        
        
        </select>

        <input type="radio" name="TripType" value="RoundTrip" <%= RoundTripChecked %> onclick="this.form.submit();" />&nbsp;Round Trip
        <input type="radio" name="TripType" value="OneWay" <%= OneWayChecked %> onclick="this.form.submit();" />&nbsp;One Way

        </font>
        </fieldset>
    </td>
  </tr>
  <tr>
    <td>
        <fieldset style="width: 345px; text-align: center" class="CriteriaField">
            <legend class="CriteriaFieldTitle"><b>Departure</b></legend>
            <div align="left">
            <font size="2">
            
            <%
            SQLDepartureAct = "SELECT ActCode, Act FROM Act (NOLOCK) WHERE ActCode = " & DepartureActCode
            Set rsDepartureAct = OBJdbConnection.Execute(SQLDepartureAct)
            
            Response.Write "<b>" & rsDepartureAct("Act") & "</b><br />" & vbCrLf
            
            rsDepartureAct.Close
            Set rsDepartureAct = nothing               
            %>

            <b>Date: </b><input type="text" name="DepartureDate" id="DepartureDate" value="<%= DepartureDateDefault %>" style="width:125px" onchange="this.form.submit();" />&nbsp;<a href="#" onclick="displayCalendar(document.getElementById('DepartureDate'),'mm/dd/yyyy',document.getElementById('DepartureDate'))"><img src="/Images/calendar_icon.gif" title="Show Calendar" border="0" alt="Calendar" /></a>
            <b>Time: <%= DepartureTime %></b>
            <%= DepartureQtyAvail %>
            </font>
            </div>
        </fieldset>
    </td>
    <% If TripType <> "OneWay" Then %>
    <td align="right">
        <fieldset style="width: 345px; text-align: center" class="CriteriaField">
            <legend class="CriteriaFieldTitle"><b>Return</b></legend>
            <div align="left">
            <font size="2">

            <%
            SQLReturnAct = "SELECT ActCode, Act FROM Act (NOLOCK) WHERE ActCode = " & ReturnActCode
            Set rsReturnAct = OBJdbConnection.Execute(SQLReturnAct)
            
            Response.Write "<b>" & rsReturnAct("Act") & "</b><br />" & vbCrLf
            
            rsReturnAct.Close
            Set rsReturnAct = nothing    
            %>
                        
            <b>Date: </b><input type="text" name="ReturnDate" id="ReturnDate" value="<%= ReturnDateDefault %>" style="width:125px" onchange="this.form.submit();" />&nbsp;<a href="#" onclick="displayCalendar(document.getElementById('ReturnDate'),'mm/dd/yyyy',document.getElementById('ReturnDate'))"><img src="/Images/calendar_icon.gif" title="Show Calendar" border="0" alt="Calendar" /></a>
            <b>Time: <%= ReturnTime %></b>
            <%= ReturnQtyAvail %>
            </font>
            </div>
        </fieldset>
    </td>
    <% End If %>
  </tr>
  <tr>
    <td colspan="2">
        <fieldset style="width: 700px; text-align: center" class="CriteriaField">
            <legend class="CriteriaFieldTitle"><b>Ticket Quantities</b></legend>
            <table width="100%">  
              <tr>
                <td align="right" width="340">
                    <font size="2"><b><u>Ticket Type - Price</u></b></font>
                </td>
                <td align="left" width="340">
                    <font size="2"><b><u>Quantity</u></b></font>
                </td>
              </tr>
              <%
              
              For TicketTypeCount = 0 To arrNum - 1
                Price = arrTicketType(TicketTypeCount, 2)
                If Request("TripType") <> "OneWay" Then
                    Price = Price * 2                
                End If
                Response.Write "<tr><td align=""right""><font size=""2"">" & arrTicketType(TicketTypeCount, 1) & "- " & TripType & " - " & FormatCurrency(Price, 2) & "</font></td>"
                Response.Write "<td align=""left""><select name=""Quantity"">"

                If Request("Quantity") <> "" Then
                    If Not isNumeric(Request("Quantity")(TicketTypeCount + 1)) Then
                        QtySelected = "0"
                    Else
                        QtySelected = CleanNumeric(Request("Quantity")(TicketTypeCount + 1))
                    End If
                Else
                    QtySelected = 0
                End If             
                       
                For i= 0 To 20
                    If i = CInt(QtySelected) Then
                        SelectedFlag = "SELECTED"
                    Else
                        SelectedFlag = ""
                    End If    
                    Response.Write "<option value=""" & i & """ " & SelectedFlag & ">" & i & "</option>" & vbCrLf
                Next
                
                Response.Write "</select></td></tr>" & vbCrLf
              
              Next
              %>

             </table>
        </fieldset>
    </td>
  </tr>
  <tr>
    <td colspan="2">
        <fieldset style="width: 700px; text-align: center" class="CriteriaField">
            <legend class="CriteriaFieldTitle"><b>Promotional Code</b></legend>
            <table width="100%">  
              <tr>
                <td align="center"><font size="2"><b><u>Enter Promotional Code (optional):</u></b></font>
                <INPUT TYPE="text" NAME="DiscountCodeDisplay" SIZE="20"></td>
              </tr>
            </table>
        </fieldset>
    </td>
  </tr>
</table>  
 <input type="submit" name="btnSubmit" value="Add To Cart" />
 </form>
<br />

</form>
<%
jsValidateForm = jsValidateForm & "  if (formObj." & fldStartDate & ".value == """") {" & vbCrLf &_
"       alert(""Start Date is required. (mm/dd/yyyy)"");" & vbCrLf &_
"       formObj." & fldStartDate & ".focus();" & vbCrLf &_
"       return false;" & vbCrLf &_
"       }" & vbCrLf &_
"   if (formObj." & fldEndDate & ".value == """") {" & vbCrLf &_
"       alert(""End Date is required. (mm/dd/yyyy)"");" & vbCrLf &_
"       formObj." & fldEndDate & ".focus();" & vbCrLf &_
"       return false;" & vbCrLf &_
"       }" & vbCrLf &_

"   if (!(isValidDate(formObj." & fldStartDate & ".value))) {" & vbCrLf &_
"       alert(""Invalid Start Date. (mm/dd/yyyy)"");" & vbCrLf &_
"       formObj." & fldStartDate & ".focus();" & vbCrLf &_
"       return false;" & vbCrLf &_
"       }" & vbCrLf &_

"   if (!(isValidDate(formObj." & fldEndDate & ".value))) {" & vbCrLf &_
"       alert(""Invalid End Date. (mm/dd/yyyy)"");" & vbCrLf &_
"       formObj." & fldEndDate & ".focus();" & vbCrLf &_
"       return false;" & vbCrLf &_
"       }" & vbCrLf &_

"       var " & fldStartDate & " = new Date(formObj." & fldStartDate & ".value)" & vbCrLf &_
"       var " & fldEndDate & " = new Date(formObj." & fldEndDate & ".value)" & vbCrLf &_
"   if (" & fldStartDate & " > " & fldEndDate & ") {" & vbCrLf &_
"       alert('Start Date must be before End Date');" & vbCrLf &_
"       formObj." & fldStartDate & ".focus();" & vbCrLf &_
"       return false;" & vbCrLf &_
"       }" & vbCrLf

%>

</CENTER>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%
End Sub 'DisplayForm

'====================================

Sub AddToCart

'=====================
'Begin Form Validation
'=====================
If Not IsDate(DepartureDate) Then
    If IsDate(Request("DepartureDate")) Then
        DepartureDate = Clean(Request("DepartureDate"))
    Else
        Message = "Invalid Departure Date." & DepartureDate & "'"
        Call DisplayForm(Message)
        Exit Sub
    End If        
End If

DepartureDate = CDate(DepartureDate)

If CDate(DepartureDate) < CDate(FormatDateTime(Now(),2)) Then
    Message = "Please select a Departure Date in the future."
    Call DisplayForm(Message)
    Exit Sub
End If


If TripType = "RoundTrip" Then
    If Not IsDate(ReturnDate) Then
        If IsDate(Request("ReturnDate")) Then
            ReturnDate = Clean(Request("ReturnDate"))
        Else
            Message = "Invalid Departure Date." & ReturnDate & "'"
            Call DisplayForm(Message)
            Exit Sub
        End If        
    End If

    ReturnDate = CDate(ReturnDate)
End If


'=================================================================================
'One Way Ticket Error message: Please select a Return Date after Departure Date
'As there is no Return Date for one way tickets, we create one by 
'taking the departure date and adding 1 day to it.  
'=================================================================================

If Clean(Request("ReturnDate")) = "" Then
	ReturnDate = DateAdd("d", 1, CDate(Clean(Request("DepartureDate"))))	
End If


If ReturnDate < DepartureDate Then        
    Message = "Please select a valid return date."
    Call DisplayForm(Message)
    Exit Sub
End If


'Validate Requested dates belong to Org

Dim Seats(20)

For Each EventCode in Request("EventCode")
    If EventOnSale(CleanNumeric(EventCode)) = False Then
        Call DisplayForm("Event is not currently on sale.  Please contact the box office for more information.")
        Exit Sub
    End If
Next

'Qty Check
TotalQty = 0

For TicketTypeCount = 0 To arrNum - 1
    TotalQty = TotalQty + Fix(Request("Quantity")(TicketTypeCount + 1))
Next

If TotalQty = 0 Then
    Message = "Please select the number of tickets you wish to purchase."
    Call DisplayForm(Message)
    Exit Sub
End If

If DepartureEventCode = 0 Then 'Get the Departure EventCode
    DepartureDate = CDate(FormatDateTime(Request("DepartureDate"), vbShortDate))

    SQLEvent = "SELECT Event.EventCode, COUNT(*) AS QtyAvail FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Event.ActCode = " & CLng(DepartureActCode) & " AND Event.EventDate = '" & DepartureDate & " " & DepartureTime & "' AND Seat.StatusCode = 'A' GROUP BY Event.EventCode"
    Set rsEvent = OBJdbConnection.Execute(SQLEvent)

    If Not rsEvent.EOF Then
        DepartureEventCode = rsEvent("EventCode")
        DepartureQtyAvail = rsEvent("QtyAvail")
    Else
        Message = "Departure Not Found.  Please contact the box office for more information."
        Call DisplayForm(Message)
        Exit Sub
    End If
    
    rsEvent.Close
    Set rsEvent = nothing  

    If DepartureQtyAvail = 0 Then
        Message = "No tickets available for departure date selected.  Please contact the box office for more information."
        Call DisplayForm(Message)
        Exit Sub
    End If
End If

If TripType = "RoundTrip" And ReturnEventCode = 0 Then
    ReturnDate = CDate(FormatDateTime(Request("ReturnDate"), vbShortDate))

    SQLEvent = "SELECT Event.EventCode, COUNT(*) AS QtyAvail FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Event.ActCode = " & CLng(ReturnActCode) & " AND Event.EventDate = '" & ReturnDate & " " & ReturnTime & "' AND Seat.StatusCode = 'A' GROUP BY Event.EventCode"
    Set rsEvent = OBJdbConnection.Execute(SQLEvent)

    If Not rsEvent.EOF Then
        ReturnEventCode = rsEvent("EventCode")
        ReturnQtyAvail = rsEvent("QtyAvail")
    Else
        Message = "Return Not Found.  Please contact the box office for more information."
        Call DisplayForm(Message)
        Exit Sub
    End If
    
    rsEvent.Close
    Set rsEvent = nothing  

    If ReturnQtyAvail = 0 Then
        Message = "No tickets available for return date selected.  Please contact the box office for more information."
        Call DisplayForm(Message)
        Exit Sub
    End If
End If
  
Call CreateOrderHeader()

If Session("OrderNumber") = 0 Then
	Message = "There was a problem processing your request.  Please try again later."
	Session.Contents.Remove("OrderNumber")
	Call DisplayForm(Message)
	Exit Sub
End If
  
SQLAvailable = "SELECT Count(LineNumber) AS ExistingSeats FROM Orderline (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Orderline.ItemNumber = Seat.ItemNumber WHERE Orderline.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & DepartureEventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
Set rsAvailable = OBJdbConnection.Execute(SQLAvailable)
ExistingSeatCount = rsAvailable("ExistingSeats")
rsAvailable.Close
Set rsAvailable = Nothing
EventTicketCount = ExistingSeatCount + TotalQty

If EventTicketCount > MaxTickets Then 'Redisplay DisplayForm and Show Error
    Message = "The maximum number of tickets has been exceeded.  Please contact the box office for more information."
    Call DisplayForm(Message)
    Exit Sub
End If  

'=====================
'End Form Validation
'=====================

'=====================
'Begin Add To Cart
'=====================


'**********************
'Reserve the seats
'**********************

'===============================================================
'This is where another error message is showing up
'It was making an extra loop on the one way ticket orders.
'Made a change to loop twice for round trip and once for one way
'=============================================================== 

'**********************
'Reserve the seats
'**********************

'If RoundTrip loop through both EventCodes

Dim arrEventCodes(2)

'One Way Tickets the OptionCount = 1
'Round Trip Tickets the OptionCount = 0

arrEventCodes(0) = DepartureEventCode

If TripType = "RoundTrip" Then
    arrEventCodes(1) = ReturnEventCode
    OptionCount = 0
Else
    OptionCount = 1
End If 


For EventNum = 1 To (UBound(arrEventCodes) - OptionCount)

    EventCode = CleanNumeric(arrEventCodes(EventNum - 1))

    EventType = ""
    SQLEventType = "SELECT EventType FROM Event (NOLOCK) WHERE EventCode = " & EventCode
    Set rsEventType = OBJdbConnection.Execute(SQLEventType)
    If Not rsEventType.EOF Then
	    EventType = rsEventType("EventType")
    End If
    rsEventType.Close
    Set rsEventType = nothing

    Select Case EventType
	    Case "SubFixedEvent" 'Fixed Event Subscription

		    Set spEventReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
		    Set spEventReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
		    spEventReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
		    spEventReserveSeatsSubFixedEvent.Commandtext = "spEventReserveSeatsSubFixedEvent"
		    spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
		    spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
		    spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
		    spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SeatCount", 3, 1, , TotalQty) 'As Integer and Input
		    spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
		    spEventReserveSeatsSubFixedEvent.Execute
			
		    ReturnCode = spEventReserveSeatsSubFixedEvent.Parameters("ReturnCode")
		
	    Case Else

		    Set spEventReserveSeats = Server.Createobject("Adodb.Command")
		    Set spEventReserveSeats.ActiveConnection = OBJdbConnection
		    spEventReserveSeats.Commandtype = 4 ' Value for Stored Procedure
		    spEventReserveSeats.Commandtext = "spEventReserveSeats"
		    spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
		    spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
		    spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
		    spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SeatCount", 3, 1, , TotalQty) 'As Integer and Input
		    spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
		    spEventReserveSeats.Execute

		    ReturnCode = spEventReserveSeats.Parameters("ReturnCode")
			
    End Select

    Select Case ReturnCode
	    Case 0	'Stored Procedure executed properly.  Continue.
	    
            For TicketTypeCount = 0 To arrNum - 1

			    If IsNumeric(CleanNumeric(Request("Quantity")(TicketTypeCount + 1))) Then
			        TicketTypeQty = CleanNumeric(Request("Quantity")(TicketTypeCount + 1))
				    If TicketTypeQty > 0 Then
					    For x = 1 To TicketTypeQty
					    
					        'Get the Price and Fees for this Event and TicketType
						    SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & CleanNumeric(arrTicketType(TicketTypeCount, 0))
						    Set rsPrice = OBJdbConnection.Execute(SQLPrice)
							
						    Price = rsPrice("Price")
						    Surcharge = rsPrice("Surcharge")
							
						    rsPrice.Close
						    Set rsPrice = nothing
							
							'Update the OrderLine
						    SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & CleanNumeric(arrTicketType(TicketTypeCount, 0)) & ", Price = " & Price & ", Surcharge = " & Surcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
						    Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
					    Next
				    End If
			    End If
		    Next
		    
		    '==================================
	        'Apply Discounts if Applicable

	        DiscountApplied = "N"
	        If Clean(Request("DiscountCodeHidden")) <> "" Or Clean(Request("DiscountCodeDisplay")) <> "" Then 'If there is a discount on the order, run the pricing through the discount subroutine
		        SQLOrderLine = "SELECT Price, Surcharge, EventCode, LineNumber, SeatTypeCode, SectionCode, ItemType FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY Price DESC"
		        Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
        			
		        Do While Not rsOrderLine.EOF
        			
			        'JAI 11/21/3 - Run Discount Program for Hidden Code
			        If Clean(Request("DiscountCodeHidden")) <> "" Then
				        Price = rsOrderLine("Price")
				        Surcharge = rsOrderLine("Surcharge")
				        SeatTypeCode = rsOrderLine("SeatTypeCode")
				        DiscountAmount = 0
				        DiscountTypeNumber = 0
				        AppliedFlag = "N"

				        'REE 3/11/3 - Added SeatType to passed parameters.
				        Call Discount(Session("OrderNumber"), rsOrderLine("LineNumber"), rsOrderLine("EventCode"), Clean(Request("DiscountCodeHidden")), Price, Surcharge, SeatTypeCode, DiscountAmount, DiscountTypeNumber, AppliedFlag, rsOrderLine("SectionCode"), rsOrderLine("ItemType"))
			        End If

			        'JAI 11/21/3 - Run Discount Program for Displayed Code
			        If Clean(Request("DiscountCodeDisplay")) <> "" Then
				        Price = rsOrderLine("Price")
				        Surcharge = rsOrderLine("Surcharge")
				        SeatTypeCode = rsOrderLine("SeatTypeCode")
				        DiscountAmount = 0
				        DiscountTypeNumber = 0
				        AppliedFlag = "N"

				        'REE 3/11/3 - Added SeatType to passed parameters.
				        Call Discount(Session("OrderNumber"), rsOrderLine("LineNumber"), rsOrderLine("EventCode"), Clean(Request("DiscountCodeDisplay")), Price, Surcharge, SeatTypeCode, DiscountAmount, DiscountTypeNumber, AppliedFlag, rsOrderLine("SectionCode"), rsOrderLine("ItemType"))
			        End If
        			
			        If AppliedFlag = "Y" Then
				        DiscountApplied = "Y"
				        SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Price & ", Surcharge = " & Surcharge & ", Discount = " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & ", SeatTypeCode = " & SeatTypeCode & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber")
				        Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)
			        End If
		          rsOrderLine.MoveNext
		        Loop 
		        rsOrderLine.Close
		        Set rsOrderLine = nothing
	        End If        	
	        '==================================

	    Case 1	'SQL database error.
		    Message = "There was a problem processing your request.  Please try again later."
		    Call DisplayForm(Message)
		    Exit Sub
	    Case 2	'Seats not available.
		    If Clean(Request("Section")) = "" OR Clean(Request("Section")) = "GA" Then
			    SelectionType = "event"
		    Else
			    SelectionType = "section"
		    End If
		    If SeatCount = 1 Then
			    Message = "There are no tickets available online for this " & SelectionType & ".  Please check with the box office for availability."
		    Else
			    Message = "There are not " & SeatCount & " tickets available online for this " & SelectionType & ".  Please check with the box office for availability."
		    End If
		    Call DisplayForm(Message)
		    Exit Sub
	    Case Else
		    Message = "There was a problem processing your request.  Please try again later."
		    Call DisplayForm(Message)
		    Exit Sub
    End Select

Next

Call DBClose(OBJdbConnection)

'Response.Redirect("/ShoppingCart.asp")
Response.Redirect("https://" & Request.ServerVariables("SERVER_NAME") & "/ShipPrep.asp?CustomerNumber=" & Session("CustomerNumber") & "&OrderNumber=" & Session("OrderNumber") & "&VenueReference=" & VenueReference)


Call DisplayForm(Message)

'=====================
'End Add To Cart
'=====================


End Sub 'AddToCart

'==========================

Function EventOnSale(EventCode)

OnSale = 0
SaleStartDate = "1/1/01"
SaleEndDate = "1/1/01"

'Get Info from Event
SQLEventInfo = "SELECT SaleStartDate, SaleEndDate, OnSale From Event (NOLOCK) WHERE EventCode = " & CLng(EventCode)
Set rsEventInfo = OBJdbConnection.Execute(SQLEventInfo)
SaleStartDate = rsEventInfo("SaleStartDate")
SaleEndDate = rsEventInfo("SaleEndDate")
OnSale = rsEventInfo("OnSale")
rsEventInfo.Close
Set rsEventInfo = nothing

'Check Member Pre-Sale Info
If Session("MemberID") <> "" Then 'Get MemberStartDate
	SQLSaleStartDate = "SELECT MemberSaleStartDate FROM MemberSaleStartDate (NOLOCK) WHERE EventCode = " & EventCode & " AND OrganizationNumber = " & Session("MemberOrganizationNumber") & " AND MemberType = '" & Session("MemberType") & "' AND MemberSaleStartDate <= '" & Now & "'"
	Set rsSaleStartDate = OBJdbConnection.Execute(SQLSaleStartDate)
	If Not rsSaleStartDate.EOF Then
		If rsSaleStartDate("MemberSaleStartDate") < SaleStartDate Then
			SaleStartDate = rsSaleStartDate("MemberSaleStartDate")
		End If
	End If
	rsSaleStartDate.Close
	Set rsSaleStartDate = nothing
End If	

'Return Result
If SaleStartDate > Now() Or SaleEndDate <= Now() Or OnSale = 0  Then
    EventOnSale = False
Else
    EventOnSale = True    
End If

End Function 'EventOnSale

'==================
Function OwnerOrgNum(EventCode)

'Get Owner Org
SQLOrg = "SELECT OrganizationNumber FROM vOrgEvent (NOLOCK) WHERE EventCode = " & DepartureEventCode & " AND vOrgEvent.Owner = 1"
Set rsOrg = OBJdbConnection.Execute(SQLOrg)

If Not rsOrg.EOF Then
    OwnerOrgNum = rsOrg("OrganizationNumber")
Else
    OwnerOrgNum = 0
End If        

rsOrg.Close
Set rsOrg = nothing

End Function 'OwnerOrgNum
'==================
Function OrgOption(OrgNum, OptionName)

SQLOption = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(OrgNum) & " AND OptionName = '" & Clean(OptionName) & "'"
Set rsOption = OBJdbConnection.Execute(SQLOption)

If Not rsOption.EOF Then
    OrgOption = rsOption("OptionValue")
Else
    OrgOption = ""
End If

rsOption.Close
Set rsOption = nothing

End Function 'OrgOption
'======================

Sub CreateOrderHeader()

If Session("OrderNumber") <> "" Then 'There's an order number.  Check the status of the order.
	SQLOrderHeader = "SELECT StatusCode From OrderHeader WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)
	If rsOrderHeader("StatusCode") = "S" Then 'If the order has been completed, clear the Session("OrderNumber") and create a new one.
	    Session("OrderNumber") = "" 
	End If
	rsOrderHeader.Close
	Set rsOrderHeader = Nothing
End If

If Session("OrderNumber") = "" Then
    
	If Session("CustomerNumber") = "" Then
		CustomerNumber = 1
	Else
		CustomerNumber = Session("CustomerNumber")
	End If

	If Session("OrderTypeNumber") = "" Then
		OrderTypeNumber = 1
	Else
		OrderTypeNumber = Session("OrderTypeNumber")
	End If

	'Set Default Expiration to 30 minutes from now using TimeOffset.  UnReserve will catch it 30 minutes from now.
	OrderExpirationDate = DateAdd("n", 30 + (TimeOffset() * -1), Now())

	'Get TimeZone Offset for VenueOwner Organization
	SQLLocalOffset = "SELECT OrganizationOptions.OrganizationNumber, OptionValue AS LocalOffset FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & OwnerOrgNum(DepartureEventCode) & " AND OrganizationOptions.OptionName = 'TimeZoneOffset'"
	Set rsLocalOffset = OBJdbConnection.Execute(SQLLocalOffset)

	Call DBOpen(OBJdbConnection2)

	If Not rsLocalOffset.EOF Then 'Get Expiration Delay for VenueOwner Organization
		SQLExpirationDelay = "SELECT OptionValue As ExpirationDelay FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & rsLocalOffset("OrganizationNumber") & " AND OptionName = 'OrderExpirationDelay'"
		Set rsExpirationDelay = OBJdbConnection2.Execute(SQLExpirationDelay)
		
		If Not rsExpirationDelay.EOF Then 'Set the ExpirationDate based on Offset and Delay
			OrderExpirationDate = DateAdd("n", (rsLocalOffset("LocalOffset") - TimeOffset()) + rsExpirationDelay("ExpirationDelay"), Now())
		End If
		
		rsExpirationDelay.close
		Set rsExpirationDelay = nothing

	End If

	rsLocalOffset.close
	Set rsLocalOffset = nothing
	
    Call DBClose(OBJdbConnection2)
	
    'If IsNumeric(OrgOption(OwnerOrgNum(DepartureEventCode), "ExpirationDelay")) Then
    '    OrderExpirationDate = DateAdd("n", Now() + OrgOption(OwnerOrgNum(DepartureEventCode), "ExpirationDelay"))
    'Else         
	'    OrderExpirationDate = DateAdd("n", 30 + (TimeOffset() * -1), Now())
    'End If
    	
	Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
	Set spInsertorderHeader.ActiveConnection = OBJdbConnection
	spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
	spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , CustomerNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , 0) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, Request.ServerVariables("REMOTE_ADDR")) 'As Varchar and Input
	spInsertOrderHeader.Execute

	Session("OrderNumber") = spInsertOrderHeader.Parameters("OrderNumber")
	
End If

End Sub 'CreateOrderHeader

'=========================
Sub Discount(OrderNumber, LineNumber, EventCode, DiscountCode, Price, Surcharge, SeatTypeCode, DiscountAmount, DiscountTypeNumber, AppliedFlag, SectionCode, ItemType)

	'REE - 6/10/4 - Initialize variables
	NewPrice = Price
	Surcharge = Surcharge
	DiscountAmount = 0
	DiscountTypeNumber = 0
	AppliedFlag="N"
	
	'Check to see if this event code has discounts associated and that the code matches.
	'REE 6/10/4 - Added Discount Script to Selection
	'REE 11/3/8 - Added ability to use wild card discount codes to run custom scripts for code validation
	SQLDiscountEvents = "SELECT TOP 1 DiscountTypeNumber, DiscountCode, Hidden, OrganizationNumber, DiscountScript FROM (SELECT 1 AS SortOrder, DiscountEvents.DiscountTypeNumber, DiscountType.DiscountCode, Hidden, OrganizationNumber, DiscountType.DiscountScript FROM DiscountEvents (NOLOCK) INNER JOIN DiscountType (NOLOCK) ON DiscountEvents.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE EventCode = " & EventCode & " AND LOWER(DiscountCode) = '" & LCase(DiscountCode) & "' UNION SELECT 2 AS SortOrder, DiscountEvents.DiscountTypeNumber, DiscountType.DiscountCode, Hidden, OrganizationNumber, DiscountType.DiscountScript FROM DiscountEvents (NOLOCK) INNER JOIN DiscountType (NOLOCK) ON DiscountEvents.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE EventCode = " & EventCode & " AND DiscountCode = '*') AS Disc ORDER BY SortOrder"
'	SQLDiscountEvents = "SELECT DiscountEvents.DiscountTypeNumber, DiscountType.DiscountCode, Hidden, OrganizationNumber, DiscountType.DiscountScript FROM DiscountEvents (NOLOCK) INNER JOIN DiscountType (NOLOCK) ON DiscountEvents.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE EventCode = " & EventCode & " AND LOWER(DiscountCode) = '" & LCase(DiscountCode) & "'"
	Set rsDiscountEvents = OBJdbConnection.Execute(SQLDiscountEvents)
    If Not rsDiscountEvents.EOF Then
        'Assign the URL from DiscountType table
        URL = rsDiscountEvents("DiscountScript")
    End If
    
    If Session("OrderTypeNumber") = "" Then
		OrderTypeNumber = 1
	Else
		OrderTypeNumber = Session("OrderTypeNumber")
	End If

	If Not rsDiscountEvents.EOF And Not IsNull(URL) And URL <> "" Then 'There is a discount for this event and the code matches.

        '	JAI 3/12/7 - Upgraded to MSXML 6
	    Set objTransfer = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
	    objTransfer.Open "GET", URL & "&OrderNumber=" & OrderNumber & "&LineNumber=" & LineNumber & "&EventCode=" & EventCode & "&DiscountCode=" & DiscountCode & "&Price=" & Price & "&Surcharge=" & Surcharge & "&SeatTypeCode=" & SeatTypeCode & "&SectionCode=" & SectionCode & "&OrganizationNumber=" & rsDiscountEvents("OrganizationNumber") & "&DiscountTypeNumber=" & rsDiscountEvents("DiscountTypeNumber") & "&OrderTypeNumber=" & OrderTypeNumber, False
	    objTransfer.Send
	    DiscountPage = objTransfer.responseText
	    Set objTransfer = nothing
    			
	    NewPrice = Mid(DiscountPage, InStr(1, DiscountPage, "<NEWPRICE>") + 10, InStr(1, DiscountPage, "</NEWPRICE>") - InStr(1, DiscountPage, "<NEWPRICE>") - 10)
	    DiscountAmount = Mid(DiscountPage, InStr(1, DiscountPage, "<DISCOUNTAMOUNT>") + 16, InStr(1, DiscountPage, "</DISCOUNTAMOUNT>") - InStr(1, DiscountPage, "<DISCOUNTAMOUNT>") - 16)
	    Surcharge = Mid(DiscountPage, InStr(1, DiscountPage, "<SURCHARGE>") + 11, InStr(1, DiscountPage, "</SURCHARGE>") - InStr(1, DiscountPage, "<SURCHARGE>") - 11)
	    AppliedFlag = Mid(DiscountPage, InStr(1, DiscountPage, "<APPLIEDFLAG>") + 13, InStr(1, DiscountPage, "</APPLIEDFLAG>") - InStr(1, DiscountPage, "<APPLIEDFLAG>") - 13)
	    If InStr(1, DiscountPage, "<PRICE>") <> 0 Then
		    Price = Mid(DiscountPage, InStr(1, DiscountPage, "<PRICE>") + 7, InStr(1, DiscountPage, "</PRICE>") - InStr(1, DiscountPage, "<PRICE>") - 7)
	    End If
	    If InStr(1, DiscountPage, "<SEATTYPECODE>") <> 0 Then
		    SeatTypeCode = Mid(DiscountPage, InStr(1, DiscountPage, "<SEATTYPECODE>") + 14, InStr(1, DiscountPage, "</SEATTYPECODE>") - InStr(1, DiscountPage, "<SEATTYPECODE>") - 14)
	    End If
			
		'Calculate the discount amount	

		'REE 1/18/3 - Compare prices instead of NewPrice >= zero.
		If AppliedFlag = "Y" Then 'Calculate discount amount					
			DiscountAmount = Price - NewPrice
			DiscountTypeNumber = rsDiscountEvents("DiscountTypeNumber")
		Else 'Set discount amount to zero.
			DiscountAmount = 0
			DiscountTypeNumber = 0
		End If
		
		If rsDiscountEvents("Hidden") Then
			AppliedFlag = "Y"
		End If
				
	End If

	rsDiscountEvents.Close
	Set rsDiscountEvents = nothing
	
End Sub 'Discount

'=========================

 %>
