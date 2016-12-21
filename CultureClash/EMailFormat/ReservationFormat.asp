<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%
OrderNumber = Clean(Request("OrderNumber"))

SQLCustomer = "SELECT Customer.FirstName, Customer.LastName, OrderHeader.ExpirationDate FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber WHERE OrderHeader.OrderNumber = " & OrderNumber
Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)

SQLOrganization = "SELECT TOP 1 Organization.OrganizationNumber, Organization, MerchantAccountNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') AND OrganizationVenue.Owner = 1 UNION SELECT TOP 1 Organization.OrganizationNumber, Organization, MerchantAccountNumber FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber INNER JOIN Organization (NOLOCK) ON Donation.RemittalOrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType = 'Donation'"
Set rsOrganization = OBJdbConnection.Execute(SQLOrganization)
Organization = rsOrganization("Organization")
OrganizationNumber = rsOrganization("OrganizationNumber")
OrganizationMerchantAccountNumber = rsOrganization("MerchantAccountNumber")
rsOrganization.Close
Set rsOrganization = nothing

'REE 3/23/3 - Added Organization's Customer Service Email Address if applicable
SQLOrgEMail = "SELECT OptionValue As OrgEMail FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & " AND OptionName = 'CustomerServiceEMailAddress'"
Set rsOrgEMail = OBJdbConnection.Execute(SQLOrgEMail)

If Not rsOrgEMail.EOF Then
    OrgEMail = rsOrgEMail("OrgEMail")
Else
    OrgEmail = "customerservice@tix.com"
End If
rsOrgEMail.Close
Set rsOrgEMail = nothing

'JAI 8/26/4 - Added EventEMailAddress from EventOptions
SQLEventEMail = "SELECT EventOptions.OptionValue AS EventEMail FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EventOptions (NOLOCK) ON Seat.EventCode = EventOptions.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') AND EventOptions.OptionName = 'EventEMailAddress' GROUP BY EventOptions.OptionValue ORDER BY EventOptions.OptionValue"
Set rsEventEMail = OBJdbConnection.Execute(SQLEventEMail)

If Not rsEventEMail.EOF Then
    OrgEMail = rsEventEMail("EventEMail")
End If
rsEventEMail.Close
Set rsEventEMail = nothing

OrderDetails = "<TABLE CELLPADDING=""5"" BORDER=""0"">" & vbCrLf
%>
<!--#INCLUDE VIRTUAL="OrderDetailsInclude.asp"-->
<%
OrderDetails = OrderDetails & "</TABLE>" & vbCrLf

'REE 11/2/2 - Modified to look for seats and donations separately.
Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=2>"
Response.Write "Dear " & rsCustomer("FirstName") & " " & rsCustomer("LastName") & ",<BR><BR>" & vbCrLf & vbCrLf
Response.Write "Thank you for ordering ""Zorro in Hell"" tickets from Nederlander Group Sales L.A.  Your Reservation Number is " & OrderNumber & " and your tickets will be reserved until " & FormatDateTime(rsCustomer("ExpirationDate"), vbLongDate) & " at " & TimeFormat(rsCustomer("ExpirationDate")) & ".  <B>If your payment does not arrive by 12:00 PM on this date, these tickets will be automatically released for resale.</B><BR><BR>For <B>credit card</B> payments, please call weekdays between 10:00 AM and 4:00 PM.<BR><BR>Please make <B>checks</B> payable to the MONTALBAN THEATRE and mail to:<BR>Nederlander Group Sales L.A.<BR>6233 Hollywood Blvd. (Hollywood & Vine)<BR>Los Angeles, CA 90028<BR>Phone: 323-463-4367<BR>Toll Free: 866-755-3075<BR>Fax: 323-463-7194<BR>Email:  groups@broadwayla.org<BR>Web: www.nedgroups.com<BR><BR>" & vbCrLf
Response.Write "For more information about ordering group tickets through Nederlander Group Sales L.A., please visit www.nedgroups.com.<BR><BR>No refunds or exchanges.  Payment of any amount indicates acceptance of the terms of this agreement and other Nederlander Group Sales L.A. policies as outlined on www.nedgroups.com.<BR><BR>" & vbCrLf
Response.Write "If you are unable to read the remainder of this e-mail, click on the following link or cut and paste it into your browser: http://www.tix.com/account.asp.  Login using your e-mail address and password to view the details of your order." & "<BR><BR>" & vbCrLf & vbCrLf
Response.Write "<HTML>"
Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf
Response.Write "<CENTER>"
Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#000000><H3>Order Information</H3></FONT>" & vbCrLf

Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#000000><B>Reservation Number - " & OrderNumber & "</B><BR><BR>" & vbCrLf
Response.Write OrderDetails

Response.Write "</FONT></BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf
%>
