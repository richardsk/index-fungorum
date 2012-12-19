<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplIF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Index Fungorum - Authors of Fungal Names</title>
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
                <td><a href=javascript:popUp("IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
                  Fungorum Partnership</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("Acknowledge.htm") onMouseOver="MM_displayStatusMsg('Acknowledgements');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Acknowledgements</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("IndexFungorum.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help 
                  with searching</a> : <font color="#FF0000"><strong><a href="javascript:popUp("IndexFungorumCookies.htm")"IndexFungorumCookies.htm")" target="_blank">Cookies</a></strong></font></td>
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
dim strSearch, strType, intPageNumber, intNumRecords, intPageSize, intPageCount
intPageSize = 50
strSearch = session("strSearch")
strType = session("strType")
  if request.form.item("Submit") <> "" then
   	  if request.form.item("SearchTerm") <> ""  then 
   	  	 strSearch = request.form.item("SearchTerm")
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
		frm  = "AuthorsOfFungalNames"
		response.write("<b>Pages: </b>")
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
		response.write(" <b>of " & intNumRecords & " records.</b><br><br>")
	else
		response.write(intNumRecords & " records<br><br>")
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
	dim strLink, i, strText, strOut, strStr, strJava, intFKID
	rs.absoluteposition=((intPageNumber-1) * intPageSize) +1
	NavForm
		for i = 1 to rs.PageSize
			if rs.eof then exit for
			if rs.bof then exit for
			strOut = ""
			strText = strn(rs("SurnameSort"))
			if strText <> "" then strOut = server.HTMLEncode(strText)
			strText = strn(rs("Forename"))
			if strText <> "" then strOut = strOut & ", " & server.HTMLEncode(strText)
			intFKID = rs("FKID") & chr(34) & chr(41)
			strJava = "javascript:popUp(" & chr(34)
			strOut = "<a href='" & strJava & "AuthorDetails.asp?ID=" & intFKID & "'>" & strOut & "</a>"
			response.write(strOut & "<br>") 
			rs.Movenext
		next 
			response.write("<br>") 
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
   	if strType = "G" then
		strSQL = "SELECT tblAuthorVariants.SurnameSort, tblAuthorVariants.Forename, tblAuthorVariants.FKID " _
			& "FROM tblAuthorVariants " _
			& "WHERE (((tblAuthorVariants.SurnameSort) Like '" & protectSQL(strSearch, false) & "%')) " _
			& "ORDER BY tblAuthorVariants.Surname, tblAuthorVariants.Forename;"
	elseif strType = "A" then
		if instr(strSearch,"?") then
		strSearch = left(strSearch,instr(strSearch,"?")-1) & "ae" & right(strSearch,len(strSearch)-instr(strSearch,"?"))
		end if
		strSQL = "SELECT tblAuthorVariants.SurnameSort, tblAuthorVariants.Forename, tblAuthorVariants.FKID " _
			& "FROM tblAuthorVariants " _
			& "WHERE (((tblAuthorVariants.SurnameSort) Is Not Null) AND ((tblAuthorVariants.Forename) Like '%" & protectSQL(strSearch, false) & "%')) " _
			& "ORDER BY tblAuthorVariants.Surname, tblAuthorVariants.Forename;"
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
            <!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
            <h2>Authors of Fungal Names</h2>
            Search for authors surname or any of the forenames. The search term 
            may be truncated (you do not need to add * or % &#8211; we do that 
            for you), you can include diacriticals but it may be safer to just 
            use the base letter as we may have got the wrong one. <a href=javascript:popUp("../Names/AuthorsOfFungalNames.htm")>Download 
            the list here</a>. <a href=javascript:popUp("../Names/AuthorsOfFungalNamesPreface.htm")>Preface 
            to published list here</a>.<br>
            <br>
            <hr noshade>
            <form method="post" action="AuthorsOfFungalNames.asp" name="search">
              <table width="500" border="0">
                <tr> 
                  <td colspan="2"><b>search by:-</b></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td><b>Surname</b></td>
                  <td><b>Forename</b></td>
                  <td><b>enter search term:-</b></td>
                </tr>
                <tr> 
                  <td> <input type="radio" name="SearchBy" value="Genus" <%if strType <> "A" then response.write("checked")%>> 
                  </td>
                  <td> <input type="radio" name="SearchBy" value="Author" <%if strType= "A" then response.write("checked")%>> 
                  </td>
                  <td> <input type="text" name="SearchTerm" size="25" <%response.write("value=" & chr(34) & strSearch & chr(34))%>
			  onKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;"> <input type="submit" name="submit" value="GO"> 
                  </td>
                </tr>
              </table>
            </form>
            <% 
	GetNav
	DisplayRes
%>
            <!-- InstanceEndEditable --></td>
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
<!-- InstanceEnd --></html>
