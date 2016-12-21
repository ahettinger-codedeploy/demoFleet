<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

Page = "Management"

Server.ScriptTimeout = 60 * 20 '4 hours


If Session("UserNumber") = "" Then
	Response.Redirect("Default.asp")
End If

SQLUser = "SELECT OrganizationNumber FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
Set rsUser = OBJdbConnection.Execute(SQLUser)

If rsUser.EOF Then 
	Response.Redirect("Default.asp")
Else
	iOrg = rsUser("OrganizationNumber")
End If

rsUser.Close
Set rsUser = nothing

    SQLDiscount = "SELECT DiscountTypeNumber, DiscountDescription, OrganizationNumber, Prompt, DiscountCode, DiscountScript FROM DiscountType (NOLOCK) WHERE DiscountTypeNumber = 26537"
    Set rsDiscount = OBJdbConnection.Execute(SQLDiscount)
    
    DiscountScript = rsDiscount("DiscountScript") 
       
        
        If DiscountScript <> "" Then
            BegPos = InStr(1, DiscountScript, "Discounts/", 1) + 10
            EndPos = InStr(1, DiscountScript, ".asp?", 1)
            DiscountType = Mid(DiscountScript,BegPos,EndPos-BegPos)
            
            'OnlineFlag
	        If InStr(1, DiscountScript, "OnlineOnly=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "OnlineOnly=") + 11
		        OnlineFlag = Mid(DiscountScript, StartPos, 1)
		    Else
		        OnlineFlag = "N"
	        End If
    	        		
	        'OfflineFlag
	        If InStr(1, DiscountScript, "OfflineOnly=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "OfflineOnly=") + 12
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        OfflineFlag = Mid(DiscountScript, StartPos, 1)
		    Else
		        OfflineFlag = "N"
	        End If
    	    	    
	        If OnlineFlag = "N" And OfflineFlag = "N" Then
	            OnlineFlag = "Y"
	            OfflineFlag = "Y"
	        Else
	            OnlineFlag = OnlineFlag
	            OfflineFlag = OfflineFlag
	        End If
    	    
	        'SeatType
	        If InStr(1, DiscountScript, "SeatTypeCode=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "SeatTypeCode=") + 13
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        SeatTypeCode = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If
	        If SeatTypeCode = "" Then
	            SeatTypeCode = "All"
	        Else
	            Call DBOpen(OBJdbConnection2)
	            sqlSeatType = "SELECT SeatTypeCode, SeatType FROM SeatType WHERE SeatTypeCode IN (" & SeatTypeCode & ")"
	            Set rsSeatType = OBJdbConnection2.Execute(sqlSeatType)
	            Do Until rsSeatType.EOF
	                SeatTypeCodeString = SeatTypeCodeString & rsSeatType("SeatType") & ","
	                rsSeatType.Movenext
	            Loop
	            SeatTypeCode = Left(SeatTypeCodeString, Len(SeatTypeCodeString)-1)
	            rsSeatType.Close
	            Set rsSeatType = nothing
	            Call DBClose(OBJdbConnection2)
	        End If
    	    
	        'StartDate
	        If InStr(1, DiscountScript, "StartDate=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "StartDate=") + 10
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        StartDate = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If
	        If StartDate = "" Then
	            StartDate = "Now"    
	        End If
        		
	        'ExpirationDate
	        If InStr(1, DiscountScript, "ExpirationDate=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "ExpirationDate=") + 15
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        ExpirationDate = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If
	        If ExpirationDate = "" Then
	            ExpirationDate = "Does Not Expire"
	        End If
    	    
	        'MaxDiscountsPerEvent
	        If InStr(1, DiscountScript, "MaxDiscountsPerEvent=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "MaxDiscountsPerEvent=") + 21
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        MaxDiscountsPerEvent = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If
	        If MaxDiscountsPerEvent = "" Then
	            MaxDiscountsPerEvent = "Unlimited"
	        End If

	        'MaxDiscountsPerOrderPerEvent
	        If InStr(1, DiscountScript, "MaxDiscountsPerOrderPerEvent=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "MaxDiscountsPerOrderPerEvent=") + 29
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        MaxDiscountsPerOrderPerEvent = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If
	        If MaxDiscountsPerOrderPerEvent = "" Then
	            MaxDiscountsPerOrderPerEvent = "Unlimited"
	        End If

	        'MaxDiscountsPerOrder
	        If InStr(1, DiscountScript, "MaxDiscountsPerOrder=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "MaxDiscountsPerOrder=") + 21
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        MaxDiscountsPerOrder = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If
	        If MaxDiscountsPerOrder = "" Then
	            MaxDiscountsPerOrder = "Unlimited"
	        End If

	        'MaxDiscountsSystemUsage
	        If InStr(1, DiscountScript, "MaxDiscountSystemUsage=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "MaxDiscountSystemUsage=") + 23
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        MaxDiscountsSystemUsage = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If
	        If MaxDiscountsSystemUsage = "" Then
	            MaxDiscountsSystemUsage = "Unlimited"
	        End If
            
            If DiscountType = "AmountDiscount" then
                DiscountAmountStartPos = InStr(1, DiscountScript, "DiscountAmount=") + 15
		        DiscountAmountEndPos = InStr(DiscountAmountStartPos, DiscountScript, "&")
                If DiscountAmountEndPos = 0 Then
			        DiscountAmountEndPos = Len(DiscountScript) + 1
		        End If
                DiscountAmount = Mid(DiscountScript, DiscountAmountStartPos, DiscountAmountEndPos - DiscountAmountStartPos)
                DiscountAmount = FormatCurrency(DiscountAmount,2) & " Off Each Ticket"
            ElseIf DiscountType = "PercentageDiscount" then
                PercentageStartPos = InStr(1, DiscountScript, "Percentage=") + 11
		        PercentageEndPos = InStr(PercentageStartPos, DiscountScript, "&")
		        If PercentageEndPos = 0 Then
			        PercentageEndPos = Len(DiscountScript) + 1
		        End If
		        Percentage = Mid(DiscountScript, PercentageStartPos, PercentageEndPos - PercentageStartPos)
                DiscountAmount = Percentage & "% Off Each Ticket"
            ElseIf DiscountType = "FixedPriceDiscount" then
                FixedPriceStartPos = InStr(1, DiscountScript, "FixedPrice=") + 11
		        FixedPriceEndPos = InStr(FixedPriceStartPos, DiscountScript, "&")
		        If FixedPriceEndPos = 0 Then
			        FixedPriceEndPos = Len(DiscountScript) + 1
		        End If
		        FixedPrice = Mid(DiscountScript, FixedPriceStartPos, FixedPriceEndPos - FixedPriceStartPos)
                DiscountAmount = FormatCurrency(FixedPrice,2) & " Ticket Price"
            ElseIf DiscountType = "BuyXGet1Free" then
                QtyToBuyStartPos = InStr(1, DiscountScript, "QtyToBuy=") + 9
		        QtyToBuyEndPos = InStr(QtyToBuyStartPos, DiscountScript, "&")
		        If QtyToBuyEndPos = 0 Then
			        QtyToBuyEndPos = Len(DiscountScript) + 1
		        End If
		        QtyToBuy = Mid(DiscountScript, QtyToBuyStartPos, QtyToBuyEndPos - QtyToBuyStartPos)
                DiscountAmount = "Buy " & QtyToBuy & " Get 1 Free"
            ElseIf DiscountType = "BuyXGet1PercentageOff" then
                QtyToBuyStartPos = InStr(1, DiscountScript, "QtyToBuy=") + 9
		        QtyToBuyEndPos = InStr(QtyToBuyStartPos, DiscountScript, "&")
		        If QtyToBuyEndPos = 0 Then
			        QtyToBuyEndPos = Len(DiscountScript) + 1
		        End If
		        QtyToBuy = Mid(DiscountScript, QtyToBuyStartPos, QtyToBuyEndPos - QtyToBuyStartPos)
		        PercentageStartPos = InStr(1, DiscountScript, "Percentage=") + 11
		        PercentageEndPos = InStr(PercentageStartPos, DiscountScript, "&")
		        If PercentageEndPos = 0 Then
			        PercentageEndPos = Len(DiscountScript) + 1
		        End If
		        Percentage = Mid(DiscountScript, PercentageStartPos, PercentageEndPos - PercentageStartPos)
                DiscountAmount = "Buy " & QtyToBuy & " Get Second " & Percentage & "% Off"
            ElseIf DiscountType = "GroupDiscount" then
                QtyStartPos = InStr(1, DiscountScript, "Qty=") + 4
		        QtyEndPos = InStr(QtyStartPos, DiscountScript, "&")
		        If QtyEndPos = 0 Then
			        QtyEndPos = Len(DiscountScript) + 1
		        End If
		        QtyToBuy = Mid(DiscountScript, QtyStartPos, QtyEndPos - QtyStartPos)
		        If InStr(1, DiscountScript, "&DiscountAmount=") <> 0 Then
			        GroupType = "GroupAmount"
			        AmountDiscountStartPos = InStr(1, DiscountScript, "DiscountAmount=") + 15
			        AmountDiscountEndPos = InStr(AmountDiscountStartPos, DiscountScript, "&")
			        If AmountDiscountEndPos = 0 Then
				        AmountDiscountEndPos = Len(DiscountScript) + 1
			        End If
			        AmountDiscount = Mid(DiscountScript, AmountDiscountStartPos, AmountDiscountEndPos - AmountDiscountStartPos)
			        DiscountAmount = FormatCurrency(AmountDiscount,2) & " Off " & QtyToBuy & "+ Tickets"
		        ElseIf InStr(1, DiscountScript, "&Percentage=") <> 0 Then
			        GroupType = "GroupPercentage"
			        PercentageDiscountStartPos = InStr(1, DiscountScript, "Percentage=") + 11
			        PercentageDiscountEndPos = InStr(PercentageDiscountStartPos, DiscountScript, "&")
			        If PercentageDiscountEndPos = 0 Then
				        PercentageDiscountEndPos = Len(DiscountScript) + 1
			        End If
			        PercentageDiscount = Mid(DiscountScript, PercentageDiscountStartPos, PercentageDiscountEndPos - PercentageDiscountStartPos)
			        DiscountAmount = PercentageDiscount & "% Off " & QtyToBuy & "+ Tickets"
		        ElseIf InStr(1, DiscountScript, "&FixedPrice=") <> 0 Then
			        GroupType = "GroupFixedPrice"
			        FixedPriceStartPos = InStr(1, DiscountScript, "FixedPrice=") + 11
			        FixedPriceEndPos = InStr(FixedPriceStartPos, DiscountScript, "&")
			        If FixedPriceEndPos = 0 Then
				        FixedPriceEndPos = Len(DiscountScript) + 1
			        End If
			        FixedPrice = Mid(DiscountScript, FixedPriceStartPos, FixedPriceEndPos - FixedPriceStartPos)
			        DiscountAmount = FormatCurrency(FixedPrice,2) & " Ticket Price"
		        End If
            End if
            
            'NewSurcharge
	        If InStr(1, DiscountScript, "NewSurcharge=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "NewSurcharge=") + 13
		        EndPos = InStr(StartPos, DiscountScript, "&")
		        If EndPos = 0 Then
			        EndPos = Len(DiscountScript) + 1
		        End If
		        NewSurcharge = Mid(DiscountScript, StartPos, EndPos - StartPos)
	        End If

	        'CalcServiceFee
	        If InStr(1, DiscountScript, "CalcServiceFee=") <> 0 Then
		        StartPos = 0
		        EndPos = 0
		        StartPos = InStr(1, DiscountScript, "CalcServiceFee=") + 15
		        CalcServiceFee = Mid(DiscountScript, StartPos, 1)
	        End If
    	    
	        If NewSurcharge <> "" Then
	            ServiceFees = FormatCurrency(NewSurcharge,2)
	        Else
	            If CalcServiceFee = "Y" Then
	                ServiceFees = "Recalculate Service Fee"
	            Else
	                ServiceFees = "No Service Fee Change"
	            End If
	        End If
            
          Response.Write "<TABLE WIDTH=""396"" BORDER=""1"" ALIGN=center>"
	        Response.Write "<TR CLASS=""FlexColumnHeading"" height=""25""><TD ALIGN=center colspan=""2"">Discount Type Info</TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Discount Type Number:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDiscount("DiscountTypeNumber") & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Discount Type:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & DiscountType & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Discount Code:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDiscount("DiscountCode") & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Discount Description:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDiscount("DiscountDescription") & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Online Flag:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & OnlineFlag & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Offline Flag:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & OfflineFlag & "</FONT></TD></TR>" & vbCrLf
   	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Applicable Ticket Type:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & SeatTypeCode & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Start Date:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & StartDate & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>End Date:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & ExpirationDate & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Maximum Number of Discounts Per Event:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & MaxDiscountsPerEvent & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Maximum Number of Discounts Per Order Per Event:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & MaxDiscountsPerOrderPerEvent & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Maximum Number of Discounts Per Order:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & MaxDiscountsPerOrder & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Maximum Discount Usage System-wide:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & MaxDiscountsSystemUsage & "</FONT></TD></TR>" & vbCrLf
	        If QtyToBuy <> "" And InStr(QtyToBuy,"/PrivateLabel/") = 0 Then
	            Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Quantity To Buy:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & QtyToBuy & "</FONT></TD></TR>" & vbCrLf
	        End If
	        If DiscountAmount <> "" Then
	            Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Discount Info:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & DiscountAmount & "</FONT></TD></TR>" & vbCrLf
	        End If
	        Response.Write "<TR><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2><B>Service Fees:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & ServiceFees & "</FONT></TD></TR>" & vbCrLf
	        Response.Write "</TABLE>" & vbCrLf
	    Else
	        Response.Write "Discount Type Information cannot be found." & vbCrLf    
	    End If
    Else
	    Response.Write "Discount Type Information cannot be found." & vbCrLf
    End If


rsDiscount.Close
Set rsDiscount = Nothing


%>