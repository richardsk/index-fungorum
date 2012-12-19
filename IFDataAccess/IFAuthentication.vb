Imports LSIDFramework
Imports CABIDataAccess

Public Enum AuthenticationLevel
    Full
    Restricted
End Enum

Public Class IFAuthentication
    Implements LSIDSecurityService

    Public Shared AccessLevel As AuthenticationLevel = AuthenticationLevel.Restricted

    Protected Overridable Sub initService(ByVal config As LSIDServiceConfig) Implements LSIDSecurityService.initService

    End Sub

    Public Function authenticate(ByVal req As LSIDRequestContext) As AuthenticationResponse Implements LSIDSecurityService.authenticate
        Dim resp As New AuthenticationResponse
        resp.Success = True

        AccessLevel = AuthenticationLevel.Full

        Dim da As New IFDataAccess
        Dim pos = req.Lsid.Lsid.LastIndexOf(":")
        Dim id As String = req.Lsid.Lsid.Substring(pos + 1)
        Dim lfyf As String = da.LastFiveYearsFlagByKey(Long.Parse(id))

        If lfyf.ToUpper = "X" Then
            AccessLevel = AuthenticationLevel.Restricted

            Dim ips As String = "," + Configuration.ConfigurationSettings.AppSettings.Get("AuthenticatedIPs") + ","
            Dim pass As String = "," + Configuration.ConfigurationSettings.AppSettings.Get("AuthenticatedPasswords") + ","

            Dim callerIP As String = req.Credentials.getProperty("IPAddress")

            'password ?
            Dim callerPass As String = ""
            If Not req.Credentials Is Nothing Then
                callerPass = req.Credentials.getProperty(req.Credentials.BASICPASSWORD)
            End If

            If ips.IndexOf("," + callerIP + ",") <> -1 Or pass.IndexOf("," + callerPass + ",") <> -1 Then
                AccessLevel = AuthenticationLevel.Full
            End If
        End If

        'always return true, but maintain an access restriction level
        Return resp
    End Function
End Class
