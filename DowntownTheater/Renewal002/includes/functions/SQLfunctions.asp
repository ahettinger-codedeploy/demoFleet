<%

'includeSQL - include the following functions for local host

'-------------------------------------------------
	
PUBLIC FUNCTION fnOrgName

If Session("OrganizationNumber") = 2266 Then
	OrgName = "Downtown Theater"
End If

fnOrgName = OrgName

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetActSuffix(EventCode)

	SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & EventCode & " AND OptionName = 'ActSuffix'"
	Set rsActSuffix = OBJdbConnection.Execute(SQLActSuffix)

		If Not rsActSuffix.EOF Then 
			ActSuffix = " - " & rsActSuffix("ActSuffix")
		Else
			ActSuffix = ""
		End If

	rsActSuffix.Close
	Set rsActSuffix = nothing
	
	GetActSuffix = ActSuffix
	
END FUNCTION

'--------------------------------

FUNCTION GetOrgNumber

	If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
		Response.Redirect("/Management/Default.asp")
	Else
		GetOrgNumber = Session("OrganizationNumber")
	End If
	
END FUNCTION

'-------------------------------------------------
	
PUBLIC FUNCTION fnOrgName

SQLThisOrg = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
	OrgName = rsThisOrg("Organization") 
rsThisOrg.Close
Set rsThisOrg = Nothing

fnOrgName = OrgName

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnClientFolder

DIM strResults
strResults = ""

SQLSearch = "SELECT OptionValue FROM OrganizationOptions WITH (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'ClientFolder'"
Set rsSearch = OBJdbConnection.Execute(SQLSearch)
If NOT rsSearch.EOF Then
	strResults = rsSearch("OptionValue")
End If
rsSearch.Close
Set rsSearch = nothing

fnClientFolder = strResults

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnPrivateLabel

OrgNumbr = Session("OrganizationNumber")

DIM strTemp
strTemp = ""

SQLVenueRefCheck = "SELECT VenueCode, OptionName, OptionValue FROM VenueOptions WITH (NOLOCK) WHERE VenueCode = (SELECT TOP 1 VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" & OrgNumbr & "') AND (OptionName = 'VenueReference')"
Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
If NOT rsVenueRefCheck.EOF Then
	strTemp = rsVenueRefCheck("OptionValue")
End If
rsVenueRefCheck.Close
Set rsVenueRefCheck = nothing

fnPrivateLabel = strTemp

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnTixUser

	Dim strResult
	strResult = FALSE

		SQLOrgUsers = "Select UserNumber FROM Users (NOLOCK) WHERE OrganizationNumber = 1 AND UserNumber = " & Session("UserNumber") & ""
		Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

			If NOT rsOrgUsers.EOF Then
				strResult = TRUE
			End If
			
		rsOrgUsers.Close
		Set rsOrgUsers = Nothing

		fnTixUser = strResult

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnUserEmails(OrgNumbr)

	'Generates an email address list for users  associated with the organization

	thisUserNumber = Session("UserNumber")

	DIM status
	status = ""

	SQLOrgUsers = "SELECT UserNumber, FirstName, LastName, EMailAddress, Status FROM Users (NOLOCK) WHERE OrganizationNumber = " &  OrgNumbr & " AND Status = 'A' AND USERS.EMailAddress is not null and len(USERS.EMailAddress) > 1"
	Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

		If Not rsOrgUsers.EOF Then 
			Do Until rsOrgUsers.EOF
			
				If rsOrgUsers("UserNumber") = Session("UserNumber") Then
					status="selected"
				Else
					status=""
				End If
				
				Name ="<option value="" " & rsOrgUsers("EMailAddress") & " "" >" & rsOrgUsers("FirstName") & "&nbsp;" & rsOrgUsers("LastName") & "&nbsp;(" & rsOrgUsers("EMailAddress") & ")</option>"							
				
				UserEmailList = UserEmailList & "," & Name
				
			rsOrgUsers.MoveNext
			Loop
		End If	

	rsOrgUsers.Close
	Set rsOrgUsers = Nothing

	UserEmailList = trimComma(UserEmailList)
	
	fnUserEmails = UserEmailList

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnGetAct(Eventcode)

		SQLActLookUp = "SELECT Act.Act, Event.ActCode FROM Event (NOLOCK) INNER JOIN ACT ON Event.ActCode = Act.ActCode WHERE EventCode = " & EventCode & ""
		Set rsActLookUp = OBJdbConnection.Execute(SQLActLookUp)			
			ThisAct = rsActLookUp("Act")
		rsActLookUp.Close
		Set rsActLookUp = nothing
	
		fnGetAct = ThisAct
	
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnGetActCode(Eventcode)

DIM strResults
strResults = ""

		SQLActLookUp = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
		Set rsActLookUp = OBJdbConnection.Execute(SQLActLookUp)			
			strResults = rsActLookUp("ActCode")
		rsActLookUp.Close
		Set rsActLookUp = nothing
	
		fnGetActCode = strResults
	
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnActSuffix(Eventcode)

DIM strResults
strResults = ""

SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & EventCode & " AND OptionName = 'ActSuffix'"
Set rsActSuffix = OBJdbConnection.Execute(SQLActSuffix)
	If Not rsActSuffix.EOF Then 
		strResults = " - " & rsActSuffix("ActSuffix")
	End If
rsActSuffix.Close
Set rsActSuffix = nothing

fnActSuffix = strResults

END FUNCTION

'--------------------------------

PUBLIC FUNCTION fnGetMap(Eventcode)

		SQLMapLookUp = "SELECT Event.Map FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
		Set rsMapLookUp = OBJdbConnection.Execute(SQLMapLookUp)			
			ThisMap = rsMapLookUp("Map")
		rsMapLookUp.Close
		Set rsMapLookUp = nothing
	
		fnGetMap = ThisMap
	
END FUNCTION

'--------------------------------

PUBLIC FUNCTION FormatDate(EventDate,Format)

'Format Standard Event Date

Select Case Format
	Case "WEEKDAY"
		FormatDate = WeekDayName(Weekday(EventDate))
	Case "UPPERWEEKDAY"
		FormatDate = Ucase(WeekDayName(Weekday(EventDate)))
	Case "WEEKDAY3"
		FormatDate = Left(WeekDayName(Weekday(EventDate)),3)
	Case "DAY"
		FormatDate = Day(EventDate)
	Case "MONTH"
		FormatDate = MonthName(Month(EventDate))
	Case "MONTH3"
		FormatDate = Left(MonthName(Month(EventDate)),3)
	Case "YEAR"
		FormatDate = Year(EventDate)
	Case "LONGDATE"
		FormatDate = FormatDateTime(EventDate, vbLongDate)
	Case "UPPERLONGDATE"
		FormatDate = UCase(FormatDateTime(EventDate, vbLongDate))
	Case "MEDIUMDATE"
		FormatDate = Monthname(Month(EventDate)) & " " & Day(EventDate) & ", " &  Year(EventDate)
	Case "SHORTDATE"
		FormatDate = FormatDateTime(EventDate, vbShortDate)
	Case "TIME"
		FormatDate = Left(FormatDateTime(EventDate,vbLongTime),Len(FormatDateTime(EventDate,vbLongTime))-6) & Right(FormatDateTime(EventDate,vbLongTime),3)
	Case "MEDIUMDATE-TIME"
		FormatDate = Monthname(Month(EventDate)) & " " & Day(EventDate)  & ", " &  Year(EventDate) & " at " & Left(FormatDateTime(EventDate,vbLongTime),Len(FormatDateTime(EventDate,vbLongTime))-6) & Right(FormatDateTime(EventDate,vbLongTime),3)
End Select
		

END FUNCTION

'--------------------------------

FUNCTION GetWKDAY(EventCode)

	'Returns MONDAY, TUESDAY, etc from EventCode

	SQLEventDate = "SELECT Event.EventDate FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
	Set rsEventDate = OBJdbConnection.Execute(SQLEventDate)			
		GetWKDAY = UCase(WeekDayName(WeekDay((rsEventDate ("EventDate")))))
	rsEventDate.Close
	Set rsEventDate = nothing
	
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetDate(Eventcode,Format)

DIM strDate
DIM strFormatedDate

		SQLDateLookUp = "SELECT Event.EventDate FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
		Set rsDateLookUp = OBJdbConnection.Execute(SQLDateLookUp)			
			strDate = rsDateLookUp("EventDate")
		rsDateLookUp.Close
		Set rsDateLookUp = nothing
		
		strFormatedDate = FormatDate(strDate,Format)
	
		GetDate = strFormatedDate
	
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetDOW(DateNumber)

	Select Case DateNumber
		Case 6
		DOW = "Friday"
		Case 7
		DOW = "Saturday"
	End Select

	GetDow = DOW

END FUNCTION

'--------------------------------

PUBLIC FUNCTION GetVenueName(Venuecode)

		SQLVenueLookUp = "SELECT Venue.Venue FROM Venue (NOLOCK) WHERE VenueCode = " & VenueCode & ""
		Set rsVenueLookUp = OBJdbConnection.Execute(SQLVenueLookUp)			
			ThisVenue = rsVenueLookUp("Venue")
		rsVenueLookUp.Close
		Set rsVenueLookUp = nothing
	
		GetVenueName = ThisVenue
	
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnOrgUsers(OrgNumbr)

	'Generate complete list of users associated with this organization

	DIM UserDetail
	UserDetail = ""
	
	DIM UserList
	UserList = ""
	
	SQLOrgUsers = "SELECT  UserNumber, FirstName, LastName, EMailAddress, Status FROM Users (NOLOCK) WHERE OrganizationNumber = " &  OrgNumbr & ""
	Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

		If Not rsOrgUsers.EOF Then 

			Do Until rsOrgUsers.EOF

				UserDetail = "" & rsOrgUsers("UserNumber") & "|" & rsOrgUsers("FirstName") & "|" & rsOrgUsers("LastName") & "|" & rsOrgUsers("EMailAddress") & "|" & rsOrgUsers("Status") & ""
												
				UserList = UserList & "," & UserDetail
			
			rsOrgUsers.MoveNext
			Loop

		End If	

	rsOrgUsers.Close
	Set rsOrgUsers = Nothing

	UserList = trimComma(UserList)
	
	fnOrgUsers = UserList

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnUserName(UserNumbr)
	
	SQLOrgUsers = "SELECT  UserNumber, FirstName, LastName, EMailAddress, Status FROM Users (NOLOCK) WHERE UserNumber = " &  UserNumbr & ""
	Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

		If Not rsOrgUsers.EOF Then 
				fnUserName = rsOrgUsers("FirstName") & " &nbsp;" & rsOrgUsers("LastName") 										
		Else
				fnUserName = "User Number Unknown"
		End If

	rsOrgUsers.Close
	Set rsOrgUsers = Nothing
	
END FUNCTION

'-------------------------------------------------

FUNCTION FindMissingPL(OrgName)

	'remove common words
	DIM string_find(4)
	string_find(1) = "theater"
	string_find(2) = ","
	string_find(3) = "."
	string_find(4) = "inc"
	
	string_replace = ""

	For i =  LBound(string_find) to UBound(string_find)
		OrgName = Replace(OrgName,string_find(i),string_replace,1,1,1)
	Next

	OrgNameArray = Split(OrgName," ")

	For i =  LBound(OrgNameArray) to UBound(OrgNameArray)

		If Len(OrgNameArray(i)) > 0 Then

			SQLVenueRefCheck = "select VenueCode, OptionName, OptionValue as URL from venueoptions where (optionname = 'venuereference' and optionvalue LIKE '%" & OrgNameArray(i) & "%' ) and venuecode NOT in (select venuecode from venueoptions where optionname = 'organizationnumber') "
			Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)

					Do Until rsVenueRefCheck.EOF
						PrivateLabelList2 = PrivateLabelList2 & "," & rsVenueRefCheck("URL")
					rsVenueRefCheck.MoveNext
					Loop

			rsVenueRefCheck.Close
			Set rsVenueRefCheck = nothing

		End If

	Next

	PrivateLabelList2 = trimComma(PrivateLabelList2)
	
	FindMissingPL = PrivateLabelList2
			
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnOrgTimeZone

	DIM TimeZone
	DIM UTCOffset

	SQLVerifyEvent = "SELECT Organization, OrganizationNumber FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
	Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

	If NOT rsVerifyEvent.EOF Then 

		SQLVerifyOption = "SELECT OptionName FROM OrganizationOptions WHERE OrganizationOptions.OptionName = 'TimeZoneOffset' AND OrganizationOptions.OrganizationNumber  = " &  rsVerifyEvent("OrganizationNumber")  & ""
		Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

			If NOT rsVerifyOption.EOF Then     
	 
					SQLCustomText= "SELECT OptionValue FROM OrganizationOptions WHERE OrganizationOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND OrganizationOptions.OrganizationNumber = " &  rsVerifyEvent("OrganizationNumber")  & ""
					Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

						 If rsCustomText("OptionValue") <> "" Then 
							TimeZoneOffset = rsCustomText("OptionValue")
							Select Case TimeZoneOffset
								Case "-240"
								TimeZone = "Atlantic"
								Case "-300"
								TimeZone = "Eastern" 
								Case "-360"
								TimeZone = "Central"
								Case "-420"
								TimeZone = "Mountain"    
								Case "-480"
								TimeZone = "Pacific"
								Case "-540"
								TimeZone = "Alaska"
								Case "-600"
								TimeZone = "Hawaii"
								Case Else
								TimeZone = "ERROR"
							End Select
							'Standard Time
							UTCOffset = ((TimeZoneOffset + 0) / 60)
							'Daylaight Savings Time
							'UTCOffset = ((TimeZoneOffset + 60) / 60)
						 End If
		 
				rsCustomText.Close
				Set rsCustomText = nothing

			End If	

	End If	
			
	rsVerifyOption.Close
	Set rsVerifyOption = nothing

	rsVerifyEvent.Close
	Set rsVerifyEvent = nothing
	
	fnOrgTimeZone = TimeZone

END FUNCTION

'-------------------------------------------------
%>
