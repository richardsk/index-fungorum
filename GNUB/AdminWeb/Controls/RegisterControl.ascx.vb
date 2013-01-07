Imports System.Configuration

Partial Class Controls_RegisterControl
    Inherits System.Web.UI.UserControl

    Protected Sub registerButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles registerButton.Click
        If Page.IsPostBack Then
            If userText.Text.Length = 0 Or emailText.Text.Length = 0 Then
                errLabel.Text = "Must complete bothe user name and email to register"
            Else
                Try
                    'todo - providerid
                    Dim provid As Guid = Guid.NewGuid
                    GNUBBusinessRules.Admin.AddUser(provid, userText.Text, Guid.NewGuid.ToString, emailText.Text, False)
                Catch ex As Exception
                    errLabel.Text = ex.Message
                End Try
            End If
        End If
    End Sub
End Class
