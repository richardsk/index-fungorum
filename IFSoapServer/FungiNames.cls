VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "FungiNames"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const ConnectionString As String = "Provider=SQLOLEDB.1;Password=fred;Persist Security Info=True;User ID=dbi_user;Initial Catalog=IndexFungorum;Data Source=DEVSERVER01;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=DEV10;Use Encryption for Data=False;Tag with column collation when possible=False"


'test to see if there is a connection
Public Function IsAlive() As Boolean
    IsAlive = True
End Function

'search for a name
Public Function NameSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As ADODB.Recordset
    Dim rs As ADODB.Recordset
    
    Dim strAnyWhere As String
    If AnywhereInText = True Then
        strAnyWhere = "%"
    Else
        strAnyWhere = ""
    End If
    
    Dim QueryString As String
    QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM FUNINDEX WHERE [NAME OF FUNGUS] LIKE '" & strAnyWhere & SearchText & "%' ORDER BY [NAME OF FUNGUS] "
    
    Set rs = QueryDatabase(QueryString)

    Set NameSearch = rs
End Function

'search for an epithet
Public Function EpithetSearch(ByVal SearchText As String, ByVal AnywhereInText As Boolean, ByVal MaxNumber As Long) As ADODB.Recordset
    Dim rs As ADODB.Recordset

    Dim strAnyWhere As String
    If AnywhereInText = True Then
        strAnyWhere = "%"
    Else
        strAnyWhere = ""
    End If
    
    Dim QueryString As String
    QueryString = "SELECT TOP " & CStr(MaxNumber) & " * FROM FUNINDEX WHERE [INFRASPECIFIC EPITHET] LIKE '" & strAnyWhere & SearchText & "%' ORDER BY [NAME OF FUNGUS] "
    
    Set rs = QueryDatabase(QueryString)
   
    Set EpithetSearch = rs
End Function

'name by key
Public Function NameByKey(ByVal NameKey As Long) As ADODB.Recordset
    Dim rs As ADODB.Recordset
  
    Dim QueryString As String
    QueryString = "SELECT TOP 100 * FROM FUNINDEX WHERE [RECORD NUMBER] = " & CStr(NameKey) & "  ORDER BY [NAME OF FUNGUS] "
    
    Set rs = QueryDatabase(QueryString)

    Set NameByKey = rs
End Function

Private Function QueryDatabase(QueryString As String) As ADODB.Recordset
    Dim rs As ADODB.Recordset
    Set rs = CreateObject("ADODB.Recordset")
    
    Dim con As String
    
    rs.Open QueryString, ConnectionString, adOpenStatic
    
    Set QueryDatabase = rs
End Function
