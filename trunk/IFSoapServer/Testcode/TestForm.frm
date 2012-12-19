VERSION 5.00
Begin VB.Form TestForm 
   Caption         =   "Form1"
   ClientHeight    =   5055
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5715
   LinkTopic       =   "Form1"
   ScaleHeight     =   5055
   ScaleWidth      =   5715
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtMax 
      BeginProperty DataFormat 
         Type            =   0
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   5129
         SubFormatType   =   0
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Text            =   "10"
      Top             =   3240
      Width           =   855
   End
   Begin VB.CommandButton cmdNameSearch 
      Caption         =   "Name Search"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   1320
      Width           =   1695
   End
   Begin VB.TextBox txtSearch 
      Height          =   375
      Left            =   0
      TabIndex        =   5
      Top             =   0
      Width           =   5535
   End
   Begin VB.CommandButton cmdInitialise 
      Caption         =   "Initialise"
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   1695
   End
   Begin VB.CommandButton cmdEpithetSearch 
      Caption         =   "Epithet Search"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   1800
      Width           =   1695
   End
   Begin VB.CommandButton cmdIsAlive 
      Caption         =   "Is Alive"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   2760
      Width           =   1695
   End
   Begin VB.CommandButton cmdNameByKey 
      Caption         =   "Name By Key"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   2280
      Width           =   1695
   End
   Begin VB.ListBox List1 
      Height          =   3960
      Left            =   1920
      TabIndex        =   0
      Top             =   600
      Width           =   3495
   End
End
Attribute VB_Name = "TestForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mFungiAccess As CabiSoapServer.FungiNames



Private Sub Form_Load()
    Set mFungiAccess = CreateObject("CabiSoapServer.FungiNames")
End Sub


Private Sub OutputRecordset(ByVal rs As Recordset)

    List1.Clear

    If rs Is Nothing Then Exit Sub
    
    If rs.State = adStateClosed Then Exit Sub
    
    While rs.EOF = False
        Dim strName As String
        strName = rs![NAME OF FUNGUS] & "  -   " & rs![RECORD NUMBER]
        List1.AddItem strName
        rs.MoveNext
    Wend

End Sub

Private Sub cmdInitialise_Click()
    'mFungiAccess.ConnectionInitalise
End Sub

Private Sub cmdNameSearch_Click()
    Dim rs As ADODB.Recordset
    Set rs = mFungiAccess.NameSearch(txtSearch.Text, False, Val(txtMax.Text))
    OutputRecordset rs
End Sub

Private Sub cmdEpithetSearch_Click()
    Dim rs As ADODB.Recordset
    Set rs = mFungiAccess.EpithetSearch(txtSearch.Text, False, Val(txtMax.Text))
    OutputRecordset rs
End Sub

Private Sub cmdNameByKey_Click()
    Dim rs As ADODB.Recordset
    Set rs = mFungiAccess.NameByKey(Val(txtSearch.Text))
    OutputRecordset rs
End Sub

Private Sub cmdIsAlive_Click()
    MsgBox mFungiAccess.IsAlive()
End Sub


