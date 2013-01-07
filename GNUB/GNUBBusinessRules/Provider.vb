Public Class Provider

    Public Shared Function GetNumberOfChangedRecords(ByVal providerId As Guid, ByVal updateDate As DateTime) As Integer
        Dim cmd As New System.Data.SqlClient.SqlCommand("sprSelect_NumDiffProvRecords")
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("@providerId", SqlDbType.UniqueIdentifier).Value = providerId
        cmd.Parameters.Add("@updateDate", SqlDbType.DateTime).Value = updateDate
        cmd.Connection = New SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("GNUB").ConnectionString)
        cmd.Connection.Open()

        Dim val As Integer = cmd.ExecuteScalar()

        cmd.Connection.Close()

        Return val
    End Function

    Public Shared Function GetLastUpdate(ByVal providerId As Guid) As GNUBDataAccess.UpdateLog

        'update current status
        GetStatus(providerId)

        Dim gda As New GNUBDataAccess.GNUBAdminEntities
        Dim recs = From ul In gda.UpdateLog Where ul.Provider.ProviderID = providerId Select ul Order By ul.CompleteDate Descending

        If recs.Count > 0 Then
            Return recs.First
        Else
            Return Nothing
        End If
    End Function

    Public Shared Function GetLastSuccessfulUpdate(ByVal providerId As Guid) As GNUBDataAccess.UpdateLog

        'update current status
        GetStatus(providerId)

        Dim gda As New GNUBDataAccess.GNUBAdminEntities
        Dim recs = From ul In gda.UpdateLog Where ul.Provider.ProviderID = providerId And ul.Status = "Succeeded" Select ul Order By ul.CompleteDate Descending

        If recs.Count > 0 Then
            Return recs.First
        Else
            Return Nothing
        End If
    End Function

    Private Shared Function GetStatus(ByVal providerId As Guid) As String
        Dim st As String = ""

        Dim cmd As New System.Data.SqlClient.SqlCommand("sprSelect_UpdateStatus")
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("@providerId", SqlDbType.UniqueIdentifier).Value = providerId
        cmd.Connection = New SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("GNUB").ConnectionString)
        cmd.Connection.Open()

        st = cmd.ExecuteScalar.ToString

        cmd.Connection.Close()

        Return st
    End Function

    Public Shared Sub RunUpdate(ByVal providerId As Guid)
        Dim cmd As New System.Data.SqlClient.SqlCommand("sprRun_Update")
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("@providerId", SqlDbType.UniqueIdentifier).Value = providerId
        cmd.Connection = New SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("GNUB").ConnectionString)
        cmd.Connection.Open()
        cmd.ExecuteNonQuery()
        cmd.Connection.Close()
    End Sub

End Class
