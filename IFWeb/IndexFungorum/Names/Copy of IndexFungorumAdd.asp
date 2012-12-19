<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplIF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Index Fungorum - Insert New Record</title>
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
                  with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Index Fungorum</a></td>
              </tr>
              <tr class="mainbody">
                <td><a href=javascript:popUp("IndexFungorumLSIDs.htm") onMouseOver="MM_displayStatusMsg('Important Announcement');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Important 
                  Announcement</a></td>
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
<script language="JavaScript">
//Function to check form is filled in correctly before submitting
function CheckForm () {
	//Check for an e-mail
	if (document.frmIndexFungorumAdd.AddedBy.value=="a"){
		alert("Please enter your name (or e-mail address) in the 'Added by' box");
		document.frmIndexFungorumAdd.AddedBy.focus();
		return false;
	}
	return true	
}
</script>
<%
sub DisplayRecord()
   response.write("<form name='frmIndexFungorumAdd' method='post' action='../Names/IndexFungorumAddInsertUpdate.asp' onSubmit='return CheckForm();'>")
   response.write("<table width='100%' border='1' cellspacing='0' cellpadding='5'>")
   response.write("<tr>")
   response.write("<td width='15%'>Name</td>")
   response.write("<td width='85%'><input type='text' name='NAMEOFFUNGUS' size='68' maxlength='100'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Authors</td>")
   response.write("<td width='85%'><input type='text' name='AUTHORS' size='68' maxlength='150'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Original orthographic</td>")
   response.write("<td width='85%'><input type='text' name='ORTHOGRAPHYCOMMENT' size='68' maxlength='70'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Publishing authors</td>")
   response.write("<td width='85%'><input type='text' name='PUBLISHINGAUTHORS' size='68' maxlength='110'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Literature title</td>")
   response.write("<td width='85%'><input type='text' name='PubAcceptedTitle' size='68' maxlength='255'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Volume</td>")
   response.write("<td width='85%'><input type='text' name='VOLUME' size='68' maxlength='15'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Part</td>")
   response.write("<td width='85%'><input type='text' name='PART' size='68' maxlength='25'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Page</td>")
   response.write("<td width='85%'><input type='text' name='PAGE' size='68' maxlength='50'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Year of publication</td>")
   response.write("<td width='85%'><input type='text' name='YEAROFPUBLICATION' size='68' maxlength='4'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Year on publication</td>")
   response.write("<td width='85%'><input type='text' name='YEARONPUBLICATION' size='68' maxlength='15'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Basionym</td>")
   response.write("<td width='85%'><input type='text' name='SYNONYMY' size='68' maxlength='255'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Type substratum</td>")
   response.write("<td width='85%'><input type='text' name='HOST' size='68' maxlength='255'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Type locality</td>")
   response.write("<td width='85%'><input type='text' name='LOCATION' size='68' maxlength='75'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Typification details</td>")
   response.write("<td width='85%'><input type='text' name='TYPIFICATIONDETAILS' size='68' maxlength='100'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Nomenclatural comment</td>")
   response.write("<td width='85%'><input type='text' name='NOMENCLATURALCOMMENT' size='68' maxlength='100'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%' hight='100'>Notes</td>")
   response.write("<td width='85%' hight='100'><textarea name='NOTES' cols='67' rows='6'></textarea></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Added by</td>")
   response.write("<td width='85%'><input type='text' name='AddedBy' size='68' maxlength='30'></td>")
   response.write("</tr>")
   response.write("<td width='15%'><input type='submit' name='Submit' value='Submit Addition'></td>")
   response.write("<td width='85%'><input type='hidden' name='RECORDNUMBER' value='1'></td>")
   response.write("</tr>")
   response.write("</table>")

   response.write("</form>")

end sub
%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
<%
   response.write("<h3><font color='#FF0000'>Index Fungorum addition form</font></h3>")
   DisplayRecord()
   response.write("<a href='javascript:history.go(-1)'>back to previous page</a>")
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
