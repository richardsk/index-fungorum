
Partial Class Controls_HeaderControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim tab As String = Request.QueryString.Get("tab")
        If tab Is Nothing Then tab = "home"
        tab = tab.ToLower

        If tab.ToLower = "gnubsearch" Then
            searchCell.CssClass = "currentmenu"
        ElseIf tab.ToLower = "provsearch" Then
            provSearchCell.CssClass = "currentmenu"
        ElseIf tab.ToLower = "home" Then
            homeCell.CssClass = "currentmenu"
        End If

    End Sub

    'Protected Sub logoutLink_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles logoutLink.Click
    '    Session("User") = Nothing
    '    Response.Redirect("~/Default.aspx")
    'End Sub
End Class
