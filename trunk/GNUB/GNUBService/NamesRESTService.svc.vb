
Imports System.Xml
Imports System.Xml.Linq
Imports System.Web
Imports System.ServiceModel.Web
Imports System.ServiceModel.Channels
Imports System.Configuration
Imports System.Diagnostics

Public Class TextBodyWriter
    Inherits BodyWriter

    Private m_Text As String = ""

    Public Sub New(ByVal text As String)
        MyBase.New(True)
        m_Text = text
    End Sub

    Protected Overrides Sub OnWriteBodyContents(ByVal writer As System.Xml.XmlDictionaryWriter)
        writer.WriteStartElement("Binary")
        Dim b As Byte() = Text.UTF8Encoding.UTF8.GetBytes(m_Text)
        writer.WriteBase64(b, 0, b.Length)
        writer.WriteEndElement()
    End Sub
End Class

<ServiceContract()> _
Public Interface INamesREST

    <OperationContract()> _
    <WebGet(UriTemplate:="hello")> _
    Function Hello() As String

    <OperationContract()> _
    <WebGet(UriTemplate:="name/{nameId}")> _
    Function GetName(ByVal nameId As String) As Message

    <OperationContract()> _
    <WebGet(UriTemplate:="names/all")> _
    Function GetAllNames() As Message

End Interface

Public Class NamesRESTService
    Implements INamesREST

    Public Sub New()
    End Sub

    Public Function Hello() As String Implements INamesREST.Hello
        Return "hello"
    End Function

    Protected Function HandleError(ByVal ex As Exception) As Message
        Dim rEl As XElement = XElement.Load(New IO.StringReader("<?xml version=""1.0"" encoding=""utf-8""?>" + _
            "<html xmlns=""http://www.w3.org/1999/xhtml"" version=""-//W3C//DTD XHTML 2.0//EN"" xml:lang=""en"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" " + _
            "xsi:schemaLocation=""http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml2.xsd""><HEAD><TITLE>Request Error</TITLE></HEAD><BODY><DIV id=""content"">" + _
            "<P class=""heading1""><B>Internal Error:</B><br/>" + HttpUtility.HtmlEncode(ex.Message) + "</P></DIV></BODY></html>"))

        Dim rsp As Message = Message.CreateMessage(MessageVersion.None, "*", rEl)

        Dim p As New HttpResponseMessageProperty
        p.StatusCode = Net.HttpStatusCode.InternalServerError
        p.StatusDescription = ex.Message
        p.Headers(System.Net.HttpResponseHeader.ContentType) = "text/html"
        rsp.Properties(HttpResponseMessageProperty.Name) = p

        EventLog.WriteEntry("Application", ex.Message, EventLogEntryType.Error)

        Return rsp
    End Function

    Public Function GetName(ByVal nameId As String) As Message Implements INamesREST.GetName
        Dim resp As Message = Nothing

        'Dim nameId As String = m.GetReaderAtBodyContents().ReadContentAsString()

        Try
            Dim ctx As WebOperationContext = WebOperationContext.Current
            If ctx.IncomingRequest.Accept = "text/html" Then
                resp = GetHtml(nameId)
            ElseIf ctx.IncomingRequest.Accept = "application/rdf+xml" Then
                resp = GetRdf(nameId)
            ElseIf ctx.IncomingRequest.Accept = "application/csv" Or ctx.IncomingRequest.Accept = "*/*" Then
                resp = GetCsv(nameId)
            ElseIf ctx.IncomingRequest.Accept = "application/json" Then
                resp = GetJson(nameId)
            End If

        Catch ex As Exception
            resp = HandleError(ex)
        End Try

        Return resp
    End Function

    Public Function GetAllNames() As Message Implements INamesREST.GetAllNames
        Dim resp As Message = Nothing

        Try
            Dim ctx As WebOperationContext = WebOperationContext.Current
            'only csv, rdf or xml


            If ctx.IncomingRequest.Accept = "application/csv" Or ctx.IncomingRequest.Accept = "*/*" Then
                resp = GetCsvAll()
            Else
                'todo ? resp = GetRdfAll(Integer.Parse(page))
            End If

            'If ctx.IncomingRequest.Accept <> "application/csv" AndAlso ctx.IncomingRequest.Accept <> "application/rdf+xml" And ctx.IncomingRequest.Accept <> "application/xml+rdf" Then
            'resp.Properties(HttpResponseMessageProperty.Name).Headers(System.Net.HttpResponseHeader.ContentType) = "text/xml"
            'End If

        Catch ex As Exception
            resp = HandleError(ex)
        End Try

        Return resp
    End Function

    Protected Function GetCsvAll() As Message
        Dim rsp As Message = Nothing
 
        Dim ifModSince As String = WebOperationContext.Current.IncomingRequest.Headers("if-modified-since")
        Dim dt As DateTime
        If Not DateTime.TryParse(ifModSince, dt) Then dt = DateTime.MinValue

        Dim file As String = GNUBBusinessRules.TaxonNameUsage.GetLatestDumpFile(System.Configuration.ConfigurationManager.AppSettings.Get("csvFolder"))

        'Dim file As String = IO.Path.Combine(System.Configuration.ConfigurationManager.AppSettings.Get("webFolder"), "gnub.zip")

        If IO.File.GetLastWriteTime(file) < dt Then
            rsp = Message.CreateMessage(MessageVersion.None, "*", "")

            Dim p As New HttpResponseMessageProperty
            p.StatusCode = Net.HttpStatusCode.NotModified
            rsp.Properties(HttpResponseMessageProperty.Name) = p
        Else
            rsp = Message.CreateMessage(MessageVersion.None, "*", New TextBodyWriter(IO.File.ReadAllText(file)))

            Dim p As New HttpResponseMessageProperty
            p.StatusCode = Net.HttpStatusCode.OK
            p.Headers(System.Net.HttpResponseHeader.ContentType) = "application/csv"
            rsp.Properties(HttpResponseMessageProperty.Name) = p

            Dim cp As New WebBodyFormatMessageProperty(WebContentFormat.Raw)
            rsp.Properties(WebBodyFormatMessageProperty.Name) = cp
        End If

        Return rsp
    End Function

    Protected Function GetCsv(ByVal nameId As String) As Message
        Dim rsp As Message = Nothing
        Try
            Dim csv As String = GNUBBusinessRules.TaxonNameUsage.GetTNUDwC(nameId)

            rsp = Message.CreateMessage(MessageVersion.None, "*", New TextBodyWriter(csv))

            Dim p As New HttpResponseMessageProperty
            p.StatusCode = Net.HttpStatusCode.OK
            p.Headers(System.Net.HttpResponseHeader.ContentType) = "application/csv"
            rsp.Properties(HttpResponseMessageProperty.Name) = p

            Dim cp As New WebBodyFormatMessageProperty(WebContentFormat.Raw)
            rsp.Properties(WebBodyFormatMessageProperty.Name) = cp

        Catch ex As Exception
            rsp = HandleError(ex)
        End Try

        Return rsp
    End Function


    Protected Function GetHtml(ByVal nameId As String) As Message

        Dim rsp As Message = Message.CreateMessage(MessageVersion.None, "*", "")

        'TODO
        'Dim p As New HttpResponseMessageProperty
        'p.StatusCode = Net.HttpStatusCode.Redirect
        'p.Headers(System.Net.HttpResponseHeader.Location) = "http://nzflora.landcareresearch.co.nz/default.aspx?selected=NameDetails&TabNum=0&NameLsid=" + nameId
        'p.Headers(System.Net.HttpResponseHeader.ContentType) = "text/html"
        'rsp.Properties(HttpResponseMessageProperty.Name) = p

        Return rsp
    End Function

    Protected Function GetRdf(ByVal nameId As String) As Message
        'TODO
        'LandcareRDF.Names.LCRNamesDatasetURI = ConfigurationManager.AppSettings.Get("NamesDataset")
        'Dim rEl As XElement = XElement.Load(New IO.StringReader(LCR.SemanticWeb.LandcareRDF.Names.ResolveName(nameId)))

        'Dim rsp As Message = Message.CreateMessage(MessageVersion.None, "*", rEl)

        'Dim p As New HttpResponseMessageProperty
        'p.StatusCode = Net.HttpStatusCode.OK
        'p.Headers(System.Net.HttpResponseHeader.ContentType) = "application/rdf+xml"
        'rsp.Properties(HttpResponseMessageProperty.Name) = p

        'Return rsp
    End Function

    Protected Function GetRdfAll(ByVal page As Integer) As Message

        'TODO
        'LandcareRDF.Names.LCRNamesDatasetURI = ConfigurationManager.AppSettings.Get("NamesDataset")
        'Dim xmlStr As String = LCR.SemanticWeb.LandcareRDF.Names.GetAllNames(page)
        'Dim rEl As XElement = XElement.Load(New IO.StringReader(xmlStr))

        'Dim rsp As Message = Message.CreateMessage(MessageVersion.None, "*", rEl)

        'Dim p As New HttpResponseMessageProperty
        'p.StatusCode = Net.HttpStatusCode.OK
        'p.Headers(System.Net.HttpResponseHeader.ContentType) = "application/rdf+xml"
        'rsp.Properties(HttpResponseMessageProperty.Name) = p

        'Return rsp
    End Function

    Protected Function GetJson(ByVal nameId As String) As Message

        'TODO
        'LandcareRDF.Names.LCRNamesDatasetURI = ConfigurationManager.AppSettings.Get("NamesDataset")
        'Dim tn As TDWG_RDF.TaxonName = LCR.SemanticWeb.LandcareRDF.Names.GetName(nameId)
        'Dim ser As New Json.DataContractJsonSerializer(GetType(TDWG_RDF.TaxonName))

        'Dim rsp As Message = Message.CreateMessage(MessageVersion.None, "*", tn, ser)

        'Dim p As New HttpResponseMessageProperty
        'p.StatusCode = Net.HttpStatusCode.OK
        'p.Headers(System.Net.HttpResponseHeader.ContentType) = "application/json"
        'rsp.Properties(HttpResponseMessageProperty.Name) = p

        'Dim cp As New WebBodyFormatMessageProperty(WebContentFormat.Json)
        'rsp.Properties(WebBodyFormatMessageProperty.Name) = cp

        'Return rsp
    End Function


End Class
