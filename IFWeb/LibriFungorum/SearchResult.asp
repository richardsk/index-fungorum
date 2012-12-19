<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/TemplLF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Libri Fungorum - Search Result</title>
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
dim intPageSize, intPageNumber, intNumRecords, intPageCount, strItemID
	intPageSize = 20		
	strItemID = session("ItemID")
	if request.querystring("ItemID") <> "" then
		strItemID = trim(request.querystring("ItemID"))
		session("ItemID") = strItemID
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
		frm  = "SearchResult"
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
		strData = strn(rs("Author"))
		if strData <> "" then
			strOut = "<b>" & encodeHtml(strData)
		else
			strData = strn(rs("UnitTitle"))
			if strData <> "" then
				strOut = encodeHtml(strData)
			end if
		end if
		strData = strn(rs("Year"))
		if strData <> "" then
			strOut = strOut & " (" & encodeHtml(strData) & ")"
		end if
		strData = strn(rs("ItemTitle"))
		if strData <> "" then
			strOut = strOut & " <i>" & encodeHtml(strData) & "</i>"
		end if
		strData = encodeHtml(strn(rs("Source")))
		if strData <> "" then
			if instr(strData,"http") then strData = replace(strData,"'>","' target='_blank'>")
			strOut = strOut & "</b> &#8211; images " & strData
		end if
		response.write("<p>" & strOut & "</b></p>")
	NavForm
	for i = 1 to rs.PageSize
	  	if rs.eof then exit for
			if rs("ItemType") = "J" then
				strData = strn(rs("UnitTitle")) & ": " & strn(rs("Page(s)"))
			elseif rs("ItemType") = "I" then
				strData = strn(rs("ItemTitle")) & ": " & strn(rs("Page(s)"))
			else
				strData = strn(rs("Author")) & ": " & strn(rs("Page(s)"))
			end if
			strPopup = "javascript:ImagepopUp(" & chr(34)
			strItemID = "ItemID=" & strn(rs("ItemCounter1"))
			strImageFileName = "ImageFileName=" & strn(rs("ImageFileName")) & chr(34) & chr(41)
			strOut = "<a href='" & strPopup & "Image.asp?" & strItemID & "&" & strImageFileName & "'>" & encodeHtml(strData) & "</a>"
			response.write(strOut & "<br>")
		rs.movenext
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
'	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=herbIMI;Data Source=webserver"
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\PESIfungi\PESIfungi.mdb"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\PESIfungi\PESIfungi.mdb"
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\PESIfungi\PESIfungi.mdb"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\PESIfungi\PESIfungi.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\PESIfungi\PESIfungi.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=pesi"
	end if
		strSQL = "SELECT tblItems.*, tblImages.*, [tblItems].[ID] AS ItemCounter1 " _
			& "FROM tblItems INNER JOIN tblImages ON tblItems.ID = tblImages.ItemFK " _
			& "WHERE (((tblImages.ItemFK) = " & protectSQL(strItemID,true) & ")) " _
			& "ORDER BY tblImages.ID;"
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if not rs.bof then 
    	rs.pagesize = intPageSize
		rs.movelast
		rs.movefirst
		intNumRecords = rs.recordcount
		intPageCount = rs.Pagecount
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
