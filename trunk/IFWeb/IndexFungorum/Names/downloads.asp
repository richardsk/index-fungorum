<%
If Session("loggedin") <> True Then Response.Redirect "login.asp"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><!-- InstanceBegin template="/Templates/template.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" --> 
<title>KIRK_NET Intranet</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="stylesheets/stylesheet.css" rel="stylesheet" type="text/css">
<script>
<!--
self.moveTo(0,0);self.resizeTo(screen.availWidth,screen.availHeight);
//-->

function onSubmitForm() {
    var formDOMObj = document.frmSend;
    if (formDOMObj.attach1.value == "" && formDOMObj.attach2.value == "" && formDOMObj.attach3.value == "" && formDOMObj.attach4.value == "" )
        alert("Please press the browse button and pick a file.")
    else
        return true;
    return false;
}

</script>
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>

<body>

<script language="JavaScript1.2">

/*
Full Screen Window
Submitted by Paul Deron (paul1.web.com)
To add more shock to your site, visit www.DHTML Shock.com
*/

<!-- Begin
function fullScreen(theURL) {
window.open(theURL, '', 'fullscreen=yes, scrollbars=auto');
}
//  End -->
</script>
<script language="JavaScript">
<!--

function mOvr(src,clrOver){ 
	if (!src.contains(event.fromElement)){ 
		src.style.cursor = 'hand'; 
		src.bgColor = clrOver; 
	} 
} 
function mOut(src,clrIn){ 
	if (!src.contains(event.toElement)){ 
		src.style.cursor = 'default'; 
		src.bgColor = clrIn; 
	} 
}
function mClk(src){ 
	if(event.srcElement.tagName=='TD')
		src.children.tags('A')[0].click();
}
//-->
</script>
<SCRIPT language=JavaScript>
	/*
		Milonic DHTML Website Navigation Menu
		Written by Andy Woolley
		Copyright 2002 (c) Milonic Solutions Ltd. All Rights Reserved.
		Plase vist http://www.milonic.co.uk/menu/ or e-mail menu3@milonic.com
		You may use this menu on your web site  free of charge as long as you 
		place prominent links to http://www.milonic.co.uk/menu and you inform 
		us of your intentions with your URL  AND ALL copyright notices remain 
		in place in all files including your home page.
		Comercial support contracts are available on request if you cannot comply with the above rules.		
	*/
	</SCRIPT>
<SCRIPT language=JavaScript src="menu_array.js" type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript src="mmenu.js" type=text/javascript></SCRIPT>
<%username = request.cookies("username")%>
<%password = request.cookies("password")%>
<table width="100%" height="100%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="30"> <table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" class="mainbody">
        <tr> 
          <td width="4"><img src="Images/Frame_ulcorn.gif" width="4" height="30"></td>
          <td background="Images/Frame_uc.gif"> <div align="left"><font color="#FFFF63" size="3" face="Arial, Helvetica, sans-serif"><b>KIRK_NET 
              Intranet</b></font></div></td>
          <td width="200" nowrap background="Images/Frame_uc.gif"><font color='#FFFF63'>Logged 
            in as: <%=username%></font></td>
          <td width="135" align="right" valign="middle" nowrap background="Images/Frame_uc.gif"> 
            <%response.write("<font color='#FFFF63'>Date: " & date()) & "</font>"%> &nbsp; </td>
          <td width="4"><img src="Images/Frame_urcorn.gif" width="4" height="30"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td> <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="mainbody">
        <tr> 
          <td background="Images/Frame_lb.gif">&nbsp;</td>
          <td valign="top" bgcolor="#FFF7E7">&nbsp;</td>
          <td background="Images/Frame_rb.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="4" background="Images/Frame_lb.gif">&nbsp;</td>
          <td valign="top" bgcolor="#FFF7E7"><table width="100%" border="0" cellspacing="0" cellpadding="10" class="mainbody">
              <tr> 
                <td><!-- InstanceBeginEditable name="main" --> 
                  <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="10" class="mainbody">
                    <tr> 
                      <td><table width="100%" border="1" align="center" cellpadding="0" cellspacing="5" bordercolor="#FFF7E7"  class="mainbody">
                          <tr> 
                            <td height="12" bordercolor="#000000" bgcolor="#5A7DDE"> 
                              <div align="center"> DOWNLOADS AREA</div></td>
                          </tr>
                          <tr> 
                            <td height="12"> <img src="images/dirlist/dir_diropen.gif" width="16" height="13"> 
                              <%= Request.ServerVariables("SERVER_NAME")%>/Downloads/<%response.write(request.querystring.item("ID"))%></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
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
		strTemp = "<IMG SRC=""../images/dirlist/dir_" & strTemp & ".gif"" WIDTH=16 HEIGHT=16 BORDER=0>"
	end if
	ShowImageForType = strTemp
End Function

Dim strPath   'Path of directory to show
Dim objFSO    'FileSystemObject variable
Dim objFolder 'Folder variable
Dim objItem   'Variable used to loop through the contents of the folder

Topic = request.querystring.item("ID")
if Topic <> "" then
	strPath = "\Downloads\" & Topic & "\"
Else
	strPath = "\Downloads"
End if
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))

%>
                                    </div>
                                    <TABLE width="100%" BORDER="1" align="center" CELLPADDING="0" CELLSPACING="1" bordercolor="#FFF7E7" class="mainbody">
                                      <TR bgcolor="E7DEC9"> 
                                        <TD width="40%" bordercolor="#000000"> 
                                          <div align="center">File Name</div></TD>
                                        <TD width="20%" bordercolor="#000000"> 
                                          <div align="center">File Size (bytes)</div></TD>
                                        <TD width="20%" bordercolor="#000000"> 
                                          <div align="center">Date Created</div></TD>
                                        <TD width="20%" bordercolor="#000000"> 
                                          <div align="center">File Type</div></TD>
                                      </TR>
                                      <TR> 
                                        <TD ALIGN="Center" > <% If Topic <> "" then response.write("<A HREF='javascript:history.go(-1)'>[To Parent Directory]</A> - <A HREF='Downloads.asp'>[Top Level]</A>") End If %> </TD>
                                        <TD ALIGN="right">&nbsp;</TD>
                                        <TD ALIGN="left" >&nbsp;</TD>
                                        <TD ALIGN="left" >&nbsp;</TD>
                                      </TR>
                                      <%
For Each objItem In objFolder.SubFolders
If InStr(1, objItem, "_vti", 1) = 0 Then
	%>
                                      <TR> 
                                        <TD width="40%" ALIGN="left" ><%= ShowImageForType("dir") %>&nbsp;<A HREF="downloads.asp?ID=<%response.write(Topic)%><%If Topic <> "" then response.write ("/") End If%><%= objItem.Name %>"><%= objItem.Name %></A></TD>
                                        <TD width="20%" ALIGN="right"><%= objItem.Size%></TD>
                                        <TD width="20%" ALIGN="left" ><div align="right"><%= objItem.DateCreated %></div></TD>
                                        <TD width="20%" ALIGN="left" ><div align="right"><%= objItem.Type %></div></TD>
                                      </TR>
                                      <%
	End If
Next
For Each objItem In objFolder.Files
%>
                                      <TR> 
                                        <TD width="40%" ALIGN="left" >
										
										<%= ShowImageForType(objItem.Name) %>&nbsp;
										<A HREF="<%= strPath & objItem.Name %>"><%= objItem.Name %></A>
										</TD>
                                        <TD width="20%" ALIGN="right"><%= objItem.Size%></TD>
                                        <TD width="20%" ALIGN="left" ><div align="right"><%= objItem.DateCreated %></div></TD>
                                        <TD width="20%" ALIGN="left" ><div align="right"><%= objItem.Type %></div></TD>
                                      </TR>
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
                      <td><table width="100%" border="1" align="center" cellpadding="0" cellspacing="5" bordercolor="#FFF7E7"  class="mainbody">
                          <tr> 
                            <td height="12"> Free space on Drive: 
                              <%
Set fso = CreateObject("Scripting.FileSystemObject")
Set driveObject = fso.GetDrive("E")

Response.Write FormatNumber(driveObject.AvailableSpace / 1024000 / 1024000) & "TB" ' 1024 bytes in a Kilobyte

Set driveObject = Nothing
Set fso = Nothing
%>
                            </td>
                          </tr>
                        </table></td>
                    </tr>
                  </table>
                  <!-- InstanceEndEditable --></td>
              </tr>
            </table></td>
          <td width="4" background="Images/Frame_rb.gif">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="30"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="5"><img src="Images/Frame_dlcorn.gif" width="5" height="29"></td>
          <td background="Images/Frame_dc.gif">
            <div align="center"><span class="copyright">&copy; Copyright 2003 
              JPK Web Designs. All rights reserved. :: designed by <a href="http://www.JPKWebDesigns.co.uk" target="_blank" class="copyright" >JPK 
              Web Designs</a></span></div></td>
          <td width="4"><img src="Images/Frame_drcorn.gif" width="4" height="29"></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
