Imports SemWeb
Imports System.Configuration

Public Class HerbIMIDataAccess

    Public Sub New()
    End Sub

    Public Shared NS As String = "specimens"
    Public Shared Authority As String = "herbimi.info"
    Public Shared AuthLevel As AuthenticationLevel = AuthenticationLevel.Full

    Public Function GetSpecimenLSID(ByVal recordNumber As String) As String
        Return "urn:lsid:" + Authority + ":" + NS + ":" + recordNumber
    End Function

    Public Function GetIPNILSID(ByVal ipniRecordId As String) As String
        Return "urn:lsid:ipni.org:names:" + ipniRecordId
    End Function

    Public Function SpecimenByKeyDs(ByVal SpecimenKey As String) As DataSet

        Dim QueryString As String
        QueryString = "SELECT *  FROM tblHerbIMIDemo i "

        Dim isNum As Boolean = False
        Try
            Integer.Parse(SpecimenKey)
            isNum = True
        Catch ex As Exception
        End Try
        If isNum Then
            QueryString &= " LEFT JOIN tblGeographyDemo g ON g.iminumber = i.iminumber "
        Else
            QueryString &= " LEFT JOIN tblGeographyDemo g ON g.iminumber = -1 "
        End If

        QueryString &= " WHERE ( i.iminumber = '" + SpecimenKey + "' ) " _
            & " ORDER BY i.iminumber;"

        Dim cnn As New SqlClient.SqlConnection(ConfigurationSettings.AppSettings("HerbIMIConnectionString"))
        Dim cmd As New SqlClient.SqlCommand(QueryString)
        cmd.Connection = cnn
        Dim ds As New DataSet
        Dim da As New SqlClient.SqlDataAdapter(cmd)

        da.Fill(ds)

        Return ds
    End Function

    Public Function SpecimenByKeyRDF(ByVal SpecimenLsid As String) As String
        Dim rdf As String = ""

        Try
            Dim pos = SpecimenLsid.LastIndexOf(":")
            Dim id As String = SpecimenLsid.Substring(pos + 1)
            Dim ds As DataSet = SpecimenByKeyDs(id)

            If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then

                Dim row As DataRow = ds.Tables(0).Rows(0)

                Dim ifDa As New IFDataAccess

                Dim TaxonOccurrenceItem As New TDWG_RDF.TaxonOccurrence
                Dim sp As New TDWG_RDF.SpecimenRDF

                TaxonOccurrenceItem.Id = SpecimenLsid

                If AuthLevel = AuthenticationLevel.Full Then
                    TaxonOccurrenceItem.basisOfRecord = TDWG_RDF.BasisOfRecordTerm.Preserved
                    TaxonOccurrenceItem.basisOfRecordString = TDWG_RDF.BasisOfRecordTerm.Preserved.ToString
                    If row("Vouchered").ToString().ToLower = "d" Then
                        'has been discarded, so now only a digital record
                        TaxonOccurrenceItem.basisOfRecord = TDWG_RDF.BasisOfRecordTerm.Digital
                        TaxonOccurrenceItem.basisOfRecordString = TDWG_RDF.BasisOfRecordTerm.Digital.ToString
                    ElseIf row("Vouchered").ToString().ToLower = "g" Then
                        TaxonOccurrenceItem.basisOfRecord = TDWG_RDF.BasisOfRecordTerm.Living
                        TaxonOccurrenceItem.basisOfRecordString = TDWG_RDF.BasisOfRecordTerm.Living.ToString
                    End If

                    TaxonOccurrenceItem.catalogNumber = row("IMINumber").ToString
                    'todo - this doesnt match up with the taxon occurrence ontology - ie should be continent, area, region in ontology
                    TaxonOccurrenceItem.continent = row("L1continent").ToString
                    TaxonOccurrenceItem.country = row("L4ISOcountry").ToString
                    'TaxonOccurrenceItem.county = row("L3area").ToString

                    Try
                        TaxonOccurrenceItem.earliestDateCollected = New DateTime(Integer.Parse(row("YearOfCollection").ToString), 1, 1)
                        TaxonOccurrenceItem.lastDateCollected = TaxonOccurrenceItem.earliestDateCollected
                    Catch ex As Exception
                    End Try

                    TaxonOccurrenceItem.hostCollectionString = "herbIMI" 'TODO collection object
                    'todo TaxonOccurrenceItem.institutionCode = "CABI" 

                    TaxonOccurrenceItem.identifiedTo = New TDWG_RDF.Identification
                    Dim nameId As String = row("FinalNameDataIF-DFnumber").ToString
                    If nameId = "0" Or nameId = "" Then nameId = row("OriginalNameDataIF-DFnumber").ToString
                    TaxonOccurrenceItem.identifiedTo.taxon = ifDa.GetTaxonConcept(nameId)
                    TaxonOccurrenceItem.identifiedTo.occurrence = TaxonOccurrenceItem
                    If Not TaxonOccurrenceItem.identifiedTo.taxon.hasName Is Nothing Then
                        TaxonOccurrenceItem.identifiedTo.taxonName = TaxonOccurrenceItem.identifiedTo.taxon.hasName.nameComplete
                    End If

                    TaxonOccurrenceItem.identifiedToString = row("FinalNameDataEdited").ToString
                    If TaxonOccurrenceItem.identifiedToString = "" Then TaxonOccurrenceItem.identifiedToString = row("OrigianlNameDataEdited").ToString

                    TaxonOccurrenceItem.locality = row("Locality").ToString
                    TaxonOccurrenceItem.stateProvince = row("L3area").ToString 'same as county

                    TaxonOccurrenceItem.typeStatusString = row("SpecimenTypeStatus").ToString
                    TaxonOccurrenceItem.typeStatus = GetTypeStatus(TaxonOccurrenceItem.typeStatusString)
                    If row("SpecimenTypeStatus").ToString.ToLower = "type" Then
                        'the following name should exist!
                        TaxonOccurrenceItem.typeForName = TaxonOccurrenceItem.identifiedTo.taxon.hasName
                    End If

                    'interactions
                    If Not row.IsNull("AssociatedOrganismFk") Then
                        Dim intObj As New TDWG_RDF.TaxonOccurrenceInteraction
                        intObj.accordingToString = "herbIMI" 'todo is this correct?
                        intObj.fromOccurence = TaxonOccurrenceItem
                        intObj.interactionCategory = TDWG_RDF.TaxonOccurrenceInteractionTerm.HasHost

                        intObj.toOccurrence = New TDWG_RDF.TaxonOccurrence
                        Dim orgId As String = row("AssociatedOrganismFk").ToString

                        intObj.toOccurrence.identifiedTo = New TDWG_RDF.Identification
                        intObj.toOccurrence.identifiedTo.taxon = New TDWG_RDF.TaxonConcept
                        intObj.toOccurrence.identifiedTo.taxon.hasName = New TDWG_RDF.TaxonName
                        intObj.toOccurrence.identifiedTo.taxonName = row("AssociatedOrganism").ToString

                        If row("AssociatedOrganismType").ToString.ToLower = "p" Then
                            'IPNI plant id
                            intObj.toOccurrence.identifiedTo.taxon.hasName.Id = GetIPNILSID(orgId)
                        Else
                            'IF fungus id
                            intObj.toOccurrence.identifiedTo.taxon.hasName.Id = GetSpecimenLSID(orgId)
                        End If

                        TaxonOccurrenceItem.Interactions.Add(intObj)
                    End If
                Else
                    Dim msg As String = Configuration.ConfigurationSettings.AppSettings.Get("UnauthenticatedMessage")

                    TaxonOccurrenceItem.isRestricted.Value = True
                    TaxonOccurrenceItem.accessMessage = msg
                    TaxonOccurrenceItem.rightsOwner = "http://www.herbimi.info"
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

    Private Function GetTypeStatus(ByVal typeStatus As String) As TDWG_RDF.NomenclaturalTypeType
        Dim ts As TDWG_RDF.NomenclaturalTypeType = TDWG_RDF.NomenclaturalTypeType.NotSpecified

        If typeStatus.ToLower = "type" Then ts = TDWG_RDF.NomenclaturalTypeType.Type
        If typeStatus.ToLower.IndexOf("holotype") <> -1 Then ts = TDWG_RDF.NomenclaturalTypeType.Holotype
        If typeStatus.ToLower.IndexOf("isotype") <> -1 Then ts = TDWG_RDF.NomenclaturalTypeType.Isotype
        If typeStatus.ToLower.IndexOf("lectotype") <> -1 Then ts = TDWG_RDF.NomenclaturalTypeType.Lectotype
        'todo If typeStatus.ToLower.IndexOf("isoparatype") <> -1 Then ts = TDWG_RDF.NomenclaturalTypeType.IsoParaType

        Return ts
    End Function
End Class
