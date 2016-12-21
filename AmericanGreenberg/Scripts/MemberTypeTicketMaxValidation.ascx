<%@ Implements Interface="Tix.IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>
<%@ Import Namespace="Tix" %>

<script runat="server">
    'CHANGE LOG
    'TTT 4/5/12 - Created CustomUserControl
    'TTT 4/10/12 - Enabled multiple events purchase and changed exceed max tickets text
    'SLM 10/29/15 - Copied for Greenberg and updated with Greenberg-specific message and survey number
    
    Public Sub LoadStep() Implements IWizardStep.LoadStep
        'Hide Continue Button
        Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
        If Not btnNext Is Nothing Then
            btnNext.Visible = False
        End If
        
        If Not Session("MemberType") Is Nothing Then
            Dim DBTix As New SqlConnection
            Dim DBCmd As New SqlCommand
            Dim DataReader As SqlDataReader
            Dim EventCode As Integer = 0
            Dim EventCount As Integer = 0
            Dim SurveyNumber As Integer = 1993
            Dim MaxTixPerMemberEvent As Integer = 0
            Dim TotalTixPurchased As Integer = 0
            
            DBOpen(DBTix)
            
            'Check for number of events belong to current MemberType
            Dim SQLEvents As String = "SELECT COUNT(DISTINCT EventCode) AS EventCount, SUM(TotalTickets) AS TotalTickets FROM ("
            SQLEvents += "SELECT Seat.EventCode, COUNT(*) AS TotalTickets FROM Seat WITH (NOLOCK) INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN MemberSaleStartDate WITH (NOLOCK) ON Seat.EventCode = MemberSaleStartDate.EventCode WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND MemberSaleStartDate.MemberType = @MemberType GROUP BY Seat.EventCode "
            SQLEvents += "UNION ALL SELECT Seat.EventCode, COUNT(*) AS TotalTickets FROM Seat WITH (NOLOCK) INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN SurveyAnswers WITH (NOLOCK) ON OrderLine.OrderNumber = SurveyAnswers.OrderNumber WHERE OrderLine.OrderNumber <> @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND SurveyAnswers.SurveyNumber = @SurveyNumber AND SurveyAnswers.Answer = @MemberType GROUP BY Seat.EventCode) AS CountTable"
            DBCmd = New SqlCommand(SQLEvents, DBTix)
            DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
            DBCmd.Parameters.AddWithValue("@MemberType", Session("MemberType").ToString())
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader.HasRows Then
                DataReader.Read()
                EventCount = CInt(DataReader("EventCount"))
                TotalTixPurchased = CInt(DataReader("TotalTickets"))
            End If
            DataReader.Close()
            
            If EventCount > 1 Then 'Customer purchases more than 1 event on order
                'lblErrorMsg.Text = "You can only purchase tickets to one event.  Please remove the tickets to the event(s) you do not wish to keep."
                Session("Checkout") = Session("OrderNumber")
                Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                Response.Redirect("Pay.aspx")
            Else
                'Check for max tickets allowed
                If EventCount <> 0 Then
                    Dim SQLMaxTix As String = "SELECT EventCode, OptionValue As MaxTix FROM EventOptions WITH (NOLOCK) WHERE EventCode IN (SELECT DISTINCT EventCode FROM Seat WITH (NOLOCK) INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')) AND OptionName = 'MaxTicketsOrderType_1&MemberType_" & Session("MemberType").ToString() & "'"
                    DBCmd = New SqlCommand(SQLMaxTix, DBTix)
                    DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
                    DataReader = DBCmd.ExecuteReader()
                    DBCmd.Parameters.Clear()
                    If DataReader.HasRows Then
                        DataReader.Read()
                        EventCode = CInt(DataReader("EventCode"))
                        MaxTixPerMemberEvent = CInt(DataReader("MaxTix"))
                    End If
                    DataReader.Close()
                    
                    If MaxTixPerMemberEvent > 0 Then
                        
                        Dim SQLMemberSurvey As String = "INSERT SurveyAnswers SELECT @SurveyNumber,@AnswerNumber, @OrderNumber,@CustomerNumber,@SurveyDate,@Question,@Answer "
                        SQLMemberSurvey += "WHERE NOT EXISTS (SELECT * FROM SurveyAnswers WITH (NOLOCK) WHERE OrderNumber = @OrderNumber AND SurveyNumber = @SurveyNumber AND Answer = @Answer)"
                        'SQLMemberSurvey += "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(@SurveyNumber,@OrderNumber,@CustomerNumber,@SurveyDate,@AnswerNumber,@Answer,@Question)"
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
                        
                        If TotalTixPurchased > MaxTixPerMemberEvent Then
                            'lblErrorMsg.Text = "You have reached your ticket purchase maximum.  Please empty your Shopping Cart."
                            lblErrorMsg.Text = "Our policy for tickets is that each dancer is allotted 6 tickets to purchase. If you need more than the allotted number you may then purchase more tickets when they go on sale to the public, November 11th. Thank you!"
                        Else
                            'Insert MemberType record into SurveyAnswers
                              
                            Session("Checkout") = Session("OrderNumber")
                            Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                            Response.Redirect("Pay.aspx")
                        End If
                    Else 'No limit on max tix customer can purchase
                        Session("Checkout") = Session("OrderNumber")
                        Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                        Response.Redirect("Pay.aspx")
                    End If
                Else 'MemberType logged in but customer does not buy any presale events
                    Session("Checkout") = Session("OrderNumber")
                    Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                    Response.Redirect("Pay.aspx")
            End If
            End If
            
            DBCmd.Dispose()
            DBClose(DBTix)
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

<br />
<asp:Label runat="server" ID="lblErrorMsg" Font-Bold="true" Font-Size="Small" />
<br />

