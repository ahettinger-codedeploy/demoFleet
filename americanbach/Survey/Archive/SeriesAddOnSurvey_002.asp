<%

'CHANGE LOG - Inception
'SSR 3/31/2011

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


'============================================================

Page = "Survey"
SurveyNumber = 999
SurveyFileName = "SeriesAddOnSurvey.asp"

'============================================================

'American Bach Soloists
'Subscription Event Add On

'-----------------------------------
'EventCode      Subscription Name
'354183         FESTIVAL 2011 CHAMBER & MASTERWORKS SERIES 
'354180         FESTIVAL 2011 SEASON PASS (7 concerts)


'Patron Must Choose One:
'EventCode      Date & Time                 Production Name
'353368         Sunday 7/17/2011 2:00 PM    Bach: Mass in B Minor (Masterworks Series 2011)
'353414         Saturday 7/23/2011 2:00 PM  Bach: Mass in B Minor (Masterworks Series 2011)

'===============================================
'Survey Variables

SeriesEventCount = 2

DIM SeriesEventCode(2)
SeriesEventCode(1) = "354183"
SeriesEventCode(2) = "354180"

DIM SeriesName(2)
SeriesName(1) = "FESTIVAL 2011 CHAMBER & MASTERWORKS SERIES SUBSCRIPTION (4 concerts)"
SeriesName(2) = "FESTIVAL 2011 SEASON PASS (7 concerts)"

ActCodeList = "62533"
OfferSection = "GA"

'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.

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

'===============================================

'Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#ffffff"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "#e9e9e9"
    TableFontColor = "blue"
    ClientFolder= "Tix"
Else
    ClientFolder = "americanbach"
End If

'===============================================

If Request("FormName") = "Removal" Then
    Call RemoveChild
Else
    Call EventList(Message)
End If

'===============================================

Sub EventList(Message)

'check for subscription event 1
SQLSubCheck = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & SeriesEventCode(1) & ""
Set rsSubCheck = OBJdbConnection.Execute(SQLSubCheck)
If NOT rsSubCheck.EOF Then
    SubscriptionName = SeriesName(1)
End If
rsSubCheck.Close
Set rsSubCheck = Nothing

'check for subscription event 2
SQLSubCheck = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & SeriesEventCode(2) & ""
Set rsSubCheck = OBJdbConnection.Execute(SQLSubCheck)
If NOT rsSubCheck.EOF Then
    SubscriptionName = SeriesName(2)
End If
rsSubCheck.Close
Set rsSubCheck = Nothing

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>

<head>

<title><%=SurveyFileName%></title>

<script type="text/javascript">
<!--

function validate_form ( )
{
    valid = true;

    if ( ( document.EventListForm.EventCode[0].checked == false )
    && ( document.EventListForm.EventCode[1].checked == false ) 
    )
    {
        alert ( "Please choose a performance time" );
        valid = false;
    }

    return valid;

}

//-->

</script>

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
	padding-top: 1px;
    padding-bottom: 1px;
    padding-left: 1px;
    padding-right: 1px;
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
#rounded-corner td.category
{
	padding-top: 5px;
    padding-bottom: 10px;
    padding-left: 5px;
    padding-right: 5px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
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
	padding-top: 5px;
    padding-bottom: 10px;
    padding-left: 5px;
    padding-right: 5px;
	font-size: 11px;
	font-weight: 400;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

</head>

<%=strBody %>

<%

If Message = "" Then
	Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=#FFFFFF onLoad=" & CHR(34) & "alert('" & Message & "')" & CHR(34) & ">" & vbCrLf
End If 

%>
    
<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%=SurveyFileName%>" method="post" name="EventListForm" onsubmit="return validate_form ( );">
<input type="hidden" name="FormName" value="Removal" />
<br />

<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category-left">&nbsp;</th>
	    <th scope="col" class="category" colspan="2">&nbsp;</th>
	    <th scope="col" class="category-right">&nbsp;</th>
    </tr>        
</thead>
    <tr>
	    <td class="category"></td>
	    <td class="category" colspan="2"><b><%=SubscriptionName%></b></td>
	    <td class="category"></td>
    </tr>
  <tbody>

<%
   
    SQLPackages = "SELECT Distinct Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.ActCode IN(" & ActCodeList & ") AND Seat.StatusCode = 'A' GROUP BY  Event.EventCode, Event.EventDate, Act.Act, Act.Comments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode ORDER BY Event.EventCode, Event.EventDate"
    Set rsPackages = OBJdbConnection.Execute(SQLPackages)
    
    If Not rsPackages.EOF Then
    
        'Venue Name and Address
        SQLVenueDetail = "Select Venue.Venue, Venue.Address_1, Venue.Address_2, Venue.City, Venue.State, Venue.Zip_Code FROM Venue (NOLOCK) INNER JOIN Event (NOLOCK) ON Venue.VenueCode = Event.VenueCode WHERE EventCode = " & rsPackages("EventCode") & " "
        Set rsVenueDetail = OBJdbConnection.Execute(SQLVenueDetail)        
            VenueAddress = VenueAddress & rsVenueDetail("Venue") & "&nbsp;<BR>" & vbCrLf
            If rsVenueDetail("Address_1") <> "" Then VenueAddress = VenueAddress & rsVenueDetail("Address_1") & "<BR>" & vbCrLf
            If rsVenueDetail("Address_2") <> "" Then VenueAddress = VenueAddress & rsVenueDetail("Address_2") & "<BR>" & vbCrLf
            VenueAddress = VenueAddress & rsVenueDetail("City") & ", " & rsVenueDetail("State") & " " & rsVenueDetail("Zip_Code") & "<BR>" & vbCrLf        
        rsVenueDetail.Close
        Set rsVenueDetail = Nothing

%>
    <tr>
        <td class="data" colspan="4">
        <h3>Your subscription includes this production:</h3>
        <%=rsPackages("Act")%><br />
        <%=rsPackages("ActComments")%><br />
        <br />
        <%=VenueAddress%><br />        

        <h3>Please select a performance time:</h3>
        <INPUT TYPE="RADIO" NAME="EventCode" VALUE="353368">Saturday, 7/23/2011 at 8:00 PM <br />
        <br />
        <INPUT TYPE="RADIO" NAME="EventCode" VALUE="353414">Sunday, 7/17/2011 at 2:00 PM<br />
        <br />

<%
End If
%>
        </td>
    </tr>
    <tr>
	    <td class="footer-left">&nbsp;</td>
	    <td class="footer" colspan="2">&nbsp;</td>
	    <td class="footer-right">&nbsp;</td>
    </tr>
<%
rsPackages.Close
Set rsPackages = Nothing
%>
        <tr>
            <td colspan="4" align="center">
            <br />
            <INPUT type="submit" value="Continue" /></form>    
            </td>
        </tr>
        </table>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
   
    
End Sub 'AddOnSurvey

'=======================================

Sub RemoveChild  

    SQLOrderLines = "SELECT OrderLine.LineNumber, Seat.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode NOT IN(SELECT EventCode FROM SubscriptionEvent (NOLOCK) WHERE SubscriptionNumber = " & SeriesEventCode(1) & " AND EventCode NOT IN(" & Clean(Request("EventCode")) & ")) AND OrderLine.ItemType = 'SubSeat' AND OrderLine.ParentLineNumber IN (SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & SeriesEventCode(1) & ") ORDER BY OrderLine.LineNumber"
    Set rsOrderLines = OBJdbConnection.Execute(SQLOrderLines)
    Do While Not rsOrderLines.EOF
        'update seat status
        SQLUpdateStatus = "UPDATE Seat WITH (ROWLOCK) SET StatusCode = COALESCE (SSL3.StatusCode, 'A'), StatusDate = GETDATE(), OrderNumber = 0 FROM Seat WITH (ROWLOCK) LEFT OUTER JOIN (SELECT SSL1.ItemNumber, SSL1.StatusCode FROM SeatStatusLog SSL1 (NOLOCK) INNER JOIN (SELECT ItemNumber, MAX(LogNumber) AS LogNumber FROM  SeatStatusLog (NOLOCK) WHERE ItemNumber = " & rsOrderLines("ItemNumber") & " GROUP BY ItemNumber) SSL2 ON SSL1.LogNumber = SSL2.LogNumber) SSL3 ON Seat.ItemNumber = SSL3.ItemNumber WHERE Seat.ItemNumber = " & rsOrderLines("ItemNumber") & " AND OrderNumber = " & Session("OrderNumber")
        Set rsUpdateStatus = OBJdbConnection.Execute(SQLUpdateStatus)
        'delete child orderlines
        SQLDeleteLines = "DELETE FROM OrderLine WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLines("LineNumber")
        Set rsDeleteLines = OBJdbConnection.Execute(SQLDeleteLines)
        rsOrderLines.movenext
    Loop
    rsOrderLines.Close
    Set rsOrderLines = Nothing
    
    
    SQLOrderLines = "SELECT OrderLine.LineNumber, Seat.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode NOT IN(SELECT EventCode FROM SubscriptionEvent (NOLOCK) WHERE SubscriptionNumber = " & SeriesEventCode(2) & " AND EventCode NOT IN(" & Clean(Request("EventCode")) & ")) AND OrderLine.ItemType = 'SubSeat' AND OrderLine.ParentLineNumber IN (SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & SeriesEventCode(2) & ") ORDER BY OrderLine.LineNumber"
    Set rsOrderLines = OBJdbConnection.Execute(SQLOrderLines)
    Do While Not rsOrderLines.EOF
        'update seat status
        SQLUpdateStatus = "UPDATE Seat WITH (ROWLOCK) SET StatusCode = COALESCE (SSL3.StatusCode, 'A'), StatusDate = GETDATE(), OrderNumber = 0 FROM Seat WITH (ROWLOCK) LEFT OUTER JOIN (SELECT SSL1.ItemNumber, SSL1.StatusCode FROM SeatStatusLog SSL1 (NOLOCK) INNER JOIN (SELECT ItemNumber, MAX(LogNumber) AS LogNumber FROM  SeatStatusLog (NOLOCK) WHERE ItemNumber = " & rsOrderLines("ItemNumber") & " GROUP BY ItemNumber) SSL2 ON SSL1.LogNumber = SSL2.LogNumber) SSL3 ON Seat.ItemNumber = SSL3.ItemNumber WHERE Seat.ItemNumber = " & rsOrderLines("ItemNumber") & " AND OrderNumber = " & Session("OrderNumber")
        Set rsUpdateStatus = OBJdbConnection.Execute(SQLUpdateStatus)
        'delete child orderlines
        SQLDeleteLines = "DELETE FROM OrderLine WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLines("LineNumber")
        Set rsDeleteLines = OBJdbConnection.Execute(SQLDeleteLines)
        rsOrderLines.movenext
    Loop
    rsOrderLines.Close
    Set rsOrderLines = Nothing
    
    
    Call Continue

    
End Sub

'=======================================

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    
End Sub 'Continue

'=======================================

%>