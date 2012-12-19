<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplSF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Species Fungorum - Species synonymy</title>
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
                  with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Index Fungorum</a></td>
              </tr>
              <tr class="mainbody">
                <td><a href=javascript:popUp("../Names/IndexFungorumLSIDs.htm") onMouseOver="MM_displayStatusMsg('Important Announcement');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Important 
                  Announcement</a></td>
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
   	dim strSQL, strLink, dbConn, rs, i, strRecordID, strOut
   	strRecordID = request.querystring("RecordID")
if clng(strRecordID) >0 then
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if strIP = "192.168.0.3" then
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
   Set RS = Server.CreateObject("ADODB.Recordset")
' find name data - assumes strRecordID is a pointer to the current name record
' when all dates are available change sort order to date order
   strSQL ="SELECT Publications.*, IndexFungorum.* " _
		& "FROM IndexFungorum " _
		& "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		& "WHERE ((IndexFungorum.[CURRENT NAME RECORD NUMBER])=" & strRecordID & " AND ((IndexFungorum.[STS FLAG]) Is Null)) " _
		& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
	rs.Open strSql, dbConn, 3
   	if rs.eof or rs.bof then
		rs.close
		set rs = nothing
		dbConn.close
		set dbConn = nothing
		exit sub
	end if
	response.write("<p><b>Current Name:</b><br>")
	rs.movefirst
' search for current name and print
	do while not rs.eof
		if rs("current name record number") = rs("record number") then
			strOut = DisplayName(rs)
		end if
		rs.movenext
	loop
	strOut = replace(strOut,",,",",")
	response.write(strOut & "</p>")
' list everything but current name
	rs.movefirst
	if rs.recordcount <> "1" then response.write("<p><b>Synonymy:</b><br>")
	do while not rs.eof
		if rs("current name record number") <> rs("record number") then
			strOut = DisplayName(rs)
			strOut = replace(strOut,",,",",")
			response.write(strOut & "<br>")
		end if
		rs.movenext
	loop
' search for current name again
	rs.movefirst
	do while not rs.eof
		if rs("current name record number") = rs("record number") then
			exit do
		end if
		rs.movenext
	loop
	response.write("<br>")
   	strLink = rs("INTERNET LINK")
   	strOut = rs("Taxonomic referee")
	if strLink <> "" then
		if left(strLink,4) = "mail" then
			response.write("<p><b>Synonymy Contributor(s): </b><br><a href=" & strLink & " >" & strOut & "</a></p>")
		else
'			response.write("<p><b>Synonymy Contributor(s): </b><br>" & strOut & "; " & strLink & "</p>")
			response.write("<p><b>Synonymy Contributor(s): </b><br>" & strLink & "; " & strOut & "</p>")
		end if
	elseif strOut <> "" then
		response.write("<p><b>Synonymy Contributor(s): </b><br>" & strOut & "</p>")	
	end if  
   	rs.close
   	set rs = nothing
   	dbConn.close
   	set dbConn = nothing
else
   response.write("Record ID parameter not valid")
end if
end sub

function DisplayName(rs)
	dim strData, strName, strLit, strGenus, strLink, strOrth
	strGenus = ""
	strName = ""
	strLit = ""
' check to see if it's an autonym and format accordingly
	if strn(rs("SPECIFIC EPITHET")) = strn(rs("INFRASPECIFIC EPITHET")) then
	' it's an autonym
		strData = left(strn(rs("NAME OF FUNGUS")),instr(strn(rs("NAME OF FUNGUS"))," ")) & strn(rs("SPECIFIC EPITHET"))
		if  strData <> "" then
			strName = "<b>" & strData & "</b>"
		end if	
		strData = server.HTMLEncode(strn(rs("AUTHORS")))
		if  strData <> "" then
			strOrth = strn(rs("ORTHOGRAPHY COMMENT"))
			if  strOrth <> "" then
				strName = strName & " <b>" & strData & "</b> [as '<i>" & strOrth & "</i>']"
			else
				strName = strName & " <b>" & strData & "</b>"
			end if	
		else
			strData = server.HTMLEncode(strn(rs("MISAPPLICATION AUTHORS")))
			if  strData <> "" then
				strName = strName & " sensu <b>" & strData & "</b>"
				strName = replace(strName,"&lt;i&gt;","<i>")
				strName = replace(strName,"&lt;/i&gt;","</i>")
			end if
		end if	
		strData = server.HTMLEncode(strn(rs("PUBLISHING AUTHORS")))
		if  strData <> "" then
			strLit = strLit & ", in " & strData
		end if	
		' put in trap for last five years names
		strShow = "False"
		if not (instr(strn(rs("LAST FIVE YEARS FLAG")),"X") > 0)  then  strShow = "True"
		if UserOK = "OK" then strShow = "True"
		if strShow = "False" then
			strPubList = strn(rs("PUBLISHED LIST REFERENCE"))
			if strPubList <> "" then
				strLit = strLit & " (" & strn(rs("YEAR OF PUBLICATION")) & ") <a href='http://www.cabi-publishing.org/products/taxonomy/IOF/Index.asp'>Recent record: see Index of Fungi</a>"
			else
				strLit = strLit & " (" & strn(rs("YEAR OF PUBLICATION")) & ") <a href='http://www.cabi-publishing.org/products/taxonomy/IOF/Index.asp'>Recent record: see next part of Index of Fungi</a>"
			end if
		else
			strData = encodeHTML(strn(rs("pubIMIAbbr")))
			if  strData <> "" then
				strLit = strLit & ", <i>" & strData & "</i>"
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
			if strData <> "" then
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
		end if
'		take sensu names out of link and make red
		if instr(strName," sensu ") then
			strLinkType = 2
			if instr(strName,"; fide") then
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & left(strName,instr(strName,"; ")-1)  & "</a></b>" & right(strName,len(strName)-instr(strName,"; ")+1)
			else
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='namesrecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
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
		if  strData <> "" then
			strName = "<b>" & strData & "</b>"
		end if	
		strData = server.HTMLEncode(strn(rs("AUTHORS")))
		if  strData <> "" then
			strOrth = strn(rs("ORTHOGRAPHY COMMENT"))
			if  strOrth <> "" then
				strName = strName & " <b>" & strData & "</b> [as '<i>" & strOrth & "</i>']"
			else
				strName = strName & " <b>" & strData & "</b>"
			end if	
		else
			strData = server.HTMLEncode(strn(rs("MISAPPLICATION AUTHORS")))
			if  strData <> "" then
				strName = strName & " sensu <b>" & strData & "</b>"
				strName = replace(strName,"&lt;i&gt;","<i>")
				strName = replace(strName,"&lt;/i&gt;","</i>")
			end if
		end if	
		strData = server.HTMLEncode(strn(rs("PUBLISHING AUTHORS")))
		if  strData <> "" then
			strLit = strLit & ", in " & strData
		end if	
		' put in trap for last five years names
		strShow = "False"
		if not (instr(strn(rs("LAST FIVE YEARS FLAG")),"X") > 0)  then  strShow = "True"
		if UserOK = "OK" then strShow = "True"
		if strShow = "False" then
			strPubList = strn(rs("PUBLISHED LIST REFERENCE"))
			if strPubList <> "" then
				strLit = strLit & " (" & strn(rs("YEAR OF PUBLICATION")) & ") <a href='http://www.cabi-publishing.org/products/taxonomy/IOF/Index.asp'>Recent record: see Index of Fungi</a>"
			else
				strLit = strLit & " (" & strn(rs("YEAR OF PUBLICATION")) & ") <a href='http://www.cabi-publishing.org/products/taxonomy/IOF/Index.asp'>Recent record: see next part of Index of Fungi</a>"
			end if
		else
			strData = encodeHTML(strn(rs("pubIMIAbbr")))
			if  strData <> "" then
				strLit = strLit & ", <i>" & strData & "</i>"
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
		end if
		' take sensu names out of link and make red
		if instr(strName," sensu ") then
			strLinkType = 2
			if instr(strName,"; fide") then
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='NamesRecord.asp?RecordID=" & rs("Record Number") & "'>" & left(strName,instr(strName,"; ")-1)  & "</a></b>" & right(strName,len(strName)-instr(strName,"; ")+1)
			else
				DisplayName = "<a class='LinkColour" & strLinkType & "' href='namesrecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
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

function UserOK
dim	strIP, strA, strB, strC, strD
	UserOK = ""
	strIP = request.servervariables("REMOTE_ADDR")
	if strIP = "" then exit function
	strA = left(strIP,instr(strIP,".")-1)
	strIP = right(strIP,len(strIP) - len(strA)-1)
	strB = left(strIP,instr(strIP,".")-1)
	strIP = right(strIP,len(strIP) - len(strB)-1)
	strC = left(strIP,instr(strIP,".")-1)
	strIP = right(strIP,len(strIP) - len(strC)-1)
	strD = strIP
' CABI sub-nets
	if strA = "198" and strB = "93" and strC = "247" then UserOK = "OK"
	if strA = "198" and strB = "93" and strC = "248" then UserOK = "OK"
' CABI firewall
	if strA = "194" and strB = "131" and strC = "255" and strD = "12" then UserOK = "OK"
' LCR Christchurch proxy
	if strIP = "202.27.40.6" then UserOK = "OK"
' Kirk_net address
	strLocalIP = request.servervariables("SERVER_NAME")
	if strLocalIP = "82.43.123.182" then UserOK = "OK"
end function

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if
end function

function encodeHTML(strData)
'take a string HTMLencode then replace the typesetting stuff
strData = server.htmlencode(strData)
strData = replace(strData,"&lt;i&gt;","<i>")
strData = replace(strData,"&lt;/i&gt;","</i>")
strData = replace(strData,"&lt;italic&gt;","<i>")
strData = replace(strData,"&lt;roman&gt;","</i>")
strData = replace(strData,"&lt;b&gt;","<b>")
strData = replace(strData,"&lt;/b&gt;","</b>")
strData = replace(strData,"&lt;bold&gt;","<b>")
strData = replace(strData,"&lt;light&gt;","</b>")
strData = replace(strData,"&lt;p&gt;","<p>")
strData = replace(strData,"&lt;/p&gt;","</p>")
encodeHTML = strData
end function
%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" -->
            <h3>Species Synonymy&nbsp;<font size='-2'><a href=javascript:popUp("SynNotes.htm")>See 
              Note</a></font></h3>
<%
if request.querystring.count > 0 then
	DisplayResults 
else
	response.write("Unexpected error: there are no variables to process?")
end if
%> 
<p>Click on an entry to see Index Fungorum data. Please contact <a href="mailto:p.kirk@cabi.org">Paul 
	Kirk</a> if you have any additions or errors to report.</p>
<p><a href='javascript:history.go(-1)'>back to previous page</a></p>
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
</body>
<!-- InstanceEnd --></html>
