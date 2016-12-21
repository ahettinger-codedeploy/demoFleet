<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<%

'Open the Client Import Database
Set dbCustomerImport = Server.CreateObject("ADODB.Connection")
'dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=127.0.0.1\SQL2000; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=sa; Password=p1n3"
dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"

Server.ScriptTimeout = 3600

OrganizationNumber = 2469
CustomerTable = "ALPLMPatrons"
ImportName = "ALPLM Customer Import"

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


SQLOldCust = "SELECT * FROM " & CustomerTable & "(NOLOCK) WHERE CustomerNumber IS NULL ORDER BY CustomerNo"
Set rsOldCust = dbCustomerImport.Execute(SQLOldCust)

Do Until rsOldCust.EOF

	FirstName = Left(rsOldCust("FirstName"),30)
	MiddleInitial = Left(rsOldCust("MiddleInitial"), 1)
'	MiddleInitial = NULL
	LastName = Left(rsOldCust("LastName"),30)
	Address1 = Left(rsOldCust("Address1"),50)
	Address2 = Left(rsOldCust("Address2"),50)
'	Address2 = NULL
	City = Left(rsOldCust("City"),50)
	State = Left(rsOldCust("State"),30)
	PostalCode = Left(rsOldCust("ZipCode"),20)
	Country = "United States"
	DayPhone = Left(rsOldCust("DayPhone"),20)
'	NightPhone = Left(rsOldCust("NightPhone"),20)
	NightPhone = Left(rsOldCust("PhoneSearch"),20)
	EMailAddress = Left(rsOldCust("EMail"),50)
'	EMailAddress = NULL
	Password = NULL
'	If rsOldCust("MailingList") = "N"
'	    OptIn = 0
'	Else
	    OptIn = 1
'	End If
	OldCustomerNumber = rsOldCust("CustomerNo")

	Set spInsertCustomer = Server.Createobject("Adodb.Command")
	Set spInsertCustomer.ActiveConnection = OBJdbConnection
	spInsertCustomer.Commandtype = 4 ' Value for Stored Procedure
	spInsertCustomer.Commandtext = "spInsertCustomer"
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("CustomerNumber", 3, 4) 'As Integer and ParamReturnValue
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("FirstName", 200, 1, 30, FirstName)'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("MiddleInitial", 200, 1, 1, MiddleInitial) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("LastName", 200, 1, 30, LastName) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Address1", 200, 1, 50, Address1) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Address2", 200, 1, 50, Address2) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("City", 200, 1, 50, City) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("State", 200, 1, 30, State) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("PostalCode", 200, 1, 20, PostalCode) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Country", 200, 1, 30, Country) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("DayPhone", 200, 1, 20, DayPhone) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("NightPhone", 200, 1, 20, NightPhone) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("EMailAddress", 200, 1, 50, EMailAddress) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("UserID", 200, 1, 50, EMailAddress) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Password", 200, 1, 10, Password) 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("OptIn", 11, 1, , OptIn) 'As Boolean and Input
	spInsertCustomer.Execute

	CustomerNumber = spInsertCustomer.Parameters("CustomerNumber")

	If CustomerNumber = 0 Then
		Response.Write "Customer " & OldCustomerNumber & " Not Added.<BR>" & vbCrLf
		FailedCount = FailedCount + 1
	Else 
		'Add The Survey Info
		SQLSurvey = "INSERT SurveyAnswers(SurveyNumber, AnswerNumber, CustomerNumber, SurveyDate, Question, Answer) VALUES(" & SurveyNumber & ", 1, " & CustomerNumber & ", '" & Now() & "', '" & ImportName & "', '" & OldCustomerNumber & "')"
		Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
		
		'Add the Mailing List Record for Client
		SQLMailingList = "INSERT CustomerMailingList(CustomerNumber, OrganizationNumber, OptInFlag, DateEntered, DateModified) VALUES(" & CustomerNumber & ", " & OrganizationNumber & ", 'Y', GETDATE(), GETDATE())"
		Set rsMailingList = OBJdbConnection.Execute(SQLMailingList) 
		
		'Add the Mailing List Record for Tix
		SQLMailingList = "INSERT CustomerMailingList(CustomerNumber, OrganizationNumber, OptInFlag, DateEntered, DateModified) VALUES(" & CustomerNumber & ", 1, 'N', GETDATE(), GETDATE())"
		Set rsMailingList = OBJdbConnection.Execute(SQLMailingList) 

		'Update Customer Import Table
		SQLUpdateOldCust = "UPDATE " & CustomerTable & " WITH (ROWLOCK) SET CustomerNumber = " & CustomerNumber & " WHERE CustomerNo = " & OldCustomerNumber
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