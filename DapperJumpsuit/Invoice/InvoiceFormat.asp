<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'Initialize Variables
OrganizationNumber = 4892 'Organization Number
StreetAddress = "1015 Ironwork Passage" 'Street Address. If this is a 2 line street address use <BR> between the two lines
CityStateZip = "Vancouver, BC, V6H 3R4" 'City State Zip Code
ClientDirectory = "ArtesiaArtsCouncil" 'Name of Client Directory where Invoice/InvoiceFormat.asp is located
PhoneNumber = "(575) 746-4212" 'Customer Service Phone Number. If org doesn't have a number, use PhoneNumber = ""




'Get Organization Name
SQLOrgName = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & ""
Set rsOrgName = OBJdbConnection.Execute(SQLOrgName)

OrgName = rsOrgName("Organization")

rsOrgName.Close
Set rsOrgName = nothing



'Get Customer Service Email Address
SQLEmail = "SELECT OptionValue FROM OrganizationOptions WITH (ROWLOCK) WHERE OrganizationNumber = " & OrganizationNumber & " AND OptionName = 'CustomerServiceEmailAddress'"
Set rsEmail = OBJdbConnection.Execute(SQLEmail)
			
If Not rsEmail.EOF Then
	EmailAddress = "email us at " & rsEmail("OptionValue") & " " & vbCrLf
Else
	EmailAddress = ""
End If
			
rsEmail.Close
Set rsEmail = nothing

If PhoneNumber <> "" Then
PhoneNumber = "call " & PhoneNumber & " " & vbCrLf
	If EmailAddress <> "" Then
		EmailAddress = "" & EmailAddress & " or " & vBCrLf
	End If
End If



'Get Customer Information
SQLCustInfo = "SELECT Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & Clean(Request("OrderNumber")) & " AND OrderLine.LineNumber = " & Clean(Request("LineNumber"))
Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

If Not rsCustInfo.EOF Then

	Response.Write "<HTML><HEAD><TITLE>Invoice Format</TITLE><BODY leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf

	Response.Write "<BR><BR><TABLE WIDTH=""750""><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""400"" VALIGN=""top"">Dapper Jumpsuit Productions Youth Theatre Society<BR>1015 Ironwork Passage<BR>Vancouver, BC, V6H 3R4<BR>Phone: (604) 295-1031<BR>Fax: (604) 424-4116<BR>Website: www.dapperjumpsuit.com<BR>Email: info@dapperjumpsuit.com</TD><TD WIDTH=""300""><IMG SRC=/clients/DapperJumpSuit/Invoice/Images/invoicelogo.png></TD></TR></TABLE>"
	Response.Write "<BR><BR><TABLE WIDTH=""750""><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""400""><B>Shipping Information</B></TD><TD WIDTH=""300""><B>Billing Information</B></TD></TR>"
	Response.Write "<TR><TD>&nbsp;</TD><TD>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
	If rsCustInfo("ShipAddress2") <> "" Then
		Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
	End If
	Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
	If rsCustInfo("Address2")<> "" Then
		Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
	End If
	Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</TD></TR></TABLE><BR><HR>" & vbCrLf
	Response.Write "<CENTER><TABLE WIDTH=""700""><TR><TD>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ", <BR><BR>Thank you for purchasing tickets from " & OrgName & ".&nbsp;&nbsp;The details of your order are listed below.  For questions regarding this order, " & EmailAddress & " " & PhoneNumber & ".<BR><BR>" & vbCrLf

	Response.Write "</BODY></HTML>" & vbCrLf

Else

	ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

End If

rsCustInfo.Close
Set rsCustInfo = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing


%>  