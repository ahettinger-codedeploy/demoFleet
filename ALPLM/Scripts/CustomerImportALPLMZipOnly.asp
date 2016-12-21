<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<%

'Open the Client Import Database
Set dbCustomerImport = Server.CreateObject("ADODB.Connection")
'dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=127.0.0.1\SQL2000; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=sa; Password=p1n3"
dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

Server.ScriptTimeout = 3600

OrganizationNumber = 2469
'CustomerTable = "ALPLMPatrons"
ImportName = "ALPLM Customer Import Zip Only"

'Add Survey if it doesn't exist
SQLSurvey = "SELECT SurveyNumber FROM Survey (NOLOCK) WHERE SurveyFileName =  '" & ImportName & "'"
Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)

If Not rsSurvey.EOF Then
	SurveyNumber = rsSurvey("SurveyNumber")
Else 'Survey doesn't exist.  Add it.
	SQLAddSurvey = "INSERT Survey (SurveyFileName, OrganizationNumber) VALUES('" & ImportName & "', " & OrganizationNumber & ")"
	Set rsAddSurvey = OBJdbConnection.Execute(SQLAddSurvey)
	
	SQLSurvey = "SELECT SurveyNumber FROM Survey (NOLOCK) WHERE SurveyFileName =  '" & ImportName & "'"
	Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
	
	SurveyNumber = rsSurvey("SurveyNumber")
End If

rsSurvey.Close
Set rsSurvey = nothing	


SQLOldCust = "SELECT OH.OrderID, BI.Billing_ZipCode FROM ALPLMOrderHeaders AS OH (NOLOCK) INNER JOIN ALPLMOrderBillingInformation AS BI (NOLOCK) ON OH.OrderID = BI.OrderID WHERE OH.UserID = -1 AND BI.Billing_ZipCode <> '12345' AND OH.CustomerNumber IS NULL"
Set rsOldCust = dbCustomerImport.Execute(SQLOldCust)

Do Until rsOldCust.EOF

	PostalCode = Left(rsOldCust("Billing_ZipCode"),20)
    OptIn = 0
    OldOrderNumber = rsOldCust("OrderID")

	Set spInsertCustomer = Server.Createobject("Adodb.Command")
	Set spInsertCustomer.ActiveConnection = OBJdbConnection
	spInsertCustomer.Commandtype = 4 ' Value for Stored Procedure
	spInsertCustomer.Commandtext = "spInsertCustomer"
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("CustomerNumber", 3, 4) 'As Integer and ParamReturnValue
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("FirstName", 200, 1, 30, "")'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("MiddleInitial", 200, 1, 1, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("LastName", 200, 1, 30, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Address1", 200, 1, 50, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Address2", 200, 1, 50, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("City", 200, 1, 50, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("State", 200, 1, 30, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("PostalCode", 200, 1, 20, PostalCode) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Country", 200, 1, 30, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("DayPhone", 200, 1, 20, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("NightPhone", 200, 1, 20, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("EMailAddress", 200, 1, 50, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("UserID", 200, 1, 50, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Password", 200, 1, 10, "") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("OptIn", 11, 1, , OptIn) 'As Boolean and Input
	spInsertCustomer.Execute

	CustomerNumber = spInsertCustomer.Parameters("CustomerNumber")

	If CustomerNumber = 0 Then
		Response.Write "Customer " & OldCustomerNumber & " Not Added.<BR>" & vbCrLf
		FailedCount = FailedCount + 1
	Else 
		'Add The Survey Info
		SQLSurvey = "INSERT SurveyAnswers(SurveyNumber, AnswerNumber, CustomerNumber, SurveyDate, Question, Answer) VALUES(" & SurveyNumber & ", 1, " & CustomerNumber & ", '" & Now() & "', '" & ImportName & " - Old Order Number:', '" & OldOrderNumber & "')"
		Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
		
		'Add the Mailing List Record for Client
		SQLMailingList = "INSERT CustomerMailingList(CustomerNumber, OrganizationNumber, OptInFlag, DateEntered, DateModified) VALUES(" & CustomerNumber & ", " & OrganizationNumber & ", 'N', GETDATE(), GETDATE())"
		Set rsMailingList = OBJdbConnection.Execute(SQLMailingList) 
		
		'Add the Mailing List Record for Tix
		SQLMailingList = "INSERT CustomerMailingList(CustomerNumber, OrganizationNumber, OptInFlag, DateEntered, DateModified) VALUES(" & CustomerNumber & ", 1, 'N', GETDATE(), GETDATE())"
		Set rsMailingList = OBJdbConnection.Execute(SQLMailingList) 

		'Update Customer Import Table
		SQLUpdateOldCust = "UPDATE ALPLMOrderHeaders WITH (ROWLOCK) SET CustomerNumber = " & CustomerNumber & " WHERE OrderID = " & OldOrderNumber
		Set rsUpdateOldCust = dbCustomerImport.Execute(SQLUpdateOldCust)
		
		AddedCount = AddedCount + 1
			
	End If


	rsOldCust.MoveNext

Loop

rsOldCust.Close
Set rsOldCust = nothing

Response.Write "Failed Count = " & FailedCount & "<BR>"
Response.Write "Added Count = " & AddedCount & "<BR>"


OBJdbConnection.Close
Set OBJdbConnection = nothing

'dbCustomerImport.Close
'Set dbCustomerImport = nothing

%>