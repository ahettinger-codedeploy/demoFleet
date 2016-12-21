<%

'CHANGE LOG - Update
'SSR 4/5/2011
'Act 58999 (Cagney) is now Act 61397 (No Way to Treat a Lady)

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
SurveyNumber = 993
SurveyName = "SubscriptionReminder.asp"

'========================================

'Alpine Theatre Project

'Checks the order to see if the 4 act season subscription
'is on the order. If not, reminds patron about the 4 act subscription

'Package 3 ("Summer") - 4 Acts

'58996	I Do! I Do!
'58997	She Loves Me
'58998	An Evening of Frank Loesser
'61397	No Way to Treat a Lady

ActCount3List = "58996,58997,58998,61397"

'===============================================

'Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "alpinetheatreproject"
End If


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

Call SurveyForm

'===============================================
	
Sub SurveyForm

'Survey Start. Request Form name and process requested action

SQLActCount3 = "SELECT COUNT(ActCode) AS ActCount3 FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND Event.ActCode IN (" &  ActCount3List & ") GROUP BY Event.ActCode) AS ActCount3"
Set rsActCount3 = OBJdbConnection.Execute(SQLActCount3)	
ActCount3 = rsActCount3("ActCount3")	
rsActCount3.Close
Set rsActCount3 = nothing

If ActCount3 < 4 Then
    Call SurveyDisplay
Else
    Call Continue 
    Exit Sub
End If


End Sub

'===============================================

Sub SurveyDisplay

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Ticket Policy</title>

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
	background: <%=TableDataBGColor%> url('/Clients/TIX/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/TIX/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
img.transparent {
	filter:alpha(opacity=75);
	opacity:.75;
}
</style>


<!--[if lte IE 6]>
<style type="text/css">
.fixMe {filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled='true',src='/Clients/<%=ClientFolder%>/Survey/Images/watermark.png');padding-top:150px}
</style>
<![endif]-->



</head>


<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<%

Session("SurveyComplete") = Session("OrderNumber")

%>

    <table id="rounded-corner" summary="surveypage" >
    <thead>
	    <tr>
    	    <th scope="col" class="category-left"></th>
    	    <th scope="col" class="category" colspan="2"><b>HOLD ON!</b></th>
    	    <th scope="col" class="category-right"></th>
        </tr>        
   </thead>
        <tbody>
        <tr>
            <td class="data" colspan="4">
            You can save up to 20% off your ticket price!<br />
            <br />
            Did you know that if you subscribe to ATP's Summer Season:<br /><br />            
            <a href="http://www.alpinetheatreproject.org/shows_detail.php?show=I%20Do!%20I%20Do!&uuid=4BF1A-BF55"><img src="http://www.alpinetheatreproject.org/cms/image_bank/single_images/2_IDOIDO_WEB1.JPG"/></a>&nbsp;
            <a href="http://www.alpinetheatreproject.org/shows_detail.php?show=She%20Loves%20Me&uuid=C193E-0546"><img src="http://www.alpinetheatreproject.org/cms/image_bank/single_images/2_SHELOVESME_WEB1.JPG" /></a>&nbsp;
            <a href="http://www.alpinetheatreproject.org/shows_detail.php?show=An%20Evening%20of%20Frank%20Loesser&uuid=4DF2E-1691"><img src="http://www.alpinetheatreproject.org/cms/image_bank/single_images/2_LOESSER_WEB1.JPG" /></a>&nbsp;
            <a href="http://www.alpinetheatreproject.org/shows_detail.php?show=No%20Way%20to%20Treat%20a%20Lady&uuid=BC489-D20C"><img src="http://www.alpinetheatreproject.org/cms/image_bank/single_images/NOWAY_WEB1.JPG" /></a>&nbsp;
            <br />
            <br />
            You can save up to 20% off the single ticket price?<br />
            <br />
            <b>That's over $7 off each ticket!</b><br />
            <br />
            <h3>Season Subscribers also enjoy these benefits:</h3>
                <ul>
                    <li>Priority Seating - get the best seats in the house. Guaranteed.</li>
                    <li>Free and Easy Ticket Exchange</li>
                    <li>Advance opportunity to purchase tickets to special events like the Yuletide Affair</li>
                    <li>Opportunity to purchase additional single tickets before public sale</li>
                </ul>
            <br />
            Simply add at least one ticket from each production to your order and the discount will be taken off automatically upon checkout.<br />
            <br />
            We look forward to seeing you all summer!
            <br />
            <br />
            </td>
        </tr>
        <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer" colspan="2">&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
    	<tr align="center">
        <td>&nbsp;</td>
<%
If Session("UserNumber") = "" Then
	Response.Write "<td><Br><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<td><Br><FORM ACTION=""/Management/EventSelection.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

    Response.Write "<INPUT TYPE=""submit"" VALUE=""<< Continue with Shopping"" id=1 name=1 Style=""width: 200px""></FORM></CENTER></td>" & vbCrLf

If Session("UserNumber") = "" Then
	Response.Write "<td><Br><FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<td><Br><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

    Response.Write "<INPUT TYPE=""submit"" VALUE=""Continue with Checkout >>"" id=1 name=1 Style=""width: 200px""></FORM></td>" & vbCrLf

%>
<td>&nbsp;</td>
</tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'======================================

Sub Continue


    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    
    
End Sub 'Continue


'======================================

%>