<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/HerbIMI.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>HerbIMI-Online - number search</title>
<!-- InstanceEndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=840,height=450,left=150,top=00');");
}

function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
//-->
</script>
<link href="StyleSheets/HerbIMI.css" rel="stylesheet" type="text/css">
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
          <td width="59%" class="h1"> <img src="Images/CABILogo.gif" width="100" height="100"> 
            CABI Databases</td>
          <td width="41%" valign="top"><table height="100%" align="center">
              <tr class="mainbody"> 
                <td width="205"><strong><font size="4">HERB. IMI ON-LINE</font></strong></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="IMINumber.asp" onMouseOver="MM_displayStatusMsg('Search herb. IMI Number');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  herb. IMI Number</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Name.asp" onMouseOver="MM_displayStatusMsg('Search Fungus Name');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Fungus Name</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Association.asp" onMouseOver="MM_displayStatusMsg('Search Associated Organism Name');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Associated Organism Name</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Countries.asp" onMouseOver="MM_displayStatusMsg('Search by Country Names');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  by Country Names</a></td>
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
          <td bgcolor="#CCFFCC"><!-- InstanceBeginEditable name="head" --> 
<%
dim strSearch
if request.form.item("SearchTerm") <> "" then
	strSearch = request.form.item("SearchTerm")
end if

sub DisplayRes 
dim strSQL, dbConn, RS
  Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
'	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=herbIMI;Data Source=webserver"
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=herbIMI;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=herbIMI;Data Source=indexfungorum"
	   dbConn.open strConn
	elseif strIP = "194.131.255.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=herbIMI;Data Source=indexfungorum"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=herbimi"
	end if
	if strIP = "10.0.5.4" then
		if strSearch <> "" then
			   strSQL = "SELECT tblHerbIMI.* " _
					& "FROM tblHerbIMI " _
					& "WHERE (((tblHerbIMI.IMInumber) Like '" & protectSQL(strSearch,true) & "%'));"
		else
		exit sub
		end if
	else
		if strSearch <> "" then
			   strSQL = "SELECT tblHerbIMI.* " _
					& "FROM tblHerbIMI " _
					& "WHERE (((tblHerbIMI.IMInumber) Like '" & protectSQL(strSearch,true) & "%'));"
		else
		exit sub
		end if
	end if
  Set RS = Server.CreateObject("ADODB.Recordset")
  RS.Open strSql, dbConn, 3
	if not rs.bof then
	    ResList(RS)
	else
	   response.write("No data available for this IMI number")
	end if
  RS.close
  set RS = nothing
  dbConn.close
  set dbConn = nothing
end sub

sub ResList(RS)
	dim strLink
	strIP = request.servervariables("LOCAL_ADDR")
		do while not RS.bof and not RS.eof
			if strIP = "10.0.5.4" then
				if rs("FinalNameDataEdited") <> "" then
					strLink = "DisplayResults.asp?strIMINumber=" & server.urlencode(rs("IMInumber"))
					response.write("<p></p><b><a href=" & strLink & ">" & strn(rs("IMInumber")) & "</a></b>")
				else
					response.write("<p></p><b>No digitized data available for IMI " & strn(rs("IMInumber")) & "</b>")
				end if
			else	
				if rs("NameOfFungus") <> "" then
					strLink = "DisplayResults.asp?strIMINumber=" & server.urlencode(rs("IMInumber"))
					response.write("<p></p><b><a href=" & strLink & ">" & strn(rs("IMInumber")) & "</a></b>")
				else
					response.write("<p></p><b>No digitized data available for IMI " & strn(rs("IMInumber")) & "</b>")
				end if
			end if
		RS.MoveNext
		loop
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
            <form method="post" action="IMINumber.asp" name="search">
              <table width="293" border="1" name="Name" height="60" bgcolor="#99FF99" bordercolor="#000000">
                <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
                  <td width="133" height="15" bordercolor="#99FF99"><b><font face="Verdana, Arial, Helvetica, sans-serif">IMI 
                    number:</font></b></td>
                  <td width="149" height="15" align="right"><input type="text" name="SearchTerm" size="30" 
					  onKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;">
				  </td>
                </tr>
                <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
                  <td width="133" height="3">&nbsp;</td>
                  <td width="140" height="3"><input type="submit" name="submit" value="Search for number">
				  </td>
                </tr>
              </table>
			  </form>
<% 
	DisplayRes
%>
            <!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 2008<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333"> 
      <a href="http://www.cabi.org/">CABI</a></font>. Return to <a href="Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
