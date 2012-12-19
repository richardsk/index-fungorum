<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplSF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Species Fungorum - GSD Species</title>
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
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCFFCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoSF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">&nbsp;Species 
            Fungorum</td>
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
                  with searching</a> : <font color="#FF0000"><strong><a href="javascript:popUp("IndexFungorumCookies.htm")" target="_blank">Cookies</a></strong></font></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Index Fungorum</a></td>
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
sub DisplayResults()
   	dim strSQL, strLink, dbConn, rs1, rs2, strRecordID, strOut, strBas
   	strRecordID = request.querystring("RecordID")
if clng(strRecordID) >0 then
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
   Set rs1 = Server.CreateObject("ADODB.Recordset")
   Set rs2 = Server.CreateObject("ADODB.Recordset")
' find name data - assumes strRecordID is a pointer to the current name record
   strSQL ="SELECT Publications.*, IndexFungorum.*, " _
		& "[FundicClassification].[Family name], [FundicClassification].[Order name], [FundicClassification].[Subclass name], " _
		& "[FundicClassification].[Class name], [FundicClassification].[Phylum name], [FundicClassification].[Kingdom name] " _
		& "FROM (IndexFungorum INNER JOIN [FundicClassification] " _
		& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number]) " _
		& "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		& "WHERE (((IndexFungorum.[RECORD NUMBER])=" & protectSQL(strRecordID,true) & "));"
	rs1.Open strSql, dbConn, 3
   if not rs1.eof and not rs1.bof then
	  strOut = DisplayName(rs1)
		' check for <i>in litt</i>
		if instr(strOut,"in litt") then
			strOut = replace(strOut,"&lt;i&gt;","<i>")
			strOut = replace(strOut,"&lt;/i&gt;","</i>")
		end if
	  response.write("<p><b>Current Name:</b><br>" &  strOut & "</p>")
   end if
' Print homotypics for this current name
	response.write("<p><b>Synonymy:</b><br>")
	DisplayHomotypics(rs1("Basionym record number"))
	response.write("</p>")
' find heterotypic basionym list ordered by date
   strSQL = "SELECT DISTINCT IndexFungorum_2.[YEAR OF PUBLICATION], IndexFungorum_1.[BASIONYM RECORD NUMBER] " _
		& "FROM (IndexFungorum AS IndexFungorum_1 " _
		& "INNER JOIN IndexFungorum " _
		& "ON IndexFungorum_1.[CURRENT NAME RECORD NUMBER] = IndexFungorum.[RECORD NUMBER]) " _
		& "INNER JOIN IndexFungorum AS IndexFungorum_2 ON IndexFungorum_1.[BASIONYM RECORD NUMBER] = IndexFungorum_2.[RECORD NUMBER] " _
		& "WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(strRecordID,true) & ") " _
		& "AND ((IndexFungorum_1.[BASIONYM RECORD NUMBER]) <> [IndexFungorum].[BASIONYM RECORD NUMBER])) " _
		& "ORDER BY IndexFungorum_2.[YEAR OF PUBLICATION], IndexFungorum_1.[BASIONYM RECORD NUMBER];"
   rs2.Open strSql, dbConn, 3
   if not rs2.eof and not rs2.bof then
	  do while not rs2.eof
		 DisplayHomotypics(rs2("Basionym record number"))
		 response.write("<br>")
		 rs2.movenext
	  loop
   	end if
	response.write("<p><b>Position in classification:</b><br>")
	if rs1("Family name") <> "" then
	 	response.write(rs1("Family name"))
	end if
	if rs1("Order name") <> "" then
		response.write(", " & rs1("Order name"))
	end if
	if rs1("Subclass name") <> "" then
		response.write(", " & rs1("Subclass name"))
	end if
	if rs1("Class name") <> "" then
		response.write(", " & rs1("Class name"))
	end if
	if rs1("Phylum name") <> "" then
	 	response.write(", " & rs1("Phylum name"))
	end if
	if rs1("Kingdom name") <> "" then
	 	response.write(", " & rs1("Kingdom name"))
	end if
	response.write("</p>")
   	strLink = rs1("INTERNET LINK")
   	strOut = rs1("Taxonomic referee")
	if strLink <> "" then
		if left(strLink,4) = "mail" then
		response.write("<p><b>Synonymy Contributor(s): </b><br><a href=" & strLink & " >" & strOut & "</a></p>")
		else
			response.write("<p><b>Synonymy Contributor(s): </b><br>" & strOut & "; " & strLink & "</p>")
		end if
	elseif strOut <> "" then
		response.write("<p><b>Synonymy Contributor(s): </b><br>" & strOut & "</p>")	
	end if  
   	rs2.close
	rs1.close
   	set rs1 = nothing
   	set rs2 = nothing
   	dbConn.close
   	set dbConn = nothing
else
   response.write("Record ID parameter not valid")
end if
end sub

sub DisplayHomotypics(strBasNum)
   dim strSQL, strLink, dbConn, rs
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
	strSQL = "SELECT IndexFungorum.*, Publications.* " _
		& "FROM IndexFungorum " _
		& "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		& "WHERE (((IndexFungorum.[BASIONYM RECORD NUMBER]) = " & protectSQL(strBasNum,true) & ") " _  
		& "AND ((IndexFungorum.[RECORD NUMBER]) <> [current name record number]))" _
		& "ORDER BY IndexFungorum.[YEAR OF PUBLICATION];"
   rs.Open strSql, dbConn, 3
   if not rs.eof and not rs.bof then
	  do while not rs.eof
		strOut = DisplayName(rs)
			' check for <i>in litt</i>
			if instr(strOut,"in litt") then
				strOut = replace(strOut,"&lt;i&gt;","<i>")
				strOut = replace(strOut,"&lt;/i&gt;","</i>")
			end if
		response.write(strOut & "<br>")
		rs.movenext
	  loop
   end if
   rs.close
   set rs = nothing
   dbConn.Close
   set dbConn = nothing	
end sub

function DisplayName(rs)
	dim strData, strName, strLit, strGenus, strLink
		strGenus = ""
		strName = ""
		strLit = ""
	if strn(rs("SPECIFIC EPITHET")) = strn(rs("INFRASPECIFIC EPITHET")) then
		' it's an autonym
		strData = left(strn(rs("NAME OF FUNGUS")),instr(strn(rs("NAME OF FUNGUS"))," ")) & strn(rs("SPECIFIC EPITHET"))
		if  strData <> "" then
			strName = "<b>" & strData & "</b>"
		end if	
		strData = encodeHtml(strn(rs("AUTHORS")))
		if  strdata <> "" then
			strOrth = strn(rs("ORTHOGRAPHY COMMENT"))
			if  strOrth <> "" then
				strName = strName & " <b>" & strData & "</b> [as '<i>" & strOrth & "</i>']"
			else
				strName = strName & " <b>" & strData & "</b>"
			end if	
		else
			strData = encodeHtml(strn(rs("MISAPPLICATION AUTHORS")))
			if  strdata <> "" then
				strName = strName & " sensu <b>" & strData & "</b>"
			end if		
		end if	
		strData = encodeHtml(strn(rs("PUBLISHING AUTHORS")))
		if  strData <> "" then
			if strLit <> "" then strLit = strLit & ","
			strLit = strLit & " in " & strData & ","
		end if	
		strData = encodeHTML(strn(rs("pubIMIAbbr")))
		if  strData <> "" then
			strLit = strLit & " <i>" & strData & "</i>"
		end if	
		strdata = encodeHTML(strn(rs("pubIMISupAbbr")))
		if strData <> "" then
			strLit = strLit & ", " & strData
		end if
		strData = encodeHTML(strn(rs("PubIMIAbbrLoc")))
		if strData <> "" then
			strLit = strLit & " (" & strData & ")"
		end if
		strData = strn(rs("VOLUME"))
		if strData <> "" then
			strLit = strLit & " <b>" & strdata & "</b>"
		end if
		strData = strn(rs("PART"))
		if strData <> "" then
			strLit = strLit & "(" & strData & ")"
		end if
		strData = strn(rs("PAGE")) 
		if strData<> "" then
			strLit = strLit & ": " & strData
		end if
		strData = strn(rs("YEAR OF PUBLICATION"))
		if strData <> "" then
			strLit = strLit & " (" & strData & ")"
		end if
		strData = strn(rs("YEAR ON PUBLICATION")) 
		if strData <> "" and strShow <> "" then
			strLit = strLit & " [" & strData & "]"
		end if
		if instr(strName," sensu ") then
			strLinkType = 2
			if instr(strName,"; fide") then
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & left(strName,instr(strName,"; ")-1)  & "</a></b>" & right(strName,len(strName)-instr(strName,"; ")+1)
				' DisplayName = "<a href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & left(strName,instr(strName,"; ")-1)  & "</a></b>" & right(strName,len(strName)-instr(strName,"; ")+1)
			else
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='namesrecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
				' DisplayName = "<a href='namesrecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
			end if
			if strName <> "" and right(strName,1) <> "," and strLit <> "" then DisplayName = DisplayName & ","
			DisplayName = DisplayName & strLit
		else
			DisplayName = "<a href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
			if strName <> "" and right(strName,1) <> "," and strLit <> "" then DisplayName = DisplayName & ","
			DisplayName = DisplayName & strLit
		end if
		' add infraspecific rank and epithet and display as bold blue
		strData = "<b><font color='#0000FF'>" & strn(rs("INFRASPECIFIC RANK")) & " " & strn(rs("INFRASPECIFIC EPITHET")) & "</font></b>"
		DisplayName = DisplayName & " " & strData
	else
		' it's a normal name
		strData = strn(rs("NAME OF FUNGUS"))
		if  strdata <> "" then
			strName = strName & "<b>" & strData & "</b>"
		end if	
		strData = encodeHtml(strn(rs("AUTHORS")))
		if  strdata <> "" then
			strOrth = strn(rs("ORTHOGRAPHY COMMENT"))
			if  strOrth <> "" then
				strName = strName & " <b>" & strData & "</b> [as '<i>" & strOrth & "</i>']"
			else
				strName = strName & " <b>" & strData & "</b>"
			end if	
		else
			strData = encodeHtml(strn(rs("MISAPPLICATION AUTHORS")))
			if  strdata <> "" then
				strName = strName & " sensu <b>" & strData & "</b>"
			end if		
		end if	
		strData = encodeHtml(strn(rs("PUBLISHING AUTHORS")))
		if  strData <> "" then
			if strLit <> "" then strLit = strLit & ","
			strLit = strLit & " in " & strData & ","
		end if	
		strData = encodeHTML(strn(rs("pubIMIAbbr")))
		if  strData <> "" then
			strLit = strLit & " <i>" & strData & "</i>"
		end if	
		strdata = encodeHTML(strn(rs("pubIMISupAbbr")))
		if strData <> "" then
			strLit = strLit & ", " & strData
		end if
		strData = encodeHTML(strn(rs("PubIMIAbbrLoc")))
		if strData <> "" then
			strLit = strLit & " (" & strData & ")"
		end if
		strData = strn(rs("VOLUME"))
		if strData <> "" then
			strLit = strLit & " <b>" & strdata & "</b>"
		end if
		strData = strn(rs("PART"))
		if strData <> "" then
			strLit = strLit & "(" & strData & ")"
		end if
		strData = strn(rs("PAGE")) 
		if strData<> "" then
			strLit = strLit & ": " & strData
		end if
		strData = strn(rs("YEAR OF PUBLICATION"))
		if strData <> "" then
			strLit = strLit & " (" & strData & ")"
		end if
		strData = strn(rs("YEAR ON PUBLICATION")) 
		if strData <> "" and strShow <> "" then
			strLit = strLit & " [" & strData & "]"
		end if
		if instr(strName," sensu ") then
			strLinkType = 2
			if instr(strName,"; fide") then
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & left(strName,instr(strName,"; ")-1)  & "</a></b>" & right(strName,len(strName)-instr(strName,"; ")+1)
				' DisplayName = "<a href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & left(strName,instr(strName,"; ")-1)  & "</a></b>" & right(strName,len(strName)-instr(strName,"; ")+1)
			else
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='namesrecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
				' DisplayName = "<a href='namesrecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
			end if
			if strName <> "" and right(strName,1) <> "," and strLit <> "" then DisplayName = DisplayName & ","
			DisplayName = DisplayName & strLit
		else
			DisplayName = "<a href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
			if strName <> "" and right(strName,1) <> "," and strLit <> "" then DisplayName = DisplayName & ","
			DisplayName = DisplayName & strLit
		end if
	end if
end function

function strn(str)
	if isnull(str) then
		strn = ""
	else
		strn = str
	end if  
end function

%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" -->
<h3><a href=javascript:popUp("../GSD/Gsd.htm")>GSD</a> Species Synonymy</h3>
<%
if request.querystring.count > 0 then
	DisplayResults
else
	response.write("Unexpected error: there are no variables to process?")
end if
%> 
<a href='javascript:history.go(-1)'>back to previous page</a><br>
<!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 2008 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm")>Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm">main page</a>. 
      Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- InstanceEnd --></html>
