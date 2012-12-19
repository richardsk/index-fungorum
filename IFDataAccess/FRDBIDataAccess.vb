Public Class FRDBIDataAccess

    Public Shared NS As String = "taxon-occurrence"
    Public Shared Authority As String = "frdbi.info"
    Public Shared AuthLevel As AuthenticationLevel = AuthenticationLevel.Full

    Public Function GetSpecimenLSID(ByVal recordNumber As String) As String
        Return "urn:lsid:" + Authority + ":" + NS + ":" + recordNumber
    End Function

    Public Function GetHerbIMILSID(ByVal herbIMIrecordNumber As String) As String
        Return "urn:lsid:herbimi.info:specimens:" + herbIMIrecordNumber
    End Function

    Private ReadOnly Property ConnectionString() As String
        Get
            Return System.Configuration.ConfigurationSettings.AppSettings("FRDBIConnectionString")
        End Get
    End Property

    Public Function GetFRDBIRecord(ByVal recordId As Long) As DataSet
        Dim ds As New DataSet

        Dim cnn As New SqlClient.SqlConnection(ConnectionString)

        Dim cmd As New SqlClient.SqlCommand("select * from vwfrdbi where FRDBIRecordNumber = " + recordId.ToString)
        cmd.Connection = cnn

        cnn.Open()

        Dim da As New SqlClient.SqlDataAdapter(cmd)
        da.Fill(ds)

        Return ds
    End Function

    Public Function GetFRDBILSIDData(ByVal frdbiLsid As String) As String
        Return frdbiLsid 'todo
    End Function

    Public Function GetFRDBIRecordRDF(ByVal frdbiLsid As String) As String
        Dim rdf As String

        Try
            Dim pos = frdbiLsid.LastIndexOf(":")
            Dim id As String = frdbiLsid.Substring(pos + 1)
            Dim ds As DataSet = GetFRDBIRecord(id)

            If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then

                Dim row As DataRow = ds.Tables(0).Rows(0)

                Dim ifDa As New IFDataAccess

                Dim TaxonOccurrenceItem As New TDWG_RDF.TaxonOccurrence
                Dim sp As New TDWG_RDF.SpecimenRDF

                TaxonOccurrenceItem.Id = frdbiLsid

                If AuthLevel = AuthenticationLevel.Full Then
                    'todo - basis??
                    'TaxonOccurrenceItem.basisOfRecord = TDWG_RDF.BasisOfRecordTerm.Living
                    TaxonOccurrenceItem.basisOfRecordString = "Record is based on a specimen"

                    TaxonOccurrenceItem.catalogNumber = row("FRDBIRecordNumber").ToString

                    If row("Ownership").ToString <> "0" AndAlso row("Collector").ToString.ToLower <> "anon" Then
                        TaxonOccurrenceItem.collector = row("Collector").ToString
                    End If

                    If Not TaxonOccurrenceItem.collector Is Nothing AndAlso TaxonOccurrenceItem.collector.Length > 0 Then
                        TaxonOccurrenceItem.collectorsBatchNumber = row("CollectorsRecordNumber").ToString
                    End If

                    'todo ?
                    TaxonOccurrenceItem.continent = "Europe"
                    TaxonOccurrenceItem.country = row("Country").ToString
                    TaxonOccurrenceItem.county = row("County").ToString
                    TaxonOccurrenceItem.locality = row("Locality").ToString
                    '? TaxonOccurrenceItem.stateProvince = row("L3area").ToString 

                    TaxonOccurrenceItem.verbatimCoordinates = row("GridReference").ToString
                    TaxonOccurrenceItem.verbatimCoordinateSystem = "UK grid reference"

                    TaxonOccurrenceItem.hostCollectionString = row("LocationOfSpecimen").ToString

                    If TaxonOccurrenceItem.hostCollectionString.Length > 0 Then
                        If TaxonOccurrenceItem.hostCollectionString.ToUpper = "IMI" AndAlso row("AccessionNumber").ToString.Length > 0 Then
                            TaxonOccurrenceItem.disposition = GetHerbIMILSID(row("AccessionNumber").ToString)
                        End If
                    End If

                    Try
                        TaxonOccurrenceItem.earliestDateCollected = row("CollectionDateStart")
                        TaxonOccurrenceItem.lastDateCollected = row("CollectionDateEnd")
                    Catch ex As Exception
                    End Try

                    TaxonOccurrenceItem.geodeticDatum = "not recorded"
                    TaxonOccurrenceItem.georeferenceProtocol = "Derived from UK Grid Reference"
                    TaxonOccurrenceItem.georeferenceVerificationStatus = "See georeferenceProtocol"

                    'TaxonOccurrenceItem.institutionCode = "CABI" 

                    TaxonOccurrenceItem.identifiedTo = New TDWG_RDF.Identification
                    Dim nameId As String = row("NameOfFungusCounter").ToString

                    'todo - correct?
                    TaxonOccurrenceItem.identifiedTo.taxon = ifDa.GetTaxonConcept(nameId)
                    TaxonOccurrenceItem.identifiedTo.occurrence = TaxonOccurrenceItem
                    TaxonOccurrenceItem.identifiedTo.taxonName = row("CurrentName").ToString

                    TaxonOccurrenceItem.identifiedTo.expertName = row("Identifier").ToString

                    Dim hTax As String = row("Family").ToString
                    If row("Order").ToString.Length > 0 Then hTax += "; " + row("Order").ToString
                    If row("SubClass").ToString.Length > 0 Then hTax += "; " + row("SubClass").ToString
                    If row("Class").ToString.Length > 0 Then hTax += "; " + row("Class").ToString
                    If row("Phylum").ToString.Length > 0 Then hTax += "; " + row("Phylum").ToString

                    TaxonOccurrenceItem.identifiedTo.higherTaxon = New TDWG_RDF.TaxonConcept
                    TaxonOccurrenceItem.identifiedTo.higherTaxon.nameString = hTax

                    TaxonOccurrenceItem.identifiedTo.verbatimDet = row("NameOfFungus").ToString

                    TaxonOccurrenceItem.identifiedToString = row("CurrentName").ToString

                    'todo ? TaxonOccurrenceItem.typeStatusString = row("SpecimenTypeStatus").ToString
                    'todo ? TaxonOccurrenceItem.typeStatus = GetTypeStatus(TaxonOccurrenceItem.typeStatusString)
                    'If row("SpecimenTypeStatus").ToString.ToLower = "type" Then
                    'the following name should exist!
                    'TaxonOccurrenceItem.typeForName = TaxonOccurrenceItem.identifiedTo.taxon.hasName
                    'End If

                    'interactions
                    If Not row.IsNull("AssociatedOrganism") Then
                        Dim intObj As New TDWG_RDF.TaxonOccurrenceInteraction
                        intObj.accordingToString = "FRDBI" 'todo is this correct?
                        intObj.fromOccurence = TaxonOccurrenceItem

                        'todo ?
                        'intObj.interactionCategory = TDWG_RDF.TaxonOccurrenceInteractionTerm.HasHost
                        intObj.interactionCategoryString = "is associated with"

                        intObj.toOccurrence = New TDWG_RDF.TaxonOccurrence
                        'Dim orgId As String = row("AssociatedOrganismFk").ToString

                        intObj.toOccurrence.identifiedTo = New TDWG_RDF.Identification
                        intObj.toOccurrence.identifiedTo.taxon = New TDWG_RDF.TaxonConcept
                        intObj.toOccurrence.identifiedTo.taxon.hasName = New TDWG_RDF.TaxonName
                        intObj.toOccurrence.identifiedTo.taxonName = row("AssociatedOrganism").ToString
                        If Not row.IsNull("AcceptedAssociatedOrganism") Then
                            intObj.toOccurrence.identifiedTo.taxonName = row("AcceptedAssociatedOrganism").ToString
                        End If

                        'todo ?
                        'If row("AssociatedOrganismType").ToString.ToLower = "p" Then
                        '    'IPNI plant id
                        '    intObj.toOccurrence.identifiedTo.taxon.hasName.Id = GetIPNILSID(orgId)
                        'Else
                        '    'IF fungus id
                        '    intObj.toOccurrence.identifiedTo.taxon.hasName.Id = GetSpecimenLSID(orgId)
                        'End If

                        TaxonOccurrenceItem.Interactions.Add(intObj)
                    End If
                Else
                    Dim msg As String = Configuration.ConfigurationSettings.AppSettings.Get("UnauthenticatedMessage")

                    TaxonOccurrenceItem.isRestricted.Value = True
                    TaxonOccurrenceItem.accessMessage = msg
                    TaxonOccurrenceItem.rightsOwner = "http://www.frdbi.info"
                End If

                rdf = sp.GetOccurrenceRDF(TaxonOccurrenceItem)

            Else
                Throw New Exception("Unknown LSID")
            End If


        Catch ex As Exception
            LSIDClient.LSIDLog.LogMessage("Data access error: " + ex.Message + ": " + ex.StackTrace)
        End Try

        Return rdf
    End Function
End Class
