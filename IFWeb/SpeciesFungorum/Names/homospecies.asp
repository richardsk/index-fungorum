<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/TemplSF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Species Fungorum - Homotypic Species</title>
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
<script type="text/javascript">
<!--
var d = new Date();
var curr_year = d.getFullYear();
//-->
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
                <td><a href="Names.asp" onMouseOver="MM_displayStatusMsg('Search Species Fungorum');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Species Fungorum</a> : <font color="#FF0000"><strong><a href=javascript:popUp("SpeciesFungorumCookies.htm") onMouseOver="MM_displayStatusMsg('Cookies');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Cookies</a></strong></font></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../BSM/bsm.asp" onMouseOver="MM_displayStatusMsg('Search Bibliography of Systematic Mycology');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Bibliography of Systematic Mycology</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="/Fundic.asp" onMouseOver="MM_displayStatusMsg('Search Dictionary of the Fungi Hierarchy');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Dictionary of the Fungi Hierarchy</a></td>
              </tr>
              <tr class="mainbody"> 
                <td>&nbsp; </td>
              </tr>
              <tr class="mainbody"> 
                <td>&nbsp;</td>
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
sub DisplayResults()
   	dim strSQL, strLink, dbConn, rs, i, strRecordID, strOut
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
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
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
   Set rs = Server.CreateObject("ADODB.Recordset")
' find name data - assumes strRecordID is a pointer to the current name record
   strSQL ="SELECT IndexFungorum.* , Publications.* " _
		& "FROM IndexFungorum " _
		& "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		& "WHERE (((IndexFungorum.[BASIONYM RECORD NUMBER]) = " & protectSQL(strRecordID,true) & ") AND (([IndexFungorum].[STS FLAG]) Is Null)) " _
		& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
	rs.Open strSql, dbConn, 3
   	if rs.eof or rs.bof then
		rs.close
		set rs = nothing
		dbConn.close
		set dbConn = nothing
		exit sub
	end if
	response.write("<p><b>Basionym Name:</b><br>")
	rs.movefirst
' search for basionym name and print
	do while not rs.eof
		if rs("basionym record number") = rs("record number") then
			strOut = DisplayName(rs)			
		end if
		rs.movenext
	loop
	response.write(strOut & "</p>")
' list everything but current name
	response.write("<p><b>Homotypic synonyms:</b><br>")
	rs.movefirst
	do while not rs.eof
		if rs("basionym record number") <> rs("record number") then
			strOut = DisplayName(rs)
			response.write(strOut & "<br>")
		end if
		rs.movenext
	loop
' search for current name again
	rs.movefirst
	do while not rs.eof
		if rs("basionym record number") = rs("record number") then
			exit do			
		end if
		rs.movenext
	loop
	response.write("</p>")
   	rs.close
   	set rs = nothing
   	dbConn.close
   	set dbConn = nothing
else
   response.write("Record ID parameter not valid")
end if
end sub

function DisplayName(rs)
	dim strData, strName, strLit, strGenus, strLink
	strGenus = ""
	strName = ""
	strLit = ""
	strData = strn(rs("NAME OF FUNGUS"))
	if  strdata <> "" then
		strName = strName & "<b>" & strData & "</b>"
	end if	
	strData = encodeHtml(strn(rs("AUTHORS")))
	if  strdata <> "" then
		strName = strName & " <b>" & strData & "</b>"
	else
		strData = encodeHtml(strn(rs("MISAPPLICATION AUTHORS")))
		if  strdata <> "" then
			strName = strName & " sensu <b>" & strData & "</b>"
		end if		
	end if	
	strData = strn(rs("ORTHOGRAPHY COMMENT"))
	if  strdata <> "" then
		strLit = strLit & " [as '<i>" & strData & "</i>']"
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
	DisplayName = "<a href='namesrecord.asp?RecordID=" & rs("Record Number") & "'>" & strName  & "</a>"
	if strName <> "" and right(strName,1) <> "," and strLit <> "" then DisplayName = DisplayName & ","
	DisplayName = DisplayName & strLit
end function

function UserOK
dim	strIP, strA, strB, strC, strD
	UserOK = ""
	strIP = request.servervariables("REMOTE_ADDR")
	if strIP = "" then exit function
    if strIP = "::1" then
        UserOK = "OK"
        exit function
    end if
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

%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" -->
<h3>Homotypic Synonyms&nbsp;<font size='-2'><a href=javascript:popUp("SynNotes.htm")>See Note</a></font><br><br></h3>
<%
if request.querystring.count > 0 then
	DisplayResults 
else
	response.write("Unexpected error: there are no variables to process?")
end if
%>
Click on an entry to see Index Fungorum data. Please contact <a href="mailto:p.kirk@cabi.org">Paul 
Kirk</a> if you have any additions or errors to report.<br>
<br>

<a href='javascript:history.go(-1)'>back to previous page</a>
<!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333">
&copy;
<script>
document.write(curr_year);
</script>
<a href=javascript:popUp("../Names/IndexFungorumPartnership.htm")>Species 
      Fungorum</a>. Return to <a href="../Index.htm">main page</a>. Return to 
      <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- InstanceEnd --></html>
