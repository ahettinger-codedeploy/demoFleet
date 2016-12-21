<%@ Implements Interface="IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>

<script runat="server">
    'CHANGE LOG
    'TTT 3/21/13 - Created CustomUserControl
    
    Public Sub LoadStep() Implements IWizardStep.LoadStep
        If CStr(Session("MemberType")) = "AWFP17" Then
            Dim DBTix As New SqlConnection
            Dim DBCmd As New SqlCommand
            Dim DataReader As SqlDataReader
            Dim SurveyNumber As Integer = 1454
            Dim Message As String = ""
        
            DBOpen(DBTix)
            
            'Check for all events belong to current MemberType
            Dim SQLEvents As String = "SELECT Act, EventOptions.OptionValue AS MaxTix, SUM(TotalTickets) AS TotalTickets FROM ("
            SQLEvents += "SELECT Seat.EventCode, Act.Act, COUNT(*) AS TotalTickets FROM Seat WITH (NOLOCK) INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN MemberSaleStartDate WITH (NOLOCK) ON Seat.EventCode = MemberSaleStartDate.EventCode WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND MemberSaleStartDate.MemberType = @MemberType GROUP BY Seat.EventCode,Act.Act "
            SQLEvents += "UNION ALL SELECT Seat.EventCode, Act.Act, COUNT(*) AS TotalTickets FROM Seat WITH (NOLOCK) INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN SurveyAnswers WITH (NOLOCK) ON OrderLine.OrderNumber = SurveyAnswers.OrderNumber WHERE OrderLine.OrderNumber <> @OrderNumber AND OrderLine.StatusCode = 'S' AND OrderHeader.CustomerNumber = @CustomerNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND SurveyAnswers.SurveyNumber = @SurveyNumber AND SurveyAnswers.Answer = @MemberType GROUP BY Seat.EventCode,Act.Act) AS CountTable "
            SQLEvents += "INNER JOIN EventOptions WITH (NOLOCK) ON CountTable.EventCode = EventOptions.EventCode AND EventOptions.OptionName = @PreSaleCode GROUP BY Act, EventOptions.OptionValue"
            DBCmd = New SqlCommand(SQLEvents, DBTix)
            DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
            DBCmd.Parameters.AddWithValue("@MemberType", Session("MemberType").ToString())
            DBCmd.Parameters.AddWithValue("@PreSaleCode", "MaxTicketsOrderType_1&MemberType_" & Session("MemberType").ToString())
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            Do While DataReader.Read()
                If CInt(DataReader("TotalTickets")) > CInt(DataReader("MaxTix")) Then
                    Message += "The maximum number of '" & DataReader("Act") & "' tickets which can be purchased is: " & DataReader("MaxTix") & ".<BR>"
                    Message += "The total number of '" & DataReader("Act") & "' tickets you have either previously purchased or have on this order is: " & DataReader("TotalTickets") & "<BR><BR>"
                End If
            Loop
            DataReader.Close()
            
            Dim SQLMemberSurvey As String = "INSERT SurveyAnswers SELECT @SurveyNumber,@AnswerNumber, @OrderNumber,@CustomerNumber,@SurveyDate,@Question,@Answer "
            SQLMemberSurvey += "WHERE NOT EXISTS (SELECT * FROM SurveyAnswers WITH (NOLOCK) WHERE OrderNumber = @OrderNumber AND SurveyNumber = @SurveyNumber AND Answer = @Answer)"
            DBCmd = New SqlCommand(SQLMemberSurvey, DBTix)
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
            DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
            DBCmd.Parameters.AddWithValue("@SurveyDate", Now())
            DBCmd.Parameters.AddWithValue("@AnswerNumber", 1)
            DBCmd.Parameters.AddWithValue("@Answer", Session("MemberType").ToString())
            DBCmd.Parameters.AddWithValue("@Question", "Please enter your Pre-Sale Code")
            DBCmd.ExecuteNonQuery()
            DBCmd.Parameters.Clear()
            
            DBCmd.Dispose()
            DBClose(DBTix)
            
            If Message <> "" Then
                lblMessage.Text = Message
                lblInfo.Text = "You have exceeded the number of allotted tickets for one or some of the events on this order. Please click on the Shopping Cart tab above to remove the additional tickets."
                'Hide Continue Button
                Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
                If Not btnNext Is Nothing Then
                    btnNext.Visible = False
                End If
            Else
                Session("Checkout") = Session("OrderNumber")
                Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                Response.Redirect("Pay.aspx")
            End If
        Else
            Session("Checkout") = Session("OrderNumber")
            Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            Response.Redirect("Pay.aspx")
        End If
    End Sub
    
    Public Function NextStep() As Boolean Implements IWizardStep.NextStep
        Return False
    End Function
</script>

<asp:Label runat="server" ID="lblMaxTicketTitle" Font-Bold="true" Font-Size="Medium" Text="Maximum Ticket Allocation Exceeded" /><br /><br />
<asp:Label runat="server" ID="lblMessage" Font-Size="Small" /><br />
<asp:Label runat="server" ID="lblInfo" Font-Size="Small" /><br />