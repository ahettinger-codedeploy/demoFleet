<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%


'Initialize Variables
'==================================================================================

OrganizationNumber = 531
'Organization Number

'Organization Name = automatically pulled from database

StreetAddress = "P.O. Box 5190/E101 Music & Speech Center"
'Street Address. If this is a 2 line street address use <BR> between the two lines

CityStateZip = "Kent, OH 44242"
'City, State and Zip Code

ClientDirectory = "Blossom" 
'Name of Client Directory where Invoice.asp or InvoiceFormat.asp is located

PhoneNumber = "" 
'Customer Service Phone Number. If org doesn't have a number, use PhoneNumber = ""

'Email Address = automatically pulled from database

LogoName = ""
'Organization Logo. Logo should be saved to /Clients/ClientDirectory/Invoice/ directory
'If org doesn't have a logo, use LogoName = ""

DonationCommentDisplay = False
DonationComment = "This will only appear when there is a donation item on the invoice"

donationcomments = "Thank you for purchasing tickets to the Kent/Blossom Music Series. Please review your order details listed below. If you have questions, please do not hesitate to call 330-672-2631. If you have purchased a 3-Concert Pass, please complete the form inside your subscriber packet and mail it to Jenna Bice 1325 Theatre Dive, MSP B103, PO BOX 5190, Kent, Ohio - 44240. Please note: All sales are final and your credit card statement will reflect a charge from Kent State Bursar.Again, we thank you for your patronage and look forward to seeing you this summer." 

'===================================================================================

'Get Organization Name
SQLOrgName = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & ""
Set rsOrgName = OBJdbConnection.Execute(SQLOrgName)
OrgName = rsOrgName("Organization")
rsOrgName.Close
Set rsOrgName = nothing


'Get Customer Service Email Address
SQLEmail = "SELECT OptionValue FROM OrganizationOptions WITH (ROWLOCK) WHERE OrganizationNumber = " & OrganizationNumber & " AND OptionName = 'CustomerServiceEmailAddress'"
Set rsEmail = OBJdbConnection.Execute(SQLEmail)

    'Add Email Address to Invoice			
    If Not rsEmail.EOF Then
	    EmailAddress = "email us at " & rsEmail("OptionValue") & " " & vbCrLf
    Else
	    EmailAddress = ""
    End If
			
rsEmail.Close
Set rsEmail = nothing


'Add Phone Number to Invoice
If PhoneNumber <> "" Then
PhoneNumber = "call " & PhoneNumber & " " & vbCrLf
	If EmailAddress <> "" Then
		EmailAddress = "" & EmailAddress & " or " & vBCrLf
	End If
End If


'Add Logo to Invoice
If LogoName <> "" Then
    Logo = "<IMG SRC=""/Clients/" & ClientDirectory & "/Invoice/Images/" & LogoName & """ HEIGHT=""120"" WIDTH=""240"">"
Else
   Logo = "<IMG SRC=""/Images/Clear.gif"" HEIGHT=""120"">"
End If
 
 
SQLDonationList = "SELECT ItemNumber, Description FROM Donation WITH (nolock) WHERE OrganizationNumber = " & OrganizationNumber & ""
Set rsDonationList = OBJdbConnection.Execute(SQLDonationList)

If Not rsDonationList.EOF Then

Do While Not rsDonationList.EOF
    
    SQLDonationFind = "SELECT LineNumber from OrderLine (NOLOCK) Where OrderNumber = " & Clean(Request("OrderNumber")) & " AND ItemNumber = " & rsDonationList("ItemNumber") & ""
    Set rsDonationFind = OBJdbConnection.Execute(SQLDonationFind)
        If Not rsDonationFind.EOF Then
                DonationFound = True
                DonationName = rsDonationList("Description")
        End If
    rsDonationFind.Close
    Set rsDonationFind = nothing


rsDonationList.movenext
Loop

End If


    
'Get Customer Information
SQLCustInfo = "SELECT Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & Clean(Request("OrderNumber")) & " AND OrderLine.LineNumber = " & Clean(Request("LineNumber"))
Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

If Not rsCustInfo.EOF Then

Response.Write "<HTML><HEAD><TITLE>Invoice Format</TITLE>" & vbCrLf

 
%>
	
<style type="text/css" media="all">
body {
background: white;
font-family: Times New Roman, Times, serif;
font-size: 10pt;
}
</style>

<%
	Response.Write "</HEAD>" & vbCrLf
	Response.Write "<BODY leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf
	Response.Write "<BR><BR><BR><BR><BR><TABLE WIDTH=""750""><TR><TD WIDTH=""80"">&nbsp;</TD><TD WIDTH=""400"" VALIGN=""top"">" & OrgName & "<BR>" & StreetAddress & "<BR>" & CityStateZip & "</TD><TD WIDTH=""300"">" & Logo & "</TD></TR></TABLE>"
	Response.Write "<BR><BR><BR><BR><TABLE WIDTH=""750"" ><TR><TD WIDTH=""80"">&nbsp;</TD><TD WIDTH=""420""><B>Shipping Information</B></TD><TD WIDTH=""250""><B>Billing Information</B></TD></TR>"
	Response.Write "<TR><TD>&nbsp;</TD><TD>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
	If rsCustInfo("ShipAddress2") <> "" Then
		Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
	End If
	Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
	If rsCustInfo("Address2")<> "" Then
		Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
	End If
	Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</TD></TR></TABLE><BR>" & vbCrLf
	Response.Write "<CENTER><TABLE WIDTH=""700""><TR><TD>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ", <BR><BR>" & donationcomments & "<BR>" & vbCrLf  
    
    Response.Write "</BODY></HTML>" & vbCrLf

Else

	ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

End If

rsCustInfo.Close
Set rsCustInfo = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing


%>  