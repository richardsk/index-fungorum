<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Fungal Name Author Details</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=740,height=495,left=150,top=00');");
}
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
<table width="100%" class="mainbody">
  <tr> 
    <td width="47%" rowspan="5"><h1><img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">&nbsp;Index 
        Fungorum</h1></td>
    <td width="22%" height="20" align="right"><a href="javascript:window.close();">Close</a></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>
</head>
<body bgcolor="#CCCCCC">
<%
function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function

sub DisplayRes
dim intID, strSQL, dbConn, rs
	if request.querystring("ID") <> "" then
		intID = trim(request.querystring("ID"))
	else
	response.write("Invalid query string<br>")
	exit sub
	end if
	strSQL = "SELECT tblAuthorMain.InvertedName, tblAuthorMain.Abbreviation, tblAuthorMain.[Abbreviation(tagged)], " _
		& "tblAuthorMain.Dates, tblAuthorMain.Published, tblAuthorMain.APN_ID, tblAuthorMain.Surname, " _
		& "tblAuthorMain.[Forename(s)], tblAuthorMain.NameOrReference, tblAuthorMain.FInumber " _
		& "FROM tblAuthorMain " _
		& "WHERE (((tblAuthorMain.ID)=" & protectSQL(intID,true) & "));"
	Set dbConn = Server.CreateObject("ADODB.Connection")
		strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=WEBSERVER"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.78" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
	   dbConn.open strConn
	elseif strIP = "194.203.77.68" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
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
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if not rs.bof then 
		strOut = ""
		strData = strn(rs("Surname")) 
		if strData <> "" then
			strOut = "Surname: <b>" & server.HTMLEncode(strData) & "</b><br><br>"
		end if
		strData = strn(rs("Forename(s)")) 
		if strData <> "" then
			strOut = strOut & "Forename(s) or initial(s): <b>" & strData & "</b><br><br>"
		end if
		strData = strn(rs("Dates")) 
		if strData <> "" then
			strOut = strOut & "Dates: <b>" & strData & "</b><br><br>"
		end if
		strData = strn(rs("Published")) 
		if strData <> "" then
			strOut = strOut & "Published date: <b>" & strData & "</b><br><br>"
		end if
		strData = strn(rs("Abbreviation")) 
		if strData <> "" then
			strOut = strOut & "Abbreviation: <b>" & server.HTMLEncode(strData) & "</b><br><br>"
		end if
		if strn(rs("Abbreviation")) <> strn(rs("Abbreviation(tagged)")) then
		strData = strn(rs("Abbreviation(tagged)")) 
		if strData <> "" then
			strOut = strOut & "Abbreviation in tagged format: <b>" & encodeHTML(strData) & "</b><br><br>"
		end if
		end if
		strData = strn(rs("NameOrReference")) 
		if strData <> "" then
			strRecordID = strn(rs("FInumber"))
				if len(strRecordID) < 6 then
					strLink = server.HTMLEncode(strData)
				else
					strLink = "NamesRecord.asp?RecordID=" & server.HTMLEncode(strRecordID)
					strLink = "<a href=" & strLink & " >" & server.HTMLEncode(strData) & "</a>"	
				end if
			strOut = strOut & "Published name: <b>" & strLink & "</b><br><br>"
		end if
		response.write(strOut)
	else
		response.write("No records found.<br>")
	end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end sub

%> 
      <h3>Fungal Name Author Details</h3>
<%
	DisplayRes
%>
</body>
</html>
