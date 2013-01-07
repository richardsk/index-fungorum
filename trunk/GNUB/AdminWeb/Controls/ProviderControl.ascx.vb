
Partial Class Controls_ProviderControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim provId As Guid = New Guid(Request.QueryString("provId"))

            Dim gda As New GNUBDataAccess.GNUBAdminEntities

            Dim p As GNUBDataAccess.Provider = (From provs In gda.Provider Where provs.ProviderID = provId Select provs).First

            provNameText.Text = p.ProviderName
            urlText.Text = p.Url

            userCombo.Items.Clear()
            Dim idx As Integer = 0
            For Each u In From users In gda.User Join up In gda.UserProvider On up.User.UserID Equals users.UserID Where up.Provider.ProviderID = provId Select users, up.IsPrimary
                userCombo.Items.Add(u.users.UserLogin)
                If u.IsPrimary Then
                    idx = userCombo.Items.Count - 1
                End If
            Next
            userCombo.SelectedIndex = idx

            hiddenProvId.Value = provId.ToString
        Catch ex As Exception
            errLabel.Text = "Error loading provider.  Contact the administrator if this error persists."

        End Try
    End Sub

    Protected Sub SaveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        Try
            Dim provId As Guid = New Guid(hiddenProvId.Value)

            GNUBBusinessRules.Admin.SaveProvider(provId, provNameText.Text, urlText.Text, userCombo.SelectedValue)

            errLabel.Text = "Changes saved."
        Catch ex As Exception
            errLabel.Text = "Error saving provider.  Contact the administrator if this error persists."

        End Try
    End Sub

    Protected Sub CncButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles CncButton.Click
        Response.Redirect("default.aspx?tab=home")
    End Sub
End Class
