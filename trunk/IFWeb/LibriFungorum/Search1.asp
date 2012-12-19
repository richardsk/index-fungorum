<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/TemplLF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Libri Fungorum - Search</title>
<!-- InstanceEndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<link href="StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="Connections/DataAccess.asp"-->
<!--#include file="Helpers/Utility.asp"-->
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCC99">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="IMAGES/LogoLF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Libri&nbsp;Fungorum</td>
          <td valign="top"> <table height="100%" align="center">
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("./html/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
                  Fungorum Partnership</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("./html/Acknowledgements.htm") onMouseOver="MM_displayStatusMsg('Acknowledgements');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Acknowledgements</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("./html/help.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help 
                  with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Search.asp" onMouseOver="MM_displayStatusMsg('Search Libri Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Libri Fungorum</a></td>
              </tr>
              <tr class="mainbody"> 
                <td>&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
        </tr>
      </table>
      
    </td>
  </tr>
  <tr>
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr>
          <td><!-- InstanceBeginEditable name="head" -->
<%
dim strItemID, strItemType, intPageNumber, intNumRecords, intPageSize, intPageCount
	intPageSize = 4
	strItemType = session("strItemType")
	strItemID = session("strItemID")
	if request.querystring.item("ItemType") <> "" then
		strItemType = request.querystring.item("ItemType")
		session("strItemType") = strItemType
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
	elseif request.querystring.item("ItemID") <> "" then
		strItemID = request.querystring.item("ItemID")
		session("strItemID") = strItemID
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
	else
		response.write("<p>Type of Resource:</p>")
		response.write("<p><a href='Search1.asp?ItemType=B'>Books</a></p>")
		response.write("<p><a href='Search1.asp?ItemType=J'>Journals</a></p>")
		response.write("<p><a href='Search1.asp?ItemType=T'>Thesauri</a></p>")
		response.write("<p><a href='Search1.asp?ItemType=I'>Indexes</a></p>")
		response.write("<p><a href='Search1.asp?ItemType=M'>Miscellaneous</a><br>")
		response.write("</p>")
	end if

sub GetNav
	select case request.querystring("pg")
		case "-1"
			intPageNumber = intPageNumber - 1
		case "+1"
			intPageNumber = intPageNumber + 1
		case else
			intPageNumber = request.querystring("pg")
	end select
	if intPageNumber = "" then intPageNumber = "1"
end sub

sub NavForm
	dim i, frm
	if intPageCount <> "" then
		frm  = "Search1"
		response.write("<p><b>Pages: </b>")
		if intPageNumber > 1 then
			response.write("<a href='" & frm & ".asp?pg=" & intPageNumber -1 & "'>[Prev &lt;&lt;]</a> ")
		end if
		for i = 1 to intPageCount
			if cstr(i) = intPageNumber then
				response.write("<b>" & i & "</b> ")
			else
				response.write("<a href='" & frm & ".asp?pg=" & i & "'>" & i & "</a> ")
			end if	
		next
		if clng(intPageNumber) < clng(intPageCount) then
			response.write("<a href='" & frm & ".asp?pg=" & intPageNumber + 1 & "'>[Next &gt;&gt;]</a>")
		end if
		response.write(" <b>of " & intNumRecords & " records.</b></p>")
	else
		response.write("<p>" & intNumRecords & " records</p>")
	end if
end sub

sub ResList (rs)
	dim strLink, i
	rs.absoluteposition=((intPageNumber-1) * intPageSize) +1
	response.write("<p>ITS WORKING</p>")
	NavForm
	for i = 1 to rs.PageSize
		if rs.eof then exit for
		if rs.bof then exit for

'		if strItemType <> "" then
				strData = strn(rs("Author"))
				if strData <> "" then
					strOut = strData
				end if
				strData = strn(rs("Year"))
				if strData <> "" then
					strOut = strOut & " (" & strData & ")"
				end if
				strData = strn(rs("ItemTitle"))
				if strData <> "" then
					strOut = strOut & " " & strData
				end if
					response.write("<p><a href='" & "Search.asp?ItemID=" & rs("ID") & "'>" & strOut & "</a></p>")
		
'		elseif strItemID <> "" then
'			response.write("<p>ITS WORKING</p>")
'		else
'			response.write("<p>ERROR</p>")
'		end if

		rs.Movenext
	next
	NavForm
end sub

sub DisplayRes
	dim strSQL, dbConn, rs
		Set dbConn = Server.CreateObject("ADODB.Connection")
		strIP = request.servervariables("LOCAL_ADDR")
		if true then        
           strConn = GetConnectionString()
	       dbConn.connectiontimeout = 180
	       dbConn.commandtimeout = 180
	       dbConn.open strConn
	    elseif strIP = "192.168.0.3" then
			strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\librifungorum\librifungorum.mdb"
			dbConn.open strConn
		elseif strIP = "194.203.77.69" then
			strConn = "Provider=SQLOLEDB.1;Password=WebServerSQL;Integrated security=SSPI;User ID=WebServerSQL;Initial Catalog=BritishFungi;Data Source=WebServer"
			dbConn.open strConn
		else
			dbConn.open "FILEDSN=librifungorum"
		end if
		if strLetter <> "" then
			strSQL = "SELECT tblItems.* " _
				& "FROM tblItems " _
				& "WHERE (((tblItems.ItemType) = '" & protectSQL(strItemType,true) & "')) " _
				& "ORDER BY tblItems.Author, tblItems.Year;"
		elseif strItemID <> "" then
			strSQL = "SELECT tblItems.BaseURL, tbImages.ImageFileName, tbImages.[Page(s)] " _
				& "FROM tblItems INNER JOIN tbImages ON tblItems.ID = tbImages.ItemFK " _
				& "WHERE (((tbImages.ItemFK) = " & protectSQL(strItemID,true) & ")) " _
				& "ORDER BY tbImages.ID;"
		else
			exit sub		
		end if
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open strSql, dbConn, 3
		if not rs.bof then
		rs.pagesize = intPageSize
		rs.movelast
		rs.movefirst
		intNumRecords = rs.recordcount
		intPageCount = rs.pagecount
		ResList(rs)
		else 
			response.write("No Records Found<br>")
			response.write("<p><a href='" & "Search.asp" & "'>Reset page</a></p>")
		end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end sub
%>
		  <!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
<% 
	GetNav
	DisplayRes
%>
            <!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 2004 <a href="Index.htm">Libri Fungorum</a>. Return to <a href="Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
