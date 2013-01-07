Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports System.ServiceModel.Description


Module Module1

    Sub Main()

        Dim b As New WebHttpBinding
        Dim sh As New WebServiceHost(GetType(GNUBService.NamesRESTService))
        sh.AddServiceEndpoint(GetType(GNUBService.INamesREST), b, "http://localhost:4321/gnubnames/")

        sh.Open()

        Console.WriteLine("Press a key to end")
        Console.ReadLine()
    End Sub

End Module
