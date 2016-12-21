<%

'CHANGE LOG - Update
'SSR 6/7/2012
'The Curators of the Univ. of Missouri
'Added Upper Act option

'SSR 12/5/2011
'Boerne Performing Arts
'Added Proper Case Spelling of Billing and Shipping Name
'Added ShortAct and Producer options

'CHANGE LOG - Update
'SSR (11/16/2011)
'Added Org Name if Custom Producer not found

'CHANGE LOG - Inception
'SSR (11/14/2011)
'Added Ticket Text 1, 2, 3 

'CHANGE LOG - Update
'SSR 10/4/2011
'George Little Management
'Added Date/Time Supress - E-Ticket will supress date/time if the event does.

'CHANGE LOG - Update
'SSR 8/11/2011
'Downtown Theater
'Added Case Statement - ticket will automatcially switch between GA and Rsvd formats 

'CHANGE LOG - Update
'SSR 6/24/2011
'Downtown Theater
'Added Ticket count added

%>

<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))


'===============================================
'Options
'===============================================

'E-Ticket Logo Option

'3 Options:
'for default logo set variable to TIX


'TicketLogo = "Tix" (tix logo - Gold)
'TicketLogo = "TixGray" (tix logo - Gray)
'TicketLogo = "" = (no background)
'TicketLogo = "images/logo.gif" (size: 215x68)

TicketLogo = "TIX"

'----------------------

'E-Ticket Background Option

'3 Options:
'for default background set variable to TIX


'TicketBackground = "Tix" (tix background - Gold)
'TicketBackground = "TixGray" (tix background - Gray)
'TicketBackground = "TixWhite" (tix background - White)
'TicketBackground = "" = (no background)
'TicketBackground = "images/logo.gif" (use custom background graphic)

TicketBackground = "TIX"

'----------------------

'E-Ticket BottomBar Option

'3 Options:
'for default BottomBar set variable to TIX

'TicketBottomBar = "Tix" (tix BottomBar)
'TicketBottomBar = "" = (no BottomBar)
'TicketBottomBar = "images/logo.gif" (use custom BottomBar graphic)

TicketBottomBar = "TIX"

'----------------------

'Producer/Organization Option

'4 Options:
'ShowPresents = "Producer"
'ShowPresents = "Organization" 
'ShowPresents = "TicketText1"  (will insert Ticket Text 1, 2 or 3)
'ShowPresents = "" (will leave line blank)

'----------------------

'Producer/Organization Suffix Option

'2 Options:

'POSuffix: = "presents" (any text can be used here)
'POSuffix: = ""

POSuffix = ""

'----------------------

'Short Act Name / Full Act Name Option

'2 Options:
'Full Act Name is default. To show short act:
'ShowShortAct = True

ShowShortAct = False

'----------------------

'Upper Case Act Option

'2 Options:
'Proper Case is default. To show upper act:
'UpperAct = True

UpperAct = False

'----------------------

'DateSuppress Option

'If the DATESUPPRESS event option is turned on, the e-ticket will not display the date

'----------------------

'TimeSuppress Option

'If the TIMESUPPRESS event option is turned on, the e-ticket will not display the time

'----------------------

'Show BarCode on Ticket
'Show BarCode on Order

ShowBarCodeTicket = True
ShowBarCodeOrder = True

'----------------------

'ShowVenue Option

'ShowVenueOrder = True (Will display the venue name and address)
'ShowVenueOrder = False (venue information will be omitted)
'ShowVenueTicket = True (Will display the venue name and address)
'ShowVenueTicket = False (venue information will be omitted)

ShowVenueTicket = True
ShowVenueOrder = True

'----------------------

'ShowDirections Option

'ShowDirections = True (Will display the driving directions)

ShowDirections = False

DrivingDirections = ""
'----------------------

'ShowMap Options

'ShowMap = True (Will display the map image)

ShowMap = False

Map = "/images/map.gif"

'----------------------

'Attendee Options

'ShowAttendee = True (Will display the Billing Name)
'ShowAttendee = False (Will display the Ship to Name)

ShowAttendee = False

'----------------------

'General Information Options

'ShowGeneralInfo = True (Will display the general information)
'ShowGeneralInfo = False (blank)

ShowGeneralInfo = True
GeneralInfoText = "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm. Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued."

'----------------------

'E-Ticket Ad Option

'3 Options:
'for default Tix logo set variable to TIX


'TicketAd = "Tix" (tix ad)
'TicketAd = "" = (no ad)
'TicketAd = "../images/ad.gif" (size: 215x68)

TicketAd = "Tix"

'----------------------

'Ticket Text 1
			
TicketText1 = ""

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

 If NOT rsVerifyEvent.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'TicketText1' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
            Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

             If rsCustomText("OptionValue") <> "" Then 
                TicketText1 = rsCustomText("OptionValue")
             End If
 
            rsCustomText.Close
            Set rsCustomText = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing

'----------------------

'Ticket Text 2
			
TicketText2 = ""

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

 If NOT rsVerifyEvent.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'TicketText2' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
            Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

             If rsCustomText("OptionValue") <> "" Then 
                TicketText2 = rsCustomText("OptionValue")
             End If
 
            rsCustomText.Close
            Set rsCustomText = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing

'----------------------

'Ticket Text 3
			
TicketText3 = ""

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

 If NOT rsVerifyEvent.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'TicketText3' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
            Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

             If rsCustomText("OptionValue") <> "" Then 
                TicketText3 = rsCustomText("OptionValue")
             End If
 
            rsCustomText.Close
            Set rsCustomText = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing

'----------------------

'Event Order Confirmation Notes

			
EventOrderConfirmationNotes = ""

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

 If NOT rsVerifyEvent.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'EventOrderConfirmationNotes' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
            Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

             If rsCustomText("OptionValue") <> "" Then 
                EventOrderConfirmationNotes = rsCustomText("OptionValue")
             End If
 
            rsCustomText.Close
            Set rsCustomText = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing


'===============================================

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
		Response.Write "<STYLE>" & vbCrLf
		Response.Write ".PageBreak {page-break-before: always}" & vbCrLf
		Response.Write "</STYLE>" & vbCrLf

        %>
        <style type="text/css">
            
        .PageBreak {page-break-before: always}
        
        div {page-break-before: always}
            
        body
        {
        line-height: 1 em;
        }
        .ticket
        {
        line-height: 0.7em;
        padding : 15px;
        }
        .order
        {
        text-align: left;
        border-collapse: collapse;
        }
        .data
        {
	    padding-left: 5px;
	    padding-right: 5px;
	    padding-top: 5px;
	    padding-bottom: 5px;
	    font-size: 12px;
        }
        #producer
        { 
        width: 100%; 
        height: 15px; 
        padding-left: 18px;  
        float: left; 
        font-weight: bold;
        overflow: hidden;
        border: 0px solid #000000;
        margin-bottom: 5px;
        margin-top: 0px;
        margin-left: 0px;
        margin-right: 0px;
        }
        #act
        { 
        width: 100%; 
        height: 30px; 
        padding-left: 18px;  
        float: left; 
        font-weight: bold;
        overflow: hidden;
        border: 0px solid #000000;
        margin-bottom: 5px;
        margin-top: 0px;
        margin-left: 0px;
        margin-right: 0px;
        }  
        .b
        {
        font-size: 14px;
        }
        .spacer
        {
         line-height: 0.4em;
         }
        </style>

        <%

		Response.Write "<CENTER>" & vbCrLf

		Do Until rsTix.EOF
		
			TixCount = TixCount + 1

		'Begin Ticket


			        Response.Write "<TABLE WIDTH=""620"" CELLPADDING=""0"" CELLSPACING=""0"" BORDER=""0"">" & vbCrLf
                    Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""4""><B>THIS IS YOUR TICKET.  " & "<FONT FACE=""Arial, Helvetica"" SIZE=""3"">Present this entire page at the event.</B></FONT>" & vbCrLf 
			        Response.Write "<BR>" & vbCrLf
			        Response.Write "<TR>" & vbCrLf
			        Response.Write "<TD VALIGN=""top"">" & vbCrLf
                    ETicketBackground = "/Images/ETicketBackground.gif"

			        If TicketBackground  = "" Then
                        ETicketBackground = ""
                    ElseIf TicketBackground = "Tix" Then
                        ETicketBackground = "/Images/ETicketBackground.gif"
                    ElseIf TicketBackground = "TixGray" Then
                        ETicketBackground = "/Images/ETicketBackgroundGray.gif"
                    ElseIf TicketBackground = "TixWhite" Then
                        ETicketBackground = "/Images/ETicketBackgroundWhite.gif"
                    Else
                        ETicketBackground = "Images/" & TicketBackground
                    End If

                    Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""0"" BACKGROUND=""" & ETicketBackground & """ BGCOLOR=""#ffffff"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf   
			    
			        Response.Write "<TR>" & vbCrLf			    
			        Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
			    
		            Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
		            Response.Write "<TR>" & vbCrLf
		            Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
			
			        '---------------------
                    'Custom Logo Option 
                    '---------------------

                     ETicketLogo = "/Images/ETicketLogo.gif"

		            If TicketLogo  = "" Then
                        ETicketLogo = ""
                    ElseIf TicketLogo = "Tix" Then
                        ETicketLogo = "/Images/ETicketLogo.gif"
                    ElseIf TicketLogo = "TixGray" Then
                        ETicketLogo = "/Images/ETicketLogoGray.gif"
                    Else
                        ETicketLogo = "Images/" & TicketLogo
                    End If
					        
                    Response.Write "<IMG src=""" & ETicketLogo & """ border=""0"">" & vbCrLf        
                    			
			        Response.Write "</TD>" & vbCrLf
			        Response.Write "</TR>" & vbCrLf
			        Response.Write "</TABLE>" & vbCrLf
			        
			        Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			        Response.Write "<TR>" & vbCrLf
			        Response.Write "</TD>" & vbCrLf
			        Response.Write "<TD>" & vbCrLf
			
			        '---------------------
                    'Producer Name Option 
                    '---------------------

                    If ShowPresents = "Producer" Then

                    	    SQLNewProducer = "SELECT Producer FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                            Set rsNewProducer = OBJdbConnection.Execute(SQLNewProducer)
                                                    
                                If NOT rsNewProducer.EOF Then     
                        
                                     If rsNewProducer("Producer") <> "" Then 
                                        EShowPresents = rsNewProducer("Producer") + "&nbsp;" & Presents & ""
                                     End If

                                End If	
                         
                            rsNewProducer.Close
                            Set rsNewProducer = nothing                           
                                         
                    ElseIf ShowPresents = "Organization" Then
                        EShowPresents = rsTix("Organization") + "&nbsp;" + POSuffix

                    ElseIf ShowPresents = "TicketText1" Then
                        EShowPresents = TicketText1 + "&nbsp;" + POSuffix

                    ElseIf ShowPresents = "TicketText2" Then
                        EShowPresents = TicketText2 + "&nbsp;" + POSuffix

                    ElseIf ShowPresents = "TicketText3" Then
                        EShowPresents = TicketText3 + "&nbsp;" + POSuffix

                    Else
                        EShowPresents = ""
                    End If
			
                    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><p id=""producer"">" & EShowPresents & "</I></p></FONT>" & vbCrLf
			
                    '-----------------
                    'Act Name Option 
                    '-----------------
			
			        ETicketAct = rsTix("Act")
        			
			        If ShowShortAct Then
        			
			            SQLNewAct = "SELECT ShortAct FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                        Set rsNewAct = OBJdbConnection.Execute(SQLNewAct)
                        
                         If NOT rsNewAct.EOF Then     
                        
                             If rsNewAct("ShortAct") <> "" Then 
                                ETicketAct = rsNewAct("ShortAct")
                             End If

                             If UpperShortAct Then
                                ETicketAct = UCASE(ETicketAct)
                             End If
                                                      
                            rsNewAct.Close
                            Set rsNewAct = nothing
             
			             End If		

                    Else
                    
                    	ETicketAct = rsTix("Act")

                    End If
                    	
			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><p id=""act"">" & ETicketAct & "</p></font>" & vbCrLf


                    '-------------------			
                    'Venue
                    '-------------------	

                    If ShowVenueTicket Then

			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><span class=""ticket"">" & rsTix("Venue") & "</span></FONT><p class=""spacer"">" & vbCrLf

                    End If


			
                    '-------------------			
                    'DateSuppress Option
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
		            

		            '-------------------			
                    'TimeSuppress Option
                    '-------------------
		
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
			            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">&nbsp;</FONT>" & vbCrLf
			        End IF
			
			        If DateOption = "Y" AND TimeOption = "F" Then			    		
			            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & "</FONT>" & vbCrLf
			        End If
			
			        If DateOption = "F" AND TimeOption = "Y" Then
			            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT>" & vbCrLf
                    End If	
            
                    If DateOption = "F" AND TimeOption = "F" Then
			            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><span class=""ticket"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</span></FONT>" & vbCrLf
                    End If
			
                    '-------------------------------------------------------------	
                    'Ticket Text 1
                    '-------------------------------------------------------------
                    Response.Write "<br>" & vbCrLf
                     Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><span class=""ticket"">" & TicketText1 & "</span></FONT><p class=""spacer"">" & vbCrLf

                    '-------------------------------------------------------------	
                    'Seat Type / Price
                    '-------------------------------------------------------------	

			         Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><span class=""ticket"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</span><p class=""spacer""></FONT>" & vbCrLf

			        '--------------------------------------------------------------------	
                    'Display Reserved Seating Information or Hide Row/Seat for GA Events
                    '--------------------------------------------------------------------	
					
                    If rsTix("EventMap") = "general" Then
		                   Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><span class=""ticket"">Section: " & rsTix("Section") & "</span></font>" & vbCrLf
                    Else
                        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><span class=""ticket""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</span></FONT><br><BR>" & vbCrLf
                    End If
                            
		            Response.Write "</TD>" & vbCrLf
		            Response.Write "</TR>" & vbCrLf
		            Response.Write "</TABLE>" & vbCrLf
			        Response.Write "</TD>" & vbCrLf

                    '--------------------			    
                    'Show BarCode Option
                    '--------------------
                    
				    If ShowBarCodeTicket Then	
    								
			            Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
			            Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270"">&nbsp;" & vbCrLf
			            Response.Write "</TD>" & vbCrLf
    			    
			        End If
			    
			        Response.Write "</TR>" & vbCrLf
					  
			        Response.Write "<TR>" & vbCrLf
			        Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf

                    ETicketBottomBar = "/Images/ETicketBottomBar.gif"

		            If TicketBottomBar  = "" Then
                        ETicketBottomBar = ""
                    ElseIf TicketBottomBar = "Tix" Then
                        ETicketBottomBar = "/Images/ETicketBottomBar.gif"
                    Else
                        ETicketBottomBar = "Images/" & TicketBottomBar
                    End If

			        Response.Write "<IMG src=""" & ETicketBottomBar & """>" & vbCrLf  

			        Response.Write "</TD>" & vbCrLf
			        Response.Write "</TR>" & vbCrLf
			        Response.Write "</TABLE>" & vbCrLf
			        Response.Write "</TD>" & vbCrLf
			        Response.Write "</TR>" & vbCrLf
			        Response.Write "</TABLE>" & vbCrLf

		'End Ticket


'==============================
'Order Information - Row 1
'==============================

			Response.Write "<TABLE class=""order"" WIDTH=""620"" BORDER=""0"">" & vbCrLf
            			
            'Order Information			
            '-----------------

            Response.Write "<TR>" & vbCrLf
			Response.Write "<TD class=""order data"" VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf				
			Response.Write "<B>ORDER INFORMATION</B><BR>" & vbCrLf			
			Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
			Response.Write "Order Time:&nbsp;&nbsp; " & Left(FormatDateTime(rsTix("OrderDate"),vbLongTime),Len(FormatDateTime(rsTix("OrderDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("OrderDate"),vbLongTime),3)& "&nbsp;Pacific Time<BR>" & vbCrLf
			Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf								
			Response.Write "</TD>" & vbCrLf	
			
            'Venue Information
            '-----------------	

            If ShowVenueOrder Then

            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<TD class=""order data"" VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf	
			Response.Write "<B>VENUE INFORMATION</B><BR>" & vbCrLf
			Response.Write rsTix("Venue") & "<BR>" & vbCrLf
			Response.Write rsTix("VenueAddress1") & "<BR>" & vbCrLf
			If rsTix("VenueAddress2") <> "" Then
				Response.Write rsTix("VenueAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("VenueCity") & ", " & rsTix("VenueState") & " " & rsTix("VenuePostalCode") & "<BR>" & vbCrLf
			Response.Write "Phone: " & FormatPhone(rsTix("EventPhoneNumber"), "United States") & "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf

            Else

            Response.Write "<TD class=""order data"" VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf						
			Response.Write "<BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf

            End If
			
            'Barcode Information
            '-------------------

            If ShowBarCodeOrder Then
            
			Response.Write "<TD class=""order data"" VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf						
			Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & """><BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
            Response.Write "</TR>" & vbCrLf

            Else
            
            Response.Write "<TD class=""order data"" VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf						
			Response.Write "<BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
            Response.Write "</TR>" & vbCrLf

            End If
            

'==============================
'Order Information - Row 2
'==============================


            'Billing Information			
            '--------------------

			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD class=""order data"" VALIGN=""top"">" & vbCrLf
			Response.Write "<B>BILLING INFORMATION</B><BR>" & vbCrLf
			Response.Write PCase(rsTix("FirstName")) & " " & PCase(rsTix("LastName")) & "<BR>" & vbCrLf
			Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			If rsTix("Address2") <> "" Then
				Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & "<BR>" & vbCrLf
            Response.Write "<BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf


            If ShowAttendee Then
            Response.Write "<TD class=""order data"" VALIGN=""top"">" & vbCrLf
            Response.Write "<B>ATTENDEE INFORMATION</B><BR>" & vbCrLf
            Else
            Response.Write "<TD class=""order data"" VALIGN=""top"">" & vbCrLf
            Response.Write "<B>SHIPPING INFORMATION</B><BR>" & vbCrLf
            End If

            Response.Write rsTix("ShipFirstName") & " " & rsTix("ShipLastName") & "<BR>" & vbCrLf
            Response.Write rsTix("ShipAddress1") & "<BR>" & vbCrLf
            If rsTix("ShipAddress2") <> "" Then
            Response.Write rsTix("ShipAddress2") & "<BR>" & vbCrLf
            End If
            Response.Write rsTix("ShipCity") & ", " & rsTix("ShipState") & " " & rsTix("ShipPostalCode") & "<BR>" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            Response.Write "</FONT>" & vbCrLf
            Response.Write "</TD>" & vbCrLf


            If SHOWDIRECTIONS Then

            'Driving Directions
            '------------------

			Response.Write "<TD class=""order data"" VALIGN=""top"" width=""40%"">" & vbCrLf
			Response.Write "<B>DRIVING DIRECTIONS</B><BR>" & vbCrLf
            Response.Write "<FONT SIZE=""1"">" & DrivingDirections & "</font><BR>" & vbCrLf
            
            Else

            'Ticket Count Information			
            '--------------------

			Response.Write "<TD class=""order data"" VALIGN=""top"">" & vbCrLf
			Response.Write "<B>TICKET COUNT</B><BR>" & vbCrLf
			Response.Write "Ticket No " & TixCount & " of " & TotalTix & "<BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf

            End If


            'Map Information
            '-------------------

            If ShowMap Then

            Response.Write "<TD class=""order data"" VALIGN=""top"">" & vbCrLf
			Response.Write "<B>MAP INFORMATION</B><BR>" & vbCrLf
            Response.Write "<IMG src=""" & ETicketLogo & """ border=""0"" width=""200"" height=""200"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
            Response.Write "</TR>" & vbCrLf

            Else

            Response.Write "<TD class=""order data"" VALIGN=""top"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
            Response.Write "</TR>" & vbCrLf

            End If


           

'==============================
'Order Information - Row 3
'==============================

                Response.Write "<TR>" & vbCrLf
                Response.Write "<TD class=""order data"" VALIGN=""top"" colspan=""3"">" & vbCrLf

			    Response.Write "</TD>" & vbCrLf
                Response.Write "</TR>" & vbCrLf


'==============================
'General Information
'==============================

            'General Information			
            '--------------------
            Response.Write "<TR>" & vbCrLf

            If ShowGeneralInfo Then
            
			Response.Write "<TD class=""order data"" VALIGN=""top"" colspan=""3"">" & vbCrLf
            Response.Write "<B>GENERAL INFORMATION</B><BR>" & vbCrLf
            Response.Write "" & TicketText3 & "" & vbCrLf
            Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm. " & vbCrLf
            Response.Write "Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
			Response.Write "</TD>" & vbCrLf

            Else

            Response.Write "<TD class=""order data"" VALIGN=""top"" colspan=""3"">" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            Response.Write "</TD>" & vbCrLf

            End If

            Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf


'==============================
'Horizonal Rule
'==============================


			'Horizonal Rule
            '--------------------
			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<HR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

'==============================
'Ad Space
'==============================

		    'Begin Ad Space
            '--------------------
            ETicketAd = "/Images/TixLogo300x225.jpg"

            If TicketAd  = "" Then
                ETicketAd = ""
            ElseIf TicketAd = "Tix" Then
                ETicketAd = "/Images/TixLogo300x225.jpg"
            Else
                ETicketAd = TicketAd
            End If

            Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<IMG src=""" & ETicketAd & """ border=""0"" Height=""300"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf 

		    'End Ad Space
			
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
  