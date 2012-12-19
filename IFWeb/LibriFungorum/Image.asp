<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Libri Fungorum - Page Image</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--#include file="Connections/DataAccess.asp"-->
<!--#include file="Helpers/Utility.asp"-->
<script language="JavaScript">
function clickIE() {if (document.all) {(message);return false;}}
function clickNS(e) {if 
(document.layers||(document.getElementById&&!document.all)) {
if (e.which==2||e.which==3) {(message);return false;}}}
if (document.layers) 
{document.captureEvents(Event.MOUSEDOWN);document.onmousedown=clickNS;}
else{document.onmouseup=clickNS;document.oncontextmenu=clickIE;}

document.oncontextmenu=new Function("return false")
</script>
</head>
<body bgcolor="#CCCC99">
<%
dim intItemID, strImageFileName, strItemTitle, strImageURL, strSQL, dbConn, rs, rs1, intTotalPages, intFirstPage, intLastPage, intNextPage, strNav, strSource
	strNav = "no"
	if request.querystring("ItemID") <> "" then
		intItemID = request.querystring("ItemID")
		strImageFileName = request.querystring("ImageFileName")
	end if
	if request.querystring("Nav") <> "" then
		strNav = request.querystring("Nav")
		intFirstPage = request.querystring("FirstPage")
		intLastPage = request.querystring("LastPage")
		intNextPage = request.querystring("NextPage")	
	end if

	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.12" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_KIRK-WEBSERVER;Initial Catalog=LibriFungorum;Data Source=KIRK-WEBSERVER"
		dbConn.open strConn
	elseif strIP = "194.203.77.76" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=LibriFungorum;Data Source=EDWINBUTLER"
		dbConn.open strConn
	elseif strIP = "194.203.77.78" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=LibriFungorum;Data Source=EDWINBUTLER"
		dbConn.open strConn
	elseif strIP = "127.0.0.1" then
		strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\librifungorum\librifungorum.mdb"
		dbConn.open strConn
	else
		dbConn.open "FILEDSN=librifungorum"
	end if

' check if it's the first request or a Nav request
if strNav = "yes" then
' need to put in tblImages.ItemFK = strItemID to keep navigation to current item
	strSQL = "SELECT tblItems.*, tblImages.*, [tblImages].[ID] AS PageCounter1 " _
		& "FROM tblItems INNER JOIN tblImages ON [tblItems].[ID] = tblImages.ItemFK " _
		& "WHERE (([tblImages].[ID]) = " & protectSQL(intNextPage, true) & ");"
else
	strSQL = "SELECT tblItems.*, tblImages.*, [tblImages].[ID] AS PageCounter1 " _
		& "FROM tblItems INNER JOIN tblImages ON [tblItems].[ID] = tblImages.ItemFK " _
		& "WHERE (((tblImages.ItemFK) = " & protectSQL(intItemID, true) & ") AND ((tblImages.ImageFileName)= '" & protectSQL(strImageFileName, false) & "')) " _
		& "ORDER BY [tblImages].[ID];"
end if

	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if not rs.bof then
' find out how many records so navigation is possible
		if strNav = "no" then
			strSQL1 = "SELECT [tblImages].[ID] AS PageCounter2 " _
				& "FROM tblImages " _
				& "WHERE (((tblImages.ItemFK) = " & protectSQL(intItemID, true) & ")) " _
				& "ORDER BY [tblImages].[ID];"
			Set rs1 = Server.CreateObject("ADODB.Recordset")
			rs1.Open strSQL1, dbConn, 3
			rs1.movelast
			intLastPage = rs1("PageCounter2")
			rs1.movefirst
			intFirstPage = rs1("PageCounter2")
			rs1.close
			set rs1 = nothing
		end if
' get current page record
		intCurrentPage = rs("PageCounter1")
' get source data
		strSource = Strn(rs("Source"))
' put together image URL
		strData = strn(rs("BaseURL"))
		if strNav = "yes" then
			strData = strData & strn(rs("ImageFileName"))
		else
			strData = strData & strImageFileName
		end if
		strImageURL = "<img src='" & strData & "' width=657>"
' put together item details
		strData = strn(rs("Author"))
		if strData <> "" then
			strOut = encodeHtml(strData)
		else
			strData = strn(rs("UnitTitle"))
			if strData <> "" then
				strOut = encodeHtml(strData) & "."
			end if
		end if
		strData = strn(rs("ItemTitle"))
		if strData <> "" then
			strOut = strOut & " <i>" & encodeHtml(strData) & "</i>"
		end if
		strData = strn(rs("Page(s)"))
		if strData <> "" then
			strOut = strOut & ": " & encodeHtml(strData)
		end if
		strData = strn(rs("Year"))
		if strData <> "" then
			strOut = strOut & " (" & encodeHtml(strData) & ")"
		end if
		strItemTitle = "<b>" & strOut & "</b>"
	else
		response.write("No records found<br>")
	end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing

function strn(str)
	if isnull(str) then
		strn = ""
	else
		strn = str
	end if
end function
%>
<table width="100%">
  <tr> 
    <td colspan="3"> <%response.write(strItemTitle)%> </td>
    <td width="13%"><div align="right"><a href="javascript:window.close();"><font size="2">Close</font></a></div></td>
  </tr>
  <tr> 
    <td colspan="3"><div align="left"> 
        <%
if strSource <> "" then
	response.write(encodeHtml(strSource))
else
	response.write("&nbsp;")
end if
%>
      </div></td>
    <td><div align="right"><a href="http://www.LibriFungorum.org" target="_blank"><font size="2">Libri Fungorum</font></a></div></td>
  </tr>
  <tr> 
    <td width="20%"><div align="right"> 
        <%
if clng(intCurrentPage) < clng(intFirstPage) + 1 then 'at the start so no previous page
    response.write("&nbsp;")
else
	intPreviousPage = int(intCurrentPage) - 1
    response.write("<a href='Image.asp?Nav=yes&FirstPage=" & intFirstPage & "&LastPage=" & intLastPage & "&NextPage=" & intPreviousPage & "'>Previous Page</a>")
end if
%>
      </div></td>
    <td width="33%">&nbsp;</td>
    <td width="34%"><div align="left"> 
        <%
if clng(intCurrentPage) > clng(intLastPage) -1 then 'at the end so no next page
    response.write("&nbsp;")
else
	intNextPage = int(intCurrentPage) + 1
    response.write("<div align='right'><a href='Image.asp?Nav=yes&FirstPage=" & intFirstPage & "&LastPage=" & intLastPage & "&NextPage=" & intNextPage & "'>Next Page</a></div>")
end if
%>
      </div></td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="4"> <%response.write(strImageURL)%> </td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="right"> 
        <%
if clng(intCurrentPage) < clng(intFirstPage) + 1 then 'at the start so no previous page
    response.write("&nbsp;")
else
	intPreviousPage = int(intCurrentPage) - 1
    response.write("<a href='Image.asp?Nav=yes&FirstPage=" & intFirstPage & "&LastPage=" & intLastPage & "&NextPage=" & intPreviousPage & "'>Previous Page</a>")
end if
%>
      </div></td>
    <td>&nbsp;</td>
    <td><div align="left"> 
        <%
if clng(intCurrentPage) > clng(intLastPage) -1 then 'at the end so no next page
    response.write("&nbsp;")
else
	intNextPage = int(intCurrentPage) + 1
    response.write("<div align='right'><a href='Image.asp?Nav=yes&FirstPage=" & intFirstPage & "&LastPage=" & intLastPage & "&NextPage=" & intNextPage & "'>Next Page</a></div>")
end if
%>
      </div></td>
    <td>&nbsp;</td>
  </tr>
</table>
</body>
</html>
