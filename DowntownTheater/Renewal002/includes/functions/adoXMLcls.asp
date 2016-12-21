<%

'----------------------------------------------------------------------------------------------------------------------------------------------------------
 'adoXMLcls
'----------------------------------------------------------------------------------------------------------------------------------------------------------
'
'	adoXMLCls is a free asp class library used for reading and extracting data from a xml file.
'
'	Copyright	: (C) 2004 adSoft.nl
'	Website		: www.adsoft.nl
'	E-mail		: support@adsoft.nl
'
'This program is free software; you can redistribute it and/or
'modify it under the terms of the GNU General Public License
'as published by the Free Software Foundation; either version 2
'of the License, or (at your option) any later version.

'----------------------------------------------------------------------------

Class adoXMLcls

	Private strXMLPath
	Private strXML
	Private IsConnected
	Private intNewPos
	Public intNumAttributes

	Public objXML
	Public strXMLError
	Public intNumChildNodes
	Public intNumNodes

'--------------------------------------------------------------------

	Private Sub Class_Initialize()
	
		IsConnected = False
		intNewPos   = 1
		
	End Sub
	
'--------------------------------------------------------------------

	Private Sub Class_Terminate()
	
		Set objXML = Nothing
		
	End Sub
	
'--------------------------------------------------------------------

	Public Sub Open(path)
	
		strXMLPath = path
		Set objXML = Server.CreateObject("Msxml2.DOMDocument.6.0")

		objXML.async = False
		objXML.Load (strXMLPath)
		
		If objXML.parseError.errorCode <> 0 Then
			strXMLError = objXML.parseError.reason
			CheckConnectionState
			Exit Sub
		End If
		
		IsConnected = True
		objXML.setProperty "SelectionLanguage", "XPath"
		
	End Sub
	
'--------------------------------------------------------------------
	
	Public Sub Close()
	
		strXMLError = "Connection closed."
		IsConnected = False
		Set objXML = Nothing
		
	End Sub
	
'--------------------------------------------------------------------

	Private Sub CheckConnectionState()
	
		If Not IsConnected Then
			Response.Clear
			Response.Write "Error: " & strXMLError
			Response.End
		End If
		
	End Sub
	
'--------------------------------------------------------------------

	Public Sub DeleteNodes(xpath)
	
		CheckConnectionState()

		Dim objDelete
		For Each objDelete In objXML.documentElement.selectNodes(xpath)
			objXML.documentElement.removeChild objDelete
		Next
		objXML.Save strXMLPath
		Set objDelete = Nothing
		
	End Sub
	
'--------------------------------------------------------------------

	Public Property Get GetNode(xpath)
	
		CheckConnectionState()
		
		if not objXML.selectSingleNode(xpath) is nothing then
			GetNode = objXML.selectSingleNode(xpath).Text
		else
			GetNode = "getNode failed"
		end if
		
	End Property
	
'--------------------------------------------------------------------

	Public Property Get GetNodeAttribute(xpath, name)
	
		CheckConnectionState()
		GetNodeAttribute = objXML.selectSingleNode(xpath).Attributes.getNamedItem(name).Text
		
	End Property

'--------------------------------------------------------------------

	Public Property Get GetNodesArray(xpath, ByVal arrNodes)
		CheckConnectionState()

		Dim objNodeList, i, j
		Set objNodeList = objXML.documentElement.selectNodes(xpath)
		intNumNodes = objNodeList.length
		If intNumNodes > 0 Then
			intNumChildNodes = objNodeList.item(0).childNodes.Length

			ReDim arrNodes(intNumNodes, intNumChildNodes)
			For i = 0 To intNumNodes-1
				For j = 0 To intNumChildNodes-1
					arrNodes(i,j) = objNodeList.item(i).childNodes.Item(j).Text
				Next
			Next
		Else
			ReDim arrNodes(0)
		End If
		Set objNodeList = Nothing
		GetNodesArray = arrNodes
		
	End Property
	
'----------------------------------------------------------------------------

	Public Property Get GetAttributesArray(xpath, ByVal arrNodes)
		CheckConnectionState()

		Dim objNodeList, i, j
		Set objNodeList = objXML.documentElement.selectNodes(xpath)
		intNumNodes = objNodeList.length
		If intNumNodes > 0 Then
			intNumAttributes = objNodeList.item(0).Attributes.Length

			ReDim arrNodes(intNumNodes, intNumAttributes)
			For i = 0 To intNumNodes-1
				For j = 0 To intNumAttributes-1
					arrNodes(i,j) = objNodeList.item(i).Attributes.Item(j).Text
				Next
			Next
		Else
			ReDim arrNodes(0)
		End If
		Set objNodeList = Nothing
		GetAttributesArray = arrNodes
	End Property
	
'----------------------------------------------------------------------------

	Public Function NewID(counter)
	
		Dim objID, intNewID, objIDChild
		Set objID = objXML.documentElement.selectNodes(counter)

		If objID.length = 1 Then
			intNewID = CInt(ObjID.item(0).Text) + 1
			objID.item(0).Text = intNewID
		Else
			intNewID = 1
			Set objIDChild  = objXML.createNode("element", counter, "")
			objIDChild.Text = CStr(1)

			objXML.documentElement.appendChild(objIDChild)
			Set objIDChild = Nothing
		End If
		objXML.Save strXMLPath

		Set objIDChild = Nothing
		Set objID = Nothing
		NewID = intNewID
		
	End Function

	
'----------------------------------------------------------------------------
	
End Class	


%>
