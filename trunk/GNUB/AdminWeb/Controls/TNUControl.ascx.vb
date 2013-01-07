
Partial Class Controls_TNUControl
    Inherits System.Web.UI.UserControl

    Protected Function TNUVal(ByVal item As System.ComponentModel.ICustomTypeDescriptor) As GNUBDataAccess.TaxonNameUsage
        Dim tnu As GNUBDataAccess.TaxonNameUsage = Nothing

        If item IsNot Nothing Then
            Dim prop As ComponentModel.PropertyDescriptor = item.GetProperties.Cast(Of ComponentModel.PropertyDescriptor).First
            tnu = CType(item.GetPropertyOwner(prop), GNUBDataAccess.TaxonNameUsage)
        End If

        Return tnu
    End Function

    Protected Function NomActVal(ByVal item As System.ComponentModel.ICustomTypeDescriptor) As GNUBDataAccess.NomenclaturalEvent
        Dim na As GNUBDataAccess.NomenclaturalEvent = Nothing

        If item IsNot Nothing Then
            Dim prop As ComponentModel.PropertyDescriptor = item.GetProperties.Cast(Of ComponentModel.PropertyDescriptor).First
            na = CType(item.GetPropertyOwner(prop), GNUBDataAccess.NomenclaturalEvent)
        End If

        Return na
    End Function


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim id As String = Request.QueryString.Get("tnuid")
        Dim idVal As Integer = 0
        If Integer.TryParse(id, idVal) Then
            tnuDs.Where = "it.[TaxonNameUsageID]=" + id
            tnaDs.Where = "it.TaxonNameUsage.TaxonNameUsageID=" + id

            TNUDetails.DataBind()
            ActsList.DataBind()

            Try

                Dim tnu As GNUBDataAccess.TaxonNameUsage = TNUVal(TNUDetails.DataItem)
                tnu.ReferenceReference.Load()
                If tnu.Reference IsNot Nothing Then
                    TNUDetails.Rows(8).Cells(1).Text += "<br/>" + tnu.Reference.CacheReference

                End If

                If tnu.ProtonymReference IsNot Nothing AndAlso tnu.ProtonymReference.EntityKey IsNot Nothing Then
                    Dim gda As New GNUBDataAccess.GNUBEntities
                    Dim pid As Integer = CInt(tnu.ProtonymReference.EntityKey.EntityKeyValues(0).Value)
                    Dim rows = From tnus In gda.TaxonNameUsage Where tnus.TaxonNameUsageID = pid Select tnus
                    If rows.Count > 0 Then
                        TNUDetails.Rows(7).Cells(1).Text += "<br/>" + rows.First.VerbatimNameString
                    End If
                End If

                tnu.TaxonNameUsage2Reference.Load()
                If tnu.TaxonNameUsage2 IsNot Nothing Then
                    TNUDetails.Rows(9).Cells(1).Text += "<br/>" + tnu.TaxonNameUsage2.VerbatimNameString
                End If

                tnu.TaxonNameUsage3Reference.Load()
                If tnu.TaxonNameUsage3 IsNot Nothing Then
                    TNUDetails.Rows(10).Cells(1).Text += "<br/>" + tnu.TaxonNameUsage3.VerbatimNameString
                End If

            Catch ex As Exception
                errLabel.Text = "Error loading taxon name usage " + ex.Message

            End Try

        End If
    End Sub

    Protected Sub ActsList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles ActsList.RowDataBound
        If e.Row.DataItem IsNot Nothing Then
            Dim na As GNUBDataAccess.NomenclaturalEvent = NomActVal(e.Row.DataItem)
            If na IsNot Nothing Then
                na.NomenclaturalEventTypeReference.Load()
                If na.NomenclaturalEventType IsNot Nothing Then
                    e.Row.Cells(4).Text += "<br/>" + na.NomenclaturalEventType.NomenclaturalEventType1
                End If
                na.NomenclaturalEvent2Reference.Load()
                If na.NomenclaturalEvent2 IsNot Nothing Then
                    na.NomenclaturalEvent2.TaxonNameUsageReference.Load()
                    If na.NomenclaturalEvent2.TaxonNameUsage IsNot Nothing Then
                        e.Row.Cells(3).Text = "<a href='default.aspx?tab=display&tnuid=" + na.NomenclaturalEvent2.TaxonNameUsage.TaxonNameUsageID.ToString + "'>" + e.Row.Cells(3).Text + "</a>"
                    End If
                End If
            End If
        End If
    End Sub
End Class
