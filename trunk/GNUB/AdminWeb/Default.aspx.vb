
Partial Class _Default
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'debugging
        'Session("User") = "richardsk"
        'GNUBBusinessRules.Admin.AddUser(New Guid("7177617c-a7dc-4726-a6bf-6cba0ee5ea81"), "richardsk", "richardsk", "richardsk@landcareresearch.co.nz", False) '

        If HttpContext.Current.User.Identity.IsAuthenticated Then
            Session("User") = HttpContext.Current.User.Identity.Name

            DisplayHeader()

            Dim tab As String = Request.QueryString.Get("tab")
            If tab Is Nothing Then tab = "home"
            tab = tab.ToLower

            Dim amp As AdminMasterPage = Master

            If tab.ToLower = "home" Then
                Dim ctrl As UserControl = LoadControl("Controls/HomeControl.ascx")
                amp.MainPlaceholder.Controls.Add(ctrl)
            ElseIf tab.ToLower.StartsWith("updateprovider") Then
                Dim ctrl As UserControl = LoadControl("Controls/UpdateControl.ascx")
                amp.MainPlaceholder.Controls.Add(ctrl)
            ElseIf tab.ToLower.StartsWith("provsearch") Then
                Dim ctrl As UserControl = LoadControl("Controls/ProvSearchControl.ascx")
                amp.MainPlaceholder.Controls.Add(ctrl)
            ElseIf tab.ToLower.StartsWith("gnubsearch") Then
                Dim ctrl As UserControl = LoadControl("Controls/GnubSearchControl.ascx")
                amp.MainPlaceholder.Controls.Add(ctrl)
            ElseIf tab.ToLower.StartsWith("editprovider") Then
                Dim ctrl As UserControl = LoadControl("Controls/ProviderControl.ascx")
                amp.MainPlaceholder.Controls.Add(ctrl)
            ElseIf tab.ToLower.StartsWith("display") Then
                Dim ctrl As UserControl = LoadControl("Controls/TNUControl.ascx")
                amp.MainPlaceholder.Controls.Add(ctrl)
            End If
        Else
            DisplayLoginHeader()

            Dim ctrl As UserControl = LoadControl("Controls/LoginControl.ascx")
            Dim amp As AdminMasterPage = Master
            amp.MainPlaceholder.Controls.Add(ctrl)

        End If
    End Sub


    Private Sub DisplayHeader()
        Dim ctrl As UserControl = LoadControl("Controls/HeaderControl.ascx")
        Dim amp As AdminMasterPage = Master
        amp.MenuPlaceholder.Controls.Add(ctrl)
    End Sub

    Private Sub DisplayLoginHeader()
        Dim ctrl As UserControl = LoadControl("Controls/LoginHeaderControl.ascx")
        Dim amp As AdminMasterPage = Master
        amp.MenuPlaceholder.Controls.Add(ctrl)
    End Sub

End Class
