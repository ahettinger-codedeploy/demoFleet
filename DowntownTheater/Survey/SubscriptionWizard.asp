<%


'CHANGE LOG - Update
'SSR 5/11/2011
'Updated query so that only events which are on sale and are for current for future dates
'Added check to force patron to select all the required events for the season subscription


'CHANGE LOG - Update
'SSR 5/10/2011
'Multiple season subscription problem resolved. Due to the OfferQuantity value not passed correctly.
'Survey allowing event selection on events which are not on sale or which are past dates.


'CHANGE LOG - Update
'SSR 5/9/2011
'ShipCode issue fixed. The system was passing the shipcode before my query in Management, but it was passed after in PL.
'Hard coded a shipcode of "0" to my query.  This is then later updated by the system with the correct shipcode.
'However, error 500 generated if more than 1 season subscription is selected


'CHANGE LOG - Update
'SSR 5/7/2011
'Works -- horray!!!  But for some reason it only works in Management.
'Orders entered into on the Private Label page cause an error 500


'CHANGE LOG - Update
'SSR 5/6/2011
'Works but now the both the original voucher tickets AND
'the actual event tickets are now stuck on the order. 


'CHANGE LOG - Update
'SSR 4/27/2011
'Works but leaves the original voucher tickets in sold status 


'CHANGE LOG - Inception
'SSR 3/29/2011
'Subscription Reminder. 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================

Page = "Survey"
SurveyNumber = 857
SurveyName = "SubscriptionWizard.asp"

'========================================

'Downtown Theater
'3 Act Season Subscription
'--------------------------------

'Includes 1 ticket to each act:
'54885  Little Shop of Horrors
'54886  Chicago
'55462  Grease

'========================================
'Subscription Variables

'Location of survey folder
ClientDirectory = "DowntownTheater"

'Subscription EventCode
SeriesEventCode = "300475"

'Subscription SectionCode
SeriesSectionCode = "GA"

SeriesActCount = 3

DIM SeriesActCode(4)
SeriesActCode(1) = 64886 'Little Shop of Horrors
SeriesActCode(2) = 54886 'Chicago
SeriesActCode(3) = 55462 'Grease

DIM VoucherCode(4)
VoucherCode(1) = 296193  'Subscription Voucher #1 
VoucherCode(2) = 296192  'Subscription Voucher #2 
VoucherCode(3) = 296189  'Subscription Voucher #3 

'Missing event trigger
MissingEventCode = "N"

'========================================

'Survey Messages


'Event selection instructions for patrons
SelectionInstructions = "Please select your choice of event date for this production:"

'Error Message: No Tickets Available 
UnavailableMessage = "<b>Sorry</b><br />There are no seats available for<br /><i><%=rsProduction("Act")%></i>"

'Error Message: Sold Out
SoldOutMessage = "<b>Sorry!</b><br /><br>There are no seats available for this production"

'Error Message: Event need to be selected
MissingEventsMessage = "<b>You did not select any events.</b><br /><br />Please be sure to choose one performance for each production"

'Error Trigger - triggers the missing events error message
MissingEventCode = "N"


'========================================

'Check to see if Order Number exists.  
'If not, redirect to Home Page.

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

'=======================================

' First determine that the season subscription event is in the shopping cart

OfferCount = 0
OfferTicketCount = 0
 
SQLRequiredTicketCount = "SELECT Count(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & SeriesEventCode & ""
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
RequiredTicketCount = rsRequiredTicketCount("TicketCount")
    
    If RequiredTicketCount => 1 Then
    
        ' Second determine that there are enough available seats in the individual events 
        
        For a = 1 To SeriesActCount
    
        SQLOfferTicketCount = "SELECT Count(ItemNumber) AS TicketCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.ActCode = " & SeriesActCode(a) & " AND GetDate() < (EventDate) AND Event.OnSale = 'True' AND Seat.SectionCode IN ('" & SeriesSectionCode & "') AND Seat.StatusCode = 'A'"
        Set rsOfferTicketCount = OBJdbConnection.Execute(SQLOfferTicketCount)
        OfferTicketCount = rsOfferTicketCount("TicketCount")   
        
        ErrorLog("OfferTicketCount" & OfferTicketCount & "")
               
            If OfferTicketCount => RequiredTicketCount Then      
                OfferCount = OfferCount + RequiredTicketCount            
            End If    
                
	    rsOfferTicketCount.Close
	    Set rsOfferTicketCount = nothing
	    
	    Next
	    
	End If
	
rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing

' If there are not enough seats left to fill the series, display a warning page

If OfferCount < (RequiredTicketCount * SeriesActCount) Then
    Call WarningPage
' If there is at least 1 available seat in each of the acts to cover all the season tickets, please go on and sell it!
Else
    Call SurveyForm
End If
    

'=======================================
	
Sub SurveyForm

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Season Subscription</title>

<%

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = ClientDirectory
End If

%>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 600px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: center;
}
#rounded-corner td.data-left
{
	padding-left: 1px;
	padding-right: 1px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: right;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: left;
}
#rounded-corner h2
{
	color: <%=TableCategoryFontColor%>
}	
</style>


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<%

Const NUMBER_OF_PAGES = 4

Dim intPreviousPage
Dim intCurrentPage
Dim strItem

' What page did we come from?
intPreviousPage = Request.Form("page")

' What page are we on?
Select Case Request.Form("navigate")
	Case "< Back"
		intCurrentPage = intPreviousPage - 1
	Case "Next >"
		intCurrentPage = intPreviousPage + 1
	Case Else
		' So either it's our first run of the page and we're on page 1...
		' Or the form is complete and pages are unimportant... 
		' Because we're about to process our first subscription!
		intCurrentPage = 1
End Select

' If we're not yet reached the finish, display the form.
If Request.Form("navigate") <> "Finish >" Then 

    %>
	<form action="<%= Request.ServerVariables("URL") %>" method="post">
	<input type="hidden" name="page" value="<%= intCurrentPage %>">
    <%
	
	' We'll take the data and store it in little hidden form fields. Brilliant, isn't it??
	' Each field is prefixed with a number so that we know what page it belongs to.	
	
	
	For Each strItem In Request.Form
        ' Ignore the "page" and "navigate" button form fields.
		If strItem <> "page" And strItem <> "navigate" Then

			If CInt(Left(strItem, 1)) <> intCurrentPage Then
				Response.Write("<input type=""hidden"" name=""" & strItem & """" _
				& " value=""" & Request.Form(strItem) & """>" & vbCrLf)
			End If
			
		End If
	Next
	
	Select Case intCurrentPage
	
		Case 1, 2, 3
		'Production #1, #2, #3
		'----------------		
        SQLProduction = "SELECT Act, Comments FROM Act (NOLOCK) WHERE Act.ActCode = " & SeriesActCode(intCurrentPage) & ""
        Set rsProduction = OBJdbConnection.Execute(SQLProduction)                
%>
        <br />
        <br />
        <br />
        <table id="rounded-corner" summary="surveypage" border="0">
        <thead>
            <tr>
                <th scope="col" class="category-left"></th>
                <th scope="col" class="category" colspan="2"><b><%=rsProduction("Act")%></b></th>
                <th scope="col" class="category-right"></th>
            </tr>        
        </thead>
            <tr><td class="data" colspan="4"><%=rsProduction("Comments")%><br /><%=SelectionInstructions%></td></tr>
<%
        
        SQLEventOffer = "SELECT DISTINCT Event.EventCode, Event.EventDate FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.ActCode = " & SeriesActCode(intCurrentPage) & " AND GetDate() < (EventDate) AND Event.OnSale = 'True' AND Seat.SectionCode IN ('" & SeriesSectionCode & "') AND Seat.StatusCode = 'A'"
        Set rsEventOffer = OBJdbConnection.Execute(SQLEventOffer)         
            
            If Not rsEventOffer.EOF Then
                Do While Not rsEventOffer.EOF
%>                
                <!-- Display all events for this particular act which are: (1) current or future date, (2) on sale and (3) have available seats -->
                <tr><td class="data" width="25%">&nbsp;</td><td class="data-left"><input type="radio" name="<%=intCurrentPage%>_eventcode" value="<%=rsEventOffer("EventCode")%>" If Request.Form("<%=intCurrentPage%>_eventcode") = "<%=rsEventOffer("EventCode")%>" Then Response.Write("checked=""checked""")></td><td class="data-right"><%=FormatDateTime(rsEventOffer("EventDate"),vbLongDate)%>&nbsp;at&nbsp;<%=Left(FormatDateTime(rsEventOffer("EventDate"),vbLongTime),Len(FormatDateTime(rsEventOffer("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEventOffer("EventDate"),vbLongTime),3)%></td><td class="data" width="25%">&nbsp;</td></tr>
<%      
                rsEventOffer.MoveNext
                Loop
                
           Else
%>                
                <!-- There are no available seats for this particular act  -->
                <tr><td class="data" colspan="4"><br /><br /></br><br /><br /></td></tr>
<% 
           End If
                
        rsProduction.Close
        Set rsProduction = Nothing  
        
        rsEventOffer.Close
        Set rsEventOffer = Nothing
 %>       
            <tr>
                <td class="footer-left">&nbsp;</td>
                <td class="footer" colspan="2">&nbsp;</td>
                <td class="footer-right">&nbsp;</td>
            </tr> 
<%
	
		
		Case 4
		'Review Page
		'-----------        
        'Verify that all events have been selected  
        
        If Request.Form("1_eventcode") = "" OR Request.Form("1_eventcode") = NULL Then
            MissingEventCode = "Y"
        End If
        
        If Request.Form("2_eventcode") = "" OR Request.Form("2_eventcode") = NULL Then
            MissingEventCode = "Y"
        End If
        
        If Request.Form("3_eventcode") = "" OR Request.Form("3_eventcode") = NULL Then
            MissingEventCode = "Y"
        End If
        
        If MissingEventCode = "N" Then
%>        
            <br />
            <br />
            <br />            
            <table id="rounded-corner" summary="surveypage" border="0">
            <thead>
	            <tr>
    	            <th scope="col" class="category-left"></th>
    	            <th scope="col" class="category" colspan="2"><b><h3>Congratulations!</h3>You have selected the following events:</b></th>
    	            <th scope="col" class="category-right"></th>
                </tr>        
            </thead>
            <tbody>

             <%
             
            For IndexNumber = 1 To SeriesActCount

                If Clean(Request(IndexNumber & "_eventcode")) <> "" Then
                    For Each Item IN Request(IndexNumber & "_eventcode")
                        If Item <> "" Then  
                        
                        EventCode = Clean(Request(IndexNumber & "_eventcode"))

                                SQLPackages = "SELECT Act.Act, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & Eventcode & ""
                                Set rsPackages = OBJdbConnection.Execute(SQLPackages)
                                 %>
                                 <tr><td class="data" colspan="4"><br /><b><%=rsPackages("Act")%></b><br /><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%><br /><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></td></tr>
                                 <%
                                rsPackages.Close
                                Set rsPackages = Nothing
                                       
                        End If
                    Next
                End If
                
            Next

            %>    
             <tr>
    	        <td class="footer-left">&nbsp;</td>
    	        <td class="footer" colspan="2">&nbsp;</td>
    	        <td class="footer-right">&nbsp;</td>
    	    </tr>        
<%
	       Else
%> 	       
	        <br />
            <br />
            <br />    
	        <table id="rounded-corner" summary="surveypage">
            <thead>
	            <tr>
	                <th scope="col" class="category-left"></th>
	                <th scope="col" class="category" colspan="2">Sorry</th>
	                <th scope="col" class="category-right"></th>
                </tr>        
            </thead>
            <tbody>
	            <tr>
	                <td class="data" colspan="4"><br /><%=MissingEventsMessage%><br /></td>
	            </tr>
                <tr>
    	            <td class="footer-left">&nbsp;</td>
    	            <td class="footer" colspan="2">&nbsp;</td>
    	            <td class="footer-right">&nbsp;</td>
    	        </tr>
<%     
         End If 
	
	Case Else
			'If this error is displayed something has gone wrong. Very wrong!
			Response.Write("Error: Bad Page Number!")
	End Select
%>
    <tr >
    <td align="center" colspan="4">
	<br />
	<!-- Display form navigation buttons. -->

	<!-- If all eventcodes have been selected, display navigation buttons -->
	<% If MissingEventCode = "N" Then %>	
	
	        <% If intCurrentPage > 1 Then %>
		        <input type="submit" name="navigate" value="&lt; Back">
	        <% End If %>	        	        
    	
	        <% If intCurrentPage < NUMBER_OF_PAGES Then %>
		        &nbsp;&nbsp;&nbsp;<input type="submit" name="navigate" value="Next &gt;">
	        <% Else %>
		        &nbsp;&nbsp;&nbsp;<input type="submit" name="navigate" value="Finish &gt;">
	        <% End If %>	    
	<!-- If missing eventcodes, send patron back to the begining to choose again -->
	<% Else %>
	
		    <% intCurrentPage = 0 %>
		    <input type="submit" name="navigate" value="Start">
	<% End If %>
	
</form>
</td>
</tr>
</table>
<%
Else
	' This is where we now submit the collected eventcode data to be processed into the actual order.
	' It's like making sausage.
    Call ProcessTickets
    Exit Sub
End If


%>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' SurveyForm

'=======================================
	
Sub WarningPage

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Season Subscription</title>

<%

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = ClientDirectory
End If

%>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 600px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: center;
}
#rounded-corner td.data-left
{
	padding-left: 1px;
	padding-right: 1px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: right;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: left;
}
#rounded-corner h2
{
	color: <%=TableCategoryFontColor%>
}	
</style>


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<%

Session("SurveyComplete") = Session("OrderNumber")

%>
<br />
<br />
<br />    
<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
        <th scope="col" class="category-left"></th>
        <th scope="col" class="category" colspan="2">SORRY</th>
        <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data" colspan="4"><br /></Br><b>There is an insufficent number of event<Br />tickets available for sale online.</b><BR /><br />Please contact the box office.<br /></td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr>
    <td colspan="4" align="center"><br /><br />
     <%

    If Session("UserNumber") = "" Then
	    Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
    Else
	    Response.Write "<FORM ACTION=""/Management/EventSelection.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
    End If

        Response.Write "<INPUT TYPE=""submit"" VALUE=""OK"" id=1 name=1 Style=""width: 50px""></FORM></CENTER>" & vbCrLf

    %>
</tr>
</td>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' SurveyForm

'======================================

Sub ProcessTickets

If Session("OrderNumber") <> "" Then

SQLRequiredCheck = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & SeriesEventCode & ""
Set rsRequiredCheck = OBJdbConnection.Execute(SQLRequiredCheck)	    	
    If Not rsRequiredCheck.EOF Then	    
         OfferQuantity = rsRequiredCheck("TicketCount")
    End If
rsRequiredCheck.Close
Set rsRequiredCheck = nothing


'Determine the SeatTypeCode
SeatTypeCode = "16"

For IndexNumber = 1 To 3

    If Clean(Request(IndexNumber & "_eventcode")) <> "" Then
        For Each Item IN Request(IndexNumber & "_eventcode")
            If Item <> "" Then                
            	Select Case IndexNumber
	                Case 1	
	                    VoucherEventCode = VoucherCode(1) 
	                Case 2
                        VoucherEventCode = VoucherCode(2)
                    Case 3
                        VoucherEventCode = VoucherCode(3)
                End Select                    
                Call AddToCart((Request(IndexNumber & "_eventcode")), SeriesSectionCode, OfferQuantity, SeatTypeCode, VoucherEventCode)              
            End If
        Next
    End If
    
Next
		
End If
       
Call Continue

End Sub

'======================================

Sub AddToCart(EventCode, SectionCode, OfferQuantity, SeatTypeCode, VoucherEventCode)

If Clean(SectionCode) <> "" Then
	SectionCode = Clean(SectionCode)
Else
	SectionCode = "GA"
End If

If Session("OrderNumber") <> "" Then 'There's an order number.  Check the status of the order.
	SQLOrderHeader = "SELECT StatusCode From OrderHeader WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)
	If rsOrderHeader("StatusCode") = "S" Then Session("OrderNumber") = "" 'If the order has been completed, clear the Session("OrderNumber") and create a new one.
	rsOrderHeader.Close
	Set rsOrderHeader = Nothing
End If

'Create an Order Header if Necessary
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

	'REE 11/24/2 - Added ExpirationDate to OrderHeader

	'Set Default Expiration to 30 minutes from now using TimeOffset.  UnReserve will catch it 30 minutes from now.
	OrderExpirationDate = DateAdd("n", 30 + (TimeOffset() * -1), Now())

	'Get TimeZone Offset for VenueOwner Organization
	SQLLocalOffset = "SELECT OrganizationOptions.OrganizationNumber, OptionValue AS LocalOffset FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationOptions (NOLOCK) ON OrganizationVenue.OrganizationNumber = OrganizationOptions.OrganizationNumber WHERE Event.EventCode = " & EventCode & " AND OrganizationVenue.Owner <> 0 AND OrganizationOptions.OptionName = 'TimeZoneOffset'"
	Set rsLocalOffset = OBJdbConnection.Execute(SQLLocalOffset)

	'JAI 4/12/5 - Open OBJdbConnection2 for Loop reads.
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
	
	'JAI 4/12/5 - Close OBJdbConnection2
	Call DBClose(OBJdbConnection2)
	rsLocalOffset.close
	Set rsLocalOffset = nothing
	
	'REE 5/29/3 - Added the user IP Address
	IPAddress = Request.ServerVariables("REMOTE_ADDR")

	Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
	Set spInsertorderHeader.ActiveConnection = OBJdbConnection
	spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
	spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , CustomerNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , 0) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, IPAddress) 'As Varchar and Input
	spInsertOrderHeader.Execute

	Session("OrderNumber") = spInsertOrderHeader.Parameters("OrderNumber")

	If Session("OrderNumber") = 0 Then
		Message = "There was a problem processing your request.  Please try again later."
		ErrorLog(Message)
		Call AddOnSurvey
		Exit Sub
	End If

End If

'**********************
'Reserve the seats
'**********************
'REE 11/29/6 - Modified to include SubFixedEvent in count
SQLAvailable = "SELECT Count(LineNumber) AS ExistingSeats FROM Orderline (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Orderline.ItemNumber = Seat.ItemNumber WHERE Orderline.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & EventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
Set rsAvailable = OBJdbConnection.Execute(SQLAvailable)
ExistingSeatCount = rsAvailable("ExistingSeats")
rsAvailable.Close
Set rsAvailable = Nothing
TotalSeatCount = ExistingSeatCount + OfferQuantity

If TotalSeatCount <= MaxTickets Then 'Process Request

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
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SeatCount", 3, 1, , OfferQuantity) 'As Integer and Input
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
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SeatCount", 3, 1, , OfferQuantity) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeats.Execute

			ReturnCode = spEventReserveSeats.Parameters("ReturnCode")
			
	End Select

	Select Case ReturnCode
		Case 0	'Stored Procedure executed properly.  Continue.
		
                    For i = 1 To OfferQuantity    			
    			
			         'Add the new subscription ticket to the order
                     '----------------------------------------------     
                        
                        SQLOldSeat = "SELECT OrderLine.LineNumber, Seat.ItemNumber, OrderLine.OrderNumber, Event.EventCode, Seat.SectionCode, OrderLine.SeatTypeCode, OrderLine.ParentLineNumber, OrderLine.ShipCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) On OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " and Event.EventCode = " & VoucherEventCode & ""
                        Set rsOldSeat = OBJdbConnection.Execute(SQLOldSeat)                             
                                                
                            Do While Not rsOldSeat.EOF                 		
            				    
				                'Removes the placeholder voucher ticket from the orderline
                                SQLDeleteOldSeat = "DELETE FROM OrderLine WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOldSeat("LineNumber") & " AND OrderLine.ItemNumber = " & rsOldSeat("ItemNumber") & ""
                                Set rsDeleteOldSeat = OBJdbConnection.Execute(SQLDeleteOldSeat)	
                                
                                'Update voucher ticket status in seat table
                                SQLUpdateStatus = "UPDATE Seat WITH (ROWLOCK) SET StatusCode = COALESCE (SSL3.StatusCode, 'A'), StatusDate = GETDATE(), OrderNumber = 0 FROM Seat WITH (ROWLOCK) LEFT OUTER JOIN (SELECT SSL1.ItemNumber, SSL1.StatusCode FROM SeatStatusLog SSL1 (NOLOCK) INNER JOIN (SELECT ItemNumber, MAX(LogNumber) AS LogNumber FROM  SeatStatusLog (NOLOCK) WHERE ItemNumber = " & rsOldSeat("ItemNumber") & " GROUP BY ItemNumber) SSL2 ON SSL1.LogNumber = SSL2.LogNumber) SSL3 ON Seat.ItemNumber = SSL3.ItemNumber WHERE Seat.ItemNumber = " & rsOldSeat("ItemNumber") & " AND OrderNumber = " & Session("OrderNumber")
                                Set rsUpdateStatus = OBJdbConnection.Execute(SQLUpdateStatus)
                                
                                'In management the shipcode is passed at this point. PL however has not  yet passed the shipcode. Solution? Hardcoded a shipcode of 0.
                                'The system will update and overwrite this placeholder shipcode with the shipcode from the parent event.
                                
                                ShippingMethod = 0                    
                                
                                'Adds the new event ticket to the orderline as a subscription ticket
				                 SQLUpdateNewSeat = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & rsOldSeat("SeatTypeCode") & ", Price = 0, Surcharge = 0, Discount = 0, DiscountTypeNumber = 37, ItemType = 'SubSeat', ParentLineNumber = " & rsOldSeat("ParentLineNumber") & ", ShipCode = " & ShippingMethod & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat'))"
				                 Set rsUpdateNewSeat = OBJdbConnection.Execute(SQLUpdateNewSeat)
        				
                            rsOldSeat.movenext   
                            Loop
                            
                        rsOldSeat.Close
                        Set rsOldSeat = Nothing
                        
                        
                     'Remove the placeholder voucher ticket from the order
                     '-----------------------------------------------------
                        SQLOrderLines = "SELECT OrderLine.LineNumber, Seat.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) On OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " and Event.EventCode = " & VoucherEventCode & ""
                        Set rsOrderLines = OBJdbConnection.Execute(SQLOrderLines)
                       
                            Do While Not rsOrderLines.EOF
                                                        
                                'Delete child orderlines
                                SQLDeleteLines = "DELETE FROM OrderLine WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLines("LineNumber")
                                Set rsDeleteLines = OBJdbConnection.Execute(SQLDeleteLines)
                                rsOrderLines.movenext
                        
                            rsOrderLines.movenext 
                            Loop
                        
                        rsOrderLines.Close
                        Set rsOrderLines = Nothing
    				
			    Next				
			
		Case Else
		
			Call ProcessTickets
			
	End Select
	
End If

End Sub

'========================

Sub Continue
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
End Sub 'Continue

'========================

%>

