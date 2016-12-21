<%
    'CHANGE LOG
    'TTT 3/9/16 - Created
%>
<%@ Implements Interface="Tix.IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>
<%@ Import Namespace="Tix" %>

<script runat="server">
    Private SurveyNumber As Integer = 0
    Private StrLastSurvey As String = ""
    Dim DiscountTypeNumber As String = "123050"
    Dim SeriesPercentage As Double = 1.0
    Dim MemberEventCode As String = "846980,846981,846982"
    Dim AllowedSeatType As String = "8120,8121"

    Public WriteOnly Property SetSurveyNumber() As Integer
        Set(ByVal Value As Integer)
            SurveyNumber = Value
        End Set
    End Property

    Public WriteOnly Property SetLastSurvey() As String
        Set(ByVal Value As String)
            StrLastSurvey = Value
        End Set
    End Property

    Public Sub LoadStep() Implements IWizardStep.LoadStep

    End Sub

    Public Function NextStep() As Boolean Implements IWizardStep.NextStep
        Return True
    End Function

    Protected Sub Page_Init()
        Dim DBTix As New SqlConnection
        Dim DBCmd As New SqlCommand
        Dim DataReader As SqlDataReader
        Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
        Dim RequiredCount As Integer = 0

        DBOpen(DBTix)

        'Determine if required event is on the current order or has already been purchased.
        Dim SQLEvents As String = "SELECT SUM(TicketCount) AS TotalCount FROM ("
        SQLEvents += "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode IN (SELECT IntValue FROM fnCsvToInt(@EventCode)) AND OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType = 'Seat' "
        SQLEvents += "UNION ALL SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = @CustomerNumber AND EventCode IN (SELECT IntValue FROM fnCsvToInt(@EventCode)) AND OrderHeader.OrderNumber <> @OrderNumber AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType = 'Seat') AS CountTable"
        DBCmd = New SqlCommand(SQLEvents, DBTix)
        DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
        DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
        DBCmd.Parameters.AddWithValue("@EventCode", MemberEventCode)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows Then
            DataReader.Read()
            RequiredCount = DataReader("TotalCount")
        End If
        DataReader.Close()

        If RequiredCount >= 1 Then
            Dim Count As Integer = 0
            Dim CurrentOrderTicketCount As Integer = 0
            Dim AllowedTicketCount As Integer = 0    'Total number of free tickets allowed
            Dim AppliedTicketCount As Integer = 0    'Number of free tickets already given
            Dim AvailableTicketCount As Integer = 0    'Number of free tickets available for this order

            'Determine the total number of discounted tickets orginally due to the paton
            Dim SQLFreeTickets As String = "SELECT Seat.EventCode, COUNT(*) AS TixCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE ((OrderHeader.CustomerNumber = @CustomerNumber AND OrderHeader.OrderNumber <> @OrderNumber AND OrderLine.StatusCode = 'S') OR OrderHeader.OrderNumber = @OrderNumber) AND Seat.EventCode IN (SELECT IntValue FROM fnCsvToInt(@EventCode)) AND OrderLine.ItemType = 'Seat' AND OrderLine.SeatTypeCode IN (SELECT IntValue FROM fnCsvToInt(@SeatTypeCode)) GROUP BY Seat.EventCode"
            DBCmd = New SqlCommand(SQLFreeTickets, DBTix)
            DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
            DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
            DBCmd.Parameters.AddWithValue("@EventCode", MemberEventCode)
            DBCmd.Parameters.AddWithValue("@SeatTypeCode", AllowedSeatType)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader.HasRows Then
                Dim SubEvents() As String = Split(MemberEventCode, ",")
                Do While DataReader.Read()
                    Select Case DataReader("EventCode")
                        Case SubEvents(0) '846980 = Flex 16-17
                            Count = 6
                        Case SubEvents(1) '846981 = Both
                            Count = 9
                        Case SubEvents(2) '846982 = Renaissance
                            Count = 3
                    End Select

                    AllowedTicketCount = AllowedTicketCount + (Count * DataReader("TixCount"))
                Loop
            End If
            DataReader.Close()

            'Determine number of discounted tickets already given to the patron
            Dim SQLApplied As String = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = @CustomerNumber AND OrderLine.DiscountTypeNumber IN (SELECT IntValue FROM fnCsvToInt(@DiscountTypeNumber)) AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType = 'Seat'"
            DBCmd = New SqlCommand(SQLApplied, DBTix)
            DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
            DBCmd.Parameters.AddWithValue("@DiscountTypeNumber", DiscountTypeNumber)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader.HasRows Then
                DataReader.Read()
                AppliedTicketCount = DataReader("TicketCount")
            End If
            DataReader.Close()

            'Determine the number of tickets on the order
            Dim SQLCurrentOrder As String = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = @OrderNumber AND Event.SurveyNumber = @SurveyNumber AND OrderLine.ItemType = 'Seat'"
            DBCmd = New SqlCommand(SQLCurrentOrder, DBTix)
            DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader.HasRows Then
                DataReader.Read()
                CurrentOrderTicketCount = DataReader("TicketCount")
            End If
            DataReader.Close()

            'Determine number of discounted tickets remaining
            AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)

            If AvailableTicketCount > 0 Then
                If CurrentOrderTicketCount > AvailableTicketCount Then
                    CurrentOrderTicketCount = AvailableTicketCount
                End If
                If Not btnNext Is Nothing Then
                    btnNext.Text = "No Thanks!"
                End If
                lblMessage.Text = "Your subscription qualifies you for " & AvailableTicketCount & " season ticket(s)."
                For i As Integer = 0 To CurrentOrderTicketCount
                    ddlQty.Items.Add(New ListItem(i.ToString(), i.ToString()))
                Next

                Dim SQLSelectedCount As String = "SELECT ISNULL(Answer,0) AS Answer FROM SurveyAnswers WITH (NOLOCK) WHERE OrderNumber = @OrderNumber AND SurveyNumber = @SurveyNumber AND Question = 'Please select the number of tickets to redeem'"
                DBCmd = New SqlCommand(SQLSelectedCount, DBTix)
                DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
                DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
                DataReader = DBCmd.ExecuteReader()
                DBCmd.Parameters.Clear()
                If DataReader.HasRows Then
                    DataReader.Read()
                    If IsNumeric(DataReader("Answer")) AndAlso Convert.ToInt32(DataReader("Answer")) > 0 Then
                        Try
                            ddlQty.Items.FindByText(DataReader("Answer")).Selected = True
                        Catch ex As Exception
                        End Try
                    End If
                End If
                DataReader.Close()
            Else
                If Not btnNext Is Nothing Then
                    Page.GetType().InvokeMember("btnNext_Click", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                End If
            End If
        Else
            If Not btnNext Is Nothing Then
                Page.GetType().InvokeMember("btnNext_Click", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            End If
        End If

        DBCmd.Dispose()
        DBClose(DBTix)

    End Sub

    Protected Sub btnRedeemTickets_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRedeemTickets.Click
        If Not String.IsNullOrEmpty(ddlQty.SelectedValue) Then
            If Convert.ToInt32(ddlQty.SelectedValue) > 0 Then
                Dim DBTix As New SqlConnection
                Dim DBCmd As New SqlCommand

                DBOpen(DBTix)

                Dim SQLMemberSurvey As String = "IF NOT EXISTS (SELECT CustomerNumber FROM SurveyAnswers WITH (NOLOCK) WHERE OrderNumber = @OrderNumber AND SurveyNumber = @SurveyNumber AND Question = @Question) BEGIN INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(@SurveyNumber,@OrderNumber,@CustomerNumber,@SurveyDate,@AnswerNumber,@Answer,@Question) END ELSE BEGIN UPDATE SurveyAnswers WITH (ROWLOCK) SET Answer = @Answer, SurveyDate = @SurveyDate WHERE OrderNumber = @OrderNumber AND SurveyNumber = @SurveyNumber AND Question = @Question END"
                DBCmd = New SqlCommand(SQLMemberSurvey, DBTix)
                DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
                DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
                DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
                DBCmd.Parameters.AddWithValue("@SurveyDate", Now())
                DBCmd.Parameters.AddWithValue("@AnswerNumber", 1)
                DBCmd.Parameters.AddWithValue("@Answer", ddlQty.SelectedValue)
                DBCmd.Parameters.AddWithValue("@Question", "Please select the number of tickets to redeem")
                DBCmd.ExecuteNonQuery()
                DBCmd.Parameters.Clear()

                DBCmd.Dispose()
                DBClose(DBTix)
            Else
                CancelRedeem()
            End If

            Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
            If Not btnNext Is Nothing Then
                Page.GetType().InvokeMember("btnNext_Click", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            End If
        End If
    End Sub

    Protected Sub CancelRedeem()
        Dim DBTix As New SqlConnection
        Dim DBCmd As New SqlCommand

        DBOpen(DBTix)

        Dim SQLDeleteSurvey As String = "DELETE SurveyAnswers WHERE OrderNumber = @OrderNumber AND SurveyNumber = @SurveyNumber AND Question = @Question"
        DBCmd = New SqlCommand(SQLDeleteSurvey, DBTix)
        DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
        DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
        DBCmd.Parameters.AddWithValue("@Question", "Please select the number of tickets to redeem")
        DBCmd.ExecuteNonQuery()
        DBCmd.Parameters.Clear()

        DBCmd.Dispose()
        DBClose(DBTix)
    End Sub

</script>

<asp:Label runat="server" ID="lblTitle" Text="Welcome Back Season Subscriber" Font-Size="Medium" Font-Bold="true" /><br /><br />

<asp:Label runat="server" ID="lblMessage" Font-Size="Small" /><br /><br />

<asp:Label runat="server" ID="lblFooter" Text="Please select the number of tickets to redeem:" Font-Size="Small" />&nbsp;
<asp:DropDownList runat="server" ID="ddlQty" ForeColor="Black" /><br /><br />

<asp:Button ID="btnRedeemTickets" runat="server" Text="Redeem Tickets" CssClass="TixButtonNext" />