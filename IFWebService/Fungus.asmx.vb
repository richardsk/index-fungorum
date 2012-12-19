Imports System.Web.Services
Imports System.Xml

<WebService(Namespace:="http://Cabi/FungusServer/")> _
Public Class Fungus
    Inherits System.Web.Services.WebService

#Region " Web Services Designer Generated Code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Web Services Designer.
        InitializeComponent()

        'Add your own initialization code after the InitializeComponent() call
        ConnectionString = System.Configuration.ConfigurationSettings.AppSettings("ConnectionString")
    End Sub

    'Required by the Web Services Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Web Services Designer
    'It can be modified using the Web Services Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents SqlDa_NameSearch As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents SqlSelectCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlCon_IndexFungorum As System.Data.SqlClient.SqlConnection
    Friend WithEvents SqlDa_EpithetSearch As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents SqlSelectCommand2 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlDa_Name As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents SqlSelectCommand3 As System.Data.SqlClient.SqlCommand
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SqlDa_NameSearch = New System.Data.SqlClient.SqlDataAdapter()
        Me.SqlSelectCommand1 = New System.Data.SqlClient.SqlCommand()
        Me.SqlCon_IndexFungorum = New System.Data.SqlClient.SqlConnection()
        Me.SqlDa_EpithetSearch = New System.Data.SqlClient.SqlDataAdapter()
        Me.SqlSelectCommand2 = New System.Data.SqlClient.SqlCommand()
        Me.SqlDa_Name = New System.Data.SqlClient.SqlDataAdapter()
        Me.SqlSelectCommand3 = New System.Data.SqlClient.SqlCommand()
        '
        'SqlDa_NameSearch
        '
        Me.SqlDa_NameSearch.SelectCommand = Me.SqlSelectCommand1
        Me.SqlDa_NameSearch.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "IndexFungorum", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("NAME OF FUNGUS", "NAME OF FUNGUS"), New System.Data.Common.DataColumnMapping("AUTHORS", "AUTHORS"), New System.Data.Common.DataColumnMapping("PUBLISHED LIST REFERENCE", "PUBLISHED LIST REFERENCE"), New System.Data.Common.DataColumnMapping("SPECIFIC EPITHET", "SPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC RANK", "INFRASPECIFIC RANK"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC EPITHET", "INFRASPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("ORTHOGRAPHY COMMENT", "ORTHOGRAPHY COMMENT"), New System.Data.Common.DataColumnMapping("TYPIFICATION DETAILS", "TYPIFICATION DETAILS"), New System.Data.Common.DataColumnMapping("MISAPPLICATION AUTHORS", "MISAPPLICATION AUTHORS"), New System.Data.Common.DataColumnMapping("VOLUME", "VOLUME"), New System.Data.Common.DataColumnMapping("PART", "PART"), New System.Data.Common.DataColumnMapping("PAGE", "PAGE"), New System.Data.Common.DataColumnMapping("YEAR OF PUBLICATION", "YEAR OF PUBLICATION"), New System.Data.Common.DataColumnMapping("YEAR ON PUBLICATION", "YEAR ON PUBLICATION"), New System.Data.Common.DataColumnMapping("SYNONYMY", "SYNONYMY"), New System.Data.Common.DataColumnMapping("HOST", "HOST"), New System.Data.Common.DataColumnMapping("LOCATION", "LOCATION"), New System.Data.Common.DataColumnMapping("ANAMORPH TELEOMORPH", "ANAMORPH TELEOMORPH"), New System.Data.Common.DataColumnMapping("EDITORIAL COMMENT", "EDITORIAL COMMENT"), New System.Data.Common.DataColumnMapping("NOMENCLATURAL COMMENT", "NOMENCLATURAL COMMENT"), New System.Data.Common.DataColumnMapping("NOTES", "NOTES"), New System.Data.Common.DataColumnMapping("CORRECTION", "CORRECTION"), New System.Data.Common.DataColumnMapping("SANCTIONING AUTHOR", "SANCTIONING AUTHOR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE VOLUME", "SANCTIONING REFERENCE VOLUME"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PART", "SANCTIONING REFERENCE PART"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PAGE", "SANCTIONING REFERENCE PAGE"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE YEAR", "SANCTIONING REFERENCE YEAR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE LITERATURE LINK", "SANCTIONING REFERENCE LITERATURE LINK"), New System.Data.Common.DataColumnMapping("PUBLISHING AUTHORS", "PUBLISHING AUTHORS"), New System.Data.Common.DataColumnMapping("LITERATURE LINK", "LITERATURE LINK"), New System.Data.Common.DataColumnMapping("BSM LINK", "BSM LINK"), New System.Data.Common.DataColumnMapping("EPITHET FLAG", "EPITHET FLAG"), New System.Data.Common.DataColumnMapping("STS FLAG", "STS FLAG"), New System.Data.Common.DataColumnMapping("CMICC FLAG", "CMICC FLAG"), New System.Data.Common.DataColumnMapping("LAST FIVE YEARS FLAG", "LAST FIVE YEARS FLAG"), New System.Data.Common.DataColumnMapping("RECORD NUMBER", "RECORD NUMBER"), New System.Data.Common.DataColumnMapping("BASIONYM RECORD NUMBER", "BASIONYM RECORD NUMBER"), New System.Data.Common.DataColumnMapping("IXF RECORD NUMBER", "IXF RECORD NUMBER"), New System.Data.Common.DataColumnMapping("NAME OF FUNGUS FUNDIC RECORD NUMBER", "NAME OF FUNGUS FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME", "CURRENT NAME"), New System.Data.Common.DataColumnMapping("CURRENT NAME RECORD NUMBER", "CURRENT NAME RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME FUNDIC RECORD NUMBER", "CURRENT NAME FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("GSD FLAG", "GSD FLAG"), New System.Data.Common.DataColumnMapping("TAXONOMIC REFEREE", "TAXONOMIC REFEREE"), New System.Data.Common.DataColumnMapping("INTERNET LINK", "INTERNET LINK"), New System.Data.Common.DataColumnMapping("SQLTimeStamp", "SQLTimeStamp"), New System.Data.Common.DataColumnMapping("UpdatedBy", "UpdatedBy"), New System.Data.Common.DataColumnMapping("AddedBy", "AddedBy"), New System.Data.Common.DataColumnMapping("UpdatedDate", "UpdatedDate"), New System.Data.Common.DataColumnMapping("AddedDate", "AddedDate")})})
        '
        'SqlSelectCommand1
        '
        Me.SqlSelectCommand1.CommandText = "SELECT TOP 10 [NAME OF FUNGUS], AUTHORS, [PUBLISHED LIST REFERENCE], [SPECIFIC EP" & _
        "ITHET], [INFRASPECIFIC RANK], [INFRASPECIFIC EPITHET], [ORTHOGRAPHY COMMENT], [T" & _
        "YPIFICATION DETAILS], [MISAPPLICATION AUTHORS], VOLUME, PART, PAGE, [YEAR OF PUB" & _
        "LICATION], [YEAR ON PUBLICATION], SYNONYMY, HOST, LOCATION, [ANAMORPH TELEOMORPH" & _
        "], [EDITORIAL COMMENT], [NOMENCLATURAL COMMENT], NOTES, CORRECTION, [SANCTIONING" & _
        " AUTHOR], [SANCTIONING REFERENCE VOLUME], [SANCTIONING REFERENCE PART], [SANCTIO" & _
        "NING REFERENCE PAGE], [SANCTIONING REFERENCE YEAR], [SANCTIONING REFERENCE LITER" & _
        "ATURE LINK], [PUBLISHING AUTHORS], [LITERATURE LINK], [BSM LINK], [EPITHET FLAG]" & _
        ", [STS FLAG], [CMICC FLAG], [LAST FIVE YEARS FLAG], [RECORD NUMBER], [BASIONYM R" & _
        "ECORD NUMBER], [IXF RECORD NUMBER], [NAME OF FUNGUS FUNDIC RECORD NUMBER], [CURR" & _
        "ENT NAME], [CURRENT NAME RECORD NUMBER], [CURRENT NAME FUNDIC RECORD NUMBER], [G" & _
        "SD FLAG], [TAXONOMIC REFEREE], [INTERNET LINK], SQLTimeStamp, UpdatedBy, AddedBy" & _
        ", UpdatedDate, AddedDate FROM dbo.IndexFungorum WHERE ([NAME OF FUNGUS] LIKE '' and [last five years flag] <> 'X') ORDE" & _
        "R BY [NAME OF FUNGUS]"
        Me.SqlSelectCommand1.Connection = Me.SqlCon_IndexFungorum
        '
        'SqlCon_IndexFungorum
        '
        Me.SqlCon_IndexFungorum.ConnectionString = "data source=DEVSERVER01;initial catalog=IndexFungorum;password=fred;persist secur" & _
        "ity info=True;user id=dbi_user;workstation id=DEV10;packet size=4096"
        '
        'SqlDa_EpithetSearch
        '
        Me.SqlDa_EpithetSearch.SelectCommand = Me.SqlSelectCommand2
        Me.SqlDa_EpithetSearch.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "IndexFungorum", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("NAME OF FUNGUS", "NAME OF FUNGUS"), New System.Data.Common.DataColumnMapping("AUTHORS", "AUTHORS"), New System.Data.Common.DataColumnMapping("PUBLISHED LIST REFERENCE", "PUBLISHED LIST REFERENCE"), New System.Data.Common.DataColumnMapping("SPECIFIC EPITHET", "SPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC RANK", "INFRASPECIFIC RANK"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC EPITHET", "INFRASPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("ORTHOGRAPHY COMMENT", "ORTHOGRAPHY COMMENT"), New System.Data.Common.DataColumnMapping("TYPIFICATION DETAILS", "TYPIFICATION DETAILS"), New System.Data.Common.DataColumnMapping("MISAPPLICATION AUTHORS", "MISAPPLICATION AUTHORS"), New System.Data.Common.DataColumnMapping("VOLUME", "VOLUME"), New System.Data.Common.DataColumnMapping("PART", "PART"), New System.Data.Common.DataColumnMapping("PAGE", "PAGE"), New System.Data.Common.DataColumnMapping("YEAR OF PUBLICATION", "YEAR OF PUBLICATION"), New System.Data.Common.DataColumnMapping("YEAR ON PUBLICATION", "YEAR ON PUBLICATION"), New System.Data.Common.DataColumnMapping("SYNONYMY", "SYNONYMY"), New System.Data.Common.DataColumnMapping("HOST", "HOST"), New System.Data.Common.DataColumnMapping("LOCATION", "LOCATION"), New System.Data.Common.DataColumnMapping("ANAMORPH TELEOMORPH", "ANAMORPH TELEOMORPH"), New System.Data.Common.DataColumnMapping("EDITORIAL COMMENT", "EDITORIAL COMMENT"), New System.Data.Common.DataColumnMapping("NOMENCLATURAL COMMENT", "NOMENCLATURAL COMMENT"), New System.Data.Common.DataColumnMapping("NOTES", "NOTES"), New System.Data.Common.DataColumnMapping("CORRECTION", "CORRECTION"), New System.Data.Common.DataColumnMapping("SANCTIONING AUTHOR", "SANCTIONING AUTHOR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE VOLUME", "SANCTIONING REFERENCE VOLUME"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PART", "SANCTIONING REFERENCE PART"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PAGE", "SANCTIONING REFERENCE PAGE"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE YEAR", "SANCTIONING REFERENCE YEAR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE LITERATURE LINK", "SANCTIONING REFERENCE LITERATURE LINK"), New System.Data.Common.DataColumnMapping("PUBLISHING AUTHORS", "PUBLISHING AUTHORS"), New System.Data.Common.DataColumnMapping("LITERATURE LINK", "LITERATURE LINK"), New System.Data.Common.DataColumnMapping("BSM LINK", "BSM LINK"), New System.Data.Common.DataColumnMapping("EPITHET FLAG", "EPITHET FLAG"), New System.Data.Common.DataColumnMapping("STS FLAG", "STS FLAG"), New System.Data.Common.DataColumnMapping("CMICC FLAG", "CMICC FLAG"), New System.Data.Common.DataColumnMapping("LAST FIVE YEARS FLAG", "LAST FIVE YEARS FLAG"), New System.Data.Common.DataColumnMapping("RECORD NUMBER", "RECORD NUMBER"), New System.Data.Common.DataColumnMapping("BASIONYM RECORD NUMBER", "BASIONYM RECORD NUMBER"), New System.Data.Common.DataColumnMapping("IXF RECORD NUMBER", "IXF RECORD NUMBER"), New System.Data.Common.DataColumnMapping("NAME OF FUNGUS FUNDIC RECORD NUMBER", "NAME OF FUNGUS FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME", "CURRENT NAME"), New System.Data.Common.DataColumnMapping("CURRENT NAME RECORD NUMBER", "CURRENT NAME RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME FUNDIC RECORD NUMBER", "CURRENT NAME FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("GSD FLAG", "GSD FLAG"), New System.Data.Common.DataColumnMapping("TAXONOMIC REFEREE", "TAXONOMIC REFEREE"), New System.Data.Common.DataColumnMapping("INTERNET LINK", "INTERNET LINK"), New System.Data.Common.DataColumnMapping("SQLTimeStamp", "SQLTimeStamp"), New System.Data.Common.DataColumnMapping("UpdatedBy", "UpdatedBy"), New System.Data.Common.DataColumnMapping("AddedBy", "AddedBy"), New System.Data.Common.DataColumnMapping("UpdatedDate", "UpdatedDate"), New System.Data.Common.DataColumnMapping("AddedDate", "AddedDate")})})
        '
        'SqlSelectCommand2
        '
        Me.SqlSelectCommand2.CommandText = "SELECT TOP 10 [NAME OF FUNGUS], AUTHORS, [PUBLISHED LIST REFERENCE], [SPECIFIC EP" & _
        "ITHET], [INFRASPECIFIC RANK], [INFRASPECIFIC EPITHET], [ORTHOGRAPHY COMMENT], [T" & _
        "YPIFICATION DETAILS], [MISAPPLICATION AUTHORS], VOLUME, PART, PAGE, [YEAR OF PUB" & _
        "LICATION], [YEAR ON PUBLICATION], SYNONYMY, HOST, LOCATION, [ANAMORPH TELEOMORPH" & _
        "], [EDITORIAL COMMENT], [NOMENCLATURAL COMMENT], NOTES, CORRECTION, [SANCTIONING" & _
        " AUTHOR], [SANCTIONING REFERENCE VOLUME], [SANCTIONING REFERENCE PART], [SANCTIO" & _
        "NING REFERENCE PAGE], [SANCTIONING REFERENCE YEAR], [SANCTIONING REFERENCE LITER" & _
        "ATURE LINK], [PUBLISHING AUTHORS], [LITERATURE LINK], [BSM LINK], [EPITHET FLAG]" & _
        ", [STS FLAG], [CMICC FLAG], [LAST FIVE YEARS FLAG], [RECORD NUMBER], [BASIONYM R" & _
        "ECORD NUMBER], [IXF RECORD NUMBER], [NAME OF FUNGUS FUNDIC RECORD NUMBER], [CURR" & _
        "ENT NAME], [CURRENT NAME RECORD NUMBER], [CURRENT NAME FUNDIC RECORD NUMBER], [G" & _
        "SD FLAG], [TAXONOMIC REFEREE], [INTERNET LINK], SQLTimeStamp, UpdatedBy, AddedBy" & _
        ", UpdatedDate, AddedDate FROM dbo.IndexFungorum WHERE ([INFRASPECIFIC EPITHET] LIKE '" & _
        "' and [last five years flag] <> 'X') ORDER BY [NAME OF FUNGUS]"
        Me.SqlSelectCommand2.Connection = Me.SqlCon_IndexFungorum
        '
        'SqlDa_Name
        '
        Me.SqlDa_Name.SelectCommand = Me.SqlSelectCommand3
        Me.SqlDa_Name.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "IndexFungorum", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("NAME OF FUNGUS", "NAME OF FUNGUS"), New System.Data.Common.DataColumnMapping("AUTHORS", "AUTHORS"), New System.Data.Common.DataColumnMapping("PUBLISHED LIST REFERENCE", "PUBLISHED LIST REFERENCE"), New System.Data.Common.DataColumnMapping("SPECIFIC EPITHET", "SPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC RANK", "INFRASPECIFIC RANK"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC EPITHET", "INFRASPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("ORTHOGRAPHY COMMENT", "ORTHOGRAPHY COMMENT"), New System.Data.Common.DataColumnMapping("TYPIFICATION DETAILS", "TYPIFICATION DETAILS"), New System.Data.Common.DataColumnMapping("MISAPPLICATION AUTHORS", "MISAPPLICATION AUTHORS"), New System.Data.Common.DataColumnMapping("VOLUME", "VOLUME"), New System.Data.Common.DataColumnMapping("PART", "PART"), New System.Data.Common.DataColumnMapping("PAGE", "PAGE"), New System.Data.Common.DataColumnMapping("YEAR OF PUBLICATION", "YEAR OF PUBLICATION"), New System.Data.Common.DataColumnMapping("YEAR ON PUBLICATION", "YEAR ON PUBLICATION"), New System.Data.Common.DataColumnMapping("SYNONYMY", "SYNONYMY"), New System.Data.Common.DataColumnMapping("HOST", "HOST"), New System.Data.Common.DataColumnMapping("LOCATION", "LOCATION"), New System.Data.Common.DataColumnMapping("ANAMORPH TELEOMORPH", "ANAMORPH TELEOMORPH"), New System.Data.Common.DataColumnMapping("EDITORIAL COMMENT", "EDITORIAL COMMENT"), New System.Data.Common.DataColumnMapping("NOMENCLATURAL COMMENT", "NOMENCLATURAL COMMENT"), New System.Data.Common.DataColumnMapping("NOTES", "NOTES"), New System.Data.Common.DataColumnMapping("CORRECTION", "CORRECTION"), New System.Data.Common.DataColumnMapping("SANCTIONING AUTHOR", "SANCTIONING AUTHOR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE VOLUME", "SANCTIONING REFERENCE VOLUME"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PART", "SANCTIONING REFERENCE PART"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PAGE", "SANCTIONING REFERENCE PAGE"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE YEAR", "SANCTIONING REFERENCE YEAR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE LITERATURE LINK", "SANCTIONING REFERENCE LITERATURE LINK"), New System.Data.Common.DataColumnMapping("PUBLISHING AUTHORS", "PUBLISHING AUTHORS"), New System.Data.Common.DataColumnMapping("LITERATURE LINK", "LITERATURE LINK"), New System.Data.Common.DataColumnMapping("BSM LINK", "BSM LINK"), New System.Data.Common.DataColumnMapping("EPITHET FLAG", "EPITHET FLAG"), New System.Data.Common.DataColumnMapping("STS FLAG", "STS FLAG"), New System.Data.Common.DataColumnMapping("CMICC FLAG", "CMICC FLAG"), New System.Data.Common.DataColumnMapping("LAST FIVE YEARS FLAG", "LAST FIVE YEARS FLAG"), New System.Data.Common.DataColumnMapping("RECORD NUMBER", "RECORD NUMBER"), New System.Data.Common.DataColumnMapping("BASIONYM RECORD NUMBER", "BASIONYM RECORD NUMBER"), New System.Data.Common.DataColumnMapping("IXF RECORD NUMBER", "IXF RECORD NUMBER"), New System.Data.Common.DataColumnMapping("NAME OF FUNGUS FUNDIC RECORD NUMBER", "NAME OF FUNGUS FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME", "CURRENT NAME"), New System.Data.Common.DataColumnMapping("CURRENT NAME RECORD NUMBER", "CURRENT NAME RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME FUNDIC RECORD NUMBER", "CURRENT NAME FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("GSD FLAG", "GSD FLAG"), New System.Data.Common.DataColumnMapping("TAXONOMIC REFEREE", "TAXONOMIC REFEREE"), New System.Data.Common.DataColumnMapping("INTERNET LINK", "INTERNET LINK"), New System.Data.Common.DataColumnMapping("SQLTimeStamp", "SQLTimeStamp"), New System.Data.Common.DataColumnMapping("UpdatedBy", "UpdatedBy"), New System.Data.Common.DataColumnMapping("AddedBy", "AddedBy"), New System.Data.Common.DataColumnMapping("UpdatedDate", "UpdatedDate"), New System.Data.Common.DataColumnMapping("AddedDate", "AddedDate")})})
        '
        'SqlSelectCommand3
        '
        Me.SqlSelectCommand3.CommandText = "SELECT TOP 10 [NAME OF FUNGUS], AUTHORS, [PUBLISHED LIST REFERENCE], [SPECIFIC EP" & _
        "ITHET], [INFRASPECIFIC RANK], [INFRASPECIFIC EPITHET], [ORTHOGRAPHY COMMENT], [T" & _
        "YPIFICATION DETAILS], [MISAPPLICATION AUTHORS], VOLUME, PART, PAGE, [YEAR OF PUB" & _
        "LICATION], [YEAR ON PUBLICATION], SYNONYMY, HOST, LOCATION, [ANAMORPH TELEOMORPH" & _
        "], [EDITORIAL COMMENT], [NOMENCLATURAL COMMENT], NOTES, CORRECTION, [SANCTIONING" & _
        " AUTHOR], [SANCTIONING REFERENCE VOLUME], [SANCTIONING REFERENCE PART], [SANCTIO" & _
        "NING REFERENCE PAGE], [SANCTIONING REFERENCE YEAR], [SANCTIONING REFERENCE LITER" & _
        "ATURE LINK], [PUBLISHING AUTHORS], [LITERATURE LINK], [BSM LINK], [EPITHET FLAG]" & _
        ", [STS FLAG], [CMICC FLAG], [LAST FIVE YEARS FLAG], [RECORD NUMBER], [BASIONYM R" & _
        "ECORD NUMBER], [IXF RECORD NUMBER], [NAME OF FUNGUS FUNDIC RECORD NUMBER], [CURR" & _
        "ENT NAME], [CURRENT NAME RECORD NUMBER], [CURRENT NAME FUNDIC RECORD NUMBER], [G" & _
        "SD FLAG], [TAXONOMIC REFEREE], [INTERNET LINK], SQLTimeStamp, UpdatedBy, AddedBy" & _
        ", UpdatedDate, AddedDate FROM dbo.IndexFungorum WHERE ([RECORD NUMBER] = 1 and [last five years flag] <> 'X') ORDER BY " & _
        "[NAME OF FUNGUS]"
        Me.SqlSelectCommand3.Connection = Me.SqlCon_IndexFungorum

    End Sub

    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        'CODEGEN: This procedure is required by the Web Services Designer
        'Do not modify it using the code editor.
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

#End Region

    Private Function GetNameLSID(ByVal recordNumber As String)
        Return "urn:lsid:indexfungorum.org:names:" + recordNumber
    End Function

    Private Sub ProtectFromSQLInjection(ByVal input As String)
        input = input.Replace("'", "''")
        If input.IndexOf(";") <> -1 Then input = input.Substring(input.IndexOf(";"))
    End Sub

    Private Property ConnectionString() As String
        Get
            Return SqlCon_IndexFungorum.ConnectionString
        End Get
        Set(ByVal Value As String)
            SqlCon_IndexFungorum.ConnectionString = Value
        End Set
    End Property


    'test to see if there is a connection
    <WebMethod()> Public Function IsAlive() As Boolean
        Return True
    End Function

    'search for a name
    <WebMethod()> Public Function NameSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As XmlDocument
        'stop sql injection
        ProtectFromSQLInjection(SearchText)

        Dim doc As New XmlDocument
        Dim ds As DataSet = NameSearchDs(SearchText, AnywhereInText, MaxNumber)
        If ds Is Nothing Then
            doc.LoadXml("<Error>Null response</Error>")
            Return doc
        Else
            doc.LoadXml(ds.GetXml)
            Return doc
        End If
    End Function

    <WebMethod()> Public Function NameSearchDs(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As DataSet
        'stop sql injection
        ProtectFromSQLInjection(SearchText)

        Dim doc As New XmlDocument
        Dim strAnyWhere As String
        If AnywhereInText = True Then
            strAnyWhere = "%"
        Else
            strAnyWhere = ""
        End If

        Dim QueryString As String
        QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM IndexFungorum WHERE [NAME OF FUNGUS] LIKE '" & strAnyWhere & SearchText & "%' " & _
            " and ([last five years flag] is null or [last five years flag] <> 'X') ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet
        SqlDa_NameSearch.SelectCommand.CommandText = QueryString
        SqlDa_NameSearch.Fill(ds)

        Return ds
    End Function


    'search for an epithet
    <WebMethod()> Public Function EpithetSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As XmlDocument
        'stop sql injection
        ProtectFromSQLInjection(SearchText)

        Dim doc As New XmlDocument
        Dim ds As DataSet = EpithetSearchDs(SearchText, AnywhereInText, MaxNumber)
        If ds Is Nothing Then
            doc.LoadXml("<Error>Null response</Error>")
            Return doc
        Else
            doc.LoadXml(ds.GetXml)
            Return doc
        End If
    End Function

    <WebMethod()> Public Function EpithetSearchDs(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As DataSet
        'stop sql injection
        ProtectFromSQLInjection(SearchText)

        Dim strAnyWhere As String
        If AnywhereInText = True Then
            strAnyWhere = "%"
        Else
            strAnyWhere = ""
        End If

        Dim QueryString As String
        QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM IndexFungorum WHERE [SPECIFIC EPITHET] LIKE '" & strAnyWhere & SearchText & "%' " & _
            " and ([last five years flag] is null or [last five years flag] <> 'X') ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet
        SqlDa_EpithetSearch.SelectCommand.CommandText = QueryString
        SqlDa_EpithetSearch.Fill(ds)

        Return ds
    End Function


    'name by key
    <WebMethod()> Public Function NameByKey(ByVal NameKey As Long) As XmlDocument
        Dim doc As New XmlDocument
        Dim ds As DataSet = NameByKeyDs(Long.Parse(NameKey))
        If ds Is Nothing Then
            doc.LoadXml("<Error>Null response</Error>")
            Return doc
        Else
            doc.LoadXml(ds.GetXml)
            Return doc
        End If
    End Function

    <WebMethod()> Public Function NameByKeyDs(ByVal NameKey As Long) As DataSet

        'if last five years then return restricted data
        Dim lfyf As Boolean = LastFiveYearsFlagByKey(NameKey)

        Dim QueryString As String

        If lfyf Then
            Dim msg As String = System.Configuration.ConfigurationSettings.AppSettings.Get("UnauthenticatedMessage")

            QueryString = "SELECT [RECORD NUMBER], " _
                & "[NAME OF FUNGUS], " _
                & "[AUTHORS], " _
                & "[YEAR OF PUBLICATION], " _
                & "'" + msg + "' AS AccessRights " _
                & "FROM IndexFungorum " _
                & "WHERE [RECORD NUMBER]=" & CStr(NameKey)
        Else
            QueryString = "SELECT IndexFungorum.*, Publications.*,FundicClassification.* " _
                & "FROM (IndexFungorum LEFT JOIN FundicClassification " _
                & "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] " _
                & "= FundicClassification.[Fundic Record Number])" _
                & "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
                & "WHERE IndexFungorum.[RECORD NUMBER]=" & CStr(NameKey)

        End If

        Dim ds As New DataSet
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Return ds
    End Function

    <WebMethod()> Public Function NameFullByKey(ByVal NameLsid As String) As String
        'stop sql injection
        ProtectFromSQLInjection(NameLsid)

        Dim ds As New DataSet

        Try
            Dim pos = NameLsid.LastIndexOf(":")
            Dim id As String = NameLsid.Substring(pos + 1)
            ds = NameByKeyDs(Long.Parse(id))
        Catch ex As Exception
            Throw New Exception("Unknown LSID")
        End Try

        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)

            Dim fName As String = row("NAME OF FUNGUS").ToString() + " " + row("AUTHORS").ToString()
            If row("YEAR OF PUBLICATION").ToString().Length > 0 Then
                fName += row("YEAR OF PUBLICATION").ToString()
            End If

            Return fName
        Else
            Throw New Exception("Unknown LSID")
        End If
        Return ""
    End Function

    <WebMethod()> Public Function NameByKeyRDF(ByVal NameLsid As String) As XmlDocument
        Dim rdf As String = ""

        Dim pos = NameLsid.LastIndexOf(":")
        Dim id As String = NameLsid.Substring(pos + 1)
        Dim ds As DataSet = NameByKeyDs(Long.Parse(id))

        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then

            Dim da As New IFDataAccess.IFDataAccess
            rdf = da.NameByKeyRDF(NameLsid)

            Dim doc As New XmlDocument
            doc.LoadXml(rdf)
            Return doc
        Else
            Throw New Exception("Unknown LSID")
        End If
        Return Nothing
    End Function

    'search for a author
    <WebMethod()> Public Function AuthorSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As XmlDocument
        'stop sql injection
        ProtectFromSQLInjection(SearchText)

        Dim doc As New XmlDocument
        Dim ds As DataSet = AuthorSearchDs(SearchText, AnywhereInText, MaxNumber)
        If ds Is Nothing Then
            doc.LoadXml("<Error>Null response</Error>")
            Return doc
        Else
            doc.LoadXml(ds.GetXml)
            Return doc
        End If
    End Function

    <WebMethod()> Public Function AuthorSearchDs(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As DataSet
        'stop sql injection
        ProtectFromSQLInjection(SearchText)

        Dim strAnyWhere As String
        If AnywhereInText = True Then
            strAnyWhere = "%"
        Else
            strAnyWhere = ""
        End If

        Dim QueryString As String
        QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM IndexFungorum WHERE AUTHORS LIKE '" & strAnyWhere & SearchText & "%' " & _
            " and ([last five years flag] is null or [last five years flag] <> 'X') ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet
        SqlDa_NameSearch.SelectCommand.CommandText = QueryString
        SqlDa_NameSearch.Fill(ds)

        Return ds
    End Function

    <WebMethod()> Public Function NamesByCurrentKey(ByVal CurrentKey As Long) As XmlDocument
        Dim doc As New XmlDocument
        Dim ds As DataSet = NamesByCurrentKeyDs(CurrentKey)
        If ds Is Nothing Then
            doc.LoadXml("<Error>Null response</Error>")
            Return doc
        Else
            doc.LoadXml(ds.GetXml)
            Return doc
        End If
    End Function

    <WebMethod()> Public Function NamesByCurrentKeyDs(ByVal CurrentKey As Long) As DataSet
        Dim QueryString As String
        QueryString = "SELECT * FROM IndexFungorum WHERE [CURRENT NAME RECORD NUMBER] = " & CStr(CurrentKey) & _
            " and ([last five years flag] is null or [last five years flag] <> 'X') ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Return ds
    End Function

    Public Function LastFiveYearsFlagByKey(ByVal NameKey As Long) As Boolean

        Dim QueryString As String
        QueryString = "SELECT [last five years flag] " _
            & "FROM IndexFungorum " _
            & "WHERE IndexFungorum.[RECORD NUMBER]=" & CStr(NameKey) & " " _
            & " and ([MISAPPLICATION AUTHORS] is null or len([MISAPPLICATION AUTHORS]) = 0);"

        Dim ds As New DataSet
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Dim lfyf As String = ""

        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            lfyf = ds.Tables(0).Rows(0)("last five years flag").ToString()
        End If

        Return (Not lfyf Is Nothing AndAlso lfyf.Length > 0 AndAlso lfyf.ToLower = "x")
    End Function


    '-------------------------------------------------
    ' Data update functions
    '
    ' Returns only LSIDs for updated names 
    ' Dates in format YYYYMMDD
    '

    'GetAllUpdatedNames(string startDate) - all names of all ranks updated/created after a specified date
    <WebMethod()> Public Function AllUpdatedNames(ByVal startDate As String) As XmlDocument
        'stop sql injection
        ProtectFromSQLInjection(startDate)

        Dim xml As String = ""

        Try
            Dim dtStr As String = startDate.Substring(4, 2) + "/" + startDate.Substring(6, 2) + "/" + startDate.Substring(0, 4)

            Dim QueryString As String 'TODO implement for all ranks
            QueryString = "SELECT CAST([RECORD NUMBER] AS VARCHAR(100)) as FungusNameLSID FROM IndexFungorum " _
                & "WHERE (UpdatedDate >= '" + dtStr + "' or AddedDate >= '" + dtStr + "') " _
                & "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

            Dim ds As New DataSet
            SqlDa_Name.SelectCommand.CommandText = QueryString
            SqlDa_Name.Fill(ds)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    r(0) = GetNameLSID(r(0).ToString)
                Next
            End If

            xml = ds.GetXml()
        Catch aex As ArgumentOutOfRangeException
            xml = "<Error>Invalid date.  Dates should be in the format YYYYMMDD.</Error>"
        Catch ex As Exception
            xml = "<Error>" + ex.Message + "</Error>"
        End Try

        Dim doc As New XmlDocument
        doc.LoadXml(xml)
        Return doc
    End Function

    'GetUpdatedNames(string rank, string startDate, string endDate) - return names of the specified 
    'rank that have been created/modified after the specified start date and before the specified end date
    <WebMethod()> Public Function UpdatedNamesInRange(ByVal rank As String, ByVal startDate As String, ByVal endDate As String) As XmlDocument

        'stop sql injection
        ProtectFromSQLInjection(rank)
        ProtectFromSQLInjection(startDate)
        ProtectFromSQLInjection(endDate)

        Dim xml As String = ""
        Try
            Dim fromDt As String = startDate.Substring(4, 2) + "/" + startDate.Substring(6, 2) + "/" + startDate.Substring(0, 4)
            Dim toDt As String = endDate.Substring(4, 2) + "/" + endDate.Substring(6, 2) + "/" + endDate.Substring(0, 4)

            Dim QueryString As String
            QueryString = "SELECT CAST([RECORD NUMBER] AS VARCHAR(100)) as FungusNameLSID FROM IndexFungorum " _
                & "WHERE ((UpdatedDate >= '" + fromDt + "' and UpdatedDate <= '" + toDt + "') or " _
                & " (AddedDate >= '" + fromDt + "' and AddedDate <= '" + toDt + "')) "
            If Not rank Is Nothing AndAlso rank.Length > 0 Then
                QueryString &= "and isnull([INFRASPECIFIC RANK], 'species') = '" + rank + "' "
            End If
            QueryString &= "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

            Dim ds As New DataSet
            SqlDa_Name.SelectCommand.CommandText = QueryString
            SqlDa_Name.Fill(ds)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    r(0) = GetNameLSID(r(0).ToString)
                Next
            End If

            xml = ds.GetXml()
        Catch aex As ArgumentOutOfRangeException
            xml = "<Error>Invalid date.  Dates should be in the format YYYYMMDD.</Error>"
        Catch ex As Exception
            xml = "<Error>" + ex.Message + "</Error>"
        End Try

        Dim doc As New XmlDocument
        doc.LoadXml(xml)
        Return doc
    End Function

    'GetUpdatedNames(string rank, string startDate) - no end date
    <WebMethod()> Public Function UpdatedNames(ByVal rank As String, ByVal startDate As String) As XmlDocument

        'stop sql injection
        ProtectFromSQLInjection(rank)
        ProtectFromSQLInjection(startDate)

        Dim xml As String = ""
        Try
            Dim fromDt As String = startDate.Substring(4, 2) + "/" + startDate.Substring(6, 2) + "/" + startDate.Substring(0, 4)

            Dim QueryString As String
            QueryString = "SELECT CAST([RECORD NUMBER] AS VARCHAR(100)) as FungusNameLSID FROM IndexFungorum " _
                & "WHERE (UpdatedDate >= '" + fromDt + "' or AddedDate >= '" + fromDt + "') "
            If Not rank Is Nothing AndAlso rank.Length > 0 Then
                QueryString &= "and [INFRASPECIFIC RANK] = '" + rank + "' "
            End If
            QueryString &= "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

            Dim ds As New DataSet
            SqlDa_Name.SelectCommand.CommandText = QueryString
            SqlDa_Name.Fill(ds)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    r(0) = GetNameLSID(r(0).ToString)
                Next
            End If

            xml = ds.GetXml()
        Catch aex As ArgumentOutOfRangeException
            xml = "<Error>Invalid date.  Dates should be in the format YYYYMMDD.</Error>"
        Catch ex As Exception
            xml = "<Error>" + ex.Message + "</Error>"
        End Try

        Dim doc As New XmlDocument
        doc.LoadXml(xml)
        Return doc
    End Function

    'GetNewNames(string rank, string startDate, string endDate) - only return new records in range
    <WebMethod()> Public Function NewNamesInRange(ByVal rank As String, ByVal startDate As String, ByVal endDate As String) As XmlDocument

        'stop sql injection
        ProtectFromSQLInjection(rank)
        ProtectFromSQLInjection(startDate)
        ProtectFromSQLInjection(endDate)

        Dim xml As String = ""
        Try
            Dim fromDt As String = startDate.Substring(4, 2) + "/" + startDate.Substring(6, 2) + "/" + startDate.Substring(0, 4)
            Dim toDt As String = endDate.Substring(4, 2) + "/" + endDate.Substring(6, 2) + "/" + endDate.Substring(0, 4)

            Dim QueryString As String
            QueryString = "SELECT CAST([RECORD NUMBER] AS VARCHAR(100)) as FungusNameLSID FROM IndexFungorum " _
                & "WHERE (AddedDate >= '" + fromDt + "' and AddedDate <= '" + toDt + "') "
            If Not rank Is Nothing AndAlso rank.Length > 0 Then
                QueryString &= "and [INFRASPECIFIC RANK] = '" + rank + "' "
            End If
            QueryString &= "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

            Dim ds As New DataSet
            SqlDa_Name.SelectCommand.CommandText = QueryString
            SqlDa_Name.Fill(ds)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    r(0) = GetNameLSID(r(0).ToString)
                Next
            End If

            xml = ds.GetXml()
        Catch aex As ArgumentOutOfRangeException
            xml = "<Error>Invalid date.  Dates should be in the format YYYYMMDD.</Error>"
        Catch ex As Exception
            xml = "<Error>" + ex.Message + "</Error>"
        End Try

        Dim doc As New XmlDocument
        doc.LoadXml(xml)
        Return doc
    End Function

    'GetNewNames(string rank, string startDate) - no end date
    <WebMethod()> Public Function NewNames(ByVal rank As String, ByVal startDate As String) As XmlDocument

        'stop sql injection
        ProtectFromSQLInjection(rank)
        ProtectFromSQLInjection(startDate)

        Dim xml As String = ""

        Try
            Dim fromDt As String = startDate.Substring(4, 2) + "/" + startDate.Substring(6, 2) + "/" + startDate.Substring(0, 4)

            Dim QueryString As String
            QueryString = "SELECT CAST([RECORD NUMBER] AS VARCHAR(100)) as FungusNameLSID FROM IndexFungorum " _
                & "WHERE AddedDate >= '" + fromDt + "' "
            If Not rank Is Nothing AndAlso rank.Length > 0 Then
                QueryString &= "and [INFRASPECIFIC RANK] = '" + rank + "' "
            End If
            QueryString &= "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

            Dim ds As New DataSet
            SqlDa_Name.SelectCommand.CommandText = QueryString
            SqlDa_Name.Fill(ds)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    r(0) = GetNameLSID(r(0).ToString)
                Next
            End If

            xml = ds.GetXml()
        Catch aex As ArgumentOutOfRangeException
            xml = "<Error>Invalid date.  Dates should be in the format YYYYMMDD.</Error>"
        Catch ex As Exception
            xml = "<Error>" + ex.Message + "</Error>"
        End Try

        Dim doc As New XmlDocument
        doc.LoadXml(xml)
        Return doc
    End Function

    'GetDeprecatedRecords(string startDate) - return name ids and new ids for all names of all 
    'ranks deprecated after a certain date
    <WebMethod()> Public Function DeprecatedNames(ByVal startDate As String) As XmlDocument
        'stop sql injection
        ProtectFromSQLInjection(startDate)

        Dim xml As String = ""

        Try
            Dim fromDt As String = startDate.Substring(4, 2) + "/" + startDate.Substring(6, 2) + "/" + startDate.Substring(0, 4)

            Dim QueryString As String 'TODO implement for all ranks
            QueryString = "SELECT CAST([RECORD NUMBER] AS VARCHAR(100)) as FungusNameOldLSID, " _
                & "CAST([CURRENT NAME RECORD NUMBER] as VARCHAR(100)) as FungusNameNewLSID FROM IndexFungorum " _
                & "WHERE [STS FLAG] = 'd' AND UpdatedDate >= '" + fromDt + "' " _
                & "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

            Dim ds As New DataSet
            SqlDa_Name.SelectCommand.CommandText = QueryString
            SqlDa_Name.Fill(ds)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    r(0) = GetNameLSID(r(0).ToString)
                    r(1) = GetNameLSID(r(1).ToString)
                Next
            End If

            xml = ds.GetXml()
        Catch aex As ArgumentOutOfRangeException
            xml = "<Error>Invalid date.  Dates should be in the format YYYYMMDD.</Error>"
        Catch ex As Exception
            xml = "<Error>" + ex.Message + "</Error>"
        End Try

        Dim doc As New XmlDocument
        doc.LoadXml(xml)
        Return doc
    End Function

    'GetDeprecatedRecords(string rank, string startDate) - ids of names of specified rank 
    'deprecated after a certain date
    <WebMethod()> Public Function DeprecatedNamesByRank(ByVal rank As String, ByVal startDate As String) As XmlDocument

        'stop sql injection
        ProtectFromSQLInjection(rank)
        ProtectFromSQLInjection(startDate)

        Dim xml As String = ""

        Try
            Dim fromDt As String = startDate.Substring(4, 2) + "/" + startDate.Substring(6, 2) + "/" + startDate.Substring(0, 4)

            Dim QueryString As String
            QueryString = "SELECT CAST([RECORD NUMBER] AS VARCHAR(100)) as FungusNameOldLSID, " _
                & "CAST([CURRENT NAME RECORD NUMBER] as VARCHAR(100)) as FungusNameNewLSID FROM IndexFungorum " _
                & "WHERE [STS FLAG] = 'd' AND UpdatedDate >= '" + fromDt + "' "
            If Not rank Is Nothing AndAlso rank.Length > 0 Then
                QueryString &= "and [INFRASPECIFIC RANK] = '" + rank + "' "
            End If
            QueryString &= "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

            Dim ds As New DataSet
            SqlDa_Name.SelectCommand.CommandText = QueryString
            SqlDa_Name.Fill(ds)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each r As DataRow In ds.Tables(0).Rows
                    r(0) = GetNameLSID(r(0).ToString)
                    r(1) = GetNameLSID(r(1).ToString)
                Next
            End If

            xml = ds.GetXml()
        Catch aex As ArgumentOutOfRangeException
            xml = "<Error>Invalid date.  Dates should be in the format YYYYMMDD.</Error>"
        Catch ex As Exception
            xml = "<Error>" + ex.Message + "</Error>"
        End Try

        Dim doc As New XmlDocument
        doc.LoadXml(xml)
        Return doc
    End Function

End Class
