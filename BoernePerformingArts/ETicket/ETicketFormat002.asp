<%

'CHANGE LOG - Update
'SSR 12/5/2011
'Boerne Performing Arts
'Proper Case Spelling of Billing and Shipping Name
'Added ShortAct and Producer options

'CHANGE LOG - Update
'SSR 10/4/2011
'George Little Management
'Date/Time Supress - E-Ticket will supress date/time if the event does.

'CHANGE LOG - Update
'SSR 8/11/2011
'Downtown Theater
'Case Statement - ticket will automatcially switch between GA and Rsvd formats 

'CHANGE LOG - Update
'SSR 6/24/2011
'Downtown Theater
'Ticket count added

%>

<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

'===============================================

'E-Ticket Options

'Boerne Performing Arts

'Display Custom Logo Upper Right
'for default logo set variable to blank
CustomETicketLogo = "/Clients/BoernePerformingArts/ETicket/Images/ETicketLogo.jpg"

'Producer Name vs Organization Name Option
ShowProducer = False

'Short Act vs Act Option
ShowShortAct = False

'Driving Directions
DrivingDirections = "<B>Directions from San Antonio:</B><BR>I-10 West, Exit 540. Turn RIGHT and head east on W. Bandera Road (TX-46) for .5 mile. Turn LEFT at S. Main Street (TX-46) and head north for .6 miles. Turn RIGHT at E. River Road (TX-46) and continue for 1.1 miles. Turn right on Charger Blvd. and proceed to the Main Entrance for Boerne Champion High School (on your LEFT).<BR><BR><B>Directions from Comfort/Fredericksburg/Kerrville/West Texas:</B><BR>I-10 East, Exit 537, heading south on US 87 Business (Main Street). Continue south for approximately three (3) miles to River Road (TX-46). Turn LEFT, heading east, on River Road and continue for 1.1 miles. Turn RIGHT on Charger Blvd. and proceed to the Main Entrance for Boerne Champion High School (on your LEFT)."


'===============================================

OrderNumber = Clean(Request("OrderNumber"))

TicketNumber = Clean(Request("TicketNumber"))

'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (ShipCode=13)
	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Event.Map AS EventMap, Act.Act, Act.Actcode, Act.ShortAct, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
	Set rsTix = OBJdbConnection.Execute(SQLTix)

	If Not rsTix.EOF Then

		SQLTotalTix = "SELECT COUNT(TicketNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
		Set rsTotalTix = OBJdbConnection.Execute(SQLTotalTix)		
		TotalTix = rsTotalTix("TotalTix")		
		rsTotalTix.Close
		Set rsTotalTix = nothing

		Response.Write "<HTML>" & vbCrLf
		Response.Write "<HEAD>" & vbCrLf
		Response.Write "<TITLE>www.TIX.com - E-Ticket</TITLE>" & vbCrLf
		Response.Write "</HEAD>" & vbCrLf
		Response.Write "<BODY onLoad=""window.print()"">" & vbCrLf

        'Set Page Break Style
        
        %>
                
        <style type="text/css">
            
        .PageBreak {page-break-before: always}
            
        body
        {
        font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
        line-height: 1 em;
        }
        #lowerhalf
        {
        font-size: 10px;
        font-weight: 400;
        text-align: left;
        border-collapse: collapse;
        }
        #lowerhalf td
        {
	    padding-left: 5px;
	    padding-right: 5px;
	    padding-top: 5px;
	    padding-bottom: 5px;
        }
        #lowerhalf b
        {
        font-size: 11px;
        font-weight: 600;
        }
        </style>
        
        <%

		Response.Write "<CENTER>" & vbCrLf

		Do Until rsTix.EOF
		
			TixCount = TixCount + 1

'=============================
'Begin Ticket - 'Upper Half
'=============================


			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
            Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""4""><B>THIS IS YOUR TICKET.  " & "<FONT FACE=""Arial, Helvetica"" SIZE=""3"">Present this entire page at the event.</B></FONT>" & vbCrLf 
			Response.Write "<BR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""1"" BACKGROUND=""/Images/ETicketBackground.gif"" BGCOLOR=""#FFD718"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
			
'Custom Logo Option 
'---------------------

            ETicketLogo = "/Images/ETicketLogo.gif"
			
			If CustomETicketLogo <> "" Then
			    ETicketLogo = CustomETicketLogo
			End If
					        
            Response.Write "<IMG src=""" & ETicketLogo & """>" & vbCrLf        
			
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD VALIGN=""top"" ALIGN=""right"">" & vbCrLf
			
			'REE 7/8/6 - Modified to allow flexible length ticket numbers.  Insert dash after every 4th digit.
			TicketDigit = 1
			ETicketNumber = ""
			Do Until TicketDigit >= Len(rsTix("TicketNumber"))
				If TicketDigit < Len(rsTix("TicketNumber")) - 4 Then
					ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, 4) & "-"
					TicketDigit = TicketDigit + 4
				Else
					ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, (Len(rsTix("TicketNumber")) - TicketDigit) + 1)
					TicketDigit = Len(rsTix("TicketNumber"))
				End If
			Loop
			Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" & ETicketNumber & "&nbsp;&nbsp;&nbsp;&nbsp;" & rsTix("OrderNumber") & " - " & rsTix("ItemNumber") & "</FONT></TD>" & vbCrLf '********** ADDED FOR TEST DRIVE **********
					
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""20"">" & vbCrLf
			Response.Write "&nbsp;" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			
'Producer Name Option 
'---------------------
			
			ETicketProducer = rsTix("Organization") + "&nbsp;presents"
			
			If ShowProducer Then
			
			    SQLNewProducer = "SELECT Producer FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                Set rsNewProducer = OBJdbConnection.Execute(SQLNewProducer)
                
                 If NOT rsNewProducer.EOF Then     
                
                     If rsNewProducer("Producer") <> "" Then 
                        ETicketProducer = rsNewProducer("Producer")
                     End If
                 
                    rsNewProducer.Close
                    Set rsNewProducer = nothing
     
			     End If		
			     	
			End If
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & ETicketProducer & "</I></FONT><BR>" & vbCrLf
			
'Short Act Option 
'-----------------
			
			ETicketAct = rsTix("Act")
			
			If ShowShortAct Then
			
			    SQLNewAct = "SELECT ShortAct FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                Set rsNewAct = OBJdbConnection.Execute(SQLNewAct)
                
                 If NOT rsNewAct.EOF Then     
                
                     If rsNewAct("ShortAct") <> "" Then 
                        ETicketAct = rsNewAct("ShortAct")
                     End If
                 
                    rsNewAct.Close
                    Set rsNewAct = nothing
     
			     End If		
			     	
			End If	
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & ETicketAct & "</B></FONT><BR>" & vbCrLf
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			
			
'DateSuppress Option
'TimeSuppress Option
'-------------------				
			
			SQLDateOption = "SELECT OptionValue FROM EventOptions (NOLOCK) WHERE EventCode = " & rsTix("EventCode") & " AND OptionName = 'DATESUPPRESS'"
			Set rsDateOption = OBJdbConnection.Execute(SQLDateOption)
			If Not rsDateOption.EOF Then
			    DateOption = rsDateOption("OptionValue")	
			Else
			    DateOption = "F"
			End If
		    rsDateOption.Close
		    Set rsDateOption = nothing 
		
			SQLTimeOption = "SELECT OptionValue FROM EventOptions (NOLOCK) WHERE EventCode = " & rsTix("EventCode") & " AND OptionName = 'TIMESUPPRESS'"
			Set rsTimeOption = OBJdbConnection.Execute(SQLTimeOption)
			If Not rsTimeOption.EOF Then
			    TimeOption = rsTimeOption("OptionValue")
			Else
			    TimeOption = "F"
			End If		
		    rsTimeOption.Close
		    Set rsTimeOption = nothing
		    
		    If DateOption = "Y" AND TimeOption = "Y" Then		    		
			    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">&nbsp;</FONT><BR><BR>" & vbCrLf
			End IF
			
			If DateOption = "Y" AND TimeOption = "F" Then			    		
			    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & "</FONT><BR><BR>" & vbCrLf
			End If
			
			If DateOption = "F" AND TimeOption = "Y" Then
			    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
            End If	
            
            If DateOption = "F" AND TimeOption = "F" Then
			    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
            End If
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT><BR>" & vbCrLf
			
			
'If reserved seating, list section name, seat number and row
'omit that information for general admission seating
'-------------------------------------------------------------	
					
            If rsTix("EventMap") = "general" Then
			    Response.Write "&nbsp;" & vbCrLf
            Else
                Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
            End If
						
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
									
			Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
			Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270"">&nbsp;" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
					  
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
			Response.Write "<IMG SRC=""/Images/ETicketBottomBar.gif"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			
'==============================
'Begin Lower Half 
'===============================

		    Response.Write "<TABLE id=""lowerhalf"" WIDTH=""620"">" & vbCrLf	
            Response.Write "<TR>" & vbCrLf
            Response.Write "<TD VALIGN=""top"" WIDTH = ""23%"">" & vbCrLf	
			
'Col 1 (Left)
'-----------
            'Billing Information

			Response.Write "<B>BILLING INFORMATION</B><BR>" & vbCrLf
			
			'Proper Case Function for Billing Name				
			Response.Write PCase(rsTix("FirstName")) & " " & PCase(rsTix("LastName")) & "<BR>" & vbCrLf
			Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			If rsTix("Address2") <> "" Then
				Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			
			
			'Shipping Information			
			
		    Response.Write "<B>SHIPPING INFORMATION</B><BR>" & vbCrLf
		    
		    'Proper Case Function for Ship To Name
            Response.Write PCase(rsTix("ShipFirstName")) & " " & PCase(rsTix("ShipLastName")) & "<BR>" & vbCrLf
            Response.Write rsTix("ShipAddress1") & "<BR>" & vbCrLf
            If rsTix("ShipAddress2") <> "" Then
            Response.Write rsTix("ShipAddress2") & "<BR>" & vbCrLf
            End If
            Response.Write rsTix("ShipCity") & ", " & rsTix("ShipState") & " " & rsTix("ShipPostalCode") & "<BR>" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            
            'Order Information
            
            Response.Write "<B>ORDER INFORMATION</B><BR>" & vbCrLf			
			Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
			Response.Write "Order Time:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), 3) & "<BR>" & vbCrLf
			Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf	
				
'Col 2 (Center)	
'-----------	

            Response.Write "</TD>" & vbCrLf		
            Response.Write "<TD VALIGN=""top"" WIDTH = ""43%"">" & vbCrLf	
            	
            
            'Venue Information	
            		
            Response.Write "<B>VENUE</B><BR>" & vbCrLf
            Response.Write rsTix("Venue") & "<BR>" & vbCrLf
			Response.Write rsTix("VenueAddress1") & "<BR>" & vbCrLf
			If rsTix("VenueAddress2") <> "" Then
				Response.Write rsTix("VenueAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("VenueCity") & ", " & rsTix("VenueState") & " " & rsTix("VenuePostalCode") & "<BR>" & vbCrLf
			Response.Write "Phone: " & FormatPhone(rsTix("EventPhoneNumber"), "United States") & "<BR>" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            
            
            'Driving Directions	
            
            Response.Write " " & DrivingDirections & " " & vbCrLf
            
'Col 3 (Right)
'-----------	

            Response.Write "</TD>" & vbCrLf		
            Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
            
            'Map Information			

            Response.Write "<B>MAP</B><BR>" & vbCrLf			
			Response.Write "<IMG SRC=""/Clients/BoernePerformingArts/ETicket/Images/ETicketMAP.jpg"">" & vbCrLf
			


'Begin Footer
'-----------
	
			Response.Write "</TR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf		

			Response.Write "<TD colspan=""3"">" & vbCrLf	
			
			'General Information
					
			Response.Write "<B>GENERAL INFORMATION</B><BR>" & vbCrLf
			Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf

			Response.Write "</TD>" & vbCrLf
			
			Response.Write "</TR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			

'Begin Horizonal Rule
'-------------------
			Response.Write "<TD COLSPAN=""3"" ALIGN=""center"">" & vbCrLf
			Response.Write "<HR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			
			
'==============================
'Begin Lower Half
'===============================

			Response.Write "</TR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			
'Begin Ad Space	
'Display different advertising image based on act code	
'-------------------
			
			Select Case rsTix("ActCode") 
			
			Case 72669 'VIENNA BOYS CHOIR
				AdSpaceImage = "Images/AdImage001.jpg"
				
			Case 72668 'TAO: The Art of the Drum
				AdSpaceImage = "Images/AdImage002.jpg"
				
			Case 72667 'BOWFIRE
				AdSpaceImage = "Images/AdImage003.jpg"
				
			Case Else 'Default Advertisting Image
				AdSpaceImage = "/Images/ETicketTixLogo.jpg"	
	        End Select		        

			Response.Write "<TD colspan=""3"" ALIGN=""center"">" & vbCrLf
			Response.Write "<IMG SRC = " & AdSpaceImage & " "" WIDTH=""500"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf		
				
			
'==============================
'End Lower Half
'==============================

			Response.Write "</TR>" & vbCrLf
			Response.Write "<TABLE>" & vbCrLf
			
			If TixCount < TotalTix Then
				'REE 3/9/7 - Added space inbetween DIV tag to resolve IE 7 Page Break issue.
				Response.Write "<DIV CLASS=""PageBreak"">&nbsp;</DIV>" 'Page Break
			End If

			rsTix.MoveNext

		Loop

		Response.Write "</CENTER>" & vbCrLf
		Response.Write "</BODY>" & vbCrLf
		Response.Write "</HTML>" & vbCrLf

	Else

		ETicketError("ETicketFormat - Ticket #" & TicketNumber)
		ErrorLog("ETicketPrint - Invalid Ticket - Order #" & OrderNumber & " - Ticket #" & TicketNumber & " - " & SQLTix)

	End If

	rsTix.Close
	Set rsTix = nothing

Else

	ETicketError("Invalid Ticket")
	ErrorLog("ETicketPrint - Invalid Ticket - Order #" & OrderNumber & " - Ticket #" & TicketNumber)

End If


rsOrderNum.Close
Set rsOrderNum = nothing

'===============================

Function PCase(ByVal strInput)' As String
     Dim I 'As Integer
     Dim CurrentChar, PrevChar 'As Char
     Dim strOutput 'As String

     PrevChar = ""
     strOutput = ""

     For I = 1 To Len(strInput)
         CurrentChar = Mid(strInput, I, 1)

         Select Case PrevChar
             Case "", " ", ".", "-", ",", """", "'"
                 strOutput = strOutput & UCase(CurrentChar)
             Case Else
                 strOutput = strOutput & LCase(CurrentChar)
         End Select

         PrevChar = CurrentChar
     Next 'I

     PCase = strOutput
     
End Function

'===============================


%>
  