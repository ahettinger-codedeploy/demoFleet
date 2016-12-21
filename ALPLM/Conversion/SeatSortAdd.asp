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

SQLOL = "SELECT ID, Performance FROM ALPLMOrderLineItems (NOLOCK) WHERE IntFee1 = 0 AND Performance IN (SELECT ID FROM ALPLMEventPerformances (NOLOCK) WHERE ActCode = 40044) ORDER BY Performance"
Set rsOL = dbCustomerImport.Execute(SQLOL)

Do Until rsOL.EOF
    ID = rsOL("ID")
    Performance = rsOL("Performance")
    
    If Performance <> LastPerformance Then
        SeatSort = 0
        LastPerformance = Performance
        EventCount = EventCount + 1
    End If
    
    SeatSort = SeatSort + 1
    SQLSS = "UPDATE ALPLMOrderLineItems WITH (ROWLOCK) SET IntFee1 = " & SeatSort & " WHERE ID = " & ID
    Set rsSOLSs = dbCustomerImport2.Execute(SQLSS)

    rsOL.MoveNext
Loop    

dbCustomerImport.Close
Set dbCustomerImport = nothing

dbCustomerImport2.Close
Set dbCustomerImport2 = nothing

EndTime = Now()

Response.Write "Event Count: " & EventCount & "<br />" & vbCrLf
Response.Write "Start Time: " & StartTime& "<br />" & vbCrLf
Response.Write "End Time: " & EndTime& "<br />" & vbCrLf

%>