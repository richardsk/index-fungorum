<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplSF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Species Fungourum - GSD search</title>
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
   dim strSearch,strType,intPageNumber, intNumRecords, intPageSize, strGenus, intPageCount
   dim strOrder, strFamily
   strGenus = session("strGenus")
   strType = session("strType")
   strOrder = session("strOrder")
   strFamily = session("strFamily")
   intPageSize = 50
   if request.form.item("Submit") = "Search for genus" then
      	 intPageNumber = "1"
   	  	 session("intPageNumber") = intPageNumber
   	  	 strGenus = request.form.item("SearchTerm")
         session("strGenus") = strGenus
   	  	 strType = "G"
		 session("strType") = strType
   elseif request.form.item("Submit") = "View Orders" then
      	 intPageNumber = "1"
   	  	 session("intPageNumber") = intPageNumber
   	  	 strType = "OS"
         session("strType") = strType
		 strGenus = ""
		 session("strGenus") = ""
   elseif request.querystring.item("RecordID") <> "" then
      	 intPageNumber = "1"
   		 strType = request.querystring.item("Type")
		 session("strType") = strType
		 select case strType
		 case "O"
		 	  strOrder = request.querystring.item("RecordID")
			  session("strOrder") = strOrder
		 case "F"
		 	  strFamily = request.querystring.item("RecordID")
			  session("strFamily") = strFamily
		 case "G"
		 	  strGenus = request.querystring.item("RecordID")
			  session("strGenus") = strGenus
	    end select
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
		frm  = "gsdquery"
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
dim strSQL, dbConn, rs
	if strType = "G" and strGenus = "" then exit sub
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
	select case strType
   	 case "G"
		strSQL = "SELECT DISTINCT FundicClassification.[Fundic Record Number], FundicClassification.[Genus name], " _
			& "FundicClassification.[Family name], FundicClassification.[Order name] " _
			& "FROM IndexFungorum INNER JOIN FundicClassification " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
			& "WHERE (((FundicClassification.[Genus name]) Like '" & protectSQL(strGenus, false) & "%') AND ((IndexFungorum.[GSD FLAG]) Like 'GSD%')) " _
			& "ORDER BY FundicClassification.[Genus name];"
     case "OS" 
       strSQL = "SELECT DISTINCT FundicClassification.[Order name] " _
			& "FROM IndexFungorum INNER JOIN FundicClassification " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
			& "WHERE (((IndexFungorum.[GSD FLAG]) Like 'GSD%')) " _
			& "ORDER BY FundicClassification.[Order name];"
 	   case "O"
        strSql = "SELECT DISTINCT FundicClassification.[Family name], FundicClassification.[Order name] " _
			& "FROM IndexFungorum INNER JOIN FundicClassification " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
			& "WHERE (((FundicClassification.[Order name])='" & protectSQL(strOrder, false) & "') AND ((IndexFungorum.[GSD FLAG]) Like 'GSD%')) " _
			& "ORDER BY FundicClassification.[Family name];"
 	   case "F"
        strSql = "SELECT DISTINCT FundicClassification.[Order name], " _
			& "FundicClassification.[Family name], " _
			& "FundicClassification.[Genus name], " _
			& "FundicClassification.[Fundic Record Number] " _
			& "FROM IndexFungorum INNER JOIN FundicClassification " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
			& "WHERE "
			if strOrder <> "not assigned" then
			   strSql = strSql & "(((FundicClassification.[Order name])='" & protectSQL(strOrder, false) & "')) and "
			else
			   strSql = strSql & "((FundicClassification.[Order name]) is null) and "
			end if
			if strFamily <> "not assigned" then
			   strSql = strSQL & "(((FundicClassification.[Family name])='" & protectSQL(strFamily, false) & "'))"
			else
			   strSql = strSql & "((FundicClassification.[Family name]) is null) "
			end if
			strSql = strSql & "ORDER BY FundicClassification.[Genus name];"
	  case else
	        exit sub
	end select
  Set rs = Server.CreateObject("ADODB.Recordset")
  rs.Open strSql, dbConn, 3
	if not rs.bof then
		rs.pagesize = intPageSize
		rs.movelast
		rs.movefirst
		intNumRecords = rs.recordcount
		intPageCount = rs.Pagecount
		ResList(rs)
	else
	   response.write("No records found<br>")
	end if
  rs.close
  set rs = nothing
  dbConn.close
  set dbConn = nothing
end sub

sub ResList (rs)
	dim strLink, i, strOut
	  NavForm
	  rs.absoluteposition=((intPageNumber-1) * rs.PageSize) +1
	  select case strType
	    case "G" 
	  	 response.write("<p></p><strong>Genus, Family, Order</strong><p></p>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for 
		   strGenus = rs("Genus name")
		   strLink = "../names/names.asp?strGenus=" & server.urlencode(strGenus) & "&GSD=Yes"
		   response.write("<a href=" & strLink &  " >" & strGenus & "</a>, ")
		   if rs("family name") <> "" then
		   	  strFamily = rs("family name")
			  strLink = "gsdquery.asp?RecordID=" & server.urlencode(strFamily) _
		   		   	 & "&Type=F"
		      response.write("<a href=" & strLink &  " >" & strFamily & "</a>, ")
		   else
		   	   strFamily = "not assigned"
		   end if
		   if rs("order name") <> "" then
		   	  strOrder = rs("order name")
			  strLink = "gsdquery.asp?RecordID=" & server.urlencode(strOrder) _
		   		   	 & "&Type=O"
		      response.write("<a href=" & strLink &  " >" & strOrder & "</a>, ")
		   else
		   	   strOrder = "not assigned"
		   end if
		   session("strGenus") = strGenus
		   session("strFamily") = strFamily
		   session("strOrder") = strOrder
		   RS.Movenext
		   response.write("<br>")
   	      next
	     case "OS" 
		   response.write("<p></p><strong>Orders</strong><br>") 
	  	   for i = 1 to rs.PageSize
		     if rs.eof then exit for
		     if rs.bof then exit for
		     strLink = "gsdquery.asp?RecordID=" & server.urlencode(rs("Order name")) _
		   		   	 & "&Type=O" 
		     response.write("<a href=" & strLink &  " >" & rs("Order name") & "</a>")
 		      RS.Movenext
		     response.write("<br>")
   	       next
		   case "O" 
	  	 response.write("<p></p><strong>Families<br> in Order " & strOrder & "</strong><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("family name")) then 
		   	  strOut = "not assigned"
		   else
		   	   strOut = rs("family name")
		   end if
		   strLink = "gsdquery.asp?RecordID=" & server.urlencode(strOut) _
		   		   	 & "&Type=F"
		   response.write("<a href=" & strLink &  " >" & strOut & "</a>")
 		    RS.Movenext
		   response.write("<br>")
   	     next
	   case "F" 
	  	 response.write("<p></p><strong>Genera<br> in Family " & strFamily & ",<br> in Order " & strOrder  & "</strong><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if not isnull(rs("genus name")) then 
			   strGenus = rs("Genus name")
			   strLink = "../names/names.asp?strGenus=" & server.urlencode(strGenus) & "&GSD=Yes"
			   response.write("<a href=" & strLink & " >" & strGenus & "</a> ")
		   end if
 		 RS.Movenext
		 response.write("<br>")
   	     next
	 end select
	NavForm
 end sub
%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
<h1>Global Species Databases <a href=javascript:popUp("../GSD/gsd.htm")><img src='../IMAGES/i.gif' alt='Click here to get an explanation of GSD&#8217;s and help with searching' width='13' height='13' border='0'></a></h1>
<form method="post" action="Gsdquery.asp">
  <table width="513" border="0">
    <tr> 
      <td width="246"><b>Genus search term:</b></td>
      <td width="272"> <input type="text" name="SearchTerm" size="24" <%response.write("value=" & chr(34) & session("strGenus") & chr(34))%>nKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;">
            </td>
    </tr>
    <tr> 
      <td width="246"> <input type="submit" name="Submit" value="View Orders"> 
      </td>
      <td width="272"> <input type="submit" name="Submit" value="Search for genus"> 
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
