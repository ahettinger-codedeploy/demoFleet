<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE virtual="NoCacheInclude.asp"-->
<!--#INCLUDE virtual="ETicketAddInclude.asp"-->
<%

'CHANGE LOG
'REE 12/3/12 - Modified for 2013 event.

Page = "ManagementReports"

EMailBodyTemplate = EMailBodyTemplate & "<html><body style=""font-size: small; font-family: Arial, Helvetica, sans-serif""><table width=""600"" cellspacing=""5""border=""0"" style=""font-size: small; font-family: Arial, Helvetica, sans-serif"">" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td colspan=""2""><img src=""http://www.tix.com/clients/gplb/images/emailbanner.jpg"" alt=""Toyota Grand Prix of Long Beach"" /><br /><br /></td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td colspan=""2"">Dear <CUSTOMERNAME>:<br /><br /></td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td valign=""top"">Thank you very much for your 2013 Toyota Grand Prix of Long Beach ticket order. Your tickets are now available for printing. Please <A HREF=""https://www.tix.com/ETicketPrint.asp?OrderNumber=<ORDERNUMBER>&TicketNumber=<TICKETNUMBER>"">click here</A> to print your tickets.<BR><BR></td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td valign=""top"">Be sure you keep your tickets in a safe place so you can be ready to use them next April 19-21.<br /><br />See you at the races!<BR><BR></td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td valign=""top"">If you need to contact us, send an e-mail to tickets@gpalb.com or call us at (888) 82-SPEED and we will get back to you as quickly as possible.</td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "</table></body></html>" & vbCrLf

SQLOrder = "SELECT FirstName, LastName, EMailAddress, OrderNumber FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber WHERE OrderNumber IN (SELECT OrderLine.OrderNumber FROM vOrgEvent (NOLOCK) INNER JOIN Event (NOLOCK) ON vOrgEvent.EventCode = Event.EventCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.itemNumber = OrderLine.ItemNumber WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.EventDate > GETDATE() AND OrderLine.StatusCode = 'S' AND OrderLine.ShipCode = 13) AND OrderHeader.StatusCode = 'S' AND Customer.EmailAddress LIKE '%@%' ORDER BY OrderHeader.OrderNumber"  
Set rsOrder = OBJdbConnection.Execute(SQLOrder)

Call DBOpen(OBJdbConnection2)

Do Until rsOrder.EOF 'Or SentCount > 3

    OrderNumber = rsOrder("OrderNumber")
    CustomerName = rsOrder("FirstName") & " " & rsOrder("LastName")
    EMailAddress = rsOrder("EMailAddress")


    'REE 3/14/4 - Added ETicket Message
    SQLETicket = "SELECT Ticket.OrderNumber, TicketNumber FROM OrderLine (NOLOCK) INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber AND OrderLine.OrderNumber = Ticket.OrderNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ShipCode = 13 AND OrderLine.StatusCode = 'S' AND Ticket.StatusCode = 'A'"
    Set rsETicket = OBJdbConnection2.Execute(SQLETicket)

    If Not rsETicket.EOF Then
		
	    TicketNumber = rsETicket("TicketNumber")
		
    End If

    rsETicket.Close
    Set rsETicket = nothing
    
    EMailBody = EMailBodyTemplate
    EMailBody = Replace(EMailBody, "<CUSTOMERNAME>", CustomerName)
    EMailBody = Replace(EMailBody, "<ORDERNUMBER>", OrderNumber)
    EMailBody = Replace(EMailBody, "<TICKETNUMBER>", TicketNumber)
    

    'JAI 3/2/5 - Modified to use CDO Mail
    'Create the e-mail server object
    Set objCDOSYSMail = Server.CreateObject("CDO.Message")
    Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

    objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
    objCDOSYSCon.Fields.Update

    'Update the CDOSYS Configuration
    Set objCDOSYSMail.Configuration = objCDOSYSCon
    objCDOSYSMail.From = "<orders@tix.com>"
    objCDOSYSMail.ReplyTo = "newsletter@gpalb.com"
    'Test Only
    'EMailAddress = "robert.edmison@tix.com"
    objCDOSYSMail.To = EMailAddress
    'objCDOSYSMail.Bcc = "robert.edmison@tix.com"
    objCDOSYSMail.Subject = "Toyota Grand Prix of Long Beach - E-Tickets"
    objCDOSYSMail.HTMLBody = EMailBody
    objCDOSYSMail.Send

    'Close the server mail object
    Set objCDOSYSMail = Nothing
    Set objCDOSYSCon = Nothing 
    
    SentCount = SentCount + 1
    
    ErrorLog("Order Number: " & OrderNumber)

    rsOrder.MoveNext

Loop	    

Call DBClose(OBJdbConnection2)

rsOrder.Close
Set rsOrder = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

Response.Write "Sent: " & SentCount & "<br />"
Response.Write "Last Order #: " & OrderNumber

%>