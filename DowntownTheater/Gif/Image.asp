<%
' Dynamic GIF Image Script

' Created by Lewis Moten
' on April 30, 2001
' Email lewis@moten.com
' URL http://www.lewismoten.com

' This script loads a text file that defines a GIF image
' and creates a dynamic color palette for it based on the
' color you define.
'
' FirstHex: The beginning hex color
' LastHex: The ending hex color
' Src: The source file to load (Required)
' Debug: Displays success/failure messages along with HEX data in image

' examples:
' Image.asp?FirstHex=FFFFFF&LastHex=000000&Src=GoButton.txt
' Image.asp?FirstHex=FFFFFF&LastHex=000000&Src=/GoButton.txt
' Image.asp?FirstHex=FFFFFF&LastHex=000000&Src=C:\GoButton.txt
' Image.asp?FirstHex=FFFFFF&LastHex=000000&Src=GoButton.txt&Debug=True

' If errors occur - a transparent image will be returned.

Option Explicit

Dim gStrTransparent		' Transparent Image Hex Data
Dim gStrData			' Data loaded from file

' Define the transparent image
gStrTransparent = _
	"4749463839610100010080FF00C63535" & _
	"00000021F90401000000002C00000000" & _
	"010001000002024401003B"

Call Main()
' ------------------------------------------------------------------------------
Sub Main()
	
	Dim lStrSRC				' Source of Image
	Dim lStrDataAry			' Array of template image data
	Dim lStrPalette			' Palette colors delimited by semicolins ";"
	Dim lStrPaletteAry		' Palette color array
	Dim lLngColors			' Number of colors in image
	Dim lStrFirstHex		' First color in color range
	Dim lStrLastHex			' Last color in color range
	Dim lStrTemplate		' Template containing hex image data
	Dim lLngIndex			' Loop Counter
	
	' Grab user defined information
	lStrSRC = Request.QueryString("SRC")
	lStrFirstHex = Request.QueryString("FirstHex")
	lStrLastHex = Request.QueryString("LastHex")

	' Validate Colors
	lStrFirstHex = ValidColor(lStrFirstHex)
	lStrLastHex = ValidColor(lStrLastHex)
	
	' If the image was not defined
	If lStrSRC = "" Then
		
		' Return a transparent image
		Call ReturnImage(gStrTransparent, "File Not Specified")
		Exit Sub
	
	End If
	
	' If the image template could not be loaded
	If Not Load(lStrSRC) Then
		
		' Return a transparent image
		Call ReturnImage(gStrTransparent, "File Not Found")
		Exit Sub
		
	End If

	' Parse information from template data
	lStrDataAry = Split(gStrData, ";",4)
	lLngColors		= CInt(lStrDataAry(0))
	lStrTemplate	= lStrDataAry(3)

	' Get default colors if user didn't specify them
	If lStrFirstHex = "" Then lStrFirstHex = lStrDataAry(1)
	If lStrLastHex = "" Then lStrLastHex = lStrDataAry(2)
	
	' Create a custom palette based off the two colors specified
	lStrPalette = DefinePalette(lLngColors, lStrFirstHex, lStrLastHex)
	
	' If palette is empty
	If lStrPalette = "" Then
		
		' Return a transparent image
		Call ReturnImage(gStrTransparent, "Palette Not Defined")
		Exit Sub
		
	End If
	
	' Split the palette colors into an array
	lStrpaletteAry = Split(lStrPalette, ";", lLngColors)
	
	' Insert each color into the image hex data
	For lLngIndex = 1 To lLngColors
		lStrTemplate = Replace(lStrTemplate, "[" & lLngIndex & "]", lStrPaletteAry(lLngIndex -1))
	Next
	
	' Return the custom image
	Call ReturnImage(lStrTemplate, "Success")
	
End Sub
' ------------------------------------------------------------------------------
Function ValidColor(ByVal pStrColor)

	' function returns empty variable if an invalid color is specified

	Dim lLngIndex	' Loop Counter
	
	' Remove Hex Identifiers
	pStrColor = Replace(pStrColor, "#", "")
	pStrColor = Replace(pStrColor, "0x", "", 1, -1, vbTextCompare)
	
	' Hex must be 6 characters long
	If Not Len(pStrColor) = 6 Then Exit Function
	
	' Loop through each character
	For lLngIndex = 1 To 6
		
		' Make sure the character is a hex character
		If InStr(1, "0123456789ABCDEF", Mid(pStrColor, lLngIndex, 1), vbTextCompare) = 0 Then
			Exit Function
		End If
	
	Next
	
	' If we made it this far, return the original color
	ValidColor = pStrColor
	
End Function
' ------------------------------------------------------------------------------
Function Load(ByRef pStrSRC)

	Dim lObjFSO		' File Scripting Object
	Dim lStrData	' Data loaded from file
	Dim lStrPath	' Path to load data
	
	' If physical location wasn't defined
	If InStr(1, pStrSrc, ":\") = 0 Then

		' (Assume Source is a URL)
		' Convert url to physical path
		lStrPath = Server.MapPath(pStrSrc)

	Else
	
		' Copy source to path
		lStrPath = pStrSrc
	
	End If
	
	' Load data from source
	Set lObjFSO = Server.CreateObject("Scripting.FileSystemObject")
	If lObjFSO.FileExists(lStrPath) Then
		gStrData = lObjFSO.OpenTextFile(lStrPath).ReadAll
		Load = True
	Else
		Load = False
	End If
	Set lObjFSO = Nothing
	
	' Remove spaces, tabs, line feeds, and chariage returns
	gStrData = Replace(gStrData, " ", "")
	gStrData = Replace(gStrData, vbTab, "")
	gStrData = Replace(gStrData, vbCr, "")
	gStrData = Replace(gStrData, vbLf, "")

End Function
' ------------------------------------------------------------------------------
Function DefinePalette(ByRef pLngColors, pStrFirstHex, pStrLastHex)

	Dim lDblPhaseAry	' Array Percentages to increase color based on index
	Dim lBytRedAry		' Red values of colors at specified indexex
	Dim lBytGreenAry	' Green values of colors at specified indexex
	Dim lBytBlueAry		' Blue values of colors at specified indexex
	Dim lLngIndex		' Loop Counter
	Dim lStrPaletteAry	' Palette of color range
	
	' Create empty arrays
	lDblPhaseAry	= Split(String(pLngColors -1, ","), ",")
	lBytRedAry		= Split(String(pLngColors -1, ","), ",")
	lBytGreenAry	= Split(String(pLngColors -1, ","), ",")
	lBytBlueAry		= Split(String(pLngColors -1, ","), ",")
	lStrPaletteAry	= Split(String(pLngColors -1, ","), ",")		
	
	' Define percentages of color to
	' increase to next color
	lDblPhaseAry(0) = 0
	For lLngIndex = 1 To pLngColors - 2
		lDblPhaseAry(lLngIndex) = (lLngIndex * ((256/pLngColors)/256))
	Next
	lDblPhaseAry(pLngColors - 1) = 1
	
	' Initialize First Color
	lBytRedAry(0) = CInt("&h" & Left(pStrFirstHex, 2))
	lBytGreenAry(0) = CInt("&h" & Mid(pStrFirstHex, 3, 2))
	lBytBlueAry(0) = CInt("&h" & Right(pStrFirstHex, 2))

	' Initialize Last Color
	lBytRedAry(pLngColors - 1) = CInt("&h" & Left(pStrLastHex, 2))
	lBytGreenAry(pLngColors - 1) = CInt("&h" & Mid(pStrLastHex, 3, 2))
	lBytBlueAry(pLngColors - 1) = CInt("&h" & Right(pStrLastHex, 2))

	' Loop through all other color
	For lLngIndex = 1 To pLngColors - 2
		' Calculate Primary Color Values Based on Index between first and last colors
		lBytRedAry(lLngIndex) = lBytRedAry(0) + ((lBytRedAry(pLngColors - 1) - lBytRedAry(0)) * lDblPhaseAry(lLngIndex))
		lBytGreenAry(lLngIndex) = lBytGreenAry(0) + ((lBytGreenAry(pLngColors - 1) - lBytGreenAry(0)) * lDblPhaseAry(lLngIndex))
		lBytBlueAry(lLngIndex) = lBytBlueAry(0) + ((lBytBlueAry(pLngColors - 1) - lBytBlueAry(0)) * lDblPhaseAry(lLngIndex))
		
		' Compile colors into Hex Value
		lStrPaletteAry(lLngIndex) = _
			Right("0" & Hex(lBytRedAry(lLngIndex)), 2) & _
			Right("0" & Hex(lBytGreenAry(lLngIndex)), 2) & _
			Right("0" & Hex(lBytBlueAry(lLngIndex)), 2)
	Next

	' Compile First Color Hex Value
	lStrPaletteAry(0) = _
		Right("0" & Hex(lBytRedAry(0)), 2) & _
		Right("0" & Hex(lBytGreenAry(0)), 2) & _
		Right("0" & Hex(lBytBlueAry(0)), 2)

	' Compile Last Color Hex Value
	lStrPaletteAry(pLngColors - 1) = _
		Right("0" & Hex(lBytRedAry(pLngColors - 1)), 2) & _
		Right("0" & Hex(lBytGreenAry(pLngColors - 1)), 2) & _
		Right("0" & Hex(lBytBlueAry(pLngColors - 1)), 2)

	' Return palette colors as a string delimited with semicolins.
	DefinePalette = Join(lStrPaletteAry, ";")
	
End Function
' ------------------------------------------------------------------------------
Sub ReturnImage(ByRef pStrImage, ByRef pStrDebug)

	Dim lLngMaxIndex	' Max Hex Bytes in Image Data
	Dim lLngIndex		' Loop Counter
	
	' If user is debugging the process
	If LCase(Request.QueryString("Debug")) = "true" Then
		
		' Write out debug message
		Response.Write("Debug: " & pStrDebug & "<BR>")
		
		' Write out Hex Data
		Response.Write("Hex Data:<PRE>")
		For lLngIndex = 1 To Len(pStrImage) Step 2
			Response.Write(Mid(pStrImage, lLngIndex, 2) & " ")
			If (lLngIndex + 1) Mod 32 = 0 Then Response.Write(vbCrLf)
		Next
		Response.Write("</PRE>")
	Else
		
		' Tell the browser what kind of datastream we are sending it
		Response.ContentType = "image/gif"

		' Find out how many bytes are in the image data		
		lLngMaxIndex = Len(pStrImage) \ 2
		
		' Loop through each hex byte
		For lLngIndex = 1 To lLngMaxIndex
			' Convert the current hex byte as a
			' Real Byte and write it to the client
			Response.BinaryWrite(ChrB("&h" & Mid(pStrImage, ((lLngIndex - 1) * 2) + 1, 2)))
		Next
	End If
End Sub
' ------------------------------------------------------------------------------
%>