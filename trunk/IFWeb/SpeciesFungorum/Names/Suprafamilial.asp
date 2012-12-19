<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/Templates/Templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Suprafamilial Names</title>
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
   dim strSearch, intPageNumber, intNumRecords, intPageSize, strFamily, intPageCount
   strFamily = session("strFamily")
   intPageSize = 50
   if request.querystring.item("FamilyName") <> "" then
      	 intPageNumber = "1"
      	 strFamily = request.querystring.item("FamilyName")
      	 session("strFamily") = strFamily
   end if
   if request.form.item("Submit") = "Search for suprafamilial name" then
      	 intPageNumber = "1"
      	 strFamily = request.form.item("SearchTerm")
      	 session("strFamily") = strFamily
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
		frm  = "families"
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

sub DisplayRes
	dim strSQL, dbConn, RS
	if strFamily = "" then exit sub
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=WebServerSQL;Integrated security=SSPI;User ID=WebServerSQL;Initial Catalog=IndexFungorum;Data Source=WebServer"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
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
		strSQL = "SELECT [tblSupraFamilialTaxa].* FROM [tblSupraFamilialTaxa] "_
			& "WHERE ((([tblSupraFamilialTaxa].[Name]) Like '" & protectSQL(strFamily, false) & "%')) " _
			& "ORDER BY [tblSupraFamilialTaxa].[Name];"
  	Set RS = Server.CreateObject("ADODB.Recordset")
  	RS.Open strSql, dbConn, 3
	if not rs.bof then
       rs.pagesize = intPageSize
	   rs.movelast
	   rs.movefirst
	   intNumRecords = rs.recordcount
	   intPageCount = rs.pagecount
	   ResList(RS) 
	else
	   response.write("No records found<br>")
	end if
  	RS.close
  	set RS=nothing
  	dbConn.close
  	set dbConn = nothing
end sub

sub ResList (rs)
	dim strLink, i, strOut
	rs.absoluteposition=((intPageNumber-1) * rs.PageSize) +1
	NavForm	
	response.write("<p></p><b>Taxa:</b><br>")
	for i = 1 to rs.PageSize
		if rs.eof or rs.bof then exit for
		if not isnull(rs("Name")) then 
			strFamily = "<b>" & rs("Name") & "</b> " & rs("Authors")
			strLink = "Suprafamilialrecord.asp?strRecordID=" & rs("ID")
				response.write("<a href=" & strLink &  " >" & strfamily & "</a>")
		end if
	 	rs.Movenext
		response.write("<br>")
   	next
	NavForm
end sub
%>
            <!-- #EndEditable --><!-- #BeginEditable "Main" --> 
            <h1>Databases of Suprafamilial Names</h1>
            <p> The present database was compiled by John David and is still being 
              updated as new information or corrections (as included in the <i><a href="http://www.cabi-publishing.org/AllOtherProducts.asp?SubjectArea=&PID=514" target="_blank">Index 
              of Fungi</a></i>) are revealed. Please forward any corrections or 
              comments to <a href="mailto:p.kirk@cabi.org">Paul Kirk</a>.</p>
            <p>The search term may be truncated.</p>
            <form method="post" action="suprafamilial.asp">
              <table width="500" border="1" bgcolor="#99FF99" bordercolor="#000000">
                <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
                  <td width="176" align="left" valign="top"><b>Taxon name search 
                    term:</b></td>
                  <td width="300"> <input type="text" name="SearchTerm" size="33" <%response.write("value='" & session("strFamily") & "'" )%> 
			  nKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;"> <input type="submit" name="Submit" value="Search for suprafamilial name"> 
                  </td>
                </tr>
              </table>
            </form>
            <%
	GetNav
	DisplayRes
%>
            
<script LANGUAGE="VBScript">
    Document.Write right(Date()),4)
</script>
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
