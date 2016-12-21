<%
    'CHANGE LOG
    'TTT 8/2/2012 - Used GenericSurvey as template to create this custom survey    
%>
<%@ Implements Interface="IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>

<script runat="server">
    Private SurveyNumber As Integer = 0
    Private StrLastSurvey As String = ""
    Dim NumTickets As String = 0
    
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
        Dim DBTix, DBTix2 As New SqlConnection
        Dim DBCmd As New SqlCommand
        Dim DataReader, DataReader2 As SqlDataReader

        DBOpen(DBTix)
        
        If SurveyNumber = 0 Then
            If LCase(SubDomain()) = "m" Then
                Response.Redirect("/m/ShoppingCart.aspx")
            Else
                Response.Redirect("/ShoppingCart.aspx")
            End If
        End If
        
        Dim SurveyFileName, SurveyTitle, SurveyHeader, SurveyFooter As String
        Dim OrganizationNumber As Integer
        Dim SQLSurvey As String = "SELECT SurveyFileName, OrganizationNumber, TotalQuestions, IsNull(SurveyTitle,'') AS SurveyTitle, IsNull(SurveyHeader,'') AS SurveyHeader, IsNull(SurveyFooter,'') AS SurveyFooter FROM Survey WITH (NOLOCK) WHERE SurveyNumber = @SurveyNumber"
        DBCmd = New SqlCommand(SQLSurvey, DBTix)
        DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows() Then
            DataReader.Read()
            SurveyFileName = DataReader("SurveyFileName")
            OrganizationNumber = DataReader("OrganizationNumber")
            SurveyTitle = DataReader("SurveyTitle")
            SurveyHeader = DataReader("SurveyHeader")
            SurveyFooter = DataReader("SurveyFooter")
        End If
        DataReader.Close()
        
        Dim SQLCurQuesNo As String = "SELECT COUNT(OrderLine.LineNumber) AS TotalTix FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.SurveyNumber = @SurveyNumber"
        DBCmd = New SqlCommand(SQLCurQuesNo, DBTix)
        DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
        DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows() Then
            DataReader.Read()
            NumTickets = DataReader("TotalTix")
        End If
        DataReader.Close()
        
        Dim SurveyStrVal As String = ""
        
        If SurveyTitle <> "" Then
            SurveyStrVal = "<center><FONT SIZE=2><H3>" & SurveyTitle & "</H3></FONT></center>" & vbCrLf
        Else
            SurveyStrVal = "<center><FONT SIZE=2><H3>Survey</H3></FONT></center>" & vbCrLf
        End If
        
        If SurveyHeader <> "" Then
            SurveyStrVal = SurveyStrVal & "<FONT SIZE=2>" & SurveyHeader & "</FONT>" & vbCrLf
        End If
        
        SurveyStrVal = SurveyStrVal & "<BR><table cellpadding=0 cellspacing=0 border=0 width=""600"">" & vbCrLf
        
        Dim QuestionRequired As Boolean = False
        For i As Integer = 1 To NumTickets
            SurveyStrVal = SurveyStrVal & "<tr><td><BR><FONT SIZE=""2""><b><u>Attendee " & i & "</u></b></FONT><BR></td></tr>" & vbCrLf
            Dim SQLSurveyQues As String = "SELECT QuestionNumber, QuestionText, QuestionType, QuestionRequired FROM SurveyQuestion WITH (NOLOCK) WHERE SurveyNumber = @SurveyNumber ORDER BY IsNull(SortOrder,1), QuestionNumber"
            DBCmd = New SqlCommand(SQLSurveyQues, DBTix)
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            Dim IsRequired As String
            Do While DataReader.Read()
                IsRequired = ""
                If Not IsDBNull(DataReader("QuestionRequired")) Then
                    If DataReader("QuestionRequired") = "Y" Then
                        QuestionRequired = True
                        IsRequired = " *"
                    End If
                End If
            
                SurveyStrVal = SurveyStrVal & "<tr><td align=""left""><BR><FONT SIZE=""2"">" & DataReader("QuestionText") & IsRequired & "</FONT>"
                If i = 1 Then
                    SurveyStrVal = SurveyStrVal & "<input type=""hidden"" name=""Question" & DataReader("QuestionNumber") & """ value=""" & DataReader("QuestionText") & """ />"
                End If
                SurveyStrVal = SurveyStrVal & "</td></tr>" & vbCrLf

                SurveyStrVal = SurveyStrVal & "<tr><td align=""left"">" & vbCrLf
                'Only for question type of dropdown list
                If DataReader("QuestionType") = "select" Then
                    SurveyStrVal = SurveyStrVal & "<select name=""Answer" & DataReader("QuestionNumber") & "_" & i & """ id=""Answer" & DataReader("QuestionNumber") & """><option value="""">- Select -</option>" & vbCrLf
                End If

                DBOpen(DBTix2)

                Dim SQLSurveyAns As String = "SELECT AnswerNumber, AnswerText, AnswerTextFieldIncluded FROM SurveyAnswer WITH (NOLOCK) WHERE SurveyNumber = @SurveyNumber AND QuestionNumber = @QuestionNumber ORDER BY AnswerNumber"
                DBCmd = New SqlCommand(SQLSurveyAns, DBTix2)
                DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
                DBCmd.Parameters.AddWithValue("@QuestionNumber", DataReader("QuestionNumber"))
                DataReader2 = DBCmd.ExecuteReader()
                DBCmd.Parameters.Clear()
                Do While DataReader2.Read()
                    If DataReader("QuestionType") = "checkbox" Or DataReader("QuestionType") = "radio" Then
                        SurveyStrVal = SurveyStrVal & "<INPUT TYPE=""" & DataReader("QuestionType") & """ NAME=""Answer" & DataReader("QuestionNumber") & "_" & i & """ VALUE=""" & DataReader2("AnswerText") & """><FONT SIZE=""2"">" & DataReader2("AnswerText") & "</FONT>" & vbCrLf
                        If Not IsDBNull(DataReader2("AnswerTextFieldIncluded")) Then
                            If DataReader2("AnswerTextFieldIncluded") = "Y" Then
                                SurveyStrVal = SurveyStrVal & "<INPUT TYPE=""text"" NAME=""" & DataReader2("AnswerText") & "_" & DataReader("QuestionNumber") & """ size=""50"">" & vbCrLf
                            End If
                        End If
                        SurveyStrVal = SurveyStrVal & "<br />" & vbCrLf
                    ElseIf DataReader("QuestionType") = "text" Then
                        SurveyStrVal = SurveyStrVal & "<FONT SIZE=""2"">" & DataReader2("AnswerText") & "</FONT>&nbsp;<INPUT TYPE=""text"" NAME=""Answer" & DataReader("QuestionNumber") & "_" & i & """ size=""50""><br />" & vbCrLf
                    Else 'dropdown list 
                        SurveyStrVal = SurveyStrVal & "<option value=""" & DataReader2("AnswerText") & """>" & DataReader2("AnswerText") & "</option>" & vbCrLf
                    End If
                Loop
                DataReader2.Close()
            
                DBClose(DBTix2)
            
                'Only for question type of dropdown list
                If DataReader("QuestionType") = "select" Then
                    SurveyStrVal = SurveyStrVal & "</select>" & vbCrLf
                End If

                SurveyStrVal = SurveyStrVal & "</td></tr>" & vbCrLf
            Loop
            DataReader.Close()
        Next
        
        SurveyStrVal = SurveyStrVal & "</table>" & vbCrLf
        
        If QuestionRequired Then
            SurveyStrVal = SurveyStrVal & "<BR><FONT SIZE=2>* - Answer Required</FONT><BR>" & vbCrLf
        End If
        
        If SurveyFooter <> "" Then
            SurveyStrVal = SurveyStrVal & "<BR><center><FONT SIZE=2>" & SurveyFooter & "</FONT></center>" & vbCrLf
        End If

        Dim lblSurvey As New Label
        lblSurvey.ID = "lblSurvey"
        lblSurvey.Attributes.Add("style", "text-align:left")
        lblSurvey.Text = SurveyStrVal
        phSurvey.Controls.Clear()
        phSurvey.Controls.Add(lblSurvey)
        
        DBClose(DBTix)    
    End Sub
 
    Public Function NextStep() As Boolean Implements IWizardStep.NextStep
        If Session("SurveyComplete") Is Nothing Then
            Dim DBTix As New SqlConnection
            Dim DBCmd As New SqlCommand
            Dim DataReader As SqlDataReader

            DBOpen(DBTix)
            
            Dim AnswersSubmitted As Boolean = True
            Dim SQLRequired As String = "SELECT QuestionNumber FROM SurveyQuestion WITH (NOLOCK) WHERE SurveyNumber = @SurveyNumber AND QuestionRequired = 'Y' ORDER BY QuestionNumber"
            DBCmd = New SqlCommand(SQLRequired, DBTix)
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            Do While DataReader.Read()
                For x As Integer = 1 To NumTickets
                    If Request("Answer" & DataReader("QuestionNumber") & "_" & x) = "" Then
                        AnswersSubmitted = False
                        Exit For
                    End If
                Next
            Loop
            DataReader.Close()
            
            If AnswersSubmitted = False Then
                Page.GetType().InvokeMember("wStepSurveyError", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                Return False
                Exit Function
            End If
            
            Dim NumQuestions As Integer = 0
            Dim SQLCurQuesNo As String = "SELECT IsNull(MAX(QuestionNumber),0) AS CurNo FROM SurveyQuestion WITH (NOLOCK) WHERE SurveyNumber = @SurveyNumber"
            DBCmd = New SqlCommand(SQLCurQuesNo, DBTix)
            DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
            DataReader = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader.HasRows() Then
                DataReader.Read()
                NumQuestions = DataReader("CurNo")
            End If
            DataReader.Close()
        
            Dim AnswerNumber, i, y As Integer
            For AnswerNumber = 1 To NumQuestions
                For y = 1 To NumTickets
                    If Clean(Request("Answer" & AnswerNumber & "_" & y)) <> "" Then
                        Dim AnswerArray = Split(Request("Answer" & AnswerNumber & "_" & y), ",")
                        For i = 0 To UBound(AnswerArray)
                            If AnswerArray(i) <> "" Then
                                Dim AnswerValue As String = ""
                                AnswerValue = AnswerArray(i)
                                If Request(AnswerValue & "_" & AnswerNumber) <> "" Then
                                    AnswerValue = AnswerValue & " - " & Request(AnswerValue & "_" & AnswerNumber)
                                End If
                                Dim SQLUpdateSurvey As String = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(@SurveyNumber,@OrderNumber,@CustomerNumber,@SurveyDate,@AnswerNumber,@Answer,@Question)"
                                DBCmd = New SqlCommand(SQLUpdateSurvey, DBTix)
                                DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
                                DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
                                DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
                                DBCmd.Parameters.AddWithValue("@SurveyDate", Now())
                                DBCmd.Parameters.AddWithValue("@AnswerNumber", AnswerNumber)
                                DBCmd.Parameters.AddWithValue("@Answer", Clean(AnswerValue))
                                DBCmd.Parameters.AddWithValue("@Question", Clean(Request("Question" & AnswerNumber)) & "")
                                DBCmd.ExecuteNonQuery()
                                DBCmd.Parameters.Clear()
                            End If
                        Next
                    End If
                Next
            Next
	    
            DBCmd.Dispose()
            DBClose(DBTix)
        
            If StrLastSurvey = "Y" Then
                Session("SurveyComplete") = Session("OrderNumber")
            End If
        End If
        
        Return True
    End Function
    
    Protected Sub Page_Init()
        If Not Session("SurveyComplete") Is Nothing Then
            Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
            If Not btnNext Is Nothing Then
                Page.GetType().InvokeMember("btnNext_Click", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            End If
        End If
    End Sub
    
</script>

<asp:PlaceHolder runat="server" ID="phSurvey"></asp:PlaceHolder>