<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%

Server.ScriptTimeout = 60 * 20 '20 Minutes

StartTime = Now()

Set dbCustomerImport = Server.CreateObject("ADODB.Connection")
dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

Set dbCustomerImport2 = Server.CreateObject("ADODB.Connection")
dbCustomerImport2.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

SQLEP = "SELECT EP.EventCode, OL.ID, OL.OrderNumber FROM ALPLMEventPerformances AS EP (NOLOCK) INNER JOIN ALPLMOrderLineItems AS OL (NOLOCK) ON EP.ID = OL.Performance WHERE OL.ItemNumber IS NULL"
Set rsEP = dbCustomerImport.Execute(SQLEP)

Do Until rsEP.EOF

    EventCode = rsEP("EventCode")
    ID = rsEP("ID")
    OrderNumber = rsEP("OrderNumber")

    SQLSeat = "SELECT ItemNumber FROM Seat (NOLOCK) WHERE EventCode = " & EventCode & " AND StatusCode = 'A' AND (OrderNumber = 0 OR OrderNumber IS NULL)"
    Set rsSeat = OBJdbConnection.Execute(SQLSeat)
    
    If Not rsSeat.EOF Then
    
        ItemNumber = rsSeat("ItemNumber")
    
        SQLUpdateSeat = "UPDATE Seat WITH (ROWLOCK) SET StatusCode = 'S', StatusDate = '8/12/9', OrderNumber = " & OrderNumber & " WHERE ItemNumber = " & ItemNumber & " AND EventCode = " & EventCode & " AND StatusCode = 'A'"
        Set rsUpdateSeat = OBJdbConnection.Execute(SQLUpdateSeat)
        
        SQLUpdateOL = "UPDATE ALPLMOrderLineItems WITH (ROWLOCK) SET ItemNumber = " & ItemNumber & " WHERE ID = " & ID
        Set rsUpdateOL = dbCustomerImport2.Execute(SQLUpdateOL)    
    
        ItemCount = ItemCount + 1

    Else
    
        ErrorLog(SQLSeat)
        Exit Do
        
    End If
    
    rsSeat.Close
    Set rsSeat = nothing
    

    rsEP.MoveNext
Loop    

rsEP.Close
Set rsEP = nothing

EndTime = Now()

Response.Write "Item Count: " & ItemCount & "<br />" & vbCrLf
Response.Write "Start Time: " & StartTime& "<br />" & vbCrLf
Response.Write "End Time: " & EndTime& "<br />" & vbCrLf

%>