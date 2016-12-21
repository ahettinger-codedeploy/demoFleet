<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<%

StartTime = Now()

'Open the Client Import Database
Set dbCustomerImport = Server.CreateObject("ADODB.Connection")
'dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=127.0.0.1\SQL2000; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=sa; Password=p1n3"
dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

Set dbCustomerImport2 = Server.CreateObject("ADODB.Connection")
dbCustomerImport2.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

Server.ScriptTimeout = 1800

SQLOL = "SELECT ID, OrderID FROM ALPLMFoundationOrderLineItems (NOLOCK) WHERE LineNumber IS NULL ORDER BY OrderID"
Set rsOL = dbCustomerImport.Execute(SQLOL)

Do Until rsOL.EOF Or OrderCount >= 100000
    OrderID = rsOL("OrderID")
    ID = rsOL("ID")
    
    If OrderID <> LastOrderID Then
        LineNumber = 0
        LastOrderID = OrderID
        OrderCount = OrderCount + 1
    End If
    
    LineNumber = LineNumber + 1
    SQLLN = "UPDATE ALPLMFoundationOrderLineItems WITH (ROWLOCK) SET LineNumber = " & LineNumber & " WHERE ID = " & ID & " AND LineNumber IS NULL"
    Set rsSOLLN = dbCustomerImport2.Execute(SQLLN)

    rsOL.MoveNext
Loop    

dbCustomerImport.Close
Set dbCustomerImport = nothing

dbCustomerImport2.Close
Set dbCustomerImport2 = nothing

EndTime = Now()

Response.Write "Order Count: " & OrderCount & "<br />" & vbCrLf
Response.Write "Start Time: " & StartTime& "<br />" & vbCrLf
Response.Write "End Time: " & EndTime& "<br />" & vbCrLf

%>