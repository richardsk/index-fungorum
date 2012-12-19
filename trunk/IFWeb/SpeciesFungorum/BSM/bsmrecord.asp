<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/templates/Templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>BSM Record</title>
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
<%      dim intArticle,intPageNumber, intNumRecords, intPageSize,  intPageCount
	if request.querystring("intArticle") <> "" then
		intArticle = trim(request.querystring("intArticle"))
	end if
Function ReplaceStr(strIn, strWhat, strWith)
    Dim i 
    i = InStr(strIn, strWhat)
	do while i > 0
        strIn = left(strIn, i - 1) & strWith & right(strIn, Len(strIn) - i - Len(strWhat) + 1)
	    i = InStr(strIn, strWhat)
	loop
	ReplaceStr = strIn
End Function

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
' Kirk_net address
	strLocalIP = request.servervariables("REMOTE_ADDR")
	if strLocalIP = "82.43.123.182" then UserOK = "OK"
end function

sub ResList(rs)
dim i, strOut, strText, strUnlock, strPass
	strLit = ""
	strUnlock = ""
	strPass = request.querystring("P")
	if strn(rs("publyearof")) <> "" then
		if clng(year(now)) - clng(strn(rs("publyearof"))) > 5 then strUnlock = "1"
	else
		strUnlock = "1"
	end if
	if strPass = "PMK" then strUnlock = "1"
	if UserOK = "OK" then strUnlock = "1"
	strOut = ""
	if strUnlock = "1" then
		strData = strn(rs("ArticleAuthors"))
		if  strData <> "" then
			strLit = strLit & " <b>" & encodeHtml(strData) & "</b>"
		end if	
   		strData = strn(rs("publyearof"))
		if strData <> "" then
			strLit = strLit & " (" & strData & ")"
		end if
		strData = strn(rs("publyearon")) 
		if strData <> ""  then
			strLit = strLit & " [" & strData & "]"
   		end if
		strdata = strn(rs("ArticleTitle"))
		if strData <> "" then
			strLit = strLit & ". " & strData & "."
		end if
		strData = strn(rs("pubEditors"))
		if strData <> "" then
			strLit = strLit & " <i>In</i> " & encodeHtml(strData) & " (eds),"
		end if
		strData = strn(rs("pubIMIAbbr"))
		if strData <> "" then
			strLit = strLit & " <i>" & strData & "</i>"
		end if
		strData = strn(rs("pubIMISupAbbr"))
		if strData <> "" then
			strLit = strLit & " " & strData & ","
		end if
		strData = strn(rs("publvolume"))
		if strData <> "" then
			strLit = strLit & " <b>" & strdata & "</b>"
			strData = strn(rs("publpart"))
			if strData <> "" then
				strLit = strLit & "(" & strdata & "):"
			else
				strLit = strLit & ":"
			end if
		end if
		strData = strn(rs("pagination")) 
		if strData<> "" then
			strLit = strLit & " " & encodeHtml(strData)
		end if
		strData = strn(rs("plates")) 
		if strData<> "" then
			strLit = strLit & "+ " & strData
		end if
		strData = strn(rs("pubIMIAbbrLoc")) 
		if strData<> "" then
			strLit = strLit & " " & encodeHtml(strData)
		end if
		strData = strn(rs("pubPublishers")) 
		if strData<> "" then
			strLit = strLit & ": " & encodeHtml(strData)
		end if
		strLit = trim(strLit)
		if right(strLit,1) <> "." then strLit = strLit & "."
		response.write("<p>" & strLit & "</p>")
	else
		strData = strn(rs("ArticleAuthors"))
		if  strData <> "" then
			strLit = strLit & " <b>" & ucase(strData) & "</b>"
		end if	
   		strData = strn(rs("publyearof"))
		if strData <> "" then
			strLit = strLit & " (" & strData & ")"
		end if
		strdata = strn(rs("ArticleTitle"))
		if strData <> "" then
			strLit = strLit & ". " & encodeHtml(strData) & "."
		end if
		response.write("<p>" & strLit & "</p>")
		strLit = "<a href='http://www.cabi.org/default.aspx?site=170&page=1016&pid=515' target='_blank'>Recent record: see the printed product</a>"
		response.write("<font color='#0000FF'>" & strLit & "</font><br>")
	end if
	strLit = ""
	strData = strn(rs("ArticleBSMVol")) 
	if strData <> "" and strData <> "0" and strData <> "59" and _
			strData <> "60" and strData <> "89" and strData <> "99"  then
		strLit = " <b>" & strData & "</b>"
	end if
	strData = strn(rs("ArticleItem")) 
	if strData <> "" and strData <> "0" then
		strLit = strLit & ": " & strData
	end if
	if strLit <> "" then
		response.write("<p><b>BSM ref.</b> " & strLit &  "</p>")
	end if
	if 	strn(rs("ArticleGenera")) <> "" then
		response.write("<p><a href='bsmgenrecord.asp?intArticle=" & strn(rs("article")) & "'><b>Indexed genera</b></a></p>")
	end if
end sub

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function

sub DisplayRes
dim strSQL, dbConn, rs
if intArticle <> ""  then 
	strSQL = "SELECT Article.article, Article.ArticleGenera, Article.ArticleTitle, " _
		& "Publication.pubOriginalTitle, Publication.pubIMIAbbr, Publication.pubIMISupAbbr, " _
		& "Publication.pubEditors, Publication.pubIMIAbbrLoc, Publication.pubPublishers, " _
		& "Article.ArticleAuthors, Article.Pagination, Article.Plates, PublicationLine.publvolume, " _
		& "PublicationLine.publPart, PublicationLine.publYearOf, PublicationLine.publYearOn, " _
		& "Publication.pubLink, Article.ArticleBSMVol, Article.ArticleItem " _
		& "FROM Publication RIGHT JOIN (PublicationLine RIGHT JOIN Article ON " _
		& "(PublicationLine.publline = Article.publline) AND (PublicationLine.publink = Article.publink)) " _
		& "ON Publication.pubLink = PublicationLine.publink " _
		& "WHERE (((Article.article)=" & protectSQL(intArticle,true) & "));"
else
	response.write("Invalid query string<br>")
	exit sub
end if
Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\indexfungorum\indexfungorumlink.mdb"
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\indexfungorum\indexfungorumlink.mdb"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open strSql, dbConn, 3, 3

if not rs.bof then 
	ResList(rs)
else
	response.write("No records found.<br>")
end if
rs.close
set rs = nothing
dbConn.close
set dbConn = nothing
end sub
%>
<!-- #EndEditable --><!-- #BeginEditable "Main" -->
            <h4>Bibliography of Systematic Mycology Record</h4>
<%
	DisplayRes
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
