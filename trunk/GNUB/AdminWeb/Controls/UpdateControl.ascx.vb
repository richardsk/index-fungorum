
Partial Class Controls_UpdateControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            errLabel.Text = ""

            Dim provId As Guid = New Guid(Request.QueryString("provId"))

            Dim gda As New GNUBDataAccess.GNUBAdminEntities

            Dim p As GNUBDataAccess.Provider = (From provs In gda.Provider Where provs.ProviderID = provId Select provs).First

            provNameCell.Text = p.ProviderName

            Dim lastSuccUpdate As GNUBDataAccess.UpdateLog = GNUBBusinessRules.Provider.GetLastSuccessfulUpdate(p.ProviderID)
            If lastSuccUpdate IsNot Nothing AndAlso lastSuccUpdate.CompleteDate.HasValue Then
                changedRecCell.Text = GNUBBusinessRules.Provider.GetNumberOfChangedRecords(p.ProviderID, lastSuccUpdate.CompleteDate.Value).ToString
            Else
                changedRecCell.Text = GNUBBusinessRules.Provider.GetNumberOfChangedRecords(p.ProviderID, New DateTime(1900, 1, 1)).ToString
            End If

            Dim lastUpdate As GNUBDataAccess.UpdateLog = GNUBBusinessRules.Provider.GetLastUpdate(p.ProviderID)
            If lastUpdate IsNot Nothing Then
                statusCell.Text = lastUpdate.Status
            Else
                statusCell.Text = "unknown"
            End If

            gvUpdateLog.DataBind()

        Catch ex As Exception
            errLabel.Text = ex.Message
        End Try
    End Sub


    Protected Function UpdateLogVal(ByVal item As System.ComponentModel.ICustomTypeDescriptor) As GNUBDataAccess.UpdateLog
        Dim ul As GNUBDataAccess.UpdateLog = Nothing

        If item IsNot Nothing Then
            Dim prop As ComponentModel.PropertyDescriptor = item.GetProperties.Cast(Of ComponentModel.PropertyDescriptor).First
            ul = CType(item.GetPropertyOwner(prop), GNUBDataAccess.UpdateLog)
        End If

        Return ul
    End Function

    Protected Sub gvUpdateLog_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUpdateLog.RowDataBound
        Dim ul As GNUBDataAccess.UpdateLog = UpdateLogVal(e.Row.DataItem)
        If ul IsNot Nothing Then
            ul.ProviderReference.Load()
            If ul.Provider IsNot Nothing Then
                e.Row.Cells(4).Text = ul.Provider.ProviderName
            End If
        End If
    End Sub

    Protected Sub goButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles goButton.Click
        Try
            Dim provId As Guid = New Guid(Request.QueryString("provId"))
            GNUBBusinessRules.Provider.RunUpdate(provId)
        Catch ex As Exception
            errLabel.Text = ex.Message
        End Try
    End Sub
End Class
