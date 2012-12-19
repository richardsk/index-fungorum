<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/templates/Templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>IndexFungorum</title>
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
          <td><!-- #BeginEditable "head" --><!-- #EndEditable --><!-- #BeginEditable "Main" --> 
      <h2>The <a href="http://www.cabi-bioscience.org/">CABI Bioscience</a> and 
        <a href="http://www.cbs.knaw.nl/cbshome.html">CBS</a> Database of Fungal 
        Names</h2>
      <p>Search for a fungus name by entering either the name or the specific 
        epithet. Click on an entry to see more data. <a href="Acknowledge.htm">Data 
        contributors</a>. <a href="IndexFungorum.htm">Help on searching</a>. Please 
        cite this database resource as Index Fungorum Partnership - www.indexfungorum.org, 
        and the date of access.</p>
      <p> <font color="#FF0000"><b>NEW</b></font> - If the name you are looking 
        for is missing and you have basic data (authors, literature reference) 
        click <a href="../IndexFungorumAdd.asp">here</a> to make an addition. <img src="../new.gif" width="32" height="16"> 
        <font color="#FF0000"><b><a href="../AuthorsOfFungalNames.htm">FREE</a></b></font><a href="../AuthorsOfFungalNames.htm"> 
        download</a>.</p>
      <p></p>
      <hr noshade>
      <form method="post" action="NAMES.ASP" name="search">
        <table width="389" border="1" name="Name" bordercolor="#000000" bgcolor="#99FF99" height="60">
          <tr bordercolor="#99FF99" bgcolor="#99FF99"> 
            <td colspan="3"><font face="Verdana, Arial, Helvetica, sans-serif"><b>Search 
              by:-</b></font></td>
            <td colspan="2"><font face="Verdana, Arial, Helvetica, sans-serif"><b>Enter 
              a search term:-</b></font></td>
          </tr>
          <tr bordercolor="#99FF99" bgcolor="#99FF99"> 
            <td width="65"><font face="Verdana, Arial, Helvetica, sans-serif"><b>Name 
              </b></font></td>
            <td colspan="2"><font face="Verdana, Arial, Helvetica, sans-serif"><b>Epithet</b></font></td>
            <td colspan="2" bordercolor="#99FF99" bgcolor="#99FF99">&nbsp; </td>
          </tr>
          <tr bordercolor="#99FF99" bgcolor="#99FF99"> 
            <td width="65"> <div align="left"> 
                <input type="radio" name="SearchBy" value="Name" <%if strType <> "E" then response.write("checked")%>>
              </div></td>
            <td colspan="2"> <div align="left"> 
                <input type="radio" name="SearchBy" value="epithet" <%if strType= "E" then response.write("checked")%>>
              </div></td>
            <td width="185"> <input type="text" name="SearchTerm" size="25" <%response.write("value=" & chr(34) & strSearch & chr(34))%>> 
            </td>
            <td width="74"> <input type="submit" name="Submit" value="Search" > 
            </td>
          </tr>
        </table>
      </form>
      <p> 
        <%
	GetNav
	DisplayRes
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
