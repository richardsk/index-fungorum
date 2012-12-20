Imports System.Data
Imports NameLiteratureSystemFrameworks

Public Class Form1
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents Button1 As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Button1 = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(104, 32)
        Me.Button1.Name = "Button1"
        Me.Button1.TabIndex = 0
        Me.Button1.Text = "Go"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(292, 273)
        Me.Controls.Add(Me.Button1)
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        InsertNameRecords()
    End Sub

    Private Sub InsertNameRecords()
        Dim ds As DataSet = IndexFungorumDataAccess.GetFungusRecords()
        Dim index As Integer = 0
        If ds.Tables.Count > 0 Then
            Dim names As New DsName
            For Each row As DataRow In ds.Tables(0).Rows
                If index > 14130 Then
                    Dim name As DsName.tblNameRow = names.tblName.NewtblNameRow()
                    name.NameCounter = row("RECORD NUMBER")
                    name.NameGuid = Guid.NewGuid().ToString
                    name.NameTaxonRankFk = GetTaxonRank(row)
                    name.NameFull = row("NAME OF FUNGUS").ToString
                    Dim canon As String = row("NAME OF FUNGUS").ToString
                    If name.NameTaxonRankFk = 24 Then
                        Dim i As Integer = canon.Trim.LastIndexOf(" ")
                        canon = canon.Substring(i + 1)
                    End If
                    name.NameCanonical = canon
                    name.NameAuthors = row("AUTHORS").ToString
                    If name.NameAuthors.Length > 255 Then name.NameAuthors = name.NameAuthors.Substring(0, 255)

                    name.NameMisapplied = (row("MISAPPLICATION AUTHORS").ToString.Length > 0)

                    name.NameIsAnamorph = False
                    name.NameSuppress = False
                    name.NameProParte = False
                    name.NameDubium = False
                    name.NameIllegitimate = False
                    name.NameAutonym = False
                    name.NameInCitation = False
                    name.NameInvalid = False
                    name.NameNovum = False

                    names.tblName.Rows.Add(name)
                End If
                index += 1
            Next

            Dim da As New NameLiteratureDataAccess.NameDataAccess
            Dim us As New SessionState
            us.UserKey = 1
            da.DaInitialise(us, "data source=devserver01;initial catalog=nuku_hk;password=fred;persist security info=True;user id=dbi_user;workstation id=DEV05;packet size=4096")
            da.UpdateNameDetails(True, names)

        End If
    End Sub

    Private Function GetTaxonRank(ByVal row As DataRow) As Integer
        Dim rankFk As Integer = -1
        Dim ifRank As String = row("INFRASPECIFIC RANK").ToString
        If ifRank = "" Then rankFk = 24 'species
        If ifRank.ToLower = "var." Or ifRank.ToLower = "[var.]" Then rankFk = 44 'variety
        If ifRank.ToLower = "f." Or ifRank.ToLower = "[f.]" Then rankFk = 5
        If ifRank.ToLower = "subsp." Then rankFk = 35
        If ifRank.ToLower = "f.sp." Then rankFk = 6
        If ifRank.ToLower = "subvar." Then rankFk = 37
        If ifRank = "α" Then rankFk = 45
        If ifRank = "β" Then rankFk = 25
        If ifRank = "γ" Then rankFk = 46
        If ifRank = "δ" Then rankFk = 47
        If ifRank = "ε" Then rankFk = 49
        If ifRank = "θ" Then rankFk = 50
        If ifRank = "μ" Then rankFk = 51
        If ifRank = "φ" Then rankFk = 52
        If ifRank = "(a.)" Then rankFk = 53
        If ifRank = "(b.)" Then rankFk = 54
        If ifRank = "(c.)" Then rankFk = 55
        If ifRank = "(d.)" Then rankFk = 56
        If ifRank = "(e.)" Then rankFk = 57
        If ifRank = "(g.)" Then rankFk = 58
        If ifRank = "a." Then rankFk = 59
        If ifRank = "b." Then rankFk = 60
        If ifRank = "c." Then rankFk = 61
        If ifRank = "d." Then rankFk = 62
        If ifRank = "e." Then rankFk = 63
        If ifRank = "g." Then rankFk = 64
        If ifRank = "*" Then rankFk = 65
        If ifRank = "**" Then rankFk = 66
        If ifRank = "****" Then rankFk = 67
        If ifRank = "B" Then rankFk = 68
        If ifRank = "mut." Then rankFk = 69
        If ifRank = "race" Then rankFk = 70
        If ifRank = "ser." Then rankFk = 71
        If ifRank = "subf." Then rankFk = 72
        If ifRank = "subsubf." Then rankFk = 73
        If ifRank = "tax.vag." Then rankFk = 74

        Return rankFk
    End Function
End Class
