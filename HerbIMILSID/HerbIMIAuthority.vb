Imports LSIDClient
Imports LSIDFramework
Imports IFDataAccess

Public Class HerbIMIAuthority
    Inherits LSIDFramework.SimpleResolutionService


    Public Overrides Function doGetMetadata(ByVal ctx As LSIDFramework.LSIDRequestContext, ByVal acceptedFormats() As String) As LSIDClient.MetadataResponse
        Dim mr As MetadataResponse

        Try
            If acceptedFormats Is Nothing OrElse acceptedFormats.BinarySearch(acceptedFormats, MetadataResponse.RDF_FORMAT) <> -1 Then
                Dim id As String = ctx.Lsid.Object

                Dim da As New HerbIMIDataAccess
                Dim d As Integer = 100
                Try
                    d = Integer.Parse(Configuration.ConfigurationSettings.AppSettings.Get("MetadataExpiryDays"))
                Catch ex As Exception
                End Try
                Dim exp As Date = DateTime.Now.AddDays(d)
                Dim ms As New IO.MemoryStream
                Dim wr As New IO.StreamWriter(ms)
                wr.Write(da.SpecimenByKeyRDF(ctx.Lsid.ToString()))
                wr.Flush()
                ms.Position = 0
                mr = New MetadataResponse(ms, exp, MetadataResponse.XML_FORMAT)
            End If
        Catch le As LSIDException
            Throw le
        Catch ex As Exception
            Throw ex ' New LSIDServerException(ex, "Error retreiving metadata")
        End Try

        Return mr
    End Function

    Public Overrides Function getData(ByVal ctx As LSIDRequestContext) As IO.Stream
        Return Nothing
    End Function

    Protected Overrides Function getServiceName() As String
        Return "HerbIMIAuthority"
    End Function

    Protected Overrides Function hasData(ByVal req As LSIDFramework.LSIDRequestContext) As Boolean
        Return False
    End Function

    Protected Overrides Function hasMetadata(ByVal req As LSIDFramework.LSIDRequestContext) As Boolean
        Dim hm As Boolean = False
        Try
            Dim ls As New LSID(req.Lsid.ToString)
            If ls.Namespace = HerbIMIDataAccess.NS Then
                Dim mr As MetadataResponse = doGetMetadata(req, New String() {MetadataResponse.RDF_FORMAT})
                If Not mr Is Nothing AndAlso mr.getValue().ToString.Length > 0 Then
                    hm = True
                End If
            End If
        Catch ex As Exception
        End Try
        Return hm
    End Function

    Protected Overrides Sub validate(ByVal req As LSIDFramework.LSIDRequestContext)

    End Sub
End Class
