<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/templates/Templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>CABI Bioscience Databases - Keys</title>
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
                  with searching</a> : <font color="#FF0000"><strong><a href=javascript:popUp("/IndexFungorumCookies.htm") onMouseOver="MM_displayStatusMsg('Cookies');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Cookies</a></strong></font></td>
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
sub WriteKeyDetails()
	dim strTitle, RS, strSQL, dbConn, strContrib
	strDistrib = ""
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.78" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
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
   	strSQL = "SELECT * FROM tblKeys ORDER BY tblKeys.KeyTitle;"
  	Set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSql, dbConn, 3
	if not rs.eof and not rs.bof then
		response.write("<b>Keys:</b><br>")
	end if
	do while not rs.bof and not rs.eof
		strTitle = strn(rs("KeyTitle"))
		strContrib = strn(rs("Contributor"))
		response.write("<a href='../names/key.asp?KeyID=" & rs("KeyID") & "'>" & strTitle & "</a>, " & strContrib & "<br>")		
		rs.movenext
	loop
  RS.close
  set RS=nothing
  dbConn.close
  set dbConn = nothing
end sub 

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function
%>
		  <!-- #EndEditable --><!-- #BeginEditable "Main" -->
      <h1>Keys </h1>
      <p>There aren't many at the moment but we hope the number will grow. Keys 
        are part of the underlying database system on this site<span class="indent"><span class="indent">. 
        There are links from taxon names in the key to all other taxon data in 
        the database. There are also links from database details on each taxon 
        to one or more keys in which it may occur. </span></span></p>
      <p><span class="indent"><span class="indent">These are not intended to be 
        sophisticated electronic keys. They are intended to be straightforward 
        to use, and to link directly to other data contained in the database. 
        They are also intended to be useable in printed form away from the computer. 
        <span class="indent">Keys can be natural, artificial, tabular etc.</span></span></span></p>
      <p>Please contact <a href="mailto:p.kirk@cabi.orh">Paul Kirk</a> for more 
        details if you would like to contribute a key.</p>
      <p>
<%
WriteKeyDetails()
%>
      </p>
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
