<html>
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
<head>
<%
	dim strSearch, bList, bExact
	if request.querystring.item("strSearch") <> "" then
		strSearch = request.querystring.item("strSearch")
response.write("HELLO") & "<br>")			  	  
	else strSearch = ""
response.write("HELLO") & "<br>")			  	  
	end if
	if request.querystring.item("bList") <> "" then
		bList = request.querystring.item("bList")
response.write("HELLO") & "<br>")			  	  
	else bList = ""
response.write("HELLO") & "<br>")			  	  
	end if
	if request.querystring.item("bExact") <> "" then
		bExact = request.querystring.item("bExact")
response.write("HELLO") & "<br>")			  	  
	else bExact = ""
response.write("HELLO") & "<br>")			  	  
	end if
response.write("HELLO") & "<br>")			  	  

sub ResList (rs)
response.write("HELLO") & "<br>")			  	  
	do while not rs.eof
		response.write(rs("NAME OF FUNGUS") & ": " & rs("Record Number") & "<br>")			  	  
		rs.Movenext
	loop
end sub

sub DisplayRes
dim strSQL, dbConn, rs
response.write("HELLO") & "<br>")			  	  
	if strSearch = "" then exit sub
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
	elseif strIP = "194.203.77.78" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	if bExact <> "" then
		strSQL = "SELECT TOP 5000 IndexFungorum.* " _
			& "FROM IndexFungorum " _
			& "WHERE [NAME OF FUNGUS] = '" & protectSQL(strSearch, false) & "'; "
	else
		strSQL = "SELECT TOP 5000 IndexFungorum.* " _
			& "FROM IndexFungorum " _
			& "WHERE [NAME OF FUNGUS] Like '" & protectSQL(strSearch, false) & "%'; "
	end if
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if not rs.bof then
		response.write("<p>" & rs.RecordCount & " records found</p>")
	if bList <> "" then
		ResList(rs)
	end if
	else
		response.write("<p>No records found</p>")
	end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end sub
%> 
<title>Funindex Check</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
	DisplayRes
%>
</body>
</html>
