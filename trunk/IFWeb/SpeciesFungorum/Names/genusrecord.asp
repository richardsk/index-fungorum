<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/Templates/templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Genus Record Details</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}

function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
//-->
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
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#9CFF9C">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="59%" class="h1"> <img src="../IMAGES/CABILogo.gif" width="100" height="100"> 
            CABI databases</td>
          <td width="41%" valign="top"><table height="100%" align="right" halign="center">
              <tr class="mainbody"> 
                <td width="267"><a href="../Names/Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Species Fungorum</a> : <font color="#FF0000"><strong><a href=javascript:popUp("SpeciesFungorumCookies.htm") onMouseOver="MM_displayStatusMsg('Cookies');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Cookies</a></strong></font></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../BSM/bsm.asp" onMouseOver="MM_displayStatusMsg('Search Bibliography of Systematic Mycology');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Bibliography of Systematic Mycology</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../Names/Fundic.asp" onMouseOver="MM_displayStatusMsg('Search Dictionary of the Fungi Hierarchy');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Dictionary of the Fungi Hierarchy</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../GSD/GSDquery.asp" onMouseOver="MM_displayStatusMsg('Search Species 2000 Fungal GSDs');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Species 2000 Fungal GSDs</a></td>
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
          <td bgcolor="#CCFFCC"><!-- #BeginEditable "head" -->
<%
sub DisplayResults()
    dim strSQL, dbConn, rs, strName
	strName = ""
    strPass = request.querystring.item("P")
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
    strSQL ="SELECT Publications.*, [FundicClassification].* " _
		  & "FROM [FundicClassification] " _
		  & "LEFT JOIN Publications ON [FundicClassification].[LITERATURE LINK] = Publications.pubLink " _
		  & "WHERE ([FundicClassification].[FUNDIC RECORD NUMBER] =" & protectSQL(request.querystring.item("RecordID"),true) & "); " 
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open strSQL, dbConn, 3
    if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit sub
    end if
    strName = DisplayGenus(rs)
    response.write("<p>" & strName & "</p>")
    DisplayLinkedData rs
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

function DisplayGenus(rs)
	dim strData, strName, strLit
	strName = ""
	strLit = ""
	strData = strn(rs("GENUS NAME"))
	if  strdata <> "" then
		strName = strName & "<b><a href='names.asp?strGenus=" & strData & "'>" & strData & "</a></b>"
	end if	
	strData = encodeHtml(strn(rs("AUTHORS")))
	if  strdata <> "" then
		strName = strName & " <b>" & strData & "</b>"
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
	if strName <> "" and right(strName,1) <> "," and strLit <> "" then strName = strName & ","
 	DisplayGenus = strName & strLit
end function

function DisplayGenus2(rs)
	dim strData, strName, strLit
	strName = ""
	strLit = ""
	strData = strn(rs("GENUS NAME"))
	if  strdata <> "" then
		strName = strName & "<b><a href='genusrecord.asp?RecordID=" & strn(rs("FUNDIC RECORD NUMBER")) & "'>" & strData & "</a></b>"
	end if	
	strData = encodeHtml(strn(rs("AUTHORS")))
	if  strdata <> "" then
		strName = strName & " <b>" & strData & "</b>"
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
	if strName <> "" and right(strName,1) <> "," and strLit <> "" then strName = strName & ","
 	DisplayGenus2 = strName & strLit
end function

function GetGenusData(strLink)
	dim strSQL, dbConn, rs
	strName = ""
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
	strSQL ="SELECT [FundicClassification].*, Publications.* " _
		  & "FROM [FundicClassification] LEFT JOIN Publications ON [FundicClassification].[LITERATURE LINK] = Publications.pubLink " _
		  & "WHERE ((([FundicClassification].[FUNDIC RECORD NUMBER])=" & protectSQL(strLink,true) & ")); "
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSQL, dbConn, 3
	if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit function
	end if
	GetGenusData = DisplayGenus(rs)
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end function

function GetGenusData2(strLink)
	dim strSQL, dbConn, rs
	strName = ""
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
	strSQL ="SELECT [FundicClassification].*, Publications.* " _
		  & "FROM [FundicClassification] LEFT JOIN Publications ON [FundicClassification].[LITERATURE LINK] = Publications.pubLink " _
		  & "WHERE ((([FundicClassification].[FUNDIC RECORD NUMBER])=" & protectSQL(strLink,true) & ")); "
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSQL, dbConn, 3
	if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit function
	end if
	GetGenusData2 = DisplayGenus2(rs)
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end function

sub DisplayLinkedData(rs)
	dim strData, strTax, strName
	strData = ""
	strTax = ""
	strName = ""
	strData = strn(rs("SANCTIONING AUTHORS"))
	if strData <> "" then
		response.write("<p><b>Sanctioning author:</b><br> " & strData & "</p>")
	end if
	strData = strn(rs("NomenclaturalComment"))
	if strData <> "" then
		response.write("<p><b>Nomenclatural Status:</b><br> " & strData & "</p>")
	end if
	strData = strn(rs("Phylum name"))
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
	strData = strn(rs("Funindex record number of type species"))
	if strData <> "" then
		response.write("<p><b>Type species:</b>")
		strName = GetNameData(strData)
		response.write("<br><a href='namesrecord.asp?RecordID=" & strData & "'>" & strName & "</a></p>")
	end if		
	strData = strn(rs("CORRECT NAME FUNDIC RECORD NUMBER"))
	if strData <> "" then
		if clng(rs("FUNDIC RECORD NUMBER")) <> clng(strData) and clng(strData) <> 0 then 
				response.write("<p><b>Correct name:</b>")
				strName = GetGenusData2(strData)
				response.write("<br><a href='genusrecord.asp?RecordID=" & strData & "'>" & strName & "</a></p>")
		end if
	end if	
	strData = strn(rs("CURRENT USE"))
	if strData = "N" then
			response.write("<p><b>Name not currently in use</b></p>")
	end if
end sub

function DisplayName(rs)
	dim strData, strName
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
		strName = strName & " [as '<i>" & strData & "</i>']"
	end if	
	strData = encodeHtml(strn(rs("PUBLISHING AUTHORS")))
	if  strData <> "" then
		if strName <> "" then strName = strName & ","
		strName = strName & " in " & strData
	end if	
   	strData = strn(rs("YEAR OF PUBLICATION"))
	if strData <> "" then
		strName = strName & " (" & strData & ")"
	end if
 	DisplayName = strName
end function

function GetNameData (strLink)
	dim strSQL, dbConn, rs
	strName = ""
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
	strSQL ="SELECT IndexFungorum.*, Publications.* " _
		  & "FROM IndexFungorum LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		  & "WHERE (((IndexFungorum.[RECORD NUMBER])=" & protectSQL(strLink,true) & ")); "
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSQL, dbConn, 3
	if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit function
	end if
	GetNameData = DisplayName (rs)
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end function

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function 

%>
            <!-- #EndEditable --><!-- #BeginEditable "Main" --> 
            <h4>Genus Record Details</h4>
<%
if request.querystring.count > 0 then
	DisplayResults()
else
   response.write("Unexpected error: there are no variables to process?")
end if
%>

<p>Follow link from Genus to search Index Fungorum 
for specific names. Generic names not in current use in the <em><strong>Dictionary 
of the Fungi</strong></em> are usually linked to the correct name. 
Type species are linked to their entry in Index Fungorum. Please 
contact <a href="mailto:p.kirk@cabi.org">Paul Kirk</a> if you have 
any additions or errors to report.</p>

<%
	strPopup = "javascript:popUp(" & chr(34)
	strURL = "http://ravenel.si.edu/botany/ing/ingForm.cfm" & chr(34) & chr(41)
	strData = "Index Nominum Genericorum"
	strOut = "<a href='" & strPopup & strURL & "'>" & strData & "</a>"
	response.write("<p>Search " & strOut & "</p>")
	response.write("<p><a href='javascript:history.go(-1)'>back to previous page</a></p>")
%>
            <!-- #EndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="53" class="Footer"> 
      <hr noshade>
<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333">
&copy;
<script>
document.write(curr_year);
</script>
      <a href="http://www.cabi.org/">CABI</a></font>. Return to <a href="../Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- #EndTemplate --></html>
