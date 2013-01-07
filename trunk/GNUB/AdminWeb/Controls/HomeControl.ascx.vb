
Partial Class Controls_HomeControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        '
        ' Provider     Last updated     Num new records
        '  X               2/2/2009        334               [update now link]
        '  Y               3/3/2008        22009             [update now link]
        ' ...

        Try
            Dim u As GNUBDataAccess.User = Utility.GetUser

            Dim gda As New GNUBDataAccess.GNUBAdminEntities

            Dim provs = (From providers In gda.Provider _
                From up In gda.UserProvider Where up.Provider.ProviderID = providers.ProviderID _
                From tu In gda.User Where tu.UserID = up.User.UserID _
                Select providers).Distinct

            For Each p As GNUBDataAccess.Provider In provs
                Dim row As New TableRow

                Dim provId As Guid = p.ProviderID
                
                Dim numRecs As String = "unknown"
                Dim dt As String = "never"

                Dim lastSuccUpdate As GNUBDataAccess.UpdateLog = GNUBBusinessRules.Provider.GetLastSuccessfulUpdate(p.ProviderID)
                If lastSuccUpdate IsNot Nothing AndAlso lastSuccUpdate.CompleteDate.HasValue Then
                    dt = lastSuccUpdate.CompleteDate.ToString()
                    numRecs = GNUBBusinessRules.Provider.GetNumberOfChangedRecords(p.ProviderID, lastSuccUpdate.CompleteDate.Value).ToString
                Else
                    numRecs = GNUBBusinessRules.Provider.GetNumberOfChangedRecords(p.ProviderID, New DateTime(1900, 1, 1)).ToString
                End If

                Dim tc As New TableCell
                tc.Text = "<a href='default.aspx?tab=editProvider&provId=" + provId.ToString + "'>Edit</a>"
                row.Cells.Add(tc)

                tc = New TableCell
                tc.Text = p.ProviderName
                row.Cells.Add(tc)

                tc = New TableCell
                tc.Text = dt
                row.Cells.Add(tc)

                tc = New TableCell
                tc.Text = numRecs
                row.Cells.Add(tc)

                tc = New TableCell
                tc.Text = "<a href='default.aspx?tab=updateProvider&provId=" + provId.ToString + "'>View updates</a>"
                row.Cells.Add(tc)

                provTable.Rows.Add(row)
            Next
        Catch ex As Exception
            errLabel.Text = ex.Message
        End Try


    End Sub
End Class
