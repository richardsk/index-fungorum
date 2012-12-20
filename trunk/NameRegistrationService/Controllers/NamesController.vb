Imports System.Net
Imports System.Web.Http
Imports System.Runtime.Serialization

<Assembly: ContractNamespaceAttribute("http://www.indexfungorum.org/names", _
   ClrNamespace:="NameRegistrationService")> 

Public Class NamesController
    Inherits ApiController

    ' GET updated names from date (YYYY-MM-DD)
    Public Function GetUpdatedRegisteredNames(fromDate As String) As IEnumerable(Of NameRegistration)
        Dim names As New List(Of NameRegistration)

        Dim ifda As New IFDataAccess.IFDataAccess
        Dim nameDs As DataSet = ifda.GetUpdatedRegisteredNames(DateTime.Parse(fromDate))

        For Each row As DataRow In nameDs.Tables(0).Rows
            Dim n As New NameRegistration
            n.Authors = row("Authors").ToString
            n.Epithet = row("Specific Epithet").ToString
            n.FullName = row("Name Of Fungus").ToString
            n.HigherRankName = row("Family name").ToString 'TODO correct?
            n.Basionym = row("Basionym").ToString
            n.BasionymId = row("BasionymId").ToString
            n.Etymology = "" 'none
            n.Gender = "" 'none
            'type stuff
            Dim typeStr As String = row("Typification Details").ToString
            If typeStr <> "" Then
                If typeStr.StartsWith("Holotype IMI") Then
                    n.HolotypeLocation = "IMI"
                    n.HolotypeSpecimenId = typeStr.Substring(9)
                ElseIf typeStr.StartsWith("Holotype PDD") Then
                    n.HolotypeLocation = "PDD"
                    n.HolotypeSpecimenId = typeStr(9)
                ElseIf typeStr.IndexOf("$") <> -1 Then
                    Try
                        Dim id As String = typeStr.Substring(0, typeStr.IndexOf("$") - 1)
                        n.Type = ifda.NameFullByRecordNumber(Long.Parse(id))
                        n.TypeNameId = id
                    Catch ex As Exception
                        'TODO log error
                    End Try
                ElseIf Char.IsNumber(typeStr(0)) Then
                    Try
                        n.TypeNameId = typeStr
                        n.Type = ifda.NameFullByRecordNumber(Long.Parse(typeStr))
                    Catch ex As Exception
                        'TODO log error
                    End Try
                Else
                    n.Type = typeStr
                End If
            End If
            n.LocalId = row("record number").ToString
            n.Page = row("Page").ToString
            n.Diagnosis = row("Diagnosis").ToString
            n.RegistrationNumber = row("RegistrationNumber").ToString
            n.Publication = row("pubOriginalTitle").ToString
            n.Rank = row("infraspecific rank").ToString
            n.RegisteredAt = "Index Fungorum"
            n.RegisteredBy = row("Username").ToString
            n.RegistrationDate = row("Date")
            n.WebUrl = "http://indexfungorum.org/Names/NamesRecord.asp?RecordID=" + n.LocalId
            n.Year = row("Year Of Publication").ToString

            names.Add(n)
        Next

        Return names
    End Function

    ' POST updated names from date
    Public Sub PostValue(<FromBody()> ByVal value As String)

    End Sub

End Class
