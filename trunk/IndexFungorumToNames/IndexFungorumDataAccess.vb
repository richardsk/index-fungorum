Imports System.Data
Imports System.Data.OleDb

Public Class IndexFungorumDataAccess

    Private Shared m_CnnStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=" + _
                "c:\temp\db1.mdb" + _
                ";Mode=Share Deny None;Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False"

    Public Shared Function GetFungusRecords() As DataSet
        Dim ds As New DataSet
        Dim cnn As OleDbConnection

        Try
            cnn = New OleDbConnection(m_CnnStr)
            cnn.Open()

            Dim cmdStr As String = "select * from IndexFungorum"
            Dim cmd As New OleDbCommand(cmdStr)
            cmd.Connection = cnn

            Dim da As New OleDbDataAdapter(cmd)
            da.Fill(ds)
        Catch ex As Exception
            MsgBox(ex.Message)
        Finally
            cnn.Close()
        End Try

        Return ds
    End Function
End Class
