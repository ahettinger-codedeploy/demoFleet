<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 847
SurveyFileName = "SubChildRemoval.asp"

'===============================================

'Ballet Arts, Inc. (1/31/2011)

'Subscription Event Removal Survey

'Purchase a ticket to the subscription:
'336438 - Pearls and Purses Classical Spring Tea Package

'Subscription includes tickets to both performances of:
'336423 Classical Jackson - 3/26/2011 7:00 PM
'336436 Classical Jackson - 3/27/2011 2:00 PM

'Survey will ask patron to select one of the two performances
'Survey will then remove the other performance from the order


'===============================================
'Survey Variables

SeriesEventCode = "336438"
SeriesName = "Pearls and Purses Classical Spring Tea Package"

ActCodeList = "59720" 'Actcode of Child Event

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

If Session("UserNumber")<> "" Then
TableFontFace = "Arial"
TableCategoryBGColor = "008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If

'===============================================

If Request("FormName") = "Removal" Then
    Call RemoveChild
Else
    Call EventList(Message)
End If

'===============================================

Sub EventList(Message)

'Determine if Subscription is on the order
SQLSubCheck = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & SeriesEventCode & ""
Set rsSubCheck = OBJdbConnection.Execute(SQLSubCheck)
If rsSubCheck.EOF Then
    Call Continue
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
<% If Session("UserNumber")<> "" Then %>

<style type="text/css">
.category 
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:10px; 
padding-right:0px; 
background-color: #008400;

text-align: left;
font-size: medium;
font-weight: 700;
color: #ffffff;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.column
{ 
width: 640px;	

padding-top:10px; 
padding-bottom:10px; 
padding-left:10px; 
padding-right:0px; 
background-color: #99cc99;

text-align: left;
font-size: small;
font-weight: 400;
color: #000000;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.data
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:10px; 
padding-right:0px; 
background-color: #dddddc;

text-align: center;
font-size: small;
font-weight: 400;
color: #000000;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}

</style>

<% Else %>

<style type="text/css">
.category 
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%=TableCategoryBGColor%>;

text-align: left;
font-size: medium;
font-weight: 700;
color: <%=TableCategoryFontColor%>;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.column
{ 
width: 640px;	

padding-top:10px; 
padding-bottom:10px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%=TableColumnHeadingBGColor%>;

text-align: left;
font-size: x-small;
font-weight: 400;
color: <%=TableColumnHeadingFontColor%>;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.data
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:20px; 
padding-right:20px; 
background-color: <%=TableDataBGColor%>;

text-align: center;
font-size: x-small;
font-weight: 400;
color: <%=TableDataFontColor%>;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}

</style>

<% End If %>

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
<table>
<tr>
    <td class="category">
      <%=SeriesName%>
    </td>
</tr>
<tr>
    <td class="column">
        Please select a performance time for this production
    </td>
</tr>

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
            <td class="data">
            <%=rsPackages("ActComments")%><br />
            <%=VenueAddress%><br />
            <br />
            <h3>Please select a performance time:</h3>
            <INPUT TYPE="RADIO" NAME="EventCode" VALUE="336436">Classical Jackson - 3/26/2011 7:00 PM<br />
            <INPUT TYPE="RADIO" NAME="EventCode" VALUE="336423">Classical Jackson - 3/27/2011 2:00 PM<br />
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