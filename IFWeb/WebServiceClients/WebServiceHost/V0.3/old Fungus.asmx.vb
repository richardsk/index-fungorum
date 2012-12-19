Imports System.Web.Services

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
    <WebMethod()> Public Function NameSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As String
        Dim ds As DataSet = NameSearchDs(SearchText, AnywhereInText, MaxNumber)
        If ds Is Nothing Then
            Return ""
        Else
            Return ds.GetXml
        End If
    End Function

    <WebMethod()> Public Function NameSearchDs(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As DataSet

        Dim strAnyWhere As String
        If AnywhereInText = True Then
            strAnyWhere = "%"
        Else
            strAnyWhere = ""
        End If

        Dim QueryString As String
        QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM IndexFungorum WHERE [NAME OF FUNGUS] LIKE '" & strAnyWhere & SearchText & "%' and [last five years flag] <> 'X' ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet()
        SqlDa_NameSearch.SelectCommand.CommandText = QueryString
        SqlDa_NameSearch.Fill(ds)

        Return ds
    End Function


    'search for an epithet
    <WebMethod()> Public Function EpithetSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As String
        Dim ds As DataSet = EpithetSearchDs(SearchText, AnywhereInText, MaxNumber)
        If ds Is Nothing Then
            Return ""
        Else
            Return ds.GetXml
        End If
    End Function

    <WebMethod()> Public Function EpithetSearchDs(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As DataSet

        Dim strAnyWhere As String
        If AnywhereInText = True Then
            strAnyWhere = "%"
        Else
            strAnyWhere = ""
        End If

        Dim QueryString As String
        QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM IndexFungorum WHERE [SPECIFIC EPITHET] LIKE '" & strAnyWhere & SearchText & "%' and [last five years flag] <> 'X' ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet()
        SqlDa_EpithetSearch.SelectCommand.CommandText = QueryString
        SqlDa_EpithetSearch.Fill(ds)

        Return ds
    End Function



    'name by key
    <WebMethod()> Public Function NameByKey(ByVal NameKey As Long) As String
        Dim ds As DataSet = NameByKeyDs(NameKey)
        If ds Is Nothing Then
            Return ""
        Else
            Return ds.GetXml
        End If
    End Function

    <WebMethod()> Public Function NameByKeyDs(ByVal NameKey As Long) As DataSet

        Dim QueryString As String
        'QueryString = "SELECT  * FROM IndexFungorum WHERE [RECORD NUMBER] = " & CStr(NameKey) & "  ORDER BY [NAME OF FUNGUS] "
        QueryString = "SELECT IndexFungorum.*, Publications.*,FundicClassification.* " _
            & "FROM (IndexFungorum LEFT JOIN FundicClassification " _
            & "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] " _
            & "= FundicClassification.[Fundic Record Number])" _
            & "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
            & "WHERE (((IndexFungorum.[RECORD NUMBER])=" & CStr(NameKey) & ") and [last five years flag] <> 'X') " _
            & "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
        Dim ds As New DataSet()
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Return ds
    End Function


    'search for a author
    <WebMethod()> Public Function AuthorSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As String
        Dim ds As DataSet = AuthorSearchDs(SearchText, AnywhereInText, MaxNumber)
        If ds Is Nothing Then
            Return ""
        Else
            Return ds.GetXml
        End If
    End Function

    <WebMethod()> Public Function AuthorSearchDs(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As DataSet

        Dim strAnyWhere As String
        If AnywhereInText = True Then
            strAnyWhere = "%"
        Else
            strAnyWhere = ""
        End If

        Dim QueryString As String
        QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM IndexFungorum WHERE AUTHORS LIKE '" & strAnyWhere & SearchText & "%' and [last five years flag] <> 'X' ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet()
        SqlDa_NameSearch.SelectCommand.CommandText = QueryString
        SqlDa_NameSearch.Fill(ds)

        Return ds
    End Function

    <WebMethod()> Public Function NamesByCurrentKey(ByVal CurrentKey As Long) As String
        Dim ds As DataSet = NamesByCurrentKeyDs(CurrentKey)
        If ds Is Nothing Then
            Return ""
        Else
            Return ds.GetXml
        End If
    End Function

    <WebMethod()> Public Function NamesByCurrentKeyDs(ByVal CurrentKey As Long) As DataSet
        Dim QueryString As String
        QueryString = "SELECT * FROM IndexFungorum WHERE [CURRENT NAME RECORD NUMBER] = " & CStr(CurrentKey) & " and [last five years flag] <> 'X' ORDER BY [NAME OF FUNGUS] "

        Dim ds As New DataSet()
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Return ds
    End Function


    Private Sub SqlDa_Name_RowUpdated(ByVal sender As System.Object, ByVal e As System.Data.SqlClient.SqlRowUpdatedEventArgs) Handles SqlDa_Name.RowUpdated

    End Sub
End Class
