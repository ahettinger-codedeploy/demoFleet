<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<%

Server.ScriptTimeout = 3600

SQLOldCust = "SELECT * FROM ColonnadeCustomers WHERE CustomerNumber IS NULL ORDER BY OldCustomerNumber"
Set rsOldCust = OBJdbConnection.Execute(SQLOldCust)

Do Until rsOldCust.EOF

	FirstName = Left(rsOldCust("FirstName"),30)
	MiddleInitial = NULL
	LastName = Left(rsOldCust("LastName"),30)
	Address1 = Left(rsOldCust("Address1"),50)
	Address2 = NULL
	City = Left(rsOldCust("City"),50)
	State = Left(rsOldCust("State"),30)
	PostalCode = Left(rsOldCust("PostalCode"),20)
	Country = "United States"
	DayPhone = Left(rsOldCust("Phone"),20)
	NightPhone = Left(rsOldCust("Phone"),20)
	EMailAddress = Left(rsOldCust("EMailAddress"),20)
	OptIn = 1
	OldCustomerNumber = rsOldCust("OldCustomerNumber")

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
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Password", 200, 1, 10, "ColonnadeI") 'As Varchar and Input
	spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("OptIn", 11, 1, , OptIn) 'As Boolean and Input
	spInsertCustomer.Execute

	CustomerNumber = spInsertCustomer.Parameters("CustomerNumber")

	If CustomerNumber = 0 Then
		Response.Write "Customer " & OldCustomerNumber & " Not Added.<BR>" & vbCrLf
	Else 
		'Add The Survey Info
		SQLSurvey = "INSERT SurveyAnswers(SurveyNumber, AnswerNumber, CustomerNumber, SurveyDate, Answer) VALUES(68, 1, " & CustomerNumber & ", '" & Now() & "', '" & OldCustomerNumber & "')"
		Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
		
		'Update Customer Import Table
		SQLUpdateOldCust = "UPDATE ColonnadeCustomers SET CustomerNumber = " & CustomerNumber & " WHERE OldCustomerNumber = " & OldCustomerNumber
		Set rsUpdateOldCust = OBJdbConnection.Execute(SQLUpdateOldCust)
			
	End If


	rsOldCust.MoveNext

Loop

%>