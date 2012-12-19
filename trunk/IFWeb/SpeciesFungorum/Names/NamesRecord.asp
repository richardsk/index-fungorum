<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/TemplSF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Species Fungorum - Names Record</title>
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
   dim strSQL, strLink, dbConn, rs, i, strPass, strShow, strGenus, strName, intRecordID, strPubList
   strPass = request.querystring.item("P")
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
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
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
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
   strSQL ="SELECT IndexFungorum.*, Publications.*, [FundicClassification].[family name], " _
		  & "[FundicClassification].[order name], [FundicClassification].[subclass name], [FundicClassification].[class name], " _
		  & "[FundicClassification].[phylum name], [FundicClassification].[TeleomorphLink], [FundicClassification].[kingdom name] " _
		  & "FROM (IndexFungorum LEFT JOIN [FundicClassification] " _
		  & "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number]) " _
		  & "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		  & "WHERE (((IndexFungorum.[RECORD NUMBER])=" & protectSQL(request.querystring.item("RecordID"),true) & ")) " _
		  & "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
  Set rs = Server.CreateObject("ADODB.Recordset")
  rs.Open strSQL, dbConn, 3
  if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit sub
  end if
  strShow = "False"
  if not (instr(strn(rs("LAST FIVE YEARS FLAG")),"X") > 0) then strShow = "True"
  if strPass = "PMK" then  strShow = "True"
  if UserOK = "OK" then strShow = "True"
  if strShow = "False" then
	strPubList = strn(rs("PUBLISHED LIST REFERENCE"))
	if strPubList <> "" then
		 strLink = " <a href='http://www.cabi-publishing.org/AllOtherProducts.asp?SubjectArea=&PID=515'>Recent record: see Index of Fungi</a>"
	else
		 strLink = " <a href='http://www.cabi-publishing.org/AllOtherProducts.asp?SubjectArea=&PID=515'>Recent record: see next part of Index of Fungi</a>"
	end if
  else
	 strLink = ""
  end if
	intRecordID = rs("RECORD NUMBER")
	strName = DisplayName (rs, strShow)
	strGenus = left(strName,instr(strName," ")-1)	
	if instr(strName,"; fide") then
		strLinkType = 2
		strLeft = left(strName,instr(strName,"; fide")-1)
		strRight = right(strName,len(strName)-instr(strName,"; fide")+1)
'		strName = "<a class='LinkColour" & strLinkType & "' href='genusrecord.asp?RecordID=" & rs("NAME OF FUNGUS FUNDIC RECORD NUMBER") & "'>" & strGenus & "</a>" & "<a class='LinkColour" & strLinkType & "'> " & right(strLeft,len(strLeft) - instr(strLeft," ")) & "</class></a></b>" & strRight
		strText = replace(strGenus,"<b>","")
		strText = replace(strText,"</b>","")
		strName = "<a class='LinkColour" & strLinkType & "' href='Names.asp?strGenus=" & strText & "'>" & strGenus & "</a>" & "<a class='LinkColour" & strLinkType & "'> " & right(strLeft,len(strLeft) - instr(strLeft," ")) & "</class></a></b>" & strRight
	else
		'check for names at higher ranks
		strText = rs("STS FLAG")
		if strText = "f" then
		' add code for popup with child taxa and synonyms for family
			strText = replace(strGenus,"<b>","")
			strText = replace(strText,"</b>","")
			strTaxonName = strText
			strText = strText & "&strRank=family" & chr(34) & chr(41)
			strpopup = "javascript:popUp(" & chr(34)
			strName = "<a href='" & strpopup & "ChildTaxa.asp?strName=" & strText & "'>" & strTaxonName & "</a></i>" & right(strName,len(strName) - len(strGenus))
		elseif strText = "r" then
		' add code for popup with child taxa for order
			strText = replace(strGenus,"<b>","")
			strText = replace(strText,"</b>","")
			strTaxonName = strText
			strText = strText & "&strRank=order" & chr(34) & chr(41)
			strpopup = "javascript:popUp(" & chr(34)
			strName = "<a href='" & strpopup & "ChildTaxa.asp?strName=" & strText & "'>" & strTaxonName & "</a></i>" & right(strName,len(strName) - len(strGenus))
		elseif strText = "c" or strText = "p" or strText = "k" then
			strName = strName
		else
			strText = replace(strGenus,"<b>","")
			strText = replace(strText,"</b>","")
			strName = "<a href='Names.asp?strGenus=" & strText & "'>" & strGenus  & "</a>" & right(strName,len(strName) - len(strGenus))
		end if
	end if
 	response.write("<p>" & strName & strLink & "</p>")
  DisplayLinkedData rs, strShow
  DisplaySyns rs 
  if strShow = "False" then
	  response.write("<p><b>Index Fungorum LSID:</b> urn:lsid:indexfungorum.org:names:" & rs("RECORD NUMBER"))
  else
	  response.write("<p><b>Index Fungorum LSID:</b> urn:lsid:indexfungorum.org:names:" & rs("RECORD NUMBER"))
  end if
  rs.close
  set rs = nothing
  dbConn.close
  set dbConn = nothing
end sub

sub DisplayFieldNames(rs)
	for each fieldlp in rs.fields
		response.write(fieldlp.name & "<br>")
	next
end sub

Function GetNameData(strRecordID)
   dim strSQL, dbConn, rs
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
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
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
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
   strSQL ="SELECT Indexfungorum.*, Publications.*, [FundicClassification].[family name], " _
		  & "[FundicClassification].[order name], [FundicClassification].[subclass name], [FundicClassification].[class name], " _
		  & "[FundicClassification].[phylum name], [FundicClassification].[TeleomorphLink], [FundicClassification].[kingdom name] " _
		  & "FROM (Indexfungorum LEFT JOIN [FundicClassification] " _
		  & "ON Indexfungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] " _
		  & "= [FundicClassification].[Fundic Record Number])" _
		  & "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		  & "WHERE (((Indexfungorum.[RECORD NUMBER])=" & protectSQL(strRecordID,true) & ")) " _
		  & "ORDER BY Indexfungorum.[NAME OF FUNGUS];"
  Set rs = Server.CreateObject("ADODB.Recordset")
  rs.Open strSQL, dbConn, 3
  if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit function
  end if
  GetNameData = DisplayName (rs, "False")
  rs.close
  set rs = nothing
  dbConn.close
  set dbConn = nothing
end function

function UserOK
dim	strLocalIP, strIP, strA, strB, strC, strD
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
	strLocalIP = request.servervariables("REMOTE_ADDR")
	if strLocalIP = "202.27.240.6" then UserOK = "OK"
' Kirk_net address
	strLocalIP = request.servervariables("REMOTE_ADDR")
	if strLocalIP = "82.43.123.182" then UserOK = "OK"
	strLocalIP = request.servervariables("SERVER_NAME")
	if strLocalIP = "82.43.123.182" then UserOK = "OK"
end function

function DisplayName(rs, strShow)
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
			if left(strdata,5) <> "sensu" then
				strName = strName & " sensu <b>" & strData & "</b>"
				strName = replace(strName,"&lt;i&gt;","<i>")
				strName = replace(strName,"&lt;/i&gt;","</i>")
			else
				strName = strName & " <b>" & strData & "</b>"
				strName = replace(strName,"&lt;i&gt;","<i>")
				strName = replace(strName,"&lt;/i&gt;","</i>")
			end if
		end if		
	end if	
	strData = strn(rs("ORTHOGRAPHY COMMENT"))
	if  strdata <> "" then
		strName = strName & " [as '<i>" & strData & "</i>']"
	end if	
	strData = encodeHtml(strn(rs("PUBLISHING AUTHORS")))
	if  strData <> "" then
		if strName <> "" then strName = strName & ","
		strName = strName & " in " & strData
	end if	
	if strShow = "True" then
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
	elseif strShow = "False" then
   		strData = strn(rs("YEAR OF PUBLICATION"))
		if strData <> "" then
			strLit = strLit & " (" & strData & ")"
		end if
	else
		strLit = ""
	end if
	if strName <> "" and right(strName,1) <> "," and strLit <> "" then strName = strName & ","
	DisplayName = strName & strLit
end function

sub DisplayLinkedData(rs, strShow)
	dim strData, strTax, strBSM, strData2, strLink
	strData = ""
	strTax = ""
	if strShow = "True" then
		strData = strn(rs("SANCTIONING AUTHOR"))
		if strData <> "" then
			if mid(strData, 4, 1) = "$" then
				strPageImage = right(strData,len(strData)-4)
				strPageImage = strPageImage & chr(34) & chr(41)
				strPopup2 = "javascript:popUp(" & chr(34)
				strPopup2 = "<b><a href='" & strpopup2 & strPageImage & "'>" & "Page Image in Sanctioning Work</a></b>"
				strOut = left(strData,3)
					strData = strn(rs("SANCTIONING REFERENCE LITERATURE LINK"))
					if strData <> "" then
						if strData = "889" then strRef = ", <i>Syst. mycol.</i>"
						if strData = "3140" then strRef = ", <i>Elench. fung.</i>"
					end if
					strData = strn(rs("SANCTIONING REFERENCE VOLUME"))
					if strData <> "" then strRef = strRef & " <b>" & strData & "</b>"
					strData = strn(rs("SANCTIONING REFERENCE PART"))
					if strData <> "" then strRef = strRef & "(" & strData & ")"
					strData = strn(rs("SANCTIONING REFERENCE PAGE"))
					if strData <> "" then strRef = strRef & ": " & strData
					strData = strn(rs("SANCTIONING REFERENCE YEAR"))
					if strData <> "" then strRef = strRef & " (" & strData & "). "
					strOut = strOut & strRef
				response.write("<p><b>Sanctioning citation: </b><br> " & strOut & " " & strPopup2 & "</p>")
			elseif mid(strData, 6, 1) = "$" then
				strPageImage = right(strData,len(strData)-6)
				strPageImage = strPageImage & chr(34) & chr(41)
				strPopup2 = "javascript:popUp(" & chr(34)
				strPopup2 = "<b><a href='" & strpopup2 & strPageImage & "'>" & "Page Image in Sanctioning Work</a></b>"
				strOut = left(strData,6)
					strData = strn(rs("SANCTIONING REFERENCE LITERATURE LINK"))
					if strData <> "" then
						if strData = "889" then strRef = ", <i>Syst. mycol.</i>"
						if strData = "3140" then strRef = ", <i>Elench. fung.</i>"
					end if
					strData = strn(rs("SANCTIONING REFERENCE VOLUME"))
					if strData <> "" then strRef = strRef & " <b>" & strData & "</b>"
					strData = strn(rs("SANCTIONING REFERENCE PART"))
					if strData <> "" then strRef = strRef & "(" & strData & ")"
					strData = strn(rs("SANCTIONING REFERENCE PAGE"))
					if strData <> "" then strRef = strRef & ": " & strData
					strData = strn(rs("SANCTIONING REFERENCE YEAR"))
					if strData <> "" then strRef = strRef & " (" & strData & "). "
					strOut = strOut & strRef
				response.write("<p><b>Sanctioning citation: </b><br> " & strOut & " " & strPopup2 & "</p>")
			else
					strOut = strData
					strData = strn(rs("SANCTIONING REFERENCE LITERATURE LINK"))
					if strData <> "" then
						if strData = "889" then strRef = ", <i>Syst. mycol.</i>"
						if strData = "3140" then strRef = ", <i>Elench. fung.</i>"
					end if
					strData = strn(rs("SANCTIONING REFERENCE VOLUME"))
					if strData <> "" then strRef = strRef & " <b>" & strData & "</b>"
					strData = strn(rs("SANCTIONING REFERENCE PART"))
					if strData <> "" then strRef = strRef & "(" & strData & ")"
					strData = strn(rs("SANCTIONING REFERENCE PAGE"))
					if strData <> "" then strRef = strRef & ": " & strData
					strData = strn(rs("SANCTIONING REFERENCE YEAR"))
					if strData <> "" then strRef = strRef & " (" & strData & "). "
				if strRef <> "" then
					strOut = strOut & strRef
					response.write("<p><b>Sanctioning citation: </b><br> " & strOut & "</p>")
				else
					response.write("<p><b>Sanctioning author: </b><br> " & strOut & "</p>")
				end if
			end if
		end if
		strData = encodeHTML(strn(rs("NOMENCLATURAL COMMENT")))
		if strData <> "" then
			response.write("<p><b>Nomenclatural comment: </b><br> " & strData & "</p>")
		end if
		strData = encodeHTML(strn(rs("EDITORIAL COMMENT")))
		if strData <> "" then
			response.write("<p><b>Editorial comment: </b><br> " & strData & "</p>")
		end if
		strData = encodeHTML(strn(rs("TYPIFICATION DETAILS")))
		if strData <> "" then
			if left(strData,13) = "Holotype IMI " then
				strData = right(strData,len(strData)-13)
				if instr(strData," ") then strData = left(strData,instr(strData," "))
 				strLink = "http://194.203.77.76/herbIMI/DisplayResults.asp?strIMINumber=" & strData
				response.write("</p><b>Typification Details:</b><br>Holotype IMI <b><a href=" & strLink & " target='_blank'>" & strData & "</a></b>")
			elseif left(strData,9) = "urn:lsid:" then
				strLSIDresolution = "http://lsid.tdwg.org/" & strData & chr(34) & chr(41)
				strPopup = "javascript:popUp(" & chr(34)
				strPopup = "<a href='" & strpopup & strLSIDresolution & "'>Resolve LSID</a>"
				response.write("<p><b>Typification Details: </b><br> " & strPopup & "; ")
				'add extra code for normal resolution
				strData = right(strData,len(strData)-33)
				response.write("<a href='NamesRecord.asp?RecordID=" & strData & "'>Display IF name record</a></p>")
				strPopup = ""
				strData = ""
			else
				response.write("</p><b>Typification Details: </b><br>" & strData)
			end if
			strData = encodeHTML(strn(rs("HOST")))
			if strData <> "" then
				strData = Ucase(left(strData,1)) & right(strData,len(strData)-1)
				strData2 = encodeHTML(strn(rs("LOCATION")))
				if strData2 <> "" then
					strData = strData & ": " & strData2
					response.write("</p><b>Host-Substratum/Locality: </b><br>" & strData)
				else
					response.write("</p><b>Host-Substratum/Locality: </b><br>" & strData)
				end if
			else
				strData = encodeHTML(strn(rs("LOCATION")))
				if strData <> "" then
					response.write("</p><b>Locality: </b><br>" & strData)
				end if
			end if
			response.write("</p>")
		else
			strData = encodeHTML(strn(rs("HOST")))
			if strData <> "" then
				strData = Ucase(left(strData,1)) & right(strData,len(strData)-1)
				strData2 = encodeHTML(strn(rs("LOCATION")))
				if strData2 <> "" then
					strData = strData & ": " & strData2
					response.write("</p><b>Host-Substratum/Locality: </b><br>" & strData)
				else
					response.write("</p><b>Host-Substratum: </b><br>" & strData)
				end if
			else
				strData = encodeHTML(strn(rs("LOCATION")))
				if strData <> "" then
					response.write("</p><b>Locality: </b><br>" & strData)
				end if
			end if
			response.write("</p>")
		end if
		strData = strn(rs("BASIONYM RECORD NUMBER"))
		if strData <> "" then
			if clng(rs("RECORD NUMBER")) <> clng(rs("BASIONYM RECORD NUMBER")) and clng(rs("BASIONYM RECORD NUMBER")) <> 0 then 
			strSynonymy = strn(rs("SYNONYMY"))
			if strSynonymy <> "" then
				strBasionym = GetNameData(strData)
				if right(strBasionym,1) = ")" then strBasionym = left(strBasionym,len(strBasionym)-1)
				strBasionym = replace(strBasionym,", (17"," 17")
				strBasionym = replace(strBasionym,", (18"," 18")
				strBasionym = replace(strBasionym,", (19"," 19")
					if instr(strSynonymy," non ") then
						response.write("<p><b>Basionym:</b><br>")
						response.write("<b><a href='NamesRecord.asp?RecordID=" & strData & "'>" & strBasionym & "</a></b></p>")
					else
						response.write("<p><b>Replaced synonym:</b><br>")
						response.write("<b><a href='NamesRecord.asp?RecordID=" & strData & "'>" & strBasionym & "</a></b></a></b></p>")
					end if
			else
				strBasionym = GetNameData(strData)
				if right(strBasionym,1) = ")" then strBasionym = left(strBasionym,len(strBasionym)-1)
				strBasionym = replace(strBasionym,", (17"," 17")
				strBasionym = replace(strBasionym,", (18"," 18")
				strBasionym = replace(strBasionym,", (19"," 19")
					response.write("<p><b>Basionym:</b><br>")
					response.write("<a href='NamesRecord.asp?RecordID=" & strData & "'>" & strBasionym & "</a></a></b></p>")
			end if
			end if
		end if
		strData = strn(rs("SYNONYMY"))
		if strData <> "" and instr(strData,"$") then
			if instr(strData," non ") then
				strUnavailable = left(strData,instr(strData," non "))
				strIDUnavailable = left(strUnavailable,6)
				strDataUnavailable = rtrim(right(strUnavailable,len(strUnavailable)-7))
				strCompeting = right(strData,len(strData)-instr(strData," non ")-4)
				strIDCompeting = left(strCompeting,6)
				strDataCompeting = right(strCompeting,len(strCompeting)-7)
				response.write("<p><b>Unavailable basionym and competing synonym:</b><br>")
				response.write("<b><a href='NamesRecord.asp?RecordID=" & strIDUnavailable & "'>" & strDataUnavailable & "</a></b> non <b><a href='NamesRecord.asp?RecordID=" & strIDCompeting & "'>" & strDataCompeting & "</a></b></p>")
			else			
				strID = left(strData,6)
				strData = right(strData,len(strData)-7)
				response.write("<p><b>Competing synonym:</b><br>")
				response.write("non <b><a href='NamesRecord.asp?RecordID=" & strID & "'>" & strData & "</a></b></p>")
			end if
		else
			if strData <> "" then
				if instr(strData," non ") then
					strUnavailable = left(strData,instr(strData," non "))
					strIDUnavailable = left(strUnavailable,6)
					strDataUnavailable = rtrim(right(strUnavailable,len(strUnavailable)-6))
					strCompeting = right(strData,len(strData)-instr(strData," non ")-5)
					strIDCompeting = left(strCompeting,6)
					strDataCompeting = right(strCompeting,len(strCompeting)-7)
					response.write("<p><b>Unavailable basionym and competing synonym:</b><br>")
					response.write("<b><a href='NamesRecord.asp?RecordID=" & strIDUnavailable & "'>" & strDataUnavailable & "</a></b> non <b><a href='NamesRecord.asp?RecordID=" & strIDCompeting & "'>" & strDataCompeting & "</a></b></p>")
				else
					response.write("<p><b>Competing synonym:</b><br>" & strData & "</p>")
				end if
			end if
		end if
		strData = encodeHTML(strn(rs("ANAMORPH TELEOMORPH")))
		if strData <> "" then
			if instr(strData,"$") then
				strMorphID = left(strData,6)
				strData = right(strData,len(strData)-7)
				strMorphType = left(strData,instr(strData," ")-1)
				strMorphName = right(strData,len(strData)-len(strMorphType))
				response.write("<p><b>" & strMorphType & ":</b><br>")
				response.write("<b><a href='NamesRecord.asp?RecordID=" & strMorphID & "'>" & strMorphName & "</a></b></p>")
			else
				if left(strData,3) = "Ana" then
					response.write("<p><b>Anamorph Name:</b><br> " & strData & "</p>")
				elseif left(strData,3) = "Syn" then
					response.write("<p><b>Synanamorph Name:</b><br> " & strData & "</p>")
				else
					response.write("<p><b>Teleomorph Name:</b><br> " & strData & "</p>")
				end if
			end if
		end if
	end if
	'check for page image to prepare for next bit
	if left(rs("CORRECTION"),2) = "$N" then
		strPageImage = right(rs("CORRECTION"),len(rs("CORRECTION"))-2)
		strPageImage = strPageImage & chr(34) & chr(41)
		strPopup = "javascript:popUp(" & chr(34)
		strPopup = "<a href='" & strpopup & strPageImage & "'>" & "Page Image for Protologue</a>"
	elseif left(rs("CORRECTION"),2) = "$I" then
		strPageImage = right(rs("CORRECTION"),len(rs("CORRECTION"))-2)
		strPageImage = strPageImage & chr(34) & chr(41)
		strPopup = "javascript:popUp(" & chr(34)
		strPopup = "<a href='" & strpopup & strPageImage & "'>" & "Page Image in Published List</a>"
	end if
	strData = strn(rs("PUBLISHED LIST REFERENCE"))
	if strData <> "" then
		strBSM = rs("BSM LINK")
		if strBSM <> "" then
		'trap for last five years using strShow
			if strShow = "True" then
				strPageImage = "../BSM/bsmrecord.asp?intArticle=" & strBSM
				strPageImage = strPageImage & chr(34) & chr(41)
				strBSMPopup = "javascript:popUp(" & chr(34)
				strBSMPopup = "<a href='" & strBSMPopup & strPageImage & "'>" & "BSM</a>"
				if left(rs("CORRECTION"),2) = "$N" then ' it's a protologue link so no BSM
					response.write("<p><b>Citations in published lists and Bibliographies:</b><br> " & strData & "; " & strPopup & "</p>")
				else
					response.write("<p><b>Citations in published lists and Bibliographies:</b><br> " & strData & "; " & strPopup & "; " & strBSMPopup & "</p>")
				end if
			else
				response.write("<p><b>Citations in published lists or literature:</b><br> " & strData & "; " & strPopup & "</p>")
			end if
		else
			response.write("<p><b>Citations in published lists or literature:</b><br> " & strData & "; " & strPopup & "</p>")
		end if
	else
		strBSM = rs("BSM LINK")
		if strBSM <> "" then
		'trap for last five years using strShow
			if strShow = "True" then
				strPageImage = "../BSM/bsmrecord.asp?intArticle=" & strBSM
				strPageImage = strPageImage & chr(34) & chr(41)
				strBSMPopup = "javascript:popUp(" & chr(34)
				strBSMPopup = "<a href='" & strBSMPopup & strPageImage & "'>" & "BSM</a>"
				if left(rs("CORRECTION"),2) = "$N" then ' it's a protologue link so no BSM
					response.write("<p><b>Citations in published lists and Bibliographies:</b><br> " & strPopup & "</p>")
				else
					response.write("<p><b>Citations in published lists and Bibliographies:</b><br> " & strPopup & "; " & strBSMPopup & "</p>")
				end if
			else
				response.write("<p><b>Citations in published lists or literature:</b><br> " & strPopup & "</p>")
			end if
		else
			response.write("<p><b>Citations in published lists or literature:</b><br> " & strPopup & "</p>")
		end if
	end if
	strData = strn(rs("Phylum name"))
	if strData <> "" then
		if strData = "Anamorphic fungi" then
			if rs("TeleomorphLink") <> "" then
				strData = rtrim(left(rs("TeleomorphLink"),instr(rs("TeleomorphLink")," ")))
				if right(strData,5) = "aceae" then
					strLink = "fundic.asp?RecordID=" & server.urlencode(strData) & "&Type=F"
					response.write("<p><b>Position in classification:</b><br> Anamorphic <a href=" & strLink & " >" & strData & "</a></p>")	
				elseif right(strData,4) = "ales" then
					response.write("<p><b>Position in classification:</b><br> Anamorphic " & strData & "</p>")
				elseif right(strData,7) = "mycetes" then
					response.write("<p><b>Position in classification:</b><br> Anamorphic " & strData & "</p>")
				elseif right(strData,6) = "mycota" then
					response.write("<p><b>Position in classification:</b><br> Anamorphic " & strData & "</p>")
				else
					strData = left(rs("TeleomorphLink"),instr(rs("TeleomorphLink")," "))
					strLink = "genusrecord.asp?RecordID=" & server.urlencode(right(rs("TeleomorphLink"),len(rs("TeleomorphLink"))-instr(rs("TeleomorphLink")," ")))
					response.write("<p><b>Position in classification:</b><br> Anamorphic <a href=" & strLink &  " >" & strData & "</a></p>")
				end if
			else
				response.write("<p><b>Position in classification:</b><br>" & rs("Phylum name") & "</p>")
			end if
		elseif rtrim(left(rs("Phylum name"),instr(rs("Phylum name")," "))) = "Fossil" then
			response.write("<p><b>Position in classification:</b><br>" & rs("Phylum name") & "</p>")
		else
			strData = strn(rs("Family name"))
			if strData <> "" then
				strTax = strData
			end if
			strData = strn(rs("Order name"))
			if strData <> "" then
				if strTax <> "" then
					strTax = strTax & ", " & strData
				else 
					strTax = strData
				end if
			end if
			strData = strn(rs("subclass name"))
			if strData <> "" then
				if strTax <> "" then
					strTax = strTax & ", " & strData
				else 
					strTax = strData
				end if
			end if
			strData = strn(rs("class name"))
			if strData <> "" then
				if strTax <> "" then
					strTax = strTax & ", " & strData
				else 
					strTax = strData
				end if
			end if
			strData = strn(rs("phylum name"))
			if strData <> "" then
				if strTax <> "" then
					strTax = strTax & ", " & strData
				else 
					strTax = strData
				end if
			end if
			strData = strn(rs("kingdom name"))
			if strData <> "" then
				if strTax <> "" then
					strTax = strTax & ", " & strData
				else 
					strTax = strData
				end if
			end if
			response.write("<p><b>Position in classification:</b><br> " & strTax & "</p>")
		end if
	else
	' it's family or higher
	end if
	strData = strn(rs("CURRENT NAME RECORD NUMBER"))
	if strData <> "" then
		if clng(rs("RECORD NUMBER")) <> clng(rs("CURRENT NAME RECORD NUMBER")) _
			and clng(rs("CURRENT NAME RECORD NUMBER")) <> 0 then 
				response.write("<p><b>Current name:</b><br>")
				strOut = GetNameData(strData)
				if right(strOut,1) = ")" then strOut = left(strOut,len(strOut)-1)
				strOut = replace(strOut,", (17"," 17")
				strOut = replace(strOut,", (18"," 18")
				strOut = replace(strOut,", (19"," 19")
				strOut = replace(strOut,", (20"," 20")
				response.write("<a href='SynSpecies.asp?RecordID=" & strData & "'>" & strOut & "</a></p>")
		end if
	end if	
end sub

sub DisplaySyns(rs)
	dim strData, strGenus, strGSD
	strData = ""
	strGenus = ""
	strGSD = ""
	strData = strn(rs("GSD FLAG"))
	if left(strData,3) = "GSD" then
		strGenus = trim(left(rs("CURRENT NAME"),instr(rs("CURRENT NAME")," ")))
		strStr = chr(34) & chr(41)
		strJava = "javascript:popUp(" & chr(34)
		strGSD = "<b>GSD: </b><a href='" & strJava & "../Names/gsd.htm" & strStr & "'><img src='../Images/i.gif' alt='Click here to get an explanation of GSD&#8217;s' width='13' height='13' border='0'></a><br>"
		if strn(rs("CURRENT NAME RECORD NUMBER")) <> "" then 
			strGSD = strGSD & "<a href='GSDspecies.asp?RecordID=" & strn(rs("CURRENT NAME RECORD NUMBER")) & "'>display synonymy</a> "
		end if
		response.write("<p>" & strGSD & "</p>")
	else
		CheckCurrent rs
		CheckBasionyms rs
	end if
end sub

sub CheckCurrent(rs)
	dim rs2, dbConn, strSQL
	if rs("Current name record number") = rs("record number") then
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
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
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
   		strSQL ="SELECT IndexFungorum.[record number] from IndexFungorum " _
		  & "WHERE (((IndexFungorum.[current name RECORD NUMBER])=" & rs("record number") & "));" 
  		Set rs2 = Server.CreateObject("ADODB.Recordset")
  		rs2.Open strSQL, dbConn, 3
		rs2.movelast
		if rs2.RecordCount > 1 then
			response.write("<p><b>Synonymy</b> <font size='-2'>(<a href=javascript:popUp('SynNotes.htm')>See Note</a>)</font>:<br>")
			response.write("<a href='SynSpecies.asp?RecordID=" & strn(rs("CURRENT NAME RECORD NUMBER")) & "'>display synonymy</a><br>")
		end if
	  	rs2.close
	  	set rs2 = nothing
	  	dbConn.close
	  	set dbConn = nothing
	end if
end sub

sub CheckBasionyms(rs)
	dim rs2, dbConn, strSQL
	if rs("basionym record number") = rs("record number") then
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
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
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
   		strSQL ="SELECT IndexFungorum.[record number] from IndexFungorum " _
		  & "WHERE (((IndexFungorum.[Basionym RECORD NUMBER])= " & rs("record number") & "));" 
  		Set rs2 = Server.CreateObject("ADODB.Recordset")
  		rs2.Open strSQL, dbConn, 3
		rs2.movelast
		if rs2.RecordCount > 1 then
			response.write("<p><b>Synonymy</b> <font size='-2'>(<a href=javascript:popUp('SynNotes.htm')>See Note</a></font>):<br>")
			response.write("<a href='HomoSpecies.asp?RecordID=" & strn(rs("Basionym RECORD NUMBER")) & "'>homotypic synonyms</a><br>")
		end if
	  	rs2.close
	  	set rs2 = nothing
	  	dbConn.close
	  	set dbConn = nothing
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
<h3>Record Details:</h3>
<%
if request.querystring.count > 0 then
	DisplayResults()
else
	response.write("Unexpected error: there are no variables to process?")
end if
%>
	<p>Please contact <a href="mailto:p.kirk@cabi.org">Paul Kirk</a> if you have any
	additions or errors to report. <a href=javascript:popUp("../Names/acknowledge.htm")>Data contributors</a>.</p>
	<p><a href='javascript:history.go(-1)'>back to previous page</a></p>
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
