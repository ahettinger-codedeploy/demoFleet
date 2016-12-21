<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 847
SurveyFileName = "AlamitosBeachSurvey.asp"

'Downtown Theater  (9/2/2010)
'===============================================
'Series Event Add On Survey

'Purchase a ticket to the series event:
'2010-2011 Season Subscription

'Option to choose 1 of 3 possible performance times
'for Shuffle 

'300470  - 4/2/2012 1:00 PM
'300471  - 4/2/2012 4:00 PM 
'300473  - 4/2/2012 7:00 PM 


'===============================================
'Survey Variables

SeriesEventCode = "300475"
SeriesName = "2010-2011 Season Subscription"

ActCodeList = "55482"
OfferSection = "GA"

'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'===============================================

If Request("FormName") = "Removal" Then
    Call RemoveChild
Else
    Call EventList(Message)
End If

'===============================================

Sub EventList(Message)

'Determine if Subscription Event is on the order
SQLSubCheck = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & SeriesEventCode & ""
Set rsSubCheck = OBJdbConnection.Execute(SQLSubCheck)
If rsSubCheck.EOF Then
    Call Continue
End If
rsSubCheck.Close
Set rsSubCheck = Nothing

%>
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
    && ( document.EventListForm.EventCode[2].checked == false )
    )
    {
        alert ( "Please choose a performance" );
        valid = false;
    }

    return valid;

}

//-->

</script>



<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<head>

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

<table width="400" cellpadding="10" cellspacing="3">
<tr class=rounded-corners bgcolor="<%=TableCategoryBGColor%>">
    <td>
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <b><%=SeriesName%></b></FONT>
        <BR><br />
        <FONT FACE="<%= FontFace %>" COLOR=<%=TableCategoryFontColor%> SIZE="2"><i>Please select a performance time for the following event:</i></FONT><br />
    </td>
</tr>
<%
    SQLPackages = "SELECT Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.ActCode IN(" & ActCodeList & ") ORDER BY SeatType.SeatTypeCode"
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

        <tr bgcolor="<%=TableDataBGColor%>">
            <td>
            <FONT FACE="<%= FontFace %>" COLOR="<%= TableDataColor %>" SIZE="3"><b><%=rsPackages("Act")%></b></FONT><br />
            <FONT FACE="<%= FontFace %>" COLOR="<%= TableDataColor %>" SIZE="2"><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%></FONT><br />
            <FONT FACE="<%= FontFace %>" COLOR="<%= TableDataColor %>" SIZE="2"><%=VenueAddress%></FONT><br />
            <INPUT TYPE="RADIO" NAME="EventCode" VALUE="300471,300473"><FONT FACE="<%= FontFace %>" COLOR="<%= TableDataColor %>" SIZE="2">1:00 PM Performance</FONT><br />
            <INPUT TYPE="RADIO" NAME="EventCode" VALUE="300471,300473"><FONT FACE="<%= FontFace %>" COLOR="<%= TableDataColor %>" SIZE="2">4:00 PM Performance</FONT><br />
            <INPUT TYPE="RADIO" NAME="EventCode" VALUE="300470,300471"><FONT FACE="<%= FontFace %>" COLOR="<%= TableDataColor %>" SIZE="2">7:00 PM Performance</FONT><br />

<%
End If
%>
            </td>
        </tr>
<%
rsPackages.Close
Set rsPackages = Nothing
%>
        <tr>
            <td align=center>
            <hr style="width:500px;" />
            <INPUT type="submit" value="Continue" /></form>    
            </td>
        </tr>
        </TABLE>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
   
    
End Sub 'AddOnSurvey
'=======================================

Sub RemoveChild   
    SQLOrderLines = "SELECT OrderLine.LineNumber, Seat.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode NOT IN(SELECT EventCode FROM SubscriptionEvent (NOLOCK) WHERE SubscriptionNumber = " & SeriesEventCode & " AND EventCode NOT IN(" & Clean(Request("EventCode")) & ")) AND OrderLine.ItemType = 'SubSeat' AND OrderLine.ParentLineNumber IN (SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & SeriesEventCode & ") ORDER BY OrderLine.LineNumber"
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

Sub Continue
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
End Sub 'Continue

%>