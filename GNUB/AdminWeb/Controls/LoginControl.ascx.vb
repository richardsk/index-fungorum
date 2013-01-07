
Partial Class Controls_LoginControl
    Inherits System.Web.UI.UserControl

    Protected Sub loginButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles loginButton.Click
        Try
            errLabel.Text = ""

            Dim gda As New GNUBDataAccess.GNUBAdminEntities
            Dim sha As System.Security.Cryptography.SHA1 = System.Security.Cryptography.SHA1.Create()
            Dim pwd As Byte() = sha.ComputeHash(UTF8Encoding.UTF8.GetBytes(pwdText.Text))

            Dim u = From users In gda.User Select users.Password, users.UserLogin Where UserLogin = userText.Text
            If Utility.ByteArraysEqual(u.First.Password, pwd) Then
                Session("User") = userText.Text
                Response.Redirect("~/default.aspx")
            Else
                errLabel.Text = "Incorrect username or password"
            End If

        Catch ex As Exception
            errLabel.Text = "Failed to login"
        End Try
    End Sub

End Class
