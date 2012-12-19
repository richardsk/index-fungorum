<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - template</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=705,height=650,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<link href="StyleIXF.css" rel="stylesheet" type="text/css">
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
          <td valign="top"> <table height="100%" align="center">
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
                  Fungorum Partnership</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/Acknowledge.htm") onMouseOver="MM_displayStatusMsg('Acknowledgements');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Acknowledgements</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/IndexFungorum.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help 
                  with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Names/AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Names/Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Index Fungorum</a></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr class="mainbody"> 
          <td><table width="100%" border="0" align="center" cellpadding="0" cellspacing="5" class="mainbody">
              <tr> 
                <td valign="top"> <div align="center"> </div>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr bordercolor="#993399" class="mainbody"> 
                      <td valign="top" nowrap> <div align="center"> 
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
		strTemp = "<A HREF=" & strPath & objItem.Name & "><img src=" & strPath & objItem.Name & " width='40' height='40' border='0'></A>"
	else
		strTemp = "<IMG SRC=""./images/dir_" & strTemp & ".gif"" WIDTH=16 HEIGHT=16 BORDER=0>"
	end if
	ShowImageForType = strTemp
End Function

Dim strPath   'Path of directory to show
Dim objFSO    'FileSystemObject variable
Dim objFolder 'Folder variable
Dim objItem   'Variable used to loop through the contents of the folder

Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
Set objFolder = objFSO.GetFolder(Server.MapPath("WebStats"))

%>
	</div>
	                    <TABLE width="100%" BORDER="1" align="center" CELLPADDING="0" CELLSPACING="1" bordercolor="#FFF7E7" class="mainbody">
                          <%
For Each objItem In objFolder.SubFolders
If InStr(1, objItem, "_vti", 1) = 0 Then
	%>
                          <TR> 
                            <TD width="40%" ALIGN="left" ><%= ShowImageForType("dir")%>&nbsp;<A HREF="WebStats/<%response.write(Topic)%><%If Topic <> "" then response.write ("/") End If%><%= objItem.Name %>/"><%= objItem.Name %></A></TD>
                            <TD width="20%" ALIGN="right"><%= objItem.Size%></TD>
                            <TD width="20%" ALIGN="left" ><div align="right"><%= objItem.DateCreated %></div></TD>
                            <TD width="20%" ALIGN="left" ><div align="right"><%= objItem.Type %></div></TD>
                          </TR>
                          <%
	End If
Next
For Each objItem In objFolder.Files
%>
                          <%
Next
Set objItem = Nothing
Set objFolder = Nothing
Set objFSO = Nothing
%>
                        </TABLE>
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
          <td>&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade> &copy; 2005 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
</body>
</html>
