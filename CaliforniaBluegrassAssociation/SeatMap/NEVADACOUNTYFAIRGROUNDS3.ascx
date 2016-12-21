<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>

<script runat="server">
    'CHANGE LOG
    'TTT 12/4/12 - Created custom seat map
    Protected EventURL, TableCategoryBGColor, TableCategoryFontColor As String
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        TableCategoryBGColor = PL("TableCategoryBGColor")
        TableCategoryFontColor = PL("TableCategoryFontColor")
        
        'Hide generic price user control panel
        Dim PricePanel As Panel = CType(Me.Parent.FindControl("PricePanel"), Panel)
        If Not PricePanel Is Nothing Then
            PricePanel.Visible = False
        End If
        
        'Change generic header label text
        Dim SeatMapText As Label = CType(Me.Parent.FindControl("SeatMapText"), Label)
        If Not SeatMapText Is Nothing Then
            SeatMapText.Text = "Select from your preferred ticket level below:"
        End If
        
        If SubDomain() = "m" Then
            EventURL = "/m/Event.aspx"
        Else
            EventURL = "/Event.aspx"
        End If
        
        Dim MapPricing As String = "<TABLE WIDTH=""400"" border=0><TR><TD align=""left""><FONT SIZE=""2""><B><U>Section</U></B></FONT></TD><TD ALIGN=""left""><FONT SIZE=""2""><B><U>Price</U></B></FONT></TD></TR>"
        
        Dim DBTix As New SqlConnection
        Dim DBCmd As New SqlCommand
        Dim DataReader, DataReader2 As SqlDataReader
        
        DBOpen(DBTix)
        
        Dim SQLSeatCheck As String = "SELECT COUNT(Seat.ItemNumber) AS Count, Section.SectionCode, Section.Section FROM Seat WITH (NOLOCK) INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section WITH (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.EventCode = @EventCode AND Seat.StatusCode = 'A' GROUP BY Section.Priority, Section.SectionCode, Section.Section ORDER BY Section.Priority"
        DBCmd = New SqlCommand(SQLSeatCheck, DBTix)
        DBCmd.Parameters.AddWithValue("@EventCode", CleanNumeric(Request("EventCode")))
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
       
	   If DataReader.HasRows() Then
	   
		Do While DataReader.Read()
	   
            Dim SQLPrice As String = "SELECT MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice FROM Price WITH (NOLOCK) INNER JOIN Section WITH (NOLOCK) ON Price.SectionCode = Section.SectionCode AND Price.EventCode = Section.EventCode WHERE Price.EventCode = @EventCode AND Section.SectionCode = @SectionCode AND Price.OnLinePriceFlag <> 0"
            DBCmd = New SqlCommand(SQLPrice, DBTix)
            DBCmd.Parameters.AddWithValue("@EventCode", CleanNumeric(Request("EventCode")))
            DBCmd.Parameters.AddWithValue("@SectionCode", DataReader("SectionCode").ToString())
            DataReader2 = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
			
            If DataReader2.HasRows Then
   
				Do While DataReader2.Read()
				
					MapPricing += "<TR><TD align=""left""><INPUT TYPE=""button"" VALUE=""" & DataReader("Section") & """ onClick=""location.href='" & EventURL & "?EventCode=" & CleanNumeric(Request("EventCode")) & "&Section=" & DataReader("SectionCode") & "&Details=NO';""></TD>"
					If CDbl(DataReader2("MinPrice")) = CDbl(DataReader2("MaxPrice")) Then
						MapPricing += "<TD align=""left""><FONT SIZE=""2"">" & FormatCurrency(DataReader2("MaxPrice")) & "</FONT></TD>"
					Else
						MapPricing += "<TD align=""left""><FONT SIZE=""2"">" & FormatCurrency(DataReader2("MinPrice")) & "-" & FormatCurrency(DataReader2("MaxPrice")) & "</FONT></TD>"
					End If
					MapPricing += "</TR>"
					
				Loop
				DataReader2.NextResult()
				
				
            End If
			
            DataReader2.Close()
			
		Loop
		DataReader.NextResult()
			
      End If
		
        DataReader.Close()
		
        DBCmd.Dispose()
        DBClose(DBTix)
        
        MapPricing += "</TABLE>"
        
        lblMapPricing.Text = MapPricing
    End Sub
</script>

<br /><asp:Label runat="server" ID="lblMapPricing" />



