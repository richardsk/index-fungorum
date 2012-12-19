<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Name Registration: Basionym Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<script type="text/javascript">
var d = new Date();
var curr_year = d.getFullYear();
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td><img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100"></td>
          <td><h1><font size="+2">Index&nbsp;Fungorum&nbsp; Name&nbsp;Registration&nbsp;System</font> 
            </h1>
            <p>search for the basionym or replaced/competing synonym and copy 
              the IF number only to the appropriate field on the form&nbsp;</p>
            </td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td> <%
	dim strSearch, strType, intPageNumber, intNumRecords, intPageSize, intPageCount, strOpen
	SERVER.SCRIPTTIMEOUT = 180
	intPageSize = 200
	strSearch = session("strSearch")
	strType = session("strType")
	if request.form.item("Submit") <> "" then
		if request.form.item("SearchTerm") <> ""  then
			'trap single quote
			strSearch = replace(request.form.item("SearchTerm"),"'","")
			' right trim
			strSearch = rtrim(strSearch)
			' trap leading %
			strSearch = replace(strSearch,"%","")
			session("strSearch") = strSearch
			intPageNumber = "1"
			if request.form.item("SearchBy") = "Name" then
				strType = "N"
				session("strType") = strType
			elseif request.form.item("SearchBy") = "epithet" then
				strType = "E"
				session("strType") = strType
			end if
	  end if
	end if
	if request.querystring.item("strGenus") <> "" then
		strSearch = request.querystring.item("strGenus")
		session("strSearch") = strSearch
		strType = "N"
		session("strType") = strType
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
		if request.querystring.item("GSD") <> "" then strType = "G"
	end if
	if request.querystring.item("strEpithet") <> "" then
		strSearch = request.querystring.item("strEpithet")
		session("strSearch") = strSearch
		strType = "E"
		session("strType") = strType
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
	end if
	if request.querystring.item("strGenusName") <> "" then
		strSearch = request.querystring.item("strGenusName")
		session("strSearch") = strSearch
		strType = "GN"
		session("strType") = strType
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
	end if
' back door for all records	
	if request.querystring.item("P") = "PMK" then
		strOpen = "OK"
	else
		strOpen = ""
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
		frm  = "names"
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
			response.write("<a href='" & frm & ".asp?pg=" & intPageNumber + 1 & "'>[Next &gt;&gt;]</a> ")
		end if
		response.write(" <b>of " & intNumRecords & " records.</b>")
		response.write(" <a class='LinkColour1a' href='#TopOfPage'>TofP</a> <a class='LinkColour1a' href='#BottomOfPage'>BofP</a> <font size='-2'><a href='javascript:window.close();'>Close window</a></font></p>")
	else
		response.write("<p>" & intNumRecords & " records</p>")
	end if
end sub

sub ResList (rs)
	dim strLink, i
	rs.absoluteposition=((intPageNumber-1) * intPageSize) +1
	response.write("<p></p><b>Name, Author, Year, (Current name), Parent taxon</b><p></p>")
	NavForm
	for i = 1 to rs.PageSize
		if rs.eof then exit for
		if rs.bof then exit for
		if strType = "E" then
			if rs("SPECIFIC EPITHET") <> "" then
				response.write(" " & rs("SPECIFIC EPITHET") & ", ")
			end if
		end if
		response.write("<a class='LinkColour1'>" & rs("NAME OF FUNGUS") & "</a>")
		if rs("AUTHORS") <> "" then
			response.write(" " & EncodeHTML(rs("AUTHORS")))
		else
' ONLY TAKE TEXT BEFORE ";"
			if rs("MISAPPLICATION AUTHORS") <> "" then
				if instr(rs("MISAPPLICATION AUTHORS"),"; fide") then
					response.write(" sensu " & encodeHtml(left(rs("MISAPPLICATION AUTHORS"),instr(rs("MISAPPLICATION AUTHORS"),"; fide")-1)))
				else
					response.write(" sensu " & encodeHtml(rs("MISAPPLICATION AUTHORS")))
				end if
			end if
		end if
		if rs("YEAR OF PUBLICATION") <> "" then
			response.write(" (" & rs("YEAR OF PUBLICATION") & ") <a class='LinkColour4'><b>" & rs("RECORD NUMBER")& "</b></a>")
		end if
		rs.Movenext
		response.write("<br>")
	next
	NavForm
	rs.close
	set rs = nothing
'	dbConn.close
	set dbConn = nothing
end sub

sub DisplayRes
	dim strSQL, dbConn, rs
	if strSearch = "" then exit sub
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.12" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_KIRK-WEBSERVER;Initial Catalog=IndexFungorum;Data Source=KIRK-WEBSERVER"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "194.203.77.68" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	if strType = "N" then
		strSQL = "SELECT TOP 6000 IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.AUTHORS, " _
			& "IndexFungorum.[CURRENT NAME], IndexFungorum.[CURRENT NAME RECORD NUMBER], IndexFungorum.[YEAR OF PUBLICATION], " _
			& "IndexFungorum.[RECORD NUMBER], IndexFungorum.[GSD FLAG], IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER], " _
			& "FundicClassification.[Family name], FundicClassification.TeleomorphLink, " _
			& "FundicClassification.[Order name], FundicClassification.[Subclass name], FundicClassification.[Class name], " _
			& "FundicClassification.[Phylum name], FundicClassification.[Kingdom name], FundicClassification.AnamorphType, " _
			& "FundicClassification_1.[Family name] AS CurrentFamily, FundicClassification_1.TeleomorphLink AS CurrentTeleomorphLink, " _
			& "FundicClassification_1.[Order name] AS CurrentOrder, FundicClassification_1.[Subclass name] AS CurrentSubclass, " _
			& "FundicClassification_1.[Class name] AS CurrentClass, FundicClassification_1.[Phylum name] AS CurrentPhylum, " _
			& "FundicClassification_1.[Kingdom name] AS CurrentKingdom, FundicClassification_1.AnamorphType AS CurrentAnamorphType " _
			& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
			& "LEFT JOIN FundicClassification AS FundicClassification_1 " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] " _
			& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '" & protectSQL(strSearch, false) & "%')) " _
			& "AND (((IndexFungorum.[STS FLAG]) Is Null)) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
	elseif strType = "E" then
		strSQL = "SELECT TOP 6000 IndexFungorum.[SPECIFIC EPITHET], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.[NAME OF FUNGUS], " _
			& "IndexFungorum.AUTHORS, IndexFungorum.[YEAR OF PUBLICATION], IndexFungorum.[CURRENT NAME], IndexFungorum.[GSD FLAG], " _
			& "IndexFungorum.[RECORD NUMBER], IndexFungorum.[CURRENT NAME RECORD NUMBER], IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER], " _
			& "FundicClassification.[Family name], FundicClassification.TeleomorphLink, FundicClassification.[Order name], " _
			& "FundicClassification.[Subclass name], FundicClassification.[Class name], FundicClassification.[Phylum name], " _
			& "FundicClassification.[Kingdom name], FundicClassification.AnamorphType, " _
			& "FundicClassification_1.[Family name] AS CurrentFamily, " _
			& "FundicClassification_1.[Order name] AS CurrentOrder, FundicClassification_1.[Subclass name] AS CurrentSubclass, " _
			& "FundicClassification_1.[Class name] AS CurrentClass, FundicClassification_1.[Phylum name] AS CurrentPhylum, " _
			& "FundicClassification_1.[Kingdom name] AS CurrentKingdom, FundicClassification_1.AnamorphType AS CurrentAnamorphType, " _
			& "FundicClassification_1.TeleomorphLink AS CurrentTeleomorphLink " _
			& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
			& "LEFT JOIN FundicClassification AS FundicClassification_1 " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] "
			if strOpen <> "OK" then
				strSQL = strSql & "WHERE (((IndexFungorum.[SPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%') " _
					& "AND ((IndexFungorum.[STS FLAG]) Is Null)) " _
					& "OR (((IndexFungorum.[INFRASPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%') AND ((IndexFungorum.[STS FLAG]) Is Null)) " _
					& "ORDER BY IndexFungorum.[SPECIFIC EPITHET], IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
			else
				strSQL = strSql & "WHERE (((IndexFungorum.[SPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%')) " _
					& "OR (((IndexFungorum.[INFRASPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%')) " _
					& "ORDER BY IndexFungorum.[SPECIFIC EPITHET], IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
			end if
   	elseif strType = "G" then
		strSQL = "SELECT TOP 6000 IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.AUTHORS, " _
			& "IndexFungorum.[CURRENT NAME], IndexFungorum.[CURRENT NAME RECORD NUMBER], IndexFungorum.[YEAR OF PUBLICATION], " _
			& "IndexFungorum.[GSD FLAG], IndexFungorum.[RECORD NUMBER], IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER], " _
			& "FundicClassification.[Family name], FundicClassification.TeleomorphLink, FundicClassification.[Order name], " _
			& "FundicClassification.[Subclass name], FundicClassification.[Class name], FundicClassification.[Phylum name], " _
			& "FundicClassification.[Kingdom name], FundicClassification.AnamorphType, " _
			& "FundicClassification_1.[Family name] AS CurrentFamily, " _
			& "FundicClassification_1.[Order name] AS CurrentOrder, FundicClassification_1.[Subclass name] AS CurrentSubclass, " _
			& "FundicClassification_1.[Class name] AS CurrentClass, FundicClassification_1.[Phylum name] AS CurrentPhylum, " _
			& "FundicClassification_1.[Kingdom name] AS CurrentKingdom, FundicClassification_1.AnamorphType AS CurrentAnamorphType, " _
			& "FundicClassification_1.TeleomorphLink AS CurrentTeleomorphLink " _
			& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
			& "LEFT JOIN FundicClassification AS FundicClassification_1 " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] " _
			& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '" & protectSQL(strSearch, false) & "%') AND ((IndexFungorum.[GSD FLAG]) Is Not Null)) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
   	elseif strType = "GN" then
		strSQL = "SELECT TOP 6000 IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.AUTHORS, " _
			& "IndexFungorum.[CURRENT NAME], IndexFungorum.[CURRENT NAME RECORD NUMBER], IndexFungorum.[YEAR OF PUBLICATION], " _
			& "IndexFungorum.[GSD FLAG], IndexFungorum.[RECORD NUMBER], IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER], " _
			& "FundicClassification.[Family name], FundicClassification.TeleomorphLink, FundicClassification.[Order name], " _
			& "FundicClassification.[Subclass name], FundicClassification.[Class name], FundicClassification.[Phylum name], " _
			& "FundicClassification.[Kingdom name], FundicClassification.AnamorphType, " _
			& "FundicClassification_1.[Family name] AS CurrentFamily, " _
			& "FundicClassification_1.[Order name] AS CurrentOrder, FundicClassification_1.[Subclass name] AS CurrentSubclass, " _
			& "FundicClassification_1.[Class name] AS CurrentClass, FundicClassification_1.[Phylum name] AS CurrentPhylum, " _
			& "FundicClassification_1.[Kingdom name] AS CurrentKingdom, FundicClassification_1.AnamorphType AS CurrentAnamorphType, " _
			& "FundicClassification_1.TeleomorphLink AS CurrentTeleomorphLink " _
			& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
			& "LEFT JOIN FundicClassification AS FundicClassification_1 " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] " _
			& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '" & protectSQL(strSearch, false) & "%') AND ((IndexFungorum.[INFRAGENERIC RANK]) = 'gen.')) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
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
		response.write("The search term <b>" & strSearch & "</b> was not found<br>")
	end if
end sub
%> 
            <form method="post" action="FindBasionym.asp" name="search">
              <table width="478" border="0" name="Name" height="60">
                <tr> 
                  <td colspan="4"><b>Search by:-</b></td>
                  <td colspan="3" align="right">&nbsp; </td>
                </tr>
                <tr> 
                  <td width="38"><b>Name</b></td>
                  <td width="46"><b>Epithet</b></td>
                  <td colspan="2">&nbsp;</td>
                  <td width="287"><b>Find the basionym or replaced synonym:-</b></td>
                  <td width="98" align="right">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="38"><input type="radio" name="SearchBy" value="Name" <%if strType <> "E" then response.write("checked")%>></td>
                  <td width="46"> <div align="left"> 
                      <input type="radio" name="SearchBy" value="epithet" <%if strType = "E" then response.write("checked")%>>
                    </div></td>
                  <td colspan="2"> <div align="left"> </div></td>
                  <td colspan="2" valign="bottom"> <input type="text" name="SearchTerm" size="45" <%response.write("value=" & chr(34) & strSearch & chr(34))%>			  onKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;"> <input type="submit" name="submit" value="Search"> 
                  </td>
                </tr>
              </table>
            </form>
            <%
	GetNav
	DisplayRes
%> </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade>
      &copy; 
                    <script>
document.write(curr_year);
</script> <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a></td>
  </tr>
</table>
<a name="BottomOfPage"></a> 
</body>
</html>
