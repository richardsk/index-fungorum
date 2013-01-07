
Partial Class AdminMasterPage
    Inherits System.Web.UI.MasterPage

    Public Property MenuPlaceholder() As ContentPlaceHolder
        Get
            Return tblHeader
        End Get
        Set(ByVal value As ContentPlaceHolder)
            tblHeader = value
        End Set
    End Property

    Public Property MainPlaceholder() As ContentPlaceHolder
        Get
            Return tblMain
        End Get
        Set(ByVal value As ContentPlaceHolder)
            tblMain = value
        End Set
    End Property
End Class

