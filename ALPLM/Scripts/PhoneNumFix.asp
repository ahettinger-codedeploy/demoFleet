<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<%

Set dbCustomerImport = Server.CreateObject("ADODB.Connection")
dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

Set dbCustomerImport2 = Server.CreateObject("ADODB.Connection")
dbCustomerImport2.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

SQLCust = "SELECT CustomerNo, CellPhone AS Phone FROM ALPLMPatrons (NOLOCK) WHERE CellPhone IS NOT NULL AND DayPhone IS NULL"
Set rsCust = dbCustomerImport.Execute(SQLCust)

Do Until rsCust.EOF
    CustNum = rsCust("CustomerNo")
    OldPhone = rsCust("Phone")
    
    'Update DayPhone
    SQLDayPhone = "UPDATE ALPLMPatrons WITH (ROWLOCK) SET DayPhone = '" & CleanPhone(OldPhone, 10) & "' WHERE CustomerNo = " & CustNum
    Set rsDayPhone = dbCustomerImport2.Execute(SQLDayPhone) 
    
    UpdateCount = UpdateCount + 1   

    rsCust.MoveNext
Loop    

rsCust.Close
Set rsCust = nothing

Response.Write UpdateCount & " Phone Numbers Updated.<BR>" & vbCrLf

dbCustomerImport.Close
Set dbCustomerImport = nothing

dbCustomerImport2.Close
Set dbCustomerImport2 = nothing

%>