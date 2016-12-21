<%
    'CHANGE LOG
    'TTT 11/11/15 - Created MemberTypeTicketMaxValidation survey
    'TTT 11/11/15 - Updated with some minor/cosmetic changes
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
    Dim TicketMaxCount As Integer = 6
    
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
        Dim Message As String = ""
        
        If Not Session("MemberType") Is Nothing Then 'if PreSale code is logged in
            DBOpen(DBTix)
            
            'Check for all events belong to current MemberType
            Dim SQLEvents As String = "SELECT SUM(TotalTickets) AS TotalCount FROM ("
            SQLEvents += "SELECT COUNT(*) AS TotalTickets FROM Seat WITH (NOLOCK) INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN MemberSaleStartDate WITH (NOLOCK) ON Seat.EventCode = MemberSaleStartDate.EventCode WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND MemberSaleStartDate.MemberType = @MemberType AND Event.SurveyNumber = @SurveyNumber "
            SQLEvents += "UNION ALL SELECT COUNT(*) AS TotalTickets FROM Seat WITH (NOLOCK) INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN SurveyAnswers WITH (NOLOCK) ON OrderLine.OrderNumber = SurveyAnswers.OrderNumber WHERE OrderLine.OrderNumber <> @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND SurveyAnswers.SurveyNumber = @SurveyNumber AND SurveyAnswers.Answer = @MemberType) AS CountTable"
            DBCmd = New SqlCommand(SQLEvents, DBTix)
            DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
            DBCmd.Parameters.AddWithValue("@MemberType", Session("MemberType").ToString())
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader.HasRows Then
                DataReader.Read()
                If CInt(DataReader("TotalCount")) > TicketMaxCount Then
                    Message = "You exceeded the maximum of " & TicketMaxCount & " tickets which can be purchased for Presale code: " & Session("MemberType").ToString()
                End If
            End If
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
        End If
                
        If Message <> "" Then
            If Not btnNext Is Nothing Then
                btnNext.Visible = False
            End If
            lblMessage.Text = Message
        Else
            If Not btnNext Is Nothing Then
                Page.GetType().InvokeMember("btnNext_Click", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            End If
        End If
        
    End Sub
    
    Protected Sub btnBackToShopping_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BackToShoppingBtn.Click
        Response.Redirect("/ShoppingCart.aspx")
    End Sub
    
</script>

<asp:Label runat="server" ID="lblTitle" Text="Ticket Quantity Restriction" Font-Size="Medium" Font-Bold="true" /><br /><br />

<asp:Label runat="server" ID="lblMessage" Font-Size="Small" /><br /><br />

<asp:Label runat="server" ID="lblFooter" Text="Please click on the Back to Shopping Cart button below to remove the additional tickets." Font-Size="Small" /><br /><br />

<asp:Button ID="BackToShoppingBtn" runat="server" Text="Back to Shopping Cart" CssClass="TixButtonBack" />