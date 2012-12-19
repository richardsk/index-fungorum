Imports SemWeb

Public Class IFDataAccess
    Friend WithEvents SqlDa_Name As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents SqlSelectCommand3 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlCon_IndexFungorum As System.Data.SqlClient.SqlConnection

    Public Sub New()
        SqlCon_IndexFungorum = New System.Data.SqlClient.SqlConnection

        SqlCon_IndexFungorum.ConnectionString = System.Configuration.ConfigurationSettings.AppSettings("IFConnectionString")

        Me.SqlSelectCommand3 = New System.Data.SqlClient.SqlCommand

        Me.SqlDa_Name = New System.Data.SqlClient.SqlDataAdapter
        Me.SqlDa_Name.SelectCommand = Me.SqlSelectCommand3
        Me.SqlDa_Name.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "IndexFungorum", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("NAME OF FUNGUS", "NAME OF FUNGUS"), New System.Data.Common.DataColumnMapping("AUTHORS", "AUTHORS"), New System.Data.Common.DataColumnMapping("PUBLISHED LIST REFERENCE", "PUBLISHED LIST REFERENCE"), New System.Data.Common.DataColumnMapping("SPECIFIC EPITHET", "SPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC RANK", "INFRASPECIFIC RANK"), New System.Data.Common.DataColumnMapping("INFRASPECIFIC EPITHET", "INFRASPECIFIC EPITHET"), New System.Data.Common.DataColumnMapping("ORTHOGRAPHY COMMENT", "ORTHOGRAPHY COMMENT"), New System.Data.Common.DataColumnMapping("TYPIFICATION DETAILS", "TYPIFICATION DETAILS"), New System.Data.Common.DataColumnMapping("MISAPPLICATION AUTHORS", "MISAPPLICATION AUTHORS"), New System.Data.Common.DataColumnMapping("VOLUME", "VOLUME"), New System.Data.Common.DataColumnMapping("PART", "PART"), New System.Data.Common.DataColumnMapping("PAGE", "PAGE"), New System.Data.Common.DataColumnMapping("YEAR OF PUBLICATION", "YEAR OF PUBLICATION"), New System.Data.Common.DataColumnMapping("YEAR ON PUBLICATION", "YEAR ON PUBLICATION"), New System.Data.Common.DataColumnMapping("SYNONYMY", "SYNONYMY"), New System.Data.Common.DataColumnMapping("HOST", "HOST"), New System.Data.Common.DataColumnMapping("LOCATION", "LOCATION"), New System.Data.Common.DataColumnMapping("ANAMORPH TELEOMORPH", "ANAMORPH TELEOMORPH"), New System.Data.Common.DataColumnMapping("EDITORIAL COMMENT", "EDITORIAL COMMENT"), New System.Data.Common.DataColumnMapping("NOMENCLATURAL COMMENT", "NOMENCLATURAL COMMENT"), New System.Data.Common.DataColumnMapping("NOTES", "NOTES"), New System.Data.Common.DataColumnMapping("CORRECTION", "CORRECTION"), New System.Data.Common.DataColumnMapping("SANCTIONING AUTHOR", "SANCTIONING AUTHOR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE VOLUME", "SANCTIONING REFERENCE VOLUME"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PART", "SANCTIONING REFERENCE PART"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE PAGE", "SANCTIONING REFERENCE PAGE"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE YEAR", "SANCTIONING REFERENCE YEAR"), New System.Data.Common.DataColumnMapping("SANCTIONING REFERENCE LITERATURE LINK", "SANCTIONING REFERENCE LITERATURE LINK"), New System.Data.Common.DataColumnMapping("PUBLISHING AUTHORS", "PUBLISHING AUTHORS"), New System.Data.Common.DataColumnMapping("LITERATURE LINK", "LITERATURE LINK"), New System.Data.Common.DataColumnMapping("BSM LINK", "BSM LINK"), New System.Data.Common.DataColumnMapping("EPITHET FLAG", "EPITHET FLAG"), New System.Data.Common.DataColumnMapping("STS FLAG", "STS FLAG"), New System.Data.Common.DataColumnMapping("CMICC FLAG", "CMICC FLAG"), New System.Data.Common.DataColumnMapping("LAST FIVE YEARS FLAG", "LAST FIVE YEARS FLAG"), New System.Data.Common.DataColumnMapping("RECORD NUMBER", "RECORD NUMBER"), New System.Data.Common.DataColumnMapping("BASIONYM RECORD NUMBER", "BASIONYM RECORD NUMBER"), New System.Data.Common.DataColumnMapping("IXF RECORD NUMBER", "IXF RECORD NUMBER"), New System.Data.Common.DataColumnMapping("NAME OF FUNGUS FUNDIC RECORD NUMBER", "NAME OF FUNGUS FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME", "CURRENT NAME"), New System.Data.Common.DataColumnMapping("CURRENT NAME RECORD NUMBER", "CURRENT NAME RECORD NUMBER"), New System.Data.Common.DataColumnMapping("CURRENT NAME FUNDIC RECORD NUMBER", "CURRENT NAME FUNDIC RECORD NUMBER"), New System.Data.Common.DataColumnMapping("GSD FLAG", "GSD FLAG"), New System.Data.Common.DataColumnMapping("TAXONOMIC REFEREE", "TAXONOMIC REFEREE"), New System.Data.Common.DataColumnMapping("INTERNET LINK", "INTERNET LINK"), New System.Data.Common.DataColumnMapping("SQLTimeStamp", "SQLTimeStamp"), New System.Data.Common.DataColumnMapping("UpdatedBy", "UpdatedBy"), New System.Data.Common.DataColumnMapping("AddedBy", "AddedBy"), New System.Data.Common.DataColumnMapping("UpdatedDate", "UpdatedDate"), New System.Data.Common.DataColumnMapping("AddedDate", "AddedDate")})})

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

    Public Shared NS As String = "names"
    Public Shared Authority As String = "indexfungorum.org"
    Public Shared AuthLevel As AuthenticationLevel = AuthenticationLevel.Full

    Public Function GetNameLSID(ByVal recordNumber As String)
        Return "urn:lsid:" + Authority + ":" + NS + ":" + recordNumber
    End Function

    Public Function NameFullByKey(ByVal NameLsid As String) As String

        Dim pos = NameLsid.LastIndexOf(":")
        Dim id As String = NameLsid.Substring(pos + 1)
        Dim ds As DataSet = NameByKeyDs(Long.Parse(id))

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
    End Function

    Public Function NameFullByRecordNumber(ByVal recordNumber As String) As String

        Dim ds As DataSet = NameByKeyDs(Long.Parse(recordNumber))

        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            Dim row As DataRow = ds.Tables(0).Rows(0)

            Dim fName As String = row("NAME OF FUNGUS").ToString() + " " + row("AUTHORS").ToString()
            If row("YEAR OF PUBLICATION").ToString().Length > 0 Then
                fName += row("YEAR OF PUBLICATION").ToString()
            End If

            Return fName
        Else
            Throw New Exception("Unknown Name")
        End If
    End Function

    Public Function NameByKeyDs(ByVal NameKey As Long) As DataSet

        Dim QueryString As String
        'QueryString = "SELECT  * FROM IndexFungorum WHERE [RECORD NUMBER] = " & CStr(NameKey) & "  ORDER BY [NAME OF FUNGUS] "
        QueryString = "SELECT IndexFungorum.*, Publications.*,FundicClassification.* " _
            & "FROM (IndexFungorum LEFT JOIN FundicClassification " _
            & "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] " _
            & "= FundicClassification.[Fundic Record Number])" _
            & "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
            & "WHERE ((IndexFungorum.[RECORD NUMBER])=" & CStr(NameKey) & " " _
            & " and ([MISAPPLICATION AUTHORS] is null or len([MISAPPLICATION AUTHORS]) = 0)) " _
            & "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
        Dim ds As New DataSet
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Return ds
    End Function

    Public Function LastFiveYearsFlagByKey(ByVal NameKey As Long) As String

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

        Return lfyf
    End Function

    Public Function GetUpdatedNamesForFamily(ByVal fromDate As DateTime, ByVal familyName As String, ByVal newOnly As Boolean)

        Dim QueryString As String = "select i.[RECORD NUMBER], i.AUTHORS, i.[NAME OF FUNGUS], i.UpdatedDate, i.AddedDate" + _
                                    " from IndexFungorum i " + _
                                    " inner join FundicClassification fc on fc.[Fundic Record Number] = i.[NAME OF FUNGUS FUNDIC RECORD NUMBER] " + _
                                    " where fc.[Family name] = '" + familyName + "' and "

        If newOnly Then
            QueryString += "i.AddedDate is not null and i.AddedDate >= '" + fromDate.ToString("MM-dd-yyyy") + "' "
        Else
            QueryString += "i.UpdatedDate is not null and i.UpdatedDate >= '" + fromDate.ToString("MM-dd-yyyy") + "' "
        End If

        QueryString += "ORDER BY i.[NAME OF FUNGUS]"

        Dim ds As New DataSet
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Return ds

    End Function

    Public Function GetUpdatedRegisteredNames(ByVal fromDate As DateTime) As DataSet

        Dim QueryString As String
        QueryString = "select i.[RECORD NUMBER], i.[NAME OF FUNGUS], i.[SPECIFIC EPITHET], i.AUTHORS, i.[YEAR OF PUBLICATION], i.[INFRASPECIFIC RANK], i.Page, " + _
             "p.pubOriginalTitle, i.[TYPIFICATION DETAILS], f.[Family name], rn.RegistrationNumber, ru.UserName, d.Diagnosis, " + _
             "bi.[record number] as BasionymId, bi.[name of fungus] as Basionym, " + _
             "ISNULL(i.UpdatedDate, ISNULL(i.AddedDate, i.UpdatedDate)) as Date " + _
            "from IndexFungorum i " + _
            "inner join tblRegistrationUsersNames run on run.[IF-FK] = i.[RECORD NUMBER] " + _
            "inner join tblRegistrationUsers ru on ru.ID = run.UserID " + _
            "inner join tblRegistrationNumbers rn on rn.ID = run.ID " + _
            "LEFT JOIN FundicClassification f ON i.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = f.[Fundic Record Number] " + _
            "LEFT JOIN Publications p ON i.[LITERATURE LINK] = p.pubLink  " + _
            "LEFT JOIN IndexFungorum bi on bi.[record number] = i.[basionym record number] " + _
            "left join tblDiagnosis d on d.recordnumberfk = i.[record number] " + _
            "where ISNULL(i.UpdatedDate, ISNULL(i.AddedDate, i.UpdatedDate)) >= '" + fromDate.ToString("yyyy-MM-dd") + "' " + _
            " and isnull(i.[last five years flag], '') <> 'X' "
        
        Dim ds As New DataSet
        SqlDa_Name.SelectCommand.CommandText = QueryString
        SqlDa_Name.Fill(ds)

        Return ds
    End Function

    Public Function NameByKeyRDF(ByVal NameLsid As String) As String
        Dim rdf As String = ""

        Try
            Dim pos = NameLsid.LastIndexOf(":")
            Dim id As String = NameLsid.Substring(pos + 1)

            Dim tn As TDWG_RDF.TaxonName = GetTaxonName(Long.Parse(id))

            Dim tnRdf As New TDWG_RDF.TaxonNameRDF
            tn.Id = NameLsid

            rdf = tnRdf.GetTaxonNameRDF(tn)

        Catch ex As Exception
            LSIDClient.LSIDException.WriteError(ex.Message)
            Throw New Exception("Unknown LSID")
        End Try

        Return rdf
    End Function

    Public Function GetTaxonName(ByVal nameKey As Long) As TDWG_RDF.TaxonName
        Dim tn As New TDWG_RDF.TaxonName

        Dim ds As DataSet = NameByKeyDs(nameKey)

        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then

            Dim row As DataRow = ds.Tables(0).Rows(0)

            Dim fName As String = row("NAME OF FUNGUS").ToString() + " " + row("AUTHORS").ToString()
            If row("YEAR OF PUBLICATION").ToString().Length > 0 Then
                fName += " " + row("YEAR OF PUBLICATION").ToString()
            End If

            tn.Id = GetNameLSID(nameKey)
            tn.fullName = fName

            Dim lfyf As Boolean = (row("last five years flag").ToString = "X")

            If AuthLevel = AuthenticationLevel.Full Or Not lfyf Then
                Dim isSubGenus As Boolean = True
                If row("STS FLAG").ToString = "g" Then isSubGenus = False

                If ds.Tables(0).Columns.Contains("INFRASPECIFIC RANK") AndAlso Not row.IsNull("INFRASPECIFIC RANK") Then
                    Dim rnk As String = row("INFRASPECIFIC RANK").ToString()
                    tn.rankString = rnk
                Else
                    tn.rankString = "species"
                End If

                tn.rank = GetTCSRank(tn.rankString)

                tn.nameComplete = row("NAME OF FUNGUS").ToString()
                tn.nomenclaturalCode = TDWG_RDF.TCSNomenclaturalCode.ICBN

                If Not isSubGenus Then
                    tn.uninomial = row("NAME OF FUNGUS").ToString()
                Else
                    tn.genusPart = row("Genus name").ToString()
                    tn.specificEpithet = row("SPECIFIC EPITHET").ToString()
                    tn.infraSpecificEpithet = row("INFRASPECIFIC EPITHET").ToString()
                End If
                tn.authorship = row("AUTHORS").ToString()
                Dim bas As String = row("BASIONYM RECORD NUMBER").ToString()
                If bas.Length > 0 AndAlso bas <> nameKey.ToString Then
                    tn.hasBasionym = GetNameLSID(bas)
                End If
                'bas author
                tn.basionymAuthorship = tn.authorship
                Dim bracketPos As Integer = tn.authorship.IndexOf("(")
                If bracketPos <> -1 Then
                    Dim endPos As Integer = tn.authorship.IndexOf(")", bracketPos)
                    If endPos <> -1 Then
                        Dim len As Integer = endPos - bracketPos
                        tn.basionymAuthorship = tn.authorship.Substring(bracketPos + 1, len - 1).Trim

                        'combination authors
                        tn.combinationAuthorship = tn.authorship.Remove(bracketPos, len + 1).Trim
                    End If
                End If

                Dim pubIn As String = ""
                Dim strData As String = ""
                Dim title As String = ""
                strData = row("pubIMIAbbr").ToString
                If strData <> "" Then
                    'pubIn = "<i>" & strData & "</i>"
                    pubIn = strData
                    title = strData
                End If
                strData = row("pubIMISupAbbr").ToString
                If strData <> "" Then
                    pubIn = pubIn & ", " & strData
                    title &= ", " & strData
                End If
                strData = row("PubIMIAbbrLoc").ToString
                If strData <> "" Then
                    pubIn = pubIn & " (" & strData & ")"
                    title &= " (" & strData & ")"
                End If

                If title.Length > 0 Then
                    tn.publication = New TDWG_RDF.PublicationCitation
                    tn.publication.Id = row("Literature Link").ToString
                    tn.publication.title = title

                    strData = row("VOLUME").ToString
                    If strData <> "" Then
                        'pubIn = pubIn & " <b>" & strData & "</b>"
                        pubIn = pubIn & " " & strData
                        tn.publication.volume = strData
                    End If
                    strData = row("PART").ToString
                    If strData <> "" Then
                        pubIn = pubIn & "(" & strData & ")"
                        tn.publication.number = strData
                    End If
                    strData = row("PAGE").ToString
                    If strData <> "" Then
                        pubIn = pubIn & ": " & strData
                        tn.publication.pages = strData
                    End If
                    strData = row("YEAR OF PUBLICATION").ToString
                    If strData <> "" Then
                        pubIn = pubIn & " (" & strData & ")"
                        tn.publication.year = strData
                    End If
                    strData = row("YEAR ON PUBLICATION").ToString
                    If strData <> "" Then
                        pubIn = pubIn & " [" & strData & "]"
                        tn.publication.year = strData
                    End If
                    'strData = row("YEAR OF PUBLICATION").ToString
                    'If strData <> "" Then
                    '    pubIn = pubIn & " (" & strData & ")"
                    'End If

                    tn.publishedIn = pubIn
                End If

                tn.year = row("YEAR OF PUBLICATION").ToString()

                'tn.microReference = row("PAGE").ToString()

                'isAnamorph?

                'sts flag?
                If row("STS FLAG").ToString = "o" Or row("STS FLAG").ToString = "d" Or row("STS FLAG").ToString = "y" Then
                    'name has been replaced
                    tn.isReplacedBy = GetNameLSID(row("CURRENT NAME RECORD NUMBER").ToString)
                End If
            Else
                Dim msg As String = Configuration.ConfigurationSettings.AppSettings.Get("UnauthenticatedMessage")

                tn.isRestricted.Value = True
                tn.accessMessage = msg
                tn.rightsOwner = "http://www.indexfungorum.org"
            End If

        End If

        Return tn
    End Function

    Public Function GetTaxonConcept(ByVal nameKey As Long) As TDWG_RDF.TaxonConcept
        Dim tc As New TDWG_RDF.TaxonConcept

        Try
            tc.hasName = GetTaxonName(nameKey)
            'tc.accordingToString = "herbIMI" 'TODO
            tc.nameString = tc.hasName.nameComplete
        Catch ex As Exception
            'todo
        End Try

        Return tc
    End Function

    Private Shared Function GetTCSRank(ByVal rankString As String) As TDWG_RDF.TCSRank
        Dim rnk As TDWG_RDF.TCSRank = TDWG_RDF.TCSRank.NotSpecified

        Select Case rankString.ToLower
            Case "biovar", "b.", "B.", "[b.]"
                rnk = TDWG_RDF.TCSRank.BioVariety
            Case "class"
                rnk = TDWG_RDF.TCSRank.Cls
            Case "cv"
                rnk = TDWG_RDF.TCSRank.Cultivar
            Case "f."
                rnk = TDWG_RDF.TCSRank.Form
            Case "family"
                rnk = TDWG_RDF.TCSRank.Family
            Case "genus", "gen"
                rnk = TDWG_RDF.TCSRank.Genus
            Case "graft hybrid"
                rnk = TDWG_RDF.TCSRank.GraftChimaera
            Case "infraclass"
                rnk = TDWG_RDF.TCSRank.Infraclass
            Case "infraorder"
                rnk = TDWG_RDF.TCSRank.Infraorder
            Case "kingdom"
                rnk = TDWG_RDF.TCSRank.Kingdom
            Case "order"
                rnk = TDWG_RDF.TCSRank.Order
            Case "phylum"
                rnk = TDWG_RDF.TCSRank.Phylum
            Case "pv."
                rnk = TDWG_RDF.TCSRank.PathoVariety
            Case "section"
                rnk = TDWG_RDF.TCSRank.Section
            Case "series", "ser."
                rnk = TDWG_RDF.TCSRank.Series
            Case "species"
                rnk = TDWG_RDF.TCSRank.Species
            Case "subclass"
                rnk = TDWG_RDF.TCSRank.Subclass
            Case "subfamily"
                rnk = TDWG_RDF.TCSRank.Subfamily
            Case "subforma", "subf."
                rnk = TDWG_RDF.TCSRank.Subform
            Case "subgenus"
                rnk = TDWG_RDF.TCSRank.Subgenus
            Case "subkingdom"
                rnk = TDWG_RDF.TCSRank.Subkingdom
            Case "suborder"
                rnk = TDWG_RDF.TCSRank.Suborder
            Case "subphylum"
                rnk = TDWG_RDF.TCSRank.Subphylum
            Case "subsection"
                rnk = TDWG_RDF.TCSRank.Subsection
            Case "subseries"
                rnk = TDWG_RDF.TCSRank.Subseries
            Case "subsp.", "[subsp.]", "sub"
                rnk = TDWG_RDF.TCSRank.Subspecies
            Case "subtribe"
                rnk = TDWG_RDF.TCSRank.Subtribe
            Case "subvar."
                rnk = TDWG_RDF.TCSRank.SubVariety
            Case "superclass"
                rnk = TDWG_RDF.TCSRank.Superclass
            Case "superfamily"
                rnk = TDWG_RDF.TCSRank.Superfamily
            Case "superorder"
                rnk = TDWG_RDF.TCSRank.Superorder
            Case "superphylum"
                rnk = TDWG_RDF.TCSRank.Superphylum
            Case "supertribe"
                rnk = TDWG_RDF.TCSRank.Supertribe
            Case "tribe"
                rnk = TDWG_RDF.TCSRank.Tribe
            Case "var.", "[var.]", "<var.>"
                rnk = TDWG_RDF.TCSRank.Variety
            Case "division"
                rnk = TDWG_RDF.TCSRank.Division

        End Select

        Return rnk
    End Function
End Class
