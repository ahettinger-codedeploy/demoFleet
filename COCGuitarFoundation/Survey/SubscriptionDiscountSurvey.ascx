<%
    'CHANGE LOG
    'SLM 6/24/14 - Inception
%>
<%@ Implements Interface="Tix.IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>
<%@ Import Namespace="clsApplyDiscount" %>
<%@ Import Namespace="Tix" %>

<script runat="server">
    Private SurveyNumber As Integer = 0
    Private StrLastSurvey As String = ""
    
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
        Dim DBCmd, DBCmd2 As New SqlCommand
        Dim DataReader As SqlDataReader
        Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
        Dim OrderNumber As Integer = Session("OrderNumber")
        Dim DiscountNumber As Integer = 97824
        Dim DiscountCode As String = ""
        Dim Message As String = ""
        
        DBOpen(DBTix)
        
        Dim SQLDiscount As String = "SELECT DiscountCode FROM DiscountType WITH (NOLOCK) WHERE DiscountTypeNumber = @DiscountTypeNumber"
        DBCmd = New SqlCommand(SQLDiscount, DBTix)
        DBCmd.Parameters.AddWithValue("@DiscountTypeNumber", DiscountNumber)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows() Then
            DataReader.Read()
            DiscountCode = DataReader("DiscountCode")
        End If
        DataReader.Close()
        
        'Call and apply discount to all applicable tickets attached to Survey
        Dim SQLOrderLine As String = "SELECT OrderLine.LineNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.DiscountTypeNumber, OrderLine.SeatTypeCode, OrderLine.ItemType, Seat.EventCode, Seat.SectionCode FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = @OrderNumber AND Event.SurveyNumber = @SurveyNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY OrderLine.Price DESC"
        DBCmd = New SqlCommand(SQLOrderLine, DBTix)
        DBCmd.Parameters.AddWithValue("@OrderNumber", OrderNumber)
        DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()

        Dim LineNumber As Integer
        Dim Price As Double
        Dim NewPrice As Double
        Dim Surcharge As Double
        Dim NewSurcharge As Double
        Dim SeatTypeCode As Integer
        Dim DiscountAmount As Double
        Dim DiscountTypeNumber As Integer
        Dim AppliedFlag As String
        Dim DiscountApplied As String = "N"

        While DataReader.Read
            LineNumber = DataReader("LineNumber")
            Price = DataReader("Price")
            NewPrice = DataReader("Price")
            Surcharge = DataReader("Surcharge")
            NewSurcharge = DataReader("Surcharge")
            SeatTypeCode = DataReader("SeatTypeCode")
            DiscountAmount = 0
            DiscountTypeNumber = 0
            AppliedFlag = "N"
            Discount(OrderNumber, DataReader("LineNumber"), DataReader("EventCode"), DiscountCode, Price, Surcharge, SeatTypeCode, DataReader("SectionCode"), DataReader("ItemType"), NewPrice, NewSurcharge, DiscountAmount, DiscountTypeNumber, AppliedFlag)

            If AppliedFlag = "Y" Then
                DiscountApplied = "Y"
                Dim SQLUpdateOrderLine As String = "UPDATE OrderLine WITH (ROWLOCK) SET Price = @Price, Surcharge = @Surcharge, Discount = @Discount, DiscountTypeNumber = @DiscountTypeNumber, SeatTypeCode = @SeatTypeCode WHERE OrderNumber = @OrderNumber AND LineNumber = @LineNumber"
                DBCmd2 = New SqlCommand(SQLUpdateOrderLine, DBTix)
                DBCmd2.Parameters.AddWithValue("@OrderNumber", OrderNumber)
                DBCmd2.Parameters.AddWithValue("@LineNumber", LineNumber)
                DBCmd2.Parameters.AddWithValue("@Price", Price)
                DBCmd2.Parameters.AddWithValue("@Surcharge", NewSurcharge)
                DBCmd2.Parameters.AddWithValue("@Discount", DiscountAmount)
                DBCmd2.Parameters.AddWithValue("@DiscountTypeNumber", DiscountTypeNumber)
                DBCmd2.Parameters.AddWithValue("@SeatTypeCode", SeatTypeCode)
                DBCmd2.ExecuteNonQuery()
                DBCmd2.Parameters.Clear()

            End If
        End While
        DataReader.Close()
        
        'Check if any of the tickets with their events have this discount but yet not applied with a discount
        Dim SQLTixDiscountApplied As String = "SELECT TOP(1) OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN DiscountEvents WITH (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE OrderLine.OrderNumber = @OrderNumber AND DiscountEvents.DiscountTypeNumber = @DiscountTypeNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND OrderLine.DiscountTypeNumber <> @DiscountTypeNumber"
        DBCmd = New SqlCommand(SQLTixDiscountApplied, DBTix)
        DBCmd.Parameters.AddWithValue("@OrderNumber", OrderNumber)
        DBCmd.Parameters.AddWithValue("@DiscountTypeNumber", DiscountNumber)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows() Then
            DataReader.Read()
            Message = "You must purchase a complete subscription in order to complete the order."
        End If
        DataReader.Close()
        
        DBCmd.Dispose()
        DBCmd2.Dispose()
        DBClose(DBTix)
        
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
        Response.Redirect(PL("HomePage"))
    End Sub
    
</script>

<asp:Label runat="server" ID="lblTitle" Text="Subscription Discount Restriction" Font-Size="Medium" Font-Bold="true" /><br /><br />

<asp:Label runat="server" ID="lblMessage" Font-Size="Small" /><br /><br />

<asp:Label runat="server" ID="lblFooter" Text="Please click on the button below to return to your Shopping Cart and adjust your order accordingly." Font-Size="Small" /><br /><br />

<asp:Button ID="BackToShoppingBtn" runat="server" Text="Back To Shopping" BackColor="#31418C" ForeColor="White" Width="150" />