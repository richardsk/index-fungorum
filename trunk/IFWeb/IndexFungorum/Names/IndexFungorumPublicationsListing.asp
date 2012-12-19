<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Publications Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript">
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
//-->
</script>
<script type="text/javascript">
<!--
var d = new Date();
var curr_year = d.getFullYear();
//-->
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum 
            - published numbers</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="80%" cellpadding="5">
        <tr> 
          <td>
                  <table width="80%" align="center" height="100%" border="0" cellpadding="0" cellspacing="10" class="mainbody">
                    <tr> 
                      <td><table width="80%" border="1" align="center" cellpadding="0" cellspacing="5" bordercolor="#FFF7E7"  class="mainbody">
                          <tr> 
                            <td height="12" bordercolor="#000000" bgcolor="#5A7DDE"> 
                              <div align="center">Index Fungorum Publications</div></td>
                          </tr>
                          <tr> 
                            <td height="12"> <img src="../images/dirlist/dir_diropen.gif" width="16" height="13"> 
                              <%= Request.ServerVariables("SERVER_NAME")%>/IndexFungorum/Publications/<%response.write(request.querystring.item("ID"))%></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td><table width="100%" border="0" align="center" cellpadding="0" cellspacing="5" class="mainbody">
                          <tr> 
                            <td valign="top" align="center"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr bordercolor="#993399" class="mainbody"> 
                                  <td valign="top" align="center" nowrap> 
                                      <%
Function ShowImageForType(strName)
	Dim strTemp
	strTemp = strName
	If strTemp <> "dir" Then
		strTemp = LCase(Right(strTemp, Len(strTemp) - InStrRev(strTemp, ".", -1, 1)))
	End If
	Select Case strTemp
		Case "asp"
			strTemp = "asp"
		Case "dir"
			strTemp = "dir"
		Case "htm", "html"
			strTemp = "htm"
		Case "gif", "jpg", "jpeg"
			strTemp = "img"
		Case "txt"
			strTemp = "txt"
		Case "zip"
			strTemp = "zip"
		Case "mdb"
			strTemp = "mdb"
		Case "doc"
			strTemp = "doc"
		Case "ppt", "pps"
			strTemp = "ppt"
		Case "xls"
			strTemp = "xls"
		Case "pdf"
			strTemp = "pdf"
		Case "pub"
			strTemp = "pub"
		Case "exe"
			strTemp = "exe"
		Case "mpg", "mpeg"
			strTemp = "mpg"
		Case "avi"
			strTemp = "avi"
		Case "wav", "mp3"
			strTemp = "snd"
		Case Else
			strTemp = "misc"
	End Select

	if strTemp = "img" then
		strTemp = "<a href=" & strPath & objItem.Name & "><img src=" & strPath & objItem.Name & " width='40' height='40' border='0'></a>"
	else
		strTemp = "<img src=""../images/dirlist/dir_" & strTemp & ".gif"" width=16 height=16 border=0>"
	end if
	ShowImageForType = strTemp
End Function

Dim strPath   'Path of directory to show
Dim objFSO    'FileSystemObject variable
Dim objFolder 'Folder variable
Dim objItem   'Variable used to loop through the contents of the folder

Topic = request.querystring.item("ID")
	strIP = request.servervariables("LOCAL_ADDR")
if Topic <> "" then
	if strIP = "10.0.5.10" then
		strPath = "/Publications/" & Topic & "/" 
	elseif strIP = "10.0.5.4" then
		strPath = "/Publications/" & Topic & "/" 
	elseif strIP = "83.244.173.37" then
		strPath = "/Publications/" & Topic & "/" 
	elseif strIP = "192.168.0.12" then
		strPath = "/IndexFungorum/Publications/" & Topic & "/" 
	else
		strPath = "/Publications/" & Topic & "/" 
	end if
Else
	if strIP = "10.0.5.10" then
		strPath = "/Publications/"
	elseif strIP = "10.0.5.4" then
		strPath = "/Publications/"
	elseif strIP = "83.244.173.37" then
		strPath = "/Publications/"
	elseif strIP = "192.168.0.12" then
		strPath = "/IndexFungorum/Publications/"
	else
		strPath = "/Publications/"
	end if
End if
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))
%>
                                    <table width="80%" border="1" align="center" cellpadding="0" cellspacing="1" bordercolor="#FFF7E7" class="mainbody">
                                      <tr bgcolor="E7DEC9"> 
                                        <td width="40%" bordercolor="#000000"> 
                                          <div align="center">File Name</div></td>
                                        <td width="20%" bordercolor="#000000"> 
                                          <div align="center">File Size (bytes)</div></td>
                                        <td width="25%" bordercolor="#000000"> 
                                          <div align="center">Date Created</div></td>
                                        <td width="15%" bordercolor="#000000"> 
                                          <div align="center">File Type</div></td>
                                      </tr>
                                      <tr> 
                                        <td align="center">&nbsp;<% If Topic <> "" then response.write("<a href='javascript:history.go(-1)'>[To Parent Directory]</a> - <A HREF='IndexFungorumPublicationsListing.asp'>[Top Level]</a>") End If %> </td>
                                        <td align="right">&nbsp;</TD>
                                        <td align="left" >&nbsp;</TD>
                                        <td align="left" >&nbsp;</TD>
                                      </tr>
                                      <%
For Each objItem In objFolder.SubFolders
If InStr(1, objItem, "_vti", 1) = 0 Then
	%>
                                      <tr> 
                                        <td width="40%" align="left" ><%= ShowImageForType("dir") %>&nbsp;<a href="IndexFungorumPublicationsListing.asp?ID=<%response.write(Topic)%><%If Topic <> "" then response.write ("/") End If%><%= objItem.Name %>"><%= objItem.Name %></a></td>
                                        <td width="20%" align="right"><%= objItem.Size%></td>
                                        <td width="25%" align="left" ><div align="right"><%= objItem.DateCreated %></div></td>
                                        <td width="15%" align="left" ><div align="right"><%= objItem.Type %></div></td>
                                      </tr>
                                      <%
	End If
Next
For Each objItem In objFolder.Files
%>
                                      <tr> 
                                        <td width="40%" align="left" >
										
										<%= ShowImageForType(objItem.Name) %>&nbsp;
										<a href="<%= strPath & objItem.Name %>"><%= objItem.Name %></a>
										</td>
                                        <td width="20%" align="right"><%= objItem.Size%></td>
                                        <td width="25%" align="left" ><div align="right"><%= objItem.DateCreated %></div></td>
                                        <td width="15%" align="left" ><div align="right"><%= objItem.Type %></div></td>
                                      </tr>
                                      <%
Next
Set objItem = Nothing
Set objFolder = Nothing
Set objFSO = Nothing
%>
                                    </table>
                                    <div align="center"></div>
                                    <div align="center"></div>
                                    <div align="center"></div>
                                    <div align="center"></div></td>
                                </tr>
                              </table></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr>
                      <td><table width="80%" border="1" align="center" cellpadding="0" cellspacing="5" bordercolor="#FFF7E7"  class="mainbody">
                          <tr> 
                            <td height="12"> Free space on Drive: 
                              <%
Set fso = CreateObject("Scripting.FileSystemObject")
	'get drive letter for each server ... mighe be bale to use this code
			'	set fs=Server.CreateObject("Scripting.FileSystemObject")
			'	set d=fs.GetDrive("c:")
'				Response.Write("The drive letter is: " & d.driveletter)
	strIP = request.servervariables("LOCAL_ADDR")
	if strIP = "10.0.5.10" then
		Set driveObject = fso.GetDrive("D")
	elseif strIP = "10.0.5.4" then
		Set driveObject = fso.GetDrive("D")
	elseif strIP = "192.168.0.12" then
		Set driveObject = fso.GetDrive("E")
	else
		Set driveObject = fso.GetDrive("D")
	end if

Response.Write FormatNumber(driveObject.AvailableSpace / 1024000 / 1024000) & "TB" ' 1024 bytes in a Kilobyte

Set driveObject = Nothing
Set fso = Nothing
%>
                            </td>
                          </tr>
                        </table></td>
                    </tr>
                  </table>
		  </td>
        </tr>
      </table> 
    </td>
  </tr>
</table>
<a name="BottomOfPage"></a> 
</body>
</html>
