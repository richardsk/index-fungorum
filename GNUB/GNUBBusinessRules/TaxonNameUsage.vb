Public Class TaxonNameUsage

    Private Shared Function GetGNUBProxy() As String
        Dim p As String = "http://gnub.bishopmuseum.org/name/"
        Dim val As String = Configuration.ConfigurationManager.AppSettings.Get("GNUBProxy")
        If val IsNot Nothing Then
            p = val
        End If
        Return p
    End Function

    Public Shared Function SearchNames(ByVal searchText As String) As List(Of GNUBDataAccess.TaxonNameUsage)
        Dim gda As New GNUBDataAccess.GNUBEntities
        Dim tu = From tus In gda.TaxonNameUsage Where tus.VerbatimNameString.Contains(searchText) Select tus
        Return tu
    End Function

    Public Shared Function GetLastModifiedDate() As DateTime
        Dim dt As DateTime = DateTime.MinValue

        Using cnn As New System.Data.SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("GNUB").ConnectionString)
            Using cmd As System.Data.SqlClient.SqlCommand = cnn.CreateCommand()

                cmd.CommandText = "sprSelect_LastModifiedDate"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New System.Data.SqlClient.SqlDataAdapter(cmd)
                Dim ds As New DataSet
                da.Fill(ds)

                If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    dt = ds.Tables(0).Rows(0)(0)
                End If
            End Using

        End Using

        Return dt
    End Function

    Public Shared Function GetTNUDwC(ByVal nameUUID As String) As String

        Dim dwc As New TDWG_RDF.DarwinCore2

        Using cnn As New System.Data.SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("GNUB").ConnectionString)
            Using cmd As System.Data.SqlClient.SqlCommand = cnn.CreateCommand()

                cmd.CommandText = "sprSelect_TNUDetails"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameId", SqlDbType.UniqueIdentifier).Value = New Guid(nameUUID)

                Dim da As New System.Data.SqlClient.SqlDataAdapter(cmd)
                Dim ds As New DataSet
                da.Fill(ds)

                If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then

                    Dim tn As New TDWG_RDF.DwcTaxon
                    tn.taxonNameID = GetGNUBProxy() + nameUUID.ToUpper
                    tn.acceptedTaxonNameID = GetGNUBProxy() + ds.Tables(0).Rows(0)("AcceptedNameID").ToString.ToUpper
                    tn.basionymID = GetGNUBProxy() + ds.Tables(0).Rows(0)("BasionymID").ToString.ToUpper
                    tn.scientificName = ds.Tables(0).Rows(0)("CacheNameComplete").ToString
                    tn.taxonRank = ds.Tables(0).Rows(0)("RankName").ToString
                    tn.higherTaxonNameID = GetGNUBProxy() + ds.Tables(0).Rows(0)("ParentNameID").ToString.ToUpper
                    tn.nomenclaturalCode = ds.Tables(0).Rows(0)("CacheNomCode").ToString
                    'tn.nomenclaturalStatus = ds.Tables(0).Rows(0)("CacheNomStatus").ToString
                    tn.taxonomicStatus = ds.Tables(0).Rows(0)("CacheNomStatus").ToString
                    tn.taxonAccordingTo = ds.Tables(0).Rows(0)("AccordingTo").ToString
                    tn.namePublishedIn = ds.Tables(0).Rows(0)("PublishedIn").ToString
                    tn.scientificNameAuthorship = ds.Tables(0).Rows(0)("ScientificNameAuthors").ToString

                    dwc.AddName(tn)
                End If
            End Using

        End Using

        If dwc.TaxonNames.Count = 0 Then Return ""

        Return dwc.GetNamesCsv("GNUB", True)
    End Function

    Public Shared Function GetLatestDumpFile(ByVal folder As String) As String
        Dim files As String() = IO.Directory.GetFiles(folder, "*.csv")
        Array.Sort(files)
        If files.Count > 0 Then
            Return files(files.Count - 1)
        End If
        Return ""
    End Function


    ''' <summary>
    ''' Get a dump of all TNUs.  Creates a CSV file and returns location of the file.
    ''' May need to be run on a separate thread as it may take a while. naah.
    ''' </summary>
    ''' <param name="saveFolder">Specifies the folder to save the csv file to.</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetAllTNUDwC(ByVal saveFolder As String, ByVal fromDate As DateTime) As String
        Dim id As Integer = 0

        If fromDate = DateTime.MinValue Then fromDate = New DateTime(1800, 1, 1)

        Dim fName As String = IO.Path.Combine(saveFolder, "dwc_dump_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv")

        'do 1 record at a time
        Using cnn As New System.Data.SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("GNUB").ConnectionString)
            cnn.Open()

            Try

                Dim cmd As System.Data.SqlClient.SqlCommand = cnn.CreateCommand()

                cmd.CommandText = "sprSelect_ModifiedTNUs"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@fromDate", SqlDbType.DateTime).Value = fromDate

                Dim da As New SqlClient.SqlDataAdapter(cmd)
                Dim ds As New DataSet
                da.Fill(ds)

                If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
                    'no data since date provided
                    fName = ""
                    Return fName
                End If

                Dim dwc As New TDWG_RDF.DarwinCore2

                For Each row As DataRow In ds.Tables(0).Rows

                    Dim tn As New TDWG_RDF.DwcTaxon
                    tn.taxonNameID = GetGNUBProxy() + row("NameId").ToString.ToUpper
                    tn.acceptedTaxonNameID = GetGNUBProxy() + row("AcceptedNameID").ToString.ToUpper
                    tn.basionymID = GetGNUBProxy() + row("BasionymID").ToString.ToUpper
                    tn.scientificName = row("CacheNameComplete").ToString
                    tn.taxonRank = row("RankName").ToString
                    tn.higherTaxonNameID = GetGNUBProxy() + row("ParentNameID").ToString.ToUpper
                    tn.nomenclaturalCode = row("CacheNomCode").ToString
                    'tn.nomenclaturalStatus = row("CacheNomStatus").ToString
                    tn.taxonomicStatus = row("CacheNomStatus").ToString
                    tn.taxonAccordingTo = row("AccordingTo").ToString
                    tn.namePublishedIn = row("PublishedIn").ToString
                    tn.scientificNameAuthorship = row("ScientificNameAuthors").ToString

                    dwc.AddName(tn)

                Next

                dwc.SaveNamesCsv("GNUB", True, fName)
            Catch ex As Exception
                'TODO error ?
            End Try

        End Using

        Return fName
    End Function

End Class
