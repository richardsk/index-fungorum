Module Module1

    Sub Main()
        Try
            Dim dt As DateTime
            Dim dtStr As String = Configuration.ConfigurationManager.AppSettings.Get("LastUpdateDate")

            If Not DateTime.TryParse(dtStr, dt) Then dt = DateTime.MinValue

            Dim lastDt As DateTime = GNUBBusinessRules.TaxonNameUsage.GetLastModifiedDate()

            If dt <= lastDt Then
                Dim folder As String = System.Configuration.ConfigurationManager.AppSettings.Get("csvFolder")

                For Each f As String In IO.Directory.GetFiles(folder, "*.csv")
                    IO.File.Delete(f)
                Next

                Dim csvFile As String = GNUBBusinessRules.TaxonNameUsage.GetAllTNUDwC(folder, DateTime.MinValue)

                Dim c As New AMS.Profile.Config
                c.GroupName = Nothing
                c.SetValue("appSettings", "LastUpdateDate", DateTime.Now)
            End If
        Catch ex As Exception
            EventLog.WriteEntry("Application", "Failed to update GNUB dump file : " + ex.Message + " : " + ex.StackTrace)
        End Try

    End Sub

End Module
