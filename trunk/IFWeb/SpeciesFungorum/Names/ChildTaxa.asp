<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Species Fungorum - Child Taxa</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--

function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=740,height=440,left=150,top=00');");
}
//-->
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCFFCC">
<a name="TopOfPage"></a> 
<%
dim strRank, strName
if request.querystring("strName") <> "" then
	strName = request.querystring("strName")
end if
if request.querystring("strRank") <> "" then
	strRank = request.querystring("strRank")
end if
	response.write("&nbsp;&nbsp;<a class='LinkColour1a' href='#TopOfPage'>TofP</a> <a class='LinkColour1a' href='#BottomOfPage'>BofP</a>")
if strRank = "family" then
	response.write("<h3>Genera in: " & strName & "</h3>")
elseif strRank = "order" then
	response.write("<h3>Families in: " & strName & "</h3>")
elseif strRank = "class" then
	response.write("<h3>Orders in: " & strName & "</h3>")
elseif strRank = "phylum" then
	response.write("<h3>Classes in: " & strName & "</h3>")
end if

dim strSQL, dbConn, rs, strSQL2, rs2
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "194.203.77.68" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
		if strRank = "family" then
			strSQL = "SELECT IndexFungorum.[CURRENT NAME], IndexFungorum.AUTHORS, " _
				& "IndexFungorum.[YEAR OF PUBLICATION] " _
				& "FROM IndexFungorum INNER JOIN FundicClassification " _
				& "ON IndexFungorum.[RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
				& "WHERE (((IndexFungorum.[CURRENT NAME])=[NAME OF FUNGUS]) " _
				& "AND (([FundicClassification].[Family name]) = '" & protectSQL(strName, false) & "')) " _
				& "ORDER BY [IndexFungorum].[CURRENT NAME], [IndexFungorum].[NAME OF FUNGUS];"
		elseif strRank = "order" then
			strSQL = "SELECT DISTINCT IndexFungorum.[NAME OF FUNGUS], IndexFungorum.AUTHORS, " _
				& "IndexFungorum.[YEAR OF PUBLICATION], FundicClassification.[Family name] " _
				& "FROM FundicClassification INNER JOIN IndexFungorum " _
				& "ON FundicClassification.[Family name] = IndexFungorum.[NAME OF FUNGUS] " _
				& "WHERE (((FundicClassification.[Order name]) = '" & protectSQL(strName, false) & "') " _
				& "AND ((FundicClassification.[Family name]) Not Like 'incertae sedis')) " _
				& "ORDER BY FundicClassification.[Family name];"
		elseif strRank = "class" then
			strSQL = "SELECT DISTINCT FundicClassification.[Order name] " _
				& "FROM FundicClassification " _
				& "WHERE (((FundicClassification.[Class name]) = '" & protectSQL(strName, false) & "')) " _
				& "ORDER BY FundicClassification.[Order name];"
		elseif strRank = "phylum" then
			strSQL = "SELECT DISTINCT FundicClassification.[Class name] " _
				& "FROM FundicClassification " _
				& "WHERE (((FundicClassification.[Phylum name]) = '" & protectSQL(strName, false) & "')) " _
				& "ORDER BY FundicClassification.[Class name];"
		end if
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if rs.recordcount > 0 then
		do while not rs.eof or rs.bof
		if strRank = "family" then
			'display this current name
			response.write("<b>" & rs("CURRENT NAME") & "</b> " & encodeHtml(rs("AUTHORS")) & " " & rs("YEAR OF PUBLICATION") & "<br>")
			'find synonyms for this current name
			strSQL2 = "SELECT IndexFungorum.[NAME OF FUNGUS], IndexFungorum.AUTHORS, IndexFungorum.[YEAR OF PUBLICATION] " _
				& "FROM IndexFungorum " _
				& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) <> [CURRENT NAME]) " _
				& "AND ((IndexFungorum.[CURRENT NAME]) = '" & rs("CURRENT NAME") & "') " _
				& "AND ((IndexFungorum.[STS FLAG]) Not Like 'o')) " _
				& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
			Set rs2 = Server.CreateObject("ADODB.Recordset")
			' check for no synonyms
			rs2.Open strSql2, dbConn, 3
			if rs2.recordcount > 0 then
				do while not rs2.eof or rs2.bof
						response.write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=  " & rs2("NAME OF FUNGUS") & " " & encodeHtml(rs2("AUTHORS")) & " " & rs2("YEAR OF PUBLICATION") & "<br>")
				rs2.movenext
				loop
			end if
		else
			response.write("<b>" & rs("NAME OF FUNGUS") & "</b> " & encodeHtml(rs("AUTHORS")) & " " & rs("YEAR OF PUBLICATION") & "<br>")
		end if
		rs.movenext
		loop
	else
		response.write("<b>This taxon is not currently recognized</b>")
	end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
	response.write("<br>&nbsp;&nbsp;<a class='LinkColour1a' href='#TopOfPage'>TofP</a> <a class='LinkColour1a' href='#BottomOfPage'>BofP</a>")
%> 
<a name="BottomOfPage"></a>
</body>
</html>
