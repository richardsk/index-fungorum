<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>PDF</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<%@ Language=VBScript %>
<% Response.Buffer = true%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<%
'
'	Retrieve the user responses
'
FirstName = Request.form("txtFirstName")
MI = Request.form("txtMI")
LastName = Request.form("txtLastName")
SS1 = Request.form("txtSocial1")
SS2 = Request.form("txtSocial2")
SS3 = Request.form("txtSocial3")
StreetAddress = Request.form("txtStreetAddress")
City = Request.form("txtCity")
State = Request.form("txtState")
Zip = Request.form("txtZip")
FilingStatus = Request.form("radFilingStatus")
Allowances = Request.form("txtAllowances")
Additional = Request.form("txtAdditional")
Exempt = Request.form("chkExempt")
If Exempt = "on" Then
	Exempt = "EXEMPT"
Else
	Exempt = ""
End If

FirstName = "txtFirstName"
MI = "txtMI"
LastName = "txtLastName"
SS1 = "txtSocial1"
SS2 = "txtSocial2"
SS3 = "txtSocial3"
StreetAddress = "txtStreetAddress"
City = "txtCity"
State = "txtState"
Zip = "txtZip"
FilingStatus = "1"
Allowances = "txtAllowances"
Additional = "txtAdditional"
Exempt = "chkExempt"





'
'	Create an instance of the Object
'
Set FdfAcx = Server.CreateObject("FdfApp.FdfApp")
'
' 	Use the fdfApp to feed the vars
'
Set myFdf = FdfAcx.FDFCreate
'
'	Stuff the variables
'
myFdf.fdfsetvalue "FirstName", FirstName, false
myFdf.fdfsetvalue "MI", MI, false
myFdf.fdfsetvalue "LastName", LastName, false
myFdf.fdfsetvalue "SS1", SS1, false
myFdf.fdfsetvalue "SS2", SS2, false
myFdf.fdfsetvalue "SS3", SS3, false
myFdf.fdfsetvalue "StreetAddress", StreetAddress, false
myFdf.fdfsetvalue "City", City, false
myFdf.fdfsetvalue "State", State, false
myFdf.fdfsetvalue "Zip", Zip, false
If FilingStatus = 1 Then
	MyFdf.fdfsetValue "StatusSingle", "X", false
End If
If FilingStatus = 2 Then
	MyFdf.fdfsetValue "StatusMarried", "X", false
End If
If FilingStatus = 3 Then
	MyFdf.fdfsetValue "MarriedBut", "X", false
End If
myFdf.fdfsetvalue "Allowances", Allowances, false
myFdf.fdfsetvalue "Additional", Additional, false
myFdf.fdfsetvalue "Exempt", Exempt, false
'
'	Point to your pdf file
'
myFDF.fdfSetFile "http://www.servername.com/workorder/w4.pdf"
Response.ContentType = "text/html"
'
'	Save it to a file.  If you were going to save the actual file past the point of printing
'	You would want to create a naming convention (perhaps using social in the name)
'	Have to use the physical path so you may need to incorporate Server.mapPath in 
'	on this portion.
'
myFDf.FDFSaveToFile Server.MapPath("CheckThis.pdf")
'myFDf.FDFSaveToFile "C:\inetpub\wwwroot\workorder\CheckThis.fdf"
' Now put a link to the file on your page. 
Response.Write "<a href=http://94.172.195.133/Indexfungorum/Names/CheckThis.pdf>pdf</A>"
'
'	Close your Objects
'
myfdf.fdfclose
set fdfacx = nothing
%>


</body>
</html>
