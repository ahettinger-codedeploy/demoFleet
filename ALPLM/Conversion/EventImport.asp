<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<%

'Open the Client Import Database
Set dbCustomerImport = Server.CreateObject("ADODB.Connection")
'dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=192.168.1.39; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=WebConnect; Password=Carn1val"
'Test Database Only
dbCustomerImport.Open "Provider=SQLOLEDB; Data Source=192.168.2.24\SQL2005; Initial Catalog=CustomerImport; Network=DBMSSOCN; User ID=TixTest; Password=xitxit"

Server.ScriptTimeout = 3600

OrganizationNumber = 2469
EventTable = "ALPLMEvents"

SQLVenue = "SELECT Venue, Address1, Address2, City, State, Country, PostalCode FROM " & EventTable & " GROUP BY Venue, Address1, Address2, City, State, Country, PostalCode ORDER BY Venue, Address1, Address2, City, State, Country, PostalCode"
Set rsVenue = dbCustomerImport.Execute(SQLVenue)

Do Until rsVenue.EOF
		
    Venue = rsVenue("Venue")
    Address1 = rsVenue("Address1")
    Address2 = rsVenue("Address2")
    City = rsVenue("City"))
    State = rsVenue("State")
    PostalCode = rsVenue("PostalCode")
    Country = rsVenue("Country")
    'Comments = Request("Comments")

	'Insert Venue
	'4/24/2 JAI - Use of Stored Procedure
	Set spInsertVenue = Server.Createobject("Adodb.Command")
	Set spInsertVenue.ActiveConnection = OBJdbConnection
	spInsertVenue.Commandtype = 4 ' Value for Stored Procedure
	spInsertVenue.Commandtext = "spInsertVenue"
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("VenueCode", 3, 4) 'As Integer and ParamReturnValue
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("Venue", 200, 1, 50, Venue) 'As Varchar and Input
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("Address_1", 200, 1, 50, Address1) 'As Varchar and Input
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("Address_2", 200, 1, 50, Address2) 'As Varchar and Input
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("City", 200, 1, 30, City) 'As Varchar and Input
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("State", 200, 1, 20, State) 'As Varchar and Input
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("Zip_Code", 200, 1, 20, PostalCode) 'As Varchar and Input
	spInsertVenue.Parameters.Append spInsertVenue.CreateParameter("Country", 200, 1, 50, Country) 'As Varchar and Input
	spInsertVenue.Execute

	VenueCode = spInsertVenue.Parameters("VenueCode")
	
	'Update Old Venue Record
	SQLUpdateVenue = "UPDATE " & EventTable & " SET VenueCode = " & VenueCode & " WHERE Venue = '" & Venue & "' AND Address1 = '" & Address1 & "' AND Address2 = '" & Address2 & "' AND City = '" & City & "' AND State = '" & State & "' AND PostalCode = '" & PostalCode & "' AND Country = '" & Country & "'"
	Set rsUpdateVenue = dbCustomerImport.Execute(SQLUpdateVenue)

	'Log Venue History After Addition
	SQLVenueHistory = "INSERT VenueHistory SELECT VenueCode, Venue, Address_1, Address_2, City, State, Zip_Code, Country, VenueComments, GETDATE(), 'Add', " & Session("UserNumber") & ", '" & Request.ServerVariables("REMOTE_ADDR") & "' FROM Venue (NOLOCK) WHERE VenueCode = " & VenueCode 
	Set rsVenueHistory = OBJdbConnection.Execute(SQLVenueHistory)

	SQLOrgVenue = "INSERT OrganizationVenue(OrganizationNumber, VenueCode, Owner) VALUES(" & OrganizationNumber & ", " & VenueCode & ", 1)"
	Set rsOrgVenue = OBJdbConnection.Execute(SQLOrgVenue)

	'Add OrganizationVenue Record For Tix
	SQLOrgVenue = "INSERT OrganizationVenue(OrganizationNumber, VenueCode, Owner) VALUES(1, " & VenueCode & ", 0)"
	Set rsOrgVenue = OBJdbConnection.Execute(SQLOrgVenue)

	'Add OrganizationVenue Record For Tix Call Center
	'REE 10/19/5 - Modified to use OrgOption for Tix Call Center entry.
	SQLTixCallCenter = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & " AND OptionName = 'TixCallCenter' AND OptionValue = 'Y'"
	Set rsTixCallCenter = OBJdbConnection.Execute(SQLTixCallCenter)

	If Not rsTixCallCenter.EOF Then
		SQLOrgVenue = "INSERT OrganizationVenue(OrganizationNumber, VenueCode, Owner) VALUES(11, " & VenueCode & ", 0)"
		Set rsOrgVenue = OBJdbConnection.Execute(SQLOrgVenue)
	End If

	rsTixCallCenter.Close
	Set rsTixCallCenter = nothing
	
	VenueCount = VenueCount + 1
	
	rsVenue.MoveNext

Loop

rsVenue.Close
Set rsVenue = nothing

Response.Write "Venues Added: " & VenueCount & "<br />" & vbCrLf


'Add Productions

SQLAct = "SELECT Production FROM " & EventTable & " GROUP BY Production ORDER BY Production"
Set rsAct = dbCustomerImport.Execute(SQLAct)

Do Until rsAct.EOF
		
    Act = rsAct("Production")

	'4/24/2 JAI - Use of Stored Procedure
	Set spInsertAct = Server.Createobject("Adodb.Command")
	Set spInsertAct.ActiveConnection = OBJdbConnection
	spInsertAct.Commandtype = 4 ' Value for Stored Procedure
	spInsertAct.Commandtext = "spInsertAct"
	spInsertAct.Parameters.Append spInsertAct.CreateParameter("ActCode", 3, 4) 'As Integer and ParamReturnValue
	spInsertAct.Parameters.Append spInsertAct.CreateParameter("Act", 200, 1, 150, Left(Act, 150)) 'As Varchar and Input
	spInsertAct.Parameters.Append spInsertAct.CreateParameter("ShortAct", 200, 1, 25, Left(Act, 25)) 'As Varchar and Input
	spInsertAct.Parameters.Append spInsertAct.CreateParameter("Producer", 200, 1, 50, "") 'As Varchar and Input
	spInsertAct.Parameters.Append spInsertAct.CreateParameter("Comments", 200, 1, 3000, "") 'As Varchar and Input
	spInsertAct.Parameters.Append spInsertAct.CreateParameter("CategoryCode", 3, 1, , CategoryCode) 'As Integer and Input
	spInsertAct.Parameters.Append spInsertAct.CreateParameter("SubCategoryCode", 3, 1, , SubCategoryCode) 'As Integer and Input
	spInsertAct.Execute

	ActCode = spInsertAct.Parameters("ActCode")
	
	'Update Old Act Record
	SQLUpdateAct = "UPDATE " & EventTable & " SET ActCode = " & ActCode & " WHERE Production = '" & Act & "'"
	Set rsUpdateAct = dbCustomerImport.Execute(SQLUpdateAct)

	'Log Act History After Addition
	SQLActHistory = "INSERT ActHistory SELECT ActCode, Act, ShortAct, Producer, Comments, CategoryCode, SubCategoryCode, GETDATE(), 'Add', " & Session("UserNumber") & ", '" & Request.ServerVariables("REMOTE_ADDR") & "' FROM Act (NOLOCK) WHERE ActCode = " & ActCode 
	Set rsActHistory = OBJdbConnection.Execute(SQLActHistory)

	SQLOrgAct = "INSERT OrganizationAct(OrganizationNumber, ActCode) VALUES(" & OrganizationNumber & ", " & ActCode & ")"
	Set rsOrgAct = OBJdbConnection.Execute(SQLOrgAct)

	'Add OrganizationAct Record For Tix
	SQLOrgAct = "INSERT OrganizationAct(OrganizationNumber, ActCode) VALUES(1, " & ActCode & ")"
	Set rsOrgAct = OBJdbConnection.Execute(SQLOrgAct)

	'Add OrganizationAct Record For Tix Call Center
	'REE 10/19/5 - Modified to use OrgOption for Tix Call Center entry.
	SQLTixCallCenter = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & " AND OptionName = 'TixCallCenter' AND OptionValue = 'Y'"
	Set rsTixCallCenter = OBJdbConnection.Execute(SQLTixCallCenter)

	If Not rsTixCallCenter.EOF Then
		SQLOrgAct = "INSERT OrganizationAct(OrganizationNumber, ActCode) VALUES(11, " & ActCode & ")"
		Set rsOrgAct = OBJdbConnection.Execute(SQLOrgAct)
	End If

	rsTixCallCenter.Close
	Set rsTixCallCenter = nothing
	
	ActCount = ActCount + 1
	
	rsAct.MoveNext

Loop

rsAct.Close
Set rsAct = nothing

Response.Write "Productions Added: " & ActCount & "<br />" & vbCrLf

'Add Events

SQLEvent = "SELECT ActCode, VenueCode, EventDate, Production FROM " & EventTable & " ORDER BY OldEventCode"
Set rsEvent = dbCustomerImport.Execute(SQLEvent)

Do Until rsEvent.EOF

    ActCode = rsEvent("ActCode")
    VenueCode = rsEvent("VenueCode")
    EventDate = rsEvent("EventDate")
    URL = ""
    Capacity = 10
    Map = "general"
    Comments = ""
    StartDate = "1/1/2000"
    EndDate = "1/1/2000"
    OnSale = 0
    Phone = ""
    EMailAddress = ""

	'Add Event
	'4/24/2 JAI - Use of Stored Procedure
	Set spInsertEvent = Server.Createobject("Adodb.Command")
	Set spInsertEvent.ActiveConnection = OBJdbConnection
	spInsertEvent.Commandtype = 4 ' Value for Stored Procedure
	spInsertEvent.Commandtext = "spInsertEvent"
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("EventCode", 3, 4) 'As Integer and ParamReturnValue
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("ActCode", 3, 1, , ActCode) 'As Integer and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("VenueCode", 3, 1, , VenueCode) 'As Integer and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("EventDate", 135, 1, 30, EventDate) 'As dbTimeStamp and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("URL", 200, 1, 100, URL) 'As Varchar and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("Capacity", 3, 1, , Capacity) 'As Varchar and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("map", 200, 1, 30, Map) 'As Varchar and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("Comments", 200, 1, 2000, Comments) 'As Varchar and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("SaleStartDate", 135, 1, 20, StartDate) 'As dbTimeStamp and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("SaleEndDate", 135, 1, 30, EndDate) 'As dbTimeStamp and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("OnSale", 11, 1, , 0) 'As Boolean and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("Phone", 200, 1, 50, Phone) 'As Varchar and Input
	spInsertEvent.Parameters.Append spInsertEvent.CreateParameter("EMailAddress", 200, 1, 50, EMailAddress) 'As Varchar and Input
	spInsertEvent.Execute

	EventCode = spInsertEvent.Parameters("EventCode")
	
	'Update Old Event Record
	SQLUpdateEvent = "UPDATE " & EventTable & " SET EventCode = " & EventCode & " WHERE OldEventCode = " & rsEvent("OldEventCode")
	Set rsUpdateEvent = dbCustomerImport.Execute(SQLUpdateEvent)

	'Log Event History After Addition
	SQLLogEventMod = "INSERT EventHistory SELECT EventCode, ActCode, VenueCode, EventDate, URL, Capacity, Map, EventType, Comments, SaleStartDate, SaleEndDate, OnSale, Phone, Fax, EMailAddress, SurveyNumber, SelectTicketsButton, BestAvailableButton, GETDATE(), 'Add', " & Session("UserNumber") & ", '" & Request.ServerVariables("REMOTE_ADDR") & "' FROM Event (NOLOCK) WHERE EventCode = " & EventCode 
	Set rsLogEventMod = OBJdbConnection.Execute(SQLLogEventMod)

OBJdbConnection.Close
Set OBJdbConnection = nothing

'dbCustomerImport.Close
'Set dbCustomerImport = nothing

%>