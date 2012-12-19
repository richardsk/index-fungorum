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
function ImagepopUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=705,height=650,left=100,top=00');");
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
                <td><a href=javascript:popUp("./html/help.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("Request.asp") onMouseOver="MM_displayStatusMsg('Submit a request');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Submit a request</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Resources.asp" onMouseOver="MM_displayStatusMsg('Search Libri Fungorum');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Libri Fungorum</a></td>
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
dim intPageSize, intPageNumber, intNumRecords, intPageCount, strItemType
	intPageSize = 10
	strItemType = session("strItemType")
	if request.querystring.item("ItemType") <> "" then
		strItemType = request.querystring.item("ItemType")
		session("strItemType") = strItemType
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
		frm  = "Search"
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

sub ResList(rs)
	dim i, strOut, strText
	rs.absoluteposition=((intPageNumber-1) * intPageSize) + 1
	NavForm
	for i = 1 to rs.PageSize
	  	if rs.eof then exit for
		if rs.bof then exit for
		strOut = ""
		if strItemType = "J" or strItemType = "I" then
			strData = strn(rs("ItemTitle"))
			if strData <> "" then
				strOut = strData
			end if
			strData = strn(rs("Year"))
			if strData <> "" then
				strOut = strOut & " (" & strData & ")"
			end if
			strData = strn(rs("Author"))
			if strData <> "" then
				strOut = strOut & " [" & strData & "]"
			end if
		else
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
		end if
			response.write("<p><a href='" & "SearchResult.asp?ItemID=" & rs("ID") & "'>" & server.HTMLEncode(strOut) & "</a></p>")
		rs.movenext
	next
	NavForm
	response.write("<p><a href='" & "Search.htm" & "'>Reset page</a></p>")
end sub

sub DisplayRes
	dim strSQL, dbConn, rs
	if strItemType <> "" and strItemType <> "0" then
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
		strSQL = "SELECT tblItems.* " _
			& "FROM tblItems " _
			& "WHERE (((tblItems.ItemType) = '" & protectSQL(strItemType,true) & "')) "
			if strItemType = "J" then
				strSQL = strSQL & "ORDER BY tblItems.ItemTitle, tblItems.Year;"
			else
				strSQL = strSQL & "ORDER BY tblItems.Author, tblItems.Year, tblItems.ItemTitle;"
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
			response.write("<p><a href='" & "Search.htm" & "'>Reset page</a></p>")
		end if
		rs.close
		set rs = nothing
		dbConn.close
		set dbConn = nothing
	else
		exit sub
	end if
end sub

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function
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
      &copy; 2004, 2005 <a href="Index.htm">Libri Fungorum</a>. Return to <a href="Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
