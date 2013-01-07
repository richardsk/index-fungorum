Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports System.ServiceModel.Description

Public Class GNUBAccess

    Protected Overrides Sub OnStart(ByVal args() As String)
        ' Add code here to start your service. This method should set things
        ' in motion so your service can do its work.

        Dim b As New WebHttpBinding
        Dim sh As New WebServiceHost(GetType(NamesRESTService))
        sh.AddServiceEndpoint(GetType(INamesREST), b, "http://localhost:4321/gnubnames/")
        sh.Open()

    End Sub

    Protected Overrides Sub OnStop()
        ' Add code here to perform any tear-down necessary to stop your service.
    End Sub

End Class
