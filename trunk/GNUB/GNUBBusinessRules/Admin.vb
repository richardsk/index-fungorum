Imports System.Configuration
Imports System.Text

Public Class Admin

    Public Shared Function AddUser(ByVal providerId As Guid, ByVal login As String, ByVal pwdStr As String, ByVal email As String, ByVal isPrimary As Boolean) As GNUBDataAccess.User
        Dim gda As New GNUBDataAccess.GNUBAdminEntities

        Dim newUser As GNUBDataAccess.User = Nothing

        Dim u = From users In gda.User Where users.UserLogin = login Select users
        If u.Count > 0 Then
            Throw New Exception("User already exists")
        Else
            Dim sha As New System.Security.Cryptography.SHA1CryptoServiceProvider
            Dim pwd As Byte() = sha.ComputeHash(UTF8Encoding.UTF8.GetBytes(pwdStr))

            newUser = GNUBDataAccess.User.CreateUser(Guid.NewGuid, login, pwd, email, True)
            gda.AddToUser(newUser)
            newUser.UserProvider.Add(GNUBDataAccess.UserProvider.CreateUserProvider(newUser.UserID, providerId))
            newUser.UserProvider(0).Provider = (From p In gda.Provider Where p.ProviderID = providerId Select p).First
            newUser.UserProvider(0).IsPrimary = isPrimary
            gda.SaveChanges()

            'todo ??
            'disabled by default - will enable when user clicks link in email
            'send email
            'SendEmail(login, pwdStr, email)
        End If

        Return newUser
    End Function

    Public Shared Sub SendEmail(ByVal login As String, ByVal pwdStr As String, ByVal emailAddr As String)

        Dim adminEmail As String = ConfigurationManager.AppSettings.Get("EmailFrom")

        Dim body As String = "<html>You have successfully registered as a GNUB user.<br/><br/>To complete your registeration, click the link below.<br/><br/><a href='"
        body += ConfigurationManager.AppSettings.Get("CompleteRegUrl") + "?uid=" + login + "&pwd=" + pwdStr
        body += "</a><br/><br/>If any issues arise, contact the administrator at <a href='mailto:'" + adminEmail + ">" + adminEmail + "</a><html>"
        Dim msg As New Net.Mail.MailMessage(adminEmail, emailAddr, ConfigurationManager.AppSettings.Get("RegisterEmailSubject"), body)
        msg.IsBodyHtml = True

        Dim cl As New Net.Mail.SmtpClient
        cl.Host = ConfigurationManager.AppSettings.Get("SMTPHost")
        cl.Send(msg)
    End Sub

    Public Shared Sub SaveProvider(ByVal providerId As Guid, ByVal providerName As String, ByVal url As String, ByVal contactUserLogin As String)

        Dim gda As New GNUBDataAccess.GNUBAdminEntities
        Dim p As GNUBDataAccess.Provider = (From provs In gda.Provider Where provs.ProviderID = providerId Select provs).First

        p.ProviderName = providerName
        p.Url = url

        Dim curUser As GNUBDataAccess.UserProvider = (From ups In gda.UserProvider Where ups.Provider.ProviderID = providerId And ups.IsPrimary = True Select ups).First
        curUser.User = (From users In gda.User Where users.UserID = curUser.UserId Select users).First
        If contactUserLogin <> curUser.User.UserLogin Then
            curUser.IsPrimary = False
            Dim up As GNUBDataAccess.UserProvider = (From ups In gda.UserProvider Where ups.User.UserLogin = contactUserLogin And ups.Provider.ProviderID = providerId).First
            up.IsPrimary = True
        End If

        gda.SaveChanges()

    End Sub
End Class
