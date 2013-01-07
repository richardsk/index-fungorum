Imports Microsoft.VisualBasic

Public Class Utility

    Public Shared Function GetUser() As GNUBDataAccess.User
        Dim u As GNUBDataAccess.User = Nothing
        Dim gda As New GNUBDataAccess.GNUBAdminEntities

        Dim ul As String = HttpContext.Current.Session("User")
        Dim uRes = From users In gda.User Where users.UserLogin.Equals(ul) Select users

        If uRes.Count > 0 Then u = uRes.First

        Return u
    End Function

    Public Shared Function ByteArraysEqual(ByVal b1 As Byte(), ByVal b2 As Byte()) As Boolean
        If b1 Is Nothing And b2 Is Nothing Then
            Return True
        End If

        If b1 Is Nothing AndAlso b2 IsNot Nothing Then
            Return False
        End If

        If b2 Is Nothing AndAlso b1 IsNot Nothing Then
            Return False
        End If

        If b2.Length <> b1.Length Then Return False

        For i As Integer = 0 To b1.Length - 1
            If b1(i) <> b2(i) Then Return False
        Next

        Return True
    End Function

End Class
