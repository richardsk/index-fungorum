<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/TemplLF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Libri Fungorum - Search</title>
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
function ImagepopUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=705,height=650,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<link href="StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="Connections/DataAccess.asp"-->
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCC99">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="IMAGES/LogoLF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Libri&nbsp;Fungorum</td>
          <td valign="top"> <table height="100%" align="center">
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("./html/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
                  Fungorum Partnership</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("./html/Acknowledgements.htm") onMouseOver="MM_displayStatusMsg('Acknowledgements');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Acknowledgements</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("./html/help.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("Request.asp") onMouseOver="MM_displayStatusMsg('Submit a request');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Submit a request</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Resources.asp" onMouseOver="MM_displayStatusMsg('Search Libri Fungorum');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Libri Fungorum</a></td>
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
		Set dbConn = Server.CreateObject("ADODB.Connection")
		strIP = request.servervariables("LOCAL_ADDR")
		if true then        
           strConn = GetConnectionString()
	       dbConn.connectiontimeout = 180
	       dbConn.commandtimeout = 180
	       dbConn.open strConn
	    elseif strIP = "192.168.0.12" then
		   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_KIRK-WEBSERVER;Initial Catalog=LibriFungorum;Data Source=KIRK-WEBSERVER"
			dbConn.open strConn
		elseif strIP = "194.203.77.76" then
			strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=LibriFungorum;Data Source=EDWINBUTLER"
			dbConn.open strConn
		elseif strIP = "194.203.77.78" then
			strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=LibriFungorum;Data Source=EDWINBUTLER"
			dbConn.open strConn
		elseif strIP = "127.0.0.1" then
			strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\librifungorum\librifungorum.mdb"
			dbConn.open strConn
		else
			dbConn.open "FILEDSN=librifungorum"
		end if
		strSQL1 = "SELECT tblItems.ID " _
			& "FROM tblItems;"
		Set rs1 = Server.CreateObject("ADODB.Recordset")
		rs1.Open strSql1, dbConn, 3
			rs1.movelast
			rs1.movefirst
			intNumItems = rs1.recordcount
		rs1.close
		set rs1 = nothing
		strSQL2 = "SELECT tblImages.ID " _
			& "FROM tblImages;"
		Set rs2 = Server.CreateObject("ADODB.Recordset")
		rs2.Open strSql2, dbConn, 3
			rs2.movelast
			rs2.movefirst
			intNumImages = rs2.recordcount
		rs2.close
		set rs2 = nothing
		dbConn.close
		set dbConn = nothing
			response.write("Libri Fungorum currently serves <b><font color='#339900'>" & intNumItems & "</font></b> items comprising")
			response.write(" <b><font color='#339900'>" & intNumImages & "</font></b> page images<br><br>")
%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
            <p><b>Type of Resource:</b></p>
            <p><a href='Search.asp?ItemType=B'>Books</a></p>
            <p><a href='Search.asp?ItemType=J'>Journals</a></p>
            <p><a href='Search.asp?ItemType=T'>Thesauri</a></p>
            <p><a href='Search.asp?ItemType=I'>Indexes</a></p>
            <p><a href='Search.asp?ItemType=M'>Miscellaneous</a><br>
            </p>
            <!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 2004, 2005 <a href="Index.htm">Libri Fungorum</a>. Return to <a href="Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
