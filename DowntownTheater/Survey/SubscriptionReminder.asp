
<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>TIX.com</title>

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

</head>


<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

    <table id="rounded-corner" summary="surveypage" >
    <thead>
	    <tr>
    	    <th scope="col" class="category-left"></th>
    	    <th scope="col" class="category" colspan="2"><b>WAIT! HOLD ON!</b></th>
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
            <a href="http://www.alpinetheatreproject.org/shows_detail.php?show=Cagney!&uuid=BC489-D20C"><img src="http://www.alpinetheatreproject.org/cms/image_bank/single_images/2_CAGNEY_WEB1.JPG" /></a>&nbsp;
            <br />
            <br />
            you can save up to 20% off the single ticket price?<br />
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

<INPUT TYPE="submit" VALUE="<< Continue with Shopping" id=1 name=1 Style="width: 200px"></FORM></CENTER></td>
<INPUT TYPE="submit" VALUE="Continue with Checkout >>" id=1 name=1 Style="width: 200px"></FORM></td>

<td>&nbsp;</td>
</tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
