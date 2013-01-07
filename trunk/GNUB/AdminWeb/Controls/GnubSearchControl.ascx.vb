
Partial Class Controls_GnubSearchControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        errLabel.Text = ""
    End Sub

    Protected Function TNUVal(ByVal item As System.ComponentModel.ICustomTypeDescriptor) As GNUBDataAccess.TaxonNameUsage
        Dim tnu As GNUBDataAccess.TaxonNameUsage = Nothing

        If item IsNot Nothing Then
            Dim prop As ComponentModel.PropertyDescriptor = item.GetProperties.Cast(Of ComponentModel.PropertyDescriptor).First
            tnu = CType(item.GetPropertyOwner(prop), GNUBDataAccess.TaxonNameUsage)
        End If

        Return tnu
    End Function

    Protected Sub searchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles searchButton.Click
        DisplayRecords("")
    End Sub

    Protected Sub ResultsView_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ResultsView.DataBound

        For Each row As GridViewRow In ResultsView.Rows
            Dim tnuid As Integer = Integer.Parse(row.Cells(0).Text)
            row.Cells(0).Text = "<a href='default.aspx?tab=display&tnuid=" + tnuid.ToString + "'>" + tnuid.ToString + "</a>"

            Dim gda As New GNUBDataAccess.GNUBEntities
            Dim ids = From rows In gda.Identifier Where rows.PK.PKID = tnuid Select rows
            If ids.Count > 0 Then
                row.Cells(5).Text = ids.First.Identifier1

                ids.First.IdentifierDomainReference.Load()
                If ids.First.IdentifierDomain IsNot Nothing Then
                    row.Cells(6).Text = ids.First.IdentifierDomain.Abbreviation
                End If
            End If
        Next

        If Page.IsPostBack AndAlso ResultsView.Rows.Count = 0 Then
            errLabel.Text = "No records found"
        End If
    End Sub

    Protected Sub ResultsView_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ResultsView.PageIndexChanged
        DisplayRecords("")
    End Sub

    Protected Sub ResultsView_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles ResultsView.PageIndexChanging
        ResultsView.PageIndex = e.NewPageIndex
    End Sub


    Protected Sub ResultsView_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles ResultsView.Sorting
        Dim sortExp As String = "it.[" + e.SortExpression + "]"
        If e.SortDirection = SortDirection.Descending Then sortExp += " desc"
        DisplayRecords(sortExp)
    End Sub


    Private Sub DisplayRecords(ByVal sortExp As String)
        TNUs.Where = "it.[VerbatimNameString] like '%" + searchText.Text.Replace("'", "") + "%'"

        If sortExp = "" Then sortExp = "it.[VerbatimNameString]"
        TNUs.OrderBy = sortExp

        ResultsView.DataBind()

    End Sub


End Class
