<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/templates/Templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>The Bibliography of Systematic Mycology</title>
<!-- #EndEditable -->
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
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
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
                <td><a href="../Names/AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../Names/Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
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
          <td><!-- #BeginEditable "head" -->
<%
dim strSearch,strType,intPageNumber, intNumRecords, intPageSize, intPageCount
intPageSize = 200
strSearch = session("strSearch")
strType = session("strType")
  if request.form.item("Submit") <> "" then
   	  if request.form.item("SearchTerm") <> ""  then 
   	  	 strSearch = request.form.item("SearchTerm")
		 strSearch = replace(strSearch,"'","''")
         session("strSearch") = strSearch
      	 intPageNumber = "1"
	   	 if request.form.item("SearchBy") = "Genus" then
   	  	   strType = "G"
           session("strType") = strType
		 elseif request.form.item("SearchBy") = "Author" then
   	  	   strType = "A"
           session("strType") = strType
	   	 end if
	  end if
	end if
	if strType = "" then
		strType = "G"
		session("strType") = strType
		strSearch = ""
		session("strSearch") = strSearch
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
		frm  = "bsm"
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
			response.write("<a href='" & frm & ".asp?pg=" & intPageNumber + 1 & "'>[Next &gt;&gt;]</a>")
		end if
		response.write(" <b>of " & intNumRecords & " records.</b></p>")
	else
		response.write("<p>" & intNumRecords & " records</p>")
	end if
end sub
function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function

sub ResList (rs)
	dim strLink, i, strText, strOut
	  rs.absoluteposition=((intPageNumber-1) * intPageSize) +1
	  response.write("<p></p><strong>Author, Title, Year</strong><p></p>")
	  NavForm
	  for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
			strOut = i + ((intPageNumber-1) * intPageSize) 
			strOut = "<A HREF='bsmrecord.asp?intArticle=" & strn(rs("article")) & "'>" & strOut & "</A>"
			 strText = strn(rs("ArticleAuthors"))
			if strText <> "" then strOut = strOut & " " & strText
			 strText = strn(rs("ArticleTitle"))
			if strText <> "" then strOut = strOut & " <i>" & strText & "</i>"
			 strText = strn(rs("publYearOf"))
			if strText <> "" then strOut = strOut & " (" & strText & ")"
			response.write(strOut & "<br>") 
		    RS.Movenext
   next 
	NavForm
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
	elseif strIP = "10.0.3.13" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\indexfungorum\indexfungorumlink.mdb"
	   dbConn.open strConn
	elseif strIP = "194.203.77.78" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\indexfungorum\indexfungorumlink.mdb"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
   	if strType = "G" then
		strSql = "SELECT ArticleGenera.article, " _
            & "Article.ArticleAuthors, Article.ArticleTitle, Publication.pubOriginalTitle, " _
            & "PublicationLine.publYearOf FROM (Publication RIGHT JOIN " _
            & "(PublicationLine RIGHT JOIN Article ON " _
            & "(PublicationLine.publline = Article.publline) AND " _
            & "(PublicationLine.publink = Article.publink)) " _
            & "ON Publication.pubLink = PublicationLine.publink) " _
            & "RIGHT JOIN ArticleGenera ON Article.article = " _
            & "ArticleGenera.article WHERE " _
            & "(((ArticleGenera.genusName) like '" & protectSQL(strSearch, false) & "%'))" _
            & "ORDER BY PublicationLine.publYearOf DESC;"
   	elseif strType = "A" then
		if instr(strSearch,"æ") then
		strSearch = left(strSearch,instr(strSearch,"æ")-1) & "ae" & right(strSearch,len(strSearch)-instr(strSearch,"æ"))
		end if
        strSQL = "SELECT ArticleAuthor.article, " _
            & "Article.ArticleAuthors, Article.ArticleTitle, Publication.pubOriginalTitle, " _
            & "PublicationLine.publYearOf FROM ArticleAuthor LEFT JOIN " _
            & "(Publication RIGHT JOIN (PublicationLine RIGHT JOIN Article " _
            & "ON (PublicationLine.publline = Article.publline) " _
            & "AND (PublicationLine.publink = Article.publink)) " _
            & "ON Publication.pubLink = PublicationLine.publink) " _
            & "ON ArticleAuthor.article = Article.article " _
            & "WHERE (((ArticleAuthor.AuthorName) Like '" & protectSQL(strSearch, false) & "%')) " _
            & "ORDER BY PublicationLine.publYearOf DESC;"
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
		response.write("No records found<br>")
	end if
  rs.close
  set rs = nothing
  dbConn.close
  set dbConn = nothing
end sub
%>
<!-- #EndEditable --><!-- #BeginEditable "Main" --> 
            <h4>The <a href="http://www.cabi.org/" target="_blank">CABI</a> Bibliography of Systematic Mycology</h4>
      <p>Search for articles by either author or fungus genus. The search term 
        may be truncated. Click on an article number to view more detail. Full 
        bibliographic details for recent records are not available. Please refer 
        to the printed product.</p>
      <p></p>
      <hr noshade>
      <form method="post" action="bsm.asp" name="search">
        <table width="500" border="1" bgcolor="#99FF99" bordercolor="#000000">
          <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
            <td colspan="2"><font face="Verdana, Arial, Helvetica, sans-serif"><b>search 
              by:-</b></font></td>
            <td><font face="Verdana, Arial, Helvetica, sans-serif"><b>enter search term:-</b></font></td>
          </tr>
          <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
            <td><font face="Verdana, Arial, Helvetica, sans-serif"><b>genus </b></font></td>
            <td><font face="Verdana, Arial, Helvetica, sans-serif"><b>author</b></font></td>
            <td>&nbsp;</td>
          </tr>
          <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
            <td> 
              <input type="radio" name="SearchBy" value="Genus" <%if strType <> "A" then response.write("checked")%>>
            </td>
            <td> 
              <input type="radio" name="SearchBy" value="Author" <%if strType = "A" then response.write("checked")%>>
            </td>
            <td> 
              <input type="text" name="SearchTerm" size="25" <%response.write("value=" & chr(34) & strSearch & chr(34))%>
			  onKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;">
              <input type="submit" name="submit" value="GO">
            </td>
          </tr>
        </table>
      </form>
<% 
	GetNav
	DisplayRes
%>
<!-- #EndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 2008 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- #EndTemplate --></html>
